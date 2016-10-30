> * 原文地址：[How to design a mobile app across OS platforms?](https://medium.com/@ooceanzou/designers-problem-d7f70d4f4d6c#.8mr6hednc)
* 原文作者：[Ocean Zou](https://medium.com/@ooceanzou)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Kulbear](https://kulbear.github.io/)
* 校对者：[siegeout](https://github.com/siegeout), [jiaowoyongqi](https://github.com/jiaowoyongqi)

# 根据 OS 设计你的应用

### 设计师们的难题

***Android 和 iOS***[ 是市场上的两个主流操作系统](http://www.idc.com/prodserv/smartphone-os-market-share.jsp)。多数公司都会要求开发者开发对应的移动端应用。对于这些需要在两个平台上同时设计的应用，其中一个挑战就是在品牌一致性和平台的不同功能特性之间进行平衡。

作为一名设计师，了解不同平台的设计惯例和行为才能在开始设计前更好的和开发者及股东们进行交流。这样，你的团队可以基于适配各个平台的优缺点来讨论决定开发计划（先开始 iOS 的开发，或者先开始 Android 的开发，或者同时进行两个平台的开发）。

> 因此，在这里我将会比对苹果和谷歌这两个操作系统设计风格上的相似之处和不同之处。我将会挑选部分应用，分析其在这两个平台上设计的相似和不同。

通过这样的比对，我们可以更好的理解在这两个平台上约定俗成的设计形式。同时还可以给予设计者／开发者们一些建议，帮他们决定将来的设计和开发策略——不论他们想要先开发某一平台或者并行开发。

### 设计参考（指南）

这一部分我们将会研究和探讨来自 [ Apple ](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/)和[ Google ](https://www.google.com/design/spec/material-design/introduction.html)的设计方针中的相似与不同。

#### 谷歌的设计指南

[Material Design](https://www.google.com/design/spec/material-design/introduction.html) 在 2014 年被谷歌提出并作为 5.0 版本及以上的 Android 系统中跨产品，跨平台设计的默认“视觉语言”。

![](http://ac-Myg6wSTV.clouddn.com/5a25fa2885fcbf1a5e08.png)

图表 1.1 各版本 Android 操作系统普及率

基于来自 [android developer dashboard site](http://developer.android.com/about/dashboards/index.html) 的上图我们可以看出，Material Design 的普及率在 2015 年 10 月 5 日时仅仅有 24%。在 2014 年 11 月发布的时候, 它的用户有过一段迅猛增长。基于新的 Android 设备的普及率，Material Design 的普及率应该和未来[新增长的 Android 设备数量](http://www.idc.com/prodserv/smartphone-os-market-share.jsp)相似。因此，由于 Material Design 是 Google 为 Android 设备发布的最新设计框架，本文中对 Android 系统的设计研究将基于此。

![](http://ac-Myg6wSTV.clouddn.com/53102f018f484dde50cf.png)

图表 1.2 Material Design 的主要特征

谷歌很好的定义了 Material Design。从图表 1.2 中我们能看出，如果你不熟悉材料设计，共有四个方面你需要特别注意。

**深度 & 表面：** 你将会发现在 Android 中使用的效果是深经考究的，尤其是浮起的元素及其投影，都是为了表现不同界面元素之间的层级关系。

**网格 and dpi（每英寸所打印的点数）：** Material Design 严格使用了独立于密度的像素网格系统（dp）。 根据 [google’s definition](https://www.google.com/design/spec/layout/units-measurements.html#units-measurements-density-independent-pixels-dp-)，dp 是一种灵活的像素单位，它可以自动按比例显示在任意屏幕上。在设计 Android 应用的时候，设计师们可以通过使用 dp 在不同像素密度的屏幕上显示同样比例的元素。在 Material Design 中，所有元素都依附在网格 8dp 宽的框架上, 这可以使不同应用间的视觉效果很有规律。比如，按钮一般都是高 48dp 的，[应用栏](https://www.google.com/design/spec/layout/structure.html#structure-app-bar)默认为 56dp，不同元素的间距总是 8dp 的倍数。

**字体：** [Roboto](https://www.google.com/fonts/specimen/Roboto) 是 Android 的默认字体集，它包括了不同尺寸和[字重](https://www.google.com/fonts/specimen/Roboto+Condensed)的字体。此外，你还可以在你的应用中导入你自己的排版字体。

**交互 & 运动：** Material Design 参考了很多用户使用动机和接触反应。根据图 1.3 中我们可以看出，当你点击某个元素时，接触点的四周将会扩散出波纹，如果你点击的是按钮，则按钮将会升起（一般通过加深阴影实现）来“靠近”你的手指。

![](http://ac-Myg6wSTV.clouddn.com/ef8991f36a50b6877541.gif)

图表 1.3 Material Design 交互

![](http://ac-Myg6wSTV.clouddn.com/1b40487c14c76b73a321.png)

图表 1.4, 各版本 iOS 的普及率

#### Apple 设计指南

和 Material Design 不同的是，Apple 很早就建立了自己的 iOS 设计框架。从图 1.3 中不难看出 iOS8 和 iOS9 占据了大多数用户。由于 iOS9 数月前刚刚发布，多数 iOS 应用还停留在 iOS8 的版本下。因此，此次我谈论的 iOS 设计将主要围绕 iOS8 和它的特性。

参考阅读 [iOS 界面设计](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/)后，我针对 iOS 设计总结出如下几点：

**扁平化设计：**它移除了任何给予组件 3D 效果的选择，比如阴影，纹理等。它专注于排版，颜色和组件之间的关系。

**极简设计 & 功能：** iOS 的设计更专注于原始功能而非外观。简易的图标和布局最大程度上减少了用户使用手机时的认知成本。

**直观的交互：**内置的应用使用了很多直观的设计，如压感反应，颜色，位置，有含义的图标和标志。用户不需要过多装饰就能明白屏幕上的某个元素是用来干什么的。比如，对于回到上一界面，多数用户会被暗示只需要在屏幕上轻轻从左向右滑动手指即可。

**颜色 & 图片：**在 iOS 中，Apple 使用了颜色来指出交互和视觉上的连贯性。 设计师们被强烈建议使用颜色和图片来引导用户使用应用时的每一步操作。

#### Apple 和 Google 的比较

**用户界面元素**

![](http://ac-Myg6wSTV.clouddn.com/775dce40405661b2b82f.png)

图表 1.5 用户界面的比较

iOS 和 Android 平台在用户界面上有着明显的分别。根据图 1.4 不难看出，第一，iOS（左）和Android（右）的主要操作栏位于不同的位置。苹果系统将其放置于界面下方，而 Android 系统将其放置在上方导航条的下方。第二，两个平台都为回退功能设计了在左上的按钮，但在 Android 平台下这个是可选的，因为 Android 手机上自带了回退导航的按钮。第三，Material Design 常用一种类似“汉堡”的图标表示菜单栏，而 Apple 不常使用这种导航方式。第四，Material Design 允许浮动按钮作为快捷方式出现在界面上，并把卡片视图作为一个用户界面上重要的组件。

**交互 & 运动**

![](http://ac-Myg6wSTV.clouddn.com/3bbd8617f851fdb1ac5e.png)

图表 1.6 交互设计上的比对

Android 和 iOS 在交互设计上也很不一样。根据图 1.5 我们可以看出，第一，当 iOS 使用颜色变化或淡出来给交互提供反馈，Android 使用从你的手指扩散出的浮动的波纹（水面和光线的反馈）以及点击后会通过加深阴影上升“靠近”你手指的按钮（材质反馈） 。第二，Apple 谨慎的设计了动画，而 Material Design 对动画的设计更抓人眼球。在 Google 来看，丰富清晰的动态设计可以有效的引导用户的关注度。他们相信对于动态效果的应用可以更平滑的在不同导航界面间引导用户，解释屏幕上组件的改变，以及强调元素的优先级*（过渡）*。

**视觉语言**

![](http://ac-Myg6wSTV.clouddn.com/89cbb9564cdc61855a4b.png)

图表 1.7 视觉设计的比对

Android 和 iOS 在视觉设计上也大为不同。首先，在 Android 上，一个关键点是密度无关像素（常被缩写为 DIP 或 DP）的引入，而 iOS 只是使用点作为他们的单位。 这两种类型都能保证你的设计在不同密度大小的设备上能正常使用。第二，iOS 大量使用了模糊效果而 Android 选择使用了阴影。第三，iOS 使用三种标准尺寸（@1x，@2x，@3x）而 Android 有四种（normal，small，large，extra large）。

### 移动端应用

在了解 Material Design 和 iOS 设计的主要特点后。我研究了一些在 Android 或是 iOS 上有相似和不相似界面的应用。由于我不认识这些开发团队中的任何人，所以这一部分的总结来源于我的观察和猜测而非真实的开发决策。基于我的观察，对多平台设计应用通常有面向平台的，面向品牌的，以及混合的方法。我会在接下来解释每种方法并分析一些例子。

#### 面向品牌的方法

面向品牌的方法主要是使用在两种系统上使用自定义的用户界面来突出自己的品牌。为了贯彻这种方法，设计师们往往不会遵循标准的平台设计而去设计独特的用户界面并发布于两个平台。在这个分类下，VSCO CAM 和 Snapchat 不仅保持了品牌特性，并且都有独特的自定义界面。这一部分，我们将比对它们并研究它们的设计。

> VSCO CAM

![](http://ac-Myg6wSTV.clouddn.com/690e10db3d0181112c16.gif)

图表 2.1 VSCO CAM — 探索页（左 iOS vs 右 Android）

VSCO Cam 应用是一个现今流行的照片处理应用。刚开始它被发布于 iOS 平台 并在随后推出了 Android 版本。图 2.1 中可以看出， Android 上的界面和 iOS 上的几乎一样。同样的导航，菜单，甚至图标。更有趣的是，没有一个平台上的开发是遵循平台设计准则的。没有传统的动作条。在不同界面的转换需要通过一个不在通常位置的菜单完成。由于 VSCO Cam 完全“不管不顾”平台的设计准则而侧重于品牌特点，你可以很明显的感觉出在不同平台上他们所关注的品牌特点。

![](http://ac-Myg6wSTV.clouddn.com/7f760c5880e1ea13e99e.gif)

图表 2.2 VSCO CAM — 相机页（左 IOS vs 右 Android）

虽然现在 iOS 和 Android 平台上的 VSCO CAM 看似很接近，但实际仍然有一些地方可以被区分开。比如，相机的界面都是原生平台的界面。

> Snapchat

![](https://cdn-images-1.medium.com/max/800/1*4uytqo55hEPhaLn2WSlrQw.gif)

图表 2.3 Snapchat — 用户界面流（左 IOS vs 右 Android）

如同 VSCO Cam 应用一样，Snapchat 很早发布在 App Store，很久之后才有 Android 版本（2011年）。交互的独特性和娱乐性让 Snapchat 脱颖而出，使它[拥有超过两亿的用户](http://www.businessinsider.com/snapchats-monthly-active-users-may-be-nearing-200-million-2014-12)。简单的拍摄并发送照片儿，优秀的颜色处理，平滑的过渡和动画效果构成了 Snapchat 的独特性。这种独一的交互是 Snapchat 的一大品牌特点，我们可以发现公司尝试统一在两个平台上的交互体验——界面看起来在两个平台上完全一样。从图 2.3 中看，Snapchat 在两个平台上有着相同的交互流程。首先用户进入相机界面，他们可以通过左滑进入朋友页或者右滑到“发现”页。此外，界面元素的设计和样式相似度很高，唯一的区别是标题和图标的位置与尺寸。

总的来说，Snapchat 和 VSCO Cam 通过在不同平台上创建独特一致的用户界面来提升了品牌的独一性。然而，这样的方法也有着很多的缺点（一会再讨论）。现在，让我们来看看面向平台的方法。

#### 面向平台的方法

面向平台的方法是在设计的过程中遵守各个平台的设计准则。在这种情况下，产品设计人员的关注点从品牌特点转向了更贴近平台设计准则（因为用户习惯于自己使用的平台习惯）。他们更熟悉自己所使用平台的设计规则，所以一个专门为平台考虑的设计使他们更快接受你的应用。在这一类产品中，Evernote 和 Dropbox 是很好的例子。

> Evernote

Evernote 作为一个帮助提升用户效率的记录笔记的应用发布于 2007 年。

iOS 和 Android 版本的 Evernote 不论从 UI 还是 UX 来看都完全不一样。在两个平台上几乎每一部分都不一样，从登陆页，到菜单的设计，甚至一些界面元素。

![](http://ac-Myg6wSTV.clouddn.com/e441197fed5eb967158f.gif)

图表 2.4 Evernote 登陆页（左 iOS vs 右 Android）

如同前面所提到的，在 iOS 版本上倾向于简洁的动画过渡，而 Android 版本上更多的动画效果致力于抓住用户的目光。从图 2.4 中看，两个平台上的登陆页遵循各自的设计准则而看起来完全不一样。这样的结果便是在 iOS 的登陆页上有着极少的图像设计和动画，而 Android 版本上有的动态风富的设计和动画。

![](http://ac-Myg6wSTV.clouddn.com/81f08899ab7d034ad4fa.gif)

图表 2.5 Evernote 主菜单（左 iOS vs 右 Android）

菜单的设计也完全不一样。iOS 上的菜单有着全绿色的背景，占据了整页，这使它看起来像一个新页面而不是菜单。而和 iOS 版本不同的是， Android 版本中遵循了 Material Design 的准则，使用了“汉堡”菜单。这个菜单只占据了半页，用户可以很明确的知道他们所在的页面。这在页面转换之余给予了用户更明确的体验。此外，菜单的栏目在 Android 版本上由于更多的留白和信息优先级要更易读一些。

![](http://ac-Myg6wSTV.clouddn.com/be827a16addd448cebfd.gif)

图表 2.6 Evernote 动态交互（左 iOS vs 右 Android）

Evernote 的设计师们还在每个平台上采用了原生的用户界面组件来执行同样的任务。从图 2.6 中可以见到，在 Android 版本中的添加按钮是一个在 Material Design 中传统的浮动按钮，而在 iOS 版本中添加按钮则被设计在了动作条上作为一个按钮——这在 iOS 的设计中十分常见。

> Dropbox

Dropbox 是一个重视功能而非界面的实用应用程序。因此，它的设计师们决定严格遵守面向平台的方法，沿用原生设计准则，从而使界面和交互更易预测，对用户更友善。

![](http://ac-Myg6wSTV.clouddn.com/fd2fc3dc962f9814f9e9.gif)

图表 2.7 Dropbox 导航结构

从图 2.7 中看，Dropbox 的 Android 和 iOS 版本使用了不同的方法来决定导航的优先级。iOS 版本中，它使用了底部的选项栏来完成在四个最高级的部分（文件，照片，离线文件，通知）之间切换。然而，Android 版本中这些都被隐藏在导航 drawer 中。从优先级角度来看，这是很大的差异。

![](http://ac-Myg6wSTV.clouddn.com/41f45399d3e334894329.gif)

图表 2.8 Dropbox 浮动按钮（左 iOS vs 右 Android）

Dropbox 的设计师们也对各自平台使用了各自规范的控制和体验交互元素。从图 2.8 来看， Android 的浮动动作条和 iOS 中的选项按钮各自被应用在其中关键的内容功能上。比如，*上传文件*，新建文件夹等等。这种对界面元素的应用不仅使两个平台上的功能保持高度一致，而且还符合各自的界面设计模式。

![](http://ac-Myg6wSTV.clouddn.com/4cc916d24f5c47cf8ac7.gif)

图表 2.9 Dropbox 登陆页（左 iOS vs 右 Android）

除了 UI 和 UX 上的设计差异之外，图像设计，动画，包括写作在不同平台上也很不一样。从图 2.9 中我们可以看到，iOS 版本使用了最少的文字和图标，而 Android 版本上则重点照顾了视觉设计和动画。 Android 上也有更好的写作体验，让用户感觉被关注和重视。 

总的来说，这两个公司都创建了高度面向平台的应用。然而，面向平台方法也有着很多的不足。现在我们先来看看最后一种方法：混合方法。

#### 混合方法

在多平台设计上应用混合方法往往是在以上提及的两种方法中寻求平衡，当然它也是最复杂的一种。在这种情况下，设计师需要考虑两种用户：熟悉你的产品的，和从未使用过你的产品的。第一种用户更贴近你的品牌，第二种用户更习惯于所使用的平台。混合方法的设计师是品牌兴趣和用户体验的外交官。他们需要找出哪些用户界面元素让它们的产品与众不同，还要找到针对平台同时不影响品牌效应的解决方案。这一类公司中，Facebook 和 Spotify 是我们将要讨论的例子。

> Facebook

Facebook 由于其品牌在多平台网络下大量的用户有着巨大的影响。这就是为什么结合品牌效应和平台适应性的混合方法看起来是最佳的选择。显而易见的，Facebook 使用了混合的方法。现在的 iOS 和 Android 端应用看起来很相似，但对每个平台的用户来说都十分“原生”。

![](http://ac-Myg6wSTV.clouddn.com/76a10752b1df69d5e875.gif)

图表 3.1 Facebook 布局（左 iOS vs 右 Android）

第一眼看去，品牌的特点通过在不同平台使用同样的图标和颜色得以体现。Facebook 在这两个平台上的区别主要在于导航栏的位置。如你在图 3.1 中所见到的，iOS 版本使用的是标准的 iOS风格的导航栏和标准搜索栏。在 Android 平台下则是和多数应用一样，通过位于顶部的选择栏完成的。

![](http://ac-Myg6wSTV.clouddn.com/6c7deac5dc7e72ba6495.gif)

图表 3.3 Facebook 搜索栏（左 iOS vs 右 Android）

在搜索栏上的导航按钮同样是针对每个平台的。从图 3.3 上看，iOS 上的 Facebook 应用有着一个取消键，在 Android 上这个取消键变成了一个 iOS 用户所不熟悉的箭头。这些针对平台的设计使新用户很容易能理解这些交互该如何完成。

> Spotify

Spotify 是一个流行的音乐播放应用，它有着针对品牌很鲜明的设计。他们的设计师侧重于品牌特点的设计，并遵循各个平台的设计准则来设计一些应用中特殊的功能。

![](http://ac-Myg6wSTV.clouddn.com/52e9851376f9599abce7.gif)

图表 3.4 Spotify Home Page（左 iOS vs 右 Android）

第一眼观看图 3.4 就不难发现，Spotify 的设计师在统一两个平台上的界面和视觉设计上做的非常好。这个页面上的设计在两个平台上保持了高度的一致性。

![](http://ac-Myg6wSTV.clouddn.com/d3f65a13207a69347547.gif)

图表 3.6 Spotify 注册页

尽管大力的贴近了品牌特点，Spotify 也迎合了用户在交互和界面上的预期，并且很多的应用了各个平台特色的用户界面组件。从图 3.6 中看，Spotify 对生日和性别信息的文本框设计在两个平台上是不一样的。在 iOS 上使用了传统的下拉菜单设计，而在 Android 上是一个弹出的菜单。卡片类的弹出菜单是 Material Design 的一个设计标准。

![](http://ac-Myg6wSTV.clouddn.com/d71ea302d20a2924bf41.gif)

消息和活动页面（左 iOS vs 右 Android）

此外，内容的优先级设计在两个平台上也不太一样。从图 3.7 中看，在 iOS 上这一部分是在最高级菜单中的，而在 Android 版本中这两个部分被放在了一个叫“通知”的菜单选项中。Spotify 的设计师遵循了 Google 的设计来简化 Android 版本上的信息流。

### 优势与缺陷

经过了这些案例分析以后，我们会针对每种方法分析优势与缺点。在这部分，我会推荐在何种情况下一个公司最好使用哪种方法，并分析使用每种方法的优缺点。

#### 面向品牌的方法

专注于品牌而忽略平台规定的准则创建 UI 是最快，最容易，也是最经济的方法。这些 UI 组件将会自由的被设计创建，从而给予用户更个性化的的设计和交互体验。由于没有遵循平台的设计准则，在多个平台上产品也可以给予用户同样的观感，帮助公司建立更好的品牌效应。然而，自定义的 UI 在开发过程中更难，需要公司比往常投入更多的精力。对于一些用户来说，可能还有体验上的问题，因为你们的界面和通用的界面并不相似。

**推荐：**开发一个树立品牌的应用，并且将保持品牌一致性作为第一准则是没有任何问题的。

#### 面向平台的方法

因为开发人员熟悉每个平台的标准界面，面向平台的方法拥有更快的开发周期。当一个应用发布之后，用户很容易就能明确交互的方法和常见的方法很相似，更容易上手。但当你遵循平台的设计准则，在设计 UI 方面你需要投入更多的时间和金钱。设计师完成设计后，很多 UI 组件需要针对不同平台重新设计和创建。此外，当设计师遵循设计准则之后，所有东西都看起来像是 Google / Apple 制造了。看起来，对于想要树立品牌的公司来说，这个方法并不是十分实用的。

**推荐：** 当你需要快速投放市场并快速的在激烈竞争的市场中抢占用户的时候，这个方法是最好的。

#### 混合方法

混合的方法在你需要用户体验为品牌代言时，是最佳的选择。我相信这是通往多平台适应的最佳路线。它允许设计师切身为平台，用户和品牌考虑。此外，这个方法可以让设计师很好的平衡诸如品牌和平台设计规则，从而发布优秀的产品。然而，混合方法由于在开发过程中经常需要变更，所以最长的时间和工作量去完成。对于没有足够的资金和时间的初创公司来说这样太难了。

**推荐：**在我看来，如果设计师可以根据反馈和评估增加／改进产品的设计而没有太多的限制，这个方法是近乎完美的。

### “如何下决定”的指导

尽管多方面结合（上文所提的多种）的方法看起来是应选的路线，我还是要说文中所提的方法没有一种是完美的。有时，倾向于品牌效应而忽视的平台标准会造成一些“特别的”用户体验问题。而针对平台开发的方法，有时候看起来太刻板太标准化，对品牌提升没什么效果。我举例的这个使用混合方法开发的应用显然是一个多平台适应的成功案例。然而，这样的例子少之又少，因为它需要很多时间和投资的支持。

因此，当我们考虑使用任何一种方法时，设计师都应该考虑产品设计的策略和实际开发中的限制（比如，缺少能胜任的开发人员，资金和时间上的限制等等）。当你身处一个小公司，团队需要极高的品牌效应的时候，面向品牌的方法显然是较好的（被推荐的）。从另一方面讲，当你的公司想要快速增增长用户的时候，面向平台开发的方法便是更好的。如果你的团队并没有什么明显的限制，而只是想要进一步提升你们的产品品质，那么混合的方法来开发是最好的。
