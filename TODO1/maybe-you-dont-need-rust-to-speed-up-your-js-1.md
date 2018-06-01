> * 原文地址：[Maybe you don't need Rust and WASM to speed up your JS — Part 1](https://mrale.ph/blog/2018/02/03/maybe-you-dont-need-rust-to-speed-up-your-js.html)
> * 原文作者：[Vyacheslav Egorov](http://mrale.ph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md)
> * 译者：
> * 校对者：

# Maybe you don't need Rust and WASM to speed up your JS — Part 1

Few weeks ago I noticed a blog post [“Oxidizing Source Maps with Rust and WebAssembly”](https://hacks.mozilla.org/2018/01/oxidizing-source-maps-with-rust-and-webassembly/) making rounds on Twitter - talking about performance benefits of replacing plain JavaScript in the core of `source-map` library with a Rust version compiled to WebAssembly.

This post piqued my interest, not because I am a huge on either Rust or WASM, but rather because I am always curious about language features and optimizations missing in pure JavaScript to achieve similar performance characteristics.

So I checked out the library from GitHub and departed on a small performance investigation, which I am documenting here almost verbatim.

### Getting the Code

For my investigations I was using an _almost_ default x64.release build of the V8 at commit [69abb960c97606df99408e6869d66e014aa0fb51](https://chromium.googlesource.com/v8/v8/+/69abb960c97606df99408e6869d66e014aa0fb51) from January 20th. My only departure from the default configuration is that I enable disassembler via GN flags to be able to dive down to generated machine code if needed.

```
╭─ ~/src/v8/v8 ‹master›
╰─$ gn args out.gn/x64.release --list --short --overrides-only
is_debug = false
target_cpu = "x64"
use_goma = true
v8_enable_disassembler = true
``` 

Then I got a checkouts of [`source-map`](https://github.com/mozilla/source-map) package at:

*   [commit c97d38b](https://github.com/mozilla/source-map/commit/c97d38b70de088d87b051f81b95c138a74032a43), which was the last commit that updated `dist/source-map.js` before Rust/WASM started landed;
*   [commit 51cf770](https://github.com/mozilla/source-map/commit/51cf7708dd70d067dfe04ce36d546f3262b48da3) which was the most recent commit, when I did my investigation;

### Profiling the Pure-JavaScript Version

Running benchmark in the pure-JS version was simple:

```
╭─ ~/src/source-map/bench ‹ c97d38b›
╰─$ d8 bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 4655.638000
console.timeEnd: iteration, 4751.122000
console.timeEnd: iteration, 4820.566000
console.timeEnd: iteration, 4996.942000
console.timeEnd: iteration, 4644.619000
[Stats samples: 5, total: 23868 ms, mean: 4773.6 ms, stddev: 161.22112144505135 ms]
```

The first thing that I did was to disable the serialization part of the benchmark:

```
diff --git a/bench/bench-shell-bindings.js b/bench/bench-shell-bindings.js
index 811df40..c97d38b 100644
--- a/bench/bench-shell-bindings.js
+++ b/bench/bench-shell-bindings.js
@@ -19,5 +19,5 @@ load("./bench.js");
    print("Parsing source map");
    print(benchmarkParseSourceMap());
    print();
-print("Serializing source map");
-print(benchmarkSerializeSourceMap());
+// print("Serializing source map");
+// print(benchmarkSerializeSourceMap());
```

And then threw it into the Linux `perf` profiler:

```
╭─ ~/src/source-map/bench ‹perf-work›
╰─$ perf record -g d8 --perf-basic-prof bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 4984.464000
^C[ perf record: Woken up 90 times to write data ]
[ perf record: Captured and wrote 24.659 MB perf.data (~1077375 samples) ]
``` 

Notice that I am passing `--perf-basic-prof` flag to the `d8` binary which instructs V8 to generate an auxiliary mappings file `/tmp/perf-$pid.map`. This file allows `perf report` to understand JIT generated machine code.

Here is what we get from `perf report --no-children` after zooming on the main execution thread:

```
Overhead  Symbol
    17.02%  *doQuickSort ../dist/source-map.js:2752
    11.20%  Builtin:ArgumentsAdaptorTrampoline
    7.17%  *compareByOriginalPositions ../dist/source-map.js:1024
    4.49%  Builtin:CallFunction_ReceiverIsNullOrUndefined
    3.58%  *compareByGeneratedPositionsDeflated ../dist/source-map.js:1063
    2.73%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    2.11%  Builtin:StringEqual
    1.93%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.66%  *doQuickSort ../dist/source-map.js:2752
    1.25%  v8::internal::StringTable::LookupStringIfExists_NoAllocate
    1.22%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.21%  Builtin:StringCharAt
    1.16%  Builtin:Call_ReceiverIsNullOrUndefined
    1.14%  v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
    0.90%  Builtin:StringPrototypeSlice
    0.86%  Builtin:KeyedLoadIC_Megamorphic
    0.82%  v8::internal::(anonymous namespace)::MakeStringThin
    0.80%  v8::internal::(anonymous namespace)::CopyObjectToObjectElements
    0.76%  v8::internal::Scavenger::ScavengeObject
    0.72%  v8::internal::String::VisitFlat<v8::internal::IteratingStringHasher>
    0.68%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    0.64%  *doQuickSort ../dist/source-map.js:2752
    0.56%  v8::internal::IncrementalMarking::RecordWriteSlow
```

Indeed, just like the [“Oxidizing Source Maps …”](https://hacks.mozilla.org/2018/01/oxidizing-source-maps-with-rust-and-webassembly/) post has stated the benchmark is rather heavy on sort: `doQuickSort` appears at the top of the profile and also several times down the list (which means that it was optimized/deoptimized few times).

### Optimizing Sorting - Argument Adaptation

One thing that jumps out in the profiler are suspicious entries, namely `Builtin:ArgumentsAdaptorTrampoline` and `Builtin:CallFunction_ReceiverIsNullOrUndefined` which seem to be part of the V8 implementation. If we ask `perf report` to expand call chains leading to them then we will notice that these functions are also mostly invoked from the sorting code:

```
- Builtin:ArgumentsAdaptorTrampoline
    + 96.87% *doQuickSort ../dist/source-map.js:2752
    +  1.22% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    +  0.68% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    +  0.68% Builtin:InterpreterEntryTrampoline
    +  0.55% *doQuickSort ../dist/source-map.js:2752

- Builtin:CallFunction_ReceiverIsNullOrUndefined
    + 93.88% *doQuickSort ../dist/source-map.js:2752
    +  2.24% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    +  2.01% Builtin:InterpreterEntryTrampoline
    +  1.49% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
``` 

It is time to look at the code. Quicksort implementation itself lives in [`lib/quick-sort.js`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/quick-sort.js) and it is invoked from parsing code in [`lib/source-map-consumer.js`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/source-map-consumer.js#L564-L568). Comparison functions used for sorting are [`compareByGeneratedPositionsDeflated`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/util.js#L334-L343) and [`compareByOriginalPositions`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/util.js#L296-L304).

Looking at the definitions of these comparison functions and how they are invoked from quick-sort implementation reveals that the invocation site has mismatching arity:

```
function compareByOriginalPositions(mappingA, mappingB, onlyCompareOriginal) {
    // ...
}

function compareByGeneratedPositionsDeflated(mappingA, mappingB, onlyCompareGenerated) {
    // ...
}

function doQuickSort(ary, comparator, p, r) {
    // ...
        if (comparator(ary[j], pivot) <= 0) {
        // ...
        }
    // ...
}
``` 

Grepping through library sources reveals that outside of tests `quickSort` is only ever called with these two functions.

What if we fix the invocation arity?

```
diff --git a/dist/source-map.js b/dist/source-map.js
index ade5bb2..2d39b28 100644
--- a/dist/source-map.js
+++ b/dist/source-map.js
@@ -2779,7 +2779,7 @@ return /******/ (function(modules) { // webpackBootstrap
            //
            //   * Every element in `ary[i+1 .. j-1]` is greater than the pivot.
            for (var j = p; j < r; j++) {
-             if (comparator(ary[j], pivot) <= 0) {
+             if (comparator(ary[j], pivot, false) <= 0) {
                i += 1;
                swap(ary, i, j);
                }
``` 

> Note: I am doing edits directly in `dist/source-map.js` because I did not want to spend time figuring out the build process.

```
╭─ ~/src/source-map/bench ‹perf-work› [Fix comparator invocation arity]
╰─$ d8 bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 4037.084000
console.timeEnd: iteration, 4249.258000
console.timeEnd: iteration, 4241.165000
console.timeEnd: iteration, 3936.664000
console.timeEnd: iteration, 4131.844000
console.timeEnd: iteration, 4140.963000
[Stats samples: 6, total: 24737 ms, mean: 4122.833333333333 ms, stddev: 132.18789657150916 ms]
``` 

Just by fixing the arity mismatch we improved benchmark mean on V8 by 14% from 4774 ms to 4123 ms. If we profile the benchmark again we will discover that `ArgumentsAdaptorTrampoline` has completely disappeared from it. Why was it there in the first place?

It turns out that `ArgumentsAdaptorTrampoline` is V8’s mechanism for coping with JavaScript’s variadic calling convention: you can call function that has 3 parameters with 2 arguments - in which case the third parameter will be filled with `undefined`. V8 does this by creating a new frame on the stack, copying arguments down and then invoking the target function:

![Argument adaptation](https://mrale.ph/images/2018-02-03/argument-adaptation.png)

If you have never heard about _execution stack_, checkout out [Wikipedia](https://en.wikipedia.org/wiki/Call_stack) and Franziska Hinkelmann’s [blog post](https://fhinkel.rocks/2017/10/30/Confused-about-Stack-and-Heap/).

While such costs might be negligible for cold code, in this code `comparator` was invoked millions of times during benchmark run which magnified overheads of arguments adaptation.

An attentive reader might also notice that we are now explicitly passing boolean value `false` where previously an implicit `undefined` was used. This does seem to contribute a bit to the performance improvement. If we replace `false` with `void 0` we would get slightly worse numbers:

```
diff --git a/dist/source-map.js b/dist/source-map.js
index 2d39b28..243b2ef 100644
--- a/dist/source-map.js
+++ b/dist/source-map.js
@@ -2779,7 +2779,7 @@ return /******/ (function(modules) { // webpackBootstrap
            //
            //   * Every element in `ary[i+1 .. j-1]` is greater than the pivot.
            for (var j = p; j < r; j++) {
-             if (comparator(ary[j], pivot, false) <= 0) {
+             if (comparator(ary[j], pivot, void 0) <= 0) {
                i += 1;
                swap(ary, i, j);
                }
```

```
╭─ ~/src/source-map/bench ‹perf-work U› [Fix comparator invocation arity]
╰─$ ~/src/v8/v8/out.gn/x64.release/d8 bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 4215.623000
console.timeEnd: iteration, 4247.643000
console.timeEnd: iteration, 4425.871000
console.timeEnd: iteration, 4167.691000
console.timeEnd: iteration, 4343.613000
console.timeEnd: iteration, 4209.427000
[Stats samples: 6, total: 25610 ms, mean: 4268.333333333333 ms, stddev: 106.38947316346669 ms]
```

For what it is worth argument adaptation overhead seems to be highly V8 specific. When I benchmark my change against SpiderMonkey, I don’t see any significant performance improvement from matching the arity:

```
╭─ ~/src/source-map/bench ‹ d052ea4› [Disabled serialization part of the benchmark]
╰─$ sm bench-shell-bindings.js
Parsing source map
[Stats samples: 8, total: 24751 ms, mean: 3093.875 ms, stddev: 327.27966571700836 ms]
╭─ ~/src/source-map/bench ‹perf-work› [Fix comparator invocation arity]
╰─$ sm bench-shell-bindings.js
Parsing source map
[Stats samples: 8, total: 25397 ms, mean: 3174.625 ms, stddev: 360.4636187025859 ms]
``` 

SpiderMonkey shell is now very easy to install thanks to Mathias Bynens’es [jsvu](https://github.com/GoogleChromeLabs/jsvu) tool.

Let us get back to the sorting code. If we profile the benchmark again we will notice that `ArgumentsAdaptorTrampoline` is gone for good from the profile, but `CallFunction_ReceiverIsNullOrUndefined` is still there. This is not surprising given that we are still calling the `comparator`.

### Optimizing Sorting - Monomorphisation

What usually performs better than calling the function? Not calling it!

The obvious option here is to try and get the comparator inlined into the `doQuickSort`. However the fact that `doQuickSort` is called with different `comparator` functions stands in the way of inlining.

To work around this we can try to monomorphise `doQuickSort` by cloning it. Here is how we do it.

We start by wrapping `doQuickSort` and other helpers into `SortTemplate` function:

```
function SortTemplate(comparator) {
    function swap(ary, x, y) {
    // ...
    }

    function randomIntInRange(low, high) {
    // ...
    }

    function doQuickSort(ary, p, r) {
    // ...
    }

    return doQuickSort;
}
```

Then we can produce clones of our sorting routines by converting `SortTemplate` into a string and then parsing it back into a function via `Function` constructor:

```
function cloneSort(comparator) {
    let template = SortTemplate.toString();
    let templateFn = new Function(`return ${template}`)();
    return templateFn(comparator);  // Invoke template to get doQuickSort
}
``` 

Now we can use `cloneSort` to produce a sort function for each comparator we are using:

```
let sortCache = new WeakMap();  // Cache for specialized sorts.
exports.quickSort = function (ary, comparator) {
    let doQuickSort = sortCache.get(comparator);
    if (doQuickSort === void 0) {
    doQuickSort = cloneSort(comparator);
    sortCache.set(comparator, doQuickSort);
    }
    doQuickSort(ary, 0, ary.length - 1);
};
```    

Rerunning benchmark yields:

```
╭─ ~/src/source-map/bench ‹perf-work› [Clone sorting functions for each comparator]
╰─$ d8 bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 2955.199000
console.timeEnd: iteration, 3084.979000
console.timeEnd: iteration, 3193.134000
console.timeEnd: iteration, 3480.459000
console.timeEnd: iteration, 3115.011000
console.timeEnd: iteration, 3216.344000
console.timeEnd: iteration, 3343.459000
console.timeEnd: iteration, 3036.211000
[Stats samples: 8, total: 25423 ms, mean: 3177.875 ms, stddev: 181.87633161024556 ms]
``` 

We can see that the mean time went from 4268 ms to 3177 ms (25% improvement).

Profiling reveals the following picture:

```
Overhead Symbol
    14.95% *doQuickSort :44
    11.49% *doQuickSort :44
    3.29% Builtin:StringEqual
    3.13% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.86% v8::internal::StringTable::LookupStringIfExists_NoAllocate
    1.86% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.72% Builtin:StringCharAt
    1.67% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.61% v8::internal::Scavenger::ScavengeObject
    1.45% v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
    1.23% Builtin:StringPrototypeSlice
    1.17% v8::internal::(anonymous namespace)::MakeStringThin
    1.08% Builtin:KeyedLoadIC_Megamorphic
    1.05% v8::internal::(anonymous namespace)::CopyObjectToObjectElements
    0.99% v8::internal::String::VisitFlat<v8::internal::IteratingStringHasher>
    0.86% clear_page_c_e
    0.77% v8::internal::IncrementalMarking::RecordWriteSlow
    0.48% Builtin:MathRandom
    0.41% Builtin:RecordWrite
    0.39% Builtin:KeyedLoadIC
```

Overheads related to invoking `comparator` have now completely disappeared from the profile.

At this point I became interested in how much time we spend _parsing_ mappings vs. _sorting_ them. I went into the parsing code and added few `Date.now()` invocations:

I wanted to sprinkle `performance.now()` but SpiderMonkey shell apparently does not support it.

```
diff --git a/dist/source-map.js b/dist/source-map.js
index 75ebbdf..7312058 100644
--- a/dist/source-map.js
+++ b/dist/source-map.js
@@ -1906,6 +1906,8 @@ return /******/ (function(modules) { // webpackBootstrap
            var generatedMappings = [];
            var mapping, str, segment, end, value;

+
+      var startParsing = Date.now();
            while (index < length) {
                if (aStr.charAt(index) === ';') {
                generatedLine++;
@@ -1986,12 +1988,20 @@ return /******/ (function(modules) { // webpackBootstrap
                }
                }
            }
+      var endParsing = Date.now();

+      var startSortGenerated = Date.now();
            quickSort(generatedMappings, util.compareByGeneratedPositionsDeflated);
            this.__generatedMappings = generatedMappings;
+      var endSortGenerated = Date.now();

+      var startSortOriginal = Date.now();
            quickSort(originalMappings, util.compareByOriginalPositions);
            this.__originalMappings = originalMappings;
+      var endSortOriginal = Date.now();
+
+      console.log(`${}, ${endSortGenerated - startSortGenerated}, ${endSortOriginal - startSortOriginal}`);
+      console.log(`sortGenerated: `);
+      console.log(`sortOriginal:  `);
            };
``` 

This yielded:

```
╭─ ~/src/source-map/bench ‹perf-work U› [Clone sorting functions for each comparator]
╰─$ d8 bench-shell-bindings.js
Parsing source map
parse:         1911.846
sortGenerated: 619.5990000000002
sortOriginal:  905.8220000000001
parse:         1965.4820000000004
sortGenerated: 602.1939999999995
sortOriginal:  896.3589999999995
^C
``` 

Here is how parsing and sorting times look like in V8 and SpiderMonkey per benchmark iteration run:

![Parse and Sort times](https://mrale.ph/images/2018-02-03/parse-sort-0.png)

In V8 we seem to be spending roughly as much time parsing mappings as sorting them. In SpiderMonkey parsing is considerably faster - while sorting is slower. This prompted me to start looking at the parsing code.

### Optimizing Parsing - Removing Segment Cache

Lets take a look at the profile again

```
Overhead  Symbol
    18.23%  *doQuickSort :44
    12.36%  *doQuickSort :44
    3.84%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    3.07%  Builtin:StringEqual
    1.92%  v8::internal::StringTable::LookupStringIfExists_NoAllocate
    1.85%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.59%  *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
    1.54%  Builtin:StringCharAt
    1.52%  v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
    1.38%  v8::internal::Scavenger::ScavengeObject
    1.27%  Builtin:KeyedLoadIC_Megamorphic
    1.22%  Builtin:StringPrototypeSlice
    1.10%  v8::internal::(anonymous namespace)::MakeStringThin
    1.05%  v8::internal::(anonymous namespace)::CopyObjectToObjectElements
    1.03%  v8::internal::String::VisitFlat<v8::internal::IteratingStringHasher>
    0.88%  clear_page_c_e
    0.51%  Builtin:MathRandom
    0.48%  Builtin:KeyedLoadIC
    0.46%  v8::internal::IteratingStringHasher::Hash
    0.41%  Builtin:RecordWrite
``` 

Removing the JavaScript code we recognize leaves us with the following:

```
Overhead  Symbol
    3.07%  Builtin:StringEqual
    1.92%  v8::internal::StringTable::LookupStringIfExists_NoAllocate
    1.54%  Builtin:StringCharAt
    1.52%  v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
    1.38%  v8::internal::Scavenger::ScavengeObject
    1.27%  Builtin:KeyedLoadIC_Megamorphic
    1.22%  Builtin:StringPrototypeSlice
    1.10%  v8::internal::(anonymous namespace)::MakeStringThin
    1.05%  v8::internal::(anonymous namespace)::CopyObjectToObjectElements
    1.03%  v8::internal::String::VisitFlat<v8::internal::IteratingStringHasher>
    0.88%  clear_page_c_e
    0.51%  Builtin:MathRandom
    0.48%  Builtin:KeyedLoadIC
    0.46%  v8::internal::IteratingStringHasher::Hash
    0.41%  Builtin:RecordWrite
``` 

When I started looking at call chains for individual entries I discovered that many of them pass through `KeyedLoadIC_Megamorphic` into `SourceMapConsumer_parseMappings`.

```
-    1.92% v8::internal::StringTable::LookupStringIfExists_NoAllocate
    - v8::internal::StringTable::LookupStringIfExists_NoAllocate
        + 99.80% Builtin:KeyedLoadIC_Megamorphic

-    1.52% v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
    - v8::internal::(anonymous namespace)::StringTableNoAllocateKey::IsMatch
        - 98.32% v8::internal::StringTable::LookupStringIfExists_NoAllocate
            + Builtin:KeyedLoadIC_Megamorphic
        + 1.68% Builtin:KeyedLoadIC_Megamorphic

-    1.27% Builtin:KeyedLoadIC_Megamorphic
    - Builtin:KeyedLoadIC_Megamorphic
        + 57.65% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
        + 22.62% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
        + 15.91% *SourceMapConsumer_parseMappings ../dist/source-map.js:1894
        + 2.46% Builtin:InterpreterEntryTrampoline
        + 0.61% BytecodeHandler:Mul
        + 0.57% *doQuickSort :44

-    1.10% v8::internal::(anonymous namespace)::MakeStringThin
    - v8::internal::(anonymous namespace)::MakeStringThin
        - 94.72% v8::internal::StringTable::LookupStringIfExists_NoAllocate
            + Builtin:KeyedLoadIC_Megamorphic
        + 3.63% Builtin:KeyedLoadIC_Megamorphic
        + 1.66% v8::internal::StringTable::LookupString
``` 

This sort of call stacks indicated to me that the code is performing a lot of keyed lookups of form `obj[key]` where `key` is dynamically built string. When I looked at the parsing I discovered [the following code](https://github.com/mozilla/source-map/blob/693728299cf87d1482e4c37ae90f5bce8edf899f/lib/source-map-consumer.js#L496-L529):

```
// Because each offset is encoded relative to the previous one,
// many segments often have the same encoding. We can exploit this
// fact by caching the parsed variable length fields of each segment,
// allowing us to avoid a second parse if we encounter the same
// segment again.
for (end = index; end < length; end++) {
    if (this._charIsMappingSeparator(aStr, end)) {
    break;
    }
}
str = aStr.slice(index, end);

segment = cachedSegments[str];
if (segment) {
    index += str.length;
} else {
    segment = [];
    while (index < end) {
    base64VLQ.decode(aStr, index, temp);
    value = temp.value;
    index = temp.rest;
    segment.push(value);
    }

    // ...

    cachedSegments[str] = segment;
}
``` 

This code is responsible for decoding Base64 VLQ encoded sequences, e.g. a string `A` would be decoded as `[0]` and `UAAAA` gets decoded as `[10,0,0,0,0]`. I suggest checking [this blog post](https://blogs.msdn.microsoft.com/davidni/2016/03/14/source-maps-under-the-hood-vlq-base64-and-yoda/) about source maps internals if you would like to understand the encoding itself better.

Instead of decoding each sequence independently this code attempts to cache decoded segments: it scans forward until a separator (`,` or `;`) is found, then extracts substring from the current position to the separator and checks if we have previous decoded such segment by looking up the extracted substring in a cache - if we hit the cache we return cached segment, otherwise we parse and cache the segment in the cache.

Caching (aka [memoization](https://en.wikipedia.org/wiki/Memoization)) is a very powerful optimization technique - however it only makes sense when maintaining the cache itself and looking up cached results is cheaper than performing computation itself again.

#### Abstract Analysis

Lets try to compare these two operations abstractly.

**On one hand is pure parsing:**

Parsing segment looks at each character of a segment once. For each character it performs few comparisons and arithmetic operations to convert a base64 character into an integer value it represents. Then it performs few bitwise operations to incorporate this integer value into a larger integer value. Then it stores decoded value into an array and moves to the next part of the segment. Segments are limited to 5 elements.

**On the other hand caching:**

1.  To look up a cached value we traverse all the characters of the segment once to find its end;
2.  We extract the substring, which requires allocation and potentially copying depending on how strings are implemented in a JS VM;
3.  We use this string as a key in a dictionary, which:
    1.  first requires VM to compute hash for this string (traversing it again and performing various bitwise operations on individual characters), this might also require VM to internalize the string (depending on implementation);
    2.  then VM has to perform a hash table lookup, which requires probing and comparing key by value with other keys (which might require it again to look at individual characters in a string);

Overall it seems that direct parsing should be faster, assuming that JS VM does good job with individual arithmetic/bitwise operations, simply because it looks at each individual character only once, where caching requires traversing the segment 2-4 times just to establish whether we hit the cache or not.

Profile seems to confirm this too: `KeyedLoadIC_Megamorphic` is a stub used by V8 to implement keyed lookups like `cachedSegments[str]` in the code above.

Based on these observations I set out to do few experiments. First I checked how big `cachedSegments` cache is at the end of the parsing. The smaller it is the more efficient caching would be.

Turns out that it grows quite big:

```
Object.keys(cachedSegments).length = 155478
``` 

#### Standalone Microbenchmarks

Now I decided to write a small standalone benchmark:

```
// Generate a string with [n] segments, segments repeat in a cycle of length
// [v] i.e. segments number 0, v, 2*v, ... are all equal and so are
// 1, 1 + v, 1 + 2*v, ...
// Use [base] as a base value in a segment - this parameter allows to make
// segments long.
//
// Note: the bigger [v], the bigger [cachedSegments] cache is.
function makeString(n, v, base) {
    var arr = [];
    for (var i = 0; i < n; i++) {
    arr.push([0, base + (i % v), 0, 0].map(base64VLQ.encode).join(''));
    }
    return arr.join(';') + ';';
}

// Run function [f] against the string [str].
function bench(f, str) {
    for (var i = 0; i < 1000; i++) {
    f(str);
    }
}

// Measure and report performance of [f] against [str].
// It has [v] different segments.
function measure(v, str, f) {
    var start = Date.now();
    bench(f, str);
    var end = Date.now();
    report(`${v}, ${f.name}, ${(end - start).toFixed(2)}`);
}

async function measureAll() {
    for (let v = 1; v <= 256; v *= 2) {
    // Make a string with 1000 total segments and [v] different ones
    // so that [cachedSegments] has [v] cached segments.
    let str = makeString(1000, v, 1024 * 1024);

    let arr = encoder.encode(str);

    // Run 10 iterations for each way of decoding.
    for (var j = 0; j < 10; j++) {
        measure(j, i, str, decodeCached);
        measure(j, i, str, decodeNoCaching);
        measure(j, i, str, decodeNoCachingNoStrings);
        measure(j, i, arr, decodeNoCachingNoStringsPreEncoded);
        await nextTick();
    }
    }
}

function nextTick() { return new Promise((resolve) => setTimeout(resolve)); }
```

**以上为本文的第一部分，更多内容详见 [Maybe you don't need Rust and WASM to speed up your JS — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md)。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
