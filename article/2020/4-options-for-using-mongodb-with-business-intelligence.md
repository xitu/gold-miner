> * 原文地址：[4 Options for Using MongoDB with Business Intelligence](https://levelup.gitconnected.com/4-options-for-using-mongodb-with-business-intelligence-ec278738b5d2)
> * 原文作者：[Sean Knight](https://medium.com/@sean_24930)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-options-for-using-mongodb-with-business-intelligence.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-options-for-using-mongodb-with-business-intelligence.md)
> * 译者：[huifrank](https://github.com/huifrank)
> * 校对者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)、[灰灰 greycodee](https://github.com/greycodee) 

# 在商业智能中使用 MongoDB 的 4 种方式 - 如何在非结构化数据中使用结构化查询分析

![由[Major Tom Agency](https://unsplash.com/@majortomagency?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/2134/0*tm1VLFJIPTSFjBcw)

##  MongoDB 可以被用在商业智能中吗？

如这篇文章中讨论的那样：[MongoDB vs SQL](https://www.knowi.com/blog/mongodb-vs-sql/)，MongoDB 已经成为目前市场上占有率最高的 NoSQL 提供者之一。

那么，问题来了：MongoDB 是能否像上面讨论的那样，和传统SQL数据库一样在商业智能使用？

答案是：可以，不过需要注意的是，想要通过 Mongo 实现真正的商业智能特性是需要付出时间和金钱的代价。

在本文中，我会简要介绍使用传统关系型数据库（例如 SQL）和 NoSQL（如 MongoDB）数据库在商业智能应用中各自的优势，并做出比较。同时，我也会给出一些建议，用于如何在 MongoDB 中，获得类似于 SQL 那样的实时动态数据查询特性。

## SQL 数据库的优势

从本质上来说，传统关系型数据库都是**结构化**的。他们的数据由键或ID字段相互关联的标准化表结构构成。这种结构化的关系型数据库可以很方便的使用SQL去进行查询。SQL的一个最大优点就是几乎所有数据库都支持这种结构化查询语句：这意味着如果一个人可以在MySQL中编写查询语句的话，那么他也可以很好地在Oracle或其他数据库中进行查询工作。

那么，传统关系型数据库的优势有哪些呢？

* **他们是结构化的** —— 该特性非常适合那些具有强一致性，整洁，标准化的数据存储，例如金融数据。但是这个特性也是一把双刃剑。 后面会详细说明。
* **高效的内存使用** ——  这种高度标准化的关系型数据保证了不会在重复的数据上浪费存储空间。
* **很方便地进行查询** —— SQL 作为一种灵活性和扩展性兼备的查询语言，被需多厂商选择。正因如此，用户可以非常容易地使用 SQL 进行查询，数据转换或与其他关系型数据表进行连接。

## MongoDB 的优势

与 SQL 数据库相比，NoSQL 数据库不遵循关系型数据库中的数据结构。特别像 MongoDB 这类的文档型 NoSQL 数据库是由一系列的 JSON 数据所构成的（这些JSON数据通常包含深层嵌套的数据结构，而这些深层嵌套的数据结构在不同对象之间并不总是一致的）。数百万的开发者使用 MongoDB，使其成为最流行的 NoSQL 数据库之一。

开发者使用MongoDB有哪些优势？

* **灵活的模式结构（schema）** —— 由于 MongoDB 采用 JSON 对象存储的缘故，不同的数据属性间可以随意嵌套。并且，不同的对象也可以拥有不同的成员属性。
* **速度** —— 相对传统的关系型数据库，JSON 数据中的索引查找让 MongoDB 为用户提供更加迅速的检索速度。
* **可伸缩性** —— 由于 MongoDB 将数据分隔为多个碎片，使它可以高效地处理大规模数据。

## 商业智能：SQL 数据库和 MongoDB 的对比

当谈到商业智能时，我们应该怎样针对这两种数据库做出比较？通常来说，[商业智能领域是 SQL 的天下 ](https://www.knowi.com/mysql)。得益于 SQL 的灵活性，我们可以轻松地在关系型数据中执行获取、过滤、连接、聚合或其他函数运算。这样可以很轻松查询报表或执行可视化操作。

作为对比，NoSQL 数据库在商业智能领域中还没有被很好的开发，也就是说，其应用还处于初期阶段。 目前来说，NoSQL 数据库已经有能力被用在商业智能中，但是由于其非结构化的特征意味着相关查询语句并不像 SQL 那样清晰。举一个例子：NoSQL 数据库中的查询语言并不能像 SQL 数据库那样可以跨多种数据库通用，并且 NoSQL 数据库通常也不支持连表操作。

## 如何在商业智能中使用 MongoDB ？

SQL 数据库通常作为商业智能中的最佳选择是很容易理解的。但是在某些使用场景中，NoSQL 数据库中的独特优势也会成为必要条件。 例如在设备互联的[物联网分析](https://www.knowi.com/solution/iot-analytics/)）领域中，这样的 NoSQL 数据库越来越有吸引力。这是一个拥有海量数据，且结构变化多样的领域。在这种情况下，你仍然需要在 Mongo 数据中执行商业智能操作。那么，应该怎样完成呢？ 

#### 方式一： ETL

你可以持续地将所有位于 MongoDB 中的数据同步至 SQL 数据库中，这样，就可以在关系型数据库中实施商业智能了。如果你们公司采用的 ETL 工具足够强力的话，就可以在商业智能中保留实时分析数据能力的前提下，同时中拥有所有 SQL 数据库的优点。[AWS Glue](https://www.knowi.com/blog/aws-glue-etl/) 便是一个很好的选择。其他公司例如 Avik Cloud 可以帮助企业建立用于 ETL 数据转换层管道。

采用这种方法的问题在于需要以硬件的形式引入附加资源，同时，维护新的环境和 ETL 流程的配置中也需要投入额外的人力。突然间， 商业智能进程需要数个来自不同团队成员的支持。从你决定要强制将 MongoDB 数据转换为强模式结构数据导入到 SQL 数据库时起，就意味着需要放弃所有来自无模式结构的优势。

#### 方式二：数据虚拟化

最近由 [Knowi](https://www.knowi.com) 公司提出的一种该问题的解决方案就是**数据虚拟化**。

数据虚拟化通过使用逻辑数据层（虚拟层）连接所有用到的原生数据集来模拟一个统一的数据集。这项技术可以在 SQL 和 NoSQL 数据垂直分布在不同区域或数据库中的情况下对外表现仍然是一个完整的单独数据集，并且可以实时访问。

![A diagram of how data virtualization was used to build the Knowi platform. The Data Services Layer is the data virtualization layer (source: [Knowi](https://www.knowi.com/why-knowi))](https://cdn-images-1.medium.com/max/3852/1*RtDIXrYGtUehJW_aT6GLWQ.png)

Knowi 使用数据虚拟化技术直接连接 MongoDB 并提供给用户一个可以通过生成语句来操纵数据的接口。

用户可以使用原生的 MongoDB 语句，直接在软件中点击鼠标，或结合以上两种方式来生成查询。在生成查询后，用户可以进一步选择使用 Knowi 中基于 SQL 的查询语言 [Cloud9QL](https://www.knowi.com/docs/cloud9QL.html) 来操纵数据。以上过程均实时在 MongoDB 实例中完成，不需要任何 ETL 工具将数据存储在 SQL 数据库中。

![Knowi’s native connection to SQL and NoSQL datasources provides a lot of flexibility](https://cdn-images-1.medium.com/max/2560/0*AJt8XmCOk3hG6fu8)

简单来说，用户可以在不使用 SQL 数据库的情况下，采用像 Knowi 这样的数据虚拟化技术用以在 MongoDB 中执行像 SQL 数据库那样的，基于实时数据中进行过滤，连接，聚合操作。这里一个额外的好处是：像类似 [Couchbase](https://www.knowi.com/couchbase) 和 [Datastax](https://www.knowi.com/datastax-enterprise-analytics) 数据仓库那样，数据虚拟化工具可以非常方便的从其他源中拉取数据，例如 [Elasticsearch，](https://www.knowi.com/elasticsearch-analytics) [REST APIs](https://www.knowi.com/rest-api)， [MySQL](https://www.knowi.com/mysql) 。

#### 方式三：转译

为了解决这个问题，目前有一些公司在尝试构建将用户输入的SQL语句“转译”为 MongoDB 查询语句的转译系统。[Dremio](https://www.dremio.com/) 便是其中之一，为了移除对 ETL 的依赖，他们做了非常出色的工作。

不幸的是，在该方案中，如果出现类似跨数据库联接时会引起非常严重的问题。因该方案通常会包含延迟，在大规模，严格商业智能产品中距理想效果还相距甚远。

#### 方案四：MongoDB Charts（有使用限制）

为了移除 Mongo 数据中数据虚拟化与商业智能的技术壁垒，MongoDB 团队最近发布了 MongoDB Charts。 MongoDB Charts 可以帮助移除使用 MongoDB 与数据虚拟化和商业智能之间许多障碍一个原生虚拟化工具。但是也有一些短板。

* 用户必须有 MongoDB Atlas 账户。
* 用户被限制为只能使用 MongoDB 数据。
* 你必须有 MongoDB Atlas 账户。
* 每张图片只能限制来自单一数据来源中的数据。
* 截止目前，商业智能的可视化程度仅限于简单的图表和仪表板。然而，他们在新特性上工作很积极。

如果你的使用情况不会受到以上这些限制，MongoDB Charts 对于你来说可能是一个好的选择。如果你已经订阅了 MongoDB Atlas，那就再棒不过了。

如果你不会受到以上这些限制，MongoDB Charts 也许是一个好的选择 —— 特别是在你已经是一位 MongoDb Atlas 订阅者的情况下。

## 总结

现代商业智能环境是充满变化的，意味着我们必须不断地对各种不同的数据库类型进行分析，并找出其中更加适合于商业智能的数据库类型。MongoDB 并不是唯一一个为商业智能领域中带来冲击的数据库。幸运的是， 已经有数个创新公司提出针对在商业智能中跨多个各种数据源问题，标准简化的解决方案。 无论你确定哪种解决方案最适合你的业务，有一件事是清楚的：你的业务不再需要在MongoDB和商业智能之间做出选择，可以全都要。

## 关于作者

Sean Knight 是 SASS 分析公司[Growth Knowi](https://www.knowi.com/)的副总裁。他同时拥有物理学和数据科学学位，曾在美国宇航局的喷气推进实验室（NASA JPL）中研究粒子加速器和核反应堆，目前在世界上已小有名气。他是一个数据极客，喜欢为数据科学、分级编码、初创公司和 Hackernoon 做出贡献。
可以在 [Twitter](https://twitter.com/SeanLikesData) 和 [Linkedin](https://www.linkedin.com/in/seanlikesdata/) 上找到他。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
