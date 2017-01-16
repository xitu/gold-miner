> * 原文地址：[How To Communicate Hidden Gestures in Mobile App](https://uxplanet.org/how-to-communicate-hidden-gestures-in-mobile-app-e55397f4006b#.po5wdv20m)
* 原文作者：[Nick Babich](https://uxplanet.org/@101?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：[Tina92](https://github.com/Tina92) , [marcmoore](https://github.com/marcmoore)

# 如何让用户发掘移动应用中的“隐藏”手势 #

我们将与应用进行交互的手指活动称为手势。可触摸界面为我们使用诸如点击、滑动、捏合等自然手势来控制应用提供了可能。但与图形控制界面相比，这些控制手势往往难以被用户感知，也就是说，如果用户不是事先就知道可以用特定的手势进行操控，他们是不会去刻意尝试（使用手势）的。

如何帮助用户发掘这些隐藏的手势呢？幸运的是，当下已经有几种可视交互设计技巧供我们选择，来让这些手势浮出水面了。

### 启动应用时展示教程和演示 ###

许多手势驱动的应用偏向于利用教程和演示来指导用户使用。这通常意味着你会展示一些指令指南，来解释应用界面的操作规则。但是，通过界面教程来解释应用的核心功能并不是最优雅的方法。该方法有以下两个缺点：

- 如果你必须要为你的应用提供配套的指令说明，那就说明你没有为用户提供一个友好的体验，因为你不能期望每个用户都会在使用应用之前阅读说明。

- 另一个问题则是，用户必须在开始使用应用之前，记住所有他们才刚刚了解到的操控方法。

打个比方，Clear 应用启动时会强制展示 7 页长的使用指南，而用户必须仔细地阅读所有信息，并尽量的记住它们。这其实是非常糟糕的设计，因为用户必须在体验应用之前做许多准备工作。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*GPB-VY6vVkRPtU1t.png">

**Clear 应用中的教程**

避免一次性展示包含多个步骤的演示，试着在对应的会话上下文中再进行指导（当用户实际使用该功能时）。通过多次小的演示，教程其实可以变成一段渐进式的探索之旅：

> 将关注点放在一次特定的交互上，而不是试着将所有可能用到的指令全都呈现在界面上。

就拿 YouTube 应用安卓端的手势教程界面为例：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*jit4P5QZ3GGKTjtc.png">

YouTube 安卓客户端

该应用同样是基于手势交互的，但它没有以教程形式向用户展示指令。相反，它仅在新用户首次进入应用的某些界面时，展示与该界面相关的使用提示。

### 如何在上下文中指导用户 ###

在上下文中对用户进行指导的技巧，是为了帮助用户掌握那些他们从未使用过的操作方式来与界面元素交互。这项技巧通常包括 **小巧的界面提示** 以及 **简短的动画示意** 。

#### 纯文本指令 ####

这项技巧基于文本指令来提示用户进行某种手势操作，并精简的描述该操作所起到的作用。

**小贴士：**尽可能缩短指令文字长度 - 文字越精简，用户就越可能仔细地读完并根据指令完成操作。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*jZyn5K8phjbxoFiZNYKZ6A.gif">

图片源于:Material Design

#### 动态提示（Hint Motion）####

动态提示（或者说界面提示动画）为元素交互动作的方式和结果提供了预览。举个例子， Pudding Monsters 的游戏机制是完全基于手势的，但它却能让用户较为准确地猜测到交互的方式。动画诠释了功能信息 - 展示一个带有动画的场景，用户便能清楚的知道该怎么做了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*mtNyp2a4Ovg2usopA6cOfw.gif">

动态提示为元素的操控提供了预览。图片来源：Pudding Monsters

#### 内容梳理（Content Teases） ####

内容梳理属于简单视觉线索（subtle visual clues）的一种，用于表明操作的可能性。下面的例子展示了如何对卡片视图进行内容梳理 - 它简单地在当前卡片下展示了其它的卡片，以此来说明此处可以使用滑动操作。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YjZGGyu1OLaddxQ-b-NKXg.gif">

展览式的导航功能。 图片来源：[Barthelemy Chalvet](https://dribbble.com/BarthelemyChalvet)

### 总结 ###

归根结底，没有一个万能的方法，能够满足所有在移动应用或是 web app 中指导用户使用手势的需求。但当涉及到指导用户如何使用界面时，我建议你尽量在相应上下文中使用弹性内容来显示指南，[渐进式地展示信息](https://uxplanet.org/design-patterns-progressive-disclosure-for-mobile-apps-f41001a293ba#.p5aq5o4f2) 并配合简短的动画。教程和演示是迫不得已时才考虑的手段。

感谢阅读！
