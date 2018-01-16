> * 原文地址：[Front-End Performance Checklist 2018 - Part 4](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2018 - Part 4
# 2018 前端性能优化清单 - 第 4 部分

Below you’ll find an overview of the front-end performance issues you mightneed to consider to ensure that your response times are fast and smooth.

下面是前端性能问题的概述，您可能需要考虑已确保您的响应时间是快速和平滑的。

- [Front-End Performance Checklist 2018 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [Front-End Performance Checklist 2018 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [Front-End Performance Checklist 2018 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [Front-End Performance Checklist 2018 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

- [2018 前端性能优化清单 - 第 1 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [2018 前端性能优化清单 - 第 2 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [2018 前端性能优化清单 - 第 3 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [2018 前端性能优化清单 - 第 4 部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

31. **Do you warm up the connection to speed up delivery?**
31. **你是否对连接进行了热身以加快传输？**

Use [resource hints](https://w3c.github.io/resource-hints) to save time on [`dns-prefetch`](http://caniuse.com/#search=dns-prefetch) (which performs a DNS lookup in the background), [`preconnect`](http://www.caniuse.com/#search=preconnect) (which asks the browser to start the connection handshake (DNS, TCP, TLS) in the background), [`prefetch`](http://caniuse.com/#search=prefetch) (which asks the browser to request a resource) and [`preload`](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) (which prefetches resources without executing them, among other things).

使用 [资源提示](https://w3c.github.io/resource-hints) 来节约时间，如 [`dns-prefetch`](http://caniuse.com/#search=dns-prefetch) （在后台执行 DNS 查询），[`preconnect`](http://www.caniuse.com/#search=preconnect) （告诉浏览器在后台进行连接握手（DNS, TCP, TLS）），[`prefetch`](http://caniuse.com/#search=prefetch) (告诉浏览器请求一个资源) and [`preload`](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) (预先获取资源而不执行他们)。


Most of the time these days, we'll be using at least `preconnect` and `dns-prefetch`, and we'll be cautious with using `prefetch` and `preload`; the former should only be used if you are very confident about what assets the user will need next (for example, in a purchasing funnel). Notice that `prerender` has been deprecated and is no longer supported.

大部分时间，我们至少会使用 `preconnect` 和 `dns-prefetch`，我们会小心使用 `prefetch` 和 `preload`；前者只能用在你对用户接下来需要什么资源非常确定的情况中（类似于采购渠道）。注意，`prerender` 已被弃用，不再被支持。

Note that even with `preconnect` and `dns-prefetch`, the browser has a limit on the number of hosts it will look up/connect to in parallel, so it's a safe bet to order them based on priority (_thanks Philip!_).

请注意，即使使用 `preconnect` 和 `dns-prefetch`，浏览器也会对它将并行查找或连接的主机数量进行限制，因此最好是将它们根据优先级进行排序。

In fact, using resource hints is probably the easiest way to boost performance, and [it works well indeed](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf). When to use what? As Addy Osmani [has explained](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf), we should preload resources that we have high-confidence will be used in the current page. Prefetch resources likely to be used for future navigations across multiple navigation boundaries, e.g. Webpack bundles needed for pages the user hasn't visited yet.

事实上，使用资源提示可能是最简单的提高性能的方法，[它确实很有效](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)。什么时候该使用什么？Addy Osmani [解释了](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)，我们应该 preload 确定将在当前页面中使用的资源。prefetch 可能用于未来页面的资源，例如用户尚未访问的页面所需的 webpack 包。

Addy's article on Loading Priorities in Chrome [shows](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) how exactly Chrome interprets resource hints, so once you've decided which assets are critical for rendering, you can assign high priority to them. To see how your requests are prioritized, you can enable a "priority" column in the Chrome DevTools network request table (as well as Safari Technology Preview).

Add 的关于 Chrome 中加载优先级的文章[展示了](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) Chrome 是如何精确的解析资源提示的，因此一旦你决定哪些资源对页面渲染比较重要，你就可以给它们赋予比较高的优先级。

![the priority column in DevTools](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/34f6f27f-88a9-425a-910e-39100034def3/devtools-priority-segixq.gif)

The 'Priority' column in DevTools. Image credit: Ben Schwarz, [The Critical Request](https://css-tricks.com/the-critical-request/)

DevTools 中的 "Priority" 列。图片来源于：Ben Schwarz，[重要的请求](https://css-tricks.com/the-critical-request/)

For example, since fonts usually are important assets on a page, it's always a good idea to [request the browser to download fonts with](https://css-tricks.com/the-critical-request/#article-header-id-2) [`preload`](https://css-tricks.com/the-critical-request/#article-header-id-2). You could also [load JavaScript dynamically](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#dynamic-loading-without-execution), effectively lazy-loading execution. Also, since `<link rel="preload">` accepts a `media` attribute, you could choose to [selectively prioritize resources](https://css-tricks.com/the-critical-request/#article-header-id-3) based on `@media` query rules.

例如，由于字体通常是页面上的重要资源，所以使用 [`preload`](https://css-tricks.com/the-critical-request/#article-header-id-2) [请求浏览器下载字体](https://css-tricks.com/the-critical-request/#article-header-id-2)总是一个好主意。你也可以[动态加载 JavaScript ](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#dynamic-loading-without-execution)，从而有效的执行延迟加载。同样的，因为 `<link rel="preload">` 接收一个 `media` 的属性，你可以基于 `@media` 查询规则来有选择性的优先加载资源。


A few [gotchas to keep in mind](https://dexecure.com/blog/http2-push-vs-http-preload/): preload is good for [moving the start download time of an asset](https://www.youtube.com/watch?v=RWLzUnESylc) closer to the initial request, but preloaded assets land in the memory cache which is tied to the page making the request. It means that preloaded requests cannot be shared across pages. Also, `preload` plays well with the HTTP cache: a network request is never sent if the item is already there in the HTTP cache.

一些[必须牢记于心](https://dexecure.com/blog/http2-push-vs-http-preload/)的点：preload 适用于[将资源的下载时间移到](https://www.youtube.com/watch?v=RWLzUnESylc)请求开始时，但是这些缓存在内存中的预先加载的资源是绑定在所发送请求的页面上，也就意味着预先加载的请求不能被页面所共享。再者，`preload` 与 HTTP 缓存配合得也很好：如果缓存命中则不会发送网络请求。

Hence, it's useful for late-discovered resources, a hero image loaded via background-image, inlining critical CSS (or JavaScript) and pre-loading the rest of the CSS (or JavaScript). Also, a `preload` tag can initiate a preload only after the browser has received the HTML from the server and the lookahead parser has found the `preload` tag. Preloading via the HTTP header is a bit faster since we don't to wait for the browser to parse the HTML to start the request. [Early Hints](https://tools.ietf.org/html/draft-ietf-httpbis-early-hints-05) will help even further, enabling preload to kick in even before the response headers for the HTML are sent.

因此，它对后发现的资源也非常有用，如：通过 background-image 加载的一幅 hero image，内联临界 CSS （或 JavaScript），并预先加载其他 CSS （或 JavaScript）。此外，只有当浏览器从服务器接收 HTML，并且前面的解析器找到了 `preload` 标签后，`preload` 标签才可以启动预加载。由于我们不等待浏览器解析 HTML 以启动请求，所以通过 HTTP 头进行预加载要快一些。[早期提示](https://tools.ietf.org/html/draft-ietf-httpbis-early-hints-05)将有助于进一步，在发送 HTML 响应标头之前启动预加载。

Beware: if you're using `preload`, `as` **must** be defined or [nothing loads](https://twitter.com/yoavweiss/status/873077451143774209), plus [Preloaded fonts without the](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [`crossorigin`](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [attribute will double fetch](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf).

请注意：如果你正在使用 `preload`，`as` **必须**定义否则[什么都不会加载](https://twitter.com/yoavweiss/status/873077451143774209)，还有，[预加载字体时如果没有 `crossorigin` 属性将会获取两次](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)

32. **Have you optimized rendering performance?**

32. **你优化渲染性能了吗？**

Isolate expensive components with [CSS containment](http://caniuse.com/#search=contain) — for example, to limit the scope of the browser's styles, of layout and paint work for off-canvas navigation, or of third-party widgets. Make sure that there is no lag when scrolling the page or when an element is animated, and that you're consistently hitting 60 frames per second. If that's not possible, then at least making the frames per second consistent is preferable to a mixed range of 60 to 15\. Use CSS' [`will-change`](http://caniuse.com/#feat=will-change) to inform the browser of which elements and properties will change.

使用 [CSS containment](http://caniuse.com/#search=contain) 隔离昂贵的组件 - 例如，限制浏览器样式、隐藏导航栏的布局和绘制，第三方组件的范围。确保在滚动页面时没有延迟，或者当一个元素进行动画时，持续地达到每秒 60 帧。如果这是不可能的，那么至少要使每秒帧数持续保持在 60 到 15 的范围。使用 CSS 的 [`will-change`](http://caniuse.com/#feat=will-change) 通知浏览器哪个元素的哪个属性将要发生变化。

Also, measure [runtime rendering performance](https://aerotwist.com/blog/my-performance-audit-workflow/#runtime-performance) (for example, [in DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/)). To get started, check Paul Lewis' free [Udacity course on browser-rendering optimization](https://www.udacity.com/course/browser-rendering-optimization--ud860) and Emily Hayman's article on [Performant Web Animations and Interactions](https://blog.algolia.com/performant-web-animations/)。

此外，评估[运行时渲染性能](https://aerotwist.com/blog/my-performance-audit-workflow/#runtime-performance)（例如，[使用 DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/)）。可以通过学习 Paul Lewis 免费的[关于浏览器渲染优化的 Udacity 课程](https://www.udacity.com/course/browser-rendering-optimization--ud860)和 Emily Hayman 的文章[优化网页动画和交互](https://blog.algolia.com/performant-web-animations/)来入门。

We also have a lil' article by Sergey Chikuyonok on how to [get GPU animation right](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/). Quick note: changes to GPU-composited layers are the [least expensive](https://blog.algolia.com/performant-web-animations/), so if you can get away by triggering only compositing via `opacity` and `transform`, you'll be on the right track.

同样，我们有 Sergey Chikuyonok 这篇文章关于如何[正确使用 GPU 动画](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/)。注意：对 GPU-composited 层的更改是[代价最小的](https://blog.algolia.com/performant-web-animations/)，如果你能通过“不透明”和“变形”来触发合成，那么你就是在正确的道路上。

33. **Have you optimized rendering experience?**

33. **你优化过渲染体验吗？**

While the sequence of how components appear on the page, and the strategy of how we serve assets to the browser matter, we shouldn't underestimate the role of [perceived performance](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/), too. The concept deals with psychological aspects of waiting, basically keeping customers busy or engaged while something else is happening. That's where [perception management](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/), [preemptive start](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#preemptive-start), [early completion](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#early-completion) and [tolerance management](https://www.smashingmagazine.com/2015/12/performance-matters-part-3-tolerance-management/) come into play.

组件以何种顺序显示在页面上以及我们如何给浏览器提供资源固然重要，但是我们同样也不能低估了[感知性能](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/)的角色。这一概念涉及到等待的心理学，主要是让顾客在其他事情发生时保持忙碌。这就涉及到了[感知管理](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/)，[优先开始](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#preemptive-start)，[提前完成](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#early-completion)和[宽容管理](https://www.smashingmagazine.com/2015/12/performance-matters-part-3-tolerance-management/)。



What does it all mean? While loading assets, we can try to always be one step ahead of the customer, so the experience feels swift while there is quite a lot happening in the background. To keep the customer engaged, we can use [skeleton screens](https://twitter.com/lukew/status/665288063195594752) ([implementation demo](https://twitter.com/razvancaliman/status/734088764960690176)) instead of loading indicators, add transitions/animations and basically [cheat the UX](https://blog.stephaniewalter.fr/en/cheating-ux-perceived-performance-and-user-experience/) when there is nothing more to optimize.

这一切意味着什么？在加载资产时，我们可以尝试始终领先于客户一步，所以在后台有很多事情发生时，体验会很快。让客户参与进来，我们可以用[骨架屏幕](https://twitter.com/lukew/status/665288063195594752)（[实例演示](https://twitter.com/razvancaliman/status/734088764960690176)），而不是当没有更多优化可做时、用加载指示，添加一些动画/过渡[欺骗用户体验](https://blog.stephaniewalter.fr/en/cheating-ux-perceived-performance-and-user-experience/)。

### HTTP/2

34. **Migrate to HTTPS, then turn on HTTP/2.**

34. **迁移到 HTTPS，然后打开 HTTP/2.**

With Google [moving towards a more secure web](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html) and eventual treatment of all HTTP pages in Chrome as being "not secure," a switch to [HTTP/2 environment](https://http2.github.io/faq/) is unavoidable. HTTP/2 is [supported very well](http://caniuse.com/#search=http2); it isn't going anywhere; and, in most cases, you're better off with it. Once running on HTTPS already, you can get a [major performance boost](https://www.youtube.com/watch?v=RWLzUnESylc&t=1s&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=25) with service workers and server push (at least long term).

在谷歌提出[向更安全的网页进军](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html)以及认为 Chrome 中所有的 HTTP 网页都是“不安全”的后，迁移到[HTTP/2]((https://http2.github.io/faq/)是不可避免的。HTTP/2[支持得非常好]it isn't going anywhere; and, in most cases, you're better off with it.（不知道啥意思，求助）。一旦运行在 HTTPS 上，你至少能够在 service workers 和 server push 方面获得[显著的性能提升](https://www.youtube.com/watch?v=RWLzUnESylc&t=1s&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=25)。


![HTTP/2](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/30dd1821-9800-4f01-91a8-1375d4812144/http-pages-chrome-opt.png)

Eventually, Google plans to label all HTTP pages as non-secure, and change the HTTP security indicator to the red triangle that Chrome uses for broken HTTPS. ([Image source](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html))

最终，谷歌计划将所有 HTTP 页面标记为不安全的，并将有问题的 HTTPS 的 HTTP 安全指示器更改为红色三角形。（[图片来源](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html)）

The most time-consuming task will be to [migrate to HTTPS](https://https.cio.gov/faq/), and depending on how large your HTTP/1.1 user base is (that is, users on legacy operating systems or with legacy browsers), you'll have to send a different build for legacy browsers performance optimizations, which would require you to adapt a [different build process](https://rmurphey.com/blog/2015/11/25/building-for-http2). Beware: Setting up both migration and a new build process might be tricky and time-consuming. For the rest of this article, I'll assume that you're either switching to or have already switched to HTTP/2.

最耗时的任务将是[迁移到 HTTPS](https://https.cio.gov/faq/)，取决于你的 HTTP/1.1 用户基础有多大（即使用旧版操作系统或浏览器的用户），你将不得不为旧版的浏览器性能优化发送不同的构建版本，这需要你采用[不同的构建流程](https://rmurphey.com/blog/2015/11/25/building-for-http2)。注意：开始迁移和新的构建过程可能会很棘手，而且耗费时间。对于本文的其余部分，我假设您将要么切换到 HTTP/2，要么已经切换到 HTTP/2。



35. **Properly deploy HTTP/2.**

35. **正确地部署 HTTP/2.**

Again, [serving assets over HTTP/2](https://www.youtube.com/watch?v=yURLTwZ3ehk) requires a partial overhaul of how you've been serving assets so far. You'll need to find a fine balance between packaging modules and loading many small modules in parallel. In the end of the day, still [the best request is no request](http://alistapart.com/article/the-best-request-is-no-request-revisited), however the goal is to find a fine balance between quick first delivery of assets and caching.

再次，[通过 HTTP/2 提供资源](https://www.youtube.com/watch?v=yURLTwZ3ehk)需要对现阶段正如何提供资源服务进行局部检查。您需要在打包模块和并行加载多个小模块之间找到一个良好的平衡。最终，仍然是[最好的请求就是没有请求](http://alistapart.com/article/the-best-request-is-no-request-revisited)，然而我们的目标是在快速传输资源和缓存之间找到一个好的平衡点。

On the one hand, you might want to avoid concatenating assets altogether, instead breaking down your entire interface into many small modules, compressing them as a part of the build process, referencing them via the ["scout" approach](https://rmurphey.com/blog/2015/11/25/building-for-http2) and loading them in parallel. A change in one file won't require the entire style sheet or JavaScript to be re-downloaded. It also [minimizes parsing time](https://css-tricks.com/musings-on-http2-and-bundling/) and keeps the payloads of individual pages low.

一方面，你可能想要避免合并所有资源，而不是把整个界面分解成许多小模块，压缩他们（作为构建过程的一部分），通过[“侦察”的方法](https://rmurphey.com/blog/2015/11/25/building-for-http2)引用和并行加载它们。一个文件的更改不需要重新下载整个样式表或 JavaScript。这样还可以[最小化解析时间](https://css- s.com/musings-on-http2-and-bundling/)，并将单个页面的负荷保持在较低的水平。

On the other hand, [packaging still matters](http://engineering.khanacademy.org/posts/js-packaging-http2.htm). First, **compression will suffer**. The compression of a large package will benefit from dictionary reuse, whereas small separate packages will not. There's standard work to address that, but it's far out for now. Secondly, browsers have **not yet been optimized** for such workflows. For example, Chrome will trigger [inter-process communications](https://www.chromium.org/developers/design-documents/inter-process-communication) (IPCs) linear to the number of resources, so including hundreds of resources will have browser runtime costs.

另一方面，[打包仍然很重要](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)。首先，**压缩将获益**。大包的压缩将从字典重用中获益，而小的单独的包则不会。有标准的工作来解决这个问题，但现在还远远不够。其次，浏览器还**没有为这种工作流优化**。例如，Chrome 将触发[进程间通信](https://www.chromium.org/developers/design-documents/inter-process-communication)（IPCs），与资源的数量成线性关系，因此页面中如果包含数以百计的资源将会造成浏览器性能损失。

![Progressive CSS loading](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/24d7fcb0-40c3-4ada-abb3-22b8524f9b2d/progressive-css-loading-opt.png)

To achieve best results with HTTP/2, consider to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/), as suggested by Chrome's Jake Archibald.

为了获得使用 HTTP/2 最好的效果，可以考虑使用[渐进地加载 CSS](https://jakearchibald.com/2016/link-in-body/)，正如 Chrome 的 Jake Archibald 所推荐的。

Still, you can try to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/). Obviously, by doing so, you are actively penalizing HTTP/1.1 users, so you might need to generate and serve different builds to different browsers as part of your deployment process, which is where things get slightly more complicated. You could get away with [HTTP/2 connection coalescing](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/), which allows you to use domain sharding while benefiting from HTTP/2, but achieving this in practice is difficult.

你可以尝试[渐进地加载 CSS](https://jakearchibald.com/2016/link-in-body/)。显然，通过这样做，您会伤害 HTTP/1.1 用户，因此您可能需要为不同的浏览器生成和提供不同的构建流程，作为部署过程的一部分，这是事情变得稍微复杂的地方。你可以使用 [HTTP/2 连接合并](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/)，它允许您使用 HTTP/2 提供的域分片，但在实践中实现这一目标是很困难的。

What to do? If you're running over HTTP/2, sending around **6–10 packages** seems like a decent compromise (and isn't too bad for legacy browsers). Experiment and measure to find the right balance for your website.

怎么做呢？如果你运行在 HTTP/2 之上，发送 **6-10 个包**是个理想的折中（对旧版浏览器也不会太差）。对于你自己的网站，你可以通过实验和测量来找到最佳的折中。

36. **Do your servers and CDNs support HTTP/2?**

36. **你的服务和 CDNs 支持 HTTP/2 吗？**

Different servers and CDNs are probably going to support HTTP/2 differently. Use [Is TLS Fast Yet?](https://istlsfastyet.com) to check your options, or quickly look up how your servers are performing and which features you can expect to be supported.

不同的服务和 CDNs 可能对 HTTP/2 的支持情况不一样。使用[TLS 够快了吗？](https://istlsfastyet.com)来查看你的可选服务，或者快速的查看你的服务的性能以及你想要其支持的特性。

![Is TLS Fast Yet?](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ff2f5-9349-46a1-9c51-7a05dc906322/istlsfastyet-opt.png)

[TLS 够快了吗？](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ff2f5-9349-46a1-9c51-7a05dc906322/istlsfastyet-opt.png)

[Is TLS Fast Yet?](https://istlsfastyet.com) allows you to check your options for servers and CDNs when switching to HTTP/2.

当你想迁移到 HTTP/2 时 [TLS 够快了吗？](https://istlsfastyet.com)可以让你查看你的可选服务和 CDNs。

37. **Is OCSP stapling enabled?**

37. **是否启动了 OCSP stapling？**

By [enabling OCSP stapling on your server](https://www.digicert.com/enabling-ocsp-stapling.htm), you can speed up your TLS handshakes. The Online Certificate Status Protocol (OCSP) was created as an alternative to the Certificate Revocation List (CRL) protocol. Both protocols are used to check whether an SSL certificate has been revoked. However, the OCSP protocol does not require the browser to spend time downloading and then searching a list for certificate information, hence reducing the time required for a handshake.

通过[在你的服务上启动 OCSP stapling](https://www.digicert.com/enabling-ocsp-stapling.htm)，你可以加速 TLS 握手。在线证书状态协议（OCSP）的提出是为了替代证书注销列表（CRL）协议。两个协议都是用于检查一个 SSL 证书是否已被撤回。但是，OCSP 协议不需要浏览器花时间下载然后在列表中搜索认证信息，因此减少了握手时间。

38. **Have you adopted IPv6 yet?**

38. **你是否已采用了 IPv6？**

Because we're [running out of space with IPv4](https://en.wikipedia.org/wiki/IPv4_address_exhaustion) and major mobile networks are adopting IPv6 rapidly (the US has [reached](https://www.google.com/intl/en/ipv6/statistics.html#tab=ipv6-adoption&tab=ipv6-adoption) a 50% IPv6 adoption threshold), it's a good idea to [update your DNS to IPv6](https://www.paessler.com/blog/2016/04/08/monitoring-news/ask-the-expert-current-status-on-ipv6) to stay bulletproof for the future. Just make sure that dual-stack support is provided across the network — it allows IPv6 and IPv4 to run simultaneously alongside each other. After all, IPv6 is not backwards-compatible. Also, [studies show](https://www.cloudflare.com/ipv6/) that IPv6 made those websites 10 to 15% faster due to neighbor discovery (NDP) and route optimization.

因为[ IPv4 即将用完](https://en.wikipedia.org/wiki/IPv4_address_exhaustion)以及主要的移动网络正在迅速采用 IPv6（美国已经[达到](https://www.google.com/intl/en/ipv6/statistics.html#tab=ipv6-adoption&tab=ipv6-adoption)50% 的 IPv6 使用阈值），[将你的 DNS 更新到 IPv6]((https://www.paessler.com/blog/2016/04/08/monitoring-news/ask-the-expert-current-status-on-ipv6) 以应对未来是一个好的想法。只要确保在网络上提供双栈支持，就可以让 IPv6 和 IPv4 同时运行。毕竟，IPv6 不是向后兼容的。[研究显示](https://www.cloudflare.com/ipv6/)，多亏了邻居发现（NDP）和路由优化，IPv6 使得这些网站快了 10% 到 15%。

39. **Is HPACK compression in use?**

39. **使用了 HPACK 压缩吗？**

If you're using HTTP/2, double-check that your servers [implement HPACK compression](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/) for HTTP response headers to reduce unnecessary overhead. Because HTTP/2 servers are relatively new, they may not fully support the specification, with HPACK being an example. [H2spec](https://github.com/summerwind/h2spec) is a great (if very technically detailed) tool to check that. [HPACK works](https://www.keycdn.com/blog/http2-hpack-compression/).

如果你使用 HTTP/2，请再次检查，确保您的服务针对 HTTP 响应头部[实现 HPACK 压缩](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/)以减少不必要的开销。由于 HTTP/2 服务相对较新，它们可能不完全支持该规范，HPACK就是一个例子。可以使用[H2spec](https://github.com/summerwind/h2spec) 这个伟大的（如果技术上很详细）工具来检查。[HPACK作品](https://www.keycdn.com/blog/http2-hpack-compression/)。

![h2spec](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/efc02119-9155-4126-b7b9-bc83c4b16436/h2spec-example-750w-opt.png)

H2spec ([View large version](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/15891f86-c883-434a-8517-209273356ee6/h2spec-example-large-opt.png)) ([Image source](https://github.com/summerwind/h2spec))

H2spec ([超大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/15891f86-c883-434a-8517-209273356ee6/h2spec-example-large-opt.png)) ([图片来源](https://github.com/summerwind/h2spec))

40. **Make sure the security on your server is bulletproof.**

40. **确保你的服务安全性是“防弹”的**

All browser implementations of HTTP/2 run over TLS, so you will probably want to avoid security warnings or some elements on your page not working. Double-check that your [security headers are set properly](https://securityheaders.io/), [eliminate known vulnerabilities](https://www.smashingmagazine.com/2016/01/eliminating-known-security-vulnerabilities-with-snyk/), and [check your certificate](https://www.ssllabs.com/ssltest/). Also, make sure that all external plugins and tracking scripts are loaded via HTTPS, that cross-site scripting isn't possible and that both [HTTP Strict Transport Security headers](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet) and [Content Security Policy headers](https://content-security-policy.com/) are properly set.

的所有实现了 HTTP/2 的浏览器都在 TLS 上运行，因此您可能希望避免安全警告或页面上的某些元素不起作用。仔细检查你的[安全头部被正确设置](https://securityheaders.io/)，[消除已知的漏洞](https://www.smashingmagazine.com/2016/01/eliminating-known-security-vulnerabilities-with-snyk/)，[检查你的证书](https://www.ssllabs.com/ssltest/)。同时，确保所有外部插件和跟踪脚本通过 HTTPS 加载，不允许跨站点脚本，[HTTP 严格传输安全头](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)和[内容安全策略头](https://content-security-policy.com/)是正确的设置。

41. **Are service workers used for caching and network fallbacks?**

41. **是否使用了 service workers 来缓存以及用作网络回退？**

No performance optimization over a network can be faster than a locally stored cache on user's machine. If your website is running over HTTPS, use the "[Pragmatist's Guide to Service Workers](https://github.com/lyzadanger/pragmatist-service-worker)" to cache static assets in a service worker cache and store offline fallbacks (or even offline pages) and retrieve them from the user's machine, rather than going to the network. Also, check Jake's [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/) and the free Udacity course "[Offline Web Applications](https://www.udacity.com/course/offline-web-applications--ud899)." Browser support? As stated above, it's [widely supported](http://caniuse.com/#search=serviceworker) (Chrome, Firefox, Safari TP, Samsung Internet, Edge 17+) and the fallback is the network anyway. Does it help boost performance? [Oh yes, it does](https://developers.google.com/web/showcase/2016/service-worker-perf).

没有什么网络性能优化能快过用户机器上的本地缓存。如果你的网站运行在 HTTPS 上，使用 “[Service Workers 的实用指南](https://github.com/lyzadanger/pragmatist-service-worker)” 在一个 service worker 中缓存静态资源并存储离线回退（甚至脱机页面）并从用户的机器中检索它们，而不是访问网络。同时，参考
Jake 的 [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/) 和 Udacity 免费课程“[离线 Web 应用程序](https://www.udacity.com/course/offline-web-applications--ud899)”。浏览器支持？如上所述，它得到了[广泛支持](http://caniuse.com/#search=serviceworker) （Chrome、Firefox、Safari TP、Samsung Internet、Edge 17+），但不管怎么说，它都是网络。它有助于提高性能吗？[哦，是的，它确实](https://developers.google.com/web/showcase/2016/service-worker-perf)。

### Testing And Monitoring

### 测试和监控

42. **Have you tested in proxy browsers and legacy browsers?**

42. **你是否在代理浏览器和旧版浏览器中测试过？**

Testing in Chrome and Firefox is not enough. Look into how your website works in proxy browsers and legacy browsers. UC Browser and Opera Mini, for instance, have a [significant market share in Asia](http://gs.statcounter.com/#mobile_browser-as-monthly-201511-201611) (up to 35% in Asia). [Measure average Internet speed](https://www.webworldwide.io/) in your countries of interest to avoid big surprises down the road. Test with network throttling, and emulate a high-DPI device. [BrowserStack](https://www.browserstack.com) is fantastic, but test on real devices as well.

在 Chrome 和 Firefox 中进行测试是不够的。看看你的网站在代理浏览器和旧版浏览器中是如何工作的。例如，UC 浏览器和 Opera Mini，[在亚洲有大量的市场份额](http://gs.statcounter.com/#mobile_browser-as-monthly-201511-201611) （达到 35%）。在你感兴趣的国家[测量平均网络速度](https://www.webworldwide.io/)从而避免在未来发现“大惊喜”。测试网络节流，并仿真一个高 DPI 设备。[BrowserStack](https://www.browserstack.com) 很不错，但也要在实际设备上测试。

[![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96fa3207-4fff-4b7b-bfa0-c115062d826a/demo-unit-perf-tests.gif)](https://github.com/loadimpact/k6)


[k6](https://github.com/loadimpact/k6) allows you write unit tests-alike performance tests.

[k6](https://github.com/loadimpact/k6) 可以让你像写单元测试一样编写性能测试用例。

43. **Is continuous monitoring set up?**

43. **是否启用了持续监控？**

Having a private instance of [WebPagetest](http://www.webpagetest.org/) is always beneficial for quick and unlimited tests. However, a continuous monitoring tool with automatic alerts will give you a more detailed picture of your performance. Set your own user-timing marks to measure and monitor business-specific metrics. Also, consider adding [automated performance regression alerts](https://calendar.perfplanet.com/2017/automating-web-performance-regression-alerts/) to monitor changes over time.

有一个[WebPagetest](http://www.webpagetest.org/)私人的实例总是有利于快速和无限的测试。但是，一个带有自动警报的连续监视工具将会给您提供更详细的性能描述。设置您自己的用户计时标记来度量和监视特定的业务指标。同时，考虑添加[自动化性能回归警报](https://calendar.perfplanet.com/2017/automating-web-performance-regression-alerts/)来监控随着时间而发生的变化。

Look into using RUM-solutions to monitor changes in performance over time. For automated unit-test-alike load testing tools, you can use [k6](https://github.com/loadimpact/k6) with its scripting API. Also, look into [SpeedTracker](https://speedtracker.org), [Lighthouse](https://github.com/GoogleChrome/lighthouse) and [Calibre](https://calibreapp.com).

使用 RUM 解决方案来监视性能随时间的变化。对于自动化的类单元测试的负载测试工具，您可以使用 [k6](https://github.com/loadimpact/k6) 脚本 API。此外，可以了解下 [SpeedTracker](https://speedtracker.org)、[Lighthouse](https://github.com/GoogleChrome/lighthouse) 和 [Calibre](https://calibreapp.com)。

### Quick Wins

### 速效方案

This list is quite comprehensive, and completing all of the optimizations might take quite a while. So, if you had just 1 hour to get significant improvements, what would you do? Let's boil it all down to **10 low-hanging fruits**. Obviously, before you start and once you finish, measure results, including start rendering time and SpeedIndex on a 3G and cable connection.

这个列表非常全面，完成所有的优化可能需要很长时间。所以，如果你只有一个小时的时间来进行重大的改进，你会怎么做？让我们把这一切归结为**10个低挂的水果**。显然，在你开始之前和完成之后，测量结果，包括开始渲染时间以及在 3G 和电缆连接下的速度指数。

1. Measure the real world experience and set appropriate goals. A good goal to aim for is First Meaningful Paint < 1 s, a SpeedIndex value < 1250, Time to Interactive < 5s on slow 3G, for repeat visits, TTI < 2s. Optimize for start rendering time and time-to-interactive.

1. 测量实际环境的体验并设定适当的目标。一个好的目标是：第一次有意义的绘制 < 1 s，速度指数 < 1250，在慢速的 3G 网络上的交互 < 5s，对于重复访问，TTI < 2s。优化渲染开始时间和交互时间。

2. Prepare critical CSS for your main templates, and include it in the `<head>` of the page. (Your budget is 14 KB). For CSS/JS, operate within a critical file size [budget of max. 170Kb gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (0.8-1MB decompressed).

2. 为您的主模板准备关键的 CSS，并将其包含在页面的 `<head>` 中。（你的预算是 14 KB）。对于 CSS/JS，文件大小[不超过 170 KB gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)（解压后 0.8-1 MB）。

3. Defer and lazy-load as many scripts as possible, both your own and third-party scripts — especially social media buttons, video players and expensive JavaScript.

3. 延迟加载尽可能多的脚本，包括您自己的和第三方的脚本——特别是社交媒体按钮、视频播放器和耗时的 JavaScript 脚本。

4. Add resource hints to speed up delivery with faster `dns-lookup`, `preconnect`, `prefetch` and `preload`.

4. 添加资源提示，使用 `dns-lookup`、`preconnect`、`prefetch` 和 `preload` 加速传输。

5. Subset web fonts and load them asynchronously (or just switch to system fonts instead).

5. 分离 web 字体，并以异步方式加载它们（或切换到系统字体）。

6. Optimize images, and consider using WebP for critical pages (such as landing pages).

6. 优化图像，并在重要页面（例如登录页面）中考虑使用 WebP。

7. Check that HTTP cache headers and security headers are set properly.

7. 检查 HTTP 缓存头和安全头是否设置正确。

8. Enable Brotli or Zopfli compression on the server. (If that's not possible, don't forget to enable Gzip compression.)

8. 在服务器上启用 Brotli 或 Zopfli 压缩。（如果做不到，不要忘记启用 Gzip 压缩。）

9. If HTTP/2 is available, enable HPACK compression and start monitoring mixed-content warnings. If you're running over LTS, also enable OCSP stapling.

9. 如果 HTTP/2 可用，启用 HPACK 压缩并开启混合内容警告监控。如果您正在运行 LTS，也可以启用 OCSP stapling。

10. Cache assets such as fonts, styles, JavaScript and images — actually, as much as possible! — in a service worker cache.

10. 在 service worker 缓存中尽可能多的缓存资产，如字体、样式、JavaScript 和图像。

### Download The Checklist (PDF, Apple Pages)

### 清单下载（PDF, Apple Pages）

With this checklist in mind, you should be prepared for any kind of front-end performance project. Feel free to download the print-ready PDF of the checklist as well as an **editable Apple Pages document** to customize the checklist for your needs:

记住了这个清单，您就已经为任何类型的前端性能项目做好了准备。请随意下载该清单的打印版PDF，以及一个**可编辑的苹果页面文档**，以定制您需要的清单：

* [Download the checklist PDF](https://www.dropbox.com/s/8h9lo8ee65oo9y1/front-end-performance-checklist-2018.pdf?dl=0) (PDF, 0.129 MB)
* [Download the checklist in Apple Pages](https://www.dropbox.com/s/yjedzbyj32gzd9g/performance-checklist-1.1.pages?dl=0) (.pages, 0.236 MB)


If you need alternatives, you can also check the [front-end checklist by Dan Rublic](https://github.com/drublic/checklist) and the "[Designer's Web Performance Checklist](http://jonyablonski.com/designers-wpo-checklist/)" by Jon Yablonski.

如果你需要其他选择，你也可以参考 [Rublic 的前端清单](https://github.com/drublic/checklist)和 Jon Yablonski 的“[设计师的 Web 性能清单](http://jonyablonski.com/designers-wpo-checklist/)”。

### Off We Go!

### 我们

Some of the optimizations might be beyond the scope of your work or budget or might just be overkill given the legacy code you have to deal with. That's fine! Use this checklist as a general (and hopefully comprehensive) guide, and create your own list of issues that apply to your context. But most importantly, test and measure your own projects to identify issues before optimizing. Happy performance results in 2018, everyone!

一些优化可能超出了您的工作或预算范围，或者由于需要处理遗留代码而显得过度滥用。没问题！使用这个清单作为一个通用（并且希望是全面的）指南，并创建适用于你的环境的你自己的问题清单。但最重要的是，测试和度量您自己的项目，以在优化前确定问题。祝大家 2018 年的性能大涨！

_A huge thanks to Guy Podjarny, Yoav Weiss, Addy Osmani, Artem Denysov, Denys Mishunov, Ilya Pukhalski, Jeremy Wagner, Colin Bendell, Mark Zeman, Patrick Meenan, Leonardo Losoviz, Andy Davies, Rachel Andrew, Anselm Hannemann, Patrick Hamann, Andy Davies, Tim Kadlec, Rey Bango, Matthias Ott, Mariana Peralta, Philipp Tellis, Ryan Townsend, Mohamed Hussain S H, Jacob Groß, Tim Swalling, Bob Visser, Kev Adamson, Aleksey Kulikov and Rodney Rehm for reviewing this article, as well as our fantastic community, which has shared techniques and lessons learned from its work in performance optimization for everybody to use. You are truly smashing!_

_非常感谢 Guy Podjarny, Yoav Weiss, Addy Osmani, Artem Denysov, Denys Mishunov, Ilya Pukhalski, Jeremy Wagner, Colin Bendell, Mark Zeman, Patrick Meenan, Leonardo Losoviz, Andy Davies, Rachel Andrew, Anselm Hannemann, Patrick Hamann, Andy Davies, Tim Kadlec, Rey Bango, Matthias Ott, Mariana Peralta, Philipp Tellis, Ryan Townsend, Mohamed Hussain S H, Jacob Groß, Tim Swalling, Bob Visser, Kev Adamson, Aleksey Kulikov and Rodney Rehm 对这篇文章的校对，同样也感谢我们出色的社区，分享了他们在性能优化工作中学习到的技术和经验，供大家使用。你们真正的非常了不起！
_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
