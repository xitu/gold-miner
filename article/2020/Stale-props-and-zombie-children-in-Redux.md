> * 原文地址：[Stale props and zombie children in Redux](https://kaihao.dev/posts/Stale-props-and-zombie-children-in-Redux)
> * 原文作者：[Kai Hao](https://kaihao.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/Stale-props-and-zombie-children-in-Redux.md](https://github.com/xitu/gold-miner/blob/master/article/2020/Stale-props-and-zombie-children-in-Redux.md)
> * 译者：[niayyy](https://github.com/nia3y)
> * 校对者：[plusmultiply0](https://github.com/plusmultiply0)

# Redux 中过时的 props 和僵尸子节点

如果你读了 `react-redux` v7 发行版本的文档，你可能会碰到[过时的 props 和“僵尸子节点”](https://react-redux.js.org/api/hooks#stale-props-and-zombie-children)这篇文章中提到的部分问题。即使它已经写的非常清晰明了，但对于不熟悉这个问题的人来说会感到迷茫。这篇文章深入探究了这个问题，并讲解了 `react-redux` 是如何解决的。

**免责声明：我不是这个话题下的专家，只是因为好奇而在网上进行了学习，文章内容可能有错误，请保持开放的态度。这篇文章针对已经熟悉 `React`、`Redux` 和 `react-redux` 的人。我们不会在这介绍 API 设计的详细信息，因此，如果你还没有准备好的话，请务必查看官方文档。你无需了解所有这些内容即可使用 `Redux` 进行工作，但是，对于知名库（library）在幕后如何工作有更深入的理解很有趣。**

## 理解 `react-redux`

要理解这个问题，我们必须先理解 `Redux`，或者更具体的来说是 `react-redux`。我们将通过重新实现 `Redux` 和 `react-redux` 的核心功能来进行理解。注意，这只是为了演示的目的，因此我们不会重构每一个功能并对其进行优化，只是足以让我们理解我们需要解决的问题。

`Redux` 的核心是一个在全局状态级别上强制使用 flux 模式操作的订阅模型。在 JavaScript 中一个订阅模型通常通过利用事件监听器来实现的。我们 `subscribe` 更改并通过 `reducers` 改变状态，并发布结果给每一个监听者以执行更新。

```js
const createStore = (reducer, initialState = {}) => {
  let state = initialState;
  const listeners = [];

  return {
    getState() {
      return state;
    },
    subscribe(listener) {
      listeners.push(listener);

      // Returns an unsubscribe function
      return () => {
        const index = listeners.indexOf(listener);
        listeners.splice(index, 1);
      };
    },
    dispatch(action) {
      state = reducer(state, action);

      listeners.forEach(listener => {
        listener();
      });
    },
  };
};
```

上面是一个 `Redux` 的 `createStore` API 的简单实现，我们创建的 `store` 可以使用 `getState()` 来获取状态，通过 `subscribe(listener)` 来订阅监听器，以及通过 `dispatch(action)` 来分发动作（dispatch action），就像我们习惯使用的官方 API 一样。

下一步是弄明白如何将其和 `React` 集成。我们将构建一个 [`<Provider>`](https://react-redux.js.org/api/provider) 组件通过上下文传递 `store`，一个 [`connect`](https://react-redux.js.org/api/connect) 高阶组件用于包装展示组件，最近的版本中，[`useSelector`](https://react-redux.js.org/api/hooks#useselector) 钩子在大多数情况下取代 `connect`。

`<Provider>` API 相对简单，我们只需要通过 `React` 上下文传递由 `createStore` 创建的 `store`。

```jsx
const Context = React.createContext();

const Provider = ({ children, store }) => (
  <Context.Provider value={store}>
    {children}
  </Context.Provider>
);

```

在我们进入 `connect` 和 `useSelector` 的实现之前，最好通过一个实例来回顾一下我们正在处理的问题。实现细节很大程度上取决于 `Redux` 的历史，如果我们对要解决的问题有扎实的背景会更好，这样我们就可以更轻松的讨论实现的演变。

## 问题

让我们快速回顾一下我们要解决的问题的[定义](https://react-redux.js.org/api/hooks#stale-props-and-zombie-children)。


> **过时的 props** 意味着在任何情况下：
> 
> 
> * 选择器函数依赖于此组件的 props 来提取数据
> * 动作的结果会导致父组件**将**重新渲染并传递新的 props
> * 但是，在该组件有机会使用那些新的 props 重渲染之前，这个组件的选择器函数就会执行
> 
> **僵尸子节点**专门指以下情况：
> 
> * 首先，挂载了多个嵌套且相关联的组件，导致子组件在父组件前订阅了 `store`
> * 分发一个从 `store` 中删除数据的动作，例如删除一个 todo 项
> * 父组件将因此停止渲染该子组件
> * 但是，由于子组件先进行了订阅，它的订阅执行于父组件停止渲染它之前，当它基于 props 从 `store` 中读取一个值时，这个数据不复存在，并且如果读取逻辑不完善的话，则可能引发错误。

如果你仔细的阅读以上内容，你可能已经注意到了，这些问题不是两个分开的问题，而是一个单独的问题。他们都是**过时的 props** 问题，**僵尸子节点**描述了一个特定场景常见的子问题。

我们现在还不必了解所有定义。我们在这里提供一个示例来演示代码问题。

## 一个例子

我们将构建的示例是一个非常简单的 Todo 应用程序（我知道，duh），这个应用程序将简单的渲染一组 `todos`，我们可以通过分发 `DELETE` 动作来删除其中的一个。

首先，我们继续，创建一个 `store` 和对应的 `reducer`。

```jsx
const reducer = (state, action) => {
  switch (action.type) {
    case 'DELETE': {
      return {
        ...state,
        todos: state.todos.filter(
          todo => todo.id !== action.payload
        ),
      };
    }
    default:
      return state;
  }
};

const store = createStore(reducer, {
  todos: [{ id: 'a', content: 'A' }],
});
```

然后，让我们创建一个 `<todo>` 组件，并使用 `connect` 进行包装（**我们在这仅使用 `connect` 高阶组件构建 API。稍后再讨论 `useSelector`**）。

```jsx
const Todo = ({ id, content, dispatch }) => (
  <li
    onClick={() => {
      dispatch({ type: 'DELETE', payload: id });
    }}
  >
    {content}
  </li>
);

const TodoContainer = connect((state, ownProps) => ({
  content: state.todos.find(todo => todo.id === ownProps.id)
    .content,
}))(Todo);

const TodoList = ({ todos }) => (
  <ul>
    {todos.map(todo => (
      <TodoContainer key={todo.id} id={todo.id} />
    ))}
  </ul>
);

const TodoListContainer = connect(state => ({
  todos: state.todos,
}))(TodoList);

ReactDOM.render(
  <Provider store={store}>
    <TodoListContainer />
  </Provider>,
  document.getElementById('root')
);
```

我们首先创建两个展示组件 `<Todo>` 和 `<TodoList>`，然后用 `connect` 高阶组件进行包装。这只是使用 `Redux` 模式进行编写的一个非常简单基础的 Todo 应用程序的示例，没有什么特别的。

如果我们运行这个应用程序并点击任何 `<Todo>` 项，我们希望将其删除。

现在，我们了解了我们的应用程序规范，我们将在 `react-redux` 中构建我们的 `connect` 高阶组件。

## 第一种方法

我们先从 `react-redux` v4 版本开始，这时事情变得更简单，并且 API 首次是**完整**和**稳定**的。让我们构建更简单版本的 `connect` 高阶组件 API。**我们正在使用钩子和其他现代的 React 特性来实现，但是应该与基于类的 API 大致相同。是关于未来生活的一件好事，对吧？**

```jsx
// For demonstration purpose, we intentionally omit `mapDispatchToProps`,
// since it's almost the same as `mapStateToProps`.
// Instead, we just pass down `dispatch` as a prop.
const connect = mapStateToProps => WrappedComponent => props => {
  const store = React.useContext(Context);
  const [state, setState] = React.useState(() =>
    mapStateToProps(store.getState(), props)
  );
  const propsRef = React.useRef();
  propsRef.current = props;

  React.useEffect(() => {
    return store.subscribe(() => {
      setState(
        mapStateToProps(store.getState(), propsRef.current)
      );
    });
  }, [store, setState, propsRef]);

  return (
    <WrappedComponent
      {...props}
      {...state}
      dispatch={store.dispatch}
    />
  );
};
```

如果不需要进行优化的话，这可能是 `connect` 最直接的实现。

让我们点击 Todo 项去删除它，看是否有效工作。嗯，好吧，一切都崩溃了。它不能工作了，出什么问题了？

我们像 JavaScript 运行时一样一步一步完成这个过程，看看到底发生了什么。

1. 在第一次渲染时，`<TodoList>` 和 `<Todo>` 在 `useEffect` 中订阅了 `store`。因为 `useEffect` （或者 `componentDidMount`）从下往上触发，`<Todo>` 首先进行订阅，然后是 `<TodoList>`。
2. 用户点击 `<Todo>` 组件，向 `store` 分发了一个 `DELETE` 动作，期待该项被删除。
3. `store` 接收到这个动作后，通过 **reducer** 来运行，然后把 `todos` 的状态改为空数组 `{ todos: [] }`。
4. 然后 `store` 调用已订阅的监听器。因为 `<Todo>` 先进行的订阅，因此也会先调用监听器。
5. `<Todo>` 中的 `connect` 高阶组件触发监听器，调用带有最新的 state（`store.getState()`）和最新的 props（`propsRef.current`）的 `mapStateToProps`。
6. **因为最新的 state 不再有 `todos` 的 state，尝试去访问 `state.todos[ownProps.id]` 导致为 `undefined`。调用 `(undefined).content` 将导致错误💥。**

这就是在动作中著名的`僵尸子节点`问题。**在 Redux 分发后，state 会同步改变，但是渲染则不会。当我们尝试在 `mapStateToProps` 函数中访问 `ownProps`，我们可能会在其中运行过时的 props**。这是类似的原因（之一）[为什么 `setState` 不是同步的](https://github.com/facebook/react/issues/11527#issuecomment-360199710)，管理 `React` 世界之外的一些状态通常需要注意一些陷阱。

我们应该如何进行修复？如果是因为我们管理了 `React` **之外**的状态，是否我们可能把状态放到 `React` **内部**？我们希望 `props` 始终保持最新，这仅在 `React` 使用最新的 props 渲染组件时发生。那么为什么不这样做呢？我们可以把 `mapStateToProps` 改到渲染阶段，我们只需要在监听器回调中触发更新来强制重新渲染。

```jsx
const connect = mapStateToProps => WrappedComponent => props => {
  const store = React.useContext(Context);
  const state = mapStateToProps(store.getState(), props);

  React.useEffect(() => {
    return store.subscribe(() => {
      forceUpdate();
    });
  }, [store, forceUpdate]);

  return (
    <WrappedComponent
      {...props}
      {...state}
      dispatch={store.dispatch}
    />
  );
};
```

现在，当我们点击该项时，他成功删除了自己，万岁🎉！

稍后，PM 来询问我们是否可以将删除延迟到 1 秒，也就是说，单击该项后不会立即删除，而是 1 秒后将其删除。

嗯，听起来很简单！是吧？

```diff
const Todo = ({ id, content, dispatch }) => (
  <li
    onClick={() => {
-      dispatch({ type: 'DELETE', payload: id });
+      setTimeout(() => {
+        dispatch({ type: 'DELETE', payload: id });
+      }, 1000);
    }}
  >
    {content}
  </li>
);
```

我们非常有信心它会工作，我们进行保存，提交，甚至没有测试（你永远不要这样做）直接发布。此后不久，我们收到了大量的投诉，每个人都惊慌失措。当用户点击并等待 1 秒后，应用程序崩溃了，整个应用程序都崩溃了

## `unstable_batchedUpdates`

为什么添加一个简单的 `setTimeout` 会导致整个应用程序崩溃呢？要研究这个问题，我们需要返回并再次执行每个步骤、我们可以通过在代码中添加一堆 `console.log` 来验证输出，但是为了节省时间，在这里只提供结果。前 4 步和之前相同，因此我们直接从第 5 步开始。

**在添加 `setTimeout` 之前：**

5. `<Todo>` 中的 `connect` 高阶组件触发监听器，调用 `forceUpdate()` 来调度重渲染。
6. `<TodoList>` 中的 `connect` 高阶组件触发监听器，调用 `forceUpdate()` 来调度重渲染。
7. `<TodoList>` 渲染，返回的元素是一个空数组 `[]`，只渲染 `<ul>` 容器，`<Todo>` 组件不会渲染。

没有错误，它正常工作。现在，让我们看看当我们添加 `setTimeout` 后，何时会分发动作。前 4 步也是相同的，唯一的区别是在 **（1）** 和 **（2）** 直接存在 1 秒延迟。

**在添加 `setTimeout` 之后：**

5. `<Todo>` 中的 `connect` 高阶组件触发监听器，调用 `forceUpdate()` 来调度重渲染。
6. `<Todo>` 渲染，调用带有最新的 state 和最新的 props 的 `mapStateToProps`。
7. 因为父组件（`<TodoList>`）还没有渲染，`<Todo>` 中的 props 实际上是**过时的 props**，但是 state 已经是最新的了。调用 `state.todos[ownProps.id]` 导致为 `undefined`，调用 `(undefined).content` 导致一个错误。

请注意，在这两种情况下，第六步是不同的。前者在父组件（`<TodoList>`）中调用另一个监视器，而后者首先渲染子组件（`<Todo>`）。 **似乎是调用 `forceUpdate()` 不久后，`<Todo>` 同步重渲染了！**

“等等，我以为 `setState` 是异步的？” 是的，当然不会。在大多数情况下， `setState` 实际上是异步的，[只要 `setState` 在 React 事件处理回调中调用即可](https://twitter.com/dan_abramov/status/959507572951797761)，React 将确保在事件处理回调中**批处理**所有的更新，并一次异步执行所有的渲染。通过在 `setTimeout` 回调中包装 `setState`，我们**选择取消** 这个特性，并使 `setState` 同步。

在我们上面的例子中，React 把 `<Todo>` 组件的 `forceUpdate()` 和 `<TodoList>` 组件的 `forceUpdate()` 放在一个事件处理回调中，然后最终让它们一次进行渲染。**这里另一个重要的说明是，在重渲染过程中，React 将确保从下到上执行。**这就是为什么父组件（`<TodoList>`）首先进行重渲染，然后跳过 `<Todo>` 渲染的原因。

幸运的是，在将来的某个版本中，[React 将可能确保所有的 `setState` 都是异步的](https://twitter.com/dan_abramov/status/959557687158689792)，这意味着即使我们把 `setState` 放到 `setTimeout` 里面，更新仍然将分批进行。

所以我们仅仅是进行等待吗？当然不是。现在还有另一种解决方法。

React，或者更准确的说，`react-dom`，有一个隐藏特性：`unstable_batchedUpdates`，能够精确的实现我们想要确保的更新在一起批处理。[React 中事件处理程序已经在内部使用此 API](https://react-redux.js.org/api/batch)，这是为什么在事件处理中 `setState` 将是异步的。**(正如他的名字暗示的那样，我们应该完全理解后再使用它。我们已经被警告了。**)

我们简单的在 `unstable_batchedUpdates` 回调中来包装我们的 `dispatch` 方法。

```diff
+import { unstable_batchedUpdates } from 'react-dom';

const Todo = ({ id, content, dispatch }) => (
  <li
    onClick={() => {
      setTimeout(() => {
-        dispatch({ type: 'DELETE', payload: id });
+        unstable_batchedUpdates(() => {
+          dispatch({ type: 'DELETE', payload: id });
+        });
      }, 1000);
    }}
  >
    {content}
  </li>
);
```

还有另一个地方我们可以添加 `unstable_batchedUpdates`。我们也可以简单的包装我们 store 分发方法，来代替包装每个带有 `unstable_batchedUpdates` 的 `dispatch` 调用。

```diff
dispatch(action) {
  state = reducer(state, action);

+  unstable_batchedUpdates(() => {
    listeners.forEach(listener => {
      listener();
    });
+  });
},
```

它工作良好。这实际上就是 `react-redux` v4 的实现，没有许多其他必要的优化，像[记住返回的元素](https://github.com/reduxjs/react-redux/blob/v4.4.0/src/components/connect.js#L238-L270)，或者[如果 `mapStateToProps` 函数不依赖于 `ownProps`，则尽早进行更新](https://github.com/reduxjs/react-redux/pull/348)。 即使进行了这些优化，在最坏的情况下，每次状态更改时，我们仍然会强制容器组件进行重渲染。对于一个很小的应用程序，它应该还不错，但是对于一个可扩展的全局状态管理库，它很快就变得无法接受。

## 嵌套订阅模型

我们希望最小化容器组件中的渲染调用，因此我们想出一种方法来在 `forceUpdate()` 调用之前的监听器回调中尽早跳过更新。我们还想强制执行**自上而下的命令**，这样我们就不会再提出过时的 props 和僵尸子节点问题。

Redux 团队提出了一种有趣的方法来解决 `react-redux` v5 中的问题。通过使用**嵌套订阅模型**，我们可以尽早跳过更新，还可以避免过时的 props 问题。

**基本思想是，我们延迟监听器回调的触发，直到父级完全重渲染为止，用来代替分批地进行更新以使其自上而下**。这样，我们可以确保更新始终是自上而下的，孩子不会在监听器回调中获得**过时的 props**，因为当我们触发回调时，props 已经是最新的了。

一个代码片段价值一千句话。

```js
const createSubscription = () => {
  const listeners = [];

  return {
    subscribe(listener) {
      listeners.push(listener);

      // Returns an unsubscribe function
      return () => {
        const index = listeners.indexOf(listener);
        listeners.splice(index, 1);
      };
    },
    notifyUpdates() {
      listeners.forEach(listener => {
        listener();
      });
    },
  };
};
```

我们创建一个 `createSubscription`，它和 `createStore` 函数非常像，它也有监听器，和 `subscribe` 函数。不同之处是它不保存任何的状态，也有一个 `notifyUpdates()` 方法。这个 `notifyUpdates()` 方法用来通知它的所有的孩子节点，来触发它们的监听器回调，我们将在之后进行更多的讨论。

你可能会注意到，这只是创建事件触发器的函数，这是非常正确的，并且它就这么的简单。下一步是编写新的 `connect` 高阶组件，并将其 `mapStateToProps` 放入监听器回调中，以尽早跳过更新。

```jsx
const connect = mapStateToProps => WrappedComponent => props => {
  const store = React.useContext(Context);

  const subStore = React.useMemo(
    () => ({
      ...store,
      ...createSubscription(),
    }),
    [store]
  );

  const [, forceUpdate] = React.useReducer(c => c + 1, 0);
  const stateRef = React.useRef();
  stateRef.current = mapStateToProps(
    store.getState(),
    props
  );
  const propsRef = React.useRef();
  propsRef.current = props;

  React.useEffect(() => {
    return store.subscribe(() => {
      const nextState = mapStateToProps(
        store.getState(),
        propsRef.current
      );

      if (shallowEqual(stateRef.current, nextState)) {
        // Bail out updates early, immediately notify updates to children
        subStore.notifyUpdates();
        return;
      }

      forceUpdate();
    });
  }, [store, propsRef, stateRef, forceUpdate, subStore]);

  React.useEffect(() => {
    subStore.notifyUpdates();
  }); // Don't pass dependencies so that it will run after every re-render

  return (
    <Provider store={subStore}>
      <WrappedComponent
        {...props}
        {...stateRef.current}
        dispatch={store.dispatch}
      />
    </Provider>
  );
};
```

这里有很多事情，让我们一一分解。基本实现有点类似于我们的第一种方法。我们通过创建一个我们刚刚实现的 `subscription` 来创建一个新的 `subStore`，并将其与原始的 `store` 合并。结果，该 `subscribe` 方法将覆盖 `store` 中原始的 `subscribe` 方法，并添加一个名为的 `notifyUpdates` 的新方法。

我们在 2 个地方运行 `mapStateToProps` 选择器。我们在渲染阶段运行我们的 `mapStateToProps`，以便在回调中调用 `forceUpdate()` 之后总是获得最新的 props。在我们的监听器回调中，我们可以看到我们也直接在它内部使用 `mapStateToProps`，并且进行了一个浅对比，以确定如果映射状态不变，是否可以跳过更新。

在 return 语句中，我们再次用该 `<Provider>` 组件包装我们的组件，并用新创建的 `subStore` 来显式覆盖 store 上下文。这样组件树下的每个组件都将获得 `subStore` 而不是最顶层的 `store`。

最后，我们创建另一个叫做 `subStore.notifyUpdates()` 的副作用，以便**在每次渲染之后**调用组件树下的所有子级。**直到下一个渲染中最新的 props 已经传递给子节点时，才会调用子节点的回调**，从而消除了**过时的 props** 问题。

再次单击该项，该项现在将成功删除而不会引发任何错误。为了使流程更清晰，我们可以再次执行每个步骤，以确保其按预期工作。

1. 在第一次渲染后，`<Todo>` 订阅 `<TodoList>` 创建的 `subStore` 然后通过 `useEffect` 中的 `Provider` 向下传递。
2. 然后 `<TodoList>` 订阅在它的 `useEffect` 中通过 `createStore` 创建的全局的 `store`。
3. 用户点击 `<Todo>`，向 store 分发一个 `DELETE` 动作，期望该项被删除。
4. store 收到这个动作，通过 **reducer** 运行它。并将 `todos` 状态更改为一个空数组 `{ todos: [] }`。
5. `store` 然后调用订阅监听器。因为仅有一个监听器订阅了 `store`，仅仅 `<TodoList>` 的监听器将调用，`<Todo>` 的则不会。
6. `<TodoList>` 调用监听器回调，调用带有最新状态（`store.getState()`）和最新 props （`propsRef.current`）的 `mapStateToProps`。
7. 映射状态并不完全相等，因此我们计划使用 `forceUpdate()` 进行更新。`<TodoList>` 然后在渲染阶段再次调用 `mapStateToProps` 并返回一个空的 `<ul>` 因为列表中不再有任何项。
8. `<Todo>` 将会卸载，因此它将调用副作用中的 `unsubscribe` 函数，从 `subStore` 中的 `listeners` 数组中移除它的监听器回调。
9. `<TodoList>` 调用副作用并在渲染后运行 `subStore.notifyUpdates()`，因为我们没有在 `subStore` 中留下任何要调用的侦听器，因此整个过程成功完成。

对于仍然剩下一些子节点的情况，每个子节点将随后调用它们的监听器回调。因为它们将在渲染后被调用，所以它们将从父组件那里获得最新的 props。

有趣的是，我们在子组件中运行了两次 `mapStateToProps`，一次是在监听器回调内，而另一次是由父组件的重渲染触发的。后者应该在前者之前发生，但是状态和 props 都应该是最新的，并且在每次运行中都应该相同。为了进一步优化性能，我们可以记住这个 `mapStateToProps` 函数，以便在这种情况下不必调用两次。

注意，我们甚至不必在 `notifyUpdates` 函数中使用 `unstable_batchedUpdates`。同一层次结构调用中的更新被**划分**到不同的 `subStore`，子组件仅在父组件完成重渲染后才调用监听器回调，因此无需将它们一起批处理。

这是 `react-redux` 在 v5 和 v7 中实现嵌套订阅模型的基本思想（当然，缺少大量的优化）。[当我们可以提早批准更新并且不必尽可能调用 React 的时候，结果将大大提高性能](https://github.com/reduxjs/react-redux/pull/416)。另外，我们可以摆脱 `unstable_batchedUpdates`，这是很难包含在 `react-redux`中的（它来自 `react-dom` 但 `react-redux` 也可以在其他渲染器中使用）。这是一个巨大的胜利！

## React 上下文

有一个更简单的方法可以通过使用 React 上下文来解决。我们已经在使用它来传递 `store` 实例，为什么不让它也对状态更改做出反应？当 React 上下文的稳定版本首次出现时，`react-context` v6 采用这种方法。该方法似乎容易得多，并且由于状态渲染传播是由 React 处理的，因此我们轻松获得了自上而下的更新。没有更多的 `unstable_batchedUpdates`，没有更多的嵌套订阅模型。事件监听器的数量也减少到了一个，我们不再需要订阅每个 connect 高阶组件。

```jsx
// Again, there're lack of many optimizations and error handlings
// in this implementation for demonstration purpose.
const Provider = ({ children, store }) => {
  const [state, setState] = React.useState(() =>
    store.getState()
  );

  React.useEffect(() => {
    return store.subscribe(() => {
      setState(store.getState());
    });
  }, [store, setState]);

  const context = React.useMemo(
    () => ({
      ...store,
      state,
    }),
    [store, state]
  );

  return (
    <Context.Provider value={context}>
      {children}
    </Context.Provider>
  );
};

const connect = mapStateToProps => WrappedComponent => props => {
  const { state, dispatch } = React.useContext(Context);

  const mappedState = mapStateToProps(state, props);

  return (
    <WrappedComponent
      {...props}
      {...mappedState}
      dispatch={dispatch}
    />
  );
};
```

一切看起来都如此完美，实现看起来很简单，我们仍然可以像第一种方法（`react-redux` v4）一样进行优化，我们不再需要处理过时的 props 和僵尸子节点问题。从本质上讲，这就是我们通常在用户区域中所做的事情，以及一些受欢迎的库，像 [`unstated-next`](https://github.com/jamiebuilds/unstated-next) 为我们所做的事情。不过，对于只有一个全局 store 的 `Redux` 来说，拥有多个更小的 store 可能是一个完美的解决方案。性能成本非常高，足以迫使我们再次对其进行迭代。

还记得为什么我们要从第一种方法迭代到嵌套订阅模型吗？这样一来，我们甚至可以在调用 `setState` 和重渲染组件之前就尽早跳过更新。在这种方法中，由于我们只能在渲染阶段获得整个状态，**因此这意味着我们必须始终先调用 `setState` 然后重渲染组件才能在之后获得最新状态**。只有到那时，我们才能调用 `mapStateToProps` 来获得组件关心的映射状态。实际上，在 `react-redux` v6 首次发布时，有一些[性能下降事件](https://github.com/reduxjs/react-redux/issues/1164)。此外，[React 团队甚至提到他们不建议当时使用 React 上下文进行类似 flux 的状态传播](https://github.com/facebook/react/issues/14110#issuecomment-448074060)。

## 钩子

React 上下文不是 React 家族中的最新成员，我们还有 hook（钩子）！`react-redux` v7 引入了新的基于钩子的 API，这些 API 使代码更加简单易懂。最重要的钩子可能是 `useSelector` 钩子。

但是首先，我们将重写我们的 Todo 应用程序以使用钩子。更具体地说，`<Todo>` 和 `<TodoList>` 组件。

```jsx
const Todo = ({ id }) => {
  const content = useSelector(
    state =>
      state.todos.find(todo => todo.id === id).content
  );
  const dispatch = useDispatch();

  return (
    <li
      onClick={() => {
        dispatch({ type: 'DELETE', payload: id });
      }}
    >
      {content}
    </li>
  );
};

const TodoList = () => {
  const todos = useSelector(state => state.todos);

  return (
    <ul>
      {todos.map(todo => (
        <Todo key={todo.id} id={todo.id} />
      ))}
    </ul>
  );
};
```

我们不再需要那些带有钩子的高阶函数容器，我们可以调用 `useSelector` 和 `useDispatch` 来获取选定的状态和分发方法。请注意一个微小的差别在普通的旧的 `mapStateToProps` 和 `useSelector` 之间的是我们不再获取状态（state）的**对象**，并将其传播到 props，而是仅仅得到状态本身。因此代替获得 `{ content }`，我们只需要得到 `content`。在我们的 `setState` 中会稍微改变我们的相等性检查。

`useDispatch` 钩子实现也很简单。

```js
const useDispatch = () =>
  React.useContext(Content).dispatch;
```

我们也可以轻松创建我们的 `useSelector` 钩子。

```js
const useSelector = selector => {
  const store = React.useContext(Context);
  const [, forceUpdate] = React.useReducer(c => c + 1, 0);
  const state = selector(store.getState());

  React.useEffect(() => {
    return store.subscribe(() => {
      forceUpdate();
    });
  }, [store, forceUpdate]);

  return state;
};
```

但是，它甚至还不能立即使用。每次状态更新时，我们都会重渲染所有的 **connected** 组件。使用钩子 API 会更加糟糕，因为我们没有一个中间容器组件，该组件通常能进行廉价的渲染，可以挽救通常更昂贵的包装组件的更新。与以前的权衡取舍不同，我们有点必须把 `selector` 放入监听器回调中以尽早跳过更新。

```js
const useSelector = selector => {
  const store = React.useContext(Context);
  const [state, setState] = React.useState(() =>
    selector(store.getState())
  );

  React.useEffect(() => {
    return store.subscribe(() => {
      setState(selector(store.getState()));
    });
  }, [store, setState, selector]);

  return state;
};
```

这个版本只是简单的打破。我们在整个文章中再次提到**过时的 props 和僵尸子节点**问题。与往常一样，我们将遍历每个步骤，以查看错误的出处和原因。

1. 在第一次渲染后，`<TodoList>` 和 `<Todo>` 组件在  `useEffect` 中订阅 store。因为 `useEffect` 自上而下触发，`<Todo>` 首先订阅，然后是 `<TodoList>`。
2. 用户点击 `<Todo>`，向 store 分发一个 `DELETE` 动作，期待该项被删除。
3. store 收到这个动作,通过 **reducer** 运行它，然后将 `todos` 状态更改为空数组 `{ todos: [] }`。
4. 然后，store 调用已订阅的监听器。由于 `<Todo>` 先订阅，因此也会先调用它的监听器。
5. **由于我们在渲染阶段传递 `props` 给 `listener`，在那时其形成了封闭的 `props`。它们是过时的 props**。访问 `state.todos[ownProps.id]` 将导致 `undefined`，然后调用 `(undefined).content` 将导致一个错误💥。

回想一下到目前为止我们对过时的 props 问题的了解。**当子节点们使用从 store 派生的 props 时，过时的 props 将在同步订阅模型中发生**。到目前为止，有2个解决方案。

1. 移动 `selector` 到渲染阶段和使用 `unstable_batchedUpdates`
2. 使用嵌套订阅模型

钩子无法更改渲染树，因此我们无法为每个组件添加一个新的 `<Provider>`，以使其传播到最近的父级 subStore。我们可以快速排除第二种解决方案。

对于第一个解决方案，当我们仅在渲染阶段使用 `selector`，它的性能不佳，会导致每次更改都需要重渲染，因此我们必须在监听器回调中尽早跳过更新。再者，如果我们在监听器回调中调用过时的 props 则可能会导致 `selector` 抛出错误。

我们的双手被束缚，尚无解决方案，我们必须做出一些妥协。

如果我们忽略该错误会发生什么？我们首先要问自己一个问题：何时会发生错误？大约有 2 种情况。错误可能是由于选择器本身的错误而引起的，或者因为僵尸子节点问题导致了意外错误。无论哪种方式，我们都希望通过重新渲染组件并在渲染阶段应用 `selector(store.getState())` 以获取最新状态来安全地处理它们。前一种情况将在渲染阶段**重新引发**错误，而后者将不会产生任何错误。

那种不会抛出过时的 props 问题呢？我们仍然可以得到不一致状态但没有错误的情况。在这种情况下，无论如何组件仍然会在以后重新渲染，因为我们仍将处于 `selector(store.getState())` 渲染阶段，因此由于我们上面提到的第一个解决方案，问题将消失。

看起来我们可以在第 5 步中安全地忽略该错误，而在渲染阶段重试该错误。

```js
const useSelector = selector => {
  const store = React.useContext(Context);
  const [, forceUpdate] = React.useReducer(c => c + 1, 0);
  const currentState = React.useRef();
  // Try to get the state in the render phase to safely get the latest props
  currentState.current = selector(store.getState());

  React.useEffect(() => {
    return store.subscribe(() => {
      try {
        const nextState = selector(store.getState());

        if (nextState === currentState.current) {
          // Bail out updates early
          return;
        }
      } catch (err) {
        // Ignore errors
      }

      // Either way we want to force a re-render
      forceUpdate();
    });
  }, [store, forceUpdate, selector, currentState]);

  return currentState.current;
};
```

结合 `unstable_batchedUpdates` 的技巧，我们可以在选定状态不变的情况下尽早跳过更新，并安全地防止过时的 props 和僵尸子节点问题。我们再次运行代码，并检查一切是否正常运行。前 4 个步骤相同，因此我们从第 5 步开始。

5. 由于我们在渲染阶段传递 `props` 给 `listener`，在那时，其形成了封闭的 `props`，换句话说，它是**过时的 props**。访问 `state.todos[ownProps.id]` 将导致 `undefined`，然后调用 `(undefined).content` 将导致错误。**我们故意捕获并隐藏错误，这是当我们知道要在渲染阶段选择状态，从而触发重渲染时**。
6. 由于我们正在使用 `unstable_batchedUpdates`，渲染已被批处理。`<TodoList>` 触发其监听器回调，`selector(store.getState())` 的结果为 `[]`，也计划重渲染。
7. 渲染从上向下进行操作，`<TodoList>` 先渲染，然后再次调用 `selector(store.getState())`，返回一个空的 `<ul>`，完成渲染。

在这种方法中，我们假设用户提供的 `selector` 函数必须遵循 2 条规则。

1. `selector` 没有任何副作用。
2. 代码不依赖也不期望 `selector` 抛出错误。

简而言之，`selector` 必须是一个**纯函数**。在更新过程中，我们可能会运行 `selector` 多次。只要 `selector` 是纯的，那么多次运行它们就不成问题。而且，`React.StrictMode` 已经执行了一段时间的渲染规则，在 `selector` 中，这样做也是一种更好的做法。

我们也可以决定以用户身份自行处理问题。谨慎地保护 `selecto` 函数并适当地处理错误，虽然有点多，但是仍然是一个很好的解决方案。

我们可以做更多的优化来增强性能，例如仅在需要时（当它有过时的 props 或选择器发生更改时）在渲染阶段才强制其调用 `selector`。但是，这是 `useSelector` 在后台如何工作以及为什么我们必须保持选择器为**纯的**基本思想。

## 收获

Phew！这是一段漫长的旅程。给自己一个走到最后的掌声。跟着走并不容易！

重新创建 `Redux` 看起来很简单，但要小心处理许多陷阱。在这篇文章中，我们甚至没有提到大量的优化和错误处理。

希望这篇文章对你更好地了解 `Redux` 和 `react-redux` 的背后的工作原理很有帮助。也赞扬所有维护者和贡献者创建了如此出色的库并不断地对其进行改进。即使我同意你可能不需要 `Redux`，它仍然为中型乃至大型团队提供了一种有用的模式，使他们可以顺利地进行协作。

下次，当你发现其它人将 `Redux` 视为理所当然时，请问他/他如何解决**过时的 props 和僵尸子节点**问题，并向她/他展示此帖子😉。

## 参考文章

* [Idiomatic Redux: The History and Implementation of React-Redux](https://blog.isquaredsoftware.com/2018/11/react-redux-history-implementation/)
* [reduxjs/react-redux#99 (Fix issues with stale props #99) Where the stale props first fixed back in v4](https://github.com/reduxjs/react-redux/pull/99)
* [reduxjs/react-redux#292 (Can we avoid inconsistencies on non-batched dispatches?) Where Dan found that the order doesn't matter, but batching updates does](https://github.com/reduxjs/react-redux/issues/292)
* [reduxjs/react-redux#1177 (React-Redux Roadmap: v6, Context, Subscriptions, and Hooks)](https://github.com/reduxjs/react-redux/issues/1177)
    * [Mark explains that `unstable_batchedUpdates` isn't sufficient for fixing stale props due to performance reason](https://github.com/reduxjs/react-redux/issues/1177#issuecomment-468765242)
* [reduxjs/react-redux#1179 (Discussion: Potential hooks API design)](https://github.com/reduxjs/react-redux/issues/1179)
    * [A comment by the author of the hooks API proposal](https://github.com/reduxjs/react-redux/issues/1179#issuecomment-482164630)
    * [Example test cases for stale props with hooks](https://github.com/reduxjs/react-redux/issues/1179#issuecomment-483617153)
* ..., and many more which I simply cannot recall where I read them.


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
