
  > * 原文地址：[Using Machine Learning to Predict Value of Homes On Airbnb](https://medium.com/airbnb-engineering/using-machine-learning-to-predict-value-of-homes-on-airbnb-9272d3d4739d)
  > * 原文作者：[Robert Chang](https://medium.com/@rchang)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-machine-learning-to-predict-value-of-homes-on-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-machine-learning-to-predict-value-of-homes-on-airbnb.md)
  > * 译者：[lsvih](httpsL//github.com/lsvih)
  > * 校对者：[TobiasLee](https://github.com/TobiasLee), [RichardLeeH](https://github.com/RichardLeeH), [reid3290](https://github.com/reid3290)

# 在 Airbnb 使用机器学习预测房源的价格

![](https://cdn-images-1.medium.com/max/2000/1*jdUbWGwyIyJJ4wlr1FaSqA.png)

**位于希腊爱琴海伊莫洛维里的一个 Airbnb 民宿的美好风景**

### 简介

数据产品一直是 Airbnb 服务的重要组成部分，不过我们很早就意识到开发一款数据产品的成本是很高的。例如，个性化搜索排序可以让客户更容易发现中意的房屋，智能定价可以让房东设定更具竞争力的价格。然而，需要许多数据科学家和工程师付出许多时间和精力才能做出这些产品。

最近，Airbnb 机器学习的基础架构进行了改进，使得部署新的机器学习模型到生产环境中的成本降低了许多。例如，我们的 ML Infra 团队构建了一个通用功能库，这个库让用户可以在他们的模型中应用更多高质量、经过筛选、可复用的特征。数据科学家们也开始将一些自动化机器学习工具纳入他们的工作流中，以加快模型选择的速度以及提高性能标准。此外，ML Infra 还创建了一个新的框架，可以自动将 Jupyter notebook 转换成 Airflow pipeline 能接受的格式。

在本文中，我将介绍这些工具是如何协同运作来加快建模速度，从而降低开发 LTV 模型（预测 Airbnb 民宿价格）总体成本的。

### 什么是 LTV？

LTV 全称 Customer Lifetime Value，意为“客户终身价值”，是电子商务、市场公司中很流行的一种概念。它定义了在未来一个时间段内用户预期为公司带来的收益，通常以美元为单位。

在一些例如 Spotify 或者 Netflix 之类的电子商务公司里，LTV 通常用于制定产品定价（例如订阅费等）。而在 Airbnb 之类的市场公司里，知晓用户的 LTV 将有助于我们更有效地分配营销渠道的预算，更明确地根据关键字做在线营销报价，以及做更好的类目细分。

我们可以根据过去的数据来[计算历史值](https://medium.com/swlh/diligence-at-social-capital-part-3-cohorts-and-revenue-ltv-ab65a07464e1)，当然也可以进一步使用机器学习来预测新登记房屋的 LTV。

### LTV 模型的机器学习工作流

数据科学家们通常比较熟悉和机器学习任务相关的东西，例如特征工程、原型制作、模型选择等。然而，要将一个模型原型投入生产环境中需要的是一系列数据工程技术，他们可能对此不太熟练。

![](https://cdn-images-1.medium.com/max/1600/1*zT1gNPErRqizxlngxXCtBA.png)

不过幸运的是，我们有相关的机器学习工具，可以将具体的生产部署工作流从机器学习模型的分析建立中分离出来。如果没有这些神奇的工具，我们就无法轻松地将模型应用于生产环境。下面将通过 4 个主题来分别介绍我们的工作流以及各自用到的工具：

- **特征工程**：定义相关特征
- **原型设计与训练**：训练一个模型原型
- **模型选择与验证**：选择模型以及调参
- **生产部署**：将选择好的模型原型投入生产环境使用

### 特征工程

> **使用工具：Airbnb 内部特征库 — Zipline**

任何监督学习项目的第一步都是去找到会影响到结果的相关特征，这一个过程被称为特征工程。例如在预测 LTV 时，特征可以是某个房源房屋在接下来 180 天内的可使用天数所占百分比，或者也可以是其与同市场其它房屋定价的差异。

在 Airbnb 中，要做特征工程一般得从头开始写 Hive 查询语句来创建特征。但是这个工作相当无聊，而且需要花费很多时间。因为它需要一些特定的领域知识和业务逻辑，也因此这些特征 pipeline 并不容易共享或复用。为了让这项工作更具可扩展性，我们开发了 **Zipline** —— 一个训练特征库。它可以提供不同粒度级别（例如房主、客户、房源房屋及市场级别）的特征。

这个内部工具“**多源共享**”的特性让数据科学家们可以在过去的项目中找出大量高质量、经过审查的特征。如果没有找到希望提取的特征，用户也可以写一个配置文件来创建他自己需要的特征：

```
source: {
  type: hive
  query:"""
    SELECT
        id_listing as listing
      , dim_city as city
      , dim_country as country
      , dim_is_active as is_active
      , CONCAT(ds, ' 23:59:59.999') as ts
    FROM
      core_data.dim_listings
    WHERE
      ds BETWEEN '{{ start_date }}' AND '{{ end_date }}'
  """
  dependencies: [core_data.dim_listings]
  is_snapshot: true
  start_date: 2010-01-01
}
features: {
  city: "City in which the listing is located."
  country: "Country in which the listing is located."
  is_active: "If the listing is active as of the date partition."
}
```

在构建训练集时，Zipline 将会找出训练集所需要的特征，自动的按照 key 将特征组合在一起并填充数据。在构造房源 LTV 模型时，我们使用了一些 Zipline 中已经存在的特征，还自己写了一些特征。模型总共使用了 150 多个特征，其中包括：

- **位置**：国家、市场、社区以及其它地理特征
- **价格**：过夜费、清洁费、与相似房源的价格差异
- **可用性**：可过夜的总天数，以及房主手动关闭夜间预订的占比百分数
- **是否可预订**：预订数量及过去 X 天内在夜间订房的数量
- **质量**：评价得分、评价数量、便利设施

![](https://cdn-images-1.medium.com/max/1600/1*KYs7WNNfdwKmKcVbgKGkiw.png)

实例数据集

在定义好特征以及输出变量之后，就可以根据我们的历史数据来训练模型了。

### 原型设计与训练

> **使用工具：Python 机器学习库** — [**scikit-learn**](http://scikit-learn.org/stable/)

以前面的训练集为例，我们在做训练前先要对数据进行一些预处理：

- **数据插补**：我们需要检查是否有数据缺失，以及它是否为随机出现的缺失。如果不是随机现象，我们需要弄清楚其根本原因；如果是随机缺失，我们需要填充空缺数据。
- **对分类进行编码**：通常来说我们不能在模型里直接使用原始的分类，因为模型并不能去拟合字符串。当分类数量比较少时，我们可以考虑使用 [one-hot encoding](http://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html) 进行编码。如果分类数量比较多，我们就会考虑使用 [ordinal encoding](https://www.kaggle.com/general/16927), 按照分类的频率计数进行编码。

在这一步中，我们还不知道最有效的一组特征是什么，因此编写可快速迭代的代码是非常重要的。如 [Scikit-Learn](http://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html)、[Spark](https://spark.apache.org/docs/latest/ml-pipeline.html) 等开源工具的 pipeline 结构对于原型构建来说是非常方便的工具。Pipeline 可以让数据科学家们设计蓝图，指定如何转换特征、训练哪一个模型。更具体来说，可以看下面我们 LTV 模型的 pipeline：

```
transforms = []

transforms.append(
    ('select_binary', ColumnSelector(features=binary))
)

transforms.append(
    ('numeric', ExtendedPipeline([
        ('select', ColumnSelector(features=numeric)),
        ('impute', Imputer(missing_values='NaN', strategy='mean', axis=0)),
    ]))
)

for field in categorical:
    transforms.append(
        (field, ExtendedPipeline([
            ('select', ColumnSelector(features=[field])),
            ('encode', OrdinalEncoder(min_support=10))
            ])
        )
    )

features = FeatureUnion(transforms)
```

在高层设计时，我们使用 pipeline 来根据特征类型（如二进制特征、分类特征、数值特征等）来指定不同特征中数据的转换方式。最后使用 [FeatureUnion](http://scikit-learn.org/stable/modules/generated/sklearn.pipeline.FeatureUnion.html) 简单将特征列组合起来，形成最终的训练集。

使用 pipeline 开发原型的优势在于，它可以使用 [data transforms](http://scikit-learn.org/stable/data_transforms.html) 来避免繁琐的数据转换。总的来说，这些转换是为了确保数据在训练和评估时保持一致，以避免将原型部署到生产环境时出现的数据不一致。

另外，pipeline 还可以将数据转换过程和训练模型过程分开。虽然上面代码中没有，但数据科学家可以在最后一步指定一种 [estimator（估值器）](http://scikit-learn.org/stable/tutorial/machine_learning_map/index.html)来训练模型。通过尝试使用不同的估值器，数据科学家可以为模型选出一个表现最佳的估值器，减少模型的样本误差。

### 模型选择与验证

> **使用工具：各种**[**自动机器学习**](https://medium.com/airbnb-engineering/automated-machine-learning-a-paradigm-shift-that-accelerates-data-scientist-productivity-airbnb-f1f8a10d61f8)**框架**

如上一节所述，我们需要确定候选模型中的哪个最适合投入生产。为了做这个决策，我们需要在模型的可解释性与复杂度中进行权衡。例如，稀疏线性模型的解释性很好，但它的复杂度太低了，不能很好地运作。一个足够复杂的树模型可以拟合各种非线性模式，但是它的解释性很差。这种情况也被称为[**偏差（Bias）和方差（Variance）的权衡**](http://scott.fortmann-roe.com/docs/BiasVariance.html)。

![](https://cdn-images-1.medium.com/max/1600/1*tQbBEq6T8ZJ9lFSCbZKFqw.png)

上图引用自 James、Witten、Hastie、Tibshirani 所著《R 语言统计学习》

在保险、信用审查等应用中，需要对模型进行解释。因为对模型来说避免无意排除一些正确客户是很重要的事。不过在图像分类等应用中，模型的高性能比可解释更重要。

由于模型的选择相当耗时，我们选择采用各种[自动机器学习](https://medium.com/airbnb-engineering/automated-machine-learning-a-paradigm-shift-that-accelerates-data-scientist-productivity-airbnb-f1f8a10d61f8)工具来加速这个步骤。通过探索大量的模型，我们最终会找到表现最好的模型。例如，我们发现 [XGBoost](https://github.com/dmlc/xgboost) (XGBoost) 明显比其他基准模型（比如 mean response 模型、岭回归模型、单一决策树）的表现要好。

![](https://cdn-images-1.medium.com/max/1600/1*y1O7nIxCFmgQamCfsrWfjA.png)

上图：我们通过比较 RMSE 可以选择出表现更好的模型

鉴于我们的最初目标是预测房源价格，因此我们很舒服地在最终的生产环境中使用 XGBoost 模型，比起可解释性它更注重于模型的弹性。

### 生产部署

> **使用工具：Airbnb 自己写的 notebook 转换框架 — ML Automator**

如开始所说，构建生产环境工作流和在笔记本上构建一个原型是完全不同的。例如，我们如何进行定期的重训练？我们如何有效地评估大量的实例？我们如何建立一个 pipeline 以随时监视模型性能？

在 Airbnb，我们自己开发了一个名为 **ML Automator** 的框架，它可以自动将 Jupyter notebook 转换为 [Airflow](https://medium.com/airbnb-engineering/airflow-a-workflow-management-platform-46318b977fd8) 机器学习 pipeline。该框架专为熟悉使用 Python 开发原型，但缺乏将模型投入生产环境经验的数据科学家准备。

![](https://cdn-images-1.medium.com/max/1600/1*uLCH5Ozfj8mM07bKXIg20Q.png)

ML Automator 框架概述（照片来源：Aaron Keys）

- 首先，框架要求用户在 notebook 中指定模型的配置。该配置将告诉框架如何定位训练数据表，为训练分配多少计算资源，以及如何计算模型评价分数。
- 另外，数据科学家需要自己写特定的 **fit** 与 **transform** 函数。fit 函数指定如何进行训练，而 transform 函数将被 Python UDF 封装，进行分布式计算（如果有需要）。

下面的代码片段展示了我们 LTV 模型中的 **fit** 与 **transform** 函数。fit 函数告诉框架需要训练 XGBoost 模型，同时转换器将根据我们之前定义的 pipeline 转换数据。

```
def fit(X_train, y_train):
    import multiprocessing
    from ml_helpers.sklearn_extensions import DenseMatrixConverter
    from ml_helpers.data import split_records
    from xgboost import XGBRegressor

    global model

    model = {}
    n_subset = N_EXAMPLES
    X_subset = {k: v[:n_subset] for k, v in X_train.iteritems()}
    model['transformations'] = ExtendedPipeline([
                ('features', features),
                ('densify', DenseMatrixConverter()),
            ]).fit(X_subset)

    # 并行使用转换器
    Xt = model['transformations'].transform_parallel(X_train)

    # 并行进行模型拟合
    model['regressor'] = XGBRegressor().fit(Xt, y_train)

def transform(X):
    # return dictionary
    global model
    Xt = model['transformations'].transform(X)
    return {'score': model['regressor'].predict(Xt)}
```

一旦 notebook 完成，ML Automator 将会把训练好的模型包装在 [Python UDF](http://www.florianwilhelm.info/2016/10/python_udf_in_hive/) 中，并创建一个如下图所示的 [Airflow](https://airflow.incubator.apache.org/) pipeline。数据序列化、定期重训练、分布式评价等数据工程任务都将被载入到日常批处理作业中。因此，这个框架显著降低了数据科学家将模型投入生产的成本，就像有一位数据工程师在与科学家一起工作一样！

![](https://cdn-images-1.medium.com/max/1600/1*DvPE_V_SoHV3pikOqiZxsg.png)

我们 LTV 模型在 Airflow DAG 中的图形界面，运行于生产环境中

**Note：除了模型生产化之外，还有一些其它项目（例如跟踪模型随着时间推移的性能、使用弹性计算环境建模等）我们没有在这篇文章中进行介绍。这些都是正在进行开发的热门领域。**

### 经验与展望

过去的几个月中，我们的数据科学家们与 ML Infra 密切合作，产生了许多很好的模式和想法。我们相信这些工具将会为 Airbnb 开发机器学习模型开辟新的范例。

- **首先，显著地降低了模型的开发成本**：通过组合各种不同的独立工具的优点（Zipline 用于特征工程、Pipeline 用于模型原型设计、AutoML 用于模型选择与验证，以及最后的 ML Automator 用于模型生产化），我们大大减短了模型的开发周期。
- **其次，notebook 的设计降低了入门门槛**：还不熟悉框架的数据科学家可以立即得到大量的真实用例。在生产环境中，可以确保 notebook 是正确、自解释、最新的。这种设计模式受到了新用户的好评。
- **因此，团队将更愿意关注机器学习产品的 idea**：在本文撰写时，我们还有其它几支团队在采用类似的方法探索机器学习产品的 idea：为检查房源队列进行排序、预测房源是否会增加合伙人、自动标注低质量房源等等。

我们对这个框架和它带来的新范式的未来感到无比的兴奋。通过缩小原型与生产环境间的差距，我们可以让数据科学家和数据工程师更多去追求端到端的机器学习项目，让我们的产品做得更好。

---

**想使用或者一起开发这些机器学习工具吗？我们正在寻找 **[**能干的你加入我们的数据科学与分析团队**](https://www.airbnb.com/careers/departments/data-science-analytics)**！**

---

**特别感谢参与这项工作的Data Science＆ML Infra团队的成员：**[*Aaron Keys*](https://www.linkedin.com/in/aaronkeys/)*, *[*Brad Hunter*](https://www.linkedin.com/in/brad-hunter-497621a/)*, *[*Hamel Husain*](https://www.linkedin.com/in/hamelhusain/)*, *[*Jiaying Shi*](https://www.linkedin.com/in/jiaying-shi-a2142733/)*, *[*Krishna Puttaswamy*](https://www.linkedin.com/in/krishnaputtaswamy/)*, *[*Michael Musson*](https://www.linkedin.com/in/michael-m-a37b1932/)*, *[*Nick Handel*](https://www.linkedin.com/in/nicholashandel/)*, *[*Varant Zanoyan*](https://www.linkedin.com/in/vzanoyan/)*, *[*Vaughn Quoss*](https://www.linkedin.com/in/vquoss/)* 等人。另外感谢 *[*Gary Tang*](https://www.linkedin.com/in/thegarytang/)*, *[*Jason Goodman*](https://medium.com/@jasonkgoodman)*, *[*Jeff Feng*](https://twitter.com/jtfeng)*, *[*Lindsay Pettingill*](https://medium.com/@lpettingill)* 给本文提的意见。*


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
