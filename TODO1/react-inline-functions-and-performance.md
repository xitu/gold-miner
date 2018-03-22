> * 原文地址：[React, Inline Functions, and Performance](https://cdb.reacttraining.com/react-inline-functions-and-performance-bdff784f5578)
> * 原文作者：[Ryan Florence](https://cdb.reacttraining.com/@ryanflorence?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md)
> * 译者：
> * 校对者：

# React, Inline Functions, and Performance

My wife and I just got through a huge remodel. We were beyond excited to show people the new digs. We showed my mother-in-law. She walked in the beautifully remodeled bedroom, looked up at the fantastically framed window and said: “No blinds?” 😐

![](https://cdn-images-1.medium.com/max/1000/1*_WL8zajmqcczto2bjiBqpw.jpeg)

Our new bedroom; holy crap it looks like a magazine picture. Also, no blinds.

I find myself with the same emotion when I’m talking about React. I’ll be getting through the first lecture of a workshop, showing off some cool new OSS, and invariably somebody says: “inline functions? I heard those are slow.”

It wasn’t always this way. But the last few months it comes up literally every day. As an instructor and library author, it gets exhausting. Unfortunately, I’m a dummy and I rant on twitter instead of writing something that might be insightful to others. So, this is my attempt at the better option 😂.

### What is an “inline function”

In the context of React, an inline function is a function that is defined while React is “rendering”. There are two meanings of “render” in React that people often get confused about: (1) getting the React elements from your components (calling your component’s render method) during an update and (2) actually rendering updates to the DOM. When I refer to “rendering” in this article, I’m talking about #1.

Here are a few examples of inline functions:

```
class App extends Component {
  // ...
  render() {
    return (
      <div>
        
        {/* 1. an inline event handler of a "DOM component" */}
        <button
          onClick={() => {
            this.setState({ clicked: true })
          }}
        >
          Click!
        </button>
        
        {/* 2. A "custom event" or "action" */}
        <Sidebar onToggle={(isOpen) => {
          this.setState({ sidebarIsOpen: isOpen })
        }}/>
        
        {/* 3. a render prop callback */}
        <Route
          path="/topic/:id"
          render={({ match }) => (
            <div>
              <h1>{match.params.id}</h1>}
            </div>
          )
        />
      </div>
    )
  }
}
```

### Premature optimization is the root of all evil

Before we go any further, we need to talk about how to optimize a program. Ask any performance expert and they will tell you not to prematurely optimize your program. All of them. Yes, every single one of them. 100% of people with deep performance experience will tell you not to prematurely optimize your code.

> If you aren’t measuring, you can’t even know if your optimizations are better, and you certainly won’t know if they make things worse!

I remember a talk my friend Ralph Holzmann gave about how gzip works that really solidified this idea for me. He talks about an experiment he did with LABjs, an old script loading library. You can watch from 30:02 to about 32:35 [in this video](https://vimeo.com/34164210) to hear about it, or just keep reading.

At the time, the source for [LABjs](https://github.com/getify/LABjs) did something a little awkward for performance. Instead of using normal object notation (`obj.foo`) it stored the keys in strings and used bracket notation to access the objects (`obj[stringForFoo]`). The idea was that after minifying and gzipping, the unnaturally written code would be smaller than the naturally written code. [You can see it here](https://github.com/getify/LABjs/blob/b23ee3fcad12157cf8f6a291cb54fd7550ac7f3b/LAB.src.js#L7-L34).

Ralph forked the code and removed the optimizations by writing the code naturally, without thinking about how to optimize for minification and gzip.

Turns out, removing the “optimizations” shaved off 5.3% of the file size! If you aren’t measuring, you can’t even know if your optimizations are better, and you certainly won’t know if they make things worse!

Not only can premature optimization explode development time while hurting code cleanliness, it can even backfire and _cause_ performance problems as it did for LABjs. Had the author been measuring, rather than just imagining performance issues, he would have saved development time, had cleaner code, and better performance.

Don’t prematurely optimize. Alright, back to React.

### Why do people say inline functions are slow?

Two reasons: Memory/garbage collection concerns, and `shouldComponentUpdate`.

#### Memory and garbage collection

First, folks (and [eslint configs](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md)) are concerned about memory and garbage collection costs around creating inline functions. This mostly spilled over from the days before arrow functions became ubiquitous. Lots of code would call `bind` inline, which has historically had poor performance. For example:

```
<div>
  {stuff.map(function(thing) {
    <div>{thing.whatever}</div>
  }.bind(this)}
</div>
```

Performance issues with `Function.prototype.bind` [got fixed here](http://benediktmeurer.de/2015/12/25/a-new-approach-to-function-prototype-bind/) and arrow functions are either a native thing or are transpiled by babel to plain functions; in both cases we can assume it’s not slow.

Remember, you don’t sit back and imagine “I bet that code is slow”. You write your code naturally, _then_ you measure it. If there are performance problems, fix them. We don’t need to prove an inline arrow function is fast, somebody else needs to prove it’s slow. Otherwise it’s a premature optimization.

As far as I’ve seen, nobody has presented an analysis of their app that indicates inline arrow functions are slow. Until then, it’s not even worth talking about — but I’ll offer one more thought anyway 😝

If the cost of creating an inline function is high enough to warrant an eslint rule against it, why would we want to move that expense to the hot path of initialization?

```
class Dashboard extends Component {
  state = { handlingThings: false }
  
  constructor(props) {
    super(props)
    
    this.handleThings = () =>
      this.setState({ handlingThings: true })

    this.handleStuff = () => { /* ... */ }

    // even more expensive with bind
    this.handleMoreStuff = this.handleMoreStuff.bind(this)
  }

  handleMoreStuff() { /* ... */ }

  render() {
    return (
      <div>
        {this.state.handlingThings ? (
          <div>
            <button onClick={this.handleStuff}/>
            <button onClick={this.handleMoreStuff}/>
          </div>
        ) : (
          <button onClick={this.handleThings}/>
        )}
      </div>
    )
  }
}
```

By prematurely optimizing we’ve slowed down the initialization of the component by 3x! If all the handlers were inline, the initial render would only have to create one function. Instead, we’ve created three. We haven’t measured anything though, so we have no reason to believe any of this is a problem.

If you want to completely miss the point, go make an eslint rule that requires inline functions everywhere to speed up the initial render 🤦🏾‍♀️.

#### PureComponent and shouldComponentUpdate

This is where the real meat of the problem lives. You can see real performance improvements by understanding two things: `shouldComponentUpdate` and JavaScript strict equality comparisons. If you don’t understand them well, you can inadvertently make your React code harder to work with in the name of performance.

When you call `setState`, React will compare the old React elements to a new set of React elements (this is called r_econciliation_, you can [read about it here](https://reactjs.org/docs/reconciliation.html)) and then use that information to update the real DOM elements. Sometimes that can get slow if you’ve got a lot of elements to check (like a big SVG). In these cases, React provides an escape hatch called `shouldComponentUpdate`.

```
class Avatar extends Component {
  shouldComponentUpdate(nextProps, nextState) {
    return stuffChanged(this, nextProps, nextState))
  }
  
  render() {
    return //...
  }
}
```

If your component has `shouldComponentUpdate` defined, before React compares the old and new elements, it will ask `shouldComponentUpdate` if anything changed. If it returns false, then React will completely skip the element diff, saving some time. If your component is large enough, this can have considerable impact on performance.

The most common way to optimize a component is to extend `React.PureComponent` instead of `React.Component`. A `PureComponent` will diff your props and state in `shouldComponentUpdate` so you don’t have to.

```
class Avatar extends React.PureComponent { ... }
```

`Avatar` will now use a “strict equality comparison” on its props and state when being asked to update, hopefully speeding things up.

#### Strict Equality Comparison

There are six primitive types in JavaScript: string, number, boolean, null, undefined, and symbol. When you do a “strict equality comparison” on two primitives that hold the same value, you’ll get `true`. For example:

```
const one = 1
const uno = 1
one === uno // true
```

When `PureComponent` diffs props it uses a strict equality comparison. This works out great for inlined primitive values: `<Toggler isOpen={true}/>`.

The prop diffing problem arises because of non-primitive types — err, excuse me, _type_. There is only one other type and that’s `Object`. What about functions and arrays you say? _Well, actually_ those are just objects.

> Functions are regular objects with the additional capability of being callable.

> - [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures)

LOL, okay JavaScript. So anyway, strict equality checks on objects, even with seemingly similar values, will evaluate to `false`:

```
const one = { n: 1 }
const uno = { n: 1 }
one === uno // false
one === one // true
```

So, if you inline an object in your JSX, it will fail the `PureComponent` prop diff and move on to diffing the more expensive React elements. The element diff will come up empty and now we’ve wasted time on both diffs.

```
// first render
<Avatar user={{ id: ‘ryan’ }}/>

// next render
<Avatar user={{ id: ‘ryan’ }}/>

// prop diff thinks something changed because {} !== {}
// element diff (reconciler) finds out that nothing changed
```

Since functions are objects and `PureComponent` does a strict equality check on props, an inline function will _always_ fail the prop diff and move on to the element diff in the reconciler.

You can see this isn’t just about inline functions. The function is simply the lead singer of the object, function, array three-piece performance postulation proliferation.

In order to make `shouldComponentUpdate` happy, you have to keep referential identity of the function. For experienced JavaScript developers, it’s not too bad. But, [Michael](https://medium.com/@mjackson) and I have led workshops with over 3,500 people at varying levels of experience and it ain’t easy for a lot of folks. ES classes don’t offer any help either, leading us down all sorts of JavaScript paths:

```
class Dashboard extends Component {
  constructor(props) {
    super(props)
    
    // bind? slows down the initialization path, looks awful
    // when you have 20 of them (I have seen your code, I know)
    // and it increases bundle size
    this.handleStuff = this.handleStuff.bind(this)

    // _this is ugly.
    var _this = this
    this.handleStuff = function() {
      _this.setState({})
    }
    
    // If you can use an ES class then you can probably use an arrow
    // function (babel, or a modern browser). This isn't too bad but
    // putting all of your handlers in the constructor is kind of
    // not awesome
    this.handleStuff = () => {
      this.setState({})
    }
  }
  
  // this is nice, but it isn't JavaScript, not yet anyway, so now
  // we need to talk about how TC39 works and evaluate our draft
  // stage risk tolerance
  handleStuff = () => {}
}
```

Learning how to keep referential identity of a function leads to surprisingly long conversations.

There’s usually no reason why we’re forcing people to do this other than an eslint config yelled at them. I’d like to show that you can have inline functions and performance optimizations both at the same time. But first, I have a personal performance story.

### My own experience with PureComponent

When I first learned about `PureRenderMixin` (the thing from earlier versions of React that later became `PureComponent`) I put in a bunch of measurements and measured my app’s performance. I then added `PureRenderMixin` to every single component. When I took the optimized set of measurements I was hoping to have a cool story to tell about how much faster everything got.

Much to my surprise, my app got slower 🤔.

Why? Well, think about it. If you have a `Component` how many diffs are there? If you have a `PureComponent` how many diffs are there? The answers are “just one” and “at least one and sometimes two”, respectively. If a component _usually_ changes when there’s an update, then a `PureComponent` will be doing two diffs instead of just one (props and state in `shouldComponentUpdate`, and then the normal element diff). Which means it’s going to be _slower usually_ but _faster occasionally_. Apparently, most of my components changed most of the time, so on the whole, my app got slower. Oops.

There are no silver bullets when it comes to performance. You have to measure.

### The three scenarios

At the start of the article I showed three types of inline functions. Now that we have some background, let’s talk about each one them. But please remember to keep `PureComponent` on the shelf until you have a measurement to justify it.

#### DOM component event handler

```
<button
  onClick={() => this.setState(…)}
>click</button>
```

It’s common to do nothing more than `setState` inside of event handlers for buttons, inputs, and other DOM components. This often makes an inline function the cleanest approach. Instead of bouncing around the file to find the event handlers, they’re colocated. The React community generally welcomes colocation.

The `button` component (and every other DOM component) can’t even be a `PureComponent`, so there are no `shouldComponentUpdate` referential identity concerns here.

So, the only reason to think this is slow is if you think simply defining a function is a big enough expense to worry about. We’ve discussed that there is no evidence anywhere that it is. It’s simply armchair performance postulation. These are fine until proven otherwise.

#### A “custom event” or “action”

```
<Sidebar onToggle={(isOpen) => {
  this.setState({ sidebarIsOpen: isOpen })
}}/>
```

If `Sidebar` is a `PureComponent` we will be breaking the prop diff. Again, since the handler is simple, the colocation can be preferable.

With an event like `onToggle`, why is `Sidebar` even diffing it? There are only two reasons to include a prop in the `shouldComponentUpdate` diff:

1.  You use the prop to render.
2.  You use the prop to perform a side-effect in `componentWillReceiveProps`, `componentDidUpdate`, or `componentWillUpdate`.

Most `on<whatever>` props do not meet either of these requirements. Therefore, most `PureComponent` usages are over-diffing, forcing developers to maintain referential identity of the handler needlessly.

We should only diff the props that matter. That way people can colocate handlers and still get the performance gains you’re seeking (and since we’re concerned about performance, we’re diffing less!).

For most components, I’d recommend creating a `PureComponentMinusHandlers` class and inherit from that instead of inheriting from `PureComponent`. It could just skip all checks on functions. Have your cake and eat it too.

Well, almost.

If you receive a function and pass that function directly into another component, it’ll get stale. Check this out:

```
// 1. App will pass a prop to Form
// 2. Form is going to pass a function down to button
//    that closes over the prop it got from App
// 3. App is going to setState after mounting and pass
//    a *new* prop to Form
// 4. Form passes a new function to Button, closing over
//    the new prop
// 5. Button is going to ignore the new function, and fail to
//    update the click handler, submitting with stale data

class App extends React.Component {
  state = { val: "one" }

  componentDidMount() {
    this.setState({ val: "two" })
  }

  render() {
    return <Form value={this.state.val} />
  }
}

const Form = props => (
  <Button
    onClick={() => {
      submit(props.value)
    }}
  />
)

class Button extends React.Component {
  shouldComponentUpdate() {
    // lets pretend like we compared everything but functions
    return false
  }

  handleClick = () => this.props.onClick()

  render() {
    return (
      <div>
        <button onClick={this.props.onClick}>This one is stale</button>
        <button onClick={() => this.props.onClick()}>This one works</button>
        <button onClick={this.handleClick}>This one works too</button>
      </div>
    )
  }
}
```

[Here’s a codesandbox running that app](https://codesandbox.io/s/v38y6zk8ml).

So, if you like the idea of inheriting from a `PureRenderWithoutHandlers`, make sure you don’t ever pass your ignored handlers _directly_ to other components — you need to wrap them one way or another.

Now we either have to maintain referential identity, or we have to avoid referential identity! Welcome to performance optimization. At least with this approach it’s the optimized component that has to deal with it, not the code using it.

I’m going to be candid, that example app is an edit I made after publishing that [Andrew Clark](https://medium.com/@acdlite) brought to my attention. And here you thought I was smart enough to know when to manage referential identity and when not to! 😂

#### A render prop

```
<Route
  path=”/topic/:id”
  render={({ match }) => (
    <div>
      <h1>{match.params.id}</h1>}
    </div>
  )
/>
```

Render props are a pattern used to create a component that exists to compose and manage shared state. ([You can read more about them here](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce).) The contents of the render prop are unknowable to the component. For example:

```
const App = (props) => (
  <div>
    <h1>Welcome, {props.name}</h1>
    <Route path=”/” render={() => (
      <div>
        {/*
          props.name is from outside of Route and it’s not passed in
          as a prop, so Route can’t reliably be a PureComponent, it
          has no knowledge of what is rendered inside here.
        */}
        <h1>Hey, {props.name}, let’s get started!</h1>
      </div>
    )}/>
  </div>
)
```

That means an inline render prop function won’t cause problems with `shouldComponentUpdate`: It can’t ever know enough to be a `PureComponent.`

So, the only other objection is back to believing that simply defining functions is slow. Repeating from the first example: there’s no evidence to support that. It’s simply armchair performance postulation.

![Snipaste_2018-03-22_18-47-55.png](https://i.loli.net/2018/03/22/5ab389e694b03.png)

### In summary

1.  Write your code naturally, code to the design.
2.  Measure your interactions to find slow paths. [Here’s how](https://reactjs.org/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline).
3.  Use `PureComponent` and `shouldComponentUpdate` only when you need to, skipping prop functions (unless they are used in lifecycle hooks for side-effects).

If you really believe that premature optimization is bad practice, then you won’t need proof that inline functions are fast, you need proof that they are slow.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
