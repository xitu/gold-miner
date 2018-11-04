> * 原文地址：[How JavaScript works: Event loop and the rise of Async programming + 5 ways to better coding with async/await](https://blog.sessionstack.com/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with-2f077c4438b5)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
> * 译者：[春雪](https://github.com/balancelove)
> * 校对者：[athena0304](https://github.com/athena0304) [tvChan](https://github.com/tvchan)

# JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧

欢迎来到旨在探索 JavaScript 以及它的核心元素的系列文章的第四篇。在认识、描述这些核心元素的过程中，我们也会分享一些当我们构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-4-eventloop-intro) 的时候遵守的一些经验规则，一个 JavaScript 应用应该保持健壮和高性能来维持竞争力。

如果你错过了前三章可以在这儿找到它们:

1.  [对引擎、运行时和调用栈的概述](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf?source=collection_home---2------1----------------)
2.  [深入 V8 引擎以及 5 个写出更优代码的技巧](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e?source=collection_home---2------2----------------)
3.  [内存管理以及四种常见的内存泄漏的解决方法](https://blog.sessionstack.com/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks-3f28b94cfbec?source=collection_home---2------0----------------)

这次我们将展开第一篇文章的内容，回顾一下在单线程环境中编程的缺点，以及如何克服它们来构建出色的 JavaScript UI。按照惯例，在文章的末尾我们将分享 5 个如何使用 async/await 写出更简洁的代码的技巧。

#### **为什么单线程会限制我们？**

在 [第一篇文章](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf) 中, 我们思考了一个问题 _当调用栈中的函数调用需要花费我们非常多的时间，会发生什么？_

比如，想象一下你的浏览器现在正在运行一个复杂的图像转换的算法。

当调用栈有函数在执行，浏览器就不能做任何事了 —— 它被阻塞了。这意味着浏览器不能渲染页面，不能运行任何其它的代码，它就这样被卡住了。那么问题来了 —— 你的应用不再高效和令人满意了。

你的应用**卡住了**。

在某些情况下，这可能不是一个很严重的问题。但这其实是一个更大的问题。一旦你的浏览器开始在调用栈运行很多很多的任务，它就很有可能会长时间得不到响应。在这一点上，大多数的浏览器会采取抛出错误的解决方案，询问你是否要终止这个页面：

它很丑，并且它会毁了你的用户体验：

![](https://cdn-images-1.medium.com/max/800/1*MCt4ZC0dMVhJsgo1u6lpYw.jpeg)

#### **JavaScript 程序的单元块**

你可能会将你的 JavaScript 代码写在一个 .js 文件中，但你的程序一定是由几个代码块组成的，而且只有一个能够 __现在__ 执行，其余的都会在 __之后__ 执行。最常见的单元块就是函数。

JavaScript 开发的新手最不能理解的就是 __之后__ 的代码并不一定会在 __现在__ 的代码执行之后执行。换句话说，在定义中不能 __现在__ 立刻完成的任务将会异步执行，这意味着可能不会像你认为的那样发生上面所说的阻塞问题。

让我们来看看下面的例子：

```js
// ajax(..) 是任意库提供的任意一个 Ajax 的函数
var response = ajax('https://example.com/api');

console.log(response);
// `response` 不会是响应的 response，因为 Ajax 是异步的
```

你可能已经意识到了，标准的 Ajax 请求不会同步发生，这意味着在代码执行的时候，ajax(..) 函数在没有任何返回值之前，是不会赋值给 response 变量的。

有一个简单的办法去 “等待” 异步函数返回它的结果，就是使用 **回调函数**：

```js
ajax('https://example.com/api', function(response) {
    console.log(response); // `response` 现在是有值的
});
```

注意：虽然实际上是可以 **同步** 实现 Ajax 请求的，但是最好永远都不要这么做。如果你使用了同步的 Ajax 请求，你的 JavaScript 应用就会被阻塞 —— 用户就不能点击、输入数据、导航或是滚动。这将会阻止用户的任何交互动作。这是一种非常糟糕的做法。

这就是使用同步的样子，但是千万不要这么做，不要毁了你的 web 应用：

```js
// 假设你正在使用 jQuery
jQuery.ajax({
    url: 'https://api.example.com/endpoint',
    success: function(response) {
        // 这是你的回调
    },
    async: false // 这是一个坏主意
});
```

我们使用 Ajax 请求只是一个例子。事实上你可以异步执行任何代码。

`setTimeout(callback, milliseconds)` 也能够异步执行。`setTimeout` 函数所做的就是设置了一个事件（超时）等待触发执行。我们来看一看：

```js
function first() {
    console.log('first');
}
function second() {
    console.log('second');
}
function third() {
    console.log('third');
}
first();
setTimeout(second, 1000); // 1000ms 后调用 `second`
third();
```

console 打印出来将会是下面这样的：

```js
first
third
second
```

#### **解析事件循环**

我们先从一个奇怪的说法谈起 —— 尽管 JavaScript 允许异步的代码(就像是我们刚刚说的 `setTimeout`) ，但直到 ES6，JavaScript 自身从未有过任何关于异步的直接概念。JavaScript 引擎只会在任意时刻执行一个程序。

关于 JavaScript 引擎是如何工作的更多细节(特别是 V8 引擎)请看我们的[前一章](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e)。

那么，谁会告诉 JS 引擎去执行你的程序？事实上，JS 引擎不是单独运行的 —— 它运行在一个宿主环境中，对于大多数开发者来说就是典型的浏览器和 Node.js。实际上，如今，JavaScript 被应用到了从机器人到灯泡的各种设备上。每个设备都代表了一种不同类型的 JS 引擎的宿主环境。

所有的环境都有一个共同点，就是都拥有一个 **事件循环** 的内置机制，它随着时间的推移每次都去调用 JS 引擎去处理程序中多个块的执行。

这意味着 JS 引擎只是任意的 JS 代码按需执行的环境。是它周围的环境来调度这些事件(JS 代码执行)。

所以，比如当你的 JavaScript 程序发出了一个 Ajax 请求去服务器获取数据，你在一个函数(回调)中写了 “response” 代码，然后 JS 引擎就会告诉宿主环境：
“嘿，我现在要暂停执行了，但是当你完成了这个网络请求，并且获取到数据的时候，请回来调用这个函数。”

然后浏览器设置对网络响应的监听，当它有东西返回给你的时候，它将会把回调函数插入到事件循环队列里然后执行。

我们来看下面的图：

![](https://cdn-images-1.medium.com/max/800/1*FA9NGxNB6-v1oI2qGEtlRQ.png)

你可以在[前一章](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf)了解到更多关于内存堆和调用栈的知识。

那图中的这些 Web API 是什么东西呢？从本质上讲，它们是你无法访问的线程，但是你能够调用它们。它们是浏览器并行启动的一部分。如果你是一个 Node.js 的开发者，这些就是 C++ 的一些 API。

那 __事件循环__ 究竟是什么？

![](https://cdn-images-1.medium.com/max/800/1*KGBiAxjeD9JT2j6KDo0zUg.png)

事件循环有一个简单的任务 —— 去监控调用栈和回调队列。如果调用栈是空的，它就会取出队列中的第一个事件，然后将它压入到调用栈中，然后运行它。

这样的迭代在事件循环中被称作一个 **tick**。每一个事件就是一个回调函数。

```js
console.log('Hi');
setTimeout(function cb1() { 
    console.log('cb1');
}, 5000);
console.log('Bye');
```

让我们**执行**一下这段代码，看看会发生什么：

1.  状态是干净的。浏览器 console 是干净的，并且调用栈是空的。

![](https://cdn-images-1.medium.com/max/800/1*9fbOuFXJHwhqa6ToCc_v2A.png)

2. `console.log('Hi')` 被添加到了调用栈里。

![](https://cdn-images-1.medium.com/max/800/1*dvrghQCVQIZOfNC27Jrtlw.png)

3. `console.log('Hi')` 被执行。

![](https://cdn-images-1.medium.com/max/800/1*yn9Y4PXNP8XTz6mtCAzDZQ.png)

4. `console.log('Hi')` 被移出调用栈。

![](https://cdn-images-1.medium.com/max/800/1*iBedryNbqtixYTKviPC1tA.png)

5. `setTimeout(function cb1() { ... })` 被添加到调用栈。

![](https://cdn-images-1.medium.com/max/800/1*HIn-BxIP38X6mF_65snMKg.png)

6. `setTimeout(function cb1() { ... })` 执行。浏览器创建了一个定时器(Web API 的一部分)，并且开始倒计时。

![](https://cdn-images-1.medium.com/max/800/1*vd3X2O_qRfqaEpW4AfZM4w.png)

7. `setTimeout(function cb1() { ... })` 本身执行完了，然后被移出调用栈。

![](https://cdn-images-1.medium.com/max/800/1*_nYLhoZPKD_HPhpJtQeErA.png)

8. `console.log('Bye')` 被添加到调用栈。

![](https://cdn-images-1.medium.com/max/800/1*1NAeDnEv6DWFewX_C-L8mg.png)

9. `console.log('Bye')` 执行。

![](https://cdn-images-1.medium.com/max/800/1*UwtM7DmK1BmlBOUUYEopGQ.png)

10. `console.log('Bye')` 被移出调用栈。

![](https://cdn-images-1.medium.com/max/800/1*-vHNuJsJVXvqq5dLHPt7cQ.png)

11. 在至少 5000ms 过后，定时器完成，然后将回调 `cb1` 压入到回调队列。

![](https://cdn-images-1.medium.com/max/800/1*eOj6NVwGI2N78onh6CuCbA.png)

12. 事件循环从回调队列取走 `cb1`，然后把它压入调用栈。

![](https://cdn-images-1.medium.com/max/800/1*jQMQ9BEKPycs2wFC233aNg.png)

13. `cb1` 被执行，然后把 `console.log('cb1')` 压入调用栈。

![](https://cdn-images-1.medium.com/max/800/1*hpyVeL1zsaeHaqS7mU4Qfw.png)

14. `console.log('cb1')` 被执行。

![](https://cdn-images-1.medium.com/max/800/1*lvOtCg75ObmUTOxIS6anEQ.png)

15. `console.log('cb1')` 被移出调用栈。

![](https://cdn-images-1.medium.com/max/800/1*Jyyot22aRkKMF3LN1bgE-w.png)

16. `cb1` 被移出调用栈。

![](https://cdn-images-1.medium.com/max/800/1*t2Btfb_tBbBxTvyVgKX0Qg.png)

快速回顾一下：

![](https://cdn-images-1.medium.com/max/800/1*TozSrkk92l8ho6d8JxqF_w.gif)

有趣的是，ES6 指定了事件循环该如何工作，这意味着在技术上它属于 JS 引擎的职责范围了，不再是宿主环境的一部分了。造成这种变化的一个主要原因是在 ES6 中引入了 promise，因为后者需要对事件循环队列的调度操作进行直接的、细微的控制(后面我们会详细的讨论它们)。

#### setTimeout(…) 是如何工作的

需要重点注意的是 `setTimeout(…)` 不会自动的把你的回调放到事件循环队列中。它设置了一个定时器。当定时器过期了，宿主环境会将你的回调放到事件循环队列中，以便在以后的循环中取走执行它。看看下面的代码：

```
setTimeout(myCallback, 1000);
```

这并不意味着 `myCallback` 将会在 1,000ms 之后执行，而是，在 1,000ms 之后将被添加到事件队列。然而，这个队列中可能会拥有一些早一点添加进来的事件 —— 你的回调将会等待被执行。

有很多文章或教程在介绍异步代码的时候都会从 setTimeout(callback, 0) 开始。好了，现在你知道了事件循环做了什么以及 setTimeout 是怎么运行的：以第二个参数是 0 的方式调用 setTimeout 就是推迟到调用栈为空才执行回调。

来看看下面的代码：

```js
console.log('Hi');
setTimeout(function() {
    console.log('callback');
}, 0);
console.log('Bye');
```

尽管等待的事件设置成 0 了，但是浏览器 console 的结果将会是下面这样：

```js
Hi
Bye
callback
```

#### ES6 中的作业(Jobs)是什么？

ES6 中介绍了一种叫 “作业队列（Job Queue）” 的新概念。它是事件循环队列之上的一层。你很有可能会在处理 Promises 的异步的时候遇到它(我们后面也会讨论到它们)。

我们现在只简单介绍一下这个概念，以便当我们讨论 Promises 的异步行为的时候，你能理解这些行为是如何被调度和处理的。

想象一下：作业队列是一个跟在事件队列的每个 **tick** 的末尾的一个队列。在事件循环队列的一个 **tick** 期间可能会发生某些异步操作，这不会导致把一整个新事件添加到事件循环队列中，而是会在当前 **tick** 的作业队列的末尾添加一项(也就是作业)。

这意味着你可以添加一个稍后执行的功能，并且你可以放心，它会在执行任何其他操作之前执行。

作业还能够使更多的作业被添加到同一个队列的末尾。从理论上说，一个作业的“循环”（一个不停的添加其他作业的作业，等等）可能会无限循环，从而使进入下一个事件循环 **tick** 的程序的必要资源被消耗殆尽。从概念上讲，这就和你写了一个长时间运行的代码或是死循环(就像是 `while (true)`)一样。

作业有点像 `setTimeout(callback, 0)` 的“hack”，但是它们引入了一个更加明确、更有保证的执行顺序：稍后执行，但是会尽快执行。

#### **回调**

众所周知，在 JavaScript 程序中，回调是表达和管理异步目前最常用的方式。确实，回调是 JavaScript 中最基础的异步模式。无数的 JS 程序，甚至是非常复杂的 JS 程序，都是使用回调作为异步的基础。

回调也不是没有缺点。许多开发者都尝试去找到更好的异步模式。但是，如果你不理解底层的实际情况，你是不可能有效的去使用任何抽象化的东西。

在下一章中，我们将深入挖掘这些抽象的概念来说明为什么更复杂的异步模式（将会在后续的帖子中讨论）是必须的甚至是被推荐的。

#### 嵌套回调

看看下面的代码：

```js
listen('click', function (e){
    setTimeout(function(){
        ajax('https://api.example.com/endpoint', function (text){
            if (text == "hello") {
	        doSomething();
	    }
	    else if (text == "world") {
	        doSomethingElse();
            }
        });
    }, 500);
});
```

我们有一个三个函数嵌套在一起的函数链，每一步都代表异步序列中的一步。

这种代码我们把它叫做“回调地狱”。但是“回调地狱”显然和嵌套/缩进没有关系。这是个更深层次的问题了。

首先，我们在等待一个“click”事件，然后等待定时器触发，再然后等着 Ajax 的响应返回，在这点上可能会再次重复。

乍一看，这个代码似乎可以分解成连续的几个步骤：

```js
listen('click', function (e) {
	// ..
});
```

然后：

```js

setTimeout(function(){
    // ..
}, 500);
```

再然后：

```js
ajax('https://api.example.com/endpoint', function (text){
    // ..
});
```

最后：

```js
if (text == "hello") {
    doSomething();
}
else if (text == "world") {
    doSomethingElse();
}
```

所以，用这样一种顺序的方式来表达你的异步代码是不是看起来更自然一些了？一定会有方法做到这一点，不是吗？

#### Promises

看看下面的代码：

```js
var x = 1;
var y = 2;
console.log(x + y);
```

这是段简单的代码：它对 `x` 和 `y` 求和，然后在控制台打印出来。但，假如 `x` 或是 `y` 的值是待确定的呢？比如说，我们需要在使用这两个值之前去服务器检索 `x` 和 `y` 的值。然后，有两个函数 `loadX` 和 `loadY`，分别从服务器获取 `x` 和 `y` 的值。最后，函数 `sum` 来将获取到的 `x` 和 `y` 的值加起来。

看起来就是这样的(相当丑，不是吗？):

```js
function sum(getX, getY, callback) {
    var x, y;
    getX(function(result) {
        x = result;
        if (y !== undefined) {
            callback(x + y);
        }
    });
    getY(function(result) {
        y = result;
        if (x !== undefined) {
            callback(x + y);
        }
    });
}
// 一个同步或者异步的函数，获取 `x` 的值
function fetchX() {
    // ..
}


// 一个同步或者异步的函数，获取 `y` 的值
function fetchY() {
    // ..
}
sum(fetchX, fetchY, function(result) {
    console.log(result);
});
```

这里面的关键点在于 — 这段代码中，`x` 和 `y` 是 **未来** 的值，然后我们还写了一个 `sum(…)` 函数，并且从外面看它并不关心 `x` 或者 `y` 现在是不是可用的。

当然，这种基于回调的方式是粗糙的并且有很多不足。这只是初步理解 __未来值__ 以及不需要去担心它们什么时候可用的第一步。

#### Promise 值

让我们看一下这个简短的例子是如何用 Promises 来表达 `x + y` 的：

```js
function sum(xPromise, yPromise) {
	// `Promise.all([ .. ])` 接受一个 promises 的数组，
	// 并且返回一个新的 promise 对象去等待它们
	// 全部完成
	return Promise.all([xPromise, yPromise])

	// 当 promise 完成的时候，我们就能获取
	// `X` and `Y` 的值，并且计算他们
	.then(function(values){
		// `values` 是一个来自前面完成的 promise
		// 的消息数组
		return values[0] + values[1];
	} );
}

// `fetchX()` and `fetchY()` 返回 promises 的值，有他们各自的
// 值，或许*现在* 已经准备好了
// 也可能要 *等一会儿*。
sum(fetchX(), fetchY())

// 我们从返回的 promise 得到了这
// 两个数字的和。
// 现在我们连续的调用了 `then(...)` 去等待已经完成的
// promise。
.then(function(sum){
    console.log(sum);
});
```

这段代码可以看到两层 Promises。

`fetchX()` 和 `fetchY()` 被直接调用，然后他们的返回值(promises!)被传给 `sum(...)`。这些 promises 代表的值可能在 _现在_ 或是 _将来_ 准备好，但每个 promise 的自身规范都是相同的。我们以一种与时间无关的方式来解释 `x` 和 `y` 的值。它们在一段时间内是 _未来值_。

第二层 promise 是 `sum(...)` 创建 (通过 `Promise.all([ ... ])`) 并返回的，我们通过调用 `then(...)` 来等待返回。当 `sum(...)` 操作完成的时候，_未来值_ 的总和也就准备就绪了，然后就可以把值打印出来了。我们隐藏了在 `sum(...)` 函数内部等待 `x` 和 `y` 的 _未来值_ 的逻辑。

**注意**：在 `sum(…)` 函数中，`Promise.all([ … ])` 创建了一个 promise (这个 promise 等待 `promiseX` and `promiseY` 的完成)。链式调用 `.then(...)` 来创建另一个 promise，返回的 `values[0] + values[1]` 会立即执行完成(还要加上加运算的结果)。因此，我们在 `sum(...)` 调用结束后加上的 `then(...)` — 在上面代码的末尾 — 实际上是在第二个 promise 返回后执行，而不是第一个 `Promise.all([ ... ])` 创建的 promise。还有，尽管我们没有在第二个 `then(...)` 后面再进行链式调用，但是它也创建了一个 promise，我们可以去观察或是使用它。关于 Promise 的链式调用会在后面详细地解释。

使用 Promises，这个 `then(...)` 的调用其实有两个方法，第一个方法被调用的时机是在已完成的时候 (就像我们前面使用的那样)，而另一个被调用的时机是已失败的时候：

```js
sum(fetchX(), fetchY())
.then(
    // 完成时
    function(sum) {
        console.log( sum );
    },
    // 失败时
    function(err) {
    	console.error( err ); // bummer!
    }
);
```

如果在获取 `x` 或者 `y` 的时候出错了，又或许是在进行加运算的时候失败了，`sum(...)` 返回的 promise 将会是已失败的状态，并且会将 promise 已失败的值传给 `then(...)` 的第二个回调处理。

因为 Promises 封装了依赖时间的状态 — 等待内部的值已完成或是已失败 — 从外面看，Promise 是独立于时间的，因此 Promises 可以能通过一种可预测的方式组合起来，而不用去考虑底层的时间或者结果。

而且，一旦 Promise 的状态确定了，那么他就永远也不会改变状态了 — 在这时它会变成一个 _不可改变的值_ — 然后就可以在有需要的时候多次 _观察_ 它。

实际上链式的 promises 是非常有用的：

```js
function delay(time) {
    return new Promise(function(resolve, reject){
        setTimeout(resolve, time);
    });
}

delay(1000)
.then(function(){
    console.log("after 1000ms");
    return delay(2000);
})
.then(function(){
    console.log("after another 2000ms");
})
.then(function(){
    console.log("step 4 (next Job)");
    return delay(5000);
})
// ...
```

调用 `delay(2000)` 会创建一个在 2000ms 完成的 promise，然后我们返回第一个 `then(...)` 的成功回调，这会导致第二个 `then(...)` 的 promise 要再等待 2000ms 执行。

**注意**：因为 Promise 一旦完成了就不能再改变状态了，所以可以安全的传递到任何地方，因为它不会再被意外或是恶意的修改。这对于在多个地方监听 Promise 的解决方案来说，尤其正确。一方不可能影响到另一方所监听到的结果。不可变听起来像是一个学术性的话题，但是它是 Promise 设计中最基础、最重要方面，不应该被忽略。

#### **用不用 Promise？**

使用 Promises 最重要的一点在于能否确定一些值是否是真正的 Promise。换句话说，它的值像一个 Promise 吗？

我们知道 Promises 是由 `new Promise(…)` 语句构造出来的，你可能会认为 `p instanceof Promise` 就能判断一个 Promise。其实，并不完全是。

主要是因为另一个浏览器窗口(比如 iframe)获取一个 Promise 的值，它拥有自己的 Promise 类，且不同于当前或其他窗口，所以使用 instance 来区分 Promise 是不准确的。

而且，一个框架或者库可以选择自己的 Promise，而不是使用 ES6 原生的 Promise 实现。事实上，你很可能会在不支持 Promise 的老式浏览器中使用第三方的 Promise 库。

#### 吞噬异常

如果在任何一个创建 Promise 或是对其结果观察的过程中，抛出了一个 JavaScript 异常错误，比如说 `TypeError` 或是 `ReferenceError`，那么这个异常会被捕获，然后它就会把 Promise 的状态变成已失败。

例如：

```js
var p = new Promise(function(resolve, reject){
    foo.bar();	  // 对不起，`foo` 没有定义
    resolve(374); // 不会执行 :(
});

p.then(
    function fulfilled(){
        // 不会执行 :(
    },
    function rejected(err){
        // `err` 是 `foo.bar()` 那一行
	// 抛出的 `TypeError` 异常对象。
    }
);
```

如果一个 Promise 已经结束了，但是在监听结果(在 `then(…)` 里的回调函数)的时候发生了 JS 异常会怎么样呢？即使这个错误没有丢失，你可能也会对它的处理方式有点惊讶。除非你深入的挖掘一下：

```
var p = new Promise( function(resolve,reject){
	resolve(374);
});

p.then(function fulfilled(message){
    foo.bar();
    console.log(message);   // 不会执行
},
    function rejected(err){
        // 不会执行
    }
);
```

这看起来就像 `foo.bar()` 的异常真的被吞了。当然了，异常并不是被吞了。这是更深层次的问题出现了，我们没有监听到异常。`p.then(…)` 调用它自己会返回另一个 promise，而这个 promise 会因为 `TypeError` 的异常变为已失败状态。

#### **处理未捕获的异常**

还有一些 _更好的_ 办法解决这个问题。

最常见的就是给 Promise 加一个 `done(…)`，用来标志 Promise 链的结束。`done(…)` 不会创建或返回一个 Promise，所以传给 `done(..)` 的回调显然不会将问题报告给一个不存在的 Promise。

在未捕获异常的情况下，这可能才是你期望的：在 `done(..)` 已失败的处理函数里的任何异常都会抛出一个全局的未捕获异常（通常是在开发者的控制台）。

```js
var p = Promise.resolve(374);

p.then(function fulfilled(msg){
    // 数字不会拥有字符串的方法，
    // 所以会抛出一个错误
    console.log(msg.toLowerCase());
})
.done(null, function() {
    // 如果有异常发生，它就会被全局抛出 
});
```

#### **ES8 发生了什么？ Async/await**

JavaScript ES8 介绍了 `async/await`，使得我们能更简单的使用 Promises。我们将简单的介绍 `async/await` 会带给我们什么以及如何利用它们写出异步的代码。

所以，来让我们看看 async/await 是如何工作的。

使用 `async` 函数声明来定义一个异步函数。这样的函数返回一个 [AsyncFunction](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncFunction) 对象。`AsyncFunction` 对象表示执行包含在这个函数中的代码的异步函数。

当一个 async 函数被调用，它返回一个 `Promise`。当 async 函数返回一个值，它不是一个 `Promise`，`Promise` 将会被自动创建，然后它使用函数的返回值来决定状态。当 `async` 抛出一个异常，`Promise` 使用抛出的值进入已失败状态。

一个 `async` 函数可以包含一个 `await` 表达式，它会暂停执行这个函数然后等待传给它的 Promise 完成，然后恢复 async 函数的执行，并返回已成功的值。

你可以把 JavaScript 的 `Promise` 看作是 Java 的 `Future` 或是 `C#` 的 Task。

> `async/await` 的目的是简化使用 promises 的写法。

让我们来看看下面的例子：

```js

// 一个标准的 JavaScript 函数
function getNumber1() {
    return Promise.resolve('374');
}
// 这个 function 做了和 getNumber1 同样的事
async function getNumber2() {
    return 374;
}
```

同样，抛出异常的函数等于返回已失败的 promises：

```js
function f1() {
    return Promise.reject('Some error');
}
async function f2() {
    throw 'Some error';
}
```

关键字 `await` 只能使用在 `async` 的函数中，并允许你同步等待一个 Promise。如果我们在 `async` 函数之外使用 promise，我们仍然要用 `then` 回调函数：

```js
async function loadData() {
    // `rp` 是一个请求异步函数
    var promise1 = rp('https://api.example.com/endpoint1');
    var promise2 = rp('https://api.example.com/endpoint2');
   
    // 现在，两个请求都被触发, 
    // 我们就等待它们完成。
    var response1 = await promise1;
    var response2 = await promise2;
    return response1 + ' ' + response2;
}
// 但，如果我们没有在 `async function` 里
// 我们就必须使用 `then`。
loadData().then(() => console.log('Done'));
```

你还可以使用 async 函数表达式的方法创建一个 async 函数。async 函数表达式的写法和 async 函数声明差不多。函数表达式和函数声明最主要的区别就是函数名，它可以在 async 函数表达式中省略来创建一个匿名函数。一个 async 函数表达式可以作为一个 IIFE（立即执行函数） 来使用，当它被定义好的时候就会执行。

它看起来是这样的：

```js
var loadData = async function() {
    // `rp` 是一个请求异步函数
    var promise1 = rp('https://api.example.com/endpoint1');
    var promise2 = rp('https://api.example.com/endpoint2');
   
    // 现在，两个请求都被触发, 
    // 我们就等待它们完成。
    var response1 = await promise1;
    var response2 = await promise2;
    return response1 + ' ' + response2;
}
```

更重要的是，所有主流浏览器都支持 async/await：

![](https://cdn-images-1.medium.com/max/800/0*z-A-JIe5OWFtgyd2.)

如果这个兼容情况不是你想要的，那么也可以使用一些 JS 转换器，像 [Babel](https://babeljs.io/docs/plugins/transform-async-to-generator/) 和 [TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-3.html)。

最后，最重要的是不要盲目的选择“最新”的方法去写异步代码。更重要的是理解异步 JavaScript 内部的原理，知道为什么它为什么如此重要以及去理解你选择的方法的内部原理。在程序中每种方法都是有利有弊的。

### 5 个编写可维护的、健壮的异步代码的技巧

1.  **干净的代码:** 使用 async/await 能够让你少写代码。每一次你使用 async/await 你都能跳过一些不必要的步骤：写一个 .then，创建一个匿名函数来处理响应，在回调中命名响应，比如：

```js
// `rp` 是一个请求异步函数
rp(‘https://api.example.com/endpoint1').then(function(data) {
 // …
});
```

对比:

```js
// `rp` 是一个请求异步函数
var response = await rp(‘https://api.example.com/endpoint1');
```

2. **错误处理:** Async/await 使得我们可以使用相同的代码结构处理同步或者异步的错误 —— 著名的 try/catch 语句。让我们看看用 Promises 是怎么实现的：

对比：

```js
async function loadData() {
    try {
        var data = JSON.parse(await getJSON());
        console.log(data);
    } catch(e) {
        console.log(e);
    }
}
```

3. **条件语句:** 使用 `async/await` 来写条件语句要简单得多：

```js
function loadData() {
  return getJSON()
    .then(function(response) {
      if (response.needsAnotherRequest) {
        return makeAnotherRequest(response)
          .then(function(anotherResponse) {
            console.log(anotherResponse)
            return anotherResponse
          })
      } else {
        console.log(response)
        return response
      }
    })
}
```

对比：

```js
async function loadData() {
  var response = await getJSON();
  if (response.needsAnotherRequest) {
    var anotherResponse = await makeAnotherRequest(response);
    console.log(anotherResponse)
    return anotherResponse
  } else {
    console.log(response);
    return response;    
  }
}
```

4. **栈帧:** 和 `async/await` 不同的是，根据promise链返回的错误堆栈信息，并不能发现哪出错了。来看看下面的代码：

```js
function loadData() {
  return callAPromise()
    .then(callback1)
    .then(callback2)
    .then(callback3)
    .then(() => {
      throw new Error("boom");
    })
}
loadData()
  .catch(function(e) {
    console.log(err);
// Error: boom at callAPromise.then.then.then.then (index.js:8:13)
});
```

对比：

```js
async function loadData() {
  await callAPromise1()
  await callAPromise2()
  await callAPromise3()
  await callAPromise4()
  await callAPromise5()
  throw new Error("boom");
}
loadData()
  .catch(function(e) {
    console.log(err);
    // 输出
    // Error: boom at loadData (index.js:7:9)
});
```

5. **调试:** 如果你使用了 promises，你就会知道调试它们将会是一场噩梦。比如，你在 .then 里面打了一个断点，并且使用类似 “stop-over” 这样的 debug 快捷方式，调试器不会移动到下一个 .then，因为它只会对同步代码生效。而通过 `async/await` 你就可以逐步的调试 await 调用了，它就像是一个同步函数一样。

编写 **异步 JavaScript 代码** 不仅对于应用程序本身并且对于库也很重要。

比如，[SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-4-eventloop-outro) 记录 Web 应用、网站中的所有内容：包括所有 DOM 的改变，用户交互，JavaScript 异常，栈追踪，网络请求失败和 debug 信息。

这一切都发生在你的生产环境中而不会影响你的用户体验。我们需要对我们的代码进行大量的优化，使其尽可能的异步，这样我们就能增加被事件循环处理的事件。

而且这不仅是个库！当你在 SessionStack 要恢复一个用户的会话时，我们必须重现所有在用户的浏览器上出现的问题，我们必须重现整个状态，允许你在会话的事件轴上来回跳转。为了做到这一点，我们大量地使用了JavaScript 提供的异步操作。

我们有一个免费的计划可以让你[免费开始](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-4-eventloop-GetStarted)。

![](https://cdn-images-1.medium.com/max/800/0*xSEaWHGqqlcF8g5H.)

更多资源：
* [https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch2.md](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch2.md)
*   [https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md)
* [http://nikgrozev.com/2017/10/01/async-await/](http://nikgrozev.com/2017/10/01/async-await/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
