> * 原文地址：[Front-End Performance Checklist 2019 — 5](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 5

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> **[译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)**
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### Table Of Contents

- [Delivery Optimizations](#delivery-optimizations)
  - [39. Do you load all JavaScript libraries asynchronously?](#39-do-you-load-all-javascript-libraries-asynchronously)
  - [40. Lazy load expensive components with IntersectionObserver](#40-lazy-load-expensive-components-with-intersectionobserver)
  - [41. Load images progressively](#41-load-images-progressively)
  - [42. Do you send critical CSS?](#42-do-you-send-critical-css)
  - [43. Experiment with regrouping your CSS rules](#43-experiment-with-regrouping-your-css-rules)
  - [44. Do you stream responses?](#44-do-you-stream-responses)
  - [45. Consider making your components connection-aware](#45-consider-making-your-components-connection-aware)
  - [46. Consider making your components device memory-aware](#46-consider-making-your-components-device-memory-aware)
  - [47. Warm up the connection to speed up delivery](#47-warm-up-the-connection-to-speed-up-delivery)
  - [48. Use service workers for caching and network fallbacks](#48-use-service-workers-for-caching-and-network-fallbacks)
  - [49. Are you using service workers on the CDN/Edge, e.g. for A/B testing?](#49-are-you-using-service-workers-on-the-cdnedge-eg-for-ab-testing)
  - [50. Optimize rendering performance](#50-optimize-rendering-performance)
  - [51. Have you optimized rendering experience?](#51-have-you-optimized-rendering-experience)

### Delivery Optimizations

#### 39. Do you load all JavaScript libraries asynchronously?

When the user requests a page, the browser fetches the HTML and constructs the DOM, then fetches the CSS and constructs the CSSOM, and then generates a rendering tree by matching the DOM and CSSOM. If any JavaScript needs to be resolved, the browser won’t start rendering the page until it’s resolved, thus delaying rendering. As developers, we have to explicitly tell the browser not to wait and to start rendering the page. The way to do this for scripts is with the `defer` and `async` attributes in HTML.

In practice, it turns out we should [prefer `defer` to](http://calendar.perfplanet.com/2016/prefer-defer-over-async/) `async` (at a [cost to users of Internet Explorer](https://github.com/h5bp/lazyweb-requests/issues/42) up to and including version 9, because you’re likely to break scripts for them). According to [Steve Souders](https://youtu.be/RwSlubTBnew?t=1034), once `async` scripts arrive, they are executed immediately. If that happens very fast, for example when the script is in cache aleady, it can actually block HTML parser. With `defer`, browser doesn’t execute scripts until HTML is parsed. So, unless you need JavaScript to execute before start render, it’s better to use `defer`.

Also, as mentioned above, limit the impact of third-party libraries and scripts, especially with social sharing buttons and `<iframe>` embeds (such as maps). [Size Limit](https://github.com/ai/size-limit) helps you [prevent JavaScript libraries bloat](https://evilmartians.com/chronicles/size-limit-make-the-web-lighter): If you accidentally add a large dependency, the tool will inform you and throw an error. You can use [static social sharing buttons](https://www.savjee.be/2015/01/Creating-static-social-share-buttons/) (such as by [SSBG](https://simplesharingbuttons.com)) and [static links to interactive maps](https://developers.google.com/maps/documentation/static-maps/intro) instead.

You might want to [revise your non-blocking script loader for CSP compliance](https://calendar.perfplanet.com/2018/a-csp-compliant-non-blocking-script-loader/).

#### 40. Lazy load expensive components with IntersectionObserver

In general, it’s a good idea to lazy-load all expensive components, such as heavy JavaScript, videos, iframes, widgets, and potentially images. The most performant way to do so is by using the [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) that provides a way to asynchronously observe changes in the intersection of a target element with an ancestor element or with a top-level document’s viewport. Basically, you need to create a new `IntersectionObserver` object, which receives a callback function and a set of options. Then we add a target to observe.

The callback function executes when the target becomes visible or invisible, so when it intercepts the viewport, you can start taking some actions before the element becomes visible. In fact, we have a granular control over when the observer’s callback should be invoked, with `rootMargin` (margin around the root) and `threshold` (a single number or an array of numbers which indicate at what percentage of the target’s visibility we are aiming).

Alejandro Garcia Anglada has published a [handy tutorial](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) on how to actually implement it, Rahul Nanwani wrote a detailed post on [lazy-loading foreground and background images](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/), and Google Fundamentals provide a [detailed tutorial on lazy loading images and video with Intersection Observer](https://developers.google.com/web/fundamentals/performance/lazy-loading-guidance/images-and-video/) as well. Remember art-directed storytelling long reads with moving and sticky objects? You can implement [performant scrollytelling with Intersection Observer](https://github.com/russellgoldenberg/scrollama), too.

Also, watch out for the [`lazyload` attribute](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/) that will allow us to specify which images and `iframe`s should be lazy loaded, natively. [Feature policy: LazyLoad](https://www.chromestatus.com/feature/5641405942726656) will provide a mechanism that allows us to force opting in or out of LazyLoad functionality on a per-domain basis (similar to how [Content Security Policies](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) work). Bonus: once shipped, [priority hints](https://twitter.com/csswizardry/status/1050717710525509633) will allow us to specify importance on scripts and preloads in the header as well (currently in Chrome Canary).

#### 41. Load images progressively

You could even take lazy loading to the next level by adding [progressive image loading](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) to your pages. Similarly to Facebook, Pinterest and Medium, you could load low quality or even blurry images first, and then as the page continues to load, replace them with the full quality versions by using the [LQIP (Low Quality Image Placeholders) technique](https://www.guypo.com/introducing-lqip-low-quality-image-placeholders) proposed by Guy Podjarny.

Opinions differ if these techniques improve user experience or not, but it definitely improves time to first meaningful paint. We can even automate it by using [SQIP](https://github.com/technopagan/sqip) that creates a low quality version of an image as an SVG placeholder, or [Gradient Image Placeholders](https://calendar.perfplanet.com/2018/gradient-image-placeholders/) with CSS linear gradients. These placeholders could be embedded within HTML as they naturally compress well with text compression methods. In his article, Dean Hume [has described](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) how this technique can be implemented using Intersection Observer.

Browser support? [Decent](https://caniuse.com/#feat=intersectionobserver), with Chrome, Firefox, Edge and Samsung Internet being on board. WebKit status is currently [supported in preview](https://webkit.org/status/#specification-intersection-observer). Fallback? If the browser doesn’t support intersection observer, we can still [lazy load](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) a [polyfill](https://github.com/jeremenichelli/intersection-observer-polyfill) or load the images immediately. And there is even a [library](https://github.com/ApoorvSaxena/lozad.js) for it.

Want to go fancier? You could [trace your images](https://jmperezperez.com/svg-placeholders/) and use primitive shapes and edges to create a lightweight SVG placeholder, load it first, and then transition from the placeholder vector image to the (loaded) bitmap image.

[![SVG lazy loading technique by José M. Pérez](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7f56052-6abb-4d18-a5aa-8d84102d812e/jmperez-composition-primitive-full.jpg)](https://jmperezperez.com/svg-placeholders/) 

SVG lazy loading technique by [José M. Pérez](https://jmperezperez.com/svg-placeholders/). ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7f56052-6abb-4d18-a5aa-8d84102d812e/jmperez-composition-primitive-full.jpg))

#### 42. Do you send critical CSS?

To ensure that browsers start rendering your page as quickly as possible, it’s become a [common practice](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) to collect all of the CSS required to start rendering the first visible portion of the page (known as "critical CSS" or "above-the-fold CSS") and add it inline in the `<head>` of the page, thus reducing roundtrips. Due to the limited size of packages exchanged during the slow start phase, your budget for critical CSS is around 14 KB.

If you go beyond that, the browser will need additional roundtrips to fetch more styles. [CriticalCSS](https://github.com/filamentgroup/criticalCSS) and [Critical](https://github.com/addyosmani/critical) enable you to do just that. You might need to do it for every template you’re using. If possible, consider using the [conditional inlining approach](https://www.filamentgroup.com/lab/modernizing-delivery.html) used by the Filament Group, or [convert inline code to static assets on the fly](https://www.smashingmagazine.com/2018/11/pitfalls-automatically-inlined-code/).

With HTTP/2, critical CSS could be stored in a separate CSS file and delivered via a [server push](https://www.filamentgroup.com/lab/modernizing-delivery.html) without bloating the HTML. The catch is that server pushing is [troublesome](https://twitter.com/jaffathecake/status/867699157150117888) with many gotchas and race conditions across browsers. It isn’t supported consistently and has some caching issues (see slide 114 onwards of [Hooman Beheshti’s presentation](http://www.slideshare.net/Fastly/http2-what-no-one-is-telling-you)). The effect could, in fact, [be negative](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/) and bloat the network buffers, preventing genuine frames in the document from being delivered. Also, it appears that server pushing is much [more effective on warm connections](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit) due to the TCP slow start.

Even with HTTP/1, putting critical CSS in a separate file on the root domain [has benefits](http://www.jonathanklein.net/2014/02/revisiting-cookieless-domain.html), sometimes even more than inlining due to caching. Chrome speculatively opens a second HTTP connection to the root domain when requesting the page, which removes the need for a TCP connection to fetch this CSS (_thanks, Philip!_)

A few gotchas to keep in mind: unlike `preload` that can trigger preload from any domain, you can only push resources from your own domain or domains you are authoritative for. It can be initiated as soon as the server gets the very first request from the client. Server pushed resources land in the Push cache and are removed when the connection is terminated. However, since an HTTP/2 connection can be re-used across multiple tabs, pushed resources can be claimed by requests from other tabs as well (_thanks, Inian!_).

At the moment, there is no simple way for the server to know if pushed resources are already in [one of the user’s caches](https://blog.yoav.ws/tale-of-four-caches/), so resources will keep being pushed with every user’s visit. You may then need to create a [cache-aware HTTP/2 server push mechanism](https://css-tricks.com/cache-aware-server-push/). If fetched, you could try to get them from a cache based on the index of what’s already in the cache, avoiding secondary server pushes altogether.

Keep in mind, though, that [the new `cache-digest` specification](http://calendar.perfplanet.com/2016/cache-digests-http2-server-push/) negates the need to manually build such "cache-aware" servers, basically declaring a new frame type in HTTP/2 to communicate what’s already in the cache for that hostname. As such, it could be particularly useful for CDNs as well.

For dynamic content, when a server needs some time to generate a response, the browser isn’t able to make any requests since it’s not aware of any sub-resources that the page might reference. For that case, we can warm up the connection and increase the TCP congestion window size, so that future requests can be completed faster. Also, all inlined assets are usually good candidates for server pushing. In fact, Inian Parameshwaran [did remarkable research comparing HTTP/2 Push vs. HTTP Preload](https://dexecure.com/blog/http2-push-vs-http-preload/), and it’s a fantastic read with all the details you might need. Server Push or Not Server Push? Colin Bendell’s [Should I Push?](https://shouldipush.com/) might point you in the right direction.

Bottom line: As Sam Saccone [noted](https://medium.com/@samccone/performance-futures-bundling-281543d9a0d5), `preload` is good for moving the start download time of an asset closer to the initial request, while Server Push is good for cutting out a full RTT ([or more](https://blog.yoav.ws/being_pushy/), depending on your server think time) — if you have a service worker to prevent unnecessary pushing, that is.
    
#### 43. Experiment with regrouping your CSS rules

We’ve got used to critical CSS, but there are a few optimizations that could go beyond that. Harry Roberts conducted a [remarkable research](https://csswizardry.com/2018/11/css-and-network-performance/) with quite surprising results. For example, it might be a good idea to split the main CSS file out into its individual media queries. That way, the browser will retrieve critical CSS with high priority, and everything else with low priority — completely off the critical path.

Also, avoid placing `<link rel="stylesheet" />` before `async` snippets. If scripts don’t depend on stylesheets, consider placing blocking scripts above blocking styles. If they do, split that JavaScript in two and load it either side of your CSS.

Scott Jehl solved another interesting problem by [caching an inlined CSS file with a service worker](https://www.filamentgroup.com/lab/inlining-cache.html), a common problem familiar if you’re using critical CSS. Basically, we add an ID attribute onto the `style` element so that it’s easy to find it using JavaScript, then a small piece of JavaScript finds that CSS and uses the Cache API to store it in a local browser cache (with a content type of `text/css`) for use on subsequent pages. To avoid inlining on subsequent pages and instead reference the cached assets externally, we then set a cookie on the first visit to a site. _Voilà!_

- YouTube 视频链接：https://youtu.be/Cjo9iq8k-bc

Do we [stream reponses](https://jakearchibald.com/2016/streams-ftw/)? With streaming, HTML rendered during the initial navigation request can take full advantage of the browser’s streaming HTML parser.

#### 44. Do you stream responses?

Often forgotten and neglected, [streams](https://streams.spec.whatwg.org/) provide an interface for reading or writing asynchronous chunks of data, only a subset of which might be available in memory at any given time. Basically, they allow the page that made the original request to start working with the response as soon as the first chunk of data is available, and use parsers that are optimized for streaming to progressively display the content.

We could create one stream from multiple sources. For example, instead of serving an empty UI shell and letting JavaScript populate it, you can let the service worker construct a stream where the shell comes from a cache, but the body comes from the network. As Jeff Posnick [noted](https://developers.google.com/web/updates/2016/06/sw-readablestreams), if your web app is powered by a CMS that server-renders HTML by stitching together partial templates, that model translates directly into using streaming responses, with the templating logic replicated in the service worker instead of your server. Jake Archibald’s [The Year of Web Streams](https://jakearchibald.com/2016/streams-ftw/) article highlights how exactly you could build it. Performance boost is [quite noticeable](https://www.youtube.com/watch?v=Cjo9iq8k-bc).

One important advantage of streaming the entire HTML response is that HTML rendered during the initial navigation request can take full advantage of the browser’s streaming HTML parser. Chunks of HTML that are inserted into a document after the page has loaded (as is common with content populated via JavaScript) can’t take advantage of this optimization.

Browser support? [Getting there](https://caniuse.com/#search=streams) with Chrome 52+, Firefox 57+ (behind flag), Safari and Edge supporting the API and Service Workers being [supported in all modern browsers](https://caniuse.com/#search=serviceworker).
    
#### 45. Consider making your components connection-aware

Data can be [expensive](https://whatdoesmysitecost.com/) and with growing payload, we need to respect users who choose to opt into data savings while accessing our sites or apps. The [Save-Data client hint request header](https://developers.google.com/web/updates/2016/02/save-data) allows us to customize the application and the payload to cost- and performance-constrained users. In fact, you could [rewrite requests for high DPI images to low DPI images](https://css-tricks.com/help-users-save-data/), remove web fonts, fancy parallax effects, preview thumbnails and infinite scroll, turn off video autoplay, server pushes, reduce the number of displayed items and downgrade image quality, or even change how you [deliver markup](https://dev.to/addyosmani/adaptive-serving-using-javascript-and-the-network-information-api-331p). Tim Vereecke has published a very detailed article on [data-s(h)aver strategies](https://calendar.perfplanet.com/2018/data-shaver-strategies/) featuring many options for data saving.

The header is currently supported only in Chromium, on the Android version of Chrome or via the Data Saver extension on a desktop device. Finally, you can also use the [Network Information API](https://googlechrome.github.io/samples/network-information/) to deliver [low/high resolution images](https://justmarkup.com/log/2017/11/network-based-image-loading/) and videos based on the network type. Network Information API and specifically `navigator.connection.effectiveType` (Chrome 62+) use `RTT`, `downlink`, `effectiveType` values (and a few [others](https://wicg.github.io/netinfo/)) to provide a representation of the connection and the data that users can handle.

In this context, Max Stoiber speaks of [connection-aware components](https://mxb.at/blog/connection-aware-components/). For example, with React, we could write a component that renders different elements for different connection types. As Max suggested, a `<Media />` component in a news article might output:

*   `Offline`: a placeholder with `alt` text,
*   `2G` / `save-data` mode: a low-resolution image,
*   `3G` on non-Retina screen: a mid-resolution image,
*   `3G` on Retina screens: high-res Retina image,
*   `4G`: an HD video.
    
Dean Hume provides a [practical implementation of a similar logic](https://deanhume.com/dynamic-resources-using-the-network-information-api-and-service-workers/) using a service worker. For a video, we could display a video poster by default, and then display the "Play" icon as well as the video player shell, meta-data of the video etc. on better connections. As a fallback for non-supporting browsers, we could [listen to `canplaythrough` event](https://benrobertson.io/front-end/lazy-load-connection-speed) and use `Promise.race()` to timeout the source loading if the `canplaythrough` event doesn’t fire within 2 seconds.

#### 46. Consider making your components device memory-aware

Network connection gives us only one perspective at the context of the user though. Going further, you could also dynamically [adjust resources based on available device memory](https://calendar.perfplanet.com/2018/dynamic-resources-browser-network-device-memory/), with the [Device Memory API](https://developers.google.com/web/updates/2017/12/device-memory) (Chrome 63+). `navigator.deviceMemory` returns how much RAM the device has in gigabytes, rounded down to the nearest power of two. The API also features a Client Hints Header, `Device-Memory`, that reports the same value.

![The priority column in DevTools](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/34f6f27f-88a9-425a-910e-39100034def3/devtools-priority-segixq.gif)

The 'Priority' column in DevTools. Image credit: Ben Schwarz, [The Critical Request](https://css-tricks.com/the-critical-request/)

#### 47. Warm up the connection to speed up delivery

Use [resource hints](https://w3c.github.io/resource-hints) to save time on [`dns-prefetch`](http://caniuse.com/#search=dns-prefetch) (which performs a DNS lookup in the background), [`preconnect`](http://www.caniuse.com/#search=preconnect) (which asks the browser to start the connection handshake (DNS, TCP, TLS) in the background), [`prefetch`](http://caniuse.com/#search=prefetch) (which asks the browser to request a resource) and [`preload`](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) (which prefetches resources without executing them, among other things).

Most of the time these days, we’ll be using at least `preconnect` and `dns-prefetch`, and we’ll be cautious with using `prefetch` and `preload`; the former should only be used if you are confident about what assets the user will need next (for example, in a purchasing funnel).

Note that even with `preconnect` and `dns-prefetch`, the browser has a limit on the number of hosts it will look up/connect to in parallel, so it’s a safe bet to order them based on priority (_thanks Philip!_).

In fact, using resource hints is probably the easiest way to boost performance, and [it works well indeed](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf). When to use what? As Addy Osmani [has explained](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf), we should preload resources that we have high-confidence will be used in the current page. Prefetch resources likely to be used for future navigations across multiple navigation boundaries, e.g. Webpack bundles needed for pages the user hasn’t visited yet.

Addy’s article on ["Loading Priorities in Chrome"](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) shows how _exactly_ Chrome interprets resource hints, so once you’ve decided which assets are critical for rendering, you can assign high priority to them. To see how your requests are prioritized, you can enable a "priority" column in the Chrome DevTools network request table (as well as Safari Technology Preview).

For example, since fonts usually are important assets on a page, it’s always a good idea to [request the browser to download fonts with](https://css-tricks.com/the-critical-request/#article-header-id-2) [`preload`](https://css-tricks.com/the-critical-request/#article-header-id-2). You could also [load JavaScript dynamically](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#dynamic-loading-without-execution), effectively lazy-loading execution. Also, since `<link rel="preload">` accepts a `media` attribute, you could choose to [selectively prioritize resources](https://css-tricks.com/the-critical-request/#article-header-id-3) based on `@media` query rules.

A few [gotchas to keep in mind](https://dexecure.com/blog/http2-push-vs-http-preload/): `preload` is good for [moving the start download time of an asset](https://www.youtube.com/watch?v=RWLzUnESylc) closer to the initial request, but preloaded assets land in the memory cache which is tied to the page making the request. `preload` plays well with the HTTP cache: a network request is never sent if the item is already there in the HTTP cache.

Hence, it’s useful for late-discovered resources, a hero image loaded via background-image, inlining critical CSS (or JavaScript) and pre-loading the rest of the CSS (or JavaScript). Also, a `preload` tag can initiate a preload only after the browser has received the HTML from the server and the lookahead parser has found the `preload` tag.

Preloading via the HTTP header is a bit faster since we don’t to wait for the browser to parse the HTML to start the request. [Early Hints](https://www.fastly.com/blog/faster-websites-early-priority-hints) will help even further, enabling preload to kick in even before the response headers for the HTML are sent and [Priority Hints](https://github.com/WICG/priority-hints) ([coming soon](https://www.chromestatus.com/feature/5273474901737472)) will help us indicate loading priorities for scripts.

Beware: if you’re using `preload`, `as` **must** be defined or [nothing loads](https://twitter.com/yoavweiss/status/873077451143774209), plus [preloaded fonts without the](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [`crossorigin`](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) [attribute will double fetch](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf).

#### 48. Use service workers for caching and network fallbacks

No performance optimization over a network can be faster than a locally stored cache on a user’s machine. If your website is running over HTTPS, use the "[Pragmatist’s Guide to Service Workers](https://github.com/lyzadanger/pragmatist-service-worker)" to cache static assets in a service worker cache and store offline fallbacks (or even offline pages) and retrieve them from the user’s machine, rather than going to the network. Also, check Jake’s [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/) and the free Udacity course "[Offline Web Applications](https://www.udacity.com/course/offline-web-applications--ud899)."

Browser support? As stated above, it’s [widely supported](http://caniuse.com/#search=serviceworker) (Chrome, Firefox, Safari TP, Samsung Internet, Edge 17+) and the fallback is the network anyway. Does it help boost performance? [Oh yes, it does](https://developers.google.com/web/showcase/2016/service-worker-perf). And it’s getting better, e.g. with Background Fetch allowing background uploads/downloads from a service worker. [Shipped in Chrome 71](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/z5WX-2RMulo/JQqeF3XZAgAJ).

There are a number of use cases for a service worker. For example, you could [implement "Save for offline" feature](https://una.im/save-offline/#%F0%9F%92%81), [handle broken images](https://bitsofco.de/handling-broken-images-with-service-worker/), introduce [messaging between tabs](https://www.loxodrome.io/post/tab-state-service-workers/) or [provide different caching strategies based on request types](https://medium.com/dev-channel/service-worker-caching-strategies-based-on-request-types-57411dd7652c). In general, a common reliable strategy is to store the app shell in the service worker’s cache along with a few critical pages, such as offline page, frontpage and anything else that might be important in your case.

There are a few gotchas to keep in mind though. With a service worker in place, we need to [beware range requests in Safari](https://philna.sh/blog/2018/10/23/service-workers-beware-safaris-range-request/) (if you are using Workbox for a service worker it has a [range request module](https://developers.google.com/web/tools/workbox/modules/workbox-range-requests)). If you ever stumbled upon `DOMException: Quota exceeded.` error in the browser console, then look into Gerardo’s article [When 7KB equals 7MB](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/).

As Gerardo writes, “If you are building a progressive web app and are experiencing bloated cache storage when your service worker caches static assets served from CDNs, make sure the [proper CORS response header exists](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#opaque-responses) for cross-origin resources, you [do not cache opaque responses](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#should-opaque-responses-be-cached-at-all) with your service worker unintentionally, you [opt-in cross-origin image assets into CORS mode](https://cloudfour.com/thinks/when-7-kb-equals-7-mb/#opt-in-to-cors-mode) by adding the `crossorigin` attribute to the `<img>` tag.”

A good starting point for using service workers would be [Workbox](https://developers.google.com/web/tools/workbox/), a set of service worker libraries built specifically for building progressive web apps.

#### 49. Are you using service workers on the CDN/Edge, e.g. for A/B testing?

At this point, we are quite used to running service workers on the client, but with [CDNs implementing them on the server](https://blog.cloudflare.com/introducing-cloudflare-workers/), we could use them to tweak performance on the edge as well.

For example, in A/B tests, when HTML needs to vary its content for different users, we could [use Service Workers on the CDN servers](https://www.filamentgroup.com/lab/servers-workers.html) to handle the logic. We could also [stream HTML rewriting](https://twitter.com/patmeenan/status/1065567680298663937) to speed up sites that use Google Fonts.

#### 50. Optimize rendering performance

Isolate expensive components with [CSS containment](http://caniuse.com/#search=contain) — for example, to limit the scope of the browser’s styles, of layout and paint work for off-canvas navigation, or of third-party widgets. Make sure that there is no lag when scrolling the page or when an element is animated, and that you’re consistently hitting 60 frames per second. If that’s not possible, then at least making the frames per second consistent is preferable to a mixed range of 60 to 15. Use CSS’ [`will-change`](http://caniuse.com/#feat=will-change) to inform the browser of which elements and properties will change.

Also, measure [runtime rendering performance](https://aerotwist.com/blog/my-performance-audit-workflow/#runtime-performance) (for example, [in DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/)). To get started, check Paul Lewis’ free [Udacity course on browser-rendering optimization](https://www.udacity.com/course/browser-rendering-optimization--ud860) and Georgy Marchuk’s article on [Browser painting and considerations for web performance](https://css-tricks.com/browser-painting-and-considerations-for-web-performance/).

If you want to dive deeper into the topic, Nolan Lawson has shared [tricks to accurately measure layout performance](https://nolanlawson.com/2018/09/25/accurately-measuring-layout-on-the-web/) in his article, and Jason Miller [suggested alternative techniques, too](https://twitter.com/_developit/status/1081682550865752064). We also have a lil' article by Sergey Chikuyonok on how to [get GPU animation right](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/). Quick note: changes to GPU-composited layers are the [least expensive](https://blog.algolia.com/performant-web-animations/), so if you can get away by triggering only compositing via `opacity` and `transform`, you'll be on the right track. Anna Migas has provided a lot of practical advice in her talk on [Debugging UI Rendering Performance](https://vimeo.com/302791098), too.

#### 51. Have you optimized rendering experience?

While the sequence of how components appear on the page, and the strategy of how we serve assets to the browser matter, we shouldn’t underestimate the role of [perceived performance](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/), too. The concept deals with psychological aspects of waiting, basically keeping customers busy or engaged while something else is happening. That’s where [perception management](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/), [preemptive start](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#preemptive-start), [early completion](https://www.smashingmagazine.com/2015/11/why-performance-matters-part-2-perception-management/#early-completion) and [tolerance management](https://www.smashingmagazine.com/2015/12/performance-matters-part-3-tolerance-management/) come into play.

What does it all mean? While loading assets, we can try to always be one step ahead of the customer, so the experience feels swift while there is quite a lot happening in the background. To keep the customer engaged, we can test [skeleton screens](https://twitter.com/lukew/status/665288063195594752) ([implementation demo](https://twitter.com/razvancaliman/status/734088764960690176)) instead of loading indicators, add transitions/animations and basically [cheat the UX](https://blog.stephaniewalter.fr/en/cheating-ux-perceived-performance-and-user-experience/) when there is nothing more to optimize. Beware though: skeleton screens should be tested before deploying as some [tests showed that skeleton screens can perform the worst](https://www.viget.com/articles/a-bone-to-pick-with-skeleton-screens/) by all metrics.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> **[译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)**
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
