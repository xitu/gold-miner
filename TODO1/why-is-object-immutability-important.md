> * 原文地址：[Why is object immutability important?](https://levelup.gitconnected.com/why-is-object-immutability-important-d6882929e804)
> * 原文作者：[Alex Pickering](https://medium.com/@pickeringacw)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-object-immutability-important.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-object-immutability-important.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[zhanght9527](https://github.com/zhanght9527)

# 为什么对象不变性很重要？

## 为什么要对象不变性?

为了探索不变性的重要性，我们应该先了解可变性的概念。我们需要知道可变性是什么，有什么意义，以及会造成什么影响。

在这篇文章中，我们将会使用 JavaScript 介绍可变性概念。不过其中原理是跟编程语言无关的。

![](https://cdn-images-1.medium.com/max/8544/0*2Y6wJDRrY8O8c-TB)

## 可变……是什么？

可变性呀！从本质上来说，可变性描述的是对象被声明后，是否还能被修改。就这么简单。

设想一下，声明一个变量并为其赋值。在后面的代码中，我们遇到需要在那里立刻修改此变量的值的情况。如果我们能立刻修改此变量的值，更改其状态，则认为这个对象是**可变的**。

```js
// 原始数组
const foo = [ 1, 2, 3, 4, 5 ]

// 改变原始数组
foo.push(6) // [ 1, 2, 3, 4, 5, 6 ]

// 原始对象
const bar = { becky: 'lemme' }

// 改变原始对象
bar.becky = true
```

说起数组，修改它的值和改变它值的状态实在是太容易了。而为了防止这种情况发生，我们保持一个不可变的状态，需要从原始数组上派生出新数组，并将新的内容插入其中。

对象也是一样的，需要从现有对象上派生出新对象，并将所需的改变添加到其中。

不过……

JavaScript 有基本类型的概念，即**字符串**和**数字**。基础类型被认为是不可变的。这里要理解的棘手地方是：字符串本身是不可变的，但被赋值的变量是可变的。意思是，如果我们创建了一个变量，并对其赋值字符串，接着如果对其重新赋值新的字符串，从技术上来说没有改变原始的字符串，而只是改变了变量赋值。这是一个重要的区别。

```js
// 实例化和声明变量
let foo = 'something'

// 利用现有的基础类型实例化和声明变量
let bar = foo

// 对原始变量重新赋值
foo = 'else'

// 在控制台上输出结果
console.log(foo, bar)
> 'else', 'something'
```

基础类型被不可变地创建了 —— 意思是当 `bar` 被实例化时，虽然被赋值成 `foo`，但是这个值在内存中是另外储存的。所有的基础类型都是这种情况！目的是，新的赋值不会作为指针泄露到任何其它变量中去！

## 试试不变性

可变性的反面是不变性。不变性在这里的意思是，一旦变量被声明并且状态被设置，就不能被再次修改。而基于原始的新对象，任何改变都**需要**被重新创建。

让我们看看如何不可变地插入一项内容到数组中。

```js
const foo = [ 1, 2, 3, 4, 5 ]

// 不可改变的，不修改原始的数组（ES6 扩展运算）
const bar = [ ...foo, 6 ]
const arr = [ 6, ...foo ]
```

我们现在从原始数组上创建 `bar` 和 `arr`，分别在结尾处和开头处添加想要的修改。我们在新数组中使用[扩展运算语法](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)来展开现有数组项。

如果我们有一个更复杂的数组，例如对象数组，如何修改其中每一个对象，而维持不可变的原则呢？非常简单！我们可以使用 `.map`，这是一个原生的数组方法。

```js
const foo = [{ a: 'b', c: 'd' }]

// 不可改变的，不修改原始数组
const bar = foo.map(item => ({
  ...item,
  a: 'something else'
}))
```

那对象呢？我们如何在独立对象上更新属性，而不修改原始对象？我们可以简单地使用扩展运算语法再来一次。

```js
const foo = { becky: 'lemme' }

// 不可改变的，不修改原始对象
const bar = { ...foo, smash: false }
```

原始对象 `foo` 还是保持原样，而同时也发现 —— 我们已经创建了具有我们预期变化的新对象。太棒了！

不过，让我们暂时假设一下，在无法使用 ES6 标准的情况下，如何实现不可变性呢？

```js
const foo = { becky: 'lemme' }

// 不可改变的，不修改原始对象
const bar = Object.assign({}, foo, { smash: false })
```

在上面的例子里，我们使用了为新对象赋值的古老方法。

请注意 —— 在嵌套对象的顶层使用扩展运算符不能保证嵌套在其中对象的不变性。我们可以看看下面的示例。

```js
const personA = {
  address: {
   city: 'Cape Town'
  }
}

const personB = {
  ...personA
}

const personC = {
  address: {
    ...personA.address,
  }
}

personA.address.city = 'Durban' // 这会同时修改 personA 与 personB。

console.log(personB.address.city) // 'Durban'
console.log(personC.address.city) // 'Cape Town'
```

为了确保嵌套对象保持不变，如上面示例所示，每一个嵌套对象都需要被扩展或者被赋值。

![](https://cdn-images-1.medium.com/max/10368/0*e8XYkZ1MhoFTSaNu)

## 你是在回答怎么做，但到底是为什么呢？

在大多数应用中，数据的完整性和一致性通常是最重要的。我们不愿意数据被莫名修改，因此被错误地存到数据库中，或者被错误地返回给使用者。我们期望有最佳的可预测性，以确保所使用的数据与预期保持一致。当涉及到异步和多线程应用程序时，这至关重要。

为了更好地理解以上内容，让我们看看下面的图。让我们假设 `foo` 依稀包含着我们系统中一个用户的重要数据。如果我们有 Promise A 和 Promise B，他们都同时运行在 Promise 中。这两个以及所有接收 `foo` 作为参数的 Promise，如果其中的一个 Promise 修改 `foo`，那么 `foo` 的新状态就会泄露到另一个 Promise 中去。

![上述问题的流程说明](https://cdn-images-1.medium.com/max/2000/1*9FYWNTJUvpL2b_4-kqjwWw.png)

如果 Promise 依赖于 `foo` 的原始状态，则在执行的过程中可能会产生副作用。

如果两个 Promise 都有修改 `foo` 对象的话，上图的结果可能会有不同的情况，结果取决于哪个 Promise 先执行。这被称为资源竞争 (race-condition)。当对象被传入时，被传入的只是一个指针，指向所传递的基础对象，而不是新的对象。

```js
// 初始化对象
const obj = {
  a: 'b',
  c: 'd'
}

// 在模拟的 1 秒计算后，控制台输出被传入的 `item`
const foo = item => setTimeout(() => console.log(item), 1000)

// 修改被传入的 `item`
const bar = item => item.a = 'something'

// 使用 Promise 对象同时运行这两个方法，并提供 `obj` 作为这两个方法输入参数。
Promise.all([ foo(obj), bar(obj) ])

// 预期结果
> { a: "b", c: "d" }

// 实际结果
> { a: "something", c: "d" }
```

在调试代码甚至尝试实现新功能时，这可能会引起不少麻烦。所以我建议保持不变性原则！

## 所以我应该创建新的对象吗？

简而言之，是的。无论怎样，您**不**应该直接地将旧变量简单地设置为新变量。这是会产生副作用的，并且可能不完全符合我们的预期。

```js
const foo = { a: 'b', c: 'd' }

// 这将创建一个指针，或者是浅拷贝
const bar = foo

// 这创建一个深拷贝
const bar = { ...foo }
```

在 JavaScript 中，这两者是有根本区别的，特别是涉及到如何将变量存储在内存中时。

更多技术层面的解释是：当创建 `foo` 对象时，其被储存在所谓的[堆](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e)中，并在[栈](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e)中创建指向这块内存的指针。和上面示例中第一个声明一样，当我们创建一个浅拷贝，一个新的指针会被放在[栈](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e)中，但其指向[堆](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e)中相同的内存块。

![上面示例中对象被创建在栈和堆中的简单图例](https://cdn-images-1.medium.com/max/2000/1*06XtgCM-VsMXRtBtpzf40w.png)

这意味着，如果 `foo` 被修改，那么 `bar` 也会被改变。**这是意料之外的后果**！

## 那性能怎么样呢？

好吧，在性能方面，您可能会认为与对现有对象简单地修改相比，这会是一个更繁琐的过程。是的，您是正确的。但这并不像您认为的那样糟糕。

JavaScript 使用结构共享的概念，这意味着从您的第一个对象派生出修改后的对象，其实不会产生太多的开销。考虑到这一点以及不变性带来的好处，这开始看起来是个不错的选择。下面列举一些好处……

* 线程安全（对于多线程语言）
* 易于测试与使用
* 最小故障性（Failure atomicity）
* 解耦合

最终，如果正确使用，不变性肯定会提升应用程序与开发的总体性能，即使是在某些计算任务更重的功能上。

![](https://cdn-images-1.medium.com/max/12000/0*QNgRdXP9gZPEyJSW)

## 我们还要用吗？

总之，是否要使用不变性的概念取决于您。我个人的观点呢，至少从表面上看，我认为不变性解决了很多问题，甚至是一些潜在的问题，这值得我们称赞。所以我也尝试确保我的对象始终保持不可变。

如果您想了解更多的信息，或者想开始在您的代码库中实现不变性，以下是一些资源参考，它们也许会引起您的兴趣。

[Immutable.js](https://immutable-js.github.io/immutable-js/)
[不变性的益处](https://hackernoon.com/5-benefits-of-immutable-objects-worth-considering-for-your-next-project-f98e7e85b6ac)

[MDN — 数组](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
[MDN — 对象](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)

感谢您的阅读，希望您能喜欢并学到一些东西。如果您有任何反馈，批评或建议，请随时在下面的评论部分中写下来。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
