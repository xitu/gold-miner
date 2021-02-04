> * 原文地址：[8 Performance Analysis Tools for Front-End Development](https://blog.bitsrc.io/performance-analysis-tools-for-front-end-development-a7b3c1488876)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/performance-analysis-tools-for-front-end-development.md](https://github.com/xitu/gold-miner/blob/master/article/2020/performance-analysis-tools-for-front-end-development.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[FateZeros](https://github.com/FateZeros)，[Rachel Cao](https://github.com/rachelcdev)

# 前端开发 8 大性能分析工具

![](https://cdn-images-1.medium.com/max/2560/1*WIIXp_ny48NehrJCWsJy6Q.jpeg)

你可以拥有世界上最漂亮，最吸引人的网站，但如果该网站无法快速加载到浏览器中，人们往往会忽略它。尽管有许多性能规则，但归根结底，这全取决于加载时间。

据 [Jakob Nielson](https://www.nngroup.com/articles/website-response-times/) 所说，这是构建网站时应记住的事。

* 小于 100 毫秒是瞬时的。
* 100 毫秒至 300 毫秒的延迟是可被感知的。
* 一秒内，用户能保持思绪不间断，虽然他们会感觉到延迟，但能自己控制住思绪。
* 47% 的用户期望网页在两秒或更短时间内被加载。
* 40% 的用户在等待网站渲染超过3秒后，就会离开网站。
* 10 秒是保持用户注意力的极限。大多数用户会在 10 秒后离开你的网站。

在[这里](https://www.hobo-web.co.uk/your-website-design-should-load-in-4-seconds/)和[这里](https://www.nngroup.com/articles/website-response-times/)详细了解这些统计信息。

---

如你所见，很显然，即使在最差的网络连接上，也需要确保页面尽快加载。但说起来容易做起来难。

为了帮助你实现这一最终目标 —— 以下我为性能分析者推荐的工具清单。

## 1. PageSpeed Insights

这是一项分析网页内容的[免费服务](https://developers.google.com/speed/pagespeed/insights/)，生成能使网页更快的建议。为你提供了关键指标，例如 FCP(First Contentful Paint)、累积阻塞时长等。指标分为现场数据、原始摘要、实验室数据、因素、诊断与过审信息。它还为你提供了进一步带改进建议。

PageSpeed 完全致力于性能方面，结合实验室数据和实际数据来构建有关网站加载速度的综合报告。以下是我的[作品集网站](https://thisismahdhi.ml)的 PageSpeed Insight 结果。如你所见，摘要中是没有足够的实际速度数据的。

![Screenshot by Author](https://cdn-images-1.medium.com/max/6696/1*ONiEtpxiMc3KitaT7OiYRw.png)

只粘贴单个 URL 的方式在企业级网站上是不可行的。但这个问题可以通过使用 PageSpeedPlus 运行[自动化的 Google PageSpeed 测试](https://pagespeedplus.com/blog/automating-google-pagespeed-testing)来解决。它每周为你扫描整个站点，并在人性化的报告中提供结果。你还可以在[这里](https://developers.google.com/speed/docs/insights/v5/get-started)查看 PageSpeed API。

## 2. Lighthouse

[Lighthouse](https://developers.google.com/web/tools/lighthouse) 是一个自动化的开源工具，可帮助你通过多个角度分析网页，不仅有性能分析，还有其他项目，例如 SEO，可访问性，最佳实践（Best Practices）以及网站是否满足 PWA 的要求。

你只需在 Chrome 开发者工具中的命令行，或者甚至作为 Node 模块运行该工具即可。你所要做的只是提供一个 URL，Lighthouse 将进行一系列审查，然后告诉你网站的运行情况。每个审查都有一个参考说明，解释了此审查的重要性，以及如何解决它。

![Google Lighthouse — Screenshot by Author](https://cdn-images-1.medium.com/max/6492/1*YjmPZ4M8Q6KTZik_6-2NaA.png)

Lighthouse 的另一个重要运用是将 API 集成到你自己的系统中，从而以编程方式运行审查。例如，如果你要阻止不符合 SEO 和性能标准的发布，则可以按需使用 Lighthouse 运行测试。

## 3. WebPageTest

这是一个[免费工具](https://www.webpagetest.org/)，可让你使用具有真实的用户连接速度的浏览器（例如 Chrome）测试网站加载速度。你可以选择诸如高级测试，简单测试，视觉比较（Visual Comparison）与路由跟踪等功能。你还有很多选择，例如多步骤交互（Multi-step Transactions）、视频捕获（Video Capture）、以及内容阻塞等。最终将产生丰富的诊断信息，包括资源加载瀑布图，页面速度优化检查以及改进建议。

网页测试还提供首屏页面渲染、重复页面渲染以及服务器响应的详细信息分析。

![Screenshot by Author](https://cdn-images-1.medium.com/max/2642/1*3MrD-mCHa-vN3bP3zTQ6-Q.png)

## 4. Pingdom

[Pingdom](https://speedcurve.com/) 是另一项功能强大的分析服务，为你提供大量的功能。它提供了完整的摘要，包括页面请求、加载的时长、大小以及请求分析。你可以从全球各地分析你的站点。还为你提供了改善页面得分的建议。

我最喜欢的功能是过滤后的摘要，其中会有关网站内容和请求的总结。我发现这对了解网页上的总体信息非常有帮助。

![Screenshot by Author](https://cdn-images-1.medium.com/max/2542/1*KHVSkyoFYveQ_mcahOpo-g.png)

## 5. SiteSpeed

[SiteSpeed](https://www.sitespeed.io/) 是一套开源工具，可让你监控和检测网站的性能。你可以通过 Docker 镜像或者安装 NPM 包来使用。由于其提供了几种工具，因此你应该能够选择到最适合自己的。你还可以在其[官网](https://www.sitespeed.io/)上找到更多这些工具的相关信息。

虽然 SiteSpeed 是免费的，但建立与维护服务器是需要额外的开销的。如果你没有自己的服务器，SiteSpeed 建议你使用拥有 2 个 vCPUs 的 [Digital Ocean](https://www.digitalocean.com/) Optimized Droplets 方案，或者使用 [AWS](https://aws.amazon.com/) 的 c5.large 实例，并将数据存储在 S3(Amazon 的一种对象存储服务) 上。

![SiteSpeed Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2662/1*n5FITnS0PUegqchHkSS2eg.png)

## 6. Calibre

[Calibre](https://calibreapp.com/) 是一款多功能的性能监控套件，可帮助你监控和检查网站的性能。它允许通过指定测试服务器的位置，管理仿真的广告偏好，甚至模仿移动设备来模拟真实条件。它还允许你设置阈值，通过为你提供的性能回归来帮助你留在阈值内。

它还具有[更多的功能](https://calibreapp.com/features)，在这篇简短的文章中无法详细说明。我强烈建议你查看他们的[网站](https://calibreapp.com/)。

![Calibre Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2674/1*ZwqTNsAkVqH5HPe2Ggmy8w.png)

## 7. SpeedCurve

[SpeedCurve](https://speedcurve.com/) 捕获真实的用户数据，并展示出我们网站实际客户的体验。通过提供基准特征，你还可以将自己网站与竞品进行比较。此举将使你始终领先于竞争对手。你还可以生成展示网站实际加载进度的幻灯片。

[SpeedCurve](https://speedcurve.com/) 还提供了综合监控。综合监控是在受控的环境中对网站进行仿真模拟。你可以自定义环境的选项，例如网速、设备与操作系统等。

![SpeedCurve Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2666/1*S3aC2hbCDQz7dfvDJsd_kg.png)

## 8. SpeedTracker

[SpeedTracker](https://speedtracker.org/) 是一个运行在 [WebPageTest](https://www.webpagetest.org/) 上的工具，可在你的网站上定期进行性能测试，并可视化地显示各类随时间变化的性能指标。这使你可以不断评估网站，并观察新功能如何影响网站的性能。你也可以定义阈值，并通过电子邮件与 Slack 获得警报。

英国广播公司（BBC）、康涅狄格大学（University of Connecticut）与红牛电视台（Red Bull TV）等大公司都在使用此工具。

![SpeedTracker Homepage — Screenshot by Author](https://cdn-images-1.medium.com/max/2658/1*FfMBnmPxWZUYUc6GeNfHUA.png)

---

使用上述工具，你可以做许多有用的事情，但如果要让网站达到标准，则可能需要更进一步的优化。我发现了一篇由 Vitaly Friedman 撰写的文章，涵盖了全方位的前端网站优化方案。强烈建议了解一下。

[**2020 前端性能清单（PDF，Apple Pages，MS Word）**](https://www.smashingmagazine.com/2020/01/front-end-performance-checklist-2020-pdf-pages/)

祝编码愉快！

---

**相关资源**

[PageSpeedPlus](https://pagespeedplus.com/blog/pagespeed-insights-vs-lighthouse)
[Techbeacon](https://techbeacon.com/app-dev-testing/web-performance-testing-18-free-open-source-tools-consider)
[Dzone](https://dzone.com/articles/client-side-performance-testing)
[Jacob Tan 的博客文章](https://medium.com/@jacobtan/tackling-front-end-performance-strategy-tools-and-techniques-12ca542052e7)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
