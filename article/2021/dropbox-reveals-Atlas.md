> * 原文地址：[Dropbox Reveals Atlas - a Managed Service Orchestration Platform](https://www.infoq.com/news/2021/03/dropbox-atlas/)
> * 原文作者：[Eran Stiller](https://www.infoq.com/profile/Eran-Stiller/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dropbox-reveals-Atlas.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dropbox-reveals-Atlas.md)
> * 译者：
> * 校对者：

# Dropbox Reveals Atlas - a Managed Service Orchestration Platform

In a recent blog post, [Dropbox revealed Atlas](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform), a platform whose aim is to provide various benefits of a [Service Oriented Architecture](https://en.wikipedia.org/wiki/Service-oriented_architecture) while minimizing the operational cost of owning a service.

Atlas' goal is to support small, self-contained functionality, saving product teams the overhead of managing a full-blown service, including capacity planning, alert setup, etc. Atlas provides its users with an experience of serverless systems such as [AWS Fargate](https://aws.amazon.com/fargate/) while being backed by automatically provisioned services behind the scenes. According to the authors, Naphat Sanguansin and Utsav Shah, they evaluated using off-the-shelf solutions to run the platform. However, to de-risk their migration and ensure low engineering costs, they decided to continue hosting services on the same deployment orchestration platform used by the rest of Dropbox.

The reason for building Atlas was to replace Dropbox's central Python [monolith](https://en.wikipedia.org/wiki/Monolith) called Metaserver. Building Atlas is a multi-year journey, still taking place today. Currently, Atlas is serving more than 25% of the monolith traffic it aims to replace. The authors draw a key conclusion regarding the migration process:

> The single most important takeaway from this multi-year effort is that well-thought-out code composition, early in a project's lifetime, is essential. Otherwise, technical debt and code complexity compound very quickly. The dismantling of import cycles and the decomposition of Metaserver (...) was probably the most strategically effective part of the project because it prevented new code from contributing to the problem and made our code simpler to understand.

The authors state that many previous efforts to improve Metaserver had not succeeded due to the codebase's size and complexity. This time, they designed the execution plan for Atlas with [stepping stones, not milestones](https://medium.com/@jamesacowling/stepping-stones-not-milestones-e6be0073563f), in mind. The idea was that each incremental step would provide sufficient value if the next part of the project failed for any reason. Key examples of this strategy involve making improvements to the monolithic codebase that have value regardless of Atlas implementation. Also, the team backported many enhancements developed for Atlas back into Metaserver to increase the project value even further.

![https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-before-after-1615307468409.png](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-before-after-1615307468409.png)

**Before and after Atlas, Source: [https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform)**

The Atlas design involved a few critical efforts revolving around componentization, orchestration, and operationalization. Atlas introduces Atlasservlets (pronounced "atlas servlets") as a logical, atomic grouping of HTTP routes to improve componentization. The authors say that "In preparation for Atlas, we worked with product teams to assign Atlasservlets to every route in Metaserver, resulting in more than 200 Atlasservlets across more than 5000 routes." Each servlet is assigned an owner, and the owner is the only authority that manages it. Also, to break up the Metaserver codebase, they had to break most of our Python import cycles. The process took several years to achieve, and they prevented regressions and new import cycles through the use of the [Bazel](https://bazel.build/) build system and its [visibility rules](https://docs.bazel.build/versions/master/visibility.html).

To improve orchestration, each servlet in Atlas is its own cluster. This decision provides isolation by default, as a misbehaving route will only impact other routes in the same Atlasservlet. Also, this decision allows for independent pushes of code. Besides, Dropbox decided to standardize on [gRPC](https://grpc.io/). To continue to serve HTTP traffic, they used the [gRPC-JSON transcoding](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/grpc_json_transcoder_filter) feature provided out of the box in [Envoy](https://www.envoyproxy.io/), which they use as proxy and load balancer in front of the servlets.

![https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-http-transcoding-1615307468739.png](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-http-transcoding-1615307468739.png)

**HTTP transcoding, Source: [https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform)**

Regarding operationalization, according to the authors, "Atlas' secret sauce is the managed experience." This effort's main pillars are automated canary analysis that automatically checks each code push before it reaches production and an autoscaling capability that removes much of the need for capacity planning.

![https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-canary-1615307469053.png](https://res.infoq.com/news/2021/03/dropbox-atlas/en/resources/1Dropbox-atlas-canary-1615307469053.png)

**Canary analysis, Source: [https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
