> * 原文地址：[Delightful animations in iOS](https://medium.com/flawless-app-stories/delightful-animations-in-ios-7607e49945eb)
> * 原文作者：[Roland Leth](https://medium.com/@rolandleth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# iOS 中赏心悦目的动画

![](https://cdn-images-1.medium.com/max/2560/1*LCqWZwVc8XhXjrlESW0zeA.png)

我们热爱动画。

一方面，它们引导我们的视线，同时也是画龙点睛的一笔，增添了额外的关注点甚至一点 **感情**。比起静态的 UI，我们更偏爱生动形象并且能给我们反馈，可以交互的 UI。但是太多了就会造成不良的后果，所以让我们来探索是否可以给一款 app 增加恰到好处的润色。

### 在 `touchDown` 时改变一个按钮的大小或颜色

我们通常在 `touchUpInside` 上设置点击事件，其原因是可以让用户有机会改变他的主意，但由 `touchDown` 处理的是按钮物理上的实际触摸。我们可以在此时让 UI 响应用户的交互，并通过改变外观让他们知道一些事 **确实** 已经发生了。

但是仍然不要太过分。
我以 `0.97` 的 `scale` 开始，背景色的 `alpha` 为 `0.85`，`borderWidth` 增加 `1` 或 `2`，或者是它们其中两者的组合，超过两个的话就有点过了。从这开始，你还有很多选项，仅仅举几个例子：增加 scale 缩放比例，改变 `y` 值，添加一个轻微的阴影，当一个按钮被不停地点击时添加一个 “抖动” 动画，就好像按钮在跟你说 **我已经知道你点了我了，你还想干嘛？**，还有增加字体的粗细，抑或是改变背景颜色。

这类动画不必很显眼，它们唯一的目的就是画龙点睛，以及给用户一些信息，告诉他们一些事情 **确实** 已经发生了。

![](https://cdn-images-1.medium.com/max/800/1*IK5eAI5eafqPS677Zs-GCw.gif)

### 添加到购物车或类似东西时

就像苹果在 Safari 中添加书签的动画一样，我们也可以把添加到购物车时做成这样的动画，这样的话就可以把用户的视引导到购物车按钮上。如果按钮上有小数字的话，就添加个缩放动画，例如像弹簧一样的动画。或者直接模仿苹果的原生效果，把整个图标添加动画就好像你买的东西进入了购物车一样。

还有，我们可以让 UI 对用户的操作进行了相应，这样也可以提示用户下一步该做什么。它能引导并告诉用户发生了什么以及 **哪里** 发生了改变。你也许会觉得在把东西添加到购物车很多次之后，用户自然就会知道购物车在哪里了，也许你是对的，但是承认它并没有坏处。

### Call to action

With a proper hierarchy, a call to action button should stand out already. But, sometimes, that isn’t possible or it’s not enough. So an approach would be to add a subtle animation to it. It could be a pulse (scale between `1.03` and `0.97` with a slow duration and with a delay between animations), a wiggle (rotate a few degrees in quick succession, but with a great delay between them), or maybe a pulse of the background, text color, text size, border width or border color. But, again, don’t pick too many at once.

![](https://cdn-images-1.medium.com/max/800/1*NAwiqTIbcce-WuTmvhlL3w.gif)

### Creating, deleting and submitting

The same tactic can be done when an event or error occurs.

When submitting a form, but one of the `UITextFields` is empty, add a subtle shake to it, or flash its border/text to red, attracting the user’s attention to where the problem is.

If the user added a new item that already exists, add a background flash to the existing item, or maybe shake it, depending on its size, location or content — if it’s a large item, prefer something really subtle, since it will have a big impact due to its size.

When the user successfully creates an item, instead of simply reloading the UI, slide the new item in, fade it in or both; or use the built-in `tableView.insertRows(at:with:)` animations. The same applies for deleting an item, but in reverse.

![](https://cdn-images-1.medium.com/max/800/1*2Ikp1rb46s7ctWm4Rx68Cg.gif)

### Selection

Think of a radio button, or a checkbox. In this particular case, the animation’s only purpose is to add a nice finishing touch, as there’s not much real UX value. It does add a visual confirmation that lasts until after the finger was lifted, though. A checkbox could have its checkmark drawn, just like you draw one on a sheet of paper; a radio button could have its center filled, like so:

![](https://cdn-images-1.medium.com/max/800/0*m9ePRKHt7KycWrqJ.gif)

### Tips

Looking at [my post](https://rolandleth.com/lthradiobutton) about the above radio button animation, we can see that I’ve broken the animation down into really small steps. The point is to:

1.  Properly understand what the animation consists of.
2.  Have actionable steps that are easy to implement.
3.  Have steps small enough that are easy to change or remove, if needed.

This can’t be stressed enough: don’t go overboard, start small. Exaggerated animations are more harmful than no animations. Start with small values, small durations and a few properties, then work your way up from there. It’s better to have something subtle that a small percentage of your users notices, than to have something obtrusive that a high percentage of your users hates (or even a small one).

A gist with a few examples can be found [here](https://gist.github.com/rolandleth/421dcde6757b942ac7102fea435fd3c3) and the radio button animation can be found in the control itself, [here](https://github.com/rolandleth/LTHRadioButton).

Happy animating!

* * *

_You can find more articles like this on my blog, or you can subscribe to my_ [_monthly newsletter_](https://rolandleth.us19.list-manage.com/subscribe?u=0d9e49508950cd57917dd7e87&id=7e4ef109bd)_. Originally published at_ [https://rolandleth.com](https://rolandleth.com).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
