> * 原文地址：[Distributed transactions in Spring, with and without XA - Part II](https://www.javaworld.com/article/2077963/distributed-transactions-in-spring--with-and-without-xa.html?page=2)
> * 原文作者：[David Syer](mailto:david.syer@springsource.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * 译者：
> * 校对者：

# Spring 的分布式事务实现-使用和不使用XA - 第二部分

> * [Spring 的分布式事务实现-使用和不使用XA - 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md)
> * [Spring 的分布式事务实现-使用和不使用XA - 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * [Spring 的分布式事务实现-使用和不使用XA - 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md)

一个共享的数据库资源有时可以从现有的单独资源中被合成，特别是如果它们都在相同的 RDBMS 平台上。企业级别的数据库供应商都支持同义词（或等价物）的概念，其中一个模式（Oracle 术语）中的表在另一个模式内被定义为同义词。这样的话，在平台中的物理数据可以被 JDBC 客户端中的相同的 `Connection` 进行事务处理。例如，在真实系统中（作为对照）在 ActiveMQ 中实现共享事务资源模式，将会经常为涉及消息传递和业务数据创建同义词。

> #### 性能和 JDBCPersistenceAdapter 
>
> 在 ActiveMQ 社区中的某些人声称 `JDBCPersistenceAdapter` 会造成性能问题。然而，许多项目和实时系统将 ActiveMQ 和关系型数据库一同使用。在这些情况下，收到的明智的建议是使用日志版本用于提高性能。这不适用于共享事务资源模式（因为日志本事是一个新的事务资源）。尽管如此，陪审团仍然在关注 `JDBCPersistenceAdapter`。并且事实上有理由认为共享事务资源可能会 _提高_
性能在日志方面。这是 Spring 和 ActiveMQ 工程团队之间积极研究的领域。   
非消息方案（多数据库）的另一种共享资源的技术是使用 Oracle 数据的链接功能在 RDBMS 平台将两个数据库模式链接在一起（请参阅资料）。这可能需要修改应用程序的代码，或者创建同义词，因为引用链接数据库的表名的别名包含了链接的名称。

## 最大努力单阶段提交模式

最大努力单阶段提交模式是相当普遍的，但在开发人员必须注意的某些情况下可能会失败。这是一种非 XA 模式，涉及了许多资源的同步单阶段提交。 因为没有使用二阶段提交，它绝不会像 XA 事务那样安全，但是如果参与者意识到妥协，通常就足够了。许多高容量，高吞吐量的事务处理系统通过设置这种方式以达到提高性能的目的。

基本思想是在事务中尽可能晚地延迟所有资源的提交，以便唯一可能出错的是基础设施故障（而不是业务处理错误）。系统依赖于最大努力单阶段提交模式的原因是基础设施故障非常罕见，以至于他们能够承担风险以换取更高的吞吐量。如果业务处理服务也被设计成幂等，那么在实战中几乎不可能出现错误。

为了帮助你更好地理解模式并分析失败的后果，我将使用消息驱动的数据库更新作为示例。

此事务中的两个资源计入并计算在内。消息事务在数据库之前启动，并以相反的顺序结束（提交或回滚）。 因此，成功案例中的顺序可能与本文开头的顺序相同：

1.  开启消息事务
2.  **接受消息**
3.  开始数据库事务
4.  **更新数据库**
5.  提交数据库事务
6.  提交消息事务

实际上，前四个步骤的顺序并不关键，除了必须在更新数据库之前接收消息，并且每个事务必须在使用其相应资源之前开始。所以这个序列同样有效：

1.  开启消息事务
2.  开始数据库事务
3.  **接受消息**
4.  **更新数据库**
5.  提交数据库事务
6.  提交消息事务

关键在于最后两个步骤很重要：它们必须按此顺序排在最后。顺序很重要的原因是因为技术性，但是业务需求也决定了顺序本事。这个顺序告诉你在这种情况下的事务资源是特殊的。它包含了关于如何去执行另一项工作的说明。这是一个业务排序：系统无法自动的判断如何排序（尽管如果消息和数据是两个资源，那么它通常按照如此顺序）。排序很重要的原因是因为它和失败情况相关。最常见的故障情况（到目前为止）是业务处理失败（错误数据，编程错误等）。在这种情况下，可以轻松地操纵这两个事务以响应异常和回滚。在这种情况下，业务数据的完整性得以保留，时间线类似于本文开头概述的理想故障情况。

触发回滚的确切机制并不重要，有几个可用。 重要的是，提交或回滚的发生方式与资源中业务排序的顺序相反。 在示例应用程序中，消息传递事务必须最后提交，因为业务流程的指令被包含在该资源中。这很重要，因为会发生第一次提交成功并且第二次提交失败的（罕见）故障情况。 因为通过设计，此时所有业务处理已经完成，所以这种部分故障的唯一原因将是消息传递中间件的基础设施问题。

Note that if the commit of the database resource fails, then the net effect is still a rollback. So the only nonatomic failure mode is one where the first transaction commits and the second rolls back. More generally, if there are `n` resources in the transaction, there are `n-1` such failure modes leaving some of the resources in an inconsistent (committed) state after a rollback. In the message-database use case, the result of this failure mode is that the message is rolled back and comes back in another transaction, even though it was already successfully processed. So you can safely assume that the worse thing that can happen is that duplicate messages can be delivered. In the more general case, because the earlier resources in the transaction are considered to be potentially carrying information about how to carry out processing on the later resources, the net result of the failure mode can generically be referred to as _duplicate message_.

Some people take the risk that duplicate messages will happen infrequently enough that they don't bother trying to anticipate them. To be more confident about the correctness and consistency of your business data, though, you need to be aware of them in the business logic. If the business processing is aware that duplicate messages might arrive, all it has to do (usually at some extra cost, but not as much as the 2PC) is check whether it has processed that data before and do nothing if it has. This specialization is sometimes referred to as the Idempotent Business Service pattern.

The sample codes includes two examples of synchronizing transactional resources using this pattern. I'll discuss each in turn and then examine some other options.

## Spring and message-driven POJOs

In the [sample code](http://images.techhive.com/downloads/idge/imported/article/jvw/2009/01/springxa-src.zip)'s `best-jms-db project,` the participants are set up using mainstream configuration options so that the Best Efforts 1PC pattern is followed. The idea is that messages sent to a queue are picked up by an asynchronous listener and used to insert data into a table in the database.

The `TransactionAwareConnectionFactoryProxy` -- a stock component in Spring designed to be used in this pattern -- is the key ingredient. Instead of using the raw vendor-provided `ConnectionFactory`, the configuration wraps `ConnectionFactory` in a decorator that handles the transaction synchronization. This happens in the `jms-context.xml,` as shown in Listing 6:

#### Listing 6. Configuring a `TransactionAwareConnectionFactoryProxy` to wrap a vendor-provided JMS `ConnectionFactory`

```xml
<bean id="connectionFactory"
  class="org.springframework.jms.connection.TransactionAwareConnectionFactoryProxy">
  <property >
    <bean class="org.apache.activemq.ActiveMQConnectionFactory" depends-on="brokerService">
      <property />
    </bean>
  </property>
  <property  />
</bean>
```

There is no need for the `ConnectionFactory`to know which transaction manager to synchronize with, because only one transaction active will be active at the time that it is needed, and Spring can handle that internally. The driving transaction is handled by a normal `DataSourceTransactionManager` configured in `data-source-context.xml`. The component that needs to be aware of the transaction manager is the JMS listener container that will poll and receive messages:

```xml
<jms:listener-container transaction-manager="transactionManager" >
  <jms:listener destination="async" ref="fooHandler" method="handle"/>
</jms:listener-container>
```

The `fooHandler` and `method` tell the listener container which method on which component to call when a message arrives on the "async" queue. The handler is implemented like this, accepting a `String` as the incoming message, and using it to insert a record:

```java
public void handle(String msg) {

  jdbcTemplate.update(
      "INSERT INTO T_FOOS (ID, name, foo_date) values (?, ?,?)", count.getAndIncrement(), msg, new Date());

}
```

To simulate failures, the code uses a `FailureSimulator` aspect. It checks the message content to see if it supposed to fail, and in what way. The `maybeFail()` method, shown in Listing 7, is called after the `FooHandler` handles the message, but before the transaction has ended, so that it can affect the transaction's outcome:

#### Listing 7. The `maybeFail()` method

```java
@AfterReturning("execution(* *..*Handler+.handle(String)) && args(msg)")
public void maybeFail(String msg) {
  if (msg.contains("fail")) {
    if (msg.contains("partial")) {
      simulateMessageSystemFailure();
    } else {
      simulateBusinessProcessingFailure();
    }
  }    
}
```

The `simulateBusinessProcessingFailure()` method just throws a `DataAccessException` as if the database access had failed. When this method is triggered, you expect a full rollback of all database and message transactions. This scenario is tested in the sample project's `AsynchronousMessageTriggerAndRollbackTests` unit test.

The `simulateMessageSystemFailure()` method simulates a failure in the messaging system by crippling the underlying JMS `Session`. The expected outcome here is a partial commit: the database work stays committed but the messages roll back. This is tested in the `AsynchronousMessageTriggerAndPartialRollbackTests` unit test.

The sample package also includes a unit test for the successful commit of all transactional work, in the `AsynchronousMessageTriggerSunnyDayTests` class.

The same JMS configuration and the same business logic can also be used in a synchronous setting, where the messages are received in a blocking call inside the business logic instead of delegating to a listener container. This approach is also demonstrated in the `best-jms-db` sample project. The sunny-day case and the full rollback are tested in `SynchronousMessageTriggerSunnyDayTests` and `SynchronousMessageTriggerAndRollbackTests`, respectively.

## Chaining transaction managers

In the other sample of the Best Efforts 1PC pattern (the `best-db-db` project) a crude implementation of a transaction manager just links together a list of other transaction managers to implement the transaction synchronization. If the business processing is successful they all commit, and if not they all roll back.

The implementation is in `ChainedTransactionManager`, which accepts a list of other transaction managers as an injected property, is shown in Listing 8:

#### Listing 8. Configuration of the ChainedTransactionManager

```xml
<bean id="transactionManager" class="com.springsource.open.db.ChainedTransactionManager">
  <property >
    <list>
      <bean
        class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property  />
      </bean>
      <bean
        class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property  />
      </bean>
    </list>
  </property>
</bean>
```

The simplest test for this configuration is just to insert something in both databases, roll back, and check that both operations left no trace. This is implemented as a unit test in `MulipleDataSourceTests`, the same as in the XA sample's `atomikos-db` project. The test fails if the rollback was not synchronized but the commit happened to work out.

Remember that the order of the resources is significant. They are nested, and the commit or rollback happens in reverse order to the order they are enlisted (which is the order in the configuration). This makes one of the resources special: the outermost resource always rolls back if there is a problem, even if the only problem is a failure of that resource. Also, the `testInsertWithCheckForDuplicates()` test method shows an idempotent business process protecting the system from partial failures. It is implemented as a defensive check in the business operation on the inner resource (the `otherDataSource` in this case):

```java
int count = otherJdbcTemplate.update("UPDATE T_AUDITS ... WHERE id=, ...?");
if (count == 0) {
  count = otherJdbcTemplate.update("INSERT into T_AUDITS ...", ...);
}
```

The update is tried first with a `where` clause. If nothing happens, the data you hoped to find in the update is inserted. The cost of the extra protection from the idempotent process in this case is one extra query (the update) in the sunny-day case. This cost would be quite low in a more complicated business process in which many queries are executed per transaction.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
