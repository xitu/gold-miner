> * 原文地址：[Deploy != Release (Part 2)](https://blog.turbinelabs.io/deploy-not-equal-release-part-two-acbfe402a91c)
> * 原文作者：[Art Gillespie](https://blog.turbinelabs.io/@artgillespie?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md)
> * 译者： [lwjcjmx123](https://github.com/lwjcjmx123)
> * 校对者：

# 部署 != 发布 (第二部分)

## 将部署和发布解耦以降低风险，并解锁功能强大的工作流

在[这系列的第一部分](https://medium.com/turbine-labs/deploy-not-equal-release-part-one-4724bc1e726b)，我解释了我们在 [Turbine Labs](https://turbinelabs.io) 上用于上线、部署、发布和回滚的定义。我解释了**部署风险**和**发布风险**之间的差异。而且我还谈到了本地发布 —— 一种常用的用于将生产请求暴露给部署风险的部署/发布策略。本文中，我将讨论解耦部署风险与发布风险的方法，并简单介绍一些功能强大的工作流来管理发布风险。

### 蓝/绿部署（或部署!=发布）

[蓝/绿部署](https://martinfowler.com/bliki/BlueGreenDeployment.html)涉及到在生产环境已有发布版本的同时部署新版本。你可以为每种“颜色”使用专用硬件或虚拟机，并在它们之间交替进行后续部署，也可以使用容器或像 Kubernetes 这样的容器集群来管理临时进程。无论如何，关键在于一旦部署了新的（绿色）版本，它不会立即就被发布 —— 也不会响应生产请求。这些服务仍由目前运行良好的（蓝色）版本处理。

在蓝/绿部署体系中，发布通常会涉及到更改负载均衡，在添加新版本的主机之后，移除掉以前运行良好的旧版本。尽管这种方式要比本地部署好的多，它也会有一些局限性，尤其是在发布风险方面。回到正题。首先，我们可以看到你可以做到很多非常强大的事情，通过不同的步骤在部署和发布的时候

#### 什么都没有

如果你的部署在循环崩溃回退中挂起，或这因为数据库密钥错误且新部署的服务无法连接，你也不用承受必须要做些什么事情来挽救的压力。你的团队可以在没有任何压力的情况下诊断问题或构建另一个新版本，然后进行部署这个新版本。你可以很轻松的重复尝试，直到你部署的版本不再出现问题。与此同时,线上的已发布 版本还在照常响应生产环境的请求,并且你不必再公司博客上发布这次部署失败了的通知,换句话说,**你的部署风险基本都被掩盖了*

#### 健康检查和集成测试

当部署与发布被拆分时，你可以在任何生产环境流量暴露给它之前，针对新部署的版本运行自动化健康检查和集成测试。我参与过许多事后分析，其中最重要的一点是，在部署好后或者预发布的时候进行健康检查等简单的事情可以有效避免问题暴露在用户面前。

![](https://cdn-images-1.medium.com/max/800/1*YcCeIx4-FrWMS63ZaVqSRQ.png)

蓝/绿部署在健康检查和集成测试的时候。如果 v1.2 出现问题，客户将不会发现这些问题。

#### 更细粒度的暴露发布风险

由于在引入新的“绿色”主机时，你不一定需要替换现有的“蓝色”主机，所以你可以有**一些**方法来控制新版本生成流量的百分比。例如，如果你有三台运行已知良好的服务版本，你可以在负载均衡器中再混入一台“绿色”主机。现在新版本只有 25% 的流量，而不是33%，只要你不是采用替换原有“蓝色”主机的情况下。虽然这仍然是相当粗放的版本风险管理，但总比没有好。

![](https://cdn-images-1.medium.com/max/800/1*7D-TdjRuzt9wGX1dcMnitg.png)

当你使一个“绿色”主机可用时，暴露该版本中任何错误流量的百分比则取决于主机的总数。这里是 33%。

### 持续发布

正如我以上的讨论，从**部署风险**角度看，蓝/绿部署更好。但当我们考虑**发布风险**时，典型的蓝/绿设置处理版本的方式并不能为我们提供我们正在寻找的细粒度控制。如果我们同意[生产中的每个发布都是测试](https://medium.com/turbine-labs/every-release-is-a-production-test-b31d80f2bc74)（不管同意与否，它一直如此），而我们**真正**想要的是使用模式匹配规则来分割我们的生产请求，并动态分配任意百分比的流量到我们服务的任何版本。这是一个强大的概念，它是构成复杂发布工作流的基础，如内部测试、增量发布、版本回退和黑暗流量。每篇文章都分为上下两部分（即将推出！），但我在这里会大概的介绍一下他们。

**内部测试**是仅向员工发布新版本服务的流行技术。通过强大的发布服务，你可以编写诸如“将内部员工流量的 50% 发送到版本为 x.x 实例”的规则。在我的职业生涯中，生产中的内部测试捕获到了许多我羞于承认的令人尴尬的错误。

**增量发布**是一个过程，从发送一些小百分比生产请求到新版本服务开始，同时监视这些请求的性能 —— 错误、延迟、成功率等 —— 与之前的产品版本相比而言。当你确信新版本不会出现任何相对上一版本意外行为的时候，你可以增加百分比并重复此过程，直至到达 100%。

+**回滚**是在使用持续性发布系统的时候，将生产中的请求转发到最后一个运行良好的实例。它速度快、风险低，并且像发布本身一样，可以通过细粒度方式有针对地完成。

+**黑暗流量**是一种功能强大的技术。你发布的系统会复制生产请求，并将一个副本发送到你的服务运行良好的“明面”上的版本，另一个发送到新的“暗处”的版本。暴露在“明面”的版本负责实际响应用户请求。“暗处”的版本也会处理请求，但其响应会被忽略。当您需要在生产环境下测试新软件时，这非常有效。

在 Turbine Labs 中，我们使用自己的产品 [Houston](https://turbinelabs.io) 来完成内部测试，增量发布、回滚，并很快进行黑暗流量。对我来说，像 Houston 这样先进的发布系统对我的日常工作来说是一种革命性改变。如此轻量级、低风险的发布，使得我可以**经常**这样做。作为一个团队，它以我没有预料到的方式提高了我们的功能发布速度和产品质量。我们将在以后的文章中更详细地介绍我们在 [Turbine Labs](https://turbinelabs.io) 的内部发布流程。

### 结论

在过去的五年中，软件发布领域的大部分技术和流程进展 —— 云计算、容器、编排框架、持续交付等 —— 都集中在部署上。有了这些进步，为你的服务设计和实现一个健壮的**部署**流程变得轻而易举，但设计和实现一个可以支持你服务需求的可靠**发布**流程仍然十分困难。Facebook、Twitter 和 Google 致力于设计、实现和持续维护像 Gatekeeper、TFE 和 GFE 这样成熟的发布系统。这些系统不仅在服务可靠性方面多次证明了它们的价值，还包括开发者生产、产品速度和用户体验方面。

> 一个先进的发布系统不仅可以降低部署风险，还可以直接提高产品速度和用户体验。

我们开始关注为各种规模的公司提供的便利的产品（[Houston](https://turbinelabs.io)、[LaunchDarkly](https://launchdarkly.com/)）和开源工具（[Envoy](https://lyft.github.io/envoy/)、[Linkerd](https://linkerd.io/)、[Traefik](https://traefik.io/)、[Istio](https://istio.io)），以及最近才向大型公司提供的发布单元和工作流。这些产品和工具使得人们可以更快速地发布功能，并且使我们有信心不会对用户体验产生负面影响。

我是 [Turbine Labs](https://turbinelabs.io/) 的一名工程师，我们正在构建 [Houston](https://docs.turbinelabs.io/reference/#introduction) —— 一项使构建和监控复杂的实时发布工作流程变得非常简单的服务。如果你希望交付更多产品并且花更少的心思，那么你绝对应该[联系我们](https://turbinelabs.io/contact)！我们很乐意与你交流。

感谢 Glen Sanford、Mark McBride、Emily Pinkerton、Brook Shelley、Sara 和 Jenn Gillespie 阅读本文的初稿。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
