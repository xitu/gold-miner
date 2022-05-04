> - 原文地址：[Deconstructing the Iconic Apple Watch Bubble UI](https://codeburst.io/deconstructing-the-iconic-apple-watch-bubble-ui-aba68a405689)
> - 原文作者：[Blake Sanie](https://medium.com/@blakesanie)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/deconstructing-the-iconic-apple-watch-bubble-ui.md](https://github.com/xitu/gold-miner/blob/master/article/2021/deconstructing-the-iconic-apple-watch-bubble-ui.md)
> - 译者：[ZhiZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[Hoarfroster](https://github.com/PassionPenguin)

# 解构标志性的 Apple Watch Bubble UI

![Photo by [Raagesh C](https://unsplash.com/@raagesh?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*N-GwBFwqZbDSNOYy)

当第一款 [**Apple Watch**](https://en.wikipedia.org/wiki/Apple_Watch) 在 2015 年推出的时候，我对 [**WatchOS**](https://en.wikipedia.org/wiki/WatchOS) 的主屏幕设计感到震惊。它的布局不同于标准的网格式布局，而是提出了一种原始的视觉动态界面。

五年后，当我打开这款具有光滑又时尚 UI 的手表时，仍然感到敬畏。但是，从工程学的角度来看，我仍然对这种布局的底层原理感到困惑。

作为一名经验丰富的应用程序开发人员，我知道构造导航流程和布局对于任何应用程序的基础都至关重要。Apple 全部都做到了，并且还具有一定的灵活性，用户的满意度和好奇心。

当然，我喜欢使用 [**CSS Grid**](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)、 **[Flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox)** 以及其他 Web 和移动端技术来构建可靠的应用程序布局，但是由于 Apple Watch Bubble UI 背后涉及的复杂性，这些方法并不适用。**我决定研究这种布局的各个方面，尤其是探索可以编排布局的视觉设计的几何形状和设计的数学原理。**

免责声明：**此用户界面的基本功能和设计的讨论仅源于我的个人见解；苹果很有可能已经实现了这一布局，甚至可能有很大不同。**

## 布局的基础几何

让我们从气泡的基本蜂窝网格开始。我们稍后将处理布局中气泡的大小调整以及其他相关效果。如下图所示是每隔一个完整的气泡行出现一个少一个气泡的行，以及最后一行的气泡是不完整的居中气泡行。

![模型起点：蜂窝布局](https://cdn-images-1.medium.com/max/4474/1*LbdzqEFn6o-Cew0OEXs1Zw.png)

如下图所示，UI 可以分为三个同心区域：**center（中心）**，**fringe（边缘）**，和 **outer（外部区域）**。在针对气泡的大小和位置在屏幕上的变化进行建模时，前两个区域至关重要。同时在针对气泡滑动的所有情况时，如果某个区域包含该气泡的中心圆点，则该气泡被判断为在该区域内。

![我建立的图形模型展示了 Bubble UI 布局的核心区域和可变尺寸](https://cdn-images-1.medium.com/max/2000/1*MvRtWHdTrozBli7ydT4CBA.gif)

**中心区域**定义为以 `x 半径` 和 `y 半径` 为边界，并且具有`拐角半径`修饰的处于中心的（圆角）矩形。中心区域中的所有气泡均以其 **maximum size**（最大尺寸）渲染。

**边缘区域**边缘区域定义为中心区域外部在其外边缘的一定 `fringe width（边缘宽度）`内的空间。此区域用于包含每个气泡**从最小尺寸到最大尺寸的过渡**。当气泡从外围进入该区域时，气泡以其最小大小进行移动，该大小线性增加，直到到达中心区域时达到其最大大小。

**外部区域**外部区域定义为 2D 画布上不包括中心和边缘区域的所有空间。在这个区域内，所有气泡都被**最小化**。

#### 圆形和非圆形矩形区域如何处理？

**当 `x 半径`，`y 半径`和`拐角半径`均相等时**，中心和边缘区域为圆形。此外，**当`拐角半径`为零时**，中心区域变为非圆形；但是，边缘区域的拐角仍将以边缘宽度的半径进行倒圆角（棱角切削成圆弧面）。

## 根据气泡位置计算气泡大小

让我们深入研究布局的基本技巧，让我们使用定义的区域来开发数学模型，该模型根据气泡在屏幕上的位置来计算气泡的大小。

首先，我们需要定义另一个关键的视觉地标：拐角区域。

![在 Bubble UI 图形的模型上可视化角落区域](https://cdn-images-1.medium.com/max/3128/1*DcjuhEvJjcGloC630vqEIw.png)

**拐角区域**定义为由画布的拐角以及中心区域的内部拐角（从边缘的嵌入的`拐角半径`）界定的四个区域。在拐角区域，尺寸相对于内部拐角沿径向（指沿半径的方向的）保持恒定。相比之下，拐角区域外部的气泡在 x 或 y 位置不变时保持大小不变。

注意： **如果中心区域是圆形，则所有四个内部角均位于中心。否则，如果中心区域形成一个非圆角的矩形，则内部拐角不会偏离矩形的外边缘。**

#### 步骤 1：确定气泡是否在角落区域

乍一看，这似乎需要四个单独的操作。但是，我们可以寻找所有拐角区域之间的相似性，然后就会产生一个表达式：如果气泡在拐角区域内，则

```
abs(bubble.x) > x_radius and abs(bubble.y) > y_radius
```

因为变量 `x radius` 和 `y radius` 本质上是正的。

#### 步骤 2：确定包含气泡的同心区域

如前所述，气泡大小有一部分是取决于哪个同心区域包含气泡的中心。

**如果气泡在拐角区域**，首先根据[**勾股距离公式**](https://www.purplemath.com/modules/distform.htm)计算其到对应内角的距离：

```
distance_to_internal_corner = sqrt((abs(bubble.x) - (x_radius - corner_radius))^2 + (abs(bubble.y) - (y_radius - corner_radius))^2)
```

如果此距离小于`拐角半径`，则气泡被判定被为在中心区域；如果此距离小于`拐角半径`和`边缘宽度`的总和，则气泡被判定为在边缘区域。否则，气泡位于外部区域。

如果气泡未限制在拐角区域内，就使用以下表达式计算其到画布中心的距离：

```
distance_to_center = max(abs(bubble.x), abs(bubble.y))
```

如果该距离小于对应的半径（x 或 y），则在中心区域内。否则，如果距离仍小于半径和`边缘宽度`的总和，则气泡位于边缘区域中。否则，气泡位于外部区域。

#### 步骤 3：计算气泡大小

中心区域内的气泡以最大尺寸渲染，而外部区域内的气泡则完全未被放大。

**边缘区域是个有趣的区域**，因为该区域需要负责气泡的大小状态之间的过渡。

所有气泡的当前大小变化都**与气泡通过边缘区域的进度成比例**。换句话说，距离外边缘 30％ 的气泡已进行了 30％ 的放大，而距离内边缘 20％ 的气泡已进行了 80％ 的放大。

因此，计算出气泡的当前大小是通过将气泡到中间区域的距离（从范围(0，`边缘宽度`)到范围(`最大大小`，`最小大小`)）进行插值来完成的。计算如下：

```
current_size = max_size + distance_to_middle_region / fringe_width * (min_size - max_size)
```

这里的 `**distance_to_middle_region**` 可以表示为

```
distance_to_internal_corner - corner_radius
```

如果气泡在拐角区域，否则

```
max(abs(bubble.x)- x_radius, abs(bubble.y)- y_radius))
```

非常棒！用户每次滚动时都需要对每个气泡重复进行此计算。看起来很简单，对吧？但实际上，这只是冰山一角。尽管许多人会对当前的模型状态感到满足，但我想进一步完善模型这样就可以完成在界面上复刻 Apple 的壮举。

## 高级功能

#### 紧凑

我不经意间注意到 Apple Watch UI 可以优化气泡的紧凑性。每当气泡在边缘区域发生尺寸转换时，它们都与最近的气泡保持相同的装订线宽度。

![[Gifer] 上的动画(https://gifer.com/en/XbVD)](https://cdn-images-1.medium.com/max/2000/1*23GQLo9bhAzjCWcbpzGuFA.gif)

当前，我们的模型始终会使气泡之间保持恒定的距离。下面的图表显示了我们当前的进度与最终目标的对比（前瞻）。

![不紧凑（左）与紧凑（右）](https://cdn-images-1.medium.com/max/2000/1*xJ5tgmf8VXKJzxhx0PKb_w.gif)

实现最佳的紧凑性会带来新的复杂性，从现在开始，除了操纵尺寸之外，我们还需要直接操作气泡的位置。

与之前相似，我们将根据包含同心区域的每个气泡以及气泡是否位于拐角区域来平移每个气泡。

**中心区域中的气泡已经很紧密了**，因此不需要移动。

外部区域中的气泡向内移动直到这个气泡的最大大小。如果**这些气泡位于拐角区域，它们将平移到相应的内部拐角或画布的中心**。

![基于画布上的位置平移的方向](https://cdn-images-1.medium.com/max/3164/1*RjPI_7Bfb3PHZc1xeUFxxQ.png)

边缘区域再次负责这**两个状态之间的过渡**。就像气泡的大小一样，气泡平移距离的多少由到中心区域的距离（范围 (`边缘宽度`，0) 到范围 (`最大大小`，0)）的插值得出。（内插或称插值（英语：interpolation）是一种通过已知的、离散的数据点，在范围内推求新数据点的过程或方法。）

```
translation_magnitude = distance_to_middle_region / fringe_width * max_size
```

之前的方向规则同样适用。

#### 引力

这个特性是我用自己的想象力想象出来的一个概念 —— Apple 的气泡布局不一定会展示它。尽管如此，我想通过将远处的气泡吸引到中心区域来进一步提高气泡之间的紧凑性。

![无重力（左）与高重力（右）](https://cdn-images-1.medium.com/max/2000/1*Ii03shSoDoKudknlylZcxw.gif)

出乎意料的是，实现引力这个特性比迄今为止进行的任何其他解构转换都要容易。

简而言之，引力效应涉及将外部区域中的气泡平移到边缘区域，与气泡到边缘的距离成正比。为了达到我们的目的，我们定义了气泡到边缘的距离与位移之间的线性关系，但是这可以通过许多不同的方式（指数，平方，平方根等）来实现。

![在无重力的情况下，外部区域的气泡相隔**最大尺寸**](https://cdn-images-1.medium.com/max/2002/1*GGG_QXIYZ3zSZkTYPzqG3w.png)

![非零重力有效地缩小了外部区域中气泡之间的分离距离](https://cdn-images-1.medium.com/max/2002/1*1CkXWgyAai1_8npyjq_kGA.png)

处于外部区域中的气泡将要被移动距离可以被描述为 “紧凑性” 所表达的数量值，**加上**一个额外值：

```
distance_to_fringe_region * gravitation
```

其中`到边缘区域的距离` 可以表达为

```
distance_to_middle_region - fringe_width
```

以及`引力`是一个比例常数。这个值为 0 时表示没有重力作用，这个值为 1 时则表示在外部气泡之间没有分离。当引力介于这两个值之间时，效果最好。

## 从理论到应用

作为一个对 [**React.js**](https://reactjs.org) 着迷的 Web 开发人员，我想向设计和开发社区开源我的这次研究发现。按照本文描述的步骤，我实现了一个[**源的 React 组件**](https://bubbleui.blakesanie.com)，可以供大家使用。

具有所有讨论的可控变量（甚至更多）的这种抽象是高度可配置的。该布局还允许使用自定义气泡组件以实现基本的可定制性。我迫不及待想看到您使用此布局创建属于你的内容！

![取自 [**React-Bubble-UI**](https://bubbleui.blakesanie.com/) 的现场演示，精美的展示了美国股市前 500 强公司,](https://cdn-images-1.medium.com/max/2000/1*Hq0zEG3n8dsY-8hAhk-byQ.gif)

## 结论

感谢您阅读我的文章，希望您能从中获得启发！随时在评论部分中留下反馈或问题。

#### 资源

1. [在线 Demo](https://bubbleui.blakesanie.com/#/demo)
2. [Github 仓库](https://github.com/blakesanie/React-Bubble-UI)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
