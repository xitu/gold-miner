> * 原文地址：[How to Run Parallel Data Analysis in Python using Dask Dataframes](https://towardsdatascience.com/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel-aa960c18a915)
> * 原文作者：[Luciano Strika](https://towardsdatascience.com/@StrikingLoo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel.md)
> * 译者：[Starriers](https://github.com/Starriers)
> * 校对者：[snpmyn](https://github.com/snpmyn)

# 在 Python 中，如何运用 Dask 数据进行并行数据分析

![](https://cdn-images-1.medium.com/max/800/1*SQtRhdtx46Lq1LLvFwbc0Q.jpeg)

多维度思维。来源：[Pixabay](https://pixabay.com/en/universe-star-space-cosmos-sky-1351865/)

有时你通过 [Python’s Pandas](https://towardsdatascience.com/exploratory-data-analysis-with-pandas-and-jupyter-notebooks-36008090d813) 打开一个大的数据集，然后试着去获取一些度量标准，但这时整个过程可能会突然停止。
如果你使用 Pandas 处理大数据，可能一个简单的序列平均值都需要你等待一分钟，我们甚至不会去调用 **apply**。这还只是百万级别的行数！当你的数据达到亿级别时，你最好使用 Spark 或者其他方式。

我在不久之前发现了这个工具：不需要更好的基础架构或转换语言，就可以在 Python 中加速数据分析的方法。但是如果数据集太大，它的最终优化结果会一定的限制，但是它仍然比常规的 Pandas 扩展性好，可能也更符合你的问题场景 —— 尤其是不进行大量的重写索引时。

#### 什么是 Dask？

[Dask](https://github.com/dask/dask-tutorial) 是一个开源项目，为你提供 NumPy 数组、Pandas Dataframes 以及常规 list 的抽象，允许你使用多核处理器并行运行它们的操作。

以下是来自本教程的摘录：

> Dask 提供了更高级别的 Array、Bag、和 DataFrame 集合，它们模仿 NumPy、list 和 Pandas，但允许在不适合主内存的数据集上并行操作。对于大型数据集，Dask 的高级集合可以取代 NumPy 和 Pandas。 

这听上去很好！为了这篇文章，我特意试用了 Dask Dataframs，并在其上运行了几个基准测试。

#### 阅读文档

我首先阅读了官方文档，看看在 Dask 的文档中的精确推荐，而不是常规 Dataframse。以下是[官方文档](http://dask.pydata.org/en/latest/dataframe.html)的部分内容：

*   操作大型数据集，即使这些数据不适用于内存
*   使用尽可能多的内核来加速长时间计算
*   在大的数据集上，通过标准的 Pandas 操作，如集群、连接、还有时间序列计算，来对计算做分布式处理。

接下来，它列出了一些很快的场景，但前提是你在使用 Dask 数据：

*   算术运算（对序列进行乘或加）
*   常用聚合（均值、最小值、最大值、和等）
*   调用 **apply（只要它是索引，而非 groupby(‘y’)，其中 y 并非索引）**
*   调用 value_counts()、drop_duplicates() 或 corr()
*   用 **Loc**、**isin** 和逐行选择进行过滤

如果发现它有用，只对数据过滤进行一次小浏览就行。

```
#通过引用仅，返回 x >5 的行（根据起初的 df 写入更改）
df2 = df.loc[df['x'] > 5]
#通过引用，仅返回x 为 0、1、2、3 或 4 的行
df3 = df.x.isin(range(4))
#通过只读引用，仅返回 x > 5 的行（不能被写）
df4 = df[df['x']>5]
```

#### 如何使用 Dask Dataframes

Dask Dataframes 具有与 Pandas Dataframes 相似的 API，只有聚合和 **apply** 是延迟计算，你需要通过调用 **compute** 方法来计算。为了生成一个 Dask Dataframe，你可以像在 Pandas 中那样简单调用 **read_csv** 方法，或只调用给定的一个 Pandas Dataframe **df**。

```
dd = ddf.from_pandas(df, npartitions=N)
```

**ddf** 是你使用 DASK Dataframes 导入的名称，而 **nparitions** 是一个参数，它告诉 Dataframe 你期望如何对它进行分区。

StackOverflow，建议将 Dataframe 划分到你计算机内核数目相同的分区中，或是这个数字的几倍，因为每个分区都会运行在不同的线程上，如果有太多线程，它们之间将变得过于昂贵。

#### 开始：进行基准测试！

我开发了一个 Jupyter 笔记来尝试使用这个框架，并且发布在 [Github](https://github.com/StrikingLoo/dask-dataframe-benchmarking) 上，这样你可以查看具体信息甚至是亲自运行它。

我运行的基准测试可以在 GitHub 上获取，这里列举了主要内容：

```
def get_big_mean():
    return dfn.salary.mean().compute()
def get_big_mean_old():
    return df3.salary.mean()

def get_big_max():
    return dfn.salary.max().compute()
def get_big_max_old():
    return df3.salary.max()

def get_big_sum():
    return dfn.salary.sum().compute()
def get_big_sum_old():
    return df3.salary.sum()

def filter_df():
    df = dfn[dfn['salary']>5000]
def filter_df_old():
    df = df3[df3['salary']>5000]
```

这是一个有着 2500 万行的常规 **df3**，内容是使用来自[上一篇文章](https://github.com/StrikingLoo/pandas_workshop)中的脚本生成的（从列表中随机抽取的列名是 **name、surname** 以及 **salary**）。我使用了 50 行数据集，并将其连接了 50 万次，因为我只对它运行所需时间感兴趣，对于分析 **per se** 却不感兴趣。

**dfn** 是基于 **df3** 的 Dask Dataframe。

#### 第一批次的结果：不太乐观

首先，我尝试用 3 个分区进行测试，因为我只有 4 个内核，所以不想过度使用我的 PC。我用 Dask 的结果不是很理想，而且还必须等待很长时间才能获取结果，我担心这可能是因为我做的分区太少了：

```
204.313940048 seconds for get_big_mean
39.7543280125 seconds for get_big_mean_old

131.600986004 seconds for get_big_max
43.7621600628 seconds for get_big_max_old

120.027213097 seconds for get_big_sum
7.49701309204 seconds for get_big_sum_old

0.581165790558 seconds for filter_df
226.700095892 seconds for filter_df_old
```

你可以看到，当我是用 Dask 时，大多数操作的速度都要慢得多。这给我了一个提示，那就是我可能不得不使用更多的分区。生成延迟评估所花费的数量也是可以忽略不计的（在某些情况下不到半秒），如果我重用它们，就不会随着时间的推移而摊销。

我还使用了 **apply** 方法测试它：

```
def f(x):
    return (13*x+5)%7

def apply_random_old():
    df3['random']= df3['salary'].apply(f)
    
def apply_random():
    dfn['random']= dfn['salary'].apply(f).compute()
```

结果并无差别：

```
369.541605949 seconds for apply_random
157.643756866 seconds for apply_random_old
```

因此，一般情况下，尽管过滤器的速度要快得多，但大多数操作的速度仍然是原来的两倍。我担心的是，也许我也应该调用 **compute** 这个函数，所以把这个结果作为对比。

#### 更多分区：惊人的速度

再这样令人沮丧的结果之后，我认为可能是我还没有使用足够的分区。这样做的要点是并行运行，或许是我需要更多的并行化？因此我对 8 个分区进行了相同的测试，下面是我得到的结果（我忽略了非并行 dataframe，因为它们基本是相同的）：

```
3.08352184296 seconds for get_big_mean
1.3314101696 seconds for get_big_max
1.21639800072 seconds for get_big_sum
0.228978157043 seconds for filter_df

112.135010004 seconds for apply_random
50.2007009983 seconds for value_count_test
```

没错，大多数操作的运行速度是常规 Dataframe 的 10 倍以上，**apply** 获得了更快的速度！我还在 **salary** 序列上运行了 **value_count** 方法。对于上下文，请记住，当我在常规的 Dataframe 上运行这个测试时，我等待了 10 分钟之后，我不得不停止这个过程，这一次只花了 50 秒！
基本上，我只是用错了工具，而且非常快。比普通的 Dataframes 快得多。

#### 结论

考虑到我在一台非常旧的 4 核 PC 上，一分钟内运行 2.5 亿行内容，我觉得它会在实际应用中有着举足轻重的地位。因此我建议，下次你处理本地或从单个 AWS 实例中处理数据集时，可以考虑使用这个框架，它真的非常高效。

我希望你觉得这盘文章有用或者有趣！编写他所花费的时间超过我的预期，因为一些基准测试花费的时间**太长了**。记得告诉我在阅读之前你是否了解过 Dask，或者你是否在工作或项目中使用过它。另外，如果有其他更棒的功能，记得告诉我，我并没有检测我是否做错了什么内容！你的回馈和评论是我写作的重要原因之一，因为我们都在从中成长。

**如果你喜欢这篇文章，可以继续支持我。[可以继续支持我的写作](http://buymeacoffee.com/strikingloo)。同时你还可以在我这里了解更多 Python 教程、提示和技巧！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
