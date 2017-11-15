> * 原文地址：[Use a Render Prop!](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce)
> * 原文作者：[Michael Jackson](https://cdb.reacttraining.com/@mjackson?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md](https://github.com/xitu/gold-miner/blob/master/TODO/use-a-render-prop.md)
> * 译者：
> * 校对者：

# Use a Render Prop!

_Update:_ [_I made a PR to add Render Props to the official React docs_](https://github.com/facebook/react/pull/10741)_._

_Update 2: Added some language to clarify that “children as a function” is the same concept, just a different prop name._

* * *

A few months ago, I tweeted:

![](https://ws1.sinaimg.cn/large/006LnBnPly1fliue6zyrcj30ed068jri.jpg)

I was suggesting that the [higher-order component pattern](https://facebook.github.io/react/docs/higher-order-components.html) that is a popular method of code reuse in many React codebases could be replaced 100% of the time with a regular component with a “render prop”. The “come fight me” part was a friendly taunt to the rest of the React community, and a good discussion ensued, but I was ultimately frustrated by my inability to fully express what I was trying to say in bursts of 140 chars apiece. I [determined instead that I’d need to write something longer](https://twitter.com/mjackson/status/885918220154134528) at some point in the future to really do it justice.

When [Tyler](https://twitter.com/tylercollier) invited me to speak at the [Phoenix ReactJS meetup](https://www.meetup.com/Phoenix-ReactJS/events/242296327/) two weeks ago, I thought it’d be a great chance to explore the idea further. I was already going to be in Phoenix running [our React Fundamentals and Advanced React workshops](https://reacttraining.com) that week, and I’d heard great things about the meetup from my business partner [Ryan](https://medium.com/@ryanflorence) who [spoke there in April](https://www.youtube.com/watch?v=hEGg-3pIHlE).

At the meetup, I gave a talk with the most click-bait-y title (sorry!) I could think of: _Never Write Another HOC_. You can watch the talk [on Phoenix ReactJS’ YouTube channel](https://www.youtube.com/watch?v=BcVAq3YFiuc), or in the embed below:

<iframe width="700" height="393" src="https://www.youtube.com/embed/BcVAq3YFiuc" frameborder="0" gesture="media" allowfullscreen></iframe>

What follows is a brief summary of the talk in case you’d prefer to read it without watching the video. But seriously: watch the video. It’s more fun. 😀

If you skip the video and start reading, but you don’t quite grasp what I’m talking about, please _go watch the video_ instead. There’s a lot more nuance in the spoken word!

### The Problem with Mixins

I started the talk by discussing the main problem that higher-order components were designed to solve: **code reuse**.

Let’s back up a little bit to 2015–to the days of `React.createClass`. Let’s say you have a simple React app that tracks the mouse position and displays it on the page. The following is an example of how you might have built it:

```
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

Now, let’s imagine that we want to track the mouse position in another component as well. Can we reuse any of the code from our `<App>`?

In the `createClass` paradigm, the problem of code reuse was solved using a technique called “mixins”. Let’s create a `MouseMixin` that anyone can use to track the mouse position.

```
import React from 'react'
import ReactDOM from 'react-dom'

// This mixin contains the boilerplate code that
// you'd need in any app that tracks the mouse position.
// We can put it in a mixin so we can easily share
// this code with other components!
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
  // Use the mixin!
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

Problem solved, right?! Now anyone can simply “mix in” `MouseMixin` to their component class to get the `x` and `y` of the mouse in `this.state`!

### HOCs Are the New Mixins

Then last year, [ES6 classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) arrived and ultimately the React team decided to move away from using `createClass` to use them instead. It was a wise decision. Who wants to maintain their own class model when JavaScript already has one built-in?

But there was a problem: **ES6 classes don’t support mixins**. Also, besides the fact they aren’t part of the ES6 class spec, mixins have other shortcomings too, many of which [Dan](https://medium.com/@dan_abramov) discussed at length in [a post on the React blog](https://facebook.github.io/react/blog/2016/07/13/mixins-considered-harmful.html).

To summarize, problems with mixins are:

*   **ES6 classes**. They don’t support mixins.
*   **Indirection**. Mixins that modify state make it tricky to tell where that state is coming from, especially when there’s more than one mixin.
*   **Naming collisions**. Two mixins that try to update the same piece of state may overwrite one another. The `createClass` API included a check that would warn you if two mixins had a `getInitialState` value with the same keys, but it wasn’t airtight.

So instead of using mixins, many in the React community eventually settled on an alternative technique for code reuse known as [higher-order components](https://facebook.github.io/react/docs/higher-order-components.html), or HOCs. In this paradigm, code is shared using a similar technique to [**decorators**](https://en.wikipedia.org/wiki/Decorator_pattern); you start with the component that defines the bulk of the markup to be rendered and then wrap it in more components that contain the behavior you’d like to share. Instead of _mixing in_ the behavior you need, you can just _decorate_ your component! 😎

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
