> * 原文地址：[Delightful animations in iOS](https://medium.com/flawless-app-stories/delightful-animations-in-ios-7607e49945eb)
> * 原文作者：[Roland Leth](https://medium.com/@rolandleth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)

# iOS 中赏心悦目的动画

![](https://cdn-images-1.medium.com/max/2560/1*LCqWZwVc8XhXjrlESW0zeA.png)

我们热爱动画。

一方面，它们引导我们的视线，同时也是画龙点睛的一笔，增添了额外的关注点甚至一点 **感情**。比起静态的 UI，我们更偏爱生动形象并且能给我们反馈，可以交互的 UI。但是太多了就会造成不良的后果，所以让我们来探索一些可以给一款 app 增加恰到好处的润色的动画。

### 在 `touchDown` 时改变一个按钮的大小或颜色

我们通常在 `touchUpInside` 上设置点击事件，其原因是可以让用户有机会改变他的主意，但在现实生活中，按下按钮则执行事件，这应 `touchDown` 处理。我们可以在此时让 UI 响应用户的交互，并通过改变外观让他们知道一些事 **确实** 已经发生了。

但是仍然不要太过分。
我以 `0.97` 的 `scale` 开始，背景色的 `alpha` 为 `0.85`，`borderWidth` 增加 `1` 或 `2`，或者是它们其中两者的组合，超过两个的话就有点过了。从这开始，你还有很多选项，仅仅举几个例子：增加 scale 缩放比例，改变 `y` 值，添加一个轻微的阴影，当一个按钮被不停地点击时添加一个 “抖动” 动画，就好像按钮在跟你说 **我已经知道你点了我了，你还想干嘛？**，还有增加字体的粗细，抑或是改变背景颜色。

这类动画不必很显眼，它们唯一的目的就是画龙点睛，以及给用户一些信息，告诉他们一些事情 **确实** 已经发生了。

![](https://cdn-images-1.medium.com/max/800/1*IK5eAI5eafqPS677Zs-GCw.gif)

### 添加到购物车或类似动作

就像苹果在 Safari 中添加书签的动画一样，我们也可以把添加到购物车时做成这样的动画，这样的话就可以把用户的视线引导到购物车按钮上。如果按钮上有小数字的话，就添加个缩放动画，例如像弹簧一样的动画。或者直接模仿苹果的原生效果，把整个图标添加动画就好像你买的东西进入了购物车一样。

还有，我们可以让 UI 对用户的操作进行了相应，这样也可以提示用户下一步该做什么。它能引导并告诉用户发生了什么以及 **哪里** 发生了改变。你也许会觉得在把东西添加到购物车很多次之后，用户自然就会知道购物车在哪里了，也许你是对的，但是强调它并没有坏处。

### 事件响应

通过合适的层级结构，一个按钮事件的响应应当已经很突出了。但是有时候却不可行或者根本不够。所有有一种方法是给他添加一个轻微的动画，也许是一个有节奏的跳动（scale 在 `1.03` 和 `0.97` 间范围内的带有延时的慢动作变化），或者一个抖动（快速地连续旋转几度，中间延迟较长），又或者是背景，文字颜色或大小，描边的宽度和颜色等等的变化。但是要注意一次性不要变化太多了。

![](https://cdn-images-1.medium.com/max/800/1*NAwiqTIbcce-WuTmvhlL3w.gif)

### 创建、删除和提交

当发生了错误的时候可以采用相同的策略。

当提交一个表单时，如果其中一个 `UITextFields` 为空，就给它添加一个轻微的抖动，也可以给边框或者文字添加红色的闪烁的效果，这样才能吸引用户并告诉他们问题出在哪了。

如果用户想添加了一个已经存在的东西，就让那一项的背景色突出显示出来或者抖动一下，这主要取决与它的大小，如果很大的话，非常轻微的动画会更好，因为它的尺寸比较大的缘故，很微小的动画反而会更加显眼。

当用户成功创建新的一项时，比起简单的刷新 UI，把新的那一项滑入或者淡入，或者也可以使用 `tableView.insertRows(at:with:)` 自带的动画会更好。反之亦然，删除一项也可以这么做。

![](https://cdn-images-1.medium.com/max/800/1*2Ikp1rb46s7ctWm4Rx68Cg.gif)

### 选择

想象一下单选按钮或者复选框，在这特殊的情况下，动画的唯一作用就是润色，因为并没有太多真正的用户体验价值。这样确实添加了一个视觉上的确认效果，直到手指抬起。一个复选框可以绘制复选的标记，就好像你是在纸上把它画出来一样。至于单选按钮，则可以给它的中心填充，例如下面的效果：

![](https://cdn-images-1.medium.com/max/800/0*m9ePRKHt7KycWrqJ.gif)

### 小窍门

你可以看看我的关于上面的单选按钮动画的 [帖子](https://rolandleth.com/lthradiobutton)，我把动画拆分成了很多非常细小的步骤，核心部分则是：

1. 正确理解动画的组成部分。
2. 采取易于实施的可操作步骤。
3. 如果需要的话，使每一步骤足够的小以便于更换或移除。

再次强调：不愠不火，从细节开始做。比起没有动画，夸张的动画反而更加有害。从短小精悍的动画开始吧，只变化几个属性！比起十分刺眼的动画，能让用户能注意到的微妙细节上的动画会更好。

有一些例子的要点可以在 [这里](https://gist.github.com/rolandleth/421dcde6757b942ac7102fea435fd3c3) 找到，单选按钮的动画可以在控件的找到 [这里](https://github.com/rolandleth/LTHRadioButton) 有单选按钮的动画，它们可以在自身的控件中找到。

祝你和动画相处愉快！

* * *

你可以在我的博客里找到更多文章，或者订阅 [**每月的推送**](https://rolandleth.us19.list-manage.com/subscribe?u=0d9e49508950cd57917dd7e87&id=7e4ef109bd)。**原文链接**：[https://rolandleth.com](https://rolandleth.com)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
