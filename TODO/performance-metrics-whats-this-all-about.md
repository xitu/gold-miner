
> * 原文地址：[Performance metrics. What’s this all about?](https://codeburst.io/performance-metrics-whats-this-all-about-1128461ad6b)
> * 原文作者：[Artem Denysov](https://codeburst.io/@denar90?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/performance-metrics-whats-this-all-about.md](https://github.com/xitu/gold-miner/blob/master/TODO/performance-metrics-whats-this-all-about.md)
> * 译者：[llp0574](https://github.com/llp0574)
> * 校对者：[ppp-man](https://github.com/ppp-man)，[lampui](https://github.com/lampui)

# 性能指标都是些什么鬼?

![](https://cdn-images-1.medium.com/max/1000/1*hT4ixOXHZ8KRZ3YfbpAxbg.png)

测量页面的加载性能是一项艰难的任务。因此 [Google Developers](https://medium.com/@googledevs) 正和社区一起致力于建立渐进式网页指标（Progressive Web Metrics，简称 PWM’s）。

PWM’s 都是些什么，我们为什么需要它们？

先来讲一点关于浏览器指标的历史。

此前我们有两个主要的点（事件）来测量性能：

`DOMContentLoaded` — 页面加载完成但脚本文件刚刚开始执行时触发（译者注：这里指初始的 HTML 文档加载并解析完成，但不包括样式表、图像和子框架的加载完成，参考 [MDN DOMContentLoaded 事件](https://developer.mozilla.org/zh-CN/docs/Web/Events/DOMContentLoaded)）。

`load` 事件在页面完全加载后触发，此时用户已经可以使用页面或应用。

举个例子，如果我们看一下 [reddit.com 的跟踪时间轴](https://chromedevtools.github.io/timeline-viewer/?loadTimelineFromURL=drive://0ByCYpYcHF12_YjBGUTlJR2gzcHc)（Chrome 的开发者工具可以帮助我们用蓝色和红色的垂直线来标记那些点），就可以明白为什么这些指标不是那么有用了。

![timeline trace of reddit.com](https://cdn-images-1.medium.com/max/1000/1*hFyHeo1-iI62aMQT8P8ORw.png)

> 时至今日，我们可以看到 `window.onload` 并不像以前那样能真实反映出用户的体验了。

> —— [Steve Souders](https://medium.com/@souders)，[Moving beyond window.onload()](https://www.stevesouders.com/blog/2013/05/13/moving-beyond-window-onload/) (2013)

确实，`DOMContentLoaded` 的问题在于不包含解析和执行 JavaScript 的时间，如果脚本文件太大，那么这个时间就会非常长。比如移动设备，在 3G 网络的限制下测量跟踪时间轴，就会发现要花费差不多十秒才能到达 `load` 点。

另一方面，`load` 事件太晚触发，就无法分析出页面的性能瓶颈。

所以我们能否依赖这些指标？它们到底给我们提供了什么信息？

而且最主要的问题是，从页面开始加载直至加载完成，**用户对这个过程的感知如何**？

为什么加载感知会如此重要？可以参考 [Chrome Developers](https://medium.com/@ChromiumDev) 上的一篇文章：[Leveraging the Performance Metrics that Most Affect User Experience](https://developers.google.com/web/updates/2017/06/user-centric-performance-metrics)，其再次强调了 `load` 的问题。

看一下下方柱状图，其 X 轴展示了加载时长，Y 轴展示了实际加载时长在特定时间区间里的用户的相对数量，你就可以明白不是所有用户的体验到的加载时间都会小于两秒。

![](https://cdn-images-1.medium.com/max/1000/1*gw7eB5MF4SDAk1TGHSUlkg.png)

因此在我们的试验里，17 秒左右的 `load` 事件在了解用户加载感知方面是没有什么价值的。用户在这 17 秒里到底看到了什么？白屏？加载了一半的页面？页面假死（用户无法点击输入框或滚动）？如果这些问题有答案的话：

1. 可以改善用户体验
2. 给应用带来更多的用户
3. 增加产品所有者的利益（用户、消费者、钱）

* * *

所以，大家都在尝试解读用户的想法并预测用户在这 17 秒的加载时间里会想些什么。

1. “**它正在运行吗？**”

我的网页开始载入了吗（服务器有回应，等等）？

2. “**它有用吗？**”

页面上是否有足够关键的内容使我能够理解？

3. “**它可以使用了吗？**”

我能不能和页面互动了呢？还是它依旧处于加载状态？

4. “**用户体验良好吗？**”

我是否因没有出现滚动卡顿、动画卡顿、无样式内容闪烁和Web 字体文件加载缓慢等问题而感到惊喜？

* * *

如果 `DOMContentLoaded` 或者 `load` 指标不能回答这些问题，那么什么指标可以回答？

## 渐进式网页指标（Progressive Web Metrics）

PWM’s 是一组用来帮助检测性能瓶颈的指标。除开 `load` 和 `DOMContentLoaded`，PWM's 给开发者提供了页面加载过程中更多更详细的信息。

下面让我们用 reddit.com 的跟踪时间轴来探究一下 PWM’s，并尝试弄明白每个指标的意思。

![Timeline trace of reddit.com measured using ChromeDevTools](https://cdn-images-1.medium.com/max/1000/1*-zjNpHphoKaaZJgG7omu2w.png)

* * *

### 首次绘制（First Paint，FP）

我曾经说我们只有两个指标，这其实不太准确。（Chrome）开发者工具还给我们提供了一个指标 - FP。这个指标表示页面绘制的时间点，换句话说它表示当用户第一次看到白屏的时间点（下面是 msn.com 的 FP 截屏）。可以在[规范说明](https://github.com/w3c/paint-timing)里阅读更多相关内容。

![First Paint of msn.com](https://cdn-images-1.medium.com/max/800/1*IuI-OeOiJByd_kbOnQ4T6A.png)

为了弄明白它是如何工作的，我们以 Chromium 中 Graphic Layer 的底层实现作为例子（译者注：关于GraphicsLayer，可以参考[WEBKIT 渲染不可不知的这四棵树](https://juejin.im/entry/57f9eb9e0bd1d00058bc0a1b)或[无线性能优化：Composite](http://taobaofed.org/blog/2016/04/25/performance-composite/)中相关内容）。

![Simplified Chromium Graphics Layer](https://cdn-images-1.medium.com/max/800/1*w0ejDtPxaRfJsyGRgoE02A.png)

FP 事件在 Graphic Layer 进行绘制的时候触发，而不是文本、图片或 Canvas 绘制的时候，但它也给出了一些开发者尝试使用的信息。

然而它并不是标准指标，所以测量就变得非常棘手。因此用到了一些不同的 “取巧” 技术，比如：

* 使用 `requestAnimationFrame` 
* 捕捉 CSS 资源加载
* 甚至使用 `DOMContentLoaded` 和 `load` 事件（它们的问题之前已经讲过）

尽管做出了这些努力，但它实际并没有太大的价值，因为文本、图片和 Canvas 可能在 FP 事件触发一段时间后才会进行绘制，而这个时间间隔会受到诸如页面体积、CSS 或 JavaScript 资源大小等性能瓶颈所影响。

> 这个指标不属于 PWM 的一部分，但它对于理解下面将要讲到的指标很有帮助。

所以需要其他一些指标来表示真实的内容绘制。

### **首次内容绘制（First Contentful Paint，FCP）**

这是当用户看见一些“内容”元素被绘制在页面上的时间点。和白屏是不一样的，它可以是文本的首次绘制，或者 SVG 的首次出现，或者 Canvas 的首次绘制等等。

因此，用户可能会产生疑问，**它正在运行吗？** 页面是否在他（她）键入 URL 并按 enter 键后开始加载了呢？

![First Paint vs First Contentful Paint of msn.com](https://cdn-images-1.medium.com/max/800/1*UduDmCWTDefC6CHubA-lTQ.png)

继续看一下 Chromium，FCP 事件在文本（正在等待字体文件加载的文本不计算在内）、图片、Canvas 等元素绘制时被触发。结果表明，FP 和 FCP 的时间差异可能从几毫秒到几秒不等。这个差别甚至可以从上面的图片中看出来。这就是为什么用一个指标来表示真实的首次内容绘制是有价值的。

> 你可以从[这里](https://docs.google.com/document/d/1kKGZO3qlBBVOSZTf-T8BOMETzk3bY15SC-jsMJWv4IE/edit#)阅读所有的规范说明。

**FCP 指标如何对开发者产生价值？**

如果**首次内容绘制**前耗时太长，那么：

* 你的网络连接可能有性能问题
* 资源太过庞大（如 index.html），传输它们消耗太多时间

阅读 [Ilya Grigorik](https://medium.com/@igrigorik) 写的 [High Performance Browser Networking](https://hpbn.co/) 了解更多关于网络性能的问题，以消除这些因素的影响。

* * *

### 首次有意义绘制（First Meaningful Paint，FMP）

这是指页面主要内容出现在屏幕上的时间点，因此——**它有用吗？**

![First Paint vs First Contentful Paint vs First Meaningful Paint of msn.com](https://cdn-images-1.medium.com/max/800/1*835Kq5Mzw87L8XRoXXyKIw.png)

主要内容是什么？

当

* 博客的标题和文本
* 搜索引擎的搜索文本
* 电子商务产品中重要的图片

展示的时候。

但如果展示的是

* 下拉菜单或类似的东西
* 无样式内容闪烁（FOUC）
* 导航条或页面标题

则**不计算**在主要内容之内。

> FMP = 最大布局变化时的绘制

基于 Chromium 的实现，这个绘制是使用 [LayoutAnalyzer](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/WebKit/Source/core/layout/LayoutAnalyzer.h&sq=package:chromium&type=cs) 进行计算的，它会收集所有的布局变化，得到布局发生最大变化时的时间。而这个时间就是 FMP。

> 你可以从[这里](https://docs.google.com/document/d/1BR94tJdZLsin5poeet0XoTW60M0SjvOJQttKT-JK8HI/edit#)阅读所有的规范说明。

**FMP 指标如何对开发者产生帮助？**

如果主要内容很久都没有展示出来，那么：

* 太多资源（图片、样式、字体、JavaScript）有较高的加载优先级，因此，它们阻塞了 FMP

我不想重复太多已有的用来提升这些瓶颈的实践方法，给大家留出一些链接：

* [Addy Osmani](https://medium.com/@addyosmani) 的 [Preload, Prefetch And Priorities in Chrome](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)
* [Ben Schwarz](https://medium.com/@benschwarz) 的 [Critical Request](https://css-tricks.com/the-critical-request/)
* [Karolina Szczur](https://medium.com/@fox) 的 [The State of the Web](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3)
* [Paul Irish](https://medium.com/@paul_irish) 和 [Sam Saccone](https://medium.com/@samccone) 的 [Practical Performance (Polymer Summit 2016)](https://youtu.be/6m_E-mC0y3Y) 

从这些文章里可以找到所有需要的信息。

* * *

### 视觉上准备好

当页面看上去“接近”加载完成，但浏览器还没有执行完所有脚本文件的时候。

* * *

### 预计输入延迟

这个指标意在估计应用对于用户输入的响应有多流畅。

但在深入研究前，我想通过解释一些术语以便大家在理解上同步。

**长任务**

浏览器底层将所有用户输入打包在一个任务里（UI 任务），并将它们放到主线程的一个队列里。除此之外，浏览器还必须解析、编译并执行页面上的 JavaScript 代码（应用任务）。如果每个应用任务要耗费很长时间的话，那么用户输入任务就可能受到阻塞，直到这些应用任务执行完成。因此它就会延迟与页面的交互，页面就会表现出卡顿和延迟。

简单来说，长任务就是指解析、编译或执行 JavaScript 代码块的耗时大于 50 毫秒。

> 你可以从[这里](https://w3c.github.io/longtasks/)阅读所有的规范说明。

长任务 API 已经在 Chrome 里[实现](https://www.chromestatus.com/feature/5738471184400384)，并用作测量主线程的繁忙程度。

![](https://cdn-images-1.medium.com/max/1000/1*JUlxNXlme70nrChpYw6idQ.png)

回到预计输入延迟，用户会假设页面响应很快，但如果主线程正忙于处理各个长任务，那么就会让用户不满意。对于应用来说，用户体验至关重要，可以从 [Measure Performance with the RAIL Model](https://developers.google.com/web/fundamentals/performance/rail) 这篇文章里阅读关于这种类型的性能瓶颈如何进行性能提升。

* * *

### 首次可交互

可交互 - **它可以使用了吗？** 是的，这是当用户看见视觉上准备好的页面时提出的问题，他们希望能与页面产生交互。

首次可交互发生需满足以下条件：

* *FMP*
* &&
* [DOMContentLoaded](https://developer.mozilla.org/ru/docs/Web/Events/DOMContentLoaded) 事件被触发
* &&
* 页面视觉完成度在 85%

首次可交互 - 这个指标可以拆分成两个指标，首次可交互的时间（Time to First Interactive，TTFI）和首次可持续交互的时间（Time to First Consistently Interactive，TTCI）。

拆分的原因在于：

* 定义最小程度的可交互，当 UI 响应良好时满足可交互，但如果响应不好也可以接受
* 当网站完全的、令人愉悦的可交互，并严格遵循 [RAIL](https://developers.google.com/web/fundamentals/performance/rail) 的指导原则时

**TTCI**

![](https://cdn-images-1.medium.com/max/800/0*6qzJAADPmBaNSwFw.)

使用逆序分析，从追踪线的尾端开始看，发现页面加载活动保持了 5 秒的安静并且再无更多的长任务执行，得到了一段叫做**安静窗口**的时期。安静窗口之后的第一个长任务（从结束时间向前开始算）之前的时间点就是**TTCI**（译者注：这里是将整个时间线反转过来看的，实际表示的是安静窗口前，最接近安静窗口的长任务的结束时间）。

**TTFI**

![](https://cdn-images-1.medium.com/max/800/0*xWGGBiXh0pLiPeuk.)

这个指标的定义和 TTCI 有一点不同。我们从头至尾来分析跟踪时间轴。在 FMP 发生后有一个 3 秒的安静窗口。这个时间已经足够说明页面对于用户来说是可交互的。但可能会有**独立任务**在这个安静窗口期间或之后开始执行，它们可以被忽略。

> **独立任务** - 将 250ms 中执行的多个任务视为一个任务，当一个任务距离 FMP 很远才执行，且在这个任务前后均有一个 1 秒的安静期，则其为一个“独立任务”。举例来说，这个任务可能是第三方广告或者分析脚本。

> 有时长于 250 毫秒的“独立任务”会对页面性能有严重的影响。

> 比如检测**adblock**

> 你可以从[这里](https://docs.google.com/document/d/1GGiI9-7KeY3TPqS3YT271upUVimo-XiL5mwWorDUD4c/edit#)阅读所有的规范说明。

**TTFI 和 TTCI 指标如何对开发者产生帮助？**

当线程在**视觉上准备好**和**首次可交互**间忙碌了很长时间：

![When thread is busy for a long time between Visually Ready and First Interactive](https://cdn-images-1.medium.com/max/800/1*_uAiHAv4-bpoMFYqgbBKcQ.png)

这是其中一个最复杂的瓶颈，并且没有标准方法来修复这类型的问题。它是独立的，而且取决于应用的特定情况。[Chrome 开发者工具](https://developer.chrome.com/devtools)有一系列[文章](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/)帮助我们检测运行时的性能问题。

* * *

### 视觉上完成 / 速度指数

**视觉上完成**是通过页面截图来计算的，并使用[速度指数算法](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)来对那些截图进行像素分析。有时候测量是否**视觉上完成**也是一件棘手的事情。

> 如果页面里有会发生变化的图片如轮播图，那么获取正确的视觉上完成结果就可能有点挑战了。

**速度指数**本身表示**视觉上完成**结果的中值。**速度指数**的值越小，性能就越好。

视觉上 100% 完成是一个最终点，决定了用户对页面是否感到满意。这个时间也是用来回答问题 - **用户体验良好吗？**

* * *

## 总结

上述并不是所有的 PWM，但是最重要的一部分。上面的指标都增加了一些资料链接，帮助我们更好地提升它们，另外，我还想留出一些关于测量这些类型指标的工具链接：

* [Web Pagetest](https://www.webpagetest.org/about)
* [Lighthouse](https://github.com/GoogleChrome/lighthouse/)
* [pwmetrics](https://github.com/paulirish/pwmetrics)
* [Calibre](https://calibreapp.com/)
* [DevTools Timeline Viewer](https://chromedevtools.github.io/timeline-viewer/)

P.S. 要获得所有这些指标的结果的话，我推荐使用 Lighthouse 或 pwmetrics。Calibre 和 WPT 都可以运行 Lighthouse，并可以通过扩展提供所有这些指标。

如果你想手动测量性能，有一个原生 API，叫 [PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver)，它可以帮助你实现你的测量目标。

从[规范说明](https://w3c.github.io/performance-timeline/)里截取的示例：

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

感谢所有工作人员，他们在规范说明、文章和工具上做了很出色的工作！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
