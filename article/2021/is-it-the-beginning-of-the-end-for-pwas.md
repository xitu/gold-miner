> * 原文地址：[Is It the Beginning of the End for PWAs?](https://blog.bitsrc.io/is-it-the-beginning-of-the-end-for-pwas-da0fb032d545)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 这会是渐进式应用程序 PWA 衰落的开始吗？
> Firefox 之后会有谁跟上来这么做？

![由 [Szabo Viktor](https://unsplash.com/@vmxhu?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*LmCaetpJHYbKh2bn)

渐进式 Web 应用程序正通过 Web 表现形式为我们提供类似于原生应用程序的体验，改变着我们对应用程序的理解。这是一种描述利用现代浏览器支持的新功能的应用程序的方式，包括 Service Worker 和 Web App Manifest，并且还允许用户无需考虑其原生的操作系统，将 Web 应用程序升级为渐进式 Web 应用程序。

但是，多年来，PWA 本身也带来了一些隐私问题，导致 Apple 停用了 Safari 上的一些 PWA 功能。你可以[阅读有关它们的更多信息](https://blog.bitsrc.io/the-darker-side-of-pwas-you-might-not-be-aware-of-ffa7b1d08888)。

尽管如此，Chrome 以及 Firefox 等其他浏览器却仍然在大力支持 PWA 的开发。

不过最近，Mozilla 发布了旨在防止超级 Cookie 的 Firefox 85，似乎也已放弃了对桌面 PWA 的一项基本功能的支持，让我们看看它是什么：

## 什么被舍弃了？

Firefox 放弃了一项用于支持在桌面上安装 PWA 的功能，**“特定站点的浏览器”（Site Specific Browser，SSB）**。

对于那些一直关注着这个问题的人，他们知道 Mozilla 曾经[提及过](https://bugzilla.mozilla.org/show_bug.cgi?id=1682593)他们可能会在将来的版本中放弃对 SSB 的支持。我们可以在 Issue Tracker 的注释中找到删除它的原因。

> SSB 功能曾经可通过隐藏的选项开启，并且有着多个已知的错误。另外，从*用户调查*发现，几乎没有人意识到该功能的好处，因此目前我们没有继续对其进行开发的想法。由于我们在这个功能上的错误的开发优先度，我们浪费了太多的时间，并且维护它的举动误导着大家，似乎告诉着别人我们还支持这个功能，因此我们决定将它从 Firefox 中删除。

### 什么是 SSB？

SSB 是一项实验性功能，允许任何网站以其自己的窗口在桌面模式下运行。它在 Firefox 73 及更高版本中可用，让我们可以以最简的 UI 窗口中启动任何网站。

## 这是底线吗？

这完全取决于你的观点和你对 PWA 的预期用途。如果你认为 PWA 是获取独立于平台并像原生应用程序一样运行的应用程序的一种方式，那么你可能会对这一决定感到失望。但如果你认为 PWA 只是桌面上的快捷方式，那么你可能不会在意此更改。

有很多人对此决定不满意，但是与用户总数相比，这个数字还是很低的。这主要是因为这是实验性功能，并不为许多人所知。

正如[伊恩](https://www.i-programmer.info/news/87-web-development/14261-firefox-drops-support-for-pwa.html)所说：

> 用户不会感到失望，因为他们不知道什么被拒绝了，以及这个举措原因是什么，并且会对你在创建原声应用程序上付出了额外的努力这个举动毫不在意，甚至感到疑惑。

由于技术发展日新月异，因此企业们在研发上花费了大量资源。实验功能至关重要，它们决定了应用程序的未来。当重要的东西被遗弃时，它会误导用户群体。

但是，当时机成熟且 PWA 成为突出的浏览器功能时，此举可能会让 Firefox 失去大量用户，让他们去使用替代的浏览器。

## 为什么要大惊小怪？

你可能会开始怀疑我是不是标题党，对吧！但不，我并不是。

科技界的共同趋势是：

* 公司采取了决定性的举措
* 竞争对手嘲笑他们
* 几年后，嘲笑此举的竞争对手也采取了同样的举动

你可以将其与一些值得注意的事件相关，例如取消耳机插孔，取消手机中的主页按钮以及最近的趋势 —— 取消掉充电器。

提到的删除 SSB 的原因是，这个功能造成了麻烦，也浪费了宝贵的时间。在这种情况下，Chrome 和 Edge 等同类产品也可能会认为采取同样的行为对他们有利，并且由于过去发生过类似的事件，我们可能会在一段时间内丢失桌面端的 PWA。尽管这不太可能发生，但总是有机会发生这种情况，尤其是在科技领域。

你如何看待 Mozilla 的举动？在下面对其进行评论吧～

感谢您的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
