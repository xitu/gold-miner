> * 原文地址：[Deploy != Release (Part 2)](https://blog.turbinelabs.io/deploy-not-equal-release-part-two-acbfe402a91c)
> * 原文作者：[Art Gillespie](https://blog.turbinelabs.io/@artgillespie?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[jasonxia23](https://github.com/jasonxia23)

# 部署!=发布（第二部分）

## 将部署和发布解耦以降低风险，并解锁功能强大的工作流

在[这系列的第一部分](https://medium.com/turbine-labs/deploy-not-equal-release-part-one-4724bc1e726b)，我解释了我们在 [Turbine Labs](https://turbinelabs.io) 上用于上线、部署、发布和回滚的定义。我解释了**部署风险**和**发布风险**之间的差异。而且我还谈到了本地发布 —— 一种常用的用于将生产请求暴露给部署风险的部署/发布策略。本文中，我将讨论解耦部署风险与发布风险的方法，并简介用于管理发布风险的工作流。

### 蓝/绿（或部署!=发布）

[蓝/绿部署](https://martinfowler.com/bliki/BlueGreenDeployment.html)涉及到在生产中发布版本的同时部署服务的新版本。你可以为每种“颜色”使用专用硬件或虚拟机，并在它们之间交替进行后续部署，也可以使用容器或像 Kubernetes 这样的编排框架来管理临时进程。无论如何，关键在于一旦部署了新的（绿色）版本，它就不会被发布 —— 也不会响应生产请求。这些服务仍由目前已知的（蓝色）版本处理。

蓝/绿设置中的发布通常涉及更改负载均衡器，以添加新版本的主机并删除已知运行良好版本的主机。虽然这种方法比本地发布要好得多，但它也存在一定的局限性，特别是与发布风险有关的问题。首先，我们来看看你现在可以做的一些非常强大的事情 —— 部署和发布是两个单独的步骤。

#### 什么也没有

如果你的部署在崩溃循环回退中挂起，或数据库密钥错误并且新部署的服务无法连接，那么你不会承受**做任何事情**的压力。你的团队可以在没有愤怒用户或执行主管的压力情况下诊断问题或构建新版本，然后进行部署。在你空闲时重复操作，直到你有一个良好的部署。与此同时，已知发布的版本继续愉快地处理生产请求，并且你不必共享公司博客上残缺部署的报告。换句话说，**你的部署风险被完全包含**。

#### 健康检查和集成测试

当部署与发布被拆分时，你可以在将任何流量暴露给它之前，针对新部署的版本运行自动化健康检查和集成测试。我参加了许多事后分析，其中最重要的一点是，事后部署/预发布健康检查等简单的事情可以有效防止发生面向客户的事件。

![](https://cdn-images-1.medium.com/max/800/1*YcCeIx4-FrWMS63ZaVqSRQ.png)

健康检查和测试蓝/绿部署。如果 v1.2 出现问题，客户不会被暴露在其中。

#### 更细粒度的发布风险暴露

由于在引入新的“绿色”主机时，你不一定需要替换现有的“蓝色”主机，所以你有**一些**可以控制暴露新版本生成流量的百分比。比如。如果你有三台运行已知良好的服务版本，则可以在负载均衡器中为混合主机添加一台“绿色”主机。现在只有 25% 的流量暴露新版本，而不是已暴露的 33% 的主机。这仍然是粗粒度的发布风险管理，但总比没有好。

![](https://cdn-images-1.medium.com/max/800/1*7D-TdjRuzt9wGX1dcMnitg.png)

当你使一个“绿色”主机可用时，暴露该版本中任何错误流量的百分比则取决于主机的总数。这里是 33%。

### 持续性发布

正如我以上的讨论，从**部署风险**角度看，蓝/绿部署赢了。但当我们考虑**发布风险**时，典型的蓝/绿设置处理版本的方式并不能为我们提供我们正在寻找的细粒度控制。如果我们同意[生产中的每个发布都是测试](https://medium.com/turbine-labs/every-release-is-a-production-test-b31d80f2bc74)（不管同意与否，它一直如此），而我们**真正**想要的是使用模式匹配规则来分割我们的生产请求，并动态路由任意百分比的流量到我们服务的任何版本。这是一个强大的概念，它是构成复杂发布工作流的基础，如内部测试、增量发布、回滚和黑暗流量。每篇文章都分为上下两部分（即将推出！），但我在这里会尽可能地总结它们。

**内部测试**是仅向员工发布新版本服务的流行技术。通过强大的发布服务，你可以编写诸如“将内部员工流量的 50% 发送到版本为 x.x 实例”的规则。在我的职业生涯中，生产中的内部测试捕获到了了比我不愿意承认的更多令人尴尬的错误。

**增量发布**是一个过程，从发送到新版本服务的一些小百分比生成请求开始，同时监视这些请求的性能 —— 错误、延迟、成功率等 —— 与之前的产品版本相比而言。当你确信新版本不会出现任何与已知良好版本相关的意外行为时，你可以增加百分比并重复此过程，直至到达 100%。

**回滚**使用持续性发布系统，只是将生产中的请求路由转发到仍然运行最后一个已知良好版本的实例。它速度快、风险低，并且像发布本身一样，可以通过细粒度方式有针对地完成。

**黑暗流量**是一种功能强大的技术。你发布的系统会复制生产请求，并将一个副本发送到你的服务已知的良好“轻量级”版本，另一个发送到新的“重量级”版本。“轻量级”版本负责实际响应用户请求。“重量级”版本处理请求，但其响应会被忽略。当您需要在生产负载下测试新软件时，这非常有效。

在 Turbine Labs 中，我们使用自己的产品 [Houston](https://turbinelabs.io) 来完成内部测试，增量发布、回滚，并很快进行黑暗流量。对我来说，像 Houston 这样复杂的发布系统对我的日常工作来说是一种革命性改变。如此轻量级、低风险的发布，使得我可以**经常**这样做。作为一个团队，我们将在以后的文章中更详细地介绍我们在 [Turbine Labs](https://turbinelabs.io) 的内部发布流程。

### 结论

在过去的五年中，上线软件的大部分技术和流程进展 —— 按需云计算、容器、编排框架、持续交付等 —— 都集中在部署原语上。有了这些进步，为你的服务设计和实现一个健壮的**部署**流程变得轻而易举，但设计和实现一个可以支持你服务需求的可靠性**发布**流程仍然十分困难。Facebook、Twitter 和 Google 致力于设计、实现和持续维护像 Gatekeeper、TFE 和 GFE 这样成熟的发布系统。这些系统不仅在服务可靠性方面多次证明了它们的价值，还包括开发者生产、产品速度和用户体验方面。

> 复杂的发布系统不仅可以降低部署风险，还可以直接提高产品速度和用户体验。

我们开始关注为各种规模的公司提供的便利的产品（[Houston](https://turbinelabs.io)、[LaunchDarkly](https://launchdarkly.com/)）和开源工具（[Envoy](https://lyft.github.io/envoy/)、[Linkerd](https://linkerd.io/)、[Traefik](https://traefik.io/)、[Istio](https://istio.io)），以及最近才向大型公司提供的原语和工作流。这些产品和工具使得人们可以更快速地发布功能，并且使我们有信心不会对用户体验产生负面影响。

我是 [Turbine Labs](https://turbinelabs.io/) 的一名工程师，我们正在构建 [Houston](https://docs.turbinelabs.io/reference/#introduction) —— 一项使构建和监控复杂的实时发布工作流程变得非常简单的服务。如果你希望交付更多并且不用担心，那么你绝对应该[联系我们](https://turbinelabs.io/contact)！我们很乐意与你交流。

感谢 Glen Sanford、Mark McBride、Emily Pinkerton、Brook Shelley、Sara 和 Jenn Gillespie 阅读本文的草稿。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
