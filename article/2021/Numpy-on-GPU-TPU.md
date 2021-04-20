> * 原文地址：[Numpy on GPU/TPU](https://medium.com/ml-mastery/numpy-on-gpu-tpu-efb8d367020a)
> * 原文作者：[Sambasivarao. K](https://medium.com/@k.sambasivarao222)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/numpy-on-gpu-tpu.md](https://github.com/xitu/gold-miner/blob/master/article/2021/numpy-on-gpu-tpu.md)
> * 译者：
> * 校对者：

# Numpy on GPU/TPU

![Image by [i2tutorials](https://www.i2tutorials.com/what-do-you-mean-by-tensor-and-explain-about-tensor-datatype-and-ranks/)](https://cdn-images-1.medium.com/max/2000/1*CPwuFuMnvGXARofgff1zbg.jpeg)

[Numpy](https://numpy.org/) is so far the most used library for performing mathematical operations on arrays. It has formed the base for many Machine learning and data science libraries. It has a large number of high level mathematical functions to operate on arrays. As we all know, Numpy gained its popularity because of its speed of operations. Numpy array objects work almost 50x faster than the python lists. Also numpy arrays supports vectorization which removes the loops in python.

> Can we run numpy operations even faster? The answer is Y**es!**

Tensorflow has implemented a subset of Numpy API and released it as part of 2.4 version, as tf.experimental.numpy. This allows running numpy code much faster and can further improve the performance by running on GPU/TPU.

## Benchmark

Before going into a more detailed view, let’s compare the performance of numpy and tensorflow-numpy. For workloads composed of small operations (less than about 10 microseconds), tensorflow dispatching operations can dominate the runtime and NumPy could provide better performance. For other cases, TensorFlow should generally provide better performance.

Tensorflow has created a sigmoid benchmark experiment for performance comparison. They implemented the sigmoid operation using numpy and tensorlfow-numpy and ran it multiple times on CPU and GPU. The results of this experiment are shown below:

![Image by [Tensorflow](https://www.tensorflow.org/guide/tf_numpy_files/output_p-fs_H1lkLfV_0.png)](https://cdn-images-1.medium.com/max/2000/1*ccZoyf2TfAonIFE-knrlZQ.png)

As you can see for small operations, numpy performs better and as the size increases, tf-numpy provides better performance. And the performance on GPU is way better than its CPU counterpart.

## TensorFlow NumPy ND array

Now that we are convinced that tensorflow-numpy performs better than numpy, let’s dive into the API.

ND array is an instance of tf.experimental.numpy.ndarray, represents a multidimensional dense array. This wraps an immutable tf.Tensor which makes it interoperable with tf.Tensor. Also, it implements __array__ interface which allows these objects to be passed into contexts that expect a NumPy or array-like object (e.g. matplotlib). Interoperation does not do data copies, even for data placed on accelerators or remote devices.

> tf.Tensor objects can be passed to tf.experimental.numpy APIs, without performing data copies.

![NumPy interoperability (Image Source:Author)](https://cdn-images-1.medium.com/max/2900/1*bOWnLqVQScm7rAPhDApFEw.png)

**Operator Precedence:** TensorFlow NumPy defines an __array_priority__ higher than NumPy’s. This means that for operators involving both ND array and np.ndarray, the former will take precedence, i.e., np.ndarray input will get converted to an ND array and the TensorFlow NumPy implementation of the operator will get invoked.

![Operator precedence (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*k3g51Gl9O9JhKbUc9If5kA.png)

**Types:** ND array supports a subset of numpy datatypes and type promotion follow numpy semantics. Also broadcasting and indexing works the same way as numpy arrays.

![Data type and promotions (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*W-KMZZz5M-1xMsZwburmBg.png)

**Device support:** ND array have GPU and TPU support on par with tf.Tensor as it wraps around tf.Tensor. We can control which device to use by using tf.device scopes as shown below.

![Device setup (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*chRzLgOvSVeYL3JKWNiIvA.png)

**Graph and eager modes:** Eager mode execution is similar to python code execution, so it supports ND array just like numpy by executing op-by-op. However the same code can be executed in graph mode by putting it inside tf.function. Below is the code example to do that.

![tf.function usage (Image Source: Author)](https://cdn-images-1.medium.com/max/2900/1*TLwyJSC1bxNa1domZLcj3Q.png)

## Limitations

* Not all dtypes are currently supported.
* Mutation is not supported. ND Array wraps immutable tf.Tensor.
* Fortran order, views, stride_tricks are not supported.
* NumPy C API is not supported. NumPy’s Cython and Swig integration are not supported.
* Only a subset of functions and modules are supported.

That’s all for now. We have explored tensorflow-numpy and its capabilities. tf-numpy’s interoperability makes it a good choice to use in both tensorflow codes and general numpy codes as well. Also you can use this library to run complex numpy codes on GPU.

In the next article, we will build a Neural Network from scratch using tensorflow-numpy and use auto-differentiation using tf.GradientTape to train the network on GPU. Also we will explore TensorFlow-related speed-up tricks, like compilation and auto-vectorization. Thank you!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
