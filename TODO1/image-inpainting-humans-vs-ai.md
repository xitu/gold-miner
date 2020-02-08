> * 原文地址：[Image Inpainting: Humans vs. AI](https://towardsdatascience.com/image-inpainting-humans-vs-ai-48fc4bca7ecc)
> * 原文作者：[Mikhail Erofeev](https://medium.com/@mikhail_26901)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/image-inpainting-humans-vs-ai.md](https://github.com/xitu/gold-miner/blob/master/TODO1/image-inpainting-humans-vs-ai.md)
> * 译者：
> * 校对者：

# Image Inpainting: Humans vs. AI

![](https://cdn-images-1.medium.com/max/6000/1*HQxitL28dDEKe1dPp9wdmQ.png)

Deep learning has had mind-blowing success in computer vision and image processing over the past few years. For many tasks, deep-learning methods have outperformed their handcrafted competitors in delivering similar or even better results than human experts. For example, GoogleNet’s performance on the ImageNet benchmark exceeds human performance ([Dodge and Karam 2017](https://arxiv.org/abs/1705.02498)). In this post, we compare professional artists and computer algorithms (including recent approaches based on deep neural networks, or DNNs) to determine which can produce better image-inpainting results.

## What Is Image Inpainting?

Image inpainting is the process of reconstructing missing parts of an image so that observers are unable to tell that these regions have undergone restoration. This technique is often used to remove unwanted objects from an image or to restore damaged portions of old photos. The figures below show example image-inpainting results.

Image inpainting is an ancient art that originally required human artists to do the work by hand. But today, researchers have proposed numerous automatic inpainting methods. In addition to the image, most of these methods also require as input a mask showing the regions that require inpainting. Here, we compare nine automatic inpainting methods with results from professional artists.

![Image-inpainting example: removing an object. (Image from [Bertalmío et al., 2000](https://conservancy.umn.edu/bitstream/handle/11299/3365/1/1655.pdf).)](https://cdn-images-1.medium.com/max/2152/1*EOuFiCNYdNde05bi9UmB8A.jpeg)

![Image-inpainting example: restoring an old, damaged picture. (Image from [Bertalmío et al., 2000.](https://conservancy.umn.edu/bitstream/handle/11299/3365/1/1655.pdf))](https://cdn-images-1.medium.com/max/2412/1*_Ldd9jY-9xS2OEE6Z8FTfw.jpeg)

## Data Set

To create a set of test images, we cut thirty-three 512×512-pixel patches out of photos from a private collection. We then filled a 180×180-pixel square at the center of each patch with black. The task for both the artists and the automatic methods was to restore a natural look to the distorted image by changing only the pixels in the black square.

We used a private, unpublished photo collection to ensure that the artists in our comparison had no access to the original images. Although irregular masks are typical in real-world inpainting, we stuck with square masks at the center of the image, since they’re the only type that some DNN methods in our comparison allow.

Below are thumbnails of the images in our data set.

![Image-inpainting test set.](https://cdn-images-1.medium.com/max/3188/1*_sOFyA9XY3ATpW4aGdnTtA.png)

## Automatic Inpainting Methods

We applied to our test data set six inpainting methods based on neural networks:

1. Deep Image Prior ([Ulyanov, Vedaldi, and Lempitsky, 2017](https://arxiv.org/abs/1711.10925))
2. Globally and Locally Consistent Image Completion ([Iizuka, Simo-Serra, and Ishikawa, 2017](http://hi.cs.waseda.ac.jp/~iizuka/projects/completion/en/))
3. High-Resolution Image Inpainting ([Yang et al., 2017](https://arxiv.org/abs/1611.09969))
4. Shift-Net ([Yan et al., 2018](https://arxiv.org/abs/1801.09392))
5. Generative Image Inpainting With Contextual Attention ([Yu et al., 2018](https://arxiv.org/abs/1801.07892)) — this method appears twice in our results because we tested two versions, each trained on a different data set (ImageNet and Places2)
6. Image Inpainting for Irregular Holes Using Partial Convolutions ([Liu et al., 2018](https://arxiv.org/abs/1804.07723))

As a baseline, we tested three inpainting methods proposed before the explosion of interest in deep learning:

1. Exemplar-Based Image Inpainting ([Criminisi, Pérez, and Toyama, 2004](http://www.irisa.fr/vista/Papers/2004_ip_criminisi.pdf))
2. Statistics of Patch Offsets for Image Completion ([He and Sun, 2012](http://kaiminghe.com/eccv12/index.html))
3. Content-Aware Fill in Adobe Photoshop CS5

## Professional Artists

We hired three professional artists who do photo retouching and restoration and asked each of them to inpaint three images randomly selected from our data set. To encourage them to produce the best possible results, we also told each artist that if his or her works outranked the competitors, we would add a 50% bonus to the honorarium. Although we imposed no strict time limit, the artists all completed their assignments in about 90 minutes.

Below are results:

![](https://cdn-images-1.medium.com/max/2000/1*tDhUKacPIfjkfdC24tXd_Q.png)

## Humans vs. Algorithms

We compared the inpainting results from the three professional artists and the results from the automatic inpainting methods against the original, undistorted images (i.e., ground truth) using the [Subjectify.us](http://www.subjectify.us) platform. This platform presented the results to study participants in a pairwise fashion, asking them to choose from each pair the image with the best visual quality. To ensure that participants make thoughtful selections, the platform also conducts verification by asking them to compare the ground truth image and the result of Exemplar-Based Image Inpainting. It discarded all answers from respondents who failed to correctly answer one or both of the verification questions. In total, the platform collected 6,945 pairwise judgments from 215 participants.

Below are the overall and per-image subjective quality scores for this comparison:

![Subjective-comparison results for images inpainted by professional artists and by automatic methods.](https://cdn-images-1.medium.com/max/2852/1*vQFC5lH3mGjAMJyTosgSjw.png)

As the **“Overall”** plot illustrates, the artists all outperform the automatic methods by a large margin. In only one case did an algorithm beat an artist: the **“Urban Flowers”** image inpainted by the non-neural method **Statistics of Patch Offsets** (He and Sun, 2012) received a higher ranking than the image drawn by **Artist #1**. Moreover, only images inpainted by the artists are on a par with or look even better than the original undistorted images: the **“Splashing Sea”** images inpainted by **Artist #2** and **#3** garnered a higher quality score than ground truth, and the **“Urban Flowers”** image inpainted by **Artist #3** garnered a score just slightly lower than ground truth.

First place among the automatic approaches went to the deep-learning method Generative Image Inpainting. But it wasn’t a landslide victory, since this algorithm never achieved the best score for any image in our study. First place for **“Urban Flowers”** and **“Splashing Sea”** went to the non-neural methods **Statistics of Patch Offsets** and **Exemplar-Based Inpainting**, respectively, and first place for **“Forest Trail”** went to the deep-learning method **Partial Convolutions**. Notably, according to the overall leaderboard, the other deep-learning methods were outperformed by non-neural ones.

## Interesting Examples

Several results caught our attention. The non-neural method **Statistics of Patch Offsets** (He and Sun, 2012) produced an image that the comparison participants generally preferred over an artist-drawn image:

![](https://cdn-images-1.medium.com/max/2000/1*3dDa-RRW6QhZwiFVIrlnfg.png)

In addition, the image from the top-ranked neural method, **Generative Image Inpainting**, earned a lower score than the non-neural method **Statistics of Patch Offsets**:

![](https://cdn-images-1.medium.com/max/2000/1*aVpvEogJotWTi2F1YjfJvg.png)

Another surprising result is that the neural method **Generative Image Inpainting**, which was proposed in 2018, scored lower than a non-neural method proposed 14 years ago (**Exemplar-Based Image Inpainting**):

![](https://cdn-images-1.medium.com/max/2000/1*UFvv4H_C1j-F3pVSi5aPlw.png)

## Algorithms vs. Algorithms

To further compare neural image-inpainting methods with non-neural ones, we performed an additional subjective comparison using Subjectify.us. Unlike the first comparison, we compared these methods using the entire 33-image data set.

Below are the overall subjective scores computed using 3,969 pairwise judgments from 147 study participants.

![Subjective comparison of automatic image-inpainting methods.](https://cdn-images-1.medium.com/max/2358/1*sfhG6AFZ546S6z51aEmuhg.png)

These results confirm our observations from our other comparison. First place (after ground truth) went to **Generative Image Inpainting** trained on the Places2 data set. The **Content-Aware Fill Tool in Photoshop CS5**, which doesn’t use neural networks, was just slightly behind first place. **Generative Image Inpainting** trained on ImageNet took third place. Notably, all other deep-learning approaches were outperformed by non-neural ones.

## Conclusion

Our study of automatic image-inpainting methods versus professional artists allows us to draw the following conclusions:

1. Inpainting by artists remains the only way to achieve quality similar to that of ground truth.
2. The results of automatic inpainting methods can be on a par with those of human artists only for certain images.
3. Although first place among the automatic methods went to a deep-learning algorithm, non-neural algorithms maintain a strong position and outperformed the deep-learning alternatives on numerous tests.
4. While non-deep-learning methods and professional artists (of course) can inpaint regions of arbitrary shape, most neural-based methods impose strict limitations on the mask shape. This constraint further narrows the real-world applicability of these methods. We therefore highlight the deep-learning method **Image Inpainting for Irregular Holes Using Partial Convolutions**, whose developers focused on supporting arbitrary masks.

We believe future research in this field as well as the growth in GPU computational power and RAM size will allow deep-learning algorithms to outperform their conventional competitors and deliver image-inpainting results on a par with those of human artists. Nevertheless, we emphasize that given the state of the art, choosing a classic image- or video-processing method may be better than blindly choosing a new deep-learning approach just because it’s the latest thing.

## Bonus

We have shared all images and subjective scores collected during the experiment, so you can do your own analysis of this data.

* [Images used in the comparison](https://github.com/merofeev/image_inpainting_humans_vs_ai)
* [Subjective scores (including per-image scores)](http://erofeev.pw/image_inpainting_humans_vs_ai/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
