> * 原文地址：[Airflow: a workflow management platform](https://medium.com/airbnb-engineering/airflow-a-workflow-management-platform-46318b977fd8)
> * 原文作者：[Maxime Beauchemin](https://medium.com/@maximebeauchemin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/airflow-a-workflow-management-platform.md](https://github.com/xitu/gold-miner/blob/master/TODO1/airflow-a-workflow-management-platform.md)
> * 译者：[yqian1991](https://github.com/yqian1991)
> * 校对者：[Park-ma](https://github.com/Park-ma) [DerekDick](https://github.com/DerekDick)

# Airflow: 一个工作流程管理平台

出自 [Maxime Beauchemin](https://medium.com/@maximebeauchemin)

![](https://cdn-images-1.medium.com/max/800/0*277Imf2r7ouTXOVy.png)

**Airbnb** 是一个快速增长的、数据启示型的公司。我们的数据团队和数据量都在快速地增长，同时我们所面临的挑战的复杂性也在同步增长。我们正在扩张的数据工程师、数据科学家和分析师团队在使用 **Airflow**，它是我们搭建的一个可以快速推进工作，保持发展优势的平台，因为我们可以自己编辑、监控和改写 **数据管道**。

今天，我们非常自豪地宣布我们要 **开源** 和 **共享** 我们的工作流程管理平台：**Airflow**。

[https://github.com/airbnb/airflow](https://github.com/apache/incubator-airflow)

* * *

### 有向无环图（DAGs）呈绽放之势

当与数据打交道的工作人员开始将他们的流程自动化，那么写批处理作业是不可避免的。这些作业必须按照一个给定的时间安排执行，它们通常依赖于一组已有的数据集，并且其它的作业也会依赖于它们。即使你让好几个数据工作节点在一起工作很短的一段时间，用于计算的批处理作业也会很快地扩大成一个复杂的图。现在，如果有一个工作节奏快、中型规模的数据团队，而且他们在几年之内要面临不断改进的数据基础设施，并且手头上还有大量复杂的计算作业网络。那这个复杂性就成为数据团队需要处理，甚至深入了解的一个重要负担。

这些作业网络通常就是 **有向无环图**（**DAGs**），它们具有以下属性：

*   **已排程：** 每个作业应该按计划好的时间间隔运行
*   **关键任务：** 如果一些作业没有运行，那我们就有麻烦了
*   **演进：** 随着公司和数据团队的成熟，数据处理也会变得成熟
*   **异质性：** 现代化的分析技术栈正在快速发生着改变，而且大多数公司都运行着好几个需要被粘合在一起的系统

### 每个公司都有一个（或者多个）

**工作流程管理** 已经成为一个常见的需求，因为大多数公司内部有多种创建和调度作业的方式。你总是可以从古老的 cron 调度器开始，并且很多供应商的开发包都自带调度功能。下一步就是创建脚本来调用其它的脚本，这在短期时间内是可以工作的。最终，一些为了解决作业状态存储和依赖的简单框架就涌现了。

通常，这些解决方案都是 **被动增长** 的，它们都是为了响应特定作业调度需求的增长，而这通常也是因为现有的这种系统的变种连简单的扩展都做不到。同时也请注意，那些编写数据管道的人通常不是软件工程师，并且他们的任务和竞争力都是围绕着处理和分析数据的，而不是搭建工作流程管理系统。

鉴于公司内部工作流程管理系统的成长总是比公司的需求落后至少一代，作业的编辑、调度和错误排查之间的 **摩擦** 制造了大量低效且令人沮丧的事情，这使得数据工作者和他们的高产出路线背道而驰。

### Airflow

在评审完开源解决方案，同时听取 Airbnb 的员工对他们过去使用的系统的见解后，我们得出的结论是市场上没有任何可以满足我们当前和未来需求的方案。我们决定搭建一个崭新的系统来正确地解决这个问题。随着这个项目的开发进展，我们意识到我们有一个极好的机会去回馈我们也极度依赖的开源社区。因此，我们决定依照 Apache 的许可开源这个项目。

这里是 Airbnb 的一些靠 Airflow 推动的处理工序：

*   **数据仓储：** 清洗、组织规划、数据质量检测并且将数据发布到我们持续增长的数据仓库中去
*   **增长分析：** 计算关于住客和房主参与度的指标以及增长审计
*   **试验：** 计算我们 A/B 测试试验框架的逻辑并进行合计
*   **定向电子邮件：** 对目标使用规则并且通过群发邮件来吸引用户
*   **会话（Sessionization）：** 计算点击流和停留时间的数据集
*   **搜索：** 计算搜索排名相关的指标
*   **数据基础架构维护：** 数据库抓取、文件夹清理以及应用数据留存策略，......

### 架构

就像英语是商务活动经常使用的语言一样，Python 已经稳固地将自己树立为数据工作的语言。Airflow 从创建之初就是用 Python 编写的。代码库可扩展、文档齐全、风格一致、语法过检并且有很高的单元测试覆盖率。

管道的编写也是用 Python 完成的，这意味着通过配置文件或者其他元数据进行动态管道生成是与生俱来的。“**配置即代码**” 是我们为了达到这个目的而坚守的准则。虽然基于 yaml 或者 json 的作业配置方式可以让我们用任何语言来生成 Airflow 数据管道，但是我们感觉到转化过程中的一些流动性丧失了。能够内省代码（ipython!和集成开发工具）子类和元程序并且使用导入的库来帮助编写数据管道为 Airflow 增加了巨大的价值。注意，只要你能写 Python 代码来解释配置，你还是可以用任何编程语言或者标记语言来编辑作业。

你仅需几行命令就可以让 Airflow 运行起来，但是它的完整架构包含有下面这么多组件：

*   **作业定义**, 包含在源代码控制中。
*   一个丰富的 **命令行工具** (命令行接口) 用来测试、运行、回填、描述和清理你的有向无环图的组成部件。
*   一个 **web 应用程序**, 用来浏览有向无环图的定义、依赖项、进度、元数据和日志。web 服务器打包在 Airflow 里面并且是基于 Python web 框架 Flask 构建的。
*   一个 **元数据仓库**，通常是一个 MySQL 或者 Postgres 数据库，Airflow 可以用它来记录任务作业状态和其它持久化的信息。
*   一组 **工作节点**，以分布式的方式运行作业的任务实例。
*   **调度** 程序，触发准备运行的任务实例。

### 可扩展性

Airflow 自带各种与 Hive、Presto、MySQL、HDFS、Postgres 和 S3 这些常用系统交互的方法，并且允许你触发任意的脚本，基础模块也被设计得非常容易进行扩展。

**Hooks** 被定义成外部系统的抽象并且共享同样的接口。Hooks 使用中心化的 vault 数据库将主机/端口/登录名/密码信息进行抽象并且提供了可供调用的方法来跟这些系统进行交互。

**操作符** 利用 hooks 生成特定的任务，这些任务在实例化后就变成了数据流程中的节点。所有的操作符都派生自 BaseOperator 并且继承了一组丰富的属性和方法。三种主流的操作符分别是：

*   执行 **动作** 的操作符, 或者通知其它系统去执行一个动作
*   **转移** 操作符将数据从一个系统移动到另一个系统
*   **传感器** 是一类特定的操作符，它们会一直运行直到满足了特定的条件

**执行器（Executors）** 实现了一个接口，它可以让 Airflow 组件（命令行接口、调度器和 web 服务器）可以远程执行作业。目前，Airflow 自带一个 SequentialExecutor（用来做测试）、一个多线程的 LocalExecutor、一个使用了  [Celery](http://www.celeryproject.org/) 的 CeleryExecutor 和一个超棒的基于分布式消息传递的异步任务队列。我们也计划在不久后开源 YarnExecutor。

### 一个绚丽的用户界面

虽然 Airflow 提供了一个丰富的[命令行接口](https://airflow.apache.org/cli.html)，但是最好的工作流监控和交互办法还是使用 web 用户接口。你可以容易地图形化显示管道依赖项、查看进度、轻松获取日志、查阅相关代码、触发任务、修正 false positives/negatives 以及分析任务消耗的时间，同时你也能得到一个任务通常在每天什么时候结束的全面视图。用户界面也提供了一些管理功能：管理连接、池和暂停有向无环图的进程。

![](https://cdn-images-1.medium.com/max/400/1*nbwR8O-CDH67fkHrXVDvYw.png)

![](https://cdn-images-1.medium.com/max/400/1*0Mask8UZw_aCsd_7JM2Rjw.png)

![](https://cdn-images-1.medium.com/max/400/1*JNOJotSnC3t0TIQC8gYcsg.png)

![](https://cdn-images-1.medium.com/max/600/1*qqOg_8bMS_MzDgWSbgdtOw.png)

![](https://cdn-images-1.medium.com/max/400/1*rNaZuJ2168jvUYiEkdu1ww.png)

![](https://cdn-images-1.medium.com/max/400/1*ojItdtSC6etsUWOZIK8trw.png)

锦上添花的是，用户界面有一个 [Data Profiling](https://airflow.apache.org/profiling.html) 区，可以让用户在注册好的连接上进行 SQL 查询、浏览结果集，同时也提供了创建和分享一些简单图表的方法。这个制图应用是由 [Highcharts](http://www.highcharts.com/)、[Flask Admin](https://flask-admin.readthedocs.org/en/v1.0.9/) 的增删改查接口以及 Airflow 的 [hooks](https://airflow.apache.org/code.html#hooks) 和 [宏](https://airflow.apache.org/code.html#macros)库混搭而成的。URL 参数可以传递给你图表中使用的 SQL，Airflow 的宏是通过 [Jinja templating](http://jinja.pocoo.org/) 的方式工作的。有了这些特性和查询功能，Airflow 用户可以很容易的创建和分享结果集和图表。

![](https://cdn-images-1.medium.com/max/400/1*8SD5x-62kLVzZ9SSfAXKCg.png)

![](https://cdn-images-1.medium.com/max/400/1*2L-uvEnYDvf5FG3eMuknuQ.png)

![](https://cdn-images-1.medium.com/max/400/1*EbUXRyeS65GZTXbCPWrF7w.png)

### 一种催化剂

使用 Airflow 之后，Airbnb 的员工进行数据工作的生产率和热情提高了好几倍。管道的编写也加速了，监控和错误排查所花费的时间也显著减少了。更重要的是，这个平台允许人们从一个更高级别的抽象中去创建可重用的模块、计算框架以及服务。

### 说得够多的了！

我们已经通过一个启发式的教程把试用 Airflow 变得极其简单。想看到示例结果也只需要执行几个 shell 命令。看一看 [Airflow 文档](https://airflow.apache.org/) 的[快速上手](https://airflow.apache.org/start.html)和[教程](https://airflow.apache.org/tutorial.html)部分，你可以在几分钟之内就让你的 Airflow web 程序以及它自带的交互式实例跑起来！

[https://github.com/airbnb/airflow](https://github.com/apache/incubator-airflow)

![](https://cdn-images-1.medium.com/max/800/1*YsUOrWx3mRxZZljtc9xZyw.png)

#### 在 [airbnb.io](http://airbnb.io) 上查看我们所有的开源项目并 在 Twitter 上关注我们: [@AirbnbEng](https://twitter.com/AirbnbEng) + [@AirbnbData](https://twitter.com/AirbnbData)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
