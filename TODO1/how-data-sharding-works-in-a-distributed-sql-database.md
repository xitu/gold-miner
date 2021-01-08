> * 原文地址：[How Data Sharding Works in a Distributed SQL Database](https://blog.yugabyte.com/how-data-sharding-works-in-a-distributed-sql-database/)
> * 原文作者：[Sid Choudhury](https://blog.yugabyte.com/author/sidchoudhury/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-data-sharding-works-in-a-distributed-sql-database.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-data-sharding-works-in-a-distributed-sql-database.md)
> * 译者：[Ultrasteve](https://github.com/Ultrasteve)
> * 校对者：[JaneLdq](https://github.com/JaneLdq), [JackEggie](https://github.com/JackEggie)

# 数据分片是如何在分布式 SQL 数据库中起作用的

如今，所有规模的企业都在拥抱用户导向应用的高速现代化，以此作为它们更广阔的数字转型策略中的一部分。因此，这些应用所依赖的 RDBMS（关系型数据库基础设施），如今就需要支持更大的数据量和事务量。然而，在这种场景中，一个单体 RDBMS 通常很快会达到过载状态。数据分片是用于解决这种问题的其中一种最为普遍的架构，它能够使 RDBMS 得到更好的性能和更高的扩展性。在这篇文章中，我们会探讨什么是分片、如何使用分片来扩展数据库、以及几种常见分片架构的优劣。我们还会探索在分布式 SQL 数据库中，例如 [YugaByte DB](https://github.com/YugaByte/yugabyte-db) 是如何实现数据分片的。 

## 数据分片到底是什么？

分片是一种把大表切分成**数据分片**的过程，分割后的数据块会分布在多个服务器中。**数据分片**必须是水平切分的，各个分片是整个数据集的子集，它们各自负责总体工作量的一部分。这种方法的中心思想，便是将原本难以放在单体中的庞大数据，分散到一个**数据库集群**中。分片也称为**水平切分**，水平切分和垂直切分的区别来自于传统的表式数据库。一个数据库可以被垂直切分（把表中不同的列分散在数据库中），也可以被水平切分（把不同的行分散到多个数据库节点中）。

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/data-sharding-distributed-sql-1.png)

**图一：垂直切分与水平切分（来源：Medium）**

## 为什么要对数据库进行分片？

随着业务规模的扩大，依赖单体 RDBMS 的商业应用会达到性能瓶颈。受到 CPU 性能，辅存和主存的大小的限制，数据库的性能总有一天会遭殃。在一个未分片的数据库中，读操作的响应及日常运维的速度会变得极度缓慢。当我们想要为数据库操作提供更多运行资源时，垂直扩张（又称作扩容）存在一系列缺陷，最终会达到得不偿失的地步。

从另一方面来看，对表格进行水平切分意味着拥有更多的计算资源去应对查询请求，你会得到更短的响应时间并能够更快地创建索引。分片通过持续的平衡额外节点之间的数据量和工作量，能在扩张中更有效地利用新资源。不仅如此，维护一组更小更廉价的服务器比维护一个大型的服务器要实惠的多。

除了解决扩展性的问题，分片还可以应对潜在的意外宕机问题。当一个未分片的服务器宕机时，所有的数据都将变得不可访问，这将是一个灾难。然而分片能够很好的解决这个问题。即使一两个节点宕掉，还存在其他保留着剩下分片的节点，只要它们在不同的出错域，便仍然能够提供数据读写服务。总的来说，分片可以提升集群的存储容量，缩短处理时间，并在相对于垂直扩展消耗更少资金的情况下，提供更高的可用性。

## 手动分片的隐患

对于大数据量的应用来说，在包含一系列建表和负载均衡的分片中进行全自动化部署将会获得巨大收益。不幸的是，像 Oracle、PostgreSQL 和 MySQL 这些单体数据库，甚至一些更新的分布式 SQL 数据库，如 Amazon Aurora，并不支持自动分片。这意味着如果你想继续使用这些数据库，你必须在应用层进行手动分片。这大大增加了开发的难度。为了知道你的数据是如何分配的，你的应用需要一套额外的分片代码，并需要知道数据的来源。你还需要决定采用什么分片方法，最终需要多少分片，并需要多少个节点。一旦你的业务改变了，分片方式和分片主键也要随之变化。

手动分片的其中一个重大挑战便是不平均的分片。不成比例的分配数据将导致分片变得不平衡，这意味着当一些节点过载时其他节点可能是空闲的。因为部分节点的过载可能会拖累整体的响应速度并导致服务崩溃，我们要尽量避免在一个分片中存入过多的数据。这个问题也有可能在一个小的分片集中发生，因为小的分片集意味着将数据分散到极少数量的分片中。这虽然在开发环境和测试环境中是可以接受的，但生产环境中是不允许的。不平均的数据分配，部分节点过载和过少的数据分配都会导致分片和服务资源的枯竭。

最后，手动分片会使操作过程复杂化。现在需要在多个服务器中进行备份了。为了保证所有分片都有相同的结构，数据迁移和表结构的变化现在需要更小心的进行协调。在缺乏足够优化的情况下，在多个服务器中进行数据库 join 操作会变得不高效和难以执行。

## 常用的自动分片架构

分片由来已久，这么多年来发展了许多用于部署在大范围的系统中的分片架构和实现。在这一节中，我们会讨论三种最常见的实现方式。

### 基于哈希的分片

基于哈希的分片使用分片主键来产生一些哈希值，这些哈希值将被用于决定这一条数据存储在哪里。通过使用一个通用的哈希算法 ketama，哈希函数能够在服务器间平均的分摊数据，以此来减少部分节点的过载。在这种方法里，那些分片主键相近的数据不太可能会被分配在同一个分片中。这个架构因此十分适用于目标明确的数据操作。

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/data-sharding-distributed-sql-2.png)

**图二：基于哈希的分片（来源：MongoDB 文档）**

### 基于范围的分片

基于范围的分片，参照数据值的范围来分割数据。分片主键值相近的数据更容易落到同一个范围中，因此也更容易落到同一个分片中。每个分片都必须保存与原数据库相同的结构。数据分片将变得十分简单，正如辨别数据正确范围并放到相应的分片中一样容易。

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/Sharding-Image-copy.jpg)

**图三：基于范围的分片**

基于范围的分片能让读取连续范围内的数据，或范围查询变得更加高效。然而这种分片方式需要用户事先选择分片主键，如果分片主键选的不好，可能会导致部分节点过载。

一个好的原则就是选择那些基数更大重复率更低的键作为分片主键，这些键通常十分稳定，不会增加和减少，是无变化的。如果没有正确的选择分片主键，数据会不均等的分配在分片中，特定的数据会比其他数据的访问频率更高，这让那些工作量较大的分片产生瓶颈。

解决不均等分片的理想方法是进行归并和自动化分片。如果分片变得过大或者其中的某一行被频繁的访问，那么最好就将这个大的分片再进行更细的分片，并将这些小的分片重新平均的分配到各个节点中。同样的，当小分片过多的时候，我们可以做相反的事情。

### 基于地理位置的分片

在基于地理位置的分片中，数据会按照那些用户个性化的列（列中的值和地理位置有关）来进行分片，不同的分片被分配到对应的区域中。例如，有一个部署在美国，英国和欧洲的集群，我们可以根据用户表中的 Country_Code 这一列的值，并依照 GDPR（通用数据保护条例）来将分片放到合适的位置。

## YugaByte DB 中的分片

YugaByte DB 是一个具备自动分片功能和高度弹性的高性能分布式 SQL 数据库，它由 Google Spanner 开发。它目前默认支持基于哈希的分片方式。它是一个活跃更新的项目，而基于地理位置和基于范围的分片功能将在今年年尾加入。在 YugaByte DB 中每一个数据分片被称作子表（tablet），它们被分配在相应的子表服务器中。

### 基于哈希的分片

对于基于哈希的分片，表被分配在 0x0000 到 0xFFFF （总共 2B 的范围中）的哈希空间中，它在很大的数据集或集群中容纳了大约 64KB 的子表。我们来看看图四中有 16 个分片子表的表。这里用到整一个 2B 大小的哈希空间来容纳分片，并将它分成16个部分，每个部分对应一个子表。

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/data-sharding-distributed-sql-4.png)

**图四：在 YugaByte DB 基于哈希分片**

在读写操作中，主键是最先被转化成内键和它们对应的哈希值。这个操作通过收集可用子表中的数据来实现。（图五）

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/data-sharding-distributed-sql-5.png)

**图五：在 Yugabyte DB 决定使用哪个子表**

例如，如图六所示，你现在想在表中插入一个键 k，值为 v 的数据。首先会根据键的值 k 来计算出一个哈希值，之后数据库会查询对应的子表和子表服务器。最后，这个请求会被直接传到相应的服务器中进行处理。

![](https://3lr6t13cowm230cj0q42yphj-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/data-sharding-distributed-sql-6.png)

**图六：在 YugaByte DB 中存储 k 值**

### 基于范围的分片

SQL 表可以在主键的第一列中设置自动递增和自动递减。这让数据能够按照预先选择的顺序存储在单个分片（即子表）中。目前，项目组正在开发[动态分割子表](https://github.com/YugaByte/yugabyte-db/issues/1004)（基于多种标准，如范围边界和负载），和用于明确指明特定范围的[增强SQL语法](https://github.com/YugaByte/yugabyte-db/issues/1486)这些功能。

## 总结

数据分片是一种在商业应用中用于建设大型数据集和满足扩展性需求的解决方案。目前有许多数据分片架构供我们选择，每一种都提供了不同的功能。在决定用哪一种架构之前，我们需要清晰的列出你的项目需求和预期负载量。由于会显著的增加应用逻辑的复杂度，我们应该在绝大部分情况下尽量避免手动分片。[YugaByte DB](https://github.com/YugaByte/yugabyte-db) 是一种具备自动分片功能的分布式 SQL 数据库，它目前支持基于哈希的分片，而基于范围和基于地理位置的分片功能将很快能够用到。你可以查看这个[教程](https://docs.yugabyte.com/latest/explore/auto-sharding/)来学习 YugaByte DB 的自动分片功能。

## 下一步？

* [深入比较](https://docs.yugabyte.com/latest/comparisons/) YugaByte DB 和 [CockroachDB](https://www.yugabyte.com/yugabyte-db-vs-cockroachdb/)，Google Cloud Spanner 与 MongoDB 的不同之处。
* [开始](https://docs.yugabyte.com/latest/quick-start/)使用 YugaByte DB，在 macOS，Linux，Docker 和 Kubernetes 中使用它。
* [联系我们](https://www.yugabyte.com/about/contact/)了解证书及收费问题或预约一个技术面谈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。 
