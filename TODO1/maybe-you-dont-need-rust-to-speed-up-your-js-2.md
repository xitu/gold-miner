> * 原文地址：[Maybe you don't need Rust and WASM to speed up your JS — Part 2](https://mrale.ph/blog/2018/02/03/maybe-you-dont-need-rust-to-speed-up-your-js-2.html)
> * 原文作者：[Vyacheslav Egorov](http://mrale.ph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md)
> * 译者：
> * 校对者：

# Maybe you don't need Rust and WASM to speed up your JS — Part 2

**以下内容为本系列文章的第二部分，如果你还没看第一部分，请移步 [Maybe you don't need Rust and WASM to speed up your JS — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md)。**

There are three different ways to decode Base64 VLQ segments that I tried against each other.

The first one `decodeCached` is exactly the same as the default implementation used by `source-map` - which I already listed above:

```
function decodeCached(aStr) {
    var length = aStr.length;
    var cachedSegments = {};
    var end, str, segment, value, temp = {value: 0, rest: 0};
    const decode = base64VLQ.decode;

    var index = 0;
    while (index < length) {
    // Because each offset is encoded relative to the previous one,
    // many segments often have the same encoding. We can exploit this
    // fact by caching the parsed variable length fields of each segment,
    // allowing us to avoid a second parse if we encounter the same
    // segment again.
    for (end = index; end < length; end++) {
        if (_charIsMappingSeparator(aStr, end)) {
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
        decode(aStr, index, temp);
        value = temp.value;
        index = temp.rest;
        segment.push(value);
        }

        if (segment.length === 2) {
        throw new Error('Found a source, but no line and column');
        }

        if (segment.length === 3) {
        throw new Error('Found a source and line, but no column');
        }

        cachedSegments[str] = segment;
    }

    index++;
    }
}
``` 

The next competitor is `decodeNoCaching`. It is essentially `decodeCached` but without the cache. Each segment is decoded independently. I also replaced `Array` with `Int32Array` for `segment` storage.

```
function decodeNoCaching(aStr) {
    var length = aStr.length;
    var cachedSegments = {};
    var end, str, segment, temp = {value: 0, rest: 0};
    const decode = base64VLQ.decode;

    var index = 0, value;
    var segment = new Int32Array(5);
    var segmentLength = 0;
    while (index < length) {
    segmentLength = 0;
    while (!_charIsMappingSeparator(aStr, index)) {
        decode(aStr, index, temp);
        value = temp.value;
        index = temp.rest;
        if (segmentLength >= 5) throw new Error('Too many segments');
        segment[segmentLength++] = value;
    }

    if (segmentLength === 2) {
        throw new Error('Found a source, but no line and column');
    }

    if (segmentLength === 3) {
        throw new Error('Found a source and line, but no column');
    }

    index++;
    }
}
``` 

Finally the third variant `decodeNoCachingNoString` tries to avoid dealing with JavaScript strings altogether by converting the string into utf8 encoded `Uint8Array`. This optimization is inspired by the fact that JS VMs are more likely to optimize an array load down to a single memory access. Optimizing `String.prototype.charCodeAt` to the same extent is harder due to the sheer complexity of the hierarchy of different string representations that JS VMs utilize.

I benchmarked both a version that encodes string into utf8 as part of the iteration and a version that uses preencoded string. With this latter “optimistic” version I am trying to estimate how much we could gain if we were able to skip _typed array ⇒ string ⇒ typed array_ round trip. Which would be possible if we loaded the source map directly as an array buffer and parsed it directly from that buffer instead of converting it to string first.

```
let encoder = new TextEncoder();
function decodeNoCachingNoString(aStr) {
    decodeNoCachingNoStringPreEncoded(encoder.encode(aStr));
}

function decodeNoCachingNoStringPreEncoded(arr) {
    var length = arr.length;
    var cachedSegments = {};
    var end, str, segment, temp = {value: 0, rest: 0};
    const decode2 = base64VLQ.decode2;

    var index = 0, value;
    var segment = new Int32Array(5);
    var segmentLength = 0;
    while (index < length) {
    segmentLength = 0;
    while (arr[index] != 59 && arr[index] != 44) {
        decode2(arr, index, temp);
        value = temp.value;
        index = temp.rest;
        if (segmentLength < 5) {
        segment[segmentLength++] = value;
        }
    }

    if (segmentLength === 2) {
        throw new Error('Found a source, but no line and column');
    }

    if (segmentLength === 3) {
        throw new Error('Found a source and line, but no column');
    }

    index++;
    }
}
``` 

Here are the results I’ve gotten by running my microbenchmark in Chrome Dev `66.0.3343.3` (V8 `6.6.189`) and Firefox Nightly `60.0a1 (2018-02-11)`:

![Different Decodes](https://mrale.ph/images/2018-02-03/different-decodes.png)

There are few things to notice here:

*   the version that uses caching is slower than anything else on both V8 and SpiderMonkey. Its performance degrades steeply as number of cache entries grows - while performance of non-caching versions does not depend on that;
*   on SpiderMonkey it pays off to convert string into typed array as part of parsing, while on V8 character access is fast enough - so it only pays off to use array if you can move string-to-array conversion out of the benchmark (e.g. you load your data into typed arrays to begin with);

I was curious if V8 team did any work recently to improve `charCodeAt` performance - as I remembered rather vividly that Crankshaft never made an effort to specialize `charCodeAt` for a particular string representation at a call-site and instead expanded `charCodeAt` into a large chunk of code handling many different string representations, making loading characters from strings slower than loading elements from typed arrays.

I trawled V8 issue tracker and found few active issues like these:

*   [Issue 6391: StringCharCodeAt slower than Crankshaft](https://bugs.chromium.org/p/v8/issues/detail?id=6391);
*   [Issue 7092: High overhead of String.prototype.charCodeAt in typescript test](https://bugs.chromium.org/p/v8/issues/detail?id=7092);
*   [Issue 7326: Performance degradation when looping across character codes of a string](https://bugs.chromium.org/p/v8/issues/detail?id=7326);

Some of the comments on these issues reference commits from late January 2018 and onward, which indicated to me that performance of `charCodeAt` is being actively worked on. Out of curiosity I decided to rerun my microbenchmark in Chrome Beta and compare against Chrome Dev

![Different Decodes](https://mrale.ph/images/2018-02-03/different-decodes-v8s.png)

This comparison does in fact confirm that all those commits by the V8 team were not for nothing: performance of `charCodeAt` improved drastically from version `6.5.254.21` to `6.6.189`. Comparing “no cache” and “using array” lines we can see that on an older V8 `charCodeAt` behaved so much worse that it made sense to convert the string into `Uint8Array` just to access it faster. However the overhead of doing this conversion inside the parse does not pay off anymore in a newer V8.

However it still pays off to use an array instead of a string as long as you don’t have to pay the conversion cost. Why is that? To figure that out I run the following code in tip-of-the tree V8:

```
function foo(str, i) {
    return str.charCodeAt(i);
}

let str = "fisk";

foo(str, 0);
foo(str, 0);
foo(str, 0);
%OptimizeFunctionOnNextCall(foo);
foo(str, 0);
```

```
╭─ ~/src/v8/v8 ‹master›
╰─$ out.gn/x64.release/d8 --allow-natives-syntax --print-opt-code --code-comments x.js
``` 

The command produced a [gigantic assembly listing](https://gist.github.com/mraleph/a1f36a67676a8dfef0af081f27f3eb6a) confirming my suspicion that V8 still does not specialize `charCodeAt` for a particular string representation. This lowering seems to come from [this code](https://github.com/v8/v8/blob/de7a3174282a48fab9c167155ffc8ff20c37214d/src/compiler/effect-control-linearizer.cc#L2687-L2826) in V8 sources, which resolves the mystery of why array access is faster than string `charCodeAt`.

#### Parsing Improvements

In light of these discoveries lets remove caching of parsed segments from `source-map` parsing code and measure the effect.

![Parse and Sort times](https://mrale.ph/images/2018-02-03/parse-sort-1.png)

Just like our microbenchmarking predicted caching was detrimental to the overall performance rather than being beneficial: removing it actually improves parsing times considerably.

### Optimizing Sorting - Algorithmic Improvements

Now that we improved parsing performance lets take a look at the sorting again.

There are two arrays that are being sorted:

1.  `originalMappings` array is being sorted using `compareByOriginalPositions` comparator;
2.  `generatedMappings` array is being sorted using `compareByGeneratedPositionsDeflated` comparator.

#### Optimizing `originalMappings` Sorting

I took a look at `compareByOriginalPositions` first.

```
function compareByOriginalPositions(mappingA, mappingB, onlyCompareOriginal) {
    var cmp = strcmp(mappingA.source, mappingB.source);
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.originalLine - mappingB.originalLine;
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.originalColumn - mappingB.originalColumn;
    if (cmp !== 0 || onlyCompareOriginal) {
    return cmp;
    }

    cmp = mappingA.generatedColumn - mappingB.generatedColumn;
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.generatedLine - mappingB.generatedLine;
    if (cmp !== 0) {
    return cmp;
    }

    return strcmp(mappingA.name, mappingB.name);
}
``` 

Here I noticed that mappings are being ordered by `source` component first and then by all other components. `source` specifies which source file the mapping originally came from. An obvious idea here is that instead of using a flat gigantic `originalMappings` array, which mixes together mappings from different source files, we can turn `originalMappings` into array of arrays: `originalMappings[i]` would be an array of all mappings from source file with index `i`. This way we can sort mappings into different `originalMappings[i]` arrays based on their source as we parse them and then sort individual smaller arrays.

This is essentially a [Bucket Sort](https://en.wikipedia.org/wiki/Bucket_sort)

Here is what we do in parsing loop:

```
if (typeof mapping.originalLine === 'number') {
    // This code used to just do: originalMappings.push(mapping).
    // Now it sorts original mappings already by source during parsing.
    let currentSource = mapping.source;
    while (originalMappings.length <= currentSource) {
    originalMappings.push(null);
    }
    if (originalMappings[currentSource] === null) {
    originalMappings[currentSource] = [];
    }
    originalMappings[currentSource].push(mapping);
}
```

And then after that:

```
var startSortOriginal = Date.now();
// The code used to sort the whole array:
//     quickSort(originalMappings, util.compareByOriginalPositions);
for (var i = 0; i < originalMappings.length; i++) {
    if (originalMappings[i] != null) {
    quickSort(originalMappings[i], util.compareByOriginalPositionsNoSource);
    }
}
var endSortOriginal = Date.now();
```

The `compareByOriginalPositionsNoSource` comparator is almost exactly the same as `compareByOriginalPositions` comparator except it does not compare `source` component anymore - those are guaranteed to be equal due to the way we constructed each `originalMappings[i]` array.

![Parse and Sort times](https://mrale.ph/images/2018-02-03/parse-sort-2.png)

This algorithmic change improves sorting times on both V8 and SpiderMonkey and additionally improves parsing times on V8.

Parse time improvement is likely due to the reduction of costs associated with managing `originalMappings` array: growing a single gigantic `originalMappings` array is more expensive than growing multiple smaller `originalMappings[i]` arrays individually. However this is just my guess, which is not confirmed by any rigorous analysis.

#### Optimizing `generatedMappings` Sorting

Let us take a look at `generatedMappings` and `compareByGeneratedPositionsDeflated` comparator.

```
function compareByGeneratedPositionsDeflated(mappingA, mappingB, onlyCompareGenerated) {
    var cmp = mappingA.generatedLine - mappingB.generatedLine;
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.generatedColumn - mappingB.generatedColumn;
    if (cmp !== 0 || onlyCompareGenerated) {
    return cmp;
    }

    cmp = strcmp(mappingA.source, mappingB.source);
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.originalLine - mappingB.originalLine;
    if (cmp !== 0) {
    return cmp;
    }

    cmp = mappingA.originalColumn - mappingB.originalColumn;
    if (cmp !== 0) {
    return cmp;
    }

    return strcmp(mappingA.name, mappingB.name);
}
```

Here we first compare mappings by `generatedLine`. There are likely considerably more generated lines than original source files so it does not make sense to split `generatedMappings` into multiple individual arrays.

However when I looked at the parsing code I noticed the following:

```
while (index < length) {
    if (aStr.charAt(index) === ';') {
    generatedLine++;
    // ...
    } else if (aStr.charAt(index) === ',') {
    // ...
    } else {
    mapping = new Mapping();
    mapping.generatedLine = generatedLine;

    // ...
    }
}
```

These are the only occurrences of `generatedLine` in this code, which means that `generatedLine` is growing monotonically - implying that `generatedMappings` array is already ordered by `generatedLine` and it does not make sense to sort the array as whole. Instead we can sort each individual smaller subarray. We change the code like this:

```
let subarrayStart = 0;
while (index < length) {
    if (aStr.charAt(index) === ';') {
    generatedLine++;
    // ...

    // Sort subarray [subarrayStart, generatedMappings.length].
    sortGenerated(generatedMappings, subarrayStart);
    subarrayStart = generatedMappings.length;
    } else if (aStr.charAt(index) === ',') {
    // ...
    } else {
    mapping = new Mapping();
    mapping.generatedLine = generatedLine;

    // ...
    }
}
// Sort the tail.
sortGenerated(generatedMappings, subarrayStart);
```

Instead of using `quickSort` for sorting smaller subarrays, I also decided to use [insertion sort](https://en.wikipedia.org/wiki/Insertion_sort), similar to a hybrid strategy that some VMs use for `Array.prototype.sort`.

Note: insertion sort is also faster than quick sort if input array is already sorted… and it turns out that mappings used for the benchmark _are_ in fact sorted. If we expect `generatedMappings` to be almost always sorted after parsing then it would be even more efficient to simply check whether `generatedMappings` is sorted before trying to sort it.

```
const compareGenerated = util.compareByGeneratedPositionsDeflatedNoLine;

function sortGenerated(array, start) {
    let l = array.length;
    let n = array.length - start;
    if (n <= 1) {
    return;
    } else if (n == 2) {
    let a = array[start];
    let b = array[start + 1];
    if (compareGenerated(a, b) > 0) {
        array[start] = b;
        array[start + 1] = a;
    }
    } else if (n < 20) {
    for (let i = start; i < l; i++) {
        for (let j = i; j > start; j--) {
        let a = array[j - 1];
        let b = array[j];
        if (compareGenerated(a, b) <= 0) {
            break;
        }
        array[j - 1] = b;
        array[j] = a;
        }
    }
    } else {
    quickSort(array, compareGenerated, start);
    }
}
```

This yields the following result:

![Parse and Sort times](https://mrale.ph/images/2018-02-03/parse-sort-3.png)

Sorting times drop drastically, while parsing times slightly increase - that happens because the code sorting `generatedMappings` as part of the parsing loop, making our breakdown slightly meaningless. Lets check comparison of cumulative timings (parsing and sorting together)

#### Improvements to Total Time

![Parse and Sort times](https://mrale.ph/images/2018-02-03/parse-sort-3-total.png)

Now it becomes obvious that we considerably improved overall mappings parsing performance.

Is there anything else we could do to improve performance?

It turns out yes: we can pull out a page from asm.js / WASM own playbook without going full-Rust on our JavaScript code base.

### Optimizing Parsing - Reducing GC Pressure

We are allocating hundreds of thousands of `Mapping` objects, which puts considerable pressure on the GC - however we don’t really need these objects to be objects - we can pack them into a typed array. Here is how I did it.

Few years ago I was really excited about [Typed Objects](https://github.com/nikomatsakis/typed-objects-explainer) proposal which would allow JavaScript programmers to define structs and arrays of structs and all other amazing things that would come extremely handy here. Unfortunately champions working on that proposal moved away to work on other things leaving us with a choice to write these things either manually or in C++ 😞

First, I changed `Mapping` from a normal object into a wrapper that points into a gigantic typed array that would contain all our mappings.

```
function Mapping(memory) {
    this._memory = memory;
    this.pointer = 0;
}
Mapping.prototype = {
    get generatedLine () {
    return this._memory[this.pointer + 0];
    },
    get generatedColumn () {
    return this._memory[this.pointer + 1];
    },
    get source () {
    return this._memory[this.pointer + 2];
    },
    get originalLine () {
    return this._memory[this.pointer + 3];
    },
    get originalColumn () {
    return this._memory[this.pointer + 4];
    },
    get name () {
    return this._memory[this.pointer + 5];
    },
    set generatedLine (value) {
    this._memory[this.pointer + 0] = value;
    },
    set generatedColumn (value) {
    this._memory[this.pointer + 1] = value;
    },
    set source (value) {
    this._memory[this.pointer + 2] = value;
    },
    set originalLine (value) {
    this._memory[this.pointer + 3] = value;
    },
    set originalColumn (value) {
    this._memory[this.pointer + 4] = value;
    },
    set name (value) {
    this._memory[this.pointer + 5] = value;
    },
};
```

Then I adjusted the parsing and sorting code to use it like this:

```
BasicSourceMapConsumer.prototype._parseMappings = function (aStr, aSourceRoot) {
    // Allocate 4 MB memory buffer. This can be proportional to aStr size to
    // save memory for smaller mappings.
    this._memory = new Int32Array(1 * 1024 * 1024);
    this._allocationFinger = 0;
    let mapping = new Mapping(this._memory);
    // ...
    while (index < length) {
    if (aStr.charAt(index) === ';') {

        // All code that could previously access mappings directly now needs to
        // access them indirectly though memory.
        sortGenerated(this._memory, generatedMappings, previousGeneratedLineStart);
    } else {
        this._allocateMapping(mapping);

        // ...

        // Arrays of mappings now store "pointers" instead of actual mappings.
        generatedMappings.push(mapping.pointer);
        if (segmentLength > 1) {
        // ...
        originalMappings[currentSource].push(mapping.pointer);
        }
    }
    }

    // ...

    for (var i = 0; i < originalMappings.length; i++) {
    if (originalMappings[i] != null) {
        quickSort(this._memory, originalMappings[i], util.compareByOriginalPositionsNoSource);
    }
    }
};

BasicSourceMapConsumer.prototype._allocateMapping = function (mapping) {
    let start = this._allocationFinger;
    let end = start + 6;
    if (end > this._memory.length) {  // Do we need to grow memory buffer?
    let memory = new Int32Array(this._memory.length * 2);
    memory.set(this._memory);
    this._memory = memory;
    }
    this._allocationFinger = end;
    let memory = this._memory;
    mapping._memory = memory;
    mapping.pointer = start;
    mapping.name = 0x7fffffff;  // Instead of null use INT32_MAX.
    mapping.source = 0x7fffffff;  // Instead of null use INT32_MAX.
};

exports.compareByOriginalPositionsNoSource =
    function (memory, mappingA, mappingB, onlyCompareOriginal) {
    var cmp = memory[mappingA + 3] - memory[mappingB + 3];  // originalLine
    if (cmp !== 0) {
    return cmp;
    }

    cmp = memory[mappingA + 4] - memory[mappingB + 4];  // originalColumn
    if (cmp !== 0 || onlyCompareOriginal) {
    return cmp;
    }

    cmp = memory[mappingA + 1] - memory[mappingB + 1];  // generatedColumn
    if (cmp !== 0) {
    return cmp;
    }

    cmp = memory[mappingA + 0] - memory[mappingB + 0];  // generatedLine
    if (cmp !== 0) {
    return cmp;
    }

    return memory[mappingA + 5] - memory[mappingB + 5];  // name
};
```

As you can see readability does suffer quite a bit. Ideally I would prefer to allocate a temporary `Mapping` object whenever I need to work with its fields. However such code style would lean heavily on VMs ability to eliminate allocations of these temporary wrappers via _allocation sinking_, _scalar replacement_ or other similar optimizations. Unfortunately in my experiments SpiderMonkey could not deal with such code well enough and thus I opted for much more verbose and error prone code.

This sort of _almost_ manual memory management might seem rather foreign in JS. That’s why I think it might be worth mentioning here that “oxidized” `source-map` actually [requires users to manually manage](https://github.com/mozilla/source-map#sourcemapconsumerprototypedestroy) its lifetime to ensure that WASM resources are freed.

Rerunning benchmark confirms that alleviating GC pressure yields a nice improvement

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-4.png)

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-4-total.png)

Interestingly enough on SpiderMonkey this approach improves both parsing _and_ sorting times, which came as a surprise to me.

#### SpiderMonkey Performance Cliff

As I was playing with this code I also discovered a confusing performance cliff in SpiderMonkey: when I increased the size of preallocated memory buffer from 4MB to 64MB to gauge reallocation costs, benchmark showed a sudden drop in performance after 7th iteration.

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-5-total.png)

This looked like some sort of polymorphism to me, but I could not immediately figure out how changing the size of an array can result in a polymorphic behavior.

Puzzled I reached out to a SpiderMonkey hacker [Jan de Mooij](https://twitter.com/jandemooij) who very [quickly identified](https://bugzilla.mozilla.org/show_bug.cgi?id=1437471) an asm.js related optimization from 2012 as a culprit… then he went and removed it from SpiderMonkey so that nobody hits this confusing cliff again.

### Optimizing Parsing - Using `Uint8Array` Instead of a String.

Finally if we start using `Uint8Array` instead of a string for parsing we get yet another small improvement.

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-6-total.png)

This improvement is predicated on rewriting `source-map` to parse mappings directly from typed arrays, instead of using JavaScript string and parsing it with `JSON.decode`. I did not do such rewrite but I don’t anticipate any issues.

### Total Improvements Against the Baseline

Here is where we started:

```
$ d8 bench-shell-bindings.js
...
[Stats samples: 5, total: 24050 ms, mean: 4810 ms, stddev: 155.91063145276527 ms]
$ sm bench-shell-bindings.js
...
[Stats samples: 7, total: 22925 ms, mean: 3275 ms, stddev: 269.5999093306804 ms]
``` 

and this is where we are finishing

```
$ d8 bench-shell-bindings.js
...
[Stats samples: 22, total: 25158 ms, mean: 1143.5454545454545 ms, stddev: 16.59358125226469 ms]
$ sm bench-shell-bindings.js
...
[Stats samples: 31, total: 25247 ms, mean: 814.4193548387096 ms, stddev: 5.591064299397745 ms]
``` 

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-final.png)

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-final-total.png)

This is a factor of 4 improvement!

It might be also worth noting that we are still sorting all `originalMappings` arrays eagerly even though this is not really needed. There are only two operations that use `originalMappings`:

*   `allGeneratedPositionsFor` which returns all generated positions for the given line in the original source;
*   `eachMapping(..., ORIGINAL_ORDER)` which iterates over all mappings in their original order.

If we assume that `allGeneratedPositionsFor` is the most common operation and that we are only going to search within a handful of `originalMappings[i]` arrays then we can vastly improve parsing time by sorting `originalMappings[i]` arrays lazily whenever we actually need to search one of them.

Finally a comparison of V8 from Jan 19th to V8 from Feb 19th with and without [untrusted code mitigations](https://github.com/v8/v8/wiki/Untrusted-code-mitigations).

![After reworking allocation](https://mrale.ph/images/2018-02-03/parse-sort-v8-vs-v8-total.png)

### Comparing to Oxidized `source-map` Version

Following the publication of this post on February 19th, I got few requests to compare `source-map` with my tweaks against mainline oxidized `source-map` that uses Rust and WASM.

Quick look at Rust source code for [`parse_mappings`](https://github.com/fitzgen/source-map-mappings/blob/master/src/lib.rs#L499-L566) revealed that Rust version does not collect or sort original mappings eagerly, only equivalent of `generatedMappings` is produced and sorted. To match this behavior I adjusted my JS version by commenting out sorting of `originalMappings[i]` arrays.

Here are benchmark results for just parsing (which also includes sorting `generatedMappings`) and for parsing and then iterating over all `generatedMappings`.

![Parse only times](https://mrale.ph/images/2018-02-03/parse-only-rust-wasm-vs-js.png)

![Parse and iterate times](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js.png)

**Note that the comparison is slightly misleading because Rust version does not optimize sorting of `generatedMappings` in the same way as my JS version does.**

Thus I am not gonna declare here that _«we have successfully reached parity with the Rust+WASM version»_. However at this level of performance differences it might make sense to reevaluate if it is even worth the complexity to use Rust in `source-map`.

#### Update (Feb 27th 2018)

Nick Fitzgerald, the author of `source-map`, [has updated](http://fitzgeraldnick.com/2018/02/26/speed-without-wizardry.html) Rust+WASM version with algorithmic improvements described in this article. Here is an amended performance graph for _parse and iterate_ benchmark:

![Parse and iterate times](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js-2.png)

As you can see WASM+Rust version is now around 15% faster on SpiderMonkey and approximately the same speed on V8.

### Learnings

#### For a JavaScript Developer

##### Profiler Is Your Friend

Profiling and fine grained performance tracking in various shapes and forms is the best way to stay on top of the performance. It allows you to localize hot-spots in your code and also reveals potential issues in the underlying runtime. For this particular reason don’t shy away from using low-level profiling tools like `perf` - “friendly” tools might not be telling you the whole story because they hide lower level.

Different performance problems require different approaches to profiling and visualizing collected profiles. Make sure to familiarize yourself with a wide spectrum of available tools.

##### Algorithms Are Important

Being able to reason about your code in terms of abstract complexity is an important skill. Is it better to quick-sort one array with 100K elements or quick-sort 3333 30-element subarrays?

A bit of handwavy mathematics can guide us ((100000 log 100000) is 3 times larger than (3333 times 30 log 30)) - and the larger your data is the more important it usually is to be able to do a tiny bit of mathematics.

In addition to knowing your logarithms, you need to posses a healthy amount of common sense and be able to evaluate how your code would be used on average and in the worst case: which operations are common, how the cost of expensive operations can be amortized, what the penalty for amortizing expensive operations?

##### VMs Are Work in Progress. Bug Developers!

Do not hesitate to reach out to developers to discuss strange performance issues. Not everything can be solved just by changing your own code. The Russian proverb says _«It’s not gods who make pots!»_. VM developers are people and just like all others they make mistakes. They are also quite good at fixing those mistakes once you reach out to them. One mail or chat message or a DM might save you days of digging through foreign C++ code.

##### VMs Still Need a Bit of Help

Sometimes you need to write low-level code or know low-level details to squeeze the last drops of that performance juice out of JavaScript.

One could prefer a better language level facilities to achieve that, but it remains to be seen if we ever get there.

#### For a Language Implementor/Designer

##### Clever Optimizations Must be Diagnosable

If your runtime has any sort of built-in clever optimizations then you need to provide a straightforward tool to diagnose when these optimizations fail and deliver an actionable feedback to the developer.

In the context of languages like JavaScript this at minimum means that tools like profiler should also provide you with a way to inspect individual operations to figure out whether VM specializes them well and it it does not - what is the reason for that.

This sort of introspection should not require building custom versions of the VM with magic flags and then treading through megabytes of undocumented debug output. This sort of tools should be right there, when you open your DevTools window.

##### Language and Optimizations Must Be Friends

Finally as a language designer you should attempt to foresee where the language lacks features which make it easier to write well performing code. Are your users on the market for a way to layout and manage memory manually? I am sure they are. If your language is even remotely popular users would eventually succeed in writing code that performs poorly. Weight the cost of adding language features that fix performance problems against solving the same performance problems by other means (e.g. by more sophisticated optimizations or by asking users to rewrite their code in Rust).

This works the other way around too: if your language has features make sure that they perform reasonably well and their performance is both well understood by users and can be easily diagnosed. Invest in making your whole language optimized, instead of having a well performing core surrounded by poorly performing long tail of rarely used features.

### Afterword

Most optimizations we discovered in this post fall into three different groups:

1.  algorithmic improvements;
2.  workarounds for implementation independent, but potentially language dependent issues;
3.  workarounds for V8 specific issues.

No matter which language you write in you still need to think about algorithms. It is easier to notice when you are using worse algorithms in inherently “slower” languages, but just reimplementing the same algorithms in a “faster” language does not solve the problem even though it might alleviate the symptoms. Large part of the post is dedicated to optimizations from this group:

*   sorting improvements achieved by sorting subsequences rather than the whole array;
*   discussions of caching benefits or lack of them there-off.

The second group is represented by the monomorphisation trick. Performance suffering due to polymorphism is not a V8 specific issue. Neither it is a JS specific issue. You can apply monomorphisation across implementations and even languages. Some languages (Rust, actually) apply it in some form for you under the hood.

The last and most controversial group is represented by argument adaptation stuff.

Finally an optimization I did to mappings representation (packing individual objects into a single typed array) is an optimization that spans all three groups. It’s about understanding limitations and costs of a GCed system as whole. It’s also about understanding strength of existing JS VMs and utilizing it for our advantage.

So… **Why did I choose the title?** That’s because I think that the third group represents all issues which should and would be fixed over time. Other groups represent universal knowledge that spans across implementations and languages.

Obviously each developer and each team are free to choose between spending `N` rigorous hours profiling and reading and thinking about their JavaScript code, or to spend `M` hours rewriting their stuff in a language `X`.

However: (a) everybody needs to be fully aware that the choice even exists; and (b) language designers and implementors should work together on making this choice less and less obvious - which means working on language features and tools and reducing the need in “group №3” optimizations.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
