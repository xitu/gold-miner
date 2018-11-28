> * 原文出自：[Google AI Blog](https://ai.googleblog.com/2018/10/curiosity-and-procrastination-in.html)
 > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
 > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/curiosity-and-procrastination-in.md](https://github.com/xitu/gold-miner/blob/master/TODO1/curiosity-and-procrastination-in.md)
 > * 译者：[haiyang-tju](https://github.com/haiyang-tju)
 > * 校对者：[Mcskiller](https://github.com/Mcskiller)，[Wangalan30](https://github.com/Wangalan30)
 
[强化学习](https://en.wikipedia.org/wiki/Reinforcement_learning)（RL）是机器学习中最活跃的研究技术之一，在这项技术中，当一个人工代理（artificial agent）做了正确的事情时会得到积极的奖励，反之则会受到消极的奖励。这种[胡萝卜加大棒](https://en.wikipedia.org/wiki/Carrot_and_stick)的方法简单而通用，比如 DeepMind 教授的 [DQN](https://deepmind.com/research/dqn/) 算法可以让它去玩老式的雅达利（Atari）游戏，可以让 [AlphaGoZero](https://deepmind.com/blog/alphago-zero-learning-scratch/) 玩古老的围棋游戏。这也是 OpenAI 如何教会它 [OpenAI-Five](https://blog.openai.com/openai-five/) 算法去玩现代电子游戏 Dota，以及 Google 如何教会机器人手臂来[抓取新物体](https://ai.googleblog.com/2018/06/scalable-deep-reinforcement-learning.html)。然而，尽管 RL 取得了成功，但要使其成为一种有效的技术仍面临许多的挑战。
  
标准的 RL 算法 [struggle](https://pathak22.github.io/noreward-rl/) 适用于对代理反馈稀疏的环境 —— 关键的是，这种环境在现实世界中很常见。举个例子，想象一下如何在一个迷宫般的大型超市里找到你最喜欢的奶酪。你搜索了一遍又一遍，但没有找到奶酪区域。如果你每走一步都没有得到“胡萝卜”或者“大棒”，那么你就无法判断自己是否在朝着正确的方向前进。在没有回报反馈的情况下，你如何才能不在原地打转呢？也许除了那个能够激发你走进一个不熟悉的产品区域去寻找心爱奶酪的好奇心，再没有什么能够打破这个循环了。
  
在论文“[基于可及性实现情景式的好奇心](https://arxiv.org/abs/1810.02274)”中 —— 这是 [Google Brain 团队](https://ai.google/research/teams/brain)、[DeepMind](https://deepmind.com/) 和 [苏黎世 ETH ](https://www.ethz.ch/en.html)之间合作的结果 —— 我们提出了一种新的情景式记忆模型，以给予 RL 奖励，这类似于在好奇心的驱使下来探索环境。由于我们不仅想让代理探索环境，而且要解决原始任务，所以我们在原始稀疏任务奖励的基础上增加了模型提供的奖励。联合奖励不再是稀疏的，这允许标准的 RL 算法可以从中得到学习。因此，我们的好奇心方法扩展了 RL 可解决的任务集。 

[![](https://3.bp.blogspot.com/-wwV_MTT8NpI/W89_jWW2FjI/AAAAAAAADas/n8Yh34UlrhIHSVW5owHNqOEq52r1Pyv9gCLcBGAs/s640/image3.png)](https://3.bp.blogspot.com/-wwV_MTT8NpI/W89_jWW2FjI/AAAAAAAADas/n8Yh34UlrhIHSVW5owHNqOEq52r1Pyv9gCLcBGAs/s1600/image3.png)

基于可及性实现情景式的好奇心：通过向记忆中添加观察机制，然后根据当前的观察与记忆中最相似的观察的距离来计算奖励。如果看到了在记忆中还没有出现的观察结果，代理会获得更多的奖励。

我们的方法中的关键想法是把代理对环境的观察储存在情景记忆中，同时当代理获得了在记忆中还没有表现出来的观察时给予奖励，从而避免原地打转，并最终向目标摸索前行。“不在记忆中”是我们方法中比较创新的定义 —— 寻找这样的观察内容即寻找不熟悉的事物。这样一种寻找不熟悉事物的驱动条件可以将人工代理引导至一个新的位置，从而避免了它在已知圈子中徘徊，并最终帮助它摸索到目标点。正如我们稍后将讨论的，我们的方法可以使代理避免一些其它方法中容易出现的不良结果。令我们惊讶的是，这些行为与外行人口中所谓的“拖延症”有一些相似之处。 
  
**以前的好奇心形式**  
尽管过去曾经有很多对好奇心进行制定的尝试\[1\]\[2\]\[3\]\[4\]，但在本文中，我们专注于一种自然且非常流行的方法：通过基于预测的惊讶来探索好奇心（通常称为 ICM 方法），该方法在最近的论文“[通过自我监督预测的好奇心驱动探索](https://pathak22.github.io/noreward-rl/)”中进行了探讨。为了说明惊讶是如何引起好奇心的，再次考虑我们在超市寻找奶酪的例子。 

[![](https://3.bp.blogspot.com/-mmkoFCNHjZo/W9ChEkHbAoI/AAAAAAAADb4/iFJYE7IRKRIg-CTxSa-ndRvmHHq5EfDUgCLcBGAs/s400/image1.jpg)](https://3.bp.blogspot.com/-mmkoFCNHjZo/W9ChEkHbAoI/AAAAAAAADb4/iFJYE7IRKRIg-CTxSa-ndRvmHHq5EfDUgCLcBGAs/s1600/image1.jpg)

插图 © [Indira Pasko](https://www.behance.net/gallery/71741137/Illustration-for-an-article-in-aigoogleblogcom)，在 [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US) 许可下使用。

当你在整个市场漫步时，你试着预测未来的情况（**“现在我在肉类区域，所以我认为拐角处的部分是鱼类区域 —— 这些区域通常在超市中是相邻的”**）。如果你的预测是错误的，你会感到惊讶（**“不，它实际上是蔬菜区域。我没料到！”**）因而得到相应的回报。这使你更加有动力接下来去看看这个角落周围的环境，探索新的位置来看看你对它们的期望是否是符合实际的（并且，希望能偶然间发现奶酪）。
  
类似地，ICM 方法建立了对整个世界环境的动态预测模型，并在模型未能做出良好预测时给予代理一定的奖励 —— 这是惊讶或新奇的标志。请注意，探索未访问的位置并不直接是 ICM 好奇心公式的一部分。对于 ICM 方法来说，访问它们只是用于获得更多“惊讶”的方式，从而最大化整体奖励。事实证明，在某些环境中可能存在其它方式会造成自我惊讶，从而导致无法预料的结果。

[![](https://4.bp.blogspot.com/-1-g1VrGbUpY/W8-MI2HcI1I/AAAAAAAADbg/O65BaNTc6fEcJjSouw-QG1g7JkeIXpGLACLcBGAs/s1600/image5.gif)](https://4.bp.blogspot.com/-1-g1VrGbUpY/W8-MI2HcI1I/AAAAAAAADbg/O65BaNTc6fEcJjSouw-QG1g7JkeIXpGLACLcBGAs/s1600/image5.gif)

基于惊讶的好奇心的代理在遇到电视画面时会被卡住。GIF 采用了来自© [Deepak Pathak](https://youtu.be/C3yKgCzvE_E) 的视频，在 [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/) 许可下使用。

**“拖延症”的威胁**  
在论文“[大规模好奇心驱动学习研究](https://pathak22.github.io/large-scale-curiosity/resources/largeScaleCuriosity2018.pdf)”中，ICM 方法作者以及 [OpenAI](https://openai.com/) 研究人员揭示了最大化惊讶的潜在危险：代理可能会放纵这种拖延行为，而不是为当前的任务做一些有用的事情。为了找出原因，让我们考虑一个常见思维实验，该实验被作者称为“嘈杂电视问题”，在这个实验中，一个代理被置于迷宫中，它的任务是找到一个高回报的物体（这类似于我们之前提到的超市例子中的“奶酪”）。该环境中还包含了一个电视装置，代理可以远程操控。电视装置的频道数量有限（每个频道都有不同的节目），并且每次按遥控器都会切换到一个随机频道。那么该代理会如何在这样的环境中执行呢？
  
对于基于惊讶的好奇心公式来说，改变电视频道会产生很大的回报，因为每次改变都是不可预测和令人惊讶的。至关重要的是，即使所有可用频道都循环播放之后，随机地频道选择也会确保每一个新的变化仍然是令人惊讶的 —— 因为代理正在预测频道改变后电视上会出现什么，而且这种预测很可能是错误的，从而导致惊讶出现。重要的是，即使代理已经看过每个频道的每个节目，变化仍然是不可预测的。因此，这种基于惊讶的好奇心会使得代理最终永远停留在电视机前，而不是去寻找那个非常有价值的物体了 —— 这类似于拖延症。那么，怎样定义好奇心才不会导致这种行为呢？
  
**情景式好奇心**  
在论文“[基于可及性实现情景式的好奇心](https://arxiv.org/abs/1810.02274)”中，我们探索了一种基于情景记忆的好奇心模型，这种模型不太容易产生“自我放纵”的即时满足感。为什么会这样呢？使用我们上面的例子，在更改了一段时间的频道之后，所有的节目都在内存中了。因此，电视节目将不再具有吸引力：即使屏幕上出现的节目顺序是随机且不可预测的，所有的这些节目已经在内存中了！这是与基于惊讶的方法的主要区别：我们的方法甚至不去尝试对可能很难（甚至不可能）预测的未来下注。相反地，代理会检查过去，以了解它是否看到过与当前**类似**的观察结果。这样我们的代理就不会被嘈杂的电视带来的即时满足所吸引。它将不得不去探索电视之外的世界来获得更多的奖励。
  
但是，我们如何判断代理是否看到了与现有内存中相同的内容内容？检查精确匹配可能是毫无意义的：因为在现实环境中，代理很少能看到两次完全相同的事情。例如，即使代理返回到同一个房间，它仍然会从一个与记忆中不同的角度来看这个房间。
  
我们训练一个[深度神经网络](https://en.wikipedia.org/wiki/Deep_learning)来测量两种体验的相似程度，而不是去寻求一个与内存中内容的精确匹配。为了训练这个网络，我们让它来猜测这两个观察内容是在时间上紧密相连，还是在时间上相距很远。我们使用时间接近程度（Temporal proximity）作为一个较好的指标，判断两个经历是否属于同一体验的一部分。该训练可以通过可达性来获取通用概念上的新颖性，如下所示。

[![](https://3.bp.blogspot.com/-7X2mG9KkAwA/W8-AwA02tDI/AAAAAAAADa8/ENoWNgeYDwwGDbbZV-cPGgJtwsTMeQc0wCLcBGAs/s640/image6.png)](https://3.bp.blogspot.com/-7X2mG9KkAwA/W8-AwA02tDI/AAAAAAAADa8/ENoWNgeYDwwGDbbZV-cPGgJtwsTMeQc0wCLcBGAs/s1600/image6.png)

可达性图会决定新颖性。而在实践中，该图是不可用的 —— 因此我们需要训练一个神经网络近似器来估计多步观察内容之间的关系。

**实现结果**  
为了比较不同的好奇心方法的性能表现，我们在两个具有丰富视觉效果三维环境中测试它们：即 [ViZDoom](https://arxiv.org/abs/1605.02097) 和 [DMLab](https://arxiv.org/abs/1612.03801)。在这些环境中，代理的任务是处理各种问题，比如在迷宫中搜索目标，或者收集好的以及避免坏的物体。DMLab 环境恰好可以为代理提供类似激光的科幻工具。在之前工作中的标准设置是为代理在所有任务中都设置 DMLab 的小工具，如果代理在特定任务中不需要此工具，则可以不用它。有趣的是，类似于上面描述的嘈杂电视实验，基于惊讶的 ICM 方法实际上是使用了这个工具的，即使它对于当前任务是无用的！当在迷宫中搜索高回报的物体时，它更喜欢花时间来标记墙壁，因为这会产生很多的“惊讶”奖励。从理论上来讲，应该是可以预测到标记结果的，但这在实践中是很难的，因为这很显然需要标准代理了解更深入的物理学知识才行。

[![](https://1.bp.blogspot.com/-pn6yWeacipw/W9ChvSGMPtI/AAAAAAAADcA/1yJQHc7dz1AOiXTm8OyBW1JDI3_r40vbgCLcBGAs/s1600/image7.gif)](https://1.bp.blogspot.com/-pn6yWeacipw/W9ChvSGMPtI/AAAAAAAADcA/1yJQHc7dz1AOiXTm8OyBW1JDI3_r40vbgCLcBGAs/s1600/image7.gif)

基于惊讶的 ICM 方法是在持续标记墙壁，而不是探索迷宫。

相反，我们的方法在相同的条件下学习合理的探索行为。这是因为它没有试图预测自身行为的结果，而是寻求从情景记忆中“更难”获得的观察结果。换句话说，代理隐式地追求一些目标，这些目标需要更多的努力才能获取到内存中，而不仅仅是单一的标记操作。

[![](https://3.bp.blogspot.com/-gqgK7Dd2jUw/W9CiFgzQmxI/AAAAAAAADcI/EcUCBL9w2Cc57jPFzHcOd70OX8yUzAuEQCLcBGAs/s1600/image6.gif)](https://3.bp.blogspot.com/-gqgK7Dd2jUw/W9CiFgzQmxI/AAAAAAAADcI/EcUCBL9w2Cc57jPFzHcOd70OX8yUzAuEQCLcBGAs/s1600/image6.gif)

我们的方法展示出的合理的探索行为。

有趣的是，我们给予奖励的方法会惩罚在圈子中循环的代理。这是因为在完成第一次循环后，代理不会遇到除记忆中的观察之外的新的观察结果，因此不会得到任何的奖励：

[![](https://3.bp.blogspot.com/-s_QMz-9Hwfc/W89-GjKp7xI/AAAAAAAADaU/HRe_JVE2tyIOyJhFp8UjbtvTbtLxK6KqQCLcBGAs/s640/image8.gif)](https://3.bp.blogspot.com/-s_QMz-9Hwfc/W89-GjKp7xI/AAAAAAAADaU/HRe_JVE2tyIOyJhFp8UjbtvTbtLxK6KqQCLcBGAs/s1600/image8.gif)

方法中奖励的可视化：红色表示负面的奖励，绿色表示积极的奖励。从左到右：带有奖励的地图，内存中带有当前位置的地图，第一人称视角图。

同时，我们的方法有利于良好的探索行为：

[![](https://2.bp.blogspot.com/-vYTrGZe07E8/W9CinK0dkyI/AAAAAAAADcU/rRYZw30k_0IQ5SrOzamcaKdsXk4JDhutwCLcBGAs/s640/image2.gif)](https://2.bp.blogspot.com/-vYTrGZe07E8/W9CinK0dkyI/AAAAAAAADcU/rRYZw30k_0IQ5SrOzamcaKdsXk4JDhutwCLcBGAs/s1600/image2.gif)

方法中奖励的可视化：红色表示负面的奖励，绿色表示积极的奖励。从左到右：带有奖励的地图，内存中带有当前位置的地图，第一人称视角图。

希望我们的工作有助于引领新的探索方法浪潮，能够超越惊讶机制并学习到更加智能的探索行为。具体方法的深入分析，请查看我们的[研究论文](https://arxiv.org/abs/1810.02274)预印本。 
  
**致谢：**  
**该项目是 Google Brain 团队、DeepMind 和 ETH Zürich 之间合作的成果。核心团队包括 Nikolay Savinov、Anton Raichuk、Raphaël Marinier、Damien Vincent、Marc Pollefeys、Timothy Lillicrap 和 Sylvain Gelly。感谢 Olivier Pietquin、Carlos Riquelme、Charles Blundell 和 Sergey Levine 关于该论文的讨论。感谢 Indira Pasko 对插图的帮助。**
  
**参考文献：**  
\[1\] "[Count-Based Exploration with Neural Density Models](https://arxiv.org/abs/1703.01310)", _Georg Ostrovski, Marc G. Bellemare, Aaron van den Oord, Remi Munos_  
\[2\] "[#Exploration: A Study of Count-Based Exploration for Deep Reinforcement Learning](https://arxiv.org/abs/1611.04717)", _Haoran Tang, Rein Houthooft, Davis Foote, Adam Stooke, Xi Chen, Yan Duan, John Schulman, Filip De Turck, Pieter Abbeel_  
\[3\] "[Unsupervised Learning of Goal Spaces for Intrinsically Motivated Goal Exploration](https://arxiv.org/abs/1803.00781)", _Alexandre Péré, Sébastien Forestier, Olivier Sigaud, Pierre-Yves Oudeyer_  
\[4\] "[VIME: Variational Information Maximizing Exploration](https://arxiv.org/abs/1605.09674)", _Rein Houthooft, Xi Chen, Yan Duan, John Schulman, Filip De Turck, Pieter Abbeel_
