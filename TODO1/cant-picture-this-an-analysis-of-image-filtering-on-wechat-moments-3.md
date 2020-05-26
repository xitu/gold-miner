> * 原文地址：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://citizenlab.ca/2018/08/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments/)
> * 原文作者：[Jeffrey Knockel](https://citizenlab.ca/author/jknockel/), [Lotus Ruan](https://citizenlab.ca/author/lotus/), [Masashi Crete-Nishihata](https://citizenlab.ca/author/masashi/), and [Ron Deibert](https://citizenlab.ca/author/profd/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)
> * 译者：
> * 校对者：

# (CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3

> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-1.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md)

## Visual-based filtering

In the previous section we analyzed how WeChat filters images containing sensitive text. In this section we analyze the other mechanism we found that WeChat uses to filter images: a visual-based algorithm that can filter images that do not necessarily contain text. This algorithm works by comparing an image’s similarity to those on a list of blacklisted images. To test different hypotheses concerning how the filter operated, we performed modifications to sensitive images that were normally censored and observed which types of modifications evaded the filtering and which did not, allowing us to evaluate whether our hypotheses were consistent with our observed filtering.

Like with WeChat’s OCR-based filtering, we did not systematically measure how much time WeChat’s visual-based filtering required. However, we found that after uploading a filtered image that does not contain sensitive text, it would typically be visible to other users for only up to 10 seconds before it was filtered and removed from others’ views of the feed. This may be because they were either filtered before they were made visible or after they were visible but before we could refresh the feed to view them. Since this algorithm typically takes less time than the OCR-based one, this algorithm would appear to be less computationally expensive than the one used for OCR filtering.

### Grayscale conversion

We performed an analysis of their grayscale conversion algorithm similar to the one we performed when evaluating WeChat’s OCR filtering to determine which grayscale conversion algorithm, if any, the blacklist-based image filtering was using. Like when testing the OCR filtering algorithm, we designed experiments such that if the blacklisted image filtering algorithm uses the same grayscale algorithm that we used to determine the intensity of gray in the image, then the image effectively disappears to the algorithm and evades filtering.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f12-1-255x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f12-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f12-2-255x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f12-2.png) |

> Table 18: Left, the original sensitive image. Right, the image thresholded to black and white, which is still filtered.

We chose an image originally containing a small number of colours and that we verified would still be filtered after converting to black and white (see Table 18). We used the black and white image as a basis for our grayscale conversion tests, where for each image we would replace white pixels with the colour to test and black with that colour’s shade of gray according to the grayscale conversion algorithm we are testing (see Table 19). As before, we tested three different grayscale conversion algorithms: Average, Lightness, and Luminosity (see the section on OCR filtering for their definitions).

|    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-1-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-1.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-2-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-2.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-3-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-3.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-4-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-4.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-5-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-5.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f13-6-150x150.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f13-6.jpeg) |

> Table 19: Each of the six colours tested. Here the intensity of the gray background of each image was chosen according to the luminosity of the foreground colour.

![](https://i.loli.net/2018/08/15/5b744160327c4.png)

> Table 20: Results choosing the intensity of the gray background according to three different grayscale conversion algorithms for six different colours of text. Only when using the luminosity algorithm were no images were filtered.

We found that the results are largely consistent with those previously found when testing the OCR algorithm suggesting that both the OCR-based and the visual-based algorithms use the same grayscale conversion algorithm. In both cases, most images created according to the Average and Lightness algorithms were filtered, whereas all images created according to the Luminosity algorithms evaded filtering (see Table 20). This suggests that WeChat’s blacklisted image filtering, like their OCR-based image filter, converts images to grayscale and does so using the Luminosity formula.

### Cryptographic hashes

A simple way to compare whether two images are the same is by either hashing their encoded file contents or the values of their pixels using a cryptographic hash such as [MD5](https://en.wikipedia.org/wiki/MD5). While this makes image comparison very efficient, this method is not tolerant of even small changes in values to pixels, as cryptographic hashes are designed such that small changes to the hashed content result in large changes to the hash. This inflexibility is incompatible with the kinds of image modifications that we found the filter tolerant of throughout this report.

### Machine learning classification

We discussed in the OCR section about how machine learning methods, including neural networks and deep learning, can be used to identify the text in an image. In this case, the machine learning algorithms classify each character into a category, where the different categories might be _a_, _b_, _c_, …, _1_, _2_, _3_, …, as well as Chinese characters, punctuation, etc. However, machine learning can also be used to classify more general purposes images into high level categories based on their content such as “cat” or “dog.” For purposes of image filtering, many social media platforms use machine learning [to classify whether content is pornography](https://yahooeng.tumblr.com/post/151148689421/open-sourcing-a-deep-learning-solution-for).

If Tencent chose to use a machine learning classification approach, they could attempt to train a network to recognize whether an image may lead to government reprimands. However, training a network against such a nebulous and nuanced category would be rather difficult considering the vagueness and fluidity of Chinese content regulations. Instead, they might identify certain more well-defined categories of images that would be potentially sensitive, such as images of Falun Gong practitioners or of deceased Chinese dissident Liu Xiaobo, and then classify whether images belong to these sensitive categories.

|    |    |    |    |
| -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-4.png) |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-5.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-6-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-6.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f14-7-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f14-7.png) |

> Table 21: Tencent’s sample images for each of the seven categories its classifier detects.

Tencent advertises _YouTu_, an API developed by the company’s machine learning research team, for providing “artificial intelligence-backed [solution](https://youtu.qq.com/#/solution-safe) to online content review.” Tencent claims that the API is equipped with image recognition functions, including OCR and facial recognition technologies, and is able to detect user generated images that contain “pornographic, terrorist, political, and spammy content”. In the case of [terrorism-related images](https://youtu.qq.com/#/img-terror-identity), YouTu provides specific categories of what it considers sensitive: militants (武装分子), controlled knives and tools (管制刀具), guns (枪支), bloody scenes (血腥), fire (火灾), public congregations (人群聚集), and extremism and religious symbols or flags (极端主义和宗教标志、旗帜) (see Table 21). To test if WeChat uses this system, we tested the sample images that Tencent provided on their website advertising the API (see Table 22). We found none of them to be censored.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f15-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f15-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f15-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f15-2.png) |

> Table 22: Left, the original image of knives, which Tencent’s Cloud API classifies as “knives” with 98% confidence. Right, the mirrored image of knives, which the Cloud API classifies as “knives” with 99% confidence. Mirroring the image had virtually no effect on the Tencent classifier’s confidence of the image’s category and no effect on the ultimate classification.

After these results, we wanted to test more broadly as to whether they may be using any sort of machine learning classification system at all or whether they were maintaining a blacklist of specific sensitive images. To do this, we performed a test that would modify images that we knew to be filtered in a way that semantically preserved their content while nevertheless largely moving around their pixels. We decided to test _mirroring_ (i.e., horizontally flipping) images. First, as a control case, we submitted the mirrored images of each of the seven categories from Table 21. We found that, as we expected, mirroring the images did not affect what they were classified as by Tencent’s Cloud API (see Table 22 for an example).

|    |    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-5.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-6-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-6.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-7-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-7.png)|
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-8-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-8.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-9-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-9.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-10-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-10.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-11-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-11.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-12-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-12.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-13-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-13.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f16-14-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f16-14.png) |

> Table 23: The first 14 of the 15 images we tested mirroring.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f17-225x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f17.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f17-mirrored-225x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f17-mirrored.png) |

> Table 24: Left, the 15th image we tested, an image of Liu Xiaobo. Right, the mirrored image. Although the images technically have pixels in different positions, they both show a depiction of the deceased Liu Xiaobo, but only the original image on the left is filtered.

Next, we mirrored 15 images that we found to be filtered using data from [previous](https://citizenlab.ca/2017/04/we-cant-chat-709-crackdown-discussions-blocked-on-weibo-and-wechat/) [reports](https://citizenlab.ca/2017/07/analyzing-censorship-of-the-death-of-liu-xiaobo-on-wechat-and-weibo/) and other contextual knowledge. Upon uploading them to WeChat, we found that none of them were filtered after mirroring. Other semantic-preserving operations such as cropping the whitespace from the image in Table 24 also allowed the image to evade filtering. These results, as well as additional results described further below, strongly suggest that no sort of high level machine learning classification system is being used to trigger the observed filtering on WeChat. Rather, these results suggest that there is a specific blacklist of images being maintained by Tencent that each image uploaded is somehow being compared against using some kind of similarity metric. This type of approach may be desirable as it easily allows Tencent to censor specific sensitive images that may be trending or that they are otherwise asked to censor by a government official regardless of the topic or category of the image. Note that this does not rule out the use of machine learning methods all together. Rather, this rules out any sort of filtering based on high level image classification.

### Invariant features

There are different ways of describing images in a way that are invariant to certain transformations such as translation (_e.g._, moving the position of an image on a blank canvas), scale (_e.g_., downscaling or upscaling an image preserving its aspect ratio), and rotation (e.g., turning an image 90 degrees onto its side). For instance, [Hu moments](https://en.wikipedia.org/wiki/Image_moment#Rotation_invariants) are a way of describing an image using seven numbers that are invariant to translation, scale, and rotation. For example, you could rotate an image and make it twice as large, and if you calculated the resulting image’s Hu moments they would be the nearly the same as those of the original (for infinite resolution images they are exactly the same, but for discrete images with finite resolution, the numbers would be approximately equal). [Zernike moments](https://ieeexplore.ieee.org/document/55109/) are similar to Hu moments except that they are designed such that one can calculate an arbitrarily high number of them in order to generate an increasingly detailed description of the image.

Hu and Zernike moments are called global features because each moment describes an entire image; however, there also exist local feature descriptors to only describe a specific point in an image. By using local feature descriptors to describe an image, one can more precisely describe the relevant parts of an image. The locations of these descriptors are often chosen through a separate keypoint-finding process designed to find the most “interesting” points in the image. Popular descriptors such as [SIFT](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform) descriptors are, like Hu and Zernike moments, invariant to scale and rotation.

To test if WeChat uses global or local features with these invariance properties to compare similarity between images, we tested if the WeChat image filter is invariant to the same properties as these features. We trivially knew that WeChat’s algorithm was invariant to scale as we had quickly found that any size of an image not trivially small would be filtered (in fact there was no reason to think that we were ever uploading an image the same size as the one on the blacklist). To test rotation, we rotated each image by 90 degrees counterclockwise. After testing these rotations on the same 15 sensitive images we tested in the previous section, we found that all consistently evaded filtering. This suggests that whatever similarity metric WeChat uses to compare uploaded images to those in a blacklist is not invariant to rotation.

### Intensity-based similarity

Another way to compare similarity between two images is to treat each as a one-dimensional array of pixel intensities and then compare these arrays using a similarity metric. Here we investigate three intensity-based similarity metrics: the mean absolute difference, statistical correlation, and mutual information.

#### Mean absolute difference

One intensity-based method to compare similarity between two images is to compare the mean absolute difference of their pixel intensities. This is to say, for each pixel, subtract from its intensity the intensity of the corresponding pixel in the other image and then take its absolute value. The average of all of these absolute differences is the images’ mean absolute difference. Thus, values close to zero represent images that are very similar.

To determine if this was the similarity metric that WeChat used to compare images, we performed the following experiment. We _inverted_, or took the negative, of each of our 15 images and measured whether the inverted image was still filtered. This transformation was chosen since it would produce images that visually resemble the original image while producing a mean absolute difference similar to that of an unrelated image.

|    |    |    |    |
| -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f18-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f18-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f18-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f18-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f18-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f18-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f18-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f18-4.png) |

> Table 25: Out of 15 images, these four evaded filtering. Compared to their non-inverted selves, they had mean absolute differences of 0.87, 0.66, 0.85, and 0.67, respectively.

We found that out of the 15 images we tested, only four of their inverted forms evaded filtering (see Table 25). The evaded images had an average mean absolute difference of 0.76, whereas the filtered ones had an average of 0.72. Among the inverted images that evaded filtering, the lowest mean absolute difference was 0.55, whereas among the inverted images that were filtered, the highest mean absolute difference was 0.97. This suggests that image modifications with low mean absolute differences can still evade filtering, whereas images with high mean absolute differences can still be filtered. Thus it would seem that mean absolute difference is not the similarity metric being used.

#### Statistical correlation

Another intensity-based approach to comparing images is to calculate their statistical correlation. The correlation between both images is the statistical correlation between each of their pixel intensities. The result is a value between -1 and 1, where a value close to 1 signifies that the brighter pixels in one image tend to be the brighter pixels in the other, and a value close to 0 signifies little correlation. Values close to -1 signify that the brighter pixels in one image tend to be the darker pixels in the other (and vice versa), such as if one image is the other with its colours inverted. As this would suggest that the images are related, images with a correlation close to both -1 and 1 can be considered similar.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f19-1.jpg)](https://citizenlab.ca/wp-content/uploads/2018/08/f19-1.jpg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f19-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f19-2.png) |

> Figure 7: Left, the original image. Right, the same image with the colours on the left half on the image inverted. When converted to grayscale, these images have a nearly zero correlation of -0.02, yet the image on the right is still filtered.

To test whether image correlation is used to compare images, we created a specially crafted image by inverting the colours of the left half on the image while leaving the colours in the right half unchanged (see Figure 7). By doing this, the left halves would have strong negative correlation, and the right halves would have strong positive correlation, and so the total correlation would be around zero. We found that our image created this way had a near zero correlation of -0.02, yet it was still filtered. This suggests that statistical correlation between images is not used to determine their similarity.

#### Mutual information

A third intensity-based approach to compare images is to calculate their mutual information. A measurement of mutual information called normalized mutual information (NMI) may be used to constrain the result to be between 0 and 1. Intuitively, mutual information between two images is the amount of information that knowing the colour of a pixel in one image gives you about knowing the colour of a pixel in the same position in other image (or vice versa).

Similar to when we were testing image correlation, we wanted to produce an image that has near-zero NMI but is still filtered. We found that the image that is half-inverted unfortunately still has a NMI of 0.89, a very high number. This is because knowing the colour of a pixel in the original image still gives us a lot of information about what colour it will be in the modified one, as in this case it will be either the original colour or its inverse. In this metric, the distance between colours is never considered, and so there is no longer a cancelling out effect.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f20-1-255x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f20-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f20-2-255x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f20-2.png) |

> Figure 8: Left, the original image in grayscale. Right, the image converted to black and white and inverted to the right of the flag transition. Although these images have a near-zero NMI of 0.03, the image on the right is still filtered.

To create an image with low NMI compared to its original, we took a sensitive image that used colours fairly symmetrically and converted it to black and white. We then inverted nearly half of the image (see Figure 8). Since the modified image is in black and white, knowing the colour of a pixel in the original now gives you little information about the colour in the other image, as most colours appear equally on both sides of the image; it is just as likely to be either its colour or its inverse, and since there are only two colours used in the modified image, knowing that does not provide any information.

Note that in our modified image, we did not split the original image with its inverse image exactly down the middle as we did with the Tank Man photo in Figure 7. We had originally tried this but found that it was not filtered. However, when we split it along the natural border between the Hong Kong and Chinese flags in the image, then it was filtered. This result suggested that edges may be an important feature in WeChat’s algorithm.

#### Histogram similarity

Another general method of comparing images is according to normalized histograms of their pixel intensities. Binning would typically be used to allow for similar colours to fall into the same bins. A simple way of comparing images is to take a histogram over each image in its entirety. This similarity metric would reveal if two images use similar colours, but since it does not consider the locations of any of the pixels, it lacks descriptive power when used as a similarity metric. As such, it would be invariant to rotation. However, as we saw in the earlier section, Tencent’s filter is not. This algorithm would also be invariant to non-uniform changes in scale, (i.e., changes in aspect ratio). To test if WeChat’s filtering algorithm is, we changed the aspect ratio of the same 15 sensitive images we tested in the previous section, in one set reducing each image’s height to 70%, and in another reducing each image’s width to 70%. We found that in all but one case (an image that had its width reduced by 70%) the new images evaded filtering. This further suggests that WeChat is not using a simple histogram approach.

A histogram-based approach would also be sensitive to changes in image brightness and inverting an image’s colours. However, we experimented with increasing images brightness by 0.4 (i.e., increasing each of the R, G, and B values for each pixel by 0.4) or inverting their colours. In each case, the image was still filtered. Since a histogram-based metric would be sensitive to these transformations, this is unlikely to be Tencent’s similarity metric.

One enhancement to the histogram approach is to use a _spatial histogram_, where an image is divided into regions and a separate histogram is counted for each region. This would allow the histogram to account for the spatial qualities of each image. We found reference to Tencent using such an algorithm in a June 2016 document on Intel’s website describing optimizations made to Tencent’s image censorship system. The document is titled “[Tencent Optimizes an Illegal Image Filtering System](https://software.intel.com/en-us/blogs/2016/06/27/tencent-optimizes-an-illegal-image-filtering-system).” The document describes how Intel worked with Tencent to use [SIMD](https://en.wikipedia.org/wiki/SIMD) technology, namely Intel’s [SSE](https://en.wikipedia.org/wiki/Streaming_SIMD_Extensions) instruction set to improve the performance of Tencent’s filtering algorithm used on WeChat and other platforms to censor images. The document does not reveal the exact algorithm used. However, it does include a high level outline and some code samples that reveal characteristics of the algorithm.

The high level view of the algorithm described in the document is as follows.

1.  First, an uploaded image is decoded.
2.  Next, it is then smoothed and resized to a fixed size.
3.  A _fingerprint_ of the image is calculated.
4.  The fingerprint is compared to the fingerprint of each illegal image. If the image is determined to be illegal, then it is filtered.

The details of the fingerprinting step are never explicitly described in the document, but from what we can infer from code samples, we suspect that they were using the following fingerprinting algorithm:

1.  The image is converted to grayscale.
2.  The image is then divided into a 3×3 grid of equally sized rectangle regions.
3.  For each of the 9 regions, a 4-bin histogram is generated by counting and binning based on the intensity of each pixel in that region. The fingerprint is a vector of these 9 × 4 = 36 counts.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f21-1-300x200.jpg)](https://citizenlab.ca/wp-content/uploads/2018/08/f21-1.jpg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f21-2-300x200.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f21-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f21-3-300x200.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f21-3.png) |

> Table 26: Left, the original filtered image. Centre, the original image with the contrast drastically decreased. Right, the original image with the colours inverted. Both the low contrast and inverted images are filtered.

It is never explicitly stated in the report, but file names referenced in the report (simhash.cpp, simhash11.cpp) would suggest that the [SimHash](https://en.wikipedia.org/wiki/SimHash) algorithm may be used to reduce the size of the final fingerprint vector and to binary-encode it. This spatial-histogram-based fingerprinting algorithm is, however, also inconsistent with our observations. While this approach would explain why the metric is not invariant to mirroring or rotation, it still would be sensitive to changes in contrast or to inverting the colours of the image, which we found WeChat’s algorithm to be largely robust to (see Table 26 for an example of decreased contrast and inverted colours).

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f22-300x169.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f22.png)

> Figure 9: Original image.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f23-300x169.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f23.png)

> Figure 10: Image modified such that each of the nine regions has been vertically flipped.

In light of finding Intel’s report, we decided to perform one additional test. We took a censored image and divided it into nine equally sized regions as done in the fingerprinting algorithm referenced in Intel’s report. Next, we independently vertically flipped the contents of each region (see Figures 9 and 10). The contents of each region should still have the same distribution of pixel intensities, thus matching the fingerprint; however, we found that the modified image evaded filtering. It is possible that Tencent has changed their implementation since Intel’s report.

#### Edge detection

Edges are often used to compare image similarity. Intuitively, edges represent the boundaries of objects and of other features in images.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f24-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f24-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f24-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f24-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f24-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f24-3.png) |

> Table 27: Two kinds of filtering. Left, the original image. Centre, the image with a Sobel filter applied. Right, the Canny edge detection algorithm.

There are generally two approaches to edge detection. The first approach involves taking the differences between adjacent pixels. The [Sobel filter](https://en.wikipedia.org/wiki/Sobel_operator) is a common example of this (see Table 27). One weakness of this approach is that by signifying small differences as low intensity and larger differences as high intensity, it still does not specify in a 0-or-1 sense which are the “real” edges and which are not. A different approach is to use a technique like [Canny edge detection](https://en.wikipedia.org/wiki/Canny_edge_detector) which uses a number of filtering and heuristic techniques to reduce each pixel of a Sobel-filtered image to either black (no edge) or white (an edge is present). As this reduces each pixel to one bit, it is more computationally efficient to use as an image feature.

There is some reason to think that WeChat’s filtering may incorporate edge detection. When we searched online patents for references to how Tencent may have implemented their image filtering, we found that in June 2008 Tencent filed a patent in China called [图片检测系统及方法](https://encrypted.google.com/patents/CN101303734A) (System and method for detecting a picture). In it they describe the following real-time system for detecting blacklisted images after being uploaded.

1.  First, an uploaded image is resized to a preset size in a way that preserves aspect ratio.
2.  Next, the [Canny edge detection](https://en.wikipedia.org/wiki/Canny_edge_detector) algorithm is then used to find the edges in the uploaded image.
3.  A fingerprint of the image is calculated.
    1.  First, the moment invariants of the result of the Canny edge detection algorithm are calculated. It is unclear what kind of moment invariants are calculated.
    2.  In a way that is not clearly specified by the patent, the moment invariants are through some process binary-encoded.
    3.  Finally, the resulting binary-encoded values are [MD5](https://en.wikipedia.org/wiki/MD5) hashed. This resulting hash is the image fingerprint.
4.  fingerprint of the uploaded image is then compared to the fingerprint of each illegal image. If the fingerprint matches any of those in the image blacklist, then it is filtered.

Steps 1 and 4 are generally consistent with our observations in this report thus far. Uploaded images are resized to a preset size in a way that preserves aspect ratio, and the calculated fingerprint of an image is compared to those in a blacklist.

In step 3, the possibility of using Canny edge detection is thus far compatible with all of our findings in this report (although it is far from being the only possibility). The use of moment invariants is not strongly supported, as WeChat’s filtering algorithm is very sensitive to rotation. Moreover, encoding the invariants into an MD5 hash through any imaginable means would seem inconsistent with our observations thus far, as MD5, being a cryptographic hash, has the property that the smallest of changes to the hashed content have, in expectation, an equal size of effect on the value of the hash as that of the largest changes. However, we might imagine that they use an alternative hash such as [SimHash](https://en.wikipedia.org/wiki/SimHash), which can hash vectors of real-valued numbers such that two hashes can be compared for similarity in a way that approximates the original [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity) between the hashed vectors.

We found that designing experiments to test for the use of Canny edge detection difficult. The algorithm is highly parameterized, and the parameters are often determined dynamically using heuristics based on the contents of an image. Moreover, unlike many image transformations such as grayscale conversion, Canny edge detection is not idempotent, (i.e., the canny edge detection of a canny edge detection is not the same as the original canny edge detection). This means that we cannot simply upload an edge-detected image and see if it gets filtered. Instead, we created test images by removing as many potentially relevant features of an image as possible while preserving the edges of an image.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f21-1-300x200.jpg)](https://citizenlab.ca/wp-content/uploads/2018/08/f21-1.jpg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f25-2-300x200.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f25-2.png) |

> Table 28: Left, the original filtered image. Right, the image thresholded according to Otsu’s method, which is also filtered.

To do this, we again returned to thresholding, which we originally explored when analyzing the WeChat filter’s ability to perform OCR. By using thresholding, we reduced all pixels to either black or white, eliminating any gray or gradients from the image, while hopefully largely preserving the edges in the image (see Table 28).

In our experiment, we wanted to know what effects performing thresholding would have on images that we knew were filtered. To do this, on our usual 15 images we applied global thresholding according to four different thresholds: the image’s median grayscale pixel value, the image’s mean grayscale pixel value, a fixed value of 0.5, and a threshold value chosen using Otsu’s method (see Table 29).

[![](https://citizenlab.ca/wp-content/uploads/2018/08/Table_14.png)](https://citizenlab.ca/wp-content/uploads/2018/08/Table_14.png)

> Table 29: Results performing four different thresholding algorithms on 15 images. All but one image was filtered after being thresholded by at least one of the four algorithms.

We found that all but one image was still filtered after being thresholded by at least one of the four algorithms.

|    |    |    |    |
| -- | -- | -- | -- |
| (a) | (b) | (c) | (d) |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f26-1-300x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f26-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f26-2-300x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f26-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f26-3.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f26-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f26-4.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f26-4.png) |

> Table 30: (a), Liu Xiaobo’s empty chair, when thresholded according to Otsu’s method, its stripes are lost. (b), Liu Xiaobo and his wife thresholded according to Otsu’s method with the algorithm performing poorly on the gradient background. (c) and (d), an artificially created gradient background and its thresholded counterpart. In (d), an edge has been created where perceptually one would not be thought to exist.

All but two of the images were still filtered after being thresholded using a threshold determined via Otsu’s method. Among the two images that were not filtered, one was the image of Liu Xiaobo’s empty chair. This may be because the threshold chosen by Otsu’s method did not distinguish the stripes on the empty chair. The other was the photograph of Liu Xiaobo and his wife clanging coffee cups. This may be because thresholding does not preserve edges well with backgrounds with gradients, as the thresholding will create an erroneous edge where none actually exists (see Table 30).

As an additional test, we took the 15 images thresholded using Otsu’s method and inverted them. This would preserve the location of all edges while radically altering the intensity of many pixels.

|    |    |    |    |
| -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f27-1-225x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f27-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f27-2-255x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f27-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f27-3-300x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f27-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f27-4-220x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f27-4.png) |

> Table 31: The four images filtered after thresholding according to Otsu’s method and then inverted.

We found that among the 13 images that were filtered after applying Otsu’s method, only four were filtered after they were additionally inverted (see Table 31). The two images that were not filtered before were also not filtered after being inverted. This suggests that, if edge detection is used, it is either in addition to other features of the image, or the edge detection algorithm is not one such as the Canny edge detection algorithm which only tracks edges not their “sign” (i.e., whether the edge is going from lighter to darker versus darker to lighter).

Between the Intel report and the Tencent patent, we have seen external evidence that WeChat is using either spatial histograms or Canny edge detection to fingerprint sensitive images. Since neither seems to be used by itself, is it possible that they are building a fingerprint using both? To test this, we took the 13 filtered images thresholded using Otsu’s method and tested to see how light we could lighten the black channel such that the thresholded image is still filtered.

|    |    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-5.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-6-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-6.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-7-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-7.png) |
| 20 | 215 | 56 | 11 | 12 | 19 | 15 |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-8-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-8.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-9-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-9.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-10-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-10.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-11-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-11.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-12-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-12.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f28-13-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f28-13.png) |
| 18 | 28 | 55 | 255 | 21 | 18 |

> Table 32: The lightest image still filtered, and, below each image, the difference in intensities between white and the darkest value (out of 255).

Our results show that sometimes the difference in intensities can be small for an image to still be filtered and that sometimes it must be large, with one case allowing no lightening of the black pixels at all (see Table 32). The images with small differences are generally the non-photographic ones with well-defined edges. These are images where the thresholding algorithm would have been most likely to preserve features of the image such as the edges in the first place. Thus, they are more likely to preserve these features when they have been lightened up, especially after possible filtering such as downscaling has been applied.

Nevertheless, this result shows that the original image need not have a similar spatial histogram. Six of the seven images in Table 32 have an intensity difference of less than 64, which, in the 4-binned spatial histogram algorithm referenced in the Intel report, would put every pixel into the same bin. When we repeat this experiment with the inverted thresholded images and lightening them such that every pixel fit into the same bin, we could not get any additional inverted images to be filtered, despite these images preserving the locations of the edges and having the same spatial histograms as images that we knew to be filtered. All together this suggests that spatial histograms are not an important feature of these images.

So far our approach has been to eliminate as many of an image’s features as possible except for edges and test to see if it still gets filtered. We also decided to take the opposite approach, eliminating edges by blurring them while keeping other features untouched. We proportionally resized each image such that its smallest dimension(s) is/are 200 pixels (see the “Resizing” section for why we resized this way). Then we applied a normalized box filter to blur the image, increasing the kernel size until the image is sufficiently blurred to evade filtering.

|    |    |    |    |    |
| -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-5.png) |
| 5 px | 3 px | 4 px | 4 px | 2 px |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-6-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-6.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-7-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-7.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-8-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-8.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-9-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-9.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-10-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-10.png) |
| 3 px | 1 px | 6 px | 4 px | 5 px |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-11-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-11.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-12-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-12.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-13-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-13.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-14-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-14.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f29-15-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f29-15.png) |
| 4 px | 6 px | 7 px | 5 px | 6 px |

> Table 33: The largest normalized box filter kernel size that can be applied to each image while still being filtered.

In general, we saw that WeChat’s filter was not robust to blurring (see Table 33). Non-photographic images were generally the easiest to evade filtering by blurring, possibly because they generally have sharper and more well-defined edges.

In this section we have demonstrated evidence that edges are important image features in WeChat’s filtering algorithm. Nevertheless, it remains unclear exactly how WeChat builds image fingerprints. Some possibilities are that it specifically uses filtering methods such as Sobel filtering, although a detection algorithm such as Canny edge detection seems unlikely as it does not preserve the sign of the edges. Another possibility is that it fingerprints images in the [frequency domain](https://en.wikipedia.org/wiki/Fourier_transform), where small changes to distinct edges can often have effect the values of a large number of multiple frequencies, and where large changes to the overall brightness of an image can significantly affect the values of only a small number of frequencies.

> * 上一篇：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md)
>
> * 下一篇：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
