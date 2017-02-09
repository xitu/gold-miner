> * 原文地址：[React “Aha” Moments](https://medium.freecodecamp.com/react-aha-moments-4b92bd36cc4e#.jxiocbkv5)
* 原文作者：[Tyler McGinnis](https://medium.freecodecamp.com/@tylermcginnis?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# React “Aha” Moments #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*6nyVYm78oKNBrvd8.jpg">

As a teacher, one of my main goals is to maximize people’s “aha” moments.

An [“aha” moment](https://en.wikipedia.org/wiki/Eureka_effect)  is a moment of sudden insight or clarity, where the subject starts to makes a lot more sense. We’ve all experienced these. And the best teachers I know are able to understand their audience and adapt the lesson in order to maximize these moments.

Over the past few years, I’ve taught React through just about every popular medium. The entire time, I’ve taken detailed notes on what triggers these “aha” moments, specifically for learning React.

About two weeks ago, I came across [this Reddit thread](https://www.reddit.com/r/reactjs/comments/5gmywc/what_were_the_biggest_aha_moments_you_had_while/) , which had the same idea. It inspired me to write this article, which is my collection of these moments and reflections on other moments shared in that Reddit thread. My hope is that this will will help React concepts click for you in new ways.

### Insight #1: Props are to components what arguments are to functions. ###

One of the best parts of React is that you can take that same intuition you have about JavaScript functions, then use it to determine when and where you should create React components. But with React, instead of taking in some arguments and returning a value, your function will take in some arguments and return an object representation of your User Interface (UI).

This idea can be summed up in the following formula: `fn(d) = V`, which can be read: “a function takes in some data and returns a view.”

This is a beautiful way to think about developing user interfaces because now your UI is just composed of different function invocations. This is how you’re already used to building applications. And now you can take advantage of all of the benefits of function composition when building UIs.

### Insight #2: In React, your entire application’s UI is built using function composition. JSX is an abstraction over those functions. ###

The most common reaction I see from first timers using React goes something like: “React seems cool, but I really don’t like JSX. It breaks my separation of concerns.”

JSX isn’t trying to be HTML. And it’s definitely more than just a templating language.

There are two important things to understand with JSX.

First, [JSX is an abstraction over *React.createElement*](https://tylermcginnis.com/react-elements-vs-react-components/), which is a function that returns an object representation of the DOM.

I know that was wordy, but basically whenever you write JSX, once it’s transpiled, you’ll have a JavaScript object which represents the actual DOM — or whatever view is representative of the platform you’re on (iOS, Android, etc). Then React is able to analyze that object and analyze the actual DOM. Then by doing a diff, React can update the DOM only where a change occurred.

This has some performance upsides to it but more importantly shows that JSX really is “just JavaScript.”

Second, because JSX is just JavaScript, you get all the benefits that JavaScript provides — such as composition, linting, and debugging. But you also still get with the declarativeness (and familiarity) of HTML.

### Insight #3: Components don’t necessary have to correspond to DOM nodes. ###

When you first learn React you’re taught that “Components are the building blocks of React. They take in input and return some UI (the Descriptor Pattern).”

Does that mean that every component needs to directly return UI descriptors as we’re typically taught? What if we wanted to have a component render another component (Higher Order Component pattern)? What if we wanted a component to manage some slice of state and then instead of returning a UI descriptor, it returns a function invocation passing in the state (Render Props pattern)? What if we had a component that was in charge of managing sound rather than a visual UI, what would it return?

What’s great about React is you don’t **have** to return typical “views” from your components. As long as what eventually gets returned is a React element, null, or false, you’re good.

You can return other components:

```
render () { 
  return <MyOtherComponent /> 
}
```

You can return function invocations:

```
render () { 
  return this.props.children(this.someImportantState) 
}
```

Or you can return nothing at all:

```
render () { 
  return null 
}
```

I really enjoyed Ryan Florence’s [React Rally talk](https://www.youtube.com/watch?v=kp-NOggyz54) where he covers this principle more in depth.

### Insight #4: When two components need to share state, I need to lift that state up instead of trying to keep their states in sync. ###

A component-based architecture naturally makes sharing state more difficult. If two components rely on the same state, where should that state live?

This was such a popular question that it spurred an entire ecosystem of solutions, which eventually ended with Redux.

Redux’s solution is to put that shared state in another location called a “store.” Components can then subscribe to any portions of the store they need, and can also dispatch “actions” to update the store.

React’s solution is to find the nearest parent of both of those components and have that parent manage the shared state, passing it down to the child components as needed. There are pros and cons to both approaches, but it’s important to be aware that both solutions exist.

### Insight #5: Inheritance is unnecessary in React, and both containment and specialization can be achieved with composition. ###

React has always been, for good reason, very liberal in adopting functional programming principles. One example of React’s move away from inheritance and towards composition was when its 0.13 release made it clear that React wasn’t adding support for Mixins with ES6 classes.

The reason for this is that almost everything you can accomplish with Mixins (or inheritance), you can also accomplish it through composition — but with fewer side effects.

If you’re coming to React from an inheritance heavy mindset, this new way of thinking may be difficult, and it may feel unnatural. Luckily there are some great resources to help. [Here’s one](https://www.youtube.com/watch?v=wfMtDGfHWpA) I enjoyed that isn’t React-specific.

### Insight #6: The separation of container and presentational components. ###

If you think about the anatomy of a React component, it usually involves some state, potentially some lifecycle hooks, and markup via JSX.

What if, instead of having all of that in one component, you could separate the state and the lifecycle hooks from the markup. This would leave you with two components. The first has state, life cycle methods, and is responsible for how the component works. The second receives data via props and is responsible for how the component looks.

This approach allows for better reusability of your presentational components, since they’re no longer coupled to the data they receive.

I’ve also found that it allows you (and newcomers to your project) to better understand the structure of your application. You’re able to swap out the implementation of a component without seeing or caring about the UI and vice versa. As a result, designers can tweak the UI without ever having to worry about how those presentational components are receiving data.

Check out [Presentational and Container Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.q9tui51xz) for more detail on this.

### Insight #7: If you try to keep most of your components pure, stateless things become a lot simpler to maintain. ###

This is another benefit of separating your presentational components from your container components.

State is the sidekick of inconsistency. By drawing the right lines of separation, you’re able to drastically improve the predictability of your application by encapsulating complexity.


Thanks for taking the time to read my article. [Follow me on Twitter](https://twitter.com/tylermcginnis33) and [check out my blog](https://tylermcginnis.com/react-aha-moments/) for more insights on JavaScript and React.
