
> * 原文地址：[Designing Websites for iPhone X](https://webkit.org/blog/7929/designing-websites-for-iphone-x/)
> * 原文作者：[Timothy Horton](https://webkit.org/blog/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/designing-websites-for-iphone-x.md](https://github.com/xitu/gold-miner/blob/master/TODO/designing-websites-for-iphone-x.md)
> * 译者：[Hyde Song](https://github.com/HydeSong)
> * 校对者：[Larry](https://github.com/lampui) [Vernon](https://github.com/VernonVan)

# iPhone X 网页设计

在最新发布 iPhone X 的全面屏上，Safari 可以精美地显示现有的网站。内容自动嵌入到显示屏的安全区域内，以免被圆角、原深感摄像头系统的空间遮挡住。

凹槽部分填充了页面的 `background-color` (比如指定为 `<body>` 或 `<html>` 元素的背景颜色)，这样就和页面其余部分混合在一起。对于许多网站来说，这已经足够了。如果你的页面在背景色上只有文本和图片，那么默认的凹槽部分看起来也非常不错。

对于其他页面 —— 特别是那些设计全宽水平导航栏的页面，比如像下图的页面，可以选择稍微深入一点，充分利用新显示的功能。 [iPhone X 人机界面指南](https://developer.apple.com/ios/human-interface-guidelines/overview/iphone-x/) 详细介绍了一些通用的设计原则，并且 [UIKit 文档](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area) 讨论了原生 app 可以采用的特定机制，以确保它们看起来不错。你的网站可以利用 iOS 11 中引入的一些类似 WebKit API 来充分利用显示器边缘到边缘的特性。

在阅读这篇文章的时候，你可以点击任何图片来访问相应的 Demo 页，并查看源代码：

[![Safari's default insetting behavior](https://webkit.org/wp-content/uploads/default-inset-behavior.png)](/demos/safe-area-insets/1-default.html)

Safari 的默认内嵌行为。

## 使用整个屏幕

第一个新特性是对现有 `viewport` meta 标签的扩展，称为 [`viewport-fit`](https://www.w3.org/TR/css-round-display-1/#viewport-fit-descriptor)，它提供对嵌入行为的控制。在 iOS 11 中可以使用 `viewport-fit`。


`viewport-fit` 的默认值是 auto，会引起自动嵌入行为的效果。为了使该行为失效，并使页面全屏幕显示，你可以设置 `viewport-fit:cover` 为 `cover`。在这样做之后，我们的 `viewport` meta 标记看起来像这样：

```
<meta name='viewport' content='initial-scale=1, viewport-fit=cover'>
```

重新加载后，导航栏显示成边缘到边缘的样子，看起来好多了。然而，很明显，为什么注意系统的安全区域内嵌很重要：一些页面的内容被原深感摄像头系统的空间遮挡了，而底部的导航栏非常难以使用。

[![viewport-fit=cover](https://webkit.org/wp-content/uploads/viewport-fit-cover.png)](/demos/safe-area-insets/2-viewport-fit.html)

用 `viewport-fit=cover` 适配全面屏.

## 注意安全区域

为了在采用 `viewport-fit=cover` 之后页面还可用，下一步要做的是选择性地给包含重要内容的元素加上 padding，以确保元素不会被屏幕的形状所遮挡。生成的页面会充分利用 iPhone X 上增加的屏幕空间，同时动态调整避免四个角落、原深感摄像头系统的空间靠近主屏幕。

[![Safe and Unsafe Areas](https://webkit.org/wp-content/uploads/safe-areas.png)](/demos/safe-area-insets/safe-areas.html)

iPhone X 横屏时的安全区和非安全区（带默认内嵌数值）

为了实现这一点，iOS 11 中的 WebKit 新增了一个 [CSS 函数](https://github.com/w3c/csswg-drafts/pull/1817)，`constant()`，以及一组 [四个预定义的常量](https://github.com/w3c/csswg-drafts/pull/1819)： `safe-area-inset-left`, `safe-area-inset-right`, `safe-area-inset-top` 和 `safe-area-inset-bottom`。当合并使用时，允许样式使用每个方向的安全区域的大小。

CSS 工作组 [最近决定添加这个特性](https://github.com/w3c/csswg-drafts/issues/1693#issuecomment-330909067)，但是使用了不同的名称，请记住这一点。

`constant()` 功能类似于 `var()`，比如下面的示例，在 `padding` 属性使用：

```
.post {
    padding: 12px;
    padding-left: constant(safe-area-inset-left);
    padding-right: constant(safe-area-inset-right);
}
```

对于不支持 `constant()` 的浏览器，包含 `constant()` 的样式将被忽略。因此，重要的是要对使用 `constant()` 的样式另外使用替代样式。

[![Safe area constants](https://webkit.org/wp-content/uploads/safe-area-constants.png)](/demos/safe-area-insets/3-safe-area-constants.html)

注意安全区内嵌，使重要内容可见。

## 使用 min() 和 max() 将其全部组合在一起

本节介绍目前 iOS 11 还**没有**实现的特性。

如果在网站设计中采用 constant() 来设置安全区域，你可能会注意到，在设置安全区域时，很难指定最小的 padding。在上面的页面中，我们把 12 px 的左填充替换成 `constant(safe-area-inset-left)`，当回到竖屏时，左侧的安全区域变成了 0 px，文本立即紧靠屏幕边缘。


[![No margins](https://webkit.org/wp-content/uploads/no-margins.png)](/demos/safe-area-insets/3-safe-area-constants.html)

安全区域内嵌不能替代边距。

要解决这个问题，我们需要指定 padding 应该是默认的 padding 或安全区域中较大的那个。这可以用 [全新的 CSS 函数 `min()` 和 `max()`](https://drafts.csswg.org/css-values/#calc-notation) 来实现，这将在未来的 Safari 预览版本中提供相应的支持。两个函数都采用任意数量的参数，并返回最小值或最大值。它们可以在 `calc()` 中使用，或者嵌套在一起，这两个函数都允许像 `calc()` 一样的数学计算。

比如像下面这样的示例，可以这样使用 `max()` ：

```
@supports(padding: max(0px)) {
    .post {
        padding-left: max(12px, constant(safe-area-inset-left));
        padding-right: max(12px, constant(safe-area-inset-right));
    }
}
```

使用 @supports 来检测 min 和 max 很重要，因为并不是任何浏览器都支持，根据 CSS 的 [无效变量处理](https://drafts.csswg.org/css-variables/#invalid-variables)，**不要**在 @supports 查询中指定变量。

在示例页面中，竖屏时 `constant(safe-area-inset-left)` 解析为 0 px，因此 `max()` 解析为 12 px。横屏时，由于感应器空间的存在，设置 `constant(safe-area-inset-left)` 的值会变得更大，而 `max()` 这个函数将会解析这个大小，以确保重要内容始终可见。

[![max() with safe area insets](https://webkit.org/wp-content/uploads/max-safe-areas-insets.png)](/demos/safe-area-insets/4-min-max.html)

max() 将安全区内嵌与传统边距结合

有经验的 Web 开发人员以前可能遇到过 CSS 锁机制，通常用于将 CSS 属性设置在特定范围的值中。一起使用 `min()` 和 `max()` 会让事情变得更加容易，并且将有助于在未来实现有效的响应式设计。

## 反馈和问题

现在你可以在 [Xcode 9](https://developer.apple.com/xcode/) 中 iPhone X 模拟器的 Safari 开始采用 viewport-fit 和安全区内嵌。很乐意听到所有特性被采纳，请随时将反馈和问题发送到 [web-evangelist@apple.com](mailto:web-evangelist@apple.com) 或者在 Twitter 上 [@webkit](https://twitter.com/webkit)，并将 bug 都提交到 [WebKit 的 bug 跟踪器](https://bugs.webkit.org/)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
