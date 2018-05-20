> * 原文地址：[Differentiable Plasticity: A New Method for Learning to Learn](https://eng.uber.com/differentiable-plasticity/)
> * 原文作者：[Uber Engineering](https://eng.uber.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/differentiable-plasticity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/differentiable-plasticity.md)
> * 译者：[luochen](https://github.com/luochen1992)
> * 校对者：

# 可微可塑性：一种学会学习的新方法

![](https://i.loli.net/2018/05/15/5afa39e829174.png)

作为 Uber 机器学习系统基础的神经网络，在解决包括图像识别、语言理解和博弈论在内的复杂问题方面被证明是非常成功的。然而，网络通常通过 [梯度下降](https://en.wikipedia.org/wiki/Gradient_descent) 训练​​到一个停止点，根据多次试验中的网络性能不断调整网络连接。一旦训练完成，网络就已经固定，连接不再改变；因此，除了以后的再训练（又需要很多样本）之外，实际上网络在训练结束时就停止学习。

相比之下，生物大脑表现出的 [**可塑性**](https://en.wikipedia.org/wiki/Neuroplasticity) —— 即在整个生命中，神经元之间连接持续不断地自主变化的能力，使动物能够从持续的经验中快速有效地学习。大脑中不同区域和连接的可塑性水平是数百万年来通过进化进行微调的结果，以便在动物的一生中进行有效地学习。由此产生的持续学习能力可以让动物只需很少的额外信息（additional data）就能适应变化或不可预测的环境。我们可以很快地记住以前从未见过的模式，或者在完全陌生的情况下从几次试验中学习新的行为。

为了给我们的人工智能体提供类似的能力，Uber 人工智能实验室开发了 [一种称为**可微可塑性**的新方法](https://arxiv.org/abs/1804.02464) 让我们通过梯度下降训练可塑的连接行为，以便他们可以帮助以前训练的网络适应未来的环境。虽然演化这种可塑性神经网络是 [进化计算长期研究的领域](https://arxiv.org/abs/1703.10371)。据我们所知，这里介绍的工作首次表明可以通过梯度下降优化可塑性网络。因为最近人工智能领域的重大突破是以基于梯度的方法为基础的（包括 [图像识别](https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks)、[机器翻译](https://research.google.com/pubs/pub45610.html) 和 [对弈](https://www.nature.com/articles/nature24270)）。使可塑性网络适应梯度下降训练可能会极大扩展这两种方法的力量。

### 可微可塑性是如何工作的

在我们的方法中，每个连接都会有初始权重，包括决定连接可塑性的系数。更准确地说，神经元 _i_ 的激活值  _y_<sub>_i_</sub> 计算如下：

[![可微可塑性方程](https://eng.uber.com/wp-content/uploads/2018/04/differentiable_plasticity_equation-300x89.png)](http://eng.uber.com/wp-content/uploads/2018/04/differentiable_plasticity_equation.png)

第一个等式是神经网络单元典型的激活函数，不包括输入权重的固定分量（绿色）和可塑性分量（红色）。可塑性分量的 _H_<sub>_i,j_</sub> 项作为输入和输出的函数可以自动更新（正如在第二个等式指出的那样，其他公式也是可以的，在 [这篇论文](https://arxiv.org/abs/1804.02464) 中有讨论。）

在初始训练期间，梯度下降调整结构参数  _w_<sub>_i,__j_</sub> 和 <span style="color: #333333;">_α_<sub>_i,j_</sub> 这决定了固定和可塑性分量的大小。因此，在初始训练之后，智能体可以从持续性的经验中自动学习，因为每个连接的可塑性分量都通过神经活动充分塑造以存储信息，让人想起动物（包括人类）中某些学习的形式。

### 展示可微可塑性

为了展示可微可塑性的潜力，我们将其应用于一些需要从不可预知刺激中快速学习具有挑战性的任务。

在图像重建任务中（图1）网络存储一组从未见过的自然图像；然后显示这些图像中的一张，但其中一半被擦除，并且网络必须从记忆中重建缺失的一半。我们展示了可微可塑性能有效地训练具有数百万参数的大型网络来解决这个任务。重要的是，具有非塑性连接的传统网络（包括 [LSTMs](https://en.wikipedia.org/wiki/Long_short-term_memory) 等最先进的循环结构）无法解决此任务，并且花费相当多的时间来学习它极大简化的版本。

[![图像重建任务](https://eng.uber.com/wp-content/uploads/2018/04/image2.jpg)](https://www.cs.toronto.edu/~kriz/cifar.html)

[![](https://eng.uber.com/wp-content/uploads/2018/04/anim0.gif)](http://eng.uber.com/wp-content/uploads/2018/04/anim0.gif)

图 1：图像补全任务（每一行都是单独的重建过程（episode））。在显示三张图像之后，网络获得部分图像并且必须从记忆中重建缺失的部分。非塑性网络（包括LSTM）无法解决此任务。源图像来自 [CIFAR10 数据集](https://www.cs.toronto.edu/~kriz/cifar.html)

我们还训练了可塑性网络来解决 [Omniglot 任务](https://github.com/brendenlake/omniglot)（一个标准的“学会学习”任务）这需要学习从每个人单独绘制的符号中识别一组陌生的手写符号。此外，该方法还可以应用于强化学习问题：可塑性网络在迷宫探索任务中胜过非塑性网络，其中智能体必须发现、记忆并反复到达迷宫内的奖励位置（图 2）。通过这种方式，将可塑性系数添加到神经网络这一简单的思想提供了一种真正新颖的方法 —— 有时是最好的方法 —— 解决广泛的需要从持续经验中不断学习的问题。

[![迷宫探索任务 —— 随机](https://eng.uber.com/wp-content/uploads/2018/04/image5.gif)](http://eng.uber.com/wp-content/uploads/2018/04/image5.gif)

[![迷宫探索任务 —— 应用可微可塑性](https://eng.uber.com/wp-content/uploads/2018/04/image4.gif)](http://eng.uber.com/wp-content/uploads/2018/04/image4.gif)

图 2：迷宫探索任务。智能体（黄色方块）尽可能多地到达奖励地点（绿色方块）从而获得奖励（智能体在每次发现奖励时将其转移到随机地点）。在第 1 次探索迷宫时（左图），智能体的行为实质上是随机的。经过 300,000 次的探索（右图）之后，智能体已经学会记住奖励地点并向其自动寻路。

### 展望

实际上，可微可塑性为 [学会学习](http://bair.berkeley.edu/blog/2017/07/18/learning-to-learn/) 或 [元学习](http://metalearning.ml) 这一经典问题提供了一种新的生物启发式方法。只需通过各种强大的方式利用梯度下降和基础构建块（可塑性连接），这种方法也能非常灵活，就像上述不同任务所证明的那样。

此外，它打开了多个新研究途径的大门。例如，我们是否可以通过连接可塑性来改进现有的复杂网络体系结构，如 LSTM？如果连接的可塑性受到网络本身的控制，那么它似乎类似于 [神经调质](https://www.ncbi.nlm.nih.gov/pubmed/12880632) 影响生物大脑？可塑性是否提供了一种比单独循环网络更有效的记忆形式（请注意，循环网络将传入的信息存储在神经活动中，而可塑性网络将其存储在数量更多的连接中）？

我们打算在未来的可微可塑性工作中研究这些以及其他令人兴奋的问题，并希望其他人加入我们的探索。为了鼓励对这种新方法的研究，我们 [在 GitHub](https://github.com/uber-common/differentiable-plasticity) 发布了上述实验的代码以及 [描述我们的方法和结果的论文](https://arxiv.org/abs/1804.02464)。

要想收到未来 Uber 人工智能实验室博客的文章，请注册为 [我们的邮件列表](https://goo.gl/forms/HvXgNYzSjbalVRQ93) 或者你也可以订阅 [Uber 人工智能实验室 YouTube 频道](https://www.youtube.com/channel/UCOb_oiEfSedawuvRA0oaVoQ)。如果您对加入 Uber AI 实验室感兴趣，请在 [Uber.ai](http://uber.ai) 上提交申请。

[订阅我们的资讯](http://uber.us11.list-manage1.com/subscribe?u=092a95bfe05dfa7c27877ca59&id=381801863c) 以跟上 Uber 工程的最新创新。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
