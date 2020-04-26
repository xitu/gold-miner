> * 原文地址：[What 5 Years of a Relationship’s  Messages Look Like](https://towardsdatascience.com/what-5-years-of-a-relationships-messages-look-like-45921155e3f2)
> * 原文作者：[Callum Ballard](https://medium.com/@callumballard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-5-years-of-a-relationships-messages-look-like.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-5-years-of-a-relationships-messages-look-like.md)
> * 译者：[Amberlin1970](https://github.com/Amberlin1970)
> * 校对者：

# 恋爱 5 年的消息看起来是什么样

> 或者，用 Python 来处理时间序列数据（还有表情）的一些很酷的方式

![出自: Pexels (不是我的女朋友)](https://cdn-images-1.medium.com/max/11232/1*_9_n9-CBegAclYiJEhndug.jpeg)

在我们的政府实施封锁的第三周，我的女朋友随口一说：**“我打赌我们发送的消息是有史以来最少的...”**

这是一个被困在家中的数据科学家不会长时间忽视的评论。所以我打开了 Telegram 的桌面程序，然后[下载我们所有的消息记录](https://telegram.org/blog/export-and-more)。消息记录是以 HTML 文件的形式导出的，每个文件包含 500 条消息数据（一共有 160 个这样的文件）。开心的是，人们可以使用一般的网络抓取技术 - 特别是[不同的 Beautifulsoup4 方法](https://towardsdatascience.com/soup-of-the-day-97d71e6c07ec) - 自动完成数据框的搭建，其中每一行代表一条消息。

![我不记得当时我们讨论的是哪个美国人了...](https://cdn-images-1.medium.com/max/2000/1*hMlh66eaIhTUbmRa2a_Hrg.png)

注意 - 这里的一个关键特征是 Timestamp 这列。在我们稍后使用的Pandas的方法中，这是重要的 ‘datetime’ 类型，而不是简单的字符串。用 Pandas 自带的 to_datetime 方法是可以很容易实现：

```python
df[‘Timestamp’] = pd.to_datetime(df[‘Timestamp’], dayfirst=True)
```

Telegram HTML 文件用 dd/mm/yyyy 的格式给出时间戳。因此，我们将 **‘dayfirst’** 参数传入，以确保字符串是这样被解释的（即，5/4/2020 应该读作 4 月 5 日，而不是 5 月 4 日）。

那我们能够用这个数据集做什么呢？我们当然可以尝试一些 NLP 工作（这可能是我未来一个博客的主题 - 关于我们在一起的时间里，我们的词汇是如何汇聚到一起的，我有一些假设... ...）现在，我们简单地思考下如何可视化我们时间序列的数据，以及怎样的可视化可以最好地进行表达以利于观点的提取。

---

我们首先通过创建每天发送的消息的折线图了解下我们的消息数量在过去的五年是怎样变化的。Pandas 自带的一个方法可通过给定的时间间隔聚合数据（例如，每天消息的计数）。

```python
df.set_index('Timestamp').groupby(pd.Grouper(freq ='D')).count()
```

There are several chained methods here — let’s break it down:

* **.set_index(‘Timestamp’)** **首先, 我们需要日期时间的特征作为索引。**
* **.groupby(pd.Grouper())** **这个操作类似一个 [标准的 pandas 分组](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html)， 但它并不是对列中唯一元素的创建索引，而是创建了一个样本中介于（和包含）‘最小’日期和‘最大’日期之间的日期索引。重要的是，这还会创建数据集中未考虑的行（例如，一些天中我们没有发送消息）。**
* **freq=‘D’**** 这个频率不一定是‘天’ —— 我们可以设置成想要的任何时间间隔（M 代表月等）**
* **.count()**** 类似一个标准的分组,我们需要调用一个聚合方法来创建实际的数据框。**

所以这个标准折线图中是什么样子呢？

![](https://cdn-images-1.medium.com/max/2000/1*5Ti9rnJOLiNxCzJuBEe39w.png)

大多数时候是一团糟。

如果我们查看每天的总字数（也就是我们的数据并没有因为我把句子中的每个子句作为单独的信息发送而受到影响，这显然令人恼火），这并没有多好。

![](https://cdn-images-1.medium.com/max/2000/1*9UyxPHsq11K1bQ91PVDdZg.png)

然而，这儿**有**一些东西是我们可以从这些图表得到的：

* 我们通常保持上限在大约 150 条消息，或是 600 字；
* 在我们分开的两个圣诞节我们发了很多消息（两个峰值分别在 2015 年和 2016 年），而不是我们一起过的圣诞节（2017,2018 和 2019）
* 我们互相发送消息的总量并不**像是**随着时间增长变化了很多

让我们更深入一点探究最后一点。图表显示，即使在过去的五年里，每天的消息量有一个非常稳定的上限，但是每天都在剧烈波动（我们今天互发 500 字，然后明天就不会发消息了）。

我们可以通过使用移动平均来整理下 —— 换句话说，某一天的数值计算为过去 **x** 天的平均值。这就表明我们上面锯齿状的图，在理论上，应当是平滑的（特别是当我们增加窗口宽度 **x** 时).这应该揭示了任何潜在的趋势。

Pandas对此有一个便利的方法：

```python
df[‘WordCount’].rolling(window = x).mean()
```

* 我们可以改变 **x** 设置窗口宽度
* 我们不需要使用平均 —— 可以滚动求和等。
* 这将创建一个与原始序列相同长度的新序列，但是第一个 **x**-1 元素是 NaN 值

现在让我们看看每天交换的总字数，划分发送人，窗口宽度增加（1 个星期，4 个星期和 8 个星期）。同时加上两条红色的垂线：

1. 我们同居时（2017 年四月）
2. 我们搬到城市，我开始在家里学习时（2019 年五月）

![](https://cdn-images-1.medium.com/max/2000/1*rPSnTDMvIg2_O9w1isb6NA.png)

![](https://cdn-images-1.medium.com/max/2000/1*22zoIEKEwkzCLte3gTVigQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*FHaiXTqFdvP3993yXSvTLQ.png)

56天的移动平均开始让一些事情变得更清楚了：

* 在我们同居之前（第一条红线的左边）我们每天发送更多的文字
* 我的女朋友每天发送的文字一直比我发送的多
* 然而，当我们搬到城市并且她开始忙于一个要求很高的客户项目时，她的消息发送量降到和我一样的水平了 ——她没有更多的时间去发送正常水平的消息量，但是当我发送信息时，她显然还是足够体贴地回复了
* 对时间序列最右边的封锁确实导致了每天互发消息量的急速下降...

---

当然，现代消息不仅仅只是你发送的文字（这儿有个缘由[2015 年牛津词典年度词汇](https://www.theverge.com/2015/11/16/9746650/word-of-the-year-emoji-oed-dictionary)是一个表情符号)。惊讶的是，Telegram HTML 的初始版本实际保留了最原始的表情符号。

![](https://cdn-images-1.medium.com/max/2000/1*2_iBufQhAZMq7sJK1zkrZw.png)

原始的Python并不兼容这些字符，然而有一个[小包（想象中称为 “emoji”）](https://pypi.org/project/emoji/)允许你识别、计算和解码字符串中的表情符号为。

如果我们研究‘非文本’消息，可以发现表情符号对于我女朋友是一种非常重要的沟通方式。从另一方面，我通过分享照片、链接（通常是 Reddit 的）和[贴纸]。
![](https://cdn-images-1.medium.com/max/2000/1*fZAjwVn3eED7un7BDeCbYA.png)（Telegram 较早推出的一个功能）来增加数值。

![](https://cdn-images-1.medium.com/max/2000/1*fZAjwVn3eED7un7BDeCbYA.png)

我们可以尝试用同样的移动平均的技巧弄清这些非文本消息量是如何随着时间变化的。然而，除了2018年早期使用贴纸出现的高峰（当我们发现可以下载自定义的集合时——可真是一个转折性的时刻），并没有很多可辨别的迹象。

![](https://cdn-images-1.medium.com/max/2000/1*RvNiHOMYgTQw_PXOit6DfQ.png)
 
相反，让我们创建一个图，按类型显示这些非文本消息的累积情况。为此，我们可以用 NumPy 的 cumsum() 方法，这个方法将会计算一个序列的累加和。假设我们有一个数据框，其索引是一个日期范围，并且每列描述了那当天发送的每种类型的消息数量：

```python
#创建一个消息类型的列表
required_cols = ['Emoji','Photo','Sticker','Link','Voice message','Animation']

#为这些类型创建一个新的数据框架
df_types_cum = df_types[required_cols]

#通过每列迭代进行替代
#每一个都是累加和
for i in required_cols:
    df_types_cum[i] = np.cumsum(df_types_cum[i])

#使用Pandas自带的绘图方法显示
df_types_cum.plot.area(figsize=(15,6), lw=0)
```

这生成了下面的图表。

![](https://cdn-images-1.medium.com/max/2000/1*fmij_Ww5MgMZ1HSEzyTqDQ.png)

再次，我们可以看见贴纸（琥珀色部分）的引进和使用，也可以看到自2018年起表情符号的使用增加。

---

我们前面的分析没有涉及到的是一天里我们互发消息（只是每天的数量）的时间。这种情况的可视化可能很快就会变得非常混乱。一天已经有 24 小时了 —— 如果我们还想知道基于其他标准（例如，一周中的哪一天、一年中的哪一天等）是否会存在差异，那我们需要在一个图里传递大量的可视化数据。

热图让我们能够做得相当整洁。在这里，我已经创建了一个数据框显示了我们开始同居前后每天每小时发送的（利用 Pandas 的 pivot_table 方法）的文字总量：

```python
df_times = pd.pivot_table(df,fill_value=0,
               index=['LivingTogether','Day'],
               columns='Hour',
               aggfunc='sum')['WordCount'].T

#注意 —— 代码结尾的.T转置了数据框
```

然后，我可以得到每个小时的平均文字量，通过将数据框划为两个部分：没同居时、同居时合适的周数。我们就可以使用 Seaborn 的热图方法可视化数据框了。

```python
sns.heatmap(df_times)
```

![](https://cdn-images-1.medium.com/max/2000/1*BVcJll7c7pqjOK96iKMSyg.png)

在加上一些垂直和水平线划分工作时间和周末后，我们可以轻松地从热图得到视觉信息。在同居之前，我们一整天都在发消息，尤其在睡前（周五和周六的灰白色正方形，表明我们更可能对方的住处过夜）。

在同居后，可以看到我们发消息受到了工作时间的限制。有趣的是，看起来一天中这个时间段的消息总量实际上增加了。也可以发现我们的睡眠时间在这段时间显著增加了 —— 发信息到凌晨 1 点的日子早已一去不复返了。

---

感谢阅读完了这则博客！我很乐意听取关于上述分析的任何意见，或者是这则博客涉及的任何概念。请在下方留言，或者通过[领英](https://www.linkedin.com/in/callum-ballard/)联系我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
