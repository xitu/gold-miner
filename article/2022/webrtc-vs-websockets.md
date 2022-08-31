> * 原文地址：[WebRTC vs WebSockets Tutorial — Web Real-Time Communication](https://requestum.com/webrtc-vs-websockets)
> * 原文作者：[Requestum](https://requestum.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md](https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md)
> * 译者：[DylanXie123](https://github.com/DylanXie123)
> * 校对者：[Quincy-Ye](https://github.com/Quincy-Ye)、[CarlosChen](https://github.com/CarlosChenN)

# WebRTC 与 WebSockets 教程 — Web 端的实时通信

实时的点对点信令和媒体传输是大多数交互式 Web 应用程序的重要功能。直接传输技术的使用场景下至简单的文字聊天，上至交互式解决方案。我们邀请了该领域的专家帮助我们分析 **WebRTC 与 WebSocket** 之间的主要区别，它们的优缺点和基本工作原理。

## WebRTC 与 WebSockets — 它们有什么不同？

让我们从 WebRTC 的定义开始。它是一种实时的直接媒体传输技术，最初是一个开源项目，主要目标是为浏览器和移动应用程序提供建立连接的方法。一个连接是通过指示信号和同步信号建立的，这个过程被称为信令。

为了在两个设备之间建立 WebRTC 连接，需要一个信令服务器。它是一个中间件，除了承担建立连接的主要功能外，还最大程度上降低了有价值的信息和机密数据泄露的风险。

WebRTC 规范没有具体说明使用什么方式来传输信令数据：[WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket_API)，[XMLHttpRequest](https://developer.mozilla.org/ru/docs/Web/API/XMLHttpRequest) 或者提供其他虚拟传输方法。

什么是 WebSocket 呢？WebRTC 和 WebSocket 都是通信技术。那它们之间的区别呢？WebSocket 是一种计算机通信协议，可以进行通信和数据传输。借助着 Web 通信方案和 WebRTC 技术相结合，现代 Web 应用程序允许您与大量用户实时传输音频和视频内容。

WebSockets 最显着的优势和特性是在单个 [TCP 连接](https://techterms.com/definition/tcp) 中提供两种通信方法。

## WebRTC 与 WebSockets — 核心区别

既然我们已经认识到不能混淆这两个技术概念，就让我们来思考一下两者的主要区别吧。

WebSockets 的核心应用场景是富 Web 应用程序，而 WebRTC 的重点则是实现快速和简单的点对点连接。

1. WebSockets 的开发环境为 Java，JMS 和 C++；而 WebRTC 则是 Java 和 HTML；
2. WebRTC 更加安全；
3. 目前 WebRTC 只被部分浏览器支持，而 WebSockets 几乎与目前所有的浏览器兼容；
4. 在可扩展性方面，WebSockets 的每个会话都会有一个对应的服务端，而 WebRTC 则是点对点式的。

[我们自己的专家](https://requestum.com/about-us)常用 WebSockets 作为最优的连接协议，它的优点包括：

* 实时的数据传输；
* 可交互性；
* 高性能；
* 端到端的软件对话。

然而，该解决方案的许多方面可能与 WebRTC 的功能重合，这就是为什么很容易将它们混淆。

Web Sockets 与 WebRTC 操作之间的区别。Web sockets 的标准模式

![Web Sockets 的标准模式](https://requestum.com/images/blogposts/webrtc-vs-websockets/web-sockets.svg)
![WebRTC 的标准模式](https://requestum.com/images/blogposts/webrtc-vs-websockets/web-rtc.svg)

## WebRTC 与 WebSockets —— 优点和缺点

### WebRTC 的优点

* 无需额外安装软件；
* 使用现代音频（Opus）和视频编解码器（VP8，H.264）进行高质量数据传输；
* 视频或音频质量能在连接过程中根据具体环境进行调整，能抑制回声和噪音；
* 数据的可靠性和安全性 —— 服务器通过 [TLS](https://www.webopedia.com/TERM/T/TLS.html) 和 [SRTP](https://www.techopedia.com/definition/16483/secure-real-time-protocol-secure-rtp-or-srtp) 协议进行数据加密以保证连接的安全和可靠；
* 提供基于 HTML5 和 JavaScript 的无限制的控制接口；
* 通过 WebSockets 可以使用多种后端技术来实现控制接口；
* 开源软件的特点允许您将 WebRTC 嵌入 Web 应用程序和服务。

如果浏览器支持 WebRTC，则基于 WebRTC 的应用程序在不同的操作系统和版本（台式机或移动设备）下都会有一致的表现。这可以让您节省大量的软件开发资金。

### WebRTC 的缺点

这种突破性的网络技术也有其缺点：

* 需要一个视频会议服务器（混合视频和声音）用于音频和视频会议，因为浏览器无法同步两个或多个输入信号流；
* WebRTC 解决方案之间缺乏兼容性，不能调用其他开发者的 WebRTC 应用；
* 您必须购买订阅服务器才能进行音视频的混合的会议。

### WebSockets 的优点

WebSockets API 和协议以被 IETF 和 W3C 标准化。[我们公司的专家](http://requestum.com/)已经验证了这一技术在 Web 端，桌面端和移动端中的可用性。该通信协议的主要优点包括：

1. 跨域通信（CORS）—— 它会产生一定的安全风险，但这在复杂功能的项目中是必须的；
2. 跨平台兼容性（Web，电脑和移动设备）；
3. 在需要服务端的 Web 应用程序或移动应用程序中，能够保持后端到前端的持续连接；
4. 短时间的断连不会切断连接；
5. 提供了完成异步任务的可能，而不局限于传统 Web 上的请求响应式任务。

WebSockets 的想法源于基于 HTTP 的技术的限制。它是一种点对点协议 —— 必须首先请求从服务端发送到客户端的数据。基于此，WebSockets 允许您发送类似 UDP 的 WebSockets 消息，同时保证了与 TCP 可比的可靠性。

WebSocket 使用 HTTP 作为初始传输机制，但在接收到 HTTP 响应后会保持 TCP 连接，供之后的服务端和客户端之间发送消息使用。

### WebSockets 的缺点

交互响应的速度慢。用 WebSocket 发送数据的结果要在 75 秒后才能确认。该协议无法直接得到数据传输的结果。这就是为什么开发人员往往要被迫使用特殊的 ping 以获得快速的响应。

客户端挂断网络。在移动网络中，移动设备经常在外部 IP、NAT 和默认网络之间切换。而这不取决于使用者。发生这种情况的原因是：如果客户端在重新连接到另一个网络时没有关闭连接，则服务端不会获知您地址信息的更改。服务端继续将隐私数据发送到您不再使用的旧 IP。当该 IP 地址被其他用户使用时，信息就会泄露。

WebSockets 的其他安全问题：

* 处理拒绝；
* 可能的隐私数据泄露；
* 客户端-服务端加密等。

为了加强安全性并允许多个用户使用相同的 IP 地址，路由器会隐藏您的 IP 地址并用另一个 IP 地址替换它。

## WebRTC 架构

最初，WebRTC 是作为点对点技术开发的。因此，开发的很大一部分集中在客户端设备上。

如今，我们可以定义三种主要的 WebRTC 架构：点对点、多点会议单元和选择性转发单元。在使用过程中，它们各自有各自的特点、优点和缺点。

### 点对点 WebRTC 架构
意味着在两个浏览器之间直接传输媒体内容。这种架构的主要优点是易于实现及开发成本低，因为它不需要大型内部基础设施。此外，由于不使用中介，接收方之间的安全性得到了保证。

![点对点 WebRTC 架构](https://requestum.com/images/blogposts/webrtc-vs-websockets/peer-2-peer-webrtc.svg)

### 多点会议单元（MCUS）
MCU 架构意味着每个会议用户都向 MCU 发送数据流。该架构对每一个流进行解码，重新调整它们，从所有接收到的流中组合一个新的流，对其进行编码，然后将其发送回用户。

总的来说，MCU 是低带宽网络的一种高效可靠的解决方案。

![多点会议单元（MCUS）](https://requestum.com/images/blogposts/webrtc-vs-websockets/multipoint-conf-unit.svg)

### 选择性转发单元
SFU 是最流行的现代方法。在这种架构中，用户将媒体流发送到集中式服务器（SFU），并通过同一服务器接收来自其他用户的流。选择性转发单元 WebRTC 架构适用于 ADSL、移动和有线网络。该架构的主要优点就是它的可扩展性。

![选择性转发单元](https://requestum.com/images/blogposts/webrtc-vs-websockets/selective-forw-units.svg)

## 2020 年 Websocket 的替代方案

在开发需要实时数据的 Web 应用程序时，公司面临的问题是：如何将数据从服务端传递到客户端？标准方法是通过 WebSockets。那有没有其他的好选择吗？事实上，是有的。

首先，确定您计划使用的提交机制很重要。有两种选择：客户端拉取（浏览器中的网站向服务器请求信息）和服务器推送（服务器向网站发送相关数据）。 在 2020 年，可用的解决方案如下：
1. WebSockets（服务端推送）；
2. 长/短轮询（客户端拉取）；
3. 服务器发送事件（服务端推送）。

我们来看看后两者。

### 客户端拉取

客户端向服务端请求数据。如果没有此操作，服务端则会在一段时间内处于非活动状态，或者：

* 如果注册了更改，则发送接收到的结果并关闭请求；
* 如果它们不存在，以及服务器长时间处于非活动状态，客户端会收到有关数据不存在的通知。

AJAX 请求通过 HTTP 协议运行：默认情况下，对同一域的请求是多路复用的。但这种机制有很多问题：

- **大量的 HTTP 消息头**：由于传输的数据 —— 与发送的的数据量相比，此类消息头的有效负载更少（假设 36 KB 的消息头对应 18 KB 的有效负载）。
- **建立连接**：您可以通过对多个请求使用 HTTP 连接来解决此问题。但并不总是能够达到预期的效果，因为请求可能会不同步。
- **停机时间**：长轮询请求需要时间，因为服务器需要将结果发送给客户端。如果长时间不活动，代理服务器将关闭连接。
- **多路复用**：当响应通过连续的 HTTP/2 连接并行传递时，会发生此事件。这个缺陷不容易修复，因为轮询响应永远无法同步。

### 服务端推送

与前一个选项相比，主要区别在于您建立一个连接并记录其事件流。而长轮询为每个请求创建一个新连接。

SSE 与 WebSockets 协议只有一个相似之处 —— 它是实时运行的。但是，数据流主要是从服务端端到客户端。该协议是单向的，即客户端不能通过它向服务端发送消息。在移动设备上加载时，此功能会引起轻微延迟（长达一秒）。

服务端推送（SSE）的细节：

1. 对于持续连接，无需使用特殊协议 —— 通过标准 HTTP 请求即可完成。多路复用可通过 HTTP/2 协议完成；
2、如果连接断开，EventSource 会自动尝试恢复；
3. 在连接中断的情况下，客户端发送接收到的最后一个唯一标识符。这允许服务端确定客户端丢失了多少消息，并在下一次连接时传递丢失的消息。

![服务端推送（SSE）的细节](https://requestum.com/images/blogposts/webrtc-vs-websockets/table-1.png)
图源: [Blog Stanko](https://blog.stanko.io/do-you-really-need-websockets-343aed40aa9b)

## 总结

WebRTC 专为高性能媒体传输而设计。 WebRTC Web 应用程序通过服务或传输网络和媒体数据的网络运行。相比之下，WebSocket 用于客户端和服务端之间的通信。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
