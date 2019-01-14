> * 原文地址：[Front-End Performance Checklist 2019 — 1](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 1

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

![](https://d33wubrfki0l68.cloudfront.net/07bab6a876338626943c46d654f45aabe7e0e807/47054/images/drop-caps/w.svg) ![](https://d33wubrfki0l68.cloudfront.net/af7798a3ff2553a4ee42f928f6cb9addbfc6de6f/0f7b2/images/drop-caps/character-15.svg) **Web performance is a tricky beast, isn’t it? How do we actually** know where we stand in terms of performance, and what our performance bottlenecks _exactly_ are? Is it expensive JavaScript, slow web font delivery, heavy images, or sluggish rendering? Is it worth exploring tree-shaking, scope hoisting, code-splitting, and all the fancy loading patterns with intersection observer, server push, clients hints, HTTP/2, service workers and — oh my — edge workers? And, most importantly, **where do we even start improving performance** and how do we establish a performance culture long-term?

Back in the day, performance was often a mere _afterthought_. Often deferred till the very end of the project, it would boil down to minification, concatenation, asset optimization and potentially a few fine adjustments on the server’s `config` file. Looking back now, things seem to have changed quite significantly.

Performance isn’t just a technical concern: it matters, and when baking it into the workflow, design decisions have to be informed by their performance implications. **Performance has to be measured, monitored and refined continually**, and the growing complexity of the web poses new challenges that make it hard to keep track of metrics, because metrics will vary significantly depending on the device, browser, protocol, network type and latency (CDNs, ISPs, caches, proxies, firewalls, load balancers and servers all play a role in performance).

So, if we created an overview of all the things we have to keep in mind when improving performance — from the very start of the process until the final release of the website — what would that list look like? Below you’ll find a (hopefully unbiased and objective) **front-end performance checklist for 2019** — an updated overview of the issues you might need to consider to ensure that your response times are fast, user interaction is smooth and your sites don’t drain user’s bandwidth.

> **[译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)**
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### Table Of Contents

- [Getting Ready: Planning And Metrics](#getting-ready-planning-and-metrics)
  - [1. Establish a performance culture](#1-establish-a-performance-culture)
  - [2. Goal: Be at least 20% faster than your fastest competitor](#2-goal-be-at-least-20-faster-than-your-fastest-competitor)
  - [3. Choose the right metrics](#3-choose-the-right-metrics)
  - [4. Gather data on a device representative of your audience](#4-gather-data-on-a-device-representative-of-your-audience)
  - [5. Set up "clean" and "customer" profiles for testing](#5-set-up-%22clean%22-and-%22customer%22-profiles-for-testing)
  - [6. Share the checklist with your colleagues.](#6-share-the-checklist-with-your-colleagues)

### Getting Ready: Planning And Metrics

Micro-optimizations are great for keeping performance on track, but it’s critical to have clearly defined targets in mind — _measurable_ goals that would influence any decisions made throughout the process. There are a couple of different models, and the ones discussed below are quite opinionated — just make sure to set your own priorities early on.

#### 1. Establish a performance culture

In many organizations, front-end developers know exactly what common underlying problems are and what loading patterns should be used to fix them. However, as long as there is no established endorsement of the performance culture, each decision will turn into a battlefield of departments, breaking up the organization into silos. You need a business stakeholder buy-in, and to get it, you need to establish a case study on how speed benefits metrics and Key Performance Indicators (_KPIs_) they care about.

Without a strong alignment between dev/design and business/marketing teams, performance isn’t going to sustain long-term. Study common complaints coming into customer service and see how improving performance can help relieve some of these common problems.

Run performance experiments and measure outcomes — both on mobile and on desktop. It will help you build up a company-tailored case study with real data. Furthermore, using data from case studies and experiments published on [WPO Stats](https://wpostats.com/) will help increase sensitivity for business about why performance matters, and what impact it has on user experience and business metrics. Stating that performance matters alone isn’t enough though — you also need to establish some measurable and trackable goals and observe them.

How to get there? In her talk on [Building Performance for the Long Term](https://vimeo.com/album/4970467/video/254947097), Allison McKnight shares a comprehensive case-study of how she helped establish a performance culture at Etsy ([slides](https://speakerdeck.com/aemcknig/building-performance-for-the-long-term)).

[![Brad Frost and Jonathan Fielding’s Performance Budget Calculator](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7191d628-f0a1-490c-afca-c8abcdfd4823/brad-perf-budget-builder.png)](http://bradfrost.com/blog/post/performance-budget-builder/) 

[Performance budget builder](http://bradfrost.com/blog/post/performance-budget-builder/) by Brad Frost and Jonathan Fielding’s [Performance Budget Calculator](http://www.performancebudget.io/) can help you set up your performance budget and visualize it. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7191d628-f0a1-490c-afca-c8abcdfd4823/brad-perf-budget-builder.png))

#### 2. Goal: Be at least 20% faster than your fastest competitor

According to [psychological research](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule), if you want users to feel that your website is faster than your competitor’s website, you need to be _at least_ 20% faster. Study your main competitors, collect metrics on how they perform on mobile and desktop and set thresholds that would help you outpace them. To get accurate results and goals though, first study your analytics to see what your users are on. You can then mimic the 90th percentile’s experience for testing.
    
To get a good first impression of how your competitors perform, you can [use Chrome UX Report](https://web.dev/fast/chrome-ux-report) (_CrUX_, a ready-made RUM data set, [video introduction](https://vimeo.com/254834890) by Ilya Grigorik), [Speed Scorecard](https://www.thinkwithgoogle.com/feature/mobile/) (also provides a revenue impact estimator), [Real User Experience Test Comparison](https://ruxt.dexecure.com/compare) or [SiteSpeed CI](https://www.sitespeed.io/) (based on synthetic testing).

**Note**: If you use [Page Speed Insights](https://developers.google.com/speed/pagespeed/insights/) (no, it isn’t deprecated), you can get CrUX performance data for specific pages instead of just the aggregates. This data can be much more useful for setting performance targets for assets like “landing page” or “product listing”. And if you are using CI to test the budgets, you need to make sure your tested environment matches CrUX if you used CrUX for setting the target (_thanks Patrick Meenan!_).

Collect data, set up a [spreadsheet](http://danielmall.com/articles/how-to-make-a-performance-budget/), shave off 20%, and set up your goals (_performance budgets_) this way. Now you have something measurable to test against. If you’re keeping the budget in mind and trying to ship down just the minimal script to get a quick time-to-interactive, then you’re on a reasonable path.

Need resources to get started?

*   Addy Osmani has written a very detailed write-up on [how to start performance budgeting](https://medium.com/@addyosmani/start-performance-budgeting-dabde04cf6a3), how to quantify the impact of new features and where to start when you are over budget.

*   Lara Hogan’s [guide on how to approach designs with a performance budget](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget) can provide helpful pointers to designers.

*   Jonathan Fielding’s [Performance Budget Calculator](http://www.performancebudget.io/), Brad Frost’s [Performance Budget Builder](https://codepen.io/bradfrost/full/EPQVBp/) and [Browser Calories](https://browserdiet.com/calories/) can aid in creating budgets (thanks to [Karolina Szczur](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) for the heads up).

*   Also, make both performance budget and current performance _visible_ by setting up dashboards with graphs reporting build sizes. There are many tools allowing you to achieve that: [SiteSpeed.io dashboard](https://www.peterhedenskog.com/blog/2015/04/open-source-performance-dashboard/) (open source), [SpeedCurve](http://speedcurve.com/) and [Calibre](https://calibreapp.com/) are just a few of them, and you can find more tools on [perf.rocks](http://perf.rocks/tools/).

Once you have a budget in place, incorporate them into your build process [with Webpack Performance Hints and Bundlesize](https://web.dev/fast/incorporate-performance-budgets-into-your-build-tools), [Lightouse CI](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget), [PWMetrics](https://github.com/paulirish/pwmetrics) or [Sitespeed CI](https://www.sitespeed.io/) to enforce budgets on pull requests and provide a score history in PR comments. If you need something custom, you can use [webpagetest-charts-api](https://github.com/trulia/webpagetest-charts-api), an API of endpoints to build charts from WebPagetest results.

For instance, just like [Pinterest](https://medium.com/@Pinterest_Engineering/a-one-year-pwa-retrospective-f4a2f4129e05), you could create a custom _eslint_ rule that disallows importing from files and directories that are known to be dependency-heavy and would bloat the bundle. Set up a listing of “safe” packages that can be shared across the entire team.

Beyond performance budgets, think about critical customer tasks that are most beneficial to your business. Set and discuss acceptable **time thresholds for critical actions** and establish "UX ready" user timing marks that the entire organization has agreed on. In many cases, user journeys will touch on the work of many different departments, so alignment in terms of acceptable timings will help support or prevent performance discussions down the road. Make sure that additional costs of added resources and features are visible and understood.

Also, as Patrick Meenan suggested, it’s worth to **plan out a loading sequence and trade-offs** during the design process. If you prioritize early on which parts are more critical, and define the order in which they should appear, you will also know what can be delayed. Ideally, that order will also reflect the sequence of your CSS and JavaScript imports, so handling them during the build process will be easier. Also, consider what the visual experience should be in "in-between"-states, while the page is being loaded (e.g. when web fonts aren’t loaded yet).

_Planning, planning, planning._ It might be tempting to get into quick "low-hanging-fruits"-optimizations early on — and eventually it might be a good strategy for quick wins — but it will be very hard to keep performance a priority without planning and setting realistic, company-tailored performance goals.

The difference between First Paint, First Contentful Paint, First Meaningful Paint, Visual Complete and Time To Interactive. [Large view](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33). Credit: [@denar90](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)

#### 3. Choose the right metrics

[Not all metrics are equally important](https://speedcurve.com/blog/rendering-metrics/). Study what metrics matter most to your application: usually it will be related to how fast you can start render _most important pixels of your product_ and how quickly you can provide input responsiveness for these rendered pixels. This knowledge will give you the best optimization target for ongoing efforts.

One way or another, rather than focusing on full page loading time (via _onLoad_ and _DOMContentLoaded_ timings, for example), prioritize page loading as perceived by your customers. That means focusing on a slightly different set of metrics. In fact, choosing the right metric is a process without obvious winners.

Based on Tim Kadlec’s research and Marcos Iglesias’ notes in [his talk](https://docs.google.com/presentation/d/e/2PACX-1vTk8geAszRTDisSIplT02CacJybNtrr6kIYUCjW3-Y_7U9kYSjn_6TbabEQDnk9Ao8DX9IttL-RD_p7/pub?start=false&loop=false&delayms=10000&slide=id.g3ccc19d32d_0_98), traditional metrics could be grouped into a few sets. Usually, we’ll need all of them to get a complete picture of performance, and in your particular case some of them might be more important than others.

*   _Quantity-based metrics_ measure the number of requests, weight and a performance score. Good for raising alarms and monitoring changes over time, not so good for understanding user experience.

*   _Milestone metrics_ use states in the lifetime of the loading process, e.g. _Time To First Byte_ and _Time To Interactive_. Good for describing the user experience and monitoring, not so good for knowing what happens between the milestones.

*   _Rendering metrics_ provide an estimate of how fast content renders (e.g. _Start Render_ time, _Speed Index_). Good for measuring and tweaking rendering performance, but not so good for measuring when _important_ content appears and can be interacted with.

*   _Custom metrics_ measure a particular, custom event for the user, e.g. Twitter’s [Time To First Tweet](https://blog.alexmaccaw.com/time-to-first-tweet) and Pinterest’s [PinnerWaitTime](https://medium.com/@Pinterest_Engineering/driving-user-growth-with-performance-improvements-cfc50dafadd7). Good for describing the user experience precisely, not so good for scaling the metrics and comparing with with competitors.

To complete the picture, we’d usually look out for useful metrics among all of these groups. Usually, the most specific and relevant ones are:

*   [First Meaningful Paint](https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint) _(FMP)_  
    
    Provides the timing when primary content appears on the page, providing an insight into how quickly the server outputs _any_ data. Long FMP usually indicates JavaScript blocking the main thread, but could be related to back-end/server issues as well.

*   [Time to Interactive](https://calibreapp.com/blog/time-to-interactive/) _(TTI)_  
    
    The point at which layout has stabilized, key webfonts are visible, and the main thread is available enough to handle user input — basically the time mark when a user can interact with the UI. The key metrics for understanding how much _wait_ a user has to experience to use the site without a lag.

*   [First Input Delay](https://developers.google.com/web/updates/2018/05/first-input-delay) _(FID)_, or _Input responsiveness_  
    
    The time from when a user first interacts with your site to the time when the browser is actually able to respond to that interaction. Complements TTI very well as it describes the missing part of the picture: what happens when a user actually interacts with the site. Intended as a RUM metric only. There is a [JavaScript library](https://github.com/GoogleChromeLabs/first-input-delay) for measuring FID in the browser.

*   [Speed Index](https://dev.to/borisschapira/web-performance-fundamentals-what-is-the-speed-index-2m5i)  
    
    Measures how quickly the page contents are visually populated; the lower the score, the better. The Speed Index score is computed based on the speed of visual progress, but it’s merely a computed value. It’s also sensitive to the viewport size, so you need to define a range of testing configurations that match your target audience (_thanks, [Boris](https://twitter.com/borisschapira)!_).

*   CPU time spent  
    
    A metric that indicates how busy is the main thread with the processing of the payload. It shows how often and how long the main thread is blocked, working on painting, rendering, scripting and loading. High CPU time is a clear indicator of a _janky_ experience, i.e. when the user experiences a noticeable lag between their action and a response. With WebPageTest, you can [select "Capture Dev Tools Timeline" on the "Chrome" tab](https://deanhume.com/ten-things-you-didnt-know-about-webpagetest-org/) to expose the breakdown of the main thread as it runs on any device using WebPageTest.

*   [Ad Weight Impact](https://calendar.perfplanet.com/2017/measuring-adweight/)  
    
    If your site depends on the revenue generated by advertising, it’s useful to track the weight of ad related code. Paddy Ganti’s [script](https://calendar.perfplanet.com/2017/measuring-adweight/) constructs two URLs (one normal and one blocking the ads), prompts the generation of a video comparison via WebPageTest and reports a delta.

*   Deviation metrics  
    
    As [noted by Wikipedia engineers](https://phabricator.wikimedia.org/phame/live/7/post/117/performance_testing_in_a_controlled_lab_environment_-_the_metrics/), data of how much variance exists in your results could inform you how reliable your instruments are, and how much attention you should pay to deviations and outlers. Large variance is an indicator of adjustments needed in the setup. It also helps understand if certain pages are more difficult to measure reliably, e.g. due to third-party scripts causing significant variation. It might also be a good idea to track browser version to understand bumps in performance when a new browser version is rolled out.

*   [Custom metrics](https://speedcurve.com/blog/user-timing-and-custom-metrics/)  
    
    Custom metrics are defined by your business needs and customer experience. It requires you to identify _important_ pixels, _critical_ scripts, _necessary_ CSS and _relevant_ assets and measure how quickly they get delivered to the user. For that one, you can monitor [Hero Rendering Times](https://speedcurve.com/blog/web-performance-monitoring-hero-times/), or use [Performance API](https://css-tricks.com/breaking-performance-api/), marking particular timestaps for events that are important for your business. Also, you can [collect custom metrics with WebPagetest](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/custom-metrics) by executing arbitrary JavaScript at the end of a test.

Steve Souders has a [detailed explanation of each metric](https://speedcurve.com/blog/rendering-metrics/). It’s important to notice that while Time-To-Interactive is measured by running automated audits in the so-called _lab environment_, First Input Delay represents the _actual_ user experience, with _actual_ users experiencing a noticeable lag. In general, it’s probably a good idea to always measure and track both of them.

Depending on the context of your application, preferred metrics might differ: e.g. for Netflix TV UI, [key input responsiveness, memory usage and TTI](https://medium.com/netflix-techblog/crafting-a-high-performance-tv-user-interface-using-react-3350e5a6ad3b) are more critical, and for Wikipedia, [first/last visual changes and CPU time spent metrics](https://phabricator.wikimedia.org/phame/live/7/post/117/performance_testing_in_a_controlled_lab_environment_-_the_metrics/) are more important.

**Note**: both FID and TTI do not account for scrolling behavior; scrolling can happen independently since it’s off-main-thread, so for many content consumption sites these metrics might be much less important (_thanks, Patrick!_).

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5d80f91c-9807-4565-b616-a4735fcd4949/network-requests-first-input-delay.png)](https://twitter.com/__treo/status/1068163152783835136) 

User-centric performance metrics provide a better insight into the actual user experience. [First Input Delay](https://developers.google.com/web/updates/2018/05/first-input-delay) (FID) is a new metric that tries to achieve just that. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5d80f91c-9807-4565-b616-a4735fcd4949/network-requests-first-input-delay.png))

#### 4. Gather data on a device representative of your audience

To gather accurate data, we need to thoroughly choose devices to test on. It’s a good option to [choose a Moto G4](https://twitter.com/katiehempenius/statuses/1067969800205422593), a mid-range Samsung device, a good middle-of-the-road device like a Nexus 5X and a slow device like Alcatel 1X, perhaps in an [open device lab](https://www.smashingmagazine.com/2016/11/worlds-best-open-device-labs/). For testing on slower thermal-throttled devices, you could also get a Nexus 2, which costs just around $100.

If you don’t have a device at hand, emulate mobile experience on desktop by testing on a throttled network (e.g. 150ms RTT, 1.5 Mbps down, 0.7 Mbps up) with a throttled CPU (5× slowdown). Eventually switch over to regular 3G, 4G and Wi-Fi. To make the performance impact more visible, you could even introduce [2G Tuesdays](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world) or set up a [throttled 3G network in your office](https://twitter.com/thommaskelly/status/938127039403610112) for faster testing.

Keep in mind that on a mobile device, you should be expecting a 4×–5× slowdown compared to desktop machines. Mobile devices have different GPUs, CPU, different memory, different battery characteristics. While download times are critical for low-end networks, parse times are critical for phones with slow CPUs. In fact, parse times on mobile [are 36% higher than on desktop](https://github.com/GoogleChromeLabs/discovery/issues/1). So always [test on an average device](https://www.webpagetest.org/easy) — a device that is most representative of your audience.

[![Introducing the slowest day of the week](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dfe1a4ec-2088-4e39-8a39-9f2010380a53/tuesday-2g-opt.png)](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)

Introducing the slowest day of the week. Facebook has introduced [2G Tuesdays](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world) to increase visibility and sensitivity of slow connections. ([Image source](http://www.businessinsider.com/facebook-2g-tuesdays-to-slow-employee-internet-speeds-down-2015-10?IR=T))

Luckily, there are many great options that help you automate the collection of data and measure how your website performs over time according to these metrics. Keep in mind that a good performance picture covers a set of performance metrics, [lab data and field data](https://developers.google.com/web/fundamentals/performance/speed-tools/):

*   **Synthetic testing tools** collect _lab data_ in a reproducible environment with predefined device and network settings (e.g. _Lighthouse_, _WebPageTest_) and
*   **Real User Monitoring** (_RUM_) tools evaluate user interactions continuously and collect _field data_ (e.g. _SpeedCurve_, _New Relic_ — both tools provide synthetic testing, too).

The former is particularly useful during _development_ as it will help you identify, isolate and fix performance issues while working on the product. The latter is useful for long-term _maintenance_ as it will help you understand your performance bottlenecks as they are happening live — when users actually access the site.

By tapping into built-in RUM APIs such as [Navigation Timing](https://developer.mozilla.org/en-US/docs/Web/API/Navigation_timing_API), [Resource Timing](https://developer.mozilla.org/en-US/docs/Web/API/Resource_Timing_API), [Paint Timing](https://css-tricks.com/paint-timing-api/), [Long Tasks](https://w3c.github.io/longtasks/), etc., synthetic testing tools and RUM together provide a complete picture of performance in your application. You could use [PWMetrics](https://github.com/paulirish/pwmetrics), [Calibre](https://calibreapp.com), [SpeedCurve](https://speedcurve.com/), [mPulse](https://www.soasta.com/performance-monitoring/) and [Boomerang](https://github.com/yahoo/boomerang), [Sitespeed.io](https://www.sitespeed.io/), which all are great options for performance monitoring. Furthermore, with [Server Timing header](https://www.smashingmagazine.com/2018/10/performance-server-timing/), you could even monitor back-end and front-end performance all in one place.

**Note**: It’s always a safer bet to choose [network-level throttlers](https://calendar.perfplanet.com/2016/testing-with-realistic-networking-conditions/), external to the browser, as, for example, DevTools has issues interacting with HTTP/2 push, due to the way it’s implemented (thanks, Yoav, Patrick!). For Mac OS, we can use [Network Link Conditioner](https://nshipster.com/network-link-conditioner/), for Windows [Windows Traffic Shaper](https://github.com/WPO-Foundation/win-shaper/releases), for Linux [netem](https://wiki.linuxfoundation.org/networking/netem), and for FreeBSD [dummynet](http://info.iet.unipi.it/~luigi/dummynet/).

[![Lighthouse](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a85a91a7-fb37-4596-8658-a40c1900a0d6/lighthouse-screenshot.png)](https://developers.google.com/web/tools/lighthouse/) 

[Lighthouse](https://developers.google.com/web/tools/lighthouse/), a performance auditing tool integrated into DevTools. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a85a91a7-fb37-4596-8658-a40c1900a0d6/lighthouse-screenshot.png))

#### 5. Set up "clean" and "customer" profiles for testing

While running tests in passive monitoring tools, it’s a common strategy to turn off anti-virus and background CPU tasks, remove background bandwidth transfers and test with a clean user profile without browser extensions to avoid skewed results ([Firefox](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Multiple_profiles), [Chrome](https://support.google.com/chrome/answer/2364824?hl=en&co=GENIE.Platform=Desktop)).

However, it’s also a good idea to study which extensions your customers are using frequently, and test with a dedicated _"customer" profile_ as well. In fact, some extensions might have a [profound performance impact](https://twitter.com/denar90_/statuses/1065712688037277696) on your application, and if your users use them a lot, you might want to account for it up front. "Clean" profile results alone are overly optimistic and can be crushed in real-life scenarios.

#### 6. Share the checklist with your colleagues.

Make sure that the checklist is familiar to every member of your team to avoid misunderstandings down the line. Every decision has performance implications, and the project would hugely benefit from front-end developers properly communicating performance values to the whole team, so that everybody would feel responsible for it, not just front-end developers. Map design decisions against performance budget and the priorities defined in the checklist.

> **[译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)**
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
