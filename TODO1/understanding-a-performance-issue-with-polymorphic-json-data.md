> * 原文地址：[Understanding a Performance Issue with “Polymorphic” JSON Data](https://medium.com/wolfram-developers/understanding-a-performance-issue-with-polymorphic-json-data-e7e4cd079be0)
> * 原文作者：[Jan Pöschko](https://medium.com/@poeschko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-a-performance-issue-with-polymorphic-json-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-a-performance-issue-with-polymorphic-json-data.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[Reaper622](https://github.com/Reaper622)、[kasheemlew](https://github.com/kasheemlew)

# 了解“多态”JSON 数据的性能问题

> 结构相同但值类型不同的对象如何对 JavaScript 性能产生惊人的影响

![照片由 [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*g6D9UP-cs6jMRzrx)

当我做一些[底层性能优化](https://medium.com/wolfram-developers/performance-through-elegant-javascript-15b98f0904de)以用于渲染 [Wolfram Cloud](https://www.wolframcloud.com/) notebook 时，我注意到一个非常奇怪的问题，就是函数会因为处理浮点数进入较慢的执行路径，即使所有传入的数据都是整数的情况下也会是这样。具体来说，**单元格计数器**被 JavaScript 引擎视为浮点数，这大大减慢了大型 notebook 的渲染速度（至少在 Chrome 里面是这样）。

我们将单元格计数器 (由 [CounterAssignments](https://reference.wolfram.com/language/ref/CounterAssignments.html) 和 [CounterIncrements](https://reference.wolfram.com/language/ref/CounterIncrements.html) 进行的定义) 表示为一个整数数组，它具有从属性名到索引的一个独立的映射。这比每组计数器存储为一个字典形式更为高效。举个例子，它并不是下面的这种格式

```js
{Title: 1, Section: 3, Input: 7}
```

而是我们会存储一个数组

```js
[1, 3, 7]
```

然后再保持一个从值到索引的独立的（全局）映射关系

```js
{Title: 0, Section: 1, Input: 2}
```

当我们渲染 notebook 时，每个单元格都保留自己当前计数器值的副本，执行自己的赋值和增量（如果有的话），并将新数组传递给下一个单元格。

我发现—-至少在有些时候--V8（也就是 Chrome 和 Node.js 的 JS 引擎）将数值数组视为它们包含的是浮点数。这会在很多操作上降低效率，因为浮点数的内存布局不如（小）整数高效。这很奇怪，因为数组里面除了 [*Smi*](https://v8.dev/blog/elements-kinds) （在正负 31 位之间的整数，也就是从 -2³⁰ 到 2³⁰-1）不包含任何其他的东西。

我找到一个解决办法，就是在从 JSON 对象读取数据之后到将他们放到计数数组之前，“强制”对所有的值进行“值 | 0”的按位运算转变成整数（即使他们已经是 JSON 数据中的整数）。然而虽然我有了这个解决办法，但是我还是不能完全理解为什么它会起作用--直到最近...

## 说明

由 [Mathias Bynens](https://twitter.com/mathias) 和 [Benedikt Meurer](https://twitter.com/bmeurer) 在 [AgentConf](https://www.agent.sh/) 的分享 [JavaScript 引擎基础：好的，坏的和丑陋的](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#1)终于点醒了我：这都是关于 JS 引擎中对象的内部实现，以及每个对象如何链接到某个**结构**。

JS 引擎会跟踪对象上定义的属性名称，然后每当添加或删除属性时，隐式使用不同的结构。相同结构的对象会在内存的相同位置有相同属性（相对于对象地址而言），允许引擎显著地加速属性的访问并减少单个对象实例的内存样板（他们不必自己维护一本完整的属性字典）。

我之前不知道的是，结构也区分了不同**类型**的属性值。特别是，具有小整数值的属性意味着与（部分时候）包含其他数值的属性不同的结构。比如在

```js
const b = {};
b.x = 2;
b.x = 0.2;
```

结构转换发生在二次赋值时，从一个具有 *Smi* 值的属性 x 转变到一个可能是任意双精度值的属性 x。之前的结构随后被“弃用”，不再继续使用。就算其他对象没有使用非 smi 的值，但是只要它的属性 x 一旦被使用就会被切换到其他状态。[这个幻灯片](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#140)对此总结的很好。

所以这正是我们使用计数器的情况：CounterAssignments 和 CounterIncrements 定义来自 JSON 值的数据就像这样

```js
{"type": "MInteger", "value": 2}
```

但是我们也会有数据像是这样

```js
{"type": "MReal", "value": 0.2}
```

在笔记本的其他部分。即使没有将 MReal 对象用于计数器，这些对象的**存在本身**导致所有 MInteger 对象也会改变它们的结构。将它们的值复制到计数器数组中然后也会导致这些数组切换到性能较低的状态。

## 检查 Node.js 中的内部类型

我们可以使用 *natives syntax* 来检查 V8 内部的内容。这是通过命令行参数 --allow-natives-syntax 来启用的。特殊函数的完整列表还没有官方文档，但是已经有[非官方列表](https://gist.github.com/totherik/3a4432f26eea1224ceeb)。而且还有一个 [v8-natives](https://github.com/NathanaelA/v8-Natives) 包可以更方便的访问。

在我们的例子中，我们可以使用 %HasSmiElements 来确定指定的数组是否具有 Smi 元素：

```js
const obj = {};
obj.value = 1;
const arr1 = [obj.value, obj.value];
console.log(`arr1 has Smi elements: ${%HasSmiElements(arr1)}`);

const otherObj = {};
otherObj.value = 1.5;

const arr2 = [obj.value, obj.value];
console.log(`arr2 has Smi elements: ${%HasSmiElements(arr2)}`);
```

运行此程序会输出下面的内容：

```bash
$ node --allow-natives-syntax inspect-types.js
arr1 has Smi elements: true
arr2 has Smi elements: false
```

在构造具有相同结构但具有浮点值的对象之后，使用原始对象（包含整数值）再次产生非 Smi 数组。

## 在独立示例上衡量其造成的影响

为了说明对性能的影响，让我们使用以下 JS 程序（counters-smi.js）：

```js
function copyAndIncrement(arr) {
  const copy = arr.slice();
  copy[0] += 1;
  return copy;
}

function main() {
  const obj = {};
  obj.value = 1;
  let arr = [];
  for (let i = 0; i < 100; ++i) {
    arr.push(obj.value);
  }
  for (let i = 0; i < 10000000; ++i) {
    arr = copyAndIncrement(arr);
  }
}

main();
```

我们首先构造一个从对象 obj 中提取的 100 个整数的数组，然后我们调用 copyAndIncrement 一千万次，它会创建一个数组的副本，然后在副本中改变一个元素，然后返回新的数组。这就是在渲染（体积很大的）notebook 时处理单个计数器时实质上发生的事。

让我们稍微改变一下程序并在开头加入如下代码（counters-float.js）：

```js
    const objThatSpoilsEverything = {};
    objThatSpoilsEverything.value = 1.5;
```

仅仅这个对象的存在本身就将导致另一个对象改变其结构并减慢根据它的值构造的数组的操作。

请注意，创建空对象后添加属性与解析 JSON 字符串具有相同的效果：

```js
    const objThatSpoilsEverything = JSON.parse('{"value": 1.5}');
```

现在比较这两个程序的执行情况：

``` bash
$ time node counters-smi.js
node counters-smi.js  0.87s user 0.11s system 103% cpu 0.951 total

$ time node counters-float.js
node counters-float.js  1.22s user 0.13s system 103% cpu 1.309 total
```

这是使用 Node v11.9.0（运行 V8 版本 7.0.276.38-node.16）。但让我们尝试一下所有的主流 JS 引擎：

![](https://cdn-images-1.medium.com/max/2000/1*DBcx2JPXO70Sw72-nPF60g.jpeg)

```bash
$ npm i -g jsvu

$ jsvu

$ v8 -v
V8 version 7.4.221

$ spidermonkey -v
JavaScript-C66.0

$ chakra -v
ch version 1.11.6.0

$ jsc
```

在 Chrome 中的 V8，在 Firefox 中的 SpiderMonkey，在 IE 和 Edge 中的 Chakra，在 Safari 中的 JavaScriptCore。

并不能理想测量整个过程的执行时间，但我们可以通过用 [multitime](https://github.com/ltratt/multitime) 关注每个示例的 100 次运行的中位数来减少异常值（按随机顺序，在两次运行之间休息 1 秒）：

```bash
$ multitime -n 100 -s 1 -b examples.bat
===> multitime results
1: v8 counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        0.767       0.014       0.738       0.765       0.812
user        0.669       0.012       0.643       0.666       0.705
sys         0.086       0.003       0.080       0.085       0.095

2: v8 counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        0.854       0.016       0.829       0.851       0.918
user        0.750       0.019       0.662       0.750       0.791
sys         0.088       0.004       0.082       0.087       0.107

3: spidermonkey counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        1.378       0.024       1.355       1.372       1.538
user        1.362       0.011       1.346       1.360       1.408
sys         0.074       0.005       0.067       0.073       0.101

4: spidermonkey counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        1.406       0.021       1.385       1.400       1.506
user        1.389       0.011       1.374       1.387       1.440
sys         0.075       0.005       0.068       0.074       0.093

5: chakra counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        2.285       0.051       2.193       2.280       2.494
user        2.359       0.044       2.291       2.354       2.560
sys         0.203       0.032       0.141       0.202       0.268

6: chakra counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        2.292       0.050       2.195       2.286       2.444
user        2.365       0.042       2.284       2.360       2.501
sys         0.207       0.031       0.141       0.209       0.277

7: jsc counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        1.042       0.031       1.009       1.034       1.218
user        1.051       0.013       1.030       1.050       1.093
sys         0.336       0.013       0.319       0.333       0.394

8: jsc counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        1.041       0.025       1.012       1.038       1.246
user        1.054       0.012       1.032       1.056       1.099
sys         0.338       0.014       0.315       0.335       0.397
```

这里有几点需要注意：

* 仅在 V8 中，两种方法之间存在着显著差异（大约 0.08 秒或 10%）。

* 在 Smi 和浮点数模式下，V8 都比其他所有的引擎更快。

* 这里独立使用的 V8 比 Node 11.9（它使用的老版本的 V8）要快得多。我猜想这主要是因为最近的 V8 版本的常规性能改进（注意 Smi 和浮点数之间的差异是如何从 0.35s 减少到 0.08s 的），但与 V8 相比，Node 的其他一些开销可能也有影响。

你可以看一下[完整的测试文件](https://gist.github.com/poeschko/7e94a825f5be4fb509ee54e27b4f18c0)。所有测试均在 2013 年末 15 英寸款 MacBook Pro 上运行，运行 macOS 10.14.3，配备 2.6 GHz i7 CPU。

## 总结

V8 中的结构转换可能会产生一些令人惊讶的性能影响。但通常您不必在实践中担心这个问题（主要是因为 V8 即使在“慢速”路径上，也可能比其他所有引擎都表现得更快）。但是在一个高性能的应用程序中，最好记住“全局”结构表的效果，因为应用程序的各个相互独立的部分也可以相互影响。

如果您正在处理不受您控制的外部 JSON 数据，您可以使用按位 OR 将值“转换”为整数，如值 | 0，这也将确保其内部表示是一个 Smi。

如果您可以直接定义 JSON 数据，那么对于具有相同底层值类型的属性仅使用相同的属性名称没准是个好主意。例如，在我们的例子中这可能更好用

```js
{"type": "MInteger", "intValue": 2}
{"type": "MReal", "realValue": 2.5}
```

而不是在不同值类型的情况下都使用同一个属性。换句话说：避免使用“多态”对象。

即使在实践中 V8 场景下对性能的影响可以忽略不计，但是更深入的了解幕后发生的事情总会很有趣。就我个人来说，当我发现我一年前做的优化**为什么**有效的时候我会感到特别开心。

有关更详细的内容，这里还有各个资料的链接：

* 幻灯片：[JavaScript engine fundamentals: the good, the bad, and the ugly](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#1)

* 视频 & 素材：[Shapes and Inline Caches](https://benediktmeurer.de/2018/06/14/javascript-engine-fundamentals-shapes-and-inline-caches/), [Optimizing Prototypes](https://benediktmeurer.de/2018/08/16/javascript-engine-fundamentals-optimizing-prototypes/)

* 分享：[Element kinds in V8](https://v8.dev/blog/elements-kinds)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
