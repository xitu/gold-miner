> * 原文地址：[How to build a recommendation system in a graph database using a latent factor model](https://towardsdatascience.com/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model-fa2d142f874)
> * 原文作者：[Changran Liu](https://medium.com/@liuchangran6106)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model.md)
> * 译者：[司徒公子](https://github.com/todaycoder001)
> * 校对者：

# 如何利用潜在因素模型在图形数据库中建立推荐系统

## 什么是推荐系统？

推荐系统是基于现有数据来预测个人优先选择的任意评级系统。推荐系统被用于各种服务，比如：视频数据流、在线购物以及社交媒体。通常情况下，系统会根据用户对某件商品的评价进行预测，从而向用户提供推荐。推荐系统可以分为两个方面，即利用信息和预测模型。

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*nphS5bpdyX4gq3oS-20201211134141389.png)
![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/20200929200915.png)
<div style="font-size:12px">图 1（图片由作者提供）。这个示例数据集包括两个用户：爱丽丝和鲍勃，两部电影：**玩具总动员**和**钢铁侠**，还有三个评级记录（实线部分）。每个用户和电影都被标记为它们的属性。</div>

#### 内容过滤 vs 协同过滤

内容过滤和协同过滤是最主要的两种推荐方法，主要根据测评所需的信息有所不同。图一显示了一组电影评分数据和一些针对用户和电影的标签。注意，从用户到图结构中电影的评级：用户和电影是图的顶点，评分    是图的边。在本例中，内容过滤方法利用电影和用户的标签属性。通过查询标签，我们得知爱丽丝是漫威电影的超级粉丝，而《钢铁侠》是一部漫威电影，因此《钢铁侠》系列对她来说是一个很好的推荐。内容过滤评分系统的一个具体例子是 TF-IDF，它用于对文档搜索进行排序。

用户和电影的标签可能并不总是可用的。当标签数据比较稀疏的时候，内容过滤的方法可能就不可靠了。另一方面，协同过滤的方法主要依赖用户行为数据（如评分记录或电影观看历史）。在上面的例子中，爱丽丝和鲍勃都很喜欢**玩具总动员**这部电影，他们分别给电影打了 5 分和 4.5 分。根据这些评分记录，可以判断这两个用户可能有相似的偏好。现在考虑到鲍勃喜欢**钢铁侠**，我们预测爱丽丝也会有类似的行为，并向爱丽丝推荐**钢铁侠**  。K-近邻算法（[KNN](https://docs.tigergraph.com/v/2.6/dev/gsql-examples/common-applications#example-1-collaborative-filtering)）是一种典型的协同过滤方法。然而，协同过滤有所谓的冷启动问题 —— 无法为没有评分记录的用户提供推荐。

**基于记忆 vs 基于模型**

根据使用特征的隐含性，推荐系统也可以分为基于记忆和基于模型的方法。在上述例子中，所有用户和电影的特征都被明确的给出，这使得我们基于电影和用户的标签直接匹配。但有时需要深度学习模型从用户和电影信息中提取潜特征（例如，根据电影的大纲对其分类的 NLP 模型）。基于模型的推荐系统利用机器学习模型来进行预测，而基于记忆的推荐系统主要利用显式特征。

下面是不同类型推荐系统的一些典型用例。

![(Image by Author)](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/1*_nrZdonnDXVTtOltRCaebg.png)

## 图因式分解在推荐系统中是如何工作的

如上所述，协同过滤方法，例如 KNN，可以在不知道用户属性和电影属性的情况下预测电影评分。然而，当评分数据稀疏的时候，即典型用户只评分了几部电影时，这种方法可能不会产生准确预测。在图 1 中，如果鲍勃没有对《玩具总动员》评分，KNN 就无法预测爱丽丝对《钢铁侠》的评分，因为爱丽丝和鲍勃之间没有联系，爱丽丝本身也没有邻居。

图 2 说明了图因式分解方法的直观性。图因式分解也被称为潜在因子或者矩阵因式分解方法。目标是获取每一个用户和电影的矢量，该矢量代表它们的潜在特征。在这个例子中（图 2），矢量的维数被指定为 2。电影向量 movie **x(i)** 的两个元素代表该电影的浪漫程度和动作内容，用户趋向 **θ(j)** 向量的两个元素分别表示用户对浪漫和动作内容的偏爱程度。用户 **j** 对电影 **i** 的评分预测是 **x(i)** 和 **θ(j)** 的点积，正如我们说期待的那样，这两个向量更好的对齐，代表着用户更喜欢这部电影。

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*T2BPqSnRLLUpGHMa.png)
<div style="font-size:12px">图 2，表格展示了 4 位用户对 6 部电影的评分记录，评分在 0 ～ 5 之间，缺少评分的部分用问号表示。θ(j) 和 x(i) 表示潜在向量因子，爱丽丝的评分预测是根据潜在因素计算的，其真实值在旁边以橙色文字显示。</div>

图 2 中的例子仅仅是说明了图因式分解方法的直观性。在实践中，每个向量元素的含义通常是未知的。这些向量实际上是随机初始化的，并通过最小化以下的的损失函数来“训练”[1]。

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*Mhilgi_E_Xo1XymH.png)

其中 **M** 表示评分记录的数量，**n** 表示潜在因子向量，**y**(i, j) 是用户 **j** 对电影 **i** 的评分，𝝀 是正则因子。第一项实质上是预测平方误差（ θ(j)_k 和 x(i)_k 的和），第二项是正则化以避免过拟合。损失函数的第一项也可以用矩阵的形式表达，

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/1*_A0x9iQr48JjpMuT9SCqtw.png)

其中，**R** 是以 **y(i, j)** 为元素的评分矩阵，**U** 和 **V** 分别是用户和电影的潜在因子向量形成的矩阵。最小化预测的平方差等价于最小化 **R-UV^T** 的 Frobenius 范式。因此，这种方法也叫矩阵分解方法。

你可能想知道为什么我们称这种方法为图因式分解法。正如之前讨论的那样，评级矩阵 **R** 就很有可能是一个稀疏矩阵，因为并非所有的用户都会对所有的电影进行评分。基于存储效率考虑，这些稀疏矩阵通常以图的形式储存，其中每个顶点代表一位用户或者一部电影，每条边表示一条评分记录，边的权重表示评分的高低。如下图所示，通过优化损失函数进而获取潜在因子的梯度下降算法也可以表示为图算法。

可以将 **θ(j)\_k** 和 **x(i)\_k** 的偏导表示如下：

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*TvDNRImZS2IxFHGe.png)

上面的方程式表明，一个潜在向量在一个顶点上的偏导数只依赖于它的边和邻域。对于我们的例子，用户向量的偏导数仅由评分和用户之前评分电影的评分的潜在向量决定。这个属性使得我们可以将评分数据存储于图中（如图 5 所示），并且使用图算法来获取电影和用户之间的潜在因素。用户和电影特征可以通过如下步骤获取。

![(Image by Author)](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/1*cKGDWSOgTxd9gJCp6nVOBQ.png)

值得一提的是计算导数以及更新潜在因子可以在 Map-Reduce 框架下完成，第二步可以对每条边 **edge\_(i, j)** （即评分）并行执行，步骤三也可以对每个顶点 **verte\_i** （即用户或者电影）并行执行。

## 为什么推荐需要使用图数据库

对于工业应用，数据库可以容纳上亿用户和电影以及数十亿的评价记录，这意味着评级矩阵 A，特性矩阵 U 和 V 加上其他中间变量在模型训练的时候会消耗以 TB 为单位的内存。这些问题可以通过在图数据库中训练潜在特性来解决，这些评分图可以分布在一个多节点集群中，其中部分存储在磁盘上。此外，图结构的用户（即用户评分）首选存储于数据库管理系统中，数据库内模型训练避免了将图数据从数据库管理系统迁移到机器学习平台，从而更好的支持不断演化训练数据的模型更新。

#### 如何在 TigerGraph 中构建一个推荐系统

这部分，我们在 TigerGraph 云提供的一个免费图数据库，加载一个电影评分的图，然后在数据库中训练推荐模型。按照下面的步骤，你就能在 15 分钟拥有一个电影推荐系统。

接着[创建你的第一个 TigerGraph 实例](https://www.tigergraph.com/2020/01/20/taking-your-first-steps-in-learning-tigergraph-cloud/)（前三步），在 **TigerGraph 云上创建一个免费的实例**。步骤一中，选择**数据库中机器学习推荐**作为入门工具包。步骤三中选择免费版 TrigerGraph。

随着[开始使用 TigerGraph 云入门版](https://www.tigergraph.com/2020/01/20/taking-your-first-steps-in-learning-tigergraph-cloud/)，**登录到 GraphStudio**，在**映射数据到 Graph** 页面，你将明白数据文件是如何映射到 graph 上的，在入门级工具包中，[MovieLens-100K](https://grouplens.org/datasets/movielens/) 文件已经上传至实例中。[MovieLens-100K](https://grouplens.org/datasets/movielens/) 数据集有两个文件：

* movieList 逗号分隔符文件有两列，分别是每部电影的 id 和名字 。
* rating 逗号分隔符文件是用户对电影的评分列表。总共有三列，分别代表用户 id，电影 id 和评分。

![Figure 3 (Image by Author). **Map Data To Graph** page](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*CFbnvuOr4sP66zYM.png)

**进入 Load Data 页面，然后点击 Start/Resume 加载**。在加载完毕之后，你能看到右边的静态图。MovieLens-100K 数据集包含来自 944 位用户对 1682 部电影的 100011 条评分记录。

![Figure.4 (Image by Author). **Load Data** page.](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*T2DVnK3W7AJxIqR5.png)

加载完成后，你能看到右边的静态图。在**浏览图表**页面，你能看到我们刚刚创建了一个二部图，每个用户和电影的信息都存储在顶点中，评分记录存储在边上。

![Figure.5 (Image by Author). **Explore Graph** page.](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*NKkeM3kRFAWDXNm1.png)

在**写 GSQL 查询**页面，你将会发现推荐系统所需要的查询已经添加到数据库中。这些查询语句是使用 TigerGraph 查询语言 GSQL 编写的。**点击安装所有查询**将所有的 GSQL 语句编译成 C++ 代码。

![Figure.6 (Image by Author). **Write Queries** page](https://blog-private.oss-cn-shanghai.aliyuncs.com/images/0*r_8aCoSYb4VwJAfR.png)

**运行分割数据查询**

该查询将评分数据分为验证集和测试集。测试数据的比例默认为 30%（30% 的评分数据将被用于验证模型，剩下的 70% 将被用于训练模型）。该查询还会输出总数据集、验证数据集和训练数据集的大小。

**运行标准化查询**

该查询将评分与电影的平均得分做差来规范化查询，每部电影的平均分通过训练集计算得出。

**运行初始化查询**

该查询初始化用户和电影的潜在向量因子。潜在向量因子中的元素通过正态分布的随机数发生器初始化。查询的输入是正态分布的标准差和平均值。

**运行训练查询**

该查询使用梯度下降算法训练推荐模型。默认情况下特征数设置为 19。这个数量必须与初始化查询中潜在因子数量一致。查询的输入为学习率、正则化因子以及训练迭代的次数。查询输出为每次迭代的均方根误差（RMSE）。

在潜在因子计算出来后，我们就可以测试并使用该模型进行推荐了。

**运行测试查询**

查询输出用户提供的真实评分数据以及模型的预测评分。该查询输入用户 id，输出用户的所有评分以及预测评分。

**运行推荐查询**

该查询输出用户推荐的评分 TOP10 的电影，基于评分预测推荐影片。

## 总结

Training machine learning model in a graph database has the potential to achieve real-time updates of the recommendation model. In this article, we introduce the mechanism of the graph factorization method and show a step-by-step example of building your own movie recommendation system using TigerGraph cloud service. Once you are familiar of this example, you should be confident with customizing this recommendation system based on your use cases.
图数据库中的机器学习训练模型有可能实现推荐模型的实时更新。这篇文章，我们介绍了图因式分解方法的原理，展示了如何使用 TigerGraph 云服务一步一步的构建你的电影推荐系统。一旦熟悉了这个事例，你应该有信心根据你的用例定制这个推荐系统了。

## 参考文献

[1] Ahmed, Amr. et al. “分布式大规模自然图分解”，**第 22 届万维网国际会议会议记录**（2013）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
