> * 原文地址：[Linear Algebra for Deep Learning](https://towardsdatascience.com/linear-algebra-for-deep-learning-506c19c0d6fa)
> * 原文作者：[Vihar Kurama](https://towardsdatascience.com/@vihar.kurama?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-for-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-for-deep-learning.md)
> * 译者：
> * 校对者：

# 深度学习中所需的线性代数知识

每个深度学习项目背后的数学知识。

**深度学习**是机器学习的一个子领域,涉及一些模仿人脑结构和功能的人工神经网络算法。

**线性代数**是一种连续的而非离散的数学形式,许多计算机科学家对它几乎没有经验。对于理解和使用许多机器学习算法，特别是深度学习算法，理解线性代数是非常重要的。

![](https://cdn-images-1.medium.com/max/1000/1*oOS8U37MHmJ7Vl8nqnepiA.jpeg)

### 为什么是数学?

线性代数，概率率和微积分是组成机器学习的三种“语言”。学习这些数学知识将有助于深入理解底层算法机制，并且开发新的算法。

当我们深入到底层时，深度学习背后的一切都是数学。因此在学习深度学习和编程之前，理解基本的线性代数知识是至关重要的。

![](https://cdn-images-1.medium.com/max/800/1*pUr-9ctuGamgjSwoW_KU-A.png)

[源码](https://hadrienj.github.io/posts/Deep-Learning-Book-Series-2.1-Scalars-Vectors-Matrices-and-Tensors/)

深度学习背后的核心数据结构是标量，矢量，矩阵和张量。让我们使用这些，通过编程的方式来解决所有基本的 线性代数问题。

### 标量

标量是**单个数字**，是 0 阶张量的例子。 符号 x ∈ ℝ 表示 x 是一个标量，属于一组实数值 ℝ 。

以下是深度学习中不同数集的表示。 ℕ 表示正整数集合 (1,2,3,…)。 ℤ 表示结合了正值，负值和零值的整数集合。 ℚ 表示有理数集合。

在 Python 中有一些内置的标量类型，**int**, **float**, **complex**, **bytes**, **Unicode** 。在 Numpy （一个 Python 库）中，有24种新的基本数据类型来描述不同类型的标量。有关数据类型的信息，请参阅文档 [这里](https://docs.scipy.org/doc/numpy-1.14.0/reference/arrays.scalars.html).

**在 Python 中定义标量和相关操作:**

下面的代码段解释了一些运算运算符在标量中的应用。

```
# 内置标量
a = 5
b = 7.5
print(type(a))
print(type(b))
print(a + b)
print(a - b)
print(a * b)
print(a / b)
```

```
<class 'int'>  
<class 'float'>  
12.5  
-2.5  
37.5  
0.6666666666666666
```

下面的代码段可以检查给出的变量是否为标量。

```
import numpy as np

# 判断是否为标量的函数
def isscalar(num):
    if isinstance(num, generic):
        return True
    else:
        return False

print(np.isscalar(3.1))
print(np.isscalar([3.1]))
print(np.isscalar(False))
```

```
True  
False  
True
```

### 向量

向量是单数的有序数组，是一阶张量的例子。量是被称为矢量空间的对象的片段。向量空间可以被认为是特定长度（或维度）的所有可能向量的整个集合。用 ℝ^3 表示的三维实值向量空间，通常用于从数学角度表示我们对三维空间的现实世界概念。

![](https://cdn-images-1.medium.com/max/800/1*fHS5crNOYBxDGASNPSp5lw.png)

为了明确地识别矢量的必要分量，矢量的第 i 个标量元素被写为 x[i] 。

在深度学习中，向量通常代表特征向量，其原始组成部分定义了具体特征的相关性。

**在 Python 中定义向量和相关操作:**

```
import numpy as np

# 定义向量

x = [1, 2, 3]
y = [4, 5, 6]

print(type(x))

# 向量不会相加
print(x + y)

# 使用 Numpy 进行向量相加

z = np.add(x, y)
print(z)
print(type(z))

# 向量交叉
mul = np.cross(x, y)
print(mul)
```

```
<class 'list'>
[1, 2, 3, 4, 5, 6]
[5 7 9]
<class 'numpy.ndarray'>
[-3  6 -3]
```

### 矩阵

矩阵是由数字组成的矩形阵列，是 2 阶张量的一个例子。如果 m 和 n 是正整数，即 m，n∈ℕ，则 m×n 矩阵包含 m * n 个数字，m 行 n 列。

完整的m×n矩阵可写为：

![](https://cdn-images-1.medium.com/max/800/1*x0q53AIuUG4i6U7BMjjUzg.png)

将全矩阵显示简写为以下表达式通常很有用：

![](https://cdn-images-1.medium.com/max/800/1*RGmyzL1tmF4so67kxYUF1g.png)

在Python中，我们使用 Numpy 库来帮助我们创建 N 维数组。数组基本上可看做矩阵，我们使用矩阵方法，并通过列表来构造一个矩阵。

$python

```
>>> import numpy as np
>>> x = np.matrix([[1,2],[2,3]])
>>> x
matrix([[1, 2],
        [2, 3]])

>>> a = x.mean(0)
>>> a
matrix([[1.5, 2.5]])
>>> # Finding the mean with 1 with the matrix x.
>>> z = x.mean(1)
>>> z
matrix([[ 1.5],
        [ 2.5]])
>>> z.shape
(2, 1)
>>> y = x - z
matrix([[-0.5,  0.5],
        [-0.5,  0.5]])
>>> print(type(z))
<class 'numpy.matrixlib.defmatrix.matrix'>
```

**在 Python 中定义矩阵和相关操作：**

#### 矩阵加法

矩阵可以与标量、向量和其他矩阵进行加法运算。每个操作都有精确的定义。这些技术经常用于机器学习和深度学习，所以值得熟悉它们。

```
# 矩阵加法

import numpy as np

x = np.matrix([[1, 2], [4, 3]])

sum = x.sum()
print(sum)
# Output: 10
```

#### 矩阵与矩阵相加

C = A + B (*A 与 B 的维度需要相同*)

方法的`shape`参数返回矩阵的维度，然后将两个参数相加并返回矩阵的和。如果矩阵的维度不同，该方法则会抛出一个异常，无法进行矩阵相加操作。

```
# 矩阵与矩阵相加

import numpy as np

x = np.matrix([[1, 2], [4, 3]])
y = np.matrix([[3, 4], [3, 10]])

print(x.shape)
# (2, 2)
print(y.shape)
# (2, 2)

m_sum = np.add(x, y)
print(m_sum)
print(m_sum.shape)
"""
Output : 
[[ 4  6]
 [ 7 13]]
(2, 2)
"""
```

#### 矩阵与标量相加

将给定的标量添加到给定矩阵中的所有元素。

```
# 矩阵与标量相加

import numpy as np

x = np.matrix([[1, 2], [4, 3]])
s_sum = x + 1
print(s_sum)
"""
Output:
[[2 3]
 [5 4]]
"""
```

#### 矩阵与标量的乘法

将给定的标量乘以给定矩阵中的所有元素。

```
# 矩阵与标量的乘法

import numpy as np

x = np.matrix([[1, 2], [4, 3]])
s_mul = x * 3
print(s_mul)
"""
[[ 3  6]
 [12  9]]
"""
```

#### 矩阵乘法

维度为(m x n)的矩阵 A 和维度为(n x p)的矩阵 B 相乘，最终得到维度为(m x p)的矩阵 C。

![](https://cdn-images-1.medium.com/max/800/1*96qrPHcvXBVM01I1lUKS8g.png)

[源码](https://hadrienj.github.io/posts/Deep-Learning-Book-Series-2.2-Multiplying-Matrices-and-Vectors/)

```
# 矩阵乘法

import numpy as np

a = [[1, 0], [0, 1]]
b = [1, 2]
np.matmul(a, b)
# Output: array([1, 2])

complex_mul = np.matmul([2j, 3j], [2j, 3j])
print(complex_mul)
# Output: (-13+0j)
```

#### 矩阵转置

通过转置，您可以将行向量转换为列向量，反之亦然：

A=[a_ij_]mxn

AT=[a_ji_]n×m

![](https://cdn-images-1.medium.com/max/800/1*VUByXk3gxhNuQVSTmcS2Gg.png)

```

# 矩阵转置

import numpy as np

a = np.array([[1, 2], [3, 4]])
print(a)
"""
[[1 2]
 [3 4]]
"""
a.transpose()
print(a)
"""
array([[1, 3],
       [2, 4]])
"""
```

### 张量

更具一般性的实体——张量，封装了标量、矢量和矩阵。在物理科学和机器学习中,有时需要使用超过两个顺序的张量。

![](https://cdn-images-1.medium.com/max/800/1*gyd_WcgWOPYncAsR6Z0IKQ.png)

[源码](https://refactored.ai/track/python-for-machine-learning/courses/linear-algebra.ipynb)

我们使用像 Tensorflow 或 PyTorch 这样的Python库来声明张量，而不是使用嵌套矩阵来表示。

**在 PyTorch 中定义一个简单的张量：**

```

import torch

a = torch.Tensor([26])

print(type(a))
# <class 'torch.FloatTensor'>

print(a.shape)
# torch.Size([1])

# 创建一个5*3的随机torch变量。
t = torch.Tensor(5, 3)
print(t)
"""
 0.0000e+00  0.0000e+00  0.0000e+00
 0.0000e+00  7.0065e-45  1.1614e-41
 0.0000e+00  2.2369e+08  0.0000e+00
 0.0000e+00  0.0000e+00  0.0000e+00
        nan         nan -1.4469e+35
[torch.FloatTensor of size 5x3]
"""
print(t.shape)
# torch.Size([5, 3])
```

**Python 中一些作用在张量中的运算符：**

```
import torch

# 创建张量

p = torch.Tensor(4,4)
q = torch.Tensor(4,4)
ones = torch.ones(4,4)

print(p, q, ones)
"""
Output:
 0.0000e+00  0.0000e+00  0.0000e+00  0.0000e+00
 1.6009e-19  4.4721e+21  6.2625e+22  4.7428e+30
 3.1921e-09  8.0221e+17  5.1019e-08  8.1121e+17
 8.1631e-07  8.2022e+17  1.1703e-19  1.5637e-01
[torch.FloatTensor of size 4x4]
 
 0.0000e+00  0.0000e+00  0.0000e+00  0.0000e+00
 1.8217e-44  1.1614e-41  0.0000e+00  2.2369e+08
 0.0000e+00  0.0000e+00  2.0376e-40  2.0376e-40
        nan         nan -5.3105e+37         nan
[torch.FloatTensor of size 4x4]
 
 1  1  1  1
 1  1  1  1
 1  1  1  1
 1  1  1  1
[torch.FloatTensor of size 4x4]
"""

print("Addition:{}".format(p + q))
print("Subtraction:{}".format(p - ones))
print("Multiplication:{}".format(p * ones))
print("Division:{}".format(q / ones))

"""
Addition:
 0.0000e+00  0.0000e+00  0.0000e+00  0.0000e+00
 1.6009e-19  4.4721e+21  6.2625e+22  4.7428e+30
 3.1921e-09  8.0221e+17  5.1019e-08  8.1121e+17
        nan         nan -5.3105e+37         nan
[torch.FloatTensor of size 4x4]
Subtraction:
-1.0000e+00 -1.0000e+00 -1.0000e+00 -1.0000e+00
-1.0000e+00  4.4721e+21  6.2625e+22  4.7428e+30
-1.0000e+00  8.0221e+17 -1.0000e+00  8.1121e+17
-1.0000e+00  8.2022e+17 -1.0000e+00 -8.4363e-01
[torch.FloatTensor of size 4x4]
Multiplication:
 0.0000e+00  0.0000e+00  0.0000e+00  0.0000e+00
 1.6009e-19  4.4721e+21  6.2625e+22  4.7428e+30
 3.1921e-09  8.0221e+17  5.1019e-08  8.1121e+17
 8.1631e-07  8.2022e+17  1.1703e-19  1.5637e-01
[torch.FloatTensor of size 4x4]
Division:
 0.0000e+00  0.0000e+00  0.0000e+00  0.0000e+00
 1.8217e-44  1.1614e-41  0.0000e+00  2.2369e+08
 0.0000e+00  0.0000e+00  2.0376e-40  2.0376e-40
        nan         nan -5.3105e+37         nan
[torch.FloatTensor of size 4x4]
"""
```

有关张量和PyTorch的更多文档 [点击这里](https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.html).

* * *

**重要的链接**

在Python中入门深度学习:

* [**Deep Learning with Python**: The human brain imitation.](https://towardsdatascience.com/deep-learning-with-python-703e26853820)
* [**Introduction To Machine Learning**: Machine Learning is an idea to learn from examples and experience, without being explicitly programmed. Instead of…](https://towardsdatascience.com/introduction-to-machine-learning-db7c668822c4)

### 结束语

感谢阅读。 如果你发现这个故事很有用, 请点击下面的 👏 来传播爱心.

特别鸣谢 [Samhita Alla](https://medium.com/@allasamhita) 对本文的贡献.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
