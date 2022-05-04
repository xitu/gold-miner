> * 原文地址：[Data Streaming Scalability](http://tutorials.jenkov.com/data-streaming/scalability.html)
> * 原文作者：[Jakob Jenkov](https://twitter.com/#!/jjenkov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-streaming-scalability.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-streaming-scalability.md)
> * 译者：[Park-ma](https://github.com/park-ma)
> * 校对者：[JackEggie](https://github.com/JackEggie), [Fengziyin1234](https://github.com/Fengziyin1234)

# 论数据流的扩展性 

在分布式系统中，数据流是一种简单但功能强大的储存和共享数据的机制。说数据流简单的原因之一是因为它们很容易扩展。无论是从纵向（增加计算机的容量）还是从横向（增加计算机的数量），数据流都能很好的扩展。本次数据流的扩展性的教程中，我们将了解数据流纵向扩展性好的原因，以及在横向扩展性上的选择。常见的问题是，当数据流在横向扩展时，对数据流的处理也可能要进行横向的扩展，这将会影响数据流处理管道的设计。

## 纵向还是横向扩展

为了避免读者感到困惑，我这里先对于纵向和横向进行定义。**纵向扩展**是指你使用更强大的计算机来运行数据流的存储和处理程序。纵向扩展有时也称为**向上扩展**。你可以提高的包括磁盘的大小和速度、内存、CPU 的速度以及 CPU 的核心数量和显卡等设备。

![Vertical scaling - AKA scaling up to a more powerful computer.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-1.jpg)

**横向扩展**指的是将工作分配给多台计算机。因此，数据流中的数据会在多台计算机之间分配，处理数据流的程序也会被分配 （至少它们可以被分配）横向扩展有时也称为**向外扩展**。你可以将一台计算机的工作横向扩展给多台计算机

有两种情况下可能需要横向扩展：一、你得不到一个有更大内存和磁盘， 可以存储和处理你的所有数据的计算机。二、有这样的计算机，但是太贵买不起。

![Horizontal scaling - AKA scaling out to multiple computers.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-2.jpg) 

## 纵向扩展

上面已经提到了，纵向扩展意味着从配置低的计算机扩展到配置高的计算机。下面是传统计算机体系结构的各个层次：

![Computer architecture - vertical scaling.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-3.jpg)
数据离 CPU 越远，CPU 访问它的速度就越慢。在上图中，数据离最底层越近，CPU 访问速度越慢。

上述计算机体系结构的每一层都经过了优化，以便串行读取数据。这意味着，顺序读取位于磁盘上，RAM 或 L3、L2、L1 高速缓存中的数据比读取随机分布在磁盘、RAM 和高速缓存的数据要快。将数据顺序写入磁盘也要比随机写入磁盘各个部分要快得多。

数据流完全是串行数据结构。它们连续地读取，连续地写入。这意味着，你可以在单台计算机上面轻松的向上扩展数据流。写入流的数据可以轻松的扩展到流文件中。向文件追加是写入文件的最快方式，相比之下，回到文件开始的位置并重写文件相对要慢。

从文件读取时，一大块数据被读入到 RAM。RAM 中的数据会被存入缓存，一小部分数据被读取并存入到 L3 缓存中，还有一小部分被读取并存入到 L2 缓存中，还有更小的一部分被读取并存入到 L1 缓存中，CPU 可以直接访问 L1 缓存并读取这部分数据。因为你的数据分散在整个磁盘中，如果你需要将一小块数据从磁盘读取到 CPU 中，你需要先读取一大块数据到 RAM中，然后再进入 L3、L2和L1高速缓存，那么在读取所需数据之前，这将会产生更多次数的数据读取操作。当数据以串行方式位于一个大块中时，磁盘、RAM、L3、L2 和 L1 高速缓存读取数据的速度要比随机读取快得多。原因很简单，因为读取次数少，每一次读取的块中都包含相关数据。

因为数据流的读写很好地利用了现代计算机，当你扩展计算机运行数据流服务时，数据流服务的性能也会线性地增长。

## 横向扩展

之前也已经提到了，横向扩展是将程序从一台计算机扩展到多台计算机。在数据流中，这意味着要将数据流中的消息分发到多台计算机。下面的图描述了将数据流的消息分发给多台计算机的过程：

![The messages of a data stream distributed onto multiple computers.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-4.jpg)

将数据流的消息分发给多台计算机也称为对于数据流的**分区**。

### 分区影响消息序列的顺序的一致性

对于数据流的分区会影响消息序列的顺序的一致性。在一台计算机上，数据流的消息的读取和写入的顺序可以保证是相同的。一旦你对数据流进行了分区，我们就不能保证这个顺序了。具体的分区方法决定了会以何种方式影响消息序列的顺序。

### Round Robin 分区

Round Robin 分区是跨多台计算机对数据流的消息进行分区的最简单的方法。Round Robin 分区只是在计算机之间均匀和顺序地分发消息。换句话说，1 号消息存储在 1 号计算机上，2 号消息存储在 2 号计算机上，以此类推。当所有的计算机都接收到消息后，Round Robin 分区的方法再从 1 号计算机开始。

如果只有一个应用程序写入数据流，使用 Round Robin 分区的方法是最简单的。但是要是有多个程序同时运行就不好办了。

当使用 Round Robin 分区机制时，对于流的读取来说，按照流中划分消息之前的顺序重新组装流中的消息是相当容易的。输出流只需以轮询调度方式从每一个分区读取一条消息。

### 基于字段值分区

基于字段值分区的原理是通过每个消息的特定值将消息分发给不同的计算机。通常，识别ID（例如主键值）作为分发消息的字段。计算每个字段值的哈希值，然后利用这个哈希值将消息映射到集群的一台计算机中。

当使用字段值分区时，很可能会丢失整个消息序列的顺序。写入同一台计算机（同一分区）的消息仍保持相互之间的顺序，但是整个序列的顺序可能会丢失，因为其他的计算机（其他分区）可能在它们之前被读取。下图就说明了这个问题：

![Key based data stream partitioning may affect overall message sequence.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-5.jpg)

如果要获得数据流分区的全部好处，就不能控制流处理器从不同分区读取数据的顺序。如果你还想扩展流处理器，那更不切实际。下图就说明这个问题：

![Key based data stream partitioning with stream processor partitioning too, will most likely affect overall message sequence.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-6.jpg)

在很多情况下，其实你并不需要完整的消息序列的顺序。你需要的可能是在数据流中**相关消息**的消息序列顺序。例如，如果消息表示对于客户端更新，那么将对于同一客户端的更新消息应该集中在集群中的同一台计算机（同一个分区）上。这样，你就可以保证对于每一个客户的更新顺序，这对于你的程序来说已经足够了。对于不同客户端更新顺序可能改变，但是对于同一逻辑实体（客户端）的更新序列保持相同，对于不同逻辑实体的更新之间的序列的改变可能不一定是个问题。

对于消息进行分区以便最后所有的相关消息都会在同一台服务器上，这通常是通过对消息主键上的数据进行分区完成的。这样应该会保证同一逻辑实体（例如客户端）的所有相关消息都会存储在同一台计算机上。

基于字段值的分区，消息的分布可能会不均匀。它取决于字段的分布以及将消息映射到群集计算机的哈希函数。不合适的哈希算法可能会将更多消息映射到某些计算机上而不是其他计算机。这样不均匀的消息分发会导致集群计算机之间负载分布的不平均，这又会导致对于计算机资源的非最佳利用。

在某些情况下，基于非标识字段值（例如外键或某些其他字段值）对消息进行分区是有意义的。这显然会导致消息离散分布，甚至可能导致非常不均匀的分布，例如使用一个比其他值更普遍的值作为分区值。

下面是横向扩展数据流的示意图，其中集群中的计算机的消息分布不一定均匀：

![Key based data stream partitioning may lead to uneven distribution of the messages in the stream across the computers in the cluster.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-scalability-7.jpg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
