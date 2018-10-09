> * 原文地址：[Immutable Data with Immer and React setState](https://codeburst.io/immutable-data-with-immer-and-react-setstate-887e8f3ad667)
> * 原文作者：[Jason Brown](https://codeburst.io/@browniefed?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/immutable-data-with-immer-and-react-setstate.md](https://github.com/xitu/gold-miner/blob/master/TODO1/immutable-data-with-immer-and-react-setstate.md)
> * 译者：[HaoChuan9421](https://github.com/HaoChuan9421)
> * 校对者：

# Immer 下的不可突变数据和 React 的 setState

[Immer](https://github.com/mweststrate/immer) 是为 JavaScript 不可突变性打造的一个非常棒的全新库。之前像 [Immutable.js](https://github.com/facebook/immutable-js) 这样的库，它需要引入操作你数据的所有新方法。

它很不错，但是需要复杂的适配器并在 JSON 和 _不可突变_ 之间来回转换，以便在需要时与其他库一起使用。

Immer 简化了这一点，你可以像往常一样使用数据和 JavaScript 对象。这意味着当你需要考虑性能并且想知道数据何时发生了变更，你可以使用三个等号来做严格的全等检查以及证明数据的确发生了变更。

你对 `shouldComponentUpdate` 的调用不再需要使用双等或者全等去遍历整个数据并进行比较。

### 文章截图

![](https://s1.ax2x.com/2018/09/28/5HELrX.png)

注：此处为截图，原文为视频，建议看英文原文。

### 对象展开运算符

在最新版本的 JavaScript 中，许多开发者依赖对象展开运算符来实现不可突变性。例如，你可以展开之前的对象并覆盖特定的属性，或者增加新的属性。它会在底层使用 `Object.assign` 并返回一个新对象。

```

const prevObject = {
  id: "12345",
  name: "Jason",
};

const newObject = {
  ...prevObject,
  name: "Jason Brown",
};
```

我们的 `newObject` 现在会是一个完全不同的对象，所以任何全等判断（`prevObject === newObject`）将会返回 false。所以它完全创建了一个新对象。name 属性也不再是 `Jason` 而是会变成 `Jason Brown`，而且由于我们没有对 `id` 属性进行任何操作，所以它会保持不变。

这也适用于 React，如果你在 `state` 中有嵌套的对象，你需要对之前的对象进行展开操作和更新，因为 React 只会合并最外层的属性。

让我们看一个例子。可以看到我们有两个嵌套的计数器，但是我们只想更新其中的一个而不影响另一个。

```
import React, { Component } from "react";

class App extends Component {
  state = {
    count: {
      counter: 0,
      otherCounter: 5,
    },
  };

  render() {
    return <div className="App">{this.state.count.counter}</div>;
  }
}

export default App;
```

下一步在 `componentDidMount` 钩子中，我们将设置一个间隔定时器来更新我们嵌套的计数器。不过，我们希望保持 `otherCounter` 的值不变。所以，我们需要使用对象展开运算符来把它从以前嵌套的 state 中带过来。

```
componentDidMount() {
    setInterval(() => {
      this.setState(state => {
        return {
          count: {
            ...state.count,
            counter: state.count.counter + 1,
          },
        };
      });
    }, 1000);
  }
```

这在 React 中是一个非常常见的场景。而且，如果你的数据是嵌套的非常深的，当你需要展开多个层级时，它会增加复杂性。

### Immer Produce 基础

Immer 仍然允许使用突变（直接改变值）而完全无需担心如何去管理展开的层级，或者哪些数据我们触及过以及需要维持不可突变性。

让我们设置一个场景：你向计数器传递一个值来进行递增，与此同时，我们还有一个 user 对象是不需要被触及的。

这里我们渲染我们的应用并传递增量值。

```
ReactDOM.render(<App increaseCount={5} />, document.getElementById("root"));
```

```
import React, { Component } from "react";

class App extends Component {
  state = {
    count: {
      counter: 0,
    },
    user: {
      name: "Jason Brown",
    },
  };

  componentDidMount() {
    setInterval(() => {}, 1000);
  }

  render() {
    return <div className="App">{this.state.count.counter}</div>;
  }
}

export default App;
```

我们像之前那样设置了我们的应用，现在我们有一个 user 对象和一个嵌套的计数器。

我们将导入 `immer` 并把它的默认值赋给  `produce` 变量。在给定当前 state 时，它将帮助我们创建下一个 state。

```
import produce from "immer";
```
接下来，我们将创建一个叫做 `counter` 的函数，它接收 state 和 props 作为参数，这样我们就可以读取当前的计数，并基于 `increaseCount` 属性更新我们的下一次计数。

```
const counter = (state, props) => {};
```

Immer 的 produce 方法接收 `state` 作为第一个参数，以及一个为下一个状态改变数据的函数作为第二个参数。

```
produce(state, draft => {
  draft.count.counter += props.increaseCount;
});
```

如果你现在把他们放在一起。我们就可以创建计数器函数，它接收 state 和 props 并调用 produce 函数。然后我们按照对下一次状态期望的样子去改变 `draft`。Immer 的 produce 函数将为我们创建一个新的不可突变状态。

```
const counter = (state, props) => {
  return produce(state, draft => {
    draft.count.counter += props.increaseCount;
  });
};
```

我们更新后的间隔计数器函数大概会是这样。

```
componentDidMount() {
    setInterval(() => {
      const nextState = counter(this.state, this.props);
      this.setState(nextState);
    }, 1000);
  }
```

不过我们只是触及过 `count` 和 `counter`，我们的 `user` 对象上又发生了什么呢？对象的引用是否也发生了变化？答案是否定的。Immer 确切的知道哪些数据是被触及过的。所以，如果我们在组件更新之后进行一次全等检测，我们可以看到 state 中之前的 user 对象和之后的 user 对象是完全相同的。

```
componentDidUpdate(prevProps, prevState) {
    console.log(this.state.user === prevState.user); // Logs true
  }
```

当你考虑性能而使用 `shouldComponentUpdate` 时，或者类似于 React Native 中`FlatList` 那样，需要一种简单的方式来知道某一行是否已经更新时，这就非常的重要。

### Immer 柯里化

Immer 可以使得操作更加简单。如果它发现你传递的第一个参数是一个函数而不是一个对象，它就会为你创建一个柯里化的函数。因此，`produce` 函数返回另一个函数而不是一个新对象。

当它被调用时，它会把第一个参数用作你希望改变的 `state`，然后还会传递任何其他参数。

因此，它不仅仅是可以创建一个计数器函数的（工厂）函数，就连 `props` 也会被代理。

```
const counter = produce((draft, props) => {
  draft.count.counter += props.increaseCount;
});
```

得益于 `produce` 返回一个函数，我们可以直接把它传递给 `setState`，因为 `setState` 有接收函数作为参数的能力。当你正在引用之前的状态时，你应该使用函数化的 `setState`（函数作为第一个参数）。在我们的场景中，我们需要引用之前的计数来把它增加到新的计数。它将传递当前的 state 和 props 作为参数，这也正是设置我们的 `counter` 函数所需要的。

所以我们的间隔计数器仅需要 `this.setState` 接收 `counter` 函数即可。

```
componentDidMount() {
    setInterval(() => {
      this.setState(counter);
    }, 1000);
  }
```

### 总结

![](https://cdn-images-1.medium.com/max/800/1*zcy1pxsvHOm2bqjkPCaMVw.png)

这显然是一个人为的示例，但具有广泛的现实应用。可以轻松比较仅更新了单个字段的一长串列表数据。大型嵌套表单只需要更新触及过的特定部分。

你不再需要做浅比对或者深比对，而且你现在可以做全等检查来准确的知道你的数据是否发生了变化，而后决定是否需要重新渲染。

* * *

_Originally published at_ [_Code_](https://codedaily.io/tutorials/58/Immutable-Data-with-Immer-and-React-setState).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
