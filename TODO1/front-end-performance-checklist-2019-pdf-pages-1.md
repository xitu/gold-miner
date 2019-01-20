> * 原文地址：[Front-End Performance Checklist 2019 — 1](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> * 译者：[Hopsken](https://juejin.im/user/57e766e42e958a00543d99ae)
> * 校对者：[SHERlocked93](https://github.com/SHERlocked93), [ElizurHz](https://github.com/ElizurHz)

# 2019 前端性能优化年度总结 — 第一部分

让 2019 来得更迅速吧~你正在阅读的是 2019 年前端性能优化年度总结，始于 2016。

**当我们在讨论前端性能时我们在谈些什么？**性能的瓶颈又**到底**在哪儿？是昂贵的 JavaScript 开销，耗时的网络字体下载，超大的图片还是迟钝的页面渲染？摇树（tree-shaking）、作用域提升（scope hoisting）、代码分割（code-splitting），以及各种酷炫的加载模式，包括交叉观察者模式（intersection observer）、服务端推送（server push）、客户端提示（clients hints）、HTTP/2、service worker 以及 edge worker，研究这些真的有用吗？还有，最重要的，当我们着手处理前端性能的时候，**我们该从哪里开始**，该如何去建立一个长期的性能优化体系？

早些时候，性能都是所谓的“**后顾之忧**”。直到项目快结束的时候，它会被归结为代码压缩（minification）、拼接（concatenation）、静态资源优化（asset optimization）以及几行服务器配置的调整。现在回想一下，情况似乎已经全然不同了。

性能问题不仅仅是技术上的考量，当它被整合进工作流时，在设计的决策中也需要考量性能的因素。**性能需要持续地被检测、监控和优化。**同时，网络在变得越来越复杂，这带来了新的挑战，简单的指标追踪变得不再可行，因为不同的设备、浏览器、协议、网络类型和延迟都会使指标发生明显变化。（CDN、ISP、缓存、代理、防火墙、负载均衡和服务器，这些都得考虑进去。） 

因此，如果我们想囊括关于性能提升的所有要点 — 从一开始到网站最后发布，那么最终这个清单应该长啥样呢？以下是一份（但愿是无偏见的、客观的）**2019 前端性能优化年度总结**，“介是你没有看过的船新版本”，它几乎包括所有你需要考虑的要点，来确保你的网站响应时间够短、用户体验够流畅、同时不会榨干用户的带宽。

> **[译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)**
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### 目录

- [起步：计划与指标](#起步计划与指标)
  - [1. 建立性能评估规范](#1-建立性能评估规范)
  - [2. 目标：比你最快的竞争对手快至少 20%](#2-目标比你最快的竞争对手快至少-20)
  - [3. 选择合适的指标](#3-选择合适的指标)
  - [4. 在目标用户的典型设备上收集数据](#4-在目标用户的典型设备上收集数据)
  - [5. 为测试设立“纯净”、“接近真实用户”的浏览器配置](#5-为测试设立纯净接近真实用户的浏览器配置profile)
  - [6. 与团队其他成员分享这份清单](#6-与团队其他成员分享这份清单)

### 起步：计划与指标

对于持续跟踪性能，“微优化”（micro-optimization）是个不错的主意，但是在脑子里有个明晰的目标也是很必要的 — **量化的**目标会影响过程中采取的所有决策。有许多不同的模型可以参考，以下讨论的都基于我个人主观偏好，请根据个人情况自行调整。

#### 1. 建立性能评估规范

在很多组织里面，前端开发者都确切地知道哪有最有可能出现问题，以及应该使用何种模式来修正这些问题。然而，由于性能评估文化的缺失，每个决定都会成为部门间的战场，使组织分裂成孤岛。要想获得业务利益相关者的支持，你需要通过具体案例来说明：页面速度会如何影响业务指标和他们所关心的 **KPI**。

没有开发、设计与业务、市场团队的通力合作，性能优化是走不远的。研究用户抱怨的常见问题，再看看如何通过性能优化来缓解这些问题。

同时在移动和桌面设备上运行性能基准测试，由公司真实数据得到定制化的案例研究（case study）。除此以外，你还可以参考 [WPO Stats](https://wpostats.com/) 上展示的性能优化案例研究及其实验数据来提升自己对性能优化的敏感性，了解为什么性能表现如此重要，它对用户体验和业务指标会产生哪些影响。光是明白性能表现很重要还不够，你还得设立量化的、可追溯的目标，时刻关注它们。

那么到底该怎么做呢？在 Allison McKnight 名为 [Building Performance for the Long Term](https://vimeo.com/album/4970467/video/254947097) 的演讲中，她详细地分享了自己如何在 Etsy 建立性能评估文化的[案例](https://speakerdeck.com/aemcknig/building-performance-for-the-long-term)。

[![Brad Frost and Jonathan Fielding’s Performance Budget Calculator](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7191d628-f0a1-490c-afca-c8abcdfd4823/brad-perf-budget-builder.png)](http://bradfrost.com/blog/post/performance-budget-builder/) 

Brad Frost 的 [Performance budget builder](http://bradfrost.com/blog/post/performance-budget-builder/) 和 Jonathan Fielding 的 [Performance Budget Calculator](http://www.performancebudget.io/) 可以帮助你建立性能预算并将其可视化表示出来。（[预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7191d628-f0a1-490c-afca-c8abcdfd4823/brad-perf-budget-builder.png)）

#### 2. 目标：比你最快的竞争对手快至少 20%

根据[一项心理学研究](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule)，如果你希望你的用户感觉到你们的网站用起来比竞争对手快，那么你需要比他们快**至少** 20%。研究你的主要对手，收集他们的网站在移动和桌面设备上的性能指标，确定超越他们的最低要求。为了得到准确的结果和目标，首先去研究你们产品的用户行为，之后模仿 90% 用户的行为来进行测试。
    
为了更好地了解你的对手的性能表现，你可以使用 [Chrome UX Report](https://web.dev/fast/chrome-ux-report)（**CrUX**，一组现成的 RUM 数据集，[Ilya Grigorik 的视频介绍](https://vimeo.com/254834890))，[Speed Scorecard](https://www.thinkwithgoogle.com/feature/mobile/)（可同时估算性能优化将如何影响收入），[真实用户体验测试比较（Real User Experience Test Comparison）](https://ruxt.dexecure.com/compare)或者 [SiteSpeed CI](https://www.sitespeed.io/)（基于集成测试）。

**注意**：如果你使用 [Page Speed Insights](https://developers.google.com/speed/pagespeed/insights/)（是的，它还没被抛弃），你可以得到指定页面详细的 CrUX 性能数据，而不是只有一些粗略的综合数据。在为具体页面（如“首页”、“产品列表页面”）设立性能目标时，这些数据会非常有用。另外，如果你正在使用 CI 来监测性能预算，当使用 CrUX 来确立目标时，你需要确保测试环境与 CrUX 一致。（**感谢 Patrick Meenan！**)

收集数据，建立一个[表格](http://danielmall.com/articles/how-to-make-a-performance-budget/)，削减掉 20%，以此建立你的目标**性能预算**。那么现在你有了量化的对照组样本。事情正逐步走向正轨，只要你时刻把这份预算记在心里，并且每次都交付尽可能少的代码以缩短可交互时间。

需要些资料来上手？

*   Addy Osmani 写了一篇非常详细的文章解释[如何开始做性能预算](https://medium.com/@addyosmani/start-performance-budgeting-dabde04cf6a3)，如何量化新特性带来的影响，以及当超出预算时，你应该怎么做。

*   Lara Hogan 有[一份考虑到性能预算时的产品设计指南](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget)，可以对设计师们提供一些有用的提示。

*   Jonathan Fielding 的 [Performance Budget Calculator](http://www.performancebudget.io/)，Brad Frost 的 [Performance Budget Builder](https://codepen.io/bradfrost/full/EPQVBp/) 和 [Browser Calories](https://browserdiet.com/calories/) 可以在建立预算上提供帮助。（感谢 [Karolina Szczur](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3) 的提醒）

*   另外，通过建立带有报告打包体积图表的仪表盘，来**可视化**展示性能预算和当前的性能指标。有很多工具可以帮你做到这一点，[SiteSpeed.io dashboard](https://www.peterhedenskog.com/blog/2015/04/open-source-performance-dashboard/)（开源），[SpeedCurve](http://speedcurve.com/) 和 [Calibre](https://calibreapp.com/) 只是其中几个，你可以在 [perf.rocks](http://perf.rocks/tools/) 找到更多工具。

一旦确立好合适的性能预算，你就可以借助 [Webpack Performance Hints and Bundlesize](https://web.dev/fast/incorporate-performance-budgets-into-your-build-tools)、[Lightouse CI](https://web.dev/fast/using-lighthouse-ci-to-set-a-performance-budget), [PWMetrics](https://github.com/paulirish/pwmetrics)、[Sitespeed CI](https://www.sitespeed.io/) 把它们整合进打包流程中，在请求合并时强制检测性能预算，并在 PR 备注中注明得分记录。如果你需要个性化定制，你可以使用 [webpagetest-charts-api](https://github.com/trulia/webpagetest-charts-api)，它提供了一系列可以从 WebPagetest 的结果生成图表的 API。

举个例子，正如 [Pinterest](https://medium.com/@Pinterest_Engineering/a-one-year-pwa-retrospective-f4a2f4129e05) 一样，你可以创建一个自定义的 **eslint** 规则，禁止导入重依赖（dependency-heavy）的文件和目录，从而避免打包文件变得臃肿。设定一个团队内共享的“安全”依赖包列表。

除了性能预算外，仔细考虑那些对你们业务价值最大的关键用户操作。规定并讨论可接受的**关键操作响应时间阈值**，并就“UX 就绪”耗时评分在团队内达成共识。大多数情况下，用户的操作流程会涉及到许多不同公司部门的工作，因此，就“时间阈值”达成共识可以为今后关于性能的沟通提供支持，避免不必要的讨论。确保对新增资源和功能带来的资源开销了如指掌。

另外，正如 Patrick Meenan 提议的，在设计过程中，**规划好加载的顺序和取舍**是绝对值得的。如果你预先规划好哪部分更重要，并确定每部分出现的顺序，那么同时你也会知道哪些部分可以延迟加载。理想情况下，这个顺序也会反映出 CSS 和 JavaScript 文件的导入顺序，因此在打包阶段处理它们会变得更容易些。除此以外，还得考虑页面加载时中间态的视觉效果（比方说，当网络字体还没有加载完全时）。

**规划，规划，规划。**尽管在早期就投入那些能起到立竿见影效果的优化似乎相当有吸引力 — 这对需要快速决胜的项目而言可能是个不错的策略，但是如果没有务实的规划和因地制宜的性能指标，很难保证性能优先能一直受到重视。

首次绘制（First Paint）、首次有内容绘制（First Contentful Paint）、首次有意义绘制（First Meaningful Paint）、视觉完备（Visual Complete）、首次可交互时间（Time To Interactive）的区别。[完整文档](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)。版权：[@denar90](https://docs.google.com/presentation/d/1D4foHkE0VQdhcA5_hiesl8JhEGeTDRrQR4gipfJ8z7Y/present?slide=id.g21f3ab9dd6_0_33)

#### 3. 选择合适的指标

[并不是所有的指标都同等重要](https://speedcurve.com/blog/rendering-metrics/)。研究哪个指标对你的应用最重要，通常来说它应该与开始渲染**你的产品中最重要的那些像素**的速度以及提供输入响应所需的时间相关。这个要点将为你指明最佳的优化目标，提供努力的方向。

不管怎样，不要总是盯着页面完整载入的时间（比方说 `onload` 和 `DOMContentLoaded`），要站在用户的角度去看待页面加载。也就是说，需要关注一组稍微不同的指标。事实上，“选择正确的指标”是没有绝对完美方案的。

根据 Tim Kadlec 的研究和 Marcos Iglesias 在[他的演讲](https://docs.google.com/presentation/d/e/2PACX-1vTk8geAszRTDisSIplT02CacJybNtrr6kIYUCjW3-Y_7U9kYSjn_6TbabEQDnk9Ao8DX9IttL-RD_p7/pub?start=false&loop=false&delayms=10000&slide=id.g3ccc19d32d_0_98)中提到的，传统的指标可以归为几种类型。通常，我们需要所有的指标来构建完整的性能画像，但是在特定场景中，某些指标可能比其他的更重要些。

*   **基于数量的指标**衡量请求数量、权重和性能评分等。对于告警和监控长期变化很有用，但对理解用户体验帮助不大。

*   **里程碑式指标**使用加载过程中的各个状态来标记，比如：**首位字节时间（Time To First Byte）**和**首次可交互时间（Time To Interactive）**。对于描述用户体验和指标很有用，但对了解加载过程中的情况帮助不大。

*   **渲染指标**可以估计内容渲染的时间，例如**渲染开始时间（Start Render）**和**速度指数（Speed Index）**。对于检测和调整渲染性能很有用，但对检测**重要**内容何时出现、何时可交互帮助不大。

*   **自定义指标**衡量某个特定的、个性化的用户事件，比如 Twitter 的[首次发推时间（Time To First Tweet）](https://blog.alexmaccaw.com/time-to-first-tweet)，Pinterest 的 [收藏等待时间（PinnerWaitTime）](https://medium.com/@Pinterest_Engineering/driving-user-growth-with-performance-improvements-cfc50dafadd7)。对准确描述用户体验很有用，但不方便规模化以及与竞品比较。

为了使性能画像更加完整，我们通常会在所有类型中都选择一些有用的指标。一般来说，最重要的是以下几个：

*   [首次有效绘制（First Meaningful Paint，FMP）](https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint)
    
    反映主要内容出现在页面上所需的时间，也侧面反映了服务器输出**任意**数据的速度。FMP 时间过长一般意味着 JavaScript 阻塞了主线程，也有可能是后端/服务器的问题。

*   [首次可交互时间（Time to Interactive，TTI）](https://calibreapp.com/blog/time-to-interactive/)
    
    在此时间点，页面布局已经稳定，主要的网络字体已经可见，主线程已可以响应用户输入 — 基本上意味着只是用户可以与 UI 进行交互。是描述“网站可正常使用前，用户所需要**等待**的时长”的关键因素。

*   [首次输入延迟（First Input Delay，FID 或 Input responsiveness）](https://developers.google.com/web/updates/2018/05/first-input-delay)
    
    从用户首次与页面交互，到网站能够响应该交互的时间。与 TTI 相辅相成，补全了画像中缺少的一块：在用户切实与网站交互后发生了什么。标准的 RUM 指标。有一个 [JavaScript 库](https://github.com/GoogleChromeLabs/first-input-delay) 可以在浏览器中测量 FID 耗时。

*   [速度指数（Speed Index）](https://dev.to/borisschapira/web-performance-fundamentals-what-is-the-speed-index-2m5i)  
    
    衡量视觉上页面被内容充满的速度，数值越低越好。速度指数由视觉上的加载速度计算而得，只是一个计算值。同时对视口尺寸也很敏感，因此你需要根据目标用户设定测试配置的范围。（感谢 [Boris](https://twitter.com/borisschapira)！）

*   CPU 耗时
    
    描述主线程处理有效负载时繁忙程度的指标，显示在绘制、渲染、运行脚本和加载时，主线程被阻塞的频次和时长。高的 CPU 耗时明显地意味着**卡顿的**用户体验。利用 WebPageTest，你可以[在 “Chrome” 标签页上选择 “Capture Dev Tools Timeline” 选项](https://deanhume.com/ten-things-you-didnt-know-about-webpagetest-org/)来暴露出可能的主线程崩溃（得益于 WebPageTest 可以在任何设备上运行）。

*   [广告的影响（Ad Weight Impact）](https://calendar.perfplanet.com/2017/measuring-adweight/)  
    
    如果你的站点的利润主要来源于广告，那么追踪广告相关代码的体积就很有用了。Paddy Ganti 的[脚本](https://calendar.perfplanet.com/2017/measuring-adweight/)可以构筑两条 URL（一条有广告，一条没有），并且利用 WebPageTest 生成一个比较视频，并显示区别。

*   偏离度指标（Deviation metrics）
    
    正如 [Wikipedia 的工程师所指出的](https://phabricator.wikimedia.org/phame/live/7/post/117/performance_testing_in_a_controlled_lab_environment_-_the_metrics/)，你的结果中数据的变化在一定程度上可以反映出设施的可靠性，以及你该花多少精力来关注这些偏离度和极端值。过大的变化意味着你很可能需要对目前设施的配置做一些调整，它也能帮助我们了解有某些页面是难以可靠地用指标衡量的，例如因为第三方脚本而导致的明显变化。另外，追踪浏览器版本也是个不错的主意，它可能帮助你获悉新版浏览器可以带来的性能变化。

*   [自定义指标（Custom metrics）](https://speedcurve.com/blog/user-timing-and-custom-metrics/)  
    
    自定义指标可由具体业务和用户体验的需要专门设置。它需要你对**重要**像素、**关键**脚本、**必要** CSS 样式和**相关**静态资源有个清晰的概念，并能够测算用户需要多长时间来下载它们。关于这点，你可以使用 [Hero Rendering Times](https://speedcurve.com/blog/web-performance-monitoring-hero-times/) 或 [Performance API](https://css-tricks.com/breaking-performance-api/)，为重要业务事件创建时间戳。另外，你也可以通过在 WebPageTest 测试完成后运行自定义的脚本来[收集自定义的指标](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/custom-metrics)。

Steve Souders 写了[一篇文章](https://speedcurve.com/blog/rendering-metrics/)详细地介绍了各个指标。需要注意的是：首次交互时间是在**实验环境**下通过自动化审查得到的，而首次输入延迟则表示**真实**用户在使用中感受到的**实际**延迟。总而言之，始终观测和追踪这两个指标会是个好主意。

不同的应用，偏好的指标可能会不同。举个例子，对于 Netflix TV 的 UI 界面而言，[关键输入响应、内存使用和首次可交互时间]((https://medium.com/netflix-techblog/crafting-a-high-performance-tv-user-interface-using-react-3350e5a6ad3b))会更重要些，而对于 Wikipedia，[首末视觉变化和 CPU 耗时指标](https://phabricator.wikimedia.org/phame/live/7/post/117/performance_testing_in_a_controlled_lab_environment_-_the_metrics/)会显得更重要些。

**注意**：FID 和 TTI 都不关心滚动表现。滚动事件可以独立发生，因为它是主线程外的。因此，对于许多内容为主的站点而言，这些指标可能并不是很重要。（**感谢 Patrick！**）。

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5d80f91c-9807-4565-b616-a4735fcd4949/network-requests-first-input-delay.png)](https://twitter.com/__treo/status/1068163152783835136) 

以用户为中心的性能指标可以帮助更好地了解真实用户体验。[首次输入延迟（FID）](https://developers.google.com/web/updates/2018/05/first-input-delay)是一个尝试去实现这一目标的新指标。（[戳此了解详情](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5d80f91c-9807-4565-b616-a4735fcd4949/network-requests-first-input-delay.png)）

#### 4. 在目标用户的典型设备上收集数据

为了得到准确的数据，我们需要选择合适的测试设备。[Moto G4](https://twitter.com/katiehempenius/statuses/1067969800205422593) 会是一个不错的选择，或者是 Samsung 的一款中端产品，又或者是一款如 Nexus 5X 一样中庸的设备，以及 Alcatel 1X 这样的低端设备。你可以在 [open device lab](https://www.smashingmagazine.com/2016/11/worlds-best-open-device-labs/) 找到这些。如果想在更慢的设备上测试，你可以花差不多 $100 买一台 Nexus 2。

如果你手上没有合适的设备，你可以通过网络限速（比如：150ms RTT，下行 1.5Mbps，上行 0.7Mbps）以及 CPU 限速（慢 5 倍）在电脑上模拟移动端体验。然后，再切换到普通 3G、4G 和 WIFI 网络进行测试。为了使性能影响更加明显，你甚至可以引入 [2G 星期二](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)，或者为了更方便测试，在办公室[限制 3G 网络](https://twitter.com/thommaskelly/status/938127039403610112)。

时刻记着：在移动设备上，运行速度应该会比在桌面设备上慢 4-5 倍。移动设备具有不同的 GPU、CPU、内存、电池特性。如果说慢速网络制约了下载时间的话，那么手机较为慢速的 CPU 则制约了解析时间。事实上，移动设备上的解析时间通常要比桌面设备[长 36%](https://github.com/GoogleChromeLabs/discovery/issues/1)。因此，一定要[在一部平均水准的设备上进行测试](https://www.webpagetest.org/easy) — 一部你的用户中最具代表性的设备。

[![Introducing the slowest day of the week](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dfe1a4ec-2088-4e39-8a39-9f2010380a53/tuesday-2g-opt.png)](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)

在一周中选择一天让网速变慢。Facebook 就有 [2G 星期二](https://www.theverge.com/2015/10/28/9625062/facebook-2g-tuesdays-slow-internet-developing-world)来提高对低速网络的关注。（[图片来源](http://www.businessinsider.com/facebook-2g-tuesdays-to-slow-employee-internet-speeds-down-2015-10?IR=T)）

幸运的是，有很多工具可以帮你自动化完成数据收集、评估上述性能指标随时间变化趋势。记住，一个好的性能画像应该包括一套完整的性能指标、[实验数据和实际数据](https://developers.google.com/web/fundamentals/performance/speed-tools/)。

*   **集成测试工具**可以在预先规定了设备和网络配置的可复制环境中收集**实验数据**。例如：**Lighthouse**、**WebPageTest**
*   **真实用户监测（RUM）**工具可以持续评估用户交互，收集实际数据。例如，**SpeedCurve**、**New Relic**，两者也都提供集成测试工具。

前者在**开发阶段**会非常有用，它可以帮助你在开发过程中发现、隔离、修复性能问题。后者在**维护阶段**会很有用，它可以帮助你了解性能瓶颈在哪儿，因为这都是真实用户产生的数据。

通过深入了解浏览器内置的 RUM API，如 [Navigation Timing](https://developer.mozilla.org/en-US/docs/Web/API/Navigation_timing_API)、[Resource Timing](https://developer.mozilla.org/en-US/docs/Web/API/Resource_Timing_API)、[Paint Timing](https://css-tricks.com/paint-timing-api/)、[Long Tasks](https://w3c.github.io/longtasks/) 等，集成测试和 RUM 两者搭配构建出完整的性能画像。你可以使用 [PWMetrics](https://github.com/paulirish/pwmetrics)、[Calibre](https://calibreapp.com), [SpeedCurve](https://speedcurve.com/)、[mPulse](https://www.soasta.com/performance-monitoring/) 和 [Boomerang](https://github.com/yahoo/boomerang)、[Sitespeed.io](https://www.sitespeed.io/) 来进行性能监测，它们都是不错的选择。另外，利用 [Server Timing header](https://www.smashingmagazine.com/2018/10/performance-server-timing/)，你甚至可以同时监测后端和前端性能。

**注意**: 建议使用浏览器外部的[网络节流器](https://calendar.perfplanet.com/2016/testing-with-realistic-networking-conditions/)，因为浏览器的 DevTools 可能会存在一些问题，比如：由于实现方法的原因，HTTP/2 push 可能会有问题。（感谢 Yoav 和 Patrick！）对于 Mac OS，我们可以用 [Network Link Conditioner](https://nshipster.com/network-link-conditioner/)；对于 Windows，可以用 [Windows Traffic Shaper](https://github.com/WPO-Foundation/win-shaper/releases)；对于 Linux，可以用 [netem](https://wiki.linuxfoundation.org/networking/netem)；对于 FreeBSD，可以用[dummynet](http://info.iet.unipi.it/~luigi/dummynet/)。

[![Lighthouse](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a85a91a7-fb37-4596-8658-a40c1900a0d6/lighthouse-screenshot.png)](https://developers.google.com/web/tools/lighthouse/) 

[Lighthouse](https://developers.google.com/web/tools/lighthouse/) — DevTools 自带的性能审查工具。

#### 5. 为测试设立“纯净”、“接近真实用户”的浏览器配置（Profile）

使用被动监控工具进行测试时，一个常见的做法是：关闭反病毒软件和 CPU 后台任务，关闭后台网络连接，使用没有安装任何插件的“干净的”浏览器配置，以避免结果失真。（[Firefox](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Multiple_profiles)、[Chrome](https://support.google.com/chrome/answer/2364824?hl=en&co=GENIE.Platform=Desktop))。

然而，了解你的用户通常会使用哪些插件也是个不错的主意，然后使用精心设计的“**接近真实用户的**”浏览器配置进行测试。事实上，某些插件可能会给你的应用带来[显著的性能影响](https://twitter.com/denar90_/statuses/1065712688037277696)。如果你有很多用户在使用这些插件，你可能需要考虑这些影响。“干净的”用户浏览器配置可能有些过于理想化了，可能会与实际情况大相径庭。

#### 6. 与团队其他成员分享这份清单

确保你的每一位同事都充分熟悉这份清单，从而避免在以后出现误解。每一个决策都会带来性能影响，整个项目会从前端开发者正确地对待性能问题而获益良多，从而使得团队中的每一个人都负起责任来，而不仅仅只是前端。根据性能预算和清单中定义的优先级来制定设计决策。

> **[译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)**
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
