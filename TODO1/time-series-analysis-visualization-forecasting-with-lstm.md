> * 原文地址：[Time Series Analysis, Visualization & Forecasting with LSTM](https://towardsdatascience.com/time-series-analysis-visualization-forecasting-with-lstm-77a905180eba)
> * 原文作者：[Susan Li](https://medium.com/@actsusanli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-visualization-forecasting-with-lstm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-visualization-forecasting-with-lstm.md)
> * 译者：
> * 校对者：

# Time Series Analysis, Visualization & Forecasting with LSTM

> Statistics normality test, Dickey–Fuller test for stationarity, Long short-term memory

![Photo credit: Unsplash](https://cdn-images-1.medium.com/max/9824/1*mtho0xL9Qu-cXu61XeLrdA.jpeg)

The title says it all.

Without further ado, let’s roll!

## The Data

The data is the measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years that can be downloaded from [here](https://www.kaggle.com/uciml/electric-power-consumption-data-set).

Different electrical quantities and some sub-metering values are available. However, we are only interested in Global_active_power variable.

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

The following data pre-processing and feature engineering steps need to be done:

* Merge Date & Time into one column and change to datetime type.
* Convert Global_active_power to numeric and remove missing values (1.2%).
* Create year, quarter, month and day features.
* Create weekday feature, “0” is weekend and “1” is weekday.

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

After removing the missing values, the data contains 2,049,280 measurements gathered between December 2006 and November 2010 (47 months).

The initial data contains several variables. We will here focus on a single value : a house’s Global_active_power history, that is, household global minute-averaged active power in kilowatt.

## Statistical Normality Test

There are several statistical tests that we can use to quantify whether our data looks as though it was drawn from a Gaussian distribution. And we will use [D’Agostino’s K² Test](https://en.wikipedia.org/wiki/D%27Agostino%27s_K-squared_test).

In the [SciPy](http://scipy.github.io/devdocs/index.html) implementation of the test, we will interpret the p value as follows.

* p \<= alpha: reject H0, not normal.
* p > alpha: fail to reject H0, normal.

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

We can also calculate [**Kurtosis**](https://en.wikipedia.org/wiki/Kurtosis) and [**Skewness**](https://en.wikipedia.org/wiki/Skewness), to determine if the data distribution departs from the normal distribution.

```
sns.distplot(df.Global_active_power);
print( 'Kurtosis of normal distribution: {}'.format(stats.kurtosis(df.Global_active_power)))
print( 'Skewness of normal distribution: {}'.format(stats.skew(df.Global_active_power)))
```

![Figure 1](https://cdn-images-1.medium.com/max/2000/1*9ju6xA26lyG1B0PvgtF2gA.png)

**Kurtosis**: describes heaviness of the tails of a distribution

Normal Distribution has a kurtosis of close to 0. If the kurtosis is greater than zero, then distribution has heavier tails. If the kurtosis is less than zero, then the distribution is light tails. And our Kurtosis is greater than zero.

**Skewness**: measures asymmetry of the distribution

If the skewness is between -0.5 and 0.5, the data are fairly symmetrical. If the skewness is between -1 and — 0.5 or between 0.5 and 1, the data are moderately skewed. If the skewness is less than -1 or greater than 1, the data are highly skewed. And our skewness is greater than 1.

## First Time Series Plot

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

![Figure 2](https://cdn-images-1.medium.com/max/2638/1*WjRLv5UzelL3t4e07pBrUg.png)

Apparently, this plot is not a good idea. Don’t do this.

## Box Plot of Yearly vs. Quarterly Global Active Power

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

![Figure 3](https://cdn-images-1.medium.com/max/2964/1*9ty6iztGg97CEwi4abPISg.png)

When we compare box plot side by side for each year, we notice that the median global active power in 2006 is much higher than the other years’. This is a little bit misleading. If you remember, we only have December data for 2006. While apparently December is the peak month for household electric power consumption.

This is consistent with the quarterly median global active power, it is higher in the 1st and 4th quarters (winter), and it is the lowest in the 3rd quarter (summer).

## Global Active Power Distribution

```python
plt.figure(figsize=(14,6))
plt.subplot(1,2,1)
df['Global_active_power'].hist(bins=50)
plt.title('Global Active Power Distribution')

plt.subplot(1,2,2)
stats.probplot(df['Global_active_power'], plot=plt);
df1.describe().T
```

![Figure 4](https://cdn-images-1.medium.com/max/2612/1*LLMi_qQpE5Tb1P8O63P9Zg.png)

Normal probability plot also shows the data is far from normally distributed.

## Average Global Active Power Resampled Over Day, Week, Month, Quarter and Year

```Python
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

![Figure 5](https://cdn-images-1.medium.com/max/2930/1*CFEGvZ4t-iPKZH8ciOjEew.png)

In general, our time series does not have a upward or downward trend. The highest average power consumption seems to be prior to 2007, actually it was because we had only December data in 2007 and that month was a high consumption month. In another word, if we compare year by year, it has been steady.

## Plot Mean Global Active Power Grouped by Year, Quarter, Month and Day

```Python
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

![Figure 6](https://cdn-images-1.medium.com/max/2302/1*gg63jSml7Sm5T611PSidmQ.png)

The above plots confirmed our previous discoveries. By year, it was steady. By quarter, the lowest average power consumption was in the 3rd quarter. By month, the lowest average power consumption was in July and August. By day, the lowest average power consumption was around 8th of the month (don’t know why).

## Global Active Power by Years

This time, we remove 2006.

```
pd.pivot_table(df.loc[df['year'] != 2006], values = "Global_active_power", 
               columns = "year", index = "month").plot(subplots = True, figsize=(12, 12), layout=(3, 5), sharey=True);
```

![Figure 7](https://cdn-images-1.medium.com/max/2000/1*eP6V7FHLsCTT1ZZoDIqDqA.png)

The pattern is similar every year from 2007 to 2010.

## Global Active Power Consumption in Weekdays vs. Weekends

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

![Figure 8](https://cdn-images-1.medium.com/max/2000/1*fyvGi1CgsMyocGBcVkREPQ.png)

The median global active power in weekdays seems to be lower than the weekends prior to 2010. In 2010, they were identical.

## Factor Plot of Global Active Power by Weekday vs. Weekend

```python
plt1=sns.factorplot('year','Global_active_power',hue='Day',
                    data=df, size=4, aspect=1.5, legend=False)                                                                                                                                                                                                                                                                                                                                             
plt.title('Factor Plot of Global active power by Weekend/Weekday')                                                             
plt.tight_layout()                                                                                                                  
sns.despine(left=True, bottom=True) 
plt.legend(loc='upper right');
```

![Figure 9](https://cdn-images-1.medium.com/max/2000/1*5XXi-NhDOonLL8yrh6QqQQ.png)

Both weekdays and weekends follow the similar pattern over year.

In principle we do not need to check for [**stationarity**](https://en.wikipedia.org/wiki/Stationary_process) nor correct for it when we are using an [**LSTM**](https://en.wikipedia.org/wiki/Long_short-term_memory). However, if the data is stationary, it will help with better performance and make it easier for the neural network to learn.

## Stationarity

In statistics, the [**Dickey–Fuller test**](https://en.wikipedia.org/wiki/Dickey%E2%80%93Fuller_test) tests the null hypothesis that a unit root is present in an autoregressive model. The alternative hypothesis is different depending on which version of the test is used, but is usually [stationarity](https://en.wikipedia.org/wiki/Stationary_process) or [trend-stationarity](https://en.wikipedia.org/wiki/Trend_stationary).

Stationary series has constant mean and variance over time. Rolling average and the rolling standard deviation of time series do not change over time.

## Dickey-Fuller test

[**Null Hypothesis**](https://en.wikipedia.org/wiki/Null_hypothesis) (H0): It suggests the time series has a unit root, meaning it is non-stationary. It has some time dependent structure.

[**Alternate Hypothesis**](https://en.wikipedia.org/wiki/Alternative_hypothesis) (H1): It suggests the time series does not have a unit root, meaning it is stationary. It does not have time-dependent structure.

p-value > 0.05: Accept the null hypothesis (H0), the data has a unit root and is non-stationary.

p-value \<= 0.05: Reject the null hypothesis (H0), the data does not have a unit root and is stationary.

```Python
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

![Figure 10](https://cdn-images-1.medium.com/max/2334/1*teCNF7iDamLWXTVFWOF3ew.png)

From the above results, we will reject the null hypothesis H0, the data does not have a unit root and is stationary.

## LSTM

The task here will be to predict values for a time series given the history of 2 million minutes of a household’s power consumption. We are going to use a multi-layered LSTM recurrent neural network to predict the last value of a sequence of values.

If you want to reduce the computation time, and also get a quick result to test the model, you may want to resample the data over hour. I will keep it is in minute.

The following data pre-processing and feature engineering need to be done before construct the LSTM model.

* Create the dataset, ensure all data is float.
* Normalize the features.
* Split into training and test sets.
* Convert an array of values into a dataset matrix.
* Reshape into X=t and Y=t+1.
* Reshape input to be 3D (num_samples, num_timesteps, num_features).

```Python
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

# reshape input to be [samples, time steps, features]
X_train = np.reshape(X_train, (X_train.shape[0], 1, X_train.shape[1]))
X_test = np.reshape(X_test, (X_test.shape[0], 1, X_test.shape[1]))
```

## Model Architecture

* Define the LSTM with 100 neurons in the first hidden layer and 1 neuron in the output layer for predicting Global_active_power. The input shape will be 1 time step with 30 features.
* Dropout 20%.
* Use the MSE loss function and the efficient Adam version of stochastic gradient descent.
* The model will be fit for 20 training epochs with a batch size of 70.

```Python
model = Sequential()
model.add(LSTM(100, input_shape=(X_train.shape[1], X_train.shape[2])))
model.add(Dropout(0.2))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam')

history = model.fit(X_train, Y_train, epochs=20, batch_size=70, validation_data=(X_test, Y_test), 
                    callbacks=[EarlyStopping(monitor='val_loss', patience=10)], verbose=1, shuffle=False)

model.summary()
```

## Make Predictions

```python
train_predict = model.predict(X_train)
test_predict = model.predict(X_test)
# invert predictions
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

## Plot Model Loss

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

![Figure 11](https://cdn-images-1.medium.com/max/2000/1*z6VdZ3BazbPmGmDIN0P8OA.png)

## Compare Actual vs. Prediction

For me, every time step is one minute. If you resampled the data over hour earlier, then every time step is one hour for you.

I will compare the actual and predictions for the last 200 minutes.

```python
aa=[x for x in range(200)]
plt.figure(figsize=(8,4))
plt.plot(aa, Y_test[0][:200], marker='.', label="actual")
plt.plot(aa, test_predict[:,0][:200], 'r', label="prediction")
# plt.tick_params(left=False, labelleft=True) #remove ticks
plt.tight_layout()
sns.despine(top=True)
plt.subplots_adjust(left=0.07)
plt.ylabel('Global_active_power', size=15)
plt.xlabel('Time step', size=15)
plt.legend(fontsize=15)
plt.show();
```

![Figure 12](https://cdn-images-1.medium.com/max/2000/1*fNpJ18MfE32UD0ib3LnrfA.png)

LSTMs are amazing!

[Jupyter notebook](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/LSTM%20Time%20Series%20Power%20Consumption.ipynb) can be found on [Github](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/LSTM%20Time%20Series%20Power%20Consumption.ipynb). Enjoy the rest of the week!

Reference:  
[**Multivariate Time Series Forecasting with LSTMs in Keras**](https://machinelearningmastery.com/multivariate-time-series-forecasting-lstms-keras/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
