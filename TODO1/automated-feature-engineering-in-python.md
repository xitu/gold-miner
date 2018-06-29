> * 原文地址：[Automated Feature Engineering in Python](https://towardsdatascience.com/automated-feature-engineering-in-python-99baf11cc219)
> * 原文作者：[William Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/automated-feature-engineering-in-python.md)
> * 译者：[mingxing47](https://github.com/mingxing47)
> * 校对者：

# Python 中的自动特征工程

## 如何自动化地创建机器学习特征

![](https://cdn-images-1.medium.com/max/1000/1*lg3OxWVYDsJFN-snBY7M5w.jpeg)

Machine learning is increasingly moving from hand-designed models to automatically optimized pipelines using tools such as [H20](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html), [TPOT](https://epistasislab.github.io/tpot/), and [auto-sklearn](https://automl.github.io/auto-sklearn/stable/). These libraries, along with methods such as [random search](http://www.jmlr.org/papers/volume13/bergstra12a/bergstra12a.pdf), aim to simplify the model selection and tuning parts of machine learning by finding the best model for a dataset with little to no manual intervention. However, feature engineering, an [arguably more valuable aspect](https://www.featurelabs.com/blog/secret-to-data-science-success/) of the machine learning pipeline, remains almost entirely a human labor.机器学习正在利用诸如 [H20](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html), [TPOT](https://epistasislab.github.io/tpot/) 和 [auto-sklearn](https://automl.github.io/auto-sklearn/stable/) 等工具越来越多地从手工设计模型向自动化优化管道迁移。

[Feature engineering](https://en.wikipedia.org/wiki/Feature_engineering), also known as feature creation, is the process of constructing new features from existing data to train a machine learning model. This step can be more important than the actual model used because a machine learning algorithm only learns from the data we give it, and creating features that are relevant to a task is absolutely crucial (see the excellent paper [“A Few Useful Things to Know about Machine Learning”](https://homes.cs.washington.edu/~pedrod/papers/cacm12.pdf)).

Typically, feature engineering is a drawn-out manual process, relying on domain knowledge, intuition, and data manipulation. This process can be extremely tedious and the final features will be limited both by human subjectivity and time. Automated feature engineering aims to help the data scientist by automatically creating many candidate features out of a dataset from which the best can be selected and used for training.

In this article, we will walk through an example of using automated feature engineering with the [featuretools Python library](https://docs.featuretools.com/#). We will use an example dataset to show the basics (stay tuned for future posts using real-world data). The complete code for this article is [available on GitHub](https://github.com/WillKoehrsen/automated-feature-engineering/blob/master/walk_through/Automated_Feature_Engineering.ipynb).

* * *

### 特征工程基础

[Feature engineering](https://www.datacamp.com/community/tutorials/feature-engineering-kaggle) means building additional features out of existing data which is often spread across multiple related tables. Feature engineering requires extracting the relevant information from the data and getting it into a single table which can then be used to train a machine learning model.

The process of constructing features is very time-consuming because each new feature usually requires several steps to build, especially when using information from more than one table. We can group the operations of feature creation into two categories: **transformations** and **aggregations**. Let’s look at a few examples to see these concepts in action.

A **transformation** acts on a single table (thinking in terms of Python, a table is just a Pandas `DataFrame` ) by creating new features out of one or more of the existing columns. As an example, if we have the table of clients below

![](https://cdn-images-1.medium.com/max/800/1*FHR7tlD4FuGKt8n5UHUpqw.png)

we can create features by finding the month of the `joined` column or taking the natural log of the `income` column. These are both transformations because they use information from only one table.

![](https://cdn-images-1.medium.com/max/800/1*QQGYN1PD06rNT-bJphNcBA.png)

On the other hand, **aggregations** are performed across tables, and use a one-to-many relationship to group observations and then calculate statistics. For example, if we have another table with information on the loans of clients, where each client may have multiple loans, we can calculate statistics such as the average, maximum, and minimum of loans for each client.

This process involves grouping the loans table by the client, calculating the aggregations, and then merging the resulting data into the client data. Here’s how we would do that in Python using the [language of Pandas](https://pandas.pydata.org/pandas-docs/stable/index.html).

```
import pandas as pd

# Group loans by client id and calculate mean, max, min of loans
stats = loans.groupby('client_id')['loan_amount'].agg(['mean', 'max', 'min'])
stats.columns = ['mean_loan_amount', 'max_loan_amount', 'min_loan_amount']

# Merge with the clients dataframe
stats = clients.merge(stats, left_on = 'client_id', right_index=True, how = 'left')

stats.head(10)
```

![](https://cdn-images-1.medium.com/max/800/1*jHHOuEft93KDenbRpaFcnA.png)

These operations are not difficult by themselves, but if we have hundreds of variables spread across dozens of tables, this process is not feasible to do by hand. Ideally, we want a solution that can automatically perform transformations and aggregations across multiple tables and combine the resulting data into a single table. Although Pandas is a great resource, there’s only so much data manipulation we want to do by hand! (For more on manual feature engineering check out the excellent [Python Data Science Handbook](https://jakevdp.github.io/PythonDataScienceHandbook/05.04-feature-engineering.html)).

### Featuretools 框架

Fortunately, featuretools is exactly the solution we are looking for. This open-source Python library will automatically create many features from a set of related tables. Featuretools is based on a method known as “[Deep Feature Synthesis](http://featurelabs1.wpengine.com/wp-content/uploads/2017/12/DSAA_DSM_2015-1.pdf)”, which sounds a lot more imposing than it actually is (the name comes from stacking multiple features not because it uses deep learning!).

Deep feature synthesis stacks multiple transformation and aggregation operations (which are called [feature primitives](https://docs.featuretools.com/automated_feature_engineering/primitives.html) in the vocab of featuretools) to create features from data spread across many tables. Like most ideas in machine learning, it’s a complex method built on a foundation of simple concepts. By learning one building block at a time, we can form a good understanding of this powerful method.

First, let’s take a look at our example data. We already saw some of the dataset above, and the complete collection of tables is as follows:

*   `clients` : basic information about clients at a credit union. Each client has only one row in this dataframe

![](https://cdn-images-1.medium.com/max/800/1*FHR7tlD4FuGKt8n5UHUpqw.png)

*   `loans`: loans made to the clients. Each loan has only own row in this dataframe but clients may have multiple loans.

![](https://cdn-images-1.medium.com/max/1000/1*95c7QchQVM-9xUUA4ZB4XQ.png)

*   `payments`: payments made on the loans. Each payment has only one row but each loan will have multiple payments.

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
