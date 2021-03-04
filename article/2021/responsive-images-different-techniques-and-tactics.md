> * 原文地址：[Responsive Images: Different Techniques and Tactics](https://blog.bitsrc.io/responsive-images-different-techniques-and-tactics-6045a1fa7ea2)
> * 原文作者：[Lahiruka Wijesinghe](https://medium.com/@lahiruka_)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/responsive-images-different-techniques-and-tactics.md](https://github.com/xitu/gold-miner/blob/master/article/2021/responsive-images-different-techniques-and-tactics.md)
> * 译者：
> * 校对者：

# Responsive Images: Different Techniques and Tactics

![](https://cdn-images-1.medium.com/max/5760/1*AeGGYFx8qjpVRaSw4jPPzQ.jpeg)

Creating a responsive image isn’t rocket science. I’m sure you are already created many of those using CSS. However, the flexible size is only one factor when it comes to responsive images.

> Sometimes depending on the device type, we need to adjust the image quality and even the image type for a better user experience.

Today we can find different techniques to maintain the right quality and size. This article will explore those approaches and help you find the one that best fits your project.

## Different Approaches to Implement Responsive Images

* **Device pixel-based method**: ****This approach allows you to use multiple versions of the same image with different resolutions and choose the most suitable one to render based on the users’ screen resolution. This method is more suitable for devices that don’t render high-resolution images.
* **Fluid-image method**: By default, images are not fluid. They tend to crop or stay at a fixed size when screen size changes. With the fluid-image method, you can insert an image into a responsive layout and give the ability to stretch or scrunch as necessary.
* **Art Direction method**: Art direction is a common issue we face when dealing with different screen sizes. We can address this by altering image content, cropping down the image, or using a different image based on users’ screen size.
* **Type-switching method**: There are some browsers and devices that don’t support modern image types like WebP. The type-switching method can be used to switch between image types allowing you to serve the best content to the user based on device and browser compatibility.

Since you understand the approaches and situations where they most suit, let’s see how we can implement those methods.

---

**Tip**: Next time you create a responsive image component with the soon-to-be-learned techniques, make sure to share it using [**Bit**](https://bit.dev) ([Github](https://github.com/teambit/bit)) to make it available for reuse by other web projects.

![Explore: Components shared on [Bit.dev](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*T6i0a9d9RykUYZXNh2N-DQ.gif)

---

## Implementing Responsive Images

As mentioned earlier, there are several ways to implement responsive images, and it’s important to know the best ways to implement them to get the maximum from your effort.

By default, there are several excellent tags and attributes like `img`, `picture`, `size`and `srcset` provided by HTML for image rendering in web development. Now, I will show you how to implement the above-discussed methods using those tags and attributes in no time.

#### 1. Device Pixel-Based Method

Before going deeper, let me tell you about high-density displays. Modern flagship mobile devices such as Samsung Galaxy S10 have Density Displays of 4x, whereas some economy models may have low-density displays.

> # If we push to load a high-density image in a low-density display, it will result in a very poor user experience and a waste of resources. So, we’ll use different images for various device pixel-ratios.

In the below example, we have considered two images. The **small-kitten.jpg** with `320×240` pixels and **large-kitten.jpg** with `640×480` pixels, making the latter one suitable for high-resolution displays. (`x` descriptor shows the expected device pixel-ratio)

```
<img 
   srcset="small-kitten.jpg 1x, large-kitten.jpg 2x"
   src="small-kitten.jpg" 
   alt="A cute kitten" 
/>
```

If users’ device resolution is above 640x480 pixels, **large-kitten.jpg** will be rendered, and if not**, small-kitten.jpg** image will be rendered**.** Most importantly, the users with low res devices will not feel any delay in image loading time, while users who have high res devices will not feel any issue in image quality.

#### 2. Fluid-Image Method

This method is focused on using the same image with different sizes rather than using different images.

For example, we can implement simple fluid-images by giving image size in relative ratios rather than giving precise pixel values. The most common method used is `max-width:100%`.

```
<img 
   src=”black-dog.jpg” 
   style=”max-width: 100%; 
   height: auto;”
   alt=”Black dog image”
>
```

![The behavior of the max-width scaled image](https://cdn-images-1.medium.com/max/2000/1*qRrsflBr2ijjicwLijLZxw.gif)

> # As you can see above image is free to scale and fit the browser window size. This method will be ideal for occasions where there are large images as article headers.

Furthermore, there is an advanced method with fluid-images to compute the dimensions using the image’s width and the page’s overall width.

As an example, consider a web page with 1200px wide and an image with 500px wide. Then the calculation of how much the image takes up on the page will be as follows:

```
width of the image = image width/page width

(500/1200) x 100 = 41.66%
```

Then we can use this value as shown in the below code snippet. It will enable the image to always keep scaled with the size of the web page.

```
<img 
   src=”black-dog.jpg” 
   style=”float: right; 
   width: 41.66%;”
   alt=”Black dog image”
>
```

![The behavior of the percentage-width scaled image](https://cdn-images-1.medium.com/max/2000/1*71Fwlv3IISxAwLGUZNyFXw.gif)

> # However, this calculation might cause some issues when the viewport is too large or too small.

We can overcome this issue by adding max and min values for image width in pixels to mark upper and lower bounds.

```
<img 
   src=”black-dog.jpg” 
   style=” width: 41.66%; 
   max-width: 500px;”
   alt=”Black dog image”
>
```

#### 3. Art Direction Method

The main idea behind Art Direction is to display different images based on the screen sizes of the device. We can address this issue by switching to `picture `tag instead of using `img `tag since it allows to provide images in multiple ratios or multiple focus points when viewed on different devices.

![The famous [Cat Experiment with Art Direction Method ](https://googlechrome.github.io/samples/picture-element/)— Google Chrome](https://cdn-images-1.medium.com/max/2000/1*owaoaROx5LN6QVYe6edlEg.gif)

A simple code snippet like the below can obtain the above result. Here we provide values for 2 different attributes inside `\<source>` element; `media` and `srcset`defining image size and sources respectively.

```
<picture>
 <source media=”(min-width: 650px)” srcset=”kitten-stretching.png”>
 <source media=”(min-width: 465px)” srcset=”kitten-sitting.png”>
 
 <img src=”kitten-curled.png” alt=”A cute kitten”>
</picture>
```

In the above example, If the screen size is greater than 560px browser will show the images from the first image, and if the screen size is greater than 465px and below 650px browser will use the second image.

You’ll notice the regular `\<img>` tag as the final nested tag of the `\<picture>` element, which is crucial to make this code snippet work. It will be used as a replacement when conditions in the media query are not matching and as a backup on browsers that do not support the `\<picture>` element.

#### 4. Image Type-Switching Method

With the rapid development of technologies, different types of modern image types like `avif`, `webp`are introduced day by day. Although these image types provide a high user experience, there are some browsers that don’t support those image types yet.

> # So, we can use type switching to address such situations by changing the image format.

For example, the below code contains 2 modern image types and `gif `image. First, the browser will try `avif` format, and if that fails, it will try `webp `format. If the browser does not support both of these, it will use `png` image.

```
<picture>
   <source type="image/avif" srcset="avif-kitten.svg" />
   <source type="image/webp" srcset="webp-kitten.webp" />
   <img src="kitten.gif" alt="A cute kitten" />
</picture>
```

You can also use chrome DevTools to emulate this to see how your image will look like when the browser isn't supporting the modern image types.

![Using Chrome DevTools to emulate image-switching](https://cdn-images-1.medium.com/max/2706/1*6Ey8MZsWnVkB74lQYfOBBw.gif)

---

## Final thoughts

I believe now you have a good understanding of the methods we can use to implement responsive images and what are the situations they mostly suit.

Make sure to get the most out of this knowledge when you develop any web application since implementing responsive images in the correct way helps to provide a better user experience.

So, I invite all of you to try out these methods and share your ideas in the comment section.

Thank you for Reading !!!

---

## Learn More
[**Improve Page Rendering Speed Using Only CSS**
**4 Important CSS tips for faster page rendering**blog.bitsrc.io](https://blog.bitsrc.io/improve-page-rendering-speed-using-only-css-a61667a16b2)
[**Why You Should Use Picture Tag Instead of Img Tag**
**Resolution Switching, Art Direction, Chrome DevTools Support, and More**blog.bitsrc.io](https://blog.bitsrc.io/why-you-should-use-picture-tag-instead-of-img-tag-b9841e86bf8b)
[**Technique for Color Blind Friendly Web Apps using Chrome DevTools**
**Around 10% of people globally suffer from color vision deficiencies and it’s high time to make them accessible**blog.bitsrc.io](https://blog.bitsrc.io/technique-for-color-blind-friendly-web-apps-using-chrome-devtools-fe25d8fcb83e)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
