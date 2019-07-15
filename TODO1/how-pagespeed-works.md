> * 原文地址：[Google 的 Pagespeed 的工作原理：提升你的分数和搜索引擎排名](https://calibreapp.com/blog/how-pagespeed-works/)
> * 原文作者：[Ben Schwarz](https://calibreapp.com/blog/author/ben-schwarz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-pagespeed-works.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-pagespeed-works.md)
> * 译者：
> * 校对者：

# Google 的 Pagespeed 的工作原理：提升你的页面分数和搜索引擎排名

![](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/1.png)

通过这篇文章，我们将揭开 PageSpeed 那苛刻的计算页面速度分的面纱。

毫无疑问，页面的加载速度已经变成了提升页面收益和降低流失率的关键性因素。由于 Google 使用页面的加载速度作为其搜索排名的一个因素，现在许多企业和组织都把目光聚焦在提升页面性能上了。

去年 **Google 针对他们的搜索排名算法做了两个重大的调整**：

* 三月, [搜索结果排名以移动端版本的页面为基础](https://webmasters.googleblog.com/2018/03/rolling-out-mobile-first-indexing.html)，取代之前的桌面端版本。
* [七月,SEO 排名算法](https://webmasters.googleblog.com/2018/01/using-page-speed-in-mobile-search.html) 更新为，增加页面的加载速度作为影响排名的因素，包括移动端页面[和广告。](https://developers.google.com/web/updates/2018/07/search-ads-speed#the_mobile_speed_score_for_ads_landing_pages)

通过这些，我们可以总结出两个结论：From this, we’re able to state two truths:

* **手机端页面的加载速度会影响你整站的 SEO 排名。**
* 如果你的页面加载很慢，就会降低你的广告质量分，所以你的**广告费会更贵。**

Google 道：

> 更快的加载速度不仅仅会提升我们的体验；最近的数据显示，提升页面的加载速度也会降低操作成本。和我们一样，用户也很重视速度 — 这就是我们决定将页面的速度这个因素，加入计算搜索排名的原因。

为了搞清楚这些变化，从性能的角度给我们带来了什么影响，我们需要掌握这些基础知识。[PageSpeed 5.0](https://developers.google.com/speed/docs/insights/release_notes) 是之前的一个完整的修订版。现在由 Lighthouse 和 [CrUX](https://developers.google.com/web/updates/2017/12/crux) 提供技术支持（Chrome User Experience Report）。

**这次升级更新了分数的算法，它使得获得 PageSpeed 的高分更加困难。**

### PageSpeed 5.0 改变了什么?

5.0 之前，PageSpeed 会针对测试的页面给出一些指导意见。如果页面有很大的、未经压缩的图片，PageSpeed 会建议对图片压缩。再比如，漏掉了 Cache-Headers，会建议加上。

这些建议是与一些列的**指导方针**对应的，如果遵从这些指导方针，**很可能**会提升你的页面性能，但这些也仅是是表层的，它不会分析用户真实场景下的加载和渲染的体验。

在 PageSpeed 5.0 中，页面被载入真实的 Chrome 浏览器，是由 Lighthouse 控制的。Lighthouse 从浏览器中获取记录各项指标，把这些指标套入得分模型里计算，最后展示一个整体的性能分。根据具体的分数指标来给出优化的指导方针。

和 PageSpeed 类似，Lighthouse 有一个性能分。在 PageSpeed 5.0 中，性能分直接从 Lighthouse 里取了。**现在 PageSpeed 的速度分和 Lighthouse 的性能分一样了**

![Calibre scores 97 on Google’s Pagespeed](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/calibre-pagespeed.png)

既然我们知道了 PageSpeed 的分数从哪里来，接下来我们就来仔细研究它是如何计算的，以及如何有效的提高页面的性能。

### Google Lighthouse 是什么?

[Lighthouse](https://calibreapp.com/blog/lighthouse-reasons/) 是一个开源项目，由一只来自 Google Chrome 优秀团队创建。在过去的几年里，它已将变成逐步免费的性能分析工具。

Lighthouse 使用 Chrome 的远程调试协议来获取网络请求的信息，计算 JavaScript 的性能, observe accessibility standards and 计算用户关注的时间指标，比如 [首次内容绘制时间 First Contentful Paint](https://calibreapp.com/docs/metrics/paint-based-metrics)、[可交互时间 Time to Interactive](https://calibreapp.com/docs/metrics/time-to-interactive) 或者速度指标。

如果你想要深入了解 Lighthouse，请看来自官方的[指引](https://github.com/GoogleChrome/lighthouse/blob/master/docs/architecture.md)。

### Lighthouse 如何计算性能分数

在性能测试中，Lighthouse 聚焦于用户看见和体验到的，记录了很多指标。

下面这 6 个指标构成了性能分数的大体部分。他们是：

* 可交互时间 Time to Interactive (TTI)
* 速度指标 Speed Index
* 首次内容绘制时间 First Contentful Paint (FCP)
* 首次 CPU 空闲时间 First CPU Idle
* 首次有效绘制 First Meaningful Paint (FMP)
* 预计输入延迟时间 Estimated Input Latency

Lighthouse 会针对这些指标运用一个 0 – 100 的分数模型。 这个过程会收集手机 75% 和 90% 的 [HTTP Archive](https://httparchive.org/)，之后使用 `普通的 log` 函数记录。

[根据算法和可交互时间的计算所得数据](https://www.desmos.com/calculator/2t1ugwykrl)，我们可以发现，如果一个页面在 2.1 秒内成为“可交互的”， 那么它的可交互时间分数指标是 92/100。

![](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/scoring-curve.png)

当每个指标完成计分后，它会被分配一个权重，用来调整页面整体的性能分数。权重规则如下：

| 指标                       | 权重 |
| ------------------------- | --------- |
| 可交互时间 (TTI) | 5        |
| 速度指标                    | 4         |
| 首次内容绘制时间             | 3         |
| 首次 CPU 空闲时间            | 2         |
| 首次有效绘制                 | 1         |
| 预计输入延迟时间             | 0         |

这些权重取决于每个指标对移动端用户的体验的影响程度。

In the future, this may also be enhanced by the inclusion of user-observed data from the Chrome User Experience Report dataset.

You may be wondering how the weighting of each metric affects the overall performance score. The Lighthouse team [have created a useful Google Spreadsheet calculator](https://docs.google.com/spreadsheets/d/1Cxzhy5ecqJCucdf1M0iOzM8mIxNc7mmx107o5nj38Eo/edit#gid=0) explaining this process:

![Picture of a spreadsheet that can be used to calculate performance scores](https://calibreapp.com/blog/uploads/how-google-pagespeed-works/weightings.png)

Using the example above, if we change (time to) interactive from 5 seconds to 17 seconds (the global average mobile TTI), our score drops to 56% (aka 56 out of 100).

Whereas, if we change First Contentful Paint to 17 seconds, we’d score 62%.

**Time to Interactive (TTI) is the most impactful metric to your performance score.**

Therefore, to receive a high PageSpeed score, you will **need** a speedy TTI measurement.

### Moving the needle on TTI

At a high level, there are two significant factors that hugely influence TTI:

* The amount of JavaScript delivered to the page
* The run time of JavaScript tasks on the main thread

Our [Time to Interactive](https://calibreapp.com/blog/time-to-interactive/) guide explains how TTI works in great detail, but if you’re looking for some quick no-research wins, we’d suggest:

**Reducing the amount of JavaScript**

Where possible, remove unused JavaScript code or focus on only delivering a script that will be run by the current page. That might mean removing old polyfills or replacing third-party libraries with smaller, more modern alternatives.

It’s important to remember that [the cost of JavaScript](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) is not only the time it takes to download it. The browser needs to decompress, parse, compile and eventually execute it, which takes non-trivial time, especially in mobile devices.

Effective measures for reducing the amount of script from your pages:

* Review and remove polyfills that are no longer required for your audience.
* Understand the cost of each third-party JavaScript library. Use [webpack-bundle-analyser](https://www.npmjs.com/package/webpack-bundle-analyzer) or [source-map-explorer](https://www.npmjs.com/package/source-map-explorer) to visualise the how large each library is.
* Modern JavaScript tooling (like Webpack) can break-up large JavaScript applications into a series of small bundles that are automatically loaded as a user navigates. This approach is known as [code splitting](https://webpack.js.org/guides/code-splitting/) and is **extremely effective in improving TTI.**
* [Service workers will cache the bytecode result of a parsed + compiled script](https://v8.dev/blog/code-caching-for-devs). If you’re able to make use of this, visitors will pay a one-time performance cost for parse and compilation, after that it’ll be mitigated by cache.

### Monitoring Time to Interactive

To successfully uncover significant differences in user experience, we suggest using a performance monitoring system (like [Calibre](https://calibreapp.com/)!) that allows for testing a minimum of two devices; a fast desktop and a low-mid range mobile phone.

That way, you’ll have the data for both the best and worst case of what your customers experience. It’s time to come to terms that your customers aren’t using the same powerful hardware as you.

### In-depth manual profiling

To get the best results in profiling JavaScript performance, test pages using intentionally slow mobile devices. If you have an old phone in a desk drawer, this is a great second-life for it.

An excellent substitute for using a real device is to use Chrome DevTools hardware emulation mode. We’ve written an extensive [performance profiling guide](https://calibreapp.com/blog/react-performance-profiling-optimization/) to help you get started with runtime performance.

## What about the other metrics?

Speed Index, First Contentful Paint and First Meaningful Paint are all browser-paint based metrics. They’re influenced by similar factors and can often be improved at the same time.

It’s objectively easier to improve these metrics as they are calculated by how quickly a page renders. Following the Lighthouse Performance audit rules closely will result in these metrics improving.

If you aren’t already preloading your fonts or optimising for critical requests, that is an excellent place to start a performance journey. Our article, [The Critical Request](https://calibreapp.com/blog/critical-request/), explains in great detail how the browser fetches and renders critical resources used to render your pages.

## Tracking your progress and making meaningful improvements

Google’s newly updated search console, Lighthouse and PageSpeed Insights are a great way to get initial visibility into the performance of your pages but fall short for teams who need to continuously track and improve the performance of their pages.

[Continuous performance monitoring](https://calibreapp.com/features) is essential to ensuring speed improvements last, and teams get instantly notified when regressions happen. Manual testing introduces unexpected variability in results and makes testing from different regions as well as on various devices nearly impossible without a dedicated lab environment.

Speed has become a crucial factor for SEO rankings, especially now that nearly 50% of Web traffic comes from mobile devices.

To avoid losing positioning, ensure you’re using an up-to-date performance suite to track key pages (pssst, we built [Calibre](https://calibreapp.com/blog/release-notes-lighthouse-4/) to be your performance companion. It has Lighthouse built-in. Hundreds of teams from around the globe are using it every day).

### Related Articles

* [About Time to Interactive](https://calibreapp.com/blog/time-to-interactive/)
* [How to optimise the performance of a JavaScript application](https://calibreapp.com/blog/react-performance-profiling-optimization/)
* [Lighthouse Performance score Calculator](https://docs.google.com/spreadsheets/d/1Cxzhy5ecqJCucdf1M0iOzM8mIxNc7mmx107o5nj38Eo/edit#gid=283330180)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
