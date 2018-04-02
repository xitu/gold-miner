> * 原文地址：[Don’t call me, I’ll call you: Side effects management with Redux-Saga (Part 1)](https://medium.com/appsflyer/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1-d0a92c3f81be)
> * 原文作者：[David Dvora](https://medium.com/@daviddvora?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[smileShirely](https://github.com/smileShirely) [ClarenceC](https://github.com/ClarenceC)

# Don’t call me, I’ll call you：使用 Redux-Saga 管理 React 应用中的异步 action（上）

![](https://cdn-images-1.medium.com/max/800/1*v-_1QMuWsWYoB-AY78nArQ.png)

在接下来的两篇文章中，我想谈谈在 React 应用中使用 Redux-Saga 进行异步 action 管理的基础和进阶方法。我会说明为什么我们会在 **AppsFlyer** 项目中使用它，以及它可以解决什么问题。

本篇文章主要介绍 Redux-Saga 相关的基本概念，下篇专门讨论 Redux-Saga 可以解决哪些问题。请注意：阅读这两篇文章，你要对 [React](https://reactjs.org/) 和 [Redux](https://redux.js.org/) 有一定的了解。

#### Generators 先行！

为了理解 Sagas，我们首先要理解什么是 Generator。下面是 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function%2A) 对 Generator 的描述：

> Generator 是在执行时能暂停，后面又能从暂停处继续执行的函数。它的上下文会在继续执行时保存。

你可以把 Generator 理解成一种遍历器对象生成函数，（译注：Generator 执行后返回的遍历器对象）提供一个 `next` 方法。执行这个方法就会返回下一个状态，或者返回遍历结束的状态。这就需要 Generator 能够维护内部状态。

下面是一个基本的 Generator 示例，它生成的遍历器对象会返回几个字符串：

```
function* namesEmitter() {
  yield "William";
  yield "Jacob";
  return "Daniel";
}

// 执行 Generator
var generator = namesEmitter();

console.log(generator.next()); // prints {value: "William", done: false}

console.log(generator.next()); // prints {value: "Jacob", done: false}

console.log(generator.next()); // prints {value: "Daniel", done: true}
```

`next` 方法的返回值结构非常简单 — 只要我们通过 `yield/return` 返回值，这个返回值就是 `value` 属性的值。如果我们没有返回值，`value` 属性的值就是 **undefined**，`done` 属性的值就是 `true`。
还有一点值的注意的是，执行 `namesEmitter` 后，函数会在调用 `yield` 的地方停下来。当我们调用 `next` 方法后，函数会继续执行，直到遇到下一个 `yield`。如果我们调用了 `return` 语句或者函数执行完毕，`done` 属性就会为真。

如果状态序列的长度不确定时，我们可以用下面的方法来写：

```
var results = generator.next();
while(!results.done){
 console.log(results.value);
 results = generator.next();
}
console.log(results.value);
```

#### 什么是 Sagas？

Sagas 是通过 Generator 函数来创建的。[官方文档](https://github.com/redux-saga/redux-saga) 的解释如下：

> Saga 就像应用中的一个独立线程，完全负责管理异步 action。

你可以把 Saga 想象成一个以最快速度不断地调用 `next` 方法并尝试获取所有 `yield` 表达式值的线程。你可能会问这和 React 有什么关系，为什么要使用它，所以首先来看看如何在 React & Redux 应用使用 Saga：

在 React & Redux 应用中，一个常见的用法从调用一个 action 开始。被分配用来处理这个 action 的 reducer 会使用新的 state 更新 store，随后视图就会被更新渲染。
如果一个 Saga 被分配用来处理这个 action — 这个 action 通常就是个异步 action（比如一个对服务端的请求），一旦这个 action 完成后，Saga 会调用另一个 action 让 reducer 进行处理。

#### 常见用例

我们可以通过一个常见流程来说明：
用户与页面进行交互，这个交互动作会触发一个从服务端请求数据的动作(此时页面显示 loading 提示)，最终我们用请求回来的数据去渲染页面的内容。
让我们为每步创建一个 action，然后用 Redux-Saga 实现一个简化的版本如下：

```
// saga.js
import { take } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
}
```

这个 Saga 的函数名叫做 `mySaga`。它调用了 Redux-Saga [effect](https://redux-saga.js.org/docs/api/#effect-creators) 的 [`take`](https://redux-saga.js.org/docs/api/#takepattern) 方法，这个方法会**阻塞**Saga的执行，直到有人调用了作为参数的那个 action，Saga 的执行也会结束，就像我们前面看到的 Generator 一样（done 变为 true）。

现在我们要让页面展示 loading 提示来响应这个 action。可以通过 [`put`](https://redux-saga.js.org/docs/api/#putaction) 方法调用另一个 action，然后分配 reducer 来处理，从而完成上述功能。如下：

```
// saga.js
import { take, put } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
    yield put(SHOW_LOADING_ACTION, {isLoading: true});
}

// reducer.js
...
case SHOW_LOADING_ACTION: (state, isLoading) => {
    return Object.assign({}, state, {showLoading: isLoading});
}
...
```

下一步是调用 [`call`](https://redux-saga.js.org/docs/api/#callfn-args) 方法，它接收一个函数和一组参数，使用这些参数来执行这个函数。我们给 `call` 方法传递一个请求服务端并返回一个 Promise 的 `GET` 函数，它会保存请求结果：

```
// saga.js
import { take, put, call } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
    yield put(SHOW_LOADING_ACTION, {isLoading: true});
    const data = yield call(GET, 'https://my.server.com/getdata');
    yield put(SHOW_DATA_ACTION, {data: data});
}

// reducer.js
...
case SHOW_DATA_ACTION: (state, data) => {
    return Object.assign({}, state, {data: data, showLoading: false};
}
...
```

通过调用 SHOW_DATA_ACTION 来用接收的数据更新页面。

#### 刚刚发生了什么？

应用启动后，所有的 Sagas 都会被执行，你可以认为一直在调用 `next` 方法直到结束。`take` 方法类似于线程挂起的作用，一旦调用了**USER_INTERACTED_WITH_UI_ACTION**，线程就会恢复执行。

然后，我们继续调用 **SHOW_LOADING_ACTION**，reducer 会处理这个 action。由于 Saga 还在继续运行，`call` 方法会发起对服务端的请求，Saga 会在再次挂起，直到请求结束。

#### 每次都使用

在上面的例子中，Saga 只处理了一个用户交互的 action，因为我们用 `put` 方法执行了 `SHOW_DATA_ACTION` 这个 action，然后后面就没有 yield 了（done 就是 true 了对吧？）。

如果我们希望在每次调用 `USER_INTERACTED_WITH_UI_ACTION` 这个 action 的时候，都会执行这一系列的 actions，我们可以用 `while(true)` 语句来包裹 Saga 内部的逻辑代码。完整代码如下：

```
// saga.js
import { take, put, call } from 'redux-saga/effects'

1. function* mySaga(){
2.   while (true){
3.    yield take(USER_INTERACTED_WITH_UI_ACTION);
4.    yield put(SHOW_LOADING_ACTION, {isLoading: true});
5.    const data = yield call(GET, 'https://my.server.com/getdata');
6.    yield put(SHOW_DATA_ACTION, {data: data});
7.  }
8. }

// reducer.js
...
case SHOW_LOADING_ACTION: (state, isLoading) => {
    return Object.assign({}, state, {showLoading: isLoading});
},
case SHOW_DATA_ACTION: (state, data) => {
    return Object.assign({}, state, {data: data, showLoading: false};
}
...
```

这个无限循环**不会**造成堆栈溢出，**也不会**使你的应用崩溃！因为 `take` 方法就像线程挂起一样，`mySaga` 执行后会一直保持 `pending` 状态，直到那个 action 被触发。下次重新进入循环后，也会重复上述过程。

让我们一步步地看一下上面的过程：
1. 应用启动，执行所有 Sagas。
2. **mySaga** 运行，进入 `while(true)` 循环，在第 3 行挂起。
3. `USER_INTERACTED_WITH_UI_ACTION` 这个 action 被触发。
4. Saga 的线程激活，执行第 4 行，触发 `SHOW_LOADING_ACTION` 这个 action，然后分配的 reducer 进行处理（reducer 处理后，页面就会显示 loading 提示）。
5. 发送一个请求到服务端（第 5 行），然后会再次挂起，直到请求的 Promise 变为 resolved，请求结果的数据会赋值给 data 变量。
6. `SHOW_DATA_ACTION` 接收 data 作为参数被触发，然后 reducer 就可以使用这些数据来更新页面。
7. 再次进入循环，回到第 2 步。

#### 接下来

在这篇文章中，我们介绍了 Redux-Saga 相关的基本概念，展示了如何在 React 应用中使用它。下篇文章中，我会展示在实际应用中使用它获得的价值。

感谢 [Yotam Kadishay](https://medium.com/@kadishay?source=post_page) 和 [Liron Cohen](https://medium.com/@lironch?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
