> * 原文地址：[Machine Learning for Humans🤖👶](https://medium.com/machine-learning-for-humans/why-machine-learning-matters-6164faf1df12)
> * 原文作者：[Vishal Maini](https://medium.com/@v_maini?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-machine-learning-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-machine-learning-matters.md)
> * 译者：[sisibeloved](https://github.com/sisibeloved)
> * 校对者：[DAA233](https://github.com/DAA233)、[whuzxq](https://github.com/whuzxq)

# 给人类的机器学习指南🤖👶

## 简单易懂的英文解释加上数学、代码和真实案例。

![](https://cdn-images-1.medium.com/max/800/1*Vkf6A8Mb0wBoL3Fw1u0paA.jpeg)

**[更新于 9/1/17]** 这个系列已经有完整的电子书了！[下载地址](https://www.dropbox.com/s/e38nil1dnl7481q/machine_learning.pdf?dl=0)。

### 导览

**[章节 1：论机器学习的重要性](https://medium.com/machine-learning-for-humans/why-machine-learning-matters-6164faf1df12)。** 人工智能和机器学习的广阔画卷 —— 过去、现在和未来。

**[章节 2.1：监督学习](https://medium.com/@v_maini/supervised-learning-740383a2feab)。** 学习解决方案。介绍线性回归、损失函数、过拟合和梯度下降。

**[章节 2.2：监督学习 II](https://medium.com/@v_maini/supervised-learning-2-5c1c23f3560d)。** 两种分类方法：逻辑斯蒂回归和支持向量机（SVM）。

**[章节 2.3：监督学习 III](https://medium.com/@v_maini/supervised-learning-3-b1551b9c4930)。** 无参学习器：k-近邻算法、决策树、随机森林。介绍交叉验证、超参调整和集成模型。

**[章节 3：无监督学习](https://medium.com/@v_maini/unsupervised-learning-f45587588294)。** 聚类：K-均值方法、分级。降维：主分量分析（PCA）、奇异值分解（SVD）。

**[章节 4：神经网络和深度学习](https://medium.com/@v_maini/neural-networks-deep-learning-cdad8aeae49b)。** 深度学习的工作原理。从人类的大脑中汲取灵感。卷积神经网络（CNNs）、循环神经网络（RNNs）。实际应用。

**[章节 5：强化学习](https://medium.com/@v_maini/reinforcement-learning-6eacf258b265)。** 探索和开发。马尔可夫决策过程。Q-学习、政策学习和深度强化学习。价值学习问题。

**[附录：机器学习的最佳资源](https://medium.com/@v_maini/how-to-learn-machine-learning-24d53bb64aa1)。** 精选的资源列表，用于创建您自己的机器学习课程。

### 面向的读者有哪些？

*   想要快速熟悉机器学习的技术人群
*   想要入门机器学习并愿意接受技术概念的非技术人群
*   对于机器是如何思考感兴趣的读者

这份指南老少皆宜。我们将会讨论概率、统计、编程、线性代数和微积分的基本概念，但就算没有基础知识亦能有所收获。

这个系列是一份在约 2~3 小时内快速熟悉高水平的机器学习概念的指南。

如果你想知道哪些课程值得学习、哪些书值得阅读、哪些项目值得尝试等等，看看我们在[附录：机器学习的最佳资源](https://medium.com/machine-learning-for-humans/how-to-learn-machine-learning-24d53bb64aa1)里的推荐吧。

### 论机器学习的重要性

与本世纪的其他创新相比，人工智能比更具前景。任何不了解它的人都会在一个充满梦幻般高科技的世界中幡然悔悟，发现自己的落伍。

人工智能的进步已然异常惊人。在过去四十年的一系列 [AI 寒冬和不切实际的希望](https://en.wikipedia.org/wiki/History_of_artificial_intelligence#The_first_AI_winter_1974.E2.80.931980) 之后，近些年数据存储和计算机运算性能上的飞速进步急剧地改变了游戏规则。

在 2015 年，Google 训练了一个对话机器人（AI），不仅能够作为一个称职的技术支持顾问与人类进行交流，还能讨论道德、发表意见并回答一些基于现实的问题。

![](https://cdn-images-1.medium.com/max/800/1*P1H87bkqILoGBVVT7g0T0A.png)

（[Vinyals 和 Le，2017](https://arxiv.org/abs/1506.05869)）

同年，DeepMind 开发了一个[智能体](https://storage.googleapis.com/deepmind-media/dqn/DQNNaturePaper.pdf)，仅接收像素和游戏分数作为输入，并在 49 个 Atari 游戏中超越了人类的表现。不久之后，在 2016 年，DeepMind 发布了一种全新的名为 A3C 的适用于人工智能[进行游戏的方法](https://arxiv.org/pdf/1602.01783.pdf)，从而超越了先前的成就。

同一时期，[AlphaGo](https://deepmind.com/research/publications/mastering-game-go-deep-neural-networks-tree-search/) 战胜了一位顶尖的围棋高手 —— 距机器首次在国际象棋上战胜人类已经过去了二十年，围棋这个领域一直被人类统治着，这可谓是一次惊人的胜利。许多高手无法领会机器怎么可能了解这个古老的中国战争艺术游戏的细节和复杂度，毕竟它有着 10¹⁷⁰ 种可能的对局（[宇宙中只有 10⁸⁰ 个原子](http://www.slate.com/articles/technology/technology/2016/03/google_s_alphago_defeated_go_champion_lee_sedol_ken_jennings_explains_what.html)）。

![](https://cdn-images-1.medium.com/max/800/1*2pYq0Qc3oMDYoVoEA9-6cg.png)

职业围棋选手李世石在与 AlphaGo 对战落败后复盘。[The Atlantic](https://www.theatlantic.com/technology/archive/2016/03/the-invisible-opponent/475611/) 摄。

在 2017 年 3 月，OpenAI 创造了能够[发明自己的语言](https://blog.openai.com/learning-to-communicate/)来合作并更加有效地达成目标的机器人。不久后，Facebook 宣布正在训练能够[谈判](https://code.facebook.com/posts/1686672014972296/deal-or-no-deal-training-ai-bots-to-negotiate/)甚至[撒谎](https://www.theregister.co.uk/2017/06/15/facebook_to_teach_chatbots_negotiation/)的机器人。

就在（本文完成的）几天前，在 2017 年 8 月 11 日，OpenAI 在在线多人对战游戏 Dota 2 中，1v1 战胜了世界顶尖的职业选手，完成了另一个令人难以置信的里程碑。

![](https://cdn-images-1.medium.com/max/800/1*eWnzwOQX5QgkQ4FRU_I6sg.png)

在 [YouTube](https://www.youtube.com/watch?v=wiOopO9jTZw) 上观看这场国际邀请赛 2017（Ti 7）中 Dendi（人类）对阵 OpenAI（机器人）的完整比赛。

许多生活中常见的技术都离不开人工智能。在你下一次前往台湾的旅程中，使用 Google Translate 应用，将相机对准菜单扫一扫，对应的菜单项会神奇地变成英文。

![](https://cdn-images-1.medium.com/max/800/1*x8IgnfzPL7iLZHa9Uhy50g.png)

Google Translate 通过卷积神经网络，实时地将英文翻译覆盖到饮品菜单上面。

如今 AI 被用来为癌症患者制定[基于病情的治疗计划](https://www.ibm.com/watson/health/oncology-and-genomics/oncology/)、从药物测试中即时分析结果以便快速[分配合适的专家](https://deepmind.com/applied/deepmind-health/)，和开展发现药物的[科学研究](http://benevolent.ai/)。

![](https://cdn-images-1.medium.com/max/800/1*GEo3QHtN3gcWt0b2k08q7w.png)

位于伦敦的 BenevolentAI 的大胆宣言（截图自[关于我们](http://benevolent.ai/about-us/)页面，2017 年 8 月）。

在日常生活中，机器取代传统意义上人类扮演的角色变得越来越普遍。真的，如果下次你打电话给酒店前台让他们送一些牙膏，出现在你面前的是一个小小的家务运输机器人，而不是一个真人时，请不要惊讶。

![](https://i.loli.net/2018/05/16/5afb8c9f2b861.png)

在本系列中，我们将探讨这些技术背后的核心机器学习概念。在完成整个系列之后，你应该不仅能从概念上描述它们运作的原理，并且可以熟练运用工具来构建类似的你自己的应用程序。

### 语义树：人工智能和机器学习

> 一点小建议：将知识看成一种**语义树** — 确保你理解了基本原理（主干和分支），然后再去看树叶/细节，否则它们会无处可栖。 — Elon Musk，[Reddit 有问必答](https://www.reddit.com/r/IAmA/comments/2rgsan/i_am_elon_musk_ceocto_of_a_rocket_company_ama/cnfre0a/)

![](https://cdn-images-1.medium.com/max/800/1*QJG2nMIqWHmLp2j4c0GVuQ.png)

机器学习是人工智能的众多子领域之一，关注如何让计算机学习经验和提升思考、计划、决定和行动的能力。

**人工智能是对智能体的研究，他们感知媒介周围的世界，形成计划并做出决定以实现其目标。** 它的基础包括数学、逻辑学、哲学、概率学、语言学、神经科学和决策论。许多领域属于人工智能的范畴，例如计算机视觉、机器人科学、机器学习和自然语言处理。

**机器学习是人工智能的子领域。** 它的目标是让计算机自行学习。一个机器学习算法使它能够识别观测数据中的模式，构建能够解释世界的模型，并在没有确切的预编程规则和模型的情况下预测事物的发展。

**人工智能效应：什么才是“人工智能”？**

“人工智能”的技术标准有点模糊，并且随着时间推移而不断改变。AI 这个标签通常用来形容能在传统领域取代人类的机器。有趣的是，一旦计算机知道如何完成这些任务，人们通常会说它不是**真正的**智能。这被称为 [**AI 效应**](https://en.wikipedia.org/wiki/AI_effect)。

例如，IBM 的深蓝在 1997 年击败了世界国际象棋冠军 [Garry Kasparov](https://medium.com/@GarryKasparov) 时，人们抱怨说它使用的是『蛮力』的方法，根本不是『真正』的智力。正如 Pamela McCorduck 所写的，**『人工智能领域的历史的一部分，就是每当有人想出如何让计算机做某事时 —— 成为一个出色的棋手，解决简单但相对没那么正式的问题 —— 就有一群评论家跳出来说，「那不叫思考！」』** （[McCorduck，2004](http://www.pamelamc.com/html/machines_who_think.html)）。

可能人类对于毫无保留地接收所谓的『人工智能』有种**难以言述**的抗拒吧：

『人工智能永远不可能实现。』 —— 侯世达

那么计算器能算 AI 吗？在某些解释中也许能算。那一辆自动驾驶汽车呢？在今天是的，而在未来或许算不上。新型的能够自动完成流程图的很酷的聊天机器人项目呢？当然……为什么不呢。

### 强大的人工智能将永远改变我们的世界；想了解这个过程，学习机器学习是一个很好的入口。

上面讨论的技术是 **狭义人工智能（ANI）** 的例子，它可以有效地执行一个狭义上的任务。

同时，我们还在继续向制造类人级别的**广义人工智能（AGI）**，也被称为[**强人工智能**](https://en.wikipedia.org/wiki/Artificial_general_intelligence)努力。AGI 的定义是一种人工智能，它能成功地完成**人类所能从事的任何智力活动**，包括学习、计划和不确定情况下的决策、用自然语言交流、开玩笑、操纵人、买卖股票或……对自身进行重编程。

而这最后一项是个大问题。一旦我们创建了一个可以改进自身的 AI，它将开启一个自我完善的循环，这可能导致在某一时期发生**智力爆炸**，从几十年到一天都有可能。

> 定义超级智能机器为一台机器，它可以在智力活动中远超任何聪明的人。因为设计机器是这些智力活动中的一种，超级智能机器可以设计出更好的机器；毫无疑问，这将是一个『智力爆炸』，而人类的智力将远远落在后面。因此，第一台超级智能机器是人类需要进行的最后一项发明，只要机器足够温顺地告诉我们如何控制它。 —— I.J. Good，1965

你可能听说过这一点被称为**奇点**。这个术语源自黑洞中心的引力奇点，黑洞是一个无限密度的一维点，在那里，我们了解的物理定律开始不复存在。

![](https://cdn-images-1.medium.com/max/800/1*rR4Hp7-pfgGBDqyPdcnh8g.png)

我们对黑洞边界之内的事情一无所知，因为没有光可以从黑洞的捕捉中逃逸。同样地，**当我们解锁了 AI 循环改进自身的能力之后，也没有人能够预测将会发生什么，就像创造出一个人类的老鼠可能无法预测人类会对他们的世界做什么一样。** 他会继续帮它们获取更多奶酪，就像它们预期的那样吗？（图片来自 [WIRED](http://www.wired.co.uk/article/what-black-holes-explained)）

人类未来研究学院最近发布了一份报告，对人工智能领域的研究者进行了 AGI 的时限调查，发现『**研究人员认为，人工智能有 50% 的几率在 45 年内在任何领域中胜过人类**』（[Grace 等人，2017](https://arxiv.org/pdf/1705.08807.pdf)）。我们曾与一些理智的人工智能实践者私下交谈过，他们预测的时限更长（上限是『永远』），而其他人给出的时限惊人地短 —— 仅仅只有几年。

![](https://cdn-images-1.medium.com/max/800/0*2TpuuqUKnhdnr5eK.)

来自 Kurzweil 的《奇点临近》，发表于 2005。现在，在 2017，只有几张海报能够名正言顺地留在墙上了。

比人类级别更高的 **超级人工智能（ASI）** 的出现对人类来说可能是最好或最坏的事情之一，它带来了一个巨大的挑战，即用有利于人类的方式确定 AI **想要**什么。

虽然说不好未来会发生什么，但有一点是肯定的：**2017 年是开始理解机器如何思考的好时机。** 不仅仅是像坐在扶手椅上的哲学家，带着对人工智能的尊重睿智地制定我们的路线图和政策这样抽象的理解，我们必须接触机器如何看待世界的细节 —— 他们“想要”什么，他们潜藏的偏见和失效模式，他们的性格怪癖 —— 就像我们研究心理学和神经科学，以了解人类如何学习、决定、行动和感觉。

关于人工智能存在着复杂的、高风险的问题，这些问题需要我们在未来几年的认真关注。

我们该如何抑制人工智能[进一步控制现有的数据集中明显的系统偏差](https://www.google.com/intl/en/about/gender-balance-diversity-important-to-machine-learning/)的倾向？我们应该如何看待世界上最好的技术专家之间关于人工智能潜在的风险和收益的[分歧](http://fortune.com/2017/07/26/mark-zuckerberg-argues-against-elon-musks-view-of-artificial-intelligence-again/)？在一个没有工作的世界里，人类的追求会发生什么变化？

机器学习是我们实现广义人工智能的核心，同时，它将改变每一个行业，并对我们的日常生活产生巨大的影响。这就是为什么我们认为机器学习值得了解，至少在概念层面上是这样的 —— 因此我们推出了这个系列，作为最佳的入门读物。

### 怎样阅读这个系列

你可以不必按部就班地阅读这个系列。根据你自己的兴趣和空余时间，有三种方法推荐给你：

1.  **T 形阅读法。** 从头读到尾。用你自己的语言概括一下每一个章节的内容（见：[Feynman technique](https://mattyford.com/blog/2014/1/23/the-feynman-technique-model)）；这样能够提升阅读的积极性并加深记忆。然后在你最感兴趣或与工作关联最为紧密的地方深入钻研。我们将会在每一章的结尾介绍一些拓展资源。
2.  **专注阅读法。** 跳到你最感兴趣的地方并把你的精力花在那儿。
3.  **[80/20 法](https://www.thebalance.com/pareto-s-principle-the-80-20-rule-2275148)。** 先通读全文，标记一些有趣的高级概念，然后花一晚时间好好钻研。😉

### 关于作者

![](https://cdn-images-1.medium.com/max/800/1*UWNsFVQBaDW5dq1HnW9k4w.png)

『读完这篇短文，我们就能理解什么是梯度下降了。』 来自爱丁堡的@ [The Boozy Cow](https://medium.com/@TheBoozyCow)

[Vishal](https://www.linkedin.com/in/vishalmaini/) 最近创办了 [Upstart](https://www.upstart.com/about#future-of-credit-2)，一个利用机器学习来定价、自动化借贷过程并获取用户的借贷平台。他热衷于应用认知科学、道德哲学和人工智能伦理学来创业。

[Samer](https://www.linkedin.com/in/samer-sabri-8995a717/) 是 UCSD 一位正在攻读计算机科学与工程的硕士生，并且是 [Conigo Labs](http://www.conigolabs.com/) 的创始人之一。在毕业之前，他创建了 TableScribe，一个面向中小企业的商业智能工具，并在麦肯锡公司待了两年，为财富 100 强公司提供咨询服务。Samer 之前在耶鲁学习了计算机科学、伦理学、政治学和经济学。

这个系列的大部分内容都是在为期 10 天的英国之行中写下的，经历了火车、飞机、咖啡馆、酒吧以及种种浮光掠影。我们的目标是巩固我们对人工智能、机器学习、以及其中的方法如何结合在一起的理解 —— 并在这个过程中创造出值得分享的东西。

现在，不要迟疑，让我们进入[**章节 2.1：监督学习**](https://medium.com/@v_maini/supervised-learning-740383a2feab)，开始探索机器学习的世界吧！

* * *

更多**给人类的机器学习指南**🤖👶系列：

*   **章节 1：论机器学习的重要性 ✅**
*   [章节 2.1：监督学习](https://medium.com/@v_maini/supervised-learning-740383a2feab)
*   [章节 2.2：监督学习 II](https://medium.com/@v_maini/supervised-learning-2-5c1c23f3560d)
*   [章节 2.3：监督学习 III](https://medium.com/@v_maini/supervised-learning-3-b1551b9c4930)
*   [章节 3：无监督学习](https://medium.com/@v_maini/unsupervised-learning-f45587588294)
*   [章节 4：神经网络和深度学习](https://medium.com/@v_maini/neural-networks-deep-learning-cdad8aeae49b)
*   [章节 5：强化学习](https://medium.com/@v_maini/reinforcement-learning-6eacf258b265)
*   [附录：机器学习的最佳资源](https://medium.com/@v_maini/how-to-learn-machine-learning-24d53bb64aa1)

#### 联系人：[ml4humans@gmail.com](mailto:ml4humans@gmail.com)

特别感谢 [_Jonathan Eng_](https://www.linkedin.com/in/jonathaneng1/)、[_Edoardo Conti_](https://www.linkedin.com/in/edoardoconti/)、[_Grant Schneider_](https://www.linkedin.com/in/grantwschneider/)、[_Sunny Kumar_](https://www.linkedin.com/in/sunnykumar1/)、[_Stephanie He_](https://www.linkedin.com/in/stephanieyhe/)、[_Tarun Wadhwa_](https://www.linkedin.com/in/tarunw/) 和 [_Sachin Maini_](https://www.linkedin.com/in/sachinmaini/)（系列编辑）的不可或缺的贡献和反馈。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
