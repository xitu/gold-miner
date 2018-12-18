> * 原文地址：[EXPLORATORY STATISTICAL DATA ANALYSIS WITH A KAGGLE DATASET USING PANDAS](http://www.dataden.tech/data-science/exploratory-statistical-data-analysis-with-a-kaggle-dataset-using-pandas/)
> * 原文作者：[Strikingloo](http://www.dataden.tech/author/strikingloo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/exploratory-statistical-data-analysis-with-a-kaggle-dataset-using-pandas.md](https://github.com/xitu/gold-miner/blob/master/TODO1/exploratory-statistical-data-analysis-with-a-kaggle-dataset-using-pandas.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：[rocheers](https://github.com/rocheers)

# 使用 Pandas 对 Kaggle 数据集进行统计数据分析

![](http://www.dataden.tech/wp-content/uploads/2018/09/runninggu.jpg)

有时，当遇到一个数据问题的时候，对于数据集，我们必须首先深入研究并了解它。了解它的性质，它的分布等等，这是我们需要专注的领域。

今天，我们将利用 [Python Pandas](https://towardsdatascience.com/exploratory-data-analysis-with-pandas-and-jupyter-notebooks-36008090d813) 框架进行数据分析，并利用 Seaborn 进行数据的可视化。

作为一名极客程序员，我的审美观念很低。Seaborn 对我来说是一种很好的可视化工具，因为只需要坐标点即可。

它在底层使用 Matplotlib 作为绘图引擎，使用默认的样式来设置图形，这使得它们看起来比我所能做的更漂亮。让我们来看一下数据集，我会给大家展示一种看待不同特征时的直观感受。也许我们能从中获得一些真知灼见呢！

#### 没有鸡蛋就不能做煎蛋卷：数据集。

下面的分析中，我使用的是 [120 年的奥运会](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv) 数据集，你可以通过点击这个链接来下载或阅读更多的相关信息。

我是从 Kaggle 上免费下载该数据集的。如果你需要获取一个数据集来尝试一些新的 [机器学习算法](http://www.dataden.tech/data-science/machine-learning-introduction-applying-logistic-regression-to-a-kaggle-dataset-with-tensorflow/)，来温习一些框架的 API，或者只是想要玩一下，Kaggle 是一个很棒的网站。

我将只使用 CSV 文件中的 ‘athlete_events’，其中记录了自 1900 年以来的每一场奥运会比赛的运动员信息，即每个参赛运动员出生地所属的国家，以及他们是否获奖等等。

有趣的是， 文件中的 _medals_ 列中有 85% 的数据是空的，所以平均只有 15% 的奥运会运动员获得了奖牌。 此外，还有一些运动员获得了不止一枚奖牌，这表明，在为数不多的奥运级别运动员中，只有更少的人能获得奖牌。所以他们的功劳是更大的！

#### 开始分析：数据集是什么样的？

首先，在深入了解该数据集之前，可以先通过一些直观数据来了解数据集的模式。比如数据集中有多少数据丢失了？数据有多少列？我想先从这些问题开始分析。

我在分析过程中使用 Jupyter 笔记进行，我会为我运行的每段代码添加注释，以便你可以继续学习。

该 Jupyter 笔记可以在 [这个仓库中](https://github.com/StrikingLoo/Olympics-analysis-notebook/) 找到，你可以打开来看一下，并可以从任何一个地方开始。

我首先要做的是使用 Pandas 来加载数据，并检查它们的大小。

```
import pandas as pd
import seaborn as sns

df = pd.read_csv('athlete_events.csv')
df.shape
#(271116, 15)
```

在这个例子中，数据集中有 15 个不同的列，以及整整 271116 行！也就是超过 27 万的运动员数据！但是接下来我想知道实际上有多少不同的运动员。还有，他们中有多少人赢得了奖牌？

为了查看这些数据，首先字数据集上调用 ‘list’ 函数列出行数据。我们可以看到许多感兴趣的特征。

```
list(df)
#['ID','Name','Sex','Age','Height','Weight','Team','NOC','Games','Year','Season','City',
# 'Sport','Event','Medal']
```

我能想到的一些事情是，我们可以查看奥运会运动员的平均身高和体重，或者通过不同的运动来划分他们。我们还可以查看依赖于性别的两个变量的分布。我们甚至还可以看到每个国家有多少奖牌，将此作为时间序列，来查看整个二十世纪文明的兴衰。

可能性是无限的！但首先让我们来解决这个难题：我们的数据集有多完整？

```
def NaN_percent(df, column_name):
    row_count = df[column_name].shape[0]
    empty_values = row_count - df[column_name].count()
    return (100.0*empty_values)/row_count
for i in list(df):
    print(i +': ' + str(NaN_percent(df,i))+'%')  
'''
0% incomplete columns omitted for brevity.
Age: 3.49444518214%
Height: 22.193821095%
Weight: 23.191180159%
Medal: 85.3262072323% --Notice how 15% of athletes did not get any medals
'''
```

在序列数据上使用 Pandas 的计数方法可以得到非空行的数量。而通过查看 shape 属性，可以查看到总的行数，不管它们是否为空。

之后就是减法和除法的问题了。我们可以看到只有四栏的属性不完整：身高、体重、年龄和奖牌。

奖牌属性的不完整是因为一个运动员可能实际上并没有赢得奖牌，所以可以预料到这条数据是不完全的。然而，在体重、身高和年龄的方面，不完整的数据让我们面临着相当大的挑战。

我试着用不同的年份对这些数据行进行过滤，但这种不完整性似乎随着时间的推移而保持一致，这让我觉得可能是有一些国家不提供运动员的这些相关数据。

#### 开始我们真正的分析： 奖牌情况是怎样的？

我们问的第一个问题是，自 1900 年以来，有多少不同的人获得过奖牌？下面的代码片段回答了这个问题：

```
total_rows = df.shape[0]
unique_athletes = len(df.Name.unique())
medal_winners = len(df[df.Medal.fillna('None')!='None'].Name.unique())

"{0} {1} {2}".format(total_rows, unique_athletes, medal_winners)

#'271116 134732 28202'
```

正如你所看到的，在过去的 120 年里，大约有 13.5 万不同的人参加了奥运会，但是只有 2.8 万多人获得了至少一枚奖牌。

获得奖牌比率大约是五分之一，还不错。但如果你考虑到许多人实际上会参加多个类别的运动，那就不那么乐观了。

既然我们已经分析到这里了，那么在这 120 年里运动员们到底赢得了多少奖牌呢？

```
# 查看奖牌分布
print(df[df.Medal.fillna('None')!='None'].Medal.value_counts())
# 总共多少奖牌
df[df.Medal.fillna('None')!='None'].shape[0]
'''
Gold      13372
Bronze    13295
Silver    13116
Total: 39783
'''
```

不出所料，奖牌榜上的分布几乎是均匀的：获得的金牌、银牌和铜牌的数量几乎是相同的。

然而，总共颁发了近 3.9 万枚奖牌，这意味着如果你属于获得奖牌最多的那 20% 的运动员，那么你的平均奖牌数将超过 1 枚。

那么按照国家来进行分配呢？为了获得这些信息，可以运行下面的代码片段：

```
team_medal_count = df.groupby(['Team','Medal']).Medal.agg('count')
# 按照数量进行排列
team_medal_count = team_medal_count.reset_index(name='count').sort_values(['count'], ascending=False)
#team_medal_count.head(40) 用来显示第一行

def get_country_stats(country):
    return team_medal_count[team_medal_count.Team==country]
# get_country_stats('some_country') 获得对应国家的奖牌
```

使用这个函数我们可以得到某个国家获得的每种类型的奖牌数量，而通过获取 Pandas 数据帧头部以看到获得奖牌最多的国家。

有趣的是，奖牌数最多国家的第二名仍然是苏联，尽管它已经近 20 年没有出现了。

在所有类别中，第一名是美国，第三名是德国。我还观察了我的两个国家——阿根廷和克罗地亚，惊讶地发现克罗地亚已经赢得了 58 枚金牌，尽管这是从 1991 年（那是 1992 年的奥运会）以来的事情。

写一段代码作为练习，获取到某一个国家参加奥运会的不同年份数据，我相信你能做到！

#### 女性参与情况

我想到的另一件有趣的事是，从这整个世纪以来，女性在奥运会上的表现如何？这段代码回答了这个问题：

```
unique_women = len(df[df.Sex=='F'].Name.unique())
unique_men = len(df[df.Sex=='M'].Name.unique())
women_medals = df[df.Sex=='F'].Medal.count()
men_medals = df[df.Sex=='M'].Medal.count()

print("{} {} {} {} ".format(unique_women, unique_men, women_medals, men_medals ))

df[df.Sex=='F'].Year.min()

#33808 100979 11253 28530 
#1900
```

让我惊讶的是早在 1900 年就有女性参加了奥运会。然而，从历史上看，奥运会的男女比例是 3 比 1。惊讶于女性早在 1900 年就参加了奥运会，我决定查看一下整个时间段里面她们的参与人数。我终于用到了 Seaborn！

![Female participation in the Olympics over time.](https://cdn-images-1.medium.com/max/800/0*Gp3AI-vPaxL7LlWs.png)

我们可以看到，在过去的几十年里，女性的参与率一直在快速上升，从几乎为零上升到数千。然而，她们的参与率真的比男性增长得快吗？或者这只是世界人口的问题？为了解决这个问题，我做了第二副图：

```
f_year_count = df[df.Sex=='F'].groupby('Year').agg('count').Name
m_year_count = df[df.Sex=='M'].groupby('Year').agg('count').Name
(sns.scatterplot(data= m_year_count),
 sns.scatterplot(data =f_year_count))
```

![Female participation in the Olympics over time.](https://cdn-images-1.medium.com/max/800/0*qtjbN64IzHEuj-Kn.png)

随时间推移，女性参与（橙色）对男性参与（蓝色）。

这一次，我们可以清楚地看到这样一个模式的出现：女性的参与数量实际上正在快速地接近男性的数量！另一件有趣的事情是：看到下面的小点了吗，在右边？我想那就是冬季奥运会！无论如何，对于女性代表来说，这幅图看起来相当乐观，尽管还没有在哪一年中女性的参与者多于男性。

#### 其它分析：身高和体重

我花了很长时间来查看身高和体重相关图，但没有得到任何有趣的结论。

*   这两种属性在大多数运动中都是呈正态分布的
*   在我所观察过的所有运动中，男性总是比女性更重和更高
*   唯一有趣的变化似乎是根据此项运动来可以分析两种性别之间的差别到底有多大。

如果你有任何有趣的想法可以用来分析体重和身高的数据，请告知我！我对每项运动的分组不够深入，所以可能会有一些错误的解释。以上就是今天的内容，我希望你们觉得这个分析很有趣，或者至少你们学到了一些 Pandas 或者数据分析的相关知识。

我把笔记放在了 [GitHub](https://github.com/StrikingLoo/Olympics-analysis-notebook/) 上，这样你就可以复制这个项目，可以做你自己的分析，然后提出一个 pull request（拉取请求）。

当然你可以得到所有的功劳！希望你们在图形显示和视觉分析上做的比我要好。

[**第2部分关于运动的深入理解**](https://github.com/xitu/gold-miner/blob/master/TODO1/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn.md) **在这里可以找到。**

**可以 [在 medium 上关注我](http://www.medium.com/@strikingloo)** **以获取更多软件开发和数据科学相关的教程、提示和技巧。
**如果你真的喜欢这篇文章，和朋友分享吧！****

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
