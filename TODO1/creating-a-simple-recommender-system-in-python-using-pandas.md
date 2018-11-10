> * 原文地址：[Creating a Simple Recommender System in Python using Pandas](https://stackabuse.com/creating-a-simple-recommender-system-in-python-using-pandas/)
> * 原文作者：[Usman Malik](https://twitter.com/usman_malikk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-simple-recommender-system-in-python-using-pandas.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-simple-recommender-system-in-python-using-pandas.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[TrWestdoor](https://github.com/TrWestdoor)

# 使用 Pandas 在 Python 中创建一个简单的推荐系统

## 简介

你有没有想过 Netflix 如何根据你已经看过的电影向你推荐电影？或者电商网站如何显示诸如“经常一起购买”等选项？它们可能看起来只是简单的选项，但是背后执行了一套复杂的统计算法以预测这些推荐。这样的系统被称为导购系统，推荐系统或者推荐引擎。[导购系统](https://en.wikipedia.org/wiki/Recommender_system)是数据科学和机器学习领域最著名的应用之一。

推荐系统采用这样一种统计算法，该算法基于实体之间的相似性或先前评估这些实体的用户之间的相似性来预测用户对特定实体的评级。直观上来讲就是相似类型的用户可能对同一组实体具有相似的评级。

目前，许多大型科技公司都以这样或那样的方式使用推荐系统。你可以从亚马逊（产品推荐）到 YouTube（视频推荐）再到 Facebook（朋友推荐）的任何地方找到它们。给用户推荐相关产品和服务的能力对公司来说可能是一个巨大的推动力，这就是为什么此技术在众多网站中被普遍运用的原因。

在这篇文章中，我们将看到如何在 Python 中构建一个简单的推荐系统。

### 推荐系统的类型

主要有两种方式构建推荐系统：基于内容的过滤和协同过滤：

#### 基于内容过滤

在基于内容的过滤中，不同产品的相似性是根据产品的属性计算出来的。例如，在一个基于内容的电影推荐系统中，电影之间的相似性是根据类型，电影中的演员，电影导演等计算的。

#### 协同过滤

协同过滤利用人群的力量。协同过滤背后的直觉是如果 A 用户喜欢产品 X 和 Y，那么如果 B 用户喜欢产品 X，他就有相当大的可能同样喜欢产品 Y。

举一个电影推荐系统的例子。假设大量的用户对电影 X 和 Y 给出一样的评分。一个新用户来了，他对电影 X 给出了相同的评分但是还没看过电影 Y。协同过滤系统就会把电影 Y 推荐给他。

### Python 中的电影推荐系统实现

在这一节，我们将使用 Python 开发一个非常简单的电影推荐系统，它使用不同电影间的评分相关性，以便找到电影之间的相似性。

我们将用于此问题的数据集是 MovieLens 数据集。要下载此数据集，可以去数据集的[主页](https://grouplens.org/datasets/movielens/latest/)下载 "ml-latest-small.zip" 文件，它包含真实电影数据集的子集并且有 700 个用户对 9000 部电影做出的 100000 条评分。

当你解压文件后，就能看到 "links.csv"、"movies.csv"、"ratings.csv" 和 "tags.csv" 文件，以及 "README" 文档。在本文中，我们会使用到 "movies.csv" 和 "ratings.csv" 文件。

对于本文中的脚本，解压的 "ml-latest-small" 文件夹已经被放在了 "E" 盘的 "Datasets" 文件夹中。

#### 数据可视化和预处理

每个数据科学问题的第一步都是数据可视化和预处理。我们也是如此，接下来我们先导入 "ratings.csv" 文件看看它有哪些内容。执行如下脚本：

```
import numpy as np
import pandas as pd

ratings_data = pd.read_csv("E:\Datasets\ml-latest-small\\ratings.csv")
ratings_data.head()
```

在上面的脚本中，我们使用 [Pandas 库](https://stackabuse.com/beginners-tutorial-on-the-pandas-python-library/) 的 `read_csv()` 方法读取 "ratings.csv" 文件。接下来，我们调用 `read_csv()` 函数返回的 dataframe 对象的 `head()` 方法。它将展示数据集的前五行数据。

输出结果如下：

|   | userId | movieId | rating	timestamp |
|---|---|------|-----|------------|
| 0	| 1	| 31   | 2.5 | 1260759144 |
| 1	| 1	| 1029 | 3.0 | 1260759179 |
| 2	| 1	| 1061 | 3.0 | 1260759182 |
| 3	| 1	| 1129 | 2.0 | 1260759185 |
| 4	| 1	| 1172 | 4.0 | 1260759205 |

从输出结果中可以看出 "ratings.csv" 文件包含 userId、movieId、ratings 和 timestamp 属性。数据集的每一行对应一条评分。userId 列包含评分用户的 ID。movieId 列包含电影的 Id，rating 列包含用户的评分。评分的取值是 1 到 5。最后的 timestamp 代表用户做出评分的时间。

这个数据集有一个问题。那就是它有电影的 ID 却没有电影名称。我们需要我们要推荐的电影的名称。而电影名称存在 "movies.csv" 文件中。让我们导入它看看里面有什么内容吧。执行如下脚本：

```
movie_names = pd.read_csv("E:\Datasets\ml-latest-small\\movies.csv")  
movie_names.head()  
```

输出结果如下：


|   | movieId | title | genres |
|---|---------|-------|--------|
| 0 | 1	| Toy Story (1995) | `Adventure|Animation|Children|Comedy|Fantasy` |
| 1 | 2	| Jumanji (1995) | `Adventure|Children|Fantasy` |
| 2 | 3	| Grumpier Old Men (1995) | `Comedy|Romance` |
| 3 | 4	| Waiting to Exhale (1995) | `Comedy|Drama|Romance` |
| 4 | 5	| Father of the Bride Part II (1995) | `Comedy` |

如你所见，数据集包含 movieId，电影名称和它的类型。我们需要一个包含 userId，电影名称和评分的数据集。而我们需要的信息在两个不同的 dataframe 对象中："ratings_data" 和 "movie_names"。为了把我们想要的信息放在一个 dataframe 中，我们可以根据 movieId 列合并这两个 dataframe 对象，因为它在这两个 dataframe 对象中是通用的。

我们可以使用 Pandas 库的 `merge()` 函数，如下所示：

```
movie_data = pd.merge(ratings_data, movie_names, on='movieId')
```

现在我们来看看新的 dataframe：

```
movie_data.head()
```

输出结果如下：

| 	| userId | movieId | rating | timestamp | title | genres |
|---|--------|---------|--------|-----------|-------|--------|
| 0	| 1	 | 31 | 2.5 | 1260759144  | Dangerous Minds (1995)	Drama |
| 1	| 7  | 31 | 3.0 | 851868750   | Dangerous Minds (1995)	Drama |
| 2	| 31 | 31 | 4.0 | 12703541953 | Dangerous Minds (1995)	Drama |
| 3	| 32 | 31 | 4.0 | 834828440   | Dangerous Minds (1995)	Drama |
| 4 | 36 | 31 | 3.0 | 847057202   | Dangerous Minds (1995)	Drama |

我们可以看到新创建的 dataframe 正如要求的那样包含 userId，电影名称和电影评分。

现在让我们看看每部电影的平均评分。为此，我们可以按照电影的标题对数据集进行分组，然后计算每部电影评分的平均值。接下来我们将使用 `head()` 方法显示前五部电影及其平均评分。请看如下脚本：

```
movie_data.groupby('title')['rating'].mean().head()
```

输出结果如下：

```
title
"Great Performances" Cats (1998)           1.750000
$9.99 (2008)                               3.833333
'Hellboy': The Seeds of Creation (2004)    2.000000
'Neath the Arizona Skies (1934)            0.500000
'Round Midnight (1986)                     2.250000
Name: rating, dtype: float64
```

你可以看到平均评分是没有排序的。让我们按照平均评分的降序对评分进行排序：

```
movie_data.groupby('title')['rating'].mean().sort_values(ascending=False).head()
```

如果你执行了上面的脚本，输出结果应该如下所示：

```
title
Burn Up! (1991)                                     5.0
Absolute Giganten (1999)                            5.0
Gentlemen of Fortune (Dzhentlmeny udachi) (1972)    5.0
Erik the Viking (1989)                              5.0
Reality (2014)                                      5.0
Name: rating, dtype: float64
```

这些电影现已根据评分的降序排序。然而有一个问题是，如果只有一个用户对电影做了评价且分数为五星，这部电影就会排到列表的顶部。因此，上述统计数据可能具有误导性。通常来讲，一部真正的好电影会有大批用户给更高的评分。

现在让我们绘制一部电影的评分总数：

```
movie_data.groupby('title')['rating'].count().sort_values(ascending=False).head()
```

执行上面的脚本返回如下结果：

```
title
Forrest Gump (1994)                          341
Pulp Fiction (1994)                          324
Shawshank Redemption, The (1994)             311
Silence of the Lambs, The (1991)             304
Star Wars: Episode IV - A New Hope (1977)    291
Name: rating, dtype: int64
```

现在你会看到真正的好电影就排在顶部了。以上列表证实了我们的观点，好电影通常会收到更高的评分。现在我们知道每部电影的平均评分和评分数量都是重要的属性了。让我们创建一个新的包含这些属性的 dataframe。

执行如下脚本创建 `ratings_mean_count` dataframe，首先将每部电影的平均评分添加到这个 dataframe：

```
ratings_mean_count = pd.DataFrame(movie_data.groupby('title')['rating'].mean())
```

接下来，我们需要把电影的评分数添加到 `ratings_mean_count` dataframe。执行如下脚本来实现：

```
ratings_mean_count['rating_counts'] = pd.DataFrame(movie_data.groupby('title')['rating'].count())
```

现在我们再看下新创建的 dataframe。

```
ratings_mean_count.head()
```

输出结果如下：

| title	| rating | rating_counts |
|-------|--------|---------------|
| "Great Performances" Cats (1998)        | 1.750000 | 2 |
| $9.99 (2008)                            | 3.833333 | 3 |
| 'Hellboy': The Seeds of Creation (2004) | 2.000000 | 1 |
| 'Neath the Arizona Skies (1934)         | 0.500000 | 1 |
| 'Round Midnight (1986)                  | 2.250000 | 2 |

你可以看到电影标题，以及电影的平均评分和评分数。

让我们绘制上面 dataframe 中 "rating_counts" 列所代表的评分数的直方图。执行如下脚本：

```
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('dark')
%matplotlib inline

plt.figure(figsize=(8,6))
plt.rcParams['patch.force_edgecolor'] = True
ratings_mean_count['rating_counts'].hist(bins=50)
```

以下是上述脚本的输出：

![Ratings histogram](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-1.png)

从上图中，我们可以看到大部分电影的评分不到 50 条。而且有 100 条以上评分的电影数量非常少。

现在我们绘制平均评分的直方图。代码如下：

```
plt.figure(figsize=(8,6))
plt.rcParams['patch.force_edgecolor'] = True
ratings_mean_count['rating'].hist(bins=50)
```

输出结果如下：

![Average ratings histogram](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-2.png)

您可以看到整数值的 bar 比浮点值更高，因为大多数用户会做出整数评分，即 1、2、3、4 或 5。此外，很明显，数据的正态分布较弱，平均值约为 3.5。数据中有一些异常值。

前面，我们说有更多评分数的电影通常也有高平均评分，因为一部好电影通常都是家喻户晓的，而很多人都会看这样的电影，因此通常会有更高的评分。我们看看在我们的数据集中的电影是否也是这种情况。我们将平均评分与评分数量进行对比：

```
plt.figure(figsize=(8,6))
plt.rcParams['patch.force_edgecolor'] = True
sns.jointplot(x='rating', y='rating_counts', data=ratings_mean_count, alpha=0.4)
```

输出结果如下：

![Average ratings vs number of ratings](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-3.png)

该图表明，相较于低平均分的电影来说，高平均分的电影往往有更多的评分数量。

#### 找出电影之间的相似之处

我们在数据的可视化和预处理上花了较多时间。现在是时候找出电影之间的相似之处了。

我们将使用电影评分之间的相关性作为相似性度量。为了发现电影评分之间的相关性，我们需要创建一个矩阵，其中每列是电影名称，每行包含特定用户为该电影指定的评分。请记住，此矩阵将具有大量空值，因为不是每个用户都会对每部电影进行评分。

创建电影标题和相应的用户评分矩阵，执行如下脚本：

```
user_movie_rating = movie_data.pivot_table(index='userId', columns='title', values='rating')
```

```
user_movie_rating.head()
```

| title | "Great Performances" Cats (1998) | $9.99 (1998) | 'Hellboy': The Seeds of Creation (2008) | 'Neath the Arizona Skies (1934) | 'Round Midnight (1986) | 'Salem's Lot (2004) | 'Til There Was You (1997) | 'burbs, The (1989) | 'night Mother (1986) | (500) Days of Summer (2009) | ... | Zulu (1964)| Zulu (2013) |
| -- | -- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| userId| |     |     |     |     |	    |     |	    |     |	    |     |	    |     |	
| 1 | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | ... | NaN | NaN |
| 2 | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | ... | NaN | NaN |
| 3 | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | ... | NaN | NaN |
| 4 | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | ... | NaN | NaN |
| 5 | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | ... | NaN | NaN |

我们知道每列包含所有用户对某部电影的评分。让我们找到电影 "Forrest Gump (1994)" 的所有用户评分，然后找出跟它相似的电影。我们选这部电影是因为它评分数最多，我们希望找到具有更高评分数的电影之间的相关性。

要查找 "Forrest Gump (1994)" 的用户评分，执行如下脚本：

```
forrest_gump_ratings = user_movie_rating['Forrest Gump (1994)']
```

如上脚本将返回一个 Pandas 序列。让我们看看它长什么样。

```
forrest_gump_ratings.head()
```

```
userId
1    NaN
2    3.0
3    5.0
4    5.0
5    4.0
Name: Forrest Gump (1994), dtype: float64
```

现在让我们检索所有和 "Forrest Gump (1994)" 类似的电影。我们可以使用如下所示的 `corrwith()` 函数找到 "Forest Gump (1994)" 和所有其他电影的用户评分之间的相关性

```
movies_like_forest_gump = user_movie_rating.corrwith(forrest_gump_ratings)

corr_forrest_gump = pd.DataFrame(movies_like_forest_gump, columns=['Correlation'])
corr_forrest_gump.dropna(inplace=True)
corr_forrest_gump.head()
```

在上面的脚本中，我们首先使用 `corrwith()` 函数检索与 "Forrest Gump (1994)" 相关的所有电影的列表及其相关值。接下来，我们创建了包含电影名称和相关列的 dataframe。然后我们从 dataframe 中删除了所有 NA 值，并使用 `head` 函数显示其前 5 行。

输出结果如下：


| **title** | **Correlation** |
| --------- | --------------- |
| $9.99 (2008)                   | 1.000000 |
| 'burbs, The (1989)             | 0.044946 |
| (500) Days of Summer (2009)    | 0.624458 |
| *batteries not included (1987) | 0.603023 |
| ...And Justice for All (1979)  | 0.173422 |

让我们按照相关性的降序对电影进行排序，以便在顶部看到高度相关的电影。执行如下脚本：

```
corr_forrest_gump.sort_values('Correlation', ascending=False).head(10)
```

以下是上述脚本的输出：

| title | Correlation |
| ----- | ----------- |
| $9.99 (2008)                       | 1.0 |
| Say It Isn't So (2001)             | 1.0 |
| Metropolis (2001)                  | 1.0 |
| See No Evil, Hear No Evil (1989)   | 1.0 |
| Middle Men (2009)                  | 1.0 |
| Water for Elephants (2011)         | 1.0 |
| Watch, The (2012)                  | 1.0 |
| Cheech & Chong's Next Movie (1980) | 1.0 |
| Forrest Gump (1994)                | 1.0 |
| Warrior (2011)                     | 1.0 |

从输出结果中你可以发现和 "Forrest Gump (1994)" 高度相关的电影并不是很有名。这表明单独的相关性不是一个很好的相似度量，因为可能有一个用户只观看了 "Forest Gump (1994)" 和另外一部电影，并将它们都评为 5 分。

该问题的解决方案是仅检索具有至少 50 个评分的相关电影。为此，我们将 `rating_mean_count` dataframe 中的 `rating_counts` 列添加到我们的 `corr_forrest_gump` dataframe 中。执行如下脚本：


```
corr_forrest_gump = corr_forrest_gump.join(ratings_mean_count['rating_counts'])
corr_forrest_gump.head()
```

输出结果如下：

| title | Correlation | rating_counts |
| ----- | ----------- | ------------- |
| $9.99 (2008)                   | 1.000000 | 3  |
| 'burbs, The (1989)             | 0.044946 | 19 |
| (500) Days of Summer (2009)    | 0.624458 | 45 |
| *batteries not included (1987) | 0.603023 | 7  |
| ...And Justice for All (1979)  | 0.173422 | 13 |

你可以看到有着最高相关性的电影 "$9.99" 只有 3 条评分。这表明只有 3 个用户给了 "Forest Gump (1994)" 和 "$9.99" 同样的评分。但是，我们可以推断，不能仅根据 3 个评分就说一部电影与另一部相似。这就是我们添加 "rating_counts" 列的原因。现在让我们过滤评分超过 50 条的与 "Forest Gump (1994)" 相关的电影。如下代码执行此操作：

```
corr_forrest_gump[corr_forrest_gump ['rating_counts']>50].sort_values('Correlation', ascending=False).head()
```

脚本输出结果如下：

| title | Correlation | rating_counts |
| ----- | ----------- | ------------- |
| Forrest Gump (1994)             | 1.000000 | 341 |
| My Big Fat Greek Wedding (2002) | 0.626240 | 51  |
| Beautiful Mind, A (2001)        | 0.575922 | 114 |
| Few Good Men, A (1992)          | 0.555206 | 76  |
| Million Dollar Baby (2004)      | 0.545638 | 65  |

现在你可以从输出中看到与 "Forrest Gump (1994)" 高度相关的电影。列表中的电影是好莱坞电影中最着名的电影之一，而且由于 "Forest Gump (1994)" 也是一部非常着名的电影，这些电影很有可能是相关的。

### 结论

在本文中，我们学习了什么是推荐系统以及如何只使用 Pandas 库在 Python 中创建它。值得一提的是，我们创建的推荐系统非常简单。现实生活中的推荐系统使用非常复杂的算法，我们将在后面的文章中讨论。

如果您想了解有关推荐系统的更多信息，我建议看看这个非常好的课程[使用机器学习和 AI 构建推荐系统](https://stackabu.se/building-recommender-systems-with-ml-and-ai)。它比我们在本文中所做的更深入，涵盖了更复杂和准确的方法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
