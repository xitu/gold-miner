> * 原文地址：[WebSockets vs Long Polling](https://www.ably.io/blog/websockets-vs-long-polling/)
> * 原文作者：[Kieran Kilbride-Singh](https://www.ably.io/blog/author/kieran/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/websockets-vs-long-polling.md](https://github.com/xitu/gold-miner/blob/master/TODO1/websockets-vs-long-polling.md)
> * 译者：[Jalan](http://jalan.space)
> * 校对者：[linxiaowu66](https://github.com/linxiaowu66), [sunui](https://github.com/sunui)

# WebSockets 与长轮询的较量

![WebSockets 与长轮询的较量](https://ik.imagekit.io/ably/ghost/prod/2019/06/websockets-vs-long-polling-1.jpg?tr=w-1520)

**我们要如何在两者之间做出选择？**

有时候，当信息一旦准备就绪，我们就需要从服务器获取它们。而我们通常使用的 AJAX 请求/响应模式无法为这类应用场景保持请求连接的建立。相反地，我们需要一种基于推送的方法，例如 WebSockets 协议、长轮询、服务器推送事件（SSE）以及最近的 HTTP2 服务器推送。在本文中，我们将对比两种方法：WebSockets 与长轮询。

## 长轮询概述

1995 年，[网景公司](https://en.wikipedia.org/wiki/Netscape) 聘请 Brendan Eich 为 Netscape Navigator 实现脚本功能，经过 10 天的时间，JavaScript 诞生了。作为一门编程语言，与现代 JavaScript 语言相比，那时诞生的 JavaScript 功能非常有限，而它与浏览器文档对象模型（DOM）的交互就更加有限了。JavaScript 主要用于提供有限的增强功能来丰富浏览器文档的使用性。例如，在浏览器中验证表单、将动态 HTML 轻便地插入现有文档。

![](https://ik.imagekit.io/ably/ghost/prod/2019/06/long-polling-f6e3a73a589fe25d7c7b622a8487a2e8a27a11f00b22b574abb021fbcd7ac2db.png?tr=w-1520)

随着 [浏览器大战](https://en.wikipedia.org/wiki/Browser_wars) 的升温，微软的 Internet Explorer 版本到达了版本 4 及以上，对浏览器强大特性集的争夺战导致微软在 Internet Explorer 中引入了一个新特性，这一特性最终成为了 [XMLHttpRequest](https://xhr.spec.whatwg.org/)。十多年来，所有浏览器都普遍支持 XMLHttpRequest。

[长轮询](https://en.wikipedia.org/wiki/Push_technology#Long_polling) 本质上是原始轮询技术的一种更有效的形式。向服务器发送重复请求会浪费资源，因为必须为每个新传入的请求建立连接，必须解析请求的 HTTP 头部，必须执行对新数据的查询，并且必须生成和交付响应（通常不提供新数据）。然后必须关闭连接并清除所有资源。长轮询是一种服务器选择尽可能长的时间保持和客户端连接打开的技术，仅在数据变得可用或达到超时阙值后才提供响应，而不是在给到客户端的新数据可用之前，让每个客户端多次发起重复的请求。

## WebSockets 概述

大约在 2008 年中期，开发人员 [Michael Carter](https://en.wikipedia.org/wiki/Michael_Carter_(entrepreneur)) 和 [Ian Hickson](https://en.wikipedia.org/wiki/Ian_Hickson) 特别敏锐地感觉到在实现真正健壮的东西时使用 Comet 的痛苦和局限性。通过 [在 IRC](https://krijnhoetmer.nl/irc-logs/whatwg/20080618#l-1145) 和 [W3C 邮件列表](https://lists.w3.org/Archives/Public/public-whatwg-archive/2008Jun/0165.html) 上的合作，他们制定了一项计划，在网络上引入了现代实时双向通信的新标准，从而 [创造了“WebSocket”这个名字](https://lists.w3.org/Archives/Public/public-whatwg-archive/2008Jun/0186.html)。

![](https://ik.imagekit.io/ably/ghost/prod/2019/06/websocks.png?tr=w-1520)

这个想法进入了 W3C HTML 草案标准，不久之后，Michael Carter 写了一篇文章，[在 Comet 社区中介绍了 WebSockets](http://cometdaily.com/2008/07/04/html5-websocket/)。2010 年，谷歌的 Chrome 4 成为第一款完全支持 WebSockets 的浏览器，其他浏览器供应商也在接下来的几年中纷纷效仿。2011 年，[RFC 6455 —— WebSocket 协议](https://tools.ietf.org/html/rfc6455) —— 在 IETF 网站上发布。

简而言之，[WebSockets](https://en.wikipedia.org/wiki/WebSocket) 是一个构建在设备 [TCP/IP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) 协议栈之上的传输层。其目的是向 Web 开发人员提供本质上尽可能接近原始的 TCP 通信层，同时添加一些抽象概念，以消除 Web 工作中存在的一些阻力。它们还满足了这样一个事实：即网络具有额外需要考虑的安全因素，这些安全因素必须考虑在内以保护消费者和服务提供商。

## 长轮询的利与弊

**优点**

* 长轮询是在 XMLHttpRequest 之后实现的，它几乎得到了设备的普遍支持，因此通常很少需要有进一步的备选方案。但是，在必须处理异常的情况下，或者在服务器可查询新数据但不支持长轮询（更不用说其他更现代的技术标准）的情况下，基本轮询有时仍然有些用处，并且可以使用 XMLHttpRequest 或通过 JSONP 利用简单的 HTML 脚本标签。
    

**缺点**

* 长轮询大量占据服务器资源。
* [可靠的消息排序](https://support.ably.io/support/solutions/articles/3000044641) 可能是长轮询的一个问题，因为来自同一个客户端的多个 HTTP 请求可能同时运行。举个例子，如果一个客户端打开两个浏览器选项卡，使用相同的服务器资源，并且客户端应用程序正在将数据持久化到本地存储区（如 localStorage 或 IndexedDb），则无法保证重复数据不会被多次写入。
* 根据服务端实现的不同，一个客户端对消息的确认接收也可能导致另一个客户端根本不会收到预期的消息，因为服务端可能错误地认为客户端已经收到了它所期望的数据。

## WebSockets 的利与弊

**优点**

* WebSockets 保持一个唯一的连接打开，同时消除长轮询的延迟问题。
* WebSockets 通常不使用 XMLHttpRequest，因此，当我们每次需要从服务器获取更多的信息时，无需发送头部数据。反过来说，这又减少了数据发送到服务器时需要付出的高昂的数据负载代价。
    

**缺点**

* 当连接终止时，WebSockets 无法自动恢复连接 —— 这是需要你自己实现的部分，也是导致存在许多 [客户端库](https://www.ably.io/download) 的原因。
* 早于 2011 年的浏览器无法支持 WebSocket 连接 —— 但这一点越来越无关紧要。

## 为什么 WebSocket 协议是更好的选择？

一般来说，WebSockets 会是更好的选择。

长轮询在服务器上占用更多的资源，而 WebSockets 在服务器上占用的空间很少。长轮询还需要在服务器与许多设备之间进行多次通信。而不同的网关对于一个常规连接允许保持打开的时间有不同的标准。如果连接打开时间太久，其进程可能会被杀死，甚至当这个进程正在处理一些重要的事情时。

使用 WebSockets 构建应用的理由：

* 全双工异步消息传送。换句话说，客户端和服务器都可以独立地相互传输消息。
* WebSockets 无需任何配置即可通过大多数防火墙。
* 良好的安全模式（基于原始的安全模式）。

## WebSockets 开源解决方案

WebSocket 库有两个主要分类：一种只实现协议部分，把其余部分留给开发人员实现，另一种构建在协议之上，它们具有实时消息通信应用程序通常需要的各种附加功能，例如丢失连接的恢复，发布/订阅频道、身份认证、授权等。

后者通常要求开发人员在客户端使用自己的库，而不仅仅是使用浏览器提供的原始 WebSocket API。因此，确保你对所选择方案的工作方式和所提供的服务感到满意就变得非常重要。一旦将所选择的解决方案集成到体系结构里，你可能会发现自己陷入了该方案的工作方式中，任何可靠性、性能和可扩展性方面的问题都可能会反过来影响你。

让我们从第一类说起。

**注意: 以下所有内容均是开源库。**  

**ws**

[ws](https://github.com/websockets/ws) 是一个“简单易用、快速且经过全面测试的 WebSocket 客户端和 Node.js 服务器”。它绝对是一个准系统级别的实现，旨在完成执行协议上所有艰难的工作，但是恢复连接、发布/订阅等附加功能，必须由你自己来管理。

客户端 (绑定前的浏览器):

```
const WebSocket = require('ws');
const ws = new WebSocket('ws://www.host.com/path');
ws.on('open', function open() {
    ws.send('something');
});

ws.on('message', function incoming(data) {
    console.log(data);
});
```

服务端（Node.js）：

```
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });
wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
    console.log('received: %s', message);
    });
    ws.send('something');
});
```

**μWebSockets**

[μWS](https://github.com/uNetworking/uWebSockets) 是 [ws](https://www.ably.io/concepts/websockets#ws) 的直接替代品，它特别注重性能和稳定性。据我所知，μWS 离最快的 WebSocket 服务器仅有一步之遥。[SocketCluster](https://www.ably.io/concepts/websockets#socketcluster) 就是由它驱动的，关于 SocketCluster 我将在下面说到。

由于作者出于哲学上的原因试图将 μWS 从 NPM 中提取出来，近来围绕 μWS 引发了一些争议，但 μWS 最新的可运行版本仍然在 NPM 上，并且可以从 NPM 安装时明确指定该版本。也就是说，作者正在开发 [一个新版本](https://github.com/uNetworking/v0.15)，其附带的 [node.js 绑定](https://github.com/uNetworking/uWebSockets-node) 也在 [开发中](https://github.com/uNetworking/uWebSockets-node/issues/2)。

```
var WebSocketServer = require('uws').Server;
var wss = new WebSocketServer({ port: 3000 });
function onMessage(message) {
    console.log('received: ' + message);
}

wss.on('connection', function(ws) {
    ws.on('message', onMessage);
    ws.send('something');
});
```

## 客户端 —— 在浏览器中使用 WebSockets

WebSocket API 定义于 [WHATWG HTML Living Standard](https://html.spec.whatwg.org/multipage/web-sockets.html#network)，它使用起来非常简单。构建 WebSocket 只需要一行代码：

JS

```
const ws = new WebSocket('ws://example.org');
```

注意，在通常使用 HTTP 方案的地方使用 ws。在通常使用 https 方案的地方，还可以选择 wss。这些协议是和 WebSocket 规范一起引入的，旨在表示一个 HTTP 连接，该连接中包括一个升级连接以使用 WebSockets 的请求。

创建 WebSocket 对象本身并没有太大的作用。连接是异步建立的，所以在发送任何消息之前，你必须监听握手的完成情况，还需要一个从服务器接收消息的监听器：

```
ws.addEventListener('open', () => {
    // 向 WebSocket 服务器发送消息
    ws.send('Hello!');
});

ws.addEventListener('message', event => {
// `event` 对象是一个典型的 DOM 事件对象，
// 服务器发送的消息数据存储在 `data` 属性中
    console.log('Received:', event.data);
});
```

还有错误事件和关闭事件。当连接终止时，WebSockets 不会自动恢复连接 —— 这需要你自己实现，这也是存在许多客户端库的原因之一。虽然 WebSocket 类简单易用，但它实际上只是一个基本的构建块。对于不同子协议或附加功能的支持，例如消息传输通道，必须单独实现。

## 长轮询 —— 开源解决方案

大多数库不会单独使用长轮询，因为长轮询通常与其他传输策略一起使用，或作为其他传输策略的备选方案，或是当长轮询不起作用时，将其他传输策略作为备选。在 2018 年及以后，独立的长轮询库尤其罕见，面对更先进的替代品对传输的广泛支持，长轮询这种技术很快就失去了相关性。不过，你可以将它作为传输的备选方案，以下是一些不同语言的可选项：

* **Go:** [**golongpoll**](https://github.com/jcuga/golongpoll)
* **PHP:** [**php-long-polling**](https://github.com/panique/php-long-polling)
* **Node.js:** [**Pollymer**](https://github.com/fanout/pollymer)
* **Python:** [**A simple COMET server**](https://github.com/jedisct1/Simple-Comet-Server)

## Ably、WebSockets 与长轮询

大多数 [Ably 的客户端库 SDK](https://www.ably.io/download) 使用 [WebSocket](https://www.ably.io/documentation/concepts/websockets) 建立与 Ably 的实时连接，然后对包括身份验证在内的所有其他 REST 操作使用简单的 HTTP 请求。

但是，客户端库 SDK（例如我们的 [Javascript 浏览器库](https://github.com/ably/ably-js)）被设计为根据可用浏览器和连接选择可用且最佳的传输方式。通过支持附加的传输方式，使其能够回退到最低的公共标准，Ably 确保现在几乎所有的浏览器都能与 Ably 建立实时连接。我们的 Javascript 浏览器库目前支持以下传输方式，按照性能从优到劣排列：

* [WebSockets](https://www.ably.io/documentation/concepts/websockets) ([截止 2017 年 12 月，全球 94% 的浏览器均支持](http://caniuse.com/#feat=websockets))
* XHR 流
* XHR 轮询
* JSONP 轮询

在实现对 WebSocket 的支持且将长轮询作为备选方案时，需要涉及到很多方面 —— 不仅涉及客户端和服务器实现细节，还涉及对其他传输方式的支持，以确保对不同客户端环境的可靠支持，也涉及到更广泛的关注点，例如 [身份验证和授权](https://www.ably.io/documentation/core-features/authentication?utm_source=websockets&utm_medium=concepts)、[保证消息可交付](https://support.ably.io/a/solutions/articles/3000044640)、[可靠的消息排序](https://support.ably.io/a/solutions/articles/3000044640)、[历史消息保留](https://www.ably.io/documentation/core-features/history?utm_source=websockets&utm_medium=concepts)，还有 [更多方面](https://www.ably.io/documentation/)。

## 参考资料与扩展阅读

* [长轮询](https://www.ably.io/concepts/long-polling)
* [WebSockets](https://www.ably.io/concepts/websockets)
* [Ably 是如何工作的](https://www.ably.io/documentation/how-ably-works#any-internet-device)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
