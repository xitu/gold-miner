> * 原文地址：[Will WebTransport Replace WebRTC in Near Future?](https://blog.bitsrc.io/will-webtransport-replace-webrtc-in-near-future-436c4f7f3484)
> * 原文作者：[Charuka E Bandara](https://medium.com/@charuka95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/will-webtransport-replace-webrtc-in-near-future.md](https://github.com/xitu/gold-miner/blob/master/article/2020/will-webtransport-replace-webrtc-in-near-future.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[zhuzilin](https://github.com/zhuzilin)

# WebTransport 会在不久的将来取代 WebRTC 吗？

![Photo by [Gabriel Benois](https://unsplash.com/@gabrielbenois) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*4MaUNhpUTKLuBX14)

目前，在网络上进行视频和音频会议已经很流行了。在过去，音视频会议往往需要一个中间服务器在双方之间进行数据传输。由于该传输过程缓慢且画质粗糙，所以出现过许多创新来改进其底层技术，以解决音视频传输的局限性。

![Diagram by the author: The basic architecture of the WebSockets](https://cdn-images-1.medium.com/max/2000/1*UZMYYV48pGhgjkcEh0lPNg.png)

从 2010 年开始，谷歌的工程师引入了 WebRTC 来解决这些问题。今天，我们在很多地方都使用它。

## WebRTC 简介

WebRTC，即 Web 实时通信，是一种允许浏览器之间直接进行通信的协议（API 集合）。这些 API 支持文件、信息或任何数据的传输。听起来像 WebSockets。但是，事实并非如此。

![Diagram by the author: The basic architecture of WebRTC](https://cdn-images-1.medium.com/max/2140/1*ZtTqRURkQA2nqRgrrCjwTg.png)

像我们提到的，通信是发生在浏览器之间，它不需要服务器的直接参与。然而，服务器需要在初始阶段借助浏览器获取对端的 IP 地址。尽管如此，它还是比经过服务器进行通信快的多。

接下来你可能会好奇，为什么我们需要一个新的协议？那是因为随着时间的流逝和技术的不断发展，我们逐渐发现 WebRTC 传输方式的一些局限性。

## WebRTC 的局限性是什么？

#### TCP层的队头阻塞（HOL）

这和我们在 HTTP/2 协议中遇到的问题是一样的。当使用 HTTP/2 协议时，多个请求被封装成流发送到服务器。因此，在给定实例中，多个请求将使用一个TCP连接。

假设有两个 GET 请求，每个请求有六个数据包。在发送 GET 请求时，如果在传输过程中有一个包发生了损坏或丢包，TCP 流会让整个流等待，直到该包被服务器重新传输和接收。因此会发生 TCP HOL。

> 不要混淆 TCP 和 HTTP HOL。这是两个不同的问题。在这里只有 TCP HOL 会造成 WebRTC 传输问题。

由于 WebRTC 是建立在 HTTP/2 协议之上，所以任何场景都可能会触发这个问题，如文件传输，视频会议。

#### WebRTC 必须由客户端发起连接

在这种情况下，因为必须由客户端发起连接以避免网络问题或安全问题，传输的局限性就会凸显出来。事实也是这样。WebRTC 面临的挑战是，在客户端未授权的情况下，任何人都不能发送信息。

但是，HTTP 推送尝试通过创建新的数据流来解决这个问题。在这里，服务器创建一个新的流，然后将内容推送到客户端。但是，它没有成功。所以最近 Google 从 Chrome 中删除了该方法。

因此，要解决这些问题，请使用全新的 WebTransport。

## WebTransport 是什么?

WebTransport 是一个可插拔的客户端-服务器通信协议，基于 HTTP/2、HTTP/3 和 QUIC 协议构建。其设计目的是取代 WebSockets 进而走向“原生的 QUIC 协议”。

> 你可以将它看作 WebRTC，但针对 80/20 规则进行了优化。

> QUIC 是一种 web API，它在双向的非 HTTP 传输中使用 QUIC 协议，通过 UDP 提供服务，类似于一个独立的 TCP，极大地减少了 TCP 建立连接所带来的延迟。主要功能是使用 steam api 在 web 客户端和 QUIC 服务器之间进行双向通信。

此外，WebTransport 还支持多数据流、单向数据流、无序传输、可靠和不可靠传输。

## WebTransport 克服了这些难题

#### WebTransport 是基于 QUIC 协议

WebTransport 是一个接口，它可以与基于 HTTP/2、HTTP/3 和 QUIC 的协议进行通信。因此，它的优点是 HTTP 和非 HTTP 流量都可以共享相同的网络端口。

此外，由于 QUIC 是基于 UDP 的，所以其每个数据流都是独立的。使用 UDP 是它的一个优势，它规避了 TCP 的队头阻塞问题。因此，任何丢失的数据包都只会导致它所在的流暂停传输，而其他流仍然可以正常传输。

#### WebTransport 支持多种协议

WebTransport 支持单向流 (单向无限长的字节流) 、双向流 (全双工流) 和数据报文 (小的/无序的/不可靠的消息) 。因此，WebTransport 有一些关键的用法：

* WebTransport 可以通过 HTTP 协议请求和接收数据 **可靠** **不可靠** (可靠的或不可靠的) ，它们都是经过通过相同的网络连接。
* WebTransport 可以使用 QUIC 协议单向发送流发送数据 (可靠和不可靠) 到服务器。
* WebTransport 可以使用单向接收流从服务器进行数据推送。

所以在游戏行业中，WebTransport 将起到重要作用，因为它能够以最小的延迟接收来自服务器的数据推送。

## 结论

在我看来，WebRTC 已经做得很好了，人们使用它已经很长一段时间了。很明显，随着技术世界的不断变化，在某些情况下，甚至毫秒级的延迟也很重要。正如我们所提到的，像游戏这样的行业使用 WebTransport 将获得显著的收益。

> 基于 WebSocket 的 WebRTC 已经不是最快的方法了。

在这种情况下，强大的 WebTransport 将解决基于 WebRTC 的 WebSocket 问题。考虑到所有这些优点，我相信 WebTransport 将取代 WebRTC。只不过人们需要一段时间来适应它。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
