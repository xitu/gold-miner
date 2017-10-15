
> * 原文地址：[Performance metrics. What’s this all about?](https://codeburst.io/performance-metrics-whats-this-all-about-1128461ad6b)
> * 原文作者：[Artem Denysov](https://codeburst.io/@denar90?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/performance-metrics-whats-this-all-about.md](https://github.com/xitu/gold-miner/blob/master/TODO/performance-metrics-whats-this-all-about.md)
> * 译者：
> * 校对者：

# Performance metrics. What’s this all about?

![](https://cdn-images-1.medium.com/max/1000/1*hT4ixOXHZ8KRZ3YfbpAxbg.png)

Measuring performance of page loading is a hard task. Hence [Google Developers](https://medium.com/@googledevs) together with the community are working on Progressive Web Metrics (PWM’s).

What are PWM’s and why do we need them?

A bit history of browser metrics.

A while ago we had 2 main points (events) for measuring performance:

`DOMContentLoaded` — fired when page is loaded but scripts just started to be executed.

`load` event which is fired then a page is fully loaded and a user can engage with either page or application.

If we take a look, as example, at [timeline trace of reddit.com](https://chromedevtools.github.io/timeline-viewer/?loadTimelineFromURL=drive://0ByCYpYcHF12_YjBGUTlJR2gzcHc) (Chrome Dev Tools helps us marking those points with blue and red vertical lines) we can understand why these metrics are not so helpful.

![timeline trace of reddit.com](https://cdn-images-1.medium.com/max/1000/1*hFyHeo1-iI62aMQT8P8ORw.png)

> Fast forward to today and we see that `window.onload` doesn’t reflect the user perception as well as it once did.

> [Steve Souders](https://medium.com/@souders), [Moving beyond window.onload()](https://www.stevesouders.com/blog/2013/05/13/moving-beyond-window-onload/) (2013)

Indeed. The problem of `DOMContentLoaded` is a time for parsing and executing javascript, if scripts are too big then this time might take too long. For example on mobile devices. Regarding the timeline trace, which was measured with 3G network throttling, it took ~10 sec for reaching `load`.

In other hand, `load` happens too late to analyze page performance bottlenecks.

So can we rely on these metrics? What information do they provide us with?

And the main question, **how do users perceive page load** from the start of page loading to fully loaded page?

Why is this loading perception is so important? We can refer to [Leveraging the Performance Metrics that Most Affect User Experience article](https://developers.google.com/web/updates/2017/06/user-centric-performance-metrics) from [Chrome Developers](https://medium.com/@ChromiumDev) which underline problem of `load` one more time.

Taking a look at the histogram where X-axis show load times and y-axis show the relative number of users who experienced a load time in that particular time bucket, you can understand that not all users experienced load time less than 2 seconds.

![](https://cdn-images-1.medium.com/max/1000/1*gw7eB5MF4SDAk1TGHSUlkg.png)

As a result `load` time, which is around 17 seconds for our experiment, couldn’t say anything valuable about user’s perception of page loading. What had user been seeing during this 17 seconds? Blank screen? Partly loaded page? Was content loaded but frozen (e.g. user couldn’t tap on input or scroll)? Having answers to that questions:

1. Can improve user experience
2. Bring more users to the application
3. Increase benefits for product owners (users, customers, money)

* * *

So, guys tried to read users minds and predict what would user ask herself/himself while 17 seconds of load time.

1. “I**s it happening?**”

Has my navigation started successfully (the server has responded, etc.)?

2. “I**s it useful?**”

Has the page painted enough critical content that I could engage with it?

3. “I**s it usable?**”

Can I actually engage with the page or is it still busy?

4. “**Is it delightful?**”

Was I pleasantly surprised by the lack of scrolling jank, animation jank, FOUC, slow webfonts, etc?

* * *

If `DOMContentLoaded` or `load` metrics can’t answer these questions which one can?

## Progressive Web Metrics

PWM’s — list of metrics which suppose to help detect performance bottlenecks. Despite `load` and `DOMContentLoaded` PWM’s provide developers with much more detailed information about page loading.

Let’s take a journey with PWM’s using reddit.com trace and try to understand the meaning of each metric.

![Timeline trace of reddit.com measured using ChromeDevTools](https://cdn-images-1.medium.com/max/1000/1*-zjNpHphoKaaZJgG7omu2w.png)

* * *

### First Paint (FP)

I was, kinda, cheating saying that we had only 2 metrics. Dev Tools also provided us with one more metric — FP. It’s a timing while page was being painted. Saying another word it’s time when user seeing a blank screen for the first time (below a FP screenshot of msn.com). Read more at [specification](https://github.com/w3c/paint-timing).

![](https://cdn-images-1.medium.com/max/800/1*IuI-OeOiJByd_kbOnQ4T6A.png)

To understand how it works, we can take a look under the hood at Chromium graphic layer, as an example

![Simplified Chromium Graphics Layer](https://cdn-images-1.medium.com/max/800/1*w0ejDtPxaRfJsyGRgoE02A.png)

FP event is fired when graphic layer was being painted, but not text, image, canvas etc, but it gave some information at list which developers tried to use.

While it was not standardized metric, measuring became really tricky. Different “hacky” techniques were used, like:

* attaching requestAnimationFrame
* catching css resources loaded
* even using `DOMContentLoaded` and `load`events (their problems were described above)

But, despite on all effort, it has low-level value because text, image, canvas might be drawn a while after fired FP event, affected by performance bottlenecks like page weight, css or javascript resources size.

> This metric is NOT a part PWM but knowledge about it is useful to understand metric explained below.

So some other metric was needed to represent actual drawing of content.

### **First Contentful Paint (FCP)**

It’s a timing when user sees something “contentful” painted on a page. Just something different from a blank screen. It can be anything either first paint of text, or first paint of SVG, or first paint of canvas etc.

As a result, user might ask himself the question, i**s it happening?** Has page started loading after he/she wrote a URL and pressed enter?

![First Paint vs First Contentful Paint of msn.com](https://cdn-images-1.medium.com/max/800/1*UduDmCWTDefC6CHubA-lTQ.png)

Continuing taking a look at Chromium, FCP event has been fired during actual drawing of a text (text which is waiting for loading fonts is ignored), image, canvas etc. As result time difference between FP and FCP might take from milliseconds to seconds_._ The difference really noticed even on a screenshot above. That’s why having metric which represents real first paint of content is valuable.

> You can read all specification [here](https://docs.google.com/document/d/1kKGZO3qlBBVOSZTf-T8BOMETzk3bY15SC-jsMJWv4IE/edit#).

**How is *FCP* metric valuable for developers?**

If time to *First Contentful Paint* takes too long, then:

* you might have performance jank in your network connection
* resources are large (e.g. index.html) and it takes a time to deliver them

Read more about network performance in [High Performance
Browser Networking](https://hpbn.co/) by [Ilya Grigorik](https://medium.com/@igrigorik) to eliminate the influence of these factors.

* * *

### First Meaningful Paint (FMP)

Is the time when page’s primary content appeared on the screen, hence — **is it useful?**

![First Paint vs First Contentful Paint vs First Meaningful Paint of msn.com](https://cdn-images-1.medium.com/max/800/1*835Kq5Mzw87L8XRoXXyKIw.png)

What’s this primary content?

When

* header and text for blogs
* search text for search engines
* images if they are critical for e-commerce products

is shown.

But it _doesn’t count_ if

* spinners or something similar
* flash of unstyled content (FOUC)
* navigation bar or page header

is shown.

> FMP = Paint that follows biggest layout change

Due to Chromium implementation, this paint is calculated using [LayoutAnalyzer](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/WebKit/Source/core/layout/LayoutAnalyzer.h&sq=package:chromium&type=cs), which collects all layout changes, by finding time when the biggest layout was changed. This time will be the FMP.

> You can read all specification [here](https://docs.google.com/document/d/1BR94tJdZLsin5poeet0XoTW60M0SjvOJQttKT-JK8HI/edit#).

**How is *FMP* metric useful for developers?**

If primary content isn’t shown for too long time, then:

* too many resources (images, styles, fonts, javascript) have high load priority, as a result, they are blocking FMP

I don’t wanna repeat already used practices for improving these bottlenecks and just leave some links

* [Preload, Prefetch And Priorities in Chrome](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf) by [Addy Osmani](https://medium.com/@addyosmani)
* [Critical Request](https://css-tricks.com/the-critical-request/) by [Ben Schwarz](https://medium.com/@benschwarz)
* [The State of the Web](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) by [Karolina Szczur](https://medium.com/@fox)
* [Practical Performance (Polymer Summit 2016)](https://youtu.be/6m_E-mC0y3Y) from [Paul Irish](https://medium.com/@paul_irish) and [Sam Saccone](https://medium.com/@samccone)

where you can find all necessary information.

* * *

### Visually Ready

When page looks “nearly” loaded but browser hasn’t finished executing all scripts.

* * *

### Estimated Input Latency

Metric suppose to estimate how smoothly application responses on user input.

But before digging in I want to explain some terminology to be on a same page.

**Long tasks**

Browser under the hood wrap all users input into tasks (UI tasks) and put them in a queue on the main thread. Other than that, browser also has to parse/compile/execute javascript on a page (application tasks). If time for each application task takes a long time then user input task might be blocked until they are done. As a result it could delay interactive with a page, page could behave janky and laggy.

Saying simple words, long tasks — parsing/compiling/executing javascript chunks longer than 50ms.

> You can read all specification [here](https://w3c.github.io/longtasks/).

Long tasks API already [implemented](https://www.chromestatus.com/feature/5738471184400384) in Chrome and already used for measuring how busy main thread is.

![](https://cdn-images-1.medium.com/max/1000/1*JUlxNXlme70nrChpYw6idQ.png)

Going back to the Estimated Input Latency, users assume that page responses immediately but if main thread is busy proceeding each long task then it bothers he/she in a not good way. As far as user experience is critical for application you can read information [Measure Performance with the RAIL Model](https://developers.google.com/web/fundamentals/performance/rail) about performance improvements of these kind bottlenecks.

* * *

### First Interactive

Interactive — i**s it usable?** Yes, this is the question user want to ask when seeing Visually Ready page and want to engage with it.

First interactive has happened then conditions

* *FMP*
* &&
* [DOMContentLoaded](https://developer.mozilla.org/ru/docs/Web/Events/DOMContentLoaded) event has been fired
* &&
* page *Visually Complete* on 85%

are satisfied.

First Interactive — metric which is separated on a two metrics Time to First Interactive (TTFI) and Time to First Consistently Interactive (TTCI).

Reasons to separate it

* define minimal interactive, when UI responses well but it’s ok if it’s not
* when a website is completely and delightfully interactive and strictly meets the guideline of [RAIL](https://developers.google.com/web/fundamentals/performance/rail)

**TTCI**

![](https://cdn-images-1.medium.com/max/800/0*6qzJAADPmBaNSwFw.)

Using revers analyses, which looks from the end of a trace, finds that the page loading activity is quiet for 5 sec and it has no more long tasks, get period called *quiet window*. Time after quiet window and before first long task (first from the end) will be **TTCI.**

**TTFI**

![](https://cdn-images-1.medium.com/max/800/0*xWGGBiXh0pLiPeuk.)

Definition of this metric a bit different from TTCI. Trace is analyzed from start to end. After FMP happened there are should be quiet window for 3 seconds. It’s enough time for saying that page is interactive enough for the user. But there might be _lonely tasks_ during/after quite window. They can be ignored.

> _Lonely tasks — _tasksexecuted far from FMP and isolated by 250ms execution time period (envelope size) and 1 sec quietness before and after envelope size. Example of this task can be third party ads or analytics scripts.

> Sometimes “lonely tasks” longer than 250ms can have serious perf impact on a page

> Like detecting *adblock*

> You can read all specification [here](https://docs.google.com/document/d/1GGiI9-7KeY3TPqS3YT271upUVimo-XiL5mwWorDUD4c/edit#).

**How are *TTFI and TTCI* metrics useful for developers?**

When thread is busy for a long time between *Visually Ready* and *First Interactive*

![](https://cdn-images-1.medium.com/max/800/1*_uAiHAv4-bpoMFYqgbBKcQ.png)

This is one of the trickiest bottlenecks and there is no standard way to fix this kind of problem. It’s individual and depends on application specific cases. [Chrome Dev Tools](https://developer.chrome.com/devtools) has bunch of [articles](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/) which can help detect runtime performance issues.

* * *

### Visually Complete / Speed Index

*Visually Complete* is calculated taking page screenshots and do pixel analysis of those screenshots applying [Speed Index algorithm](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index). Sometimes it can be tricky measuring *Visually Complete.*

> If page has changing images aka carousel it might be challenging to get proper Result of Visually Complete

*Speed Index* by itself represents median of *Visually Complete* results. The less value of *Speed Index* metric then better.

Visually Complete 100% is a final point where user can be either happy or not. This is a time for asking question — **was it delightful?**

* * *

## Summarizing

It’s not all PWM but most important of them. Above, were added links to materials which can help improve each metric, also, I want to leave some links to the tools for measuring this kind of metrics

* [Web Pagetest](https://www.webpagetest.org/about)
* [Lighthouse](https://github.com/GoogleChrome/lighthouse/)
* [pwmetrics](https://github.com/paulirish/pwmetrics)
* [Calibre](https://calibreapp.com/)
* [DevTools Timeline Viewer](https://chromedevtools.github.io/timeline-viewer/)

P.S. For getting results of all these metrics is better to use either Lighthouse or pwmetrics. Both Calibre and WPT run Lighthouse, and by extension of that provides all of these metrics.

If you want to do performance measurements manually there are native API called [PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver) can help you achieve your measurement goals.

Example from [specification](https://w3c.github.io/performance-timeline/):

```
const observer = new PerformanceObserver(list => {
  list
    .getEntries()
    // Get the values we are interested in
    .map(({ name, entryType, startTime, duration }) => {
      const obj = {
        "Duration": duration,
        "Entry Type": entryType,
        "Name": name,
        "Start Time": startTime,
      };
      return JSON.stringify(obj, null, 2);
    })
    // Display them to the console
    .forEach(console.log);
  // maybe disconnect after processing the events.
  observer.disconnect();
});
// retrieve buffered events and subscribe to new events
// for Resource-Timing and User-Timing
observer.observe({
  entryTypes: ["resource", "mark", "measure"],
  buffered: true
});
```

Thanks to all guys for amazing work with a specifications, articles, and tools!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
