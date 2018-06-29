> * 原文地址：[Pythonic Data Cleaning With NumPy and Pandas](https://realpython.com/python-data-cleaning-numpy-pandas/)
> * 原文作者：[Malay Agarwal](https://realpython.com/team/magarwal/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-data-cleaning-numpy-pandas.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-data-cleaning-numpy-pandas.md)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[luochen1992](https://github.com/luochen1992)，[Hopsken](https://github.com/Hopsken)

# 使用 NumPy 和 Pandas 进行 Python 式数据清理

![](https://files.realpython.com/media/data-cleaning-numpy-pandas.0897550e8675.jpg)

数据科学家花费大量时间清理数据集，将它们清理为可以工作的形式。事实上，很多数据科学家表示，80% 的工作都是获取和清理数据。

因此，不管你是刚刚进入这个领域或者计划进入，那么处理混乱数据的能力会非常重要，无论这意味着缺失值、格式不一致、格式错误还是无意义的异常值。

在此教程中，我们将利用 Pandas 和 NumPy 这两个库来清理数据。

我们将介绍以下内容：

*   删除 `DataFrame` 中不必要的列
*   更改 `DataFrame` 的索引
*   用 `.str()` 方法清理列
*   使用 `DataFrame.applymap()` 函数以元素方式清理数据集
*   将列重命名为更易识别的标签
*   跳过 CSV 文件中不必要的行

这些是我们将要用到的数据集：

*   [BL-Flickr-Images-Book.csv](https://github.com/realpython/python-data-cleaning/blob/master/Datasets/BL-Flickr-Images-Book.csv) – 包含大英图书馆书籍信息的 CSV 文件
*   [university_towns.txt](https://github.com/realpython/python-data-cleaning/blob/master/Datasets/university_towns.txt) – 包含美国各州大学城名称的文本文件
*   [olympics.csv](https://github.com/realpython/python-data-cleaning/blob/master/Datasets/olympics.csv) – 汇总所有国家夏季和冬季奥运会参与情况的 CSV 文件

你可以从 Real Python 的 [GitHub 仓库](https://github.com/realpython/python-data-cleaning) 下载所有数据集，以便查看以下示例。

**注意**：我推荐使用 Jupyter Notebook 来进行以下步骤。

本教程假设你对 Pandas 和 NumPy 库有基本的了解，包括 Pandas 的主要工作对象 [`Series` 和 `DataFrame`](https://pandas.pydata.org/pandas-docs/stable/dsintro.html)，应用于它们的常用方法，以及熟悉 NumPy 的 [`NaN`](https://docs.scipy.org/doc/numpy-1.13.0/user/misc.html) 值。

让我们从 import 这些模块开始吧！

```
>>> import pandas as pd
>>> import numpy as np
```

## 删除 `DataFrame` 中不必要的列

你经常会发现数据集中并非所有类别的数据都对你有用。例如，你可能有一个数据集包含了学生信息（名字、成绩、标准、父母姓名和住址），但你想要专注于分析学生的成绩。

在这种情况下，住址和父母姓名对你来说并不重要，保留这些类别将占用不必要的空间，并可能拖累运行时间。

Pandas 提供了一个很方便的 [`drop()`](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.drop.html) 函数来从 `DataFrame` 中移除列或行。我们来看一个简单的例子，从 `DataFrame` 中删除一些列。

首先，我们从 CSV 文件 “BL-Flickr-Images-Book.csv” 中创建一个 `DataFrame`。在下面的例子中，我们把相对路径传递给 `pd.read_csv`，当前工作路径下，所有的数据集都存放在 `Datasets` 文件夹中：

```
>>> df = pd.read_csv('Datasets/BL-Flickr-Images-Book.csv')
>>> df.head()

    Identifier             Edition Statement      Place of Publication  \
0         206                           NaN                    London
1         216                           NaN  London; Virtue & Yorston
2         218                           NaN                    London
3         472                           NaN                    London
4         480  A new edition, revised, etc.                    London

  Date of Publication              Publisher  \
0         1879 [1878]       S. Tinsley & Co.
1                1868           Virtue & Co.
2                1869  Bradbury, Evans & Co.
3                1851          James Darling
4                1857   Wertheim & Macintosh

                                               Title     Author  \
0                  Walter Forbes. [A novel.] By A. A      A. A.
1  All for Greed. [A novel. The dedication signed...  A., A. A.
2  Love the Avenger. By the author of “All for Gr...  A., A. A.
3  Welsh Sketches, chiefly ecclesiastical, to the...  A., E. S.
4  [The World in which I live, and my place in it...  A., E. S.

                                   Contributors  Corporate Author  \
0                               FORBES, Walter.               NaN
1  BLAZE DE BURY, Marie Pauline Rose - Baroness               NaN
2  BLAZE DE BURY, Marie Pauline Rose - Baroness               NaN
3                   Appleyard, Ernest Silvanus.               NaN
4                           BROOME, John Henry.               NaN

   Corporate Contributors Former owner  Engraver Issuance type  \
0                     NaN          NaN       NaN   monographic
1                     NaN          NaN       NaN   monographic
2                     NaN          NaN       NaN   monographic
3                     NaN          NaN       NaN   monographic
4                     NaN          NaN       NaN   monographic

                                          Flickr URL  \
0  http://www.flickr.com/photos/britishlibrary/ta...
1  http://www.flickr.com/photos/britishlibrary/ta...
2  http://www.flickr.com/photos/britishlibrary/ta...
3  http://www.flickr.com/photos/britishlibrary/ta...
4  http://www.flickr.com/photos/britishlibrary/ta...

                            Shelfmarks
0    British Library HMNTS 12641.b.30.
1    British Library HMNTS 12626.cc.2.
2    British Library HMNTS 12625.dd.1.
3    British Library HMNTS 10369.bbb.15.
4    British Library HMNTS 9007.d.28.
```

当我们使用 `head()` 方法查看前五条数据时，我们可以看到一些列提供了对图书馆来说有用的辅助信息，但是对描述书籍本身并没有太多帮助： `Edition Statement`，`Corporate Author`，`Corporate Contributors`，`Former owner`，`Engraver`，`Issuance type` 和 `Shelfmarks`。

我们可以这样删除这些列：

```
>>> to_drop = ['Edition Statement',
...            'Corporate Author',
...            'Corporate Contributors',
...            'Former owner',
...            'Engraver',
...            'Contributors',
...            'Issuance type',
...            'Shelfmarks']

>>> df.drop(to_drop, inplace=True, axis=1)
```

这里，我们定义了一个列表，其中包含了我们想要删除的列的名字。然后调用 `drop()` 函数，传入 `inplace` 参数为 `True`，以及 `axis` 参数为 `1`。这两个参数告诉 Pandas 我们想要让改变直接作用在对象上，并且我们需要删除的是列。

再次查看 `DataFrame`，可以发现不想要的列已经被移除了：

```
>>> df.head()
   Identifier      Place of Publication Date of Publication  \
0         206                    London         1879 [1878]
1         216  London; Virtue & Yorston                1868
2         218                    London                1869
3         472                    London                1851
4         480                    London                1857

               Publisher                                              Title  \
0       S. Tinsley & Co.                  Walter Forbes. [A novel.] By A. A
1           Virtue & Co.  All for Greed. [A novel. The dedication signed...
2  Bradbury, Evans & Co.  Love the Avenger. By the author of “All for Gr...
3          James Darling  Welsh Sketches, chiefly ecclesiastical, to the...
4   Wertheim & Macintosh  [The World in which I live, and my place in it...

      Author                                         Flickr URL
0      A. A.  http://www.flickr.com/photos/britishlibrary/ta...
1  A., A. A.  http://www.flickr.com/photos/britishlibrary/ta...
2  A., A. A.  http://www.flickr.com/photos/britishlibrary/ta...
3  A., E. S.  http://www.flickr.com/photos/britishlibrary/ta...
4  A., E. S.  http://www.flickr.com/photos/britishlibrary/ta...
```

或者，我们可以通过直接将列传递给 `columns` 参数来删除列，不用单独指定删除的标签以及删除列还是行：

```
>>> df.drop(columns=to_drop, inplace=True)
```

这种方法更直观易读，这一步做了什么是非常明显的。

如果你事先知道那些列是你需要保留的，另外一个选择是将列作为 `usecols` 的参数传给 `pd.read_csv`。

## 更改 `DataFrame` 的索引

Pandas 的 `Index` 扩展了 NumPy 的数组功能，从而可以实现更多功能的截取和标签。在多数情况下，使用数据唯一有价值的标识字段作为索引是很有帮助的。

例如，在上一节使用的数据集中，可以想象到，图书管理员如果需要搜索记录，他也许输入的是书籍的唯一标识符（`Identifier` 列）：

```
>>> df['Identifier'].is_unique
True
```

让我们用 `set_index` 来替换现有的索引：

```
>>> df = df.set_index('Identifier')
>>> df.head()
                Place of Publication Date of Publication  \
206                           London         1879 [1878]
216         London; Virtue & Yorston                1868
218                           London                1869
472                           London                1851
480                           London                1857

                        Publisher  \
206              S. Tinsley & Co.
216                  Virtue & Co.
218         Bradbury, Evans & Co.
472                 James Darling
480          Wertheim & Macintosh

                                                        Title     Author  \
206                         Walter Forbes. [A novel.] By A. A      A. A.
216         All for Greed. [A novel. The dedication signed...  A., A. A.
218         Love the Avenger. By the author of “All for Gr...  A., A. A.
472         Welsh Sketches, chiefly ecclesiastical, to the...  A., E. S.
480         [The World in which I live, and my place in it...  A., E. S.

                                                   Flickr URL
206         http://www.flickr.com/photos/britishlibrary/ta...
216         http://www.flickr.com/photos/britishlibrary/ta...
218         http://www.flickr.com/photos/britishlibrary/ta...
472         http://www.flickr.com/photos/britishlibrary/ta...
480         http://www.flickr.com/photos/britishlibrary/ta...
```

**技术细节**： 与 SQL 中的主键不同，Pandas 的 `Index` 不保证是唯一的，尽管许多索引及合并操作在唯一的情况下运行时会加速。

我们可以使用 `loc[]` 直接访问每条记录。尽管 `loc[]` 可能不具有直观的名称，但它允许我们执行**基于标签的索引**，即标记某一行或某一条记录而不用考虑其位置：

```
>>> df.loc[206]
Place of Publication                                               London
Date of Publication                                           1879 [1878]
Publisher                                                S. Tinsley & Co.
Title                                   Walter Forbes. [A novel.] By A. A
Author                                                              A. A.
Flickr URL              http://www.flickr.com/photos/britishlibrary/ta...
Name: 206, dtype: object
```

换句话说，206 是索引的第一个标签。如要按位置访问它，我们可以使用 `df.iloc[0]`，它执行基于**位置**的索引。

**技术细节**：`.loc[]` 在技术上来说是一个[类实例](https://github.com/pandas-dev/pandas/blob/7273ea0709590e6264607f227bb8def0ef656c50/pandas/core/indexing.py#L1415)，它有一些特殊的[语法](https://pandas.pydata.org/pandas-docs/stable/indexing.html#selection-by-label)不完全符合大多数普通 Python 实例方法。

一开始，我们的索引是一个 RangeIndex，也就是从 0 开始的整数，类似于 Python 内置的 `range`。通过把列的名称传给 `set_index`，我们将索引改成了 `Identifier` 中的值。

你可能注意到，我们使用 `df = df.set_index(...)` 将此方法返回的值重新赋值给变量。这是因为默认情况下，此方法会返回一个修改后的副本，并不会直接对原本的对象进行更改，索引可以通过设置 `inplace` 参数来避免这种情况：

```
df.set_index('Identifier', inplace=True)
```

## 整理数据中的字段

到这里，我们已经删除了不必要的列，并将 `DataFrame` 的索引更改为更有意义的列。在这一节，我们将会清理特定的列，使其成为统一的格式，以便更好地理解数据集并强化一致性。具体来说，我们将清理 `Date of Publication` 和 `Place of Publication` 这两列。

经过检查，所有的数据类型都是 `object` [dtype](http://pandas.pydata.org/pandas-docs/stable/basics.html#dtypes)，它与 Python 中的 `str` 类似。

它封装了任何不适用于数字或分类数据的字段。这是有道理的，因为我们使用的数据最初只是一堆杂乱的字符：

```
>>> df.get_dtype_counts()
object    6
```

其中出版日期一列，如果将其转化为数字类型更有意义，所以我们可以进行如下计算：

```
>>> df.loc[1905:, 'Date of Publication'].head(10)
Identifier
1905           1888
1929    1839, 38-54
2836        [1897?]
2854           1865
2956        1860-63
2957           1873
3017           1866
3131           1899
4598           1814
4884           1820
Name: Date of Publication, dtype: object
```

一本书只能有一个出版日期，因此我们需要做到以下几点：

*   除去方括号内的多余日期，不管出现在哪里，例如：1879 [1878]
*   将日期范围转换为“开始日期”，例如：1860-63; 1839, 38-54
*   完全移除任何不确定的日期，并用 NumPy 的 `NaN` 值替代：[1897?]
*   将字符串 `nan` 也转换为 NumPy 的 `NaN`

综合以上，我们实际上可以利用一个正则表达式来提取出版年份：

```
regex = r'^(\d{4})'
```

这个正则表达式意图在字符串的开头找到四位数字，这足以满足我们的要求。上面是一个原始字符串（这意味着反斜杠不再是转义字符），这是正则表达式的标准做法。

`\d` 表示任何数字，`{4}` 表示重复 4 次，`^` 表示匹配字符串的开头，括号表示一个捕获组，它向 Pandas 表明我们想要提取正则表达式的这部分。（我们希望用 `^` 来避免字符串从 `[` 开始的情况。）

现在让我们来看看我们在数据集中运行这个表达式时会发生什么：

```
>>> extr = df['Date of Publication'].str.extract(r'^(\d{4})', expand=False)
>>> extr.head()
Identifier
206    1879
216    1868
218    1869
472    1851
480    1857
Name: Date of Publication, dtype: object
```

对正则不熟悉？你可以在 regex101.com 这个网站上[查看上面这个正则表达式](https://regex101.com/r/3AJ1Pv/1)，也可以阅读更多 Python 正则表达式 [HOWTO](https://docs.python.org/3.6/howto/regex.html) 上的教程。

从技术上讲，这一列仍然是 `object` dtype，但是我们用 `pd.to_numeric` 即可轻松获取数字：

```
>>> df['Date of Publication'] = pd.to_numeric(extr)
>>> df['Date of Publication'].dtype
dtype('float64')
```

这么做会导致十分之一的值丢失，但这相对于能够对剩余的有效值上进行计算而已，是一个比较小的代价：

```
>>> df['Date of Publication'].isnull().sum() / len(df)
0.11717147339205986
```

很好！本节完成了！

## 结合 NumPy 以及 `str` 方法来清理列

上一部分，你可能已经注意到我们使用了 `df['Date of Publication'].str`。这个属性是访问 Pandas 的快速[字符串操作](https://pandas.pydata.org/pandas-docs/stable/text.html)的一种方式，它主要模仿了原生 Python 中的字符串或编译的正则表达式方法，例如 `.split()`、`.replace()`、`.capitalize()`。

为了清理 `Place of Publication` 字段，我们可以结合 Pandas 的 `str` 方法以及 NumPy 的 `np.where` 函数，这个函数基本上是 Excel 里的 `IF()` 宏的矢量化形式。它的语法如下：

```
>>> np.where(condition, then, else)
```

这里，`condition` 可以是一个类似数组的对象或者一个布尔遮罩，如果 `condition` 为 `True`，则使用 `then` 值，否则使用 `else` 值。

从本质上来说，`.where()` 函数对对象中的每个元素进行检查，看 `condition` 是否为 `True`，并返回一个 `ndarray` 对象，包含`then` 或者 `else` 的值。

它也可以被用于嵌套的 if-then 语句中，允许我们根据多个条件进行计算：

```
>>> np.where(condition1, x1, 
        np.where(condition2, x2, 
            np.where(condition3, x3, ...)))
```

我们将用这两个函数来清理 `Place of Publication` 一列，因为此列包含字符串。以下是该列的内容：

```
>>> df['Place of Publication'].head(10)
Identifier
206                                  London
216                London; Virtue & Yorston
218                                  London
472                                  London
480                                  London
481                                  London
519                                  London
667     pp. 40. G. Bryan & Co: Oxford, 1898
874                                 London]
1143                                 London
Name: Place of Publication, dtype: object
```

我们发现某些行中，出版地被其他不必要的信息包围着。如果观察更多值，我们会发现只有出版地包含 ‘London’ 或者 ‘Oxford’ 的行才会出现这种情况。

我们来看看两条特定的数据：

```
>>> df.loc[4157862]
Place of Publication                                  Newcastle-upon-Tyne
Date of Publication                                                  1867
Publisher                                                      T. Fordyce
Title                   Local Records; or, Historical Register of rema...
Author                                                        T.  Fordyce
Flickr URL              http://www.flickr.com/photos/britishlibrary/ta...
Name: 4157862, dtype: object

>>> df.loc[4159587]
Place of Publication                                  Newcastle upon Tyne
Date of Publication                                                  1834
Publisher                                                Mackenzie & Dent
Title                   An historical, topographical and descriptive v...
Author                                               E. (Eneas) Mackenzie
Flickr URL              http://www.flickr.com/photos/britishlibrary/ta...
Name: 4159587, dtype: object
```

这两本书在用一个地方出版，但是一个地名中间包含连字符，另一个没有。

想要一次性清理这一列，我们可以用 `str.contains()` 来获得一个布尔掩码。

我们按如下方式清理此列：

```
>>> pub = df['Place of Publication']
>>> london = pub.str.contains('London')
>>> london[:5]
Identifier
206    True
216    True
218    True
472    True
480    True
Name: Place of Publication, dtype: bool

>>> oxford = pub.str.contains('Oxford')
```

与 `np.where` 结合：

```
df['Place of Publication'] = np.where(london, 'London',
                                      np.where(oxford, 'Oxford',
                                               pub.str.replace('-', ' ')))

>>> df['Place of Publication'].head()
Identifier
206    London
216    London
218    London
472    London
480    London
Name: Place of Publication, dtype: object
```

这里，`np.where` 函数在嵌套结果中被调用，`condition` 是从 `str.contains()` 返回的布尔值的 `Series` 对象。`contains()` 方法类似原生 Python 中内置的 [`in` 关键字](https://www.programiz.com/python-programming/keyword-list#in)，它被用来查找一个迭代器中某个实体是否出现（或者字符串中是否有某子字符串）。

替换的是我们想要的出版地点的字符串。我们也用 `str.replace()` 方法将连字符替换成了空格然后重新赋值给 `DataFrame` 的列。

虽然这个数据集中还有很多脏数据，我们现在只讨论这两列。

让我们来重新看看前五项，看起来比最开始的时候清晰多了：

```
>>> df.head()
           Place of Publication Date of Publication              Publisher  \
206                      London                1879        S. Tinsley & Co.
216                      London                1868           Virtue & Co.
218                      London                1869  Bradbury, Evans & Co.
472                      London                1851          James Darling
480                      London                1857   Wertheim & Macintosh

                                                        Title    Author  \
206                         Walter Forbes. [A novel.] By A. A        AA
216         All for Greed. [A novel. The dedication signed...   A. A A.
218         Love the Avenger. By the author of “All for Gr...   A. A A.
472         Welsh Sketches, chiefly ecclesiastical, to the...   E. S A.
480         [The World in which I live, and my place in it...   E. S A.

                                                   Flickr URL
206         http://www.flickr.com/photos/britishlibrary/ta...
216         http://www.flickr.com/photos/britishlibrary/ta...
218         http://www.flickr.com/photos/britishlibrary/ta...
472         http://www.flickr.com/photos/britishlibrary/ta...
480         http://www.flickr.com/photos/britishlibrary/ta...
```

**注意**：到这里，`Place of Publication` 会是一个很好转化为 [`Categorical` dtype](https://pandas.pydata.org/pandas-docs/stable/categorical.html) 的列，因为我们可以用整数对比较小的唯一的城市进行编码。（**分类数据类型的内存使用量与类别数目加上数据长度成正比，dtype 对象的大小是一个常数乘以数据长度。**）

## 使用 `applymap` 函数清理整个数据集

在某些情况下，你会发现不仅是某一列里有脏数据，而是分散在整个数据集。

有时如果可以对 `DataFrame` 里的每个单元或元素都应用一个自定义函数会很有帮助。Pandas 的 `.applymap()` 函数类似内置的 `map()` 函数，只是它将应用于 `DataFrame` 中的所有元素。

让我们来看个例子，我们将从 “university_towns.txt” 文件中创建 `DataFrame`。

```Shell
$ head Datasets/univerisity_towns.txt
Alabama[edit]
Auburn (Auburn University)[1]
Florence (University of North Alabama)
Jacksonville (Jacksonville State University)[2]
Livingston (University of West Alabama)[2]
Montevallo (University of Montevallo)[2]
Troy (Troy University)[2]
Tuscaloosa (University of Alabama, Stillman College, Shelton State)[3][4]
Tuskegee (Tuskegee University)[5]
Alaska[edit]
```

我们发现州名后面跟着大学城的名字这样周期性出现：`StateA TownA1 TownA2 StateB TownB1 TownB2…`，如果我们在文件中查看州名的写法，会发现所有都有一个 “[edit]” 子字符串。

我们可以利用这个模式创建一个 `(state, city)` 元组列表，并将它放入 `DataFrame`。

```
>>> university_towns = []
>>> with open('Datasets/university_towns.txt') as file:
...     for line in file:
...         if '[edit]' in line:
...             # Remember this `state` until the next is found
...             state = line
...         else:
...             # Otherwise, we have a city; keep `state` as last-seen
...             university_towns.append((state, line))

>>> university_towns[:5]
[('Alabama[edit]\n', 'Auburn (Auburn University)[1]\n'),
 ('Alabama[edit]\n', 'Florence (University of North Alabama)\n'),
 ('Alabama[edit]\n', 'Jacksonville (Jacksonville State University)[2]\n'),
 ('Alabama[edit]\n', 'Livingston (University of West Alabama)[2]\n'),
 ('Alabama[edit]\n', 'Montevallo (University of Montevallo)[2]\n')]
```

我们可以将这个列表包入 DataFrame 中，并将列起名为 “State” 和 “RegionName”。Pandas 会获取每个列表中的元素，将左边的值放入 `State` 列，右边的值放入 `RegionName` 列。

生成的 DataFrame 如下：

```
>>> towns_df = pd.DataFrame(university_towns,
...                         columns=['State', 'RegionName'])

>>> towns_df.head()
 State                                         RegionName
0  Alabama[edit]\n                    Auburn (Auburn University)[1]\n
1  Alabama[edit]\n           Florence (University of North Alabama)\n
2  Alabama[edit]\n  Jacksonville (Jacksonville State University)[2]\n
3  Alabama[edit]\n       Livingston (University of West Alabama)[2]\n
4  Alabama[edit]\n         Montevallo (University of Montevallo)[2]\n
```

尽管我们可以使用 for 循环来清理上面的字符串，但是使用 Pandas 会更加方便。我们只需要州名和城镇名字，其他都可以删除。虽然这里也可以再次使用 .str() 方法，但我们也可以使用 applymap() 方法将一个 Python 可调用方法映射到 DataFrame 的每个元素上。

我们一直在使用**元素**这个术语，但实际上到底是指什么呢？看一下以下这个 DataFrame 例子：

```
        0           1
0    Mock     Dataset
1  Python     Pandas
2    Real     Python
3   NumPy     Clean
```

在这个例子中，每个单元格（‘Mock’、‘Dataset’、‘Python’、‘Pandas’ 等）都是一个元素。所以 `applumap()` 方法将函数作用于每个元素上。假设定义函数为：

```
>>> def get_citystate(item):
...     if ' (' in item:
...         return item[:item.find(' (')]
...     elif '[' in item:
...         return item[:item.find('[')]
...     else:
...         return item
```

Pandas 的 `.applymap()` 只接受一个参数，也就是将会作用于每个元素上的函数（可调用）：

```
>>> towns_df =  towns_df.applymap(get_citystate)
```

首先，我们定义一个 Python 函数，它以 `DataFrame` 中的元素作为参数。在函数内部，执行元素是否包含 `(` 或 `[` 的检查。

函数返回的值取决于这个检查。最后，`applymap()` 函数在我们的 `DataFrame` 对象上被调用。现在我们的 `DataFrame` 对象更加简洁了。

```
>>> towns_df.head()
     State    RegionName
0  Alabama        Auburn
1  Alabama      Florence
2  Alabama  Jacksonville
3  Alabama    Livingston
4  Alabama    Montevallo
```

`applymap()` 方法从 DataFrame 中获取每个元素，将它传递给函数，然后将原来的值替换为函数返回的值。就是这么简单！

**技术细节**：虽然它是一个方便多功能的方法，但 `.applymap()` 对于较大的数据集会有明显的运行时间，因为它将可调用的 Python 函数映射到每个单独元素。某些情况下，使用 Cython 或者 NumPy （调用 C 语言）里的矢量化操作更高效。

## 列的重命名以及跳过行

通常，需要处理的数据集可能包含不易理解的列名，或者某些包含不重要信息的行，它们可能是最前面的有关术语定义的几行，或者最末尾的脚注。

在这种情况下，我们希望重命名列以及跳过某些行，以便我们可以只对必要的信息以及有意义的标签进行深入分析。

为了说明我们如何做到这一点，我们先来看一看 “olympics.csv” 数据集的前五行：

```Shell
$ head -n 5 Datasets/olympics.csv
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
,? Summer,01 !,02 !,03 !,Total,? Winter,01 !,02 !,03 !,Total,? Games,01 !,02 !,03 !,Combined total
Afghanistan (AFG),13,0,0,2,2,0,0,0,0,0,13,0,0,2,2
Algeria (ALG),12,5,2,8,15,3,0,0,0,0,15,5,2,8,15
Argentina (ARG),23,18,24,28,70,18,0,0,0,0,41,18,24,28,70
```

然后，将它读入 Pandas 的 DataFrame 中：

```
>>> olympics_df = pd.read_csv('Datasets/olympics.csv')
>>> olympics_df.head()
                   0         1     2     3     4      5         6     7     8  \
0                NaN  ? Summer  01 !  02 !  03 !  Total  ? Winter  01 !  02 !
1  Afghanistan (AFG)        13     0     0     2      2         0     0     0
2      Algeria (ALG)        12     5     2     8     15         3     0     0
3    Argentina (ARG)        23    18    24    28     70        18     0     0
4      Armenia (ARM)         5     1     2     9     12         6     0     0

      9     10       11    12    13    14              15
0  03 !  Total  ? Games  01 !  02 !  03 !  Combined total
1     0      0       13     0     0     2               2
2     0      0       15     5     2     8              15
3     0      0       41    18    24    28              70
4     0      0       11     1     2     9              12
```

这确实很凌乱！列是从 0 开始索引的字符串形式的数字。应该是头部的行（也就是应该设置为列名的行）位于 `olympics_df.iloc[0]`。发生这种情况是因为我们的 csv 文件是以 0、1、2…15 开头的。

另外，如果我们去查看[数据集的来源](https://en.wikipedia.org/wiki/All-time_Olympic_Games_medal_table)，会发现 `NaN` 应该是类似 “Country”，`?Summer` 应该代表的是 “Summer Games”，而 `01!` 应该是 “Gold” 等等。

所以，我们需要做以下两件事：

*   跳过一行，将第一行（索引为 0）设置为 header
*   重命名这些列

我们可以在读取 CSV 文件时通过传递一些参数给 `read_csv()` 函数来跳过某行并设置 header。

这个函数有[很多可选的参数](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_csv.html)，但这个情况里，我们只需要一个参数（`header`）来移除第 0 行：

```
>>> olympics_df = pd.read_csv('Datasets/olympics.csv', header=1)
>>> olympics_df.head()
          Unnamed: 0  ? Summer  01 !  02 !  03 !  Total  ? Winter  \
0        Afghanistan (AFG)        13     0     0     2      2         0
1            Algeria (ALG)        12     5     2     8     15         3
2          Argentina (ARG)        23    18    24    28     70        18
3            Armenia (ARM)         5     1     2     9     12         6
4  Australasia (ANZ) [ANZ]         2     3     4     5     12         0

   01 !.1  02 !.1  03 !.1  Total.1  ? Games  01 !.2  02 !.2  03 !.2  \
0       0       0       0        0       13       0       0       2
1       0       0       0        0       15       5       2       8
2       0       0       0        0       41      18      24      28
3       0       0       0        0       11       1       2       9
4       0       0       0        0        2       3       4       5

   Combined total
0               2
1              15
2              70
3              12
4              12
```

我们现在已经有了正确的 header 行，以及移除了所有不必要的行。注意 Pandas 将包含国家名字的列的名字从 `NaN` 变成了 `Unnames:0`。

要重命名列，我们将利用 `rename()` 方法，这个方法允许你基于一个映射（本例中，指字典）来重新标记轴的名字。

让我们从定义一个新的字典开始，它将现在的列的名字作为 key，映射到可用性更强的名字（字典值）。

```
>>> new_names =  {'Unnamed: 0': 'Country',
...               '? Summer': 'Summer Olympics',
...               '01 !': 'Gold',
...               '02 !': 'Silver',
...               '03 !': 'Bronze',
...               '? Winter': 'Winter Olympics',
...               '01 !.1': 'Gold.1',
...               '02 !.1': 'Silver.1',
...               '03 !.1': 'Bronze.1',
...               '? Games': '# Games',
...               '01 !.2': 'Gold.2',
...               '02 !.2': 'Silver.2',
...               '03 !.2': 'Bronze.2'}
```

然后调用 `rename()` 函数：

```
>>> olympics_df.rename(columns=new_names, inplace=True)
```

将 `inplace` 参数设置为 `True` 可以将变化直接作用于我们的 `DataFrame` 对象上。让我们看看是否生效：

```
>>> olympics_df.head()
                   Country  Summer Olympics  Gold  Silver  Bronze  Total  \
0        Afghanistan (AFG)               13     0       0       2      2
1            Algeria (ALG)               12     5       2       8     15
2          Argentina (ARG)               23    18      24      28     70
3            Armenia (ARM)                5     1       2       9     12
4  Australasia (ANZ) [ANZ]                2     3       4       5     12

   Winter Olympics  Gold.1  Silver.1  Bronze.1  Total.1  # Games  Gold.2  \
0                0       0         0         0        0       13       0
1                3       0         0         0        0       15       5
2               18       0         0         0        0       41      18
3                6       0         0         0        0       11       1
4                0       0         0         0        0        2       3

   Silver.2  Bronze.2  Combined total
0         0         2               2
1         2         8              15
2        24        28              70
3         2         9              12
4         4         5              12
```

## Python 数据清理：回顾以及其他资源

在本教程中，你学习了如何使用 `drop()` 函数删除不必要的信息，以及如何给你的数据集设置索引以便更加方便的引用其他的项。

此外，你也学习了如何使用 `.str()` 清理对象字段，以及如何使用 `applymap()` 函数清理整个数据集。最后，我们探索了一下如何跳过 CSV 文件中某些列以及使用 `rename()` 方法重命名列。

了解数据清理非常重要，因为这是数据科学很重要的一部分。你现在已经对如何使用 Pandas 以及 NumPy 清理数据集有了基本的了解。

查看以下链接可以帮你找到更多的资源继续你的 Python 数据科学之旅：

*   [Pandas 文档](https://pandas.pydata.org/pandas-docs/stable/index.html)
*   [NumPy 文档](https://docs.scipy.org/doc/numpy/reference/)
*   [Python 数据分析](https://realpython.com/asins/1491957662/) 由 Pandas 的创造者 Wes McKinney 撰写
*   [Pandas Cookbook](https://realpython.com/asins/B06W2LXLQK/) 由数据科学教练和顾问 Ted Petrou 撰写

Real Python 的每一个教程都是由一组开发人员创建，所以它符合我们的高质量标准。参与本教程的团队成员是 [Malay Agarwal](https://realpython.com/team/magarwal/) （作者）以及 [Brad Solomon](https://realpython.com/team/bsolomon/) （编辑）。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
