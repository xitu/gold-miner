> * 原文地址：[WebRTC vs WebSockets Tutorial — Web Real-Time Communication](https://requestum.com/webrtc-vs-websockets)
> * 原文作者：[Requestum](https://requestum.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md](https://github.com/xitu/gold-miner/blob/master/article/2022/webrtc-vs-websockets.md)
> * 译者：
> * 校对者：

# WebRTC vs WebSockets Tutorial — Web Real-Time Communication

Real-time peer-to-peer signaling and media exchange is an important capabilities for most interactive web applications. Use cases of direct exchange technologies range from simple text chats to interactive solutions. We asked the specialists in the field to help us analyze the key differences **between WebRTC vs WebSocket**, their pros, cons, and basic principles of work.

## WebRTC vs WebSockets — What’s the Difference?

Let’s start with the WebRTC definition. It is a real-time direct media exchange technology, an open-source project originally. Its main goal is to provide the connection means for browsers and mobile apps. A connection is established through signal indication and synchronization — the whole process is essentially called signaling.

To establish a WebRTC connection between two devices, a signaling server is required. It is an intermediary that on top of its main function of establishing a connection also minimizes the risk of valuable information and confidential data leakage.

The WebRTC specification does not specify what exactly to use to transmit signaling data: [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket_API), [XMLHttpRequest](https://developer.mozilla.org/ru/docs/Web/API/XMLHttpRequest), or another virtual transport.

What is WebSocket? Both WebRTC and WebSocket are technologies for communication capabilities. What is the difference between them? WebSocket is a computer communication protocol that enables communication and data exchange. With the help of this web communication solution and WebRTC technology combined, modern web applications allow you to exchange audio and video content with a large number of users in real-time.

The most significant advantage and feature of WebSockets is the availability of two communication methods over a single [TCP connection](https://techterms.com/definition/tcp).

## WebRTC vs WebSockets — Key Differences

Now that we figured out that you should not confuse these tech concepts, let’s consider the main differences between them.

While the WebSockets ‘core’ is rich web applications, the focus of WebRTC is on fast and simple peer-to-peer connections.

1. The environment for WebSockets is Java, JMS, and C ++; for WebRTC — Java, and HTML;
2. WebRTC is more secure;
3. At the moment, WebRTC is only supported by certain browsers while WebSockets is compatible with almost all existing browsers;
4. In terms of scalability, WebSockets uses a server per session approach and WebRTC is peer-to-peer.

[Our own experts](https://requestum.com/about-us) frequently use WebSockets as a top beneficial connection protocol, which boasts:

* data transmission in real-time;
* interactivity;
* high performance;
* End-to-end software dialogue.

Many of the solution’s aspects, however, can overlap with WebRTC’s capabilities, which is why it’s easy to confuse them.

The difference between Web Sockets vs WebRTC operation. The standard mode of Web Sockets

## WebRTC vs WebSockets — Pros and Cons

### Pros of WebRTC

* No software installation is required;
* High-quality data transmission using modern audio (Opus) and video codecs (VP8, H.264);
* Video or audio quality adjusts to the digital environment during the connection, suppressing echoes and noise;
* Reliability and safety of data — the server protects connections by encrypting them via [TLS](https://www.webopedia.com/TERM/T/TLS.html) and [SRTP](https://www.techopedia.com/definition/16483/secure-real-time-protocol-secure-rtp-or-srtp) protocols;
* An implementation of an unlimited control interface based on HTML5 and JavaScript is available;
* There is an option to implement an interface with various backend systems via WebSockets;
* Open-source software allows you to embed WebRTC with web applications and services.

WebRTC-based applications differ in productivity regardless of operating systems and version (desktop or mobile), if the browser supports WebRTC. This allows you to save lots of software development money.

### Cons of WebRTC

This breakthrough web technology also has its drawbacks:

* The need for a video conferencing server (which mixes video and sound) for audio and video conferences in a group, since the browser is unable to synchronize two or more incoming streams;
* Lack of compatibility of WebRTC solutions with each other: you cannot make calls to WebRTC applications of other developers;
* You must purchase a subscription to mix conferences in a group.

### Pros of WebSockets

The WebSockets API and protocol are standardized by the IETF and W3C. They have proven themselves among the [experts of our company](http://requestum.com/) as a functional technology in web, desktop, and mobile applications. The main advantages of this communication protocol include:

1. cross-communication (cross-origin communication) — it creates certain security risks but is needed for extensive functionality;
2. cross-platform compatibility (web, computer, mobile devices);
3. continuous connection from the backend to the frontend in a web application or mobile application working with a server;
4. short-term lack of connection does not break the connection;
5. the possibility of asynchronous work, instead of the classic work on the Web in the request-response format.

The idea for WebSockets was born out of the limitations of HTTP-based technology. It is a peer-to-peer protocol — data that is sent from the server to the client must first be requested. In turn, WebSockets allow you to send data based on UDP-like WebSockets messages, but with higher TCP reliability.

WebSocket uses HTTP as an initial transport mechanism but maintains a TCP connection after receiving an HTTP response for later use in sending messages between the server and the client.

### Cons of WebSockets

Slow interaction response. The result of sending data to the WebSocket becomes known after 75 seconds of the timeout. The protocol doesn’t directly announce the result. That’s why developers are often forced to run special pings to get a quick response.

Hange of the network by the client. In mobile networks, mobile devices often switch between external IP, NAT, and the default network. And this doesn’t depend on the operator. Why this happens: the server doesn’t get information about your change of address if the client did not close the connection when reconnecting to another network. The server continues to send private data to the old IP, which you no longer use. This IP address is used by another user and information is leaked.

Other security issues in WebSockets:

* processing denial;
* possible private data leaks;
* client-server encryption, etc.

To reinforce security and allow multiple users to use the same IP address, the router hides your IP address and replaces it with another.

## WebRTC architecture

Initially, WebRTC was developed as a peer-to-peer technology. Accordingly, a significant portion of the development has centered around the client device.

Today, we can define three main WebRTC architectures: peer-to-peer, multipoint conferencing units, and selective forwarding units. Each of them has its own characteristics, advantages, and disadvantages in use.

## Websocket alternative 2020

When it comes to the development of a web application that uses data in real-time, companies are faced with the question: how to deliver data from server to client? The standard approach is through WebSockets. Are there any decent alternatives? Yes, there are in fact.

First of all, it is important to determine the submission mechanism that you plan to use. There are two options: client pull (the website in the browser requests information from the server) and server push (the server sends relevant data to the website). In 2020, the following methods are used for this purpose:

1. WebSockets (server push);
2. Long/short polling (client pull);
3. Server-Sent Events (server push).

Let’s take a look at the latter two.

### Client Pull

The client makes a data request to the server. Without this action, the server remains inactive for a certain time or:

* if there are changes registered, it sends the received result and closes the request;
* if they are absent, as well as if the server has been inactive for a long time, the client receives a notification about the absence of data.

AJAX requests operate over the HTTP protocol: by default, requests to the same domain are multiplexed. This mechanism has a number of issues:

### Server Push

The main difference compared to the previous option is that you get one connection and keep the flow of events that goes through it. Long polling creates a new connection for every request.

SSE has only one similarity to the WebSockets protocol — it runs in real-time. However, the mainstream of data comes from the server to the client. The protocol is unidirectional, that is, the client cannot send messages through it to the server. This feature provokes a slight delay when loading on mobile devices (up to a second long).

Specifics of Server Push (SSE):

1. For a continuous connection, no special protocol is used — the processes occur through standard HTTP requests. Multiplexing is carried out over the HTTP/2 protocol;
2. If the connection is broken, EventSource will automatically try to resume it;
3. In case of an interrupted connection, the client sends the last unique identifier known to him. This allows the server to determine how many messages were missed by the client, as well as deliver the missed messages on the next connection.

## Summary

WebRTC is designed for high-performance media transfer. WebRTC web applications run through a service or transport, through which they exchange network and media data. WebSocket, by contrast, is for communication between client and server.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
