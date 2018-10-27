> * 原文地址：[Shine a light on JavaScript performance with Lighthouse](https://dev.to/addyosmani/shine-a-light-on-javascript-performance-with-lighthouse-1opf)
> * 原文作者：[Addy Osmani](https://dev.to/addyosmani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/shine-a-light-on-javascript-performance-with-lighthouse-1opf.md](https://github.com/xitu/gold-miner/blob/master/TODO1/shine-a-light-on-javascript-performance-with-lighthouse-1opf.md)
> * 译者：
> * 校对者：

# Shine a light on JavaScript performance with Lighthouse

Unsure if the [cost of JavaScript](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4) is too high for your user-experience? 🙃 [Lighthouse](https://developers.google.com/web/tools/lighthouse/) has a [JavaScript execution time audit](https://developers.google.com/web/tools/lighthouse/audits/bootup) that measures the total impact of JavaScript on your page's load performance:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--sglLOF1R--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ggbnzgr8b1k8suklbjsr.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--sglLOF1R--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ggbnzgr8b1k8suklbjsr.png)

Try it. It's in the Chrome DevTools [Audits](https://developers.google.com/web/updates/2017/05/devtools-release-notes#lighthouse) panel today. It's also available via [WebPageTest](https://webpagetest.org/easy).

For the above content site, it takes 51s (oi vey) for the browser to process just the primary bundle for this site on mobile. Including network transfer time, a user could be waiting for up to a minute to [interact](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/) with this page ⏳😪

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--vm1znBte--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/oqmf5qnqt89lt5f81pub.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--vm1znBte--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/oqmf5qnqt89lt5f81pub.png)

That's time spent parsing, compiling and executing script on a median mobile device configuration. [dev.to](https://dev.to) (offering a similar content experience) is able to load their main bundle with a minimal dependency on script execution ❤️

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--ZzfpjOGJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/detuj3z8swkr729nb6zs.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--ZzfpjOGJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/detuj3z8swkr729nb6zs.png)

How can we improve the cost of JS in the original site?

By only shipping JavaScript the user really needs upfront. We can lazily load the rest as needed using techniques like [code-splitting](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/code-splitting/). I use the DevTools [Code Coverage](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage) feature to help here.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--gW_GJhzR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ksqhn42t3sswm0oah9zd.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--gW_GJhzR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/ksqhn42t3sswm0oah9zd.png)

If I hit record and load up the above experience then interact for a while, we can see about 57% of the code loaded upfront may not be needed. That's a great candidate for something that can be loaded on-demand.

If you haven't checked out Lighthouse before, it's full of useful nuggets like checks for whether you're correctly minifying your scripts or compressing them:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--vN61H7CR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/uwsg5tivewa8plw9o8jt.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--vN61H7CR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/uwsg5tivewa8plw9o8jt.png)

And if you're into automation using headless Chrome, there's also a useful [code-coverage example](https://github.com/GoogleChromeLabs/puppeteer-examples#code_coveragejs) for [Puppeteer](https://developers.google.com/web/tools/puppeteer/) that can visualize JS code coverage usage across page loads.

Wrapping up.. 🎁

JavaScript can have a large impact on your user-experience; Lighthouse can highlight opportunities to improve here. To keep JavaScript transmission and processing times low:

*   Only send the code that your users need.
*   Minify and compress your scripts.
*   Remove unused code and dependencies.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
