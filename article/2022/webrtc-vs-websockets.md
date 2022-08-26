> * 原文地址：[WebRTC vs WebSockets Tutorial — Web Real-Time Communication](https://requestum.com/webrtc-vs-websockets)
> * 原文作者：[Requestum](https://requestum.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md](https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md)
> * 译者：[DylanXie123](https://github.com/DylanXie123)
> * 校对者：

# WebRTC vs WebSockets Tutorial — Web Real-Time Communication
# WebRTC 与 WebSockets 教程 — Web 端的实时通信

Real-time peer-to-peer signaling and media exchange is an important capabilities for most interactive web applications. Use cases of direct exchange technologies range from simple text chats to interactive solutions. We asked the specialists in the field to help us analyze the key differences **between WebRTC vs WebSocket**, their pros, cons, and basic principles of work.
实时的点对点信令和媒体传输是大多数交互式 Web 应用程序的重要功能。直接传输技术的使用场景可囊括简单的文字聊天至交互式解决方案。我们邀请了该领域的专家帮助我们分析 **WebRTC 与 WebSocket** 之间的主要区别，它们的优缺点和基本工作原理。

## WebRTC vs WebSockets — What’s the Difference?
## WebRTC 与 WebSockets — 它们有什么不同？

Let’s start with the WebRTC definition. It is a real-time direct media exchange technology, an open-source project originally. Its main goal is to provide the connection means for browsers and mobile apps. A connection is established through signal indication and synchronization — the whole process is essentially called signaling.
让我们从 WebRTC 的定义开始。它是一种实时的直接媒体传输技术，最初是一个开源项目，主要目标是为浏览器和移动应用程序提供建立连接的方法。一个连接是通过指示信号和同步信号建立的，这个过程被称为信令。

To establish a WebRTC connection between two devices, a signaling server is required. It is an intermediary that on top of its main function of establishing a connection also minimizes the risk of valuable information and confidential data leakage.
为了在两个设备之间建立 WebRTC 连接，需要一个信令服务器。它是一个中间件，除了建立连接的主要功能外，还能降低重要以及机密数据泄露的风险。

The WebRTC specification does not specify what exactly to use to transmit signaling data: [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket_API), [XMLHttpRequest](https://developer.mozilla.org/ru/docs/Web/API/XMLHttpRequest), or another virtual transport.
WebRTC 规范没有具体说明使用什么方式来传输信令数据：[WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket_API)，[XMLHttpRequest](https:// developer.mozilla.org/ru/docs/Web/API/XMLHttpRequest)或其他虚拟传输方法都是可选的方案。

What is WebSocket? Both WebRTC and WebSocket are technologies for communication capabilities. What is the difference between them? WebSocket is a computer communication protocol that enables communication and data exchange. With the help of this web communication solution and WebRTC technology combined, modern web applications allow you to exchange audio and video content with a large number of users in real-time.
什么是 WebSocket 呢？WebRTC 和 WebSocket 都是通信技术。那它们之间的区别呢？WebSocket 是一种计算机通信协议，可以进行通信和数据交换。将此 Web 通信方案和 WebRTC 技术相结合，现代 Web 应用程序允许您与大量用户实时交换音频和视频内容。

The most significant advantage and feature of WebSockets is the availability of two communication methods over a single [TCP connection](https://techterms.com/definition/tcp).
WebSockets 最显着的优势和特性是在单个 [TCP 连接](https://techterms.com/definition/tcp) 中提供两种通信方法。

## WebRTC vs WebSockets — Key Differences
## WebRTC 与 WebSockets — 核心区别

Now that we figured out that you should not confuse these tech concepts, let’s consider the main differences between them.
既然我们已经认识到不能混淆这两个技术概念，就让我们来思考一下两者的主要区别吧。

While the WebSockets ‘core’ is rich web applications, the focus of WebRTC is on fast and simple peer-to-peer connections.
WebSockets 的核心应用场景是 Web 应用程序，而 WebRTC 的重点是实现快速和简单的点对点连接。

1. The environment for WebSockets is Java, JMS, and C ++; for WebRTC — Java, and HTML;
2. WebRTC is more secure;
3. At the moment, WebRTC is only supported by certain browsers while WebSockets is compatible with almost all existing browsers;
4. In terms of scalability, WebSockets uses a server per session approach and WebRTC is peer-to-peer.
1、WebSockets 的开发环境为 Java，JMS 和 C++；而 WebRTC 则是 Java 和 HTML；
2、WebRTC 更加安全；
3、目前 WebRTC 只被部分浏览器支持，而 WebSockets 几乎与目前所有的浏览器兼容；
4. 在可扩展性方面，WebSockets 的每个会话都会有一个对应的服务端，而 WebRTC 则是点对点式的。

[Our own experts](https://requestum.com/about-us) frequently use WebSockets as a top beneficial connection protocol, which boasts:
[我们自己的专家](https://requestum.com/about-us) 常认为 WebSockets 是最优的连接协议，它的优点包括：

* data transmission in real-time;
* interactivity;
* high performance;
* End-to-end software dialogue.
* 实时的数据传输；
* 可交互性；
* 高性能；
* 端到端的软件对话。

Many of the solution’s aspects, however, can overlap with WebRTC’s capabilities, which is why it’s easy to confuse them.
然而，该解决方案的许多方面可能与 WebRTC 的功能重合，这就是为什么很容易将它们混淆。

The difference between Web Sockets vs WebRTC operation. The standard mode of Web Sockets
Web Sockets 与 WebRTC 操作之间的区别

![Web Sockets 的标准模式](https://requestum.com/images/blogposts/webrtc-vs-websockets/web-sockets.svg)
![WebRTC 的标准模式](https://requestum.com/images/blogposts/webrtc-vs-websockets/web-rtc.svg)

## WebRTC vs WebSockets — Pros and Cons
## WebRTC 与 WebSockets —— 优点和缺点

### Pros of WebRTC
### WebRTC 的优点

* No software installation is required;
* High-quality data transmission using modern audio (Opus) and video codecs (VP8, H.264);
* Video or audio quality adjusts to the digital environment during the connection, suppressing echoes and noise;
* Reliability and safety of data — the server protects connections by encrypting them via [TLS](https://www.webopedia.com/TERM/T/TLS.html) and [SRTP](https://www.techopedia.com/definition/16483/secure-real-time-protocol-secure-rtp-or-srtp) protocols;
* An implementation of an unlimited control interface based on HTML5 and JavaScript is available;
* There is an option to implement an interface with various backend systems via WebSockets;
* Open-source software allows you to embed WebRTC with web applications and services.
* 无需额外安装软件；
* 使用现代音频（Opus）和视频编解码器（VP8，H.264）进行高质量数据传输；
* 视频或音频质量能在连接过程中根据具体环境进行调整，能抑制回声和噪音；
* 数据的可靠性和安全性 —— 服务器通过 [TLS](https://www.webopedia.com/TERM/T/TLS.html) 和 [SRTP](https://www.techopedia. com/definition/16483/secure-real-time-protocol-secure-rtp-or-srtp) 协议进行数据加密以保证连接的安全和可靠；
* 提供基于 HTML5 和 JavaScript 的无限制的控制接口；
* 通过 WebSockets 可以使用多种后端技术来实现控制接口；
* 开源软件的特点允许您将 WebRTC 嵌入 Web 应用程序和服务。

WebRTC-based applications differ in productivity regardless of operating systems and version (desktop or mobile), if the browser supports WebRTC. This allows you to save lots of software development money.
如果浏览器支持 WebRTC，则基于 WebRTC 的应用程序在生产环境下会有所不同，无论操作系统和版本（台式机或移动设备）如何。这可以让您节省大量的软件开发资金。

### Cons of WebRTC
### WebRTC 的缺点

This breakthrough web technology also has its drawbacks:
这种突破性的网络技术也有其缺点：

* The need for a video conferencing server (which mixes video and sound) for audio and video conferences in a group, since the browser is unable to synchronize two or more incoming streams;
* Lack of compatibility of WebRTC solutions with each other: you cannot make calls to WebRTC applications of other developers;
* You must purchase a subscription to mix conferences in a group.
* 需要一个视频会议服务器（混合视频和声音）用于音频和视频会议，因为浏览器无法同步两个或多个输入信号流；
* WebRTC 解决方案之间缺乏兼容性，不能调用其他开发者的 WebRTC 应用；
* 您必须购买订阅服务才能在群组中混合会议。

### Pros of WebSockets
### WebSockets 的优点

The WebSockets API and protocol are standardized by the IETF and W3C. They have proven themselves among the [experts of our company](http://requestum.com/) as a functional technology in web, desktop, and mobile applications. The main advantages of this communication protocol include:
WebSockets API 和协议以被 IETF 和 W3C 标准化。[我们公司的专家](http://requestum.com/)已经认可了这一技术在 Web端，桌面端和移动端中的可用性。该通信协议的主要优点包括：

1. cross-communication (cross-origin communication) — it creates certain security risks but is needed for extensive functionality;
2. cross-platform compatibility (web, computer, mobile devices);
3. continuous connection from the backend to the frontend in a web application or mobile application working with a server;
4. short-term lack of connection does not break the connection;
5. the possibility of asynchronous work, instead of the classic work on the Web in the request-response format.
1. 跨域通信（CORS）—— 它会产生一定的安全风险，但这在复杂功能的项目中是必须的；
2. 跨平台兼容性（Web，电脑和移动设备）；
3. 在需要服务端的 Web 应用程序或移动应用程序中，能够保持后端到前端的持续连接；
4. 短时间的断连不会切断连接；
5. 提供了完成异步任务的可能，而不局限于传统 Web 上的请求响应式任务。

The idea for WebSockets was born out of the limitations of HTTP-based technology. It is a peer-to-peer protocol — data that is sent from the server to the client must first be requested. In turn, WebSockets allow you to send data based on UDP-like WebSockets messages, but with higher TCP reliability.
WebSockets 的想法源于基于 HTTP 的技术的限制。它是一种点对点协议 —— 必须首先请求从服务器发送到客户端的数据。基于此，WebSockets 允许您发送类似 UDP 的 WebSockets 消息，同时保证了与 TCP 可比的可靠性。

WebSocket uses HTTP as an initial transport mechanism but maintains a TCP connection after receiving an HTTP response for later use in sending messages between the server and the client.
WebSocket 使用 HTTP 作为初始传输机制，但在接收到 HTTP 响应后保持 TCP 连接，在之后的服务端和客户端之间发送消息时使用。

### Cons of WebSockets
### WebSockets 的缺点

Slow interaction response. The result of sending data to the WebSocket becomes known after 75 seconds of the timeout. The protocol doesn’t directly announce the result. That’s why developers are often forced to run special pings to get a quick response.
交互响应的速度慢。用 WebSocket 发送数据的结果要在 75 秒后才能确认。该协议无法直接得到数据传输的结果。这就是为什么开发人员往往要被迫使用特殊的 ping 以获得快速的响应。

Hange of the network by the client. In mobile networks, mobile devices often switch between external IP, NAT, and the default network. And this doesn’t depend on the operator. Why this happens: the server doesn’t get information about your change of address if the client did not close the connection when reconnecting to another network. The server continues to send private data to the old IP, which you no longer use. This IP address is used by another user and information is leaked.
客户端挂断网络。在移动网络中，移动设备经常在外部 IP、NAT 和默认网络之间切换。而这不取决于使用者。发生这种情况的原因是：如果客户端在重新连接到另一个网络时没有关闭连接，则服务端不会获知您地址信息的更改。服务端继续将隐私数据发送到您不再使用的旧 IP。当该 IP 地址被其他用户使用时，信息就会泄露。

Other security issues in WebSockets:
WebSockets 的其他安全问题：

* processing denial;
* possible private data leaks;
* client-server encryption, etc.
* 处理拒绝；
* 可能的隐私数据泄露；
* 客户端-服务端加密等。

To reinforce security and allow multiple users to use the same IP address, the router hides your IP address and replaces it with another.
为了加强安全性并允许多个用户使用相同的 IP 地址，路由器会隐藏您的 IP 地址并用另一个 IP 地址替换它。

## WebRTC architecture
## WebRTC 架构

Initially, WebRTC was developed as a peer-to-peer technology. Accordingly, a significant portion of the development has centered around the client device.
最初，WebRTC 是作为点对点技术开发的。因此，开发的很大一部分集中在客户端设备上。

Today, we can define three main WebRTC architectures: peer-to-peer, multipoint conferencing units, and selective forwarding units. Each of them has its own characteristics, advantages, and disadvantages in use.
如今，我们可以定义三种主要的 WebRTC 架构：点对点、多点会议单元和选择性转发单元。它们中的每一个在使用中都有自己的特点、优点和缺点。

### PEER-TO-PEER WEBRTC ARCHITECTURE
### 点对点 WebRTC 架构
Implies a direct exchange of media content between two browsers. The main advantage of this architecture is the ease of implementation and low cost of app development since it does not require a large internal infrastructure. In addition, security is guaranteed between the receiving parties since no intermediary is used.
意味着在两个浏览器之间直接传输媒体内容。这种架构的主要优点是易于实现及开发成本低，因为它不需要大型内部基础设施。此外，由于不使用中介，接收方之间的安全性得到了保证。

![PEER-TO-PEER WEBRTC ARCHITECTURE](https://requestum.com/images/blogposts/webrtc-vs-websockets/peer-2-peer-webrtc.svg)

### MULTIPOINT CONFERENCING UNIT (MCUS)
### 多点会议单元 (MCUS)
The MCU architecture implies that each conference user sends a data stream to the MCU. The architecture decodes each of these streams, rescales them, composes a new one from all received, encodes it, and sends it back to users.
MCU 架构意味着每个会议用户都向 MCU 发送数据流。该架构对每一个流进行解码，重新调整它们，从所有接收到的流中组合一个新的流，对其进行编码，然后将其发送回用户。

Ultimately, MCU is an efficient and reliable solution for low-bandwidth networks.
总的来说，MCU 是低带宽网络的一种高效可靠的解决方案。

![MULTIPOINT CONFERENCING UNIT (MCUS)](https://requestum.com/images/blogposts/webrtc-vs-websockets/multipoint-conf-unit.svg)

### SELECTIVE FORWARDING UNITS
### 选择性转发单元
SFU is the most popular of modern approaches. In this architecture, users send media streams to a centralized server (SFU) and receive streams from other users through the same server. Selective Forwarding Units WebRTC architecture is suitable for ADSL, mobile, and cable networks. The main advantage of the architecture is its scalability.
SFU 是最流行的现代方法。在这种架构中，用户将媒体流发送到集中式服务器 (SFU)，并通过同一服务器接收来自其他用户的流。选择性转发单元 WebRTC 架构适用于 ADSL、移动和有线网络。该架构的主要优点就是它的可扩展性。

![SELECTIVE FORWARDING UNITS](https://requestum.com/images/blogposts/webrtc-vs-websockets/selective-forw-units.svg)

## Websocket alternative 2020
## 2020 年 Websocket 的替代方案

When it comes to the development of a web application that uses data in real-time, companies are faced with the question: how to deliver data from server to client? The standard approach is through WebSockets. Are there any decent alternatives? Yes, there are in fact.
在开发实时使用数据的 Web 应用程序时，公司面临的问题是：如何将数据从服务器传递到客户端？标准方法是通过 WebSockets。有没有像样的选择？是的，事实上有。

First of all, it is important to determine the submission mechanism that you plan to use. There are two options: client pull (the website in the browser requests information from the server) and server push (the server sends relevant data to the website). In 2020, the following methods are used for this purpose:
首先，确定您计划使用的提交机制很重要。有两种选择：客户端拉取（浏览器中的网站向服务器请求信息）和服务器推送（服务器向网站发送相关数据）。 2020 年，为此目的使用了以下方法：

1. WebSockets (server push);
2. Long/short polling (client pull);
3. Server-Sent Events (server push).
1. WebSockets（服务端推送）；
2. 长/短轮询（客户端拉取）；
3. 服务器发送事件（服务端推送）。

Let’s take a look at the latter two.
我们来看看后两者。

### Client Pull
### 客户端拉取

The client makes a data request to the server. Without this action, the server remains inactive for a certain time or:
客户端向服务端请求数据。如果没有此操作，服务器则会在一段时间内不活动，或者：

* if there are changes registered, it sends the received result and closes the request;
* if they are absent, as well as if the server has been inactive for a long time, the client receives a notification about the absence of data.
* 如果注册了更改，则发送接收到的结果并关闭请求；
* 如果它们不存在，以及服务器长时间处于非活动状态，客户端会收到有关数据不存在的通知。

AJAX requests operate over the HTTP protocol: by default, requests to the same domain are multiplexed. This mechanism has a number of issues:
AJAX 请求通过 HTTP 协议运行：默认情况下，对同一域的请求是多路复用的。但这种机制有很多问题：

- **Large volume of HTTP-headers**: Due to the data delivered - the payload of such headers is less compared to the amount of sent B (let's say 36KB of headers for 18KB of payload).
- **Establishment of connection**: You can work around this problem by using an HTTP connection for multiple requests. But it is not always possible to achieve the desired effect, since the requests can go out of sync.
- **Downtime**: Long polling requests take time because the server needs to send the result to the client). If there is a long period of inactivity, the proxy server will close the connection.
- **Multiplexing**: This event occurs when responses are delivered in parallel over a continuous HTTP/2 connection. This flaw is not easy to fix because the polling responses can never be synced.
- **大量的 HTTP 消息头**：由于传输的数据 —— 与发送的的数据量相比，此类消息头的有效负载更少（假设 36KB 的消息头对应 18KB 的有效负载）。
- **建立连接**：您可以通过对多个请求使用 HTTP 连接来解决此问题。但并不总是能够达到预期的效果，因为请求可能会不同步。
- **停机时间**：长轮询请求需要时间，因为服务器需要将结果发送给客户端。如果长时间不活动，代理服务器将关闭连接。
- **多路复用**：当响应通过连续的 HTTP/2 连接并行传递时，会发生此事件。这个缺陷不容易修复，因为轮询响应永远无法同步。

### Server Push
### 服务端推送

The main difference compared to the previous option is that you get one connection and keep the flow of events that goes through it. Long polling creates a new connection for every request.
与前一个选项相比，主要区别在于您建立一个连接并记录其事件流。而长轮询为每个请求创建一个新连接。

SSE has only one similarity to the WebSockets protocol — it runs in real-time. However, the mainstream of data comes from the server to the client. The protocol is unidirectional, that is, the client cannot send messages through it to the server. This feature provokes a slight delay when loading on mobile devices (up to a second long).
SSE 与 WebSockets 协议只有一个相似之处 —— 它是实时运行的。但是，数据流主要是从服务器端到客户端。该协议是单向的，即客户端不能通过它向服务端发送消息。在移动设备上加载时，此功能会引起轻微延迟（长达一秒）。

Specifics of Server Push (SSE):
服务器推送（SSE）的细节：

1. For a continuous connection, no special protocol is used — the processes occur through standard HTTP requests. Multiplexing is carried out over the HTTP/2 protocol;
2. If the connection is broken, EventSource will automatically try to resume it;
3. In case of an interrupted connection, the client sends the last unique identifier known to him. This allows the server to determine how many messages were missed by the client, as well as deliver the missed messages on the next connection.
1. 对于持续连接，无需使用特殊协议 —— 通过标准 HTTP 请求即可完成。多路复用可通过 HTTP/2 协议完成；
2、如果连接断开，EventSource 会自动尝试恢复；
3. 在连接中断的情况下，客户端发送接收到的最后一个唯一标识符。这允许服务器确定客户端丢失了多少消息，并在下一次连接时传递丢失的消息。

![Specifics of Server Push (SSE)](https://requestum.com/images/blogposts/webrtc-vs-websockets/table-1.png)
Source: [Blog Stanko](https://blog.stanko.io/do-you-really-need-websockets-343aed40aa9b)
图源: [Blog Stanko](https://blog.stanko.io/do-you-really-need-websockets-343aed40aa9b)

## Summary
## 总结

WebRTC is designed for high-performance media transfer. WebRTC web applications run through a service or transport, through which they exchange network and media data. WebSocket, by contrast, is for communication between client and server.
WebRTC 专为高性能媒体传输而设计。 WebRTC Web 应用程序通过服务或传输网络和媒体数据的网络运行。相比之下，WebSocket 用于客户端和服务端之间的通信。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
