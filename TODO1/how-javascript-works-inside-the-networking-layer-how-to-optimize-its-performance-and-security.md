> * 原文地址：[How JavaScript Works: Inside the Networking Layer + How to Optimize Its Performance and Security](https://blog.sessionstack.com/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security-f71b7414d34c)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md)
> * 译者：
> * 校对者：

# How JavaScript Works: Inside the Networking Layer + How to Optimize Its Performance and Security

This is post # 12 of the series dedicated to exploring JavaScript and its building components. In the process of identifying and describing the core elements, we also share some rules of thumb we use when building [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-intro), a JavaScript application that needs to be robust and highly-performant to help users see and reproduce their web app defects real-time.

If you missed the previous chapters, you can find them here:

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)
9. [[译] JavaScript 是如何工作的：Web 推送通知的机制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)
10. [[译] JavaScript 是如何工作的：用 MutationObserver 追踪 DOM 的变化](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md)
11. [[译] JavaScript 是如何工作的：渲染引擎和性能优化技巧](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)

Just like we mentioned in our previous blog post about the [rendering engine](https://blog.sessionstack.com/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance-7b95553baeda), we believe that the difference between good and great JavaScript developers is that the latter not only understand the nuts and bolts of the language but also its internals and the surrounding environment.

#### A little bit of history

Forty-nine years ago, a thing called ARPAnet was created. It was [an early packet switching network](https://en.wikipedia.org/wiki/Packet_switching) and the first network [to implement the TCP/IP suite](https://en.wikipedia.org/wiki/Internet_protocol_suite). That network set up a link between University of California and Stanford Research Institute. 20 years later Tim Berners-Lee circulated a proposal for a “Mesh” which later became better known as the World Wide Web. In those 49, years the internet has come a long way, starting from just two computers exchanging packets of data, to reaching more than 75 million servers, 3.8B people using the internet and 1.3B websites.

![](https://cdn-images-1.medium.com/max/800/1*x8P3OcgcgKrEEDpgT2IKkQ.jpeg)

In this post, we’ll try to analyze what techniques modern browsers employ to automatically boost performance (without you even knowing it), and we’ll specifically zoom in on the browser networking layer. At the end, we’ll provide some ideas on how to help browsers boost even more the performance of your web apps.

### Overview

The modern web browser has been specifically designed for the fast, efficient and secure delivery of web apps/websites. With hundreds of components running on different layers, from process management and security sandboxing to GPU pipelines, audio and video, and many more, the web browser looks more like an operating system rather than just a software application.

The overall performance of the browser is determined by a number of large components: parsing, layout, style calculation, JavaScript and WebAssembly execution, rendering, and of course, **the networking stack**.

Engineers often think that the networking stack is a bottleneck. This is frequently the case since all resources need to be fetched from the internet before the rest of the steps are unblocked. For the networking layer to be efficient it needs to play the role of more than just a simple socket manager. It is presented to us as a very simple mechanism for resource fetching but it’s actually an entire platform with its own optimization criteria, APIs, and services.

![](https://cdn-images-1.medium.com/max/800/1*WqInzMPQGGcMX9AOONN76g.jpeg)

As web developers, we don’t have to worry about the individual TCP or UDP packets, request formatting, caching and everything else that’s going on. The entire complexity is taken care of by the browser so we can focus on the application we’re developing. Knowing what’s happening under the hood, however, can help us create faster and more secure applications.

In essence, here’s what’s happening when the user starts interacting with the browser:

*   The user enters a URL in the browser address bar
*   Given the URL of a resource on the web, the browser starts by checking its local and application caches and tries to use a local copy to fulfill the request.
*   If the cache cannot be used, the browser takes the domain name from the URL and requests the IP address of the server from a [DNS](https://en.wikipedia.org/wiki/Domain_Name_System). If the domain is cached, no DNS query is needed.
*   The browser creates an HTTP packet saying that it requests a web page located on the remote server.
*   The packet is sent to the TCP layer which adds its own information on top of the HTTP packet. This information is required to maintain the started session.
*   The packet is then handed to the IP layer which main job is to figure out a way to send the packet from the user to the remote server. This information is also stored on top of the packet.
*   The packet is sent to the remote server.
*   Once the packet is received, the response gets sent back in a similar manner.

The W3C [Navigation Timing specification](http://www.w3.org/TR/navigation-timing/) provides a browser API as well as visibility into the timing and performance data behind the life of every request in the browser. Let’s inspect the components, as each plays a critical role in delivering the optimal user experience:

![](https://cdn-images-1.medium.com/max/800/1*rjBdCBwOx5Gp_A6b6FQgfw.png)

The whole networking process is very complex and there are many different layers which can become a bottleneck. This is why browsers strive to improve performance on their side by using various techniques so that the impact of the entire network communication is minimal.

### Socket management

Let’s start with some terminology:

*   **Origin** — A triple of application protocol, domain name and port number (e.g. https, [www.example.com](http://www.example.com), 443)
*   **Socket pool** — a group of sockets belonging to the same origin (all major browsers limit the maximum pool size to 6 sockets)

JavaScript and WebAssembly **do not** allow us to manage the lifecycle of individual network sockets, and that’s a good thing! This not only keeps our hands clean but it also allows the browser to automate a lot of performance optimizations some of which include socket reuse, request prioritization and late binding, protocol negotiation, enforcing connection limits, and many other.

Actually, modern browsers go the extra mile to separate the request management cycle from socket management. Sockets are organized in pools, which are grouped by origin, and each pool enforces its own connection limits and security constraints. Pending requests are queued, prioritized, and then bound to individual sockets in the pool. Unless the server intentionally closes the connection, the same socket can be automatically reused across multiple requests!

![](https://cdn-images-1.medium.com/max/800/1*0e8X3UTBpsiBSZKa3l1hXA.png)

Since the opening of a new TCP connection comes at an additional cost, the reuse of connections introduces great performance benefits on its own. By default, browsers use the so-called “keepalive” mechanism which saves time from opening a new connection to the server when a request is made. The average time for opening a new TCP connection is:

*   Local requests — `23ms`
*   Transcontinental requests — `120ms`
*   Intercontinental requests — `225ms`

This architecture opens the door to a number of other optimization opportunities. The requests can be executed in a different order depending on their priority. The browser can optimize the bandwidth allocation across all sockets or it can open sockets in anticipation of a request.

As I mentioned before, this is all managed by the browser and does not require any work on our side. But this doesn’t necessarily mean that we can’t do anything to help. Choosing the right network communication patterns, type, and frequency of transfers, choice of protocols and tuning/optimization of our server stack can play a great role in improving the overall performance of an application.

Some browsers even go one step further. For example, Chrome can self-teach itself to get faster as you use it. It learns based on the sites visited and the typical browsing patterns so it can anticipate likely user behavior and take action before the user does anything. The simplest example is pre-rendering a page when the user hovers on a link. If you’re interested in learning more about Chrome’s optimizations, you can check out this chapter [https://www.igvita.com/posa/high-performance-networking-in-google-chrome/](https://www.igvita.com/posa/high-performance-networking-in-google-chrome/) of the [High-Performance Browser Networking](https://hpbn.co) book.

### Network Security and Sandboxing

Allowing the browser to manage the individual sockets has another very important purpose: this way the browser enables the enforcement of a consistent set of security and policy constraints on untrusted application resources. For example, the browser does not allow direct API access to raw network sockets as this would enable any malicious application to make arbitrary connections to any host. The browser also enforces connection limits which protect the server as well as the client from resource exhaustion.

The browser formats all outgoing requests to enforce consistent and well-formed protocol semantics to protect the server. Similarly, response decoding is done automatically to protect the user from malicious servers.

#### TLS negotiation

[Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security) is a cryptographic protocol that provides communication security over a computer network. It finds widespread use in many applications, one of which is web browsing. Websites can use TLS to secure all communications between their servers and web browsers.

The entire TLS handshake consists of the following steps:

1.  The client sends a “Client hello” message to the server, along with the client’s random value and supported cipher suites.
2.  The server responds by sending a “Server hello” message to the client, along with the server’s random value.
3.  The server sends its certificate for authentication to the client and may request a similar certificate from the client. The server sends the “Server hello done” message.
4.  If the server has requested a certificate from the client, the client sends it.
5.  The client creates a random Pre-Master Secret and encrypts it with the public key from the server’s certificate, sending the encrypted Pre-Master Secret to the server.
6.  The server receives the Pre-Master Secret. The server and the client each generate the Master Secret and session keys based on the Pre-Master Secret.
7.  The client sends a “Change cipher spec” notification to the server to indicate that the client will start using the new session keys for hashing and encrypting messages. The client also sends a “Client finished” message.
8.  The server receives the “Change cipher spec” and switches its record layer security state to symmetric encryption using the session keys. The server sends a “Server finished” message to the client.
9.  Client and server can now exchange application data over the secured channel they have established. All messages sent from the client to the server and back are encrypted using the session key.

The user is warned in case any of the verifications fail — e.g., the server is using a self-signed certificate.

#### Same-origin policy

Two pages have the same origin if the protocol, port (if one is specified), and host are the same for both pages.

Here are some examples of resources which may be embedded cross-origin:

*   JavaScript with `<script src=”…”></script>`. Error messages for syntax errors are only available for same-origin scripts
*   CSS with `<link rel=”stylesheet” href=”…”>`. Due to the relaxed syntax rules of CSS, cross-origin CSS requires a correct Content-Type header. Restrictions vary by browser
*   Images with `<img>`
*   Media files with `<video>` and `<audio>`
*   Plug-ins with `<object>`, `<embed>` and `<applet>`
*   Fonts with @font-face. Some browsers allow cross-origin fonts, others require same-origin fonts.
*   Anything with `<frame>` and `<iframe>`. A site can use the X-Frame-Options header to prevent this form of cross-origin interaction.

The above list is far from complete; its goal is to highlight the principle of “least privilege” at work. The browser exposes only the APIs and resources that are necessary for the application code: the application supplies the data and the URL, and the browser formats the request and handles the full lifecycle of each connection.

It’s worth noting that there is no single concept of the “same-origin policy.” Instead, there is a set of related mechanisms that enforce restrictions on DOM access, cookie and session state management, networking, and other components of the browser.

### Resource and Client State Caching

The best and fastest request is a request not made. Prior to dispatching a request, the browser automatically checks its resource cache, performs the necessary validation checks, and returns a local copy of the resources if the specified conditions are met. If a local resource is not available in the cache, then a network request is made and the response is automatically placed in the cache for a subsequent access if such is permitted.

*   The browser automatically evaluates caching directives on each resource
*   The browser automatically revalidates expired resources when possible
*   The browser automatically manages the size of the cache and resource eviction

Managing an efficient and optimized resource cache is hard. Thankfully, the browser takes care of the entire complexity on our behalf, and all we need to do is ensure that our servers are returning the appropriate cache directives; to learn more, see [Cache Resources on the Client](https://hpbn.co/optimizing-application-delivery/#cache-resources-on-the-client). You do provide Cache-Control, ETag, and Last-Modified response headers for all the resources on your pages, right?

Finally, an often-overlooked but critical function of the browser is its duty to provide authentication, session, and cookie management. The browser maintains separate “cookie jars” for each origin, provides necessary application and server APIs to read and write new cookie, session, and authentication data, and automatically appends and processes appropriate HTTP headers to automate the entire process on our behalf.

#### An example:

A simple but illustrative example of the convenience of deferring session state management to the browser: an authenticated session can be shared across multiple tabs or browser windows, and vice versa; a sign-out action in a single tab will invalidate open sessions in all other open windows.

### Application APIs and Protocols

Walking up the ladder of provided network services we finally arrive at the application APIs and protocols. As we saw, the lower layers provide a wide array of critical services: socket and connection management, request and response processing, enforcement of various security policies, caching, and much more. Every time we initiate an HTTP or an XMLHttpRequest, a long-lived Server-Sent Event or WebSocket session, or open a WebRTC connection, we are interacting with some or all of these underlying services.

There is no single best protocol or API. Every non-trivial application will require a mix of different transports based on a variety of requirements: interaction with the browser cache, protocol overhead, message latency, reliability, type of data transfer, and more. Some protocols may offer low-latency delivery (e.g., Server-Sent Events, WebSocket), but may not meet other critical criteria, such as the ability to leverage the browser cache or support efficient binary transfers in all cases.

### A Few Things You Can Do To Improve Your Web App Performance and Security

*   Always use the “Connection: Keep-Alive” header in your requests. Browsers do this by default. Make sure that the server uses the same mechanism.
*   Use the proper Cache-Control, Etag and Last-Modified headers so you can save the browser some downloading time.
*   Spend time tweaking and optimizing your web server. This is where real magic can happen! Bear in mind that the process if is very specific for each web app and the type of data you’re transmitting.
*   Always use TLS! Especially if you have any type of authentication in your application.
*   Research what security policies browsers provide and enforce them in your application.

Both performance and security are first-class citizens in [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-outro). The reason why we can’t afford to compromise on either is that once SessionStack is integrated into your web app, it starts monitoring everything from DOM changes and user interaction to network requests, unhandled exceptions and debug messages. All the data is transmitted to our servers real-time which allows you to replay issues from your web apps as videos and see everything that happened to your users. And this all is taking place with minimum latency and no performance overhead to your app.

This is why we strive to employ all the above tips + a few more which we’ll discuss in a future post.

There is a free plan if you’d like to [give SessionStack a try](https://www.sessionstack.com/signup/).

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### Resources

*   [https://hpbn.co/](https://hpbn.co/)
*   [https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886)
*   [https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513(v=vs.85).aspx](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513%28v=vs.85%29.aspx)
*   [http://www.internetlivestats.com/](http://www.internetlivestats.com/)
*   [http://vanseodesign.com/web-design/browser-requests/](http://vanseodesign.com/web-design/browser-requests/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
