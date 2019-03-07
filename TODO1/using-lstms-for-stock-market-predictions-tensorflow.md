> * 原文地址：[Using LSTMs For Stock Market Predictions (Tensorflow)](https://towardsdatascience.com/using-lstms-for-stock-market-predictions-tensorflow-9e83999d4653)
> * 原文作者：[Thushan Ganegedara](https://towardsdatascience.com/@thushv89?source=user_popover)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-lstms-for-stock-market-predictions-(tensorflow).md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-lstms-for-stock-market-predictions-(tensorflow).md)
> * 译者：[Qiuk17](https://github.com/Qiuk17)
> * 校对者：[Park-ma](https://github.com/Park-ma)，[Long Xiong](https://github.com/xionglong58)

# 用长短期记忆网络预测股票市场（使用 Tensorflow）

![](https://cdn-images-1.medium.com/max/1600/1*kq6dfFNUkPhPLS2B6vODrg.jpeg)

在本教程中，你将了解到如何使用被称作长短期记忆网络（LSTM）的时间序列模型。LSTM 模型在保持长期记忆方面非常强大。阅读这篇教程时，你将：

*   明白预测股市走势的动机；
*   下载股票数据 — 你将使用由 Alpha Vantage 或 Kaggle 收集的股票数据；
*   将数据划分为训练集和测试集，并将其标准化；
*   简要讨论一下为什么 LSTM 模型可以预测未来多步的情形；
*   使用现有数据预测股票趋势，并将结果可视化。

**注意：请不要认为 LSTM 是一种可以完美预测股票趋势的可靠模型，也不要盲目使用它进行股票交易**。我只是出于对机器学习的兴趣做了这个实验。在大部分情况下，这个模型的确能发现数据中的特定规律并准确预测股票的走势。但是否将其用于实际的股票市场取决于你自己。

### 为什么要用时间序列模型？

作为一名股民，如果你能对股票价格进行正确的建模，你就可以通过在合适的时机买入或卖出来获取利益。因此，你需要能通过一组历史数据来预测未来数据的模型——时间序列模型。

**警告**：股价本身因受到诸多因素影响而难以预测，这意味着你难以找到一种能完美预测股价的模型。并不只有我一人如此认为。普林斯顿大学的经济学教授 Burton Malkiel 在他 1973 年出版的《A Random Walk Down Wall Street》一书中写道：“如果股市足够高效，以至于人们能从公开的股价中知晓影响它的全部因素，那么人人都能像投资专业人士那样炒股”。

但是，请保持信心，用机器学习的方法来预测这完全随机的股价仍有一丝希望。我们至少能通过建模来预测这组数据的实际走势。换而言之，不必知晓股价的确切值，你只要能预测股价要涨还是要跌就万事大吉了。

```python
# 请确保你安装了这些包，并且能运行成功以下代码
from pandas_datareader import data
import matplotlib.pyplot as plt
import pandas as pd
import datetime as dt
import urllib.request, json 
import os
import numpy as np
import tensorflow as tf # TensorFlow 1.6 版本下测试通过
from sklearn.preprocessing import MinMaxScaler
```

### 下载数据

你可以从以下来源下载数据：

1.  Alpha Vantage。首先，你必须从 [这个网站](https://www.alphavantage.co/support/#api-key) 获取所需的 API key。在此之后，将它的值赋给变量 `api_key`。
2.  从 [这个页面](https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs) 下载并将其中的 _Stocks_ 文件夹拷贝到你的工程目录下。

股价中包含几种不同的数据，它们是：

*   开盘价：一天中股票刚开盘时的价格；
*   收盘价：一天中股票收盘时的价格；
*   最高价：一天中股价的最大值；
*   最低价：一天中股价的最小值。

### 从 Alpha Vantage 获取数据

为了从 Alpha Vantage 上下载美国航空公司的股价数据用于分析，你要将行情显示代号 `ticker` 设置为 `"AAL"`。同时，你也要定义一个 `url_string` 变量来获取包含最近 20 年内的全部股价信息的 JSON 文件，以及文件保存路径 `file_to_save`。别忘了用你的 `ticker` 变量来帮助你命名你下载下来的文件。

接下来，设定一个条件：如果本地没有保存的数据文件，就从 `url_string` 指明的 URL 下载数据，并将其中的日期、最低价、最高价、交易量、开盘价和收盘价存入 Pandas 的 DataFrame `df` 中，再将其保存到 `file_to_save`；否则直接从本地读取 csv 文件就好了。

### 从 Kaggle 获取数据

从 Kaggle 上找到的数据是一系列 csv 表格，你不需要对它进行任何处理就可以直接读入 Pandas 的 DataFrame 中。确保你正确地将 _Stocks_ 文件夹放在项目的主目录中。

### 读取数据

现在，将这些数据打印到 DataFrame 中吧！由于数据的顺序在时间序列模型中至关重要，所以请确保你的数据已经按照日期排好序了。

```python
# 按日期排序
df = df.sort_values('Date')

# 检查结果
df.head()
```

#### 数据可视化

看看你的数据，并从中找到伴随时间推移而具有的不同规律。

```python
plt.figure(figsize = (18,9))
plt.plot(range(df.shape[0]),(df['Low']+df['High'])/2.0)
plt.xticks(range(0,df.shape[0],500),df['Date'].loc[::500],rotation=45)
plt.xlabel('Date',fontsize=18)
plt.ylabel('Mid Price',fontsize=18)
plt.show()
```

![](https://cdn-images-1.medium.com/max/1600/0*BK3alG7gtLtG05nw.png)

这幅图包含了很多信息。我特意选取了这家公司的股价图，因为它包含了股价的多种不同规律。这将使你的模型更健壮，也让它能更好地预测不同情形下的股价。

另一件值得注意的事情是 2017 年的股价远比上世纪七十年代的股价高且波动更大。因此，你要在**数据标准化**的过程中，注意让这些部分的数据落在相近的数值区间内。

### 将数据划分为训练集和测试集

首先通过对每一天的最高和最低价的平均值来算出 `mid_prices`。

```python
# 首先用最高和最低价来算出中间价
high_prices = df.loc[:,'High'].as_matrix()
low_prices = df.loc[:,'Low'].as_matrix()
mid_prices = (high_prices+low_prices)/2.0
```

然后你就可以划分数据集了。前 11000 个数据属于训练集，剩下的都属于测试集。

```python
train_data = mid_prices[:11000] 
test_data = mid_prices[11000:]
```

接下来我们需要一个换算器 `scaler` 用于标准化数据。`MinMaxScalar` 会将所有数据换算到 0 和 1 之间。同时，你也可以将两个数据集都调整为 `[data_size, num_features]` 的大小。

```python
# 将所有数据缩放到 0 和 1 之间
# 在缩放时请注意，缩放测试集数据时请使用缩放训练集数据的参数
# 因为在测试前你是不应当知道测试集数据的
scaler = MinMaxScaler()
train_data = train_data.reshape(-1,1)
test_data = test_data.reshape(-1,1)
```

上面我们注意到不同年代的股价处于不同的价位，如果不做特殊处理的话，在标准化后的数据中，上世纪的股价数据将非常接近于 0。这对模型的学习过程没啥好处。所以我们将整个时间序列划分为若干个区间，并在每一个区间上做标准化。这里每一个区间的长度取值为 2500。

**提示**：因为每一个区间都被独立地初始化，所以在两个区间的交界处会引入一个“突变”。为了避免这个“突变”给我们的模型带来大麻烦，这里的每一个区间长度不要太小。

本例中会引入 4 个“突变”，鉴于数据有 11000 组，所以它们无关紧要。

```python
# 使用训练集来训练换算器 scaler，并且调整数据使之更平滑
smoothing_window_size = 2500
for di in range(0,10000,smoothing_window_size):
    scaler.fit(train_data[di:di+smoothing_window_size,:])
    train_data[di:di+smoothing_window_size,:] = scaler.transform(train_data[di:di+smoothing_window_size,:])

# 标准化所有的数据
scaler.fit(train_data[di+smoothing_window_size:,:])
train_data[di+smoothing_window_size:,:] = scaler.transform(train_data[di+smoothing_window_size:,:])
```

将数据矩阵调整回 `[data_size]` 的形状。

```python
# 重新调整测试集和训练集
train_data = train_data.reshape(-1)

# 将测试集标准化
test_data = scaler.transform(test_data).reshape(-1)
```

为了产生一条更平滑的曲线，我们使用一种叫做指数加权平均的算法。

**注意**：我们只使用训练集来训练换算器 `scaler`，否则在标准化测试集时将得到不准确的结果。

**注意**：只允许对训练集做平滑处理。

```python
# 应用指数加权平均
# 现在数据将比之间更为平滑
EMA = 0.0
gamma = 0.1
for ti in range(11000):
  EMA = gamma*train_data[ti] + (1-gamma)*EMA
  train_data[ti] = EMA

# 用于可视化和调试
all_mid_data = np.concatenate([train_data,test_data],axis=0)
```

### 评估结果

为了评估训练出来的模型，我们将计算其预测值与真实值的均方误差（MSE）。将每一个预测值与真实值误差的平方取均值，即为这个模型的均方误差。

### 股价建模中的平均值

在我的 [这篇同类型文章](https://www.datacamp.com/community/tutorials/lstm-python-stock-market) 中，我提到了取平均值在股价建模中是一种糟糕的做法，其结论如下：

> 取平均值在预测单步上效果不错，但对股市预测这种需要预测许多步的情形不适用。如果你想了解更多，请查看 [这篇文章](https://www.datacamp.com/community/tutorials/lstm-python-stock-market)。

### 使用 LSTM 预测未来股价走势

长短期记忆网络模型是非常强大的基于时间序列的模型，它们能向后预测任意步。一个 LSTM 模块（或者一个 LSTM 单元）使用 5 个重要的参数来对长期和短期数据建模。

*   单元状态（$c_{t}$）- 这代表了单元存储的短期和长期记忆；
*   隐藏状态（$h_{t}$）- 这是根据当前输入、以前的隐藏状态和当前单元输入计算的用于预测未来股价的输出状态信息 。此外，隐藏状态还决定着是否只使用单元状态中的记忆（短期、长期或两者都使用）来进行下一次预测；
*   输入门（$i_{t}$）- 从输入门流入到单元状态中的信息；
*   遗忘门（$f_{t}$）- 从当前输入和前一个单元状态流到当前单元状态的信息；
*   输出门（$o_{t}$）- 从当前单元状态流到隐藏状态的信息，这决定了 LSTM 接下来使用的记忆类型。

下图展示了一个 LSTM 单元。

![](https://cdn-images-1.medium.com/max/1600/0*pbM_2Jo3xG-mI5Zu.png)

其中计算的算式如下：

* $i_{t} = \sigma(W_{ix} * x_{t} + W_{ih} * h_{t-1}+b_{i})$
* $\tilde{c_{t}} = tanh(W_{cx} * x_{t} + W_{ch} * h_{t-1} + b_{c})$
* $f_{t} = \sigma(W_{fx} * x_{t} + W_{fh} * h_{t-1}+b_{f})$
* $c_{t} = f_{t} * c_{t-1} + i_{t} * \tilde{c_{t}}$
* $o_{t} = \sigma(W_{ox} * x_{t} + W_{oh} * h_{t-1}+b_{o})$
* $h_{t} = o_{t} * tanh(c_{t})$

如果你想更学术性地了解 LSTM，请阅读 [这篇文章](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)。

### 数据生成器

最简单的想法是将总量为 N 的数据集，平均分割成 N/b 个序列，每个序列包含 b 个数据点。然后我们假想若干个指针，它们指向每一个序列的第一个元素。然后我们就可以开始采样生成数据了。我们将当前段的指针指向的元素下标当作输入，并在其后面的 1~5 个元素中随机挑选一个作为正确的预测值，因为模型并不总是只预测紧靠当前时间点的后一个数据。这样可以有效避免过拟合。每一次取样之后，我们将指针的下标加一，并开始生成下一个数据点。请移步我的 [另一篇教程](https://www.datacamp.com/community/tutorials/lstm-python-stock-market) 来了解更多。

![](https://cdn-images-1.medium.com/max/1600/0*gzwP9wpanog-uOPq.png)

### 定义超参数

在本节中，我们将定义若干个超参数。`D` 是输入的维数。因为你使用前一天的股价来预测后面的股价，所以 `D` 应当是 `1`。

`num_unrollings` 表示单个步骤中考虑的连续时间点个数，越大越好。

然后是 `batch_size`。它是在单个时间点中考虑的数据样本数量。它越大越好，因为选取的样本数量越大，模型可以参考的数据也就更多。

最后是 `num_nodes` 决定了每个单元中包含了多少隐藏神经元。在本例中，网络中包含三层 LSTM。

```python
D = 1 # 数据的维度
num_unrollings = 50 # 你想预测多远的结果
batch_size = 500 # 一次批处理中包含的数据个数
num_nodes = [200,200,150] # 使用的深层 LSTM 网络的每一层中的隐藏节点数
n_layers = len(num_nodes) # 层数
dropout = 0.2 # dropout 概率

tf.reset_default_graph() # 如果你想要多次运行，这个语句至关重要
```

### 定义输入和输出

接下来定义用于输入训练数据和标签的 placeholder。因为每个 placeholder 中只包含一批一维数据，所以这并不难。对于每一个优化步骤，我们需要 `num_unrollings` 个 placeholder。

```python
# 输入数据
train_inputs, train_outputs = [],[]

# 根据时间顺序展开输入，为每个时间点定义一个 placeholder
for ui in range(num_unrollings):
    train_inputs.append(tf.placeholder(tf.float32, shape=[batch_size,D],name='train_inputs_%d'%ui))
    train_outputs.append(tf.placeholder(tf.float32, shape=[batch_size,1], name = 'train_outputs_%d'%ui))
```

### 定义 LSTM 和回归层的参数

您将有一个包含三层 LSTM 和一层线性回归层的神经网络，分别用 `w` 和 `b` 表示，它获取上一个长短期记忆单元的输出，并输出对下一个时间的预测。你可以使用 TensorFlow 中的 `MultiRNNCell` 来封装您创建的三个 `LSTMCell` 对象。此外，LSTM 单元上还可以加上 dropout 来提高性能并减少过拟合。

```python
stm_cells = [
    tf.contrib.rnn.LSTMCell(num_units=num_nodes[li],
                            state_is_tuple=True,
                            initializer= tf.contrib.layers.xavier_initializer()
                           )
 for li in range(n_layers)]

drop_lstm_cells = [tf.contrib.rnn.DropoutWrapper(
    lstm, input_keep_prob=1.0,output_keep_prob=1.0-dropout, state_keep_prob=1.0-dropout
) for lstm in lstm_cells]
drop_multi_cell = tf.contrib.rnn.MultiRNNCell(drop_lstm_cells)
multi_cell = tf.contrib.rnn.MultiRNNCell(lstm_cells)

w = tf.get_variable('w',shape=[num_nodes[-1], 1], initializer=tf.contrib.layers.xavier_initializer())
b = tf.get_variable('b',initializer=tf.random_uniform([1],-0.1,0.1))
```

### 计算 LSTM 输出并将结果代入回归层进行预测

在本节中，首先创建 TensorFlow 张量 `c` 和 `h` 用来保存 LSTM 单元的单元状态和隐藏状态。然后将 `train_input` 转换为 `[num_unrollings, batch_size, D]` 的形状，这是计算 `tf.nn.dynamic_rnn` 函数的输出所必需的。然后用 `tf.nn.dynamic_rnn` 计算 LSTM 输出，并将输出转化为一系列 `num_unrolling` 张量来预测和真实股价之间的损失函数。

```python
# 创建 LSTM 的单元状态 c 和隐藏状态 h
c, h = [],[]
initial_state = []
for li in range(n_layers):
  c.append(tf.Variable(tf.zeros([batch_size, num_nodes[li]]), trainable=False))
  h.append(tf.Variable(tf.zeros([batch_size, num_nodes[li]]), trainable=False))
  initial_state.append(tf.contrib.rnn.LSTMStateTuple(c[li], h[li]))

# 因为 dynamic_rnn 函数需要特定的输出格式，所以我们对张量进行一些变换
# 请访问 https://www.tensorflow.org/api_docs/python/tf/nn/dynamic_rnn 来了解更多
all_inputs = tf.concat([tf.expand_dims(t,0) for t in train_inputs],axis=0)

# all_outputs 张量的尺寸是 [seq_length, batch_size, num_nodes]
all_lstm_outputs, state = tf.nn.dynamic_rnn(
    drop_multi_cell, all_inputs, initial_state=tuple(initial_state),
    time_major = True, dtype=tf.float32)

all_lstm_outputs = tf.reshape(all_lstm_outputs, [batch_size*num_unrollings,num_nodes[-1]])

all_outputs = tf.nn.xw_plus_b(all_lstm_outputs,w,b)

split_outputs = tf.split(all_outputs,num_unrollings,axis=0)
```

### 损失函数的计算与优化

然后计算损失函数。但是在计算它时有一个值得注意的点。对于每批预测和真实输出，计算均方误差。然后将这些均方损失加起来（而非平均值）。最后，定义用于优化神经网络的优化器。我推荐使用 Adam 这种最新的、性能良好的优化器。

```python
# 在计算损失函数时，你需要注意准确的计算方法
# 因为你要同时计算所有展开步骤的损失函数
# 因此，在展开时取每批数据的平均误差，并将它们相加得到最终损失函数

print('Defining training Loss')
loss = 0.0
with tf.control_dependencies([tf.assign(c[li], state[li][0]) for li in range(n_layers)]+
                             [tf.assign(h[li], state[li][1]) for li in range(n_layers)]):
  for ui in range(num_unrollings):
    loss += tf.reduce_mean(0.5*(split_outputs[ui]-train_outputs[ui])**2)

print('Learning rate decay operations')
global_step = tf.Variable(0, trainable=False)
inc_gstep = tf.assign(global_step,global_step + 1)
tf_learning_rate = tf.placeholder(shape=None,dtype=tf.float32)
tf_min_learning_rate = tf.placeholder(shape=None,dtype=tf.float32)

learning_rate = tf.maximum(
    tf.train.exponential_decay(tf_learning_rate, global_step, decay_steps=1, decay_rate=0.5, staircase=True),
    tf_min_learning_rate)

# 优化器
print('TF Optimization operations')
optimizer = tf.train.AdamOptimizer(learning_rate)
gradients, v = zip(*optimizer.compute_gradients(loss))
gradients, _ = tf.clip_by_global_norm(gradients, 5.0)
optimizer = optimizer.apply_gradients(
    zip(gradients, v))

print('\tAll done')
```

这里定义与预测相关的 TensorFlow 操作。首先，定义用于输入的占位符（`sample_input`）。然后像训练阶段那样，定义用于预测的状态变量（`sample_c` 和 `sample_h`）。再然后用 `tf.nn.dynamic_rnn` 函数计算预测值。最后通过线性回归层（`w` 和 `b`）发送输出。您还应该定义 `reset_sample_state` 操作用于重置单元格状态和隐藏状态。每次进行一系列预测时，都应该在开始时执行此操作。

```python
print('Defining prediction related TF functions')

sample_inputs = tf.placeholder(tf.float32, shape=[1,D])

# 在预测阶段更新 LSTM 状态
sample_c, sample_h, initial_sample_state = [],[],[]
for li in range(n_layers):
  sample_c.append(tf.Variable(tf.zeros([1, num_nodes[li]]), trainable=False))
  sample_h.append(tf.Variable(tf.zeros([1, num_nodes[li]]), trainable=False))
  initial_sample_state.append(tf.contrib.rnn.LSTMStateTuple(sample_c[li],sample_h[li]))

reset_sample_states = tf.group(*[tf.assign(sample_c[li],tf.zeros([1, num_nodes[li]])) for li in range(n_layers)],
                               *[tf.assign(sample_h[li],tf.zeros([1, num_nodes[li]])) for li in range(n_layers)])

sample_outputs, sample_state = tf.nn.dynamic_rnn(multi_cell, tf.expand_dims(sample_inputs,0),
                                   initial_state=tuple(initial_sample_state),
                                   time_major = True,
                                   dtype=tf.float32)

with tf.control_dependencies([tf.assign(sample_c[li],sample_state[li][0]) for li in range(n_layers)]+
                              [tf.assign(sample_h[li],sample_state[li][1]) for li in range(n_layers)]):  
  sample_prediction = tf.nn.xw_plus_b(tf.reshape(sample_outputs,[1,-1]), w, b)

print('\tAll done')
```

### 运行 LSTM

在这里，你将训练并预测股票价格在接下来一段时间内的变动趋势，并观察预测是否正确。按照以下步骤操作我分享出来的 Jupyter Notebook。

> ★ 在时间序列上定义一系列起始点 `test_points_seq` 用于评估你的模型
>
> ★ 对于每一个时间点
>
> ★★ 对于全部的训练数据
>
> ★★★ 将 `num_unrollings` 展开
>
> ★★★ 使用展开的数据训练神经网络
>
> ★★ 计算训练的平均损失函数
>
> ★★ 对于测试集中的每一个起始点
>
> ★★★ 通过迭代测试点之前找到的 `num_unrollings` 中的数据点来更新 LSTM 状态
>
> ★★★ 连续预测接下来的 `n_predict_once` 步，然后将前一次的预测作为本次的输入
>
> ★★★ 计算预测值和真实股价之间的均方误差

### 将预测结果可视化

你可以发现，模型的均方误差在显著地下降，这意味着模型确实学习到了有用的信息。你可以通过比较神经网络产生的均方误差以及对股价取标准平均的均方误差（0.004）来量化你的成果。显然，LSTM 优于标准平均，同时你也能明白股价的标准平均能较好地反映股价地变化。

![](https://cdn-images-1.medium.com/max/1600/0*7p0lFpJwrT2ZHngS.png)

尽管并不完美，LSTM 在大部分情况下都能正确预测接下来的股价。而且你只能预测到股票接下来是涨是跌，而非股价的确切值。

### 总结

但愿本教程能帮到你，写这篇教程也让我受益匪浅。在本教程中，我了解到建立能够正确预测股价走势的模型是非常困难的。首先我们探讨了预测股价的动机。接下来我们了解到如何去下载并处理数据。然后我们介绍了两种可以向后预测一步的平均技术，这两种方法在预测多步时并不管用。之后，我们讨论了如何使用 LSTM 对未来的多步进行预测。最后，结果可视化，并发现这个模型（尽管并不完美）能出色地预测股价走势。

下面是本教程中对几个要点：

1.  股票价格/走势预测是一项极其困难的任务。就我个人而言，我认为任何股票预测模型都不完全正确，因此它们不应该被盲目地依赖。模型并不总是正确的。

2.  不要相信那些声称预测曲线与真实股价完全重合的文章。那些取平均的方法在实践中并不管用。更明智的做法是预测股价走势。

3.  模型的超参数会显著影响训练结果。所以最好使用一些诸如 Grid search 和 Random search 的调参技巧，下面是一系列非常重要的超参数：**优化器的学习速率、网络层数、每层中的隐藏节点个数、优化器（Adam 是最好用的）以及模型的种类（GRU / LSTM / 增加 peephole connection 的 LSTM）**。

4.  在本教程中，由于数据集太小，我们根据测试损失函数来降低学习速率，这本身是不对的，因为这间接地将有关测试集的信息泄露到训练过程中。一种更好的处理方法是使用一个独立的验证集（与测试集不同），并根据验证集的性能降低学习速率。

### Jupyter Notebook：请访问我的 [GitHub](https://github.com/thushv89/datacamp_tutorials) 来获取。

### 参考

我参照 [这个](https://github.com/jaungiers/LSTM-Neural-Network-for-Time-Series-Prediction) 理解了怎样使用 LSTM 来预测股价。但是实现细节与之有很大不同。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
