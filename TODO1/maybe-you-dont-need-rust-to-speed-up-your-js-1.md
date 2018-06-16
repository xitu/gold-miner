> * 原文地址：[Maybe you don't need Rust and WASM to speed up your JS — Part 1](https://mrale.ph/blog/2018/02/03/maybe-you-dont-need-rust-to-speed-up-your-js.html)
> * 原文作者：[Vyacheslav Egorov](http://mrale.ph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md)
> * 译者：[Shery](https://github.com/shery15)
> * 校对者：[geniusq1981](https://github.com/geniusq1981)

# 或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第一部分

几个星期前，我在 Twitter 上看到一篇名为 [“Oxidizing Source Maps with Rust and WebAssembly”](https://hacks.mozilla.org/2018/01/oxidizing-source-maps-with-rust-and-webassembly/) 的推文，其内容主要是讨论用 Rust 编写的 WebAssembly 替换 `source-map` 库中纯 JavaScript 编写的核心代码所带来的性能优势。

这篇文章使我感兴趣的原因，并不是因为我擅长 Rust 或 WASM，而是因为我总是对语言特性和纯 JavaScript 中缺少的性能优化感到好奇。

于是我从 GitHub 检出了这个库，然后逐字逐句的记录了这次小型性能研究。

### 获取代码

对于我的研究，当时使用的是**近乎**默认配置的 x64 V8 的发布版本，V8 版本对应着 1 月 20 日的提交历史 commit [69abb960c97606df99408e6869d66e014aa0fb51](https://chromium.googlesource.com/v8/v8/+/69abb960c97606df99408e6869d66e014aa0fb51)。为了能够根据需要深入到生成的机器码，我通过 GN 标志启用了反汇编程序，这是我唯一偏离默认配置的地方。

```
╭─ ~/src/v8/v8 ‹master›
╰─$ gn args out.gn/x64.release --list --short --overrides-only
is_debug = false
target_cpu = "x64"
use_goma = true
v8_enable_disassembler = true
``` 

然后我获取了两个版本的 [`source-map`](https://github.com/mozilla/source-map)，版本信息如下：

*   [commit c97d38b](https://github.com/mozilla/source-map/commit/c97d38b70de088d87b051f81b95c138a74032a43)，在 Rust/WASM 实装前最近一次更新 `dist/source-map.js` 的提交记录；
*   [commit 51cf770](https://github.com/mozilla/source-map/commit/51cf7708dd70d067dfe04ce36d546f3262b48da3)，当我进行这次调查时的最近一次提交记录；

### 分析纯 JavaScript 版本

在纯 JavaScript 版本中进行基准测试很简单:

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

我做的第一件事是禁用基准测试的序列化部分:

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

然后把它放到 Linux 的 `perf` 性能分析工具中:

```
╭─ ~/src/source-map/bench ‹perf-work›
╰─$ perf record -g d8 --perf-basic-prof bench-shell-bindings.js
Parsing source map
console.timeEnd: iteration, 4984.464000
^C[ perf record: Woken up 90 times to write data ]
[ perf record: Captured and wrote 24.659 MB perf.data (~1077375 samples) ]
``` 

请注意，我将 `--perf-basic-prof` 标志传递给了 `d8` 二进制文件，它通知 V8 生成一个辅助映射文件 `/tmp/perf-$pid.map`。该文件允许 `perf report` 理解 JIT 生成的机器码。

这是我们切换到主执行线程后通过 `perf report --no-children` 获得的内容:

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

事实上, 就像 [“Oxidizing Source Maps …”](https://hacks.mozilla.org/2018/01/oxidizing-source-maps-with-rust-and-webassembly/) 那篇博文说的那样，基准测试相当侧重于排序上：`doQuickSort` 出现在配置文件的顶部，并且在列表中还多次出现（这意味着它已被优化/去优化了几次）。

### 优化排序 — 参数适配

在性能分析器中出现了一些可疑内容，分别是 `Builtin:ArgumentsAdaptorTrampoline` 和 `Builtin:CallFunction_ReceiverIsNullOrUndefined`，它们似乎是V8实现的一部分。如果我们让 `perf report` 追加与它们关联的调用链信息，那么我们会注意到这些函数大多也是从排序代码中调用的：

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

现在是查看代码的时候了。快速排序实现本身位于 [`lib/quick-sort.js`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/quick-sort.js) 中，并通过解析 [`lib/source-map-consumer.js`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/source-map-consumer.js#L564-L568) 中的代码进行调用。用于排序的比较函数是 [`compareByGeneratedPositionsDeflated`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/util.js#L334-L343) 和 [`compareByOriginalPositions`](https://github.com/mozilla/source-map/blob/c97d38b70de088d87b051f81b95c138a74032a43/lib/util.js#L296-L304)。

通过查看这些比较函数是如何定义，以及如何在快速排序中调用，可以发现调用时的参数数量不匹配：

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

通过梳理源代码发现除了测试之外，`quickSort` 只被这两个函数调用过。

如果我们修复调用参数数量问题会怎么样？

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

> 注意：因为我不想花时间搞清楚构建过程，所以我直接在 `dist/source-map.js` 中进行编辑。

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

仅仅通过修正参数不匹配，我们将 V8 的基准测试平均值从 4774 ms 提高到了 4123 ms，提升了 14% 的性能。如果我们再次对基准测试进行性能分析，我们会发现 `ArgumentsAdaptorTrampoline` 已经完全消失。为什么最初它会出现呢？

事实证明，`ArgumentsAdaptorTrampoline` 是 V8 应对 JavaScript 可变参数调用约定的机制：您可以在调用有 3 个参数的函数时只传入 2 个参数 —— 在这种情况下，第三个参数将被填充为 `undefined`。V8 通过在堆栈上创建一个新的帧，接着向下复制参数，然后调用目标函数来完成此操作：

![参数适配](https://mrale.ph/images/2018-02-03/argument-adaptation.png)

> 如果您从未听说过**执行栈**，请查看[维基百科](https://en.wikipedia.org/wiki/Call_stack) 和 Franziska Hinkelmann 的[博客文章](https://fhinkel.rocks/2017/10/30/Confused-about-Stack-and-Heap/)。

尽管对于真实代码这类开销可以忽略不计，但在这段代码中，`comparator` 函数在基准测试运行期间被调用了数百万次，这扩大了参数适配的开销。

细心的读者可能还会注意到，现在我们明确地将以前使用隐式 `undefined` 的参数设置为布尔值 `false`。这看起来对性能改进有一定贡献。如果我们用 `void 0` 替换 `false`，我们会得到稍微差一点的测试数据：

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

对于参数适配开销的争论似乎是高度针对 V8 的。当我在 SpiderMonkey 下对参数适配进行基准测试时，我看不到采用参数适配后有任何显着的性能提升：

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

多亏了 Mathias Bynens 的 [jsvu](https://github.com/GoogleChromeLabs/jsvu) 工具，SpiderMonkey shell 现在非常易于安装。

让我们回到排序代码。如果我们再次分析基准测试，我们会注意到 `ArgumentsAdaptorTrampoline` 从结果中消失了，但 `CallFunction_ReceiverIsNullOrUndefined` 仍然存在。这并不奇怪，因为我们仍在调用 `comparator` 函数。

### 优化排序 — 单态（monomorphise）

怎样比调用函数的性能更好呢？不调用它！

这里明显的选择是尝试将 `comparator` 内联到 `doQuickSort`。然而事实上使用不同 `comparator` 函数调用 `doQuickSort` 阻碍了内联。

要解决这个问题，我们可以尝试通过克隆 `doQuickSort` 来实现单态（monomorphise）。下面是我们如何做到的。

我们首先使用 `SortTemplate` 函数将 `doQuickSort` 和其他 helpers 包装起来：

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

然后，我们通过先将 `SortTemplate` 函数转换为一个字符串，再通过 `Function` 构造函数将它解析成函数，从而对我们的排序函数进行克隆：

```
function cloneSort(comparator) {
    let template = SortTemplate.toString();
    let templateFn = new Function(`return ${template}`)();
    return templateFn(comparator);  // Invoke template to get doQuickSort
}
``` 

现在我们可以使用 `cloneSort` 为我们使用的每个 `comparator` 生成一个排序函数：

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

重新运行基准测试生成的结果：

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

我们可以看到平均时间从 4268 ms 变为 3177 ms（提高了 25%）。

分析器显示了以下图片：

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

与调用 `comparator` 相关的开销现在已从结果中完全消失。

这个时候，我开始对我们花了多少时间来**解析**映射和对它们进行**排序**产生了兴趣。我进入到解析部分的代码并添加了几个 `Date.now()` 记录耗时：

> 我想用 `performance.now()`，但是 SpiderMonkey shell 显然不支持它。

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

这是生成的结果：

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

以下是在 V8 和 SpiderMonkey 中每次迭代运行基准测试时解析映射和排序的耗时：

![解析和排序耗时](https://mrale.ph/images/2018-02-03/parse-sort-0.png)

在 V8 中，我们花费几乎和排序差不多的时间来进行解析映射。在 SpiderMonkey 中，解析映射速度更快，反而是排序较慢。这促使我开始查看解析代码。

### 优化解析 — 删除分段缓存

让我们再看看这个性能分析结果

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

以下是在我们删除了已知晓的 JavaScript 代码之后剩下的内容：

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

当我开始查看单个条目的调用链时，我发现其中很多都通过 `KeyedLoadIC_Megamorphic` 传入 `SourceMapConsumer_parseMappings`。

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

这种调用堆栈向我表明，代码正在执行很多 obj[key] 的键控查找，同时 key 是动态构建的字符串。当我查看解析代码时，我发现了[以下代码](https://github.com/mozilla/source-map/blob/693728299cf87d1482e4c37ae90f5bce8edf899f/lib/source-map-consumer.js#L496-L529)：

```
// 由于每个偏移量都是相对于前一个偏移量进行编码的，
// 因此许多分段通常具有相同的编码。
// 从而我们可以通过缓存每个分段解析后的可变长度字段，
// 如果我们再次遇到相同的分段，
// 可以不再对他进行解析。
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

该代码负责解码 Base64 VLQ 编码序列，例如，字符串 `A` 将被解码为 `[0]`，并且 `UAAAA` 被解码为 `[10,0,0,0,0]`。如果你想更好地理解编码本身，我建议你查看这篇关于 source maps 内部实现细节的[博客文章](https://blogs.msdn.microsoft.com/davidni/2016/03/14/source-maps-under-the-hood-vlq-base64-and-yoda/)。

该代码不是对每个序列进行独立解码，而是试图缓存已解码的分段：它向前扫描直到找到分隔符 (`,` or `;`)，然后从当前位置提取子字符串到分隔符，并通过在缓存中查找提取的子字符串来检查我们是否有先前解码过的这种分段——如果我们命中缓存，则返回缓存的分段，否则我们进行解析，并将分段缓存到缓存中。

缓存（又名[记忆化](https://en.wikipedia.org/wiki/Memoization)）是一种非常强大的优化技——然而，它只有在维护缓存本身，以及查找缓存结果比再次执行计算这个过程开销小时才有意义。

#### 抽象分析

让我们尝试抽象地比较这两个操作。

**一种是直接解析：**

解析分段只查看一个分段的每个字符。对于每个字符，它执行少量比较和算术运算，将 base64 字符转换为它所表示的整数值。然后它执行几个按位操作来将此整数值并入较大的整数值。然后它将解码值存储到一个数组中并移动到该段的下一部分。分段不得多于 5 个。

**另一种是缓存：**

1.  为了查找缓存的值，我们遍历该段的所有字符以找到其结尾；
2.  我们提取子字符串，这需要分配资源和可能的复制，具体取决于 JS VM 中字符串的实现方式；
3.  我们使用这个字符串作为 Dictionary 对象中的键名，其中：
    1.  首先需要 VM 为该字符串计算散列值（再次遍历它并对单个字符执行各种按位操作），这可能还需要 VM 将字符串内部化（取决于实现方式）；
    2.  那么 VM 必须执行散列表查找，这需要通过值与其他键进行探测和比较（这可能需要再次查看字符串中的单个字符）；

总的来看，直接解析应该更快，假设 JS VM 在独立运算/按位操作方面做得很好，仅仅是因为它只查看每个单独的字符一次，而缓存需要遍历该分段 2-4 次，以确定我们是否命中缓存。

性能分析似乎也证实了这一点：`KeyedLoadIC_Megamorphic` 是 V8 用于实现上面代码中类似  `cachedSegments[str]` 等键控查找的存根。

基于这些观察，我着手做了几个实验。首先，我检查了解析结尾有多大的 `cachedSegments` 缓存。它越小缓存效率越高。

结果发现它变得相当大：

```
Object.keys(cachedSegments).length = 155478
``` 

#### 独立微型基准测试（Microbenchmarks）

现在我决定写一个小的独立基准测试：

```
// 用 [n] 个分段生成一个字符串，分段在长度为 [v] 的循环中重复，
// 例如，分段数为 0，v，2 * v，... 都相等，
// 因此是 1, 1 + v, 1 + 2 * v, ...
// 使用 [base] 作为分段中的基本值 —— 这个参数允许分段很长。
//
// 注意：[v] 越大，[cachedSegments] 缓存越大。
function makeString(n, v, base) {
    var arr = [];
    for (var i = 0; i < n; i++) {
    arr.push([0, base + (i % v), 0, 0].map(base64VLQ.encode).join(''));
    }
    return arr.join(';') + ';';
}

// 对字符串 [str] 运行函数 [f]。
function bench(f, str) {
    for (var i = 0; i < 1000; i++) {
    f(str);
    }
}

// 衡量并报告 [f] 对 [str] 的表现。
// 它有 [v] 个不同的分段。
function measure(v, str, f) {
    var start = Date.now();
    bench(f, str);
    var end = Date.now();
    report(`${v}, ${f.name}, ${(end - start).toFixed(2)}`);
}

async function measureAll() {
    for (let v = 1; v <= 256; v *= 2) {
    // 制作一个包含 1000 个分段的字符串和 [v] 个不同的字符串
    // 因此 [cachedSegments] 具有 [v] 个缓存分段。
    let str = makeString(1000, v, 1024 * 1024);

    let arr = encoder.encode(str);

    // 针对每种解码方式运行 10 次迭代。
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

**以上为本文的第一部分，更多内容详见 [或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md)。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
