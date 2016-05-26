>* 原文链接 : [Reducing JPG File size](https://medium.com/@duhroach/reducing-jpg-file-size-e5b27df3257c#.l67l1mxg8)
* 原文作者 : [Colt McAnlis](https://medium.com/@duhroach)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


![](https://cdn-images-1.medium.com/max/2000/1*sRYE2_-ROxbzz1y1s4M9GQ.png)

### 减少 JPG 文件大小

如果你是一个现代的开发者，你一定会使用 JPG 文件，无论你是网站开发、移动开发、还是一些奇怪的系统管理程序。JPG 是你工作的一部分，并且对于用户体验有着极其重要的作用。

为什么让 JPG 文件尽量小这么重要呢？由于 [当今平均网页体积与一个 Doom（译者注：一款经典电脑游戏，中文译名：毁灭战士）游戏相当 - The Average Webpage Is Now the Size of the Original Doom](http://www.wired.com/2016/04/average-webpage-now-size-original-doom/)，你应该开始问自己网页的那么多字节都分别是从哪里来的，并且你可以怎样尽可能地减少它们的体积（不要让我从移动应用的大小开始讲...）。

虽然 [JPG 压缩令人印象深刻](https://medium.freecodecamp.com/how-jpg-works-a4dbd2316f35#.z4lekhosw)，但你如何在应用程序中_使用它_将会极大地影响文件的体积。因此我整理了一些能帮助你最大程度减小文件体积并增强用户体验的技巧。

### 你应该使用一个优化工具

当你开始看 [JPG 压缩方法](https://medium.freecodecamp.com/how-jpg-works-a4dbd2316f35)，以及 [文件格式](https://en.wikipedia.org/wiki/JPEG)，你会开始意识到，和 [PNG 文件](https://medium.com/@duhroach/reducing-png-file-size-8473480d0476)一样，JPG 文件在体积上有很大的改进空间。举个例子，你可以尝试比较用 Photoshop 直接保存的 JPG 文件和用 “储存为 web 所用格式“ 导出的文件之间的大小差异：

![](https://cdn-images-1.medium.com/max/800/1*vZF5gbyfYtDskdRr1MTZXA.png)

一个_简单的红色正方形_图片减少了大约90%的体积。和 PNG 一样，JPG 同样支持一些[数据块](https://en.wikipedia.org/wiki/JPEG#Syntax_and_structure)，这就意味着图片编辑器或是相机能够[插入非图片信息](http://dev.exiv2.org/projects/exiv2/wiki/The_Metadata_in_JPEG_files)。这就是为什么你的图片分享服务知道你在哪里[吃的最后一个华夫饼](https://www.instagram.com/bestfoodaustin/)，以及你使用什么相机[拍下了这张照片](https://exposingtheinvisible.org/resources/obtaining-evidence/image-digging)。如果你的应用程序不需要这些额外的信息，那简单地从 JPG 文件中移除它们就能对文件体积有很大的改善。

然而事实上，你可以在文件格式上[做更多](http://www.elektronik.htw-aalen.de/packjpg/_notes/PCS2007_PJPG_paper_final.pdf)。

最开始，你可以使用一些像 [JPEGMini](http://www.jpegmini.com/) 的工具，在不过度影响图片保真度的情况下进行低质量压缩，就像是 Mozilla 的 [MOZJpeg](https://github.com/mozilla/mozjpeg/)（虽然 Mozilla 申明了他们的项目可能会影响兼容性）。

另外，[jpegTran/cjpeg](http://jpegclub.org/) 试图提供无损的体积优化。而 [packJPG](http://www.elektronik.htw-aalen.de/packjpg/) 会用一种更小的形式重新打包 JPG 数据，虽然这已经是一种不同的文件格式了，并且不再与 JPG 兼容（但如果你能在客户端自己对文件进行解析，就会非常方便）。

此外，还有一大堆基于网页的工具，但是我还没有找到能比我列出来的这些工具更好用的（事实上，大多数这些基于网页的工具在后端都只是使用了上述工具）。当然 [ImageMagick](http://www.imagemagick.org/script/index.php) 有它自己的 [特性](http://www.imagemagick.org/script/mogrify.php)。

使用这些工具通常可以帮助你减少大约 15% 到 24% 的文件体积，这对于这样小的投入来说已经是一个非常不错的改进了。

### 寻找最理想的质量值

首先要声明的是：你永远都不应该把 JPG 文件的质量值设置为 100。

JPG 文件的力量来源于你能够使用一个标量来调节图片的质量与文件大小的比例。问题在于你应该如何找到图片的_正确_质量值。给你一个随机的图片，你应该如何确定最理想的设置？

正如 [imgmin](https://github.com/rflynn/imgmin) 所指出的，75 到 100 的 JPG 压缩等级只会给用户带去非常小的可感知的变化。

> _JPEG 文件的质量值在 100 到 75 之间通常只会对图片质量造成非常微小的、很不明显的改变，但是却能显著减小文件的尺寸。也就是说许多图片在 75 的质量值时看起来依然很好，但却只有 95 质量值时一般的文件大小。当质量值减小到 75 以下时，造成的视觉上的差异会扩大，而文件尺寸的节约会减少。_

因此，75 的质量值显然是一个很好的初始状态。但是我们有一个更大的问题：我们不能希望人去手工设定每张图片的质量值。

对于那些每篇上传和转发成千上万 JPG 文件的媒体应用来说，你不能期望某个人去手工调节所有图片的参数。因此，大多数开发者会创建多组质量参数，并且依赖这些参数组来压缩它们的图片。

比如说，缩略图的质量值可能是 35，因为更小的图片通常能掩盖更多的压缩损坏。而一个全屏的图片也许又有一个不同的参数来用作音乐专辑的封面等等。

你可以看到这些影响存在于整个领域中：[imgmin](https://github.com/rflynn/imgmin) 项目进一步地显示了大多数的大型网站都倾向于将他们 JPG 图片的质量值设置在 75 上下波动。

Google 图片 缩略图: 74–76  
Facebook 全尺寸图片: 85  
Yahoo 首页 JPG: 69–91  
YouTube 首页 JPG: 70–82  
Wikipedia 图片: 80  
Windows 动态背景: 82  
Twitter 用户 JPEG 图片: 30–100

**这里的问题时选取的值不完美**

通常凭空选取一个质量值并应用到整个系统中，会导致一些图片能在损失极小质量的情况下被进一步压缩，而另一些图片则由于过度压缩而看起来不那么好。质量值应该是改变的，应该为每一张图片寻找其独特的最优参数。

**What if** there was a way to measure the visual degradation that compression has on an image?  
**What if** you could test that value against the quality metric to find out if it’s a good level?  
**What if** you could automate the above two, to run on your server?

There **is**.  
Can **do**.  
Totally **possible**.

This all starts with something known as the [Psychovisual Error Threshold](http://ieeexplore.ieee.org/xpl/login.jsp?tp=&arnumber=6530010&url=http%3A%2F%2Fieeexplore.ieee.org%2Fiel7%2F6523355%2F6529997%2F06530010.pdf%3Farnumber%3D6530010), which basically denotes how much degradation can be inserted into an image before the human eye starts to notice it.

There’s a few measurements of this, notably the [PSNR](https://en.wikipedia.org/wiki/Peak_signal-to-noise_ratio) and [SSIM](https://en.wikipedia.org/wiki/Structural_similarity) metrics. Each has their own nuances with respect to evaluation measurement, which is why I rather prefer the new [Butteraugli](http://goo.gl/1ehQOi) project. After testing it on a corpus of images, I found that the metric is a lot more understandable to me in terms of visual quality.

To do this, you write a simple script to:

*   Save a JPG file at various quality values
*   Use [Butteraugli](http://goo.gl/1ehQOi) to test for the [Psychovisual Error Threshold](http://ieeexplore.ieee.org/xpl/login.jsp?tp=&arnumber=6530010&url=http%3A%2F%2Fieeexplore.ieee.org%2Fiel7%2F6523355%2F6529997%2F06530010.pdf%3Farnumber%3D6530010)
*   Stop once the output value is > 1.1
*   And save the final image using that quality value

The result is the smallest JPG file possible that doesn’t impact the PET more than significantly noticeable. For the image below, the difference is 170k in savings, but visually it looks the same.

![](https://cdn-images-1.medium.com/max/800/1*QCVqIL_ueQju40gyJGXodg.png)

Of course, you could go even further than this. Maybe your goal is to allow a lot more visual loss in order to conserve bandwidth. You could easily continue on with this, but there’s madness there. As of _right now_, the [Butteraugli](http://goo.gl/1ehQOi) denotes that any result > 1.1 is deemed “bad looking” and doesn’t try to define what any of that looks like, from a numerical authority. So you could run the script to stop once visual quality hits 2.0 (see the image below) but at that point, it’s unclear what the visual scalar is that you’re testing against.

![](https://cdn-images-1.medium.com/max/800/1*5yfAv-aFdneBAZywSUZ1Ag.png)

### Blurring Chroma

One of the reasons that JPG is so powerful, is that expects there to be little visual variance in an 8x8 block. Directly, the human eye is more attuned to visual changes in the Luminosity channel of the [YCbCr](https://en.wikipedia.org/wiki/YCbCr) image. As such, if you can reduce the amount of variation in chroma across your 8x8 blocks, you’ll end up producing less visual artifacts, and better compression. The simplest way to do this is to apply a median filter to high-contrast areas of your chroma channel. Let’s take a look at this process with the sample image below.

![](https://cdn-images-1.medium.com/max/800/1*kxVa2DEkM048to6UnUYCfA.png)

One trick here is that most photo editing programs don’t support editing in [YCbCr](https://en.wikipedia.org/wiki/YCbCr) colorspace; but they do support [LAB](https://en.wikipedia.org/wiki/Lab_color_space). The L channel represents Lightness (which is close to the Y channel, luminosity) while the A and B channels represent Red/Green and Blue/Yellow, similar components to Cb and Cr. By converting your image to LAB, you should see the following channels:

![](https://cdn-images-1.medium.com/max/800/1*VwKrI76p9IsLWhJmPQaD6Q.jpeg)

What we’d like to do is smooth out the sharp transitions in the A/B channels. Doing so will give the compressor more homogeneous values to work with. To do this, we select the areas of high detail in each of those channels, and apply a 1–3 pixel blur to that area. The result will smooth out the information significantly, without hurting the visual impact on the image much.

![](https://cdn-images-1.medium.com/max/800/1*BGquAMZw-oEEj5IH-xJEhw.jpeg)

<figcaption class="imageCaption">On the left, we see the selection mask in photoshop (we’re selecting the background houses) on the right, the result of the blur operation</figcaption>

The main point here is that by slightly blurring the A/B modes of our image, we can reduce the amount of visual variance in those channels, such that when JPG goes through its’ down sampling phase, your image gets less unique information in the CbCr channels. You can see the result of that below.

![](https://cdn-images-1.medium.com/max/800/1*sv9wBkOKWzaFIUOEiAHLLQ.png)

The top image is our source file, and the bottom, we blurred some of the Cb/CR data in the image, producing a file that’s smaller by ~50%.

### Consider WebP

At this point, [WebP](https://developers.google.com/speed/webp/) shouldn’t be news to you. I’ve been suggesting [folks use it](https://www.youtube.com/watch?v=1pkKMiDWwpM) for some time now, because it’s a really impressive codec. One of the o[riginal studies compared WebP to JPG](https://developers.google.com/speed/webp/docs/webp_study#introduction), showing that the files can be **25%-33%** smaller with the same SSIM index, which is a great amount of savings for just swapping file formats.

Regardless if you’re a web developer, or mobile developer, the support and savings from WebP denotes a firm evaluation for your pipeline.

### “Science the shit out of it”

[Thanks Mark](https://www.youtube.com/watch?v=d6lYeTWdYLw), I sent you some potatoes; LMK when they arrive.

One of the biggest problems with modern image compression is that most engineering is done in the vacuum of “the file.” That is, pixel data comes in, compressed image format goes out.

Done. Move on.

But that’s really only half the story. Modern applications consume images at various places and methods, for various needs. There is no single “one size fits all” solution, and certainly there’s opportunities to leverage the internet as a medium to transfer information.

That’s why it’s so impressive that the engineers over @ [Facebook](https://code.facebook.com/posts/991252547593574/the-technology-behind-preview-photos/) figured out a hell of a way to leverage every type of trick they could to compress their images. The result [has to be my favorite posts on the internet](https://code.facebook.com/posts/991252547593574/the-technology-behind-preview-photos/), reducing their preview photos to only 200bytes each.

![](https://cdn-images-1.medium.com/max/800/0*qFRye2GXhYIH4Vkv.)

The magic behind this solution came from a lot of analysis of the JPG header data (which they were able to remove & hard-code in the codec) alongside an aggressive Blurring & scaling process that occurs @ load time. **200 bytes is insane**. I haven’t seen anything that crazy since the [Twitter Image Encoding challenge](http://stackoverflow.com/questions/891643/twitter-image-encoding-challenge), which figured out you can evolve the [Mona Lisa using genetic programming](https://rogeralsing.com/2008/12/07/genetic-programming-evolution-of-mona-lisa/). Proof that thinking _just_ in the space of an image codec may be limiting the ability to do truly amazing things with your data compression.

### The takeaway

At the end of the day, your company needs to find a middle ground between automatic bucketing of quality values, against hand-optimizing them, and even figuring out how to compress data further. The result is going to be a reduction in cost for you to send the content, store the content, and clients to receive the content.

