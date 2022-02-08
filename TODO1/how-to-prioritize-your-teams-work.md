> * 原文地址：[How To Prioritize Your Team’s Work](https://medium.com/better-programming/how-to-prioritize-your-teams-work-9e68f5e571c)
> * 原文作者：[Maria Valcam](https://medium.com/@mariavalerocam)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-prioritize-your-teams-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-prioritize-your-teams-work.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[sunbufu](https://github.com/sunbufu), [Baddyo](https://github.com/Baddyo)

# 如何确定团队工作的优先级

> 先了解你公司的目标以及你团队的目标

![](https://raw.githubusercontent.com/stuchilde/public-images/master/img/20191124002420.jpeg)

---

## 日常工作

对于每家公司，我们可以将工作分为三大类：

* **产品相关的工作** —— 这就是用户能看到的。通常由产品负责人定义，它包含一些功能以及程序漏洞。
* **内部 IT 相关的工作** —— 改善基础架构或日常运营，它包括创建新环境、编写自动化脚本、改进 CI/CD 以及更新依赖项等。
* **计划外的工作以及重新放回的任务** —— 突发情况和问题。这无法计划，所以在本文的剩余部分中我将忽略它。

* 注意：我参考了《DevOps 手册》中的四种工作类型，并对它们做了一些更改：将业务项目重命名为产品工作（所有的项目都是业务相关的项目）并且将内部 IT 项目和更新合并为一个。

但是，我们如何确定工作的优先级呢？要回答这个问题，我们需要知道公司的目标是什么，我们团队的目标是什么。

更重要的是：

为什么你每天上班？

---

## 从大局出发

为了更大的愿景，需要将公司的目标和团队的目标传达给每一个人，**OKR** 是一个框架，它可以帮助在组织的上下级中实现目标。

注意：OKR 广泛用于一些科技公司：Google、Intuit、Microsoft、Amazon、Intel、Facebook、Netflix、Samsung、Spotify、Slack、Twitter、Salesforce.com、Deloitte、Dropbox 等。

#### OKR（目标 + 关键成果）是什么？

OKRs 有两个部分：

* **目标** — 需要实现的目标。它们必须是有意义的、具体的、行动导向的并且（理想情况下）鼓舞人心的。

* **关键成果** — 我们如何实现它。它们一定要遵循 [SMART](https://corporatefinanceinstitute.com/resources/knowledge/other/smart-goal/) 原则（明确、可衡量、可达成、实际、及时）。

约翰·杜尔在他的著作《衡量事项》中定义了它们。观看此视频以进行快速总结。

![](https://raw.githubusercontent.com/stuchilde/public-images/master/img/20191124002837.jpg)

---

## 设定团队的 OKR

确定我们 OKR 的第一步是设定公司的目标，然后设定团队的目标，公司目标（和公司战略）由董事定义。

1. 了解公司的 OKR 

2. 为团队设定明确的 OKR

通常，团队的目标仅由产品负责人确定。他们据此创建他们的产品待办需求。对他们来说，这很容易，因为他们了解业务方面，但是这种方法存在许多问题：

* 缺少对于业务发展至关重要的内部 IT OKR，如果仅以产品工作为目标，那么服务的速度、质量和稳定性将受到伤害。
* 开发人员不会理解他们工作的意义，团队中的每个人都应该参与目标的设定，以便他们了解全局并可以在日常工作中进行权衡。正如《哈佛商业评论》文章“[不要让指标破坏你的业务](https://hbr.org/2019/09/dont-let-metrics-undermine-your-business)”中所描述，开发人员需要明白指标是真实目标的代理。

解决方案？团队中的每个人都应该参与定义团队的 OKR。

在每个人都了解业务目标之后，它们可以坐在一起，就团队应该专注于哪些方面来帮助实现这些目标进行讨论。最终，他们应该定义关键成果来保证目标的可追溯性。

---

## 技术 OKR

你觉不觉得和 PM 达成一致是一件困难的事情？提醒他们，内部工作也能为客户带来价值，所以错过它们对公司来说也是致命的。

![](https://raw.githubusercontent.com/stuchilde/public-images/master/img/20191124003216.jpeg)

您可以添加以下目标：

* **改善交付** —— [DevOps 状态报告](https://services.google.com/fh/files/misc/state-of-devops-2019.pdf)显示了 31000 份来自在职专业人员的调查反馈的结论。它始终指向的是反应开发和交付过程中有效性相同的四个指标。它们分别是交付周期、部署频率、更改失败、可用性和恢复时间。这些指标将高绩效者和低绩效者区分开。
* **降低风险因素** —— 首先，你应该确定你的风险（使用便利贴与你的团队一起做），根据相关性对它们进行排序，设定它们发生的可能性（低、中、高）。然后，你的团队应该在表格上记录下 OKR。

注意：你应该每年检查一次风险因素。

* **降低成本** —— 你还在为一个应用花费太多？新项目还没有成果？那笔钱本可以花在你公司的其他地方，我们需要通过减少不必要的开支来考虑这种机会成本。

注意：对于某些低成本的公司而言，减少成本的工作可能是至关重要的。

---

## 放在一起

一旦你的团队有了目标，每个新项目都应该与 OKR 关联起来。如果一个项目没有对 OKR 作出贡献，那它就是在浪费团队的时间。

提示：

* **项目应被视为假设**，假设它可能无法实现你的目标。例子1：如果我们允许用户使用 PayPal 支付，我们将获得更多的用户。例子2：如果我们使用微服务，我们将缩短交付周期。所以，你需要验证关键成果是否正在改善。如果不能，请删除该项目并创建一个新的假设。
* 目标可以存在一年或更长的时间，但是关键成果会随着工作的进展而演变。所以，你应该至少每年一次**检查你的目标是否仍有意义**，并且每个月或者每个季度至少检查一次关键成果。
* 在整个组织中 **OKR 应该是透明的**。这可以激发部门之间的沟通，避免重复工作，因此致力于同一目标的团队可以齐心协力。
* 在谷歌，**每一位员工都有自己的 OKR**。其中，六到八个来自于团队，还有两个由他们自己设置（20% 的时间）。他们这样做是为了改善创新并促进人们为公司增添他们的远见（Gmail 就是在 Google 中的那 20% 的项目）。
* OKR 有两种类型：承诺型和进取型。承诺型 OKR 必须为团队实现目标，进取型 OKR 旨在引导团队朝着同一个方向前进，但预计不会实现。实际上，**实现所有的 OKR 是一个不够野心勃勃的信号**（参考 “[Google’s Larry Page on Why Moon Shots Matter](https://www.wired.com/2013/01/ff-qa-larry-page/)”）。

---

## 感谢阅读

我希望这些技巧能使你更好的安排工作的优先级。

你设置了不同的优先级吗？在评论中让我看到！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
