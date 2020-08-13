> * 原文地址：[8 Unheard of Browser APIs You Should Be Aware Of](https://medium.com/better-programming/8-unheard-of-browser-apis-you-should-be-aware-of-45247e7d5f3a)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/8-unheard-of-browser-apis-you-should-be-aware-of.md](https://github.com/xitu/gold-miner/blob/master/article/2020/8-unheard-of-browser-apis-you-should-be-aware-of.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[onlinelei](https://github.com/onlinelei)

# 你应该了解的八种浏览器 API

![Photo by [Szabo Viktor](https://unsplash.com/@vmxhu?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9990/0*WzOJqPzOSrcQrX5b)

随着网页流行度的提高，浏览器开发商开始发布用于复杂功能的 API，这些 API 有时只能通过本机应用程序实现。快速发展到现在，很难找到只使用一两个浏览器 API 的 web 应用程序。

随着 Web 开发领域的不断发展，浏览器供应商也试图跟上行业的快速发展。他们不断开发更新的 API，这些 API 可以为您的 Web 应用程序带来类似 Native 的新功能。虽然现在很多主流的浏览器已完全支持这些 API，但是人们对这些 API还不是很了解。

您应该了解以下这些 API，因为它们在未来会发挥至关重要的作用。

## Web 锁 API

该 [API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Locks_API) 允许您在多个选项卡上运行 Web 应用程序，以访问和协调资源共享。虽然简单的日常 Web 应用程序在多个选项卡上运行并不常见，但是在某些复杂的情况，您运行的 Web 应用程序需要开启多个选项卡并使它们保持同步。在这些情况下，这个 API 可能会派上用场。

尽管可以使用诸如 SharedWorker，BroadcastChannel，localStorage，sessionStorage，postMessage，卸载处理程序之类的 API 来管理选项卡通信和同步，但它们各自都有缺点，而且急待解决方案，这会降低代码的可维护性。Web 锁 API 试图通过引入更标准化的解决方案来简化此过程。可以使用共享工作器，广播通道，localStorage，sessionStorage，postMessage 等。

虽然 Chrome 69 默认启用了该功能，但主流浏览器（如 Firefox 和 Safari）仍不支持该功能。

**小贴士：** 你应该了解诸如“死锁”之类的概念，以避免在使用此 API 时陷入困惑。

## 形状检测 API

作为网络开发人员，您可能有很多实例需要安装外部库来处理对元素的检测，例如图像中的面部，文本和条形码，这是因为没有 Web 标准 API 供开发人员使用。

Chrome 小组正在尝试通过在 Chrome 浏览器中提供实验性的[形状检测 API](https://web.dev/shape-detection/) 并将其设置为网络标准来改变这一点。

尽管此功能是实验性功能，但可以通过启用 chrome://flags 中的 ＃enable-experimental-web-platform-features 标志来本地访问。

![Photo by [Element5 Digital](https://unsplash.com/@element5digital?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9542/0*0NoSa7j_eQ1npFws)

## 付款请求 API

这个[付款请求 API](https://developer.mozilla.org/zh-CN/docs/Web/API/Payment_Request_API) 可帮助客户和卖方更加便利地完成结帐过程。这种新方法消除了结帐表格，并从根本上改善了用户的付款体验。借助对 Apple Pay 和 Google Pay 的支持，该 API 有望成为电子商务领域的主要组成部分。

此外，由于凭据是在浏览器中管理的，因此客户可以更轻松地从移动浏览器切换到桌面浏览器，并且仍然可以访问其卡信息。该 API 还允许从商家端进行自定义。您可以提及支持的付款方式和支持的卡，甚至可以根据送货地址提供送货选项。

## 页面可见性 API

平时经常遇到一台电脑，在浏览器中打开了大约 20 个奇怪标签。我曾经有一个朋友，在修复了一个错误之后，他关闭了大约 100 多个选项卡。浏览器甚至已经开始[实现功能](https://blog.google/products/chrome/manage-tabs-with-google-chrome/) 来对选项卡进行分组以使它们更加有序。

借助[页面可见性API](https://developer.mozilla.org/zh-CN/docs/Web/API/Page_Visibility_API)，您可以检测网页是否空闲。换句话说，您可以找出用户是否正在查看包含网页的选项卡。

尽管这听起来很简单，但是在提高网站的用户体验方面可能非常有效。在下面几种使用情况，都可以使用此 API。

* 在浏览器选项卡处于非活动状态时，下载其余的应用程序捆绑包资源和媒体资源。这将帮助您非常有效地利用空闲时间。
* 当用户最小化或切换到另一个选项卡时，暂停视频。
* 当选项卡处于非活动状态时，暂停图像幻灯片/回声显示。

尽管开发人员过去曾经在窗口上使用过诸如“模糊”和“聚焦”之类的事件，但他们并没有告诉您您的页面是否实际上对用户隐藏了。页面可见性 API 帮助解决了这个问题。

该浏览器 API 与大多数浏览器兼容。

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API#Browser_compatibility)](https://cdn-images-1.medium.com/max/2000/1*I743ncklwG4-veVjsVFfSA.png)

## Web 分享 API

这个 [Web 分享 API](https://www.w3.org/TR/web-share/) 可以让你像使用本地应用程序一样分享链接，文本和文件，给你的本地应用程序。该 API 可以帮助增加用户对 Web 应用程序的参与度。您可以阅读 Joe Medley 的博客 [post](https://web.dev/web-share/)，以了解有关此炫酷 API 的更多信息。

截至 2020 年中，此 API 仅在 Safari 和 Chromium fork 中的 Android 上可用。 [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share#Browser_compatibility) 查看更多浏览器兼容性信息。

![The native Share interface. Screenshot by the author.](https://cdn-images-1.medium.com/max/2000/1*uhEtWw7OEueQkMPXrn6Akw.png)

## 共享目标 API

渐进式 Web 应用程序通过在 Web 窗体中提供类似应用程序的体验，正在改变我们对应用程序的理解方式。根据 StateOfJS 网站的数据，大约 48.2％的用户使用了 PWA，而 45.5％的用户知道什么是 PWA,这表明了 PWA 的影响。您可以在[此处](https://medium.com/better-programming/progressive-web-apps-an-overview-c6e4328ef2d2?source=friends_link&sk=94b7cf9919c4bb86e407604dd975dadb)上阅读有关 PWA 的更多信息。

尽管 PWA 具有许多类似本机的功能，但是它们缺乏从本机应用程序接收文件的方法。使用此 API，您可以从其他本机应用程序接收链接，文本和文件。Chrome 76 及更高版本仅支持 Android。您可以通过[此处](https://web.dev/web-share-target/)阅读有关此 API 的更多信息。

## 推送 API

这个[Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) 允许 Web 应用程序接收从服务器推送到它们的消息，而不管该应用程序是否在前台。即使未在浏览器中加载应用，它也可以正常工作。这使开发人员可以及时向用户传递异步通知。但这要起作用，应该在使用 API 之前获得用户许可。

您可以在 Flavio 的[精彩文章](https://flaviocopes.com/push-api/) 中阅读有关 Push API 的更多信息。

## Cookie 缓存 API

众所周知，使用 Cookie 会有点慢，因为它是同步的。但是 [Cookie 缓存 API](https://developers.google.com/web/updates/2018/09/asynchronous-access-to-http-cookies) 提供了对 HTTP cookie 的异步访问。此外，此 API 还向服务工作者公开了这些 HTTP cookie。

尽管有一些帮助程序库可以帮助完成所有通常的 cookie 操作，但借助 Cookie Store API，它会变得更加轻松和高效。该 API 有时也称为 Async Cookies API。

您可以在[此处](https://wicg.github.io/cookie-store/explainer.html)了解有关此 API 的更多信息。

## 总结

当我使用这些 API 时，我它们感到惊讶。如前所述，上述 API 唯一令人失望的是缺乏主流浏览器的支持。这意味着在生产中使用它们并不简单。但是可以肯定的是，这些 API 无疑将在浏览器和 Web 开发的中发挥至关重要的作用。



## 参考资料

* [MDN web docs](https://developer.mozilla.org/en-US/)
* [SitePen](https://www.sitepen.com/blog/cross-tab-synchronization-with-the-web-locks-api/)
* [StateOFJS](https://2019.stateofjs.com/)
* [Creative Bloq](https://www.creativebloq.com/features/15-web-apis-youve-never-heard-of)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
