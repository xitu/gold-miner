> * 原文地址：[Building a Virtual World Worthy of Sci-Fi: Designing a global metaverse](https://medium.com/google-developers/building-a-virtual-world-worthy-of-sci-fi-3d48e2fd05e3)
> * 原文作者：[Reto Meier](https://medium.com/@retomeier?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-a-virtual-world-worthy-of-sci-fi.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-a-virtual-world-worthy-of-sci-fi.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：[IllllllIIl](https://github.com/IllllllIIl)、[Wangalan30](https://github.com/Wangalan30)

# 建立一个像科幻小说一样的虚拟世界：设计一个全球性的虚拟世界

在 Build Out 系列的第二集里面，[Colt McAnlis](https://medium.com/@duhroach) 和 [Reto Meier](https://medium.com/@retomeier) 接受了设计一个全球虚拟世界的挑战。

看一看下面的视频，看看他们想出了什么，然后继续阅读本文，看看你如何从他们的探索中学习建立你自己的解决方案！

<iframe width="700" height="393" src="https://www.youtube.com/embed/H9FbNi5aYYM?list=PLOU2XLYxmsILr0RmtqFITcoXnfOrWtytp" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 视频梗概：他们设计了什么

两种解决方案都描述了一种能够生成让用户通过 VR 头盔就可以体验的 3D 环境的设计，使用不同级别的云计算和云存储来给客户端提供虚拟地球的数据，并且实时计算用户与之交互时对世界环境的改变。

**Reto 的方案**专注于使用数百万个无人机获取实时传感器数据，创建一个对现实世界的虚拟克隆。他的虚拟空间本质上是和现实世界联系在一起的，包括几何形状和当前的天气条件。

![](https://cdn-images-1.medium.com/max/1000/1*61k82U4FxUM9lOfd34stlg.png)

**Colt 的方案**充分利用了他的游戏开发经验，设计了一个完全隔离虚拟世界和物理世界的系统。他的架构详细描述了创建一个 MMO (或者其他大型合作空间)后端服务所需要的框架。

![](https://cdn-images-1.medium.com/max/1000/1*Es5nrGnQu3jQYirGuq8aPw.png)

### 创建你自己的全球虚拟世界

这些设计里面最大的区别在于虚拟环境的气候和几何信息的来源。Reto 的设计方案依赖于分析现实世界中的传感器数据，而 Colt 的系统使用艺术家来提供人造景观和建筑物。

如果你想要一个包含真实世界几何图形和纹理的系统，你可以从 Google Map 上面找点灵感。

他们的系统使用图像和传感器数据的组合来生成 3D 模型以及这些模型的纹理信息。这使得他们能够生成非常真实的城市环境三维再现，而不需要雇佣一大群艺术家来重新创建相同的内容。

让我们来生成一个十分相似的具有代表性的东西来反映这个过程。我们可以使用卫星数据，LIDAR（激光雷达）输入，还有来自各个角度和来源的无人机图片，并把他们放到一个 GCS bucket 里面。

另外，我们还要生成工作信息并将 work token 推送到 pub/sub。我们有一批抢占式虚拟机，负责收集这些 pub/sub 请求，并开始制作 3D 网格和纹理图集。最终的结果也被推送到 GCS bucket 里面。

![](https://cdn-images-1.medium.com/max/800/1*2awv-uWabgiVAepGrpUdzA.png)

> **为什么要用抢占式虚拟机（PVM）？** PVM 允许自己被计算引擎管理器终止。因此，与同样配置的标准虚拟机相比，它们提供了非常便宜的折扣价。由于它们的寿命是不稳定的，因此它们非常适用于执行可能会中断而无法完成的批量工作。

Pub/sub 在这方面与 PVMs 携手合作。一旦 PVM 收到一个终止信号，它可以停止工作，并将工作负载推回到 pub/sub，以便另一个 PVM 稍后拾取继续工作。

或者，对于这种算法失效的区域，你可以允许用户为图标式地标提交自定义模型和纹理，然后将其插入到生成的 3D 环境中。

![](https://cdn-images-1.medium.com/max/800/1*8ngyDPNUw6GqNRdxWnvJrA.png)

### 存储和分发虚拟世界数据

当我们所有的网格和纹理数据都处理完毕的时候，结果将是数以 TB 的虚拟环境数据。很明显，我们不能一次将所有内容都传输给每个客户，相反，我们会根据地理边界打包模型数据。

这些 『区域性 blob』 被编入索引，包含元数据，并且可以存储在多层压缩存档中，以便它们可以流式传输到客户端。

要计算这一点，需要使用与生成 3D 网格相同的离线构建过程；具体来说，你可以为 pub/sub 生成一堆任务，并使用一群抢占式虚拟机来计算和合并适当的区域 blob。

![](https://cdn-images-1.medium.com/max/800/1*CEkaLsDQMXbQVvygHYrhGw.png)

将区域档案分发给客户取决于用户在虚拟世界中的『实际』位置，以及他们面对的方向。

![](https://cdn-images-1.medium.com/max/800/1*Jz_zqlU5Ca0MGIIGGjUMlg.png)

为了优化客户端的加载时间，给他们经常访问的区域添加本地缓存是非常有意义的，以此来帮助他们避免每次进入一块新的区域都需要下载大量数据的情况。

![](https://cdn-images-1.medium.com/max/800/1*6b2I4tUiPyn3pVSw7aPwfg.png)

为了图表清晰起见，我们可以将整个过程封装起来作为一个离线系统，我们称它为『自动内容生成器（ACG）』。

随着时间的推移，本地缓存将会失效，或者需要将更新推送给用户。为此，我们制定了更新和分期流程，客户可以在登录或是重新进入他们最近访问的区域时接收更新的环境数据。

![](https://cdn-images-1.medium.com/max/800/1*lCgVkyWLf2gSqfZE2Wlhww.png)

> **为什么用 GCF？** 有很多种方法可以让客户端检查更新。例如，我们可以创建一个负载均衡器来自动扩展一组 GCE 实例。或者我们可以制作一个可以根据需求进行扩展的 Kubernetes pod。

> 或者我们可以使用 app engine flex，它允许我们提供我们自己的图像，只是图片大小相同。或者我们可以使用 app engine 标准，它有自己的部署和扩展。

> 我们之所以选择 Cloud Functions 的原因是：首先，GCF 增强了对 Firebase 推送通知的支持。如果发生了什么情况，我们需要通知客户有紧急修复补丁，我们可以直接将这些数据推送给客户。

> 其次，GCF 需要最少的工作来部署功能。我们不需要花费额外的周期来配置图像，平衡或部署细节；我们只需编写我们的代码，并将其推出确保可以使用。

### 为你的虚拟世界提供模拟数据

随着你的用户移动并且和虚拟环境交互，他们所导致的任何改变都需要和其他的周边数据同步，并分享给其他用户。

你需要一些复合组件来确保用户操作不违反任何物理规则，然后是一个用于存储或向其他用户广播这些信息的系统。

为此，你可以利用一组名为 『World Shards』 的 App Engine Flex 组件，它们允许地理上比较接近的客户端连接并交换位置和移动信息数据。因此，当用户进入游戏区域时，我们会计算出他们最近的区域，并将它们直接连接到适当的 World Shards。

> **为什么用 App Engine Flex？**对于 World Shards 而言，我们可以轻松使用一组共享一个图像的实例化的 GCE 虚拟机来实现，但是 app engine flex 为我们提供了相同的功能，且不需要额外的维护开销。同样的，一个 GKE Kubernetes 集群也可以做到这一点，但对于我们的应用场景，我们并不需要 GKE 提供的一些高级功能。

我们还需要一组独立的计算单元来帮助我们管理所有二级世界互动项目。诸如购买商品，玩家间通信等等。为此，你可以启动第二组 App Engine Flex 实例。

所有需要分发到多个其他客户端的持久性数据将存储在云端 Spanner 中，这将使得区域比较靠近的用户在有需要时能够尽快共享信息。

![](https://cdn-images-1.medium.com/max/800/1*KQnoHJeVWVQbJJr8ELQKcQ.png)

> **为什么用 Spanner？**我们之所以选择 spanner 是因为它的托管服务，全球容量以及扩展能力来处理非常高的事务性工作负载。你也可以用 SQL 系统来做到这一点，但是这样的话，你就得为获得相同的效果做很多繁重的工作。

由于我们的代码需要经常改动，我们需要增加我们的更新和临时服务器以将代码分发到我们的 world-shards。为了实现这一点，我们允许在暂存代码中执行计算级分段，并将图像推送到 Google Container Registry，以便根据需要支持各种 world shards 和游戏服务器。

![](https://cdn-images-1.medium.com/max/800/1*V0jjfEVbgTpBA1T91L1W1A.png)

### 绘制你的虚拟世界

除非您戴上 VR 头盔，否则虚拟世界就不是一个有意义的虚拟世界。为此，你可以利用 Google VR 和 Android Daydream 平台在完全身临其境的 VR 体验中呈现我们巨大的虚拟世界。然而，Daydream 本身并不是一个合适的渲染引擎，因此你需要利用像 UNITY 这样的工具来帮我们绘制所有模型，并代表我们与 Daydream 系统进行交互。

![](https://cdn-images-1.medium.com/max/800/1*cMAXUcr7QcZXdnFnOm38WA.png)

描述如何在 VR 模式下每帧正确渲染数百万个多边形是一个很大的挑战，但这已经不在本文的讨论范围之内了;）

### 帐户和身份认证服务

我们将添加一个 app engine 前端实例，利用 Cloud IAM 对用户进行身份验证和识别，并与帐户管理数据库通信，这个数据库可能包含帐单和联系人数据等敏感信息。

![](https://cdn-images-1.medium.com/max/800/1*_XrckPhaLAUKQbfkJAV48g.png)

> **为什么用 App Engine 标准？** 我们选择 app engine 标准作为 IAM 系统的前端服务的原因有很多。

> 首先是它的管理，这样我们就不必像 containers、GKE、App Engine Flex 那样处理配置和部署的细节了。

> 其次，它内置了 IAM 规则和配置，因此我们可以用更少的代码来获得我们所需的安全保证和登录系统。

> 第三，它直接包含了对数据存储的支持，我们用它来存储我们所有的 IAM 数据。

* * *

想要了解我们技术选型的更多详细描述，可以在 [Google Play Music](https://play.google.com/music/listen#/ps/Imvre4gs5o4fv2aqknxopy6cb7q)，iTunes，或者[你最喜爱的播客应用或网站](http://feeds.feedburner.com/BuildOutRewound)上关注我们的系列播客，Build Out Rewound。

如果你对我们的系统设计或者技术选型有任何问题，请在下面留言，或者在我们的 YouTube 视频下面留言。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
