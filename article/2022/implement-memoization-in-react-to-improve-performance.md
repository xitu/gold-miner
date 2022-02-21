> * 原文地址：[How to Implement Memoization in React to Improve Performance](https://www.sitepoint.com/implement-memoization-in-react-to-improve-performance/)
> * 原文作者：[Nida Khan](https://www.sitepoint.com/author/nkhan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/implement-memoization-in-react-to-improve-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/implement-memoization-in-react-to-improve-performance.md)
> * 译者：
> * 校对者：

# How to Implement Memoization in React to Improve Performance

> **In this tutorial, we’ll learn how to implement memoization in React. Memoization improves performance by storing the results of expensive function calls and returning those cached results when they’re needed again.**

We’ll cover the following:

* how React renders the UI
* why there’s a need for React memoization
* how we can implement memoization for functional and class components
* things to keep in mind regarding memoization

This article assumes you have a basic understanding of class and functional components in React. If you’d like to brush up on those topics, check out the official React docs on [components and props](https://reactjs.org/docs/components-and-props.html).

![Memoization in React](https://uploads.sitepoint.com/wp-content/uploads/2021/11/1635996790memoization-in-react.jpg)

## How React Renders the UI

Before going into the details of memoization in React, let’s first have a look at how React renders the UI using a virtual DOM.

The regular DOM basically contains a set of nodes represented as a tree. Each node in the DOM is a representation of a UI element. Whenever there’s a state change in your application, the respective node for that UI element and all its children get updated in the DOM and then the UI is re-painted to reflect the updated changes.

Updating the nodes is faster with the help of efficient tree algorithms, but the re-painting is slow and can have a performance impact when that DOM has a large number of UI elements. Therefore, the virtual DOM was introduced in React.

This is a virtual representation of the real DOM. Now, whenever there’s any change in the application’s state, instead of directly updating the real DOM, React creates a new virtual DOM. React then compares this new virtual DOM with the previously created virtual DOM to find the differences that need to be repainted.

Using these differences, the virtual DOM will update the real DOM efficiently with the changes. This improves performance, because instead of simply updating the UI element and all its children, the virtual DOM will efficiently update only the necessary and minimal changes in the real DOM.

## Why We Need Memoization in React

In the previous section, we saw how React efficiently performs DOM updates using a virtual DOM to improve performance. In this section, we’ll look at a use case that explains the need for memoization for further performance boost.

We’ll create a parent class that contains a button to increment a state variable called `count`. The parent component also has a call to a child component, passing a prop to it. We’ve also added `console.log()` statements in render the method of both the classes:

```jsx
//Parent.js
class Parent extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  handleClick = () => {
    this.setState((prevState) => {
      return { count: prevState.count + 1 };
    });
  };

  render() {
    console.log("Parent render");
    return (
      <div className="App">
        <button onClick={this.handleClick}>Increment</button>
        <h2>{this.state.count}</h2>
        <Child name={"joe"} />
      </div>
    );
  }
}

export default Parent;
```

The complete code for this example is available on [CodeSandbox](https://codesandbox.io/s/adoring-flower-c7zu0).

We’ll create a `Child` class that accepts a prop passed by the parent component and displays it in the UI:

```jsx
//Child.js
class Child extends React.Component {
  render() {
    console.log("Child render");
    return (
      <div>
        <h2>{this.props.name}</h2>
      </div>
    );
  }
}

export default Child;
```

Whenever we click the button in the parent component, the count value changes. Since this is a state change, the parent component’s render method is called.

The props passed to the child class remain the same for every parent re-render, so the child component should not re-render. Yet, when we run the above code and keep incrementing the count, we get the following output:

```
Parent render
Child render
Parent render
Child render
Parent render
Child render
```

You can increment the count for the above example yourself in the following [this sandbox](https://j2x3z.csb.app/) and see the console for the output.

From this output, we can see that, when the parent component re-renders, it will also re-render the child component — even when the props passed to the child component are unchanged. This will cause the child’s virtual DOM to perform a difference check with the previous virtual DOM. Since we have no difference in the child component — as the props are the same for all re-renders — the real DOM isn’t updated.

We do have a performance benefit where the real DOM is not updated unnecessarily, but we can see here that, even when there was no actual change in the child component, the new virtual DOM was created and a difference check was performed. For small React components, this performance is negligible, but for large components, the performance impact is significant. To avoid this re-render and virtual DOM check, we use memoization.

### Memoization in React

In the context of a React app, memoization is a technique where, whenever the parent component re-renders, the child component re-renders only if there’s a change in the props. If there’s no change in the props, it won’t execute the render method and will return the cached result. Since the render method isn’t executed, there won’t be a virtual DOM creation and difference checks — thus giving us a performance boost.

Now, let’s see how to implement memoization in class and functional React components to avoid this unnecessary re-render.

## Implementing Memoization in a Class Component

To implement memoization in a class component, we’ll use [React.PureComponent](https://reactjs.org/docs/react-api.html#reactpurecomponent). `React.PureComponent` implements [shouldComponentUpdate()](https://reactjs.org/docs/react-component.html#shouldcomponentupdate), which does a shallow comparison on state and props and renders the React component only if there’s a change in the props or state.

Change the child component to the code shown below:

```jsx
//Child.js
class Child extends React.PureComponent { // Here we change React.Component to React.PureComponent
  render() {
    console.log("Child render");
    return (
      <div>
        <h2>{this.props.name}</h2>
      </div>
    );
  }
}

export default Child;
```

The complete code for this example is shown in [this sandbox](https://jwt2q.csb.app/).

The parent component remains unchanged. Now, when we increment the count in parent component, the output in the console is as follows:

```
Parent render
Child render
Parent render
Parent render
```

For the first render, it calls both parent and child component’s render method.

For subsequent re-render on every increment, only the parent component’s `render` function is called. The child component isn’t re-rendered.

## Implementing Memoization in a Functional Component

To implement memoization in functional React components, we’ll use [React.memo()](https://reactjs.org/docs/react-api.html#reactmemo).`React.memo()` is a [higher order component](https://www.sitepoint.com/react-higher-order-components/) (HOC) that does a similar job to `PureComponent`, avoiding unnecessary re-renders.

Below is the code for a functional component:

```jsx
//Child.js
export function Child(props) {
  console.log("Child render");
  return (
    <div>
      <h2>{props.name}</h2>
    </div>
  );
}

export default React.memo(Child); // Here we add HOC to the child component for memoization
```

We also convert the parent component to a functional component, as shown below:

```jsx
//Parent.js
export default function Parent() {
  const [count, setCount] = useState(0);
  const handleClick = () => {
    setCount(count + 1);
  };
  console.log("Parent render");
  return (
    <div>
      <button onClick={handleClick}>Increment</button>
      <h2>{count}</h2>
      <Child name={"joe"} />
    </div>
  );
}
```

The complete code for this example can be seen in [this sandbox](https://z42uj.csb.app/).

Now, when we increment the count in the parent component, the following is output to the console:

```
Parent render
Child render
Parent render
Parent render
Parent render
```

## The Problem with React.memo() for Function Props

In the above example, we saw that when we used the `React.memo()` HOC for the child component, the child component didn’t re-render, even if the parent component did.

A small caveat to be aware of, however, is that if we pass a function as prop to child component, even after using `React.memo()`, the child component will re-render. Let’s see an example of this.

We’ll change the parent component as shown below. Here, we’ve added a handler function that we’ll pass to the child component as props:

```jsx
//Parent.js
export default function Parent() {
  const [count, setCount] = useState(0);
  const handleClick = () => {
    setCount(count + 1);
  };

  const handler = () => {
    console.log("handler");    // This is the new handler that will be passed to the child
  };

  console.log("Parent render");
  return (
    <div className="App">
      <button onClick={handleClick}>Increment</button>
      <h2>{count}</h2>
      <Child name={"joe"} childFunc={handler} />
    </div>
  );
}
```

The child component code remains as it is. We don’t use the function we’ve passed as props in the child component:

```jsx
//Child.js
export function Child(props) {
  console.log("Child render");
  return (
    <div>
      <h2>{props.name}</h2>
    </div>
  );
}

export default React.memo(Child);
```

Now, when we increment the count in parent component, it re-renders and also re-renders the child component, even though there’s no change in the props passed.

So, what caused the child to re-render? The answer is that, every time the parent component re-renders, a new handler function is created and passed to the child. Now, since the handler function is recreated on every re-render, the child, on a shallow comparison of props, finds that the handler reference has changed and re-renders the child component.

In the next section, we’ll see how to fix this issue.

## `useCallback()` to Avoid Further Re-rendering

The main issue that caused the child to re-render is the recreation of the handler function, which changed the reference passed to the child. So, we need to have a way to avoid this recreation. If the handler isn’t recreated, the reference to the handler won’t change — so the child won’t re-render.

To avoid recreating the function every time when the parent component is rendered, we’ll use a React hook called [useCallback()](https://reactjs.org/docs/hooks-reference.html#usecallback). Hooks were introduced in React 16. To learn more about hooks, you can have a look at the React’s official [hooks documentation](https://reactjs.org/docs/hooks-intro.html), or check out “[React Hooks: How to Get Started & Build Your Own](https://www.sitepoint.com/react-hooks/)”.

The `useCallback()` hook takes two arguments: the callback function, and a list of dependencies.

Consider the following example of `useCallback(`):

```jsx
const handleClick = useCallback(() => {
  //Do something
}, [x,y]);
```

Here, `useCallback()` is added to the `handleClick()` function. The second argument `[x,y]` could be an empty array, a single dependency, or a list of dependencies. Whenever any dependency mentioned in the second argument changes, only then will the `handleClick()` function be recreated.

If the dependencies mentioned in `useCallback()` don’t change, a memoized version of the callback that’s mentioned as the first argument is returned. We’ll change our parent functional component to use the `useCallback()` hook for the handler that’s passed to the child component:

```JSX
//Parent.js
export default function Parent() {
  const [count, setCount] = useState(0);
  const handleClick = () => {
    setCount(count + 1);
  };

  const handler = useCallback(() => { //using useCallback() for the handler function
    console.log("handler");
  }, []);

  console.log("Parent render");
  return (
    <div className="App">
      <button onClick={handleClick}>Increment</button>
      <h2>{count}</h2>
      <Child name={"joe"} childFunc={handler} />
    </div>
  );
}
```

The child component code remains as it is.

The complete code for this example is shown in [this sandbox](https://r797x.csb.app/).

When we increment the count in the parent component for the code above, we can see the following output:

```
Parent render
Child render
Parent render
Parent render
Parent render
```

Since we used the `useCallback()` hook for the parent handler, every time the parent re-renders, the handler function won’t be recreated, and a memoized version of the handler is sent down to the child. The child component will do a shallow comparison and notice that handler function’s reference hasn’t changed — so it won’t call the `render` method.

## Things to Remember

Memoization is a good technique for improving performance in React apps by avoiding unnecessary re-renders of a component if its props or state haven’t changed. You might think of just adding memoization for all the components, but that’s not a good way to build your React components. You should use memoization only in cases where the component:

* returns the same output when given the same props
* has multiple UI elements and a virtual DOM check will impact performance
* is often provided the same props

## Conclusion

In this tutorial, we’ve seen:

* how React renders the UI
* why memoization is needed
* how to implement memoization in React through `React.memo()` for a functional React component and `React.PureComponent` for a class component
* a use case where, even after using `React.memo()`, the child component will re-render
* how to use the `useCallback()` hook to avoid re-rendering when a function is passed as props to a child component.

I hope you’ve found this introduction to React memoization useful!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
