> * 原文地址：[Using Redis on Cloud? Here are ten things you should know](https://itnext.io/using-redis-on-cloud-here-are-ten-things-you-should-know-a1026624441e)
> * 原文作者：[Abhishek Gupta](https://medium.com/@abhishek1987)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/using-redis-on-cloud-here-are-ten-things-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2022/using-redis-on-cloud-here-are-ten-things-you-should-know.md)
> * 译者：[timerring](https://github.com/timerring)
> * 校对者：[CompetitiveLin](https://github.com/CompetitiveLin)  [Quincy-Ye](https://github.com/Quincy-Ye)

# 在云端使用 Redis？你应该知道这十件事

![Photo by [Ian Battaglia](https://unsplash.com/@ianjbattaglia?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5936/0*lgkpH3OZWmszU6L4)

大规模操作有状态的分布式系统通常是很难的，Redis 也不例外。 尽管托管数据库通过承担大部分的繁杂工作使生活变得更加轻松。 但是你仍然需要一个完善的架构使它在服务器（Redis）和客户端（application）上得到最佳的应用实践。

本篇博客涵盖了一系列与 Redis 相关的最佳实践、提示和技巧，包括集群可扩展性、客户端配置、集成、指标等。虽然我在下文将时不时引用 Redis 的 [Amazon MemoryDB](https://docs.aws.amazon.com/memorydb/latest/devguide/what-is-memorydb-for-redis.html) 和 [ElastiCache](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html)，但是大部分（可能不是全部）通常适用于 Redis 集群。

> **这并不是一个详尽的清单。 我只是选择了 10 条，因为 10 是一个完美有益的数字！**

让我们深入了解一下从扩展 Redis 集群有哪些选择。

## 1. 可扩展性选项

你可以**放大**或者**缩小**：

* 纵向扩展 — 你可以增加单个节点/实例的容量，例如从 [Amazon EC2](https://aws.amazon.com/ec2/instance-types/) `db.r6g.xlarge` 类型升级到`db.r6g.2xlarge`
* 横向扩展 — 你可以向集群添加更多节点

**横向扩展**的需求可能是由几个原因驱动的。

如果你需要处理**读取繁重的**工作负载，你可以选择添加更多副本节点。 这适用于 Redis 集群设置（如`MemoryDB`）或非集群主副本模式，例如[禁用集群模式的 ElastiCache](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Replication.Redis-RedisCluster.html)。

如果你想增加 **写入** 的容量，你会发现自己受到主副本模式的限制，并且应该选择基于 Redis 集群的设置。 你可以增加集群中的分片数量 —— 这是因为只有主节点可以接受写入，并且每个分片只能有一个主节点。

> **这还具有增加整体的高可用性的好处。**

![**Figure 1: Redis (cluster mode disabled) and Redis (cluster mode enabled) clusters — ElastiCache for Redis documentation**](https://cdn-images-1.medium.com/max/2000/0*SINLUyOftL3ux0h-.png)

## 2. 扩展集群后，最好使用这些副本！

大多数 Redis 集群客户端（包括 `redis-cli`）默认将所有 **reads** 重定向到 **primary** 节点。 如果你已添加只读副本以扩展读取流量，它们将处于空闲状态！

为了确保处理所有读取请求的副本不只是被动参与者，你需要切换到 [READONLY](https://redis.io/commands/readonly/) 模式。 确保正确配置你的 Redis 客户端——这将因客户端和编程语言而异。

例如，在[Go Redis 客户端](https://github.com/go-redis/redis)中，可以将`ReadOnly`设置为`true`：

```
client := redis.NewClusterClient(
	&redis.ClusterOptions{
	     Addrs:     []string{clusterEndpoint},
	     ReadOnly:  true,
		//..other options
})
```

为了进一步优化，你还可以使用 `RouteByLatency` 或 `RouteRandomly`，它们都会自动开启 `ReadOnly` 模式。

> **你可以参考 [Java clients such as Lettuce](https://lettuce.io/core/release/reference/index.html#readfrom.read-from-settings)的工作原理**

## 3. 当使用只读副本时要注意一致性

你的应用程序有可能从副本中读取过时的数据——这就是**一致性**的作用。 由于主节点到副本节点的复制是**异步的**，因此你发送到主节点的写入可能还没有反映在只读副本中。 当你有大量只读副本，特别是当跨多个可用区时，很可能会出现这种情况。 如果这对于你的实例来说是不可接受的，那么你讲不得不求助于使用主节点进行读取。

MemoryDB 或 ElastiCache for Redis 中的 [ReplicationLag 指标](https://docs.aws.amazon.com/memorydb/latest/devguide/metrics.memorydb.html) 可用于副本的变化相对于主节点发生变化的延迟（以秒为单位）。

如果是强一致性呢？

在`MemoryDB`的情况下，[来自主节点的读取是高度一致的](https://docs.aws.amazon.com/memorydb/latest/devguide/consistency.html)。 这是因为客户端应用程序只有在一次写入（到主节点）被记录在**持久多可用区事务日志**后，才会收到成功的写入确认。

## 4. 请记住，你可以影响密钥在 Redis 集群中如何分布

Redis 没有使用一致性哈希（像许多其他分布式数据库一样），而是使用哈希槽的概念。 总共有 `16384` 个槽，为集群中的每个主节点分配一个哈希槽的范围，每个键属于一个特定的哈希槽（从而分配给特定的节点）。 如果键属于不同的哈希槽，那么在 Redis 集群上执行的多键操作将无法进行。

但是，你并非完全受集群的支配！ 还可以通过使用 **hash tags** 来影响键的位置。因此，你可以确保特定键具有相同的哈希槽。例如，如果你将客户 ID `42` 的订单存储在名为 `customer:42:orders` 的 `HASH` 中，并将客户资料信息存储在 `customer:42:profile` 中，则可以使用花括号 `{}` 定义将被散列的特定子字符串。 在这种情况下，我们的键是 `{customer:42}:orders` 和 `{customer:42}:profile` - `{customer:42}` ，它们驱动着哈希槽的放置。 现在我们可以确信这两个键都在**相同的**哈希槽中（因此是相同的节点）。

## 5. 是否考虑过缩减规模？

想象这样一个场景，你的应用很成功，有很多的用户和巨大流量。你扩展了集群并且所有事情进展都很顺利。 棒极了！

但是，如果你需要缩减规模怎么办？

在执行此操作之前，你需要注意一些事项：

* 每个节点上是否有足够的空闲内存？
* 可以在非高峰时段进行吗？
* 它将如何影响你的客户端应用程序？
* 在此阶段你可以监控哪些指标？ （例如`CPUUtilization`、`CurrConnections`等）

请参阅 [MemoryDb for Redis 文档中的最佳实践](https://docs.aws.amazon.com/memorydb/latest/devguide/best-practices-online-resharding.html) 以更好地规划扩展。

## 6. 当事情出错时......

面对现实吧，失败是不可避免的。 重要的是你是否已经为之做好准备？ 对于你的 Redis 集群，需要考虑以下几点：

* 你是否测试过你的应用程序/服务在遇到故障时的行为？ 如果没有，请一定要测试！ 使用 Redis 的MemoryDB和ElastiCache，你可以利用 [Failover API](https://docs.aws.amazon.com/memorydb/latest/devguide/autofailover.html#auto-failover-test) 模拟主节点故障并触发故障转移。
* 你有副本节点吗？ 如果你只有一个带有单个主节点的分片，而该节点发生故障，你肯定会停机。
* 你有多个分片吗？ 如果你只有一个分片（主分片和副本分片），则在该分片的主节点故障的情况下，集群将无法接受任何写入。
* 你的分片是否跨越多个可用区？ 如果你有跨多个 AZ 的分片，你将更好地应对 AZ 故障。

> **在所有情况下，`MemoryDB` 都将确保在节点替换或故障转移期间不会丢失数据**

## 7. 无法连接到 Redis，怎么办？

> **简单地说: 可能是网络/安全配置的问题**

这是一直困扰人们的事情！使用 `MemoryDB` 和 `ElastiCache`, 你的 [Redis 节点位于 VPC 中](https://docs.aws.amazon.com/memorydb/latest/devguide/vpcs.html). 如果你将客户端应用程序部署到例如 [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html), [EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html), [ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html), [App Runner](https://docs.aws.amazon.com/apprunner/latest/dg/what-is-apprunner.html) 等计算服务上, 你需要确保你拥有正确的配置 —— 特别是在 VPC 和安全组方面。

当然这可能因你使用的计算平台而异。例如, [配置 Lambda 函数以访问 VPC 中的资源](https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html) 与 App Runner（通过[VPC 连接器](https://docs.aws.amazon.com/apprunner/latest/dg/network-vpc.html)），或者 EKS（尽管从概念上讲，它们是相同的）的做法略有不同。

## 8. Redis 6 带有访问控制列表 —— 使用它!

要对 Redis 集群应用身份验证（用户名/密码）和授权（基于 ACL 的权限）。`MemoryDB` 符合 Redis 6 并且[支持 ACL](https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html)。 但是，为了符合旧的 Redis 版本，它为每个帐户配置一个 **default** 用户（使用默认用户名）和一个名为 `open-access` 的不可变 ACL。 如果你创建一个 `MemoryDB` 集群并将其与此 ACL 关联:

* 客户端可以连接**无需**身份验证
* 客户端可以对任何键执行**any** 命令（也没有权限或授权）

作为最佳实践：

* 定义显式 ACL
* 添加用户（连同密码）
* 根据你的安全要求配置访问字符串。

你应该监控身份验证失败。 例如，MemoryDB 中的 [AuthenticationFailures](https://docs.aws.amazon.com/memorydb/latest/devguide/metrics.memorydb.html) 指标为你提供失败的身份验证尝试总数 —— 可以设置警报来检测未经授权的访问尝试。

不要忘记周边安全。

如果你在服务器上配置了 `TLS`，别忘了在你的客户端也使用它！ 例如，使用 Go Redis：

```
client := redis.NewClusterClient(
	&redis.ClusterOptions{
		Addrs:     []string{clusterEndpoint},
		TLSConfig: &tls.Config{MaxVersion:      tls.VersionTLS12},
		//..other options
	})
```

> **你需要小心的是：不使用它可能会给你不明显的错误（例如，通用的 `i/o timeout`）并使bug难以调试解决。**

## 9. 你不能做的一些事情

作为托管数据库服务， `MemoryDB` 或 `ElastiCache` [限制对某些 Redis 命令的访问](https://docs.aws.amazon.com/memorydb/latest/devguide/restrictedcommands.html)。 例如，你**不能**使用 [CLUSTER](https://redis.io/commands/cluster/) 相关命令的子集，因为集群管理（规模、分片等）是由服务承担。

但是，在某些情况下，你可能会找到替代方案。 以监控运行缓慢的查询为例， 尽管你**不能**使用 [CONFIG SET](https://redis.io/commands/config-set/) 配置 `latency-monitor-threshold`，但可以在[参数组](https://docs.aws.amazon.com/memorydb/latest/devguide/components.html#whatis.components.parametergroups)中设置 `slowlog-log-slower-than`，然后使用`slowlog get`进行比较。

## 10. 使用连接池

你的 Redis 服务器节点（即使是功能强大的节点）只有有限的资源。 资源之一便是能够支持一定数量的并发连接。 大多数 Redis 客户端都提供连接池作为有效管理与 Redis 服务器的连接的一种方式。 重用连接不仅有益于你的 Redis 服务器，而且由于开销减少，客户端性能也得到了提高——这一点在大容量场景中至关重要。

ElastiCache 提供了你可以跟踪的[一些指标](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheMetrics.Redis.html) ：

* `CurrConnections`：客户端连接数（不包括来自只读副本的连接数）
* `NewConnections`：特定时间段内服务器接受的连接总数

## 11. (彩蛋) 使用合适的连接方式

这一点很明显，但我还是要说出来，因为这是我目睹人们犯的最常见的“入门”错误之一。

你在客户端应用程序中使用的连接模式取决于你是否使用独立的 Redis 设置、Redis 集群（很大可能）。 大多数 Redis 客户端对它们进行了明确的区分。 例如，如果你使用的是[Go Redis客户端](https://github.com/go-redis/redis)，启用了`MemoryDB`或`Elasticache`集群模式)，需要使用[NewClusterClient](https ://pkg.go.dev/github.com/go-redis/redis#NewClusterClient) (不是[NewClient](https://pkg.go.dev/github.com/go-redis/redis#NewClient)) ：

```
redis.NewClusterClient(&redis.ClusterOptions{//....})
```

> **有趣的是，[UniversalClient](https://pkg.go.dev/github.com/go-redis/redis#NewUniversalClient) 选项更灵活一些（截至本文撰写时，它在Go Redis v9中)**

如果你没有使用正确的连接模式，你会得到一个error。 但有时侯，根本原因会隐藏在错误消息后面——所以你需要格外小心。

---

## 总结

你做出的架构选择最终将由你的 [特定要求](https://docs.aws.amazon.com/memorydb/latest/devguide/cluster-create-determine-requirements.html) 驱动。 为了更深入地了解 MemoryDB 和 ElastiCache for Redis 的性能特征，以及它们如何影响你的解决方案设计方式，我鼓励你看以下博客文章：

* [优化 Amazon ElastiCache 和 MemoryDB 的 Redis 客户端性能](https://aws.amazon.com/blogs/database/optimize-redis-client-performance-for-amazon-elasticache/)
* [最佳实践：Redis 客户端和适用于 Redis 的 Amazon ElastiCache](https://aws.amazon.com/blogs/database/best-practices-redis-clients-and-amazon-elasticache-for-redis/)
* [测量 Amazon MemoryDB for Redis 的数据库性能](https://aws.amazon.com/blogs/database/measuring-database-performance-of-amazon-memorydb-for-redis/)

随意分享你的 Redis 提示、技巧和建议。 在那之前，祝大家探索愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
