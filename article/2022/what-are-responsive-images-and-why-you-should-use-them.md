> * 原文地址：[What Are Responsive Images And Why You Should Use Them](https://levelup.gitconnected.com/what-are-responsive-images-and-why-you-should-use-them-ac1042d6d1ff)
> * 原文作者：[Nainy Sewaney](https://medium.com/@nainysewaney)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/what-are-responsive-images-and-why-you-should-use-them.md](https://github.com/xitu/gold-miner/blob/master/article/2022/what-are-responsive-images-and-why-you-should-use-them.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[CarlosChenN](https://github.com/CarlosChenN)、[samyu2000](https://github.com/samyu2000)、[xionglong58](https://github.com/xionglong58)

# 如何在网页中使用响应式图像

![图片源自 [UX Store](https://unsplash.com/@uxstore?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/15904/0*hgrV7tfWod03eJTb)

或许你已经在网页设计领域见过响应式设计（responsive design）这个术语。

响应式设计是让你的网页在不同尺寸的设备屏幕上能得到最佳展示，也就是让你的网页能对各种屏幕尺寸自适应。

那么，什么是响应式图像呢？

响应式图像与响应式设计有什么关系吗？我们为什么要使用它们？

在本文中，我们就这些问题展开讨论。

## 什么是响应式图像

如今，图像已成为网页设计中必不可少的元素之一。

绝大多数的网站都会使用图像。

然而你是否知道，尽管你的网站布局可以适应设备尺寸，但显示的图像却不是自适应的？

无论使用何种设备（移动设备、平板或台式机），默认下载的都是相同的图像。

例如，如果图像大小为 2 MB，那么无论在何种设备上，下载的都是 2 MB 的图像数据。

开发者可以编写代码，在移动设备上显示该图像的一部分，但是仍然需要下载整个 2 MB 图像数据。

这是不合时宜的。

如果要为同一个网页下载多个图像，应该如何实现？

手机和平板上的图像本来应该是较小尺寸的，如果下载了大量较大尺寸的图像，肯定会影响性能。

我们需要为不同尺寸的设备提供不同尺寸的图像，移动设备显示小尺寸图像，平板显示中等尺寸的图像，台式机显示大尺寸的图像，该如何实现？

通过使用响应式图像，我们可以避免在较小的设备上下载不必要的图像数据，并提高网站在这些设备上的性能。

让我们看看如何实现这一目标。

## HTML 中的响应式图像

![Photo by [Gary Bendig](https://unsplash.com/@kris_ricepees?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*rVwyAfwIstLALepi)

以上面的图像为例。

这幅图像是为桌面应用设计的，在小屏幕设备上就需要对图像大小进行压缩，我们可以对这幅图像进行裁剪，而非下载完整的图像。

![Photo by [Gary Bendig](https://unsplash.com/@kris_ricepees?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/2000/1*J6RbwtrbpoMW949lWH0crA.jpeg)

我们可以在 HTML 中编写以下内容，以便在不同的尺寸屏幕中下载不同的图像。

```html
<img src="racoon.jpg" alt="Cute racoon"
     srcset="small-racoon.jpg 500w,
             medium-racoon.jpg 1000w,
             large-racoon.jpg 1500w" sizes="60vw"/>
```

让我们看下这段代码的作用。

`<img>` 标签负责在 HTML 中渲染图像，而 `src` 属性告诉浏览器默认显示哪个图像。在这种情况下，如果浏览器不支持 `srcset` 属性，则默认为 `src` 属性。

在这段代码中 `srcset` 属性是最重要的属性之一。

`srcset` 属性通知浏览器图像的合适宽度，浏览器不需要下载所有图像。通过 `srcset` 属性，浏览器决定下载哪个图像并且适应该视口宽度。

你可能还注意到 `srcset` 中每个图像大小的 `w` 描述符。

```
srcset="small-racoon.jpg 500w,
        medium-racoon.jpg 1000w,
        large-racoon.jsp 1500w"
```

上面代码片段中的 `w` 指定了 `srcset` 中图像的宽度（以像素为单位）。

还有一个 `sizes` 属性,它通知浏览器具有 `srcset` 属性的 `<img>` 元素的大小。

```
sizes="60vw"
```

在这里，`sizes` 属性的值为 `60 vw`，它告诉浏览器图像的宽度为视口的 `60%`。`size` 属性帮助浏览器从 `srcset` 中为该视口宽度选择最佳图像。

例如，如果浏览器视口宽度为 `992 px`，那么

`992 px` 的 `60%`

= `592 px`

根据上面的计算，浏览器将选择宽度为 `500 w` 或 `500 px`，最接近 `592 px` 的图像显示在屏幕上。

最终由浏览器决定选择哪个图像。

注意，为不同视口宽度选择图像的决策逻辑可能因浏览器而异，你可能会看到不同的结果。

为较小的设备下载较少的图像数据，可以让浏览器快速显示这些图像，从而提高网站的性能。

## 本文总结

网站加载缓慢的最主要原因是下载了 MB 级数据的图像。

使用响应式图像可以避免下载不必要的图像数据，从而减少网站的加载时间并提供更好的用户体验。

唯一的缺点是我们放弃了对浏览器的完全控制，让浏览器选择要在特定视口宽度下显示的图像。

每个浏览器都有不同的策略来选择适当的响应式图像。这就是为什么你可能会在不同的浏览器中，看到以相同分辨率加载的不同图像。

放弃对浏览器的控制，根据视口宽度显示图像以获得性能优势，你需要在实际应用时做权衡考虑。

---

以上就是本文全部内容，我希望通过本文，你能对响应式图像有进一步的了解，知道为什么应该考虑将它们应用于网站。

如果你有任何问题、建议或意见，请随时在下面的评论区留言分享。

感谢你的阅读！

本文参考：

Image Optimization — Addy Osmani

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
