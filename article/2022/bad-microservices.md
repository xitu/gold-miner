> * 原文地址：[When Microservices Are a Bad Idea](https://semaphoreci.com/blog/bad-microservices)
> * 原文作者：[Tomas Fernandez](https://semaphoreci.com/author/tfernandez)
> * 原文审校：[Dan Ackerson](https://semaphoreci.com/author/dan-ackerson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/bad-microservices.md](https://github.com/xitu/gold-miner/blob/master/article/2022/bad-microservices.md)
> * 译者：[DylanXie123](https://github.com/DylanXie123)
> * 校对者：[wangxuanni](https://github.com/wangxuanni)、[Quincy-Ye](https://github.com/Quincy-Ye)

# 微服务架构何时会是一种坏选择

单单是纸上谈兵的话，微服务听起来很好，它是模块化、可扩展的，而且具有容错性。许多公司利用微服务这一模式取得了巨大的成功，所以微服务似乎自然而然的成为了一种优秀的软件架构模式和启动一个新软件项目时的最好方法。

然而，许多依靠微服务取得成功的公司并没有在一开始就采用这一架构。以 Airbnb 和 Twitter 为例，他们是在快速增长的单体架构无法满足需求后才切换到了微服务架构，而如今他们也正在努力[降低微服务架构的复杂性](https://thenewstack.io/how-airbnb-and-twitter-cut-back-on-microservice-complexities)。即使那些使用微服务架构取得成功的公司也似乎正在寻找微服务架构的最佳实践。很明显，微服务架构也有它的利和弊。

从单体架构迁移到微服务架构不是一件简单的事，用微服务的方式创建未经测试的产品则会更加复杂。只有在评估了其他技术路线后，才应认真考虑微服务架构。

## 微服务只适用于成熟的产品

在设计一个微服务架构时，[Martin Fowler 注意到](https://martinfowler.com/bliki/MonolithFirst.html)：

1. 几乎所有成功的微服务架构都起始于一个规模过大以至于要崩溃的单体架构。
2. 几乎所有以微服务架构为起点的系统，最终都会面临着严重的问题。
 
这一规律让很多人认为，即使你十分确定你的应用会大到值得采用微服务架构，你也不应该在一开始就采用微服务架构。

最初的设计很少是被充分优化的。任何新产品的前几次设计都是为了挖掘用户的真实需求。因此要的是保持敏捷、能够对产品进行快速的改进、重新设计和重构。在这一方面，微服务架构比单体架构要差得多。如果你没能很好的完成初始的设计，那之后采用微服务将会很艰难，因为重构一个微服务架构比重构一个单体架构要困难的多。

### 你是在初创公司还是在开发一个新的项目？

如果是在初创公司（在当今的经济条件下不太可能），你已经在没日没夜的加班，期望能在下一件坏事发生之前找到突破口。在这一阶段（甚至是之后的好几年），你需要的不是可扩展性，所以为什么要忽视客户的需求而去采用一个复杂的架构模型呢？

在那些既不受早期工程限制，也没有前期经验可参考的新项目中，也可以提出相似的观点。Sam Newman, 《[**构建微服务**](https://semaphoreci.com/blog/books-every-senior-engineer-should-read#building-microservices-designing-fine-grained-systems-by-sam-newman)**: 设计细微化的系统**》一书的作者表示，[采用微服务架构进行绿地软件项目的开发](https://samnewman.io/blog/2015/04/07/microservices-for-greenfield/)十分困难：

> 我仍然认为划分一个旧系统要比划分一个处于前期的新系统要容易的多。你有更多的内容可以参考，有更多的代码可以查看，还可以与之前维护系统的人去交流。你还能知道“好”的系统应该是怎样的 —— 你有一个现成的系统，这能让你更轻松的意识到是否出现了问题，或采取的措施是否过于激进。

## 微服务不适用于本地部署

由于所有的部件是可移动的，微服务部署需要可靠的自动化流程。在正常情况下，我们可以依赖于[持续集成流水线](https://semaphoreci.com/blog/cicd-pipeline) —— 开发者将微服务部署，客户只需要在线上使用软件即可。

这并不适用于本地部署的应用，因为在开发者发布一个软件包后，需要由客户在自己的私有系统中手动部署和配置。微服务架构将会让这一过程变得非常复杂，所以，微服务架构并不适用于这一发行模式。

要明确的是，开发一个本地部署的微服务架构是完全可行的。Semaphore 正是通过 [Semaphore On-Premise](https://semaphoreci.com/enterprise/on-premise) 这样完成的。然而，我们逐渐意识到有[几个问题需要解决](https://semaphoreci.com/blog/release-management-microservices)。在采用微服务本地部署的方式前，不妨考虑以下的几个问题：

* 微服务本地部署模式的版本规则要更加的严格。你必须要能追踪发行版本中的每一个单独的微服务。
* 你必须有贯穿全线和端到端的测试，因为你无法在生产模式中进行测试。
* 由于不能直接访问生产模式，在微服务架构的软件中定位问题更加困难。

## 你的单体应用也许还够用

每一个软件都有生命周期。你可能因为单体架构的老旧和复杂感到厌烦，但直接放弃已有的产品是一种浪费。也许多花一点时间，你就能让现有的系统多存活几年时间。

在以下的两个时刻，微服务架构可能会成为唯一的选择：

* **混乱的代码库**：很难在不破坏其他功能的前提下进行修改和添加新功能。
* **性能**：扩展单体架构应用时遇到困难。

### 模块化单体架构

开发者不想使用单体架构的一个常见原因就是它会容易让代码变得混乱。当我们陷入这种情况时，很难再往其中添加新的功能，因为所有的东西都相互耦合在了一起。

但是一个单体架构的应用不一定意味着混乱。以 Shopify 为例：他们的单体架构有超过 3 百万行的代码，是世界上最大的 Rails 单体架构之一。到了某一时刻，它们的系统增长的过于巨大以致于[给开发者造成了极大的痛苦](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity)：

> 这样的应用极其脆弱，添加新的代码就会造成意想不到的结果。一个小小的改动可能会让一连串不相关的测试失败。举例来说，如果计算运费的代码在计算税率的代码中被调用，那么改动计算税率的代码将会影响运费计算的结果，但其原因却不得而知。这就是高耦合且没有边界的结果，代码的测试变得非常难写，在 CI 中运行也很缓慢。

[Shopify 选择了模块化](https://shopify.engineering/shopify-monolith)的解决方案，而不是将整个单体架构的应用重写。

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/module-vs-units.jpg)

<small>模块化有助于设计更好的单体架构和微服务架构。如果没有仔细的进行模块化的区分，我们可能会掉入传统的分层单体架构的陷阱，甚至是变成结合了单体架构和微服务架构缺点的分布式单体架构。</small>

的确，模块化是一个大工程。但它也是值得的，因为这能让开发的过程更加简洁明了。新的开发者不需要了解整个应用，他们每次只需要了解一个模块。这让一个大的单体架构应用感觉起来变小了。

模块化是转向微服务架构过程中的一个必须步骤，而且可能是比微服务架构更好的解决方案。模块化的单体架构应用也能像微服务架构一样，通过将代码分割成独立的模块，解决复杂代码库的问题。与微服务架构通过网络进行通讯不同，单体架构中的模块通过内部的 API 调用进行通讯。

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/layered-vs-modular-1-1056x723.jpg)

<small>分层单体架构与模块化单体架构对比。模块化单体架构有许多微服务架构的优点且没有微服务架构所面临的问题。</small>

### 单体架构也是可扩展的

另一个关于单体架构的错误观点就是它不具备可扩展性。如果你遇到了性能问题，认为微服务架构是唯一的解决方案，那你需要重新想想。Shopify 的例子已经向我们证明，单体架构也能扩展到一个令人难以置信的量级：

> 2021年我们的黑色星期五和网络星期一是有史以来最大规模的！和我们在[@GoogleCloud](https://twitter.com/googlecloud?ref_src=twsrc%5Etfw)的朋友一起，我们在平均 30 TB/min，也就是43 PB/天的出口流量条件下，实现了几乎完美的启动时间，
> 
> — 来自 Shopify Engineering 团队的 Twitter（@ShopifyEng）

采用的架构和技术栈决定了单体架构能在多大程度上被优化，而优化往往是一个从模块化开始并利用云技术进行拓展的过程：

* 部署多个单体架构应用，使用负载均衡来平衡流量。
* 利用 CDNs 分发静态内容和前端代码。
* 使用缓存来减少数据库的负载。
* 利用边缘计算和无服务器函数来实现高性能要求的功能。

## 如果它能用，就不要动它

如果我们以单位时间内添加的有价值功能为指标来衡量生产率，那么在高生产率的时候切换架构就显得毫无意义。

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/productivity.jpg)

<small>由于更大的维护成本，微服务架构不可避免的是一种生产率更低的架构。随着一个单体架构不断增长变得复杂，添加新功能会变得更加复杂。微服务架构仅在穿过那条线之后才能更有价值。</small>

的确，一些东西最终会变化。但那可能是好几年之后的事，那时的要求可能也发生了变化 —— 而且谁知道在这段时间内会不会有新架构出现呢？

## 布鲁克斯法则和程序员的生产率

在《[**人月神话**](https://semaphoreci.com/blog/books-every-senior-engineer-should-read#month)》（1975）一书中，Fred Brook Jr 表示，“向进度落后的项目中增加人手，只会使进度更加落后”。因为新的程序员必须要经过指导才能开始在一个复杂的代码库中开展工作。同时，随着团队的增长，沟通成本也会增加，更加难以组织起来并做出决定。

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/brooke.jpg)

<small>软件开发中的布鲁克斯法则表明，向进度落后的项目中增加人手，只会使进度更加落后。</small>

微服务是一种减少布鲁克斯法则影响的方法。但是，这只在复杂和大型的代码库中才有效，因为代码之间相互耦合，难以将其分割为独立的任务。

在转向使用微服务之前，你必须考虑布鲁克斯法则是否影响了你的单体架构应用的开发。过早的迁移到微服务架构并不会有多少好处。

## 做好准备迁移了吗？

在你准备采用微服务架构之前，有几点要求必须要达到。除了[改进你的单体架构应用](https://semaphoreci.com/blog/monolith-microservices)，你还需要：

* 建立[持续集成 CI 和持续交付 CD](https://semaphoreci.com/cicd) 以完成自动部署。
* 实施快速配置以按需构建基础架构。
* 掌握云原生技术栈，包括容器（containers），Kubernetes，和无服务器（serverless）。
* 熟悉[领域驱动开发](https://semaphoreci.com/blog/domain-driven-design-microservices)，[测试驱动开发](https://semaphoreci.com/blog/test-driven-development)和[行为驱动开发](https://semaphoreci.com/community/tutorials/behavior-driven-development)。
* 重组开发团队以构建[多功能型团队](https://kanbanize.com/blog/cross-functional-teams/)，摒弃缺乏联系的开发模式，扁平化管理层级以鼓励创新。
* 培养开发运维（DevOps）的文化，让开发者和运维人员的界限模糊化。

改变一个公司的文化可能要花上数年的时间，学习所有的知识可能会花费好几个月的时间。如果没有这些准备，迁移到微服务架构将不太可能取得成功。

## 结论

我们可以将以上这些关于迁移到微服务架构的讨论总结成一句话：除非你有一个很好的理由，否则不要这么做。那些没有好好准备就直接迁移到微服务架构的公司将会发现这非常困难。在将微服务架构作为一种选择之前，你需要大量的工程师文化和如何对应用进行扩展的知识。

同时，如果你的系统能好好的运行且仍然能够添加新功能，为什么要去改变它呢？

感谢您的阅读，祝快乐编码！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
