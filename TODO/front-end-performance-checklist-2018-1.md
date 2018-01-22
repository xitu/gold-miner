> * 原文地址：[Front-End Performance Checklist 2018 - Part 1](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2018 - Part 1

Below you’ll find an overview of the front-end performance issues you mightneed to consider to ensure that your response times are fast and smooth.

- [Front-End Performance Checklist 2018 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [Front-End Performance Checklist 2018 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [Front-End Performance Checklist 2018 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [Front-End Performance Checklist 2018 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

### Getting Ready: Planning And Metrics

Micro-optimizations are great for keeping performance on track, but it's critical to have clearly defined targets in mind — _measurable_ goals that would influence any decisions made throughout the process. There are a couple of different models, and the ones discussed below are quite opinionated — just make sure to set your own priorities early on.

1. **Establish a performance culture.**

In many organizations, front-end developers know exactly what common underlying problems are and what loading patterns should be used to fix them. However, as long as there is no alignment between dev/design and marketing teams, performance isn't going to sustain long-term. Study common complaints coming into customer service and see how improving performance can help relieve some of these common problems.

Run performance experiments and measure outcomes — both on mobile and on desktop. It will help you build up a company-tailored case study with real data. Furthermore, using data from case studies and experiments published on [WPO Stats](https://wpostats.com/) can help increase sensitivity for business about why performance matters, and what impact it has on user experience and business metrics. Stating that performance matters alone isn't enough though — you also need to establish some measurable and trackable goals and observe them.

2. **Goal: Be at least 20% faster than your fastest competitor.**

According to [psychological research](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule), if you want users to feel that your website is faster than your competitor's website, you need to be _at least_ 20% faster. Study your main competitors, collect metrics on how they perform on mobile and desktop and set thresholds that would help you outpace them. To get accurate results and goals though, first study your analytics to see what your users are on. You can then mimic the 90th percentile's experience for testing. Collect data, set up a [spreadsheet](http://danielmall.com/articles/how-to-make-a-performance-budget/), shave off 20%, and set up your goals (i.e. [performance budgets](http://bradfrost.com/blog/post/performance-budget-builder/)) this way. Now you have something measurable to test against.

If you're keeping the budget in mind and trying to ship down just the minimal script to get a quick time-to-interactive, then you're on a reasonable path. Lara Hogan's [guide on how to approach designs with a performance budget](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget) can provide helpful pointers to designers and both [Performance Budget Calculator](http://www.performancebudget.io/) and [Browser Calories](https://browserdiet.com/calories/) can aid in creating budgets (thanks to [Karolina Szczur](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) for the heads up).

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_2000/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/231e97c1-4bfa-4dff-85a7-93e0a16b2690/performance-budget-lbp9l7-c-scalew-862-opt.png)

Beyond performance budgets, think about critical customer tasks that are most beneficial to your business. Set and discuss acceptable **time thresholds for critical actions** and establish "UX ready" user timing marks that the entire organization has agreed on. In many cases, user journeys will touch on the work of many different departments, so alignment in terms of acceptable timings will help support or prevent performance discussions down the road. Make sure that additional costs of added resources and features are visible and understood.

Also, as Patrick Meenan suggested, it's worth to **plan out a loading sequence and trade-offs** during the design process. If you prioritize early on which parts are more critical, and define the order in which they should appear, you will also know what can be delayed. Ideally, that order will also reflect the sequence of your CSS and JavaScript imports, so handling them during the build process will be easier. Also, consider what the visual experience should be in "in-between"-states, while the page is being loaded (e.g. when web fonts aren't loaded yet).

Planning, planning, planning. It might be tempting to get into quick "low-hanging-fruits"-optimizations early on — and eventually it might be a good strategy for quick wins — but it will be very hard to keep performance a priority without planning and realistic, company-tailored performance goals.

3. **Choose the right metrics.**

[Not all metrics are equally important](https://speedcurve.com/blog/rendering-metrics/). Study what metrics matter most to your application: usually it will be related to how fast you can start render _most important_ pixels (and what they are) and how quickly you can provide input responsiveness for these rendered pixels. This knowledge will give you the best optimization target for ongoing efforts. One way or another, rather than focusing on full page loading time (via _onLoad_ and _DOMContentLoaded_ timings, for example), prioritize page loading as perceived by your customers. That means focusing on a slightly [different set of metrics](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33). In fact, choosing the right metric is a process without obvious winners.

<figure class="video-container break-out"><iframe src="https://player.vimeo.com/video/249524245" width="640" height="358" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

The difference between First Paint, First Contentful Paint, First Meaningful Paint, Visual Complete and Time To Interactive. [Large view](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33). Credit: [@denar90](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)

Below are some of the metrics worth considering:

* _First Meaningful Paint_ (FMP, when primary content appears on the page),
* _[Hero Rendering Times](https://speedcurve.com/blog/web-performance-monitoring-hero-times/)_ (when the page's important content has finished rendering),
* _Time to Interactive_ (TTI, the point at which layout has stabilized, key webfonts are visible, and the main thread is available enough to handle user input — basically the time mark when a user can tap on UI and interact with it),
* _Input responsiveness_ (how much time it takes for an interface to respond to user's action),
* _Perceptual Speed Index_ (measures how quickly the page contents are visually populated; the lower the score, the better),
* Your [custom metrics](https://speedcurve.com/blog/user-timing-and-custom-metrics/), as defined by your business needs and customer experience.

Steve Souders has a [detailed explanation of each metrics](https://speedcurve.com/blog/rendering-metrics/). While in many cases TTI and Input responsiveness will be most critical, depending on the context of your application, these metrics might differ: e.g. for Netflix TV UI, [key input responsiveness, memory usage and TTI](https://medium.com/netflix-techblog/crafting-a-high-performance-tv-user-interface-using-react-3350e5a6ad3b) are more critical.

4. **Gather data on a device representative of your audience.**

To gather accurate data, we need to thoroughly choose devices to test on. It's a good option to choose a Moto G4, a mid-range Samsung device and a good middle-of-the-road device like a Nexus 5X, perhaps in an [open device lab](https://www.smashingmagazine.com/2016/11/worlds-best-open-device-labs/). If you don't have a device at hand, emulate mobile experience on desktop by testing on a throttled network (e.g. 150ms RTT, 1.5 Mbps down, 0.7 Mbps up) with a throttled CPU (5× slowdown). Eventually switch over to regular 3G, 4G and Wi-Fi. To make the performance impact more visible, you could even introduce [2G Tuesdays](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world) or set up a [throttled 3G network in your office](https://twitter.com/thommaskelly/status/938127039403610112) for faster testing.

[![Introducing the slowest day of the week](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dfe1a4ec-2088-4e39-8a39-9f2010380a53/tuesday-2g-opt.png)](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)

Introducing the slowest day of the week. Facebook has introduced [2G Tuesdays](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world) to increase visibility and sensitivity of slow connections. ([Image source](http://www.businessinsider.com/facebook-2g-tuesdays-to-slow-employee-internet-speeds-down-2015-10?IR=T))

Luckily, there are many great options that help you automate the collection of data and measure how your website performs over time according to these metrics. Keep in mind that a good performance metrics is a combination of passive and active monitoring tools:

* **Passive monitoring tools** that simulate user interaction on request (_synthetic testing_, e.g. _Lighthouse_, _WebPageTest_) and
* **Active monitoring tools** that record and evaluate user interactions continuously (_Real User Monitoring_, e.g. _SpeedCurve_, _New Relic_ — both tools provide synthetic testing, too).

The former is particularly useful during development as it will help you stay on track while working on the product. The latter is useful for long-term maintenance as it will help you understand your performance bottlenecks as they are happening live — when users actually access the site. By tapping into built-in RUM APIs such as Navigation Timing, Resource Timing, Paint Timing, Long Tasks, etc., both passive and active performance monitoring tools together provide a complete picture of performance in your application. For instance, you could use [PWMetrics](https://github.com/paulirish/pwmetrics), [Calibre](https://calibreapp.com), [SpeedCurve](https://speedcurve.com/), [mPulse](https://www.soasta.com/performance-monitoring/) and [Boomerang](https://github.com/yahoo/boomerang), [Sitespeed.io](https://www-origin.sitespeed.io/), which all are fantastic options for performance monitoring.

_Note_: It's always a safer bet to choose network-level throttlers, external to the browser, as, for example, DevTools has issues interacting with HTTP/2 push, due to the way it's implemented (_thanks, Yoav!_).

[![Lighthouse](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d829af6f-23ff-432c-9659-bd6f3c13678f/lighthouse-shop-polymer-opt.png)](https://developers.google.com/web/tools/lighthouse/)

[Lighthouse](https://developers.google.com/web/tools/lighthouse/), a performance auditing tool integrated into DevTools.

5. **Share the checklist with your colleagues.**

Make sure that the checklist is familiar to every member of your team to avoid misunderstandings down the line. Every decision has performance implications, and the project would hugely benefit from front-end developers properly communicating performance values to the whole team, so that everybody would feel responsibility for it, not just front-end developers. Map design decisions against performance budget and the priorities defined in the checklist.

[![RAIL](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c91c910d-e934-4610-9dc5-369ec9071b57/rail-perf-model-opt.png)](https://developers.google.com/web/fundamentals/performance/rail)

[RAIL](https://developers.google.com/web/fundamentals/performance/rail), a user-centric performance model.

### Setting Realistic Goals

6. **100-millisecond response time, 60 fps.**

For an interaction to feel smooth, the interface has 100ms to respond to user's input. Any longer than that, and the user perceives the app as laggy. The [RAIL, a user-centered performance model](https://www.smashingmagazine.com/2015/10/rail-user-centric-model-performance/) gives you healthy targets: To allow for <100 milliseconds response, the page must yield control back to main thread at latest after every <50 milliseconds. [Estimated Input Latency](https://developers.google.com/web/tools/lighthouse/audits/estimated-input-latency) tells us if we are hitting that threshold, and ideally, it should be below 50ms. For high pressure points like animation, it's best to do nothing else where you can and the absolute minimum where you can't.

Also, each frame of animation should be completed in less than 16 milliseconds, thereby achieving 60 frames per second (1 second ÷ 60 = 16.6 milliseconds) — preferably under 10 milliseconds. Because the browser needs time to paint the new frame to the screen your code should finish executing before hitting the 16.6 milliseconds mark. [Be optimistic](https://www.smashingmagazine.com/2016/11/true-lies-of-optimistic-user-interfaces/) and use idle time wisely. Obviously, these targets apply to runtime performance, rather than loading performance.

7. **SpeedIndex < 1250, TTI < 5s on 3G, Critical file size budget < 170Kb.**

Although it might be very difficult to achieve, a good ultimate goal would be First Meaningful Paint under 1 second and a [SpeedIndex](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) value under 1250\. Considering the baseline being a $200 Android phone (e.g. Moto G4) on a slow 3G network, emulated at 400ms RTT and 400kbps transfer speed, aim for [Time to Interactive under 5s](https://www.youtube.com/watch?v=_srJ7eHS3IM&feature=youtu.be&t=6m21s), and for repeat visits, aim for under 2s.

Notice that, when speaking about _Time To Interactive_, it's a good idea to distinguish between [First Interactive and Consistency Interactive](https://calendar.perfplanet.com/2017/time-to-interactive-measuring-more-of-the-user-experience/) to avoid misunderstandings down the line. The former is the earliest point after the main content has rendered (where there is at least a 5-second window where the page is responsive). The latter is the point where the page can be expected to always be responsive to input.

The first 14~15Kb of the HTML is the **most critical payload chunk** — and the only part of the budget that can be delivered in the first roundtrip (which is all you get in 1 second at 400ms RTT). In more general terms, to achieve the goals stated above, we have have to operate within a critical file size [budget of max. 170Kb gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (0.8-1MB decompressed) which already would take up to 1s (depending on the resource type) to parse and compile on an average phone. Being slightly above that is fine, but push to get these values as low as possible.

You could also go beyond bundle size budget though. For example, you could set performance budgets on the activities of the browser's main thread, i.e. paint time before start render, or [track down front-end CPU hogs](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/). Tools such as [Calibre](https://calibreapp.com/), [SpeedCurve](https://speedcurve.com/) and [Bundlesize](https://github.com/siddharthkp/bundlesize) can help you keep your budgets in check, and can be integrated into your build process.

[![From 'Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/3bb4ab9e-978a-4db0-83c3-57a93d70516d/file-size-budget-fast-default-addy-osmani-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

[From Fast By Default: Modern loading best practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani (Slide 19)

### Defining The Environment

8. **Choose and set up your build tools.**

[Don't pay too much attention to what's supposedly cool](https://24ways.org/2017/all-that-glisters/) these days. Stick to your environment for building, be it Grunt, Gulp, Webpack, Parcel, or a combination of tools. As long as you are getting results you need fast and you have no issues maintaining your build process, you're doing just fine.

9. **Progressive enhancement.**

Keeping [progressive enhancement](https://www.aaron-gustafson.com/notebook/insert-clickbait-headline-about-progressive-enhancement-here/) as the guiding principle of your front-end architecture and deployment is a safe bet. Design and build the core experience first, and then enhance the experience with advanced features for capable browsers, creating [resilient](https://resilientwebdesign.com/) experiences. If your website runs fast on a slow machine with a poor screen in a poor browser on a suboptimal network, then it will only run faster on a fast machine with a good browser on a decent network.

10. **Choose a strong performance baseline.**

With so many unknowns impacting loading — the network, thermal throttling, cache eviction, third-party scripts, parser blocking patterns, disk I/O, IPC jank, installed extensions, CPU, hardware and memory constraints, differences in L2/L3 caching, RTTS, images, web fonts loading behavior — [JavaScript has the heaviest cost of the experience](https://youtu.be/_srJ7eHS3IM?t=3m2s), next to web fonts blocking rendering by default and images often consuming too much memory. With the performance bottlenecks [moving away from the server to the client](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/), as developers, we have to consider all of these unknowns in much more detail.

With a 170KB budget that already contains the critical-path HTML/CSS/JavaScript, router, state management, utilities, framework and the application logic, we have to thoroughly [examine network transfer cost, the parse/compile time and the runtime cost](https://www.twitter.com/kristoferbaxter/status/908144931125858304) of the framework of our choice.

[!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/39c247a9-223f-4a6c-ae3d-db54a696ffcb/tti-budget-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani (Slides 18, 19).

As [noted](https://twitter.com/sebmarkbage/status/829733454119989248) by Seb Markbåge, a good way to measure start-up costs for frameworks is to first render a view, then delete it and then render again as it can tell you how the framework scales.

The first render tends to warm up a bunch of lazily compiled code, which a larger tree can benefit from when it scales. The second render is basically an emulation of how code reuse on a page affects the performance characteristics as the page grows in complexity.

[Not every project needs a framework](https://twitter.com/jaffathecake/status/923805333268639744). In fact, some projects can [benefit from removing an existing framework](https://twitter.com/jaffathecake/status/925320026411950080) altogether. Once a framework is chosen, you'll be staying with it for at least a few years, so if you need to use one, make sure your choice [is informed](https://www.youtube.com/watch?v=6I_GwgoGm1w) and [well considered](https://medium.com/@ZombieCodeKill/choosing-a-javascript-framework-535745d0ab90#.2op7rjakk). It's a good idea to consider _at least_ the total cost on size + initial parse times before choosing an option; lightweight options such as [Preact](https://github.com/developit/preact), [Inferno](https://github.com/infernojs/inferno), [Vue](https://vuejs.org/), [Svelte](https://svelte.technology/) or [Polymer](https://github.com/Polymer/polymer) can get the job done just fine. The size of your baseline will define the constraints for your application's code.

[![JavaScript parsing costs can differ significantly](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8a36eef0-083f-4652-9814-95ffe7848982/parse-costs-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

JavaScript parsing costs can differ significantly. From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani (Slide 10).

Keep in mind that on a mobile device, you should be expecting a 4×–5× slowdown compared to desktop machines. Mobile devices have different GPUs, CPU, different memory, different battery characteristics. Parse times on mobile [are 36% higher than on desktop](https://github.com/GoogleChromeLabs/discovery/issues/1). So always [test on an average device](https://www.webpagetest.org/easy-load) — a device that is most representative of your audience.

Different frameworks will have different effects on performance and will require different strategies of optimization, so you have to clearly understand all of the nuts and bolts of the framework you'll be relying on. When building a web app, look into the [PRPL pattern](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) and [application shell architecture](https://developers.google.com/web/updates/2015/11/app-shell). The idea is quite straightforward: Push the minimal code needed to get interactive for the initial route to render quickly, then use service worker for caching and pre-caching resources and then lazy-load routes that you need, asynchronously.

[![PRPL Pattern in the application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bb4716e5-d25b-4b80-b468-f28d07bae685/app-build-components-dibweb-c-scalew-879-opt.png)](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)

[PRPL](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) stands for Pushing critical resource, Rendering initial route, Pre-caching remaining routes and Lazy-loading remaining routes on demand.

[![Application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6423db84-4717-4aeb-9174-7ae96bf4f3aa/appshell-1-o0t8qd-c-scalew-799-opt.jpg)](https://developers.google.com/web/updates/2015/11/app-shell)

An [application shell](https://developers.google.com/web/updates/2015/11/app-shell) is the minimal HTML, CSS, and JavaScript powering a user interface.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
