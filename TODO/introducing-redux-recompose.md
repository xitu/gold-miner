> * 原文地址：[Introducing redux-recompose: Tools to ease Redux actions and reducers development](https://medium.com/wolox-driving-innovation/932e746b0198)
> * 原文作者：[Manuel V Battan](https://medium.com/@manuelvbattan?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/introducing-redux-recompose.md](https://github.com/xitu/gold-miner/blob/master/TODO/introducing-redux-recompose.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：[congFly](https://github.com/congFly)、[FateZeros](https://github.com/FateZeros)

# redux-recompose 介绍：优雅的编写 Redux 中的 action 和 reducer

![](https://cdn-images-1.medium.com/max/2000/1*YFWtliBac9cTpe5gKKMixQ.png)

去年一年做了不少 React 和 React Native 项目的开发，而且这些项目都使用了 Redux 来管理组件状态 。碰巧，这些项目里有很多具有代表性的开发模式，所以趁着我还在 Wolox，在分析、总结了这些模式之后，开发出了 [redux-recompose](https://github.com/Wolox/redux-recompose)，算是对这些模式的抽象和提升。

* * *

### 痛点所在

在 Wolox 培训的那段时间，为了学 redux 看了 [Dan Abramov’s 在 Egghead 上发布的 Redux 教程](https://egghead.io/courses/getting-started-with-redux)，发现他大量使用了 `switch` 语句：我闻到了点 __坏代码的味道__。

在我接手的第一个 React Native 项目中，开始的时候我还是按照教程上讲的，使用 `switch` 编写 reducer。但不久后就发现，这种写法实在难以维护：

```javascript
import { actions } from './actions';

const initialState = {
  matches: [],
  matchesLoading: false,
  matchesError: null,
  pitches: [],
  pitchesLoading: false,
  pitchesError: null
};

/* eslint-disable complexity */
function reducer(state = initialState, action) {
  switch (action.type) {
    case actions.GET_MATCHES: {
      return { ...state, matchesLoading: true };
    }
    case actions.GET_MATCHES_SUCCESS: {
      return {
        ...state,
        matchesLoading: false,
        matchesError: null,
        matches: action.payload
      };
    }
    case actions.GET_MATCHES_FAILURE: {
      return {
        ...state,
        matchesLoading: false,
        matchesError: action.payload
      };
    }
    case actions.GET_PITCHES: {
      return { ...state, pitchesLoading: true };
    }
    case actions.GET_PITCHES_SUCCESS: {
      return {
        ...state,
        pitches: action.payload,
        pitchesLoading: false,
        pitchesError: null
      };
    }
    case actions.GET_PITCHES_FAILURE: {
      return {
        ...state,
        pitchesLoading: false,
        pitchesError: null
      };
    }
  }
}
/* eslint-enable complexity */

export default reducer;
```

到后面 reducer 里的条件实在是太多了，索性就把 eslint 的复杂度检测关掉了。

另一个问题集中在异步调用上，action 的定义中大量充斥着 __SUCCESS__ 和 __FAILURE__ 这样的代码，虽然这可能也不是什么问题，但是还是引入了太多重复代码。

```javascript
import SoccerService from '../services/SoccerService';

export const actions = createTypes([
  'GET_MATCHES',
  'GET_MATCHES_SUCCESS',
  'GET_MATCHES_FAILURE',
  'GET_PITCHES',
  'GET_PITCHES_SUCCESS',
  'GET_PITCHES_FAILURE'
], '@SOCCER');

const privateActionCreators = {
  getMatchesSuccess: matches => ({
    type: actions.GET_MATCHES_SUCCESS,
    payload: matches
  }),
  getMatchesError: error => ({
    type: actions.GET_MATCHES_ERROR,
    payload: error
  }),
  getPitchesSuccess: pitches => ({
    type: actions.GET_PITCHES_SUCCESS,
    payload: pitches
  }),
  getPitchesFailure: error => ({
    type: actions.GET_PITCHES_FAILURE,
    payload: error
  })
};

const actionCreators = {
  getMatches: () => async dispatch => {
    // 将 loading 状态置为 true
    dispatch({ type: actions.GET_MATCHES });
    // -> api.get('/matches');
    const response = await SoccerService.getMatches();
    if (response.ok) {
      // 存储 matches 数组数据，将 loading 状态置为 false
      dispatch(privateActionCreators.getMatchesSuccess(response.data));
    } else {
      // 存储错误信息，将 loading 状态置为 false
      dispatch(privateActionCreators.getMatchesFailure(response.problem));
    }
  },
  getPitches: clubId => async dispatch => {
    dispatch({ type: actions.GET_PITCHES });
    const response = await SoccerService.getPitches({ club_id: clubId });
    if (response.ok) {
      dispatch(privateActionCreators.getPitchesSuccess(response.data));
    } else {
      dispatch(privateActionCreators.getPitchesFailure(response.problem));
    }
  }
};

export default actionCreators;
```

### 对象即过程

某天，我的同事建议：

’要不试试把 `switch` 语句改成访问对象属性的形式？这样之前 `switch` 的条件就都能抽离成单个的函数了，也方便测试。‘

再者，[Dan Abramov 也说过](https://github.com/reactjs/redux/issues/929#issuecomment-150314197)：
__Reducer 就是一个很普通的函数，你可以抽出一些代码独立成函数，也可以在里面调用其他的函数，具体实现可以自由发挥。__

有了这句话我们也就放心开干了，于是开始探索有没有更加优雅的方式编写 reducer 的代码。最终，我们得出了这么一种写法：

```javascript
const reducerDescription = {
  [actions.GET_MATCHES]: (state, action) => ({ ...state, matchesLoading: true }),
  [actions.GET_MATCHES_SUCCESS]: (state, action) => ({
    ...state,
    matchesLoading: false,
    matchesError: null,
    matches: action.payload
  }),
  [actions.GET_MATCHES_FAILURE]: (state, action) => ({
    ...state,
    matchesLoading: false,
    matchesError: action.payload
  }),
  [actions.GET_PITCHES]: (state, action) => ({ ...state, pitchesLoading: true }),
  [actions.GET_PITCHES_SUCCESS]: (state, action) => ({
    ...state,
    pitchesLoading: false,
    pitchesError: null,
    pitches: action.payload
  }),
  [actions.GET_PITCHES_FAILURE]: (state, action) => ({
    ...state,
    pitchesLoading: false,
    pitchesError: action.payload
  })
};
```

```javascript
function createReducer(initialState, reducerObject) {
  return (state = initialState, action) => {
    (reducerObject[action.type] && reducerObject[action.type](state, action)) || state;
  };
}

export default createReducer(initialState, reducerDescription);
```

__SUCCESS__ 和 __FAILURE__ 的 action 和之前看来没啥区别，只是 action 的用法变了 —— 这里将 action 和操作它对应的 state 里的那部分数据的函数进行了一一对应。例如，我们分发了一个 action.aList 来修改一个列表的内容，那么‘aList’就是找到对应的 reducer 函数的关键词。

### 靶向化 action

有了上面的尝试，我们不妨更进一步思考：何不站在 action 的角度来定义 state 的哪些部分会被这个 action 影响？

[ Dan 这么说过：](https://github.com/reactjs/redux/issues/1167#issuecomment-166642708)

__我们可以把 action 想象成一个“差使”，action 不关心 state 的变化 —— 那是 reducer 的事__。

那么，为什么就不能反其道而行之呢，如果 action 就是要去管 state 的变化呢？有了这种想法，我们就能引申出 __靶向化 action__ 的概念了。何谓靶向化 action？就像这样：

```javascript
const privateActionCreators = {
  getMatchesSuccess: matchList => ({
    type: actions.GET_MATCHES_SUCCESS,
    payload: matchList,
    target: 'matches'
  }),
  getMatchesError: error => ({
    type: actions.GET_MATCHES_ERROR,
    payload: error,
    target: 'matches'
  }),
  getPitchesSuccess: pitchList => ({
    type: actions.GET_PITCHES_SUCCESS,
    payload: pitchList,
    target: 'pitches'
  }),
  getPitchesFailure: error => ({
    type: actions.GET_PITCHES_FAILURE,
    payload: error,
    target: 'pitches'
  })
};
```

### effects 的概念

如果你以前用过 [redux saga](https://github.com/redux-saga/redux-saga) 的话，应该对 effects 有点印象，但这里要讲的还不是这个 effects 的意思。

这里讲的是将 reducer 和 reducer 对 state 的操作进行解耦合，而这些抽离出来的操作（即函数）就称为 __effects__ —— 这些函数具有幂等性质，而且对 state 的变化一无所知：

```javascript
export function onLoading(selector = (action, state) => true) {
  return (state, action) => ({ ...state, [`${action.target}Loading`]: selector(action, state) });
}

export function onSuccess(selector = (action, state) => action.payload) {
  return (state, action) => ({
    ...state,
    [`${action.target}Loading`]: false,
    [action.target]: selector(action, state),
    [`${action.target}Error`]: null
  });
}

export function onFailure(selector = (action, state) => action.payload) {
  return (state, action) => ({
    ...state,
    [`${action.target}Loading`]: false,
    [`${action.target}Error`]: selector(action, state)
  });
}
```

注意上面的代码是如何使用这些 effects 的。你会发现里面有很多 selector 函数，它主要用来从封装对象中取出你需要的数据域：

```javascript
// 假设 action.payload 的结构是这个样子: { matches: [] }; 
const reducerDescription = {
  // 这里只引用了 matches 数组，不用处理整个 payload 对象
  [actions.GET_MATCHES_SUCCESS]: onSuccess(action => action.payload.matches)
};
```

有了以上思想，最终处理函数的代码变成这样：

```javascript
const reducerDescription = {
  [actions.MATCHES]: onLoading(),
  [actions.MATCHES_SUCCESS]: onSuccess(),
  [actions.MATCHES_FAILURE]: onFailure(),
  [actions.PITCHES]: onLoading(),
  [actions.PITCHES_SUCCESS]: onSuccess(),
  [actions.PITCHES_FAILURE]: onFailure()
};

export default createReducer(initialState, reducerDescription);
```

当然，我并不是这种写法的第一人：

![](https://i.loli.net/2017/12/26/5a41ed61266b0.jpg)

到这一步你会发现代码还是有重复的。针对每个基础 action（有配对的 SUCCESS 和 FAILURE），我们还是得写相应的 SUCCESS 和 FAILURE 的 effects。 那么，能否再做进一步改进呢？

### 你需要 Completer

Completer 可以用来抽取代码中重复的逻辑。所以，用它来抽取 __SUCCESS__ 和 __FAILURE__ 的处理代码的话，代码会从：

```javascript
const reducerDescription: {
  [actions.GET_MATCHES]: onLoading(),
  [actions.GET_MATCHES_SUCCESS]: onSuccess(),
  [actions.GET_MATCHES_FAILURE]: onFailure(),
  [actions.GET_PITCHES]: onLoading(),
  [actions.GET_PITCHES_SUCCESS]: onSuccess(),
  [actions.GET_PITCHES_FAILURE]: onFailure(),
  [actions.INCREMENT_COUNTER]: onAdd()
};

export default createReducer(initialState, reducerDescription);
```
变成以下更简洁的写法：

```javascript
const reducerDescription: {
  primaryActions: [actions.GET_MATCHES, actions.GET_PITCHES],
  override: {
    [actions.INCREMENT_COUNTER]: onAdd()
  }
}

export default createReducer(initialState, completeReducer(reducerDescription))
```

`completeReducer` 接受一个 reducer description 对象，它可以帮基础 action 扩展出相应的 SUCCESS 和 FAILURE 处理函数。同时，它也提供了重载机制，用于配制非基础 action 。

根据 SUCCESS 和 FAILURE 这两种情况定义状态字段也比较麻烦，对此，可以使用 `completeState` 自动为我们添加 loading 和 error 这两个字段：

```javascript
const stateDescription = {
  matches: [],
  pitches: [],
  counter: 0
};

const initialState = completeState(stateDescription, ['counter']);
```

还可以自动为 action 添加配对的 `SUCCESS` 和 `FAILURE`：

```javascript
export const actions = createTypes(
  completeTypes(['GET_MATCHES', 'GET_PITCHES'], ['INCREMENT_COUNTER']),
  '@@SOCCER'
);
```

这些 completer 都有第二个参数位 —— 用于配制例外的情况。

鉴于 SUCCESS-FAILURE 这种模式比较常见，目前的实现只会自动加 SUCCESS 和 FAILURE。不过，后期我们会支持用户自定义规则的，敬请期待！

### 使用注入器（Injections）处理异步操作

那么，异步 action 的支持如何呢？

当然也是支持的，多数情况下，我们写的异步 action 无非是从后端获取数据，然后整合到 store 的状态树中。

写法如下：

```javascript
import SoccerService from '../services/SoccerService';

export const actions = createTypes(completeTypes['GET_MATCHES','GET_PITCHES'], '@SOCCER');

const actionCreators = {
  getMatches: () =>
    createThunkAction(actions.GET_MATCHES, 'matches', SoccerService.getMatches),
  getPitches: clubId =>
    createThunkAction(actions.GET_PITCHES, 'pitches', SoccerService.getPitches, () => clubId)
};

export default actionCreators;
```

思路和刚开始是一样的：加载数据时先将 loading 标志置为 `true` ，然后根据后端的响应结果，选择分发 __SUCCESS__ 还是 __FAILURE__ 的 action。使用这种方法，我们抽取出了大量的重复逻辑，也不用再创建 `privateActionsCreators` 对象了。

但是，如果我们想要在调用和分发过程中间执行一些自定义代码呢？

我们可以使用 __注入器（injections）__ 来实现，在下面的例子中我们就用这个函数为 baseThunkAction 添加了一些自定义行为。

这两个例子要传达的思想是一样的：

```javascript
const actionCreators = {
  fetchSomething: () => async dispatch => {
    dispatch({ type: actions.FETCH });
    const response = Service.fetch();
    if (response.ok) {
      dispatch({ type: actions.FETCH_SUCCESS, payload: response.data });
      dispatch(navigationActions.push('/successRoute');
    } else {
      dispatch({ type: actions.FETCH_ERROR, payload: response.error });
      if (response.status === 404) {
        dispatch(navigationActions.push('/failureRoute');
      }
    }
  }
}
```

```javascript
const actionCreators = {
  fetchSomething: () => composeInjections(
    baseThunkAction(actions.FETCH, 'fetchTarget', Service.fetch),
    withPostSuccess(dispatch => dispatch(navigationActions.push('/successRoute'))),
    withStatusHandling({ 404: dispatch => dispatch(navigationActions.push('/failureRoute')) })
  )
}
```

* * *

以上是对这个库的一些简介，详情请参考 [https://github.com/Wolox/redux-recompose](https://github.com/Wolox/redux-recompose)。
安装姿势：

```
npm install --save redux-recompose
```

感谢 [Andrew Clark](https://github.com/acdlite)，他创建的 [recompose](https://github.com/acdlite/recompose) 给了我很多灵感。同时也感谢 redux 的创始人 [Dan Abramov](https://github.com/gaearon)，他的话给了我很多启发。

当然，也不能忘了同在 Wolox 里的战友们，是大家一起合力才完成了这个项目。

欢迎各位积极提出意见，如果在使用中发现任何 bug，一定要记得在 GitHub 上给我们反馈，或者提交你的修复补丁，总之，我希望大家都能积极参与到这个项目中来！

在以后的文章中，我们将会讨论更多有关 effects、注入器（injectors）和 completers 的话题，同时还会教你如何将其集成到 [apisauce](https://github.com/infinitered/apisauce) 或 [seamless-immutable](https://github.com/rtfeldman/seamless-immutable) 中使用。

希望你能继续关注！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
