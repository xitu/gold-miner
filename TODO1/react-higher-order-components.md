> * 原文地址：[React Higher-Order Components](https://tylermcginnis.com/react-higher-order-components/)
> * 原文作者：[Tyler McGinnis](https://twitter.com/tylermcginnis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-higher-order-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-higher-order-components.md)
> * 译者：[CoderMing](https://github.com/coderming)
> * 校对者：[giddens9527](https://github.com/giddens9527)、[icy](https://github.com/Raoul1996)

# 深入理解 React 高阶组件

![](https://tylermcginnis.com/static/higherOrderComponents-5d56d61ada5a155f12e10d5a4abb0936-b64db.png)

> 在这篇文章的开始之前，我们有两点需要注意：首先，我们所讨论的仅仅是一种设计模式。它甚至就像组件结构一样不是 React 里的东西。第二，它不是构建一个 React 应用所必须的知识。你可以关掉这篇文章、不学习在这篇文章中我们所讨论的内容，之后仍然可以构建一个正常的 React 应用。不过，就像构建所有东西一样，你有更多可用的工具就会得到更好的结果。如果你在写 React 应用，在你的“工具箱”之中没有这个（React 高阶组件）的话会对你是非常不利的。

在你听到 `Don't Repeat Yourself`或者 D.R.Y 这样（中邪一样）的口号之前你是不会在软件开发的钻研之路上走得很远的。有时候实行这些名言会有点过于麻烦，但是在大多数情况下，（实行它）是一个有价值的目标。在这篇文章中我们将会去探讨在 React 库中实现 DRY 的最著名的模式——高阶组件。不过在我们探索答案之前，我们首先必须要完全明确问题来源。

假设我们要负责重新创建一个类似于 Sprite（译者注：国外的一个在线支付公司）的仪表盘。正如大多数项目那样，一切事务在最后收尾之前都工作得很正常。你发现在仪表盘上有一串不一样的提示框需要你某些元素 hover 的时候显示。 => 你在仪表盘上面发现了一些不同的、（当鼠标）悬停在某些组成元素上面会出现的提示信息。

![GIF of Stripe's dashboard with lots of tooltips](https://tylermcginnis.com/images/posts/react-fundamentals/tool-tips.gif)

这里有好几种方式可以实现这个效果。其中一个你可能想到的是监听特定的组件的 hover 状态来决定是否展示 tooltip。在上图中，你有三个组件需要添加它们的监听功能—— `Info`、`TrendChart` 和 `DailyChart`。

让我们从 `Info` 组件开始。现在它只是一个简单的 SVG 图标。

```
class Info extends React.Component {
  render() {
    return (
      <svg
        className="Icon-svg Icon--hoverable-svg"
        height={this.props.height}
        viewBox="0 0 16 16" width="16">
          <path d="M9 8a1 1 0 0 0-1-1H5.5a1 1 0 1 0 0 2H7v4a1 1 0 0 0 2 0zM4 0h8a4 4 0 0 1 4 4v8a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4zm4 5.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z" />
      </svg>
    )
  }
}
```

现在我们需要添加让它可以监测到自身是否被（鼠标）悬停的功能。我们可以使用 React 所附带的 `onMouseOver` 和 `onMouseOut` 这两个鼠标时间。我们传递给 `onMouseOver` 的函数将会在组件被鼠标悬停后触发，同时我们传递给 `onMouseOut` 的函数将会在组件不再被鼠标悬停时触发。要以 React 的方式来操作，我们会给给我们的组件添加一个 `hovering` state 属性，所以我们可以在 `hovering` state 属性改变的时候触发重绘，来展示或者隐藏我们的提示框。

```
class Info extends React.Component {
  state = { hovering: false }
  mouseOver = () => this.setState({ hovering: true })
  mouseOut = () => this.setState({ hovering: false })
  render() {
    return (
      <>
        {this.state.hovering === true
          ? <Tooltip id={this.props.id} />
          : null}
        <svg
          onMouseOver={this.mouseOver}
          onMouseOut={this.mouseOut}
          className="Icon-svg Icon--hoverable-svg"
          height={this.props.height}
          viewBox="0 0 16 16" width="16">
            <path d="M9 8a1 1 0 0 0-1-1H5.5a1 1 0 1 0 0 2H7v4a1 1 0 0 0 2 0zM4 0h8a4 4 0 0 1 4 4v8a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4zm4 5.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z" />
        </svg>
      </>
    )
  }
}
```

上面的代码看起来很棒。现在我们要添加同样的功能给我们的其他两个组件——`TrendChart` 和 `DailyChart`。如果这两个组件没有出问题，就请不要修复它。我们对于 `Info` 的悬停功能运行的很好，所以请再写一遍之前的代码。

```
class TrendChart extends React.Component {
  state = { hovering: false }
  mouseOver = () => this.setState({ hovering: true })
  mouseOut = () => this.setState({ hovering: false })
  render() {
    return (
      <>
        {this.state.hovering === true
          ? <Tooltip id={this.props.id}/>
          : null}
        <Chart
          type='trend'
          onMouseOver={this.mouseOver}
          onMouseOut={this.mouseOut}
        />
      </>
    )
  }
}
```

你或许知道下一步了：我们要对最后一个组件 `DailyChart` 做同样的事情。

```
class DailyChart extends React.Component {
  state = { hovering: false }
  mouseOver = () => this.setState({ hovering: true })
  mouseOut = () => this.setState({ hovering: false })
  render() {
    return (
      <>
        {this.state.hovering === true
          ? <Tooltip id={this.props.id}/>
          : null}
        <Chart
          type='daily'
          onMouseOver={this.mouseOver}
          onMouseOut={this.mouseOut}
        />
      </>
    )
  }
}
```

这样的话，我们就全部做完了。你可能以前曾经这样写过 React 代码。但这并不该是你最终所该做的（不过这样做也还凑合），但是它很不 “DRY”。正如我们所看到的，我们在我们的每一个组件中都 重复着完全一样的的鼠标悬停逻辑。

从这点看的话，**问题**变得非常清晰了：**我们希望避免在在每个需要添加鼠标悬停逻辑的组件是都再写一遍相同的逻辑**。所以，**解决办法**是什么？在我们开始前，让我们先讨论一些能让我们更容易理解答案的编程思想—— `回调函数` 和 `高阶函数`。

在 JavaScript 中，函数是 “一等公民”。这意味着它就像对象/数组/字符串那样可以被声明为一个变量、当作函数的参数或者在函数中返回一个函数，即使返回的是其他函数也可以。

```
function add (x, y) {
  return x + y
}

function addFive (x, addReference) {
  return addReference(x, 5)
}

addFive(10, add) // 15
```

如果你没这样用过，你可能会感到困惑。我们将 `add` 函数作为一个参数传入 `addFive` 函数，重新命名为 `addReference`，然后我们调用了着个函数。

这时候，你作为参数所传递进去的函数被叫做**回调**函数同时你使用回调函数所构建的新函数被叫做**高阶函数**。

因为这些名词很重要，下面是一份根据它们所表示的含义重新命名变量后的同样逻辑的代码。

```
function add (x,y) {
  return x + y
}

function higherOrderFunction (x, callback) {
  return callback(x, 5)
}

higherOrderFunction(10, add)
```

这个模式很常见，哪里都有它。如果你之前用过任何 JavaScript 数组方法、jQuery 或者是 lodash 这类的库，你就已经用过高阶函数和回调函数了。

```
[1,2,3].map((i) => i + 5)

_.filter([1,2,3,4], (n) => n % 2 === 0 );

$('#btn').on('click', () =>
  console.log('回调函数哪里都有')
)
```

让我们回到我们之前的例子。如果我们不仅仅想创建一个 `addFive` 函数，我们也想创建 `addTen`函数、 `addTwenty` 函数等等，我们该怎么办？在我们当前的实践方法中，我们必须在需要的时候去重复地写我们的逻辑。

```
function add (x, y) {
  return x + y
}

function addFive (x, addReference) {
  return addReference(x, 5)
}

function addTen (x, addReference) {
  return addReference(x, 10)
}

function addTwenty (x, addReference) {
  return addReference(x, 20)
}

addFive(10, add) // 15
addTen(10, add) // 20
addTwenty(10, add) // 30
```

再一次出现这种情况，这样写并不糟糕，但是我们重复写了好多相似的逻辑。这里我们的目标是要能根据需要写很多 “adder” 函数（`addFive`、`addTen`、`addTwenty` 等等），同时尽可能减少代码重复。为了完成这个目标，我们创建一个 `makeAdder` 函数怎么样？着个函数可以传入一个数字和原始 `add` 函数。因为这个函数的目的是创建一个新的 adder 函数，我们可以让其返回一个全新的传递数字来实现加法的函数。这儿讲的有点多，让我们来看下代码吧。

```
function add (x, y) {
  return x + y
}

function makeAdder (x, addReference) {
  return function (y) {
    return addReference(x, y)
  }
}

const addFive = makeAdder(5, add)
const addTen = makeAdder(10, add)
const addTwenty = makeAdder(20, add)

addFive(10) // 15
addTen(10) // 20
addTwenty(10) // 30
```

太酷了！现在我们可以在需要的时候随意地用最低的代码重复度创建 “adder” 函数。

> 如果你在意的话，这个通过一个多参数的函数来返回一个具有较少参数的函数的模式被叫做 “部分应用（Partial Application）“，它也是函数式编程的技术。JavaScript 内置的 “.bind“ 方法也是一个类似的例子。

好吧，那这与 React 以及我们之前遇到鼠标悬停的组件有什么关系呢？我们刚刚通过创建了我们的 `makeAdder` 这个高阶函数来实现了代码复用，那我们也可以创建一个类似的 “高阶组件” 来帮助我们实现相同的功能（代码复用）。不过，不像高阶函数返回一个新的函数那样，高阶组件返回一个新的组件来渲染 “回调” 组件🤯。这里有点复杂，让我们来攻克它。

##### （我们的）高阶函数

*   是一个函数
*   有一个回调函数做为参数
*   返回一个新的函数
*   返回的函数会触发我们之前传入的回调函数

```
function higherOrderFunction (callback) {
  return function () {
    return callback()
  }
}
```

##### （我们的）高阶组件

*   是一个组件
*   有一个组件做为参数
*   返回一个新的组件
*   返回的组件会渲染我们之前传入的组件

```
function higherOrderComponent (Component) {
  return class extends React.Component {
    render() {
      return <Component />
    }
  }
}
```

我们已经有了一个高阶函数的基本概念了，现在让我们来完善它。如果你还记得的话，我们之前的问题是我们重复地在每个需要的组件上写我们的鼠标悬停的处理逻辑。

```
state = { hovering: false }
mouseOver = () => this.setState({ hovering: true })
mouseOut = () => this.setState({ hovering: false })
```

考虑到这一点，我们希望我们的高阶组件（我们把它称作 `withHover`）自身需要能封装我们的鼠标悬停处理逻辑然后传递 `hovering` state 给其所需要渲染的组件。这将允许我们能够复用鼠标悬停逻辑，并将其装入单一的位置（`withHover`）。

最后，下面的代码就是我们的最终目标。无论什么时候我们想让一个组件具有 `hovering` state，我们都可以通过将它传递给withHover 高阶组件来实现。

```
const InfoWithHover = withHover(Info)
const TrendChartWithHover = withHover(TrendChart)
const DailyChartWithHover = withHover(DailyChart)
```

于是，无论给 `withHover` 传递什么组件，它都会渲染原始组件，同时传递一个 `hovering` prop。

```
function Info ({ hovering, height }) {
  return (
    <>
      {hovering === true
        ? <Tooltip id={this.props.id} />
        : null}
      <svg
        className="Icon-svg Icon--hoverable-svg"
        height={height}
        viewBox="0 0 16 16" width="16">
          <path d="M9 8a1 1 0 0 0-1-1H5.5a1 1 0 1 0 0 2H7v4a1 1 0 0 0 2 0zM4 0h8a4 4 0 0 1 4 4v8a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4zm4 5.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z" />
      </svg>
    </>
  )
}
```

现在我们需要做的最后一件事是实现 `withHover`。正如我们上面所看到的：

*   传入一个组件参数
*   返回一个新的组件
*   渲染传入参数的那个组件同时注入一个 “hovering” prop。

##### 传入一个组件参数

```
function withHover (Component) {

}
```

##### 返回一个新的组件

```
function withHover (Component) {
  return class WithHover extends React.Component {

  }
}
```

#### 渲染传入参数的那个组件同时注入一个 “hovering” prop

现在问题变为了我们应该如何获取 `hovering` 呢？好吧，我们已经有之前写逻辑的代码了。我们仅仅需要将其添加到一个新的组件同时将 `hovering` state 作为一个 prop 传递给参数中的 `组件` 。

```
function withHover(Component) {
  return class WithHover extends React.Component {
    state = { hovering: false }
    mouseOver = () => this.setState({ hovering: true })
    mouseOut = () => this.setState({ hovering: false })
    render() {
      return (
        <div onMouseOver={this.mouseOver} onMouseOut={this.mouseOut}>
          <Component hovering={this.state.hovering} />
        </div>
      );
    }
  }
}
```

我比较喜欢的思考这些知识的方式（同时也在 React 文档中有提到）是 **组件是将 props 转化到视图层，高阶组件则是将一个组件转化到另一个组件。**在我们的例子中，我们将我们的 `Info`、`TrendChart` 和 `DailyChart` 组件搬运到一个具有 `hovering` prop 的组件中。 

* * *

至此，我们已经涵盖到了高阶组件的所有基础知识。这里还有一些很重要的知识我们需要来说明下。

如果你再回去看我们的 `withHover` 高阶组件的话，它有一个缺点就是它已经假定了一个名为 `hovering` 的 prop。在大多数情况下这样或许是没问题的，但是在某些情况下会出问题。举个例子，如果（原来的）组件已经有一个叫做 `hovering` 的 prop 呢？这里我们出现了命名冲突。我们可以做的是让我们的 `withHover` 高阶组件能够允许用户自己定义传入子组件的 prop 名。因为 `withHover` 只是一个函数，让我们让它的第二个参数来描述传递给子组件 prop 的名字。

```
function withHover(Component, propName = 'hovering') {
  return class WithHover extends React.Component {
    state = { hovering: false }
    mouseOver = () => this.setState({ hovering: true })
    mouseOut = () => this.setState({ hovering: false })
    render() {
      const props = {
        [propName]: this.state.hovering
      }

      return (
        <div onMouseOver={this.mouseOver} onMouseOut={this.mouseOut}>
          <Component {...props} />
        </div>
      );
    }
  }
}
```

现在我们设置了默认的 prop 名称为 `hovering`（通过使用 ES6 的默认参数特性来实现），如果用户想改变  `withHover` 的默认 prop 名的话，可以通过第二个参数来传递一个新的 prop 名。

```
function withHover(Component, propName = 'hovering') {
  return class WithHover extends React.Component {
    state = { hovering: false }
    mouseOver = () => this.setState({ hovering: true })
    mouseOut = () => this.setState({ hovering: false })
    render() {
      const props = {
        [propName]: this.state.hovering
      }

      return (
        <div onMouseOver={this.mouseOver} onMouseOut={this.mouseOut}>
          <Component {...props} />
        </div>
      );
    }
  }
}

function Info ({ showTooltip, height }) {
  return (
    <>
      {showTooltip === true
        ? <Tooltip id={this.props.id} />
        : null}
      <svg
        className="Icon-svg Icon--hoverable-svg"
        height={height}
        viewBox="0 0 16 16" width="16">
          <path d="M9 8a1 1 0 0 0-1-1H5.5a1 1 0 1 0 0 2H7v4a1 1 0 0 0 2 0zM4 0h8a4 4 0 0 1 4 4v8a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4zm4 5.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z" />
      </svg>
    </>
  )
}

const InfoWithHover = withHover(Info, 'showTooltip')
```

* * *

你可能发现了我们的 `withHover` 函数实现的另外一个问题。看看我们的 `Info` 组件，·你可能会发现其还有一个 `height` 属性，但是 `height` 将会是 undefined。其原因是我们的 `withHover` 组件是渲染 `Component` 组件的函数。事实上我们这样做的话，除了 `hovering` prop 以外我们不会传递任何 prop 给我们最终创建的 `<Component />` 。

```
const InfoWithHover = withHover(Info)

...

return <InfoWithHover height="16px" />
```

`height` prop 通过 `InfoWithHover` 组件传入，但是这个组件是从哪儿来的？它是我们通过 `withHover` 所创建并返回的那个组件。

```
function withHover(Component, propName = 'hovering') {
  return class WithHover extends React.Component {
    state = { hovering: false }
    mouseOver = () => this.setState({ hovering: true })
    mouseOut = () => this.setState({ hovering: false })
    render() {
      console.log(this.props) // { height: "16px" }

      const props = {
        [propName]: this.state.hovering
      }

      return (
        <div onMouseOver={this.mouseOver} onMouseOut={this.mouseOut}>
          <Component {...props} />
        </div>
      );
    }
  }
}
```

深入 `WithHover` 组件内部，`this.props.height` 的值是 `16px` 但是我们没有用它做任何事情。我们需要确保我们将其传入给我们实际渲染的 `Component`。

```
   render() {
      const props = {
        [propName]: this.state.hovering,
        ...this.props,
      }

      return (
        <div onMouseOver={this.mouseOver} onMouseOut={this.mouseOut}>
          <Component {...props} />
        </div>
      );
    }
```

* * *

由此来看，我们已经感受到了使用高阶组件减少代码重复的诸多优点。但是，它（高阶组件）还有什么坑吗？当然有，我们马上就去踩踩这些坑。

当我们使用高阶组件时，会发生一些 [控制反转](https://en.wikipedia.org/wiki/Inversion_of_control) 的情况。想象下我们正在用类似于 React Router 的 `withRouter` 这类第三方的高阶组件。 根据它们的文档，“`withRouter` 将会在任何被它包裹的组件渲染时，将 `match`、`location` 和 `history` prop 传递给它们。

```
class Game extends React.Component {
  render() {
    const { match, location, history } = this.props // From React Router

    ...
  }
}

export default withRouter(Game)
```

请注意，我们并没有（由 `<Game />` 组件直接）在界面上渲染 `Game` 元素。我们将我们的组件全权交给了 React Router 同时我们也相信其不止能正确渲染组件，也能正确传递 props。我们之前在讨论 `hovering` prop 命名冲突的时候看到过这个问题。为了修复这个问题我们尝试着给我们的 `withHover` 高阶组件传递第二个参数来允许修改 prop 的名字。但是在使用第三方高阶组件的时候，我们没有这个配置项。如果我们的 `Game` 组件已经使用了 `match`、`location` 或者  `history` 的话，就没有（像使用我们自己的组件）那没幸运了。我们除了改变我们之前所需要使用的 props 名之外就只能不使用 `withRouter` 高阶组件了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
