> * 原文地址：[Automated Feature Engineering in Python](https://towardsdatascience.com/automated-feature-engineering-in-python-99baf11cc219)
> * 原文作者：[William Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md)
> * 译者：[mingxing47](https://github.com/mingxing47)
> * 校对者：

# Python 中的自动特征工程

## 如何自动化地创建机器学习特征

![](https://cdn-images-1.medium.com/max/1000/1*lg3OxWVYDsJFN-snBY7M5w.jpeg)

机器学习正在利用诸如 [H20](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html)、[TPOT](https://epistasislab.github.io/tpot/) 和 [auto-sklearn](https://automl.github.io/auto-sklearn/stable/) 等工具越来越多地从手工设计模型向自动化优化管道迁移。以上这些类库，连同如 [random search](http://www.jmlr.org/papers/volume13/bergstra12a/bergstra12a.pdf) 等方法一起，目的都是在通过找到适合于几乎不需要人工干预的数据集的最佳模型来简化机器学习的模型选择和调优部分。然而，特征工程，作为机器学习管道中一个[可以说是更有价值的方面](https://www.featurelabs.com/blog/secret-to-data-science-success/)，几乎全部是手工活。

[特征工程](https://en.wikipedia.org/wiki/Feature_engineering)，也成为特征创建，是从已有数据中创建出新特征并且用于训练机器学习模型的过程。这个步骤可能要比实际使用的模型更加重要，因为机器学习算法仅仅从我们提供给他的数据中进行学习，创建出与任务相关的特征是非常关键的（可以参照这篇文章 ["A Few Useful Things to Know about Machine Learning"](https://homes.cs.washington.edu/~pedrod/papers/cacm12.pdf) —— 《了解机器学习的一些有用的事》，译者注）。

通常来说，特征工程是一个漫长的手工过程，依赖于某个特定领域的知识、直觉、以及对数据的操作。这个过程可能会非常乏味并且最终获得的特性会被人类的主观性和花在上面的时间所限制。自动特征工程的目标是通过从数据集中创建许多候选特征来帮助数据科学家减轻工作负担，从这些创建了候选特征的数据集中，数据科学家可以选择最佳的特征并且用来训练。

在这篇文章中，我们将剖析一个基于 [featuretools Python library](https://docs.featuretools.com/#) 库进行自动特征工程处理的案例。我们将使用一个样例数据集来展示基本信息（请继续关注未来的使用真实数据的文章）。这篇文章最终的代码可以在 [GitHub](https://github.com/WillKoehrsen/automated-feature-engineering/blob/master/walk_through/Automated_Feature_Engineering.ipynb) 获取。

* * *

### 特征工程基础

[特征工程](https://www.datacamp.com/community/tutorials/feature-engineering-kaggle)意味着从分布在多个相关表格中的现有数据集中构建出额外的特性。特征工程需要从数据中提取相关信息，并且将其放入一个单独的表中，然后可以用来训练机器学习模型。

构建特征的过程非常耗时，因为每获取一项新的特征都需要很多步骤才能构建出来，尤其是当需要从多于一张表格中获取信息时。我们可以把特征创建的操作分成两类：**转换**和**聚集**。让我们通过几个例子的实战来看看这些概念。

一次**转换**操作仅作用于一张表，该操作能从一个或多个现有列中创建新特征（比如说 Python 中，一张表就如同 Pandas 库中的一个 `DataFrame`）。如下面的例子所示，假如我们有如下的一张客户（clients）信息表：

![](https://cdn-images-1.medium.com/max/800/1*FHR7tlD4FuGKt8n5UHUpqw.png)

我们可以通过从 `joined` 列中寻找出月份或者对 `income` 列取自然对数来创建特征。这些都是转换的范畴，因为他们都是使用了单张表中的信息。

![](https://cdn-images-1.medium.com/max/800/1*QQGYN1PD06rNT-bJphNcBA.png)

另一方面，**聚集** 则是跨表执行的，其使用了一对多关系进行分组观察，然后再计算统计数据。比如说，如果我们还有另外一张含有客户贷款信息的表格，这张表里可能每个客户都有多种贷款，我们就可以计算出每位客户端诸如贷款平均值、最大值、最小值等统计数据。

这个过程包括了根据客户进行贷款表格分组、计算聚合、然后把计算结果数据合并到客户数据中。如下代码展示了我们如果使用 Python 中的 [language of Pandas](https://pandas.pydata.org/pandas-docs/stable/index.html)库进行计算的过程：

```
import pandas as pd

# 根据客户 id （client id）进行贷款分组，并计算贷款平均值、最大值、最小值
stats = loans.groupby('client_id')['loan_amount'].agg(['mean', 'max', 'min'])
stats.columns = ['mean_loan_amount', 'max_loan_amount', 'min_loan_amount']

# 把客户的 dataframe 进行合并
stats = clients.merge(stats, left_on = 'client_id', right_index=True, how = 'left')

stats.head(10)
```

![](https://cdn-images-1.medium.com/max/800/1*jHHOuEft93KDenbRpaFcnA.png)

这些操作本身并不困难，但是如果我们有数百个变量分布在数十张表中，手工进行操作则是不可行的。理想情况下，我们希望有一种解决方案，可以在多个表格当中进行自动转换和聚合操作，最后将结果数据合并到一张表格中。尽管 Pandas 是一个很优秀的资源库，但利用 Pandas 时我们仍然需要手工操作很多的数据！（更多关于手工特征工程的消息可以查看如下这个杰出的著作 [Python Data Science Handbook](https://jakevdp.github.io/PythonDataScienceHandbook/05.04-feature-engineering.html)）。

### Featuretools 框架

幸运的是， featuretools 正是我们所寻找的解决方案。这个开源的 Python 库可以自动地从一系列有关联的表格中创建出很多的特征。 Featuretools 的是基于一个被称为 "[Deep feature synthesis](http://featurelabs1.wpengine.com/wp-content/uploads/2017/12/DSAA_DSM_2015-1.pdf)" （深度特征合成）的方法所创建出来的，这个方法听起来要比实际跑起来更加令人印象深刻。（这个名字是来自于多特征的叠加，并不是因为这个方法使用了深度学习！）

深度特征合成叠加了多个转换和聚合操作（在 feautretools 中也被称为 [feature primitives (特征基元)](https://docs.featuretools.com/automated_feature_engineering/primitives.html)）来从遍布很多表格中的数据中创建出特征。如同绝大多数机器学习中的想法一样，这是一种建立在简单概念基础上的复杂方法。通过一次学习一个构建模块，我们可以很好地理解这个强大的方法。

首先，让我们看看我们的数据。之前我们已经看到了一些数据集，完整的表集合如下所示：

*   `clients` : 客户在信用社的的基本信息。每个客户在这个 dataframe 中仅占一行

![](https://cdn-images-1.medium.com/max/800/1*FHR7tlD4FuGKt8n5UHUpqw.png)

*   `loans`: 给客户的贷款。每个贷款在这个 dataframe 中仅占一行，但是客户可能会有多个贷款

![](https://cdn-images-1.medium.com/max/1000/1*95c7QchQVM-9xUUA4ZB4XQ.png)

*   `payments`: 贷款偿还。每个付款只有一行，但是每笔贷款可以有多笔付款。

![](https://cdn-images-1.medium.com/max/1000/1*RbgNzspaiwq74aWU6W5LWQ.png)

如果我们有一件机器学习任务，例如预测一个客户是否会偿还一个未来的贷款，我们将把所有关于客户的信息合并到一个表格中。这些表格是相互关联的（通过 `client_id` 和 `loan_id` 变量），我们可以使用一系列的转换和聚合操作来手工完成这一过程。然而，我们很快就将看到，我们可以使用 featuretools 来自动化这个过程。

### 实体和实体集

对于 featuretools 来说，最重要的两个概念是**实体**和**实体集**。一个实体就只是一张表（或者说一个 Pandas 中的 `DataFrame`） 。一个[实体集](https://docs.featuretools.com/loading_data/using_entitysets.html)是一系列表的集合以及这些表格之间的关系。你可以把实体集认为是 Python 中的另外一个数据结构，这个数据结构有自己的方法和参数。

我们可以在 featuretools 中利用下面的代码创建出一个空的实体集：

```
import featuretools as ft

# 创建新实体集  
es = ft.EntitySet(id = 'clients')
```

现在我们必须添加一些实体。每个实体必须有一个索引，它是一个包含所有唯一元素的列。也就是说，索引中的每个值必须只出现在表中一次。`clients` dataframe 中的索引是 `client_id` ，因为每个客户在这个 dataframe 中只有一行。我们使用以下语法向实体集添加一个已经有索引的实体：

```
# 从客户 dataframe 中创建出一个实体
# 这个 dataframe 已经有一个索引和一个时间索引
es = es.entity_from_dataframe(entity_id = 'clients', dataframe = clients, 
                              index = 'client_id', time_index = 'joined')
```

`loans` datafram 同样有一个唯一的索引,`loan_id` 以及向实体集添加 `loan_id` 的语法和 `clients` 一样。然而，对于 `payments` dataframe 来说，并不存在唯一的索引。当我们向实体集添加实体时，我们需要把参数 `make_index` 设置为 `True`( `make_index = True` )，同时为索引指定好名称。此外，虽然 featuretools 会自动推断实体中的每个列的数据类型,我们也可以将一个列类型的字典传递给参数 `variable_types` 来进行数据类型重写。

```
# 从付款 dataframe 中创建一个实体
# 该实体还没有一个唯一的索引
es = es.entity_from_dataframe(entity_id = 'payments', 
                              dataframe = payments,
                              variable_types = {'missed': ft.variable_types.Categorical},
                              make_index = True,
                              index = 'payment_id',
                              time_index = 'payment_date')
```

对于这个 dataframe 来说，即使 `missed` 是一个整型数据，这不是一个[数值变量](https://socratic.org/questions/what-is-a-numerical-variable-and-what-is-a-categorical-variable)，因为它只能接受两个离散值，所以我们告诉 featuretools 将它是为一个分类变量。在向实体集添加了 dataframs 之后，我们将检查其中的任何一个：

![](https://cdn-images-1.medium.com/max/800/1*DZ44KuggN_4jWKwuhrpCaw.png)

我们指定的修改可以正确地推断列类型。接下来，我们需要指定实体集中的表是如何进行关联的。

#### 表关系

考虑两个表之间的**关系**的最佳方式是[父亲与孩子的类比](https://stackoverflow.com/questions/7880921/what-is- par-table -and- child-table-in-database)。这是一对多的关系:每个父亲可以有多个孩子。在表领域中，父亲在每个父表中都有一行，但是子表中可能有多个行对应于同一个父亲的多个孩子。

例如，在我们的数据集中，`clients` dataframe 是 `loans` dataframe 的父亲。每个客户在 `clients` 中只有一行，但在 `loans` 中可能有多行。同样， `loans` 是 `payments` 的父亲，因为每笔贷款都有多个支付。父亲通过共享变量与孩子相连。当我们执行聚合时，我们将子表按父变量分组，并计算每个父表的子表的统计信息。

要[在 featuretools 中格式化关系](https://docs.featuretools.com/loading_data/using_entitysets.html#add -a-relationship)，我们只需指定将两个表链接在一起的变量。 `clients` 和 `loans` 表通过 `loan_id` 变量链接， `loans` 和 `payments` 通过 `loan_id` 联系在一起。创建关系并将其添加到实体集的语法如下所示:

```
# 客户与先前贷款的关系
r_client_previous = ft.Relationship(es['clients']['client_id'],
                                    es['loans']['client_id'])

# 将关系添加到实体集
es = es.add_relationship(r_client_previous)

# 以前的贷款和以前的付款之间的关系
r_payments = ft.Relationship(es['loans']['loan_id'],
                                      es['payments']['loan_id'])

# 将关系添加到实体集
es = es.add_relationship(r_payments)

es
```

![](https://cdn-images-1.medium.com/max/800/1*W_jS8Z4Ym5zAFTdjHki1ig.png)

实体集现在包含三个实体(或者说是表)和连接这些实体的关系。在添加实体和对关系形式化之后，我们的实体集就准备完成了，我们接下来可以准备创建特征。

#### 特征基元

在深入了解特性合成之前，我们需要了解[特征基元](https://docs.featuretools.com/automated_feature_engineering/primartives.html)。我们已经知道它们是什么了，但是我们只是用不同的名字称呼它们！这些是我们用来形成新特征的基本操作:

*   聚合：通过父节点对子节点(一对多)关系完成的操作，并计算子节点的统计信息。一个例子是通过 `client_id` 将 `loan` 表分组，并为每个客户机找到最大的贷款金额。
*   转换：在单个表上对一个或多个列执行的操作。举个例子，取一个表中两个列之间的差值，或者取列的绝对值。

新特性是在 featruetools 中创建的，使用这些特征基元本身或叠加多个特征基元。下面是 featuretools 中的一些特征基元列表(我们还可以[定义自定义特征基元](https://docs.featuretools.com/guides/advanced_custom_basics .html)：

![](https://cdn-images-1.medium.com/max/800/1*_p-HwN54IjLvmSSlkkazUQ.png)

特征基元

这些基元可以自己使用或组合来创建特征。要使用指定的基元，我们使用 `ft.dfs` 函数（代表深度特征合成）。我们传入 `实体集`、`目标实体`（这两个参数是我们想要加入特征的表）以及 `trans_primitives` 参数(用于转换)和 `agg_primitives` 参数(用于聚合)：

```
# 使用指定的基元创建新特征
features, feature_names = ft.dfs(entityset = es, target_entity = 'clients', 
                                 agg_primitives = ['mean', 'max', 'percent_true', 'last'],
                                 trans_primitives = ['years', 'month', 'subtract', 'divide'])
```

以上函数返回结果是每个客户的新特征 dataframe (因为我们把客户定义为`目标实体`)。例如，我们有每个客户加入的月份，这个月份是一个转换特性基元：

![](https://cdn-images-1.medium.com/max/800/1*gEQkpyTDxXz21_gUPeNlMQ.png)

我们还有一些聚合基元，比如每个客户的平均支付金额：

![](https://cdn-images-1.medium.com/max/800/1*7aOkE5N-WCNQHJi1qBcqjQ.png)

尽管我们只指定了很少一部分的特征基元，但是 featuretools 通过组合和叠加这些基元创建了许多新特征。

![](https://cdn-images-1.medium.com/max/800/1*q24CTYC4x7fHj0YFwdusoQ.png)

完整的 dataframe 有793列新特性！

#### 深度特征合成

现在，我们已经准备好了理解深度特征合成(deep feature synthesis, dfs)的所有部分。事实上，我们已经在前面的函数调用中执行了 dfs 函数！深度特性只是将多个特征基元叠加的特性，而 dfs 是生成这些特性的过程的名称。深度特征的深度是创建该特性所需的特征数量。

例如，`MEAN(payments.payment_amount)` 列是一个深度为 1 的特征，因为它是使用单个聚合创建的。深度为 2 的特征是 `LAST(loans(MEAN(payments.payment_amount))` ，这是通过叠加两个聚合而成的： LAST(most recent) 在均值之上。这表示每个客户最近一次贷款的平均支付金额。

![](https://cdn-images-1.medium.com/max/800/1*y28-ibs-ZCpCvavVPmmZAw.png)

我们可以将特征叠加到任何我们想要的深度，但是在实践中，我从来没有超过 2 的深度。在这之后，这些特征就很难解释了，但我鼓励有兴趣的人尝试[“深入研究”](http://knowyourmeme.com/memes/we-needgo-deep)。

* * *

我们不必手工指定特征基元，而是可以让 featuretools 自动为我们选择特性。为此，我们使用相同的 `ft.dfs` 函数调用，但不传递任何特征基元:

```
# 执行深度特征合成而不指定特征基元。
features, feature_names = ft.dfs(entityset=es, target_entity='clients', 
                                 max_depth = 2)

features.head()
```

![](https://cdn-images-1.medium.com/max/800/1*tewxbRVcXb_weoy_g6EfkA.png)

Featuretools 已经为我们构建了许多新的特征供我们使用。虽然这个过程会自动创建新特征，但它不会取代数据科学家，因为我们仍然需要弄清楚如何处理所有这些特征。例如，如果我们的目标是预测客户是否会偿还贷款，我们可以查找与特定结果最相关的特征。此外，如果我们有特殊领域知识，我们可以使用它来选择具有候选特征的特定特征基元或[种子深度特征合成](https://docs.featuretools.com/guides/tuning_dfs.html)。

#### 接下来的步骤

自动化的特征工程解决了一个问题，但却创造了另一个问题：创造出太多的特征。虽然说在确定好一个模型之前很难说这些特征中哪些是重要的，但很可能并不是所有的特征斗鱼我们想要训练的任务相关。更多的是，[拥有太多特征](https://pdfs.semanticscholar.org/a83b/ddb34618cc68f1014ca12eef7f537825d104.pdf)可能会让模型的表现下降，因为在训练的过程中一些不太有用的特征会淹没那些更为重要的特征。

太多特征的问题被称为[维数的诅咒](https://en.wikipedia.org/wiki/Curse_of_dimensionality#Machine_learning)。随着特征数量的增加(数据的维数增加)，模型越来越难以了解特征和目标之间的映射。事实上，模型执行良好所需的数据量(与特性的数量成指数比例)(https://stats.stackexchange.com/a/65380/157316)。

可以化解维数诅咒的是[特征削减(也称为特征选择)](https://machinelearningmastery.com/an-introduction-to-feature-selection/)：移除不相关特性的过程。这可以采取多种形式:主成分分析(PCA)，使用 SelectKBest 类，使用从模型引入的特征，或者使用深度神经网络进行自动编码。当然，[特征削减](https://en.wikipedia.org/wiki/Feature_selection)则是另一篇文章的另一个主题了。现在，我们知道，我们可以使用 featuretools ，以最少的工作量从许多表中创建大量的特性！

### 结论

像机器学习领域很多的话题一样，使用 feautretools 的自动特征工程是一个建立在简单想法之上的复杂概念。使用实体集、实体和关系的概念，feautretools 可以执行深度特性合成来创建新特征。深度特征合成反过来又将特征基元堆叠起来 —— 也就是**聚合**，在表格之间建立起一对多的关系，同时进行**转换**，在单表中对一列或者多列应用，通过这些方法从很多的表格中构建出新的特征出来。

请持续关注这篇文章，与此同时，阅读关于这个竞赛的介绍 [this introduction to get started](https://towardsdatascience.com/machine-learning-kaggle-competition-part-one-getting-started-32fb9ff47426)。我希望您现在可以使用自动化特征工程作为数据科学管道中的辅助工具。我们的模型将和我们提供的数据一样好，自动化的特征工程可以帮助使特征创建过程更有效。

要获取更多关于特征工具的信息，包括这些工具的高级用法，可以查阅[在线文档](https://docs.featuretools.com/)。要查看特征工具如何在实践中应用，可以参见 [Feature Labs 的工作成果](https://www.featurelabs.com/)，这是一个开源库背后的公司。

我一如既往地欢迎各位的反馈和建设性的批评，你们可以在 Twitter [@koehrsen_will](http://twitter.com/koehrsen_will) 上与我进行交流。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
