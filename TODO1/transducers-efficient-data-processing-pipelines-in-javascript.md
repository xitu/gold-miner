> * 原文地址：[Transducers: Efficient Data Processing Pipelines in JavaScript](https://medium.com/javascript-scene/transducers-efficient-data-processing-pipelines-in-javascript-7985330fe73d)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/transducers-efficient-data-processing-pipelines-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/transducers-efficient-data-processing-pipelines-in-javascript.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[ElizurHz](https://github.com/ElizurHz), [Yangfan2016](https://github.com/Yangfan2016)

# Transducers：JavaScript 中高效的数据处理 Pipeline

![Smoke Art Cubes to Smoke](https://user-gold-cdn.xitu.io/2019/1/8/1682919845dd2203?w=2000&h=910&f=jpeg&s=120724)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> 注意：这是从头开始学 JavaScript ES6+ 中的函数式编程和组合软件技术中 “撰写软件” 系列的一部分。敬请关注，我们会讲述大量关于这方面的知识！ 
> [< 上一篇](https://github.com/xitu/gold-miner/blob/master/TODO1/curry-and-function-composition.md) | [<< 从第一篇开始](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md)

在使用 transducer 之前，你首先要完全搞懂[**复合函数（function composition）**](https://juejin.im/post/5c0dd214518825444758453a)和 [**reducers**](https://github.com/xitu/gold-miner/blob/master/TODO1/reduce-composing-software.md) 是什么。

> Transduce：源于 17 世纪的科学术语（latin name 一般指学名）“transductionem”，意为“改变、转换”。它更早衍生自“transducere/traducere”，意思是“引导或者跨越、转移”。

一个 transducer 是一个可组合的高阶 reducer。以一个 reducer 作为输入，返回另外一个 reducer。

Transducers 是：

* 可组合使用的简单功能集合
* 对大型集合或者无限流有效：不管 pipeline 中的操作数量有多少，都只对单一元素进行一次枚举。
* 能够转换任何可枚举的源（例如，数组、树、流、图等...）
* 无需更换 transducer pipeline，即可用于惰性或热切求值（译者注：[求值策略](https://zh.wikipedia.org/wiki/%E6%B1%82%E5%80%BC%E7%AD%96%E7%95%A5)）。

Reducer 将多个输入 **折叠（fold）** 成单个输出，其中“折叠”可以用几乎任何产生单个输出的二进制操作替换，例如：

```js
// 求和: (1, 2) = 3  
const add = (a, c) => a + c;

// 求乘积: (2, 4) = 8  
const multiply = (a, c) => a * c;

// 字符串拼接: ('abc', '123') = 'abc123'  
const concatString = (a, c) => a + c;

// 数组拼接: ([1,2], [3,4]) = [1, 2, 3, 4]  
const concatArray = (a, c) => [...a, ...c];
```
Transducer 做了很多相同的事情，但是和普通的 reducer 不同，transducer 可以使用正常地组合函数组合。换句话说，你可以组合任意数量的 tranducer，组成一个将每个 transducer 组件串联在一起的新 transducer。

普通的 reducer 不能这样（组合）。因为它需要两个参数，只返回一个输出值。所以你不能简单地将输出连接到串联中下一个 reducer 的输入。这样会出现类型不符合的情况：

```js
f: (a, c) => a
g:          (a, c) => a
h: ???
```

Transducers 有着不同的签名：

```js
f: reducer => reducer
g:            reducer => reducer
h: reducer    =>         reducer
```

### 为什么选择 Transducer？

通常，处理数据时，将处理分解成多个独立的可组合阶段很有用。例如，从较大的集合中选择一些数据然后处理该数据非常常见。你可能会这么做：

```js
const friends = [
  { id: 1, name: 'Sting', nearMe: true },
  { id: 2, name: 'Radiohead', nearMe: true },
  { id: 3, name: 'NIN', nearMe: false },
  { id: 4, name: 'Echo', nearMe: true },
  { id: 5, name: 'Zeppelin', nearMe: false }
];

const isNearMe = ({ nearMe }) => nearMe;

const getName = ({ name }) => name;

const results = friends
  .filter(isNearMe)
  .map(getName);

console.log(results);
// => ["Sting", "Radiohead", "Echo"]
```

这对于像这样的小型列表来说很好，但是存在一些潜在的问题：

1. 这仅仅只适用于数组。对于那些来自网络订阅的潜在无限数据流，或者朋友的朋友的社交图如何处理呢？

2. 每次在数组上使用点链语法（dot chaining syntax）时，JavaScript 都会构建一个全新的中间数组，然后再转到链中的下一个操作。如果你有一个 2,000,000 名“朋友”的名单，这可能会使数据处理减慢一两个数量级。使用 transducer，你可以通过完整的 pipeline 流式传输每个朋友，而无需在它们之间建立中间集合，从而节省大量时间和内存。

3. 使用点链，你必须构建标准操作的不同实现。如 `.filter()`、`.map()`、`.reduce()`、`.concat()` 等。数组方法内置在 JavaScript 中，但是如果你想构建自定义数据类型并支持一堆标准操作而且还不需要重头进行编写，改怎么办？Transducer 可以使用任何传输数据类型：编写一次操作符，在支持 transducer 的任何地方使用它。

让我们看看 transducer。这段代码还不能工作，但是还请继续，你将能够自己构建这个 transducer pipeline 的每一部分：

```js
const friends = [  
  { id: 1, name: 'Sting', nearMe: true },  
  { id: 2, name: 'Radiohead', nearMe: true },  
  { id: 3, name: 'NIN', nearMe: false },  
  { id: 4, name: 'Echo', nearMe: true },  
  { id: 5, name: 'Zeppelin', nearMe: false }  
];

const isNearMe = ({ nearMe }) => nearMe;

const getName = ({ name }) => name;

const getFriendsNearMe = compose(  
  filter(isNearMe),  
  map(getName)  
);

const results2 = toArray(getFriendsNearMe, friends);
```

在你告诉他们开始并向他们提供一些数据进行处理之前，transducer 不会做任何事情。这就是我们为什么需要使用 `toArray()`。他提供传导过程并告诉 transducer 将结果转换成新数组。你可以告诉它转换一个流、一个 observable，或者任何你喜欢的东西，而不仅仅只是调用 `toArray()`。

Transducer 可以将数字映射（mapping）成字符串，或者将对象映射到数组，或者将数组映射成更小的数组，或者根本不做任何改变，映射 `{ x, y, z } -> { x, y, z }`。Transducer 可以过滤流中的部分信号 `{ x, y, z } -> { x, y }`，甚至可以生成新值插入到输出流中，`{ x, y, z } -> { x, xx, y, yy, z, zz }`。

我将在本节中使用“信号（signal）”和“流（stream）”等词语。请记住，当我说“流”时，我并不是指任何特定的数据类型：只是一个有零个或者多个值的序列，或者**随时间表达的值列表。**

### 背景和词源

在硬件信号处理系统中，transducer（换能器）是将一种形式的能量转换成另一种形式的装置。例如，麦克风换能器将音频波转换为电能。换句话说，它将一种信号转换成为另一种信号。同样，代码中的 transducer 将一个信号转换成另一个信号。

软件找那个使用 “transducer” 一词和数据转换的可组合 pipeline 的通用概念至少可以追溯到 20 世纪 60 年代，但是我们对于他们应该如何工作的想法已经从一种语言和上下文转变为下一种语言。在计算机科学的早期，许多软件工程师也是电气工程师。当时对计算机科学的一般研究经常涉及到硬件和软件设计。因此，将计算过程视为 “transducer” 并不是特别新颖。在早期的计算机科学文献中可能会遇到这个术语 —— 特别是在数字信号处理（DSP）和**数据流编程**的背景下。

在 20 世纪 60 年代，麻省理工学院林肯实验室的图形计算开始使用 TX-2 计算机系统，这是美国空军 SAGE 防御系统的前身。Ivan Sutherland 著名的 [Sketchpad](https://dspace.mit.edu/handle/1721.1/14979)，于 1961 年至 1962 年开发，是使用光笔进行对象原型委派和图形编程的早期例子。

Ivan 的兄弟 William Robert “Bert” Sutherland 是数据流编程的几个先驱之一。他在 Sketchpad 上构建了一个数据流编程环境。它将软件“过程”描述为操作员节点的有向图，其输出连接到其他节点的输入。他在 1966 年的论文 [“The On-Line Graphical Specification of Computer Procedures”](https://dspace.mit.edu/handle/1721.1/13474) 中写下了这段经历。在连续运行的交互式程序循环中，所有内容都表示为值的流，而不是数组和处理中的数组。每个节点在到达参数输入时处理每个值。你现在可以在[虚拟蓝图引擎 Visual Scripting Environment](https://docs.unrealengine.com/en-us/Engine/Blueprints) 或 [Native Instruments’ Reaktor](https://www.native-instruments.com/en/products/komplete/synths/reaktor-6/) 找到类似的系统，这是一种音乐家用来构建自定义音频合成器的可视化编程环境。

![ Bert Sutherland 撰写的运营商组成图](https://user-gold-cdn.xitu.io/2019/1/8/168291981b06d06c?w=800&h=707&f=png&s=63423)

Bert Sutherland 撰写的运营商组成图

据我所知，第一本在基于通用软件的流处理环境中推广 “transducer” 一词的书是 1985 年 MIT 计算机科学课程 [“Structure and Interpretation of Computer Programs”](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871/ref=as_li_ss_tl?ie=UTF8&qid=1507159222&sr=8-1&keywords=sicp&linkCode=ll1&tag=eejs-20&linkId=44b40411506b45f32abf1b70b44574d2) 的教科书（SICP）。该书由 Harold Abelson、Gerald Jay Sussman、Julie Sussman 和撰写。然而在数字信号处理中使用术语 “transducer” 早于 SICP。 

> **注**：从函数式编程的角度来看，SICP 仍然是对计算机科学出色的介绍。它仍然是这个主题中我最喜欢的书。

最近，transducer 已经重新被独立发掘。并且 **Rich Hickey**（大约 2014 年）为 Clojure 开发了一个**不同的协议**，他以精心选择基于词源的概念词而闻名。这时，我就会说他说的太棒了，因为 Clojure 的 transducer 的内在基本和 SICP 中的相同，并且他们也具有了很多共性。但是，他们**并非严格相同。**

Transducer 作为一般概念（不是 Hickey 的协议规范）来讲，对计算机科学的重要分支产生了相当大的影响，包括数据流编程、科学和媒体应用的信号处理、网络、人工智能等等。随着我们开发更好的工具和技术在我们打应用代码中阐释 transducer，它们开始帮助我们更好的理解各种软件组合，包括 Web 和 易用应用程序中的用户界面行为，并且在将来，还可以很好地帮助我们管理复杂的 AR（augmented reality），自主设备和车辆等。

为了讨论起见，当我说 “transducer” 时，我并不是指 SICP transducer，尽管如果你已经熟悉了 SICP transducer，可能听起来像是在讲述它们。我也没有**具体**提到 Clojure 的 transducer，或者已经成为 JavaScript 事实标准的 transducer 协议（由 Ramda、Transducer-JS、RxJS等支持...）。我指的是**高阶 reducer**的一般概念 —— 变幻的转换。

在我看来，transducer 协议的特定细节比 transducer 的一般原理和基本数学特性重要的多，但是如果你想在生产中使用 transducer，为了满足互操作性，我目前的建议是使用现有的库来实现 transducer 协议。

我将在这里描述的 transducer 应该是用伪代码来演示概念。它们**与 transducer 协议不兼容，不应该在生产中使用**。如果你想要学习如何使用特定库的 transducer，请参阅库文档。我这样写他们是为了引你入门，让你看看它们是如何工作的，而不是强迫你同时学习协议。

当我们完成后，你应该更好的理解 transducer，以及如何在任意的上下文中、与任意的库一起、在任何支持闭包和高阶函数的语言中使用它。

### Transducer 的音乐类比

如果你是众多既是音乐家又是软件的开发者的那群人中的一个，用音乐类比可能会很有用：你可以想到信号处理装置等传感器（如吉他失真踏板，均衡器，音量旋钮，回声，混响和音频混频器）。

要使用乐器录制歌曲，我们需要某种物理传感器（即麦克风）来讲空气中的声波转换为电线上的电流。然后我们需要将该线路连接到我们想要使用的信号处理单元。例如，为电吉他加失真，或者对音轨进行混响。最终，这些不同声音的集合必须聚合在一起，混合来想成最终记录的单个信号（或者通道集合）。

换句话说，信号流看起来可能是这样。把箭头想像成传感器之间的导线：

```
[ Source ] -> [ Mic ] -> [ Filter ] -> [ Mixer ] -> [ Recording ]
```

更一般地说，你可以这么表达：

```
[ Enumerator ]->[ Transducer ]->[ Transducer ]->[ Accumulator ]
```

如果你曾经使用过音乐制作软件，这可能会让您想起一系列的音频效果。当你考虑 transducer 时，这是一个很好的直觉。但他们还可以更广泛的应用于数字、对象、动画帧、3D 模型或者任何你可以在软件中表示的其他内容。

![](https://user-gold-cdn.xitu.io/2019/1/8/168291981ed78a6b?w=1000&h=101&f=png&s=47421)

屏幕截图：Renoise 音频效果通道。

如果你曾在数组上使用 map 方法，你可能会对某些行为有点像 transducer 的东西熟悉。例如，要将一系列数字加倍：

```js
const double = x => x * 2;  
const arr = [1, 2, 3];

const result = arr.map(double);
```

在这个示例中，数组是可枚举对象。map 方法枚举原始数组，并将其元素传递给处理阶段 `double`，它将每个元素乘以 2，然后将结果累积到一个新数组中。

你甚至可以像这样构成效果：

```js
const double = x => x * 2;  
const isEven = x => x % 2 === 0;

const arr = [1, 2, 3, 4, 5, 6];

const result = arr  
  .filter(isEven)  
  .map(double)  
;

console.log(result);  
// [4, 8, 12]
```

但是，如果你想过滤和加倍的可能是无限数字流，比如无人机的遥测数据呢？

数组不能是无限的，并且数组处理过程中的每个阶段都要求你在单个值可以流经 pipeline 的下一个阶段之前处理整个数组。同样的问题意味着使用数组方法的合成会降低性能，因为需要创建一个新数组，并且合成中的每个阶段迭代一个新的集合。

想象一下，你有两段管道，每段都代表一个应用于数据流的转换，以及一个表示流的字符串。第一个转换表示 `isEven` 过滤器，下一个转换表示 `double` 映射。为了从数组中生成单个完全变换的值，你必须首先通过第一个管道运行整个字符串，从而产生一个全新的过滤数组，**然后**才能通过 `double` 管处理单个值。当你最终将第一个值 `double`，必须等待整个数组加倍才能读取单个结果。

所以，上面的代码相当于：

```js
const double = x => x * 2;  
const isEven = x => x % 2 === 0;

const arr = [1, 2, 3, 4, 5, 6];

const tempResult = arr.filter(isEven);  
const result = tempResult.map(double);

console.log(result);  
// [4, 8, 12]
```
另一种方法是将值直接从过滤后的输出流式传输到映射转换，而无需在其间创建和迭代临时数组。将值一次一个地流过，无需在转换过程中对每个阶段迭代相同的集合，并且 transducer 可以随时发出停止信号，这意味着你不需要在集合中更深入地计算每个阶段。需要产生所需的值。

有两种方法可以做到这一点：

*   Pull：惰性求值，或者
*   Push：及早求值

Pull API 等待 consumer 请求下一个值。JavaScript 中一个很好的例子是 `Iterable`。例如生成器函数生成的对象。在通过它在返回的迭代器对象上调用 `.next()` 来请求下一个值之前，生成器函数什么事情都不做。

Push API 枚举源值并尽可能快地将它们推送到管中。对于 `array.reduce()` 调用是 push API 的一个很好的例子。`array.reduce()` 从数组中一次获取一个值并将其推送到 reducer，从而在另一端产生一个新值。对于像 array reduce 这样的热切进程，会立即对数组中的每个元素重复该过程，直到处理完整个数组。在此期间，阻止进一步的程序执行。

Transducers 不关心你是 pull 还是 push。Transducers 不了解他们所采取的数据结构。他们只需调用你传递给它们的 reducer 来积累新值。

Transducers 是高阶 reducer： Reducer 函数采用 reducer 返回新的 reducer。Rich Hickey 将 transducer 描述为过程变换，这意味着 transducer 没有简单地改变流经的值，而是改变了作用这些值的过程。

签名应该是这样的：

```js
reducer = (accumulator, current) => accumulator

transducer = reducer => reducer
```

或者，拼出来：

```js
transducer = ((accumulator, current) => accumulator) => ((accumulator, current) => accumulator)
```

一般来说，大多数 transducer 需要部分应用于某些参数来专门化它们。例如，map transducer 可能如下所示：

```js
map = transform => reducer => reducer
```

或者更具体地说：

```js
map = (a => b) => step => reducer
```

换句话说，map transducer 采用映射函数（称为变换）和 reducer（称为 `step` 函数 ），返回新的 reducer。`Step` 函数是一个 reducer，当我们生成一个新值以下一步中添加到累加器时调用。

让我们看一些不成熟的例子：

```js
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);

const map = f => step =>  
  (a, c) => step(a, f(c));

const filter = predicate => step =>  
  (a, c) => predicate(c) ? step(a, c) : a;

const isEven = n => n % 2 === 0;  
const double = n => n * 2;

const doubleEvens = compose(  
  filter(isEven),  
  map(double)  
);

const arrayConcat = (a, c) => a.concat([c]);

const xform = doubleEvens(arrayConcat);

const result = [1,2,3,4,5,6].reduce(xform, []); // [4, 8, 12]

console.log(result);
```
这包含了很多内容。让我们分解一下。`map` 将函数应用于某些上下文的值。在这种情况下，上下文是 transducer pipeline。看起来大致如下：

```js
const map = f => step =>  
  (a, c) => step(a, f(c));
```

你可以像这样使用它：

```js
const double = x => x * 2;

const doubleMap = map(double);

const step = (a, c) => console.log(c);

doubleMap(step)(0, 4);  // 8doubleMap(step)(0, 21); // 42
```

函数调用末尾的零表示 reducer 的初始值。请注意，step 函数应该是 reducer，但出于演示目的，我们可以劫持它并打开控制台。如果需要对 step 函数的使用方式进行断言，则可以在单元测试中使用相同的技巧。

当我们将它们组合在一起的时候，transducer 将会变得很有意思。让我们实现一个简化的 filter transducer：

```js
const filter = predicate => step =>  
  (a, c) => predicate(c) ? step(a, c) : a;
```

Filter 采用 predicate 函数，只传递与 predicate 匹配的值。否则，返回的 reducer 返回累加器，不变。

由于这两个函数都使用 reducer 并且返回了 reducer，因此我们可以使用简单的函数组合来组合它们：

```js
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);

const isEven = n => n % 2 === 0;  
const double = n => n * 2;

const doubleEvens = compose(  
  filter(isEven),  
  map(double)  
);
```
这也将返回一个 transducer，需要我们必须提供最后一个 step 函数，以告诉 transducer 如何累积结果：

```js
const arrayConcat = (a, c) => a.concat([c]);

const xform = doubleEvens(arrayConcat);
```
此调用结果是标准的 reducer，我们可以直接传递给任何兼容的 reduce API。第二个参数表示 reduction 的初始值。这种情况下是一个空数组：

```js
const result = [1,2,3,4,5,6].reduce(xform, []); // [4, 8, 12]
```

如果这看起来像是做了很多，请记住，已经有函数编程库提供常见的 transducer 以及诸如 `compose` 工具程序，他们处理函数组合，并将值转换为给定的空值。例如：

```js
const xform = compose(
  map(inc),
  filter(isEven)
);

into([], xform, [1, 2, 3, 4]); // [2, 4]
```

由于工具带中已经有了大多数所需的工具，因此使用 transducer 进行编程非常直观。

一些支持 transducer 的流行库包括 Ramda、RxJS 和 Mori。

### 由上至下组合 transducers

标准函数组成下的 transducer 从上到下/从左到右而非从下到上/从右到左应用。也就是说，使用正常函数组合，`compose(f, g)` 表示“在 `g` **之后**复合 `f`”。Transducer 在组成下纠缠其他 transducer。换言之，transducer 说“我要做我的事情，**然后**调用管道中下一个 transducer”，这会将执行堆栈内部转出。

想象一下，你有一沓纸，顶部的一个标有 `f`，下一个是 `g`，再下面是 `h`。对于每张纸，将纸张从纸沓的顶部取出，然后将其放到相邻的新的一沓纸的顶部。当你这样做之后，你将获得一个栈，其内容标记为 `h`，然后是 `g`，然后是 `f`。

### Transducer 规则

上面的例子不太成熟，因为他们忽略了 transducer 必须遵循的互操作性（interoperability）规则

和软件中的大部分内容一样，transducer 和转换过程需要遵循一些规则：

1. 初始化：如果没有初始的累加器值，transducer 必须调用 step 函数来产生有效的初始值进行操作。该值应该表示空状态。例如，累积数组的累加器应该在没有参数的情况下调用其 step 函数时提供空数组。

2. 提前终止：使用 transducer 的进程必须在收到 reduce 过的累加器值时检查并停止。此外，对于嵌套 reduce 的 transducer，使用其 step 函数时必须在遇到时检查并传递 reduce 过的值。

3. 完成（可选）：某些转换过程永远不会完成，但那些转换过程应调用完成函数（completion function）来产生最终值/或刷新（flush）状态，并且状态 transducer 应提供完成的操作以清除任何积累的资源和可能产生最终的资源值。

### 初始化

让我们回到 `map` 操作并确保它遵守初始化（空）法则。当然，我们不需要做任何特殊的事情，只需要使用 step 函数在 pipeline 中传递请求来创建默认值：

```js
const map = f => step => (a = step(), c) => (
  step(a, f(c))
);
```

我们关心的部分是函数签名中的 `a = step()`。如果 `a`（累加器）没有值，我们将通过链中的下一个 reducer 来生成它。最终，它将到达 pipeline 的末端，并（但愿）为我们创建有效的初始值。

记住这条规则：当没有参数调用时，reducer 的操作应该总是为 reducer 返回一个有效的初始（空）值。对于任何 reducer 函数，包括 React 或 Redux 的 Reducer，遵守此规则通常是个好主意。 

### 提前终止

可以向 pipeline 中的其他 transducer 发出信号，表明我们已经完成了 reduce，并且他们不应该期望再处理任何值。在看到 `reduced` 值时，其他 transducer 可以决定停止添加到集合，并且转换过程（由最终 `step()` 函数控制）可以决定停止枚举值。由于接收到 `reduced` 值，转换过程可以再调用一次：完成上述调用。我们可以通过特殊的 reduce 过的累加器来表示这个意图。

什么是 reduced 值？它可能像将累加器值包装在一个名为 `reduced` 的特殊类型中一样简单。可以把它想象包装盒子并用 "Express" 或 "Fragile" 这样的消息标记盒子。像这样的元数据包装器（metadata wrapper）在计算中很常见。例如：http 消息包含在名为 “request” 或 “response” 的容器中，这些容器类型提供了状态码、预期消息长度、授权参数等信息的表头...

基本上，它是一种发送多条信息的方式，其中只需要一个值。`reduced()` 类型提升的最小（非标准）示例可能如下所示：

```js
const reduced = v => ({
  get isReduced () {
    return true;
  },
  valueOf: () => v,
  toString: () => `Reduced(${ JSON.stringify(v) })`
});
```

唯一严格要求的部分是：

* 类型提升：获取类型内部值的方法（例如，这种情况下的 `reduced` 函数）
* 类型识别：一种测试值以查看它是否为 `reduced` 值的方法（例如，`isReduced` getter）
* 值提取：一种从值中取出值的方法（例如，`valueOf()`）

此处包含 `toString()` 以便于调试。它允许您在 console 中同时内省类型和值。

### 完成

> “在完成步骤中，具有刷新状态（flush state）的 transducer 应该在调用嵌套 transducer 的完成函数之前刷新状态，除非之前已经看到嵌套步骤中的 reduced 值，在这种情况下应该丢弃 pending 状态。” ~ Clojure transducer 文档

换句话说，如果在前一个函数表示已完成 reduce 后，有更多状态需要刷新，则完成函数是处理它的时间。在此阶段，你可以选择：

* 再发送一个值（刷新待处理状态）
* 丢弃 pending 状态
* 执行任何所需的状态清理

### Transducing

可以转换大量不同类型的数据，但是这个过程可以推广：

```js
// 导入标准 curry，或者使用这个魔术：
const curry = (
  f, arr = []
) => (...args) => (
  a => a.length === f.length ?
    f(...a) :
    curry(f, a)
)([...arr, ...args]);

const transduce = curry((step, initial, xform, foldable) =>
  foldable.reduce(xform(step), initial)
);
```

`transduce()` 函数采用 step 函数（transducer pipeline 的最后一步），累加器的初始值，transducer 并且可折叠。可折叠是提供 `.reduce()` 方法的任何对象。

通过定义 `transduce()`，我们可以轻松创建一个转换为数组的函数。首先，我们需要一个 reduce 数组的 reducer：

```js
const concatArray = (a, c) => a.concat([c]);
```

现在我们可以使用柯里化过的 `transduce()` 创建一个转换为数组的部分应用程序：

```js
const toArray = transduce(concatArray, []);
```

使用 `toArray()` 我们可以用一行替代两行代码，并在很多其他情况下复用它，除此之外：

```js
// 手动 transduce:
const xform = doubleEvens(arrayConcat);
const result = [1,2,3,4,5,6].reduce(xform, []);
// => [4, 8, 12]

// 自动 transduce:
const result2 = toArray(doubleEvens, [1,2,3,4,5,6]);
console.log(result2); // [4, 8, 12]
```

### Transducer 协议

到目前为止，我们一直在隐藏幕后一些细节，但现在是时候看看它们了。Transducer 并非真正的单一函数。他们由 3 种不同的函数组成。Clojure 使用函数的 arity 上的模式匹配并在它们之间切换。

在计算机科学中，函数的 arity 是函数所采用参数的数量。在 transducer 的情况下，reducer 函数有两个参数，累加器和当前值。在 Clojure 中，两者都是**可选的**，并且函数的行为会根据参数是否通过而更改。如果没有传递参数，则函数中该参数的类型是 `undefined`。

JavaScript transducer 协议处理的方式略有不同。JavaScript transducer 不是使用函数 arity，而是采用 transducer 并返回 transducer 的函数。Transducer 是一个有三种方法的对象：

* `init` 返回累加器的有效初始值（通常，只需要调用下一步 `step()`）。
* `step` 应用变换，例如，对于 `map(f)`：`step(accumulator, f(current))`。
* `result` 如果在没有新值的情况下调用 transducer，它应该处理其完成步骤（通常是 `step(a)`，除非 transducer 是有状态的）。

> **注意：** JavaScript 中的 transducer 协议分别使用 `@@transducer/init`、`@@transducer/step` 和 `@@transducer/result`。

有些库提供一个 `tranducer()` 工具程序，可以自动为你包装 transducer。

这是一个不那么不成熟的 transducer 实现：

```js
const map = f => next => transducer({
  init: () => next.init(),
  result: a => next.result(a),
  step: (a, c) => next.step(a, f(c))
});
```

默认情况下，大多数 transducer 应该将 `init()` 调用传递给 pipeline 中的下一个 transducer，因为我们不知道传输数据类型，因此我们无法为它生成有效的初始值。

此外，特殊的 `reduced` 对象使用这些属性（在 transducer 协议中也命名为 `@@transducer/<name>`）：

*   `reduced` 一个布尔值，对于 reduced 的值，该值始终为 `true`。
*   `value` reduced 的值。

### 结论

**Transducers** 是可组合的高阶 reducer，可以 reduce 任何基础数据类型。

Transducers 产生的代码比使用数组进行点链接的效率高几个数量级，并且可以处理潜在的无需数据集而无需创建中间聚合。

> **注意**：Transducers 并不是总是比内置数组方法更快。当数据集非常大（数十万个项目）或 pipeline 非常大（显著增加使用方法链所需的迭代次数）时，性能优势往往会有所提升。如果你追求性能优势，请记住简介。

再看看介绍中的例子。你应该能使用示例代码作为参考构建 `filter()`、`map()` 和 `toArray()`，并使此代码工作：

```js
const friends = [  
  { id: 1, name: 'Sting', nearMe: true },  
  { id: 2, name: 'Radiohead', nearMe: true },  
  { id: 3, name: 'NIN', nearMe: false },  
  { id: 4, name: 'Echo', nearMe: true },  
  { id: 5, name: 'Zeppelin', nearMe: false }  
];

const isNearMe = ({ nearMe }) => nearMe;

const getName = ({ name }) => name;

const getFriendsNearMe = compose(  
  filter(isNearMe),  
  map(getName)  
);

const results2 = toArray(getFriendsNearMe, friends);
```

在生产中，你可以使用 [Ramda](http://ramdajs.com/)、[RxJS](https://github.com/ReactiveX/rxjs)、[transducers-js](https://github.com/cognitect-labs/transducers-js) 或者 [Mori](https://github.com/swannodette/mori)。

所有上面的这些都与这里的示例代码略有不同，但遵循所有相同的基本原则。

一下是 Ramda 的一个例子：

```js
import {  
  compose,  
  filter,  
  map,  
  into  
} from 'ramda';

const isEven = n => n % 2 === 0;  
const double = n => n * 2;

const doubleEvens = compose(  
  filter(isEven),  
  map(double)  
);

const arr = [1, 2, 3, 4, 5, 6];

// into = (structure, transducer, data) => result  
// into transduces the data using the supplied  
// transducer into the structure passed as the  
// first argument.  
const result = into([], doubleEvens, arr);

console.log(result); // [4, 8, 12]
```

每当我们需要组个一些操作时，例如 `map`、`filter`、`chunk`、`take` 等，我会深入 transducer 以优化处理过程并保持代码的可读性和清爽。来试试吧。

### 在 EricElliottJS.com 上可以了解到更多

视频课程和函数式编程已经为  EricElliottJS.com 的网站成员准备好了。如果你还不是当中的一员，[现在就注册吧](https://ericelliottjs.com/)。

[![](https://user-gold-cdn.xitu.io/2019/1/8/16829198165fd961?w=800&h=257&f=jpeg&s=27661)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

**_Eric Elliott_ 是 [“编写 JavaScript 应用”](http://pjabook.com)（O’Reilly）以及[“跟着 Eric Elliott 学 Javascript”](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 *Adobe Systems*、*Zumba Fitness*、*The Wall Street Journal*、*ESPN* 和 *BBC* 等，也是很多机构的顶级艺术家，包括但不限于 *Usher*、*Frank Ocean* 以及 *Metallica*。**

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
