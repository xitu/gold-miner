>* 原文链接 : [Reducing JPG File size](https://medium.com/@duhroach/reducing-jpg-file-size-e5b27df3257c#.l67l1mxg8)
* 原文作者 : [Colt McAnlis](https://medium.com/@duhroach)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


![](https://cdn-images-1.medium.com/max/2000/1*sRYE2_-ROxbzz1y1s4M9GQ.png)

### Reducing JPG File size

If you’re a modern developer, then you use JPG files. Doesn’t matter if you’re a web dev, mobile dev, or some weird sysadmin who just sends around memes all day. JPGs are a part of your job, and critical to the experience of the users who benefit from that work.

Which is why it’s so important to make sure these JPG files are as small as possible. With the [Average webpage size now larger than the original DOOM game](http://www.wired.com/2016/04/average-webpage-now-size-original-doom/), you have to start asking where all the bytes are coming from, and how you can do more to toss those things out (Don’t get me started on the sizes of mobile apps…).

While [JPG compression is impressive](https://medium.freecodecamp.com/how-jpg-works-a4dbd2316f35#.z4lekhosw) in its’ own right, how _you use it_ in your application can influence the size of these files significantly. As such I’ve assembled a handy collection of things that can help you squeeze out those last bits, and make a better experience for your users.

### You should be using an optimizer tool.

Once you start looking at [JPG compression methods](https://medium.freecodecamp.com/how-jpg-works-a4dbd2316f35), and the [file format](https://en.wikipedia.org/wiki/JPEG), you’ll start to realize that, much like [PNG files](https://medium.com/@duhroach/reducing-png-file-size-8473480d0476), there’s plenty of room for improvement. For example, check out the file size difference when you save a JPG from photoshop, vs “exporting for web”:

![](https://cdn-images-1.medium.com/max/800/1*vZF5gbyfYtDskdRr1MTZXA.png)

That’s around a 90% file size reduction, for a _simple red square_. See, much like PNG, JPG also supports some [chunk data in the file format](https://en.wikipedia.org/wiki/JPEG#Syntax_and_structure), which means photo editors or cameras can [insert non picture information into the file](http://dev.exiv2.org/projects/exiv2/wiki/The_Metadata_in_JPEG_files). This is why your photo sharing service knows the geolocation of the last [waffle you ate](https://www.instagram.com/bestfoodaustin/), and what camera [you took it with](https://exposingtheinvisible.org/resources/obtaining-evidence/image-digging). If your application doesn’t need this extra data, then removing it from the JPG files can yield a significant improvement.

But it turns out there’s [quite a bit](http://www.elektronik.htw-aalen.de/packjpg/_notes/PCS2007_PJPG_paper_final.pdf) more you can do with the format.

For starters, tools like [JPEGMini](http://www.jpegmini.com/) are geared towards finding lower quality (lossy) compression w/o disrupting the visual fidelity of your images too much. Which is similar to what the Mozilla folks have done with [MOZJpeg](https://github.com/mozilla/mozjpeg/) (Although they explicitly state that their project does break some compatibility).

On the other hand, [jpegTran/cjpeg](http://jpegclub.org/) attempt to provide lossless improvements to size, while [packJPG](http://www.elektronik.htw-aalen.de/packjpg/) will repack JPG data into a much smaller form, although it’s a separate file format, and not JPG compatible any more (which is handy if you can do your own decode in the client).

In addition to those, there’s a whole slew of web-based tools, but I haven’t found those to be any better than the ones listed (or rather, most of them just use the above tools behind the scenes…). And of course, [ImageMagick](http://www.imagemagick.org/script/index.php) has its’ own [bag of tricks](http://www.imagemagick.org/script/mogrify.php).

The end result is adopting these tools can often net you 15% and 24% reduction on file sizes, which is a nice improvement for a small investment.

### Find the optimal quality value.

Let’s be clear about this : you should never ship JPGs @ 100 quality.

The power of JPG comes from the fact that you can tune the quality vs file-size ratio with a scalar value. The trick, is finding out what the _correct_ quality value is for your image. Given a random image, how do you determine the ideal setting?

As the [imgmin](https://github.com/rflynn/imgmin) project points out, there’s generally only a small change in user-perceived quality for JPG compression between levels 75 and 100:

> _For an average JPEG there is a very minor, mostly insignificant change in *apparent* quality from 100–75, but a significant filesize difference for each step down. This means that many images look good to the casual viewer at quality 75, but are half as large than they would be at quality 95\. As quality drops below 75 there are larger apparent visual changes and reduced savings in filesize._

So, starting at a quality setting of 75 is an obvious initial state; but we’re missing a bigger problem here: We can’t expect people to fine-tune this value by hand.

For large media applications that upload and re-send millions of JPGs a day, you can’t expect that someone will hand-tune their values for each asset. As such, most developers create buckets of quality settings, and compress their images according to that bucket.

For example, thumbnails may have a quality setting of 35, since the smaller image hides more of the compression artifacts. And maybe full-screen profile photos get a different setting that previews of Music album covers, etc etc.

And you can see this effect live and in the field: The [imgmin](https://github.com/rflynn/imgmin) project further goes to show that most large websites tend to oscillate their images around this quality=75 mark for almost all of their JPG images:

Google Images thumbnails: 74–76  
Facebook full-size images: 85  
Yahoo frontpage JPGs: 69–91  
YouTube frontpage JPGs: 70–82  
Wikipedia images: 80  
Windows live background: 82  
Twitter user JPEG images: 30–100

**The issue here is that the values chosen aren’t ideal**.

They are usually the result of a single quality value chosen in a vacuum and then applied to all images coming through the system. In reality, some images could be compressed further with negligent quality loss, while other images will be compressed too much and not look good; The quality value should change, per-image, in order to find the ideal sweet spot.

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

