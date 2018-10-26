> * 原文地址：[Shine a light on JavaScript performance with Lighthouse](https://dev.to/addyosmani/shine-a-light-on-javascript-performance-with-lighthouse-1opf)
> * 原文作者：[Addy Osmani](https://dev.to/addyosmani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/shine-a-light-on-javascript-performance-with-lighthouse-1opf.md](https://github.com/xitu/gold-miner/blob/master/TODO1/shine-a-light-on-javascript-performance-with-lighthouse-1opf.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：

# 通过 Lighthouse 了解 JavaScript 性能

不确定 [JavaScript 的开销](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)对于您那的用户体验来讲是不是太高了？🙃 [Lighthouse](https://developers.google.com/web/tools/lighthouse/)有  [JavaScript 执行时间审计](https://developers.google.com/web/tools/lighthouse/audits/bootup)，用来衡量 JavaScript 对于页面加载性能的影响。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--sglLOF1R--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ggbnzgr8b1k8suklbjsr.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--sglLOF1R--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ggbnzgr8b1k8suklbjsr.png)

试试如何？现在它已经在 Chrome DevTools [审计（Audits）](https://developers.google.com/web/updates/2017/05/devtools-release-notes#lighthouse)面板里边了。同样可以通过访问 [WebPageTest](https://webpagetest.org/easy) 来使用。

对于上面的内容站点，移动设备上的浏览器需要 51s（oi vey）才能处理完主包。算上网络传输时间，用户可能需要等待一分钟才能和这个页面进行交互 ⏳😪

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--vm1znBte--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/oqmf5qnqt89lt5f81pub.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--vm1znBte--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/oqmf5qnqt89lt5f81pub.png)

这是花在中等配置的移动设备上的解析、编译和执行脚本的时间。[dev.to](https://dev.to)（提供类似的内容体验）能够加载他们的他们的主包，并对脚本执行的依赖最小❤️

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--ZzfpjOGJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/detuj3z8swkr729nb6zs.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--ZzfpjOGJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/detuj3z8swkr729nb6zs.png)

我们怎样才能优化原始网站 JS 的成本呢？

只有当用户真正需要前，才传输 JavaScript。我们可以使用像[代码分割](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/code-splitting/)的技术来实现对剩余部分的懒加载。我使用 DevTools 的 [Code Coverage](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage) 功能提供帮助。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--gW_GJhzR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ksqhn42t3sswm0oah9zd.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--gW_GJhzR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ksqhn42t3sswm0oah9zd.png)

如果我开始记录并加载上述网站然后交互一段时间，我们可以看到可能不需要预加载大约 57% 的代码。对于可以按需加载的资源来说，这是很好的备选方案。

如果你之前没有仔细看过 Lighthouse，那么他会有很多有用的小模块，比如检查你是否正确精简或者压缩脚本。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--vN61H7CR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/uwsg5tivewa8plw9o8jt.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--vN61H7CR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/uwsg5tivewa8plw9o8jt.png)

如果你使用无头浏览器进行自动化操作，那么 [Puppeteer](https://developers.google.com/web/tools/puppeteer/) 还有一个很有用的 [code-coverage example](https://github.com/GoogleChromeLabs/puppeteer-examples#code_coveragejs) 示例，可以在页面加载的时候可视化 JS 代码覆盖率的使用情况。

结束.. 🎁

JavaScript 会对您的用户体验产生巨大的影响; Lighthouse 可以突出改善此处的机会。为了保持较低的 JavaScript 传输和处理时间：

*   只发送你用户需要的代码
*   精简压缩脚本
*   移除未使用的代码和依赖

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
