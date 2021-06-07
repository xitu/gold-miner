> - 原文地址：[What is HTTP/3, and Why Does it Matter?](https://javascript.plainenglish.io/what-is-http-3-and-why-does-it-matter-cb7d7b4b600f)
> - 原文作者：[AsyncBanana](https://medium.com/@asyncbanana)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[Chorer](https://github.com/Chorer)、[Usualminds](https://github.com/Usualminds)

# 什么是 HTTP/3，为什么它很重要？

![Photo by [JJ Ying](https://unsplash.com/@jjying?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*oudyG8yVAEkJ7vm5)

研究互联网及其背后的技术时，你可能会遇到这个术语：HTTP。HTTP 或超文本传输协议，它是网络的主干，是传输文本数据的通用协议。你肯定用过它，因为你在网站上了解 HTTP 时，该网站使用的就是 HTTP 网络协议。

## 简介

### HTTP 历史简介

HTTP 的第一个正式发布版本是 HTTP/0.9。 蒂姆·伯纳斯·李于 1989 年创建了 HTTP，并在 1991 年将其命名为 HTTP/0.9。HTTP/0.9 功能有限，只能完成一些基本的任务。它无法返回除网页以外的任何内容，不支持 Cookie 和其他现代功能。1996 年 HTTP/1.0 版本发布，它带来了一些新功能，比如 POST 请求以及发送除网页以外的东西。 但是，它离今天的 HTTP 协议还相差甚远。HTTP/1.1 于 1997 年发布，并分别在 1999年 和 2007 年进行了修订。它带来了诸如 Cookie 和长连接在内的许多新功能。最终，在 2015 年，HTTP/2 发布了，它带来了性能的巨大提升，同时也带来了 SSE 服务端推送功能，并允许一次发送多个请求。HTTP/2 相对来说还是比较新的东西，只有[不到一半的网站](https://w3techs.com/technologies/details/ce-http2)使用了它。

### HTTP/3：HTTP 的最新版本

HTTP/3 也被称为基于 QUIC 的 HTTP, 它极大的改变了 HTTP。传统的 HTTP 是通过 TCP（传输层控制协议）完成的。然而 TCP 是在 1974 年开发的，也就是互联网的早期。在最初发明 TCP 时，它的作者并没意识到网络的发展会如此之快。由于 TCP 的过时，它在速度和安全性方面一度限制了 HTTP。但由于有了 HTTP/3，HTTP 不再受限制。HTTP/3 使用了谷歌在 2012 年开发的一种名为 QUIC（发音为 “quick”）的新协议，而不是 TCP。这为 HTTP 引入了许多新特性。

## 特性

### 更快的多路复用请求

![Photo by [PAUL SMITH](https://unsplash.com/@sumo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*Oz9x1jnI9c2V5qmd)

在 HTTP/2 之前，浏览器一次只能向服务器发送一个请求。这使得网站的加载速度明显变慢，因为浏览器一次只加载一个资源，比如 CSS 或 JavaScript。HTTP/2 引入了一次加载多个资源的能力，但 TCP 不是为此而设计的。如果其中一个请求失败，TCP 会让浏览器重新发起所有的请求（原文描述有些问题：HTTP/2 协议使用虽然是基于 TCP 协议，但是使用了帧和流的技术，一个请求失败，TCP连接还在，不用重新发起所有请求，因此正确的说法是：如果其中一个请求帧失败，TCP 会让浏览器重新发起该请求）。由于 TCP 在 HTTP/3 中被移除，改用 QUIC，所以 HTTP/3 不会有这个问题。对于 HTTP/3，浏览器只需要重新发起失败的请求。因此，HTTP/3 更快、更可靠。

### 更快的加密

![Photo by [Franck](https://unsplash.com/@franckinjapan?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*YCjpKNI1WGsHrXla)

HTTP/3 优化了加密浏览器的 HTTP 请求的握手过程。QUIC 将初始连接与 TLS 握手结合在一起，使其在默认情况下安全且更快。

## 实现

### 标准化

在撰写本文时，HTTP/3 和 QUIC 还没有标准化。目前有一个 IETF [工作组](https://quicwg.org/)正在起草标准化 QUIC 的草案。用于 HTTP/3 的 QUIC 版本做了轻微的修改，使用 TLS 而不是谷歌的加密算法，但它有同样的优势。

### 浏览器支持

目前，由于谷歌创建了 QUIC 协议和基于 QUIC 的 HTTP 提案，所以 Chrome 默认支持 HTTP/3。Firefox 88 以上的版本也支持该协议，不需要用户手动开启设置。Safari 14 支持 HTTP/3，但需要用户在浏览器中手动开启设置。

![Browser support for HTTP/3 (Source: [Can I Use](https://caniuse.com/http3))](https://cdn-images-1.medium.com/max/2740/1*DwY-vtr6Qzj2TdbW4KaTAw.png)

### Serverless/CDN 支持

到目前为止，只有一些服务器支持 HTTP/3，但它们的占比正在变大。Cloudflare 是谷歌之外第一批支持 HTTP/3 的公司之一，因此他们的 Serverless 和 CDN 都是兼容 HTTP/3 的。此外，谷歌云和 Fastly 也是兼容 HTTP/3 的公司，而微软 Azure CDN 和 AWS CloudFront 目前似乎不支持 HTTP/3。如果你想尝试 HTTP/3，[QUIC.Cloud](https://quic.cloud/) 是一种有趣的（虽然是实验性的）方法，可以让你在服务器前搭建一个缓存 HTTP/3 CDN。Cloudflare、Fastly 和谷歌云也有很好的 HTTP/3 支持，而且更适合生产环境。

## 总结

HTTP/3 仍然是 HTTP 的一个实验性更新，它很可能会改变。然而，超过一半的用户支持当前形式的 HTTP/3。如果你准备更新你的实现，那么这种更新带来的性能提升可能会大受欢迎。希望你享受阅读这篇文章的同时，并从中学到一些东西。

## 引用

- [Usage Statistics of HTTP/2 for Websites, May 2021 (w3techs.com)](https://w3techs.com/technologies/details/ce-http2)
- [QUIC Working Group (quicwg.org)](https://quicwg.org/)
- [Can I use… Support tables for HTML5, CSS3, etc](https://caniuse.com/http3)
- [Homepage — QUIC.cloud](https://quic.cloud/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
