> * 原文地址：[Redux 4 Ways](https://medium.com/react-native-training/redux-4-ways-95a130da0cdc#.nyb3hqtgb)
* 原文作者：本篇文章已获得作者 [Nader Dabit](https://medium.com/@dabit3?source=post_header_lockup) 授权
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[reid3290](https://github.com/reid3290)
* 校对者：[rccoder](https://github.com/rccoder)，[xekri](https://github.com/xekri)

# Redux 异步四兄弟 #

## 在十分钟内实践 [Thunk](https://github.com/gaearon/redux-thunk) 、 [Saga](https://github.com/redux-saga/redux-saga) 、 [Observable](https://github.com/redux-observable/redux-observable) 以及 [Redux Promise Middleware](https://github.com/pburtchaell/redux-promise-middleware)。 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*V6i_YjJC80VVeSnYvBiL5Q.jpeg">

在上一次的 [React Native online meetup](https://github.com/knowbody/react-native-online-meetups) 活动中，笔者就 Thunk 、 Saga 以及 Redux Observable 之间的不同之处做了报告 [(点击此处获取幻灯片)](http://slides.com/dabit3/deck-11-12) 。

> 上述函数库都提供了一些方法用以处理 Redux 应用中带有副作用的或者是异步的 action。更多关于为什么要用到这些库的介绍，请 [点击此处](https://github.com/markerikson/react-redux-links/blob/master/redux-side-effects.md) 。

相较于仅仅是创建一个[仓库](https://github.com/dabit3/redux-4-ways)，然后查看和测试这些库的实现方法，笔者希望更进一步，即一步步地弄清这些库是如何解决异步在 Redux 中产生的副作用，并额外增加一种方案 —— [Redux Promise Middleware](https://github.com/pburtchaell/redux-promise-middleware) 。

笔者第一次接触 Redux 的时候，就被这些异步的、带有副作用的函数库搞得“头昏脑胀”。 虽然相关文档还算齐全，但还是希望能够结合实际项目去深入理解这些函数库是如何解决 Redux 中的异步问题。从而快速上手，避免浪费过多时间。

在本教程中，笔者将应用上述函数库，一步步地实现一个拉取数据并将数据存储在 reducer 中的简单例子。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*8PlQZYT4kGnCGZTVGtAoGg.jpeg">

如图所示，上述函数库最通用的模式之一就是发起一个 API 请求，显示加载图标，数据返回后展示结果（如果出现错误则展示错误信息）。笔者将依次使用上述 4 个函数库实现该功能。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*06R5v_0WvZNNdvPntIuWaA.gif">

### 开始 ###

在本例中笔者将使用 React Native，当然使用 React 也是完全一样的 —— 只需要把 `View` 替换为 `div`, 把 `Text` 替换为 `p` 即可。 在本节中，笔者将仅仅实现一个简单的 Redux 示例应用，以展示上述 4 个函数库的用法。

首先运行 react-native init 命令创建一个空项目：

```
react-native init redux4ways 
```

当然也可以使用 create-react-app:

```
create-react-app redux4ways
```

然后进入项目目录：

```
cd redux4ways
```

安装所需依赖：

```
yarn add redux react-redux redux-thunk redux-observable redux-saga rxjs redux-promise-middleware
```

创建将要用到的相关目录和文件：

```
mkdir reducers
```

```
touch reducers/index.js reducers/dataReducer.js
```

```
touch app.js api.js configureStore.js constants.js actions.js
```

至此，所有依赖都已安装完毕，相关文件业已新建妥当，可以着手编码开发了。

首先将 `index.ios` (ios) 或 `index.android.js` (android) 中的代码更新如下： 

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
1. 从 `react-redux` 中引入 `Provider`。
2. 引入 `configureStore`，随后将创建该文件。
3. 引入 `App` 作为本例应用中的入口组件。
4. 调用 `configureStore()` 方法创建 store。
5. 将 `App` 包裹在 `Provider` 中并传入上述 store。


接着创建 actions 和 reducer 所涉及的相关常量，`constants.js` 文件内容如下：
```
export const FETCHING_DATA = 'FETCHING_DATA'
export const FETCHING_DATA_SUCCESS = 'FETCHING_DATA_SUCCESS'
export const FETCHING_DATA_FAILURE = 'FETCHING_DATA_FAILURE'
```

再接着创建 `dataReducer`，`dataReducer.js` 文件内容如下：

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
1. 引入相关常量。
2. 该 reducer 的初始状态 `initialState` 是一个对象，该对象由 1 个数组 `data` 和 3 个布尔类型的变量：`dataFetched` 、`isFetching` 以及 `error` 构成。
3. 该 reducer 负责处理 3 种类型的 actions 并相应地更新状态。例如，如果 action 的类型是 `FETCHING_DATA_SUCCESS`， 则将新数据添加到状态对象中并将 `isFetching` 设为 `false`。

接下来需要创建 reducer 的入口文件，在该文件中会对所有的 reducers 调用 `combineReducers` 方法（在本例中只有一个 reducer，即 `dataReducer.js` ）。

`reducers/index.js` 文件内容如下：
```
import { combineReducers } from 'redux'
import appData from './dataReducer'

const rootReducer = combineReducers({
    appData
})

export default rootReducer
```

之后则需要创建相应的 actions，`actions.js` 文件内容如下： 
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
1. 引入相关常量。
2. 定义 4 个函数，其中 3 个 （`getData`、`getDataSuccess` 和 `getDataFailure`）会直接返回 action，第 4 个（`fetchData`）则会更新一个 thunk （具体实现见下文）。

接着定义 configureStore：
```
import { createStore } from 'redux'
import app from './reducers'

export default function configureStore() {
  let store = createStore(app)
  return store
}
```
1. 从 `./reducers` 中引入 root reducer。
2. 暴露用以创建 store 的函数接口。

最后, 对接页面 UI 并绑定相应 props：
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
此处代码不言自明 —— connect 方法用于将当前 Redux store 的状态和引入的 actions 作为 props 传入目标展示性组件中，即此例中的 `App`。

最后需要一个模拟的数据接口，该接口返回一个 promise，该 promise 会在 3 秒钟后 reslove，并返回相应数据。对应文件 `api.js` 内容如下：
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
在该文件中，首先创建一个含有人员信息的数组，然后暴露一个实现了上述模拟接口功能的方法。

### Redux Thunk ###

 至此，Redux 已经和 React 连接了起来，接下来引入第一个异步函数库 —— [Redux Thunk](https://github.com/gaearon/redux-thunk)。（[branch](https://github.com/dabit3/redux-4-ways/tree/thunk)）

首先需要创建一个 thunk

> “[Redux Thunk middleware](https://github.com/reactjs/redux/blob/master/docs/advanced/Middleware.md) 允许 action 创建函数返回一个函数而不是 action。 该中间件可以用于延迟 action 的 dispatch 过程， 或仅当满足特定条件时才 dispatch action；其内部函数接受两个参数：`dispatch` 和 `getState`。 ” —— Redux Thunk 文档

在 `actions.js` 文件中，更新函数 `fetchData` 并引入 api:
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

此处 `fetchData` 函数是一个 thunk。当被调用时，fetchData 会返回一个函数；该函数首先会 dispatch `getData` action，然后调用 `getPeople`，在 `getPeople` 返回的 promise reslove 之后，会 dispatch `getDataSuccess` action。

接下来，需要更新 `configureStore` 函数以引入 thunk 中间件：

```
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'
import thunk from 'redux-thunk'

export default function configureStore() {
  let store = createStore(app, applyMiddleware(thunk))
  return store
}
```

1. 从 `redux` 引入 applyMiddleware。
2. 从 `redux-thunk` 引入 `thunk`。
3. 将 `applyMiddleware` 作为第二个参数传递给函数 `createStore`。

最后，更新 `app.js` 文件来使用上述 thunk：
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

此处代码主要有以下几个要点：

1. 为 TouchableHighlight 组件绑定 onPress 函数，当按压事件触发后调用 `props.fetchData()`。
2. 检查 `props.appData.isFetching` 的值是否为 true， 如果是则返回正在加载的文字提示。
3. 检查 `props.appData.data.length`，如果该值存在且不为 0，则遍历该数组，展示人员姓名和年龄信息。

至此，当按下按钮 Load Data 后，首先会看到正在加载的提示文字，3 秒后会看到人员信息。

### Redux Saga ###

[Redux Saga](https://github.com/redux-saga/redux-saga) 组合使用 async await 和 Generators，使其函数接口简单易用。（[branch](https://github.com/dabit3/redux-4-ways/tree/saga)）

> “通过使用 ES6 的新特性 Generators，涉及异步流程的代码变得易于阅读、编写和测试。（如果你对此特性还不熟悉的话，[**点击此处获取入门介绍**](https://redux-saga.github.io/redux-saga/docs/ExternalResources.html)）。基于此，Javascript 的异步代码看起来就和标准的同步代码一样（有点类似于 `async`/`await`，但 Generators 另外还有一些我们所需要的极佳特性）。—— Redux Saga 文档

为了实现 Saga，首先需要更新 actions —— 删除 `actions.js` 文件中除了如下代码外的其它所有代码：

```
import { FETCHING_DATA } from './constants'

export function fetchData() {
  return {
    type: FETCHING_DATA
  }
}
```

该 action 会触发我们即将创建的 saga。新建 `saga.js` 文件，写入如下代码：

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

1. 引入所需常量。
2. 从 `redux-saga/effects` 中引入 `put` 和 `takeEvery`。当调用 `put` 函数时，Reduc Sage 会指示中间件 dipatch 一个 action。`takeEvery` 函数则会监听被 dispatch 了的 action（本例中即为 `FETCHING_DATA`），然后调用回调函数（本例中即为 `fetchData`）。
3. 当 `fetchData` 被调用后，代码会等待函数 `getPeople` 的返回，如果返回成功则 dispatch `FETCHING_DATA_SUCCCESS` action。

最后更新 `configureStore.js` 文件，用 saga 替换 thunk。

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

在该文件中既引入了上述 saga，又从 `redux-saga` 中引入了 `createSagaMiddleware`。在创建 store 时，传入 `sagaMiddleware`，然后在返回 store 之前调用 `sagaMiddleWare.run`。

至此，可以再次运行该程序并看到和使用 Redux Thunk 是同样的效果！

> 注意：从 thunk 迁移到 saga 只改变了 3 个文件： `saga.js`、`configureStore.js` 以及 `actions.js`。

### Redux Observable ###

Redux Observable 使用 RxJS 和 observables 来为 Redux 应用创建异步 action 和异步数据流。（[branch](https://github.com/dabit3/redux-4-ways/tree/observable)）

> “基于 [RxJS 5](http://github.com/ReactiveX/RxJS) 的 [Redux](http://github.com/reactjs/redux) 中间件。组合撤销异步 actions 以产生副作用等。” —— Redux Observable 文档

首先还是需要更新 actions.js 文件：
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

如上所示，将之前的 actions 更新为最早的 3 个 actions。

接着创建所谓的 epic —— 输入 action stream 并输出 action stream 的函数。

新建 `epic.js` 文件并加入如下代码：
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

> 一般在 RxJS 中，变量名中的 $ 符号用以表示该变量是某 stream 的引用。

1. 引入常量 FETCHING_DATA。
2. 引入 `getDataSuccess` 和 `getDataFailure` 函数。
3. 从 rxjs 中引入 `rxjs` 和 `Observable`。
4. 定义函数 `fetchUserEpic`。
5. 等到 `FETCHING_DATA` action 通过该 stream 之后，调用 [mergeMap](https://www.learnrxjs.io/operators/transformation/mergemap.html) 函数, 从 `getPeople` 中返回 `Observable.fromPromise` 并将返回值映射到 `getDataSuccess` 函数中。

最后，更新 configureStore，应用新中间件 —— epic。

`configureStore.js` 文件内容如下：
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

至此，可以再次运行该程序并看到后之前一样的效果！

### Redux Promise Middleware ###

Redux Promise Middleware 是一个用于 reslove 和 reject promise 的轻量级函数库。 ([branch](https://github.com/dabit3/redux-4-ways/tree/promise-middleware))

> “Redux Promise Middleware 使得 [Redux](http://redux.js.org/) 中的异步代码更为健壮，并使 optimistic updates 、dispatches pending 、fulfilled 和 rejected actions 成为可能。 它也可以和 [redux-thunk](https://github.com/gaearon/redux-thunk) 结合使用链式化异步 action” —— Redux Promise Middleware 文档

正如你将要看到的一样，相比于上述几个函数库而言，Redux Promise Middleware 极大地减少了代码量。

它也可以和 [Thunk 结合使用](https://github.com/pburtchaell/redux-promise-middleware/blob/640c48c40c4f5168bafba017e8c975e09dafe4b4/README.md) 以实现异步 action 的链式化。

相较于上述几个函数库，Redux Promise Middleware 有所不同 —— 它会接管你的 action 并基于 promise 状态的不同在 action 类型名称后添加 `_PENDING`、`_FULFILLED` 或 `_REJECTED`。

例如，如果调用如下函数：

```
function fetchData() {
  return {
    type: FETCH_DATA,
    payload: getPeople()
  }
}
```

那么就会自动地 dispatch `FETCH_DATA_PENDING` action。

一旦 `getPeople` promise resolved，基于返回结果的不同，会 dispatch `FETCH_DATA_FULFILLED` 或 `FETCH_DATA_REJECTED` action。

让我们通过现有的例子来理解该特性：

首先需要更新 `constants.js`，以使其匹配我们将要用到的常量:

```
export const FETCH_DATA = 'FETCH_DATA'
export const FETCH_DATA_PENDING = 'FETCH_DATA_PENDING'
export const FETCH_DATA_FULFILLED = 'FETCH_DATA_FULFILLED'
export const FETCH_DATA_REJECTED = 'FETCH_DATA_REJECTED'
```

接着将 `actions.js` 文件更新为只有一个 `FETCH_DATA` 这一个 action。

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

接着基于上面新定义的常量更新 `dataReducer.js` 文件：

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

最后更新 `configureStore`，应用 Redux Promise Middleware：

```
import { createStore, applyMiddleware } from 'redux'
import app from './reducers'
import promiseMiddleware from 'redux-promise-middleware';

export default function configureStore() {
  let store = createStore(app, applyMiddleware(promiseMiddleware()))
  return store
}
```

至此，可以再次运行该程序并看到后之前一样的效果！

### 总结 ###

总的来说，笔者认为 Saga 更适用于较为复杂的应用，除此之外的其他所有情况 Redux Promise Middleware 都是十分合适的。笔者十分喜欢 Saga 中的 Generators 和 async-await，这些特性很有趣； 同时笔者也喜欢 Redux Promise Middleware，因为它极大地减少了代码量。

如果对 RxJS 更为熟悉的话，笔者也许会偏向 Redux Observable；但还是有很多笔者理解不透彻的地方，因此无法自信地将其应用于生产环境中。

> 笔者 [Nader Dabit](https://twitter.com/dabit3)，是一名专注于 React 和 React Native 开发和培训的软件开发者。

> 如果你也喜欢 React Native，欢迎查看我和 [Gant Laborde](https://medium.com/@gantlaborde) [Kevin Old](https://medium.com/@kevinold) [Ali Najafizadeh](https://medium.com/@alinz) 及 [Peter Piekarczyk](https://medium.com/@peterpme) 在 [Devchat.tv](http://devchat.tv/) 的 podcast — [React Native Radio](https://devchat.tv/react-native-radio)。

> 同时，也欢迎查看笔者所著的 [React Native in Action](https://www.manning.com/books/react-native-in-action)，该书目前可以在 Manning Publications 购买。

> 如果你喜欢这篇文章，欢迎推荐和分享！谢谢！
