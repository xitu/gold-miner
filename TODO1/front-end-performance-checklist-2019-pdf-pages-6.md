> * 原文地址：[Front-End Performance Checklist 2019 — 6](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 6

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> **[译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)**

#### Table Of Contents

- [HTTP/2](#http2)
  - [52. Migrate to HTTPS, then turn on HTTP/2](#52-migrate-to-https-then-turn-on-http2)
  - [53. Properly deploy HTTP/2](#53-properly-deploy-http2)
  - [54. Do your servers and CDNs support HTTP/2?](#54-do-your-servers-and-cdns-support-http2)
  - [55. Is OCSP stapling enabled?](#55-is-ocsp-stapling-enabled)
  - [56. Have you adopted IPv6 yet?](#56-have-you-adopted-ipv6-yet)
  - [57. Is HPACK compression in use?](#57-is-hpack-compression-in-use)
  - [58. Make sure the security on your server is bulletproof.**](#58-make-sure-the-security-on-your-server-is-bulletproof)
- [Testing And Monitoring](#testing-and-monitoring)
  - [59. Have you optimized your auditing workflow?](#59-have-you-optimized-your-auditing-workflow)
  - [60. Have you tested in proxy browsers and legacy browsers?](#60-have-you-tested-in-proxy-browsers-and-legacy-browsers)
  - [61. Have you tested the accessibility performance?](#61-have-you-tested-the-accessibility-performance)
  - [62. Is continuous monitoring set up?](#62-is-continuous-monitoring-set-up)
- [Quick Wins](#quick-wins)
- [Download The Checklist (PDF, Apple Pages)](#download-the-checklist-pdf-apple-pages)
- [Off We Go!](#off-we-go)

### HTTP/2

#### 52. Migrate to HTTPS, then turn on HTTP/2

With Google [moving towards a more secure web](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html) and eventual treatment of all HTTP pages in Chrome as being "not secure," a switch to [HTTP/2 environment](https://http2.github.io/faq/) is unavoidable. HTTP/2 is [supported very well](http://caniuse.com/#search=http2); it isn’t going anywhere; and, in most cases, you’re better off with it. Once running on HTTPS already, you can get a [major performance boost](https://www.youtube.com/watch?v=RWLzUnESylc&t=1s&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=25) with service workers and server push (at least long term).

![HTTP/2](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/30dd1821-9800-4f01-91a8-1375d4812144/http-pages-chrome-opt.png)

Eventually, Google plans to label all HTTP pages as non-secure, and change the HTTP security indicator to the red triangle that Chrome uses for broken HTTPS. ([Image source](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html))

The most time-consuming task will be to [migrate to HTTPS](https://https.cio.gov/faq/), and depending on how large your HTTP/1.1 user base is (that is, users on legacy operating systems or with legacy browsers), you’ll have to send a different build for legacy browsers performance optimizations, which would require you to adapt to a [different build process](https://rmurphey.com/blog/2015/11/25/building-for-http2). Beware: Setting up both migration and a new build process might be tricky and time-consuming. For the rest of this article, I’ll assume that you’re either switching to or have already switched to HTTP/2.

#### 53. Properly deploy HTTP/2

Again, [serving assets over HTTP/2](https://www.youtube.com/watch?v=yURLTwZ3ehk) requires a partial overhaul of how you’ve been serving assets so far. You’ll need to find a fine balance between packaging modules and loading many small modules in parallel. At the end of the day, still [the best request is no request](http://alistapart.com/article/the-best-request-is-no-request-revisited), however, the goal is to find a fine balance between quick first delivery of assets and caching.

On the one hand, you might want to avoid concatenating assets altogether, instead breaking down your entire interface into many small modules, compressing them as a part of the build process, referencing them via the ["scout" approach](https://rmurphey.com/blog/2015/11/25/building-for-http2) and loading them in parallel. A change in one file won’t require the entire style sheet or JavaScript to be re-downloaded. It also [minimizes parsing time](https://css-tricks.com/musings-on-http2-and-bundling/) and keeps the payloads of individual pages low.

On the other hand, [packaging still matters](http://engineering.khanacademy.org/posts/js-packaging-http2.htm). First, **compression will suffer**. The compression of a large package will benefit from dictionary reuse, whereas small separate packages will not. There’s standard work to address that, but it’s far out for now. Secondly, browsers have **not yet been optimized** for such workflows. For example, Chrome will trigger [inter-process communications](https://www.chromium.org/developers/design-documents/inter-process-communication) (IPCs) linear to the number of resources, so including hundreds of resources will have browser runtime costs.

![Progressive CSS loading](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/24d7fcb0-40c3-4ada-abb3-22b8524f9b2d/progressive-css-loading-opt.png)

To achieve best results with HTTP/2, consider to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/), as suggested by Chrome’s Jake Archibald.

Still, you can try to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/). In fact, since Chrome 69, in-body CSS [no longer blocks rendering for Chrome](https://twitter.com/patmeenan/status/1037027969842208777). Obviously, by doing so, you are actively penalizing HTTP/1.1 users, so you might need to generate and serve different builds to different browsers as part of your deployment process, which is where things get slightly more complicated. You could get away with [HTTP/2 connection coalescing](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/), which allows you to use domain sharding while benefiting from HTTP/2, but achieving this in practice is difficult, and in general, it’s not considered to be good practice.

What to do? Well, if you’re running over HTTP/2, sending around **6–10 packages** seems like a decent compromise (and isn’t too bad for legacy browsers). Experiment and measure to find the right balance for your website.

#### 54. Do your servers and CDNs support HTTP/2?

Different servers and CDNs are probably going to support HTTP/2 differently. Use [Is TLS Fast Yet?](https://istlsfastyet.com) to check your options, or quickly look up how your servers are performing and which features you can expect to be supported.

Consult Pat Meenan’s incredible [research on HTTP/2 priorities](https://blog.cloudflare.com/http-2-prioritization-with-nginx/) and [test server support for HTTP/2 prioritization](https://github.com/pmeenan/http2priorities). According to Pat, it’s recommended to enable BBR congestion control and set `tcp_notsent_lowat` to 16KB for HTTP/2 prioritization to work reliably on Linux 4.9 kernels and later (_thanks, Yoav!_). Andy Davies did a similar research for HTTP/2 prioritization across browsers, [CDNs and Cloud Hosting Services](https://github.com/andydavies/http2-prioritization-issues#cdns--cloud-hosting-services).

![Is TLS Fast Yet?](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c2102708-944d-46ed-93d9-fa28cd76f232/is-tls-fast-yet-01.png)

[Is TLS Fast Yet?](https://istlsfastyet.com) allows you to check your options for servers and CDNs when switching to HTTP/2. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c2102708-944d-46ed-93d9-fa28cd76f232/is-tls-fast-yet-01.png))

#### 55. Is OCSP stapling enabled?

By [enabling OCSP stapling on your server](https://www.digicert.com/enabling-ocsp-stapling.htm), you can speed up your TLS handshakes. The Online Certificate Status Protocol (OCSP) was created as an alternative to the Certificate Revocation List (CRL) protocol. Both protocols are used to check whether an SSL certificate has been revoked. However, the OCSP protocol does not require the browser to spend time downloading and then searching a list for certificate information, hence reducing the time required for a handshake.

#### 56. Have you adopted IPv6 yet?

Because we’re [running out of space with IPv4](https://en.wikipedia.org/wiki/IPv4_address_exhaustion) and major mobile networks are adopting IPv6 rapidly (the US has [reached](https://www.google.com/intl/en/ipv6/statistics.html#tab=ipv6-adoption&tab=ipv6-adoption) a 50% IPv6 adoption threshold), it’s a good idea to [update your DNS to IPv6](https://www.paessler.com/blog/2016/04/08/monitoring-news/ask-the-expert-current-status-on-ipv6) to stay bulletproof for the future. Just make sure that dual-stack support is provided across the network — it allows IPv6 and IPv4 to run simultaneously alongside each other. After all, IPv6 is not backwards-compatible. Also, [studies show](https://www.cloudflare.com/ipv6/) that IPv6 made those websites 10 to 15% faster due to neighbor discovery (NDP) and route optimization.

#### 57. Is HPACK compression in use?

If you’re using HTTP/2, double-check that your servers [implement HPACK compression](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/) for HTTP response headers to reduce unnecessary overhead. Because HTTP/2 servers are relatively new, they may not fully support the specification, with HPACK being an example. [H2spec](https://github.com/summerwind/h2spec) is a great (if very technically detailed) tool to check that. HPACK’s compression algorithm is quite [impressive](https://www.mnot.net/blog/2018/11/27/header_compression), and [it works](https://www.keycdn.com/blog/http2-hpack-compression/).

#### 58. Make sure the security on your server is bulletproof.**  

All browser implementations of HTTP/2 run over TLS, so you will probably want to avoid security warnings or some elements on your page not working. Double-check that your [security headers are set properly](https://securityheaders.io/), [eliminate known vulnerabilities](https://www.smashingmagazine.com/2016/01/eliminating-known-security-vulnerabilities-with-snyk/), and [check your certificate](https://www.ssllabs.com/ssltest/). Also, make sure that all external plugins and tracking scripts are loaded via HTTPS, that cross-site scripting isn’t possible and that both [HTTP Strict Transport Security headers](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet) and [Content Security Policy headers](https://content-security-policy.com/) are properly set.

### Testing And Monitoring

#### 59. Have you optimized your auditing workflow?

It might not sound like a big deal, but having the right settings in place at your fingertips might save you quite a bit of time in testing. Consider using Tim Kadlec’s [Alfred Workflow for WebPageTest](https://github.com/tkadlec/webpagetest-alfred-workflow) for submitting a test to the public instance of WebPageTest.

You could also [drive WebPageTest from a Google Spreadsheet](https://calendar.perfplanet.com/2014/driving-webpagetest-from-a-google-docs-spreadsheet/) and [incorporate accessibility, performance and SEO scores](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget) into your Travis setup with Lighthouse CI or [straight into Webpack](https://twitter.com/addyosmani/statuses/1017655423099289600).

And if you need to debug something quickly but your build process seems to be remarkably slow, keep in mind that "[whitespace removal and symbol mangling accounts for 95% of the size reduction](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1) in minified code for most JavaScript — not elaborate code transforms. You can simply disable compression to speed up Uglify builds by 3 to 4 times."

[![pull request checks review required](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/705ed9b1-cd4d-4231-b808-ce8c2e72e070/review-required-checks-pr.png)](https://cdn-images-1.medium.com/max/1600/1*Y-1sdlIzFBRfEQPprzLnbA.png) 

Integrating [accessibility, performance and SEO scores](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget) into your Travis setup with Lighthouse CI will highlight the performance impact of a new feature to all contributing developers. ([Image source](https://cdn-images-1.medium.com/max/1600/1*Y-1sdlIzFBRfEQPprzLnbA.png)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/705ed9b1-cd4d-4231-b808-ce8c2e72e070/review-required-checks-pr.png))

#### 60. Have you tested in proxy browsers and legacy browsers?

Testing in Chrome and Firefox is not enough. Look into how your website works in proxy browsers and legacy browsers. UC Browser and Opera Mini, for instance, have a [significant market share in Asia](http://gs.statcounter.com/#mobile_browser-as-monthly-201511-201611) (up to 35% in Asia). [Measure average Internet speed](https://www.webworldwide.io/) in your countries of interest to avoid big surprises down the road. Test with network throttling, and emulate a high-DPI device. [BrowserStack](https://www.browserstack.com) is fantastic, but test on real devices as well.

[![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96fa3207-4fff-4b7b-bfa0-c115062d826a/demo-unit-perf-tests.gif)](https://github.com/loadimpact/k6)

[k6](https://github.com/loadimpact/k6) allows you write unit tests-alike performance tests.

#### 61. Have you tested the accessibility performance?

When the browser starts to load a page, it builds a DOM, and if there is an assistive technology like a screen reader running, it also creates an accessibility tree. The screen reader then has to query the accessibility tree to retrieve the information and make it available to the user — sometimes by default, and sometimes on demand. And sometimes it takes time.

When talking about fast Time to Interactive, usually we mean an indicator of how _soon_ a user can interact with the page by clicking or tapping on links and buttons. The context is slightly different with screen readers. In that case, fast Time to Interactive means how much _time_ passes by until the screen reader can announce navigation on a given page and a screen reader user can actually hit keyboard to interact.

Léonie Watson has given an [eye-opening talk on accessibility performance](https://www.youtube.com/watch?v=n1sXj9oAXFU) and specifically the impact slow loading has on screen reader announcement delays. Screen readers are used to fast-paced announcements and quick navigation, and therefore might potentially be even less patient than sighted users.

Large pages and DOM manipulations with JavaScript will cause delays in screen reader announcements. A rather unexplored area that could use some attention and testing as screen readers are available on literally every platform (Jaws, NVDA, Voiceover, Narrator, Orca).

#### 62. Is continuous monitoring set up?

Having a private instance of [WebPagetest](http://www.webpagetest.org/) is always beneficial for quick and unlimited tests. However, a continuous monitoring tool — like [Sitespeed](https://www.sitespeed.io/), [Calibre](https://calibreapp.com/) and [SpeedCurve](https://speedcurve.com/) — with automatic alerts will give you a more detailed picture of your performance. Set your own user-timing marks to measure and monitor business-specific metrics. Also, consider adding [automated performance regression alerts](https://calendar.perfplanet.com/2017/automating-web-performance-regression-alerts/) to monitor changes over time.

Look into using RUM-solutions to monitor changes in performance over time. For automated unit-test-alike load testing tools, you can use [k6](https://github.com/loadimpact/k6) with its scripting API. Also, look into [SpeedTracker](https://speedtracker.org), [Lighthouse](https://github.com/GoogleChrome/lighthouse) and [Calibre](https://calibreapp.com).

### Quick Wins

This list is quite comprehensive, and completing all of the optimizations might take quite a while. So, if you had just 1 hour to get significant improvements, what would you do? Let’s boil it all down to **12 low-hanging fruits**. Obviously, before you start and once you finish, measure results, including start rendering time and Speed Index on a 3G and cable connection.

1.  Measure the real world experience and set appropriate goals. A good goal to aim for is First Meaningful Paint < 1 s, a Speed Index value < 1250, Time to Interactive < 5s on slow 3G, for repeat visits, TTI < 2s. Optimize for start rendering time and time-to-interactive.
2.  Prepare critical CSS for your main templates, and include it in the `<head>` of the page. (Your budget is 14 KB). For CSS/JS, operate within a critical file size [budget of max. 170KB gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (0.7MB decompressed).
3.  Trim, optimize, defer and lazy-load as many scripts as possible, check lightweight alternatives and limit the impact of third-party scripts.
4.  Serve legacy code only to legacy browsers with `<script type="module">`.
5.  Experiment with regrouping your CSS rules and test in-body CSS.
6.  Add resource hints to speed up delivery with faster `dns-lookup`, `preconnect`, `prefetch` and `preload`.
7.  Subset web fonts and load them asynchronously, and utilize `font-display` in CSS for fast first rendering.
8.  Optimize images, and consider using WebP for critical pages (such as landing pages).
9.  Check that HTTP cache headers and security headers are set properly.
10.  Enable Brotli or Zopfli compression on the server. (If that’s not possible, don’t forget to enable Gzip compression.)
11.  If HTTP/2 is available, enable HPACK compression and start monitoring mixed-content warnings. Enable OCSP stapling.
12.  Cache assets such as fonts, styles, JavaScript and images in a service worker cache.

### Download The Checklist (PDF, Apple Pages)

With this checklist in mind, you should be prepared for any kind of front-end performance project. Feel free to download the print-ready PDF of the checklist as well as an **editable Apple Pages document** to customize the checklist for your needs:

*  [Download the checklist PDF](https://www.dropbox.com/s/21vof23jlwf0swc/performance-checklist-1.2.pdf?dl=0) (PDF, 166 KB)
*  [Download the checklist in Apple Pages](https://www.dropbox.com/s/xyf5qjnp1ii5okm/performance-checklist-1.2.pages?dl=0) (.pages, 275 KB)
*  [Download the checklist in MS Word](https://www.dropbox.com/s/76b3yzexqdwsg65/performance-checklist-1.2.docx?dl=0) (.docx, 151 KB)

If you need alternatives, you can also check the [front-end checklist by Dan Rublic](https://github.com/drublic/checklist), the "[Designer’s Web Performance Checklist](http://jonyablonski.com/designers-wpo-checklist/)" by Jon Yablonski and the [FrontendChecklist](https://github.com/thedaviddias/Front-End-Performance-Checklist).

### Off We Go!

Some of the optimizations might be beyond the scope of your work or budget or might just be overkill given the legacy code you have to deal with. That’s fine! Use this checklist as a general (and hopefully comprehensive) guide, and create your own list of issues that apply to your context. But most importantly, test and measure your own projects to identify issues before optimizing. Happy performance results in 2019, everyone!

* * *

_A huge thanks to Guy Podjarny, Yoav Weiss, Addy Osmani, Artem Denysov, Denys Mishunov, Ilya Pukhalski, Jeremy Wagner, Colin Bendell, Mark Zeman, Patrick Meenan, Leonardo Losoviz, Andy Davies, Rachel Andrew, Anselm Hannemann, Patrick Hamann, Andy Davies, Tim Kadlec, Rey Bango, Matthias Ott, Peter Bowyer, Phil Walton, Mariana Peralta, Philipp Tellis, Ryan Townsend, Ingrid Bergman, Mohamed Hussain S. H., Jacob Groß, Tim Swalling, Bob Visser, Kev Adamson, Adir Amsalem, Aleksey Kulikov and Rodney Rehm for reviewing this article, as well as our fantastic community which has shared techniques and lessons learned from its work in performance optimization for everybody to use. You are truly smashing!_

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> **[译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
