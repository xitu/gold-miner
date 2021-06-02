> * 原文地址：[Performance Best Practices: Transactions and Read / Write Concerns](https://www.mongodb.com/blog/post/performance-best-practices-transactions-and-read--write-concerns)
> * 原文作者：[Mat Keep](https://www.mongodb.com/blog/search/Mat%20Keep)、[Henrik Ingo](https://www.mongodb.com/blog/search/Henrik%20Ingo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/.md](https://github.com/xitu/gold-miner/blob/master/article/2021/.md)
> * 译者：
> * 校对者：

# Performance Best Practices: Transactions and Read / Write Concerns

Welcome to the fifth in a series of blog posts covering performance best practices for MongoDB.

In this series, we are covering key considerations for achieving performance at scale across a number of important dimensions, including:

* [Data modeling and sizing memory](https://www.mongodb.com/blog/post/performance-best-practices-mongodb-data-modeling-and-memory-sizing) (the working set)
* [Query patterns and profiling](https://www.mongodb.com/blog/post/performance-best-practices-query-patterns-and-profiling)
* [Indexing](https://www.mongodb.com/blog/post/performance-best-practices-indexing)
* [Sharding](https://www.mongodb.com/blog/post/performance-best-practices-sharding)
* Transactions and read/write concerns, which we’ll cover today
* Hardware and OS configuration
* Benchmarking

## Single Document Atomicity

Because documents can bring together related data that would otherwise be modeled across separate parent-child tables in a tabular schema, MongoDB’s single-document operations provide atomic semantics that meets the data integrity needs of the majority of applications.

One or more fields may be written in a single operation, including updates to multiple subdocuments and elements of an array. The guarantees provided by MongoDB ensure complete isolation as a document is updated; any errors cause the operation to roll back so that clients receive a consistent view of the document.

## The Arrival of Multi-Document ACID Transactions

Starting with MongoDB 4.0, support was added for [multi-document ACID transactions](https://www.mongodb.com/transactions), making it even easier for developers to address a complete range of use cases with MongoDB. In 4.0, transactions were scoped to a replica set, and with the later 4.2 release, support was extended to sharded clusters.

MongoDB’s transactions feel just like the transactions developers are familiar with from relational databases – multi-statement, a similar syntax, and easy to add to any application. Through snapshot isolation, transactions provide a consistent view of data, enforce all-or-nothing execution, and do not impact performance for workloads that do not require them.

You can review the performance of transactions by reviewing the TPC-C benchmarking results published in our [VLDB conference paper](https://webassets.mongodb.com/MongoDB_TPCC_VLDB.pdf).

Here are some tips to make best use of transactions in your applications.

## Best Practices for Multi-Document Transactions

Creating long-running transactions, or attempting to perform an excessive number of operations in a single ACID transaction can result in high pressure on the WiredTiger storage engine cache. This is because the cache must maintain state for all subsequent writes since the oldest snapshot was created. As a transaction always uses the same snapshot while it is running, new writes accumulate in the cache throughout the duration of the transaction. These writes cannot be flushed until transactions currently running on old snapshots commit or abort, at which time the transactions release their locks and WiredTiger can evict the snapshot.

To maintain predictable levels of database performance, developers should, therefore, consider the following.

### Transaction runtime limit

By default, MongoDB will automatically abort any multi-document transaction that runs for more than 60 seconds. Note that if write volumes to the server are low, you have the flexibility to tune your transactions for a longer execution time.

To address timeouts, the transaction should be broken into smaller parts that allow execution within the configured time limit. You should also ensure your query patterns are properly optimized with the appropriate index coverage to allow fast data access within the transaction.

### Number of operations in a transaction

There are no hard limits to the number of documents that can be read within a transaction. As a best practice, no more than 1,000 documents should be modified within a transaction.

For operations that need to modify more than 1,000 documents, developers should break the transaction into separate parts that process documents in batches.

### Distributed, multi-shard transactions

Transactions that affect multiple shards incur a greater performance cost as operations are coordinated across multiple participating nodes over the network.

Snapshot read concern is the only isolation level that provides a consistent snapshot of your data across multiple shards. If latency is more critical than cross-shard read consistency, use the default local read concern which operates on a local version of the snapshot.

### Exception Handling

When a transaction aborts, an exception is returned to the driver and the transaction is fully rolled back. Developers should add application logic that can catch and retry a transaction that aborts due to temporary exceptions, such as an MVCC write conflict, a transient network failure or a primary replica election.

With [retryable writes](https://docs.mongodb.com/manual/core/retryable-writes/index.html), the MongoDB drivers will automatically retry the commit statement of the transaction.

### Benefit for write latency

While it might not seem obvious at first, using multi-document transactions can improve write performance by way of reducing the commit latency.

With the w:majority write concern if you execute 10 updates independently, each write has to wait for a replication round trip.

However, if the same 10 updates are executed inside a transaction, they are all replicated together at commit time. This reduces latency by 10 times!

### What else do I need to know?

You can review all best practices in the [MongoDB documentation for multi-document transactions](https://docs.mongodb.com/master/core/transactions/). Refer to the Production Considerations section of this documentation for performance-specific guidance.

## Choose the Appropriate Write Guarantees

MongoDB allows you to specify the level of durability guarantee when issuing writes to the database, which is called the [write concern](https://docs.mongodb.com/manual/reference/write-concern/).

Note that write concerns can apply to any operation that is executed against the database, irrespective of whether it is a regular operation against a single document, or wrapped in a multi-document transaction.

The following options can be configured on a per-connection, per database, per collection, or even per operation basis. The options are as follows:

* **Write Acknowledged**: This is the default write concern. The `mongod` will confirm the execution of the write operation, allowing the client to catch network, duplicate key, schema validation, and other exceptions.
* **Journal Acknowledged**: The `mongod` will confirm the write operation only after it has flushed the operation to the journal on the primary. This confirms that the write operation can survive a `mongod` crash and ensures that the write operation is durable on disk.
* **Replica Acknowledged**: It is also possible to wait for acknowledgment of writes to other replica set members. MongoDB supports writing to a specific number of replicas. This also ensures that the write is written to the journal on the secondaries. Because replicas can be deployed across racks within data centers and across multiple data centers, ensuring writes propagate to additional replicas can provide extremely robust durability.
* **Majority**: This write concern waits for the write to be applied to a majority of replica set data-bearing and electable members, and therefore cannot be rolled in the event of a primary election. This also ensures that the write is recorded in the journal on these replicas – including on the primary.

## Choose the Right Read Concern

Like write concerns, read concerns can apply to any query that is executed against the database, irrespective of whether it is a regular read against a single or set of documents, or wrapped in a multi-document read transaction.

To ensure isolation and consistency, the [`readConcern`](https://docs.mongodb.com/manual/reference/readConcern/) can be set to `majority` to indicate that data should only be returned to the application if it has first been replicated to a majority of the nodes in the replica set, and so cannot be rolled back in the event of the election of a new primary node.

MongoDB supports a readConcern level of “Linearizable”. The linearizable read concern ensures that a node is still the primary member of the replica set at the time of the read and that the data it returns will not be rolled back if another node is subsequently elected as the new primary member. Configuring this read concern level can have a significant impact on latency, therefore a [maxTimeMS](https://docs.mongodb.com/manual/reference/method/cursor.maxTimeMS/) value should be supplied in order to timeout long-running operations.

### Use causal consistency where needed

[Causal consistency](https://docs.mongodb.com/manual/core/read-isolation-consistency-recency/#causal-consistency) guarantees that every read operation within a client session will always see the previous write operation, regardless of which replica is serving the request. You can minimize any latency impact by using causal consistency only where you need monotonic read guarantees.

## What’s Next

That wraps up this installment of the performance best practices series. Next up in this series: hardware and OS configuration.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
