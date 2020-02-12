> * 原文地址：[Image Inpainting: Humans vs. AI](https://towardsdatascience.com/image-inpainting-humans-vs-ai-48fc4bca7ecc)
> * 原文作者：[Mikhail Erofeev](https://medium.com/@mikhail_26901)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/image-inpainting-humans-vs-ai.md](https://github.com/xitu/gold-miner/blob/master/TODO1/image-inpainting-humans-vs-ai.md)
> * 译者：[Starry](https://github.com/Starry316)
> * 校对者：[lsvih](https://github.com/lsvih), [Amberlin1970](https://github.com/Amberlin1970) 

# 图像修复：人类和 AI 的对决

![](https://cdn-images-1.medium.com/max/6000/1*HQxitL28dDEKe1dPp9wdmQ.png)

在许多任务中，深度学习方法优于相应的传统方法，能够取得与人类专家相近甚至是更好的结果。比如说 GoogleNet 在 ImageNet 基准上的表现超过了人类([Dodge and Karam 2017](https://arxiv.org/abs/1705.02498))。这篇文章中，我们对专业艺术家和计算机算法（包括最近基于深度神经网络的方法，或者叫 DNN）进行比较，看看哪一方能够在图像修复上取得更好的结果。

## 图像修复是什么？

图像修复是对一幅图像丢失部分的重构过程，使得观察者察觉不到这些区域曾被修复。这种技术通常用于移除图像中多余的元素，或者是修复老照片中损坏的部分。下面的图片展示了图像修复结果的例子。

图像修复是一门古老的艺术，最初需要人类艺术家手工作业。但如今，研究人员提出了许多自动修复方法。大多数自动修复方法除了图像本身外，还需要输入一个掩码（mask）来表示需要修复的区域。接下来，我们将对九个自动修复方法和专业艺术家对图像修复的结果进行比较。

![图像修复例子：移除一个物体。 （图片来自 [Bertalmío et al., 2000](https://conservancy.umn.edu/bitstream/handle/11299/3365/1/1655.pdf)）](https://cdn-images-1.medium.com/max/2152/1*EOuFiCNYdNde05bi9UmB8A.jpeg)

![图像修复例子：修复一张老旧、损坏的照片。（图片来自 [Bertalmío et al., 2000.](https://conservancy.umn.edu/bitstream/handle/11299/3365/1/1655.pdf)）](https://cdn-images-1.medium.com/max/2412/1*_Ldd9jY-9xS2OEE6Z8FTfw.jpeg)

## 数据集

为了创建测试图片数据集，我们从一个私人照片集中截取了 33 个 512x512 像素的图像。然后将一个 180x180 像素的黑色正方形填充到每个图像片的中心。艺术家和自动方法的任务是，通过只改变黑色正方形中的像素，来恢复失真图像的原样。

我们使用一个私有，未公开的照片集来保证参与对比的艺术家们没有接触过原始图片。虽然不规则的掩码是现实世界图像修复的典型特征，但我们只能在图像中心使用正方形的掩码，因为它们是我们对比实验中一些 DNN 方法所唯一允许的掩码类型。

下面是我们数据集中图片的略缩图。

![图像修复测试集。](https://cdn-images-1.medium.com/max/3188/1*_sOFyA9XY3ATpW4aGdnTtA.png)

## 自动修复方法

我们在测试数据集应用了如下六种基于神经网络的图像修复方法：

1. Deep Image Prior ([Ulyanov, Vedaldi, and Lempitsky, 2017](https://arxiv.org/abs/1711.10925))
2. Globally and Locally Consistent Image Completion ([Iizuka, Simo-Serra, and Ishikawa, 2017](http://hi.cs.waseda.ac.jp/~iizuka/projects/completion/en/))
3. High-Resolution Image Inpainting ([Yang et al., 2017](https://arxiv.org/abs/1611.09969))
4. Shift-Net ([Yan et al., 2018](https://arxiv.org/abs/1801.09392))
5. Generative Image Inpainting With Contextual Attention ([Yu et al., 2018](https://arxiv.org/abs/1801.07892)) — this method appears twice in our results because we tested two versions, each trained on a different data set (ImageNet and Places2)
6. Image Inpainting for Irregular Holes Using Partial Convolutions ([Liu et al., 2018](https://arxiv.org/abs/1804.07723))

我们测试了三个在人们对深度学习的兴趣爆发前提出的修复方法（非神经网络方法）作为（对比的）基准：

1. Exemplar-Based Image Inpainting ([Criminisi, Pérez, and Toyama, 2004](http://www.irisa.fr/vista/Papers/2004_ip_criminisi.pdf))
2. Statistics of Patch Offsets for Image Completion ([He and Sun, 2012](http://kaiminghe.com/eccv12/index.html))
3. Content-Aware Fill in Adobe Photoshop CS5

## 专业艺术家

我们请了三位从事图像后期调整和修复的专业艺术家，让他们修复从我们的数据库中随机选取的三张图片。为了激励他们得到尽可能好的结果。我们跟他们说，如果他或她的作品比竞争对手好，我们会给酬金增加 50% 作为奖励。尽管我们没有给定严格的时间限制，但所有艺术家都在 90 分钟左右的时间内完成了任务。

下面是结果：

![](https://cdn-images-1.medium.com/max/2000/1*tDhUKacPIfjkfdC24tXd_Q.png)

## 人类 vs. 算法

我们使用[Subjectify.us](http://www.subjectify.us)平台将三个专业艺术家和自动图像修复方法的结果与原始、未失真的图像（即真值（ground truth））进行对比。这个平台将结果以两两配对的方式呈现给研究参与者，让他们在每一对图片中选出一个视觉质量更好的。为了保证参与者做出的是思考后的选择，平台还会让他们在真值图片和图像修复范例结果之间进行选择来验证。 如果应答者没有在一个或两个验证问题中选择出正确答案，平台会将他的所有答案抛弃。最终，平台一共收集到了来自 215 名参与者的 6945 个成对判断。

下面是这次比较的总体和每幅图像的主观质量分数：

![Subjective-comparison results for images inpainted by professional artists and by automatic methods.](https://cdn-images-1.medium.com/max/2852/1*vQFC5lH3mGjAMJyTosgSjw.png)

 **“Overall”** 图表表明，所有艺术家的表现都比自动方法好上一大截。只有在一个例子下，一个算法击败了一名艺术家： **Statistics of Patch Offsets** (He and Sun, 2012) 对 **“Urban Flowers”** 图片的修复，得分高过了 **Artist #1** 绘制的图片。还有，只有艺术家修复的图片能够媲美甚至比原图更好：**Artist #2** 和 **#3** 修复的 **“Splashing Sea”** 图片得到了比真值更高的质量分数，**Artist #3** 修复的 **“Urban Flowers”** 得分只比真值低一点点。

在自动方法中获得第一名的是深度学习方法 Generative Image Inpainting。但这并不是压倒性的胜利，因为在我们的研究中，这个算法从来没有在任何图片中取得最高分数。对于 **“Urban Flowers”** 和 **“Splashing Sea”** 第一名分别是非神经网络方法的 **Statistics of Patch Offsets** 和 **Exemplar-Based Inpainting**，而 **“Forest Trail”** 的第一名是深度学习方法 **Partial Convolutions**。值得注意的是，根据总体的排行榜来看，其它的深度学习方法都被非神经网络方法超越。

## 一些有趣的例子

一些结果引起了我们的注意。非神经网络的方法 **Statistics of Patch Offsets** (He and Sun, 2012) 生成的图片比起艺术家修复的图片更受到参与比较者的青睐：

![](https://cdn-images-1.medium.com/max/2000/1*3dDa-RRW6QhZwiFVIrlnfg.png)

此外，高排名的神经网络方法 **Generative Image Inpainting** 得到的图像，获得了比非神经网络方法 **Statistics of Patch Offsets** 更低的分数：

![](https://cdn-images-1.medium.com/max/2000/1*aVpvEogJotWTi2F1YjfJvg.png)

另一个令人惊讶的结果是，2018 年提出的神经网络方法 **Generative Image Inpainting**，得分比 14 年前提出的非神经网络方法（**Exemplar-Based Image Inpainting**）还低：

![](https://cdn-images-1.medium.com/max/2000/1*UFvv4H_C1j-F3pVSi5aPlw.png)

## 算法之间的比较

为了深入比较神经网络方法和非神经网络方法，我们使用 Subjectify.us 进行了一次额外的主观比较。与第一次比较不同，我们使用完整的 33 张图片数据集对这些方法进行比较。

下面是从 147 名研究参与者给出的 3,969 个成对判断中得到总体主观分数。

![自动图像修复方法的主观比较。](https://cdn-images-1.medium.com/max/2358/1*sfhG6AFZ546S6z51aEmuhg.png)

这些结果证实了我们从其他比较中得到的观测结果。第一名（在真值之后）是在 the Places2 数据集上训练的 **Generative Image Inpainting**。没有使用神经网络的 **Content-Aware Fill Tool in Photoshop CS5** 以很小的差别位居第二名。在 ImageNet 上训练的 **Generative Image Inpainting** 获得第三名。值得注意的是，其他所有的非神经网络方法的表现都超过了深度学习方法。

## 结论

我们从自动图像修复方法与专业艺术家的对比研究中得到如下结论：

1. 艺术家的图像修复仍然是取得接近真值质量的唯一方法.
2. 只有在特定的图像上，自动图像修复方法的结果才能和人类艺术家相媲美。
3. 尽管在这些自动方法中一个深度学习算法取得了第一名，但非神经网络算法仍然处在一个强有力的位置，并且在众多测试的表现超过了深度学习方法。
4. 非深度学习方法和专业艺术家（废话）可以修复任意形状的区域，而大部分基于神经网络的却受到掩码形状的严格限制。这个约束使得这些方法在现实世界中的适用性变窄了。我们因此突出强调 **Image Inpainting for Irregular Holes Using Partial Convolutions** 这一深度学习方法上，它的开发人员关注于支持任意形状的掩码。

我们相信未来这一领域的研究，以及 GPU 算力和 RAM 容量的增长，将会使得深度学习算法胜过它们的传统竞争者，得到和人类艺术家相媲美的图像修复结果。然而我们强调，在目前最新的技术下，选择一个传统的图像或视频处理方法，也许会比盲目地只是因为新，而选择一个新的深度学习方法更好。

## 福利

我们已将实验中收集的图片和主观分数进行了分享，因此你可以自己分析这些数据。

* [实验对比中的图像](https://github.com/merofeev/image_inpainting_humans_vs_ai)
* [主观分数（包含每幅图片的分数）](http://erofeev.pw/image_inpainting_humans_vs_ai/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
