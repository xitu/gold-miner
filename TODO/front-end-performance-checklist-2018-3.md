> * 原文地址：[Front-End Performance Checklist 2018 - Part 3](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：[Ryou](https://github.com/ryouaki)、[z](https://github.com/wzy816)

# 2018 前端性能优化清单 - 第 3 部分

下面是前端性能问题的其他部分，你可以参考以确保流畅的阅读本文。


- [2018 前端性能优化清单 - 第 1 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [2018 前端性能优化清单 - 第 2 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [2018 前端性能优化清单 - 第 3 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [2018 前端性能优化清单 - 第 4 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

### 静态资源优化

22. **你是使用 Brotli 还是 Zopfli 进行纯文本压缩？**

在 2005 年，[Google 推出了](https://opensource.googleblog.com/2015/09/introducing-brotli-new-compression.html) [Brotli](https://github.com/google/brotli)，一个新的开源无损数据压缩格式，现在 [被所有的现代浏览器所支持](http://caniuse.com/#search=brotli)。实际上，Brotli 比 Gzip 和 Deflate [更有效](https://samsaffron.com/archive/2016/06/15/the-current-state-of-brotli-compression)。取决于设置信息，压缩可能会非常慢。但是缓慢的压缩过程会提高压缩率，并且仍然可以快速解压。当然，解压缩速度很快。

只有当用户通过 HTTPS 访问网站时，浏览器才会采用。Brotli 现在还不能预装在某些服务器上，而且如果不自己构建 NGINX 和 UBUNTU 的话很难部署。[不过这也并不难](https://www.smashingmagazine.com/2016/10/next-generation-server-compression-with-brotli/)。实际上，[一些 CDN 是支持的](https://community.akamai.com/community/web-performance/blog/2017/08/18/brotli-support-enablement-on-akamai)，甚至 [可以也可以通过服务器在不支持 CDN 的情况下启用 Brotli](http://calendar.perfplanet.com/2016/enabling-brotli-even-on-cdns-that-dont-support-it-yet/)。

在最高级别的压缩下，Brotli 的速度会变得非常慢，以至于服务器在等待动态压缩资源时开始发送响应所花费的时间可能会使文件大小的任何潜在收益都无效。但是，对于静态压缩，[高压缩比的设置比较受欢迎](https://css-tricks.com/brotli-static-compression/) —— （**感谢 Jeremy!**）

或者，你可以考虑使用 [Zopfli 的压缩算法](https://blog.codinghorror.com/zopfli-optimization-literally-free-bandwidth/)，将数据编码为 Deflate，Gzip 和 Zlib 格式。Zopfli 改进的 Deflate 编码使得任何使用 Gzip 压缩的文件受益，因为这些文件大小比 用Zlib 最强压缩后还要小 3％ 到 8％。问题在于压缩文件的时间是原来的大约 80倍。这就是为什么虽然 使用 Zopfli 是一个好主意但是变化并不大，文件都需要设计为只压缩一次可以多次下载的。

比较好的方法是你可以绕过动态压缩静态资源的成本。Brotli 和 Zopfli 都可以用于明文传输 —— HTML，CSS，SVG，JavaScript 等。

有什么方法呢？在最高等级和 Brotli 的 1-4 级动态压缩 HTML 使用 Brotli+Gzip 预压缩静态资源。同时，检查 Brotli 是否支持 CDN，（例如 **KeyCDN，CDN77，Fastly**）。确保服务器能够使用 Brotli 或 gzip 处理内容。如果你不能安装或者维护服务器上的 Brotli，那么请使用 Zopfli。

23. **图像是否进行了适当的优化？**
尽可能通过 `srcset`，`sizes` 和 `<picture>` 元素使用 [响应式图片](https://www.smashingmagazine.com/2014/05/responsive-images-done-right-guide-picture-srcset/)。也可以通过 `<picture>` 元素使用 WebP 格式的图像（Chrom，Opera，[Firefox soon](https://bugzilla.mozilla.org/show_bug.cgi?id=1294490)支持），或者一个 JPEG 的回调（见 Andreas Bovens 的 [code snippet](https://dev.opera.com/articles/responsive-images/#different-image-types-use-case)）或者通过使用内容协商（使用 `Accept` 头信息）。

Sketch 本身就支持 WebP 并且 WebP 图像可以通过使用 [WebP 插件](http://telegraphics.com.au/sw/product/WebPFormat#webpformat) 从 PhotoShop 中导出。也有其他选择可以使用，如果你使用 WordPress 或者 Joomla，也有可以轻松支持 WebP 的扩展，例如 [Optimus](https://wordpress.org/plugins/optimus/) 和 [Cache Enabler](https://wordpress.org/plugins/cache-enabler/)（通过 [Cody Arsenault](https://css-tricks.com/comparing-novel-vs-tried-true-image-formats/)）

你可以仍然使用 [client hints](https://www.smashingmagazine.com/2016/01/leaner-responsive-images-client-hints/)，但仍需要获得一些浏览器支持。没有足够的资源支持响应式图片？使用 [断点发生器](http://www.responsivebreakpoints.com/) 或者类似 [Cloudinary](http://cloudinary.com/documentation/api_and_access_identifiers) 这样的服务自动优化图片。同样，在许多情况下，只使用 `srcset` 和 `sizes` 会有不错的效果。

On Smashing Magazine, we use the postfix `-opt` for image names — for example, `brotli-compression-opt.png`; whenever an image contains that postfix, everybody on the team knows that the image has already been optimized.

[![响应图像断点发生器](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/db62c469-bbfc-4959-839d-590abb41b64e/responsive-breakpoints-opt.png)](http://www.responsivebreakpoints.com/)

[响应图像断点生成器](http://www.responsivebreakpoints.com/)自动生成图像和标记生成。


24. **将图像优化到下一个级别**
现在有一个至关重要着陆页，有一个特定的图片的加载速度非常关键，确保 JPEGs 是渐进式的并且使用 [Adept](https://github.com/technopagan/adept-jpg-compressor)、 [mozJPEG](https://github.com/mozilla/mozjpeg) （通过操纵扫描级来改善开始渲染时间）或者 [Guetzli](https://github.com/google/guetzli) 压缩，谷歌新的开源编码器重点是能够感官的性能，并借鉴 Zopfli 和 WebP。唯一的 [不足](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) 是：处理的时间慢（每百万像素 CPU 一分钟）。至于 png，我们可以使用 [Pingo](http://css-ig.net/pingo)，和 [svgo](https://www.npmjs.com/package/svgo)，对于 SVG 的处理，我们使用 [SVGO](https://www.npmjs.com/package/svgo) 或 [SVGOMG](https://jakearchibald.github.io/svgomg/)

每一个图像优化的文章会说明，但始终保持保持矢量资产清洁总是值得提醒的。确保清理未使用的资源，删除不必要的元数据，并减少图稿中的路径点数量（从而减少SVG代码）。（**感谢，Jeremy！**）

到目前为止，这些优化只涵盖了基础知识。 Addy Osmani 已经发布了 [一个非常详细的基本图像优化指南](https://images.guide/)，深入到图像压缩和颜色管理的细节。 例如，您可以模糊图像中不必要的部分（通过对其应用高斯模糊滤镜）以减小文件大小，最终甚至可以开始移除颜色或将图像变成黑白色，以进一步缩小图像尺寸。 对于背景图像， 从Photoshop 导出的照片质量为 0 到 10％ 也是绝对可以接受的。

那么 GIF 图片呢？我们可以使用 [循环的 HTML5 视频](https://bitsofco.de/optimising-gifs/)，而不是影响渲染性能和带宽的重度 GIF 动画，而使用循环的 HTML5 视频，[`<video>`](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags) 会使得 [浏览器的性能很慢](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags)，而且与图像不同的是，浏览器不会预先加载 `<video>` 内容。 至少我们可以使用 [Lossy GIF](https://kornel.ski/lossygif), [gifsicle](https://github.com/kohler/gifsicle) 或者 [giflossy](https://github.com/pornel/giflossy) 添加有损压缩 GIF。

[好](https://developer.apple.com/safari/technology-preview/release-notes/) [消息](https://bugs.chromium.org/p/chromium/issues/detail?id=791658): 希望不久以后我们可以使用 `<img src=".mp4">` 来加载视频, 早期的测试表明 `img` 标签比同等大小的 GIF 显示的要 [快 20 多倍解析速度与要快 7 倍多](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/)。

还不够好？那么，你也可以使用 [多种](http://csswizardry.com/2016/10/improving-perceived-performance-with-multiple-background-images/) [背景](https://jmperezperez.com/medium-image-progressive-loading-placeholder/) [图像](https://manu.ninja/dominant-colors-for-lazy-loading-images#tiny-thumbnails) [技术](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/) 提高图像的感知性能。 记着，[减少对比度](https://css-tricks.com/contrast-swap-technique-improved-image-performance-css-filters/)  和模糊不必要的细节（或消除颜色）也可以减小文件的大小。 你需要放大一个小照片而不失真？考虑使用 [Letsenhance.io](https://letsenhance.io)

![Zach Leatherman的字体加载策略综合指南](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/eb634666-55ab-4db3-aa40-4b146a859041/font-loading-strategies-opt.png)

Zach Leatherman 的 [字体加载策略综合指南](https://www.zachleat.com/web/comprehensive-webfonts/) 提供了十几种更好的网页字体发送选项

25. **Web字体是否优化？**
首先需要问一个问题，你是否能不使用 [UI 系统字体](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/)。 如果不可以，那么你有很大可能使用 Web 网络字体，会包含字形和额外的功能以及用不到的加粗。 如果您使用的是开源字体（例如，通过仅包含带有某些特殊的重音字形的拉丁语），则可以只选择部分 Web 字体来减少其文件大小。

[WOFF2](http://caniuse.com/#search=woff2) 非常好，你可以使用 WOFF 和 OTF 作为不支持它的浏览器的备选。另外，从 Zach Leatherman 的《[字体加载策略综合指南](https://www.zachleat.com/web/comprehensive-webfonts/)》（代码片段也可以作为 [Web字体加载片段](https://github.com/zachleat/web-font-loading-recipes)）中选择一种策略，并使用服务器缓存持久地缓存字体。是不是感觉小有成就？Pixel Ambacht 有一个 [快速教程和案例研究](https://pixelambacht.nl/2016/font-awesome-fixed/)，让你的字体按顺序排列。

如果你无法从你的服务器拿到字体并依赖于第三方主机，请确保使用 [字体加载事件](https://www.igvita.com/2014/01/31/optimizing-web-font-rendering-performance/#font-load-events)（或对不支持它的浏览器使用 [Web字体加载器](https://github.com/typekit/webfontloader)）[FOUT 要优于 FOIT](https://www.filamentgroup.com/lab/font-events.html); 立即开始渲染文本，并异步加载字体 —— 也可以使用 [loadCSS](https://github.com/filamentgroup/loadCSS)。 你也可以 [摆脱本地安装的操作系统字体](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/)，也可以使用 [可变的](https://alistapart.com/blog/post/variable-fonts-for-responsive-design) [字体](https://www.smashingmagazine.com/2017/09/new-font-technologies-improve-web/)。

怎么才能是一个无漏洞的字体加载策略？ 从 `font-display` 开始，然后回到 Font Loading API，**然后**回到 Bram Stein 的 [Font Face Observer](https://github.com/bramstein/fontfaceobserver)（**感谢 Jeremy！**）如果你有兴趣从用户的角度来衡量字体加载的性能， Andreas Marschke 探索了 [使用 Font API 和 UserTiming API 进行性能跟踪](ttps://www.andreas-marschke.name/posts/2017/12/29/Fonts-API-UserTiming-Boomerang.html)

此外，不要忘记包含 [`font-display：optional`](https://font-display.glitch.me/) 描述符来提供弹性和快速的字体回退，[`unicode-range`](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2015/august/how-to-subset-fonts-with-unicode-range/) 将大字体分解成更小的语言特定的字体，以及Monica Dinculescu [的字体样式匹配器](https://meowni.ca/font-style-matcher/) 用来解决由于两种字体之间的大小差异，最大限度地减少了布局上的震动的问题。


### 交付优化

26. **你是否异步加载 JavaScript？**
当用户请求页面时，浏览器获取 HTML 并构造 DOM，然后获取 CSS 并构造 CSSOM，然后通过匹配 DOM 和 CSSOM 生成一个渲染树。如果有任何的 JavaScript 需要解决，浏览器将不会开始渲染页面，直到 JavaScript 解决完毕，这样就会延迟渲染。 作为开发人员，我们必须明确告诉浏览器不要等待并立即开始渲染页面。 为脚本执行此操作的方法是使用 HTML 中的 `defer` 和 `async` 属性。

事实证明，我们 [应该把 `defer` 改为 `async`](http://calendar.perfplanet.com/2016/prefer-defer-over-async/)（因为 ie9 及以下不支持 async）。 另外，如上所述，限制第三方库和脚本的影响，特别是使用社交共享按钮和嵌入的 `<iframe>` 嵌入（如地图）。 [大小限制](https://github.com/ai/size-limit) 有助于防止 JavaScript 库过大：如果您不小心添加了大量依赖项，该工具将通知你并抛出错误。 您可以使用 [静态社交分享按钮](https://www.savjee.be/2015/01/Creating-static-social-share-buttons/)（如通过 [SSBG](https://simplesharingbuttons.com) ）和 [静态链接](https://developers.google.com/maps/documentation/static-maps/intro) 来代替交互式地图。

27. **你是否懒加载了开销很大并使用 Intersection Observer 的代码？**
如果您需要延迟加载图片、视频、广告脚本、A/B 测试脚本或任何其他资源，则可以使用 [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API)，它提供了一种方法异步观察目标元素与 祖先元素或顶层文档的视口。基本上，你需要创建一个新的 IntersectionObserver 对象，它接收一个回调函数和一组选项。 然后我们添加一个目标来观察。

当目标变得可见或不可见时执行回调函数，所以当它拦截视口时，可以在元素变得可见之前开始采取一些行动。 事实上，我们可以精确地控制观察者的回调何时被调用，使用 `rootMargin`（根边缘）和 `threshold`（一个数字或者一个数字数组来表示目标可见度的百分比， 瞄准）。Alejandro Garcia Anglada 发表了一个 [简单的教程](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) 关于如何实际实施的方便教程。

你甚至可以通过向你的网页添加 [渐进式图片加载](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) 来将其提升到新的水平。 与 Facebook，Pinterest 和 Medium 类似，你可以首先加载低质量或模糊的图像，然后在页面继续加载时，使用 Guy Podjarny 提出的 [LQIP (Low Quality Image Placeholders) technique](https://www.guypo.com/introducing-lqip-low-quality-image-placeholders/)（低质量图像占位符）技术替换它们的全部质量版本。

如果技术提高了用户体验，观点就不一样了，但它肯定会提高第一次有意义的绘画的时间。我们甚至可以通过使用 [SQIP](https://github.com/technopagan/sqip) 创建图像的低质量版本作为 SVG 占位符来实现自动化。 这些占位符可以嵌入 HTML 中，因为它们自然可以用文本压缩方法压缩。 Dean Hume 在他的文章中 [描述了](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) 如何使用相交观测器来实现这种技术。

浏览器支持成都如何呢？[Decent](https://caniuse.com/#feat=intersectionobserver)，与 Chrome，火狐，Edge 和 Samsung Internet 已经支持了。 WebKit 目前 [正在开发中](https://webkit.org/status/#specification-intersection-observer)。如果浏览器不支持呢？ 如果不支持交叉点观察者，我们仍然可以 [延迟加载](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) 一个 [polyfill](https://github.com/jeremenichelli/intersection-observer-polyfill) 或立即加载图像。甚至还有一个 [library](https://github.com/ApoorvSaxena/lozad.js)。

通常，我们会使用懒加载来处理所有代价较大的组件，如 字体，JavaScript，轮播，视频和 iframe。 你甚至可以根据网络质量调整内容服务。[网络信息 API](https://googlechrome.github.io/samples/network-information/)，特别是 `navigator.connection.effectiveType`（Chrome 62+）使用 RTT 和下行链路值来更准确地表示连接和用户可以处理的数据。 您可以使用它来完全删除视频自动播放，背景图片或 Web 字体，以便连接速度太慢。

28. **你是否优先加载关键的 CSS？**
为确保浏览器尽快开始渲染页面，[通常](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) 会收集开始渲染页面的第一个可见部分所需的所有 CSS（称为 “关键CSS” 或 “上一层CSS”）并将其内联添加到页面的 `<head>` 中，从而减少往返。 由于在慢启动阶段交换包的大小有限，所以关键 CSS 的预算大约是 14 KB。

如果超出这个范围，浏览器将需要额外往返取得更多样式。  [CriticalCSS](https://github.com/filamentgroup/criticalCSS) 和 [Critical](https://github.com/addyosmani/critical) 可以做到这一点。 你可能需要为你使用的每个模板执行此操作。 如果可能的话，考虑使用 Filament Group 使用的 [条件内联方法](https://www.filamentgroup.com/lab/modernizing-delivery.html)。

使用 HTTP/2，关键 CSS 可以存储在一个单独的 CSS 文件中，并通过 [服务器推送](https://www.filamentgroup.com/lab/modernizing-delivery.html) 来传递，而不会增大 HTML 的大小。 问题在于，服务器推送是很 [麻烦](https://twitter.com/jaffathecake/status/867699157150117888)，因为浏览器中存在许多问题和竞争条件。 它一直不被支持，并有一些缓存问题（参见 [Hooman Beheshti介绍的文章]([Hooman Beheshti's presentation](http://www.slideshare.net/Fastly/http2-what-no-one-is-telling-you)) 114 页内容）。事实上，这种影响可能是 [负面的](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/)，会使网络缓冲区膨胀，从而阻止文档中的真实帧被传送。 而且，由于 TCP 启动缓慢，似乎服务器推送在热连接上 [更加有效](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit)。

即使使用 HTTP/1，将关键 CSS 放在根目录上的单独文件中也是有 [好处的](http://www.jonathanklein.net/2014/02/revisiting-cookieless-domain.html)，有时甚至比缓存和内联更为有效。 Chrome 请求这个页面的时候会再发送一个 HTTP 连接到根目录，从而不需要 TCP 连接来获取这个 CSS（**感谢 Philip！**）

需要注意的一点是：和 `preload` 不同的是，`preload` 可以触发来自任何域的预加载，而你只能从你自己的域或你所授权的域中推送资源。 一旦服务器得到来自客户端的第一个请求，就可以启动它。 服务器将资源压入 Push 缓存，并在连接终止时被删除。 但是，由于可以在多个选项卡之间重复使用 HTTP/2 连接，所以推送的资源也可以被来自其他选项卡的请求声明（**感谢 Inian！**）。

目前，服务器并没有一个简答的方法得知被推送的资源 [是否已经存在于用户的缓存中](https://blog.yoav.ws/tale-of-four-caches/)，因此每个用户的访问都会继续推送资源。因此，您可能需要创建一个 [缓存监测 HTTP/2 服务器推送机制](https://css-tricks.com/cache-aware-server-push/)。如果被提取，您可以尝试从缓存中获取它们，这样可以避免再次推送。

但请记住，[新的 `cache-digest` 规范](http://calendar.perfplanet.com/2016/cache-digests-http2-server-push/) 无需手动建立这样的 “缓存感知” 的服务器，基本上在 HTTP/2 中声明的一个新的帧类型就可以表达该主机的内容。因此，它对于 CDN 也是特别有用的。

对于动态内容，当服务器需要一些时间来生成响应时，浏览器无法发出任何请求，因为它不知道页面可能引用的任何子资源。 在这种情况下，我们可以预热连接并增加 TCP 拥塞窗口大小，以便将来的请求可以更快地完成。 而且，所有内联配置对于服务器推送都是较好的选择。事实上，Inian Parameshwaran 对 [HTTP/2 Push 和 HTTP Preload 进行了比较 深入的研究](https://dexecure.com/blog/http2-push-vs-http-preload/)，内容很不错，其中包含了您可能需要的所有细节。服务器到底是推送还是不推送呢？你可以阅读一下 Colin Bendell 的  [Should I Push?](https://shouldipush.com/)。

底线：正如 Sam Saccone [所说](https://medium.com/@samccone/performance-futures-bundling-281543d9a0d5)，`preload` 有利于将资产的开始下载时间更接近初始请求， 而服务器推送是一个完整的 RTT（或 [更多](https://blog.yoav.ws/being_pushy/)，这取决于您的服务器反应时间 —— 如果你有一个服务器可以防止不必要的推送。

<figure class="video-container break-out"><iframe data-src="https://www.youtube.com/embed/Cjo9iq8k-bc" width="600" height="480" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

你使用 [流响应](https://jakearchibald.com/2016/streams-ftw/) 吗？通过流，在初始导航请求中呈现的 HTML 可以充分利用浏览器的流式 HTML 解析器。

29. **你使用流响应吗?**
[streams](https://streams.spec.whatwg.org/) 经常被遗忘和忽略，它提供了异步读取或写入数据块的接口，在任何给定的时间内，只有一部分数据可能在内存中可用。 基本上，只要第一个数据块可用，它们就允许原始请求的页面开始处理响应，并使用针对流进行优化的解析器逐步显示内容。

我们可以从多个来源创建一个流。例如，您可以让服务器构建一个壳子来自于缓存，内容来自网络的流，而不是提供一个空的 UI 外壳并让它填充它。 正如 Jeff Posnick [指出](https://developers.google.com/web/updates/2016/06/sw-readablestreams)的，如果您的 web 应用程序由 CMS 提供支持的，那么服务器渲染 HTML 是通过将部分模板拼接在一起来呈现的，该模型将直接转换为使用流式响应，而模板逻辑将从服务器复制而不是你的服务器。Jake Archibald 的 [The Year of Web Streams](https://jakearchibald.com/2016/streams-ftw/) 文章重点介绍了如何构建它。对于性能的提升是非常明显的。

流式传输整个 HTML 响应的一个重要优点是，在初始导航请求期间呈现的 HTML 可以充分利用浏览器的流式 HTML 解析器。 在页面加载之后插入到文档中的 HTML 块（与通过 JavaScript 填充的内容一样常见）无法利用此优化。

浏览器支持程度如何呢? [详情请看这里](https://caniuse.com/#search=streams) Chrome 52+、Firefox 57、Safari 和 Edge 支持此 API 并且服务器已经支持所有的 [现代浏览器](https://caniuse.com/#search=serviceworker).

30. **你使用 `Save-Data` 存储数据吗**?
特别是在新兴市场工作时，你可能需要考虑优化用户选择节省数据的体验。 [Save-Data 客户端提示请求头](https://developers.google.com/web/updates/2016/02/save-data) 允许我们和定制为成本和性能受限的用户定制应用程序和有效载荷。 实际上，您可以将 [高 DPI 图像的请求重写为低 DPI 图像](https://css-tricks.com/help-users-save-data/)，删除网页字体和花哨的特效，关闭视频自动播放，服务器推送，甚至更改提供标记的方式。

该头部目前仅支持 Chromium，Android 版 Chrome 或 桌面设备上的 Data Saver 扩展。最后，你还可以使用 service worker 和 Network Information API 来提供基于网络类型的低/高分辨率的图像。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
