> * 原文地址：[Redux 4 Ways](https://medium.com/react-native-training/redux-4-ways-95a130da0cdc#.nyb3hqtgb)
* 原文作者：[Nader Dabit](https://medium.com/@dabit3?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Redux 4 Ways #

## Implementations of [Thunk](https://github.com/gaearon/redux-thunk) vs [Saga](https://github.com/redux-saga/redux-saga) vs [Observable](https://github.com/redux-observable/redux-observable) vs [Redux Promise Middleware](https://github.com/pburtchaell/redux-promise-middleware) in 10 minutes. ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*V6i_YjJC80VVeSnYvBiL5Q.jpeg">

At the last [React Native online meetup](https://github.com/knowbody/react-native-online-meetups), I gave a presentation on the differences of Thunk vs Saga vs Redux Observable [(see slides here)](http://slides.com/dabit3/deck-11-12) .

> These libraries offer ways to handle side effects or asynchronous actions in a redux application. For more information on why you may need something like this, see [this link.](https://github.com/markerikson/react-redux-links/blob/master/redux-side-effects.md) 

I thought I would take this one step further and not only create [a repo ](https://github.com/dabit3/redux-4-ways) for viewing and testing these implementations, but walk through how they are implemented step by step and add one more implementation, [Redux Promise Middleware](https://github.com/pburtchaell/redux-promise-middleware) .

When I first started with redux, wrapping my head around these asynchronous side effect options was overwhelming. Even though the documentation was not bad, I just wanted to see the most absolute basic implementations of each in action to give me a clear understanding of how to get started with them without wasting a bunch of time.

In this tutorial, I’ll walk through a basic example of fetching and storing data in a reducer using each of these libraries.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*8PlQZYT4kGnCGZTVGtAoGg.jpeg">

As displayed in the above diagram, one of the most common use cases for these side effect libraries is hitting an api, showing a loading indicator, then displaying the data once it has returned from the api (or showing an error if there is an error). We will implement this exact functionality in all four libraries.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*06R5v_0WvZNNdvPntIuWaA.gif">

### Getting Started ###

I will be using React Native in this example, but feel free to use React, as it will all be exactly the same. If you are following along, just replace the `View` with `div`, and `Text` with `p`. In this first section, we will just be implementing a basic redux boilerplate to use with the four libraries.

I will run react-native init to create an empty project:

```
react-native init redux4ways 
```

Or, using create-react-app:

```
create-react-app redux4ways
```

Then, cd into the project

```
cd redux4ways
```

Next, we will install all of the dependencies we will need for the rest of the project.

```
yarn add redux react-redux redux-thunk redux-observable redux-saga rxjs redux-promise-middleware
```

Next, we will create all of the files and folders we will need to get started:

```
mkdir reducers
```

```
touch reducers/index.js reducers/dataReducer.js
```

```
touch app.js api.js configureStore.js constants.js actions.js
```

Now that we have everything installed and the files we need, we will build out the basic redux implementation we will be using.

In `index.ios` (ios) or `index.android.js` (android), update the code to the following:

```
import React from 'react'
import {
  AppRegistry
} from 'react-native'

import { Provider } from 'react-redux'
import configureStore from './configureStore'
import App from './app'

const store = configureStore()

const ReduxApp = () => (
  <Provider store={store}>
    <App />
  </Provider>
)

```
1. We import `Provider` from `react-redux`
2. import `configureStore` that we will create soon
3. import `App` which will be our main application component for this tutorial
4. create the store, calling `configureStore()`
5. wrap `App` in the `Provider`, passing in the store


Next, we’ll create the constants we will use in our actions and reducer. In `constants.js`, update the code to the following:
```
export const FETCHING_DATA = 'FETCHING_DATA'
export const FETCHING_DATA_SUCCESS = 'FETCHING_DATA_SUCCESS'
export const FETCHING_DATA_FAILURE = 'FETCHING_DATA_FAILURE'
```

Next, we will create our `dataReducer`. In `dataReducer.js`, update the code to the following:

```
import { FETCHING_DATA, FETCHING_DATA_SUCCESS, FETCHING_DATA_FAILURE } from '../constants'
const initialState = {
  data: [],
  dataFetched: false,
  isFetching: false,
  error: false
}

export default function dataReducer (state = initialState, action) {
  switch (action.type) {
    case FETCHING_DATA:
      return {
        ...state,
        data: [],
        isFetching: true
      }
    case FETCHING_DATA_SUCCESS:
      return {
        ...state,
        isFetching: false,
        data: action.data
      }
    case FETCHING_DATA_FAILURE:
      return {
        ...state,
        isFetching: false,
        error: true
      }
    default:
      return state
  }
}
```
1. We import the constants that we will be needing in this reducer.
2. The `initialState` of the reducer is an object with a `data` array, a `dataFetched` Boolean, an `isFetching` Boolean, and an `error` Boolean.
3. The reducer checks for three actions, updating the state accordingly. For example, if `FETCHING_DATA_SUCCESS` is the action, then we update the state with the new data, and set `isFetching` to `false`.

Now, we need to create our reducer entrypoint, in which we will call `combineReducers` on all of our reducers, which in our case is only one reducer: `dataReducer.js`.

In `reducers/index.js`:
```
import { combineReducers } from 'redux'
import appData from './dataReducer'

const rootReducer = combineReducers({
    appData
})

export default rootReducer
```

Next, we create the actions. In `actions.js`**,** update the code to the following:
```
import { FETCHING_DATA, FETCHING_DATA_SUCCESS, FETCHING_DATA_FAILURE } from './constants'

export function getData() {
  return {
    type: FETCHING_DATA
  }
}

export function getDataSuccess(data) {
  return {
    type: FETCHING_DATA_SUCCESS,
    data,
  }
}

export function getDataFailure() {
  return {
    type: FETCHING_DATA_FAILURE
  }
}

export function fetchData() {}
```
1. We import the constants that we will be needing in this reducer.
2. Create four methods, three of them calling actions (`getData`, `getDataSuccess`, and `getDataFailure`), the fourth will be updated to a thunk soon (`fetchData`).

Now, let’s create the configureStore. In configureStore.js, update the code to the following:
```
import { createStore } from 'redux'
import app from './reducers'

export default function configureStore() {
  let store = createStore(app)
  return store
}
```
1. import the root reducer from `‘./reducers’`
2. export a function that will create the store

Finally, we will create the UI and hook into the props that we will need. In `app.js`:
```
import React from 'react'
import { TouchableHighlight, View, Text, StyleSheet } from 'react-native'

import { connect } from 'react-redux'
import { fetchData } from './actions'

let styles

const App = (props) => {
  const {
    container,
    text,
    button,
    buttonText
  } = styles

  return (
    <View style={container}>
      <Text style={text}>Redux Examples</Text>
      <TouchableHighlight style={button}>
        <Text style={buttonText}>Load Data</Text>
      </TouchableHighlight>
    </View>
  )
}

styles = StyleSheet.create({
  container: {
    marginTop: 100
  },
  text: {
    textAlign: 'center'
  },
  button: {
    height: 60,
    margin: 10,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0b7eff'
  },
  buttonText: {
    color: 'white'
  }
})

function mapStateToProps (state) {
  return {
    appData: state.appData
  }
}

function mapDispatchToProps (dispatch) {
  return {
    fetchData: () => dispatch(fetchData())
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)
```
Everything here is pretty self explanatory. If you’re new to redux, the connect method transforms the current Redux store state and imported actions into the props you want to pass to a presentational component you are wrapping, in our case `App`.

The final piece we will need is a mock api that will simulate a 3 second timeout and return a promise with the fetched data.

To do so, open `api.js` and place in it the following code:
```
const people = [
  { name: 'Nader', age: 36 },
  { name: 'Amanda', age: 24 },
  { name: 'Jason', age: 44 }
]

export default () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      return resolve(people)
    }, 3000)
  })
}
```
In `api.js`, we are creating an array of people, and when this file is imported and executed, it will return a promise that will return after 3 seconds with the people array..

### Redux Thunk ###

Now that redux is hooked up, we will sync it up with our first asynchronous library, [Redux Thunk](https://github.com/gaearon/redux-thunk). ([branch](https://github.com/dabit3/redux-4-ways/tree/thunk))

To do so, first we need to create a thunk.

> “Redux Thunk [middleware](https://github.com/reactjs/redux/blob/master/docs/advanced/Middleware.md) allows you to write action creators that return a function instead of an action. The thunk can be used to delay the dispatch of an action, or to dispatch only if a certain condition is met. The inner function receives the store methods `dispatch` and `getState` as parameters.” — Redux Thunk documentation

In `actions.js`, update the `fetchData` function and import the api:
```
import { FETCHING_DATA, FETCHING_DATA_SUCCESS, FETCHING_DATA_FAILURE } from './constants'
import getPeople from './api'

export function getData() {
  return {
    type: FETCHING_DATA
  }
}

export function getDataSuccess(data) {
  return {
    type: FETCHING_DATA_SUCCESS,
    data,
  }
}

export function getDataFailure() {
  return {
    type: FETCHING_DATA_FAILURE
  }
}

export function fetchData() {
  return (dispatch) => {
    dispatch(getData())
    getPeople()
      .then((data) => {
        dispatch(getDataSuccess(data))
      })
      .catch((err) => console.log('err:', err))
  }
}
view raw
```

The `fetchData` function is now a thunk. When fetchData is called, it returns a function that will then dispatch the `getData` action. Then, `getPeople` is called. Once `getPeople` resolves, it will then dispatch the `getDataSuccess` action.

Next, we update `configureStore` to apply the thunk middleware:

```
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'
import thunk from 'redux-thunk'

export default function configureStore() {
  let store = createStore(app, applyMiddleware(thunk))
  return store
}
```

1. import applyMiddleware from `redux`
2. import `thunk` from `redux-thunk`
3. call `createStore`, passing in `applyMiddleware` as the second argument.

Finally, we can update the `app.js` file to use the new thunk.
```

import React from 'react'
import { TouchableHighlight, View, Text, StyleSheet } from 'react-native'

import { connect } from 'react-redux'
import { fetchData } from './actions'

let styles

const App = (props) => {
  const {
    container,
    text,
    button,
    buttonText,
    mainContent
  } = styles

  return (
    <View style={container}>
      <Text style={text}>Redux Examples</Text>
      <TouchableHighlight style={button} onPress={() => props.fetchData()}>
        <Text style={buttonText}>Load Data</Text>
      </TouchableHighlight>
      <View style={mainContent}>
      {
        props.appData.isFetching && <Text>Loading</Text>
      }
      {
        props.appData.data.length ? (
          props.appData.data.map((person, i) => {
            return <View key={i} >
              <Text>Name: {person.name}</Text>
              <Text>Age: {person.age}</Text>
            </View>
          })
        ) : null
      }
      </View>
    </View>
  )
}

styles = StyleSheet.create({
  container: {
    marginTop: 100
  },
  text: {
    textAlign: 'center'
  },
  button: {
    height: 60,
    margin: 10,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0b7eff'
  },
  buttonText: {
    color: 'white'
  },
  mainContent: {
    margin: 10,
  }
})

function mapStateToProps (state) {
  return {
    appData: state.appData
  }
}

function mapDispatchToProps (dispatch) {
  return {
    fetchData: () => dispatch(fetchData())
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)
```

Main takeaways from this change:

1. We add an onPress method to the TouchableHighlight that calls `props.fetchData()` when pressed.
2. We add a check to see if `props.appData.isFetching` is true, and if so we return loading indicator text.
3. We add a check to `props.appData.data.length`, looping through the array if it is there and returning the name and age of the person.

Now, when we click the Load Data button, we should see the loading message, and then the data should display after 3 seconds.

### Redux Saga ###

[Redux Saga](https://github.com/redux-saga/redux-saga) uses a combination of async await and generators to make for a smooth and fun to use api. ([branch](https://github.com/dabit3/redux-4-ways/tree/saga))

> “It uses an ES6 feature called Generators to make those asynchronous flows easy to read, write and test. (if you’re not familiar with them [*here are some introductory links*](https://redux-saga.github.io/redux-saga/docs/ExternalResources.html) ) By doing so, these asynchronous flows look like your standard synchronous JavaScript code. (kind of like `async`/`await`, but generators have a few more awesome features we need)” — Redux Saga documentation

To implement a Saga, we first need to update our actions.

In `actions.js`, replace everything except the following function:
```
import { FETCHING_DATA } from './constants'

export function fetchData() {
  return {
    type: FETCHING_DATA
  }
}
```

This action will trigger the saga we are about to create. In a new file called `saga.js`, add the following code:
```
import { FETCHING_DATA, FETCHING_DATA_SUCCESS, FETCHING_DATA_FAILURE } from './constants'
import { put, takeEvery } from 'redux-saga/effects'
import getPeople from './api'

function* fetchData (action) {
  try {
    const data = yield getPeople()
    yield put({ type: FETCHING_DATA_SUCCESS, data })
  } catch (e) {
    yield put({ type: FETCHING_DATA_FAILURE })
  }
}

function* dataSaga () {
  yield takeEvery(FETCHING_DATA, fetchData)
}

export default dataSaga
```

1. We import the constants that we will be needing.
2. We import `put` and `takeEvery` from `redux-saga/effects`. When we call `put`, redux saga instructs the middleware to dispatch an action. `takeEvery` will listen for dispatched action (in our case `FETCHING_DATA)` and call a callback function (in our case `fetchData`)
3. When `fetchData` is called, we will wait to see if `getPeople` returns successfully, and if it does, we will dispatch `FETCHING_DATA_SUCCCESS`

Finally, we need to update `configureStore.js` to use the saga middleware instead of the thunk middleware.
```
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'

import createSagaMiddleware from 'redux-saga'
import dataSaga from './saga'

const sagaMiddleware = createSagaMiddleware()

export default function configureStore() {
  const store = createStore(app, applyMiddleware(sagaMiddleware))
  sagaMiddleware.run(dataSaga)
  return store
}
```

The main things to note in this file is that we import our saga and also `createSagaMiddleware` form `redux-saga`. When we create the store, we pass in the `sagaMiddleware` that we created, and then call `sagaMiddleWare.run` before returning the store.

Now, we should be able to run the application and get the same functionality that we had when using redux thunk!

> Notice that we only changed three files in the move from thunk to saga: `saga.js``configureStore.js` and `actions.js`.

### Redux Observable ###

Redux Observable uses RxJS and observables to create asynchronous actions and data flow for a Redux app. ([branch](https://github.com/dabit3/redux-4-ways/tree/observable))

> [“RxJS 5](http://github.com/ReactiveX/RxJS)-based middleware for [Redux](http://github.com/reactjs/redux). Compose and cancel async actions to create side effects and more.” — Redux Observable documentation

The first thing we need to do to get started with redux observable is to again update our actions.js file:
```
import { FETCHING_DATA, FETCHING_DATA_SUCCESS, FETCHING_DATA_FAILURE } from './constants'

export function fetchData () {
  return {
    type: FETCHING_DATA
  }
}

export function getDataSuccess (data) {
  return {
    type: FETCHING_DATA_SUCCESS,
    data
  }
}

export function getDataFailure (error) {
  return {
    type: FETCHING_DATA_FAILURE,
    errorMessage: error
  }
}
```

As you can see, we’ve updated our actions to have our original three actions from before.

Next, we will create what is known as an epic. An epic is a function which takes a stream of actions and returns a stream of actions.

Create a file called `epic.js` with the following code:
```
import { FETCHING_DATA } from './constants'
import { getDataSuccess, getDataFailure } from './actions'
import getPeople from './api'

import 'rxjs'
import { Observable } from 'rxjs/Observable'

const fetchUserEpic = action$ =>
  action$.ofType(FETCHING_DATA)
    .mergeMap(action =>
      Observable.fromPromise(getPeople())
        .map(response => getDataSuccess(response))
        .catch(error => Observable.of(getDataFailure(error)))
      )

export default fetchUserEpic
```

> $ is a common RxJS convention to identify variables that reference a stream

1. import the FETCHING_DATA constant.
2. import `getDataSuccess` and `getDataFailure` functions from the actions.
3. import `rxjs` and `Observable` from rxjs.
4. We create a function called `fetchUserEpic`.
5. We wait for the `FETCHING_DATA` action to come through the stream, and when it does we call [mergeMap](https://www.learnrxjs.io/operators/transformation/mergemap.html) on the action, returning `Observable.fromPromise` from `getPeople` and mapping the response to the `getDataSuccess` function from our actions.

Finally, we just need to update configureStore to use the new epic middleware.

In `configureStore.js`:
```
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'

import { createEpicMiddleware } from 'redux-observable'
import fetchUserEpic from './epic'

const epicMiddleware = createEpicMiddleware(fetchUserEpic)

export default function configureStore () {
  const store = createStore(app, applyMiddleware(epicMiddleware))
  return store
}
view raw
```

Now we should be able to run our application and the functionality should all work as before!

### Redux Promise Middleware ###

Redux Promise Middleware is a lightweight library for resolving and rejecting promises with conditional optimistic updates. ([branch](https://github.com/dabit3/redux-4-ways/tree/promise-middleware))

> “Redux promise middleware enables robust handling of async code in [Redux](http://redux.js.org/) . The middleware enables optimistic updates and dispatches pending, fulfilled and rejected actions. It can be combined with [redux-thunk](https://github.com/gaearon/redux-thunk) to chain async actions.” — Redux Promise Middleware documentation

As you will see, Redux Promise Middleware reduces boilerplate pretty dramatically vs some of the other options.

It can also be [combined with Thunk](https://github.com/pburtchaell/redux-promise-middleware/blob/640c48c40c4f5168bafba017e8c975e09dafe4b4/README.md) to chain the async actions.

Redux Promise Middleware is different in that it takes over your actions and appends `_PENDING`, `_FULFILLED`, or `_REJECTED` actions depending on the outcome of your promise.

For example, if we called FETCHING like this:

```
function fetchData() {
  return {
    type: FETCH_DATA,
    payload: getPeople()
  }
}
```

Then `FETCH_DATA_PENDING` would automatically be dispatched.

Once the `getPeople` promise resolved, it would call either `FETCH_DATA_FULFILLED` or `FETCH_DATA_REJECTED` depending on the outcome of `getPeople`.

Let’s see this in action in our existing app.

To get started, let’s first update our constants to match those that we will now be working with. In `constants.js`:
```
export const FETCH_DATA = 'FETCH_DATA'
export const FETCH_DATA_PENDING = 'FETCH_DATA_PENDING'
export const FETCH_DATA_FULFILLED = 'FETCH_DATA_FULFILLED'
export const FETCH_DATA_REJECTED = 'FETCH_DATA_REJECTED'
```

Next, in `actions.js`, let’s update our action to a single action: `FETCH_DATA`:
```
import { FETCH_DATA } from './constants'
import getPeople from './api'

export function fetchData() {
  return {
    type: FETCH_DATA,
    payload: getPeople()
  }
}
```

Now, in our reducer (`dataReducer.js`) we need to swap out the actions with the new constants we are working with:
```
import { FETCH_DATA_PENDING, FETCH_DATA_FULFILLED, FETCH_DATA_REJECTED } from '../constants'
const initialState = {
  data: [],
  dataFetched: false,
  isFetching: false,
  error: false
}

export default function dataReducer (state = initialState, action) {
  switch (action.type) {
    case FETCH_DATA_PENDING:
      return {
        ...state,
        data: [],
        isFetching: true
      }
    case FETCH_DATA_FULFILLED:
      return {
        ...state,
        isFetching: false,
        data: action.payload
      }
    case FETCH_DATA_REJECTED:
      return {
        ...state,
        isFetching: false,
        error: true
      }
    default:
      return state
   }
}
```

Last, we just need to update `configureStore` to use the new Redux Promise Middleware:
、、、
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'
import promiseMiddleware from 'redux-promise-middleware';

export default function configureStore() {
  let store = createStore(app, applyMiddleware(promiseMiddleware()))
  return store
}
、、、

Now, we should be able to run our application and get the same functionality.

### Conclusion ###

Overall, I think I like Saga for more complex applications, and Redux Promise Middleware for everything else. I really like working with generators and async-await with Saga, it is fun, but I also like the reduction in boilerplate that Redux Promise Middleware offers.

If I knew how to use RXJS a little better, I may sway to Redux Observable, but there are still quite a few things I don’t understand well enough to confidently use it in production.

> My Name is [Nader Dabit](https://twitter.com/dabit3) , and I am a software developer that specializes in building and teaching React and React Native.

> If you like React Native, checkout out our podcast — [React Native Radio](https://devchat.tv/react-native-radio) on [Devchat.tv](http://devchat.tv/) with [Gant Laborde](https://medium.com/@gantlaborde) [Kevin Old](https://medium.com/@kevinold) [Ali Najafizadeh](https://medium.com/@alinz) and [Peter Piekarczyk](https://medium.com/@peterpme) 

> Also, check out my book, [React Native in Action](https://www.manning.com/books/react-native-in-action)  now available from Manning Publications

> If you enjoyed this article, please recommend and share it! Thanks for your time
