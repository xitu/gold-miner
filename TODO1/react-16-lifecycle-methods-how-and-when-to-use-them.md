> * 原文地址：[React 16 Lifecycle Methods: How and When to Use Them](https://blog.bitsrc.io/react-16-lifecycle-methods-how-and-when-to-use-them-f4ad31fb2282)
> * 原文作者：[Scott Domes](https://medium.com/@scottdomes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-16-lifecycle-methods-how-and-when-to-use-them.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-16-lifecycle-methods-how-and-when-to-use-them.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[hanxiaosss](https://github.com/hanxiaosss), [Zelda256](https://github.com/Zelda256)

# React 16 生命周期函数：如何以及何时使用它们

#### React 组件生命周期的修订版最新指南

![](https://cdn-images-1.medium.com/max/5000/1*bqLzlcQEU8e7yWQ3tKSaxQ.png)

自从我关于这个主题的[第一篇文章](https://engineering.musefind.com/react-lifecycle-methods-how-and-when-to-use-them-2111a1b692b1)以来，React 组件 API 发生了显著的变化。一些生命周期函数已被弃用，一些新的被引入。所以是时候进行更新了！

（看看我是如何抵制开 `shouldArticleUpdate` 的玩笑的？这些就是约束。）

由于这次生命周期 API 有点复杂，我将这些函数分为四个部分：挂载、更新、卸载和错误。

如果你对 React 还不太熟悉，[我的文章](https://medium.freecodecamp.org/everything-you-need-to-know-about-react-eaedf53238c4)在这提供了一个全面的介绍。

**提示**:

使用可复用的组件库更快地构建 React 应用程序。使用 **[Bit](https://github.com/teambit/bit)** 共享你的组件，并使用它们来构建新的应用程序。试试看。

![发现、尝试、使用集成 bit 的 React 组件](https://cdn-images-1.medium.com/max/2726/1*pqRT9FOXRyCYMWB3WSUEjg.png)

[**组件发现与协作 · Bit**](https://bit.dev/)

## 问题

我们这个教程的示例应用程序很简单：一个由块组成的网格，每个块都有一个随机尺寸，排列成一个砖石布局（就像 Pinterest）。

每隔几秒钟，页面底部会加载一堆新的需要进行排列的块。

你可以查看最终的[应用程序](https://happful-ptolemy-8b66a6.netlify.com/)及其[代码](https://github.com/scotthouse/react-lifecycle-example)。

这不是一个复杂的例子，但这里有一个问题：我们将使用 [bricks.js 库](http://callmecavs.com/bricks.js/)来对齐网格。

Brick.js 是一个很棒的工具，但它没有对与 React 集成进行优化。它更适合普通的 JavaScript 或 jQuery。

那我们为什么要用它？嗯，这是生命周期函数的一个常见用例：**将非 React 工具集成到 React 范例中**。

有时，实现功能最好的库不是最适配的库，生命周期函数有助于弥合这一差距。

---

## 在我们深入研究前的最后一点

如上所述，生命周期函数是最后的手段。

它们将被用于**特殊**情况，当处于其他回退时将无法工作，如重新排列组件或改变 state。

生命周期方法（`constructor` 除外）很难解释。它们会增加应用程序的复杂性。除非必须，否则不要使用它们。

不废话了，让我们来看看吧。

## 挂载

#### constructor

**如果**你的组件是类组件，第一个被调用的是组件构造函数。这不适用于函数组件。

你的构造函数可能如下所示：

```JavaScript
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: 0,
    };
  }
}
```

调用构造函数时传入组件的 props。** 你必须调用 `super` 并传入 props。**

然后，你可以初始化 state，设置默认值。你甚至可以根据 props 设置 state：

```JavaScript
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: props.initialCounterValue,
    };
  }
}
```

请注意，使用构造函数的方式是可选的，如果你的 Babel 设置支持[类字段](https://github.com/tc39/proposal-class-fields)，则可以这样初始化 state：

```JavaScript
class MyComponent extends Component {
  state = {
    counter: 0,
  };
}
```

**这种方法广受欢迎。** 你仍然可以根据 props 设置 state：

```JavaScript
class MyComponent extends Component {
  state = {
    counter: this.props.initialCounterValue,
  };
}
```

但是，如果需要使用 [ref](https://reactjs.org/docs/refs-and-the-dom.html)，你可能仍需要构造函数。以下是我们的网格应用程序中的示例：

```JavaScript
class Grid extends Component {
  constructor(props) {
    super(props);
    this.state = {
      blocks: [],
    };
    this.grid = React.createRef();
  }
```

我们需要构造函数调用 `createRef` 来创建对 grid 元素的引用，因此我们可以将它传递给 `bricks.js`。

你还可以使用构造函数进行函数绑定，这也是可选的。有关更多信息，请参阅[此处](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)：

[**React 绑定模式：处理 `this` 的 5 种方法**](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)

**constructor 的最常见用例：** 设置 state、创建引用和函数绑定。

#### getDerivedStateFromProps

挂载时，`getDerivedStateFromProps` 是渲染前调用的最后一个方法。你可以通过它根据初始的 props 设置 state。这是示例 `Grid` 组件的代码：

```JavaScript
static getDerivedStateFromProps(props, state) {
  return { blocks: createBlocks(props.numberOfBlocks) };
}
```

我们来看 `numberOfBlocks` prop，使用它来创建一组随机大小的块。然后我们返回想要的 state 对象。

以下是调用 `console.log(this.state)` 之后的内容：

```JavaScript
console.log(this.state);
// -> {blocks: Array(20)}
```

请注意，我们可以将此代码放在 `constructor` 中。`getDerivedStateFromProps` 的优点是它更直观 —— 它**只**用于设置 state，而构造函数有多种用途。`getDerivedStateFromProps` 在挂载和更新之前都会被调用，我们稍后会看到。

**getDerivedStateFromProps 的最常见用例（挂载期间）：**返回基于初始 props 的 state 对象。

#### render

渲染完成所有工作。它返回实际组件的 JSX。使用 React 时，大部分时间都将花费在这。

**render 的最常见用例：** 返回组件 JSX。

#### componentDidMount

在我们第一次渲染我们的组件之后，此方法被调用。

如果你需要加载数据，请在此处执行操作。不要尝试在 constructor、render 或是其他疯狂的地方加载数据。我会让 [Tyler McGinnis](https://twitter.com/tylermcginnis33) 解释原因：

> 你无法确保在组件挂载之前 AJAX 请求不会被解析。如果确实如此，那就意味着你要在未挂载的组件上尝试执行 setState，这不仅不起作用，而且 React 会给你报一大堆错误。在 componentDidMount 中执行 AJAX 请求将保证这的确有一个组件需要更新。

你可以在他的[回答](https://tylermcginnis.com/react-interview-questions/)里阅读更多。

`componentDidMount` 也是你可以做很多有趣事情的地方，那些在组件未加载时可没法做。以下是一些例子：

* 绘制刚刚渲染的 \<canvas> 元素
* 在元素集合中初始化[砖石](http://masonry.desandro.com/)网格布局（就是我们正在做的！）
* 添加事件监听器

基本上，在这里你可以做所有没有 DOM 你不能做的设置，并获取所有你需要的数据。

以下我们的示例：

```JavaScript
componentDidMount() {
    this.bricks = initializeGrid(this.grid.current);
    layoutInitialGrid(this.bricks)

    this.interval = setInterval(() => {
      this.addBlocks();
    }, 2000);
  }
```

我们使用 `bricks.js` 库（在 `initializeGrid` 函数中调用）创建并排列网格。

然后我们设置一个定时器，每两秒添加更多的块，模拟数据的加载。你可以设想这是一个 `loadRecommendations` 的调用或是现实世界中的某些东西。

**componentDidMount 的最常见用例：** 发送 AJAX 请求以加载组件的数据。

## 更新

#### getDerivedStateFromProps

是的，又是这个。现在，它更有用了。

如果你需要根据 prop 的改变更新 state，可以通过返回新 state 对象来执行此操作。

**同样，不推荐基于 props 更改 state。**这应该被视为最后的手段。问问自己 —— 我需要存储 state 吗？我不可以只从 props 本身获得正确的功能吗？

也就是说，存在一些边缘案例。以下是一些例子：

* 当源更改时重置视频或音频元素
* 使用服务器的更新刷新 UI 元素
* 当内容改变时关闭手风琴元素

即使有上述情况，通常也有更好的方法。但是，当最坏的情况发生时，`getDerivedStateFromProps` 会帮你挽救回来。

使用我们的示例应用程序，假设我们的 `Grid` 组件的 `numberOfBlocks` prop 增加了。但是我们已经“加载”了比新数量更多的块。使用相同的值没有意义。所以我们这样做：

```JavaScript
static getDerivedStateFromProps(props, state) {
  if (state.blocks.length > 0) {
    return {};
  }

  return { blocks: createBlocks(props.numberOfBlocks) };
}
```

如果我们当前 state 中的块数超过了新的 prop，我们根本不更新状态，返回一个空对象。

（关于 `static` 函数的最后一点，比如 `getDerivedStateFromProps`：你没有通过 `this` 访问组件的权限。例如，我们无法访问的网格的引用。）

**getDerivedStateFromProps 的最常见用例：** 当 props 本身不足时，根据情况更新 state。

#### shouldComponentUpdate

当我们有新的 props 时。典型的 React 法则是，当一个组件接收到新的 props 或者新的 state 时，它应该更新。

但我们的组件有点担忧，得先征得许可。

这是我们得到的 —— `shouldComponentUpdate` 函数，调用时以 `nextProps` 作为第一个参数，`nextState` 是第二个。

`shouldComponentUpdate`应该总是返回一个布尔值 —— 问题的答案，“我应该重新渲染吗？”是的，小组件，你应该。它返回的默认值始终是 true。

但如果你担心浪费渲染资源和其它无意义的事 —— `shouldComponentUpdate` 是一个提高性能的好地方。

我写了一篇关于用这种方式使用 `shouldComponentUpdate` 的文章 —— 请看：

[**如何对 React 组件进行基准测试：快速简要指南**](https://engineering.musefind.com/how-to-benchmark-react-components-the-quick-and-dirty-guide-f595baf1014c)

在文章中，我们谈论有一个包含许多部分的表格。问题是当表重新渲染时，每个部分也都会重新渲染，从而减慢了速度。

`shouldComponentUpdate` 让我们能够说：组件只在你关心的 props 改变时才更新。

但请牢记，如果你设置了并忘记了它会导致重大问题，因为你的 React 组件将无法正常更新。所以要谨慎使用。

在我们的网格应用程序中，我们之前已经确定了有时我们将忽略 `this.props.numberOfBlocks` 的新值。默认行为表示我们的组件仍然会重新渲染，因为它收到了新的 props。这太浪费了。

```JavaScript
shouldComponentUpdate(nextProps, nextState) {
  // Only update if bricks change
  return nextState.blocks.length > this.state.blocks.length;
}
```

现在我们可以说：**只有**当 state 中的块数改变时，组件才应该更新。

**shouldComponentUpdate 的最常见用例：** 精确控制组件的重新渲染。

#### render

和之前一样！

#### getSnapshotBeforeUpdate

这个函数是一个有趣的新增功能。

请注意，它是在 `render` 与更新组件被实际传播到 DOM 之间调用的。在你的组件中，它作为最后一次看到之前的 props 和 state 的机会存在。

为什么？好吧，在调用 `render` 和显示更改之间可能会有一段延迟。如果你需要在整合最新 `render` 调用的结果时知道 DOM 是什么**，这里就是你可以找到答案的地方。

这是一个例子。假设我们的团队负责人决定，如果用户在加载新块时位于网格底部，则应将其向下滚动到屏幕的**新**底部。

换句话说：当网格扩展时，如果它们位于底部，请让它们继续在底部。

```JavaScript
getSnapshotBeforeUpdate(prevProps, prevState) {
    if (prevState.blocks.length < this.state.blocks.length) {
      const grid = this.grid.current;
      const isAtBottomOfGrid =
        window.innerHeight + window.pageYOffset === grid.scrollHeight;

      return { isAtBottomOfGrid };
    }

    return null;
  }
```

这就是说：如果用户滚动到底部，则返回如下对象：`{isAtBottomOfGrid：true}`。如果没有，则返回 `null`。

**你应该返回 `null` 或从 `getSnapshotBeforeUpdate` 获取的值。**

为什么？我们马上就能看到。

**getSnapshotBeforeUpdate 的最常见用例：** 查看当前 DOM 的一些属性，并将值传给 `componentDidUpdate`。

#### componentDidUpdate

现在，我们的更改已经提交给 DOM。

在 `componentDidUpdate` 中，我们可以访问三个东西：之前的 props、之前的 state 以及我们从 `getSnapshotBeforeUpdate` 返回的任何值。

完成上面的例子：

```JavaScript
componentDidUpdate(prevProps, prevState, snapshot) {
  this.bricks.pack();

  if (snapshot.isAtBottomOfGrid) {
    window.scrollTo({
      top: this.grid.current.scrollHeight,
      behavior: 'smooth',
    });
  }
}
```

首先，我们使用 Bricks.js 的 `pack` 函数重新布局网格。

然后，如果我们的快照显示用户原先就位于网格的底部，我们将它们向下滚动到新块的底部。

**componentDidUpdate 的最常见用例：** 响应（哈哈！）DOM 的已提交更改。

## 卸载

#### componentWillUnmount

它快要结束了。

你的组件将会消失。也许是永远。这很令人悲伤。

在此之前，它会询问你是否有任何最后一刻前的请求。

你可以在此处取消任何向外的网络请求，或删除与该组件关联的所有事件监听器。

总的来说，清除所涉及的组件的每一件事 —— 当它消失时，它应该完全消失。

在我们的例子中，我们有一个在 `componentDidMount` 中调用的 `setInterval` 需要清理。

```JavaScript
componentWillUnmount() {
  clearInterval(this.interval);
}
```

**componentWillUnmount 的最常见用例：** 清理组件中所有的剩余碎片。

## 错误

#### getDerivedStateFromError

有些东西出问题咯。

不是在你的组件本身，而是在它的某个子孙组件。

我们想要将错误显示在屏幕上。最简单的方法是使用一个像 `this.state.hasError` 这样的值，此时该值将转换为 `true`。

```JavaScript
static getDerivedStateFromError(error) {
  return { hasError: true };
}
```

请注意，你必须返回更新的 state 对象。不要将此方法作用于任何其他操作。而是使用下面的 `componentDidCatch`。

**getDerivedStateFromError的最常见用例：** 更新 state 以显示错误在屏幕上。

#### componentDidCatch

与上面非常相似，因为它在子组件中发生错误时被触发。

区别在于不是为了响应错误而更新 state，我们现在可以执行任何其他操作，例如记录错误。

```JavaScript
componentDidCatch(error, info) {
  sendErrorLog(error, info);
}
```

`error` 是实际的错误消息（未定义的变量之类），`info` 是堆栈跟踪（`In Component, in div, etc`）。

**请注意，componentDidCatch 仅适用于渲染/生命周期函数中的错误。如果你的应用程序在点击事件中抛出错误，它不会被捕获。**

你通常只在特殊的**错误边界**组件中使用 `componentDidCatch`。这些组件封装子组件的唯一目的是捕获并记录错误。

例如，此错误边界将捕获错误并呈现“Oops！”消息而不是子组件：

```JavaScript
class ErrorBoundary extends Component {
  state = { errorMessage: null };

  static getDerivedStateFromError(error) {
    return { errorMessage: error.message };
  }

  componentDidCatch(error, info) {
    console.log(error, info);
  }

  render() {
    if (this.state.errorMessage) {
      return <h1>Oops! {this.state.errorMessage}</h1>;
    }

    return this.props.children;
  }
}
```

**componentDidCatch 的最常见用例：** 捕获并记录错误。

## 结论

就是这样！这些都是生命周期函数，任你使用。

你可以查看示例程序的[代码](https://github.com/scottdomes/react-lifecycle-example)和[最终产品](https://blissful-ptolemy-8b66a6.netlify.com/)。

感谢阅读！请随意在下面发表评论并提出任何问题，欢迎交流！

---

## 延伸阅读

* [**5 个加快 React 开发的工具**](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
* [**了解 React 渲染 props 和高阶组件**](https://blog.bitsrc.io/understanding-react-render-props-and-hoc-b37a9576e196)
* [**在 2019 年你应该知道的 11 个 React UI 组件库**](https://blog.bitsrc.io/11-react-component-libraries-you-should-know-178eb1dd6aa4)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
