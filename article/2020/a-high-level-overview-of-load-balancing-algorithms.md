> * 原文地址：[A High-Level Overview of Load Balancing Algorithms](https://medium.com/better-programming/a-high-level-overview-of-load-balancing-algorithms-8c7d3368276)
> * 原文作者：[Aastikta Sharma](https://medium.com/@aastiktasharma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-high-level-overview-of-load-balancing-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-high-level-overview-of-load-balancing-algorithms.md)
> * 译者：[jackwener](https://github.com/jackwener)
> * 校对者：[lsvih](https://github.com/lsvih)，[zenblo](https://github.com/zenblo)

# 简述网络层与应用层的负载均衡算法

![Photo by [Martin Sanchez](https://unsplash.com/@martinsanchez?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*5Q1kzxdcs6WZv19y)

## 负载均衡的简介

**负载平衡**是将网络负载均匀分布在多个服务器上的过程。它有助于处理流量高峰时的任务统一分配及扩大需求。服务器可以存在于云数据中心或本地。它可以是物理服务器，也可以是虚拟服务器。负载均衡器（LB）的一些主要功能包括：

* 高效路由数据
* 防止服务器过载
* 检查服务器执行运行状况
* 在面对大流量时提供新的服务器实例

## 负载均衡算法分类

在 OSI 七层模型中，负载均衡主要应用在第 4 层（传输层）到第 7 层（应用层）。

![](https://cdn-images-1.medium.com/max/2808/1*A9uYwKDdWjmPVEPiKzSE0A.png)

根据流量的分布情况（譬如流量是网络层流量还是应用层流量），不同类型的负载均衡算法可以有效地分配网络流量。

* 负载均衡器根据TCP端口，IP底层路由网络层流量。
* 应用层流量根据各种其他属性（如 HTTP 头，SSL）进行路由，甚至为负载均衡器提供内容交换功能。

## 网络层算法

#### 1. 轮询算法（Round-robin algorithm）

流量负载被分配到第一个可用的服务器，然后该服务器推到队列底。如果服务器是相同的，并且没有持久的连接，这个算法可以证明是有效的。主要有两种类型的循环算法：

* **加权轮询算法：**如果服务器容量不一样，可以用此算法分配负载。分配权重或者效率参数给池中的服务器并基于这些参数，以类似的循环方式分配负载
* **动态轮询算法：**也可以在运行时计算分配给服务器以标识其容量的权重。动态轮询机制有助于根据运行时权重将请求发送到服务器

#### 2. 最少连接算法（Least-connections algorithm）

此算法计算特定时间内每个服务器的活动连接数，并将传入流量定向到连接最少的服务器。这在需要持久连接的情况下非常有用。

#### 3. 加权最小连接算法（Weighted least-connections algorithm）

这与上面的最少连接算法相似，但是除了考虑与服务器的活动连接数量外，它还考虑服务器容量。

#### 4. 最小响应时间算法（Least-response-time algorithm）

这也类似于最少连接算法，但是它也考虑了服务器的响应时间。该请求以最短的响应时间发送到服务器。

#### 5. 哈希算法（Hashing algorithm）

不同的请求参数决定请求将被发送到哪。基于此的不同类型的算法有：

* **源/目的地址哈希：**源和目标 IP 地址一起哈希，确定为请求提供服务的服务器。如果连接断开，可以在重试时将同一请求重定向到同一服务器。
* **URL 哈希：**哈希请求的 URL，此方法避免相同请求对象存储在许多缓存中，从而帮助减少服务器缓存的重复。

#### 6. 其他算法（Miscellaneous algorithms）

也有一些其他的算法，如下：

* **最小带宽算法：** 负载均衡器选择在过去 14 分钟内带宽消耗最少的服务器。
* **最少数据包算法：** 类似上面，负载均衡器选择传输数据包数量最少的服务器以重定向流量。
* **自定义负载算法：** 负载均衡器根据服务器上的当前负载来选择服务器，该负载可由内存，处理单元使用情况，响应时间，请求数等确定。

## 应用层算法

在这一层，可以根据请求的内容分配流量。因此，负载均衡器可以做出更明智的决定。由于它已经连接了所有从服务器来的路径，因此也可以跟踪服务器响应，这有助于更有效地确定服务器负载。

在此层使用的最重要的算法之一是**最少等待请求算法**。此算法将待处理的 HTTP 请求的流量定向到最可用的服务器。该算法有助于通过监视服务器负载来调整请求流量的突峰。

## 总结

这些是一些已知的负载均衡算法。在选择适用的算法时，需要考虑许多因素，例如，高流量或突然的峰值。好的算法选择有助于维持应用程序的可靠性和较高性能。因此，对这些内容有良好了解，将在设计大型分布式系统时很有帮助。。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
