> * 原文地址：[Front-End Performance Checklist 2019 — 6](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)
> * 译者：[子非](https://github.com/CoolRice/)
> * 校对者：

# 2019 前端性能优化年度总结 — 第六部分

现在我们让 2019……更快！年度前端性能清单，这里有目前你需要知道的关于创建快速体验的全部知识。本清单从 2016 年开始更新。

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> **[译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)**

#### 内容目录

- [HTTP/2](#http2)
  - [52. 迁移到 HTTPS，然后启用 HTTP/2](#52-迁移到-https-然后打开-http2)
  - [53. 合适地部署 HTTP/2](#53-恰当地部署-http2)
  - [54. 你的服务器和 CDN 支持 HTTP/2 吗？](#54-你的服务器和-cdn-支持-http2-吗)
  - [55. OCSP Stapling 是否启用？](#55-ocsp-stapling-是否启用)
  - [56. 你采用 IPv6 了吗？](#56-你采用-ipv6-了吗)
  - [57. 是否使用 HPACK 压缩？](#57-是否使用-hpack-压缩)
  - [58. 确保你的服务器安全稳固**](#58-确保你的服务器安全稳固)
- [测试和监控](#测试和监控)
  - [59. 你优化过你的测试流程吗？](#59-你优化过你的测试流程吗)
  - [60. 你测试过有代理和过时的浏览器吗？](#60-你测试过有代理和过时的浏览器吗)
  - [61. 你测试过辅助工具的性能吗？](#61-你测试过辅助工具的性能吗)
  - [62. 是否设置了持续监控？](#62-是否设置了持续监控)
- [速效方案](#速效方案)
- [下载清单 （PDF，Apple Pages）](#下载清单-pdf-apple-pages)
- [出发！](#出发)

### HTTP/2

#### 52. 迁移到 HTTPS，然后启用 HTTP/2

随着 Google [推进更安全的 web](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html)  并最终所有的 HTTP 页面都被 Chrome 视为“不安全”，[向 HTTP/2 环境转变](https://http2.github.io/faq/)已经不可避免。HTTP/2 现在已经得到了[很好的支持](http://caniuse.com/#search=http2)；它没有任何大的改变；并且在大多数情况下，使用它会让你得到出色的性能表现。一旦在已经 HTTPS 运行了，你可以使用 service workes 和 server push 得到[巨大的性能提升](https://www.youtube.com/watch?v=RWLzUnESylc&t=1s&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=25)（至少长期来看）。

![HTTP/2](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/30dd1821-9800-4f01-91a8-1375d4812144/http-pages-chrome-opt.png)

最终 Google 打算标记所有 HTTP 页面为非安全，并把 Chrome 标记非 HTTPS 使用的 HTTP 安全标记变为红色三角形。([图像来源](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html))

大多数情况下使用者的工作是[迁移至 HTTPS](https://https.cio.gov/faq/)，并且依赖于你的 HTTP/1.1 用户数多少（指用户使用过时的操作系统和浏览器）你不得不要考虑过时浏览器的性能优化而发送不同构建的版本，这需要你采纳不同的[构建进程](https://rmurphey.com/blog/2015/11/25/building-for-http2)。注意：迁移和新构建进程同时进行会很麻烦并消耗很多时间。在本文的余下内容中，我会假设你正在或已经迁移 HTTP/2。

#### 53. 合适地部署 HTTP/2

[为让资源运行在 HTTP/2 上](https://www.youtube.com/watch?v=yURLTwZ3ehk)需要部分检查已经存在的资源。你需要在打包成一个大模块和并行加载许多小模块之间找到合适的平衡。[最好的请求就是没有请求](http://alistapart.com/article/the-best-request-is-no-request-revisited)，然而目标是在首次快速分发资源和缓存之间找到一个好的平衡。

一方面，你可能想避免资源全都合并在一起，而是把全部的借口分割成许多小的模块，把它们压缩为构建进程的一部分，通过 [“侦查”途径](https://rmurphey.com/blog/2015/11/25/building-for-http2)引用并并行加载它们。一个文件的改变不需要重新加载全部样式或 JavaScript 。它还[压缩解析时间](https://css-tricks.com/musings-on-http2-and-bundling/)并为独立的页面从而保持少量的资源负载。

另一方面，[打包仍然是个问题](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)。首先，**压缩会受到影响**。大模块压缩会受益于字典复用，而小的独立模块不会。是有一些标准来解决这个问题，但是目前还差得很远。第二，浏览器针对这种流程**还没有做优化**。例如，Chrome 会触发[进程间通讯](https://www.chromium.org/developers/design-documents/inter-process-communication)（IPC）和资源数的线性关系，这样大量的资源会消耗浏览器运行时。

![渐进式 CSS 加载](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/24d7fcb0-40c3-4ada-abb3-22b8524f9b2d/progressive-css-loading-opt.png)

为了获得使用 HTTP/2 的最佳效果，请考虑[渐进式加载 CSS](https://jakearchibald.com/2016/link-in-body/)，这是来自 Chrome 成员 Jake Archibald 的建议。

你可以尝试[渐进加载式 CSS](https://jakearchibald.com/2016/link-in-body/)。实际上，自从 Chrome 69 开始，body 内的 CSS 已经[不在阻塞 Chrome 的渲染](https://twitter.com/patmeenan/status/1037027969842208777)。显然，这样做不利于使用 HTTP/1.1 的用户，所以你可能需要为不同的浏览器生成并服务不同的构建资源，来作为你的调度进程一部分，事情会稍微更复杂一些。你可能会使用 [HTTP/2 连接聚合](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/)来避免，它允许你利用 HTTP/2 使用域切分，但实际上并不容易做到，总之，它被不认为是最佳实践。

该怎么做呢？如果你正在运行 HTTP/2，那么发送大约 **6-10 个包** 会是一个不错的折中方案（并且对于过时浏览也不会太糟糕）。需要试验和测试来为你的网站找到最佳的平衡。

#### 54. 你的服务器和 CDN 支持 HTTP/2 吗？

不同的服务器和 CDN 可能需要的 HTTP/2 支持不一样。使用 [TLS 速度快吗？](https://istlsfastyet.com)来检查你的配置，或快速查找服务器的运行情况以及你希望支持哪些功能。

我参考了 Pat Meenan 非常棒的[ HTTP/2 优先级的研究](https://blog.cloudflare.com/http-2-prioritization-with-nginx/)和[对服务器支持 HTTP/2 优先级的测试](https://github.com/pmeenan/http2priorities)。依据 Pat 的研究，为了让 HTTP/2 优先级能可靠地工作在 Linux 4.9 以及更新的内核上，推荐开启 BBR 堵塞控制和设置 `tcp_notsent_lowat` 为 16 KB（**感谢 Yoav！**）。Andy Davies 在多个浏览器上做了类似的 HTTP/2 优先级研究，[CDN 和云托管服务](https://github.com/andydavies/http2-prioritization-issues#cdns--cloud-hosting-services)。

![TLS 速度快吗？](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c2102708-944d-46ed-93d9-fa28cd76f232/is-tls-fast-yet-01.png)

[TLS 速度快吗？](https://istlsfastyet.com)允许你在切换到 HTTP/2 时检查你的服务器和 CDN 的配置 ([大预览图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c2102708-944d-46ed-93d9-fa28cd76f232/is-tls-fast-yet-01.png))

#### 55. OCSP Stapling 是否启用？

通过[在你的服务器上启用 OCSP Stapling](https://www.digicert.com/enabling-ocsp-stapling.htm)，可以加速 TLS 握手。创建在线证书状态协议（Online Certificate Status Protocol）（OCSP）是作为证书撤销列表（Certificate Revocation List）（CRL）协议的代替。两种协议都是用来检查 SSL 证书是否被撤销。然而，OCSP 协议不需要浏览器花费时间下载然后在列表中搜寻证书信息，因此能减少握手需要的时间。

#### 56. 你采用 IPv6 了吗？

因为 [IPv4 地址正在消耗殆尽](https://en.wikipedia.org/wiki/IPv4_address_exhaustion)并且主要的手机网络正在迅速接受 IPv6（美国已经[达到](https://www.google.com/intl/en/ipv6/statistics.html#tab=ipv6-adoption&tab=ipv6-adoption) 50% IPv6 采纳率），[更新你的 DNS 为 IPv6](https://www.paessler.com/blog/2016/04/08/monitoring-news/ask-the-expert-current-status-on-ipv6) 是一个不错的想法，这样在将来可以保持服务器安全稳固。只需要确认网络是否支持双栈 —— 它允许 IPv6 和 IPv4 同时工作。别忘了，IPv6 并不向后兼容。并且，[研究表明](https://www.cloudflare.com/ipv6/) 得益于邻居发现（NDP）和路由优化， IPv6 使这些网站提速了 10 到 15%。

#### 57. 是否使用 HPACK 压缩？

拿 HPACK 举个例子，如果你在使用 HTTP/2，请确保检查你的服务器为 HTTP 响应头[实现了 HPACK 压缩](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/)来减少不必要的载荷。因为 HTTP/2 服务器都比较新，它们也许没有完全支持设计规范。[H2spec](https://github.com/summerwind/h2spec) 是一个出色的（从技术上讲很详尽）检查工具。HPACK 的压缩算法确实[令人印象深刻](https://www.mnot.net/blog/2018/11/27/header_compression)，并且[运行效果不错](https://www.keycdn.com/blog/http2-hpack-compression/)。

#### 58. 确保你的服务器安全稳固**

所有浏览器的 HTTP/2 实现都是运行在 TLS 之上，所以你可能想避免安全性警告或页面中的某些元素出错。请确保 [HTTP 头在安全方面得到合适配置](https://securityheaders.io/)，[消除一致的风险](https://www.smashingmagazine.com/2016/01/eliminating-known-security-vulnerabilities-with-snyk/)，并且[检查你的证书](https://www.ssllabs.com/ssltest/)。还有确保通过 HTTPS 加载所有的外部插件和跟踪脚本，没有跨站脚本并且已经合适地配置了 [HTTP 严格传输安全头](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)和[内容安全策略头](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)。

### 测试和监控

#### 59. 你优化过你的测试流程吗？

可能听起来没什么大不了的，但是如果设置合适可能会减少你很多测试上的时间。请考虑使用 Tim Kadlec 的[针对 WebPageTest 的 Alfred 工作流](https://github.com/tkadlec/webpagetest-alfred-workflow)向 WebPageTest 公共实例来提交测试用例。

你也可以用 [Google Spreadsheet 来驱动 WebPageTest](https://calendar.perfplanet.com/2014/driving-webpagetest-from-a-google-docs-spreadsheet/) 并且 Travis 使用 Lighthouse CI 安装了[包含辅助工具，性能和 SEO 评分](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget)的测试或[直接打包进 Webpack](https://twitter.com/addyosmani/statuses/1017655423099289600)。

并且如果你需要快速调试东西但你的构建进程似乎奇慢，记住“对于大部分 JavaScript 来说[移除空白符和 symbol mangling 可以使被压缩代码大小减少 95%](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1) —— 并不是精巧的代码转换。你可以简化压缩来使 Uglify 构建速度快 3 到 4 倍。”

[![pull request 检查非常有必要](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/705ed9b1-cd4d-4231-b808-ce8c2e72e070/review-required-checks-pr.png)](https://cdn-images-1.medium.com/max/1600/1*Y-1sdlIzFBRfEQPprzLnbA.png)

在 Travis 中使用 Lighthouse CI 集成[辅助性工具，性能和 SEO 评分测试](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget)对所有的合作开发者来说都能显著提升开发新功能的效率。([图像来源](https://cdn-images-1.medium.com/max/1600/1*Y-1sdlIzFBRfEQPprzLnbA.png)) ([大预览图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/705ed9b1-cd4d-4231-b808-ce8c2e72e070/review-required-checks-pr.png))

#### 60. 你测试过有代理和过时的浏览器吗？

光测试 Chrome 和 Firefox 还不够。看看你的网站在有代理的浏览器和过时浏览器中的表现。例如[在亚洲有着巨大的市场](http://gs.statcounter.com/#mobile_browser-as-monthly-201511-201611)的 UC 浏览器和 Opera Mini（在亚洲多达 35%）。[评估平均网络速度](https://www.webworldwide.io/)以避免在你的国家出现加载非常慢的情况。使用网络节流和模拟高分辨率设备测试。[BrowserStack](https://www.browserstack.com) 非常不错，不过还是要在真机上测试。

[![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96fa3207-4fff-4b7b-bfa0-c115062d826a/demo-unit-perf-tests.gif)](https://github.com/loadimpact/k6)

[k6](https://github.com/loadimpact/k6) 允许你写类似单元测试的性能测试用例。

#### 61. 你测试过辅助工具的性能吗？

当浏览器开始加载页面，它创建 DOM，如果此时有例如屏幕阅读器的辅助技术在运行，它也会创建辅助树。屏幕阅读器必须查询辅助树来获取信息并让读者可用 —— 有时默认直接查询，有时是按需，并且它可能会消耗一些时间。

当讨论到快速到达可交互状态，通常我们指用户能**尽快**通过点击链接或按钮来与页面交互的指标。这个概念与屏幕阅读器的有细微不同。对于屏幕阅读器来说，最快可交互时间是指当屏幕阅读器可以读出给定页面的导航并且使用者可以实际敲击键盘来交互时的**时间**过去了多少。

Léonie Watson 有一个[在辅助性工具的性能方面令人眼界大开的讨论](https://www.youtube.com/watch?v=n1sXj9oAXFU)并且特别指出加载慢会导致屏幕阅读器阅读延迟。屏幕阅读器本是用来快速阅读并导航的，因此可能那些视力不好的用户会比视力好的用户缺少耐心。

加载大页面和 使用 JavaScript 操作 DOM 会导致屏幕阅读器语音延迟。请关注这些以前没注意到的地方，并测试所有可用的平台（Jaws，NVDA，Voiceover，Narrator，Orca）。

#### 62. 是否建立可持续监控？

对于快速无限制测试来说持有一个 [WebPagetest](http://www.webpagetest.org/) 实例总是非常受益的。一个类似 [Sitespeed](https://www.sitespeed.io/)，[Calibre](https://calibreapp.com/) 和 [SpeedCurve](https://speedcurve.com/) 的可持续监控工具能自动报警，给你更详尽的性能画像。设置你自己的用户时间记录来测试和监控特殊业务指标。并请考虑加入[自动性能回归警报](https://calendar.perfplanet.com/2017/automating-web-performance-regression-alerts/)来监控变化。

了解使用 RUM-solutions 来监控性能随时间的变化。对于像加载测试工具的自动化测试，你可以使用 [k6](https://github.com/loadimpact/k6) 和它的脚本 API。并了解 [SpeedTracker](https://speedtracker.org)，[Lighthouse](https://github.com/GoogleChrome/lighthouse) 和  [Calibre](https://calibreapp.com)。

### 速效方案

本文的清单相当全面，并且完成所有的优化需要相当一段时间。所以，如果你只有一小时但想获得巨大性能提升，你要怎么做？让我们总结为 **12 条易于实现的目标**。显然，在你开始之前和完成之后，评估结果，包括在 3G 和有线网络连接下的渲染时间和 Speed Index。

1.  评估实际经验和设置合适的目标。一个很好的目标是追求首次有意义的渲染时间 < 1 秒，同时 Speed Index < 1250 秒，慢速 3G 网络下首次可交互时间 < 5秒，TTI < 2 秒。针对渲染时间和首次可交互时间做优化。
2.  为你的主要模板准备关键 CSS，并在放在页面的 `head` 标签内（预算应小于 14 KB）。对于 CSS/JS，使它们小于关键文件大小[最大预算 gzipped 压缩后为 170 KB](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)（未压缩为 0.7 MB）。
3.  尽可能地让更多的脚本分割，优化，defer 加载或者懒加载，检查轻量级的可选包并限制第三方包的大小。
4.  使用 `<script type="module">` 来让代码只对旧浏览器工作。
5.  试着整个 CSS 规则并测试 in-body CSS。
6.  使用更快的 `dns-lookup`，`preconnect`，`prefetch` 和 `preload` 来添加资源提示来加速分发。
7.  给网络字体分组并异步加载，在 CSS 中利用 `font-display` 来加速首次渲染。
8.  优化图片，并考虑为重要的页面（例如首页）使用 WebP。
9.  检查 HTTP 头设置的缓存并确保已经被合适地设置。
10. 在服务器上启用 Brotli 和 Zopfli 压缩。（如果不能，别忘了启用 Gzip 压缩。）
11. 如果 HTTP/2 可用，启用 HPACK 压缩并开始监控 mixed-content 警告。开启 OSCP 压缩。
12. 在 service worker 中缓存字体，样式，JavaScript 和图片等资源文件。

### 下载清单 （PDF，Apple Pages）

记住这条清单，你应该就能应对各种前端性能方面的项目。请自由下载可打印版的 PDF 清单，同时为了供您按需定制清单还准备了**可编辑的 Apple Pages 文档**。

*  [下载 PDF 版清单](https://www.dropbox.com/s/21vof23jlwf0swc/performance-checklist-1.2.pdf?dl=0) (PDF，166 KB)
*  [下载 Apple Pages 版清单](https://www.dropbox.com/s/xyf5qjnp1ii5okm/performance-checklist-1.2.pages?dl=0) (.pages，275 KB)
*  [下载 MS Word 版清单](https://www.dropbox.com/s/76b3yzexqdwsg65/performance-checklist-1.2.docx?dl=0) (.docx，151 KB)

如果你需要更多选择，你也可以查看 [Dan Rublic 总结的前端清单](https://github.com/drublic/checklist)，Jon Yablonski 总结的[设计者的 Web 性能清单](http://jonyablonski.com/designers-wpo-checklist/) 和 [FrontendChecklist](https://github.com/thedaviddias/Front-End-Performance-Checklist)。

### 出发！

一些优化可能超出你的工作或计划，或者对于你要处理的老旧代码可能造出更多麻烦。这都不是问题！请把这个清单作为一个（希望够全面）大纲，创建适合你的专属的问题清单。不过重中之重的是优化前测试和权衡你的项目来定位问题。希望大家在 2019 年都能得到不错的优化成绩！

* * *

**非常感谢 Guy Podjarny，Yoav Weiss，Addy Osmani，Artem Denysov，Denys Mishunov，Ilya Pukhalski，Jeremy Wagner，Colin Bendell，Mark Zeman，Patrick Meenan，Leonardo Losoviz，Andy Davies，Rachel Andrew，Anselm Hannemann，Patrick Hamann，Andy Davies，Tim Kadlec，Rey Bango，Matthias Ott，Peter Bowyer，Phil Walton，Mariana Peralta，Philipp Tellis，Ryan Townsend，Ingrid Bergman，Mohamed Hussain S. H.，Jacob Groß，Tim Swalling，Bob Visser，Kev Adamson，Adir Amsalem，Aleksey Kulikov 和 Rodney Rehm 对这篇文章的审阅，同时也感谢我们无与伦比的社区，大家会分享从工作学到的，对每个人都有用的优化技术和课程。你们真的是太棒了！**

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> **[译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
