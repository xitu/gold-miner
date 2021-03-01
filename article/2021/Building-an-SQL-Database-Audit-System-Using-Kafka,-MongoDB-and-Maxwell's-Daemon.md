> * 原文地址：[Building an SQL Database Audit System Using Kafka, MongoDB and Maxwell's Daemon](https://www.infoq.com/articles/database-audit-system-kafka/)
> * 原文作者：[About the Author](https://www.infoq.com/articles/database-audit-system-kafka/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Building-an-SQL-Database-Audit-System-Using-Kafka,-MongoDB-and-Maxwell's-Daemon.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Building-an-SQL-Database-Audit-System-Using-Kafka,-MongoDB-and-Maxwell's-Daemon.md)
> * 译者：[joyking7](https://github.com/joyking7)
> * 校对者：[lsvih](https://github.com/lsvih)、[PassionPenguin](https://github.com/PassionPenguin)

# 使用 Kafka、MongoDB 和 Maxwell's Daemon 构建 SQL 数据库审计系统

### 本文要点

* 审计日志系统的用处远不止存储数据用于审计目的。除了合规性和安全性目的之外，它还能被市场营销团队使用，便于锁定目标用户，也可以用来生成关键的告警。
* 数据库内置的审计日志功能可能并不够用，并且对于需要处理所有用户场景的情况下，它肯定不是最佳选择。
* 当前有许多开源工具实现审计日志功能，比如说 [Maxwell's Daemons](https://maxwells-daemon.io/) 和 [Debezium](https://debezium.io/)，它们能够以最少的基础设施和时间来支持这些需求。
* Maxwell's Daemon 能够读取 SQL binlog 并将 binlog event 发送给各种生产者，比如 [Kafka](https://kafka.apache.org/)、[Amazon Kinesis](https://aws.amazon.com/kinesis/)、[SQS](https://aws.amazon.com/sqs/)、[Rabbit MQ](https://www.rabbitmq.com/) 。
* SQL 数据库生成的 binlog 文件必须是 ROW 格式，这样整个配置才能正常工作。

那么假设你正在使用关系型数据库来维护你的事务型数据，并且你需要存储的某些数据的审计跟踪信息只出现在很少的表中。如果你像大多数开发人员那样做，那么最终所使用的方案可能如下所示：

### 1. 使用数据库审计日志功能

大多数数据库都提供了插件来支持审计日志。这些插件可以很容易地安装和配置，以便于记录数据。但是，这种方式存在以下问题：

* 成熟完善的审计日志插件一般只有企业版才提供，社区版可能会缺少这些插件。以 MySQL 为例，[审计日志插件](https://dev.mysql.com/doc/refman/5.7/en/audit-log.html)只有企业版才能使用。值得一提的是，MySQL 社区版的用户仍然可以安装其他来自 MariaDB 或者 Percona 的审计日志插件绕过这个限制。
* 正如[慢查询日志对性能影响](http://blog.symedia.pl/2016/10/performance-impact-general-slow-query-log.html) 和 [MySQL 日志性能影响](https://www.percona.com/blog/2009/02/10/impact-of-logging-on-mysql%E2%80%99s-performance)两篇文章讨论的一样，数据库级别的审计日志会给数据库服务器带来 10-20% 的额外开销。通常来讲，对于高负载的系统，我们可能只想对于慢查询部分启用审计日志，而不是对于所有查询开启。
* 审计日志会被写入到日志文件中，这些数据不易于搜索。为了数据分析和审计，我们会更想要让审计数据存储成可搜索的格式。
* 大量审计归档文件会消耗重要的数据库存储，因为它们与数据库存储在相同服务器上。

### 2. 使用你的应用来负责审计日志

你可以通过下面的方式实现：

**a.** 更新现有数据之前，复制现有数据到另外一个表中，然后再更新当前表中的数据。

**b.** 为数据添加一个版本号，每一次更新都将插入一个自增的版本号。

**c.** 写入到两张数据库表中，其中一张包含最新的数据，另外一张包含审计跟踪信息。

作为设计可扩展系统的一项原则，我们必须要避免多次写入相同的数据，因为这样不仅会降低系统的性能，还会引起数据不同步的问题。

## 为什么企业需要审计数据？

在开始介绍审计日志系统架构之前，我们首先看一下各种组织对审计日志系统的需求：

* 合规性和审计：从审计人员的角度来看，他们需要以有意义和上下文相关的方式获取数据。数据库审计日志适合 DBA 团队却不适合审计人员。
* 对于任何大型软件来说，一项基本要求就是在出现安全漏洞时生成关键的告警，审计日志可以用于实现此目的。
* 你必须能够回答各种问题，比如谁访问了数据，数据在此之前的状态是什么，在更新的时候都修改了哪些内容，以及内部用户是否滥用了权限等。
* 还有很重要的一点需要注意，因为审计跟踪信息能有助于识别渗透者，这能够增强对"内部人员"的威慑。人们如果知道自己的行为会被审查，那么他们就不太可能会访问未经授权的数据库或篡改特定的数据。
* 所有行业，从金融、能源到餐饮服务和公共工程，都需要分析数据访问情况，并定期向各种政府机构提交详细报告。根据《健康保险携带和责任法案》（Health Insurance Portability and Accountability Act, HIPAA）的规定，HIPAA 法案要求医疗服务提供商提供所有接触他们数据记录的每个人的审计跟踪信息，信息要求细致到行级别和记录级别。新的《欧盟通用数据保护条例》（European Union General Data Protection Regulation, GDPR）也有类似的要求。《Sarbanes-Oxley 法案》（Sarbanes-Oxley Act, SOX）对公众企业提出了广泛的会计法规，这些组织需要定期分析数据访问情况并生成详细的报告。

本文中，我将会使用像 Maxwell's Daemon 和 Kafka 这样的技术为你提供一个可扩展的解决方案，用于管理审计跟踪数据。

## 问题描述

构建一个独立于应用和数据模型的审计系统，该系统必须兼顾可扩展性与性价比。

## 架构

> 重要提示：本系统只适用于使用 MySQL 数据库的情况，并且使用的是基于 ROW 格式的 [binlog 日志模式](https://dev.mysql.com/doc/refman/5.7/en/binary-log-formats.html)

在我们讨论解决方案细节之前，先让我们快速地了解一下本文所讨论到的每一项技术。

### Maxwell’s Daemon

[Maxwell's Daemon](https://maxwells-daemon.io/)（MD）是一个由 [Zendesk](https://www.zendesk.com/) 开发的开源项目，它会读取 MySQL binlog 并且将 ROW 的更新以 JSON 格式写入到 Kafka、Kinesis 或其他流平台。Maxwell 的运维成本很低，除了 MySQL 和一些在 [Maxwell's Daemon 文档](https://maxwells-daemon.io/)提到的需要写入数据的地方之外，就没有别的需求了。简而言之，MD 是一个数据变更捕获（Change-Data-Capture, CDC）的工具。

市面上有相当多各异的 CDC 工具，比如 Redhat 的 Debezium、Netflix 的 DBLog 和 LinkedIn 的 Brooklyn。CDC 功能可以通过这些工具中的任意一个来实现，但是 Netflix 的 DBLog 和 LinkedIn 的 Brooklyn 是为了满足上述不同的使用场景开发的。但是 Debezium 和 MD 非常相似，可以用来替代我们架构中的 MD。该选择 MD 还是 Debezium，我简单地列出了几个需要考虑的事情：

* Debezium 只能写入数据到 Kafka，至少这是它所主要支持的生产者。而 MD 支持包括 Kafka、[Kinesis](https://aws.amazon.com/kinesis/)、 [Google Cloud Pub/Sub](https://cloud.google.com/pubsub/docs/overview)、 [SQS](https://aws.amazon.com/sqs/)、[Rabbit MQ](https://www.rabbitmq.com/)和 Redis 在内的各种生产者。
* MD 支持用户自己编写生产者并对其进行配置，详情可参考 [Maxwell's Daemon 生产者文档](https://maxwells-daemon.io/producers/)。
* Debezium 的优势在于它可以从多种数据源读取变化数据，比如 [MySQL](https://www.mysql.com/)、[MongoDB](https://www.mongodb.com/)、[PostgreSQL](https://www.postgresql.org/)、[SQL Server](https://www.microsoft.com/en-in/sql-server/)、[Cassandra](http://cassandra.apache.org/)、[DB2](https://www.ibm.com/in-en/products/db2-database)和 [Oracle](https://www.oracle.com/index.html)。在新增数据源上，Debezium 十分灵活，而 MD 目前只支持 MySQL 数据源。

### Kafka

[Apache Kafka](https://kafka.apache.org/) 是一个开源的分布式事件流平台，可用于实现高性能数据管道、流分析、数据集成和关键任务应用。

### MongoDB

[MongoDB](https://www.mongodb.com/) 是一个通用的、基于文档的分布式数据库，它是为现代应用开发者和云时代构建的。我们使用 MongoDB 只是为了进行讲解，你也可以选择其他方案，比如 [S3](https://aws.amazon.com/s3/)，也可以选择其他时序数据，如 [InfluxDB](https://www.influxdata.com/) 或 [Cassandra](http://cassandra.apache.org/)。

下图展示了审计跟踪方案的数据流图：
<div align=center>
<img src='https://res.infoq.com/articles/database-audit-system-kafka/en/resources/1Figure-1-Data-flow-diagram-1609154417022.jpg' alt='数据流图'>
</div>
<center>图 1 数据流图</center>

审计跟踪管理系统中应包括以下步骤：

1. 程序执行数据库写入、更新或删除操作。
2. SQL 数据库以 ROW 格式为以上操作生成 binlog，这涉及到 SQL 数据库的相关配置。
3. Maxwell's Daemon 轮询 SQL binlog，读取新增内容并将其写入 Kafka 主题（Topic）中。
4. 消费者应用轮询 Kafka 主题来读取数据并进行处理。
5. 消费者将处理吼的数据写入到新的存储中。

## 设置

为了配置简单，我们要尽可能的使用 Docker 容器。如果你还没有在你的电脑安装 Dockcer，可以考虑安装 [Docker Desktop](https://www.docker.com/products/docker-desktop)。

### MySQL 数据库

1. 本地运行 mysql 服务器，下面的命令会在 3307 端口启动一个 mysql 容器。

```bash
docker run -p 3307:3306 -p 33061:33060 --name=mysql83 -d mysql/mysql-server:latest
```

2. 如果是刚刚新安装的，我们并不知道 root 密码，运行下面的命令在控制台打印密码。

```bash
docker logs mysql83 2>&1 | grep GENERATED
```

3. 如果有需要，可以登录容器并修改密码。

```bash
docker exec -it mysql83 mysql -uroot -p
alter user 'root'@'localhost' IDENTIFIED BY 'abcd1234'
```

4. 为了安全的考虑，mysql docker 容器默认不允许外部应用连接。我们需要运行下面命令进行修改。

```sql
update mysql.user set host = '%' where user='root';
```

5. 退出 mysql 提示窗并重启 docker 容器。

```bash
docker container restart mysql83
```

6. 重新登录 mysql 客户端，运行下面的命令为 Maxwell's Daemon 创建用户。关于该步骤的详情，可以参考 [Maxwell's Daemon 快速指南](https://maxwells-daemon.io/quickstart/)。

```bash
docker exec -it mysql83 mysql -uroot -p
set global binlog_format=ROW;
set global binlog_row_image=FULL;
CREATE USER 'maxwell'@'%' IDENTIFIED BY 'pmaxwell';
GRANT ALL ON maxwell.* TO 'maxwell'@'%';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'maxwell'@'%';
CREATE USER 'maxwell'@'localhost' IDENTIFIED BY 'pmaxwell';
GRANT ALL ON maxwell.* TO 'maxwell'@'localhost';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'maxwell'@'localhost';
```

### Kafka 消息代理

搭建 Kafka 是一件十分简单的事情，从[该链接](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.6.0/kafka_2.13-2.6.0.tgz)下载 Kafka。

运行下面的命令：

提取 Kafka 文件

```bash
tar -xzf kafka_2.13-2.6.0.tgz
cd kafka_2.13-2.6.0
```

启动 Kafka 当前所需要的 Zookeeper

```bash
bin/zookeeper-server-start.sh config/zookeeper.properties
```

在另外一个终端启动 Kafka

```bash
bin/kafka-server-start.sh config/server.properties
```

在另外一个终端创建一个 Kafka 主题

```bash
bin/kafka-topics.sh --create --topic maxwell-events --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

上述命令会启动 Kafka 消息代理并在它内部创建一个叫做 "**maxwell-events**" 的主题。

要推送消息到这个 Kafka 主题，可以在新的终端运行下面的命令：

```bash
bin/kafka-console-producer.sh --topic maxwell-events --broker-list localhost:9092
```

上述命令会给我们一个对话框，可以输入消息内容，敲击回车键将消息发送给 Kafka。

消费来自 Kafka 主题的消息：

```bash
bin/kafka-console-producer.sh --topic quickstart-events --broker-list localhost:9092
```

### Maxwell’s Daemon

从[该链接](https://maxwells-daemon.io/quickstart/#download)下载 Maxwell's Daemon。
将其解压并运行如下命令：

```bash
bin/maxwell --user=maxwell   --password=pmaxwell --host=localhost --port=3307  --producer=kafka     --kafka.bootstrap.servers=localhost:9092 --kafka_topic=maxwell-events
```

这样我们就启动了 Maxwell 来监控前面搭建好的数据库 binlog。当然我们也可以只监控一些数据库或表，更多信息请参考 [Maxwell’s Daemon 配置](https://maxwells-daemon.io/bootstrapping/)文档。

### 测试设置

为了测试设置是否能正常工作，我们可以连接 MySQL 并向一张表中插入一些数据。

```
docker exec -it mysql83 mysql -uroot -p

CREATE DATABASE maxwelltest;

USE maxwelltest;

CREATE TABLE Persons (
    PersonId int NOT NULL AUTO_INCREMENT,
    LastName varchar(255),
    FirstName varchar(255),
    City varchar(255),
    primary key (PersonId)

);

INSERT INTO Persons (LastName, FirstName, City) VALUES ('Erichsen', 'Tom',  'Stavanger');

```

在另外一个终端运行下面命令：

```bash
bin/kafka-console-consumer.sh --topic maxwell-events --from-beginning --bootstrap-server localhost:9092
```

在终端中，应该能够看到如下内容：

```JSON
{"database":"maxwelltest","table":"Persons","type":"insert","ts":1602904030,"xid":17358,"commit":true,"data":{"PersonId":1,"LastName":"Erichsen","FirstName":"Tom","City":"Stavanger"}}
```

正如所看到的，Maxwell's Daemon 捕获了数据库插入事件，并向 Kafka 主题写入了一个包含事件详细信息的 JSON 字符串。

### 搭建 MongoDB

要在本地运行 MongoDB，运行下面的命令：

```bash
docker run --name mongolocal -p 27017:27017 mongo:latest
```

### Kafka 消费者

Kafka-Consumer 代码可以从 [Github 项目 kmaxwell](https://github.com/vishalsinha27/kmaxwell) 获取，下载源码并参考 README 文档来了解如何运行。

### 最终测试

最后，我们完成了整个安装过程。登录 MySQL 数据库并运行任意插入、删除或更新命令，如果配置正确的话，我们可以在 MongoDB 的 auditlog 数据库看到相应的数据条目。我们可以开心地进行审计工作了！

## 总结

本文所描述的系统在实际部署中运行良好，为我们提供了一个用户数据之外的额外数据源，但在使用这种架构之前，有一些事情需要我们注意：

1. 基础设施成本。这样的设置需要额外的基础设施，数据会经过多次跳转，从数据库到 Kafka 再到另一个数据库，还可能存到备份中，这些都会增加基础设施的成本。
2. 因为数据会经过多次跳转，审计日志数据无法实时维护，它会存在秒级或分钟级的延迟。我们可能会讨论说“谁需要实时的审计日志数据呢”，但如果你计划使用这些数据进行实时监控，这是你必须要考虑到的。
3. 在这个架构中，我们捕获了数据变化，而不是谁改变了数据。如果你还关注是哪个用户改变了数据的话，这种设计可能无法直接进行支持。

在强调了这种架构的一些权衡之处后，我想重申一下这种架构的收益来结束本文。主要收益如下：

*  这样的设计减少了数据库在审计日志方面的性能损耗，并且能够满足传统数据源在市场营销和告警方面的需求
*  这样的架构易于搭建且稳定，任何组件的任何问题都不会导致数据的丢失。例如，如果 MD 挂掉了，数据依然会被存储在 binlog 文件中，当 Daemon 下次启动时，仍能够从中断地方读取数据。如果 Kafka 消息代理挂掉，MD 能够探测它并停止从 binlog 中读取数据。如果 Kafka 消费者崩溃的话，数据将会被保存在 Kafka 消息代理中。因此，在最坏的情况下，审计日志可能会延迟但不会出现数据丢失。
*  安装配置过程简单直接，不需要耗费过多开发精力。

## 关于作者

**![Vishal Sinha](https://res.infoq.com/articles/database-audit-system-kafka/en/resources/1Vishal-Sinha-1609154417736.jpg)Vishal Sinha** 是一位充满激情的技术专家，对分布式计算和大型可扩展系统有着专业的知识和浓厚的兴趣，他目前在一家行业领先的印度独角兽公司担任技术总监。在 16 年多的软件行业生涯中，他曾在多家跨国公司和初创公司工作，开发过各种大型可扩展系统，并带领过一个由许多软件工程师组成的团队，他十分享受解决复杂问题及尝试各种新技术。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
