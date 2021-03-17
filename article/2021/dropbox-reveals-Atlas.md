> * 原文地址：[Dropbox Reveals Atlas - a Managed Service Orchestration Platform](https://www.infoq.com/news/2021/03/dropbox-atlas/)
> * 原文作者：[Eran Stiller](https://www.infoq.com/profile/Eran-Stiller/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dropbox-reveals-Atlas.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dropbox-reveals-Atlas.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Dropbox 公布了 Atlas —— 一个托管服务编排平台

在最近的博客文章中，[Dropbox 公布了 Atlas](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform)，旨在提供给用户面向服务的体系结构的各种好处，同时让拥有服务的运营成本降至最低。

Atlas 的目标是支持小型的独立功能，为产品团队节省管理各种服务的开销，包括容量规划、警报设置等。Atlas 还借助后台自动调配的服务，为用户提供了与无服务器系统（如 AWS Fargate）搭配使用的体验。根据作者 Naphat Sanguansin 和 Utsav Shah 的说法，他们评估了使用现成的解决方案来运行该平台。但是，为了降低迁移风险并确保较低的工程成本，他们决定继续在 Dropbox 其余部分使用的同一编排平台上托管服务。

构造 Atlas 的原因是他们想要要替换 Dropbox 的 Python 中心库 [monolith](https://en.wikipedia.org/wiki/Monolith) Metaserver。构造 Altas 会是一个历时多年的历程，至今仍在进行之中。目前，Atlas 正在为它打算取代的 monolith 提供 25％ 以上的服务。作者给出了有关迁移过程的关键结论：

> 多年努力中我们发现最重要的一点是，在项目生命周期的早期，编写经过深思熟虑的代码是至关重要的。否则，技术负担和代码复杂性将很快融合一起来作怪。导入周期的拆除和 Metaserver（...）的分解可能是该项目在战略上最有效的部分，因为它可以防止新代码导致问题并简化我们的代码。

作者指出，由于代码库的大小和复杂性，以前许多改进 Metaserver 的努力都没有成功。这次，他们考虑[将其作为垫脚石，而不是里程碑](https://medium.com/@jamesacowling/stepping-stones-not-milestones-e6be0073563f)，为 Atlas 设计了执行计划。想法是，如果项目的下一部分由于任何原因失败，则每个增量步骤都将提供足够的价值。此策略的关键示例涉及对单片代码库进行改进，无论有没有 Atlas 实施，该改进都有其价值。此外，团队将为 Atlas 开发的许多增强功能回移植到 Metaserver 中，以进一步提高项目价值。

![https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-before-after-1615307468409.png](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-before-after-1615307468409.png)
<small>以前与以后，图源 [Dropbox](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform) </small>

Atlas 的设计涉及一些围绕组件化，编排和操作性的关键工作。Atlas 引入了 Atlasservlets（atlas servlets）作为 HTTP 路由的逻辑，原子分组，以改善组件化。作者说：“在为 Atlas 做准备时，我们与产品团队合作，将 Atlasservlet 分配给 Metaserver 中的每个路由，从而在 5000 多个路由中产生了 200 多个 Atlasservlet。” 每个 Servlet 均分配有一个所有者，该所有者是管理它的唯一权限。另外，要分解 Metaserver 代码库，他们必须打破我们的大多数 Python 导入周期。这个过程花了几年时间才能实现，。

为了改进编排，Atlas 中的每个 Servlet 都是其自己的集群。默认情况下，该决定会提供隔离，因为行为异常的路由只会影响同一 Atlasservlet 中的其他路由。同样，此决定允许独立推送代码。此外，Dropbox 决定在 [gRPC](https://grpc.io/) 上进行标准化。继续为 HTTP 流量，他们用 [GRPC JSON 的转码器](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/grpc_json_transcoder_filter)中提供了 [Envoy](https://www.envoyproxy.io/)，这是他们在 Servlet 的前面作为代理服务器和负载平衡器使用。

![HTTP 转码器](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-http-transcoding-1615307468739.png)

<small>HTTP 转码器，图源 [Dropbox](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform) </small>

根据作者的说法，关于可操作性，“Atlas 的秘密秘诀是可管理的经验”。这项工作的主要支柱是自动金丝雀分析，它可以在每个代码推入生产之前自动检查每个代码推入，以及自动缩放功能，从而消除了对容量规划的大部分需求。

![Canary 版本分析](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-canary-1615307469053.png)

<small>Canary 版本分析，图源 [Dropbox](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform) </small>

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
