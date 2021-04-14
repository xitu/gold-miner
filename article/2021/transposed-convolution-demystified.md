> * 原文地址：[Transposed Convolution Demystified](https://towardsdatascience.com/transposed-convolution-demystified-84ca81b4baba)
> * 原文作者：[Divyanshu Mishra](https://medium.com/@mdivyanshu.ai)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md](https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 解密反卷积

反卷积是图像分割、超分辨率等应用领域的革命性概念，但有时它变得有些难以理解。 在这篇文章中，我将尝试对这个概念进行解密，并使其更易于理解。

![[(source](https://imgflip.com/memegenerator/7296870/Confused-Baby))](https://cdn-images-1.medium.com/max/2000/0*ilAQO9B3hm5waqqq)

## 前言

自从卷积神经网络（CNN）普及以来，计算机视觉领域正处于一个过渡阶段。 革命始于 Alexnet 在 2012 年赢得 ImageNet 挑战冠军，此后，CNN 一直在图像分类、目标检测、图像分割和许多其它与图像/视频相关的任务中占据主导地位。

当网络变得越深，卷积操作会使得空间尺寸变得更小，同时创建输入图像的抽象表示。 CNN 的此项特性对于图像分类等任务非常有用。此类任务只需预测输入图像中是否存在特定的对象即可。 但是，此项特性可能会给诸如目标定位、分割之类的任务带来问题。在这类任务中，物体在原始图像中的空间尺寸对于预测输出边界框或对物体进行分割是必需的。

为了解决这个问题，包括全尺寸卷积神经网络在内的多种技术被提了出来。在全尺寸卷积神经网络中，输入的维度通过 "same" 填充方式始终保持不变。 尽管该技术在很大程度上解决了该问题，但由于整个网络的卷积运算都是在原始输入尺寸上进行，因此也增加了计算成本。

![**Figure 1.** 全卷积神经网络([源](https://arxiv.org/abs/1411.4038))](https://cdn-images-1.medium.com/max/2000/0*jS2M_DNV6Z2YkhJ1.png)

图像分割领域使用的另一种方法是将网络分为两个部分，即降采样网络和上采样网络。在下采样网络中，使用了普通的 CNN 架构，并生成了输入图像的抽象表示。在上采样网络中，使用了各种技术对图像的抽象表示进行上采样，以使其空间尺寸等于输入图像。 这种架构也就是著名的编码器-解码器网络。

![**Figure 2**. 一个用于图像分割的先降采样再上采样的网络模型([源](https://arxiv.org/abs/1505.04366)).](https://cdn-images-1.medium.com/max/2000/0*t-FynrY2FJnaExY_.png)

## 上采样技术

下采样网络是直观的、众所周知的，但是很少有关于上采样所使用的各种技术的讨论。

编码器-解码器网络中最广泛使用的上采样技术是**：**

1. **最近邻技术：** 顾名思义，在最近邻技术中，我们将一个输入像素值复制到 K 个最近的邻居中，其中 K 取决于期望的输出。

![**Figure 3**. 最近邻上采样](https://cdn-images-1.medium.com/max/2000/0*0EJ025oepLbyi-Zd.png)

2. **双线性插值：** 在双线性插值中，我们采用输入像素的 4 个最近像素值，并根据与这四个像元的距离进行加权平均对输出进行平滑处理。

![**Figure 4.** 双线性插值](https://cdn-images-1.medium.com/max/2000/0*tWSnVE_JhDSZq8HQ)

3. **Bed Of Nails:** 在该方法中，我们将输入像素的值复制到输出图像中的相应位置，并在其余位置填充零。

![**Figure 5.** Bed Of Nails 上采样](https://cdn-images-1.medium.com/max/2000/1*LJAl2rkIfFTDRIQanIbfRQ.png)

4. **Max-Unpooling:** CNN 中的最大池化层选取卷积核内最大值作为输出。为了执行 max-unpooling 操作，首先，在编码步骤中为每个最大pooling层保存最大值的索引。然后在“解码”步骤中使用保存的索引，在该步骤中，将输入像素映射到保存的索引，并在其他所有位置填充零。The Max-Pooling layer in CNN takes the maximum among all the values in the kernel. To perform max-unpooling, first, the index of the maximum value is saved for every max-pooling layer during the encoding step. The saved index is then used during the Decoding step where the input pixel is mapped to the saved index, filling zeros everywhere else.

![**Figure 6.** Max-Unpooling Upsampling](https://cdn-images-1.medium.com/max/2018/1*Mog6cmBG4XzLa0IFbjZIaA.png)

All the above-mentioned techniques are predefined and do not depend on data, which makes them task-specific. They do not learn from data and hence are not a generalized technique.

## Transposed Convolutions

Transposed Convolutions are used to upsample the input feature map to a desired output feature map using some learnable parameters. 
The basic operation that goes in a transposed convolution is explained below:
1. Consider a 2x2 encoded feature map which needs to be upsampled to 3x3 feature map.

![**Figure 7.** Input Feature Map](https://cdn-images-1.medium.com/max/2000/1*BMJnnOKPhK8hoFP6sQ9edQ.png)

![**Figure 8.** Output Feature Map](https://cdn-images-1.medium.com/max/2000/1*VxtMdM-DsGwIa51GyDx-XQ.png)

2. We take a kernel of size 2x2 with unit stride and zero padding.

![**Figure 9.** Kernel of size 2x2](https://cdn-images-1.medium.com/max/2000/1*e6UnrcsFRaOidCq7mwJpTA.png)

3. Now we take the upper left element of the input feature map and multiply it with every element of the kernel as shown in figure 10.

![**Figure 10.**](https://cdn-images-1.medium.com/max/2000/1*7hVid7EAqCPkG6sEjHMI5w.png)

4. Similarly, we do it for all the remaining elements of the input feature map as depicted in figure 11.

![**Figure 11.**](https://cdn-images-1.medium.com/max/2000/1*yxBd_pCiEVVwEQFmc-Heog.png)

5. As you can see, some of the elements of the resulting upsampled feature maps are over-lapping. To solve this issue, we simply add the elements of the over-lapping positions.

![**Figure 12.** The Complete Transposed Convolution Operation](https://cdn-images-1.medium.com/max/2000/1*faRskFzI7GtvNCLNeCN8cg.png)

6. The resulting output will be the final upsampled feature map having the required spatial dimensions of 3x3.

Transposed convolution is also known as Deconvolution which is not appropriate as deconvolution implies removing the effect of convolution which we are not aiming to achieve.

It is also known as upsampled convolution which is intuitive to the task it is used to perform, i.e upsample the input feature map.

It is also referred to as fractionally strided convolution due since stride over the output is equivalent to fractional stride over the input. For instance, a stride of 2 over the output is 1/2 stride over the input.

Finally, it is also referred to as Backward strided convolution because forward pass in a Transposed Convolution is equivalent to backward pass of a normal convolution.

## Problems with Transposed Convolutions:

Transposed convolutions suffer from chequered board effects as shown below.

![**Figure 13.** Chequered Artifacts([source](https://distill.pub/2016/deconv-checkerboard/))](https://cdn-images-1.medium.com/max/2194/1*4Tsf3dlg7Wlhrt0D7k7osA.png)

The main cause of this is uneven overlap at some parts of the image causing artifacts. This can be fixed or reduced by using kernel-size divisible by the stride, for e.g taking a kernel-size of 2x2 or 4x4 when having a stride of 2.

## Applications of Transposed Convolution:

1. Super- Resolution:

![**Figure 14.** Super Resolution using Transposed Convolution([source](http://openaccess.thecvf.com/content_ECCV_2018/html/Seong-Jin_Park_SRFeat_Single_Image_ECCV_2018_paper.html))](https://cdn-images-1.medium.com/max/NaN/0*kIeyw3eMk-e1UchK.png)

2. Semantic Segmentation:

![**Figure 15.** Semantic Segmentation implemented using Transposed Convolution([source](https://thegradient.pub/semantic-segmentation/))](https://cdn-images-1.medium.com/max/2220/0*vk2xCr1r6ZaO7cYD.png)

## Conclusion:

Transposed Convolutions are the backbone of the modern segmentation and super-resolution algorithms. They provide the best and most generalized upsampling of abstract representations. In this post, we explored the various upsampling techniques used and then tried to dig deeper into the intuitive understanding of transposed convolutions. 
I hope you liked the post and if you have any doubts, queries or comments, please feel free to connect with me on [Twitter](https://twitter.com/Perceptron97) or [Linkedin](https://www.linkedin.com/in/divyanshu-mishra-ai/).

**References:**

1. [CS231n: Convolutional Neural Networks for Visual Recognition](https://www.youtube.com/watch?v=nDPWywWRIRo)
2. [Transposed Convolutions explained with… MS Excel!](https://medium.com/apache-mxnet/transposed-convolutions-explained-with-ms-excel-52d13030c7e8)
3. [Deep Dive into Deep Learning](http://d2l.ai/chapter_computer-vision/transposed-conv.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
