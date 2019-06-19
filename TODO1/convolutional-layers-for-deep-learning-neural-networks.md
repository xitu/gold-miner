> * 原文地址：[A Gentle Introduction to Convolutional Layers for Deep Learning Neural Networks](https://machinelearningmastery.com/convolutional-layers-for-deep-learning-neural-networks/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/convolutional-layers-for-deep-learning-neural-networks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/convolutional-layers-for-deep-learning-neural-networks.md)
> * 译者：[QiaoN](https://github.com/QiaoN)
> * 校对者：[HearFishle](https://github.com/HearFishle), [shixi-li](https://github.com/shixi-li)

# 浅析深度学习神经网络的卷积层

卷积和卷积层是卷积神经网络中使用的主要构建模块。

卷积是将输入简单通过滤波器进行激活。重复对输入使用同一个滤波器得到的激活后的图称为特征图/特征映射（feature map），表示输入（比如一张图像）中检测到的特征的位置和强度。

卷积神经网络在特定的预测建模问题（如图像分类）的约束下，能创新的针对训练数据集并行自动学习大量滤波器。结果是可以在输入图像的任何位置检测到高度特定的特征。

在本教程中，你将了解卷积在卷积神经网络中是如何工作的。

完成本教程后，你将知道：

* 卷积神经网络使用滤波器从输入中得到特征映射，该特征映射汇总了输入中检测到的特征的存在。
* 滤波器可以手工设计，例如线条检测器，但卷积神经网络的创新是，训练期间在特定预测问题的背景下学习滤波器。
* 在卷积神经网络中如何计算一维和二维卷积层的特征映射。

让我们开始吧。

![浅析深度学习神经网络的卷积层](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/A-Gentle-Introduction-to-Convolutional-Layers-for-Deep-Learning-Neural-Networks.jpg)

浅析深度学习神经网络的卷积层
照片由 [mendhak](https://www.flickr.com/photos/mendhak/5059410544/) 拍摄，版权所有。

## 教程概述

本教程分为四个部分，分别为：

1. 卷积神经网络中的卷积
2. 计算机视觉中的卷积
3. 学习到的滤波器的能力
4. 卷积层的样例

## 卷积神经网络中的卷积

卷积神经网络，简称 CNN，是一种专门用于处理二维图像数据的神经网络模型，尽管其也可用于一维和三维数据。

卷积神经网络的核心是卷积层，这也是卷积神经网络命名的由来。该层执行的操作称为“**卷积**”。

在卷积神经网络的语境中，卷积是涵盖了一组权重与输入相乘的线性操作，很像传统的神经网络。由于该技术是为二维输入设计的，这个乘法会在输入数据阵列和二维权重阵列之间进行，称为滤波器或核。

滤波器小于输入数据，在滤波器大小的输入区块和滤波器之间应用的乘法被称作点积。[点积](https://en.wikipedia.org/wiki/Dot_product)是滤波器大小的输入区块和滤波器之间的对应元素相乘，然后求和产生的单一值。因为它产生单一值，所以该操作通常被称为“**标积**”。

我们故意使用小于输入的滤波器，因为它允许相同的滤波器（权重集）在输入的不同点处多次乘以输入阵列。具体而言，滤波器从左到右、从上到下，系统地应用于输入数据的每个重叠部分或滤波器大小的区块。

在图像上系统地应用相同的滤波器是一个强大的想法。如果滤波器设计为检测输入中的特定类型的特征，那么在整个输入图像上系统地应用该滤波器能有机会在图像中的任何位置发现该特征。这种能力通常被称为平移不变性，比如说，关注该特征是否存在，而不是在哪里存在。

> 如果我们更关心某个特征是否存在而不是存在的确切位置，那么本地平移不变性会是非常有用的属性。例如，当判定图像是否包含面部时，我们不需要知道眼睛的像素级准确位置，我们只需要知道面部左侧和右侧分别有一只眼睛。

—— 第 342 页，[深度学习](https://amzn.to/2Dl124s)，2016。

将滤波器与输入阵列相乘一次，可得到单一值。由于滤波器多次应用于输入阵列，因此结果是一个表示输入滤波后的二维阵列输出值，这个结果被称为“**特征映射**”。

特征映射创建后，我们可以通过非线性函数（例如 ReLU ）传递特征映射中的每个值，就像我们对全连接层的输出所做的那样。

![对二维输入创建特征映射的滤波器示例](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Example-of-a-Filter-Applied-to-a-Two-Dimensional-input-to-create-a-Feature-Map.png)

对二维输入创建特征映射的滤波器示例

如果你来自数字信号处理领域或相关的数学领域，你可能会将矩阵的卷积运算理解为不同的东西。尤其应用输入前先翻转滤波器（核）。理论上，在卷积神经网络中说的卷积实际上是“**互相关**”。然而在深度学习中，它被称为“**卷积**”操作。

> 很多机器学习库实现的互相关被称为卷积。

—— 第 333 页，[深度学习](https://amzn.to/2Dl124s)，2016。

总之，我们有一个**输入**，例如一个像素值图像，我们还有一个滤波器，它也是一组权重，滤波器系统地应用于输入数据从而创建出**特征映射**。

## 计算机视觉中的卷积

对卷积神经网络来说，用卷积处理图像数据的想法并不新颖或独特，它是计算机视觉中的常用技术。

历史上，滤波器是由计算机视觉专家手工设计的，然后将其应用于图像以产生特征映射或滤波后的输出，这在某种程度上使图像分析更容易。

例如，下面是一个手工 3×3 元素的滤波器，用于检测垂直线：

```
0.0, 1.0, 0.0

0.0, 1.0, 0.0

0.0, 1.0, 0.0
```

将此滤波器应用于图像将生成仅包含垂直线的特征映射。这是一个垂直线检测器。

你能从滤波器的权重值中看到这一点：中心垂直线上的任何像素值都将被正激活，其它侧的任何像素值将被负激活。在图像的像素值上系统地拖拽此滤波器只能突出显示垂直线像素。

我们还可以创建水平线检测器并将其应用于图像，例如：

```
0.0, 0.0, 0.0

1.0, 1.0, 1.0

0.0, 0.0, 0.0
```

综合两个滤波器的结果，比如综合两个特征映射，将会突出显示图像中的所有的线。

可以设计一套数十甚至数百个其它的小型滤波器来检测图像中的其它特征。

在神经网络中使用卷积运算的创新之处在于，滤波器的值是网络训练中需要学习到的权重。

网络将学习到从输入中提取的特征类型。具体而言，在随机梯度下降的训练中，网络定会学习从图像中提取特征，该特征最小化了网络被训练要解决的特定任务的损失，例如，提取将图像分类为狗或猫最有用的特征。

在这种情况下，你会看到这是一个很强大的想法。

## 学习到的滤波器的能力

学习针对机器学习任务的单个滤波器是一种强大的技术。

然而，卷积神经网络在实践中实现了更多。

### 多个滤波器

卷积神经网络不只学习单个滤波器。事实上，它们对给定输入并行学习多个特征。

例如，对于给定输入，卷积层通常并行地学习 32 到 512 个滤波器。

这样提供给模型 32 甚至 512 种不同的从输入中提取特征的方式，或者说“**学习看**”的许多不同方式，以及训练后“**看**”输入数据的许多不同方式。

这种多样性允许定制化，比如不仅是线条，还有特定训练数据中的特定线条。

### 多个通道

彩色图像具有多个通道，通常每个颜色通道有一个，例如红色，绿色和蓝色。

从数据的角度来看，这意味着作为输入的单个图像在模型上实际是三个图像。

滤波器必须始终具有与输入相同的通道数量，通常称为“**深度**”。如果输入图像有 3 个通道（深度为 3），则应用于该图像的滤波器也必须有 3 个通道（深度为3）.这种情况下，一个 3×3 滤波器实际上行、列和深度为 3x3x3 或 [3, 3, 3]。无论输入和滤波器的深度如何，都使用点积运算将滤波器应用于输入来产生单一值。

这意味着如果卷积层具有 32 个滤波器，则这 32 个滤波器对二维图像输入不仅是二维的，还是三维的，对于三个通道中的每一个都具有特定的滤波器权重。然而，每个滤波器都会生成一个特征映射,这意味着对于创建的32个特征映射，应用 32 个滤波器的卷积层的输出深度为 32。

### 多个层

卷积层不仅应用于输入数据如原始像素值，也可以应用于其他层的输出。

卷积层的堆叠允许输入的层次分解。

考虑直接对原始像素值进行操作的滤波器将学习提取低级特征，例如线条。

在第一线层的输出上操作的滤波器可能提取综合低级特征的特征，比如可表示形状的多条线的特征。

这个过程会一直持续到非常深的层，提取面部、动物、房屋等。

这些正是我们在实践中看到的。随着网络深度的增加，特征的抽取会越来越高阶。

## 卷积层的样例

深度学习库 Keras 提供了一系列卷积层。

通过看一些人为数据和手工滤波器的样例，我们可以更好地理解卷积运算。

在本节中，我们将同时研究一维卷积层和二维卷积层的例子，两者都具体化了卷积操作，也提供了使用 Keras 层的示范。

### 一维卷积层的样例

我们可以定义一个具有八个元素的一维输入，正中间两个凸起元素值为 1.0，其余元素值为 0.0。

```
[0, 0, 0, 1, 1, 0, 0, 0]
```

对于一维卷积层，Keras 的输入必须是三维的。

第一维指每个输入样本，在本例中我们只有一个样本。第二个维度指每个样本的长度，在本例中长度是 8。第三维指每个样本中的通道数，在本例中我们只有一个通道。

因此，输入阵列的 shape 为 [1, 8, 1]。

```
# define input data
data  =  asarray([0,  0,  0,  1,  1,  0,  0,  0])
data  =  data.reshape(1,  8,  1)
```

我们将定义一个模型，其输入样本的 shape 为 [8, 1]。

该模型将具有一个滤波器，shape 为 3，或者说三个元素宽。Keras 将滤波器的 shape 称为 **kernel_size**。

```
# create model
model  =  Sequential()
model.add(Conv1D(1,  3,  input_shape=(8,  1)))
```

默认情况下，卷积层中的滤波器使用随机权重进行初始化。在这个人为例子中，我们将手动设定单个滤波器的权重。我们将定义一个能够检测凸起的滤波器，这是一个由低输入值包围的高输入值，正如我们在输入示例中定义的那样。

我们将三元素滤波器定义如下：

```
[0, 1, 0]
```

卷积层还具有偏差输入值，该值也需要我们设置一个为 0 的权重。

因此，我们可以强制我们的一维卷积层的权重使用如下所示的手工滤波器：

```
# define a vertical line detector
weights = [asarray([[[0]],[[1]],[[0]]]), asarray([0.0])]
# store the weights in the model
model.set_weights(weights)
```

权重必须以行、列、通道的三维结构被设定，滤波器有一行、三列、和一个通道。

我们可以检索权重并确认它们被正确设置。

```
# confirm they were stored
print(model.get_weights())
```

最后，我们可将单个滤波器应用于输入数据。

我们可以通过在模型上调用 **predict()** 函数来实现这一点。这将直接返回特征映射：这是在输入序列中系统地应用滤波器的输出。

```
# apply filter to input data
yhat  =  model.predict(data)
print(yhat)
```

将所有这些结合在一起，完整的样例如下所列。

```
# example of calculation 1d convolutions
from numpy import asarray
from keras.models import Sequential
from keras.layers import Conv1D
# define input data
data = asarray([0, 0, 0, 1, 1, 0, 0, 0])
data = data.reshape(1, 8, 1)
# create model
model = Sequential()
model.add(Conv1D(1, 3, input_shape=(8, 1)))
# define a vertical line detector
weights = [asarray([[[0]],[[1]],[[0]]]), asarray([0.0])]
# store the weights in the model
model.set_weights(weights)
# confirm they were stored
print(model.get_weights())
# apply filter to input data
yhat = model.predict(data)
print(yhat)
```

运行该样例，首先打印网络的权重，这证实了我们的手工滤波器在模型中是按照我们的预期设置的。

接下来，滤波器应用到输入模式，计算并显示出特征映射。我们可以从特征映射的值中看到凸起被正确检测到。

```
[array([[[0.]],
       [[1.]],
       [[0.]]], dtype=float32), array([0.], dtype=float32)]

[[[0.]
  [0.]
  [1.]
  [1.]
  [0.]
  [0.]]]
```

让我们仔细看看发生了什么。

回想一下，输入是一个八元素向量，其值为：[0, 0, 0, 1, 1, 0, 0, 0]。

首先，通过计算点积（“.”运算符）将三元素滤波器 [0, 1, 0] 应用于输入的前三个输入 [0, 0, 0]，得到特征映射中的单个输出值 0。

回想一下，点积是对应元素相乘的总和，在这它是 (0 x 0) + (1 x 0) + (0 x 0) = 0。在 NumPy 中，这可以手动实现为：

```
from numpy import asarray
print(asarray([0, 1, 0]).dot(asarray([0, 0, 0])))
```

在我们的手动示例中，具体如下：

```
[0, 1, 0] . [0, 0, 0] = 0
```

然后滤波器沿着输入序列的一个元素移动，并重复该过程。具体而言，在索引 1，2 和 3 处对输入序列应用相同的滤波器，得到特征映射中的输出为 0。

```
[0, 1, 0] . [0, 0, 1] = 0
```

我们是系统的，所以再一次，滤波器沿着输入的另一个元素移动，并应用于索引 2、3 和 4 处的输入。这次在特征映射中输出值是 1。我们检测到该特征并相应的激活。

```
[0, 1, 0] . [0, 1, 1] = 1
```

重复该过程，直到我们计算出整个特征映射。

```
[0, 0, 1, 1, 0, 0]
```

请注意，特征映射有六个元素，而我们的输入有八个元素。这是滤波器应用于输入序列的手工结果。还有其它方法可以将滤波器应用于输入序列可得到不同 shape 的特征映射，例如填充，但我们不会在本文中讨论这些方法。

你可以想象，通过不同的输入，我们可以检测到具有不同强度的特征，且在滤波器中具有不同的权重，那么我们将检测到输入序列中的不同特征。

### 二维卷积层的样例

我们可以将上一节的凸起检测样例扩展为二维图像的垂直线检测器。

同样的，我们可以约束输入，在这里为一个具有单个通道（如灰度）的正方形 8×8 像素的输入图像，其中间有一个垂直线。

```
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
[0, 0, 0, 1, 1, 0, 0, 0]
```

Conv2D（二维卷积层）的输入必须是四维的。

第一个维度定义样本，在本例中只有一个样本。第二个维度定义行数，在本例中是 8。第三维定义列数，在本例中还是 8。最后定义通道数，本例中是 1。

因此，输入必须具有四维 shape [样本，列，行，通道]，在本例中是 [1, 8, 8, 1]。

```
# define input data
data = [[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0]]
data = asarray(data)
data = data.reshape(1, 8, 8, 1)
```

我们将用单个滤波器定义 Conv2D，就像我们在上一节对 Conv1D 样例所做的那样。

滤波器将是二维的，一个 shape 3×3 的正方形。该层将期望输入样本具有 shape [列，行，通道]，在本例中为 [8, 8, 1]。

```
# create model
model = Sequential()
model.add(Conv2D(1, (3,3), input_shape=(8, 8, 1)))
```

我们将定义一个垂直线检测器的滤波器来检测输入数据中的单个垂直线。

滤波器如下所示：

```
0, 1, 0
0, 1, 0
0, 1, 0
```

我们可以实现如下：

```
# define a vertical line detector
detector = [[[[0]],[[1]],[[0]]],
            [[[0]],[[1]],[[0]]],
            [[[0]],[[1]],[[0]]]]
weights = [asarray(detector), asarray([0.0])]
# store the weights in the model
model.set_weights(weights)
# confirm they were stored
print(model.get_weights())
```

最后，我们将滤波器应用于输入图像，将得到一个特征映射，表明对输入图像中垂直线的检测，如我们希望的那样。

```
# apply filter to input data
yhat = model.predict(data)
```

特征映射的输出 shape 将是四维的，[批，行，列，滤波器]。我们将执行单个批处理，并且我们有一个滤波器（一个滤波器和一个输入通道），因此输出 shape 为 [1, ?, ?, 1]。我们可以完美打印出单个特征映射的内容，如下所示：

```
for r in range(yhat.shape[1]):
	# print each column in the row
	print([yhat[0,r,c,0] for c in range(yhat.shape[2])])
```

将所有这些结合在一起，完整的样例如下所列。

```
# example of calculation 2d convolutions
from numpy import asarray
from keras.models import Sequential
from keras.layers import Conv2D
# define input data
data = [[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0],
		[0, 0, 0, 1, 1, 0, 0, 0]]
data = asarray(data)
data = data.reshape(1, 8, 8, 1)
# create model
model = Sequential()
model.add(Conv2D(1, (3,3), input_shape=(8, 8, 1)))
# define a vertical line detector
detector = [[[[0]],[[1]],[[0]]],
            [[[0]],[[1]],[[0]]],
            [[[0]],[[1]],[[0]]]]
weights = [asarray(detector), asarray([0.0])]
# store the weights in the model
model.set_weights(weights)
# confirm they were stored
print(model.get_weights())
# apply filter to input data
yhat = model.predict(data)
for r in range(yhat.shape[1]):
	# print each column in the row
	print([yhat[0,r,c,0] for c in range(yhat.shape[2])])
```

运行该样例，首先确认手工滤波器已在层权重中被正确定义。

接下来，打印计算出的特征映射。从数字的规模我们可以看到，滤波器确实在特征映射的中间检测到具有单个强激活的垂直线。

```
[array([[[[0.]],
        [[1.]],
        [[0.]]],
       [[[0.]],
        [[1.]],
        [[0.]]],
       [[[0.]],
        [[1.]],
        [[0.]]]], dtype=float32), array([0.], dtype=float32)]

[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
```

让我们仔细看看计算了什么。

首先，将滤波器应用于图像的左上角，或者说 3×3 元素的图像区块。理论上，图像区块是三维的，具有单个通道，滤波器具有相同的尺寸。在 NumPy 中我们不能使用 [dot()](https://docs.scipy.org/doc/numpy/reference/generated/numpy.dot.html)  函数实现它，我们必须使用 [tensordot()](https://docs.scipy.org/doc/numpy/reference/generated/numpy.tensordot.html) 函数代替，以便我们可以适当地对所有维度求和，例如：

```
from numpy import asarray
from numpy import tensordot
m1 = asarray([[0, 1, 0],
			  [0, 1, 0],
			  [0, 1, 0]])
m2 = asarray([[0, 0, 0],
			  [0, 0, 0],
			  [0, 0, 0]])
print(tensordot(m1, m2))
```

该计算得到单个输出值 0.0，也就是未检测到特征。这给了我们特征映射左上角的第一个元素。

手动如下所示：

```
0, 1, 0     0, 0, 0
0, 1, 0  .  0, 0, 0 = 0
0, 1, 0     0, 0, 0
```

滤波器沿着一列向左移动，并重复该过程。同样的，未检测到该特征。

```
0, 1, 0     0, 0, 1
0, 1, 0  .  0, 0, 1 = 0
0, 1, 0     0, 0, 1
```

再向左移动到下一列，第一次检测到该特征并强激活。

```
0, 1, 0     0, 1, 1
0, 1, 0  .  0, 1, 1 = 3
0, 1, 0     0, 1, 1
```

重复此过程，直到滤波器的边缘位于输入图像的边缘或最后一列上。这给出了特征映射的第一个完整行中的最后一个元素。

```
[0.0, 0.0, 3.0, 3.0, 0.0, 0.0]
```

然后滤波器向下移动一行并返回到第一列，从左到右重复如上过程，给出特征映射的第二行。直到滤波器的底部位于输入图像的底部或最后一行。

与上一节一样，我们可以看到特征映射是一个 6×6 矩阵，比 8×8 的输入图像小，因为滤波器应用于输入图像的限制。

## 延伸阅读

如果你希望更深入，本节将提供此主题的更多资源。

### 文章

* [机器学习卷积神经网络的速成课程](https://machinelearningmastery.com/crash-course-convolutional-neural-networks/)

### 书

* 第 9 章：卷积网络，[深度学习（Deep Learning）](https://amzn.to/2Dl124s)，2016。
* 第 5 章：计算机视觉的深度学习，[使用 Python 深度学习（Deep Learning with Python）](https://amzn.to/2Dnshvc)，2017。

### API

* [Keras Convolutional Layers API](https://keras.io/layers/convolutional/)
* [numpy.asarray API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.asarray.html)

## 总结

在本教程中，你了解到卷积在卷积神经网络中是如何工作的。

具体来说，你学到了：

* 卷积神经网络使用滤波器从输入中得到特征映射，该特征映射汇总了输入中检测到的特征的存在。
* 滤波器可以手工设计，例如线条检测器，但卷积神经网络的创新是，在训练期间在特定预测问题的背景下学习滤波器。
* 在卷积神经网络中如何计算一维和二维卷积层的特征映射。

你有什么问题？
在下面的评论中提出您的问题，我会尽力回答。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
