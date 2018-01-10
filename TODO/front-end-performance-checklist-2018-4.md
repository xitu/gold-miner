> * 原文地址：[Front-End Performance Checklist 2018 - Part 4](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2018 - Part 4

Below you’ll find an overview of the front-end performance issues you mightneed to consider to ensure that your response times are fast and smooth.

- [Front-End Performance Checklist 2018 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [Front-End Performance Checklist 2018 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [Front-End Performance Checklist 2018 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [Front-End Performance Checklist 2018 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

31. **Do you warm up the connection to speed up delivery?**

Use [resource hints](https://w3c.github.io/resource-hints) to save time on [`dns-prefetch`](http://caniuse.com/#search=dns-prefetch) (which performs a DNS lookup in the background), [`preconnect`](http://www.caniuse.com/#search=preconnect) (which asks the browser to start the connection handshake (DNS, TCP, TLS) in the background), [`prefetch`](http://caniuse.com/#search=prefetch) (which asks the browser to request a resource) and [`preload`](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) (which prefetches resources without executing them, among other things).

Most of the time these days, we'll be using at least `preconnect` and `dns-prefetch`, and we'll be cautious with using `prefetch` and `preload`; the former should only be used if you are very confident about what assets the user will need next (for example, in a purchasing funnel). Notice that `prerender` has been deprecated and is no longer supported.

Note that even with `preconnect` and `dns-prefetch`, the browser has a limit on the number of hosts it will look up/connect to in parallel, so it's a safe bet to order them based on priority (_thanks Philip!_).

In fact, using resource hints is probably the easiest way to boost performance, and [it works well indeed](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf). When to use what? As Addy Osmani [has explained](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf), we should preload resources that we have high-confidence will be used in the current page. Prefetch resources likely to be used for future navigations across multiple navigation boundaries, e.g. Webpack bundles needed for pages the user hasn't visited yet.

Addy's article on Loading Priorities in Chrome [shows](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) how exactly Chrome interprets resource hints, so once you've decided which assets are critical for rendering, you can assign high priority to them. To see how your requests are prioritized, you can enable a "priority" column in the Chrome DevTools network request table (as well as Safari Technology Preview).

![the priority column in DevTools](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/34f6f27f-88a9-425a-910e-39100034def3/devtools-priority-segixq.gif)

The 'Priority' column in DevTools. Image credit: Ben Schwarz, [The Critical Request](https://css-tricks.com/the-critical-request/)

For example, since fonts usually are important assets on a page, it's always a good idea to [request the browser to download fonts with](https://css-tricks.com/the-critical-request/#article-header-id-2) [`preload`](https://css-tricks.com/the-critical-request/#article-header-id-2). You could also [load JavaScript dynamically](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#dynamic-loading-without-execution), effectively lazy-loading execution. Also, since `<link rel="preload">` accepts a `media` attribute, you could choose to [selectively prioritize resources](https://css-tricks.com/the-critical-request/#article-header-id-3) based on `@media` query rules.

A few [gotchas to keep in mind](https://dexecure.com/blog/http2-push-vs-http-preload/): preload is good for [moving the start download time of an asset](https://www.youtube.com/watch?v=RWLzUnESylc) closer to the initial request, but preloaded assets land in the memory cache which is tied to the page making the request. It means that preloaded requests cannot be shared across pages. Also, `preload` plays well with the HTTP cache: a network request is never sent if the item is already there in the HTTP cache.

Hence, it's useful for late-discovered resources, a hero image loaded via background-image, inlining critical CSS (or JavaScript) and pre-loading the rest of the CSS (or JavaScript). Also, a `preload` tag can initiate a preload only after the browser has received the HTML from the server and the lookahead parser has found the `preload` tag. Preloading via the HTTP header is a bit faster since we don't to wait for the browser to parse the HTML to start the request. [Early Hints](https://tools.ietf.org/html/draft-ietf-httpbis-early-hints-05) will help even further, enabling preload to kick in even before the response headers for the HTML are sent.

Beware: if you're using `preload`, `as` **must** be defined or [nothing loads](https://twitter.com/yoavweiss/status/873077451143774209), plus [Preloaded fonts without the](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [`crossorigin`](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [attribute will double fetch](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf).

32. **Have you optimized rendering performance?**

Isolate expensive components with [CSS containment](http://caniuse.com/#search=contain) — for example, to limit the scope of the browser's styles, of layout and paint work for off-canvas navigation, or of third-party widgets. Make sure that there is no lag when scrolling the page or when an element is animated, and that you're consistently hitting 60 frames per second. If that's not possible, then at least making the frames per second consistent is preferable to a mixed range of 60 to 15\. Use CSS' [`will-change`](http://caniuse.com/#feat=will-change) to inform the browser of which elements and properties will change.

Also, measure [runtime rendering performance](https://aerotwist.com/blog/my-performance-audit-workflow/#runtime-performance) (for example, [in DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/)). To get started, check Paul Lewis' free [Udacity course on browser-rendering optimization](https://www.udacity.com/course/browser-rendering-optimization--ud860) and Emily Hayman's article on [Performant Web Animations and Interactions](https://blog.algolia.com/performant-web-animations/).

We also have a lil' article by Sergey Chikuyonok on how to [get GPU animation right](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/). Quick note: changes to GPU-composited layers are the [least expensive](https://blog.algolia.com/performant-web-animations/), so if you can get away by triggering only compositing via `opacity` and `transform`, you'll be on the right track.

33. **Have you optimized rendering experience?**

While the sequence of how components appear on the page, and the strategy of how we serve assets to the browser matter, we shouldn't underestimate the role of [perceived performance](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/), too. The concept deals with psychological aspects of waiting, basically keeping customers busy or engaged while something else is happening. That's where [perception management](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/), [preemptive start](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#preemptive-start), [early completion](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#early-completion) and [tolerance management](https://www.smashingmagazine.com/2015/12/performance-matters-part-3-tolerance-management/) come into play.

What does it all mean? While loading assets, we can try to always be one step ahead of the customer, so the experience feels swift while there is quite a lot happening in the background. To keep the customer engaged, we can use [skeleton screens](https://twitter.com/lukew/status/665288063195594752) ([implementation demo](https://twitter.com/razvancaliman/status/734088764960690176)) instead of loading indicators, add transitions/animations and basically [cheat the UX](https://blog.stephaniewalter.fr/en/cheating-ux-perceived-performance-and-user-experience/) when there is nothing more to optimize.

### HTTP/2

34. **Migrate to HTTPS, then turn on HTTP/2.**

With Google [moving towards a more secure web](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html) and eventual treatment of all HTTP pages in Chrome as being "not secure," a switch to [HTTP/2 environment](https://http2.github.io/faq/) is unavoidable. HTTP/2 is [supported very well](http://caniuse.com/#search=http2); it isn't going anywhere; and, in most cases, you're better off with it. Once running on HTTPS already, you can get a [major performance boost](https://www.youtube.com/watch?v=RWLzUnESylc&t=1s&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=25) with service workers and server push (at least long term).

![HTTP/2](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/30dd1821-9800-4f01-91a8-1375d4812144/http-pages-chrome-opt.png)

Eventually, Google plans to label all HTTP pages as non-secure, and change the HTTP security indicator to the red triangle that Chrome uses for broken HTTPS. ([Image source](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html))

The most time-consuming task will be to [migrate to HTTPS](https://https.cio.gov/faq/), and depending on how large your HTTP/1.1 user base is (that is, users on legacy operating systems or with legacy browsers), you'll have to send a different build for legacy browsers performance optimizations, which would require you to adapt a [different build process](https://rmurphey.com/blog/2015/11/25/building-for-http2). Beware: Setting up both migration and a new build process might be tricky and time-consuming. For the rest of this article, I'll assume that you're either switching to or have already switched to HTTP/2.

35. **Properly deploy HTTP/2.**

Again, [serving assets over HTTP/2](https://www.youtube.com/watch?v=yURLTwZ3ehk) requires a partial overhaul of how you've been serving assets so far. You'll need to find a fine balance between packaging modules and loading many small modules in parallel. In the end of the day, still [the best request is no request](http://alistapart.com/article/the-best-request-is-no-request-revisited), however the goal is to find a fine balance between quick first delivery of assets and caching.

On the one hand, you might want to avoid concatenating assets altogether, instead breaking down your entire interface into many small modules, compressing them as a part of the build process, referencing them via the ["scout" approach](https://rmurphey.com/blog/2015/11/25/building-for-http2) and loading them in parallel. A change in one file won't require the entire style sheet or JavaScript to be re-downloaded. It also [minimizes parsing time](https://css-tricks.com/musings-on-http2-and-bundling/) and keeps the payloads of individual pages low.

On the other hand, [packaging still matters](http://engineering.khanacademy.org/posts/js-packaging-http2.htm). First, **compression will suffer**. The compression of a large package will benefit from dictionary reuse, whereas small separate packages will not. There's standard work to address that, but it's far out for now. Secondly, browsers have **not yet been optimized** for such workflows. For example, Chrome will trigger [inter-process communications](https://www.chromium.org/developers/design-documents/inter-process-communication) (IPCs) linear to the number of resources, so including hundreds of resources will have browser runtime costs.

![Progressive CSS loading](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/24d7fcb0-40c3-4ada-abb3-22b8524f9b2d/progressive-css-loading-opt.png)

To achieve best results with HTTP/2, consider to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/), as suggested by Chrome's Jake Archibald.

Still, you can try to [load CSS progressively](https://jakearchibald.com/2016/link-in-body/). Obviously, by doing so, you are actively penalizing HTTP/1.1 users, so you might need to generate and serve different builds to different browsers as part of your deployment process, which is where things get slightly more complicated. You could get away with [HTTP/2 connection coalescing](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/), which allows you to use domain sharding while benefiting from HTTP/2, but achieving this in practice is difficult.

What to do? If you're running over HTTP/2, sending around **6–10 packages** seems like a decent compromise (and isn't too bad for legacy browsers). Experiment and measure to find the right balance for your website.

36. **Do your servers and CDNs support HTTP/2?**

Different servers and CDNs are probably going to support HTTP/2 differently. Use [Is TLS Fast Yet?](https://istlsfastyet.com) to check your options, or quickly look up how your servers are performing and which features you can expect to be supported.

![Is TLS Fast Yet?](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ff2f5-9349-46a1-9c51-7a05dc906322/istlsfastyet-opt.png)

[Is TLS Fast Yet?](https://istlsfastyet.com) allows you to check your options for servers and CDNs when switching to HTTP/2.

37. **Is OCSP stapling enabled?**

By [enabling OCSP stapling on your server](https://www.digicert.com/enabling-ocsp-stapling.htm), you can speed up your TLS handshakes. The Online Certificate Status Protocol (OCSP) was created as an alternative to the Certificate Revocation List (CRL) protocol. Both protocols are used to check whether an SSL certificate has been revoked. However, the OCSP protocol does not require the browser to spend time downloading and then searching a list for certificate information, hence reducing the time required for a handshake.

38. **Have you adopted IPv6 yet?**

Because we're [running out of space with IPv4](https://en.wikipedia.org/wiki/IPv4_address_exhaustion) and major mobile networks are adopting IPv6 rapidly (the US has [reached](https://www.google.com/intl/en/ipv6/statistics.html#tab=ipv6-adoption&tab=ipv6-adoption) a 50% IPv6 adoption threshold), it's a good idea to [update your DNS to IPv6](https://www.paessler.com/blog/2016/04/08/monitoring-news/ask-the-expert-current-status-on-ipv6) to stay bulletproof for the future. Just make sure that dual-stack support is provided across the network — it allows IPv6 and IPv4 to run simultaneously alongside each other. After all, IPv6 is not backwards-compatible. Also, [studies show](https://www.cloudflare.com/ipv6/) that IPv6 made those websites 10 to 15% faster due to neighbor discovery (NDP) and route optimization.

39. **Is HPACK compression in use?**

If you're using HTTP/2, double-check that your servers [implement HPACK compression](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/) for HTTP response headers to reduce unnecessary overhead. Because HTTP/2 servers are relatively new, they may not fully support the specification, with HPACK being an example. [H2spec](https://github.com/summerwind/h2spec) is a great (if very technically detailed) tool to check that. [HPACK works](https://www.keycdn.com/blog/http2-hpack-compression/).

![h2spec](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/efc02119-9155-4126-b7b9-bc83c4b16436/h2spec-example-750w-opt.png)

H2spec ([View large version](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/15891f86-c883-434a-8517-209273356ee6/h2spec-example-large-opt.png)) ([Image source](https://github.com/summerwind/h2spec))

40. **Make sure the security on your server is bulletproof.**

All browser implementations of HTTP/2 run over TLS, so you will probably want to avoid security warnings or some elements on your page not working. Double-check that your [security headers are set properly](https://securityheaders.io/), [eliminate known vulnerabilities](https://www.smashingmagazine.com/2016/01/eliminating-known-security-vulnerabilities-with-snyk/), and [check your certificate](https://www.ssllabs.com/ssltest/). Also, make sure that all external plugins and tracking scripts are loaded via HTTPS, that cross-site scripting isn't possible and that both [HTTP Strict Transport Security headers](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet) and [Content Security Policy headers](https://content-security-policy.com/) are properly set.

41. **Are service workers used for caching and network fallbacks?**

No performance optimization over a network can be faster than a locally stored cache on user's machine. If your website is running over HTTPS, use the "[Pragmatist's Guide to Service Workers](https://github.com/lyzadanger/pragmatist-service-worker)" to cache static assets in a service worker cache and store offline fallbacks (or even offline pages) and retrieve them from the user's machine, rather than going to the network. Also, check Jake's [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/) and the free Udacity course "[Offline Web Applications](https://www.udacity.com/course/offline-web-applications--ud899)." Browser support? As stated above, it's [widely supported](http://caniuse.com/#search=serviceworker) (Chrome, Firefox, Safari TP, Samsung Internet, Edge 17+) and the fallback is the network anyway. Does it help boost performance? [Oh yes, it does](https://developers.google.com/web/showcase/2016/service-worker-perf).

### Testing And Monitoring

42. **Have you tested in proxy browsers and legacy browsers?**

Testing in Chrome and Firefox is not enough. Look into how your website works in proxy browsers and legacy browsers. UC Browser and Opera Mini, for instance, have a [significant market share in Asia](http://gs.statcounter.com/#mobile_browser-as-monthly-201511-201611) (up to 35% in Asia). [Measure average Internet speed](https://www.webworldwide.io/) in your countries of interest to avoid big surprises down the road. Test with network throttling, and emulate a high-DPI device. [BrowserStack](https://www.browserstack.com) is fantastic, but test on real devices as well.

[![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96fa3207-4fff-4b7b-bfa0-c115062d826a/demo-unit-perf-tests.gif)](https://github.com/loadimpact/k6)


[k6](https://github.com/loadimpact/k6) allows you write unit tests-alike performance tests.

43. **Is continuous monitoring set up?**

Having a private instance of [WebPagetest](http://www.webpagetest.org/) is always beneficial for quick and unlimited tests. However, a continuous monitoring tool with automatic alerts will give you a more detailed picture of your performance. Set your own user-timing marks to measure and monitor business-specific metrics. Also, consider adding [automated performance regression alerts](https://calendar.perfplanet.com/2017/automating-web-performance-regression-alerts/) to monitor changes over time.

Look into using RUM-solutions to monitor changes in performance over time. For automated unit-test-alike load testing tools, you can use [k6](https://github.com/loadimpact/k6) with its scripting API. Also, look into [SpeedTracker](https://speedtracker.org), [Lighthouse](https://github.com/GoogleChrome/lighthouse) and [Calibre](https://calibreapp.com).

### Quick Wins

This list is quite comprehensive, and completing all of the optimizations might take quite a while. So, if you had just 1 hour to get significant improvements, what would you do? Let's boil it all down to **10 low-hanging fruits**. Obviously, before you start and once you finish, measure results, including start rendering time and SpeedIndex on a 3G and cable connection.

1. Measure the real world experience and set appropriate goals. A good goal to aim for is First Meaningful Paint < 1 s, a SpeedIndex value < 1250, Time to Interactive < 5s on slow 3G, for repeat visits, TTI < 2s. Optimize for start rendering time and time-to-interactive.
2. Prepare critical CSS for your main templates, and include it in the `<head>` of the page. (Your budget is 14 KB). For CSS/JS, operate within a critical file size [budget of max. 170Kb gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (0.8-1MB decompressed).
3. Defer and lazy-load as many scripts as possible, both your own and third-party scripts — especially social media buttons, video players and expensive JavaScript.
4. Add resource hints to speed up delivery with faster `dns-lookup`, `preconnect`, `prefetch` and `preload`.
5. Subset web fonts and load them asynchronously (or just switch to system fonts instead).
6. Optimize images, and consider using WebP for critical pages (such as landing pages).
7. Check that HTTP cache headers and security headers are set properly.
8. Enable Brotli or Zopfli compression on the server. (If that's not possible, don't forget to enable Gzip compression.)
9. If HTTP/2 is available, enable HPACK compression and start monitoring mixed-content warnings. If you're running over LTS, also enable OCSP stapling.
10. Cache assets such as fonts, styles, JavaScript and images — actually, as much as possible! — in a service worker cache.

### Download The Checklist (PDF, Apple Pages)

With this checklist in mind, you should be prepared for any kind of front-end performance project. Feel free to download the print-ready PDF of the checklist as well as an **editable Apple Pages document** to customize the checklist for your needs:

* [Download the checklist PDF](https://www.dropbox.com/s/8h9lo8ee65oo9y1/front-end-performance-checklist-2018.pdf?dl=0) (PDF, 0.129 MB)
* [Download the checklist in Apple Pages](https://www.dropbox.com/s/yjedzbyj32gzd9g/performance-checklist-1.1.pages?dl=0) (.pages, 0.236 MB)

If you need alternatives, you can also check the [front-end checklist by Dan Rublic](https://github.com/drublic/checklist) and the "[Designer's Web Performance Checklist](http://jonyablonski.com/designers-wpo-checklist/)" by Jon Yablonski.

### Off We Go!

Some of the optimizations might be beyond the scope of your work or budget or might just be overkill given the legacy code you have to deal with. That's fine! Use this checklist as a general (and hopefully comprehensive) guide, and create your own list of issues that apply to your context. But most importantly, test and measure your own projects to identify issues before optimizing. Happy performance results in 2018, everyone!

_A huge thanks to Guy Podjarny, Yoav Weiss, Addy Osmani, Artem Denysov, Denys Mishunov, Ilya Pukhalski, Jeremy Wagner, Colin Bendell, Mark Zeman, Patrick Meenan, Leonardo Losoviz, Andy Davies, Rachel Andrew, Anselm Hannemann, Patrick Hamann, Andy Davies, Tim Kadlec, Rey Bango, Matthias Ott, Mariana Peralta, Philipp Tellis, Ryan Townsend, Mohamed Hussain S H, Jacob Groß, Tim Swalling, Bob Visser, Kev Adamson, Aleksey Kulikov and Rodney Rehm for reviewing this article, as well as our fantastic community, which has shared techniques and lessons learned from its work in performance optimization for everybody to use. You are truly smashing!_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
