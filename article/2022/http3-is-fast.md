> * 原文地址：[HTTP/3 is Fast](https://requestmetrics.com/web-performance/http3-is-fast)
> * 原文作者：[Request Metrics](https://requestmetrics.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/http3-is-fast.md](https://github.com/xitu/gold-miner/blob/master/article/2022/http3-is-fast.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[luochen1992](https://github.com/luochen1992)、[finalwhy](https://github.com/finalwhy)

# HTTP/3 为什么这么快？

![HTTP/3 很快](https://requestmetrics.com/assets/images/webperf/http3/http3-teaser-500.png) 

HTTP/3 已经来临，这对 Web 性能是件大事。让我们看看它能让网站速度提升多少吧！

等等，HTTP/2 难道不好么？它在这几年不是挺火的吗？确实是，但它仍有一些[问题](https://en.wikipedia.org/wiki/HTTP/2#Criticisms)。为了解决这些问题，[新版本](https://quicwg.org/base-drafts/draft-ietf-quic-http.html)的协议正朝向“标准跟踪（standards track，RFC 的类别之一）”做出努力。

嗯，但 HTTP/3 真能让网络变得更快？它肯定能，我们将用基准测试来证明这一点。

## 预览

在我们深入细节之前，让我们快速预览一下基准测试的结果。在下方的图表中，我们在相同的网络中使用相同的浏览器请求相同的站点，唯一不同的只是 HTTP 协议的版本。每个站点都被重复请求 20 次，响应时间通过浏览器的 Performance API 测量。（更多关于基准测试的细节在下方。）

你可以清楚地看到使用每个新版本的 HTTP 协议（相较于 HTTP/1.1）带来的性能提升

![](https://requestmetrics.com/assets/images/webperf/http3/ny-all-protocols.png)

当地理距离更远或网络不太可靠时，这些差别将变得更加明显。

在了解 HTTP/3 基准测试的细节之前，我们需要知道一些背景知识。

## HTTP 简史

HTTP（超文本传输协议 1.0）的[第一个正式版本](https://datatracker.ietf.org/doc/html/rfc1945)在 1996 年完成。然而，该版本存在一些实践问题且部分标准需要更新，所以 [HTTP/1.1](https://datatracker.ietf.org/doc/html/rfc2068) 在一年后（也就是 1997 年）发布了。正如作者所说：

> 然而，HTTP/1.0 没有充分考虑分层代理、缓存、持久连接的需求和虚拟主机的影响。此外，将自身标榜为 "HTTP/1.0" 但又没完全实践 HTTP/1.0 的应用数量急剧增加；因此，我们需要一个新版的协议以便两个相互通信应用能确认对方真实的通信能力。

18 年后，新版本的 HTTP 发布了。在 2015 年，[RFC 7540](https://datatracker.ietf.org/doc/html/rfc7540) 大张旗鼓地宣布，会将 HTTP/2 标准化为协议的下一个主要版本。

### 一个连接，一个文件

如果一个网页需要 10 个 JavaScript 文件，那么浏览器就需要检索所有的 10 个文件才能完成加载。在 HTTP/1.1 那个时代，一次与服务器的 TCP 连接只能下载一个文件。这意味着文件是依次下载的，只要有一个文件出现延迟，后面的所有下载都会被阻塞。这个现象被称为[队头阻塞](https://en.wikipedia.org/wiki/Head-of-line_blocking)；这对页面性能是不利的。

为了解决这个问题，浏览器可以打开多个 TCP 连接来并行地检索资源。然而，这是种资源密集型的方法。每个新的 TCP 连接都会消耗客户端和服务端的资源；并且当你再引入 TLS 后，整个通信过程将会发生大量的 SSL 协商。因此，我们需要一种更好的解决方案。

### HTTP/2 中的多路复用

HTTP/2 的最大亮点就是它的**多路复用（multiplexing）**机制。HTTP/2 解决了**应用层**的队头阻塞的问题，通过将为数据转化为二进制（译者注：并且在传输前将数据进行分帧，以帧为单位进行传输），使得在多文件下载时能够多路复用。即，客户端可以同时请求所有的 10 个文件，并通过一个 TCP 连接并行地下载这 10 个文件。

不幸的是，HTTP/2 的通信过程中仍存在队头阻塞的问题，而源头就出现在它的下一层 —— TCP 变成了传输链上最脆弱的一环。任何出现了丢包的数据流都需要等待该包[重新传输后才能继续](https://quicwg.org/base-drafts/draft-ietf-quic-http.html#name-prior-versions-of-http)。

> 然而，由于 HTTP/2 多路复用的并行特性对于 TCP 的丢包恢复机制是不可见的，一个丢失或顺序不对的数据包会导致所有活动的事务停顿，无论其是否受到丢包的直接影响。

事实上，在高丢包的环境下，HTTP/1.1 反而表现得更好，正是因为 HTTP/2 开了太多并行的 TCP 连接！

### QUIC 和 HTTP/3 中真正的多路复用

现在说到 HTTP/3。HTTP/2 和 HTTP/3 的主要区别在于所使用的传输协议。与之前的 TCP 协议不同，HTTP/3 使用了一个全新的协议 —— [QUIC](https://www.rfc-editor.org/rfc/rfc9000.html)。QUIC 是一个通用的传输协议，解决了 HTTP/2 因为 TCP 而产生的队头阻塞问题。这个协议能让你通过 UDP 创建[一系列带状态的流](https://quicwg.org/base-drafts/draft-ietf-quic-http.html#name-delegation-to-quic)（这与 TCP 很相似）。

![](https://requestmetrics.com/assets/images/webperf/http3/udp-joke.min.png)

> QUIC 传输协议包含流的复用和对每个流的流量控制，这两者与 HTTP/2 中实现的类似。通过在整个连接中提供流级别的可靠性和拥塞控制，比起 TCP 映射，**QUIC 更能提高 HTTP 的性能**。

如果你不关心测试是怎么进行的，那就跳到下方的结果吧！

## HTTP/3 的基准测试

要想了解 HTTP/3 在性能方面带来了什么改变，我们需要先搭建一个基准测试环境。

### HTML

为了能更贴合实际使用情况，这次的测试考虑了三种场景 —— 一个小型站点、一个内容站点（大量图片和些许 JavaScript 资源）和一个单页面应用（大量 JavaScript 资源）。我查看了几个现实生活中的站点，并计算了每个站点的图片和 JavaScript 文件的平均数量，然后编写了一些与这些资源数量（和大小）差不多的演示站点。

* 小型站点
    * **10** 个 2 kB 到 100 kB 的 JavaScript 文件；
    * **10** 张 1kB 到 50 kB 的图片；
    * 总载荷大小 **600 kB**，共计 20 个阻塞资源。
* 内容站点
    * **50** 个 2 kB 到 1 MB 的 JavaScript 文件；
    * **55** 张 1 kB 到 1 MB 的图片；
    * 总载荷大小 **10MB**，共计 105 个阻塞资源（在开发者工具中看看 cnn.com 你就会明白这个量为什么会这么大了）。
* 单页面应用
    * **85** 个 2 kB 到 1 MB 的 JavaScript 文件；
    * **30** 张 1 kB 到 50 kB 的图片；
    * 总载荷大小 **15MB**，共计 115 个阻塞资源（在开发者工具中看看 JIRA （缺陷跟踪管理系统）吧）。

### 服务端

[Caddy](https://caddyserver.com/) 作为这次测试的服务器，向外提供资源及 HTML。

* 所有响应都使用 `Cache-Control: "no-store"` 以确保浏览器每次都会重新下载资源；
* HTTP/1.1 和 HTTP/2 使用 TLS 1.2；
* HTTP/3 使用 [TLS 1.3](https://www.rfc-editor.org/rfc/rfc9001.html)；
* 所有的 HTTP/3 连接都开启 [0-RTT](https://www.rfc-editor.org/rfc/rfc9001.html#name-0-rtt)。

### 地理位置

测试是从我在明尼苏达州的计算机到三个独立数据中心（由 Digital Ocean 托管）进行的：

* 美国纽约
* 英国伦敦
* 印度班加罗尔

### 客户端

浏览器将连续请求同一个页面 20 次，每次请求间隔 3 秒，过程完全自动化。网络的额定速度为 200 Mbps。数据采集时，计算机上没有运行其他应用程序。

## HTTP/3 有多快？

### 美国纽约

以下是从纽约数据中心请求三个不同站点时 HTTP/2 与 HTTP/3 的响应时间：

![](https://requestmetrics.com/assets/images/webperf/http3/ny-http2and3.png)

HTTP/3 在：

* 小型站点快了 **200 毫秒**
* 内容站点快了 **325 毫秒**
* 单页面应用快了 **300 毫秒**

明尼苏达州距离纽约 1000 英里（约等于 160 公里）；这长度对于网络连接来说不算什么。然而重要的是，即使在相对较短的距离内，HTTP/3 也能够将性能提高这么多。

### 英国伦敦

在这次的测试中，我也包含了 HTTP/1.1 的基准测试。为了展示 HTTP/2 和 HTTP/3 快了多少，我将下方图表的轴刻度都保持一致了。你可以看到，对于内容站点，HTTP/1.1 的速度是多么的慢；慢得连图表都不能完全显示！

![](https://requestmetrics.com/assets/images/webperf/http3/london-all-protocols.png)

正如你所见，当网络的距离更远时，速度的提高更明显了。

* 小型站点快了 **600 毫秒**（速度是纽约的 **3 倍**）
* 内容站点快了 **1200 毫秒**（速度是纽约的 **3.5 倍**）
* 单页面应用快了 **1000 毫秒**（速度是纽约的 **3 倍**）

### 印度班加罗尔

HTTP/3 性能的进步在从印度加载页面时最为明显。我并不打算测试 HTTP/1.1，因为它太慢了。以下是 HTTP/2 与 HTTP/3 的结果对比：

![](https://requestmetrics.com/assets/images/webperf/http3/india-http2and3.png)

当请求涉及更大的地理区域和更多的网络跃点时，HTTP/3 仍然继续领先。更值得注意的是 HTTP/3 的响应时间数据分布是多么的集中（译者注：这说明在保证快的前提下，HTTP/3也很稳定）。当数据包传输数千英里时，QUIC 将发挥重要的作用。

在每种情况下 HTTP/3 都比历代 HTTP 更快！

### 为什么 HTTP/3 这么快？

#### 真正的多路复用

HTTP/3 真正的多路复用特性意味着堆栈上的任何地方都不会发生队头阻塞。当你从更远的地理位置请求资源时，丢包的可能性会高出很多，TCP 重新传输的需求也会提高。

#### 颠覆局面的 0-RTT

此外，HTTP/3 也支持 [0-RTT](https://www.rfc-editor.org/rfc/rfc9001.html#section-4.6-1) QUIC 连接，减少了建立安全 TLS 连接的数据往返次数。

> QUIC 中的 0-RTT 功能能让客户端在三次握手完成之前发送应用数据。这个功能通过重用先前连接的参数实现。0-RTT 依赖于客户端记住的重要参数，并向服务器提供 TLS 会话票证（session ticket）以恢复相同的信息。

然而，你不应该盲目地启用 0-RTT。基于你的威胁模型，它[可能](https://www.rfc-editor.org/rfc/rfc8446#section-2.3)[存在一些安全问题](https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt)。

> 0-RTT 数据的安全属性弱于其他类型的 TLS 数据。具体来说：
>
> 1. 数据不是前向保密（forward secret）的；数据仅仅只被预共享密钥（pre-shared key，PSK）衍生的密钥加密。
> 2. 不能保证连接之间不重放（译者注：详情见[重放攻击](https://baike.baidu.com/item/%E9%87%8D%E6%94%BE%E6%94%BB%E5%87%BB/2229240)）。

## 我现在能用 HTTP/3 了吗？

或许可以喔！虽然协议现在仍处于 **互联网草案（Internet-Draft）**状态，但市面上已有许多不同的[实践方案](https://en.wikipedia.org/wiki/HTTP/3#Server)了。

作为这次的基准测试，我特别选择了 **Caddy**。我只需要修改 `Caddyfile` 中的一个[简单的配置](https://caddyserver.com/docs/caddyfile/options#protocol)就能启用 HTTP/3。

Nginx 对 HTTP/3 也有实验性的支持，且正在[朝向将发布的 HTTP/3（它就在不久的将来）迈进](https://www.nginx.com/blog/our-roadmap-quic-http-3-support-nginx/)。

像是谷歌和 Facebook 这些科技巨擘已经通过 HTTP/3 提供服务了。在现代浏览器中，[Google.com](https://google.com) 已完全使用 HTTP/3。

对于那些“困在”微软生态系统中的用户，据说 Windows Server 2022 将会支持 HTTP/3，但你需要执行一些[“深奥”的步骤](https://techcommunity.microsoft.com/t5/networking-blog/enabling-http-3-support-on-windows-server-2022/ba-p/2676880)来启用它。

## 总结

HTTP/3 能在用户体验方面带来了很大的改善。在一般情况下，站点需要的资源越多，HTTP/3 和 QUIC 的性能提升就越大。随着标准离定稿越来越近，也许你是时候该考虑为你的网站启用 HTTP/3 了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
