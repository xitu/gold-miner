> * 原文地址：[Improve Page Rendering Speed Using Only CSS](https://blog.bitsrc.io/improve-page-rendering-speed-using-only-css-a61667a16b2)
> * 原文作者：[Rumesh Eranga Hapuarachchi](https://medium.com/@rehrumesh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improve-page-rendering-speed-using-only-css.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improve-page-rendering-speed-using-only-css.md)
> * 译者：
> * 校对者：

# Improve Page Rendering Speed Using Only CSS

#### 4 Important CSS tips for faster page rendering

![Image by [Arek Socha](https://pixabay.com/users/qimono-1962238/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1726153) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1726153)](https://cdn-images-1.medium.com/max/2560/1*o38gRq5SvLMtgjMMo5Ph7A.jpeg)

Users love fast web apps. They expect the page to load fast and to function smoothly. If there are breaking animations or lags when scrolling, there is a high chance of users leaving your website. As a developer, you could do many things to improve the user experience. This article will focus on 4 CSS tips you can use to improve the page rendering speed.

## 1. Content-visibility

In general, most web apps have complex UI elements, and it expands beyond what the user sees in the browser view. On such occasions, we can use `content-visibility` to skip the rendering of the off-screen content. This will decrease the page rendering time drastically if you have a large amount of content off-screen.

This feature is one of the latest additions, and it is one of the most impactful features to improve rendering performance. While `content-visibility` accepts several values, we can use `content-visibility: auto;` on an element to obtain immediate performance gains.

Let's consider the following page that contains many cards with different info. While about 12 cards fit the screen, there are approximately 375 cards in the list. As you can see, the browser has taken 1037ms to render this page.

![Regular HTML page](https://cdn-images-1.medium.com/max/2256/1*8IqnZPmf3Gmw65XnMmQ6YQ.png)

As the next step, you can add `content-visibility` to all cards.

> # In this example, after adding `content-visibility` to the page, rendering time dropped to 150ms. That's more than **6x** performance improvement.

![With content-visibility](https://cdn-images-1.medium.com/max/2402/1*zL8hg1aj4ztMVDHe_W7BLQ.png)

As you can see, content-visibility is pretty powerful and highly useful to improve the page rendering time. According to the things we discussed so far, you must be thinking of it as a silver bullet for page rendering.

#### Limitations of content-visibility

However, there are few areas content-visibility falls apart. I want to highlight two points for your consideration.

* **This feature is still experimental.** 
As of this moment, Firefox (PC and Android versions), Internet Explorer (I don’t think they have plans to add this to IE) and, Safari (Mac and iOS) do not support content-visibility.
* **Issues related to scroll-bar behavior**. 
Since elements are initially rendered with 0px height, whenever you scroll down, these elements come into the screen. The actual content will be rendered, and the height of the element will be updated accordingly. This will make the scroll bar to behavior in an unintended manner.

![Scroll behavior with content-visibility](https://cdn-images-1.medium.com/max/2000/1*_PZdobRzoAhQkqG-Kq5B3A.gif)

To fix the scroll bar issue, you can use another CSS property called `contain-intrinsic-size`. It specifies the natural size of an element. Therefore the element will be rendered with the given height instead of 0px.

```
.element{
    content-visibility: auto;
    contain-intrinsic-size: 200px;
}
```

However, while experimenting, I noticed that even with `containt-intrinsic-size`, if we are having a large number of elements with `content-visibility` set to `auto` you will still have smaller scroll bar issues.

Therefore, my recommendation is to plan your layout, decompose it into a few sections and then use content-visibility on those sections for better scrollbar behavior.

---

**Tip: Share your reusable components between projects using [Bit](https://bit.dev/) ([Github](https://github.com/teambit/bit)).**

Bit makes it simple to share, document, and reuse independent components between projects**.** Use it to maximize code reuse, keep a consistent design, collaborate as a team, speed delivery, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, React Native, React, Vue, Angular, and more.

![Example: React components shared on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/2000/0*wX7aqf12JHg5d12f.gif)

---

## 2. Will-change property

Animations on the browser aren’t a new thing. Usually, these animations are rendered regularly with other elements. However, browsers can now use GPU to optimize some of these animation operations.

> # With will-change CSS property, we can indicate that the element will modify specific properties and let the browser perform necessary optimizations beforehand.

What happens underneath is that the browser will create a separate layer for the element. After that, it delegates the rendering of that element to the GPU along with other optimizations. This will result in a smoother animation as GPU acceleration take over the rendering of the animation.

Consider the following CSS class:

```
// In stylesheet
.animating-element {
  will-change: opacity;
}

// In HTML

<div class="animating-elememt">
  Animating Child elements
</div>
```

When rendering the above snippet in the browser, it will recognize the `will-change` property and optimize future opacity-related changes.

> # According to a performance benchmark done by [Maximillian Laumeister](https://www.maxlaumeister.com/articles/css-will-change-property-a-performance-case-study/), you can see that he has obtained over 120FPS rendering speed with this one-line change, which initially was at roughly 50FPS.

![Without using will-change; Image by Maximilian](https://cdn-images-1.medium.com/max/2000/0*KP2Dz1t5MCjqapBm.png)

![With will-change; Image by Maximilian](https://cdn-images-1.medium.com/max/2000/0*SM3J13ZbiJeAfmRo.png)

#### When not to use will-change

While `will-change` is intended to improve performance, it also can degrade web app performance if you misuse it.

* **Using**` will-change `**indicates that the element will change in the future.** 
So if you try to use `will-change` along with an animation simultaneously, it will not give you the optimization. Therefore, it is recommended to use will-change on the parent element and the animation on the child element.

```
.my-class{
  will-change: opacity;
}

.child-class{
  transition: opacity 1s ease-in-out;
}
```

* **Do not use elements that are not animating.** 
When you use `will-change` on an element, the browser will try to optimize it by moving the element into a new layer and handing over the transformation to the GPU. If you have nothing to transform, it will result in a waste of resources.

One last thing to keep in mind is that it is advisable to remove will-change from an element after completing all the animations.

## 3. Reducing the Render-blocking time

Today, many web apps must cater to many form factors, including PCs, Tablets, & Mobile Phones, etc. To accomplish this responsive nature, we must write new styles according to the media sizes. When it comes to the page rendering, it cannot start the rendering phase until the 
CSS Object Model (CSSOM) is ready. Depending on your web application, you may have a large stylesheet that caters to all device form factors.

> # However, suppose we split it up into multiple stylesheets depending on the form factor. In that case, we can let only the main CSS file block the critical path and have it downloaded as a high priority and let other stylesheets download in a low priority manner.

```
<link rel="stylesheet" href="styles.css">
```

![Single stylesheet](https://cdn-images-1.medium.com/max/2000/1*0LtBYTLTuUcK7J8ArX4sZA.png)

After decomposing it to multiple stylesheets:

```
<!-- style.css contains only the minimal styles needed for the page rendering -->
<link rel="stylesheet" href="styles.css" media="all" />

<!-- Following stylesheets have only the styles necessary for the form factor -->
<link rel="stylesheet" href="sm.css" media="(min-width: 20em)" /><link rel="stylesheet" href="md.css" media="(min-width: 64em)" /><link rel="stylesheet" href="lg.css" media="(min-width: 90em)" /><link rel="stylesheet" href="ex.css" media="(min-width: 120em)" /><link rel="stylesheet" href="print.css" media="print" />
```

![](https://cdn-images-1.medium.com/max/2000/1*TiCgtB6JO9Ud5v0E0XblmQ.png)

As you can see, having stylesheets decomposed according to form factors can reduce the render-blocking time.

## 4. Avoiding @import to include multiple stylesheets

With `@import`, we can include a stylesheet in another stylesheet. When we are working on a large project, having `@import` makes the code cleaner.

> # The critical fact about `@import` is that it is a blocking call as it has to make a network request to fetch the file, parse it, and include it in the stylesheet. If we have nested `@import` within stylesheets, it will hinder the rendering performance.

```
# style.css
@import url("windows.css");

# windows.css
@import url("componenets.css");
```

![Waterfall with imports](https://cdn-images-1.medium.com/max/2056/1*kmPjWDOBdfzyVLsiLYmENA.png)

Instead of using `@import` we can achieve the same with much better performance by having multiple links as it allows us to load stylesheets in parallel.

![Waterfall with linking](https://cdn-images-1.medium.com/max/2106/1*-KPFrviQosYgL1KTZUQHYw.png)

## Conclusion

Apart from the 4 areas we discussed in this article, there are few other ways we can use CSS to improve the performance of the web page. One of the recent features of CSS, `content-visibility,` looks so promising in the years to come as it gives a multi-fold performance gain with page rendering.

> # The most important thing is, we gained all the performance without writing a single statement of JavaScript.

I am confident that you can incorporate some of the above features and build better-performing web apps for end-users. I hope the article is useful and if you know any CSS tips to improve web app performance, please mention them in the comments below. Thanks!

---

## Learn More
[**Performance Metrics for Front-End Applications**
**Better UX by focusing on the right metrics**blog.bitsrc.io](https://blog.bitsrc.io/performance-metrics-for-front-end-applications-a04fdfde217a)
[**8 Performance Analysis Tools for Front-End Development**
**Recommended tools to test and analyze your frontend code performance.**blog.bitsrc.io](https://blog.bitsrc.io/performance-analysis-tools-for-front-end-development-a7b3c1488876)
[**Creating morphing animations with CSS clip-path**
**Learn how to implement morphing, a technique for transforming one appearance into another, using CSS.**blog.bitsrc.io](https://blog.bitsrc.io/creating-morphing-animations-with-css-clip-path-3c3bf5e4335f)
[**4 Ways to Remove Unused CSS**
**How to remove unused CSS to reduce your app’s bundle size and maintain a clear and simple code.**blog.bitsrc.io](https://blog.bitsrc.io/4-ways-to-remove-unused-css-647828ca629b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
