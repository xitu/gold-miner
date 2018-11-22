> * 原文地址：[A Guide For Time Series Prediction Using Recurrent Neural Networks (LSTMs)](https://blog.statsbot.co/time-series-prediction-using-recurrent-neural-networks-lstms-807fa6ca7f)
> * 原文作者：[Neelabh Pant](https://blog.statsbot.co/@neelabhpant?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-prediction-using-recurrent-neural-networks-lstms.md](https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-prediction-using-recurrent-neural-networks-lstms.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：[TrWestdoor](https://github.com/TrWestdoor) 

# 使用递归神经网络（LSTMs）对时序数据进行预测

## 使用长短时记忆网络（LSTMs）来预测未来货币汇率变化

![](https://cdn-images-1.medium.com/max/800/1*aFXm8OFmNq1sTItCQP-xUw.png)

[**Statsbot**](http://statsbot.co?utm_source=blog&utm_medium=article&utm_campaign=timeseries_lstm)  **团队已经发表了一篇关于**[ **使用时间序列分析进行异常检测** ](https://blog.statsbot.co/time-series-anomaly-detection-algorithms-1cef5519aef2)**的文章。今天，我们将讨论使用长短时记忆模型（LSTMs）进行时间序列的预测。我们请数据科学家 Neelabh Pant 向大家来讲述他使用循环神经网络预测汇率变化的经验。**

![](https://cdn-images-1.medium.com/max/2000/1*MvLugAVHIv0uPX0A1RyGTw.jpeg)

作为一个生活在美国的印度人，我和我的家人之间会有源源不断的资金流相互流转。如果美元在市场上走强，那么印度卢比（INR）就会下跌，因此，一个印度人将要用更多的卢比来购买一美元。如果美元走弱，你就会花更少的卢比去购买同样的一美元。

如果你能预测出明天的一美元是什么价格，那么它就能指导你的决策，这对于最小化风险和最大化回报是非常重要的。通过观察神经网络的优势，特别是循环神经网络，我想到了预测美元和印度卢比的汇率。

预测汇率的方法有很多，例如：

*   **购买力平价（PPP）**，它将通货膨胀考虑在内并计算通胀的差异。
*   **相对经济实力方法**，它考虑了各国经济增长，以此对汇率的走势进行预测。
*   **计量经济模式** 是另一种常用的汇率预测技术，可以根据预测者认为重要的因素或属性进行定制。这样的因素或属性可能是不同国家之间存在的利率差异、GDP 的增长率、收入增长率等特征。
*   **时间序列模型** 则是纯粹取决于过去的变化行为和价格模式来预测未来的汇率对应价格。

在本文中，我们将告诉你如何使用机器学习进行时间序列分析来预测未来的汇率变化。

### 序列问题

让我们从顺序问题开始。涉及序列的最简单的机器学习问题是一对一问题。

![](https://cdn-images-1.medium.com/max/800/0*7AIMLPm1e7hgGolz.)

一对一

在这种情况下，模型的输入数据或输入张量只有一个，同时模型根据给定的输入生成一个对应的预测。线性回归、分类和使用卷积网络进行的图像分类都属于这一范畴。将其进行拓展，可以允许模型使用输入和输出的旧值。

这就是一对多问题了。一对多问题开始时就和一对一问题一样，模型有一个输入，同时生成一个输出。然而，模型的输出现在作为新的输入反馈给模型。模型现在可以生成一个新的输出，我们可以这样无限地继续循环下去。现在你可以看到为什么这些被称为循环神经网络了。

![](https://cdn-images-1.medium.com/max/800/0*QFWZFOLMH4EyyZxu.)

一对多

使用递归神经网络处理序列问题，因为它们都可以连接形成一个有向的循环。换句话说，通过使用它们自己的输出作为下一个步骤的输入，它们可以保持从一个迭代到下一个迭代的状态。使用编程的术语来说，这就像是在运行一个固定的程序，其中带有特定输入和一些内部变量。如果我们在时间轴上将其**展开**，最简单的递归神经网络可以看作是一个完全连接的神经网络。

![](https://cdn-images-1.medium.com/max/800/0*x1vmPLhmSow0kzvK.)

在时间轴上展开的 RNN

![](https://cdn-images-1.medium.com/max/800/0*ni39BJU15z96HtxW.)

在这种单变量情况下，只涉及到两个权重。权重 **u** 乘以当前的输入 **xt**，而另一个权重 **w** 乘以前一次的输出 **yt-1**。这个公式类似于指数加权移动平均方法（EWMA），它将过去的输出值与当前的输入值结合起来。

可以通过简单堆叠神经网络单元来建立一个深层的循环神经网络。一个简单的循环神经网络只对短期记忆有效。如果我们有长期记忆的需求，就会发现它对此有根本上的不足。

### 长短时神经网络

正如我们已经讨论过的，一个简单的循环网络存在一个根本问题，即不能捕获序列中的长时依赖关系。我们构建的 RNNs 在分析文本和回答问题时，涉及到跟踪长序列的单词，所以这将会是一个问题。

在 90 年代后期，[LSTM 是由 Sepp Hochreiter 和 Jurgen Schmidhuber 提出的](http://www.mitpressjournals.org/doi/abs/10.1162/neco.1997.9.8.1735)，用来替代 RNNs、隐马尔科夫模型以及其它众多应用中的序列学习方法，相比于它们 LSTM 对时间间隔长度不敏感。

![](https://cdn-images-1.medium.com/max/800/0*_rC7UKSazzfOkpFZ.)

LSTM 网络结构

该模型是一个操作单元，其中包括几个基本操作。LSTM 有一个内部状态变量，它从一个单元传递到另外一个单元，并由 **操作门** 来修改。

1. **遗忘门**

![](https://cdn-images-1.medium.com/max/800/0*YK0duxOW-Jly8DZk.)

使用一个 sigmoid 层来接收前一个时间节点 **t-1** 的输出和当前时间节点 **t** 的输入，将其合并成为一个张量（tensor），然后在其后应用一个线性变换。经过 sigmoid 激活函数后，遗忘门的输出为 0 到 1 之间的数值。这个数值将会与内部状态相乘，这也就是为什么它会被称为遗忘门的原因。如果 **ft=0**，则完全忘记之前的内部状态，如果 **ft=1**，则会没有任何改变地通过。

2. **输入门**

![](https://cdn-images-1.medium.com/max/800/0*wO-TFX3T3t6l6BFJ.)

输入门接受先前的输出和新输入，并将其传递到另一个 sigmoid 层。输入门返回的也是 0 到 1 之间的值。然后输入门返回的值与候选层的输出相乘。

![](https://cdn-images-1.medium.com/max/800/0*Zq_yfpO7eG4WL6QY.)

这一层对输入和先前层的输出进行混合，然后应用双曲切线激活，返回一个候选向量添加到内部状态上。

内部状态更新规则如下：

![](https://cdn-images-1.medium.com/max/800/0*9yb45Vnf6g47dDv8.)

之前的状态乘以遗忘门输出，然后添加到输出门允许的新的候选项中。

3. **输出门**

![](https://cdn-images-1.medium.com/max/800/0*9Wb-rBVYurzKpzHp.)

![](https://cdn-images-1.medium.com/max/800/0*vdc6Tlu5KBPFN7c9.)

输出门控制着有多少内部状态被传递给输出，它的工作方式类似于其它的门结构。

上面描述的这三个门结构具有独立的权值和偏差，因此网络需要学习有多少过去的输出需要保留，有多少当前的输入需要保留，以及有多少的内部状态需要被传送到输出。

在递归神经网络中，需要输入的不仅仅是当前网络的输入数据，还有该网络的前一个时刻的状态数据。例如，如果我说“嘿！我在开车的时候发生了一件疯狂的事情”，然后你的大脑某个部分就开始转动开关，说“哦，这是 Neelabh 告诉我的一个故事，故事的主角是 Neelabh，路上发生了一些事情。”现在，你就会保留一部分我刚才告诉你的句子的信息。当你听我讲其它句子的时候，为了理解整个故事，你必须保留一些之前句子信息中的记忆。

另外一个例子是使用循环神经网络进行**视频处理**。在当前帧中发生的事情很大程度上取决于上一帧的内容。在一段时间内，一个循环神经网络应该学习到保留什么、从过去的数据中保留多少、以及对当前状态保留多少的策略，这使得它比简单的前馈神经网络更加强大。

### 时间序列预测

我对循环神经网络的优势印象是很深刻的，决定使用它来预测美元和印度卢比的汇率。本项目使用的数据集是 1980 年 1 月 2 日至 2017 年 8 月 10 日的汇率数据。稍后，我会提供一个链接来下载这个数据集并进行实验。

![](https://cdn-images-1.medium.com/max/800/0*f70CZA2vHe0R_rsq.)

表 1 数据集示例

数据集显示了 1 美元的卢比价值。从 1980 年 1 月 2 日到 2017 年 8 月 10 日，我们总共有 13730 项记录。

![](https://cdn-images-1.medium.com/max/800/0*UYHLdtUFPTM7YPs6.)

USD 对 INR

从整个阶段看，1 美元的卢比价格一直是在上涨的。我们可以看到，美国经济在 2007 到 2008 年间大幅下滑，这在很大程度上是由那段时期的大衰退造成的。2000 年代末至 2010 年代初，全球市场普遍经历了经济衰退。

这段时期对世界上的发达经济体来说并不是很好，特别是北美和欧洲（包括俄罗斯），它们已经陷入了严重的经济衰退。许多较新的发达经济体受到的影响要小得多，特别是中国和印度，这两个国家的经济在这段时期大幅增长。

### 训练-测试数据划分

现在，要训练模型，我们就需要将数据划分为测试集和训练集。处理时间序列时，以一个特定的日期将其划分为训练集和测试集是非常重要的。所以，我们不希望看到的是测试数据出现在训练数据之前。

在我们的实验中，我们将定义一个日期，比如 2010 年 1 月 1 日，作为我们分开的日期。训练数据是 1980 年 1 月 2 日至 2009 年 12 月 31 日之间的数据，大约有 11000 个训练数据点。

测试数据集在 2010 年 1 月 1 日到 2017 年 8 月 10 日之间，大约 2700 个数据点。

![](https://cdn-images-1.medium.com/max/800/0*jXH_D2Zd8TOmXa1H.)

测试-训练数据划分

接下来要做的是对数据集进行规范化。只需要调整和变换训练数据，然后变换测试数据即可。这样做的原因是，假定我们是不知道测试数据的规模的。

对数据进行规范化或变换是指应用一个新的介于 0 和 1 之间的缩放变量。

### 神经网络模型

**全连接模型**是一个简单的神经网络模型，它被构建为一个单输入单输出的回归模型。基本上是取前一天的价格来预测第二天的价格。

我们使用均方差作为损失函数，使用随机梯度下降作为优化器，在训练足够多的时期（epochs）后，将会找到一个较好的局部最优值。下面是全连接层的概要。

![](https://cdn-images-1.medium.com/max/800/0*u3xLjEmM4m-0Ucjr.)

全连接层概要

在将该模型训练到 200 个时期后或者无论出现哪个 _early_callbacks_（即满足条件的提前终止回调）之后，该模型通过训练学习到数据的模式和行为。由于我们将数据分为训练集和测试集，我们现在可以预测测试数据对应的数值了，并将其与真实值进行比较。

![](https://cdn-images-1.medium.com/max/600/0*6-fJhYPOGwCzGEs7.)

真实值（蓝色）对 预测值（橙色）

正如你所看到的，这个模型的表现并不好。它本质上就是重复前面的数据，只有一个轻微的变化。全连接模型不能从单个先前值来预测未来的数据。现在让我们来尝试使用一个循环神经网络，看看它做得如何。

### **长短时记忆**

我们使用的循环网络模型是一个单层的顺序模型。在我们输入维度形状为 (1,1) 的层中使用了 6 个 LSTM 节点，即该网络的输入只有一个。

![](https://cdn-images-1.medium.com/max/800/0*fDevZBB0iBwHtlIw.)

LSTM 模型概要

最后一层是密集层（即全连接层），损失函数采用的是均方差，优化器使用随机梯度下降算法。我们使用 _early_stopping_ 回调对这个模型进行了200次的训练。模型的概要如上图所示。

![](https://cdn-images-1.medium.com/max/600/1*ysQ--yj7je3GReiiX5knBg.png)

LSTM 预测

这个模型已经学到了重现数据在年度内的整体形状，而且不像前面使用简单的前馈神经网络那样有延迟。但是它仍然低估了一些观察值，所以该模型肯定还有改进的空间。

### 模型修改

该模型可以做很多的改变来使它变得更好。一般可以直接通过修改优化器来更改模型训练配置。另外一个重要的修改是使用了[滑动时间窗口](https://en.wikipedia.org/wiki/Data_stream_management_system#Windows)的方法，它是来自于流数据管理系统领域的方法。

这种方法来自于这样一种观点，即只有最近的数据才是重要的。你可以使用一年的模型数据，并试着对下一年的第一天做出预测。滑动时间窗口方法在获取数据集中的重要模式方面非常有用，这些模式高度依赖于过去的大量观察。

你可以尝试根据个人喜好对该模型进行修改，并查看模型对这些修改的反应。

### 数据集

我在 github 账户的仓库中 [deep learning in python](https://github.com/neelabhpant/Deep-Learning-in-Python) 提供了该数据集。请随意下载并使用它。

### 有用的资源

我个人关注了一些喜欢的数据科学家，比如 [Kirill Eremenko](https://www.superdatascience.com)， [Jose Portilla](https://www.udemy.com/user/joseporitlla/)， [Dan Van Boxel](https://www.youtube.com/user/dvbuntu) （即著名的 Dan Does Data），等等。他们中的大多数人都可以在不同的博客站点上找到，他们的博客中有很多不同的主题，比如 RNN，卷积神经网络， LSTM，甚至最新的[神经图灵机](https://en.wikipedia.org/wiki/Neural_Turing_machine)技术。

保持更新各种[人工智能会议](http://www.aaai.org)的新闻。顺便说一下，如果你感兴趣的话， Kirill Eremenko 将会[在今年的 11 月份](https://www.datasciencego.com/?utm_source=Email&utm_medium=AllLess_ID1&utm_content=EM2_EarlyBirds_ImageLogo&utm_campaign=event)来到圣地亚哥和他的团队一起做关于机器学习、神经网络和数据科学的演讲。

### 结论

LSTM 模型足够强大，可以学习到最重要的过去行为，并理解这些过去的行为是否是进行未来预测的重要特征。在许多应用程序中，LSTM 的使用率都很高。一些应用比如如语音识别、音乐合成、手写识别，甚至是在我目前的人口流动和旅游预测等的研究中。

在我看来，LSTM 就像是一个拥有自己记忆的模型，在做决定时可以表现得像一个聪明的人。

再次感谢，并祝在机器学习的学习过程中得到快乐！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
