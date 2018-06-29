> * 原文地址：[A guide to the Google Play Console](https://medium.com/googleplaydev/a-guide-to-the-google-play-console-1bdc79ca956f)
> * 原文作者：[Dom Elliott](https://medium.com/@iamdom?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)，[IllllllIIl](https://github.com/IllllllIIl)

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

从列表中选择一个应用，然后跳转到其信息中心。在左侧有一个导航菜单（三），可快速访问所有 Play 控制台的工具，让我们来依次的看一下。

* * *

### 信息中心和统计信息（Dashboard and statistics）

前两项是信息中心和统计信息。通过这些相关报告你可以对你的应用的表现情况做一个概览。

**信息中心**（**Dashboard**）提供了安装和卸载情况的概要，安装排名前列的国家，安装的激活量，评分的数量和值，崩溃简报，Android vitals 的概要，以及一个发布前测试报告的列表。对于每个概要，点击**查看详细信息**（**view details**）以获取更多详细的信息。你可以在 7 天，30 天，1 年以及应用程序整个生命周期之间切换视图。

![](https://cdn-images-1.medium.com/max/800/1*giTv35N9RabYBOfzwQmejw.png)

应用的信息中心。

运气好的话，概要会显示出你的应用成功的获得了很高的安装率和很低的崩溃率。快速浏览信息中心是一种可以查看事情是否按照预期进行的简单的方法，要格外注意：卸载增长，崩溃增长，评分下滑，以及其他一些性能不佳的指标。如果这一切都不是你所预期的，那么你或你的工程师可以获得更多的细节来找出这些不同问题的原因。

**统计信息**（**Statistics**）让你可以构建一个对你十分重要的应用数据视图。除了查看任何日期范围内的数据外，你还可以同时绘制两个指标，并将它们与前一个期间进行比较。你可以通过图表下方的表格中选定的维度（例如设备，国家/地区，语言或应用版本）对统计信息进行全面细分。有些统计数据每小时提供一次绘图，以获取更详细的情况。事件（例如应用程序的发布或销售）显示在图表和其下面的事件时间轴中，因此你可以了解到统计信息是因为什么而变化的。

![](https://cdn-images-1.medium.com/max/800/1*Abi3DL27q_HXPXxO4gDDHQ.png)

统计信息。

例如，你可能正在巴西进行新的应用推广。你就可以将报告设置为按国家显示安装情况，将国家/地区列表过滤为巴西（从维度表中），然后将数据与早期推广活动的数据进行比较，以清楚地了解你的促销活动的进展情况。

> **更多关于信息中心和统计信息的资源：**
> -[监控你的应用程序的统计信息，并查看预期之外的警报](https://developer.android.com/distribute/best-practices/launch/monitor-stats.html)

* * *

### Android vitals

> 大鱼游戏（Big Fish Games）在他们管理游戏的过程中[使用 Android vitals 减少 21％ 的崩溃](https://www.youtube.com/watch?v=qRXkEQOtQ98)，[Cooking Craze](https://play.google.com/store/apps/details?id=com.bigfishgames.cookingcrazegooglef2p).

**Android vitals** 主要是以性能和稳定性来衡量你应用的质量的一个工具。去年 Google 进行的一项内部研究考察了 Play Store 中的一星评论，发现 50％ 的人提到了应用程序的稳定性和错误。通过解决这些问题，对影响用户满意度是有积极作用的，从而使得更多人留下正面评论并保留你的应用。Android vitals 提供了关于应用性能的三个方面的信息：稳定性，渲染（也称为 jank）和电池寿命。

![](https://cdn-images-1.medium.com/max/800/1*yPQRAKol71_5xpShvtRUsQ.png)

Android vitals（只有 Play 有足够的关于您应用的数据时，才会显示每一项）。

前两项指标—**插入唤醒锁**（**stuck wake locks**）和**过度唤醒**（**excessive wakeups**）—表明应用是否对电池寿命产生负面影响。这些报告显示应用程序是否要求设备长时间（一小时或更长时间）保持打开状态，或者经常要求设备唤醒（设备充满电后每小时唤醒超过 10 次）。

应用程序稳定性信息采用**应用程序无响应**（**ANR**）和**崩溃率**（**crash rate**）报告的形式。正如本节中的所有概要一样，按应用版本，设备和 Android 版本提供细分。从概要中，你可以深入了解到哪些旨在帮助开发人员识别这些问题的原因的细节。最近对信息中心的改进中提供了有关 ANR 和崩溃的更多详细信息，使它们更易于诊断和修复。工程师可以从 **ANR 和崩溃**（**crashs**）部分获取更多详细信息，并通过加载**去混淆文件**（**de-obfuscation files**）来提高崩溃报告的可读性。

接下来的两项指标—**渲染速度减缓**（**slow rendering**）和**帧冻结**（**frozen frames**）—与开发人员称为 _jank_ 的内容或应用 UI 中的帧频不一致有关。每一次应用程序的 UI 抖动和卡顿都会导致糟糕的用户体验。这些统计数据会告诉你有多少用户会出现以下这些情况：

*   超过 15％ 的帧需要超过 16 毫秒才能完成渲染，或者
*   1000 帧中至少有一帧的渲染时间大于 700 毫秒。

**行为阈值（Behavior thresholds）**

对于每个指标，你都会看到一个**不良行为阈值**（**bad behavior threshold**）。如果你的某个 Android vitals 超出了不良行为阈值，你会看到一个红色的错误图标。这个图标表示你的应用程序在该指标的分数上高于其他应用程序（在这里值越高代表越差！）。你应该尽快解决这个糟糕的表现，因为若如果你的受众的用户体验不好，你的应用在 Play Store 中也会有不好的表现。这是因为 Google Play 的搜索和排名算法以及包含 Google Play 奖励在内的所有促销机会都会结合应用的 vitals 来考虑。超过不良行为阈值将导致排名降低。

> **更多关于 Android vitals 的资源：**
> - [使用 Android vitals 提高你的应用的表现和稳定性](https://developer.android.com/distribute/best-practices/develop/android-vitals.html)
> - [了解如何调试和修复  Android vitals 文档中的问题](https://developer.android.com/topic/performance/vitals/index.html)
> - [在精不在多：为什么质量很重要](https://www.youtube.com/watch?v=hfpnldMBN38) (Playtime ‘17 session)
> - [用于优化 Android 应用程序的 10 个秘诀，以保持良好的用户体验](https://www.youtube.com/watch?v=ovPCRS_lEWU) (I/O ‘17 session)
> - [使用 Android 和 Play 中的工具来提高工作效率](https://www.youtube.com/watch?v=ySxCrzsKSGI) (I/O ‘17 session)

* * *

### 开发工具（Development tools）

我会略过这一部分；这是控制台为技术人员提供的一些工具。**服务和 API** 部分列出了各种服务及 API 的密钥和 ID，例如 Firebase Cloud Messaging 和 Google Play 游戏服务。而 **FCM 统计信息**会向你显示通过 Firebase Cloud Messaging 发送的与数据相关的信息。欲了解更多信息请[查看帮助中心](https://support.google.com/googleplay/android-developer/answer/2663268).

* * *

### 发布管理（Release management）

> [Zalando](https://play.google.com/store/apps/details?id=de.zalando.mobilehttps://play.google.com/store/apps/details?id=de.zalando.mobile) focused on quality and used release management tools to 每季度[减少 90％ 的崩溃次数并将用户终身价值提高 15％。](https://youtu.be/Aau8LWGdBFE)。

在**发布管理**（**Release management**）部分中，你可以控制如何让你的新应用或者已更新的应用被人们来安装。这包括在发布之前测试你的应用程序，设置正确的设备定位，管理和监控测试，以及产品的实时追踪。

随着应用程序版本的发布，**发布信息中心**（**release dashboard**）将为你提供重要统计数据的整体视图。你还可以将当前版本与过去的版本进行比较。你可能还想和一个不太满意的版本做比较，以确保类似的情况不会再发生。或者与最佳的版本进行比较，看看是否能做进一步改进。

![](https://cdn-images-1.medium.com/max/800/1*HfxpJpQzXrPj77c6MATgkA.png)

发布信息中心。

你应该在发布时使用**分阶段发布**（**staged rollouts**）。你可以选择一定比例的受众群体来接收应用更新，然后监控发布信息中心。如果事情进展不顺利— 例如崩溃持续增加，评级下降或卸载量增加—在太多用户受到影响之前，你可以点击**管理版本**（**manage release**）并暂停部署。运气好的话，希望你们的工程师能在恢复部署（如果问题不需要应用程序更新）或启动新版本（如果需要更新）之前解决这些问题。如果一切顺利的话，你可以继续提高收到更新的受众群体的百分比，直到达到 100％。

> Google Play 你将测试版本的软件发布到全球发布，并持续获取用户的反馈。这使我们能够查看到真实的数据并尽可能为我们的玩家制作最好的游戏。

> — [David Barretto, Hutch Games 的 CEO 和联合创始人](https://www.youtube.com/watch?v=jLOIwdKiSd0)

**应用程序发布（App releases）** 是应用程序包（你的 APK）上传和准备发布的地方。应用可以发布到不同的渠道：**alpha**，**beta** 和 **production**。在 alpha 和 beta 渠道上进行受信任用户的封闭测试或任何人都可以加入的公开测试。在准备发布时，你可以将其保存为草稿，这使得你有机会反复并仔细的编辑应用的详细信息，直到你准备好要发布为止。

> **[免安装应用]使用户无需额外从 Play Store 安装应用程序即可轻松获得出色的应用体验。我们已经看到我们的即时应用取得了巨大成功。**

> - [Laurie Kahn, Realtor.com 的首席产品经理](https://developer.android.com/stories/instant-apps/realtor-com.html)

**Android 免安装应用**（**Instant Apps**）部分就像应用程序发布，只不过是为了适用于免安装应用。如果你还不熟悉免安装应用，它们允许用户通过链接即时访问应用程序的部分功能，而不必花时间从 Play Store 下载完整的应用程序。查看 [Android 免安装应用](https://developer.android.com/topic/instant-apps/index.html)文档获取更多详细信息。

**工件库**（**artifact library**）是一个专门展示你为发布应用上传的所有文件集合的部分，例如 APK，假如出于某些需要，你可以回顾并从这里下载某些旧的 APK。

> 在第一次使用时，[设备目录（device catalog）]让我避免了去做出一个糟糕的，不知情的决定。我当时正打算移除一种支持设备，但后来我发现它有着很好的安装，4.6 的评分和 30 天的重要收入。在目录中有这样的数据非常棒！

> - Oliver Miao, [Pixelberry Studios](https://play.google.com/store/apps/developer?id=Pixelberry&hl=en) 的创始人和首席执行官

**设备目录**（**device catalog**）包含数千台经过 Google 认证的 Android 和 Chrome 操作系统设备，可提供搜索和查看设备规格的功能。通过精细筛选控制，你可以移除使用范围较小的问题设备，以便在你的应用能在所有支持的设备上提供最佳体验。你可以单独移除设备和/或通过性能指标（如 RAM 和芯片系统）来设置规则。该目录还显示每种设备类型的安装量，评分和收入。例如，特定设备的平均评分较低，可能是设备问题在一般测试中没有被捕捉到导致的。你可以移除这样的设备，并暂时停止新的安装，直到你完成修复。

![](https://cdn-images-1.medium.com/max/800/1*5bPHUQncjHlGsIPD2rnIBA.png)

设备目录。

**应用签名**（**App signing**）是我们为帮助你保护应用签名密钥的安全而推出的一项服务。Google Play 上的每个应用都由其开发人员签名，提供了一个可追踪的声明来让开发人员证明 “真的是我开发的这个 app”。如果用于签名应用程序的密钥丢失，这是一个严重问题。你将无法更新你的应用程序。作为替代，你需要上传一个新的应用程序，你将失去应用程序的安装历史记录，评分和评论，并且尝试切换时可能会导致用户混淆。使用应用程序签名后，你可以上传应用程序签名密钥，将其安全的存储到 Google 的云中。这与使用 Google 存储我们的应用密钥的技术是相同的，这得益于我们在业界领先的安全基础架构。上传的密钥随后可用于在你提交更新时为你的应用签名。当你第一次上传全新的应用程序时，你可以很容易注册应用程序签名。而我们将为你生成应用签名密钥。

![](https://cdn-images-1.medium.com/max/800/1*6RcDJJp7WPjANQKcMjuYtQ.png)

应用签名（由 Google Play 提供的服务）。

> 应用开发语言学习者 [Erudite](https://play.google.com/store/apps/dev?id=7358092740483658893&hl=en) 因为[使用预发行报告提高了 60% 的留存率](https://www.youtube.com/watch?v=WMJR6CuPp4w&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c&index=17v).

本节的最后一个部分是**预发行报告**（**re-launch report**）。当你上传应用的 alpha 版或 beta 版时，我们会在 Android 的 Firebase 测试实验室中针对各种规格的流行设备进行自动化测试，并展示结果。这些测试会查找月崩溃，性能和安全漏洞相关的一些错误和问题。您可以查看在不同设备和不同语言中运行的应用的屏幕截图。你还可以设置证书，以便在登录后执行测试，以及使用 Google Play 许可服务来测试应用程序。

![](https://cdn-images-1.medium.com/max/800/1*bc-LZ91iCVuIXTNjq5XlyQ.png)

预启动报告（Pre-launch report）（自动生成 alpha/beta 版）。

在发行一个 app 后，有限或不完整的测试可能会使应用因为其质量问题导致低评分和负面评论，从而使得应用被推出，这种情况很难恢复。预发行报告是全面测试以及帮助你识别和修复应用中的常见问题的良好开端。然而，您仍然需要运行一套测试来全面检查您的应用。在 [**Android 的 Firebase 测试实验室**](https://firebase.google.com/docs/test-lab/)中来构建测试，该测试通过预发行报告来提供其他功能，并且测试实验室能够在多台设备上自动运行这些测试，这可能比人工测试更有效及高效。

> **更多关于发布管理的资源：**
> - [根据质量准则进行测试来满足用户期望](https://developer.android.com/distribute/best-practices/develop/quality-guidelines.html)
> - [使用预发行和崩溃报告来改进您的应用](https://developer.android.com/distribute/best-practices/launch/pre-launch-crash-reports.htmlhttps://developer.android.com/distribute/best-practices/launch/pre-launch-crash-reports.html)
> - [用 Beta 版测试你的应用程序并获取用户宝贵的早期反馈](https://developer.android.com/distribute/best-practices/launch/beta-tests.html)
> - [分段发布更新以确保获得积极的反响](https://developer.android.com/distribute/best-practices/launch/progressive-updates.html)
> - [推出手机游戏的新时代](https://medium.com/googleplaydev/a-new-era-of-launching-mobile-games-ef2453686f73) (Medium 推送)
> - [发布你的游戏](https://www.youtube.com/watch?v=rV9Q6AMdt84) (Playtime ‘17 session)
> - [新版本和设备定位工具](https://www.youtube.com/watch?v=peCWuCSIv7U) (I/O ‘17 session)
> - [注册应用签名以保护您的应用密钥](https://www.youtube.com/watch?v=PuaYhnGmeEk) (DevByte video)

* * *

### Store 展示（Store presence）

你可以在此部分管理应用在 Google Play 上的宣传文案，针对应用的内容运行实验，设置定价和市场，获取内容分级，管理应用内商品以及获取翻译。

**商品详情**（**Store listing**）部分和你想象中的一样—这是你维护应用元数据的地方，例如其标题，说明，图标，功能图片，功能视频，屏幕截图，商店分类，联系详情和隐私政策。

![](https://cdn-images-1.medium.com/max/800/1*GGu4yJsG73asnwF8X_QFmQ.png)

商品详情（Store listing）。

一个好的的商品详情应该有一个醒目的图标; 一个用于展示应用程序的特别之处的功能的图形，视频和屏幕截图（支持所有设备类别和所有方向）; 以及一个引人注目的描述。对于游戏，请上传视频和至少三张横屏截图，以确保您的游戏符合 Play Store 游戏部分中的视频/屏幕截图群集。了解哪些内容最适合并推动最多安装可能是一项挑战。但是，控制台的下一部分旨在回答这个问题。

> 通过利用应用程序的图标和屏幕截图进行商品详情实验后，日本房地产应用程序 [LIFULL HOME’S](https://play.google.com/store/apps/details?id=jp.co.homes.android3) [安装率增加了 188％](https://www.youtube.com/watch?v=PXW6zcm3-4c&index=7&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c).

**商品详情实验室**（**Store listing experiments**）使你能够测试商品详情的许多方面，例如其说明，应用图标，功能图形，屏幕截图和促销视频。你可以对图像和视频进行全局实验，以及对文本进行本地化实验。进行实验时，你最多可以指定要测试的项目的三种变体，并且你将会看到测试变体所占的 store 访问者的百分比。这个实验会一直运进行直到统计到足够多的 store 访问者为止，然后会告诉你如何去比较变体。如果你得到了具有明确优势的变体，您可以选择将该变体应用于商品详情并将其展示给所有访问者。

![](https://cdn-images-1.medium.com/max/800/1*xbwluyqq7-UQhO-Auce_hg.png)

商品详情实验室（Store listing experiments）。

有效的实验需要从一个明确的目标开始。首先要测试你的应用程序图标，因为它是你的清单中最明显的部分，其次是其他清单内容。每个实验测试一种内容类型以获得更可靠的结果。实验应至少运行七天，尤其是在商店流量较低的情况下，以达到 store 访问者的 50%—但如果测试可能会有一些风险，请保持较低的百分比。通过反复从实验中获取表现良好的内容并针对主题进行进一步的迭代。例如，如果你的第一个测试发现一个更好的元素添加到游戏的图标中，你的下一个实验可以测试一下图标背景颜色变化所带来的影响。

**定价和分发**（**Pricing & distribution**）是你为应用设置价格的地方，并且可以限制其分发的国家/地区。你还可以在这里指出你的应用是否针对特定设备类别（如 Android Wear）进行了支持，以及你的应用是否适用于诸如 Designed for Families 之类的计划。每个设备类别和程序都有相关要求和最佳做法，我在下面添加了有关每种设备更多信息的链接。

![](https://cdn-images-1.medium.com/max/800/1*AV9a0VumHeQwlGUkqgiDOQ.png)

定价和分发（Pricing & distribution）。

在设定价格时，你会看到一个本地化功能，控制台会自动将价格调整为最符合该指定国家/地区的惯例。例如，日本的结算价格为 .00。此时，你可能还想创建一个 **定价模板**（**pricing template**）。使用定价模板，你可以按国家/地区创建一组价格，然后将其应用于多个付费应用和应用内商品。对模板所做的任何更改都会自动应用于所有使用该模板设置过价格的应用或产品。在控制台的全局设置菜单中可以找到你的定价模板。

在为应用程序设置了详细信息后，最有可能重回此部分的原因是运行付费应用程序的销售，选择加入新程序或更新应用程序分发的国家列表。

> **详细了解分配设备类别和程序：**
> - [分发到 Android Wear](https://developer.android.com/distribute/best-practices/launch/distribute-wear.html)
> - [分发到 Android TV](https://developer.android.com/distribute/best-practices/launch/distribute-tv.html)
> - [分发到 Android Auto](https://developer.android.com/distribute/best-practices/launch/distribute-auto.html)
> - [优化 Chrome OS 设备](https://developer.android.com/distribute/best-practices/engage/optimize-for-chromebook.html)
> - [分发到 Daydream](https://developer.android.com/distribute/best-practices/develop/daydream-and-cardboard-vr.html)
> - [使用托管的 Google Play 分发给企业和组织](https://developer.android.com/distribute/google-play/work.html)
> - [分发以家庭或孩子为中心的应用程序和游戏](https://developer.android.com/distribute/google-play/families.html)

接下来是你的应用的**内容评级**（**content rating**）。通过回答内容评级调查问卷获得评分，完成后，你的应用将收到来自世界各地认可机构贴切的评分标记。没有内容分级的应用将从 Play Store 中删除。

**应用内商品**（**in-app products**）部分是你维护从你的应用中出售的产品和订阅目录的地方。在这里添加商品不会为你的应用或游戏增加功能，每个产品的交付或解锁或订阅都需要编码到应用中。这里的信息决定了 store 对这些商品所做的事情，比如它向用户收费的金额以及续订的时间。因此，对于应用内商品，除了说明和价格明细之外，你还可以添加其订阅时描述和价格，然后添加结算周期，试用期和未付款宽限期。项目价格可以单独设置或基于定价模板设置。如果价格是为各国单独设定的，你可以接受根据当前汇率所得的价格或手动设置每个价格。

![](https://cdn-images-1.medium.com/max/800/1*EzneiTuF-mc_0U9JrWfpBw.png)

应用内商品（in-app products）。

> Noom [国际收入增长了 80%](https://developer.android.com/stories/apps/noom-health.html) 通过将其应用在Google Play 上本地化。

本部分的最后一个选项是**翻译服务**（**translation service**）。Play 控制台让你可以通过可靠的经过审核的翻译人员，将你的应用翻译成新的语言。当你的应用程序以当地的语言提供时，这将有很大的可能提高商品详情转换率以及增加定的国家/地区的安装次数。Play 控制台中有一些工具可帮助识别要翻译成哪些合适的语言。例如，通过使用收入报告，你可以识别哪些访问商品详情较多但安装量却较低的国家/地区。如果您的技术团队正在通过此服务翻译应用的用户界面，那么你也可以得到翻译文本。通过在提交翻译之前在 strings.xml 文件中包含商店列表元数据，应用内商品名称和通用应用推广文本来实现这一点。

> **更多关于 store 展示的资源：**
> - [制作引人注目的 Google Play Store 详情以吸引更多的安装](https://developer.android.com/distribute/best-practices/launch/store-listing.html)
> - [使用引人注目的功能图形来展示你的应用](https://developer.android.com/distribute/best-practices/launch/feature-graphic.html)
> - [使用商品详情实验室将更多访问转化为安装](https://developer.android.com/distribute/best-practices/grow/store-listing-experiments.html)
> - [走向全球并在新的国家成功培养有价值的观众](https://developer.android.com/distribute/best-practices/grow/go-global.html)

* * *

### 用户获取（User acquisition）

> 相较于其他移动平台 Peak Games 在 Android 平台上[平均成本降低了 30% — 40%](https://www.youtube.com/watch?v=eNpDqYoHFZk) 。

每个开发者都希望能吸引受众，Play 控制台的这一部分是关于理解和优化用户的获取及保留的。

在**收获报告中**（**acquisition reports**），根据你是销售应用内商品还是订阅，最多可以访问三份报告（顶部的标签）：

*   **保留的安装程序**（**Retained Installers**）—显示应用程序在 Store 页面的访问者数量，然后显示其中有多少人安装了你的应用程序并将其保留了 30 天以上。
*   **购买者**（**Buyers**）—显示应用程序在 Store 页面的访问者数量，然后有多少人安装了您的应用程序，然后继续购买一个或多个应用内商品或订阅。
*   **订阅者**（**Subscribers**）—显示应用在 Store 页面的访问者数量，然后显示其中有多少人安装了您的应用，然后继续激活了应用内订阅。

每个报告都包含一个图表，显示报告期间访问你应用在商品详情页面的用户数量，其次是安装人员的数量，保留安装人员的数量以及（在购买者或订阅报告中）购买者或订阅的人数。如果我们确定没有足够的数据可显示，那么一些报告将是空白的。使用「衡量」（measured by）下拉菜单在按以下方式细分的数据之间切换：

*   **获取渠道**（**Acquisition channel**）—显示访问者来自哪里的数据表格，如 Play Store，Google 搜索，AdWords 等。
*   **国家/地区**（**Country**）—显示每个国家/地区访问者的总人数。
*   **国家/地区**（**Country**）（**Play Store organic**）—通过过滤国家/地区总数有机地向你展示访问者通过 Google Play 上搜索和浏览来到你的商品详情页面。

在所有报告中，你可以切换选项以查看未访问商品详情页面的安装者数量，例如直接从 Google 搜索结果或 play.google.com/store 安装的安装者。

![](https://cdn-images-1.medium.com/max/800/1*2SKVVb8Osd4EE15tlkq9Bg.png)

收入报告。

当通过审查收入渠道或国家/地区（Play Store organic）的报告时，如果有足够的数据，你将看到**转化率基准**（**conversion rate benchmarks**）。根据你的应用的类别和获利方式，这些基准将提供一个关于你的应用的性能与 Play Store 中的所有类似应用的比较。基准是一种方便的方法，用于检查你是否在操作安装时做得很好。

![](https://cdn-images-1.medium.com/max/800/1*Mkdd5i--pE8ha_iZu-8U_w.png)

转化率基准。

增加安装量的方法之一是进行推广活动，并且你可以从 **AdWords 推广系列快速入门**。你可以在本节创建和跟踪一个通用应用推广系列。这种类型的推广系列使用 Google 的机器学习算法为你的应用程序找到最佳收入渠道以及目标每次安装费用（CPI）。为推广系列提供文字，图片和视频，其余部分则由 AdWords 完成，通过 AdMob 广告网络在 Google Play，Google Search，YouTube，其他应用以及 Google Display Network 网络中的移动网站上投放广告。

一旦你的通用应用推广系列投入运行，你将在收入报告中获得更多数据。要详细了解和跟踪情况，请查看 AdWords 帐户中的报告。

推动安装和参与的另一个选择是进行**促销**。你可以在此创建促销码并管理促销活动，以便免费赠送应用或应用内商品的副本。例如，你可以在社交媒体上的营销中或在电子邮件活动中使用促销码。

本节最后的功能是**优化建议**。这些建议是在我们检测到存在可以改善你的应用程序及其性能的更改时自动生成的。在其他建议中，优化建议可能会建议你根据你的应用受欢迎的地区的语言来翻译你的应用，识别使用了某些过时的 Google API，确定你是否从使用 Google Play 游戏服务中受益，亦或者检测你的应用还未对平板电脑进行优化。每个建议都包含了帮助你实施的说明。

> **更多关于获取和保留用户的资源：**
> - [了解具有价值的用户来自哪里并优化您的营销](https://developer.android.com/distribute/best-practices/grow/user-aquisition.html)
> - [通过通用应用推广系列增加下载量](https://developer.android.com/distribute/best-practices/grow/install-ads.html)
> - [走向全球，成功地在新的国家增加有价值的观众](https://developer.android.com/distribute/best-practices/grow/go-global.html)
> - [打消付费用户获取的疑虑](https://medium.com/googleplaydev/taking-the-guesswork-out-of-paid-user-acquisition-720d9d74882e) (来自 Medium)
> - [缩小 APK，增加安装量](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2) (来自 Medium)
> - [如何针对新兴市场优化您的 Android 应用程序](https://medium.com/googleplaydev/how-to-optimize-your-android-app-for-emerging-markets-7124c4180fc) (来自 Medium)
> - [在 Google Play上制作有帮助的数据](https://www.youtube.com/watch?v=Dr82cv6Lj0c) (I/O ‘17 大会)

* * *

### 财务报告（Financial reports）

> Play 提供的分析和测试功能无与伦比，为开发如 Hooked 这样应用的开发者们提供了帮助其发展的重要见解，对帮助我们理解和优化我们的收入至关重要。

> —Prerna Gupta, 创始人 & CEO, [HOOKED](https://play.google.com/store/apps/details?id=tv.telepathic.hooked)

如果你销售应用，应用内商品或订阅，则需要跟踪并了解你的收入进展情况。**财务报告**（**Financial reports**）部分可让你访问多个信息中心和报告。

该部分的第一份报告提供了收入和购买者的**概览**。该报告显示了与上一期报告相比，你的收入和买家购买力是如何变化的。

![](https://cdn-images-1.medium.com/max/800/1*0gplcgqBGeRlPJ6wgQp-oQ.png)

财务报告（Financial reports）。

单独的报告提供了**收入**（**revenue**），**购买者**（**buyers**）和**转化**（**conversions**）的详细分类，可以深入了解用户的支出模式。每个报告都允许你查看特定时段的数据，例如最后一天，7 天，30 天或在应用程序的整个生命周期。你还可以深入了解收入和买家报告中的设备以及国家/地区数据。

转化报告有助于你讲了解用户的支出模式。**转化率**表格显示了你的受众群体在你的应用中购买商品的百分比，并帮助你了解最近的更改对转化的影响。**买家平均开销**的表可以让你深入的了解用户的消费习惯是如何改变的以及付费用户的生命周期价值。

> **更多关于获利的资源：**
> - [使用 Google Play 帐单销售应用内商品](https://developer.android.com/distribute/best-practices/earn/in-app-purchases.html)
> - [设计你的应用来推动转化](https://developer.android.com/distribute/best-practices/develop/design-to-drive-conversions.html)
> - [使用针对 Firebase 的 Google 分析来提高转化次数](https://developer.android.com/distribute/best-practices/earn/improve-conversions.html)
> - [从应用程序浏览者到首次购买者](https://medium.com/googleplaydev/from-app-explorer-to-first-time-buyer-6476be50893) (来自 Medium)
> - [预测你的应用的获利的未来](https://medium.com/googleplaydev/predicting-your-apps-future-65b741999e0e) (来自 Medium)
> - [提高游戏即服务货币化的五大技巧](https://medium.com/googleplaydev/five-tips-to-improve-your-games-as-a-service-monetization-1a99cccdf21) (来自 Medium)
> - [推动 Android 应用转化](https://www.youtube.com/watch?v=P2z1CnNj6ag) (‘17 大会游戏时间)
> - [与游戏的生命周期价值一起玩耍](https://www.youtube.com/watch?v=mZIIMRbh8z8) (‘17 大会游戏时间)
> - [在 Google Play 上赚钱](https://www.youtube.com/watch?v=LQ6MsPmUa38) (DevByte)
> - [Play 应用内结算库 1.0](https://www.youtube.com/watch?v=y78ugwN4Obg) (DevByte 视屏)

> 随时可用于分析的订阅数据很有价值。能够看到订阅如何随着时间的推移而变化，许多开发人员认为这是有用的。

> —Kyle Grymonprez，[Glu](https://play.google.com/store/apps/developer?id=Glu) 跨平台和 Android 开发负责人 

最后，如果你发放**订阅**，信息中心将为你提供订阅如何进行的全面视图，以帮助你可就如何增加订阅，减少取消和增加收入方面做出更好的决策。信息中心包括概述，详细的订阅获取报告，终生保留报告和取消报告。你可以使用此信息来发现优化营销和应用内消息的机会，以推动新的订阅以及减少客户流失。

![](https://cdn-images-1.medium.com/max/800/1*AunDgPC8DHfFXLBzlN3PXg.png)

订阅信息中心。

> **更多关于订阅的资源：**
> - [通过 Google Play 帐号销售订阅](https://developer.android.com/distribute/best-practices/earn/subscriptions.html)
> - [建立全天候的订阅业务](https://medium.com/googleplaydev/building-a-subscriptions-business-for-all-seasons-7ffd95b3f929) (来自 Medium)
> - [如何留住你的应用的订阅者们](https://medium.com/googleplaydev/how-to-hold-on-to-your-apps-subscribers-eebb5965e267) (来自 Medium)
> - [智对订阅难点](https://medium.com/googleplaydev/outsmarting-subscription-challenges-711216b6292c) (来自 Medium)
> - [使用行为经济学来传达价值订阅](https://medium.com/googleplaydev/using-behavioural-economics-to-convey-the-value-of-paid-app-subscriptions-cd96ca171d5b) (来自 Medium)
> - [通过 Google Play 上的订阅获得更多收益](https://www.youtube.com/watch?v=hRZPXgRhOH0) (I/O ‘17 大会)

* * *

### 用户反馈（User feedback）

> **评分和评论部分是了解你们社区的强大工具。在 Google 翻译的帮助下，我们用他们的母语回答他们。因此，我们看到用户评分有了很大提高。事实上，他们全部都是 4.4 星，甚至更高。**

> **—** [**Papumba 首席产品官员 Andres Ballone**](https://www.youtube.com/watch?v=9M9mAhYAspU)

通过评论进行评分和用户反馈非常重要。Play Store 的访问者在决定是否安装它时会考量你的应用的评分和评论。评论还提供了一种与受众群体进行互动的方式，并收集有关对你的应用有帮助的反馈。

**评分**是随着时间推移按照国家/地区，语言，应用版本，Android 版本，设备和运营商得出的所有评分的摘要。你可以深入了解这些数据，以了解你的应用的评分与其应用类别的基准评分的对比情况。

在分析这些数据时，需要注意两件关键的事情。首先是随着时间推移而变化的评分，特别是其上升或者下降时。平分的降低则表明你需要查看最近的更新。也许更新使得应用程序难以使用或引入了导致其更频繁崩溃的问题。第二种用法是寻找与评分整体水平不一致的地方。也许对某种语言的评价很低—这意味着你的翻译可能牛头不对马嘴。或者可能在特定设备上的评分较低—表明你的应用未针对该设备进行优化。如果你的评分总体上较好，那么查找并解决「挑刺儿」差评可帮助你提高评分，特别是在难以找到应用改进机会的情况下。

![](https://cdn-images-1.medium.com/max/800/0*Qv_i6KSksTlTz8sL.)

评分。

> **我们使用评论分析（reviews analysis）来收集用户在 Google Play 上的反馈，并使用它们来改善 Erudite 的功能。它还使我们能够直接单独的回复用户，因此我们可以提升与用户的沟通并了解他们的真实需求。**

> **—** [**Benji Chan, Erudite 的产品经理**](https://www.youtube.com/watch?v=WMJR6CuPp4w)

用户可以在不提供评论的情况下为你的应用打分，但是当评分包含评论时，通过其内容可以洞悉是什么导致了这个评分。这是**评论分析**（**reviews analysis**）部分发挥作用的地方。它提供了三种见解：更新后的评分（updated ratings），基准（benchmarks）和话题分析（topic analysis）。

![](https://cdn-images-1.medium.com/max/800/0*pijImEKdKgfJG-hF.)

评论分析（reviews analysis）。

**更新后的评分**（**updated ratings**）可帮助你了解更改评论的用户是如何更改他们提供的评分的。数据在你回复的评论和没有回复的评论之间进行了细分。你会发现报告显示，对差评进行回复（例如，如果你答复让用户知道问题已得到解决）通常会使用户返回并向上修改其评分。

**基准**（**benchmarks**）根据应用类别的常见评论话题来提供评分分析。因此，例如，你可以看到用户如何提及你的应用的注册体验以及该项的评论是如何对你的评分作出贡献的。此外，你还可以看到你的评分和评论数量与同一类别中的类似应用的比较情况。如果你想进一步了解，点击一个话题去查看构成此分析的评论。

**话题**（**Topic**）提供了有关应用评价中使用的关键字的信息及其对评分的影响。从每个单词中，你可以深入了解这些出现的评论的详细信息，以便可以更详细地了解所发生的情况。此功能为英语，印地语，意大利语，日语，韩语和西班牙语的评论提供分析。

> **它使我们可以轻松地搜索评论，并且在需要获取更多信息时联系用户，一般而言，它为我节省了大量时间，每周大约节省 5 到 10 小时。**

> **— Olivia Schafer，[Aviary](https://play.google.com/store/apps/dev?id=5644820617218674509) 的社区支持专家**

在**评论**（**reviews**）部分中，你可以查看个别评论。默认视图显示所有来源和所有语言的最新评论。使用过滤器选项来优化列表。注意**所有回复状态**（**all reply states**）选项。筛选评论以查看你未回复的内容，以及你回复的内容和用户随后更新其评论或评分的评论。回复评论很容易，在评论中只需点击**回复此评论**（**reply to this review**）。

有时候你会遇到违反[评论发布政策](https://play.google.com/about/comment-posting-policy.html)的评论，你可通过点击评论区域中的举报标志来举报这些评论。

![](https://cdn-images-1.medium.com/max/800/0*9rElhiblAG0KXrJ5.)

评论（Reviews）。

> **在**[**抢先体验**](https://developer.android.com/distribute/google-play/startups.html#be-part-of-early-access)**中使用测试反馈，西班牙游戏开发者** [**Omnidrone**](https://play.google.com/store/apps/developer?id=Omnidrone&hl=en) [**提高了 41％ 的保留率，50％ 的参与率和 20％ 的货币化**](https://www.youtube.com/watch?v=LzGC6V_YnlE&index=10&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c)。

有一个专门针对**测试反馈**（**beta feedback**）的部分。当你对应用进行公开测试时，测试人员提供的任何反馈都会在此处显示—它不会包含在你产品应用的评分和评论中，并且不会公开显示。这些功能类似于公众反馈：您可以过滤评论，回复评论以及查看与用户对话的历史记录。

> **更多关于用户反馈的资源：**
> - [浏览并回复应用评价以积极的与用户互动](https://developer.android.com/distribute/best-practices/engage/user-reviews.html)
> - [分析用户评论以了解关于你的应用的意见](https://developer.android.com/distribute/best-practices/grow/user-reviews.html)

* * *

### 全局 Play 控制台部分

到目前为止，我已经查看了可用于每个应用的 Play 控制台功能。完成之前，我想给你一个关于全局 Play 控制台功能的简要指南：游戏服务，订单管理，下载报告，警报和设置。

> [**Senri 实施 Play 游戏服务**](https://developer.android.com/stories/games/leos-fortune.html) **在 Leo’s Fortune（里奥的财富）及每一章的排行榜上存储游戏。Google Play 游戏服务用户在 1 天后返回的可能性增加 22％，在 2 天后增加 17％。**

**Google Play 游戏服务**提供一系列提供游戏功能以帮助推动玩家参与度的工具，例如：

*   **排行榜**（**Leaderboards**）—让玩家与朋友比较他们的分数并与顶级玩家竞争的地方。
*   **成就**（**Achievements**）—在游戏中设定目标，玩家获得经验值（XP）来完成。
*   **游戏的保存**（**Saved Games**）—存储游戏数据并跨设备进行同步，以便玩家可以轻松恢复游戏。
*   **多玩家**（**Multiplayer**）—通过实时和回合制的多人游戏来连结玩家们。

许多这些功能可以在不更改游戏代码的情况下进行更新和管理。

> **Eric Froemling 使用玩家分析在游戏**  [**Bombsquad**](https://play.google.com/store/apps/details?id=net.froemling.bombsquad) **上** [**平均每位用户收入提升了 140%，平均每位付费用户收入提升了 67%**](https://www.youtube.com/watch?v=3ks0IwqLNnI)

**玩家分析**（**Player analytics**）将有关游戏性能的宝贵信息集中在一个地方，并提供一组免费报告，帮助你管理游戏业务并了解游戏中的玩家行为。当你将 Google Play 游戏服务集成到您的游戏时，它就是标准配置。

![](https://cdn-images-1.medium.com/max/800/0*ihSQz7lO1yVCO4y3.)

玩家分析（作为 Google Play 游戏服务的一部分）。

您可以设置玩家花费的每日目标，然后监控**目标 vs 实际**（**target vs. actual**）**图表**中的表现，并定义如何将你的玩家花费与**业务驱动**（**business drivers**）报告中类似游戏的基准相比。您可以使用**保留**（**retention**）报告追踪新用户队列中的玩家保留情况，并通过**玩家进度**（**player progression**）报告查看玩家在哪里花费时间，竞争以及变动的情况。然后通过**资源和渠道**（**sources and sinks**）报告来检查和帮助管理你的游戏内经济，例如，你不会弃用玩家正在使用中的资源。

你还可以深入了解玩家行为的细节。使用**筛选器**（**funnels**）可根据任何顺序事件（如成就，花费和自定义事件）创建图表，或使用**群组**（**cohorts**）报告通过新用户群组比较任何事件的累积事件值。通过玩家**时间系列**资源管理器，了解玩家在关键时刻会发生什么情况，并根据你的自定义 Play 游戏事件与**事件查看器**（**events viewer**）创建报告。

> **更多关于 Google Play 游戏服务的资源：**
> - [使用 Google Play 游戏服务创建更具吸引力的游戏体验](https://developer.android.com/distribute/best-practices/engage/games-services.htmlhttps://developer.android.com/distribute/best-practices/engage/games-services.html)
> - [使用玩家分析来更好地了解玩家在游戏中的表现](https://developer.android.com/distribute/best-practices/engage/player-analytics.html)
> - [通过玩家分析并提供收入目标来管理您的游戏业务](https://developer.android.com/distribute/best-practices/earn/grow-game-revenue.html)
> - [针对游戏开发者的 Medium 文章](https://medium.com/googleplaydev/tagged/game-development)

**订单管理**（**Order management**）提供访问用户所有付款的详细信息。你的客户服务团队成员将使用此部分查找和退款或取消订阅。

![](https://cdn-images-1.medium.com/max/800/1*Gab41EMLdSrFdY-fLwMkew.png)

订单管理（Order management）。

**下载报告**（**Download reports**）会获取包括崩溃和应用程序无响应错误（ANR），评论和财务报告详细信息在内的数据。此外，还提供了用于安装，评分，崩溃，Firebase 云消息传递（FCM）和订阅的汇总数据。你可以通过工具使用这些下载报告来分析 Play 控制台捕获的数据。

**警报**（**Alerts**）涉及与崩溃，安装，评分，卸载和安全相关的问题。对于使用 Google Play 游戏服务的游戏，会出现游戏功能警报，可能是因为未正确使用游戏功能而被阻止，例如达到限制或过度的 API 调用等等。你可以在设置菜单的通知部分选择通过电子邮件接收提醒。

**设置**（**Settings**）提供各种选项来控制你的开发者帐户以及 Play 控制台的行为。

我想着重介绍**开发者帐户**（**developer account**）下的一个设置功能，**用户帐户和权限**（**user accounts & rights**）。你可以完全控制哪些人可以在控制台中访问你应用的功能和数据。你可以为每个团队成员提供对整个帐户的查看或编辑的访问权限，也可以为特定的部分提供访问权限。例如，你可以选择允许你的市场部门主管访问商品详情（store listing），评论和 AdWords 推广系列，但不能访问控制台的其他部分。访问权的另一个常见用途是使你的财务报告仅显示给那些需要查看它们的人。

你应该设置你的**开发者页面**（**developer page**），以便在用户点击你的开发者名称时在 store 中展示你的应用或游戏以及公司的品牌。你可以添加标题图片，徽标，简要说明，网站 URL 以及精选应用程序（你的应用程序的完整列表可自动显示）。

在**偏好设置**（**preferences**）中，你可以选择通过网络界面或电子邮件收到哪些 Play 控制台的通知，[注册新闻](http://g.co/play/monthlynews) 选择参与反馈并调查，告诉我们你的角色，并更改你的偏好，与我们分享你的控制台使用数据。

* * *

### 获取 Play 控制台应用程序

本文中的屏幕截图展示了浏览器中的 Play 控制台，但是你的 Android 设备也可以使用 Play 控制台应用。快速访问你应用的统计信息，评分，评论以及发布信息。获取重要更新的通知，例如你的最新版本已经上线，以及执行回复评论等快速操作。

[在 Google Play 上获取](https://play.google.com/store/apps/details?id=com.google.android.apps.playconsole&hl=en).

* * *

### 保持最新状态

有几种方法可以保持从 Google Play 获取最新最好的状态：

*   点击 Play 控制台右上角的 🔔 ，查看需了解的有关新功能和更改的通知。
*   [通过电子邮件注册获取新闻和提示](http://g.co/play/monthlynews) 包括我们的月刊。
*   [在 Medium 上关注我们](https://medium.com/googleplaydev)来自团队的长篇文章，包括最佳实践，商业策略，研究和行业思想。
*   [在 Twitter 上联系我们](https://twitter.com/googleplaydev)或者通过 [Linkedin](https://www.linkedin.com/showcase/googleplaydev/) 与我们开始对话。
*   获取[给开发者的 Playbook 应用](https://play.google.com/store/apps/details?id=com.google.android.apps.secrets&hl=en) 以管理推送（包括我们所有的博客及 Medium 中的推送）和 YouTube 视频从而帮助你在 Google Play 上成功发展业务，并选择接收通知的内容。

* * *

**关于 Play 控制台的问题或反馈？请与我们取得联系！**
在下方评论或者使用标签 **#AskPlayDev** 向我们发送推文，我们将通过 [@GooglePlayDev](http://twitter.com/googleplaydev) 进行回复，我们会定期分享有关如何在 Google Play 上取得成功的新闻和技巧。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
