> - 原文地址：[What is HTTP/3, and Why Does it Matter?](https://javascript.plainenglish.io/what-is-http-3-and-why-does-it-matter-cb7d7b4b600f)
> - 原文作者：[AsyncBanana](https://medium.com/@asyncbanana)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：

# 什么是 HTTP/3，为什么它很重要？

![Photo by [JJ Ying](https://unsplash.com/@jjying?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*oudyG8yVAEkJ7vm5)

在研究互联网及其背后的技术时，你可能会遇到这个术语：HTTP。HTTP 或超文本传输协议，是网络的主干，是传输文本数据的通用协议。你肯定用过它，因为你在网站上了解 HTTP 时，该网站使用的就是 HTTP。

## 简介

### HTTP 历史简介

HTTP 的第一个发布版本 HTTP/0.9。 Tim Berners-Lee 于 1989 年创建它，它于 1991 年被命名为 HTTP/0.9。HTTP/0.9 功能有限，只能做一些基本的东西。它无法返回除网页以外的任何内容，不支持 Cookie 和其他现代功能。1996 年 HTTP/1.0 发布，也带来了一些新功能，比如 POST 请求以及发送除网页以外的东西。 但是，它离今天的水平还有很长的路要走。HTTP/1.1 于 1997 年发布，并于 1999 年被修改了两次，2007 年修改了一次。它带来了许多主要的新功能，如 Cookie 和 长链接。最终，在 2015 年发布了 HTTP/2 并允许提高性能，让服务器可以发送事件和一次发送多个请求。HTTP/2 仍然是新的，只有[不到一半的网站](https://w3techs.com/technologies/details/ce-http2)使用它。

### HTTP/3：HTTP 的最新版本

HTTP/3 或者是 HTTP 通过 QUIC, 极大的改变了 HTTP。HTTP 传统上是通过 TCP（传输控制协议）完成的。然而 TCP 是在 1974 年开发的，也就是互联网的初期。TCP 最初创建时，它的作者无法预测网络的增长。由于 TCP 的过时，TCP 在速度和安全性方面暂时限制了 HTTP。现在因为 HTTP/3，HTTP 不再受限制。HTTP/3 使用了谷歌在 2012 年开发的一种名为 QUIC(发音为 “quick”) 的新协议，而不是 TCP。这为 HTTP 引入了许多新特性。

## 特征

### 更快的多路复用请求

![Photo by [PAUL SMITH](https://unsplash.com/@sumo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*Oz9x1jnI9c2V5qmd)

在 HTTP/2之前，浏览器一次只能向服务器发送一个请求。这使得网站加载速度明显变慢，因为浏览器一次只加载一个资源，比如 CSS 或 JavaScript。HTTP/2 引入了一次加载多个资源的能力，但 TCP 不是为此而设计的。如果其中一个请求失败，TCP 会让浏览器重新所有请求所有的请求。由于 TCP 在 HTTP/3 中被移除，被 QUIC 代替，HTTP/3 解决了这个问题。对于 HTTP/3，浏览器只需要重新请求失败的请求。因此，HTTP/3 更快更可靠。

### 更快的加密

![Photo by [Franck](https://unsplash.com/@franckinjapan?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*YCjpKNI1WGsHrXla)

HTTP/3 优化了 “握手”，允许浏览器的 HTTP 请求被加密。QUIC 将初始连接与 TLS 握手结合在一起，使其在默认情况下安全且更快。

## 实现

### 标准化

在撰写本文时，HTTP/3 和 QUIC 还没有标准化。目前有一个 IETF [工作组]((https://quicwg.org/))正在起草标准化 QUIC 的草案。用于 HTTP/3 的QUIC 版本做了轻微的修改，使用 TLS 而不是谷歌的加密，但它有同样的优点。

### 浏览器支持

目前，由于谷歌创建了QUIC 协议和基于 QUIC 的 HTTP 提议，Chrome 默认支持 HTTP/3。Firefox 在 88 以上的版本也支持不带标志的协议。Safari 14 支持 HTTP/3，但前提是启用了一个实验性的特性标志。

![Browser support for HTTP/3 (Source: [Can I Use](https://caniuse.com/http3))](https://cdn-images-1.medium.com/max/2740/1*DwY-vtr6Qzj2TdbW4KaTAw.png)

### 无服务器/CDN 支持

到目前为止，只有一些服务器支持 HTTP/3，但它们的份额正在增长。Cloudflare 是谷歌之外第一批支持 HTTP/3 的公司之一，因此他们的无服务器功能和 CDN 都是 兼容 HTTP/3 的。此外，谷歌云和 Fastly 是 兼容 HTTP/3 的。不幸的是，微软 Azure CDN 和 AWS CloudFront 目前似乎不支持 HTTP/3。如果你想尝试 HTTP/3，[QUIC.Cloud](https://quic.cloud/) 是一种有趣的（虽然是实验性的）方法来在你的服务器前建立一个缓存 HTTP/3 CDN。Cloudflare、Fastly 和谷歌云也有很好的 HTTP/3 支持，而且更适合生产环境。

## 总结

HTTP/3 仍然是 HTTP 的一个实验性更新，它很可能会改变。然而，超过一半的用户支持当前形式的 HTTP/3。如果您准备更新您的实现，那么这可能是一个受欢迎的性能提升。希望你喜欢阅读并从这篇文章中学到一些东西。

## 引用

- [Usage Statistics of HTTP/2 for Websites, May 2021 (w3techs.com)](https://w3techs.com/technologies/details/ce-http2)
- [QUIC Working Group (quicwg.org)](https://quicwg.org/)
- [Can I use… Support tables for HTML5, CSS3, etc](https://caniuse.com/http3)
- [Homepage — QUIC.cloud](https://quic.cloud/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
