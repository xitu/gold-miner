> * 原文地址：[Delightful animations in iOS](https://medium.com/flawless-app-stories/delightful-animations-in-ios-7607e49945eb)
> * 原文作者：[Roland Leth](https://medium.com/@rolandleth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/delightful-animations-in-ios.md)
> * 译者：
> * 校对者：

# Delightful animations in iOS

![](https://cdn-images-1.medium.com/max/2560/1*LCqWZwVc8XhXjrlESW0zeA.png)

We all love animations.

On one hand, they help our eyes be guided, but they also bring a nice finishing touch, a bit of extra care, a bit of _emotion. W_e also prefer a lively UI to a static one, a UI that gives us feedback, that interacts back with us. But, as with anything, too much _will_ be harmful, so let’s explore a few finishing touches that can be added to an app without overwhelming it.

### Changing a button’s frame and/or color on `touchDown`

We usually put a button’s action on `touchUpInside` and the reason for that is to give the user a chance to change his mind. But the physical action performed is the actual touch of the button, which is handled by `touchDown`. At this point, we can have the UI respond to the user’s interaction, to let them know something _did_ happen, by modifying the appearance.

Don’t go overboard with this, though.  
I’d start with a scale of `0.97`, a background `alpha` change to `0.85`, a `borderWidth` increase of `1` or `2`, or a combination of two them — more than two will be too aggressive. From here, you have many other options and to name a few: scale increase, `y` position change, adding a slight shadow, a ”wiggle” animation while the button is kept pressed (as if the button was asking _I got your touch, what now?_), a font weight increase or a background color change.

This kind of animation doesn’t have to stand out. Its only purpose is to bring a nice finishing touch and to give the user the information that something _did_ happen.

![](https://cdn-images-1.medium.com/max/800/1*IK5eAI5eafqPS677Zs-GCw.gif)

### Adding to cart or similar

Just like Apple animates the add bookmark action in Safari, the same could be done when adding to cart. Guide the user’s eyes to where their action had an effect — the cart button. If you have a badge on it (most likely), animate its scale, for example, with a nice bounce effect. Or, just like Apple does, animate the whole icon and maybe the item ”into” it, as well.

This, again, serves as a nice finishing touch and makes the UI respond to the user’s action, but it also serves as a ”here’s where to go next”. It helps the user be guided of what happened, but also to _where_ the change happened. You might say ”after adding to cart 15 times, the user will know where to look for it” and you’d be right; but it doesn’t hurt to confirm it.

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
