> - 原文地址：[How to useRef to Fix React Performance Issues](https://medium.com/better-programming/how-to-useref-to-fix-react-performance-issues-4d92a8120c09)
> - 原文作者：[Sidney Alcantara](https://medium.com/@notsidney)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-useref-to-fix-react-performance-issues.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-useref-to-fix-react-performance-issues.md)
> - 译者：[NieZhuZhu「弹铁蛋同学」](https://github.com/NieZhuZhu)
> - 校对者：[regon-cao](https://github.com/regon-cao)、[zenblo](https://github.com/zenblo)

# 如何使用 useRef 修复 React 性能问题

![Photo by the author.](https://cdn-images-1.medium.com/max/3208/1*ychn1nsfNdNxt4fRIz2qkw@2x.png)

Refs 是 React 中很少会使用到的特性。如果你已经读过了官方的 [React Ref Guide](https://reactjs.org/docs/refs-and-the-dom.html)，你会从中了解到 Refs 被描述为重要的 React 数据流的 “逃生舱门”，需谨慎使用。Refs 被视为访问组件的基础 DOM 元素的正确方法。

伴随着 React Hooks 的到来，React 团队引入了 [useRef](https://reactjs.org/docs/hooks-reference.html#useref) Hook，它扩展了这个功能：

> “`useRef()` 比 ref 属性更有用。它通过类似在 class 中使用实例字段的方式，[非常方便地](https://reactjs.org/docs/hooks-faq.html#is-there-something-like-instance-variables) 保存任何可变值。” —— [React 文档](https://reactjs.org/docs/hooks-reference.html)

新的 React Hooks API 发布的时候，我的确忽略了这一点，事实证明 useRef 真的非常有用。

## 面临的问题

我是一名 [Firetable](https://firetable.io/?utm_source=Medium&utm_medium=blog&utm_campaign=How%20to%20useRef%20to%20Fix%20React%20Performance%20Issues&utm_content=MediumArticle) 的软件开发工程师。Firetable 是一个开源的 React 电子表格应用，结合了 Firestore 和 Firebase 的主要功能。其中有一个主要功能是侧面抽屉，它是一种类似于窗体的 UI，用于编辑在主表上滑动的那一行。

![](https://cdn-images-1.medium.com/max/2560/1*1h6w52_v9rflIGJ9WlDPGw.gif)

当用户单击选中表格中的某一个单元格时，可以通过打开侧抽屉的方式编辑该单元格所对应的行数据。 换句话说，我们在侧边抽屉中渲染的内容取决于当前选择的行 —— 我们需要将这行的数据状态记录下来。

将这行数据的状态的放在侧抽屉组件内部是最符合逻辑的，因为当用户选择其他单元格时，它应该**仅**影响侧边的抽屉组件。 然而：

- 我们需要在表格组件里**设置**这个数据状态。我们用的是 [react-data-grid](https://github.com/adazzle/react-data-grid) 渲染表格，并且它接收一个当用户点击一个单元格时会触发的回调。就目前来看，这是我们能从表格中获取选中行数据的唯一途径。
- 但是侧边抽屉组件和表格组件是同级（兄弟）组件，所以不能直接访问彼此的数据状态。

React 的推荐做法是 [提升状态](https://reactjs.org/docs/lifting-state-up.html) 到俩组件最近的父级节点 (以这个为例，父级节点为 `TablePage`)。但是我们决定不将状态迁移到这个组件，理由是：

1. `TablePage` 不保存状态，主要是放置 table 和 side drawer 组件的容器, 两者都不接收任何的 props。我们倾向于保持这种做法。
2. 我们已经在组件树的顶层使用 [React Context](https://reactjs.org/docs/context.html) 来共享了许多的全局数据，并且我们觉得应该将这个状态上升到全局 store。

**注意：即使我们将数据状态放在了 `TablePage`，无论如何我们都将面临下面这个相同的问题。**

问题就是每当用户选择一个单元格或打开侧面抽屉时，全局 context 的更新会使得整个应用发生重新渲染。table 组件可以一次显示数十个单元格，并且每个单元格都有自己的编辑器组件。这会导致大约 650ms 的渲染时间，这个时间太长以至于在打开侧边抽屉的时候会感受到明显的延迟。

![注意单击打开按钮到侧面抽屉动画打开之间的延迟](https://cdn-images-1.medium.com/max/2560/1*DPrtPDYRTq3IBR9_Hsh6dQ.gif)

罪魁祸首是 context —— 这就是为什么要在 React 中使用而不是在全局 JavaScript 对象中使用：

> ”只要提供给 Provider 的值发生变化，所有消费到了 Provider 的后代组件都会发生重渲染。“ —— [React Context](https://reactjs.org/docs/context.html)

到目前为止，虽然我们已经足够了解 React 的状态和生命周期，但现在看来我们依旧陷入了困境。

## 顿悟时刻

在决定使用 `useRef` 之前，我们尝试了几种不同的解决方案。([Dan Abramov 的文章](https://github.com/facebook/react/issues/15156#issuecomment-474590693)) :

1. 拆分 context (也就是创建新的 `SideDrawerContext`) —— table 组件仍然会消费到新的 context，在打开侧边抽屉的时候依旧会 [导致 table 组件的不必要的重新渲染](https://reactjs.org/docs/hooks-reference.html#usecontext)。
2. 将 table 组件放在 `React.memo` 或 `useMemo` 中 —— table 组件依旧是需要通过 `useContext` 拿到侧边抽屉组件的状态，[两种 API 均无法阻止其重新渲染](https://reactjs.org/docs/react-api.html#reactmemo)。
3. 将用于渲染表格的 `react-data-grid` 组件进行 memo —— 这将使我们的代码更加的冗长。我们还发现它阻止了 “必要” 的重新渲染，要求我们花费更多的时间完全修复或者重构我们的代码来实现侧边抽屉。

当再次阅读 Hook APIs 和 `useMemo` 文档的时候，我终于遇到了 `useRef` 相关内容。

> “`useRef()` 比 ref 属性更有用。它通过像在 class 中使用实例字段的方式，[非常方便地](https://reactjs.org/docs/hooks-faq.html#is-there-something-like-instance-variables) 保存任何可变值。” —— [React 文档](https://reactjs.org/docs/hooks-reference.html)

更重要的是：

> “当 ref 对象内容发生变化时，`useRef` 并不会通知变更。变更 `.current` 属性不会引发组件重新渲染。” —— [React 文档](https://reactjs.org/docs/hooks-reference.html)

此时：我们不需要存储侧抽屉的状态。我们只需要引用设置该状态的函数即可。

## 解决方案

1. 将打开状态和单元状态保存在侧面抽屉组件中。
2. 创建这些状态的 ref，并将其存储在 context 中。
3. 当用户单击单元格时，使用之前说的表中的回调去调用 ref 设置数据状态的函数（在侧抽屉内）。

![](https://cdn-images-1.medium.com/max/2944/1*ywF1zWB-Z9RextkazZKKpw@2x.png)

以下代码是在 Firetable 使用的代码缩写版，其中包括了 ref 和 TypeScript 的类型：

```TSX
import { SideDrawerRef } from 'SideDrawer'

export function FiretableContextProvider({ children }) {
  const sideDrawerRef = useRef<SideDrawerRef>();

  return (
    <FiretableContext.Provider value={{ sideDrawerRef }}>
      {children}
    </FiretableContext.Provider>
  )
}
```

**注意：由于函数组件在重新渲染时会运行整个函数体，所以每当 “单元” 或 “打开” 状态更新（并导致重新渲染）时，“sideDrawerRef” 总是能在 “.current” 中获取到最新值。**

事实证明，此解决方案是最佳的：

1. 当前的单元格和打开的状态存储在侧面抽屉组件中 —— 这是放置它的最合逻辑的地方。
2. **当需要时**，表格组件也可以访问其兄弟组件的状态。
3. 当前单元格或打开状态更新时，它只会触发侧抽屉组件的重新渲染，而不触发整个应用程序中的其他组件重新渲染。

你可以在 Firetable 源码中看它是如何被使用的 [GitHub](https://github.com/AntlerVC/firetable/blob/master/www/src/components/SideDrawer/index.tsx#L37)。

## 什么时候使用 useRef

不过，这并不意味着您可以在应用中随意使用。当您需要在特定时间访问或更新另一个组件的状态，但是您的其他组件不依赖于该状态或基于该状态进行呈现时，这是最好的办法。 React 的提升状态和单向数据流的核心概念足以覆盖大多数应用程序架构。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
