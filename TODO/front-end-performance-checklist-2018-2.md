> * 原文地址：[Front-End Performance Checklist 2018 - Part 2](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
> * 译者：[sakila1012](https://github.com/sakila1012)
> * 校对者：[sunshine940326](https://github.com/sunshine940326)，[xingqiwu55555](https://github.com/xingqiwu55555)

# 2018 前端性能优化清单 - 第 2 部分

下面是前端性能问题的概述，你可以参考以确保流畅的阅读本文。

- [2018 前端性能优化清单 - 第 1 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [2018 前端性能优化清单 - 第 2 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [2018 前端性能优化清单 - 第 3 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [2018 前端性能优化清单 - 第 4 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

11. **你会在你的项目中使用 AMP 和 Instant Articles 么？**

依赖于你的组织优先性和战略性，你可能想考虑使用谷歌的 [AMP](https://www.ampproject.org/) 和 Facebook 的 [Instant Articles](https://instantarticles.fb.com/) 或者苹果的 [Apple News](https://www.apple.com/news/)。没有它们，你可以实现很好的性能，但是 AMP 确实提供了一个免费的内容分发网络（CDN）的性能框架，而 Instant Articles 将提高你在 Facebook 上的知名度和表现。

对于用户而言，这些技术主要的优势是确保性能，但是有时他们宁愿喜欢 AMP-/Apple News/Instant Pages 链路，也不愿是“常规”和潜在的臃肿页面。对于以内容为主的网站，主要处理很多第三方法内容，这些选择极大地加速渲染的时间。

对于网站的所有者而言优势是明显的：在各个平台规范的可发现性和[增加搜索引擎的可见性](https://ethanmarcotte.com/wrote/ampersand/)。你也可以通过把 AMP 作为你的 PWA 数据源来构建[渐进增强的 Web 体验](https://www.smashingmagazine.com/2016/12/progressive-web-amps/)。缺点？显然，在一个有围墙的区域里，开发者可以创造并维持其内容的单独版本，防止 Instant Articles 和 Apple News [没有实际的URLs](https://www.w3.org/blog/TAG/2017/07/27/distributed-and-syndicated-content-whats-wrong-with-this-picture/)。（**谢谢** _Addy，Jeremy_）

12. **明智地选择你的 CDN**

根据你拥有的动态数据量，你可以将部分内容外包给[静态站点生成器](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)，将其放在 CDN 中并从中提供一个静态版本。因此可以避免数据的请求。你甚至可以选择一个基于 CDN 的[静态主机平台](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/)，将交互组件作为增强来充实你的页面 ([jamstack](https://jamstack.org/))。

注意，CDN 也可以服务（卸载）动态内容。因此，限制你的 CDN 到静态资源是不必要的。仔细检查你的 CDN 是否进行压缩和转换（比如：图像优化方面的格式，压缩和调整边缘的大小），智能 HTTP/2 交付，边侧包含，在 CDN 边缘组装页面的静态和动态部分（比如：离用户最近的服务端），和其他任务。

### 构建优化

13. **分清轻重缓急**

知道你应该优先处理什么是个好主意。管理你所有资产的清单（JavaScript，图片，字体，第三方脚本和页面中“昂贵的”模块，比如：轮播图，复杂的图表和多媒体内容），并将它们划分成组。

建立电子表格。针对传统的浏览器，定义基本的_核心_体验（比如：完全可访问的核心内容），针对多功能浏览器_提升_体验（比如：丰富多彩的，完美的体验）和其他的（不是绝对需要而且可以被延迟加载的资源，如 Web 字体、不必要的样式、旋转木马脚本、视频播放器、社交媒体按钮、大型图像。）。我们在“[Improving Smashing Magazine's Performance](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)”发布了一篇文章，上面详细描述了该方法。

14. **考虑使用“cutting-the-mustard”模式**

虽然很老，但我们仍然可以使用 [cutting-the-mustard 技术](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard)将核心经验带到传统浏览器并增强对现代浏览器的体验。严格要求加载的资源：优先加载核心传统的，然后是提升的，最后是其他的。该技术从浏览器版本中演变成了设备功能，这已经不是我们现在能做的事了。

例如：在发展中国家，廉价的安卓手机主要运行 Chrome，尽管他们的内存和 CPU 有限。这就是 [PRPL 模式](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)可以作为一个好的选择。因此，使用[设备内存客户端提示头](https://github.com/w3c/device-memory)，我们将能够更可靠地针对低端设备。在写作的过程中，只有在 Blink 中才支持 header(Blink 支持[客户端提示](https://caniuse.com/#search=client%20hints))。因为设备存储也有一个在 [Chrome 中可以调用的](https://developers.google.com/web/updates/2017/12/device-memory) JavaScript API，一种选择是基于 API 的特性检测，只在不支持的情况下回退到 “符合标准”技术（**谢谢**，_Yoav！_）。

15. **解析 JavaScript 的代价很大，应保持其较小**

但我们处理单页面应用时，在你可以渲染页面时，你需要一些时间来初始化 app。寻找模块和技术加快初始化渲染时间（例如：[这里是如何调试 React 性能](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad)，以及[如何提高 Angular 性能](https://www.youtube.com/watch?v=p9vT0W31ym8)），因为大多数性能问题来自于启动应用程序的初始解析时间。

[JavaScript 有成本](https://youtu.be/_srJ7eHS3IM?t=9m33s)，但不一定是文件大小会影响性能。解析和执行时间的不同很大程度依赖设备的硬件。在一个普通的手机上（Moto G4），仅解析 1MB （未压缩的）的 JavaScript 大概需要 1.3-1.4 秒，会有 15 - 20% 的时间耗费在手机的解析上。在执行编译过程中，只是用在JavaScript准备平均需要 4 秒，在手机上绘排需要 11 秒。解释：在低端移动设备上，[解析和执行时间可以轻松提高 2 至 5 倍](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

Ember 最近推出了一个实验，一种使用[二进制模板](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates)巧妙的避免解析开销的方式。这些模板不需要解析。（**感谢**，_Leonardo！_）

这就是检查每个 JavaScript 依赖性的关键，工具像 [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)，[Source Map Explorer](https://github.com/danvk/source-map-explorer) 和 [Bundle Buddy](https://github.com/samccone/bundle-buddy) 可以帮助你完成这些。[度量 JavaScript 解析和编译时间](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557)。Etsy 的 [DeviceTiming](https://github.com/danielmendel/DeviceTiming)，一个小工具允许您指示 JavaScript 在任何设备或浏览器上测量解析和执行时间。重要的是，虽然大小重要，但它不是一切。解析和编译时间并不是随着脚本大小增加而[线性增加](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

<figure class="video-container"><iframe src="https://player.vimeo.com/video/249525818" width="640" height="384" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

[Webpack Bundle Analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) visualizes JavaScript dependencies.

16. **你使用预编译器么？**

使用[预编译器](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/)来[减轻从客户端](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/)到[服务端的渲染](http://redux.js.org/docs/recipes/ServerRendering.html)的开销，因此快速输出有用的结果。最后，考虑使用 [Optimize.js](https://github.com/nolanlawson/optimize-js) 更快的加载,用快速地调用的函数（尽管，它[可能不需要](https://twitter.com/tverwaes/status/809788255243739136)）。

17. **你使用 tree-shaking，scope hoisting，code-splitting 么**

[Tree-shaking](https://medium.com/@roman01la/dead-code-elimination-and-tree-shaking-in-javascript-build-systems-fb8512c86edf) 是一种通过只加载生产中确实被使用的代码和[在 Webpack 中](http://www.2ality.com/2015/12/webpack-tree-shaking.html)清除无用部分，来整理你构建过程的方法。使用 Webpack 3 和 Rollup，我们还可以[提升作用域](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f)允许工具检测 `import` 链接以及可以转换成一个内联函数，不影响代码。有了 Webpack 4，你现在可以使用 [JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0)。[UnCSS](https://github.com/giakki/uncss) or [Helium](https://github.com/geuis/helium-css) 可以帮助你去删除未使用 CSS 样式。

而且，你想考虑学习如何[编写有效的 CSS 选择器](http://csswizardry.com/2011/09/writing-efficient-css-selectors/)以及如何[避免臃肿和开销浪费的样式](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/)。感觉好像超越了这个？你也可以使用 Webpack 缩短类名和在编译时使用作用域孤立来[动态地重命名 CSS 类名](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b)

[Code-splitting](https://webpack.github.io/docs/code-splitting.html) 是另一种 Webpack 特性，可以基于“chunks”分割你的代码然后按需加载这些代码块。并不是所有的 JavaScript 必须下载，解析和编译的。一旦在你的代码中确定了分割点，Webpack 会全权负责这些依赖关系和输出文件。在应用发送请求的时候，这样基本上确保初始的下载足够小并且实现按需加载。另外，考虑使用 [preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin) 获取代码拆分的路径，然后使用 `<link rel="preload">` or `<link rel="prefetch">` 提示浏览器预加载它们。

在哪里定义分离点？通过追踪使用哪些 CSS/JavaScript 块和哪些没有使用。Umar Hansa [解释了](https://vimeo.com/235431630#t=11m37s)你如何可以使用 Devtools 代码覆盖率来实现。

如果你没有使用 Webpack，值得注意的是相比于 Browserify 输出结果 [Rollup](http://rollupjs.org/) 展现的更加优秀。当使用 Rollup 时，我们会想要查看 [Rollupify](https://github.com/nolanlawson/rollupify)，它可以转化 ECMAScript 2015 modules 为一个大的 CommonJS module ——因为取决于打包工具和模块加载系统的选择，小的模块会有[令人惊讶的高性能开销](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/)。

![Addy Osmani 的'默认快速：现代负载最佳实践'](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)

Addy Osmani 的从[快速默认：现代加载的最佳实践]（https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices）。幻灯片76。

最后，随着[现代浏览器](http://kangax.github.io/compat-table/es6/)对 ES2015 支持越来越好，考虑[使用`babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) 只有 transpile ES2015+ 特色不支持现代浏览器的目标。然后[设置两个构建](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9)，一个在 ES6 一个在 ES5。我们可以[使用`script type="module"`](https://matthewphillips.info/posts/loading-app-with-script-module)让具有 ES 模块浏览器支持加载文件，而老的浏览器可以加载传统的建立`script nomodule`。

对于 loadsh，[使用 `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash)将会加载你仅仅在源码中使用的。这样将会很大程度减轻 JavaScript 的负载。

18. **利用目标 JavaScript 引擎的优化。**

研究 JavaScript 引擎在用户基础中占主导地位，然后探索优化它们的方法。例如，当优化的 V8 引擎是用在 Blink 浏览器，Node.js 运行和电子，对每个脚本充分利用[脚本流](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html)。一旦下载开始，它允许 `async` 或 `defer scripts` 在一个单独的后台线程进行解析，因此在某些情况下，提高页面加载时间达 10%。实际上，在 `<head>` 中[使用 `<脚本延迟>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，以致于[浏览器更早地可以发现资源](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，然后在后台线程中解析它。

**Caveat**：_Opera Mini [不支持 defement 脚本](https://caniuse.com/#search=defer)，如果你正在为印度和非洲开发，`defer` 将会被忽略，导致阻塞渲染直到脚本已经评估了_（感谢 Jeremy）!_。

[![渐进引导](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)

[渐进引导](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)：使用服务器端呈现获得第一个快速的有意义的绘排，而且还要包含一些最小必要的 JavaScript 来保持实时交互来接近第一次的绘排。

19. **客户端渲染或者服务端渲染？**

在两种场景下，我们的目标应该是建立[渐进引导](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)：使用服务器端呈现获得第一个快速的有意义的绘排，而且还要包含一些最小必要的 JavaScript 来**保持实时交互来接近第一次的绘排**。如果 JavaScript 在第一次绘排没有获取到，那么浏览器可能会在解析时[锁住主线程](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky)，编译和执行最新发现的 JavaScript，因此限制[互动的网站或应用程序](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/)。

为了避免这样做，总是将执行函数分离成一个个，异步任务和可能用到 `requestIdleCallback`的地方。考虑 UI 的懒加载部分使用 WebPack [动态 `import` 支持](https://developers.google.com/web/updates/2017/11/dynamic-import)，避免加载，解析，和编译开销直到用户真的需要他们（**感谢** _Addy!_）。

在本质上，交互时间（TTI）告诉我们导航和交互之间的时间长度。度量是通过在初始内容呈现后的第一个五秒窗口来定义的，在这个过程中，JavaScript 任务没有操作 50ms 的。如果发生超过 50ms 的任务，寻找一个五秒的窗口重新开始。因此，浏览器首先会假定它达到了交互式，只是切换到冻结状态，最终切换回交互式。

一旦我们达到交互式，然后，我们可以按需或随时间所允许的，启动应用程序的非必需部分。不幸的是，随着 [Paul Lewis 提到的](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting)，框架通常没有优先出现的概念可以向开发人员展示，因此渐进式引导很难用大多数库和框架实现。如果你有时间和资源，使用该策略可以极大地改善前端性能。

20. **你限制第三方脚本的影响么？**

尽管所有的性能得到很好地优化，我们不能控制来自商业需求的第三方脚本。第三方脚本度量不受终端用户体验的影响，所以，一个单一的脚本常常会以调用令人讨厌的，长长的第三方脚本为结尾，因此，破坏了为性能专门作出的努力。为了控制和减轻这些脚本带来的性能损失，仅异步加载（[可能通过 defer](https://www.twnsnd.com/posts/performant_third_party_scripts.html)）和通过资源提示，如：`dns-prefetch` 或者 `preconnect` 加速他们是不足够的。

正如 Yoav Weiss 在他的[必须关注第三方脚本的通信](http://conffab.com/video/taking-back-control-over-third-party-content/)中解释的，在很多情况下，下载资源的这些脚本是动态的。页面负载之间的资源是变化的，因此我们不必知道主机是从哪下载的资源以及这些资源是什么。

这时，我们有什么选择？考虑 **通过间隔下载资源来使用 service workers**，如果在特定的时间间隔内资源没有响应，返回一个空的响应告知浏览器执行解析页面。你可以记录或者限制那些失败的第三方请求和没有执行特定标准请求。

另一个选择是建立一个 **内容安全策略（CSP）** 来限制第三方脚本的影响，比如：不允许下载音频和视频。最好的选择是通过 `<iframe>` 嵌入脚本以致于脚本运行在 iframe 环境中，因此如果没有接入页面 DOM 的权限，在你的域下不能运行任何代码。Iframe 可以 使用 `sandbox` 属性进一步限制，因此你可以禁止 iframe 的任何功能，比如阻止脚本运行，阻止警告、表单提交、插件、访问顶部导航等等。

例如，它可能需要允许脚本运行 `<iframe sandbox="allow-scripts">`。每一个限制都可以通过'允许'值在 'sandbox' 属性中（[几乎处处支持](https://caniuse.com/#search=sandbox)）解除，所以把他们限制在最低限度的允许他们去做的事情上。考虑使用 [Safeframe](https://github.com/interactiveadvertisingbureau/safeframe) 和交叉观察；这将使广告嵌入 iframe 的同时仍然调度事件或需要从 DOM 获取信息（例如广告知名度）。注意新的策略如[特征策略](https://wicg.github.io/feature-policy/)），资源的大小限制，CPU 和带宽优先级限制损害的网络功能和会减慢浏览器的脚本，例如：同步脚本，同步 XHR 请求，document.write 和超时的实现。

为了[压测第三方](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/)，在 DevTools 上自底向上概要地检查页面的性能，测试如果一个请求被阻塞了会发生什么或者对于后面的请求有超时限制，你可以使用 WebPageTest's Blackhole 服务器 `72.66.115.13`，同时可以在你的 `hosts` 文件中指定特定的域名。最好是[自我主机和使用一个单一的主机名](https://www.twnsnd.com/posts/performant_third_party_scripts.html)，但是同时[生成一个请求映射](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/)，当脚本变化时，暴露给第四方调用和检测。

![请求块](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)

图片信用：[Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)

21. **HTTP cache 头部设置是否合理？**

再次检查一遍 `expires`，`cache-control`，`max-age` 和其他 HTTP cache 头部都是否设置正确。通常，资源应该是可缓存的，不管是短时间的（如果它们很可能改变），还是无限期的（如果它们是静态的）——你可以在需要更新的时候，改变它们 URL 中的版本即可。在任何资源上禁止头部 `Last-Modified` 都会导致一个 `If-Modified-Since` 条件查询，即使资源在缓存中。与 `Etag` 一样，即使它在使用中。

使用 `Cache-control: immutable`，该头部针对被标记指纹的静态资源设计，避免资源被重新验证（截至 2017年12月，[在 FireFox，Edge 和 Safari 中支持](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)；只有 FireFox 在 HTTPS 中支持）。你也可以使用 [Heroku 的 HTTP 缓存头部](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers)，Jake Archibald 的 "[Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)" ，以及 Ilya Grigorik 的 [HTTP caching primer](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) 作为指导。而且，注意[不同的头部](https://www.smashingmagazine.com/2017/11/understanding-vary-header/)，尤其是[在关系到 CDN 时](https://www.fastly.com/blog/getting-most-out-vary-fastly)，并且注意[关键头部](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html)有助于避免在新请求稍有差异时进行额外的验证，但从以前请求标准，并不是必要的（**感谢**，_Guy！_）。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
