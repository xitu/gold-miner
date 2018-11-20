> * 原文地址：[Start Performance Budgeting](https://medium.com/@addyosmani/start-performance-budgeting-dabde04cf6a3)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/start-performance-budgeting.md](https://github.com/xitu/gold-miner/blob/master/TODO1/start-performance-budgeting.md)
> * 译者：[Sam](https://github.com/xutaogit/)
> * 校对者：[Augustwuli](https://github.com/Augustwuli), [Calpa](https://github.com/calpa)

# 开启性能预算

![](https://cdn-images-1.medium.com/max/2000/1*BTZwTbmKyBE60tuXPDy34g.png)

**如果你正在构建网站体验，并且希望保持快速，[性能预算](https://timkadlec.com/2013/01/setting-a-performance-budget/)也许就[非常重要](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)。为了能够成功，需要接受性能预算并且学会在生活中运用它们。移动设备上的网络以及 CPU 限制会提出诸如”对我的用户来说真正重要的是什么？“这样的难题。**

当我们同致力于提高性能的世界 500 强企业对话时，(了解到)一旦回归到功能开发，性能指标通常会**快速回归**。性能预算帮助团队确定功能的优先级，优化并[促进](https://tobias.is/blogging/web-performance-budgets-as-currency/)讨论对用户真正重要的是什么。

> **“在项目早期的适当阶段，拥有一个预设好的 ‘预算’ 会是一个清晰并切实的方式，可用来决定项目中应该包含什么。” —— Mark Perkins**

### 什么是性能预算？

性能预算是一个团队不能允许超过的页面**限制**。它可以是最大的 JavaScript 包大小，所有图像的总体量，特定的加载时间（例如，在 3G/4G 网络上 5s 以内的[交互时间](https://calendar.perfplanet.com/2017/time-to-interactive-measuring-more-of-the-user-experience/)）或者其它任何数量指标的阈值。

![](https://cdn-images-1.medium.com/max/800/0*qe3ZW3Vvf8lsdxMq.png)

**当然性能预算不仅仅是做门槛限制。它们更像财务预算，需要有意识的使用**。把它们看作是在用户体验上花费和交易的货币。在 [JavaScript 成本](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)仍然较高的移动设备环境中，预算可以说是指导我们取得成功的少数工具之一。

### 性能预算指标

性能预算的[指标](https://timkadlec.com/2014/11/performance-budget-metrics/)包括里程碑时间，基于数量的指标和基于规则的指标。

![](https://cdn-images-1.medium.com/max/800/0*bP485as_8xmWGD9s.png)

**里程碑时间**：基于加载一个页面的用户体验的时间（例如，[交互时间](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#time_to_interactive)，[首次内容绘制时间](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#first_paint_and_first_contentful_paint)）。你会经常需要配对几个里程碑时间，用来准确地描述页面加载的整个过程。有些团队还会维护自定义指标，譬如 Twitter 的“[首次推文时间](https://blog.alexmaccaw.com/time-to-first-tweet)”。

**基于数量的指标**：基于原始值（例如：JavaScript 的体量（KB/MB），HTTP 请求数量）。这些都侧重于浏览器体验。

**基于规则的指标**：通过像 [Lighthouse](https://developers.google.com/web/tools/lighthouse/) 或 [WebPageTest](https://webpagetest.org/) 这样的工具打分。通常是用单个数字或系列为你的网站评级。

如果一个 PR 降低了性能，包含性能预算的团队通常会有 CI 告警或者构建错误提示。[Lighthouse CI](https://github.com/ebidel/lighthouse-ci#3-call-lighthouse-ci) 现在支持当某一类别（比如性能）跌落到特定的值以下时，减低其 Lighthouse 分数：

![](https://cdn-images-1.medium.com/max/800/0*30uWWuN-yRDK4awS.png)

一个基于“规则”的性能预算实际例子。使用 Lighthouse CI，我们可以给预算设置一个性能分数。如果他们的性能分低于一个特定的值，那么 PR 就会失败。

### 预算的例子

* 我们的产品页面在移动端上发布的 JavaScript 代码必须少于 170KB
* 我们的搜索页面包含的桌面图片不能超过 2MB
* 我们的主页必须在慢速的 3G/Moto G4（网络）上 5s 内加载并可交互
* 我们的博客必须在 Lighthouse 的性能审查中获得 80+ 的分数

下面是一个数量指标 —— 在 [SpeedCurve](https://speedcurve.com/) 上 The Guardian’s 桌面网站的 [JS 大小](https://t.co/ZKpkSJfnLy)。它在预算范围内以黄色高亮显示，在超出预算时以红色显示。

![](https://cdn-images-1.medium.com/max/800/0*JHF8gX8AMSLf9Wj1.jpg)

我们还可以将里程碑指标可视化。下面是[第一次交互](https://developers.google.com/web/tools/lighthouse/audits/first-interactive)（这时第一个 CPU 空闲） —— 标记了浏览器主线程被任何单个任务阻塞不超过 50 毫秒的时间点，因此可以快速响应用户的输入。

![](https://cdn-images-1.medium.com/max/800/0*hm42fQwOmOdAsHwr.png)

预算会因为很多因素而不同，包括目标设备级别。比较 Guardian 的移动端和桌面端体验，我们可以看到它们有很大的总体量差别：

![](https://cdn-images-1.medium.com/max/800/0*KzrhYg-dqQ59LL-c.jpg)

这或许表明**不同设备级别间的预算值得考虑**。例如，移动设备 <170KB（min/gzip）的 JS 代码量和桌面设备 <1.5MB 的 JS 代码量，可以让用户拥有更快的 CPU 和网络连接。

### 量化新功能的影响

> **“当一个包含三张轮播图和一张全屏高分辨率背景图片的模块已经审批通过时，还要保证页面大小不能超过 500kB 对你来说可能不太容易” —— Tim Kadlec**

通常，**非工程利益相关的人员不能意识到他们的决定**对功能和设计所带来的**性能影响**。这不是他们的错。我们需要让产品经理，设计师和利益相关者更容易理解他们做得选择所带来的**用户体验影响**。

利益相关者可能需要帮助，去理解换一种 JavaScript 轮播或者过多的图片会严重影响网站的性能。性能预算可以战略性地帮助我们改变思维模式，以此来考量我们添加每件事物的价值。

如果我们从一开始就把性能作为我们项目目标的一部分，那就更好了。这会是性能预算心态的转变，从只把它当做开发中的一个考量因子，转变成贯穿整个项目生命周期的关键因素。

### 为用户体验做出权衡

![](https://cdn-images-1.medium.com/max/800/0*KKs6HE9r_U2vUc9d.png)

和任何财务预算一样，你的性能预算有时候可能会**很低**。这就需要你做出一些削减或权衡以确保持续的快速用户体验。哪些功能对你的用户来说是真正重要的？哪一个最能激发或留住他们？这是一个艰难的对话，并且不总是很清晰。

可以用**抛弃一个功能而开放另一个功能**来结束这个对话。“抛弃”可能意味着把它从关键路径移除 —— 该功能仍可在稍后用户需要它的时候按需加载。

在这种情况下，你可以在逐页的基础上，打电话咨询页面性能预算，并把它作为事实来源帮助你持续接近目标。

### 实施预算

业务通过[实施绩效文化](https://rigor.com/blog/2016/06/5978)的内部流程方式来实现性能预算。

**组织化的性能预算要确保预算是关联到每个人身上的，而不仅仅是通过团队的方式来定义**。性能预算不能只是工程团队关心的事。

> **“网络性能预算应该是关于多个正确因素协作效果创建出的一个方程式，用以帮助企业做出正确的决定，并且能产出必要的建议帮助其产品向前发展。这会比开展一项带有潜在冲突的关于旨在修复网站性能阈值的对话要有效得多。” —— Tobias Baldauf**

设定好预算，并且让整个组织尽早了解有哪些预算参数时，可以说性能不再只是一个工程问题，而会作为构建网站整个软件包的关键部分。

当考虑性能时它（译者注：预算）提供了设计和工程指南，并且会根据每个可能影响性能的决策做检查。

SpeedCurve 等监控服务还能让你针对竞争对手的网站做[基准测试](https://support.speedcurve.com/get-the-most-out-of-speedcurve/benchmark-yourself-against-your-competitors)，使你可以轻松的可视化（查看）他们在你预算上的性能表现。当你告诉利益相关者为什么 “控制预算” 很重要时，这些会是很有帮助。

![](https://cdn-images-1.medium.com/max/800/0*u16guMcsuAKpzCwH.jpg)

### 帮助执行性能预算的工具

存在很多用于实施性能预算的工具。

[**bundlesize**](https://github.com/siddharthkp/bundlesize) 在 CI 中用于捕获 **JavaScript 回归大小**特别合适：

![](https://cdn-images-1.medium.com/max/800/0*9jRDyljdEMDmsqSs.jpg)

Tinder.com 使用包大小来设置每次 PR 提交时检查的 JavaScript 包预算。他们的 React 应用有一个 170KB 的主包预算和一个 20KB 的 CSS 预算。代码分拆的方式使它们能够保持在预算范围内。诸如 Trivago, Zendesk 和 OpenTable 这样的网站使用的也是这种方式。

其他团队使用 [Webpack 内置支持的性能预算](https://medium.com/webpack/webpack-performance-budgets-13d4880fbf6d)。你可以配置 [performance.hints ](https://webpack.js.org/configuration/performance/) 在超过预算时告警或构建失败。Webpack 支持最大[资源尺寸（maxAssetSize）](https://webpack.js.org/configuration/performance/#performance-maxassetsize)或 JavaScript 包[入口文件尺寸（maxEntrypointSize）](https://webpack.js.org/configuration/performance/#performance-maxentrypointsize)配置。

![](https://cdn-images-1.medium.com/max/800/0*A_YYVf6zDLhQZtUD.png)

[**SpeedCurve**](http://support.speedcurve.com/get-the-most-out-of-speedcurve/create-performance-budgets-and-set-alerts) 支持为各种指标，资源大小和 Lighthouse 审查类别做预算配置。

![](https://cdn-images-1.medium.com/max/800/0*Ae57J3LinlF-4M3R.jpg)

![](https://cdn-images-1.medium.com/max/800/1*Y4k7aQHDKEGGqqIobKAmQw.png)

例子里以 80/100 的预算追踪了 blog.google 在 Lighthouse 上的性能分数。红线表示超出了预算。

Zillow [使用](https://www.zillow.com/engineering/bigger-faster-more-engaging-budget/) SpeedCurve 为移动搜索中的数量（例如图像大小）和里程碑时间指标设置预算。其他性能监控服务（如 [Calibre](https://calibreapp.com/docs/metrics/budgets)）也支持设置预算和退回时的警报。

![](https://cdn-images-1.medium.com/max/800/1*Lh3B43rKikOFLbataMNSdg.png)

如果您正处于决定把什么作为目标预算的计划阶段，[**https://performancebudget.io**](https://performancebudget.io) 是一个预设了不同网络速度的预算视觉辅助。

![](https://cdn-images-1.medium.com/max/800/0*c_mNxUFA58JBEwIz.png)

当然，早些时候提到的，如果一个团队想要以规则为基础在 PR 上做性能预算，[Lighthouse CI](https://github.com/ebidel/lighthouse-ci#3-call-lighthouse-ci) 会是很好的选择。

### 结束思考

性能预算引入了一种**问责**文化，这使得利益相关者能够权衡每次网站变更中[以用户为中心的指标](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics)。和你的团队聊聊，看看是否可以在你的项目里采用性能预算。如果值得加快（译者注：网站体验），那就值得保持快速。❤️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
