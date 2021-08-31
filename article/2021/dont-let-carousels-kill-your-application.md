> * 原文地址：[Don’t Let Carousels Kill Your Application](https://blog.bitsrc.io/dont-let-carousels-kill-your-application-ba5ce27f6d10)
> * 原文作者：[Isuri Devindi](https://medium.com/@isuridevindi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dont-let-carousels-kill-your-application.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dont-let-carousels-kill-your-application.md)
> * 译者：
> * 校对者：

# Don’t Let Carousels Kill Your Application

![](https://cdn-images-1.medium.com/max/5760/1*hRv4pMYj7sioqL2FJ2Ww8w.jpeg)

Today, carousels are widely used in web applications as a slideshow component, cycling through a collection of elements.

> Although they make your application unique, implementing carousels could cause usability issues and degrade application performance.

So, in this article, I will discuss the negative impacts of using carousels and how we can overcome them.

First, let’s see what are the issues caused by carousels.

## Impact on Performance

A well-implemented carousel should have minimal to no impact on performance. However, if it’s an image slider with large media assets, a delay in loading could be visible to the user.

The delay in loading time could be due to various reasons. And we can describe most of them using the core web vitals as follows.

### 1. LCP (Largest Contentful Paint)

Carousels often contain various sized, high-resolution images, which eventually become the page’s LCP element. As a result, the LCP value for websites containing carousels could move above the recommended value of 2.5s, adversely affecting the site’s loading performance.

### 2. FID (First Input Delay)

Since traditional carousels have minimal JavaScript requirements, they should not impact page interactivity. However, incorrect implementations of carousels might contain long-running JavaScript, which could cause unresponsive behavior for the site visitors leading to higher FIDs.

### 3. CLS (Cumulative Layout Shift)

Many carousals, especially auto-forwarding ones, have non-composited animations that could cause visual instability for users, leading to a higher CLS value.

> **Note:** Since Google uses web vitals to rank web applications, poor web vitals scores can rank your application lower in Google search results.

## Impact on UX

Carousels seem like a visually appealing solution for displaying multiple messages in a confined space. However, there are several adverse effects on User Experience, which are mostly hidden at first glance.

### 1. Banner blindness

Carousels mostly use animations and layouts that mimic the design aesthetics of banner advertisements. As a result, many users have started to completely ignore the carousel, treating them as advertisements and look elsewhere for content.

### 2. Loss of Control

Giving users control is fundamental for better UX. Carousels, especially auto-forwarding ones, often have terrible usability. This is because users are expected to act fast before a message disappears.

This forces people into unplanned and confusing interactions that make them feel like they are no longer in control.

### 3. Not Built for Accessibility

A website should be accessible to all visitors equally, regardless of any disabilities anyone may have. However, auto-forwarding carousels can be difficult to read for low-literacy or vision-impaired users.

On the other hand, carousels with small arrows or bullets make it hard for mobile users and people with accessibility issues to navigate.

![Example for a poorly implemented carousel. Source: [Article](https://www.nngroup.com/articles/auto-forwarding/) by [Jakob Nielsen](https://www.nngroup.com/articles/author/jakob-nielsen/)](https://cdn-images-1.medium.com/max/3840/1*JKO7mieZ-6I_p84CI_obCw.png)

I think now you understand the negative effects carousels can make on your application.

> But, if you know the best practices and techniques, you can easily overcome these issues.

## Making Carousels More Effective

Although carousels affect application performance, there are situations where we need them. Following tips and tricks will help you overcome the issues we discussed and make the carousel more attractive to your users.

### 1. Choose the correct image size

Images in the carousel are the main factor affecting the LCP of a website.

> To keep the LCP at an acceptable range, we must ensure that the images don’t weigh more than 500kb and keep all images at the same size.

The easiest method is to compress the carousel images before uploading them to the website. Using next-gen image formats like JPEG 2000, JPEG XR, and WebP often provides better compression than PNG or JPEG.

### 2. Eliminate render-blocking resources

Some JavaScript files used for the carousels might be pretty large and often act as render-blocking resources.

> In such situations, it is better to deliver blocking JS/CSS inline and preload carousels, specially if they are on the main page.

### 3. Avoid using linked absolute positioned layers

If the carousel is linked to an absolute layer, it’s no longer positioned from the container but a different absolute layer. The carousel first needs to calculate the position of the absolute layer it’s linked to and then start to calculate the position of the second layer to display a linked layer.

Therefore, the carousel cannot show up until every layer position is calculated, which takes time.

> Therefore, to reduce the loading time, avoid using linked layers.

### 4. Reduce the number of slides

Unless the carousel is used for a gallery, having too many slides will be inefficient because users will ignore most of them. Also, having more slides means more layers, which will negatively impact the loading speed.

### 5. Provide prominent navigation controls

Choose the color and size of the navigation controls to make them obvious for users.

### 6. Indicate navigation progress

Providing some context about the total number of slides and a preview of the upcoming content can make the navigation easier for the user and increase engagement.

![The carousel on the [Hilton](https://www.hilton.com/en/) website](https://cdn-images-1.medium.com/max/3786/1*B-yLIKw-RnEbHx8P7lYUcQ.png)

In the above example, the carousel has a minimum number of slides, with proper navigation controls that indicate the user’s progress.

### 7. Support mobile gestures

On mobile, swipe gestures should be supported in addition to traditional navigation controls (such as on-screen buttons).

### 8. Provide alternate navigation paths

The content of the carousel slides must be accessible from other routes because it’s unlikely that all users will engage with all the content in the carousel.

### 9. Don’t use autoplay

Auto-playing carousels are difficult to read and distracting. Therefore, users tend to ignore them, which could cause less exposure to the critical content in the carousel.

> The ideal solution is to have user-directed navigation via navigation controls.

### 10. Keep text and images separate

When the carousel text content is often included in the image file, it harms the accessibility, localization, and compression ratio.

> Therefore, it’s recommended to display the text separately using HTML markup.

## Conclusion

There is no doubt that carousels can make your application unique and attractive. But, we should be aware of the negative impacts so that we can avoid them.

So, if you follow the best practices discussed in this article, you will be able to implement a better carousel for your application while maintaining both usability and performance.

Thank you for Reading!!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
