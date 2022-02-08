> * 原文地址：[Don’t Let Carousels Kill Your Application](https://blog.bitsrc.io/dont-let-carousels-kill-your-application-ba5ce27f6d10)
> * 原文作者：[Isuri Devindi](https://medium.com/@isuridevindi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dont-let-carousels-kill-your-application.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dont-let-carousels-kill-your-application.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[nia3y](https://github.com/nia3y)

# 别让轮播毁了你的应用程序

![](https://cdn-images-1.medium.com/max/5760/1*hRv4pMYj7sioqL2FJ2Ww8w.jpeg)

时至今日，轮播在 web 应用程序被广泛地用作为幻灯片组件，用于将一个集合中的元素循环播放。

> 虽然轮播能使你的应用程序变得独特，但它可能会造成可用性上的问题，并降低应用程序的性能。

因此，我会在这篇文章中讨论使用轮播所带来的负面影响以及解决这些问题的方法。

首先，让我们看看轮播会造成什么问题。

## 对性能的影响

一个良好的轮播应该对性能有极小的影响，甚至是没有影响。然而，如果它包含具有大型媒体资源，则可能造成用户可见的加载延迟。

造成加载延迟的原因有很多种。我们可以通过以下的核心网络指标来描述大部分的原因。

### 1. 最大内容绘制（LCP）

轮播常常包含各种尺寸、分辨率高的图片。这些图片最终会成为页面的 LCP 元素。因此，包含轮播的网站的 LCP 值可能会超过 2.5 秒（推荐值），这严重地影响了网站的加载性能。

### 2. 首次输入延迟（FID）

由于传统的轮播对于 JavaScript 的要求极低，因此他们不影响页面的交互性。话虽如此，但错误地实现轮播会导致 JavaScript 长时间运行，造成网页无响应，从而导致更高的 FID。

### 3. 累计布局偏移（CLS）

许多的轮播（尤其是自动播放的那种）都包含非合成动画。这可能会造成用户的视觉不稳定，提高了 CLS 值。

> **备注**：由于 Google 使用核心网络指标来为 web 应用程序排名，较差的指标成绩会使你的应用程序在 Google 搜索结果中排名较低。

## 对用户体验（UX）的影响

对于在有限的空间中展示多个信息，轮播似乎是一个吸引人的解决方案。然而，这对用户体验有着一些负面的影响，但在乍一看下你很难发现这些问题。

### 1. 视而不见的 Banner

轮播主要使用模仿广告设计美学的动画和布局。结果，许多用户开始忽略轮播，把它们当作广告并在其他地方寻找内容。

### 2. 可控性低

给予用户控制权是改善用户体验的基础。轮播的可控性非常糟糕，尤其是自动播放的轮播。这是因为用户必须在信息消失之前快速做出反应。

这迫使用户陷入计划外且令人困惑的交互，使他们感觉失去控制。

### 3. 不支持无障碍功能

无论网站的到访者是否有任何残疾，我们都应该公平地为他们提供服务。但是，对于识字率低或有视觉障碍的用户来说，自动播放的轮播可能难以阅读。

此外，轮播中的小箭头/图标使得移动端的用户和有障碍的人士难以导航。

![一个不佳的轮播示例。来源：[nngroup](https://www.nngroup.com/articles/auto-forwarding/)，作者：[Jakob Nielsen](https://www.nngroup.com/articles/author/jakob-nielsen/)](https://cdn-images-1.medium.com/max/3840/1*JKO7mieZ-6I_p84CI_obCw.png)

> 图中文字注解：自动播放的轮播和扩展面板组件会使用户厌烦并且降低可见度。

我想你现在已经了解了轮播对你的应用程序所带来的负面影响。

> 然而，如果你知道轮播的最佳实现和技巧，那么你便能克服这些问题。

## 优化轮播

虽然轮播影响应用程序的效能，但在某些场景下我们仍需要它们。以下的提示和技巧能帮你克服上述的问题，使得你的轮播对用户而言更具吸引力。

### 1. 选择正确的图片大小

轮播中的图片是影响网站 LCP 指标的主要因素。

> 为了将 LCP 值保持在一个可以接受的范围内，我们必须确保图片的大小不超过过 500 kB，并确保所有图片的尺寸相同。

最简单的办法是在上传轮播内的图片之前就将其进行压缩。相比于 PNG 或 JPEG 格式，JPEG 2000、JPG XR、WebP 等下一代图片格式能更好地压缩图片。

### 2. 移除渲染阻塞资源

一些用于轮播的 JavaScript 文件可能非常大，并且时常阻塞渲染。

> 在这种情况下，较好地解决办法是拆分出导致阻塞的内联 JavaScript/CSS 并进行预加载，特别是当轮播图位于主页时。

### 3. 避免将轮播链接到一个绝对布局的图层

如果轮播链接到一个绝对布局的图层，则它的位置将相对于该图层而不是容器。轮播首先需要计算它所链接到的绝对定位图层的位置，再计算自身图层的位置。

因此，这需要时间 —— 在计算出每个图层的位置之前，轮播不能显示。

> 为缩短加载时间，请避免使用链接图层。

### 4. 减少幻灯片的数量

除非轮播用于实现画廊效果，否则置放太多幻灯片的效果并不好，因为其中的大部分都会被用户忽略。另一方面，更多的幻灯片意味着更多的图层，这将对加载速度产生负面的影响。

### 5. 提供醒目的导航控件

为导览控件选择醒目的颜色和大小。

### 6. 显示导航进度

提供一些关于幻灯片数量和下一页内容的资讯。这使得用户能更轻松地浏览内容，提高用户参与度。

![在 [Hilton](https://www.hilton.com/en/) 网页上的轮播](https://cdn-images-1.medium.com/max/3786/1*B-yLIKw-RnEbHx8P7lYUcQ.png)

在上方的示例中，轮播中包含极少的幻灯片，并带有指示用户进度的导航控件。

### 7. 移动端的手势支持

在移动端上，除了传统的导览控件（例如按钮）以外，应用程序也应该支持滑动手势。

### 8. 提供替代的导览途径

轮播幻灯片中的内容应当可从其他途径访问，因为不是所有的用户都对其中的每一个内容感兴趣。

### 9. 不要使用自动播放

自动播放会分散读者的注意力，使得内容难以阅读。因此，用户更倾向于忽略它们，这导致轮播中重要内容的曝光率下降。

> 最好的解决方法是通过控件让用户自行控制导航进度。

### 10. 分离文字和图片

当轮播中图片包含文字内容时，阅读辅助功能、语言本地化和压缩率都会受到影响。

> 因此，我建议你使用 HTML 将文字单独显示。

## 总结

毫无疑问，轮播能让你的应用程序变得独特且有吸引力。然而，我们应该警惕其所带来的负面影响以避免踩坑。

因此，如果你遵循本篇文章所讨论的最佳实践，那么你就能在维持可用性和性能的情况下更好的实现轮播。

感谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
