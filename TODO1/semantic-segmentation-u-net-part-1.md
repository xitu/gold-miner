> * 原文地址：[Semantic Segmentation — U-Net (Part 1)](https://medium.com/@keremturgutlu/semantic-segmentation-u-net-part-1-d8d6f6005066)
> * 原文作者：[Kerem Turgutlu](https://medium.com/@keremturgutlu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/semantic-segmentation-u-net-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/semantic-segmentation-u-net-part-1.md)
> * 译者：
> * 校对者：

# Semantic Segmentation — U-Net (Part 1)

_Here again writing to my 6 months ago self…_

In this post I will mainly be focusing on semantic segmentation, a pixel-wise classification task and a particular algorithm for it. I will be providing a walk-through on some of the cases I had and have been working on lately.

By definition, semantic segmentation is the partition of an image into coherent parts. For example classifying each pixel that belongs to a person, a car, a tree or any other entity in our dataset.

**Semantic Segmentation vs. Instance Segmentation**

Semantic segmentation is relatively easier compared to it’s big brother, instance segmentation.

In instance segmentation, our goal is to not only make pixel-wise predictions for every person, car or tree but also to identify each entity separately as person 1, person 2, tree 1, tree 2, car 1, car 2, car 3 and so on. Current state of the art algorithm for instance segmentation is Mask-RCNN: a two-stage approach with multiple sub-networks working together: RPN (Region Proposal Network), FPN (Feature Pyramid Network) and FCN (Fully Convolutional Network) [5, 6, 7, 8].

![](https://cdn-images-1.medium.com/max/800/1*pKKYS17lOwPsreUVTak37g.png)

Fig 4. Semantic Segmentation

![](https://cdn-images-1.medium.com/max/800/1*C90jdvqH1-Kc67wEYwtFLQ.png)

Fig 5. Instance Segmentation

### Case Study: Data Science Bowl 2018

Data Science Bowl 2018 just ended and I’ve learned a lot from it. Maybe the most important lesson I learned was, even with deep learning, a more automated technique compared to traditional ML, pre and post processing might be crucial to get good results. Those are important skills for a practitioner to obtain and they define the way you structure and model the problem.

I will not go through every little detail and explanation about this particular competition since there is great amount of discussion and explanation on both the task itself and the methods used throughout the competition [here](https://www.kaggle.com/c/data-science-bowl-2018/discussion/54741) . But I will briefly mention the winning solution as it is related to the foundations of this post. [13]

Data Science Bowl 2018 just like other Data Science Bowls in the past was organized by Booz Allen Foundation. This year’s task was to identify nuclei of cells in a given microscopy image and to provide masks for each nucleus independently.

Now, take a moment or two to guess which type of segmentation this task demands; semantic or instance ?

Here is a sample masked image and it’s raw microscopy image.

![](https://cdn-images-1.medium.com/max/800/1*Lj9cyAXoTtOnB_nM5fwMyw.png)

Fig 6. Masked Nuclei (left) and Original Image (right)

Even though it may sound like a semantic segmentation task at first, the task here is instance segmentation. We need to treat each nucleus in the image independently and identify them as nuclei 1, nuclei 2, nuclei 3, … similar to the example we had for car 1, car 2, person 1 and so on. Perhaps the motivation for this task is to track the sizes, the counts and the characteristics of nuclei from a cell sample over time. It is very important to automate this tracking process and further speed up the experimentation of running on different treatments for curing various diseases.

Now, you may think that if this article is about semantic segmentation and if Data Science Bowl 2018 is an example of instance segmentation task, then why am I keep talking about this particular competition. If you are thinking about this, then you are definitely right and indeed the end goal for this competition was not an example for semantic segmentation. But as we will keep going you will see how you can actually turn this instance segmentation problem into a multiclass semantic segmentation task. This was the approach that I’ve tried but failed in practice but also turned out to be the high level motivation for the winning solution too.

During this 3 months of period of the competition there were only two models (or variants of them) which were shared or at least explicitly discussed throughout the forums; Mask-RCNN and U-Net. As I’ve mentioned earlier Mask-RCNN is the state-of-the-art algorithm for object detection which detects individual objects and predicts their masks, as in instance segmentation. Mask-RCNN’s implementation and training is harder since it employs a two-stage learning approach, where you first optimize for an RPN (Region Proposal Network) and then predict bounding boxes, classes and masks simultaneously.

On the other hand U-Net is a very popular end-to-end encoder-decoder network for semantic segmentation [9]. It was originally invented and first used for biomedical image segmentation, a very similar task we had for Data Science Bowl. There was no silver bullet in the competition, and none of these two architectures alone without post or pre-processing or any minor tweaks in architectural design proved to have a top score. I didn’t have the chance to try Mask-RCNN for this competition, so I kept my experiments around U-Net and learned a lot about it.

Also, since our topic is semantic segmentation I will leave Mask-RCNN to other blog posts out there to explain. But if you still insist to try them in your own CV applications, here are two popular github repositories with implementations in [Tensorflow](https://github.com/matterport/Mask_RCNN) and [PyTorch](https://github.com/multimodallearning/pytorch-mask-rcnn). [10, 11]

Now, we may continue with U-Net and dive deeper into it’s details...

Here is the architecture for start:

![](https://cdn-images-1.medium.com/max/800/1*dKPBgCdJx6zj3MpED3lcNA.png)

Fig 7. Vanilla U-Net

For those who are familiar with traditional convolutional neural networks first part (denoted as DOWN) of the architecture will be familiar. This first part is called down or you may think it as the encoder part where you apply convolution blocks followed by a maxpool downsampling to encode the input image into feature representations at multiple different levels.

The second part of the network consists of upsample and concatenation followed by regular convolution operations. Upsampling in CNNs may be a new concept to some of the readers but the idea is fairly simple: we are expanding the feature dimensions to meet the same size with the corresponding concatenation blocks from the left. You may see the gray and green arrows, where we concatenate two feature maps together. The main contribution of U-Net in this sense compared to other fully convolutional segmentation networks is that while upsampling and going deeper in the network we are concatenating the higher resolution features from down part with the upsampled features in order to better localize and learn representations with following convolutions. Since upsampling is a sparse operation we need a good prior from earlier stages to better represent the localization. Similar idea of combining matching levels is also seen in FPNs (Feature Pyramidal Networks). [7]

![](https://cdn-images-1.medium.com/max/800/1*Y5CRI3eoVsjf570nkWEcDg.png)

Fig 7. Vanilla U-Net Tensor Annotation

We can define one block of operations in down part as convolutions→ downsampling.

```
# a sample down block
def make_conv_bn_relu(in_channels, out_channels, kernel_size=3, stride=1, padding=1):
    return [
        nn.Conv2d(in_channels, out_channels, kernel_size=kernel_size,  stride=stride, padding=padding, bias=False),
        nn.BatchNorm2d(out_channels),
        nn.ReLU(inplace=True)
    ]
self.down1 = nn.Sequential(
    *make_conv_bn_relu(in_channels, 64, kernel_size=3, stride=1, padding=1 ),
    *make_conv_bn_relu(64, 64, kernel_size=3, stride=1, padding=1 ),
)

# convolutions followed by a maxpool
down1 = self.down1(x)
out1   = F.max_pool2d(down1, kernel_size=2, stride=2)
```

U-Net sample down block

Similarly we can define one block of operations in up part as upsampling → concatenation →convolutions.

```
# a sample up block
def make_conv_bn_relu(in_channels, out_channels, kernel_size=3, stride=1, padding=1):
    return [
        nn.Conv2d(in_channels, out_channels, kernel_size=kernel_size,  stride=stride, padding=padding, bias=False),
        nn.BatchNorm2d(out_channels),
        nn.ReLU(inplace=True)
    ]
self.up4 = nn.Sequential(
    *make_conv_bn_relu(128,64, kernel_size=3, stride=1, padding=1 ),
    *make_conv_bn_relu(64,64, kernel_size=3, stride=1, padding=1 )
)
self.final_conv = nn.Conv2d(32, num_classes, kernel_size=1, stride=1, padding=0 )

# upsample out_last, concatenate with down1 and apply conv operations
out   = F.upsample(out_last, scale_factor=2, mode='bilinear')  
out   = torch.cat([down1, out], 1)
out   = self.up4(out)

# final 1x1 conv for predictions
final_out = self.final_conv(out)
```

U-Net sample up block

By inspecting the figure more carefully, you may notice that output dimensions (388 x 388) are not same as the original input (572 x 572). If you want to get consistent size, you may apply padded convolutions to keep the dimensions consistent across concatenation levels just like we did in the sample code above.

When such upsampling is mentioned you may come across to either one of the following terms: transposed convolution, upconvolution, deconvolution or upsamling. Many people including myself and PyTorch documentations don’t like the term deconvolution, since during upsampling stage we are actually doing regular convolution operations and there is nothing de- about it. Before going any further if you are unfamiliar with basic convolution operations and their arithmetic I highly recommend visiting [here](https://github.com/vdumoulin/conv_arithmetic/blob/master/README.md). [12]

I will be explaining upsampling methods from simplest to more complex. Here are three ways of upsampling a 2D tensor in PyTorch:

**Nearest Neighbor**

This is the simplest way of finding the values of missing pixels when resizing (translating) a tensor into a larger tensor, e.g. 2x2 to 4x4, 5x5 or 6x6.

Let’s implement this basic computer vision algorithm step by step using Numpy:

```
def nn_interpolate(A, new_size):
    """
    Nearest Neighbor Interpolation, Step by Step
    """
    # get sizes
    old_size = A.shape
    
    # calculate row and column ratios
    row_ratio, col_ratio = new_size[0]/old_size[0], new_size[1]/old_size[1]
    
    # define new pixel row position i
    new_row_positions = np.array(range(new_size[0]))+1
    new_col_positions = np.array(range(new_size[1]))+1
    
    # normalize new row and col positions by ratios
    new_row_positions = new_row_positions / row_ratio
    new_col_positions = new_col_positions / col_ratio
    
    # apply ceil to normalized new row and col positions
    new_row_positions = np.ceil(new_row_positions)
    new_col_positions = np.ceil(new_col_positions)
    
    # find how many times to repeat each element
    row_repeats = np.array(list(Counter(new_row_positions).values()))
    col_repeats = np.array(list(Counter(new_col_positions).values()))
    
    # perform column-wise interpolation on the columns of the matrix
    row_matrix = np.dstack([np.repeat(A[:, i], row_repeats) 
                            for i in range(old_size[1])])[0]
    
    # perform column-wise interpolation on the columns of the matrix
    nrow, ncol = row_matrix.shape
    final_matrix = np.stack([np.repeat(row_matrix[i, :], col_repeats)
                             for i in range(nrow)])

    return final_matrix
    
    
def nn_interpolate(A, new_size):
    """Vectorized Nearest Neighbor Interpolation"""

    old_size = A.shape
    row_ratio, col_ratio = np.array(new_size)/np.array(old_size)

    # row wise interpolation 
    row_idx = (np.ceil(range(1, 1 + int(old_size[0]*row_ratio))/row_ratio) - 1).astype(int)

    # column wise interpolation
    col_idx = (np.ceil(range(1, 1 + int(old_size[1]*col_ratio))/col_ratio) - 1).astype(int)

    final_matrix = A[:, row_idx][col_idx, :]

    return final_matrix
```

![](https://cdn-images-1.medium.com/max/800/1*IiEfK4NbvGrhWA7Nlsm7fg.png)

**[PyTorch]** F.upsample(…, mode = “nearest”)

```
>>> input = torch.arange(1, 5).view(1, 1, 2, 2)
>>> input

(0 ,0 ,.,.) =
  1  2
  3  4
[torch.FloatTensor of size (1,1,2,2)]

>>> m = nn.Upsample(scale_factor=2, mode='nearest')
>>> m(input)

(0 ,0 ,.,.) =
  1  1  2  2
  1  1  2  2
  3  3  4  4
  3  3  4  4
[torch.FloatTensor of size (1,1,4,4)]
```

**Bilinear Interpolation**

Bilinear Interpolation Algorithm is less computationally efficient than nearest neighbor but it’s a more precise approximation. A single pixel value is calculated as the weighted average of all other values based on distances.

**[PyTorch]** F.upsample(…, mode = “bilinear”)

```
>>> input = torch.arange(1, 5).view(1, 1, 2, 2)
>>> input

(0 ,0 ,.,.) =
  1  2
  3  4
[torch.FloatTensor of size (1,1,2,2)]
>>> m = nn.Upsample(scale_factor=2, mode='bilinear')
>>> m(input)

(0 ,0 ,.,.) =
  1.0000  1.2500  1.7500  2.0000
  1.5000  1.7500  2.2500  2.5000
  2.5000  2.7500  3.2500  3.5000
  3.0000  3.2500  3.7500  4.0000
[torch.FloatTensor of size (1,1,4,4)]
```

**Transposed Convolution**

In transposed convolutions we have weights that we learn through back-propagation. In papers I’ve come across all of these upsampling methods for various cases and also in practice you may change your architecture and try all of them to see which works best for your own problem. I personally prefer transposed convolutions since we have more control over it but you may go for bilinear interpolation or nearest neighbor for simplicity as well.

**[PyTorch]** nn.ConvTranspose2D(…, stride=…, padding=…)

![](https://cdn-images-1.medium.com/max/800/1*-u7Cj5jpGUbWkdpT1Y-1Sg.png)

Fig 8. Examples for transposed convolution operation with different parameters. Credit goes to [https://github.com/vdumoulin/conv_arithmetic](https://github.com/vdumoulin/conv_arithmetic) [12]

If we go back to our original case, Data Science Bowl, the main drawback of using a vanilla U-Net approach in the competition was the overlapping nuclei. As it’s seen in the image above if you create a binary mask and use it as your target, U-Net will surely predict something similar to this and you will have a combined mask for several nuclei which are overlapping or lie very close to each other.

![](https://cdn-images-1.medium.com/max/800/1*ePiNH-RIVPaxNXH1WgFYVw.png)

Fig 9. Overlapping nuclei mask

Referring to overlapping instances problem, authors of U-Net paper used weighted cross entropy to emphasize learning the borders of cells. This method helped them to separate overlapping instances. Basic idea is to weight borders more and to push network towards learning gaps between close instances.[9]

![](https://cdn-images-1.medium.com/max/800/1*3dp84O3KCVCr1AsJt-QZWQ.png)

Fig 10. Weight map

![](https://cdn-images-1.medium.com/max/800/1*LPbooZuQG_IA0vmbxv96Eg.png)

Fig 11. (a) Raw image (b) ground truth different color for each instance (c) generated segmentation mask (d) pixel-wise weight map

Another solution to this kind of problem, an approach that was used by many competitors including the winning solution, is to convert binary masks into a multiclass target. The nice thing about U-Net is that you can structure your network to output as many channels as you want and represent any class in any channel by using 1x1 convolution at the final layer.

Quoting from the Data Science Bowl winning solution:

> 2 channels masks for networks with sigmoid activation i.e. (mask — border, border) or 3 channels masks for networks with softmax activation i.e. (mask — border, border , 1 — mask — border)

> 2 channels full masks i.e. (mask, border)

After making these predictions classical image processing algorithms like watershed can be used for post-processing to further segment individual nuclei. [14]

![](https://cdn-images-1.medium.com/max/800/1*DIbLJC1xv_ypx3QFwfXmag.png)

Fig 12. For visual purposes foreground (green) contour (yellow) background (dark) classes

This was the first official computer vision competition that I’ve had the courage to participate in Kaggle and it was a Data Science Bowl. Even though I’ve completed the competition only in top 20% (which is considered as an average score) I felt the pleasure of participating in a Data Science Bowl and learning the things that I could have never learn if I wasn’t actually participating and trying on my own. Active learning is far more fruitful than watching or reading about similar approaches from online sources.

As a deep learning practitioner who just started practicing months back with Fast.ai this was an important step for me towards my never ending journey and it was very valuable in terms of gaining experience. So, for those who feel intimated by challenges that you’ve never seen or solved before I highly recommend you to specifically go after these type of challenges in order to feel the great pleasure of learning something that you didn’t know before.

Another valuable lesson I’ve learned in this competition was that, in a computer vision (this applies to NLP too) competition it’s very important to check every single prediction by eye to see what’s working and what’s not. If your data is small enough you should go and check each and every individual output for sure. This will allow you to further come up with better ideas or even debug your code if something is wrong with it.

### **Transfer Learning and Beyond**

So far we’ve defined the building blocks of vanilla U-Net and mentioned how we can manipulate targets to solve for instance segmentation. Now we can further discuss the flexibility of these type of encoder-decoder networks. By flexibility I mean the freedom you have over it and the creativity you can put on it’s design.

Anyone who practices deep learning at some point come across to transfer learning because it’s a very powerful idea. In short transfer learning is the concept of using a pretrained network which was trained on many samples for a similar task that we are facing but lacking the same amount of data. Even with enough data transfer learning can boost the performance up to some extent, not only for computer vision tasks but also for NLP too.

Transfer learning proved to be a powerful technique for U-Net like architectures as well. We’ve previously defined two major components of U-Net; down and up. Let’s rephrase these parts as encoder and decoder this time. Encoder part basically takes the input and encodes it in a low dimensional feature space which represents our input in a lower dimension. Now imagine replacing this encoder with your favorite ImageNet winner; VGG, ResNet, Inception, NasNet, … which ever you want. These networks are highly engineered to do one common thing: to encode a natural image in the best way possible to classify it and their pretrained weights on ImageNet are waiting for you to grab them online.

So why not use one of these architectures as our encoder and construct the decoder in a way that it will work the same way as the original U-Net, but better, on steroids.

TernausNet which is the winner architecture for [Kaggle Carvana](https://www.kaggle.com/c/carvana-image-masking-challenge) challenge uses the same transfer learning idea with VGG11 as it’s encoder. [15, 16]

![](https://cdn-images-1.medium.com/max/800/1*mqdUlED6AuhZGip7Ov1o-g.png)

TernausNet by Vladimir Iglovikov and Alexey Shvets

### Fast.ai: Dynamic U-Net

Inspired by TernausNet paper and by many other great resources, I wanted to generalize this idea of using pretrained or custom encoders for U-Net like architectures. So, I’ve came up with a general architecture: [**Dynamic Unet**](https://github.com/fastai/fastai/blob/master/fastai/models/unet.py).

Dynamic Unet is an implementation of this idea, it automatically creates the decoder part to any given encoder by doing all the calculations and matching for you. Encoder can either be a pretrained network off the shelf or any custom architecture you define yourself.

It is written in PyTorch and currently in Fast.ai library. You can refer to this [notebook](https://github.com/KeremTurgutlu/deeplearning/blob/master/datasciencebowl2018/FASTAI%20-%20DSBOWL%202018.ipynb) to see it in action or look at [source](https://github.com/fastai/fastai/blob/master/fastai/models/unet.py). The main goal of Dynamic Unet is to save practioners’ time and allow easier experimentation with different encoders with the least amount of code possible.

In part 2 I will be explaining 3D Encoder Decoder models for volumetric data, such as MRI scans and give real world examples that I’ve been working on.

**References**

[5] Faster R-CNN: Towards Real-Time Object Detection with Region Proposal Networks: [https://arxiv.org/abs/1506.01497](https://arxiv.org/abs/1506.01497)

[6] Mask R-CNN: [_https://arxiv.org/abs/1703.06870_](https://arxiv.org/abs/1703.06870)

[7] Feature Pyramid Networks for Object Detection: [_https://arxiv.org/abs/1612.03144_](https://arxiv.org/abs/1612.03144)

[8] Fully Convolutional Networks for Semantic Segmentation: [_https://people.eecs.berkeley.edu/~jonlong/long_shelhamer_fcn.pdf_](https://people.eecs.berkeley.edu/~jonlong/long_shelhamer_fcn.pdf)

[9] U-net: Convolutional Networks for Biomedical Image Segmentation: [_https://arxiv.org/abs/1505.04597_](https://arxiv.org/abs/1505.04597)

[10] Tensorflow Mask-RCNN: [_https://github.com/matterport/Mask_RCNN_](https://github.com/matterport/Mask_RCNN)

[11] Pytorch Mask-RCNN:  [_https://github.com/multimodallearning/pytorch-mask-rcnn_](https://github.com/multimodallearning/pytorch-mask-rcnn)

[12] Convolution Arithmetic: [_https://github.com/vdumoulin/conv_arithmetic_](https://github.com/vdumoulin/conv_arithmetic/blob/master/README.md)

[13] Data Science Bowl 2018 Winning Solution, ods-ai: [_https://www.kaggle.com/c/data-science-bowl-2018/discussion/54741_](https://www.kaggle.com/c/data-science-bowl-2018/discussion/54741)

[14] Watershed Algorithm [https://docs.opencv.org/3.3.1/d3/db4/tutorial_py_watershed.html](https://docs.opencv.org/3.3.1/d3/db4/tutorial_py_watershed.html)

[15] Carvana Image Masking Challenge: [https://www.kaggle.com/c/carvana-image-masking-challenge](https://www.kaggle.com/c/carvana-image-masking-challenge)

[16] TernausNet: U-Net with VGG11 Encoder Pre-Trained on ImageNet for Image Segmentation: [_https://arxiv.org/abs/1801.05746_](https://arxiv.org/abs/1801.05746)

Thanks to [Prince Grover](https://medium.com/@pgrover3?source=post_page) and [Serdar Ozsoy](https://medium.com/@serdarozsoy?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
