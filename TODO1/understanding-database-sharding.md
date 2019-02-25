> * 原文地址：[Understanding Database Sharding](https://www.digitalocean.com/community/tutorials/understanding-database-sharding)
> * 原文作者：[Mark Drake](https://www.digitalocean.com/community/users/mdrake)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-database-sharding.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-database-sharding.md)
> * 译者：[Romeo0906](https://github.com/Romeo0906)
> * 校对者：[HearFishle](https://github.com/HearFishle)

# Understanding Database Sharding

# 理解数据库分片

![](https://community-cdn-digitalocean-com.global.ssl.fastly.net/assets/tutorials/images/large/Database-Mostov_v4.1_twitter-_-facebook.png?1549487063)

### Introduction

### 概述

Any application or website that sees significant growth will eventually need to scale in order to accommodate increases in traffic. For data-driven applications and websites, it's critical that scaling is done in a way that ensures the security and integrity of their data. It can be difficult to predict how popular a website or application will become or how long it will maintain that popularity, which is why some organizations choose a database architecture that allows them to scale their databases dynamically.

任何蓬勃发展的应用或者网站，最终都需要扩容开来以适应流量的增长。对于数据驱动的应用和网站来说，以一种能够保障数据安全和完整性的方式进行扩容尤为重要。要预测一个网站或应用将来会有多火，以及它能火多久是非常困难的，因此一些团队选择的数据库架构都支持动态扩展，

In this conceptual article, we will discuss one such database architecture: _sharded databases_. Sharding has been receiving lots of attention in recent years, but many don't have a clear understanding of what it is or the scenarios in which it might make sense to shard a database. We will go over what sharding is, some of its main benefits and drawbacks, and also a few common sharding methods.

在本篇概念文中，我们将会讨论一种支持动态扩展的数据库架构：**分片数据库**。近年来，数据库分片技术非常抓人眼球，但很多人并不了解它到底是什么，以及什么场景下对数据库进行分片才能物尽其用。我们将在文中讨论什么是数据库分片，分析其优劣以及一些常见的数据库分片方法。

## What is Sharding?

## 什么是数据库分片？

Sharding is a database architecture pattern related to _horizontal partitioning_ — the practice of separating one table's rows into multiple different tables, known as partitions. Each partition has the same schema and columns, but also entirely different rows. Likewise, the data held in each is unique and independent of the data held in other partitions.

数据库分片是一种**横向分区**的数据库架构模式，所谓的横向分区技术就是将一个表中的数据按行拆分为多个不同的表的实践方式，这些不同的表被称作分区。每个分区都拥有相同的模式和相同的列，但是数据行却完全不同。同样的，每一个分区中的数据都是唯一的，并且独立于其他的分区。

It can be helpful to think of horizontal partitioning in terms of how it relates to _vertical partitioning_. In a vertically-partitioned table, entire columns are separated out and put into new, distinct tables. The data held within one vertical partition is independent from the data in all the others, and each holds both distinct rows and columns. The following diagram illustrates how a table could be partitioned both horizontally and vertically:

结合**纵向分区**来理解横向分区或许会更容易一些。在纵向分区的表中，成列的数据被分离到另外的新表中。每个纵向分区中的数据都独立于其他分区，并且每个分区的行和列都不相同。下面的图展示了如何对表进行横向和纵向分区：

![Example tables showing horizontal and vertical partitioning](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_1_cropped.png)

![例：表的横向分区与纵向分区](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_1_cropped.png)

Sharding involves breaking up one's data into two or more smaller chunks, called _logical shards_. The logical shards are then distributed across separate database nodes, referred to as _physical shards_, which can hold multiple logical shards. Despite this, the data held within all the shards collectively represent an entire logical dataset.

数据库分片包括将数据分成若干个子集，称为**逻辑分片**，然后逻辑分片分布在不同的数据库节点上，称为**物理分片**。每个数据库节点能够承载多个逻辑分片。尽管如此，所有这些分片集合中的数据一起表现出来就如同一整个逻辑数据集。

Database shards exemplify a [_shared-nothing architecture_](https://en.wikipedia.org/wiki/Shared-nothing_architecture). This means that the shards are autonomous; they don't share any of the same data or computing resources. In some cases, though, it may make sense to replicate certain tables into each shard to serve as reference tables. For example, let's say there's a database for an application that depends on fixed conversion rates for weight measurements. By replicating a table containing the necessary conversion rate data into each shard, it would help to ensure that all of the data required for queries is held in every shard.

数据库分片是[**无共享架构**](https://en.wikipedia.org/wiki/Shared-nothing_architecture)的一个例证。这意味着分片行为是自治行为；各个分片之间不会共享任何数据或者计算资源。然而在某些情况下，将某些特定的数据表作为引用表复制到各个分片中也非常有用。比如，某个应用依赖固定的换算率在不同的重量单位之间换算。对于它的数据库，我们需要把保存换算率数据的表复制到每个分片中，才能够确保在每个分片中都保存着换算查询所需要的数据。

Oftentimes, sharding is implemented at the application level, meaning that the application includes code that defines which shard to transmit reads and writes to. However, some database management systems have sharding capabilities built in, allowing you to implement sharding directly at the database level.

数据库分片通常在应用级别实现，应用里的代码定义了用于读、写的数据库分片。然而，一些数据库管理系统内置了分片功能，允许你直接在数据库级别实现分片操作。

Given this general overview of sharding, let's go over some of the positives and negatives associated with this database architecture.

了解了以上关于数据库分片的基本知识，我们来看这种数据库架构下的优点和缺点。

## Benefits of Sharding

## 数据库分片的优点

The main appeal of sharding a database is that it can help to facilitate _horizontal scaling_, also known as _scaling out_. Horizontal scaling is the practice of adding more machines to an existing stack in order to spread out the load and allow for more traffic and faster processing. This is often contrasted with _vertical scaling_, otherwise known as _scaling up_, which involves upgrading the hardware of an existing server, usually by adding more RAM or CPU.

数据库分片技术最吸引人的要数它能简化**横向扩展**的工作，也被称为**扩张（scaling out）**。横向扩展指的是在已有的基础上增加更多的机器来疏散负载，从而承载更多的流量、实现更快的处理速度。经常拿来与之比较的是**纵向扩展**，或者叫做**扩容（scaling up）**，指的是升级现有机器的硬件配置，通常指加内存、加 CPU。

It's relatively simple to have a relational database running on a single machine and scale it up as necessary by upgrading its computing resources. Ultimately, though, any non-distributed database will be limited in terms of storage and compute power, so having the freedom to scale horizontally makes your setup far more flexible.

我们可以很容易地在某一台机器上运行一个关系型数据库实例，只需要通过升级机器的计算资源即可对其进行扩容。然而，所有非分布式的数据库最终都会受限于机器的存储容量和计算力，因此能够自由地横向扩展将使你的应用变得更加灵活。

Another reason why some might choose a sharded database architecture is to speed up query response times. When you submit a query on a database that hasn't been sharded, it may have to search every row in the table you're querying before it can find the result set you're looking for. For an application with a large, monolithic database, queries can become prohibitively slow. By sharding one table into multiple, though, queries have to go over fewer rows and their result sets are returned much more quickly.

另一个选择数据库分片架构的原因是提高查询的响应速度。假如不曾对数据库做分片处理，当你向数据库发送查询指令的时候，可能需要查询表中的所有行才能找到需要的数据。对于拥有庞大的单个数据库的应用来说，查询将会变得非常慢。通过分片技术，将数据分散到多个表，查询的时候将会在少部分数据中查找需要的数据，同时能够更快地返回结果集。

Sharding can also help to make an application more reliable by mitigating the impact of outages. If your application or website relies on an unsharded database, an outage has the potential to make the entire application unavailable. With a sharded database, though, an outage is likely to affect only a single shard. Even though this might make some parts of the application or website unavailable to some users, the overall impact would still be less than if the entire database crashed.

数据库分片还能使应用更加稳定，因为它降低了宕机的影响。如果你的应用或网站依赖于一个未经分片的数据库，宕机有可能会使得整个应用都不可用。但假如是分片的数据库，宕机也只会影响其中的一个分片。尽管我们的应用或网站的某些功能可能无法被一些用户访问，但总的影响仍然会比整个数据库都挂掉要小很多。

## Drawbacks of Sharding

## 数据库分片的缺点

While sharding a database can make scaling easier and improve performance, it can also impose certain limitations. Here, we'll discuss some of these and why they might be reasons to avoid sharding altogether.

尽管对数据库分片能够易于扩展、提高性能，但是它也有一些局限性。我们将在这部分讨论其部分局限性，并解释为什么不应该一股脑儿地都对数据库做分片处理。

The first difficulty that people encounter with sharding is the sheer complexity of properly implementing a sharded database architecture. If done incorrectly, there's a significant risk that the sharding process can lead to lost data or corrupted tables. Even when done correctly, though, sharding is likely to have a major impact on your team's workflows. Rather than accessing and managing one's data from a single entry point, users must manage data across multiple shard locations, which could potentially be disruptive to some teams.

数据库分片中遇到的第一个困难就是正确地实现数据库分片架构相当复杂。如果没能正确操作，你将会承受极大的风险，因为在数据库分片过程中可能会造成数据丢失、数据表损坏等后果。即使成功了，数据库分片操作很可能会极大地影响团队的工作流。大家不再通过单点来读取、管理数据，他们将跨多个数据库分片来管理数据，这可能会在一些团队中造成混乱的局面。

One problem that users sometimes encounter after having sharded a database is that the shards eventually become unbalanced. By way of example, let's say you have a database with two separate shards, one for customers whose last names begin with letters A through M and another for those whose names begin with the letters N through Z. However, your application serves an inordinate amount of people whose last names start with the letter G. Accordingly, the A-M shard gradually accrues more data than the N-Z one, causing the application to slow down and stall out for a significant portion of your users. The A-M shard has become what is known as a _database hotspot_. In this case, any benefits of sharding the database are canceled out by the slowdowns and crashes. The database would likely need to be repaired and resharded to allow for a more even data distribution.

还有一个问题，大家可能在数据库分片之后遇到分片不平衡的现象。举个例子，假如你的数据库有两个单独的分片，一个保存着姓名以 A 到 M 字母开头的客户，另一个保存着姓名以 N 到 Z 字母开头的客户。然而，你的应用有大量的姓名以 G 字母开头的用户。因此，A - M 分片逐渐产生了比 N - Z 分片更多的数据，导致了应用变得很慢，甚至在部分用户的使用中卡住。这里 A - M 分区就是所谓的**数据库热点**。这个例子中，所有数据库分片带来的好处因为应用的反应慢和崩溃而变得一文不值。因此，数据库需要被修复，被重新分片来达到更加合理的数据分布。

Another major drawback is that once a database has been sharded, it can be very difficult to return it to its unsharded architecture. Any backups of the database made before it was sharded won't include data written since the partitioning. Consequently, rebuilding the original unsharded architecture would require merging the new partitioned data with the old backups or, alternatively, transforming the partitioned DB back into a single DB, both of which would be costly and time consuming endeavors.

另一个重要的缺点就是，一旦数据库分片完成了，就很难恢复到分片之前的架构了。分片操作之前所做的任何备份都不包含分区之后写入的数据。因此，要重建原始的未分片的数据库架构就必须将新分区的数据和旧的备份数据融合在一起，或者将各个分区的数据库导入到单个数据库中。这两种方式都费事费力，代价不菲。

A final disadvantage to consider is that sharding isn't natively supported by every database engine. For instance, PostgreSQL does not include automatic sharding as a feature, although it is possible to manually shard a PostgreSQL database. There are a number of Postgres forks that do include automatic sharding, but these often trail behind the latest PostgreSQL release and lack certain other features. Some specialized database technologies — like MySQL Cluster or certain database-as-a-service products like MongoDB Atlas — do include auto-sharding as a feature, but vanilla versions of these database management systems do not. Because of this, sharding often requires a "roll your own" approach. This means that documentation for sharding or tips for troubleshooting problems are often difficult to find.

最后一个需要考量的缺点，并非所有的数据库引擎都原生地支持分片操作。比如，PostgreSQL 没有自动分片的功能，因此我们只能手动地给 PostgreSQL 数据库分片。虽然有很多 Postgres 的分支版本具备自动分片的功能，但是这些版本的发布通常都晚于最新的 PostgreSQL 版本，并且会缺少某些功能。一些专业的数据库技术 - 比如 MySQL 集群或者某些数据库服务产品（比如 MongoDB Atlas）- 具备自动分片的功能，但是普通版本的数据库关系系统中并不具备这样的功能。正因如此，数据库分片操作通常需要你自己动手，这也意味着很难找到关于数据库分片操作的文档或者排查问题的建议。

These are, of course, only some general issues to consider before sharding. There may be many more potential drawbacks to sharding a database depending on its use case.

当然，这些仅仅是数据库分片操作之前需要考虑的一些常见问题。可能还有很多问题，大都依赖于数据库分片的使用场景。

Now that we've covered a few of sharding's drawbacks and benefits, we will go over a few different architectures for sharded databases.

至此我们讨论了一些数据库分片的优缺点，接下来我们将介绍几种数据库分片的架构方式。

## Sharding Architectures

## 数据库的分片架构

Once you've decided to shard your database, the next thing you need to figure out is how you'll go about doing so. When running queries or distributing incoming data to sharded tables or databases, it's crucial that it goes to the correct shard. Otherwise, it could result in lost data or painfully slow queries. In this section, we'll go over a few common sharding architectures, each of which uses a slightly different process to distribute data across shards.

一旦你决定要对数据库进行分片，接下来你要做的就是弄清楚如何去实现它。查询数据的时候或者保存数据到分片的数据库或数据表中的时候，选用正确的分区至关重要。否则，将会造成数据丢失或者令人痛苦的慢查询。在这部分，我们将要介绍一些常用的数据库分片架构，每种架构在不同分片之前保存数据的方式都略有不同。

### Key Based Sharding

### 基于键的数据库分片

_Key based sharding_, also known as _hash based sharding_, involves using a value taken from newly written data — such as a customer's ID number, a client application's IP address, a ZIP code, etc. — and plugging it into a _hash function_ to determine which shard the data should go to. A hash function is a function that takes as input a piece of data (for example, a customer email) and outputs a discrete value, known as a _hash value_. In the case of sharding, the hash value is a shard ID used to determine which shard the incoming data will be stored on. Altogether, the process looks like this:

**基于键的分片**也叫**基于哈希的分片**，使用新写入数据的值 —— 比如客户 ID、客户端 IP、ZIP 码等等 —— 通过**哈希函数**判断保存的分片位置。哈希函数将输入的数据（如用户的邮件地址）转换成离散数据（也叫做哈希值）输出。在数据库分片中，哈希值将作为数据库分片 ID 将数据保存到对应的分片中。总的来说，整个过程是这样的：

![Key based sharding example diagram](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_2_cropped.png)

![例：基于键的数据库分片图示](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_2_cropped.png)

To ensure that entries are placed in the correct shards and in a consistent manner, the values entered into the hash function should all come from the same column. This column is known as a _shard key_. In simple terms, shard keys are similar to [_primary keys_](https://en.wikipedia.org/wiki/Primary_key) in that both are columns which are used to establish a unique identifier for individual rows. Broadly speaking, a shard key should be static, meaning it shouldn't contain values that might change over time. Otherwise, it would increase the amount of work that goes into update operations, and could slow down performance.

为了保证所有数据的保存位置正确，保存行为一致（即相同的数据每次都保存到相同的位置，译者注），哈希函数的输入值应当为同一列数据。这列数据被称为**分片键**。简单一点，分区键就类似于[**主键**](https://en.wikipedia.org/wiki/Primary_key)，两者都是用来给每个数据/分片创建一个唯一标识的。一般来说，分片键应该是静态的，也就是说它不应该保存可变的数据。否则，更新数据的时候将会产生更多的工作量，还可能会降低性能。

While key based sharding is a fairly common sharding architecture, it can make things tricky when trying to dynamically add or remove additional servers to a database. As you add servers, each one will need a corresponding hash value and many of your existing entries, if not all of them, will need to be remapped to their new, correct hash value and then migrated to the appropriate server. As you begin rebalancing the data, neither the new nor the old hashing functions will be valid. Consequently, your server won't be able to write any new data during the migration and your application could be subject to downtime.

尽管基于键的数据库分片是一种非常常见的数据库分片架构方式，在这种架构上动态地增加或移除数据库服务器却是一件困难的事情。当你增加服务器的时候，每个数据库分片的哈希值都需要调整，因此，即使不是全部数据，也会有很多数据需要重新映射到正确的哈希值，然后迁移到正确的服务器。当你对数据进行均衡性调整的时候，新旧哈希函数都将失效。因此，在数据迁移期间，数据库服务器将不能写入任何数据，应用也将暂停服务。

The main appeal of this strategy is that it can be used to evenly distribute data so as to prevent hotspots. Also, because it distributes data algorithmically, there's no need to maintain a map of where all the data is located, as is necessary with other strategies like range or directory based sharding.

这种策略最吸引人的是它能够将数据平均地分配，从而避免数据热点的出现。另外，因为它使用算法来分配数据，无需像其他策略（基于范围或基于目录的数据库分片策略）那样需要维护一个数据分布的映射关系。

### Range Based Sharding

### 基于范围的数据库分片

_Range based sharding_ involves sharding data based on ranges of a given value. To illustrate, let's say you have a database that stores information about all the products within a retailer's catalog. You could create a few different shards and divvy up each products' information based on which price range they fall into, like this:

**基于范围的数据库分片**基于给定数据的范围来对数据做分片处理。这么说吧，假如你有一个保存着零售店的商品信息的数据库，你可以创建一些数据库分片，然后根据价格区间将商品数据分布到不同的分片中，像这样：

![Range based sharding example diagram](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_3_cropped.png)

![例：基于范围的数据库分片图示](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_3_cropped.png)

The main benefit of range based sharding is that it's relatively simple to implement. Every shard holds a different set of data but they all have an identical schema as one another, as well as the original database. The application code just reads which range the data falls into and writes it to the corresponding shard.

基于范围的数据库分片最大的好处就是实行起来相对简单一些。每个分片都保存着不同的数据集，但它们却有着与众不同的模式，当然也不同于原始的数据库。应用代码中只需读取数据落在了哪个区间，并且将其写入对应的分区即可。

On the other hand, range based sharding doesn't protect data from being unevenly distributed, leading to the aforementioned database hotspots. Looking at the example diagram, even if each shard holds an equal amount of data the odds are that specific products will receive more attention than others. Their respective shards will, in turn, receive a disproportionate number of reads.

另一方面，基于范围的数据库分片并不能防止数据的不均匀分布，也不能防止出现前文所说的数据库热点。再来看上文的图例，即使每个分片保存的数据量相等，但是还可能会产生某些产品比其他更加受欢迎，因此各个分片在数据的读取上也会出现分布不均的情况。

### Directory Based Sharding

### 基于目录的数据库分片

To implement _directory based sharding_, one must create and maintain a _lookup table_ that uses a shard key to keep track of which shard holds which data. In a nutshell, a lookup table is a table that holds a static set of information about where specific data can be found. The following diagram shows a simplistic example of directory based sharding:

若要实现**基于目录的数据库分片**，你必须创建并维护一个**查找表**，并在表中通过数据库分片的键来记录数据保存的位置。简而言之，查找表就是保存着如何查找指定数据的静态数据集的表。下图展示了一个基于目录的数据库分片的简单的例子：

![Directory based sharding example diagram](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_4_cropped.png)

![例：基于目录的数据库分片图示](https://assets.digitalocean.com/articles/understanding_sharding/DB_image_4_cropped.png)

Here, the **Delivery Zone** column is defined as a shard key. Data from the shard key is written to the lookup table along with whatever shard each respective row should be written to. This is similar to range based sharding, but instead of determining which range the shard key's data falls into, each key is tied to its own specific shard. Directory based sharding is a good choice over range based sharding in cases where the shard key has a low cardinality and it doesn't make sense for a shard to store a range of keys. Note that it's also distinct from key based sharding in that it doesn't process the shard key through a hash function; it just checks the key against a lookup table to see where the data needs to be written.

这个例子中，**Delivery Zone** 列被定义为分片的键，分片键的值和该行数据保存的分区被一起写入查找表中。这跟基于范围的数据库分片类似，但是我们并没有判断数据落在了哪个区间，而是将每条数据绑定到了其所在的分片。相对于基于范围的数据库分片来说，基于目录的数据库分片不失为一个更好的选择，假如分片键的基数本来就很小，那么对于数据库分片来说，保存某个范围的键将变得没有意义。当然，基于目录的数据库分片也不同于基于键的数据库分片，它并不使用哈希函数来处理分片键，而只是在查找表中检查键名然后找到数据需要被写入的位置。

The main appeal of directory based sharding is its flexibility. Range based sharding architectures limit you to specifying ranges of values, while key based ones limit you to using a fixed hash function which, as mentioned previously, can be exceedingly difficult to change later on. Directory based sharding, on the other hand, allows you to use whatever system or algorithm you want to assign data entries to shards, and it's relatively easy dynamically add shards using this approach.

基于目录的数据库分片架构最吸引人的地方就是灵活性。基于范围的数据库分片架构要求你必须制定值的区间，而基于键的数据库分片架构则要求你必须使用一个固定的哈希函数，正如前文所说，要修改该函数是非常困难的一件事。而基于目录的数据库分片架构允许你使用任何系统、任何算法来指定数据保存的分片位置，而且添加分片也相对简单一些。

While directory based sharding is the most flexible of the sharding methods discussed here, the need to connect to the lookup table before every query or write can have a detrimental impact on an application's performance. Furthermore, the lookup table can become a single point of failure: if it becomes corrupted or otherwise fails, it can impact one's ability to write new data or access their existing data.

尽管基于目录的数据库分片架构是目前讨论过的最灵活的分片方法，但是每一次查询、写入数据之前都需要先查询查找表可能会影响应用的性能。而且，查找表可能会产生单点故障：如果查找表损毁了，或者由于其他原因失效了，将会影响写入新数据或者查询现有数据的功能。

## Should I Shard?

## 我应该对数据库分片吗？

Whether or not one should implement a sharded database architecture is almost always a matter of debate. Some see sharding as an inevitable outcome for databases that reach a certain size, while others see it as a headache that should be avoided unless it's absolutely necessary, due to the operational complexity that sharding adds.

究竟该不该采用分片的数据库架构一直是备受争议的问题。一些人认为当数据库达到一定量级的时候，采用分片架构是必然的；另一些人则认为由于操作复杂，除非是万不得已，否则不应该使用分片架构。

Because of this added complexity, sharding is usually only performed when dealing with very large amounts of data. Here are some common scenarios where it may be beneficial to shard a database:

*   The amount of application data grows to exceed the storage capacity of a single database node.
*   The volume of writes or reads to the database surpasses what a single node or its read replicas can handle, resulting in slowed response times or timeouts.
*   The network bandwidth required by the application outpaces the bandwidth available to a single database node and any read replicas, resulting in slowed response times or timeouts.

由于其复杂性，数据库分片架构多用于处理非常大量的数据。以下这些场景中，对数据库分片可能会非常有用：

* 应用数据不断增长，超出了单点数据库的存储能力。
* 数据库的读写超出了单点数据库或只读从库（读写分离架构下，译者注）的处理能力，从而导致了响应慢或超时。
* 应用所需的网络带宽超出了单点数据库或只读从库的可用带宽，从而导致了响应慢或超时。

Before sharding, you should exhaust all other options for optimizing your database. Some optimizations you might want to consider include:

对数据库分片之前，你最好先尝试其他的方式来优化你的数据库。比如：

*   **Setting up a remote database**. If you're working with a monolithic application in which all of its components reside on the same server, you can improve your database's performance by moving it over to its own machine. This doesn't add as much complexity as sharding since the database's tables remain intact. However, it still allows you to vertically scale your database apart from the rest of your infrastructure.
* **使用远程数据库**。如果你有一个庞大的应用，其所有的组件都依赖于同一个数据库服务器，你可以考虑将数据库迁移到一台单独的机器上来提高其性能。这不会像数据库分片那样复杂，因为所有的数据库表都还是完整的。并且，这种方式还允许你能够抛开其他基础设施，单独地对数据库做纵向扩展。
*   **Implementing [caching](https://en.wikipedia.org/wiki/Database_caching)**. If your application's read performance is what's causing you trouble, caching is one strategy that can help to improve it. Caching involves temporarily storing data that has already been requested in memory, allowing you to access it much more quickly later on.
* **使用[缓存](https://en.wikipedia.org/wiki/Database_caching)**。如果应用受制于读数据的性能，使用缓存是改进性能的一种方式。缓存通过将请求过的数据暂时地保存在内存中，加速后续的数据访问。
*   **Creating one or more read replicas**. Another strategy that can help to improve read performance, this involves copying the data from one database server (the _primary server_) over to one or more _secondary servers_. Following this, every new write goes to the primary before being copied over to the secondaries, while reads are made exclusively to the secondary servers. Distributing reads and writes like this keeps any one machine from taking on too much of the load, helping to prevent slowdowns and crashes. Note that creating read replicas involves more computing resources and thus costs more money, which could be a significant constraint for some.
* **创建若干个只读从库**。另一种能够改进读取性能的方法是将数据从**主库**拷贝到若干个**从库**中。这样一来，新的写操作将使用主库，之后再拷贝到从库中，而读操作将使用从库。这种读写分离的模式使得每一台机器都不会承受过大的负载，有助于防止机器变慢甚至崩溃。值得注意的是，创建只读从库需要更多的计算资源、花更多的钱，某些情况下，这些将会使你步履维艰。
*   **Upgrading to a larger server**. In most cases, scaling up one's database server to a machine with more resources requires less effort than sharding. As with creating read replicas, an upgraded server with more resources will likely cost more money. Accordingly, you should only go through with resizing if it truly ends up being your best option.
* **升级服务器**。一些情况下，升级数据库服务器的配置比数据库分片简单多了。对比创建只读从库，升级服务器配置可能会花更多的钱。因此，除非这真的是你最好的选择，否则不应该对机器扩容。

Bear in mind that if your application or website grows past a certain point, none of these strategies will be enough to improve performance on their own. In such cases, sharding may indeed be the best option for you.

谨记只有当你的应用或者网站增长超过了一定量级的时候，以上这些方法都不足以有效地改进其性能的时候，数据库分片才真的是最佳选择。

## Conclusion

## 总结

Sharding can be a great solution for those looking to scale their database horizontally. However, it also adds a great deal of complexity and creates more potential failure points for your application. Sharding may be necessary for some, but the time and resources needed to create and maintain a sharded architecture could outweigh the benefits for others.

数据库分片对尝试横向扩展数据库的人来说是一个非常好的方案。然而，它也将模型变得更加复杂，也为应用增加了很多潜在的故障点（每个数据库分片都有可能发生故障，译者注）。对一些人来说，数据库分片可能会非常有必要，但是对于另一些人来说，创建和维护数据库分片架构所花费的时间和资源将会大于它带来的好处。

By reading this conceptual article, you should have a clearer understanding of the pros and cons of sharding. Moving forward, you can use this insight to make a more informed decision about whether or not a sharded database architecture is right for your application.

通过阅读本篇概念文，你应该已经对数据库分片的优劣势有了更加清醒的认识。以后，你可以使用本文的观点来判断你的应用是否真的需要数据库分片架构。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
