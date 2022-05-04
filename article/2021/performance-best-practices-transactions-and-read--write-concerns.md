> * 原文地址：[Performance Best Practices: Transactions and Read / Write Concerns](https://www.mongodb.com/blog/post/performance-best-practices-transactions-and-read--write-concerns)
> * 原文作者：[Mat Keep](https://www.mongodb.com/blog/search/Mat%20Keep)、[Henrik Ingo](https://www.mongodb.com/blog/search/Henrik%20Ingo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/performance-best-practices-transactions-and-read--write-concerns.md](https://github.com/xitu/gold-miner/blob/master/article/2021/performance-best-practices-transactions-and-read--write-concerns.md)
> * 译者：[Miigon](https://github.com/Miigon)
> * 校对者：[Kimberly](https://github.com/kimberlyohq)

# MongoDB 高性能最佳实践：事务，读取关心程度与写入关心程度

本文为介绍 MongoDB 最佳性能实践的系列推文的第 5 篇。

本系列文章中，我们将多维度地介绍在大数据量场景下实现高性能的关键考虑因素，包括：

* [数据建模与内存分配（工作集）](https://www.mongodb.com/blog/post/performance-best-practices-mongodb-data-modeling-and-memory-sizing)
* [请求模式与性能分析](https://www.mongodb.com/blog/post/performance-best-practices-query-patterns-and-profiling)
* [索引](https://www.mongodb.com/blog/post/performance-best-practices-indexing)
* [数据库分片](https://www.mongodb.com/blog/post/performance-best-practices-sharding)
* 事务，读取关心程度与写入关心程度（本文的主题）
* 硬件与操作系统配置
* 基准测试

## 单文档原子性

在分表式的数据库设计中，相互关联的数据需要被抽象为分散在多个独立的父-子表中。但在 MongoDB 里，由于文档的存在，这样的数据可以被聚集在一起存储。MongoDB 的单文档操作提供了原子性语义，满足了大多数应用程序的需求。

一个操作可以修改一个或多个字段，包括更新多个子文档或数组元素。MongoDB 保证单个文档更新时的完全隔离；任何错误都会使得整个操作回滚，因此保证用户得到的文档数据总是具有一致性。

## 多文档 ACID 事务的到来

从 4.0 版本开始，MongoDB 就加入了对[多文档 ACID 事务](https://www.mongodb.com/transactions) 的支持，使开发者利用 MongoDB 实现各种场景下的需求变得更简单。在 4.0 版本之后，事务的作用域限制为一个副本集内。在随后的 4.2 版本，多文档事务的支持被拓宽到整个分片集群。

MongoDB 的事务功能和关系型数据库的事务功能十分相似 —— 多语句、熟悉的语法、便于集成到任何程序。通过快照隔离，事务功能确保了数据一致性，提供“要么全成功要么全失败”的执行模式，并且对不涉及事务功能的其他操作的性能没有影响。

你可以查看我们发布在 [VLDB 会议论文](https://webassets.mongodb.com/MongoDB_TPCC_VLDB.pdf)上的基准测试结果获取有关事务性能的更多信息。

接下来我们将讨论如何在你的项目中更好地使用事务。

## 多文档事务的最佳实践

创建长耗时的事务，或者在单个 ACID 事务中进行大量操作，会加大 WiredTiger 存储引擎的缓存压力。这是因为自快照创建开始，所有的写操作都需要由缓存来保存和管理状态。由于一个事务在运行中自始至终使用同一份快照，事务途中对集合进行的写操作将在缓存中堆积。只有在事务提交或终止且相关的锁被释放后，这些写操作才能被写入数据库。

为了维持稳定可预测的数据库性能，开发者需要注意以下几点：

### 事务运行时限

在默认的情况下，MongoDB 会自动终止运行超过 60 秒的多文档事务。若服务器写入量较弱，它会灵活调整事务的运行时间。

为解决事务超时问题，过大的事务应该被切分为多个能够在配置的运行时限内执行完毕的小事务。同时为了降低查询语句耗时，你应该确保已经使用合适的索引覆盖来对查询语句进行优化。

### 事务中的操作数量

一个事务中能够读取的文档数量没有硬性限制。但作为一种最佳实践，单个事务一般不应该修改超过 1000 个文档。

若存在需要修改超过 1000 个文档的操作，开发者应该将事务切分为多个事务分配处理这些文档。

### 分布式的跨分片事务

涉及多个数据库分片的事务产生的性能开销更大，因为跨分片的操作需要多个节点通过网络协同进行。

`snapshot` 读取关心等级是在跨分片情景下唯一能够提供一致的数据快照的隔离等级。当低延迟比跨分片读取一致性更加重要时，应使用默认的 `local` 读取关心等级，该等级在一份单机的快照中执行事务。

### 异常处理

当一个事务终止时，一个异常会被返回给调用者，并且事务会被完全回滚。开发者需要实现异常捕捉以及并针对临时性异常（如 MVCC 写冲突、暂时性网络错误或发生主副本选举）进行重试的逻辑。

借助 [可重试写入](https://docs.mongodb.com/manual/core/retryable-writes/index.html) 机制，MongoDB 调用者会对事务的提交指令进行自动重试。

### 对写入延迟的益处

虽然第一眼可能没那么显而易见，但使用多文档事务，由于降低了提交延迟，实际上提高了写入性能。

使用 w:majority 的写入关心等级，假设分开执行 10 条更新指令，则每一条指令都需要等待一个分片间复制的往返时长。

然而，如果同样的 10 条更新指令运行在同一个事务里，它们将在事务提交的时候被一次性复制，从而将延迟降低 10 倍！

### 我还需要知道什么？

你可以在 [MongoDB 多文档事务参考文档](https://docs.mongodb.com/master/core/transactions/)处学习所有最佳实践。请查阅该文档中的“生产环境注意事项”一栏了解性能相关的指引。

## 选择合适的写入保证等级

MongoDB 允许你在向数据库提交写入请求时指定一个可靠性保证等级，称为[“写入关心等级”](https://docs.mongodb.com/manual/reference/write-concern/)

注意到，写入关心等级可以对任何对服务器进行的操作生效，无论该操作是对单个文档的一般操作还是包含在一个多文档事务中的一部分。

以下选项能够在“每次连接”、“每个数据库”、“每个集合”、甚至“每个操作”的水平上设置。总共有这些选项：

* __写入确认 (Write Acknowledged)：__ 这是默认的写入关心等级。`mongod` 会保证写操作的执行，使得客户可以捕捉到网络异常、key 重复异常、schema 验证异常等异常类型。
* __日志确认 (Journal Acknowledged)：__ `mongod` 只有在写操作已经被写入主节点的日志后才会确认写入操作成功。该等级确保写操作能够存活一次 `mongod` 崩溃，并且确保写操作被写入硬盘。
* __副本确认 (Replica Acknowledged)：__ 使用本选项能够确保等待副本集中的其他成员已经发送写入确认后才视为写入操作成功。MongoDB 支持写入到指定数量的副本中。本选项同时确保写入数据被写入二级数据库的日志中。由于副本可以被部署在数据中心的不同机架甚至不同数据中心，确保写入的数据扩增到额外的副本可以提供极高的可靠性。
* __多数确认 (Majority)：__ 本写关心等级将等待写操作被应用到副本集中多数的可承载数据且可选举的成员上，因此在遇到主副本选举事件时，写操作将会无法成功执行。这个等级同时确保了写操作能够被记录在各个副本的日志里 —— 包括主副本的。

## 选择合适的读取关心程度

就像写入关心程度一样，读取关心程度也可以被应用于任何对数据库发起的请求，无论是对单个文档的读取，还是作为多文档事务的一部分。

为保证隔离度与一致性，[`readConcern`](https://docs.mongodb.com/manual/reference/readConcern/) 可以被设置为 `majority` (多数确认) ，该等级代表仅当数据已经被覆盖到副本集中的多数节点，也就是数据不会因为新主节点选举而被回滚时，才能被返回到应用程序。

MongoDB 支持一个`linearizable`（可线性化）的读取关心等级。可线性化的读取关心等级确保一个节点在读取的时候仍然是副本集的主节点，并且即使后来另外一个节点被选举为新的主节点，其已经返回的数据也保证不会被回滚。使用该读取关心等级可能会对延迟造成显著影响，故需要提供一个 [maxTimeMS](https://docs.mongodb.com/manual/reference/method/cursor.maxTimeMS/) 值来让运行时间过长的操作超时。

### 仅在必要时使用因果一致性

[因果一致性 (causal consistency)](https://docs.mongodb.com/manual/core/read-isolation-consistency-recency/#causal-consistency) 保证客户端会话内的所有读操作都能看到上一次写操作的结果，不管当前请求是由哪一个副本在提供服务。仅当在需要单调读保证（monotonic read guarantees）的地方使用因果一致性，能够降低延迟的影响。

## 下一篇

这就是本期的高性能最佳实践。本系列的下一篇：硬件与操作系统配置。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
