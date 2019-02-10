> * 原文地址：[Front-End Performance Checklist 2019 — 2](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> * 译者：[格子熊](https://github.com/KarthusLorin)
> * 校对者：[Ivocin](https://github.com/Ivocin)，[Fengziyin1234](https://github.com/Fengziyin1234)

# 2019 前端性能优化年度总结 — 第二部分

让 2019 来得更迅速吧~你正在阅读的是 2019 年前端性能优化年度总结，始于 2016。

> - [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> - **[译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)**
> - [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> - [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> - [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> - [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### 目录

- [设置切实可行的目标](#设置切实可行的目标)
  - [7. 100 毫秒响应时间，60 fps](#7-100-毫秒响应时间60-fps)
  - [8. 速度指数 < 1250，TTI（交互时间） < 5s（3G），关键文件大小 < 170KB（gzip 压缩后）](#8-速度指数--1250tti交互时间--5s3g关键文件大小--170kbgzip-压缩后)
- [定义环境](#定义环境)
  - [9. 选择并设置你的构建工具](#9-选择并设置你的构建工具)
  - [10. 默认使用渐进增强](#10-默认使用渐进增强)
  - [11. 选择一个高性能基准](#11-选择一个高性能基准)
  - [12. 评估每个框架以及它们的依赖项](#12-评估每个框架以及它们的依赖项)
  - [13. 考虑使用 PRPL 模式以及应用程序 shell 架构](#13-考虑使用-prpl-模式以及应用程序-shell-架构)
  - [14. 你是否优化了各个 API 的性能？](#14-你是否优化了各个-api-的性能)
  - [15. 你会使用 AMP 或 Instant Articles 吗？](#15-你会使用-amp-或-instant-articles-吗)
  - [16. 明智地选择你的 CDN](#16-明智地选择你的-cdn)

### 设置切实可行的目标

#### 7. 100 毫秒响应时间，60 fps

为了使用户感觉交互流畅，界面的响应时间不得超过 100ms。如果超过了这个时间，那么用户将会认为该应用程序是卡顿的。[RAIL，一个以用户为中心的性能模型](https://www.smashingmagazine.com/2015/10/rail-user-centric-model-performance/) 为你提供了健康的目标：为了达到 <100 毫秒的响应，页面必须在每 50 毫秒内将控制权交还给主线程。[预计输入延迟时间](https://developers.google.com/web/tools/lighthouse/audits/estimated-input-latency) 可以告诉我们是否到达了这个阈值，理想情况下，它应该小于 50 毫秒。对于像动画这样的（性能）高压点，如果可以，最好不要做任何事情。

[![RAIL](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c91c910d-e934-4610-9dc5-369ec9071b57/rail-perf-model-opt.png)](https://developers.google.com/web/fundamentals/performance/rail)
    
[RAIL](https://developers.google.com/web/fundamentals/performance/rail)，一个以用户为中心的性能模型。

此外，每一帧动画应在 16 毫秒内完成，从而达到每秒 60 帧（1 秒 ÷ 60 = 16.6 毫秒）—— 最好在 10 毫秒以下。由于浏览器需要时间将新帧绘制到屏幕上，因此你的代码应在到达 16.6 毫秒的标记之前执行完成。我们开始讨论 120 fps（例如 iPad 的新屏幕以 120Hz 运行），而 Surma 已经覆盖了一些 120 fps 的 [渲染性能解决方案](https://dassur.ma/things/120fps/)，但这可能不是我们目前正关注的目标。

对性能预期持悲观态度，但要 [在界面设计上保持乐观](https://www.smashingmagazine.com/2016/11/true-lies-of-optimistic-user-interfaces/) 并 [明智地使用空闲时间](https://philipwalton.com/articles/idle-until-urgent/)。显然，这些目标适用于运行时性能，而不是加载性能。

#### 8. 速度指数 < 1250，TTI（交互时间） < 5s（3G），关键文件大小 < 170KB（gzip 压缩后）

虽然很难实现，但最好将终级目标定为，首次绘制时间 1 秒以内，[速度指数](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) 的值限制在 1250 以下。由于基准是模拟在价值 200 美元的 Android 手机（如 Moto G4）上，网络为 slow 3G，400ms RTT 和 400kbps 的传输速度，目标是 [交互时间低于 5 秒](https://www.youtube.com/watch?v=_srJ7eHS3IM&feature=youtu.be&t=6m21s)，对于重复访问，目标是低于 2 秒（只能通过 service worker 实现）。

请注意，当谈到互动指标时，最好区分 [First CPU Idle 以及 Time to Interactive](https://calendar.perfplanet.com/2017/time-to-interactive-measuring-more-of-the-user-experience/)，以避免误解。前者是主要内容渲染后的最早点（其中页面至少有 5 秒的响应时间）。后者是页面可以始终响应输入的时间。（**感谢 Philip Walton ！**）

我们有两个主要限制因素，限制我们制定一个 **合理的** 目标来保证网络内容的快速传输。一方面，由于 [TCP 慢启动](https://hpbn.co/building-blocks-of-tcp/#slow-start)，我们有着网络传输的限制。HTML 的前 14 KB是最关键的有效负载块——并且是第一次往返中唯一可以提供的预算（由于手机唤醒时间，这是在 400ms RTT 情况下 1 秒内获得的）。

另一方面，内存和 CPU 有 **硬件限制**（稍后我们将详细讨论它们），原因是 JavaScript 的解析时间。为了实现第一段中所述目标，我们必须考虑 JavaScript 关键文件大小的预算。关于预算应该是多少有很多不同的意见（这应该由你的项目的本身决定），但是 gzip 压缩后预算为 170KB 的 JavaScript 已经需要花费 1s 才能在普通手机上进行解析和编译。假设解压缩时 170KB 扩展到 3 倍大小，那么解压缩后（0.7MB）时，那已经可能是 Moto G4 或 Nexus 2 上“用户体验的丧钟”。

当然，你的数据可能显示你的客户没有使用这些设备，但是也许因为低下的性能导致你的服务无法访问，他们根本没有出现在你的分析中。事实上，Google 的 Alex Russels 建议将 [gzip 压缩后大小为 130-170KB](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) 作为一个合理的上限，当超出这个预算时，你应该进行慎重考虑。在现实世界中，大多数产品都不是很接近（这个标准）；当今的 bundle 平均大小约为 [400KB](https://beta.httparchive.org/reports/state-of-javascript#bytesJs)，与 2015年末相比增长了 35%。在中等水平的移动设备上，**Time-To-Interactive** 占 30-35 秒。

我们当然也可以超过 bundle 的大小预算。例如，我们可以根据浏览器主线程的活动设置性能预算，即在开始渲染之前进行绘制，或 [跟踪前端 CPU 热点](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/)。[Calibre](https://calibreapp.com/)、[SpeedCurve](https://speedcurve.com/) 以及 [Bundlesize](https://github.com/siddharthkp/bundlesize) 等工具能够帮你控制预算，并且可以集成到你的构建过程中。

此外，性能预算可能不应该是固定值。由于依赖网络连接，[性能预算应该（对不同的网络条件）进行适配](https://twitter.com/katiehempenius/status/1075478356311924737)，但无论他们如何使用，慢速连接上的负载更加“昂贵”。

[![From 'Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/3bb4ab9e-978a-4db0-83c3-57a93d70516d/file-size-budget-fast-default-addy-osmani-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

[From Fast By Default: Modern loading best practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani（幻灯片 19）

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/949e5601-04e7-48ee-91a5-10bd7af19a0f/perf-budgets-network-connection.jpg)](https://twitter.com/katiehempenius/status/1075478356311924737) 

性能预算应根据普通移动设备的网络条件进行调整。（图片来源：[Katie Hempenius](https://twitter.com/katiehempenius/status/1075478356311924737)）（[大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/949e5601-04e7-48ee-91a5-10bd7af19a0f/perf-budgets-network-connection.jpg)）

### 定义环境

#### 9. 选择并设置你的构建工具

[不要过分关注那些炫酷的东西。](https://2018.stateofjs.com/) 坚持你自己的构建环境，无论是 Grunt、Gulp、Webpack、Parcel 还是工具组合。只要你获得了所需结果，并且构建过程中没有任何问题，这就可以了。

在构建工具中，Webpack 似乎是最成熟的工具，有数百个插件可用于优化构建大小。入门 Webpack 可能会很难。所以如果你想要入门，这里有一些很棒的资源：

*   [Webpack documentation](https://webpack.js.org/concepts/) —— 显然，一个很好的起点，Webpack 也是如此。Raja Rao 写的 [Webpack — The Confusing Bits](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9) 以及 Andrew Welch 写的 [An Annotated Webpack Config](https://nystudio107.com/blog/an-annotated-webpack-4-config-for-frontend-web-development) 也是。

*   Sean Learkin 有一个名为 [Webpack: The Core Concepts](https://webpack.academy/p/the-core-concepts) 的免费课程，Jeffrey Way 有一个名为 [Webpack for everyone](https://laracasts.com/series/webpack-for-everyone) 的免费课程。这两个课程都是深入 Webpack 的好资料。

*   [Webpack Fundamentals](https://frontendmasters.com/courses/webpack-fundamentals/) 是一个时长为 4h 的非常全面的免费课程，由 Sean Larkin 创作，发布在 FrontendMasters。

*   如果你稍微高级一点，Rowan Oulton 已经发布了一门 [Field Guide for Better Build Performance with Webpack](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1) 并且 Benedikt Rötsch 进行了一项关于优秀的研究 [putting Webpack bundle on a diet](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)。

*   [Webpack examples](https://github.com/webpack/webpack/tree/master/examples) 包含数百个可以立即使用的 Webpack 配置，按主题和目的分类。还额外提供了一个 [Webpack 配置生成器](https://webpack.jakoblind.no/)，可以生成基本配置文件。

*   [awesome-webpack](https://github.com/webpack-contrib/awesome-webpack) 是一个实用的 Webpack 资源，库和工具的精选列表，包括 Angular、React 和框架无关项目的文章、视频、课程、书籍和示例。

#### 10. 默认使用渐进增强

保持 [渐进增强](https://www.aaron-gustafson.com/notebook/insert-clickbait-headline-about-progressive-enhancement-here/) 作为前端架构和部署的指导原则是一个安全的选择。首先设计和构建核心体验，然后使用高级特性为支持的浏览器提升体验，创建 [弹性](https://resilientwebdesign.com/) 体验。如果你的网站在一台拥有着差劲网络、屏幕以及浏览器的慢速机器上运行的很快，那么它在一台拥有强力网络和浏览器的快速机器上只会运行地更快。

#### 11. 选择一个高性能基准

有很多未知因素影响加载——网络，热量限制，第三方脚本，缓存替换，解析器阻塞模式，磁盘 I/O，IPC 延迟，已安装的扩展，杀毒软件和防火墙，后台 CPU 任务，硬件和内存限制，L2/L3 缓存的差异和 RTTS 等。[JavaScript 的成本最高](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)，此外默认情况下阻塞渲染的 web 字体以及图像也经常消耗过多内存。随着性能瓶颈[从服务器转移到客户端](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/)，作为开发人员，我们必须更详细地考虑所有这些未知因素。

由于 170KB 的预算已经包含关键路径 HTML/CSS/JavaScript、路由、状态管理、实用程序、框架和应用程序逻辑，我们必须彻底审核我们选择不同框架的 [网络传输成本，解析/编译时间和运行时成本](https://www.twitter.com/kristoferbaxter/status/908144931125858304)。

正如 Seb Markbåge [所指出的](https://twitter.com/sebmarkbage/status/829733454119989248)，衡量框架启动成本的一个好方法是首先渲染一个视图，然后将其删除后重新渲染，因为它能告诉你框架如何压缩。首次渲染趋向于唤醒一堆懒洋洋的编译代码，一个更大的树可以在压缩时收益。第二次渲染基本上模拟了随着页面复杂性的提升，页面代码是如何重用影响性能特征的。

[!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/39c247a9-223f-4a6c-ae3d-db54a696ffcb/tti-budget-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani（幻灯片 18, 19）。

#### 12. 评估每个框架以及它们的依赖项

现在，[并非每个项目都需要框架](https://twitter.com/jaffathecake/status/923805333268639744)，而且[不是每个单页应用的页面都需要加载框架](https://medium.com/dev-channel/a-netflix-web-performance-case-study-c0bcde26a9d9)。在 Netflix 的案例中，“删除 React，几个库以及对应的客户端代码将 JavaScript 总量减少了 200KB 以上，导致 [Netflix 登出主页的交互时间缩短了 50% 以上]((https://news.ycombinator.com/item?id=15567657))。”然后，团队利用用户在目标网页上花费的时间为用户可能使用的后续网页预读取 React（[详情请继续阅读](https://jakearchibald.com/2017/netflix-and-react/)）。

这听起来很明显但是值得一提：一些项目也可以[从完全删除现有框架中收益]((https://twitter.com/jaffathecake/status/925320026411950080))。一旦选择了一个框架，你将至少使用它好几年，所以如果你需要使用它，请确保你的选择得到了[充分的考虑](https://medium.com/@ZombieCodeKill/choosing-a-javascript-framework-535745d0ab90#.2op7rjakk)。

Inian Parameshwaran [测量了排名前 50 的框架的性能足迹](https://youtu.be/wVY3-acLIoI?t=699)（针对[首次内容渲染](https://developers.google.com/web/tools/lighthouse/audits/first-contentful-paint)——从导航到浏览器从 DOM 渲染第一部分内容的时间）。Inian 发现，单独来说，Vue 和 Preact 是最快的——无论是桌面端还是移动端，其次是 React（[幻灯片](https://drive.google.com/file/d/1CoCQP7qyvkSQ4VG9L_PTWD5AF9wF28XT/view)）。你可以检查你的候选框架和它建议的体系结构，并研究大多数解决方案如何执行，例如平均而言，使用服务端渲染或者客户端渲染。

基线性能成本很重要。根据 Ankur Sethi 的一项研究，“无论你对它的优化程度如何，你的 React 应用程序在印度的普通手机上的加载时间绝对不会低于 1.1 秒。你的 Angular 应用程序始终需要至少 2.7 秒才能启动。你的 Vue 应用程序的用户需要等待至少 1 秒才能开始使用它。”无论如何，你可能不会讲印度定位为主要市场，但是网络不佳的用户在访问你的网站是会获得类似的体验。作为交换，你的团队当然可以获得可维护性和开发人员效率。但这种考虑值得商榷。

你可以通过探索功能、可访问性、稳定性、性能、包生态系统、社区、学习曲线、文档、工具、跟踪记录和团队来评估 Sacha Greif 的[12 点量表评分系统](https://medium.freecodecamp.org/the-12-things-you-need-to-consider-when-evaluating-any-new-javascript-library-3908c4ed3f49) 中的框架（或者任何其他 JavaScript 库）。但是在艰难的时间表上，在选择一个选项之前，最好至少考虑大小 + 初始解析时间的总成本；轻量级选项，如 [Preact](https://github.com/developit/preact)、[Inferno](https://github.com/infernojs/inferno)、[Vue](https://vuejs.org/)、[Svelte](https://svelte.technology/) 或者 [Polymer](https://github.com/Polymer/polymer)，都可以很好地完成工作。基线的大小将定义应用程序代码的约束。

一个很好的起点是为你的应用程序选择一个好的默认堆栈。[Gatsby.js](http://gatsbyjs.org/)（React）、[Preact CLI](https://github.com/developit/preact-cli) 以及 [PWA Starter Kit](https://github.com/Polymer/pwa-starter-kit) 为中等移动硬件上的快速加载提供了合理的默认值。

[![JavaScript processing times in 2018 by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/53363a80-48ae-4f91-aed0-69d292e6d7a2/2018-js-processing-times.png)](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4) 

（图片来源：[Addy Osmani](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)）（[大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/53363a80-48ae-4f91-aed0-69d292e6d7a2/2018-js-processing-times.png)）

#### 13. 考虑使用 PRPL 模式以及应用程序 shell 架构

不同的框架会对性能产生不同的影响，并且不需要不同的优化策略，因此你必须清楚地了解你将依赖的框架的所有细节。构建 Web 应用程序时，请查看 [PRPL模式](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) 和 [应用程序 shell 体系结构](https://developers.google.com/web/updates/2015/11/app-shell)。这个想法非常简单：推送初始路由交互所需的最少代码，以便快速渲染，然后使用 service worker 进行缓存和预缓存资源，然后异步地延迟加载所需的路由。

[![PRPL Pattern in the application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bb4716e5-d25b-4b80-b468-f28d07bae685/app-build-components-dibweb-c-scalew-879-opt.png)](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)

[PRPL](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) 代表按需推送关键资源，渲染初始路由，预缓存与按需求延迟加载剩余路由。

[![Application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6423db84-4717-4aeb-9174-7ae96bf4f3aa/appshell-1-o0t8qd-c-scalew-799-opt.jpg)](https://developers.google.com/web/updates/2015/11/app-shell)

应用程序 shell 是驱动用户界面所需要的最少 HTML、CSS 和 JavaScript。 

#### 14. 你是否优化了各个 API 的性能？

API 是应用程序通过所谓的端点向内部和第三方应用程序公开数据的通信通道。在 [设计和构建 API 时](https://www.smashingmagazine.com/2012/10/designing-javascript-apis-usability/)，我们需要一个合理的协议来启动服务器和第三方请求之间的通信。[Representational State Transfer](https://www.smashingmagazine.com/2018/01/understanding-using-rest-api/)（[**REST**](http://web.archive.org/web/20130116005443/http://tomayko.com/writings/rest-to-my-wife)）是一个合理的成熟选择：它定义了开发人员遵循的一组约束，以便以高性能，可靠和可扩展的方式访问内容。符合 REST 约束的 Web 服务称为 **RESTful Web 服务**。

HTTP 请求成功时，当从 API 检索数据，服务器响应中的任何延迟都将传播给最终用户，从而延迟渲染。当资源想要从 API 检索某些数据时，它将需要从相应的端点请求数据。从多个资源渲染数据的组件（例如，在每个评论中包含评论和作者照片的文章）可能需要多次往返服务器以在渲染之前获取所有数据。此外，通过 REST 返回的数据量通常大于渲染该组件所需的数据量。

如果许多资源需要来自 API 的数据，API 可能会成为性能瓶颈。[GraphQL](https://graphql.org/) 为这些问题提供了高性能的解决方案。本身，GraphQL 是 API 的查询语句，是一个使用你为数据定义的类型系统执行查询的服务端运行时。与 REST 不同，GraphQL 可以在单个请求中检索所有数据，并且响应将完全符合要求，而不会像 REST 那样**过多**或**过少**读取数据。

此外，由于 GraphQL 使用 schema（描述数据结构的元数据），它已经可以将数据组织到首选结构中，因此，例如，[使用 GraphQL，我们可以删除用于处理状态管理的 JavaScript 代码](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d)，生成更简洁的应用程序代码，可以在客户端上运行得更快。

如果你想开始使用 GraphQL，Eric Bear 在 Smashing 杂志上发表了两篇精彩的文章：[A GraphQL Primer: Why We Need A New Kind Of API](https://www.smashingmagazine.com/2018/01/graphql-primer-new-api-part-1/) 以及 [A GraphQL Primer: The Evolution Of API Design](https://www.smashingmagazine.com/2018/01/graphql-primer-new-api-part-2/)（**感谢提示，Leonardo**）。

[![Hacker Noon](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5fda8d85-1151-4d0b-b2f6-da354ebae345/redux-rest-apollo-graphql.png)](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d) 

REST 和 GraphQL 之间的区别，就如左图 Redux + REST 之间的对话与右图 Apollo + GraphQL 的对话的区别（图片来源：[Hacker Noon](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d)）（[大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5fda8d85-1151-4d0b-b2f6-da354ebae345/redux-rest-apollo-graphql.png)）

#### 15. 你会使用 AMP 或 Instant Articles 吗？

根据你的组织的优先级和策略，你可能需要考虑使用 Google 的 [AMP](https://www.ampproject.org/) 或者 Facebook 的 [Instant Articles](https://instantarticles.fb.com/) 或者 Apple 的 [Apple News](https://www.apple.com/news/)。如果没有它们，你也获得良好的性能，但 AMP 确实提供了一个可靠的性能框架和免费的内容分发网络（CDN），而 Instant Articles 将提高你在 Facebook 上的可见性和性能。

对于用户来说，这些技术最直观的的好处是保证了性能。 所以比起“正常“的和可能膨胀的页面，有时用户甚至更喜欢 AMP/Apple News/Instant Pages 链接。对于处理大量第三方内容的内容繁重的网站，这些选项可能有助于大幅加快渲染时间。

[除非他们不这样做](https://timkadlec.com/remembers/2018-03-19-how-fast-is-amp-really/)。例如，根据 Tim Kadlec的说法，“AMP 文档往往比同行更快，但并不一定意味着页面具有高性能。在性能方面，AMP 不是最大的差异。”

站长的好处显而易见：这些格式在各自平台上的可发现性以及[搜索引擎的可见性提高](https://ethanmarcotte.com/wrote/ampersand/)。你也可以通过重复使用 AMP 作为 PWA 的数据源来[构建渐进式 web APM](https://www.smashingmagazine.com/2016/12/progressive-web-amps/)。至于缺点？显然，因为各个平台的不同的要求和限制，开发人员需要对他们的内容，在不同平台制作和维护不同的版本，如果是 Instant Articles 和 Apple News [没有实际的URL](https://www.w3.org/blog/TAG/2017/07/27/distributed-and-syndicated-content-whats-wrong-with-this-picture/)（感谢 Addy，Jeremy）。

#### 16. 明智地选择你的 CDN

根据你拥有的动态数据量，你可以将内容的某些部分“外包”到 [静态站点生成器](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)，将其推送到 CDN 并从中提供静态版本，从而避免数据库请求。你甚至可以选择基于 CDN 的[静态托管平台](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/)，通过交互式组件丰富你的页面作为增强功能（[JAMStack](https://jamstack.org/)）。事实上，其中一些生成器（如 Reats 之上的 [Gatsby](https://www.gatsbyjs.org/blog/2017-09-13-why-is-gatsby-so-fast/)）实际上是[网站编译器](https://tomdale.net/2017/09/compilers-are-the-new-frameworks/)，提供了许多自动优化功能。随着编译器随着时间的推移添加优化，编译后的输出随着时间的推移变得越来越小，越来越快。

请注意，CDN 也可以提供（和卸载）动态内容。因此，不必将CDN限制为只有静态文件。仔细检查你的 CDN 是否执行压缩和转换（例如，在格式，压缩和边缘大小调整方面的图像优化），对 [服务器端工作者](https://www.filamentgroup.com/lab/servers-workers.html) 的支持，包括边缘，在 CDN 边缘组装页面的静态和动态部分（即最接近用户的服务器）和其他任务。

注意：基于 Patrick Meenan 和 Andy Davies 的研究，HTTP/2 [在许多 CDN 上被破坏](https://github.com/andydavies/http2-prioritization-issues#cdns--cloud-hosting-services)，所以我们不应该对那里的性能提升过于乐观。

> - [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> - **[译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)**
> - [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> - [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> - [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> - [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
