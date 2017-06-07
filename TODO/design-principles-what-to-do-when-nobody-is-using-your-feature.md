> * 原文地址：[Design principles: what to do when nobody is using your feature](https://blog.intercom.com/design-principles-what-to-do-when-nobody-is-using-your-feature/)
> * 原文作者：[Brendan Fagan](https://blog.intercom.com/author/brendanfagan1/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [iloveivyxuan](https://github.com/iloveivyxuan)
> * 校对者：[xunge0613](https://github.com/xunge0613)、[SareaYu](https://github.com/SareaYu)

---

# 设计准则：如何说服用户去使用新的功能

![hero](https://blog.intercomassets.com/wp-content/uploads/2017/03/13212312/Intercom_Profiles_Walkthrough_Logo.jpg)

### 去年，在我们发布了即时消息之后，我们又添加了一个功能，用户可以创建丰富的个人信息，这样用户就可以知道，在另一端和他们交流的是一个真实的人。

可是一个问题随之而来，没有人去尝试这个新的功能。功能刚刚发布之后，**只有 13-15% 的用户完整地填完了个人信息**，大部分人只填写了一部分，而其他的人是一点都没写。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20134424/ss-e1490018054223.png)

在我们的调研小组和分析小组跟大学生聊过之后，我们发现新特性之所以没有被采用，主要原因有 2 个：

1、**不显眼**。填写信息的入口被藏在了整个应用里特别不显眼的地方。
2、**不明确**。用户并没有明确意识到，个人信息对于建立和别人的人际关系是多么的重要。

## 解决办法

个人信息贯穿 Intercom 产品的各个部分，也就是说，我们必须投入大量的人力，才能让大家使用这个功能。用户增长团队（Growth Team）先将创建个人信息整合到产品中，然后 Intercom 通过产品本身，再让用户注意到他们可以编辑个人信息。

但其实，只要好好利用手机应用本身，就很可能大大增加用户使用数量。大约有 45% 的组员会使用我们的安卓应用或者苹果应用（[Resolve](https://www.intercom.com/customer-support-software/help-desk) 产品）和他们的客户聊天。

## 开始

对于每一个新项目，Intercom 的设计师都会先根据我们要努力解决的困难，列出一张清单，写清最高目标。这份清单可以引导你去思考解决方案。我们的清单会像下面这个样子：

1、**增加受众率**，让更多没有填完信息或是根本没有填写信息的人把信息填写完整。
2、**说服用户**，让他们明白公开个人信息是很重要的一件事。
3、让用户随时都可以轻松地**编辑个人简介**。

### 进行系统的思考

首先，我们抛开个人信息功能不谈，这样可以帮助团队去理解系统架构，然后决策出哪些特定组件需要优先考虑。也就是说，列出现存组件、状态、规则等等。下面是一个会被贴到我们办公室墙上的例子。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20182819/system-1.png)

### 想法可以来自任何团队

这个系统文档帮助团队尽早地对技术限制进行讨论，甚至在初期，开发团队就可以对设计团队没有考虑到地方提出一些建议。例如，有人提到，我们可以根据已有的数据来自动填充个人信息，因为在用户注册的时候，我们就获得了用户的姓名，所以为什么不能自动填充好，为用户节省一些手动录入信息的时间呢？

在画出几个方案的草图之后，我们去见了我们的产品设计总监 ——  [Emmet](https://blog.intercom.com/author/thoughtwax/)，从他那里得到了反馈还有下一步的计划。下面是 4 个初步设想。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20180350/Profiles-Option-A.png)

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20180344/Profiles-Option-B.png)

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20180347/Profiles-Option-C.png)

最最关键的部分是提醒用户和说服用户。我们不希望它被轻易地跳过，同时我们需要通过它让用户明白，个人信息里的每一个部分都很重要。但是，我们知道过度打扰用户，会让用户感到厌烦（就是说用户总是想要跳过），所以我们想要尽可能地减少每一个过程的操作步骤。最后，我们决定采用最简单的流程。下面是会议的决定，皮皮虾我们走！

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20182812/notes.png)

## 设计解决方案

这个时候，我们做了两个决定。我们要在启动应用的时候加一个简单的流程，询问没有填完信息的用户是否要把信息填写完整（提醒并且教育用户）。我们第三个目标就是“让用户随时随地编辑自己的信息”。我们决定沿用我们现在的引导模式，然后在抽屉式导航中加一个简单的编辑图标，这样就会进行跳转。

**注意：** 在 Intercom，我们其中的一个重要价值观就是“仰望星空，脚踏实地”。在这之前，我们一直在规划更新导航栏。，虽然加在底部导航栏中会比加在抽屉式导航栏中更好，然而那依赖于工程师大量的工作量，而我们需要尽快发布。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/13225749/Current-navigation-vs-planned-navigation.png)

在系统架构层面上，我们提出了 3 个用户状态，它们会让用户处于流程中的不同位置。在大方向上，我们知道流程由 3 个主要的步骤组成（示意图如下），这么做也是因为我们想让流程尽可能的简单和轻量。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20182815/entry.png)

系统设计的流程图还是很简单的，它从开始到结束是一段固定的路径，但是如果把用户状态也考虑进去，就会变得很复杂。但我们想让你直接跳到相关的步骤，而不是强迫你一定要走完整个流程。这里也需要考虑不同平台会有的特殊步骤，比如开启摄像头权限。不是所有的步骤都需要一个新页面。

于是，这些图表也会打印出来并且挂在我们的办公室里。工程师会常常站在墙前浏览整个流程，有时候还会提出一些边界情况，需要我们一起再对流程进行修改。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/13211829/diagram.png)

## 建模

到目前为止，我们已经有了框架，然后就可以将每个部分进行填充了。视觉和交互设计我们同时进行，然后在进行开发的时候也还要继续调整视觉。我们发现对于复杂的交互和动画，越早确定细节越好（这也是为什么高保真原型很棒的原因），因为之后再去做某些调整，比如更新资源、颜色等等，就会变得很困难，毕竟它和调整视觉设计不一样。

我们使用 [Framer JS](https://framer.com/) 来实现初期的交互原型，并和工程师对最后可以实现什么效果进行了讨论。下面是我们 iOS 应用最终的原型图，它经历了整整 12 轮调整。

从视觉设计的角度来说，我们的手机应用要和我们的品牌相契合。任何新的设计不仅需要在语言上保持一致性，还要重复使用必要的图案。所以我们和我们一流的[品牌设计团队](http://intercombrandstudio.tumblr.com/)一起合作完成了介绍页面和确认页面的图案。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/13211837/illustrations.png)

要成功说服用户，内容是至关重要的。我们需要解释清楚，为什么个人信息有那么重要。我们的内容策划师  [Elizabeth McGuane](https://blog.intercom.com/author/emcguane/) 也会亲临设计工作，以此创造出更加扣人心弦的体验，并帮助用户理解个人信息的重要性。

![](https://blog.intercomassets.com/wp-content/uploads/2017/03/20142756/Screen-Shot-2017-03-20-at-14.27.34-e1490020092177.png)

## 测试和调整

即使我们添加了之后提醒我的选项，我们依然清楚，会有很多用户跳过，他们不会按照流程去走。所以关键是要对整体的完成率和组件完成率进行数据上的统计，然后基于结果在测试阶段进行调整。

我们第一个版本达成的完成率相当低，特别是安卓版本。所以我们对设计又做了大量的调整，比如让之后提醒我的按钮不那么明显，调整布局和内容，使其多一点趣味性，少一点指导意味。

## 开发一个用户真正会使用的功能

经过一周的快速调整与监控，用户的个人信息完成率大幅度上升。由于多个小组的共同参与，我们看到了我们**信息完成率在一个月内从 14% 涨到了 46%**。这种移动端的设计流程大大推动了完成率的上升，而我们也从中总结了一系列具体的关键点，可以让我们将其应用到下一个项目中去。

- 确保问题对所有利益相关者和所有团队都是清楚明确的
- 用调查和数据解决问题，用概要目标去指导解决方案
- 不管做什么都要脚踏实地仰望星空
- 设计要尽早和程序对接，交换想法并明确概念
- 交互设计要尽早确定下来，趁着调整还不太难
- 明确成功的度量方法，跟踪解决办法是否有效，并确保还有时间进行调整

遵循这样一个明确、有逻辑的流程，大大增加了用户真正去使用新特性的可能性。起初整个流程可能会看起来太复杂，但是一旦养成了习惯，就会成为下意识的做法。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
