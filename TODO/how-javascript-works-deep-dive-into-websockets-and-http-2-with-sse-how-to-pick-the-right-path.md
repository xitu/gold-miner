> * 原文地址：[How JavaScript works: Deep dive into WebSockets and HTTP/2 with SSE + how to pick the right path](https://blog.sessionstack.com/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path-584e6b8e3bf7)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[NeoyeElf](https://github.com/NeoyeElf) [athena0304](https://github.com/athena0304)

# JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择

欢迎来到旨在探索 JavaScript 以及它的核心元素的系列文章的第五篇。在认识、描述这些核心元素的过程中，我们也会分享一些当我们构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-4-eventloop-intro) 的时候遵守的一些经验规则，这是一个轻量级的 JavaScript 应用，其具备的健壮性和高性能让它在市场中保有一席之地。

如果你错过了前面的文章，你可以在这儿找到它们：

1.  [对引擎、运行时和调用栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2.  [深入 V8 引擎以及 5 个写出更优代码的技巧](https://juejin.im/post/5a102e656fb9a044fd1158c6)
3.  [内存管理以及四种常见的内存泄漏的解决方法](https://juejin.im/post/59ca19ca6fb9a00a42477f55)
4.  [事件循环和异步编程的崛起以及 5 个如何更好的使用 async/await 编码的技巧](https://juejin.im/post/5a221d35f265da43356291cc)

这一次，我们将深入到通信协议中，去讨论和对比 WebSockets 和 HTTP/2 的属性和构成。我们将快速比较 WebSockets 和 HTTP/2，并在最后，针对网络协议，分享一些如何选择这2种技术的想法。

#### 简介

现在，富交互 web 应用已然司空见惯了。由于 internet 经过了漫长的发展，这一点看起来也不足为奇了。

最初，internet 的建立不是为了支持这样动态的、复杂的 web 应用程序。它只被认为是一个 HTML 页面的集合，页面间能够链接到其他页面，从而构成了一个 “web” 这样一个信息载体的概念。internet 中每个事物都是由 HTTP 中的请求/响应（request/response）范式构建而成。一个客户端加载了一个页面后将不会再发生任何事，除非用户点击并跳转到了下一页。

2005 年左右，AJAX 技术的引入让许多人开始探索客户端和服务器间**双向通信（bidirectional）**的可能。然而，所有的 HTTP 通信都是由客户端掌控的，这要求用户交互式地或者周期轮询式地去从服务器拉取新数据。

#### 让 HTTP 成为 “双向通信的”

能够让服务器“主动地”发送数据给客户端的技术已经出现了一段时间了，例如 [“Push”](https://en.wikipedia.org/wiki/Push_technology) 和 [“Comet”](http://en.wikipedia.org/wiki/Comet_%28programming%29)。

为了制造出服务器主动给客户端发送数据的假象，最常用的一个 hack 是**长轮询（long polling）**。通过长轮询，客户端打开了一个到服务端的 HTTP 连接，该连接会一直保持直到有数据返回。无论什么时候服务器有了需要被送达的数据，它都会将数据作为一个响应传输到客户端。

让我们看看一个非常简单的长轮询代码片段长什么样：

```javascript
(function poll(){
   setTimeout(function(){
      $.ajax({ 
        url: 'https://api.example.com/endpoint', 
        success: function(data) {
          // 使用 `data` 来做一些事
          // ...

          // 递归地开始下一次轮询
          poll();
        }, 
        dataType: 'json'
      });
  }, 10000);
})();
```

这是一个自执行函数，它将自动运行。其设置了一个 10 秒的间隔，当一个异步请求发送完成后，在其回调方法中又会再次调用这个异步请求`。

其他一些技术还涉及到了 [Flash](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/Socket.html) 、 XHR multipart request  以及 [htmlfiles](http://cometdaily.com/2007/12/27/a-standards-based-approach-to-comet-communication-with-rest/) 。

所有的这些方案都面临了相同的问题：它们都是建立在 HTTP 上的，这就使得它们不适合那些需要低延迟的应用。例如浏览器中的第一人称射击这样实时性要求高的在线游戏。

#### WebSockets 简介

[WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) 规范定义了一个 API 用来建立一个 web 浏览器和服务器之间的 “socket” 通信。通俗点说，客户端和服务器间将建立一个持续的连接，这让双方都能在任何时候发送数据给彼此。

![](https://cdn-images-1.medium.com/max/800/1*a4lA5FYDkjA9mv53NPKtOg.png)

客户端通过一个被称为 WebSocket **握手（handshake）**的过程建立一个 WebSocket 连接。该过程开始于客户端发送了一个普通的 HTTP 请求到服务器。一个 `Upgrade` header 包含在了请求头中，它告诉了服务器现在客户端想要建立一个 WebSocket 连接。

让我们看看在客户端如何打开一个 WebSocket 连接：

```javascript
// 创建一个具有加密连接的 WebSocket
var socket = new WebSocket('ws://websocket.example.com');
```

> WebSocket URL 使用了 `ws` scheme。也可以使用 `wss` 来服务于安全的 WebSocket 连接，这类似于 `HTTPS`。

这个 scheme 仅只是启动了一个进程来打开客户端到 websocket.example.com 的 WebSocket 连接。

下面是初始化请求头的简单示例：

```http
GET ws://websocket.example.com/ HTTP/1.1
Origin: http://example.com
Connection: Upgrade
Host: websocket.example.com
Upgrade: websocket
```

如果服务器支持 WebSocket 协议，它将同意进行协议更新，并通过响应头中的 `Upgrade` 同客户端通信。

让我们看看在 Node.js 中这是如何实现的：

```javascript
// 我们使用这个 WebSocket 实现： https://github.com/theturtle32/WebSocket-Node
var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
  // 处理 HTTP 请求。
});
server.listen(1337, function() { });

// 创建 server
wsServer = new WebSocketServer({
  httpServer: server
});

// WebSocket server
wsServer.on('request', function(request) {
  var connection = request.accept(null, request.origin);

  // 下面这个回调方法很重要，我们将在这里处理所有来自用户的消息
  connection.on('message', function(message) {
      // 处理 WebSocket 消息
  });

  connection.on('close', function(connection) {
    // 连接关闭时进行的操作
  });
});
```

在连接建立以后，服务器通过响应头的 `Upgrade` 进行回复：

```http
HTTP/1.1 101 Switching Protocols
Date: Wed, 25 Oct 2017 10:07:34 GMT
Connection: Upgrade
Upgrade: WebSocket
```

一旦连接建立，客户端下 WebSocket 实例的 `open` 事件将会被触发：

```javascript
var socket = new WebSocket('ws://websocket.example.com');

// 当 WebSocket 被打开后，显示一条已连接消息。
socket.onopen = function(event) {
  console.log('WebSocket is connected.');
};
```

现在，握手完成，最初的一个 HTTP 连接被一个使用相同底层 TCP/IP 连接的 WebSocket 连接所取代。自此，任何一方都可以开始发送数据了。

通过 WebSockets，你可以尽情地传输数据，而不会遇到使用传统 HTTP 请求时的瓶颈。使用 WebSocket 传输的数据被称作**消息（messages）**，每一条消息都包含了一个或多个**帧（frames）**，它们承载了你要发送的数据（payload）。为了保证消息在送达客户端以后能够被正确解析，每一帧都会在头部填充关于 payload 的 4-12 个字节。基于帧的消息系统能够减少非 payload 数据的传输数量，从而大幅减少延迟。

**注意**：需要留意的是，只有当所有帧都到达，并且原始消息 payload 也被解析，客户端才会接受新消息通知。

#### WebSocket URLs

前文中，我们简要介绍了 WebSocket 引入了一个新的 URL scheme。实际上，其引入了两个新的 schema（协议标识符）：`ws://` 和 `wss://`。

WebSocket URLs 则有一个指定 schema 的语法。WebSocket URLs 较为特别，它们并不支持锚点（anchor），例如 `#sample_anchor`。

WebSocket 风格的 URL 与 HTTP 风格的 URL 具有相同的规则。`ws` 不会进行加密编码，并且默认端口是 80。而 `wss` 则要求 TLS 编码，且默认端口是 443。

#### 成帧协议（Framing Protocal）

让我们深入到成帧协议中。下面是 [RFC](https://tools.ietf.org/html/rfc6455#page-27) 提供给我们的帧格式：

```
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M| Payload len |    Extended payload length    |
|I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
|N|V|V|V|       |S|             |   (if payload len==126/127)   |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
|     Extended payload length continued, if payload len == 127  |
+ - - - - - - - - - - - - - - - +-------------------------------+
|                               |Masking-key, if MASK set to 1  |
+-------------------------------+-------------------------------+
| Masking-key (continued)       |          Payload Data         |
+-------------------------------- - - - - - - - - - - - - - - - +
:                     Payload Data continued ...                :
+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
|                     Payload Data continued ...                |
+---------------------------------------------------------------+
```

在 RFC 所规定的 WebSocket 版本中，每个包只有一个头部，但是这个头部非常复杂。现在我们解释下它的组成部分：

*   `fin` （1 bits）：指出了当前帧是消息的最后一帧。绝大多数时候消息都能被一帧容纳，所以这一个 bit 通常都会被设置。实验显示 FireFox 将会在 32K 之后创建第二个帧。
*   `rsv1`、`rsv2`、`rsv3`（每个都是 1 bits）：除非扩展协议为它们定义了非零值的含义，否则三者都应当被设置为 0。如果收到了一个非零值，并且没有任何没有任何扩展协议定义了该非零值的意义，那么接收端将会使这次连接失败。
*   `opcode`（4 bits）：说明了帧的含义。下面是一些经常使用的取值：

​       `0x00`：当前帧继续传输上一帧的 payload。

​       `0x01`：当前帧含有文本数据。

​       `0x02`：当前帧含有二进制数据。

​       `0x08`：当前帧终止了连接。
​       `0x09`：当前帧为 ping。
​       `0x0a`：当前帧为 pong。

​    （如你所见，还有很多取值未被使用，未来它们会被用作表示其他含义。）

* `mask`（1 bits）：指示了连接是否被掩码。就目前来说，每条从客户端到服务器的消息都必须经过掩码处理，否则，按规定需要终止连接。

* `payload_len`（7 bits）：payload 长度。WebSocket 的帧长度区间为：

  如果是 0–125，则直接指示了 payload 长度。如果是 126，则意味着接下来两个字节将指明长度，如果是 127，则意味着接下来 8 个字节将指明长度。所以，一个 payload 的长度将可能是 7 bit、16 bit 或者 64 bit 以内。

*   `masking-key`（32 bits）：所有由客户端发送给服务器的帧都被一个包含在帧里面的 32 bit 的值进行了掩码处理。
*   `payload`：极大可能被掩码了的实际数据，由 `payload_len` 标识了长度。

为什么 WebSocket 是基于帧（frame-based）的，而不是基于流（stream-based）的？我和你一样都不清楚，我也苛求学到更多，如果你对此有任何见解，可以在文章下面评论留言。当然，也可以加入到 [HackerNews 上这个主题的讨论中](https://news.ycombinator.com/item?id=3377406)。

#### 帧里面的数据

如上文所述，一段数据可以被分片为多个帧。传输数据的第一帧中通过一个 opcode 指出了需要被传输的数据是什么类型。这是非常必要的，因为当规范出台时，JavaScript 尚未对二进制数据提供支持。`0x01` 指出了数据是 utf-8 编码的文本数据，`0x02` 指出了数据是二进制数据。大多数人们会在传输 JSON 时选择文本 opcode。当你发送二进制数据时，数据会在浏览器中以一种特殊的 [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) 形式展现。

 通过 WebSocket 发送数据的 API 非常简单：

```javascript
var socket = new WebSocket('ws://websocket.example.com');
socket.onopen = function(event) {
  socket.send('Some message'); // Sends data to server.
};
```

当 WebSocket 开始接收数据（在客户端），一个 `message` 事件就会被触发。该事件包含了一个叫做 `data` 的属性可以被用来访问消息内容。

```javascript
// 处理服务器送来的数据。
socket.onmessage = function(event) {
  var message = event.data;
  console.log(message);
};
```

通过 Chrome 开发者工具中的 Network Tab，你可以很容易地查看 WebSocket 连接中的每一帧数据。

![](https://cdn-images-1.medium.com/max/800/1*Sz4wI2ukt91vRrgf8UonWw.png)

#### 分片（Fragmentation）

payload 可以被划分为多个独立的帧。接收端被认为能够缓存这些帧，直到某个帧的 `fin` 位被设置。所以你可以用 11 个包传输 “Hello World” 字符串，每个包大小为 6（头部长度）+ 1 字节。对于控制包（control package）来说，分片则是不被允许的。然而，你被要求能够处理[交错的](https://en.wikipedia.org/wiki/Interleaving_%28data%29)控制帧。这是为了应付 TCP 包是以任意序列到达的状况。

合并各个帧的逻辑大致如下：

*   收到第一帧
*   记住 opcode
*   连接各个帧的 payload 直到 `fin` 被设置
*   断言每个包的 opcode 都是 0

分片的主要目的在于当消息传输开始时，允许传输一个未知大小的消息。通过分片技术，服务器可以选择合理的大小的 buffer，并在 buffer 充满时，写入一个分片到网络中。分片技术的次要用例则是多路复用（multiplexing），让某个逻辑信道上的大消息占据整个输出信道是不可取的，因此多路复用需要能够支持将消息划分为若干小的分片，从而更好的共享输出信道。

#### 什么是心跳机制？

握手完成之后的任意时刻，客户端或者服务器都能够发送一个 ping 到对面。当 ping 被接收以后，接收方必须尽快回送一个 pong。这就是一次心跳，你可以通过这个机制来确保客户端仍处于连接状态。

一个 ping 或者 pong 只是普通的一个帧，但它们是**控制帧（control frame）**。Ping 的 opcode 为 `0x9`，pong 则为 `0xA`。当你收到了一个 ping，你回送的 pong 需要和 ping 具有一样的 payload data（ping 和 pong 允许的最大 payload 长度为 **125**）。如果你收到了没有和一个 ping 结对的 pong 的话，直接忽略即可。

心跳机制是非常有用的。例如负载均衡这样的一些服务可能会终止掉空闲连接，因此你需要利用心跳机制观测连接状况。另外，收信方是无法知道远端连接是否终止。只有下一次发送消息时才能知道远端是否被终止。

#### 错误处理

你能够通过监听 `event` 事件处理任何发生的错误。

就像下面这样：

```javascript
var socket = new WebSocket('ws://websocket.example.com');

// 处理任何发生的错误。
socket.onerror = function(error) {
  console.log('WebSocket Error: ' + error);
};
```

#### 关闭连接

为了关闭连接，客户端或服务端都可以发送一个 opcode 为 `0x8` 的控制帧来关闭连接。一旦收到这样一帧，另一端就需要发送一个关闭帧作为回应。接着发送端便会关闭连接。关闭连接后收到的任何数据都会被丢弃。

下面的代码展示了如何从客户端初始化 WebSocket 连接的关闭：

```javascript
// 如果连接是打开的，则关闭
if (socket.readyState === WebSocket.OPEN) {
    socket.close();
}
```

通过监听 `close ` 事件，你可以在在连接关闭后进行一些“善后”工作：

```javascript
// 做一些必要的清理
socket.onclose = function(event) {
  console.log('Disconnected from WebSocket.');
};
```

服务器也必须监听 `close` 事件，做一些它需要的处理工作：

```javascript
connection.on('close', function(reasonCode, description) {
    // 连接关闭了
});
```

#### WebSockets 和 HTTP/2 的对比

即便 HTTP/2 有很多优点，但其也无法完全替代现有的 push/streaming 技术。

对 HTTP/2 的首要认识是知道它不是 HTTP 的完全替代。HTTP verb、状态码以及大多数头部内容都仍然保持了一致。HTTP/2 着眼于提高数据的传输效率。

现在，如果我们对比 HTTP/2 和 WebSocket，会发现二者许多相似之处：

|                       | HTTP/2                      | WebSocket |
| --------------------- | --------------------------- | --------- |
| 头部（Headers）           | 压缩（HPACK）                   | 不压缩       |
| 二进制数据（Binary）         | Yes                         | 二进制或文本数据  |
| 多路复用（Multiplexing）    | Yes                         | Yes       |
| 优先级技术（Prioritization） | Yes                         | Yes       |
| 压缩（Compression）       | Yes                         | Yes       |
| 方向（Direction）         | Client/Server + Server Push | 双向的       |
| 全双工（Full-deplex）      | Yes                         | Yes       |

正如我们之前提到的，HTTP/2 引入了 [Server Push](https://en.wikipedia.org/wiki/Push_technology?oldformat=true) 来允许服务器主动地发送资源到客户端缓存中。但是，并不允许直接发送数据到客户端应用程序中。服务器推送的内容只能被浏览器处理，而不是客户端应用程序代码，这意味着应用中没有 API 能够感知到推送。

这也让 Server-Sent Events（SSE）变得很有用。当客户端和服务器的连接建立后，SSE 这个机制能够让服务器异步地推送数据到客户端。之后，服务器随时都可以在准备好后发送数据。这可以被看作是单向的 [发布-订阅](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) 模型。SSE 还提供了一个叫做 EventSource 的标准 JavaScript 客户端 API，这个 API 已经被大多数现代浏览器作为 [W3C](https://www.w3.org/TR/eventsource/) 所制定的HTML5 标准的一部分所实现了。对于那些不支持 [EventSource API](http://caniuse.com/#feat=eventsource) 的浏览器来说，这些 API 也能被轻易地 polyfill。

由于 SSE 是基于 HTTP 的，所以它天然亲和 HTTP/2，因此可以组合二者，以吸取各自精华：HTTP/2 通过多路复用流来提高传输层的效率，SSE 则为客户端应用程序提供了接收推送的 API。

为了完整地解释流和多路复用是什么，让我们先看看 IETF 对此的定义：

“流（stream）” 是一个独立的、双向的帧序列，这些帧在处于 HTTP/2 连接中的客户端和服务器之间交换。其主要特征是一个单个 HTTP/2 连接可以包含多个同时打开的流，任意一端都可以交错地使用这些流中的帧。

![](https://cdn-images-1.medium.com/max/800/1*pSh7IORJoUXbwCjyJ7fM9A.png)

要记住 SSE 是基于 HTTP 的。这意味着通过使用 HTTP/2，不仅能够将 SSE 流交错地送入到一个 TCP 连接中去，也能完成 SSE 流（服务器向客户端推送）的合并的和客户端请求（客户端到服务器）的合并。得益于 HTTP/2 和 SSE，我们现在得到了一个具有简洁 API 的 HTTP 双向连接，这让应用代码能监听到服务器推送。曾几何时，双向通信能力的缺失成为了 SSE 相对于 WebSocket 的主要缺陷。但 HTTP/2 让这不再成为问题。这使得开发者能够回归到基于 HTTP 的通信方式，而不再使用 WebSocket。

#### 如何在 WebSocket 和 HTTP/2 中作出选择？

在 HTTP/2 + SSE 的大浪潮中，WebSocket 仍将保有一席之地，因为它已经被广泛使用，在一些非常特殊的使用场景下，相较于 HTTP/2，其优势在于能够以更少的开销（如头部信息）来构建应用的双向通信能力。

倘若你想要构建一个端到端之间需要传输大量消息的大型多人在线游戏，WebSocket 将非常非常适合。

一般而言，当你需要真正的**低延迟**，希望客户端和服务器能有接近实时的连接，就使用 WebSocket。这就可能需要你重新审视和构建你的服务端应用，并聚焦到事件队列这样的技术上。

如果你的使用场景是展示实时市场新闻、市场数据、或是聊天应用等等，那么 HTTP/2 + SSE 能让你继续受益于 HTTP 世界时，还能享受到高效的双向通信通道：

* WebSocket 在处理浏览器兼容性时让人头痛，因为其将 HTTP 连接更新到了一个完全不同协议，因此无法再用 HTTP 做任何事。
* 扩展性和安全性：Web 组件（防火墙、入侵检测、负载均衡）是基于 HTTP 来构建、维护和配置的，考虑到弹性伸缩、安全性和可扩展，那些大型/重要的应用会选择使用 HTTP。

接下来，你可以看下几种技术的浏览器支持状况。首先看到 WebSocket：

![](https://cdn-images-1.medium.com/max/800/1*YFr59cEF2qxzjjleebvbcQ.png)

WebSocket 兼容性问题现在好多了，是吧？

HTTP/2 则有些尴尬：

![](https://cdn-images-1.medium.com/max/800/1*C1VWSKOx89vqdiSiflDRJw.png)

*   TLS-only （这倒不算坏）
*   只有在 Windows 10 系统下才对 IE 11 部分支持
*   Safari 支持则需要系统是 OSX 10.11+
*   只有在你可以通过 ALPN（你的服务器需要支持的扩展）进行协商时，才能支持 HTTP/2

SSE 的支持则更好一些：

![](https://cdn-images-1.medium.com/max/800/1*9ryMUEZhtbTg7lECHVz0fw.png)

只有 IE/Edge 没有提供支持（Opera Mini 既不支持 SSE，也不支持 WebSocket，我们把它排除在外）。但在 IE/Edge 中，有一些正式的 polyfill 能够帮助支持 SSE。

#### 在 SessionStack 中，我们是如何作出决策的

我们在  [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-5-websockets-outro) 中按需使用了 WebSocket 和 HTTP。一旦你将 SessionStack 集成到你的应用中，它就开始记录所有的 DOM 改变、用户交互、JavaScript 异常、堆栈跟踪、失败的网络请求以及 debug 信息，允许你通过视频来复现问题，从而了解到用户到底做了什么。SessionStack 是完全**实时的**并且不会对你的应用造成任何的性能影响。

这意味着，当用户在使用浏览器时，你可以实时地观察用户的行为。在这个场景下，由于不需要双向通信（只是服务器将数据流发送到浏览器），所以我们选择了 HTTP。WebSocket 在这个场景下则显得大材小用了，难于维护和扩展。

然而集成到你应用中的 SessionStack 库却是使用的 WebSocket（如果支持的话，否则会退回到 HTTP）。其批量发送数数据到我们服务器，这也是一个单向通信。这个场景下，我们仍选择 WebSocket 是因为其为产品蓝图中的一些需要双向通信的特性提供了支持。

尝试使用 SessionStack  来了解和重现你 web 应用中存在的技术或者体验问题，我们为你提供了一个免费计划让你 [快速开始](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-5-websockets-getStarted)。

![](https://cdn-images-1.medium.com/max/800/1*kEQmoMuNBDfZKNSBh0tvRA.png)

#### 参考资料

* [http://lucumr.pocoo.org/2012/9/24/websockets-101/](http://lucumr.pocoo.org/2012/9/24/websockets-101/)
* [http://blog.teamtreehouse.com/an-introduction-to-websockets](http://blog.teamtreehouse.com/an-introduction-to-websockets)
* [https://www.infoq.com/articles/websocket-and-http2-coexist](https://www.infoq.com/articles/websocket-and-http2-coexist)
* [https://tools.ietf.org/html/rfc6455](https://tools.ietf.org/html/rfc6455)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
