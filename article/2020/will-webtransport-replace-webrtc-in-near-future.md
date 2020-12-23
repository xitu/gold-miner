> * 原文地址：[Will WebTransport Replace WebRTC in Near Future?](https://blog.bitsrc.io/will-webtransport-replace-webrtc-in-near-future-436c4f7f3484)
> * 原文作者：[Charuka E Bandara](https://medium.com/@charuka95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/will-webtransport-replace-webrtc-in-near-future.md](https://github.com/xitu/gold-miner/blob/master/article/2020/will-webtransport-replace-webrtc-in-near-future.md)
> * 译者：
> * 校对者：

# Will WebTransport Replace WebRTC in Near Future?

![Photo by [Gabriel Benois](https://unsplash.com/@gabrielbenois) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*4MaUNhpUTKLuBX14)

Video and audio conferencing on the web have become popular in the modern era. In the good old days, it required an intermediary server to transfer data between two parties. Since it was slow and grainy, there were many innovations to improve the underlying technology to overcome its limitations.

![Diagram by the author: The basic architecture of the WebSockets](https://cdn-images-1.medium.com/max/2000/1*UZMYYV48pGhgjkcEh0lPNg.png)

During 2010 the Google engineers introduced WebRTC to solve some of these challenges. Today we use it almost everywhere.

## Introducing WebRTC

WebRTC, Web Real-time communication is the protocol (collection of APIs) that allows direct communication between browsers. These APIs support exchanging files, information, or any data. It sounds like WebSockets. However, it is not.

![Diagram by the author: The basic architecture of WebRTC](https://cdn-images-1.medium.com/max/2140/1*ZtTqRURkQA2nqRgrrCjwTg.png)

As we discussed, communication happens between browsers without requiring the direct involvement of the server. However, the server needs to facilitate sharing each other’s IP address at the beginning. Still, it’s faster than communicating through a server.

Then you might wonder, why do we need a new protocol? The reason is that as time passes, technologies evolve, and we can find some of its limitations coming to the surface.

## So what are the limitations with WebRTC?

#### The head of the line blocking (HOL) at the TCP layer

This is the same problem that we have with HTTP/2. When using HTTP/2, multiple requests will be sent to servers as encapsulated streams. Therefore in a given instance, multiple requests will use a single TCP connection.

Suppose two GET requests are having six packets each. While sending a GET request, if one packet is damaged or lost during the transmission, the TCP stream makes the entire stream wait until that packet is re-transmitted and received by the server. So the TCP HOL will occur.

> Don’t get confused between the TCP vs HTTP HOL. These are two things. Only TCP HOL becomes an issue here.

Since WebRTC is built on top of HTTP/2, this issue can occur in any scenario such as file transmission, video conferencing.

#### Clients have to initiate the connection

In this case, the limitation is tricky because the client has to initiate a connection to avoid networking issues or security issues. That is how things work. The challenge in WebRTC is that no one else can send any information without the client’s awareness.

However, HTTP push tried to get rid of this by creating a new stream. Here, the server creates a new stream and then push content to the client. However, it was not successful. So. lately, Google has removed that approach from Chrome.

So, to address these issues, here comes the all-new WebTransport.

## What is WebTransport?

WebTransport is a pluggable protocol for client-server communication, built on top of HTTP/2, HTTP/3, and QUIC. It is designed to replace WebSockets going ‘QUIC-native.’

> You can think of it as WebRTC, but optimize for 80/20 Rule.

> QUIC is a web API that uses the QUIC protocol in a bidirectional, non-HTTP transport, which is served over UDP, similar to an independent TCP that drastically reduced connection setup latency. The main functionality is two-way communications between a web client and a QUIC server with steam APIs.

Besides, WebTransport has the support for multiple streams, unidirectional streams, out-of-order delivery, reliable and unreliable transport.

## Overcoming the challenges with WebTransport

#### WebTransport is on top of QUIC

WebTransport is an interface that can talk to HTTP/2 based, HTTP/3 based, and QUIC based protocols. So, it has the advantage that HTTP and non-HTTP traffic can share the same network port.

Besides, since QUIC operates over UDP, each stream is independent. Switching to UDP is an advantage to reduce the impact of TCP head of line blocking. Therefore any lost packet only halts the stream that it belongs to, while the other streams can go on.

#### WebTransport supports multiple protocols

WebTransport supports unidirectional streams (indefinitely long streams of bytes in one direction), bidirectional streams (full-duplex streams), and datagrams (small/out-of-order/unreliable messages). So, there are some key usages of WebTransport which are,

* WebTransport can request over HTTP and receiving data **pushed** **out-of-order** (reliably and unreliable) over the same network connection.
* WebTransport can send data (reliable and unreliable) to the server using a QUIC unidirectional send stream.
* WebTransport can receive data pushed from the server using unidirectional receive streams.

So in the gaming industry, WebTransport will play a significant role because of its capability of receiving media pushed from the server with minimal latency.

## Conclusion

In my opinion, WebRTC is doing quite well, and people use it for many years now. Obviously, with the changing technological world, there are situations where even the latency of milliseconds matters. As we discussed, industries like online gaming would reap the clear benefits of WebTransport.

> WebSocket based WebRTC is not the fastest approach anymore.

In this case, the powerful WebTransport will address the issue of Web Socket based WebRTC. By considering all these advantages, I believe WebTransport will replace WebRTC. But it will take some time for people to adapt.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
