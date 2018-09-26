> * 原文地址：[Unsupervised Learning with Python](https://towardsdatascience.com/unsupervised-learning-with-python-173c51dc7f03)
> * 原文作者：[Vihar Kurama](https://towardsdatascience.com/@vihar.kurama?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unsupervised-learning-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unsupervised-learning-with-python.md)
> * 译者：[zhmhhu](https://github.com/zhmhhu)
> * 校对者：[jianboy](https://github.com/jianboy), [7Ethan](https://github.com/7Ethan)

# Python 中的无监督学习算法

无监督学习是一种用于在数据中查找模式的机器学习技术。提供给无监督算法的数据是没有标记的，这意味着只给出输入变量（X）而没有相应的输出变量。在无监督学习中，算法自己来发现数据中有趣的结构。

![](https://cdn-images-1.medium.com/max/800/1*c19D4-xJpW8EoP1d46jn8Q.jpeg)

> 人工智能研究主任 Yan Lecun 解释说，无监督学习 —— 在不明确告诉他们所做的一切是对还是错的情况下教机器自我学习 —— 是“真正的”人工智能的关键所在。

## 监督学习 Vs 无监督学习。

在监督学习中，系统试图从先前给出的示例中学习。（另一方面，在无监督学习中，系统会尝试直接从给定的示例中查找模式。）因此，如果数据集被标记则为监督问题，如果数据集未标记，则是无监督问题。

![](https://cdn-images-1.medium.com/max/800/1*AZMDyaifxGVdwTV-1BN7kA.png)

[src](http://beta.cambridgespark.com/courses/jpm/01-module.html)

上面的图像是监督学习的一个例子; 我们使用回归算法找到特征之间的最佳拟合线。在无监督学习中，输入的数据以特征为基础而被分隔成不同的群集，并且预测它所属的群集。

## 重要术语

**Feature**: 用于进行预测的输入变量。

**Predictions:** 输入示例时的模型输出。

**Example**: 一行数据集。一个 example 包含一个或多个特征以及可能的标签。

**Label:** 特征结果。

## 无监督学习数据准备

在本文中，我们使用鸢尾花（Iris）数据集进行第一次预测。数据集包含一组有 150 个记录的集合，拥有 5 个属性 —— 花瓣长度、花瓣宽度、萼片长度、萼片宽度和类别。Iris Setosa、Iris Virginica 和 Iris Versicolor 是这三个类别。在我们的无监督算法中，我们给出了鸢尾花的这四个特征并预测它属于哪个类别。

我们使用 Python 中的 sklearn 库来加载鸢尾花数据集，使用 matplotlib 库来实现数据可视化。以下是用于研究数据集的代码段。

```
# 引入模块
from sklearn import datasets
import matplotlib.pyplot as plt

# 加载数据集
iris_df = datasets.load_iris()

# 数据集上的可用方法
print(dir(iris_df))

# 特征
print(iris_df.feature_names)

# 目标
print(iris_df.target)

# 目标名称
print(iris_df.target_names)
label = {0: 'red', 1: 'blue', 2: 'green'}

# 数据集切片
x_axis = iris_df.data[:, 0]  # Sepal Length
y_axis = iris_df.data[:, 2]  # Sepal Width

# 绘制
plt.scatter(x_axis, y_axis, c=iris_df.target)
plt.show()
```

```
['DESCR', 'data', 'feature_names', 'target', 'target_names']
['sepal length (cm)', 'sepal width (cm)', 'petal length (cm)', 'petal width (cm)']

[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2]

['setosa' 'versicolor' 'virginica']
```

![](https://cdn-images-1.medium.com/max/800/1*W97xJQLjkOUqbYL5_3EZQQ.png)

紫色：Setosa，绿色：Versicolor，黄色：Virginica

## 聚类

在群集中，数据分为几组。简而言之，目的是将具有相似特征的群体分开并将其分配到对应的群集中。

可视化的例子，

![](https://cdn-images-1.medium.com/max/800/1*58tBPk4oZqhZ-LUq-0Huow.jpeg)

在上图中，左边的图像是未进行分类的原始数据，右边的图像是聚类的（数据根据其特征进行分类）。当给出要预测的输入时，它根据它的特征检查它所属的群集，并进行预测。

## Python 中的 K-均值 聚类算法

K 均值是一种迭代聚类算法，旨在在每次迭代中找到局部最大值。最初选择所需数量的群集。由于我们知道涉及 3 个类别，因此我们将算法编程为将数据分组为 3 个类别，方法是将参数 “n_clusters” 传递给我们的 K 均值模型。现在随机将三个点（输入）分配到三个群集中。基于每个点之间的质心距离，下一个给定的输入被分配到相应的群集。现在，重新计算所有群集的质心。

群集的每个质心都是一组特征值，用于定义结果组。检查质心特征权重可用于定性地解释每个群集代表什么类型的组。

我们从 sklearn 库导入 K 均值模型，拟合特征并预测。

**Python 中的 K 均值算法实现。**

```
# 引入模块
from sklearn import datasets
from sklearn.cluster import KMeans

# 加载数据集
iris_df = datasets.load_iris()

# 声明模型
model = KMeans(n_clusters=3)

# 拟合模型
model.fit(iris_df.data)

# 预测单个输入
predicted_label = model.predict([[7.2, 3.5, 0.8, 1.6]])

# 预测整个数据
all_predictions = model.predict(iris_df.data)

# 打印预测结果
print(predicted_label)
print(all_predictions)
```

```
[0]
[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 2 1 1 1 1 2 1 1 1 1 1 1 2 2 1 1 1 1 2 1 2 1 2 1 1 2 2 1 1 1 1 1 2 1 1 1 1 2 1 1 1 2 1 1 1 2 1 1 2]
```

### 分层聚类

顾名思义，分层聚类是一种构建聚类层次结构的算法。该算法从分配给自己的群集的所有数据开始。然后将两个最接近的群集合并到同一群集中。最后，当只剩下一个群集时，该算法结束。

可以使用树形图显示分层聚类的完成过程。现在让我们看一下谷物数据的层次聚类的例子。数据集可以在[这里](https://raw.githubusercontent.com/vihar/unsupervised-learning-with-python/master/seeds-less-rows.csv)找到。

**Python 中分层聚类算法的实现。**

```
# 引入模块
from scipy.cluster.hierarchy import linkage, dendrogram
import matplotlib.pyplot as plt
import pandas as pd

# 读入 DataFrame
seeds_df = pd.read_csv(
    "https://raw.githubusercontent.com/vihar/unsupervised-learning-with-python/master/seeds-less-rows.csv")

# 从 DataFrame 中删除谷物种类，稍后再保存
varieties = list(seeds_df.pop('grain_variety'))

# 将测量值提取为 NumPy 数组
samples = seeds_df.values

"""
使用带有 method ='complete' 关键字参数的
linkage() 函数对样本执行分层聚类。
将结果合并。
"""
mergings = linkage(samples, method='complete')

"""
在合并时使用 dendrogram() 函数绘制树形图，
指定关键字参数 labels = varieties，leaf_rotation = 90 
和 leaf_font_size = 6。
"""
dendrogram(mergings,
           labels=varieties,
           leaf_rotation=90,
           leaf_font_size=6,
           )

plt.show()
```

![](https://cdn-images-1.medium.com/max/800/1*CM2pEq3FmXeKQ-9XublYGQ.png)

## K 均值和分层聚类之间的差异

*   分层聚类不能很好地处理大数据，但 K 均值聚类可以。这是因为 K 均值的时间复杂度是线性的，即 O(n)，而分层聚类的时间复杂度是二次的，即 O(n2)。
*   在 K 均值聚类中，当我们从任意选择的聚类开始时，通过多次运行算法生成的结果可能会有所不同。然而在分层聚类中结果是可重现的。
*   当群集的形状是超球形时（如 2D 中的圆圈，3D 中的球体），我们发现 K 均值工作良好。
*   K-均值不允许噪声数据，而在分层聚类中我们可以直接使用噪声数据集进行聚类。

### t-SNE 聚类

它是可视化的无监督学习方法之一。t-SNE 代表 **t 分布的随机嵌入邻域**。它将高维空间映射到可以可视化的 2 维或 3 维空间。具体地，它通过二维或三维点对每个高维对象建模，使得相似对象由附近点建模，而非相似对象由远点以高概率建模。

**用于鸢尾花数据集的 Python 中的 t-SNE 聚类实现。**

```
# 引入模块
from sklearn import datasets
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt

# 加载数据集
iris_df = datasets.load_iris()

# 定义模型
model = TSNE(learning_rate=100)

# 拟合模型
transformed = model.fit_transform(iris_df.data)

# 绘制二维的 t-Sne
x_axis = transformed[:, 0]
y_axis = transformed[:, 1]

plt.scatter(x_axis, y_axis, c=iris_df.target)
plt.show()
```

![](https://cdn-images-1.medium.com/max/800/1*zFroZYrm97bnZxfv4nl-2Q.png)

紫色：Setosa，绿色：Versicolor，黄色：Virginica

这里，由于鸢尾花数据集具有四个特征（4d），因此它被转换并以二维图形表示。类似地，t-SNE 模型可以应用于具有 n 个特征的数据集。

### DBSCAN 聚类

DBSCAN（具有噪声的基于密度的聚类方法）是一种流行的聚类算法，用于替代预测分析中的 K 均值。它不需要输入群集的数量就能运行。但是，你必须调整另外两个参数。

scikit-learn 实现提供了 eps 和 min_samples 参数的默认值，但是你通常需要调整这些参数。eps 参数是要在同一邻域中考虑的两个数据点之间的最大距离。min_samples 参数是邻域中被视为群集的数据点的最小数量。

**Python 中的 DBSCAN 聚类**

```
# 引入模块
from sklearn.datasets import load_iris
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from sklearn.decomposition import PCA

# 加载数据集
iris = load_iris()

# 声明模型
dbscan = DBSCAN()

# 拟合
dbscan.fit(iris.data)

# 使用PCA进行转换
pca = PCA(n_components=2).fit(iris.data)
pca_2d = pca.transform(iris.data)

# 基于类别进行绘制
for i in range(0, pca_2d.shape[0]):
    if dbscan.labels_[i] == 0:
        c1 = plt.scatter(pca_2d[i, 0], pca_2d[i, 1], c='r', marker='+')
    elif dbscan.labels_[i] == 1:
        c2 = plt.scatter(pca_2d[i, 0], pca_2d[i, 1], c='g', marker='o')
    elif dbscan.labels_[i] == -1:
        c3 = plt.scatter(pca_2d[i, 0], pca_2d[i, 1], c='b', marker='*')

plt.legend([c1, c2, c3], ['Cluster 1', 'Cluster 2', 'Noise'])
plt.title('DBSCAN finds 2 clusters and Noise')
plt.show()
```

![](https://cdn-images-1.medium.com/max/800/1*mEW-43TlDuSS3dwbhxlxRg.png)

## 更多无监督技术：

*   主成分分析（[PCA](https://towardsdatascience.com/pca-using-python-scikit-learn-e653f8989e60)）
*   异常检测
*   自动编码
*   深度信念网络
*   赫布型学习
*   生成式对抗网络(GANs)
*   自组织映射

* * *

**重要链接：**

**Python 中的监督学习算法。**

* [**用 Python 进行监督学习**：为什么是人工智能和机器学习](https://towardsdatascience.com/supervised-learning-with-python-cf2c1ae543c1)
* [**机器学习简介**：机器学习是一个从实例和经验中进行学习的思想，它没有明确编程方法。](https://towardsdatascience.com/introduction-to-machine-learning-db7c668822c4)
* [**使用 Python 进行深度学习**：模仿人类的大脑。](https://towardsdatascience.com/deep-learning-with-python-703e26853820)
* [**用于深度学习的线性代数**：每个深度学习程序背后的数学。](https://towardsdatascience.com/linear-algebra-for-deep-learning-506c19c0d6fa)

### 后记

感谢阅读。如果你发现这篇文章有用，请点击下面的 ❤️ 来传递爱吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
