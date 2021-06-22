> * 原文地址：[Performance Differences Between Postgres and MySQL](https://dzone.com/articles/performance-differences-between-postgres-and-mysql)
> * 原文作者：Blessing Krofegha
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/performance-differences-between-postgres-and-mysql.md](https://github.com/xitu/gold-miner/blob/master/article/2021/performance-differences-between-postgres-and-mysql.md)
> * 译者：[灰灰 greycodee](https://github.com/greycodee)
> * 校对者：[1autodidact](https://github.com/1autodidact)、[kamly](https://github.com/kamly)

# Postgres 和 MySQL 之间的性能差异

## 简介

在 Arctype 社区里，我们回答了很多关于数据库性能的问题，尤其是 Postgres 和 MySQL 这两个之间的性能问题。在管理数据库中，性能是一项至关重要而又复杂的任务。它可能受到配置、硬件、或者是操作系统的影响。PostgreSQL 和 MySQL 是否具有稳定性和兼容性取决于我们的硬件基础架构。

并不是所有关系型数据库（RDBMS）都是一样的。 虽然 PostgreSQL 和 MySQL 有一些地方很相似，但是在不同的使用场景中，它们都有各自的性能优势。虽然在上篇[文章](https://blog.arctype.com/mysqlvspostgres)中我们已经讨论了一些它们之间的基本差异，但在性能上还有许多差异值得我们讨论。

在本文中，我们将讨论工作负载分析和运行的查询。然后，我们将进一步解释一些可以提高 MySQL 和 PostgreSQL 数据库的性能的基本配置。最后总结一下 MySQL 和 PostgreSQL 的一些关键区别。

### 目录

- 如何衡量性能
- 查询JSON的性能
- 索引开销
- 数据库复制和集群
- 并发
- 总结

## 如何衡量性能

MySQL 尽管在读写操作混合使用时并发性很差，但是因其优秀的读取速度而备受好评。PostgreSQL（俗称 Postgres）表示自己是最先进的开源关系数据库，并且已开发为符合标准且功能丰富的数据库。

以前，Postgres 的性能更加平衡，也就是说，读取通常比MySQL慢，但后来它得到了改进，现在可以更有效地写入大量数据，从而使并发处理更好。MySQL 和 Postgres 的最新版本略微消除了两个数据库之间的性能差异。

在 MySQL 中使用旧的 [MyISAM](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html) 引擎可以非常快速地读取数据。遗憾的是最新版本的 MySQL 并没有使用该引擎。但是，如果使用 InnoDB（允许键约束，事务），则差异可以忽略不计。InnoDB 中的功能对于企业或有很大用户量的应用程序至关重要，因此不能选择使用旧引擎。但是随着 MySQL 版本不断更新，这种差异越来越小。

**数据库基准测试**是一个用于表现和比较数据库系统或这些系统上的算法的性能（时间，内存或质量）的可再现的实验框架。 这种实用的框架定义了被测系统、工作量、指标和实验。

在接下来 4 节内容中，我们讨论一下每个数据库各自的性能优点。

## JSON 查询在 Postgres 中更快

在本节中，我们看下 PostgreSQL 和 MySQL 之间的基准测试的差异

### 执行步骤

1. 创建一个项目（Java、 Node、或者Ruby），并且该项目的数据库使用的是 PostgreSQL 和 MySQL。
2. 创建一个 JSON 对象，然后执行读取和写入操作。
3. 整个 JSON 对象的大小为约为 14 MB，在数据库中创建约 200 至 210 个条目。

#### 统计数据

**PostgreSQL：平均时间（毫秒）：写入：**2279.25、**读取：**31.65、**更新：**26.26

![https://dzone.com/storage/temp/14521891-1615593359984.png](https://dzone.com/storage/temp/14521891-1615593359984.png)

**MySQL：平均时间（毫秒）：写入：**3501.05、**读取：**49.99、**更新：**62.45

![https://dzone.com/storage/temp/14521893-1615593515968.png](https://dzone.com/storage/temp/14521893-1615593515968.png)

#### 结论

从上面的数据可以看出，PostgreSQL 在处理 JSON 时的性能要比 MySQL 更好，当然这也是 PostgreSQL 亮点之一。

我们可以对数据库进行频繁的操作（读取、写入、更新）来了解其性能，然后选出最好的来用到你的项目上。通过上面的测试数据结果我们可以知道，尽管 MySQL 的速度比 PostgreSQL 要快，但也只是在某些特定条件下。

## 索引

索引是所有数据库最重要的特性之一。数据库在查询数据时，有索引查询比没有索引查询快的多。但是，索引也会给数据库带来额外的开销，所有我们好刚要用在刀刃上，别瞎用。在没有索引的情况下，数据库在查找数据时会进行全文搜索（Full Text），也就是会从第一行开始一行一行的进行对比查找，这样的话数据量越多，查询的越慢。

PostgreSQL 和 MySQL 都有一些处理索引的特定的方法：

- **B-Tree索引：**PostgreSQL 支持 B-Tree 索引和 Hash 索引。同时 PostgreSQL 还支持以下特性：
- **表达式索引：**我们可以为表达式或函数来创建一个索引，而不是用字段。
- **局部索引：**索引只是表的一部分

假设 PostgreSQL 有一个 `user` 表，表的每一行代表一个用户。那么表可以这么定义：

```sql
CREATE TABLE users (
    id    SERIAL PRIMARY KEY,  
    email VARCHAR DEFAULT NULL,  
    name  VARCHAR
);
```

假设我们为该表创建如下索引：

![https://dzone.com/storage/temp/13693160-screen-shot-2020-07-01-at-113832-am.png](https://dzone.com/storage/temp/13693160-screen-shot-2020-07-01-at-113832-am.png)

上面两个索引有什么区别呢？ 索引 `#1` 是一个局部索引，索引 `#2` 是一个表达式索引。 正如 PostgreSQL 文档所描述的那样，

> “局部索引建立在由条件表达式定义的表中的行子集上（称为局部索引的谓词）。索引仅包含满足谓词的那些表行的条目。使用局部索引的主要原因是避免索引常见的值。由于查询通常会出现的值（占所有表行的百分之几以上的值）无论如何都会遍历大多数表，因此使用索引的好处是微不足道的。更好的策略是创建局部索引，其中这些行完全排除在外。局部索引减少了索引的大小，因此加快了使用索引的查询的速度。 这也将使许多写入操作速度更快，因为索引不需要在所有情况下都更新。” —— 摘自[ PostgreSQL 文档](https://www.postgresql.org/docs/12/indexes-partial.html)

**MySQL：** :MySQL 大部分索引（PRIMARY KEY、UNIQUE、INDEX、FULLTEXT）在使用时都是使用 B-Tree 数据结构。特殊情况下也会使用 R-Tree 的数据结构。 MySQL 也支持 Hash 索引，而且在 InnoDB 引擎下使用 FULLTEXT 索引时是倒序排列的。

## 数据库复制

PostgreSQL 和 MySQL 的另一个性能差异是**复制**。复制指的是将数据从一个数据库复制到另外一台服务器上的数据库。这种数据的分布意味着用户现在可以访问数据而不直接影响其他用户。数据库复制最大的困难之一是协调整个分布式系统中的数据一致性。MySQL 和 PostgreSQL 为数据库复制提供了几个选项。除了一个主服务器，一个备用数据库和多个备用数据库之外，PostgreSQL 和MySQL 还提供以下复制选项：

## 多版本并发控制（MVCC）

当用户同时对一个数据库进行读和写操作时，这种现象就叫并发现象。因此，多个客户端同时读取和写入会导致各种边缘情况/竞赛条件，即，对于相同的记录X和许多其他条件，先读取后写入。各种现代数据库都利用**事务**来减轻并发问题。

Postgres 是第一个推出多版本并发控制（MVCC）的 DBMS，这意味着读取永远不会阻止写入，反之亦然。此功能是企业偏爱 Postgres 而不是 MySQL 的主要原因之一

> "不同于大多数数据库使用锁来进行并发控制, Postgres通过使用多版本模型维护数据一致性。此外，在查询数据库时，无论基础数据的当前状态如何，每个事务都会像以前一样看到数据快照（数据库版本）。它可以防止事务查看同一数据行上的（其他）并发事务更新引起的不一致数据，从而为每个数据库会话提供事务隔离。" —— 摘自[ PostgreSQL 文档](https://www.postgresql.org/docs/7.1/mvcc.html)

MVCC 允许多个读取器和写入器同时与 Postgres 数据库进行交互，从而避免了每次有人与数据进行交互时都需要读写锁的情况。附带的好处是此过程可显着提高效率。**MySQL** 利用 InnoDB 存储引擎，支持对同一行的写入和读取而不会互相干扰。MySQL每次将数据写入一行时，也会将一个条目写入回滚段中。此数据结构存储用于将行恢复到其先前状态的**回滚日志**。之所以称为**回滚段**，因为它是用来处理回滚事务的工具。

> "InnoDB 是一个多版本存储引擎：它保留有关已更改行的旧版本的信息，以支持诸如并发和回滚之类的事务功能。此信息存储在表空间中的数据结构中，该数据结构称为回滚段（Oracle 中也有类似的结构）。InnoDB 使用回滚段中的信息来执行事务回滚中所需的撤消操作。它还使用该信息来构建行的早期版本以实现一致的读取。" —— 摘自[ MySQL 文档](https://dev.mysql.com/doc/refman/8.0/en/innodb-multi-versioning.html)

## 总结

在本文中，我们处理了PostgreSQL和MySQL之间的一些性能差异。虽然数据库性能会受硬件、操作系统类型等等的影响，但是最主要的是你对目标数据库的了解。PostgreSQL 和 MySQL 都有各自的有点和缺点，但是了解哪些功能适合某个项目并整合这些功能最终可以提高性能。

我很想听听你在数据库性能方面的经验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
