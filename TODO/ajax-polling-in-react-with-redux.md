> * 原文地址：[AJAX POLLING IN REACT WITH REDUX](http://notjoshmiller.com/ajax-polling-in-react-with-redux/)
> * 原文作者：[Josh M](http://notjoshmiller.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-in-react-with-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-in-react-with-redux.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[yoyoyohamapi](https://github.com/yoyoyohamapi)，[FateZeros](https://github.com/FateZeros)

# 在 React & Redux 中使用 AJAX 轮询

> 更新：查看最新关于使用 redux-saga 进行轮询的文章：[http://notjoshmiller.com/ajax-polling-part-2-sagas/](http://notjoshmiller.com/ajax-polling-part-2-sagas/)

正如生活不总是给予你所需之物，你所用的 API 也不总是支持流式事件。因此，当你需要把一些有时序依赖的状态从服务端同步到客户端时，一个常用的 “曲线救国” 方法就是使用 AJAX 进行接口轮询。我们大部分人都知道使用 `setInterval` 并不是处理轮询的 “最佳人选”，不过它的堂兄 `setTimeout` 配合 [递归解法](http://stackoverflow.com/questions/14027005/simple-long-polling-example-with-javascript-and-jquery) 却可以大展身手。

React & Redux 为我们提供了响应式的数据流，我们如何才能使普通的轮询方法与其和谐共处？RxJS 以及其他 Observable 类库是处理轮询的不错选择，不过除非你的项目已经集成了 Observable 类库，否则仅为解决轮询而引入相关类库显得并不值当。当前通过结合 React 组件的生命周期方法和 Redux 的 Action 就已经足够处理 AJAX 轮询，下面来看看如何得解？

首先通过 Redux 的 Reducer 来说明当前 State：

```javascript
const initialState = {  
    data: {},
    isFetching: false
};

export function data (state = initialState, action) {  
    switch (action.type) {
    case DATA_FETCH_BEGIN: {
        return { ...state, isFetching: true };
    }
    case DATA_FETCH_SUCCESS: {
        return { isFetching: false, data: { ...state.data, action.payload }};
    }
    case DATA_FETCH_ERROR: {
        return { ...state, isFetching: false };
    }
    default:
        return state;
}
```

我不会在这里去讲解如何处理 Redux 中的异步 Action 创建函数，想更好地了解这方面知识请参考 Redux 文档中的异步示例。 现在只需假设我们已有相关的 Redux 中间件来处理本文提到的各种 Action 。我会使用与 [real-world example](https://github.com/rackt/redux/tree/master/examples/real-world)（译注：原文链接的仓库已不存在，可以参考 Redux 文档中同名例子）中相似形式的 Action 创建函数。

对应上方的数据模型，我们的 Action 创建函数可能为：

```javascript
export function dataFetch() {  
  return {
    [CALL_API]: {
      types: [DATA_FETCH_BEGIN, DATA_FETCH_SUCCESS, DATA_FETCH_ERROR],
      endpoint: 'api/data/'
    }
  };
}
```

回到最初的问题，让我们想想你会如何实现 API 接口的轮询。你会把轮询的定时器设置在 Reducer 中？还是 Action 创建函数里？或许是中间件里？如果把定时器放到 Smart 组件（译注：参看 [Smart and Dumb Components - Medium](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)）中怎么样呢？我会选择在组件中设置定时器，不仅是因为组件需要控制自身的数据依赖，而且我们可以通过组件的生命周期方法控制这些定时器，看看如何做到？

```javascript
import React from 'react';  
import {connect} from 'react-redux';  
import {bindActionCreators} from 'redux';  
import * as DataActions from 'actions/DataActions';

// 组件需要哪些 Redux 全局状态作为 props 传入？
function mapStateToProps(state) {  
    return {
        data: state.data.data,
        isFetching: state.data.isFetching
    };
}

// 组件需要哪些 Action 创建函数作为 props 传入？
function mapDispatchToProps(dispatch) {  
    return {
        dataActions: bindActionCreators(DataActions, dispatch)
    };
}

@connect(mapStateToProps, mapDispatchToProps)
export default class AppContainer {  
    componentWillReceiveProps(nextProps) {
        if (this.props.data !== nextProps.data) {

            clearTimeout(this.timeout);

            // 你可以在这里处理获取到的数据

            if (!nextProps.isFetching) {
                this.startPoll();
            }
        }

    }

    componentWillMount() {
        this.props.dataActions.dataFetch();
    }

    componentWillUnmount() {
        clearTimeout(this.timeout);
    }

    startPoll() {
        this.timeout = setTimeout(() => this.props.dataActions.dataFetch(), 15000);
    }
}
```

好了，大功告成。因为上面的组件需要一些额外数据进行渲染，所以它会在挂载的时候尝试获取这些数据。 当 `dataFetch` 发送了一个新 Action 后，我们的 Reducer 会返回新的状态， 进而触发组件的 `componentWillReceiveProps` 方法。在这个生命周期方法内会首先清除所有进行中的定时器，若当前没有进行数据请求则随即启动一个新定时器。

诚然还有很多方法可以处理这里的接口轮询问题，并且如果有任何长轮询方法可用时，此处的轮询方法便相形见绌。不过我还是希望这篇文章可以帮助阐明结合 React 生命周期方法和 Redux 数据流的处 “事” 之道。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
