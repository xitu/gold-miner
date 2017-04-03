> * 原文地址：[How to make your React app fully functional, fully reactive, and able to handle all those crazy side effects](https://medium.freecodecamp.com/how-to-make-your-react-app-fully-functional-fully-reactive-and-able-to-handle-all-those-crazy-e5da8e7dac10#.amw15u5zd)
* 原文作者：[Luca Matteis](https://medium.freecodecamp.com/@lmatteis)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZhangFe ](https://github.com/ZhangFe)
* 校对者：[AceLeeWinnie](https://github.com/AceLeeWinnie)，[liucaihua9](https://github.com/liucaihua9)

# 如何让你的 React 应用完全的函数式，响应式，并且能处理所有令人发狂的副作用

![](https://cdn-images-1.medium.com/max/2000/1*lD7IVk_sCcOcgVDOJPn7cA.jpeg)

[函数响应式编程](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) (FRP) 是一个在最近获得了无数关注的编程范式，尤其是在 JavaScript 前端领域。它是一个有很多含义的术语，却描述了一个极为简单的想法:

> 所有的事物都应该是纯粹的以便于测试和推理 **（函数式）**，并且使用随时变化的值给异步行为建模 **（响应式）**。

React 本身并非完全的函数式，也不是完全的响应式。但是它受到了一些来自 FRP 背后理念的启发。例如 [函数式组件](https://facebook.github.io/react/docs/components-and-props.html) 就是一些依赖他们 props 的纯函数。 并且 [他们响应了 prop 和 state 的变化](https://facebook.github.io/react/docs/react-component.html#updating).
(译者注：无状态组件只接收 props ，这里的 state 应该是指父元素的）

但是一谈到**副作用的处理**（side effects），仅作为视图层的 React 就需要一些其他库的帮助了，比如说[Redux](https://github.com/reactjs/redux)。

在这篇文章里我会谈谈 [redux-cycles](https://github.com/cyclejs-community/redux-cycles)，它是一个 Redux 中间件，借助 [Cycle.js](https://cycle.js.org/) 框架的优势，帮助你以一种函数式和响应式的方法处理你 React 应用中的副作用和异步代码，这是一个尚未被其他 Redux 副作用模型共享的特征。

![](https://cdn-images-1.medium.com/max/1000/1*G_eskQOkhm6nv-NDylvbjw.jpeg)

### 什么是副作用？

副作用即是改变了外部世界的行为。你的应用里所有发出 HTTP 请求，写入 localStorage 的操作，或者甚至操作 DOM 都被认为是副作用。

副作用是不好的，他们很难去测试，维护起来很复杂，并且通常你的 bug 都出现在这里。因此你的目标就是最小化或者定位他们。

![](https://cdn-images-1.medium.com/max/800/1*GENmEdK1Rq2dB6H4uxzVNw.jpeg)

> “由于有副作用的存在，一个程序的行为依赖于历史记录，即代码执行的顺序，因为理解一个有效的程序需要考虑到所有可能的历史记录，副作用经常会使一个程序很难理解。” —  [Norman Ramsey](http://stackoverflow.com/users/41661/norman-ramsey)

以下是几种现今用来处理 Redux 中的副作用比较流行的方法：

1. [redux-thunk](https://github.com/gaearon/redux-thunk)  — 将你有副作用的代码放在 action creators 中
2. [redux-saga](https://github.com/redux-saga/redux-saga)  —  使用 saga 声明你的副作用逻辑
3. [redux-observable](https://github.com/redux-observable/redux-observable)  —  使用响应式编程来给副作用建模

然而问题是以上方法中没有一个既是纯函数式的又是响应式的。他们中有的（redux-saga）是纯函数有些（redux-observable）则是响应式的，但是没有一个拥有我们前文介绍的 FRP 所拥有的所有的概念。

[**Redux-cycles**](https://github.com/cyclejs-community/redux-cycles) **既是纯函数又是响应式的**

![](https://cdn-images-1.medium.com/max/800/1*KJuc4SE0zrxXuxBrfOpGjA.png)

首先我们会更详细地解释这些函数式和响应式的概念以及为什么你需要关心这些，然后会详细介绍 redux-cycles 是如何工作的。

---

### 使用 Cycle.js 以纯函数的方式处理副作用

HTTP 请求大概是最常见的副作用了。下面是一个使用 redux-thunk 发出 HTTP 请求的例子：

    function fetchUser(user) {
      return (dispatch, getState) => 
      fetch(`https://api.github.com/users/${user}`)
    }

这个函数是命令式的。虽然它返回了一个 promise 并且你可以使用其他 promises 来链式调用它，但是 `fetch()` 已经执行了，在这个特定时刻它已经不是一个纯函数了。

这同样适用于 redux-observable:

    const fetchUserEpic = action$ =>
      action$.ofType(FETCH_USER)
        .mergeMap(action =>
      ajax.getJSON(`https://api.github.com/users/${action.payload}`)
            .map(fetchUserFulfilled)
        );

`ajax.getJSON()` 使得这段代码是命令式的。

**为了保证一个 HTTP 请求是纯粹的，你不应该去想“立刻发送一个 HTTP 请求”而是应该“描述一下我希望 HTTP 请求是什么样的”并且不要担心它何时发出去或者谁调用了它**

这就是你在 [Cycle.js](https://cycle.js.org/) 中编写所有代码的本质。你使用这个框架所做的每件事都是创建你想做某事的描述。这些描述之后会被发送给那些实际关心 HTTP 请求的 [**drivers**](https://cycle.js.org/drivers.html) （通过响应式数据流）。

    function main(sources) {
      const request$ = xs.of({
        url: `https://api.github.com/users/foo`,
      });

      return {
        HTTP: request$
      };
    }

就像你在上面这个代码片段中看到的，我们并没有调用函数去发出请求。如果你执行这段代码你会发现请求立即就发出了，那么背后究竟发生了什么呢？

神奇之处就在于 drivers。当你的函数返回了一个包含 `HTTP` 键值的对象时，Cycle.js 知道需要处理它从数据流收到的消息，并且执行相应的 HTTP 请求（通过 HTTP driver）。

![](https://cdn-images-1.medium.com/max/1000/1*2eF9bIE5BQExjIg1navQ-Q.png)

**关键的一点是，你虽然没有摆脱副作用，HTTP 请求依然要发出，但是你将它定位在了你的应用代码之外**

你的函数更加容易理解，尤其是更容易测试，因为你只要测试你的函数是否发出了正确的消息，不需要浪费那些无用的 mock 时间。

### 响应式副作用

在之前的例子里我们提到了响应式。这需要有一种和这些 drivers 沟通“在外部世界做某事”和被告知“外部世界有某事已经发生了”的方式。

[Observables](http://reactivex.io/documentation/observable.html) (aka streams) 是对于这类异步交互的完美抽象。

![](https://cdn-images-1.medium.com/max/800/1*Y9HjN7iA7k6QQm_l7MaP9w.png)

每当你想“做某事”时，你会向输出流发出你想做什么的描述。在 Cycle.js 里这些输出流被称作 **sinks**。

每当你想“被通知某事”你只要使用一个输入流（被称作**sources**）并且遍历一次流的值就能知道发生了什么。

这形成一种 **反应式** **循环**，相比于一般的命令式代码，你需要一个不同的思维来理解它。
让我们使用这个范例来建模一个HTTP请求/响应生命周期：

    function main(sources) {
      const response$ = sources.HTTP
        .select('foo')
        .flatten()
        .map(response => response);

      const request$ = xs.of({
        url: `https://api.github.com/users/foo`,
        category: 'foo',
      });

      const sinks = {
      HTTP: request$
      };
      return sinks;
    }

HTTP driver 知道这个函数返回的 `HTTP` 键值。这是一个包含请求 GitHub 链接的 HTTP 请求流描述。它正在告诉 HTTP driver ：“我想要请求这个地址”。 

之后这个 dirver 知道要执行请求，并且将返回值作为 sources（sources.HTTP）返回给 main 函数 — 注意 sinks 和 sources 使用相同的键值。

让我们再解释一次：**我们用** **`sources.HTTP`** 来 **“被通知 HTTP 已经返回了”，并且我们返回了`sinks.HTTP` 来“发送 HTTP请求”**。

这里有一个动画来解释这一重要的响应式循环：

![](https://cdn-images-1.medium.com/max/1000/1*RfpxAyyI0h0itIABMZ9TfA.gif)

相比于一般的命令式编程，这似乎是反直觉的：为什么读取响应值的代码在发出请求的代码之前？

这是因为在 FRP 中代码在哪是不重要的。所有你要做的就是发送描述，并且监听变化，代码的顺序并不重要。

这使得代码非常容易重构。

---

### 介绍 redux-cycles

![](https://cdn-images-1.medium.com/max/800/1*_iikpPfUOR9f04iFGDJQLA.png)

此时你可能会问，所有的这些和我的 React 应用有什么关系？

仅仅通过写一些你想做某事的描述，你已经学习到了使用纯函数的优势，并且学习了用观察者去和外部世界交流的优势。

现在，你将看到如何在你当前的 React 应用里使用这些概念去变成完全的函数式和响应式。

#### 拦截并且调度 Redux 行为

使用 Redux 时你需要 dispatch actions 来告诉你的 reducers 你需要一个新的state。 

这是一个同步的流程，意味着一旦你想执行异步行为（为了副作用）你需要使用一些中间件来拦截这些 actions，相应的，你要触发其他的 actions 来执行这个异步副作用。

这正是 [redux-cycles](https://github.com/cyclejs-community/redux-cycles) 所做的。它是一个中间件，拦截了 redux actions 后进入 Cycle.js 的响应式循环，并且允许你使用 drivers 去执行其他副作用。然后它基于你函数里的异步数据流描述 dispatch 一个新的 action。

    function main(sources) {
      const request$ = sources.ACTION
        .filter(action => action.type === FETCH_USER)
        .map(action => ({
          url: `https://api.github.com/users/${action.payload}`,
          category: 'users',
        }));
    
      const action$ = sources.HTTP
        .select('users')
        .flatten()
        .map(fetchUserFulfilled);
    
      const sinks = {
      ACTION: action$,
        HTTP: request$
      };
      return sinks;
    }


在上面这个例子里有一个新的 source 和 sink - **`ACTION`**。但是数据通信的模式是一致的。

它使用 `sources.ACTION` 来监听被 Redux 调用的 actions。并且通过返回 `sinks.ACTION` 来dispatch 新的 actions。

具体点说它是触发了标准的 [Flux Actions objects](https://github.com/acdlite/flux-standard-action)。

最酷的事情是你可以结合其他 drivers 发生的事。在之前的例子里 **在 `HTTP` 域里发生的事确实触发了 `ACTION` 域，反之亦然**。

— 注意，与 Redux 的通信完全通过 `ACTION` 的 source 和 sink。Redux-cycle 的 drivers 负责处理实际的 dispatch。

![](https://cdn-images-1.medium.com/max/1000/1*A30wroaUd6WiLjq5c-fxYw.gif)

### 更复杂的应用程序?

如果只写那些转换数据流的纯函数该如何开发一个复杂的应用呢？

使用[已有的 drivers](https://github.com/cyclejs-community/awesome-cyclejs#drivers)你已经可以做很多事了。或者你可以创建你自己的 drivers — 下面是一个简单的 driver，它在控制台上输出了写入其 sink 的消息。


    run(main, {
      LOG: msg$ => msg$.addListener({
        next: msg => console.log(msg)
      })
    });

`run` 是 Cycle.js 的一部分，它执行你的 main 函数（第一个参数）并且传入其他所有的 drivers（第二个参数）。

Redux-cycles 推荐了两个你可以和 Redux 通信的 drivers， `makeActionDriver()` & `makeStateDriver()`:

    import { createCycleMiddleware } from 'redux-cycles';

    const cycleMiddleware = createCycleMiddleware();
    const { makeActionDriver, makeStateDriver } = cycleMiddleware;

    const store = createStore(
      rootReducer,
      applyMiddleware(cycleMiddleware)
    );

    run(main, {
      ACTION: makeActionDriver(),
      STATE: makeStateDriver()
    })

`makeStateDriver()` 是一个只读的 driver。这意味着在你的 main 函数里只能读取`sources.STATE`。你不能让它做什么，只能从它读取数据。

每当 Redux 的 state 发生了变化，`sources.STATE` 流就会触发产生一个新的 state 对象。[当你需要基于当前应用的数据写一些特定逻辑时](https://github.com/cyclejs-community/redux-cycles#drivers) 非常有用

![](https://cdn-images-1.medium.com/max/2000/1*YyiXu9GK7EKVUHQZnZnsKw.png)

### 复杂的异步数据流

![](https://cdn-images-1.medium.com/max/800/1*7OmEwOnki2v-cR7mESwD7w.gif)

响应式编程的另一个巨大优势就是能够使用运算符将流组成其他流，可以随时将它们当做数据对待：你可以对它们进行 [`map`](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/gettingstarted/categories.md) [`filter`](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/gettingstarted/categories.md) [`甚至`](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/gettingstarted/categories.md) [`reduce`](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/gettingstarted/categories.md) 这些操作。

运算符使得显式的数据流图（即操作符之间的依赖逻辑）成为可能。允许你通过各种操作符将数据流可视化，就像上面的动画一样。

Redux-observable 也允许你写复杂的异步流，他们用一个复杂的 WebSocket 例子作为它们的卖点，然而以纯函数的方式编写这些流才是 Cycle.js 真正区别于其他方式的强大之处。

> 由于一切都是纯数据流，我们可以想象到未来的编程将只是将操作符块连接到一起。

### 使用弹子图（marble diagrams）测试

![](https://cdn-images-1.medium.com/max/800/1*2uZuH38HrfZwZNgjJB3eNg.png)

最后但也值得关注的是测试。这才是 redux-cycles（和通常所有的 Cycle.js 应用一样）真正闪耀的地方。

因为你的应用代码里都是纯函数，要测试你的主要功能，你只需要将其作为输入流，并将特定流作为输出即可。

使用这个很棒的 [@cycle/time](https://github.com/cyclejs/time) 项目，你甚至可以画一个 [弹子图](http://rxmarbles.com/) 并且以一种可视化的方式去测试你的函数：

    assertSourcesSinks({
      ACTION: { '-a-b-c----|': actionSource },
      HTTP:   { '---r------|': httpSource },
    }, {
      HTTP:   { '---------r|': httpSink },
      ACTION: { '---a------|': actionSink },
    }, searchUsers, done);

[这段代码](https://github.com/cyclejs-community/redux-cycles/blob/master/example/cycle/test/test.js) 执行了 [`searchUsers`](https://github.com/cyclejs-community/redux-cycles/blob/master/example/cycle/index.js#L31) 函数，将特定源作为输入（以第一个参数的方式）。给定的这些 sources 期望函数返回所提供的 sinks（以第二个参数的方式）。如果不是，断言就会失败。

当你需要测试异步行为时，以图形的方式定义流特别有用。

当 `HTTP` 源发出一个 `r` （响应），你会立刻看到 `a`（action）出现在 `ACTION` sink 中 — 他们同时发生。然而，当  `ACTION` source 发出一段 `-a-b-c`，你不要指望此时 `HTTP` sink 会发生什么。

这是因为 `searchUsers` 去抖了他接收到的 actions。它只会在 ACTION source 流停止活动 800 毫秒后发送 HTTP 请求，这是一个自动完成的功能。

测试这种异步行为对于纯函数和响应式函数来说是微不足道的。

### 结论

在这篇文章里我们介绍了 FRP 的真正力量。我们介绍了 Cycle.js 和它新颖的范式。如果你想学习更多的关于 FRP 的知识，Cycle.js [awesome list](https://github.com/cyclejs-community/awesome-cyclejs) 是一个很重要的资源。

只使用 Cycle.js 本身而不使用 React 或者 Redux 可能有点痛苦， 但是如果你愿意放弃一些来自 React 或 Redux 社区的技术和资源的话还是可以做到的。

另一方面，Redux-cycles 允许你继续使用所有的伟大的 React 的内容并且使用 FRP 和 Cycles.js 使你更加轻松。

也十分感谢 [Gosha Arinich](https://medium.com/@goshakkk) 以及 [Nick Balestra](https://medium.com/@nickbalestra) 和我一起维护这个项目，也谢谢 [Nick Johnstone](https://twitter.com/widdnz) 校对这篇文章。

