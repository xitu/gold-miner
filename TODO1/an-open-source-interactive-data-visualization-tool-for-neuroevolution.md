> * 原文地址：[VINE: An Open Source Interactive Data Visualization Tool for Neuroevolution](https://eng.uber.com/vine/)
> * 原文作者：[Uber Engineering](https://eng.uber.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-open-source-interactive-data-visualization-tool-for-neuroevolution.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-open-source-interactive-data-visualization-tool-for-neuroevolution.md)
> * 译者：[Starrier](https://github.com/Starrier)
> * 校对者：[wzy816](https://github.com/wzy816)

# VINE：一种开源的神经进化（Neuroevolution）交互式数据可视化工具

在 Uber 的规模上，机器学习的进步可以显著增强为更安全和更可靠的交通解决方案提供动力的技术。Uber AI 实验室最近宣布的一项进展是[深度神经进化](https://eng.uber.com/deep-neuroevolution/)，其中进化算法（如进化策略（ES）和遗传算法（GA））帮助训练深层神经网络来解决困难的强化学习（RL）问题。最近，人们对深度神经进化的兴趣越来越大，其主要贡献来自于 [OpenAI](https://blog.openai.com/evolution-strategies/)、[DeepMind](https://deepmind.com/blog/population-based-training-neural-networks/)、[Google Brain](https://arxiv.org/abs/1802.01548) 和 [Sentient](https://www.sentient.ai/blog/evolution-is-the-new-deep-learning/) 。这反过来又造成了解决该领域的研究人员对工具的需求的问题。

特别是在神经进化和神经网络优化中，往往很难观察到学习过程的基本动态。为了弥补这一差距并开放观察过程，我们引入[视觉神经进化检查器（VINE）](https://github.com/uber-common/deep-neuroevolution)，一个开源的交互式数据可视化工具，旨在帮助那些对神经进化感兴趣的人更好地理解和探索这一系列算法。我们希望这项技术可以在未来激发神经进化的创新和应用。

VINE 可以高亮 ES- 和 GA- 风格的方法。本文中，我们将把 ES 应用于 [Mujoco](http://www.mujoco.org/index.html) [仿人运动任务](https://gym.openai.com/)的结果可视化为我们的示例。

在传统的 ES 应用（如 OpenAI 推广）中，一组称为伪后代云的神经网络针对几代人的目标进行优化。云中每个个体神经网络的参数通过随机扰动单个「父」神经网络的参数生成。然后根据目标对每个伪后代神经网络进行评估：在仿人学习任务中，每个伪后代神经网络控制机器人的运动，并根据机器人的行走能力获得一个分数，称为适应度。ES 基于这些适应度评分来聚合伪后代的参数来构造下一个父级（这几乎就像一种复杂的多亲交叉形式，也使人想起随机有限差分）。然后循环重复。

[![](https://eng.uber.com/wp-content/uploads/2018/03/fig1_left.gif)](http://eng.uber.com/wp-content/uploads/2018/03/fig1_left.gif)

[![](https://eng.uber.com/wp-content/uploads/2018/03/fig1_right.gif)](http://eng.uber.com/wp-content/uploads/2018/03/fig1_right.gif)

图 1：模拟机器人训练走遗传算法（左）和进化策略（右）。

### 使用 VINE

为了利用 VINE，在评估期间会记录每个双亲和所有假后代的行为特征（BC）。在这里，BC 可以是代理在与其环境交互时行为的任何指标。例如，在 Mujoco 中，我们简单地使用代理的最终位置｛x,y｝作为 BC，因此它表示代理从原点移到了什么位置。

可视化工具根据它们的 BC 将双亲和伪后代映射到 2D 平面上。为此，它调用图形用户界面(GUI)，其主要组件由两种相互关联的图形组成：一个或多个伪子代云图（在不同的 2D 平面上）和一个适应度图。如图 2 所示，下面的伪后代云图显示了每一代在云中的双亲和伪后代的 BC，而适应图作为世代进步的一个关键指标则显示了双亲的适应度得分曲线。

[![](https://eng.uber.com/wp-content/uploads/2018/03/image8.png)](http://eng.uber.com/wp-content/uploads/2018/03/image8.png)

图 2：伪子代云图和适合度图的事例。

然后用户和这些图交互，探索伪后代云的总体趋势以及任何双亲或伪后代在进化过程中的个体行为：（1）用户可以可视化任何一代的双亲，表现最好的和（或）整个伪后代云，并探索具有不同适应度的伪后代在 2D BC 平面上的数量和空间分布；（2）用户可以在世代间进行比较，浏览数代，以可视化父母和（或）伪后代云是如何在 2D BC 平面上移动的，以及这些移动与适应度评分曲线的关系（如图 3 所示，移动云的完整电影片段可以自动生成）；（3）点击云图上的任意一点，就会显示相应的伪后代的行为信息和适应度分数。

[![](https://eng.uber.com/wp-content/uploads/2018/03/image7.gif)](http://eng.uber.com/wp-content/uploads/2018/03/image7.gif)

图 3：可视化的世代行为演变过程。每一代颜色都会发生改变。在一代人的时间里，每一个伪后代颜色强度都是根据其在这一代人中的适应度分数的百分位数来计算的（合计为五个分箱）。

### 附加用例

该工具还支持默认功能之外的高级选项和自定义可视化。例如，作为最终单点｛x，y｝的替换，BC 可以替换为每个代理的完整轨迹（例如，用 1000 个时间点步骤连接的｛x，y｝） 代替单个最后｛x，y｝点。在这种情况下，当 BC 的维数超过 2 时，需要使用维数简约技术（如 [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis) 或者 [t-SNE](https://lvdmaaten.github.io/tsne/)）将 BC 数据降维到 2D。我们的工具会自动化这些过程。

GUI 能够加载多组 2D BC（可能通过不同的缩减技术生成），并将它们显示在同时连接的云图中，如图 4 所示。此功能为用户探索不同的 BC 选择和降维方法提供了一种便捷方式。此外，用户还可以通过定制功能扩展基础的可视化。图 4 展示了一个这样的自定义云图，可以显示某些类型的特定领域的高维 BC（在这种情况下，代理的完整轨迹）以及相应的减少的 2D BC。图 5 中定制云图的另一个例子允许用户在与环境交互时重放代理的确定性和随机行为。

[![](https://eng.uber.com/wp-content/uploads/2018/03/image1-2.png)](http://eng.uber.com/wp-content/uploads/2018/03/image1-2.png)

图  4：多个 2D BC 和一个高维 BC 的可视化以及一个适应度图。 

[![](https://eng.uber.com/wp-content/uploads/2018/03/image2.gif)](http://eng.uber.com/wp-content/uploads/2018/03/image2.gif)

图 5：VINE 允许用户查看任何代理的确定性和随机行为的视频。

该工具还设计用于处理移动任务以外的域。下图 6 演示了一个云图，它可视化了训练代理来玩 Frostbit 游戏，这是 Atari 2600 游戏之一，我们使用最后的模拟器 RAM 状态（长度为 128 的整数值向量，捕捉游戏中的所有状态变量）作为 BC，并应用 PCA 将 BC 映射到 2D 平面上。

[![](https://eng.uber.com/wp-content/uploads/2018/03/image3-1.png)](http://eng.uber.com/wp-content/uploads/2018/03/image3-1.png)

图 6：可视化代理学习来演示 Frostbite。 

从图中，我们可以观察到，随着进化的发展，伪后代云向左边移动，并向那里的星云移动。能够看到每个玩游戏的代理的相应视频，我们可以推断每个集群对应于语义上有意义不同的结束状态。

VINE 还可以与其他神经进化算法（如 GA）无缝协作，这些算法能使后代繁衍数代。事实上，该工具独立于任何特定的神经进化算法。用户只需要稍微修改他们的神经进化代码，就可以保存他们针对特定问题选择的 BC。在代码发行版中，我们提供了对 ES 和 GA 实现了此类修改以作示例。

### 下一步

由于进化方法是在一组点上操作，所以为新型可视化提供了机会。在实现了提供可视化功能的工具后，我们发现它很有用并且想在机器学习社区进行分享，让大家一起受益。随着神经进化扩展到具有数百万或更多连接的神经网络，通过 VINE 等工具获得更多的洞察力对加深进步越来越有价值，也越来越重要。

可以在此[链接](https://github.com/uber-common/deep-neuroevolution/tree/master/visual_inspector)找到 VINE。它是轻量级的，可移值的，而且是用 Python 实现的。

**致谢：** 我们感谢 Uber AI 实验室，尤其是 Joel Lehman、Xingwen Zhang、Felipe Petroski Such 和 Vashisht Madhavan 为我们提供了宝贵的建议和有益的讨论。 

图 1，左图来源：例如Felipe Petroski。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
