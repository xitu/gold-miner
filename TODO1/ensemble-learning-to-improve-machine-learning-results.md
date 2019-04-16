> * 原文地址：[Ensemble Learning to Improve Machine Learning Results](https://blog.statsbot.co/ensemble-learning-d1dcd548e936)
> * 原文作者：[Vadim Smolyakov](https://blog.statsbot.co/@vsmolyakov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ensemble-learning-to-improve-machine-learning-results.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ensemble-learning-to-improve-machine-learning-results.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[haiyang-tju](https://github.com/haiyang-tju), [TrWestdoor](https://github.com/TrWestdoor)

# 通过集成学习**提高机器学习结果**

## 集成方法的工作原理：bagging、boosting 和 stacking

![](https://cdn-images-1.medium.com/max/2000/1*-XBxuOgB5j0irQiB9dRubA.jpeg)

**集成学习可以通过组合多种模型来提高机器学习的结果。这种方法相对于单个模型，可以为结果带来更好的性能预测。这也是集成方法在诸多久负盛名的机器学习竞赛（如 NetFlix 竞赛、KDD 2009 和 Kaggle）中位居第一的原因。***。

[**Statsbot**](http://statsbot.co?utm_source=blog&utm_medium=article&utm_campaign=ensemble) 团队为了让你了解这种方法的优点，邀请了数据科学家 Vadim Smolyakov 来带你一起深入研究三种基本的集成学习技术。

* * *

集成方法是将多个机器学习技术组合成一个预测模型的元算法，它可以进行 **decrease** **variance** (bagging)、**bias** (boosting) 或者 **改进预测** (stacking)。

集成学习可以分成两组：

*   **序列**集成方法，是基础学习对象按顺序生成的（例如 AdaBoost）。
    序列方法的基本动机是**利用基础学习对象之间的依赖性**。通过加权先前错误标记的高权重示例，可以提高总体性能。
*   **并行**集成方法，是基础学习对象并行生成的（例如 Random Forest）。
    并行方法的基本动机是**利用基础学习对象之间的独立性**，因为错误可以通过均衡来显著减少。

大多数集成方法都使用单基学习算法来生成同类的学习对象，即相同类型的学习对象，从而形成**集成**。

也有一些使用不同类型的方法，即不同类型的学习对象，会导致**异构集成**。为了使集成方法比它的任何一个成员更精确，基础学习对象必须尽可能准确，尽可能多样化。

### Bagging

Bagging 表示自助汇聚（bootstrap aggregation）。降低估计方差的一种方法是将多个估计平均在一起。例如，我们可以在数据的不同子集（随机选择和替换）上训练 M 个不同的树，并计算集成。

![](https://cdn-images-1.medium.com/max/800/1*VLSQXGANQ-cUdcI_lyH3YA.png)

Bagging 使用自助采样来获取训练基础学习对象的数据子集。为了聚合基础学习对象的输出，bagging 使用**分类投票**和**回归平均**。

我们可以在鸢尾花数据集分类的背景下研究 bagging 问题。我们可以选择两个基础估计器：一个决策树和一个 k-NN 分类器。图一显示了基础估计器的学习决策树边界以及应用鸢尾花数据集的 bagging 集成。

Accuracy: 0.63 (+/- 0.02) [Decision Tree]
Accuracy: 0.70 (+/- 0.02) [K-NN]
Accuracy: 0.64 (+/- 0.01) [Bagging Tree]
Accuracy: 0.59 (+/- 0.07) [Bagging K-NN]

![](https://cdn-images-1.medium.com/max/1000/0*_qR1_TDjTpchTmDE.)

决策树显示了 axes 的平行边界，当 k=1 时的最近临界点与数据点非常靠近。Bagging 集成使用 10 种基估计器来进行训练，训练数据的子采样为 0.8，特征的子采样为 0.8。

相较于 K-NN bagging 集成，决策树 bagging 集成具有更高的精确度。K-NN 对训练样本的扰动不太敏感，因此被称为稳定的学习对象。

> **将稳定的学习对象组合在一起并不都是有利的，因为有时这样的集成无利于提高泛化性能**。

图中还显示了在测试时，随着集成度的提高精确度也会随之提高。基于交叉验证的结果，我们可以看到精确度的提升大约会在有 10 个基估计器时趋于稳定。因此，添加超过 10 个基估计器只会增加计算复杂度，而不会提高鸢尾花数据集的准确度。

我们还可以看到 bagging 树集成的学习曲线。注意，训练数据的平均误差是 0.3，测试数据的误差曲线是 U 型。训练和测试误差之间的最小差距发生在训练集大小的 80% 左右。

> **一种常用的集成算法是随机森林**。

在**随机森林**中，集成的每一棵树都是从训练集中用替换（例如，引导样本）绘制样本构建的。此外，不使用所有的特性，而是选择一个随机子集的特征，进一步随机化树。

结果，森林的偏差略有增加，但由于相关性较弱的树木被平均化，从而导致方差减小，因此形成了一个整体上更好的模型。

![](https://cdn-images-1.medium.com/max/800/0*uGzCQfXlC-97VR10.)

在一个**非常随机的树**中，算法的随机性更进一步：分裂阀值是随机的。对于每个候选特征，阈值都是随机抽取的，而不是寻找最具鉴别性的阈值，并选择这些随机生成的阀值中的最佳阀值作为分割规则。这通常会使模型的方差减少得多一点，但代价是偏差增加得多一点。

### Boosting

Boosting 是指能够将弱学习对象转化为强学习对象的一系列算法。Boosting 的主要原理是对一系列仅略好于随机预测的弱学习模型进行拟合，例如小决策树 —— 对数据进行加权处理。对前几轮错误分类的例子给予更多的重视。

然后，通过加权多数投票（分类）或加权和（回归）组合预测，生成最终预测。Boosting 和 committee（如 bagging）的主要区别在于，基础学习对象是按加权版本的数据顺序进行训练的。

下述算法描述了使用最广泛的，称为 **AdaBoost** 的 boosting 算法，它代表着自适应增强。

![](https://cdn-images-1.medium.com/max/800/0*MmYd6wgreP-oBoKi.)

我们看到，第一个基分类器 y1(x) 是使用相等的加权系数来训练的，这些系数是相等的。在随后的增强轮次中，对于被错误分类的数据点增加加权系数，对于正确分类的数据点则减小加权系数。

数量 epsilon 表示每个基分类器的加权错误率。因此，加权系数 α 赋予更准确的分类器更大的权重。

![](https://cdn-images-1.medium.com/max/1000/0*yu6i_z6UwcQLHpua.)

AdaBoost 算法如上图所示。每个基学习器由一棵深度为 1 的决策树组成，从而根据一个特征阀值对数据进行分类（分为两个区域），该区域由一个与其中一个轴平行的线性决策面隔开。该图还显示了测试精度如何随着集成的大小和训练测试数据的学习曲线的提高而提高。

**梯度树 Boosting** 是 bootsting 对任意可微损失函数的推广。它既可用于回归问题，也可用于分类问题。梯度 Boosting 以顺序的方式建立模型。

![](https://cdn-images-1.medium.com/max/800/1*NCol0wpk85JG1K5Qek-6Ig.jpeg)

选择决策树 hm(x) 在每个阶段使用给定当前的 Fm-1(x) 来最小化损失函数 L。

![](https://cdn-images-1.medium.com/max/800/1*ogVGUcU2QpzBk_GonOxUdQ.jpeg)

回归算法和分类算法在所使用的损失函数类型上有所区别。

### Stacking

Stacking 是一种通过元分类器或元回归器来将多种分类或回归模型结合在一起的集成学习技术。基于一套完整的训练集对该基础模型进行训练，然后将该元模型作为特征所述基础级模型的输出进行训练。

基础级通常由不同的学习算法组成，因此 stacking 集成往往是异构的。下面的算法总结了 stacking。

![](https://cdn-images-1.medium.com/max/800/0*GXMZ7SIXHyVzGCE_.)

![](https://cdn-images-1.medium.com/max/1000/0*68zDJt_8RZ953Y5U.)

上图的右上子图显示了以下准确度：

Accuracy: 0.91 (+/- 0.01) [KNN]
Accuracy: 0.91 (+/- 0.06) [随机森林]
Accuracy: 0.92 (+/- 0.03) [Naive Bayes]
Accuracy: 0.95 (+/- 0.03) [Stacking Classifier]

Stacking 集成如上所示。它由 K-NN、随机森林和朴素贝叶斯基分类器组成，其预测用 Logistic 回归作为元分类器。我们可以看到 stacking 分类器实现了决策边界的混合。该图还表明，stacking 比单个分类器具有更高的精度，并且是基于学习曲线，没有出现过拟合的迹象。

Stacking 是赢取 Kaggle 数据科学竞赛的常用技术。例如，Otto 组产品分类挑战的第一名是由 30 个模型组成的 stacking 集成，它的输出被作为三种元分类器的特征：XGBoost、神经网络和 Adaboost。更多细节可以在[此](https://www.kaggle.com/c/otto-group-product-classification-challenge/discussion/14335)查看。

### 代码

本文生成所有图像的代码都可以在，你可以在 [ipython notebook](https://github.com/vsmolyakov/experiments_with_python/blob/master/chp01/ensemble_methods.ipynb) 上查看。

### 总结

除了本文所研究的方法，在深度学习中使用多样化训练和精确的分类器来集成也是非常普遍的方式。多样化也可以通过变化的架构、设置超参数以及使用不同的训练技术来实现。

集成方法在具有挑战性的数据集上非常成功地达到了创纪录的性能，并在 Kaggle 数据科学竞赛中名列前茅。

### 推荐阅读

*   Zhi-Hua Zhou，“集成方法：基础与算法”，CRC Press, 2012
*   L. Kuncheva，“组合模式分类器：方法与算法”，Wiley, 2004
*   [Kaggle 集成指南](https://mlwave.com/kaggle-ensembling-guide/)
*   [Scikit 集成学习指南](http://scikit-learn.org/stable/modules/ensemble.html)
*   [S. Rachka, MLxtend library](http://rasbt.github.io/mlxtend/)
*   [Kaggle Winning Ensemble](https://www.kaggle.com/c/otto-group-product-classification-challenge/discussion/14335)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
