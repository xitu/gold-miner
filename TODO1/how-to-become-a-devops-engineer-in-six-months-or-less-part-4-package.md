> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 4: Package](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package-47677ca2f058)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：

# 如何在六个月或更短的时间内成为 DevOps 工程师，第四部分：打包

![](https://cdn-images-1.medium.com/max/1000/0*dUiEaJN0gcR_ZFd5)

“Packages” 由 [chuttersnap](https://unsplash.com/@chuttersnap?utm_source=medium&utm_medium=referral) 拍摄并发表在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 上

### 快速回顾

在第 1 部分，我们聊了聊 DevOps 的文化和所需要的基础：

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师（系列文章第一篇）](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md)**

在第 2 部分，我们讨论了如何为部署将来的代码奠定基础：

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师，第二部分：配置](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)**

在第 3 部分，我们探讨了如何组织部署代码：

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师，第三部分：版本控制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md)**

这个部分，我们将说一说怎么打包你的代码以便于部署和后续执行。

作为参考，这里是我们的旅程：

![](https://cdn-images-1.medium.com/max/800/1*uTJj1toNrJRl9f6qxR73rQ.png)

<center>打包</center>

注意：你可以看到每一部分如何前一部分之上，并为后续部分奠定基础。这很重要并且是有目的的。

原因是，无论你与现在的老板还是以后的老板交谈，你都得能清楚表达出什么是 DevOps 并且为何它这么重要。

你通过讲述一个连贯的故事来做到这一点 —— 这个故事讲述了如何既好又快地把代码从开发者的笔记本电脑上发送到能赚钱的生产环境（prod）部署。

因此，我们正在学习的并不是一堆割裂的、时髦的 DevOps 工具，我们正在学习的是是一系列受业务需求驱动，由技术工具支持的技能。

好了，哔哔够了，让我们开始吧！

### 虚拟化入门

还记得物理服务器吗？你必须等待几周才能获得 PO 批准，发货，数据中心接收，上架，联网，安装操作系统以及打补丁？

是的，那些。他们是第一位的。

实质上，想一下如果获得住所的唯一方式是建造一座全新的房子。需要一个住的地方？还得等这么长时间？有点意思。然而每个人都有房子，但也不是真的因为建造房子需要很长时间。在这个类比中，物理服务器就像一个房子。

然后人们对花了这么长的时间去做这堆事情感到恼火，有些非常聪明的人提出了 **虚拟化** 的想法：如何在一台单独的物理机上运行一堆伪装的“机器”，并让每台假机器伪装成一台真机。天才！

所以，如果你真的想要一套房子，你可以建造你自己的并等待 6 周。或者你可以住在公寓楼里和其他租户共享资源。或许不是很棒但是足够好了。但是更重要的是，不需要等待！

这种情况持续了一段时间，公司（即VMWare）对此进行了绝对的杀戮。

直到其他聪明的人认为将一堆虚拟机填充到物理机还不够好：我们需要压缩**更多**的流程**更紧凑**的打包到**更少**的资源中。

在这一点上，房子太贵了，公寓也太贵了。如果我们只需要暂时租用一间屋子呢？这太棒了，我可以随时出入！

实际上，这就是 Dokcer。


### Docker 的诞生

Dokcer 是新的但是 Docker 背后的**思想**是很古老的。一个叫 FreeBSD 的系统有一个 [jails](https://en.wikipedia.org/wiki/FreeBSD_jail) 的概念，其可回溯到 2000 年！诚然一切新的都是旧的。

当时和现在的想法都是在同一个操作系统中隔离单个进程，即所谓的“操作系统级虚拟化”。

注意：这和“完全虚拟化”不同，后者是在同一物理主机上并行运行虚拟机。

这实际上意味着什么？

实际上，这意味着 Docker 的兴起巧妙地反映着微服务的兴起 —— 一种软件工程的方法，其中软件被分解成多个独立的组件。

并且这些组件需要一个家。单独部署他们，部署独立的 Java 应用程序或者二进制可执行文件非常痛苦：你管理 Java 应用程序的方式和管理 C++ 应用程序的方式不同，这和管理 Golang 应用程序的方式也是不同的。

相反，Docker 提供单一的管理界面，让软件工程师以一致的方式打包（！）、部署、运行各种各样的应用程序。

这是一个里程碑！

OK，我们一起来聊聊 Docker 更多的好处。

### Docker 的好处

#### 进程隔离

Docker 允许每个服务有完全的**进程隔离**。服务 A 和自己所有的依赖一起存在于自己的小容器之中，服务 B 也和自己的依赖存在于自己的容器中，而且二者没有冲突！

此外，如果一个容器挂了，只有该容器会被影响。其余的（应该）将会继续愉快地运行着。

这对于安全的好处也是显而易见的。如果容器被泄露，那么离开容器并破解宿主系统是非常困难的（并非不可能！）。

最后，如果容器发生了故障（占用了太多的 CPU 或者内存），则可以仅仅将爆炸半径”包含“到该容器，而不会影响系统其它部分。

#### 部署

想想实际上如何构建不同的应用程序。

如果它是一个 Python 应用程序，它会有各种各样的 Python 包。一些作为 **pip** 模块安装，另一些是 **rpm** 或者 **deb** 包，其它则是简单的 **git clone** 安装。或者使用 **virtualenv**，它将是 **virtualenv** 目录中所有的 zip 文件。

另一方面，如果它是一个 Java 应用程序，他将用 gradle 构建，其所有依赖关系被拉取并放到适当的位置。

你抓住了关键点。在将这些应用程序部署到 prod 环境中时，各种应用程序，使用不同语言和不同运行时（runtime）构建都是一项挑战。

我们怎么样才能保持所有的依赖关系都满足呢？

另外，如果存在冲突，问题会更加严重。如果服务 A 依赖于 Python 库 v1，但是服务 B 依赖 Python 库 v2 怎么办？现在存在冲突，因为 v1 和 v2 不能再同一台机器上共存。

选择 Docker。

Docker 不仅允许完全**进程隔离**，还允许完全的**依赖隔离**。在同一个操作系统上并排运行多个容器是完全可行并常见的，每个容器都有自己冲突着的库和包。

#### 运行时管理

同样，我们管理不同应用程序的方式因应用程序而异。Java 代码的日志记录方式不同，启动方式不同，监控方式和 Python 不同，Python 和 GoLang 等也不同。

通过 Docker，我们得到了一个统一的管理界面，允许我们启动、监控、收集日志、停止和重启多种不同类型的应用程序。

这是一个里程碑，并大大降低了运行生产系统的运营开销。

### 选择 Lambda

As great as Docker is, it has downsides.

First, running Docker is still running servers. Servers are brittle and flaky. They must be managed, patched and otherwise cared for.

Second, nobody really runs Docker as is. Instead, it is almost always deployed as part of a complex container orchestration fabric, such as Kubernetes, ECS, _docker-swarm_ or Nomad. These are fairly complex platforms that require dedicated personnel to operate (more on these solutions later).

However, if I’m a developer, I just want to write code and have somebody else run it for me. Docker, Kubernetes and all that jazz are not simple things to learn — do I really have to?!

Short answer is, it depends!

For people who just want somebody else run their code, [AWS Lambda](https://aws.amazon.com/lambda/) (and other solutions like it) are the answer:

> AWS Lambda lets you run code without provisioning or managing servers. You pay only for the compute time you consume — there is no charge when your code is not running.

If you have heard of the whole “serverless” movement, this is it! No more servers to run or containers to manage. Just write your code, package it up in to a zip file, upload to Amazon and let them deal with the headache!

Moreover, since Lambdas are short lived there is nothing to hack — Lambdas are pretty secure by design.

Great, isn’t it?

It is but (surprise!) there are caveats.

First, Lambdas can only run for a max of 15 minutes (as of November 2018). This implies that long running processes, like Kafka consumers or number crunching apps cannot run in Lambda.

Second, Lambdas are Functions-as-a-Service, which means your application must be fully decomposed into microservices and orchestrated with other complex PaaS services like [AWS Step Functions](https://aws.amazon.com/step-functions/). Not every enterprise is at this level of microservice architecture.

Third, troubleshooting Lambdas are difficult. They are cloud-native runtimes and all bug fixing takes place within Amazon ecosystem. This is oftentimes challenging and non-intuitive.

In short, there is no free lunch.

NOTE: There are now “serverless” cloud container solutions as well. [AWS Fargate](https://aws.amazon.com/fargate/) is one such approach. However, I’m ignoring that for now since these tend to be fairly expensive and are still sparingly used.

### 总结

Docker and Lambda are two of the most popular modern, cloud-native approaches to packaging, running and managing production applications.

They are often complimentary, each suited for slightly different use cases and applications.

Regardless, a modern DevOps engineer must be well versed in both. Therefore, learning Docker and Lambda are good short- and medium-term goals.

NOTE: Thus far in our series we have dealt with topics that Junior to Mid-Level DevOps Engineers are expected to know. In subsequent sections, we will start discussing techniques that are more suited for Mid-Level to Senior DevOps Engineers. As always, however, there are no shortcuts to experience!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
