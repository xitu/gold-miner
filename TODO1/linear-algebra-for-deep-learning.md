> * 原文地址：[Linear Algebra for Deep Learning](https://towardsdatascience.com/linear-algebra-for-deep-learning-506c19c0d6fa)
> * 原文作者：[Vihar Kurama](https://towardsdatascience.com/@vihar.kurama?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-for-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO1/linear-algebra-for-deep-learning.md)
> * 译者：
> * 校对者：

# Linear Algebra for Deep Learning

The Math behind every deep learning program.

**Deep Learning** is a subdomain of machine learning, concerned with the algorithm which imitates the function and structure of the brain called the artificial neural network.

**Linear algebra** is a form of continuous rather than discrete mathematics, many computer scientists have little experience with it. A good understanding of linear algebra is essential for understanding and working with many machine learning algorithms, especially deep learning algorithms.

![](https://cdn-images-1.medium.com/max/1000/1*oOS8U37MHmJ7Vl8nqnepiA.jpeg)

### Why Math?

Linear algebra, probability and calculus are the ‘languages’ in which machine learning is formulated. Learning these topics will contribute a deeper understanding of the underlying algorithmic mechanics and allow development of new algorithms.

When confined to smaller levels, everything is math behind deep learning. So it is essential to understand basic linear algebra before getting started with deep learning and programming it.

![](https://cdn-images-1.medium.com/max/800/1*pUr-9ctuGamgjSwoW_KU-A.png)

[src](https://hadrienj.github.io/posts/Deep-Learning-Book-Series-2.1-Scalars-Vectors-Matrices-and-Tensors/)

The core data structures behind Deep-Learning are Scalars, Vectors, Matrices and Tensors. Programmatically, let’s solve all the basic linear algebra problems using these.

### Scalars

Scalars are **single numbers** and are an example of a 0_th_-order tensor. The notation x ∈ ℝ states that x is a scalar belonging to a set of real-values numbers, ℝ.

There are different sets of numbers of interest in deep learning. ℕ represents the set of positive integers (1,2,3,…). ℤ designates the integers, which combine positive, negative and zero values. ℚ represents the set of rational numbers that may be expressed as a fraction of two integers.

Few built-in scalar types are **int**, **float**, **complex**, **bytes**, **Unicode** in Python. In In NumPy a python library, there are 24 new fundamental data types to describe different types of scalars. For information regarding datatypes refer documentation [here](https://docs.scipy.org/doc/numpy-1.14.0/reference/arrays.scalars.html).

_Defining Scalars and Few Operations in Python:_

The following code snippet explains few arithmetic operations on Scalars.

```
# In-Built Scalars
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

The following code snippet checks if the given variable is scalar or not.

```
import numpy as np

# Is Scalar Function
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

### Vectors

Vectors are ordered arrays of single numbers and are an example of 1st-order tensor. Vectors are fragments of objects known as vector spaces. A vector space can be considered of as the entire collection of all possible vectors of a particular length (or dimension). The three-dimensional real-valued vector space, denoted by ℝ^3 is often used to represent our real-world notion of three-dimensional space mathematically.

![](https://cdn-images-1.medium.com/max/800/1*fHS5crNOYBxDGASNPSp5lw.png)

To identify the necessary component of a vector explicitly, the i_th_ scalar element of a vector is written as x[i].

In deep learning vectors usually represent feature vectors, with their original components defining how relevant a particular feature is. Such elements could include the related importance of the intensity of a set of pixels in a two-dimensional image or historical price values for a cross-section of financial instruments.

_Defining Vectors and Few Operations in Python:_

```
import numpy as np

# Declaring Vectors

x = [1, 2, 3]
y = [4, 5, 6]

print(type(x))

# This does'nt give the vector addition.
print(x + y)

# Vector addition using Numpy

z = np.add(x, y)
print(z)
print(type(z))

# Vector Cross Product
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

### Matrices

Matrices are rectangular arrays consisting of numbers and are an example of 2_nd_-order tensors. If m and n are positive integers, that is m, n ∈ ℕ then the m×n matrix contains m*n numbers, with m rows and n columns.

The full m×n matrix can be written as:

![](https://cdn-images-1.medium.com/max/800/1*x0q53AIuUG4i6U7BMjjUzg.png)

It is often useful to abbreviate the full matrix component display into the following expression:

![](https://cdn-images-1.medium.com/max/800/1*RGmyzL1tmF4so67kxYUF1g.png)

In Python, We use numpy library which helps us in creating ndimensional arrays. Which are basically matrices, we use matrix method and pass in the lists and thereby defining a matrix.

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

_Defining Matrices and Few Operations in Python:_

#### Matrix Addition

Matrices can be added to scalars, vectors and other matrices. Each of these operations has a precise definition. These techniques are used frequently in machine learning and deep learning so it is worth familiarising yourself with them.

```
# Matrix Addition

import numpy as np

x = np.matrix([[1, 2], [4, 3]])

sum = x.sum()
print(sum)
# Output: 10
```

#### Matrix-Matrix Addition

C = A + B (_Shape of A and B should be equal_)

The methods shape return the shape of the matrix, and add takes in two arguments and returns the sum of those matrices. If the shape of the matrices is not same it throws an error saying, addition not possible.

```
# Matrix-Matrix Addition

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

#### Matrix-Scalar Addition

Adds the given scalar to all the elements in the given matrix.

```
# Matrix-Scalar Addition

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

#### Matrix Scalar Multiplication

Multiplies the given scalar to all the elements in the given matrix.

```
# Matrix Scalar Multiplication

import numpy as np

x = np.matrix([[1, 2], [4, 3]])
s_mul = x * 3
print(s_mul)
"""
[[ 3  6]
 [12  9]]
"""
```

#### Matrix Multiplication

A of shape (m x n) and B of shape (n x p) multiplied gives C of shape (m x p)

![](https://cdn-images-1.medium.com/max/800/1*96qrPHcvXBVM01I1lUKS8g.png)

[src](https://hadrienj.github.io/posts/Deep-Learning-Book-Series-2.2-Multiplying-Matrices-and-Vectors/)

```
# Matrix Multiplication

import numpy as np

a = [[1, 0], [0, 1]]
b = [1, 2]
np.matmul(a, b)
# Output: array([1, 2])

complex_mul = np.matmul([2j, 3j], [2j, 3j])
print(complex_mul)
# Output: (-13+0j)
```

#### Matrix Transpose

With transposition you can convert a row vector to a column vector and vice versa:

A=[a_ij_]mxn

AT=[a_ji_]n×m

![](https://cdn-images-1.medium.com/max/800/1*VUByXk3gxhNuQVSTmcS2Gg.png)

```

# Matrix Transpose

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

### Tensors

The more general entity of a tensor encapsulates the scalar, vector and the matrix. It is sometimes necessary — both in the physical sciences and machine learning — to make use of tensors with order that exceeds two.

![](https://cdn-images-1.medium.com/max/800/1*gyd_WcgWOPYncAsR6Z0IKQ.png)

[src](https://refactored.ai/track/python-for-machine-learning/courses/linear-algebra.ipynb)

We use Python libraries like tensorflow or PyTorch in order to declare tensors, rather than nesting matrices.

_To define a simple tensor in PyTorch_

```

import torch

a = torch.Tensor([26])

print(type(a))
# <class 'torch.FloatTensor'>

print(a.shape)
# torch.Size([1])

# Creates a Random Torch Variable of size 5x3.
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

_Few Arithmetic Operations on Tensors in Python_

```
import torch

# Creating Tensors

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

For more documentation regarding tensors and PyTorch [click here](https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.html).

* * *

_Important Links_

To get started with deep learning in python:

* [**Deep Learning with Python**: The human brain imitation.](https://towardsdatascience.com/deep-learning-with-python-703e26853820)
* [**Introduction To Machine Learning**: Machine Learning is an idea to learn from examples and experience, without being explicitly programmed. Instead of…](https://towardsdatascience.com/introduction-to-machine-learning-db7c668822c4)

### Closing Notes

Thanks for reading. If you found this story helpful, please click the below 👏 to spread the love.

Special Thanks to [Samhita Alla](https://medium.com/@allasamhita) for her contributions towards the article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
