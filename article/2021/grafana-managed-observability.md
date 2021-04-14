> * 原文地址：[Grafana Adds Enterprise Logs to Its Managed Observability Stack](https://www.infoq.com/news/2021/03/grafana-managed-observability/)
> * 原文作者：[Jared-Ruckle](https://www.infoq.com/profile/Jared-Ruckle/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/grafana-managed-observability.md](https://github.com/xitu/gold-miner/blob/master/article/2021/grafana-managed-observability.md)
> * 译者：[5Reasons](https://github.com/5Reasons)
> * 校对者：[IAMSHENSH](https://github.com/IAMSHENSH)

# Grafana 为其可视化产品栈新增企业级日志服务

Grafana Labs 近期为其商业数据可视化平台：[Grafana Enterprise Stack](https://grafana.com/products/enterprise/) 发布了一款新的日志聚合模块。

这款新产品：[Grafana Enterprise Logs](https://grafana.com/blog/2021/02/17/introducing-grafana-enterprise-logs-a-core-part-of-the-grafana-enterprise-stack-integrated-observability-solution/) 能够从应用程序和其他组件中获取并存储日志。当这个新模块与 Grafana Enterprise Stack 中的其他组件一起使用时，用户可以配置仪表盘来显示数据和指标。工程师们还可以在 Grafana Enterprise Logs 中查看来自其他商业工具中的测量数据，例如 Splunk 和 New Relic。

Grafana Labs 的 CTO、联合创始人 [Anthony Woods](https://grafana.com/author/awoods) 阐述了日志对于分布式系统团队的重要性。从长远的角度来看，工程师们的任务是从日益增长的日志中筛选出有价值的信息。

在 [DevClass](https://devclass.com/2021/02/19/bp-190221/) 的一次采访中，Woods 表示 Grafana Enterprise Logs 尝试实现一种“更靠近于 SRE 开发人员的工作流，只需搜索现有的日志、辅以 grep 过滤器来完成工作”。他指出，当人们不知道自己想要什么，但清楚地知道自己不想要什么时，这样的工作方法是十分行之有效的。人们可以排除自己不想要的东西，层层过滤，直到找到自己需要的日志和错误。

Grafana Enterprise Logs 还在 Grafana Enterprise Stack 中新增了其他两个模块：Grafana 的增强版 [Grafana Enterprise](https://grafana.com/products/enterprise/grafana/)，以及兼容 Prometheus 的可拓展测量系统 [Grafana Enterprise Metrics](https://grafana.com/products/enterprise/metrics/)。

市面上并不乏可供大企业选择的监控、日志工具。去年 [Gartner 公司的一份研究报告](https://www.gartner.com/en/documents/3983892/magic-quadrant-for-application-performance-monitoring) 指出，应用程序性能监测拥有价值 44.8 亿美元的市场，到 2023 年能拥有 1.1% 的复合年均增长率。在这份报告中，Gartner 建议 IT 行业的领导者们作出如下假设：“到 2025 年，50% 的新型云原生应用监控系统将会采用开源工具来替代特定供应商的产品，以此提高系统的互用性”。这一比例将远高于 2019 年的 5%。

Grafana 公司试图通过开源项目 [Grafana Loki](https://grafana.com/oss/loki/) 在这样一个红海市场中脱颖而出。Loki 是新型日志功能的核心。他们将 Loki 描述为“在 Prometheus 的启发下开发出的具有水平可拓展、高可用性、多租户的日志聚合系统”。区别于对每一行日志进行索引，Loki 旨在通过索引日志的元数据来提升日志聚合系统的性能和效率。

Grafana Enterprise Logs 结合了基于角色的鉴权和配额。它还可以与 OIDC 身份验证厂家进行集成。

Grafana Enterprise Stack 可以通过两种方式部署：在您自有的基础设施中进行自我管理，或通过 [Grafana Cloud](https://grafana.com/products/cloud/) 使用完全管理型的版本。

![[Source](https://grafana.com/blog/2021/02/17/introducing-grafana-enterprise-logs-a-core-part-of-the-grafana-enterprise-stack-integrated-observability-solution/)](https://res.infoq.com/news/2021/03/grafana-managed-observability/en/resources/1grafana-meta-image-for-blog-1616540157142.png)

Grafana Labs 并不是唯一一家提供基于 Grafana 和 Prometheus 的托管服务的厂商。AWS 在 2021 年一月发布了 [亚马逊管理服务的 Grafana 和 Prometheus 两种版本](https://www.infoq.com/news/2021/01/aws-grafana-prometheus/)。Grafana 的开源版本可以在 [谷歌云](https://console.cloud.google.com/marketplace/details/google/grafana) 和 [微软 Azure](https://azuremarketplace.microsoft.com/en-in/marketplace/apps/grafana-labs.grafana_oss?tab=overview) 上获得。

如果你想要进一步了解 Grafana Enterprise Logs，请查看它们的 [官方文档](https://grafana.com/docs/enterprise-logs/latest/)。基于 Grafana Cloud 的管理版本的价格细节详见 [价格页面](https://grafana.com/products/cloud/pricing/)。您也可以试用 50 GB 的免费版本。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
