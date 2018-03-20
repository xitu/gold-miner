> * 原文地址：[A guide to the Google Play Console](https://medium.com/googleplaydev/a-guide-to-the-google-play-console-1bdc79ca956f)
> * 原文作者：[Dom Elliott](https://medium.com/@iamdom?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[IllllllIIl](https://github.com/IllllllIIl) [hanliuxin5](https://github.com/hanliuxin5)

# Google Play 控制台指南

## 无论你是企业用户还是作为技术人员，在 1 或 100 人的团队中，Play 控制台能为你做的都不仅仅是发布应用这么简单而已

![](https://cdn-images-1.medium.com/max/800/1*VRf8qf0oY8dxrdAfBFE3fg.png)

你或许使用 [Google Play 控制台](http://g.co/play/console)上传过 Android 应用或者游戏，创建一个商品详情并点击上传按钮把它添加到 Google Play 上。但你可能没意识到 Play 控制台其实还有很多其他的功能，特别是对那些专注于改善其应用的质量和业务表现的人。

和我一起来学习 Play 控制台；我将向你介绍每一个功能并指出其中一些有用的资源，以充分利用它们。一旦你熟悉了这些功能，你就可以通过用户管理控制，允许团队成员使用合适的特性功能或他们所需的数据。注意：在这篇文章中我所说的「应用」通常代表的意思是「应用或者游戏」。

目录跳转到：

*   [快速上手](#8b10)
*   [信息中心和统计信息（Dashboard and statistics）](#a5a0)
*   [Android vitals](#ed9a)
*   [开发工具（Development tools）](#add5)
*   [发布管理（Release management）](#4e06)
*   [Store 展示（Store presence）](#c527)
*   [用户获取（User acquisition）](#111b)
*   [财务报告（Financial reports）](#fb37)
*   [用户反馈（User feedback）](#d92a)
*   [全局 Play 控制台部分](#4f14)
*   [获取 Play 控制台应用](#a696)
*   [保持最新状态](#eb8c)
*   [疑问？](#3882)

* * *

### 快速上手

如果你受邀协助管理应用或你已经上传过一个应用，当你访问 Play 控制台时，你会看到如下所示的内容：

![](https://cdn-images-1.medium.com/max/800/1*_aVpZRSbE9Fc8NVdulvk4w.png)

这是当你拥有一个应用程序或游戏时，登录 Play 控制台后的视图。

在这篇文章中我会假设你已经拥有了一个应用。如果你刚开始发布你的第一个应用，看一下[启动清单](https://developer.android.com/distribute/best-practices/launch/launch-checklist.html)。稍后我会回到全局菜单选项（游戏服务，警报和设置）。

从列表中选择一个应用，然后跳转到其信息中心。在左侧有一个导航菜单（☰），可快速访问所有 Play 控制台的工具，让我们来依次的看一下。

* * *

### 信息中心和统计信息（Dashboard and statistics）

前两项是信息中心和统计信息。通过这些相关报告你可以对你的应用的表现情况做一个概览。

**信息中心（Dashboard）** 提供了安装和卸载情况的概要，安装排名前列的国家，安装的激活量，评分的数量和值，崩溃简报，Android vitals 的概要，以及一个发布前测试报告的列表。对于每个概要，点击 **查看详细信息（view details）** 以获取更多详细的信息。你可以在 7 天，30 天，1 年以及应用程序整个生命周期之间切换视图。

![](https://cdn-images-1.medium.com/max/800/1*giTv35N9RabYBOfzwQmejw.png)

应用的信息中心。

运气好的话，概要会显示出你的应用成功的获得了很高的安装率和很低的崩溃率。快速浏览信息中心是一种可以查看事情是否按照预期进行的简单的方法，要格外注意：卸载增长，崩溃增长，评分下滑，以及其他一些性能不佳的指标。如果这一切都不是你所预期的，那么你或你的工程师可以获得更多的细节来找出这些不同问题的原因。

**统计信息（Statistics）** 让你可以构建一个对你十分重要的应用数据视图。除了查看任何日期范围内的数据外，你还可以同时绘制两个指标，并将它们与前一个期间进行比较。你可以通过图表下方的表格中选定的维度（例如设备，国家/地区，语言或应用版本）对统计信息进行全面细分。有些统计数据每小时提供一次绘图，以获取更详细的情况。事件（例如应用程序的发布或销售）显示在图表和其下面的事件时间轴中，因此你可以了解到统计信息是因为什么而变化的。

![](https://cdn-images-1.medium.com/max/800/1*Abi3DL27q_HXPXxO4gDDHQ.png)

统计信息。

例如，你可能正在巴西进行新的应用推广。你就可以将报告设置为按国家显示安装情况，将国家/地区列表过滤为巴西（从维度表中），然后将数据与早期推广活动的数据进行比较，以清楚地了解你的促销活动的进展情况。

> **更多关于信息中心和统计信息的资源**
-[监控你的应用程序的统计信息，并查看预期之外的警报](https://developer.android.com/distribute/best-practices/launch/monitor-stats.html)

* * *

### Android vitals

> 大鱼游戏（Big Fish Games）在他们管理游戏的过程中[使用 Android vitals 减少 21％ 的崩溃](https://www.youtube.com/watch?v=qRXkEQOtQ98)，[Cooking Craze](https://play.google.com/store/apps/details?id=com.bigfishgames.cookingcrazegooglef2p).

**Android vitals** 主要是以性能和稳定性来衡量你应用的质量的一个工具。去年 Google 进行的一项内部研究考察了 Play Store 中的一星评论，发现 50％ 的人提到了应用程序的稳定性和错误。通过解决这些问题，对影响用户满意度是有积极作用的，从而使得更多人留下正面评论并保留你的应用。Android vitals 提供了关于应用性能的三个方面的信息：稳定性，渲染（也称为 jank）和电池寿命。

![](https://cdn-images-1.medium.com/max/800/1*yPQRAKol71_5xpShvtRUsQ.png)

Android vitals（只有 Play 有足够的关于您应用的数据时，才会显示每一项）。

前两项指标— **插入唤醒锁（stuck wake locks）**和**过度唤醒（excessive wakeups）**— 表明应用是否对电池寿命产生负面影响。这些报告显示应用程序是否要求设备长时间（一小时或更长时间）保持打开状态，或者经常要求设备唤醒（设备充满电后每小时唤醒超过 10 次）。

应用程序稳定性信息采用 **应用程序无响应（ANR）**和**崩溃率（crash rate）**报告的形式。正如本节中的所有概要一样，按应用版本，设备和 Android 版本提供细分。从概要中，你可以深入了解到哪些旨在帮助开发人员识别这些问题的原因的细节。最近对信息中心的改进中提供了有关 ANR 和崩溃的更多详细信息，使它们更易于诊断和修复。工程师可以从**ANR 和崩溃（crashs）**部分获取更多详细信息，并通过加载 **去混淆文件（de-obfuscation files）**来提高崩溃报告的可读性。

接下来的两项指标— **渲染速度减缓（slow rendering）**和**帧冻结（frozen frames）**—与开发人员称为 _jank_ 的内容或应用 UI 中的帧频不一致有关。每一次应用程序的 UI 抖动和卡顿都会导致糟糕的用户体验。这些统计数据会告诉你有多少用户会出现以下这些情况：

*   超过 15％ 的帧需要超过 16 毫秒才能完成渲染，或者
*   1000 帧中至少有一帧的渲染时间大于 700 毫秒。

**行为阈值（Behavior thresholds）**

对于每个指标，你都会看到一个**不良行为阈值（bad behavior threshold）**。如果你的某个 Android vitals 超出了不良行为阈值，你会看到一个红色的错误图标。这个图标表示你的应用程序在该指标的分数上高于其他应用程序（在这里值越高代表越差！）。你应该尽快解决这个糟糕的表现，因为若如果你的受众的用户体验不好，你的应用在 Play Store 中也会有不好的表现。这是因为 Google Play 的搜索和排名算法以及包含 Google Play 奖励在内的所有促销机会都会结合应用的 vitals 来考虑。超过不良行为阈值将导致排名降低。

> **更多关于 Android vitals 的资源：**
> 
> - [使用 Android vitals 提高你的应用的表现和稳定性](https://developer.android.com/distribute/best-practices/develop/android-vitals.html)
> - [了解如何调试和修复  Android vitals 文档中的问题](https://developer.android.com/topic/performance/vitals/index.html)
> - [在精不在多：为什么质量很重要](https://www.youtube.com/watch?v=hfpnldMBN38) (Playtime ‘17 session)
> - [用于优化 Android 应用程序的 10 个秘诀，以保持良好的用户体验](https://www.youtube.com/watch?v=ovPCRS_lEWU) (I/O ‘17 session)
> - [使用 Android 和 Play 中的工具来提高工作效率](https://www.youtube.com/watch?v=ySxCrzsKSGI) (I/O ‘17 session)

* * *

### 开发工具（Development tools）

我会略过这一部分；这是控制台为技术人员提供的一些工具。**服务和 API** 部分列出了各种服务及 API 的密钥和 ID，例如 Firebase Cloud Messaging 和 Google Play 游戏服务。而 **FCM 统计信息**会向你显示通过 Firebase Cloud Messaging 发送的与数据相关的信息。欲了解更多信息请[查看帮助中心](https://support.google.com/googleplay/android-developer/answer/2663268).

* * *

### Release management（发布管理）

> [Zalando](https://play.google.com/store/apps/details?id=de.zalando.mobilehttps://play.google.com/store/apps/details?id=de.zalando.mobile) focused on quality and used release management tools to 每季度[减少 90％ 的崩溃次数并将用户终身价值提高 15％。](https://youtu.be/Aau8LWGdBFE)。

在 **Release management（发布管理）** 部分中，你可以控制如何让你的新应用或者已更新的应用被人们来安装。这包括在发布之前测试你的应用程序，设置正确的设备定位，管理和监控测试，以及产品的实时追踪。

随着应用程序版本的发布，**发布信息中心（release dashboard）** 将为你提供重要统计数据的整体视图。你还可以将当前版本与过去的版本进行比较。你可能还想和一个不太满意的版本做比较，以确保类似的情况不会再发生。或者与最佳的版本进行比较，看看是否能做进一步改进。

![](https://cdn-images-1.medium.com/max/800/1*HfxpJpQzXrPj77c6MATgkA.png)

发布信息中心。

你应该在发布时使用 **分阶段发布（staged rollouts）**。你可以选择一定比例的受众群体来接收应用更新，然后监控发布信息中心。如果事情进展不


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
