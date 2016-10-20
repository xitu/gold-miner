> * 原文地址：[Bringing Pokémon GO to life on Google Cloud](https://cloudplatform.googleblog.com/2016/09/bringing-Pokemon-GO-to-life-on-Google-Cloud.html)
* 原文作者：[Luke Stone](https://cloudplatform.googleblog.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cdpath](https://github.com/cdpath)
* 校对者：[DeadLion (Jasper Zhong)](https://github.com/DeadLion), [yifili09 (Nicolas(Yifei) Li)](https://github.com/yifili09)

# 让 Pokémon GO 运行在谷歌云服务上
作者 Luke Stone，客户可靠性工程主管。

在我的工程师生涯中，我曾参与发布了多个产品，它们后来拥有了数百万用户。假以时日，随着在新功能和架构上的调整，用户采纳度通常会在数月内稳步提升。我曾参与过的任何产品的增长速度都无法和[谷歌云服务](https://cloud.google.com/)的客户 [Niantic](https://www.nianticlabs.com/) 所发布的 Pokémon GO 相提并论。

先放一张胜过千言万语的图表作为预告吧：

[![](https://3.bp.blogspot.com/-QNgvo5Ec03Q/V-2XAaD0GQI/AAAAAAAADJA/g2M6VTRGUiktueNG6gGFxBjSLXRQDeNZQCLcB/s640/google-cloud-pokemon-go-1.png)](https://3.bp.blogspot.com/-QNgvo5Ec03Q/V-2XAaD0GQI/AAAAAAAADJA/g2M6VTRGUiktueNG6gGFxBjSLXRQDeNZQCLcB/s1600/google-cloud-pokemon-go-1.png)

有同行在技术社区问过我们用什么基础架构来支撑数百万玩家使用 Pokémon GO。 Niantic 和谷歌云服务团队一起写了这篇文章来着重说明支撑着目前最流行的手机游戏的一些关键组件。

### 共同的命运

在今天的 [Horizon](https://atmosphere.withgoogle.com/live/horizon)  活动上，我们会介绍谷歌客户可靠性工程（CRE），一种谷歌技术人员和客户小组相结合的全新参与模式，双方分担责任帮助关键的云端应用实现高可靠性并获得成功。谷歌 CRE 的第一个客户就是 Niantic，其第一个任务就是发布 Pokémon GO，这是个真正的测试，如果真有的话。

在澳大利亚和新西兰首发的 15 分钟内，玩家流量的激增已经超出了 Niantic 的预期。这时 Niantic 的产品和工程团队才意识到他们手上的东西真的不一般。为应对第二天在美国区的发布，Niantic 打电话给谷歌 CRE 请求增援。Niantic 和谷歌云服务团队 —— 包括 CRE，SRE，开发，产品，技术支持和执行团队 —— 已经做好准备迎接蜂涌而至的新 Pokémon 训练师（游戏玩家）了，而 Pokémon GO 的玩家流量还会持续超出预期。

### 创造 Pokémon 游戏世界

Pokémon GO 这个手机应用使用了多个谷歌云服务，而[云存储](https://cloud.google.com/datastore/)成了这个游戏全面流行的直接原因，因为它是游戏的主要数据库，用来获得 Pokémon 游戏世界。这篇博客开篇的图表讲了这样一个故事：团队定下的目标是一倍的玩家流量，而最坏情况预计是这个目标的五倍。Pokémon GO 的流行迅速带来了超过预期目标五十倍的流量，十倍于预计的最坏情况。为了应对这一情况，谷歌 CRE 为 Niantic 无缝地提供了额外的处理能力，成功应对了破纪录的流量增长。

不是所有东西在发布时都是一帆风顺的！当游戏的稳定性出现问题时，Niantic 和谷歌工程师们勇敢的面对一个又一个的问题，动作迅速地解决问题。谷歌 CRE 和 Niantic 携手审查了架构的每一部分，充分利用谷歌云服务团队的核心工程师和产品经理的专业知识，共同应对涌入的数以百万的新玩家。

### 容器支撑的 Pokémon

Pokémon GO 不只是一个全球性现象，它还是基于容器的开发形式在实际开发中的最令人激动的生动例子之一。游戏的应用逻辑运行在[谷歌容器引擎 (GKE)](https://cloud.google.com/container-engine/)上，它是基于开源的 [Kubernetes project](http://kubernetes.io/) 开发的。Niantic 选择 GKE 是因为能够极大规模地编排容器集群，小组可以集中精力为玩家部署实时更新。通过这种方式，Niantic 利用谷歌云服务将 Pokémon GO 变成了服务数百万玩家的服务，可以持续调整并改进。

Niantic 和谷歌 CRE 小组完成的另一个更激进的技术是升级到新版的 GKE，从而在容器集群中多加一千个节点。这都是为了应对游戏在日本区众所期待的发布。如同给飞行的飞机换发动机一样，需要采取谨慎的操作来保证已有玩家不受影响，切换的新版 GKE 的同时还有数百万的新玩家注册并加入 Pokémon 游戏世界。除了这次升级之外，Niantic 和谷歌工程师们还同心协力将[网络负载均衡](https://cloud.google.com/compute/docs/load-balancing/network/)替换为更新更复杂的 HTTP/S 负载均衡。[HTTP/S 负载均衡](https://cloud.google.com/load-balancing/)是专为 HTTPS 流量设计的全球系统，提供了更多的控制能力，更快的用户连接以及整体更高的吞吐量，更适合 Pokémon GO 所经历的流量的量级和类型。

从美国区发布吸取的教训 —— 提供海量处理能力，架构调整到最新的容器引擎，以及升级到 HTTP/S 负载均衡 —— 都在日本区发布时收到了回报，没有发生故障的同时新增玩家达到了两周前美国区发布时的三倍。







[![](https://3.bp.blogspot.com/-Eo29IdLeofM/V-ysvX6aqXI/AAAAAAAADIc/b1Kf1YUDk2UbiheUIKElXjTypd5MBqpGACLcB/s640/google-cloud-cre.png)](https://3.bp.blogspot.com/-Eo29IdLeofM/V-ysvX6aqXI/AAAAAAAADIc/b1Kf1YUDk2UbiheUIKElXjTypd5MBqpGACLcB/s1600/google-cloud-cre.png)





谷歌云服务 GKE/Kubernetes 团队为包括 Niantic 在内的多个客户提供支持







其他有趣的事实

*   Pokémon GO 游戏世界使用了超过 12 个 Google Cloud 服务。
*   Pokémon GO 是有史以来 [Google Container Engine](https://cloud.google.com/container-engine/) 上最大的 [Kubernetes](http://kubernetes.io/)。得益于集群的规模和相应的吞吐量，大量的 bug 被发现、修正最后合并回[开源项目](https://github.com/kubernetes/kubernetes)。
*   为支持 Pokémon GO 的海量玩家数据库，谷歌为 Niantic 的容器引擎集群提供了成千上万的 CPU 核心。
*   [谷歌的全球网络](https://peering.google.com/#/infrastructure)帮助减少 Pokémon 训练师（游戏玩家）在游戏世界中总体的延迟。游戏流量通过谷歌专用光纤网络走过大多数中转，为全球玩家提供可靠、低延迟的体验。[甚至在海下](https://cloudplatform.googleblog.com/2016/06/Google-Cloud-customers-run-at-the-speed-of-light-with-new-FASTER-undersea-pipe.html)!

Niantic 的 Pokémon GO 是一次齐心协力地发布，需要在超过六个小组间迅速、高效地传递决策。游戏的规模和目标要求 Niantic 直接从设计了低层产品的工程团队中挖掘架构和运营的最佳实践。我在这里代表谷歌 CRE 团队表示能够参与到如此令人难忘的产品发布已是难得的乐趣，更何况游戏已为世界各地的人们带来乐趣。
