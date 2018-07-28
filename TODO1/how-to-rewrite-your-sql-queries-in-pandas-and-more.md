> * 原文地址：[How to rewrite your SQL queries in Pandas, and more](https://codeburst.io/how-to-rewrite-your-sql-queries-in-pandas-and-more-149d341fc53e)
> * 原文作者：[Irina Truong](https://codeburst.io/@itruong?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-rewrite-your-sql-queries-in-pandas-and-more.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-rewrite-your-sql-queries-in-pandas-and-more.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[DAA233](https://github.com/DAA233)

# 如何使用 Pandas 重写你的 SQL 查询以及其他操作

![](https://cdn-images-1.medium.com/max/800/1*gKYCyrcudAeE5e5KAbRhBQ.jpeg)

15 年前，软件开发人员只需掌握很少的一些技能，他或她就有机会获得 95% 的工作机会。这些技能包括：

*   面向对象编程
*   脚本语言
*   JavaScript 以及其他
*   SQL

当您需要快速浏览一些数据并得出初步结论时，SQL 是一种常用的工具，这些结论可能会产生一个分析报告或者是编写一个应用程序。这被称之为 **探索性分析**。

现如今，数据会以各种各样的形式出现，不再仅仅是“关系型数据库”的同义词。您的数据可能会是 CSV 文件、纯文本、Parquet、HDF5，或者其他什么格式。这些正是 **Pandas** 库的亮点所在。

### 什么是 Pandas？

Pandas，即 Python 数据分析库（Python Data Analysis Library），是一个用于数据分析和处理的 Python 库。它是开源的，被 Anaconda 所支持。它特别适合结构化（表格化）数据。有关更多信息,请参考 [http://pandas.pydata.org/pandas-docs/stable/index.html](http://pandas.pydaxta.org/pandas-docs/stable/index.html)。

### 使用它可以做什么？

之前您在 SQL 里面进行的查询数据以及其他各种操作，都可以由 Pandas 完成！

### 太好了！我要从哪里开始呢？

对于已经习惯于用 SQL 语句来处理数据问题的人来说，这是一个令人生畏的部分。

SQL 是一种 **声明式编程语言**：[https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Declarative_languages.](https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Declarative_languages)。

使用 SQL，你通过声明语句来声明想要的内容，这些声明读起来几乎就如同普通英文短句一样顺畅。

而 **Pandas** 的语法与 SQL 完全不同。在 **pandas** 中，您对数据集进行处理，并将它们链在一起，以便按照您希望的方式进行转换和重构。

我们需要一本 **phrasebook（常用语手册）！**

### 剖析 SQL 查询

SQL 查询由几个重要的关键字组成。在这些关键字之间，添加您想要看到的具体数据。下面是一些没有具体数据的查询语句的框架：

SELECT… FROM… WHERE…

GROUP BY… HAVING…

ORDER BY…

LIMIT… OFFSET…

当然还有其他命令，但上面这些是最重要的。那么我们如何将这些命令在 Pandas 实现呢？

首先，我们需要向 Pandas 里面加载一些数据，因为它们还没有在数据库中。如下所示：

```Python
import pandas as pd

airports = pd.read_csv('data/airports.csv')
airport_freq = pd.read_csv('data/airport-frequencies.csv')
runways = pd.read_csv('data/runways.csv')
```

我的数据来自 [http://ourairports.com/data/](http://ourairports.com/data/)。

### SELECT, WHERE, DISTINCT, LIMIT

这是一些 SELECT 语句。我们使用 LIMIT 来截取结果，使用 WHERE 来进行过滤筛选，使用 DISTINCT 去除重复的结果。

|  SQL  |   Pandas  |
|:-----:|:---------:|
| select * from airports         | airports         |
| select * from airports limit 3 | airports.head(3) |
| select id from airports where ident = 'KLAX' | airports[airports.ident == 'KLAX'].id |
| select distinct type from airport | airports.type.unique() |

### 使用多个条件进行 SELECT 操作

我们将多个条件通过符号 & 组合在一起。如果我们只想要表格列中条件的子集条件，那么可以通过添加另外一对方括号来表示。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select * from airports where iso_region = 'US-CA' and type = 'seaplane_base' | airports[(airports.iso_region == 'US-CA') & (airports.type == 'seaplane_base')] |
| select ident, name, municipality from airports where iso_region = 'US-CA' and type = 'large_airport' | airports[(airports.iso_region == 'US-CA') & (airports.type == 'large_airport')][['ident', 'name', 'municipality']] |

### ORDER BY（排序）

默认情况下，Pandas 会使用升序排序。如果要使用降序，请设置 asending=False。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select * from airport_freq where airport_ident = 'KLAX' order by type      | airport_freq[airport_freq.airport_ident == 'KLAX'].sort_values('type') |
| select * from airport_freq where airport_ident = 'KLAX' order by type desc | airport_freq[airport_freq.airport_ident == 'KLAX'].sort_values('type', ascending=False) |

### IN… NOT IN（包含……不包含）

我们知道了如何对值进行筛选，但如何对一个列表进行筛选呢，如同 SQL 的 IN 语句那样？在 Pandas 中，**.isin()** 操作符的工作方式与 SQL 的 IN 相同。要使用否定条件，请使用 **~**。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select * from airports where type in ('heliport', 'balloonport') | airports[airports.type.isin(['heliport', 'balloonport'])]  |
| select * from airports where type not in ('heliport', 'balloonport') | airports[~airports.type.isin(['heliport', 'balloonport'])] |

### GROUP BY, COUNT, ORDER BY（分组）

分组操作很简单：使用 **.groupby()** 操作符。SQL 和 pandas 中的 **COUNT** 语句存在微妙的差异。在 Pandas 中，**.count()** 将返回非空/非 NaN 的值。要获得与 SQL **COUNT** 相同的结果，请使用 **.size()**。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select iso_country, type, count(&ast;) from airports group by iso_country, type order by iso_country, type | airports.groupby(['iso_country', 'type']).size() |
| select iso_country, type, count(&ast;) from airports group by iso_country, type order by iso_country, count(&ast;) desc | airports.groupby(['iso_country', 'type']).size().to_frame('size').reset_index().sort_values(['iso_country', 'size'], ascending=[True, False]) |

下面，我们对多个字段进行分组。Pandas 默认情况下将对列表中相同字段上的内容进行排序，因此在第一个示例中不需要 `.sort_values()`。如果我们想使用不同的字段进行排序，或者想使用 **DESC** 而不是 **ASC**，就像第二个例子那样，那我们就必须明确使用 **.sort_values()**：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select iso_country, type, count(&ast;) from airports group by iso_country, type order by iso_country, type | airports.groupby(['iso_country', 'type']).size() |
| select iso_country, type, count(&ast;) from airports group by iso_country, type order by iso_country, count(&ast;) desc | airports.groupby(['iso_country', 'type']).size().to_frame('size').reset_index().sort_values(['iso_country', 'size'], ascending=[True, False]) |

其中使用 **.to_frame()** 和 **reset_index()** 是为什么呢？因为我们希望通过计算出的字段（**size**）进行排序，所以这个字段需要成为 **DataFrame** 的一部分。在 Pandas 中进行分组之后，我们得到了一个名为 **GroupByObject** 的新类型。所以我们需要使用 **.to_frame()** 把它转换回 **DataFrame** 类型。再使用 `.reset_index()`，我们重新进行数据帧的行编号。

### HAVING（包含）

在 SQL 中，您可以使用 HAVING 条件语句对分组数据进行追加过滤。在 Pandas 中，您可以使用 **.filter()** ，并给它提供一个 Python 函数（或 lambda 函数），如果结果中包含这个组，该函数将返回 **True**。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select type, count(&ast;) from airports where iso_country = 'US' group by type having count(&ast;) > 1000 order by count(&ast;) desc | airports[airports.iso_country == 'US'].groupby('type').filter(lambda g: len(g) > 1000).groupby('type').size().sort_values(ascending=False) |

### 前 N 个记录

假设我们做了一些初步查询，现在有一个名为 **by_country** 的 dataframe，它包含每个国家的机场数量：

![](https://cdn-images-1.medium.com/max/800/0*7BtzYznnc0Eu5Ghv.)

在接下来的第一个示例中，我们通过 **airport_count** 来进行排序，只选择数量最多的 10 个国家。第二个例子比较复杂，我们想要“前 10 名之后的另外 10 名，即 11 到 20 名”：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select iso_country from by_country order by size desc limit 10 | by_country.nlargest(10, columns='airport_count') |
| select iso_country from by_country order by size desc limit 10 offset 10 | by_country.nlargest(20, columns='airport_count').tail(10) |

### 聚合函数（MIN，MAX，MEAN）

现在给定一组 dataframe，或者一组跑道数据：

![](https://cdn-images-1.medium.com/max/800/0*dl1ZaGt2fYUDlfIL.)

计算跑道长度的最小值，最大值，平均值和中值：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select max(length_ft), min(length_ft), mean(length_ft), median(length_ft) from runways | runways.agg({'length_ft': ['min', 'max', 'mean', 'median']}) |

您会注意到，使用 SQL 查询，每个统计结果都是一列数据。但是使用 Pandas 的聚集方法，每个统计结果都是一行数据：

![](https://cdn-images-1.medium.com/max/800/0*5uJqmyB2KdwpsoY5.)

不用担心 — 只需将 dataframe 通过 **.T** 进行转换就可以得到成列的数据：

![](https://cdn-images-1.medium.com/max/800/0*hONoWL47JSn4LdwW.)

### JOIN（连接）

使用 **.merge()** 来连接 Pandas 的 dataframes。您需要提供要连接哪些列（left_on 和 right_on）和连接类型：**inner**（默认），**left**（对应 SQL 中的 LEFT OUTER），**right**（RIGHT OUTER），或 **OUTER**（FULL OUTER）。

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select airport_ident, type, description, frequency_mhz from airport_freq join airports on airport_freq.airport_ref = airports.id where airports.ident = 'KLAX' | airport_freq.merge(airports[airports.ident == 'KLAX'][['id']], left_on='airport_ref', right_on='id', how='inner')[['airport_ident', 'type', 'description', 'frequency_mhz']] |

### UNION ALL and UNION（合并）

使用 **pd.concat()** 替代 **UNION ALL** 来合并两个 dataframes：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| select name, municipality from airports where ident = 'KLAX' union all select name, municipality from airports where ident = 'KLGB' | pd.concat([airports[airports.ident == 'KLAX'][['name', 'municipality']], airports[airports.ident == 'KLGB'][['name', 'municipality']]]) |

合并过程中想要删除重复数据（等价于 **UNION**），你还需要添加 **.drop_duplicates()**。

### INSERT（插入）

到目前为止，我们一直在讲筛选，但是在您的探索性分析过程中，您可能也需要修改。如果您想添加一些遗漏的记录你该怎么办?

Pandas 里面没有形同 **INSERT** 语句的方法。相反，您只能创建一个包含新记录的新 dataframe，然后合并两个 dataframe：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| create table heroes (id integer, name text); | df1 = pd.DataFrame({'id': [1, 2], 'name': ['Harry Potter', 'Ron Weasley']}) |
| insert into heroes values (1, 'Harry Potter'); | df2 = pd.DataFrame({'id': [3], 'name': ['Hermione Granger']}) |
| insert into heroes values (2, 'Ron Weasley'); | |
| insert into heroes values (3, 'Hermione Granger'); | pd.concat([df1, df2]).reset_index(drop=True) |

### UPDATE（更新）

现在我们需要修改原始 dataframe 中的一些错误数据：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| update airports set home_link = 'http://www.lawa.org/welcomelax.aspx' where ident == 'KLAX' | airports.loc[airports['ident'] == 'KLAX', 'home_link'] = 'http://www.lawa.org/welcomelax.aspx' |

### DELETE（删除）

从 Pandas dataframe 中“删除”数据的最简单(也是最易读的)方法是将 dataframe 提取包含您希望保留的行数据的子集。或者，您可以通过获取行索引来进行删除，使用 **.drop()** 方法删除这些索引的行：

|  SQL  |  Pandas  |
|:-----:|:--------:|
| delete from lax_freq where type = 'MISC' | lax_freq = lax_freq[lax_freq.type != 'MISC'] |
|  | lax_freq.drop(lax_freq[lax_freq.type == 'MISC'].index) |

### Immutability（不变性）

我需要提及一件重要的事情 — 不可变性。默认情况下，大部分应用于 Pandas dataframe 的操作符都会返回一个新对象。有些操作符可以接收 **inplace=True** 参数，这样您可以继续使用原始的 dataframe。例如，以下是一个就地重置索引的方法：

```Python
df.reset_index(drop=True, inplace=True)
```

然而,上面的 **UPDATE** 示例中的 **.loc** 操作符仅定位需要更新记录的索引，并且这些值会就地更改。此外，如果您更新了一列的所有值：

```Python
df['url'] = 'http://google.com'
```

或者添加一个计算得出的新列：

```Python
df['total_cost'] = df['price'] * df['quantity']
```

这些都会就地发生变化。

### 更多！

Pandas 的好处在于它不仅仅是一个查询引擎。你可以用你的数据做更多事情，例如：

*   以多种格式输出：

```Python
df.to_csv(...)  # csv file
df.to_hdf(...)  # HDF5 file
df.to_pickle(...)  # serialized object
df.to_sql(...)  # to SQL database
df.to_excel(...)  # to Excel sheet
df.to_json(...)  # to JSON string
df.to_html(...)  # render as HTML table
df.to_feather(...)  # binary feather-format
df.to_latex(...)  # tabular environment table
df.to_stata(...)  # Stata binary data files
df.to_msgpack(...)	# msgpack (serialize) object
df.to_gbq(...)  # to a Google BigQuery table.
df.to_string(...)  # console-friendly tabular output.
df.to_clipboard(...) # clipboard that can be pasted into Excel
```

*   绘制图表：

```Python
top_10.plot(
    x='iso_country', 
    y='airport_count',
    kind='barh',
    figsize=(10, 7),
    title='Top 10 countries with most airports')
```

去看看一些很不错的图表！

![](https://cdn-images-1.medium.com/max/800/0*wiV3vIJWP7_c3sT7.)

*   共享：

共享 Pandas 查询结果、绘图和相关内容的最佳媒介是 Jupyter notebooks（[http://jupyter.org/](http://jupyter.org/)）。事实上，有些人（比如杰克·范德普拉斯（Jake Vanderplas），他太棒了）会把整本书都发布在 Jupyter notebooks 上：[https://github.com/jakevdp/PythonDataScienceHandbook](https://github.com/jakevdp/PythonDataScienceHandbook)。

很简单就可以创建一个新的笔记本：

```Python
pip install jupyter
jupyter notebook
```

之后：
- 打开 localhost:8888
- 点击“新建”，并给笔记本起个名字
- 查询并显示数据
- 创建一个 GitHub 仓库，并添加您的笔记本到仓库中（后缀为 **.ipynb** 的文件）。

GitHub 有一个很棒的内置查看器，可以以 Markdown 的格式显示 Jupyter notebooks 的内容。

### 现在，你可以开始你的 Pandas 之旅了！

我希望您现在确信，Pandas 库可以像您的老朋友 SQL 一样帮助您进行探索性数据分析，在某些情况下甚至会做得更好。是时候你自己动手开始在 Pandas 里查询数据了！

[![](https://cdn-images-1.medium.com/max/1000/1*i3hPOj27LTt0ZPn5TQuhZg.png)](http://bit.ly/codeburst)

> ✉️ _Subscribe to_ CodeBurst’s _once-weekly_ [**_Email Blast_**](http://bit.ly/codeburst-email)**_,_** 🐦 _Follow_ CodeBurst _on_ [**_Twitter_**](http://bit.ly/codeburst-twitter)_, view_ 🗺️ [**_The 2018 Web Developer Roadmap_**](http://bit.ly/2018-web-dev-roadmap)_, and_ 🕸️ [**_Learn Full Stack Web Development_**](http://bit.ly/learn-web-dev-codeburst)_._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
