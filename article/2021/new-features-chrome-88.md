> * 原文地址：[New Features in Chrome 88 Devtools](https://www.infoq.com/news/2021/03/new-features-chrome-88/?topicPageSponsorship=eb89fa44-b190-43ef-87d0-4bc8727e7413)
> * 原文作者：[Guy Nesher](https://www.infoq.com/profile/Guy-Nesher/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-features-chrome-88.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-features-chrome-88.md)
> * 译者：
> * 校对者：

# New Features in Chrome 88 Devtools

The recent release of Chrome 88 includes significant updates to the Chrome DevTools, including improved network debugging, experimental CSS Flexbox debugging tools, improved frame details view, new WASM debug capabilities, and general performance improvements.

The network tab offers three new capabilities aimed at simplifying the debug process:

1. Request properties can now be copied directly from the network tab by right-clicking the specific request and selecting 'Copy value.'
2. The stack trace for the network initiator can now be copied from individual network requests by selecting the 'Copy stack trace' option.
3. Failed [**C**ross-**O**rigin **R**esource **S**haring](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors) will now be flagged correctly on the network view.

[CSS Flexbox](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox) is a powerful design tool that is often difficult to debug - as it operates on both axes. To simplify the debugging process, Chrome offers two new badges. The first badge appears on the elements hierarchy view and flags elements with *display:flex* applied to them.

The second badge is a context-aware alignment indicator that is based on the following flexbox properties:

* flex-direction
* align-items
* align-content
* align-self
* justify-items
* justify-content

While taking into account the direction based on:

* flex-direction
* direction
* writing-mode

To use flexbox debugging, developers need to enable it under the Settings > Experiments tab.

![](https://res.infoq.com/news/2021/03/new-features-chrome-88/en/resources/113-flex-debugging-1614281700033.png)

The Chrome 88 Devtools also provide an improved frame details view that includes additional information on Cross-origin isolation information status, dedicated information on frame web workers, and the ability to discover which frame triggers another Window opening.

Chrome 88 also aligns [Wasm](https://developer.mozilla.org/en-US/docs/WebAssembly) debugging with existing Javascript debugging capabilities. While pausing execution on a breakpoint, developers can either hover over variables to see their current values or evaluate them in the Console.

Finally, the DevTools startup is now nearly 40% faster in terms of JavaScript compilation due to the reduced performance overhead of serialization, parsing, and deserialization during the startup.

Chrome DevTools provides a rich set of utilities for debugging web applications and is used in most Chromium-based browsers. The Chrome development team continues to improve the DevTools and ships new features with every release of Chrome. Developers can keep track of the latest features on the [Google developers website](https://developers.google.com/web/updates/tags/devtools) and discuss possible features, changes, and bugs on the [mailing list](https://groups.google.com/forum/#!forum/google-chrome-developer-tools).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
