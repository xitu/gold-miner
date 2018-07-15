> * 原文地址：[What we learned migrating off Cron to Airflow](https://medium.com/videoamp/what-we-learned-migrating-off-cron-to-airflow-b391841a0da4)
> * 原文作者：[Katie Macias](https://medium.com/@katiemacias?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-we-learned-migrating-off-cron-to-airflow.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-we-learned-migrating-off-cron-to-airflow.md)
> * 译者：[cf020031308](https://github.com/cf020031308)
> * 校对者：

# 从 Cron 到 Airflow 的迁移中我们学到了什么

![](https://cdn-images-1.medium.com/max/800/1*nK7DJiewFjF4E6F8BdrSMA.png)

去年秋天，VideoAmp 数据工程部门正在进行重大变革。当时的团队由三名数据工程师和一名与我们密切合作的系统工程师组成。我们集体确定了如何优化公司的技术债。

当时，数据团队是所有批处理作业的唯一所有者，这些作业从我们的实时竞价仓库获取反馈，提供给 Postgres 数据库，由 Postgres 数据库向 UI 填充。如果这些作业失败，UI 就会过时，我们的内部交易员和外部客户将只有陈旧数据可供依据。因此，满足这些作业的服务等级协议对于平台的成功至关重要。大多数这些作业都是用 Scala 构建的，并且使用了 Spark。这些批处理作业通过 Cron（一种内置于 Linux 的调度工具）被精心地编排。

**Cron 的优点**

我们发现 Cron 造成的一些主要的痛点甚至盖过了其带来的好处。 Cron 内置于 Linux 中，无需安装。此外，Cron 相当可靠，这使它成为一个吸引人的选择。因此，Cron 是项目概念证明的绝佳选择。但成规模使用时效果并不好。

![](https://cdn-images-1.medium.com/max/800/0*eMxK4MoEOhgJTlQJ.)

Crontab 文件：以前如何安排应用程序

**Cron 的缺点**

Cron 的第一个问题是对 crontab 文件的更改不容易追踪。 crontab 文件包含了在该计算机上运行的作业的调度计划，这些计划是跨项目的，但不会在源码管理中跟踪，也不会集成到单个项目的部署过程中。相反，工程师会随需要进行编辑，但不记录时间或项目依赖。

第二个问题是作业效果不透明。 Cron 的日志是输出到运行作业的服务器上 —— 而不是集中到某处一起。开发人员如何知道作业是成功还是失败？不论开发人员是自己浏览，还是需要暴露给下游工程团队使用，解析日志获取这些细节都是昂贵的。

最后，重新运行失败的作业是权宜且困难的。默认情况下，Cron 只设置了一些环境变量。新手开发人员经常会惊讶地发现存储在 crontab 文件中的 bash 命令不会产生与其终端相同的输出，因为他们的 bash 配置文件中的设置并不存在于 Cron 环境中。这要求开发人员构建出执行命令的用户环境的所有依赖关系。

很明显，需要在 Cron 之上构建许多工具才能获得成功。虽然我们略微解决了一些，但我们知道有许多功能更强大的开源选项可用。我们整个团队使用过的编排工具统共有 Luigi、Oozie 和其他定制解决方案等，但最终这些经历仍让我们觉得不满。而 AirBnB 的 Airflow 能入选 Apache 孵化器，这正意味着它众望所归。

**设置和迁移**

以典型的黑客方式，我们秘密地从现有技术栈中获取资源，通过设置 Airflow metadb 和主机来证明我们的想法。

此 metadb 包含了重要的信息，如单向无环图（DAG）和任务清单、作业的效果和结果，以及用于向其他任务发送信号的变量。 Airflow metadb 可以构建在诸如 PostgreSQL 或 SQLite 之类的关系数据库之上。通过这种依赖，Airflow 可以扩展到单个实例之外。我们就挪用了另一个团队用于开发环境的 PostgreSQL 虚拟机（他们的开发冲刺结束了，他们不再使用这个实例）。

Airflow 主机安装在我们的 spark 开发虚拟机上，是我们 spark 集群的一部分。该主机使用 LocalExecutor 进行设置，并运行着调度程序和用于 Airflow 的 UI。安装在我们的 spark 集群中的一个实例上后，我们的作业具有了执行所需要的 spark 依赖项的权限。这是成功迁移的关键，也是之前尝试失败的原因。

从 Cron 迁移到 Airflow 带来了特殊的挑战。由于 Airflow 自带任务调度，我们不得不修改我们的应用程序以获取新格式的输入。幸运的是，Airflow 通过变量为调度脚本提供必要的元信息。我们还去除了我们在其中构建的大部分工具的应用程序，例如推送警报和信号。最后，我们最终将许多应用程序拆分为较小的任务，以遵循 DAG 范例。

![](https://cdn-images-1.medium.com/max/800/0*tktxAKxxE2x4ZGA-.)

Airflow UI：开发人员可以清楚地从UI中辨别出哪些 Dags 是稳定的，哪些不那么健壮，需要强化。

**得到的教训**

1.  **应用程序臃肿** 使用 Cron 时，调度逻辑必须与应用程序紧密耦合。每个应用程序都必须完成 DAG 的整个工作。这个额外的逻辑掩盖了作为应用程序目的核心的工作单元。这使得它既难以调试又难以并行开发。自从迁移到 Airflow 以来，将任务放在 DAG 中的想法使团队能够开发出专注于该工作单元的强大脚本，同时最大限度地减少了我们的工作量。
2.  **优化了批处理作业的效果呈现** 通过采用Airflow UI，数据团队的批处理作业效果对团队和依赖我们数据的其他工程部门都是透明的。
3.  **具有不同技能组合的数据工程师可以共同构建一个管道** 我们的数据工程团队利用 Scala 和 Python 来执行 Spark 作业。 Airflow 为我们的团队提供了一个熟悉的中间层，可以在 Python 和 Scala 应用程序之间建立协议 —— 允许我们支持这两种技能的工程师。
4.  **我们的批处理作业调度的扩展路径很明显** 使用 Cron 时，我们的调度仅限于一台机器。扩展应用程序需要我们构建一个协调层。 Airflow 正为我们提供了开箱即用的扩展功能。使用 Airflow，从 LocalExecutor 到 CeleryExecutor，从单个机器上的 CeleryExecutor 到多个 Airflow worker，路径清晰可见。
5.  **重新运行作业变得微不足道** 使用 Cron，我们需要获取执行的 Bash 命令，并希望我们的用户环境与 Cron 环境足够相似，以便能为调试而重现问题。如今，通过 Airflow，任何数据工程师都可以直接查看日志，了解错误并重新运行失败的任务。
6.  **合适的警报级别** 在 Airflow 之前，批处理作业的所有告警都会发送到我们的流式数据应用程序的告警邮箱中。通过 Airflow，该团队构建了一个 Slack 操作符，可被所有 DAG 统一调用来推送通知。这使我们能够将来自我们的实时竞价堆栈的紧急失败通知与来自我们的批处理作业的重要但不紧急的通知分开。
7.  **一个表现不佳的 DAG 可能会导致整个机器崩溃** 为您的数据团队设立规范，来监控其作业的外部依赖性，以免影响其他作业的服务等级协议。
8.  **滚动覆盖您的 Airflow 日志** 这应该不言而喻，但 Airflow 会存储所有它所调用的应用程序的日志。请务必适当地对日志进行滚动覆盖，以防止因磁盘空间不足而导致整个机器停机。

五个月后，VideoAmp 的数据工程团队规模几乎增加了两倍。我们管理着 36 个 DAG，并且数量还在增加！ Airflow 经过扩展可让我们所有的工程师为我们的批量流程做出贡献和支持。该工具的简单性使得新工程师上手相对无痛。该团队正在快速开发改进，例如对我们的 slack 频道进行统一的推送告警、升级到 Python3 Airflow、转移到 CeleryExecutor，以及利用 Airflow 提供的强大功能。

有任何疑问或意见可在这里直接询问，或在下面分享你的经验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。