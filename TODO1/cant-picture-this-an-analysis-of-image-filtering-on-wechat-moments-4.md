> * 原文地址：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4](https://citizenlab.ca/2018/08/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments/)
> * 原文作者：[Jeffrey Knockel](https://citizenlab.ca/author/jknockel/), [Lotus Ruan](https://citizenlab.ca/author/lotus/), [Masashi Crete-Nishihata](https://citizenlab.ca/author/masashi/), and [Ron Deibert](https://citizenlab.ca/author/profd/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md)
> * 译者：
> * 校对者：

# (CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4

> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-1.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md)

#### Resizing

Up until this point, we have been mostly concerned with experimenting with images that have the same aspect ratios. In this section we test how changing images’ sizes affected WeChat’s ability to recognize them. How does WeChat’s filter compare images that might be an upscaled or downscaled version of that on the blacklist? For instance, does WeChat normalize the dimensions of uploaded images to a canonical size? (See Table 34)

![](https://i.loli.net/2018/08/16/5b74e3805b458.png)

> Table 34: Examples of how two images would be resized according to five different hypotheses.

To answer these questions, we decided to test five different hypotheses:

1.  Images are proportionally resized such that their **width** is some value such as 100.
2.  Images are proportionally resized such that their **height** is some value such as 100.
3.  Images are proportionally resized such that their **largest** dimension is some value such as 100.
4.  Images are proportionally resized such that their **smallest** dimension is some value such as 100.
5.  **Both** dimensions are resized according to two parameters to some fixed size and proportion such as 100×100.

If the last hypothesis is correct, then we would expect WeChat’s filter to be invariant to non-uniform changes in scale, i.e., it should be tolerant of modifications to a sensitive image’s aspect ratio. This is because the aspect ratio of the uploaded image would be erased when the image is resized to a preset aspect ratio. To test this, we performed an experiment on our usual set of 15 images. We created a _shorter_ image by stretching each image 30% shorter. We also created a _thinner_ image by stretching each image 30% thinner. Each of the shorter images evaded filtering. Moreover, all but one of the thinner images, the graphic of Liu Xiaobo with his wife, evaded filtering. As modifying the aspect ratio of blacklisted images easily evades filtering, this would suggest that the last hypothesis is not true.

To test hypotheses 1 through 4, we made the following corresponding predictions:

1.  If images are proportionally resized based on their **width**, then adding extra space to their width would evade filtering but adding it to their height would not.
2.  If images are proportionally resized based on their **height**, then adding extra space to their height would evade filtering.
3.  If images are proportionally resized based on their **largest** dimension, then adding extra space to that dimension would evade filtering.
4.  If images are proportionally resized based on their **smallest** dimension, then adding extra space to that dimension would evade filtering.

|    |    |    |    |    |
| -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w1-150x141.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w2-150x125.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w3-150x141.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-w5.png) |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f30-h5.png) |

> Table 35: The five wide and the five tall images we tested.

|    | **Resized to same height** | **Resized to same width** |
| -- | -------------------------- | ------------------------- |
|    | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-2.png) |
|    | (the original) | (the original) |
| +  | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-3.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-4-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-4-1.png) |
|    | (space added to width, resized to same height) | (space added to width, resized to same width) |
| =  | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-5-150x100.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-5.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f31-6.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f31-6.png) |

> Table 36: Two different ways of resizing an image after extra space is added to its width. If resizing by its height (hypothesis 2) or by its shortest dimension (hypothesis 4), the scale of the image’s contents are unchanged with respect to the original and there is complete overlap (white). If resizing by its width (hypothesis 1) or by its largest dimension (hypothesis 3), the image’s original contents become smaller and do not overlap well with the original.

To test these predictions, we chose ten filtered images, five such that their height is no more than ⅔ of their width, which we call the _wide_ images, and five such that their width is no more than ⅔ of their height, which we call the _tall_ images (see Table 35). We then modified each of the images by adding black space the size of 50% of their width to their left and right sides (see Table 36 for an example) and again by adding black space the size of 50% of their height to their top and bottom sides. We repeated these again except by using 200% of the respective dimensions.

![](https://i.loli.net/2018/08/16/5b74f84ec10a0.png)

> Table 37: The number of wide and tall images that evaded filtering after adding different amounts of extra space to either their width or height.

We found that wide images with space added to their width and tall images with space added to their height were always filtered. This is consistent with hypothesis 4, that WeChat resizes based on an uploaded image’s shortest dimension, as this hypothesis predicts that adding space in this matter will not change the scale of the original image contents after the image is resized. We also found that wide images with space added to their height and tall images with space added to their width usually evaded filtering, suggesting that this caused the uploaded image to be further downscaled compared to the corresponding one on the blacklist.

The results between adding 50% and 200% extra space were fairly consistent, with only one additional image being filtered in the 200% case. This consistency is to be expected, since according to the shortest dimension hypothesis, adding extra space past when the image has already become square will not affect its scaling.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f32.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f32.png)

> Figure 11: A screenshot of visually similar images to the Tank Man photo with extra space on their top and bottom found via a reverse Google Image search.

It is not clear why some images–two tall images with extra width and one wide image with extra height–were still filtered. It is possible that WeChat’s filtering algorithm has some tolerance of changes in scale. However, it is also possible that variants of these images with that extra space or some other border or content added in these areas are also on the blacklist. For example, the only wide image with extra height to still be filtered is the famous and highly reproduced Tank Man photo. A reverse Google Image search finds that there are many images with similar spacing added to them already in circulation on the Internet (see Figure 11).

#### Translational invariance

In the previous section, when we tested how the filter resizes uploaded images, we did so by adding blank black space to the edges of uploaded images and observing which are filtered. We found that images with a large amount of extra space added to their largest dimensions were still filtered. We tested this by keeping the sensitive image in the centre and adding an equal amount of extra space to both sides of the largest dimension. We wanted to know if WeChat’s filtering algorithm can only find sensitive images in the centre of such an image, or if it can find them anywhere in an image. Formally, we wanted to test whether WeChat’s filtering algorithm is [translationally invariant](https://en.wikipedia.org/wiki/Translation_invariance).

[![](https://citizenlab.ca/wp-content/uploads/2018/08/F33_1-300x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/F33_1.png)[![](https://citizenlab.ca/wp-content/uploads/2018/08/F33_2-300x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/F33_2.png)

> Figure 12: The three images on the left are filtered demonstrating the WeChat filter’s translational invariance. However, the three images on the right are not filtered because they make the tall image wider, affecting its smallest dimension.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/F34_1-MK-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/F34_1-MK-1.png)

> Figure 13: Examples of images filtered due to the WeChat filter’s translational invariance.

We took images from the previous experiment and experimented with increasing their canvas size and moving the image proper around inside of a larger, blank canvas (see Figures 12 and 13). We found that so long as we did not change the size of the image’s smallest dimension, the image proper could be moved anywhere inside of the extended canvas and still not be censored.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/F35_1-MK.png)](https://citizenlab.ca/wp-content/uploads/2018/08/F35_1-MK.png)

> Figure 14: For a square image where its width is equal to its height, adding space to either dimension will not evade filtering regardless of where the image is located.

Note that in a tall or wide image, we can only add space to one of its dimensions for it to still be filtered. For a square image, we can add space to either side, but only in one dimension at a time (see Figure 14). However, if we add extra space to both, its scale will be modified after it is resized by WeChat’s filtering algorithm.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/F36_1-MK.png)](https://citizenlab.ca/wp-content/uploads/2018/08/F36_1-MK.png)

> Figure 15: (a), an image encoded to JPEG by WeChat that evaded filtering, and (b), that image with the extended canvas cropped off that also evaded filtering. (c), an image encoded to PNG by WeChat that was filtered, and (d), that image with the extended canvas cropped off that was also filtered. At a glance, both (b) and (d) look surprisingly similar, but (b) has more JPEG compression artifacts.

We came across some apparent exceptions to the WeChat algorithm’s translational invariance that we found could ultimately be explained by WeChat’s compression algorithm. Some images where we extended the canvas with blank space evaded filtering (see Figure 15). However, we found that this may actually be due to the WeChat server’s compression of the images. We found that, after posing these images, when we downloaded them using another WeChat user and examined them, they were encoded in JPEG, a lossy compression algorithm that decreases the size needed to represent the image by partially reducing the quality of that image. We found that when we took this image as it was encoded by WeChat’s servers and cropped off the extended canvas and posted it onto WeChat, it still evaded filtering, suggesting that it is WeChat’s compression and not the extension of the canvas per se that caused the image to evade filtering. We found that WeChat increased its compression of images for larger images, likely to try to keep larger images from taking up more space. Thus, by extending the size of the canvas, we increased the compression of the original image, causing it to evade filtering.

We found that not all images were JPEG compressed when downloaded by another client. Rarely, images would be downloaded in PNG, a lossless compression algorithm that reduces image size by accounting for redundancies in an image but never by reducing the image’s quality. In this case, we found that the PNG image another WeChat client downloaded was pixel-for-pixel identical to the one that we had originally uploaded. We found that such images were always filtered, further suggesting that WeChat’s own compression was affecting its filtering behavior in other images. Unfortunately, we were unable to determine why WeChat would compress a posted image as JPEG or PNG, as this behavior was both rare and nondeterministic. That is, often even if we uploaded an image that had previously been observed to have been encoded to PNG, it would often be encoded to JPEG in subsequent uploads. This nondeterministic compression behavior would also explain why we would occasionally observe nondeterministic filtering behavior on WeChat.

|    |    |    |    |    |
| -- | -- | -- | -- | -- |
| (a) | (b) | (c) | (d) | (e) |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f37-1-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f37-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f37-2-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f37-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f37-3-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f37-3.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f37-4-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f37-4.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f37-5-150x150.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f37-5.png) |

> Table 38: (a), the original image. (b), that image thresholded and pixelated to 16×16 blocks. (c), (d), and (e) show compression artifacts by colouring pure black as orange, pure white as green, leaving the off-white and off-black colours unchanged. (c) is the result of WeChat’s compression. (d) is the result of WebP compression at quality 42, visually similar to (c). (e) is the result of either PNG or JPEG compression, as PNG is losslessly compressed and JPEG uses no interblock compression.

We found that the images downloaded in JPEG appeared to have been also previously compressed using a different compression algorithm. We determined this by creating an image made entirely of 16×16 pixel blocks of purely black or white (see Table 38 (a) and (b)). Even though JPEG is a lossy algorithm, it independently compresses 8×8 pixel blocks (i.e., there is no inter-block compression between blocks). However, we observed the images having been compressed by a 16×16 block compression algorithm that utilizes information from surrounding blocks. The new [WebP](https://en.wikipedia.org/wiki/WebP) image compression algorithm from Google is consistent with these findings, as were the compression artifacts (see Table 38 (c), (d), and (e)). Moreover, we found that WeChat supported posting WebP images, which further suggests that they may be using it to encode uploaded images as well.

Despite having some initial difficulty controlling for the effects of WeChat’s image compression on posted images, we generally found that WeChat’s filtering algorithm is invariant to translation. There are a number of different methods that could account for finding an image inside of another, especially since the algorithm is not invariant to changes in scale. WeChat’s filtering algorithm could be centering images according to their centre of mass before comparing them. The filter could be using [cross-correlation](https://en.wikipedia.org/wiki/Cross-correlation) or [phase correlation](https://en.wikipedia.org/wiki/Phase_correlation) to compare the images accounting for differences in their alignments (i.e., their translational difference). WeChat’s filtering algorithm could also be using a sliding window approach such as with [template matching](https://en.wikipedia.org/wiki/Template_matching), or it may be using a [convolutional neural network](https://en.wikipedia.org/wiki/Convolutional_neural_network), a neural network that does not require a sliding window to implement but that has similar functionality. We initially found the translational invariance of WeChat’s algorithm surprising given that it was not invariant to other transformations such as mirroring or rotation, but the use of any one of the methods enumerated in this paragraph would provide translational invariance without necessarily providing invariance to mirroring or rotation. In the next section, we will try to eliminate some of these methods as possibilities by testing what happens if we replace the blank canvas space that we have been using to extend image with complex patterns.

#### Sliding window

In the previous section, we tested for translational invariance by extending the canvas with blank space. What if the added content is not blank? In this section we are concerned with whether the algorithm is not simply translationally invariant but whether it can find an image inside of another image regardless of the surrounding contents.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f38-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f38-1.png)

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f38-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f38-2.png)

> Figure 16: Above, an image extended with i = 2 blank canvases. Below, an image extended with i = 2 duplicates of itself.

Given our findings about WeChat’s compression affecting filtering results in the previous section, we carefully designed our experiment. Taking our five wide and five tall images, we extended their canvas in their largest dimension on both sides by _i_ ⋅ _n_, for a total of 2 ⋅ _i_ ⋅ _n_ overall, for each _i_ in {1, 2, …, 5}, where _n_ is the size of the largest dimension. We then created equivalently sized images that were not blank. Since many image operations such as thresholding and edge detection are sensitive to the distribution of pixel intensities in an image, and others such as moment invariants are sensitive to changes in centre of mass, to control for these variables, we filled each blank area by a duplicate copy of the image itself so that these variables are not affected (see Figure 16). To account for WeChat’s compression, for any image we generated, if it evades filtering, we download the image and analyze it. If the centre image inside of it (the only one in the case of a blank extended canvas or the one in the middle in the case of where the image is duplicated) are no longer filtered when uploaded on their own, then we discard all results from any images derived from that original wide or tall image.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/Table_17.png)](https://citizenlab.ca/wp-content/uploads/2018/08/Table_17.png)

> Table 39: After testing a wide or tall image by either extending it by i-many blank canvas or i-many image duplicates, was it still filtered? Y = Yes, N = No, C = No due to compression artifacts. With one exception, all images extended with blankness were either filtered or evaded filtering due to compression artifacts, whereas when extending an image with duplicates of itself, none of the filtering evasion can be explained by compression artifacts.

Our results are given in Table 39. We found that images extended with their own duplicates evaded filtering after a sufficiently large number of images were added, and none of these evasions could be explained by image compression. Conversely, in all but one test, images extended with blank canvases were either filtered or their evasion could be explained by image compression.

These results suggest that, even when we add additional contents to an uploaded image such that neither the distribution of intensities of the image nor its centre of mass change, these contents affect the ability of WeChat to recognize the uploaded image as sensitive. This suggests that WeChat may not use a sliding window approach that ignores contents outside of that window to compare images. Instead, the images appear to be compared as a whole and that adding complex patterns outside of a blacklisted image can evade filtering.

#### Perceptual hashing

Unlike cryptographic hashing, where small changes are designed to produce large changes to the hash, perceptual hashing is a technique to reduce an image to a hash such that similar images have either [equal](https://ieeexplore.ieee.org/abstract/document/1421855/) or [similar](http://phash.org/) hashes to facilitate efficient comparison. It is [used by many social media companies such as Facebook, Microsoft, Twitter and YouTube](https://newsroom.fb.com/news/2016/12/partnering-to-help-curb-spread-of-online-terrorist-content/) to filter illegal content.

As we suggested in the section on edge detection, a frequency-based approach would explain the visual-based filter’s sensitivity to edges; however, such an approach can also be used to achieve a hash exhibiting translational invariance. The popular open source implementation [pHash](http://phash.org/) computes a hash using the discrete cosine transform, which is not translationally invariant. However, an alternative spectral computation that would exhibit translational invariance would be to calculate the image’s amplitude spectrum by computing the absolute magnitude of the discrete [Fourier transform](https://en.wikipedia.org/wiki/Fourier_transform) of the image, as [translation only affects the phase, not the magnitude](https://en.wikipedia.org/wiki/Fourier_transform#Basic_properties), of the image’s frequencies. The use of a hash based on this computation would be consistent with our findings, but more work is needed to test if this technique is used.

## Conclusion

In analyzing both the OCR-based and visual-based filtering techniques implemented by WeChat, we discovered both strengths in the filter as well as weaknesses. An effective evasion strategy against an image filter modifies a sensitive image so that it (1) no longer resembles a blacklisted image to the filter but (2) still resembles a blacklisted image to people reading it.

The OCR-based algorithm was generally able to read text of varying legibility and in a variety of environments. However, due to the way it was implemented, we found two ways to evade filtering:

*   By hiding text in the hue of an image, since the OCR filter converts images to grayscale.
*   By hiding text using a large amount of blobs, since the OCR filter performs blob merging.

Similarly, the visual-based algorithm was able to match sensitive images to those on a blacklist under a variety of conditions. The algorithm had translational invariance. Moreover, it detected images even after their brightness or contrast had been altered, after their colours had been inverted, and after they had been thresholded to only two colours. However, due to the way it was implemented, we found multiple ways to evade filtering:

*   By mirroring or rotating the image, since the filter has no high level semantic understanding of uploaded images. However, many images lose meaning when mirrored or rotated, particularly images that contain text which may be rendered illegible.
*   By changing the aspect ratio of an image, such as by stretching the image wider or taller. However, this may make objects in images look out of proportion.
*   By blurring the photo, since edges appear important to the filter. However, while edges are important to WeChat’s filter, they are often perceptually important for people too.
*   By adding a sufficiently large border to the smallest dimensions of an image, or to both the smallest and largest dimensions, particularly if both dimensions are of equal or similar size.
*   By adding a large border to the largest dimensions of an image and adding a sufficiently complex pattern to it.

In this work we present experiments uncovering implementation details of WeChat’s image filter that inform multiple effective evasion strategies. While the focus of this work has been WeChat, due to common implementation details between image filtering implementations, we hope that our methods will serve as a road map for future research studying image censorship on other platforms.

## Acknowledgments

We would like to thank Lex Gill for research assistance. We would also like to extend thanks to Jakub Dalek, Adam Senft, and Miles Kenyon for peer review. This research was supported by the Open Society Foundations.

Image testing data and source code is available [here](https://github.com/citizenlab/chat-censorship/tree/master/wechat/image-filtering).

> * 上一篇：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
