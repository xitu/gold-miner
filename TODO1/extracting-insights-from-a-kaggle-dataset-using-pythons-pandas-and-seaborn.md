> * 原文地址：[EXTRACTING INSIGHTS FROM A KAGGLE DATASET USING PYTHON’S PANDAS AND SEABORN](http://www.dataden.tech/data-science/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn/)
> * 原文作者：[Strikingloo](http://www.dataden.tech/author/strikingloo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn.md](https://github.com/xitu/gold-miner/blob/master/TODO1/extracting-insights-from-a-kaggle-dataset-using-pythons-pandas-and-seaborn.md)
> * 译者：
> * 校对者：

# EXTRACTING INSIGHTS FROM A KAGGLE DATASET USING PYTHON’S PANDAS AND SEABORN

![](http://www.dataden.tech/wp-content/uploads/2018/09/peacock-feathers-3617474_1920-1038x576.jpg)

Curiosity and Intuition are two of a Data Scientist’s most powerful tools. The third one may be Pandas.

On my [previous article](https://github.com/xitu/gold-miner/blob/master/TODO1/exploratory-statistical-data-analysis-with-a-kaggle-dataset-using-pandas.md) I showed you how to get an idea of how complete a Dataset was, plot a few of the variables, and look at trends and tendencies over time.

To do this, we used [Python’s Pandas framework](https://towardsdatascience.com/exploratory-data-analysis-with-pandas-and-jupyter-notebooks-36008090d813) on a Jupyter Notebook for Data analysis and processing, and the Seaborn Framework for visuals.

On the previous article, as on this one, we used the [120 years of Olympics](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv) [Kaggle](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv) [Dataset](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv), and looked at female participation over time, athletes’ weights’ and heights’ distributions, and other variables, but did not use the data about which sport each athlete practiced.

This time, we will focus on the Sport column of the Dataset, and gain some insights about it.

A few questions I can think of are:

*   Which sports favor heavybuilt people? What about tall people?
*   Which sports are newer, and which are older? Are there any sports that actually lost the Olympics’ favor and stopped being played?
*   Are there some sports where the same teams always win? What about the most diverse sports, with winners from many different places?

Same as before, we’ll be using [this Github project](https://github.com/StrikingLoo/Olympics-analysis-notebook) for the analysis, and you can fork it and add your own analysis and insights.  
Let’s dive right in!

### Weights and Statures

For our first analysis, we’ll look at what sports have the heaviest and tallest players, and which have the lightest or shortest.

As we saw on the previous article, both height and weight are heavily dependent on sex, and we have more data on the male athletes than the female ones. So we’ll do this analysis on the male ones, but the same code would work for either by just switching the ‘Sex’ filter.

```
male_df = df[df.Sex=='M']
sport_weight_height_metrics = male_df.groupby(['Sport'])['Weight','Height'].agg(
  ['min','max','mean'])

sport_weight_height_metrics.Weight.dropna().sort_values('mean', ascending=False)[:5]
```

As you can see, if I group by sport I can take the min, max and average weight and height for each sport’s players.

I then looked at the top 5 heaviest sports, and found this (in kilograms):

```
Sport            min  max  average
Tug-Of-War       75.0 118.0  95.61
Basketball       59.0 156.0  91.68
Rugby Sevens     65.0 113.0  91.00
Bobsleigh        55.0 145.0  90.38
Beach Volleyball 62.0 110.0  89.51
```

Not too unexpected, right? Tug-of-war practitioners, Basketball players and Rugby players are all heavy. It’s quite interesting to see there’s so much variation in Basketball and Rugby players, going from 59 to 156 kg, whereas most tug of war players are over 80 kilos.

Then I just plotted the mean weight for each sport, and found that it had a pretty normal distribution:

```
sns.distplot(sport_weight_height_metrics.Weight.dropna()['mean'])
```

![](https://cdn-images-1.medium.com/max/800/1*kyUYokW9XjQTKjsI0Faz9w.png)

Athlete’s mean Weight by sport is normally distributed.

The height has a similar, normal distribution, but its variance is a lot smaller, being highly concentrated in the mean:

![](https://cdn-images-1.medium.com/max/800/1*f98OB-KyZbEN_IlN3Ew5MA.png)

Athlete’s height is normally distributed.

Next I set out to graph all individual means, in an ordered scatter plot, to see whether there were any outliers.

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

Mean height distribution of each Olympic’s Sport’s Athletes.

In fact, the ‘heaviest’ sport is quite the outlier with respect to the rest of the graph, and the same happens with the ‘lightest’. If we look at heights, even though variance was clearly smaller, the plot reveals an even bigger difference between ‘outliers’ and people near the mean, accentuated by the fact that most people do not really deviate a lot from it.

![](https://cdn-images-1.medium.com/max/800/1*aX9K7OlymvXLzwWfAFs8Bw.png)

Mean weight of each sport’s athletes.

For the lightest sports, the results can be obtained using the previously generated variable, _plot_data_.

```
print('lightest:')
for sport,weight in plot_data[:5]:
    print(sport + ': ' + str(weight))

print('\nheaviest:')    
for sport,weight in plot_data[-5:]:
    print(sport + ': ' + str(weight))
```

The results (omitting the heaviest ones, since we already saw those) are the following:

```
lightest:
Gymnastics:      63.3436047592
Ski Jumping:     65.2458805355
Boxing:          65.2962797951
Trampolining:    65.8378378378
Nordic Combined: 66.9095595127
```

Gymnastics athletes, even the male ones, are by far the lightest players! They are followed quite closely by Ski Jumping, Boxing (which kinda surprised me) and Trampolining, which actually makes a lot of sense.

If we instead look for the tallest and shortest athletes, the results will be a little less surprising. I’m guessing we all expected the same sport to come up on top and, unsurprisingly, it did. At least we can now say it’s not a stereotype.

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

We see Gymnastics practitioners are very light, and very short. But some sports in these rankings do not appear in the weight ones. I wonder what ‘build’ (weight/height) each sport has?

```
mean_heights = sport_weight_height_metrics.Height.dropna()['mean']
mean_weights = sport_weight_height_metrics.Weight.dropna()['mean']
avg_build = mean_weights/mean_heights
avg_build.sort_values(ascending = True)
builds = list(avg_build.sort_values(ascending = True))

plot_dict = {'x':[i for i,_ in enumerate(builds)],'y':builds}
sns.lineplot(data=plot_dict, x='x', y='y')
```

The plot has a pretty linear look, until we get to the top where most outliers fall:

![](https://cdn-images-1.medium.com/max/800/1*3NE2GsVnKoVG4cdHuP35uA.png)

Build (Weight/Height) distribution of Olympics’ athletes

And here are the least and most heavily built sports:

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

Again, Rugby and Tug of War are the most heavily built sports. This time Alpine skiing comes up as the least one, with Archery and Art Competitions (which I just learned is an Olympics Sport and will require further research) following close by.

### Sports over time

Now we’ve done all the interesting things I could think of with those three columns, I’d like to start looking at the time variable. Specifically the year. I want to see whether new sports have been introduced to the Olympics, and when. But also which have been deprecated.

This code will be generally useful any time we need to see when something arose for the first time, especially if we want to see an abnormal increase in a variable.

```
from collections import Counter

sport_min_year = male_df.groupby('Sport').Year.agg(['min','max'])['min'].sort_values('index')
year_count = Counter(sport_min_year)
year = list(year_count.keys())
new_sports = list(year_count.values())

data = {'x':year, 'y':new_sports}
sns.scatterplot(data=data, x = 'x', y='y')
```

#### Results

The graph shows us how many sports were practiced in the Olympics for the first time for each year. Or, in other words, how many sports were introduced each year:

![](https://cdn-images-1.medium.com/max/800/1*C4I8ie1tjSt6PsdWCXtD9g.png)

Quantity of Sports introduced each year.  

So even though a lot of sports where there before 1910, and most where introduced before 1920, there have been many relatively new introductions. Looking at the data, I see there were many new sports introduced in 1936, and afterwards they were always brought in small (less than five sports) sets.  
There weren’t any new sports between 1936 and 1960, when Biathlon was introduced, and then they kept adding them pretty regularly:

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

An analogous analysis for deprecated sports (where max year is not recent) shows this list of sports, most of which I’ve never heard of (though that’s by no means a good metric of whether a sport is popular!)

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

We see Art Competitions were dropped in 1948, Polo hasn’t been practiced olympically since 1936, and the same goes for Aeronautics. If anyone knows what exactly is Aeronautics, please let me know, I’m picturing people in a plane but don’t see what the competition could be like. Maybe plane races? Let’s bring those back!

That’s all for today, folks! I hope you’ve enjoyed this tutorial, and maybe you’ve got a new interesting fact to bring up in your next family dinner.  
As usual, feel free to fork the code from this analysis and add your own insights. As a follow up, I’m thinking of [training a small Machine Learning model to predict an athlete’s sex](http://www.dataden.tech/data-science/machine-learning-introduction-applying-logistic-regression-to-a-kaggle-dataset-with-tensorflow/) based on the sport, weight and height columns, tell me what model you’d use!  
And if you feel anything in this article was not properly explained, or is simply wrong, please also let me know, as I’m learning from these as well!

_Keep visiting this site for more Data Analysis articles, Python tutorials and anything else Data Related. If you liked this article, please share it with your data friends on twitter._

_Consider [following me on Twitter](http://twitter.com/strikingloo) or [Medium](http://www.medium.com/@strikingloo) to know when I write anything new._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
