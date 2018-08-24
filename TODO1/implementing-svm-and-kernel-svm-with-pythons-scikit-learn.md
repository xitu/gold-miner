> * 原文地址：[Implementing SVM and Kernel SVM with Python's Scikit-Learn](https://stackabuse.com/implementing-svm-and-kernel-svm-with-pythons-scikit-learn/)
> * 原文作者：[Usman Malik](https://twitter.com/usman_malikk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-svm-and-kernel-svm-with-pythons-scikit-learn.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-svm-and-kernel-svm-with-pythons-scikit-learn.md)
> * 译者：[rockyzhengwu](https://github.com/rockyzhengwu)
> * 校对者：[zhusimaji](https://github.com/zhusimaji), [TrWestdoor](https://github.com/TrWestdoor)

# 用 Scikit-Learn 实现 SVM 和 Kernel SVM

[支持向量机](https://en.wikipedia.org/wiki/Support_vector_machine)（SVM）是一种监督学习分类算法。支持向量机提出于 20 世纪 60 年代在 90 年代得到了进一步的发展。然而，由于能取得很好的效果，最近才开始变得特别受欢迎。与其他机器学习算法相比，SVM 有其独特之处。

本文先简明地介绍支持向量机背后的理论和如何使用 Python 中的 Scikit-Learn 库来实现。然后我们将学习高级 SVM 理论如 Kernel SVM，同样会使用 Scikit-Learn 来实践。

### 简单 SVM

考虑二维线性可分数据，如图 1，典型的机器学习算法希望找到使得分类错误最小的分类边界。如果你仔细看图 1，会发现能把数据点正确分类的边界不唯一。两条虚线和一条实线都能正确分类所有点。

![Multiple Decision Boundaries](https://s3.amazonaws.com/stackabuse/media/implementing-svm-kernel-svm-python-scikit-learn-1.jpg)

**图 1：多决策边界**

SVM 通过最大化所有类中的数据点到[决策边界](https://en.wikipedia.org/wiki/Decision_boundary)的最小距离的方法来确定边界，这是 SVM 和其他算法的主要区别。SVM 不只是找一个决策边界；它能找到最优决策边界。

能使所有类到决策边界的最小距离最大的边界是最优决策边界。如图 2 所示，那些离决策边界最近的点被称作支持向量。在支持向量机中决策边界被称作最大间隔分类器，或者最大间隔超平面。

![Decision Boundary with Support Vectors](https://s3.amazonaws.com/stackabuse/media/implementing-svm-kernel-svm-python-scikit-learn-2.jpg)

**图 2：决策边界的支持向量**

寻找支持向量、计算决策边界和支持向量之间的距离和最大化该距离涉及到很复杂的数学知识。本教程不打算深入到数学的细节，我们只会看到如何使用 Python 的 Scikit-Learn 库来实现 SVM 和 Kernel-SVM。

### 通过 Scikit-Learn 实现 SVM

我们将使用和[决策树教程](https://stackabuse.com/decision-trees-in-python-with-scikit-learn/)一样的数据。

我们的任务是通过四个属性来判断纸币是不是真的，四个属性是小波变换图像的偏度、图像的方差、图像的熵和图像的曲率。我们将使用 SVM 解决这个二分类问题。剩下部分是标准的机器学习流程。

#### 导入库

下面的代码导入所有需要的库

```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline
```

#### 导入数据

数据可以从下面的链接下载：

[https://drive.google.com/file/d/13nw-uRXPY8XIZQxKRNZ3yYlho-CYm_Qt/view](https://drive.google.com/file/d/13nw-uRXPY8XIZQxKRNZ3yYlho-CYm_Qt/view)

数据的详细信息可以参考下面的链接：

[https://archive.ics.uci.edu/ml/datasets/banknote+authentication](https://archive.ics.uci.edu/ml/datasets/banknote+authentication)

从 Google drive 链接下载数据并保存在你本地。这个例子中数据集保存在我 Windows 电脑的 D 盘 “Datasets” 文件夹下的 CSV 文件里。下面的代码从文件路径中读取数据。你可以根据文件在你自己电脑上的路径修改。

读取 CSV 文件的最简单方法是使用 pandas 库中的 `read_csv` 方法。下面的代码读取银行纸币数据记录到 pandas 的  dataframe:

```
bankdata = pd.read_csv("D:/Datasets/bill_authentication.csv")
```

#### 探索性数据分析

使用 Python 中各种各样的库几乎可以完成所有的数据分析。为了简单起见，我们只检查数据的维数并查看最前面的几条记录。查看数据的行数和列数，执行下面的语句：

```
bankdata.shape
```

你将看到输出为（1372, 5）。这意味着数据集有 1372 行和 5 列。

为了对数据长什么样有个直观感受，可以执行下面的命令：

```
bankdata.head()
```

输出下面如下:

![](https://i.loli.net/2018/08/15/5b73e22032c4a.jpg)

你可以发现所有的属性都是数值型。类别标签也是数值型即 0 和 1。

#### 数据预处理

数据预处理包括（1）把属性和类表标签分开和（2）划分训练数据集和测试数据集。

把属性和类别标签分开，执行下面的代码：

```
X = bankdata.drop('Class', axis=1)
y = bankdata['Class']
```

上面代码第一行从 `bankdata` dataframe 中移除了类别标签列 “Class” 并把结果赋值给变量 `X`。函数 `drop()` 删除指定列。

第二行，只将类别列存储在变量 `y` 里。现在变量 `X` 包含所有的属性变量 `y` 包含对应的类别标签。

现在数据集已经将属性和类别标签分开，最后一步预处理是划分出训练集和测试集。幸运的是 Scikit-Learn 中 `model_selection` 模块提供了函数 `train_test_split` 允许我们优雅地把数据分成训练和测试两部分。

执行下面的代码完成划分：

```
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20)
```

#### 算法训练

我们已经把数据分成了训练集和测试集。现在我们使用训练集来训练。Scikit-Learn 库中的 `svm` 模块实现了各种不同的 SVM 算法。由于我们要完成一个分类任务，我们将使用由 Scikit-Learn 中 `svm` 模块下的 `SVC` 类实现的支持向量分类器。这个类需要一个参数指定核函数的类型。这参数很重要。这里考虑最简单的 SVM 把类型参数设为 `linear` 线性支持向量机只适用于线性可分数据。我们在下一部分介绍非线性核。

把训练数据传给 SVC 类 `fit` 方法来训练算法。执行下面的代码完成算法训练：

```
from sklearn.svm import SVC
svclassifier = SVC(kernel='linear')
svclassifier.fit(X_train, y_train)
```

#### 做预测

`SVC` 类的 `predict` 方法可以用来预测新的数据的类别。代码如下：

```
y_pred = svclassifier.predict(X_test)
```

#### 算法评价

混淆矩阵、精度、召回率和 F1 是分类任务最常用的一些评价指标。Scikit-Learn 的 `metrics` 模块中提供了 `classification_report` 和`confusion_matrix` 等方法，这些方法可以快速的计算这些评价指标。

下面是计算评价指标的代码：

```
from sklearn.metrics import classification_report, confusion_matrix
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
```

#### 结果

下面是评价结果：

```
[[152    0]
 [  1  122]]
              precision   recall   f1-score   support

           0       0.99     1.00       1.00       152
           1       1.00     0.99       1.00       123

avg / total        1.00     1.00       1.00       275
```

从上面的评价结果中我们可以发现 SVM 比决策树稍微的要好。SVM 只有 1% 的错分类而决策树有 4%。

### Kernel SVM

在上面的章节我们看到了如何使用简单 SVM 算法在线性可分数据上找到决策边界。然而，当数据不是线性可分的时候如图 3，直线就不能再作为决策边界了。

![Non-linearly Separable Data](https://s3.amazonaws.com/stackabuse/media/implementing-svm-kernel-svm-python-scikit-learn-3.jpg)

Fig 3: 非线性可分数据

对非线性可分的数据集，简单的 SVM 算法就不再适用。一种改进的 SVM 叫做 Kernel SVM 可以用来解决非线性可分数据的分类问题。

从根本上说，kernel SVM 把在低维空间中线性不可分数据映射成在高维空间中线性可分的数据, 这样不同类别的数据点就分布在了不同的维度上。同样，这里涉及到复杂的数学，但是如果你只是使用 SVM 完全不用担心。我们可以很简单的使用 Python 的 Scikit-Learn 库来实现和使用 kernel SVM。

### 使用 Scikit-Learn 实现 Kernel SVM

和实现简单的 SVM 一样。在这部分我们使用有名的[鸢尾花数据集](https://en.wikipedia.org/wiki/Iris_flower_data_set)，依照植物下面的四个属性去预测它属于哪个分类：萼片宽度，萼片长度，花瓣宽度和花瓣长度。

数据可以从下面的链接下：

[https://archive.ics.uci.edu/ml/datasets/iris4](https://archive.ics.uci.edu/ml/datasets/iris4)

剩下的步骤就是典型的机器学习步骤在训练 Kernel SVM 之前我们需要一些简单说明。

#### 导入库

```
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
```

#### 导入数据

```
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"

# Assign colum names to the dataset
colnames = ['sepal-length', 'sepal-width', 'petal-length', 'petal-width', 'Class']

# Read dataset to pandas dataframe
irisdata = pd.read_csv(url, names=colnames)
```

#### 预处理

```
X = irisdata.drop('Class', axis=1)
y = irisdata['Class']
```

#### 训练和测试集划分

```
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20)
```

#### 算法训练

同样使用 Scikit-Learn 的 `svm` 模块中的 `SVC` 类。区别在于类 `SVC` 的核函数类型参数的值不一样。在简单 SVM 中我们使用的核函数类型是 “linear”。然而，kernel SVM 你可以使用 高斯、多项式、sigmoid或者其他可计算的核。我们将实现多项式、高斯和 sigmoid 核并检验哪一个表现更好。

#### 1. 多项式核

在[多项式核](https://en.wikipedia.org/wiki/Polynomial_kernel)的情况下，你开需要传递一个叫`degree` 的参数给`SVC` 类。这个参数是多项式的次数。看下面的代码如何实现多项式核实现 kernel SVM：

```
from sklearn.svm import SVC
svclassifier = SVC(kernel='poly', degree=8)
svclassifier.fit(X_train, y_train)
```

#### 做预测

现在我们已经训练好了算法，下一步是在测试集上做预测。

运行下面的代码来实现：

```
y_pred = svclassifier.predict(X_test)
```

####  算法评价

通常机器学习算法的最后一步是评价多项式核。运行下面的代码。

```
from sklearn.metrics import classification_report, confusion_matrix
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
```

使用多项式核的 kernel SVM 的输出如下：

```
[[11  0  0]
 [ 0 12  1]
 [ 0  0  6]]
                 precision   recall   f1-score   support

    Iris-setosa       1.00     1.00       1.00        11
Iris-versicolor       1.00     0.92       0.96        13  
 Iris-virginica       0.86     1.00       0.92         6

    avg / total       0.97     0.97       0.97        30
```

现在让我们使用高斯和 sigmoid 核来重复上面的步骤。

#### 2. 高斯核

看一眼我们是如何使用高斯核实现 kernel SVM 的：

```
from sklearn.svm import SVC
svclassifier = SVC(kernel='rbf')
svclassifier.fit(X_train, y_train)
```

使用高斯核，你必须指定类 SVC 的核参数额值为 “rbf”。

#### 预测和评价

```
y_pred = svclassifier.predict(X_test)
```

```
from sklearn.metrics import classification_report, confusion_matrix
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
```

使用高斯核的输出：

```
[[11  0  0]
 [ 0 13  0]
 [ 0  0  6]]
                 precision   recall   f1-score   support

    Iris-setosa       1.00     1.00       1.00        11
Iris-versicolor       1.00     1.00       1.00        13  
 Iris-virginica       1.00     1.00       1.00         6

    avg / total       1.00     1.00       1.00        30
```

#### 3. Sigmoid 核

最后，让我们使用 sigmoid 核实现 Kernel SVM。看下面的代码：

```
from sklearn.svm import SVC
svclassifier = SVC(kernel='sigmoid')
svclassifier.fit(X_train, y_train)
```

使用 sigmoid 核需要指定 `SVC` 类的参数 `kernel` 的值为 “sigmoid”。

#### 预测和评价

```
y_pred = svclassifier.predict(X_test)
```

```
from sklearn.metrics import classification_report, confusion_matrix
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
```

使用 Sigmoid 核的输出如下：

```
[[ 0  0 11]
 [ 0  0 13]
 [ 0  0  6]]
                 precision   recall   f1-score   support

    Iris-setosa       0.00     0.00       0.00        11
Iris-versicolor       0.00     0.00       0.00        13  
 Iris-virginica       0.20     1.00       0.33         6

    avg / total       0.04     0.20       0.07        30
```

#### 对比核的表现

对比发现 sigmoid 核是最差的。因为 sigmoid 返回 0 和 1 两个值，sigmoid 核更适合二分类问题。而我们的例子中有三个类别。

高斯核与多项式核有差不多的表现。高斯核预测准确率 100% 多项式核也只有 1% 的误差。高斯核表现稍好。然而没有硬性的规则来评价哪种核函数在任何场景下都更好。只能通过在测试集上的测试结果来选择哪一个核在你的数据集上表现更好。

### 资源

是否想学习更多的 Scikit-Learn 和的机器学习算法相关知识？我推荐你查看更多的资料，如在线课程：

*   [Python for Data Science and Machine Learning Bootcamp](http://stackabu.se/python-data-science-machine-learning-bootcamp)
*   [Machine Learning A-Z: Hands-On Python & R In Data Science](http://stackabu.se/machine-learning-hands-on-python-data-science)
*   [Data Science in Python, Pandas, Scikit-learn, Numpy, Matplotlib](http://stackabu.se/data-science-python-pandas-sklearn-numpy)

### 总结

本文我们学习了基本的 SVM 和 kernel SVMs。还了解了 SVM 算法背后的直觉以及如何使用 Python 库 Scikit-Learn 来实现。我们也学习了使用不同类型的核来实现 SVM。我猜你已经想把这些算法应用到真实的数据上了比如 [kaggle.com](https://www.kaggle.com)。

最后我还是建议你去详细了解下 SVM 背后的数学。虽然如果只使用 SVM 算法并不需要了解那些数学，但要理解算法是如何找到决策边界的数学会很有帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
