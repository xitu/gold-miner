> * 原文地址：[Algorithms Behind Modern Storage Systems](https://queue.acm.org/detail.cfm?id=3220266)
> * 原文作者：[acmqueue](https://queue.acm.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/algorithms-behind-modern-storage-systems.md](https://github.com/xitu/gold-miner/blob/master/TODO1/algorithms-behind-modern-storage-systems.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：

# 支撑现代存储系统的算法

## 读优化 B-Tree 和写优化 LSM-Tree 的不同用途

### Alex Petrov

应用程序处理的数据量不断增长。因此，扩展存储变得愈发具有挑战性。每个数据库系统都有自己的方案。为了做出正确的选择，了解它们是至关重要的。

每个应用程序在读写负载平衡、一致性、延迟和访问模式方面各不相同。熟悉数据库和底层存储有助于架构决策；有助于解释系统行为；有助于解决问题；有助于根据具体情况调优。

十全十美的优化系统是不可能的。我们当然希望有一个数据结构既能保证最佳的读写性能，又不需要任何存储开销，但显然，这是不存在的。

本文深入讨论了大多数现代数据库中使用的两种存储系统设计 —— 读优化 [B-Tree](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.96.6637&rep=rep1&type=pdf) <sup><a href="#note1">[1]</a></sup> 和写优化 [LSM（结构化日志合并）-Tree](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.2782&rep=rep1&type=pdf) <sup><a href="#note5">[5]</a></sup> —— 并描述了它们的用例和优缺权衡。

### B-Tree

B-Tree 是一种流行的读优化索引数据结构，是二叉树的泛化。它有许多变种，并且被用于多种数据库（包括 [MySQL InnoDB](https://dev.mysql.com/doc/refman/5.7/en/innodb-physical-structure.html) <sup><a href="#note1">[4]</a></sup>、[PostgreSQL](http://www.interdb.jp/pg/pgsql01.html) <sup><a href="#note1">[7]</a></sup>）甚至[文件系统](https://en.wikipedia.org/wiki/HTree)（HFS+ <sup><a href="#note1">[8]</a></sup>、HTrees ext4 <sup><a href="#note1">[9]</a></sup>）。B-Tree 中的 _B_ 代表原始数据结构的作者 _Bayer_，或是他当时就职的公司 _Boeing_。

在[搜索二叉树](https://en.wikipedia.org/wiki/Binary_tree)中，每个节点都有两个孩子（称为左右孩子）。左子树的节点值小于当前节点值，右子树反之。为了保持树的深度最小，搜索二叉树必须是平衡的：当随机顺序的值被添加到树中时，如果不加调整，终会导致树的倾斜。

一种平衡二叉树的方法是所谓的旋转：重新排列节点，将较深子树的父节点向下推到其子节点下方，并将该子节点拉上来，将其放在原父节点的位置。图 1 是平衡二叉树中的旋转示例。在左侧添加节点 2 后，二叉树失去平衡。为了使该树平衡，将其以节点 3 为轴旋转（树围绕它旋转）。然后节点 5（旋转前是根节点和节点 3 的父节点）成为其子节点。旋转完成后，左侧子树的深度减少 1，右侧子树的深度增加 1。树的最大深度已经减小。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/18/C6yZiF.png)

二叉树是最有用的内存数据结构。然而由于平衡（保持所有子树的深度最小）和低出度（每个节点最多两个子节点），它们在磁盘上水土不服。B-Tree 允许每个节点存储两个以上的指针，并通过将节点大小与页面大小（例如，4 KB）进行匹配来与块设备协同工作。今天的一些实现将使用更大的节点大小，跨越多个页面。

B-Tree 有以下几个性质：

• 有序。这允许顺序扫描并简化查找。

• 自平衡。在插入和删除时不需要平衡树：当 B-Tree 节点已满时，它被分成两部分，并且当相邻节点的利用率低于某个阈值时，合并这两个节点。这也意味着各叶子节点与根节点的距离相等，并且在查找过程中定位的步数是相同的。

• 对数级查找时间复杂度。查找时间是非常重要的，这使得 B-Tree 成为数据库索引的理想选择。

• 易变。插入、更新、删除（包括因此导致的拆分和合并）过程在磁盘上进行。为了使就地更新成为可能，需要一定的空间开销。B-Tree 可以作为聚集索引，实际数据存储在叶子节点上，也可以作为非聚集索引，称为一个堆文件。

本文讨论的 B+Tree <sup><a href="#note3">[3]</a></sup> 是一种经常用于数据库存储的 B-Tree 现代变种。B+Tree 与原始 B-Tree <sup><a href="#note1">[1]</a></sup> 的不同之处在于：(1)它采用额外链接的叶节点存储值；(2)值不能存储在内部节点上。

#### 剖析 B-Tree

我们先来仔细看看 B-Tree 的结构，如图 2 所示。B-Tree 的节点有几种类型：根节点，内部节点和叶子节点。根节点（顶部）是没有双亲的节点（即，它不是任何节点的子节点）。内部节点（中间）有双亲和孩子节点；他们将根节点和叶子节点连接起来。叶子节点（底部）持有数据并且没有孩子节点。图 2 描绘了分支因子为 4（4 个指针，内部节点中有 3 个键，叶上有 4 个键/值对）的 B-Tree。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/18/C6qgs0.png)

B-Tree 的特性如下：

• 分支因子 —— 指向子节点的指针数(_N_)。除指针外，根节点和内部节点还持有 N-1 个键。

• 利用率 —— 节点当前持有的指向子节点的指针数量与可用最大值之比。例如，若某树分支因子是 _N_，且其中某节点当前持有 _N/2_ 个指针，则该节点利用率为 50%。

• 高度 —— B-Tree 的数量级，表示在查找过程中必须经过多少指针。

树中的每个非叶节点最多可持有 _N_ 个键（索引条目），这些键将树分为 _N+1_ 个子树，这些子树可以通过相应的指针定位。项 _K<sub>i</sub>_ 中的指针 _i_ 指向某子树，该子树中包含所有 _K<sub>i-1</sub> <= K<sub>目标</sub> < K<sub>i</sub>_（其中 _K_ 是一组键）的索引项。首尾指针是特殊的，它们指向的子树中所有的项都小于等于最左子节点的 _K<sub>0</sub>_ 或大于最右子节点的 _K<sub>N-1</sub>_。叶子节点同时持有其同级前后节点的指针，形成兄弟节点间的双向链表。所有节点中的键总是有序的。

#### 查找

进行查找时，将从根节点开始搜索，并经过内部节点递归向下到叶子节点层。在每层中，通过指向子节点的指针将搜索范围缩小到某子树（包含搜索目标值的子树）。图 3 展示了 B-Tree 的一次从根到叶的搜索过程，指针在两个键之间，其中一个大于（或等于）搜索目标，另一个小于搜索目标。进行点查询时，搜索将在定位到叶子节点后完成。进行范围扫描时，遍历所找到的叶子节点的键和值，然后遍历范围内的兄弟叶子节点。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/19/Cc6dRe.png)

在复杂度方面，B-Tree 保证查询的时间复杂度为 _log(n)_，因为查找一个节点中的键使用二分查找，如图 4 所示。二进制搜索可以通俗的解释为在字典中查找以某字母开头的单词，字典中所有单词都按字母顺序排序。首先你翻开正好在字典中间的一页。如果要查找的单词字母顺序小于（在前面）当前页，你继续在字典的左半边查找；否则就继续在右半边查找。你继续像这样将剩余的页码范围分为一半，选择一边，直到找到期望的字母。每一步都将搜索范围减半，因此查找的时间复杂度为对数级。 B-Tree 节点上的键是有序的，且使用二分查找算法进行匹配，因此 B-Tree 的搜索复杂度是对数级的。这也说明了保持树的高利用率和统一访问的重要性。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/19/CcRZy4.png)

#### 插入、更新、删除

进行插入时，第一步是定位目标叶子节点。此过程使用前序搜索算法。在定位目标页面后，键和值将被添加至该节点。如果该节点没有足够的可用空间，这种情况称为溢出，则将叶子节点分割成两部分。这是通过分配一个新的叶子节点，将一半元素移动到新节点并将一个指向这个新节点的指针添加到父节点来完成的。如果父节点没有足够的空间，则也会在父节点上进行分割。操作一直持续到根节点为止。当根节点溢出时，其内容在新分配的节点之间被分割，根节点本身被覆盖以避免重定位。这也意味着树（及其高度）总是通过分裂根节点而增长。

### LSM-Tree

The log-structured merge-tree is an immutable disk-resident write-optimized data structure. It is most useful in systems where writes are more frequent than lookups that retrieve the records. LSM-trees have been getting more attention because they can eliminate random insertions, updates, and deletions.

#### 剖析 LSM-Tree

To allow sequential writes, LSM-trees batch writes and updates in a memory-resident table (often implemented using a data structure allowing logarithmic time lookups, such as a [binary search tree](https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree) or [skip list](https://en.wikipedia.org/wiki/Skip_list)) until its size reaches a threshold, at which point it is written on disk (this operation is called a _flush_). Retrieving the data requires searching all disk-resident parts of the tree, checking the in-memory table, and merging their contents before returning the result. Figure 5 shows the structure of an LSM-tree: a memory-resident table used for writes. Whenever the memory table is large enough, its sorted contents are written on disk. Reads are served, hitting both disk- and memory-resident tables, requiring a merge process to reconcile the data.

![支撑现代存储系统的算法](http://deliveryimages.acm.org/10.1145/3230000/3220266/petrov5.png)

#### Sorted String Tables

Many modern LSM-tree implementations (such as [RocksDB](https://en.wikipedia.org/wiki/RocksDB) and [Apache Cassandra](https://en.wikipedia.org/wiki/Apache_Cassandra)) implement disk-resident tables as SSTables (Sorted String Tables), because of their simplicity (easy to write, search, and read) and merge properties (during the merge, source SSTable scans and merged result writes are sequential).

An SSTable is a disk-resident ordered immutable data structure. Structurally, an SSTable is split into two parts: data and index blocks, as shown in figure 6. A data blocks consists of sequentially written unique key/value pairs, ordered by key. An index block contains keys mapped to data-block pointers, pointing to where the actual record is located. An index is often implemented using a format optimized for quick searches, such as a B-tree, or using a hash table for a point-query. Every value item in an SSTable has a timestamp associated with it. This specifies the write time for inserts and updates (which are often indistinguishable) and removal time for deletes.

![支撑现代存储系统的算法](http://deliveryimages.acm.org/10.1145/3230000/3220266/petrov6.png)

SSTables have some nice properties:

• Point-queries (i.e., finding a value by key) can be done quickly by looking up the primary index.

• Scans (i.e., iterating over all key/value pairs in a specified key range) can be done efficiently simply by reading key/value pairs sequentially from the data block.

An SSTable represents a snapshot of all database operations over a period of time, as the SSTable is created by the _flush_ process from the memory-resident table that served as a buffer for operations against the database state for this period.

#### Lookups

Retrieving data requires searching all SSTables on disk, checking the memory-resident tables, and merging their contents before returning the result. The merge step during the read is required since the searched data can reside in multiple SSTables.

The merge step is also necessary to ensure that the deletes and updates work. Deletes in an LSM-tree insert placeholders (often called _tombstones_), specifying which key was marked for deletion. Similarly, an update is just a record with a later timestamp. During the read, the records that get shadowed by deletes are skipped and not returned to the client. A similar thing happens with the updates: out of two records with the same key, only the one with the later timestamp is returned. Figure 7 shows a merge step reconciling the data stored in separate tables for the same key: as shown here, the record for Alex was written with timestamp 100 and updated with a new phone and timestamp 200; the record for John was deleted. The other two entries are taken as is, as they're not shadowed.

![支撑现代存储系统的算法](http://deliveryimages.acm.org/10.1145/3230000/3220266/petrov7.png)

To reduce the number of searched SSTables and to avoid checking every SSTable for the searched key, many storage systems employ a data structure known as a [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter)<sup>10</sup>. This is a probabilistic data structure that can be used to test whether an element is a member of the set. It can produce false-positive matches (i.e., state that the element is a member of set, while it is not, in fact, present there) but cannot produce false negatives (i.e., if a negative match is returned, the element is guaranteed not to be a member of the set). In other words, a Bloom filter is used to tell if the key “might be in an SSTable” or “is definitely not in an SSTable.” SSTables for which a Bloom filter has returned a negative match are skipped during the query.

#### LSM-tree maintenance

Since SSTables are _immutable_, they are written sequentially and hold no reserved empty space for in-place modifications. This means insert, update, or delete operations would require rewriting the whole file. All operations modifying the database state are “batched” in the memory-resident table. Over time, the number of disk-resident tables will grow (data for the same key located in several files, multiple versions of the same record, redundant records that got shadowed by deletes), and the reads will continue getting more expensive.

To reduce the cost of reads, reconcile space occupied by shadowed records, and reduce the number of disk-resident tables, LSM-trees require a _compaction_ process that reads complete SSTables from disk and merges them. Because SSTables are sorted by key and compaction works like merge-sort, this operation is very efficient: records are read from several sources sequentially, and merged output can be appended to the results file right away, also sequentially. One of the advantages of merge-sort is that it can work efficiently even for merging large files that don't fit in memory. The resulting table preserves the order of the original SSTables.

During this process, merged SSTables are discarded and replaced with their “compacted” versions, as shown in figure 8. Compaction takes multiple SSTables and merges them into one. Some database systems logically group the tables of the same size to the same “level” and start the merge process whenever enough tables are on a particular level. After compaction, the number of SSTables that have to be addressed is reduced, making queries more efficient.

![支撑现代存储系统的算法](http://deliveryimages.acm.org/10.1145/3230000/3220266/petrov8.png)

### Atomicity and Durability

To reduce the number of I/O operations and make them sequential, both B-trees and LSM-trees batch operations in memory before making an actual update. This means that data integrity is not guaranteed during failure scenarios and _atomicity_ (applying a series of changes atomically, as if they were a single operation, or not applying them at all) and _durability_ (ensuring that in the face of a process crash or power loss, data has reached persistent storage) properties are not ensured.

To solve that problem, most modern storage systems employ WAL (write-ahead logging). The key idea behind WAL is that all the database state modifications are first durably persisted in the append-only log on disk. If the process crashes in the middle of an operation, the log is replayed, ensuring that no data is lost and all changes appear atomically.

In B-trees, using WAL can be understood as writing changes to data files only after they have been logged. Usually log sizes for B-tree storage systems are relatively small: as soon as changes are applied to the persisted storage, they can be discarded. WAL serves as a backup for the in-flight operations: any changes that were not applied to data pages can be redone from the log records.

In LSM-trees, WAL is used to persist changes that have reached the memtables but have not yet been fully flushed on disk. As soon as a memtable is fully flushed and switched so that read operations can be served from the newly created SSTable, the WAL segment holding the data for the flushed memtable can be discarded.

### Summarizing

One of the biggest differences between the B-tree and LSM-tree data structures is what they optimize for and what implications these optimizations have.

Let's compare the properties of B-trees with LSM-trees. In summary, B-trees have the following properties:

• They are mutable, which allows for in-place updates by introducing some space overhead and a more involved write path, although it does not require complete file rewrites or multisource merges.

• They are read-optimized, meaning they do not require reading from (and subsequently merging) multiple sources, thus simplifying the read path.

• Writes might trigger a cascade of node splits, making some write operations more expensive.

• They are optimized for paged environments (block storage), where byte addressing is not possible.

• Fragmentation, caused by frequent updates, might require additional maintenance and block rewrites. B-trees, however, usually require less maintenance than LSM-tree storage.

• Concurrent access requires reader/writer isolation and involves chains of locks and latches.

LSM-trees have these properties:

• They are immutable. SSTables are written on disk once and never updated. Compaction is used to reconcile space occupied by removed items and merge same-key data from multiple data files. Merged SSTables are discarded and removed after a successful merge as part of the compaction process. Another useful property coming from immutability is that flushed tables can be accessed concurrently.

• They are write optimized, meaning that writes are buffered and flushed on disk sequentially, potentially allowing for spatial locality on the disk.

• Reads might require accessing data from multiple sources, since data for the same key, written during different times, might land in different data files. Records have to go through the merge process before being returned to the client.

• Maintenance/compaction is required, as buffered writes are flushed on disk.

### Evaluating Storage Systems

Developing storage systems always presents the same challenges and factors to consider. Deciding what to optimize for has a substantial influence on the result. You can spend more time during write in order to lay out structures for more efficient reads, reserve extra space for in-place updates, facilitate faster writes, and buffer data in memory to ensure sequential write operations. It is impossible, however, to do this all at once. An ideal storage system would have the lowest read cost, lowest write cost, and no overhead. In practice, data structures compromise among multiple factors. Understanding these compromises is important.

Researchers from Harvard's DASlab (Data System Laboratory) summarized the three key parameters database systems are optimized for: read overhead, update overhead, and memory overhead, or RUM. Understanding which of these parameters are most important for your use-case influences the choice of data structures, access methods, and even suitability for certain workloads, as the algorithms are tailored having a specific use-case in mind.

The [RUM Conjecture](http://daslab.seas.harvard.edu/rum-conjecture/)<sup>2</sup> states that setting an upper bound for two of the mentioned overheads also sets a lower bound for the third one. For example, B-trees are read-optimized at the cost of write overhead as well as having to reserve empty space for the (thereby resulting in memory overhead). LSM-trees have less space overhead at a cost of read overhead brought on by having to access multiple disk-resident tables during the read. These three parameters form a competing triangle, and improvement on one side may imply compromise on the other. Figure 9 illustrates the RUM Conjecture.

![支撑现代存储系统的算法](http://deliveryimages.acm.org/10.1145/3230000/3220266/petrov9.png)

B-trees optimize for read performance: the index is laid out in a way that minimizes the disk accesses required to traverse the tree. Only a single index file has to be accessed to locate the data. This is achieved by keeping this index file mutable, which also increases write amplification resulting from node splits and merges, relocation, and fragmentation/imbalance-related maintenance. To amortize update costs and reduce the number of splits, B-trees reserve extra free space in nodes on all levels. This helps to postpone write amplification until the node is full. In short, B-trees trade update and memory overhead for better read performance.

LSM-trees optimize for write performance. Neither updates nor deletes require locating data on disk (which B-trees do), and they guarantee sequential writes by buffering all insert, update, and delete operations in memory-resident tables. This comes at the price of higher maintenance costs and a need for compaction (which is just a way of mitigating the ever-growing price of reads and reducing the number of disk-resident tables) and more expensive reads (as the data has to be read from multiple sources and merged). At the same time, LSM-trees eliminate memory overhead by not reserving any empty space (unlike B-tree nodes, which have an average occupancy of 70 percent, an overhead required for in-place updates) and allowing block compression because of the better occupancy and immutability of the end file. In short, LSM-trees trade read performance and maintenance for better write performance and lower memory overhead.

There are data structures that optimize for each desired property. Using adaptive data structures allows for better read performance at the price of higher maintenance costs. Adding metadata facilitating traversals (such as [fractional cascading](https://en.wikipedia.org/wiki/Fractional_cascading)) will have an impact on write time and take space, but can improve the read time. Optimizing for memory efficiency using compression (for example, algorithms such as [Gorilla compression](http://www.vldb.org/pvldb/vol8/p1816-teller.pdf),<sup>6</sup> [delta encoding](https://en.wikipedia.org/wiki/Delta_encoding), and many others) will add some overhead for packing the data on writes and unpacking it on reads. Sometimes, you can trade functionality for efficiency. For example, [heap files and hash indexes](https://en.wikipedia.org/wiki/Database_storage_structures) can provide great performance guarantees and smaller space overhead because of the file format simplicity, for the price of not being able to perform anything but point queries. You can also trade precision for space and efficiency by using approximate data structures, such as the Bloom filter, [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog), [Count-Min sketch](https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch), and many others.

The three tunables—read, update, and memory overheads—can help you evaluate the database and gain a deeper understanding of the workloads for which it is best suited. All of them are quite intuitive, and it's often easy to sort the storage system into one of the buckets and guess how it's going to perform, then validate your hypothesis through extensive testing.

Of course, there are other important factors to consider when evaluating a storage system, such as maintenance overhead, operational simplicity, system requirements, suitability for frequent updates and deletes, access patterns, and so on. The RUM Conjecture is just a rule of thumb that helps to develop an intuition and provide an initial direction. Understanding your workload is the first step on the way to building a scalable back end.

Some factors may vary from implementation to implementation, and even two databases that use similar storage-design principles may end up performing differently. Databases are complex systems with many moving parts and are an important and integral part of many applications. This information will help you peek under the hood of a database and, knowing the difference between the underlying data structures and their inner doings, decide what's best for you.

#### 参考文献

<a name="note1"></a>1. Comer, D. 1979. The ubiquitous B-tree. _Computing Surveys_ 11(2); 121-137; [http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.96.6637](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.96.6637&rep=rep1&type=pdf).

<a name="note2"></a>2. Data Systems Laboratory at Harvard. The RUM Conjecture; [http://daslab.seas.harvard.edu/rum-conjecture/](http://daslab.seas.harvard.edu/rum-conjecture/).

<a name="note3"></a>3. Graefe, G. 2011. Modern B-tree techniques. _Foundations and Trends in Databases_ 3(4): 203-402; [http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.219.7269&rep=rep1&type=pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.219.7269&rep=rep1&type=pdf).

<a name="note4"></a>4. MySQL 5.7 Reference Manual. The physical structure of an InnoDB index; [https://dev.mysql.com/doc/refman/5.7/en/innodb-physical-structure.html](https://dev.mysql.com/doc/refman/5.7/en/innodb-physical-structure.html).

<a name="note5"></a>5. O'Neil, P., Cheng, E., Gawlick, D., O'Neil, E. 1996. The log-structured merge-tree. _Acta Informatica_ 33(4): 351-385; [http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.2782](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.2782&rep=rep1&type=pdf).

<a name="note6"></a>6. Pelkonen, T., Franklin, S., Teller, J., Cavallaro, P., Huang, Q., Meza, J., Veeraraghavan, K. 2015. Gorilla: a fast, scalable, in-memory time series database. _Proceedings of the VLDB Endowment_ 8(12): 1816-1827; [http://www.vldb.org/pvldb/vol8/p1816-teller.pdf](http://www.vldb.org/pvldb/vol8/p1816-teller.pdf).

<a name="note7"></a>7. Suzuki, H. 2015-2018. The internals of PostreSQL; [http://www.interdb.jp/pg/pgsql01.html](http://www.interdb.jp/pg/pgsql01.html).

<a name="note8"></a>8. Apple HFS Plus Volume Format; [https://developer.apple.com/legacy/library/technotes/tn/tn1150.html#BTrees](https://developer.apple.com/legacy/library/technotes/tn/tn1150.html#BTrees)

<a name="note9"></a>9. Mathur, A., Cao, M., Bhattacharya, S., Dilger, A., Tomas, A., Vivier, L. (2007). [The new ext4 filesystem: current status and future plans](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.111.798&rep=rep1&type=pdf). _Proceedings of the Linux Symposium_. Ottawa, Canada: Red Hat.

<a name="note10"></a>10. Bloom, B. H. (1970), [Space/time trade-offs in hash coding with allowable errors](https://dl.acm.org/citation.cfm?doid=362686.362692),_Communications of the ACM_, 13 (7): 422-426

#### 相关文章

**[五分钟法则：20 年后闪存将如何改写游戏规则](https://queue.acm.org/detail.cfm?id=1413264)**  
Goetz Graefe, Hewlett-Packard 实验室  
旧规则继续发展，而闪存增加了两条新规则。  
[https://queue.acm.org/detail.cfm?id=1413264](https://queue.acm.org/detail.cfm?id=1413264)

**[Disambiguating Databases](https://queue.acm.org/detail.cfm?id=2696453)**  
Rick Richardson  
根据您的访问模型构建数据库。  
[https://queue.acm.org/detail.cfm?id=2696453](https://queue.acm.org/detail.cfm?id=2696453)

**[你做错了！](https://queue.acm.org/detail.cfm?id=1814327)**  
Poul-Henning Kamp  
你以为自己已经掌握了服务器性能的艺术了么？再想一想。  
[https://queue.acm.org/detail.cfm?id=1814327](https://queue.acm.org/detail.cfm?id=1814327)

**Alex Petrov** ([http://coffeenco.de/](http://coffeenco.de/), [@ifesdjeen (GitHub)](https://github.com/ifesdjeen) [@ifesdjeen (Twitter)](https://twitter.com/ifesdjeen))，一位 Apache Cassandra 贡献者、存储系统爱好者。在过去的几年，他一直致力于数据库，为各个公司建立分布式系统和数据处理管道。

> 本文英文原文 PDF 文件：[下载地址](https://dl.acm.org/ft_gateway.cfm?id=3220266&ftid=1967080&dwn=1)

Copyright © 2018 held by owner/author. Publication rights licensed to ACM.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
