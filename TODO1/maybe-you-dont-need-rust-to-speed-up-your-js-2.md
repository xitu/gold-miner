> * 原文地址：[Maybe you don't need Rust and WASM to speed up your JS — Part 2](https://mrale.ph/blog/2018/02/03/maybe-you-dont-need-rust-to-speed-up-your-js-2.html)
> * 原文作者：[Vyacheslav Egorov](http://mrale.ph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第二部分

**以下内容为本系列文章的第二部分，如果你还没看第一部分，请移步 [或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md)。**

我尝试过三种不同的方法对 Base64 VLQ 段进行解码。

第一个是 `decodeCached`，它与 `source-map` 使用的默认实现方式完全相同 - 我已经在上面列出了：

```[]
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

下一个是`decodeNoCaching`。它实际上就是没有缓存的`decodeCached`。每个分段都被单独解码。我使用`Int32Array`来进行`segment`存储，而不再是`Array`。

```[]
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

最后，第三个是 `decodeNoCachingNoString`，它尝试通过将字符串转换为 utf8编码的`Uint8Array`来避免处理JavaScript字符串。 这个优化受到了下面的启发：JS虚拟机更有可能将阵列负载优化为单个内存访问。 由于JS VM使用的不同字符串表示的层次结构非常复杂，所以将`String.prototype.charCodeAt`优化到相同的范围更加困难。

我对比了两个版本，一个是将字符串编码为 utf8的版本，另一个是使用预编码字符串的版本。用后面的这个“优化”版本，我想要评估一下，通过数组⇒字符串⇒数组的转化过程，可以给我们带来多少的性能提升。"优化"版本的实现方式是我们将源映射为数组缓冲区并直接从该缓冲区解析它，而不是直接对字符串进行转换。

```[]
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

下面是我在Chrome Dev`66.0.3343.3`（V8`6.6.189`）和 Firefox Nightly`60.0a1` 中运行我的微基准测试得到的结果(2018-02-11):

![不同的解码](https://mrale.ph/images/2018-02-03/different-decodes.png)

注意几点：

* 在 V8 和 SpiderMonkey 上，使用缓存的版本比的其他版本都要慢。随着缓存数量的增加，其性能急剧下降 - 而无缓存版本的性能不会受此影响;
* 在SpiderMonkey上，将字符串转换为类型化数组作为分析的一部分，而在 V8上字符访问速度足够快 - 所以只有在可以将字符串到数组的转换移出基准（例如，你将你的数据加载到类型数组中以开始）;

我很怀疑 V8 团队近年来没有改进过 charCodeAt 的性能 - 我清楚地记得 Crankshaft 没有花费力气把 'charCodeAt' 作为特定字符串的调用方法，反而是将其扩大到所有以字符串表示的代码块都能使用，使得从字符串加载字符比从类型数组加载元素慢。

我浏览了V8问题跟踪器，发现了下面几个问题：

* [Issue 6391: StringCharCodeAt slower than Crankshaft](https://bugs.chromium.org/p/v8/issues/detail?id=6391);
* [Issue 7092: High overhead of String.prototype.charCodeAt in typescript test](https://bugs.chromium.org/p/v8/issues/detail?id=7092);
* [Issue 7326: Performance degradation when looping across character codes of a string](https://bugs.chromium.org/p/v8/issues/detail?id=7326);

这些问题的评论当中，有些引用了2018年1月末以后的提交，这表明正在积极地进行`charCodeAt`的性能改善。 出于好奇，我决定在 Chrome Beta 版本中重新运行我的微基准测试，并与 Chrome Dev 版本进行比较

![Different Decodes](https://mrale.ph/images/2018-02-03/different-decodes-v8s.png)

事实上，通过比较可以确认 V8 团队的所有提交都卓有成效的：`charCodeAt`的性能从“6.5.254.21”版本到“6.6.189”版本得到了很大提高。 通过对比“无缓存”和“使用数组”的代码行，我们可以看到，在老版本的V8中，charCodeAt 表现的差很多，因此将只是将字符串转换为“Uint8Array”来加快访问速度就可以带来效果。然而，在新版本的 V8 中，只是在解析内部进行这种转换的话，并不能带来任何效果。

但是，如果您可以不通过转换，就能直接使用数组而不是字符串，那么就会带来性能的提升。 这是为什么呢？ 为了解答这个问题，我在 V8 运行以下代码：

```[]
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

```[]
╭─ ~/src/v8/v8 ‹master›
╰─$ out.gn/x64.release/d8 --allow-natives-syntax --print-opt-code --code-comments x.js
```

这个命令产生了一个[巨大的程序集列表](https://gist.github.com/mraleph/a1f36a67676a8dfef0af081f27f3eb6a)，这个证实我的怀疑，V8 的 “charCodeAt” 仍然没有针对特定的字符串表示进行特殊处理。这种降低似乎源自 V8 中的[这个代码](https://github.com/v8/v8/v8/blob/de7a3174282a48fab9c167155ffc8ff20c37214d/src/compiler/effect-control-linearizer.cc#L2687-L2826)，它可以解释什么数组访问速度快于字符串的`charCodeAt`的奥秘。

## 解析改进

基于这些发现，我们可以从`source-map`解析代码中删除被解析分段的缓存，再测试影响效果。

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-1.png)

就像我们的微基准测试预测的那样，缓存对整体性能是不利的：删除它可以大大提升解析时间。

## 优化排序 - 算法改进

现在我们改进了解析性能，让我们再看一下排序。

有两个正在排序的数组：

1. `originalMappings`数组使用`compareByOriginalPositions` 比较器进行排序;
2. `generatedMappings`数组使用`compareByGeneratedPositionsDeflated` 比较器进行排序.

### 优化 `originalMappings` 排序

我首先看了一下`compareByOriginalPositions`。

```[]
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

我注意到，映射首先由`source`组件进行排序，然后再由所有其他组件排序。 `source`指定映射最先来自哪个源文件。 一个显而易见的想法是，我们可以将`originalMappings`变成数组的集合：`originalMappings [i]`是包含第i个源文件所有映射的数组，而不再使用巨大的`originalMappings`数组直接将来自不同源文件的映射混合在一起。通过这种方式，我们可以把从源文件解析出来的映射排序存到不同的`originalMappings [i]`数组中，然后对单个较小的数组再进行排序。

实际上是个[桶排序]（https://en.wikipedia.org/wiki/Bucket_sort）

这是我们在解析循环中做的：

```[]
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

在那之后：

```[]
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

“compareByOriginalPositionsNoSource”比较器几乎与“compareByOriginalPositions”比较器完全相同，只是它不再比较“source”组件 - 针对我们构造`originalMappings [i]`数组的方式，这样可以保证是公平的。

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-2.png)

这个算法改进可提升 V8 和 SpiderMonkey 上的排序速度，从而进一步改进 V8 上的解析速度。

解析速度的提高是由于处理`originalMappings`数组的消耗的降低：生成一个单一的巨大的`originalMappings`数组比生成多个但更小的`originalMappings [i]`数组要消耗更多。不过，这只是我的猜测，没有经过任何严格的分析。

### 优化 `generatedMappings` 排序

让我们看一下`generatedMappings`和`compareByGeneratedPositionsDeflated`比较器。

```[]
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

这里我们首先比较`generatedLine`的映射。一般生成的行可能比原始源文件多得多，因此将`generatedMappings`分成多个单独的数组是没有意义的。

但是，当我看到解析代码时，我注意到了以下的内容：

```[]
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

这是代码中唯一出现`generatedLine`的地方，这意味着`generatedLine`是单调增长的 — 意味着`generatedMappings`数组已经被`generatedLine`排序了，并且对整个数组排序没有意义。相反，我们可以对每个较小的子数组进行排序。我们把代码改成下面这样：

```[]
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

我没有使用`快速排序`排序子数组，而是决定使用[插入排序](https://en.wikipedia.org/wiki/Insertion_sort)，类似于一些 VM 用于 Array.prototype.sort  的混合策略。

注意：如果输入数组已经排序，插入排序会比快速排序更快...事实证明，用于基准测试的映射实际上是排序过的。如果我们期望`generatedMappings`在解析之后几乎都是被排序过的，那么在排序之前先简单地检查`generatedMappings`是否已经排序会更有效率。

```[]
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

这产生以下结果：

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-3.png)

排序时间急剧下降，而解析时间稍微增加 — 这是因为代码将`generatedMappings`作为解析循环的一部分进行排序，使得我们的分解略显无意义。让我们检查累计时间的比较（解析和排序）

#### 改善总时间

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-3-total.png)

现在很明显，我们大大提高了整体映射解析性能。

我们还可以做些什么来改善性能吗？

是的：我们可以从 asm.js/WASM 指南中抽出一页，而不用在 JavaScript 基础上全部使用 Rust。

### 优化解析 - 降低 GC 压力

我们正在分配成千上万的`Mapping`对象，这给GC带来了相当大的压力 - 然而我们并不是真的需要这样的对象 - 我们可以将它们打包成一个类型数组。这是我的做法。

几年前，我对 [Typed Objects](https://github.com/nikomatsakis/typed-objects-explainer) 提案感到非常兴奋，该提案将允许 JavaScript 程序员定义结构体和结构体数组以及所有其他令人惊喜的东西，这样很方便。但不幸的是，推动该提案的领导者离开去做其他方面的工作，这让我们要么手动，要么使用C ++来编写这些东西。

首先，我将 Mapping 从一个普通对象变成一个只想类型数组的一个包装器，它将包含我们所有的映射。

```[]
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

然后我调整了解析和排序代码，如下所示：

```[]
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

正如你所看到的，可读性确实受到了很大影响。理想情况下，我希望在需要处理对应分段时分配临时的“映射”对象。然而，这种代码风格将严重依赖于虚拟机通过_allocation sinking_，_scalar replacement_或其他类似的优化来消除这些临时包装的分配的能力。不幸的是，在我的实验中，SpiderMonkey无法很好地处理这样的代码，因此我选择了更多冗长且容易出错的代码。

这种几乎纯手动进行内存管理的方式在 JS 中是不多见的。这就是为什么我认为在这里值得提出，“氧化源图”实际上[需要用户手动管理](https://github.com/mozilla/source-map#sourcemapconsumerprototypedestroy)它的生命周期，以确保 WASM 资源被释放。

重新运行基准测试，证明缓解 GC 压力产生了很好的改善效果

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-4.png)

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-4-total.png)

有趣的是，在 SpiderMonkey 上，这种方法对于解析和排序都有改善效果，这对我来说真是一个惊喜。

#### SpiderMonkey 性能断崖

当我使用这段代码时，我还发现了 SpiderMonkey 中令人困惑的性能断崖现象：当我将预置内存缓冲区的大小从 4MB 增加到 64MB 来衡量重新分配的消耗时，基准测试显示当进行第7次迭代后性能突然下降了。

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-5-total.png)

这看起来像某种多态性，但我不能立即就搞清楚如何改变数组的大小可以导致多态行为。

我很困惑，但我找到了一个 SpiderMonkey 黑客 [Jan de Mooij](https://twitter.com/jandemooij)，他很快[识别出](https://bugzilla.mozilla.org/show_bug.cgi?id=1437471) 罪魁祸首是 asm.js 从 2012 年开始的相关优化......然后他将它从 SpiderMonkey 中删除，以免再次碰到这个令人迷惑的性能断崖。

### 优化分析 - 使用 `Uint8Array` 替代字符串。

最后，如果我们使用`Uint8Array`代替字符串来解析，我们又可以得到小的改善效果。

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-6-total.png)

假设我们重写 source-map，直接从类型数组映射而不是利用 JavaScript 的字符串方法 JSON.decode，那么还能得到一些性能提升。

### 对基线的总体改进

这是开始的情况：

```[]
$ d8 bench-shell-bindings.js
...
[Stats samples: 5, total: 24050 ms, mean: 4810 m
s, stddev: 155.91063145276527 ms]
$ sm bench-shell-bindings.js
...
[Stats samples: 7, total: 22925 ms, mean: 3275 ms, stddev: 269.5999093306804 ms]
```

这是我们完成时的情况

```[]
$ d8 bench-shell-bindings.js
...
[Stats samples: 22, total: 25158 ms, mean: 1143.5454545454545 ms, stddev: 16.59358125226469 ms]
$ sm bench-shell-bindings.js
...
[Stats samples: 31, total: 25247 ms, mean: 814.4193548387096 ms, stddev: 5.591064299397745 ms]
```

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-final.png)

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-final-total.png)

这是4倍的性能提升！

也许值得注意的是，尽管这并不是必须的，但我们仍然对所有的`originalMappings`数组进行了排序。 只有两个操作使用到`originalMappings`：

* `allGeneratedPositionsFor` 它返回给定线的所有生成位置;
* `eachMapping(..., ORIGINAL_ORDER)` 它按照原始顺序对所有映射进行迭代.

如果我们假设`allGeneratedPositionsFor`是最常见的操作，并且我们只在少数`originalMappings [i]`数组中搜索，那么无论何时我们需要搜索其中的一个，我们都可以通过对`originalMappings [i]`数组进行排序来大大提高解析时间。

最后比较从 1 月 19 日的 V8 和 2 月 19 日的 V8 包含和不包含[减少不可信代码]（https://github.com/v8/v8/wiki/Untrusted-code-mitigations）。

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-v8-vs-v8-total.png)

### 比较 Oxidized`source-map`版本

继 2 月 19 日发布这篇文章之后，我收到一些反馈要求将我改进的`source-map`与使用 Rust 和 WASM 的主线的 Oxidized`source-map`相比较。

快速查看 [`parse_mappings`](https://github.com/fitzgen/source-map-mappings/blob/master/src/lib.rs#L499-L566) 的 Rust 源代码，发现 Rust 版本没有排序原始映射，只会生成等价的`generatedMappings`并且排序。为了匹配这种行为，我通过注释掉`originalMappings [i]`数组的排序来调整我的JS版本。

这里是仅仅是解析的对比结果（其中还包括对`generatedMappings`进行排序），然后对所有`generatedMappings`进行解析和迭代。

![只有解析时间](https://mrale.ph/images/2018-02-03/parse-only-rust-wasm-vs-js.png)

![解析和迭代次数](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js.png)

**请注意，这个对比有点误导，因为 Rust 版本并未像我的 JS 版本那样优化`generatedMappings`的排序。**

因此，我不会在这里宣布，“我们已经成功达到 Rust+WASM 版本的水平”。但是，在这种程度的性能差异情况下，我们可能需要重新评估在`source-map`中使用如此复杂的 Rust 是否是值得的。

#### 更新（2018 年 2 月 27 日）

`source-map`的作者 Nick Fitzgerald 把本文描述的算法[已更新](http://fitzgeraldnick.com/2018/02/26/speed-without-wizardry.html)到 Rust+WASM 的版本。以下是解析和迭代的对比性能图表：

![解析和迭代次数](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js-2.png)

正如你可以看到 WASM+Rust 版本在 SpiderMonkey 上的速度现在增加了大约 15％，而在 V8 上的速度也大致相同。

### 学习

#### 对于JavaScript开发人员

##### 分析器是你的朋友

以各种形式进行分析和性能跟踪是获得高性能的最佳方式。它允许您在代码中放置热点，来揭示运行时的潜在问题。基于这个原因，不要回避使用像 perf 这样的低级分析工具 - “友好”的工具可能不会告诉你整个状况，因为它们隐藏了低级别的分析。

不同的性能问题需要不同的方法去分析并可视化地去收集分析结果。确保您熟悉各种可用的工具。

##### 算法很重要

能够根据抽象复杂性来推理你的代码是一项重要的技能。快速排序一个具有十万个元素的数组好呢？还是快速排序3333个数组，每个子数组有30元素更好呢？

数学计算可以告诉我们（（100000 log 100000）比（3333 倍的 30 log 30）大3倍）- 如果数据量越大，通常能够进行些数学变换就越重要。

除了了解对数之外，你需要知道一些常识，并且能够评估你的代码在平均和最糟糕的情况下的使用情况：哪些操作很常见，昂贵的运算成本如何摊销，昂贵的运算摊销带来的坏处是什么？

##### 虚拟机也在工作。问题开发者！

不要犹豫，与开发人员讨论奇怪的性能问题。并非所有事情都可以通过改变自己的代码来解决。俄国谚语说道：“制作罐子的不是上帝！”虚拟机开发人员也是人，他们也一样会犯错误。只要把问题理清，他们也相当擅长把这些问题修复。一封邮件或聊天消息或 DM 可能为您节省通过外部 C++ 代码进行挖掘的时间。

##### 虚拟机仍然需要一点帮助

有时候您也需要编写一些底层代码或者了解一些底层的实现细节，这样有助于榨取 JavaScript 的最后一丝性能。

人们可能更喜欢更好的语言水平的设施来实现这一点，但是我们能不能实现，仍有待观察。

#### 对于语言实现者/设计者

##### 巧妙的优化必须是可诊断的

如果您的运行时具有任何内置的智能优化，那么您需要提供一个直观的工具来诊断这些优化失败的时间并向开发人员提供可操作的反馈。

在 JavaScript 这样的语言环境中，至少有像 profiler 这样的分析工具为您单个操作提供一种专业化方法来检测，以确定虚拟机优化的结果是好是坏并且指出原因。

这种排序的自检工具不能依赖于在虚拟机的某个版本上打上特殊的补丁，然后输出一堆毫无可读性的调试输出。相反，它应该是任何你需要的时候，只要打开调试工具窗口，它就把结果呈现出来。

##### 语言和优化必须是朋友

最后，作为一名语言设计师，您应该尝试预测语言缺乏哪些特性，从而更容易编写性能良好的代码。市场上的用户是否需要手动设置和管理内存？我确定他们是。如果大多数人使用了您的语言最后都写出大量性能很低的代码。那只能通过添加大量的语言特性或者通过其他途径来提升代码的性能（例如，通过更复杂的优化或请求用户用 Rust 重构代码）

以下是一些语言设计的通用法则：如果要为您的语言添加新特性，请确保运算过程的合理性，而且这些特性很容易理解和检测。从整个语言层面去考虑优化工作，而不是对一些使用频率很低、性能相对较差的非核心特性去做优化工作。

### 后记

我们在这篇文章中发现的优化大致分成三个部分：

1. 算法改进;
2. 如何优化完全独立的代码和有潜在依赖关系的代码；
3. 针对 V8 的优化方法。

无论您使用哪种编程语言，都需要考虑到算法性能entire。当您在本身就“比较慢”的编程语言中使用糟糕的算法时，您能更容易的注意到这一点，但是如果只是换成使用“比较快”的编程语言，还继续使用相同的算法，症状会有所缓解，但依然解决不了问题。这篇文章中的很大一部分内容都致力于这个部分的优化：

* 对子数组排序优化效果要优于对整个数组进行排序优化;
* 讨论使用或者不使用缓存的优缺点。

第二部分是单态化。由于多态性而导致的性能降低不是 V8 特有的问题。这也不是一个 JS 特有的问题。您可以通过不同的实现方式，甚至跨语言的去应用单态。有些语言（Rust，实际上）已经在引擎内为您实现。

最后一个也是最有争议的部分是参数适配问题。

最后，使用映射表示法进行的优化（将单个对象封装到单个类型数组中）横跨了文中提及的三个部分。这是建立在对 GCed 系统的局限性和性能花销，以及 JS 虚拟机作了哪些特殊优化的基础上进行的。

所以... 为什么我选择了这个标题？ 这是因为我坚信第三部分涉及的问题都会随着时间的推移而被修复。其他部分可通过常用编程语言进行跨语言实现。

很显然，每个开发人员和每个团队都可以自由的去选择，到底是花费 N 小时去分析，阅读和思考他们的 JavaScript 代码，还是花费 `M` 小时用 `X` 语言重写他们的东西。

但是：（a）每个人都需要充分意识到这种选择是存在的;（b）语言设计者和实现者应该共同努力使这样的选择越来越不明显 - 也就是说在语言特征和工具方面开展工作，减少“第3部分”优化的需求。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
