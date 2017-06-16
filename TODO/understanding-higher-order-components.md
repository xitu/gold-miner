> * 原文地址：[Understanding Higher Order Components](https://medium.freecodecamp.com/understanding-higher-order-components-6ce359d761b)
> * 原文作者：[Tom Coleman](https://medium.freecodecamp.com/@tmeasday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Haichao Jiang](https://github.com/AceLeeWinnie)
> * 校对者：

---

# Understanding Higher Order Components
# 高阶函数一点通

## *Making sense of the rapidly changing React best practice.*
## **快速转变成 React 最佳实践的意义**

[![](https://cdn-images-1.medium.com/max/1000/1*w4MV4Ufnk2WWY4LgX9ZhPA.jpeg)](http://jamesturrell.com/work/type/skyspace/)

If you’re new to React, you may have heard about “Higher Order Components” and “Container” components. If so, you may be wondering what all the fuss is about. Or you may have even used an API for a library that provides one, and been a little confused about the terminology.

如果你刚开始接触 React，你可能已经听说过 “高阶组件” 和 “容器” 组件。你也许会奇怪这都什么鬼东西。或者你已经开始使用库提供的 API 了，但对于这些个术语还有些疑惑。

As a maintainer of [Apollo’s React integration](http://dev.apollodata.com/react/) — a popular open source library that makes heavy use of High Order Components — and the author of much of its documentation, I’ve spent a bit of time getting my head around the concept myself.

作为 [Apollo 的 React 集成](http://dev.apollodata.com/react/) - 那是一个重度使用高阶组件的热门开源库 - 的维护者和文档组着，我花了些时间来理清这些概念。 

I hope this post can help shed some light on the subject for you too.

我希望这篇文章能够帮你对这一主题有更进一步的了解。

### **A React re-primer**

## **重识 React**

This post assumes that you are familiar with React — if not there’s a lot of great content out there. For instance Sacha Greif’s [5 React Concepts post](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3) is a good place to start. Still, let’s just go over a couple of things to get our story straight.

假定你已对 React 有一定的了解 - 如果没有的话有很多资料可供查阅。例如 Sacha Greif 的 [React 5 大概念系列](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3) 都是入门级材料。但是，让我们再回顾一下然后继续我们的故事。

A React Application consists of a set of **components**. A component is passed a set of input properties (**props**) and produces some HTML which is rendered to the screen. When the component’s props change, it re-renders and the HTML may change.

一个 React 应用包含一系列 **组件**。组件中会传递一组输入属性（**props**），并且输出屏幕渲染的 HTML 片段。当一个组件的 props 更新时，会触发组件重绘，HTML 也会相应变化。

When the user of the application interacts with that HTML, via some kind of event (such as a mouse click), the component handles it either by triggering a **callback** prop, or changing some internal **state**. Changing internal state also causes it and its children to re-render.

当用户通过一组事件（例如鼠标点击）与 HTML 进行交互时，组件处理事件要么通过触发 **回调** prop，要么通过更新内部 state。更新内部 state 也会造成组件自身及其子组件的重绘。

This leads to a component **lifecycle**, as a component is rendered for the first time, attached to the DOM, passed new props, etc.

这里就不得不提组件 **生命周期**，即组件首次渲染，绑定 DOM，传递新 props 等。

A component’s render function returns one or instances of other components. The resultant **view tree** is a good mental model to keep in mind for how the components of the app interact. In general they interact only by passing props to their children or triggering callbacks passed by their parents.

组件的渲染函数返回一个或多个其他组件的实例。合成 **视图树** 是一个好的思维模型，能够表明应用内的组件是如何交互的。通常，组件交互是通过传递 props 给子组件实现的，或者通过触发父组件传递来的回调函数实现。

![](https://cdn-images-1.medium.com/max/800/1*NS6TPKPJuCgsK2M45tPIGw.gif)

Data flow in a React view tree

React 视图树中的数据流

### **React UI vs statefulness**

### **React UI vs 无状态**

It seems almost dated now, but there was a time where everything was described in terms of the distinction between Models, Views and Controllers (or View Models, or Presenters, etc). In this classification, a View’s task is to **render **and deal with user interaction, and a Controller’s is to **prepare data**.

似乎现在已经过时，但曾经一切都区分为 Model，View 和 Controllers（或者 View Model，或者 Presenter）来描述。在这一经典案例中，视图的任务就是 **渲染** 并且处理用户交互，控制器的任务则是 **准备数据**。

A recent trend in React is towards **functional stateless components**. These simplest “pure” components only ever transform their props into HTML and call callback props on user interaction:

React 最近的趋势是实现 **无状态函数组件**。这些简单的 “纯” 组件只根据自身的 props 转换成 HTML 和调用回调 props 来相应用户交互：

![](https://ws3.sinaimg.cn/large/006tNc79gy1fg9il3qk1uj314o0e0q4d.jpg)

They are functional because you can really think of them as functions. If your entirely view tree consisted of them you are really talking about one big function to produce HTML composed of calls to many smaller ones.

他们是函数式的，你甚至可以就把他们当做函数。如果你的视图树包含 “纯” 组件，你可以把整棵树堪称一个由许多小函数组成的输出 HTML 的大型函数。

A nice property of functional stateless components is that they are super-easy to test, and simple to understand. This means they are easier to develop and quicker to debug.

无状态函数式组件中，一个很好的特点是极容易测试，并且易于理解。即易于开发和快速 debug。

But you can’t always get away with this. UI does need state. For instance, your menu may need to open when the user hovers over it (ugh, I hope not!)—and the way to do this in React is certainly by using state. To use state, you use class-based components.

但是你不能一直逃避的是，UI 需要状态。比如，当用户滑过菜单时，要自动打开（我希望是不要啦！）- 在 React 是利用 state 来实现的。要用 state，你就要用基于 class 的组件。

Where things get complicated is wiring the “global state” of your UI into the view tree.

把 UI 的 “全局 state” 引入视图树就是事情复杂的开始。

### Global State

### 全局 State

Global state in your UI is the state that isn’t directly and uniquely relevant to a single component. It typically consists of two main types of things:

UI 的 全局 state 不能直接和唯一和某个独立组件相联系。典型地，这包含了两个内容：

1. The **data** in your application that has come from some server. Typically the data is used in multiple places and so is not unique to a single component.

1. 应用的 **数据** 只能从 server 来。通常，数据用于多处，所以并不唯一关联某个独立组件。

2. **Global UI state**, (like the URL, and thus which page the user is looking at).

2. **全局 UI state**，（像 URL，决定了用户浏览的页面路径）。

One approach to global state is to attach it to the highest “root” component in your app and pass it down the tree to all the components that need it. You then pass all changes to that state back up the tree via a chain of callbacks.

安置全局 state 的一个方法是应用内绑定最高层的 “根” 组件，并且下发到各个需要它的子组件中去。然后 state 的改变再通过一连串的回调反馈到顶层。

![](https://cdn-images-1.medium.com/max/800/1*-RDYOXCu7BBOTnkFsE3yFg.gif)

Data flow from the store into a view tree, with a single container

单容器从 store 到 视图树的数据流。

This approach gets unwieldy pretty quickly, though. It means the root component needs to understand the requirements of it’s entire tree, and likewise for every parent of every subtree in the entire tree. That’s where this next concept comes in.

这一方法不实用但很快。根组件需要理解全树的需求，每个子树的父组件同样需要理解每个子树的需求。此时引入另一个概念。

### **Containers and Presentational Components**

### **容器和展示类组件**

This problem is typically solved by allowing components to access global state anywhere in the view tree (some restraint is typically called for).

这个问题通常通过允许任何层级组件都能获取全局 state 的方式来解决（要求有一些限制）。

In this world, components can be classified into those that access the global state, and those that don’t.

在 React 的世界里，组件可以分为能拿到全局 state 的和不能拿到的。

The “pure” components that do not are the easiest to test and understand (especially if they are functional stateless components). A soon as a component is “impure” it’s tainted and harder to deal with.

“纯” 组件易于测试和理解（尤其是无状态函数式组件）。一旦一个组件是 “不纯” 的，它就被污染了，并且很难处理。【译者：555...】

For this reason, [a pattern](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) has emerged to separate each “impure” component into **two** components:

因此，需要一个 [pattern](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) 把 “不纯” 的组件拆分成 **两个** 组件：

- The **container** component that does the “dirty” global state work
- The **presentational** component that does not.

- **容器** 组件操作 “脏” 全局 state
- **展示** 组件相反

We can now treat the presentational component just like we treated our simple components above, and isolate the dirty, complex data handling work in the container.

我们只要像对待上面的一般组件一样对待展示类组件，但把脏的和复杂数据操作类的工作独立到容器组件里。

![](https://cdn-images-1.medium.com/max/800/1*tIdBW-TqotpALD3b2xk3SA.gif)

Data flow with multiple containers

多容器的数据流

### The container

### 容器

Once you’re on board with the presentational/container component split, writing container components becomes interesting.

一旦你开始区分 展示类/容器类 组件，编写容器组件会变得有趣。

One thing you notice is they often don’t look a lot like a component at all. They might:

有件事要注意的是容器类组件有时候不像个组件。它们可能：

- Fetch and pass one piece of global state (say from Redux) into their child.
- Run one data-accessing (say GraphGL) query and pass the results into their child.

- 获取并传递一个全局 state 片段（可以是 Redux）到子组件。
- 运行一个数据访问（可以是 GraphQL）请求，然后把结果传给子组件。

Also, if we follow a good separation of concerns, our containers will **only ever render a single child component**. The container is necessarily tied to the child, because the child is hardwired in the render function. Or is it?

当然，如果我们遵循好的拆分原则，容器 **只挂载单个子组件**。容器和子组件强绑定，因为子组件天生在 render 方法里。不是么？

### Generalizing containers

### 容器归纳

For any “type” of container component (for instance one that access Redux’s store), the implementation looks the same, differing only in the details: which child component they render, and what exact data they are fetching.

对于容器组件的 **众多类型** 来说（例如，某个容器组件访问的是 Redux store），实现基本相同，不同在于细节：渲染的子组件的不同，获取数据的不同。

For example, in the world of Redux, a container might look like:

举个栗子，在 Redux 的世界里，容器可能是这样的：

![](https://ws2.sinaimg.cn/large/006tNc79gy1fg9ilyq3foj314q0owwhi.jpg)

Even though this container doesn’t do most of what a true Redux container would do, you can already see that apart from the implementation of `mapStateToProps` and the specific `MyComponent` that we are wrapping, there is a lot of boilerplate that we would have to write **every single time we write a Redux-accessing container**.

虽然这个容器很多功能不像真的 Redux 容器，但已经注意到除了 `mapStateToProps` 和具体 `MyComponent` 的内容，**每次写访问 Redux 的容器**，我们还要写很多模板代码。

### Generating Containers

### 生成容器

In fact, it might be simpler just to write a function that **generates** the container component based on the pertinent information (in this case the child component and the `mapStateToProps` function).

事实上，写一个自动 **生成** 容器组件的方法会更容易，这个方法基于相关信息（此例中是子组件和 `mapStateToProps` 函数）。

![](https://ws3.sinaimg.cn/large/006tNc79gy1fg9imav510j314m0ikq51.jpg)

This is a **Higher Order Component** (HOC), which is a **function** that takes a child component and some options, then builds a container for that child.

这是一个 **高阶组件**（HOC），是以子组件和其他选项作为参数，为该子组件构造容器的函数。

It’s “higher order” in the same way as a “higher order function” — a function that builds a function. In fact you can think of React Components as functions that produce UI. This works especially well for functional stateless components, but if you squint, it works for pure stateful presentational components as well. A HOC is exactly a higher order function.

“高阶” 即 “高阶方法” - 构造函数的函数，事实上，可以认为 React 组件是产出 UI 的组件。尤其在无状态函数式组件中，这一方法尤其实用，但是仔细想想，它在纯状态展示组件中也同样实用。HOC 其实就是高阶组件。

### **Examples of HOCs**

### **HOC 例子**

There are many, but some notable ones:

这里有些值得一看的例子：

- The most common is probably [Redux’s](http://redux.js.org)`connect` function, which our `buildReduxContainer` function above is just a shabby version of.
- [React Router’s](https://github.com/ReactTraining/react-router)`withRouter` function which simply grabs the router off the context and makes it a prop for the child.
- `[react-apollo](http://dev.apollodata.com/react/)`'s main interface is the `graphql` HOC, which, given a component and a GraphQL query, provides the results of that query to the child.
- [Recompose](https://github.com/acdlite/recompose) is a library that’s full of HOCs that do a variety of small tasks you may want to abstract away from your components.

- 最普遍的可能是 [Redux](http://redux.js.org) 的 `connect` 函数了，上述的 `buildReduxContainer` 函数就是一个简陋版 `connect` 函数。
- [React Router](https://github.com/ReactTraining/react-router) 的 `withRouter` 函数，它从上下文中抓取路由并作为 props 传入子组件。
- `[react-apollo](http://dev.apollodata.com/react/)` 主要的接口就是 `graphql` HOC，给定一个组件和一个 GraphQL 请求，即为子组件提供请求的返回结果。
- [Recompose](https://github.com/acdlite/recompose) 是一个全是 HOC 的库，它能执行一系列任何你想从组件中抽取出来的不同的子任务。

### **Custom HOCs**

### 自定义 HOC

Should you write new HOCs in your app? Sure, if you have component patterns that could be generalized.

应该为你的应用编写新的 HOC 吗？当然了，如果你有组件的模板要生成的话更应该这么做。

> Beyond simply sharing utility libraries and simple composition, HOCs are the best way to share behavior between React Components.

> 以上简单分享了有用的库和简单的组成方式，HOC 是 React 组件中共享行为的最佳方式。

Writing a HOC is a simple as a function that returns a Class, like we saw with our `buildReduxContainer` function above. If you want to read more about what you can do when you build HOCs, I suggest you read Fran Guijarro’s [extremely comprehensive post](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e#.pvnx42kku) on the subject.

编写 HOC 是一个函数返回类的简单方法，像我们在上面看到的 `buildReduxContainer` 方法。如果你想了解通过构建 HOC 你能做些什么，我建议你阅读 Fran Guijarro 在这一主题的 [极度全面的博客](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e#.pvnx42kku)。

### Conclusion

### 结论

Higher order components are at heart a codification of a separation of concerns in components in a **functional** way. Early versions of React used classes and mixins to achieve code reuse, but all signs point to this more functional approach driving the future design of React.

高阶组件在本质上是一种以函数式的方式分离组件中的关注点的编码方式。React 早起版本用 class 和 mixin 来重用代码，但所有迹象表明更函数式的方法才是 React 的未来。

If your eyes typically glaze over when you hear about functional programming techniques, don’t worry! The React team has done a great job of taking the best simplifying parts of these approaches to lead us all toward writing more modular, componetized UIs.

如果当你听说函数式编程技术时呆住了，不要紧！React 团队致力于简化这些方法，让我们所有人都能写出模块化，组件化的 UI。

If you want to learn more about building applications in a modern, component-oriented fashion, check my [series of posts](https://blog.hichroma.com/ui-components/home) at [Chroma](https://www.hichroma.com), and if you like this article, please consider 💚ing and sharing it!

如果你想获取更多关于构建现代、组件化应用的信息，查阅我在 [Chroma](https://www.hichroma.com) 上的 [系列博客](https://blog.hichroma.com/ui-components/home)。如果你喜欢这篇文章，请点赞💚 并分享出去哦~

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
