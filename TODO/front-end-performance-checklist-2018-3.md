> * 原文地址：[Front-End Performance Checklist 2018 - Part 3](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2018 - Part 3

Below you’ll find an overview of the front-end performance issues you mightneed to consider to ensure that your response times are fast and smooth.

- [Front-End Performance Checklist 2018 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [Front-End Performance Checklist 2018 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [Front-End Performance Checklist 2018 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [Front-End Performance Checklist 2018 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

### Assets Optimizations

22. **Is Brotli or Zopfli plain text compression in use?**

In 2015, Google [introduced](https://opensource.googleblog.com/2015/09/introducing-brotli-new-compression.html) [Brotli](https://github.com/google/brotli), a new open-source lossless data format, which is now [supported in all modern browsers](http://caniuse.com/#search=brotli). In practice, Brotli appears to be [more effective](https://samsaffron.com/archive/2016/06/15/the-current-state-of-brotli-compression) than Gzip and Deflate. It might be (very) slow to compress, depending on the settings, but slower compression will ultimately lead to higher compression rates. Still, it decompresses fast.

Browsers will accept it only if the user is visiting a website over HTTPS though. What's the catch? Brotli still doesn't come preinstalled on some servers today, and it's not straightforward to set up without self-compiling NGINX or Ubuntu. Still, [it's not that difficult](https://www.smashingmagazine.com/2016/10/next-generation-server-compression-with-brotli/). In fact, [some CDNs support it](https://community.akamai.com/community/web-performance/blog/2017/08/18/brotli-support-enablement-on-akamai) and you can even [enable Brotli even on CDNs that don't support it](http://calendar.perfplanet.com/2016/enabling-brotli-even-on-cdns-that-dont-support-it-yet/) yet (with a service worker).

At the highest level of compression, Brotli is so slow that any potential gains in file size could be nullified by the amount of time it takes for the server to begin sending the response as it waits to dynamically compress the asset. With static compression, however, [higher compression settings are preferred](https://css-tricks.com/brotli-static-compression/) — _thanks Jeremy!_).

Alternatively, you could look into using [Zopfli's compression algorithm](https://blog.codinghorror.com/zopfli-optimization-literally-free-bandwidth/), which encodes data to Deflate, Gzip and Zlib formats. Any regular Gzip-compressed resource would benefit from Zopfli's improved Deflate encoding, because the files will be 3 to 8% smaller than Zlib's maximum compression. The catch is that files will take around 80 times longer to compress. That's why it's a good idea to use Zopfli on resources that don't change much, files that are designed to be compressed once and downloaded many times.

If you can bypass the cost of dynamically compressing static assets, it's worth the effort. Both Brotli and Zopfli can be used for any plaintext payload — HTML, CSS, SVG, JavaScript, and so on.

The strategy? [Pre-compress static assets with Brotli+Gzip](https://css-tricks.com/brotli-static-compression/) at the highest level and compress (dynamic) HTML on the fly with Brotli at level 1–4\. Also, check for Brotli support on CDNs (e.g. _KeyCDN, CDN77, Fastly_). Make sure that the server handles content negotiation for Brotli or gzip properly. If you can't install/maintain Brotli on the server, use Zopfli.

23. **Are images properly optimized?**

As far as possible, use [responsive images](https://www.smashingmagazine.com/2014/05/responsive-images-done-right-guide-picture-srcset/) with `srcset`, `sizes` and the `<picture>` element. While you're at it, you could also make use of the [WebP format](https://www.smashingmagazine.com/2015/10/webp-images-and-performance/) (supported in Chrome, Opera, [Firefox soon](https://bugzilla.mozilla.org/show_bug.cgi?id=1294490)) by serving WebP images with the `<picture>` element and a JPEG fallback (see Andreas Bovens' [code snippet](https://dev.opera.com/articles/responsive-images/#different-image-types-use-case)) or by using content negotiation (using `Accept` headers).

Sketch natively supports WebP, and WebP images can be exported from Photoshop using a [WebP plugin for Photoshop](http://telegraphics.com.au/sw/product/WebPFormat#webpformat). [Other options are available](https://developers.google.com/speed/webp/docs/using), too. If you're using WordPress or Joomla, there are extensions to help you easily implement support for WebP, such as [Optimus](https://wordpress.org/plugins/optimus/) and [Cache Enabler](https://wordpress.org/plugins/cache-enabler/) for WordPress and [Joomla's own supported extension](https://extensions.joomla.org/extension/webp/) (via [Cody Arsenault](https://css-tricks.com/comparing-novel-vs-tried-true-image-formats/)).

You can also use [client hints](https://www.smashingmagazine.com/2016/01/leaner-responsive-images-client-hints/), which still have to [gain some browser support](http://caniuse.com/#search=client-hints). Not enough resources to bake in sophisticated markup for responsive images? Use the [Responsive Image Breakpoints Generator](http://www.responsivebreakpoints.com/) or a service such as [Cloudinary](http://cloudinary.com/documentation/api_and_access_identifiers) to automate image optimization. Also, in many cases, using `srcset` and `sizes` alone will reap significant benefits.

On Smashing Magazine, we use the postfix `-opt` for image names — for example, `brotli-compression-opt.png`; whenever an image contains that postfix, everybody on the team knows that the image has already been optimized.

[![Responsive Image Breakpoints Generator](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/db62c469-bbfc-4959-839d-590abb41b64e/responsive-breakpoints-opt.png)](http://www.responsivebreakpoints.com/)

The [Responsive Image Breakpoints Generator](http://www.responsivebreakpoints.com/) automates images and markup generation.

24. **Take image optimization to the next level.**

When you're working on a landing page on which it's critical that a particular image loads blazingly fast, make sure that JPEGs are progressive and compressed with [Adept](https://github.com/technopagan/adept-jpg-compressor), [mozJPEG](https://github.com/mozilla/mozjpeg) (which improves the start rendering time by manipulating scan levels) or [Guetzli](https://github.com/google/guetzli), Google's new open source encoder focusing on perceptual performance, and utilizing learnings from Zopfli and WebP. [The only downside](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3): slow processing times (a minute of CPU per megapixel). For PNG, we can use [Pingo](http://css-ig.net/pingo), and [SVGO](https://www.npmjs.com/package/svgo) or [SVGOMG](https://jakearchibald.github.io/svgomg/) for SVG.

Every single image optimization article would state it, but keeping vector assets clean and tight is always worth reminding. Make sure to clean up unused assets, remove unnecessary metadata and reduces the amount of path points in artwork (and thus SVG code). (_Thanks, Jeremy!_)

These optimizations so far cover just the basics. Addy Osmani has published a [very detailed guide on Essential Image Optimization](https://images.guide/) that goes very deep into details of image compression and color management. For example, you could blur out unnecessary parts of the image (by applying a Gaussian blur filter to them) to reduce the file size, and eventually you might even start removing colors or turn the picture into black and white to reduce the size even further. For background images, exporting photos from Photoshop with 0 to 10% quality can be absolutely acceptable as well.

What about GIFs? Well, instead of loading heavy animated GIFs which impact both rendering performance and bandwidth, we could potentially use [looping HTML5 videos](https://bitsofco.de/optimising-gifs/), yet [browser performance is slow with](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags) [`<video>`](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags) and, unlike with images, browsers do not preload `<video>` content. At least we can add lossy compression to GIFs with [Lossy GIF](https://kornel.ski/lossygif), [gifsicle](https://github.com/kohler/gifsicle)or [giflossy](https://github.com/pornel/giflossy).

[Good](https://developer.apple.com/safari/technology-preview/release-notes/) [news](https://bugs.chromium.org/p/chromium/issues/detail?id=791658): hopefully soon we'll be able to use `<img src=".mp4">` to load videos, and early tests show that `img` tags [display 20× faster and decode 7× faster](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/) than the GIF equivalent, in addition to being a fraction in file size.

Not good enough? Well, you can also improve perceived performance for images with the [multiple](http://csswizardry.com/2016/10/improving-perceived-performance-with-multiple-background-images/) [background](https://jmperezperez.com/medium-image-progressive-loading-placeholder/) [images](https://manu.ninja/dominant-colors-for-lazy-loading-images#tiny-thumbnails) [technique](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/). Keep in mind that [playing with contrast](https://css-tricks.com/contrast-swap-technique-improved-image-performance-css-filters/) and blurring out unnecessary details (or removing colors) can reduce file size as well. Ah, you need to enlarge a small photo without losing quality? Consider using [Letsenhance.io](https://letsenhance.io).

![Zach Leatherman's Comprehensive Guide to Font-Loading Strategies](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/eb634666-55ab-4db3-aa40-4b146a859041/font-loading-strategies-opt.png)

Zach Leatherman's [Comprehensive Guide to Font-Loading Strategies](https://www.zachleat.com/web/comprehensive-webfonts/) provides a dozen of options for better web font delivery.

25. **Are web fonts optimized?**

The first question that's worth asking if you can get away with [using UI system fonts](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/) in the first place. If it's not the case, chances are high that the web fonts you are serving include glyphs and extra features and weights that aren't being used. You can ask your type foundry to subset web fonts or [subset them yourself](https://www.fontsquirrel.com/tools/webfont-generator) if you are using open-source fonts (for example, by including only Latin with some special accent glyphs) to minimize their file sizes.

[WOFF2 support](http://caniuse.com/#search=woff2) is great, and you can use WOFF and OTF as fallbacks for browsers that don't support it. Also, choose one of the strategies from Zach Leatherman's "[Comprehensive Guide to Font-Loading Strategies](https://www.zachleat.com/web/comprehensive-webfonts/)," (code snippets also available as [Web font loading recipes](https://github.com/zachleat/web-font-loading-recipes)) and use a service worker cache to cache fonts persistently. Need a quick win? Pixel Ambacht has a [quick tutorial and case study](https://pixelambacht.nl/2016/font-awesome-fixed/) to get your fonts in order.

If you can't serve fonts from your server and are relying on third-party hosts, make sure to use [Font Load Events](https://www.igvita.com/2014/01/31/optimizing-web-font-rendering-performance/#font-load-events) (or [Web Font Loader](https://github.com/typekit/webfontloader) for browsers not supporting it). [FOUT is better than FOIT](https://www.filamentgroup.com/lab/font-events.html); start rendering text in the fallback right away, and load fonts asynchronously — you could also use [loadCSS](https://github.com/filamentgroup/loadCSS) for that. You might be able to [get away with locally installed OS fonts](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/) as well, or use [variable](https://alistapart.com/blog/post/variable-fonts-for-responsive-design) [fonts](https://www.smashingmagazine.com/2017/09/new-font-technologies-improve-web/) that are [gaining traction](https://caniuse.com/#search=variable), too.

What would make a bulletproof font loading strategy? Start with `font-display`, then fall back to the Font Loading API, _then_ fall back to Bram Stein's [Font Face Observer](https://github.com/bramstein/fontfaceobserver). (_thanks Jeremy!_) And if you're interested in measuring the performance of font loading from the user's perspective, Andreas Marschke explores [performance tracking with Font API and UserTiming API](ttps://www.andreas-marschke.name/posts/2017/12/29/Fonts-API-UserTiming-Boomerang.html).

Also, don't forget to include the [`font-display: optional`](https://font-display.glitch.me/) descriptor for resilient and fast font fallbacks, [`unicode-range`](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2015/august/how-to-subset-fonts-with-unicode-range/) to break down a large font into smaller language-specific fonts, and Monica Dinculescu's [font-style-matcher](https://meowni.ca/font-style-matcher/) to minimize a jarring shift in layout, due to sizing discrepancies between the two fonts.



### Delivery Optimizations

26. **Do you limit the impact of JavaScript libraries, and load them asynchronously?**

When the user requests a page, the browser fetches the HTML and constructs the DOM, then fetches the CSS and constructs the CSSOM, and then generates a rendering tree by matching the DOM and CSSOM. If any JavaScript needs to be resolved, the browser won't start rendering the page until it's resolved, thus delaying rendering. As developers, we have to explicitly tell the browser not to wait and to start rendering the page. The way to do this for scripts is with the `defer` and `async` attributes in HTML.

In practice, it turns out we should [prefer `defer` to](http://calendar.perfplanet.com/2016/prefer-defer-over-async/) `async` (at a [cost to users of Internet Explorer](https://github.com/h5bp/lazyweb-requests/issues/42) up to and including version 9, because you're likely to break scripts for them). Also, as mentioned above, limit the impact of third-party libraries and scripts, especially with social sharing buttons and `<iframe>` embeds (such as maps). [Size Limit](https://github.com/ai/size-limit) helps you [prevent JavaScript libraries bloat](https://evilmartians.com/chronicles/size-limit-make-the-web-lighter): If you accidentally add a large dependency, the tool will inform you and throw an error. You can use [static social sharing buttons](https://www.savjee.be/2015/01/Creating-static-social-share-buttons/) (such as by [SSBG](https://simplesharingbuttons.com)) and [static links to interactive maps](https://developers.google.com/maps/documentation/static-maps/intro) instead.

27. **Are you lazy-loading expensive scripts with Intersection Observer?**

If you need to lazy-load images, videos, ad scripts, A/B testing scripts or any other resources, you can use the shiny new [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) that provides a way to asynchronously observe changes in the intersection of a target element with an ancestor element or with a top-level document's viewport. Basically, you need to create a new IntersectionObserver object, which receives a callback function and a set of options. Then we add a target to observe.

The callback function executes when the target becomes visible or invisible, so when it intercepts the viewport, you can start taking some actions before the element becomes visible. In fact, we have a granular control over when the observer's callback should be invoked, with `rootMargin` (margin around the root) and `threshold` (a single number or an array of numbers which indicate at what percentage of the target's visibility we are aiming). Alejandro Garcia Anglada has published a [handy tutorial](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) on how to actually implement it.

You could even take it to the next level by adding [progressive image loading](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) to your pages. Similarly to Facebook, Pinterest and Medium, you could load low quality or even blurry images first, and then as the page continues to load, replace them with the full quality versions, using the [LQIP (Low Quality Image Placeholders) technique](https://www.guypo.com/introducing-lqip-low-quality-image-placeholders/) proposed by Guy Podjarny.

Opinions differ if the technique improves user experience or not, but it definitely improves time to first meaningful paint. We can even automate it by using [SQIP](https://github.com/technopagan/sqip) that creates a low quality version of an image as an SVG placeholder. These placeholders could be embedded within HTML as they naturally compress well with text compression methods. In his article, Dean Hume [has described](https://calendar.perfplanet.com/2017/progressive-image-loading-using-intersection-observer-and-sqip/) how this technique can be implemented using Intersection Observer.

Browser support? [Decent](https://caniuse.com/#feat=intersectionobserver), with Chrome, Firefox, Edge and Samsung Internet being on board. WebKit status is currently [in development](https://webkit.org/status/#specification-intersection-observer). Fallback? If we don't have support for intersection observer, we can still [lazy load](https://medium.com/@aganglada/intersection-observer-in-action-efc118062366) a [polyfill](https://github.com/jeremenichelli/intersection-observer-polyfill) or load the images immediately. And there is even a [library](https://github.com/ApoorvSaxena/lozad.js) for it.

In general, it's a good idea to lazy-load all expensive components, such as fonts, JavaScript, carousels, videos and iframes. You could even adapt content serving based on effective network quality. [Network Information API](https://googlechrome.github.io/samples/network-information/) and specifically `navigator.connection.effectiveType` (Chrome 62+) use RTT and downlink values to provide a slightly more accurate representation of the connection and the data that users can handle. You can use it to remove video autoplay, background images or web fonts entirely for connections that are too slow.

28. **Do you push critical CSS quickly?**

To ensure that browsers start rendering your page as quickly as possible, it's become a [common practice](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) to collect all of the CSS required to start rendering the first visible portion of the page (known as "critical CSS" or "above-the-fold CSS") and add it inline in the `<head>` of the page, thus reducing roundtrips. Due to the limited size of packages exchanged during the slow start phase, your budget for critical CSS is around 14 KB.

If you go beyond that, the browser will need additional roundtrips to fetch more styles. [CriticalCSS](https://github.com/filamentgroup/criticalCSS) and [Critical](https://github.com/addyosmani/critical) enable you to do just that. You might need to do it for every template you're using. If possible, consider using the [conditional inlining approach](https://www.filamentgroup.com/lab/modernizing-delivery.html) used by the Filament Group.

With HTTP/2, critical CSS could be stored in a separate CSS file and delivered via a [server push](https://www.filamentgroup.com/lab/modernizing-delivery.html) without bloating the HTML. The catch is that server pushing is [troublesome](https://twitter.com/jaffathecake/status/867699157150117888) with many gotchas and race conditions across browsers. It isn't supported consistently and has some caching issues (see slide 114 onwards of [Hooman Beheshti's presentation](http://www.slideshare.net/Fastly/http2-what-no-one-is-telling-you)). The effect could, in fact, [be negative](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/) and bloat the network buffers, preventing genuine frames in the document from being delivered. Also, it appears that server pushing is much [more effective on warm connections](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit) due to the TCP slow start.

Even with HTTP/1, putting critical CSS in a separate file on the root domain [has benefits](http://www.jonathanklein.net/2014/02/revisiting-cookieless-domain.html), sometimes even more than inlining due to caching. Chrome speculatively opens a second HTTP connection to the root domain when requesting the page, which removes the need for a TCP connection to fetch this CSS (_thanks, Philip!_)

A few gotchas to keep in mind: unlike `preload` that can trigger preload from any domain, you can only push resources from your own domain or domains you are authoritative for. It can be initiated as soon as the server gets the very first request from the client. Server pushed resources land in the Push cache and are removed when the connection is terminated. However, since an HTTP/2 connection can be re-used across multiple tabs, pushed resources can be claimed by requests from other tabs as well (_thanks, Inian!_).

At the moment, there is no simple way for the server to know if pushed resources are already in [one of user's caches](https://blog.yoav.ws/tale-of-four-caches/), so resources will keep being pushed with every user's visit. So, you might need to create a [cache-aware HTTP/2 server push mechanism](https://css-tricks.com/cache-aware-server-push/). If fetched, you could try to get them from a cache based on the index of what's already in the cache, avoiding secondary server pushes altogether.

Keep in mind, though, that [the new `cache-digest` specification](http://calendar.perfplanet.com/2016/cache-digests-http2-server-push/) negates the need to manually build such "cache-aware" servers, basically declaring a new frame type in HTTP/2 to communicate what's already in the cache for that hostname. As such, it could be particularly useful for CDNs as well.

For dynamic content, when a server needs some time to generate a response, the browser isn't able to make any requests since it's not aware of any sub-resources that the page might reference. For that case, we can warm up the connection and increase the TCP congestion window size, so that future requests can be completed faster. Also, all inlined assets are usually good candidates for server pushing. In fact, Inian Parameshwaran [did a remarkable research comparing HTTP/2 Push vs. HTTP Preload](https://dexecure.com/blog/http2-push-vs-http-preload/), and it's a fantastic read with all the details you might need. Server Push or Not Server Push? Colin Bendell's [Should I Push?](https://shouldipush.com/) might point you in the right direction.

Bottom line: As Sam Saccone [said](https://medium.com/@samccone/performance-futures-bundling-281543d9a0d5), `preload` is good for moving the start download time of an asset closer to the initial request, while Server Push is good for cutting out a full RTT ([or more](https://blog.yoav.ws/being_pushy/), depending on your server think time) — if you have a service worker to prevent unnecessary pushing, that is.

<figure class="video-container break-out"><iframe data-src="https://www.youtube.com/embed/Cjo9iq8k-bc" width="600" height="480" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

Do you [stream reponses](https://jakearchibald.com/2016/streams-ftw/)? With streaming, HTML rendered during the initial navigation request can take full advantage of the browser's streaming HTML parser.

29. **Do you stream responses?**

Often forgotten and neglected, [streams](https://streams.spec.whatwg.org/) provide an interface for reading or writing asynchronous chunks of data, only a subset of which might be available in memory at any given time. Basically, they allow the page that made the original request to start working with the response as soon as the first chunk of data is available, and use parsers that are optimized for streaming to progressively display the content.

We could create one stream from multiple sources. For example, instead of serving an empty UI shell and letting JavaScript populate it, you can let the service worker construct a stream where the shell comes from a cache, but the body comes from the network. As Jeff Posnick [noted](https://developers.google.com/web/updates/2016/06/sw-readablestreams), if your web app is powered by a CMS that server-renders HTML by stitching together partial templates, that model translates directly into using streaming responses, with the templating logic replicated in the service worker instead of your server. Jake Archibald's [The Year of Web Streams](https://jakearchibald.com/2016/streams-ftw/) article highlights how exactly you could build it. Performance boost is [quite noticeable](https://www.youtube.com/watch?v=Cjo9iq8k-bc).

One important advantage of streaming the entire HTML response is that HTML rendered during the initial navigation request can take full advantage of the browser's streaming HTML parser. Chunks of HTML that are inserted into a document after the page has loaded (as is common with content populated via JavaScript) can't take advantage of this optimization.

Browser support? [Getting there](https://caniuse.com/#search=streams) with Chrome 52+, Firefox 57+ (behind flag), Safari and Edge supporting the API and Service Workers being [supported in all modern browsers](https://caniuse.com/#search=serviceworker).

30. **Are you saving data with** `Save-Data`?

Especially when working in emerging markets, you might need to consider optimizing experience for users who choose to opt into data savings. The [Save-Data client hint request header](https://developers.google.com/web/updates/2016/02/save-data) allows us to customize the application and the payload to cost- and performance-constrained users. In fact, you could [rewrite requests for high DPI images to low DPI images](https://css-tricks.com/help-users-save-data/), remove web fonts and fancy parallax effects, turn off video autoplay, server pushes or even change how you deliver markup.

The header is currently supported only in Chromium, on the Android version of Chrome or via the Data Saver extension on a desktop device. Finally, you can also use service workers and the Network Information API to deliver low/high resolution images [based on the network type](https://justmarkup.com/log/2017/11/network-based-image-loading/).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
