> * 原文地址：[Serverless: Where Is the Industry Going in 2021?](https://dzone.com/articles/serverless-where-is-the-industry-going-in-2021)
> * 原文作者：Suresh Kumar
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/serverless-where-is-the-industry-going-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/serverless-where-is-the-industry-going-in-2021.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[kamly](https://github.com/kamly)

# 无服务器化：2021 年该项技术何去何从？

> 在本文中，我们主要讨论无服务器化的含义、公司是如何应用这一技术的、以及该技术在 2021 年将会如何发展。

## 介绍

无服务器计算是在云平台上开发软件的一种方法，它将开发人员从代码部署、基础设施配置和云上代码可用性管理之类的复杂工作中解放出来。亚马逊在 2014 年通过 Lambda 服务推广了这一技术。自此之后，其他的云服务提供商都纷纷效仿，推出了类似的功能、 Azure 函数和谷歌云函数。

就像在出现虚拟化之前开发人员必须担心裸机服务器，而容器的出现使得开发人员不需要特别担心虚拟机一样，类似地，随着人们对无服务器计算这种用于开发、部署和执行代码的新范式越来越感兴趣，开发人员也不需要担心容器。

## 无服务器定义

有许多关于无服务器的定义 —— 一些定义将其描述为功能即服务（FaaS），其他定义则将其包含的数据库（DBaaS）或安全服务描述为与后端服务（BaaS）有关。它们都具有类似的特征，可以使用基于执行或消费的成本模型抽象到平台或功能层。

大多数对于无服务的兴趣在于功能即服务（FaaS），这不应该被误解为函数式编程，事实上，大多数云提供商的服务并不支持函数式编程。那么，什么是功能即服务呢?

1. **代码开发** —— 开发人员可以编写他们想要的任何代码，并在 FaaS 环境中进行最少的更改就能执行这些代码。该代码将具有一个消息处理程序，它是充当侦听器接口的主要方法。

2. **代码部署** —— 它实际上是将特定功能复制粘贴到 FaaS 控制台中的操作，尽管大多数 IDE 也支持 FaaS 集成。

3. **代码扩展** —— FaaS 运行时按需求扩容尽可能多的实例。类似 Kubernetes 的集群管理技术将该功能封装并供用户使用。

4. **执行代码** —— FaaS 适合于事件驱动的体系结构，因为代码在接收到事件或触发器时运行，这些事件可以是一个 HTTP 请求，一个正在发送的文件，或者到达消息队列的消息，等等。

5. **短时间运行** —— FaaS 是短暂而非长时间运行的，因此不保持任何状态。开发人员应该将需要保存的状态保存在函数之外。

6. **执行成本** —— FaaS 按照执行时间长短收取费用。这就是 FaaS 与 BaaS 的不同之处。例如，谷歌 BigQuery 根据扫描的数据量或 SQS 对每次 API 调用的数据量收费。运行时间过长或没有收到请求的代码最终将超时。

## 高延迟挑战

![https://dzone.com/storage/temp/14502652-picture-1.png](https://dzone.com/storage/temp/14502652-picture-1.png)

当事件被触发时，先要进行初始化才能接着执行 FaaS 函数。这段初始化事件被称作 VM 运行代码的冷启动时间或暖启动时间。

## 语言和内存方面的挑战

FaaS 代码的延迟可能从毫秒到秒不等，而选择不同语言以及分配不同的内存大小可能会对性能带来很大差异，例如，在最近的 AWS re:Invent 演讲中展示了使用 Springboot 和 Java 是如何显著提高冷启动时间的，以及如何将内存分配从 1Mb 增加到 3Mb 可以进一步减少冷启动时间。但是，不管内存分配如何，使用 Node 框架的冷启动时间要低 100 倍，正因如此 Node 成为了一种流行的无服务器语言。总的来说，Python 或 Node 启动更快。

### 为什么这些问题不再是问题？

近年来，关于无服务器计算的性能问题已经被开发者们进行了广泛讨论，讨论确定无服务器计算应该被用于某些适合的情境下，例如，无服务器技术不适合于要求低延迟的物联网应用程序，但它适用于传统的 Web 和 API 服务。这些讨论对无服务器中延迟、冷启动和热启动时间以及不同语言框架的性能特征等问题也进行了阐述。

- **云服务提供商正在努力：**所有主要的云提供商都在无服务器的管道上投入了大量的精力来优化冷启动时间，这意味着云服务提供商可以通过一系列措施(包括预测调度、语言运行时的优化、本地分支进程)来解决延迟问题。

- **开发者也可以自行优化：**对于开发人员来说，他们可以控制许多策略，比如增加内存分配、选择更快的运行时语言、将共享数据保存在内存中、缩小包大小、保留预暖函数池(也称为预备并发)，以解决大多数问题。

### 这一技术将何去何从？

> Forrester 公司预测：“到 2021 年年底，25% 的开发者将使用无服务器，近 30% 的开发者将定期使用容器。”

无服务器正在超越单纯的计算，在无服务器上甚至可以提供数据库。亚马逊在 AWS re:Invent 2020 上宣布：Aurora v2 无服务器将把 MySQL 和 PostgresSQL 扩展到 Pb 级，完全支持高可用，具有读副本、回溯和并行查询的全球数据库。AWS 并没有停滞不前，他们宣布可以使用容器打包和部署 Lambda 无服务器功能，这样对于已经拥有自动化管道的开发人员来说就容易多了 —— 这都有助于减少开发人员采用 Lambda 的阻力。

许多企业已经采用 Kubernetes 作为其容器部署的通用平台。对许多企业这并不容易，因为它给开发人员和运营团队带来了额外的压力。很少有企业需要 Kubernetes 提供的的规模和复杂功能，因而转向了像弹性容器服务（ECS）这样的替代选项，它更便宜，更容易部署。将 ECS 与类似 Fargate 的无服务器结合，开发人员甚至不需要担心配置 EC2 实例。与 ECS Fargate 等价的是谷歌 Cloud Run 和 Azure for Anthos。

尽管云供应商试图简化云上容器管理，但对更高层次的抽象的趋势和方向是清晰的，在这种趋势之下，开发人员可以专注于代码，而不是部署节点、pods 或虚拟机的复杂工作。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

