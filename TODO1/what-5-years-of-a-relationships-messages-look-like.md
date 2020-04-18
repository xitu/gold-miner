> * 原文地址：[What 5 Years of a Relationship’s  Messages Look Like](https://towardsdatascience.com/what-5-years-of-a-relationships-messages-look-like-45921155e3f2)
> * 原文作者：[Callum Ballard](https://medium.com/@callumballard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-5-years-of-a-relationships-messages-look-like.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-5-years-of-a-relationships-messages-look-like.md)
> * 译者：
> * 校对者：

# What 5 Years of a Relationship’s  Messages Look Like

> Or, some cool ways to deal with time series data (and emojis) in Python

![Source: Pexels (Not my girlfriend)](https://cdn-images-1.medium.com/max/11232/1*_9_n9-CBegAclYiJEhndug.jpeg)

As our government-imposed lockdown reached week number three, my girlfriend made a throwaway comment: **“I bet our message-sending is at an all time low…”**

It’s the kind of remark that a house-bound data scientist isn’t going to ignore for long. So I went to Telegram’s desktop app, and [downloaded our entire message history](https://telegram.org/blog/export-and-more). The export comes in the form of HTML files, each containing 500 messages’ worth of data (there were over 160 such files). Happily, one can use techniques used in general webscraping endevours — in particular, [various BeatifulSoup4 methods](https://towardsdatascience.com/soup-of-the-day-97d71e6c07ec) — to automate the creation of a dataframe, where each row represents one message.

![I can not remember which American we were talking about at the time…](https://cdn-images-1.medium.com/max/2000/1*hMlh66eaIhTUbmRa2a_Hrg.png)

Note — a key feature here is the Timestamp column. It is important for the Pandas methods we’ll use later that this is of type ‘datetime’, rather than simply a string. This is pretty easy to achieve with Pandas’ in-buit to_datetime method:

```python
df[‘Timestamp’] = pd.to_datetime(df[‘Timestamp’], dayfirst=True)
```

The Telegram HTML gives its timestamps using the dd/mm/yyyy format. We thus pass the **‘dayfirst’** parameter to ensure that this is how the string is interpreted (i.e. 5/4/2020 should be read as the 5th of April, not the 4th of May).

So what can we do with this dataset? We could certainly attempt some NLP work (this may be the subject of a future blog — I have certain hypotheses about how our vocabularies have converged during our time together…) For now, let’s simply think about how to visualise our time series data, and how such visualisations can be best presented to enable the extraction of insight.

---

Let’s first investigate how our message volumes have evolved over the last five years by creating a line chart of messages sent per day. Pandas comes with a built-in method allowing us to aggregate data by given time intervals (e.g. a count of messages per day).

```python
df.set_index('Timestamp').groupby(pd.Grouper(freq ='D')).count()
```

There are several chained methods here — let’s break it down:

* **.set_index(‘Timestamp’)** **first, we need to have the datetime feature as our index.**
* **.groupby(pd.Grouper())** **this works like a [standard pandas groupby](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html), but rather than creating an index of the unique items in the column, it creates an index of days between (and including) the ‘smallest’ and ‘largest’ date in the sample. Crucially, this also creates rows for days that aren’t accounted for in the dataset (e.g. because we exchanged no messages on some days).**
* **freq=‘D’**** this frequency doesn’t have to be ‘days’ — we can set it to any interval we want (M for month, etc.)**
* **.count()**** like a standard groupby, we need to call an aggregation method to create the actual dataframe.**

So what does this look like in as a standard line chart?

![](https://cdn-images-1.medium.com/max/2000/1*5Ti9rnJOLiNxCzJuBEe39w.png)

A mess, mostly.

This isn’t really any better if we look at the total word count on a daily basis (i.e. it’s not the case that our data is affected by my apparently annoying tendency to send each clause in a sentence as a separate message).

![](https://cdn-images-1.medium.com/max/2000/1*9UyxPHsq11K1bQ91PVDdZg.png)

There **are** a couple of things we can pull from these charts, however:

* We generally stay within an upper bound of about 150 messages, or 600 words
* We messaged a lot on the two Christmasses we spent apart (the two spikes in 2015 and 2016), and not at all on the Christmasses we spent together (2017, 2018, and 2019)
* The overall amount that we message each other doesn’t **seem** to have changed that much over time

Let’s investigate that last point a bit further. The charts show that, even though the daily messaging volumes have a pretty consistant upper bound over the five years, they fluctuate wildly day by day (we’ll exchange 500 words one day, and zero the next).

We can clean this up a bit by using rolling averages — in other words, the value for a given day is calculated as the mean value of the last **x** days. This means that our very jagged plots above should, in theory, smooth out (especially as we increase the window width, **x**). This ought to reveal any underlying trends.

Pandas has a handy method for this:

```python
df[‘WordCount’].rolling(window = x).mean()
```

* We can change **x** to set the window width
* We don’t need to use mean — we could look at a rolling sum, etc.
* This will create a new series of the same length as the original series, but where the first **x**-1 elements are NaNs

Let’s now look at total words exchanged per day, split between sender, with increasing window widths (of one week, four weeks, and eight weeks). Let’s also add two red vertical lines showing:

1. When we moved in together (April 2017)
2. When we moved cities and I started studying from home (May 2019)

![](https://cdn-images-1.medium.com/max/2000/1*rPSnTDMvIg2_O9w1isb6NA.png)

![](https://cdn-images-1.medium.com/max/2000/1*22zoIEKEwkzCLte3gTVigQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*FHaiXTqFdvP3993yXSvTLQ.png)

The 56 day rolling average starts to make a few things a little bit clearer:

* We exchanged many more words per day before we moved in together (left of the first red line)
* My girlfriend has consistently sent more words per day than me
* However, when we moved cities and she started working on a more demanding client project, her messaging volumes dropped to my levels — she had less time to engage in her normal levels of messaging, but she was clearly still considerate enough to respond when I sent something
* The lockdown at the far right of the time series has indeed led to a precipitous drop in our words exchaged per day…

---

Of course, modern messaging is more than just the words you exchange (there’s a reason the [Oxford Dictionary word-of-the-year in 2015](https://www.theverge.com/2015/11/16/9746650/word-of-the-year-emoji-oed-dictionary) was an emoji). Surprisingly, the initial scrape of the Telegram HTML actually preserved the original emoji.

![](https://cdn-images-1.medium.com/max/2000/1*2_iBufQhAZMq7sJK1zkrZw.png)

Native Python does not cope with these characters, however there’s a [neat little package (imaginatively called ‘emoji’)](https://pypi.org/project/emoji/) that allows you to identify, count, and decode emojis in strings.

If we investigate the ‘non-text’ messages, we can see that emojis are an especially important communication method for my girlfriend. I, on the other hand, add value by sharing photos and links (generally from Reddit), and [stickers](https://telegram.org/blog/discover-stickers-and-more) (a feature that Telegram was relatively early to introduce).

![](https://cdn-images-1.medium.com/max/2000/1*fZAjwVn3eED7un7BDeCbYA.png)

We can attempt to see how volumes of these non-text messages have changed over time using the same rolling average trick. However, beyond an early 2018 spike in Stickers (when we worked out that you could download custom sets — truly, a gamechaging moment), there aren’t many discernable patterns.

![](https://cdn-images-1.medium.com/max/2000/1*RvNiHOMYgTQw_PXOit6DfQ.png)

Instead, let’s build a graph showing the accumilation of these non-text messages by type. To do this, we can employ NumPy’s cumsum() method, which will take a cumulative sum of a series. Supposing we have a dataframe whose index is a date range, and each column describes the number of messages of each type sent on that day:

```python
#Create a list of message types
required_cols = ['Emoji','Photo','Sticker','Link','Voice message','Animation']

#Create a new dataframe of just these types
df_types_cum = df_types[required_cols]

#Iterate through the columns and replace
#each with the cumulative sum version
for i in required_cols:
    df_types_cum[i] = np.cumsum(df_types_cum[i])

#Use Pandas' in-built plot method to show it
df_types_cum.plot.area(figsize=(15,6), lw=0)
```

This produces the following chart.

![](https://cdn-images-1.medium.com/max/2000/1*fmij_Ww5MgMZ1HSEzyTqDQ.png)

Again, we can see the introduction and uptake of stickers (the amber segment), as well as an acceleration in the use of emojis from 2018 onwards.

---

Something that our previous analysis has not touched on is the time of day that we have shared messages (only the amount per day). A visualisation of this could get very messy very quickly. There are already 24 hours a day — if we then want to see if there are differences depending on other metrics (e.g. day of the week, the year, etc.) then suddenly we have a lot of visual data we need to convey in a single chart.

A heatmap allows us to do this fairly neatly. Here, I’ve created a dataframe showing the sum of words sent by hour, by each day of the week, before and after we started living together (using Pandas’ pivot_table method):

```python
df_times = pd.pivot_table(df,fill_value=0,
               index=['LivingTogether','Day'],
               columns='Hour',
               aggfunc='sum')['WordCount'].T

#Note - the .T at the end of the code transposes the dataframe
```

I can then get the average words sent per hour by dividing the two parts of the dataframe by the appropriate number of weeks spent not living, and living together. We can then use Seaborn’s heatmap function to visualise the dataframe.

```python
sns.heatmap(df_times)
```

![](https://cdn-images-1.medium.com/max/2000/1*BVcJll7c7pqjOK96iKMSyg.png)

Having added a couple of vertical and horizontal lines to demarkate work hours and weekends, we can easily pull visual information from the heatmap. Before moving in together, we messaged fairly consistantly through the day, but especially heavily before sleeping (the paler squares on Fridays and Saturdays suggest that we were more likely to sleepover at each other’s houses on these evenings).

Having moved in together, we can see that our messaging became confined to work hours. Interestingly, it appears that the volume of messaging during this time of the day actually increased. We can also see that our bedtimes drastically improved in this time — long gone are the days of messaging until 1am.

---

Thanks for reading all the way to the end of the blog! I’d love to hear any comments about the above analysis, or any of the concepts that the piece touches on. Feel free to leave a message below, or reach out to me through [LinkedIn](https://www.linkedin.com/in/callum-ballard/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
