> * 原文地址：[TensorFlow in a Nutshell — Part One: Basics](https://medium.com/@camrongodbout/tensorflow-in-a-nutshell-part-one-basics-3f4403709c9d#.y95bdu5wy)
* 原文作者：[Camron Godbout](https://medium.com/@camrongodbout)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cdpath](https://github.com/cdpath)
* 校对者：[marcmoore (Mark)](https://github.com/marcmoore), [Graning (Gran)](https://github.com/Graning)

# 简明 TensorFlow 教程 —— 第一部分：基础知识




#### 快速上手世界上最流行的深度学习框架

TensorFlow 是谷歌开发的用于训练深度学习模型的框架。深度学习属于机器学习，使用多层神经网络。自 1943 年神经生理学家 Warren McCulloch 和数学家 Walter Pitts 发表关于神经元工作机制的论文以来，深度学习的观念开始流行。他俩还用电路搭建了简单的神经网络模型。

自那时起众多开发者参与进来。（不过）这些数学模型高度精确，要求极高的计算资源。随着近期 GPU 和 CPU 的计算能力的进步，深度学习开始爆发性流行起来。

TensorFlow 在发明之初就考虑到了处理能力的限制。自 2015 年 11 月 开源以来，TensorFlow 已经可以成功地运行在所有类型的计算机上，甚至包括智能手机。TensorFlow 可以快速生成经过训练的预测模型。在写作本文时，TensorFlow 是目前排名第一的深度学习框架。









![](https://cdn-images-1.medium.com/max/1600/1*PMimtWrXXOIYvIw7nUrp5w.jpeg)



作者 Francois Chollet @fchollet (twitter)



#### 基本计算图

TensorFlow 中一切的一切都是基于创建计算图。用过 Theano 的读者应该会对本节非常熟悉。不妨将计算图看成节点网络，每个节点都是一种操作，可以运行函数，包括简单的加减甚至复杂的多元方程。

每个操作也表示能返回零个或多个张量的操作符，返回的张量可以稍后在图中使用。下面是一些操作及其输出的例子:

``` python
import tensorflow as tf

tf.add(1, 2)
# 3

tf.sub(2, 1)
# 1

tf.mul(2, 2)
# 4

tf.div(2, 2)
# 1

tf.mod(4, 5)
# 4

tf.pow(3, 2)
# 9

# x < y
tf.less(1, 2)
# True 

# x <= y="" tf.less_equal(1,="" 1)="" #="" true="" tf.greater(1,="" 2)="" false="" tf.greater_equal(1,="" tf.logical_and(true,="" false)="" tf.logical_or(true,="" tf.logical_xor(true,="" true
```

每个操作都可以接受一个常量，数组，矩阵或者 n 维矩阵。n 维矩阵也叫做张量，二维张量等价于 m x m 矩阵。


``` python
import tensorflow as tf

# 新建 2X2 矩阵常量
tensor_1 = tf.constant([[1., 2.], [3.,4]])

tensor_2 = tf.constant([[5.,6.],[7.,8.]])

# 新建矩阵乘法操作
output_tensor = tf.matmul(tensor_1, tensor_2)

# 必须在会话 (Session) 中运行计算图
sess = tf.Session()

result = sess.run(output_tensor)
print(result)

sess.close()
```









![](https://cdn-images-1.medium.com/max/1600/1*mvhm5_r6LY-eHsin21RJTg.png)



计算图


上面的代码新建了两个常量张量，相乘，然后输出结果。这只是个简单的例子，用来示范如何创建图并运行会话 (session)。 操作符所需的所有输入都会自动求值，而且通常是并行计算。这里运行的会话实际上会执行图中的三个操作，结果就是创建两个常量然后进行矩阵乘法。

#### 图

上面创建的常量和操作都会自动加到 TensorFlow 图中。默认图在导入 TensorFlow 库时就实例化了。当然，不使用默认图新建一个也可以，这在需要在一个文件中创建多个互不依赖的模型时非常有用。

``` python
new_graph = tf.Graph()

with new_graph.as_default():
    new_g_const = tf.constant([1., 2.])
```

任何在 `with new_graph.as_default()` 之外使用的变量和操作都会加到默认图中，默认图就是加载库时新建的那个图。当然，也可以取得指向默认图的引用。

``` python
default_g = tf.get_default_graph()
```

大多数情况下默认图就够用了。

#### 会话

TensorFlow 中有两种会话 (Session) 对象

#### `tf.Session()`

它封装了执行运算和张量求值需要的环境。会话可以有自己的变量，队列和分配的订阅者。所以在用完之后记得使用 `close()`。会话有三个可选参数。

1.  target —— 要连接的执行引擎
2.  graph —— 要使用的图
3.  config —— ConfigProto 协议缓存，里面有会话的配置参数

只要运行 TensorFlow 计算中的「一步」，`tf.Session()` 就会被调用，所有执行图所需要的依赖都会被运行。

#### `tf.InteractiveSession()`

和 `tf.Session()` 完全一样，主要是为了方便 IPython 和 Jupyter Notebooks 使用，加些东西比较方便，而且使用 `Tensor.eval()` 和 `Operation.run()` 就不用每次要算个什么东西都得用 `Session.run()` 完整地跑一遍了。

``` python
sess = tf.InteractiveSession()
a = tf.constant(1)
b = tf.constant(2)
c = a + b
# 这里不用 sess.run(c)
c.eval()
```

使用 `InteractiveSession` 还可以不显式地传入会话 (Session) 对象。

#### 变量

变量在 TensorFlow 中由会话 (Session) 管理。因为张量和操作对象都是不可变的，所以生存期超过会话的变量非常有用。`tf.Variable()` 就可以新建变量。

``` python
tensorflow_var = tf.Variable(1, name="my_variable")
```

大多数时候你可能需要新建由 0，1 或者随机数组成的张量变量。

*   tf.zeros() — 由 0 组成的矩阵
*   tf.ones() — 由 1 组成的矩阵
*   tf.random_normal() — 由随机正态分布值组成的矩阵
*   tf.random_uniform() — 由随机均匀分布的数字组成的矩阵
*   tf.truncated_normal() — 和 tf.random_normal() 一样，但是所有数字都不超过两个标准差

这些函数接受一个初始化用的 shape 参数，用来定义矩阵的维度。比如：

``` python
# 正态分布的 4X4X4 三维矩阵，平均值 0， 标准差 1
normal = tf.truncated_normal([4, 4, 4], mean=0.0, stddev=1.0)
```

还可以把变量设成这种矩阵辅助函数：

``` python
normal_var = tf.Variable(tf.truncated_normal([4,4,4] , mean=0.0, stddev=1.0)
```

要初始化这些变量，必须使用 TensorFlow 的变量初始化函数，然后把初始化函数传给会话。这样的话如果运行多个会话，变量都是一样的。

``` python
init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init)
```

如果要完全改变变量的值可以使用 `Variable.assign()` ，必须在会话中使用。

``` python
initial_var = tf.Variable(1)

changed_var = initial_var.assign(initial_var + initial_var)

init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init)

sess.run(changed_var)
# 2

sess.run(changed_var)
# 4

sess.run(changed_var)
# 8

# .... and so on
```

有时需要在模型中添加一个计数器，这时就可以用 `Variable.assign_add()` ，它需要一个数量参数，这个参数就是说给变量加多少。 类似的，减法可以用 `Variable.assign_sub()`。

``` python
counter = tf.Variable(0)

sess.run(counter.assign_add(1))
# 1

sess.run(counter.assign_sub(1))
# -1
```

#### 作用域

TensorFlow 有作用域，可以控制模型的复杂性，便于将模型分解为独立的小组件。作用域非常简单，甚至可以用来在用 TensorBoard 的时候分解模型(本文第二部分有所介绍）。作用域甚至可以嵌套在其他作用域中。

```
with tf.name_scope("Scope1"):
    with tf.name_scope("Scope_nested"):
        nested_var = tf.mul(5, 5)
```

当然这里作用域看上去并不是特别强大，但是结合 TensorBoard 使用就会非常有用。

#### 小结

我展示了许多 TensorFlow 提供的基本组件。它们组合起来可以构建非常复杂的模型。TensorFlow 提供的远不止这些，如果需要在接下来的文章中了解其他特性，欢迎告诉我。





