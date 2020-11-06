> * 原文地址：[Performance Metrics for Front-End Applications](https://blog.bitsrc.io/performance-metrics-for-front-end-applications-a04fdfde217a)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/performance-metrics-for-front-end-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2020/performance-metrics-for-front-end-applications.md)
> * 译者：[niayyy](https://github.com/nia3y)
> * 校对者：[plusmultiply0](https://github.com/plusmultiply0)、[HurryOwen](https://github.com/HurryOwen)

# 前端应用的性能指标

![](https://cdn-images-1.medium.com/max/2560/1*V7jvAKZ4UKLwQ3ET2r9CuQ.jpeg)

网络已经成为我们日常生活中不可或缺的一部分。根据 [CreditLoan](https://www.creditloan.com/blog/how-the-world-spends-its-time-online/) 调查显示，用户平均每天花费 7.6 小时上网，其中 20% 的时间用来网上冲浪。你可以想象一下，在 2020 年这个充满灾难的一年，当每个人都呆在家里的时候，上网的小时数应该有多大。

这些数字体现了网络对我们有多么重大的影响。为了充分利用这个大的机会，网站应该有非常高的标准。构建一个好看的网站是容易的，但是要获得出色的性能是非常困难的。这是因为 Web 开发中存在许多瓶颈，像：昂贵的 JavaScript 开销、网络字体加载缓慢、大型的图片下载缓慢等。

你可以拥有世界上最好看、最吸引人的网站，但是如果网站性能在用户浏览器上表现非常差，人们也不会去使用它。

## 以用户为中心的性能及其重要性

现在我们知道为什么应该开始改善网站的性能了。

> 通过 [Vitaly](https://www.smashingmagazine.com/author/vitaly-friedman/)，一般而言，你的目标应该是要比最快的竞争对手快至少 20%。

但是当我们讨论性能时，我们真正的目的是什么？

正如 [Philip](https://web.dev/authors/philipwalton/) 所说，“性能是相对的”。在某些情况下，你的网站可以在用户手机上加载的非常快，而在其他设备上却很缓慢。两个网站可能花费相同的时间来加载，但一个网站似乎可以通过渐进式加载来更快地显示内容。这会造成页面已经准备就绪的错觉，然而实际上它还在加载。。

另一种情况是，Web 页面能够快速加载，但是后台运行着多个阻塞进程，因此可能需要很长时间页面才能响应。

因此，最重要的是根据可以定量测量的客观标准来精确地衡量性能。

### 为什么是重要的？

传统意义上，像 `load` 等页面事件被用来衡量性能。但是实际上，这不一定是用户所关心的。

例如，一个网站可能立刻 `load` 一个最小的页面，但随后推迟获取内容，并需要花费几秒钟的时间在页面上显示有用的内容。这可能发生在页面 `load` 事件之后。尽管从技术上讲，“**加载时间**”更短，但加载时间与实际的用户体验无关，因为有用的内容还需要几秒钟的时间才能显示。

## 性能指标种类

性能指标可能被分为一下几类。

* 基于数量的指标
* 里程碑指标
* 渲染指标
* 自定义指标

### 基于数量的指标

衡量 HTTP 请求的数量，取决于图片、样式、JavaScript、HTML 等资源的大小。

**有用之处**

* 发出警报 —— 他们通过让你知道的 Web 应用程序是否超出性能预算来告知你网站的运行状况，同时也能帮助监控你的 Web 应用程序加载是否超时，这被认为是最简单的性能指标。

**无用之处**

* 了解用户体验 —— 他们无法详细说明用户感知的信息，因为这些指标主要与直接属性有关。

### 基于规则的指标

这些指标由 Web 应用程序和浏览器扩展根据预定义规则生成的。你将获得单个输出值/分数或一系列站点评级。谷歌的 Pagespeed Insights 和 Lighthouse 等应用程序提供了基于规则的指标。

**有用之处**

* 分数这种表示形式，可以让交流、衡量和跟踪绩效更简单。换句话说，分数很容易解释，因为更高的分数直接表明了更好的性能。
* 提供“活动项”或关于如何提高每项分数或评级的提示。

**无用之处**

* 知道用户体验 —— 与基于数量的指标类似，这些指标无法详细说明用户感知的信息，因为这些指标基于随时间变化的已知规则。但有一些应用程序和扩展确实提供了以用户为中心的反馈。

### 里程碑指标

这些指标通常是基于时间的，可以从浏览器开发者工具的网络标签轻松查看。像“**页面加载**”、“DOMContentLoaded” 之类的指标是里程碑指标的一部分。“**获取第一个字节的时间**”指标也是其中的一部分，可帮助了解后端服务器的响应速度。

还有一个指标是“可交互时间”。这个指标告诉你页面何时可以进行用户交互。换句话说，当页面准备好可供用户进行交互时。这非常重要，因为尚未准备好进行用户交互的已加载页面等于未加载页面。

**有用之处**

* 将用户端的用户体验描述为里程碑，并描述用户的感知。
* 基于时间的指标易于跟踪。
* 可视化很简单，很容易理解。

**无用之处**

* 不能显示整体情况 —— 这些指标未捕获用户在里程碑之间看到的内容。

### 渲染指标

渲染指标通过揭示用户在屏幕上看到的内容的视觉体验，来帮助填补里程碑指标的空白。结合里程碑指标使用将会非常有用。

**有用之处**

* 描述用户体验，因为他们能够从用户的角度处理视觉体验
* 标识渲染性能

**无用之处**

* 像素优先级 —— 他们不知道哪些像素是重要的。换句话说，它不知道忽略对用户没有任何实际价值的视觉内容，例如广告和弹窗。
* 无法识别交互性 —— 不知道用户何时能与视觉内容进行交互。

### 自定义指标

当用户体验发生变化时，将触发[自定义指标](https://web.dev/user-centric-performance-metrics/#custom-metrics)。使用诸如 User Timing 之类的 API 从浏览器获取指标并将其传递到服务器上。

**有用之处**

* 描述指标集中于用户的真实数据时的用户体验。

**无用之处**

* 与竞争对手相比，因为你的网站的指标是独一无二的。例如，Twitter 的“首次发布时间”指标不能与 Facebook 的自定义指标进行比较，因为它们并不意味着同一件事。

## 关键指标 —— 重点

现在我们知道了一些指标，让我们看一下其中的一些关键指标。

### 可交互时间（TTI）

这是一切都足够稳定，可以处理用户交互的点。换句话说，当布局稳定后，将显示关键的 Web 字体，并且主线程有足够的空闲时间来处理用户输入。这个指标对于理解用户需要等待多长时间才能与网站进行无延迟或延迟的交互至关重要。

### 首次输入延迟（FID）

这也称为**输入响应性**。从用户与网站进行交互到网站能够响应交互的时间。由于 FID 填补了用户与网站交互时发生的空白，因此增强了 TTI。这是一个真实用户指标（RUM），可以在浏览器中的一些 JavaScript [库](https://github.com/GoogleChromeLabs/first-input-delay)的帮助下进行测量。

### 最大内容绘制（LCP）

表示页面生命周期中页面的重要内容可能已加载的位置。尽管这是基于以下假设：页面的最重要元素是用户视口中可见的最大元素。如果内容已在可见区域（折叠）的上方和下方渲染，则只考虑上面的内容 —— 用户可见的部分。

### 总阻塞时间（TBT）

TBT 是一个帮助量化一个网页需要多长时间才能进行交互的指标。TBT 测量的是第一次绘制和可交互时间（TTI）之间的时间。较低的 TBT 表示较好的性能。

### 累积布局偏移（CLS）

CLS 检查网站元素的不稳定程度。它突出了用户多久遇到意外布局的偏移（回流）及其对整体用户体验的影响。

让我们看一下意外的布局偏移如何对用户体验产生负面影响。

![Source: [Web.dev](https://web.dev/cls/)](https://cdn-images-1.medium.com/max/2632/1*lbPHYbFOBwMs7yN4hcmjeA.gif)

### 速度指数

速度指数衡量页面内容在视觉上的填充速度。这个分数是根据视觉进度计算出来的，但这仅仅是一个计算。由于此度量标准是从视觉角度考虑的，因此视口大小直接影响速度指标。因此，需要定义视口大小以匹配目标受众，以获得更有意义的分数。

### 花费的 CPU 时间

这个指标显示了主线程被阻塞的时间。它显示了 CPU/主线程被阻止执行的**频率**和**时间**，例如绘制、渲染、脚本和加载。如果你的 Web 应用程序具有很高的 CPU 时间，它将给用户带来不愉快的延迟体验。可以借助 WebPageTest 进行计算。

### 组件级 CPU 成本

与花费的 CPU 时间类似，此指标侧重于 JavaScript 的成本。总体思路是使用每个组件的 CPU 指令计数，以了解其对总体体验的影响。

可以通过 [Puppeteer](https://calendar.perfplanet.com/2019/javascript-component-level-cpu-costs/) 实施。

### 挫折指数

当用户感到沮丧时，他们会离开你的网页。上面讨论的所有指标都针对单个事件。但是 [Tim Vereecke](https://calendar.perfplanet.com/2019/frustrationindex-mind-the-gap/) 的沮丧指数集中在指标之间的**差距**上，而不是单独进行查看。这个指标查看页面中的关键里程碑，并计算用户在页面加载期间承受的挫败程度，以此作为得分。

这是用户体验的关键性能指标，因为它完全关注用户。

### 广告权重影响

如果您的网站上通过广告来产生收入，那么你必须知道它会给用户带来的额外负担，因为它可能会使网页性能下降，这对你至关重要。由 Paddy Ganti 创建的一个[脚本](https://calendar.perfplanet.com/2017/measuring-adweight/)可以帮助你找出广告相关代码的权重。

### 偏差指标

我们谈到了许多不同的指标。但是上述所有指标的问题都存在的问题是一致性。结果的差异表明你的网站在整个网络中的可靠性。这也表示你必须对系统和基础结构给予多少关注才能提供简化的服务。由于某些外部脚本非常不可靠，因此特定页面的差异可能更大。正如 Vitaly 所说，跟踪受支持的浏览器版本也是一个好主意，可便于更好地了解性能。

## 为什么要为你的网站考虑指标组合？

每个网站都有自己的目标受众。根据网站的功能和服务对象，你应将重点更多地放在特定指标上。

例如，如果您是流媒体提供商，则应将更多的精力放在输入响应性、内存使用率和 TTI 这些关键点上，因为它们对于你的应用程序至关重要。但是，如果您的网站上的内容更关注可读性，例如 Wikipedia 和 Medium，则应更多地关注外观变化和 CPU 指标。如果你自己的博客中集成了广告，则还应该关注广告权重的影响。此外，挫折指数可以应用于所有上述示例，因为任何网站的主要目标都是避免用户受挫，因为它可能对用户体验产生负面影响。

> 你只有一次机会给人留下第一印象。把握好这次机会（提升你的网站性能）！

---

这是本文的全部内容。我强烈建议你阅读以下资源，因为它们对于 Web 性能这个广泛的领域非常有教育意义。


**资源**
- [Front-End Performance Checklist 2020 by Vitaly Friedman](https://www.smashingmagazine.com/2020/01/front-end-performance-checklist-2020-pdf-pages/)
- [Presentation by Marcos Iglesias](https://docs.google.com/presentation/d/e/2PACX-1vTk8geAszRTDisSIplT02CacJybNtrr6kIYUCjW3-Y_7U9kYSjn_6TbabEQDnk9Ao8DX9IttL-RD_p7/pub?start=false&loop=false&delayms=10000&slide=id.g3ccc19d32d_0_98)
- [Article by Steve Souders](https://speedcurve.com/blog/rendering-metrics/)
- [Article by Philip Walton](https://web.dev/user-centric-performance-metrics/)
- [Article by Mat Ball](https://blog.newrelic.com/product-news/monitor-frontend-performance-with-user-centric-performance-metrics/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
