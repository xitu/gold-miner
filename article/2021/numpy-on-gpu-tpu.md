> * 原文地址：[Numpy on GPU/TPU](https://medium.com/ml-mastery/numpy-on-gpu-tpu-efb8d367020a)
> * 原文作者：[Sambasivarao. K](https://medium.com/@k.sambasivarao222)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/numpy-on-gpu-tpu.md](https://github.com/xitu/gold-miner/blob/master/article/2021/numpy-on-gpu-tpu.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[PingHGao](https://github.com/PingHGao), [Kimhooo](https://github.com/Kimhooo)

# Numpy 在 GPU/TPU 上的性能

![Image by [i2tutorials](https://www.i2tutorials.com/what-do-you-mean-by-tensor-and-explain-about-tensor-datatype-and-ranks/)](https://cdn-images-1.medium.com/max/2000/1*CPwuFuMnvGXARofgff1zbg.jpeg)

[Numpy](https://numpy.org/) 是迄今为止使用最广泛的数组运算函数库。它是许多机器学习和数据科学库的基础库。它包含大量的高阶数组运算函数。众所周知，Numpy 因其运算速度而非常受欢迎。Numpy 对数组对象的处理比 Python 自带的 List 库要快 50 倍。同时，Numpy 还支持矢量化，可以取代 Python 中的循环控制结构。

> Numpy 能否运行得更快？答案是肯定的。

Tensorflow 以 tf.experimental.numpy 形式引入了一系列 Numpy API 的功能，并在 2.4 版中发布。这使 Numpy 相关代码运行更快，如果运行于 GPU/TPU 则性能更佳。

## 基准

在深入研究之前，我们来比较 numpy 与 tensorflow-numpy 的性能。对于由一些小型运算操作构成的任务（少于 10 微秒），tensorflow 的任务调度系统在运行时花费了大部分时间，此时 NumPy 的性能更好。在其他方面，TensorFlow 的性能一般要好一些。

Tensorflow 创建了用于性能比较的测试程序。它们使用 numpy 和 tensorlfow-numpy 执行 sigmoid 函数，并分别在 CPU 和 GPU 上多次运行。该试验的结果如下：

![Image by [Tensorflow](https://www.tensorflow.org/guide/tf_numpy_files/output_p-fs_H1lkLfV_0.png)](https://cdn-images-1.medium.com/max/2000/1*ccZoyf2TfAonIFE-knrlZQ.png)

你可以看出，对于小型运算任务，numpy 的性能较好，对于较大的运算任务，则是 tf-numpy 更好。在 GPU 上运行时，性能比在 CPU 上运行要好。

## TensorFlow NumPy ND array

既然我们确信 tensorflow-numpy 的性能比 numpy 好，我们就深入研究一下 API：

NDArray 是 tf.experimental.numpy.ndarray 的一个实例，代表一个多维数组。它也包含一个不变的 tf.Tensor 对象，因此可以跟 tf.Tensor 互操作。它也实现了 __array__ 接口，可以将这些对象传递到需要 NumPy 或类似于数组的对象的环境中（例如 matplotlib）。互操作不进行数据的复制，甚至对位于加速器或远程设备上的数据也是如此。

> tf.Tensor 对象不需要进行数据复制，就能传递到 tf.experimental.numpy 相关的 API。 

![NumPy interoperability (Image Source:Author)](https://cdn-images-1.medium.com/max/2900/1*bOWnLqVQScm7rAPhDApFEw.png)

**运算符的优先级**：TensorFlow NumPy 定义了一个高于 NumPy 的 __array_priority__。这意味着涉及 ND Array 和 np.ndarray 的运算，前者优先，例如，输入的 np.ndarray 对象会转换为 ND Array, TensorFlow NumPy 对运算符的实现是有效的，运行程序时会调用相关代码。

![Operator precedence (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*k3g51Gl9O9JhKbUc9If5kA.png)

**类型**：ND Array 支持一系列 numpy 数据类型，类型提升相关操作遵循 numpy 语义。同时，广播和索引的相关使用也跟 Numpy 中的数组类似。

![Data type and promotions (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*W-KMZZz5M-1xMsZwburmBg.png)

**支持选择设备**：由于 ND Array 是包含于 tf.Tensor 的，GPU 和 TPU 都支持 ND Array。如下图所示，我们可以通过设置 tf.device 选择运行代码的设备。

![Device setup (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*chRzLgOvSVeYL3JKWNiIvA.png)

**Graph and eager modes**：Eager 模式执行类似于 Python 代码执行，所以它支持 NDArray，就像 numpy 一样，一步一步的执行。然而，同样的代码可以通过将其放入 tf.function 中以图形模式执行。下面是实现此目的的代码示例。

![tf.function usage (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*TLwyJSC1bxNa1domZLcj3Q.png)

## 使用限制

* 部分 dtype 不受支持。
* 不支持 Mutation 类型。ND Array 包含了不可变的 tf.Tensor。
* 不支持 Fortran 方式排序、展开以及分块操作。
* 不支持使用 NumPy C API、NumPy’s Cython、Swig integration。
* 仅支持部分函数和模块的使用。

这就是我们需要讨论的全部内容。我们研究了 tensorflow-numpy 和它的某些功能。tf-numpy 具有互操作性，因此在编写 tensorflow 和普通的 numpy 程序代码时都可以使用。你也可以在 GPU 上使用这个库运行复杂的 numpy 程序。

在下一篇文章中，我们将使用 tensorflow-numpy 从头开发一个神经网络，并在 GPU 上利用 tensorflow 自动微分机制训练它。我们还将研究 TensorFlow 相关加速技巧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
