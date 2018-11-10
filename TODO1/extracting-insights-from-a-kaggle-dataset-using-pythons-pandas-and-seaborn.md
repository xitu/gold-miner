> * 原文地址：[EXTRACTING INSIGHTS FROM A KAGGLE DATASET USING PYTHON’S PANDAS AND SEABORN](http://www.dataden.tech/data-science/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn/)
> * 原文作者：[Strikingloo](http://www.dataden.tech/author/strikingloo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn.md](https://github.com/xitu/gold-miner/blob/master/TODO1/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：[rocheers](https://github.com/rocheers)

# 使用 Python 的 Pandas 和 Seaborn 框架从 Kaggle 数据集中提取信息

![](http://www.dataden.tech/wp-content/uploads/2018/09/peacock-feathers-3617474_1920-1038x576.jpg)

好奇心和直觉是数据科学家最强大的两个工具。第三个可能就是 Pandas 了。

我在 [上一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO1/exploratory-statistical-data-analysis-with-a-kaggle-dataset-using-pandas.md) 中，展示了如何了解一个数据集的完整性，并绘制一些变量，以及查看随时间变化的趋势和倾向。

为此，我在 Jupyter Notebook 上使用了 [Python 的 Pandas 框架](https://towardsdatascience.com/exploratory-data-analysis-with-pandas-and-jupyter-notebooks-36008090d813) 进行数据分析和处理，并使用Seaborn 框架进行可视化。

和本文一样，前一篇文章中我们使用了 [Kaggle 上 120 年奥运会数据集](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv)，研究了女性运动员随时间推进的参与情况、运动员的体重和身高分布以及其它一些变量的分析，但没有使用到每一位运动员参与运动项目的数据。

这一次，我们将关注数据集的体育运动栏数据，并获取一些关于它的信息。

我能想到的几个问题是：

*   哪项运动更有利于身材魁梧的人？个子高的人呢？
*   哪些运动项目较新，哪些较旧？有没有什么运动项目是由于失去了奥运会的青睐而停止了比赛呢？
*   有没有在某些运动项目中，总是同样的队伍获胜吗？那最多样化的运动呢，获胜者是不是来自于不同的地区？

与前面一样，我们分析中使用的项目放在 [这个 Github 项目](https://github.com/StrikingLoo/Olympics-analysis-notebook) 中，你可以对其进行 fork（复制），并添加自己的分析和理解。
让我们开始吧！

### 体重与身材分析

在我们的第一个分析中，我们想要分析看看哪些运动项目拥有最重和最高的运动员，哪些运动项目拥有最轻或最矮的运动员。

正如我们在前一篇文章中看到的，身高和体重都很大程度上取决于性别，数据集中男性运动员的数据比女性运动员的数据要多。所以我们会对男性做分析，但同样的代码对任何一种性别都是适用的，只需要切换性别过滤器即可。

```
male_df = df[df.Sex=='M']
sport_weight_height_metrics = male_df.groupby(['Sport'])['Weight','Height'].agg(
  ['min','max','mean'])

sport_weight_height_metrics.Weight.dropna().sort_values('mean', ascending=False)[:5]
```

正如你所看见的那样，如果我按运动进行分组，就可以计算每个运动运动员体重和身高的最小、最大和平均值。

然后我查看了排名前五的拥有体重最重运动员的运动，发现（以公斤为单位）：

```
Sport            min  max  average
Tug-Of-War       75.0 118.0  95.61
Basketball       59.0 156.0  91.68
Rugby Sevens     65.0 113.0  91.00
Bobsleigh        55.0 145.0  90.38
Beach Volleyball 62.0 110.0  89.51
```

不是很意外对吧？拔河运动员、篮球运动员和橄榄球运动员体重都很重。有趣的是，篮球和橄榄球运动员的体重变化很大，从 59 公斤到 156 公斤，而大多数拔河运动员的体重都超过了 80 公斤。

然后我画出了每种运动的平均体重图，发现它服从一个很好的正态分布：

```
sns.distplot(sport_weight_height_metrics.Weight.dropna()['mean'])
```

![](https://cdn-images-1.medium.com/max/800/1*kyUYokW9XjQTKjsI0Faz9w.png)

运动员的平均体重是服从正态分布的。

运动员的身高具有相似的正态分布，但其方差很小，高度集中在均值附近：

![](https://cdn-images-1.medium.com/max/800/1*f98OB-KyZbEN_IlN3Ew5MA.png)

运动员的身高是呈正态分布的。

接下来，我开始绘制所有的个体平均值，在有序的散点图中，看看是否有异常值出现。

```
means = list(sport_weight_height_metrics.Weight.dropna()['mean'])
sports = list(sport_weight_height_metrics.Weight.dropna().index)
plot_data = sorted(zip(sports, means), key = lambda x:x[1])
plot_data_dict = {
    'x' : [i for i, _ in enumerate(plot_data)],
    'y' : [v[1] for i, v in enumerate(plot_data)],
    'group' :  [v[0] for i, v in enumerate(plot_data)]
}
sns.scatterplot(data = plot_data_dict, x = 'x' , y = 'y')
```

![](https://cdn-images-1.medium.com/max/800/1*d1Z18iF59ZAN_Z7lu0NiqA.png)

每个奥林匹克运动员的平均身高分布。

实际上，拥有最重运动员的运动相对于图表的其余部分来说是非常离群的，而拥有最轻运动员的运动也是如此。如果我们在观察一下身高，尽管方差明显更小，但图中显示的“离群值”和接近均值的人之间的差异更大，更明显的是大多数人并没有偏离均值太多。

![](https://cdn-images-1.medium.com/max/800/1*aX9K7OlymvXLzwWfAFs8Bw.png)

每项运动的运动员平均体重。

对于运动员体重最轻的运动，可以使用之前生成的变量 _plot_data_ 来获取结果。

```
print('lightest:')
for sport,weight in plot_data[:5]:
    print(sport + ': ' + str(weight))

print('\nheaviest:')    
for sport,weight in plot_data[-5:]:
    print(sport + ': ' + str(weight))
```

结果（省略了最重的，因为我们已经在上面看过了）如下：

```
lightest:
Gymnastics:      63.3436047592
Ski Jumping:     65.2458805355
Boxing:          65.2962797951
Trampolining:    65.8378378378
Nordic Combined: 66.9095595127
```

体操运动员中甚至是男性运动员，都是迄今为止体重最轻的运动员！紧随其后的是跳台滑雪、拳击（这个让我有点吃惊）和蹦床，这其实很合理。

如果我们寻找身高最高和最矮的运动员，结果就不会那么令人惊讶了。我猜我们都期望与想象中同样的运动能够在榜首，不出所料，确实如此。至少我们现在可以说这不是刻板印象。

```
shortest (cm):
Gymnastics:    167.644438396
Weightlifting: 169.153061224
Trampolining:  171.368421053
Diving:        171.555352242
Wrestling:     172.870686236
```

```
tallest (cm):
Rowing:           186.882697947
Handball:         188.778373113
Volleyball:       193.265659955
Beach Volleyball: 193.290909091
Basketball:       194.872623574
```

我们可以看到体操运动员一般是很轻、很矮的。但是，身高排名中的一些运动项目并没有出现在体重排名中。我想知道每种运动都有着什么样的“体型”（即重量 / 高度）？

```
mean_heights = sport_weight_height_metrics.Height.dropna()['mean']
mean_weights = sport_weight_height_metrics.Weight.dropna()['mean']
avg_build = mean_weights/mean_heights
avg_build.sort_values(ascending = True)
builds = list(avg_build.sort_values(ascending = True))

plot_dict = {'x':[i for i,_ in enumerate(builds)],'y':builds}
sns.lineplot(data=plot_dict, x='x', y='y')
```

这幅图看上去是线性的，直到我们到达大多数离群点落下来的顶端：

![](https://cdn-images-1.medium.com/max/800/1*3NE2GsVnKoVG4cdHuP35uA.png)

奥林匹克运动员的体型（重量/高度）分布

以下是具有体型最小值和最大值的运动项目：

```
Smallest Build (Kg/centimeters)
Alpine Skiing    0.441989
Archery          0.431801
Art Competitions 0.430488
Athletics        0.410746
Badminton        0.413997
Heaviest Build
Tug-Of-War     0.523977
Rugby Sevens   0.497754
Bobsleigh      0.496656
Weightlifting  0.474433
Handball       0.473507
```

橄榄球和拔河比赛是具有最大值体型的运动项目。这次高山滑雪的运动员则是拥有最小值体型中的一个，紧随其后的是射箭和艺术比赛（这个是我刚知道的一项奥林匹克运动，需要进一步研究）。

### 随时间推移的体育运动变化

现在我们已经做了所有能想到的关于这三列的有趣的事情，我想开始观察一下时间变量。特别是今年。我想看看奥运会是否引进了新的运动项目，什么时候引进。同样也要观察一下被废弃的体育项目。

我们想要看一下一个东西第一次是什么时候出现的，下面这段代码一般会很有用，特别是当我们想看一下某个变量的异常增长时。

```
from collections import Counter

sport_min_year = male_df.groupby('Sport').Year.agg(['min','max'])['min'].sort_values('index')
year_count = Counter(sport_min_year)
year = list(year_count.keys())
new_sports = list(year_count.values())

data = {'x':year, 'y':new_sports}
sns.scatterplot(data=data, x = 'x', y='y')
```

#### 结果

这张图表向我们展示了每年有多少体育项目首次在奥运会上进行。或者，换句话说，每年有多少运动被引进：

![](https://cdn-images-1.medium.com/max/800/1*C4I8ie1tjSt6PsdWCXtD9g.png)

Quantity of Sports introduced each year.  

所以尽管在 1910 年之前就已经有很多运动项目，并且大多数的运动项目是在 1920 年之前引进的，但还是有很多新引进的。看着这些数据，我们就会发现 1936 年引进了很多新的运动项目，之后的每年引进的新项目就很少了（少于 5 个运动项目） 
从 1936 年到 1960 年的这段时间里没有什么新的运动项目引进，直到冬季两项运动项目的出现，之后就定期地增加新项目：

```
Sport           introduced
Biathlon           1960
Luge               1964
Volleyball         1964
Judo               1964
Table Tennis       1988
Baseball           1992
Short Track Speed Skating 1992
Badminton           1992
Freestyle Skiing    1992
Beach Volleyball    1996
Snowboarding        1998
Taekwondo           2000
Trampolining        2000
Triathlon           2000
Rugby Sevens        2016
```

对废弃运动（最大的年份并不在最近）进行的类比分析，结果显示这张运动列表中，其中大部分我从未听说过（尽管这绝不是衡量一项运动是否是流行的好指标！）

```
Basque Pelota    1900
Croquet          1900
Cricket          1900
Roque            1904
Jeu De Paume     1908
Racquets         1908
Motorboating     1908
Lacrosse         1908
Tug-Of-War       1920
Rugby            1924
Military Ski Patrol 1924
Polo             1936
Aeronautics      1936
Alpinism         1936
Art Competitions 1948
```

我们看到艺术比赛在 1948 年被取消，马球自 1936 年以来就没有在奥运会上出现过，飞行比赛也是如此。如果有人知道飞行比赛到底是什么，请告知我。我可以想到是在飞机上进行，但不知道比赛会是什么样子。也许是飞机飞行比赛？让它们再回到赛场上吧！

今天就到这里，伙计们！我希望你能喜欢这个教程，或许你已经得到了一个新的有趣的想法，可以在你的下次家庭晚餐中聊一聊。
和以往一样，你可以随意从该分析中 fork（复制）代码并添加自己的观点。后续工作我正在考虑使用基于运动、体重和身高列的数据来 [训练一个小型的机器学习模型来预测运动员的性别](http://www.dataden.tech/data-science/machine-learning-introduction-applying-logistic-regression-to-a-kaggle-dataset-with-tensorflow/)，告诉我你会用什么模型呢？ 
如果你觉得本文有什么地方表述不正确，或者有一些简单错误，请让我知道，让我们共同学习！

**继续访问网站以获取更多数据分析文章、Python 技术教程和其它数据相关内容。如果你喜欢这篇文章，请在 twitter 上与你的朋友分享。**

**可以在 [Twitter](http://twitter.com/strikingloo) 或者 [Medium](http://www.medium.com/@strikingloo) 上关注我获取更多新内容。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
