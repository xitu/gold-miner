
> * 原文地址：[Deep Learning 4: Why You Need to Start Using Embedding Layers](https://medium.com/towards-data-science/deep-learning-4-embedding-layers-f9a02d55ac12)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-4-embedding-layers.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-4-embedding-layers.md)
> * 译者：[Tobias Lee](http://tobiaslee.top)
> * 校对者：[LJ147](https://github.com/LJ147)、[changkun](https://github.com/changkun)

# 深度学习系列4:  为什么你需要使用嵌入层

## 除了词嵌入以外还有很多

![](https://cdn-images-1.medium.com/max/2000/1*sXNXYfAqfLUeiDXPCo130w.png)

**这是深度学习系列的其中一篇，其他文章地址如下**

1. [设置 AWS & 图像识别](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md)
2. [卷积神经网络](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md)
3. [CNNs 以及应对过拟合的详细探讨](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md)

---

欢迎阅读深度学习系列的第四部分，你可能注意到这一篇和前面三篇文章之间隔了一小段时间。我写这个系列最初的目的是想记录 fast.ai 上的深度学习课程，然而后面一部分课程的内容有所重叠，所以我决定先把课程完成，这样我能够更为细致地从整体上来把握这些主题。在这篇文章里我想介绍一个在很多节课中都有涉及，并且在实践中被证明非常有用的一个概念：嵌入层（Embedding layer）。

介绍嵌入层这个概念可能会让它变得更加难以理解。比如说，Keras 文档里是这么写的：“把正整数（索引）转换为固定大小的稠密向量”。你 Google 搜索也无济于事，因为文档通常会排在搜索结果的第一个（你还是不能获得更加详细的解释）。然而，从某种意义上来说，Keras 文档的描述是正确的。那么为什么你应该使用嵌入层呢？这里有两个主要原因：

1. 独热编码（One-hot encoding）向量是高维且稀疏的。假如说我们在做自然语言处理（NLP）的工作，并且有一个包含 2000 个单词的字典。这意味着当我们使用独热编码时，每个单词由一个含有 2000 个整数的向量来表示，并且其中的 1999 个整数都是 0。在大数据集下这种方法的计算效率是很低的。
2. 每个嵌入向量会在训练神经网络时更新。文章的最上方有几张图片，它们展示了在多维空间之中，词语之间的相似程度，这使得我们能够可视化词语之间的关系。同样，对于任何能够通过使用嵌入层而把它变成向量的东西，我们都能够这么做。

嵌入层这个概念可能还是有点模糊，让我们再来看嵌入层作用在词语上的一个例子。嵌入这个概念源自于词嵌入（Word embedding），如果你想了解更多的话可以看看 [word2vec](https://arxiv.org/pdf/1301.3781.pdf) 这篇论文。让我们用下面这个句子作为例子（随便举的一个例子，不用太认真对待）：

> “deep learning is very deep”

使用嵌入层的第一步是通过索引对这个句子进行编码，在这个例子里，我们给句中每个不同的词一个数字索引，编码后的句子如下所示：

> 1 2 3 4 1

下一步是创建嵌入矩阵。我们要决定每个索引有多少“潜在因素”，这就是说，我们需要决定词向量的长度。一般我们会使用像 32 或者 50 这样的长度。出于可读性的考虑，在这篇文章里我们每个索引的“潜在因素”个数有 6 个。那么嵌入矩阵就如下图所示：

![](https://cdn-images-1.medium.com/max/1600/1*Di85w_0UTc6C3ilk5_LEgg.png)

嵌入矩阵

所以，和独热编码中每个词向量的长度相比，使用嵌入矩阵能够让每个词向量的长度大幅缩短。简而言之，我们用一个向量 [.32, .02, .48, .21, .56, .15]来代替了词语“deep”。然而并不是每个词被一个向量所代替，而是由其索引在嵌入矩阵中对应的向量代替。再次强调，在大数据集中，这种方法的计算效率是很高的。同时因为在训练深度神经网络过程中，词向量能够不断地被更新，所以我们同样能够在多维空间中探索各个词语之间的相似程度。通过使用像 [t-SNE ](https://lvdmaaten.github.io/tsne/) 这样的降维技术，我们能够把这些相似程度可视化出来。

![](https://cdn-images-1.medium.com/max/1600/1*m8Ahpl-lpVgm16CC-INGuw.png)

通过 t-SNE 可视化的词嵌入（向量）

---

### 不仅仅是词嵌入

前面的例子体现了词嵌入在自然语言处理领域重要的地位，它能够帮助我们找到很难察觉的词语之间的关系。然而，嵌入层不仅仅可以用在词语上。在我现在的一个研究项目里，我用嵌入层来嵌入网上用户的使用行为：我为用户行为分配索引，比如“浏览类型 X 的网页（在门户 Y 上）”或“滚动了 X 像素”。然后，用这些索引构建用户的行为序列。

深度学习模型（深度神经网络和循环神经网络）和“传统”的机器学习模型（支持向量机，随机森林，梯度提升决策树）相比，我觉得嵌入方法更适用于深度神经网络。

“传统”的机器学习模型，非常依赖经过特征工程的表格式的输入，这意味着需要我们研究者来决定什么是一个特征。在我的那个项目里，作为特征的有：浏览的主页数量、搜索的次数、总共滚动的像素。然而，在特征工程时，我们很难把时间维度方面的特征考虑进去。利用深度学习和嵌入层，我们就能够把用户行为序列（通过索引）作为模型的输入，从而有效地捕捉到时间维度上的特征。

在我的研究中，使用 GRU（Gated Recurrent Unit）或者是 LSTM（Long-Short Term Memory）技术的循环神经网络表现地最好，它们的结果很接近。在“传统” 的需要特征工程的模型中，梯度提升决策树表现地最好。关于我的研究项目，我以后会写一篇文章，我的下一篇文章会更细致地讨论关于循环神经网络的问题。

其他还有使用嵌入层来编码学生在慕课上行为的例子（Piech et al., 2016），以及用户浏览在线时尚商店的点击顺序（Tamhane et al., 2017）。

---

#### 推荐系统

嵌入层甚至可以用来处理推荐系统中的稀疏矩阵问题。在 fast.ai 的深度学习课程中利用推荐系统来介绍了嵌入层，这里我也想谈谈推荐系统。

推荐系统已经广泛地应用在各个领域了，你可能每天都被它们所影响着。亚马逊的产品推荐和 Netflix  的节目推荐系统，是两个最常见的例子。Netflix 举办了一个奖金为一百万美元的比赛，用来寻找最适合他们推荐系统的协同过滤算法。你可以在[这里](http://abeautifulwww.com/wp-content/uploads/2007/04/netflixAllMovies-blackBack3[5].jpg)看到其中一个模型的可视化结果。

推荐系统主要有两种类型，区分它们是很重要的。

1. 基于内容过滤：这种过滤是基于物品或者是产品的数据的。比如说，我们让用户填一份他们喜欢的电影的表格。如果他们说喜欢科幻电影，那么我们就给他推荐科幻电影。这种方法需要大量的对应产品的元数据。
2. 协同过滤：找到和你相似的人，假设你们的爱好相同，看看他们喜欢什么。和你相似的人，意味着他们对你看过的电影有着相似的评价。在大数据集中，这个方法和元数据方法相比，效果更好。另外一点很重要的是，询问用户他们的行为和观察他们实际的行为之间是有出入的，这其中更深沉次的原因需要心理学家来解释。

为了解决这个问题，我们可以创建一个巨大的所有用户对所有电影的评价矩阵。然而，在很多情况下，这个矩阵是非常稀疏的。想想你的 Netflix 账号，你看过的电影占他们全部电影的百分之多少？这可能是一个非常小的比例。创建矩阵之后，我们可以通过梯度下降算法训练我们的神经网络，来预测每个用户会给每部电影打多少分。如果你想知道更多关于在推荐系统中使用深度学习的话，请告诉我，我们可以一起来探讨更细节的问题。总而言之，嵌入层的作用是令人惊讶的，不可小觑。

如果你喜欢这篇文章，请把它推荐给你的朋友们，让更多人的看到它。你也可以按照这篇文章，跟上我在 Fast AI 课程中的进度。到时候那里见！

#### 参考文献

Piech, C., Bassen, J., Huang, J., Ganguli, S., Sahami, M., Guibas, L. J., & Sohl-Dickstein, J. (2015). *Deep knowledge tracing. In Advances in Neural Information Processing Systems* (pp. 505–513).

Tamhane, A., Arora, S., & Warrier, D. (2017, May). *Modeling Contextual Changes in User Behaviour in Fashion e-Commerce*. In Pacific-Asia Conference on Knowledge Discovery and Data Mining (pp. 539–550). Springer, Cham.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
