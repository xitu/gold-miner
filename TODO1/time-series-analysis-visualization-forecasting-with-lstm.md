> * 原文地址：[Time Series Analysis, Visualization & Forecasting with LSTM](https://towardsdatascience.com/time-series-analysis-visualization-forecasting-with-lstm-77a905180eba)
> * 原文作者：[Susan Li](https://medium.com/@actsusanli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-visualization-forecasting-with-lstm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-visualization-forecasting-with-lstm.md)
> * 译者：[Minghao23](https://github.com/Minghao23)
> * 校对者：[Xuyuey](https://github.com/Xuyuey)，[TrWestdoor](https://github.com/TrWestdoor)

# 时间序列分析、可视化、和使用 LSTM 预测

> 统计正态性检验，平稳性 Dickey-Fuller 检验，长短期记忆网络

![Photo credit: Unsplash](https://cdn-images-1.medium.com/max/9824/1*mtho0xL9Qu-cXu61XeLrdA.jpeg)

标题已经阐述了一切。

闲话少说，让我们直接开始吧！

## 数据

该数据是在近四年的时间里对一个家庭以一分钟采样率测量的电力消耗，可以在[这里](https://www.kaggle.com/uciml/electric-power-consumption-data-set)下载。

数据包括不同的电量值和一些分表的数值。然而，我们只关注 Global_active_power 这个变量。

```python
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
pd.set_option('display.float_format', lambda x: '%.4f' % x)
import seaborn as sns
sns.set_context("paper", font_scale=1.3)
sns.set_style('white')
import warnings
warnings.filterwarnings('ignore')
from time import time
import matplotlib.ticker as tkr
from scipy import stats
from statsmodels.tsa.stattools import adfuller
from sklearn import preprocessing
from statsmodels.tsa.stattools import pacf
%matplotlib inline

import math
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout
from keras.layers import *
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
from keras.callbacks import EarlyStopping

df=pd.read_csv('household_power_consumption.txt', delimiter=';')
print('Number of rows and columns:', df.shape)
df.head(5)
```

![Table 1](https://cdn-images-1.medium.com/max/2790/1*_uhygRBN14RxN6nVGTPDpA.png)

以下数据预处理和特征工程步骤需要完成：

* 将日期和时间合并到同一列，并转换为 datetime 类型。
* 将 Global_active_power 转换为数值型，并移除缺失值（1.2%）。
* 创建年、季度、月和日的特征。
* 创建周的特征，“0”表示周末，“1”表示工作日。

```python
df['date_time'] = pd.to_datetime(df['Date'] + ' ' + df['Time'])
df['Global_active_power'] = pd.to_numeric(df['Global_active_power'], errors='coerce')
df = df.dropna(subset=['Global_active_power'])
df['date_time']=pd.to_datetime(df['date_time'])
df['year'] = df['date_time'].apply(lambda x: x.year)
df['quarter'] = df['date_time'].apply(lambda x: x.quarter)
df['month'] = df['date_time'].apply(lambda x: x.month)
df['day'] = df['date_time'].apply(lambda x: x.day)
df=df.loc[:,['date_time','Global_active_power', 'year','quarter','month','day']]
df.sort_values('date_time', inplace=True, ascending=True)
df = df.reset_index(drop=True)
df["weekday"]=df.apply(lambda row: row["date_time"].weekday(),axis=1)
df["weekday"] = (df["weekday"] < 5).astype(int)

print('Number of rows and columns after removing missing values:', df.shape)
print('The time series starts from: ', df.date_time.min())
print('The time series ends on: ', df.date_time.max())
```

![](https://cdn-images-1.medium.com/max/2000/1*6J4X7Ft17os7DYKYYF-HEQ.png)

移除缺失值之后，数据包括从 2006 年 12 月到 2010 年 11 月（47 个月）共 2,049,280 个测量值。

初始数据包括多个变量。这里我们只会关注一个单独的变量：房屋的 Global_active_power 历史记录，也就是整个房屋平均每分钟消耗的有功功率，单位是千瓦。

## 统计正态性检验

有一些统计测试方法可以用来量化我们的数据是否看起来像高斯分布采样。我们将会使用 [D’Agostino’s K² 检验](https://en.wikipedia.org/wiki/D%27Agostino%27s_K-squared_test)。

在 [SciPy](http://scipy.github.io/devdocs/index.html) 对这个检验的实现中，我们对 p 值做出如下解释。

* p <= alpha：拒绝 H0，非正态。
* p > alpha：不拒绝 H0，正态。

```python
stat, p = stats.normaltest(df.Global_active_power)
print('Statistics=%.3f, p=%.3f' % (stat, p))
alpha = 0.05
if p > alpha:
    print('Data looks Gaussian (fail to reject H0)')
else:
    print('Data does not look Gaussian (reject H0)')
```

![](https://cdn-images-1.medium.com/max/2000/1*JQpoCL2OxTKrfzdHkXG4AA.png)

同时我们也会计算[**峰度**](https://en.wikipedia.org/wiki/Kurtosis)和[**偏度**](https://en.wikipedia.org/wiki/Skewness)，以确定数据分布是否偏离正态分布。

```python
sns.distplot(df.Global_active_power);
print( 'Kurtosis of normal distribution: {}'.format(stats.kurtosis(df.Global_active_power)))
print( 'Skewness of normal distribution: {}'.format(stats.skew(df.Global_active_power)))
```

![图 1](https://cdn-images-1.medium.com/max/2000/1*9ju6xA26lyG1B0PvgtF2gA.png)

**峰度**：描述分布的尾重

正态分布的峰度接近于 0。如果峰度大于 0，则分布尾部较重。如果峰度小于 0，则分布尾部较轻。我们计算出的峰度是大于 0 的。

**偏度**：度量分布的不对称性

如果偏度介于 -0.5 和 0.5 之间，则数据是基本对称的。如果偏度介于 -1 和 -0.5 之间或者 0.5 和 1 之间，则数据是稍微偏斜的。如果偏度小于 -1 或大于 1，则数据是高度偏斜的。我们计算出的偏度是大于 1 的。

## 第一个时间序列图像

```python
df1=df.loc[:,['date_time','Global_active_power']]
df1.set_index('date_time',inplace=True)
df1.plot(figsize=(12,5))
plt.ylabel('Global active power')
plt.legend().set_visible(False)
plt.tight_layout()
plt.title('Global Active Power Time Series')
sns.despine(top=True)
plt.show();
```

![图 2](https://cdn-images-1.medium.com/max/2638/1*WjRLv5UzelL3t4e07pBrUg.png)

很明显，这个图像并不是我们想要的。不要这么做。

## 年度和季度总体有功功率箱形图对比

```python
plt.figure(figsize=(14,5))
plt.subplot(1,2,1)
plt.subplots_adjust(wspace=0.2)
sns.boxplot(x="year", y="Global_active_power", data=df)
plt.xlabel('year')
plt.title('Box plot of Yearly Global Active Power')
sns.despine(left=True)
plt.tight_layout()

plt.subplot(1,2,2)
sns.boxplot(x="quarter", y="Global_active_power", data=df)
plt.xlabel('quarter')
plt.title('Box plot of Quarterly Global Active Power')
sns.despine(left=True)
plt.tight_layout();
```

![图 3](https://cdn-images-1.medium.com/max/2964/1*9ty6iztGg97CEwi4abPISg.png)

当并排比较每年的箱形图时，我们注意到 2006 年的总体有功功率的中位数相比于其他年份高很多。其实这里会有一点误导。如果你还记得，我们只有 2006 年 12 月的数据。而很明显 12 月是一个家庭电力消耗的高峰月。

季度总体有功功率的中位数就比较符合预期，第一、四季度（冬季）较高，第三季度（夏季）最低。

## 总体有功功率分布

```python
plt.figure(figsize=(14,6))
plt.subplot(1,2,1)
df['Global_active_power'].hist(bins=50)
plt.title('Global Active Power Distribution')

plt.subplot(1,2,2)
stats.probplot(df['Global_active_power'], plot=plt);
df1.describe().T
```

![图 4](https://cdn-images-1.medium.com/max/2612/1*LLMi_qQpE5Tb1P8O63P9Zg.png)

正态概率图也显示这个数据与正态分布偏离很大。

## 按照天、周、月、季度和年重新抽样平均总体有功功率

```python
fig = plt.figure(figsize=(18,16))
fig.subplots_adjust(hspace=.4)
ax1 = fig.add_subplot(5,1,1)
ax1.plot(df1['Global_active_power'].resample('D').mean(),linewidth=1)
ax1.set_title('Mean Global active power resampled over day')
ax1.tick_params(axis='both', which='major')

ax2 = fig.add_subplot(5,1,2, sharex=ax1)
ax2.plot(df1['Global_active_power'].resample('W').mean(),linewidth=1)
ax2.set_title('Mean Global active power resampled over week')
ax2.tick_params(axis='both', which='major')

ax3 = fig.add_subplot(5,1,3, sharex=ax1)
ax3.plot(df1['Global_active_power'].resample('M').mean(),linewidth=1)
ax3.set_title('Mean Global active power resampled over month')
ax3.tick_params(axis='both', which='major')

ax4  = fig.add_subplot(5,1,4, sharex=ax1)
ax4.plot(df1['Global_active_power'].resample('Q').mean(),linewidth=1)
ax4.set_title('Mean Global active power resampled over quarter')
ax4.tick_params(axis='both', which='major')

ax5  = fig.add_subplot(5,1,5, sharex=ax1)
ax5.plot(df1['Global_active_power'].resample('A').mean(),linewidth=1)
ax5.set_title('Mean Global active power resampled over year')
ax5.tick_params(axis='both', which='major');
```

![](https://cdn-images-1.medium.com/max/2912/1*Q1l143_6aSredba6WCrZ8w.png)

![](https://cdn-images-1.medium.com/max/2912/1*elxuVoG1JZ4k3xWkHsZ_9g.png)

![](https://cdn-images-1.medium.com/max/2926/1*7ZodE8tdX98HGPMpEECEug.png)

![](https://cdn-images-1.medium.com/max/2942/1*m70T6psxaS64c_GWt7uj-w.png)

![图 5](https://cdn-images-1.medium.com/max/2930/1*CFEGvZ4t-iPKZH8ciOjEew.png)

通常来说，我们的时间序列不会存在上升或下降的趋势。最高的平均耗电量似乎是在 2007 年之前，实际上这是因为我们在 2007 年只有 12 月的数据（译者注：原文有误，应该是只有 2006 年 12 月的数据），而那个月是用电高峰月。也就是说，如果我们逐年比较，这个序列其实较为平稳。

## 绘制总体有功功率均值图，并以年、季、月和天分组

```python
plt.figure(figsize=(14,8))
plt.subplot(2,2,1)
df.groupby('year').Global_active_power.agg('mean').plot()
plt.xlabel('')
plt.title('Mean Global active power by Year')

plt.subplot(2,2,2)
df.groupby('quarter').Global_active_power.agg('mean').plot()
plt.xlabel('')
plt.title('Mean Global active power by Quarter')

plt.subplot(2,2,3)
df.groupby('month').Global_active_power.agg('mean').plot()
plt.xlabel('')
plt.title('Mean Global active power by Month')

plt.subplot(2,2,4)
df.groupby('day').Global_active_power.agg('mean').plot()
plt.xlabel('')
plt.title('Mean Global active power by Day');
```

![图 6](https://cdn-images-1.medium.com/max/2302/1*gg63jSml7Sm5T611PSidmQ.png)

以上的图像证实了我们之前的发现。以年为单位，序列较为平稳。以季度为单位，最低的平均耗电量处于第三季度。以月为单位，最低的平均耗电量处于七月和八月。以天为单位，最低的平均耗电量大约在每月的 8 号（不知道为什么）。

## 每年的总体有功功率

这一次，我们移除 2006 年。

```python
pd.pivot_table(df.loc[df['year'] != 2006], values = "Global_active_power",
               columns = "year", index = "month").plot(subplots = True, figsize=(12, 12), layout=(3, 5), sharey=True);
```

![图 7](https://cdn-images-1.medium.com/max/2000/1*eP6V7FHLsCTT1ZZoDIqDqA.png)

从 2007 年到 2010 年，每年的模式都很相似。

## 工作日和周末的总体有功功率对比

```python
dic={0:'Weekend',1:'Weekday'}
df['Day'] = df.weekday.map(dic)

a=plt.figure(figsize=(9,4))
plt1=sns.boxplot('year','Global_active_power',hue='Day',width=0.6,fliersize=3,
                    data=df)
a.legend(loc='upper center', bbox_to_anchor=(0.5, 1.00), shadow=True, ncol=2)
sns.despine(left=True, bottom=True)
plt.xlabel('')
plt.tight_layout()
plt.legend().set_visible(False);
```

![图 8](https://cdn-images-1.medium.com/max/2000/1*fyvGi1CgsMyocGBcVkREPQ.png)

在 2010 年以前，工作日的总体有功功率的中位数要比周末低一些。在 2010 年，它们完全相等。

## 工作日和周末的总体有功功率对比的因素图

```python
plt1=sns.factorplot('year','Global_active_power',hue='Day',
                    data=df, size=4, aspect=1.5, legend=False)
plt.title('Factor Plot of Global active power by Weekend/Weekday')
plt.tight_layout()
sns.despine(left=True, bottom=True)
plt.legend(loc='upper right');
```

![图 9](https://cdn-images-1.medium.com/max/2000/1*5XXi-NhDOonLL8yrh6QqQQ.png)

以年为单位，工作日和周末都遵循同样的模式。

原则上，当使用 [**LSTM**](https://en.wikipedia.org/wiki/Long_short-term_memory) 时，我们不需要去检验或修正[**平稳性**](https://en.wikipedia.org/wiki/Stationary_process)。然而，如果数据是平稳的，它会帮助模型提高性能，使神经网络更容易学习。

## 平稳性

在统计学中，[**Dickey–Fuller test**](https://en.wikipedia.org/wiki/Dickey%E2%80%93Fuller_test) 检验了一个零假设，即单位根存在于自回归模型中。备择假设依据使用的检验方法的不同而不同，但是通常为[平稳性](https://en.wikipedia.org/wiki/Stationary_process)或[趋势平稳性](https://en.wikipedia.org/wiki/Trend_stationary)。

平稳序列的均值和方差一直是常数。时间序列在滑动窗口下的均值和标准差不随时间变化。

## Dickey-Fuller 检验

[**零检验**](https://en.wikipedia.org/wiki/Null_hypothesis)（H0）：表明时间序列有一个单位根，意味着它是非平稳的。它包含一些和时间相关的成分。

[**备择检验**](https://en.wikipedia.org/wiki/Alternative_hypothesis)（H1）：表明时间序列不存在单位根，意味着它是平稳的。它不包含和时间相关的成分。

p-value > 0.05：接受零检验（H0），数据有单位根且是非平稳的。

p-value \<= 0.05：拒绝零检验（H0），数据没有单位根且是平稳的。

```python
df2=df1.resample('D', how=np.mean)

def test_stationarity(timeseries):
    rolmean = timeseries.rolling(window=30).mean()
    rolstd = timeseries.rolling(window=30).std()

    plt.figure(figsize=(14,5))
    sns.despine(left=True)
    orig = plt.plot(timeseries, color='blue',label='Original')
    mean = plt.plot(rolmean, color='red', label='Rolling Mean')
    std = plt.plot(rolstd, color='black', label = 'Rolling Std')

    plt.legend(loc='best'); plt.title('Rolling Mean & Standard Deviation')
    plt.show()

    print ('<Results of Dickey-Fuller Test>')
    dftest = adfuller(timeseries, autolag='AIC')
    dfoutput = pd.Series(dftest[0:4],
                         index=['Test Statistic','p-value','#Lags Used','Number of Observations Used'])
    for key,value in dftest[4].items():
        dfoutput['Critical Value (%s)'%key] = value
    print(dfoutput)
test_stationarity(df2.Global_active_power.dropna())
```

![图 10](https://cdn-images-1.medium.com/max/2334/1*teCNF7iDamLWXTVFWOF3ew.png)

从以上结论可得，我们会拒绝零检验 H0，因为数据没有单位根且是平稳的。

## LSTM

我们的任务是根据一个家庭两百万分钟的耗电量历史记录，对这个时间序列做预测。我们将使用一个多层的 LSTM 递归神经网络来预测时间序列的最后一个值。

如果你想缩减计算时间，并快速获得结果来检验模型，你可以对数据以小时为单位重新采样。在本文的实验中我会维持原单位为分钟。

在构建 LSTM 模型之前，需要进行下列数据预处理和特征工程的工作。

* 创建数据集，保证所有的数据的类型都是 float。
* 特征标准化。
* 分割训练集和测试集。
* 将数值数组转换为数据集矩阵。
* 将维度转化为 X=t 和 Y=t+1。
* 将输入维度转化为三维 (num_samples, num_timesteps, num_features)。

```python
dataset = df.Global_active_power.values #numpy.ndarray
dataset = dataset.astype('float32')
dataset = np.reshape(dataset, (-1, 1))
scaler = MinMaxScaler(feature_range=(0, 1))
dataset = scaler.fit_transform(dataset)
train_size = int(len(dataset) * 0.80)
test_size = len(dataset) - train_size
train, test = dataset[0:train_size,:], dataset[train_size:len(dataset),:]

def create_dataset(dataset, look_back=1):
    X, Y = [], []
    for i in range(len(dataset)-look_back-1):
        a = dataset[i:(i+look_back), 0]
        X.append(a)
        Y.append(dataset[i + look_back, 0])
    return np.array(X), np.array(Y)

look_back = 30
X_train, Y_train = create_dataset(train, look_back)
X_test, Y_test = create_dataset(test, look_back)

# 将输入维度转化为 [samples, time steps, features]
X_train = np.reshape(X_train, (X_train.shape[0], 1, X_train.shape[1]))
X_test = np.reshape(X_test, (X_test.shape[0], 1, X_test.shape[1]))
```

## 模型结构

* 定义 LSTM 模型，第一个隐藏层含有 100 个神经元，输出层含有 1 个神经元，用于预测 Global_active_power。输入的维度是一个包含 30 个特征的时间步长。
* Dropout 20%。
* 使用均方差损失函数，和改进于随机梯度下降的效率更高的 Adam。
* 模型将会进行 20 个 epochs 的训练，每个 batch 的大小为 70。

```python
model = Sequential()
model.add(LSTM(100, input_shape=(X_train.shape[1], X_train.shape[2])))
model.add(Dropout(0.2))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam')

history = model.fit(X_train, Y_train, epochs=20, batch_size=70, validation_data=(X_test, Y_test),
                    callbacks=[EarlyStopping(monitor='val_loss', patience=10)], verbose=1, shuffle=False)

model.summary()
```

## 做出预测

```python
train_predict = model.predict(X_train)
test_predict = model.predict(X_test)
# 预测值求逆
train_predict = scaler.inverse_transform(train_predict)
Y_train = scaler.inverse_transform([Y_train])
test_predict = scaler.inverse_transform(test_predict)
Y_test = scaler.inverse_transform([Y_test])

print('Train Mean Absolute Error:', mean_absolute_error(Y_train[0], train_predict[:,0]))
print('Train Root Mean Squared Error:',np.sqrt(mean_squared_error(Y_train[0], train_predict[:,0])))
print('Test Mean Absolute Error:', mean_absolute_error(Y_test[0], test_predict[:,0]))
print('Test Root Mean Squared Error:',np.sqrt(mean_squared_error(Y_test[0], test_predict[:,0])))
```

![](https://cdn-images-1.medium.com/max/2000/1*b8JlFAzFOi6oihjc915gOg.png)

## 绘制模型损失

```python
plt.figure(figsize=(8,4))
plt.plot(history.history['loss'], label='Train Loss')
plt.plot(history.history['val_loss'], label='Test Loss')
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epochs')
plt.legend(loc='upper right')
plt.show();
```

![图 11](https://cdn-images-1.medium.com/max/2000/1*z6VdZ3BazbPmGmDIN0P8OA.png)

## 比较真实值和预测值

在我的结果中，每个时间步长是 1 分钟。如果你之前以小时重新采样了数据，那么在你的结果里每个时间步长是 1 小时。

我将会比较最近 200 分钟的真实值和预测值。

```python
aa=[x for x in range(200)]
plt.figure(figsize=(8,4))
plt.plot(aa, Y_test[0][:200], marker='.', label="actual")
plt.plot(aa, test_predict[:,0][:200], 'r', label="prediction")
# plt.tick_params(left=False, labelleft=True) # 移除 ticks
plt.tight_layout()
sns.despine(top=True)
plt.subplots_adjust(left=0.07)
plt.ylabel('Global_active_power', size=15)
plt.xlabel('Time step', size=15)
plt.legend(fontsize=15)
plt.show();
```

![图 12](https://cdn-images-1.medium.com/max/2000/1*fNpJ18MfE32UD0ib3LnrfA.png)

LSTMs 太神奇了！

[Jupyter notebook](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/LSTM%20Time%20Series%20Power%20Consumption.ipynb) 可以在 [Github](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/LSTM%20Time%20Series%20Power%20Consumption.ipynb) 中找到。享受这一周余下的时光吧！

参考：

- [**Multivariate Time Series Forecasting with LSTMs in Keras**](https://machinelearningmastery.com/multivariate-time-series-forecasting-lstms-keras/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
