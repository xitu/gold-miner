> * 原文地址：[Implementation of Convolutional Neural Network using Python and Keras](https://rubikscode.net/2018/03/05/implementation-of-convolutional-neural-network-using-python-and-keras/)
> * 原文作者：[rubikscode](https://rubikscode.net)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/implementation-of-convolutional-neural-network-using-python-and-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO/implementation-of-convolutional-neural-network-using-python-and-keras.md)
> * 译者：[JohnJiangLA](https://github.com/JohnJiangLA)
> * 校对者：[Gladysgong](https://github.com/Gladysgong) [Starrier](https://github.com/Starriers)

# 使用 Python 和 Keras 实现卷积神经网络

你有没有想过？Snapchat 是如何检测人脸的？自动驾驶汽车是怎么知道路在哪里？你猜的没错，他们是使用了卷积神经网络这种专门用于处理计算机视觉的神经网络。在[**前一篇文章**](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/)中，我们研究了它们是怎么工作的。我们讨论了这些神经网络的层及其功能。基本上，卷积神经网络的附加层会将图像处理成神经网络能够支持的标准格式。这样做的第一步是检测某些特征或属性，这些工作是由卷积层完成的。

这一层使用过滤器来检测低层次的特征（比如边缘和曲线）以及更高层次的特征（比如脸和手）。然后卷积神经网络使用附加层消除图像中的线性干扰，这些干扰会导致过分拟合。当线性干扰移除后，附加层会将图像下采样并将数据进行降维。最后，这些信息会被传递到一个神经网络中，在卷积神经网络中它叫全连接层。同样，本文的目标是如何实现这些层，因此关于这些附加层的更多细节以及如何工作和具体用途都可以在[**前一篇文章**](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/)中找到。

![](https://i.imgur.com/Tnkq3Tf.png)

在我们开始解决问题和开始码代码之前，请正确配置好你的环境。与[**本系列**](https://rubikscode.net/2018/02/19/artificial-neural-networks-series/)之前的所有文章一样，我会使用 Python 3.6。另外，我使用的是 Anaconda 和 Spyder，但是你也可以使用其他的 IDE。然后，最重要的是安装 Tensorflow 和 Keras。安装和使用 Tensorflow 的说明请查看[**此处**](https://rubikscode.net/2018/02/05/introduction-to-tensorflow-with-python-example/)，而安装和使用 Keras 的说明请查看[**此处**](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/)。

## MNIST 数据集

因此，在本文中，我们将训练我们的网络来识别图像中的数字。为此，我们将使用另一个著名的数据集 —— MNIST 数据集。在前身 [**NIST**](https://www.nist.gov/sites/default/files/documents/srd/nistsd19.pdf) 的基础上，这个数据集由一个包含 60,000 个样本的训练集和一个包含 10,000 个手写数字图像的测试集组成。所有数字都已大小归一化并居中了。图像的大小也是固定的，因此预处理图像数据已被最简化了。这也是这个数据集为何如此流行的原因。它被认为是卷积神经网络世界中的 “Hello World” 样例。

![](https://i.imgur.com/dMRUT6k.png)

###### MNIST 数据集样例

此外，使用卷积神经网络，我们可以得到与人类判断相差无几的结果。目前，这一纪录由 Parallel Computing Center（赫梅尔尼茨基，乌克兰）保持。他们只使用了由 5 个卷积神经网络组成的集合，并将错误率控制在 0.21%。很酷吧？

## 导入库和数据

与[**本系列**](https://rubikscode.net/2018/02/19/artificial-neural-networks-series/)前面的文章一样，我们首先导入所有必要的库。其中一些是我们熟悉的，但是其中一些需要进一步讲解。

正如你所见，我们将使用 numpy，这是我们在前面的示例中用于操作多维数组和矩阵的库。另外，也可以看到，我们会使用一些[**本系列**](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/)之前 Keras 库中用过的特性，也会使用一些新特性。比如创建模型和标准层（比如全连接层）会使用到 **Sequential** 和 **Dense**。 

此外，我们还会使用一些 **Keras** 中的新类。**Conv2D** 是用于创建卷积层的类。**MaxPooling2D** 则是用于创建池化层的类，而 **Flatten** 是用于降维的类。我们也使用 **Keras util** 中的 **to_categorical**。该类用于将向量（整形量）转化为二值类别矩阵，即它用于 [**one-hot 编码**](https://en.wikipedia.org/wiki/One-hot)。最后，注意我们将使用 **matplotlib** 来显示结果。

导入必要的库和类之后，我们需要处理数据。幸运的是，Keras 提供了 MNIST 数据集， 所以我们不需要下载它。如前所述，所有这些图像都已经进行了部分预处理。这意味着他们有相同的大小和数字位于合适的位置。因此，让我们导入这个数据集并为我们的模型准备数据：

如你所见，我们从 Keras 数据集中导入了 MNIST 数据集。然后，我们将数据加载到训练和测试矩阵中。在此基础上，利用形状属性得到图像的维数，并对输入数据进行重构，从而得到输入图像的一个通道。基本上，我们只使用这个图像的一个通道，而不是常规的三个通道（RGB）。这样做是为了简化实现的难度。然后对输入矩阵中的数据进行归一化处理。最后，我们使用 **to_categorical** 对输出矩阵进行编码。

## 模型创建

现在，数据已经准备好了，我们可以开始最有趣的环节了 —— 创建模型：

理所当然的，我们为此需要使用 **Sequential**，并首先使用 Conv2D 类添加卷积层。正如你所见的，这个类使用的参数很少，所以让我们一起来研究下。第一个参数是定要使用的过滤器个数，即要检测的特征个数。通常来说我们从 32 开始随后逐步增大这个数字。这正是我们在做的，在第一个卷积层中我们检测 32 个特征，第二层中 64 个，最后的第三层中 128 个。使用的过滤器大小则由下一个参数 —— **kernel_size** 来定义，我们已经选择了 3*3 的过滤器。

在激活函数中，我们使用整流器函数。这样，在每个卷积层中非线性程度都会自然增加。实现这一点的另一种方法是使用 **keras.layers.advanced_activations** 中的 **LeakyReLU**。它不像标准的整理器函数，不是将所有低于某一固定值的值压缩为零，而是有一个轻微的负斜率。如果你决定使用它，请注意必须使用 **Conv2D** 中的线性激活。下面就是这种方式的样例：

我们有点跑题了。讲回到 Conv2D 及其参数。另一个非常重要的参数是 **input_shape**。使用这个参数，定义输入图像的维数。如前所述，我们只使用一个通道，这是为什么我们的 **input_shape** 最终维度是 1。这是我们从输入图像中提取的维度。

此外，我们还在模型中添加了其它层。Dropout 层能帮助我们防止过分拟合，此后，我们使用 **MasPooling2D** 类添加池化层。显然，这一层使用的是 max-pool 算法，池化过滤器的大小则是 2*2。池化层之后是降维层，最后是全连接层。对于最后的全连接层，我们添加了两层的神经网络，对于这两层，我们使用了 **Dense** 类。最后，我们编译模型，并使用了 Adam 优化器。

如果你不明白其中的一些概念，你可以查看[**之前的文章**](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/)，其中解释了卷积层的原理机制。另外，如果你对于一些 Keras 的内容有疑惑，那么[**这篇文章**](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/)会帮助到你。

## 训练

很好，我们的数据预处理了，我们的模型也建好了。下面我们将他们合并到一起，并训练我们的模型。为了使我们正在使用的能够运转正常。我们传入输入矩阵并定义 **batch_size** 和 **epoch** 数。我们要做的另外一件事是定义 **validation_split**。这个参数用于定义将测试数据的哪个部分用作验证数据。

基本上，该模型将保留部分训练数据，但它使用这部分数据在每个循环结束时计算损失和其他模型矩阵。这与测试数据不同，因为我们在每个循环结束后都会使用它。

在我们的模型已经训练完成并准备好之后，我们使用 **evaluate** 方法并将测试集传入。这里我们能够得出这个卷积神经网络的准确率。

## 预测

我们可以做的另一件事是在测试数据集中收集对对神经网络的预测。这样，我们就可以将预测结果和实际结果进行比较。为此，我们将使用 **predict** 方法。使用这个方法我们还可以对单个输入进行预测。

## 结果

让我们使用这些我们刚刚收集到的预测来完成我们实现的最后一步。我们将显示预测的数字与实际的数字。我们还会显示我们预测的图像。基本上，我们将为我们的实现做很好的可视化展示。毕竟，我们在处理图像。

在这里，我们使用了 **pyplot** 来显示十幅图像，并给出了实际结果和我们的预测。当我们运行我们的实现时，如下图所示：

![](https://i.imgur.com/q70wn55.png)

我们运行了 20 轮并得到了 99.39% 的准确率。并不差，当然这还有提升空间。

## 结论

卷积神经网络是计算机视觉领域中一个非常有趣的分支，也是最有影响力的创新之一。本文中我们实现了这些神经网络中的一个简易版本并用它来检测 MNIST 数据集上的数字。

感谢阅读！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
