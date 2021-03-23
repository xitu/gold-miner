> * 原文地址：[Web Almanac Mega Study Reveals That Popular Front-End Frameworks Are Still a Small Part of the Web](https://www.infoq.com/news/2021/03/web-almanac-2020)
> * 原文作者：Suresh Kumar
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/web-almanac-2020.md](https://github.com/xitu/gold-miner/blob/master/article/2021/web-almanac-2020.md)
> * 译者：
> * 校对者：

# Web Almanac Mega Study Reveals That Popular Front-End Frameworks Are Still a Small Part of the Web

The HTTP Archive recently finalized the Web Almanac 2020, an annual report on the state of the web. The report gathers its conclusions in 22 chapters organized in four sections (e.g, page content, user experience, content publishing and distribution) totaling 600 pages: jQuery is still 80% of the web; CSS Houdini is seldom used; the median website ships 400 KB of JavaScript in 2020, 14% more than in 2019; and many more.

The CSS chapter emphasized that adoption of some shiny additions or proposals enriching the CSS standard may be lagging:

> Overall, what we observed was a web in two different gears when it comes to CSS adoption. In our blog posts and Twitter bubbles, we tend to mostly discuss the newest and shiniest, however, there are still millions of sites using decade-old code. [… While] we also observed impressive adoption of many new features—even features that only got support across the board this very year, like min() and max(), […] there is generally an inverse correlation between how cool something is perceived to be and how much it is actually used; for example, cutting-edge Houdini features were practically nonexistent. […] Most CSS usage in the wild is fairly simple.

The CSS chapter additionally reports that the median weight of CSS is around 60 KB aggregating over 400 rules and 5,000 declarations. The majority of websites are now using [Flexbox layouts](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) (around 60% in 2020 vs. 40% in 2019). CSS Grid layouts (`display:grid`) are picking up (doubling its share vs. 2019) but remain a distant minority (5% of websites). Transitions and animations are quite extended across the web with over 80% of pages featuring a `transition` property and over 70% having an **`animation`** property. Visual effects (blend modes, image filters, clipping paths) are popular CSS features: CSS filters are used in 80% of pages; blend modes doubled their share over the previous year and amount to 13% of pages.

By contrast, only 2% of websites use any CSS-in-JS method, despite CSS-in-JS being plentifully discussed among web developers. CSS Houdini is also used in a vanishingly small portion of web pages. The report says:

> The CSS Painting API is a more broadly implemented Houdini spec that allows developers to create custom CSS functions that return <image> values, e.g. to implement custom gradients or patterns. Only 12 pages were found to be using paint(). Each worklet name (hexagon, ruler, lozenge, image-cross, grid, dashed-line, ripple) only appeared on one page each, so it appears the only in-the-wild use cases were likely demos.Typed OM, another Houdini specification, allows access to structured values instead of the strings of the classic CSS OM. It appears to have considerably higher adoption compared to other Houdini specs, though still low overall. It is used in 9,864 desktop pages (0.18%) and 6,391 mobile ones (0.1%).

The JavaScript chapter of the report indicates around 14% growth in the size of JavaScript loaded by pages, with the median page at around 400 KB of JavaScript. The report notes that pages targeting mobiles and pages targeting desktops have similar JavaScript payloads while largely differing in networking and processing capabilities; and that 37% of the JavaScript on the median web page is unused. The report says:

> Depending on your point of view, you could be forgiven for not getting too upset about the small gap in the amount of code sent to a desktop browser versus a mobile one—after all, what’s an extra 30 KB or so at the median, right? […]The median desktop site spends 891 ms on the main thread of a browser working with all that JavaScript. The median mobile site, however, spends 1,897 ms—over two times the time spent on the desktop. It’s even worse for the long tail of sites. At the 90th percentile, mobile sites spend a staggering 8,921 ms of main thread time dealing with JavaScript, compared to 3,838 ms for desktop sites.

On the bright side, [resource hints](https://www.infoq.com/news/2019/09/webexpo-2019-resource-hints-tips/), which allow offsetting some of the network costs of loading JavaScript, are used in nearly 17% of pages, with nearly all that usage coming from [`preload`](https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content).

The Third Parties chapter of the report analyzes the presence, distribution, and impact of third-party scripts, emphasizing the importance of managing them:

> Advertising requests appear to have an increased impact on CPU time. The median page with advertising scripts consumes three times as much CPU as those without.

Developers can [consult the full report online](https://almanac.httparchive.org/en/2020/) in four different languages. The HTTP Archive took more than five months to compile the Web Almanac, with hundreds of contributors scouring through million websites’ data. The HTTP Archive evaluates the composition of millions of web pages on a monthly basis and makes its terabytes of metadata available for analysis on [BigQuery](https://httparchive.org/faq#how-do-i-use-bigquery-to-write-custom-queries-over-the-data).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
