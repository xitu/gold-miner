> * 原文地址：[Understanding Asynchronous JavaScript](https://blog.bitsrc.io/understanding-asynchronous-javascript-the-event-loop-74cd408419ff)
> * 原文作者：[Sukhjinder Arora](https://blog.bitsrc.io/@Sukhjinder?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-asynchronous-javascript-the-event-loop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-asynchronous-javascript-the-event-loop.md)
> * 译者：[H246802](https://github.com/H246802)
> * 校对者：

# 理解异步 JavaScript

学习 JavaScript 是怎么工作的

![](https://cdn-images-1.medium.com/max/2000/0*wO-kYdN93deiT0U9)

Photo by [Sean Lim](https://unsplash.com/@sean1188?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

JavaScript 是一种单线程编程语言，这意味着同一时间只能完成一件事情。也就是说，JavaScript 引擎只能在单一线程中处理一次语句。

单线程语言简化了代码编写，因为你不必担心并发问题，但这也意味着你无法在不阻塞主线程的情况下执行网络请求等长时间操作。

想象一下从 API 中请求一些数据。根据情况，服务器可能需要一些时间来处理请求，同时阻塞主线程，让网页无法响应。

这也就是异步 JavaScript 的美妙之处了。使用异步 JavaScript （例如回调，Promise 或者 async/await ），你可以执行长时间网络请求同时不会阻塞主线程。

虽然您没有必要将所有这些概念都学会成为一名出色的 JavaScript 开发人员，但了解这些对你会很有帮助

所以不用多说了，让我们开始吧！

### 同步 JavaScript 如何工作？

在深入研究异步 JavaScript 之前，让我们首先了解同步 JavaScript 代码在 JavaScript 引擎中的执行情况。例如：

```JavaScript
const second = () => {
  console.log('Hello there!');
}
const first = () => {
  console.log('Hi there!');
  second();
  console.log('The End');
}
first();
```

要理解上述代码在 JavaScript 引擎中的执行方式，我们必须理解执行上下文和调用栈（也称为执行栈）的概念。

#### 执行上下文

执行上下文是评估和执行 JavaScript 代码的环境的抽象概念。每当在 JavaScript 中运行任何代码时，它都在执行上下文中运行。

函数代码在函数执行上下文中执行，全局代码在全局执行上下文中执行。每个函数都有自己的执行上下文。

#### 调用栈

顾名思义，调用栈是一个具有 LIFO（后进先出）结构的栈，用于存储代码执行期间创建的所有执行上下文。

JavaScript 有一个单独的调用栈，因为它是一种单线程编程语言。调用栈具有 LIFO 结构，这意味着只能从调用栈顶部添加或删除元素。

让我们回到上面的代码片段以便尝试理解代码在 JavaScript 引擎中的执行方式。

```js
const second = () => {
  console.log('Hello there!');
}
const first = () => {
  console.log('Hi there!');
  second();
  console.log('The End');
}
first();
```


![image](https://cdn-images-1.medium.com/max/1240/1*DkG1a8f7rdl0GxM0ly4P7w.png)
 <p align="center">上述代码的调用栈工作情况</p>

 #### 这过程发生了什么呢？

 当代码执行的时候，会创建一个全局执行上下文（由 `main()` 表示）并将其推到执行栈的顶部。当对 `first()` 函数调用时，它会被推送的栈的顶部。

 接下来，`console.log('Hi there!')` 被推到调用栈的顶部，当它执行完成后，它会从调用栈中弹出。在它之后，我们调用 `second()` ，因此 `second()` 函数被推送到调用栈的顶部。

 `console.log('Hello there!')` 被推到调用栈顶部并在完成后从调用栈中弹出。`second()` 函数执行完成，接着它从调用栈中弹出。

 `console.log('The End')` 被推到调用栈顶部并在完成后被删除。之后，`first()` 函数执行完成，因此它从调用栈中删除。

 程序此时完成其执行，因此从调用栈中弹出全局执行上下文 (`main()`)。

 ### 异步JavaScript如何工作？

 现在我们已经了解了相关调用栈的基本概念，以及同步JavaScript的工作原理，现在让我们回到异步JavaScript。

 #### 什么是阻塞？

 假设我们正在以同步方式进行图像处理或网络请求。例如：

 ```js
const processImage = (image) => {
  /**
  * 对图像进行一些操作
  **/
  console.log('Image processed');
}
const networkRequest = (url) => {
  /**
  * 请求网络资源
  **/
  return someData;
}
const greeting = () => {
  console.log('Hello World');
}
processImage(logo.jpg);
networkRequest('www.somerandomurl.com');
greeting();
 ```

进行图像处理和网络请求都需要时间。因此，当 `processImage()` 函数调用时需要一些时间，具体多少时间根据图像的大小决定。

当 `processImage()` 函数完成时，它将从调用栈中删除。之后调用`networkRequest()` 函数并将其推送到执行栈。同样，它还需要一些时间才能完成执行。

最后，当 `networkRequest()` 函数完成时，调用 `greeting()` 函数，因为它只包含 `console.log` 语句，而console.log语句通常很快，所以 `greeting()` 函数会立即执行并返回。

所以你可以看到，我们必须等到函数（例如 `processImage()` 或 `networkRequest()` ）完成。这也就意味着这些函数阻塞了调用栈或主线程。因此，在执行上述代码时，我们无法执行任何其他操作，这是不理想的。

#### 那么解决方案是什么？

最简单的解决办法是异步回调，我们通常使用异步回调来让代码无阻塞。例如：

```js
const networkRequest = () => {
  setTimeout(() => {
    console.log('Async Code');
  }, 2000);
};
console.log('Hello World');
networkRequest();
```

这里我使用了 `setTimeout` 方法来模拟网络请求。请记住， `setTimeout` 不是 JavaScript 引擎的一部分，它是 Web APIs（在浏览器中）和 C/C++ APIs（在node.js中）的一部分。

要了解如何执行此代码，我们必须了解一些其他概念，例如事件循环和回调队列（也称为任务队列或消息队列）。

![image](https://cdn-images-1.medium.com/max/992/1*O_H6XRaDX9FaC4Q9viiRAA.png)
 <p align="center">JavaScript 运行时环境概述</p>

 **事件循环**，**Web APIs** 和 **消息队列/任务队列** 不是JavaScript 引擎的一部分，它是浏览器的 JavaScript 运行所处环境或Nodejs JavaScript运行所处环境中的一部分（在 Nodejs 的环境下）。在Nodejs 中，Web APIs 被C / C ++ APIs 取代。

 现在让我们回过头看看上面的代码，看看它是如何以异步方式执行的。

 ```js
const networkRequest = () => {
  setTimeout(() => {
    console.log('Async Code');
  }, 2000);
};
console.log('Hello World');
networkRequest();
console.log('The End');
 ```

![image](https://cdn-images-1.medium.com/max/992/1*sOz5cj-_Jjv23njWg_-uGA.gif))
 <p align="center">Event Loop（事件循环）</p>

 当上面的代码在浏览器中运行时，`console.log('Hello World')` 被推送到栈，在执行完成后从栈中弹出。紧接着，遇到 `networkRequest() `的执行，因此将其推送到栈顶部。

 接下来调用 `setTimeout()` 函数，因此将其推送到栈顶部。`setTimeout()` 有两个参数：1) 回调和 2) 以毫秒（ms）为单位的时间。
 
 `setTimeout()` 方法在 Web APIs 环境中启动 2s 的计时器。此时，`setTimeout()` 已完成，并从调用栈中弹出。在它之后，`console.log('The End')` 被推送到栈，在执行完成后从调用栈中删除。
 
 同时，计时器已到期，现在回调函数被推送到消息队列。但回调函数并没有立即执行，而这就是形成了一个事件循环（Event Loop）。

 #### 事件循环

事件循环的作用是查看调用栈并确定调用栈是否为空。如果调用栈为空，它会查看消息队列以查看是否有任何挂起的回调等待执行。

在这个例子中，消息队列包含一个回调，此时调用栈为空。因此，事件循环（Event Loop） 将回调推送到调用栈顶部。

再之后，`console.log('Async Code')` 被推到栈顶部，执行并从调用栈中弹出。此时，回调函数已完成，因此将其从调用栈中删除，程序最终完成。

#### DOM 事件

**消息队列**还包含来自 DOM 事件的回调，例如点击事件和键盘事件。

例如：

```js
document.querySelector('.btn').addEventListener('click',(event) => {
  console.log('Button Clicked');
});
```
在DOM事件的情况下，事件监听器位于 Web APIs 环境中等待某个事件（在这种情况下是点击事件）发生，并且当该事件发生时，则回调函数被放置在等待执行的消息队列中。

事件循环再次检查调用栈是否为空，如果它为空并且执行了回调，则将事件回调推送到调用栈。

我们已经知道了如何执行异步回调和DOM事件，它们使用消息队列来存储等待执行的所有回调。

#### ES6 工作队列/微任务队列（Job Queue/ Micro-Task queue）

ES6引入了 Promises 在 JavaScript 中使用的工作队列/微任务队列的概念。消息队列和微任务队列之间的区别在于工作队列的优先级高于消息队列，这意味着 工作队列/微任务队列中的 promise 工作将在消息队列内的回调之前执行。

例如：

```js
console.log('Script start');
setTimeout(() => {
  console.log('setTimeout');
}, 0);
new Promise((resolve, reject) => {
    resolve('Promise resolved');
  }).then(res => console.log(res))
    .catch(err => console.log(err));
console.log('Script End');
```

输出：

```
Script start
Script End
Promise resolved
setTimeout
```

我们可以看到 promise 在 `setTimeout` 之前执行，因为 promise 响应存储在微任务队列中，其优先级高于消息队列。

让我们再看一个例子，这次有两个 promise 和两个 setTimeout。例如：

```js
console.log('Script start');
setTimeout(() => {
  console.log('setTimeout 1');
}, 0);
setTimeout(() => {
  console.log('setTimeout 2');
}, 0);
new Promise((resolve, reject) => {
    resolve('Promise 1 resolved');
  }).then(res => console.log(res))
    .catch(err => console.log(err));
new Promise((resolve, reject) => {
    resolve('Promise 2 resolved');
  }).then(res => console.log(res))
    .catch(err => console.log(err));
console.log('Script End');
```

输出：

```
Script start
Script End
Promise 1 resolved
Promise 2 resolved
setTimeout 1
setTimeout 2
```

我们可以看到两个 promise 都在 `setTimeout` 中的回调之前执行，因为事件循环将微任务队列中的任务优先于消息队列/任务队列中的任务。

当事件循环正在执行微任务队列中的任务时，如果另一个 promise 执行 resolve 方法，那么它将被添加到同一个微任务队列的末尾，并且它将在消息队列的所有回调之前执行，无论消息队列回调等待执行花费了多少时间。

例如：

```js
console.log('Script start');
setTimeout(() => {
  console.log('setTimeout');
}, 0);
new Promise((resolve, reject) => {
    resolve('Promise 1 resolved');
  }).then(res => console.log(res));
new Promise((resolve, reject) => {
  resolve('Promise 2 resolved');
  }).then(res => {
       console.log(res);
       return new Promise((resolve, reject) => {
         resolve('Promise 3 resolved');
       })
     }).then(res => console.log(res));
console.log('Script End');
```

输出：

```
Script start
Script End
Promise 1 resolved
Promise 2 resolved
Promise 3 resolved
setTimeout
```

因此，微任务队列中的所有任务都将在消息队列中的任务之前执行。也就是说，事件循环将首先在执行消息队列中的任何回调之前清空微任务队列。

### 总结

因此，我们已经了解了异步 JavaScript 如何工作以及其他概念，例如调用栈，事件循环，消息队列/任务队列和工作队列/微任务队列，它们共同构成了 JavaScript 运行时环境。虽然您没有必要将所有这些概念都学习成为一名出色的 JavaScript 开发人员，但了解这些概念会很有帮助:)

**译者注：**
- 文中工作队列（Job Queue）也就是微任务队列，而消息队列则是指我们通常聊得宏任务队列。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
