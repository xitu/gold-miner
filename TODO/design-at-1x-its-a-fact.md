>* 原文链接 : [Design at 1x—It’s a Fact](https://medium.com/shyp-design/design-at-1x-its-a-fact-249c5b896536)
* 原文作者 : [Kurt Varner](https://medium.com/@kurtvarner)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [wildflame](https://github.com/wild-flame/)
* 校对者: [tanglie1993](https://github.com/tanglie1993/),[llp0574](https://github.com/llp0574)

# 移动开发中用 1x 视觉稿设计的好处

那我就开门见山了：我确信你们很多人都已经知道 1x 设计的好处了。但是呢，言语和风声总不会那么一致。在移动设备上，到底是使用 1x 设计稿更好，还是 2x 设计稿，一直没有达成共识。

#### 背景简述

当我刚加入 [Shyp](http://shyp.com) 的时候，我们为 iOS 进行 2x 分辨率的设计，而为 Anrdroid 端进行 3x (xxhdpi) 的设计，那段回忆简直像一坨屎一样。我们到底为什么要这样做？

1.  进行低像素，非 retina 的设计是反直觉的。实际上，我已经有很长时间没有见过 iPhone 3GS 了。
2.  那时，1：1 比例的设计使我们可以很方便的在设备上预览我们的草稿，我们使用 iPhone 5 和 Nexus 5 来做测试，那些低于 2x 和 3x 的设计稿，在屏幕上都是模糊不清的。
3.  抗拒改变 — 正因为我们所有的设计都是 2x，重新设计他们是一份费力的事情。（后来我们把它们全部重新设计成 1x 了）

这些理由真令人伤感，但却都不能和 1x 设计的好处相媲美。

### 使用 1x 视觉设计稿的 7 条理由

关于到底是 1x 设计更好，还是 2x 设计更好其实已经没必要再争论了。鉴于我从没见过任何一个关于 1x 好处的列举，我把这些好处在下面列出来了。

### 1\. 不用数学

如果你要设计非 1x 的设计稿，那么你就要步入那条无休无止的为不同分辨率转换像素尺寸的道路了。

不信啊，你上呗 —— 在 2x 分辨率下把这些下面这些 pixel 转换到 point：36px 的字体大小，左右各是 40px 内边距，上下则是 20px。你算完了，好那在 3x 分辨率下面再试一次吧。

你觉得这一切很有趣吗？

并不，我也一样。而且如果像素还不是偶数的话，那简直是一场灾难。“那啥，请在那上面加上 16.66pt 的缩进。”

### 2\. IOS 与 Android 保持一比一的比例

额的神啊。这节省了多少时间。所有的设计都在 iOS 和 Android 之间无缝衔接，字体大小，图标，空白。你懂的，就是那些设计指南里的好东西，非常容易的就重用上了。

### 3\. 导出直观

好了，现在假设我在按 2x 来设计稿子，并且打算把它导出为资源 (assets) 。对于 iOS，你需要按照 .5x、1x 和1.5x 导出（实际上是 1x、2x 和 3x）。毫无逻辑可言。对于 Android 来说，则有五个不同的值，即 .5x、.75x、1x、1.5x、2x（实际上是1x、1.5x、2x、3x、4x）。

当你按照 1x 设计时，事情就变简单了，1x 就是 1x，

下面是在 Sketch 里面 1x 设计稿和 2x 设计稿的导出界面的比较：

![](http://ww2.sinaimg.cn/large/a490147fgw1f5l6ixmm78j20m80own0l.jpg)

### 4\. 跟工程师们使用同样的标称

<span class="markup--quote markup--p-quote is-other" data-creator-ids="anon">你的设计难道不应该和写代码实现它的人在相同的次元么？是的，当然应该。工程师们都用 point，不用 pixel。</span>

[Jiashu Wang](https://twitter.com/jiashuw)，Shyp 的一个 iOS 工程师对这个问题是这样回复的：

> 工程师用 point（不用 pixel），所以 1x 的 Sketch 设计对我们来说刚刚好，我们可以直接在 Sketch 里面找到需要的值而不需使用比例系数（scale factors）。

> 比方说，如果用 2x 的 Sketch 文件，iOS 工程师就会按照下面的步骤执行：
> —— 在 sketch 里查看一个 UI 元素的值，比方说是 50
> —— 接下来开始算：50（元素在 sketch 里的值）/ 2（设计稿对应的系数）=
> —— 在代码里写上 25。

> 现在，我们用 `1x` ，我们看到 25 ，就是 25。

_（作者注：是的，我们的工程师直接用 Sketch，酷毙了！）_

不仅工程师会爱上你，实际上还使得设计中犯得错误更少了。那些关于像素调整的不必要的品控都可以避免掉了。

### 5\. 设备上的预览仍然可以使用

记得我之前说 Sketch 里的 1x 的设计图预览会变得模糊不清么？其实那早就不是问题啦。现在所有一切都可以无缝的在设备上预览了。

对于 Android 设备来说，也可以 Photoshop 和 Skala 达到同样的效果。Duang！一切都可以完美缩放了！

### 6\. 文件更小，性能更棒

这样你的设计文件会更小，特别是当你还使用了位图（bitmap）的时候。在 Sketch 里，如果一个页面 (page) 里包含了过多的画板 (artboard) ，延迟就是一个很头疼的事情了，而更小的画板意味着更好的表现。

### 7\. 保证未来

按照 1x 来设计避免了以后 Apple 和 Google 推出新的分辨率又要再做一次转换的问题。还记得苹果发布 iPhone 6 Plus 的时候，大家每天念叨着该如何为这个屏幕做设计么？这个困惑导致了后来出现来一系列关于如何做转换的[资源](http://www.paintcodeapp.com/news/iphone-6-screens-demystified)。

按照非 1x 下设计总给人一种随意的感觉，总有更多新的屏幕分辨率会出现。只有 1x 的设计才是恒久远的。

-

更新 1：[Dave Bedingfield](https://twitter.com/dbedingfield)，推特的一名设计师，指出了按照 1x 另一个重要的优点。

### **理由8 — 过多空白带来的假象**

在 2x 和 3x 设计时往往会给人一种错觉，那就是“我还有很多的空间”。特别是对于那些刚入行的设计师来说，他们会在高像素的空间里放入更多的内容，容易造成点击区域过小或者显示不清晰的问题。而按照 1x 设计则避免了这样的影响。

> Designing for 2x can also cause designers to experience a placebo effect: designing at 2x is quite appealing, visually, and can mask. However, a baseline of 1x is still the optimal “starting point” in and I actually think our designs benefit from this constraint (a design that “works” at 1x will also “work” 2x; we avoid fooling ourselves into thinking that 2x provides more space to “cram” elements). The temptation to design for higher resolutions can cause tap targets to shrink, type sizes to decrease, legibility to suffer, etc.. Designing at 1x can help protect from that.

本段引用，译文如下：

> 按照 2x 的设计也容易给人造成一种假象：在视觉上，2x 的设计的确更具诱惑。但是， 1x 设计仍然是设计的“出发点”，我甚至认为，1x 的设计正是受益于它的限制（ 1x 的设计在 2x 下仍然是可用的；避免了让自己误以为还有更多空间可以“塞下”更过的元素）。在更高的分辨率下做设计会导致可以点击的空间缩水，可以输入的空间变少，内容的辨认度下降等等...按照 1x 设计则帮助我们规避了这些问题。

Dave 是我认识的最了解在不同平台设计这一学问的人了，这也带给了推特的很多独创性的想法。很多年前他给推特的设计团队发的一封很长的邮件，强调了 1x 设计的重要性，摘录于此[链接](https://medium.com/@kurtvarner/heres-an-excerpt-from-dave-bedingfield-s-email-to-the-twitter-design-team-articulating-the-103b82055b70#.t09g4p9ne)。

以上。客官，您请随便用。如果我有漏掉的，还请客官补充。

特别鸣谢 [Jeremy Goldberg](https://twitter.com/jeremygoldbrg) ，将我带入正途并说服我使用 1x 设计的第一人。

译注：

1. 文中 1x 可读作“一倍”，2x 读作 “两倍”，依次类推
