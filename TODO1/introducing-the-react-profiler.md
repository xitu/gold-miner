> * 原文地址：[Introducing the React Profiler](https://reactjs.org/blog/2018/09/10/introducing-the-react-profiler.html)
> * 原文作者：[Brian Vaughn](https://github.com/bvaughn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-react-profiler.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-react-profiler.md)
> * 译者：[CoderMing](https://github.com/coderming)
> * 校对者：

# React Profiler 介绍

React 16.5 添加了对新的 profiler DevTools 插件的支持。 这个插件使用 React 的 [Profiler 实验性 API](https://github.com/reactjs/rfcs/pull/51) 去收集所有 component 的渲染时间，目的是为了找出你的 React App 的性能瓶颈。它将会和我们即将发布的 [时间片](https://reactjs.org/blog/2018/03/01/sneak-peek-beyond-react-16.html) 特性完全兼容。（译者注：可以参考 [Dan 在第一届中国 React 开发者大会上的视频](https://v.qq.com/x/page/i0763tiywrf.html)）

这片博文包括以下的话题：

*   [Profile 一个 APP](#Profile-一个-APP)
*   [查看性能数据](#查看性能数据)
  
    *   [浏览 commits](#浏览-commits)
    *   [筛选 commit](#筛选-commit)
    *   [火焰图](#火焰图)
    *   [排序图](#排序图)
    *   [Component 图](#Component-图)
    *   [交互动作 ( Interactions )](交互动作-( Interactions ))
*   [常见问题 & 解决方法](#常见问题-&-解决方法)
  
    *   [你所选择的根元素下没有 profile 数据被记录](#你所选择的根元素下没有-profile-数据被记录)
    *   [你所选中的 commit 记录没有展示时间数据](#你所选中的-commit-记录没有展示时间数据)

## Profile 一个 APP

DevTools 将会对支持新的  profiling API 的 APP新加一个 “Profiler” tab栏：

 [![New DevTools ](/static/devtools-profiler-tab-4da6b55fc3c98de04c261cd902c14dc3-acf85.png)](/static/devtools-profiler-tab-4da6b55fc3c98de04c261cd902c14dc3-53c76.png) 

> Note: `react-dom` 16.5+ 在 DEV 模式下才支持 Profiling， 同时生产环境下也可以通过一个 profiling bundle `react-dom/profiling`来支持。请在[fb.me/react-profiling](https://fb.me/react-profiling)上查看如何使用这个 bundle。
>

这个 “Profiler” 的界面在刚开始的时候是空的。 你可以点击 record 按钮来启动 profile：

[![Click ](https://reactjs.org/static/start-profiling-bae8d10e17f06eeb8c512c91c0153cff-acf85.png)](https://reactjs.org/static/start-profiling-bae8d10e17f06eeb8c512c91c0153cff-53c76.png) 

当你开始记录之后，DevTools 将会自动收集你 APP 在（启动之后）每一刻的性能数据。（在记录期间）你可以和平常一样使用你的 APP，当你完成 profile 之后，请点 “Stop” 按钮。

[![Click ](https://reactjs.org/static/stop-profiling-45619de03bed468869f7a0878f220586-acf85.png)](https://reactjs.org/static/stop-profiling-45619de03bed468869f7a0878f220586-53c76.png) 

如果你的 APP 在 profile 期间重新渲染了几次，DevTools 将会提供好几种方法去查看性能数据。我们将会 [在接下来讨论它们](#reading-performance-data)。

## 查看性能数据

### 浏览 commits

从概念上讲，React 的运行分为两个阶段：

*   在 **render** 阶段会确定例如 DOM之类的数据需要做那些变化。 在这个阶段，React 将会执行（各个组件的） `render` 方法，之后会计算出和调用 `render` 方法之前有哪些变化。
*   **commit** 阶段是 React 提交任何更改所在的阶段（在 React DOM 下，就是指 React 添加、修改和移除 DOM 节点的时候）。同时在这个阶段，React 会执行像 `componentDidMount` 和 `componentDidUpdate` 这类周期函数。

（译者注：此处可参考 [React.js 小书第18-20篇](http://huziketang.mangojuice.top/books/react/lesson18)）

profiler DevTools 是在 commit 阶段收集性能数据的。各次 commit 会被展示在界面顶部的条形图中：

[![Bar chart of profiled commits](https://reactjs.org/static/commit-selector-bd72dec045515d59be51c944e902d263-8ef72.png)](https://reactjs.org/static/commit-selector-bd72dec045515d59be51c944e902d263-8ef72.png) 

在条形图中，每一栏都表示单次的 commit 数据，你当前选中的 commit 栏会变成黑色。你可以点击各个栏（或者是左/右切换按钮）来查看不同的 commit 数据。

这些栏的颜色和高度对应着该次 commit 在渲染上所花的时间（较高、偏黄的栏会比较矮、偏蓝的栏花费的时间多）。

### 筛选 commit

你 profile 的记录时间越长，就会有越多的渲染次数。有时候你或许会被过多的（价值低的） commit 记录干扰。 为了帮助你解决这个问题， profiler 提供了一个筛选功能。 用它来制定一个时间门槛，之后 profiler 会隐藏所有比这个门槛更快的 commit。

![Filtering commits by time](https://reactjs.org/filtering-commits-683b9d860ef722e1505e5e629df7ef7e.gif)

### 火焰图
（译者注： [阮一峰：如何读懂火焰图？](http://www.ruanyifeng.com/blog/2017/09/flame-graph.html)）

火焰图会展示你所指定的那一次 commit 的信息。 图中每一栏都代表了一个 React component（例如下图中的 `App`、 `Nav`）。 各栏的尺寸和颜色表示这栏所代表的 component 及其 children 的渲染时间。（栏的长度表示该 component 最近一次渲染所花费的时间，栏的颜色代表在该次 commit 中渲染所花费的时间）

[![Example flame chart](https://reactjs.org/static/flame-chart-3046f500b9bfc052bde8b7b3b3cfc243-acf85.png)](https://reactjs.org/static/flame-chart-3046f500b9bfc052bde8b7b3b3cfc243-53c76.png) 

> Note:
> 
> 栏的长度表示 component（和它的 children）最近一次渲染所花费的时间。 如果这个 component 在本次 commit 中没有被重新渲染，那其所展示的时间表示上一次 render 的耗时。 一个栏越宽，其所代表的 component 渲染耗时就越长。
> 
> 栏的颜色表示在本次 commit 中该 component（和它的 children）所花费的时间。黄色代表耗时较长、蓝色代表耗时较短，灰色代表该 component 在这次 commit 中没有被（重新）渲染。

举个例子，上图中所展示的 commit 总共渲染耗时为 18.4ms。 `Router` component 是渲染成本 ”最昂贵“ 的 component（花费了 18.4ms）。他所花费的时间大部分在两个 children 上：`Nav` (8.4ms) 和 `Route` (7.9ms)。剩下的时间用于它的其他 children 和它自身的渲染。

你可以通过点击 component 栏来放大或缩小火焰图： ![Click on a component to zoom in or out](https://reactjs.org/zoom-in-and-out-39ba82394205242af7c37ccb3a631f4d.gif)

点击一个 component 的同时也会选中它，它的具体信息将会展示在右边的数据栏，栏里会展示该 component 在这次 commit 过后的 `props` 和 `state`。你可以去深入研究这些数据来找出这次 commit 具体做了哪些。

![Viewing a component's props and state for a commit](https://reactjs.org/props-and-state-1f4d023f1a0f281386625f28df87c78f.gif)

某些情况下，点击一个 component 后在不同的 commit 之间切换也可以发现触发这次渲染的原因：

![Seeing which values changed between commits](https://reactjs.org/see-which-props-changed-cc2a8b37bbce52c49a11c2f8e55dccbc.gif)

上图表示在两次 commit 中 `state.scrollOffset` 被改变了。这或许就是触发 `List` component 重绘的原因。

### 排序图

同火焰图一样，排序图也会展示你所指定的那一次 commit 的信息，图中每一栏都代表了一个 React component（例如下图中的 `App`、 `Nav`）。 不同的是排序图是有顺序的，耗时最长的 component。会展示在第一行。

 [![Example ranked chart](https://reactjs.org/static/ranked-chart-0c81347535e28c9cdef0e94fab887b89-acf85.png)](https://reactjs.org/static/ranked-chart-0c81347535e28c9cdef0e94fab887b89-53c76.png) 

> Note:
> 
> 一个 component 的渲染时间也包括了它的 children 们。 所以渲染耗时最长的 component 通常距离渲染树顶部最近。

和火焰图一样，你可以通过点击 component 栏来放大或缩小排序图。
（译者注：排序图只会展示在本次 commit 中被触发重绘的 component。）

### Component 图

在你 profile 的过程中，使用该图查看单一 component （在多次 commit 中）的渲染时间有时候是非常有用的。  Component 图会展示一个栏的集合，其中每一栏都表示你所选择的 component 的某一次 commit 下的渲染时间。每栏高度和颜色都表示该 component 在某次 commit 中同其它组件的耗时对比。

 [![Example component chart](https://reactjs.org/static/component-chart-d71275b42c6109e222fbb0932a0c8c09-acf85.png)](https://reactjs.org/static/component-chart-d71275b42c6109e222fbb0932a0c8c09-53c76.png) 

上图表示 `List` component 的 11 次渲染。 它同时展示了在它的每次渲染的时候，它都是那次 commit 中 ”最昂贵“ 的组件。（译者注：此处是通过栏的颜色判断）

查看这种图的方法有两种：双击一个 component 或者是选中一个 component 后点击在右边栏中的蓝色表格按钮。你可以通过点击右边栏的 “x” 按钮来返回原图，当然你也可以双击 Component 图中的某一栏来查看那次 commit 的更多信息。

![How to view all renders for a specific component](https://reactjs.org/see-all-commits-for-a-fiber-99cb4321ded8eb0c21ae5fc673878563.gif)

如果你所选中的 component 在 profile 期间从来没被渲染过，则会显示下面的信息：

[![No render times for the selected component](https://reactjs.org/static/no-render-times-for-selected-component-8eb0c37a13353ef5d9e61ae8fc040705-acf85.png)](https://reactjs.org/static/no-render-times-for-selected-component-8eb0c37a13353ef5d9e61ae8fc040705-53c76.png) 

### 交互动作 ( Interactions )

React 最近添加了一个 [实验性 API](https://fb.me/react-interaction-tracking) ，目的是为了追踪引起更新的原因。被这些API所追踪的 “交互动作” 也会展示在 profiler 里：

[![The interactions panel](https://reactjs.org/static/interactions-a91a39ac076b71aa7a202aaf46f8bd5a-acf85.png)](https://reactjs.org/static/interactions-a91a39ac076b71aa7a202aaf46f8bd5a-53c76.png) 

上图展现了一个 profile 期间被追踪的 4 个交互动作。每行都展示了一个追踪的交互动作。每行里带有颜色的点表示与其交互动作所对应的 commit 记录。

你也可以在特定的 commit 记录的右边栏看到在该记录期间所被追踪的交互动作。

[![List of interactions for a commit](https://reactjs.org/static/interactions-for-commit-9847e78f930cb7cf2b0f9682853a5dbc-acf85.png)](https://reactjs.org/static/interactions-for-commit-9847e78f930cb7cf2b0f9682853a5dbc-53c76.png) 

你可以通过点击它们来实现在交互动作和 comits 之间的跳转：

![Navigate between interactions and commits](https://reactjs.org/navigate-between-interactions-and-commits-7c66e7686b5242473c87b3d0b4576cf3.gif)

tracking API 仍然是很新的特性，我们会在接下来的博客文章中详细介绍它。

## 常见问题 & 解决方法

### 选择的根元素下没有 profile 数据被记录

如果你的 APP 有好几个 “根“（译者注：指 React 有好几个根组件），你可能会在 profile 之后看到下面的信息： [![No profiling data has been recorded for the selected root](https://reactjs.org/static/no-profiler-data-multi-root-0755492a211f5bbb775285c0ff2fdfda-acf85.png)](https://reactjs.org/static/no-profiler-data-multi-root-0755492a211f5bbb775285c0ff2fdfda-53c76.png) 

这个信息表示你在 “Elements” 界面下所选择的根元素之下没有性能数据被记录。这种情况下，请尝试选择一个不同的根元素来查看在这个根元素下的 profile 数据：

![Select a root in the "Elements" panel to view its performance data](https://reactjs.org/select-a-root-to-view-profiling-data-bdc30593d414b5c8d2ae92027ed11940.gif)

### 选中的 commit 记录没有时间数据可以展示

有时候 commit 速度可能非常地快，以至于 `performance.now()` 没法提供给 DevTools 任何有意义的数据。这种情况下，会展示下面的界面：

 [![No timing data to display for the selected commit](https://reactjs.org/static/no-timing-data-for-commit-63b2fb6298feecb179272c467020ed95-acf85.png)](https://reactjs.org/static/no-timing-data-for-commit-63b2fb6298feecb179272c467020ed95-53c76.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
