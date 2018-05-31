> * 原文地址：[Algorithms Behind Modern Storage Systems](https://queue.acm.org/detail.cfm?id=3220266)
> * 原文作者：[Alex Petrov](http://coffeenco.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/algorithms-behind-modern-storage-systems.md](https://github.com/xitu/gold-miner/blob/master/TODO1/algorithms-behind-modern-storage-systems.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：

# 支撑现代存储系统的算法

## 读优化 B-Tree 和写优化 LSM-Tree 的不同用途

### 作者：Alex Petrov

应用程序处理的数据量不断增长。因此，扩展存储变得愈发具有挑战性。每个数据库系统都有自己的方案。为了从这些方案中做出正确的选择，了解它们是至关重要的。

每个应用程序在读写负载平衡、一致性、延迟和访问模式方面各不相同。熟悉数据库和底层存储有助于架构决策；有助于解释系统行为；有助于解决问题；有助于根据具体情况调优。

优化一个系统不可能做到面面俱到。我们当然希望有一个数据结构既能保证最佳的读写性能，又不需要任何存储开销，但显然，这是不存在的。

本文深入讨论了大多数现代数据库中使用的两种存储系统设计 —— 读优化 [B-Tree](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.96.6637&rep=rep1&type=pdf) <sup><a href="#note1">[1]</a></sup> 和写优化 [LSM（结构化日志合并）-Tree](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.2782&rep=rep1&type=pdf) <sup><a href="#note5">[5]</a></sup> —— 并描述了它们的用例和优缺权衡。

### B-Tree

B-Tree 是一种流行的读优化索引数据结构，是二叉树的泛化。它有许多变种，并且被用于多种数据库（包括 [MySQL InnoDB](https://dev.mysql.com/doc/refman/5.7/en/innodb-physical-structure.html) <sup><a href="#note4">[4]</a></sup>、[PostgreSQL](http://www.interdb.jp/pg/pgsql01.html) <sup><a href="#note7">[7]</a></sup>）甚至[文件系统](https://en.wikipedia.org/wiki/HTree)（HFS+ <sup><a href="#note8">[8]</a></sup>、HTrees ext4 <sup><a href="#note9">[9]</a></sup>）。B-Tree 中的 _B_ 代表原始数据结构的作者 _Bayer_，或是他当时就职的公司 _Boeing_。

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

结构化日志合并树是一个不可变的基于磁盘的写优化数据结构。它适用于写入比查询操作更频繁的场景。LSM-Tree 已经获得了更多的关注，因为它可以避免随机插入，更新和删除。

#### 剖析 LSM-Tree

为了允许连续写入，LSM-Tree 在内存中的表（通常使用支持查找的时间复杂度为对数的数据结构，例如二叉搜索树或跳跃表）中批量写入和更新，当其大小达到阈值时将它写在磁盘上（这个操作称为刷新）。检索数据时需要搜索树所有磁盘中的部分，检查内存中的表，合并它们的内容，然后再返回结果。图 5 展示了 LSM-Tree 的结构：用于写入的基于内存的表。只要内存表体积达到一定程度，内存表就会被写入磁盘。进行读取时，同时读取磁盘和内存表，通过一个合并操作来整合数据。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/20/CgQ3cQ.png)

#### 有序串行表

因为 SSTable（有序串行表）的简单性（易于写入，搜索和读取）与合并性能（合并期间，扫描源 SSTable，合并结果的写入是顺序的），多数现代的 LSM-Tree 实现（例如 [RocksDB](https://en.wikipedia.org/wiki/RocksDB) 和 [Apache Cassandra](https://en.wikipedia.org/wiki/Apache_Cassandra)）都选用 SSTable 作为硬盘表。

SSTable 是一种基于硬盘的有序不可变的数据结构。从结构上来看，SSTable 可以分为两部分：数据块和索引块，如图 6 所示。数据块包含以键为顺序写入的唯一键值对。索引块包含映射到数据块指针的键，指针指向实际记录的位置。为了快速搜索，索引一般使用优化的结构实现，例如 B-Tree 或用于点查询的哈希表。SSTable 中的每一个值都有一个时间戳与之对应。时间戳记录了插入、更新（这两者一般不做区分）和删除时间。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/22/C2vwlD.png)

SSTable 具有以下优点：

• 通过查询主键索引可以实现快速的点查询（例如，通过键寻找值）。

• 只需要顺序读取数据块上的键值对就可以实现扫描（例如，遍历制定范围内的键值对）。

SSTable 代表一段时间内所有数据库操作的快照，因为 SSTable 是通过对内存表的**刷新**操作创建的，该表充当此时段内对数据库状态的缓冲区。

#### 查询

检索数据需要搜索硬盘上的所有 SSTable，检查内存表，并且合并它们的内容后返回结果。要搜索的数据可以存储在多个 SSTable 中，因此合并步骤是必须的。

合并步骤也是确保删除和更新正常工作所必需的。在 LSM-Tree 中，通过插入占位符（通常称为墓碑）来指定哪个键被标记为删除。同样的，更新操作只是一个记录一个有较晚的时间戳。在读取期间，被标记删除的记录被跳过，不会返回给客户端。更新操作与之类似：在具有相同键的两个记录中，只返回具有较晚时间戳的记录。图 7 展示了一次合并操作，用于对在不同表中存储的同一个键的数据进行整合：如图，Alex 记录中时间戳是 100，随后更新了新的电话，时间戳为 200；John 记录被删除。另外两项没有改变，因为它们没有被覆盖。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/23/CRyDYV.png)

为了减少搜索 SSTable ，防止为了查找某个键而搜索每个 SSTable，许多存储系统采用一个被称为[布隆过滤器](https://en.wikipedia.org/wiki/Bloom_filter) <sup><a href="#note10">[10]</a></sup> 的数据结构。这是一个概率数据结构，可用于测试某个元素是否属于某集合。它有可能产生错误的肯定（即，判断元素是集合的成员，但实际上并不是），但不能产生错误的否定（即，如果返回否定结果，则元素一定不是集合的成员）。换句话说，布隆过滤器用于判断键“可能在 SSTable 中”或“绝对不在 SSTable 中”。在搜索过程中，将会跳过布隆过滤器返回否定结果的 SSTable。

#### LSM-Tree 的维护

由于 SSTable 是**不可变**的，因此它们会按顺序写入，并且不存在用于修改的预留空白空间。这就意味着插入、更新或删除操作将需要重写整个文件。所有修改数据库状态的操作都在内存表中“批处理”。随着时间的推移，磁盘表的数量将增加（同一个键的数据位于几个不同文件，同一记录有多个不同的版本，被删除的冗余记录），读取操作的开销将变得越来越大。

为了降低读取开销，整合被删除记录占用的空间并减少磁盘表的数量，LSM-Tree 需要一个**压缩**操作，从磁盘读取完整的 SSTable 并合并它们。由于 SSTable 是以键排序的，因此其压缩工作和归并排序差不多，这个操作非常高效：从多个源有序序列中读取记录，进行合并后的输出马上追加到结果文件中，则结果文件也是有序的。归并排序的一个优点是，即使合并内存吃不消的大文件，它依旧可以高效地工作。结果表保留了原始 SSTable 的顺序。

在此过程中，被合并的 SSTable 被丢弃并替换为其“压缩”后的版本，如图 8 所示。压缩多个 SSTable 并将它们合并为一个。某些数据库系统在逻辑层面上按大小把不同的表分为不同级别，分组到相同的“级别”，并在特定级别的表足够多时开始合并操作。压缩后，SSTable 的数量减少，提高查询效率。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/27/Ch4JKI.png)

### 原子性与持久性

为了减少 I/O 操作并使它们顺序执行，无论是 B-Tree 还是 LSM-Tree 都在实际更新之前，先在内存中进行批量操作。这意味着，在故障情况时，数据完整性、**原子性**（将一系列操作赋予原子性，将它们视为一个操作，要么全部执行要么全不执行）、**持久性**（当进程崩溃或电源失效时，可以确保数据已经到达持久性存储设备）得不到保证。

为了解决这个问题，大多数现代存储系统采用 WAL（预写日志）。WAL 的核心思想是，所有数据库状态改变都先持久化进硬盘中只追加的日志中。如果进程在工作中崩溃，将会重映日志以确保没有数据丢失且所有更改都满足原子性。

在 B-Tree 中，使用 WAL 可以理解为仅在写入操作被记录后才将其写入数据文件。通常，B-Tree 存储系统的日志尺寸相对较小：只要将更改应用于持久存储，它们就可以被弃用。WAL 还可以作为运行时操作的备份：任何未应用于数据页的更改都可以根据日志记录重做。

在 LSM-Tree 中，WAL 用于保存处于内存表但尚未完全刷新到磁盘上的更改。只要内存表被刷新完毕并置换，便可以在新创建的 SSTable 中进行读取操作，则 WAL 中从内存表刷新到硬盘上的那部分更改就可以丢弃了。

### 总结

B-Tree 和 LSM-Tree 数据结构最大的差异之一是，它们优化的目的以及优化的效果。

我们来对比一下 B-Tree 和 LSM-Tree 之间的特性。总的来说，B-Tree 具有以下特性：

• 它是可变的，它允许通过一些空间开销和更多的写入路径来进行就地更新，因而它不需要文件重写或多源合并。

• 它是读优化的，这意味着它不需要从多个源数据中读取（也不需要合并），因而简化了读取路径。

• 写操作可能引起级联节点分裂，这使得写操作开销较高。

• 它针对分页环境（块存储）进行了优化，杜绝了字节定位操作。

• 碎片化, 由频繁更新造成的碎片化可能需要额外的维护和块重写。然而对 B-Tree 的维护一般要比 LSM-Tree 要少。

• 并发访问读写隔离，这涉及锁存器与锁链。

LSM-Tree 具有以下特性：

• 它是不可变的。SSTable 一旦被写入硬盘就不会再改变。压缩操作被用于整合占用空间，删除条目，合并在不同数据文件中的同键数据。作为压缩操作的一部分，在成功合并后，源 SSTable 将被弃用并删除。这种不可变性给我们带来了另一个有用的特性，刷新后的表可以被并发访问。

• 它是写优化的，这意味着写入操作将进入缓冲，随后顺序刷新到硬盘上，可能支持基于硬盘的空间局部性。

• 读取操作可能需要访问多个数据源，因为在不同时间写入的同一个键的数据有可能位于不同的数据文件中。必须经过合并过程才能将记录返回给客户端。

• 需要维护 / 压缩，因为缓冲中的写入操作被刷新到硬盘上。

### 评估存储系统

开发存储系统总要面对类似的挑战，考虑类似的因素。决定优化方向会对结果产生很大影响。你可以在写入过程中花费更多时间来布局结构以实现更高效的读取，为就地更新预留空间，也可以缓冲数据确保顺序写入以提高写入速度。但是，一次完成这一切是不可能的。想象中的存储系统应该具有最低的读取成本，最低的写入成本，并且没有开销。但实际上，数据结构只能在多个因素之间权衡。理解这些妥协是重要的。

来自哈佛 DASlab（数据系统实验室）的研究人员总结了数据库系统优化方向的关键三点：读取开销、更新开销和内存开销（或简称为 RUM）。对于数据结构的选择应该了解哪些参数对你的用例最为重要，访问方法，甚至适用于某些工作负载，因为算法是针对特定用例量身定制的。

[RUM 假说](http://daslab.seas.harvard.edu/rum-conjecture/) <sup><a href="#note2">[2]</a></sup> 为上述的两种开销设置了上限，同时为第三种设置了下限。例如，B-Tree 以提高写入开销、预留空间（同时也造成了内存开销）为代价进行读优化。LSM-Tree 以读取时必须进行多硬盘表访问的高读取开销换取低写入开销。在处于竞争三角形的三个参数中，一方面的改进可能就意味着另一方面的让步。图 9 对 RUM 假说进行了说明。

![支撑现代存储系统的算法](https://s1.ax1x.com/2018/05/29/C4OA5n.png)

B-Tree 优化读取性能：索引的布局方式可以最小化遍历树的磁盘访问需求。通过访问一个索引文件就可以定位数据。这是通过持续更新索引文件来实现的，但这也增加了由于节点拆分和合并，重定位以及碎片、不平衡相关的维护造成的额外写入开销。为了平稳更新成本并减少分割次数，B-Tree 在所有级别的节点上都预留有额外的空间。这有助于在节点饱和之前延迟写入开销的增长。简而言之，B-Tree 牺牲更新和内存性能以获得更好的读取性能。

LSM-Tree 优化写入性能。无论是更新还是删除都需要在磁盘上定位数据（B-Tree 也一样），并且它通过在内存表中缓存所有插入，更新和删除操作来保证顺序写入。这是以较高的维护成本和压缩需求（这是唯一的缓解不断增长的读取开销和减少磁盘表的数量的方式）和更高的读取成本（因为数据必须从多个源读取并合并）为代价的。同时，LSM-Tree 通过不保留任何预留空间来减少内存开销（不同于 B-Tree 节点，其平均利用率为 70％，包含就地更新所需的开销），因为更高的利用率和最终文件的不变性，LSM-Tree 支持块压缩。简而言之，LSM-Tree 牺牲读取性能，提高维护成本来获得更好的写入性能和更低的内存占用。

有的数据结构可针对每个期望的属性进行优化。使用自适应数据结构可以以更高维护成本获得更好的读取性能。添加有助于遍历的元数据（如[分散层叠](https://en.wikipedia.org/wiki/Fractional_cascading)）将会影响写入时间并占用更多空间，但可以提高读取性能。使用压缩优化内存使用率（例如，[Gorilla 压缩](http://www.vldb.org/pvldb/vol8/p1816-teller.pdf) <sup><a href="#note6">[6]</a></sup> 、[delta 编码](https://en.wikipedia.org/wiki/Delta_encoding)等诸多算法）会增加一些开销，用于在写入时压缩数据并在读取时解压缩数据。有时候，您可以牺牲功能来提高效率。例如，[堆文件和散列索引](https://en.wikipedia.org/wiki/Database_storage_structures)由于文件格式简单，可以保证很好的性能和较小的空间开销，而作为代价，它们不支持除点查询以外的其他功能。你还可以通过使用近似数据结构（如布隆过滤器、[HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog)、[Count-Min sketch](https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch) 等）来为了空间与效率牺牲精度。

三种可变参数 —— 读取，更新和内存开销 —— 可以帮助你评估数据库并深入了解最适合的工作负载。它们都非常直观，将存储系统按其分类很容易，猜测它是如何执行的，然后通过大量测试验证你的假设。

当然，评估存储系统时还有一些其他重要因素需要考虑，例如维护开销，易用性，系统要求，频繁增删的适应性，访问模式等。RUM 假说只是帮助发展直观感觉并提供初始方向的一条经验法则。了解你的工作部件是构建可扩展后端的第一步。

一些因素可能因实施而异，甚至两个使用类似存储设计原则的数据库可能会有不同表现。数据库是包含许多可插拔模块的复杂系统，是许多应用程序的重要组成部分。这些信息将帮助你窥探数据库的底层，并且了解底层数据结构和其内部行为之间的差异，从而决定哪个是最适合你的。

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
