> * 原文地址：[GET READY: A NEW V8 IS COMING, NODE.JS PERFORMANCE IS CHANGING.](https://medium.com/the-node-js-collection/get-ready-a-new-v8-is-coming-node-js-performance-is-changing-46a63d6da4de)
> * 原文作者：[Node.js Foundation](https://medium.com/@nodejs?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/get-ready-a-new-v8-is-coming-node-js-performance-is-changing.md](https://github.com/xitu/gold-miner/blob/master/TODO/get-ready-a-new-v8-is-coming-node-js-performance-is-changing.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[ClarenceC](https://github.com/ClarenceC)、[moods445](https://github.com/moods445)

# 做好准备：新的 V8 即将到来，Node.js 的性能正在改变。

本文由 [David Mark Clements](https://twitter.com/davidmarkclem) 和 [Matteo Collina](https://twitter.com/matteocollina) 共同撰写，负责校对的是来自 V8 团队的 [Franziska Hinkelmann](https://twitter.com/fhinkel) 和 [Benedikt Meurer](https://twitter.com/bmeurer)。起初，这个故事被发表在 [nearForm 的 blog 板块](https://www.nearform.com/blog/node-js-is-getting-a-new-v8-with-turbofan/)。在 7 月 27 日文章发布以来就做了一些修改，文章中对这些修改有所提及。

**更新：Node.js 8.3.0 将会和** [**Turbofan 一起发布在 V8 6.0 中**](https://github.com/nodejs/node/pull/14594) 。**用** `NVM_NODEJS_ORG_MIRROR=https://nodejs.org/download/rc nvm i 8.3.0-rc.0` **来验证应用程序**

自诞生之日起，node.js 就依赖于 V8 JavaScript 引擎来为我们熟悉和喜爱的语言提供代码执行环境。V8 JavaScipt 引擎是 Google 为 Chrome 浏览器编写的 JavaScipt VM。起初，V8 的主要目标是使 JavaScript 更快，至少要比同类竞争产品要快。对于一种高度动态的弱类型语言来说，这可不是容易的事情。文章将介绍 V8 和 JS 引擎的性能演变。

允许 V8 引擎高速运行 JavaScript 的是其中一个核心部分：JIT(Just In Time) 编译器。这是一个可以在运行时优化代码的动态编译器。V8 第一次创建 JIT 编译器的时候, 它被称为 FullCodegen。之后 V8 团队实现了 Crankshaft，其中包含了许多 FullCodegen 未实现的性能优化。

**编辑：FullCodegen 是 V8 的第一个优化编译器，感谢 [_Yang Guo_](https://twitter.com/hashseed) 的报告**

作为 JavaScript 自 90 年代以来的关注者和用户，JavaScript（不管是什么引擎）中快速或者缓慢的方法似乎往往是违法直觉的，JavaScript 代码缓慢的原因也常常难以理解。

最近几年，[Matteo Collina](https://twitter.com/matteocollina) 和 [我](https://twitter.com/davidmarkclem) 致力于研究如何编写高性能 Node.js 代码。当然，这意味着我们在用 V8 JavaScript 引擎执行代码的时候，知道哪些方法是高效的，哪些方法是低效的。

现在是时候挑战所有关于性能的假设了，因为 V8 团队已经编写了一个新的 JIT 编译器：Turbofan。

从更常见的 "V8 Killers"(导致优化代码片段的 `bail-out--` 在 Turbofan 环境下失效) 开始，Matteo 和我在 Crankshaft 性能方面所得到的模糊发现，将会通过一系列微基准测试结果和对 V8 进展版本的观察来得到答案。

当然，在优化 V8 逻辑路径前，我们首先应该关注 API 设计，算法和数据结构。这些微基准测试旨在显示 JavaScript 在 Node 中执行时是如何变化的。我们可以使用这些指标来影响我们的一般代码风格，以及改进在进行常用优化之后性能提升的方法。

我们将在 V8 5.1、5.8、5.9、6.0 和 6.1 中查看微基准测试下它们的性能。

将上述每个版本都放在上下文中：V8 5.1 是 Node 6 使用的引擎，使用了 Crankshaft JIT 编译器，V8 5.8 是 Node 8.0 至 8.2 的引擎，混合使用了 Crankshaft **和** Turbofan。

目前，5.9 和 6.0 引擎将在 Node 8.3（也可能是 Node 8.4）中，而 V8 6.1 是 V8 最新版本 (在编写本报告时)，它在 node-v8 仓库 [https://github.com/nodejs/node-v8.](https://github.com/nodejs/node-v8.) 的实验分支中与 Node 集成。换句话说，V8 6.1 版本将在后继 Node 版本中使用。

让我们看下微基准测试，另一方面，我们将讨论这对未来意味着什么。所有的微基准测试都由 benchmark.js](https://www.npmjs.com/package/benchmark) 执行，绘制的值是每秒操作数，因此在图中越高越好。

###  TRY/CATCH 问题

最著名的去优化模式之一是使用 `try/catch` 块。

在这个微基准测试中，我们比较了四种情况：

*   带有 `try/catch` 的函数 (**带 try catch 的 sum**)
*   不含 `try/catch` 的函数 (**不带 try catch 的 sum**)
*   调用 `try`  块中的函数 (**sum 在 try 中**)
*   简单的函数调用, 不涉及 `try/catch`  (**sum 函数**)

**代码** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/try-catch.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/try-catch.js)

![](https://cdn-images-1.medium.com/max/800/0*lFxHAunjIiG0o7Dw.png)

我们可以看到，在 Node 6 (V8 5.1) 围绕 `try/catch` 引发性能问题是真实存在的，但是对 Node 8.0-8.2 (V8 5.8) 的性能影响要小得多。

值得注意的是，在 `try` 块内部调用函数比从 `try` 块之外调用函数慢得多 - 在 Node 6 (V8 5.1) 和 Node 8.0-8.2 (V8 5.8) 都是如此。

然而对于 Node 8.3+，在 `try` 块内调用函数的性能影响可以忽略不计。

尽管如此，不要掉以轻心。在整理性能工作报告时，Matteo 和我[发现了一个性能 bug](https://bugs.chromium.org/p/v8/issues/detail?id=6576&q=matteo%20collina&colspec=ID%20Type%20Status%20Priority%20Owner%20Summary%20HW%20OS%20Component%20Stars)，在特殊情况下 Turbofan 中可能会导致出现去优化/优化的无限循环 (被视为“killer” — 一种破坏性能的模式)。

### 从 Objects 中删除属性

多年来，`delete` 已经限制了很多希望编写出高性能 JavaScript 的人（至少是我们试图为热路径编写最优代码的地方）。

 `delete` 的问题归结于 V8 在原生 JavaScript 对象的动态性质以及（可能也是动态的）原型链的处理方式上。这使得查找在实现层面上的属性查询更加复杂。 

V8 引擎快速生成属性对象的技术是基于对象的“形状”在 c++ 层创建类。形状本质上是属性所具有的键、值（包括原型链键值）。这些被称为“隐藏类”。但是这是在运行时对对象进行优化，如果对象的类型不确定，V8 有另一种属性检索的模型：hash 表查找。hash 表的查找速度很慢。历史上， 当我们从对象中 `delete`  一个键时，后续的属性访问将是一个 hash 查找。 这是我们避免使用  `delete`  而将属性设置为  `undefined` 以防止在检查属性是否已经存在时，导致结果与值相同的问题的产生的原因。 但对于预序列化已经足够了，因为  `JSON.stringify` 输出中不包含 `undefined`  (`undefined` 不是 JSON 规范中的有效值) 。

现在，让我们看看更新 Turbofan 实现是否解决了 `delete` 问题。

在这个微基准测试中，我们比较如下三种情况：

*   在对象属性设置为  `undefined` 后，序列化对象
*   在 `delete` 对象属性后，序列化对象
*   在 `delete` 已被移出对象的最近添加的属性后，序列化对象

**代码** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/property-removal.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/property-removal.js)

![](https://cdn-images-1.medium.com/max/800/0*i8btiU7YDD57gY4g.png)

在 V8 6.0 和 6.1 (尚未在任何 Node 发行版本中使用)中，Turbofan 会创建一个删除最后一个添加到对象中的属性的快捷方式，因此会比设置 `undefined` 更快。这是好消息，因为它表明 V8 团队正努力提高 `delete` 的性能。然而，如果从对象中删除了一个不是最近添加的属性， `delete` 操作仍然会对属性访问的性能带来显著影响。因此，我们仍然不推荐使用 `delete`。

**编辑: 在之前版本的帖子中，我们得出结论 `elete` 可以也应该在未来的 Node.js 中使用。但是 [_Jakob Kummerow_](http://disq.us/p/1kvomfk) 告诉我们，我们的基准测试只触发了最后一次属性访问的情况。感谢 [_Jakob Kummerow_](http://disq.us/p/1kvomfk)!**

### 显式并且数组化 `ARGUMENTS`

普通 JavaScript 函数 (相对于没有 `arguments` 对象的箭头函数 )可用隐式 `arguments`对象的一个常见问题是它类似数组，实际上不是数组。

为了使用数组方法或大多数数组行为，`arguments` 对象的索引属性已被复制到数组中。在过去 JavaScripters 更倾向于将 **less code**和 **faster code** 相提并论。虽然这一经验规则对浏览器端代码产生了有效负载大小的好处，但可能会对在服务器端代码大小远不如执行速度重要的情况造成困扰。因此将`arguments` 对象转换为数组的一种诱人的简洁方案变得相当流行： `Array.prototype.slice.call(arguments)`。调用数组 `slice` 方法将 `arguments` 对象作为该方法的`this` 上下文传递, `slice` 方法从而将对象看做数组一样。也就是说，它将整个参数数组对象作为一个数组来分割。

然而当一个函数的隐式 `arguments` 对象从函数上下文中暴露出来（例如，当它从函数返回或者像 `Array.prototype.slice.call(arguments)`时，会传递到另一个函数时）导致性能下降。 现在是时候验证这个假设了。

下一个微基准测量了四个 V8 版本中两个相互关联的主题：`arguments` 泄露的成本和将参数复制到数组中的成本 (随后 函数作用域代替了 `arguments` 对象暴露出来).

这是我们案例的细节：

*   将 `arguments` 对象暴露给另一个函数 - 不进行数组转换 (**泄露 arguments**)
*   使用 `Array.prototype.slice` 特性复制 `arguments` 对象 (**数组的 prototype.slice arguments**)
*   使用 for 循环复制每个属性 (**for 循环复制参数**)
*   使用 EcmaScript 2015 扩展运算符将输入数组分配给引用 (**扩展运算符**)

**代码：** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/arguments.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/arguments.js)

![](https://cdn-images-1.medium.com/max/800/0*G35zRaziX-t5aNyc.png)

让我们看一下线性图形中的相同数据以强调性能特征的变化：

![](https://cdn-images-1.medium.com/max/800/0*8dlqdDK4PQcFnpc9.png)

要点如下：如果我们想要将函数输入作为一个数组处理，写在高性能代码中 (在我的经验中似乎相当普遍)，在 Node 8.3 及更高版本应该使用 spread 运算符。在 Node 8.2 及更低版本应该使用 for 循环将键从 `arguments` 复制到另一个新的(预分配) 数组中 (详情请参阅基准代码)。

在 Node 8.3+ 之后的版本中，我们不会因为将 `arguments`对象暴露给其他函数而受到惩罚， 因此我们不需要完整数组并可以以使用类似数组结构的情况下，可能会有更大的性能优势。

### 部分应用 (CURRYING) 和绑定

部分应用（或 currying）指的是我们可以在嵌套闭包作用域中捕获状态的方式。

例如：

```
function add (a, b) {
  return a + b
}
const add10 = function (n) {
  return add(10, n)
}
console.log(add10(20))
```

这里 `add` 的参数 `a` 在 `add10` 函数中数值 `10` 部分应用。

从 EcmaScript 5 开始，`bind` 方法就提供了部分应用的简洁形式：

```
function add (a, b) {
  return a + b
}
const add10 = add.bind(null, 10)
console.log(add10(20))
```

但是我们通常不用 `bind`，因为它明显比使用闭包要慢 。

这个基准测试了目标 V8 版本中 `bind` 和闭包之间的差异，并以之直接函数调用作为控件。

这是我们使用的四个案例：

*   函数调用另一个第一个参数部分应用的函数 (**curry**)
*   箭头函数 (**箭头函数**)
*   通过 `bind` 部分应用另一个函数的第一个参数创建的函数 (**bind**)。
*   直接调用一个没有任何部分应用的函数 (**直接调用**)

**代码：** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/currying.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/currying.js)

![](https://cdn-images-1.medium.com/max/800/0*diYza234QpDdYolV.png)

基准测试结果的可视化线性图清楚地说明了这些方法在 V8 或者更高版本中是如何合并的。有趣的是，使用箭头函数的部分应用比使用普通函数要快（至少在我们微基准情况下）。事实上它跟踪了直接调用的性能特性。在 V8 5.1 (Node 6) 和 5.8（Node 8.0–8.2）中 `bind` 的速度显然很慢，使用箭头函数进行部分应用是最快的选择。然而 `bind` 速度比 V8 5.9 (Node 8.3+) 提高了一个数量级，成为 6.1 (Node 后继版本) 中最快的方法( 几乎可以忽略不计) 。

使用箭头函数是克服所有版本的最快方法。后续版本中使用箭头函数的代码将偏向于使用 `bind` ，因为它比普通函数更快。但是，作为警告，我们可能需要研究更多具有不同大小的数据结构的部分应用类型来获取更全面的情况。

### 函数字符数

函数的大小，包括签名、空格、甚至注释都会影响函数是否可以被 V8 内联。是的：为你的函数添加注释可能会导致性能下降 10%。Turbofan 会改变么？让我们找出答案。

在这个基准测试中，我们看三种情况：

*   调用一个小函数 (**sum small function**)
*   一个小函数的操作在内联中执行，并加上注释。(**long all together**)
*  调用已填充注释的大函数 (**sum long function**)

**Code:** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/function-size.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/function-size.js)

![](https://cdn-images-1.medium.com/max/800/0*zqsOxnfdkDWMHYY0.png)

在 V8 5.1 (Node 6) 中，**sum small function** 和 **long all together** 是一样的。这完美阐释了内联是如何工作的。当我们调用小函数时，就好像 V8 将小函数的内容写到了调用它的地方。因此当我们实际编写函数的内容  (即使添加了额外的注释填充）时, 我们已经手动内联了这些操作，并且性能相同。在 V8 5.1 (Node 6) 中，我们可以再次发现，调用一个包含注释的函数会使其超过一定大小，从而导致执行速度变慢。

在 Node 8.0–8.2 (V8 5.8) 中，除了调用小函数的成本显著增加外，情况基本相同。这可能是由于 Crankshaft 和 Turbofan 元素混合在一起，一个函数在 Crankshaft 另一个可能 Turbofan 中导致内联功能失调。(即必须在串联内联函数的集群间跳转)。

在 5.9 及更高版本（Node 8.3+）中，由不相关字符（如空格或注释）添加的任何大小都不会影响函数性能。这是因为 Turbofan 使用函数 AST ([Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) 节点数来确定函数大小，而不是像在 Crankshaft 中那样使用字符计数。它不检查函数的字节计数，而是考虑函数的实际指令，因此 V8 5.9 (Node 8.3+)之后 **空格, 变量名字符数, 函数名和注释不再是影响函数是否内联的因素。**

值得注意的是，我们再次看到函数的整体性能下降。

这里的优点应该仍然是保持函数较小。目前我们必须避免函数内部过多的注释（甚至是空格）。而且如果您想要绝对最快的速度，手动内联（删除调用）始终是最快的方法。当然还要与以下事实保持平衡：函数不应该在大小（实际可执行代码）确定后被内联，因此将其他函数代码复制到您的代码中可能会导致性能问题。换句话说，手动内联是一种潜在方法：大多数情况下，最好让编译器来内联。

### 32BIT 整数 VS 64BIT 整数

众所周知，JavaScript 只有一种数据类型：`Number`。

但是 V8 是用 C++ 实现的，因此必须在 JavaScript 数值的底层基础类型上进行选择。

对于整数 (也就是说，当我们在 JS 中指定一个没有小数的数字时), V8 假设所有的数字都是 32 位--直到它们不是的时候。 这似乎是一个合理的选择，因为多数情况下，数字都在 2147483648–2147483647 范围之间。 如果 JavaScript (整) 数超过 2147483647，JIT 编译器必须动态地将该数字基础类型更改为 double (双精度浮点数) — 这也可能对其他优化产生潜在的影响。

以下三个基准测试案例：

*   只处理 32 位范围内的数字的函数 (**sum small**)
*   处理 32 位和 double 组合的函数 (**from small to big**)
*   只处理 double 类型数字的函数 (**all big**)

**Code:** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/numbers.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/numbers.js)

![](https://cdn-images-1.medium.com/max/800/0*cISX2jccM4yVWZcl.png)

我们可以从图中看出，无论是在 Node 6 (V8 5.1) 还是 Node 8 (V8 5.8) 甚至是 Node 的后继版本，这些观察都是正确的。使用大于 2147483647 数字（整数）的操作将导致函数运行速度在一半到三分之二之间。因此，如果您有很长的数字 ID—将他们放在字符串中。

同样值得注意的是，在 32 位范围内的数字操作在 Node 6 (V8 5.1) 和 Node 8.1 以及 8.2 (V8 5.8) 有速度增长，但是在 Node 8.3+ (V8 5.9+)中速度明显降低。然而在 Node 8.3+ (V8 5.9+)中，double 运算变得更快，这很可能是（32位）数字处理速度缓慢，而不是函数或与 `for` 循环 (在基准代码中使用)速度有关

**编辑: 感谢** [**Jakob Kummerow**](http://disq.us/p/1kvomfk) **和** [**Yang Guo**](https://twitter.com/hashseed) **已经 V8 团队对结果的准确性和精确性的更新。**

### 迭代对象

获得对象的所有值并对它们进行处理是常见的操作，而且有很多方法可以实现。让我们找出在 V8 (和 Node) 中最快的那个版本。

这个基准测试的四个案例针对所有 V8 版本：

*   在 `for`-`in` 循环中使用 `hasOwnProperty` 方法来检查是否已经获得对象值。 (**for in**)
*   使用 `Object.keys` 并使用数组的 `reduce` 方法迭代键，访问 iterator 函数中提供给的对象值 (**函数式 Object.keys**)
*   使用 `Object.keys` 并使用数组的 `reduce` 方法迭代键，访问 iterator 函数中的对象值，提供给 `reduce` 的迭代函数中对象值，以减少 iterator 是箭头函数的位置 (**函数式箭头函数 Object.keys**)
*  循环访问使用 `for` 循环从 `Object.keys` 返回的数组的每个对象值  (**for 循环 Object.keys **)

我们还为V8 5.8、5.9、 6.0 和 6.1 增加了三个额外的基准测试案例

*   使用 `Object.values` 和数组 `reduce`方法遍历值, (**函数式 Object.values**)
*  使用 `Object.values` 和数组 `reduce` 方法遍历值,其中提供给 `reduce` 的 iterator 函数是箭头函数 (**函数式箭头函数 Object.values**)
*   使用 `for` 循环遍历从 `Object.values` 中返回的数组  (**for 循环 Object.values**)

在 V8 5.1 (Node 6)中，我们不会支持这些情况，因为它不支持原生 EcmaScript 2017 `Object.values` 方法。 

**Code:** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/object-iteration.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/object-iteration.js)

![](https://cdn-images-1.medium.com/max/800/0*okwut-5U3KjXn4ab.png)

在 Node 6 (V8 5.1) 和 Node 8.0–8.2 (V8 5.8) 中，遍历对象的键然后访问值使用  `for`-`in` 是迄今为止最快的方法。4 千万 op/s 比下一个接近 `Object.keys`  的方法（大约 8 百万 op/s）快了近5倍。

在 V8 6.0 (Node 8.3) 中 `for`-`in` 发生了改变，它降低至之前版本速度的四分之三，但仍然比任何方法速度都快。

在 V8 6.1 (Node 后继版本)中，`Object.keys` 比使用`for`-`in` 的速度有所提升 -但在 V8 5.1 和 5.8 (Node 6, Node 8.0-8.2) 中，仍然不及 `for`-`in` 的速度。

Turbofan 背后的运行原理似乎是对直观的编码行为进行优化。也就是说，对开发者最符合人体工程学的情况进行优化。

使用 `Object.values` 直接获取值比使用 `Object.keys` 并访问对象值要慢。最重要的是，程序循环比函数式编程要快。因此在迭代对象时可能要做更多的工作。

此外，对那些为了提升性能而使用 `for`-`in` 却因为没有其他选择而失去大部分速度的人来说，这是一个痛苦的时刻。

### 创建对象

我们**始终**在创建对象，所以这是一个很好的测量领域。

我们要看三个案例：

*  创建对象时使用对象字面量 (**literal**) 
*  创建对象时使用 ECMAScript 2015 类 (**class**) 
*  创建对象时使用构造函数 (**constructor**) 

**Code:** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/object-creation.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/object-creation.js)

![](https://cdn-images-1.medium.com/max/800/0*ELU7jCa6FA4SOhhv.png)

在 Node 6 (V8 5.1) 中所有方法都一样。

在 Node 8.0–8.2 (V8 5.8)中，从 EcmaScript 2015 类创建实例的速度不及用对象字面量或者构造函数速度的一半。所以，你知道后要注意这一点。

在 V8 5.9 中，性能再次均衡。

然后在 V8 6.0 (可能是 Node 8.3，或者是 8.4) 和 6.1 (目前尚未发布在任何 Node 版本) 中对象创建速度 **简直疯狂**！！超过了 500 百万 op/s！令人难以置信。

![](https://cdn-images-1.medium.com/max/800/0*xvzRH5TOxggMACa0.gif)

我们可以看到由构造函数创建对象稍慢一些。因此，为了对未来友好的高性能代码，我们最好的选择是始终使用对象字面量。这很适合我们，因为我们建议从函数（而不是使用类或构造函数）返回对象字面量作为一般的最佳编码实践。

**编辑：Jakob Kummerow  在 **[_http://disq.us/p/1kvomfk_](http://disq.us/p/1kvomfk)** 中指出，Turbofan 可以在这个特定的微基准中优化对象分配。考虑这一点，我们会尽快重新进行更新。**

### 单态函数与多态函数

当我们总是将相同类型的 argument 输入到函数中（例如，我们总是传递一个字符串）时，我们就以单态形式使用该函数。一些函数被编写成多态 --  这意味着相同的参数可以作为不同的隐藏类处理 -- 所以它可能可以处理一个字符串、一个数组或一个具有特定隐藏类的对象，并相应地处理它。在某些情况下，这可以提供良好的接口，但会对性能产生负面影响。

让我们看看单态和多态在基准测试的表现。

在这里，我们研究五个案例：

*   函数同时传递对象字面量和字符串 (**多态字面量**)
*   函数同时传递构造函数实例和字符串 (**多态构造函数**)
*   函数只传递字符串 (**单态字符串**)
*   函数只传递字面量 (**单态字面量**)
*   函数只传递构造函数实例 (**带构造函数的单例对象**)

**代码：** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/polymorphic.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/polymorphic.js)

![](https://cdn-images-1.medium.com/max/800/0*eF_vt7YUPD0YFsWo.png)

图中的可视化数据表明，在所有的 V8 测试版本中单态函数性能优于多态函数。

这进一步说明了在 V8 6.1（Node 后继版本）中，单态函数和多态函数之间的性能差距会更大。不过值得注意的是，这个基于使用了一种 nightly-build 方式构建 V8 版本的 node-v8 分支的版本 -- 可能最终不会成为 V8 6.1 中的一个具体特性

如果我们正在编写的代码需要是最优的，并且函数将被多次调用，此时我们应该避免使用多态。另一方面，如果只调用一两次，比如实例化/设置函数，那么多态 API 是可以接受的。

**编辑：V8 团队已经通知我们，使用其内部可执行文件 **`_d8_`** 无法可靠地重现此特定基准测试的结果。然而，这个基准在 Node 上是可重现的。因此，应该考虑到结果和随后的分析，可能会在之后的 Node 更新中发生变化（基于 Node 和 V8 的集成中）。不过还需要进一步分析。感谢** [_Jakob Kummerow_](http://disq.us/p/1kvomfk) **指出了这一点**。

### `DEBUGGER` 关键词

最后，让我们讨论一下 `debugger` 关键词。

确保从代码中删除了 `debugger` 语句。散乱的 `debugger` 语句会破坏性能。

我们看下以下两种案例：

*   包含 `debugger` 关键词的函数 (**带有 debugger**)
*   不包含 `debugger` 关键词的函数 (**不含 debugger**)

**Code:** [https://github.com/davidmarkclements/v8-perf/blob/master/bench/debugger.js](https://github.com/davidmarkclements/v8-perf/blob/master/bench/debugger.js)

![](https://cdn-images-1.medium.com/max/800/0*mdbzBVOk1UWiDb7w.png)

是的，`debugger` 关键词的存在对于测试所有 V8 版本的性能来说都很糟糕。

在**没有 debugger** 行的那些 V8 版本中，性能显著提升。我们将在[总结](https://www.nearform.com/blog/node-js-is-getting-a-new-v8-with-turbofan/#summary)中讨论这一点。

### 真实世界的基准： LOGGER 比较

除了微基准测试，我们还可以通过使用 Node.js 最流行的日志（Matteo 和我创建的 [Pino](http://getpino.io/) 时编写的）来查看 V8 版本的整体效果。

下面的条形图表明在Node.js 6.11 (Crankshaft) 中最受欢迎的 logger 记录1万行(更低些会更好) 日志所用时间：

![](https://cdn-images-1.medium.com/max/800/0*lsRsaA4cIuC7z7y3.png)

以下是使用 V8 6.1 (Turbofan) 的相同基准：

![](https://cdn-images-1.medium.com/max/800/0*3-QHw8cgY83Cg57i.png)

虽然所有的 logger 基准测试速度都有所提高 (大约是 2 倍)，但 Winston logger 从新的 Turbofan JIT 编译器中获得了最大的好处。这似乎证明了我们在微基准测试中看到的各种方法之间的速度趋于一致：Crankshaft 中较慢的方法在 Turbofan 中明显更快，而在 Crankshaft 的快速方法在 Turbofan 中往往会稍慢。Winston 是最慢的，可能是使用了在 Crankshaft 中较慢而在 Turbofan 中更快的方法，然而 Pino 使用最快的 Crankshaft 方法进行优化。虽然在 Pino 中观察到速度有所增加，但是效果不是很明显。

### 总结

一些基准测试表明，随着 V8 6.0 和 V8 6.1中全部启用 Turbofan,在 V8 5.1, V8 5.8 和 5.9 中的缓慢情况有所加速 ，但快速情况也有所下降，这往往与缓慢情况的增速相匹配。

很大程度上是由于在 Turbofan (V8 6.0 及以上) 中进行函数调用的成本。Turbofan 的核心思想是优化常见情况并消除“V8 Killers”。这为 (Chrome) 浏览器和服务器 (Node)带来了净效益。 对于大多数情况来说，权衡出现在(至少是最初)速度下降。基准日志比较表明，Turbofan 的总体净效应即使在代码基数明显不同的情况下(例如：Winston 和 Pino) 也可以全面提高。

如果您关注 JavaScript 性能已经有一段时间了，也可以根据底层引擎改善编码方式，那么是时候放弃一些技术了。如果您专注于最佳实践，编写一般的 JavaScript，那么很好，感谢 V8 团队的不懈努力，高效性能时代即将到来。

本文的作者是 [David Mark Clements](https://twitter.com/davidmarkclem) 和 [Matteo Collina](https://twitter.com/matteocollina), 由来自 V8 团队的 [Franziska Hinkelmann](https://twitter.com/fhinkel) 和 [Benedikt Meurer](https://twitter.com/bmeurer) 校对。

* * *

本文的所有源代码和文章副本都可以在 [https://github.com/davidmarkclements/v8-perf](https://github.com/davidmarkclements/v8-perf) 上找到。

 文章的原始数据可以在[https://docs.google.com/spreadsheets/d/1mDt4jDpN_Am7uckBbnxltjROI9hSu6crf9tOa2YnSog/edit?usp=sharing](https://docs.google.com/spreadsheets/d/1mDt4jDpN_Am7uckBbnxltjROI9hSu6crf9tOa2YnSog/edit?usp=sharing)。

大多数的微基准测试是在 Macbook Pro 2016 上进行的，16 GB 2133 MHz LPDDR3 的 3.3 GHz Intel Core i7，其他的 (数字、属性已经删除) 则运行在 MacBook Pro 2014，16 GB 1600 MHz DDR3的 3 GHz Intel Core i7 。Node.js 不同版本之间的测试都是在同一台机器上进行的。我们已经非常小心地确保不受其他程序的干扰。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

