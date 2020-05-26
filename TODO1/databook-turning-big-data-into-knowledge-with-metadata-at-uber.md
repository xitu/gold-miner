> * 原文地址：[Databook: Turning Big Data into Knowledge with Metadata at Uber](https://eng.uber.com/databook/)
> * 原文作者：[Luyao Li, Kaan Onuk and Lauren Tindal](https://eng.uber.com/databook/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/databook-turning-big-data-into-knowledge-with-metadata-at-uber.md](https://github.com/xitu/gold-miner/blob/master/TODO1/databook-turning-big-data-into-knowledge-with-metadata-at-uber.md)
> * 译者：[cf020031308](https://github.com/cf020031308)
> * 校对者：[yqian1991](https://github.com/yqian1991)

# Databook：通过元数据，Uber 将大数据转化为知识

![](https://i.loli.net/2018/08/16/5b751c9f4474b.png)

从司机与乘客的位置和目的地，到餐馆的订单和支付交易，Uber 的运输平台上的每次互动都是由数据驱动的。数据赋能了 Uber 的全球市场，使我们面向全球乘客、司机和食客的产品得以具备更可靠、更无缝的用户体验，并使我们自己的员工能够更有效地完成工作。

凭借系统的复杂性和数据的广泛性，Uber 将数据驱动提升到了一个新的水平：每天处理万亿级的 Kafka 消息，横跨多个数据中心的 [HDFS](https://eng.uber.com/scaling-hdfs/) 中存储着数百 PB 的数据，并支持每周上百万的分析查询。

然而大数据本身并不足以形成见解。Uber 规模的数据要想被有效且高效地运用，还需要结合背景信息来做业务决策，这才能形成见解。为此我们创建了 Uber 的内部平台 Databook，该平台用于展示和管理具体数据集的有关内部位置和所有者的元数据，从而使我们能够将数据转化为知识。

### 业务（和数据）的指数增长

自 2016 年以来，Uber 的平台上已增加了多项新业务，包括 [Uber Eats](https://www.ubereats.com/)、[Uber Freight](https://freight.uber.com/)，以及 [Jump Bikes](https://jumpbikes.com/)。如今，我们每天至少完成 1500 万次行程，每月活跃有超过 7500 万乘客。在过去的八年中，Uber 已从一家小型创业公司发展到在全球拥有 18,000 名员工。

随着这种增长，数据系统和工程架构的复杂性也增加了。例如有数万张表分散在多个在役的分析引擎中，包括 [Hive](https://hive.apache.org/)、[Presto](https://eng.uber.com/presto/) 和 [Vertica](https://www.vertica.com/)。这种分散导致我们急需了解信息的全貌，特别是我们还在不断添加新业务和新员工。 2015 年的时候，Uber 开始手动维护一些静态 HTML 文件来对表进行索引。

随着公司发展，要更新的表和相关元数据的量也在增长。为确保我们的数据分析能跟上，我们需要一种更加简便快捷的方式来做更新。在这种规模和增长速度下，有个能发现所有数据集及其相关元数据的强大系统简直不要太赞：它绝对是让 Uber 数据能利用起来的必备品。

[![](https://eng.uber.com/wp-content/uploads/2018/08/image6.png)](http://eng.uber.com/wp-content/uploads/2018/08/image6.png)

图 1：Databook 是 Uber 的内部平台，可以展示和管理数据有关内部位置和所有者的元数据。

为使数据集的发现和探索更容易，我们创建了 Databook。 Databook 平台管理和展示着 Uber 中丰富的数据集元数据，使我们员工得以探索、发现和有效利用 Uber 的数据。 Databook 确保数据的背景信息 —— 它的意义、质量等 —— 能被成千上万试图分析它的人接触到。简而言之，Databook 的元数据帮助 Uber 的工程师、数据科学家和运营团队将此前只能干看的原始数据转变为可用的知识。

通过 Databook，我们摒弃了手动更新，转为使用一种先进的自动化元数据库来采集各种经常刷新的元数据。Databook 具有以下特性：

*   **拓展性：** 易于添加新的元数据、存储和记录。
*   **访问性：** 所有元数据可被服务以程序方式获取。
*   **扩展性：** 支持高通量读取。
*   **功能性：** 跨数据中心读写。

Databook 提供了各种各样的元数据，这些元数据来自 Hive、Vertica、[MySQL](https://eng.uber.com/mysql-migration/)、[Postgres](https://www.postgresql.org/)、[Cassandra](http://cassandra.apache.org/) 和其他几个内部存储系统，包括：

*   表模式
*   表/列的说明
*   样本数据
*   统计数据
*   上下游关系
*   表的新鲜度、SLA 和所有者
*   个人数据分类

所有的元数据都可以通过一个中心化的 UI 和 [RESTful API](https://restfulapi.net/) 来访问到。 UI 使用户可以轻松访问到元数据，而 API 则使 Databook 中的元数据能被 Uber 的其他服务和用例使用。

虽说当时已经有了像 LinkedIn 的 [WhereHows](https://github.com/linkedin/WhereHows/wiki) 这种开源解决方案，但在 Databook 的开发期间，Uber 还没有采用 [Play 框架](https://www.playframework.com/)和 [Gradle](https://gradle.org/)（译者注：两者为 WhereHows 的依赖）。 且 WhereHows 缺乏跨数据中心读写的支持，而这对满足我们的性能需求至关重要。因此，利用 Java 本身强大的功能和成熟的生态系统，我们创建了自己内部的解决方案。

接下来，我们将向您介绍我们创建 Databook 的过程以及在此过程中我们遇到的挑战。

### Databook 的架构

Databook 的架构可以分为三个部分：采集元数据、存储元数据以及展示元数据。下面图 2 描绘的是该工具的整体架构：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image4.png)](http://eng.uber.com/wp-content/uploads/2018/08/image4.png)

图 2：Databook 架构：元数据从 Vertica、Hive 和其他存储系统中获取，存储到后端数据库，通过 RESTful API 输出。

Databook 引入多个数据源作为输入，存储相关元数据并通过 RESTful API 输出（Databook 的 UI 会使用这些 API）。

在初次设计 Databook 时，我们就必须做出一个重大的决定，是事先采集元数据存起来，还是等到要用时现去获取？我们的服务需要支持高通量和低延迟的读取，如果我们将此需求托付给元数据源，则所有元数据源都得支持高通量和低延迟的读取，这会带来复杂性和风险。比如，获取表模式的 Vertica 查询通常要处理好几秒，这并不适合用来做可视化。同样，我们的 Hive metastore 管理着所有 Hive 的元数据，令其支持高通量读取请求会有风险。既然 Databook 支持许多不同的元数据源，我们就决定将元数据存储在 Databook 自身的架构中。此外，大多数用例虽然需要新鲜的元数据，但并不要求实时看到元数据的更改，因此定期爬取是可行的。

我们还将请求服务层与数据采集层分开，以使两者能运行在独立的进程中，如下面的图 3 所示：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image11.png)](http://eng.uber.com/wp-content/uploads/2018/08/image11.png)

图 3：Databook 由两个不同的应用层组成：数据采集爬虫和请求服务层。

两层隔离开可减少附带影响。例如，数据采集爬虫作业可能占用较多的系统资源，没隔离就会影响到请求服务层上 API 的 SLA。另外，与 Databook 的请求服务层相比，数据采集层对中断不太敏感，如果数据采集层挂掉，可确保仍有之前的元数据能提供，从而最大限度地减少对用户的影响。

### 事件驱动采集 vs 定时采集

我们的下一个挑战是确定如何最且成效且最高效地从多种不同数据源采集元数据。我们考虑过多种方案，包括创建一个分布式的容错框架，利用基于事件的数据流来近乎实时地检测和调试问题。

我们先创建了爬虫来定期采集各种数据源和微服务生成的有关数据集的元数据信息，例如表的使用数据统计，它由我们用于解析和分析 SQL 的强大开源工具 [Queryparser](https://eng.uber.com/queryparser/) 生成。**（顺带一提：Queryparser 也由我们的“数据知识平台”团队创建）。**

我们需要以可扩展的方式频繁采集元数据信息，还不能阻塞到其他的爬虫任务。为此，我们将爬虫部署到了不同的机器，这就要求分布式的爬虫之间能进行有效协调。我们考虑配置 [Quartz](http://www.quartz-scheduler.org/) 的集群模式（由 MySQL 支持）来做分布式调度。但是，却又面临两个实现上的障碍：首先，在多台机器上以集群模式运行 Quartz 需要石英钟的定期[同步](http://www.quartz-scheduler.org/documentation/quartz-2.2.x/configuration/ConfigJDBCJobStoreClustering.html)，这增加了外部依赖，其次，在启动调度程序后我们的 MySQL 连接就一直不稳定。最后，我们排除了运行 Quartz 集群的方案。

但是，我们仍然决定使用 Quartz，以利用其强大的内存中调度功能来更轻松、更高效地向我们的任务队列发布任务。对于 Databook 的任务队列，我们用的是 Uber 的开源任务执行框架 [Cherami](https://eng.uber.com/cherami/)。这个开源工具让我们能在分布式系统中将消费程序解耦，使其能跨多个消费者群组进行异步通信。有了 Cherami，我们将 Docker 容器中的爬虫部署到了不同的主机和多个数据中心。使用 Cherami 使得从多个不同来源采集各种元数据时不会阻塞任何任务，同时让 CPU 和内存的消耗保持在理想水平并限制在单个主机中。

尽管我们的爬虫适用于大多数元数据类型，但有一些元数据还需要近乎实时地获取，所以我们决定过渡到基于 Kafka 的事件驱动架构。有了这个，我们就能及时检测和调试数据中断。我们的系统还可以捕获元数据的重大变动，例如数据集上下游关系和新鲜度，如下面的图 4 所示：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image5.png)](http://eng.uber.com/wp-content/uploads/2018/08/image5.png)

图 4：在 Databook 中，对每个表采集上下游关系/新鲜度元数据。

这种架构使我们的系统能够以程序方式触发其他微服务并近乎实时地向数据用户发送信息。但我们仍需使用我们的爬虫执行诸如采集/刷新样本数据的任务，以控制对目标资源的请求频率，而对于在事件发生时不一定需要采集的元数据（比如数据集使用情况统计）则自动触发其他系统。

除了近乎实时地轮询和采集元数据之外，Databook UI 还从使用者和生产者处采集数据集的说明、语义，例如表和列的描述。

### 我们如何存储元数据

在 Uber，我们的大多数数据管道都运行在多个集群中，以实现故障转移。因此，同一张表的某些类型的元数据的值（比如延迟和使用率）可能因集群的不同而不同，这种数据被定义为集群相关。相反，从用户处采集的说明元数据与集群无关：描述和所有权信息适用于所有集群中的同一张表。 为了正确关联这两种类型的元数据，例如将列描述与所有集群中的表列相关联，可以采用两种方案：写时关联或读时关联。

##### 写时关联

将集群相关的元数据与集群无关的元数据相关联时，最直接的策略是在写入期间将元数据关联在一起。例如，当用户给某个表列添加描述时，我们就将信息保存到所有集群的表中，如下面的图 5 所示：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image3.png)](http://eng.uber.com/wp-content/uploads/2018/08/image3.png)

图 5：Databook 将集群无关的元数据持久化保存到所有表中。

这方案可确保持久化数据保持整洁。例如在图 5 中，如果“列 1”不存在，该集群就会拒绝该请求。但这存在一个重要的问题：在写入时将集群无关的元数据关联到集群相关的元数据，所有集群相关的元数据必须已经存在，这在时间上只有一次机会。例如，当在图 5 中改动表列描述时，还只有集群 1 有此“列 1”，则集群 2 的写入失败。之后，集群 2 中同一个表的模式被更新，但已错失机会，除非我们定期重试写入，否则此描述将永远不可用，这导致系统复杂化。下面图 6 描述了这种情况：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image9.png)](http://eng.uber.com/wp-content/uploads/2018/08/image9.png)

图 6：Databook 将集群无关的元数据持久保存到所有表中。

##### 读时关联

实现目标的另一种方案是在读取时关联集群无关和集群相关的元数据。由于这两种元数据是在读取时尝试关联，无所谓集群相关的元数据一时是否存在，因此这方案能解决写时关联中丢失元数据的问题。当表模式更新后显示“列 1”时，其描述将在用户读取时被合并，如下面图 7 所示：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image10.png)](http://eng.uber.com/wp-content/uploads/2018/08/image10.png)

图 7：Databook 在读取时关联集群相关和集群无关的元数据。

##### 存储选择

Databook 后端最初是使用 MySQL，因为它开发速度快，可以通过 Uber 的基础设施自动配置。但是，当涉及多数据中心支持时，共享 MySQL 集群并不理想，原因有三：

*   单个主节点：首先，Uber 仅支持单个主节点，导致其他数据中心的写入时间较慢（我们这情况每次写入增加约 70ms）。
*   手动提权：其次，当时不支持自动提权。因此，如果主节点挂掉，要花数小时才能提升一个新的主节点。
*   数据量：我们弃用 MySQL 的另一个原因是 Uber 所产生的大量数据。我们打算保留所有历史变更，并希望我们的系统支持未来扩展，而无需在集群维护上花费太多时间。

出于这些原因，我们选择 Cassandra 来取代 MySQL，因为它具有强大的 XDC 复制支持，允许我们从多个数据中心写入数据而不会增加延迟。而且由于 Cassandra 具有线性可扩展性，我们不再需要担心适应 Uber 不断增长的数据量。

### 我们如何展示数据

Databook 提供了两种访问元数据的主要方法：RESTful API 和可视化 UI。Databook 的 RESTful API 用 [Dropwizard](https://www.dropwizard.io/)（一个用于高性能 RESTful Web 服务的 Java 框架）开发，并部署在多台计算机上，由 Uber 的内部请求转发服务做负载平衡。

在 Uber，Databook 主要用于其他服务以程序方式访问数据。例如，我们的内部查询解析/重写服务依赖于 Databook 中的表模式信息。API 可以支持高通量读取，并且可以水平扩展，当前的每秒查询峰值约为 1,500。可视化 UI 由 React.js 和 Redux 以及 D3.js 编写，主要服务于整个公司的工程师、数据科学家、数据分析师和运营团队，用以分流数据质量问题并识别和探索相关数据集。

##### 搜索

搜索是 Databook UI 的一项重要功能，它使用户能够轻松访问和导航表元数据。我们使用 Elasticsearch 作为我们的全索引搜索引擎，它从 Cassandra 同步数据。如下面图 8 所示，使用 Databook，用户可结合多个维度搜索，例如名称、所有者、列和嵌套列，从而实现更及时、更准确的数据分析：

[![](https://eng.uber.com/wp-content/uploads/2018/08/image1.png)](http://eng.uber.com/wp-content/uploads/2018/08/image1.png)

图 8：Databook 允许用户按不同的维度进行搜索，包括名称、所有者和列。

### Databook 的新篇章

通过 Databook，Uber 现在的元数据比以往更具可操作性和实用性，但我们仍在努力通过建造新的、更强大的功能来扩展我们的影响力。我们希望为 Databook 开发的一些功能包括利用机器学习模型生成数据见解的能力，以及创建高级的问题检测、预防和缓解机制。

如果结合内部和开源解决方案建立可扩展的智能服务并开发有创意的复杂技术对您来说有吸引力，请联系 Zoe Abrams（[za@uber.com](mailto:za@uber.com)）或申请我们团队的[职位](https://www.uber.com/careers/list/29589/)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
