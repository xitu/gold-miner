> * 原文地址：[Brief History of HTTP](https://hpbn.co/brief-history-of-http/)
> * 原文作者：[Ilya Grigorik](https://www.igvita.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/brief-history-of-http.md](https://github.com/xitu/gold-miner/blob/master/TODO1/brief-history-of-http.md)
> * 译者：
> * 校对者：

# HTTP简史

## 简介

超文本传输​​协议（ HTTP ）是 Internet 上最普遍和广泛采用的应用程序协议之一：它是客户端和服务器之间的通用语言，支持现代 Web 。从简单的单一关键字和文档路径开始，它已不再是浏览器的专属，而且适用于几乎所有连接互联网的软件和硬件应用程序的协议。

在本章中，我们将简要介绍 HTTP 协议的演变。对不同 HTTP 语义的完整讨论超出了本书的范围，但是理解 HTTP 的关键设计变更以及每个变更背后的动机将为我们讨论 HTTP 性能提供必要的背景，特别是本文中提及的 HTTP/2 即将进行的许多改进。

## HTTP 0.9: 单线协议

Tim Berners-Lee 最初的 HTTP 提案在设计时考虑到了 _简单性_ ，以帮助他支撑他的另一个新生想法：万维网。该策略似乎有效：有抱负的协议设计者，请注意

1991年，Berners-Lee 概述了新协议产生的动机并列出了几个高级设计目标：文件传输功能、请求索引搜索超文本存档的能力、格式协商以及将客户端引用到另一个服务器的能力。为了证明该理论的实际应用，我们构建了一个简单的原型，它实现了所提议功能的一小部分：

*   客户端请求是单个 ASCII 字符串。
*   客户请求由回车（CRLF）终止。
*   服务器响应是 ASCII 字符流。
*   服务器响应是一种超文本标记语言（HTML）。
*   文档传输完成后终止连接。

然而，这听起来却比实际复杂得多。这些规则启用的是一个一些 Web 服务器当前已经支持的、非常简单的并且 Telnet 友好的协议：

```
$> telnet google.com 80

Connected to 74.125.xxx.xxx

GET /about/

(hypertext response)
(connection closed)
```

请求由单行：`GET` 方法和所请求文档的路径组成。响应是单个超文本文档 - 没有头部或任何其他元数据，只有 HTML 。它真的不能变得更简单。此外，由于先前的交互是预期协议的子集，因此它并不是必须有 HTTP/0.9 标签。其余的，正如他们所说，是历史。

从1991年这些不起眼的开始，HTTP 开始了自己的生命，并在未来几年迅速发展。让我们快速回顾一下 HTTP/0.9 的功能：

*   客户端 - 服务器，请求 - 响应协议。
*   ASCII 协议，运行在 TCP / IP 链接之上。
*   旨在传输超文本文档（HTML）。
*   每次请求后，服务器和客户端之间的连接都将关闭。

> 小提示：现阶段流行的 Web 服务器，如 Apache 和 Nginx ，仍然有一部分支持 HTTP/0.9 协议，因为本来就没有多少人在用它！如果您感到好奇，请打开 Telnet 会话并尝试通过 HTTP/0.9 访问 google.com 或您自己喜欢的网站，并检查此早期协议的行为和限制。

## HTTP/1.0: 协议的快速发展和信息 RFC

1991年至1995年期间是 HTML 规范的快速发展的阶段，一种被称为“网络浏览器”的新型软件，以及面向消费者的公共互联网基础设施的出现和快速增长。

> #### 完美风暴：20世纪90年代初的互联网热潮
>
> 在 Tim Berner-Lee 最初的浏览器原型的基础上，国家超级计算应用中心（NCSA）的一个团队决定实现他们自己的版本。有了这个，第一个流行的浏览器诞生了：NCSA Mosaic 。1994年10月，NCSA 团队的一名程序员 Marc Andreessen 与 Jim Clark 合作创建了 Mosaic 社区。该公司后来改名为 Netscape （网景），并于1994年12月发布了 Netscape Navigator 1.0 。到目前为止，一切已经很明朗了，万维网不仅仅是一个学术热点而必将引起 _更多的_ 关注。
>
> 实际上，同年第一次万维网会议在瑞士日内瓦举办，这也是万维网联盟（W3C）创建的直接原因，这个联盟用以帮助指导 HTML 的发展。同样，在 IETF 内部同期建立了HTTP 工作组（HTTP-WG），专注于改进 HTTP 协议。这两个群体将继续协助网络的发展。
>
>最后，为了创造完美的风暴，CompuServe ，AOL 和 Prodigy 在1994-1995相同的时段内开始向公众提供拨号上网服务。凭借这股迅速采用的浪潮，Netscape 在1995年8月9日以非常成功的 IPO 创造了历史 - 互联网热潮已经到来，每个人都想要分得一瓢羹！

新兴网络的所需功能及其在公共网站上不断增加的用户需求很快暴露了 HTTP/0.9 的许多根本限制：我们需要的协议不仅可以提供超文本文档，还可以提供有关请求的更丰富的元数据：响应、启用内容协商等。反过来，新兴的 Web 开发人员社区通过临时流程生成大量实验性 HTTP 服务器和客户端实现来做出回应：实现，部署，并观望是否有人开始采用它。

从这段快速的实验期开始，一系列最佳的实践和常见的模式开始出现，1996年5月，HTTP 工作组（HTTP-WG）发布了 RFC 1945，它记录了许多 HTTP/1.0 实现的没被提上规范的“常见用法”。请注意，这只是一个信息 RFC：HTTP/1.0 ，因为我们知道它不是正式规范或Internet 标准！

话虽如此，但 HTTP/1.0 请求实例看起来却非常熟悉：

```
$> telnet website.org 80

Connected to xxx.xxx.xxx.xxx

GET /rfc/rfc1945.txt HTTP/1.0 1⃣️
User-Agent: CERN-LineMode/2.15 libwww/2.17b3
Accept: */*

HTTP/1.0 200 OK 2⃣️
Content-Type: text/plain
Content-Length: 137582
Expires: Thu, 01 Dec 1997 16:00:00 GMT
Last-Modified: Wed, 1 May 1996 12:45:26 GMT
Server: Apache 0.84

(plain-text response)
(connection closed)
```

1⃣️ 具有HTTP版本号的请求行，后接请求头

2⃣️具有响应状态码，后接响应头

前面的变化不只是 HTTP/1.0 功能的详尽列表，但它确实说明了一些关键的协议更改：

*   请求可能包含多个换行符分隔的标题字段。
*   响应对象以响应状态行为前缀。
*   响应对象有自己的一组换行符分隔的标题字段。
*   响应对象不限于超文本。
*   每次请求后，服务器和客户端之间的连接都将关闭。

请求和响应头都应保证是 ASCII 编码，但响应对象本身可以是任何类型：HTML 文件、纯文本文件、图像或任何其他内容类型。因此，HTTP 的“超文本传输​​”部分在新特性引入后不久就变成了用词不当。实际上，HTTP已经迅速发展成为 _超媒体_ 传输，但原始名称仍然存在。

除了媒体类型协商之外，RFC 还记录了许多其他常用功能：内容编码，字符集支持，多部分类型，授权，缓存，代理行为，日期格式等。

> 小提示：如今，Web 上的几乎所有服务器都可以并且仍将使用 HTTP/1.0。除此之外，到现在为止，你应该知道它比之前更好！但每个请求需要新的TCP连接会对HTTP/1.0造成严重的性能损失。参考：[三次握手](/building-blocks-of-tcp/#three-way-handshake)，以及[Slow-Start](/building-blocks-of-tcp/#slow-start)。


## HTTP/1.1：Internet 标准

将 HTTP 转变为官方 IETF 互联网标准的工作与围绕 HTTP/1.0 的文档工作并行进行，并发生在大约四年的时间内：1995年至1999年。事实上，第一个正式的 HTTP/1.1 标准定义于 RFC 2068，在 HTTP/1.0发布大约六个月后于1997年1月正式发布。两年半之后，即1999年6月，标准中包含了许多改进和更新，并作为 RFC 2616 发布。

HTTP/1.1 标准解决了早期版本中发现的许多协议歧义，并引入了许多关键性能优化：keep-alive 连接，分块编码传输，字节范围请求，附加缓存机制，传输编码和管道式请求。

有了这些能力，我们现在可以检查由任何现代 HTT P浏览器和客户端执行的典型 HTTP/1.1会话：

```
$> telnet website.org 80
Connected to xxx.xxx.xxx.xxx

GET /index.html HTTP/1.1 1⃣️

Host: website.org
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4)... (snip)
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3
Cookie: __qca=P0-800083390... (snip)

HTTP/1.1 200 OK 2⃣️

Server: nginx/1.0.11
Connection: keep-alive
Content-Type: text/html; charset=utf-8
Via: HTTP/1.1 GWA
Date: Wed, 25 Jul 2012 20:23:35 GMT
Expires: Wed, 25 Jul 2012 20:23:35 GMT
Cache-Control: max-age=0, no-cache
Transfer-Encoding: chunked

100 3⃣️

<!doctype html>
(snip)

100
(snip)

0 4⃣️

GET /favicon.ico HTTP/1.1 5⃣️

Host: www.website.org
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4)... (snip)
Accept: */*
Referer: http://website.org/
Connection: close 6⃣️

Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3
Cookie: __qca=P0-800083390... (snip)

HTTP/1.1 200 OK 7⃣️

Server: nginx/1.0.11
Content-Type: image/x-icon
Content-Length: 3638
Connection: close
Last-Modified: Thu, 19 Jul 2012 17:51:44 GMT
Cache-Control: max-age=315360000
Accept-Ranges: bytes
Via: HTTP/1.1 GWA
Date: Sat, 21 Jul 2012 21:35:22 GMT
Expires: Thu, 31 Dec 2037 23:55:55 GMT
Etag: W/PSA-GAu26oXbDi

(icon data)
(connection closed)
```

1⃣️ 请求 HTML 文件，包含编码，字符集和 cookie 元数据

2⃣️ 原始 HTML 请求的分块响应

3⃣️ 块中的八位字节数表示为 ASCII 十六进制数（256字节）

4⃣️ 分块流响应结束

5⃣️ 请求在同一 TCP 连接上创建的图标文件

6⃣️ 通知服务器不会重用连接

7⃣️ 图标响应，然后关闭连接

哎呀，那里有太多事情发生！第一个也是最明显的区别是我们有两个对象请求，一个用于HTML页面，另一个用于图像，两者都通过单个连接传递。这是连接 keep-alive 的实际应用，它允许我们重用现有的 TCP 连接，以便对同一主机发出多个请求，并提供更快的最终用户体验。参阅[ TCP 的优化](/building-blocks-of-tcp/#optimizing-for-tcp)。

要终止持久连接，请注意第二个客户端请求 `close` 通过 `Connection` 请求头向服务器发送显式指令 。类似地，一旦传输响应，服务器就可以通知客户端关闭当前TCP连接的意图。从技术上讲，任何一方都可以在没有此类信号的情况下终止TCP连接，但客户端和服务器应尽可能提供它以在双方上实现更好的连接重用策略。

> 小提示：HTTP/1.1 下将 HTTP 协议的语法更改为默认情况使用连接 keep-alive 。这意味着，除非另有说明（通过 `Connection: close` 头部），否则服务器应默认保持连接处于打开状态。
>
> 但是，同样的功能也被反向移植到 HTTP/1.0 并通过 `Connection: Keep-Alive` 头部启用。因此，如果您使用 HTTP/1.1，从技术上讲，您不需要 `Connection: Keep-Alive` 请求头，但许多客户端仍然选择提供它。

此外，HTTP/1.1 协议添加了内容，编码，字符集，甚至语言协商，传输编码，缓存指令，客户端 cookie，以及可以在每个请求上协商的十几种其他功能。

我们不打算详述每个 HTTP/1.1 功能的语义。这会是一本专业的书的主题，已经写了很多很棒的书。相反，前面的示例可以很好地说明HTTP 的快速进展和演变，以及每个客户端 - 服务器交换的错综复杂的舞蹈。那里有很多事情发生！

> 小提示：有关HTTP协议所有内部工作原理的详细参考，请查看 David Gourley 和 Brian Totty 撰写的 O'Reilly 出版的 _HTTP：The Definitive Guide_ 。

## HTTP/2: 提高运输性能

自发布以来，RFC 2616 已经成为互联网空前增长的基础：数十亿台各种形状和大小的设备，从台式电脑到我们口袋里的小型网络设备，我们的生活中都离不开每天都会用HTTP来传送新闻、视频以及数以百万计的其他网络应用程序。

最初用于检索超文本的简单单行协议最终演变为通用的超媒体传输，现在或者十年后甚至可用于为您能想象的任何需求提供支持。无处不在的服务器以及协议在客户端中的广泛可用性，意味着现在许多应用程序都是专门在 HTTP 之上设计和部署的。

需要一个协议来控制你的咖啡壶？RFC 2324 已经涵盖了超文本咖啡壶控制协议（HTCPCP/1.0） - 原本是 IETF 的愚人节玩笑，并且在我们新的超连接世界中越来越多的“玩笑”。

> 超文本传输​​协议（HTTP）是用于分布式协作超媒体信息系统的应用程序级协议。它是一种通用的无状态协议，可以通过扩展其请求方法，错误代码和头部，用于拓展其用于超文本之外的许多任务，例如名称服务器和分布式对象管理系统。HTTP 的一个特性是数据表示的输入和协商，允许系统独立于正在传输的数据而构建。
> 
> RFC 2616：HTTP/1.1, 1999年6月

HTTP 协议的简捷性使其最初被广泛采用和快速发展成为可能。事实上，现在发现使用 HTTP 作为主要控制和数据协议的嵌入式设备（传感器，执行器和咖啡壶）并不罕见。但在其自身成功的重压下，随着我们越来越多地继续将我们的日常互动转移到网络 —— 社交、电子邮件、新闻、视频以及越来越多的个人和工作空间 —— 它也开始显示出有心无力的迹象。用户和 Web 开发人员现在都要求 HTTP/1.1 提供近乎实时的响应和协议性能，如果不做出修改，它就无法满足需求。

为了应对这些新挑战，HTTP 必须继续发展，因此 HTTPbis 工作组在2012年初宣布了一项针对 HTTP/2的新计划：

> 新的实现专注于在保留 HTTP 的语义的基础上，摒弃 HTTP/1.x 消息框架和语法的遗留问题，这些问题已被确定为妨碍性能并大量使用底层传输。
> 
> 工作组将基于 HTTP 当前的语义以及有序的全双工模式中设计新的规范。与 HTTP/1.x 一样，主要目标传输是 TCP，但应该可以使用其他传输。
> 
> HTTP/2 章程，2012年1月

HTTP/2 的主要关注点是提高传输性能并实现更低的延迟和更高的吞吐量。主要的版本增幅听起来是一个很大的步骤，就性能而言，它将是一个重要的步骤，但重要的是要注意，没有任何高级协议语义受到影响：所有 HTTP 头，值和用户场景都是相同的。

任何现有的网站或应用程序都可以并且将通过 HTTP/2 传送而无需做出任何修改：您无需变更您的应用程序以利用 HTTP/2。HTTP 服务器将普遍使用 HTTP/2，但这应该成为大多数用户的透明升级。如果工作组实现其目标，唯一的区别应该是我们的应用程序以更低的延迟和更好的网络链接利用率交付！

Having said that, let’s not get ahead of ourselves. Before we get to the new HTTP/2 protocol features, it is worth taking a step back and examining our existing deployment and performance best practices for HTTP/1.1. The HTTP/2 working group is making fast progress on the new specification, but even if the final standard was already done and ready, we would still have to support older HTTP/1.1 clients for the foreseeable future—realistically, a decade or more.
话虽如此，让我们不要过于超前。在我们开始使用新的 HTTP/2 协议功能之前，值得退一步并检查我们现有的 HTTP/1.1 部署和性能最佳实践。HTTP/2 工作组正在新规范上取得快速进展，但即使最终标准已经完成并准备就绪，我们仍然必须在可预见的未来支持旧的 HTTP/1.1 客户端。实际上，有可能会是十年或更长时间。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
