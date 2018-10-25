> * 原文地址：[Data Science for Startups: Introduction](https://towardsdatascience.com/data-science-for-startups-introduction-80d022a18aec)
> * 原文作者：[Ben Weber](https://towardsdatascience.com/@bgweber?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-for-startups-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-for-startups-introduction.md)
> * 译者：[临书](https://github.com/tmpbook)
> * 校对者：

# 初创公司的数据科学：简介

![](https://cdn-images-1.medium.com/max/1600/1*z0AJeiYe_9qltVgp2g7zkw.jpeg)

照片来源：rawpixel 发表在 pixabay.com

我最近换了行业，加入了一家创业公司，负责建立数据科学部。虽然我加入时这里已经有了可靠的数据管道，但是没有适用于可重复分析、扩展模型和执行实验的流程。本系列博文的目标是概述如何从头开始为创业公司构建数据科学平台，并使用谷歌云平台（GCP）为读者提供可以自己尝试的真实示例。

本系列适用于希望超越训练模型阶段，以及想构建可能对公司产生影响的数据管道和数据产品的数据科学家和分析师。但是对于希望更好的了解如何与数据科学家合作运行实验和构建数据产品的其他学科来说，它也是有用的。它适用于具有编程经验的读者，本系列主要使用了 R 与 Java 的代码示例。

#### 为什么选择数据科学？

为您的创业公司雇佣数据科学家时，首先要问的问题之一是：_数据科学将如何改进我们的产品_？在 [Windfall Data](https://angel.co/windfall-data)，我们的产品就是数据，因此数据科学的目标与公司的目标可以很好的协调，可以建立最准确的估算净值模型。而在其他公司（如移动游戏公司），答案可能没那么直接，数据科学可能对了解如何运营业务而不是改进产品更有用。但是在早期阶段就开始收集有关客户行为的数据通常是有益的，这样您就可以在将来改进产品。

在初创公司启动数据科学的好处有：

1. 可以确定要跟踪和预测的关键业务指标
2. 可以建立客户行为的预测模型
3. 可以运行实验以测试产品变化
4. 可以构建支持新产品功能的数据产品

许多公司在前两个或三个步骤中就陷入了困境，并没有充分发挥数据科学的潜力。本系列博客文章的目标是展示如何使用托管服务让小型团队超越仅为计算业务运营指标而搭建数据管道，过渡到数据科学可以为产品提供关键输入的公司。

#### 系列概述

以下是我对此博客系列文章的主题计划。当我写新的部分时，我可能会添加或移动部分内容。如果您认为应该涵盖其他主题，可以在文末提出来。

1.  简介（即本文）：提供在初创公司使用数据科学的动力，并概述本系列文章所涵盖的内容。类似的文章包括[数据科学的功能](https://towardsdatascience.com/functions-of-data-science-4afd5341a659)，[数据科学扩展](https://medium.com/windfalldata/scaling-data-science-at-windfall-55f5f23698e1)还有[我的 FinTech 之旅](https://towardsdatascience.com/from-games-to-fintech-my-ds-journey-b7169f08b6ad)。
2.  [**跟踪数据**](https://towardsdatascience.com/data-science-for-startups-tracking-data-4087b66952a1)：讨论从应用程序和网页捕获数据的动机，提出收集跟踪数据的不同方法，引入隐私和欺诈等问题，并以 Google PubSub 为例。
3.  [**数据管道**](https://medium.com/@bgweber/data-science-for-startups-data-pipelines-786f6746a59a)：介绍如何使用不同方法收集数据以供分析和数据科学团队使用，讨论了平面文件、数据库和数据池方式，并介绍了基于 PubSub，DataFlow 和 BigQuery 的实现。类似的文章有[可扩展的分析管道](https://towardsdatascience.com/a-simple-and-scalable-analytics-pipeline-53720b1dbd35)和[游戏分析平台的演进](https://towardsdatascience.com/evolution-of-game-analytics-platforms-4b9efcb4a093)。
4.  [**商业智能**](https://towardsdatascience.com/data-science-for-startups-business-intelligence-f4a2ba728e75)：认识 ETL 的常见实践经验、自动化报告/仪表盘以及计算业务运营指标和 KPI。使用 R Shiny 和 Data Studio 为例。
5.  [**探索性分析**](https://towardsdatascience.com/data-science-for-startups-exploratory-data-analysis-70ac1815ddec)：涵盖用于挖掘数据常用分析，比如构建直方图和累积分布函数、相关性分析以及线性模型的特征重要性。使用 [Natality](https://cloud.google.com/bigquery/sample-tables) 公共数据集进行示例分析。类似的文章有[聚合前 1%](https://medium.freecodecamp.org/clustering-the-top-1-asset-analysis-in-r-6c529b382b42) 和 [数据科学可视化的 10 年](https://towardsdatascience.com/10-years-of-data-science-visualizations-af1dd8e443a7)。
6.  [**预测建模**](https://medium.com/@bgweber/data-science-for-startups-predictive-modeling-ec88ba8350e9)：讨论监督和非监督学习方法，并介绍流失和交叉推广预测模型，以及评估离线模型性能的方法。
7.  [**模型制作**](https://medium.com/@bgweber/data-science-for-startups-model-production-b14a29b2f920)：展示如何扩展离线模型以获得数百万条记录，并讨论模型部署的批处理和在线方法。类似的文章有[在 Twitch 产品化数据科学](https://blog.twitch.tv/productizing-data-science-at-twitch-67a643fd8c44)，还有[使用 DataFlow 生成模型](https://towardsdatascience.com/productizing-ml-models-with-dataflow-99a224ce9f19)。
8.  **实验**：介绍产品的 A/B 测试，讨论如何配置运行实验的框架，并提供 R 和 bootstrapping 示例分析。类似的文章有[分阶段的 A/B 测试](https://blog.twitch.tv/a-b-testing-using-googles-staged-rollouts-ea860727f8b2)。
9. **推荐系统**：介绍推荐系统的基础知识，并提供扩展生产系统推荐器的示例。类似的文章有[推荐人原型设计](https://towardsdatascience.com/prototyping-a-recommendation-system-8e4dd4a50675)
10.  **深度学习**：简要介绍一些问题最好通过深度学习来解决的数据科学问题，例如将聊天消息标记为令人反感的。提供带有 [Keras](https://keras.rstudio.com/) 的 R 接口的原型模型示例，以及使用 [CloudML](https://tensorflow.rstudio.com/tools/cloudml/articles/getting_started.html) 的 R 接口进行产品化。

本系列还存在[网络版](https://bgweber.github.io/)和[印刷版](https://www.amazon.com/dp/1983057975)的书。

#### 工具

在整个系列中，我将介绍基于 Google Cloud Platform 构建的代码示例。我选择 GCP，因为它提供了许多托管服务，使小型团队可以构建数据管道，产生预测模型并利用深度学习。也可以通过 GCP 注册免费试用并获得 300 美元的余额。使用免费试用的 GCP 运行本系列中介绍的大多数主题已经够了，但如果您的目标是深入了解云端的深度学习，它将很快过期。

对于编程语言，我将使用 R 来编写脚本，Java 用于生产，以及使用 SQL 来处理 BigQuery 中的数据。我还会介绍其他工具，如 Shiny。建议读者掌握一些 R 和 Java 的使用经验，因为我不会介绍这些语言的基础知识。

* * *

[Ben Weber](https://www.linkedin.com/in/ben-weber-3b87482/) 是游戏行业的数据科学家，在 Electronic Arts，Microsoft Studios，Daybreak Games 还有 Twitch 都有工作经验。他还是 FinTech 初创公司的第一位数据科学家。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
