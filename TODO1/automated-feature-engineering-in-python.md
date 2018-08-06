> * 原文地址：[Automated Feature Engineering in Python](https://towardsdatascience.com/automated-feature-engineering-in-python-99baf11cc219)
> * 原文作者：[William Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md)
> * 译者：[mingxing47](https://github.com/mingxing47)
> * 校对者：

# Python 中的自动特征工程

## 如何自动化地创建机器学习特征

![](https://cdn-images-1.medium.com/max/1000/1*lg3OxWVYDsJFN-snBY7M5w.jpeg)

机器学习正在利用诸如 [H20](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html), [TPOT](https://epistasislab.github.io/tpot/) 和 [auto-sklearn](https://automl.github.io/auto-sklearn/stable/) 等工具越来越多地从手工设计模型向自动化优化管道迁移。以上这些类库，连同如 [random search](http://www.jmlr.org/papers/volume13/bergstra12a/bergstra12a.pdf) 等方法一起，目的都是在通过找到适合于几乎不需要人工干预的数据集的最佳模型来简化机器学习的模型选择和调优部分。然而，特征工程，作为机器学习管道中一个[可以说是更有价值的方面](https://www.featurelabs.com/blog/secret-to-data-science-success/)，几乎全部是人工劳动的成果。

[特征工程](https://en.wikipedia.org/wiki/Feature_engineering)，也成为特征创建，是从已有数据中创建出新特征并且用于训练机器学习模型的过程。这个步骤可能要比实际使用的模型更加重要，因为机器学习算法仅仅从我们提供给他的数据中进行学习，创建出与任务相关的特征是非常关键的（可以参照这篇文章 ["A Few Useful Things to Know about Machine Learning"](https://homes.cs.washington.edu/~pedrod/papers/cacm12.pdf) —— 《了解机器学习的一些有用的事》，译者注）。

通常来说，特征工程是一个漫长的手工过程，依赖于某个特定领域的知识、直觉、以及对数据的操作。这个过程可能会非常乏味并且最终获得的特性会被人类的主观性和花在上面的时间所限制。自动特征工程的目标是通过从数据集中创建许多候选特征来帮助数据科学家，从这些创建了候选特征的数据集中，数据科学家可以选择最佳的特征并且用来训练。

在这篇文章中，我们将剖析一个基于 [featuretools Python library](https://docs.featuretools.com/#) 库进行自动特征工程处理的案例。我们将使用一个样例数据集来展示基本信息（请继续关注未来的使用真实数据的文章）。这篇文章最终的代码可以在 [GitHub](https://github.com/WillKoehrsen/automated-feature-engineering/blob/master/walk_through/Automated_Feature_Engineering.ipynb) 获取。

* * *

### 特征工程基础

[特征工程](https://www.datacamp.com/community/tutorials/feature-engineering-kaggle)意味着从分布在多个相关表格中的现有数据集中构建出额外的特性。特征工程需要从数据中提取相关信息，并且将其放入一个单独的表中，然后可以用来训练机器学习模型。

构建特征的过程非常耗时，因为每获取一项新的特征都需要很多步骤才能构建出来，尤其是当需要从多于一张表格中获取信息时。我们可以把特征创建的操作分成两类：**转换** 和 **聚集**。让我们通过几个例子的实战来看看这些概念。

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

Deep feature synthesis stacks multiple transformation and aggregation operations (which are called [feature primitives](https://docs.featuretools.com/automated_feature_engineering/primitives.html) in the vocab of featuretools) to create features from data spread across many tables. Like most ideas in machine learning, it’s a complex method built on a foundation of simple concepts. By learning one building block at a time, we can form a good understanding of this powerful method.深度特征合成叠加了多个转换和聚合操作（在 feautretools 中也被称为 [feature primitives (特征元)](https://docs.featuretools.com/automated_feature_engineering/primitives.html)来便于）。

First, let’s take a look at our example data. We already saw some of the dataset above, and the complete collection of tables is as follows:首先，让我们看看我们的数据。

*   `clients` : basic information about clients at a credit union. Each client has only one row in this dataframe

![](https://cdn-images-1.medium.com/max/800/1*FHR7tlD4FuGKt8n5UHUpqw.png)

*   `loans`: loans made to the clients. Each loan has only own row in this dataframe but clients may have multiple loans.

![](https://cdn-images-1.medium.com/max/1000/1*95c7QchQVM-9xUUA4ZB4XQ.png)

*   `payments`: payments made on the loans. Each payment has only one row but each loan will have multiple payments.*   

![](https://cdn-images-1.medium.com/max/1000/1*RbgNzspaiwq74aWU6W5LWQ.png)

If we have a machine learning task, such as predicting whether a client will repay a future loan, we will want to combine all the information about clients into a single table. The tables are related (through the `client_id` and the `loan_id` variables) and we could use a series of transformations and aggregations to do this process by hand. However, we will shortly see that we can instead use featuretools to automate the process.

### 实体和实体集

The first two concepts of featuretools are **entities** and **entitysets**. An entity is simply a table (or a `DataFrame` if you think in Pandas). An [EntitySet](https://docs.featuretools.com/loading_data/using_entitysets.html) is a collection of tables and the relationships between them. Think of an entityset as just another Python data structure, with its own methods and attributes.

We can create an empty entityset in featuretools using the following:

```
import featuretools as ft

# Create new entityset  
es = ft.EntitySet(id = 'clients')
```

Now we have to add entities. Each entity must have an index, which is a column with all unique elements. That is, each value in the index must appear in the table only once. The index in the `clients` dataframe is the `client_id`because each client has only one row in this dataframe. We add an entity with an existing index to an entityset using the following syntax:

```
# Create an entity from the client dataframe
# This dataframe already has an index and a time index
es = es.entity_from_dataframe(entity_id = 'clients', dataframe = clients, 
                              index = 'client_id', time_index = 'joined')
```

The `loans` dataframe also has a unique index, `loan_id` and the syntax to add this to the entityset is the same as for `clients`. However, for the `payments` dataframe, there is no unique index. When we add this entity to the entityset, we need to pass in the parameter `make_index = True` and specify the name of the index. Also, although featuretools will automatically infer the data type of each column in an entity, we can override this by passing in a dictionary of column types to the parameter `variable_types` .

```
# Create an entity from the payments dataframe
# This does not yet have a unique index
es = es.entity_from_dataframe(entity_id = 'payments', 
                              dataframe = payments,
                              variable_types = {'missed': ft.variable_types.Categorical},
                              make_index = True,
                              index = 'payment_id',
                              time_index = 'payment_date')
```

For this dataframe, even though `missed` is an integer, this is not a [numeric variable](https://socratic.org/questions/what-is-a-numerical-variable-and-what-is-a-categorical-variable) since it can only take on 2 discrete values, so we tell featuretools to treat is as a categorical variable. After adding the dataframes to the entityset, we inspect any of them:

![](https://cdn-images-1.medium.com/max/800/1*DZ44KuggN_4jWKwuhrpCaw.png)

The column types have been correctly inferred with the modification we specified. Next, we need to specify how the tables in the entityset are related.

#### 表关系

The best way to think of a **relationship** between two tables is the [analogy of parent to child](https://stackoverflow.com/questions/7880921/what-is-a-parent-table-and-a-child-table-in-database). This is a one-to-many relationship: each parent can have multiple children. In the realm of tables, a parent table has one row for every parent, but the child table may have multiple rows corresponding to multiple children of the same parent.

For example, in our dataset, the `clients` dataframe is a parent of the `loans` dataframe. Each client has only one row in `clients` but may have multiple rows in `loans`. Likewise, `loans` is the parent of `payments` because each loan will have multiple payments. The parents are linked to their children by a shared variable. When we perform aggregations, we group the child table by the parent variable and calculate statistics across the children of each parent.

To [formalize a relationship in featuretools](https://docs.featuretools.com/loading_data/using_entitysets.html#adding-a-relationship), we only need to specify the variable that links two tables together. The `clients` and the `loans` table are linked via the `client_id` variable and `loans` and `payments` are linked with the `loan_id`. The syntax for creating a relationship and adding it to the entityset are shown below:

```
# Relationship between clients and previous loans
r_client_previous = ft.Relationship(es['clients']['client_id'],
                                    es['loans']['client_id'])

# Add the relationship to the entity set
es = es.add_relationship(r_client_previous)

# Relationship between previous loans and previous payments
r_payments = ft.Relationship(es['loans']['loan_id'],
                                      es['payments']['loan_id'])

# Add the relationship to the entity set
es = es.add_relationship(r_payments)

es
```

![](https://cdn-images-1.medium.com/max/800/1*W_jS8Z4Ym5zAFTdjHki1ig.png)

The entityset now contains the three entities (tables) and the relationships that link these entities together. After adding entities and formalizing relationships, our entityset is complete and we are ready to make features.

#### 特征基元

Before we can quite get to deep feature synthesis, we need to understand [feature primitives](https://docs.featuretools.com/automated_feature_engineering/primitives.html). We already know what these are, but we have just been calling them by different names! These are simply the basic operations that we use to form new features:

*   Aggregations: operations completed across a parent-to-child (one-to-many) relationship that group by the parent and calculate stats for the children. An example is grouping the `loan` table by the `client_id` and finding the maximum loan amount for each client.
*   Transformations: operations done on a single table to one or more columns. An example is taking the difference between two columns in one table or taking the absolute value of a column.

New features are created in featuretools using these primitives either by themselves or stacking multiple primitives. Below is a list of some of the feature primitives in featuretools (we can also [define custom primitives](https://docs.featuretools.com/guides/advanced_custom_primitives.html)):

![](https://cdn-images-1.medium.com/max/800/1*_p-HwN54IjLvmSSlkkazUQ.png)

Feature Primitives

These primitives can be used by themselves or combined to create features. To make features with specified primitives we use the `ft.dfs` function (standing for deep feature synthesis). We pass in the `entityset`, the `target_entity` , which is the table where we want to add the features, the selected `trans_primitives` (transformations), and `agg_primitives` (aggregations):

```
# Create new features using specified primitives
features, feature_names = ft.dfs(entityset = es, target_entity = 'clients', 
                                 agg_primitives = ['mean', 'max', 'percent_true', 'last'],
                                 trans_primitives = ['years', 'month', 'subtract', 'divide'])
```

The result is a dataframe of new features for each client (because we made clients the `target_entity`). For example, we have the month each client joined which is a transformation feature primitive:

![](https://cdn-images-1.medium.com/max/800/1*gEQkpyTDxXz21_gUPeNlMQ.png)

We also have a number of aggregation primitives such as the average payment amounts for each client:

![](https://cdn-images-1.medium.com/max/800/1*7aOkE5N-WCNQHJi1qBcqjQ.png)

Even though we specified only a few feature primitives, featuretools created many new features by combining and stacking these primitives.

![](https://cdn-images-1.medium.com/max/800/1*q24CTYC4x7fHj0YFwdusoQ.png)

The complete dataframe has 793 columns of new features!

#### 深度特征合成

We now have all the pieces in place to understand deep feature synthesis (dfs). In fact, we already performed dfs in the previous function call! A deep feature is simply a feature made of stacking multiple primitives and dfs is the name of process that makes these features. The depth of a deep feature is the number of primitives required to make the feature.

For example, the `MEAN(payments.payment_amount)` column is a deep feature with a depth of 1 because it was created using a single aggregation. A feature with a depth of two is `LAST(loans(MEAN(payments.payment_amount))` This is made by stacking two aggregations: LAST (most recent) on top of MEAN. This represents the average payment size of the most recent loan for each client.

![](https://cdn-images-1.medium.com/max/800/1*y28-ibs-ZCpCvavVPmmZAw.png)

We can stack features to any depth we want, but in practice, I have never gone beyond a depth of 2. After this point, the features are difficult to interpret, but I encourage anyone interested to try [“going deeper”](http://knowyourmeme.com/memes/we-need-to-go-deeper).

* * *

We do not have to manually specify the feature primitives, but instead can let featuretools automatically choose features for us. To do this, we use the same `ft.dfs` function call but do not pass in any feature primitives:

```
# Perform deep feature synthesis without specifying primitives
features, feature_names = ft.dfs(entityset=es, target_entity='clients', 
                                 max_depth = 2)

features.head()
```

![](https://cdn-images-1.medium.com/max/800/1*tewxbRVcXb_weoy_g6EfkA.png)

Featuretools has built many new features for us to use. While this process does automatically create new features, it will not replace the data scientist because we still have to figure out what to do with all these features. For example, if our goal is to predict whether or not a client will repay a loan, we could look for the features most correlated with a specified outcome. Moreover, if we have domain knowledge, we can use that to choose specific feature primitives or [seed deep feature synthesis](https://docs.featuretools.com/guides/tuning_dfs.html) with candidate features.

#### 接下来的步骤

Automated feature engineering has solved one problem, but created another: too many features. Although it’s difficult to say before fitting a model which of these features will be important, it’s likely not all of them will be relevant to a task we want to train our model on. Moreover, [having too many features](https://pdfs.semanticscholar.org/a83b/ddb34618cc68f1014ca12eef7f537825d104.pdf) can lead to poor model performance because the less useful features drown out those that are more important.

The problem of too many features is known as the [curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality#Machine_learning). As the number of features increases (the dimension of the data grows) it becomes more and more difficult for a model to learn the mapping between features and targets. In fact, the amount of data needed for the model to perform well [scales exponentially with the number of features](https://stats.stackexchange.com/a/65380/157316).

The curse of dimensionality is combated with [feature reduction (also known as feature selection)](https://machinelearningmastery.com/an-introduction-to-feature-selection/): the process of removing irrelevant features. This can take on many forms: Principal Component Analysis (PCA), SelectKBest, using feature importances from a model, or auto-encoding using deep neural networks. However, [feature reduction](https://en.wikipedia.org/wiki/Feature_selection) is a different topic for another article. For now, we know that we can use featuretools to create numerous features from many tables with minimal effort!

### 结论

Like many topics in machine learning, automated feature engineering with featuretools is a complicated concept built on simple ideas. Using concepts of entitysets, entities, and relationships, featuretools can perform deep feature synthesis to create new features. Deep feature synthesis in turn stacks feature primitives — **aggregations,** which act across a one-to-many relationship between tables, and **transformations,** functions applied to one or more columns in a single table — to build new features from multiple tables.

In future articles, I’ll show how to use this technique on a real world problem, the [Home Credit Default Risk competition](https://www.kaggle.com/c/home-credit-default-risk) currently being hosted on Kaggle. Stay tuned for that post, and in the meantime, read [this introduction to get started](https://towardsdatascience.com/machine-learning-kaggle-competition-part-one-getting-started-32fb9ff47426) in the competition! I hope that you can now use automated feature engineering as an aid in a data science pipeline. Our models are only as good as the data we give them, and automated feature engineering can help to make the feature creation process more efficient.

要获取更多关于特征工具的信息，包括这些工具的高级用法，可以查阅[在线文档](https://docs.featuretools.com/)。要查看特征工具如何在实践中应用，可以参见 [Feature Labs 的工作成果](https://www.featurelabs.com/)，这是一个开源库背后的公司。

我一如既往地欢迎各位的反馈和建设性的批评，你们可以在 Twitter [@koehrsen_will](http://twitter.com/koehrsen_will) 上与我进行交流。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
