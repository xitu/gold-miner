> * 原文地址：[Front-End Performance Checklist 2019 — 3](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> * 译者：[Starriers](https://github.com/Starriers)
> * 校对者：[Jingyuan0000](https://github.com/Jingyuan0000), [kikooo](https://github.com/kikooo)

# 2019 前端性能优化年度总结 — 第三部分

让 2019 来得更迅速吧~你正在阅读的是 2019 年前端性能优化年度总结，始于 2016。

> - [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> - [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> - **[译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)**
> - [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> - [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> - [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### 目录

- [资源优化](#资源优化)
  - [17. 使用 Brotli 或 Zopfli 来对纯文本内容进行压缩](#使用-brotli-或-zopfli-来对纯文本内容进行压缩)
  - [18. 使用响应式图像和 WebP](#使用响应式图像和-webp)
  - [19. 图像是否已经被适当优化？](#图像是否已经被适当优化)
  - [20. 视频是否已经被适当优化?](#视频是否已经被适当优化)
  - [21. 网页字体是否已经优化？](#网页字体是否已经优化)

### 资源优化

#### 17. 使用 Brotli 或 Zopfli 来对纯文本进行压缩

2015 年，Google [推出了](https://opensource.googleblog.com/2015/09/introducing-brotli-new-compression.html) [Brotli](https://github.com/google/brotli)，一种新开源的无损数据格式，现已被[所有现代浏览器所支持](http://caniuse.com/#search=brotli)。实际上，Brotli 比 Gzip 和 Deflate [有效得](https://quixdb.github.io/squash-benchmark/#results-table)[多](https://paulcalvano.com/index.php/2018/07/25/brotli-compression-how-much-will-it-reduce-your-content/)。因为它比较依赖配置，所以这种压缩可能会（非常）慢，但较慢的压缩意味着更高的压缩率。不过它解压速度很快。所以你可以[考虑 Brotli 为你的网站所节省的成本](https://tools.paulcalvano.com/compression.php)。

只有用户通过 HTTPS 访问站点时，浏览器才会接受这种格式。那代价是什么呢？Brotli 并没有预安装在一些服务器上，所以如果没有自编译 Nginx，那么配置就会相对困难。尽管如此，[它也并非是不可攻破的难题](https://www.tinywp.in/nginx-brotli/)，比如，[Apache 自 2.4.26](https://httpd.apache.org/docs/trunk/mod/mod_brotli.html) 版本起，开始逐步对它进行支持。得益于 Brotli 被众多厂商支持，许多 CDN 也开始支持它（[Akamai](https://community.akamai.com/community/web-performance/blog/2017/08/18/brotli-support-enablement-on-akamai)、[AWS](https://medium.com/@felice.geracitano/brotli-compression-delivered-from-aws-7be5b467c2e1)、[KeyCDN](https://www.keycdn.com/blog/keycdn-brotli-support)、[Fastly](https://docs.fastly.com/guides/detailed-product-descriptions/performance-optimization-package)、[Cloudlare](https://support.cloudflare.com/hc/en-us/articles/200168396-What-will-Cloudflare-compress-)、[CDN77](https://www.cdn77.com/brotli)），你甚至（结合 service worker 一起使用）[可以在不支持它的 CDN 上，启用 Brotli](http://calendar.perfplanet.com/2016/enabling-brotli-even-on-cdns-that-dont-support-it-yet/)。

在最高级别压缩时，Brotli 会非常缓慢，以至于服务器在开始发送响应前等待动态压缩资源所花费的时间，可能会抵消文件大小（被压缩后）的潜在增益。但对于静态压缩，[应该首选更高级别的压缩](https://css-tricks.com/brotli-static-compression/)。

或者，你可以考虑使用将数据编码为 Deflate、Gzip 和 Zlib 格式的 [Zopfli 的压缩算法](https://blog.codinghorror.com/zopfli-optimization-literally-free-bandwidth/)。任何普通的 Gzip 压缩资源都可以通过 Zopfli 改进的 Deflate 编码达到比 Zlib 的最大压缩率小 3% 到 8%的文件大小。问题是压缩文件大约需要耗费 80 倍的时间。这就是为什么在资源上使用 Zopfli 是个好主意，因为这些资源不会发生太大的变化，它们被设计成只压缩一次但可以下载多次。

如果可以降低动态压缩静态资源的成本，那么这种付出是值得的。Brotli 和 Zopfli 都可以用于任意纯文本的有效负载 — HTML、CSS、SVG 和 JavaScript 等。

有何对策呢？[使用最高级别的 Brotli + Gzip 来预压缩静态资源](https://css-tricks.com/brotli-static-compression/)，使用 Brotli 在 1 — 4 级中动态压缩（动态）HTML。确保服务器正确处理 Brotli 或 Gzip 的协议内容。如果你在服务器上无法安装/维护 Brotli，请使用 Zopfli。
    
#### 18. 使用响应图像和 WebP

尽量使用带有 `srcset`、`sizes` 属性的响应式图片和 `<picture>` 元素[响应式图片](https://www.smashingmagazine.com/2014/05/responsive-images-done-right-guide-picture-srcset/)。当然，你还可以通过在原生 `<picture>` 上使用 WebP 图片以及回退到 JPEG 的机制或者使用协议内容的方式中使用 [WebP 格式](https://www.smashingmagazine.com/2015/10/webp-images-and-performance/)（在 Chrome、Opera、Firefox 65、Edge 18 中都被支持的格式）（参见 Andreas Bovens 的[代码片段](https://dev.opera.com/articles/responsive-images/#different-image-types-use-case)），或者使用协议内容（`Accept` 头部）。Ire Aderinokun 也有关于[将图像转换为 WebP 图像的超详细教程](https://bitsofco.de/why-and-how-to-use-webp-images-today/)。

Sketch 原生地支持 WebP 的，可以使用 [Phtotshop 的 WebP 插件](http://telegraphics.com.au/sw/product/WebPFormat#webpformat)从 Photoshop 中导出 WebP 图像。[当然也存在其他可用的选项](https://developers.google.com/speed/webp/docs/using)。如果你正在使用 WordPress 或 Joomla，也可以使用一些扩展来帮助你自己轻松实现对 WebP 的支持，比如适用于 WordPress 的 [Optimus](https://wordpress.org/plugins/optimus/) 和 [Cache Enabler](https://wordpress.org/plugins/cache-enabler/)，[Joomla 当然也存在对应可提供支持的扩展](https://extensions.joomla.org/extension/webp/) (通过使用 [Cody Arsenault](https://css-tricks.com/comparing-novel-vs-tried-true-image-formats/))。

需要注意的是，尽管 WebP 图像文件大小[等价于 Guetzli 和 Zopfli](https://www.ctrl.blog/entry/webp-vs-guetzli-zopfli)，但它[并不支持像 JPEG 这样的渐进式渲染](https://youtu.be/jTXhYj2aCDU?t=630)，这也是用户以前通过 JPEG 可以更快地看到实际图像的原因，尽管 WebP 图像在网络中的传输速度更快。使用 JPEG，我们可以将一半甚至四分之一的数据提供给用户，然后再加载剩余数据，而不是像 WebP 那样可能会导致有不完整的图像。你应该根据自己的需求来进行取舍：使用 WebP，你可以有效减少负载，使用 JPEG，你可以提高性能感知。

在 Smashing Magazine 中，我们使用 `-opt` 后缀来为图像命名 — 比如，`brotli-compression-opt.png`；这样，当我们发现图像包含该后缀时，团队成员就会明白这个图像已经被优化过了。— **难以置信**！— Jeremy Wagner [出了一本关于 WebP 的书，写的很好](https://www.smashingmagazine.com/ebooks/the-webp-manual/)。

[![Responsive Image Breakpoints Generator](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/db62c469-bbfc-4959-839d-590abb41b64e/responsive-breakpoints-opt.png)](http://www.responsivebreakpoints.com/)

[响应式图片端点生成器](http://www.responsivebreakpoints.com/)会自动生成图像和标记。

#### 19. 图像的优化是否得当？

当你在开发 landing page 时，特定图像的加载必须很快，要确保 JPEG 是渐进加载的并且经过了 [mozJPEG] 或者 [Guetzli](https://github.com/google/guetzli) 的压缩（通过操作扫描级别来改进开始渲染的时间），Google 新开源的编码器专注于性能感知，并利用了从 Zopfli 和 WebP 中所学的优点。[唯一的缺点是](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3)：处理时间慢（每百万像素需要一分钟的 CPU）。对于 PNG 来说，我们可以使用 [Pingo](http://css-ig.net/pingo)，对于 SVG 来说，我们可以使用 [SVGO](https://www.npmjs.com/package/svgo) 或 [SVGOMG](https://jakearchibald.github.io/svgomg/)。如果你需要快速预览、复制或下载网站上的所有 SVG 资源，那么你可以尝试使用 [svg-grabber](https://chrome.google.com/webstore/detail/svg-grabber-get-all-the-s/ndakggdliegnegeclmfgodmgemdokdmg)。

虽然每一篇图像优化文章都会说，但是我还是要提醒应该保证矢量资源的干净和紧凑。要记得清理未使用的资源，删除不必要的元数据以及图稿中的路径点数量（比如 SVG 这类代码）（**感谢 Jeremy！**）

还有更高级的选项，比如：

*   使用 [Squoosh](https://squoosh.app/) 以最佳压缩级别（有损或无损）压缩。调整和操作图像。

*   使用[响应式图像断点生成器](http://www.responsivebreakpoints.com/)或 [Cloudinary](http://cloudinary.com/documentation/api_and_access_identifiers)、[Imgix](https://www.imgix.com/) 这样的服务来实现自动化图像优化。此外，在许多情况下，使用 `srcset` 和 `sizes` 可以获得最佳效果。

*   要检查响应标记的效率，你可以使用 [imaging-heap](https://github.com/filamentgroup/imaging-heap)（一个命令行工具）来检测不同视窗大小和设备像素比的效果。

*   使用 [lazysizes](https://github.com/aFarkas/lazysizes) 来延迟加载图像和 iframes，这是一个通过检测用户交互（或之后我们将讨论的 IntersectionObserver）来触发任何可见性修改的库。

*   注意默认加载的图像，它们可能永远也用不到 —— 例如，在 carousels、accordions 和 image galleries。

*   考虑根据请求类型来指定的不同图像显示以[通过 Sizes 属性切换图像](https://www.filamentgroup.com/lab/sizes-swap/)，比如，操作 `sizes` 来交换 magnifier 组件中的数据源。

*   为防止前景和背景图像的意外下载，请检查[图像下载的不一致性](https://csswizardry.com/2018/06/image-inconsistencies-how-and-when-browsers-download-images/)。

*   为了从根本上优化存储，你可以使用 Dropbox 的新[格式（Lepton）](https://github.com/dropbox/lepton)来对 JPEG 执行平均值可达到 22% 的无损压缩。

*   注意 [CSS 属性中的 `aspect-ratio` 属性](https://drafts.csswg.org/css-sizing-4/#ratios) 和 [`intrinsicsize` 属性](https://github.com/ojanvafai/intrinsicsize-attribute)，它们允许为图像设置宽高和尺寸，因此浏览器为了[避免样式错乱](https://24ways.org/2018/jank-free-image-loads/)，可以在页面加载期间提前预留一个预定义的布局槽。

*   如果你喜欢冒险，为了更快地通过网络传输图像，可以使用基于 CDN 的实时过滤器 [Edge workers](https://youtu.be/jTXhYj2aCDU?t=854) 来终止并重排 HTTP/2 流。Edge workers 使用你可以控制的 JavaScript 流模块（它们是运行在 CDN 上的，可以修改响应流），这样你就可以控制图像的传输。相对于 service worker 来说，这个过程时间稍长，因为你无法控制传输过程，但它确实适用于 Edge workers。因此，你可以在针对特定登录页面逐步保存的静态 JPEG 上使用它们。

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8422076c-6eea-4b35-a98c-b15445cb2dff/viewport-percentage-match.jpg)](https://pbs.twimg.com/media/DY1XZ28VwAAwjd8.jpg) 

[imaging-heap](https://github.com/filamentgroup/imaging-heap)（一个用于检测跨视窗大小及设备像素比的加载效率的命令行工具）的输出样例，（[图像来源](https://pbs.twimg.com/media/DY1XZ28VwAAwjd8.jpg)）（[详细预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8422076c-6eea-4b35-a98c-b15445cb2dff/viewport-percentage-match.jpg)）

响应式图像的未来可能会随着采用[客户端提示](https://cloudfour.com/thinks/responsive-images-201-client-hints/)而发生巨变。客户端提示内容是 HTTP 的请求头字段，例如 `DPR`、`Viewport-Width`、`Width`、`Save-Data`、`Accept`（指定图像格式首选项）等。它们应该告知服务器用户的浏览器、屏幕、连接等细节。因此，服务器可以决定如何用对应大小的图像来填充布局，而且只提供对应格式所需的图像。通过客户端提示，我们将资源从 HTML 标记中，迁移到客户端和服务器之间的请求响应协议中。

就像 Ilya Grigorik [说的](https://developers.google.com/web/updates/2015/09/automating-resource-selection-with-client-hints)那样，客户端提示使图像处理更加完整 —— 它们不是响应式图像的替代品。`<picture>` 在 HTML 标记中提供了必要艺术方向的控制。客户端提示为请求的图像提供注释来实现资源选择的自动化。Service Worker 为客户端提供完整的请求和响应管理功能。比如，Service Worker 可以在请求中附加新的客户端提示 header 值，重写 URL 并将图像请求指向 CDN，根据链接调整响应，用户偏好等。它不仅适用于图像资源，也适用于所有其他请求。

对于支持客户端提示的客户端，可以检测到在[图像上已经节省了 42% 的字节](https://twitter.com/igrigorik/status/1032657105998700544)和超过 70% 的 1MB+ 字节数。在 Smashing 杂志上，我们同样可以检测到已经[提高了 19-32% 的性能](https://www.smashingmagazine.com/2016/01/leaner-responsive-images-client-hints/)。不幸的是，客户端提示仍然需要[得到浏览器的支持才行](http://caniuse.com/#search=client-hints)。[Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=935216) 和 [Edge](https://dev.modern.ie/platform/status/httpclienthints/) 正在考虑对它的支持。但如果同时提供普通的响应图像标记和客户端提示的 `<meta>` 标记，浏览器将评估响应图像标记并使用客户端提示 HTTP header 请求相应的图像。

还不够？那么你可以使用[多种](http://csswizardry.com/2016/10/improving-perceived-performance-with-multiple-background-images/)[背景](https://jmperezperez.com/medium-image-progressive-loading-placeholder/)[图像](https://manu.ninja/dominant-colors-for-lazy-loading-images#tiny-thumbnails)[技术](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/)来提高图像的感知性能。请记住，[处理对比以及模糊不必要细节](https://css-tricks.com/contrast-swap-technique-improved-image-performance-css-filters/)（或删除颜色）也可以减小文件大小。你想放大一张小照片而不至于损失质量的话，可以考虑使用 [Letsenhance.io](https://letsenhance.io)。

到目前为止，这些优化只涉及基本内容。Addy Osmani 出版了一份[非常详细的关于基本图像优化的指南](https://images.guide/)，这份指南对于图像压缩和颜色管理的细节有很深入的讲解。例如，你可以模糊图像中不必要的部分（通过应用高斯模糊过滤器）来减小文件大小，甚至可以移除颜色或将图像转换为黑白来进一步缩小文件。对于背景图像，从 Photoshop 中导出的照片质量只有 0 到 10% 是完全可以接受的。[不要在 web 上使用 JPEG-XR](https://calendar.perfplanet.com/2018/dont-use-jpeg-xr-on-the-web/) — “在 CPU 上解码 JPEG-XRs 软件端这个过程会让节省字节大小这个潜在地积极影响失效，甚至更糟，尤其是在 SPAs 情况下”。

#### 20. 视频优化是否得当？

到目前为止，我们的已经讨论完了图像的相关内容，但我们避免了关于 GIF 优点的探讨。坦白说，与其加载影响渲染性能和带宽的重动画 GIF，不如选择动态 WebP（GIF 作为回退）或者用 [HTML5 videos 循环](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/replace-animated-gifs-with-video/)来替换它们。是的，[带有 `<video>` 的浏览器](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags)性能极差，而且与图像不同的是，浏览器不会预加载 `<video>` 内容，但它们往往比 GIF 更轻量级、更小。别无他法了么？那么至少我们可以通过 [Lossy GIF](https://kornel.ski/lossygif)、[gifsicle](https://github.com/kohler/gifsicle) 或 [giflossy](https://github.com/pornel/giflossy) 来有损压缩 GIF。

早期测试表明带有 `img` 标签的内联视频相较于等效的 GIF，除了文件大小问题外，[前者的显示的速度要快 20 倍，解码要快 7 倍](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/)。虽然在 [Safari 技术预览](https://developer.apple.com/safari/technology-preview/release-notes/)中声明了对 `<img src=".mp4">` 的技术支持，但是这个特性还远未普及，因此它在近期内[不会被采用](https://bugs.chromium.org/p/chromium/issues/detail?id=791658#c36)。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c987b182-0a0e-40e5-8f8d-dd81feb991f5/replace-animated-gifs.jpg)

Addy Osmani [推荐](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/replace-animated-gifs-with-video/)用循环内联视频来取代 GIF 动画。文件大小差异明显（节省了 80%）。([预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c987b182-0a0e-40e5-8f8d-dd81feb991f5/replace-animated-gifs.jpg))

前端是不停进步的领域，多年来，视频格式一直在不停改革。很长一段时间里，我们一直希望 WebM 可以成为格式的统治者，而 WebP（基本上是 WebM 视频容器中的一个静止图像）将取代过时的图像格式。尽管这些年来 WebP 和 WebM [获得了](https://caniuse.com/webp)[支持](https://caniuse.com/#feat=webm)，但我们所希望看到的突破并未发生。

在 2018，Alliance of Open Media 发布了一种名为 **AV1** 的视频格式。AV1 具有和 H.265（H.264 的改进版本）编码器类似的压缩，但与后者不同的是，AV1 是免费的。H.265 的许可证价格迫使浏览器供应商采用性能相同的 AV1：**AV1（与 H.265 一样）的压缩性能是 WebP 的两倍**。

[![AV1 Logo 2018](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b5a4354f-4a9b-420d-8979-bd7abb87aebc/av1-logo-2018-full.png)](https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/AV1_logo_2018.svg/2560px-AV1_logo_2018.svg.png) 
    
AV1 很有可能成为网络视频的终极标准。（图像来源：[Wikimedia.org](https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/AV1_logo_2018.svg/2560px-AV1_logo_2018.svg.png)）（[详细预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b5a4354f-4a9b-420d-8979-bd7abb87aebc/av1-logo-2018-full.png)）
    
事实上，目前 Apple 使用的是 HEIF 格式和 HEVC（H.265），最新的 IOS 中，所有的照片和视频都以这些格式保存，而不是纯 JPEG 格式。尽管 [HEIF](https://caniuse.com/#search=heif) 和 [HEVC（H.265）](https://caniuse.com/#search=hevc) 并没有在网上被公开使用，但[被浏览器已经开始对慢慢支持 AV1 了](https://caniuse.com/#feat=av1)。因此在你的 `<video>` 标签中可以添加 `AV1`，因为所有的浏览器供应商都会慢慢加入对它的支持。

目前来说，使用最广泛的是 H.264，由 MP4 文件提供服务，因此在提供文件之前，请确保你的 MP4 文件用 [multipass-encoding](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77) 处理过，用 [frei0r iirblur](https://yalantis.com/blog/experiments-with-ffmpeg-filters-and-frei0r-plugin-effects/) 进行了模糊处理（如果适用），[moov atom metadata](http://www.adobe.com/devnet/video/articles/mp4_movie_atom.html) 也被移动到文件头部，而你的服务器[接受字节服务](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77)。Boris Schapira 提供了 [FFmpeg 的确切说明](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77)来最大限度地优化视频。当然，提供 WebM 格式作为替代方案也会有所帮助。

视频回放性能本身就有很多内容可以研究，如果你想深入了解它的细节，可以参阅 Doug Sillar 关于[当前视频现状](https://www.smashingmagazine.com/2018/10/video-playback-on-the-web-part-1/)和[视频传输最佳实践](https://www.smashingmagazine.com/2018/10/video-playback-on-the-web-part-2/)的系列视频。包括视频传输指标、视频预加载、压缩和流媒体等详细信息。

![Zach Leatherman’s Comprehensive Guide to Font-Loading Strategies](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/eb634666-55ab-4db3-aa40-4b146a859041/font-loading-strategies-opt.png)

Zach Leatherman 的[字体加载策略综合指南](https://www.zachleat.com/web/comprehensive-webfonts/)为 web 字体传输提供了十几种选择。

#### 21. Web 字体优化过了么？

值得提出的第一个问题就是，你是否可以[首选 UI 系统字体](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/)。如果不是上述情况，那你所提供的 Web 字体很有可能包括系统字体没有使用的字形或额外的特性或者字体粗细。你可以要求字体提供方将字体分组，或者如果你使用的是开源字体，你可以使用 [Glyphhanger](https://www.afasterweb.com/2018/03/09/subsetting-fonts-with-glyphhanger/) 或 [Fontsquirrel](https://www.fontsquirrel.com/tools/webfont-generator) 自行对它们进行子集化。你甚至可以使用 Peter Müller 的 [subfont](https://github.com/Munter/subfont#readme)，一个可以自动化你整个流程的命令行工具，它可以静态分析你的页面，生成最佳 Web 字体子集，然后注入页面中。

[WOFF2 的支持性](http://caniuse.com/#search=woff2)是最好的，你可以使用 WOFF 作为不支持 WOFF2 的浏览器的备用选项 — 毕竟，系统字体对遗留的浏览器版本会更友好。Web 字体的加载有**很多，很多，很多**的选项。你可以从 Zach Leatherman 的 "[字体加载策略综合指南](https://www.zachleat.com/web/comprehensive-webfonts/)"中选择一种策略（代码片段也可以在 [Web 字体加载](https://github.com/zachleat/web-font-loading-recipes)中找到）。

现在，更好的选项应该是[使用 Critical FOFT 结合 `preload`](https://www.zachleat.com/web/comprehensive-webfonts/#critical-foft-preload) 和 ["The Compromise" 方法](https://www.zachleat.com/web/the-compromise/)。它们都使用两阶段渲染来逐步提供 Web 字体 —— 首先是使用 Web 字体快速准确地渲染页面所需的小超集，然后再异步加载剩余部分，不同的是 "The Compromise" 技术只在[字体加载事件](https://www.igvita.com/2014/01/31/optimizing-web-font-rendering-performance/#font-load-events)不受支持的的情况下才异步加载 polyfill，所以默认情况下不需要加载 polyfill。需要快速入门？Zach Leatherman 有一个 [快速入门的 23 分钟教程和案例研究](https://www.zachleat.com/web/23-minutes/)来帮助你使用字体。

一般而言，使用 `preload` 资源提示来预加载字体是个好主意，但需要在你的标记中包含 CSS 和 JavaScript 的链接。否则，字体加载会在第一次渲染时消耗时间。尽管如此，[有选择性](https://youtu.be/FbguhX3n3Uc?t=1637)地选择重要文件是个好主意。比如，渲染至关重要的文件会有助于你避免可视化和具有破坏性的文本刷新文件。总之，Zach 建议**预加载每个系列的一到两个字体**。如果这些字体不是很关键的话，延迟加载一些字体也是有意义的。

没有人喜欢等待内容的显示。使用 [`font-display` CSS 描述符](https://font-display.glitch.me/)，我们可以控制字体加载行为并使内容可被**立即**读取(`font-display: optional`)，或者几乎是**立即**被读(`font-display: swap`)。然而，如果你想[避免文本被重排](https://www.zachleat.com/web/font-display-reflow/)，我们仍然需要使用字体加载 API，尤其是 **group repaints**，或者当你使用第三方主机时。除非你可以 [用 Cloudflare workers 的 Google 字体](https://blog.cloudflare.com/fast-google-fonts-with-cloudflare-workers/)。讨论 Google 字体：考虑使用 [google-webfonts-helper](https://google-webfonts-helper.herokuapp.com/fonts)，这是一种轻松自我托管 Google 字体的方式。如果可以，那么[自行托管你的字体](https://speakerdeck.com/addyosmani/web-performance-made-easy?slide=55)会赋予你对字体最大程度的控制。

一般而言，如果你选择 `font-display: optional`，那么就[需要放弃使用](https://www.zachleat.com/web/preload-font-display-optional/) `preload`，因为它会提前触发对 Web 字体的请求（如果你有其他需要获取的关键路径资源，就会导致网络阻塞）。`preconnect` 可以更快地获取跨域字体请求，但要谨慎使用 `preload`，因为来自不同域的预加载字体会导致网络竞争。所有这些技术都包含在 Zach 的 [Web 字体加载](https://github.com/zachleat/web-font-loading-recipes)。

此外，如果用户在辅助功能首选项中启用了 [Reduce Motion](https://webkit.org/blog/7551/responsive-design-for-motion/) 或选择数据保护模式（详细内容可参阅 [`Save-Data` header](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/save-data/))，那么最好是选择不使用 Web 字体（至少是第二阶段的渲染中）。或者当用户碰巧链接速度较慢时（通过 [网络信息 API](https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API)）。

要检测 Web 字体的加载性能，可以考虑使用[**所有文本可视化**](https://noti.st/zachleat/KNaZEg/the-five-whys-of-web-font-loading-performance#s5IYiho)的度量标准（字体加载的时，所有内容立即以 Web 字体显示），以及首次渲染后的 [**Web 字体重排计数**](https://noti.st/zachleat/KNaZEg/the-five-whys-of-web-font-loading-performance#sJw0KSc)。显然，这两种指标越低，性能越好。重要的是考虑到[变量](https://alistapart.com/blog/post/variable-fonts-for-responsive-design)[字体](https://www.smashingmagazine.com/2017/09/new-font-technologies-improve-web/)[对性能的需求](https://youtu.be/FbguhX3n3Uc?t=2161)。它们为设计师提供了更大的字体选择空间，代价是单个串行请求与许多单独的文件请求相反。这个单一的请求可能会缓慢地阻止页面上的整个排版外观。不过，好的一面是，在使用可变字体的情况下，默认情况下我们将得到一个重新的文件流，因此不需要 JavaScript 对重新绘制的内容进行分组。

有没有一种完美的 Web 字体加载策略？ 子集字体为二阶段渲染做好准备，使用 `font-display` 描述符来声明它们，使用字体加载 API 对重新绘制的内容进行分组并将字体存储在持久化的 service worker 缓存中。如果有必要，你可以回到 Bram Stein 的 [Font Face Observer](https://github.com/bramstein/fontfaceobserver)。如果你有兴趣检测字体加载的性能，Andreas Marschke 研究了[使用 字体 API 和 UserTiming API 的性能](https://www.andreas-marschke.name/posts/2017/12/29/Fonts-API-UserTiming-Boomerang.html)。

最后，不要忘记加入 [`unicode-range`](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2015/august/how-to-subset-fonts-with-unicode-range/)，将一个大字体分解成更小的特定语言字体，使用 Monica Dinculescu 的 [font-style-matcher](https://meowni.ca/font-style-matcher/) 来最小化布局上的不和谐变化，这是因为回退和 Web 字体之间的大小会产生不一致。

> - [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> - [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> - **[译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)**
> - [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> - [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> - [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
