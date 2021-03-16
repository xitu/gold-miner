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

In the same way that developers had to worry about bare metal servers before virtualization came around, developers didn’t need to worry specifically about virtual machines with the advent of containers.  Similarly, developers don’t need to worry about containers with the increasing interest in serverless computing—the new paradigm for getting code developed, deployed, and executed.

## Serverless Definition

There are many definitions of serverless—some definitions talk about Functions as a Service (FaaS) and the other definitions relate to Backend Services (BaaS) whether they are database (DBaaS) or Security services.  They both share similar characteristics to abstract to a platform or a functional layer using an execution or consumption-based cost model.

Most of the serverless interest is in Function as a Service; this should not be misunderstood to mean functional programming, in fact, most of the Cloud providers do not provide major support for functional programming.  What then characterizes Function as a Service?

1. **Writing the code** — A developer can write whatever code they want and have it executed within a FaaS environment with minimal change. The code will have a message handler which is the main method that acts as the listener interface.

2. **Deploying the code** — It's literally a copy-and-paste into the FaaS console for that specific function. Although most IDE also supports FaaS integration.

3. **Scaling the code** — It is the responsibility of the FaaS runtime to scale as many instances as necessary. Cluster management technologies like Kubernetes, if used, are abstracted.*

4. **Executing the code** — FaaS are suitable for event-driven architectures as the code runs when it receives an event or a trigger. This can be an HTTP request, a file being sent, or a message arriving on a message queue, etc. 

5. **Short running** — FaaS are ephemeral and not long-running, therefore they do not hold any state. It is the responsibility of the developer to persist in any state outside the function.

6. **Cost execution** — FaaS is charged for the duration of execution. This is where FaaS differs from BaaS; for example, Google BigQuery would charge the amount of data scanned or SQS would charge per API call. Code that runs for too long or doesn’t receive a request will eventually time out.

## Latency Challenges

![https://dzone.com/storage/temp/14502652-picture-1.png](https://dzone.com/storage/temp/14502652-picture-1.png)

When an event is triggered there is an amount of time for the FaaS function to be initialized before it can be executed. This can be the cold-start-time or the warm-start time of the VM running the code.

## Language and Memory Challenges

The latency of your FaaS code can vary from milliseconds to seconds and the choice of language and the amount of memory allocated can have a big difference; for example from a recent AWS re:Invent, talk they showed how cold start time was significantly higher using Springboot to Java and how increasing memory allocation from 1Mb to 3Mb could reduce that further.  But using node frameworks had a 100x lower cold start-up time regardless of memory allocation.  Thus, showing node as a popular language for serverless. In summary Python or Node is faster.

### Why Is This Not a Problem Today?

In recent years a lot has been said about the performance concerns regarding serverless computing lending them for certain use cases over others; for example, Serverless could greatly benefit from traditional Web and API serving compared to something like low latency IoT applications.  Concerns about latency and cold and warm start-up times and performance characteristics of different language frameworks have also been stated.

- **Cloud Vendors are optimizing:**  All of the major cloud providers are putting significant effort into Serverless plumbing to optimize the cold-start times which means that through a number of measures (including predictive scheduling, optimization of language runtimes, native forked processes) that these concerns will be resolved.

- **Developers can optimize too:**  For developers there are a number of strategies that they are in control of like, increasing memory allocation, choosing a faster language runtime, keeping shared data in memory, shrinking the package size, keeping a pool of pre-warmed functions (also known as provisioned concurrency), all of which addresses most concerns.

### Where Is the Industry Going?

> Forrester predicts “25% of developers will use serverless and nearly 30% will use containers regularly by the end of 2021."

Serverless is moving beyond just Compute to really make it easy to provision Database on Serverless too. Amazon announced at AWS re:Invent 2020 that Aurora Serverless v2 will scale MySQL and PostgresSQL to Petabyte scale with full support for Multi-AZ, Global database with Read Replicas, backtrack, and Parallel Query. AWS is not standing still they announced that you can package and deploy Lambda serverless functions using containers, thus making it much easier for developers who have existing automated pipelines—this all helps to reduces the friction for developer adoption.

Many enterprises have adopted Kubernetes as a common platform for the deployment of their containers and this has not been an easy journey for many putting additional pressure on developers and operations teams.  Very few enterprises need the scale and complexity of Kubernetes (EKS) and the market has realized that with alternative options in the marketplace like Elastic Container Service (ECS), which is cheaper and easier to deploy, couple that with something like Fargate for Serverless then developers don’t even need to worry about provisioning their EC2 instances.  The equivalent of ECS Fargate is Google Cloud Run and Azure for Anthos.

Despite cloud vendors trying to simplify container management in the cloud the trend and direction are clear to higher levels of abstraction where the developers can focus on the code rather than the complexities of deploying nodes, pods, or virtual machines.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

