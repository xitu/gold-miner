> * 原文地址：[Maybe you don't need Rust and WASM to speed up your JS — Part 2](https://mrale.ph/blog/2018/02/03/maybe-you-dont-need-rust-to-speed-up-your-js-2.html)
> * 原文作者：[Vyacheslav Egorov](http://mrale.ph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-2.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第二部分

**以下内容为本系列文章的第二部分，如果你还没看第一部分，请移步 [或许你并不需要 Rust 和 WASM 来提升 JS 的执行效率 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/maybe-you-dont-need-rust-to-speed-up-your-js-1.md)。**

有三种不同的方式可以解码我试过的 Base64 VLQ 段。

第一个是 `decodeCached`，它与 `source-map` 使用的默认实现方式完全相同 - 我已经在上面列出了：

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

下一个竞争者是`decodeNoCaching`。 它本质上是没有缓存的`decodeCached`。 每个段都被独立解码。我也用`Int32Array`替换`Array`作为`segment`存储。

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

最后，第三个是`decodeNoCachingNoString`，它尝试避免通过将字符串转换为utf8编码的`Uint8Array`来处理JavaScript字符串。 这个优化受到了下面的启发：JS虚拟机更有可能将阵列负载优化为单个内存访问。 由于JS VM使用的不同字符串表示的层次结构非常复杂，所以将`String.prototype.charCodeAt`优化到相同的范围更加困难。

我对比了两个版本，一个是将字符串编码为utf8的版本，另一个是使用预编码字符串的版本。用后面的这个“优化”版本，我想要评估一下，通过跳过数组⇒字符串⇒数组转化过程，可以给我们带来多少的优化提升。如果我们直接将源映射加载为数组缓冲区并直接从该缓冲区解析它，而不是先将其转换为字符串，那么种方式将是可能实现的。

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

下面是我在Chrome Dev`66.0.3343.3`（V8`6.6.189`）和 Firefox Nightly`60.0a1` 中运行我的微基准测试得到的结果(2018-02-11):

![不同的解码](https://mrale.ph/images/2018-02-03/different-decodes.png)

注意几点：

* 在 V8 和 SpiderMonkey 上，使用缓存的版本比的其他版本都要慢。随着缓存数量的增加，其性能急剧下降 - 而无缓存版本的性能不会受此影响;
* 在SpiderMonkey上，将字符串转换为类型化数组作为分析的一部分，而在V8上字符访问速度足够快 - 所以只有在可以将字符串到数组的转换移出基准（例如，你将你的数据加载到类型数组中以开始）;

我很好奇，V8团队最近有没有做了一些工作来提高charCodeAt性能 - 我记得生动地记得Crankshaft从来没有努力在一个调用站点为特定的字符串表示专门化'charCodeAt'，而是将`charCodeAt`扩展为一大块代码处理许多不同的字符串表示，使得从字符串加载字符比从加载数组加载元素慢。

我浏览了V8问题跟踪器，发现了下面几个问题：

*   [Issue 6391: StringCharCodeAt slower than Crankshaft](https://bugs.chromium.org/p/v8/issues/detail?id=6391);
*   [Issue 7092: High overhead of String.prototype.charCodeAt in typescript test](https://bugs.chromium.org/p/v8/issues/detail?id=7092);
*   [Issue 7326: Performance degradation when looping across character codes of a string](https://bugs.chromium.org/p/v8/issues/detail?id=7326);

这些问题的评论当中，有些引用了2018年1月末以后的提交，这表明正在积极地进行`charCodeAt`的性能改善。 出于好奇，我决定在 Chrome Beta 版本中重新运行我的微基准测试，并与 Chrome Dev 版本进行比较

![Different Decodes](https://mrale.ph/images/2018-02-03/different-decodes-v8s.png)

事实上，通过比较可以确认 V8 团队的所有提交都卓有成效的：`charCodeAt`的性能从“6.5.254.21”版本到“6.6.189”版本得到了很大提高。 通过对比“无缓存”和“使用数组”的代码行，我们可以看到，在老版本的V8中，charCodeAt 表现的差很多，因此将只是将字符串转换为“Uint8Array”来加快访问速度就可以带来效果。然而，在新版本的 V8 中，只是在解析内部进行这种转换的话，并不能带来任何效果。

但是，如果您可以不通过转换，就能直接使用数组而不是字符串，那么就会带来性能的提升。 这是为什么呢？ 为了解答这个问题，我在 V8 运行以下代码：

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

这个命令产生了一个[巨大的程序集列表](https://gist.github.com/mraleph/a1f36a67676a8dfef0af081f27f3eb6a)，这个证实我的怀疑，V8 的 “charCodeAt” 仍然没有针对特定的字符串表示进行特殊处理。这种降低似乎源自 V8 中的[这个代码](https://github.com/v8/v8/v8/blob/de7a3174282a48fab9c167155ffc8ff20c37214d/src/compiler/effect-control-linearizer.cc#L2687-L2826)，它可以解释什么数组访问速度快于字符串的`charCodeAt`的奥秘。

#### 解析改进

鉴于这些发现，我们可以从`source-map`解析代码中去掉缓存解析片段，再测试效果。

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-1.png)

就像我们的微基准测试预测的那样，缓存对整体性能是不利的：删除它可以大大提升解析时间。

### 优化排序 - 算法改进

现在我们改进了解析性能，让我们再看一下排序。

有两个正在排序的数组：

1.  `originalMappings`数组使用`compareByOriginalPositions` 比较器进行排序;
2.  `generatedMappings`数组使用`compareByGeneratedPositionsDeflated` 比较器进行排序.

#### 优化 `originalMappings` 排序

我首先看了一下`compareByOriginalPositions`。

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

我注意到，映射首先由`source`组件进行排序，然后再由所有其他组件排序。 `source`指定映射最初来自哪个源文件。 一个明显的想法是，我们可以将`originalMappings`变成数组的嵌套：`originalMappings [i]`是一个包含第i个源文件所有映射的数组，而不再使用巨大的`originalMappings`数组，它直接将来自不同源文件的映射混合在一起。通过这种方式，我们可以把从源文件解析出来的映射排序存到不同的`originalMappings [i]`数组中，然后对单个较小的数组在进行排序。

本质上是个[桶排序]（https://en.wikipedia.org/wiki/Bucket_sort）

这是我们在解析循环中做的：

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

在那之后：

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

“compareByOriginalPositionsNoSource”比较器几乎与“compareByOriginalPositions”比较器完全相同，只是它不再比较“source”组件 - 针对我们构造`originalMappings [i]`数组的方式，这样可以保证是公平的。

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-2.png)

这个算法改进可提升 V8 和 SpiderMonkey 上的排序速度，从而进一步改进 V8 上的解析速度。

解析速度的提高是由于处理`originalMappings`数组的消耗的降低：生成一个单一的巨大的`originalMappings`数组比生成多个但更小的`originalMappings [i]`数组要消耗更多。不过，这只是我的猜测，没有经过任何严格的分析。

#### 优化 `generatedMappings` 排序

让我们看一下`generatedMappings`和`compareByGeneratedPositionsDeflated`比较器。

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

这里我们首先比较`generatedLine`的映射。一般生成的行可能比原始源文件多得多，因此将`generatedMappings`分成多个单独的数组是没有意义的。

但是，当我看到解析代码时，我注意到了以下的内容：

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

这是代码中唯一出现`generatedLine`的地方，这意味着`generatedLine`是单调增长的 — 意味着`generatedMappings`数组已经被`generatedLine`排序了，并且对整个数组排序没有意义。相反，我们可以对每个较小的子阵列进行排序。我们把代码改成下面这样：

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

我没有使用`quickSort`排序子序列，而是决定使用[插入排序](https://en.wikipedia.org/wiki/Insertion_sort)，类似于一些VM用于Array.prototype.sort 的混合策略。

注意：如果输入数组已经排序，插入排序会比快速排序更快...事实证明，用于基准测试的映射实际上是排序过的。如果我们期望`generatedMappings`在解析之后几乎都是被排序过的，那么在排序之前先简单地检查`generatedMappings`是否已经排序会更有效率。

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

这产生以下结果：

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-3.png)

排序时间急剧下降，而解析时间稍微增加 — 这是因为代码将`generatedMappings`作为解析循环的一部分进行排序，使得我们的分解略显无意义。让我们检查累计时间的比较（解析和排序）

####改善总时间

![解析和排序时间](https://mrale.ph/images/2018-02-03/parse-sort-3-total.png)

现在很明显，我们大大提高了整体映射解析性能。

我们还可以做些什么来改善性能吗？

是的：我们可以从 asm.js/WASM 指南中抽出一页，而不用在 JavaScript 基础上全部使用 Rust。

###优化解析 - 降低GC压力

我们正在分配成千上万的`Mapping`对象，这给GC带来了相当大的压力 - 然而我们并不是真的需要这样的对象 - 我们可以将它们打包成一个类型数组。这是我的做法。

几年前，我对[Typed Objects](https://github.com/nikomatsakis/typed-objects-explainer)提案感到非常兴奋，该提案将允许 JavaScript 程序员定义结构体和结构体数组以及所有其他令人惊喜的东西，这样很方便。但不幸的是，推动该提案的领导者离开去做其他方面的工作，这让我们要么手动，要么使用C ++来编写这些东西。

首先，我将Mapping从一个普通对象变成一个只想类型数组的一个包装器，它将包含我们所有的映射。

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

然后我调整了解析和排序代码，如下所示：

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

正如你所看到的，可读性确实受到了相当的影响。理想情况下，我希望在需要处理对应字段时分配临时的“映射”对象。然而，这种代码风格将严重依赖于虚拟机通过_allocation sinking_，_scalar replacement_或其他类似的优化来消除这些临时包装的分配的能力。不幸的是，在我的实验中，SpiderMonkey无法很好地处理这样的代码，因此我选择了更多冗长且容易出错的代码。

这种几乎手动进行内存管理的方式在 JS 是相当陌生。这就是为什么我认为在这里值得提出，“氧化源图”实际上[需要用户手动管理](https://github.com/mozilla/source-map#sourcemapconsumerprototypedestroy)它的生命周期，以确保WASM资源被释放。

重新运行基准测试，证明缓解GC压力产生了很好的改善

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-4.png)

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-4-total.png)

有趣的是，在SpiderMonkey上，这种方法对于解析和排序都有改善效果，这对我来说真是一个惊喜。

#### SpiderMonkey 性能断崖

当我使用这段代码时，我还发现了SpiderMonkey中令人困惑的性能断崖：当我将预置内存缓冲区的大小从 4MB 增加到 64MB 来衡量重新分配的消耗时，基准测试显示当进行第7次迭代后性能突然下降了。

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-5-total.png)

这看起来像某种多态性，但我不能立即弄清楚如何改变数组的大小可以导致多态行为。

我很困惑，我找到了一个 SpiderMonkey 黑客 [Jan de Mooij](https://twitter.com/jandemooij)，他很快[识别出](https://bugzilla.mozilla.org/show_bug.cgi?id=1437471) 罪魁祸首是 asm.js 从 2012 年开始的相关优化......然后他将它从 SpiderMonkey 中删除，以免再次碰到这个令人迷惑的性能断崖。

###优化分析 - 使用 `Uint8Array` 替代字符串。

最后，如果我们使用`Uint8Array`代替字符串来解析，我们又可以得到小的改进。

###对基线的总体改进

这是开始的情况：
```
$ d8 bench-shell-bindings.js
...
[Stats samples: 5, total: 24050 ms, mean: 4810 m
s, stddev: 155.91063145276527 ms]
$ sm bench-shell-bindings.js
...
[Stats samples: 7, total: 22925 ms, mean: 3275 ms, stddev: 269.5999093306804 ms]
``` 

这是我们完成时的情况

```
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

可能还值得注意的是，尽管这不是真的需要，我们仍然热切地对所有`originalMappings`数组进行排序。 只有两个操作使用`originalMappings`：

*   `allGeneratedPositionsFor` which returns all generated positions for the given line in the original source;
*   `eachMapping(..., ORIGINAL_ORDER)` which iterates over all mappings in their original order.

如果我们假设`allGeneratedPositionsFor`是最常见的操作，并且我们只在少数`originalMappings [i]`数组中搜索，那么无论何时我们可以通过对`originalMappings [i]`数组进行排序来大大提高解析时间 实际上需要搜索其中的一个。

最后比较从1月19日V8从2月19日与V8没有[不可信代码缓解]（https://github.com/v8/v8/wiki/Untrusted-code-mitigations）。

![重新分配后](https://mrale.ph/images/2018-02-03/parse-sort-v8-vs-v8-total.png)

###比较氧化的`source-map`版本

继2月19日发布这篇文章之后，我几乎没有要求将源图与我使用Rust和WASM的主线氧化“源图”相比较。

快速查看[`parse_mappings`]（https://github.com/fitzgen/source-map-mappings/blob/master/src/lib.rs#L499-L566）的Rust源代码，发现Rust版本不收集或者热切排序原始映射，只会生成和排序`generatedMappings`的等价物。为了匹配这种行为，我通过注释掉`originalMappings [i]`数组的排序来调整我的JS版本。

这里是仅仅解析的基准结果（其中还包括对`generatedMappings`进行排序），然后对所有`generatedMappings`进行解析和迭代。

![只解析时间](https://mrale.ph/images/2018-02-03/parse-only-rust-wasm-vs-js.png)

![解析和迭代次数](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js.png)

**请注意，比较有点误导，因为Rust版本并未像我的JS版本那样优化`generatedMappings`的排序。**

因此，我不会在这里宣布，“我们已经成功与Rust + WASM版本达成了平衡”。然而，在这种性能差异的水平上，如果甚至值得在`source-map`中使用Rust的复杂性，那么重新评估可能是有意义的。

####更新（2018年2月27日）

`source-map`的作者Nick Fitzgerald [已更新](http://fitzgeraldnick.com/2018/02/26/speed-without-wizardry.html)本文描述的算法改进的Rust + WASM版本。 以下是_parse和iterate_ benchmark的修正性能图：

![解析和迭代次数](https://mrale.ph/images/2018-02-03/parse-iterate-rust-wasm-vs-js-2.png)

正如你可以看到 WASM+Rust 版本在 SpiderMonkey 上的速度现在增加了大约 15％，而在 V8 上的速度也大致相同。

###学习

####对于JavaScript开发人员

##### Profiler是你的朋友

以各种形状和形式进行的分析和细粒度的性能跟踪是保持性能表现的最佳方式。它允许您在代码中本地化热点，并揭示潜在的运行时问题。因为这个特殊的原因，不要回避使用像perf这样的低级分析工具 - “友好”的工具可能不会告诉你整个故事，因为它们隐藏了较低的级别。

不同的性能问题需要不同的方法来分析和可视化收集的配置文件。确保熟悉各种可用的工具。

#####算法很重要

能够根据抽象复杂性来推理你的代码是一项重要的技能。快速排序一个具有100K元素的阵列或快速排序3333 30元素的子阵列会更好吗？

一些手语数学可以指导我们（（100000 日志 100000）比（3333 日志 30 日志 30）大3倍）-数据越大，通常能够做一点数学的重要性越大。

除了了解你的对数之外，你需要拥有一定数量的常识，并且能够评估你的代码在平均和最糟糕的情况下的使用情况：哪些操作很常见，昂贵操作的成本如何摊销，昂贵的运营摊销的惩罚是什么？

##### 虚拟机正在进行中。Bug开发人员！

不要犹豫，与开发人员讨论奇怪的性能问题。并非所有事情都可以通过改变自己的代码来解决。俄国谚语说道：“制作罐子的不是上帝！”虚拟机开发人员是人，就像所有他们犯错误一样。一旦你接触到他们，他们也很擅长修复这些错误。一封邮件或聊天消息或DM可能为您节省通过外部C ++代码进行挖掘的时间。

#####虚拟机仍然需要一点帮助

有时您需要编写低级代码或了解低级别细节，以便将JavaScript中的最后一滴性能压缩。

人们可能更喜欢更好的语言水平的设施来实现这一点，但是如果我们到达那里，仍有待观察。

####对于语言实现者/设计者

#####巧妙的优化必须是可诊断的

如果您的运行时具有任何内置的智能优化，那么您需要提供一个直观的工具来诊断这些优化失败的时间并向开发人员提供可操作的反馈。

在像JavaScript这样的语言环境中，这至少意味着像分析器这样的工具也应该为您提供一种方法来检查单个操作，以确定虚拟机是否专注于它们，而不是它 - 这是什么原因。

这种内省应该不需要用魔术标志来构建虚拟机的自定义版本，然后通过兆字节的未记录调试输出进行循环。当您打开DevTools窗口时，此类工具应该就在那里。

#####语言和优化必须是朋友

最后，作为一名语言设计师，您应该尝试预测语言缺乏哪些特性，从而更容易编写性能良好的代码。市场上的用户是否需要手动布局和管理内存？我确定他们是。如果您的语言甚至是非常流行的用户最终会成功编写性能较差的代码。通过其他方式（例如，通过更复杂的优化或要求用户在Rust中重写其代码）来增加解决性能问题和解决相同性能问题的语言功能的成本。

这也适用于其他方式：如果您的语言具有功能，请确保它们执行得相当好，并且它们的性能既可以被用户理解，又可以轻松诊断。投资使您的整个语言达到最优化，而不是拥有性能良好的核心，这些核心被性能不佳的很少使用的特性的长尾巴包围。

###后记

我们在这篇文章中发现的大多数优化分为三个不同的组：

1.算法改进;
2.独立实施的解决方法，但潜在的语言依赖问题;
3.针对V8特定问题的解决方法。

无论您编写哪种语言，仍然需要考虑算法。当你在固有的“较慢”语言中使用更糟糕的算法时，更容易注意到，但只是用“更快”的语言重新实现相同的算法，即使它可能会缓解症状，也不能解决问题。很大一部分帖子致力于这个组的优化：

*通过对子序列进行排序而不是整个排列实现排序改进;
*讨论缓存好处或缺乏它们。

第二组由单态化技巧表示。由于多态性而导致的性能受损不是V8特有的问题。这不是一个JS特定的问题。您可以跨实现甚至语言应用单态。有些语言（Rust，实际上）以某种形式将它应用于引擎盖下。

最后一个也是最有争议的小组由争论适应的东西代表。

最后，我对映射表示进行的优化（将单个对象封装到单个类型数组中）是跨越所有三个组的优化。这是关于理解GCed系统整体的局限性和成本。这也是关于理解现有JS虚拟机的优势，并将其用于我们的优势。

所以... **为什么我选择了标题？**这是因为我认为第三组代表了所有应该随着时间的推移将会修复的问题。其他组代表跨越实现和语言的普遍知识。

很显然，每个开发人员和每个团队都可以自由选择花费N小时严格的时间分析，阅读和思考他们的JavaScript代码，或花费'M`小时用'X'语言重写他们的东西。

但是：（a）每个人都需要充分意识到这种选择是存在的;和（b）语言设计者和实现者应该共同努力使这个选择越来越不明显 - 这意味着在语言特征和工具方面开展工作，并且减少“第3组”优化的需求。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
 
