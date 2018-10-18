> * 原文地址：[Motion Design Doesn’t Have to Be Hard](https://medium.com/google-design/motion-design-doesnt-have-to-be-hard-33089196e6c2)
> * 原文作者：[Jonas Naimark](https://medium.com/@jnaimark?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/motion-design-doesnt-have-to-be-hard.md](https://github.com/xitu/gold-miner/blob/master/TODO1/motion-design-doesnt-have-to-be-hard.md)
> * 译者：[Ryden Sun](https://juejin.im/user/585b9407da2f6000657a5c0c)
> * 校对者：

# 动效设计可以很简单

![](https://cdn-images-1.medium.com/max/2000/1*mVa7DA7XfZUb0cDpNj-Vng.gif)

动效让 UI 更有表现力和易于使用。即使动效有很多的潜能，但它可能是设计原则中最少被理解的。这可能是因为它是设计家族中最新的成员。视觉和交互设计可以追溯到早期的 GUIs，但动效设计需要等待现代化的硬件来流畅的渲染动画才可以。UI 动效和传统动画的重叠也会让人模糊不清。在 Disney 的 [12 个基本原则](https://en.wikipedia.org/wiki/12_basic_principles_of_animation) 上，需要花费一生的时间来掌握它们，这意味着 UI 动效设计也同样这么复杂吗？人们经常告诉我，设计动效是很复杂的，亦或是选择正确的值是很玄学的。我认为，作为 UI 中的重要领域，动效设计可以也应该是简单的。

### 从哪里开始

动效的主要工作就是通过具象化 UI 元素之间的关系来帮助用户浏览一个 app。动效也有给 app 添加特性的功能，通过带有动画的图标，logo 和插图；然而，构建良好的可用性应该比增加表现度更重要。在展示你特性动画的技巧前，通过专注于导航过渡，让我们先从设计一个坚实的动效基础开始。

### 过渡模式

当设计一个导航过渡是，简易性和连续性是最关键的。为了实现这个目标，我们从动效模式中选择两种类型：

1.  基于一个容器的过渡。
2.  不基于容器的过渡。

#### 基于一个容器的过渡。

![](https://cdn-images-1.medium.com/max/600/1*SX8QU5bCP1ceLQhM1DRr8g.gif)

一些元素比如文本，图标和图片被组合到容器中

如果一个组合包含一个容器，比如按钮，卡片或列表，那么它的过渡设计应该是基于其容器进行动画的。容器通常很容易被发现，因为其可见的边界，但要记住，他们也可能再过渡开始前都不可见，就想一个没有分割线的列表。这个模式可以被分解为三个步骤：

**1.** 使用 [Material’s standard easing](https://material.io/design/motion/speed.html#easing) 让容器进行动画（即它会先迅速加速然后慢慢减速至停止）。在这个例子中，容器的大小和圆角半径会从一个圆形按钮变化到一个充满屏幕的长方形。

![](https://cdn-images-1.medium.com/max/800/1*dv557WZmYFEx_T7Z4XUpFA.gif)

**2.** 改变容器内元素的大小来适应宽度。元素被固定在顶端并且被容器遮盖。这为容器和其内的元素创造了一个清晰地联系。

![](https://cdn-images-1.medium.com/max/800/1*IgUQHrbcRGyGpW8laj6ZWw.gif)

<center>放缓动画来展示元素是怎么被改变大小并被遮罩在容器内的</center>

**3.** 元素在淡出过渡时即容器加速时离开。元素在淡入过渡时及容器减速时进入。流畅地处理效果的技巧是通过在元素迅速移动时让他们淡入/淡出来实现的。

![](https://cdn-images-1.medium.com/max/1000/1*GXG-QKLh4ILSjw3_A9FCfA.gif)

<center>放缓动画来展示元素是怎么使用淡入/淡出的</center>

将这个模式运用到所有包含一个容器的过渡上，建立一种连贯的设计样式。它也会让开始和结束的组合之间的关系清晰明了，因为它们被带有动效的容器连接了起来。为了展示这种模式的灵活性，下面是它运用到5中不同组合上的例子：

![](https://cdn-images-1.medium.com/max/2000/1*uyyN_Xoe3fnvlVi0mvY0nA.gif)

<center>放缓动画来展示开始和结束的组合是怎样被容器链接起来的</center>

一些容器简单地使用 Material’s standard easing 从屏幕外侧划入。它划入的方向受它关联的组件的位置影响。比如，点击一个屏幕左上角的导航抽屉图标会让容器从左侧划入。

![](https://cdn-images-1.medium.com/max/1000/1*kDHIYLL1TQq9brqgkBDcvA.gif)

如果一个容器是从屏幕内出现，它会渐入并且放大。相比于从 0% 开始，它其实是从 95% 开始放大，为了避免过渡动画吸引了过多的注意力。大小改变动画使用了 [Material’s deceleration easing](https://material.io/design/motion/speed.html#easing)，意味着它从最高速度开始，然后慢慢的减速到停止。对于退出来说，容器只是简单地淡出，不进行任何大小的改变。相对于进入动画，退出动画被设计得更微妙，为了将注意力集中到新的内容上。

![](https://cdn-images-1.medium.com/max/800/1*JmunYZEFJzSaV7kCyzYPMg.gif)

<center>放缓动画来展示容器是如何通过淡入和大小改变动画进入的</center>

#### 不基于容器的过渡

一些组合是没有一个容器让过渡在其上设计的，比如点击一个底部导航图标，带用户到一个新的目的地。在这些案例中，一个两步式的模式会被使用：

1.  开始的组合通过淡出退出，接着结束的组合通过淡入进入。
2.  随着结束组合淡入，它也微妙地使用 Material’s deceleration easing 动画来放大。同样，大小改变只被运用到进入组合上，为了强调新的内容。

![](https://cdn-images-1.medium.com/max/800/1*EMaQi0I-Zvt3JHEiqal56Q.gif)

<center>放缓动画来展示不基于容器的过渡是如何淡入/淡出和改变大小的。</center>

如果开始和结束的组合有一个清晰的空间和顺序上的关系，它们可以共享一个动效来加强这个关系。比如导航一个分步组件时，开始和结束的组合在淡入/淡出时共享一个垂直方向的滑动动效。这加强了它们垂直方向的排列布局。当点击一个引导页流程上的下一步按钮，这些组合共享一个横向的滑动动效。从左向右移动加强了流程上的概念。共享的动效使用了 Material’s standard easing。

![](https://cdn-images-1.medium.com/max/1000/1*9pGkX_CRRRlnhIHy4ZvxOA.gif)

<center>放缓动画来展示垂直向和横向的共享动效</center>

* * *

### 最佳的练习

#### 保持简单化

考虑到它们高使用频率和可用性之间的强联系，导航过渡大多数情况下应该偏向于功能性而不是设计感。这并不是说它们**永远不**具有设计感，只是确定设计风格的选择应该根据品牌调整。抓人眼球的动效一般会被用到类似小图标，logo，加载符或是空状态这些元素上。下面一个简单的例子或许不会在 Dribbble 上获得很多关注，但它会让 app 更有可用性。

![](https://cdn-images-1.medium.com/max/1000/1*9vPdOuElDyPZtCHYM3shFA.gif)

<center>放缓动画来展示不同的动效风格</center>

#### 选择正确的持续时间和 easing

导航过渡应该使用合适的持续时间，将功能快速排出优先级但不要太快，这样会变得让人迷惑。持续时间是根据动画需要占据多少屏幕来选择的。因为导航过渡通常占据了屏幕中的大部分空间，300ms 的长的持续时间是一个不错的经验结果。相反，想切换这种小的组件会使用一个 100ms 的短的持续时间。如果一个过渡感觉太快或太慢，以 25ms 为单位增量调整它的持续时间知道达到合适的平衡。

Easing 描绘了动画加速和减速的比率。大多数导航过渡都使用 Material’s standard easing，这是一种不均匀的 easing 类型。这意味着元素会迅速加速然后缓慢减速来将注意力集中到最终的过渡上。这种 easing 类型给了动画一种自然地感觉，因为真实世界的物体并不是立即开始或停止运动的。如果一个过渡看起来很呆板或者很机械，可能是错误地选择了均匀的或是线性的 easing。

![](https://cdn-images-1.medium.com/max/1000/1*UNRu3Rm4_fgj8j8xUGFHvg.gif)

<center>放缓动画来展示不同的 easing 类型</center>

* * *

文章简要介绍的模式和最佳的练习旨在建立一个实用和精细的动效风格。这适用于大多数的 app，然而一些品牌可能有风格表现更强烈的需求。想学习更多的关于动效设计风格的，点击[这里](https://material.io/design/motion/customization.html)阅读我们关于自定义动效的指南。

一旦开始考虑导航过渡，给你的 app 添加特性的挑战就开始了。在这里，简单的模式并不适合，而动画的工艺会真正闪耀起来。

![](https://cdn-images-1.medium.com/max/800/1*N22ZpI-Mvv5vMXTWCx77nQ.gif)

<center>特性动画可以给令人沮丧的错误增添一点趣味。</center>

如果你有兴趣了解更多的关于动效的潜力，一定要阅读我们的 [Material motion guidelines](https://material.io/design/motion/understanding-motion.html#principles)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
