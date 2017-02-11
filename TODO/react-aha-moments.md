> * 原文地址：[React “Aha” Moments](https://medium.freecodecamp.com/react-aha-moments-4b92bd36cc4e#.jxiocbkv5)
* 原文作者：[Tyler McGinnis](https://medium.freecodecamp.com/@tylermcginnis?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# React “Aha” Moments #

# React 中“灵光乍现”的那些瞬息

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*6nyVYm78oKNBrvd8.jpg">

As a teacher, one of my main goals is to maximize people’s “aha” moments.

作为一名教师，我最主要的一个目标是去让学生能遇到更多“灵光乍现”的那一瞬息。

An [“aha” moment](https://en.wikipedia.org/wiki/Eureka_effect)  is a moment of sudden insight or clarity, where the subject starts to makes a lot more sense. We’ve all experienced these. And the best teachers I know are able to understand their audience and adapt the lesson in order to maximize these moments.

所谓[“灵光乍现”的一瞬息](https://en.wikipedia.org/wiki/Eureka_effect)，指的就是一个人突然洞悉或阐明某事物的那一瞬间。而正正是这样的一刹那时间，却对事物产生了莫大的意义。当然，我们每个人都会有遇到过那么一刹那的时候，而在我看来，最优秀的教师是能因人施教，以使得学生遇到更多这样的瞬间。

Over the past few years, I’ve taught React through just about every popular medium. The entire time, I’ve taken detailed notes on what triggers these “aha” moments, specifically for learning React.

在过去几年，我曾采用过各种流行的教学方法去施教 React。在整个过程中，尤其是对于学习 React 的过程，我都记录了一些会触发“灵光乍现”的时机。

About two weeks ago, I came across [this Reddit thread](https://www.reddit.com/r/reactjs/comments/5gmywc/what_were_the_biggest_aha_moments_you_had_while/) , which had the same idea. It inspired me to write this article, which is my collection of these moments and reflections on other moments shared in that Reddit thread. My hope is that this will will help React concepts click for you in new ways.

大概两周前，我偶然地发现到[这则 Reddit](https://www.reddit.com/r/reactjs/comments/5gmywc/what_were_the_biggest_aha_moments_you_had_while/)与我的想法如出一辙，并致使我写下了该篇文章。文章中不仅记录了我所发现的一些瞬息，而且还转载有这则 Reddit 所分享的其他瞬息。

### Insight #1: Props are to components what arguments are to functions. ###

### 瞬息 #1：Props 之于组件（Components）正如参数之于函数。 ###

One of the best parts of React is that you can take that same intuition you have about JavaScript functions, then use it to determine when and where you should create React components. But with React, instead of taking in some arguments and returning a value, your function will take in some arguments and return an object representation of your User Interface (UI).

React 的其中一个妙处在于，你可以通过自身对 JavaScript 函数的一种直观性来确定何时何地才应该创建一个 React 组件。但不同之处在于，函数要接受部分参数，并返回关于 UI 的一个对象存储结构，而非一个确切的值。

This idea can be summed up in the following formula: `fn(d) = V`, which can be read: “a function takes
in some data and returns a view.”

总的来说，可以概括为这样的一个公式：`fn(d) = V`。即可理解为：“一个函数会接受部分的数据并返回一个视图。”

This is a beautiful way to think about developing user interfaces because now your UI is just composed of different function invocations. This is how you’re already used to building applications. And now you can take advantage of all of the benefits of function composition when building UIs.

就开发 UI 而言，这的确是一种漂亮的思考方式。因为，如今你的 UI 仅仅是由不同的函数调用所构成。而这难道不是你构建应用时早已司空见惯的一种方法吗？换而言之，我们就可以利用起所有关于组合函数的优势去构建我们的 UI。

### Insight #2: In React, your entire application’s UI is built using function composition. JSX is an abstraction over those functions. ###

### 瞬息 #2：既然，在 React 中整个应用的 UI 都是使用组合函数来构建的。那么，JSX 则是基于这些函数之上的一种抽象。 ###

The most common reaction I see from first timers using React goes something like: “React seems cool, but I really don’t like JSX. It breaks my separation of concerns.”

每当我回顾第一次使用 React，脑海里总会涌现出同样的一个反应：“即便 React 看起来好酷，但我一点都不喜欢 JSX。这是因为，它打破了我的分离关注点。”

JSX isn’t trying to be HTML. And it’s definitely more than just a templating language.

在我看来，JSX 的原意并非是去尝试成为 HTML 语言，而它更多时候仅仅是被定义成一种模板语言来使用。

There are two important things to understand with JSX.

因而，关于 JSX 我们有两重点需要注意的是：

First, [JSX is an abstraction over *React.createElement*](https://tylermcginnis.com/react-elements-vs-react-components/), which is a function that returns an object representation of the DOM.

首先，[JSX 是在函数 *React.createElement* 上的一层抽象](https://tylermcginnis.com/react-elements-vs-react-components/)，而该函数会返回一个 DOM 的对象存储结构。

I know that was wordy, but basically whenever you write JSX, once it’s transpiled, you’ll have a JavaScript object which represents the actual DOM — or whatever view is representative of the platform you’re on (iOS, Android, etc). Then React is able to analyze that object and analyze the actual DOM. Then by doing a diff, React can update the DOM only where a change occurred.

即便是啰嗦，我也要说一句，“每当写 JSX 时，一旦它被转译，就会产生用来表示真正 DOM 结构的一个 JavaScript 对象。无论是在哪个平台（iOS、Android 等）上的视图都会如此。然后，React 就会分析该对象与真正的 DOM 结构之间的差异，并以此来更新产生变化的那一部分 DOM。”

This has some performance upsides to it but more importantly shows that JSX really is “just JavaScript.”

虽然，这样做会产生部分的性能问题，但重点在于能显示出 JSX 的的确确“仅是 JavaScript”。

Second, because JSX is just JavaScript, you get all the benefits that JavaScript provides — such as composition, linting, and debugging. But you also still get with the declarativeness (and familiarity) of HTML.

第二点就是，既然 JSX 仅仅就是 JavaScript，那么你就可以运用上 JavaScript 的一切优势，如程序的编写、约束及调试。此外，你还可以利用上 HTML 的陈述性（以及通晓性）。

### Insight #3: Components don’t necessary have to correspond to DOM nodes. ###

### 瞬息 #3：组件并非一定要对应上 DOM 节点。 ###

When you first learn React you’re taught that “Components are the building blocks of React. They take in input and return some UI (the Descriptor Pattern).”

当你首次学习 React 时，总会被教到那么一点，“组件是 React 的积木，用于输入，并返回部分 UI（描述符模式，the Descriptor Pattern）”

Does that mean that every component needs to directly return UI descriptors as we’re typically taught? What if we wanted to have a component render another component (Higher Order Component pattern)? What if we wanted a component to manage some slice of state and then instead of returning a UI descriptor, it returns a function invocation passing in the state (Render Props pattern)? What if we had a component that was in charge of managing sound rather than a visual UI, what would it return?

难道这就意味着每一个组件都需要直接返回一个 UI 描述符吗？倘若我想使用一个组件去渲染另一个组件（高阶组件模式，the Higher Order Component Pattern）？或我想使用组件去管理一小部分的 State，并返回一个传递于 State 中的函数调用，而非 UI 描述符（渲染 Props 模式，the Render Props Pattern）？亦或者曾用于负责管理音频，而非可视化 UI 的组件，它会返回什么？

What’s great about React is you don’t **have** to return typical “views” from your components. As long as what eventually gets returned is a React element, null, or false, you’re good.

React 其中的一个优点就在于组件并非**要**返回一个标准的“视图”。只要它能返回 React 元素、null 或 false 这三者之一都不会有任何的问题。

You can return other components:

可以返回其他的组件：

```
render () {
  return <MyOtherComponent />
}
```

You can return function invocations:

也可以返回函数调用：

```
render () {
  return this.props.children(this.someImportantState)
}
```

Or you can return nothing at all:

或返回空也可以：

```
render () {
  return null
}
```

I really enjoyed Ryan Florence’s [React Rally talk](https://www.youtube.com/watch?v=kp-NOggyz54) where he covers this principle more in depth.

关于该原则的进一步探究，我推荐阅读 Ryan Florence 所制作的《[关于 React Rally 的讨论](https://www.youtube.com/watch?v=kp-NOggyz54)》。

### Insight #4: When two components need to share state, I need to lift that state up instead of trying to keep their states in sync. ###

### 瞬息 #4：当两个组件需要共享 State 时，我需要做的是抽取该值而并非尝试去同步两组件的 State。 ###

A component-based architecture naturally makes sharing state more difficult. If two components rely on the same state, where should that state live?

一个以组件为基础的结构自然上会使得 State 的分享变得更为困难。如果两个组件同时依赖于同一个 State，那么该 State 应存放于哪？

This was such a popular question that it spurred an entire ecosystem of solutions, which eventually ended with Redux.

关于该火热问题的解决方案争夺总在刺激着整个生态系统，并最终以 Redux 结束。

Redux’s solution is to put that shared state in another location called a “store.” Components can then subscribe to any portions of the store they need, and can also dispatch “actions” to update the store.

Redux 的解决办法是把共享的 State 存放在名为“Store”的另一个地方。然后，组件就能向该 Store 订阅它们所需要的任何东西，以及发出“Action”去更新该 Store。

React’s solution is to find the nearest parent of both of those components and have that parent manage the shared state, passing it down to the child components as needed. There are pros and cons to both approaches, but it’s important to be aware that both solutions exist.

而 React 本身的解决办法是寻找所有这些组件的最近父组件，并让该父组件来管理共享的 State，以把其传递给所需的子组件。尽管两种方案各有优劣之处，但重要的是我们能认清它们两的存在。

### Insight #5: Inheritance is unnecessary in React, and both containment and specialization can be achieved with composition. ###

### 瞬息 #5：React 中继承（Inheritance）并非绝对，因为通过组合（Composition）就可以完成组件的包裹（Containment）和特化（Specialization）。 ###

React has always been, for good reason, very liberal in adopting functional programming principles. One example of React’s move away from inheritance and towards composition was when its 0.13 release made it clear that React wasn’t adding support for Mixins with ES6 classes.

我们有理由相信，React 对采用函数式编程的原则总是抱有阔达的态度。其中关于 React 从继承走向组合的例子是其 0.13 版本的发行，使得我们更为清晰发现 React 过去所做的并非是为 ES6 类（Class）下定义的 Mixins 提供支持。

The reason for this is that almost everything you can accomplish with Mixins (or inheritance), you can also accomplish it through composition — but with fewer side effects.

原因在于，任何几乎能使用 Mixins （或继承）完成的事情，都可以通过组合完成，即便会产生些许的副作用。

If you’re coming to React from an inheritance heavy mindset, this new way of thinking may be difficult, and it may feel unnatural. Luckily there are some great resources to help. [Here’s one](https://www.youtube.com/watch?v=wfMtDGfHWpA) I enjoyed that isn’t React-specific.

若你在接触 React 时，本来就是一个看重继承方式的开发者，那么要接受这样的新思想也许是件难事，并感到不适。但幸运的是，部分的资源可以帮到你克服困难，而其中[就有一个](https://www.youtube.com/watch?v=wfMtDGfHWpA)并非针对 React 本身。

### Insight #6: The separation of container and presentational components. ###

### 瞬息 #6：容器组件（Container Component）与描述型组件（Presentational Component）的分离

If you think about the anatomy of a React component, it usually involves some state, potentially some lifecycle hooks, and markup via JSX.

如果你在思考一个 React 组件的骨骼时，它通常会涉及有若干个 State、潜在的生命周期方法以及使用 JSX 语法书写的标记语言。

What if, instead of having all of that in one component, you could separate the state and the lifecycle hooks from the markup. This would leave you with two components. The first has state, life cycle methods, and is responsible for how the component works. The second receives data via props and is responsible for how the component looks.

但倘若你能把 State 和生命周期方法从一个组件的标记语言中分离出来，而非全部整合在一块。也就是说，你需要两个组件来进行分离。第一个组件含有 State 与生命周期方法，并负责组件的工作，而第二个组件则通过 Props 接受数据，并负责组件的渲染。

This approach allows for better reusability of your presentational components, since they’re no longer coupled to the data they receive.

既然，这样的方法能使得描述型组件不再耦合于所接受的数据，那么，开发者也就能更好地复用它们。

I’ve also found that it allows you (and newcomers to your project) to better understand the structure of your application. You’re able to swap out the implementation of a component without seeing or caring about the UI and vice versa. As a result, designers can tweak the UI without ever having to worry about how those presentational components are receiving data.

而且，我还发现了一点。这样的新方法还能使开发者更好地去了解应用本身的结构，且能随时替换掉组件的实现而无须担心 UI 的改变，反之亦然。这样一来，设计师也就能随意地扭捏 UI，而无须操心那些描述型组件所接受数据的方式。

Check out [Presentational and Container Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.q9tui51xz) for more detail on this.

更多详情请查看《[描述型与容器组件](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.q9tui51xz)》。

### Insight #7: If you try to keep most of your components pure, stateless things become a lot simpler to maintain. ###

### 瞬息 #7：若你想保持大部分组件的纯净，无 State 会更为容易地去维护。 ###

This is another benefit of separating your presentational components from your container components.

这是分离描述型组件与容器组件的另一大优势。

State is the sidekick of inconsistency. By drawing the right lines of separation, you’re able to drastically improve the predictability of your application by encapsulating complexity.

在我看来，State 本来就是不一致性的帮凶。通过划定清晰的分离界线，我们就可以封装起复杂的实现以大幅度地提高应用的可预测性（Predictability）。

Thanks for taking the time to read my article. [Follow me on Twitter](https://twitter.com/tylermcginnis33) and [check out my blog](https://tylermcginnis.com/react-aha-moments/) for more insights on JavaScript and React.

感谢您花时间去阅读我的文章。恳请关注我的 [Twitter](https://twitter.com/tylermcginnis33)，并[查看我博客中](https://tylermcginnis.com/react-aha-moments/)与 JavaScript 和 React 相关的文章。
