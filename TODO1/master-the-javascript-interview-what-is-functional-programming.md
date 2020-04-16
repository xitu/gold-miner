> * 原文地址：[Master the JavaScript Interview: What is Functional Programming?](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/master-the-javascript-interview-what-is-functional-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/master-the-javascript-interview-what-is-functional-programming.md)
> * 译者：[zoomdong](https://github.com/fireairforce)
> * 校对者：[Roc](https://github.com/QinRoc),[Long Xiong](https://github.com/xionglong58)

# 掌握 JavaScript 面试：什么是函数式编程

![Structure Synth — Orihaus (CC BY 2.0)](https://cdn-images-1.medium.com/max/3200/1*1OxglOpkZHLITbIKEVCy2g.jpeg)

> “掌握 JavaScript 面试” 是一系列的帖子，为了帮助求职者在面试中高级 JavaScript 职位时可能遇见的常见问题做准备。这些是我在真实面试场景中经常会问到的一些问题。

函数式编程已经成为 JavaScript 领域中一个非常热门的话题。就在几年前，甚至很少有 JavaScript 程序员知道什么是函数式编程，但是我在过去 3 年看到的每个大型应用程序代码库中都大量使用了函数式编程思想。

**函数式编程**（通常缩写为 FP）是通过组合**纯函数**，避免**状态共享**、**可变数据**和**副作用**来构建软件的过程。函数式编程是**声明式**的，而不是**命令式**的，应用程序状态通过纯函数流动。与面向对象编程不同，在面向对象编程中，应用程序状态通常与对象中的方法共享和协作。

函数式编程是一种**编程范式**，这意味着它是一种基于一些基本的、定义性的原则（如上所列）来思考软件构建的方法。其他编程范式包括面向对象编程和面向过程编程。

与命令式或面向对象的代码相比，函数式代码往往更简洁、更可预测、更易于测试 —— 但如果你不熟悉它以及与之相关的常见模式，函数式代码看起来也会密集得多，而且相关的文档对于新人来说可能是难以理解的。

如果你开始在 Google 上搜索函数式编程术语，你很快就会遇到一堵学术术语的墙，这对初学者来说是非常可怕的。说它有一个学习曲线是非常保守的说法。但是如果你已经使用 JavaScript 编程了一段时间，那么你很可能已经在实际的软件应用中使用了大量的函数式编程的概念和实用工具。

> 不要让所有生词吓跑你。它们比听起来容易多了。

最困难的部分是吸收（或者理解）这些词汇。在你开始理解函数式编程的含义之前，上面这个看似简单的定义中有很多需要理解的概念：

* 纯函数
* 函数组合
* 避免状态共享
* 避免可变数据
* 避免副作用

换句话说，如果你想知道函数式编程在实践中意味着什么，你必须首先理解这些核心概念。

**纯函数**指的是具有下列特征的函数：

* 给定相同的输入，总是得到相同的输出
* 没有副作用

纯函数有许多在函数式编程中很重要的属性，包括**引用透明性**（你可以使用函数一次调用的结果值代替其余对该函数的调用操作，这样并不会对程序产生影响）。阅读[“什么是纯函数？”](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)了解更多。

**组合函数**是将两个或两个以上的函数组合起来以产生一个新函数或进行某种计算的过程。例如，`f . g` 组合（. 的意思是组合）在 JavaScript 中等价于 `f(g(x))`。理解组合函数是理解如何使用函数式编程构建软件的重要一步。阅读 [“什么是组合函数？”](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-function-composition-20dfb109a1a0)了解更多。

## 状态共享

**状态共享**是指共享作用域中存在的任何变量、对象或内存空间，或者是在作用域之间传递的对象的属性。共享作用域可以包括全局作用域或闭包作用域。通常，在面向对象编程中，通过向其他对象添加属性，在作用域之间共享对象。

例如，计算机游戏可能有一个主游戏对象，其中的角色和游戏项存储为该对象所拥有的属性。函数式编程避免了状态共享，而是依赖不可变的数据结构和纯计算从现有数据中派生出新数据。有关函数式软件如何处理应用程序状态的更多详细信息，请参阅[“10个更好的 Redux 架构提示”](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44)。

共享状态的问题在于，为了了解函数的效果，你必须要了解函数使用或影响的每个共享变量的全部历史记录。

假设你有一个需要保存的 `user` 对象。`saveUser()` 函数向服务器上的 API 发出请求。在此过程中，用户使用 `updateAvatar()` 更改他们的个人头像，并触发另一个 `saveUser()` 请求。在保存时，服务器发送回一个规范的 `user` 对象，为了同步服务端或者其他客户端 API 引起的更改，该对象应该替换掉内存中对应的对象。

不幸的是，第二个响应在第一个响应之前被接收，所以当第一个（现在已经过时了）响应被返回时，新的个人头像会在内存中被删除并替换为旧的个人头像。这就是一个竞争条件的例子 —— 与状态共享相关的非常常见的错误。

与共享状态相关的另一个常见问题是，更改调用函数的顺序可能会导致一系列故障，因为作用于共享状态的函数依赖于时序：

```JavaScript
// 在共享状态下，函数调用的顺序会更改函数调用的结果。

const x = {
  val: 2
};

const x1 = () => x.val += 1;

const x2 = () => x.val *= 2;

x1();
x2();

console.log(x.val); // 6

// 这个例子和上面完全相同，除了对象名称
const y = {
  val: 2
};

const y1 = () => y.val += 1;

const y2 = () => y.val *= 2;

// 函数调用的顺序被颠倒了
y2();
y1();

// 从而改变了结果的值
console.log(y.val); // 5
```

当避免状态共享时，函数调用的时间和顺序不会更改调用函数的结果。对于纯函数，给定相同的输入，总是得到相同的输出。这使得函数调用时完全独立于其他函数调用，这可以从根本上简化更改和重构。一个函数的变化，或者函数调用的时间不会影响程序的其他部分。

```JavaScript
const x = {
  val: 2
};

const x1 = x => Object.assign({}, x, { val: x.val + 1});

const x2 = x => Object.assign({}, x, { val: x.val * 2});

console.log(x1(x2(x)).val); // 5


const y = {
  val: 2
};

// 由于不依赖于外部变量
// 我们不需要不同的函数来操作不同的变量


// 此处故意留空


// 因为函数不会发生变化
// 所以可以按任意顺序多次调用这些函数
// 而不必更改其他函数调用的结果
x2(y);
x1(y);

console.log(x1(x2(y)).val); // 5
```

在上面的例子中，我们使用 `Object.assign()` 并传入一个空对象作为第一个参数来复制 `x` 的属性，而不是在原数据上进行修改。在之前的示例中，它相当于从零开始创建一个新对象，而不使用 `object.assign()`，但这是 JavaScript 中创建现有状态副本的常见模式，而不是使用突变的常见模式，我们在第一个示例中证明了这一点。

如果仔细观察这个例子中的 `console.log()`语句，你应该会注意到我已经提到的一些东西：组合函数。回想一下前面，组合函数类似这样：`f(g(x))`。在本例中，我们将组合 `x1 . x2` 中的 `f()` 和 `g()` 替换为 `x1()` 和 `x2()`。

当然，如果你改变了组合的顺序，输出结果同样会改变。操作的顺序同样很重要。`f(g(x))` 并不总是和 `g(f(x))` 相同，但不再重要的是函数外的变量发生了什么，这很重要。对于非纯函数，除非你知道函数使用或影响的每个变量的整个历史记录，否则不可能完全理解函数的作用。

移除函数调用计时依赖项，就消除了一整类的潜在 bug。

## 不变性

**不可变**对象是指创建后不能修改的对象。相反，可变对象是在创建后可以修改的对象。

不变性是函数式编程的核心概念，因为没有它，程序中的数据流是有损的。状态历史被抛弃，奇怪的 bug 可能会潜入你的软件。更多关于不变性的意义，请参阅[“不变性之道”](https://medium.com/javascript-scene/the-dao-of-immutability-9f91a70c88cd)。

在 JavaScript 中，重要的是不要混淆 `const` 和不变性。`const` 创建一个变量名绑定，该绑定在创建后不能重新分配。`const` 不创建不可变对象。不能更改绑定所引用的对象，但仍然可以更改对象的属性，这意味着使用 `const` 创建的绑定是可变的，而不是不可变的。

不可变对象根本不能更改。通过深度冻结对象，可以使值真正不可变。JavaScript 有一种方法可以将对象冻结一层：

```JavaScript
const a = Object.freeze({
  foo: 'Hello',
  bar: 'world',
  baz: '!'
});

a.foo = 'Goodbye';
// Error: Cannot assign to read only property 'foo' of object Object

```

但是冻结的对象只是表面上不可变。例如，以下对象是可变的：

```JavaScript
const a = Object.freeze({
  foo: { greeting: 'Hello' },
  bar: 'world',
  baz: '!'
});

a.foo.greeting = 'Goodbye';

console.log(`${ a.foo.greeting }, ${ a.bar }${a.baz}`);
```

正如你所看到的，冻结对象的顶层基本属性不能改变，但是里面的任何对象属性（包括数组等）仍然可以改变 —— 所以即使是冻结的对象也不是不可变的，除非你遍历整个对象树并冻结每个对象属性。

在许多函数式编程语言中，有一种特殊的不可变的数据结构称为 **trie 数据结构**（发音同“tree”），它实际上是深度冻结的 —— 这意味着无论属性处于对象层次结构中的哪个层级，都不可以改变。

Tries 使用了**共享结构**在不可变对象被复制之后为对象共享引用内存地址，该方法使用较少的内存，并且使得在一些操作下的性能得到提升。

例如，你可以在对象对的根节点进行一致性比较来比较两个对象是否一致。如果一致的话，你就不需要再遍历整个对象树查找差异了。

JavaScript 中有几个库使用到了 tries，包括 [Immutable.js](https://github.com/facebook/immutable-js) 和 [Mori](https://github.com/swannodette/mori)。

我尝试过这两种方法，并且倾向于在需要大量不可变状态的大型项目中使用 Immutable.js。有关更多信息，请参见[“10个更好的Redux架构技巧”](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44)。

## 副作用

副作用是指任何应用程序状态的改变都是可以在被调用函数之外观察到的，除了返回值。副作用包括：

* 修改任何外部变量或对象属性（例如，全局变量或父函数作用域链中的变量）
* 打印日志到控制台
* 写入屏幕
* 写入文件
* 写入网络
* 触发任何外部过程
* 调用其它有副作用的函数

在函数式编程中，通常会避免产生副作用，这使得程序的作用更易于理解和测试。

Haskell 和其他函数语言经常使用 [**monad**](https://en.wikipedia.org/wiki/Monad_(functional_programming)) 从纯函数中分离和封装副作用。有关 monad 的话题的深度足以写一本书来讨论，所以我们以后再谈。

你现在需要知道的是，副作用操作需要与软件的其他部分隔离开来。如果你将副作用与其他的程序逻辑隔离开，你的软件将更容易扩展、重构、调试、测试和维护。

这就是大多数前端框架鼓励用户在单独的、松散耦合的模块中管理状态和组件渲染的原因。

## 通过高阶函数实现可重用性

函数式编程倾向于重用一组通用的函数式实用程序来处理数据。面向对象编程倾向于将方法和数据集中在对象中。这些协作方法只能对它们被设计用于操作的数据类型进行操作，而且通常只能对特定对象实例中包含的数据进行操作。

在函数式编程中，任何类型的数据都是平等的。同一个 `map()` api 可以映射对象、字符串、数字或任何其他数据类型，因为它以一个函数作为参数，该参数适当地处理给定的数据类型。FP 使用了**高阶函数**完成它的通用实用技巧。

JavaScript 中**函数是头等公民**，这些函数允许，它允许我们将函数作为数据 —— 将其赋给变量、传递给其他函数、从函数返回等等。

**高阶函数**是那些函数作为参数、返回值为函数或两者兼有的函数。高阶函数通常用于：

* 使用回调函数、promise、monad 等来抽象或隔离动作、效果或异步流控制。
* 创建可以作用于多种数据类型的工具程序
* 将一个函数部分地应用于它的参数，或者创建一个柯里化过的函数，以便重用或组合函数
* 获取一个函数列表，并返回这些输入函数的一些组合

#### 容器，函子，列表，和流

函子是可以映射的。换句话说，它是一个容器，它有一个接口，可用于将函数应用于其中的值。当你看到函子这个词时，你应该想到“可映射”。

前面我们了解了 `map()` 工具程序可以作用于各种数据类型。它通过提升映射操作来使用函子 API 来实现这一点。`map()` 使用的重要流控制操作利用了该接口。对于 `array.prototype.map()`，容器是一个数组，但是其他数据结构也可以是函子 —— 只要它们提供了映射 API。

让我们看看 `Array.prototype.map()` 如何允许你从映射实用程序中提取数据类型，使 `map()` 可用于任何数据类型。我们将创建一个简单的 `double()` 映射，它将传入的任何值乘以 2：

```JavaScript
const double = n => n * 2;
const doubleMap = numbers => numbers.map(double);
console.log(doubleMap([2, 3, 4])); // [ 4, 6, 8 ]
```

如果我们想要在游戏中对目标进行操作以使他们所获得的点数翻倍该怎么办？我们所要做的就是对 `double()` 函数做一些细微的修改，然后将其传递给 `map()`，这样一切仍然可以正常工作:

```JavaScript
const double = n => n.points * 2;

const doubleMap = numbers => numbers.map(double);

console.log(doubleMap([
  { name: 'ball', points: 2 },
  { name: 'coin', points: 3 },
  { name: 'candy', points: 4}
])); // [ 4, 6, 8 ]
```

为了使用通用实用函数来操作任意数量的不同数据类型，需要使用像函子和高阶函数这样的抽象，这个概念是很重要的。你将看到一个类似的概念以[各种不同的方式应用](https://github.com/fantasyland/fantasy-land)。

> # “随着时间推移表示的列表是一个流。”

现在你需要了解的是，数组和函子并不是容器和容器中的值这一概念应用的唯一方式。例如，数组只是事物的列表。随着时间的推移，一个列表是一个流，因此你可以使用相同类型的实用程序来处理传入事件的流 —— 当你开始用 FP 构建真正的软件时，你会看到很多这种情况。

## 声明式 vs 命令式

函数式编程是一种声明性的范式，这意味着程序逻辑的表达没有显式地描述流控制。

**命令式**程序花费几行代码来描述用于实现预期结果的特定步骤 —— **流控制：如何**做事情。

**声明性**程序抽象了流控制过程，花费几行代码来描述**数据流：应该做什么**。**如何**被抽象出来。

例如，这个**命令式**映射接受一个数字数组，并返回一个新数组，其中每个数字都被乘以2：

```JavaScript
const doubleMap = numbers => {  
  const doubled = [];
  for (let i = 0; i < numbers.length; i++) {
    doubled.push(numbers[i] * 2);
  }
  return doubled;
};

console.log(doubleMap([2, 3, 4])); // [4, 6, 8]
```

这个**声明式**映射也做了同样的事情，但是使用`Array.prototype.map()`函数式实用程序将流控件抽象出来，它允许你更清楚地表示数据流：

```JavaScript
const doubleMap = numbers => numbers.map(n => n * 2);

console.log(doubleMap([2, 3, 4])); // [4, 6, 8]
```

**命令式**代码经常使用语句。**语句**是执行某些操作的一段代码。常用的语句包括 `for`、`if`、`switch`、`throw` 等。

**声明式**代码更多地依赖于表达式。**表达式**是计算某个值的一段代码。表达式通常是函数调用、值和运算符的组合，它们被用于计算出结果。

下面是表达式的一些例子：

```
2 * 2
doubleMap([2, 3, 4])
Math.max(4, 3, 2)
```

通常在代码中，你会看到表达式被分配给标识符、从函数返回或传递到函数中。在被分配、返回或传递之前，表达式会先进行计算，实际使用的是其结果值。

## 总结

函数式编程倾向于：

* 纯函数而不是状态共享或副作用
* 不变性而不是可变的数据
* 组合函数而不是命令式流控制
* 大量通用的、可重用的实用程序，它们使用高阶函数来处理多种数据类型，而不是仅对位于同一位置的数据进行操作的方法
* 声明式代码而不是命令式代码（做什么而不是怎么做）
* 表达式而不是语句
* 容器和高阶函数而不是多态

## 作业

学习和练习这些函数式数组的核心功能：

* `.map()`
* `.filter()`
* `.reduce()`

#### 探索《掌握 JavaScript 面试》系列文章

* [闭包是什么？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36#.ecfskj935)
* [类和原型继承之间的区别是什么](https://medium.com/javascript-scene/master-the-javascript-interview-what-s-the-difference-between-class-prototypal-inheritance-e4cd0a7562e9#.h96dymht1)
* [纯函数是什么？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976#.4256pjcfq)
* [组合函数是什么？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-function-composition-20dfb109a1a0#.i84zm53fb)
* [函数式编程是什么？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0#.jddz30xy3)
* [Promise 是什么？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-promise-27fc71e77261#.aa7ubggsy)
* [软技能](https://medium.com/javascript-scene/master-the-javascript-interview-soft-skills-a8a5fb02c466)

> This post was included in the book “Composing Software”.**[
Buy the Book](https://leanpub.com/composingsoftware) | [Index](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc) | [\< Previous](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976) | [Next >](https://medium.com/javascript-scene/a-functional-programmers-introduction-to-javascript-composing-software-d670d14ede30)**

---

**Eric Elliott** 是一名分布式系统专家，并且是 [《组合软件》](https://leanpub.com/composingsoftware)和[《编写 JavaScript 程序》](https://ericelliottjs.com/product/programming-javascript-applications-ebook/)这两本书的作者。作为 [EricElliottJS.com](https://ericelliottjs.com) 和 [DevAnywhere.io](https://devanywhere.io/) 的联合创始人，他教开发人员远程工作和实现工作以及生活平衡所需的技能。他创建了加密项目的开发团队，并为他们提供建议。他还在软件体验上为 **Adobe 系统、Zumba Fitness、华尔街日报、ESPN、BBC** 以及包括 **Usher、Frank Ocean、Metallica** 等在内的顶级唱片艺术家做出了贡献。

**他和世界上最漂亮的女人一起享受着远程（工作）的生活方式。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
