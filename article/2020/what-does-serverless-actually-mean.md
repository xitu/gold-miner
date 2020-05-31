> * 原文地址：[What Does Serverless Actually Mean?](https://medium.com/better-programming/what-does-serverless-actually-mean-c68bde4cdc0d)
> * 原文作者：[Steven Popovich](https://medium.com/@steven.popovich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/what-does-serverless-actually-mean.md](https://github.com/xitu/gold-miner/blob/master/article/2020/what-does-serverless-actually-mean.md)
> * 译者：[Roc](https://github.com/QinRoc)
> * 校对者：[Xiny](https://github.com/x1ny)，[江不知](https://github.com/JalanJiang)

# 无服务器实际上是什么意思？

![Photo by [Taylor Vick](https://unsplash.com/@tvick?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/servers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/7912/1*poXRRZdZAElrrP9C3ZQLoQ.jpeg)

> 无服务器实际上根本不是没有服务器

**无服务器（serverless）** 这个单词真是误导人。当然，这是个流行词。

如果你用 Google 搜索“无服务器”，搜索结果中 Wikipedia 的定义实际上相当好：

> “无服务器计算是[云计算](https://en.wikipedia.org/wiki/Cloud_computing)的一种[运行模型](https://en.wikipedia.org/wiki/Execution_model)。在这个模型中，云服务商负责运行[服务器](https://en.wikipedia.org/wiki/Server_(computing))，动态分配机器资源。这种方式基于应用实际消耗的资源量计费，而不是基于预先购买的容量单位。[[1]](https://en.wikipedia.org/wiki/Serverless_computing#cite_note-techcrunch-lambda-1) 它是[效用计算](https://en.wikipedia.org/wiki/Utility_computing)的一种形式。” —— Wikipedia

这都是真的。而且，如果你可以消化这个术语的定义，就会发现无服务器实际上包括许多服务器。

无服务器实际上意味着你不必担心服务器的配置（处理能力）或为用户服务所需的服务器数量。无服务器服务的提供商会根据你投入的工作量来调整所需的服务器配置和数量。

Cloudflare(一个无服务器后端提供商)用下图很好地展示了无服务器是如何为你节省资金以及如何扩展的：

![源自 [Cloudfare 的无服务器的成本效益分析图](https://www.cloudflare.com/learning/serverless/why-use-serverless/)](https://cdn-images-1.medium.com/max/2000/1*e3EE-9xCRweHvYnK44wYlQ.png)

在传统系统中，当更多的用户涌入你的应用程序，或者用户执行了更多操作，又或者任何导致后端程序需要进行更多处理的事情发生时，你都必须增加服务器的数量（或服务器的性能）来应对增长的需求。

让我们举个例子。假设你运营 Reddit。你必须有一个服务器集群来为用户提供网站服务，并需要一个数据库来保存所有链接、评论和用户个人资料。

在传统模型中，你可能只有一台服务器来处理访问流量。你可能有一个扩展策略 —— 如果该服务器的 CPU 负载持续 5 分钟超过了 95％，就添加另一台服务器来分流。这台新加的服务器就是上图中的蓝色服务器。你将为每台服务器每小时支付固定费用。当你从一台服务器扩展到两台服务器时，你的成本就会增加一倍。

但是，如果扩展到两台服务器后，用户离开了你的网站，你该怎么办呢？你的新服务器甚至都没发挥作用。你可能有一个缩放策略，可以缩减到一台服务器，但关键是，如果你启用了两台服务器，就需要为它们付费。

你可以看到增加的开销。从技术上讲，你是在为可能不会使用的服务器性能付费。

但是，在理论上，使用无服务器，你就只需为使用的东西付费。你无需设置扩展策略或选择所需的服务器数量。你只需要向无服务器提供商提供流量并支付费用即可。你不知道提供商使用了多少台服务器，也不在乎。节省下来的钱理论上会留给你。

这就是**无服务器**这个名词的由来。你使用的是服务器性能，不必考虑后台运行的服务器。但是它们还在那里！

## 有什么隐患么？

所以为什么不处处使用无服务器呢？似乎每个人都会从中受益，因为我们不会浪费服务器时间。

但是这没那么简单。在幕后，无服务器提供商仍然做着和传统模型一样的事情。而且它不会神奇地变得完美。

无服务器提供商（即 AWS Lambda，Cloudflare，Azure 和 Google Cloud 之类的服务）仍然在幕后伸缩，并增减投入工作的服务器。有时它们会有闲置的服务器。无论服务器是否被使用，仍然有人需要为它们付费。

现在，它们可能会在这方面做得更好。它们可以使用先进的机器学习算法，来将你的工作智能地分配到多台服务器上。服务器可以由不同的人运行。由于以节省成本的方式提供服务器时间且避免服务器时间的浪费是其主要目的，因此它们可能比你更有效地做到这一点。但是，就像你管理自己的服务器那样，它们也必须处理服务器集群的缩放。

无服务器实际上只是将扩展工作交给了服务提供商。那么，如果提供商不擅长做这个，又该怎么办呢？请记住，你在为无服务器算法和基础架构的工程付费。这意味着，对于某些工作负载，你可能需要支付更多的费用。

请记住：这些提供商是企业。

请务必记住，无论你选择其中哪个提供商，无服务器都是需要赚钱的业务。

它们可能在小项目上赔钱，而在大项目上赚钱。

许多面向开发者的后端服务的提供商（Google Maps API 和 Firebase，仅举几个我使用过的）都采用了“扩展时就付款”的策略。在这种情况下，对于一些小的工作负载，其成本要比你自己配置服务器便宜得多。但是，当你扩大工作量（业务增长）时，无服务器的成本将远远超过你自己配置服务器的成本。请记住这一点，并在必要时使用提供商的计价方式来计算成本。

#### 幕后还有一人

此外，无服务器还存在另一个问题，让作为分布式系统维护人员的我感到紧张：你无法确切地了解正在发生的事情。

当你运行自己的服务器，在其上运行自己的软件，并对自己管理的所有服务器进行自己的监控和缩放时，你拥有**控制权**。开发人员和公司都需要对大型应用程序进行控制。你需要洞悉系统中正在发生的事情。

使用无服务器时，如果你的工作负载出现问题，会很难判断发生了什么，因为你不能只看服务器上的日志来分析问题。正在进行的计算对你是隐藏的。

或者，当用户开始投诉你的软件无法运行或运行缓慢时，你将无法准确地了解系统为何无法扩展。你所能做的就是向你的提供商提交工单，并希望这只是个短暂的现象。

这意味着调试系统会更加困难。虽然你仍然可以依靠日志记录之类的内容来调试系统，但是我知道大多数后端维护者都希望能够登录到出现问题的服务器上，并确切地了解发生了什么。

无服务器还存在许多其他问题，我就不在这里一一赘述了（供应商锁定，冷启动，安全性？）。但是如果你正在考虑将无服务器用于你的应用程序，那么这些问题就值得你认真考虑了。

## 但我们需要无服务器

我希望无服务器是完美的。我和许多其他人都过多地担心我们的系统是否会扩展。

请记住，任何时候只要你可以减少系统中需要担心的变量数，它都会让系统变得更好。你总是希望能降低系统的复杂性。

但是明天就拥抱无服务器并不一定能降低复杂性，也不一定能降低成本。和其他任何技术或架构决策一样，重要的是确定它是否适合你的项目。花点时间来深入分析什么是适合自己的东西吧。

无服务器还在使用服务器 —— 别被骗了！感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
