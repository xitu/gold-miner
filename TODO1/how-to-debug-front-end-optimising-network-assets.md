> * 原文地址：[How to debug front-end: optimising network assets](https://blog.pragmatists.com/how-to-debug-front-end-optimising-network-assets-c0bfcad29b40)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@WitkowskiMichau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-debug-front-end-optimising-network-assets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-debug-front-end-optimising-network-assets.md)
> * 译者：[stormluke](https://github.com/stormluke)
> * 校对者：[Starrier](https://github.com/Starriers)、[allenlongbaobao](https://github.com/allenlongbaobao)

# 如何调试前端：优化网络资源

![](https://cdn-images-1.medium.com/max/800/1*RD1J6kKPcfZV3MeAq-f4bA.jpeg)

网络性能可以决定 web app 的成败。最初 app 很新很小时，很少有开发者会持续关注 app 到底用了多长时间发送了多少兆字节给用户。

如果你从未测量过自己 app 的性能，那很可能会有一些改进余地。问题是，你需要改善多少才能让用户注意到。

在下面的研究中，你可以找到有关多长的加载时间差异可以被人们明显地感受到的信息。如果你想让用户注意到你的努力，那就要超过 20% 这个门槛。[阅读更多](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule)

这篇文章中，我会介绍（TL;DR）：

* 通过 Chrome Devtool Audit 来测量性能
* 图像优化
* Web 字体优化
* JavaScript 优化
* 渲染阻塞资源时的优化
* 其他性能测量应用/扩展

如果你正在努力解决这之外的一些问题，请在评论告诉所我们 —— 我们的团队和读者们很乐意提供帮助。

**这篇文章是《如何调试前端》系列的一部分：**

* [如何调试前端：HTML/CSS](https://blog.pragmatists.com/how-to-debug-front-end-elements-d97da4cbc3ea)
* [如何调试前端：控制台](https://blog.pragmatists.com/how-to-debug-front-end-console-3456e4ee5504)

### 衡量 app 的性能

#### Chrome Devtools Audits

由于整篇文章都是关于 Chrome Devtools 的，我们就先从 Audit 标签页开始（其本身使用了 Lighthouse）

打开 Chrome Devtools > Audits > Perform an audit... > Run audit

我决定检查性能（Performance）和最佳实践（Best practices），但我们这次暂不涉及渐进式 Web 应用（Progressive Web App）或无障碍性（Accessibility）主题。

![](https://cdn-images-1.medium.com/max/800/0*Vu8XSuJJ4qkaGqzQ.)

不错。一段时间后，我们完成了性能评估，并知道了一些改进这些性能指标的可行方法。如果 Audit 把屏幕分辨率调成了「移动设备」，请不必担心，因为对于 Chrome 来说这是正常的。我强烈建议你用 Chrome 金丝雀版（Canary）来执行评估。金丝雀版有个可以评估桌面版网页的选项，并且增加了网络限速功能 —— 看看下面的图片。

![](https://cdn-images-1.medium.com/max/800/0*VJ1eB8sRN7fB3Pr-.)

### 指标

![](https://cdn-images-1.medium.com/max/800/0*2OAae2UKiLFk2b6T.)

指标（Metrics）选项卡收集了基本的测量结果，并且提供了页面加载时间的总体概况。

**`首次有意义绘图（First meaningful paint）`** —— audit 确定用户首次看到主要内容所需的时间。请尽可能保持在 1 秒以下。[阅读更多](https://developers.google.com/web/fundamentals/performance/rail)

**`首次可交互（First interactive）`** —— 指首次用户看到可交互 UI 元素并且页面可以响应所需的时间。

**`感知速度指数（Perceptual Speed Index）`** —— 指显示页面可见部分的平均时间。它以毫秒表示并取决于视口的大小。请尽量保持在 1250 毫秒以下。[阅读更多](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)

**`预估输入延迟（Estimated Input Latency）`** —— 应用响应用户输入的时间，以毫秒为单位。

#### 改进点

**`改进点（Opportunities）`** —— 是一个更详细的部分，收集了有关图片、CSS 和响应时间的信息。我会介绍每个项目，并加上一些如何加速的小提示。

#### 减少阻塞渲染（render-blocking）的样式表

CSS 文件被视为渲染阻塞资源。意味着浏览器会等待它们完全加载完毕，之后才开始渲染。最简单的方法就是不加载不必要的 CSS 文件。如果你使用 bootstrap，也许你不需要整个库来样式化你的页面 —— 尤其是在项目刚开始时。

其次，你可以考虑针对不同屏幕尺寸进行优化。要降低加载 CSS 的数量级，可以使用条件加载，它只加载特定屏幕分辨率所需的 CSS 文件。下面有个例子。

```html
<link href="other.css" rel="stylesheet" media="(min-width: 40em)">
<link href="print.css" rel="stylesheet" media="print">
```

如果对你来说还不够，Keith Clark 提出了一个不阻塞页面渲染的加载 CSS 的好主意。诀窍是对媒体查询（media query）使用带有无效值的链接元素。当媒体查询结果为 false 时，浏览器仍然会下载样式表，但不会延迟渲染页面。您可以将剩余的不必要的 CSS 分离出来并稍后下载。[阅读更多](https://keithclark.co.uk/articles/loading-css-without-blocking-render/)

#### 保持较低的服务响应时间

虽然这部分可能是不言自明的，但仍值得我们提醒自己它的作用。为了减少服务器响应时间，你可以考虑为某些资源使用 CDN。也可以采用 HTTP2，或简单地删除不必要的请求，并在渲染页面后延迟加载它们。

#### 合适尺寸的图片（Properly size Images）、离屏图片（Offscreen images）和下一代格式（next-gen formats）

这三部分都与一个主题紧密相关 —— 图片。要准确了解你正在加载哪些图片以及它们所占的时间比重，请进入 Chrome Devtools 的网络选项卡并通过 IMG 选项进行过滤。通过查看大小和时间这两行，看看你是否满意这些结果。关于每个图片的大小比重并没有一般性的规则。这很大程度上取决于你的客户端设备、客户端群以及更多只有你自己才了解的情况。

![](https://cdn-images-1.medium.com/max/800/0*0QWY_H341qffDwUE.)

我想在这里更多地谈谈图片优化。在 Audit 结果中这个主题多次出现。

#### 图像优化

图片光栅图和矢量图。光栅图由像素组成。我们通常将它们用于照片和复杂的动画。扩展名：jpg、jpeg、gif。

矢量图由几何图像组成。我们将它们用于徽标和图标，因为它们可以随意缩放不失真。扩展名：svg。

#### SVG

SVG 从一开始就相对较小，但用这些优化器可以使它更小。

* [SvgOmg](https://jakearchibald.github.io/svgomg/)
* [Svg-optimiser](http://petercollingridge.appspot.com/svg-optimiser)

#### 光栅图

这里有点棘手，因为光栅图像可能非常大。有几种技术可以使它们保持较大的分辨率但仍有较小的文件大小。

#### 多张图片

首先准备多个版本的图像。你并不想在手机上加载视网膜级大小的图像，对吗？尝试制作 3 到 4 个版本的图片。手机版、平板版、桌面版和视网膜版。它们的大小取决于你的目标设备。如果你有任何疑问，请查看[链接](https://css-tricks.com/snippets/css/media-queries-for-standard-devices/)中的标准查询。

#### Srcset 属性

当你的图像准备好后，src 属性有助于定义何时加载哪些图像。

```html
<img src="ing.jpg" srcset="img.jpg, img2x.jpg 2x" alt="img">
```

`src` 给不支持 `srcset` 的浏览器用
`srcset` 给支持的浏览器用
`img2x.jpg` 给像素缩放比为 2.0 的设备用（视网膜）

```html
<img src="img.jpg" srcset="img1024.jpg 1024w, img2048.jpg 2048w" alt="img">
```

`src` 给不支持 `srcset` 的浏览器用
`srcset` 给支持的浏览器用
`img1024` 给宽度为 1024 时使用，等等.

上面的例子来自于 [Developer Mozilla](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)

#### 媒体查询

你还可以创建上面提到过的媒体查询和样式，例如平板或手机。这种方法与 CSS 预处理器同时使用时特别有效。

srcset 属性的替代品是媒体查询，它的规则不在 HTML 中，而是在 CSS 文件里。对于纯 CSS，这种方法非常耗时，不值得花时间去做。但在这里，预处理器可以通过混入（mixins）和变量来解决问题。有了预处理器后，媒体查询与 srcset 不相上下。决定权在你。

```less
@desktop:   ~"only screen and (min-width: 960px) and (max-width: 1199px)";
@tablet:    ~"only screen and (min-width: 720px) and (max-width: 959px)";

@media @desktop {
  footer {
    width: 940px;
  }
}

@media @tablet {
  footer {
    width: 768px;
  }
}
```

#### 图片 CDNs

当照片准备好并优化后，你还可以优化分发的过程。像 Cloudinary 这样的工具可以显着减少响应延迟。他们的服务器遍布全球，因此分发速度会更快。使用 HTTP 时，对于一个服务器你只能开启 6 个并行请求。使用 CDN 后，并行请求数量会随着服务器数量成倍增长。

#### 延迟加载

有时候，图片必须很花哨且很大。如果你为长时间的延迟而困扰，可以试试图片模糊化或延迟加载。

延迟加载是一种在需要时才开始加载图片或其他任何内容的方法。当图库中有 1000 个图片时，并非所有图片都需要加载。只需加载前 10 个，其余的等用户需要时再加载。

有大量的库可以做到这点。[阅读更多](https://www.sitepoint.com/five-techniques-lazy-load-images-website-performance/)

Facebook 目前正在使用图片模糊化。当你在网络不好的情况下打开某人的资料页时，刚开始图片是模糊的；后来它才变得清晰。[阅读更多](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/)

### 诊断

![](https://cdn-images-1.medium.com/max/800/0*pJgV5n0ujBTL3zhB.)

诊断页（Diagnostics）结束了这一系列测试。我不会详细介绍列表里的每一个标题，因为其中一些主题已经介绍过了。我只会提及其中的一些，并试图在整体上涵盖这些主题。

#### 对静态资源使用了低效的缓存策略

Goole 很注重缓存和无服务器应用。缓存完全取决于你，我不是缓存的忠实拥护者。如果你想了解更多缓存的东西，Google 准备了一些不错的课程。[阅读更多](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching#cache-control)

#### 关键请求链 / 阻塞渲染的脚本

关键请求链（Critical request chains）包含了需要在页面渲染前就完成的请求。保持它尽可能小至关重要。

我们之前提到了 CSS 加载，现在我们来讨论一下 Web 字体。

#### 优化 Web 字体

在创建 web 应用/网站时，目前我们使用四种字体格式：EOT、TTF、WOFF、WOFF2。

没有一种格式是最合适的，因此我们需要再次针对不同的浏览器使用不同的格式。这个主题的入门教程和更多解释在这里。[阅读更多](https://css-tricks.com/snippets/css/using-font-face/)
不过在刚开始时，最好问问自己是否真的需要使用一个 web 字体。[这里](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae)有一篇关于它的非常好的文章。

#### 字体压缩

字体是形状和路径描述的集合，用于创建字母。每个字母都是不同的，但幸运的是他们有很多共同点，所以我们可以稍微压缩一下。
由于 EOT 和 TTF 格式默认未压缩，请确保你的服务器配置了使用 GZIP。
WOFF 内置了压缩功能。请在你的服务器上使用最佳压缩设置。
WOFF2具有自定义预处理。[阅读更多](http://www.w3.org/TR/WOFF20ER/)

#### 限制字符

你是否只使用英文？请记住：不需要在字体中添加阿拉伯文或希腊文字母。你也可以使用 unicode 代码点。这使得浏览器可以将较大的 Unicode 字体拆分成较小的子集。[阅读更多](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/unicode-range)

#### 字体加载策略

加载字体会阻塞页面渲染，因为浏览器需要使用其中的所有字体来构建 DOM。字体加载策略可以防止加载延迟。字体显示（fonts-display）是策略之一，在 CSS 属性中。[阅读更多](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)

### 优化 JavaScript

#### 不必要的依赖

现在，随着 ES6 越来越重要，我们广泛使用 webpack 和 gulp。在使用库，务必记住，你并不总是需要整个库。如果你不需要引入整个 lodash，只需引入一个函数。

`import _ from 'lodash '` —— 会把整个 lodash 库加到包中

`import {map} from 'lodash'` —— 也会把整个 lodash 库加到包中，你可以使用 [lodash-webpack-plugin](https://github.com/lodash/lodash-webpack-plugin)、[babel-plugin-lodash](https://github.com/lodash/babel-plugin-lodash) 这些插件

`import map from 'lodash/map'` —— 只会把 map 模块加入包中

仔细查看框架中的 ES6 函数和你自己的函数。你不需要为每个功能都引入一个新库。要检查你的包是如何构建的，请使用下面链接中的工具。

* [Webpack bundle analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)
* [Bundle buddy](https://github.com/samccone/bundle-buddy)

#### 其他工具

当然有更多的工具来衡量你网站的性能。
其中一个是 tools.pingdom.com，它或多或少地为你提供与 Audits + Network 选项卡相似的信息。

![](https://cdn-images-1.medium.com/max/800/0*tVmtmD2cIQkhmfnO.)

我同时也推荐安装 PageSpeed Insights 这个 Chrome 扩展。它直接向你显示哪个图片需要更小点。

### 总结

本文试图向你展示如何通过减少资源的大小来使你的网站更轻盈。这只是提高网站性能的第一步。毕竟，这个领域十分广泛，并随着现代前端的发展而变化。请关注这个话题和你的竞争对手。尽量提前一步。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
