> * 原文地址：[Distributed transactions in Spring, with and without XA - Part I](https://www.javaworld.com/article/2077963/distributed-transactions-in-spring--with-and-without-xa.html)
> * 原文作者：[David Syer](mailto:david.syer@springsource.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md)
> * 译者：[JackEggie](https://github.com/JackEggie)
> * 校对者：[fireairforce](https://github.com/fireairforce)

# Spring 的分布式事务实现 — 使用和不使用 XA — 第一部分

> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-1.md)
> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-2.md)
> * [Spring 的分布式事务实现 — 使用和不使用 XA — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/distributed-transactions-in-spring-with-and-without-xa-part-3.md)

> Spring 的 7 种事务处理模式

虽然在 Spring 中分布式事务通常使用 Java Transaction API 和 XA 协议实现，但也有其他的实现方式。最好的实现方式取决于应用程序所使用资源的类型，以及你是否愿意在性能、安全性、可靠性和数据完整性之间做出权衡。针对这个 Java 中的典型问题，Spring 的开发者 David Syer 将会介绍 7 种 Spring 分布式应用的实现方式，其中 3 种实现使用了 XA 协议，另外 4 种使用了其他的实现方式。（中级知识点）

Spring 框架对 Java Transaction API (JTA) 的支持使应用程序能够[无需在 Java EE 容器中](http://www.javaworld.com/javaworld/jw-04-2007/jw-04-xa.html)即可使用分布式事务和 XA 协议。然而，即使有了这种支持，XA 的性能开销仍然很大，而且可能不可靠并且难于管理。不过令人惊喜的是，某种特定类型的应用程序可以完全避免使用 XA 来实现分布式事务。

为了让你对分布式事务的各种实现方式有充分的理解和思考，我将详细分析这 7 种事务处理模式，并提供代码示例帮助你理解得更具体。我将根据安全性和可靠性来依次介绍这些模式，从通常来说数据完整性和原子性程度最高的模式开始。当你按顺序浏览时，你会看到越来越多的警示说明和限制条件。这些模式的性能开销也大致相反（从开销最大的模式开始）。与编写业务代码完全不同的是，这些模式都是从架构复杂度和技术难度考虑的，所以我不会关心业务用例，只关心使每种模式正常工作的最小代码量。

注意，只有前三种模式涉及 XA。而从性能的角度考虑，这些模式可能无法使用或性能差到不可接受。我不会像介绍其他模式那样对 XA 模式有详细的讨论，因为 XA 在其他地方已经有很多介绍了，不过我提供了第一个模式（基于 XA）的简单示例。通过阅读本文，你将了解使用分布式事务可以做什么、不能做什么，何时使用 XA、何时不使用 XA，以及如何避免使用 XA。

## 分布式事务及其原子性

一个**分布式事务**通常包含多个事务资源。事务资源是指关系型数据库和消息中间件的连接。一个典型的事务资源都会有像 `begin()`、`rollback()`、`commit()` 这样的 API。在 Java 中，一个事务资源通常表现为底层连接工厂提供的实例：对于数据库来说，就是 `Connection` 对象（由 `DataSource` 提供）或是 [Java Persistence API](http://www.javaworld.com/javaworld/jw-01-2008/jw-01-jpa1.html)（JPA）的 `EntityManager` 对象；对于 [Java Message Service](http://www.javaworld.com/jw-01-1999/jw-01-jms.html)（JMS）来说，则是 `Session` 对象。

在一个典型的例子中，一个 JMS 消息触发了数据库的更新。根据时间先后顺序，一次成功的交互过程如下：

1.  启动消息事务
2.  **接收消息**
3.  启动数据库事务
4.  **更新数据库**
5.  提交数据库事务
6.  提交消息事务

如果数据库在更新数据时报错（如约束冲突），理想的交互顺序如下：

1.  启动消息事务
2.  **接收消息**
3.  启动数据库事务
4.  **更新数据库失败！**
5.  回滚数据库事务
6.  回滚消息事务

在这个例子中，消息在最后回滚完成之后回到了中间件，在某个时刻将再次提交到另一个事务中。这通常是一件好事，因为如果这样做的话更新数据时发生的错误将会被记录下来。（自动重试和异常处理的机制超出了本文的讨论范围。）

上述两个例子中最重要的特点就是**原子性**，逻辑上来说，一个事务要么完全成功，要么完全失败。

那么是什么保证了上面两个例子在流程上的一致性呢？我们必须在事务资源之间进行一些同步，以便在一个事务提交之后，另一个事务才能提交。否则，整个事务就不是原子性的。因为涉及多个资源，所以事务是分布式的。如果不进行同步，事务就不会是原子性的。分布式事务的理论和实现上的困难都与资源的同步（或缺少资源）有关。

下面讨论的前三个模式都是基于 XA 协议的。由于这些模式已经被普及，所以在这里我不会介绍得很详细。如果你对 XA 的模式非常熟悉，你可以直接跳到[共享事务资源模式](#共享事务资源模式)。

## 完整的 XA 协议与两阶段提交（2PC）

如果你需要确保应用程序的事务在服务器宕机（服务器崩溃或断电）之后仍能够恢复，那么完整的 XA 协议是你唯一的选择。在下面的例子中，用于同步事务的共享资源是一个特殊的事务管理器，它使用 XA 协议协调了进程的信息。在 Java 中，从开发者的角度来看，该协议是通过 JTA 的 `UserTransaction` 对象暴露出来的。

作为一个系统接口，XA 是大多数开发者从未见过的一种底层技术。开发者需要知道 XA 协议的存在、它能做什么、性能消耗如何，以及它是如何操作事务资源的。性能消耗来自于[两阶段提交](http://www.javaworld.com/jw-07-2000/jw-0714-transaction.html)（2PC）协议，事务管理器使用该协议来确保所有资源能在事务结束前就事务的结果达成一致。

如果应用程序是基于 Spring 构建的，它将使用 Spring 中的 `JtaTransactionManager` 和 Spring 声明性事务管理来隐藏底层同步的细节。对于开发者来说，使用 XA 与否取决于工厂资源的配置方式：在应用程序中如何配置 `DataSource` 实例和事务管理器。本文包含了一个示例应用程序（`atomikos-db` 项目），它演示了这种配置方式。该应用程序中只有 `DataSource` 实例和事务管理器是基于 XA 或者 JTA 的。

要查看示例的运行方式，请运行 `com.springsource.open.db` 下的单元测试。`MulipleDataSourceTests` 类向两个数据源插入了数据，然后使用 Spring 的集成支持特性将事务回滚，如清单 1 所示：

#### 清单 1. 事务回滚

```java
@Transactional
  @Test
  public void testInsertIntoTwoDataSources() throws Exception {

    int count = getJdbcTemplate().update(
        "INSERT into T_FOOS (id,name,foo_date) values (?,?,null)", 0,
        "foo");
    assertEquals(1, count);

    count = getOtherJdbcTemplate()
        .update(
            "INSERT into T_AUDITS (id,operation,name,audit_date) values (?,?,?,?)",
            0, "INSERT", "foo", new Date());
    assertEquals(1, count);

    // 数据的变更将在此方法退出后回滚

  }
```

然后 `MulipleDataSourceTests` 将会验证这两个操作都回滚完成，如清单 2 所示：

#### 清单 2. 验证回滚

```java
@AfterTransaction
  public void checkPostConditions() {

    int count = getJdbcTemplate().queryForInt("select count(*) from T_FOOS");
    // 该数据变更已被测试框架回滚
    assertEquals(0, count);

    count = getOtherJdbcTemplate().queryForInt("select count(*) from T_AUDITS");
    // 由于 XA 的存在，该数据变更也被回滚了
    assertEquals(0, count);

  }
```

为了更好地理解 Spring 事务管理的工作原理以及配置的方式，请参阅 [Spring 参考文档](http://static.springframework.org/spring/docs/2.5.x/reference/new-in-2.html#new-in-2-middle-tier)。

## XA 与 1PC 优化

这种模式通过避免 2PC 的性能开销对许多只包含单资源事务的事务管理器进行了优化。你将会希望你的应用程序服务能够借此解决这个问题。

## XA 与最终资源策略

XA 事务管理器的另一个特性是，当除某一个资源外的所有资源都支持 XA 时，它仍然可以提供与所有资源都支持 XA 时相同的数据恢复保证。通过对资源进行排序，并使非 XA 资源参与决策来实现该特性。如果提交失败，则回滚所有其他资源。这几乎是 100% 的完全性保证，但还不够完美。当提交失败时，除非采取额外的措施（在一些高端实现中有这样的实现），否则报错的跟踪信息会很少。

## 共享事务资源模式

在某些系统中，为了降低复杂性和增加吞吐量，一种较好的模式是通过确保系统中的所有事务资源实际上都是同一个资源的不同形式，从而完全消除对 XA 的依赖。显然，这在所有的用例中都是不可能的，但这种模式与 XA 一样可靠，而且通常要快得多。这样的共享事务资源模式是足够可靠的，但只限于某些特定的平台和处理场景。

有一个这种模式的简单例子对很多人来说都很熟悉，即在对象关系映射（ORM）组件和 [JDBC](http://www.javaworld.com/javaworld/jw-05-2006/jw-0501-jdbc.html) 组件之间共享数据库的 `Connection`。这就是你使用支持 ORM 工具的 Spring 事务管理器时所发生的事情，如 [Hibernate](http://www.javaworld.com/javaworld/jw-10-2004/jw-1018-hibernate.html)、[EclipseLink](http://www.eclipse.org/eclipselink/) 和 [Java Persistence API](http://www.javaworld.com/javaworld/jw-01-2008/jw-01-jpa1.html)（JPA）。同一个事务可以安全地跨 ORM 和 JDBC 组件使用，该执行过程通常由控制事务的服务级方法来实现。

该模式的另一个有效用法是单个数据库的消息驱动更新（如本文中介绍的简单例子所示）。消息中间件系统需要将数据存储在某个地方，通常是关系数据库中。要实现此模式，只需指定消息传递系统的目标数据库为同一个业务数据库即可。此模式需要消息中间件的供应商公开其存储策略的详细信息，以便可以将其配置指向相同的数据库并挂接到相同的事务中。

并不是所有的供应商都能做到这一点。另一种适用于几乎所有数据库的方式，是使用 [Apache ActiveMQ](http://activemq.apache.org/) 进行消息传递并将存储策略配置到消息代理服务器中。了解其中的技巧，配置起来就会非常简单。本文的 `shared-jms-db` 示例项目展示了这种配置方式。应用程序的代码中（在本例中是单元测试）不需要感知这种模式的使用，因为它已经在 Spring 配置中已经以声明方式被启用了。

示例中名为 `SynchronousMessageTriggerAndRollbackTests` 的单元测试验证了所有同步消息的接收处理。`testReceiveMessageUpdateDatabase` 方法接收了两条消息，并将这两条消息中的数据记录插入到数据库中。当退出该方法时，测试框架将会回滚当前的事务，接下来你就可以验证消息和数据库更新都已经回滚，如清单 3 所示：

#### 清单 3. 验证消息和数据库更新的回滚

```java
@AfterTransaction
public void checkPostConditions() {

  assertEquals(0, SimpleJdbcTestUtils.countRowsInTable(jdbcTemplate, "T_FOOS"));
  List<String> list = getMessages();
  assertEquals(2, list.size());

}
```

该配置最重要的特性是 ActiveMQ 的持久化策略，它将业务数据源的消息系统连接到同一个 `DataSource`，用于接收消息的 Spring `JmsTemplate` 上的标志位也同样重要。配置 ActiveMQ 持久化策略的方式如清单 4 所示：

#### 清单 4. ActiveMQ 的持久化配置

```xml
<bean id="connectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory"
  depends-on="brokerService">
  <property vm://localhost?async=false" />
</bean>

<bean id="brokerService" class="org.apache.activemq.broker.BrokerService" init-method="start"
  destroy-method="stop">
    ...
  <property >
    <bean class="org.apache.activemq.store.jdbc.JDBCPersistenceAdapter">
      <property >
        <bean class="com.springsource.open.jms.JmsTransactionAwareDataSourceProxy">
          <property />
          <property />
        </bean>
      </property>
      <property  />
    </bean>
  </property>
</bean>

```

用于接收消息的 Spring `JmsTemplate` 上的标志位配置如清单 5 所示：

#### 清单 5. 为事务配置 `JmsTemplate`

```xml
<bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate">
  ...
  <!-- 这很重要... -->
  <property  />
</bean>
```

如果没有设置 `sessionTransacted=true`，就永远不会执行 JMS 会话事务的 API 调用，并且消息的接收将无法回滚。这里重要的一点是嵌入式消息代理服务器中的特殊参数 `async=false` 和对 `DataSource` 的包装，他们共同确保了 ActiveMQ 和 Spring 共同使用了同一个 JDBC 事务的 `Connection`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
