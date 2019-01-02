> * 原文地址：[PROGRAMMING Machine Learning for Diabetes with Python](https://datascienceplus.com/machine-learning-for-diabetes-with-python/)
> * 原文作者：[Susan Li](https://datascienceplus.com/author/susan-li/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/machine-learning-for-diabetes-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/machine-learning-for-diabetes-with-python.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[luochen1992](https://github.com/luochen1992)，[zhmhhu](https://github.com/zhmhhu)

# 用 Python 编程进行糖尿病相关的机器学习

根据 [Centers for Disease Control and Prevention](https://www.cdc.gov/)，现如今美国大约七分之一的成年人都患有糖尿病。而到了 2050 年，这个比率将会激增到三分之一之多。考虑到这一点，我们今天将要完成的就是：学习如何利用机器学习来帮助我们预测糖尿病。现在开始吧！

## 数据

糖尿病的数据集来自于 [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.php)，[这里](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/diabetes.csv) 可以下载。

```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline
diabetes = pd.read_csv('diabetes.csv')
print(diabetes.columns)
```

```
Index([‘Pregnancies’, ‘Glucose’, ‘BloodPressure’, ‘SkinThickness’, ‘Insulin’, ‘BMI’, ‘DiabetesPedigreeFunction’, ‘Age’, ‘Outcome’], dtype=’object’)
```

```
diabetes.head()
```

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_1.png)

糖尿病数据集包含 768 个数据点，每个数据点包含 9 个特征：

```
print("dimension of diabetes data: {}".format(diabetes.shape))

```

```
dimension of diabetes data: (768, 9)
```

“输出”就是我们将要预测的特征，0 表示非糖尿病，1 表示糖尿病。在这 768 个数据点中，500 个被标记为 0，268 个被标记为 1：

```
print(diabetes.groupby('Outcome').size())
```

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_2.png)

```
import seaborn as sns
sns.countplot(diabetes['Outcome'],label="Count")
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_3.png)

```
diabetes.info()
```

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_4.png)

## k 近邻

k 近邻算法可以说是最简单的机器学习算法。它建立仅包含训练数据集的模型。为了对一个新的数据点作出预测，算法将在训练数据集中找到最近的数据点 - 它的“最近邻点”。

首先，我们需要考察是否可以确认模型的复杂度和精度之间的联系：

```
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(diabetes.loc[:, diabetes.columns != 'Outcome'], diabetes['Outcome'], stratify=diabetes['Outcome'], random_state=66)
from sklearn.neighbors import KNeighborsClassifier
training_accuracy = []
test_accuracy = []
# 从 1 到 10 试验参数 n_neighbors
neighbors_settings = range(1, 11)
for n_neighbors in neighbors_settings:
    # 建立模型
    knn = KNeighborsClassifier(n_neighbors=n_neighbors)
    knn.fit(X_train, y_train)
    # 记录训练集精度
    training_accuracy.append(knn.score(X_train, y_train))
    # 记录测试集精度
    test_accuracy.append(knn.score(X_test, y_test))
plt.plot(neighbors_settings, training_accuracy, label="training accuracy")
plt.plot(neighbors_settings, test_accuracy, label="test accuracy")
plt.ylabel("Accuracy")
plt.xlabel("n_neighbors")
plt.legend()
plt.savefig('knn_compare_model')
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_5.png)

如上图所示，y 轴表示的训练和测试集精度和 x 轴表示的 n 近邻数呈反比。想象一下，如果我们只选择一个近邻，在训练集的预测是很完美的。但是当加入了更多的近邻的时候，训练精度将会下降，这表示仅选用一个近邻所得到的模型太过复杂。最佳实践是选择 9 个左右的近邻。

参考上图我们应该选择 n_neighbors=9。那么这里就是：

```
knn = KNeighborsClassifier(n_neighbors=9)
knn.fit(X_train, y_train)
print('Accuracy of K-NN classifier on training set: {:.2f}'.format(knn.score(X_train, y_train)))
print('Accuracy of K-NN classifier on test set: {:.2f}'.format(knn.score(X_test, y_test)))
```

```
Accuracy of K-NN classifier on training set: 0.79
Accuracy of K-NN classifier on test set: 0.78
```

## 逻辑回归

逻辑回归是最常用的分类算法之一。

```
from sklearn.linear_model import LogisticRegression
logreg = LogisticRegression().fit(X_train, y_train)
print("Training set score: {:.3f}".format(logreg.score(X_train, y_train)))
print("Test set score: {:.3f}".format(logreg.score(X_test, y_test)))
```

```
Training set accuracy: 0.781
Test set accuracy: 0.771
```

默认值 C=1 在训练集的精度是 78%，在测试集的精度是 77%。

```
logreg001 = LogisticRegression(C=0.01).fit(X_train, y_train)
print("Training set accuracy: {:.3f}".format(logreg001.score(X_train, y_train)))
print("Test set accuracy: {:.3f}".format(logreg001.score(X_test, y_test)))
```

```
Training set accuracy: 0.700
Test set accuracy: 0.703
```

使用 C=0.01 则导致在训练集和测试集的精度都有所下降。

```
logreg100 = LogisticRegression(C=100).fit(X_train, y_train)
print("Training set accuracy: {:.3f}".format(logreg100.score(X_train, y_train)))
print("Test set accuracy: {:.3f}".format(logreg100.score(X_test, y_test)))
```

```
Training set accuracy: 0.785
Test set accuracy: 0.766
```

使用 C=100 导致在训练集上的精度略有上升但是在测试集的精度下降，我们可以确定低正则和更复杂的模型也许并不能比默认设置表现更好。

因此我们应该采用默认值 C=1。

我们来将参数可视化，这些参数是通过学习对三个不同正则化参数 C 的数据集建立的模型所得到的。

正则化比较强（C=0.001）的集合得到的参数越来越靠近零。更仔细的看图，我们也能发现，对于 C=100，C=1 和 C=0.001，特征 “DiabetesPedigreeFunction” 系数都是正值。这意味着，不管我们看的是哪个模型，高 “DiabetesPedigreeFunction” 特征和糖尿病样本是相关联的。

```
diabetes_features = [x for i,x in enumerate(diabetes.columns) if i!=8]
plt.figure(figsize=(8,6))
plt.plot(logreg.coef_.T, 'o', label="C=1")
plt.plot(logreg100.coef_.T, '^', label="C=100")
plt.plot(logreg001.coef_.T, 'v', label="C=0.001")
plt.xticks(range(diabetes.shape[1]), diabetes_features, rotation=90)
plt.hlines(0, 0, diabetes.shape[1])
plt.ylim(-5, 5)
plt.xlabel("Feature")
plt.ylabel("Coefficient magnitude")
plt.legend()
plt.savefig('log_coef')
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_6.png)

## 决策树

```
from sklearn.tree import DecisionTreeClassifier
tree = DecisionTreeClassifier(random_state=0)
tree.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(tree.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(tree.score(X_test, y_test)))
```

```
Accuracy on training set: 1.000
Accuracy on test set: 0.714
```

在训练集的精度是 100%，但是测试集的精度就差了很多。这意味着树过拟合了，所以对新数据的泛化能力很弱。因此，我们需要对树进行剪枝。

我们设置最大深度 max_depth=3，限制了树的深度能降低过拟合。这将会导致训练集上精度的下降，但是在测试集的结果将会改善。

```
tree = DecisionTreeClassifier(max_depth=3, random_state=0)
tree.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(tree.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(tree.score(X_test, y_test)))
```

```
Accuracy on training set: 0.773
Accuracy on test set: 0.740
```

## 决策树的特征权重

特征权重决定了每个特征对于一棵树最后决策的重要性。对每个特征它都是一个 0 到 1 之间的数，0 表示着“完全没用”而 1 表示“完美预测结果”。特征权重的总和一定是 1。

```
print("Feature importances:\n{}".format(tree.feature_importances_))
```

```
Feature importances: [ 0.04554275 0.6830362 0\. 0\. 0\. 0.27142106 0\. 0\. ]
```

然后我们将特征权重可视化：

```
def plot_feature_importances_diabetes(model):
    plt.figure(figsize=(8,6))
    n_features = 8
    plt.barh(range(n_features), model.feature_importances_, align='center')
    plt.yticks(np.arange(n_features), diabetes_features)
    plt.xlabel("Feature importance")
    plt.ylabel("Feature")
    plt.ylim(-1, n_features)
plot_feature_importances_diabetes(tree)
plt.savefig('feature_importance')
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_7.png)

特征 “Glucose”（葡萄糖）是目前位置权重最大的特征。

## 随机森林

让我们在糖尿病数据集上应用一个包含 100 棵树的随机森林：

```
from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier(n_estimators=100, random_state=0)
rf.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(rf.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(rf.score(X_test, y_test)))
```

```
Accuracy on training set: 1.000
Accuracy on test set: 0.786
```

没做任何调参的随机森林给出的精度为 78.6%，比逻辑回归或者单独的决策树都要好。但是，我们还是可以调整 max_features 的设置，看看结果能否更好。

```
rf1 = RandomForestClassifier(max_depth=3, n_estimators=100, random_state=0)
rf1.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(rf1.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(rf1.score(X_test, y_test)))
```

```
Accuracy on training set: 0.800
Accuracy on test set: 0.755
```

并没有，这意味着随机森林默认的参数就已经运作的很好了。

## 随机森林中的特征权重

```
plot_feature_importances_diabetes(rf)
```

得出下图：

![]=(https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_8.png)

和单一决策树相似，随机森林的 “Glucose” 特征权重也比较高，但是还选出了 “BMI” 作为所有特征中第二高的权重。生成随机森林时的随机性要求算法必须考虑众多可能的解答，结果就是随机森林比单一决策树能够更完整地捕捉到数据的特征。

## 梯度提升

```
from sklearn.ensemble import GradientBoostingClassifier
gb = GradientBoostingClassifier(random_state=0)
gb.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(gb.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(gb.score(X_test, y_test)))
```

```
Accuracy on training set: 0.917
Accuracy on test set: 0.792
```

模型有可能会过拟合。为了减弱过拟合，我们可以应用强度更大的剪枝操作来限制最大深度或者降低学习率：

```
gb1 = GradientBoostingClassifier(random_state=0, max_depth=1)
gb1.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(gb1.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(gb1.score(X_test, y_test)))
```

```
Accuracy on training set: 0.804
Accuracy on test set: 0.781
```

```
gb2 = GradientBoostingClassifier(random_state=0, learning_rate=0.01)
gb2.fit(X_train, y_train)
print("Accuracy on training set: {:.3f}".format(gb2.score(X_train, y_train)))
print("Accuracy on test set: {:.3f}".format(gb2.score(X_test, y_test)))
```

```
Accuracy on training set: 0.802
Accuracy on test set: 0.776
```

降低了模型的复杂度的这两个方法也都如期降低了训练集的精度。但是在这个例子中，这几个方法都没有提高测试集上的泛化能力。

我们可以将特征权重可视化来更深入的研究我们的模型，尽管我们对它并不是很满意：

```
plot_feature_importances_diabetes(gb1)
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_9.png)

我们可以看出，梯度提升的树的特征权重和随机森林的特征权重在某种程度上有些相似，在这个实例中，所有的特征都被赋予了权重。

## 支持向量机

```
from sklearn.svm import SVC
svc = SVC()
svc.fit(X_train, y_train)
print("Accuracy on training set: {:.2f}".format(svc.score(X_train, y_train)))
print("Accuracy on test set: {:.2f}".format(svc.score(X_test, y_test)))
```

```
Accuracy on training set: 1.00
Accuracy on test set: 0.65
```

这个模型很明显过拟合了，训练集上结果完美但是测试集上仅有 65% 的精度。

SVM（支持向量机）需要所有的特征做归一化处理。我们需要重新调整数据的比例，这样所有的特征都大致在同一个量纲：

```
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.fit_transform(X_test)
svc = SVC()
svc.fit(X_train_scaled, y_train)
print("Accuracy on training set: {:.2f}".format(svc.score(X_train_scaled, y_train)))
print("Accuracy on test set: {:.2f}".format(svc.score(X_test_scaled, y_test)))
```

```
Accuracy on training set: 0.77
Accuracy on test set: 0.77
```

数据归一化导致了巨大的不同！现在其实欠拟合了，训练集和测试集的表现相似但是距离 100% 的精度还有点远。此时，我们可以试着提高 C 或者 gamma 来生成一个更复杂的模型。

```
svc = SVC(C=1000)
svc.fit(X_train_scaled, y_train)
print("Accuracy on training set: {:.3f}".format(
    svc.score(X_train_scaled, y_train)))
print("Accuracy on test set: {:.3f}".format(svc.score(X_test_scaled, y_test)))
```

```
Accuracy on training set: 0.790
Accuracy on test set: 0.797
```

这里，提高 C 优化了模型，使得测试集上的精度变成了 79.7%。

## 深度学习

```
from sklearn.neural_network import MLPClassifier
mlp = MLPClassifier(random_state=42)
mlp.fit(X_train, y_train)
print("Accuracy on training set: {:.2f}".format(mlp.score(X_train, y_train)))
print("Accuracy on test set: {:.2f}".format(mlp.score(X_test, y_test)))
```

```
Accuracy on training set: 0.71
Accuracy on test set: 0.67
```

多层感知器（Multilayer perceptrons）的精度远不如其他模型的好，这可能是因为数据的量纲。深度学习算法同样希望所有输入特征归一化，并且最好均值为 0，方差为 1。我们必须重新调整数据，让它满足这些要求。

```
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.fit_transform(X_test)
mlp = MLPClassifier(random_state=0)
mlp.fit(X_train_scaled, y_train)
print("Accuracy on training set: {:.3f}".format(
    mlp.score(X_train_scaled, y_train)))
print("Accuracy on test set: {:.3f}".format(mlp.score(X_test_scaled, y_test)))
```

```
Accuracy on training set: 0.823
Accuracy on test set: 0.802
```

让我们提高迭代次数：

```
mlp = MLPClassifier(max_iter=1000, random_state=0)
mlp.fit(X_train_scaled, y_train)
print("Accuracy on training set: {:.3f}".format(
    mlp.score(X_train_scaled, y_train)))
print("Accuracy on test set: {:.3f}".format(mlp.score(X_test_scaled, y_test)))
```

```
Accuracy on training set: 0.877
Accuracy on test set: 0.755
```

提高迭代次数仅仅优化了模型在训练集的表现，测试集的表现并没有改变。

让我们提高 alpha 参数，并增强权重正则性：

```
mlp = MLPClassifier(max_iter=1000, alpha=1, random_state=0)
mlp.fit(X_train_scaled, y_train)
print("Accuracy on training set: {:.3f}".format(
    mlp.score(X_train_scaled, y_train)))
print("Accuracy on test set: {:.3f}".format(mlp.score(X_test_scaled, y_test)))
```

```
Accuracy on training set: 0.795
Accuracy on test set: 0.792
```

结果很好，但是我们没能够进一步提高测试集精度。

因此，目前为止最好的模型就是归一化后默认的深度学习模型。

最后，我们绘制学习糖尿病数据集的神经网络的第一层权重的热图。

```
plt.figure(figsize=(20, 5))
plt.imshow(mlp.coefs_[0], interpolation='none', cmap='viridis')
plt.yticks(range(8), diabetes_features)
plt.xlabel("Columns in weight matrix")
plt.ylabel("Input feature")
plt.colorbar()
```

得出下图：

![](https://datascienceplus.com/wp-content/uploads/2018/03/diabetes_10.png)

从热图上很难很快就看出，相比于其他特征哪些特征的权重比较低。

## 总结

为了分类和回归，我们试验了各种各样的机器学习模型，（知道了）它们的优点和缺点都是什么，以及如何控制每个模型的复杂度。我们发现对于很多算法，设置合适的参数对于模型的上佳表现至关重要。

我们应该知道了如何应用、调参，并分析上文中我们试验过的模型。现在轮到你了！试着在 [scikit-learn](https://datascienceplus.com/multi-class-text-classification-with-scikit-learn/) 的内置数据集或者其他你选择的任意数据集上应用这些算法中的任一一个。快乐的进行机器学习吧！

这篇博客上的源码可以在这里找到。关于上文内容，我很乐意收到你们的反馈和问题。

参考链接：[Introduction to Machine Learning with Python](http://shop.oreilly.com/product/0636920030515.do)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
