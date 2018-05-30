> * 原文地址：[How JavaScript Works: Inside the Networking Layer + How to Optimize Its Performance and Security](https://blog.sessionstack.com/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security-f71b7414d34c)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md)
> * 译者：[Hopsken](https://github.com/hopsken)
> * 校对者：[sophiayang1997](https://github.com/sophiayang1997) [luochen1992](https://github.com/luochen1992)

# JavaScript 是如何工作的：深入网络层 + 如何优化性能和安全

这是探索 JavaScript 及其内建组件系列文章的第 12 篇。在认识和描述这些核心元素的过程中，我们也会分享我们在构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-intro) 时所遵循的一些经验规则。SessionStack 是一个轻量级 JavaScript 应用，它协助用户实时查看和复现他们的 Web 应用缺陷，因此其自身不仅需要足够健壮还要有不俗的性能表现。

如果你错过了前面的文章，你可以在下面找到它们：

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

正如我们在前一篇关于[渲染引擎](https://blog.sessionstack.com/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance-7b95553baeda)的文章中所说的，我们相信，优秀的 JavaScript 开发者和杰出的 JavaScript 开发者之间的区别在于后者不仅懂得如何使用这门语言，还能够理解它的内在以及周遭环境。

#### 一点点历史

49 年前，一个叫做 ARPAnet 的东西被创造了出来。它是[一个早期的数据包交换网络](https://en.wikipedia.org/wiki/Packet_switching)，也是第一个[实践 TCP/IP 套件](https://en.wikipedia.org/wiki/Internet_protocol_suite)的网络。该网络在加州大学和斯坦福研究中心之间搭建了一个连接。20年后，Tim Berners-Lee 发布了一个名为『Mesh』的提案，也就是后来人们所说的万维网。在这 49 年里，互联网走过了漫长的道路，从两台计算机交换数据包开始，到如今拥有超过 7500 万台服务器，38 亿名用户和 13 亿个网站。

![](https://cdn-images-1.medium.com/max/800/1*x8P3OcgcgKrEEDpgT2IKkQ.jpeg)

在这边文章中，我们将尝试分析现代浏览器使用了哪些技术来自动地提高性能（有些你甚至并不知道）。我们将尤其关注浏览器的网络层。在最后，我们将会提供一些建议，关于如何使得浏览器能够更好地提升你的 Web 应用的性能。

### 概览

为了能够快速、高效并且安全地展示 Web 应用/网站，现代的浏览器都是经过特别设计的。数百个组件运行在不同的层上，从进程管理和安全沙盒到 GPU 流水线，音频和视频等等，Web浏览器看起来更像是一个操作系统，而不仅仅是一个软件应用程序。

浏览器的整体性能取决于许多大型组件：解析、布局、样式计算、JavaScript 和 WebAssembly 执行、渲染，当然还有**网络栈**。

工程师经常认为网络栈是一个瓶颈。通常来说，确实如此，因为在执行接下来的步骤之前，先得从互联网上获取到所有的资源。为了提高网络层的效率，它不仅需要扮演简单的套接字管理员的角色。它呈现给我们的只是一种非常简单的资源获取机制，但它实际上是一个拥有自己的优化标准，API 和服务的完整平台。

![](https://cdn-images-1.medium.com/max/800/1*WqInzMPQGGcMX9AOONN76g.jpeg)

作为 Web 开发人员，我们不必操心个别的 TCP 或 UDP 数据包、请求格式化、缓存和此过程中的其他所有事情。所以复杂的事务都由浏览器处理，因此我们可以专注于我们正在开发的应用程序。但是，了解底层究竟发生了什么，可以帮助我们创建更快、更安全的应用程序。

实质上，当用户开始与浏览器交互时发生了以下事务：

*   用户在浏览器地址栏中输入一个 URL
*   给定一个 Web 资源的 URL，浏览器首先检查本地和应用程序缓存，并尝试使用本地副本来完成请求。
*   如果缓存无法使用，浏览器将从URL中获取域名，并通过 [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) 请求服务器的 IP 地址。如果该域被缓存，则不需要 DNS 查询。
*   浏览器创建一个 HTTP 数据包，说明它请求位于远程服务器上的某个网页。
*   数据包被发送到 TCP 层，在 HTTP 数据包的顶部添加它自己的信息。此信息将被用于维护已经开始的会话。
*   然后将数据包交给 IP 层，它的主要工作是找出将数据包从用户发送到远程服务器的途径。这些信息也会存储在数据包的顶部。
*   数据包被发送到远程服务器。
*   远程服务器一旦接收到数据包，就会以类似的方式发回响应。

W3C 的[导航时序规范](http://www.w3.org/TR/navigation-timing/)提供了浏览器 API，它能够提供浏览器中每个请求的生命周期背后的时间和性能数据。让我们来看看这些组件，因为它们在提供最佳用户体验方面起着至关重要的作用：

![](https://cdn-images-1.medium.com/max/800/1*rjBdCBwOx5Gp_A6b6FQgfw.png)

这个网络通信的过程是非常复杂的，有很多不同的层可能成为瓶颈。这就是为什么浏览器努力通过使用各种技术来提高性能的原因，以便整个网络通信的影响最小。

### 套接字管理

让我们先从一些术语开始：

*   **源（Origin）** —— 由应用协议、域名、端口三者构成（例如，https，[www.example.com](http://www.example.com)，443）
*   **套接字池（Socket pool）** —— 一组属于同一源的套接字（所有主流浏览器都将池的大小限制为最多 6 个套接字）

JavaScript 和 WebAssembly **不允许**我们管理网络套接字的生命周期，这是一件好事！这不仅可以使我们免去很多麻烦，而且还可以让浏览器自动去进行大量的性能优化，其中一些包括套接字重用，请求优先级和后期绑定，协议协商，强制连接限制等等。

实际上，现代浏览器更进了一步，把请求管理周期与套接字管理分立了开来。套接字按池组织，按源分组，每个池强制实施自己的连接限制和安全约束。待处理的请求会先排队，再按优先级处理，然后绑定到池中的单个套接字上。除非服务器有意关闭连接，否则可以在多个请求中自动重用相同的套接字！

![](https://cdn-images-1.medium.com/max/800/1*0e8X3UTBpsiBSZKa3l1hXA.png)

由于开辟新的 TCP 连接需要额外的成本，因此连接的重用具有很大的性能优势。默认情况下，浏览器使用所谓的「keepalive」机制，这可以节省出在已有请求发生后再打开新连接到服务器的时间。打开一个新的 TCP 连接的平均时间是：

*   本地请求 —— `23ms`
*   横贯大陆的请求 —— `120ms`
*   洲际请求 —— `225ms`

这种架构为其他一些优化提供了可能。这些请求可以根据其优先级以不同的顺序执行。浏览器可以优化所有套接字的带宽分配，或者在预期请求时先打开套接字。

正如我之前提到的，这一切都是由浏览器自行管理的，并不需要我们做任何工作。但这并不一定意味着我们什么都做不了。选择合适的网络通信模式，传输类型和频率，恰当地选择协议以及调整/优化服务器架构可以在提高应用程序的整体性能方面发挥重要作用。

有些浏览器甚至更进一步。例如，Chrome 可以学习用户的操作习惯来使自己变得更快。它根据用户访问的网站和典型的浏览模式进行学习，以便在用户做任何事情之前预测可能的用户行为并采取行动。最简单的例子是当用户在链接上悬停时，Chrome 会预先渲染页面。如果您有兴趣了解有关 Chrome 优化的更多信息，可以查看[高性能浏览器网络（High-Performance Browser Networking）](https://hpbn.co)一书中的本章节 [https://www.igvita.com/posa/high-performance-networking-in-google-chrome/](https://www.igvita.com/posa/high-performance-networking-in-google-chrome/)。

### 网络安全和沙盒

允许浏览器管理单个套接字具有另一个非常重要的目的：通过这种方式，浏览器可以对不可信的应用程序资源强制执行一致的安全和策略约束。例如，浏览器不允许通过 API 直接访问原始网络套接字，因为这可以使任何恶意应用程序与任何主机进行任意连接。浏览器还强制性地限制连接数，以保护服务器以及客户端免受资源耗尽的问题。

浏览器格式化所有传出请求，以强制实行风格一致且格式良好的协议语义来保护服务器。同样，响应解码自动完成，以保护用户免受恶意服务器的侵害。

#### TLS 协商

[传输层安全协定（TLS）](https://en.wikipedia.org/wiki/Transport_Layer_Security)是一种在计算机网络上提供安全通信保障的加密协议。它在许多应用程序中广泛使用，其中之一是网页浏览。网站可以使用 TLS 来保护其服务器和 Web 浏览器之间的所有通信。

完整的 TLS 握手包含以下几步：

1.  客户端向服务器发送『Client hello』消息，与之一同发送的还有客户端产生的随机值和支持的密码套件。
2.  服务器通过向客户端发送『Server hello』消息以及服务器产生的随机值进行响应。
3.  服务器将其认证证书发送给客户端，并可能向客户端请求类似的证书。服务器发送『Server hello done』消息。
4.  如果服务器已经向客户端请求了证书，则客户端发送它。
5.  客户端创建一个随机的预主密钥（Pre-Master Secret），并使用服务器证书中的公钥对其进行加密，再将加密的预主密钥发送给服务器。
6.  服务器接收到预主密钥。服务器和客户端根据预主密钥生成主密钥和会话密钥。
7.  客户端向服务器发送『Change cipher spec』通知，指示客户端将开始使用新的会话密钥进行散列和加密消息。客户端还发送『Client finished』消息。
8.  服务器收到『Change cipher spec』的消息，并使用会话密钥将其记录层安全状态切换为对称加密。服务器向客户端发送『Server finished』消息。
9.  客户端和服务器现在可以通过他们建立的安全通道交换应用程序数据。所有从当前客户端发送到服务器并返回的消息均使用会话密钥加密。

任何一步校验失败，用户都将会收到警告。例如，服务器正在使用自签名证书。

#### 同源策略

如果两个页面的协议、端口和主机名都相同的话，那么这两个页面同源。

以下是一些可能嵌入跨源资源的一些例子：

*   通过 `<script src=”…”></script>` 引用 JavaScript 资源。语法错误的错误消息仅适用于同源脚本
*   通过 `<link rel=”stylesheet” href=”…”>` 引用 CSS 资源。由于 CSS 的宽松语法规则，跨源 CSS 需要正确的 Content-Type 标头。不同浏览器可能有不同的限制。
*   通过 `<img>` 引用图像资源。
*   通过 `<video>` 和 `<audio>` 引用多媒体资源。
*   通过 `<object>`、`<embed>` 和 `<applet>` 引用插件资源。
*   通过 @font-face 引用字体资源。某些浏览器允许使用跨域字体，某些则不行。
*   任何通过 `<frame>` 和 `<iframe>` 引用的资源。网站可以使用 X-Frame-Options 头部标识来阻止这种形式的跨源交互。

以上列表远非完整；其目地是为了突出『最小特权』原则。 浏览器只公开应用程序代码必须的 API 和资源：应用程序提供数据和 URL，浏览器格式化请求并处理每个连接的完整生命周期。

值得注意的是，『同源策略』并非是个单一的概念。相反，有一组相关机制来强制性地限制 DOM 访问，Cookie 和会话状态管理，网络以及浏览器的其他组件。

### 资源和客户端状态缓存

最好和最快的请求是未发出的请求。在分派请求之前，浏览器会自动检查其资源缓存，执行必要的验证检查，并在满足指定条件时返回资源的本地副本。如果本地资源在缓存中不可用，则会发出网络请求，并且响应会被自动放入缓存中以供后续访问（如果允许）。

*   浏览器自动评估每个资源上的缓存指令
*   在可能的情况下，浏览器会自动重新验证过期资源
*   浏览器自动管理缓存大小和回收资源

管理高效和优化的资源缓存是很困难的。值得庆幸的是，浏览器替我们完成了所有复杂的事务，我们只需要确保我们的服务器返回适当的缓存指令；要了解更多信息，请参见[客户端上的缓存资源（Cache Resources on the Client）](https://hpbn.co/optimizing-application-delivery/#cache-resources-on-the-client)。您确实有为网页上的所有资源都提供了 Cache-Control，ETag 和 Last-Modified 响应头部字段，对吧？

最后，浏览器经常被忽视但至关重要的功能是提供身份验证，会话和 cookie 管理。浏览器为每个源维护单独的「Cookie jars」，提供必要的应用程序和服务器 API 来读取和写入新的 Cookie，会话和身份验证数据，并自动附加上和处理相应的 HTTP 头以代替我们自动执行整个过程。

#### 举个栗子：

用一个简单但有说明性的例子来说明将会话状态管理推放到浏览器端的便利之处：同一个经过身份验证的会话可以在多个选项卡或浏览器窗口之间共享，反之亦然；单个选项卡中的注销操作将使所有其他打开的窗口中打开的会话失效。

### 应用程序 API 和协议

研究完了网络服务，终于到达了应用程序 API 和协议这一步。正如我们所看到的，较低层提供了一系列关键服务：套接字和连接管理、请求和响应处理、各种安全策略的执行、缓存等等。每次我们启动一个 HTTP、一个XMLHttpRequest 或是一个长期的 Server-Sent Event 或 WebSocket 会话，或是打开一个 WebRTC 连接，我们都在与这些底层服务的一部分或全部进行交互。

没有单一的最佳协议或 API。每个不平凡的应用程序都需要根据各种需求混合使用不同的传输：与浏览器缓存的交互、协议开销、消息延迟、可靠性、数据传输类型等等。某些协议可能提供低延迟传输（例如 Server-Sent Events，WebSocket），但可能不符合其他关键条件，例如在所有情况下都能够利用浏览器缓存或支持高效二进制传输。

### 简单几步提高您的 Web 应用性能和安全性

*   请求中始终使用「Connection：Keep-Alive」头部字段。浏览器默认这样做。确保服务器使用相同的机制。
*   使用正确的 Cache-Control、Etag 和 Last-Modified 头部字段，这样可以节约一些浏览器下载时间。
*   花时间调整并优化您的 Web 服务器。这才是真正的魔法发生的地方！请记住，该过程要针对每个 Web 应用程序以及您要传输的数据的类型对症下药。
*   始终使用 TLS！特别是如果您的应用程序中有任何形式的身份验证。
*   研究浏览器在您的应用程序中提供并实施了哪些安全策略。

性能和安全性两者都是 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-outro) 中的一等公民。我们无法妥协的原因在于，一旦 SessionStack 集成到您的 Web 应用程序中，它就会开始监视从 DOM 更改、用户交互到网络请求，未处理的异常和调试消息的所有内容。所有数据都会实时传输到我们的服务器上，这样您就能够以视频的形式重现用户遇到的一切情况。 而这一切都是以最短的延迟进行的，不会对应用程序造成任何额外的性能开销。

这就是为何我们努力实践以上所有提示，以及我们将在未来发布的内容中讨论的更多内容。

如果你想[试一试 SessionStack](https://www.sessionstack.com/signup/)，这有一个免费的计划。

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### 参考资源

*   [https://hpbn.co/](https://hpbn.co/)
*   [https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886)
*   [https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513(v=vs.85).aspx](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513%28v=vs.85%29.aspx)
*   [http://www.internetlivestats.com/](http://www.internetlivestats.com/)
*   [http://vanseodesign.com/web-design/browser-requests/](http://vanseodesign.com/web-design/browser-requests/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
