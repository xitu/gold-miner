> * 原文地址：[MongoDB Vs. MySQL: When to Use?](https://dzone.com/articles/mongodb-vs-mysql-when-to-use)
> * 原文作者：[Mariana Berga](https://dzone.com/users/4502628/mobrdev.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/mongodb-vs-mysql-when-to-use.md](https://github.com/xitu/gold-miner/blob/master/article/2021/mongodb-vs-mysql-when-to-use.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin), [greycodee](https://github.com/greycodee)

# MongoDB 和 MySQL 使用场景分析

MongoDB 和 MySQL 都是不错的数据库，都具有优良的性能。然而，它们是否成功取决于应用场景。首先应当了解它们各自不同的运行环境，而不能只比较各自的优点和缺点。因此，在本文中，我们将探讨 MongoDB 和 MySQL 各自的关键特性、差别和优势。

坚持把本文看完，你就能更深入了解两种数据库的差异（有很大的不同），从而作出合适的选择。

## 什么是 MySQL？

MySQL 是一个开源的 RDBMS，即关系数据库系统。更确切地说，关系数据库系统是一个用于更新、管理和设计**关系数据库**的应用程序，它很有用，也有利于程序的编码。关系数据库是一种数据库（数据通常以表格形式呈现），它支持在同一个数据库中根据数据间的关联关系来查询数据。MySQL、PostgreSQL 和 SQL 都属于关系数据库系统，它们都有各自的 SQL（结构化查询语言） 标准。

MySQL 是最常用的开源 RDBMS 之一，它于 1995 年面世，因其可靠性持续受到业界的好评。而且它使用很方便。由于数据库模式是根据某种规则预先定义的，数据以行和列的形式存在，还能体现不同表的字段间的关系。

## 什么是 MongoDB？

MongoDB 也是开源的，但它是一种基于文件存储的数据库，这点跟 MySQL 不同。它把文档存储在数据集合中，而不是存储于关系表中。

使用 MongoDB 时，数据模式不是固定的。在一个集合内部删除或修改文档的某些属性是可行的，这就提供了很大的灵活性。而且，同一集合内的文档，其结构可以是完全不同的。

## MongoDB 与 MySQL 的差异

正如前文所述，这两种开源数据库的主要差别在于，MySQL 是关系型的，MongoDB 是基于文件存储的。在本章中，我们将研究这种差异代表什么，包括数据模式和容量、性能和速度、安全性和查询语言等方面。

## 数据模式和容量

在 MongoDB 中，数据是以类似于 JSON 文件的名值对形式存在的，因其模式设计，它对数据的约束条件较少。因此如果数据是快速变化的，MongoDB 就很有优势。另外，MongoDB 还提供了预定义的结构，如果需要也可以使用。

![图片出处: MongoDB](https://www.imaginarycloud.com/blog/content/images/2021/02/MongoDBJSON.png)

关于**数据模式**，MySQL 就不一样了。在 MySQL 中虽然可以改变模式，但是其灵活性和动态性比基于文件存储的数据库差。在存入任何数据之前，MySQL 都会强制进行检查，如果存入数据后表和列符合预先定义的规则，才会真正执行。更改数据模式也需要重新设计数据库的 DDL（数据定义语言）和 DML（数据建模语言）。

关系型数据库和文档型数据库都使用了 DDL 和 DML 的概念。然而，在关系数据库中，**DDL** 和 **DML** 的定义很重要。反之，MongoDB 的数据模式的扩展性较强，不像 MySQL 那样关注数据结构。虽然这似乎是一个很大的缺点，但这种一致性实际上是 MySQL 最大的优势，因为它确保了数据的结构化，维持了数据的清洁性。

![图片出处: [dev.mysql](https://dev.mysql.com/)](https://www.imaginarycloud.com/blog/content/images/2021/02/dataschemasample_MySQL.png)

每个 MongoDB 数据库都包含了若干个集合，或者更准确的说，是由一些文档组成的。这些文档可能包含各种各样的信息字段和类型，并支持存储各种内容和大小的数据。在 MySQL 中，由于数据模式比较具有约束力，一个表中的每条数据都有同样的列，因此当数据库体量很大时，就很难对它进行管理。所以，如果数据库太大且很复杂的情况下，MySQL 处理能力就不如 MongoDB 了。

换句话说，基于文件存储的 MongoDB 比 关系型的 MySQL 更适合处理大量的、结构多变的复杂数据。

## 性能和速度

MongoDB 接收任何数据都比 MySQL 快，而且能接收的数据量也比 MySQL 多。然而，猜想这样一种业务，数据量很小，数据结构也不那么多变，因此不必过于追求快速，那么其他特性（像可靠性和一致性）就成为优先考虑的因素了。

我们需要比较每一种数据库的速度，但更重要的是了解在业务或项目的需求约束下，哪种数据库更合适或性能更优。

如果项目需求侧重于数据的隐私性和完整性，MySQL 就是成熟且合理的方案。由于数据模式是明确的，MySQL 凭借数据表使数据类型系统化，使数据中各自的值都能充分查询并且容易搜索，所以使用 MySQL 意味着数据库结构是稳定不变的。但是，对于非结构化的数据，它就不适合。MySQL 最大的优点（也可以说是缺点）在于需要事先定义数据结构，这就避免了很多技术债务。但是，在某些情况下，数据太复杂，就难以设计一套合适的模式。

另一方面，MongoDB 在处理非结构化数据时更灵活，速度也快。在数据模式难以预先定义的情况下，基于文件存储的数据库就比较适合。然而，如果数据是多样化的，在数据的某个属性上添加索引是难以实现的。因此数据模式需要不断优化。此时如果片面追求一致性，反而会带来风险。

## 安全性

MySQL 利用一套基于权限的安全模型，即用户对数据库进行操作需要身份认证，系统也可以授予或禁止用户对某个数据库进行操作的权限。而且如果应用程序需要从数据库获取数据，就需要使用 SSL 这种安全协议建立加密连接。

MongoDB 的安全体系是由基于角色的访问控制组成的，包括身份认证、授权和审计。另外，如果有加密的需要，也会使用 TLS 和 SSL。

虽然 MongoDB 和 MySQL 都提供了安全模型，在项目需要一定的可靠性和数据一致性的情况下都可以使用，但 MySQL 是最适合的选项。

## 事务的特性：原子性、一致性、隔离性和持久性

在计算机科学中，ACID 是指数据库事务应当具有的属性，满足了这些属性，数据才是有效的。它们分别是：原子性、一致性、隔离性和持久性。

人们通常认为 MySQL 是符合 ACID 标准的，但对于 MongoDB 来说，一味地去满足 ACID 标准就不是最优策略了，因为它会牺牲速度和可用性。MongoDB 于 2018 年开始支持 ACID 多文档事务。但是，默认情况下，此选项处于关闭状态。另一方面，MySQL 的事务符合 ACID 标准，就事务的属性而言，它可以确保数据有效性。

## 查询

MySQL 使用 SQL 语句从一个或几个数据表中获取数据。SQL 是最流行的查询语言，只需要与 DDL 和 DML 相结合，就可以跟数据库系统通信。

相反，MongoDB 使用的是**非结构化查询语言**。从基于 JSON 的文件型数据库中查询数据，第一要务是使用与结果匹配的属性来搜索文档。

换句话说，为了获取 MongoDB 中的数据，需要执行查询操作。应当执行这个函数：`db.collection.find()`。MongoDB 支持多种语言（类似于 [Python](https://www.imaginarycloud.com/blog/why-use-python-for-web-development/), Java, C##, Perl, PHP, [Ruby](https://www.imaginarycloud.com/blog/ruby-vs-python-for-web-development/), 以及[JavaScript](https://www.imaginarycloud.com/blog/async-javascript-patterns-guide/)），只要在该语言中查询可以构建，MongoDB 都支持使用。复合查询可以使用查询操作符为集合文档中的各个字段建立特定的条件。查询操作符（`$and`, `$or`, `$type`, `$eq`等）用于定义条件和过滤器。通过查询获取到的数据是由查询条件决定的，进一步来说，查询、更新、删除的对象都是查询条件决定的。

![图片出处: [MongoDB](https://docs.mongodb.com/guides/)](https://www.imaginarycloud.com/blog/content/images/2021/02/MongoQuery.png)

然而，MongoDB 不支持连接查询，也没有与它等同的替代方案。MySQL 支持 **JOIN 操作符**（包括内连接、外连接、左连接、右连接、全连接），它用于从两个或更多的表中获取数据。简单地说，这些操作允许使用单个 SQL 语句来关联多个表中的数据。

## MongoDB vs. MySQL：分别在什么情况下使用

因为使用环境不同，很难说哪种数据库更好。实际上，MySQL 和 MongoDB 的运行原理完全不同，都是很好用的数据库管理系统。所以，即使其中一种对某些业务或项目很适合，对其他不同的需求来说就未必是最好的选择。公司会根据不同的项目需求来选择合适的数据库。

它们之间为数不多的共同点之一就是**开源和易于访问**。此外，两种系统都提供了有附加功能的商业版。除了这些相似性，它们最关键的不同点在于一个是关系型的，而另一个不是。

MongoDB 是一种文档型数据库，由于它不限制数据量和数据类型，它是**高容量环境**下最合适的解决方案。由于 MongoDB 具备云服务需要的水平可伸缩性和灵活性，它非常适合云计算服务的开发。另外，它降低了负载，简化了业务或项目内部的扩展，实现了**高可用**和数据的快速恢复。

尽管 MongoDB 有那么多优点，但 MySQL 也在某些方面优于 MongoDB，例如**可靠性**和**数据一致性**。另外，如果优先考虑安全性，MySQL 就是安全性最高的 DBMS 之一。

而且，当应用程序需要把多个操作视为一个事务（比如会计或银行系统）时，关系数据库是最合适的选择。除了安全性，MySQL 的事务率也很高。实际上，MongoDB 支持快速插入数据，而 MySQL 相反，它支持事务操作，并关注事务安全性。

总体上看，如果项目的数据模式是固定的，而且不需要频繁变更，推荐使用 MySQL，因此项目维护容易，而且确保了数据的完整性和可靠性。  

另一方面，如果项目中的数据持续增加，而且数据模式不固定，MongoDB 是最合适的选择。由于它属于非关系数据库，数据可以自由使用，不需要定义统一的数据结构，所以对数据进行更新和查询也很方便。MongoDB 通常用于需要对内容进行管理、处理物联网相关业务、进行实时分析等功能的项目中。

## 结论

MySQL 是一个开源的关系数据库，其中的数据存于表中，数据中的某些属性可以跟其他表建立关系。MongoDB 也是开源的，但它属于文档型数据库。因此，它没有记录的概念，它的数据模不固定，所以它是一种动态灵活的数据库，可以插入大量数据。

在选定最佳数据库之前，特定的**业务需求和项目的优先事项**应当是清晰确定的，正如前文提到的，在处理大量数据方面，MongoDB 比 MySQL 更胜一筹。另外，在云计算服务和需求频繁变化的项目上，MongoDB 也是如此。

相反，MySQL 中数据结构和模式是固定的，因此保证了数据一致性和可靠性。使用 MySQL 还有一个好处，就是由于它支持基于 ACID 准则的事务操作，数据安全性更高。所以对于看重这些因素的项目来说，MySQL 是最合适的。

简而言之，只要使用场景跟应用程序的需求相符，并且符合系统的特点，这两种数据库都能提供令人满意的性能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
