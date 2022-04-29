> * 原文地址：[How to Implement Memoization in React to Improve Performance](https://www.sitepoint.com/implement-memoization-in-react-to-improve-performance/)
> * 原文作者：[Nida Khan](https://www.sitepoint.com/author/nkhan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/implement-memoization-in-react-to-improve-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/implement-memoization-in-react-to-improve-performance.md)
> * 译者：[Zavier](https://github.com/zaviertang)
> * 校对者：[jjCatherine](https://github.com/xyj1020)、[finalwhy](https://github.com/finalwhy)

# 如何用 React 实现 Memoization 以提高性能

> **在本教程中，我们将学习如何在 React 中实现 Memoization。Memoization 通过缓存函数调用的结果并在再次需要时返回这些缓存的结果来提高性能。**

我们将介绍以下内容：

* React 是如何渲染视图的？
* 为什么需要 Memoization？
* 如何在函数组件和类组件中实现 Memoization？
* 注意事项

本文假设你对 React 中的类和函数组件有基本的了解。如果你想查阅这些主题，可以查看 React 官方文档 [components and props](https://reactjs.org/docs/components-and-props.html)。

![Memoization in React](https://uploads.sitepoint.com/wp-content/uploads/2021/11/1635996790memoization-in-react.jpg)

## React 是如何渲染视图的？

在讨论 React 中的 Memoization 细节之前，让我们先来看看 React 是如何使用虚拟 DOM 渲染 UI 的。

常规 DOM 基本上包含一组用树的形式保存的节点。DOM 中的每个节点代表一个 UI 元素。每当应用程序中出现状态变更时，该 UI 元素及其所有子元素的相应节点都会在 DOM 树中更新，然后会触发 UI 重绘。

在高效的 DOM 树算法的帮助下，更新节点的速度更快，但重绘的速度很慢，并且当该 DOM 具有大量 UI 元素时，可能会影响性能。因此，在 React 中引入了虚拟 DOM。

这是真实 DOM 的虚拟表示。现在，每当应用程序的状态有任何变化时，React 不会直接更新真正的 DOM，而是创建一个新的虚拟 DOM。然后 React 会将此新的虚拟 DOM 与之前创建的虚拟 DOM 进行比较，找到有差异的地方（译者注：也就是找到需要被更新节点），然后进行重绘。

根据这些差异，虚拟 DOM 能更高效地更新真正的 DOM。这样提高了性能，因为虚拟 DOM 不会简单地更新 UI 元素及其所有子元素，而是有效地仅更新实际 DOM 中必要且最小的更改。

## 为什么需要 Memoization？

在上一节中，我们看到了 React 如何使用虚拟 DOM 有效地执行 DOM 更新操作来提高性能。在本节中，我们将介绍一个例子，该例子解释了为了进一步提高性能而需要使用 Memoization。

我们将创建一个父类，包含一个按钮，用于递增名为 `count` 的变量。父组件还调用了子组件，并向其传递参数。我们还在 `render` 方法中添加了 `console.log()` 语句：

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

此示例的完整代码可在 [CodeSandbox](https://codesandbox.io/s/adoring-flower-c7zu0) 上查看。

我们将创建一个 `Child` 类，该类接受父组件传递的参数并将其显示在 UI 中：

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

每当我们点击父组件中的按钮时，`count` 值都会更改。由于 state 变化了，因此父组件的 `render` 方法被执行了。

传递给子组件的参数在每次父组件重新渲染时都没有改变，因此子组件不应重新渲染。然而，当我们运行上面的代码并继续递增 `count` 时，我们得到了以下输出：

```
Parent render
Child render
Parent render
Child render
Parent render
Child render
```

你可以在这个 [sandbox](https://j2x3z.csb.app/) 中体验上述示例，并查看控制台的输出结果。

从输出中，我们可以看到，当父组件重新渲染时，即使传递给子组件的参数保持不变，子组件也会重新渲染。这将导致子组件的虚拟 DOM 与以前的虚拟 DOM 执行差异检查。由于我们的子组件中没有变更且重新渲染时的所有 props 都没有变，所以真正的 DOM 不会被更新。

真正的 DOM 不会进行不必要地更新对性能确实是有好处，但是我们可以看到，即使子组件中没有实际更改，也会创建新的虚拟 DOM 并执行差异检查。对于小型 React 组件，这种性能消耗可以忽略不计，但对于大型组件，性能影响会很大。为了避免这种重新渲染和虚拟 DOM 的差异检查，我们使用 Memoization。

### React 中的 Memoization

在 React 应用的上下文中，Memoization 是一种手段，每当父组件重新渲染时，子组件仅在它所依赖的 props 发生变化时才会重新渲染。如果子组件所依赖的 props 中没有更改，则它不会执行 render 方法，并将返回缓存的结果。由于渲染方法未执行，因此不会有虚拟 DOM 创建和差异检查，从而实现性能的提升。

现在，让我们看看如何在类和函数组件中实现 Memoization，以避免这种不必要的重新渲染。

## 类组件实现 Memoization

为了在类组件中实现 Memoization，我们将使用 [React.PureComponent](https://reactjs.org/docs/react-api.html#reactpurecomponent)。`React.PureComponent` 实现了 [shouldComponentUpdate()](https://reactjs.org/docs/react-component.html#shouldcomponentupdate)，它对 `state` 和 `props` 进行了浅比较，并且仅在 props 或 state 发生更改时才重新渲染 React 组件。

将子组件更改为如下所示的代码：

```jsx
//Child.js
class Child extends React.PureComponent { // 这里我们把 React.Component 改成了 React.PureComponent
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

此示例的完整代码显示在这个 [sandbox](https://jwt2q.csb.app/) 中。

父组件保持不变。现在，当我们在父组件中增加 `count` 时，控制台中的输出如下所示：

```
Parent render
Child render
Parent render
Parent render
```

对于首次渲染，它同时调用父组件和子组件的 `render` 方法。

对于每次增加 `count` 后的重新渲染，仅调用父组件的 `render` 函数。子组件不会重新渲染。

## 函数组件实现 Memoization

为了在函数组件中实现 Memoization，我们将使用 [React.memo()](https://reactjs.org/docs/react-api.html#reactmemo)。`React.memo()` 是一个[高阶组件](https://www.sitepoint.com/react-higher-order-components/)（HOC），它执行与 `PureComponent` 类似的工作，来避免不必要的重新渲染。

以下是函数组件的代码：

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

export default React.memo(Child); // 这里我们给子组件添加 HOC 实现 Memoization
```

同时还将父组件转换为了函数组件，如下所示：

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

此示例的完整代码可以在这个 [sandbox](https://z42uj.csb.app/) 中看到。

现在，当我们递增父组件中的 `count` 时，以下内容将输出到控制台：

```
Parent render
Child render
Parent render
Parent render
Parent render
```

## React.memo() 存在的问题

在上面的示例中，我们看到，当我们对子组件使用 `React.memo()` HOC 时，子组件没有重新渲染，即使父组件重新渲染了。

但是，需要注意的一个小问题是，如果我们将函数作为参数传递给子组件，即使在使用 `React.memo()` 之后，子组件也会重新渲染。让我们看一个这样的例子。

我们将更改父组件，如下所示。在这里，我们添加了一个处理函数，并作为参数传递给子组件：

```jsx
//Parent.js
export default function Parent() {
  const [count, setCount] = useState(0);
  const handleClick = () => {
    setCount(count + 1);
  };

  const handler = () => {
    console.log("handler");    // 这里的 handler 函数将会被传递给子组件
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

子组件代码将保持原样。我们不会在子组件中使用父组件传递来的函数：

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

现在，当我们递增父组件中的 `count` 时，它会重新渲染并同时重新渲染子组件，即使传递的参数中没有更改。

那么，是什么原因导致子组件重新渲染的呢？答案是，每次父组件重新渲染时，都会创建一个新的 `handler` 函数并将其传递给子组件。现在，由于每次重新渲染时都会重新创建 `handle` 函数，因此子组件在对 props 进行浅比较时会发现 `handler` 引用已更改，并重新渲染子组件。

接下来，我们将介绍如何解决此问题。

## 通过 `useCallback()` 来避免更多的重复渲染

导致子组件重新渲染的主要问题是重新创建了 `handler` 函数，这更改了传递给子组件的引用。因此，我们需要有一种方法来避免这种重复创建。如果未重新创建 `handler` 函数，则对 `handler` 函数的引用不会更改，因此子组件不会重新渲染。

为了避免每次渲染父组件时都重新创建函数，我们将使用一个名为 [useCallback()](https://reactjs.org/docs/hooks-reference.html#usecallback) 的 React Hook。Hooks 是在 React 16 中引入的。要了解有关 Hooks 的更多信息，你可以查看 React 的官方 [hooks 文档](https://reactjs.org/docs/hooks-intro.html)，或者查看 `[React Hooks: How to Get Started & Build Your Own](https://www.sitepoint.com/react-hooks/)"。

`useCallback()` 钩子传入两个参数：回调函数和依赖项列表。

以下是 `useCallback()` 示例：

```jsx
const handleClick = useCallback(() => {
  //Do something
}, [x,y]);
```

在这里，`useCallback()` 被添加到 `handleClick()` 函数中。第二个参数 `[x, y]` 可以是空数组、单个依赖项或依赖项列表。每当第二个参数中提到的任何依赖项发生更改时，才会重新创建 `handleClick()` 函数。

如果 `useCallback()` 中提到的依赖项没有更改，则返回作为第一个参数提及的回调函数的 Memoization 版本。我们将更改父组件，以便对传递给子组件的处理程序使用 `useCallback()` 钩子：

```JSX
//Parent.js
export default function Parent() {
  const [count, setCount] = useState(0);
  const handleClick = () => {
    setCount(count + 1);
  };

  const handler = useCallback(() => { // 给 handler 函数使用 useCallback()
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

子组件代码将保持原样。

此示例的完整代码这个 [sandbox](https://r797x.csb.app/) 中。

当我们在上述代码的父组件中增加 `count` 时，我们可以看到以下输出：

```
Parent render
Child render
Parent render
Parent render
Parent render
```

由于我们对父组件中的 `handler` 使用了 `useCallback()` 钩子，因此每次父组件重新渲染时，都不会重新创建 `handler` 函数，并且会将 `handler` 的 Memoization 版本传递到子组件。子组件将进行浅比较，并注意到 `handler` 函数的引用没有更改，因此它不会调用 `render` 方法。

## 值得注意的事

Memoization 是一种很好的手段，可以避免在组件的 state 或 props 没有改变时对组件进行不必要的重新渲染，从而提高 React 应用的性能。你可能会考虑为所有组件添加 Memoization，但这并不一定是构建高性能 React 组件的方法。只有在组件出现以下情况时，才应使用 Memoization：

* 固定的输入有固定的输出时
* 具有较多 UI 元素，虚拟 DOM 检查将影响性能
* 多次传递相同的参数

## 总结

在本教程中，我们理解了：

* React 是如何渲染 UI 的
* 为什么需要 Memoization
* 如何在 React 中通过函数组件的 `React.memo()` 和类组件的 `React.PureComponent` 实现 Memoization
* 通过一个例子展示，即使在使用 `React.memo()` 之后，子组件也会重新渲染
* 如何使用 `useCallback()` 钩子来避免在函数作为 props 传递给子组件时产生重新渲染的问题

希望这篇 React Memoization 的介绍对你有帮助！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
