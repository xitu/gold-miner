> * 原文地址：[AJAX POLLING IN REDUX PART 2: SAGAS](http://notjoshmiller.com/ajax-polling-part-2-sagas/)
> * 原文作者：[Josh M](http://notjoshmiller.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-part-2-sagas.md](https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-part-2-sagas.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[yoyoyohamapi](https://github.com/yoyoyohamapi)，[FateZeros](https://github.com/FateZeros)

# 在 Redux 中使用 AJAX 轮询（二）：Saga 篇

不久之前我写了一篇关于在 React 中使用 AJAX 轮询的短文，内容可以概括为如何发起和控制周期性 AJAX 请求。文中我证明了通过使用组件生命周期方法，原生 React 和 Redux 在技术上就足以解决 AJAX 轮询的控制问题。随着时间推移，在使用中我发现这个方法需要开发者非常细心地筛选和管理 `componentWillReceiveProps` 中传入的 props 。最终，我的目标变成了尽可能地清除组件中的异步逻辑。

在 Redux 生态中，已有不少管理副作用（side effect）的类库，从最基础的 [redux-thunk](https://github.com/gaearon/redux-thunk)，到受 Elm 熏陶的 [redux-loop](https://github.com/raisemarketplace/redux-loop)，最后还有使用 Generator 函数强力驱动的 [redux-saga](https://github.com/yelouafi/redux-saga/)。

理想情况下，我喜欢把所有的异步请求都放置到一个 API 中间件中，这种用法可以参考 Redux 官方实例 [real-world example](https://github.com/reactjs/redux/tree/master/examples/real-world)。若使用 thunk 会使我的 Action 创建函数被异步逻辑所污染，所以 `redux-thunk` 已然出局。使用 `redux-loop` 则会与我的中间件相冲突，作为 store 的一个 enhancer 它却修改了 store 的 signature，进而导致其下游的所有中间件都需要调整。所以综上我决定探索 `redux-saga`，它本质上提供给我的是在应用后台执行任务的能力。使用 `redux-saga` 可以保证我利用中间件集中控制异步逻辑的用法不变，同时通过设定各类不同的观察者（watcher）来触发副作用。那么如何使用 redux-sage 处理 AJAX 轮询呢？

```
// 延时副作用的工具函数
function delay(millis) {  
    const promise = new Promise(resolve => {
        setTimeout(() => resolve(true), millis)
    });
    return promise;
}

// 每隔 20 秒获取一次数据                                           
function* pollData() {  
    try {
        yield call(delay, 20000);
        yield put(dataFetch());
    } catch (error) {
        // 取消异常 -- 如果你愿意也可以捕获
        return;
    }
}

// 等待上一次数据请求返回成功后，发起下一轮轮询
// 如果用户登出，则取消本次未完成的轮询                                          
function* watchPollData() {  
    while (true) {             
        yield take(DATA_FETCH_SUCCESS);
        yield race([
            call(pollData),
            take(USER_LOGOUT)
        ]);
    }
}

// 让各类任务在后台并行运行                       
export default function* root() {  
    yield [
        fork(watchPollData)
        // 此处可包含其他观察者
    ];
}
```

这种以 sagas 存在的轮询逻辑让开发者免于处理组件中潜在的复杂生命周期。我在 race 条件中添加了 `USER_LOGOUT` Action，这样可以代劳之前 `componentWillUnmount` 中 `clearTimeout` 的工作。当发送 logout Action 后，运行中的 `pollData` saga 就可以被很好地中断执行。

其余涉及到的逻辑如下：

`dataFetch` -- 它是一个 Action 创建函数，产生的 Action 会被 API 中间件拦截并处理。在中间件中会发起真正的 API 请求，并根据请求结果发出一系列后续 Action。

`watchPollData` -- 它是一个随应用启动并一直运行的 saga。启动后它会阻塞 saga 执行并监听 `DATA_FETCH_SUCCESS` Action 的发出。一旦监听到相应的 Action 被发出，它就解除阻塞继续执行后续的 `pollData` saga。

`pollData` -- 先阻塞 Generator 函数的执行，20秒后再调用 `dataFetch` 并 dispatch `dataFetch` 产生的 Action。

此处用到的 `take`、 `put`、 `race`、 `call` 和 `fork` 作用符，都可以在 [redux-saga documentation](http://yelouafi.github.io/redux-saga/docs/api/index.html#effect-creators) 中找到。

你可以将本文的新方法与前一篇文章中在组件内做控制的方法作比较，使用 saga 后更利于预测和集中管理我的副作用。需要注意的是并不是所有的浏览器都支持 Generator 函数，如果你使用了 ES2015 和 Babel，那么它们已经提供了 Generator 函数的浏览器 polyfill 兼容支持。

现在所有的数据容器（组件）只需在挂载的时候简单地调用一次 `dataFetch()` 即可，之后我们的 saga 就会自动接管所有的轮询工作。非常简而美吧。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
