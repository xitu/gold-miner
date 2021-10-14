> * 原文地址：[High-speed inserts with MySQL](https://medium.com/@benmorel/high-speed-inserts-with-mysql-9d3dcd76f723)
> * 原文作者：[Benjamin Morel](https://medium.com/@benmorel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/high-speed-inserts-with-mysql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/high-speed-inserts-with-mysql.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[GJXAIOU](https://github.com/GJXAIOU)、[QinRoc](https://github.com/QinRoc)

# MySQL 最佳实践 —— 高效插入数据

![Get the dolphin up to speed — Photo by [JIMMY ZHANG](https://blog-private.oss-cn-shanghai.aliyuncs.com/20200402002543.jpeg) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6528/1*9Ihf50zErzTg4KR4JnodzA.jpeg)

当你需要在 MySQL 数据库中批量插入数百万条数据时，你就会意识到，逐条发送 `INSERT` 语句并不是一个可行的方法。

MySQL 文档中有些值得一读的 [INSERT 优化技巧](https://dev.mysql.com/doc/refman/5.7/en/insert-optimization.html)。

在这篇文章里，我将概述高效加载数据到 MySQL 数据库的两大技术。

## LOAD DATA INFILE

如果你正在寻找提高原始性能的方案，这无疑是你的首选方案。`LOAD DATA INFILE` 是一个专门为 MySQL 高度优化的语句，它直接将数据从 CSV / TSV 文件插入到表中。

有两种方法可以使用 `LOAD DATA INFILE`。你可以把数据文件拷贝到服务端数据目录（通常 `/var/lib/mysql-files/`），并且运行：

```sql
LOAD DATA INFILE '/path/to/products.csv' INTO TABLE products;
```

这个方法相当麻烦，因为你需要访问服务器的文件系统，为数据文件设置合适的权限等。

好消息是，你也能将数据文件存储**在客户端**，并且使用 `LOCAL` 关键词：

```sql
LOAD DATA LOCAL INFILE '/path/to/products.csv' INTO TABLE products;
```

在这种情况下，从客户端文件系统中读取文件，将其透明地拷贝到服务端临时目录，然后从该目录导入。总而言之，**这几乎与直接从服务器文件系统加载文件一样快**，不过，你需要确保服务器启用了此 [选项](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_local_infile)。

`LOAD DATA INFILE` 有很多可选项，主要与数据文件的结构有关（字段分隔符、附件等）。请浏览 [文档](https://dev.mysql.com/doc/refman/5.7/en/load-data.html) 以查看全部内容。

虽然从性能角度考虑， `LOAD DATA INFILE` 是最佳选项，但是这种方式需要你先将数据以逗号分隔的形式导出到文本文件中。如果你没有这样的文件，你就需要花费额外的资源来创建它们，并且可能会在一定程度上增加应用程序的复杂性。幸运的是，还有一种另外的选择。

## 扩展的插入语句（Extended inserts）

一个典型的 `INSERT` SQL 语句是这样的：

```sql
INSERT INTO user (id, name) VALUES (1, 'Ben');
```

extended `INSERT` 将多条插入记录聚合到一个查询语句中：

```sql
INSERT INTO user (id, name) VALUES (1, 'Ben'), (2, 'Bob');
```

关键在于找到每条语句中要插入的记录的最佳数量。没有一个放之四海而皆准的数字，因此，你需要对数据样本做基准测试，以找到性能收益的最大值，或者在内存使用和性能方面找到最佳折衷。

为了充分利用 extended insert，我们还建议：

* 使用预处理语句
* 在事务中运行该语句

## 基准测试

我要插入 120 万条记录，每条记录由 6 个 混合类型数据组成，平均每条数据约 26 个字节大小。我使用了两种常见的配置进行测试：

* 客户端和服务端在同一机器上，通过 UNIX 套接字进行通信
* 客户端和服务端在不同的机器上，通过延迟非常低（小于 0.1 毫秒）的千兆网络进行通信

作为比较的基础，我使用 `INSERT ... SELECT` 复制了该表，这个操作的性能表现为**每秒插入 313,000 条数据**。

#### LOAD DATA INFILE

令我吃惊的是，测试结果证明 `LOAD DATA INFILE` 比拷贝表**更快**：

* `LOAD DATA INFILE`：每秒 **377,000** 次插入
* `LOAD DATA LOCAL INFILE` 通过网络：每秒 **322,000** 次插入

这两个数字的差异似乎与从客户端到服务端传输数据的耗时有直接的关系：数据文件的大小为 53 MB，两个基准测试的时间差了 543 ms，这表示传输速度为 780 mbps，接近千兆速度。

这意味着，很有可能，**在完全传输文件之前，MySQL 服务器并没有开始处理该文件**：因此，插入的速度与客户端和服务端之间的带宽直接相关，如果它们不在同一台机器上，考虑这一点则非常重要。

#### Extended inserts

我使用 `BulkInserter` 来测试插入的速度，`BulkInserter` 是我编写的 [开源库](https://github.com/brick/db) PHP 类的一部分，每个查询最多插入 10,000 条记录：

![](http://blog-private.oss-cn-shanghai.aliyuncs.com/20200402002600.png)

正如我们所看到的，随着每条查询插入数的增长，插入速度也会迅速提高。与逐条`插入`速度相比，我们在本地主机上性能提升了 6 倍，在网络主机上性能提升了 17 倍：

* 在本地主机上每秒插入数量从 40,000 提升至 247,000
* 在网络主机上每秒插入数量从 1,2000 提升至 201,000

这两种情况都需要每个查询大约 1,000 个插入来达到最大吞吐量。但是**每条查询 40 个插入就足以在本地主机上达到 90% 的吞吐量**，这可能是一个很好的折衷。还需要注意的是，达到峰值之后，随着每个查询插入数量的增加，性能实际上是会下降。

extended insert 的优势在网络连接的情况下更加明显，因为连续插入的速度取决于你的网络延迟。

```sql
max sequential inserts per second ~= 1000 / ping in milliseconds
```

客户端和服务端之间的延迟越高，你从 extended insert 中获益越多。

## 结论

不出所料，**`LOAD DATA INFILE` 是在单个连接上提升性能的首选方案**。它要求你准备格式正确的文件，如果你必须先生成这个文件，并/或将其传输到数据库服务器，那么在测试插入速度时一定要把这个过程的时间消耗考虑进去。

另一方面，extended insert 不需要临时的文本文件，并且可以达到相当于 `LOAD DATA INFILE` 65% 的吞吐量，这是非常合理的插入速度。有意思的是，无论是基于网络还是本地主机，**聚集多条插入到单个查询总是能得到更好的性能**。

如果你决定开始使用 extended insert，一定要先**用生产环境的数据样本**和一些不同的插入数来**测试你的环境**，以找出最佳的数值。。

在增加单个查询的插入数的时候要小心，因此它可能需要：

* 在客户端分配更多的内存
* 增加 MySQL 服务器的 [max_allowed_packet](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_allowed_packet) 参数配置。

最后，值得一提的是，根据 Percona 的说法，你可以使用并发连接、分区以及多个缓冲池，以获得更好的性能。更多信息请查看 [他们博客的这篇文章](http://www.percona.com/blog/2011/01/07/high-rate-insertion-with-mysql-and-innodb/)。

**基准测试运行在装有 Centos 7 和 MySQL 5.7 的裸服务器上，它的主要硬件配置有 Xeon E3 @3.8 GHz 处理器，32 GB RAM 和 NVMe SSD。MySQL 的基准表使用 InnoBD 存储引擎。**

**基准测试的源代码保存在 [gist](https://gist.github.com/BenMorel/78f742356391d41c91d1d733f47dcb13) 上，结果图保存在 [plot.ly](https://plot.ly/~BenMorel/52) 上。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
