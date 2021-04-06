> - 原文地址：[Top 10 Open Source Projects for SREs and DevOps](https://dzone.com/articles/top-open-source-projects-for-sres-and-devops)
> - 原文作者：Nir Sharma
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-open-source-projects-for-sres-and-devops.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-open-source-projects-for-sres-and-devops.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[kamly](https://github.com/kamly)、[1autodidact](https://github.com/1autodidact)

# SREs 和 DevOps 十大开源项目

构建可扩展高可用的软件系统是每个 SRE 的最终目标。在我们最新的博客的帮助下，您可以沿着持续学习的道路前进，其中概述了在监控，部署和维护领域最受追捧的开源项目。
成为成功的 SRE 的方式在于不断学习。 SRE / DevOps 有大量出色的开源项目，每个项目都有新颖而令人兴奋的实现方式，并且常常应对独特的挑战。 这些开源项目完成了繁重的工作，因此您可以更轻松地完成工作。

在该博客中，我们将在监控、部署和维护方面研究一些最受欢迎的开源项目。在我们所涉及的项目中，有一些项目可以模拟网络流量，并允许你对不可预测的（混乱的）事件进行建模，以开发可靠的系统。

## 1. Cloudprober

[Cloudprober](https://github.com/google/cloudprober) 是一个主动的跟踪和监控应用程序，可以在客户发现故障之前发现故障。它使用“active”监视模型来检查组件是否按预期运行。例如，它会主动运行探针，以确保前端能否访问后端。类似地，可以运行一个探针来验证你的内部系统是否能够真正访问云内虚拟机。这种跟踪方式可以轻松地，独立于实施之外地跟踪你的应用程序配置，并让你能够轻松地确定系统中故障所在。

### 特性：

- 原生集成 Prometheus 和 Grafana 的开源监控。Cloudprober 也可以导出探测结果。
- 对于云目标，自动发现目标。为 GCE 和 Kubernetes 提供了开箱即用的支持；其他云服务可以轻松配置。
- 致力于简化部署。Cloudprober 是完全用 Go 编写并编译成二进制静态文件。它可以通过 Docker 容器快速部署。 除了大多数更新之外，由于自动追踪目标，通常不需要重新部署或重新配置 Cloudprober。
- Cloudprober Docker 的镜像占用很小，只包含一个静态编译的二进制文件，即使运行大量的探针，也只需要非常少的 CPU 和 RAM。

![[Image Source](https://github.com/google/cloudprober)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5bd946575b4c9affe61b_1.png)

## 2. Cloud Operations Sandbox (Alpha)

[Cloud Operations Sandbox](https://github.com/GoogleCloudPlatform/cloud-ops-sandbox) 是一个开源平台，它可以让专家们了解谷歌的服务可靠性工程实践，并使用 Ops 管理（以前的 Stackdriver）使其适应自己的云系统。它基于 Hipster Shop，一个基于云的本地微服务平台。注意：这需要一个谷歌云服务帐户。

### 特性：

- 演示服务 — 基于现代云原生微服务架构设计的应用程序。
- 一键部署 — 脚本处理将服务部署到 Google Cloud Platform 的工作。
- 负载生成器 — 在演示服务上生成模拟流量的部件。

![[Image Source](https://github.com/GoogleCloudPlatform/cloud-ops-sandbox)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c14d10c2b76716fbe34_2.jpg)

## 3. Version Checker for Kubernetes

一个[Kubernetes 实用工具](https://github.com/jetstack/version-checker#:~:text=version%2Dchecker%20is%20a%20Kubernetes,This%20tool%20is%20currently%20experimental.) 允许你观察集群中运行的镜像的现有版本。这个工具还允许您在 Grafana 仪表板上以表格格式查看当前的镜像版本。

### 特性：

- 可以一次性设置多个自托管的注册表。
- 这个实用程序允许您以 Prometheus metrics 的形式查看版本信息。
- 支持注册，如 ACR, DockerHub, ECR。

![[Image Source](https://github.com/jetstack/version-checker)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae46c71a5a0a24cfccbd8d_image6.png)

## 4. Istio

[Istio](https://istio.io/) 是一个开放的框架，用于整合微服务、通过微服务监控流量移动、实施策略以及以标准化方式聚合遥测数据。Istio的控制平面在集群管理（如 Kubernetes）的底层平台上提供了一个抽象层。

### 特性：

- 自动负载均衡的 HTTP，gRPC，WebSocket，和 TCP 通信。
- 通过丰富的路由规则、重试、故障转移和故障注入对流量行为进行细粒度控制。
- 支持访问控制、速率限制和配额的可插拔策略层和配置 API。
- 对集群内的所有流量（包括集群入口和出口）进行自动度量、日志和跟踪。
- 通过强大的基于身份的身份认证和授权，在集群集中进行安全的服务间通信。

![[Image Source](https://istio.io/)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c3ad3b5421ccfa359f7_3.jpg)

## 5. Checkov

[Checkov](https://www.checkov.io/) 是一个基础架构即代码的静态检查工具。它扫描 Terraform，Cloud Details，Cubanet，无服务器或 ARM 模型云基础架构，并检测安全性和合规性错误配置。

### 特性：

- 超过 400 条内置规则涵盖了 AWS，Azure 和 Google Cloud 的最佳保护和安全实践。
- 评估 Terraform 供应商设置，以监控 Terraform 管理的 IaaS、PaaS 或 SaaS 开发、维护和更新。
- 检测 EC2 Userdata、Lambda 上下文变量和 Terraform 提供商中的 AWS 凭据。

![[Image Source](https://www.checkov.io/)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae46b8a8cf376b15c27f31_image3.png)

## 6. Litmus

[Cloud-Native Chaos Engineering](https://github.com/litmuschaos/litmus)
Litmus 是基于云的混沌建模工具包。 Litmus 提供了一些工具来协调 Kubernetes 上的混乱情况，以帮助 SRE 发现其部署中的漏洞。 SRE 首先使用 Litmus 在登台区域进行混沌测试，最后在开发过程中使用它来发现故障和漏洞。 解决这些缺陷可以提高系统的弹性。

### 特性：

- 开发人员可以在应用程序开发期间运行混乱测试，作为单元测试或集成测试的扩展。
- 对于 CI 管道构建器：将 chaos 作为管道阶段运行，以便在应用程序遇到管道中的失败路径时发现 bug。

![[Image Source](https://github.com/litmuschaos/litmus)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5c80e9ad215032686770_4.jpg)

## 7. Locust

[Locust](https://github.com/locustio/locust) 是一个易于使用，可编写脚本且灵活的性能测试应用程序。 您可以使用标准的 Python 代码定义用户的行为，而不是使用笨拙的 UI 或特定于域的语言。 这使 Locust 可以扩展并且对开发人员友好。

### 特性：

- Locust 是分布式和可扩展的-很容易支持数百或数千用户。
- 基于 Web 的 UI，可实时显示进度。
- 稍加修改就可以测试任何系统。

![[Image Source](https://github.com/locustio/locust)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae487f1a5a0a3f0eccc78d_image1.png)

## 8. Prometheus

[Prometheus](https://github.com/prometheus/prometheus)  是云原生计算基金会项目，是一个系统和服务监控系统。它在特定时间从已配置的目标中提取指标，测试规则并显示结果。如果违反了指定条件，它将触发通知。

### 特性：

- 多维数据模型（由度量名称和键/值维集定义的时间序列）。
- 通过服务发现或静态配置发现目标。
- 不依赖于分布式存储； 单个服务器节点是自治的。
- PromQL，一种强大而灵活的查询语言，可利用此维度。

![[Image Source](https://github.com/prometheus/prometheus)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5cabe713151e3ba35284_5.jpg)

### 9. Kube-monkey

[Kube-monkey](https://github.com/asobti/kube-monkey) 是 Netflix 的 Chaos Monkey 的 Kubernetes 集群实现。 随机删除 Kubernetes Pod 有助于创建抗故障资源并同时对其进行验证。

### 特性：

- Kube-monkey 使用选择模式运行，并且仅针对专门接受 kube-monkey 终止其 pod 的 Kubernetes（k8s）用户的终止。
- 可根据您的要求进行高度可定制的计划功能。

![[Image Source](https://www.slideshare.net/arungupta1/chaos-engineering-with-kubernetes)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae4976092c02d97f145670_image10.png)

## 10. PowerfulSeal

[PowerfulSeal](https://github.com/powerfulseal/powerfulseal) 将故障注入 Kubernetes 集群，帮助您尽快识别问题。它让创建描述完整混沌实验的方案成为可能。

### 特性：

- 与 Kubernetes，OpenStack，AWS，Azure，GCP 和本地计算机兼容。
- 与 [Prometheus](https://prometheus.io/) 和 [Datadog](https://www.datadoghq.com/) 连接以收集指标。
- 自定义用例允许使用多种模式。

![[Image Source](https://github.com/powerfulseal/powerfulseal)](https://uploads-ssl.webflow.com/5c9200c49b1194323aff7304/5fae5cca5c87c3b80dcf9912_6.jpg)

## 总结

开源技术的一大优点是其可扩展的特性。如果需要，您可以向工具添加特性，以便更好地适应您的自定义架构。这些开源项目有广泛的支持文档和用户社区。由于微服务体系结构将主导云计算领域，用于监控和排除这些实例的可靠工具肯定会成为每个开发人员的工具库的一部分。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
