> * 原文地址：[Visualising Machine Learning Datasets with Google’s FACETS.](https://towardsdatascience.com/visualising-machine-learning-datasets-with-googles-facets-462d923251b3)
> * 原文作者：[Parul Pandey](https://medium.com/@parulnith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/visualising-machine-learning-datasets-with-googles-facets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/visualising-machine-learning-datasets-with-googles-facets.md)
> * 译者：[QiaoN](https://github.com/QiaoN)
> * 校对者：[lsvih](https://github.com/lsvih), [Mcskiller](https://github.com/Mcskiller)

# 使用谷歌 FACETS 可视化机器学习数据集

> FACETS 是谷歌的一个开源工具，可以轻松的从大量数据中学习模式

![摄影：[Franki Chamaki](https://unsplash.com/@franki?utm_source=medium&utm_medium=referral)，出自[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*AAAs7V238jAuaZp_)

> 大量数据比好的算法更有用，但好的数据比大量数据更有用：Peter Norvig

关于大量的训练数据如何对机器学习模型的结果产生巨大的影响，已经有很多的讨论。然而，随着数据量的增加，要构建一个强大且健壮的机器学习系统，数据质量也非常关键。毕竟“输入糟粕，输出糟粕”，也就是说，你从系统中得到的东西会体现出你提供给系统的东西。

一个机器学习数据集有时包含数千到数百万的数据点，而它们可能包含成百上千个特征。此外，现实世界的数据很混乱，会有缺失值、不均衡数据、异常值等。因此，在进行模型构建之前，我们必须清理数据。可视化数据有助于找到这些离群点并定位需要清理的数据。数据可视化提供了整体数据概览（无论数据量多大），有助于快速准确的进行 EDA（探索性数据分析）。

---

## FACETS

![](https://cdn-images-1.medium.com/max/2168/1*3tUB6KRfE-FapwbH4Lz0Vg.png)

在字典里 facet 意为某种特殊方面或某物的特征。同样，[**FACETS**](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html) 工具让我们无需明确编码即可理解并探索数据的各项特征。

Facets 是谷歌为了支持 [**PAIR**](https://ai.google/research/teams/brain/pair) **\(People + AI Research\)** 项目而发布的一个开源可视化工具，可以帮助我们理解和分析机器学习数据集。Facets 包括两个可视化部分，这两部分均可深入挖掘数据并带来好的洞察，而无需在用户端进行大量工作。

* **Facets Overview**

顾名思义，此可视化部分提供了整个数据集的概览和数据每项特征的分布情况。Facets Overview 总结了每项特征的统计量并比较了训练和测试数据集。

* **Facets Dive**

此功能可帮助用户深入理解数据的单个特征，并通过观察单个特征获取更多信息。它有助于一次性交互式地探索大量数据点。

> 这些可视化由 [Typescript](https://www.typescriptlang.org/) 编写的 [Polymer](https://www.polymer-project.org/) Web 组件实现，能够轻易嵌入 Jupyter Notebook 或是 Web 页面中。

---

## 使用 & 安装

使用 FACETS 处理数据有两种方式：

#### Web 应用

它可以直接在下面链接里的演示页面中使用：

[**Facets —— 机器学习数据集的可视化**](https://pair-code.github.io/facets/)

该网站允许任何人直接在浏览器中可视化他们自己的数据集，而无需安装或设置任何软件，并且你的数据不会被上传。

#### 在 Jupyter Notebooks/Colaboratory 中

FACETS 也可以在 Jupyter Notebook 或 Colaboratoty 中使用。这可以更灵活的在同一个 notebook 中完成整个 EDA 和建模。有关安装的完整细节，请参阅官方 [Github 仓库](https://github.com/pair-code/facets#setup)。不过，在下文中我们将介绍如何在 colab 中使用 FACETS。

---

## 数据

虽然你可以用演示页面上提供的数据，但我打算用另一组数据。我将用 FACETS 对**贷款预测数据集**进行 EDA。 问题陈述是预测一个已获得公司贷款的申请人是否会偿还贷款。这是机器学习社区中的一个非常知名的例子。

[**这里**](https://github.com/parulnith/Data-Visualisation-Tools/tree/master/Data%20Visualisation%20with%20Facets%20)是已经分为训练集和测试集的**数据集**。让我们将数据加载到 Colab 中。

```python
import pandas as pd
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
```

现在让我们来了解如何将 Facets Overview 用于此数据。

#### FACETS Overview

Overview 自动的让用户快速了解数据各项特征值的分布情况。也可以立刻在训练集和测试集中比较分布情况。如果数据中存在某些异常，它便会从异常数据的位置弹出。

通过此功能可以轻松得到的一些信息如下：

* 统计数据如均值、中位数和标准差
* 列的最小值和最大值
* 缺失数据
* 有零值的值
* 由于还可以查看测试数据集的分布，我们可以轻松确认训练数据和测试数据是否遵循相同的分布。

> 有人会说我们可以轻松地用 Pandas 来完成这些任务，为什么要投入到另一个工具呢？没错，当我们只有少量的特征很少的数据点时，可能不需要这样做。然而，情况在我们面对大型数据集时会有所不同，很难用 Pandas 分析多列中的每一个数据点。

Google Colaboaratory 将 FACETS 变得易于使用，因为我们不需要额外的安装，只用编写几行代码就好。

```
# Clone the facets github repo to get access to the python feature stats generation code
!git clone https://github.com/pair-code/facets.git
```

要计算出特征的统计量，我们需要用 Python 脚本中的函数 GenericFeatureStatisticsGenerator()。

```python
# Add the path to the feature stats generation code.
import sys
sys.path.insert(0, '/content/facets/facets_overview/python/')

# Create the feature stats for the datasets and stringify it.
import base64
from generic_feature_statistics_generator import GenericFeatureStatisticsGenerator

gfsg = GenericFeatureStatisticsGenerator()
proto = gfsg.ProtoFromDataFrames([{'name': 'train', 'table': train},
                                  {'name': 'test', 'table': test}])
protostr = base64.b64encode(proto.SerializeToString()).decode("utf-8")
```

现在用下面的代码，我们可以轻松的在 notebook 中显示出可视化。

```python
# Display the facets overview visualization for this data
from IPython.core.display import display, HTML

HTML_TEMPLATE = """<link rel="import" href="https://raw.githubusercontent.com/PAIR-code/facets/master/facets-dist/facets-jupyter.html" >
        <facets-overview id="elem"></facets-overview>
        <script>
          document.querySelector("#elem").protoInput = "{protostr}";
        </script>"""
html = HTML_TEMPLATE.format(protostr=protostr)
display(HTML(html))
```

当你按下“Shift + Enter”，你就能看到一个漂亮的交互式可视化：

![](https://cdn-images-1.medium.com/max/2000/1*ZXS2t1A8JZDtxGsfUP3GFQ.png)

在图中，我们能看到 Facets Overview 对贷款预测数据集的五个数值特征进行了可视化。这些特征按非均匀性排序，分布最不均匀的特征排在顶部。红色数字表示可能的异常点，在这里，数值特征为 0 有很高的百分比。用右侧的柱状图你可以比较训练数据（蓝色）和测试数据（橙色）的分布情况。

![](https://cdn-images-1.medium.com/max/2000/1*0yYTqIN5Vimf_0SxxB-35w.png)

上面的可视化显示了数据集的八个分类特征之一。这些特征按分布距离排序。训练数据集（蓝色）和测试数据集（橙色）间偏差最大的特征排在顶部。

#### FACETS Dive

[Facets Dive](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html) 提供了一个直观的可定制界面，用于探索数据集内不同特征的数据点之间的关系。使用 Facets Dive，你可以根据每个数据点的特征值来控制它的位置、颜色和视觉效果。如果数据点有相关联的图像，此图像也可用在可视化中。

必须将数据转换为 JSON 格式才可使用 Dive 可视化。

```python
# Display the Dive visualization for the training data.
from IPython.core.display import display, HTML

jsonstr = train.to_json(orient='records')
HTML_TEMPLATE = """<link rel="import" href="https://raw.githubusercontent.com/PAIR-code/facets/master/facets-dist/facets-jupyter.html">
        <facets-dive id="elem" height="600"></facets-dive>
        <script>
          var data = {jsonstr};
          document.querySelector("#elem").data = data;
        </script>"""
html = HTML_TEMPLATE.format(jsonstr=jsonstr)
display(HTML(html))
```

运行代码后，你应该能看到：

![Facets Dive 可视化](https://cdn-images-1.medium.com/max/2000/1*X3BYI7oGEvlZv_CejS1wZA.png)

现在我们可以轻松进行单变量和双变量分析，让我们来看看一些获得的结果：

#### 单变量分析

这里我们将分别地查看目标变量，即 Loan_Status 和其它的分类特征如性别、婚姻状况、就业状况和信用记录。同样的，你也可以看看其它特征。

![](https://cdn-images-1.medium.com/max/2000/1*bCJ-ofkzPvhO5TuMgQ7VOw.gif)

#### 推论：

* 数据集中的大多数申请人都是男性。
* 同样的，数据集中的大多数申请人都已婚且偿还了债务。
* 此外，大多数申请人没有家属，大学毕业，来自城郊地区。

现在让我们可视化有序变量，即家属、教育和房产地区。

![](https://cdn-images-1.medium.com/max/2000/1*ufgW6M-AanfNCjWBjQ6Aig.gif)

以下推论可以从上面的条形图中得出：

* 大多数申请人没有任何家属。
* 大多数申请人是大学毕业生。
* 大多数申请人来自城郊。

现在你可以接着使用数值数据进行分析。

#### 双变量分析

我们来找找目标变量和分类自变量之间的关系。

![](https://cdn-images-1.medium.com/max/1600/1*D2Tio24GXTKIdP84duZIIQ.gif)

从上面的条形图中可以推断出：

* 已批准贷款中已婚申请人的比例较高。
* 在 Loan_Status 的两个类别中，有 1 个或 3 个以上家属的申请人具有相似的分布情况。
* 信用记录为 1 的人似乎更有可能获得贷款批准。
* 与农村或城市地区相比，在城郊获得贷款批准的比例较高。

---

## 结论

FACETS 为数据集进行 EDA 提供了一个简单直观的环境，帮助我们获得有意义的结果。唯一的问题是目前它只适用于 **Chrome**。

在结束本文之前，让我们看一个**有趣的事实**：下图体现出如何用 FACETS Dive 揪出 CIFAR-10 数据集中一个小小的人为标记错误。在分析数据集时，发现一个青蛙的图像被错误地标记为猫。这确实是一些成就，因为对人眼来说这是一项不可能完成的任务。

![](https://cdn-images-1.medium.com/max/2000/1*VfkUBpXdGNIsK_RKT-ct1Q.gif)
[原始资料](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
