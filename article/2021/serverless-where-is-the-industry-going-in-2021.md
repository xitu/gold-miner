> * 原文地址：[Serverless: Where Is the Industry Going in 2021?](https://dzone.com/articles/serverless-where-is-the-industry-going-in-2021)
> * 原文作者：Suresh Kumar
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/serverless-where-is-the-industry-going-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/serverless-where-is-the-industry-going-in-2021.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：

# Serverless: Where Is the Industry Going in 2021?
# 去服务化：2021年该项技术何去何从？

> In this article, we discuss what it means to be considered Serverless, how companies are adopting this trend, and where the industry is advancing in 2021.
> 在本文中，我们主要讨论去服务化的含义、公司是如何应用这一技术的、以及在2021年该技术将会如何发展。

## Introduction
## 介绍

Serverless computing is a style of developing software on cloud platforms that frees developers of the complexities of code deployment, infrastructure provisioning, and availability management of the code in the cloud.  Amazon popularized this with Lambda in 2014.  Since then, all the cloud vendors have followed suit with similar capabilities, Azure Functions, and Google Cloud Functions.
无服务器计算是在云平台上开发软件的一种风格，它将开发人员从代码部署、基础设施配置和云中的代码可用性管理的复杂性中解放出来。亚马逊在2014年用Lambda推广了这一点。从那以后，所有的云供应商都纷纷效仿，推出了类似的功能、Azure功能和谷歌云功能。

In the same way that developers had to worry about bare metal servers before virtualization came around, developers didn’t need to worry specifically about virtual machines with the advent of containers.  Similarly, developers don’t need to worry about containers with the increasing interest in serverless computing—the new paradigm for getting code developed, deployed, and executed.
就像在出现虚拟化之前开发人员必须担心裸金属服务器一样，随着容器的出现，开发人员不需要特别担心虚拟机。类似地，随着人们对无服务器计算(用于开发、部署和执行代码的新范式)越来越感兴趣，开发人员也不需要担心容器。

## Serverless Definition
## 无服务定义

There are many definitions of serverless—some definitions talk about Functions as a Service (FaaS) and the other definitions relate to Backend Services (BaaS) whether they are database (DBaaS) or Security services.  They both share similar characteristics to abstract to a platform or a functional layer using an execution or consumption-based cost model.
有许多关于无服务器的定义——一些定义讨论功能即服务(FaaS)，其他定义与后端服务(BaaS)有关，不管它们是数据库(DBaaS)还是安全服务。它们都具有类似的特征，可以使用基于执行或消费的成本模型抽象到平台或功能层。

Most of the serverless interest is in Function as a Service; this should not be misunderstood to mean functional programming, in fact, most of the Cloud providers do not provide major support for functional programming.  What then characterizes Function as a Service?
大多数无服务器的兴趣在于服务的功能;这不应该被误解为函数式编程，事实上，大多数云提供商并不提供函数式编程的主要支持。那么是什么将功能定义为服务呢?

1. **Writing the code** — A developer can write whatever code they want and have it executed within a FaaS environment with minimal change. The code will have a message handler which is the main method that acts as the listener interface.
1. **代码开发** —— 开发人员可以编写他们想要的任何代码，并在FaaS环境中以最小的更改执行这些代码。该代码将具有一个消息处理程序，它是充当侦听器接口的主要方法。

2. **Deploying the code** — It's literally a copy-and-paste into the FaaS console for that specific function. Although most IDE also supports FaaS integration.
2. **代码部署** —— 它实际上是将特定功能复制粘贴到FaaS控制台中的操作。尽管大多数IDE也支持FaaS集成。

3. **Scaling the code** — It is the responsibility of the FaaS runtime to scale as many instances as necessary. Cluster management technologies like Kubernetes, if used, are abstracted.
3. **代码扩展** —— FaaS运行时的职责是根据需要扩展尽可能多的实例。集群管理技术(如Kubernetes)是抽象的。

4. **Executing the code** — FaaS are suitable for event-driven architectures as the code runs when it receives an event or a trigger. This can be an HTTP request, a file being sent, or a message arriving on a message queue, etc. 
4. **执行代码** —— FaaS适合于事件驱动的体系结构，因为代码在接收到事件或触发器时运行。这可以是一个HTTP请求，一个正在发送的文件，或者到达消息队列的消息，等等。

5. **Short running** — FaaS are ephemeral and not long-running, therefore they do not hold any state. It is the responsibility of the developer to persist in any state outside the function.
5. **短时间运行** ——  FaaS是短暂的，不是长时间运行的，因此它们不保持任何状态。开发人员应该将需要保存的状态保存在函数之外。

6. **Cost execution** — FaaS is charged for the duration of execution. This is where FaaS differs from BaaS; for example, Google BigQuery would charge the amount of data scanned or SQS would charge per API call. Code that runs for too long or doesn’t receive a request will eventually time out.
6. **执行成本** —— FaaS在执行期间收取费用。这就是FaaS与BaaS的不同之处;例如，谷歌BigQuery将对扫描的数据量或SQS对每次API调用的数据量收费。运行时间过长或没有收到请求的代码最终将超时。

## Latency Challenges
## 延迟挑战

![https://dzone.com/storage/temp/14502652-picture-1.png](https://dzone.com/storage/temp/14502652-picture-1.png)

When an event is triggered there is an amount of time for the FaaS function to be initialized before it can be executed. This can be the cold-start-time or the warm-start time of the VM running the code.
当事件被触发时，在执行FaaS函数之前有一段时间对其进行初始化。这可以是VM运行代码的冷启动时间或暖启动时间。

## Language and Memory Challenges
## 语言和内存方面的挑战

The latency of your FaaS code can vary from milliseconds to seconds and the choice of language and the amount of memory allocated can have a big difference; for example from a recent AWS re:Invent, talk they showed how cold start time was significantly higher using Springboot to Java and how increasing memory allocation from 1Mb to 3Mb could reduce that further.  But using node frameworks had a 100x lower cold start-up time regardless of memory allocation.  Thus, showing node as a popular language for serverless. In summary Python or Node is faster.
FaaS代码的延迟可能从毫秒到秒不等，语言的选择和分配的内存数量可能有很大的差异;例如，在最近的AWS re:Invent演讲中，他们展示了使用Springboot到Java是如何显著提高冷启动时间的，以及如何将内存分配从1Mb增加到3Mb可以进一步减少冷启动时间。但是，不管内存分配如何，使用节点框架的冷启动时间要低100倍。因此，将node显示为一种流行的无服务器语言。总之，Python或Node更快。

### Why Is This Not a Problem Today?
### 为什么这些问题不再是问题？

In recent years a lot has been said about the performance concerns regarding serverless computing lending them for certain use cases over others; for example, Serverless could greatly benefit from traditional Web and API serving compared to something like low latency IoT applications.  Concerns about latency and cold and warm start-up times and performance characteristics of different language frameworks have also been stated.
近年来，关于无服务器计算的性能问题已经说了很多了，它们被用于某些用例而不是其他用例;例如，与低延迟的物联网应用程序相比，无服务器可以从传统的Web和API服务中大大受益。对延迟、冷启动和热启动时间以及不同语言框架的性能特征也进行了阐述。

- **Cloud Vendors are optimizing:**  All of the major cloud providers are putting significant effort into Serverless plumbing to optimize the cold-start times which means that through a number of measures (including predictive scheduling, optimization of language runtimes, native forked processes) that these concerns will be resolved.
- **云服务提供商正在努力：**所有主要的云提供商都在无服务器的管道上投入了大量的精力来优化冷启动时间，这意味着通过一系列措施(包括预测调度、语言运行时的优化、本地分支进程)，这些问题都将得到解决。

- **Developers can optimize too:**  For developers there are a number of strategies that they are in control of like, increasing memory allocation, choosing a faster language runtime, keeping shared data in memory, shrinking the package size, keeping a pool of pre-warmed functions (also known as provisioned concurrency), all of which addresses most concerns.
- **开发者也可以自行优化：**对于开发人员来说，他们可以控制许多策略，比如增加内存分配、选择更快的语言运行时、将共享数据保存在内存中、缩小包大小、保留预暖函数池(也称为预备并发)，所有这些都可以解决大多数问题。

### Where Is the Industry Going?
### 这一技术将何去何从？

> Forrester predicts “25% of developers will use serverless and nearly 30% will use containers regularly by the end of 2021."
> Forrester 公司预测:“到2021年年底，25%的开发者将使用无服务器，近30%的开发者将定期使用容器。”

Serverless is moving beyond just Compute to really make it easy to provision Database on Serverless too. Amazon announced at AWS re:Invent 2020 that Aurora Serverless v2 will scale MySQL and PostgresSQL to Petabyte scale with full support for Multi-AZ, Global database with Read Replicas, backtrack, and Parallel Query. AWS is not standing still they announced that you can package and deploy Lambda serverless functions using containers, thus making it much easier for developers who have existing automated pipelines—this all helps to reduces the friction for developer adoption.
无服务器正在超越单纯的计算，使在无服务器上提供数据库变得更加容易。亚马逊在AWS：发明2020上宣布:,Aurora无服务器v2将把MySQL和PostgresSQL扩展到pb级，完全支持多az，具有读副本、回溯和并行查询的全球数据库。AWS并没有停滞不前，他们宣布可以使用容器打包和部署Lambda无服务器功能，这样对于已经拥有自动化管道的开发人员来说就容易多了——这都有助于减少开发人员采用Lambda的阻力。

Many enterprises have adopted Kubernetes as a common platform for the deployment of their containers and this has not been an easy journey for many putting additional pressure on developers and operations teams.  Very few enterprises need the scale and complexity of Kubernetes (EKS) and the market has realized that with alternative options in the marketplace like Elastic Container Service (ECS), which is cheaper and easier to deploy, couple that with something like Fargate for Serverless then developers don’t even need to worry about provisioning their EC2 instances.  The equivalent of ECS Fargate is Google Cloud Run and Azure for Anthos.
许多企业已经采用Kubernetes作为其容器部署的通用平台，这对许多企业来说并不是一件容易的事情，这给开发人员和运营团队带来了额外的压力。很少有企业需要的规模和复杂性Kubernetes(的)和市场意识到与替代选项在市场上像弹性容器服务(ECS),这是更便宜,更容易部署,结合类似Fargate Serverless然后开发人员甚至不需要担心配置EC2实例。与ECS Fargate等价的是谷歌Cloud Run和Azure for Anthos。

Despite cloud vendors trying to simplify container management in the cloud the trend and direction are clear to higher levels of abstraction where the developers can focus on the code rather than the complexities of deploying nodes, pods, or virtual machines.
尽管云供应商试图简化云中的容器管理，但趋势和方向对更高层次的抽象来说是清晰的，开发人员可以专注于代码，而不是部署节点、pods或虚拟机的复杂性。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

