> * 原文地址：[Grafana Adds Enterprise Logs to Its Managed Observability Stack](https://www.infoq.com/news/2021/03/grafana-managed-observability/)
> * 原文作者：[Jared-Ruckle](https://www.infoq.com/profile/Jared-Ruckle/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/grafana-managed-observability.md](https://github.com/xitu/gold-miner/blob/master/article/2021/grafana-managed-observability.md)
> * 译者：[5Reasons](https://github.com/5Reasons)
> * 校对者：

# Grafana Adds Enterprise Logs to Its Managed Observability Stack

Grafana Labs recently released a new log aggregation module for [Grafana Enterprise Stack](https://grafana.com/products/enterprise/), its commercial observability platform.
Grafana Labs 近期为其商业可视化平台：[Grafana 企业产品栈](https://grafana.com/products/enterprise/)更新了一款新的日志聚合模块。

The new product, [Grafana Enterprise Logs](https://grafana.com/blog/2021/02/17/introducing-grafana-enterprise-logs-a-core-part-of-the-grafana-enterprise-stack-integrated-observability-solution/), ingests and stores logs from applications and other components. When using the module with other components of the Grafana Enterprise Stack, users can configure dashboards to display log data alongside metrics. Engineers can also view telemetry from other commercial tools like Splunk and New Relic in Grafana Enterprise Logs.
这款新产品：[Grafana 企业日志](https://grafana.com/blog/2021/02/17/introducing-grafana-enterprise-logs-a-core-part-of-the-grafana-enterprise-stack-integrated-observability-solution/),能够从应用程序和其他组建中获取并存储日志。当这个新模块与 Grafana 企业产品栈中的其他组件一起使用时，用户可以配置仪表盘来显示数据和指标。工程师们还可以在 Grafana 企业日志中查看来自其他商业工具，例如 Splunk 和 New Relic 中的测量数据。

[Anthony Woods](https://grafana.com/author/awoods), CTO and co-founder of Grafana Labs, noted the importance of logs for teams working on distributed systems. Further, engineers are tasked with sifting through a growing volume of logs.
Grafana Labs 的 CTO 和联合创始人 [Anthony Woods](https://grafana.com/author/awoods) 阐述了日志对于分布式系统团队的重要性。从长远的角度来看，工程师们的任务是从日益增长的日志中筛选出有价值的信息。

In an interview with [DevClass](https://devclass.com/2021/02/19/bp-190221/), Woods says Grafana Enterprise Logs seeks to deliver "a more SRE-kind of developer workflow, where you just want to search through the logs that you have, and use a grep filter." He notes this approach is handy when "I don’t know exactly what I’m looking for, but I know what I don’t want. So I can kind of exclude those and filter down until I find the logs and errors that I’m looking for."
在 [DevClass](https://devclass.com/2021/02/19/bp-190221/) 的一次采访中，Woods 表示 Grafana 企业日志尝试实现一种“更靠近于 SRE 开发人员的工作流，只需搜索现有的日志，并使用 grep 过滤器”。他指出，当人们不知道自己想要什么，但清楚地知道自己不想要什么时，这样的工作方法是十分行之有效的。人们可以排除自己不想要的东西，层层过滤，直到找到自己需要的日志和错误。

Grafana Enterprise Logs joins two other modules in the Grafana Enterprise Stack: [Grafana Enterprise](https://grafana.com/products/enterprise/grafana/), an enhanced version of Grafana, and [Grafana Enterprise Metrics](https://grafana.com/products/enterprise/metrics/), a scalable Prometheus-compatible metrics system.
Grafana 企业日志还在 Grafana 企业产品栈中新增了其他两个模块：Grafana 的增强版 [Grafana Enterprise](https://grafana.com/products/enterprise/grafana/)，以及兼容 Prometheus 的可拓展测量系统 [Grafana Enterprise Metrics](https://grafana.com/products/enterprise/metrics/)。

There’s no shortage of monitoring and logging tools available to big companies today. Last year, [Gartner pegged the application performance monitoring market](https://www.gartner.com/en/documents/3983892/magic-quadrant-for-application-performance-monitoring) at $4.48 billion, with an 1.1% CAGR through 2023. In that same report, Gartner suggested that IT leaders assume that "50% of new cloud-native application monitoring will use open-source instrumentation instead of vendor-specific agents for improved interoperability" by 2025, up from only 5% in 2019.
市面并不缺乏适用于大型企业的监控日志工具。？？

The company is attempting to stand out in this crowded market with the inclusion of [Grafana Loki](https://grafana.com/oss/loki/), an open-source project. Loki sits at the heart of the new logging capability. The company describes Loki as "a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus." Loki aims to improve performance and efficiency of log aggregation by indexing the metadata of logs, rather than the lines themselves.
Grafana 公司试图通过开源项目 [Grafana Loki](https://grafana.com/oss/loki/) 在这样一个拥挤的市场中脱颖而出。Loki 是新型日志功能的核心。他们将 Loki 描述为“在 Prometheus 的启发下开发出的具有水平可拓展、高可用性、多租户的日志聚合系统”。区别于对每一行日志进行索引，Loki 旨在通过索引日志的元数据来提升日志聚合系统的性能和效率。

Grafana Enterprise Logs bundles role-based access controls, and quotas. It can also be integrated with OIDC authentication providers.
Grafana 企业日志结合了基于角色的鉴权和配额。它还可以与 OIDC 身份验证厂家进行集成。

Grafana Enterprise Stack can be deployed in two ways: self-managed on your own infrastructure, or as [Grafana Cloud](https://grafana.com/products/cloud/), a fully-managed version.
Grafana 企业产品栈可以通过两种方式部署：在您自有的基础设施中进行自我管理，或通过 [Grafana Cloud](https://grafana.com/products/cloud/) 使用完全管理型的版本。

![[Source](https://grafana.com/blog/2021/02/17/introducing-grafana-enterprise-logs-a-core-part-of-the-grafana-enterprise-stack-integrated-observability-solution/)](https://res.infoq.com/news/2021/03/grafana-managed-observability/en/resources/1grafana-meta-image-for-blog-1616540157142.png)

Grafana Labs isn’t the only vendor offering managed services based on Grafana and Prometheus. AWS announced [Amazon Managed Service for Grafana and Amazon Managed Service for Prometheus](https://www.infoq.com/news/2021/01/aws-grafana-prometheus/) in January 2021. The open-source version of Grafana is available in the marketplaces for [Google Cloud](https://console.cloud.google.com/marketplace/details/google/grafana) and [Microsoft Azure](https://azuremarketplace.microsoft.com/en-in/marketplace/apps/grafana-labs.grafana_oss?tab=overview).
Grafana Labs 并不是唯一一家提供基于 Grafana 和 Prometheus 的托管服务的厂商。AWS 在 2021 年一月发布了[亚马逊管理服务的 Grafana 和 Prometheus 两种版本](https://www.infoq.com/news/2021/01/aws-grafana-prometheus/)。Grafana 的开源版本 可以在 [谷歌云](https://console.cloud.google.com/marketplace/details/google/grafana) 和 [微软 Azure](https://azuremarketplace.microsoft.com/en-in/marketplace/apps/grafana-labs.grafana_oss?tab=overview) 上获得。

Engineers looking to learn more about Grafana Enterprise Logs can review [documentation](https://grafana.com/docs/enterprise-logs/latest/). Pricing details Grafana Cloud, the managed service, are available on the [pricing page](https://grafana.com/products/cloud/pricing/). A free tier with up to 50 GB of logs is available.
如果你想要进一步了解 Grafana 企业日志，请查看它们的 [官方文档](https://grafana.com/docs/enterprise-logs/latest/)。基于 Grafana Cloud 的管理版本的价格细节详见 [价格页面](https://grafana.com/products/cloud/pricing/)。您也可以试用 50 GB 的免费版本。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
