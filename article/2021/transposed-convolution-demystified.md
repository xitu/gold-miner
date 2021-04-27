> * 原文地址：[Transposed Convolution Demystified](https://towardsdatascience.com/transposed-convolution-demystified-84ca81b4baba)
> * 原文作者：[Divyanshu Mishra](https://medium.com/@mdivyanshu.ai)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md](https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[chzh9311](https://github.com/chzh9311)，[samyu2000](https://github.com/samyu2000)

# 解密转置卷积

转置卷积是图像分割、超分辨率等应用领域的革命性概念，但它有些晦涩难懂。 在这篇文章中，我将揭开它的神秘面纱，方便大家理解。

![（[源](https://imgflip.com/memegenerator/7296870/Confused-Baby)）](https://cdn-images-1.medium.com/max/2000/0*ilAQO9B3hm5waqqq)

## 前言

自从卷积神经网络（CNN）技术普及以来，计算机视觉技术进入了一个过渡阶段。在 2012 年的 ImageNet 竞赛中，Alexnet 获得了冠军，此后，CNN 成了处理图像分类、目标检测、图像分割以及其它与图像/视频相关的任务的主要技术。

当网络变得越深，卷积操作会使得空间尺寸变得更小，同时创建了输入图像的抽象表示。 CNN 的此项特性对于只需预测输入图像中是否存在特定对象的图像分类等任务非常有用。但是，此项特性可能会给诸如目标定位、分割之类的任务带来问题。因为在这类任务中，物体在原始图像中的空间尺寸对于预测输出边界框或对物体进行分割是必不可少的。

为了解决这个问题，包括全尺寸卷积神经网络在内的多种技术应运而生。在全尺寸卷积神经网络中，图像维度通过 same padding 的方式保持与输入一致。 尽管该技术在很大程度上解决了该问题，但由于整个网络的卷积运算都是在原始输入尺寸上进行，因此也增加了计算成本。

![**图 1.** 全卷积神经网络([源](https://arxiv.org/abs/1411.4038))](https://cdn-images-1.medium.com/max/2000/0*jS2M_DNV6Z2YkhJ1.png)

图像分割领域使用的另一种方法是将网络分为两个部分，即降采样网络和上采样网络。在降采样网络中，使用了普通的 CNN 架构，并生成了输入图像的抽象表示。在上采样网络中，使用了各种技术对图像的抽象表示进行上采样，以使其空间尺寸等于输入图像。 这种架构也就是著名的编码器-解码器网络。

![**图 2**. 一个用于图像分割的先降采样再上采样的网络模型([源](https://arxiv.org/abs/1505.04366)).](https://cdn-images-1.medium.com/max/2000/0*t-FynrY2FJnaExY_.png)

## 上采样技术

下采样网络比较直观，同时被广泛使用，但关于上采样的相关技术，很少有人讨论。

编码器-解码器网络中最广泛使用的上采样技术是：

1. **最近邻技术：** 顾名思义，在最近邻技术中，我们将一个输入像素值复制到 K 个最近的邻近元素中，其中 K 取决于期望的输出。

![**图 3**. 最近邻上采样](https://cdn-images-1.medium.com/max/2000/0*0EJ025oepLbyi-Zd.png)

2. **双线性插值：** 在双线性插值中，我们采用输入像素的 4 个最近像素值，并根据与这四个像元的距离进行加权平均对输出进行平滑处理。

![**图 4.** 双线性插值](https://cdn-images-1.medium.com/max/2000/0*tWSnVE_JhDSZq8HQ)

3. **Bed Of Nails：** 在该方法中，我们将输入像素的值复制到输出图像中的相应位置，并在其余位置填充零。

![**图 5.** Bed Of Nails 上采样](https://cdn-images-1.medium.com/max/2000/1*LJAl2rkIfFTDRIQanIbfRQ.png)

4. **反最大池化:** CNN 中的最大池化层选取卷积核内最大值作为输出。为了执行反最大池化操作，首先，在编码步骤中为每个最大池化层保存最大值的索引。然后在“解码”步骤中使用保存的索引，将输入像素映射到保存的索引对应的位置，并在其他位置填充零。

![**图 6.** 反最大池化上采样](https://cdn-images-1.medium.com/max/2018/1*Mog6cmBG4XzLa0IFbjZIaA.png)

所有上述技术都是预定义的，并且不依赖于数据，这使它们成为特定于任务的。它们无法从数据中学习，因此不是通用技术。

## 转置卷积

转置卷积用于使用一些可学习的参数对输入特征图进行上采样，从而得到所需的输出特征图。
转置卷积的基本操作步骤如下：
1. 以一个 2x2 编码的特征图为例，将其上采样到 3x3 大小。

![**图 7.** 输入特征图](https://cdn-images-1.medium.com/max/2000/1*BMJnnOKPhK8hoFP6sQ9edQ.png)

![**图 8.** 输出特征图](https://cdn-images-1.medium.com/max/2000/1*VxtMdM-DsGwIa51GyDx-XQ.png)

2.我们使用一个大小为 2x2 的核，步长为 1，填充为 0。

![**图 9.** 2x2 大小的核](https://cdn-images-1.medium.com/max/2000/1*e6UnrcsFRaOidCq7mwJpTA.png)

3. 现在，我们将输入特征图的左上角元素与核的每个元素相乘，如图 10 所示。

![**图 10.**](https://cdn-images-1.medium.com/max/2000/1*7hVid7EAqCPkG6sEjHMI5w.png)

4. 同样，我们对输入特征图的所有其余元素执行此操作，如图 11 所示。

![**图 11.**](https://cdn-images-1.medium.com/max/2000/1*yxBd_pCiEVVwEQFmc-Heog.png)

5. 如您所见，生成的上采样特征图的某些元素是重叠的。为解决此问题，我们简单地将重叠的元素求和即可。

![**图 12.** 完整的转置卷积操作](https://cdn-images-1.medium.com/max/2000/1*faRskFzI7GtvNCLNeCN8cg.png)

6. 最终的输出将是上采样后具有所需空间尺寸的 3x3 大小的特征图。

转置卷积也称为反卷积，但这一别称并不合适。因为反卷积意味着抵消卷积操作的效果，而这并不是我们的目的。

它也被称为上采样卷积，这直观的反映了它执行的任务，即对输入特征图进行上采样。

由于在输出上进行常规卷积等效于在输入上进行小数步长卷积，转置卷积也称为小数步长卷积。例如，输出上的步长为 2 的卷积等价于输入上的步长为 0.5 的卷积。

最后，它也被称为反向卷积，因为转置卷积中的前向计算等效于常规卷积的反向计算。

## 转置卷积的问题：

转置的卷积受棋盘效应的影响，如下所示。

![**图 13.** 棋盘效应（[源](https://distill.pub/2016/deconv-checkerboard/)）](https://cdn-images-1.medium.com/max/2194/1*4Tsf3dlg7Wlhrt0D7k7osA.png)

造成这种情况的主要原因是在图像的某些部分出现不均匀的重叠，从而导致出现伪影。这可以通过使用可被步长整除的核大小来修复或减轻，例如在步长为 2 时采用 2x2 或 4x4 的核大小。

## 转置卷积的应用：

1. 超分辨率：

![**图 14.** 使用转置卷积进行超分辨（[源](http://openaccess.thecvf.com/content_ECCV_2018/html/Seong-Jin_Park_SRFeat_Single_Image_ECCV_2018_paper.html)）](https://cdn-images-1.medium.com/max/NaN/0*kIeyw3eMk-e1UchK.png)

2. 语义分割：

![**图 15.** 使用转置卷积实现语义分割（[源](https://thegradient.pub/semantic-segmentation/)）](https://cdn-images-1.medium.com/max/2220/0*vk2xCr1r6ZaO7cYD.png)

## 结论：

转置卷积是当今语义分割和超分辨率算法的基础。它们提供了抽象表示形式的最佳、最通用的上采样方式。在这篇文章中，我们探索了经常使用的各种上采样技术，然后尝试更加直观、深入地了解转置卷积。希望您喜欢这篇文章，如果您有任何疑问、问题或意见，请随时通过 [Twitter](https://twitter.com/Perceptron97) 或者 [Linkedin](https://www.linkedin.com/in/divyanshu-mishra-ai/) 联系我。

**参考目录：**

1. [CS231n: Convolutional Neural Networks for Visual Recognition](https://www.youtube.com/watch?v=nDPWywWRIRo)
2. [Transposed Convolutions explained with… MS Excel!](https://medium.com/apache-mxnet/transposed-convolutions-explained-with-ms-excel-52d13030c7e8)
3. [Deep Dive into Deep Learning](http://d2l.ai/chapter_computer-vision/transposed-conv.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
