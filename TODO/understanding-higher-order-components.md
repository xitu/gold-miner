> * 原文地址：[Understanding Higher Order Components](https://medium.freecodecamp.com/understanding-higher-order-components-6ce359d761b)
> * 原文作者：[Tom Coleman](https://medium.freecodecamp.com/@tmeasday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Haichao Jiang](https://github.com/AceLeeWinnie)
> * 校对者：[sun](https://github.com/sunui), [xilihuasi](https://github.com/xilihuasi)

---

# 高阶函数一点通

## **理解快速变化的 React 最佳实践**

[![](https://cdn-images-1.medium.com/max/1000/1*w4MV4Ufnk2WWY4LgX9ZhPA.jpeg)](http://jamesturrell.com/work/type/skyspace/)


如果你刚开始接触 React，你可能已经听说过 “高阶组件” 和 “容器” 组件。你也许会奇怪这都什么鬼东西。或者你已经开始使用库提供的 API 了，但对于这些个术语还有些疑惑。


作为 [Apollo 的 React 集成](http://dev.apollodata.com/react/) - 一个重度使用高阶组件的热门开源库 - 的维护者和文档作者，我花了些时间来理清这些概念。 


我希望这篇文章能够帮你对这一主题有更进一步的了解。

## **重识 React**

本文假定你已对 React 有一定的了解 - 如果没有的话有很多资料可供查阅。例如 Sacha Greif 的 [React 5 大概念](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3) 就是很好的入门文章。但是，让我们再回顾一下然后继续我们的文章。

一个 React 应用包含一系列 **组件**。组件中会传递一组输入属性（**props**），并且输出屏幕渲染的 HTML 片段。当一个组件的 props 更新时，会触发组件重绘，HTML 也会相应变化。

当用户通过一种事件（例如鼠标点击）与 HTML 进行交互时，组件处理事件要么通过触发 **回调** prop，要么通过更新内部 state。更新内部 state 也会造成组件自身及其子组件的重绘。

这里就不得不提组件 **生命周期**，即组件首次渲染，绑定 DOM，传递新 props 等。

组件的渲染函数返回一个或多个其他组件的实例。合成 **视图树** 是一个好的思维模型，能够表明应用内的组件是如何交互的。通常，组件交互是通过传递 props 给子组件实现的，或者通过触发父组件传递来的回调函数实现。

![](https://cdn-images-1.medium.com/max/800/1*NS6TPKPJuCgsK2M45tPIGw.gif)

React 视图树中的数据流

### **React UI vs 无状态**

似乎现在已经过时，但曾经一切都区分为 Model，View 和 Controller（或者 View Model，或者 Presenter）来描述。在这种分类方式，View 的任务就是 **渲染** 并且处理用户交互，Controller 的任务则是 **准备数据**。

React 最近的趋势是实现 **无状态函数组件**。这些简单的“纯”组件只根据自身的 props 转换成 HTML 和调用回调 props 来响应用户交互：

![](https://ws3.sinaimg.cn/large/006tNc79gy1fg9il3qk1uj314o0e0q4d.jpg)

他们是函数式的，你甚至可以就把他们当做函数。如果你的视图树包含“纯”组件，你可以把整棵树看成一个由许多小函数组成的输出 HTML 的大型函数。

无状态函数式组件有个很好的特点是极容易测试，并且易于理解。即易于开发和快速 debug。

但是你不能一直逃避的是，UI 需要状态。比如，当用户滑过菜单时，要自动打开（我希望是不要啦！）- 在 React 是利用 state 来实现的。要用 state，你就要用基于 class 的组件。

把 UI 的 “全局 state” 引入视图树就是事情复杂的开始。

### 全局 State

UI 的 全局 state 不能直接独立和某个独立组件相联系。典型地，这一般包含了两类事情：

1. 应用的 **数据** 从 server 来。通常，数据用于多处，所以并不唯一关联某个组件。

2. **全局 UI state**，（像 URL，决定了用户浏览的页面路径）。

安置全局 state 的一个方法是应用内绑定最高层的 “根” 组件，并且下发到各个需要它的子组件中去。然后 state 的改变再通过一连串的回调反馈到顶层。

![](https://cdn-images-1.medium.com/max/800/1*-RDYOXCu7BBOTnkFsE3yFg.gif)

单容器从 store 到视图树的数据流。

这一方法即使快但很笨拙。根组件需要理解全树的需求，每个子树的父组件同样需要理解每个子树的需求。此时引入另一个概念。

### **容器和展示类组件**

这个问题通常通过允许任何层级组件都能获取全局 state 的方式来解决（要求有一些限制）。

在 React 的世界里，组件可以分为能拿到全局 state 的和不能拿到的。

“纯”组件易于测试和理解（尤其是无状态函数式组件）。一旦一个组件是“不纯”的，它就被污染了，并且很难处理。

因此，出现了一个 [pattern](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) 把“不纯”的组件拆分成 **两个** 组件：

- **容器** 组件操作“脏”全局 state
- **展示** 组件相反

我们只要像对待上面的一般组件一样对待展示类组件，但把脏的和复杂数据操作类的工作独立到容器组件里。

![](https://cdn-images-1.medium.com/max/800/1*tIdBW-TqotpALD3b2xk3SA.gif)

多容器的数据流

### 容器

一旦你开始区分展示类/容器类组件，编写容器组件会变得有趣。

有件事要注意的是容器类组件有时候不像个组件。它们可能：

- 获取并传递一个全局 state（可以是 Redux）片段到子组件。
- 运行一个数据访问（可以是 GraphQL）请求，然后把结果传给子组件。

当然，如果我们遵循好的拆分原则，容器 **只挂载单个子组件**。容器和子组件强绑定，因为子组件天生在 render 方法里。不是么？

### 容器归纳

对于容器组件的 **众多类型** 来说（例如，某个容器组件访问的是 Redux store），实现基本相同，不同在于细节：渲染的子组件的不同，获取数据的不同。

举个栗子，在 Redux 的世界里，容器可能是这样的：

![](https://ws2.sinaimg.cn/large/006tNc79gy1fg9ilyq3foj314q0owwhi.jpg)

虽然这个容器很多功能不像真的 Redux 容器，你可以看到除了 `mapStateToProps` 的实现和我们包装的特定 `MyComponent`，**每次写访问 Redux 的容器**，我们还要写很多模板代码。

### 生成容器

事实上，写一个自动 **生成** 容器组件的方法会更容易，这个方法基于相关信息（此例中是子组件和 `mapStateToProps` 函数）。

![](https://ws3.sinaimg.cn/large/006tNc79gy1fg9imav510j314m0ikq51.jpg)

这是一个 **高阶组件**（HOC），是以子组件和其他选项作为参数，为该子组件构造容器的函数。

“高阶”即“高阶函数” - 构造函数的函数，事实上，可以认为 React 组件是产出 UI 的组件。尤其在无状态函数式组件中，这一方法尤其实用，但是仔细想想，它在纯状态展示组件中也同样实用。HOC 其实就是高阶函数。

### **HOC 例子**

这里有些值得一看的例子：

- 最普遍的可能是 [Redux](http://redux.js.org) 的 `connect` 函数了，上述的 `buildReduxContainer` 函数就是一个简陋版 `connect` 函数。
- [React Router](https://github.com/ReactTraining/react-router) 的 `withRouter` 函数，它从上下文中抓取路由并作为 props 传入子组件。
- `[react-apollo](http://dev.apollodata.com/react/)` 主要的接口就是 `graphql` HOC，给定一个组件和一个 GraphQL 请求，即为子组件提供请求的返回结果。
- [Recompose](https://github.com/acdlite/recompose) 是一个全是 HOC 的库，它能执行一系列任何你想从组件中抽取出来的不同的子任务。

### 自定义 HOC

应该为你的应用编写新的 HOC 吗？当然了，如果你有组件的模板要生成的话更应该这么做。

> 以上简单分享了有用的库和简单的组成方式，HOC 是 React 组件中共享行为的最佳方式。

编写 HOC 是一个函数返回类的简单方法，像我们在上面看到的 `buildReduxContainer` 方法。如果你想了解通过构建 HOC 你能做些什么，我建议你阅读 Fran Guijarro 关于这一主题的 [极度全面的博客](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e#.pvnx42kku)。

### 结论

高阶组件在本质上是一种以 **函数式** 的方式分离组件中的关注点的编码方式。React 早期版本用 class 和 mixin 来重用代码，但所有迹象表明更函数式的方法才是 React 的未来。

如果当你听说函数式编程技术时呆住了，不要紧！React 团队致力于简化这些方法，让我们所有人都能写出模块化，组件化的 UI。

如果你想获取更多关于构建现代、组件化应用的信息，查阅我在 [Chroma](https://www.hichroma.com) 上的 [系列博客](https://blog.hichroma.com/ui-components/home)。如果你喜欢这篇文章，请点赞💚 并分享出去哦~

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
