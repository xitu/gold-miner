
> * 原文地址：[How to Convert a Time Series to a Supervised Learning Problem in Python](http://machinelearningmastery.com/convert-time-series-supervised-learning-problem-python/)
> * 原文作者：[Dr. Jason Brownlee](http://machinelearningmastery.com/author/jasonb/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/convert-time-series-supervised-learning-problem-python.md](https://github.com/xitu/gold-miner/blob/master/TODO/convert-time-series-supervised-learning-problem-python.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：

# 如何将时间序列问题用 Python 转换成为监督学习问题

一些机器学习方法（例如深度学习）可以用于进行时间序列预测。

在使用这些机器学习方法前，必须先将时间序列预测问题转化为监督学习问题。也就是说，需要将一个时间序列转换成一组包含成对输入输出的序列。

在这篇教程里，你将了解如何将单变量时间序列预测问题和多变量时间序列预测问题转换成监督学习问题，以使用机器学习算法。

读完这篇教程，你将会了解：

- 如何编写一个将时间序列数据集转换为监督学习数据集的函数。
- 如何转换一元时间序列数据以使用机器学习。
- 如何转换多元时间序列数据以使用机器学习。

让我们开始吧。

![How to Convert a Time Series to a Supervised Learning Problem in Python](http://3qeqpr26caki16dnhd19sv6by6v.wpengine.netdna-cdn.com/wp-content/uploads/2017/05/How-to-Convert-a-Time-Series-to-a-Supervised-Learning-Problem-in-Python.jpg)

题图：如何将时间序列问题用 Python 转换成为监督学习问题

[Quim Gil](https://www.flickr.com/photos/quimgil/8490510169/) 拍摄，版权所有。

## 时间序列 vs 监督学习

在正式开始之前，让我们先花点时间更好地了解一下时间序列和监督学习的数据集结构。

单个时间序列由一系列按照时间排序的数字序列组成。可以将其理解为一列有序值。

例如：

```
0
1
2
3
4
5
6
7
8
9
```


而一个监督学习问题是由一组输入（*X*）和一组输出（*y*）组成，算法可以学会如何通过输入值来预测输出值。

例如：

```
X,  y
1 2
2,  3
3,  4
4,  5
5,  6
6,  7
7,  8
8,  9
```

可以参阅这篇文章，学习更多有关知识：

- [Time Series Forecasting as Supervised Learning](http://machinelearningmastery.com/time-series-forecasting-supervised-learning/)

## Pandas 的 shift() 函数

我们将时间序列数据转化为监督学习问题的关键就是使用 Pandas 的 [shift()](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.shift.html) 函数。

给定一个 DataFrame，*shift()* 函数会将输入的列复制一份，然后将副本列整体往后移动（最前面的数据空位会用 NaN 填充）或者往前移动（最后面的数据空位会用 NaN 填充）。

这样可以创建一个滞后值列，加上观察列，就能将时间序列数据集变成监督学习数据集的格式。

让我们看看 shift 函数实际用起来效果如何。

我们可以通过下面的代码模拟一个长度为 10 的时间序列数据集，此时它在 DataFrame 中为单独的一列：

```
from pandas import DataFrame
df = DataFrame()
df['t'] = [x for x in range(10)]
print(df)
```

运行上面的样例，将时间序列数据输出，其每一行都为带有索引的观察组数据。
```
   t
0  0
1  1
2  2
3  3
4  4
5  5
6  6
7  7
8  8
9  9
```

我们可以在数据顶部插入一行，将观察组的数据整体下挪一位。由于最上面插入的新行没有数据，因此我们可以用 NaN 填充来表示这儿“没有数据”。

shift 函数可以完成这些操作。我们可以将 shift 函数“挪动”过的新列插入原始序列的旁边。

```
from pandas import DataFrame
df = DataFrame()
df['t'] = [x for x in range(10)]
df['t-1'] = df['t'].shift(1)
print(df)
```

运行上面的样例，你将得到一个包含两列的数据集。第一列是原始的观察组，第二列是经由 shift 函数挪动生成的新列。

可以看到，经过将序列移动一次的操作之后，我们得到了一个原始的监督学习问题（虽然此时的 *X* 和 *y* 的排序明显是错的）。忽略最前面的表头，第一行存在 NaN 值，因此需要将其丢弃。在第二行，我们可以将第二列的 0.0 作为输入值（也就是 *X*），将第一列的 1 作为输出值（或 *y*）。

```
   t  t-1
0  0  NaN
1  1  0.0
2  2  1.0
3  3  2.0
4  4  3.0
5  5  4.0
6  6  5.0
7  7  6.0
8  8  7.0
9  9  8.0
```

如果我们重复 shift 步骤，让原始列挪动 2 位、3 位或者更多位，我们就能得到一系列的输入数据（*X*），由这些输入值就能去预测输出值（*y*）了。

shift 操作能也能接受负整数作为参数。如果你这么做，它会在列底部插入新行，从而使得原列向上移动。下面是例子：

```
from pandas import DataFrame
df = DataFrame()
df['t'] = [x for x in range(10)]
df['t+1'] = df['t'].shift(-1)
print(df)
```

运行上面的样例，可以看到新列中的最后一个值为 NaN。

此时可以将预测列作为输入值（*X*），将第二列作为输出值（*y*）。也就是给定输入值 0 可以用于预测输出值 1。

```
   t  t+1
0  0  1.0
1  1  2.0
2  2  3.0
3  3  4.0
4  4  5.0
5  5  6.0
6  6  7.0
7  7  8.0
8  8  9.0
9  9  NaN
```

从技术上说，在时间序列预测问题的术语中，当前时间（*t*）和未来时间（*t+1, t+n*）为待预测时间，过去时间（*t-1, t-n*）则用于预测。

从上面的例子中，我们可以学会如何使用通过 shift 函数正向或反向移动序列，生成新的 DataFrame，将时间序列问题转变成监督学习问题的输入-输出模式。

这不仅可以解决经典的 *X -> y* 类预测问题，也可以用于输入输出值都是序列的 *X -> Y* 类预测。

另外，shift 函数也能用于多元时间序列问题中。这类问题中包含多列观察组（例如温度、气压等）。时间序列中的所有变量都能用通过向前或向后挪动，生成多元输入值与输出值序列。稍后我们将探讨这类问题。

## series_to_supervised() 函数

我们可以使用 Pandas 的 *shift()* 函数，在给定希望得到的输入值、输出值序列长度后自动生成时间序列问题的新格式数据。

这是个很有用的工具。我们可以通过机器学习算法研究各种时间序列问题格式，探究哪种格式能够得到效果更佳的模型。

在本节中，我们将创建一个新的 Python 函数，名为 *series_to_supervised()*。它可以将多元时间序列问题与一元时间序列问题转换为监督学习数据集的格式。

这个函数接收以下 4 个参数：

- **data**：必填，待转换的序列，数据类型为 list 或 2 维 NumPy array。
- **n_in**： 可选，滞后组（作为输入值 X）的数量。范围可以在 [1..len(data)] 之间，默认值为 1。
- **n_out**： 可选，观察组（作为输出值 y）的数量。范围可以在  [0..len(data)-1] 之间，默认值为 1。
- **dropnan**：选填，决定是否抛去包含 NaN 的行。类型为 Boolean，默认值为 True。

函数将会返回一个值：

- **return**：返回监督学习格式的数据集，数据类型为 Pandas DataFrame。

新数据集 DataFrame 格式，每一列都由原变量名称和移动步数命名，让你可以根据给定的一元或多元时间序列问题设计出各种移动步数的序列。

在 DataFrame 返回时，你可以对其行进行分割，根据你的需要决定如何将返回的 DataFrame 分成 X 和 y 两部分。

这个函数的参数都设置了默认值，因此可以直接调用它处理你的数据，这种默认情况它将会返回一个 *t-1* 作为 X，*t* 作为 y 的 DataFrame。

这个函数已确定同时兼容 Python2 和 Python3。

下面为完整代码，并写好了注释：

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
  """
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg
```

你觉得可以怎样提高这个函数的鲁棒性或者可读性吗？请留言在评论区。

至此我们已经得到了整个函数，接下来探索它的用法。

## 单步或单变量预测

在时间序列预测问题中通常使用滞后时间（例如 t-1）作为输入变量来预测当前时间（t）。

这种问题被称为单步预测。

下面展示了使用滞后一个时间步的时间（t-1）来预测当前时间（t）的例子。

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
  """
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg
  
  values = [x for x in range(10)]
  data = series_to_supervised(values)
  print(data)
```

运行样例，输出转换后的时间序列。

```
   var1(t-1)  var1(t)
1        0.0        1
2        1.0        2
3        2.0        3
4        3.0        4
5        4.0        5
6        5.0        6
7        6.0        7
8        7.0        8
9        8.0        9
```

可以看到，观察组被命名为“*var1*”，作为输入值的观察组被命名为（*t-1*），输出值组被命名为（*t*）。

此外，可以看到包含 NaN 的行已经被自动从 DataFrame 中移除。

我们可以任意给定输入序列数量的值来重复运行这个例子。例如输入 3，我们事先已经将输入序列的数量定义为了一个参数。例如：

```
data = series_to_supervised(values, 3)
```

完整样例如下：

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
"""
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg


values = [x for x in range(10)]
data = series_to_supervised(values, 3)
print(data)
```

再次运行样例，输出重新构造的序列，可以看到输入序列准确无误地从左至右裴烈，作为预测项的输入值在最右边。

```
   var1(t-3)  var1(t-2)  var1(t-1)  var1(t)
3        0.0        1.0        2.0        3
4        1.0        2.0        3.0        4
5        2.0        3.0        4.0        5
6        3.0        4.0        5.0        6
7        4.0        5.0        6.0        7
8        5.0        6.0        7.0        8
9        6.0        7.0        8.0        9
```

## 多步或序列预测

还有一类预测问题：使用过去的观察组来对未来的观察组序列做预测。

可以将这类问题成为序列预测问题或者多步预测问题。

我们可以通过规定另一个参数来将序列预测问题的时间序列重新构造。例如，我们可以把 2 个过去的观察组转变为 2 个未来的观察组，从而重新构造预测问题：

```
data=series_to_supervised(values,2,2)
```

完整样例如下：

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
  """
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg

values = [x for x in range(10)]
data = series_to_supervised(values, 2, 2)
print(data)
```

运行样例，可以看到将（*t-n*）作为输入变量、将（*t+n*）作为输出变量时，与将当前观察组（*t*）作为输出的不同之处。

```
   var1(t-2)  var1(t-1)  var1(t)  var1(t+1)
2        0.0        1.0        2        3.0
3        1.0        2.0        3        4.0
4        2.0        3.0        4        5.0
5        3.0        4.0        5        6.0
6        4.0        5.0        6        7.0
7        5.0        6.0        7        8.0
8        6.0        7.0        8        9.0

```

## 多元预测

还有一种重要的时间序列类型，叫做多元时间序列。

这种情况我们会将多个不同的指标作为观察组，并预测它们中的一个或多个的值。

例如，我们有两组时间序列观察组 obs1 和 obs2，希望预测它们或它们中的一者。

我们同样可以调用 *series_to_supervised()*。例如：

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
  """
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg


raw = DataFrame()
raw['ob1'] = [x for x in range(10)]
raw['ob2'] = [x for x in range(50, 60)]
values = raw.values
data = series_to_supervised(values)
print(data)
```

运行样例，将会得到经过重新构造后的数据。数据显示了分别处于同一个时间的两组变量作为输入组以及输出组。

与之前一样，根据问题的需要，可以将列分入 *X* 和 *y* 两个子集中，需要注意的是如果放入了 *var1* 做为观察组，那就要放入 *var2* 作为待预测组。

```
   var1(t-1)  var2(t-1)  var1(t)  var2(t)
1        0.0       50.0        1       51
2        1.0       51.0        2       52
3        2.0       52.0        3       53
4        3.0       53.0        4       54
5        4.0       54.0        5       55
6        5.0       55.0        6       56
7        6.0       56.0        7       57
8        7.0       57.0        8       58
9        8.0       58.0        9       59
```

可以看到，通过上面这样给定输入序列和输出序列的数量生成的新的序列，可以帮助你轻松地完成多元时间序列的预测。

例如，下面将把 1 作为输入列数量，将 2 作为输出列（预测列）数量，重新构造预测序列：

```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
  """
  函数用途：将时间序列转化为监督学习数据集。
  参数说明：
    data: 观察值序列，数据类型可以是 list 或者 NumPy array。
    n_in: 作为输入值(X)的滞后组的数量。
    n_out: 作为输出值(y)的观察组的数量。
    dropnan: Boolean 值，确定是否将包含 NaN 的行移除。
  返回值:
    经过转换的用于监督学习的 Pandas DataFrame 序列。
  """
  n_vars = 1 if type(data) is list else data.shape[1]
  df = DataFrame(data)
  cols, names = list(), list()
  # 输入序列 (t-n, ... t-1)
  for i in range(n_in, 0, -1):
    cols.append(df.shift(i))
    names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
  # 预测序列 (t, t+1, ... t+n)
  for i in range(0, n_out):
    cols.append(df.shift(-i))
    if i == 0:
      names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
    else:
      names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
  # 将所有列拼合
  agg = concat(cols, axis=1)
  agg.columns = names
  # drop 掉包含 NaN 的行
  if dropnan:
    agg.dropna(inplace=True)
  return agg

raw = DataFrame()
raw['ob1'] = [x for x in range(10)]
raw['ob2'] = [x for x in range(50, 60)]
values = raw.values
data = series_to_supervised(values, 1, 2)
print(data)
```

运行样例，将会展示重新构造的很大的 DataFrame。

```
   var1(t-1)  var2(t-1)  var1(t)  var2(t)  var1(t+1)  var2(t+1)
1        0.0       50.0        1       51        2.0       52.0
2        1.0       51.0        2       52        3.0       53.0
3        2.0       52.0        3       53        4.0       54.0
4        3.0       53.0        4       54        5.0       55.0
5        4.0       54.0        5       55        6.0       56.0
6        5.0       55.0        6       56        7.0       57.0
7        6.0       56.0        7       57        8.0       58.0
8        7.0       57.0        8       58        9.0       59.0
```

你可以用你自己的数据集多做几次实验，来试试哪种重构的效果更好。

## 总结

在这篇教程中，你已经了解了如何使用 Python 将时间序列数据集转换为监督学习问题。

特别的，你了解了：

- 有关 Pandas *shift()* 函数的知识，以及它如何自动将时间序列数据转化为监督学习数据集。
- 如何将一元时间序列重构成单步或多步监督学习问题。
- 如何将多元时间序列重构成单步或多步监督学习问题。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
