> * 原文地址：[Transposed Convolution Demystified](https://towardsdatascience.com/transposed-convolution-demystified-84ca81b4baba)
> * 原文作者：[Divyanshu Mishra](https://medium.com/@mdivyanshu.ai)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md](https://github.com/xitu/gold-miner/blob/master/article/2021/transposed-convolution-demystified.md)
> * 译者：
> * 校对者：

# Transposed Convolution Demystified

Transposed Convolutions is a revolutionary concept for applications like image segmentation, super-resolution etc but sometimes it becomes a little trickier to understand. In this post, I will try to demystify the concept and make it easier to understand.

![[(source](https://imgflip.com/memegenerator/7296870/Confused-Baby))](https://cdn-images-1.medium.com/max/2000/0*ilAQO9B3hm5waqqq)

## Introduction

Computer Vision Domain is going through a transition phase since gaining popularity of Convolutional Neural Networks(CNN). The revolution started with Alexnet winning the ImageNet challenge in 2012 and since then CNN’s have ruled the domain in Image Classification, Object Detection, Image Segmentation and many other image/videos related tasks.

The Convolution operation reduces the spatial dimensions as we go deeper down the network and creates an abstract representation of the input image. This feature of CNN’s is very useful for tasks like image classification where you just have to predict whether a particular object is present in the input image or not. But this feature might cause problems for tasks like Object Localization, Segmentation where the spatial dimensions of the object in the original image are necessary to predict the output bounding box or segment the object.

To fix this problem various techniques are used such as fully convolutional neural networks where we preserve the input dimensions using ‘same’ padding. Though this technique solves the problem to a great extent, it also increases the computation cost as now the convolution operation has to be applied to original input dimensions throughout the network.

![**Figure 1.** Fully Convolutional Neural Network([source](https://arxiv.org/abs/1411.4038))](https://cdn-images-1.medium.com/max/2000/0*jS2M_DNV6Z2YkhJ1.png)

Another approach used for image segmentation is dividing the network into two parts i.e An Downsampling network and then an Upsampling network.
In the Downsampling network, simple CNN architectures are used and abstract representations of the input image are produced. 
In the Upsampling network, the abstract image representations are upsampled using various techniques to make their spatial dimensions equal to the input image. This kind of architecture is famously known as Encoder-Decoder network.

![**Figure 2**. A Downsampling and Upsampling Network for Image Segmentation([source](https://arxiv.org/abs/1505.04366)).](https://cdn-images-1.medium.com/max/2000/0*t-FynrY2FJnaExY_.png)

## Upsampling Techniques

The Downsampling network is intuitive and well known to all of us but very less is discussed about the various techniques used for Upsampling.

The most widely used techniques for upsampling in Encoder-Decoder Networks are**:**

1. **Nearest Neighbors**: In Nearest Neighbors, as the name suggests we take an input pixel value and copy it to the K-Nearest Neighbors where K depends on the expected output.

![**Figure 3**. Nearest Neighbors Upsampling](https://cdn-images-1.medium.com/max/2000/0*0EJ025oepLbyi-Zd.png)

2. **Bi-Linear Interpolation:** In Bi-Linear Interpolation, we take the 4 nearest pixel value of the input pixel and perform a weighted average based on the distance of the four nearest cells smoothing the output.

![**Figure 4.** Bi-Linear Interpolation](https://cdn-images-1.medium.com/max/2000/0*tWSnVE_JhDSZq8HQ)

3. **Bed Of Nails:** In Bed of Nails, we copy the value of the input pixel at the corresponding position in the output image and filling zeros in the remaining positions.

![**Figure 5.** Bed Of Nails Upsampling](https://cdn-images-1.medium.com/max/2000/1*LJAl2rkIfFTDRIQanIbfRQ.png)

4. **Max-Unpooling:** The Max-Pooling layer in CNN takes the maximum among all the values in the kernel. To perform max-unpooling, first, the index of the maximum value is saved for every max-pooling layer during the encoding step. The saved index is then used during the Decoding step where the input pixel is mapped to the saved index, filling zeros everywhere else.

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
