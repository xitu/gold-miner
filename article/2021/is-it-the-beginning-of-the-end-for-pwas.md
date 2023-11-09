> * 原文地址：[Is It the Beginning of the End for PWAs?](https://blog.bitsrc.io/is-it-the-beginning-of-the-end-for-pwas-da0fb032d545)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[Usualminds](https://github.com/Usualminds)

# 渐进式应用程序 PWA 开始衰落了吗？
> Firefox 之后会有谁效仿？

![由 [Szabo Viktor](https://unsplash.com/@vmxhu?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*LmCaetpJHYbKh2bn)

渐进式 Web 应用程序正通过 Web 为我们提供类似于原生应用程序的体验，改变了我们对应用程序的理解。这种方式让应用程序得以利用现代浏览器支持的新功能，包括 Service Worker 和 Web App Manifest，并且还允许用户无需考虑其原生的操作系统，将 Web 应用程序升级为渐进式 Web 应用程序。

但是，PWA 在这些年也引发了一些隐私问题，导致 Apple 停用了 Safari 上的一些 PWA 功能。你可以在[另一篇文章中](https://blog.bitsrc.io/the-darker-side-of-pwas-you-might-not-be-aware-of-ffa7b1d08888)了解更多相关信息。

尽管如此，Chrome 以及 Firefox 等其他浏览器却仍然在大力支持 PWA 的开发。

不过，Mozilla 最近发布了旨在防止超级 Cookie 的 Firefox 85，似乎也已放弃了对桌面 PWA 的一项基本功能的支持，让我们看看它是什么。

## Firefox 放弃了什么？

Firefox 放弃了一项支持在桌面端安装 PWA 的功能，即**“特定站点的浏览器”（Site Specific Browser，SSB）**。

一直关注这个问题的人可能会知道，Mozilla 曾经[提及过](https://bugzilla.mozilla.org/show_bug.cgi?id=1682593)未来的版本可能会放弃对 SSB 的支持。我们可以在 bug 跟踪板块的评论区中找到放弃这个功能的原因。

> SSB 功能一直都只能通过隐藏选项开启，并且有着多个已知的 bug。另外，从*用户调查*发现，几乎没有人意识到该功能的好处，因此目前我们没有继续开发该功能的想法。为了修复这个 bug，我们花费了过多的时间，持续维护的行为也让大家误以为我们还支持这个功能，因此我们决定将它从 Firefox 中移除。

### 什么是 SSB？

SSB 是一项实验性功能，允许任何网站以其独有的窗口在桌面模式下运行。该功能在 Firefox 73 及更高版本中可用，让我们可以在 UI 精简的窗口中启动任何网站。

## 这算是坏了一桩好事吗？

这完全取决于你的观点和你对 PWA 的预期用途。如果你认为 PWA 可以让应用独立于平台并像原生应用一样运行，那么你可能会对这一决定感到失望。但如果你认为 PWA 只是桌面上的快捷方式，那么你可能不会在意此更改。

有很多人对此决定不满意，但是与用户总数相比，这部分人数还是很少的。主要原因在于这是实验性功能，并不为许多人所知。

正如[伊恩](https://www.i-programmer.info/news/87-web-development/14261-firefox-drops-support-for-pwa.html)所说：

> 用户不会感到失望，因为他们不知道移除了什么功能。话说回来，他们又凭什么在乎你在创建原生应用程序上付出的额外努力呢？

由于技术发展日新月异，企业在研发上投入了大量资源。实验性功能至关重要，它们决定了应用程序的未来。当重要的功能被移除时，这会误导用户群体。

但是，当时机成熟且 PWA 成为突出的浏览器功能时，此举可能会让 Firefox 失去大量用户，让他们转而使用其它的浏览器。

## 为什么要大惊小怪？

你可能会开始怀疑我是不是标题党，对吧！但不，我并不是。

科技领域的共同趋势是：

* 公司采取了激进的举措
* 竞争对手嘲笑他们
* 几年后，嘲笑此举的竞争对手也采取了同样的举措

你可以将这个趋势与一些值得注意的事件相联系，例如取消耳机插孔，取消手机中的主页按钮以及最近的趋势 —— 取消充电器。

Mozilla 提到，移除 SSB 的原因是这个功能造成了麻烦，并且浪费了宝贵的时间。在这种情况下，Chrome 和 Edge 等同类产品也可能会认为采取同样的行为对他们有利，并且由于过去发生过类似的事件，我们可能会在一段时间内失去桌面端的 PWA 的支持。尽管这几乎不可能发生，但还是不排除有一定的几率，尤其是在科技领域。

你如何看待 Mozilla 的举措？在下面评论区分享你的看法吧。

感谢你的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
