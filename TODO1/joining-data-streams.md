> * 原文地址：[Joining Data Streams](http://tutorials.jenkov.com/data-streaming/joining-data-streams.html)
> * 原文作者：[Jakob Jenkov](https://twitter.com/#!/jjenkov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/joining-data-streams.md](https://github.com/xitu/gold-miner/blob/master/TODO1/joining-data-streams.md)
> * 译者：[whatbeg](https://github.com/whatbeg)
> * 校对者：[xionglong58](https://github.com/xionglong58), [Fengziyin1234 ](https://github.com/Fengziyin1234)

# 连接数据流

连接数据流意味着将一个数据流的消息与另一个数据流的消息连接起来，这通常基于这些消息中的关键字。一旦开始连接数据流，它将牵扯到如何处理流以及如何扩展流的方式。连接数据流还会影响到连接过程中存储消息所需的存储空间大小。

## 基本的流连接

连接流的基本概念指的是你从多个流中读取消息并将这些消息连接在一起。例如，假设你有一个数据流包含客户更新的更新事件，另一个流包含客户合同的更新事件。当你收到客户的更新时，你可能希望查找客户的所有联系人并对其执行某些操作。例如，你可以将合同附加到客户对象，并将附加后的客户对象转发到另一个数据流。或者，假设客户的婚姻状况从已婚变为单身，你可能会想检查他们的合同是否应该做相应的更改。

![](http://tutorials.jenkov.com/images/data-streaming/joining-data-streams-1.png)

当连接流时，彼此相关的不同流中的消息通常由一组关键字标识。例如，客户具有客户 ID，合同具有合同 ID 以及合同所属的客户 ID（外键）。要将特定客户对象与其相关的合同对象连接起来，你可以在合同流中查找合同对象，确保这个合同对象有一个客户的 ID 对应所查询的客户的客户 ID。

## 流数据视图

当处理数据流时，你是一次处理一条消息或记录。你无权访问该数据流中的任何先前的记录，同样也无法访问任何将来的记录。因此，为了能够从另一个流中定位记录，该流的消息必须存储在某种数据视图中。

![](http://tutorials.jenkov.com/images/data-streaming/joining-data-streams-2.png)

数据视图有两种常见的变体：

*   窗口（Windows）
*   表（Tables）

### 数据窗口（Data Windows）

一个**数据窗口**保存了一个可以在其中查找记录的记录**视窗**。数据窗口通常受时间，记录数量和其他存储约束的限制。当预计两个流中的记录在到达时间上彼此接近时，时间通常被用来限制窗口。然后，一个流中的记录可以存储在一个窗口中，例如 5 分钟或 30 分钟（或适合实际用例的任何时间窗口），直到其他数据流中的记录到达。

### 数据表（Data Tables）

一个**数据表**将记录保存在表格型数据结构中。这样的数据结构可以是简单的关键字，记录的映射，这里，记录可以通过其关键字来查找。记录也可以存储在其他地方，如数据库表，以便可以通过主键，外键和其他值找到记录。

### 数据窗口和数据表的组合

数据窗口和表格可以组合。数据表中可以仅存放记录窗口的数据。当记录“太旧”而不在窗口中时，它也将会重新从数据表中被删除。

### 其他数据视图

还可以对数据流或数据窗口中的记录使用其他数据结构（如树或图）来构建数据视图。这一切都取决于你的需求。

## 转发连接后的记录

有时，你可能希望从一个数据流中转发记录，而该数据流已与另一个数据流中的记录进行了连接。这里的**转发**指的是将连接后的记录写入另一个数据流，供其他人使用。这里的**连接**指的是要么将一条记录插入另一条记录，要么创建一条包含两条记录的连接信息的新记录。这两个选项都在下图说明：

![](http://tutorials.jenkov.com/images/data-streaming/joining-data-streams-3.png)

一旦你转发连接后的记录，会有一些问题影响到系统的正确性和性能。我将在以下部分介绍这些问题。

## 时序问题

输入数据流中记录到达的时序会影响处理或转发时连接后记录的样子。下图说明了时序的差异如何影响两个输入记录的连接记录：

![](http://tutorials.jenkov.com/images/data-streaming/joining-data-streams-4.png)

记录 A 和 B 各自被更新 2 次。这两个版本标注为 A1，A2，B1 和 B2，其中数字代表记录的版本。请注意，A1，A2，B1 和 B2 的到达时间是如何影响处理或转发时连接记录的外观的。该图显示了 3 种不同的时序排列，并且在每种情况下连接的结果看起来都不同。

注意，即使最终连接后的记录看起来相同，得到最终记录的连接记录也不会相同。另外，请记住，你永远不知道“最终”记录何时被连接。没有任何办法可以知道输入数据流中将来会发生什么。因此，你不能只查看上面示例中的最后一条记录，就得出数据流中这些记录的连接操作的“最终”结果。“最终”结果是所有中间突变中连接记录的完整序列。

## 水平扩展性问题

如果你的数据流是水平扩展的（scale out），则连接记录将更加困难。在本节中，我将尝试向你解释为什么会这样。

如本教程之前所述，连接的记录通常由其键匹配。例如，一个 Customer 记录可能使用 customerId 作为主键，而一个 Contract 记录可能具有引用 Customer 记录的主键 customerId 的外键 customerIdFk。

当水平扩展数据流时，数据流中的记录在不同的计算机上进行分区。要连接两条记录，要么将记录分区到同一台计算机上，要么你的连接操作必须知道如何查找存储在另一台计算机上的记录。这两个选项将在以下各节做更详细的介绍。

### 记录重分区

如果你的连接操作不知道如何查找存储在另一台计算机上的记录，则必须对要连接的记录进行分区，以便要连接的记录都位于同一台计算机上。如果此分区不是记录的自然分区，则必须重新分区其中一个数据流中的记录，以便将需要连接的记录放置在同一计算机上。

![](http://tutorials.jenkov.com/images/data-streaming/joining-data-streams-5.png)

注意，记录的重新分区会降低完整记录处理链（也就是图或拓扑）的性能。重新分区还会创建被重新分区的记录的额外副本。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
