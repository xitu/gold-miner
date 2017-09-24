> * 原文地址：[Preload, Prefetch And Priorities in Chrome](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)
> * 原文作者：本文已获原作者 [Addy Osmani](https://medium.com/@addyosmani) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[IridescentMia](https://github.com/IridescentMia),[vuuihc](https://github.com/vuuihc)


<img src="https://cdn-images-1.medium.com/max/2000/1*W4_tAMHlFs6tunMxbXQjFA.png">

# **Preload，Prefetch 和它们在 Chrome 之中的优先级**

今天我们来深入研究一下 Chrome 的网络协议栈，来更清晰的描述早期网络加载（像 [**\<link rel=“preload”>**](https://w3c.github.io/preload/) 和 [**\<link rel=“prefetch”>**](https://w3c.github.io/resource-hints/)）背后的工作原理，让你对其更加了解。

**像[其他文章](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/)描述的那样，preload 是声明式的 fetch，可以强制浏览器请求资源，同时不阻塞文档 [onload](https://developer.mozilla.org/en-US/docs/Web/API/GlobalEventHandlers/onload) 事件。**

**Prefetch 提示浏览器这个资源将来可能需要**，但是把决定是否和什么时间加载这个资源的决定权交给浏览器。

<img src="https://cdn-images-1.medium.com/max/2000/1*PSMeFcC3AXDUmdNf5l19Ug.jpeg">

Preload 将 load 事件与脚本解析过程解耦，如果你还没有用过它，看看 Yoav Weiss 的文章 [Preload: What is it Good For?](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/)。

### Preload 在生产环境的成功案例

在我们深入细节之前，下面是上一年发现的使用 proload 并对加载产生积极影响的案例总结：

Housing.com 在对他们的渐进式 Web 应用程序的脚本转用 proload 看到[**大约缩短了10%的可交互时间**](https://twitter.com/HousingEngg/status/844169796891508737)。

<img src="https://cdn-images-1.medium.com/max/2000/1*fZH0GKzI42x7IgxKfiaddA.png">

Shopify 在转用 [preload 加载字体](https://www.bramstein.com/writing/preload-hints-for-web-fonts.html)后在 Chrome 桌面版获得了 [**50%**（1.2s）](https://twitter.com/ShopifyEng/status/844245243948163072) 的文字渲染优化，这完全解决了他们的文字闪动问题。

<img src="https://cdn-images-1.medium.com/max/1000/0*rDnsYXceRwO-xxSZ.">

左边：使用 preload，右边：不使用 preload（[视频](https://video.twimg.com/tweet_video/C7dcmxaUwAAUhPX.mp4)）

<img src="https://cdn-images-1.medium.com/max/1000/1*r2RiRVrghz5iDUnhBX8W1Q.png">

使用`<link rel=”preload”>` 加载字体。

Treebo，印度最大的旅馆网站之一，在 3G 网络下对其桌面版试验，在对其顶部图片和主要的 Webpack 打包文件使用 preload 之后，在**首屏绘制和可交互延迟分别减少了** [**1s**](https://twitter.com/__lakshya/status/844429211867791361)。

<img src="https://cdn-images-1.medium.com/max/2000/1*SKYdHNpGldFFUPZBDZQgSQ.png">

同样的，在对自己的渐进式 Web 应用程序主要打包文件使用 preload 之后，Flipkart 在路由解析之前 **节省了大量的主线程空闲时间**（在 3G 网络下的低性能手机下）。

<img src="https://cdn-images-1.medium.com/max/1000/0*QL0ztXPZ1wUXpRKX.">

上面：未使用 preload，下面：使用 preload

Chrome 数据保护团队在对脚本和 CSS 样式表使用 preload 之后，发现页面首次绘制时间获得[**平均 12%**](https://medium.com/reloading/a-link-rel-preload-analysis-from-the-chrome-data-saver-team-5edf54b08715#.bgj9qkqfr) 的速度提升。

对于 prefetch ，它被广泛使用，在 Google 我们仍用它来获取可以加快 [搜索结果页面](https://plus.google.com/+IlyaGrigorik/posts/ahSpGgohSDo) 的渲染的关键资源。

Preload 在很多大型网站都有实际应用，这点你在接下来的文章里也可以看到，让我们来仔细探讨下网络协议栈实际上是如何对待 preload 和 prefetch 的。

### 什么时候该用 \<link rel=”preload”> ？ 什么时候又该用 \<link rel=”prefetch”> ?

**建议：对于当前页面很有必要的资源使用 preload，对于可能在将来的页面中使用的资源使用 prefetch。**

preload 是对浏览器指示预先请求当前页需要的资源（关键的脚本，字体，主要图片）。

prefetch 应用场景稍微又些不同 —— 用户将来可能在其他部分（比如视图或页面）使用到的资源。如果 A 页面发起一个 B 页面的 prefetch 请求，这个资源获取过程和导航请求可能是同步进行的，而如果我们用 preload 的话，页面 A 离开时它会立即停止。

使用 preload 和 prefetch，我们有了对当前页面和将来页面加载关键资源的解决办法。

###  \<link rel="preload"> 和 \<link rel="prefetch"> 的缓存行为

[Chrome 有四种缓存](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/): HTTP 缓存，内存缓存，Service Worker 缓存和 Push 缓存。preload 和 prefetch 都被存储在 **HTTP 缓存中**。

当一个资源被 **preload 或者 prefetch** 获取后，它可以从 HTTP 缓存移动至渲染器的内存缓存中。如果资源可以被缓存（比如说存在有效的[cache-control](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) 和 max-age），它被存储在 HTTP 缓存中可以被**现在或将来的任务使用**，如果资源不能被缓存在 HTTP 缓存中，作为代替，它被放在内存缓存中直到被使用。

### Chrome 对于 preload 和 prefetch 的网络优先级？

下面是在 Blink 内核的 Chrome 46 及更高版本中不同资源的加载优先级情况（ [Pat Meenan](https://docs.google.com/document/d/1bCDuq9H1ih9iNjgzyAL0gpwNFiEP4TZS-YLRp_RuMlc/edit#)）

<img src="https://cdn-images-1.medium.com/max/1000/1*BTi3YhvCAYiJYRpjNQft9Q.jpeg">

preload 用 “as” 或者用 “type” 属性来表示他们请求资源的优先级（比如说 preload 使用 as="style" 属性将获得最高的优先级）。没有 “as” 属性的将被看作异步请求，“Early”意味着在所有未被预加载的图片请求之前被请求（“late”意味着之后）,感谢 Paul Irish 更新这张关于开发者工具以及网络层上各种请求优先级的表。

我们来谈一下这张表。

**脚本根据它们在文件中的位置是否异步、延迟或阻塞获得不同的优先级**：

* 网络在第一个图片资源之前阻塞的脚本在网络优先级中是中级
* 网络在第一个图片资源之后阻塞的脚本在网络优先级中是低级
* 异步／延迟／插入的脚本（无论在什么位置）在网络优先级中是很低级

图片（视口可见）将会获得相对于视口不可见图片（低级）的更高的优先级（中级），所以某些程度上 Chrome 将会尽量懒加载这些图片。低优先级的图片在布局完成被视口发现时，将会获得优先级提升（但是注意已经在布局完成后的图片将不会更改优先级）。

preload 使用 “as” 属性加载的资源将会获得与资源 “type” 属性所拥有的**相同的优先级**。比如说，preload as="style" 将会获得比 as=“script” 更高的优先级。这些资源同样会受内容安全策略的影响（比如说，脚本会受到其 “src” 属性的影响）。

不带 “as” 属性的 preload 的优先级将会等同于异步请求。

如果你想了解各种资源加载时的优先级属性，从开发者工具的 Timeline/Performance 区域的 Network 区域都能看到相关信息：

<img  src="https://cdn-images-1.medium.com/max/2000/1*5QsDQsYJ4ts-4Tl0_1dZwQ.png">

在 Network 面板下的“Priority”部分

<img src="https://cdn-images-1.medium.com/max/1000/0*26d5UlWhql2NZ0Eg.">

### 当页面 preload 已经在 Service Worker 缓存及 HTTP 缓存中的资源时会发生什么？

这就要说看情况了，但通常来说，会是比较好的情况 —— 如果资源没有超出 HTTP 缓存时间或者 Service Worker 没有主动重新发起请求，那么浏览器就不会再去请求这个资源了。

如果资源在 HTTP 缓存（ Service Worker 缓存和网络中），那么 preload 将会获得一次缓存命中。

### 这将会浪费用户的带宽吗？

**用“preload”和“prefetch”情况下，如果资源不能被缓存，那么都有可能浪费一部分带宽。**

没有用到的 preload 资源在 Chrome 的 console 里会在 *onload* 事件 3s 后发生警告。

<img src="https://cdn-images-1.medium.com/max/1000/0*Um55iV_tEBO3eXEs.">

原因是你可能为了改善性能使用 preload 来缓存一定的资源，但是如果没有用到，你就做了无用功。在手机上，这相当于浪费了用户的流量，所以明确你要 preload 对象。

### 什么情况会导致二次获取？

preload 和 prefetch 是很简单的工具，你很容易不小心[二次获取](https://bugs.chromium.org/p/chromium/issues/list?can=2&amp;q=preload%20double%20owner%3Ayoav%40yoav.ws)。

不要用 “prefetch” 作为 “preload” 的后备，它们适用于不同的场景，常常会导致不符合预期的二次获取。使用 preload 来获取当前需要任务否则使用 prefetch 来获取将来的任务，不要一起用。

<img src="https://cdn-images-1.medium.com/max/1000/0*KKong0kz69LOteD3.">

不要指望 preload 和 fetch() 配合使用，在 Chrome 中这样使用将会导致二次的下载。这并不只发生在异步请求的情况我们有一个关于这个问题公开的 [bug](https://bugs.chromium.org/p/chromium/issues/detail?id=652228)。

**对 preload 使用 “as” 属性，不然将不会从中获益**。

如果你对你所 preload 的资源使用明确的 “as” 属性，比如说，脚本，你将会导致[二次获取](https://twitter.com/DasSurma/status/808791438171537408)。

**preload 字体不带 crossorigin 也将会二次获取！** 确保你对 preload 的字体添加 [crossorigin](https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_settings_attributes) 属性，否则他会被下载两次，这个请求使用匿名的跨域模式。这个建议也适用于字体文件在相同域名下，也适用于其他域名的获取(比如说默认的异步获取)。

**存在 intergrity 属性的资源不能使用 preload 属性（目前）也会导致二次获取。**链接元素的 `[integrity](https://bugs.chromium.org/p/chromium/issues/detail?id=677022)` 属性目前还没有被支持，目前有一个关于它的开放[issue](https://github.com/w3c/webappsec-subresource-integrity/issues/26)，这意味着存在 integrity 的元素将会丢弃 preload 的资源。往宽了讲，这会导致重复的请求，你需要在安全和性能之间作出权衡。

最后，虽然它不会导致二次获取，还是有下面的建议：

**不要 preload 所有东西！** 作为替代的，用 preload 来告诉浏览器一些本来不能被提早发现的资源，以便提早获取它们。

### 我应当在页面头部加载所有的资源文件吗？有什么建议比如说限制“只加载6个文件”？

这是**工具而不是规则**的好例子。你 preload 的文件数量取决于加载其他资源时网络内容、用户的带宽和其他网络状况。

尽早 preload 页面中可能需要的文件，对于脚本文件，preload 关键打包文件很有用因为它将加载与执行分离开来，`script async`不好因为它会阻塞 window 的 onload 事件。你可以尽早加载图片、样式、字体和媒体资源。大部分的 —— 最重要的是，你作为作者是可以清晰的知道哪些东西是页面目前需要的。

### prefetch 有哪些你需要知道的魔法属性吗？当然

在 Chrome 中，如果用户从一个页面跳转到另一个页面，prefetch 发起的请求仍会进行不会中断。

另外，prefetch 的资源在网络堆栈中至少缓存 5 分钟，无论它是不是可以缓存的。

### 我在 JS 中使用自定义的 “preload”，它跟原本的 rel="preload" 或者 preload 头部有什么不同？

preload 将资源获取与执行解耦，像这样，preload 在标记中声明以被 Chrome preload 扫描器扫描。这意味着，在许多案例中，在 HTML 解析器获取到标签之前，preload 就会被获取（用它声明的优先级）。这将会比自定义的 preload 更加强大。

### 等一下，我不是可以用 HTTP/2 的服务器推送来代替 preload 吗？

当你知道资源加载的正确顺序时使用推送，用 service worker 来拦截那些可能需要会导致二次获取的资源请求，用 preload 来加快第一个请求的开始时间 —— 这对所有的资源获取都有用。

再次说一下，这都要看[情况](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit)，我们试想一下位 Google Play 商店做购物车，对于一个向购物车的请求：

用 preload 来加载页面的主要的模块需要浏览器等待 play.google.com/cart 有效载荷以便 preload 扫描器发现依赖，但这之后会浸透网络管道可以更好的像资源发起请求，这可能不是最理想的冷启动，但对于高速缓存和带宽的后续请求非常友好。

使用 HTTP/2 的服务器推送，当请求 play.google.com/cart 我们可以快速浸透网络管道，但如果资源已经在 HTTP 或者 Service Worker 缓存中的话我们就浪费了带宽，两种方法都需要做出权衡。

虽然推送很有效，但它不像 preload 那样对所有的情况都适应。

preload 利于下载与执行的解耦，多亏其对文档 onload 事件的支持我们现在可以控制其加载完毕后的事件，获取 JS 包文件在空闲快执行或者获取 CSS 模块在正确的时间点执行，可以说是非常强大的。

推送不能用于第三方资源的内容，通过立即发送资源，它还有效地缩短浏览器自身的资源优先级情况。在你明确的知道在做什么时，这应该会提高你的应用性能，如果不是很清晰的话，你也许会损失掉部分的性能。

### preload HTTP 头是什么？跟 preload 标签有什么不同？又跟 HTTP/2 服务器推送有什么不同？

跟其他链接不同，preload 链接即可以放在 HTML 标签里也可以放在 HTTP 头部（[preload HTTP 头](https://w3c.github.io/preload/#server-push-http-2)），每种情况下，都会直接使浏览器加载资源并缓存在内存里，表明页面有很高的可能性用这些资源并且不想等待 preload 扫描器或者解析器去发现它。

当金融时报在它们的网站使用 preload HTTP 头时，他们节约了**大约 [1s](https://twitter.com/wheresrhys/status/843252599902167040) 的显示片头图片时间**。

<img src="https://cdn-images-1.medium.com/max/2000/1*QGUllBDRLMjdy1uawXG8EQ.jpeg">

下面的：使用 preload，上面：使用 preload。在 3G 网络下的 Moto G4 测试。

原来：[https://www.webpagetest.org/result/170319_Z2_GFR/](https://www.webpagetest.org/result/170319_Z2_GFR/)，之后: [https://www.webpagetest.org/result/170319_R8_G4Q/](https://www.webpagetest.org/result/170319_R8_G4Q/)。你可以使用两种形式的 preload，但应当知道很重要的一点：根据规范，许多服务器当它们遇到 preload HTTP 头会发起 HTTP/2 推送，HTTP/2 推送的性能影响不同于普通的预加载，所以你要确保没有发起不必要的推送。

你可以使用 preload 标签来代替 preload 头以避免不必要的推送，或者在你的 HTTP 头上加一个 “nopush” 属性。

### 我怎样检测 link rel=preload 的支持情况呢？

用下面的代码段可以检测`<link rel=”preload”>`是否被支持：

	const preloadSupported = () => {
	      const link = document.createElement('link');
	      const relList = link.relList;
	      if (!relList || !relList.supports)
	        return false;
	      return relList.supports('preload');
	    };

FilamentGroup 也有一个 [preload](https://github.com/filamentgroup/loadCSS/blob/master/src/cssrelpreload.js#L8-L14) 检测器 ，作为他们的异步 CSS 加载库 [loadCSS](https://github.com/filamentgroup/loadCSS) 的一部分。

### 你可以让 preload的 CSS 样式表立即生效吗？

当然，preload 支持基于异步加载的标记，使用 `<link rel=”preload”>` 的样式表使用 `onload` 事件立即应用到文档：

	<link rel="preload" href="style.css" onload="this.rel=stylesheet">

更多相关的例子，看一下 Yoav Weiss 很棒的[使用实例](http://yoavweiss.github.io/link_htmlspecial_16/#53)。

### preload 还有哪些更广泛的应用？

**根据 HTTPArchive，[很多网站](https://twitter.com/addyosmani/status/843254667316465664)应用 `<link rel=”preload”>` 来加载[字体](https://www.zachleat.com/web/preload/)，包括 Teen Vogue 和以上提到的其他网站：**

<img src="https://cdn-images-1.medium.com/max/2000/1*osYEtZ6gZnmstK4fpcJTrg.png">

**[其他](https://twitter.com/addyosmani/status/843258951110074368)一些网站，比如 LifeHacker 和 JCPenny 用 FilamentGroup 的 [loadCSS](https://github.com/filamentgroup/loadCSS) 来异步加载 CSS:**

<img src="https://cdn-images-1.medium.com/max/2000/1*BxecU2LjN-uGAW_uQgDTdw.png">

**有越来越多的渐进式 Web 应用程序（比如 Twitter.com 移动端， Flipkart 和 Housing）使用它来加载当前链接需要的脚本：**

<img src="https://cdn-images-1.medium.com/max/2000/1*rppoHbaTTJQNVZBO4j_NAQ.png">

基本的观点是要保持高粒度而不是单片，所以任何应用都可以按需加载依赖或者预加载资源并放在缓存中。

### 当前浏览器对 preload 和 prefetch 的支持度？

根据 CanIUse 在 [Safari Tech Preview](https://developer.apple.com/safari/technology-preview/release-notes/)的调查看，`<link rel="preload">` 大约有 [50%](http://caniuse.com/#feat=link-rel-preload) 的支持度，`<link rel="prefetch">` 大约有 [70%](http://caniuse.com/#search=prefetch) 的支持度。
`<link rel="preload">` is available to [~50% ](http://caniuse.com/#feat=link-rel-preload)of the global population according to CanIUse and is implemented in the [Safari Tech Preview](https://developer.apple.com/safari/technology-preview/release-notes/). `<link rel="prefetch">` is available to [71%](http://caniuse.com/#search=prefetch) of global users.

### 更多有用的见解

* Yoav Weiss 最近对 Chrome 里 preload CSS 和 阻塞的脚本做了[更改](https://twitter.com/yoavweiss/status/843810722383630337%20)。
* 他最近还把 preload 媒体[分成](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/BN6tqGLBmuI)三个不同的类型：video、audio 和 track。
* Domenic Denicola 正在[寻求](https://github.com/whatwg/html/pull/2383)规格的改变以便支持 ES6 模块。
* Yoav Weiss 最近还增加了在 HTTP 头部支持 [Link header support for “prefetch”](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/8Zo2HiNEs94/h8mDVkx0EwAJ) 以便更容易的加载下一个页面的资源。

### 拓展阅读

- [Preload — what is it good for?](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) — Yoav Weiss
- [A <link rel=”preload”> study](https://twitter.com/ChromiumDev/status/837715866078752768) by the Chrome Data Saver team
- [Planning for performance](https://www.youtube.com/watch?v=RWLzUnESylc) — Sam Saccone
- [Webpack plugin](https://github.com/googlechrome/preload-webpack-plugin) for auto-wiring up <link rel=”preload”>
- [What is preload, prefetch and preconnect?](https://www.keycdn.com/blog/resource-hints/) — KeyCDN
- [Web Fonts preloaded](https://www.zachleat.com/web/preload/) by Zach Leat
- [HTTP Caching: cache-control](https://www.google.com/url?q=https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching%23cache-control&amp;sa=D&amp;ust=1490641457910000&amp;usg=AFQjCNEb6fMArN_ahD7ySMICPF1Obf4rsw) by Ilya Grigorik

感谢 @ShopifyEng、@AdityaPunjani、@HousingEngg、@adgad、@wheresrhys 和 @__lakshya 分享的统计信息。

***非常感谢下列技术审核与建议人员: Ilya Grigorik, Gray Norton, Yoav Weiss, Pat Meenan, Kenji Baheux, Surma, Sam Saccone, Charles Harrison, Paul Irish, Matt Gaunt, Dru Knox, Scott Jehl.***

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
