> * 原文地址：[Google 的 Pagespeed 的工作原理：提升你的分数和搜索引擎排名](https://calibreapp.com/blog/how-pagespeed-works/)
> * 原文作者：[Ben Schwarz](https://calibreapp.com/blog/author/ben-schwarz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-pagespeed-works.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-pagespeed-works.md)
> * 译者：[Jerry-FD](https://github.com/Jerry-FD/)
> * 校对者：[weberpan](https://github.com/weberpan/)，[Endone](https://github.com/Endone/)

# Google 的 Pagespeed 的工作原理：提升你的页面分数和搜索引擎排名

![](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/1.png)

通过这篇文章，我们将揭开 PageSpeed 最为重要的页面速度评分的计算方法。

毫无疑问，页面的加载速度已经成了提升页面收益和降低流失率的关键性因素。由于 Google 已经将页面的加载速度列入影响其搜索排名的因素，现在更多的企业和组织都把目光聚焦在提升页面性能上了。

去年 **Google 针对他们的搜索排名算法做了两个重大的调整**：

* 三月，[搜索结果排名以移动端版本的页面为基础](https://webmasters.googleblog.com/2018/03/rolling-out-mobile-first-indexing.html)，取代之前的桌面端版本。
* [七月，SEO 排名算法](https://webmasters.googleblog.com/2018/01/using-page-speed-in-mobile-search.html)更新为，增加页面的加载速度作为影响其搜索排名的因素，如移动端页面排名[和广告排名。](https://developers.google.com/web/updates/2018/07/search-ads-speed#the_mobile_speed_score_for_ads_landing_pages)

通过这些改变，我们可以总结出两个结论：

* **手机端页面的加载速度会影响你整站的 SEO 排名。**
* 如果你的页面加载很慢，就会降低你的广告质量分，进而你的**广告费会更贵。**

Google 道：

> 更快的加载速度不仅仅会提升我们的体验；最近的数据显示，提升页面的加载速度也会降低操作成本。和我们一样，我们的用户就很重视速度 — 这就是我们决定将页面的速度这一因素，加入搜索排名计算的原因。

为了从页面性能的角度搞清楚这些变化给我们带来了什么影响，我们需要掌握这些基础知识。[PageSpeed 5.0](https://developers.google.com/speed/docs/insights/release_notes) 是之前版本的一次颠覆性的改动。现在由 Lighthouse 和 [CrUX](https://developers.google.com/web/updates/2017/12/crux) 提供技术支持（Chrome 用户体验报告部）。

**这次升级使用了新的评分算法，将会使获得 PageSpeed 高分更加困难。**

### PageSpeed 5.0 有哪些变化?

5.0 之前，PageSpeed 会针对测试的页面给出一系列指导意见。如果页面里有很大的、未经压缩的图片，PageSpeed 会建议对图片压缩。再比如，漏掉了 Cache-Headers，会建议加上。

这些建议是与一些**指导方针**对应的，如果遵从这些指导方针，**很可能**会提升你的页面性能，但这些也仅仅是表层的，它不会分析用户在真实场景下的加载和渲染页面的体验。

在 PageSpeed 5.0 中，页面在 Lighthouse 的控制下被载入到真实的 Chrome 浏览器中。Lighthouse 从浏览器中获取记录各项指标，把这些指标套入得分模型里计算，最后展示一个整体的性能分。根据具体的分数指标来给出优化的指导方针。

和 PageSpeed 类似，Lighthouse 也有一个性能分。在 PageSpeed 5.0 中，性能分直接从 Lighthouse 里获取。所以**现在 PageSpeed 的速度分和 Lighthouse 的性能分一样了。**

![Calibre 在 Google 的 Pagespeed 上获得了 97 分](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/calibre-pagespeed.png)

既然我们知道了 PageSpeed 的分数从哪里来，接下来我们就来仔细研究它是如何计算的，以及我们该如何有效的提高页面的性能。

### Google Lighthouse 是什么?

[Lighthouse](https://calibreapp.com/blog/lighthouse-reasons/) 是一个开源项目，由一只来自 Google Chrome 的优秀团队运作。在过去的几年里，它已逐步变成免费的性能分析工具。

Lighthouse 使用 Chrome 的远程调试协议来获取网络请求的信息、计算 JavaScript 的性能、评估无障碍化级别以及计算用户关注的时间指标，比如 [首次内容绘制时间 First Contentful Paint](https://calibreapp.com/docs/metrics/paint-based-metrics)、[可交互时间 Time to Interactive](https://calibreapp.com/docs/metrics/time-to-interactive) 和速度指标。

如果你想要深入了解 Lighthouse 的整体架构，请看来自官方的[教程](https://github.com/GoogleChrome/lighthouse/blob/master/docs/architecture.md)。

### Lighthouse 如何计算性能分数

在性能测试中，Lighthouse 聚焦于用户所见和用户体验，记录了很多指标。

下面这 6 个指标构成了性能分数的大体部分。他们是：

* 可交互时间 Time to Interactive (TTI)
* 速度指标 Speed Index
* 首次内容绘制时间 First Contentful Paint (FCP)
* 首次 CPU 空闲时间 First CPU Idle
* 首次有效绘制 First Meaningful Paint (FMP)
* 预计输入延迟时间 Estimated Input Latency

Lighthouse 会针对这些指标运用一个 0 – 100 的分数模型。 这个过程会收集移动端第 75 和第 90 百分位的 [HTTP 档案](https://httparchive.org/)，然后输入到`对数正太分布`函数（校对者注：这样的话只要性能数据低于 25% 的线上移动端页面，也就是排位在 75% 以下，都给 0 分，而只要比 95% 的移动端页面得分高，就得满分）。

[根据算法和可交互时间的计算所得数据](https://www.desmos.com/calculator/2t1ugwykrl)，我们可以发现，如果一个页面在 2.1 秒内成为“可交互的”，那么它的可交互时间分数指标是 92/100。

![](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/scoring-curve.png)

当每个指标完成计分后会被分配一个权重，用权重调整后算出页面整体的性能分数。权重规则如下：

| 指标                       | 权重 |
| ------------------------- | --------- |
| 可交互时间 (TTI) | 5        |
| 速度指标                    | 4         |
| 首次内容绘制时间             | 3         |
| 首次 CPU 空闲时间            | 2         |
| 首次有效绘制                 | 1         |
| 预计输入延迟时间             | 0         |

这些权重取决于每个指标对移动端用户的体验的影响程度。

在未来，这些权重在参考来自于 Chrome 用户体验报告的用户观测数据之后，还可能会被进一步优化。

你可能想知道究竟这每一个指标的权重是如何影响整体得分的。Lighthouse 团队[打造了一款实用的 Google 电子表格计算器](https://docs.google.com/spreadsheets/d/1Cxzhy5ecqJCucdf1M0iOzM8mIxNc7mmx107o5nj38Eo/edit#gid=0)来阐述具体的细节：

![这张电子表格的图片可以用来计算性能分数](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/weightings.png)

使用上面的例子，如果我们把可交互时间从 5 秒 变为 17 秒 (全球移动端平均 TTI)，我们的分数会降低到 56% (也就是 100 分之中的 56 分)。

然而，如果我们把首次内容绘制时间变为 17 秒，我们的分数会是 62%。

**可交互时间 (TTI) 是对你的性能分数影响最大的指标。**

因此，想要得到 PageSpeed 的高分，你**最需要**的是降低 TTI。

### 剑指 TTI

深入来说，有两个对 TTI 影响极大的重要因素：

* 传输到页面的 JavaScript 代码的总大小
* 主线程上 JavaScript 的运行时间

我们的[可交互时间](https://calibreapp.com/blog/time-to-interactive/)文章详细说明了 TTI 的工作原理，但如果你想要一些快速无脑的优化，我们建议：

**降低 JavaScript 总大小**

尽可能地，移除无用的 JavaScript 代码，或者只传输当前页面会执行的代码。这可能意味着要移除老的 polyfills 或者尽量采用更小、更新的第三方库。

你需要记住的是 [JavaScript 花费的](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) 不仅仅是下载它所需要的时间。浏览器需要解压、解析、编译然后才最终执行，这些过程都会消耗不容忽视的时间，尤其在移动设备上。

能降低你的页面脚本总大小的有效措施是：

* 检查并移除对你的用户来说并不需要的 polyfills。
* 搞清楚每一个第三方 JavaScript 库所花费的时间。使用 [webpack-bundle-analyser](https://www.npmjs.com/package/webpack-bundle-analyzer) 或者 [source-map-explorer](https://www.npmjs.com/package/source-map-explorer) 来可视化分析他们的大小。
* 现代 JavaScript 工具（比如 webpack）可以把大的 JavaScript 应用分解成许多小的 bundles，随着用户的浏览而动态加载。这就是所谓的 [code splitting](https://webpack.js.org/guides/code-splitting/)，它会**极大地优化 TTI。**
* [Service workers 会缓存解析和编译后所得的字节码](https://v8.dev/blog/code-caching-for-devs)。如果善加利用这个特性，用户只需花费一次解析和编译代码带来的时间损耗，在那之后的结果就会被缓存优化。

### 监控可交互时间

为了较好的展示用户体验的差异性，我们建议使用监控系统（比如 [Calibre](https://calibreapp.com/)），它可以测试页面在两个不同设备上的最小评分；一个较快的桌面端设备和一个中等速度的移动端设备。

这样的话，你就可以得到你的用户可能体验到的最好和最差两种情况下的数据。是时候意识到，你的用户并没有使用和你一样强大的设备了。

### 深度剖析

为了获得剖析 JavaScript 性能的最好结果，可以刻意使用较慢的移动设备来测试你的页面。如果你的抽屉里有一部老手机，你会发现一片新的天地。

Chrome DevTools 的硬件仿真模块可以很好的替代真实设备来进行测试，我们写了一个详细的[性能剖析指南](https://calibreapp.com/blog/react-performance-profiling-optimization/)来帮你开始学习分析运行时的性能。

## 其他的指标呢？

速度指标、首次内容绘制时间和首次有效绘制都是以浏览器绘制为基础的指标。他们的影响因素很相似，往往可以被同时优化。

显然，优化这些指标会相对比较容易，因为他们是通过记录页面的渲染速度来计算的。仔细遵从 Lighthouse 的性能考核准则就能优化这些指标。

如果你还没有对字体进行预加载或者优化那些关键请求，那从这里入手会是一些很好的切入点。我们的文章，[关键请求](https://calibreapp.com/blog/critical-request/)，详细说明了浏览器针对你的页面是如何发起请求以及渲染关键资源的。

## 跟踪过程做出优化

Google 最近更新了搜索控制台、Lighthouse 和 PageSpeed Insights 针对你的页面的首屏的性能分析有独到之处，但是对于那些需要持续跟踪页面来提升页面性能的团队来说，就显得捉襟见肘了。

[持续的性能监控](https://calibreapp.com/features) 可以保证速度优化，当页面又变差的时候团队也会立刻知晓。人为的测试会对结果引入大量的不可预期的变量，在不同区域、不同设备上的测试在没有专业的实验室环境下几乎是不可能完成的。

速度已经变成影响了 SEO 排名的关键因素，尤其是目前大约 50% 的页面流量来自于移动设备。

为了避免排名下降，确保你正在使用最新的性能分析套件来跟踪你的关键页面（哈，我们打造了 [Calibre](https://calibreapp.com/blog/release-notes-lighthouse-4/) 来做你的性能提升伙伴。他以 Lighthouse 为基础。每天都有很多来自全球的团队在使用它）。

### 相关文章

* [About Time to Interactive](https://calibreapp.com/blog/time-to-interactive/)
* [How to optimise the performance of a JavaScript application](https://calibreapp.com/blog/react-performance-profiling-optimization/)
* [Lighthouse Performance score Calculator](https://docs.google.com/spreadsheets/d/1Cxzhy5ecqJCucdf1M0iOzM8mIxNc7mmx107o5nj38Eo/edit#gid=283330180)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
