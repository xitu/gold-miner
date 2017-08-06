
> * 原文地址：[How to Handle Imbalanced Classes in Machine Learning](https://elitedatascience.com/imbalanced-classes)
> * 原文作者：[elitedatascience](https://elitedatascience.com/imbalanced-classes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-handle-imbalanced-classes-in-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-handle-imbalanced-classes-in-machine-learning.md)
> * 译者：[RichardLeeH](https://github.com/RichardLeeH)
> * 校对者：[lsvih](https://github.com/lsvih), [lileizhenshuai](https://github.com/lileizhenshuai)

# 如何处理机器学习中的不平衡类别

不平衡类别使得“准确率”失去意义。这是机器学习 (特别是在分类)中一个令人惊讶的常见问题，出现于每个类别的观测样本不成比例的数据集中。

普通的准确率不再能够可靠地度量性能，这使得模型训练变得更加困难。

不平衡类别出现在多个领域，包括：

- 欺诈检测
- 垃圾邮件过滤
- 疾病筛查
- SaaS 客户流失
- 广告点击率

在本指南中，我们将探讨 5 种处理不平衡类别的有效方法。

![How to Handle Imbalanced Classes in Machine Learning](https://elitedatascience.com/wp-content/uploads/2017/06/imbalanced-classes-feature-with-text.jpg)

#### 直观的例子：疾病筛查案例

假如你的客户是一家先进的研究医院，他们要求你基于采集于病人的生物输入来训练一个用于检测一种疾病的模型。

但这里有陷阱... 疾病非常罕见；筛查的病人中只有 8% 的患病率。

现在，在你开始之前，你觉得问题可能会怎样发展呢？想象一下，如果你根本没有去训练一个模型。相反，如果你只写一行代码，总是预测“没有疾病”，那会如何呢？

一个拙劣但准确的解决方案

```
def disease_screen(patient_data):
    # 忽略 patient_data
    return 'No Disease.'
```

很好，猜猜看？你的“解决方案”应该有 92% 的准确率！

不幸的是，以上准确率具有误导性。

- 对于未患该病的病人，你的准确率是 100% 。
- 对于已患该病的病人，你的准确率是 0%。
- 你的总体准确率非常高，因为大多数患者并没有患该病 (不是因为你的模型训练的好)。

这显然是一个问题，因为设计的许多机器学习算法是为了最大限度的提高整体准确率。本指南的其余部分将说明处理不平衡类别的不同策略。

#### 我们开始之前的重要提示：

首先，请注意，我们不会分离出一个独立的测试集，调整超参数或者实现交叉检验。换句话说，我们不打算遵循最佳做法 (在我们的[7 天速成课程](http://elitedatascience.com/)中有介绍)。

相反，本教程只专注于解决不平衡类别问题。

此外，并非以下每种技术都会适用于每一个问题。不过通常来说，这些技术中至少有一个能够解决问题。

## Balance Scale 数据集

对于本指南，我们将会使用一个叫做 Balance Scale 数据的合成数据集，你可以从[这里](http://archive.ics.uci.edu/ml/datasets/balance+scale) UCI 机器学习仓库下载。

这个数据集最初被生成用于模拟心理实验结果，但是对于我们非常有用，因为它的规模便于处理并且包含不平衡类别

导入第三方依赖库并读取数据
```
import pandas as pd
import numpy as np

# 读取数据集
df = pd.read_csv('balance-scale.data',
                 names=['balance', 'var1', 'var2', 'var3', 'var4'])

# 显示示例观测样本
df.head()
```

![Balance Scale Dataset](https://elitedatascience.com/wp-content/uploads/2017/06/balance-scale-dataset-head.png)

基于两臂的重量和距离，该数据集包含了天平是否平衡的信息。

- 其中包含 1 个我们标记的目标变量
      balance .
- 其中包含 4 个我们标记的输入特征
      var1  到
      var4 .

![Image Scale Data](https://elitedatascience.com/wp-content/uploads/2017/06/balance-scale-data.png)

目标变量有三个类别。

- **R** 表示右边重,，当
      var3*var4>var1*var2
- **L** 表示左边重，当
      var3*var4<var1*var2
- **B** 表示平衡，当
      var3*var4=var1*var2

每个类别的数量

```
df['balance'].value_counts()
# R    288
# L    288
# B     49
# Name: balance, dtype: int64
```

然而，对于本教程， 我们将把本问题转化为 **二值分类** 问题。

我们将把天平平衡时的每个观测样本标记为 **1** (正向类别)，否则标记为 **0** (负向类别)：

转变成二值分类

```
# 转换为二值分类
df['balance'] = [1 if b=='B' else 0 for b in df.balance]

df['balance'].value_counts()
# 0    576
# 1     49
# Name: balance, dtype: int64
# About 8% were balanced
```

正如你所看到的，只有大约 8% 的观察样本是平衡的。 因此，如果我们的预测结果总为 **0**，我们就会得到 92% 的准确率。

## 不平衡类别的风险

现在我们有一个数据集，我们可以真正地展示不平衡类别的风险。

首先，让我们从 [Scikit-Learn](http://scikit-learn.org/stable/) 导入逻辑回归算法和准确度度量模块。

导入算法和准确度度量模块

```
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
```

接着，我们将会使用默认设置来生成一个简单的模型。

在不平衡数据上训练一个模型

```
# 分离输入特征 (X) 和目标变量 (y)
y = df.balance
X = df.drop('balance', axis=1)

# 训练模型
clf_0 = LogisticRegression().fit(X, y)

# 在训练集上预测
pred_y_0 = clf_0.predict(X)
```

如上所述，许多机器学习算法被设计为在默认情况下最大化总体准确率。

我们可以证实这一点：

```
# 准确率是怎样的?
print( accuracy_score(pred_y_0, y) )
# 0.9216
```

因此我们的模型拥有 92% 的总体准确率，但是这是因为它只预测了一个类别吗？

```
# 我们应该兴奋吗?
print( np.unique( pred_y_0 ) )
# [0]
```

正如你所看到的，这个模型仅能预测 **0**，这就意味着它完全忽视了少数类别而偏爱多数类别。

接着，我们将会看到第一个处理不平衡类别的技术：上采样少数类别。

## 1. 上采样少数类别

上采样是从少数类别中随机复制观测样本以增强其信号的过程。

达到这个目的有几种试探法，但是最常见的方法是使用简单的放回抽样的方式重采样。

首先，我们将从 Scikit-Learn 中导入重采样模块：

重采样模块

```
from sklearn.utils import resample
```

接着，我们将会使用一个上采样过的少数类别创建一个新的 DataFrame。 下面是详细步骤：

1. 首先，我们将每个类别的观测样本分离到不同的 DataFrame 中。
2. 接着，我们将采用**放回抽样**的方式对少数类别重采样，让样本的数量与多数类别数量相当。
3. 最后，我们将上采样后的少数类别 DataFrame 与原始的多数类别 DataFrame 合并。

以下是代码：

上采样少数类别

```
#  分离多数和少数类别
df_majority = df[df.balance==0]
df_minority = df[df.balance==1]

# 上采样少数类别
df_minority_upsampled = resample(df_minority,
                                 replace=True,     # sample with replacement
                                 n_samples=576,    # to match majority class
                                 random_state=123) # reproducible results

# 合并多数类别同上采样过的少数类别
df_upsampled = pd.concat([df_majority, df_minority_upsampled])

# 显示新的类别数量
df_upsampled.balance.value_counts()
# 1    576
# 0    576
# Name: balance, dtype: int64
```

正如你所看到的，新生成的 DataFrame 比原来拥有更多的观测样本，现在两个类别的比率为 1:1。

让我们使用逻辑回归训练另一个模型，这次我们在平衡数据集上进行：

在上采样后的数据集上训练模型

```
# 分离输入特征 (X) 和目标变量 (y)
y = df_upsampled.balance
X = df_upsampled.drop('balance', axis=1)

# 训练模型
clf_1 = LogisticRegression().fit(X, y)

# 在训练集上预测
pred_y_1 = clf_1.predict(X)

# 我们的模型仍旧预测仅仅一个类别吗？
print( np.unique( pred_y_1 ) )
# [0 1]

# 我们的准确率如何？
print( accuracy_score(y, pred_y_1) )
# 0.513888888889
```

非常好，现在这个模型不再只是预测一个类别了。虽然准确率急转直下，但现在的性能指标更有意义。

## 2. 下采样多数类别

下采样包括从多数类别中随机地移除观测样本，以防止它的信息主导学习算法。

其中最常见的试探法是不放回抽样式重采样。

这个过程同上采样极为相似。下面是详细步骤：

1. 首先，我们将每个类别的观测样本分离到不同的 DataFrame 中。
2. 接着，我们将采用**不放回抽样**来重采样多数类别，让样本的数量与少数类别数量相当。
3. 最后，我们将下采样后的多数类别 DataFrame 与原始的少数类别 DataFrame 合并。

以下为代码：

下采样多数类别

```
# 分离多数类别和少数类别
df_majority = df[df.balance==0]
df_minority = df[df.balance==1]

# 下采样多数类别
df_majority_downsampled = resample(df_majority,
                                 replace=False,    # sample without replacement
                                 n_samples=49,     # to match minority class
                                 random_state=123) # reproducible results

# Combine minority class with downsampled majority class
df_downsampled = pd.concat([df_majority_downsampled, df_minority])

# Display new class counts
df_downsampled.balance.value_counts()
# 1    49
# 0    49
# Name: balance, dtype: int64
```

这次，新生成的 DataFrame 比原始数据拥有更少的观察样本，现在两个类别的比率为 1:1。

让我们再一次使用逻辑回归训练一个模型：

在下采样后的数据集上训练模型

```
# Separate input features (X) and target variable (y)
y = df_downsampled.balance
X = df_downsampled.drop('balance', axis=1)

# Train model
clf_2 = LogisticRegression().fit(X, y)

# Predict on training set
pred_y_2 = clf_2.predict(X)

# Is our model still predicting just one class?
print( np.unique( pred_y_2 ) )
# [0 1]

# How's our accuracy?
print( accuracy_score(y, pred_y_2) )
# 0.581632653061
```

模型不再仅预测一个类别，并且其准确率似乎有所提高。

我们还希望在一个未见过的测试数据集上验证模型时， 能看到更令人鼓舞的结果。

## 3. 改变你的性能指标

目前，我们已经看到通过重采样数据集来解决不平衡类别的问题的两种方法。接着，我们将考虑使用其他性能指标来评估模型。

阿尔伯特•爱因斯坦曾经说过，“如果你根据能不能爬树来判断一条鱼的能力，那你一生都会认为它是愚蠢的。”，这句话真正突出了选择正确评估指标的重要性。

对于分类的通用指标，我们推荐使用 **ROC 曲线下面积** (AUROC)。

- 本指南中我们不做详细介绍，但是你可以在[这里](https://stats.stackexchange.com/questions/132777/what-does-auc-stand-for-and-what-is-it)阅读更多关于它的信息。
- 直观地说，AUROC 表示从中类别中区别观测样本的可能性。
- 换句话说，如果你从每个类别中随机选择一个观察样本，它将被正确的“分类”的概率是多大？

我们可以从 Scikit-Learn 中导入这个指标：

ROC 曲线下面积

```
from sklearn.metrics import roc_auc_score
```

为了计算 AUROC，你将需要预测类别的概率，而非仅预测类别。你可以使用如下代码获取这些结果
      .predict_proba() ** ** function like so:

获取类别概率

```
# Predict class probabilities
prob_y_2 = clf_2.predict_proba(X)

# Keep only the positive class
prob_y_2 = [p[1] for p in prob_y_2]

prob_y_2[:5] # Example
# [0.45419197226479618,
#  0.48205962213283882,
#  0.46862327066392456,
#  0.47868378832689096,
#  0.58143856820159667]
```

那么在 AUROC 下 这个模型 (在下采样数据集上训练模型) 效果如何？

下采样后数据集上训练的模型的 AUROC
Python

```
print( roc_auc_score(y, prob_y_2) )
# 0.568096626406
```

不错... 这和在不平衡数据集上训练的原始模型相比，又如何呢？

不平衡数据集上训练的模型的 AUROC

```
prob_y_0 = clf_0.predict_proba(X)
prob_y_0 = [p[1] for p in prob_y_0]

print( roc_auc_score(y, prob_y_0) )
# 0.530718537415
```

记住，我们在不平衡数据集上训练的原始模型拥有 92% 的准确率，它远高于下采样数据集上训练的模型的 58% 准确率。

然而，后者模型的 AUROC 为 57%，它稍高于 AUROC  为 53% 原始模型的 (并非远高于)。

**注意：** 如果 AUROC 的值为 0.47，这仅仅意味着你需要翻转预测，因为 Scikit-Learn 误解释了正向类别。 AUROC 应该 >= 0.5。

## 4. 惩罚算法 (代价敏感学习)

接下来的策略是使用惩罚学习算法来增加对少数类别分类错误的代价。

对于这种技术，一个流行的算法是惩罚性-SVM：

支持向量机

```
from sklearn.svm import SVC
```

训练时，我们可以使用参数
      class_weight='balanced' 来减少由于少数类别样本比例不足造成的预测错误。

我们也可以包含参数
      probability=True  ，如果我们想启用 SVM 算法的概率估计。
让我们在原始的不平衡数据集上使用惩罚性的 SVM 训练模型：

SVM 在不平衡数据集上训练惩罚性-SVM

```
# 分离输入特征 (X) 和目标变量 (y)
y = df.balance
X = df.drop('balance', axis=1)

# 训练模型
clf_3 = SVC(kernel='linear',
            class_weight='balanced', # penalize
            probability=True)

clf_3.fit(X, y)

# 在训练集上预测
pred_y_3 = clf_3.predict(X)

# Is our model still predicting just one class?
print( np.unique( pred_y_3 ) )
# [0 1]

# How's our accuracy?
print( accuracy_score(y, pred_y_3) )
# 0.688

# What about AUROC?
prob_y_3 = clf_3.predict_proba(X)
prob_y_3 = [p[1] for p in prob_y_3]
print( roc_auc_score(y, prob_y_3) )
# 0.5305236678
```

再说，这里我们的目的只是为了说明这种技术。真正决定哪种策略最适合*这个问题*，你需要在保留测试集上评估模型。

## 5. 使用基于树的算法

最后一个策略我们将考虑使用基于树的算法。决策树通常在不平衡数据集上表现良好，因为它们的层级结构允许它们从两个类别去学习。

在现代应用机器学习中，树集合(随机森林、梯度提升树等) 几乎总是优于单一决策树，所以我们将跳过单一决策树直接使用树集合模型：

随机森林

```
from sklearn.ensemble import RandomForestClassifier
```

现在，让我们在原始的不平衡数据集上使用随机森林训练一个模型。

在不平衡数据集上训练随机森林

```
# 分离输入特征 (X) 和目标变量 (y)
y = df.balance
X = df.drop('balance', axis=1)

# 训练模型
clf_4 = RandomForestClassifier()
clf_4.fit(X, y)

# 在训练集上进行预测
pred_y_4 = clf_4.predict(X)

# 我们的模型仍然仅能预测一个类别吗?
print( np.unique( pred_y_4 ) )
# [0 1]

# 我们的准确率如何?
print( accuracy_score(y, pred_y_4) )
# 0.9744

# AUROC 怎么样?
prob_y_4 = clf_4.predict_proba(X)
prob_y_4 = [p[1] for p in prob_y_4]
print( roc_auc_score(y, prob_y_4) )
# 0.999078798186
```

哇! 97% 的准确率和接近 100% AUROC 是魔法吗？戏法？作弊？是真的吗？

嗯，树集合已经非常受欢迎，因为他们在许多现实世界的问题上表现的非常良好。我们当然全心全意地推荐他们。

**然而：**

虽然这些结果令人激动，但是模型*可能*导致过拟合，因此你在做出最终决策之前仍旧需要在未见过的测试集上评估模型。

**注意: 由于算法的随机性，你的结果可能略有不同。为了能够复现试验结果，你可以设置一个随机种子。**

## 顺便提一下

有些策略没有写入本教程：

#### 创建合成样本 (数据增强)

创建合成样本与上采样非常相似， 一些人将它们归为一类。例如， [SMOTE 算法](https://www.jair.org/media/953/live-953-2037-jair.pdf) 是一种从少数类别中重采样的方法，会轻微的引入噪声，来创建”新“样本。

你可以在 [imblearn 库](http://contrib.scikit-learn.org/imbalanced-learn/generated/imblearn.over_sampling.SMOTE.html) 中 找到 SMOTE 的一种实现

**注意：我们的读者之一，马可，提出了一个很好的观点：仅使用 SMOTE 而不适当的使用交叉验证所造成的风险。查看评论部分了解更多详情或阅读他的关于本主题的 [博客文章](http://www.marcoaltini.com/blog/dealing-with-imbalanced-data-undersampling-oversampling-and-proper-cross-validation) 。**

#### 组合少数类别

组合少数类别的目标变量可能适用于某些多类别问题。

例如，假如你希望预测信用卡欺诈行为。在你的数据集中，每种欺诈方式可能会分别标注，但你可能并不关心区分他们。你可以将它们组合到单一类别“欺诈”中并把此问题归为二值分类问题。

#### 重构欺诈检测

异常检测， 又称为离群点检测，是为了[检测异常点(或离群点)和小概率事件](https://en.wikipedia.org/wiki/Anomaly_detection)。不是创建一个分类模型，你会有一个正常观测样本的 ”轮廓“。如果一个新观测样本偏离 “正常轮廓” 太远，那么它就会被标注为一个异常点。

## 总结 & 下一步

在本指南中，我们介绍了 5 种处理不平衡类别的有效方法：

1. 上采样 少数类别
2. 下采样 多数类别
3. 改变你的性能指标
4. 惩罚算法 (代价敏感学习)
5. 使用基于树的算法

这些策略受[没有免费的午餐定理](http://elitedatascience.com/machine-learning-algorithms)支配，你应该尝试使用其中几种方法，并根据测试集的结果来决定你的问题的最佳解决方案。

如果你喜欢本指南，我们邀请你注册我们的 **[7天免费应用机器学习速成课](http://elitedatascience.com/)**。我们会分享在我们博客中找不到的课程，当我们发布类似本教程的新教程时我们会给你发送通知。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
