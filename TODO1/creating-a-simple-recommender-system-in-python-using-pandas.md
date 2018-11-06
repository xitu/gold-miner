> * 原文地址：[Creating a Simple Recommender System in Python using Pandas](https://stackabuse.com/creating-a-simple-recommender-system-in-python-using-pandas/)
> * 原文作者：[Usman Malik](https://twitter.com/usman_malikk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-simple-recommender-system-in-python-using-pandas.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-simple-recommender-system-in-python-using-pandas.md)
> * 译者：
> * 校对者：

# Creating a Simple Recommender System in Python using Pandas

# 使用 Pandas 在 Python 中创建一个简单的推荐系统

## Introduction

## 简介

Have you ever wondered how Netflix suggests movies to you based on the movies you have already watched? Or how does an e-commerce websites display options such as "Frequently Bought Together"? They may look relatively simple options but behind the scenes, a complex statistical algorithm executes in order to predict these recommendations. Such systems are called Recommender Systems, Recommendation Systems, or Recommendation Engines. A [Recommender System](https://en.wikipedia.org/wiki/Recommender_system) is one of the most famous applications of data science and machine learning.

你有没有想过 Netflix 如何根据你已经看过的电影向你推荐电影？或者电商网站如何显示诸如“经常一起购买”等选项？他们可能看起来只是简单的选项，但是背后执行了一套复杂的统计算法以预测这些推荐。这样的系统被称为导购系统，推荐系统或者推荐引擎。[导购系统](https://en.wikipedia.org/wiki/Recommender_system)是数据科学和机器学习领域最著名的应用之一。

A Recommender System employs a statistical algorithm that seeks to predict users' ratings for a particular entity, based on the similarity between the entities or similarity between the users that previously rated those entities. The intuition is that similar types of users are likely to have similar ratings for a set of entities.

推荐系统采用统计算法，该算法基于实体之间的相似性或先前评估这些实体的用户之间的相似性来预测用户对特定实体的评级。直觉就是类似类型的用户可能对一组实体具有相似的评级。

Currently, many of the big tech companies out there use a Recommender System in one way or another. You can find them anywhere from Amazon (product recommendations) to YouTube (video recommendations) to Facebook (friend recommendations). The ability to recommend relevant products or services to users can be a huge boost for a company, which is why it's so common to find this technique employed in so many sites.

目前，许多大型科技公司都以这样或那样的方式使用推荐系统。你可以从亚马逊（产品推荐）到 YouTube（视频推荐）再到 Facebook（朋友推荐）的任何地方找到它们。给用户推荐相关产品和服务的能力对公司来说可能是一个巨大的推动力，这就是为什么此技术在众多网站中被普遍运用的原因。

In this article, we will see how we can build a simple recommender system in Python.

在这篇文章中，我们将看到如何使用 Python 构建一个简单的推荐系统。

### Types of Recommender Systems

### 推荐系统的类型

There are two major approaches to build recommender systems: Content-Based Filtering and Collaborative Filtering:

主要有两种方式构建推荐系统：基于内容过滤和协同过滤：

#### Content-Based Filtering

#### 基于内容过滤

In content-based filtering, the similarity between different products is calculated on the basis of the attributes of the products. For instance, in a content-based movie recommender system, the similarity between the movies is calculated on the basis of genres, the actors in the movie, the director of the movie, etc.

在基于内容过滤中，不同产品的相似性是根据产品的属性计算出来的。例如，在一个基于内容的电影推荐系统中，电影之间的相似性是根据类型，电影中的演员，电影导演等计算的。

#### Collaborative Filtering

#### 协同过滤

Collaborative filtering leverages the power of the crowd. The intuition behind collaborative filtering is that if a user A likes products X and Y, and if another user B likes product X, there is a fair bit of chance that he will like the product Y as well.

协同过滤利用人群的力量。协同过滤背后的直觉是如果 A 用户喜欢产品 X 和 Y，那么如果 B 用户喜欢产品 X，他就有相当大的可能同样喜欢产品 Y。

Take the example of a movie recommender system. Suppose a huge number of users have assigned the same ratings to movies X and Y. A new user comes who has assigned the same rating to movie X but hasn't watched movie Y yet. Collaborative filtering system will recommend him the movie Y.

举一个电影推荐系统的例子。假设大量的用户对电影 X 和 Y 给出一样的评分。一个新用户来了，他对电影 X 给出了相同的评分但是还没看过电影 Y。协同过滤系统就会把电影 Y 推荐给他。

### Movie Recommender System Implementation in Python

### Python 中的电影推荐系统实现

In this section, we'll develop a very simple movie recommender system in Python that uses the correlation between the ratings assigned to different movies, in order to find the similarity between the movies.

在这一节，我们将使用 Python 开发一个非常简单的电影推荐系统，它使用不同电影间的评分相关性，以便找到电影之间的相似性。

The dataset that we are going to use for this problem is the MovieLens Dataset. To download the dataset, go the [home page](https://grouplens.org/datasets/movielens/latest/) of the dataset and download the "ml-latest-small.zip" file, which contains a subset of the actual movie dataset and contains 100000 ratings for 9000 movies by 700 users.

我们将用于此问题的数据集是 MovieLens 数据集。要下载此数据集，可以去数据集的[主页](https://grouplens.org/datasets/movielens/latest/)下载“ml-latest-small.zip”文件，它包含真实电影数据集的子集并且有 700 个用户对 9000 部电影做出的 100000 条评分。

Once you unzip the downloaded file, you will see "links.csv", "movies.csv", "ratings.csv" and "tags.csv" files, along with the "README" document. In this article, we are going to use the "movies.csv" and "ratings.csv" files.

当你解压文件后，就能看到 "links.csv"、"movies.csv"、"ratings.csv" 和 "tags.csv" 文件，以及 "README" 文档。在本文中，我们会使用到 "movies.csv" 和 "ratings.csv" 文件。

For the scripts in this article, the unzipped "ml-latest-small" folder has been placed inside the "Datasets" folder in the "E" drive.

对于本文中的脚本，解压的 "ml-latest-small" 文件夹已经被放在了 "E" 盘的 "Datasets" 文件夹中。

#### Data Visualization and Preprocessing

#### 数据可视化和预处理

The first step in every data science problem is to visualize and preprocess the data. We will do the same, so let's first import the "ratings.csv" file and see what it contains. Execute the following script:

每个数据科学问题的第一步都是数据可视化和预处理。我们也是如此，接下来我们先导入 "ratings.csv" 文件看看它有哪些内容。执行如下脚本：

```
import numpy as np
import pandas as pd

ratings_data = pd.read_csv("E:\Datasets\ml-latest-small\\ratings.csv")
ratings_data.head()
```

In the script above we use the `read_csv()` method of the [Pandas library](/beginners-tutorial-on-the-pandas-python-library/) to read the "ratings.csv" file. Next, we call the `head()` method from the dataframe object returned by the `read_csv()` function, which will display the first five rows of the dataset.

在上面的脚本中，我们使用 [Pandas 库](/beginners-tutorial-on-the-pandas-python-library/) 的 `read_csv()` 方法读取 "ratings.csv" 文件。接下来，我们调用 `read_csv()` 函数返回的 dataframe 对象的 `head()` 方法。它将展示数据集的前五行数据。

The output looks likes this:

输出结果如下：

|   | userId | movieId | rating	timestamp |
|---|---|------|-----|------------|
| 0	| 1	| 31   | 2.5 | 1260759144 |
| 1	| 1	| 1029 | 3.0 | 1260759179 |
| 2	| 1	| 1061 | 3.0 | 1260759182 |
| 3	| 1	| 1129 | 2.0 | 1260759185 |
| 4	| 1	| 1172 | 4.0 | 1260759205 |

You can see from the output that the "ratings.csv" file contains the userId, movieId, ratings, and timestamp attributes. Each row in the dataset corresponds to one rating. The userId column contains the ID of the user who left the rating. The movieId column contains the Id of the movie, the rating column contains the rating left by the user. Ratings can have values between 1 and 5. And finally, the timestamp refers to the time at which the user left the rating.

从输出结果中可以看出 "ratings.csv" 文件包含 userId、movieId、ratings 和 timestamp 属性。数据集的每一行对应一条评分。userId 列包含评分用户的 ID。
movieId 列包含电影的 Id，rating 列包含用户的评分。评分的取值是 1 到 5。最后的 timestamp 代表用户做出评分的时间。

There is one problem with this dataset. It contains the IDs of the movies but not their titles. We'll need movie names for the movies we're recommending. The movie names are stored in the "movies.csv" file. Let's import the file and see the data it contains. Execute the following script:

这个数据集有一个问题。那就是它有电影的 ID 却没有电影名称。我们需要我们将推荐的电影的名称。电影名称存在 "movies.csv" 文件中。让我们导入它看看里面有什么内容吧。执行如下脚本：

```
movie_names = pd.read_csv("E:\Datasets\ml-latest-small\\movies.csv")  
movie_names.head()  
```

The output looks likes this:

输出结果如下：


|   | movieId | title | genres |
|---|---------|-------|--------|
| 0 | 1	| Toy Story (1995) | `Adventure|Animation|Children|Comedy|Fantasy` |
| 1 | 2	| Jumanji (1995) | `Adventure|Children|Fantasy` |
| 2 | 3	| Grumpier Old Men (1995) | `Comedy|Romance` |
| 3 | 4	| Waiting to Exhale (1995) | `Comedy|Drama|Romance` |
| 4 | 5	| Father of the Bride Part II (1995) | `Comedy` |

As you can see, this dataset contains movieId, the title of the movie, and its genre. We need a dataset that contains the userId, movie title, and its ratings. We have this information in two different dataframe objects: "ratings_data" and "movie_names". To get our desired information in a single dataframe, we can merge the two dataframes objects on the movieId column since it is common between the two dataframes.

如你所见，数据集包含 movieId，电影名称和它的类型。我们需要一个包含 userId，电影名称和评分的数据集。而我们需要的信息在两个不同的 dataframe 对象中："ratings_data" 和 "movie_names"。为了把我们想要的信息放在一个 dataframe 中，我们可以根据 movieId 列合并这两个 dataframe 对象，因为它在这两个 dataframe 对象中是通用的。

We can do this using `merge()` function from the Pandas library, as shown below:

我们可以使用 Pandas 库的 `merge()` 函数，如下所示：

```
movie_data = pd.merge(ratings_data, movie_names, on='movieId')
```

Now let's view our new dataframe:

现在我们来看看新的 dataframe：

```
movie_data.head()
```

The output looks likes this:

输出结果如下：

| 	| userId | movieId | rating | timestamp | title | genres |
|---|--------|---------|--------|-----------|-------|--------|
| 0	| 1	 | 31 | 2.5 | 1260759144  | Dangerous Minds (1995)	Drama |
| 1	| 7  | 31 | 3.0 | 851868750   | Dangerous Minds (1995)	Drama |
| 2	| 31 | 31 | 4.0 | 12703541953 | Dangerous Minds (1995)	Drama |
| 3	| 32 | 31 | 4.0 | 834828440   | Dangerous Minds (1995)	Drama |
| 4 | 36 | 31 | 3.0 | 847057202   | Dangerous Minds (1995)	Drama |

You can see our newly created dataframe contains userId, title, and rating of the movie as required.

我们可以看到新创建的 dataframe 正如要求的那样包含 userId，电影名称和电影评分。

Now let's take a look at the average rating of each movie. To do so, we can group the dataset by the title of the movie and then calculate the mean of the rating for each movie. We will then display the first five movies along with their average rating using the `head()` method. Look at the the following script:

现在让我们看看每部电影的平均评分。为此，我们可以按照电影的标题对数据集进行分组，然后计算每部电影评分的平均值。然后我们将使用 `head()` 方法显示前五部电影及其平均评分。请看如下脚本：

```
movie_data.groupby('title')['rating'].mean().head()
```

The output looks likes this:

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

You can see that the average ratings are not sorted. Let's sort the ratings in the descending order of their average ratings:

你可以看到平均评分是没有排序的。让我们按照平均评分的降序对评分进行排序：

```
movie_data.groupby('title')['rating'].mean().sort_values(ascending=False).head()
```

If you execute the above script, the output will look like this:

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

The movies have now been sorted according to the ascending order of their ratings. However, there is a problem. A movie can make it to the top of the above list even if only a single user has given it five stars. Therefore, the above stats can be misleading. Normally, a movie which is really a good one gets a higher rating by a large number of users.

这些电影现已根据评分的升序排序。然而，有一个问题。即使只有一个对电影做出了五星评价，这部电影就会排到列表的顶部。因此，上述统计数据可能具有误导性。通常来讲，一部真正的好电影会有大批用户给更高的评分。

Let's now plot the total number of ratings for a movie:

现在让我们绘制一部电影的评分总数：

```
movie_data.groupby('title')['rating'].count().sort_values(ascending=False).head()
```

Executing the above script returns the following output:

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

Now you can see some really good movies at the top. The above list supports our point that good movies normally receive higher ratings. Now we know that both the average rating per movie and the number of ratings per movie are important attributes. Let's create a new dataframe that contains both of these attributes.

现在你会看到真正的好电影就排在顶部了。以上列表证实了我们的观点，好电影通常会收到更高的评分。现在我们知道每部电影的平均评分和评分数量是重要的属性了。让我们创建一个新的包含这些属性的 dataframe。

Execute the following script to create `ratings_mean_count` dataframe and first add the average rating of each movie to this dataframe:

执行如下脚本创建 `ratings_mean_count` dataframe，首先将每部电影的平均评分添加到这个 dataframe ：

```
ratings_mean_count = pd.DataFrame(movie_data.groupby('title')['rating'].mean())
```

Next, we need to add the number of ratings for a movie to the `ratings_mean_count` dataframe. Execute the following script to do so:

接下来，我们需要把电影的评分数添加到 `ratings_mean_count` dataframe。执行如下脚本来实现：

```
ratings_mean_count['rating_counts'] = pd.DataFrame(movie_data.groupby('title')['rating'].count())
```

Now let's take a look at our newly created dataframe.

现在我们再看下新创建的 dataframe。

```
ratings_mean_count.head()
```

The output looks like this:

输出结果如下：

| title	| rating | rating_counts |
|-------|--------|---------------|
| "Great Performances" Cats (1998)        | 1.750000 | 2 |
| $9.99 (2008)                            | 3.833333 | 3 |
| 'Hellboy': The Seeds of Creation (2004) | 2.000000 | 1 |
| 'Neath the Arizona Skies (1934)         | 0.500000 | 1 |
| 'Round Midnight (1986)                  | 2.250000 | 2 |

You can see movie title, along with the average rating and number of ratings for the movie.

你可以看到电影标题，以及电影的平均评分和评分数。

Let's plot a histogram for the number of ratings represented by the "rating_counts" column in the above dataframe. Execute the following script:

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

Here is the output of the script above:

以下是上述脚本的输出：

![Ratings histogram](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-1.png)

From the output, you can see that most of the movies have received less than 50 ratings. While the number of movies having more than 100 ratings is very low.

从上图中，我们可以看到大部分的电影收到少于 50 条评分。而且有 100 条以上评分的电影数量非常少。

Now we'll plot a histogram for average ratings. Here is the code to do so:

现在我们绘制平均评分的直方图。代码如下：

```
plt.figure(figsize=(8,6))
plt.rcParams['patch.force_edgecolor'] = True
ratings_mean_count['rating'].hist(bins=50)
```

The output looks likes this:

输出结果如下：

![Average ratings histogram](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-2.png)

You can see that the integer values have taller bars than the floating values since most of the users assign rating as integer value i.e. 1, 2, 3, 4 or 5. Furthermore, it is evident that the data has a weak normal distribution with the mean of around 3.5. There are a few outliers in the data.

您可以看到整数值的 bar 比浮点值更高，因为大多数用户会做出整数评分，即 1,2,3,4 或 5。此外，很明显，数据的正态分布较弱，平均值约为 3.5。数据中有一些异常值。

Earlier, we said that movies with a higher number of ratings usually have a high average rating as well since a good movie is normally well-known and a well-known movie is watched by a large number of people, and thus usually has a higher rating. Let's see if this is also the case with the movies in our dataset. We will plot average ratings against the number of ratings:

前面，我们说有更多评分数的电影通常也有高平均评分，因为一部好电影通常都是众所周知的，很多人都会观看一部着名的电影，因此通常会有更高的评分。我们看看在我们的数据集中的电影是否也是这种情况。我们将平均评分与评分数量进行对比：

```
plt.figure(figsize=(8,6))
plt.rcParams['patch.force_edgecolor'] = True
sns.jointplot(x='rating', y='rating_counts', data=ratings_mean_count, alpha=0.4)
```

The output looks likes this:

输出结果如下：

![Average ratings vs number of ratings](https://s3.amazonaws.com/stackabuse/media/creating-simple-recommender-system-python-pandas-3.png)

The graph shows that, in general, movies with higher average ratings actually have more number of ratings, compared with movies that have lower average ratings.

该图表明，通常，更高平均评分的电影相对较低平均评分的来说有更多评分数量。

#### Finding Similarities Between Movies

#### 找出电影之间的相似之处

We spent quite a bit of time on visualizing and preprocessing our data. Now is the time to find the similarity between movies.

我们在数据的可视化和预处理上花了较多时间。现在是时候找出电影之间的相似之处了。

We will use the correlation between the ratings of a movie as the similarity metric. To find the correlation between the ratings of the movie, we need to create a matrix where each column is a movie name and each row contains the rating assigned by a specific user to that movie. Bear in mind that this matrix will have a lot of null values since every movie is not rated by every user.

我们将使用电影评分之间的相关性作为相似性度量。为了发现电影评分之间的相关性，我们需要创建一个矩阵，其中每列是电影名称，每行包含特定用户为该电影指定的评分。请记住，此矩阵将具有大量空值，因为不是每个用户都会对每部电影进行评分。

To create the matrix of movie titles and corresponding user ratings, execute the following script:

创建电影标题矩阵和相应的用户评分，执行如下脚本：

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

We know that each column contains all the user ratings for a particular movie. Let's find all the user ratings for the movie "Forrest Gump (1994)" and find the movies similar to it. We chose this movie since it has the highest number of ratings and we want to find the correlation between movies that have a higher number of ratings.

我们知道每列包含所有用户对某部电影的评分。让我们找到电影 "Forrest Gump (1994)" 的所有用户评分，然后找出跟它相似的电影。我们选这部电影是因为它评分数最多，我们希望找到具有更高评分数的电影之间的相关性。

To find the user ratings for "Forrest Gump (1994)", execute the following script:

要查找 "Forrest Gump (1994)" 的用户评分，执行如下脚本：

```
forrest_gump_ratings = user_movie_rating['Forrest Gump (1994)']
```

The above script will return a Pandas series. Let's see how it looks.

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

Now let's retrieve all the movies that are similar to "Forrest Gump (1994)". We can find the correlation between the user ratings for the "Forest Gump (1994)" and all the other movies using `corrwith()` function as shown below:

现在让我们检索所有和 "Forrest Gump (1994)" 类似的电影。我们可以使用如下所示的 `corrwith()` 函数找到 "Forest Gump (1994)" 和所有其他电影的用户评分之间的相关性

```
movies_like_forest_gump = user_movie_rating.corrwith(forrest_gump_ratings)

corr_forrest_gump = pd.DataFrame(movies_like_forest_gump, columns=['Correlation'])
corr_forrest_gump.dropna(inplace=True)
corr_forrest_gump.head()
```

In the above script, we first retrieved the list of all the movies related to "Forrest Gump (1994)" along with their correlation value, using `corrwith()` function. Next, we created a dataframe that contains movie title and correlation columns. We then removed all the NA values from the dataframe and displayed its first 5 rows using the `head` function.

在上面的脚本中，我们首先使用 `corrwith()` 函数检索与 "Forrest Gump (1994)" 相关的所有电影的列表及其相关值。接下来，我们创建了包含电影名称和相关列 的 dataframe。然后我们从 dataframe 中删除了所有 NA 值，并使用 `head` 函数显示其前 5 行。

The output looks likes this:

输出结果如下：

| **title** | **Correlation** |
| --------- | --------------- |
| $9.99 (2008)                   | 1.000000 |
| 'burbs, The (1989)             | 0.044946 |
| (500) Days of Summer (2009)    | 0.624458 |
| *batteries not included (1987) | 0.603023 |
| ...And Justice for All (1979)  | 0.173422 |

Let's sort the movies in descending order of correlation to see highly correlated movies at the top. Execute the following script:

让我们按照相关性的降序对电影进行排序，以便在顶部看到高度相关的电影。执行如下脚本：

```
corr_forrest_gump.sort_values('Correlation', ascending=False).head(10)
```

Here is the output of the script above:

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

From the output you can see that the movies that have high correlation with "Forrest Gump (1994)" are not very well known. This shows that correlation alone is not a good metric for similarity because there can be a user who watched '"Forest Gump (1994)" and only one other movie and rated both of them as 5.

从输出结果中你可以发现和 "Forrest Gump (1994)" 高度相关的电影并不是很有名。这表明单独的相关性不是一个很好的相似度量，因为可能有一个用户只观看了 "Forest Gump (1994)" 和另外一部电影，并将它们都评为 5 分。

A solution to this problem is to retrieve only those correlated movies that have at least more than 50 ratings. To do so, will add the `rating_counts` column from the `rating_mean_count` dataframe to our `corr_forrest_gump` dataframe. Execute the following script to do so:

该问题的解决方案是仅检索具有至少 50 个评分的相关电影。为此，我们将 `rating_mean_count` dataframe 中的 `rating_counts` 列添加到我们的 `corr_forrest_gump` dataframe 中。执行如下脚本：

```
corr_forrest_gump = corr_forrest_gump.join(ratings_mean_count['rating_counts'])
corr_forrest_gump.head()
```

The output looks likes this:

输出结果如下：

| title | Correlation | rating_counts |
| ----- | ----------- | ------------- |
| $9.99 (2008)                   | 1.000000 | 3  |
| 'burbs, The (1989)             | 0.044946 | 19 |
| (500) Days of Summer (2009)    | 0.624458 | 45 |
| *batteries not included (1987) | 0.603023 | 7  |
| ...And Justice for All (1979)  | 0.173422 | 13 |

You can see that the movie "$9.99", which has the highest correlation has only three ratings. This means that only three users gave same ratings to "Forest Gump (1994)", "$9.99". However, we can deduce that a movie cannot be declared similar to the another movie based on just 3 ratings. This is why we added "rating_counts" column. Let's now filter movies correlated to "Forest Gump (1994)", that have more than 50 ratings. The following code will do that:

你可以看到有着最高相关性的电影 "$9.99" 只有 3 条评分。这表明只有 3 个用户给了 "Forest Gump (1994)" 和 "$9.99" 同样的评分。但是，我们可以推断，不能仅根据 3 个评分就说一部电影与另一部相似。这就是我们添加 "rating_counts" 列的原因。现在让我们过滤评分超过 50 条的与 "Forest Gump (1994)" 相关的电影。如下代码执行此操作：

```
corr_forrest_gump[corr_forrest_gump ['rating_counts']>50].sort_values('Correlation', ascending=False).head()
```

The output of the script, looks likes this:

脚本输出结果如下：

| title | Correlation | rating_counts |
| ----- | ----------- | ------------- |
| Forrest Gump (1994)             | 1.000000 | 341 |
| My Big Fat Greek Wedding (2002) | 0.626240 | 51  |
| Beautiful Mind, A (2001)        | 0.575922 | 114 |
| Few Good Men, A (1992)          | 0.555206 | 76  |
| Million Dollar Baby (2004)      | 0.545638 | 65  |

Now you can see from the output the movies that are highly correlated with "Forrest Gump (1994)". The movies in the list are some of the most famous movies Hollywood movies, and since "Forest Gump (1994)" is also a very famous movie, there is a high chance that these movies are correlated.

现在你可以从输出中看到与 "Forrest Gump (1994)" 高度相关的电影。列表中的电影是好莱坞电影中最着名的电影之一，而且由于 "Forest Gump (1994)" 也是一部非常着名的电影，这些电影很有可能是相关的。

### Conclusion

### 结论

In this article, we studied what a recommender system is and how we can create it in Python using only the Pandas library. It is important to mention that the recommender system we created is very simple. Real-life recommender systems use very complex algorithms and will be discussed in a later article.

在本文中，我们学习了什么是推荐系统以及如何只使用 Pandas 库在 Python 中创建它。值得一提的是，我们创建的推荐系统非常简单。现实生活中的推荐系统使用非常复杂的算法，我们将在后面的文章中讨论。

If you want to learn more about recommender systems, I suggest checking out this very good course [Building Recommender Systems with Machine Learning and AI](https://stackabu.se/building-recommender-systems-with-ml-and-ai). It goes much more in-depth and covers more complex and accurate methods than we did in this article.

如果您想了解有关推荐系统的更多信息，我建议看看这个非常好的课程[使用机器学习和 AI 构建推荐系统](https://stackabu.se/building-recommender-systems-with-ml-and-ai)。它比我们在本文中所做的更深入，涵盖了更复杂和准确的方法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
