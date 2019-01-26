> * 原文地址：[Front-End Performance Checklist 2019 — 5](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> * 译者：[wznonstop](https://github.com/wznonstop)
> * 校对者：

# 2019 前端性能优化年度总结 — 第五部分

让 2019 来得更迅速吧~你正在阅读的是 2019 年前端性能优化年度总结，始于 2016。

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> **[译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)**
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### 目录

- [交付优化](#交付优化)
  - [39. 所有的 JavaScript 库是否都采用了异步的方式加载？](#39-所有的-JavaScript-库是否都采用了异步的方式加载？)
  - [40. 使用 IntersectionObserver 加载开销大的组件](#40-使用-IntersectionObserver-加载开销大的组件)
  - [41. 渐进式加载图片](#41-渐进式加载图片)
  - [42. 是否发送了关键的css？](#42-你是否发送了关键的css？)
  - [43. 尝试重组 CSS 规则](#43-尝试重组-CSS-规则)
  - [44. 有没有将请求设为 stream？](#44-你有没有将请求设为-stream？)
  - [45. 考虑使组件具有连接感知能力](#45-考虑使组件具有连接感知能力)
  - [46. 考虑使组件具有设备内存感知能力](#46-考虑使组件具有设备内存感知能力)
  - [47. 做好连接的热身准备以加速交付](#47-做好连接的热身准备以加速交付)
  - [48. 使用 service workers 进行缓存和网络后备方案](#48-使用-service-workers-进行缓存和网络后备方案)
  - [49. 是否在 CDN/Edge 上使用了 service workers，例如，用于 A/B 测试？](#49-是否在-CDN/Edge-上使用了-service-workers，例如，用于-A/B-测试？)
  - [50. 优化渲染性能](#50-优化渲染性能)
  - [51. 是否优化了渲染体验？](#51-是否优化了渲染体验？)

### 交付优化

#### 39. 所有的 JavaScript 库是否都采用了异步的方式加载？

当用户请求页面时，浏览器获取HTML并构造DOM，然后获取CSS并构造CSSOM，然后通过匹配DOM和CSSOM生成渲染树。一旦出现需要解析的 JavaScript，浏览器将停止渲染，直到 JavaScript 被解析完成，从而造成渲染延迟。作为开发人员，我们必须明确告诉浏览器不要等待 JS 解析，直接渲染页面。对脚本执行此操作的方法是使用HTML中的`defer`和`async`属性。

在实践中，事实证明我们应该[更倾向于使用`defer`](http://calendar.perfplanet.com/2016/prefer-defer-over-async/)。使用`async`的话，[Internet Explorer 9 及其之前的版本有兼容性问题](https://github.com/h5bp/lazyweb-requests/issues/42)，可能会破坏它们的脚本。根据[Steve Souders 的讲述](https://youtu.be/RwSlubTBnew?t=1034)，一旦`async`脚本加载完成，它们就会立即执行。如果这种情况发生得非常快，例如当脚本处于缓存中时，它实际上可以阻止HTML解析器。使用`defer`的话，浏览器在解析HTML之前不会执行脚本。因此，除非在开始渲染之前需要执行JavaScript，否则最好使用`defer`。

此外，如上所述，限制第三方库和脚本的可能造成的影响，尤其是社交共享按钮和嵌入式`<iframe>`（如地图）。 [Size Limit库](https://github.com/ai/size-limit)可以帮助[防止 JavaScript 库过大](https://evilmartians.com/chronicles/size-limit-make-the-web-lighter) ：如果不小心添加了一个大的依赖项，该工具将通知你并抛出错误。可以使用[静态的社交分享按钮](https://www.savjee.be/2015/01/Creating-static-social-share-buttons/)（例如[SSBG](https://simplesharingbuttons.com) ）和[交互式地图的静态链接](https://developers.google.com/maps/documentation/static-maps/intro)。

也可以试着[修改非阻塞脚本加载器以实现CSP合规性](https://calendar.perfplanet.com/2018/a-csp-compliant-non-blocking-script-loader/)。

#### 40. 使用 IntersectionObserver 加载开销大的组件

一般来说，延迟加载所有开销大的组件是一个好主意，例如大体积的JavaScript，视频，iframe，小部件和潜在的图像。最高效的方法是使用[Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API)，它对具有祖先元素或顶级文档视口的目标元素提供了一种异步观察交叉点变化的方法。基本用法是，创建一个新的`IntersectionObserver`对象，该对象接收回调函数和一组选项。然后再添加一个观察目标就可以了。

回调函数在目标变为可见或不可见时执行，因此当它截取视口时，可以在元素变为可见之前开始执行某些操作。实际上，我们使用了`rootMargin`（根周围的边距）和`threshold`（单个数字或数字数组，表示目标可见性的百分比）对回调函数的执行时间进行了精细的控制。

Alejandro Garcia Anglada发表了一篇关于如何将其应用到实践中的[简易教程](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366)，Rahul Nanwani写了一篇关于[延迟加载前景和背景图片的详细文章](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/)，Google Fundamentals提供了[关于 Intersection Observer 延迟加载图像和视频的详细教程](https://developers.google.com/web/fundamentals/performance/lazy-loading-guidance/images-and-video/) 。还记得使用动静结合的物体进行艺术指导的长篇故事吗？您也可以使用Intersection Observer实现[高性能的滚动型讲述](https://github.com/russellgoldenberg/scrollama)。

另外，请注意[`lazyload`属性](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/)，它将允许我们以原生的方式指定哪些图像和`iframe`应该是懒惰加载。 [功能说明：LazyLoad](https://www.chromestatus.com/feature/5641405942726656)将提供一种机制，允许我们强制在每个域的基础上选择加入或退出LazyLoad功能（类似于[内容安全政策](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)的功能）。 惊喜：一旦启用，[优先提示 priority hints]（https://twitter.com/csswizardry/status/1050717710525509633）将允许我们在标题中指定脚本和预加载资源的权重（目前已在Chrome Canary中实现）。

#### 41. 渐进式加载图片

你甚至可以通过向页面添加[渐进式图像加载技术]（https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/）将延迟加载提升到新的水平。与Facebook，Pinterest和Medium类似，可以先加载质量较差甚至模糊的图像，然后在页面继续加载时，使用Guy Podjarny提出的[LQIP（低质量图像占位符）技术](https://www.guypo.com/introducing-lqip-low-quality-image-placeholders)将其替换为原图。

对于这项技术是否提升了用户体验，大家各执一词，但它一定缩短了第一次有效的绘图时间。我们甚至可以使用[SQIP](https://github.com/technopagan/sqip)将其创建为SVG占位符或带有CSS线性渐变的[渐变图像占位符](https://calendar.perfplanet.com/2018/gradient-image-placeholders/)。这些占位符可以嵌入HTML中，因为它们可以使用文本压缩方法自然地压缩。Dean Hume在他的文章中[描述了](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) 如何使用Intersection Observer实现此技术。

浏览器支持怎么样呢？[主流浏览器](https://caniuse.com/#feat=intersectionobserver)，Chrome，Firefox，Edge和三星的浏览器均有支持。WebKit状态目前已在[预览中支持](https://webkit.org/status/#specification-intersection-observer)。如何优雅降级？如果浏览器不支持 intersection observer，我们仍然可以使用[polyfill](https://github.com/jeremenichelli/intersection-observer-polyfill)来[延迟加载](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366)或立即加载图像。甚至有一个[库](https://github.com/ApoorvSaxena/lozad.js)可以用来实现它。

想成为一名发烧友？你可以[追踪你的图像](https://jmperezperez.com/svg-placeholders/)并使用原始形状和边框来创建一个轻量级的SVG占位符，首先加载它，然后从占位符矢量图像转换为（已加载的）位图图像。

[![José M. Pérez 的 SVG 延迟加载技术](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7f56052-6abb-4d18-a5aa-8d84102d812e/jmperez-composition-primitive-full.jpg)](https://jmperezperez.com/svg-placeholders/) 

[José M. Pérez](https://jmperezperez.com/svg-placeholders/)的 SVG 延迟加载技术。([大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7f56052-6abb-4d18-a5aa-8d84102d812e/jmperez-composition-primitive-full.jpg))

#### 42. 你是否发送了关键的css？

为了确保浏览器尽快开始渲染页面，[通常做法是](https://www.smashingmagazine.com/2015/08/understanding-critical-css/)收集开始渲染页面的第一个可见部分所需的所有CSS（称为“关键CSS”或“首页CSS”）并将其以内联的形式添加到页面的“<head>”中，从而减少往返请求。由于在慢启动阶段交换的包的大小有限，因此关键CSS的预算约为14 KB。

如果超出此范围，浏览器将需要额外的开销来获取更多样式。 [CriticalCSS](https://github.com/filamentgroup/criticalCSS)和[Critical](https://github.com/addyosmani/critical)使你能够做到这一点。你可能需要为正在使用的每个模板执行此操作。如果可能的话，请考虑使用Filament Group使用的[条件内联方法](https://www.filamentgroup.com/lab/modernizing-delivery.html)，或[动态地将内联代码转换为静态资源](https://www.smashingmagazine.com/2018/11/pitfalls-automatically-inlined-code/)。

使用HTTP/2，关键CSS可以存储在单独的CSS文件中，并通过[服务器推送](https://www.filamentgroup.com/lab/modernizing-delivery.html)传送，而不会增加HTML的大小。问题是，服务器推送[很麻烦](https://twitter.com/jaffathecake/status/867699157150117888) ，浏览器存在许多陷阱和竞争条件。往往并不能始终支持，且伴有一些缓存问题（参见[Hooman Beheshti演示文稿幻灯片的114页](http://www.slideshare.net/Fastly/http2-what-no-one-is-telling-you)）。事实上，这种影响可能是[负面的](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/) ，它会使网络缓冲区膨胀，从而阻止文档中的真实帧被传递。此外，由于TCP启动缓慢，服务器推送似乎[在热连接上更有效](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit)。

即使使用HTTP/1，将关键CSS放在根域名下的单独文件中[也是有好处的](http://www.jonathanklein.net/2014/02/revisiting-cookieless-domain.html)，由于缓存的原因，有时甚至比内联更优。 Chrome在请求页面时会尝试打开根域名下的第二个HTTP连接，从而无需TCP连接来获取此CSS（_感谢Philip！_）

需要记住的一些问题是：与可以从任何域触发预加载的“预加载”不同，你只能从自己的域或认证过的域中推送资源。一旦服务器从客户端获得了第一个请求，就可以启动该连接。服务器推送资源落在Push缓存中，并在连接终止时被删除。但是，由于HTTP/2连接可以在多个选项卡中重复使用，因此也可以使用通过其他选项卡的请求声明推送的资源（_感谢Inian！_）。

目前，服务器没有简单的方法可以知道要推送资源是否已经存在于[用户缓存之中](https://blog.yoav.ws/tale-of-four-caches/)中，每个用户访问的时候都会推送资源。因此，你可能需要创建[HTTP/2的缓存感知服务器推送机制](https://css-tricks.com/cache-aware-server-push/)。如果发现已存在，则可以尝试根据缓存中已有内容的索引从缓存中获取它们，从而避免服务器的全量推送。

但请记住，[新的`cache-digest`规范](http://calendar.perfplanet.com/2016/cache-digests-http2-server-push/)否定了手动构建此类“缓存感知”服务器的需要，只需要在HTTP/2中声明一个新的帧类型，就可以传达该域名下缓存中已有的内容。因此，它对CDN也特别有用。

对于动态内容，当服务器需要一些时间来生成响应时，浏览器无法发出任何请求，因为它不知道页面可能引用的任何子资源。对于这种情况，我们可以预热连接并增加TCP拥塞窗口的数量，以便可以更快地完成将来的请求。此外，所有内联资源通常都是服务器推送的良好候选者。事实上，Inian Parameshwaran [针对HTTP/2推送与HTTP预加载做了很棒的比较的研究](https://dexecure.com/blog/http2-push-vs-http-preload/)，这份高质量的资料包括了你可能想了解的各种细节。是否选择服务器推送？科林·本德尔的[我是否应该进行服务器推送？](https://shouldipush.com/) 可能会为你指明方向。

一句话：正如Sam Saccone [所说](https://medium.com/@samccone/performance-futures-bundling-281543d9a0d5)，`预加载`适用于将资源的开始下载时间向初始请求靠拢，服务器推送适用于删除完整的RTT（[等](https://blog.yoav.ws/being_pushy/)，具体取决于服务器的响应时间） - 前提是你得有一个service worker用来避免不必要的推送。
    
#### 43. 尝试重组 CSS 规则

We’ve got used to critical CSS, but there are a few optimizations that could go beyond that. Harry Roberts conducted a [remarkable research](https://csswizardry.com/2018/11/css-and-network-performance/) with quite surprising results. For example, it might be a good idea to split the main CSS file out into its individual media queries. That way, the browser will retrieve critical CSS with high priority, and everything else with low priority — completely off the critical path.

Also, avoid placing `<link rel="stylesheet" />` before `async` snippets. If scripts don’t depend on stylesheets, consider placing blocking scripts above blocking styles. If they do, split that JavaScript in two and load it either side of your CSS.

Scott Jehl solved another interesting problem by [caching an inlined CSS file with a service worker](https://www.filamentgroup.com/lab/inlining-cache.html), a common problem familiar if you’re using critical CSS. Basically, we add an ID attribute onto the `style` element so that it’s easy to find it using JavaScript, then a small piece of JavaScript finds that CSS and uses the Cache API to store it in a local browser cache (with a content type of `text/css`) for use on subsequent pages. To avoid inlining on subsequent pages and instead reference the cached assets externally, we then set a cookie on the first visit to a site. _Voilà!_

- YouTube 视频链接：https://youtu.be/Cjo9iq8k-bc

Do we [stream reponses](https://jakearchibald.com/2016/streams-ftw/)? With streaming, HTML rendered during the initial navigation request can take full advantage of the browser’s streaming HTML parser.

我们已经习惯了关键的CSS，但还有一些优化可以超越这一点。HarryRoberts进行了一项[非凡的研究](https:/csswissdry.com/2018/11/css-and-network-Performance/)，得出了相当惊人的结果。例如，将主CSS文件拆分为单独的媒体查询可能是个好主意。这样，浏览器将检索具有高优先级的关键CSS，以及其他具有低优先级的所有内容 —— 最终完全脱离关键路径。

另外，避免将`<link rel="stylesheet" />` 放在 `async` 标签之前。如果脚本不依赖于样式表，请考虑将阻塞脚本放在阻塞样式之前。如果脚本依赖样式，请将该JavaScript一分为二，然后对应将其加载到CSS的前后。

Scott Jehl通过[使用service worker缓存内联CSS文件](https:/www.filamentGroup.com/lab/inlining-cache.html)解决了另一个有趣的问题，这是使用关键CSS时常见的问题。基本上，我们将ID属性添加到`style`元素中，以便使用JavaScript时可以轻松找到它，然后一小块JavaScript发现CSS并使用缓存API将其存储在本地浏览器缓存中(其内容类型为`text/css`)，以便在后续页面中使用。为了不在后续页面上内联引用，而是从外部引用缓存的资源，我们在第一次访问站点时设置了一个cookie。_瞧！_。

- YouTube 视频链接：https://youtu.be/Cjo9iq8k-bc

我们是否[以流的方式进行响应了](https:/jakearchibald.com/2016/stream-ftw/)？使用流，在初始导航请求期间呈现的HTML可以充分利用浏览器的流HTML解析器。

#### 44. 你有没有将请求设为 stream？

经常被遗忘和忽略的是[Streams](https://streams.spec.whatwg.org/)提供了一个读或写异步数据块的接口，在任何给定的时间里，内存中可能只有一部分数据块可用。基本上，它们允许发出原始请求的页面在第一块数据可用时立即开始处理响应，并使用针对流优化的解析器逐步显示内容。

我们可以从多个来源创建一个流。例如，可以让service worker构造一个流，其中shell来自缓存，但主体来自网络，而不是提供一个空的 UI shell 并让JavaScript填充它。正如Jeff Posnick[所说](https:/developers.google.com/web/update/2016/06/sw-readablestream)，如果你的Web应用程序由CMS提供支持，该CMS通过将部分模板缝合在一起呈现HTML，则可以将该模型直接转换为使用流响应，模板逻辑将复制到service worker而不是你的服务器中。 Jake Archibald 的[网络流年](https:/jakearchibald.com/2016/stream-ftw/)文章重点介绍了如何准确地构建它。可以为性能带来[相当明显的提升](https:/www.youtube.com/watch？v=Cjo9iq8k-bc)。

流式处理整个HTML响应的一个重要优点是，在初始导航请求期间呈现的HTML可以充分利用浏览器的流式HTML解析器。页面加载后插入到文档中的HTML块(这在通过JavaScript填充的内容中很常见)则无法享受这种优化。

浏览器支持怎么样呢？[主流浏览器](https:/caniuse.com/#Search=Streams)，Chrome 52+、Firefox 57+、Safari和Edge均支持该API，而[所有的现代浏览器中都支持](https://caniuse.com/#search=serviceworker)Service Workers。
    
#### 45. 考虑使组件具有连接感知能力

随着不断增长的负载，数据的开销可能[变得很大](https://whatdoesmysitecost.com/)，我们需要尊重选择在访问我们的网站或应用程序时希望节省流量的用户。[Save-Data客户端提示请求头](https:/developers.google.com/web/update/2016/02/save-data)允许我们为受成本和性能限制的用户定制应用程序及其负载。事实上，你可以[将高DPI图像的请求重写为低DPI图像请求](https://css-tricks.com/help-users-save-data/)，删除Web字体、花哨的视差效果、预览缩略图和无限滚动、关闭视频自动播放、服务器推送、减少显示项目的数量并降低图像质量，甚至改变[交付标记的方式](https://dev.to/addyosmani/adaptive-serving-using-javascript-and-the-network-information-api-331p)。Tim Vereecke发表了一篇关于[data-s(h)aver策略的非常详细的文章](https:/calendar.perplanet.com/2018/data-shaver-policy/)，其中介绍了许多用于数据保存的选项。

目前，只有Chromium、Android版本的Chrome或桌面设备上的Data Saver扩展才支持标识头。最后，你还可以使用[Network Information API](https:/googlechrome.gitrub.io/samples/network-Information/)根据网络类型提供[高/低分辨率的图像](https://justmarkup.com/log/2017/11/network-based-image-loading/) 和视频。Network Information API，特别是`navigator.connection.effectiveType`(Chrome62+)使用 `RTT`、 `downlink`、 `effectiveType`(以及一些[其他值](https://wicg.github.io/netinfo/))来为用户提供可处理的连接和数据表示。

在这种情况下，Max Stoiber谈到[连接感知组件](https://mxb.at/blog/connection-aware-components/)。例如，使用React时，我们可以编写一个为不同连接类型呈现不同元素的组件。正如Max建议的那样，新闻文章中的`<Media />`组件或许应该输出为下列的几种形式：

*   `Offline`: 带有`alt`文本的占位符，
*   `2G` / `省流` 模式: 低分辨率图像，
*   非视网膜屏的`3G`: 中等分辨率图像，
*   视网膜屏的`3G`s: 高分辨率视网膜图像，
*   `4G`: 高清视频。

DeanHume提供了一个使用service worker的[类似逻辑的实现](https://deanhume.com/dynamic-resources-using-the-network-information-api-and-service-workers/) 。对于视频，我们可以在默认情况下显示视频海报，然后显示“播放”图标，在网络更好的情况下显示视频播放器外壳、视频元数据等。作为浏览器不兼容的降级方案，我们可以[监听`canplaythrough`事件](https://benrobertson.io/front-end/lazy-load-connection-speed) ，并在`canplaythrough`事件2秒内未触发的情况下使用`Promise.race()`来触发资源加载超时。

#### 46. 考虑使组件具有设备内存感知能力

尽管如此，网络连接也只是为我们提供了关于用户上下文的一个视角。更进一步，你还可以动态地[根据可用设备内存调整资源](https://calendar.perfplanet.com/2018/dynamic-resources-browser-network-device-memory/)，使用[Device Memory API](https:/developers.google.com/web/update/2017/12/Device-Memory)(Chrome63+)。`navigator.deviceMemory` 返回设备的RAM容量(以GB为单位)，四舍五入到最近的2次方。该API还具有客户端提示标头`Device-Memory`，该标头可以提供相同的值。

![DevTools中的“优先级”列](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/34f6f27f-88a9-425a-910e-39100034def3/devtools-priority-segixq.gif)。

DevTools中的“优先级”列。图片来源：Ben Schwarz, [关键请求](https://css-tricks.com/the-critical-request/)

#### 47. 做好连接的热身准备以加速交付

使用[资源提示](https://w3c.github.io/resource-hints)来节省[`dns-prefch`](http://caniuse.com/#search=dns-prefetch)(在后台执行DNS查找)的时间。[`preconnect`](http://www.caniuse.com/#search=preconnect)(要求浏览器在后台启动连接握手(DNS、TCP、TLS)，[`prefetch`](http://caniuse.com/#search=prefetch)(要求浏览器请求资源)和[`preload’](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/)(除此之外，它并不需要执行它们即可预获取资源)。

现在大部分时间里，我们至少会使用`preconnect` 和 `dns-prefetch`，并且我们会谨慎地使用`prefetch` 和 `preload`；只有当您对用户下一步需要哪些资源(例如，当用户处于购买漏斗模型中时)有信心时，才应该使用前者。

请注意，即使使用`preconnect` 和 `dns-prefetch`，浏览器对要并行查找/连接到的主机数量也有限制，因此基于优先级对它们进行排序是安全的(_感谢Philip！_)。

事实上，使用资源提示可能是提高性能的最简单的方法，而且[它确实工作得很好](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)。什么时候用什么？正如Addy Osmani[曾解释过的](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)，我们应该预先加载我们高度信任的资源，以便在当前页面中使用这些资源。预获取资源可能会用于未来跨边界的导航，例如用户尚未访问的页面所需的 webpack bundles。

Addy关于[“在Chrome中加载优先级”]的文章(https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)准确地展示了Chrome是如何解释资源提示的，因此一旦确定了哪些资源对于渲染至关重要，就可以为它们分配高优先级。要查看请求的优先级，可以在Chrome 的 DevTools 网络请求表(以及 Safari 的 Technology Preview)中启用“优先级”列。

例如，由于字体通常是页面上的重要资源，使用[请求浏览器下载字体](https://css-tricks.com/the-critical-request/#article-header-id-2)的 [`preload`](https://css-tricks.com/the-critical-request/#article-header-id-2)一直是个好主意。你还可以[动态加载JavaScript](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#dynamic-loading-without-execution)，有效地执行延迟加载。另外，由于 `<link rel="preload">`接受一个`media`属性，因此可以基于`@media`查询规则选择[可选的资源优先级](https://css-tricks.com/the-critical-request/#article-header-id-3)。

一些[要记住的点](https://dexecure.com/blog/http2-push-vs-http-preload/)：`preload`有利于[使资源的开始下载时间](https://www.youtube.com/watch?v=RWLzUnESylc)更接近初始请求，但是，预加载的资源会存在内存缓存中，该缓存绑定到发出请求的页面上。`preload`可以很好地处理HTTP缓存：如果HTTP缓存中已经存在该资源，则永远不会针对该资源去发送网络请求。

因此，对于最近发现的资源、通过后台图像加载的主页横幅、内联关键CSS(或JavaScript)以及预加载CSS(或JavaScript)的其余部分，它非常有用。此外，`preload`标记只能在浏览器接收到来自服务器的HTML并且先行解析器找到`preload`标记后才能启动预加载。

通过HTTP报头预加载要快一些，因为我们不需要等待浏览器解析HTML来启动请求。[提早提示](https://www.fastly.com/blog/faster-websites-early-priority-hints) 将提供更多帮助，即使在发送HTML的响应头和[优先级提示](https://github.com/WICG/priority-hints) ([即将发布](https://www.chromestatus.com/feature/5273474901737472))之前就启用预加载，将帮助我们指示脚本的加载优先级。

注意：如果您使用的是`preload`， `正如` **必须被定义** 或[不加载任何内容](https://twitter.com/yoavweiss/status/873077451143774209)，另外[不使用预加载字体的话](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)[`跨域`](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)[属性会两次获取数据](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)。

#### 48. 使用 service workers 进行缓存和网络降级

网络上的任何性能优化都赶不上从用户计算机上本地存储的缓存中取数据快。如果你的网站基于HTTPS协议，请使用“[Service Workers的实用指南](https://github.com/lyzadanger/pragmatist-service-worker)”将静态资源缓存到service worker缓存中，并存储离线回退(甚至离线页)，然后从用户的计算机检索它们，而不是转向网络。此外，请查看Jake的[离线Cookbook](https://jakearchibald.com/2014/offline-cookbook/) 和免费的udacity课程“[离线Web应用](https://www.udacity.com/course/offline-web-applications--ud899)”。

浏览器支持怎么样呢？如上所述，它得到了[广泛支持](http://caniuse.com/#search=serviceworker)(Chrome、Firefox、Safari TP、三星浏览器、Edge 17+)，降级的话就是去发网络请求。它是否有助于提高性能呢？[当然了，](https://developers.google.com/web/showcase/2016/service-worker-perf)。而且它正在变得更好，例如通过后台抓取，允许从service worker进行后台上传/下载等。[Chrome71中已发布](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/z5WX-2RMulo/JQqeF3XZAgAJ)。

service worker有许多使用案例。例如，可以[实现“离线保存”功能](https://una.im/save-offline/#%F0%9F%92%81)、[处理已损坏图像](https://bitsofco.de/handling-broken-images-with-service-worker/)，介绍[选项卡之间的消息传递](https://www.loxodrome.io/post/tab-state-service-workers/)或[根据请求类型提供不同的缓存策略](https://medium.com/dev-channel/service-worker-caching-strategies-based-on-request-types-57411dd7652c)。一般来说，一种常见的可靠策略是将应用程序外壳与几个关键页面一起存储在service worker的缓存中，例如离线页面、前端页面以及对具体场景中可能重要的任何其他页面。

尽管如此，还是有几个问题需要记住。使用service worker时，我们需要[注意Safari中的范围请求](https://philna.sh/blog/2018/10/23/service-workers-beware-safaris-range-request/) (如果你使用的是service worker的工作框，它有一个[范围请求模块](https://developers.google.com/web/tools/workbox/modules/workbox-range-requests)。如果你在浏览器控制台中偶然发现了`DOMException: Quota exceeded.`错误，那么请查看Gerardo的文章[当7KB等于7Mb](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/)。

Gerardo写道：“如果你正在构建一个渐进式Web应用程序，并且使用service worker缓存来自CDN的静态资源，并正在经历高速缓存存储膨胀，请确保跨域资源[有适当的CORS响应头存在](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#opaque-responses) ，[不要缓存不透明的响应](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#should-opaque-responses-be-cached-at-all) ，通过给`<img>`标签设置`crossorigin`属性，[将跨域图像资源设为CORS模式](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#opt-in-to-cors-mode)“。

使用service worker的一个很好的起点是[workbox](https://developers.google.com/web/tools/workbox/)，这是一组专门为构建渐进式Web应用程序而构建的service worker库。

#### 49. 是否在 CDN/Edge 上使用了 service workers，例如，用于 A/B 测试？

在这一点上，我们已经习惯于在客户端上运行service worker，但是通过[在CDNS服务器上使用它们](https://blog.cloudflare.com/introducing-cloudflare-workers/)，我们也可以实现用它们来调整边缘性能。

例如，在A/B测试中，当HTML需要为不同的用户改变其内容时，我们可以[使用CDN服务器上的service worker](https://www.filamentgroup.com/lab/servers-workers.html) 来处理逻辑。我们还可以通过[重写HTML流](https://twitter.com/patmeenan/status/1065567680298663937) 来加速使用谷歌字体的站点。

#### 50. 优化渲染性能

使用[CSS容器](http://caniuse.com/#search=contain)隔离开销大的组件 —— 例如，限制浏览器样式、画布和画图用于画布外导航或第三方小部件的范围。请确保在滚动页面或设置元素动画时没有延迟，并且始终达到每秒60帧。如果这无法实现，那么至少使每秒的帧数保持一致，这比60到15之间的不定值更可取。使用CSS的[`will-change`](http://caniuse.com/#feat=will-change)去通知浏览器哪些元素和属性将更改。

此外，度量[运行时渲染性能](https://aerotwist.com/blog/my-performance-audit-workflow/#runtime-performance)(例如，[使用DevTools中的rendering工具](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/)）。想要快速上手，可以查看Paul Lewis[关于浏览器渲染优化的免费udacity课程](https://www.udacity.com/course/browser-rendering-optimization--ud860)和Georgy Marchuk关于[浏览器绘制和Web性能思考的文章](https://css-tricks.com/browser-painting-and-considerations-for-web-performance/)。

如果你想深入探讨这个话题， Nolan Lawson 在他的文章中分享了[精确测量布局性能的技巧](https://nolanlawson.com/2018/09/25/accurately-measuring-layout-on-the-web/)，Jason Miller [也给出了替代技术的建议](https://twitter.com/_developit/status/1081682550865752064)。 我们还有Sergey Chikuyonok撰写的一篇关于如何[正确制作GPU动画](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/)的文章。快速提示：对GPU合成层的更改是[开销最小的](https://blog.algolia.com/performant-web-animations/)，因此，如果你只通过`opacity` 和 `transform`触发合成，那就对了。Anna Migas在她关于[调试UI呈现性能](https://vimeo.com/302791098)的演讲中也提供了很多实用的建议。 

#### 51. 是否优化了渲染体验？

虽然组件在页面上的显示顺序以及我们如何将资源提供给浏览器的策略很重要，但我们不应低估[感知性能](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/)的作用。这一概念涉及到等待时的心理效应，基本上是让顾客在其他事情发生的时候保持有事可做。这就是[感知管理](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/)，[抢先启动](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#preemptive-start)，[提前完成](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#early-completion) 和[容忍度管理](https://www.smashingmagazine.com/2015/12/performance-matters-part-3-tolerance-management/)开始发挥作用。

这一切意味着什么？在加载资源时，我们可以尝试始终领先于客户一步，这样在后台繁忙的时候，用户依然感觉页面速度很快。为了让客户参与进来，我们可以测试[框架屏幕](https://twitter.com/lukew/status/665288063195594752) ([实现演示](https://twitter.com/razvancaliman/status/734088764960690176)），而不是loading指示器。添加过渡/动画，简单的[欺骗用户体验](https://blog.stephaniewalter.fr/en/cheating-ux-perceived-performance-and-user-experience/)。不过，请注意：在部署之前应该对骨架屏幕进行测试，因为从各项指标来看，有些[测试表明，骨架屏幕的性能最差](https://www.viget.com/articles/a-bone-to-pick-with-skeleton-screens/) 。

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> **[译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)**
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
