> * 原文地址：[Web Almanac Mega Study Reveals That Popular Front-End Frameworks Are Still a Small Part of the Web](https://www.infoq.com/news/2021/03/web-almanac-2020)
> * 原文作者：[Bruno Couriol](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/web-almanac-2020.md](https://github.com/xitu/gold-miner/blob/master/article/2021/web-almanac-2020.md)
> * 译者：[felixliao](https://github.com/felixliao)
> * 校对者：

# 网络年鉴大研究表明热门的前端框架依然是互联网的一小部分

HTTP Archive 最近完成了 2020 网络年鉴，一份关于网络状况的年度报告。这份报告从四个部分（页面内容、用户体验、内容发表和分发）中的 22 个章节和 600 页中得出结论：jQuery 的使用率仍然高达 80%；CSS Houdini 很少被使用；2020 年网站发送的 JavaScript 大小中位数为 400 KB，比 2019 年多了 14%。除此以外，还有更多其他结论。

CSS 的章节强调，一些为丰富 CSS 标准的新功能或提案的采用可能会滞后：

> 总的来看，我们观察到互联网上 CSS 的采用处在两个不同的层次。在博客和推文中我们更趋向于讨论最新最亮的东西，但是还是有成千上万的站点在使用十年前的代码。（……尽管）我们观察到许多新功能有引人注目的采用率 —— 甚至是那些今年才得到广泛支持的功能，例如 `min()` 和 `max()`，（……）总体上看，一个东西的酷炫程度和它的应用范围有多广还是呈反比；例如，先进的 Houdini 功能基本上不存在。（……）实践中大部分 CSS 的使用比较简单。

CSS 的章节还指出 CSS 文件的中位大小在 60 KB 左右，基本上包含超过 400 条规则和 5000 条声明。大部分网站如今已在使用 [Flexbox 布局](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)（2020 年为 60% 左右，2019 年为 40%）。CSS 网格布局（`display:grid`）正在被更多地使用（其使用率比起 2019 年翻了一番）但是依然是极其小众的（只有 5% 的网站使用）。过渡和动画使用非常广泛，超过 80% 的页面包含 `transition` 属性，超过 70% 包含 `animation` 属性。视觉效果（混合模式、图像滤镜、剪切路径）是非常热门的 CSS 功能：CSS 滤镜被使用于 80% 的页面；混合模式的占比和去年比翻倍，13% 的页面在使用它。

相比之下，只有 2% 的网站使用任何 CSS-in-JS 的手段，尽管 CSS-in-JS 在开发者之间的讨论非常多。CSS Houdini 在网页中的使用也只有微乎其微的比例。该报告称：

> CSS Painting API 是一个 Houdini 中被更为广泛实现的规范，它允许开发者创建自定义 CSS 函数来返回 `<image>` 值，例如实现自定义渐变或图案。但是我们发现只有 12 个页面在使用 `paint()`，且每个工作集名称 （`hexagon`、`ruler`、`lozenge`、`image-cross`、`grid`、`dashed-line`、`ripple`）在每个页面只出现了一次。由此看来，仅有的实践案例很可能是演示。Typed OM，另一个 Houdini 规范，允许了结构化数值的存取，而不是传统 CSS OM 中的字符串。比起其他 Houdini 规范，它有明显更高的采用率，尽管和整体比还是很低。它被应用于 9846 个桌面端站点（0.18%）和 6391 个移动端站点（0.1%）。

报告中的 JavaScript 章节称页面加载的 JavaScript 体积增长了约 14%，其中中位页面会加载 400 KB 左右的 JavaScript。报告指出针对桌面端和移动端的页面有相近的 JavaScript 体积，但其网络和处理性能有很大差别；以及中位网站上有 37% 的 JavaScript 代码是没有被使用的。报告写道：

> 取决于你的看法，你也许可以宽恕自己没有因为发送到桌面端和移动端代码间小小的区别感到懊恼 — 毕竟，30 KB 的中位差能怎么样呢，对吧？[...] 中位桌面站点花费浏览器主进程 891 毫秒来处理这些 JavaScript。然而，中位移动端站点花费 1897 毫秒 — 是桌面端花费时间的两倍多。这在底层的页面上更为糟糕。在 90 百分位，移动端页面要占据主进程 8921 毫秒来处理 JavaScript，相比之下桌面站点只需要 3838 毫秒。

好的一面是，[resource hints](https://www.infoq.com/news/2019/09/webexpo-2019-resource-hints-tips/) 可以抵消一些加载 JavaScript 的网络成本，它在将近 17% 的页面中被使用，其中大部分来自于 [`preload`](https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content)。

报告中关于第三方的章节分析了第三方脚本的存在、分布和影响，并强调了管理它们的重要性：

> 广告相关的请求似乎对 CPU 时间有负面影响。包含广告脚本的中位页面，比起那些不含脚本的，花费了最多三倍 CPU 时间。

开发者们可以用四种语言[在线参考完整的报告](https://almanac.httparchive.org/en/2020/)。HTTP Archive 花费超过五个月来编写互联网年鉴，数百计的贡献者搜集了数百万网页的数据。HTTP Archive 每月评估数百万网页的构成，并将其 TB 级的元数据公开在 [BigQuery](https://httparchive.org/faq#how-do-i-use-bigquery-to-write-custom-queries-over-the-data) 上供分析使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
