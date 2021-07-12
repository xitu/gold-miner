> * 原文地址：[Progress Delayed Is Progress Denied](https://infrequently.org/2021/04/progress-delayed/)
> * 原文作者：[Infrequently Noted](https://infrequently.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/progress-delayed.md](https://github.com/xitu/gold-miner/blob/master/article/2021/progress-delayed.md)
> * 译者：
> * 校对者：

# Progress Delayed Is Progress Denied

### Do App Store policies harm developers? Is the web a credible alternative? A look at the data.

***Update (June 16th, 2021):** Folks attempting to build mobile web games have informed me that the [Fullscreen API](https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API) [remains broken on iOS for non-video elements](https://developer.apple.com/forums/thread/133248). This hobbles gaming and immersive media experiences in a way that is hard to overstate. Speaking of being hobbled, the original post gave Apple credit for eventually shipping a useable implementation of IndexedDB. [It seems this was premature](https://www.theregister.com/2021/06/16/apple_safari_indexeddb_bug/).*

---

Three facts...

1. [Apple bars web apps from the only App Store allowed on iOS](https://developer.apple.com/app-store/review/guidelines/#4.2).<sup>[1]</sup>
2. [Apple forces developers of competing browsers to use their engine for all browsers on iOS](https://developer.apple.com/app-store/review/guidelines/#2.5.6), restricting their ability to deliver a better version of the web platform.
3. [Apple claims](https://firt.dev/pwa-2021#tim-cook-promoting-pwas) that [browsers on iOS are platforms sufficient to support developers who object to the App Store's terms](https://firt.dev/ios-14.5/#progressive-web-apps-on-ios-14.5) .

...and a proposition:

> Apple's iOS browser (Safari) and engine (WebKit) are uniquely under-powered. Consistent delays in the delivery of important features ensure the web can never be a credible alternative to its proprietary tools and App Store.

This is a bold assertion, and proving it requires overwhelming evidence. This post mines publicly available data on the pace of compatibility fixes and feature additions to assess the claim.

### Steve & Tim's Close-up Magic

Misdirections often derail the debate around browsers, the role of the web, and App Store policies on iOS. Classics of the genre include:

> Apple's just focused on performance!

> ...that feature is in Tech Preview

> Apple's trying, they just added <long-awaited feature>

These points can be simultaneously valid and immaterial to the web's fitness as a competent alternative to native app development on iOS.

To understand the gap Apple created and maintains between the web and native, we should look at trends rather than individual releases. To know if we're in a drought, we have to check reservoir levels and seasonal rainfall. It might be raining features *right this instant*, but weather isn't climate.

Before we get to measuring water levels, I want to make some things *excruciatingly* clear.

First, what follows is not a critique of individuals on the Safari team or the WebKit project; it is a plea for Apple to [fund](https://www.cnbc.com/2021/01/27/apple-q1-cash-hoard-heres-how-much-apple-has-on-hand.html) their work adequately<sup>[2]</sup>. They are, pound for pound, some of the best engine developers globally and genuinely want good things for the web. Apple Corporate is at fault, not Open Source engineers or the line managers who support them.

Second, browser projects having different priorities at the leading edge is *natural and healthy*. So is speedy resolution and agreement. What's unhealthy is an engine trailing far behind for many years. *Even worse* are situations that cannot be addressed through browser choice. It's *good* for teams to be leading in different areas, assuming that the "compatible core" of features continues to expand at a steady pace. We should not expect uniformity in the short run — it would leave no room for leadership<sup>[3]</sup>.

Lastly, while this post *does* measure the distance Safari lags, let nobody mistake that for the core concern: *iOS App Store policies that prevent meaningful browser competition are at issue here*.

Safari trails competing MacOS browsers by roughly the same amount, but it's not a crisis because genuine browser choice enables meaningful alternatives.

MacOS Safari is compelling enough to have maintained 40-50% share for many years amidst stiff competition. Safari has many good features, and in an open marketplace, choosing it is entirely reasonable.

## The Performance Argument

As an engineer on a browser team, I've been privy to the blow-by-blow of various performance projects, benchmark fire drills, and the ways performance marketing impacts engineering priorities.

All modern browsers are fast, Chromium and Safari/WebKit included. No browser is *always* fastest. As reliably as the Sun rises in the East, new benchmarks launch projects to re-architect internals to pull ahead. This is as it should be.

Healthy competitions feature competitors trading the lead with regularity. [Spurious reports of "10x worse" performance](https://news.ycombinator.com/item?id=26186114) merit intense scepticism.

After 20 years of neck-in-neck competition, often starting from common code lineages, there just isn't *that* much left to wring out of the system. [Consistent improvement](https://blog.chromium.org/2021/04/digging-for-performance-gold.html) is the name of the game, and it can [still have positive impacts, particularly as users lean on the system more heavily over time](https://blog.chromium.org/2021/03/advanced-memory-management-and-more.html).

All browsers are deep into the optimisation journey, forcing complex tradeoffs. Improving things for one type of device or application can regress them for others. Significant gains today *tend* to [come from (subtly) breaking contracts with developers](https://blog.chromium.org/2020/11/tab-throttling-and-more-performance.html) in the hopes users won't notice. There isn't a massive gap in focus on performance engineering between engines.

Small gaps and a frequent hand-off of the lead imply differences in capability and correctness aren't the result of one team focusing on performance while others chase different goals<sup>[4]</sup>.

Finally, the choice to fund feature and correctness work is not mutually exclusive to improving performance. Many delayed features on the list below would allow web apps to run faster on iOS. Internal [re-architectures](https://blog.mozilla.org/blog/2017/11/14/introducing-firefox-quantum/) to improve correctness often [yield performance benefits](https://developers.google.com/web/updates/2019/06/layoutNG) too.

## The Compatibility Tax [#](#death-and)

Web developers are a hearty bunch; we don't give up at the first whiff of bugs or incompatibility between engines. [Deep wells of knowledge](https://alistapart.com/article/understandingprogressiveenhancement/) and [practice](https://alistapart.com/article/responsive-web-design/) centre on the question: *"how can we deliver a good experience to everyone despite differences in what their browsers support?"*

Adaptation is a way of life for skilled front enders.

The cultural value of adaptation has enormous implications. First, web developers don't view a single browser as their development target. Education, tools, and training all support the premise that supporting more browsers is better ([*ceteris paribus*](https://en.wikipedia.org/wiki/Ceteris_paribus#Economics)), creating a substantial incentive to grease squeaky wheels. Therefore, bridging the gap between leading and trailing-edge browsers is an intense focus of the web development community. Huge amounts of time and effort are spent developing workarounds (preferably with low runtime cost) for lagging engines<sup>[5]</sup>. Where workarounds fail, cutting features and UI fidelity is understood to be the right thing to do.

Compatibility across engines is key to developer productivity. To the extent that an engine has more than 10% share (or thereabouts), developers tend to view features it lacks as "not ready". It's therefore possible to deny web developers access to features globally by failing to deliver them at the margin.

A single important, lagging engine can make the whole web less competitive this way.

To judge the impact of iOS along this dimension, we can try to answer a few questions:

1. How far behind *both* competing engines is Safari regarding correctness?
2. When Safari has implemented essential features, how often is it far ahead? Behind?

Thanks to the [Web Platform Tests project](https://web-platform-tests.org/) and [`wpt.fyi`](https://wpt.fyi), we have the makings of an answer for the first:

[![Tests that fail only in a given browser. Lower is better.](/2021/04/progress-delayed/bsf.webp)((img) => { if (img && window.blurIt) { window.blurIt(img, ""); } })(document.currentScript.previousElementSibling.querySelector("img"));](https://wpt.fyi/results/?label=master&label=experimental&aligned)

Tests that fail only in a given browser. Lower is better.

The yellow Safari line is a rough measure of how often other browsers are compatible, but Safari's implementation is wrong. Conversely, the much lower Chrome and Firefox lines indicate Blink and Gecko are considerably more likely to agree and be correct regarding core web standards<sup>[6]</sup>.

[`wpt.fyi`'s new Compat 2021](https://wpt.fyi/compat2021?feature=summary&stable) dashboard narrows this full range of tests to a [subset chosen to represent the most painful compatibility bugs](https://web.dev/compat2021/#choosing-what-to-focus-on):

[![Stable-channel Compat 2021 results over time. Higher is better.](/2021/04/progress-delayed/compat_21_stable.png)((img) => { if (img && window.blurIt) { window.blurIt(img, ""); } })(document.currentScript.previousElementSibling.querySelector("img"));](https://wpt.fyi/compat2021?feature=summary&stable)

Stable-channel Compat 2021 results over time. Higher is better.

[![Tip-of-tree improvements are visible in WebKit. Sadly, these take quarters to reach devices because Apple ties WebKit features to the slow cadence of OS releases.](/2021/04/progress-delayed/compat_21_exp.png)((img) => { if (img && window.blurIt) { window.blurIt(img, ""); } })(document.currentScript.previousElementSibling.querySelector("img"));](https://wpt.fyi/compat2021?feature=summary)

Tip-of-tree improvements are visible in WebKit. Sadly, these take quarters to reach devices because Apple ties WebKit features to the slow cadence of OS releases.

In almost every area, Apple's low-quality implementation of *features WebKit already supports* requires workarounds. Developers would not need to find and fix these issues in Firefox (Gecko) or Chrome/Edge/Brave/Samsung Internet (Blink). This adds to the expense of developing for iOS.

## Converging Views

The [Web Confluence Metrics](https://web-confluence.appspot.com/#!/) project provides another window into this question.

This dataset is [derived by walking the tree of web platform features exposed to JavaScript](https://github.com/GoogleChromeLabs/confluence/blob/master/CatalogDataCollection.md#what-data-are-collected), an important subset of features. The available data goes back further, providing a fuller picture of the trend lines of engine completeness.

Engines add features at different rates, and the [Confluence graphs](https://web-confluence.appspot.com/#!/confluence) illuminate both the absolute scale of differences and the pace at which releases add new features. The data is challenging to compare across those graphs, so I extracted it to produce a [single chart](/2021/04/progress-delayed/confluence_data/index.html):

![](https://infrequently.org/2021/04/progress-delayed/confluence_data/rates.svg)

<small>blue: Chrome, red: Firefox, yellow: Safari</small>
<small>Count of APIs available from JavaScript by [Web Confluence](https://web-confluence.appspot.com/#!/confluence). Higher is better.</small>

In line with Web Platform Tests data, Chromium and Firefox implement more features and deliver them to market more steadily. From this data, we see that iOS is the least complete and competitive implementation of the web platform, and the gap is growing. At the time of the last Confluence run, the gap had stretched to nearly 1000 APIs, doubling since 2016.

Perhaps counting APIs gives a distorted view?

Some minor additions (e.g. [CSS's new Typed Object Model](https://developers.google.com/web/updates/2018/03/cssom)) may feature large expansions in API surface. Likewise, some transformative APIs (e.g. [webcam access via `getUserMedia()`](https://www.html5rocks.com/en/tutorials/getusermedia/intro/) or [Media Sessions](https://web.dev/media-session/)) may only add a few methods and properties.

To understand if intuitions formed by the Web Confluence data are directionally correct, we need to look more deeply at the history of feature development and connect APIs to the types of applications they enable.

## Material Impacts

Browser release notes and [caniuse](https://caniuse.com/) tables since [Blink forked from WebKit in 2013](https://www.zdnet.com/article/the-real-reason-why-google-forked-webkit/)<sup>[7]</sup> capture the arrival of features in each engine over an even longer period than either WPT or the Confluence dataset. This record can inform a richer understanding of how individual features and *sets* of capabilities unlock new types of apps.

Browsers sometimes launch new features simultaneously (e.g., [CSS Grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout) and [ES6](https://caniuse.com/?search=es6)). More often, there is a lag between the first and the rest. To provide a sizeable "grace period", and account for short-run differences in engine priorities, we look primarily at features with **a gap of three years or more**<sup>[8]</sup>.

What follows is an attempt at a full accounting of features launched in this era. A summary of each API and the impact of its absence accompanies every item.

### Where Chrome Has Lagged

It's healthy for engines to have different priorities, leading every browser to avoid certain features. Chrome has missed several APIs for 3+ years:

#### [Storage Access API](https://developer.mozilla.org/en-US/docs/Web/API/Storage_Access_API)

Introduced in Safari three years ago, this anti-tracking API was under-specified, leading to [significant divergence in API behaviour across implementations](https://developer.mozilla.org/en-US/docs/Web/API/Storage_Access_API#safari_implementation_differences). The low quality of Apple's initial versions of "Intelligent Tracking Prevention" [created *a worse* tracking vector](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/7450c395e2d3ca583b24f0b8fbf704aa3c781692.pdf)(pdf) ([subsequently repaired](https://support.apple.com/en-us/HT210792))<sup>[9]</sup>.

On the positive side, this has spurred a broader conversation around privacy on the web, leading to [many new, better-specified proposals](https://github.com/privacycg) and [proposed models](https://web.dev/digging-into-the-privacy-sandbox/).

#### [CSS Snap Points](https://caniuse.com/css-snappoints)

Image carousels and other touch-based UIs are smoother and easier to build using this feature. Differences within the Blink team about the correct order to deliver this vs. [Animation Worklets](https://developers.google.com/web/updates/2018/10/animation-worklet) led to regrettable delays.

#### [Initial Letter](https://caniuse.com/css-initial-letter)

An advanced typography feature, planned in Blink once the [LayoutNG project](https://developers.google.com/web/updates/2019/06/layoutNG) finishes.

#### [`position: sticky`](https://www.chromestatus.com/feature/6190250464378880)

Makes "fixed" elements in scroll-based UIs easier to build. The initial implementation was removed from Blink post-fork and re-implemented on new infrastructure several years later.

#### [CSS `color()`](https://css-tricks.com/wide-gamut-color-in-css-with-display-p3/)

Wide gamut colour is important in creative applications. Chrome does not yet support this for CSS, but is [under development for `<canvas>` and WebGL](https://chromestatus.com/feature/5701580166791168).

#### JPEG 2000

[Licensing concerns](http://en.swpat.org/wiki/JPEG_2000) caused [Chrome to ship WebP instead](https://developers.google.com/speed/webp/docs/c_study).

#### [HEVC/H.265](https://caniuse.com/hevc)

Next-generation video codecs, supported in many modern chips, but also a licensing minefield. The open, royalty-free codec [AV1](https://en.wikipedia.org/wiki/AV1) has been [delivered](https://caniuse.com/av1) instead.

### Where iOS Has Lagged

Some features in this list were launched in Safari but were not enabled for other browsers [forced to use WebKit on iOS](https://developer.apple.com/app-store/review/guidelines/#:~:text=2.5.6%20Apps%20that%20browse%20the%20web%20must%20use%20the%20appropriate%20WebKit%20framework%20and%20WebKit%20Javascript.) (e.g. [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers), [`getUserMedia`](https://developers.google.com/web/fundamentals/media/recording-video)). In these cases, only the delay to shipping in Safari is considered.

#### [`getUserMedia()`](https://developers.google.com/web/fundamentals/media/recording-video)

#### [Provides access to webcams](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia). Necessary for building competitive video experiences, including messaging and videoconferencing.

These categories of apps were delayed on the web for iOS by five years.

#### [WebRTC](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)

Real-time network protocols for enabling videoconferencing, desktop sharing, and game streaming applications.

Delayed five years.

#### [Gamepad API](https://caniuse.com/?search=gamepad%20api)

Fundamental for enabling the game streaming PWAs (Stadia, GeForce NOW, Luna, xCloud) now arriving on iOS.

Delayed five years.

#### [Audio Worklets](https://developers.google.com/web/updates/2017/12/audio-worklet)

Audio Worklets are a fundamental enabler for rich media and games on the web. Combined with WebGL2/WebGPU and WASM threading (see below), Audio Worklets unlock more of a device's available computing power, resulting in consistently good sound without fear of glitching.

After years of standards discussion and the first delivered to other platforms in 2018, iOS 14.5 finally shipped Audio Worklets *this week*.

#### [IndexedDB](https://developers.google.com/web/ilt/pwa/working-with-indexeddb)

A veritable [poster-child for the lateness and low quality of Safari](https://arstechnica.com/information-technology/2015/06/op-ed-safari-is-the-new-internet-explorer/) amongst web developers, IndexedDB is a modern replacement for the [legacy WebSQL API](http://html5doctor.com/introducing-web-sql-databases/). It provides developers with a way to store complex data locally.

Initially [delayed by two years](https://caniuse.com/indexeddb), first versions of the feature were so [badly broken on iOS](https://www.raymondcamden.com/2014/09/25/IndexedDB-on-iOS-8-Broken-Bad/) that independent developers began to [maintain lists](https://gist.github.com/nolanlawson/08eb857c6b17a30c1b26) of show-stopping bugs.

Had Apple shipped a usable version in either of the first two attempts, IndexedDB would not have made the three-year cut. The release of iOS 10 finally delivered a workable version, bringing the lag with Chrome and Firefox to four and five years, respectively.

#### [Pointer Lock](https://caniuse.com/pointerlock)

Critical for gaming with a mouse. Still not available for iOS or iPadOS.

#### [Media Recorder](https://developers.google.com/web/updates/2016/01/mediarecorder)

Fundamentally enabling for video creation apps. Without it, video recordings must fit in memory, leading to crashes.

This was Chrome's most anticipated developer feature *ever* (measured by stars). It was delayed by iOS for five years.

#### [Pointer Events](https://developers.google.com/web/updates/2016/10/pointer-events)

#### [A uniform API for handling user input](https://developers.google.com/web/updates/2016/10/pointer-events) like mouse movements and screen taps that is important in adapting content to mobile, [particularly regarding multi-touch gestures](https://javascript.info/pointer-events).

First proposed by Microsoft, delayed three years by Apple<sup>[10]</sup>.

#### [Service Workers](https://web.dev/service-worker-mindset/)

Key API enabling modern, reliable offline web experiences and PWAs.

Delayed three years ([Chrome 40, November 2014](https://blog.chromium.org/2014/12/chrome-40-beta-powerful-offline-and.html) vs. [Safari 11.1, April 2018](https://webkit.org/blog/8216/new-webkit-features-in-safari-11-1/), but not usable until several releases later).

#### [WebM and VP8/VP9](https://caniuse.com/?search=webm)

Royalty-free codecs and containers; free alternatives to H.264/H.265 with competitive compression and features. Lack of support forces developers to spend time and money transcoding and serving to multiple formats (in addition to multiple bitrates).

They are supported only for use in WebRTC but not the usual mechanisms for media playback (`<audio>` and `<video>`).

#### [CSS Typed Object Model](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Typed_OM_API)

[A high-performance](https://github.com/w3c/css-houdini-drafts/issues/634#issuecomment-366358609) [interface](https://developers.google.com/web/updates/2018/03/cssom) to styling elements. A fundamental building block that [enables](https://bugs.webkit.org/showdependencytree.cgi?id=190217&hide_resolved=0) other ["Houdini" features like CSS Custom Paint](https://www.smashingmagazine.com/2020/03/practical-overview-css-houdini/).

Not available for iOS.

#### [CSS Containment](https://www.smashingmagazine.com/2019/12/browsers-containment-css-contain-property/)

Features that [enable consistently high performance](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Containment) in rendering UI, and a building block for [new features](https://web.dev/content-visibility/) that can dramatically improve performance on large pages and apps.

Not available for iOS.

#### [CSS Motion Paths](https://www.infoq.com/news/2020/02/css-motion-path-browser-support/)

Enables [complex animations without JavaScript](https://blog.logrocket.com/css-motion-path-the-end-of-gsap/).

[Not available for iOS](https://caniuse.com/css-motion-paths).

#### [Media Source API (a.k.a. "MSE")](https://developers.google.com/web/fundamentals/media/mse/basics)

MSE enables the [`MPEG-DASH`](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP) video streaming protocol. Apple provides an implementation of [HLS](https://developer.apple.com/streaming/), but prevents use of alternatives.

Only available on iPadOS.

#### [`element.animate()`](https://hacks.mozilla.org/2016/08/animating-like-you-just-dont-care-with-element-animate/)

Browser support for the full Web Animations API has been rocky, with Chromium, Firefox, and Safari [all completing support for the full spec the past year](https://caniuse.com/web-animation).

`element.animate()`, a subset of the full API, has enabled developers to more easily create [high-performance visual effects](https://developers.google.com/web/updates/2014/05/Web-Animations-element-animate-is-now-in-Chrome-36) with a lower risk of visual stuttering in Chrome and Firefox since 2014.

#### [`EventTarget` Constructor](https://twitter.com/passle_/status/1246468359589412870)

Seemingly trivial but deceptively foundational. Lets developers integrate with the browser's internal mechanism for message passing.

Delayed by nearly three years on iOS.

#### Web Performance APIs

iOS consistently fails to provide modern APIs for measuring web performance by three or more years. Delayed or missing features are not limited to:

* [`navigator.sendBeacon()`](https://developers.google.com/web/updates/2014/10/Send-beacon-data-in-Chrome-39)
* [Paint Timing](https://web.dev/fcp/) ([delayed](https://chromestatus.com/feature/5688621814251520) [two-to-four years](https://webkit.org/blog/11648/new-webkit-features-in-safari-14-1/))
* [User Timing](https://www.html5rocks.com/en/tutorials/webperformance/usertiming/)
* [Resource Timing](https://developers.google.com/web/fundamentals/performance/navigation-and-resource-timing)
* [Performance Observers](https://developers.google.com/web/updates/2016/06/performance-observer)

The impact of missing Web Performance APIs is largely a question of scale: the larger the site or service one attempts to provide on the web, the more important measurement becomes.

#### [`fetch()`](https://caniuse.com/fetch) and [Streams](https://caniuse.com/mdn-api_readablestream)

Modern, asynchronous network APIs that [dramatically improve performance in some situations](https://jakearchibald.com/2016/streams-ftw/).

Delayed two to four years, depending on how one counts.

Not every feature blocked or delayed on iOS is transformative, and this list omits cases that were on the bubble (e.g., the 2.5 year lag for [BigInt](https://v8.dev/features/bigint)). Taken together, the delays Apple generates, even for low-controversy APIs, makes it challenging for businesses to treat the web as a serious development platform.

## The Price

Suppose Apple had implemented WebRTC and the Gamepad API in a timely way. Who can say if the [game streaming revolution](https://pocketnow.com/apple-says-cloud-gaming-services-like-stadia-and-xcloud-violate-app-store-policies) now taking place might have happened sooner? It's possible that [Amazon Luna](https://www.theverge.com/2020/10/20/21525339/amazon-luna-hands-on-cloud-gaming-streaming-early-access-price-games), [NVIDIA GeForce NOW](https://pocketnow.com/nvidias-game-streaming-service-arrives-on-ios-googles-stadia-is-next-in-line), [Google Stadia](https://www.macworld.com/article/234952/googles-stadia-game-streaming-service-is-now-available-on-ios-via-web-app.html), and [Microsoft xCloud](https://www.theverge.com/2021/4/20/22393793/microsoft-xbox-cloud-gaming-xcloud-iphone-ipad-hands-on) could have been built years earlier.

It's also possible that APIs delivered on every other platform, but not yet available on *any* iOS browser (because Apple), may unlock whole categories of experiences on the web.

While dozens of features are either currently, or predicted to be, delayed multiple years by Apple, a few high-impact capabilities deserve particular mention:

#### [WebGL2](https://webgl2fundamentals.org/webgl/lessons/webgl2-whats-new.html)

The first of two modern 3D graphics APIs currently held up by Apple, [WebGL2](https://hacks.mozilla.org/2017/01/webgl-2-lands-in-firefox/) dramatically improves the visual fidelity of 3D applications on the web, including games. The underlying graphics capabilities from [OpenGL ES 3.0](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/BestPracticesforAppleA7GPUsandLater/BestPracticesforAppleA7GPUsandLater.html) [have been available in iOS since 2013 with iOS 7.0](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/AdoptingOpenGLES3/AdoptingOpenGLES3.html#//apple_ref/doc/uid/TP40008793-CH504-SW4). WebGL 2 launched for other platforms on [Chrome and Firefox in 2017](https://caniuse.com/webgl2). While WebGL2 is [in development in WebKit](https://webkit.org/status/#specification-webgl-2), the anticipated end-to-end lag for these features is approaching half a decade.

#### [WebGPU](https://hacks.mozilla.org/2020/04/experimental-webgpu-in-firefox/)

WebGPU is a successor to WebGL and WebGL2 that [improves graphics performance](https://www.construct.net/en/blogs/ashleys-blog-2/webgl-webgpu-construct-1519) by better aligning with next-gen low-level graphics APIs ([Vulkan](https://www.khronos.org/vulkan/), [Direct3D 12](https://en.wikipedia.org/wiki/Direct3D#Direct3D_12), and [Metal](https://en.wikipedia.org/wiki/Metal_(API))).

WebGPU will also unlock richer [GPU compute](https://developers.google.com/web/updates/2019/08/get-started-with-gpu-compute-on-the-web#performance_findings) for the web, accelerating [machine learning](https://medium.com/octoml/webgpu-powered-machine-learning-in-the-browser-with-apache-tvm-3e5d79c77618) and media applications. WebGPU is likely to ship in Chrome in late 2021. Despite years of delay in standards bodies at the behest of Apple engineers, the timeline for WebGPU on iOS is unclear. Keen observers anticipate a minimum of several years of additional delay.

#### [WASM Threads](https://medium.com/google-earth/performance-of-web-assembly-a-thread-on-threading-54f62fd50cf7) and [Shared Array Buffers](https://caniuse.com/mdn-javascript_builtins_sharedarraybuffer)

Web Assembly ("WASM") is supported by all browsers today, but extensions for "threading" (the ability to use multiple processor cores together) are missing from iOS.

Threading support enables [richer and smoother 3D experiences](https://www.youtube.com/watch?v=khM7iilBgc0), games, AR/VR apps, creative tools, simulations, and scientific computing. The history of this feature is complicated, but TL;DR, [they are now available to sites that opt in](https://web.dev/coop-coep/) on every platform save iOS. Worse, there's no timeline and little hope of them becoming available soon.

Combined with delays for Audio Worklets, modern graphics APIs, and Offscreen Canvas, many compelling reasons to own a device have been impossible to deliver on the web.<sup>[11]</sup>

#### [WebXR](https://immersiveweb.dev/)

[Now in development in WebKit](https://bugs.webkit.org/showdependencytree.cgi?id=208988&hide_resolved=1) after years of radio silence, [WebXR APIs](https://web.dev/vr-comes-to-the-web/) provide Augmented Reality and Virtual Reality input and scene information to web applications. Combined with (delayed) advanced graphics APIs and threading support, WebXR enables immersive, low-friction commerce and entertainment on the web.

Support for a growing list of these features has been available in leading browsers across other platforms [for several years](https://caniuse.com/webxr). There is no timeline from Apple for when web developers can deliver equivalent experiences to their iOS users (in any browser).

These omissions mean web developers cannot compete with their native app counterparts on iOS in categories like gaming, shopping, and creative tools.

Developers [expect *some* lag](https://infrequently.org/2020/06/platform-adjacency-theory/) between the introduction of native features and corresponding browser APIs. Apple's policy against browser engine choice adds years of delays *beyond* the (expected) delay of design iteration, specification authoring, and browser feature development.

These delays prevent developers from reaching wealthy users with great experiences on the web. This gap, created exclusively and uniquely by Apple policy, all but forces businesses off the web and into the App Store where Apple [prevents developers from reaching users with web experiences](https://developer.apple.com/app-store/review/guidelines/#:~:text=your%20app%20should%20include%20features,%20content,%20and%20ui%20that%20elevate%20it%20beyond%20a%20repackaged%20website.).

## Just Out Of Reach

One might imagine five-year delays for 3D, media, and games might be the worst impact of Apple's policies preventing browser engine progress. That would be mistaken.

The next tier of missing features is relatively uncontroversial proposals in development in standards groups that Apple participates in or has enough support from web developers to be "no-brainers". Each enables better quality web apps. None are expected on iOS any time soon:

#### [Scroll Timeline](https://flackr.github.io/scroll-timeline/demo/parallax/) for CSS & Web Animations

Likely to ship in Chromium later this year, enables smooth animation based on scrolling and swiping, a key interaction pattern on modern mobile devices.

No word from Apple on if or when this will be available to web developers on iOS.

`content-visibility`

CSS extensions that [dramatically improve rendering performance](https://web.dev/content-visibility/) for large pages and complex apps.

#### [WASM SIMD](https://robaboukhalil.medium.com/webassembly-and-simd-7a7daa4f2ecd)

Coming to Chrome next month, [WASM SIMD enables high performance vector math](https://v8.dev/features/simd) for [dramatically improved performance](https://www.infoq.com/articles/webassembly-simd-multithreading-performance-gains/) for many media, ML, and 3D applications.

#### [Form-associated Web Components](https://web.dev/more-capable-form-controls/)

Reduces data loss in web forms and enables components to be easily reused across projects and sites.

#### [CSS Custom Paint](https://houdini.how/)

Efficiently enables [new styles of drawing content on the web](https://bobrov.dev/css-paint-demos/), removing many hard tradeoffs between [visual richness](https://houdini.how/), accessibility, and performance.

#### [Trusted Types](https://web.dev/trusted-types/)

A standard version of an approach [demonstrated in Google's web applications to dramatically improve security](https://security.googleblog.com/2020/07/towards-native-security-defenses-for.html).

#### [CSS Container Queries](https://css-tricks.com/say-hello-to-css-container-queries/)

A top request from web developers and [expected in Chrome later this year](https://bugs.chromium.org/p/chromium/issues/detail?id=1145970), CSS Container Queries enable content to [better adapt to varying device form-factors](https://piccalil.li/blog/container-queries-are-actually-coming).

#### [`<dialog>`](https://css-tricks.com/some-hands-on-with-the-html-dialog-element/)

A built-in mechanism for a common UI pattern, improving performance and consistency.

#### [`inert` Attribute](https://css-tricks.com/focus-management-and-inert/#enter-inert)

Improves focus management and accessibility.

#### [Browser assisted lazy-loading](https://web.dev/lazy-loading-images/#images-inline-browser-level)

Reduces data use and improves page load performance.

Fewer of these features are foundational (e.g. SIMD). However, even those that can be emulated in other ways still impose costs on developers and iOS users to paper over the gaps in Apple's implementation of the web platform. This tax can, without great care, [slow experiences for users on other platforms](https://www.debugbear.com/blog/how-does-browser-support-impact-bundle-size) as well<sup>[12]</sup>.

## What Could Be

Beyond these relatively uncontroversial (MIA) features lies an ocean of foreclosed possibility. Were Apple willing to allow the sort of honest browser competition for iOS that MacOS users enjoy, features like these would enable entirely new classes of web applications. Perhaps that's the problem.

Some crucial features (shipped on every other OS) that Apple is preventing *any* browser from delivering to iOS today, in no particular order:

#### [Push Notifications](https://developers.google.com/web/fundamentals/push-notifications)

In an egregious display of anti-web gate-keeping, Apple has implemented for iOS *neither* the long-standard [Web Push API](https://web.dev/push-notifications-overview/) *nor* [Apple's own](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/NotificationProgrammingGuideForWebsites/Introduction/Introduction.html), entirely proprietary [push notification system for MacOS Safari](https://developer.apple.com/notifications/safari-push-notifications/)

It's difficult to overstate the challenges posed by a lack of push notifications on a modern mobile platform. Developers across categories report a lack of push notifications as a deal-killer, including:

* Chat, messaging, and social apps (for obvious reasons)
* [e-commerce](https://developers.google.com/web/showcase/2015/beyond-the-rack) (abandoned cart reminders, shipping updates, etc.)
* News publishers (breaking news alerts)
* Travel (itinerary updates & at-a-glance info)
* [Ride sharing](https://developers.google.com/web/showcase/2017/ola) & delivery (status updates)

This omission has put sand in the web's tank — to the benefit of Apple's native platform, which [has enjoyed push notification support for 12 years](https://en.wikipedia.org/wiki/Apple_Push_Notification_service).

#### [PWA Install Prompts](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Add_to_home_screen)

Apple led the way with [support for installing certain web apps to a device's homescreen](https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html) as early as iOS 1.0. Since 2007, support for these features has barely improved.

Subsequently, Apple [added the ability to promote the installation of native apps](https://developer.apple.com/documentation/webkit/promoting_apps_with_smart_app_banners), but has not provided equivalent "install prompt" tools for web apps.

Meanwhile, browsers on other platforms have developed both [ambient (browser provided) promotion](https://web.dev/promote-install/#browser-promotion) and [programmatic mechanisms](https://web.dev/customize-install/) to guide users in saving frequently-used web content to their devices.

Apple's maintenance of this feature gap between native and web (despite clear underlying support for the mechanism) and unwillingness to allow other iOS browsers to improve the situation<sup>[13]</sup>, combined with policies that prevent the placement of web content in the App Store, puts a heavy thumb on the scale for discovering content built with Apple's proprietary APIs.

#### [PWA App Icon Badging](https://web.dev/badging-api/)

Provides support for "unread counts", e.g. for email and chat programs. Not available for web apps added to the home screen on iOS.

#### [Media Session API](https://firt.dev/ios-14.5/#background-audio)

Enables web apps to play media while in the background. It also allows developers to plug into (and configure) system controls for back/forward/play/pause/etc. and provide track metadata (title, album, cover art).

Lack of this feature prevents entire classes of media applications (podcasting and music apps like Spotify) from being plausible.

[In development now](https://firt.dev/ios-14.5/#:~:text=but%20there%20is%20one%20hope%3A%20the%20media%20session%20api%20is%20now%20available%20as%20an%20experiment), but if it ships this fall (the earliest window), web media apps will have been delayed more than five years.

#### [Navigation Preloads](https://developers.google.com/web/updates/2017/02/navigation-preload)

Dramatically improve page loading performance on sites that provide an offline experience using [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers).

Multiple top-10 web properties have reported to Apple that lack of this feature prevents them from deploying more resilient versions of their experiences (including building [PWAs](https://web.dev/progressive-web-apps/)) for users on iOS.

#### [Offscreen Canvas](https://medium.com/samsung-internet-dev/offscreencanvas-workers-and-performance-3023ca15d7c7)

Improves the smoothness of 3D and media applications by moving rendering work to a separate thread. For latency-sensitive use-cases like XR and games, this feature is necessary to consistently deliver a competitive experience.

#### `TextEncoderStream` & `TextDecoderStream`

These [TransformStream types](https://github.com/ricea/encoding-streams/blob/master/stream-explainer.md) help applications efficiently deal with large amounts of binary data. [They *may* have shipped in iOS 14.5](https://firt.dev/ios-14.5/) but the [release notes are ambiguious](https://webkit.org/blog/11648/new-webkit-features-in-safari-14-1/).

#### [`requestVideoFrameCallback()`](https://blog.tomayac.com/2020/05/15/the-requestvideoframecallback-api/)

Helps media apps on the web save battery when doing video processing.

#### [Compression Streams](https://github.com/wicg/compression/blob/main/explainer.md)

Enable developers to compress data efficiently without downloading large amounts of code to the browser.

#### [Keyboard Lock API](https://web.dev/keyboard-lock/)

An essential part of remote desktop apps and some game streaming scenarios with keyboards attached ([not uncommon for iPadOS users](https://www.apple.com/shop/ipad/accessories/keyboards)).

#### [Declarative Shadow DOM](https://web.dev/declarative-shadow-dom/)

An addition to the [Web Components](https://www.webcomponents.org/introduction) system that powers applications like YouTube and Apple Music. Declarative Shadow DOM can [improve loading performance](https://github.com/mfreed7/declarative-shadow-dom/blob/master/README.md#performance) and help developers provide UI for users when scripts are disabled or fail to load.

#### [Reporting API](https://developer.mozilla.org/en-US/docs/Web/API/Reporting_API)

Indispensable for improving the quality of sites and avoid breakage due to browser deprecations. Modern versions [also let developers know when applications crash](https://developer.mozilla.org/en-US/docs/Web/API/CrashReportBody), helping them diagnose and repair broken sites.

#### [Permissions API](https://developers.google.com/web/updates/2015/04/permissions-api-for-the-web)

Helps developers present better, more contextual options and prompts, reducing user annoyance and "prompt spam".

#### [Screen Wakelock](https://web.dev/wake-lock/)

Keeps the screen from going dark or a screen saver taking over. Important for apps that present boarding passes and QR codes for scanning, as well as and presentation apps (e.g. PowerPoint or Google Slides).

#### [Intersection Observer V2](https://web.dev/intersectionobserver-v2/)

Reduces ad fraud and enables one-tap-sign-up flows, improving commerce conversion rates.

#### [Content Indexing](https://web.dev/content-indexing-api/)

An extension to Service Workers that enables browsers to present users with cached content when offline.

#### [AV1/AVIF](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Video_codecs#:~:text=the%20aomedia%20video%201%20(av1)%20codec%20is%20an%20open%20format%20designed%20by%20the%20alliance%20for%20open%20media%20specifically%20for%20internet%20video.)

A modern, royalty-free video codec with near-universal support outside Safari.

#### [PWA App Shortcuts](https://web.dev/app-shortcuts/)

Allows developers to configure "long press" or "right-click" options for web apps installed to the home screen or dock.

#### [Shared Workers](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker) and [Broadcast Channels](https://developers.google.com/web/updates/2016/09/broadcastchannel)

Coordination APIs allow applications to save memory and processing power (albeit, most often in desktop and tablet form-factors).

#### [`getInstalledRelatedApps()`](https://web.dev/get-installed-related-apps/)

Helps developers avoid prompting users for permissions that might be duplicative with apps already on the system. Particularly important for avoiding duplicated push notifications.

#### [Background Sync](https://developers.google.com/web/updates/2015/12/background-sync)

A tool for reliably sending data — for example, chat and email messages — in the face of intermittent network connections.

#### [Background Fetch API](https://www.youtube.com/watch?v=cElAoxhQz6w)

Allows applications to [upload and download bulk media efficiently](https://developers.google.com/web/updates/2018/12/background-fetch) with progress indicators and controls. Important for reliably syncing playlists of music or videos for offline or synchronising photos/media for sharing.

#### [Periodic Background Sync](https://web.dev/periodic-background-sync/)

Helps applications ensure they have fresh content to display offline in a battery and bandwidth-sensitive way.

#### [Web Share Target](https://web.dev/web-share-target/)

Allows installed web apps to *receive* sharing intents via system UI, enabling chat and social media apps to help users post content more easily.

The list of missing, foundational APIs for media, social, e-commerce, 3d apps, and games is astonishing. Essential apps in the most popular categories in the App Store are impossible to attempt on the web on iOS because of feature gaps Apple has created and perpetuates.

## Device APIs: The Final Frontier

An area where browsers makers disagree fervently, but where Chromium-based browsers have forged ahead (Chrome, Edge, Samsung Internet, Opera, UC, etc.) is access to hardware devices. While not essential to most "traditional" web apps, these features are foundational for vibrant categories like education and creative music applications. iOS Safari supports none of them today, while Chromium browsers on other OSes enable these apps on the web:

#### [Web Bluetooth](https://web.dev/bluetooth/)

Allows Bluetooth Low Energy devices to safely communicate with web apps, eliminating the need to download heavyweight applications to configure individual IoT devices.

#### [Web MIDI](https://www.smashingmagazine.com/2018/03/web-midi-api/)

Enables creative music applications on the web, including synthesisers, mixing suites, drum machines, and music recording.

#### [Web USB](https://web.dev/usb/)

Provides safe access to USB devices from the web, enabling new classes of applications in the browser from [education](https://www.microsoft.com/en-us/makecode) to [software development](https://flash.android.com/welcome) and [debugging](https://app.vysor.io/#/).

#### [Web Serial](https://web.dev/serial/)

Supports connections to legacy devices. Particularly important in industrial, IoT, health care, and education scenarios.

Web Serial, Web Bluetooth, and Web USB enable educational programming tools to help students learn to program physical devices, including [LEGO](https://makecode.mindstorms.com/bluetooth).

Independent developer [Henrik Jorteg](https://twitter.com/HenrikJoreteg) has [written at length about frustration stemming from an inability to access these features on iOS](https://joreteg.com/blog/project-fugu-a-new-hope), and has [testified to the way they enable lower cost development](https://www.youtube.com/watch?v=14pb8t1lHws&t=1640s). The lack of web APIs on iOS isn't just a frustration for developers. It drives up the prices of goods and services, shrinking the number of organisations that can deliver them.

#### [Web HID](https://web.dev/hid-examples/)

Enables safe connection to input [devices](https://github.com/robatwilliams/awesome-webhid#devices) not traditionally supported as keyboards, mice, or gamepads.

This API provides safe access to specialised features of niche hardware over a standard protocol they already support without proprietary software or unsafe native binary downloads.

#### [Web NFC](https://web.dev/nfc/)

Lets web apps safely read and write NFC tags, e.g. for tap-to-pay applications.

#### [Shape Detection](https://web.dev/shape-detection/)

Unlocks platform and OS provided capabilities for high-performance recognition of barcodes, faces, text in images and video.

Important in videoconferencing, commerce, and IoT setup scenarios.

#### [Generic Sensors API](https://web.dev/generic-sensor/)

A uniform API for accessing sensors standard in phones, including Gyroscopes, Proximity sensors, Device Orientation, Acceleration sensors, Gravity sensors, and Ambient Light detectors.

Each entry in this inexhaustive list can block entire classes of applications from credibly being possible on the web. The real-world impact is challenging to measure. Weighing up the deadweight losses seems a good angle for economists to investigate. Start-ups not attempted, services not built, and higher prices for businesses forced to develop native apps multiple times could, perhaps, be estimated.

## Incongruous

The data agree: Apple's web engine consistently trails others in both compatibility and features, resulting in a large and persistent gap with Apple's native platform.

Apple wishes us to accept that:

* It is reasonable to force iOS browsers to use its web engine, leaving iOS on the trailing edge.
* The web is a viable alternative on iOS for developers unhappy with App Store policies.

One or the other might be reasonable. Together? Hmm.

Parties interested in the health of the digital ecosystem should look past Apple's claims and focus on the differential pace of progress.

---

***Full disclosure**: for the past twelve years I have worked on Chromium at Google, spanning both the pre-fork era where potential features for Chrome and Safari were discussed within the WebKit project, as well as the [post-fork](https://techcrunch.com/2013/04/03/google-forks-webkit-and-launches-blink-its-own-rendering-engine-that-will-soon-power-chrome-and-chromeos/) epoch. Over this time I have led multiple projects to add features to the web, some of which have been opposed by Safari engineers.*

*Today, I lead [Project Fugu](https://web.dev/fugu-status/), a collaboration within Chromium that is directly responsible for the majority of the device APIs mentioned above. Microsoft, Intel, Google, Samsung, and others are contributing to this work, and it is being done in the open with the hope of standardisation, but my interest in its success is large. My front-row seat allows me to state unequivocally that independent software developers are clamouring for these APIs and are ignored when they request support for them from Apple. It is personally frustrating to be unable to deliver these improvements for developers who wish to reach iOS users — which is all developers. My interests and biases are plain.*

*Previously, I helped lead the effort to develop Service Workers, Push Notifications, and PWAs over the frequent and pointed objections of Apple's engineers and managers. Service Worker design was started as a collaboration between Google, Mozilla, Samsung, Facebook, Microsoft, and independent developers looking to make better, more reliable web applications. Apple only joined the group after other web engines had delivered working implementations. The delay in availability of Service Workers (as well as highly-requested follow-on features like Navigation Preload) for iOS users and developers interested in serving them well, likewise, carries an undeniable personal burden of memory.*

---

1. iOS is unique in disallowing the web from participating in its only app store. MacOS's built-in App Store has similar anti-web terms, but MacOS allows multiple app stores (e.g. Steam and the Epic Store), along with real browser choice.

   [Android](https://developer.chrome.com/docs/android/trusted-web-activity/overview/) and [Windows](https://docs.microsoft.com/en-us/microsoft-edge/progressive-web-apps-chromium/microsoft-store) directly include support for web apps in their default stores, allow multiple stores, and facilitate true browser choice. [↩︎](#fnref-progress-delayed-1)

2. Failing adequate staffing for the Safari and WebKit teams, we must insist that Apple change iOS policy to allow competitors to safely fill the gaps that Apple's own skinflint choices have created. [↩︎](#fnref-progress-delayed-2)

3. Claims that I (or other Chromium contributors) would happily see engine homogeneity could not be more wrong. [↩︎](#fnref-progress-delayed-3)

4. Some commenters appear to confuse unlike hardware for differences in software. For example, an area where Apple is *absolutely killing it* is [CPU design](https://infrequently.org/2021/03/the-performance-inequality-gap/#mind-the-gap). Resulting differences in [Speedometer](https://browserbench.org/Speedometer2.0/) scores between flagship Android and iOS devices are demonstrations of Apple's domineering lead in mobile CPUs.

   A-series chips have run circles around other ARM parts for more than half a decade, largely through [gobsmacking amounts of L2/L3 cache per core](https://twitter.com/slightlylate/status/1371325558806573056?s=20). Apple's restrictions on iOS browser engine choice have made it difficult to demonstrate software parity. Safari doesn't run on Android, and Apple won't allow Chromium on iOS.

   Thankfully, the advent of M1 Macs makes it possible to remove hardware differences from comparisons. For more than a decade, Apple has been making tradeoffs and unique decisions in cache hierarchy, branch prediction, instruction set, and GPU design. Competing browser makers are just now starting to explore these differences and adapt their engines to take full advantage of them.

   As that is progressing, the results are coming back into line with the situation on Intel: Chromium is roughly as fast, and in many cases much faster, than WebKit.

   The lesson for performance analysis is, as always, that one must always double-and-triple-check to ensure you actually measure what you hope to. [↩︎](#fnref-progress-delayed-4)

5. Ten years ago, trailing-edge browsers were largely the detritus of installations that could not (or would not) upgrade. The [relentless march of auto-updates](https://twitter.com/TheRealNooshu/status/1385598013037551617?s=20) has largely removed this hurdle. The residual set of salient browser differences in 2021 is the result of some combination of:

    * Market-specific differences in browser update rates; e.g., emerging markets show several months of additional lag between browser release dates and full replacement
    * Increasingly rare enterprise scenarios in where legacy browsers persist (e.g., IE11)
    * Differences in feature support between engines

   As other effects fade away, the last one comes to the fore. Auto-updates don't do as much good as they could when the replacement for a previous version lacks features developers need. Despite outstanding OS update rates, iOS undermines the web at large by projecting the deficiencies of WebKit's leading-edge into *every browser on every iOS device*. [↩︎](#fnref-progress-delayed-5)

6. Perhaps it goes without saying, but the propensity for Firefox/Gecko to implement features with higher quality than Safari/WebKit is a major black eye for Apple.

   A scrappy Open Source project without [~$200 billion in the bank](https://www.cnbc.com/2021/01/27/apple-q1-cash-hoard-heres-how-much-apple-has-on-hand.html) is doing what the world's most valuable computing company will not: investing in browser quality and delivering a more compatible engine *across more OSes and platforms* than Apple does.

   This should be reason enough for Apple to allow Mozilla to ship Gecko on iOS. That they do not is all the more indefensible for the tax it places on web developers worldwide. [↩︎](#fnref-progress-delayed-6)

7. The data captured by [MDN Browser Compatibility Data Respository](https://developer.mozilla.org/en-US/docs/MDN/Structures/Compatibility_tables) and the [caniuse database](https://caniuse.com/) is often partial and sometimes incorrect.

   Where I was aware they were not accurate — often related to releases in which features first appeared — or where they disagreed, original sources (browser release notes, contemporaneous blogs) have been consulted to build the most accurate picture of delays.

   The presence of features in "developer previews", beta branches, or behind a flag that users must manually flip have not been taken into account. This is reasonable based on several concerns beyond the obvious: that developers cannot count on the feature when it is not fully launched, mooting any potential impact on the market:

    * Some features linger for many years behind these flags (e.g. WebGL2 in Safari).
    * Features not yet available on release branches may still change in their API shape, meaning that developers would be subject to expensive code churn and re-testing to support them in this state.
    * Browser vendors universally discourage users from enabling experimental flags manually

   [↩︎](#fnref-progress-delayed-7)
8. Competing engines led WebKit on dozens of features not included in this list because of the 3+ year lag cut-off.

   The data shows that, as a proportion of features landed in a leading vs. trailing way, it doesn't much matter which timeframe one focuses on. The proportion of leading/lagging features in WebKit remains relatively steady. One reason to omit shorter time periods is to reduce the impact of Apple's lethargic feature release schedule.

   Even when Apple's [Tech Preview](https://developer.apple.com/safari/technology-preview/) builds gain features at roughly the same time as [Edge](https://www.microsoftedgeinsider.com/en-us/welcome), [Chrome](https://www.google.com/chrome/beta/), or [Firefox's](https://www.mozilla.org/en-US/firefox/channel/desktop/) Beta builds, they may be delayed in reaching users (and therefore becoming available to developers) because of the uniquely slow way Apple introduces new features. Unlike leading engines that deliver improvements every six weeks, the pace of new features arriving in Safari is tied to Apple's twice-a-year iOS point release cadence. Prior to 2015, this lag was often as bad as a full year. Citing only features with a longer lag helps to remove the impact of such release cadence mismatch effects to the benefit of WebKit.

   It is scrupulously generous to Cupertino's case that features with a gap shorter than three years were omitted. [↩︎](#fnref-progress-delayed-8)

9. One effect of Apple's forced web engine monoculture is that, unlike other platforms, issues that affect WebKit *impact every other browser on iOS too*.

   Not only do developers suffer an unwelcome uniformity of quality issues, users are impacted negatively when security issues in WebKit create OS-wide exposure to problems that can only be repaired at the rate OS updates are applied. [↩︎](#fnref-progress-delayed-9)

10. The three-year delay in Apple implementing Pointer Events for iOS is *in addition* to delays due to Apple-generated licensing drama within the W3C regarding standardisation of various event models for touch screen input. [↩︎](#fnref-progress-delayed-10)

11. During the drafting of this post, iOS 14.5 was released and with it, Safari 14.1.

In a bit good-natured japery, Apple initially [declined to provide release notes for web platform features in the update](https://twitter.com/firt/status/1386793991165911041?s=20).

In the days that followed, [belated documentation included a shocking revelation: against all expectations, iOS 14.5 had brought WASM Threads!](/2021/04/progress-delayed/safari_14.1_wasm_thread_release_notes_cropped.png) The wait was over! WASM Threads for iOS were entirely unexpected due to the distance WebKit would need to close to add either true [Site Isolation](https://security.googleblog.com/2018/07/mitigating-spectre-with-site-isolation.html) or [new developer opt-in mechanisms to protect sensitive content from side-channel attacks on modern CPUs](https://web.dev/coop-coep/). Neither seemed within reach of WebKit this year.

The Web Assembly community was understandably excited and [began to test the claim](https://twitter.com/RReverser/status/1387874356257345543?s=20), but could not seem to make the feature work as hoped.

Soon after, Apple [updated it's docs](https://twitter.com/RReverser/status/1387884606792339458?s=20) and [provided details on what was, in fact, added](https://twitter.com/othermaciej/status/1387903432279826433?s=20). Infrastructure that will eventually be critical to a WASM Threading solution in WebKit was made available, but it's a bit like an engine on a test mount: without the rest of the car, it's beautiful engineering without the ability to take folks where they want to go.

WASM Threads for iOS had seen their shadow and six more months of waiting (minimum) are predicted. At least we'll have one over-taxed CPU core to keep us warm. [↩︎](#fnref-progress-delayed-11)

12. It's perverse that users and developers everywhere pay a tax for Apple's under-funding of Safari/WebKit development, in effect subsidising the world's wealthiest firm. [↩︎](#fnref-progress-delayed-12)

13. Safari uses a private API not available to other iOS browsers for installing web apps to the home screen.

Users who switch their browser on iOS today are, perversely, less able to make the web a more central part of their computing life, and the inability for other browsers to offer web app installation creates challenges for developers who must account for the gap and recommend users switch to Safari in order to install their web experience. [↩︎](#fnref-progress-delayed-13)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
