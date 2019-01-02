> * 原文地址：[Real-time object detection with YOLO](http://machinethink.net/blog/object-detection-with-yolo/)
> * 原文作者：本文已获原作者 [Matthijs Hollemans](http://machinethink.net/blog/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Danny Lau](https://github.com/Danny1451)
> * 校对者：[Dalston Xu](https://github.com/xunge0613) ,[DeepMissea](https://github.com/DeepMissea)


# 深度学习在 iOS 上的实践 —— 通过 YOLO 在 iOS 上实现实时物体检测 #


>译者注：
>在阅读这篇文章之前可能会遇到的一些名词，这里是解释(我自己也查了相当多的资料，为了翻译地尽可能的简单易懂一些)
> - Metal：Metal 是苹果在 iOS 8 之后 提供的一种低层次的渲染应用程序编程接口，提供了软件所需的最低层，保证软件可以运行在不同的图像芯片上。（和 OpenGL ES 是并列关系）
> - 分类器：该函数或模型能够把数据库中的数据纪录映射到给定类别中的某一个，从而可以应用于数据预测。
> - 批量归一化：解决在训练过程中，中间层数据分布发生改变的问题，以防止梯度消失或爆炸、加快训练速度。
> - 文中术语主要参照孙逊等人对斯坦福大学深度学习教程[UFLDL Tutorial](http://ufldl.stanford.edu/wiki/index.php/UFLDL%E6%95%99%E7%A8%8B)的翻译

在计算机视觉领域，物体检测是经典问题之一：
**识别一张给定的图像中包含的物体*是什么*，和它们在图像中的*位置*。**

检测是比分类更复杂的一个问题，虽然分类也要识别物体，但是它不需要告诉你物体在图像中的位置，并且分类无法识别包含多个物体的图像。

[![](http://machinethink.net/images/yolo/ClassificationVsDetection.png) ](http://machinethink.net/images/yolo/ClassificationVsDetection@2x.png)

[YOLO](https://pjreddie.com/darknet/yolo/) 是一个用来处理实时物体检测的聪明的神经网络。

在这篇博客里面我将介绍如何通过 Metal Performance Shaders 让“迷你”版的 YOLOv2 在 iOS 上运行（译：MetalPerformanceShaders 是 iOS 9 中 Metal Kit新增的方法）。

在你继续看下去之前，务必先看下这个[令人震惊的 YOLOv2 预告](https://www.youtube.com/watch?v=VOC3huqHrss)。 😎

## YOLO 是怎么工作的 ##

你可以用一个类似于 [VGGNet](/blog/convolutional-neural-networks-on-the-iphone-with-vggnet/) 或 [Inception](https://github.com/hollance/Forge/tree/master/Examples/Inception) 的分类器，通过在图像上移动一个小的窗口将分类器转换成物体检测器。在每一次移动中，运行分类器来获取对当前窗口内物体类型的推测。通过滑动窗口可以获得成百上千个关于该图像的推测，但是只有那个分类器最确定的那个选项会被保留。

这个方案虽然是可行的但是很明显它会非常的慢，因为你需要多次运行分类器。一种可以略微改善的方法是首先预测哪些部分的图片可能包含有趣的信息 - 所谓的**区域建议** - 然后只在这些区域运行分类器。相比移动窗口来说，分类器确实减少了不少工作量，但是它仍会运行较多次数。

YOLO 采用了一种完全不同的实现方式。它不是传统的分类器，而是被改造成了对象探测器。YOLO 实际上只会看图像一次（因此得名：You Only Look Once（你只用看一次）），但是是通过一种聪明的方式。
YOLO 把图像分割为 13 乘 13 单元的网格：

[![The 13x13 grid](http://machinethink.net/images/yolo/Grid@2x.png)](/images/yolo/Grid@2x.png)

每个单元都负责预测 5 个边界框。边界框代表着这个矩形包含着一个物体。

YOLO 也会输出一个 **确信值** 来告诉我们它有多确定边界框里是否包含某个物体。这个分数不会包含任何关于边界框内的物体是什么的信息，只是这个框是否符合标准。

预测之后的边界框可能看上去像下面这样（确信值越高，盒子的边界画的越宽）

[![](http://machinethink.net/images/yolo/Boxes.png)](http://machinethink.net/images/yolo/Boxes@2x.png)

对每个边界框，单元也会推测一个**类别**。这就像分类器一样：它提供了所有可能类的可能性分布情况。这个版本的 YOLO 我们是通过 [PASCAL VOC dataset](http://host.robots.ox.ac.uk/pascal/VOC/) 来训练的，它可以识别 20 种不同的类，比如：

- 自行车
- 船
- 汽车
- 猫
- 狗
- 人
- 等等…

边界框的确信值和类的预测组合成一个最终分数，告诉我们边界框中包含一个特定类型的物体的可能性。举个例子，左侧这个又大又粗的黄色方框认为有 85% 的可能性它包含了“狗”这个物体。


[![The bounding boxes with their class scores](http://machinethink.net/images/yolo/Scores.png)](http://machinethink.net/images/yolo/Scores@2x.png)

一共有 13×13 = 169 个单元格，每个单元格预测 5 个边界框，最终我们会有 845 个边界框。事实证明，大部分的框的确信值都很低，所以我们只保留那些最终得分在 30% 及以上的值（你可以根据你所需要的精确程度来修改这个下限）。

接下来是最后的预测：

[![The final prediction](http://machinethink.net/images/yolo/Prediction.png)](http://machinethink.net/images/yolo/Prediction@2x.png)

从总共 845 的个边界框中我们只保留了这三个，因为它们给出了最好的结果。但是请注意虽然是 845 个独立的预测，它们都是同时运行的 - 神经网络只会运行一次。这也是为什么 YOLO 是如此的强大和快速。

*(上图来自 [pjreddie.com](https://pjreddie.com)。)*

## 神经网络 ##

YOLO 的架构是很简单的，它就是一个卷积神经网络：

```
Layer         kernel  stride  output shape
---------------------------------------------
Input                          (416, 416, 3)
Convolution    3×3      1      (416, 416, 16)
MaxPooling     2×2      2      (208, 208, 16)
Convolution    3×3      1      (208, 208, 32)
MaxPooling     2×2      2      (104, 104, 32)
Convolution    3×3      1      (104, 104, 64)
MaxPooling     2×2      2      (52, 52, 64)
Convolution    3×3      1      (52, 52, 128)
MaxPooling     2×2      2      (26, 26, 128)
Convolution    3×3      1      (26, 26, 256)
MaxPooling     2×2      2      (13, 13, 256)
Convolution    3×3      1      (13, 13, 512)
MaxPooling     2×2      1      (13, 13, 512)
Convolution    3×3      1      (13, 13, 1024)
Convolution    3×3      1      (13, 13, 1024)
Convolution    1×1      1      (13, 13, 125)
---------------------------------------------

```

这种神经网络只使用了标准的层类型：3x3 核心的卷积层和 2x2 的最大值池化层，没有复杂的事务。YOLOv2 中没有全连接层。

**注意：** 我们将要使用的“迷你”版本的 YOLO 只有 9 个卷积层和 6 个池化层。完整版的 YOLOv2 模型的层数是“迷你”版的 3 倍，并且有一个略微复杂的形状，但它仍然是一个常规的转换。

最后的卷积层有个 1x1 的核心用于降低数据到 13x13x125 的尺寸。这个 13x13 看上去很熟悉：这正是图像原来分割之后的网格尺寸。

所以最终我们给每个网格单元生成了 125 个通道。这 125 个数字包含了边界框中的数据和类型预测。为什么是 125 个呢？恩，每个单元格预测 5 个边界框，并且一个边界框通过 25 个数据元素来描述：

- 边界框的矩形的 x 轴坐标， y 轴坐标，宽度和高度
- 确信值
- 20 个类型的可能性分布

使用 YOLO 很简单：你给它一个输入图像（尺寸调节到 416x416 像素），它在单一传递下通过卷积网络，最后转变为 13x13x125 的张量来描述这些网格单元的边界框。你所需要做的只是计算这些边界框的最终分数，将那些小于 30% 的分数遗弃。

**提示：** 为了学习更多关于 YOLO 的工作原理和训练方式，看下这个其中一位发明者的[精彩的演讲](https://www.youtube.com/watch?v=NM6lrxy0bxs)。这个视频实际上描述的是 YOLOv1，一个在构建方面略微有点不同的老版本，但是其主要思想还是一样的。值得一看！

## 转换到 Metal ##

我刚刚描述的架构是迷你 YOLO 的，正是我们将在 iOS app 中使用的那个。完整的 YOLOv2 网络包含 3 倍的层数，并且这对于目前的 iPhone 来说想快速运行它，有点太大了。因此，迷你 YOLO 用了更少的层数，这使它比它哥哥快了不少，但是也损失了一些精确度。


[![](http://machinethink.net/images/yolo/CatOrDog.png) ](http://machinethink.net/images/yolo/CatOrDog@2x.png)

YOLO 是用 Darknet 写的，YOLO 作者的一个自定义深度学习框架。可下载到的权重只有 Darknet 格式。虽然 Darknet 已经[开源](https://github.com/pjreddie/darknet)了，但是我不是很愿意花太多的时间来弄清楚它是怎么工作的。

幸运的是，[有人](https://github.com/allanzelener/YAD2K/)已经尝试并把 Dardnet 模型转换为 Keras，恰好是我所用的深度学习工具。因此我唯一要做的就是执行这个 ”YAD2K“ 的脚本来把 Darknet 格式的权重转换到 Keras 格式，然后再写我自己的脚本，把 Keras 权重转换到 Metal 的格式。

但是，仍然有些奇怪…… YOLO 在卷积层之后使用的是一个常规的技术叫做**批量归一化**。

在”批量归一化“背后的想法是数据干净的时候神经网络工作效果最好。理想情况下，输入到层的数据的均值是 0 并且没有太多的分歧。任何做过任意机器学习的人应该很熟悉这个，因为我们经常使用一个叫做”特征缩放“或者”白化“在我们的输入数据上来实现这一效果。

批量归一化在层与层之间对数据做了一个类似的特征缩放的工作。这个技术让神经网络表现的更好因为它暂停了数据由于在网络中流动而导致的污染。

为了让你大致了解批量归一的作用，看一看下面这两个直方图，分别是第一次应用卷积层后进行归一化与不进行归一化的不同结果。
[![](http://machinethink.net/images/yolo/BatchNorm.png)](http://machinethink.net/images/yolo/BatchNorm@2x.png)

在训练深度网络的时候，批量归一化很重要，但是我们证实在推断时可以不用这个操作。这样效果不错，因为不做批量归一化的计算会让我们的 app 更快。而且任何情况下，Metal 都没有一个 `MPSCNNBatchNormalization` 层。

批量归一化通常在卷积层之后，在激活函数（在 YOLO 中叫做”泄露“的 Relu ）生效之前。既然卷积和批量统一都是对数据的线性转换，我们可以把批量统一层的参数和卷积的权重组和到一起。这叫做把批量统一层”折叠“到卷积层。

长话短说，通过一些数学运算，我们可以移除批量归一层，但是并不意味着我们在卷积层之前必须去改变权重。

关于卷积层计算内容的快速总结：如果 `x` 是输入图像的像素，`w` 是这层的权重，卷积根本上来说就是按下面的方式计算每个输出像素：

```
out[j] = x[i]*w[0] + x[i+1]*w[1] + x[i+2]*w[2] + ... + x[i+k]*w[k] + b

```

这是输入像素和卷积权重点积和加上一个偏置值 `b`，

下面这是批量归一化对上述卷积输出结果进行的计算操作：

```
        gamma * (out[j] - mean)
bn[j] = ---------------------- + beta
            sqrt(variance)

```

它先减去了输出像素的平均值，除以方差，再乘以一个缩放参数 gamma，然后加上偏移量 beta。这四个参数 — `mean`，`variance`， `gamma`，和 `beta`。- 正是批量统一层随着网络训练之后学到的内容。

为了移除批量归一化，我们可以把这两个等式调整一下来给卷积层计算新的权重和偏置量：

```
           gamma * w
w_new = --------------
        sqrt(variance)

        gamma*(b - mean)
b_new = ---------------- + beta
         sqrt(variance)

```

用这个基于输入 `x` 的新权重和偏置项来进行卷积操作会得到和之前卷积加上批量归一化一样的结果。

现在我们可以移除批量归一化层只用卷积层了，但是由于调整了权重和新的偏置项 `w_new` 和 `b_new` 。我们要对网络中所有的卷积层都重复这个操作。

**注意：** 实际上在 YOLO 中，卷积层并没有使用偏置量，所以 `b` 在上面的等式中始终是 0 。但是请注意在折叠批量归一化参数的之后，卷积层**真**得到了一个偏置项。

一旦我们把所有的批量归一化层都折叠到它们的之前卷积层中时，我们就可以把权重转换到 Metal 了。这是一个很简单的数组转换（Keras 与 Metal 相比是用不同的顺序来存储），然后把它们写入到一个 32 位浮点数的二进制文件中。

如果你好奇的话，看下这个转换脚本 [yolo2metal.py](https://github.com/hollance/Forge/blob/master/Examples/YOLO/yolo2metal.py) 可以了解更多。为了测试这个折叠工作，这个脚本生成了一个新的模型，这个模型没有批量归一化层而是用了调整之后的权重，然后和之前的模型的推测进行一个比较。

## iOS 应用 ##

毋庸置疑地，我用了 [Forge](https://github.com/hollance/Forge) 来构建 iOS 应用。
 😂 你可以在 [YOLO](https://github.com/hollance/Forge/tree/master/Examples/YOLO) 的文件夹中找到代码。想试的话：下载或者 clone Forge，在 Xcode 8.3 或者更新的版本中打开 **Forge.xcworkspace** ，然后在 iPhone 6 或者更高版本的手机上运行 **YOLO** 这个 target 。

测试这个应用的最简单的方法是把你的 iPhone 对准这些 [YouTube 视频](https://www.youtube.com/watch?v=e_WBuBqS9h8)上:

[![简单的应用](http://machinethink.net/images/yolo/App.png)](http://machinethink.net/images/yolo/App@2x.png)

有趣的代码是在 **YOLO.swift** 中。首先它初始化了卷积网络：

```
let leaky = MPSCNNNeuronReLU(device: device, a: 0.1)

let input = Input()

let output = input
         --> Resize(width: 416, height: 416)
         --> Convolution(kernel: (3, 3), channels: 16, padding: true, activation: leaky, name: "conv1")
         --> MaxPooling(kernel: (2, 2), stride: (2, 2))
         --> Convolution(kernel: (3, 3), channels: 32, padding: true, activation: leaky, name: "conv2")
         --> MaxPooling(kernel: (2, 2), stride: (2, 2))
         --> ...and so on...

```

先把来自摄像头的输入缩放至 416x416 像素，然后输入到卷积和最大池化层中。这和其他的转换操作都非常相似。

有趣的是在输出之后的操作。回想一下输出的转换之后是一个 13x13x125 的张量：图片中的每个网格的单元都有 125 个通道的数据。这 125 数据包含了边界框和类型的预测，然后我们需要以某种方式把输出排序。这些都在函数 `fetchResult()` 中进行。

**注意：** `fetchResult()` 中的代码是在 CPU 中执行的，不是在 GPU 中。这样的方式更容易实现。话句话说，这个嵌套的循环在 GPU 中并行执行可能效果会更好。未来我也许会研究这个，然后再写一个 GPU 的版本。


下面介绍了 fetchResult() 是如何工作的： 

```
public func fetchResult(inflightIndex: Int) -> NeuralNetworkResult<Prediction> {
  let featuresImage = model.outputImage(inflightIndex: inflightIndex)
  let features = featuresImage.toFloatArray()

```

在卷积层的输出是以 `MPSImage` 的格式的。我们先把它转换到一个叫做 features 的 Float 值类型的数组，以便我们更好的使用它。

`fetchResult()` 的主体是一个大的嵌套循环。它包含了所有的网格单元和每个单元的五次预测：

```
for cy in0..<13 {
    for cx in0..<13 {
      for b in0..<5 {
         . . .
      }
    }
  }

```

在这个循环里面，我们给网格单元 `(cy, cx)` 计算了边界框 `b` 。 

首先我们从 `features` 数组中读取边界框的 x， y， width 和 height ，也包括确信值。

```
let channel = b*(numClasses + 5)
let tx = features[offset(channel, cx, cy)]
let ty = features[offset(channel + 1, cx, cy)]
let tw = features[offset(channel + 2, cx, cy)]
let th = features[offset(channel + 3, cx, cy)]
let tc = features[offset(channel + 4, cx, cy)]

```


帮助函数 `offset()` 用来定位数组中合适的读取位置。Metal 以每次 4 个通道一组来把数据存在纹理片中，这意味着 125 个通道不是连续存储，而是分散存储的。（想深入分析的话可以去看源码）。

我们仍然需要处理 `tx`， `ty`， `tw`， `th`， `tc` 这五个参数 ，因为它们的格式有点奇怪。如果你不知道这些处理方法哪来的话，可以看下这篇[论文](https://arxiv.org/abs/1612.08242) (这是训练这个神经网络的附加产物之一)。
>译者注：这篇论文就是 YOLO 的作者写的。作者在训练的过程中形成了这篇论文，并作为训练过程的一个更详细的描述。

```
llet x = (Float(cx) + Math.sigmoid(tx)) * 32
let y = (Float(cy) + Math.sigmoid(ty)) * 32

let w = exp(tw) * anchors[2*b    ] * 32
let h = exp(th) * anchors[2*b + 1] * 32

let confidence = Math.sigmoid(tc)

```

现在 `x` 和 `y` 代表了在我们使用的输入到神经网络的 416x416 的图像中边界框的中心；
`w` 和 `h` 则是上述图像空间中边界框的宽度和高度。边界框的确信值是 `tc` ，我们通过 sigmoid 函数把它转换到百分比。

现在我们有了我们的边界框，并且我们知道了 YOLO 对这个框中是否包含着某个对象的确信度。接下来，让我们看下类型预测，来看看 YOLO 认为框中到底是个什么类型的物体：

```
var classes = [Float](repeating: 0, count: numClasses)
for c in 0..< numClasses {
  classes[c] = features[offset(channel + 5 + c, cx, cy)]
}
classes = Math.softmax(classes)

let (detectedClass, bestClassScore) = classes.argmax()

```

重新调用 `features` 数组中包含着对边界框中物体预测的 20 个通道。我们读取到一个新的数组 `classes` 中。因为是用来做分类器的，我们通过 softmax 把这个数组转换成可能的分配情况，然后我们选择最高分数的类作为最后的胜者。

现在我们可以计算边界框的最终分数了 - 举个例子，“这个边界框有 85% 的概率包含一条狗”。由于一共有 845 个边界框，而我们只想要那些分数高于某个值的边界框。

```
let confidenceInClass = bestClassScore * confidence
if confidenceInClass > 0.3 {
  let rect = CGRect(x: CGFloat(x - w/2), y: CGFloat(y - h/2),
                    width: CGFloat(w), height: CGFloat(h))

  let prediction = Prediction(classIndex: detectedClass,
                              score: confidenceInClass,
                              rect: rect)
  predictions.append(prediction)
}

```

上面的代码是对网格内的每个单元进行循环。当循环结束后，我们通常会有了一个包含了 10 到 20 个预测 `predictions` 数组。

我们已经过滤掉了那些低分数的边界框，但是仍然有些框的和其他的框有较多的重叠。因此，在最后一步我们需要在 `fetchResult()` 里面做的事叫做 *非极大抑制* ，用来去掉那些重复的框。

```
var result = NeuralNetworkResult<Prediction>()
  result.predictions = nonMaxSuppression(boxes: predictions,
                                         limit: 10, threshold: 0.5)
  return result
}

```

`nonMaxSuppression()` 函数使用的算法很简单：

1. 从那个最高分的边界框开始。
2. 移除剩下所有与它重叠部分大于最小值的边界框（比如 大于 50%）。
3. 回到第一步直到没有更多的边界框。

这会移除那些有高分数但是和其他框有太多重复部分的框。只会保留最好的那些框。

上面这些差不多就是这个意思：一个常规的卷积网络加上对结果的一系列处理。


## 它表现的效果怎么样？ ##

[YOLO 网站](https://pjreddie.com/darknet/yolo/)声称迷你版本的 YOLO 可以实现 200 帧每秒。但是当然这是在一个桌面级的 GPU 上，不是在移动设备上。所以在 iPhone 上它能跑多快呢？

在我的 iPhone 6s 上面处理一张图片大约需要 **0.15 秒** 。帧率只有 6 ，这帧率基本满足实时的调用。如果你把你的手机对着开过的汽车，你可以看到有个边界框在车子后面不远的地方跟着它。尽管如此，我还是被这个技术深深的震惊了。 😁

**注意：** 正如我上面所解释的，边界框的处理是在 CPU 而不是 GPU 上的。如果完全在 GPU 上运行是不是会更快呢？可能，但是 CPU 的代码只用了 0.03 秒， 20% 的运行时间。在 GPU 上处理一部分的工作是可行的，但是我不确定这样是否值得，因为转换层仍然占用了 80% 的时间。

我认为慢的主要原因之一是由于卷积层包含了 512 和 1024 个输出通道。在我的实验中，似乎 `MPSCNNConvolution` 在处理多通道的小图片比少通道的大图片时更吃力。

一个让我想去尝试的是采用不同的网络构建方式，比如 SqueezeNet ，然后重新训练网络来在最后一层进行边界框的预测。换句话说，采用 YOLO 的想法并将它在一个更小更快的转换之上实现。用准确度的下降来换取速度的提升的做法是否值得呢？

**注意：** 另外，最近发布的 [Caffe2](http://caffe2.ai/) 框架同样是通过 Metal 来实现在 iOS 上运行的。[Caffe2-iOS 项目](https://github.com/KleinYuan/Caffe2-iOS)来自于迷你 YOLO 的一个版本。它似乎比纯 Metal 版本运行的慢 0.17 秒每帧。


## 鸣谢 ##

想了解更多关于 YOLO 的信息，看下以下由它的作者们写的论文吧：

- [You Only Look Once: Unified, Real-Time Object Detection](https://arxiv.org/abs/1506.02640) by Joseph Redmon, Santosh Divvala, Ross Girshick, Ali Farhadi (2015)
- [YOLO9000: Better, Faster, Stronger](https://arxiv.org/abs/1612.08242) by Joseph Redmon and Ali Farhadi (2016)

我的实现是部分基于 TensorFlow 的 Android demo [TF Detect](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/android)， Allan Zelener 的[YAD2K](https://github.com/allanzelener/YAD2K/), 和 [Darknet的源码](https://github.com/pjreddie/darknet)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
