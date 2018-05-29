> * 原文地址：[A Simple Guide to ES6 Promises](https://codeburst.io/a-simple-guide-to-es6-promises-d71bacd2e13a)
> * 原文作者：[Brandon Morelli](https://codeburst.io/@bmorelli25?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-es6-promises.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-es6-promises.md)
> * 译者：[sophia](https://github.com/sophiayang1997)
> * 校对者：

# 一个简单的 ES6 Promises 指南

> The woods are lovely, dark and deep. But I have promises to keep, and miles to go before I sleep. — Robert Frost

![](https://cdn-images-1.medium.com/max/1000/1*WlQlce8AlSpq2VnQNO9UfQ.jpeg)

Promises 是 JavaScript ES6 中最令人兴奋的新增功能之一。为了支持异步编程，JavaScript 使用回调（callbacks），[以及一些其他的技术](http://exploringjs.com/es6/ch_async.html#sec_receiving-results-asynchronously)。然而，使用回调会遇到[地狱回调](http://callbackhell.com/)/[末日金字塔](https://en.wikipedia.org/wiki/Pyramid_of_doom_%28programming%29)等问题。Promises 是一种通过使代码看起来同步并避免回调相关问题进而大大简化异步编程的模式。

在这篇文章中，我们将看到什么是 Promises，以及如何利用它们给我们带来好处。

* [**2018年Web开发者路线图**：一个提供给前端或后端开发人员的插图指南（内部提供课程链接）](https://codeburst.io/the-2018-web-developer-roadmap-826b1b806e8d)

#### 什么是 Promise？

ECMA 委员会将 promises 定义为 ——

> Promise 是一个对象，是一个用作延迟（也可能是异步）计算的最终结果的占位符。

简单来说，**一个 promise 是一个装有未来值的容器**。如果你仔细想想，这正是你正常的日常谈话中使用**承诺（promise）**这个词的方式。比如，你预定一张去印度的机票，准备前往美丽的山岗站[大吉岭](https://en.wikipedia.org/wiki/Darjeeling)旅游。预订后，你会得到一张**机票**。这张**机票**是航空公司的一个**承诺**，意味着你在出发当天可以获得相应的座位。实质上，票证是未来价值的占位符，即**座位**。

这还有另外一个例子 —— 你**答应**你的朋友，你会在看完[**计算机程序设计艺术**](https://en.wikipedia.org/wiki/The_Art_of_Computer_Programming)这本书后还给他们。在这里，你的话充当占位符。价值就相当于这本书。

你可以想想其他类似承诺（promise）的例子，这些例子涉及各种现实生活中的情况，例如在医生办公室等候，在餐厅点餐，在图书馆发放书籍等等。这些所有的情况都涉及某种形式的承诺（promise）。然而，例子只能告诉我们这么多，[屁话少说，放码过来](https://news.ycombinator.com/item?id=902216)。

#### 创建 Promises

当某个任务的完成时间不确定或太长时，我们可以创建一个 promise 。例如 —— 根据连接速度的不同，一个网络请求可能需要 10 ms 甚至需要 200 ms 这么久。我们不想等待这个数据获取的过程。对你而言，200 ms 可能看起来很少，但对于计算机来说是一段非常漫长的时间。promises 的目的就是让这种异步（asynchrony）变得简单而轻松。让我们一起来看看基础知识。

使用 **Promise** 构造函数创建了一个新的 promise。像这样 —— 

```
const myPromise = new Promise((resolve, reject) => {
    if (Math.random() * 100 <= 90) {
        resolve('Hello, Promises!');
    }
    reject(new Error('In 10% of the cases, I fail. Miserably.'));
});
```

Promise 示例

观察这个构造函数就可以发现其接收一个带有两个参数的函数，这个函数被称为**执行器**函数，并且它**描述了需要完成的计算**。执行器函数的参数通常被称为 **resolve**  和 **reject**，分别标记执行器函数的成功和不成功的最终完成结果。

`resolve` 和 `reject` 本身也是函数，它们用于将返回值返回给 promise 对象。当计算成功或未来值准备好时，我们使用 `resolve` 函数将值返回。**这时我们说这个 promise 已经被成功解决（resolve）了**。

如果计算失败或遇到错误，我们通过在 `reject` 函数中传递错误对象告知 promise 对象。 **这时我们说这个 promise 已经被拒绝（reject）了**。`reject` 可以接收任何类型的值。但是，建议传递一个 `Error` 对象，因为它可以通过查看堆栈跟踪来帮助调试。

在上面的例子中，`Math.random()` 用于生成一个随机数。有 90% 概率，这个 promise 会被成功解决（假设概率分布相同）。其余的情况则会被拒绝。

#### 使用 Promises

在上面的例子中，我们创建了一个 promise 并将其存储在 `myPromise` 中。**那我们如何才能获得通过** `resolve` **或** `reject` **函数获取传递过来的值呢**？所有的 `Promise` 都有一个 `.then()` 方法。这样问题就好解决了，让我们一起来看一下 ——

```
const myPromise = new Promise((resolve, reject) => {
    if (Math.random() * 100 < 90) {
        console.log('resolving the promise ...');
        resolve('Hello, Promises!');
    }
    reject(new Error('In 10% of the cases, I fail. Miserably.'));
});

// Two functions 
const onResolved = (resolvedValue) => console.log(resolvedValue);
const onRejected = (error) => console.log(error);

myPromise.then(onResolved, onRejected);

// Same as above, written concisely
myPromise.then((resolvedValue) => {
    console.log(resolvedValue);
}, (error) => {
    console.log(error);
});

// Output (in 90% of the cases)

// resolving the promise ...
// Hello, Promises!
// Hello, Promises!
```

使用 Promises

`.then()` 接收两个回调函数。第一个回调在 promise 被**解决**时调用。第二个回调在 promise 被**拒绝**时调用。

两个函数分别在第 10 行和第 11 行定义，即 `onResolved` 和 `onRejected`。它们作为回调传递给第 13 行中的 `.then（）`。你也可以使用第 16 行到第 20 行更常见的 `.then` 写作风格。它提供了与上述写法相同的功能。

在上面的例子中还有一些需要注意的**重要**事项。

我们创建了一个 promise 实例 `myPromise`。我们分别在第 13 行和第 16 行附加了两个 `.then` 的处理程序。尽管它们在功能上是相同的，但它们还是被被视为不同的处理程序。但是 ——

*   一个 promise 只能成功（resolved）或失败（reject）一次。它不能成功或失败两次，也不能从成功切换到失败，反之亦然。
*   如果一个 promise 在你添加成功/失败回调（即 `.then`）之前就已经成功或者失败，则 promise 还是会正确地调用回调函数，即使事件发生地比添加回调函数要早。

这意味着一旦 promise 达到最终状态，即使你多次附加 `.then` 处理程序，状态也不会改变（即不会再重新开始计算）。

为了验证这一点，你可以在第3行看到一个 `console.log` 语句。当你用 `.then` 处理程序运行上述代码时，需要输出的语句只会被打印一次。**它表明 promise 缓存了结果，并且下次也会得到相同的结果**。

另一个要注意的是，promise 的特点是[及早求值（evaluated eagerly）](https://en.wikipedia.org/wiki/Eager_evaluation)。**只要声明并将其绑定到变量，就立即开始执行**。没有 `.start` 或 `.begin` 方法。就像在上面的例子中那样。

为了确保 promises 不是立即开始而是惰性求值（evaluates lazily），**我们将它们包装在函数中**。稍后会看到一个例子。

#### 捕捉 Promises

到目前为止，我们只是很方便地看到了 `resolve` 的案例。那当执行器函数发生错误的时候会发生什么呢？当发生错误时，执行 `.then()` 的第二个回调，即 `onRejected`。让我们来看一个例子 ——

```
const myProimse = new Promise((resolve, reject) => {
  if (Math.random() * 100 < 90) {
    reject(new Error('The promise was rejected by using reject function.'));
  }
  throw new Error('The promise was rejected by throwing an error');
});

myProimse.then(
  () => console.log('resolved'), 
  (error) => console.log(error.message)
);

// Output (in 90% of cases)

// The promise was rejected by using reject function.
```

Promises 出错

这与第一个例子相同，但现在它以 90% 的概率执行 **reject** 函数，并且剩下的 10% 的情况会抛出错误。

在第 10 和 11 行，我们分别定义了 `onResolved` 和 `onRejected` 回调。请注意，即使发生错误，`onRejected` 也会执行。因此我们没有必要通过在 `reject` 函数中传递错误来拒绝一个 promise。也就是说，这两种情况下的 promise 都会被拒绝。

由于错误处理是健壮程序的必要条件，因此 promise 为这种情况提供了一条捷径。当我们想要处理一个错误时，我们可以使用 `.catch(onRejected)` 接收一个回调：`onRejected`，而不是使用 `.then(null, () => {...})`。以下代码将展示如何使用 catch 处理程序 ——

```
myProimse.catch(  
  (error) => console.log(error.message)  
);
```

请记住 `.catch` 只是 `.then(undefined, onRejected)` 的一个[语法糖](https://en.wikipedia.org/wiki/Syntactic_sugar)。

#### Promises 链式调用

`.then()` 和 `.catch()` 方法**总是返回一个 promise**。所以你可以把多个 `.then` 连接到一起。让我们通过一个例子来理解它。

首先，我们创建一个返回 promise 的 `delay` 函数。返回的 promise 将在给定秒数后解析。这是它的实现 ——

```
const delay = (ms) => new Promise(  
  (resolve) => setTimeout(resolve, ms)  
);
```

在这个例子中，我们使用一个函数来包装我们的 promise，以便它不会立即执行。该 `delay` 函数接收以毫秒为单位的时间作为参数。由于[闭包](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)的特点，该执行器函数可以访问 `ms` 参数。它还包含一个在毫秒后调用 `resolve` 函数的 `setTimeout` 函数，从而**有效解决 promise**。这是一个示例用法 ——

```
delay(5000).then(() => console.log('Resolved after 5 seconds'));
```

只有在 `delay(5000)` 解决后，`.then` 回调中的语句才会运行。当你运行上面的代码时，你会在 5 秒后看到 `Resolved after 5 seconds` 被打印出来。

以下是我们如何实现 `.then()` 的链式调用 ——

```
const delay = (ms) => new Promise(
  (resolve) => setTimeout(resolve, ms)
);

delay(2000)
  .then(() => {
    console.log('Resolved after 2 seconds')
    return delay(1500);
  })
  .then(() => {
    console.log('Resolved after 1.5 seconds');
    return delay(3000);
  }).then(() => {
    console.log('Resolved after 3 seconds');
    throw new Error();
  }).catch(() => {
    console.log('Caught an error.');
  }).then(() => {
    console.log('Done.');
  });

// Resolved after 2 seconds
// Resolved after 1.5 seconds
// Resolved after 3 seconds
// Caught an error.
// Done.
```

Promises 链式调用

我们从第 5 行开始。所采取的步骤如下 ——

*   `delay(2000)` 函数返回一个在两秒之后可以得到解决的 promise。
*   第一个 `.then()` 执行。它输出了一个句子 `Resolved after 2 seconds`。然后，它通过调用 `delay(1500)` 返回另一个 promise。如果一个 `.then()` 里面返回了一个 promise，该 promise 的**解决方案（技术上称为结算）**是转发给下一个 `.then` 去调用。
*   链式调用持续到最后。

**另请注意第 15 行**。我们在 `.then` 里面抛出了一个错误。只意味着当前的 promise 被拒绝了，**并被下一个** `.catch` **处理程序捕捉**。因此，`Caught an error` 这句话被打印。然而，一个 `.catch` **本身总是被解析为 promise，并且不会被拒绝**（除非你故意抛出错误）。这就是为什么 `.then` 后面的 `.catch` 会被执行的原因。

这里建议使用 `.catch` 而不是带有 `onResolved` 和 `onRejected` 参数的 `.then` 去处理。下面有一个案例解释了为什么最好这样做 ——

```
const promiseThatResolves = () => new Promise((resolve, reject) => {
  resolve();
});

// Leads to UnhandledPromiseRejection
promiseThatResolves().then(
  () => { throw new Error },
  (err) => console.log(err),
);

// Proper error handling
promiseThatResolves()
  .then(() => {
    throw new Error();
  })
  .catch(err => console.log(err));
```

第 1 行创建了一个始终可以解决的 promise。当你有一个带有两个回调 `onResolved` 和 `onRejected` 的 `.then` 时，你只能处理**执行器**函数的错误和拒绝。假设 `.then` 中的处理程序也会抛出错误。它不会导致执行 `onRejected` 回调，如第 6 - 9 行所示。

但如果你在 `.then` 后跟着调用 `.catch`，那么 `.catch` **既捕捉执行器函数的错误也捕捉 .then 处理程序的错误**。这是有道理的，因为 `.then` 总是返回一个 promise。如第 12 - 16 行所示。

* * *

你可以执行所有的代码示例，并通过实践应用学的更多。一个好的学习方法是将 promise 通过基于回调的函数实现。如果你使用 Node，那么有很多 `fs` 和其他模块中的函数都是基于回调的。在 Node 中确实存在可以自动将基于回调的函数转换为 promise 的实用工具，例如 [util.promisify](https://nodejs.org/api/util.html#util_util_promisify_original) 和 [pify](https://github.com/sindresorhus/pify)。但是，**如果你还在学习阶段**，请考虑遵循 WET（Write Everything Twice）原则，并重新实现或阅读尽可能多的库/函数的代码。特别是在生产环境下，请每隔一段时间就要使用 [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)（Don’t Repeat Yourself） 原则激励自己。

还有很多其他的 promises 相关知识我没有提及，比如 `Promise.all` 、`Promise.race` 和其他静态方法，以及如何处理 promises 中出现的错误，还有一些在创建一个promise 时应该注意的一些常见的反模式（anti-patterns）和细节。你可以参考下面的文章，以便可以更好地了解这些主题。

如果你希望我在另一篇文章中涵盖这些主题，请回复本文！:)

* * *

#### 参考

*   由 [Jake Archibald](https://medium.com/@jaffathecake) 撰写的 [ECMA Promise 规范](http://www.ecma-international.org/ecma-262/6.0/#sec-promise-objects)、[Mozilla 文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)、[Google 的 Promises 开发者指南](https://developers.google.com/web/fundamentals/primers/promises#promise-api-reference)，还有 [探索 JavaScript 中的 Promises 章节](http://exploringjs.com/es6/ch_promises.html#sec_first-example-promises) 以及 [Promises 介绍](http://jamesknelson.com/grokking-es6-promises-the-four-functions-you-need-to-avoid-callback-hell/)。

> 我希望你能喜欢这个客串贴！本文由 [**Arfat Salmon**](https://codeburst.io/@arfatsalman) 专门为 CodeBurst.io 撰写

### 结束语

感谢阅读！如果你最终决定走上 web 开发这条不归路，请查看：[**2018 年 Web 开发人员路线图**](https://codeburst.io/the-2018-web-developer-roadmap-826b1b806e8d)。

如果你正在努力成为一个更好的 JavaScript 开发人员，请查看：[**提高你的 JavaScript 面试水平 ——  学习算法 + 数据结构**](https://codeburst.io/ace-your-javascript-interview-learn-algorithms-data-structures-dabb547fb385)。

如果你希望成为我每周一次的电子邮件列表中的一员，请考虑[**在此输入你的 email**](https://docs.google.com/forms/d/e/1FAIpQLSeQYYmBCBfJF9MXFmRJ7hnwyXvMwyCtHC5wxVDh5Cq--VT6Fg/viewform)，或者在 [**Twitter**](https://twitter.com/BrandonMorelli) 上关注我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
