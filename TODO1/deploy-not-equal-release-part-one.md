> * 原文地址：[Deploy != Release (Part 1): The difference between deploy and release and why it matters.](https://blog.turbinelabs.io/deploy-not-equal-release-part-one-4724bc1e726b)
> * 原文作者：[Art Gillespie](https://blog.turbinelabs.io/@artgillespie?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-one.md)
> * 译者：[stormluke](https://github.com/stormluke)
> * 校对者：[MechanicianW](https://github.com/MechanicianW)、[ALVINYEH](https://github.com/ALVINYEH)

# 部署 != 发布（第一部分）

## 部署与发布的区别，以及为什么这很重要

问：「最新版本部署了吗？」

答：「我在生产环境里部署了 gif 动图支持。」

问：「就是说 gif 动图支持已经发布啦？」

答：「Gif 动图的发布版本已经部署了。」

问：「……」

我曾在很多公司工作过，在这些公司中「部署（deploy，动词）」、「部署物（deployment，名词）」、「上线（ship）」和「发布（release）」都是随意地使用，甚至可以互换使用。作为一个行业，我们在规范使用这些术语方面做得还不够，尽管我们在过去的十多年里已经从根本上改进了运维实践和工具。在 [Turbine Labs](https://turbinelabs.io) 中，我们使用了「上线」、「部署」、「发布」和「回滚（rollback）」的精确定义，并花了大量的时间来思考当你把「发布」作为上线过程的一个独立阶段时，世界是什么样子的。在这篇文章的第一部分，我会分享这些术语的定义，描述一些常见的「部署 == 发布」的实践，并且解释为什么这样做的抗风险性很差。在第二部分，我会描述当「部署」和「发布」被视为软件上线周期的不同阶段时的一些非常强大的风险缓释技术。

### 上线

**上线**指你的团队从源码管理库中获取服务代码某个**版本**的快照，并用它处理线上流量的过程。我认为整个上线过程由四个不同的专门的小流程组成：构建（build）、测试、部署和发布。得益于云基础架构、容器、编配框架的技术进步以及流程改进，如 [twelve-factor](https://12factor.net/)、[持续集成](https://martinfowler.com/articles/continuousIntegration.html)和[持续交付](https://martinfowler.com/bliki/ContinuousDelivery.html)，执行前三个流程（构建，测试和部署）从未如此简单。

### 部署

**部署**指你的团队在生产环境的基础设置中安装新版本服务代码的过程。当我们说新版软件被**部署**时，我们的意思是它正在生产环境的基础设施的某个地方运行。基础设置可以是 AWS 上的一个新启动的 EC2 实例，也可以是在数据中心的 Kubernetes 集群中的某个容器中运行的一个 Docker 容器。你软件已成功启动，通过了健康检查，并且已准备好（像你希望的那样！）来处理线上流量，但实际上可能没有收到任何流量。这是一个重要的观点，所以我会用 Medium 超棒的大引用格式来重复一遍：

> **部署不需要向用户提供新版本的服务。**

根据这个定义，**部署可以是几乎零风险的活动**。诚然，在部署过程中可能会出现很多问题，但是如果一个容器静默应对崩溃，并且没有用户获得 500 状态响应，那问题是否真的算是**发生**了？

![](https://cdn-images-1.medium.com/max/800/1*5B2HsE8FasLrEsaoRLxBiQ.png)

部署了新的版本（紫色），但未发布。已知良好的版本（绿色）仍对线上请求做出响应。

### 发布

当我们说服务版本**发布**时，我们的意思是它负责服务线上流量。在动词形式中，**发布**是将线上流量转移到新版本的过程。鉴于这个定义，与上线新的二进制文件有关的所有风险 —— 服务中断、愤怒的用户、[The Register](https://www.theregister.co.uk/2017/02/28/aws_is_awol_as_s3_goes_haywire) 中的刻薄内容 —— 与新软件的发布而不是部署有关。在一些公司，我听说这个上线阶段被称为**首次发布（rollout）**。这篇文章中我们将依旧使用**发布**来表述。

![](https://cdn-images-1.medium.com/max/800/1*wDLGwgwtDo1h7dCWg4Qymw.png)

新版本发布，响应线上请求。

### 回滚

迟早，很可能不久之后，你的团队就会上线一些功能有问题的服务。回滚（和它危险的、不可预测的、压力山大的兄弟 —— 前滚 roll-forward）指将线上服务退回到某个已知状态的过程，通常是重新发布最近的版本。将回滚视为另一个部署和发布流程有助于理解，唯一的区别是：

* 你正在上线的版本的特征在生产环境中已知
* 你正在时间压力下执行部署和发布过程
* 你可能正向一个不同的环境中发布 —— 在上次失败的发布之后某些东西可能改变了（或被改变了）

![](https://cdn-images-1.medium.com/max/800/0*MAapvhIhLX8oWJ25.)

一个发布后回滚的例子。

现在我们已经就上线、部署、发布和回滚的定义达成了共识，让我们来看看一些常见的部署和发布实践。

### 原地发布（即部署 == 发布）

当你的团队的上线流程涉及将新版本的软件推送到运行旧版本的服务器上并重启服务的流程时，你就是在原地发布。根据我们上面的定义，部署和发布是同时发生的：一旦新软件开始运行（部署），它就会负载旧版本的所有线上流量（发布）。此时，成功的部署就是成功的发布，失败的部署则会带来部分或整体的服务中断，一群愤怒的用户，可能还有一个气急败坏的经理。

在我们所讨论的部署/发布过程中，原地发布是唯一的将**部署风险**暴露给用户的方式。如果你刚刚部署的新版本无法启动 —— 可能是因为无法找到新增的环境变量而抛出异常，也可能是有一个库依赖不满足，或者只是你今天出门时没看黄历 —— 此时并没有老版本的服务实例来负载用户请求。你的服务此时至少是部分不可用的。

此外，如果有用户相关的问题或更微妙的运维问题 —— 我把它叫做**发布风险** —— 原地发布会将线上请求暴露给你已发布的所有实例。

在集群环境中，您可能会首先原地发布一个实例。这种做法通常称为**金丝雀**发布，它可以减轻一些风险 —— 面临部署风险和发布风险的流量的百分比为：新服务实例的个数除以集群中的实例总数。

![](https://cdn-images-1.medium.com/max/800/1*rAKFZcAMipD5HpvovIlXmA.png)

一个金丝雀发布：集群中的一个主机运行新版本

最后，回滚错误的原地部署可能会有问题。即使你回滚（重新发布）到旧版本，也无法保证可以恢复到以前的系统状态。与当前错误的部署一样，你的回滚部署在启动时也可能会失败。

尽管其风险管理相对较差 —— 即便使用金丝雀，一些用户请求也会面临部署风险 —— 原地部署仍旧是业务中常见的方式。我认为这类的经验会导致不幸地混用「部署」和「发布」这两个术语。

### 别绝望

我们可以做得更好！在[这篇文章的第二部分](https://medium.com/turbine-labs/deploy-not-equal-release-part-two-acbfe402a91c)，我们会讨论分离部署和发布的策略，以及可以在复杂的发布系统上构建的一些强大工作流。

**我是 [_Turbine Labs_](https://turbinelabs.io) 的一名工程师，我们正在构建 [_Houston_](https://docs.turbinelabs.io/reference/#introduction)，这个服务可以轻松构建和监控复杂的实时发布工作流程。如果你想轻松地上线更多服务，你绝对应该[联系我们](https://turbinelabs.io/contact)。我们很乐意与你交谈。**

**感谢 Glen Sanford、Mark McBride、Emily Pinkerton、Brook Shelley、Sara 和 Jenn Gillespie 阅读此文的草稿。**

感谢 [Glen D Sanford](https://medium.com/@9len?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
