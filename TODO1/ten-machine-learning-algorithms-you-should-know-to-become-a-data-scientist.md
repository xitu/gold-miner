> * 原文地址：[Ten Machine Learning Algorithms You Should Know to Become a Data Scientist](https://towardsdatascience.com/ten-machine-learning-algorithms-you-should-know-to-become-a-data-scientist-8dc93d8ca52e)
> * 原文作者：[Shashank Gupta](https://towardsdatascience.com/@shashankgupta_54342)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ten-machine-learning-algorithms-you-should-know-to-become-a-data-scientist.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ten-machine-learning-algorithms-you-should-know-to-become-a-data-scientist.md)
> * 译者：[JohnJiang](https://github.com/JohnJiangLA)
> * 校对者：[Daltan He](https://github.com/Daltan), [Kasheem Lew](https://github.com/kasheemlew)

# 数据科学领域十大必知机器学习算法

![](https://cdn-images-1.medium.com/max/1600/1*kfTtbiN7TEppfvIDYeMnhw.jpeg)

机器学习从业者们各有各自不同的信仰。有些信奉“一剑破万法”（这里“剑”就是一种算法，而万法则是各种类型的数据），有些则认为“合适的工具做对的事”。他们中许多人也赞同“样样了解，精通一门”，他们在一个领域拥有丰富的专业知识，对机器学习的不同领域也略知一二。尽管如此，不可否认的是作为一名数据科学家，必须要对常见的机器学习算法了解一二，这将帮助我们在解决新问题时提供思路。本教程带你速览常见机器学习算法和相关资源，以便快速上手。

### 1. 主成分分析 (PCA)/SVD

PCA 是一种无监督方法，用于了解由向量构成数据集的全局属性。这里对数据点的协方差矩阵进行分析，以了解哪些维度（较多情况下）或数据点（部分情况下）更重要。比如，它们之间的方差较高，但与其他维度的协方差较低。考虑那些具有最高特征值的特征向量，它们就有可能是上层主成分（PC）。SVD 本质上也是一种计算有序成分的方法，但是不需要得到数据点的协方差即可获得。

![](https://cdn-images-1.medium.com/max/1600/1*HjYtbYvrP5ko0HC7YBX4cA.png)

这类算法通过将数据降维来解决高维数据分析难题。

### 工具库：

[https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.svd.html](https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.svd.html)

[http://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html](http://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html)

### 入门教程：

[https://arxiv.org/pdf/1404.1100.pdf](https://arxiv.org/pdf/1404.1100.pdf)

### 2a. 最小二乘法与多项式拟合

还记的你在大学时通常用于将直线或曲线拟合到点上以求得方程式的数值分析方法吗？可以在较小的低维数据集上使用它们来拟合机器学习中的曲线。（对于大型数据或者多个维度的数据集，最终结果可能会出现严重的过拟合。因此不必多费苦心了。）最小二乘法（OLS）有闭合解，所以不需要使用复杂的优化技术。

![](https://cdn-images-1.medium.com/max/1600/1*x7hjx5Lk_SvrteIYqAnx5g.jpeg)

显而易见，这个算法只能用于拟合简单的曲线或回归。

### 工具库：

[https://docs.scipy.org/doc/numpy/reference/generated/numpy.linalg.lstsq.html](https://docs.scipy.org/doc/numpy/reference/generated/numpy.linalg.lstsq.html)[https://docs.scipy.org/doc/numpy-1.10.0/reference/generated/numpy.polyfit.html](https://docs.scipy.org/doc/numpy-1.10.0/reference/generated/numpy.polyfit.html)

### 入门教程：

[https://lagunita.stanford.edu/c4x/HumanitiesScience/StatLearning/asset/linear_regression.pdf](https://lagunita.stanford.edu/c4x/HumanitiesScience/StatLearning/asset/linear_regression.pdf)

### 2b. 约束线性回归

最小二乘法在处理数据中的离群值、伪场和噪声会产生混淆。因此，在拟合一个数据集是需要约束来减少数据行中的方差。正确的方法是使用线性回归模型对数据集进行拟合，这样才能保证权重值不会出错。模型可以是 L1 规范（LASSO）或 L2（岭回归）或两者兼备（elastic regression）。均方损失最优化。

![](https://cdn-images-1.medium.com/max/1600/1*pVbeQKc9qvtYRAIO4F9pdA.jpeg)

这类算法拟合回归线时有约束，可以避免过拟合，并降低模型中噪声维度。

### 工具库：

[http://scikit-learn.org/stable/modules/linear_model.html](http://scikit-learn.org/stable/modules/linear_model.html)

###  入门教程：

[https://www.youtube.com/watch?v=5asL5Eq2x0A](https://www.youtube.com/watch?v=5asL5Eq2x0A)

[https://www.youtube.com/watch?v=jbwSCwoT51M](https://www.youtube.com/watch?v=jbwSCwoT51M)

### 3. K-means 聚类

这是大家最喜欢的无监督聚类算法。给定一组向量形式的数据点，可以通过它们之间的距离将其分为不同的群类。这是一种最大期望（EM）算法，它不停的移动群类的中心点，再根据群类中心对数据点进行聚类。这个算法的输入是需要生成的群类个数和聚类过程的迭代次数。

![](https://cdn-images-1.medium.com/freeze/max/60/1*ZPx88gYG1DsTwGmjBOc5Aw.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*ZPx88gYG1DsTwGmjBOc5Aw.png)

顾名思义，可以使用此算法使数据集分为 K 个集群。

### 工具库：

[http://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html](http://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html)

### 入门教程：

[https://www.youtube.com/watch?v=hDmNF9JG3lo](https://www.youtube.com/watch?v=hDmNF9JG3lo)

[https://www.datascience.com/blog/k-means-clustering](https://www.datascience.com/blog/k-means-clustering)

### 4. 逻辑回归

逻辑回归是一种约束线性回归，加权具有非线性应用（常用 sigmod 函数，你也可使用 tanh），因此输出被严格限定为 +/- 类（在 sigmod 中即为 1 和 0）。使用梯度下降对交叉熵损失函数进行优化。请初学者注意：逻辑回归用于分类，而不是回归。你也可以将逻辑回归想成单层神经网络。逻辑回归会采用梯度下降或 L-BFGS 等方法进行训练。NLP 中它通常被称作最大熵分类器。

Sigmod 函数图像如下：

![](https://cdn-images-1.medium.com/max/1600/1*Sb5O5yzsZmfVgiePgGln1Q.jpeg)

可以使用LR来训练简单但非常健壮的分类器。

### 工具库：

[http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html](http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)

### 入门教程：

[https://www.youtube.com/watch?v=-la3q9d7AKQ](https://www.youtube.com/watch?v=-la3q9d7AKQ)

### 5. SVM（支持向量机）

支持向量机是类似线性回归和逻辑回归的线性模型，它们之间的不同在于使用了不同的边际损失函数（支持向量的推导是我见过使用特征值计算的最优美的数学结果之一）。你可以使用 L-BFGS 甚至 SGD 这样的优化方法来优化损失函数。

![](https://cdn-images-1.medium.com/max/1600/1*_qnx-GnWBNYlpeEy9Z7aWQ.jpeg)

SVM 的另一创新之处在于数据到特征工程中的核心使用。如果你有很好的数据透视能力，你可以用更智能的核心替换原来还算不错的 RBF 并从中受益。

SVM 的一个独特之处是可以学习一个分类器。

支持向量机可以用来训练分类器（甚至是回归器）。

### 工具库：

[http://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html](http://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html)

### 入门教程：

[https://www.youtube.com/watch?v=eHsErlPJWUU](https://www.youtube.com/watch?v=eHsErlPJWUU)

**注意**：基于 SGD 的逻辑回归和 SVM 训练都是来源于 SKLearn 的 [http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.SGDClassifier.html](http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.SGDClassifier.html)，我常用这个，因为可以用公用接口同时检测逻辑回归和 SVM。你也可以使用小型批次利用 RAM 大小的数据集进行训练。

### 6. 前馈神经网络

这些本质上来说就是多层逻辑回归分类器。通过非线性函数（sigmod、tanh、relu + softmax 以及超酷的新玩意 selu）将各层的权重分割开。它也被成为多层感知机。前馈神经网络可以作为自编码器在分类器或者非监督特征学习中使用。

![](https://cdn-images-1.medium.com/max/1600/1*Njzm1u6cgWMzJwvgBK1ABg.jpeg)

**多层感知机**

![](https://cdn-images-1.medium.com/max/1600/1*32eXUEJTlPbfUWPPBxa5CQ.jpeg)

**作为自编码器的前馈神经网络**

前馈神经网络可以用来训练分类器或者作为自编码器提取特征。

### 工具库：

[http://scikit-learn.org/stable/modules/generated/sklearn.neural\_network.MLPClassifier.html#sklearn.neural\_network.MLPClassifier](http://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPClassifier.html#sklearn.neural_network.MLPClassifier)

[http://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPRegressor.html](http://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPRegressor.html)

[https://github.com/keras-team/keras/blob/master/examples/reuters\_mlp\_relu\_vs\_selu.py](https://github.com/keras-team/keras/blob/master/examples/reuters_mlp_relu_vs_selu.py)

### 入门教程：

[http://www.deeplearningbook.org/contents/mlp.html](http://www.deeplearningbook.org/contents/mlp.html)

[http://www.deeplearningbook.org/contents/autoencoders.html](http://www.deeplearningbook.org/contents/autoencoders.html)

[http://www.deeplearningbook.org/contents/representation.html](http://www.deeplearningbook.org/contents/representation.html)

### 7. 卷积神经网络（卷积网）

目前世界上几乎所有最先进的基于视觉的机器学习成果都是通过卷积神经网络实现的。它们可以用于图像分类、目标检测甚至图像分割。卷积网是由 Yann Lecun 在 80 年代末 90 年代初发明的，它以卷积层为主要特征，这些卷积层起到分层特征提取的作用。可以在文本（甚至图表）中使用它们。

![](https://cdn-images-1.medium.com/max/1600/1*Qwlwaeaw8ZoMJlioAw4zGw.png)

使用卷积网进行最新的图像和文本分类，目标检测，图像分割。

### 工具库：

[https://developer.nvidia.com/digits](https://developer.nvidia.com/digits)

[https://github.com/kuangliu/torchcv](https://github.com/kuangliu/torchcv)

[https://github.com/chainer/chainercv](https://github.com/chainer/chainercv)

[https://keras.io/applications/](https://keras.io/applications/)

### 入门教程：

[http://cs231n.github.io/](http://cs231n.github.io/)

[https://adeshpande3.github.io/A-Beginner%27s-Guide-To-Understanding-Convolutional-Neural-Networks/](https://adeshpande3.github.io/A-Beginner%27s-Guide-To-Understanding-Convolutional-Neural-Networks/)

### 8. 循环神经网络 (RNN)

RNN 通过将同一权重集递归应用到 t 时的聚合器状态和 t 时的输入，来对序列数据进行建模。（给定一个在时间点 0..t..T 处输入的序列，并在各个 t 处有一个由 RNN 中 t-1 步输出的隐藏状态）。纯粹的 RNN 现在很少使用，但它的相似架构，比如 LSTM 和 GRAS，在大多数序列型建模任务中都是最先进的。

![](https://cdn-images-1.medium.com/max/1600/1*QFge9bi7_guc4HLzmdKJag.jpeg)

RNN（如果这是一个密集联接单元并具有非线性，那么现在 f 通常是 LSTM 或 GRU）。LSTM 单元通常用来代替 RNN 结构中的普通密集层。

![](https://cdn-images-1.medium.com/max/1600/1*L6a7zn51aI8H3xRD1iKSDA.jpeg)

使用 RNN 进行任何序列型建模任务，特别是文本分类、机器翻译、语言建模。

### 工具库：

[https://github.com/tensorflow/models](https://github.com/tensorflow/models) (Many cool NLP research papers from Google are here)

[https://github.com/wabyking/TextClassificationBenchmark](https://github.com/wabyking/TextClassificationBenchmark)

[http://opennmt.net/](http://opennmt.net/)

### 入门教程：

[http://cs224d.stanford.edu/](http://cs224d.stanford.edu/)

[http://www.wildml.com/category/neural-networks/recurrent-neural-networks/](http://www.wildml.com/category/neural-networks/recurrent-neural-networks/)

[http://colah.github.io/posts/2015-08-Understanding-LSTMs/](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)

### 9. 条件随机场（CRF）

CRF 可能是概率图模型（PGM）家族中最常用的模型。它们可以像 RNN 一样用于序列型建模，也可以与 RNN 结合使用。在神经网络机器翻译系统出现之前，CRF 是最先进的，在许多小数据集的顺序型标记任务中，它们仍比需要大量数据才能归纳推理的 RNN 学习得更好。它们还可以用于其他结构化的预测任务中，比如图像分割等。CRF 对序列中的每个元素（比如句子）进行建模，以便相邻元素影响序列中某个组件的标签，而不是所有标签彼此独立。

使用 CRF 标记序列（文本、图像、时间序列、DNA等）

### 工具库：

[https://sklearn-crfsuite.readthedocs.io/en/latest/](https://sklearn-crfsuite.readthedocs.io/en/latest/)

### 入门教程：

[http://blog.echen.me/2012/01/03/introduction-to-conditional-random-fields/](http://blog.echen.me/2012/01/03/introduction-to-conditional-random-fields/)

油管上 Hugo Larochelle 的 7 部系列演讲：[https://www.youtube.com/watch?v=GF3iSJkgPbA](https://www.youtube.com/watch?v=GF3iSJkgPbA)

### 10. 决策树

比方来说，我收到了一张 Excel 表格，上面有关于各种水果的数据，我必须说出哪些看起来像苹果。我要做的就是问一个问题“哪个水果是红色且是圆形的？”，把所有回答“是”与“不是”的水果分为两个部分。现在红色且是圆形的水果不一定是苹果，所有苹果不一定都是红色且圆形的。所以我要问下一个问题，对于红色且圆形的水果问：“哪个水果有红色或者黄色？”而对不红且不圆的水果问：“哪些水果是绿色且圆形的？”。根据这些问题，可以相当准确的说出哪些是苹果。这一系列的问题就是决策树。然而，这是一个我直观描述的决策树。直觉不能用于高维的复杂数据。我们必须通过查看标记的数据自动提出一连串的问题。这就是基于机器学习的决策树所做的工作。像 CART 树这样较早的版本曾经用于简单的数据，但是随着数据集越来越大，偏差和方差之间的权衡需要更好的算法来解决。目前常用的两种决策树算法是随机森林算法（在属性的子集上建立不同的分类器，并将它们组合在一起进行输出）和增强树算法（在其他树之上训练一系列树，并纠正其子树中的错误）。

决策树可以用来对数据点（甚至回归）进行分类。

### 工具库：

[http://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html](http://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)

[http://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingClassifier.html](http://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingClassifier.html)

[http://xgboost.readthedocs.io/en/latest/](http://xgboost.readthedocs.io/en/latest/)

[https://catboost.yandex/](https://catboost.yandex/)

### 入门教程：

[http://xgboost.readthedocs.io/en/latest/model.html](http://xgboost.readthedocs.io/en/latest/model.html)

[https://arxiv.org/abs/1511.05741](https://arxiv.org/abs/1511.05741)

[https://arxiv.org/abs/1407.7502](https://arxiv.org/abs/1407.7502)

[http://education.parrotprediction.teachable.com/p/practical-xgboost-in-python](http://education.parrotprediction.teachable.com/p/practical-xgboost-in-python)

### 更多算法（你应当学习）

如果你还在思考以上方法能否解决类似 DeepMind 击败世界围棋冠军一样的任务，不要痴心妄想了。我们上面讨论的这 10 种算法都是模式识别，而不是策略学习。要学习解决多步骤问题（比如赢得棋类游戏或玩 Atari 游戏）的策略，我们需要创建一个自由终端并让其能够学习其面对的奖励和惩罚。这一类的机器学习被称作强化学习。最近该领域中的许多成果（并非全部）都是在将卷积网或 LSTM 的感知能力与一组名为即时差分学习的算法相结合而得出的成果。其中就包括 Q-learning、SARSA 和其他一些变种。这些算法巧妙运用贝尔曼方程得到一个能够让终端由环境奖励训练的损失函数。

这些算法主要用于自动打游戏 :D，也在言语生成和实体识别有一定应用。

### 工具库：

[https://github.com/keras-rl/keras-rl](https://github.com/keras-rl/keras-rl)

[https://github.com/tensorflow/minigo](https://github.com/tensorflow/minigo)

### 入门教程：

获取 Sutton 和 Barto 的免费图书：[https://web2.qatar.cmu.edu/~gdicaro/15381/additional/SuttonBarto-RL-5Nov17.pdf](https://web2.qatar.cmu.edu/~gdicaro/15381/additional/SuttonBarto-RL-5Nov17.pdf)

查看 David Silver 的课程：[https://www.youtube.com/watch?v=2pWv7GOvuf0](https://www.youtube.com/watch?v=2pWv7GOvuf0)。

这些就是成为一个数据科学家你必学的 10 个机器学习算法。

可以在[这里](https://blog.paralleldots.com/data-science/lesser-known-machine-learning-libraries-part-ii/)阅读机器学习的相关工具库。

希望你喜欢这篇文章，请[登录](http://https//user.apis.paralleldots.com/signing-up?utm_source=blog&utm_medium=chat&utm_campaign=paralleldots_blog)获取免费 ParallelDots 账号开始你的 AI 之路。你也可以在[这里](https://www.paralleldots.com/ai-apis)查看我们 API 的样例。

[这里](https://blog.paralleldots.com/data-science/machine-learning/ten-machine-learning-algorithms-know-become-data-scientist/)查看原文。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
