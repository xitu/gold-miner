> * 原文地址：[The headers we don't want](https://www.fastly.com/blog/headers-we-dont-want)
> * 原文作者：[Andrew Betts](https://www.fastly.com/blog/andrew-betts)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/headers-we-dont-want.md](https://github.com/xitu/gold-miner/blob/master/TODO1/headers-we-dont-want.md)
> * 译者：[SergeyChang](https://github.com/SergeyChang)
> * 校对者：[Hank](https://github.com/lihanxiang)

# 那些我们不需要的 HTTP 头信息

如果你想了解更多 http 头信息的知识，请关注 5 月 22 号[安德鲁在伦敦的演讲](https://www.fastly.com/altitude/2018/london)。

http 头信息是控制缓存和浏览器处理web内容的一种重要方式。但很多时候它都被错误或冗余地使用，这不仅没有达成我们的使用目的，还增加了加载页面时的运行开销。这篇 http 头信息的系列博文中的第一篇文章，让我们先来扒一扒那些不必要的 http 头信息。

大多数开发者都了解一些 HTTP 头信息，并利用它去处理内容。如大家熟知的 `Content-Type` 和 `Content-Length` ，它们都是通用的。但最近，`Content-Security-Policy` 和 `Strict-Transport-Security` 这样的头信息已经开始用于提高安全性，`Link rel=preload` 用于提高性能。只是极少数网站使用他们，尽管它们被浏览器广泛支持。

与此同时，还有很多以前就有并且灰常受欢迎的头信息是不实用的。我们可以使用 [HTTP 存档](http://httparchive.org/) 来证实这一点。[HTTP 存档](http://httparchive.org/) 是由 Fastly 赞助并由 Google 运营的项目，每个月使用 [WebPageTest](https://www.webpagetest.org/) 加载 500,000 个网站并进行性能测试，结果公布在 [BigQuery](https://cloud.google.com/bigquery/)。

在 HTTP 存档数据中，这里列出了 30 个最受欢迎的响应头信息（基于存档中大多数网站都处理的头信息进行统计的结果），并大致说说它们多有用：

| Header name | Requests | Domains | Status |
| --- | --- | --- | --- |
| date | 48779277 | 535621 | Required by protocol |
| content-type | 47185627 | 533636 | Usually required by browser |
| **server** | **43057807** | **519663** | **Unnecessary** |
| content-length | 42388435 | 519118 | Useful |
| last-modified | 34424562 | 480294 | Useful |
| cache-control | 36490878 | 412943 | Useful |
| etag | 23620444 | 412370 | Useful |
| content-encoding | 16194121 | 409159 | Required for compressed content |
| **expires** | **29869228** | **360311** | **Unnecessary** |
| **x-powered-by** | **4883204** | **211409** | **Unnecessary** |
| **pragma** | **7641647** | **188784** | **Unnecessary** |
| **x-frame-options** | **3670032** | **105846** | **Unnecessary** |
| access-control-allow-origin | 11335681 | 103596 | Useful |
| x-content-type-options | 11071560 | 94590 | Useful |
| link | 1212329 | 87475 | Useful |
| age | 7401415 | 59242 | Useful |
| **x-cache** | **5275343** | **56889** | **Unnecessary** |
| x-xss-protection | 9773906 | 51810 | Useful |
| strict-transport-security | 4259121 | 51283 | Useful |
| **via** | **4020117** | **47102** | **Unnecessary** |
| **p3p** | **8282840** | **44308** | **Unnecessary** |
| expect-ct | 2685280 | 40465 | Useful |
| content-language | 334081 | 37927 | Debatable |
| **x-aspnet-version** | **676128** | **33473** | **Unnecessary** |
| access-control-allow-credentials | 2804382 | 30346 | Useful |
| x-robots-tag | 179177 | 24911 | Not relevant to browsers |
| x-ua-compatible | 489056 | 24811 | Useful |
| access-control-allow-methods | 1626129 | 20791 | Useful |
| access-control-allow-headers | 1205735 | 19120 | Useful |

我们这里只关注那些不需要的头信息，以及说明为什么不需要它们、该如何处理。

## 没用的信息（server, x-powered-by, via）

你可能为你服务器软件的选择而骄傲，但是大多数人（用户）对此并不关心。并且这些头部信息可能会导致你的敏感信息泄漏进而使得你的网站受到攻击。

```
Server: apache
X-Powered-By: PHP/5.1.1
Via: 1.1 varnish, 1.1 squid
```

[RFC7231](https://httpwg.org/specs/rfc7231.html#header.server) 标准允许服务器在响应中包含 `Server` 头信息，识别用于服务内容的服务器软件。最常见的是 “apache” 和 “nginx”。虽然它是允许的，也不是强制的，但是对开发者和最终用户都没有太多实在意义。然而，它是当今 web 上第三个最流行的 HTTP 响应头。

`X-Powered-By` 是没有在任何标准中定义却很受欢迎的头信息，相似地，通常用于指出 web 服务器后的应用软件平台。常见的值有 “ASP.net”， “PHP” 和 “Express”，实际上它们并不提供任何好处，还占用空间。

更具争议的应该是 `Via`，当添加到通过其传递的代理来识别代理的任何代理的响应时，[RFC7230](https://httpwg.org/specs/rfc7230.html#header.via) 规定它是必须的。代理主机名的时候他可能是有用的，但更多时候它像是一个通用标识符，如  “vegur”，“varnish”，或 “squid”。删除或者不设置这个头信息在技术上是违反规范的，但是没有浏览器对它做任何事情，所以如果你想删除它是没问题的。

## 弃用的标准（P3P, Expires, X-Frame-Options）

另一类 http 头信息是那些在浏览器中有效果的，但不是(或者不再是)达成效果的最佳方式。

```
P3P: cp="this is not a p3p policy"
Expires: Thu, 01 Dec 1994 16:00:00 GMT
X-Frame-Options: SAMEORIGIN
```

`P3P` 是个让人好奇的东东。我对它不了解，甚至很好奇，它最常见的值居然是 “this is not a p3p policy”。那它是，还是不是啊？

这要追溯到[试图使机器可读的隐私政策标准化](https://en.wikipedia.org/wiki/P3P#User_agent_support)，当时大家对于如何在浏览器中显示数据存在分歧，并且只有一个浏览器实现了这个 http 头信息 -- IE 浏览器。即使在 IE 浏览器中，`P3P` 也不会给用户带去任何视觉效果，它只需要在 iframe 中允许访问第三方cookie。有些网站甚至设置了一个不符合标准的 P3P 规则，比如上面的一个，即使这样做是[不合法律规定的](https://www.cylab.cmu.edu/_files/pdfs/tech_reports/CMUCyLab10014.pdf)。

不用说，读取第三方 cookie 通常是不可取的，所以如果你打算不这样做，你也不需要设置一个 `P3P` 头信息

`Expires` 受欢迎程度达到了不可思议的状况，试想下这种情况，`Cache-Control` 被设置为 20 年后过期。如果 `Cache-Control` 头信息包含 `max-age` 指令，那么在相同响应上的任何 `Expires` 头信息将被忽略。但是有大量网站同时设置了这两个信息，并且 `Expires` 头信息通常被设置为格林尼治时间 -- `Thu, 01 Dec 1994 16:00:00` 。很多人这样做因为他们不希望网站内容被缓存和复制，所以就[从规范中](https://www.ietf.org/rfc/rfc2616.txt)复制这个实例日期来填充。

![Screen Shot 2018-05-10 at 21.49.25](//www.fastly.com/cimages/6pk8mg3yh2ee/63zsHXNxp6YmWacesKYgwy/e3f1040e2d948b0655667aaa86d5310f/Screen_Shot_2018-05-10_at_21.49.25.png)

实际上我们没必要这么做。如果你设置了一个 `Expires` 头信息并为其设置了一个过往的时间，那么你可以这么设置，用来取代你之前的做法：

```
Cache-Control: no-cache, private
```

一些审核你网站的工具会让你添加一个值为 “SAMEORIGIN” 的 `X-Frame-Options` 头信息。这告诉浏览器你拒绝被其他网站诬陷，这也是预防[点击攻击](https://en.wikipedia.org/wiki/Clickjacking)的一种常用手段。
然而，以下更一致的支持和更可靠的行为定义的方式，可以实现同样的效果：

```
Content-Security-Policy: frame-ancestors 'self'
```

作为头信息（csp）的一部分，你还获得其他好处（稍后会详细介绍）。 所以你现在可能没有 `X-Frame-Options` 头信息。

## 调试数据（X-ASPNet-Version, X-Cache）

令人惊讶的是，一些最常用的头信息都没有任何标准。实际上，这意味着，成千上万的网站似乎自发地同意以特定的方式使用特定的 http 头信息。

```
X-Cache: HIT
X-Request-ID: 45a336c7-1bd5-4a06-9647-c5aab6d5facf
X-ASPNet-Version: 3.2.32
X-AMZN-RequestID: 0d6e39e2-4ecb-11e8-9c2d-fa7ae01bbebc
```

实际上，这些“未知”头信息并不是由网站开发人员独立完成的。 它们通常是受使用特定服务器框架、软件或特定供应商服务的人为因素的影响而形成的（在此示例中，最后一个头信息是常见的 AWS 头信息）。

特别地，`X-Cache` 实际是 Fastly 添加的（其他 CDN 也是这样做的），其他一些与 Fastly 相关的头信息，如`X-Cache-Hits` 和 `X-Served-By`。当启用调试时，我们添加更多头信息，如 `Fastly-Debug-Path` 和 `Fastly-Debug-TTL`。

这些头信息无法被任何浏览器识别，删除它们对网页渲染没有任何影响。 但是，由于这些标题可能向开发人员提供有用的信息，因此你或许要保留一些方法来告知开发者。

## 不能被正确识别（Pragma）

我没料到会在 2018 年写一篇关于“Pragma”头的文章，但根据我们的 HTTP 存档数据，它居然还排在了第 11 位。早在 1997 年，Pragma 就已经弃用了，它也从来没有打算成为响应头 —— 正如所指定的，它只有作为请求的一部分时才有意义。

```
Pragma: no-cache
```

尽管如此，它作为一个响应头是如此被广泛使用，以至于一些浏览器也能识别它。现在，你的回应将传递一个能识别 `Pragma` 的缓存，而不能识别 `Cache-Control` 的概率很小。如果你想确保某些东西没有被缓存，你只需要 `Cache-Control: no-cache, private`。  

## 非浏览器的（X-Robots-Tag）

排名前 30 的头信息中有一个是非浏览器的头信息。`X-Robots-Tag` 用于对付网络爬虫，比如 Google 和 Bing 的机器人。因为它对浏览器没有任何意义，所有你可以在需要应对爬虫的时候才设置这个头信息。与此同时带来的影响，可能是使得测试变得困难，或者是违反了搜索引擎的服务条款。

## Bugs

最后，值得一提的是简单的错误。在一个**请求**中，`Host` 头信息存在是有道理的，但是如果它出现在响应中就说明很可能你的服务被错误地配置（我很想知道这是怎么产生的）。尽管如此，上文提到的 HTTP 存档还是有 68 个网域返回了 `Host` 的头信息。

## 删除头信息

如果你的网站使用了 Fastly 的服务，那么恭喜你，使用 [VCL](https://docs.fastly.com/guides/vcl/) 是删去头信息是很便捷的。你可能希望将真正有用的调试数据保留到你的开发团队中，但将其隐藏在公共用户中，这很有意义，你可以通过检测 cookie 或传进来 HTTP 头信息来轻松实现:

```
unset resp.http.Server;
unset resp.http.X-Powered-By;
unset resp.http.X-Generator;

if (!req.http.Cookie:debug && !req.http.Debug) {
  unset resp.http.X-Amzn-RequestID;
  unset resp.http.X-Cache;
}
```

在本系列的下一篇文章中，我将讨论设置 HTTP 头信息的最佳做法，以及如何启用它们。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
