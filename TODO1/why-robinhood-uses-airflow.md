> * 原文地址：[Why Robinhood uses Airflow](https://robinhood.engineering/why-robinhood-uses-airflow-aed13a9a90c8)
> * 原文作者：[Vineet Goel](https://robinhood.engineering/@vineetgoel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-robinhood-uses-airflow.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-robinhood-uses-airflow.md)
> * 译者：[cf020031308](https://github.com/cf020031308)
> * 校对者：

# Robinhood 为什么使用 Airflow

Robinhood 通过定时作业批处理大量任务。这些作业涵盖了从数据分析和指标汇总到经纪业务如股息支付的范围。我们起初使用 cron 来调度这些工作，但随着它们的数量和复杂性的增加，这越来越具有挑战性：

*   **依赖管理**难。使用 cron，我们得用上游作业的最坏预期时长来安排下游作业。随着这些作业的复杂度及其依赖关系的成规模增加，这越来越难。
*   **失败处理**和警报必须由作业管理。在存在依赖关系的情况下，如果作业不能处理重试和上游故障，就只能靠工程师随叫随到。
*   **回溯**难。我们得筛查日志或警报来检查作业在过去某一天的表现。

为了满足调度需求，我们决定放弃 cron，将其替换为能解决上述问题的东西。我们调研了一些开源替代品，如 [Pinball](https://github.com/pinterest/pinball)， [Azkaban](https://azkaban.github.io/) 以及 [Luigi](https://github.com/spotify/luigi)，最终决定用 [Airflow](http://pythonhosted.org/airflow/index.html)。

#### Pinball

Pinball 由 Pinterest 开发，具有分布式、可水平扩展的工作流管理和调度系统的许多功能。它解决了上面提到的很多问题，但文档很少，社区相对较小。

#### Azkaban

由 LinkedIn 开发的 Azkaban 可能是我们考虑过的替代品中最古老的。它使用属性文件来定义工作流，而大多数新的替代方案使用代码。这使得定义复杂工作流程变得更加困难。

#### Luigi

由 Spotify 开发的 Luigi 拥有一个活跃的社区，可能在我们的调研中最接近 Airflow。它使用 Python 来定义工作流，并带有一个简单的 UI。但是 Luigi 没有调度程序，用户仍然需要依赖 cron 来安排作业。

### Hello Airflow!

由 Airbnb 开发的 Airflow 拥有一个持续增长的社区，似乎是最适合我们目的的。它是一个可水平扩展的分布式工作流管理系统，允许我们使用 Python 代码指定复杂的工作流。

#### 依赖管理

Airflow 使用 [运算符](https://airflow.incubator.apache.org/concepts.html#operators) 作为定义任务的基本抽象单元，并使用 [DAG](https://airflow.incubator.apache.org/concepts.html#dags)（有向无环图）通过一组运算符定义工作流。 运算符是可扩展的，这使得自定义工作流变得容易。运算符分为3种类型：

*   **动作** 执行某些操作的操作符，例如执行Python函数或提交 Spark Job。
*   **转移** 在系统之间移动数据的运算符，例如从 Hive 到 Mysql 或从 S3 到 Hive。
*   **传感器** 在满足特定条件时触发依赖网中的下游任务，例如在下游使用之前检查 S3 上的某个文件是否可用。传感器是 Airflow 的强大功能，使我们能够创建复杂的工作流程并轻松管理其前提条件。

下面是一个示例，说明不同类型的传感器如何用于典型的 ETL（[数据提取转换与加载](https://en.wikipedia.org/wiki/Extract,_transform,_load)）工作流程。该示例使用传感器运算符等待数据可用，并使用转移运算符将数据移动到所需位置。然后将动作运算符用于转换阶段，然后使用转移运算符加载结果。最后，我们使用传感器运算符来验证结果是否已正确存储。

![](https://cdn-images-1.medium.com/max/800/1*CcxrRbffqn45YwGglCyexw.png)

```
| 传感器 -> 转移 -|> 动作 -|> 转移 -> 传感器 |
|      提取       |  转换  |      加载       |
```

使用不同类型的 Airflow 操作符的 ETL 工作流程

#### 故障处理和监控

Airflow 允许我们为单个任务配置重试策略配置，并可设置在出现故障、重试以及运行的任务[长于预期](https://airflow.incubator.apache.org/concepts.html#slas)的情况下告警。Airflow 有直观的 UI，带有一些用于监控和管理作业的强大工具。它提供了作业的历史视图和控制作业状态的工具——例如，终止正在运行的作业或手动重新运行作业。 Airflow 的一个独特功能是能够使用作业数据创建图表。这使我们能够构建自定义可视化以紧密监视作业，并在排查作业和调度问题时充当一个很好的调试工具。

#### 可扩展

Airflow 运算符是使用 Python 类定义的。这使得通过扩展现有运算符来定义自定义、可重用的工作流非常容易。我们在内部构建了一大套自定义操作符，其中一些值得注意的例子是 OpsGenieOperator，DjangoCommandOperator 和 KafkaLagSensor。

#### 更智能的 Cron

Airflow DAG 是使用 Python 代码定义的。这使我们能够定义比 cron 更复杂的调度。例如，我们的一些 DAG 只需在市场开放日运行。而如果用简陋的 cron，我们得设置在所有的工作日运行，然后在应用程序中处理市场假期的情况。

我们还使用 Airflow 传感器在市场收盘后立即开始作业，即使当天只有半天开盘。以下示例通过为需要复杂的调度的工作流自定义运算符，来在给定日期根据市场时间动态更新。

![](https://cdn-images-1.medium.com/max/800/1*avVioxXl1jTrnC0rj0oEYA.png)

```
   今天开市吗？  +-- 当日休市传感器 -- Django 命令运算符
                 |
                 |
开市分支运算符 --+
                 |
                 |
   今天休市吗？  +-- Django 命令运算符
```

在给定日期根据市场时间动态调度的工作流

#### 回填

我们使用 Airflow 进行指标聚合和批量处理数据。随着需求的不断变化，我们有时需要回头更改我们汇总某些指标或添加新指标的方式。这需要能往过去任意时间段回填数据。 Airflow 提供了一个命令行工具，让我们能使用单个命令跨任意时间段进行回填，也可以从 UI 触发回填。我们使用 Celery（由我们的 [Ask Solem](https://medium.com/@asksol) 制作）往 worker box 中分发这些任务。 Celery 的分发能力使我们能够在运行回填时使用更多 worker box，从而使回填变得快捷方便。

#### 常见的陷阱和弱点

我们目前使用的是 Airflow 1.7.1.3，它在生产中运行良好，但有自己的[弱点和陷阱](https://cwiki.apache.org/confluence/display/AIRFLOW/Common+Pitfalls)。

*   **时区问题** ——Airflow 依赖系统时区（而不是 UTC）进行调度。这要求整个 Airflow 设置在同一时区运行。
*   **调度程序**分开运行预定作业和回填作业。这可能会导致奇怪的结果，例如回填不符合 DAG 的 max_active_runs 配置。
*   Airflow 主要用于数据批处理，因而其设计师决定总是**先等待一个间隔后再开始作业**。因此，对一个计划在每天午夜运行的作业，其上下文中传入的执行时间为“2016-12-31 00:00:00”，但实际却在“2017-01-01 00:00:00”才真正运行。这可能会让人感到困惑，尤其是在不定期运行的作业中。
*   **意外的回填** ——默认情况下，Airflow 会在 DAG 从暂停中恢复时或在添加一个 start_date 为过去时间的新 DAG 时尝试回填错过的任务。虽然这种行为是可预料的，但终究没有办法绕过，如果一个作业不应该回填，这就会导致问题。Airflow 1.8 引入了[最近运算符](https://github.com/apache/incubator-airflow/blob/master/airflow/operators/latest_only_operator.py) 来解决这个问题。

* * *

### 总结

Airflow 迅速发展成了我们 Robinhood 基础设施的重要组成部分。使用 Python 代码和可扩展 API 定义 DAG 的能力使 Airflow 成为可配置且功能强大的工具。希望这篇文章对于任何探索调度和工作流管理工具以满足其自身需求的人都很有用。我们很乐意回答任何问题。如果这种东西对你很有意思，考虑下我们的[招聘](https://boards.greenhouse.io/robinhood#.WQqFh1PyvUI)！

感谢 [Arpan Shah](https://medium.com/@arpanshah29?source=post_page)，[Aravind Gottipati](https://medium.com/@aravindg?source=post_page)，和 [Jack Randall](https://medium.com/@thejgr?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
