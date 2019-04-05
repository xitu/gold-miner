> * 原文地址：[Distributed transactions in Spring, with and without XA - Part II](https://www.javaworld.com/article/2077963/distributed-transactions-in-spring--with-and-without-xa.html?page=2)
> * 原文作者：[David Syer](mailto:david.syer@springsource.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * 译者：[xiantang](https://github.com/xiantang)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)

# Spring 的分布式事务实现 — 使用和不使用 XA — 第二部分

> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md)
> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md)

一个共享的数据库资源有时可以从现有的单独资源中被合成，特别是如果它们都在相同的 RDBMS 平台上。企业级别的数据库供应商都支持同义词（或等价物）的概念，其中一个模式（Oracle 术语）中的表在另一个模式内被定义为同义词。这样的话，在平台中的物理数据可以被 JDBC 客户端中的相同的 `Connection` 进行事务处理。例如，在真实系统中（作为对照）在 ActiveMQ 中实现共享事务资源模式，将会经常为涉及消息传递和业务数据创建同义词。

> #### 性能和 JDBCPersistenceAdapter
>
> 在 ActiveMQ 社区中的某些人声称 `JDBCPersistenceAdapter` 会造成性能问题。然而，许多项目和实时系统将 ActiveMQ 和关系型数据库一同使用。在这些情况下，收到的明智的建议是使用日志版本用于提高性能。这不适用于共享事务资源模式（因为日志本事是一个新的事务资源）。尽管如此，陪审团仍然在关注 `JDBCPersistenceAdapter`。并且事实上有理由认为共享事务资源可能会**提高**。性能在日志方面。这是 Spring 和 ActiveMQ 工程团队之间积极研究的领域。 

非消息方案（多数据库）的另一种共享资源的技术是使用 Oracle 数据的链接功能在 RDBMS 平台将两个数据库模式链接在一起（请参阅资料）。这可能需要修改应用程序的代码，或者创建同义词，因为引用链接数据库的表名的别名包含了链接的名称。

## 最大努力单阶段提交模式

最大努力单阶段提交模式是相当普遍的，但在开发人员必须注意的某些情况下可能会失败。这是一种非 XA 模式，涉及了许多资源的同步单阶段提交。因为没有使用二阶段提交，它绝不会像 XA 事务那样安全，但是如果参与者意识到妥协，通常就足够了。许多高容量，高吞吐量的事务处理系统通过设置这种方式以达到提高性能的目的。

基本思想是在事务中尽可能晚地延迟所有资源的提交，以便唯一可能出错的是基础设施故障（而不是业务处理错误）。系统依赖于最大努力单阶段提交模式的原因是基础设施故障非常罕见，以至于他们能够承担风险以换取更高的吞吐量。如果业务处理服务也被设计成幂等，那么在实战中几乎不可能出现错误。

为了帮助你更好地理解模式并分析失败的后果，我将使用消息驱动的数据库更新作为示例。

此事务中的两个资源计入并计算在内。消息事务在数据库之前启动，并以相反的顺序结束（提交或回滚）。因此，成功案例中的顺序可能与本文开头的顺序相同：

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

触发回滚的确切机制并不重要，有几个可用。重要的是，提交或回滚的发生方式与资源中业务排序的顺序相反。在示例应用程序中，消息传递事务必须最后提交，因为业务流程的指令被包含在该资源中。这很重要，因为会发生第一次提交成功并且第二次提交失败的（罕见）故障情况。因为通过设计，此时所有业务处理已经完成，所以这种部分故障的唯一原因将是消息传递中间件的基础设施问题。

请注意，如果数据库资源的提交失败，则净效果仍然是回滚。因此，唯一的非原子失败模式是第一个事务提交而第二个事务回滚。更普遍的情况下，如果事务中存在 `n` 个资源，存在 `n-1` 这样的失败模式，在回滚之后会使资源存在不一致(已提交)状态。在消息数据库的用例中，此失败模式的结果是消息被回滚并返回到另一个事务中，即使它已经成功处理。因此，您可以推测到可能发生的更糟糕的事情是可以传递重复的消息。在更普遍的情况下，因为事务中较早的资源被认为可能携带有关如何对后来的资源进行处理的信息，所以失败模式的最终结果通常可以称为**消息重复**。

有些人承担了重复消息不经常发生的风险，以至于他们不会费心去预测它们。但是，为了对业务数据的正确性和一致性更有信心，您需要在业务逻辑中了解它们。如果你在业务处理中意识到重复的消息可能会发生，那么所有必须做的事情（通常需要一些额外的成本，但不如 2PC 那么多）是检查它是否已经处理过该数据，如果有，则不执行任何操作。此专业化有时称为幂等业务服务模式。

示例代码包括使用此模式同步事务资源的两个示例。我将依次讨论每一个，然后测试一些其他选项。

## Spring 和消息驱动的 POJO

在[示例代码](http://images.techhive.com/downloads/idge/imported/article/jvw/2009/01/springxa-src.zip)的 `best-jms-db project,` 参与者使用主流配置选项进行设置，以便遵循最大努力单阶段提交模式。这个想法是发送到队列的消息由异步监听器收集并用于将数据插入数据库的表中。

这个 `TransactionAwareConnectionFactoryProxy` — Spring 中的一个组件，旨在用于这种模式 — 是关键因素。使用配置将 `ConnectionFactory` 包装在处理事务同步的装饰器中，而不是使用原始供应商提供的 `ConnectionFactory`。这发生在 `jms-context.xml,` 如示例 6 所示:

#### 示例 6. 配置一个`TransactionAwareConnectionFactoryProxy` 来包装供应商提供的 `ConnectionFactory`

```xml
<bean id="connectionFactory"
  class="org.springframework.jms.connection.TransactionAwareConnectionFactoryProxy">
  <property>
    <bean class="org.apache.activemq.ActiveMQConnectionFactory" depends-on="brokerService">
      <property/>
    </bean>
  </property>
  <property/>
</bean>
```

`ConnectionFactory` 不需要知道要与哪个事务管理器同步，因为在需要时只有一个事务处于活动状态，而 Spring 可以在内部处理它。驱动事务由 `data-source-context.xml` 中配置的普通 `DataSourceTransactionManager` 处理。需要了解的是事务管理器的组件是将轮询和接收消息的JMS监听器容器：

```xml
<jms:listener-container transaction-manager="transactionManager">
  <jms:listener destination="async" ref="fooHandler" method="handle"/>
</jms:listener-container>
```

 `fooHandler` 和 `method` 告诉监听器容器当消息到达 `async` 队列时，哪个组件要调用哪个方法。处理程序是这样实现的，接受一个 `String` 作为传入消息，并使用它来插入记录：

```java
public void handle(String msg) {

  jdbcTemplate.update(
      "INSERT INTO T_FOOS (ID, name, foo_date) values (?, ?,?)", count.getAndIncrement(), msg, new Date());

}
```

为了模拟失败的情况，代码使用了 `FailureSimulator` 切面。它检查消息内容以查看它是否应该失败，以及以何种方式。示例 7 中所示的 `maybeFail()` 方法在 `FooHandler` 处理消息之后调用，但在事务结束之前调用，以便它可以影响事务的结果：

#### 示例 7. `maybeFail()` 方法

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

 `simulateBusinessProcessingFailure()` 方法只抛出一个 `DataAccessException`，好像数据库访问失败一样。当触发此方法时，您期望完全回滚所有数据库和消息事务。此方案在示例项目的 `AsynchronousMessageTriggerAndRollbackTests` 单元测试中进行了测试。

 `simulateMessageSystemFailure()` 方法通过削弱底层 JMS `Session` 来模拟消息传递系统中的失败。这里的预期结果是部分提交：数据库工作保持提交但消息回滚。这是在 `AsynchronousMessageTriggerAndPartialRollbackTests` 单元测试中测试的。

示例包还包括在 `AsynchronousMessageTriggerSunnyDayTests` 类中成功提交所有事务工作的单元测试。

相同的JMS配置和相同的业务逻辑也可以在同步设置中使用，其中消息在业务逻辑内的阻塞调用中接收，而不是委托给侦听器容器。这种方法也在 `best-jms-db` 示例项目中得到了证明。sunny-day 案例和完整回滚分别在 `SynchronousMessageTriggerSunnyDayTests` 和 `SynchronousMessageTriggerAndRollbackTests` 中进行测试。

## 链接事务管理器

在最大努力单阶段提交模式的另一个示例（`best-db-db` 项目）中，事务管理器的粗略实现只是将其他事务管理器的列表链接在一起以实现事务同步。如果业务处理成功，他们都会提交，如果不是，他们都会回滚。

实现在 `ChainedTransactionManager` 中，它接受其他事务管理器的列表作为注入属性，如示例 8 所示：

#### 示例 8. ChainedTransactionManager 的配置

```xml
<bean id="transactionManager" class="com.springsource.open.db.ChainedTransactionManager">
  <property>
    <list>
      <bean
        class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property/>
      </bean>
      <bean
        class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property/>
      </bean>
    </list>
  </property>
</bean>
```

对此配置最简单的测试就是在两个数据库中插入内容，回滚并检查两个操作是否都没有留下痕迹。这是作为 `MulipleDataSourceTests` 中的单元测试实现的，与 XA 示例的 `atomikos-db` 项目中的相同。如果回滚未同步但提交失败，则测试失败。

请记住，资源的顺序很重要。它们是嵌套的，并且提交或回滚的顺序与它们被登记的顺序相反（这是配置中的顺序）。这使得其中一个资源变得特殊：如果出现问题，最外层资源总会回滚，即使唯一的问题是该资源的故障。此外，`testInsertWithCheckForDuplicates()` 测试方法显示了一个幂等的业务流程，可以保护系统免受部分故障的影响。它被实现为对内部资源（在这种情况下为 `otherDataSource`）的业务操作的防御性检查：

```java
int count = otherJdbcTemplate.update("UPDATE T_AUDITS ... WHERE id=, ...?");
if (count == 0) {
  count = otherJdbcTemplate.update("INSERT into T_AUDITS ...", ...);
}
```

首先使用 `where` 子句尝试更新。如果没有任何反应，则插入您希望在更新中找到的数据。在这种情况下，对幂等过程的额外保护的成本是在 sunny-day 案例中的一个额外查询（更新）。在更复杂的业务流程中，此成本将非常低，其中每个事务执行许多查询。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
