> * 原文地址：[HTTP/3: From root to tip](https://blog.cloudflare.com/http-3-from-root-to-tip/)
> * 原文作者：[Lucas Pardue](https://blog.cloudflare.com/author/lucas/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/http-3-from-root-to-tip.md](https://github.com/xitu/gold-miner/blob/master/TODO1/http-3-from-root-to-tip.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[jerryOnlyZRJ](https://github.com/jerryOnlyZRJ)，[kasheemlew](https://github.com/kasheemlew)，[Fengziyin1234](https://github.com/Fengziyin1234)

# HTTP/3：起源

HTTP 是确保 Web 应用程序正常运行的应用层协议。1991 年，HTTP/0.9 正式发布，至 1999 年，已经发展为 IETF（国际互联网工程任务组）的标准化协议 HTTP/1.1。在很长的一段时间里，HTTP/1.1 表现得都非常好，但面对如今变化多端的 Web 需求，显然需要一个更为合适的协议。2015 年，HTTP/2 应运而生。最近，有人披露 IETF 预计发布一个新版本 —— HTTP/3。对有些人来说，这是惊喜，也引发了业界的激烈探讨。如果你不怎么关注 IETF，可能就会觉得 HTTP/3 的出现非常突然。但事实是，我们可以透过 HTTP 的一系列实现和 Web 协议发展来追溯它的起源，尤其是 QUIC 传输协议。

如果你不熟悉 QUIC，可以查看我同事的一些高质量博文。John 的[博客](https://blog.cloudflare.com/the-quicening/)从不同的角度讨论了现如今的 HTTP 所存在的一些问题，Alessandro 的[博客](https://blog.cloudflare.com/the-road-to-quic/) 阐述了传输层的本质，Nick 的[博客](https://blog.cloudflare.com/head-start-with-quic/) 涉及了相关测试的处理方法。我们对这些相关内容进行了收集整理，如果你想要查看更多内容，可以前往 [https://cloudflare-quic.com](https://cloudflare-quic.com)。如果你对此感兴趣，记得去查看我们自己用 Rust 编写的 QUIC 开源实现项目 —— [quiche](https://blog.cloudflare.com/enjoy-a-slice-of-quic-and-rust/)。

HTTP/3 是 QUIC 传输层的 HTTP 应用程序映射。该名称在最近（2018 年 10 月底）草案的第 17 个版本中被正式提出（[draft-ietf-quic-http-17](https://tools.ietf.org/html/draft-ietf-quic-http-17)），在 11 月举行的 IETF 103 会议中进行了讨论并形成了初步的共识。HTTP/3 以前被称为 QUIC（以前被称为 HTTP/2）。在此之前，我们已经有了 gQUIC，而在更早之前，我们还有 SPDY。事实是，HTTP/3 只是一种适用于 IETF QUIC 的新 HTTP 语法 —— 基于 UDP 的多路复用和安全传输。

在本文中，我们将讨论 HTTP/3 以前一些名称背后的历史故事，以及最近更名的诱因。我们将回到 HTTP 的早期时代，探寻它一路成长中的美好回忆。如果你已经迫不及待了，可以直接查看文末，或打开[这个详细的 SVG 版本](https://blog.cloudflare.com/content/images/2019/01/web_timeline_large1.svg)。

![](https://blog.cloudflare.com/content/images/2019/01/http3-stack.png)

HTTP/3 分层模型（蛋糕模型）

## 设置背景

在我们关注 HTTP 之前，值得回忆的是两个共享 QUIC 的名称。就像我们[之前](https://blog.cloudflare.com/the-road-to-quic/)解释得那样，gQUIC 通常是指 Google QUIC（协议起源），QUIC 通常用于表示与 gQUIC 不同的 IETF 标准（正在开发的版本）。

在 90 年代初期，Web 需求就已经发生了改变。我们已经有了新的 HTTP 版本，以传输层安全（TLS）的形式加强用户安全性。在本文中，我们会涉及 TLS。如果你想更详细地了解这个领域，可以参阅我们其他的高质量[博文](https://blog.cloudflare.com/tag/tls/)。

为了帮助我们了解 HTTP 和 TLS 的历史，我整理了协议规范以及日期的细节内容。这种信息一般以文本形式呈现，比如，按日期排序说明文档标题的符号点列表。不过，因为分支标准的存在，所以重叠的时间和简单的列表并不能正确表达复杂的关系。在 HTTP 中，并行工作导致了核心协议定义的重构，为了更简单的使用，我们为新行为扩展了协议内容，为了提高性能，我们甚至还重定义了协议如何在互联网上交换数据。当你尝试了解近 30 年的互联网历史，跨越不同的分支工作流程时，你需要将其可视化。所以我做了一个 Cloudflare 安全 Web 时间线（注意：从技术上说，它是[进化树](https://en.wikipedia.org/wiki/Cladogram)，但时间线这个术语更广为人知）。

在创建它时，经过深思熟虑后，我选择关注 IETF 中的成功分支。本文未涉及的内容，包括 W3C [HTTP-NG](https://www.w3.org/Protocols/HTTP-NG/) 工作组的努力成果，还有些热衷于解释如何发音的作者的奇特想法：[HMURR（发音为 'hammer'）](https://blog.jgc.org/2012/12/speeding-up-http-with-minimal-protocol.html) 和 [WAKA（发音为 “wah-kah”）](https://github.com/HTTPWorkshop/workshop2017/blob/master/talks/waka.pdf)。
  
为了让你们更好地把握本文的脉络，下面的一些部分，我会沿着这条时间线来解释 HTTP 历史的重点内容。了解标准化以及 IETF 是如何对待标准化的。因此，在回到时间线之前，我们首先会对这个主题进行一个简短的概述。如果你已经非常熟悉 IETF 了，可以跳过该内容。

## Internet 标准的类型

一般而言，标准定义了共同的职责范围、权限、适用性以及其他相关内容。标准有多种形状和大小，可以是非正式的（即事实上的），也可以是正式的（由 IETF、ISO 或 MPEG 等标准定义组织协商/发布的）。标准应用于众多领域，甚至还有一种为制茶而定义的正式标准的 —— BS 6008。

早期 Web 使用在 IETF 之外发布的 HTTP 和 SSL 协议定义，它们在安全的 Web 时间线上被标记为**红线**。客户端和服务的对这些协议的妥协使它们得以成为事实上的标准。

迫于当时的形式，这些协议最终被确定为标准化（一些激进的原因会在之后进行描述）。互联网标准通常在 IETF 中定义，以“多数共识和运行的代码”非正式原则作为指导。这是基于在互联网上开发和部署项目的经验。这与试图在真空中开发完美协议的 "clean room" 方法形成了鲜明对比。

IETF 互联网标准通常被称为 RFCs。这是一个解释起来很复杂的领域，因此我建议阅读 QUIC 工作组主席 Mark Nottingham 的博文 "[如何阅读 RFC](https://www.ietf.org/blog/how-read-rfc/)"。工作组或 WG，或多或少的只是一个邮件列表。

IETF 每年举行三次会议，为所有工作组提供时间和设施，如果他们愿意的话，可以亲自前来。这几周的行程挤在了一起，需要在有限的时间里深入讨论高级技术领域。为了解决这个问题，一些工作组甚至选择在 IETF 的一般性会议期间举行临时会议。这有助于保持规范开发的信心。自 2017 年以来，QUIC 工作组举行了几次临时会议，可以在其[会议网站页面](https://datatracker.ietf.org/wg/quic/meetings/)查看完整清单。

这些 IETF 会议也为 IETF 的相关群体提供了机会，比如[互联网架构委员会](https://www.iab.org/)或者[互联网研究任务组](https://irtf.org/)。最近几年，在 IETF 会议前的几周还举行了 [IETF Hackathon](https://www.ietf.org/how/runningcode/hackathons/)。这为社区提供了一个开发运行代码的机会，更重要的是，可以和其他人进行交互操作性测试。这有助于发现规范中的问题，并在接下来的会议中进行讨论。

这个博客最重要的目的是让大家理解 RFCs 并不是凭空出世的。很显然，它经历了以 IETF 因特网草案（I-D）格式开始的过程，该格式是为了考虑采用而提交的。在已发布规范的情况下，I-D 的准备可能只是一个简单的重格式化尝试。I-Ds 自发布起，有 6 个月的有效期。为了保证它的活跃，需要发布新的版本。实践中，让 I-D 消逝并不产生严重的后果，而且这一情况时有发生。对于想要了解它们的人，可以在 [IETF 文档网站](https://datatracker.ietf.org/doc/recent)阅览。

I-Ds 在安全 Web 时间线上显示为**紫色**。每条线都有格式为 **draft-{author name}-{working group}-{topic}-{version}** 的唯一名称。工作组字段是可选的，它可以预测 IETF 工作组是否在此工作，这是可变的参数，如果选用了 I-D，或者如果 I-D 是直接在 IETF 内启动的，名称为 **draft-ietf-{working group}-{topic}-{version}**。I-Ds 就可能会产生分支，合并或者死亡。从 00 版本开始，每次发布新草案就 +1。比如，I-D 的第四稿有 03 版本号。无论何时，只要 I-D 变更名称，它的版本号就会重置为 00。

需要注意的是，任何人都可以向 IETF 提交一个 I-D；你不应该将这些视为标准。但如果 IETF 的 I-D 标准化过程得到了一致的肯定，而且通过了最终的文件审查，我们就会得到一个 RFC。在此阶段，名称会再次变更。每个 RFC 都有一个唯一的数字。比如，[RFC 7230](https://tools.ietf.org/html/rfc7230)。他们在安全 Web 时间线上显示为**蓝色**。

RFC 是不可变文档。这意味着 RFC 的更改会产生一个全新的数字。为了合并修复的错误（发现和报告的编辑或技术错误）或是简单地重构规范来改进布局，可以进行更改。RFC 可能会**弃用**旧版本，或只是**更新**它们（实质性改变）。

所有的 IETF 文档都是开源在 [http://tools.ietf.org](http://tools.ietf.org) 上的。因为它提供了从 I-D 到 RFC 的文档进度可视化，所以个人认为 [IETF Datatracker](https://datatracker.ietf.org) 对用户很友好。

以下是显示 [RFC 1945](https://tools.ietf.org/html/rfc1945) —— HTTP/1.0 开发的示例，它为安全 Web 时间线提供了一个明确灵感来源。

![](https://blog.cloudflare.com/content/images/2019/01/RFC-1945-datatracker.png)

IETF RFC 1945 Datatracker 视图

有意思的是，在我的工作过程中，我发现上述可视化是不正确的。由于某种原因，它丢失了 [draft-ietf-http-v10-spec-05](https://tools.ietf.org/html/draft-ietf-http-v10-spec-05)。由于 I-D 生命周期只有 6 个月，所以在成为 RFC 之前会存在分歧，而实际上草案 05 直到 1996 年 8 月，仍处于活跃状态。

## 探索安全的 Web 时间线

稍微了解因特网标准文档是如何实现后，我们就可以着手安全网络时间线了。在本节中，有许多摘选图显示了时间轴的重要部分。每个点对应着文档或功能的可用日期。对于 IETF 文档，为了清晰可见，省略了草案编号。但如果你想查看所有细节，可以查看[完整的时间线](https://blog.cloudflare.com/content/images/2019/01/web_timeline_large1.svg)。

HTTP 在 1991 年以 HTTP/0.9 协议开始，在 1994 年 I-D [draft-fielding-http-spec-00](https://tools.ietf.org/html/draft-fielding-http-spec-00) 发布。它很快就被 IETF 采用，导致 [draft-ietf-http-v10-spec-00](https://tools.ietf.org/html/draft-ietf-http-v10-spec-00) 的名称被修改。在 [RFC 1945](https://tools.ietf.org/html/rfc1945) —— HTTP/1.0 于 1996 年发布之前，I-D 已经已经了 6 个草案版本的修改。

![](https://blog.cloudflare.com/content/images/2019/01/http11-standardisation.png)

甚至在 HTTP/1.0 还没有完成之前，HTTP/1.1 就已经开始了一个独立的分支。I-D [draft-ietf-http-v11-spec-00](https://tools.ietf.org/html/draft-ietf-http-v11-spec-00) 于 1995 年 11 月发布，1997 年正式以 [RFC 2068](https://tools.ietf.org/html/rfc2068) 形式出版。敏锐的洞察力会让你发现安全 Web 时间线并不能捕捉到事件顺序，这是用于生成可视化工具的一个不幸的副作用。我会尽可能的减少这样的问题。

HTTP/1.1 修订工作在 1997 年年中以 [draft-ietf-http-v11-spec-rev-00](https://tools.ietf.org/html/draft-ietf-http-v11-spec-rev-00) 形式开始。1999 年出版的 [RFC 2616](https://tools.ietf.org/html/rfc2616) 标志着这一计划的完成。直到 2007 年，IETF HTTP 世界才获得平静。我们很快会再提及此事。

## SSL 和 TLS 的历史

![](https://blog.cloudflare.com/content/images/2019/01/ssl-tls-standardisation.png)

现在我们开始研究 SSL。我们可以看到 SSL 2.0 规范是在 1995 年前后发布的，SSL 3.0 是在 1996 年 11 月发布的。有趣的是，在 2011 年 8 月发布的 SSL 3.0 [RFC 6101](https://tools.ietf.org/html/rfc6101) 是**里程碑**版本，通常是为了“记录被考虑和丢弃的想法，或者是在决定记录他们时已经具有历史意义的协议”。参照 [IETF](https://www.ietf.org/blog/iesg-statement-designating-rfcs-historic/?primary_topic=7&)。在这种情况下，拥有描述 SSL 3.0 的 IETF 文档是有利的，因为它可以作为其他地方的规范引用。

我们更感兴趣的是 SSL 如何促进 TLS 发展的，TLS 的生命在 1996 年 11 月开始于 [draft-ietf-tls-protocol-00](https://tools.ietf.org/html/draft-ietf-tls-protocol-00)。它通过了 6 个草案版本，发布时为 [RFC 2246](https://tools.ietf.org/html/rfc2246) —— TLS 1.0 起始于 1999。

在 1995 年和 1999 年，SSL 和 TLS 协议被用于保护因特网上的 HTTP 通信。作为一个事实上的标准，它并没有太大的问题。直到 1998 年 1 月，HTTPS 的正式标准化进程才随着 I-D [draft-ietf-tls-https-00](https://tools.ietf.org/html/draft-ietf-tls-https-00) 的出版而开始。这项工作结束于 2000 年 5 月，发布的 [RFC 2616](https://tools.ietf.org/html/rfc2616) —— HTTP over TLS。

伴随着 TLS 1.1 和 1.2 的标准化，TLS 在 2000 至 2007 年得以继续发展。距下一个 TLS 版本的开发时间还有 7 年时间，它在 2014 年 4 月的 [draft-ietf-tls-tls13-00](https://tools.ietf.org/html/draft-ietf-tls-tls13-00) 中被通过，在历经 28 份草案之后，[RFC 8446](https://tools.ietf.org/html/rfc8446) —— TLS 1.3 于 2018 年 8 月完成。

## 因特网标准化过程

在看了下时间线之后，我希望你能对 IETF 的工作方式有大概的了解。互联网标准形成方式的概况是，研究人员或工程师和他们具体用例的实验协议。他们在不同规模的公共或私有协议中进行试验。这些数据有助于发现可以优化的地方或问题。这项工作可能是为了解释试验，收集更广泛的投入，或帮组寻找其他实验者。其他对早期工作的参与者可能会使其成为事实上的标准；可能最后会有足够的原因使其成为正式标准化的一种选择。

对于正在考虑实施、部署或以某种范式使用协议的组织来说，协议的状态可能是一个重要的因素。一个正式的标准化过程可以促使事实上的标准更具吸引力，因为标准化倾向于提供稳定性。管理和指导由 IETF 这类组织提供，它反映了更广泛的经验。然而，需要强调的是，并非所有的正式标准都是成功的。

创建最终标准的过程与标准本身同等重要。从具有更广泛知识、经验和用例的人那里获取初步的想法和贡献，可以帮助产生对更广泛人群有用的产物。但标准化的过程并不容易。存在陷阱和障碍，有时，需要花费很长的时间过程，才能排除不相关的内容。

每个标准定义组织都存在自己的标准化过程，主要围绕其对应领域和参与者。解释 IETF 如何运转的所有工作细节，远远超过了这个博客的涵盖范围。IETF 的“[我们的运行原理](https://www.ietf.org/how/)”是很好的起点，涵盖了很多内容。是的，理解的最好途径就是自己参与其中。就像加入电子邮件列表或添加相关 GitHub 仓库的讨论一样容易。

## Cloudflare 的运行代码

Cloudflare 为成为新的、不断发展的协议的早期采用者而感到自豪。我们很早就采用了新标准，比如 [HTTP/2](https://blog.cloudflare.com/introducing-http2/)。我们还测试了一些实验性或尚未最终确定的特性，比如 [TLS 1.3](https://blog.cloudflare.com/introducing-tls-1-3/) 和 [SPDY](https://blog.cloudflare.com/introducing-spdy/)。

在 IETF 标准化过程中，将运行中的代码部署到多个不同网站的真实网络上，可以帮助我们理解协议在实践中的工作效果。我们将现有的专业知识与实现信息进行结合，来改进运行中的代码，并在有意义的地方，对工作组的反馈问题或改进进行修正，来促使协议标准化。

测试新特性并不是唯一的优先级。作为改革者，需要知道什么时候推进进度，抛弃旧的创新。有时，这会涉及到面向安全的协议，比如 Cloudflare 因为 POODLE 的漏洞而[默认禁用 SSLv3](https://blog.cloudflare.com/sslv3-support-disabled-by-default-due-to-vulnerability/)。在某些情况下，协议会被更先进的所取代；Cloudflare [废弃 SPDY](https://blog.cloudflare.com/deprecating-spdy/)，转而支持 HTTP/2。

相关协议的介绍和废弃在安全 Web 时间线上显示为**橙色**。垂直虚线有助于将 Cloudflare 事件与 IETF 相关文档关联。比如，Cloudflare 在 2016 年 9 月开始支持的 TLS 1.3，最后的文档 [RFC 8446](https://tools.ietf.org/html/rfc8446)，在近两年后的 2018 年 8 月发布。

![](https://blog.cloudflare.com/content/images/2019/01/cf-events.png)

## 重构 HTTPbis

HTTP/1.1 是非常成功的协议，时间线显示 1999 年以后 IETF 并不活跃。然而，事实是，多年的积极使用，为 [RFC 2616](https://tools.ietf.org/html/rfc2616) 研究潜在问题提供了实战经验，但这也导致了一些交互操作的问题。此外，RFC（像 2817 和 2818）还对该协议进行了扩展。2007 年决定启动一项改进 HTTP 协议规范的新活动 —— HTTPbis（"bis" 源自拉丁语，意为“二”、“两次”或“重复”），它还采用了新的工作组形式。最初的[章程](https://tools.ietf.org/wg/httpbis/charters?item=charter-httpbis-2007-10-23.txt)详细描述了尝试解决的问题。

简而言之，HTTPbis 决定重构 [RFC 2616](https://tools.ietf.org/html/rfc2616)。它将纳入勘误修订，合并在此期间发布的其他规范的一些内容。文件将被分为几个部分，这导致 2017 年 12 月发布了 6 个 I-D：

*   draft-ietf-httpbis-p1-messaging
*   draft-ietf-httpbis-p2-semantics
*   draft-ietf-httpbis-p4-conditional
*   draft-ietf-httpbis-p5-range
*   draft-ietf-httpbis-p6-cache
*   draft-ietf-httpbis-p7-auth

![](https://blog.cloudflare.com/content/images/2019/01/http11-refactor.png)

图表显示了这项工作是如何在长达 7 年的草案过程中取得进展的，在最终被标准化之前，已经发布了 27 份草案。2014 年 6 月，发布了 RFC 723x 系列（x 范围在 0-5）。HTTPbis 工作组的主席以 "[RFC2616 is Dead](https://www.mnot.net/blog/2014/06/07/rfc2616_is_dead)" 来庆祝这一成果。如果它不够清楚，这些新文档就会弃用旧的 [RFC 2616](https://tools.ietf.org/html/rfc2616)。

## 这和 HTTP/3 有什么联系？

尽管 IETF 的 RFC 723x 系列的工作繁忙，但是技术的进步并未停止。人们继续加强、扩展和测试因特网上的 HTTP。而 Google 已率先开始尝试名为 SPDY（发音同 Speedy）的技术。该协议宣称可以提高 Web 浏览性能，一个使用 HTTP 原则的用例。2009 年底，SPDY v1 发布，2010 年 SPDY v2 紧随其后。

我想避免深入 SPDY 的技术细节。因为这又是另一个话题。重要的是理解 SPDY 采用的是 HTTP 核心范例，通过对交换格式的修改来改进技术。我们可以看到 HTTP 清楚地划分了语义和语法。语义描述了请求和响应的概念，包括：方法，状态码，头字段（元数据）和主体部分（有效载荷）。语法描述如何将语义映射到 wire 字节上。

HTTP/0.9、1.0 和 1.1 有很多相同的语义。它们还以通过 TCP 连接发送字符串的形式共享语法。SPDY 采用 HTTP/1.1 语义，语法修改是，将字符串改为二进制。这是一个非常有趣的话题，但今天并不会深入涉及这些问题。

Google 对 SPDY 实验表明，改变 HTTP 语法是有希望的，维持现有 HTTP 语义是有意义的。比如，保留 URL 的使用格式 —— https://，可以避免许多可能影响采用的问题。

看到一些积极的结果后，IETF 决定考虑 HTTP/2.0。2012 年 3 月 IETF 83 期间举行的 HTTPbis 会议的 [slides](https://github.com/httpwg/wg-materials/blob/gh-pages/ietf83/HTTP2.pdf)显示了请求、目标和成功标准。它还明确指出 "HTTP/2.0 与 HTTP/1.x 连线格式不兼容"。

![](https://blog.cloudflare.com/content/images/2019/01/http2-standardisation.png)

社区在这次会议期间被邀请分享提案。提交审议的 I-D 包括 [draft-mbelshe-httpbis-spdy-00](https://tools.ietf.org/html/draft-mbelshe-httpbis-spdy-00)、[draft-montenegro-httpbis-speed-mobility-00](https://tools.ietf.org/html/draft-montenegro-httpbis-speed-mobility-00) 和 [draft-tarreau-httpbis-network-friendly-00](https://tools.ietf.org/html/draft-tarreau-httpbis-network-friendly-00)。最终，SPDY 草案被通过，在 2012 年 11 月开始于 [draft-ietf-httpbis-http2-00](https://tools.ietf.org/html/draft-ietf-httpbis-http2-00)。在超过 2 年的时间里完成了 18 次草案，[RFC 7540](https://tools.ietf.org/html/rfc7540) —— HTTP/2 于 2015 年发布。在此规范期间，HTTP/2 的精确语法的差异导致 HTTP/2 和 SPDY 不兼容。

这几年，IETF 的 HTTP 相关工作繁重，HTTP/1.1 的重构与 HTTP/2 的标准化齐头并进。与 21 世纪初的平静形成了鲜明对比。你可以查看完整的时间表来查看这些繁重的工作。

尽管 HTTP/2 正处于标准化阶段，但使用和实验 SPDY 的好处不言而喻。Cloudflare 在 2012 年 8 月[引入了对 SPDY 的支持](https://blog.cloudflare.com/spdy-now-one-click-simple-for-any-website/)，在 2018 年 2 月将其弃用，我们的统计数据显示只有不到 4% 的 Web 客户仍然会考虑继续使用 SPDY。与此同时，我们在 2015 年 12 月[引入对 HTTP/2](https://blog.cloudflare.com/introducing-http2/)的支持，在 RFC 发布不久后，我们的分析表明有意义的 Web 客户端可以对其加以利用。

使用 SPDY 和 HTTP/2 协议 的 Web 客户端支持首选使用 TLS 的安全选项。2014 年 9 月引入 [Universal SSL](https://blog.cloudflare.com/introducing-universal-ssl/) 有助于确保所有注册 Cloudflare 的网站都能够利用这些新协议。

### gQUIC

2012-2015 之间，Google 继续进行试验，他们发布了 SPDY v3 和 v3.1。他们还开始研究 gQUIC(当时的发音类似于 quick），在 2012 年年初，发布了初始的公共规范。

gQUIC 的早期版本使用 SPDY v3 形式的 HTTP 语法。这个选择是有意义的，因为 HTTP/2 尚未完成。SPDY 二进制语法被打包到可以用 UDP 数据报发送数据的 QUIC 包中。这与 HTTP 传统上依赖的 TCP 传输不同。当所有的东西堆叠在一起时，就会像这样：

![](https://blog.cloudflare.com/content/images/2019/01/gquic-stack.png)

SPDY 式 gQUIC 分层模型（蛋糕模型）

gQUIC 使用巧妙的设计来实现性能优化。其中一个是破坏应用程序与传输层之间清晰的分层。这也意味着 gQUIC 只支持 HTTP。因此，gQUIC 最后被称为 "QUIC"。它是 HTTP 下一个候选版本的同义词。QUIC 从过去的几年到现在，一直在持续更新，但我们并不会涉及过多的讨论，QUIC 也被人们理解为是初始 HTTP 的变体。不幸的是，这正是我们在讨论协议时，经常出现混乱的原因。

gQUIC 继续在实验中摸索，最后选择了更接近 HTTP/2 的语法。也正因为如此，它才被称为 "HTTP/2 over QUIC"。但因为技术上的限制，所有存在一些非常微妙的差别。一个示例是，HTTP 头是如何序列化并交换的。这是一个细微的差别，但实际上，这意味着 HTTP/2 式 gQUIC 与 IETF's HTTP/2 并不兼容。

最后，同样重要的是，我们总是需要考虑互联网协议的安全方面。gQUIC 选择不使用 TLS 来提供安全性。转而使用 Google 开发的另一种称为 QUIC Crypto 的方法。其中一个有趣的方面是有一种加速安全握手的新方法。以前与服务器建立了安全会话的客户端可以重用信息来进行“零延迟往返握手”或 0-RTT 握手。0-RTT 后来被纳入 TLS 1.3。

## 现在可以告诉你什么是 HTTP/3 了么？

当然。

到目前为止，你应该已经了解了标准化的工作原理，gQUIC 并非与众不同。或许你也对 Google 用 I-D 格式编写的规范感兴趣。在2015 年 6 月的 [draft-tsvwg-quic-protocol-00](https://tools.ietf.org/html/draft-tsvwg-quic-protocol-00) 中，写有 "QUIC：基于 UDP 的安全可靠的 HTTP/2 传输" 已经提交。请记住我之前提过的，几乎都是 HTTP/2 的语法。

Google [宣布](https://groups.google.com/a/chromium.org/forum/#!topic/proto-quic/otGKB4ytAyc)将在布拉格举行一次 Bar BoF  IETF 93 会议。如有疑问，请参阅 [RFC 6771](https://tools.ietf.org/html/rfc6771)。提示：BoF 是物以类聚（Birds of a Feather）的缩写。

![](https://blog.cloudflare.com/content/images/2019/01/quic-standardisation.png)

总之，与 IETF 的合作结果是 QUIC 在传输层提供了许多优势，而且它应该与 HTTP 分离。应该重新引入层与层之间清楚的隔离。此外，还有返回基于 TLS 握手的优先级（它自 TLS 1.3 起就在运行，所以并不是太槽糕，而且它结合了 0-RTT 握手）。

大约是一年后，在 2016 年，一组新的 I-D 集合被提交：

*   [draft-hamilton-quic-transport-protocol-00](https://tools.ietf.org/html/draft-hamilton-quic-transport-protocol-00)
*   [draft-thomson-quic-tls-00](https://tools.ietf.org/html/draft-thomson-quic-tls-00)
*   [draft-iyengar-quic-loss-recovery-00](https://tools.ietf.org/html/draft-iyengar-quic-loss-recovery-00)
*   [draft-shade-quic-http2-mapping-00](https://tools.ietf.org/html/draft-shade-quic-http2-mapping-00)

这里是关于 HTTP 和 QUIC 的另一个困惑的来源。[draft-shade-quic-http2-mapping-00](https://tools.ietf.org/html/draft-shade-quic-http2-mapping-00) 题为 "HTTP/2 使用 QUIC 传输协议的语义"，对于自己的描述是 "HTTP/2 式 QUIC 的另一种语义映射"。但这个解释并不正确。HTTP/2 在维护语义的同时，改变了语法。而且，我很早之前就说过了，"HTTP/2 式 gQUIC" 从未对语法进行确切的描述，记住这个概念。

这个 QUIC 的 IETF 版本即将成为新的传输层协议。因为任务艰巨，所以 IETF 会在首次确认之前，评估测评人员对其的实际兴趣程度。因此，2016 年在柏林举行 IETF 96 会议期间，举行了一次正式的 [Birds of a Feather](https://www.ietf.org/how/bofs/) 会议。我很荣幸地参加了这次会议，[幻灯片](https://datatracker.ietf.org/meeting/96/materials/slides-96-quic-0)并未给出公正的评价。就像 Adam Roach 的[图片](https://www.flickr.com/photos/adam-roach/28343796722/in/photostream/)所示，有数百人参加了这次会议。会议结束时，达成了一致的共识：QUIC 将被 IETF 采用并标准化。

将 HTTP 映射到 QUIC 的第一个 IETF QUIC I-D —— [draft-ietf-quic-http-00](https://tools.ietf.org/html/draft-ietf-quic-http-00)，采用了 Ronseal 方法来简化命名 —— "HTTP over QUIC"。不幸的是，它并没有达到预期效果，整个内容中都残留有 HTTP/2 术语的实例。Mike Bishop —— I-D 的新编辑，发现并修复了 HTTP/2 的错误名称。在 01 草案中，将描述修改为 "a mapping of HTTP semantics over QUIC"。

随着时间和版本的推进，"HTTP/2" 的使用逐渐减少，实例部分仅仅是对 [RFC 7540](https://tools.ietf.org/html/rfc7540) 部分的引用。从 2018 年 10 月开始向前回退两年的时间开始计算，I-D 如今已经是第 16 版本。虽然 HTTP over QUIC 与 HTTP/2 有相似内容，但始终是独立的（非向后兼容的 HTTP 语法）。然而，对那些不密切关注 IETF 发展的人来说（人数众多），他们并不能从名称中发现一些细微的差异。标准化的重点之一是帮助通信和互操作性。但像命名这样的简单事件，才是导致社区相对混乱的主要原因。

回顾 2012 年的内容，"HTTP/2.0 意味着 wire 格式与 HTTP/1.x 格式不兼容"。IETF 遵循现有线索。IETF 103 是经过深思熟虑才最终达成一致的，即："HTTP over QUIC" 命名为 HTTP/3。互联网正在促使世界变得更加美好，我们可以继续进行更加重要的探讨。

## 但 RFC 7230 和 7231 并不同意你对语义和语法的定义！

文档的标题有时候会给人造成困扰。如今描述 HTTP 文档语法和语义的是：

*   [RFC 7230](https://tools.ietf.org/html/rfc7230) —— 超文本传输协议（HTTP/1.1）：消息语法和路由
*   [RFC 7231](https://tools.ietf.org/html/rfc7231) —— 超文本传输协议（HTTP/1.1）：语法和上下文

对这些名称的过度解读可能会让你认为 HTTP 版本的核心语义是特定的。比如，HTTP/1.1。但这是 HTTP 家族树的副作用。好消息是 HTTPbis 工作组正在尝试解决这个问题。一些勇敢的成员正在进行文档的另一轮修订，就像 Roy Fielding 说的 "one more time!"。这项工作目前正作为 HTTP 核心任务进行（你可能也听过 moniker HTTPtre 或 HTTPter；命名工作很艰难）。这将把六个草案压缩成三个：

*   HTTP 语义（draft-ietf-httpbis-semantics）
*   HTTP 缓存（draft-ietf-httpbis-caching）
*   HTTP/1.1 消息语法和路由（draft-ietf-httpbis-messaging）

在这种新结构之下，对于常见的 HTTP 定义来说，HTTP/2 和 HTTP/3 的语法定义会更清晰。这并不意味着它拥有超出语法以外的特性，但这在未来是否有变数仍可商榷。

## 总结

本文对过去三十年 IETF 如何标准化 HTTP 做了大概的简介。在不涉及技术细节的情况下，我尽量解释 HTTP/3 的历史发展进程。如果你跳过了中间的 good bits 部分却又想概括地了解它，概况来说就是：HTTP/3 只是一种适用于 IETF QUIC 的新 HTTP 语法 —— 一种基于 UDP 多路复用的安全传输层。仍有许多有趣的领域需要深入探索，但需要等下次有机会再做介绍。

本文的叙述过程中，我们探究了 HTTP 和 TLS 开发中的重要章节，但它们都是单独阐述的。在文章即将结束时，我们会将它们全部总结到下面介绍的完整安全 Web 时间线。你可以用它来调查详细的历史记录。对于 super sleuths，请务必查看[包括草案编号的完整版本](https://blog.cloudflare.com/content/images/2019/01/web_timeline_large1.svg)。

![](https://blog.cloudflare.com/content/images/2019/01/cf-secure-web-timeline-1.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
