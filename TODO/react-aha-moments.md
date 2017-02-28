> * 原文地址：[React “Aha” Moments](https://medium.freecodecamp.com/react-aha-moments-4b92bd36cc4e#.jxiocbkv5)
* 原文作者：[Tyler McGinnis](https://medium.freecodecamp.com/@tylermcginnis?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [aleen42](https://github.com/aleen42)
* 校对者：[Tina92](https://github.com/Tina92)、[sqrthree](https://github.com/sqrthree)

# React 中“灵光乍现”的那些瞬息

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*6nyVYm78oKNBrvd8.jpg">

作为一名教师，我的主要目标之一就是要去让学生能遇到更多这种“灵光乍现”的瞬息。

所谓[“灵光乍现”的瞬息](https://en.wikipedia.org/wiki/Eureka_effect)，指的就是一个人突然洞悉或阐明某事物的那一瞬间。而正是那一刻，使得该人明白了很多事情。当然，我们每个人都会有所体验。而在我看来，最优秀的教师就是能因人施教，以使得学生能遇到更多的“灵光乍现”。

在过去几年，我曾采用过各种流行的教学方法去施教 React。在整个过程中，尤其是对于学习 React 的过程，我都记录了一些会遇到“灵光乍现”的情况。

而大概就在两周前，我竟偶然地发现到[这则 Reddit](https://www.reddit.com/r/reactjs/comments/5gmywc/what_were_the_biggest_aha_moments_you_had_while/)与我的想法如出一辙，并致使我写下了该篇文章。文章中不仅记录了我所发现的这些瞬息，而且还转载有这则 Reddit 中分享的其他瞬息。因而希望能帮助学习者以新的方式去了解 React 的概念。

### 瞬息 #1：Props 之于组件（Components）正如参数之于函数。 ###

React 的其中一个妙处在于，你可以通过自身对 JavaScript 函数的直观性感受来确定何时何地应该去创建一个 React 组件。但不同之处在于，函数要接受一些参数并返回一个确切的值，而组件则是接受一些参数并返回一个用于绘制 UI 界面的对象存储结构。

总的来说，可以概括为这样的一个公式：`fn(d) = V`。即可理解为：“一个函数会接受一些数据作为参数并返回一个视图。”

就开发 UI 而言，这的确是一种漂亮的思考方式。因为，如今你的 UI 仅仅是由不同的函数调用所构成。而这难道不是你构建应用时早已司空见惯的一种方法吗？换而言之，从此你就可以利用上所有关于函数组合的优势去构建 UI。

### 瞬息 #2：既然，在 React 中整个应用的 UI 都是可以使用函数组合来进行构建。那么，JSX 则是这些函数上的一种抽象。 ###

每当我回顾第一次使用 React 时，脑海里总会涌现出同样的一个反应：“即便 React 看起来好酷，但我一点都不喜欢 JSX。这是因为它破坏了我的关注点分离（Separation of Concerns）。”

在我看来，JSX 的原意并非想尝试成为 HTML，而更多时候它仅仅是被定义成一种模板语言来使用。

因而，关于 JSX 我们有两个重点需要了解的是：

首先，[JSX 是在函数 *React.createElement* 上的一层抽象](https://tylermcginnis.com/react-elements-vs-react-components/)，而该函数会返回 DOM 结构的一个对象存储结构。

即便是啰嗦，我也要说一句，“每当我们写 JSX 时，都会发现一旦 JSX 被转译，则会生成一个 JavaScript 对象用于表示真正的 DOM 结构或任何平台（iOS、Android 等）上的视图。然后，React 就会分析该对象与真正的 DOM 结构之间的差异，并以此来更新产生变化的那一部分 DOM 结构。”

这样做虽然会产生部分的性能问题，但更为重要的是它能彰显出一点：JSX 的的确确“只是 JavaScript”。

其次，既然 JSX 仅仅就是 JavaScript，那么你就可以运用上 JavaScript 的任何一切优势，如程序的编写、约束及调试。此外，你还可以利用上 HTML 的声明特性（以及关联点）。

### 瞬息 #3：组件与 DOM 节点并非相当。 ###

当你首次学习 React 时，总会被教到那么一点，“组件是 React 的积木。它们可被用于输入，并返回部分的 UI（描述符模式，the Descriptor Pattern）”

可是，难道这就意味着每一个组件都需要直接返回一个 UI 描述符吗？倘若我想使用一个组件去渲染另一个组件（高阶组件模式，the Higher Order Component Pattern）？或我想使用组件去管理一小部分的 State，并返回一个传递于 State 中的函数调用，而非 UI 描述符（渲染 Props 模式，the Render Props Pattern）？亦或者曾用于负责管理音频，而非可视化 UI 的组件，它们会返回什么？

React 其中的一个优点就在于组件并非**要**返回一个标准的“视图”。只要它能返回 React 元素、null 或 false 这三者之一，就不会有任何的问题。

你可以返回其他的组件：

```
render () {
  return <MyOtherComponent />
}
```

也可以返回函数调用：

```
render () {
  return this.props.children(this.someImportantState)
}
```

或返回空也可以：

```
render () {
  return null
}
```

关于该原则的进一步探究，我推荐阅读 Ryan Florence 所制作的[关于 React Rally 的讨论](https://www.youtube.com/watch?v=kp-NOggyz54)。

### 瞬息 #4：当两个组件需要共享 State 时，抽取该值而并非尝试去进行同步。 ###

一个以组件为基础的框架结构本来就难于在组件间分享 State。可如果两个组件同时依赖于同一个 State，那么该 State 应存放在哪呢？

关于解决方案的争夺热火朝天，乃至于刺激着整个生态系统，并最终以 Redux 的出现而结束。

Redux 所提出的办法是把共享的 State 存放在另一个名为 “Store” 的地方。然后，由组件来向该 Store 订阅它们所需要的任何数据，及发出 “Action” 去进行数据的更新。

而 React 本身的解决办法是寻找所有这些组件的最近父组件，并让该父组件来管理共享的 State。然后，再把其传递给所需的子组件。尽管两种方案各有优劣之处，但重要的是我们能意识到它俩的存在。

### 瞬息 #5：React 中继承（Inheritance）并非必要，因为通过组合（Composition）就可以完成组件的包裹（Containment）和特化（Specialization）。 ###

我们有理由相信，React 对采用函数式编程的原则总是抱有阔达的态度。关于 React 从继承走向组合的例子是其 0.13 版本的发行，这就使得我们更为清晰地发现， React 过去所做的并非是为 ES6 类（Class）下定义的 Mixins 提供支持。

原因在于，任何几乎能使用 Mixins（或继承）完成的事情，都可以通过组合完成，即便这会产生些许的副作用。

但若你在接触 React 时，本来就是一个看重继承方式的开发者，那么要接受这样的新思想也许是件难事，并感到不适。但幸运的是，一些资源可以帮到你克服困难，而其中[就有一个](https://www.youtube.com/watch?v=wfMtDGfHWpA)并非针对于 React 本身。

### 瞬息 #6：容器组件（Container Component）与描述型组件（Presentational Component）的分离

如果你在思考一个 React 组件的骨骼时，它通常会涉及有若干个 State、潜在的生命周期方法以及使用 JSX 语法书写的标记语言。

但倘若可以把 State 和生命周期方法从一个组件的标记语言中分离出来，而非全部整合在一块呢？也就是说，你需要两个组件来进行分离。第一个组件含有 State 与生命周期方法，并负责组件的工作，而第二个组件则通过 Props 来接受数据，并负责组件的渲染。

既然这样的方法能使得描述型组件不再耦合于所接受的数据，那么开发者也就能更好地复用它们。

而且，我还发现了一点。这样的新方法还能使开发者更好地去了解应用本身的结构，且能随时替换掉组件的实现而无须担心 UI 的改变，反之亦然。这样一来，设计师也就能随意地扭捏 UI，而无须操心那些描述型组件所接受数据的方式。

更多详情请查看《[描述型组件与容器组件](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.q9tui51xz)》。

### 瞬息 #7：若你想保持大部分组件的纯净，无 State 组件会更为容易地去维护。 ###

这是分离描述型组件与容器组件的另一大优势。

在我看来，State 本来就是组件中不一致性的帮凶。通过划定清晰的分离界线，我们就可以通过封装复杂的组件来大幅度地提高应用的可预测性（Predictability）。

最后，感谢您花时间去阅读我的文章。恳请大家关注一下我的 [Twitter](https://twitter.com/tylermcginnis33)，并[查看我博客中](https://tylermcginnis.com/react-aha-moments/)与 JavaScript 和 React 相关的一些文章。
