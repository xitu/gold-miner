> * 原文地址：[AJAX POLLING IN REACT WITH REDUX](http://notjoshmiller.com/ajax-polling-in-react-with-redux/)
> * 原文作者：[Josh M](http://notjoshmiller.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-in-react-with-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO/ajax-polling-in-react-with-redux.md)
> * 译者：
> * 校对者：

# AJAX Polling in React with Redux

> Update: Check out a more recent article on using redux-saga for polling here: [http://notjoshmiller.com/ajax-polling-part-2-sagas/](http://notjoshmiller.com/ajax-polling-part-2-sagas/)

Sometimes life gives you lemons. Sometimes your API doesn't stream events. Polling with AJAX is a common workaround for keeping client-side state in sync with time-dependent server-side state. Most of us know that `setInterval` is not optimal for this, but its cousin `setTimeout` can be used in [recursive solutions](http://stackoverflow.com/questions/14027005/simple-long-polling-example-with-javascript-and-jquery).

How can we reconcile naive polling with the reactive data flow that React and Redux prescribe for us? RxJS and other observable variants are a good choice, but unless your project is already harnessing observables then it's probably not worth pulling them in for one problem. A possible solution is already available in the form of React component lifecycle methods and Redux actions. What might this look like?

Let's first visualize our state via a Redux reducer:

```
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

I won't cover how to handle asynchronous action creators here, but there are good examples in the Redux docs. Just assume we have middleware that can handle the action types illustrated here. I will be using an action creator signature similar to the one found in the [real-world example](https://github.com/rackt/redux/tree/master/examples/real-world).

So our action creator for this model might look like:

```
export function dataFetch() {  
  return {
    [CALL_API]: {
      types: [DATA_FETCH_BEGIN, DATA_FETCH_SUCCESS, DATA_FETCH_ERROR],
      endpoint: 'api/data/'
    }
  };
}
```

Super basic, but let's now think about how you would poll this endpoint. Should you set a timer in the reducer? The action creator? Perhaps even the middleware? What about the smart component itself? I vote for the component, since it should be able to handle its own data dependencies, and we can control our timer with lifecycle methods. How would that look?

```
import React from 'react';  
import {connect} from 'react-redux';  
import {bindActionCreators} from 'redux';  
import * as DataActions from 'actions/DataActions';

// Which part of the Redux global state does our component want to receive as props?   
function mapStateToProps(state) {  
    return {
        data: state.data.data,
        isFetching: state.data.isFetching
    };
}

// Which action creators does it want to receive by props?       
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

            // Optionally do something with data

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

And that's basically it. The component needs data so it fetches while mounting. When `dataFetch` dispatches a new action our reducer returns new state, triggering `componentWillReceiveProps`, which clears any pending timers and only starts a new timer if we aren't already fetching.

Granted there are other ways to handle this approach, and of course this kind of polling is discouraged if any kind of long-polling is available, but I hope this helps illustrate what is possible when combining React lifecycle methods with the kind of data flow afforded by Redux.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
