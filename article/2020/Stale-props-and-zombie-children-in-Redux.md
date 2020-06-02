> * 原文地址：[Stale props and zombie children in Redux](https://kaihao.dev/posts/Stale-props-and-zombie-children-in-Redux)
> * 原文作者：[Kai Hao](https://kaihao.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/Stale-props-and-zombie-children-in-Redux.md](https://github.com/xitu/gold-miner/blob/master/article/2020/Stale-props-and-zombie-children-in-Redux.md)
> * 译者：
> * 校对者：

# Stale props and zombie children in Redux


If you have read the `react-redux` v7 release documentation, you might have come across the section where it mentioned the [stale props and "zombie children"](https://react-redux.js.org/api/hooks#stale-props-and-zombie-children) problem. Even though it's very well written and clear, it might seem a little bit vague for someone who's not familiar with the problem. This post is about deep diving into the problem and understanding how `react-redux` solved it.

****Disclaimer**: I'm not an expert on this topic but just being curious to study it online, I could be wrong, keep open-minded. This post is for someone who has already been familiar with React, Redux, and `react-redux`. We won't cover the details of the API design here, so be sure to check out the official documentation if you haven't already. You don't have to understand all of this post to be productive with Redux, however, it's fun to have a deeper knowledge on how the well-known library works under the hood.**

## Understanding `react-redux`

To understand the problem, we have to first understand Redux, or more specifically, `react-redux`. We're going to do that by re-implementing the core features of Redux and `react-redux` together. Note that it's only for demonstration purpose, so we're not going to re-build every feature and optimization of them but just enough to get us to understand the problem we're going to solve.

At its core, Redux is a subscription model which enforce the flux pattern operating at the global state level. A subscription model in JavaScript is often achieved by leveraging event listeners. We `subscribe` to changes and mutate the state via `reducers`, and emit the result to every listener to perform updates.

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

Above is a bare minimum implementation of the Redux's `createStore` API. The store we use it to create can get the state with `getState()`, subscribe to listeners via `subscribe(listener)`, and dispatch actions with `dispatch(action)`, just like the official API we're used to.

The next step is to figure out how to integrate it with React. We're going to build a [`<Provider>`](https://react-redux.js.org/api/provider) component to pass down `store` via context, a [`connect`](https://react-redux.js.org/api/connect) HOC to wrap presentational components, and most recently, a[`useSelector`](https://react-redux.js.org/api/hooks#useselector) hook to replace `connect` in most cases.

The `<Provider>` API is relatively straightforward, we just have to pass down the `store` created by `createStore` via React's context.

```jsx
const Context = React.createContext();

const Provider = ({ children, store }) => (
  <Context.Provider value={store}>
    {children}
  </Context.Provider>
);

```

Before we jump into the implementation of `connect` and `useSelector`, it's best to first recap the problem we're dealing with and see an example in action. The implementation details heavily depend on the history of Redux, it'll be better if we can have a solid background on things we're trying to fix so that it's easier for us to discuss the evolution of the implementation.

## The problem

Let's quickly recap the problems' [definitions](https://react-redux.js.org/api/hooks#stale-props-and-zombie-children) we are trying to address.


> **Stale props** means any case where:
> 
> 
> * a selector function relies on this component's props to extract data
> * a parent component **would** re-render and pass down new props as a result of an action
> * but this component's selector function executes before this component has had a chance to re-render with those new props
> 
> **Zombie child** refers specifically to the case where:
> 
> * Multiple nested connected components are mounted in a first pass, causing a child component to subscribe to the store before its parent
> * An action is dispatched that deletes data from the store, such as a todo item
> * The parent component would stop rendering that child as a result
> * However, because the child subscribed first, its subscription runs before the parent stops rendering it. When it reads a value from the store based on props, that data no longer exists, and if the extraction logic is not careful, this may result in an error being thrown.

If you've read them very closely, you might have noticed that these are not two separated problems, but a single one. They're both the **stale props** problem, **zombie children** is a common sub-problem of it which describes a certain scenario.

We don't have to understand every bit of the definitions just yet. We're here to provide an example to demonstrate the problem with code.

## An example

The example we're going to build is a very simple todo app (I know, duh) which simply renders a set of `todos`, and we can remove one of them by dispatching a `DELETE` action.

First, we go ahead and create a store and the according reducer.

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

Then, let's create a todo component, and wrap it with `connect` **(We are building the API using `connect` HOC only here. We'll talk about `useSelector` later).**

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

We first create two presentational components `<Todo>` and `<TodoList>`, and then wrap them with the `connect` HOC. It's just a very simple and basic example of a Todo app written in `Redux` pattern, nothing's special about it.

If we run the app and click on any `<Todo>` item, we would expect it to be deleted.

Now that we understand our application spec, we are going to build our `connect` HOC in `react-redux`.

## First approach

We are starting from `react-redux` v4 when things are simpler and the APIs are **completed** and **stable** for the first time. Let's build our simpler version of `connect` HOC API. **We are using hooks and other modern React features for the implementation, but it should be mostly the same as the class-based APIs. A good thing about living in the future, huh?**

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

It might be the most straightforward implementation of `connect`, without almost all of the optimizations.

Let's click the item to delete it to see if it works. Uh, okay, everything is falling apart. It won't work. What's wrong?

We can go through the process step-by-step like a JavaScript runtime and see what exactly happened.

1. After the first render, Both `<TodoList>` and `<Todo>` subscribe to the store in `useEffect`. Since `useEffect` (or `componentDidMount`) fires from bottom to top, `<Todo>` subscribes first, then `<TodoList>`.
2. The user clicks `<Todo>`, dispatches a `DELETE` action to store, expects the item to be deleted.
3. The store receives the action, runs it through the **reducer**, and changes the `todos` state to an empty array `{ todos: [] }`.
4. The store then calls the subscribed listeners. Since `<Todo>` subscribes first, it will also call the listener first.
5. The `connect` in `<Todo>` HOC fires the listener, calls `mapStateToProps` with the latest state (`store.getState()`) and the current props (`propsRef.current`).
6. **Since the state doesn't have the `todos` state anymore, trying to access `state.todos[ownProps.id]` will result in `undefined`. Calling `(undefined).content` will result in error 💥.**

This is the famous `zombie children` problem in action. **Changing the state happens synchronously after dispatching in Redux, but rendering is not. Whenever we are trying to access `ownProps` in our `mapStateToProps` function, we could potentially have **stale props** running inside it.** It's the similar (one of the) reason [why `setState` is not synchronous](https://github.com/facebook/react/issues/11527#issuecomment-360199710), managing the state outside of `React`'s world often has some gotchas needed to be paid attention to.

How can we fix it though? If it's because we're managing the state **outside** of React, can we just bring it **inside** React? We want the `props` to always stay up-to-date, which only happens when React renders the component with the latest props. So why not do that? We can move our `mapStateToProps` to render phase instead, we just have to trigger an update in the listener callback to force a re-render.

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

Now when we click the item, it successfully deletes itself. Hooray 🎉!

Later, the PM comes and asks if we can delay the deletion to 1 second, that is, the item won't get deleted immediately after clicked, but 1 second later.

Hmm, alright, sounds easy! Right?

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

We were so confident that it would work, we saved it, committed, and released it without even testing it (which you should never do). Soon after that, we got complains bombing our channels and everyone is panicking. The app broke, just after the user clicked and waited for that 1 second, the whole app crashed.

## `unstable_batchedUpdates`

Why does adding a simple `setTimeout` cause the whole app to crash? To examine this issue, we have to go back and follow each step again. We can do this by adding a bunch of `console.log` in the code and verify the output, but we're going to save some time here and just provide the result. The first 4 steps are the same as before, so we can start from the 5th.

**Before adding `setTimeout`:**

5. The `connect` in `<Todo>` HOC fires the listener, calls `forceUpdate()` to schedule a re-render.
6. The `connect` in `<TodoList>` HOC fires the listener, calls `forceUpdate()` to schedule a re-render.
7. `<TodoList>` renders, the returned element is an empty array `[]`, just renders the `<ul>` wrapper. `<Todo>` never renders.

No errors, it works just fine. Now let's see when we add `setTimeout` while dispatching the action. The first 4 steps are also the same, the only difference is that between **(1)** and **(2)**, there's a delay for 1 second.

**After adding `setTimeout`:**

5. The `connect` in `<Todo>` HOC fires the listener, calls `forceUpdate()` to schedule a re-render.
6. `<Todo>` renders, calls `mapStateToProps` with current state and current props.
7. Since the parent (`<TodoList>`) hasn't rendered yet, the props in `<Todo>` are in fact the **stale props**, but the state is already the latest. Calling `state.todos[ownProps.id]` results in `undefined` and calling `(undefined).content` results in an error.

Note that between these 2 cases, the 6th step is different. The former is calling the other listener in the parent (`<TodoList>`), while the latter renders the child (`<Todo>`) first. **Seems like `<Todo>` synchronously re-renders soon after calling `forceUpdate()`!**

"Wait, I thought `setState` is asynchronous?" Yes, and of course, no. For most cases, `setState` is in fact asynchronous, [as long as the `setState` call is inside React event handler callback](https://twitter.com/dan_abramov/status/959507572951797761). React will ensure to **batch** all updates inside the event handler callback, and perform the render all at once asynchronously. By wrapping `setState` inside a `setTimeout` callback, we **opt-out** of this feature and make `setState` synchronous.

In our example above, React batches both `<Todo>`'s `forceUpdate()` and `<TodoList>`'s `forceUpdate()` together and then finally render them all at once. **Another important note here is that during the re-render, React will ensure to perform it from top to bottom.** That's why the parent (`<TodoList>`) will re-render first, and then skip rendering `<Todo>`.

Fortunately, sometime in the future, [React probably will make sure all `setState` is asynchronous](https://twitter.com/dan_abramov/status/959557687158689792), which means that even if we put our `setState` inside `setTimeout`, the updates would still batch together.

So we're just going to wait? Of course not. There's another way to fix this now.

React, or more accurately, `react-dom`, has a hidden feature: `unstable_batchedUpdates`, which does exactly what we want to make sure that the updates are batched together. [The event handler in React is already using this API internally](https://react-redux.js.org/api/batch), that's why in event handler the `setState` will be asynchronous. **(As its name suggested, we shouldn't use it unless we fully understand it. We've been warned.**)

We simply wrap our `dispatch` method into the `unstable_batchedUpdates` callback.

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

There's also another place we can add `unstable_batchedUpdates` to. Instead of wrapping every `dispatch` calls with `unstable_batchedUpdates`, we can simply wrap in our store dispatch method.

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

It works. It is actually what `react-redux` v4 implementation is, without a bunch of other essential optimizations, like [memoizing the returned elements](https://github.com/reduxjs/react-redux/blob/v4.4.0/src/components/connect.js#L238-L270), or [bailing out updates early if the `mapStateToProps` function doesn't depend on `ownProps`](https://github.com/reduxjs/react-redux/pull/348). Even with these optimizations, we're still forcing the container components to re-render every time the state changed in the worst cases. For a tiny app, it should be just fine, but for a global state management library designed to be scalable, it soon becomes unacceptable.

## Nested subscriptions model

We want to minimize the render calls in the container component, so we want to come up with a way to bail out updates early inside the listener callback before the `forceUpdate()` call. We also want to enforce the **top-down order** so that we don't re-introduce the stale props and zombie children problem.

Redux team came up with an interesting approach to address this in `react-redux` v5. By using the **nested subscriptions model**, we can bail out updates early and also avoid the stale props problem.

**The basic idea is that instead of batching the updates to make it top-down, we delay the firing of the listener callbacks until the parents have fully re-rendered.** This way, we can be sure the updates are always top-down, the children won't get **stale props** in the listener callback because the props are already the latest when we trigger the callbacks.

A code snippet is worth a thousand words.

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

We create a `createSubscription` function, which is much like `createStore`, it also has the listeners and `subscribe` function. The differences are that it doesn't keep any states, and also have a `notifyUpdates()` method. The `notifyUpdates()` method is used to notify all of the children below to trigger their listener callbacks, we'll discuss more on that later.

You might notice that this is simply just a function to create an **event emitter**, which is exactly right and it's just as simple as that. The next step is to write our new `connect` HOC and put our `mapStateToProps` inside the listener callbacks to bail out updates early.

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

There're a lot of things going around here, let's break them down one by one. The basic implementation is somewhat similar to our first approach. We create a new `subStore` by creating a `subscription` we just implemented and merge it with our original `store`. As a result, the `subscribe` method will override the original `subscribe` method in `store`, and also add a new method called `notifyUpdates`.

There are 2 places where we run our `mapStateToProps` selector. We run our `mapStateToProps` in the render phase so that they will always get the latest props after we call `forceUpdate()` in the callback. In our listener callback, we can see that we're also using `mapStateToProps` directly inside it and doing a shallow comparing to determine if we can bail out updates if the mapped state does not change.

In the return statement, we wrap our component again with the `<Provider>` component, and explicitly overriding the store context with our newly created `subStore`. So that every component below the tree will get our `subStore` rather than the top-most `store`.

Lastly, we create another effect to call `subStore.notifyUpdates()` to all the children below the tree **after every render**. **The children's callbacks won't get called until the latest props have already passed down to them in the next render**, thus eliminating the **stale props** problem.

Click the item again, the item will now successfully be deleted without throwing any errors. To make the process clearer, we can go through each step again to see that it works as we expected.

1. After the first render, `<Todo>` subscribes to the `subStore` that `<TodoList>` created and passed down via `Provider` in `useEffect`.
2. Then `<TodoList>` subscribes to the global `store` created by `createStore` in it's `useEffect`.
3. The user clicks `<Todo>`, dispatches a `DELETE` action to store, expects the item to be deleted.
4. The store receives the action, run it through the **reducer**, and change the `todos` state to an empty array `{ todos: [] }`.
5. The `store` then calls subscribed listeners. Since there's only one listener subscribed to `store`, only `<TodoList>`'s listener will be called, `<Todo>` won't.
6. `<TodoList>` calls the listener callback, calls `mapStateToProps` with the latest state (`store.getState()`) and the latest props (`propsRef.current`).
7. The mapped state is not shallowly equal, so we schedule an update with `forceUpdate()`. `<TodoList>` then calls `mapStateToProps` again in the render phase and return an empty `<ul>` since there're no items in the list anymore.
8. `<Todo>` will unmount, so it calls the unsubscribe function in the effect, remove its listener callback from the `listeners` array in the `subStore`.
9. `<TodoList>` calls the effect and run `subStore.notifyUpdates()` after the render, since we don't have any listeners in `subStore` left to call, the whole process completed successfully.

For cases where there are still some children left, each child will then call their listener callbacks. Because they will be called after the render, they will have the latest props passed from their parents available.

Interesting that we are running `mapStateToProps` potentially 2 times in the children component, one is inside the listener callback and the other is triggered by parent's re-rendering. The latter should happen before the former, but both the state and the props should be up-to-date and the same between each run. For further optimizing performance, we can memoize the `mapStateToProps` function so that it won't have to call itself twice in such cases.

Note that we don't even have to use `unstable_batchedUpdates` in the `notifyUpdates` function. The updates in the same hierarchy call are **split** into different `subStore`, the children component will only call the listener callback when the parent has finished re-rendered, so there's no need to batch them together.

This is the basic idea of how the nested subscriptions model is implemented both in `react-redux` v5 and v7 (of course lack of tons of optimizations). [The result is gaining significant performance boost when we can bail out updates early and don't have to invoke React whenever possible](https://github.com/reduxjs/react-redux/pull/416). Also, we can get rid of `unstable_batchedUpdates`, which is tricky to be included in `react-redux` (it's from `react-dom` but `react-redux` can be used in other renderers as well). It's a huge win!

## React Context

There is a more straightforward way to fix this, by using **React context**. We're already using it to pass down our `store` instance, why not make it react to state changes as well? `react-context` v6 takes this approach when the stable version of React context first came up. The approach seems much easier and since the state rendering propagation is handled by React, we get the top-down updates for free. No more `unstable_batchedUpdates`, no more nested subscriptions model. The event listeners count also decrease down to only a single one, we don't have to subscribe in each `connect` HOC anymore.

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

It all seems so perfect, the implementation looks straightforward, we can still do the same optimizations as in our first approach (`react-redux` v4), we don't have to deal with stale props and zombie children problem anymore. This is essentially how we normally do in userland and how some popular libraries like [`unstated-next`](https://github.com/jamiebuilds/unstated-next) do it for us. Still, it might be a perfect solution for multiple smaller stores, `Redux` has only one global store. The cost of performance is significant enough to force us to iterate from it again.

Remember why we iterate from the first approach to the nested subscriptions model? It's so that we can bail out updates early even before we call `setState` and re-render the component. In this approach, since we can only get the whole state in render phase, **it means that we have to always call `setState` first and re-render the component to get the latest state later**. Only until then we can call `mapStateToProps` to get our mapped state the component cares about. In fact, there are several [performance regression incidents](https://github.com/reduxjs/react-redux/issues/1164) when `react-redux` v6 first released. Additionally, [the React team even mentioned that they don't recommend to use React context for flux-like state propagation at the time](https://github.com/facebook/react/issues/14110#issuecomment-448074060).

## Hooks

React context isn't the newest member in the React family, we have hooks! `react-redux` v7 introduces the new hooks-based APIs which makes the code much simpler and easier to understand. The most important hook might be the `useSelector` hook.

But first, we're going to rewrite our Todo app to use the hooks. More specifically, the `<Todo>` and `<TodoList>` component.

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

We don't need those HOC containers anymore, with hooks, we can just call `useSelector` and `useDispatch` to get the selected state and the dispatch method. Note a slight difference between the plain old `mapStateToProps` and `useSelector` is that we're no longer getting **an object** of states and spread them to props, but just get the state itself. So instead of getting `{ content }`, we're just getting `content`. This changes the equality check in our `setState` a little bit.

The `useDispatch` hook implementation is also pretty straightforward.

```js
const useDispatch = () =>
  React.useContext(Content).dispatch;
```

We can create our `useSelector` hook pretty easily too.

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

However, it's not even close to being ready to use. Every time the state updated, we'll be re-rendering all of our **connected** components. It's even worse with hooks API because we don't have an intermediate container component that's usually cheaper to render to potentially bail out updates of the usually more expensive wrapped component. Different from the previous trade-offs, we kind of **have to** put `selector` in the listener callback to bail out updates early.

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

This version simply just break. We suffer from the **stale props and zombie children** problem again we mentioned throughout the whole post. As always, we'll go through each step to see where and why it went wrong.

1. After the first render, Both `<TodoList>` and `<Todo>` subscribe to the store in `useEffect`. Since `useEffect` fires from bottom to top, `<Todo>` subscribes first, then `<TodoList>`.
2. The user clicks `<Todo>`, dispatches a `DELETE` action to store, expects the item to be deleted.
3. The store receives the action, run it through the **reducer**, and change the `todos` state to an empty array `{ todos: [] }`.
4. The store then calls the subscribed listeners. Since `<Todo>` subscribes first, it will also call the listener first.
5. **Since we are passing `props` to `listener` in render phase, it forms a closure with the `props` at that time. They're the **stale props**.** Accessing `state.todos[ownProps.id]` will results in `undefined` and calling `(undefined).content` will results in an error 💥.

Recall what we know about the stale props problem so far. **Stale props will happen in a synchronous subscription model when children are using props derived from the store.** There are 2 solutions so far.

1. Move `selector` to the render phase and use `unstable_batchedUpdates`
2. Use the nested subscriptions model

Hooks cannot change the render tree, so we cannot add a new `<Provider>` for every component to make them propagate to the nearest parent's sub-store. We can quickly cross out the second solution.

For the first solution, due to its bad performance when we only use `selector` in the render phase causing re-render for every change, we have to bail out updates early in the listener callback. Then again, stale props would potentially cause the `selector` to throw errors if we call it in the listener callback.

Our hands are tied, there's no solution yet to be known, we have to make some compromises.

What if we ignore the error? We first have to ask ourselves the question: when will the error occur? There are roughly 2 cases. Either the error occurs as expected as a bug in the selector itself, or it's because of the zombie children problem causing an unexpected error. Either way, we want to safely handle them by re-rendering the component and apply `selector(store.getState())` in the render phase to get the latest state. The former case will then **re-throw** the error in the render phase, and the latter will not produce any errors.

What about the kind of stale props problem which doesn't throw errors? The cases which we could still get the inconsistent state but there are no errors. In such cases, the component will still get re-rendered afterward anyway, since we will still be getting `selector(store.getState())` in the render phase, the issue will go away because of the first solution we mentioned above.

Looks like we can safely ignore the error in the 5th step, and re-try it in the render phase instead.

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

Together with the `unstable_batchedUpdates` trick, we can then both bail out updates early if the selected state doesn't change and also prevent stale props and zombie children problem safely. We run the code again and check that everything operates normally in order. The first 4 steps are the same, so we begin with the 5th.

5. Since we are passing `props` to `listener` in render phase, it forms a closure with the `props` at that time, in other words, it's the **stale props**. Accessing `state.todos[ownProps.id]` will results in `undefined` and calling `(undefined).content` will results in an error. **We catch and swallow the error intentionally, this is when we know that we want to select the state in the render phase instead, thus triggering a re-render.**
6. Since we're using `unstable_batchedUpdates`, the render is batched. `<TodoList>` fires its listener callback, `selector(store.getState())` results in `[]`, also schedule a re-render.
7. The render operates from top-down, `<TodoList>` renders first, calls `selector(store.getState())` again, and returns an empty `<ul>`, done rendering.

In this approach, we assume that the `selector` function provided by the user has to follow 2 rules.

1. The `selector` has no side-effects.
2. The code doesn't rely on or expect `selector` throwing errors.

In short, the `selector` must be a **pure function**. We could potentially be running the `selector` multiple times during updates. As long as the `selector` is pure, then running them multiple times shouldn't be an issue. Furthermore, `React.StrictMode` has kind of already enforced the rules for rendering for quite some time, it should be a better practice to do so in `selector` too.

We can also decide to deal with the problem ourselves as the users. Carefully guard the `selector` function and gracefully handle the errors is a bit much, but is still a good solution.

We can do many more optimizations to enhance the performance, like only forcing it to call the `selector` in render phase when it needs to (when it has stale props or the selector has changed). However, it's the basic idea of how `useSelector` work under the hood and why we have to keep our selectors **pure**.

## Takeaways

Phew! It's a long journey. Give yourself a round of applause for making to the end. It's not easy to follow along!

As simple as it seems to re-create Redux, there are many gotchas have to be handled carefully. We didn't even bring up the numerous optimizations and error handlings in this post.

I hope you find this post helpful to better understand how Redux and `react-redux` work behind the scenes. Also kudos to all the maintainers and contributors for creating such a wonderful library and consistently working on improving it. Even though I agree you probably don't need Redux, it still provides a useful pattern for a medium-to-big team to collaborate smoothly together.

Next time, when you find someone is taking Redux for granted, just ask her/him how to solve the **stale props and zombie children** problem and show her/him this post 😉.

## References

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
