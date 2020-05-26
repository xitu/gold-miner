> * 原文地址：[Extreme Rare Event Classification using Autoencoders in Keras](https://towardsdatascience.com/extreme-rare-event-classification-using-autoencoders-in-keras-a565b386f098)
> * 原文作者：[Chitta Ranjan](https://medium.com/@cran2367)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/extreme-rare-event-classification-using-autoencoders-in-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/extreme-rare-event-classification-using-autoencoders-in-keras.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[lsvih](https://github.com/lsvih)

# 在 Keras 下使用自编码器分类极端稀有事件

> 在本文中，我们将要学习使用自编码器搭建一个稀有事件分类器.我们将使用来自[1]的一个现实场景稀有事件数据集。

## 背景

### 什么是极端稀有事件？

在稀有事件问题中，我们面对的是一个不平衡的数据集。这代表着，相较于负样本，我们只有很少的正样本标签。典型的稀有事件问题中，正样本在全部数据中占比大概在 5-10% 之间。在极端稀有事件问题中，我们只有少于 1% 的正样本数据。比如，在我们使用的数据集中，正样本只有 0.6%。

这种极端稀有的事件在现实世界中是十分普遍的。比如，工厂中的纸张断裂和机器故障，在线销售行业中的点击或者购买。

分类这些稀有事件是十分具有挑战的。最近，深度学习被广泛应用于分类问题。然而，**少量的正样本限制了深度学习的应用**。不管数据量有多大，正样本数量都会限制深度学习的效果。

### 为什么还要绞尽脑汁使用深度学习？

这是一个合理的问题。我们为什么不去考虑使用其他的机器学习方法呢？

答案是主观的。我们可以使用机器学习方法。为了使它工作，我们可以对负样本数据进行负采样，使得数据接近平衡。由于正样本数据只有 0.6%，降采样后的数据集大概只有原始数据集大小的 1%。一些机器学习方法，如：SVM、随机森林等，都可以在这个数据量上工作。然而，它的准确率会受到限制。这是因为我们不会使用剩下的 99% 的数据。

如果数据充足，深度学习会表现的更好。它还可以通过使用不同的结构来灵活的改进模型。因此，我们准备尝试使用深度学习方法。

***

在本推文中，**我们将要学习如何使用一个简单的全连接层自编码器来搭建一个稀有事件分类器**。推文的目是为了展示一个极端稀有事件分类器的自编码器实现。我们将探索不同自编码器结构和配置的工作留给读者。如果有什么有趣的发现，请分享给我们。

## 针对分类的自编码器

自编码器处理分类任务的方法类似于**异常检测**。在异常检测中，我们学习正常过程的模式。任何与这个模式不一致的东西，我们都认为是异常的。对于一个稀有事件的二分类任务，我们可以用类似的方法使用自编码器（[延伸阅读](https://www.datascience.com/blog/fraud-detection-with-tensorflow) [2]）。

### 快速浏览：什么是自编码器？

* 自编码器由编码器和解码器组成。
* 编码器用来学习过程的潜在特征。这些特征通常是由少量的维度表出。
* 解码器可以从潜在的特征中重构出原始的数据。

![Figure 1. 自编码器的示意图。 [[Source](http://i-systems.github.io/HSE545/machine%20learning%20all/Workshop/CAE/06_CAE_Autoencoder.html): Autoencoder by Prof. Seungchul Lee
iSystems Design Lab]](https://cdn-images-1.medium.com/max/2000/1*S_OcBPkRTpKJo0iz5IaNbQ.png)

### 怎么使用自编码器来分类稀有事件？

* 我们首先将数据分为两个部分：正样本标签和负样本标签。
* 负样本标签被约定为过程的**正常**状态。**正常**状态是无事件的过程。
* 我们将忽视正样本数据，同时在负样本上训练这个自编码器。
* 现在，这个自编码器学习了所有**正常**过程的特征。
* 一个充分训练的自编码器可以预测任何来自**正常**状态的过程（因为他们有同样的模式和分布）。
* 因此，重构的误差会比较小。
* 然而，如果我们重构一个来自稀有事件的数据，那么自编码器会遇到困难。
* 这会导致重构稀有事件时，会有一个很高的重构误差。
* 我们可以捕获这些高重构误差同时标记它们为稀有事件
* 这个过程类似于异常检测。

## 实现

### 数据和问题

这是一个关于纸张断裂的二分类标签数据来自于造纸厂。在造纸厂，纸张断裂是一个严重的问题。单次的纸张断裂可能造成数千美金的损失，而且工厂每天至少会发生一次或多次纸张断裂。这导致每年数百万美元的损失和工作风险。

由于过程的性质，检测中断事件非常具有挑战性。正如[1]中提到的，即使减少 5% 的断裂也会给钢厂带来显著的好处。

通过 15 天的收集，我们得到了包含 18K 行的数据。列 ‘y’ 包含了二分类标签，1 代表断裂。 其他列是预测器。这里有 124 个正样本（~0.6%）。

从[这里]下载数据(https://docs.google.com/forms/d/e/1FAIpQLSdyUk3lfDl7I5KYK_pw285LCApc-_RcoC0Tf9cnDnZ_TWzPAw/viewform)下载数据。

### 代码

Import the desired libraries.

```python
%matplotlib inline
import matplotlib.pyplot as plt
import seaborn as sns

import pandas as pd
import numpy as np
from pylab import rcParams

import tensorflow as tf
from keras.models import Model, load_model
from keras.layers import Input, Dense
from keras.callbacks import ModelCheckpoint, TensorBoard
from keras import regularizers

from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, precision_recall_curve
from sklearn.metrics import recall_score, classification_report, auc, roc_curve
from sklearn.metrics import precision_recall_fscore_support, f1_score

from numpy.random import seed
seed(1)
from tensorflow import set_random_seed
set_random_seed(2)

SEED = 123 #used to help randomly select the data points
DATA_SPLIT_PCT = 0.2

rcParams['figure.figsize'] = 8, 6
LABELS = ["Normal","Break"]
```

注意，为了可复现结果，我们设置了随机数种子。

**数据处理**

现在，我们来读取和准备数据。

```python
df = pd.read_csv("data/processminer-rare-event-mts - data.csv")
```

这个稀有事件问题的目的是在发生断裂前预测它。我们尝试提前 4 分钟预测出断裂。为了建立这个模型，我们把数据标签提前 2 行（对应于 4 分钟）。通过这行代码实现 `df.y=df.y.shift(-2)`。然而，在这个问题中，我们想做的是：判断行 n 是否会被标记为正样本，

* 让 (**n**-2) 和 (**n**-1) 标记为 1。这样可以帮助分类器学习到提前 4 分钟预测。

* 删除 **n** 行。因为我们不想让分类器学习预测正在发生的断裂。

我们将为这个曲线移动开发以下 UDF。

```python
sign = lambda x: (1, -1)[x < 0]

def curve_shift(df, shift_by):
    '''
    这个函数是用来偏移数据中的二分类标签。
    平移只针对标签为 1 的数据
    举个例子，如果偏移量为 -2，下面的处理将会发生：
    如果是 n 行的标签为 1，那么
    - 使 (n+shift_by):(n+shift_by-1) = 1
    - 删除第 n 行。
    也就是说标签会上移 2 行。
    
    输入：
    df       一个分类标签列的 pandas 数据。
             这个标签列的名字是 ‘y’。
    shift_by 一个整数，表示要移动的行数。
    
    输出：
    df       按照偏移量平移过后的数据。
    '''

    vector = df['y'].copy()
    for s in range(abs(shift_by)):
        tmp = vector.shift(sign(shift_by))
        tmp = tmp.fillna(0)
        vector += tmp
    labelcol = 'y'
    # 添加向量到 df
    df.insert(loc=0, column=labelcol+'tmp', value=vector)
    # 删除 labelcol == 1 的行.
    df = df.drop(df[df[labelcol] == 1].index)
    # 丢弃 labelcol 同时将 tmp 作为 labelcol。
    df = df.drop(labelcol, axis=1)
    df = df.rename(columns={labelcol+'tmp': labelcol})
    # 制作二分类标签
    df.loc[df[labelcol] > 0, labelcol] = 1

    return df
```

现在，我们将数据分为训练集、验证集和测试集。然后我们将只使用标签为 0 的子集来训练自编码器。

```python
df_train, df_test = train_test_split(df, test_size=DATA_SPLIT_PCT, random_state=SEED)
df_train, df_valid = train_test_split(df_train, test_size=DATA_SPLIT_PCT, random_state=SEED)

df_train_0 = df_train.loc[df['y'] == 0]
df_train_1 = df_train.loc[df['y'] == 1]
df_train_0_x = df_train_0.drop(['y'], axis=1)
df_train_1_x = df_train_1.drop(['y'], axis=1)

df_valid_0 = df_valid.loc[df['y'] == 0]
df_valid_1 = df_valid.loc[df['y'] == 1]
df_valid_0_x = df_valid_0.drop(['y'], axis=1)
df_valid_1_x = df_valid_1.drop(['y'], axis=1)

df_test_0 = df_test.loc[df['y'] == 0]
df_test_1 = df_test.loc[df['y'] == 1]
df_test_0_x = df_test_0.drop(['y'], axis=1)
df_test_1_x = df_test_1.drop(['y'], axis=1)
```

**标准化**

对于自编码器，通常最好使用标准化数据(转换为高斯、均值 0 和方差 1)。

```python
scaler = StandardScaler().fit(df_train_0_x)
df_train_0_x_rescaled = scaler.transform(df_train_0_x)
df_valid_0_x_rescaled = scaler.transform(df_valid_0_x)
df_valid_x_rescaled = scaler.transform(df_valid.drop(['y'], axis = 1))

df_test_0_x_rescaled = scaler.transform(df_test_0_x)
df_test_x_rescaled = scaler.transform(df_test.drop(['y'], axis = 1))
```

### 自编码分类器

**初始化**

首先，我们将初始化自编码器框架。我们只构建一个简单的自编码器。更多复杂的结构和配置留给读者去探索。

```python
nb_epoch = 100
batch_size = 128
input_dim = df_train_0_x_rescaled.shape[1] #num of predictor variables, 
encoding_dim = 32
hidden_dim = int(encoding_dim / 2)
learning_rate = 1e-3

input_layer = Input(shape=(input_dim, ))
encoder = Dense(encoding_dim, activation="tanh", activity_regularizer=regularizers.l1(learning_rate))(input_layer)
encoder = Dense(hidden_dim, activation="relu")(encoder)
decoder = Dense(hidden_dim, activation='tanh')(encoder)
decoder = Dense(input_dim, activation='relu')(decoder)
autoencoder = Model(inputs=input_layer, outputs=decoder)
```

**训练**

我们将训练模型，并保存它到指定文件。存储训练模型是节省未来分析时间的好方法。

```python
autoencoder.compile(metrics=['accuracy'],
                    loss='mean_squared_error',
                    optimizer='adam')

cp = ModelCheckpoint(filepath="autoencoder_classifier.h5",
                               save_best_only=True,
                               verbose=0)

tb = TensorBoard(log_dir='./logs',
                histogram_freq=0,
                write_graph=True,
                write_images=True)

history = autoencoder.fit(df_train_0_x_rescaled, df_train_0_x_rescaled,
                    epochs=nb_epoch,
                    batch_size=batch_size,
                    shuffle=True,
                    validation_data=(df_valid_0_x_rescaled, df_valid_0_x_rescaled),
                    verbose=1,
                    callbacks=[cp, tb]).history
```

![Figure 2. 自编码器训练过程的损失值。](https://cdn-images-1.medium.com/max/2696/1*dMlsnQly8WLMNoJqjG9nVg.png)

**分类器**

接下来，我们将展示我们如何使用自编码器对于稀有事件的重构误差来做分类。

之前已经提到，如果重构误差比较高，我们将认定它是一次断裂。我们需要定一个阈值。

我们使用验证集来设置阈值。

```python
valid_x_predictions = autoencoder.predict(df_valid_x_rescaled)
mse = np.mean(np.power(df_valid_x_rescaled - valid_x_predictions, 2), axis=1)
error_df = pd.DataFrame({'Reconstruction_error': mse,
                        'True_class': df_valid['y']})

precision_rt, recall_rt, threshold_rt = precision_recall_curve(error_df.True_class, error_df.Reconstruction_error)
plt.plot(threshold_rt, precision_rt[1:], label="Precision",linewidth=5)
plt.plot(threshold_rt, recall_rt[1:], label="Recall",linewidth=5)
plt.title('Precision and recall for different threshold values')
plt.xlabel('Threshold')
plt.ylabel('Precision/Recall')
plt.legend()
plt.show()
```

![Figure 3. 阈值为0.85应该在精确度和召回率之间提供一个合理的平衡。](https://cdn-images-1.medium.com/max/2768/1*s5MCn5NruZSXSu7MAg4jNA.png)

现在，我们将对测试数据进行分类。

> **我们不应该根据测试数据来估计分类阈值。这会导致过拟合。**

```python
test_x_predictions = autoencoder.predict(df_test_x_rescaled)
mse = np.mean(np.power(df_test_x_rescaled - test_x_predictions, 2), axis=1)
error_df_test = pd.DataFrame({'Reconstruction_error': mse,
                        'True_class': df_test['y']})
error_df_test = error_df_test.reset_index()

threshold_fixed = 0.85
groups = error_df_test.groupby('True_class')

fig, ax = plt.subplots()

for name, group in groups:
    ax.plot(group.index, group.Reconstruction_error, marker='o', ms=3.5, linestyle='',
            label= "Break" if name == 1 else "Normal")
ax.hlines(threshold_fixed, ax.get_xlim()[0], ax.get_xlim()[1], colors="r", zorder=100, label='Threshold')
ax.legend()
plt.title("Reconstruction error for different classes")
plt.ylabel("Reconstruction error")
plt.xlabel("Data point index")
plt.show();
```

![Figure 4. 使用阈值 = 0.85 进行分类。阈值线上方的橙色和蓝色圆点分别表示真阳性和假阳性。](https://cdn-images-1.medium.com/max/3308/1*MjCGb-HIfcyiFoeFyjF2Dw.png)

在图 4 中，阈值线上方的橙色和蓝色圆点分别表示真阳性和假阳性。正如我们所看到的，我们有很多假阳性。为了更好的理解，我们使用混淆矩阵来表示。

```python
pred_y = [1 if e > threshold_fixed else 0 for e in error_df.Reconstruction_error.values]

conf_matrix = confusion_matrix(error_df.True_class, pred_y)

plt.figure(figsize=(12, 12))
sns.heatmap(conf_matrix, xticklabels=LABELS, yticklabels=LABELS, annot=True, fmt="d");
plt.title("Confusion matrix")
plt.ylabel('True class')
plt.xlabel('Predicted class')
plt.show()
```

![Figure 5. 测试集预测结果的混淆矩阵。](https://cdn-images-1.medium.com/max/2948/1*MSwOdDkv8coFWzgYhTCVgw.png)

我们可以预测 32 次断裂中的 9 次。值得注意的是，这些结果是提前 2 到 4 分钟预测的。这一比率大概是 28%，这对于造纸业来说已经是一个很好的召回率了。假阳性大致是 6.3%。这并不完美，但是对于工厂而言也不坏。

该模型还可以进一步改进，在假阳性率较小的情况下提高召回率。我们将在下面讨论 AUC，然后讨论下一个改进方法。

**ROC 曲线和 AUC**

```python
false_pos_rate, true_pos_rate, thresholds = roc_curve(error_df.True_class, error_df.Reconstruction_error)
roc_auc = auc(false_pos_rate, true_pos_rate,)

plt.plot(false_pos_rate, true_pos_rate, linewidth=5, label='AUC = %0.3f'% roc_auc)
plt.plot([0,1],[0,1], linewidth=5)

plt.xlim([-0.01, 1])
plt.ylim([0, 1.01])
plt.legend(loc='lower right')
plt.title('Receiver operating characteristic curve (ROC)')
plt.ylabel('True Positive Rate')
plt.xlabel('False Positive Rate')
plt.show()
```

![](https://cdn-images-1.medium.com/max/3420/1*GAyB6Bruo8YNBiEUiav0mw.png)

AUC 的结构是 0.624。

### Github 仓库

带有注释的代码在[这里](https://github.com/cran2367/autoencoder_classifier)。
[**cran2367/autoencoder_classifier**
**Autoencoder model for rare event classification. Contribute to cran2367/autoencoder_classifier development by creating…**github.com](https://github.com/cran2367/autoencoder_classifier/blob/master/autoencoder_classifier.ipynb)

## 还有什么可以做得更好呢?

这是一个（多元）时间序列数据。我们没有考虑数据中的时间信息/模式。我们将在[下一篇推文](https://medium.com/@cran2367/lstm-autoencoder-for-extreme-rare-event-classification-in-keras-ce209a224cfb)探索是否可以结合 RNN 进行分类。我们将尝试 [LSTM autoencoder](https://medium.com/@cran2367/lstm-autoencoder-for-extreme-rare-event-classification-in-keras-ce209a224cfb)。

## 结论

我们研究了一个工作于造纸厂的极端稀有事件的二值数据的自编码分类器。我们达到了不错的准确度。我们的目的是展示自编码器对于稀有事件分类问题的基础应用。我们之后会尝试开发其它的方法，包括可以结合时空特征的 [LSTM Autoencoder](https://medium.com/@cran2367/lstm-autoencoder-for-extreme-rare-event-classification-in-keras-ce209a224cfb) 来达到一个更好的效果。

下一篇关于 LSTM 自编码的推文在这里 [LSTM Autoencoder for rare event classification](https://medium.com/@cran2367/lstm-autoencoder-for-extreme-rare-event-classification-in-keras-ce209a224cfb).

## 引用

1. Ranjan, C., Mustonen, M., Paynabar, K., & Pourak, K. (2018). Dataset: Rare Event Classification in Multivariate Time Series. [**arXiv preprint arXiv:1809.10717**](https://arxiv.org/abs/1809.10717).
2. [https://www.datascience.com/blog/fraud-detection-with-tensorflow](https://www.datascience.com/blog/fraud-detection-with-tensorflow)
3. Github repo: [https://github.com/cran2367/autoencoder_classifier](https://github.com/cran2367/autoencoder_classifier)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
