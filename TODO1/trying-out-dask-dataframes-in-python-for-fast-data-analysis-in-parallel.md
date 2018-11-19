> * 原文地址：[How to Run Parallel Data Analysis in Python using Dask Dataframes](https://towardsdatascience.com/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel-aa960c18a915)
> * 原文作者：[Luciano Strika](https://towardsdatascience.com/@StrikingLoo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/trying-out-dask-dataframes-in-python-for-fast-data-analysis-in-parallel.md)
> * 译者：
> * 校对者：

# How to Run Parallel Data Analysis in Python using Dask Dataframes

![](https://cdn-images-1.medium.com/max/800/1*SQtRhdtx46Lq1LLvFwbc0Q.jpeg)

Your mind on multi-cores. source: [Pixabay](https://pixabay.com/en/universe-star-space-cosmos-sky-1351865/)

Sometimes you open a big Dataset with [Python’s Pandas](https://towardsdatascience.com/exploratory-data-analysis-with-pandas-and-jupyter-notebooks-36008090d813), try to get a few metrics, and the whole thing just freezes horribly.  
If you work on Big Data, you know if you’re using Pandas, you can be waiting for up to a whole minute for a simple average of a Series, and let’s not even get into calling _apply_. And that’s just for a couple million rows! When you get to the billions, you better start using Spark or something.

I found out about this tool a short while ago: a way to speed up Data Analysis in Python, without having to get better infrastructure or switching languages. It will eventually feel limited if your Dataset is huge, but it scales a lot better than regular Pandas, and may be just the fit for your problem — especially if you’re not doing a lot of reindexing.

#### What is Dask?

[Dask](https://github.com/dask/dask-tutorial) is an Open Source project that gives you abstractions over NumPy Arrays, Pandas Dataframes and regular lists, allowing you to run operations on them in parallel, using multicore processing.

Here’s an excerpt straight from the tutorial:

> Dask provides high-level Array, Bag, and DataFrame collections that mimic NumPy, lists, and Pandas but can operate in parallel on datasets that don’t fit into main memory. Dask’s high-level collections are alternatives to NumPy and Pandas for large datasets.

It’s as awesome as it sounds! I set out to try the Dask Dataframes out for this Article, and ran a couple benchmarks on them.

#### Reading the docs

What I did first was read the official documentation, to see what exactly was recommended to do in Dask’s instead of regular Dataframes. Here are the relevant parts from the [official docs](http://dask.pydata.org/en/latest/dataframe.html):

*   Manipulating large datasets, even when those datasets don’t fit in memory
*   Accelerating long computations by using many cores
*   Distributed computing on large datasets with standard Pandas operations like groupby, join, and time series computations

And then below that, it lists some of the things that are really fast if you use Dask Dataframes:

*   Arithmetic operations (multiplying or adding to a Series)
*   Common aggregations (mean, min, max, sum, etc.)
*   Calling _apply (as long as it’s along the index -that is, not after a groupby(‘y’) where ‘y’ is not the index-)_
*   Calling value_counts(), drop_duplicates() or corr()
*   Filtering with _loc_, _isin_, and row-wise selection

Just a small brush up on filtering Dataframes, in case you find it useful.

```
#returns only the rows where x is >5, by reference (writing on them alters original df)
df2 = df.loc[df['x'] > 5] 
#returns only the rows where x is 0,1,2,3 or 4, by reference
df3 = df.x.isin(range(4)) 
#returns only the rows where x is >5, by read-only reference (can't be written on)
df4 = df[df['x']>5]
```

#### How to use Dask Dataframes

Dask Dataframes have the same API as Pandas Dataframes, except aggregations and _apply_s are evaluated lazily, and need to be computed through calling the _compute_ method. In order to generate a Dask Dataframe you can simply call the _read_csv_ method just as you would in Pandas or, given a Pandas Dataframe _df_, you can just call

```
dd = ddf.from_pandas(df, npartitions=N)
```

Where _ddf_ is the name you imported Dask Dataframes with, and _npartitions_ is an argument telling the Dataframe how you want to partition it.

According to StackOverflow, it is advised to partition the Dataframe in about as many partitions as cores your computer has, or a couple times that number, as each partition will run on a different thread and communication between them will become too costly if there are too many.

#### Getting dirty: Let’s benchmark!

I made a Jupyter Notebook to try out the framework, and made it [available on Github](https://github.com/StrikingLoo/dask-dataframe-benchmarking) in case you want to check it out or even run it for yourself.

The benchmarking tests I ran are available in the notebook at Github, but here are the main ones:

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

Here _df3_ is a regular Pandas Dataframe with 25 million rows, generated using the script from the [previous article](https://github.com/StrikingLoo/pandas_workshop) (columns are _name, surname_ and _salary_, sampled randomly from a list). I took a 50 rows Dataset and concatenated it 500000 times, since I wasn’t too interested in the analysis _per se_, but only in the time it took to run it.

_dfn_ is simply the Dask Dataframe based on _df3_.

#### First batch of results: not too optimistic

I first tried the test with 3 partitions, as I only have 4 cores and didn’t want to overwork my PC. I had pretty bad results with Dask and had to wait a lot to get them too, but I feared it may had been because I’d made too few partitions:

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

You can see most of the operations turned a lot slower when I used Dask. That gave me the hint that I may have had to use more partitions. The amount that generating the lazy evaluations took was negligible as well (less than half a second in some cases), so it’s not like it would have got amortized over time if I reused them.

I also tried this test with the _apply_ method:

```
def f(x):
    return (13*x+5)%7

def apply_random_old():
    df3['random']= df3['salary'].apply(f)
    
def apply_random():
    dfn['random']= dfn['salary'].apply(f).compute()
```

And had pretty similar results:

```
369.541605949 seconds for apply_random
157.643756866 seconds for apply_random_old
```

So generally, most operations became twice as slow as the original, though filter was a lot faster. I am worried maybe I should have called _compute_ on that one as well, so take that result with a grain of salt.

#### More partitions: amazing speed up

After such discouraging results, I decided maybe I was just not using enough partitions. The whole point of this is running things in parallel, after all, so maybe I just needed to parallelize more? So I tried the same tests with 8 partitions, and here’s what I got (I omitted the results from the non-parallel dataframe, since they were basically the same):

```
3.08352184296 seconds for get_big_mean
1.3314101696 seconds for get_big_max
1.21639800072 seconds for get_big_sum
0.228978157043 seconds for filter_df

112.135010004 seconds for apply_random
50.2007009983 seconds for value_count_test
```

That’s right! Most operations are running over ten times faster than the regular Dataframe’s, and even the _apply_ got faster! I also ran the _value_count_ test, which just calls the _value_count_ method on the _salary_ Series. For context, keep in mind I had to kill the process when I ran this test on a regular Dataframe after ten whole minutes of waiting. This time it only took 50 seconds!  
So basically I was just using the tool wrong, and it’s pretty darn fast. A lot faster than regular Dataframes.

#### Final take-away

Given we just operated with 25 million rows in under a minute on a pretty old 4-core PC, I can see how this would be huge in the industry. So my advice is try this Framework out next time you have to process a Dataset locally or from a single AWS instance. It’s pretty fast.

I hope you found this article interesting or useful! It took a lot more time to write it than I anticipated, as some of the benchmarks took _so long_. Please tell me if you’d ever heard of Dask before reading this, and whether you’ve ever used it in your job or for a project. Also tell me if there are any other cool features I didn’t cover, or some things I did plain wrong! Your feedback and comments are the biggest reason I write, as I am also learning from this.

_Follow me for more Python tutorials, tips and tricks! If you really liked this article, please consider_ [_supporting my writing_](http://buymeacoffee.com/strikingloo)_._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
