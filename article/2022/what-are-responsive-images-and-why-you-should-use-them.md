> * 原文地址：[What Are Responsive Images And Why You Should Use Them](https://levelup.gitconnected.com/what-are-responsive-images-and-why-you-should-use-them-ac1042d6d1ff)
> * 原文作者：[Nainy Sewaney](https://medium.com/@nainysewaney)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/what-are-responsive-images-and-why-you-should-use-them.md](https://github.com/xitu/gold-miner/blob/master/article/2022/what-are-responsive-images-and-why-you-should-use-them.md)
> * 译者：
> * 校对者：

# What Are Responsive Images And Why You Should Use Them

![Photo by [UX Store](https://unsplash.com/@uxstore?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/15904/0*hgrV7tfWod03eJTb)

You might have come across the term 'responsive design' in the web design world.

Responsive design is nothing but adapting your web design to display optimally on multiple screen devices and sizes. i.e., your web design **responds** to the device's dimensions.

But what are responsive images?

Do they have anything to do with responsive design, and why should we use them?

To answer these questions, let's dive right in.

## What Are Responsive Images?

In today's world, images have become the heart of web design.

It's uncommon to find a website without any images.

But do you know that although your website layout is adaptive to the device dimensions, the images displayed aren't?

No matter the device, the same image is downloaded across mobile, tablets, and desktops.

For example, if the image size is 2MB, those 2MBs of data will be downloaded across all devices.

You could decide to show a fraction of that image on mobile devices, but still, you need to download the entire 2MB image.

That's not fair now.

What if there are multiple images to download for the same webpage?

Downloading a plethora of large images meant to be displayed smaller will affect the website performance across mobiles and tablets.

What if we could have different images for different device widths like a small one for mobile, a medium-sized image for tablets and a large one for desktops?

That way, we could avoid downloading unnecessary bytes of data on smaller devices and improve the performance of our website across those devices.

Let's have a look to see how we could achieve that.

## Responsive Images In HTML

![Photo by [Gary Bendig](https://unsplash.com/@kris_ricepees?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*rVwyAfwIstLALepi)

Consider the image above.

Suppose this image is what we need to show on desktops. To cut back on downloading bytes of data on smaller devices, we could display a cropped version of it like below instead of downloading the full version of the image.

![Photo by [Gary Bendig](https://unsplash.com/@kris_ricepees?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/2000/1*J6RbwtrbpoMW949lWH0crA.jpeg)

We could write something like this in our HTML to download different images across different viewports.

```html
<img src="racoon.jpg" alt="Cute racoon"
     srcset="small-racoon.jpg 500w,
             medium-racoon.jpg 1000w,
             large-racoon.jpg 1500w" sizes="60vw"/>
```

Let's understand what this code snippet does.

The <img> tag is responsible for rendering images in HTML, and the src attribute tells the browser which image to display by default. In this case, the src attribute is defaulted to if the srcset attribute is not browser-supported.

The srcset attribute is one of prime importance here.

It informs the browser of the width of the images without the browser having to download them. After going through srcset, the browser decides which image to download and display for that viewport width.

You might also notice a 'w' descriptor for each image size in the srcset.

```
srcset="small-racoon.jpg 500w,
        medium-racoon.jpg 1000w,
        large-racoon.jsp 1500w"
```

The 'w' in the above snippet specifies **the image's width in the srcset in pixels.**

There is a sizes attribute as well. It informs the browser of the size of the \<img> element that has the srcset attribute.

```
sizes="60vw"
```

Here, the sizes attribute has a value of 60vw, which tells the browser that the image will be at 60% of the viewport width. The sizes attribute assists the browser in choosing the best possible image from the srcset for that viewport width.

For example, if the browser viewport width is at 992px, then

60% of 992px

= 592px

As per the above calculation, the browser would then pick the image of width 500w or 500px, closest to 592px, to display on the viewport.

Ultimately it's the browser's decision regarding which image to pick.

Keep in mind that this decision-making logic of picking out images for different viewport widths might differ for browsers, and you might see varied results.

Downloading fewer bytes of data for smaller devices allows the browser to display those images quickly, which improves the performance of your website.

## Takeaway

The most significant cause of slow loading websites is downloading images which are MBs of data.

Using responsive images avoids fetching unnecessary bytes of data that improve your website's load time and provide a great user experience.

The only con is that we give up complete control to the browser to choose which image to display for specific viewport width.

Each browser has a different implementation for choosing the appropriate responsive image. That's why you might see different images loaded for the same resolution across different browsers.

Giving up control to the browser to display images as per the viewport width for performance benefits is a trade-off you might consider for your use case.

---

That's it, folks. I hope you did get a good overview of what responsive images are and why you should consider using them for your websites.

If you have any questions, suggestions, comments, feel free to share them in the comments section below.

Till then, Happy Coding!

**References:**

Image Optimization — Addy Osmani

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
