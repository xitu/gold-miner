> * 原文地址：[Dragging React performance forward](https://medium.com/@alexandereardon/dragging-react-performance-forward-688b30d40a33)
> * 原文作者：[Alex Reardon](https://medium.com/@alexandereardon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dragging-react-performance-forward.md](https://github.com/xitu/gold-miner/blob/master/TODO/dragging-react-performance-forward.md)
> * 译者：[hexiang](https://github.com/hexianga)
> * 校对者：[wznonstop](https://github.com/wznonstop)，[zephyrJS](https://github.com/zephyrJS)

# **拖放库中 React 性能的优化**

![](https://cdn-images-1.medium.com/max/800/1*I6CQ27V59uP_i7p1liMFtA.jpeg)

照片由 [James Padolsey](https://unsplash.com/photos/6JCANHNBNGw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 在 [Unsplash](https://unsplash.com/collections/1584252/drag-blog?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄

我为 [React](https://reactjs.org/) 写了一个拖放库  [**react-beautiful-dnd**](https://github.com/atlassian/react-beautiful-dnd) 🎉。[Atlassian](https://medium.com/@Atlassian) 创建这个库的目的是为网站上的列表提供一种美观且易于使用的拖放体验。你可以阅读介绍文档: [关于拖放的反思](https://medium.com/@alexandereardon/rethinking-drag-and-drop-d9f5770b4e6b)。这个库**完全通过状态驱动** —— 用户的输入导致状态改变，然后更新用户看到的内容。这在概念上允许使用任何输入类型进行拖动，但是太多状态驱动拖动将会导致性能上的缺陷。🦑

我们最近发布了 react-beautiful-dnd 的第四个版本 [`version 4`](https://github.com/atlassian/react-beautiful-dnd/releases/tag/v4.0.0)，其中包含了**大规模的性能提升**。

![](https://cdn-images-1.medium.com/max/800/1*cn48EAW1k9TcDpfTtkySog.png)

列表中的数据是基于具有 500 个可拖动卡片的配置，在开发版本中启用仪表的情况下进行记录的，开发版本及启用仪表都会降低运行速度。但与此同时，我们使用了一台性能卓越的机器用于这次记录。确切的性能提升幅度会取决于数据集的大小，设备性能等。

您看仔细了，**我们看到有 99% 的性能提升** 🤘。由于这个库已经经过了[极致的优化](https://github.com/atlassian/react-beautiful-dnd#performance)，所以这些改进更加令人印象深刻。你可在[大型列表示例](https://react-beautiful-dnd.netlify.com/iframe.html?selectedKind=single%20vertical%20list&selectedStory=large%20data%20set)或[大型面板示例](https://react-beautiful-dnd.netlify.com/iframe.html?selectedKind=board&selectedStory=large%20data%20set)这两个例子中来感受性能提升的酸爽 😎。

* * *

在本博客中，我将探讨我们面临的性能挑战以及我们如何克服它们以获得如此重要的结果。我将谈论的解决方案非常适合我们的问题领域。有一些原则和技术将会出现 —— 但具体问题可能会在问题领域有所不同。

我在这篇博客中描述的一些技术相当先进，其中大部分技术最好在 React 库的边界内使用，而不是直接在 React 应用程序中使用。

### TLDR;

我们都很忙！这里是这个博客的一个非常高度的概述：

尽可能避免 `render` 调用。 另外以前探索的技术 ([第一轮](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191), [第二轮](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97))，我在这里有一些新的认识：

*   避免使用 props 来传递消息
*   调用 `render` 不是改变样式的唯一方法
*   避免离线工作
*   如果可以的话，批量处理相关的 Redux 状态更新

### 状态管理

react-beautiful-dnd 的大部分状态管理使用 [Redux](https://redux.js.org/docs/introduction/)。这是一个实现细节，库的使用者可以使用任何他们喜欢的状态管理工具。本博客中的许多具体内容都针对 Redux 应用程序 —— 然而，有一些技术是通用的。为了能够向不熟悉 Redux 的人解释清楚，下面是一些相关术语的说明：

*   **store:** 一个全局的状态容器  —  通常放在 [`context`](https://reactjs.org/docs/context.html) 中，所以**被连接的组件**可以被注册去更新。
*   **被连接的组件:** 直接注册到 **store** 的组件. 他们的责任是响应 store 中的状态更新并将 props 传递给未连接的组件。这些通常被称为**智能或者容器**组件
*   **未连接的组件**: 未连接到 Redux 的组件。他们通常被连接到 store 的组件包裹，接收来自 state 的 props。这些通常被称为**笨拙**或者**展示**组件

**如果你感兴趣，这是一些来自 [Dan Abramov](https://medium.com/@dan_abramov)   的关于这些概念[更详细的信息](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)**。

### 第一个原则

![Snipaste_2018-03-10_19-58-28.png](https://i.loli.net/2018/03/10/5aa3c874e327e.png)

作为一般规则，您应该尽可能避免调用组件的 render() 函数，`render` 调用代价很大，有以下原因：

*   `render` 函数调用的进程很费资源
*   Reconciliation

[Reconciliation](https://reactjs.org/docs/reconciliation.html) 是 React 构建一颗新树的过程，然后用当前的视图（虚拟 DOM）来进行 **调和**，根据需要执行实际的 DOM 更新。reconciliation 过程在调用一个 `render` 后被触发。

`render` 函数的 processing 和 reconciliation 在规模上是代价很大的。 如果你有 100 个或者 10000 个组件，你可能不希望每个组件在每次更新时都协调一个 `store` 中的共享状态。理想情况下，只有**需要**更新的组件才会调用它的 `render` 函数。对于我们每秒 60 次更新（60 fps）的拖放，这尤其如此。

我在前两篇博客 ([第一轮](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191), [第二轮](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97)) 中探讨了避免不必要的 `render` 调用的技巧，React 文档[关于这个问题的叙述](https://reactjs.org/docs/optimizing-performance.html)也讨论了这个主题。就像所有东西都有一个平衡点一样，如果你太过刻意地避免渲染，你可能会引入大量潜在的冗余记忆检查。 这个话题已经在其他地方讨论过了，所以我不会在这里详细讨论。

除了渲染成本之外，当使用 Redux 时，连接的组件越多，您就需要在每次更新时运行更多的状态查询 ([`mapStateToProps`](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options)) 和记忆检查。我在 [round 2 blog](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97#.zflzltn15) 中详细讨论了与 Redux 相关的状态查询，选择器和备忘录。

### Problem 1：拖动开始之前长时间停顿

![](https://cdn-images-1.medium.com/max/800/1*tgrL8LuY9xY46qFo7HhuLQ.gif)

注意从鼠标下的圆圈出现到被选卡片变绿时的时间差。

当点击一个大列表中的卡片时，需要相当长的时间才能开始拖拽，在 500 个卡片的列表中这是 **2.6 s 😢**！对于那些期望拖放交互是即时的用户来说，这是一个糟糕的体验。 让我们来看看发生了什么，以及我们用来解决问题的一些技巧。

### Issue 1：原生维度的发布

为了执行拖动，我们将所有相关组件的尺寸（坐标，大小，边距等）的快照放入到我们的 **state** 和拖动的开始处。然后，我们会在拖动过程中使用这些信息来计算需要移动的内容。 我们来看看我们如何完成这个初始快照：

1.  当我们开始拖动时，我们对 `state` 发出请求 `request`。
2.  **关联**维度发布组件读取此 `request` 并查看他们是否需要发布任何内容。
3.  如果他们需要发布，他们会在**未连接**维度的发布者上设置一个 `shouldPublish` 属性。
4.  **未连接**的维度发布者从 DOM 收集维度并使用 `publish` 回调来发布维度

好的，所以这里有一些痛点：

> 1. 当我们开始拖动时，我们在 `state` 上发起了一个 `request`。
> 2. 关联维度发布组件读取此请求并查看他们是否需要发布任何内容

此时，每个关联的维度发布者都需要针对 store 执行检查，以查看他们是否需要请求维度。不理想，但并不可怕。让我们继续

> 3. 如果他们需要发布，他们会在未连接的维度发布者上设置一个 `shouldPublish` 属性

我们过去使用 `shouldPublish` 属性来**传递消息**给组件来执行一个动作。不幸的是，这样做会有一个副作用，它会导致组件进行 render，从而引发该组件本身及其子组件的调和。当你在众多组件上执行这个操作时，代价昂贵。

> 4. **未连接**的维度发布者从 DOM 收集维度并使用 `publish` 回调来发布维度

事情会变得**更糟**。首先，我们会立即从 DOM 读取很多维度，这可能需要一些时间。从那里每个维度发布者将单独 `publish` 一个维度。 这些维度会被存储到状态中。这种 `state` 的变化会触发 store 的订阅，从而导致步骤二中的关联组件状态查询和记忆检查被执行。它还会导致应用程序中的其他连接组件类似地运行冗余检查。因此，每当未连接的维度发布者发布维度时，将导致所有其他连接组件的冗余工作。这是一个 O(n²) 算法 - 更糟！哎。

#### The dimension marshal

为了解决这些问题，我们创建了一个新角色来管理维度收集流程：`dimension marshal`（维度元帅）。以下是新的维度发布的工作方式：

拖动工作之前：

1.  我们创建一个 `dimension marshal`，然后把它放到了 [`context`](https://reactjs.org/docs/context.html) 中。
2.  当维度发布者加载到 DOM 中时，它会从 `context` 中读取 `dimension marshal` ，并向 `dimension marshal` 注册自己。Dimension 发布者不再直接监听 store。 因此，不存在更多未连接的维度发布者。

拖动工作开始：

1.  当我们开始拖动时，我们对 `state` 发出 `request` 。
2.  `dimension marshal` 接收 `request` 并直接向所需维度发布者请求关键维度（拖动卡片及其容器）以便开始拖动。 这些发布到 store 就可以开始拖动。
3.  然后，`dimension marshal` 将在下一个帧中异步请求所有其他 dimension publishers 的 dimensions。这样做会分割从 DOM 中收集维度的成本，并将维度（下一步）发布到单独的帧中。
4.  在另一个帧中，`dimension marshal` 执行所有收集维度的批量 `publish`。在这一点上，state 是完全混合的，它只需要三帧。

这种方法的其他性能优势：

*   更少的状态更新导致所有连接组件的工作量减少
*   没有更多的连接维度发布者，这意味着在这些组件中完成的处理不再需要发生。

因为 `dimension marshal` 知道系统中的所有 `ID` 和  `index`，所以它可以直接请求任何维度 `O（1）`。这也使其能够决定如何以及何时收集和发布维度。 以前，我们有一个单独的 `shouldPublish` 信息，它对一切都立即进行回应。`dimension marshal` 在调整这部分生命周期的性能方面给了我们很大的灵活性。如果需要，我们甚至可以根据设备性能实施不同的收集算法。

#### 总结

我们通过以下方式改进了维度收集的性能：

*   不使用 props 传递没有明显更新的消息。
*   将工作分解为多个帧。
*   跨多个组件批量更新状态。

### Issue 2：样式更新

当一个拖动开始的时候，我们需要应用一些样式到每一个 `Draggable` (例如 `pointer-events: none;`)。为此我们应用了一个行内样式。为了应用行内样式我们需要 `render` 每一个 `Draggable`。当用户试图开始拖动时，这可能会导致潜在的在 100 个可拖动卡片上调用 `render`，这会导致 500 个卡片耗费 350 ms。

那么，我们将如何去更新这些样式而不会产生 `render`?

#### 动态共享样式 💫

对于所有 `Draggable` 组件，我们现在应用共享数据属性（例如 `data-react-beautiful-dnd-draggable`）。`data` 属性从来没有改变过。 但是，我们通过我们在页面 `head` 创建的**共享样式元素**动态地更改应用于这些数据属性的样式。

这是一个简单的例子：

```
// 创建一个新的样式元素
const el = document.createElement('style');
el.type = 'text/css';

// 将它添加到页面的头部
const head = document.querySelector('head');
head.appendChild(el);

// 在将来的某个时刻，我们可以完全重新定义样式元素的全部内容
const setStyle = (newStyles) => {
  el.innerHTML = newStyles;
};

// 我们可以在生命周期的某个时间点应用一些样式
setStyle(`
  [data-react-beautiful-dnd-drag-handle] {
    cursor: grab;
  }
`);

// 另一个时刻可以改变这些样式
setStyle(`
  body {
    cursor: grabbing;
  }
  [data-react-beautiful-dnd-drag-handle] {
    point-events: none;
  }
  [data-react-beautiful-dnd-draggable] {
    transition: transform 0.2s ease;
  }
`);
```

**如果你感兴趣，你可以看看我们怎么**[**实施它的**](https://github.com/atlassian/react-beautiful-dnd/blob/0fb4dc75ea9b625f64cac48602635ac2822f26ec/src/view/style-marshal/style-marshal.js)。

在拖拽生命周期的不同时间点上，我们重新定义了样式规则本身的内容。 您通常会通过切换 `class` 来改变元素的样式。 但是，通过使用定义动态样式，我们可以避免应用新的 `class` 去 `render` 任何需要渲染的组件。

**我们使用 `data` 属性而不是 `class` 使这个库对于开发者更容易使用，他们不需要合并我们提供的 `class` 和他们自己的 `class`**。

使用这种技术，我们还能够优化拖放生命周期中的其他阶段。 我们现在可以更新卡片的样式，而无需 `render` 它们。

**注意：您可以通过创建预置样式规则集，然后更改 `body`上的 `class` 来激活不同的规则集来实现类似的技术。然而，通过使用我们的动态方法，我们可以避免在 `body` 上添加 `class`es。并允许我们随着时间的推移使用具有不同值的规则集，而不仅仅是固定的。**

不要害怕，`data` 属性的选择器性能[很好](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/)，与 `render` 性能差别很大。

### Issue 3：阻止不需要的拖动

当一个拖动开始时，我们也在 `Draggable` 上调用 `render` 来将 `canLift` prop 更新为 `false`。这用于防止在拖动生命周期中的特定时间开始新的拖动。我们需要这个 prop ，因为有一些键盘鼠标的组合输入可以让用户在已经拖动一些东西的期间开始另一些东西的拖动。我们仍然真的需要这个 `canLift` 检查 —— 但是我们怎么做到这一点，而无需在所有的 `Draggables`上调用 `render`？

#### 与 State 结合的 context 函数

我们没有通过 `render` 更新每个 `Draggable` 的 props 来阻止拖动的发生，而是在 `context` 中添加了 `canLift` 函数。该函数能够从 store 中获得当前状态并执行所需的检查。通过这种方式，我们能够执行相同的检查，但无需更新 `Draggable` 的 props。

**此代码大大简化，但它说明了这种方法：**

```
import React from 'react';
import PropTypes from 'prop-types';
import createStore from './create-store';

class Wrapper extends React.Component {
 // 把 canLiftFn 放置在 context 上
 static childContextTypes = {
   canLiftFn: PropTypes.func.isRequired,
 }

 getChildContext(): Context {
   return {
    canLiftFn: this.canLift,
   };
 }

 componentWillMount() {
   this.store = createStore();
 }

 canLift = () => {
   // 在这个位置我们可以进入 store
   // 所以我们可以执行所需的检查
   return this.store.getState().canDrag;
 }
 
 // ...
}

class DraggableHandle extends React.Component {
  static contextTypes = {
    canLiftFn: PropTypes.func.isRequired,
  }

  // 我们可以用它来检查我们是否被允许开始拖拽
  canStartDrag() {
    return this.context.canLiftFn();
  }

  // ...
}
```

很明显，你只想非常谨慎地做到这一点。但是，我们发现它是一种非常有用的方法，可以在**不**更新 props 的情况下向组件提供 store 信息。鉴于此检查是针对用户输入而进行的，并且没有渲染影响，我们可以避开它。 

### 拖曳开始前不再有很长的停顿

![](https://cdn-images-1.medium.com/max/800/1*RTkP4pJmX_4eGQUzkUVTIw.gif)

在拥有 500 个卡片的列表中进行拖动立刻就拖动了

通过使用上面介绍的技术，我们可以将在一个有 500 个可拖动卡片的拖动时间从 2.6 s 拖动到到 15 ms（在一个帧内），这是一个 **99％ 的减少 😍!**。

### Problem 2：缓慢的位移

![](https://cdn-images-1.medium.com/max/800/1*xio-0VMqqAzA2t45_Uzkzw.gif)

移动大量卡片时帧速下降。

从一个大列表移动到另一个列表时，帧速率显著下降。 当有 500 个可拖动卡片时，移入新列表将花费大约 350 ms。

### Issue 1：太多的运动

react-beautiful-dnd 的核心设计特征之一是卡片在发生拖拽时会自然地移出其它卡片的方式。但是，当您进入新列表时，您通常可以一次取代大量卡片。 如果您移动到列表的顶部，则需移动下整个列表中的所有内容才能腾出空间。离线的 CSS 变化本身[代价不大](https://codepen.io/alexreardon/full/Ozwxqa/)。然而，与 `Draggables` 沟通，通过 `render` 来告诉他们移动出去的方式，对于同时处理大量卡片来说是很昂贵的。

#### 虚拟位移

我们现在只移动对用户来说部分可见的东西，而不是移动用户看不到的卡片。 因此完全不可见的卡片不会移动。这大大减少了我们在进入大列表时需要做的工作量，因为我们只需要 `render` 可见的可拖动卡片。

当检测可见的内容时，我们需要考虑当前的浏览器视口以及滚动容器（带有自己滚动条的元素）。一旦用户滚动，我们会根据现在可见的内容更新位移。在用户滚动时，确保这种位移看起来正确，有一些复杂。他们不应该知道我们没有移动那些看不见的卡片。以下是我们提出的一些规则，以创建在用户看起来是正确的体验。

*   如果卡片需要移动并且可见：移动卡片并为其运动添加动画
*   如果一个卡片需要移动但它不可见：不要移动它
*   如果一个卡片需要移动并且可见，但是它之前的卡片需要移动但不可见：请移动它，但不要使其产生动画。

因此我们只移动可见卡片，所以不管当前的列表有多大，从性能的角度看移动都没有问题，因为我们只移动了用户可见的卡片。

#### 为什么不使用虚拟列表?

![](https://cdn-images-1.medium.com/max/800/1*IC1HCd7gv48oIEnKazC0Gg.gif)

一个来自 [react-virtualized](https://github.com/bvaughn/react-virtualized) 的拥有 10000 卡片的虚拟列表。

避免离屏工作是一项艰巨的任务，您使用的技术将根据您的应用程序而有所不同。我们希望避免在拖放交互过程中移动和动画显示不可见的已挂载元素。这与避免完全使用诸如 [react-virtualized](https://github.com/bvaughn/react-virtualized) 之类的某种虚拟化解决方案渲染离屏组件完全不同。虚拟化是令人惊奇的，但是增加了代码库的复杂性。它也打破了一些原生的浏览器功能，如打印和查找（`command / control + f`）。我们的决定是为 React 应用程序提供卓越的性能，即使它们不使用虚拟化列表。这使得添加美观，高性能的拖放操作变得非常简单，而且只需很少的开销即可将其拖放到现有的应用程序中。也就是说，我们也计划支持 [supporting virtualised lists](https://github.com/atlassian/react-beautiful-dnd/issues/68) - 因此开发者可以选择是否要使用虚拟化列表减少大型列表 `render` 时间。 如果您有包含 1000 个卡片的列表，这将非常有用。

### Issue 2：可放弃的更新

当用户拖动 `Droppable` 列表时，我们通过更新 `isDraggingOver`  属性让用户知道。但是，这样做会导致 `Droppable` 的 `render` - 这反过来会导致其所有子项 `render` - 可能是 100 个 `Draggable` 卡片！

#### 我们不控制组件的子元素

为了避免这种情况，我们针对 react-beautiful-dnd 的使用者，创建了性能优化的建议[建议文档](https://github.com/atlassian/react-beautiful-dnd#recommended-droppable-performance-optimisation)，以避免渲染不需要渲染的 `Droppable` 的子元素。库本身并不控制 `Droppable` 的子元素的渲染，所以我们能做的最好的是提供一个建议的优化。 这个建议允许用户在拖拽时设置 `Droppable`，同时避免在其所有子项上调用 `render`。

```
import React, { Component } from 'react';

class Student extends Component<{ student: Person }> {
  render() {
    // 渲染一个可拖动的元素
  }
}

class InnerList extends Component<{ students: Person[] }> {
  // 如果子列表没有改变就不要重新渲染
  shouldComponentUpdate(nextProps: Props) {
    if(this.props.students === nextProps.students) {
      return false;
    }
    return true;
  }
  // 你也不可以做你自己的 shouldComponentUpdate 检查，
  // 只能继承自 React.PureComponent

  render() {
    return this.props.students.map((student: Person) => (
      <Student student={student} />
    ))
  }
}

class Students extends Component {
  render() {
    return (
      <Droppable droppableId="list">
        {(provided: DroppableProvided, snapshot: DroppableStateSnapshot) => (
          <div
            ref={provided.innerRef}
            style={{ backgroundColor: provided.isDragging ? 'green' : 'lightblue' }}
          >
            <InnerList students={this.props.students} />
            {provided.placeholder}
          </div>
        )}
      </Droppable>
    )
  }
}
```

### 即时位移

![](https://cdn-images-1.medium.com/max/800/1*zwqHyu4wDUTY7Pa4yEdZCA.gif)

在大的列表之间的平滑移动。

通过实施这些优化，我们可以减少在包含 500 个卡片的列表之间移动的时间，这些卡片的位移时间从 380 ms 减少到 8 ms 每帧！**这是另一个 99％ 的减少**。

### Other：查找表

**这种优化并不是针对 React 的 - 但在处理有序列表时非常有用**

在 react-beautiful-dnd 中我们经常使用数组去存储有序的数据。但是，我们也希望快速查找此数据以检索条目，或查看条目是否存在。通常你需要做一个 `array.prototype.find` 或类似的方法来从列表中获取条目。 如果这样的操作过于频繁，对于庞大的数组来说可能会是场灾难。

![Snipaste_2018-03-10_20-03-13.png](https://i.loli.net/2018/03/10/5aa3c987332f2.png)

有很多技术和工具来解决这个问题（包括 [normalizr](https://github.com/paularmstrong/normalizr)）。一种常用的方法是将数据存储在一个 `Object` 映射中，并有一个 `id` 数组来维护顺序。如果您需要定期查看列表中的值，这是一个非常棒的优化，并且可以加快速度。

我们做了一些不同的事情。我们用 [`memoize-one`](https://github.com/alexreardon/memoize-one) (只记住最新参数的记忆函数) 去创建懒 `Object` 映射来进行实时地按需查找。这个想法是你创建一个接受 `Array` 参数并返回一个 `Object` 映射的函数。如果多次将相同的数组传递给该函数，则返回之前计算的 `Object` 映射。 如果数组更改，则重新计算映射。 这使您拥有一张立即查找表，而无需定期重新计算或者需要将其明确存储在 `state` 中。

```
const getIdMap = memoizeOne((array) => {
  return array.reduce((previous, current) => {
   previous[current.id] = array[current];
   return previous;
  }, {});
});

const foo = { id: 'foo' };
const bar = { id: 'bar' };

// 我们喜欢的有序结构
const ordered = [ foo, bar ];

// 懒惰地计算出快速查找的映射
const map1 = getMap(ordered);

map1['foo'] === foo; // true
map1['bar'] === bar; // true
map1['baz'] === undefined; // true

const map2 = getMap(ordered);
// 像之前一样返回相同的映射 - 不需要重新计算
const map1 === map2;
```

使用查找表大大加快了拖动动作，我们在每次更新（系统中的 `O(n²)`）时检查每个连接的 `Draggable` 组件中是否存在某个卡片。通过使用这种方法，我们可以根据状态变化计算一个 `Object` 映射，并让连接的 `Draggable` 组件使用共享映射进行 `O(1)` 查找。

### 最后的话 ❤️

我希望你发现这个博客很有用，可以考虑一些可以应用于自己的库和应用程序的优化。看看 [react-beautiful-dnd](https://github.com/atlassian/react-beautiful-dnd)，也可以试着玩一下[我们的示例](https://react-beautiful-dnd.netlify.com)。

感谢 [Jared Crowe](https://medium.com/@jaredjcrowe) 和 [Sean Curtis](https://medium.com/@seancurtis) 提供优化帮助，[Daniel Kerris](https://medium.com/@DanielKerris)，[Jared Crowe](https://medium.com/@jaredjcrowe)，[Marcin Szczepanski](https://medium.com/@mszczepanski)，[Jed Watson](https://medium.com/@jedwatson)，[Cameron Fletcher](https://medium.com/@cameronfletcher92)，[James Kyle](https://medium.com/@thejameskyle)，Ali Chamas 和其他 [Atlassian](https://medium.com/@Atlassian) 人将博客放在一起。

### 记录

我在 [React Sydney](https://twitter.com/reactsydney) 发表了一篇关于这个博客的主要观点的演讲。

YouTube 视频链接：[这儿](https://youtu.be/3REMkuIg23k)

在 React Sydney 上优化 React 性能。

感谢 [Marcin Szczepanski](https://medium.com/@mszczepanski?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
