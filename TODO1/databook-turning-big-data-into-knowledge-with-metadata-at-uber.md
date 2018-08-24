> * 原文地址：[Databook: Turning Big Data into Knowledge with Metadata at Uber](https://eng.uber.com/databook/)
> * 原文作者：[Luyao Li, Kaan Onuk and Lauren Tindal](https://eng.uber.com/databook/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/databook-turning-big-data-into-knowledge-with-metadata-at-uber.md](https://github.com/xitu/gold-miner/blob/master/TODO1/databook-turning-big-data-into-knowledge-with-metadata-at-uber.md)
> * 译者：
> * 校对者：

# Databook: Turning Big Data into Knowledge with Metadata at Uber

![](https://i.loli.net/2018/08/16/5b751c9f4474b.png)

From driver and rider locations and destinations, to restaurant orders and payment transactions, every interaction on Uber’s transportation platform is driven by data. Data powers Uber’s global marketplace, enabling more reliable and seamless user experiences across our products for riders, drivers, and eaters worldwide, as well as empowering our own employees to more efficiently do their jobs.

Uber takes data-driven to the next level with the complexity of its systems and breadth of data, processing trillions of Kafka messages per day, storing hundreds of petabytes of data in [HDFS](https://eng.uber.com/scaling-hdfs/) across multiple data centers, and supporting millions of weekly analytical queries.

Big data by itself, though, isn’t enough to leverage insights; to be used efficiently and effectively, data at Uber scale requires context to make business decisions and derive insights. To provide further insight, we built Databook, Uber’s in-house platform that surfaces and manages metadata about the internal locations and owners of certain datasets, allowing us to turn data into knowledge.

### Exponential business (and data) growth

Since 2016, Uber has added several new lines of business to its platform, including [Uber Eats](https://www.ubereats.com/), [Uber Freight](https://freight.uber.com/), and [Jump Bikes](https://jumpbikes.com/). Now, we complete over 15 million trips a day, with over 75 million monthly active riders. In the last eight years, the company has grown from a small startup to 18,000 employees across the globe.

With this growth comes an increased complexity of data systems and engineering architecture. For instance, tens of thousands of tables exist across the multiple analytics engines we use, including [Hive](https://hive.apache.org/), [Presto](https://eng.uber.com/presto/), and [Vertica](https://www.vertica.com/). This dispersion makes it imperative to have full visibility into what information is available, especially as we continue to add new line-of-business data and employees. In 2015, Uber began cataloging its tables with a set of static HTML files that were manually maintained.

As the company grew, so did the number of tables and relevant metadata that we needed to update. To ensure that our data analytics could keep up with our company’s pace of growth, we needed an easier and faster way to make these updates. At this scale and pace of growth, a robust system for discovering all datasets and their relevant metadata is not just nice to have: it is absolutely integral to making data useful at Uber.

[![](https://eng.uber.com/wp-content/uploads/2018/08/image6.png)](http://eng.uber.com/wp-content/uploads/2018/08/image6.png)

Figure 1. Databook is Uber’s in-house platform that surfaces and manages metadata about internal data locations and owners.

To make dataset discovery and exploration easier, we created Databook. The Databook platform manages and surfaces rich metadata about Uber’s datasets, enabling employees across Uber to explore, discover, and effectively utilize data at Uber. Databook ensures that context about data—what it means, its quality, and more—is not lost among the thousands of people trying to analyze it. In short, Databook’s metadata empowers Uber’s engineers, data scientists, and operations teams to move from viewing raw data to having actionable knowledge.

With Databook, we went from making manual updates to leveraging an advanced, automated metadata store to collect a wide variety of frequently refreshed metadata. Databook incorporates the following features:

*   **Extensibility:** New metadata, storage, and entities are easy to add.
*   **Accessibility:** Services can access all metadata programmatically.
*   **Scalability:** Support for high-throughput read.
*   **Power:** Cross-data center read and write.

Databook provides a wide variety of metadata derived from Hive, Vertica, [MySQL](https://eng.uber.com/mysql-migration/), [Postgres](https://www.postgresql.org/), [Cassandra](http://cassandra.apache.org/), and several other internal storage systems, including:

*   Table schema
*   Table/column descriptions
*   Sample data
*   Statistics
*   Lineage
*   Table freshness, SLAs, and owners
*   Personal data categorization

All metadata is accessible through both visualizations in a central UI and a [RESTful API](https://restfulapi.net/). The Databook UI enables users to access the metadata easily, while the API allows Databook metadata to power other services and use cases across Uber.

Though open source solutions like LinkedIn’s [WhereHows](https://github.com/linkedin/WhereHows/wiki) already existed, the [Play framework](https://www.playframework.com/) and [Gradle](https://gradle.org/) were not supported at Uber during Databook’s development. WhereHows also lacked the cross-data center read and write support that was critical to our performance needs. As such, we set out to build our own, in-house solution, written in Java to leverage its built-in functionality and mature ecosystem.

Next, we’ll take you through how we created Databook and the challenges we experienced along the way.

### Databook architecture

Databook’s architecture can be broken down into three sections: how metadata is collected, how metadata is stored, and how metadata is surfaced. Figure 2, below, depicts the tool’s overall architecture:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image4.png)](http://eng.uber.com/wp-content/uploads/2018/08/image4.png)

Figure 2. The Databook architecture takes in metadata from Vertica, Hive, and other storage systems, stores it in its back-end databases, and outputs the data using RESTful APIs.

Databook intakes multiple sources as inputs, stores the relevant metadata, and outputs this information through RESTful APIs, which powers the Databook UI.

When first designing Databook, one major decision we had to make was whether we would store the metadata we collect or fetch it as requested. Our service needed to support high-throughput and low-latency read, and if we delegated this responsibility to the metadata sources, it would require all sources to support high-throughput and low-latency read, which would introduce complexity and risk. For example, a Vertica query that fetches table schema typically takes a few seconds to process, making it ill-suited for visualizations. Similarly, our Hive metastore manages all of Hive’s metadata, making it risky to require support for high-throughput read requests. Since Databook supports so many different metadata sources, we decided to store the metadata in the Databook architecture itself. In addition, while most use cases require fresh metadata, they do not need to see metadata changes in real time, making periodical crawling possible.

We also separated the request serving layer from the data collection layer so that each runs in a separate process, as depicted in Figure 3, below:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image11.png)](http://eng.uber.com/wp-content/uploads/2018/08/image11.png)

Figure 3. Databook is comprised of two different application layers: data collection crawlers and a request serving layer.

This isolates both layers, thereby reducing collateral impact. For example, data collection crawling jobs may use significant system resources, which could impact the SLA of APIs on the request serving layer. Moreover, compared to Databook’s request serving layer, the data collection layer is less sensitive to outages, ensuring that, if the data collection layer is down, outdated metadata will still be served, in turn minimizing impact to users.

### Event-based collection vs. scheduled collection

Our next challenge was to determine how we could most effectively and performantly collect metadata from several different, disparate data sources. We considered multiple options, including: creating a fault-tolerant framework in a distributed manner and leveraging event-based streaming to detect and debug issues in near real time.

We first created crawlers to periodically collect information from our various data sources and microservices that generate metadata information about datasets, such as table usage statistics derived by our powerful open source tool for parsing and analyzing SQL, [Queryparser](https://eng.uber.com/queryparser/). _(Fun fact: Queryparser was also built by our Data Knowledge Platform team_).

We needed to collect metadata information frequently in a scalable manner without blocking other crawler tasks; in order to do this, we deployed our crawlers to different machines, requiring effective coordination between crawlers in a distributed manner. We considered configuring [Quartz](http://www.quartz-scheduler.org/) in clustering mode for distributed scheduling (backed by MySQL). However, we faced two blockers that prevented us from implementing this solution: first, running Quartz in clustering mode on multiple machines requires Quartz clocks to be [synced](http://www.quartz-scheduler.org/documentation/quartz-2.2.x/configuration/ConfigJDBCJobStoreClustering.html) periodically, adding an external dependency, and second, we experienced constant MySQL connection instability after the schedulers started. As a result, we ruled out running Quartz in clustering mode.

However, we still decided to use Quartz for its robust in-memory scheduling functionality to make publishing tasks into our task queue easier and more efficient. For Databook’s task queue, we leveraged Uber’s open-sourced task execution framework, [Cherami](https://eng.uber.com/cherami/). This open source tool allows us to decouple consumer applications in a distributed system, enabling them to communicate in an asynchronous manner across multiple consumer groups. With Cherami, we deployed crawlers in Docker containers into different hosts and multiple data centers. Using Cherami made it possible to collect various metadata from many different sources without blocking any tasks, while keeping CPU and memory consumption under a desirable level and in a single host.

Though our crawlers worked for most metadata types, some metadata needed to be captured in near real time, which is why we decided to transition to an event-based architecture using Kafka. With this, we are able to detect and debug data outages instantly. Our system can also capture critical metadata changes, such as dataset lineage and freshness, as depicted in Figure 4, below:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image5.png)](http://eng.uber.com/wp-content/uploads/2018/08/image5.png)

Figure 4. In Databook, metadata lineage/freshness is collected for each table.

This architecture enables our system to programmatically trigger other microservices and send communications to data users in near real time. However, we still use our crawlers for tasks such as collecting (or refreshing) sample data, throttling requests against destination resources, and for metadata that does not necessarily need to be collected when an event happens that automatically triggers other systems (e.g., dataset usage statistics).

In addition to polling and collecting metadata in near real time, the Databook UI also collects manual, semantic information about datasets from both dataset consumers and producers, such as descriptions of tables and columns.

### How we store metadata

At Uber, most of our pipelines run in multiple clusters for failover purposes. As a result, the values (for example, latency and usage) for some types of metadata can differ for the same table across different clusters, which are defined as cluster-specific. On the contrary, the manual metadata collected from users is cluster-agnostic: descriptions and ownership information apply to the same table across clusters. In order to link these two types of metadata correctly, such as associating a column description to a table column in all clusters, two potential approaches can be adopted: link during write or link during read.

##### Link during write

When associating cluster-specific metadata with cluster-agnostic metadata, the most straightforward strategy is linking together metadata during the write. For example, when a user adds a column description to a given table column, we persist the information to the table in all clusters, depicted in Figure 5, below:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image3.png)](http://eng.uber.com/wp-content/uploads/2018/08/image3.png)

Figure 5. Databook persists cluster-agnostic metadata to all tables.

This approach ensures that the persisted data is in a clean state. For instance, in Figure 5, if “column 1” does not exist, it will reject the request. However, there is a major problem: to link cluster-agnostic metadata to cluster-specific metadata during the write time, all cluster-specific metadata must be present, and there is only one chance in terms of time. For example, when the description is triggered in Figure 4, only Cluster 1 has this “column 1,” so the write to Cluster 2 fails. Later, schema of the same table in Cluster 2 gets updated, but the chance has slipped away and this description will never be available unless we periodically retry the write, thereby complicating the system. Figure 6, below, depicts this scenario:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image9.png)](http://eng.uber.com/wp-content/uploads/2018/08/image9.png)

Figure 6. Databook persists cluster-agnostic metadata to all tables.

##### Link during read

Another way to achieve the goal is linking cluster-agnostic and cluster-specific metadata during read. This approach resolves the issue of missing metadata in link during write as these two types of metadata are linked during read, whenever the cluster-specific metadata is present. When “column 1” shows up after the schema is updated, its description will be merged at the time users read, as depicted in Figure 7, below:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image10.png)](http://eng.uber.com/wp-content/uploads/2018/08/image10.png)

Figure 7. Databook links cluster-specific and cluster-agnostic metadata during reads.

##### Storage choice

MySQL was initially used to power Databook’s backend since it’s fast to develop and can be provisioned automatically through Uber’s infrastructure portal. However, when it comes to multi-data center support, a shared MySQL cluster is not ideal for three reasons:

*   A single master: First, only single master was supported at uber, resulting in slow write times (adding ~70ms for each write in our case) from other data centers.
*   Manual promotion: Second, auto-promotion was not supported at the time. As a result, if the master node was down, it took hours to promote a new master node.
*   Data volume: Another reason we switched from MySQL is the massive volume of data Uber generates. We intended to keep all history changes, and wanted our system to support future expansion without spending too much time on cluster maintenance.

For these reasons, we chose Cassandra to replace MySQL because of its robust XDC replication support, allowing us to write data from multiple data centers without suffering from increased latency. And because Cassandra is linear scalable, we no longer needed to worry about accommodating Uber’s ever increasing data volume.

### How we surface data

Databook provides two primary means of accessing metadata: a RESTful API and visual UI. Databook’s RESTful API is powered by [Dropwizard](https://www.dropwizard.io/), a Java framework for high-performance RESTful web services, and is deployed in multiple machines and load balanced by Uber’s in-house request forwarding service.

At Uber, Databook is mainly used by other services which access data in a programmatic way. For example, our in-house query parsing/rewriting service relies on table schema information in Databook. The API can support high-throughput read and is horizontally scalable, with a current peak queries per second of around 1,500. The visualization UI is written in React.js and Redux as well as D3.js and is primarily used by engineers, data scientists, data analysts, and operations teams throughout the company to triage data quality issues and identify and explore relevant datasets.

##### Search

Search, a critical feature of the Databook UI, empowers users to easily access and navigate table metadata. We use Elasticsearch as our full-index search engine, which in turn syncs data from Cassandra. With Databook, users can search across multiple dimensions, such as name, owner, column, and nested column, depicted in Figure 8, below, enabling fresher and more accurate data analysis:

[![](https://eng.uber.com/wp-content/uploads/2018/08/image1.png)](http://eng.uber.com/wp-content/uploads/2018/08/image1.png)

Figure 8. Databook lets users search by different dimensions, including name, owner, and column.

### Databook’s next chapter

With Databook, metadata at Uber is now more actionable and useful than ever before, but we are still working to expand our impact by building out new, more robust functionalities. Some functionalities we hope to develop for Databook include the abilities to generate data insights with machine learning models and create advanced issue detection, prevention, and mitigation mechanisms.

If building scalable, smart services and developing innovative complex technologies with a mix of both in-house and open source solutions appeals to you, please reach out to Zoe Abrams ([za@uber.com](mailto:za@uber.com)) or apply for a [role](https://www.uber.com/careers/list/29589/) on our team!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
