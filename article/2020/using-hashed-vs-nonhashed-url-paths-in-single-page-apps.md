> * 原文地址：[Using Hashed vs. Non-Hashed URL Paths in Single Page Apps](https://blog.bitsrc.io/using-hashed-vs-nonhashed-url-paths-in-single-page-apps-a66234cefc96)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-hashed-vs-nonhashed-url-paths-in-single-page-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-hashed-vs-nonhashed-url-paths-in-single-page-apps.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[JohnieXu](https://github.com/JohnieXu)

# 单页应用程序的哈希 URL 与普通 URL

![图片由 [Eric Binder](https://pixabay.com/users/Yivra-1836258/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2998837) 发布于 [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2998837)](https://cdn-images-1.medium.com/max/3840/1*jAhsrJZmP8gM3gwZmSrliQ.jpeg)

在单页应用程序支持以下两种路由方式：

* 哈希 URL 路径 - 我们使用 ＃（哈希）分隔网址路径，以便浏览器识别它只是一个虚拟片段。
* 普通 URL 路径（非哈希 URL 路径）- 服务器需要拦截请求并返回 index.html。

在本文中，您将学习这两种方法的优缺点，并将帮助您为自己的应用程序选择更好的方法。

## 普通 URL 路径

从它们的外观中，您可以确定以下是普通 URL。

```
https://mysite.com/dashboard
https://mysite.com/shopping-cart
```

#### 优点

* 普通的 URL 看起足够简洁干净。
* 就 SEO 而言，这些类型的 URL 具有更好的优势。
* 默认情况下，使用 Angular 之类框架的 Web 应用脚手架也支持此功能。
* 现代开发框架的 server 服务（例如 Angular 中的 `ng serve`）支持此功能。

总而言之，从普通 URL 支持的功能来看，使用普通 URL 是更好的选择。但是，这些优点是有代价的。

#### 挑战

当我们考虑在单页应用程序使用普通 URL 时，您需要配置 Web 服务器以支持它运行。

* 需要配置 Web 服务器以便为 SPA 路由路径提供 index.html。
* 将 Web 服务器中的每个 SPA 路由路径列入白名单是不切实际的，因此需要为 API 提供单独的路由模式，以将其与 SPA 路由区分开（例如，/api/* 路由地址分配给 API 接口使用）。
* 在 SPA 中定义 URL 路径链接时需要特别小心，因为它可能导致重新加载整个页面。
* 在某些情况下，例如分别托管前端和后端服务，您将需要网关来执行服务器端基于路径的路由。

## 哈希 URL 路径

哈希 URL 将采用以下格式，由哈希（#）分隔的部分称为片段或锚点。

```
https://mysite.com/#/dashboard
https://mysite.com/#/cart
```

如果您是几年前开始使用 SPA 的，那时候的 URL 哈希路径就很普遍了。但是，在过去几年中，情况发生了变化。SPA 已成为 Web 开发的标准，并且工具和技术进步对此提供了支持。这就是为什么现在很难看有到除哈希 URL 和普通 URL 之外出名的 URL 方案。但是，哈希 URL 有几个优点是值得了解的。

#### 优点

* 浏览器不会将哈希之后的路径片段视为单独的页面。浏览器的这种行为非常适合单页应用程序，因为刷新页面会重新加载 index.html。
* 在前端用哈希定义链接是安全的，因为它不会重新加载页面。
* 服务器配置很简单，很容易区分 API 和前端请求（不过，我们任然需要规划前端资源路径）。

#### 缺点

哈希网址的最大缺点就是不够美观。

* 一些用户可能认为这样的网址是不常见的。
* 对于 SEO 来说不是最好的。

否则，这对于 SPA 来说是最容易实现的。

## 在 SPA 中处理 URL 路径

如今，几乎所有现代 SPA 框架都包含一个路由模块，该模块内置了对 URL 或哈希后面路径片段更改处理的支持。

当然，如果不使用现代框架内置的路由模块，也可以开发一个自定义路由解决方案来跟踪 SPA 中的 URL 更改。要实现自定义路由器，需要使用以下浏览器 API。

* [History API](https://developer.mozilla.org/en-US/docs/Web/API/History) — 可直接访问浏览器的历史记录接口。它允许您进行 URL 操作而不会产生哈希。它具有诸如 `back()`、`forward()` 之类的方法，该方法使您可以基于浏览历史记录导航到上一个状态或下一个浏览记录。
* [Location API](https://developer.mozilla.org/en-US/docs/Web/API/Location) 和 [onHashChange](https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onhashchange) 事件侦听器 — 在此方法中，浏览器 `onHashChange` 每次在 URL 中看到哈希更改时都会触发一次。您可以轻松管理哈希更改，而无需使用此方法与服务器进行通信。

## 总结

您可以对单个页面应用程序使用哈希 URL 或普通 URL。考虑到这两种方法的利弊，您应该也会认同我的看法，即这两种方法在技术上都是可行的。

即使您为应用程序使用普通的 URL，任何单页应用程序框架或库都将支持它。因此，您不必担心路由带来的复杂性。但是您可能需要研究服务器端设置以支持此设置。

我希望本文能概述使用这两种类型的 URL，并加深您的理解。如果您有任何疑问，可以在下面进行评论。

选择使用哪种类型 URL 取决于你！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
