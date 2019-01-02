> * 原文地址：[Use a Render Prop!](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce)
> * 原文作者：[Michael Jackson](https://cdb.reacttraining.com/@mjackson?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md](https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[MechanicianW](https://github.com/MechanicianW) [Usey95](https://github.com/Usey95)

# 用 Render props 吧！

**更新**：[我提交了一个 PR 到 React 官方文档，为其添加了 Render props](https://github.com/facebook/react/pull/10741)。

**更新2**：添加一部分内容来说明 “children 作为一个函数” 也是相同的概念，只是 prop 名称不同罢了。

* * *

几个月前，我发了一个 twitter：

![](https://ws1.sinaimg.cn/large/006LnBnPly1fliue6zyrcj30ed068jri.jpg)

> 译注：@reactjs 我可以在一个普通组件上使用一个 render prop 来完成 HOC（高阶组件） 能够做到的事情。不服来辩。

我认为，[高阶组件模式](https://facebook.github.io/react/docs/higher-order-components.html) 作为一个在许多基于 React 的代码中流行的代码复用手段，是可以被一个具有 “render prop” 的普通组件 100% 地替代的。“不服来辩” 一词是我对 React 社区朋友们的友好 “嘲讽”，随之而来的是一个系列好的讨论，但最终，我对我自己无法用 140 字来完整描述我想说的而感到失望。 我 [决定在未来的某个时间点写一篇更长的文章](https://twitter.com/mjackson/status/885918220154134528) 来公平公正的探讨这个主题。

两周前，当 [Tyler](https://twitter.com/tylercollier) 邀请我到 [Phoenix ReactJS](https://www.meetup.com/Phoenix-ReactJS/events/242296327/) 演讲时，我认为是时候去对此进行更进一步的探讨了。那周我已经到达 Phoenix 去启动 [我们的 React 基础和进阶补习课](https://reacttraining.com) 了，而且我还从我的商业伙伴 [Ryan](https://medium.com/@ryanflorence) 听到了关于大会的好消息，他在[四月份做了演讲](https://www.youtube.com/watch?v=hEGg-3pIHlE)。

在大会上，我的演讲似乎有点标题党的嫌疑：**不要再写另一个 HOC 了**。你可以在 [Phoenix ReactJS 的 YouTube 官方频道](https://www.youtube.com/watch?v=BcVAq3YFiuc) 上观看我的演讲，也可以通过下面这个内嵌的视频进行观看：

<iframe width="700" height="393" src="https://www.youtube.com/embed/BcVAq3YFiuc" frameborder="0" gesture="media" allowfullscreen></iframe>

如果你不想看视频的话，可以阅读后文对于演讲主要内容的介绍。但是严肃地说：视频要有趣多了 😀。

如果你直接跳过视频开始阅读，但并没有领会我所说的意思，就**折回去看视频**吧。演讲时的细节会更丰富。

### Mixins 存在的问题

我的演讲始于高阶组件主要解决的问题：**代码复用**。

让我们回到 2015 年使用 `React.createClass` 那会儿。假定你现在有一个简单的 React 应用需要跟踪并在页面上实时显示鼠标位置。你可能会构建一个下面这样的例子：

```js
import React from 'react'
import ReactDOM from 'react-dom'

const App = React.createClass({
  getInitialState() {
    return { x: 0, y: 0 }
  },

  handleMouseMove(event) {
    this.setState({
      x: event.clientX,
      y: event.clientY
    })
  },

  render() {
    const { x, y } = this.state

    return (
      <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>
        <h1>The mouse position is ({x}, {y})</h1>
      </div>
    )
  }
})

ReactDOM.render(<App/>, document.getElementById('app'))
```

现在，假定我们在另一个组件中也需要跟踪鼠标位置。我们可以重用 `<App>` 中的代码吗？

在 `createClass` 这个范式中，代码重用问题是通过被称为 “mixins” 的技术解决的。我们创建一个 `MouseMixin`，让任何人都能通过它来追踪鼠标位置。

```js
import React from 'react'
import ReactDOM from 'react-dom'

// mixin 中含有了你需要在任何应用中追踪鼠标位置的样板代码。
// 我们可以将样板代码放入到一个 mixin 中，这样其他组件就能共享这些代码
const MouseMixin = {
  getInitialState() {
    return { x: 0, y: 0 }
  },

  handleMouseMove(event) {
    this.setState({
      x: event.clientX,
      y: event.clientY
    })
  }
}

const App = React.createClass({
  // 使用 mixin！
  mixins: [ MouseMixin ],
  
  render() {
    const { x, y } = this.state

    return (
      <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>
        <h1>The mouse position is ({x}, {y})</h1>
      </div>
    )
  }
})

ReactDOM.render(<App/>, document.getElementById('app'))
```

问题解决了，对吧？现在，任何人都能轻松地将 `MouseMixin` 混入他们的组件中，并通过 `this.state` 属性获得鼠标的 `x` 和 `y` 坐标。

### HOC 是新的 Mixin

去年，随着[ES6 class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) 的到来，React 团队最终决定使用 ES6 class 来代替 `createClass`。这是一个明智的决定，没有人会在 JavaScript 都内置了 class 时还会维护自己的类模型。

但就存在一个问题：**ES6 class 不支持 mixin**。除了不是 ES6 规范的一部分，Dan 已经在[一篇 React 博客](https://facebook.github.io/react/blog/2016/07/13/mixins-considered-harmful.html)上发布的博文上详细讨论了 mixin 存在的其他问题。

minxins 的问题总结下来就是

* **ES6 class**。其不支持 mixins。
* **不够直接**。minxins 改变了 state，因此也就很难知道一些 state 是从哪里来的，尤其是当不止存在一个 mixins 时。
* **名字冲突**。两个要更新同一段 state 的 mixins 可能会相互覆盖。`createClass` API 会对两个 mixins 的 `getInitialState` 是否具有相同的 key 做检查，如果具有，则会发出警告，但该手段并不牢靠。

所以，为了替代 mixin，React 社区中的不少开发者最终决定用[高阶组件](https://facebook.github.io/react/docs/higher-order-components.html)（简称 HOC）来做代码复用。在这个范式下，代码通过一个类似于 [**装饰器（decorator）**](https://en.wikipedia.org/wiki/Decorator_pattern) 的技术进行共享。首先，你的一个组件定义了大量需要被渲染的标记，之后用若干具有你想用共享的行为的组件包裹它。因此，你现在是在 **装饰** 你的组件，而不是**混入**你需要的行为！

```js
import React from 'react'
import ReactDOM from 'react-dom'

const withMouse = (Component) => {
  return class extends React.Component {
    state = { x: 0, y: 0 }

    handleMouseMove = (event) => {
      this.setState({
        x: event.clientX,
        y: event.clientY
      })
    }

    render() {
      return (
        <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>
          <Component {...this.props} mouse={this.state}/>
        </div>
      )
    }
  }
}

const App = React.createClass({
  render() {
    // 现在，我们得到了一个鼠标位置的 prop，而不再需要维护自己的 state
    const { x, y } = this.props.mouse

    return (
      <div style={{ height: '100%' }}>
        <h1>The mouse position is ({x}, {y})</h1>
      </div>
    )
  }
})

// 主需要用 withMouse 包裹组件，它就能获得 mouse prop
const AppWithMouse = withMouse(App)

ReactDOM.render(<AppWithMouse/>, document.getElementById('app'))
```

让我们和 mixin 说再见，去拥抱 HOC 吧。

在 ES6 class 的新时代下，HOC 的确是一个能够优雅地解决代码重用问题方案，社区也已经广泛采用它了。

此刻，我想问一句：是什么驱使我们迁移到 HOC ? 我们是否解决了在使用 mixin 时遇到的问题？

让我们看下：

* **ES6 class**。这里不再是问题了，ES6 class 创建的组件能够和 HOC 结合。
* **不够直接**。即便用了 HOC，这个问题仍然存在。在 mixin 中，我们不知道 state 从何而来，在 HOC 中，我们不知道 props 从何而来。
* **名字冲突**。我们仍然会面临该问题。两个使用了同名 prop 的 HOC 将遭遇冲突并且彼此覆盖，并且这次问题会更加隐晦，因为 React 不会在 prop 重名是发出警告。

另一个 HOC 和 mixin 都有的问题就是，二者使用的是 **静态组合** 而不是 **动态组合**。问问你自己：在 HOC 这个范式下，组合是在哪里发生的？当组件类（如上例中的的 `AppWithMouse`）被创建后，发生了一次静态组合。

你无法在 `render` 方法中使用 mixin 或者 HOC，而这恰是 React **动态** 组合模型的关键。当你在 `render` 中完成了组合，你就可以利用到所有 React 生命期的优势了。动态组合或许微不足道，但兴许某天也会出现一篇专门探讨它的博客，等等，我有点离题了。😅

总而言之：**使用 ES6 class 创建的 HOC 仍然会遇到和使用 `createClass` 时一样的问题，它只能算一次重构。**

现在不要说拥抱 HOC 了，我们不过在拥抱新的 mixin！🤗

除了上述缺陷，由于 HOC 的实质是**包裹**组件并创建了一个**混入**现有组件的 mixin 替代，因此，**HOC 将引入大量的繁文缛节**。从 HOC 中返回的组件需要表现得和它包裹的组件尽可能一样（它需要和包裹组件接收一样的 props 等等）。这一事实使得构建健壮的 HOC 需要大量的样板代码（boilerplate code）。

上面我所讲到的，以 [React Router](https://github.com/ReactTraining/react-router) 中的 [`withRouter` HOC](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/modules/withRouter.js) 为例，你可以看到 [props 传递](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L14)、[wrappedComponentRef](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L22)、[被包裹组件的静态属性提升（hoist）](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L25)等等这样的样板代码，当你需要为你的 React 添加 HOC 时，就不得不撰写它们。

### Render Props

现在，有了另外一门技术来做代码复用，该技术可以规避 mixin 和 HOC 的问题。在 [React Training](https://reacttraining.com) 中，称之为 “Render Props”。

我第一次见到 render prop 是在 [ChengLou](https://medium.com/@chenglou) 在 React Europe 上 [关于 react-motion 的演讲](https://www.youtube.com/watch?v=1tavDv5hXpo)，大会上，他提到的 `<Motion children>` API 能让组件与它的父组件共享 interpolated animation。如果让我来定义 render prop，我会这么定义：

> 一个 render prop 是一个类型为函数的 prop，它让组件知道该渲染什么。

更通俗的说法是：不同于通过 “混入” 或者装饰来共享组件行为，**一个普通组件只需要一个函数 prop 就能够进行一些 state 共享**。

继续到上面的例子，我们将通过一个类型为函数的 `render` 的 prop 来简化 `withMouse` HOC 到一个普通的 `<Mouse>` 组件。然后，在 `<Mouse>` 的 `render` 方法中，我们可以使用一个 render prop 来让组件知道如何渲染：

```js
import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

// 与 HOC 不同，我们可以使用具有 render prop 的普通组件来共享代码
class Mouse extends React.Component {
  static propTypes = {
    render: PropTypes.func.isRequired
  }

  state = { x: 0, y: 0 }

  handleMouseMove = (event) => {
    this.setState({
      x: event.clientX,
      y: event.clientY
    })
  }

  render() {
    return (
      <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>
        {this.props.render(this.state)}
      </div>
    )
  }
}

const App = React.createClass({
  render() {
    return (
      <div style={{ height: '100%' }}>
        <Mouse render={({ x, y }) => (
          // render prop 给了我们所需要的 state 来渲染我们想要的
          <h1>The mouse position is ({x}, {y})</h1>
        )}/>
      </div>
    )
  }
})

ReactDOM.render(<App/>, document.getElementById('app'))
```

这里需要明确的概念是，`<Mouse>` 组件实际上是调用了它的 `render` 方法来将它的 state 暴露给 `<App>` 组件。因此，`<App>` 可以随便按自己的想法使用这个 state，这太美妙了。😎

在此，我想说明，“children as a function” 是一个 **完全相同的概念**，只是用 `children` prop 替代了 `render` prop。我挂在嘴边的 `render prop` 并不是在强调一个 **名叫** `prop` 的 prop，而是在强调你使用一个 prop 去进行渲染的概念。

该技术规避了所有 mixin 和 HOC 会面对的问题：

* **ES6 class**。不成问题，我们可以在 ES6 class 创建的组件中使用 render prop。
* **不够直接**。我们不必再担心 state 或者 props 来自哪里。我们可以看到通过 render prop 的参数列表看到有哪些 state 或者 props 可供使用。
* **名字冲突**。现在不会有任何的自动属性名称合并，因此，名字冲突将全无可乘之机。

并且，render prop 也不会引入 **任何繁文缛节**，因为你不会 **包裹** 和 **装饰** 其他的组件。它仅仅是一个函数！如果你使用了 [TypeScript](https://www.typescriptlang.org) 或者 [Flow](https://flow.org/)，你会发现相较于 HOC，现在很容易为你具有 render prop 的组件写一个类型定义。当然，这是另外一个话题了。

另外，这里的组合模型是 **动态的**！每次组合都发生在 render 内部，因此，我们就能利用到 React 生命周期以及自然流动的 props 和 state 带来的优势。

使用这个模式，你可以将 **任何** HOC 替换一个具有 render prop 的一般组件。这点我们可以证明！😅

### Render Props > HOCs

一个更将强有力的，能够证明 render prop 比 HOC 要强大的证据是，任何 HOC 都能使用 render prop 替代，反之则不然。下面的代码展示了使用一个一般的、具有 render prop 的 `<Mouse>` 组件来实现的 `withMouse` HOC：

```js
const withMouse = (Component) => {
  return class extends React.Component {
    render() {
      return <Mouse render={mouse => (
        <Component {...this.props} mouse={mouse}/>
      )}/>
    }
  }
}
```

有心的读者可能已经意识到了 `withRouter` HOC 在 React Router 代码库中确实就是通过[**一个 render prop **](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L13) 实现的！

所以还不心动？快去你自己的代码中使用 render prop 吧！尝试使用具有 render prop 组件来替换 HOC。当你这么做了之后，你将不再受困于 HOC 的繁文缛节，并且你也将利用到 React 给予的动态组合模型的好处，那是特别酷的特性。😎

[**Michael**](https://twitter.com/mjackson) 是 [**React Training**](https://reacttraining.com) 的成员，也是 React 社区中一个多产的[开源软件贡献者](https://github.com/mjackson)。想了解最新的培训和课程就[订阅邮件推送](subscribe to the mailing list) 并 [在 Twitter 上关注 React Training](https://twitter.com/reacttraining)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。