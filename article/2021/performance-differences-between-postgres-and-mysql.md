> * 原文地址：[Performance Differences Between Postgres and MySQL](https://dzone.com/articles/performance-differences-between-postgres-and-mysql)
> * 原文作者：Blessing Krofegha
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/performance-differences-between-postgres-and-mysql.md](https://github.com/xitu/gold-miner/blob/master/article/2021/performance-differences-between-postgres-and-mysql.md)
> * 译者：[灰灰 greycodee](https://github.com/greycodee)
> * 校对者：

# Postgres 和 MySQL 之间的性能差异

## 简介

在 Arctype 社区里，我们回答了很多关于数据库性能的问题，尤其是 Postgres 和 MySQL 这两个之间的性能问题。在管理数据库中，性能是一项至关重要而又复杂的任务。它可能受到配置、硬件、或者是操作系统的影响。PostgreSQL 和 MySQL 是否具有稳定性和兼容性取决于我们的硬件基础架构。

并不是所有关系型数据库（RDBMS）都是一样的。 虽然 PostgreSQL 和 MySQL 有一些地方很相似，但是在不同的使用场景中，它们都有各自的性能优势。虽然在上篇[文章](https://blog.arctype.com/mysqlvspostgres)中我们已经讨论了一些它们之间的基本差异，但在性能上还有许多差异值得我们讨论。

在本文中，我们先来看看它们的查询性能。然后，我们再讲一些可以提高 MySQL 和 PostgreSQL 数据库的性能的基本配置。最后总结一下 MySQL 和 PostgreSQL 的一些关键区别。

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

**PostgreSQL: Avg time (in ms): WRITE:** 2279.25 | **READ:** 31.65 | **UPDATE**: 26.26

![https://dzone.com/storage/temp/14521891-1615593359984.png](https://dzone.com/storage/temp/14521891-1615593359984.png)

**MySQL: Avg time (in ms): WRITE:** 3501.05 | **READ:** 49.99 | **UPDATE** : 62.45

![https://dzone.com/storage/temp/14521893-1615593515968.png](https://dzone.com/storage/temp/14521893-1615593515968.png)

#### Conclusion

If we look at the numbers, it reflects that PostgreSQL is way better than MySQL if it’s a matter of dealing with JSON data type which is, of course, one of the key features of having PostgreSQL.

The frequent type of operation(READ, WRITE, UPDATE) performed in a database determines which database suits your personal or professional project. The definite conclusion from these metrics is that out of the box, while MySQL is architected to run faster than PostgreSQL, sometimes benchmarks are particular to the application.

## Indexes

The index is a critical factor in all databases. It enhances database performance, as it allows the database servers to find and retrieve specific rows much faster than without an index. But, indexes add a particular overhead to the database system as a whole, so they should be used sensibly. Without an index, the database server would begin with the first row and then read through the entire table to find the relevant rows: the larger the table, the more costly the operation. Both PostgreSQL and MySQL have specific ways of handling indexes.

- **Standard B Tree Indexes:** PostgreSQL includes built-in support for regular B-tree and hash indexes. Indexes in PostgreSQL also support the following features:
- **Expression indexes:** can be created with an index of the result of an expression or function instead of a column's value.
- **Partial indexes:** index only a part of a table.

Let us assume we have a table in PostgreSQL named users, where each row in the table represents a user. The table is defined as follows.`CREATE TABLE users (  id    SERIAL PRIMARY KEY,  email VARCHAR DEFAULT NULL,  name  VARCHAR);`Now, let us assume we create the following indexes on the table above.

![https://dzone.com/storage/temp/13693160-screen-shot-2020-07-01-at-113832-am.png](https://dzone.com/storage/temp/13693160-screen-shot-2020-07-01-at-113832-am.png)

What is the difference between the two indexes shown above? The first index #1 is a partial index while index #2 is an expression index. As the PostgreSQL docs states,

> “A partial index is built over a subset of rows in a table defined by a conditional expression (called the predicate of the partial index). The index contains entries only for those table rows that satisfy the predicate. A major reason for using a partial index is to avoid indexing commonly occurring values. Since a query searching for a commonly occurring value (one that accounts for more than a few percent of all the table rows) will run through most of the table anyway, the benefit from using an index is marginal. A better strategy is to create a partial index where such rows exclude altogether. Partial indexing reduces the index's size and hence speeds up those queries that do use the index. It will also speed up many write operations because the index does not need to update in all cases” - Documentation on Partial Indexes - Postgres Docs.

**MySQL:** Most MySQL indexes (PRIMARY KEY, UNIQUE, INDEX, and FULLTEXT) are in B-trees. Exceptions include the indexes on spatial data types that use R-trees. MySQL also supports hash indexes, and the InnoDB engine uses inverted lists for FULLTEXT indexes.

## Database Replication

Another performance difference, as it concerns both PostgreSQL and MySQL, is **replication**. Replication is the ability to copy data from one database server to another database on a different server. This distribution of information means that users can now access data without directly affecting other users. One of the difficult tasks of database replication is harmonizing data consistency across a distributed system. MySQL and PostgreSQL offer several possible options for database replication. Apart from one master to one standby and multiple standbys, PostgreSQL and MySQL offer the following replication options:

## Multi-Version Concurrency Control

When users read and write to a database simultaneously, that phenomenon is known as concurrency. So, multiple clients reading and writing at the same time can lead to various edge cases/race conditions, i.e., read followed by write happened for same record X and numerous other conditions. Various modern databases make use of ***transactions*** to mitigate problems in concurrency.

Postgres was the first DBMS to rollout multi-version concurrency control (MVCC), which means reading never blocks writing and vice versa. This feature is one of the main reasons why businesses prefer Postgres to MySQL.

> "Unlike most other database systems, which use locks for concurrency control, Postgres maintains data consistency by using a multi-version model. Furthermore, while querying a database, each transaction sees a snapshot of data (a database version) as it was some time ago, regardless of the underlying data's current state. It protects the transaction from viewing inconsistent data caused by (other) concurrent transaction updates on the same data rows, providing transaction isolation for each database session." Multi-Version Concurrency Control" — PostgreSQL Documentation

MVCC lets multiple readers and writers concurrently interact with the Postgres database, eliminating the need for a read-write lock every time someone interacts with the data. A side benefit is this process provides a significant efficiency boost. **MySQL** utilizing the InnoDB storage engine, MySQL supports writes and reads of the same row to not interfere with each other. Every time MySQL writes data into a row, it *also* writes an entry into the rollback segment. This data structure stores “undo logs” used to restore the row to its previous state. It’s called the “rollback segment” because it is the tool used to handle rolling back transactions.

> "InnoDB is a multi-versioned storage engine: it keeps the information about old versions of changed rows to support transactional features such as concurrency and rollback. This information is stored in the tablespace in a data structure called a rollback segment (after an analogous data structure in Oracle). InnoDB uses the information in the rollback segment to perform the undo operations needed in a transaction rollback. It also uses the information to build earlier versions of a row for a consistent read." - InnoDB Multi-Versioning — MySQL MVCC

## Conclusion

We have treated a few performance differences between PostgreSQL and MySQL in this post. It’s important to note that database performance relies on several other factors such as Hardware, type of OS, and most importantly, your understanding of the intended database. Both PostgreSQL and MySQL have unique qualities and drawbacks, but understanding what features would suit a project and integrating those features would ultimately result in performance.

I’d love to hear about your experience with database performance.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。