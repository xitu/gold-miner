> * 原文地址：[How Modern Web Browsers Accelerate Performance: The Networking Layer](https://blog.sessionstack.com/how-modern-web-browsers-accelerate-performance-the-networking-layer-f6efaf7bfcf4)
> * 原文作者：[
Lachezar Nickolov](https://blog.sessionstack.com/@lsnickolov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-modern-web-browsers-accelerate-performance-the-networking-layer.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-modern-web-browsers-accelerate-performance-the-networking-layer.md)
> * 译者：
> * 校对者：

# How Modern Web Browsers Accelerate Performance: The Networking Layer

Forty-nine years ago a thing called ARPAnet was created. It was [an early packet switching network](https://en.wikipedia.org/wiki/Packet_switching) and the first network [to implement the TCP/IP suite](https://en.wikipedia.org/wiki/Internet_protocol_suite). That network set up a link between the University of California and Stanford Research Institute. 20 years later Tim Berners-Lee circulated a proposal for a “Mesh” which later became better known as the World Wide Web. In those 49, years the internet has come a long way, starting from just two computers exchanging packets of data, to reaching more than 75 million servers, 3.8B people using the internet and 1.3B websites.

![](https://cdn-images-1.medium.com/max/800/1*x8P3OcgcgKrEEDpgT2IKkQ.jpeg)

In this post, we’ll try to analyze what techniques modern browsers employ to automatically boost performance (without you even knowing it), and we’ll specifically zoom in on the browser networking layer. We’ll provide some ideas on how to help browsers boost the performance of your web apps even more. At the end, we also share some rules of thumb we use when building [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-6-webassembly-intro), a lightweight JavaScript application that has to be robust and highly-performant to help users see and reproduce their web app defects real-time.

We’re all familiar with the technology used for presenting those 1.3B websites in a user- friendly way. I’m talking about web browsers. The modern web browser has been specifically designed for the fast, efficient and secure delivery of web apps/websites. With hundreds of components running on different layers, from process management and security sandboxing to GPU pipelines, audio and video, and many more, the web browser looks more like an operating system rather than just a software application.

The overall performance of the browser is determined by a number of large components: parsing, layout, style calculation, JavaScript and WebAssembly execution, rendering, and of course, the networking stack. The networking stack is often doubted to be a bottleneck. This is often the case because all resources need to be fetched from the internet before the rest of the steps are unblocked. For the networking layer to be efficient it needs to play the role of more than just a simple socket manager. It is presented to us as a very simple mechanism for resource fetching but it’s actually an entire platform with its own optimization criteria, APIs, and services.

![](https://cdn-images-1.medium.com/max/800/1*WqInzMPQGGcMX9AOONN76g.jpeg)

As web developers, we don’t have to worry about the individual TCP or UDP packets, request formatting, caching and everything else that’s going on. The entire complexity is taken care of by the browser so we can focus on the application we’re developing. But hey… it won’t hurt if we get to know a bit of what’s going on under the hood of web browsers. Actually, it can even help us create faster and more secure applications.

In essence, here’s what’s happening when the user starts interacting with the browser:

* The user enters a URL in the browser address bar
* The browser takes the domain name from the URL and requests the IP address of the server from a [DNS](https://en.wikipedia.org/wiki/Domain_Name_System).
* The browser creates an HTTP packet saying that it requests a web page located on the remote server.
* The packet is sent to the TCP layer which adds its own information on top of the HTTP packet. This information is required to maintain the started session.
* The packet is then handed to the IP layer which main job is to figure out a way to send the packet from you to the remote server. This information is also stored on top of the packet.
* The packet is sent to the remote server.
* Once the packet is received, the response gets sent back in a similar manner.

This is a very high-level overview of what’s going on when a network request is made. The whole networking process is very complex and there are many different layers which can become a bottleneck. This is why browsers strive to improve performance on their side by using various techniques so the impact of the whole network communication can be minimal.

### Socket management

Let’s start with some terminology:

* Origin — A triple of application protocol, domain name and port number (e.g. https, [www.example.com](http://www.example.com), 443)
* Socket pool — a group of sockets belonging to the same origin (all major browsers limit the maximum pool size to 6 sockets)

JavaScript and WebAssembly do not allow us to manage the lifecycle of individual network sockets, and that’s a good thing! This not only keeps our hands clean but it also allows the browser to automate a lot of performance optimizations some of which include sockets reuse, request prioritization and late binding, protocol negotiation, enforcing connection limits, and many other. Actually, modern browsers go the extra mile to separate the request management cycle from socket management. Sockets are organized in pools, which are grouped by origin, and each pool enforces its own connection limits and security constraints. Pending requests are queued, prioritized, and then bound to individual sockets in the pool. Unless the server intentionally closes the connection, the same socket can be automatically reused across multiple requests!

![](https://cdn-images-1.medium.com/max/800/1*_0F_8oL0vQQestOkKeRmAw.jpeg)

Since the opening of a new TCP connection comes at an additional cost, the reuse of connections introduces great performance benefits on its own. By default browsers use the so-called “keepalive” mechanism which saves time from opening a new connection to the server when a request is made. The average time for opening a new TCP connection is 23ms for local requests, 120ms for transcontinental requests and 225ms for intercontinental requests. Now imagine that the browser has to make only 10 requests to the server. I’ll let you do the math :)

This architecture opens the door for a number of other optimization opportunities. The requests can be executed in a different order depending on their priority; the browser can optimize the bandwidth allocation across all sockets or it can open sockets in anticipation of a request.

As I mentioned before, this is all managed by the browser and does not require any work on our side. But this doesn’t necessarily mean that we can’t do anything to help. Choosing the right network communication patterns, type, and frequency of transfers, choice of protocols and tuning/optimization of our server stack can play a great role in the overall performance of an application.

Some browsers even go one step beyond. For example, Chrome can self-teach itself to get faster as you use it. It learns based on the sites visited and the typical browsing patterns so it can anticipate likely user behavior and take action before the user does anything. The simplest example is pre-rendering a page when the user hovers on a link. If you’re interested in learning more about Chrome’s optimizations, you can check out this chapter [https://www.igvita.com/posa/high-performance-networking-in-google-chrome/](https://www.igvita.com/posa/high-performance-networking-in-google-chrome/) of the [High-Performance Browser Networking](https://hpbn.co) book.

### Network Security and Sandboxing

Allowing the browser to manage the individual sockets has another very important purpose: it enables the enforcement of a consistent set of security and policy constraints on untrusted application resources. For example, the browser does not allow direct API access to raw network sockets as this would enable any malicious application to make arbitrary connections to any host. The browser also enforces connection limits which protect the server as well as the client from resource exhaustion.

The browser formats all outgoing requests to enforce consistent and well-formed protocol semantics to protect the server. Similarly, response decoding is done automatically to protect the user from malicious servers.

#### TLS negotiation

[Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security) is a cryptographic protocol that provides communications security over a computer network. It finds widespread use in many applications, one of which is web browsing. Websites are able to use TLS to secure all communications between their servers and web browsers.

The whole TLS handshake consists of the following steps:

1. The client sends a “Client hello” message to the server, along with the client’s random value and supported cipher suites.
2. The server responds by sending a “Server hello” message to the client, along with the server’s random value.
3. The server sends its certificate to the client for authentication and may request a certificate from the client. The server sends the “Server hello done” message.
4. If the server has requested a certificate from the client, the client sends it.
5. The client creates a random Pre-Master Secret and encrypts it with the public key from the server’s certificate, sending the encrypted Pre-Master Secret to the server.
6. The server receives the Pre-Master Secret. The server and the client each generate the Master Secret and session keys based on the Pre-Master Secret.
7. The client sends a “Change cipher spec” notification to the server to indicate that the client will start using the new session keys for hashing and encrypting messages. The client also sends a “Client finished” message.
8. Server receives the “Change cipher spec” and switches its record layer security state to symmetric encryption using the session keys. Server sends a “Server finished” message to the client.
9. Client and server can now exchange application data over the secured channel they have established. All messages sent from the client to the server and back are encrypted using the session key.

The user is then warned if any of the verifications fail — e.g., the server is using a self-signed certificate.

#### Same-origin policy

The browser enforces constraints on the type of requests that can be initiated by the application, and to which origin these requests can be made.

The above list is far from complete; its goal is to highlight the principle of “least privilege” at work. The browser exposes only the APIs and resources that are necessary for the application code: the application supplies the data and the URL, and the browser formats the request and handles the full lifecycle of each connection.

It’s worth noting that there is no single concept of the “same-origin policy.” Instead, there is a set of related mechanisms that enforce restrictions on DOM access, cookie and session state management, networking, and other components of the browser. If you’re curious to learn more, I’d suggest [The Tangled Web](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886) by Michal Zalewski.

### Resource and Client State Caching

The best and fastest request is a request not made. Prior to dispatching a request, the browser automatically checks its resource cache, performs the necessary validation checks, and returns a local copy of the resources if the specified conditions are met. Similarly, if a local resource is not available in the cache, then a network request is made and the response is automatically placed in the cache for a subsequent access if such is permitted.

* The browser automatically evaluates caching directives on each resource
* The browser automatically revalidates expired resources when possible
* The browser automatically manages the size of the cache and resource eviction

Managing an efficient and optimized resource cache is hard. Thankfully, the browser takes care of the entire complexity on our behalf, and all we need to do is ensure that our servers are returning the appropriate cache directives; to learn more, see [Cache Resources on the Client](https://hpbn.co/optimizing-application-delivery/#cache-resources-on-the-client). You provide Cache-Control, ETag, and Last-Modified response headers for all the resources on your pages, right?

Finally, an often-overlooked but critical function of the browser is to provide authentication, session, and cookie management. The browser maintains separate “cookie jars” for each origin, provides necessary application and server APIs to read and write new cookie, session, and authentication data, and automatically appends and processes appropriate HTTP headers to automate the entire process on our behalf.

#### An example:

A simple but illustrative example of the convenience of deferring session state management to the browser: an authenticated session can be shared across multiple tabs or browser windows, and vice versa; a sign-out action in a single tab will invalidate open sessions in all other open windows.

### Application APIs and Protocols

Walking up the ladder of provided network services we finally arrive at the application APIs and protocols. As we saw, the lower layers provide a wide array of critical services: socket and connection management, request and response processing, enforcement of various security policies, caching, and much more. Every time we initiate an HTTP or an XMLHttpRequest, a long-lived Server-Sent Event or WebSocket session, or open a WebRTC connection, we are interacting with some or all of these underlying services.

There is no single best protocol or API. Every non-trivial application will require a mix of different transports based on a variety of requirements: interaction with the browser cache, protocol overhead, message latency, reliability, type of data transfer, and more. Some protocols may offer low-latency delivery (e.g., Server-Sent Events, WebSocket), but may not meet other critical criteria, such as the ability to leverage the browser cache or support efficient binary transfers in all cases.

To summarize, here are a few things you can do to improve your web application performance and security:

* Always use the “Connection: Keep-Alive” header in your requests. Browsers do this by default. Make sure that the server uses the same mechanism.
* Use the proper Cache-Control, Etag and Last-Modified headers so you can save the browser some downloading time.
* Spend some time to tweak and optimize your web server
* Always use TLS! Especially if you have any type of authentication in your application
* Research what are the security policies provided by the browsers and enforce them in your application
* Be sure to check out the books referenced in this post. Many other techniques can be learned from them

Both performance and security are first-class citizens in SessionStack. The reason why they’re so important is that once SessionStack is integrated into your web app, it starts recording everything from DOM changes and user interaction to network requests, unhandled exceptions and debug messages. All of this data is transmitted to our servers in real-time which allows you to replay issues from your web apps as videos and see everything that happened to your users. And all of this is happening with minimum latency and no performance overhead to your app.

This is why we’re striving to employ all of the above tips + a few more which we’ll discuss in a future post.

There is a free plan that allows you to [get started for free](https://www.sessionstack.com/signup/).

![](https://cdn-images-1.medium.com/max/800/1*8wanSMWsaiOFLjEBb-5j8g.png)

#### Resources

* [https://hpbn.co/](https://hpbn.co/)
* [https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886)
* [https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513(v=vs.85).aspx](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513%28v=vs.85%29.aspx)
* [http://www.internetlivestats.com/](http://www.internetlivestats.com/)
* [http://vanseodesign.com/web-design/browser-requests/](http://vanseodesign.com/web-design/browser-requests/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
