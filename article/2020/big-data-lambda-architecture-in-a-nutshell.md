> * 原文地址：[Big Data: Lambda Architecture in a nutshell](https://levelup.gitconnected.com/big-data-lambda-architecture-in-a-nutshell-fd5e04b12acc)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/big-data-lambda-architecture-in-a-nutshell.md](https://github.com/xitu/gold-miner/blob/master/article/2020/big-data-lambda-architecture-in-a-nutshell.md)
> * 译者：[jackwener](https://github.com/jackwener)
> * 校对者：[zenblo](https://github.com/zenblo)、[bljessica](https://github.com/bljessica)

# 大数据：简述 Lambda 架构

#### 我们如何对抗 CAP 理论？

![CAP 理论](https://cdn-images-1.medium.com/max/2730/1*ZyXE41bENSEUP29slqpQyQ.png)

计算机科学中有一个 CAP 定理，分布式数据存储不可能同时提供以下三个保证中的两个以上。

* **一致性**：每个节点读取的是最新结果或者是报错。
* **可用性**：每个请求都会收到一个（非错误）响应，但不保证它包含最新的写入。
* **分区容错**：尽管节点之间的网络丢弃（或延迟了）任意数量的消息，系统仍继续运行。

## 简史

2011年，内森·马兹（Nathan Marz）在他的博客中提出了一种解决 CAP 定理局限性的重要方法，即 Lambda 架构。

![Lambda架构](https://cdn-images-1.medium.com/max/2730/1*RX4WviL_wF7vVChcQUgyzg.png)

## 工作原理

让我们仔细看看 Lambda 架构。Lambda 架构分为三层: 批处理层（batch layer），加速层（speed layer），和服务层（serving layer）。

> 它结合了对同一数据的实时（real-time）和批量（batches）处理。

**首先**，传入的实时数据流在批处理层（batch layer）存储在主数据集中，并在加速层（speed layer）存储在内存缓存中。**然后**对批处理层中的数据建索引，且通过批处理视图使之可用。加速层（speed layer）中的实时数据通过实时视图（real-time views）暴露出来。 **最后**，批处理视图和实时视图都可以独立查询，也可以一起查询，以回答任何历史的或实时的问题。

#### 批处理层（Batch layer）

该层负责管理主数据集。主数据集中的数据必须具有以下三个属性。

- 数据是原始的
- 数据是不可变的
- 数据永远是真实的

主数据集是正确性的保证（source of truth）。即使丢失所有服务层数据集和加速层数据集，也可以从主数据集中重建应用程序。

批处理层还将主数据集预计算到批处理视图（batch views）中，以便能进行低延迟查询。

![批处理视图的预计算](https://cdn-images-1.medium.com/max/2730/1*0fEm3ceh7KurPVJ027S2TA.png)

由于我们的主数据集在不断增长，因此我们必须制定一种策略，以便在有新数据可用时管理批处理视图（batch views）。

* **重新计算法**：抛弃旧的批处理视图，重新计算整个主数据集的函数。
* **增量算法**：当新数据到达时，直接更新视图。

#### 加速层（Speed layer）

加速层批处理视图建立索引便于能快速的即席查询（Ad hoc queries），它存储实时视图并处理传入的数据流，以便更新这些视图。基础存储层必须满足以下场景。

* **随机读**：支持快速随机读取以快速响应查询。
* **随机写**：为了支持增量算法，必须尽可能的以低延迟修改实时视图。
* **可伸缩性**：实时视图应随它们存储的数据量和应用程序所需的读/写速率进行缩放。
* **容错性**：当机器故障，实时视图应还能继续正常运行。

#### 服务层（Serving layer）

该层提供了主数据集上执行的计算结果的低延迟访问。读取速度可以通过数据附加的索引来加速。与加速层类似，该层也必须满足以下要求，例如随机读取，批量写入，可伸缩性和容错能力。

##  Lambda 架构几乎可以满足所有属性

Lambda 体系结构基于几个假定：容错、即席查询、可伸缩性、可扩展性。

* **容错：**   Lambda 架构为大数据系统提供了更友好的容错能力，一旦发生错误，我们可以修复算法或从头开始重新计算视图。
* **即席查询：** 批处理层允许针对任何数据进行临时查询。
* **可伸缩性：** 所有的批处理层、加速层和服务层都很容易扩展。因为它们都是完全分布式的系统，我们可以通过增加新机器来轻松地扩大规模。
* **扩展：** 添加视图是容易的，只是给主数据集添加几个新的函数。

## 一些问题

#### 层之间的代码如何同步

解决此问题的方法之一是通过使用通用库或引入流之间共享的某种抽象来为各层提供通用代码库。譬如 Summingbird or Lambdoop，Casado 这些框架

#### 我们可以移除速度层（speed layer）吗?

是的，在许多应用程序中都不需要速度层（speed layer）。如果我们缩短批处理周期，则可以减少数据可用性中的延迟。另一方面，用于访问存储在 Hadoop 上的数据的新的更快的工具（例如 Impala ， Drill 或 Tez 的新版本等），使在合理时间内对数据执行某些操作成为可能。

#### 我们可以丢弃批处理层（batch layer）并处理速度层（speed layer）中的所有内容吗？

是的，一个例子是 Kappa Kreps 架构，它的示例建议在流中处理传入的数据，并且每当需要更大的历史记录时，它将从 Kafka 缓冲区中重新流化，或者如果我们必须进一步追溯到历史数据集群。

## 如何实现 Lambda 架构？

我们可以使用 Hadoop 数据湖在现实世界中实现此架构，在该数据湖中，HDFS 用于存储主数据集， Spark（或 Storm）可构成速度层（speed layer）， HBase（或 Cassandra）作为服务层，由 Hive 创建可查询的视图。

![Lambda 架构实现的一个例子](https://cdn-images-1.medium.com/max/2730/1*4oItXvPnvE04LCB9Z2-BZw.png)

## 使用 Lambda 架构的公司

#### Yahoo

为了在广告数据仓库上进行分析，雅虎采取了类似的方法，也使用了 Apache Storm，Apache Hadoop 和 Druid²。

#### Netflix

Netflix Suro 项目是 Netflix 数据管道的主干，该管道有独立的数据处理路径，但不严格遵循 lambda 体系结构，因为这些路径可能用于不同的目的，不一定提供相同类型的视图（views）。

**LinkedIn**

使用 Apache Calcite 来桥接离线和近线计算。

## 总结

请记住: batch view = function (all data) realtime view = function (real-time view new data) and query = function (batch view real-time view).

很容易，对吧？

## 参考文献

- [1] [http://nathanmarz.com/blog/how-to-beat-the-cap-theorem.html](http://nathanmarz.com/blog/how-to-beat-the-cap-theorem.html)
- [2] [http://www.slideshare.net/Hadoop_Summit/interactive-analytics-in-human-time?next_slideshow=1](http://www.slideshare.net/Hadoop_Summit/interactive-analytics-in-human-time?next_slideshow=1)
- [3] [https://netflixtechblog.com/announcing-suro-backbone-of-netflixs-data-pipeline-5c660ca917b6](https://netflixtechblog.com/announcing-suro-backbone-of-netflixs-data-pipeline-5c660ca917b6)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
