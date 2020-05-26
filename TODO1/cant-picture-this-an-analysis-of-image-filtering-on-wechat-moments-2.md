> * 原文地址：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2](https://citizenlab.ca/2018/08/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments/)
> * 原文作者：[Jeffrey Knockel](https://citizenlab.ca/author/jknockel/), [Lotus Ruan](https://citizenlab.ca/author/lotus/), [Masashi Crete-Nishihata](https://citizenlab.ca/author/masashi/), and [Ron Deibert](https://citizenlab.ca/author/profd/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md)
> * 译者：
> * 校对者：

# (CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2

> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-1.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-2.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)
> * [(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-4.md)

## Analyzing Image Filtering on WeChat

We measured whether an image is automatically filtered on WeChat Moments by posting the image using an international account and measuring whether it was visible to an account registered to a mainland China phone number after 60 seconds, as we found that images automatically filtered were typically removed in 5 to 30 seconds. To determine how WeChat filters images, we performed modifications to images that were otherwise filtered and measured which modifications evaded filtering. The results of this method revealed multiple implementation details of WeChat’s filtering algorithms, and since our methods understand how WeChat’s filtering algorithm is implemented by analyzing which image modifications evade filtering, they naturally inform strategies to evade the filter.

We found that WeChat uses two different filtering mechanisms to filter images: an Optical Character Recognition (OCR)-based approach that searches images for sensitive text and a visual-based approach that visually compares an uploaded image against a list of blacklisted images. In this section we describe how testing for and understanding implementation details of both of these filtering methods led to effective evasion techniques.

### OCR-based filtering

We found that one approach that Tencent uses to filter sensitive images is to use OCR technology. An OCR algorithm is an algorithm that automatically reads and extracts text from images. OCR technology is commonly used to perform tasks such as automatically converting a scanned document into editable text or to read characters off of a license plate. In this section, we describe how WeChat uses OCR technology to detect sensitive words in images.

OCR algorithms are complicated to implement and the subject of active research. While reading text comes naturally to most people, computer algorithms have to be specifically programmed and trained in how to do this. OCR algorithms have become increasingly sophisticated over the past decades to be able to effectively read text in an increasingly diverse amount of real-world cases.

We did not systematically measure how much time WeChat’s OCR algorithm required, but we found that OCR images were not filtered in real time and that after uploading an image containing sensitive text, it would typically be visible to other users between 5 and 30 seconds before it was filtered and removed from others’ views of the Moments feed.

#### Grayscale conversion

OCR algorithms may use different strategies to recognize text. However, at a high level, we found that WeChat’s OCR algorithm shares implementation details with other OCR algorithms. As most OCR algorithms do not operate directly on colour images, the first step they take is to convert a colour image to _grayscale_ so that it only consists of black, white, and intermediate shades of gray, as this largely simplifies text recognition since the algorithms only need to operate on one channel.

| Algorithm | Result |
| --------- | ------ |
| Original | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f4-1.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f4-1.jpeg) |
| Average | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f4-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f4-2.png) |
| Lightness | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f4-3.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f4-3.png) |
| Luminosity | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f4-4.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f4-4.png) |

Table 1: An image with green text and a background colour of gray with the same shade as the text according to the luminosity formula for grayscale and how the text would appear to an OCR algorithm according to three different grayscale algorithms. If the OCR algorithm uses the same grayscale algorithm that we used to determine the intensity of the gray background, then the text effectively disappears to the algorithm.

To test if WeChat’s OCR filtering algorithm performed a grayscale conversion of colour images, we designed test images that would evade filtering if the OCR algorithm converted uploaded images to grayscale. We designed the images to contain text hidden in the hue of an image in such a way that it is easily legible by a person reading it in colour but such that once it is converted to grayscale, the text disappears and is invisible to the OCR algorithm. If the image evaded censorship, then the OCR algorithm must have converted the image to grayscale (see Table 1 for an illustration).

As we did not know which formula the OCR algorithm used to convert colour images to grayscale, we evaluated multiple possibilities. Coloured raster images are typically represented digitally as a two-dimensional array of pixels, each pixel having three colour channels (red, green, and blue) of variable intensity. These intensities correspond to the intensities of the red, green, and blue outputs on most electronic displays, one for each cone of the human eye.

In principle, the gray intensity of a colour pixel could be calculated according to any function of its red, green, and blue intensities. We evaluated three common algorithms:

1.  [average](https://docs.gimp.org/en/gimp-tool-desaturate.html)(_r_, _g_, _b_) = (_r_ + _g_ + _b_) / 3
    
2.  [lightness](https://docs.opencv.org/3.4.2/de/d25/imgproc_color_conversions.html)(_r_, _g_, _b_) = (max(_r_, _g_, _b_) + min(_r_, _g_, _b_)) / 2
    
3.  [luminosity](https://docs.opencv.org/3.4.2/de/d25/imgproc_color_conversions.html)(_r_, _g_, _b_) = 0.299 _r_ + 0.587 _g_ + 0.114 _b_
    

To use as comparisons and to validate our technique, in addition to WeChat’s algorithm, we also performed this same analysis on two other OCR algorithms: the [one provided by Tencent’s Cloud API](https://youtu.qq.com/#/char-general), an online API programmers can license from Tencent to perform OCR, and [Tesseract.js](https://tesseract.projectnaptha.com/), a browser-based Javascript implementation of the open source [Tesseract](https://github.com/tesseract-ocr/tesseract) OCR engine. We chose Tencent’s Cloud OCR because we suspected it may share common implementation details with the OCR algorithm WeChat uses for filtering, and we chose Tesseract.js since it was popular and open source.

Since Tesseract.js was open source, we analyzed it first as it allowed us to look at the source code and directly observe the algorithm used for grayscale to use as a ground truth. To our surprise, the exact algorithm used was not any of the algorithms that we had initially presumed but rather a close approximation of one. Namely, it used a fixed-point approximation of the YCbCr luminosity formula equivalent to the following Javascript expression:

> (255 * (77 * _r_ + 151 * g + 28 * _b_) + 32768) >> 16

where “_a_ >> _b_” denotes shifting _a_ to the right by _b_ bits, an operation mathematically equivalent to ⌊_a_ / 2<sup>_b_</sup>⌋. Multiplied out, this is approximately equivalent to 0.300 _r_ + 0.590 _g_ + 0.109 _b_.

Knowing this, we created images containing filtered text in six different colours: red, (1.0, 0, 0); yellow, (1.0, 1.0, 0); green, (0, 1.0, 0); cyan, (0, 1.0, 1.0); blue, (0, 1.0, 1.0); and magenta, (1.0, 0, 1.0); where (_r_, _g_, _b_) is the colour in RGB colourspace and 1.0 is the highest intensity of each channel (see Table 2). These six colours were chosen because they have maximum saturation in the [HSL](https://en.wikipedia.org/wiki/HSL_and_HSV) colourspace and a simple representation in the RGB colourspace. For each colour (_r_, _g_, _b_), we created an image whose text was colour (_r_, _g_, _b_) and whose background was the gray colour (_Y_, _Y_, _Y_), such that _Y_ was equal to the value of the above Javascript expression evaluated as a function of _r_, _g_, and _b_.

We tested the images on Tesseract.js, and any text we tried putting into the image was completely invisible to the algorithm. We found that no other grayscale algorithm consistently evaded detection on all colours, including the original luminosity formula. While very similar to the formula Tesseract.js used, it, for example, failed for the colours with a blue component, as the coefficient for the blue channel is where the formulas most disagreed. Even this small difference produced text that was detectable. Generalizing from this, we concluded that evading WeChat’s OCR filtering algorithm may prove difficult, as we may have to know the exact grayscale formula used, but once we correctly identified it, we would be able to consistently evade WeChat’s filtering algorithm with any colour of text.

|    |    |    |    |    |
| -- | -- | -- | -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-1-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-1.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-2-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-2.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-3-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-3.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-4-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-4.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-5-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-5.jpeg) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f5-6-215x300.jpeg)](https://citizenlab.ca/wp-content/uploads/2018/08/f5-6.jpeg) |

> Table 2: Each of the six colours of text tested. Here the background colour of each of the above six images was chosen according to the luminosity of the colour of that image’s text.

Knowing that our methodology was feasible as long we knew the exact algorithfigurm that WeChat used to convert images to grayscale, we turned our attention to WeChat’s OCR algorithm. Using the same technique as before, we tested each of the three candidate grayscale conversion algorithms to determine if any would consistently evade the filter. We used the same six colours as before. For each test image, we used 25 keyword combinations randomly selected from a set that we already knew to be filtered via OCR filtering (see the Section “Filtered text content analysis” for how we created this set). For each colour (_r_, _g_, _b_), we used the grayscale algorithm being tested _f_ to determine (_Y_, _Y_, _Y_), the colour of the gray background, where _Y_ = _f_(_r_, _g_, _b_).

After performing this initial test, we found that only when choosing the intensity of the gray background colour as given by the luminosity formula could we consistently evade filtering for every tested colour. The other two algorithms did not evade censorship when testing most colours (see Table 3).

![](https://i.loli.net/2018/08/15/5b73fb70eac5a.png)

> Table 3: Results choosing the intensity of the gray background colour according to three different grayscale conversion algorithms for six different colours of text. For the average and lightness algorithms, most of the images were filtered. For the luminosity algorithm, none of them were.

We repeated this same experiment for Tencent’s online OCR platform. Unlike WeChat’s OCR filtering implementation, where we could only observe whether WeChat’s filter found sensitive text in the image, Tencent’s platform provided us with more information, including whether the OCR algorithm detected any text at all and the exact text detected. Repeating the same procedure as with WeChat, we found that again only choosing gray backgrounds according to each colour’s luminosity would consistently hide all text from Tencent’s online OCR platform. This suggested that Tencent’s OCR platform may share implementation details with WeChat, as both appear to perform grayscale conversion the same way.

To confirm that using the luminosity formula to choose the text’s background colour consistently evaded WeChat’s OCR filtering, we performed a more extensive test targeting only that algorithm. We selected five lists of 25 randomly chosen keywords we knew to be blocked. We also selected five lists of 10, 5, 2, and 1 keyword(s) chosen at random. For each of these lists, we created six images, one for each of the same six colours we used in the previous experiment. Our results were that all 150 images evaded filtering. These results show that we can consistently evade WeChat’s filtering by hiding coloured text on a gray background chosen by the luminosity of the text and that WeChat’s OCR algorithm uses the same or similar formula for grayscale conversion.

### Image thresholding

After converting a coloured image to grayscale, another step in most OCR algorithms is to apply a _thresholding_ algorithm to the grayscale image to convert each pixel, which may be some shade of gray, to either completely black or completely white such that there are no shades of gray in between. This step is often called “binarization” as it creates a binary image where each pixel is either 0 (black) or 1 (white). Like converting an image to grayscale, thresholding further simplifies the image data making it easier to process.

There are two common approaches to thresholding. One is to apply _global thresholding_. In this approach, a single threshold value is chosen for every pixel in the image, and if a gray pixel is less than that threshold, it is turned black, and if it is at least that threshold, it is turned white. This threshold can be a value fixed in advance, such as 0.5, a value between 0.0 (black) and 1.0 (white), but it is often determined dynamically according to the image’s contents using [Otsu’s method](https://en.wikipedia.org/wiki/Otsu%27s_method), which determines the value of the threshold depending on the distribution of gray values in the image.

Instead of using the same global threshold for the entire message, another approach is to apply _adaptive thresholding_. Adaptive thresholding is a more sophisticated approach that calculates a separate threshold value for each pixel depending on the values of its nearby pixels.

To test if WeChat used a global thresholding algorithm such as Otsu’s method, we created a grayscale image with 25 random keyword combinations discovered censored via WeChat’s OCR filtering. The text was light gray (intensity 0.75) on a white (intensity 1.0) background, and the right-hand side was entirely black (intensity 0.0) (see Table 4). This image was designed so that an algorithm such as Otsu’s would pick a threshold such that all of the text would be turned entirely white.

|    |    |    |
| -- | -- | -- |
| ![](https://citizenlab.ca/wp-content/uploads/2018/08/f6-1-1-300x290.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f6-2-300x290.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f6-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f6-3-300x290.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f6-3.png) |

> Table 4: Left, the original image. Centre, what the image would look like to an OCR filter performing thresholding using Otsu’s method. Right, what the image might look like to an OCR filter performing thresholding using an adaptive thresholding technique.

We first tested the image against Tesseract.js and found that this made the text invisible to the OCR algorithm. This suggested that it used a global thresholding algorithm. Upon inspecting the source code, we found that it did use a global thresholding algorithm and that it determined the global threshold using Otsu’s method. This suggests that our technique would successfully evade OCR detection on other platforms using a global thresholding algorithm.

We then uploaded the image to WeChat and found that the image was filtered and that our strategy did not evade detection. We also uploaded it to Tencent’s Cloud OCR and found that the text was detected there as well. This suggests that these two platforms do not use global thresholding, possibly using either adaptive thresholding or no thresholding at all.

### Blob merging

After thresholding, many OCR algorithms perform a step called _blob merging_. After the image has been thresholded, it is now binary, _i.e_., entirely black or white, with no intermediate shades of gray. In order to recognize each character, many OCR algorithms try to determine which blobs in an image correspond to each character. Many characters such as the English letter “i” are made up of unconnected components. In languages such as Chinese, individual characters can be made up of many unconnected components (e.g., 診). OCR algorithms use a variety of algorithms to try to combine these blobs into characters and to evaluate which combinations produce the most recognizable characters.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f7-1.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f7-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f7-2.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f7-2.png) |

> Table 5: Left, the square tiling. Right, the letter tiling.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f8-1-300x96.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f8-1.png)

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f8-2-300x96.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f8-2.png)

> Figure 4: 法轮功 (Falun Gong) patterned using squares and letters.

To test whether WeChat’s OCR filtering performed blob merging, we experimented with uploading an image that could be easily read by a person but that would be difficult to read by an algorithm piecing together blobs combinatorially. To do this, we experimented with using two different patterns to fill text instead of using solid colours. Specifically, we used a tiled square pattern and a tiled letter pattern (see Table 5 and and Figure 4), both black on white. Using these patterns causes most characters to be made up of a large amount of disconnected blobs in a way that is easily readable by most people but that is difficult for OCR algorithms performing blob merging. The second pattern that tiles English letters was designed to especially confuse an OCR algorithm by tricking it into finding the letters in the tiles as opposed to the larger characters that they compose.

To test if blobs of this type affected the OCR algorithm, we created a series of test images. We selected five lists of 25 randomly chosen keyword combinations we knew to be blocked. Randomly sampling from blocked keyword combinations, we also created five lists for each of four additional list lengths, 10, 5, 2, and 1. For each of these lists, we created two images: one with the text patterned in squares and another patterned in letters.

For images with a large number of keywords, we decrease the font size to ensure that the generated images fit within a 1000×1000 pixel image. This is to ensure that images did not become too large and to ensure that they would not be downscaled, as we had previously experienced some images that were larger than 1000×1000 downscaled by WeChat, although we did not confirm that 1000×1000 was the exact cutoff. We did this to control for any effects that downscaling the images could have on our experiment such as by blurring the text.

![](https://i.loli.net/2018/08/15/5b743caeac96d.png)

> Table 6: The number of images that evaded filtering for each test. Letter-patterned text evaded all tests, but square-patterned did not evade two of the tests with the largest number of sensitive keywords.

Our results showed that square-patterned text evaded filtering in 92% of our tests, and letter-patterned text evaded filtering in 100% of our tests (see Table 6 for a breakdown). The reason for the two failures of squares in the 25 keyword case is not clear, but there are two possibilities. One is that the higher number of keywords per image increased the probability that at least one of those keywords would not evade filtering. The second is that images with a larger number of keywords used a smaller font size, and so there were fewer blobs per character, reducing the effectiveness of the evasion strategy. Letters were more effective in evading filtering and were perfect in our testing. This may be because of the previously suggested hypothesis that the OCR filter would be distracted by the letters in the pattern and thus miss the characters of which they collectively form, but it may also be because the letters are less dense insofar as they have fewer black pixels per white. Overall, these results suggest that WeChat’s OCR filtering algorithm considers blobs when performing text recognition and that splitting characters into blobs is an effective evasion strategy.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f9.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f9.png)

> Figure 5: Output of Tencent Cloud OCR when uploading the Falun Gong image from Figure 4. The filter finds the constituent letters making up the characters, as well as other erroneous symbols, but not the characters 法轮功 themselves.

For comparison, we also tested these same images on Tesseract.js and Tencent’s Cloud OCR. For the former, the images always evaded detection, whereas in the latter the patterns often failed to evade detection, especially in larger images. We suspect that blobs are also important to Tencent’s Cloud OCR, but, as we found that these patterns did not evade detection only in larger images, we suspect that this is due to some processing such as downscaling that is being performed by Tencent’s Cloud OCR only on larger images. We predict that by increasing the distance between the blobs in larger images, we could once again evade filtering on Tencent’s Cloud OCR.

### Character classification

Most OCR algorithms ultimately determine which characters exist in an image by performing character classification based on different features extracted from the original image such as blobs, edges, lines, or pixels. The classification is often done using machine learning methods. For instance, Tencent’s Cloud OCR [advertises](https://cloud.tencent.com/product/ocr) that it uses deep learning, and Tesseract [also uses machine learning methods](https://github.com/tesseract-ocr/docs/blob/master/tesseracticdar2007.pdf) to classify each individual character.

In cases where deep neural networks are used to classify images, researchers have developed ways of adversarially creating images that appear to people as one thing but that trick the neural networks into classifying the image under an unrelated category; however, this work does not typically focus on OCR-related networks. [One recent work](https://arxiv.org/abs/1802.05385) was able to trick Tesseract into misreading text; however, it unfortunately required full _white-box_ assumptions (i.e., it was done with the knowledge of all Tesseract source code and its trained machine learning models) and so their methods could not be used to create adversarial inputs for a _black-box_ OCR filter such as WeChat’s where we do not have access to its source code or its trained machine learning models.

Outside of the context of OCR, researchers have developed black-box methods to estimate gradients of neural networks when one does not have direct access to them. This allows one to still trigger a misclassification by the neural network by uploading an adversarial image that appears to people as one thing but is classified as another unrelated thing by the neural network. While this would seem like an additional way to circumvent OCR filtering, the threat models assumed by even these black-box methods are often unrealistic. [A recent work capable of working under the most restrictive assumptions](https://arxiv.org/abs/1804.08598) assumes that an attacker has access to not only the network’s classifications, but the top _n_ classifications and their corresponding scores. This is unfortunately still too restrictive for WeChat’s OCR, as our only signal from WeChat’s filtering is a single bit–whether the image was filtered or not. Even Tencent’s Cloud OCR, which may share implementation details with WeChat’s OCR filtering, provides a classification score for the top result but does not provide any other scores for any other potential classifications, and so the threat model is still too restrictive.

### Filtered text content analysis

In this section we look at the nature of the text content triggering WeChat’s OCR-based filtering. Our previous research [found](https://citizenlab.ca/2016/11/wechat-china-censorship-one-app-two-systems/) that WeChat filters text chat using blacklisted keyword combinations consisting of one (_e.g.,_ “刘晓波”) or more (_e.g.,_ “六四 [+] 学生 [+] 民主运动”) keyword components, where if a message contains all components of any blacklisted keyword combination then it is filtered. We found that to implement its OCR-based image filtering WeChat also maintains a blacklist of sensitive keyword combinations but that this blacklist is different from the one used to filter text chat. Only if an image contains all components of any keyword combination blacklisted from images will it be filtered.

To help understand the scope and target of OCR-based image filtering on WeChat, in April 2018, we tested images containing keyword combinations from a sample list. This sample list was created using keyword combinations [previously found blocked](https://citizenlab.ca/2017/11/managing-message-censorship-19th-national-communist-party-congress-wechat/) in WeChat’s group text chat between September 22, 2017 and March 16, 2018, excluding any keywords that were no longer blocked in group text chat at the time of our testing. These results provide a general overview of the overlap between text chat censorship and OCR-based image censorship on WeChat.

[![](https://citizenlab.ca/wp-content/uploads/2018/08/f10-MK-1024x648.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f10-MK.png)

> Figure 6: The percentage of tested keywords blocked and not blocked on WeChat’s OCR-based image censorship by category.

Out of the 876 keyword combinations tested, we found 309 trigger OCR-based image censorship on WeChat Moments. In [previous research](https://citizenlab.ca/2016/11/wechat-china-censorship-one-app-two-systems/), we performed content analysis of keywords by manually grouping them into content categories based on contextual information. Using similar methods, we present content analysis to provide a high-level description of our keyword and image samples. Figure 6 shows the percentage of tested keyword combinations blocked and not blocked on WeChat’s OCR-based image censorship by category.

**Government Criticism**

We found that 59 out of 194 tested keyword combinations thematically related to government criticism triggered OCR-based image filtering. These include keyword combinations criticizing government officials and policy (see Table 7).

![](https://i.loli.net/2018/08/15/5b743d1ecd146.png)

> Table 7: Examples of keyword combination related to government criticism that triggered OCR-based image filtering.

The first two examples make references to China’s censorship policies: Lu Wei, the former head of the Cyberspace Administration of China (the country’s top-level Internet management office), is often [described](https://www.straitstimes.com/asia/east-asia/chinas-former-internet-czar-lu-wei-charged-with-taking-bribes) as China’s “Internet czar”; and in 2017, Freedom House [ranked](https://freedomhouse.org/report/freedom-net/2017/china) China as “the world’s worst abuser of Internet freedom” for the third year in a row. The keyword ( “盗国贼” kleptocrat) is an derogatory reference to [Wang Qishan](https://www.scmp.com/news/china/diplomacy-defence/article/2146263/chinese-vice-president-wang-qishan-given-key-foreign), the current Vice President of China whose family [has](https://www.bbc.com/zhongwen/simp/chinese-news-40345328) allegedly benefited from ties to Chinese conglomerate HNA group.

|    |    |
| -- | -- |
| [![](https://citizenlab.ca/wp-content/uploads/2018/08/f11-1-169x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f11-1.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f11-2-169x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f11-2.png) | [![](https://citizenlab.ca/wp-content/uploads/2018/08/f11-3-169x300.png)](https://citizenlab.ca/wp-content/uploads/2018/08/f11-3.png) |

> Table 8: An example of OCR-based image filtering in WeChat Moments. A user with an international account (on the right) posts an image containing the text “互联网自由 全世界 报告 最差” (Internet freedom [+] globally [+] report [+] the worst), which is hidden from the Moments’ feed of user with China account (in the middle). The image is visible in the user’s own feed as well as to another international account (on the left).

**Party Policies and Ideology**

In [previous work](https://citizenlab.ca/2017/11/managing-message-censorship-19th-national-communist-party-congress-wechat/), we found that even keyword combinations that were non-critical and that only made neutral references to CPC ideologies and central policy were blocked on WeChat. Eighteen out of 84 tested keywords made neutral references to CPC policies and triggered OCR-based image filtering (see Table 9).

![](https://i.loli.net/2018/08/15/5b743d8cd4930.png)

> Table 9: Examples of keyword combinations related to Party policies and ideology that triggered OCR-based image filtering.

**Social Activism**

Forty-eight keyword combinations in our sample set include references to protest, petition, or activist groups. We found that 21 of them triggered OCR-based image filtering (see Table 10).

![](https://i.loli.net/2018/08/15/5b743f064f251.png)

> Table 10: Examples of keyword combinations related to social activism that triggered OCR-based image filtering.

**Leadership**

[Past work](https://www.usenix.org/system/files/conference/foci17/foci17-paper-knockel.pdf)[ shows](https://citizenlab.ca/2016/11/wechat-china-censorship-one-app-two-systems/) that direct or indirect references to the name of a Party or government leader often trigger censorship. We found that among the 113 tested keyword combinations that made general references to government leadership, 21 triggered OCR-based image filtering (see Table 11). For example, we found that both the simplified and traditional Chinese version of “Premier Wang Qishan” triggered OCR-based image filtering. Around the 19th National Communist Party Congress in late 2017, there was widespread [speculation](https://www.bbc.com/zhongwen/simp/press-review-40715318) centering on whether Wang Qishan, a close ally of Xi, would assume the role of Chinese premier.

![](https://i.loli.net/2018/08/15/5b743f42a9b5f.png)

> Table 11: Examples of keyword combination related to leadership that triggered OCR-based image filtering.

**Xi Jinping**

Censorship related to President Xi Jinping has [increased](https://citizenlab.ca/2017/11/managing-message-censorship-19th-national-communist-party-congress-wechat/) in recent years on Chinese social media. The focus of censorship related to Xi warrants testing it as a single category. Among the 258 Xi Jinping-related keyword tested, 101 triggered OCR-based image censorship (see Table 12). Keywords included memes that subtly reference Xi (such as likening his appearance to Winnie the Pooh), and derogatory homonyms (吸精瓶, which literally means Semen sucking bottle).

![](https://i.loli.net/2018/08/15/5b743f74587f8.png)

> Table 12: Examples of keyword combinations related to Xi Jinping that triggered OCR-based image filtering.

**Power Struggle**

Content in this category is thematically linked to power struggles or personnel transition within the CPC. Smooth power transition has been a challenge through the CPC’s history. Rather than institutionalizing the process, personnel transitions are often influenced by [patronage networks](https://www.brookings.edu/articles/the-powerful-factions-among-chinas-rulers/) based on family ties, personal contacts, and where individuals work. We found that 40 of the 64 tested keywords in this content category triggered OCR-based image filtering (see Table 13).

![](https://i.loli.net/2018/08/15/5b743f9b719b2.png)

> Table 13: Examples of keyword combinations related to power struggle that triggered OCR-based image filtering.

**International Relations**

Forty-four keywords in our sample set include references to China’s relations with other countries. We found 18 of them triggered OCR-based image filtering (see Table 14).

![](https://i.loli.net/2018/08/15/5b743fc6d53ee.png)

> Table 14: Examples of keyword combinations related to international relations that triggered OCR-based image filtering.

**Ethnic Groups and Disputed Territories**

Content in this category includes references to Hong Kong, Taiwan, or ethnic groups such as Tibetans and Uyghurs. These issues have long been contested and are [frequently censored](https://netalert.me/harmonized-histories.html) [topics](https://citizenlab.ca/2017/01/tibetans-blocked-from-kalachakra-at-borders-and-on-wechat/) in mainland China. We found 15 out of 47 keywords tested in this category triggered OCR-based image censorship (see Table 15).

![](https://i.loli.net/2018/08/15/5b743ffa6ce96.png)

> Table 15: Examples of keyword combinations related to ethnic groups and disputed territories that triggered OCR-based image filtering.

**Events**

Content in this category references specific events such as the June 4, 1989 Tiananmen Square protest. We found that 14 of the 17 tested event-related keywords triggered OCR-based image filtering (see Table 16). Thirteen of the keywords were related to the Tiananmen Square protests. We also found references to more obscure events censored such as the [suicide](http://www.chinadaily.com.cn/china/2017-09/12/content_31905967.htm) of WePhone app founder Sun Xiangmao, who said his ex-wife Zhai Xinxin had blackmailed him into paying her 10 million RMB. Although the event attracted wide public attention and online [debates](https://www.whatsonweibo.com/questions-surrounding-tragic-suicide-wephone-founder-su-xiangmo/), it is unclear why the keyword was blocked.

![](https://i.loli.net/2018/08/15/5b74406888ce5.png)

> Table 16: Examples of keyword combinations related to events that triggered OCR-based image filtering.

**Foreign Media**

The Chinese government maintains tight control over news media, especially those owned and operated by [foreign organizations](https://foreignpolicy.com/2016/03/04/china-won-war-western-media-censorship-propaganda-communist-party/?wp_login_redirect=0). We found one out of three blocked text-based images that include names of news organizations that operate outside of China and publish critical reports on political issues (see Table 17).

![](https://i.loli.net/2018/08/15/5b7440923c6b3.png)

> Table 17: Example of keyword combinations related to foreign media that triggered OCR-based image filtering.

> * 上一篇：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-1.md)
>
> * 下一篇：[(CAN’T) PICTURE THIS: An Analysis of Image Filtering on WeChat Moments — Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/cant-picture-this-an-analysis-of-image-filtering-on-wechat-moments-3.md)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
