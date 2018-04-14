> * 原文地址：[UNIDIRECTIONAL USER INTERFACE ARCHITECTURES](https://staltz.com/unidirectional-user-interface-architectures.html)
> * 原文作者：[André Staltz](https://staltz.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unidirectional-user-interface-architectures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unidirectional-user-interface-architectures.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Hopsken](https://github.com/Hopsken)，[dandyxu](https://github.com/dandyxu)

# 单向用户界面架构

本文对所谓的“单向数据流”架构进行了非详尽的概述。这并不意味着本文应被视为一个初学者教程，它更应该是一个架构之间的差异和特性的概述。最后，我将会介绍一个和其他框架显著不同的新框架。本文仅假设客户端是 Web UI 框架。

## 术语

如果没有术语的共识，讨论这些框架可能会造成困惑，所以我们作出如下的假设：

> **用户事件（User events）** 是来自用户直接操作的输入设备的事件。比如：鼠标点击，鼠标滚动，键盘按键，屏幕触摸等等。

当不同的框架使用 “View” 这个术语时，含义可能大不相同。作为替代，我们使用 “rendering” 来代表共识中的 “View”。

> **用户接口渲染（User interface rendering）**指代屏幕上的图形输出，一般情况下用 HTML 或者其他类似的高级声明代码比如 JSX 来描述。

> 一个**用户界面（UI）程序（User interface (UI) program）**是任何一个将用户事件作为输入输出视图的程序，这是一个持续的过程而不是一次性的转换。

假定 DOM 以及其他层比如一些框架和库存在于用户和架构之间。

**模块间箭头的所属很重要。**`A--> B` 和 `A -->B` 是不一样的。前者是被动编程，而后者是反应式编程。[这里](http://cycle.js.org/observables.html#reactive-programming)可以阅读更多。

> 如果子组件和整体的结构一致，这个单向架构就被称为**分形（fractal）**。

在分形架构中，整体可以像组件一样简单地打包然后用于更大的应用。

在非分形架构中，那些不重复的部分被称为**协调器（orchestrators）**，它们不属于具有分级结构的部分。

## FLUX

第一个必须提到的是 [Flux](https://github.com/facebook/flux/)。它虽然不是绝对的先驱，但是至少在流行度上，对于很多人它都是第一个单向架构。

**组成部分：**

*   **Stores**：管理事务信息和状态
*   **View**：一个 React 组件的分级结构
*   **Actions**：由 View 当中触发的用户事件而产生的事件
*   **Dispatcher**：搭载所有 actions 的事件

[![Flux diagram](https://staltz.com/img/flux-unidir-ui-arch.jpg)](https://staltz.com/img/flux-unidir-ui-arch.jpg)

**特点：**

**Dispatcher。** 因为它是事件的载体，它是唯一的。很多 Flux 的变体去掉了对 dispatcher 的需求，其他的一些单向框架也没有 dispatcher 等同物。

**只有 View 有可组合组件。** 分级结构仅存在于 React 组件中，Stores 和 Actions 都没有。一个 React 组件就是一个 UI 程序，并且其内部通常不会编写成一个 Flux 架构的形式。所以 Flux 不是分形的，Dispatcher 和 Stores 作为它的协调器。

**用户事件处理器在 rendering 中声明。** 换句话说，React 组件的 `render()` 函数处理和用户交互的两个方向：渲染和用户事件处理（例如 `onClick={this.clickHandler}`）

## REDUX

[Redux](http://rackt.github.io/redux/) 是一个 Flux 的变体，单例 Dispatcher 被改编成了一个独一的 Store。Store 不是从零开始实现的，相反，创建它的方式是给 store 工厂一个 reducer 函数。

**组成部分：**

*   **Singleton Store**：管理状态，并拥有一个 `dispatch(action)` 函数
*   **Provider**：Store 的订阅者，和像 React 或者 Angular 这样的 “View” 框架交互
*   **Actions**：由用户事件创建的事件，并且是根据 Provider 而创建
*   **Reducers**：纯函数，根据前一状态和一个 action 得出新的状态

[![Redux diagram](https://staltz.com/img/redux-unidir-ui-arch.jpg)](https://staltz.com/img/redux-unidir-ui-arch.jpg)

**特点：**

**store 工厂。** 使用工厂函数 `createStore()` 可以创建 Store，由 reducer 函数作为组成参数。还有一个元工厂函数 `applyMiddleware()`，接受中间件函数作为参数。中间件是用附加的链式功能重写 store 的 `dispatch()` 函数的机制。

**Providers。** 对于用来作为 UI 程序的 “View” 框架，Redux 并不武断控制。它可以和 React 或者 Angular 或者其他框架配合使用。在这个框架中，“View” 是 UI 程序。和 Flux 一样，Redux 被设计为非分形的，并且以 Store 作为协调器。

**用户事件处理函数的声明可能在也可能不在 rendering。** 取决于当下的 Provider。

## BEST

[Famous Framework](https://blog.famous.org/introducing-the-famous-framework/) 引入了 Behavior-Event-State-Tree (BEST)，它是一个 MVC 的变体，BEST 中 Controller 分成了两个单向元素：Behavior 和 Event。

**组成部分：**

*   **State**: 用类 JSON 结构的声明来初始化 state
*   **Tree**: 一个组件的声明性分级结构
*   **Event**: 在 Tree 上的事件监听，它能改变 state
*   **Behavior**: 依赖 state 的 tree 的动态属性

[![BEST diagram](https://staltz.com/img/best-unidir-ui-arch.jpg)](https://staltz.com/img/best-unidir-ui-arch.jpg)

**特点：**

**多范例。** State 和 Tree 是完全声明式的。Event 是急迫性的，Behavior 是功能性的。一些部分是响应式的，而其他部分则是被动式的。（例如，Behavior 会对 State 作出反应，Tree 则对 Behavior 比较消极）

**Behavior。** Behavior 将 UI 视图（Tree）和它的动态属性分离了，这在本文中的其他几个框架中都不会出现。据称，这出于不同的考虑：Tree 就好比 HTML，Behavior 就好比 CSS。

**用户事件处理的声明从视图分离。** BEST 是极少的不将用户事件处理和视图关联的单向框架之一。用户事件处理属于 Event，而不是 Tree。

在这个框架中，“View” 是一个树结构，一个 “Component” 是一个 Behavior-Event-Tree-State 元组。组件是 UI 程序。BEST 是分形框架。

## MODEL-VIEW-UPDATE

也被称为 “[The Elm Architecture](https://github.com/evancz/elm-architecture-tutorial/)”，Model-View-Update 和 Redux 很相似，主要因为后者是受这个框架启发的。这是一个纯函数的框架，因为它的主语言是 [Elm](http://elm-lang.org/)，一个 Web 的函数式编程语言。

**组成部分：**

*   **Model**：一个定义状态数据结构的类型
*   **View**：将状态转化为视图的纯函数
*   **Actions**：定义通过邮件发送的用户事件的类型
*   **Update**：一个纯函数，将前一状态和 action 转变为新的状态

[![Model-View-Update diagram](https://staltz.com/img/mvu-unidir-ui-arch.jpg)](https://staltz.com/img/mvu-unidir-ui-arch.jpg)

**特点：**

**到处都是分级结构。** 之前的几个框架只在 “View” 中有分级结构，但是在 MVU 架构中这样的结构在 Model 和 Update 中也能找到。甚至是 Actions 可能也嵌套了 Actions。

**组件分块导出。** 因为哪里都是分级结构，在 Elm 架构中的 “component” 是一个元组，包括了：模块类型，一个初始模块实例，一个 View 函数，一个 Action 类型，一个 Update 函数。纵览整个架构，不可能有组件从这个结构中偏离。每个组件都是 UI 程序，并且这个架构是分形的。

## MODEL-VIEW-INTENT

Model-View-Intent 是基于框架 [Cycle.js](http://cycle.js.org) 的主要架构模式，它同时也是基于观察者 [RxJS](https://github.com/Reactive-Extensions/RxJS) 的完全反应单向架构。**可观察（Observable）** 事件流是一个所有地方都用到的原函数，Observables 上的函数是架构的一部分。

**组成部分：**

*   **Intent**：来自 Observable 用户事件的函数，用来观察 “actions”
*   **Model**：来自 Observable 的 actions 的函数，观察 state
*   **View**：来自 Observable 的 state 的函数，观察 rendering 视图
*   **Custom element**：rendering 视图的子部件，其自身也是一个 UI 程序。可能会作为 MVI 或者一个 Web 组件被应用。是否应用于 View 是可选的。

[![Model-View-Intent diagram](https://staltz.com/img/mvi-unidir-ui-arch.jpg)](https://staltz.com/img/mvi-unidir-ui-arch.jpg)

**特点：**

**极大的依赖于 Observables。** 该框架每一部分的输出都被描述为 Observable 事件流。因此，如果不用 Observables，就很难或者说不可能描述任何 “data flow” 或 “change”。

**Intent。** 和 BEST 中的 **Event** 大致相似，用户事件处理在 Intent 中声明，从视图中分离出来。和 BEST 不同，Intent 创建了 actions 的 Observable 流，这里的 actions 就和 Flux，Redux，和 Elm 中的类似。但是，和 Flux 等中的不同的是， MVI 中的 actions 不直接被发送到 Dispatcher 或 Store。它们就是简单的可以直接被模块监听。

**完全反应。** 用户视图反应到视图输入，视图输出反应到模块输出，模块输出反应到 Intent 输出，Intent 输出反应到用户事件。

MVI 元组是一个 UI 程序。当且仅当所有用户定义元素与 MVI 一起应用时，这个框架是分形的。

## NESTED DIALOGUES

这篇博文将 **Nested Dialogues** 作为一个新的单向架构来介绍，适用于 Cycle.js 和其他完全依赖于 Observables 的方法。这是 Model-View-Intent 架构的一次进化。

从 Model-View-Intent 序列可以函数化组合为一个函数这个特性说起，一个 “Dialogue”：

[![A Dialogue function equivalent to Model-View-Intent](https://staltz.com/img/dialogue-mvi-unidir-ui-arch.jpg)](https://staltz.com/img/dialogue-mvi-unidir-ui-arch.jpg)

如图所示，一个 **Dialogue** 是一个将用户事件的 Observable 作为输入（Intent 的输入），然后输出一个视图的 Observable（View 的输出）的方法。因此，Dialogue 就是一个 UI 程序。

我们推广了 Dialogue 的定义来容许用户之外的其他目标，每一个目标都有一个 Observable 输入和一个 Observable 输出。例如，如果 Dialogue 通过 HTTP 连接了用户和服务端，这个 Dialogue 就应该接受两个 Observables 作为输入：用户事件的 Observables 和 HTTP 响应的 Observables。然后，它将会输出两个 Observables：视图的 Observables 和 HTTP 请求的 Observables。这个是 Cycle.js 里面 [Drivers](http://cycle.js.org/drivers.html) 的概念。

这就是 Model-View-Intent 作为 Dialogue 重组后的样子：

[![A Dialogue function as a UI program](https://staltz.com/img/single-dialogue-unidir-ui-arch.jpg)](https://staltz.com/img/single-dialogue-unidir-ui-arch.jpg)

要想将 Dialogue 方法作为一个更大程序的 UI 程序子组件重复使用，这就涉及到 Dialogue 之间的嵌套问题：

[![Nested Dialogues](https://staltz.com/img/nested-dialogues-unidir-ui-arch.jpg)](https://staltz.com/img/nested-dialogues-unidir-ui-arch.jpg)

Observables 在 Dialogues 不同层之间的连接是一个数据流图。它并不必须是一个非周期图。在例如子组件动态列表这样的实例中，数据流图就必须是周期的。这样的例子超出了本文的讨论范围。

嵌套的 Dialogues 实际上是一个元架构：它对组件的内部结构没有约束，这就允许我们将前文所述的所有架构嵌入一个嵌套的 Dialogue 组件中。唯一的约束涉及 Dialogue 的一端的接口：输入和输出都必须是一个或一组 Observable。如果一个结构如同 Flux 或者 Model-View-Update 的 UI 程序能够让它的输入和输出都以 Observables 呈现，那么这个 UI 程序就能够作为一个 Dialogues 函数嵌入一个嵌套的 Dialogues。

因此，这个架构是分形的（仅涉及 Dialogue 接口时）、一般性的。

可以查看 [TodoMVC implementation](https://github.com/cyclejs/todomvc-cycle) 和 [this small app](https://github.com/cyclejs/cyclejs/tree/master/examples/advanced/bmi-nested) 作为使用了 Cycle.js 的嵌套 Dialogues 的例子。

## 重点总结

尽管嵌套 Dialogues 的一般性和优雅性在理论上可以用来作为子组件嵌入到其他架构中，但我对这个框架最主要的兴趣在于构建 Cycle.js 应用。我一直在寻找一个**自然**且**灵活**的 UI 架构，并且同时能够提供 **结构**。

我认为嵌套的 Dialogues 是**自然**的，因为它直接表现了其他典型 UI 程序完成的：一个将用户事件作为输入（输入 Observable）持续运行的进程（Observable 就是持续的进程），并且产生视图作为输出（输出 Observable）。

它也是**灵活的**，因为正如我们所见，Dialogue 的内部结构可以自由的应用于任何模式。这和有着死板结构作为条框的 Model-View-Update 截然相反。分形架构比非分形的更加易重用，我很高兴嵌套的 Dialogues 也有这个属性。

但是，一些常规的**结构**也可以对引导开发有所帮助。虽然我认为 Dialogue 的内部结构应当是 Flux，但我想 Model-View-Intent 很自然的适配了 Observable 的输入输出接口。所以当我想自由一些，不把 Dialogue 作为 MVI 时，我承认大部分时间我都会把它构造成 MVI。

我不想自大的说这是最好的用户界面架构，因为我也是刚刚发现了它并且依旧需要实际应用来发现它的优缺点。嵌套 Dialogues 仅仅是我现在的最强烈推荐。

* * *

[Comments in Hacker News](https://news.ycombinator.com/item?id=10115314).

如果你喜欢这篇文章，分享给你的 followers：[(tweeting)](https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fstaltz.com%2Funidirectional-user-interface-architectures.html&text=Unidirectional%20User%20Interface%20Architectures&tw_p=tweetbutton&url=https%3A%2F%2Fstaltz.com%2Funidirectional-user-interface-architectures.html&via=andrestaltz "tweeting")。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
