> * 原文地址：[Javascript - Generator-Yield/Next & Async-Await](https://codeburst.io/javascript-generator-yield-next-async-await-e428b0cb52e4)
> * 原文作者：[Deepak Gupta](https://codeburst.io/@ideepak.jsd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-generator-yield-next-async-await.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-generator-yield-next-async-await.md)
> * 译者：[acev](https://github.com/acev-online)
> * 校对者：[huimingwu](https://github.com/huimingwu), [zsky](https://github.com/zsky)

# Javascript - Generator-Yield/Next 和 Async-Await

![](https://cdn-images-1.medium.com/max/2000/0*yONeU8vuaq8eIyTD)

Generator (ES6)

> generator 函数是一个可以根据用户需求，在不同的时间间隔返回多个值，并能管理其内部状态的函数。如果一个函数使用了 <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*" title=" function* 声明（function 关键字后跟着星号）定义了一个 Generator 函数，它返回一个 Generator 对象。" rel="noopener">function*</a> 语法，那么它就变成了一个 generator 函数。

它们与正常函数不同，正常函数在单次执行中完成运行，而 **generator 函数可以被暂停和恢复**。它们确实会运行完成，但触发器在我们手中。它们使得**对异步函数能有更好的执行控制**，但这并不意味着它们不能用作同步函数。

> 注意：执行 generator 函数时，会返回一个新的 Generator 对象。

generator 的暂停和恢复是使用 `yield` 和 `next` 完成的。让我们来看看它们是什么，以及它们能做什么。

#### Yield/Next

> `yield` 关键字暂停 generator 函数的执行，并且 `yield` 关键字后面的表达式的值将返回给 generator 的调用者。它可以被理解为基于 generator 版本的 `return` 关键字。

`yield` 关键字实际上返回一个具有 `value` 和 `done` 两个属性的 `IteratorResult` 对象。（[如果你不了解什么是 iterators 和 iterables，点击这里阅读](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4)）。

> 一旦暂停 `yield` 表达式，generator 的代码执行将保持暂停状态，直到调用 generator 的 `next()` 方法为止。每次调用 generator 的 `next()` 方法时，generator 都会恢复执行并返回 [iterator](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4) 结果。

嗯……理论先到这里，让我们看一个例子：

```js
function* UUIDGenerator() {
    let d, r;
    while(true) {
        yield 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            r = (new Date().getTime() + Math.random()*16)%16 | 0;
            d = Math.floor(d/16);
            return (c=='x' ? r : (r&0x3|0x8)).toString(16);
        });
    }
};
```

UUIDGenerator 是一个 generator 函数，它使用当前时间和随机数计算 UUID ，并在每次执行时返回一个新的 UUID 。

要运行上面的函数，我们需要创建一个可以调用 `next()` 的 generator 对象：

```js
const UUID = UUIDGenerator();
// UUID is our generator object

UUID.next() 
// return {value: 'e35834ae-8694-4e16-8352-6d2368b3ccbf', done: false}
```
每次 UUID.next() 返回值的 value 值是新的 UUID ，done 值将始终为 false ，因为我们处于一个无限循环中。

> 注意：我们在无限循环上暂停，这是一种很酷的方式。在 generator 函数中的任何“停止点”处，不仅可以为外部函数生成值，还可以从外部接收值。

有许多 generator 的实现，并且很多库都在大量使用。比如说 [co](https://github.com/tj/co)、[koa](https://koajs.com/) 和 [redux-saga](https://github.com/redux-saga/redux-saga)。

* * *

#### Async/Await (ES7)

![](https://cdn-images-1.medium.com/max/1600/0*LAkE4GiZATgtseM5)

依照惯例，当一个异步操作返回由 `Promise` 处理的数据时，回调会被传递并调用。

> Async/Await 是一种特殊的语法，以更舒适的方式使用 Promise，这种方式非常容易理解和使用。

**Async 关键字**用于定义**异步函数** ，该函数返回一个 <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncFunction" title=" AsyncFunction 构造函数创建一个新的异步函数对象。在 JavaScript 中，每个异步函数实际上都是一个 AsyncFunction 对象。" rel="noopener" >AsyncFunction</a> 对象。

**Await 关键字**用于暂停异步函数执行，直到 `Promise` 被解决（resolved 或者 rejected），并在完成后继续执行 `async` 函数。恢复时，await 表达式的值是已执行的 Promise 的值。

**关键点：**

> 1. Await 只能在异步函数中使用。
> 2. 具有 async 关键字的函数将**始终**返回 promise。
> 3. 在相同函数下的多个 await 语句将始终按顺序运行。
> 4. 如果 promise 正常被 resolve，则 `await` 会返回 `promise` 结果。但是如果被 reject，它就会抛出错误，就像在那行有 `throw` 语句一样。
> 5. 异步函数不能同时等待多个 promise。
> 6. 如果在 await 之后使用 await 多次，并且后一条语句不依赖于前一条语句，则可能会出现性能问题。

到目前为止一切顺利，现在让我们看一个简单的例子：

```js
async function asyncFunction() {

  const promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("i am resolved!"), 1000)
  });

  const result = await promise; 
  // wait till the promise resolves (*)

  console.log(result); // "i am resolved!"
}

asyncFunction();
```

在 `await promise` 这一行，`asyncFunction` 执行“暂停”，并在 promise 被解决后回复，`result`（第 95 行的 `const result`）变成它的结果。上面的代码在一秒钟后展示 “`i am resolved!`”。

* * *

#### Generator 和 Async-await 比较

1.  **Generator 函数/yield** 和 **Async 函数/await** 都可以用来编写“等待”的异步代码，这意味着代码看起来像是同步的，即使它确实是异步的。
2.  **Generator 函数**按照 **yield 接着 yield** 的顺序执行，就是说一个 yield 表达式通过迭代器来执行一次（执行 `next` 方法），而 **Async-await** 按照 **await 接着 await** 的顺序依序执行。
3.  **Async/await** 可以更容易地实现 **Generators** 的特定用例。
4.  **Generator** 的返回值始终是 **{value: X, done: Boolean}**。对于 **Async 函数**它将始终是一个将解析为值 X 或抛出错误的 **promise**。
5.  **Async 函数**可以分解为 **Generator 和 promise** 来实现，这些都很有用。
* * *

如果您想要添加到我的电子邮件列表中，请考虑 [**在此处输入您的电子邮件**](https://goo.gl/forms/MOPINWoY7q1f1APu2)，并在 [**medium**](https://medium.com/@ideepak.jsd) **上关注我以阅读更多有关 javascript 的文章，并在** [**github**](https://github.com/dg92) **上查看我的疯狂代码**。如果有什么不清楚的，或者你想指出什么，请在下面评论。

你可能也喜欢我的其他文章：

1.  [Nodejs app structure](https://codeburst.io/fractal-a-nodejs-app-structure-for-infinite-scale-d74dda57ee11)
2.  [Javascript data structure with map, reduce, filter](https://codeburst.io/write-beautiful-javascript-with-%CE%BB-fp-es6-350cd64ab5bf)
3.  [Javascript- Currying VS Partial Application](https://codeburst.io/javascript-currying-vs-partial-application-4db5b2442be8)
4.  [Javascript ES6 — Iterables and Iterators](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4)
5.  [Javascript performance test — for vs for each vs (map, reduce, filter, find).](https://codeburst.io/write-beautiful-javascript-with-%CE%BB-fp-es6-350cd64ab5bf)
6.  [Javascript — Proxy](https://codeburst.io/why-to-use-javascript-proxy-5cdc69d943e3)

* * *

**如果你喜欢这篇文章，请鼓掌。提示：你可以拍 50 次！此外，欢迎推荐和分享，以帮助其他人找到它！**

**谢谢！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
