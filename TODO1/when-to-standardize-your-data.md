> * 原文地址：[When and why to standardize your data ?](https://towardsdatascience.com/when-to-standardize-your-data-in-4-minutes-f9282190707e)
> * 原文作者：[Zakaria Jaadi](https://medium.com/@zakaria.jaadi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-to-standardize-your-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-to-standardize-your-data.md)
> * 译者：[Ultrasteve](https://github.com/Ultrasteve)
> * 校对者：[TBLGSn](https://github.com/TBLGSn)

# 什么时候需要进行数据的标准化？为什么？

> 一份告诉你什么时候应该进行数据标准化的指南

![Credits : 365datascience.com](https://cdn-images-1.medium.com/max/NaN/1*dZlwWGNhFco5bmpfwYyLCQ.png)

数据标准化是一种重要的技术，通常来说，在使用许多机器学习模型之前，我们都要使用它来对数据进行预处理，它能对输入数据集里面的各个特征的范围进行标准化。

一些机器学习工程师通常在使用所有机器学习模型之前，倾向于盲目地对他们的数据进行标准化，然而，其实他们并不清楚数据标准化的理由，更不知道什么情况下使用这一技术是必要的，什么时候不是。因此，这篇文章的目标是解释如何，为什么以及何时标准化数据。

## 标准化

当输入数据集的特征在它们的范围之间具有大差异时，或者它们各自使用的单位不同时（比如说一些用米，一些用厘米），我们会想到对数据进行标准化。

这些初始特征范围的差异，会给许多机器学习模型带来不必要的麻烦。例如，对于基于距离计算的模型来说，当其中一个特征值变化范围较大时，那么预测结果很大程度上就会受到它的影响。

我们这里举一个例子。现在我们有一个二维的数据集，它有两个特征，以米为单位的高度（范围是 1 到 2 米）和以磅为单位的重量（范围是 10 到 200 磅）。无论你在这个数据集上使用什么基于距离的模型，重量特征对结果的影响都会大大的高于高度特征，因为它的数据变化范围相对更大。因此，为了预防这种问题的发生，我们会在这里用到数据标准化来约束重量特征的数据变化范围。

## 如何进行数据标准化？

### Z-score

`Z-score` 是最受欢迎的数据标准化方法之一，在这种方法中，我们对每一项数据减去它的平均值并除以它的标准差。

![](https://cdn-images-1.medium.com/max/NaN/0*AgmY9auxftS9BI73.png)

一旦完成了数据标准化，所有特征对应的数据平均值变为 0，方差变为 1，因此，所有特征的数据变化范围现在是一致的。

> 其实还有许多数据标准化的方法，但为了降低难度，我们在这篇文章中只使用这种方法。

## 什么时候需要进行数据的标准化？为什么？

如上所示，在基于距离的模型中，数据标准化用于预防范围较大的特征对预测结果进行较大的影响。不过使用标准化的原因不仅仅只有这一个，对于不同的模型会有不同的原因。

那么，在使用什么机器学习方法和模型之前，我们需要进行数据标准化呢？原因又是什么？

**1- 主成分分析：**

在主成分分析中，方差较大或者范围较大的特征，相较于小方差小范围的数据获得更高的权重，这样会导致它们不合常理的主导第一主成分（方差最大的成分）的变化。为什么说这是不合常理的呢？因为导致这一特征比其他特征权重更大的理由，仅仅是因为它们是以不同的尺度测量的。

通过给予所有特征相同的权重，数据标准化可以预防这一点。

**2- 聚类：**

聚类模型是基于距离的算法。为了测量观测对象之间的相似性，并将它们聚集在一起，模型需要使用距离度量
距离度量(Distance Metrics)。在这种算法中，范围较大的特征会对聚类结果产生更大的影响。因此，在进行聚类之前我们需要进行数据标准化。

**3- KNN：**

k-最近邻(分类算法)是一个基于距离的分类器，其基于对训练集中已标记的观察结果的相似性度量（例如：距离度量）来对于新数据进行分类。标准化使所有变量对相似性度量的贡献相等。

**4- SVM：**

支持向量机尝试最大化决策平面与支持向量之间的距离。如果一个特征的值很大，那么相较于其他特征它会对计算结果造成更大的影响。因此，标准化使所有特征对距离度量具有相同的影响。

![Credits : Arun Manglick ([arun-aiml.blogspot.com](http://arun-aiml.blogspot.com/))](https://cdn-images-1.medium.com/max/2000/0*_taflmQxrsa0vguT.PNG)

**5- 在回归模型中测量自变量的重要性**

你可以在回归分析中测量变量的重要程度。首先使用**标准化**过后的独立变量来训练模型，然后计算它们对应的标准化系数的绝对值差就能得出结论。然而，如果独立变量是未经标准化的，那比较它们的系数将毫无意义。

**6- Lasso 回归和岭回归**

Lasso 回归和岭回归对各变量对应的系数进行惩罚。变量的范围将会影响到他们对应系数受到什么程度的惩罚。因为方差大的变量对应的系数很小，因此它们会受到较小的惩罚。因此，在使用上面的两个回归之前需要进行标准化。

## 什么时候不需要标准化？

**逻辑回归和树形模型**

逻辑回归，树形模型（决策树，随机森林）和梯度提升树对于变量的大小并不敏感。所以数据标准化在这里并不必要。

## 结论

综上所述，正确使用数据标准化的时机取决于你当前在使用什么模型，你想用模型达到怎么样的目的。因此，如果机器学习工程师想知道什么时候该进行数据标准化并建造一个成功的机器学习模型，理解机器学习算法的内在原理十分重要。

> 注：这篇文章并没有列出所有需要标准化的模型和方法。

### 参考文献：

* [**365DataScience.com**]: Explaining Standardization Step-By-Step
* [**Listendata.com** ]: when and why to standardize a variable

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
