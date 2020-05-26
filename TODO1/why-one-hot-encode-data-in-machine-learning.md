> * 原文地址：[Why One-Hot Encode Data in Machine Learning](https://machinelearningmastery.com/why-one-hot-encode-data-in-machine-learning/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-one-hot-encode-data-in-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-one-hot-encode-data-in-machine-learning.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[TrWestdoor](https://github.com/TrWestdoor), [portandbridge](https://github.com/portandbridge)

# 在机器学习中为什么要进行 One-Hot 编码？

入门机器学习应用，尤其是需要对实际数据进行处理时，是很困难的。

一般来说，机器学习教程会推荐你或要求你，在开始拟合模型之前，先以特定的方式准备好数据。

其中，一个很好的例子就是对类别数据（Categorical data）进行 One-Hot 编码（又称独热编码）。

* 为什么 One-Hot 编码是必要的？
* 为什么你不能直接使用数据来拟合模型？

在本文中，你将得到上述重要问题的答案，并能更好地理解机器学习应用中的数据准备工作。

让我们开始吧！

![在机器学习中为什么要进行 One-Hot 编码？](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2017/07/Why-One-Hot-Encode-Data-in-Machine-Learning.jpg)

[题图 by Karan Jain，保留部分权利](https://www.flickr.com/photos/jiangkeren/8263176332/)

## 什么是类别数据？

类别数据是一种只有标签值而没有数值的变量。

它的值通常属于一个大小固定且有限的集合。

类别变量也常被称为[标称值（nominal）](https://en.wikipedia.org/wiki/Nominal_category)。

下面举例说明：

* 宠物（pet）变量包含以下几种值：狗（dog）、猫（cat）。
* 颜色（color）变量包含以下几种值：红（red）、绿（green）、蓝（blue）。
* 位次（place）变量包含以下几种值：第一（first）、第二（second）和第三（third）。

以上例子中的每个值都代表着一个不同的类别。

有些类别彼此间存在一定的自然关系，比如自然的排序关系。

上述例子中，位次（place）变量的值就有这种自然的排序关系。这种变量被称为序数变量（ordinal variable）。

## 类别数据有什么问题？

有些算法可以直接应用于类别数据。

比如，你可以不进行任何数据转换，将决策树算法直接应用于类别数据上（取决于具体实现方式）。

但还有许多机器学习算法并不能直接操作标签数据。这些算法要求所有的输入输出变量都是数值（numeric）。

通常来说，这种限制主要是因为这些机器学习算法的高效实现造成的，而不是算法本身的限制。

但这也意味着我们需要把类别数据转换成数值形式。如果输出变量是类别变量，那你可能还得将模型的预测值转换回类别形式，以便在一些应用中展示或使用它们。

## 如何将类别数据转换成数值数据？

这包含两个步骤：

1. 整数编码
2. One-Hot 编码

### 1. 整数编码

第一步，先要给每个类别值都分配一个整数值。

比如，用 1 表示红色（red），2 表示绿色（green），3 表示蓝色（blue）。

这种方式被称为标签编码或者整数编码，可以很轻松地将它还原回类别值。

对于某些变量来说，这种编码就足够了。

整数之间存在自然的排序关系，机器学习算法也许可以理解并利用这种关系。

比如，前面的位次（place）例子中的序数变量就是一个很好的例子。对于它我们只需要进行标签编码就够了。

### 2. One-Hot 编码

但对于不存在次序关系的类别变量，仅使用上述的整数编码是不够的。

实际上，使用整数编码会让模型假设类别间存在自然的次序关系，从而导致结果不佳或得到意外的结果（预测值落在两个类别的中间）。

这种情况下，就要对整数表示使用 One-Hot 编码了。One-Hot 编码会去除整数编码，并为每个整数值都创建一个二值变量。

在颜色（color）的示例中，有 3 种类别，因此需要 3 个二值变量进行编码。对应的颜色位置上将被标为“1”，其它颜色位置上会被标为“0”。

比如：

```
red, green, blue
1, 0, 0
0, 1, 0
0, 0, 1
```

在统计学等领域中，这种二值变量通常被称为“虚拟变量”或“哑变量”（dummy variable）。

## One-Hot 编码教程

如果你想了解如何在 Python 对你的数据进行 One-Hot 编码，请参阅：

* [Data Preparation for Gradient Boosting with XGBoost in Python](https://machinelearningmastery.com/data-preparation-gradient-boosting-xgboost-python/) — 在 Python 中使用 XGBoost 梯度提升法前的数据准备
* [How to One Hot Encode Sequence Data in Python](https://machinelearningmastery.com/how-to-one-hot-encode-sequence-data-in-python/) — 如何使用 Python 对序列数据进行 One-Hot 编码

## 拓展阅读

* [类别变量（Categorical variable）](https://en.wikipedia.org/wiki/Categorical_variable)，Wikipedia
* [标称分类（Nominal category）](https://en.wikipedia.org/wiki/Nominal_category)，Wikipedia
* [虚拟变量，哑变量（Dummy variable）](https://en.wikipedia.org/wiki/Dummy_variable_(statistics))，Wikipedia

## 总结

在本文中，你应该了解了为什么在使用机器学习算法时通常要对类别数据进行编码。

特别要注意：

* 类别数据的定义是由一组有限集合中的值构成的变量。
* 大多数机器学习算法都需要输入数值变量，并会输出数值变量。
* 通过整数编码与 One-Hot 编码可以将类别数据转换为整型数据。

还有别的问题？

请在评论中留下你的问题，我会尽力回答。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
