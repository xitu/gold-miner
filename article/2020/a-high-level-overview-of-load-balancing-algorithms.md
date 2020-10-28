> * 原文地址：[A High-Level Overview of Load Balancing Algorithms](https://medium.com/better-programming/a-high-level-overview-of-load-balancing-algorithms-8c7d3368276)
> * 原文作者：[Aastikta Sharma](https://medium.com/@aastiktasharma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-high-level-overview-of-load-balancing-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-high-level-overview-of-load-balancing-algorithms.md)
> * 译者：
> * 校对者：

# A High-Level Overview of Load Balancing Algorithms

![Photo by [Martin Sanchez](https://unsplash.com/@martinsanchez?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*5Q1kzxdcs6WZv19y)

## Introduction

**Load balancing** is the process of evenly distributing your network load across several servers. It helps in scaling the demand during peak traffic hours by helping spread the work uniformly. The server can be present in a cloud or a data center or on-premises. It can be either a physical server or a virtual one. Some of the main functions of a load balancer (LB) are:

* Routes data efficiently
* Prevents server overloading
* Performs health checks for the servers
* Provisions new server instances in the face of large traffic

## Types of Load Balancing Algorithms

In the seven-layer OSI model, load balancing occurs from layers 4 (transport layer) to 7 (application layer).

![](https://cdn-images-1.medium.com/max/2808/1*A9uYwKDdWjmPVEPiKzSE0A.png)

The different types of LB algorithms are effective in distributing the network traffic based on how the distribution of traffic looks, i.e., whether it’s network layer traffic or application layer traffic.

* The network layer traffic is routed by LB based on TCP port, IP addresses, etc.
* The application layer traffic is routed based on various additional attributes like HTTP header, SSL, and it even provides content switching capabilities to LBs.

## Network Layer Algorithms

#### 1. Round-robin algorithm

The traffic load is distributed to the first available server, and then that server is pushed down into the queue. If the servers are identical and there are no persistent connections, this algorithm can prove effective. There are two major types of round-robin algorithms:

* **Weighted round-robin:** If the servers are not of identical capacity, then this algorithm can be used to distribute load. Some weights or efficiency parameters can be assigned to all the servers in a pool and based on that, in a similar cyclic fashion, load is distributed.
* **Dynamic round-robin:** The weights that are assigned to a server to identify its capacity can also be calculated on runtime. Dynamic round-robin helps in sending the requests to a server based on runtime weight.

#### 2. Least-connections algorithm

This algorithm calculates the number of active connections per server during a certain time and directs the incoming traffic to the server with the least connections. This is super helpful in the scenarios where a persistent connection is required.

#### 3. Weighted least-connections algorithm

This is similar to the least-connections algorithm above but apart from the number of active connections to a server, it also keeps in mind the server capacity.

#### 4. Least-response-time algorithm

This is again similar to the least-connections algorithm, but it also considers the response time of servers. The request is sent to the server with the least response time.

#### 5. Hashing algorithm

The different request parameters are used to determine where the request will be sent. The different types of algorithms based on this are:

* **Source/destination IP hash:** The source and destination IP addresses are hashed together to determine the server that will serve the request. In case of a dropped connection, the same request can be redirected to the same server upon retry.
* **URL hash:** The request URL is used for performing hashing, and this method helps in reducing duplication of server caches by avoiding storing the same request object in many caches.

#### 6. Miscellaneous algorithms

There are a few other algorithms as well, which are as follows:

* **Least-bandwidth algorithm:** The server with the least consumption of bandwidth in the last 14 minutes is selected by the load balancer.
* **Least-packets algorithm:** Similar to above, the server that is transmitting the least number of packets is chosen by the load balancer to redirect traffic.
* **Custom-load algorithm:** The load balancer selects the server based on the current load on it, which can be determined by memory, processing unit usage, response time, number of requests, etc.

## Application Layer Algorithms

At this layer, traffic can be distributed based on the contents of the request; hence, a much more informed decision can be made by LBs. The server response can be tracked as well since it has traveled all the way from the server, and this helps in determining the server load much more effectively.

One of the most significant algorithms used at this layer is the **least-pending-request algorithm**. This algorithm directs the traffic of pending HTTP(s) requests to the most available server. This algorithm is helpful in adjusting the sudden spike in requests by monitoring the server load.

## Conclusion

These are some of the known load balancing algorithms, and while selecting the most desirable algorithm, a number of factors need to be considered, e.g., high traffic or sudden spikes. A good selection of algorithm helps in maintaining the reliability and performance of any application. Hence, a good understanding of these will prove helpful when designing large-scale distributed systems.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
