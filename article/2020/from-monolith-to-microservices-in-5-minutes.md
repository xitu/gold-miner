> - 原文地址：[From Monolith to Microservices in 5 Minutes](https://levelup.gitconnected.com/from-monolith-to-microservices-in-5-minutes-83069677d021)
> - 原文作者：[Daniel Rusnok](https://medium.com/@danielrusnok)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/from-monolith-to-microservices-in-5-minutes.md](https://github.com/xitu/gold-miner/blob/master/article/2020/from-monolith-to-microservices-in-5-minutes.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[zenblo](https://github.com/zenblo)，[NieZhuZhu](https://github.com/NieZhuZhu)

# 5 分钟内从单体架构迁移到微服务架构

> “微服务架构是一种将单体应用程序开发为一套小型服务的方法。”——马丁 · 福勒。

![Monolithic Architecture vs. Microservice Architecture](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3oixi4ktj318x0u0e81.jpg)

首先，我们需要明白什么是单体架构。因此，我将向你展示如何修改它的域，以便为微服务架构做好准备。最后，我将会简要地告诉你微服务架构的基础知识，并讨论其优缺点。

## 单体架构

每一种非垂直拆分的架构都是单体架构。软件设计中的垂直拆分意味着将应用程序划分为更多可部署的单元。这并不意味着单体架构不能[水平划分](https://levelup.gitconnected.com/layers-in-software-architecture-that-every-sofware-architect-should-know-76b2452b9d9a)。

单体这个词指的是软件的体系结构是由一个后端单元组成。我之所以说后端，是因为我认为单体架构可以在具有多个 UI（如 Web 和移动设备）的同时，仍然可以被看作为一个整体。

![Monolithic Architecture](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3oiyfcgrj309h0e7dgg.jpg)

组件之间的通信主要通过方法的调用。如果你的前端和后端是在物理上隔离的，但是它们仍然是一个整体，例如 API 和 Web 客户端。

除非你将后端划分为更多部署单元，否则在我看来你依旧是在使用单体架构。

## 单域模型

> “域是计算机程序的目标主题领域。形式上，它代表特定编程项目的目标主题。”—— 维基百科

用我的话说，域就是软件存在的原因和目的。我在 [3 Domain-Centric Architectures Every Software Developer should Know](https://levelup.gitconnected.com/3-domain-centric-architectures-every-software-developer-should-know-a15727ada79f) 这篇文章中写了有关域的几个观点。

下图是一个将在线商城域可视化的结果。

![Single-Domain Model](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3oj5uhidj31kr0siwfk.jpg)

Sales 和 Catalog 子域包含单个的 **Product** 实体。这种做法是不可取的，因为这将导致一个地方出现更多的问题。这违反了[关注点分离原则](https://en.wikipedia.org/wiki/Separation_of_concerns)。

强迫一个实体承担更多的责任，显然是不合理的。实体在这两种上下文中都包含未使用的属性。Sales 不需要知道产品的类别，并且对于 Catalog 来说，知道 Product 是如何将信息传递给客户并没有任何用处。

为了避免这个问题，我们需要找到 Sales 和 Catalog 上下文的边界来将它们分开。这就引出接下来要说的限界上下文。

## 限界上下文

> 限界上下文是上下文的边界，参考 [Idapwiki.com](https://ldapwiki.com/wiki/Bounded%20Context)

要指定限界上下文，我们需要识别出一个模型仍然有效的上下文范围。

我们可以通过对域中的每个实体问一个简单的问题来验证模型，即：**这个实体对于哪个上下文有效？**

![Specifying Entities Contexts](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3oj7fmupj31pf0riwgp.jpg)

当一个实体对多个上下文有效时，那么它应该被划分到多个上下文中。每个实体都具有与上下文相对应的属性。这一步结束后，你的应用就准备好迁移到**微服务架构**了。

下图是从在线商城域中对 Product 分离的实体类的可视化结果。

![Multi-Domain Model](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3ojbxttfj31yx0sfab7.jpg)

## 微服务架构

微服务架构是因为微服务从而闻名。它是不断细分的单体。微服务将大型系统划分为较小的部分。

限界上下文帮助我们找到一个微服务的最佳大小。微服务的模型应当尽可能小，以最大程度减少与外部世界的通信；但也不能过于小而失去存在的必要性。

![Microservices](https://tva1.sinaimg.cn/large/0081Kckwgy1gl3ojcifbtj30y10u0gs9.jpg)

微服务架构使项目具有独立性。该架构支持分离的开发团队、不同的操作系统、不同的编程语言以及不同的业务层架构，例如 [CQRS](https://levelup.gitconnected.com/3-cqrs-architectures-that-every-software-architect-should -know-a7f69aae8b6c)。

每一个微服务对外都有一个明确定义的接口，主要通过 HTTP 传输，并以 JSON 的形式实现，例如 REST API。对于微服务之间的通信，推荐的解决方案是通过 [RabitMQ](https://www.rabbitmq.com/) 或 [Azure 服务总线](https://azure.microsoft.com/cs-cz/services) 之类的消息平台。

如果没有适当的消息传递工具，那么微服务必须知道其他微服务的位置，并且这个位置是会被随意更改的。

## 总结

在大型应用程序中，微服务体系结构的开发成本曲线较好。小型应用程序无法从微服务中受益，因此应保持单体架构。

微服务会有分布式系统的成本，比如负载平衡和网络延迟。这些问题通过任务编排器可以很好的解决，常见的有 [Kubernetes ](https://kubernetes.io/) 和 [Azure Service Fabric](https://azure.microsoft.com/cs-cz/services/service-fabric/)。

有了对以上这些内容的理解，接下来我推荐你去阅读 [Pluralsight course from Mark Heath — Microservices Fundamentals](https://app.pluralsight.com/library/courses/microservices-fundamentals/table-of-contents)。

## 参考

- [Martin Fowler’s blog post about microservices.](https://martinfowler.com/microservices/)
- [Martin Fowler’s blog post about Bounded Context.](https://martinfowler.com/bliki/BoundedContext.html)
- [Pluralsight course Clean architecture patterns, practices, and principles](https://app.pluralsight.com/library/courses/clean-architecture-patterns-practices-principles/table-of-contents).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
