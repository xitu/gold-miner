> - 原文地址：[Design like a Developer](https://medium.com/going-your-way-anyway/design-like-a-developer-b92f7a8f4520#.ohgf4aagn)
* 原文作者：[Chris Basha](https://medium.com/@BashaChris)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：[skyar2009](https://github.com/skyar2009)，[sqrthree](https://github.com/sqrthree)

---

![](https://cdn-images-1.medium.com/max/1600/1*cUlwzVshahSl9DM4DZApYQ.jpeg)

Westworld, HBO

## 以开发人员方式交付设计

长标题：像在开发环境中搭建 UI 一样在 Sketch 中设计

首先，这将是本文中唯一一次提到 Photoshop。现在是 2017 年了，为自己好，去下载 Sketch（或者 Figma — 只要不是 Photoshop 就行） 用吧。

UI 设计已经有了长足的发展，图像处理程序也是如此（如果你现在还这么称呼它们的话）。仍记得在 GIMP 中创建我们的第一套 UI 时的场景，现在，有了 MacBook，我们可以用 Sketch 完成几乎所有与 UI 相关的所有工作啦。

事情是这样的，尽管，Sketch 是为设计人员打造的。其使命是帮助设计人员创建用户界面 — 你可以用它创建相当惊艳的东西。但不要忘了，你是在打造一个产品，在设计被交付时，你的工作才算完成，而不是当你“定稿” Sketch 文件时。

你的设计必须经由开发人员在开发环境中构建。这就是问题所在：如果你比较 Sketch 和开发环境中的 UI 构建工具（或者 IDE，比如 Xcode、Android Studio)，就会发现两者相似之处并不多。

开发人员构建你的设计的方式，与你作为一个设计师在 Sketch 中创建的方式完全不同。如果这么想，听起来有些蠢，不是吗？

![](https://cdn-images-1.medium.com/max/1600/1*SILxrapOSVGmc4sLIaM3CA.png)

Xcode、Sketch 和 Android Studio（和一些闪电符号）

没关系，这篇文章就是介绍一种设计方法，它更接近开发人员构建你的设计时的方式（好拗口）。

### 以“视图”思考

你知道 Sketch 中的 **Symbol** 功能，是吧？当开始用 Sketch 时，我们对这个功能非常着迷，因为这如此接近开发人员构建 UI 的方式。多数情况下，当你观察例如列表项或者操作栏时，它们都可以看作一个独立的源**视图**不断被复用。

![](https://cdn-images-1.medium.com/max/800/1*nhQf6v6HBbnhR7lWbq7Ehw.png)

![](https://cdn-images-1.medium.com/max/800/1*z12CHMxb0YJxT7vppoCciQ.png)

![](https://cdn-images-1.medium.com/max/800/1*cJqbNsqX7jQ0vCynbSpYMA.png)

像开发人员一样设计，最重要的指导原则就是根据**视图**来思考你的设计。将 View 视为独立的一组元素，它们已定义了边界，并按照层次排好顺序了。

例如，在我们的 Nimber 安卓应用中，将搜索结果页分成两个主要视图：由操作栏和包含了用户位置输入及筛选卡片组成的顶部视图，返回搜索结果的列表视图。

在上面的线框图和结构图中，你可以看到视图的边界是如何在设计中被清晰定义的。**Sketch 文件中有一些不可见的图层（透明度为0%）**，这在交给开发人员时非常有用。

看下面操作栏是如何被分解成更小的视图的。

![](https://cdn-images-1.medium.com/max/1600/1*gcQLtwSi9its2BBZ5zpGtg.png)

视图层级的最顶层

![](https://cdn-images-1.medium.com/max/1600/1*eAXV4sx5uwqlPbllrhWmFw.png)

操作栏视图

![](https://cdn-images-1.medium.com/max/1600/1*g4gsq4tDW707agveiSOzNg.png)

100% 透明度时的操作视图元素

确保不要随机把图层分类。以清晰的方式定义它们的尺寸和间距（避免奇数），并按层级顺序排序。

同样的原则也适用于图层的样式，当你需要统一的边框、圆角、阴影时，也可以这样做。

这个叫 [Zeplin](https://zeplin.io) 的应用非常有用。简单说：你可以在应用中引入你的设计，应用会以一个开发人员使用的方式，抽取所有视图的尺寸、文本大小、颜色等。这是一个可以填补设计和开发差异的很棒的工具，我迫不及待地想看到它后续功能。

当你交付设计后，开发人员可以在 Zeplin 中提取某个元素的尺寸、边距、留白等信息，再在 IDE 中创建相应的视图。

### 按 1x 设计

为什么会在这里。。。

按 **1x** 设计指的是，首先你不需要计算其他屏幕的比例大小，重要的是，你和开发人员最终都用相同的参数。这样可以防止交付你的设计时出现计算错误，保持一组统一的值。

这是适用于视图尺寸、文本尺寸、行高等绝大部分与数字相关的设计。

### 一致的调色板

一次创建，多次重用。尝试使用尽可能少的颜色。

![](https://cdn-images-1.medium.com/max/1200/1*MwWQuonkMOBlroqzqD9l2Q.png)

开发人员最常用的命名是  *Primary, Secondary, Accent, Enabled, Disabled* 等。你可以按同样规则命名。*Primary* 和 *Secondary*  可以是你的文本颜色，*Accent* 可以是你的品牌主色调，你懂的。

在 Sketch 里，你可以用颜色拾取器来保存这些颜色，但就我所知，没有什么可以在 Sketch 文件之外共享它们的好办法。然而你可以用你的调色板的颜色、它们的名字和 hex 码创建一个画板。这样当开发人员用 Zeplin 打开你的设计时，就能快速提取出这些颜色，在应用的代码中使用它们。

![](https://cdn-images-1.medium.com/max/1600/1*UnGAceC6fZfRUcc63u4-2A.png)

Nimber 应用中我们用到的颜色。

### 适用于所有情况的设计

牢记开发人员不是在创建完美的 UI，而是在创建接近理想 UI 的东西。他们不得不处理无网络链接、或服务器响应错误、或者没有内容显示的等很多情况。

所以确保你的设计可以适用于每一个场景。具体说就是，确保每一屏都有自己的空白状态、加载状态、错误状态和完美状态。这样做的话，99% 的时间里，就表现足够好了。[Scott Hurff](https://medium.com/@scotthurff) 的[这篇文章](http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack)更深入地解释了各类状态的问题，推荐阅读。

### 屏幕尺寸

我们生活在一个多屏幕尺寸的时代，所以不得不相应地进行设计。当为 Android 系统设计时，这个尤为重要，因为它的设备有各种各样的尺寸。

当用 Sketch 进行设计时，一个“偷懒”的方式就是用诸如 [Sketch Constraints](https://github.com/bouchenoiremarc/Sketch-Constraints) 这样的插件来处理这个问题。用这个工具，你可以复制画板，重新调整它们的尺寸，然后刷新画板。神奇的事发生了， UI 会根据屏幕尺寸变化而变化。

“正确”的方式是为手机屏幕（7 英寸以下）、7 英寸的平板、10 英寸的平板电脑各设计一套 UI。Master-Detail Flow 是一种将列表和详情面板组合在一起复杂的布局，如下图所示：

![](https://cdn-images-1.medium.com/max/1600/1*x5oYpU9S0lUJ9vQbwcNNEw.png)

Oh, you wanna know what this is? [Well you’re in luck!](https://medium.com/@BashaChris/overhauling-the-twitter-experience-on-android-80f5b09e7c67#.1c8wpz368)

### 需要记住的事情

1. 并非所有用户都是在英语环境中使用应用。时刻想着，在其他的语言中，文字的长度可能较长（或者较短），在设计布局时，必须要考虑到这个因素。
2. 不要过于挑剔 — 你不可能控制每一个像素。由于不可预知的数据，应用程序的某些部分设计不可避免地不完美。
3. 尝试使用平台内置的交互方式、手势、过场及动画特效，开发人员会感谢你的。

### 最后但最重要的

多与开发人员沟通！让他们指导你。虽然 Zeplin 和 Flinto 这类工具是与开发人员共享设计的好方法，但是它们不能解释应用每个部分的行为。分享知识，努力实现最好的产品。

---

就这样，希望你可以学习并尝试这些方法。

**交付开心！**✌️

---

![](https://cdn-images-1.medium.com/max/1600/1*0zBg56i9RC8DSpsK6pvEJA.png)

此文的作者是 Nimber 的设计团队的 [Chris](https://twitter.com/BashaChris) 和 [Andrew](https://twitter.com/ckor)，请记得在 Twitter 上关注我们！

同时请也尝试下 [Nimber](http://nimber.com)，[Facebook主页](http://facebook.com/easybring) - [Twitter账号](http://twitter.com/nimber)

点个 ♥️，让世间充满爱！
