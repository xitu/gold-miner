> * 原文地址：[Little Big Details For Your Mobile App](http://babich.biz/little-big-details-for-your-mobile-app/)
* 原文作者：[Nick Babich](http://babich.biz/author/nick/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[mypchas6fans] (https://github.com/mypchas6fans)
* 校对者：[DeadLion] (https://github.com/DeadLion) [siegeout] (https://github.com/siegeout)

# 开发移动应用，你应该注意这些小细节

你的 app 的成功涉及很多因素，但最重要的是总体用户体验。市场上脱颖而出的 app 都提供了很棒的 UX。具体到设计移动 UX，遵从最佳实践是一个好方法，但是构建蓝图的时候，往往容易忽略一些锦上添花的设计元素。而“不错的体验”和“非凡的体验”之间，通常取决于我们设计这些小细节的用心程度。

通过本文你可以看到这些 __小中见大的细节__ 和设计中那些更明显的元素同样重要，以及它们如何决定 app 的成功。

## 启动页

当用户打开 app 时，最不能做的事情就是让他们等待。但是如果 app 的初始设置非常耗时，又 __不可能__ 优化该怎么办？你 __不得不__ 让用户等。如果他们愿意等，你得知道如何 __吸引他们__。启动页解决了等待的问题，让你有一个简洁有力的窗口来吸引用户。

![](http://babich.biz/content/images/2016/08/1-kA8WMVt3-7UxbCYieFoOsg.png)

图片来源: mobile-patterns

这里有一些小贴士，在设计启动页的时候记得注意：

*   [Google](https://developer.android.com/training/articles/perf-anr.html) 和 [Apple](https://developer.apple.com/ios/human-interface-guidelines/graphics/launch-screen/) 都建议用启动页 __模拟更快的加载__ 来提高用户体验。启动页给到用户即时反馈，表示 app 已经启动并正在加载。 为了保证人们等待的时候不厌倦，给他们一些 __娱乐__：有意思的，意想不到的，或者任何可以抓住用户注意力的东西，时间长到够 app 启动就好。

    ![](http://babich.biz/content/images/2016/08/1-88tQ_gtQrWY7LQXUMglNzg.gif)

    图片来源: Cuberto

*   如果 app 的初始设置超过 10 秒钟，考虑使用 [进度条](http://babich.biz/progress-indicators/) 来表示正在加载。__记住，不确定时间的等待给人的感觉要比确定时间的等待更加漫长__。所以，你要给用户一个清晰的标识，他们需要等多长时间。

    ![](http://babich.biz/content/images/2016/08/1-Qq7rzaTpyd2OndF3zgyZtA.png)

    通过使用进度条让加载过程更自然. 图片来源: de_martin

## 空状态

我们通常会设计一个丰满的界面，布局中的所有元素都完美的放置，看上去很美。但是如果界面正在等待用户操作，该怎么设计？我要说的就是空状态。设计空状态是非常重要的，因为即使它是一个临时状态，它也会是 __app 中的一份子__， 并且对用户 __有用__。

空状态的意义不仅是一个装饰。除了向用户提示界面上将要展现的内容，它还可以作为一种 __导引__ （介绍 app，展示为用户做的事情），或者 __助手__ （出错时的屏幕）。这两种情况下，你都希望用户能做点什么事情，所以，屏幕不会立即变为空状态。

![](http://babich.biz/content/images/2016/08/1-W3q0L25iO7HP6ywPYQJ9lQ.png)

图片来源: inspired-ui

下面是一些设计空状态时的小技巧：

*   __给新手用户设计空状态__。记住新用户的体验很 __重要__。给他们设计空状态的时候要尽量简单。重点放在用户的主要目标，设计互动性最大化：清晰的信息，合适的图像，一个按钮，这就够了。

    ![](http://babich.biz/content/images/2016/08/1-Wg23TxJp1IFCSwpiaZ43zw.png)

    Khaylo Workout 是一个关于空状态设计的很好例子。这个空状态告诉用户为什么会看到当前界面（因为他们还没有挑战任何朋友）以及如何操作（点击 + 图标）. 图像来源: emptystat.es

*   __错误状态__。如果空状态时由于系统或用户错误，你必须在友好度和帮助度之间寻找一个平衡。一点小幽默通常可以抹平出错的沮丧，但是更重要的是你要清楚的说明解决问题的步骤。

    ![](http://babich.biz/content/images/2016/08/1-czn24uzZvVIsLRhc2nVYag.png)

    迷失方向，孤立无援，就像在一个荒岛上？遵从 Azendoo 的建议，保持冷静，点个火，然后继续刷新。图片来源: emptystat.es

## 框架界面

我们通常不考虑内容的不同加载速度——我们一直认为都是立马加载（或者至少非常快）。所以我们通常没有为用户需要等待加载的场合设计。

但是网速不是总是有保障的，它可能比预期的要慢。尤其是下载比较大的内容时（比如图片）。如果你不能缩短时间，至少要让用户等待得舒服一点。你可以用 __临时信息容器__ 来保持用户的注意，比如框架界面和图片占位符。比起转圈的加载提示，框架界面能建立对内容的预期，减少认知的负担。

几点建议:

*   框架界面不必很抢眼。只需要凸显必要的信息，比如段落结构。Facebook 的灰色占位符就是个好例子——它加载时使用了元素模板，让用户熟悉正在加载的内容的整体结构。注意框架界面中的图片和线框并没有很大区别。

    ![](http://babich.biz/content/images/2016/08/1-PGXSupBdpfiGeU6zwfBxNw--1-.jpeg)

*   对正在加载的图片，可以用图片中的主色填充一个占位符。 Medium 有一个很棒的图片加载效果。首先载入一个小的模糊图片，然后慢慢转变成大图。

    ![](http://babich.biz/content/images/2016/08/1-jFvvQCNfMH7rs-QG5DprKg.png)

    真正的图片出现之前，你可以看到模糊图片填充的占位符。图片来源: jmperezperez

## 动画反馈

好的交互设计会提供反馈。在现实世界，像按钮这样的物体会对我们的交互做出反馈。人们会对 app 中的元素有同样水平的期望。可视的反馈让人们有 __掌控感__：

*   它会告知交互的结果，让结果可见并可以理解。
*   它给用户一个信号，这个对象（或者 app ）执行一个任务成功或者失败。

动画反馈通过即时的信息沟通来节约时间，并且不能让用户厌烦或者分心。最基础的动画反馈就是 __转场__：

![](http://babich.biz/content/images/2016/08/1-JySxzSIszvxYECYOo0Gxag.gif)

当用户看的点击/触摸操作引发的一个动画反馈，他们马上知道这个操作被接受了。图片来源: Ryan Duffy

![](http://babich.biz/content/images/2016/08/1-VQ66RMfNtTLiCX4jqqhlFQ.gif)

当用户点击勾选任务已完成, 包括这个任务的区域就缩小并且变成了绿色。图片来源: Vitaly Rubtsov

使用不同凡响的 [动画](http://babich.biz/animation-in-mobile-ux-design/)，一个 app 可以真正的打动用户。
下面是关于动画反馈的一些提示：

*   动画反馈必须经久不衰。第一次看着新鲜的东西，100 次之后可能就烦了。

    ![](http://babich.biz/content/images/2016/08/1-DCw_ooNYrwRAs_19o_wcsQ.jpeg)

    图片来源: Rachel Nabors

*   动画可以让用户分心，让他们忽略加载的时间。

    ![](http://babich.biz/content/images/2016/08/1-JzEgzgSjJKV7zxWKPdBAjg.gif)

    图片来源: xjw

*   动画可以让用户体验打动人心，刻骨铭心。

    ![](http://babich.biz/content/images/2016/08/1-l2AHcRcm2Knky-IpD0hP4g.gif)

    图片来源: Tubik

## 总结

__用心设计__。app 的 UI 里面，每个微小的细节都值得密切注意，因为 UX 就是让所有细节协调的总和。所以，请从一而终，持之以恒的打磨你的 UI，创造真正无与伦比的用户体验。

谢谢！



