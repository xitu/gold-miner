> * 原文地址：[Engineering to Improve Marketing Effectiveness (Part 2) — Scaling Ad Creation and Management](https://medium.com/netflix-techblog/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2-7dd933974f5e)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[kuangbao9](https://github.com/kuangbao9)

# 提高营销效率的工程（二）—— 广告制作和管理的规模化

[Ravi Srinivas Ranganathan](https://www.linkedin.com/in/rravisrinivas)，[Gopal Krishnan](https://www.linkedin.com/in/gopal-krishnan-9057a7/) 编写

> 在本系列的[第一篇](https://medium.com/netflix-techblog/engineering-to-improve-marketing-effectiveness-part-1-a6dd5d02bab7)博客中，我们描述了如何将市场营销的理念，动机和方法融入广告技术。此外，我们还制定了解决创意开发和本地化问题的业务。

> 在第二部分中，我们描述了 在 Netflix 中通过广告组装和个性化来推广广告的过程。

### 问题的表象

我们的世界级营销团队的独特任务是为我们展示不断增长的原创电影和电视节目，以及每一部电影和电视剧背后的独特故事。他们的工作不仅仅是提高我们制作的内容的认知度，更困难的是 —— 为合格的非会员(收购营销)和会员量身定制合适的内容，这是我们的在线广告所涉及的数十亿用户。这些广告必须在各种网站和发布商、Facebook、YouTube 和其他广告平台上送达至互联网用户。

想象一下，如果你要为下一部大片电影或必须看的电视节目发起数字营销活动。你需要为各种创意概念、A/B 测试、广告格式和本地化创建广告，然后为技术和内容错误创建 QC（质量控制）。在考虑到这些变化后，你需要将它们传输到这些广告将要投放的对应平台上。现在，想象一下，每天发布多重标题，同时仍然确保这些广告中的每一个都能传达给它们想要与之交谈的人。最后，你需要在广告发布后继续管理你的广告组合，来确保他们是最新的（比如，音乐授权和权限到期），并继续支持推出后的各个阶段。

问题可以分为三类：

*  **Ad Assembly**: 一种可扩展的广告制作和构建自动化工作流的方法
*  **Creative QC**: 一组可以轻松地对成千上万的广告单元的功能和语义正确性进行质量控制的工具和服务。
*  **Ad Catalog Management**: 基于 ML 的自动化管理使管理规模性广告活动成为可能

### 什么是 Ad Assembly？

总之，如果你从纯粹的分析角度来看待这个问题，我们需要找到一种方法来有效地自动化和管理内容组合所产生的指数级规模增长。

**广告基数总数 ≈**

_Titles in Catalog_ **x** _Ad Platforms_ **x** _Concepts_ **x** _Formats_ **x** _A/B Tests_ **x** _Localizations_

我们处理组合学的方法是从源头捕获它，然后创建我们的广告业务（我们产品的主要用户）可用最少信息来简洁地表达各种变化的营销平台。

![](https://cdn-images-1.medium.com/max/800/1*TWbovfnsSqMJG66KYDQp6w.gif)

**基于视频的社会广告创意变体**

考虑以下广告，这些广告在高亮显示的多个不同维度上有所不同。

![](https://cdn-images-1.medium.com/max/800/0*NQ9dYbl6USSMRXhc)

**CREATIVE VARIATIONS IN DISPLAY ADS**

如果你只是简单地改变这则广告在所有市场的独特本地化，那么就会导致产生 30 种变体。在创建静态广告的世界中，这意味着将通过营销生成 30 个唯一的广告文件，然后进行投放。除了更努力外，任何需要处理所有单元的变化都必须分别引入份单元中，然后再重新进行 QC-ed。哪怕是对一个创意表达的小小修改，比如资产的改变，也会涉及到在广告单元中进行修改。然后，每个变体都需要涉及 QC 和素材更新/重放广告投放的剩余流程。

我们对于上述内容的解决方案是构建动态广告创建和配置平台 —— 我们的广告制作合作伙伴构建单个 **_dynamic_** 单元，然后使用相关的数据配置来修改广告单元的行为。其次，通过提供工具，营销人员只需要表达变化并自动继承不变的内容，就可以显著减少需要定义和管理的数据的表面积。

如果你查看下面的本地化版本就会发现，它们会重用相同的基本构建块，但只会基于配置来表达不同的创意。

![](https://cdn-images-1.medium.com/max/600/0*DqNQBG1sW7cEvPYf)

**简单的本地化配置**

这样就可以在几分钟内从 1 => 30 地逐个进行本地化，而不是每个广告单元都花费几个小时甚至是几天时间！

我们还可以通过与许多有用的服务构建集成来加快广告组装的过程，从而使这个过程更加无缝。比如，我们有支持成熟度评级、转码和压缩视频资产或从我们的产品目录中提取图稿等集成功能。总而言之，这些便利性极大地降低了运行具有极大覆盖范围的活动所需的时间。

### 素材 QC

质量控制的一个主要方面是确保广告正确渲染并没有任何技术或视觉错误的 —— 我们称之为“功能性 QC”。鉴于不同广告类型之间存在广泛差异以及可能出现的问题，下面是我们追求改进素材质量控制状态而采取的一些顶级方法。

首先，我们有一些工具可以在整个广告组装过程中插入合理的值，并减少出错的可能性。

然后，通过在整个装配过程中增加验证和正确性检查，使 QC 问题的总量最小化。比如，当超过 Facebook 视频广告的字符限制时，我们就会给出警告。

![](https://cdn-images-1.medium.com/max/800/0*e-_QuY5UR1T24BMR)

**广告装配期间的警告**

其次，我们运行自动测试套件，帮助识别广告单元中是否存在任何可能对功能产生负面影响或对用户体验产生负面影响的技术问题。

![](https://cdn-images-1.medium.com/max/800/0*htbGIBapUv-gh_S1)

**来自一个显示广告的样本自动扫描**

最近，我们开始利用机器视觉来处理一些 QC 任务。比如，根据广告的投放位置，可能需要添加特定的评级图像。为了验证在视频创建过程中应用了正确的评级图像，我们现在使用由我们的云媒体系统团队开发的图像检测算法。随着以 AV 为中心的广告素材的数量不断扩大以及时间的推移，我们将在整体工作流中添加更多这样的解决方案。

![](https://cdn-images-1.medium.com/max/600/0*OF25W7mXzgtEoFj5)

**采用计算机视觉的抽样来评定图像 QC-ED**

除了功能的正确性，我们还非常关心语义化 QC —— 即，让我们的营销用户确定广告是否符合他们的创意目标，并准确地代表了内容和 Netflix 品牌的音调和声音。

构建我们广告平台的核心原则之一是立即更新实时渲染功能。这再加上我们的用户可以很容易地识别和做出具有广泛影响的精确的更新，使他们能够尽快解决问题。我们的用户还能够根据需要进行创造性的反馈，通过共享 **_tearsheets_** 来进行更有效地评论。Tearsheet 是在最后的广告被锁定时的预览，用来在发射前获得最终的许可。

鉴于这一过程对我们的广告活动的整体健康和成功的重要性，我们正大力投资 QC 自动化基础设施。我们还积极致力于支持复杂度的任务管理，状态跟踪和通知工作流，帮助我们以可持续的方式扩展到更高的数量级。

### 广告目录管理

广告准备好后，我们会用一个“目录”层将广告制作、组装和广告投放分离开来，而不是直接投放广告。

目录根据广告活动的意图选择要运行的广告集，这是为了建立标题意识还是用于收购营销？我们是在为一部电影或节目做宣传活动，还是它突显多个标题，还是一项以品牌为中心的资产？这是发布前的广告系列还是发布后的广告系列？

一旦指定了用户定义：自动目录就会处理以下内容：

*  使用聚合的第一方数据和机器学习模型，用户配置，广告性能数据等，来管理它所提供的广告素材。
*  自动请求制作所需但尚未提供的广告
*  对不断变化的资产可用性、推荐数据、黑名单等作出响应。
*  简化用户工作流 —— 管理活动的启动前和启动后阶段，调度内容刷新等。
*  收集指标并跟踪资产的使用情况和效率

因此，目录是一个非常强大的工具，因为它完成了对自己的优化，因此它支持 —— 实际上，它把我们的第一部分数据变成了一个“情报层”。

### 个性化和 A/B 测试

所有这些都可以加到大于其部分 - 的总和中。使用这一技术，我们现在可以运行 **_Global Scale Vehicle_** —— 一个由内容性能数据和广告性能数据驱动的始终支持常绿/常青状态的自动化优化广告系列。自动预算分配算法（我们将在本系列的下一篇博客中讨论它），这非常有效地调整了操作复杂度。因此，我们的营销用户可以专注于构建精彩的广告素材，并制定 A/B 测试和市场技术，我们的自动化目录有助于将创意传达到与之对应的地方 ——  自动化广告选择和个性化。

为了理解为什么这是一个游戏改变者，让我们回顾一下之前的方法 —— 每个需要发布的标题都必须涉及预算、目标定位，是否支持任意标题，运行时长，消费水平等。

面对我们不断增加的内容库，对于世界上几乎所有国家的营销广度和细微差别以及需要支持的平台和格式的数量，这是一项极其艰巨的任务。其次，对创造性表现的意外变化做出足够快的反应是很有挑战性的，同时也要把重点放在即将到来的广告和发布会上。

![](https://cdn-images-1.medium.com/max/800/1*TuPBPYY83i85z6vYN7lTsQ.png)

实际上，Netflix 的做法是，我们通过一系列 A/B 测试获得这个模型 —— 起初，我们运行了几个测试，了解到一个带有个性化交互的始终在线的广告目录的性能优于我们先前的 tentpole 发布方法。我们之后进行了跟进，来确定它在不同平台是如何表现优异的。正如人们所想的那样，这基本上是一个持续学习的过程，当我们继续在世界各地进行越来越多的营销 A/B 测试时，我们惊喜地发现我们的优化指标有了巨大的、连续的改进。

### 服务架构

我们使用一些基于 Java 和 Groovy 的微服务来启用这项技术，这些服务可以访问各种 NoSQL 存储，比如 Cassandra 和 Elasticsearch，通过使用 Kafka 和 Hermes 传输数据和触发导致在 [Titus](https://medium.com/netflix-techblog/titus-the-netflix-container-management-platform-is-now-open-source-f868c9fb5436) 进行调用的 [dockerized 微服务应用程序](https://medium.com/netflix-techblog/the-evolution-of-container-usage-at-netflix-3abfc096781b)事件来粘合不同部分。

![](https://cdn-images-1.medium.com/max/800/1*6_BrSaP_JSBsJPZP0RPGzA.png)

![](https://cdn-images-1.medium.com/max/600/1*H6bB68gFOfg3mjQ672j5xQ.png)

我们广告服务器中大量使用 [RxJava](https://github.com/ReactiveX/RxJava) 来处理实时服务展示和 VAST 视频请求，使用 RXNetty 作为它的应用程序框架，因为它的特性和性能低开销便于我们的定制化。我们使用 Tomcat / Jersey / Guice 作为广告的中间件服务器，因为它提供了更多的特性，且易于集成，比如简单的验证和授权。因为我们缺少严格的延迟和吞吐量限制，所以可以在 Netflix 的云生态系统中进行即插即用。

### 展望未来

尽管过去的这些年中，我们利用机会创建了大量的技术，但现实是，我们所需要完成的工作仍有很多。、

我们已经在一些广告平台上取得了巨大的进步，在有些平台上却才刚起步，而还有一些平台，我们还未纳入考虑范围。在有些平台中，我们已经完成了广告创作，组装和管理以及 QC 等流程，而在其他平台中，我们甚至还未触及广告中简单的组装内容。

自动化和机器学习已经让我们走得足够远了 — 但我们的团队对于如何做得更多以及做的更好的兴趣远超于构建这些系统的速度。因为我们面临着许多有趣的挑战，所以每次在广告流程的各个方面使用数据进行流量分析和预测时，每个 A/B 测试都会让我们相处更多的探索方向。

### Closing

总之，我们已经讨论了如何构建独特的广告技术来帮助我们在广告工作中增加规模和智能。其中一些细节本身就值得后续的文章，我们将在未来发布它们。

为了进一步推进我们的营销技术之旅，我们很快就会有下一个博客，它将故事推进到我们如何支持来自各种平台的营销分析，并使不可能的事情成为可能，以及用它来优化营销支出。

如果你对加入我们有兴趣，想要参与 Netflix 的营销团队的机会，可以关注我们现在的[**招聘**](https://sites.google.com/netflix.com/adtechjobs/ad-tech-engineering)**！** :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
