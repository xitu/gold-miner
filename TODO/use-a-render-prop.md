> * 原文地址：[Use a Render Prop!](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce)
> * 原文作者：[Michael Jackson](https://cdb.reacttraining.com/@mjackson?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md](https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：

# 用 Render props 吧！

**更新**：[我提交了一个 PR 到 React 官方文档，为其添加了 Render props](https://github.com/facebook/react/pull/10741)。

**更新2**：添加一部分内容来说明 “children 作为一个函数” 也是相同的概念，只是 prop 名称不同罢了。

* * *

几个月前，我发了一个 twitter：

![](https://ws1.sinaimg.cn/large/006LnBnPly1fliue6zyrcj30ed068jri.jpg)

> 译注：@reactjs 我可以在一个普通组件上使用一个 render prop 来完成 HOC（高阶组件） 能够做到的事情。不服来辩。

我认为，[高阶组件模式](https://facebook.github.io/react/docs/higher-order-components.html) 作为一个在许多基于 React 的代码中流行的代码复用手段，是可以被一个具有 “render prop” 的一般组件 100% 地替代的。“不服来辩” 一词是我对 React 社区朋友们的友好 “嘲讽”，随之而来的是一个系列好的讨论，但最终，我对我自己无法用 140 字来完整描述我想说的而感到失望。 我 [决定在未来的某个时间点写一篇更长的文章](https://twitter.com/mjackson/status/885918220154134528) 来公平公正的探讨这个主题。

两周后，当 [Tyler](https://twitter.com/tylercollier) 邀请我到 [Phoenix ReactJS ](https://www.meetup.com/Phoenix-ReactJS/events/242296327/) 演讲时，我认为是时候去对此进行更进一步的探讨了。那周我已经到达 Phoenix 去启动 [我们的 React 基础和进阶补习课](https://reacttraining.com) 了，关于大会，还有一件令我高兴的事儿就是我的商业伙伴 [Ryan](https://medium.com/@ryanflorence) 在[四月份做了演讲](https://www.youtube.com/watch?v=hEGg-3pIHlE)。

在大会上，我的演讲似乎有点标题党的嫌疑：**不要再写另一个 HOC 了**.你可以在 [Phoenix ReactJS 的 YouTube 官方频道]() 上观看我的演讲，也可以通过下面这个内嵌的视频进行观看：

<iframe width="700" height="393" src="https://www.youtube.com/embed/BcVAq3YFiuc" frameborder="0" gesture="media" allowfullscreen></iframe>

后文大致记述了演讲的主要内容，如果你不想观看视频的话，你可以阅读它。但是严肃地说：视频要有趣多了 😀。

如果你直接跳过视频开始阅读，但仍没有领会我所说的意思，就**折回去看视频**吧。演讲时的细节会更丰富。

### Mixin 存在的问题

我的演讲始于高阶组件主要解决的问题：**代码重用**。

让我们回到 2015 年使用 `React.createClass` 那会儿。假定你现在有一个简单的 React 应用需要跟踪并在页面上实时显示鼠标位置。下面的例子可能是你会构建的。

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

在 `createClass` 这个范式中，代码重用问题是通过被称为 “mixin” 的技术解决的。我们创建一个 `MouseMixin`，让任何人都能通过它来追踪鼠标位置。

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
  // 使用这个 mixin！
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

问题解决了，对吧？现在，任何人都能轻松地将 `MouseMixin` 混入他们的组件中，并通过 `this.state` 对象获得鼠标的 `x` 和 `y` 坐标。

### HOC 是新的 Mixin

去年，随着[ES6 class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) 的到来，React 团队最终决定使用 ES6 class 来代替 `createClass`。

但就存在一个问题：**ES6 class 不支持 mixin**。除了不是 ES6 规范的一部分，Dan 已经在[一篇 React 博客](https://facebook.github.io/react/blog/2016/07/13/mixins-considered-harmful.html)上发布的博文上详细讨论了 mixin 存在的其他问题。

minxin 的问题总结下来就是

* **ES6 class**。其不支持 mixin。
* **不够直接**。minxin 改变了 state，因此也就很难知道一些 state 是从哪里来的，尤其是当不止存在一个 mixin 时。
* **名字冲突**。两个要更新同一段 state 的 mixin 可能会相互覆盖。`createClass` API 会对两个 mixin 的 `getInitialState` 是否具有相同的 key 做检查，如果具有，则会发出警告，但该手段并不牢靠。

所以，为了替代 mixin，React 社区中的不少开发者最终决定用[高阶组件](https://facebook.github.io/react/docs/higher-order-components.html)（简称 HOC）来做代码复用。在这个范式下，代码通过一个类似于 [**装饰器（decorator）**](https://en.wikipedia.org/wiki/Decorator_pattern) 的技术进行共享。首先，你的一个组件定义了大量需要被渲染的标记，之后用若干具有你想用共享的行为的组件包裹它。从而，你现在是在 **装饰** 你的组件，而不是**混入**你需要的行为！

```
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
    // Instead of maintaining our own state,
    // we get the mouse position as a prop!
    const { x, y } = this.props.mouse

    return (
      <div style={{ height: '100%' }}>
        <h1>The mouse position is ({x}, {y})</h1>
      </div>
    )
  }
})

// Just wrap your component in withMouse and
// it'll get the mouse prop!
const AppWithMouse = withMouse(App)

ReactDOM.render(<AppWithMouse/>, document.getElementById('app'))
```

Goodbye mixins, hello HOCs!

It was a good solution that solved the problem of code reuse elegantly in the brave new world of ES6 classes, and the community adopted it in droves.

At this point I’d like to stop and ask: what did we gain by moving to higher-order components? Did we solve any of the problems we had with mixins?

Let’s see:

*   **ES6 classes**. Yep! No problems here. We can use HOCs with components created using ES6 classes.
*   **Indirection**. We still have the same problem with indirection that we had when we were using mixins. Except this time instead of wondering where our state comes from we’re wondering which HOC provides which props.
*   **Naming collisions**. Unfortunately we still have this problem too. Two HOCs that try to use the same prop name will collide and overwrite one another, except this time it’s slightly more insidious because React won’t warn us about the prop name collision. 😳

Another problem that both mixins and HOCs share is that they use **static composition** instead of **dynamic composition**. Ask yourself: where is the composition happening in the HOC paradigm? Static composition happens once, when the component class is created (e.g. `AppWithMouse` in the previous example).

You don’t use mixins or HOCs in your `render` method, which is a key piece of React’s **dynamic** composition model. When you compose in `render`, you get to take advantage of the full React lifecycle. This point is subtle, and probably deserves its own blog post at some point in the future, but I digress. 😅

So in summary: **using a HOC with ES6 classes poses many of the same problems that mixins did with** `**createClass**`**, just re-arranged a bit**.

Welcome to the new mixins! 🤗

In addition to these drawbacks, **HOCs introduce a lot of ceremony** due to the fact that they _wrap_ components and create new onesinstead of being _mixed in_ to existing components. The component that is returned from the HOC needs to act as similarly as it can to the component that it wraps (it should take the same props, etc.) This fact alone requires a lot of boilerplate code just to build a robust HOC.

You can see a good example of what I’m talking about in [the](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/modules/withRouter.js) `[withRouter](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/modules/withRouter.js)` [HOC](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/modules/withRouter.js) that ships with [React Router](https://github.com/ReactTraining/react-router). The [prop passing](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L14), the `[wrappedComponentRef](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L22)`, the [hoisting of the wrapped component’s static properties](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L25), and other things are all part of the dance you need to do if you’re going to ship a HOC with your React library.

### Render Props

There is another technique for sharing code that avoids the drawbacks of mixins and HOCs. At [React Training](https://reacttraining.com), we call this technique “Render Props”.

The first time I ever saw a render prop was in [Cheng Lou](https://medium.com/@chenglou)’s [talk on react-motion](https://www.youtube.com/watch?v=1tavDv5hXpo) at React Europe where he talked about the `<Motion children>` API that they were using to share interpolated animation values with the parent component. If I had to try and define it, I’d say something like this:

> A render prop is a function prop that a component uses to know what to render.

More generally speaking, the idea is this: instead of “mixing in” or decorating a component to share behavior, **just render a regular component with a function prop that it can use to share some state with you**.

Continuing with the example above, we can simplify the `withMouse` HOC to a regular `<Mouse>` component with a `render` prop that is a function. Then, inside `<Mouse>`'s `render`, we can use that prop to know what to render!

```
import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

// Instead of using a HOC, we can share code using a
// regular component with a render prop!
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
          // The render prop gives us the state we need
          // to render whatever we want here.
          <h1>The mouse position is ({x}, {y})</h1>
        )}/>
      </div>
    )
  }
})

ReactDOM.render(<App/>, document.getElementById('app'))
```

The main concept to understand here is that the `<Mouse>` component essentially exposes its state to the `<App>` component by calling its `render` prop. Therefore, `<App>` can render whatever it wants with that state. Pretty cool. 😎

I should clarify at this point that “children as a function” is _the exact same concept_, just using the `children` prop instead of `render`. When I say “render prop” I’m not talking specifically about a prop _named_ `render`, but rather the concept of having a prop that you use to render something. 😅

This technique avoids all of the problems we had with mixins and HOCs:

*   **ES6 classes**. Yep, not a problem. We can use render props with components that are created using ES6 classes.
*   **Indirection**. We don’t have to wonder where our state or props are coming from. We can see them in the render prop’s argument list.
*   **Naming collisions**. There is no automatic merging of property names, so there is no chance for a naming collision.

And there’s absolutely **no ceremony** required to use a render prop because you’re not _wrapping_ or _decorating_ some other component. It’s just a function! Actually, if you’re using [TypeScript](https://www.typescriptlang.org/) or [Flow](https://flow.org/), you’ll probably find it much easier to write a type definition for your component with a render prop than its equivalent HOC. Again, a topic for a separate post!

Additionally, **the composition model here is _dynamic_**! Everything happens inside of render, so we get to take full advantage of the React lifecycle and the natural flow of props & state.

Using this pattern, you can replace **any** HOC with a regular component with a render prop. And we can prove it, too! 😅

### Render Props > HOCs

One of the most convincing pieces of evidence that render props are a more powerful pattern than HOCs is the fact that any HOC can be implemented using a render prop, but the inverse is not true. The following is an implementation of our `withMouse` HOC using a regular ol’ `<Mouse>`:

```
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

Observant readers may have already noticed that the `withRouter` HOC in the React Router codebase is actually implemented with … wait for it … [a render prop](https://github.com/ReactTraining/react-router/blob/f77440ec9025d463c6713039ab1a6db1faca99bb/packages/react-router/modules/withRouter.js#L13)!

So go ahead, try out render props in your codebase! Go and find some HOC and turn it into a regular component with a render prop. As you do, you should see a lot of the HOC ceremony code melt away and you’ll start to take better advantage of the dynamic composition model that React gives us, which is extremely cool. 😎

[_Michael_](https://twitter.com/mjackson) _is a partner at_ [_React Training_](https://reacttraining.com) _and a prolific_ [_OSS contributor_](https://github.com/mjackson) _in the React community. To learn more about upcoming training workshops and courses, please_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。