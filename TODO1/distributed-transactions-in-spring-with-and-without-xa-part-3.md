> * 原文地址：[Distributed transactions in Spring, with and without XA - Part III](https://www.javaworld.com/article/2077963/distributed-transactions-in-spring--with-and-without-xa.html?page=3)
> * 原文作者：[David Syer](mailto:david.syer@springsource.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md)
> * 译者：[radialine](https://github.com/radialine)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94)

# Spring 的分布式事务实现-使用和不使用XA — 第三部分

> * [Spring 的分布式事务实现-使用和不使用XA — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md)
> * [Spring 的分布式事务实现-使用和不使用XA — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * [Spring 的分布式事务实现-使用和不使用XA — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md)

## 其它建议

示例中的 `ChainedTransactionManager` 具有简单的优点：它不用为可用的扩展和优化费心。另一种方法是在第二个资源加入时，使用 Spring 中的 `TransactionSychronization` API 为当前事务注册一个回调。这是 `best-jms-db` 示例中的方法，其中关键特性是 `TransactionAwareConnectionFactory` 与 `DataSourceTransactionManager` 的组合。这种特殊情况可以扩展泛化到使用 `TransactionSynchronizationManager` 的非 JMS 资源上。优点是，原则上只有加入该事务的那些资源将被登记，而不是链中的所有资源。然而，配置仍然需要知道潜在事务中的参与者对应于哪些资源。

此外，Spring 工程团队正在为 Spring Core 考虑开发「Best Efforts 1PC 事务管理器」功能。如果你喜欢该模式，并且希望在 Spring 中看到对它的明确和更透明的支持，你可以在这个 [JIRA 问题](http://jira.springframework.org/browse/SPR-3844)中投票。

## 非事务访问模式

非事务访问模式在某种特殊的业务流程中才有意义。这里是指，有时你需要访问的资源是边缘的，不需要在事务中。例如，你可能需要向审计表中插入一行，该行与业务事务是否成功无关，它只是记录了尝试做某事。更常见的是，人们高估了他们需要对一个资源进行读写更改的程度，往往只读访问就足够了。或者写操作可以被在更细粒度上加以控制，使得在写操作中出现错误时，错误可以被考虑或忽略。

在这些情况下，保持在事务之外的资源可能实际上具有它自己的事务，但是它不与正在发生的任何事务同步。如果你使用 Spring，则主要事务由 `PlatformTransactionManager` 驱动，边缘资源可能是从不由事务管理器控制的数据库「连接」从「数据源」获取。所有这一切都发生在每个访问边缘资源的默认设置是 `autoCommit = true` 时。读操作不会看到在另一个未提交的事务中同时发生的更新（假设有合理的默认隔离级别），但是写操作的效果通常会被其他参与者立即看到。

这种模式需要更仔细的分析和更多设计业务流程的信心，但它不是完全不同于 Best Efforts 1PC。当出现任何问题，提供补偿事务的通用服务对于大多数项目来说是不现实的。但是简单的使用情况涉及幂等的、只执行一个写操作（可能多次读）的服务并不罕见。这些是非事务性情境的理想情况。

## 飞行之翼：反模式

最后一个模式是一个反模式。它往往出现在开发人员不了解分布式事务或不知道他们已经实现了一个分布式事务的情况下。如果没有显式调用底层资源的事务 API，你不能只是假设所有的资源都加入一个事务。如果你使用除 `JtaTransactionManager` 之外的 Spring 事务管理器，就会有一个事务资源依附到这个模式。该事务管理器将用于使用 Spring 声明性事务管理功能（如 `@Transactional`）来拦截方法执行。不能期望在同一事务中登记其他资源。通常的结果是正常情况下一切没有问题，但只要有一个异常，用户会发现其中一个资源没有回滚。导致此问题的典型错误是使用 `DataSourceTransactionManager` 和使用 Hibernate 来实现仓库。

## 该使用哪个模式呢？

我将通过分析这些模式的利弊得出结论，帮助你了解如何在它们之间做出决定。第一步是确认你有一个需要分布式事务的系统。一个必要的（但不是充分的）条件是存在具有多于一个事务资源的单个进程；一个充分的条件是这些资源在单个用例中一起使用，通常由对你的架构中的服务级别的调用驱动。

如果你还没有分辨出分布式事务，你可能已经实现了**飞行之翼**模式。迟早你会看到应该已回滚但并没有回滚的数据。可能在真实的错误发生很久后你才能看到所造成的影响，这时已经很难追溯回失败的源头。开发人员可能会不小心使用飞行之翼模式，因为他们认为 XA 已经在发挥作用，但实际上没有配置基础资源来参与事务。我曾经在一个项目上工作，其中数据库已被另一个组安装，并且在安装过程中关闭了 XA 支持。系统运行了好几个月，然后奇怪的错误开始渗透到业务流程中。诊断这个问题花了很长时间。

如果你的混合资源用例很简单，可以负担得起分析和重构，那么**非事务资源**模式可能是一种选项。当其中一个资源主要是读取，写入操作可以通过对重复项的检查来保护时，这种模式最有效。即使在失败之后，非事务性资源中的数据也必须在业务中有意义。审核、版本控制和日志记录信息通常适用于此类别。在这个模式中，失败将是相对常见的（任何时候都有可能发生事务回滚），但你可以相信这个没有副作用。

**Best Efforts 1PC** 适用于要求失败率低，且不希望有像 2PC 那么大的开销的系统。选择这个模式带来的性能提升是很显著的。它的设置比非事务性资源更为棘手，但它不需要那么多的分析，并且用于更通用的数据类型。绝对的数据一致性要求业务处理对「外部」资源（除第一次以外的任一次提交）都是幂等的。消息驱动的数据库更新是一个完美的例子，Spring 对它已经有相当好的支持。更不常见的情况需要一些额外的框架代码（这些框架代码可能最终会是 Spring 的一部分）。

**共享资源**模式非常适用于特殊情况，通常涉及两个特定类型和平台的资源（例如 ActiveMQ 与任何 RDBMS 或 Oracle AQ 与 Oracle 数据库位于同一位置）。这个模式的优点是极强的鲁棒性和卓越的性能。

> #### 样例代码更新
>
> 由于 Spring 版本的新版本和其他组件的发布，本文提供的[示例代码](http://images.techhive.com/downloads/idge/imported/article/jvw/2009/01/springxa-src.zip)将不可避免地过时。请参阅 [Spring 社区网站](http://www.springframework.org/)以访问作者的最新代码，以及 Spring Framework 和相关组件的最新版本。

**Full XA with 2PC** 是通用的，并且总是有最高的置信度、最强的保护以防止在使用多个不同资源的情况下发生故障。缺点是，这个模式很昂贵，因为协议规定了额外的 I/O（但不要写，直到你尝试它），还需要特殊用途的平台。有开源 JTA 实现了这种模式，可以提供摆脱应用程序服务器的方法，但许多开发人员仍然认为这种方式是次优的。当然，更多人没有花时间思考他们系统中的事务边界就选择了使用使用 JTA 和 XA。至少如果他们使用 Spring，他们的业务逻辑就不需要知道事务是如何被处理的，因此可以延迟平台选择。

Dr. [David Syer](mailto:david.syer@springsource.com) 是 SpringSource 的首席顾问，常驻英国。他是 Spring Batch 项目的创始人和首席工程师，Spring Batch 是一个用于构建和配置离线和批处理应用程序的开源框架。他经常主持关于企业 Java 和行业评论员的会议。最近的出版物可以在 The Server Side, InfoQ 和 SpringSource 博客找到。

### 更多参考资料

*   下载这篇文章的[源代码](http://images.techhive.com/downloads/idge/imported/article/jvw/2009/01/springxa-src.zip)。也别忘了访问 [Spring 社区网站](http://www.springframework.org/)获取这篇文章的最新代码。
*   从 Java 文档中学习更多关于 `javax.transaction` 的 [JTA](http://java.sun.com/javaee/5/docs/api/javax/transaction/package-frame.html) 和 [`XAResource`](http://java.sun.com/javase/6/docs/api/javax/transaction/xa/XAResource.html) 的知识。
*   “[使用 XA 的 Spring](http://www.javaworld.com/javaworld/jw-04-2007/jw-04-xa.html)”（Murali Kosaraju, JavaWorld, April 2007）解释了如何在 Java EE 容器外用 JTA 配置 Spring。
*   “[深入 XA，第二部分](http://jroller.com/pyrasun/category/XA)”（Mike Spille, Pyrasun, The Spille Blog, April 2004）是一篇非常好的文章帮助深度了解 2PC。
*   阅读 _Spring_ 参考指南，[第九章 事务管理](http://static.springframework.org/spring/docs/2.5.x/reference/transaction.html)，来深入了解 Spring 事务管理的工作原理，如何配置 Spring 事务管理。
*   “[J2EE 1.2 中的事务管理](http://www.javaworld.com/jw-07-2000/jw-0714-transaction.html)”（Sanjay Mahapatra, JavaWorld, July 2000）定义了事务的 ACID 属性，包括原子性。
*   在“[用 XA 还是不用 XA](http://guysblogspot.blogspot.com/2006/10/to-xa-or-not-to-xa.html)”（Guy's Blog, October 2006）中，Atomikos 的 CTO Guy Pardon 支持使用 XA。
*   阅读 [Atomikos documentation](http://www.atomikos.com/Documentation/WebHome) 来了解这个开源的事务管理器。
*   “[如何在 Oracle 中创建数据库链接](http://searchoracle.techtarget.com/tip/0,289483,sid41_gci1263933,00.html)”（Elisa Gabbert, SearchOracle.com, January 2004）解释了如何创建 Oracle 数据库链接。
*   权衡这个为 Spring 框架[提供一个开箱即用的 "best efforts" 1PC 事务管理器](http://jira.springframework.org/browse/SPR-3844)的提案。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
