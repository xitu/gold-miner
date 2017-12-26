> * 原文地址：[Introducing redux-recompose: Tools to ease Redux actions and reducers development](https://medium.com/wolox-driving-innovation/932e746b0198)
> * 原文作者：[Manuel V Battan](https://medium.com/@manuelvbattan?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/introducing-redux-recompose.md](https://github.com/xitu/gold-miner/blob/master/TODO/introducing-redux-recompose.md)
> * 译者：
> * 校对者：

# Introducing redux-recompose: Tools to ease Redux actions and reducers development

![](https://cdn-images-1.medium.com/max/2000/1*YFWtliBac9cTpe5gKKMixQ.png)

I have been working on many React and React Native projects this past year, and all of them use Redux. Thanks to the various patterns present in those projects, at Wolox we developed [redux-recompose](https://github.com/Wolox/redux-recompose) in order to abstract and improve these patterns.

* * *

### The ‘problem’

When I watched the lessons of [Dan Abramov’s Egghead course](https://egghead.io/courses/getting-started-with-redux) to learn Redux for Wolox trainings, I felt that _using a switch in a reducer was smelly_.

We started writing reducers in a traditional way, with that switch. In the first project we developed in React Native, this pattern became unhandy:

```
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

Since reducers grew too much, we started to disable `complexity` from `eslint` rules.

Another issue we have encountered is that _async actions, nearly in a 90% of cases dispatched a SUCCESS or a FAILURE action._ Although this is not an issue per se, it introduced too much duplicated code:

```
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
    // Puts loadingMatches in true
    dispatch({ type: actions.GET_MATCHES });
    // -> api.get('/matches');
    const response = await SoccerService.getMatches();
    if (response.ok) {
      // Stores matches, put loading in false
      dispatch(privateActionCreators.getMatchesSuccess(response.data));
    } else {
      // Store the error, put loading in false
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

### Reducer handlers as Objects

One day, one of my coworkers said:

‘We can try using an object instead of a switch for reducers. Switch cases can be extracted in smaller, testeable functions.’

[From a Dan Abramov comment](https://github.com/reactjs/redux/issues/929#issuecomment-150314197):
_Reducer is just a function. How you structure it and whether you split it into many and call other functions is completely up to you._

That comment encouraged us to explore other ways to write reducers. Which lead us to this:

```
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

```
function createReducer(initialState, reducerObject) {
  return (state = initialState, action) => {
    (reducerObject[action.type] && reducerObject[action.type](state, action)) || state;
  };
}

export default createReducer(initialState, reducerDescription);
```

Handlers for _SUCCESS_ and _FAILURE_ actions still looked too similar; only the ‘target’ of these actions were different. We denote **target** of an action from that part of the state being modified. For example, if we update a list from `action.aList`, ‘aList’ is the target of the reducer.

### Targeted actions

What if we can define from the action-side what part of the state will be affected by the action?

[From Dan:](https://github.com/reactjs/redux/issues/1167#issuecomment-166642708)

_Think of action as a “message”. The_ **_action doesn’t know how the state changes_**_. It’s precisely reducers’ job._

What if actions know _what part_ of the state change? That’s the concept of targeted actions. **Targeted actions**look like this:

```
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

### Introducing the concept of effect

If you’ve ever used [redux saga](https://github.com/redux-saga/redux-saga) you’ve probably thought about those effects. Well, these are a little bit different.

The idea here is to _decouple reducers from the operations that they do over the state._ These operations can be extracted as **effects**— functions that always do the same over the state, but they don’t know what part of the state changes:

```
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

Notice that we can handle a function with these effects. These functions are called **selectors.** Selectors may lend a hand for relevant data wrapped in an object:

```
// if action.payload is like: { matches: [] }; 
const reducerDescription = {
  // This will store the array of matches instead of the whole object comming from payload
  [actions.GET_MATCHES_SUCCESS]: onSuccess(action => action.payload.matches)
};
```

With that in mind, these handlers now look like this:

```
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

This idea isn’t new:

![](https://i.loli.net/2017/12/26/5a41ed61266b0.jpg)

But, there is code that is _still_ being repeated. For every **primary action** (i.e. actions that have associated SUCCESS and FAILURE actions), we must write a SUCCESS and a FAILURE effect. Is there a way to extract code patterns like this one?

### Completers to the rescue

Completers are meant to extract patterns that cause repeated logic. For example, we could extract _SUCCESS-FAILURE_ from the reducer.

We can reduce this code:

```
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
To this:

```
const reducerDescription: {
  primaryActions: [actions.GET_MATCHES, actions.GET_PITCHES],
  override: {
    [actions.INCREMENT_COUNTER]: onAdd()
  }
}

export default createReducer(initialState, completeReducer(reducerDescription))
```

`completeReducer` is a function that takes a reducer description and extends SUCCESS and FAILURE cases for all primary actions. Also, it supports a field named `override` to provide actions that aren’t primary.

Since writing state fields from SUCCESS and FAILURE cases also might be a bit annoying, `completeState` adds `loading` and `error` for us:

``
const stateDescription = {
  matches: [],
  pitches: [],
  counter: 0
};

const initialState = completeState(stateDescription, ['counter']);
``

And for action names, adding `SUCCESS` and `FAILURE` actions:

```
export const actions = createTypes(
  completeTypes(['GET_MATCHES', 'GET_PITCHES'], ['INCREMENT_COUNTER']),
  '@@SOCCER'
);
```

These completers take another param for the **exceptions cases** — those items that we don’t want to extend.

Since SUCCESS-FAILURE is a very common pattern, completers are oriented to complete this by default. Currently, we are working on custom completers that take custom rules for completion, they will be available soon.

### Craft your own async action with Injections

What about async actions? Do they work here?

Yes! They do. In most cases, we write async actions to fetch things from a service and put them in the store’s state.

We can write async actions as:

```
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

Those are conceptually the same as the first ones: they put loading flag in true, and according to the service response, dispatch a _SUCCESS_ or a _FAILURE_ action. This way, we have extracted the many repeated logic; also eliminated the need of declaring a `privateActionsCreators` object.

But, what if we want to customize this behavior, by adding code between calls or dispatches?

We could achieve that with **injections** — functions that add behavior to baseThunkAction.

These examples are both equal conceptually:

```
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

```
const actionCreators = {
  fetchSomething: () => composeInjections(
    baseThunkAction(actions.FETCH, 'fetchTarget', Service.fetch),
    withPostSuccess(dispatch => dispatch(navigationActions.push('/successRoute'))),
    withStatusHandling({ 404: dispatch => dispatch(navigationActions.push('/failureRoute')) })
  )
}
```

* * *

More detailed documentation is available at h[ttps://github.com/Wolox/redux-recompose](https://github.com/Wolox/redux-recompose)
Also a `npm` package is available:

```
npm install --save redux-recompose
```

I’d like to thanks [Andrew Clark](https://github.com/acdlite) for creating [recompose](https://github.com/acdlite/recompose), whose library inspired this work, and to thanks to [Dan Abramov](https://github.com/gaearon) for those wiseful comments 📚.

Also I’d like to thanks everyone at Wolox who helped build this project.

If you have any suggestions, any ideas you want to talk about, or find a bug, please post an issue or create a PR on GitHub and I’ll gladly reply it. Let us know what you think !

In later posts, we are going to explore available effects, injectors and completers, and how to integrate them with other libraries like `[apisauce](https://github.com/infinitered/apisauce)` or `[seamless-immutable](https://github.com/rtfeldman/seamless-immutable)`.

Stay tuned !


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
