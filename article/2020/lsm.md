> * 原文地址：[Understanding LSM Trees: What Powers Write-Heavy Databases](https://yetanotherdevblog.com/lsm/)
> * 原文作者：[Braden Groom](https://yetanotherdevblog.com/author/author/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/lsm.md](https://github.com/xitu/gold-miner/blob/master/article/2020/lsm.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[chzh9311](https://github.com/chzh9311), [Eminlin](https://github.com/Eminlin)

# 理解 LSM 树：一种适用于频繁写入的数据库的结构

LSM 树是一种数据结构，它通常用于处理大量数据写入的业务。数据写入路径是由顺序写入来优化的。LSM 树是 [BigTable](https://cloud.google.com/bigtable), [Cassandra](https://cassandra.apache.org/), [Scylla](https://www.scylladb.com/), and [RocksDB](https://rocksdb.org/) 等众多数据库系统背后的核心数据结构。

# SSTables

LSM 树使用 **Sorted Strings Table (SSTable)** 格式持久化于磁盘中。顾名思义，SSTable 是一种存储 key-value 对的格式，其中 key 是经过排序的。一个 SSTable 是由若干已排序的文件组成的，这些文件称为 **segments**。这些 segments 一经写入磁盘，就处于不可变状态。我们来看一个简单的例子：

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--3-.png)

你可以看到，每个 segment 中的 key-value 对都是按 key 排序的。我们将在下一节讨论究竟什么是 segment 以及它是如何创建的。

# 数据更新

我们来回顾下，LSM 树只能处理顺序写入。您可能不知道如何在写入值是无序的情况下顺序写入数据。这个问题可以使用内存中的树结构来解决。它通常被称为 **内存表**，从本质上来看，它是一种经排序的树，类似于[红黑树](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree)。当进行数据更新时，会存入这个红黑树。

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--4-.png)

我们写入的数据存在红黑树中，直到树的大小达到某个预设的值为止。此时红黑树有了足够的数据元素，它就作为一个有序的片段转移到磁盘上。因此，我们就能以单次顺序写入的方式更新这个片段，即使插入的数据是无序的也可以实现。

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--5-.png)

# 数据读取

那么我们如何在 SSTable 中查找一个值？逐个扫描所有的 segment 显然太天真了。如果这样做，我们需要从最新的 segment 开始，逐个往回查找，直到找到目标值为止。这意味着我们需要以更快的速度找到最近写入的数据。有一种简单的优化办法，就是在内存中维护一个[稀疏索引](https://yetanotherdevblog.com/dense-vs-sparse-index/)。

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--6-.png)

我们使用这样的索引，可以快速得到需要的 key 前后的值的偏移量。现在只需要对每个 segment 中符合边界条件的一小部分进行扫描。例如，我们需要在上图所示的 segment 中查找名为 `dollar` 的 key。我们可以在稀疏索引中进行二分搜索，结果发现 `dollar` 位于 `dog` 与 `downgrade` 之间。此时我们只需要在偏移量为 17208 与 19504 之间的数据进行扫描，就能找到需要的值。

这种优化方法很好，但如果查找不存在的记录会怎样呢？如果沿袭上述办法，我们仍然需要遍历所有的 segment 文件，才能得到查找目标不存在的结果。在此情况下，就需要使用[布隆过滤器](https://yetanotherdevblog.com/bloom-filters/)了。布隆过滤器是一种空间效率较高的数据结构，它用于检测数据中某个值素是否存在。在写入数据的同时，我们可以把记录添加到布隆过滤器；在开始读取时，布隆过滤器就会进行检查，从而高效处理对不存在的数据的请求。

# 数据压缩

系统在运行过程中，会累积越来越多的 segment 文件。为了防止 segment 文件数量逐渐庞大直至失控，应当对这些 segment 文件进行清理和维护。压缩进程就是负责这些工作的。它是一个后台进程，会持续地把旧 segment 跟新 segment 进行结合。

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--7-.png)

在上图所示的例子中，你可以看到，1 号 segment 与 2 号 segment 中， `dog` 键都有对应的值。新的 segment 包含最新写入的值，所以 2 号 segment 中的值是传入 4 号 segment 中的值。当压缩进程把加入的数据写入一个新的 segment 时，旧 segment 文件就被删除了。

# 数据删除

我们已经讨论了数据的读取和更新，那数据的删除呢？既然 segment 文件是不可变的，那如何把它从 SSTable 中删除呢？实际上，删除跟写入的过程是一样的。无论何时，只要收到删除请求，需要删除的那个 key 就打上了具有唯一标识的 **tombstone** 标记。

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--8-.png)

上述例子说明，名为 `dog` 的 key 原来对应的值是 52，现在打上了 tombstone 标记。这说明如果收到一个获取 key 为 `dog` 的数据的请求，我们应当得到的响应是数据不存在。这说明，删除请求起初占用的磁盘空间很大，很多开发者可能对此感到吃惊。但最终，打上 tombstone 标记的数据被压缩了，因此相关的值就永远消失了。

# 结论

我们现在知道了一个基本 LSM 树的存储引擎是如何工作的：

1. 写入的数据存储在内存中的树结构中（也可以称为内存表）。任何支持的数据结构（布隆过滤器和稀疏索引）都会在必要时更新。
2. 当树结构太大时，会以一个有序的片段的形式转移到磁盘上。
3. 读取数据时，我们先检查布隆过滤器。如果布隆过滤器找不到相应的值，就告诉客户端相应的 key 不存在。如果布隆过滤器找到了相应的值，我们就开始按照从新到旧的顺序遍历 segment 文件。
4. 对于每个 segment 文件，我们需要检查稀疏索引并在估计能查找到需要的 key 的位置扫描偏移量，直到我们找到了目标 key 为止。一经找到，就可以返回相应的值。 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
