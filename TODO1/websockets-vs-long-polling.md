> * 原文地址：[WebSockets vs Long Polling](https://www.ably.io/blog/websockets-vs-long-polling/)
> * 原文作者：[Kieran Kilbride-Singh](https://www.ably.io/blog/author/kieran/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/websockets-vs-long-polling.md](https://github.com/xitu/gold-miner/blob/master/TODO1/websockets-vs-long-polling.md)
> * 译者：
> * 校对者：

# WebSockets vs Long Polling

![WebSockets vs Long Polling](https://ik.imagekit.io/ably/ghost/prod/2019/06/websockets-vs-long-polling-1.jpg?tr=w-1520)

**How to choose between the two?**

Sometimes we need information from our servers as soon as it’s available. The usual AJAX request/response we’re all used to doesn’t keep the connection open for this sort of use case. Instead we need a push-based method like WebSockets, Long Polling, Server-sent events (SSE) and more recently HTTP2 push. In this article, we compare two methods: WebSockets and Long Polling.

## An overview of Long Polling

In 1995, [Netscape Communications](https://en.wikipedia.org/wiki/Netscape) hired Brendan Eich to implement scripting capabilities in Netscape Navigator and, over a ten-day period, the JavaScript language was born. Its capabilities as a language were initially very limited compared to modern-day JavaScript, and its ability to interact with the browser’s document object model (DOM) was even more limited. JavaScript was mostly useful for providing limited enhancements to enrich document consumption capabilities. For example, in-browser form validation and lightweight insertion of dynamic HTML into an existing document.

![](https://ik.imagekit.io/ably/ghost/prod/2019/06/long-polling-f6e3a73a589fe25d7c7b622a8487a2e8a27a11f00b22b574abb021fbcd7ac2db.png?tr=w-1520)

As the [browser wars](https://en.wikipedia.org/wiki/Browser_wars) heated up and Microsoft’s Internet Explorer reached version 4 and beyond, the battle for the most robust feature set led to Microsoft’s introduction of what ultimately became the [XMLHttpRequest](https://xhr.spec.whatwg.org/). All browsers have universally supported this for well over a decade.

[Long polling](https://en.wikipedia.org/wiki/Push_technology#Long_polling) is essentially a more efficient form of the original polling technique. Making repeated requests to a server wastes resources, as each new incoming connection must be established, the HTTP headers must be parsed, a query for new data must be performed, and a response (usually with no new data to offer) must be generated and delivered. The connection must then be closed and any resources cleaned up. Rather than having to repeat this process multiple times for every client until new data for a given client becomes available, long polling is a technique where the server elects to hold a client’s connection open for as long as possible, delivering a response only after data becomes available or a timeout threshold is reached.

## An overview of WebSockets

Around the middle of 2008, the pain and limitations of using Comet when implementing anything truly robust were being felt particularly keenly by developers [Michael Carter](https://en.wikipedia.org/wiki/Michael_Carter_(entrepreneur)) and [Ian Hickson](https://en.wikipedia.org/wiki/Ian_Hickson). Through collaboration [on IRC](https://krijnhoetmer.nl/irc-logs/whatwg/20080618#l-1145) and [W3C mailing lists](https://lists.w3.org/Archives/Public/public-whatwg-archive/2008Jun/0165.html), they hatched a plan to introduce a new standard for modern real-time, bi-directional communication on the web, and thus [the name ‘WebSocket’ was coined](https://lists.w3.org/Archives/Public/public-whatwg-archive/2008Jun/0186.html).  

![](https://ik.imagekit.io/ably/ghost/prod/2019/06/websocks.png?tr=w-1520)

The idea made its way into the W3C HTML draft standard and, shortly after, Michael Carter wrote [an article introducing the Comet community to the WebSockets.](http://cometdaily.com/2008/07/04/html5-websocket/) In 2010, Google Chrome 4 was the first browser to ship full support for WebSockets, with other browser vendors following suit over the course of the next few years. In 2011, [RFC 6455 – The WebSocket Protocol](https://tools.ietf.org/html/rfc6455) – was published to the IETF website.

In a nutshell, [WebSockets](https://en.wikipedia.org/wiki/WebSocket) are a thin transport layer built on top of a device’s [TCP/IP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) stack. The intent is to provide what is essentially an as-close-to-raw-as-possible TCP communication layer to web application developers while adding a few abstractions to eliminate certain friction that would otherwise exist concerning the way the web works. They also cater to the fact that the web has additional security considerations that must be taken into account to protect both consumers and service providers.

## Long Polling: pros and cons

**Pros**

* Long polling is implemented on the back of XMLHttpRequest, which is near-universally supported by devices so there’s usually little need to support further fallback layers. In cases where exceptions must be handled though, or where a server can be queried for new data but does not support long polling (let alone other more modern technology standards), basic polling can sometimes still be of limited use, and can be implemented using XMLHttpRequest, or via JSONP through simple HTML script tags.  
    

**Cons**

* Long polling is a lot more intensive on the server.
* [Reliable message ordering](https://support.ably.io/support/solutions/articles/3000044641) can be an issue with long polling because it is possible for multiple HTTP requests from the same client to be in flight simultaneously. For example, if a client has two browser tabs open consuming the same server resource, and the client-side application is persisting data to a local store such as localStorage or IndexedDb, there is no in-built guarantee that duplicate data won’t be written more than once.
* Depending on the server implementation, confirmation of message receipt by one client instance may also cause another client instance to never receive an expected message at all, as the server could mistakenly believe that the client has already received the data it is expecting.

## WebSockets: pros and cons

**Pros**

* WebSockets keeps a unique connection open while eliminating latency problems that arise with Long Polling.
* WebSockets generally do not use XMLHttpRequest, and as such, headers are not sent every-time we need to get more information from the server. This, in turn, reduces the expensive data loads being sent to the server.  
    

**Cons**

* WebSockets don’t automatically recover when connections are terminated – this is something you need to implement yourself, and is part of the reason why there are many [client-side libraries](https://www.ably.io/download) in existence.
* Browsers older than 2011 aren’t able to support WebSocket connections - but this is increasingly less relevant.

## Why the WebSocket protocol is the better choice

Generally, WebSockets will be the better choice.

Long polling is much more resource intensive on servers whereas WebSockets have an extremely lightweight footprint on servers. Long polling also requires many hops between servers and devices. And these gateways often have different ideas of how long a typical connection is allowed to stay open. If it stays open too long something may kill it, maybe even when it was doing something important.

Why you should build with WebSockets:  

* Full-duplex asynchronous messaging. In other words, both the client and the server can stream messages to each other independently.
* WebSockets pass through most firewalls without any reconfiguration.
* Good security model (origin-based security model).

## WebSockets open source solutions

There are two primary classes of WebSocket libraries: those that implement the protocol and leave the rest to the developer and those that build on top of the protocol with various additional features commonly required by realtime messaging applications, such as restoring lost connections, pub/subm and channels, authentication, authorization, etc.

The latter variety often requires that their own libraries be used on the client side, rather than just using the raw WebSocket API provided by the browser. As such, it becomes crucial to make sure you’re happy with how they work and what they’re offering. You may find yourself locked into your chosen solution’s way of doing things once it has been integrated into your architecture, and any issues with reliability, performance, and extensibility may come back to bite you.

Let’s start with a list of those that fall into the first of the two categories.

**Note: All of the following are open-source libraries.**  

**ws**

[ws](https://github.com/websockets/ws) is a “simple to use, blazing fast and thoroughly tested WebSocket client and server for Node.js”. It is definitely a barebones implementation, designed to do all the hard work of implementing the protocol, however additional features such as connection restoration, pub/sub, and so forth, are concerns you’ll have to manage yourself.  

Client (Browser, before bundling):

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

Server (Node.js):

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

[μWS](https://github.com/uNetworking/uWebSockets) is a drop-in replacement for [ws](https://www.ably.io/concepts/websockets#ws), implemented with a particular focus on performance and stability. To the best of my knowledge, μWS is the fastest WebSocket server implementation available by a mile. It’s actually used under the hood by [SocketCluster](https://www.ably.io/concepts/websockets#socketcluster), which I’ll talk about below.

There has been a little [controversy](https://www.reddit.com/r/node/comments/91kgte/uws_has_been_deprecated/) around μWS recently due to the author having attempted to pull it from NPM for philosophical reasons, but [the latest working version](https://www.npmjs.com/package/uws/v/10.148.1) remains on NPM and can be installed specifying that version explicitly when installing from NPM. That said, the author is working on [a new version](https://github.com/uNetworking/v0.15), with accompanying [node.js bindings](https://github.com/uNetworking/uWebSockets-node) also [in development](https://github.com/uNetworking/uWebSockets-node/issues/2).  

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

## The client-side – Using WebSockets in the browser

The WebSocket API is defined in the [WHATWG HTML Living Standard](https://html.spec.whatwg.org/multipage/web-sockets.html#network) and is actually pretty trivial to use. Constructing a WebSocket takes one line of code:

JS

```
const ws = new WebSocket('ws://example.org');
```

Note the use of ws where you’d normally have the http scheme. There’s also the option to use wss where you’d normally use https. These protocols were introduced in tandem with the WebSocket specification, and are designed to represent an HTTP connection that includes a request to upgrade the connection to use WebSockets.

Creating the WebSocket object doesn’t do a lot by itself. The connection is established asynchronously, so you’d need to listen for the completion of the handshake before sending any messages, and also include a listener for messages received from the server:  

```
ws.addEventListener('open', () => {
    // Send a message to the WebSocket server
    ws.send('Hello!');
});

ws.addEventListener('message', event => {
// The `event` object is a typical DOM event object, and the message data sent
// by the server is stored in the `data` property
    console.log('Received:', event.data);
});
```

There are also the error and close events. WebSockets don’t automatically recover when connections are terminated – this is something you need to implement yourself, and is part of the reason why there are many client-side libraries in existence. While the WebSocket class is straightforward and easy to use, it really is just a basic building block. Support for different subprotocols or additional features such as messaging channels must be implemented separately.

## Long polling - open source solutions

Most libraries don’t implement long polling in isolation from other transports because, in general, long polling is usually accompanied with other transport strategies, either as a fallback or with those transports as fallbacks when long polling doesn’t work. In 2018 and beyond, standalone long polling libraries are particularly uncommon, given that it’s a technique that is quickly losing relevance in the face of widespread support for more modern alternatives. Nevertheless, below are a handful of options for a few different languages you can implement for fallback transport:  

* **Go:** [**golongpoll**](https://github.com/jcuga/golongpoll)
* **PHP:** [**php-long-polling**](https://github.com/panique/php-long-polling)
* **Node.js:** [**Pollymer**](https://github.com/fanout/pollymer)
* **Python:** [**A simple COMET server**](https://github.com/jedisct1/Simple-Comet-Server)

## Ably, WebSockets, and long polling

Most of [Ably’s client library SDKs](https://www.ably.io/download) use a [WebSocket](https://www.ably.io/documentation/concepts/websockets) to establish a realtime connection to Ably, then use a simple HTTP request for all other REST operations including authentication.

However, client library SDKs such as our [Javascript browser library](https://github.com/ably/ably-js) are designed to choose the best transport available based on the browser and connection available. By supporting additional transports with the ability to fallback to the lowest common denominator, Ably ensures that practically every browser in use today is able to establish a realtime connection to Ably. The following transports are currently supported by our [Javascript browser library](https://github.com/ably/ably-js) in order of best to worst performing:

* [WebSockets](https://www.ably.io/documentation/concepts/websockets) ([supported by 94% of browsers globally as of Dec 2017](http://caniuse.com/#feat=websockets))
* XHR streaming
* XHR polling
* JSONP polling

There’s a lot involved when implementing support for WebSockets with Long Polling as a fallback - not just in terms of client and server implementation details, but also with respect to support for other transports to ensure robust support for different client environments, as well as broader concerns, such as [authentication and authorization](https://www.ably.io/documentation/core-features/authentication?utm_source=websockets&utm_medium=concepts), [guaranteed message delivery-](https://support.ably.io/a/solutions/articles/3000044640), [reliable message ordering-](https://support.ably.io/a/solutions/articles/3000044640), [historical message retention](https://www.ably.io/documentation/core-features/history?utm_source=websockets&utm_medium=concepts), and [more](https://www.ably.io/documentation/).

## References and further reading

* [Long Polling](https://www.ably.io/concepts/long-polling)
* [WebSockets](https://www.ably.io/concepts/websockets)
* [How Ably Works](https://www.ably.io/documentation/how-ably-works#any-internet-device)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
