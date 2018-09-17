> * 原文地址：[The Best Database-as-a-Service Solutions of 2018](https://uk.pcmag.com/software/116526/guide/the-best-database-as-a-service-solutions-of-2018)
> * 原文作者：[Pam Baker](https://uk.pcmag.com/u/pam-baker)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-database-as-a-service-solutions-of-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-database-as-a-service-solutions-of-2018.md)
> * 译者：[cf020031308](https://github.com/cf020031308)
> * 校对者：

# 2018 年度最佳数据库即服务解决方案

从应用程序到工作流，随处都有数据库的用武之地，而为大多数企业部署这些数据引擎的最佳方式便是成本低廉且功能先进的数据库即服务（DBaaS）。这里我们调研了一些顶级 DBaaS 解决方案供您参考，您可根据自身业务选择其中最合适的。

![](https://i.loli.net/2018/09/09/5b94c0c4b03e9.png)

## 什么是数据库即服务（DBaaS）？

数据库即服务（DBaaS）是云上数据库存储和服务的术语。它具有许多其他云服务常见的优缺点，例如一方面是更好的成本控制，另一方面是比内部替代方案更有限的功能。不同的是，它可兼作引擎式软件，支持从直接相关的[数据可视化](https://uk.pcmag.com/cloud-services/83744/guide/the-best-data-visualization-tools-of-2018)工具到整个组织的[企业资源规划](https://uk.pcmag.com/cloud-services/83146/guide/the-best-erp-software-for-2018)（ERP）平台的大量其他软件即服务（SaaS）应用。同时 DBaaS 这种解决方案仍继承着[数据库](https://www.pcmag.com/encyclopedia/term/40871/database)功能所特有的优缺点。

DBaaS 的好处之一是令之前只能用于大型企业的技术更易使用，也降低了数字时代特有用例的准入门槛，例如[物联网](https://uk.pcmag.com/feature/88407/how-to-build-a-business-ready-internet-of-things-use-cases)（IoT）数据流、[机器学习](https://uk.pcmag.com/feature/89094/the-business-guide-to-machine-learning)（ML）数据训练，以及辅助边缘计算的混合应用等。

DBaaS 的缺点包括数据库的普遍僵化、数据科学的复杂性、集成的不灵活性、网络性能问题以及大数据传输带来的复杂性。这些限制可能导致不得不需要[数据库管理员](https://www.pcmag.com/encyclopedia/term/40873/database-administrator)（DBA）的帮助，尽管许多 DBaaS 供应商声称他们的平台是可自助服务且对用户友好的。

重要的是，哪怕 DBaaS 产品中数据库的启动和配置已有一定程度的自动化，数据科学仍不容易。但多种 DBaaS 产品和服务中，有的比其他的更易用，即使普通开发者和业务分析师也足以胜任。

我从开发者和分析师的角度做了这个总结，因此这对于内部 IT 资源很少的中小型企业（SMB）也有借鉴意义。这个总结的目的不是要从严格的技术角度排出谁优谁劣，而是确定一个普通用户在没有 DBA 的帮助下可以将该服务使用到何种程度，同时仍保留该技术的全部优势。如果仅考虑技术方面，那么供应商排名可能会有所不同。

## 在 DBaaS 中“易于使用”意味着什么

与任何其他 SaaS 产品一样，DBaaS 实际上是其他人服务器上的软件。即使在不幸名为“无服务器”的模型中也是如此。本文的“易于使用”不仅调研[用户界面](https://www.pcmag.com/encyclopedia/term/53558/user-interface)是否对用户友好，还涉及以下方面：

1. 是否提供指导，帮助用户根据自身数据或工作量选择合适的数据库类型或引擎，
2. 加载和传输数据的容易程度，
3. 服务器硬件配置和服务配置项的智能程度，以及
4. 备份和恢复过程的自动化程度。

如果用户单是配置数据库就得做出一长串决策，那么无论 UI 上有多少下拉菜单和说明框，它对于非 DBA 人士来说就都不算易用。然而对 DBA 来说，无论哪种都算易用，那么出于不同目的也许换个面貌也很好。换句话说，为了使 DBaaS 成为一个强大的自助服务平台，它需要在每一个实际交互细节上消除对 DBA 的需求。

另一方面，如果它是已有数据库的备份，或是混合数据库的一部分，甚至是公司主数据库（云时代的公司通常是这种情况），那么是否利于 DBA 使用和监控就应该是要考虑的首要因素。例如，如果您的公司多年来一直在本地运行 Microsoft SQL Server 实例，而现在选择添加一个 Microsoft Azure SQL 数据库实例作为云上备份，则大多数最终用户将永远用不到这个实例。同样，如果数据库的主要任务是支持另一个应用程序或工作流，那么用户通常不需要直接与其进行交互。毕竟，一旦数据库启动并运行，用户就可以借助[商业智能](https://uk.pcmag.com/cloud-services/74173/guide/the-best-self-service-business-intelligence-bi-tools-of-2018)（BI）、开发者和 [DevOps](https://www.pcmag.com/encyclopedia/term/66383/devops) 应用程序等工具来完成他们真正感兴趣的工作。大多数情况下，数据库仍处于后台，不是 DBA 的话很少需要碰它，即使是高级用户。

也就是说，这篇总结中的易用性包括所提供的所有服务。这些服务使得开发者、分析师以及少数 SMB 通用技术人员得以随时启用数据库，而只需要很少的指令，以及信用卡和一台能上网的笔记本电脑。

考虑到这些，Microsoft Azure SQL 数据库是最容易使用的，MongoDB Atlas 紧随其后。要从这两个“主编推荐”奖项得主中选出适合您使用的，应多考虑您的数据格式和业务，而不是易用性。 IBM Db2 on Cloud 也很容易使用，但很多开发者可能会不赞同。除了大多集中在开发者的设计限制上的槽点外，IBM Db2 on Cloud 还有可选择地区很少的问题，这可能是受限于欧盟[通用数据保护法规](https://uk.pcmag.com/feature/91721/gdpr-begins-today-what-you-need-to-know)（GDPR）。诚然，MongoDB Atlas 还不符合[健康保险流通与责任法案](https://www.pcmag.com/encyclopedia/term/44279/hipaa)（HIPAA），但这是暂时的。即便如此，HIPAA 对开发者的影响也比 GDPR 少，这使得后者成为更多开发者、分析师和开发者的关注点。

## 测试版本，以及地区的重要性

对每种产品的调研内容还包括是否有试用版/免费版及其限制。例如，MongoDB Atlas 有一个“永久免费”版本，512 MB 容量和共享[随机存取存储器](https://www.pcmag.com/encyclopedia/term/50159/ram)（RAM）。 IBM Db2 on Cloud 有一个免费的含企业功能的开发者版本，但其免费商业版 Express-C 不含高级企业功能。付费版本差异较小，因为它们通常与存储和计算用量而非功能特性相挂钩。但在选择之前请注意，各种版本中可用的功能和地区非常重要。

显然，如果一个版本没有你正需要的高级企业功能，例如 IBM Db2 on Cloud 的 Express-C 版，那它就没用了。同样，如果您需要解决 GDPR 的问题，或者您需要为世界各地的大量用户提供低延迟的应用程序，那么 Microsoft Azure SQL 数据库惊人的全球 140 个国家的 50 个可选地区就很重要了。

地区方面，Microsoft Azure SQL 数据库是迄今为止可选地区最多的。 MongoDB Atlas 排名第二，但这只是因为它托管在 [Amazon Web Services](https://uk.pcmag.com/amazon-web-services/73783/review/amazon-web-services)（AWS）、[Google Cloud](https://uk.pcmag.com/google-cloud-platform/73782/review/google-cloud-platform) 和 [Microsoft Azure](https://uk.pcmag.com/microsoft-azure/73781/review/microsoft-azure) 上，利用了这三家服务提供的地区。另外，与直觉相反，谷歌 BigQuery 的地区数量最少。

能够为数据库选择地区位置非常重要，原因有两个。首先，由于 GDPR 等法规，您必须确定数据所在的位置（即使在云中）、移动位置以及使用方式。即使您没有欧盟（EU）客户数据或欧盟员工数据，为保持符合 GDPR 标准也必须能够选择合适的数据库位置。这里有好些情况可能触碰到 GDPR。

例如，员工可能是美国人，因此他的数据不受 GDPR 的影响。他的妻子可能是欧洲人或美国人，但如果他们的孩子出生在欧洲，就可能拥有双重国籍。那么他们的保险数据将受 GDPR 的影响。因此，即使公司没有欧盟客户或欧盟员工数据，也仍需要符合 GDPR 标准。该法律非常复杂。欧盟甚至还有另外的更复杂的隐私法。因此，谨慎地了解您的数据在何处以及发生了什么，再想想您是否还认为您没有任何欧盟个人数据需要担心。

您的数据和应用程序越近，性能就越好，就越不会有滞后或其它问题。您会希望找个与数据库相同的数据中心部署您的应用程序或将您的数据库[寄存](https://www.pcmag.com/encyclopedia/term/39977/colocation)在应用程序旁。

供应商之间以及单个供应商的不同产品之间，版本也存在很大差异。有些刚开始不贵，但通过各种工具和服务升级来刺激消费，提高成本，例如额外的安全性或备份和恢复服务。注意这一点。

这篇总结中，我主要使用由供应商设置的中等价位测试帐户，而不是更受限的试用版或免费版。有时我会传输自己的测试数据，有时我会加载供应商的测试数据或使用他们加载好的数据集。通常，供应商提供了额度以确保我可以彻底测试他们的系统。有时我用免费的开发者版本测试，比如说 SAP Cloud Platform，因为这些版本通常是功能齐全的。不论如何，我会在每篇调研中都写明测试的版本。

## SQL 还是 NoSQL？

另一个使得本文难以直接对比的因素是数据库的类型。正如所有数据专业人士所知，[SQL](https://www.pcmag.com/encyclopedia/term/51902/sql) 处理结构化数据，[NoSQL](https://www.pcmag.com/encyclopedia/term/63645/nosql) 用于非结构化数据，但这种区别对于普通用户来说可能并不明显。结构化数据的例子是电子表格，而非结构化数据的示例是 Twitter 反馈消息。 SQL 数据库通常称为关系数据库，而 NoSQL 数据库称为非关系数据库。

但是，当涉及到 DBaaS 时，选项更加多样化，而不仅仅是确定数据是结构化还是非结构化。例如，开源 NoSQL 的 MongoDB Atlas 运行在其他品牌的云服务上，如 AWS、Google 和 Microsoft。一些供应商会指导您完成迷宫般的选项，因为他们的品牌 DBaaS 服务提供了其它类型数据库的产品选项。

例如，IBM Db2 on Cloud 就是 SQL，但它会在一开始就将用户导入 IBM 的 NoSQL DBaaS 产品 [Cloudant](https://www.ibm.com/cloud/cloudant)，或开源数据库 MongoDB on IBM，就像上传的数据所指示的那样。这对于那些数据科学技能很少或理解力有限的人来说非常有用。

在每篇调研中，我都会注明 DBaaS 产品是 SQL 还是 NoSQL，以及产品中是否有其他数据库选项。大多数服务要求您本身就知道您需要什么类型的数据库。少数服务，如 IBM Db2 on Cloud，会通过新手教程引导您选择正确的数据库。

这有一个快速的经验法则：如果您使用的是机器可读的数据，那么您需要 SQL。想想电子表格和物联网数据。如果它是人类的想法或表达，那么你需要 NoSQL。想想社交媒体、视频数据和音频数据。但要事先知道，有时应用程序会向推动您选择某一种类型，通常是 SQL。但有时最终目标会推动您选择另一种类型：NoSQL，利于更大、更快地扩展。

最后，请记住，机器学习辅助比自己篡改数据更好。 机器学习的支持也在调研中有注明。

## 特色数据库即服务解决方案调研：

### [Microsoft Azure SQL Database 调研](https://uk.pcmag.com/microsoft-azure-sql-database/116530/review/microsoft-azure-sql-database) ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

**优点：** 功能丰富。使用方便。许多地区都有更多符合 GDPR 标准的选项。迁移中没有应用程序破损。基于机器学习的自动调整功能。支持 2005 年之后的 SQL 版本。

**缺点：** 仅适用于结构化数据，因为数据库是 SQL。非常适合复杂的查询，但不适合不规则的人类通信数据。

**概要：** Microsoft Azure SQL 数据库是一种出色的数据库即服务（DBaaS）解决方案，适用于开发者、业务分析师和数据库管理员，因为它易于使用且可控性出色。

[调研详情](https://uk.pcmag.com/microsoft-azure-sql-database/116530/review/microsoft-azure-sql-database)

### [MongoDB Atlas 调研](https://uk.pcmag.com/mongodb-atlas/116531/review/mongodb-atlas) ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

**优点：** 易于使用。开源，具有强大的扩展、分片、无服务器和机器学习功能。

**缺点：** 它是 NoSQL，因此它不适合复杂的查询或需要 HIPAA 合规性的项目。某些应用程序需要 SQL 数据库才能运行，就无需考虑 NoSQL 数据库。

**概要：** MongoDB Atlas 是开发者的理想数据库，具有非常简单的用户界面，比大多数数据库即服务（DBaaS）解决方案更自动化，高度的灵活性和可控性，内置复制与零锁定。

[调研详情](https://uk.pcmag.com/mongodb-atlas/116531/review/mongodb-atlas)

### [Amazon 关系型数据库服务调研](https://uk.pcmag.com/amazon-relational-database-service/116529/review/amazon-relational-database-service) ⭐️ ⭐️ ⭐️ ⭐ ️

**优点：** 稳定而强大。为用户提供充分的控制。非常有安全意识。

**缺点：** 设置和移动数据复杂。需要数据库管理员和网络专业人员的帮助才能进行设置。贵。

**概要：** Amazon 关系型数据库服务不是一种对新手友好的数据库即服务（DBaaS）解决方案，但如果有合适的专业人员帮助您，它将是一个很棒的关系型数据库服务。

[调研详情](https://uk.pcmag.com/amazon-relational-database-service/116529/review/amazon-relational-database-service)

### [Google BigQuery 调研](https://uk.pcmag.com/google-bigquery/116528/review/google-bigquery) ⭐️ ⭐️ ⭐️ ⭐️

**优点：** 非常适合大数据项目。数据提取灵活。分析快速。几乎可以与任何类型的数据集成。

**缺点：** 专为大数据而设计，因此对小型数据集来说太重了。SQL 方言令人困惑。如果没有适当关注工具使用和自动扩展，将会产生大量成本。更好的统一费率定价。

**概要：** Google BigQuery 是一个出色的数据库即服务（DBaaS）解决方案，适用于云时代的公司以及任何从事机器学习应用程序开发或处理大量数据集的人。

[调研详情](https://uk.pcmag.com/google-bigquery/116528/review/google-bigquery)

### [IBM Db2 on Cloud 调研](https://uk.pcmag.com/ibm-db2-on-cloud/116532/review/ibm-db2-on-cloud) ⭐️ ⭐️ ⭐️ ⭐️

**优点：** 数据迁移和设置异常简单。设计精良。

**缺点：** 可选地区较少，可能会影响您的性能和合规性要求，具体取决于您对数据库的使用方式。

**概要：** IBM Db2 on Cloud 是面向开发者和业务分析师的理想数据库即服务（DBaaS）解决方案，因为他们可以在没有数据库管理员帮助的情况下使用它，而无需太多专业技能。

[调研详情](https://uk.pcmag.com/ibm-db2-on-cloud/116532/review/ibm-db2-on-cloud)

### [SAP Cloud Platform 调研](https://uk.pcmag.com/sap-cloud-platform/116527/review/sap-cloud-platform) ⭐️ ⭐️ ⭐️

**优点：** 非常适合 HANA 用户和大数据开发者。是的，这意味着适合物联网、机器学习和 Java。

**缺点：** 拥有两个不同的开发者环境，这令人困惑，且可能具有限制性。

**概要：** SAP Cloud Platform 还不够成熟，但它仍然是一个功能强大且独特的数据库即服务（DBaaS）解决方案，具有许多重要功能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
