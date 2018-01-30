> * 原文地址：[Front-End Performance Checklist 2018 - Part 1](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
> * 译者：[tvChan](https://github.com/tvChan)
> * 校对者：[mysterytony](https://github.com/mysterytony) [ryouaki](https://github.com/ryouaki)

# 2018 前端性能优化清单 —— 第一部分

下面你将会看到你可能需要考虑到的前端性能优化问题，以保证你的应用具有快速和流畅的响应时间。

- [2018 前端性能优化清单 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [2018 前端性能优化清单 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [2018 前端性能优化清单 —— 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [2018 前端性能优化清单 —— 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

### 做好准备：计划和指标

微小的优化对于保持性能来说都是很重要的，但是在头脑中明确的定义 —— **可衡量**的目标才是至关重要的。这将会影响你整个过程中做出的任何决定。有几种不同的模型，下面讨论的模型都很有自己的主见 —— 只要确保在一开始能设定自己的优先级就行。

1. **建立性能指标。**

在许多组织里，前端开发人员确切的知道常见的潜在问题是什么，并且知道使用什么加载模块来修复它们。然而，只要开发/设计和营销团队之间没有一致性，性能就不能长期维持。研究客户服务中的常见投诉，了解如何提高性能，可以帮助解决这些常见问题。

在移动和桌面设备上运行性能实验和测量结果。它将帮助你的公司量身定做一个根据真实数据而得到的研究案例。此外，利用 [WPO 统计](https://wpostats.com/) 数据对案例进行研究和实验，可以帮助提高业务对性能问题的敏感度，以及它对用户体验和业务指标的影响。仅仅说明性能问题是远远不够的 —— 你也需要建立一些可衡量和可跟踪的目标并对它们进行观察。

2. **目标：至少要比你最快的竞争对手还快 20%。**

根据[心理学的研究](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule)，如果你想让用户感觉你的网站比竞争对手的快，你**至少**需要比它们快 20%。 研究你的主要竞争对手，收集它们是怎么在手机和桌面设备上展示的数据，并且设置阈值来帮助你超过它们。要获取准确的结果和目标，首先要研究你的分析结果，看看你的用户都在做什么。然后，你可以模拟第百分之九十位的实验进行测试。收集数据，创建一个 [电子数据表](http://danielmall.com/articles/how-to-make-a-performance-budget/)，从中剔除 20%, 并制定你的目标（即 [性能预算](http://bradfrost.com/blog/post/performance-budget-builder/)）。现在你就有一些可以测试的东西了。

如果你希望保持现在的成本不变，并尽可能的少写一些脚本，就能有一个快速的可交互时间。那么你已经走在正确的道路上了。劳拉.霍根的[指导你如何用性能预算接近设计](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget) 里提供了有用的方向，设计人员，[性能预算计算者](http://www.performancebudget.io/)和 [Browser Calories](https://browserdiet.com/calories/) 可以帮助我们创建预算（感谢 [Karolina Szczur](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) 的牵头）。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_2000/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/231e97c1-4bfa-4dff-85a7-93e0a16b2690/performance-budget-lbp9l7-c-scalew-862-opt.png)

除了性能预算之外，还要考虑对你的业务最有利的关键客户任务。设置和讨论可接受的**关键行为的时间阈值**，并建立整个项目组都已经同意的 ＂UX 就绪＂的用户计时标记。在许多情况下，用户的需求将会影响到许多不同部门的工作。因此, 在可接受的时间内进行调整，将有助于支持或避免了在优化路上的性能讨论。确保增加资源和功能的额外成本是可预见和可理解的。

此外, 正如 Patrick Meenan 建议的，在设计过程中**制定一个加载顺序及其权衡**是非常值得。如果你在早期优先考虑哪些部分更重要，并且定义了它们应该出现的顺序，那么你也将知道哪些部分可以延迟。在理想情况下，该顺序还将反映 CSS 和 JavaScript 的导入顺序。因此，在构建过程中处理它们会更容易。此外，在加载页面时，请考虑在"中间"状态下的视觉体验 (例如，web 字体尚未加载时)。

计划，计划，计划。在早期的优化里，它可能像是诱人的＂熟水果＂ —— 最终它可能是一个很好的能快速取胜的策略 —— 但是，如果没有计划和切合实际的、为公司量身定制的性能目标，就很难将性能放在首位。

3. **选择正确的指标。**

[并不是所有的指标都同样重要](https://speedcurve.com/blog/rendering-metrics/)。研究哪些标准对你的应用程序最重要：通常它与你开始渲染那些**最重要的**像素点（以及它们是什么）有多快和如何快速地为这些渲染的像素点提供输入响应有关。这可以帮助你为后续的工作提供最佳的优化结果。不管怎样，不要专注于整个页面的加载时间（例如，通过 **onLoad** 和 **DOMContentLoaded** 计时），而是优先加载用户认为重要的页面。这意味着要专注于一组稍有不同的指标。事实上，选择正确的指标是一个没有对手的过程。

<figure class="video-container break-out"><iframe src="https://player.vimeo.com/video/249524245" width="640" height="358" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

首次有内容渲染，首次有效渲染，视觉完整和可交互时间之间的区别。[大图](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)。来自于：[@denar90](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)

下面是一些值得考虑的指标：

* **首次有效渲染**（FMP，是指主要内容出现在页面上所需的时间），
* **[英雄渲染时间](https://speedcurve.com/blog/web-performance-monitoring-hero-times/)**（页面最重要部分渲染完成所需的时间），
* **可交互时间**（TTI，是指页面布局已经稳定，关键的页面字体已经可见，主进程可以足够的处理用户的输入 —— 基本的时间标记是，用户可以在 UI 上进行点击和交互），
* **输入响应**，接口响应用户操作所需的时间，
* **速度指标**，测量填充页面内容的速度。 分数越低越好，
* 你的[自定义指标](https://speedcurve.com/blog/user-timing-and-custom-metrics/)，由你的业务需求和客户体验来决定。

Steve Souders 对[每个指标都进行了详细的解释](https://speedcurve.com/blog/rendering-metrics/)。在许多情况下，根据你的应用程序的上下文，[可交互时间和输入响应](https://medium.com/netflix-techblog/crafting-a-high-performance-tv-user-interface-using-react-3350e5a6ad3b)会是最关键的。但这些指标可能会不同：例如，对于 Netflix 电视的用户界面来说，关键输入响应、内存使用和可交互时间更为重要。

4. **从具有代表性的观众的设备上收集数据。**

为了收集准确的数据，我们需要彻底的选择要测试的设备。也许在一个[开放式的实验室](https://www.smashingmagazine.com/2016/11/worlds-best-open-device-labs/)里，Moto G4 是一个很好的选择，它是一款中档的三星设备又或者是一个普通的设备，如 Nexus 5X。如果你手边没有设备，可以在节流网络（例如，150 ms 的往返时延，1.5 Mbps 以下，0.7 Mbps 以上）上使用节流 CPU（5× 减速）实现在桌面设备上模拟移动设备的体验。最终，切换到常规的 3G，4G 和 wi-fi。为了使性能体验的影响更明显，你甚至可以在你的办公室里引入 [2G Tuesdays 计划](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)或者设置[一个节流的 3G 网络](https://twitter.com/thommaskelly/status/938127039403610112)，以便进行更快的测试。

[![Introducing the slowest day of the week](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dfe1a4ec-2088-4e39-8a39-9f2010380a53/tuesday-2g-opt.png)](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)

引入一周中最慢的一天。Facebook推出了[周二 2G 计划](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)，以提高对低速连接的能见度和灵敏度。（[图片来源](http://www.businessinsider.com/facebook-2g-tuesdays-to-slow-employee-internet-speeds-down-2015-10?IR=T)）

幸运地是，有许多很好的选项可以帮助你自动的收集数据，并根据这些指标来衡量在一段时间内你的网站的运行情况。请记住，良好的性能指标是被动和主动监测工具的组合：

* **被动监测工具**，是那些模拟用户交互请求（**综合测试**，如**Lighthouse**，**WebPageTest**）和
* 那些不断记录和评价用户交互行为的**主动监测工具**（**真正的用户监控**，如 **SpeedCurve**，**New Relic**  ——   这两种工具也提供综合测试）

前者是在开发过程中特别有用，因为它能帮助你在产品开发过程中持续跟踪。后者对于长期维护很有用，因为它能帮助你了解用户在实际访问站点时的性能瓶颈。利用内置的 RUM API，如导航计时，资源计时，渲染计时，长任务等，被动和主动的性能监测工具可以一起为你的应用程序提供完整的性能视图。例如，你可以使用[PWMetrics](https://github.com/paulirish/pwmetrics)，[Calibre](https://calibreapp.com)，[SpeedCurve](https://speedcurve.com/)，[mPulse](https://www.soasta.com/performance-monitoring/)，[Boomerang](https://github.com/yahoo/boomerang) 和 [Sitespeed.io](https://www-origin.sitespeed.io/)，这些都是性能监测工具的绝佳选择。

**注意**：选择网络级别的节流器（在浏览器外部）总是比较安全的，例如，DevTools 与 HTTP/2 推送的交互问题，是因为它的实现方式。（**感谢 Yoav!**）

[![Lighthouse](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d829af6f-23ff-432c-9659-bd6f3c13678f/lighthouse-shop-polymer-opt.png)](https://developers.google.com/web/tools/lighthouse/)

[Lighthouse](https://developers.google.com/web/tools/lighthouse/)一个集成在 DevTools 的性能检测工具。

5. **与你的同事分享性能清单。**

为了避免误解，要确保你团队里的每个同事都对清单很熟悉。每个决策都对性能有影响。项目将极大地受益于前端开发人员正确地将性能价值传达给整个团队。这样每个人都会对它负责，而不仅仅是前端开发人员。根据性能预算和核对表中定义的优先级映射设计决策。

[![RAIL](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c91c910d-e934-4610-9dc5-369ec9071b57/rail-perf-model-opt.png)](https://developers.google.com/web/fundamentals/performance/rail)

[RAIL](https://developers.google.com/web/fundamentals/performance/rail)，以用户为中心的性能模型。

### 制定现实的目标

6. **60 fps，100 毫秒的响应时间。**

为了让交互感觉起来很顺畅，接口有 100ms 来响应用户的输入。任何比它长的时间，用户都会认为该应用程序很慢。[RAIL，一个以用户为中心的性能模型](https://www.smashingmagazine.com/2015/10/rail-user-centric-model-performance/)会为你提供健壮的目标。为了让页面达到小于 100ms 的响应，页面必须要在在每小于 50ms 前将控制返回到主线程。[预计输入延迟时间](https://developers.google.com/web/tools/lighthouse/audits/estimated-input-latency)会告诉我们，如果我们能达到这个门槛，在理想情况下，它应该低于 50ms。对于像动画这样的高压点，最好不要在你能做到的地方做任何事，也不要做你不能做到的事。

同时，每一帧动画应该要在 16 毫秒内完成，从而达到 60 帧每秒（1秒 ÷ 60 = 16.6 毫秒） —— 最好在 10 毫秒。因为浏览器需要时间将新框架绘制到屏幕上，你的代码应该在触发 16.6 毫秒的标志前完成。[保持乐观](https://www.smashingmagazine.com/2016/11/true-lies-of-optimistic-user-interfaces/)和明智地利用空闲时间。显然，这些目标适用于运行时的性能，而不是加载性能。

7. **速度指标小于 1250，在 3G 网络环境下可交互时间小于 5s，重要文件的大小预算小于 170kb。**

虽然这可能很难实现，但首次有效渲染要低于 1 秒和[速度指标](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)的值低于 1250 将会是一个很好的最终目标。考虑到是一个以 200 美金为基准的 Android 手机（如 Moto G4）在一个缓慢的 3G 网络上，模拟 400ms 的往返延时和 400kb 的传输速度。它的目标是[可交互时间低于 5s](https://www.youtube.com/watch?v=_srJ7eHS3IM&feature=youtu.be&t=6m21s)，并且重复访问的速度低于 2s。

请注意，当谈到**可交互时间**时，最好来区分一下[首次交互和一致性交互](https://calendar.perfplanet.com/2017/time-to-interactive-measuring-more-of-the-user-experience/)以避免对它们之间的误解。前者是在主要内容已经渲染出来后最早出现的点（窗口至少需要 5s，页面才开始响应）。后者是期望页面可以一直进行输入响应的点。

HTML 的前 14~15kb 加载是**是最关键的有效载荷块**  —— 也是第一次往返（这是在400 ms 往返延时下 1秒内所得到的）预算中唯一可以交付的部分。一般来说，为了实现上述目标，我们必须在关键的文件大小内进行操作。[最高预算 170 Kb gzip](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (0.8-1MB decompressed)（0.8-1MB解压缩），它已经占用多达 1s （取决于资源类型）来解析和在普通电话上进行编译。稍微高于这个值是可以的，但是要尽可能地降低这些值。

不过你也可以超出包大小的预算。例如，你可以在浏览器主线程的活动中设置性能预算，即：在开始渲染前的绘制时间或者[跟踪前端 CPU](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/) 。[Calibre](https://calibreapp.com/)，[SpeedCurve](https://speedcurve.com/) 和 [Bundlesize](https://github.com/siddharthkp/bundlesize) 这些工具可以帮助你保持你的预算控制，并集成到你的构建过程。

[![From 'Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/3bb4ab9e-978a-4db0-83c3-57a93d70516d/file-size-budget-fast-default-addy-osmani-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

[本来就很快的：现代化加载的最佳实践](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) 来自 Addy Osmani（幻灯片 19）

### Defining The Environment

8. **选择和设置你的构建工具。**

[不要太在意那些很酷的东西](https://24ways.org/2017/all-that-glisters/)。坚持使用你的构建工具，无论是Grunt，Gulp，Webpack，Parcel，还是工具间的组合。只需要你能快速的得到结果，并且维护你的构建过程保证没问题。那么，你就做的很好了。

9. **渐进式增强。**

将[渐进式增强](https://www.aaron-gustafson.com/notebook/insert-clickbait-headline-about-progressive-enhancement-here/)作为前端结构体系和部署的指导原则是一个安全的选择。首先设计和构建核心经验，然后为有能力的浏览器使用高级特性增强体验，创造[弹性](https://www.aaron-gustafson.com/notebook/insert-clickbait-headline-about-progressive-enhancement-here/)体验。如果你的网站是在一个网络不佳的并且有个糟糕的显示屏上糟糕的浏览器上运行，速度还很快的话，那么，当它运行在一个快速网络下快速的浏览器的机器上，它只会运行得更快。

10. **选择一个强大的性能基准。**

有这么多未知因素影响加载 —— 网络、热保护、缓存回收、第三方脚本、解析器阻塞模式、磁盘的读写、IPC jank、插件安装、CPU、硬件和内存限制、web 字体加载行为 —— [JavaScript 的代价是最大的](https://youtu.be/_srJ7eHS3IM?t=3m2s)，web 字体阻塞渲染往往是默认和图片消耗了大量的内存所导致的。由于性能瓶颈从[服务器端转移到客户端](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/)，作为开发人员，我们必须更详细地考虑所有这些未知因素。

在 170kb 的预算中，已经包括了关键路径的 HTML/CSS/JavaScript、路由器、状态管理、实用程序、框架和应用程序逻辑，我们必须彻底[检查网络传输成本，分析/编译时间和我们选择的框架的运行时的成本](https://www.twitter.com/kristoferbaxter/status/908144931125858304)。

[!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/39c247a9-223f-4a6c-ae3d-db54a696ffcb/tti-budget-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

本来就很快的：[现代化加载的最佳实践](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)来自 Addy Osmani(幻灯片18、19)。

正如 Seb Markbage 所[指出](https://twitter.com/sebmarkbage/status/829733454119989248)，测量框架的启动成本的好方法是首先渲染视图，再删除它，然后再渲染，因为它可以告诉你框架是如何处理的。

第一种渲染倾向于预热一堆编译迟缓的代码，当它扩展时，更大的树可以从中受益。第二种渲染基本上是对页面上的代码重用如何影响性能特性的模拟，因为页面越来越复杂。

[并不是每个项目都需要框架](https://twitter.com/jaffathecake/status/923805333268639744)。事实上，某些项目因[移除已存在的框架而从中获益](https://twitter.com/jaffathecake/status/925320026411950080)。一旦选择了一个框架，你将会至少与它相处几年。所以，如果你需要使用它，确保你的选择是经过[深思熟虑的](https://medium.com/@ZombieCodeKill/choosing-a-javascript-framework-535745d0ab90#.2op7rjakk)而且别人是[知情的](https://www.youtube.com/watch?v=6I_GwgoGm1w)。在进行选择前，至少要考虑总大小的成本 + 初始解析时间：轻量级的选项像 [Preact](https://github.com/developit/preact)，[Inferno](https://github.com/infernojs/inferno)，[Vue](https://vuejs.org/)，[Svelte](https://svelte.technology/) 或者 [Polymer](https://github.com/Polymer/polymer) 都可以把工作做得很好。大小的基准将决定应用程序代码的约束。

[![JavaScript parsing costs can differ significantly](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8a36eef0-083f-4652-9814-95ffe7848982/parse-costs-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

JavaScript 解析成本可能有很大差异。[本来就很快的: 现代化加载的最佳实践](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)来自Addy Osmani (幻灯片 10)。

请记住，在移动设备上，与台式计算机相比，你会预计有 4x-5x 的减速。因为移动设备具有不同的 GPU，CPU，内存及电池特性。在手机上的解析时间[比桌面设备的要高 36%](https://github.com/GoogleChromeLabs/discovery/issues/1)。所以总在一个[普通的设备上测试](https://www.webpagetest.org/easy-load) —— 一种最能代表你的观众的设备。

不同的框架将会对性能产生不同的影响，并且需要不同的优化策略。因此，你必须清楚地了解你所依赖的框架的所有细节。[PRPL 模式](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)和[应用程序 shell 体系结构](https://developers.google.com/web/updates/2015/11/app-shell)。这个想法很简单: 将初始路由的交互所需的最小代码快速呈现，然后使用 service worker 进行缓存和预缓存资源，然后异步加载所需的路由。

[![PRPL Pattern in the application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bb4716e5-d25b-4b80-b468-f28d07bae685/app-build-components-dibweb-c-scalew-879-opt.png)](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)

[PRPL](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) 代表的是保持推送关键资源，渲染初始路由，预缓存剩余路由和延迟加载必要的剩余路由。

[![Application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6423db84-4717-4aeb-9174-7ae96bf4f3aa/appshell-1-o0t8qd-c-scalew-799-opt.jpg)](https://developers.google.com/web/updates/2015/11/app-shell)

[应用程序 shell](https://developers.google.com/web/updates/2015/11/app-shell) 是最小的 HTML、CSS 和 JavaScript 驱动的用户界面。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
