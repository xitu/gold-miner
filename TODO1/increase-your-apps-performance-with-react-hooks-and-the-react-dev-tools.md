> * 原文地址：[Increase your App’s performance with React hooks and the React Dev Tools](https://medium.com/clever-franke/increase-your-apps-performance-with-react-hooks-and-the-react-dev-tools-bfa67e72299c)
> * 原文作者：[Koen Poelhekke](https://medium.com/@kpoelhekke)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/increase-your-apps-performance-with-react-hooks-and-the-react-dev-tools.md](https://github.com/xitu/gold-miner/blob/master/TODO1/increase-your-apps-performance-with-react-hooks-and-the-react-dev-tools.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[wuyanan](https://github.com/wuyanan)，[Jerry-FD](https://github.com/Jerry-FD)

# 用 React Hooks 和调试工具提升应用性能

![](https://cdn-images-1.medium.com/max/5120/1*fftOIi1nxu9tJZ74EaLMMg.png)

在构建 React 应用时，你会发现随着嵌套组件增多，用户界面的某些部分开始变得缓慢迟滞。这是因为，被改变 state 的元素在组件树中的层级越高，浏览器需要重绘的组件越多。

本文将告诉你如何**通过备忘（[memoization](https://en.wikipedia.org/wiki/Memoization)）技术避免不必要的重绘，让你的 React 应用快如闪电。⚡**

***

在 [CLEVER°FRANKE](https://www.cleverfranke.com) 的一个客户端项目中，我做过一个过滤器组件，该组件包含一个展示步数的直方图。

![直方图过滤器组件](https://cdn-images-1.medium.com/max/2000/1*DEaGq8vzh_oESuid9YAlbg.png)

我发现每当拖拽过滤器的操纵杆，动画帧率就会骤降，导致组件失去效用。故此我决定一探究竟。

## 抽丝剥茧

只有明白用户拖拽操纵杆时的内部运作原理，才能确定从何处下手调试。React 使用[虚拟 DOM](https://www.codecademy.com/articles/react-virtual-dom) 来代表 DOM 中真实的元素。每当用户操作界面元素，应用的 state 都会改变。React 会遍历所有受 state 改变影响的组件，计算生成新的虚拟 DOM。React 将新旧版本的虚拟 DOM 进行比较，若发现二者有差异，就将对应的变化更新到真实 DOM 上。该过程叫做 [reconciliation](https://reactjs.org/docs/reconciliation.html)。

操纵 DOM 元素可是一个非常耗费资源的任务。同样，遍历所有受影响组件的 render 函数也很耗时，`render` 函数中的计算量很大时尤其如此。因此我们要尽量减少这些**浪费性渲染**。

***

现在回到我们的案例：因为过滤器组件的 state 由其父组件掌控，所以我的推论是可能发生了不必要的渲染和计算。为了快速确诊，我们要使用 Chrome 调试工具。它有个 **Paint Flashing** 功能，可以将发生改变的 DOM 高亮显示。你可以在 **Rendering** 标签页临时激活该功能：

![在 Chrome 调试工具中激活 Paint Flashing 功能](https://cdn-images-1.medium.com/max/2000/1*ZmzAER8ng6Xo4a67bmV_vw.png)

一经激活，浏览器就会显示哪些元素被重绘了。在本案例中效果如下：

![用 Paint Flashing 功能高亮过滤器组件](https://cdn-images-1.medium.com/max/2000/1*fJNSgWgEbPRlPNeuzbkY2A.gif)

看起来合情合理，只有我操纵的组件引发了 DOM 操纵。也就是说浏览器没有做不必要的绘制。那我们就要进一步深入来探究原因了。

***

为了把 React 组件重绘的情况看得更真切，我们得用 [React 调试工具](https://github.com/facebook/react-devtools)中一个类似的工具。它叫做 **Highlight Updates**，你可以在 React 调试工具的首选项面板中找到它。激活后，它会高亮显示所有正在渲染的组件。如果渲染时间过长，它还会用特殊颜色标识出来。

![用 Highlight Updates 功能高亮过滤器组件](https://cdn-images-1.medium.com/max/2000/1*xdxAnoef3kv0yqa7yE2v-Q.gif)

> React 调试工具使你能够检查 React 组件层级，以及对应组件的 props 和 state。<br />
> 它有浏览器插件（支持 [Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) 和 [Firefox](https://addons.mozilla.org/firefox/addon/react-devtools/)）和[独立应用](https://github.com/facebook/react-devtools/tree/master/packages/react-devtools)（支持 Safari、IE、和 React Native 等运行环境）两种形式。

***

**这里就清晰地揭示了问题所在：当我在一个过滤器上拖拽，包含直方图的另一个过滤器也被重绘了。** 这就是应该被避免的处理器资源浪费。像直方图这样的笨重组件尤其如此。

现在我们知道了问题所在，但还不知道导致界面响应缓慢的原因。为了找到原因，我们可以使用 Chrome 调试工具的 **Performance** 面板。它可以帮助你查看在浏览器在执行某一特定任务的过程中，每一帧具体做了什么。

**关于 Performance 面板的使用细节，不在本文讨论范围之内。但你可以在[这里](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/)找到教程。**

***

我使用 **Performance** 面板记录了过滤器组件中的一次变更。放大火焰图后，我有了以下发现：

![Performance 面板中的火焰图 🔥](https://cdn-images-1.medium.com/max/2534/1*hSQUcxdZ-HHh_o8b8-yIhQ.png)

如你所见，这两个火焰图大体相同。第一张图（在 **Timings** 下方）展示了 React 组件的实际的加载和更新。React 调用了[用户时间接口](https://developer.mozilla.org/en-US/docs/Web/API/User_Timing_API)，所以我们能看到这张额外的图。第二张图展示了主线程上执行的所有任务，这张图更为详细。

我更喜欢用第一张图来看哪些组件性能差，用第二张图深入了解具体哪个函数和计算过程耗时更多。

***

第一次看到 **Performance** 面板的默认火焰图，你可能会被吓到。万幸 React 调试工具也有一个相似功能，在 **Profiler** 标签页中，能够根据[用户时间接口](https://developer.mozilla.org/en-US/docs/Web/API/User_Timing_API)生成同样的火焰图。我认为 React 调试工具中的火焰图更易于理解，而且它还有很多趁手的附加功能：

* 你可以根据组件渲染时长将所有组件排序（见下方截图）。
* 你可以快速浏览不同的渲染记录。
* 你可以点击某组件查看特定渲染阶段的 **props**。

![按渲染时长排列组件](https://cdn-images-1.medium.com/max/2560/1*DZda1hD432v2ylP_KhNJ2g.png)

***

以上图形揭露了罪魁祸首：`Histogram`。特别是渲染第二个直方图（右侧那个），耗费了很长时间（402.8 毫秒！），即使我根本没有拖拽它。我们破案了！接下来就该修复问题、优化组件性能了。

> 注意：我记录性能时打开了 CPU 节流功能，用 1/4 倍速模拟那些并非使用最新版 Macbook Pro 的用户，以此来突显性能问题。

## 提升组件性能

为防止浪费性渲染的发生，我们可以通过备忘技术优化组件。我们要使用 `React.memo` 来记忆组件，用 React 的备忘 hooks `useMemo` 和 `useCallback` 记忆变量和函数。

### React.memo

从 `16.6.0` 版本起，React 就支持高阶组件 [`React.memo`](https://reactjs.org/docs/react-api.html#reactmemo) 了。它等价于 `React.PureComponent`，但只适用于函数组件。社区正逐步从 class 的组件风格转向带有 hooks 的函数组件风格，而 `React.memo` 正是这种组件。

当你用 `React.memo` 包裹一个函数组件时，它会将传入的 props 进行浅层比较。当比较的 props 不一致时，才会重新渲染组件。你也可以自己写一个比较函数，作为第二个参数传入。但要慎用，以避免意外故障。

我们可以将组件分解为更小的组件，并把每个更小的组件都用 `React.memo` 包裹起来。如此你能保证当 props 更新，仅有组件的一部分重新渲染了。但也不要把所有东西都做备忘，因为比较 **props** 所花时间可能要比渲染组件的时间还要长。

在本文案例中，我用 `React.memo` 包裹了过滤器组件（`RangeSlider`）和 `Histogram` 组件。此外，我把直方图分解为包裹组件和 `HistogramBuckets` 组件两部分，将逻辑部分和展现部分剥离开来。

```javascript
const RangeSlider = React.memo(props => {
   ...
});
```

### 备忘 hooks

React `16.8.0` 版本为我们带来功能强大的 hooks，有了 hooks，我们可以轻松备忘组件中的值和回调函数。在引入 hooks 之前，你当然也可以用一个单独的库实现备忘功能，但自从它成为 React 原生库的一部分，集成和塑造工作流变得更加简单易行。

[`useMemo`](https://reactjs.org/docs/hooks-reference.html#usememo) 会记忆一个值，这样就不用在下一轮渲染中重新计算它了。[`useCallback`](https://reactjs.org/docs/hooks-reference.html#usecallback) 记忆的则是回调函数。你可以给二者传入一个依赖数组，该数组包含了组件作用域的值（比如 props 和 state），这些值将在 hooks 内部被用到。每次渲染时，React 都会比较这些依赖值，一旦它们发生改变，React 就会更新备忘的值或函数。

> 注意：React 为了尽可能快地进行比较，使用了比较算法 [Object.is](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is#Description) 来优化比较的速度。也就是说，如果你把对象或数组的新实例作为 props 传入，比较时该算法会返回 `false`，并重新计算备忘的值。

### 传入备忘的 props

在本例中，未经使用 `React.memo` 的过滤器组件需要优化。这曾是父组件设置 props 的方式：

```javascript
function handleChange(value => {
  ...
});

<RangeSlider  
  value={[minValue, maxValue]}  
  onChange={handleChange}
/>
```

每渲染一次，都要创建 `handleChange` 的一个实例，并传入一个新的数组实例作为 props。这就导致 `RangeSlider` 组件总是更新，尽管有 `React.memo` 包裹，因为 `Object.is()` 比较算法总是返回 `false`。为了精确优化，我得用下列代码重构：

```javascript
const handleChange = useCallback((value) => {
    ...
}, []);

const value = useMemo(() => [minValue, maxValue], [minValue, maxValue]);

<RangeSlider  
  value={value}  
  onChange={handleChange}
/>
```

如果依赖数组为空，那么 `handleChange` 则仅在挂载时更新。无论 `minValue` 或 `maxValue` 何时更改，`value` 总会返回一个新数组。

我对 `Histogram` 组件做了同样的优化，`Histogram` 组件把 props 传到 `HistogramBuckets` 子组件中。

> 小提示：要想快速找出两次渲染中哪些 props 发生了变化，可以用这个精巧的 hooks：[useWhyDidYouUpdate](https://usehooks.com/useWhyDidYouUpdate/)。

## 成果

通过方便快捷的优化，组件的性能得到了显著提升。经过备忘优化后，在相同的操作下，`Histogram` 组件的渲染时间缩短到了 0.5 毫秒。比起原来的 72.7 毫秒加上第二个直方图消耗的 402.8 毫秒，**这可是超过千倍的提速啊！🤩** 最终成果就是，仅用了极小的努力，就获得了更流畅的用户体验。

![备忘优化后的直方图渲染时间](https://cdn-images-1.medium.com/max/5112/1*iGs_fQ2NfXbeLNO0xVQ9GQ.png)

***

## 加入 C°F

另外，如果你被本文惊艳到了，CLEVER°FRANKE 的大门永远为达人敞开哦。来[我们的招聘传送门](http://jobs.cleverfranke.com/)看看，如果感兴趣，欢迎向我们展示你的超能力。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
