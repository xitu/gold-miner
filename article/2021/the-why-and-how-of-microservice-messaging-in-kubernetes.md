> * 原文地址：[The Why and How of Microservice Messaging in Kubernetes](https://levelup.gitconnected.com/the-why-and-how-of-microservice-messaging-in-kubernetes-1d54a4717bf1)
> * 原文作者：[Michael Bogan](https://medium.com/@michael.bogan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-why-and-how-of-microservice-messaging-in-kubernetes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-why-and-how-of-microservice-messaging-in-kubernetes.md)
> * 译者：
> * 校对者：

# The Why and How of Microservice Messaging in Kubernetes

## Introduction

Struggling with connecting and maintaining your microservices in Kubernetes? As the number of microservices grows, the difficulty and complexity of maintaining your distributed fleet of services grows exponentially. Messaging can provide a clean solution to this issue, but legacy message queues come with their own set of problems.

In this article, I’ll share the benefits of messaging in Kubernetes and the difficulties that can come with legacy solutions. I’ll also briefly look at KubeMQ, which attempts to address some of the traditional problems with messaging in Kubernetes.

## Why Messaging in Kubernetes?

As a microservice-based architecture grows, it can be difficult to connect each of these distributed services. Issues of security, availability, and latency have to be addressed for each point-to-point interaction. Furthermore, as the number of services increases, the number of potential connections also grows. For example, consider an environment with only three services. These three services have a total of three potential connections:

![](https://cdn-images-1.medium.com/max/2000/0*MnLbG8FpmHAHgqIh)

However, as that increases to say five services, the number of potential connections increases to 10:

![](https://cdn-images-1.medium.com/max/2000/0*toIa18YoswmvefdJ)

With 20 services, the number of potential connections is 190! For reference, see the table below:

![](https://cdn-images-1.medium.com/max/2750/1*YICTJvUjgWg2V1-8FHWrjA.png)

This is clearly not sustainable for organizations with a large portfolio of services. However, through the use of a message queue, we can centralize those connections. Since the number of connections is equal to the number of services, this results in a solution which scales linearly. See below:

![](https://cdn-images-1.medium.com/max/2328/0*0RiyaZI4dgiwTRAB)

For a large microservice fleet, this significantly simplifies the security and availability issues, as each microservice needs to communicate primarily with the message queue. This is the very reason implementing a message queue architecture is considered best practice when running large numbers of microservices in Kubernetes. As a result, the selection of the message queue is a critically important decision, as the entire architecture will depend on the reliability and scalability of that message queue.

Finally, deploying the message queue in Kubernetes allows you to avoid platform lock-in. There are a number of platform-specific messaging solutions from the major cloud providers, but running a platform-agnostic solution allows you to keep your microservices architecture consistent, regardless of your platform. Kubernetes is the de facto orchestration solution and has support from all major cloud providers.

Now that we’ve established why messaging is helpful, let’s dig a little deeper. This seems like such a simple solution, so what could be so hard about it?

## What’s hard about messaging in Kubernetes?

There are a number of pain points when attempting to run a message queue in Kubernetes. Let’s consider the differences between a typical microservice and your standard message queue. I’ve summarized some of the differences in the following table:

![](https://cdn-images-1.medium.com/max/2000/1*x8OmpOvNMcnLAexbDeQVxA.png)

First, microservices are designed to be resource-light. This is in some ways a natural result of being a microservice — each service performs a single purpose, and thus can be smaller and more nimble. In contrast, legacy message queues are large, resource-intensive applications. The latest version of IBM MQ at time of writing has [significant hardware requirements](https://www.ibm.com/software/reports/compatibility/clarity-reports/report/html/softwareReqsForProduct?deliverableId=E3F333600B7F11EABCF401BE73544226&osPlatforms=Linux&duComponentIds=D005%7CS011%7CS006%7CS010%7CS008%7CS007%7CS009%7CA004%7CA003%7CA001%7CA002&mandatoryCapIds=16&optionalCapIds=30%7C341%7C47%7C12%7C9%7C1%7C25%7C20%7C28%7C184%7C185%7C70%7C16%7C15%7C26#!). For example, > 1.5 GB disk space and 3 GB of RAM.

Additionally, a typical microservice is stateless, as it does not contain any part of the state of the application in itself. However, many legacy message queues function effectively as databases and require persistent storage. Persistent storage in Kubernetes is best handled with the [Persistent Volume API](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), but this requires workarounds for legacy solutions.

These differences in resource usage lead naturally to the next point — microservices are simple to deploy. Microservices are designed to deploy quickly and as part of a cluster. On the other hand, due to their resource-intensive nature, legacy message queues have complex deployment instructions and require a dedicated team to set up and maintain.

Next, microservices are designed to be horizontally scalable. Horizontal scaling is done through the deployment of additional instances of a service. This allows a service to scale nearly infinitely, have high availability, and is generally cheaper. In contrast, due to the aforementioned resource requirements and deployment pains, legacy message queues must be scaled vertically — in other words, a bigger machine. In addition to the physical limitations (a single machine can only be so powerful), larger machines are expensive.

These issues typically require significant investment and time to resolve, reducing the value that the message queue provides to your overall architecture. However, none of these issues are inherent to messaging; they are instead an artifact of when the major message queues were designed and conceived.

So how can we address these issues? Let’s take a look at one option: using a Kubernetes-native message queue such as KubeMQ.

## A Kubernetes-native Approach

[KubeMQ](https://kubemq.io/) is an product that attempts to solve Kubernetes-related messaging issues. Let’s take a look at a few ways it does this.

First, it is **Kubernetes-native**, which means that it integrates well with Kubernetes and is simple to deploy as a Kubernetes cluster. [Operators](https://operatorhub.io/operator/kubemq-operator) that allow you to automate tasks **beyond** what Kubernetes natively provides come with the product for lifecycle management. [Cluster persistency](https://docs.kubemq.io/learn/cluster-scale#cluster-persistency) is supported through both local volume and PVCs. Being Kubernetes-native also means that it is cloud-agnostic, and thus it can also be deployed on-premises or into hybrid cloud environments.

Additionally, it is **lightweight** — the Docker container is roughly ~30 MB, a far cry from the GB of required space from legacy solutions. This allows it to be deployed virtually anywhere and enables new use cases, such as edge deployments for Internet-of-Things device support. Despite its small size, it has support for [a variety of messaging patterns](https://kubemq.io/product-messaging-patterns/).

Finally, it is **extensible**. Through the use of [Bridges](https://kubemq.io/kubemq-bridges/), [Targets](https://kubemq.io/kubemq-targets/), and [Sources](https://kubemq.io/kubemq-sources/), these pre-built connectors allow it to connect to a variety of other applications and services, reducing the need for custom integrations. Bridges allow KubeMQ clusters to pass messages between one another, enabling KubeMQ to connect various cloud, on-premises, and edge environments.

Since KubeMQ is small, you can try it out for yourself with a [local installation of minikube](https://minikube.sigs.k8s.io/docs/start/) or access to any other Kubernetes cluster.

1. [Sign up](https://account.kubemq.io/login/register) for a (free) account and get a license token.
2. Run kubectl apply -f [https://get.kubemq.io/deploy?token=](https://get.kubemq.io/deploy?token=)\<your-license-token>

You can verify the status of your cluster with kubectl get kubemqclusters -n kubemq. For more information, check out the [official docs](https://docs.kubemq.io/getting-started/quick-start).

## Summary

In this article, I reviewed the benefits of a message queue, looked at difficulties around implementing messaging in Kubernetes, and took a quick look at [KubeMQ](https://kubemq.io/) — a lightweight and Kubernetes-native solution that can provide several advantages over legacy solutions.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
