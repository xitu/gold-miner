> * 原文地址：[Front-End Performance Checklist 2019 — 3](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 3

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> **[译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)**
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### Table Of Contents

- [Assets Optimizations](#assets-optimizations)
  - [17. Use Brotli or Zopfli for plain text compression](#17-use-brotli-or-zopfli-for-plain-text-compression)
  - [18. Use responsive images and WebP](#18-use-responsive-images-and-webp)
  - [19. Are images properly optimized?](#19-are-images-properly-optimized)
  - [20. Are videos properly optimized?](#20-are-videos-properly-optimized)
  - [21. Are web fonts optimized?](#21-are-web-fonts-optimized)

### Assets Optimizations

#### 17. Use Brotli or Zopfli for plain text compression

In 2015, Google [introduced](https://opensource.googleblog.com/2015/09/introducing-brotli-new-compression.html) [Brotli](https://github.com/google/brotli), a new open-source lossless data format, which is now [supported in all modern browsers](http://caniuse.com/#search=brotli). In practice, Brotli appears to be [much](https://paulcalvano.com/index.php/2018/07/25/brotli-compression-how-much-will-it-reduce-your-content/) [more effective](https://quixdb.github.io/squash-benchmark/#results-table) than Gzip and Deflate. It might be (very) slow to compress, depending on the settings, but slower compression will ultimately lead to higher compression rates. Still, it decompresses fast. You can also [estimate Brotli compression savings for your site](https://tools.paulcalvano.com/compression.php).

Browsers will accept it only if the user is visiting a website over HTTPS though. What’s the catch? Brotli still doesn’t come preinstalled on some servers today, and it’s not straightforward to set up without self-compiling Nginx. Still, [it’s not that difficult](https://www.tinywp.in/nginx-brotli/), and its support is coming, e.g. it’s available [since Apache 2.4.26](https://httpd.apache.org/docs/trunk/mod/mod_brotli.html). Brotli is widely supported, and many CDNs support it ([Akamai](https://community.akamai.com/community/web-performance/blog/2017/08/18/brotli-support-enablement-on-akamai), [AWS](https://medium.com/@felice.geracitano/brotli-compression-delivered-from-aws-7be5b467c2e1), [KeyCDN](https://www.keycdn.com/blog/keycdn-brotli-support), [Fastly](https://docs.fastly.com/guides/detailed-product-descriptions/performance-optimization-package), [Cloudlare](https://support.cloudflare.com/hc/en-us/articles/200168396-What-will-Cloudflare-compress-), [CDN77](https://www.cdn77.com/brotli)) and you can [enable Brotli even on CDNs that don’t support it](http://calendar.perfplanet.com/2016/enabling-brotli-even-on-cdns-that-dont-support-it-yet/) yet (with a service worker).

At the highest level of compression, Brotli is so slow that any potential gains in file size could be nullified by the amount of time it takes for the server to begin sending the response as it waits to dynamically compress the asset. With static compression, however, [higher compression settings are preferred](https://css-tricks.com/brotli-static-compression/).

Alternatively, you could look into using [Zopfli’s compression algorithm](https://blog.codinghorror.com/zopfli-optimization-literally-free-bandwidth/), which encodes data to Deflate, Gzip and Zlib formats. Any regular Gzip-compressed resource would benefit from Zopfli’s improved Deflate encoding because the files will be 3 to 8% smaller than Zlib’s maximum compression. The catch is that files will take around 80 times longer to compress. That’s why it’s a good idea to use Zopfli on resources that don’t change much, files that are designed to be compressed once and downloaded many times.

If you can bypass the cost of dynamically compressing static assets, it’s worth the effort. Both Brotli and Zopfli can be used for any plaintext payload — HTML, CSS, SVG, JavaScript, and so on.

The strategy? [Pre-compress static assets with Brotli+Gzip](https://css-tricks.com/brotli-static-compression/) at the highest level and compress (dynamic) HTML on the fly with Brotli at level 1–4. Make sure that the server handles content negotiation for Brotli or gzip properly. If you can’t install/maintain Brotli on the server, use Zopfli.
    
#### 18. Use responsive images and WebP

As far as possible, use [responsive images](https://www.smashingmagazine.com/2014/05/responsive-images-done-right-guide-picture-srcset/) with `srcset`, `sizes` and the `<picture>` element. While you’re at it, you could also make use of the [WebP format](https://www.smashingmagazine.com/2015/10/webp-images-and-performance/) (supported in Chrome, Opera, Firefox 65, Edge 18) by serving WebP images with the `<picture>` element and a JPEG fallback (see Andreas Bovens' [code snippet](https://dev.opera.com/articles/responsive-images/#different-image-types-use-case)) or by using content negotiation (using `Accept` headers). Ire Aderinokun has a very detailed [tutorial on converting images to WebP](https://bitsofco.de/why-and-how-to-use-webp-images-today/), too.

Sketch natively supports WebP, and WebP images can be exported from Photoshop using a [WebP plugin for Photoshop](http://telegraphics.com.au/sw/product/WebPFormat#webpformat). [Other options are available](https://developers.google.com/speed/webp/docs/using), too. If you’re using WordPress or Joomla, there are extensions to help you easily implement support for WebP, such as [Optimus](https://wordpress.org/plugins/optimus/) and [Cache Enabler](https://wordpress.org/plugins/cache-enabler/) for WordPress and [Joomla’s own supported extension](https://extensions.joomla.org/extension/webp/) (via [Cody Arsenault](https://css-tricks.com/comparing-novel-vs-tried-true-image-formats/)).

It’s important to note that while WebP image file sizes [compared to equivalent Guetzli and Zopfli](https://www.ctrl.blog/entry/webp-vs-guetzli-zopfli), the format [doesn’t support progressive rendering like JPEG](https://youtu.be/jTXhYj2aCDU?t=630), which is why users might see an actual image faster with a good ol' JPEG although WebP images might get faster through the network. With JPEG, we can serve a "decent" user experience with the half or even quarter of the data and load the rest later, rather than have a half-empty image as it is in the case of WebP. Your decision will depend on what you are after: with WebP, you’ll reduce the payload, and with JPEG you’ll improve perceived performance.

On Smashing Magazine, we use the postfix `-opt` for image names — for example, `brotli-compression-opt.png`; whenever an image contains that postfix, everybody on the team knows that the image has already been optimized. And — _shameless plug!_ — Jeremy Wagner even [published a Smashing book on WebP](https://www.smashingmagazine.com/ebooks/the-webp-manual/).

[![Responsive Image Breakpoints Generator](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/db62c469-bbfc-4959-839d-590abb41b64e/responsive-breakpoints-opt.png)](http://www.responsivebreakpoints.com/)

The [Responsive Image Breakpoints Generator](http://www.responsivebreakpoints.com/) automates images and markup generation.

#### 19. Are images properly optimized?

When you’re working on a landing page on which it’s critical that a particular image loads blazingly fast, make sure that JPEGs are progressive and compressed with [mozJPEG](https://github.com/mozilla/mozjpeg) (which improves the start rendering time by manipulating scan levels) or [Guetzli](https://github.com/google/guetzli), Google’s new open-source encoder focusing on perceptual performance, and utilizing learnings from Zopfli and WebP. [The only downside](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3): slow processing times (a minute of CPU per megapixel). For PNG, we can use [Pingo](http://css-ig.net/pingo), and for SVG, we can use [SVGO](https://www.npmjs.com/package/svgo) or [SVGOMG](https://jakearchibald.github.io/svgomg/). And if you need to quickly preview and copy or download all the SVG assets from a website, [svg-grabber](https://chrome.google.com/webstore/detail/svg-grabber-get-all-the-s/ndakggdliegnegeclmfgodmgemdokdmg) can do that for you, too.

Every single image optimization article would state it, but keeping vector assets clean and tight is always worth reminding. Make sure to clean up unused assets, remove unnecessary metadata and reduces the amount of path points in artwork (and thus SVG code). (_Thanks, Jeremy!_)

There are more advanced options though. You could:

*   Use [Squoosh](https://squoosh.app/) to compress, resize and manipulate images at the optimal compression levels (lossy or lossless),

*   Use the [Responsive Image Breakpoints Generator](http://www.responsivebreakpoints.com/) or a service such as [Cloudinary](http://cloudinary.com/documentation/api_and_access_identifiers) or [Imgix](https://www.imgix.com/) to automate image optimization. Also, in many cases, using `srcset` and `sizes` alone will reap significant benefits.

*   To check the efficiency of your responsive markup, you can use [imaging-heap](https://github.com/filamentgroup/imaging-heap), a command line tool that measure the efficiency across viewport sizes and device pixel ratios.

*   Lazy load images and iframes with [lazysizes](https://github.com/aFarkas/lazysizes), a library that detects any visibility changes triggered through user interaction (or IntersectionObserver which we’ll explore later).

*   Watch out for images that are loaded by default, but might never be displayed — e.g. in carousels, accordions and image galleries.

*   Consider [Swapping Images with the Sizes Attribute](https://www.filamentgroup.com/lab/sizes-swap/) by specifying different image display dimensions depending on media queries, e.g. to manipulate `sizes` to swap sources in a magnifier component.

*   Review [image download inconsistencies](https://csswizardry.com/2018/06/image-inconsistencies-how-and-when-browsers-download-images/) to prevent unexpected downloads for foreground and background images.

*   To optimize storage interally, you could use Dropbox’s new [Lepton format](https://github.com/dropbox/lepton) for losslessly compressing JPEGs by an average of 22%.

*   Watch out for the [`aspect-ratio` property in CSS](https://drafts.csswg.org/css-sizing-4/#ratios) and [`intrinsicsize` attribute](https://github.com/ojanvafai/intrinsicsize-attribute) which will allow us to set aspect ratios and dimensions for images, so browser can reserve a pre-defined layout slot early to [avoid layout jumps](https://24ways.org/2018/jank-free-image-loads/) during the page load.

*   If you feel adventurous, you could chop and rearrange HTTP/2 streams using [Edge workers](https://youtu.be/jTXhYj2aCDU?t=854), basically a real-time filter living on the CDN, to send images faster through the network. Edge workers use JavaScript streams that use chunks which you can control (basically they are JavaScript that runs on the CDN edge that can modify the streaming responses), so you can control the delivery of images. With service worker it’s too late as you can’t control what’s on the wire, but it does work with Edge workers. So you can use them on top of static JPEGs saved progressively for a particular landing page.

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8422076c-6eea-4b35-a98c-b15445cb2dff/viewport-percentage-match.jpg)](https://pbs.twimg.com/media/DY1XZ28VwAAwjd8.jpg) 

A sample output by [imaging-heap](https://github.com/filamentgroup/imaging-heap), a command line tool that measure the efficiency across viewport sizes and device pixel ratios. ([Image source](https://pbs.twimg.com/media/DY1XZ28VwAAwjd8.jpg)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8422076c-6eea-4b35-a98c-b15445cb2dff/viewport-percentage-match.jpg))

The future of responsive images might change dramatically with the adoption of [client hints](https://cloudfour.com/thinks/responsive-images-201-client-hints/). Client hints are HTTP request header fields, e.g. `DPR`, `Viewport-Width`, `Width`, `Save-Data`, `Accept` (to specify image format preferences) and others. They are supposed to inform the server about the specifics of user’s browser, screen, connection etc. As a result, the server can decide how to fill in the layout with appropriately sized images, and serve only these images in desired formats. With client hints, we move the resource selection from HTML markup and into the request-response negotiation between the client and server.

As Ilya Grigorik [noted](https://developers.google.com/web/updates/2015/09/automating-resource-selection-with-client-hints), client hints complete the picture — they aren’t an alternative to responsive images. "The `<picture>` element provides the necessary art-direction control in the HTML markup. Client hints provide annotations on resulting image requests that enable resource selection automation. Service Worker provides full request and response management capabilities on the client." A service worker could, for example, append new client hints headers values to the request, rewrite the URL and point the image request to a CDN, adapt response based on connectivity and user preferences, etc. It holds true not only for image assets but for pretty much all other requests as well.

For clients that support client hints, one could measure [42% byte savings on images](https://twitter.com/igrigorik/status/1032657105998700544) and 1MB+ fewer bytes for 70th+ percentile. On Smashing Magazine, we could measure [19-32% improvement](https://www.smashingmagazine.com/2016/01/leaner-responsive-images-client-hints/), too. Unfortunately, client hints still have to [gain some browser support](http://caniuse.com/#search=client-hints). Under consideration in [Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=935216) and [Edge](https://dev.modern.ie/platform/status/httpclienthints/). However, if you supply both the normal responsive images markup and the `<meta>` tag for Client Hints, then the browser will evaluate the responsive images markup and request the appropriate image source using the Client Hints HTTP headers.

Not good enough? Well, you can also improve perceived performance for images with the [multiple](http://csswizardry.com/2016/10/improving-perceived-performance-with-multiple-background-images/) [background](https://jmperezperez.com/medium-image-progressive-loading-placeholder/) [images](https://manu.ninja/dominant-colors-for-lazy-loading-images#tiny-thumbnails) [technique](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/). Keep in mind that [playing with contrast](https://css-tricks.com/contrast-swap-technique-improved-image-performance-css-filters/) and blurring out unnecessary details (or removing colors) can reduce file size as well. Ah, you need to enlarge a small photo without losing quality? Consider using [Letsenhance.io](https://letsenhance.io).

These optimizations so far cover just the basics. Addy Osmani has published a [very detailed guide on Essential Image Optimization](https://images.guide/) that goes very deep into details of image compression and color management. For example, you could blur out unnecessary parts of the image (by applying a Gaussian blur filter to them) to reduce the file size, and eventually you might even start removing colors or turn the picture into black and white to reduce the size even further. For background images, exporting photos from Photoshop with 0 to 10% quality can be absolutely acceptable as well. Ah, and [don’t use JPEG-XR on the web](https://calendar.perfplanet.com/2018/dont-use-jpeg-xr-on-the-web/) — "the processing of decoding JPEG-XRs software-side on the CPU nullifies and even outweighs the potentially positive impact of byte size savings, especially in the context of SPAs".

#### 20. Are videos properly optimized?

We covered images so far, but we’ve avoided a conversation about good ol' GIFs. Frankly, instead of loading heavy animated GIFs which impact both rendering performance and bandwidth, it’s a good idea to switch either to animated WebP (with GIF being a fallback) or replace them with [looping HTML5 videos](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/replace-animated-gifs-with-video/) altogether. Yes, the browser performance [is slow with `<video>`](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/#-but-we-already-have-video-tags), and, unlike with images, browsers do not preload `<video>` content, but they tend to be lighter and smaller than GIFs. Not an option? Well, at least we can add lossy compression to GIFs with [Lossy GIF](https://kornel.ski/lossygif), [gifsicle](https://github.com/kohler/gifsicle) or [giflossy](https://github.com/pornel/giflossy).

Early tests show that inline videos within `img` tags [display 20× faster and decode 7× faster](https://calendar.perfplanet.com/2017/animated-gif-without-the-gif/) than the GIF equivalent, in addition to being a fraction in file size. Although the support for `<img src=".mp4">` has [landed in Safari Technology Preview](https://developer.apple.com/safari/technology-preview/release-notes/), we are far from it being adopted widely as it’s [not coming to Blink any time soon](https://bugs.chromium.org/p/chromium/issues/detail?id=791658#c36).

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c987b182-0a0e-40e5-8f8d-dd81feb991f5/replace-animated-gifs.jpg)

Addy Osmani [recommends](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/replace-animated-gifs-with-video/) to replace animated GIFs with looping inline videos. The file size difference is noticeable (80% savings). ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c987b182-0a0e-40e5-8f8d-dd81feb991f5/replace-animated-gifs.jpg))

In the land of good news though, video formats have been advancing massively over the years. For a long time, we had hoped that WebM would become the format to rule them all, and WebP (which is basically one still image inside of the WebM video container) will become a replacement for dated image formats. But despite WebP and WebM [gaining](https://caniuse.com/webp) [support](https://caniuse.com/#feat=webm) these days, the breakthrough didn’t happen.

In 2018, the Alliance of Open Media has released a new promising video format called _AV1_. AV1 has compression similar to H.265 codec (the evolution of H.264) but unlike the latter, AV1 is free. The H.265 license pricing pushed browser vendors to adopting a comparably performant AV1 instead: **AV1 (just like H.265) compress twice as good as WebP**.

[![AV1 Logo 2018](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b5a4354f-4a9b-420d-8979-bd7abb87aebc/av1-logo-2018-full.png)](https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/AV1_logo_2018.svg/2560px-AV1_logo_2018.svg.png) 
    
AV1 has good chances of becoming the ultimate standard for video on the web. (Image credit: [Wikimedia.org](https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/AV1_logo_2018.svg/2560px-AV1_logo_2018.svg.png)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b5a4354f-4a9b-420d-8979-bd7abb87aebc/av1-logo-2018-full.png))
    
In fact, Apple currently uses HEIF format and HEVC (H.265), and all the photos and videos on the latest iOS are saved in these formats, not JPEG. While [HEIF](https://caniuse.com/#search=heif) and [HEVC (H.265)](https://caniuse.com/#search=hevc) aren’t properly exposed to the web (yet?), AV1 is — and [it’s gaining browser support](https://caniuse.com/#feat=av1). So adding the `AV1` source in your `<video>` tag is reasonable, as all browser vendors seem to be on board.

For now, the most widely used and supported encoding is H.264, served by MP4 files, so before serving the file, make sure that your MP4s are processed with a [multipass-encoding](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77), blurred with the [frei0r iirblur effect](https://yalantis.com/blog/experiments-with-ffmpeg-filters-and-frei0r-plugin-effects/) (if applicable) and [moov atom metadata](http://www.adobe.com/devnet/video/articles/mp4_movie_atom.html) is moved to the head of the file, while your server [accepts byte serving](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77). Boris Schapira provides [exact instructions for FFmpeg](https://medium.com/@borisschapira/optimize-your-mp4-video-for-better-performance-dareboost-blog-fb2f3f3dce77) to optimize videos to the maximum. Of course, providing WebM format as an alternative would help, too.

Video playback performance is a story on its own, and if you’d like to dive into it in details, take a look at Doug Sillar’s series on [The Current State of Video](https://www.smashingmagazine.com/2018/10/video-playback-on-the-web-part-1/) and [Video Delivery Best Practices](https://www.smashingmagazine.com/2018/10/video-playback-on-the-web-part-2/) that include details on video delivery metrics, video preloading, compression and streaming.

![Zach Leatherman’s Comprehensive Guide to Font-Loading Strategies](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/eb634666-55ab-4db3-aa40-4b146a859041/font-loading-strategies-opt.png)

Zach Leatherman’s [Comprehensive Guide to Font-Loading Strategies](https://www.zachleat.com/web/comprehensive-webfonts/) provides a dozen options for better web font delivery.

#### 21. Are web fonts optimized?

The first question that’s worth asking if you can get away with [using UI system fonts](https://www.smashingmagazine.com/2015/11/using-system-ui-fonts-practical-guide/) in the first place. If it’s not the case, chances are high that the web fonts you are serving include glyphs and extra features and weights that aren’t being used. You can ask your type foundry to subset web fonts or if you are using open-source fonts, subset them on your own with [Glyphhanger](https://www.afasterweb.com/2018/03/09/subsetting-fonts-with-glyphhanger/) or [Fontsquirrel](https://www.fontsquirrel.com/tools/webfont-generator). You can even automate your entire workflow with Peter Müller’s [subfont](https://github.com/Munter/subfont#readme), a command line tool that statically analyses your page in order to generate the most optimal web font subsets, and then inject them into your page.

[WOFF2 support](http://caniuse.com/#search=woff2) is great, and you can use WOFF as fallback for browsers that don’t support it — after all, legacy browsers would probably be served well enough with system fonts. There are _many, many, many_ options for web font loading, and you can choose one of the strategies from Zach Leatherman’s "[Comprehensive Guide to Font-Loading Strategies](https://www.zachleat.com/web/comprehensive-webfonts/)," (code snippets also available as [Web font loading recipes](https://github.com/zachleat/web-font-loading-recipes)).

Probably the better options to consider today are [Critical FOFT with `preload`](https://www.zachleat.com/web/comprehensive-webfonts/#critical-foft-preload) and ["The Compromise" method](https://www.zachleat.com/web/the-compromise/). Both of them use a two-stage render for delivering web fonts in steps — first a small supersubset required to render the page fast and accurately with the web font, and then load the rest of the family async. The difference is that "The Compromise" technique loads polyfill asynchronously only if [font load events](https://www.igvita.com/2014/01/31/optimizing-web-font-rendering-performance/#font-load-events) are not supported, so you don’t need to load the polyfill by default. Need a quick win? Zach Leatherman has a [quick 23-min tutorial and case study](https://www.zachleat.com/web/23-minutes/) to get your fonts in order.

In general, it’s a good idea to use the `preload` resource hint to preload fonts, but in your markup include the hints _after_ the link to critical CSS and JavaScript. Otherwise, font loading will cost you in the first render time. Still, it might be a good idea to [be selective](https://youtu.be/FbguhX3n3Uc?t=1637) and choose files that matter most, e.g. the ones that are critical for rendering or that would help you avoiding visible and disruptive text reflows. In general, Zach advises to **preload one or two fonts of each family** — it also makes sense to delay some font loading if they are less-critical.

Nobody likes waiting for the content to be displayed. With the [`font-display` CSS descriptor](https://font-display.glitch.me/), we can control the font loading behavior and enable content to be readable _immediately_ (`font-display: optional`) or _almost immediately_ (`font-display: swap`). However, if you want to [avoid text reflows](https://www.zachleat.com/web/font-display-reflow/), we still need to use the Font Loading API, specifically to **group repaints**, or when you are using third party hosts. Unless you can use [Google Fonts with Cloudflare Workers](https://blog.cloudflare.com/fast-google-fonts-with-cloudflare-workers/), of course. Talking about Google Fonts: consider using [google-webfonts-helper](https://google-webfonts-helper.herokuapp.com/fonts), a hassle-free way to self-host Google Fonts. [Always self-host your fonts](https://speakerdeck.com/addyosmani/web-performance-made-easy?slide=55) for maximum control if you can.

In general, if you use `font-display: optional`, it [might not be a good idea](https://www.zachleat.com/web/preload-font-display-optional/) to also use `preload` as it it’ll trigger that web font request early (causing network congestion if you have other critical path resources that need to be fetched). Use `preconnect` for faster cross-origin font requests, but be cautious with `preload` as preloading fonts from a different origin wlll incur network contention. All of these techniques are covered in Zach’s [Web font loading recipes](https://github.com/zachleat/web-font-loading-recipes).

Also, it might be a good idea to opt out of web fonts (or at least second stage render) if the user has enabled [Reduce Motion](https://webkit.org/blog/7551/responsive-design-for-motion/) in accessibility preferences or has opted in for Data Saver Mode (see [`Save-Data` header](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/save-data/)). Or when the user happens to have slow connectivity (via [Network Information API](https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API)).

To measure the web font loading performance, consider the [_All Text Visible_](https://noti.st/zachleat/KNaZEg/the-five-whys-of-web-font-loading-performance#s5IYiho) metric (the moment when all fonts have loaded and all content is displayed in web fonts), as well as [_Web Font Reflow Count_](https://noti.st/zachleat/KNaZEg/the-five-whys-of-web-font-loading-performance#sJw0KSc) after first render. Obviously, the lower both metrics are, the better the performance is. It’s important to notice that [variable](https://alistapart.com/blog/post/variable-fonts-for-responsive-design) [fonts](https://www.smashingmagazine.com/2017/09/new-font-technologies-improve-web/) might require a [significant performance consideration](https://youtu.be/FbguhX3n3Uc?t=2161). They give designers a much broader design space for typographic choices, but it comes at the cost of a single serial request opposed to a number of individual file requests. That single request might be slow blocking the entire typographic appearance on the page. On the good side though, with a variable font in place, we’ll get exactly one reflow by default, so no JavaScript will be required to group repaints.

Now, what would make a bulletproof web font loading strategy? Subset fonts and prepare them for the 2-stage-render, declare them with a `font-display` descriptor, use Font Loading API to group repaints and store fonts in a persistent service worker’s cache. You could fall back to Bram Stein’s [Font Face Observer](https://github.com/bramstein/fontfaceobserver) if necessary. And if you’re interested in measuring the performance of font loading, Andreas Marschke explores [performance tracking with Font API and UserTiming API](https://www.andreas-marschke.name/posts/2017/12/29/Fonts-API-UserTiming-Boomerang.html).

Finally, don’t forget to include [`unicode-range`](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2015/august/how-to-subset-fonts-with-unicode-range/) to break down a large font into smaller language-specific fonts, and use Monica Dinculescu’s [font-style-matcher](https://meowni.ca/font-style-matcher/) to minimize a jarring shift in layout, due to sizing discrepancies between the fallback and the web fonts.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> **[译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)**
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
