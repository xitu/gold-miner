> * 原文地址：[When Microservices Are a Bad Idea](https://semaphoreci.com/blog/bad-microservices)
> * 原文作者：[Tomas Fernandez](https://semaphoreci.com/author/tfernandez)
> * 原文审校：[Dan Ackerson](https://semaphoreci.com/author/dan-ackerson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/bad-microservices.md](https://github.com/xitu/gold-miner/blob/master/article/2022/bad-microservices.md)
> * 译者：
> * 校对者：

# When Microservices Are a Bad Idea

On paper, microservices sound wonderful. They are modular, scalable, and fault tolerant. A lot of companies have had great success using this model, so microservices might naturally seem to be the superior architecture and the best way to start new applications.
xxx，微服务听起来很好，它是模块化、可扩展的，而且具有容错性。许多公司利用微服务这一模式取得了巨大的成功，所以微服务似乎自然而然的成为了一种优秀的软件架构以及开始一个新软件项目时的最好方法。

However, most firms that have succeeded with microservices did not begin with them. Consider the examples of Airbnb and Twitter, which went the microservice route after outgrowing their monoliths and are now [battling its complexities](https://thenewstack.io/how-airbnb-and-twitter-cut-back-on-microservice-complexities). Even successful companies that use microservices appear to still be figuring out the best way to make them work. It is evident that microservices come with their share of tradeoffs.
然而，许多依靠微服务取得成功的公司并没有在一开始就采用这一架构。以 Airbnb 和 Twitter 为例，他们也是在快速增长的单体架构无法满足需求后切换到了微服务架构，如今也正在努力[降低微服务架构的复杂性](https://thenewstack.io/how-airbnb-and-twitter-cut-back-on-microservice-complexities)。即使那些使用微服务架构取得成功的公司似乎也正在寻找微服务架构的最佳实践。很明显微服务架构也是尤其取舍。

Migrating from a monolith to microservices is also not a simple task, and creating an untested product as a new microservice is even more complicated. Microservices should only be seriously considered after evaluating the alternative paths.
从单体架构迁移到微服务架构不是一件简单的事，用微服务的方式创建未经测试的产品则会更加复杂。只有在评估了其他路线后，微服务才应该被认真考虑

## Microservices are only viable for mature products
## 微服务只适用于成熟的产品

On the topic of starting from a microservice design, [Martin Fowler observed that](https://martinfowler.com/bliki/MonolithFirst.html):
在开始设计一个微服务架构时，[Martin Fowler 注意到](https://martinfowler.com/bliki/MonolithFirst.html)：

1. Almost all the successful microservice stories started with a monolith that got too big and was broken up.
2. Almost all the cases where a system that was built as a microservice system from scratch, ended up in serious trouble.
1. 几乎所有成功的微服务案例都起始于xxx单体架构
2. 几乎所有以微服务架构为起点的系统最终都会面临巨大的问题
 
This pattern has led many to argue that you shouldn’t start a new project with microservices, even if you’re sure your application will be big enough to make it worthwhile.
这一规律让很多人认为，即使你十分确定你的应用会大到值得采用微服务架构，你也不应该一开始就采用微服务架构。

The first design is rarely fully optimized. The first few iterations of any new product are spent finding what users really need. Therefore, success hinges on staying agile and being able to quickly improve, redesign, and refactor. In this regard, microservices are manifestly worse than a monolith. If you don’t nail the initial design, you’re in for a rough start, as it’s much harder to refactor a microservice than a monolith.
最初的设计很少是被充分优化的。任何新产品的初始设计都是为了去寻找用户真正需要的是什么。因此，需要的是保持敏捷、能够对产品进行快速的改进、重新设计和重构。在这一方面，微服务架构比单体架构要差得多。如果你没能完成好初始的设计，那之后采用微服务将会很艰难，因为重构一个微服务架构比重构一个单体架构要困难的多。

### Are you a startup or working on a greenfield project?
### 初创项目还是绿地软件项目？

As a startup (not likely in this economy), you already are running against the clock, looking for a breakthrough before the next bad thing happens. You don’t need the scalability at this point (and probably not for a few years yet), so why ignore your customers by using a complicated architecture model?
作为一个初创项目（在当今的经济条件下不太可能），你已经在没日没夜的加班，期望能在下一件坏事发生之前找到突破口。在这一阶段（甚至是之后的好几年），你需要的不是可扩展性，所以为什么要忽视客户的需求而采用一个复杂的架构模型呢？

A similar argument can be made when working on greenfield projects, which are unconstrained by earlier work and hence have nothing upon which to base decisions. Sam Newman, author of [**Building Microservices**](https://semaphoreci.com/blog/books-every-senior-engineer-should-read#building-microservices-designing-fine-grained-systems-by-sam-newman)**: Designing Fine-Grained Systems**, stated that it is very difficult to [build a greenfield project with microservices](https://samnewman.io/blog/2015/04/07/microservices-for-greenfield/):
相似的情况也出现在不受早期工作限制也没有前期经验可参考的绿地软件项目中。Sam Newman, [**Building Microservices**](https://semaphoreci.com/blog/books-every-senior-engineer-should-read#building-microservices-designing-fine-grained-systems-by-sam-newman)**: Designing Fine-Grained Systems** 一书的作者表示，[采用微服务架构进行绿地软件项目的开发](https://samnewman.io/blog/2015/04/07/microservices-for-greenfield/)十分困难：

> I remain convinced that it is much easier to partition an existing “brownfield” system than to do so upfront with a new, greenfield system. You have more to work with. You have code you can examine, you can speak to people who use and maintain the system. You also know what ‘good’ looks like – you have a working system to change, making it easier for you to know when you may have got something wrong or been too aggressive in your decision-making process.
> 我仍然坚信对一个已经存在的“棕地”软件系统进行划分要比一个还尚处前期的绿地软件系统要容易的多。你有更多的内容可以参考，有更多的代码可以查看，还可以与之前维护系统的人去交流。你还知道一个“好”应该是怎样的 —— 你有一个现成的系统，这能让你更轻松的知道是否出现了问题，或意识到采取的措施过于激进。

## Microservices aren’t the best for on-premise
## 微服务不适用于本地部署

Microservice deployments need robust automation because of all the moving parts. Under normal circumstances, we can rely on [continuous deployment pipelines](https://semaphoreci.com/blog/cicd-pipeline) for the job–Developers deploy the microservices and customers just use the application online.
由于不同部件的存在，微服务部署需要可靠的自动化流程。在正常情况下，我们可以依赖于[持续集成流水线](https://semaphoreci.com/blog/cicd-pipeline) —— 开发者将微服务部署，客户只需要在线上使用软件即可。

This won’t fly for on-premise applications, where developers publish a package and it’s up to the customer to manually deploy and configure everything on their own on their private systems. Microservices make all these tasks especially challenging, so this is a release model that does not fit nicely with microservice architecture.
这并不适用于本地部署的应用，因为在开发者发布一个软件包后，需要由客户手动在自己的私有系统中手动部署和配置。微服务架构将会让这一过程变得非常复杂，所以，微服务架构并不适用于这一发行模式。

To be clear, developing an on-premise microservice application is entirely viable. Semaphore is accomplishing just that with [Semaphore On-Premise](https://semaphoreci.com/enterprise/on-premise). However, as we realized along the way, there are [several challenges to overcome](https://semaphoreci.com/blog/release-management-microservices). Consider the following before deciding to adopt microservices on-premise:
要明确的是，开发一个本地部署的微服务架构是完全可行的。Semaphore 正是通过 [Semaphore On-Premise](https://semaphoreci.com/enterprise/on-premise) 这样完成的。然而，我们逐渐意识到有[几个问题需要解决](https://semaphoreci.com/blog/release-management-microservices)。在采用微服务本地部署的方式前，不妨考虑一下的几个问题：

* Versioning rules for on-premise microservices are more stringent. You must track each individual microservice that participates in a release.
* You must carry out thorough integration and end-to-end testing, as you can’t test in production.
* Troubleshooting a microservice application is substantially more difficult without direct access to the production environment.
* 微服务本地部署模式的版本规则更加的严格。你必须要能追踪发行版本中的每一个微服务。
* 你必须有贯穿全线和端到端的测试，因为你无法在生产模式中进行测试。
* 由于不能直接访问生产模式，在微服务架构的软件中定位问题更加困难。

## Your monolith might have life left
## 你的单体应用也许还够用

Every piece of software has a lifecycle. You might be tempted to scrap a monolith because it’s old and has its share of complications. But tossing a working product is wasteful. With a little effort, you might be able to squeeze a few more good years out of your current system.
每一个软件都有生命周期。你可能因为单体软件的老旧和复杂感到厌烦，但直接放弃已有的产品是一种浪费。也许多花一点时间，你就能让现有的系统多存活几年时间。

There are two moments when it might seem that microservices are the only way forward:
以下的两个时刻可能会让微服务架构成为唯一的选择：

* **Tangled codebase**: it’s hard to make changes and add features without breaking other functionality.
* **Performance**: you’re having trouble scaling the monolith.
* **混乱的代码库**: 很难在不影响其他功能的前提下进行修改和添加新功能。
* **性能**: 扩展单体架构应用时遇到困难

### Modularizing the monolith
### 模块化单体架构

A common reason developers want to avoid monoliths is their proclivity to deteriorate into a tangle of code. It’s challenging to add new features when we get to this point since everything is interconnected.
开发者不想使用单体架构的一个常见原因就是它会容易让代码变得混乱。当我们陷入这种情况时，很难再往其中添加新的功能，因为所有的东西都相互交织在了一起。

But a monolith does not have to be a mess. Take the example of Shopify: with over 3 million lines of code, theirs is one of the largest Rails monoliths in the world. At one point, the system grew so large it [caused much grief to developers](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity):
但是一个单体架构的应用不一定意味着混乱。以 Shopify 为例：他们的单体架构有超过3百万行的代码，是世界上最大的 Rails 单体架构之一。到了某一时刻，它们的系统增长的过于巨大以致于[给开发者造成了极大的痛苦](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity)：

> The application was extremely fragile with new code having unexpected repercussions. Making a seemingly innocuous change could trigger a cascade of unrelated test failures. For example, if the code that calculates our shipping rate is called into the code that calculates tax rates, then making changes to how we calculate tax rates could affect the outcome of shipping rate calculations, but it might not be obvious why. This was a result of high coupling and a lack of boundaries, which also resulted in tests that were difficult to write, and very slow to run on CI.
> 应用变得及其脆弱，新的代码会造成意想不到的结果。一个小小的改动可能会让一连串不相关的测试失败。举例来说，如果计算运费的代码在计算税率的代码中被调用，那么改动计算税率的代码将会影响运费计算的结果，但其原因却不得而知。这就是高耦合、没有边界的结果，使得代码的测试非常难写，在 CI 中运行也很缓慢。

Instead of rewriting their entire monolith as microservices, [Shopify chose modularization](https://shopify.engineering/shopify-monolith) as the solution.
不是将整个单体架构的应用重写，[Shopify 选择了模块化](https://shopify.engineering/shopify-monolith)的解决方案.

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/module-vs-units.jpg)

<small>Modularization helps design better monoliths and microservices. Without carefully defined modules, we either fall into the traditional layered monolith (the big ball of mud) or, even worse, as a distributed monolith, which combines the worst features of monoliths and microservices.</small>
<small>模块化有助于设计更好的单体架构和微服务架构。如果没有仔细的进行模块化的区分，我们可能会调入传统的分层单体架构的陷阱，甚至是结合了单体架构和微服务架构缺点的分布式单体架构</small>

Modularization is a lot of work, that’s true. But it also adds a ton of value because it makes development more straightforward. New developers do not have to know the whole application before they can start making changes. They only need to be familiar with one module at a time. Modularity makes a large monolith feel small.

Modularization is a required step before transitioning to microservices, and it may be a better solution than microservices. The modular monolith, like in microservices, solves the tangled codebase problem by splitting the code into independent modules. Unlike with microservices, where communication happens over a network, the modules in the monolith communicate over internal API calls.

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/layered-vs-modular-1-1056x723.jpg)

<small>Layered vs modular monoliths. Modularized monoliths share many of the characteristics of microservice architecture sans the most difficult challenges.</small>

### Monoliths can scale

Another misconception about monoliths is that they can’t scale. If you’re experiencing performance issues and think that microservices are the only way out, think again. Shopify has shown us that sound engineering can make a monolith on work on a mind-boggling scale:

> 2021 was our biggest Black Friday Cyber Monday ever! Together with our friends at [@GoogleCloud](https://twitter.com/googlecloud?ref_src=twsrc%5Etfw) we achieved near-perfect uptime while averaging ~30TB/min of egress traffic across our infrastructure. That’s a massive ~43PB/day!  
> 
> — Twitter from Shopify Engineering (@ShopifyEng)

The architecture and technology stack will determine how the monolith can be optimized; a process that almost invariably will start with modularization and can leverage cloud technologies for scaling:

* Deploying multiple instances of the monolith and using load balancing to distribute the traffic.
* Distributing static assets and frontend code using CDNs.
* Using caching to reduce the load on the database.
* Implementing high-demand features with edge computing or serverless functions.

## If it’s working, don’t fix it

If we measure productivity as the number of value-adding features implemented over time, then it follows that switching architecture makes little sense while productivity is strong.

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/productivity.jpg)

<small>Microservices are initially the less productive architecture due to maintenance overhead. As the monolith grows, it gets more complex, and it’s harder to add new features. Microservice only pays off after the lines cross.</small>

True, something will have to change eventually. But that could be years from now, and by then, requirements may have changed — and who knows what new architecture models may emerge in the meantime?

## Brooke’s Law and developer productivity

In [**The Mythical Man Month**](https://semaphoreci.com/blog/books-every-senior-engineer-should-read#month) (1975), Fred Brook Jr stated that “adding manpower to a late software project makes it later”. This happens because new developers must be mentored before they can work on a complex codebase. Also, as the team grows, the communication overhead increases. It’s harder to get organized and make decisions.

![](https://wpblog.semaphoreci.com/wp-content/uploads/2022/07/brooke.jpg)

<small>Brook’s law applied to complex software development states that adding more developers to a late software project only makes it take longer.</small>

Microservices are one method of reducing the impact of Brooke’s Law. However, this effect is only visible in complicated and huge codebases where everything is interconnected, because we cannot divide development into discrete tasks in such a scenario.

Before deciding on using microservices, you must determine if Brooke’s Law is affecting your monolith. Switching to microservices too soon would not add much value.

## Are you ready to transition?

Some conditions must be met before you can begin working with microservices. Along with [preparing your monolith](https://semaphoreci.com/blog/monolith-microservices), you’ll need to:

* Set up [continuous integration and continuous delivery](https://semaphoreci.com/cicd) for automatic deployment.
* Implement quick provisioning to build infrastructure on demand.
* Learn about cloud-native tech stacks, including containers, Kubernetes, and serverless.
* Get acquainted with [Domain-Driven Design](https://semaphoreci.com/blog/domain-driven-design-microservices), [Test-Driven Development](https://semaphoreci.com/blog/test-driven-development), and [Behavior-Driven Development](https://semaphoreci.com/community/tutorials/behavior-driven-development).
* Reorganize the teams to be [cross-functional](https://kanbanize.com/blog/cross-functional-teams/), removing silos and flattening hierarchies to allow for innovation.
* Foster a DevOps culture in which the lines between developer and operations jobs are blurred.

Changing the culture of an organization can take years. Learning all that there is to know will take months. Without preparation, transitioning to microservices is unlikely to succeed.

## Conclusion

We can summarize this whole discussion about transitioning to microservices in one sentence: don’t do it unless you have a good reason. Companies that embark on the journey to microservices unprepared and without a solid design will have a very tough time of it. You need to achieve a critical mass of engineering culture and scaling know-how before microservices should be considered as an option.

In the meantime, why change if your system is performing well and you’re still developing features at a decent pace?

Thanks for reading, and happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
