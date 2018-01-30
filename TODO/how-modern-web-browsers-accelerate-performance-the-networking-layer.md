> * 原文地址：[How Modern Web Browsers Accelerate Performance: The Networking Layer](https://blog.sessionstack.com/how-modern-web-browsers-accelerate-performance-the-networking-layer-f6efaf7bfcf4)
> * 原文作者：[
>   Lachezar Nickolov](https://blog.sessionstack.com/@lsnickolov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-modern-web-browsers-accelerate-performance-the-networking-layer.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-modern-web-browsers-accelerate-performance-the-networking-layer.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[realYukiko](https://github.com/realYukiko) [MechanicianW](https://github.com/MechanicianW)

# 现代浏览器是如何提升性能的：网络层

49 年前，ARPnet 建立了。这是一个[早期的分组交换网络](https://en.wikipedia.org/wiki/Packet_switching)，也是第一个 [实现了 TCP/IP 协议簇](https://en.wikipedia.org/wiki/Internet_protocol_suite) 的网络。该网络建立了一个从加州大学到斯坦福研究院的连接。20 年后，Tim Berners-Lee（译注：万维网之父）分享了一个叫做 “Mesh” 的提案（译注：参看 [Information Management: A Proposal](https://www.w3.org/History/1989/proposal.html)），这在之后成为了我们所熟知的万维网（World Wide Web）。49 年间，因特网得到了长足发展，从仅仅是两台电脑间的数据分组交换，到现如今有超过 7500 万台服务器，38 亿个互联网用户，以及 13 亿个网站。

![](https://cdn-images-1.medium.com/max/800/1*x8P3OcgcgKrEEDpgT2IKkQ.jpeg)

本文中，我们将分析现代浏览器用来自动提升性能的技术（甚至你都感知不到这些技术），并且我们会聚焦于浏览器的网络层。我们也会提供一些使用浏览器提高你的 web 应用性能的思路。最后，我们也会分享一些我们在构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-6-webassembly-intro) 时的经验法则，这是一个轻量级、健壮且高性能的 JavaScript 应用，旨在帮助用户实时查看和复现他们的 web 应用缺陷。

我们都熟悉这 13 亿个网站在呈现一个用户友好页面时所用的技术。这次我们则聚焦于 web 浏览器。现代 web 浏览器被专门设计来交付快速、高效和安全的 web 应用程序或是网站。web 浏览器看起来更像是一个操作系统，而不仅仅是一个软件，因为有数以百计的组件运行在不同分层，从进程管理和安全沙箱，再到 GPU 管道，音视频等等。

浏览器的整体性能取决于这些大型组件：解析、布局、样式计算、JavaScript 和 WebAssembly 执行、渲染以及网络堆栈。网络堆栈（或者说网络协议栈）经常会被质疑是性能的瓶颈所在。这是因为在剩余步骤被解锁前，需要从因特网获得所有需要的资源。为了让网络层高效，网络堆栈需要扮演一个更为重要的角色，而不仅仅是个简单的 socket 管理员。网络层的资源获取的机制是简单浅显的，但机制以外，它还是一个拥有自己的优化法则、API 以及服务的完整平台。

![](https://cdn-images-1.medium.com/max/800/1*WqInzMPQGGcMX9AOONN76g.jpeg)

作为 web 开发者，我们不用关心各个 TCP 或者 UDP 报文，请求格式化、缓存等等正在进行的过程。这些复杂的东西都是浏览器的职责，这让我们可以专注于应用开发。但是，这也不妨碍我们多多少少去知道一些 web 浏览器的底层细节。事实上，这可以帮助我们创建更快、更安全的应用。

本质上，下面罗列的这些就是用户和浏览器交互的过程：

* 用户在浏览器地址栏输入了一段 URL。
* 浏览器从 URL 中获得了域名，再通过 [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) 请求到服务器的 IP 地址。
* 浏览器创建了一个 HTTP 报文，该报文说明了它将请求放在远程服务器上的 web 页面。
* 报文被送到了 TCP 层，TCP 层会在 HTTP 报文头部添加一些它自己的信息，该信息是保持会话的必需。
* 之后，报文又被送入了 IP 层，这一层的主要任务是指出如何将你的报文从本地发送到远端的服务器。这个信息也被保存在了报文头部。
* 报文被送到了远端服务器。
* 一旦报文被收到，服务端响应会被以同样形式送回。

这是一个针对于网络请求创建后发生了什么而做的高级概述。整个网络进程是非常复杂的，其中许多层都可能成为性能瓶颈。这也就是为何浏览器会致力于通过使用不同的技术手段来减小网络通信的开销，从而提高性能。

### socket 管理

让我们以几个技术开始：

* origin —— 一个含有应用协议、域名和端口的三元组（例如 https、[www.example.com](http://www.example.com)、443）
* socket 池 —— 一个同源 sockets 组（所有的主流浏览器都限制了池的大小不超过 6 个 socket）

JavaScript 和 WebAssembly 不允许我们管理单个报文的生命期，这可是件好事儿！这不仅让我们专注于应用开发，还允许浏览器自动进行一系列的性能提升，例如 socket 重用、设置请求优先级以及延迟绑定、协议协商、强制连接限制等等。事实上，现代浏览器已经极大地将请求管理循环从 socket 管理中分离出来。Socket 通过池进行组织，每个池容纳了同源的 socket，每一个 socket 池又都强制了连接限制和安全限制。待执行请求被放入队列并设置了优先级，之后会被绑定到池中单个 socket。除非服务器有意关闭了连接，否则相同的 socket 可以在多个请求中自动重用。

![](https://cdn-images-1.medium.com/max/800/1*_0F_8oL0vQQestOkKeRmAw.jpeg)

由于开启一个新的 TCP 连接会带来额外的性能开销，因此连接重用会为连接带来极大的性能收益。默认情况下，当一个请求建立后，为避免开启一个新的到服务器的连接产生的耗时，浏览器使用了 “keepalive” 机制。打开一个本地请求的 TCP 连接的平均时间为 23 ms，开启一个横贯大陆连接的平均时间为 120 ms，而开启一个洲际连接则为 225 ms。现在，想象浏览器已经创建了 10 个到服务器的连接，你大可自己算算要消耗多少时间。

这一架构为其他许多性能优化手段开启了大门。不同优先级的请求，将会被以不同的顺序执行。浏览器可以优化各个 socket 间的带宽分配，也可以依据请求打开新的 socket。

正如我之前提到的，这些都是通过浏览器进行管理，而不会要求开发者做任何的工作。但这并不意味着我们对于提升网络性能无能为力。选择正确的网络通信模式、类型、传输频率，以及服务器堆栈的选择和调试都将在应用的整体性能中扮演重要角色。

一些浏览器的能力甚至不仅于此。例如，Chrome 的自我学习手段能让你越用越快。它是基于用户已访问过的网站和具有代表性的浏览模式进行学习的，因此，它可以预估相似用户的行为，并且在用户什么都没做之前就进行优化。最简单的例子就是，当用户的鼠标滑过某个超链接时，Chrome 就预先渲染了这个链接对应的页面。如果你想要了解更多 Chrome 的优化手段，你可以阅读 [High-Performace Browser Networking](https://hpbn.co) 的这一章 [https://www.igvita.com/posa/high-performance-networking-in-google-chrome/](https://www.igvita.com/posa/high-performance-networking-in-google-chrome/)。

### 网络安全和沙箱化

允许浏览器对单独的 socket 进行管理还有另外一个重要目的：它为不受信任的应用资源强制开启了一连串的安全和策略限制。例如，浏览器不允许 API 直接访问原始的网络 socket，因为这将让任何恶意应用都能直连到任意主机。浏览器也强行限制了连接个数，目的在于防止服务器和客户端资源枯竭。

浏览器会对所有发出的请求进行格式化，借此强制协议语义的一致性和结构正确，从而保护服务器。类似地，响应解码也会自动完成，从而保护用户不受恶意服务器的侵害。

#### TLS 协议

[传输层安全（TLS）](https://en.wikipedia.org/wiki/Transport_Layer_Security) 是一个加密协议，它能够在计算机网络间提供通信安全。TLS 已经被广泛应用到了许多应用中，其中之一就是 web 浏览。网站可以使用 TLS 来保障服务器和 web 浏览器间的通信安全。

完整的 TLS 握手过程包含如下步骤：

1. 客户端发送了一个 “Client hello” 消息给服务器，并附上了客户端的随机数和支持的密文簇。
2. 服务器响应一个 “Server hello” 消息给客户端，并附上了服务端的随机数。
3. 服务器发送其证书给客户端用于认证，并且也请求客户端的证书。然后，服务器发送 “Server hello done” 消息。
4. 如果服务器向客户端请求了证书，则客户端就会发送证书。
5. 客户端创建了一个随机的 Pre-Master Secret，并且使用了从服务器证书中获得的公钥对其进行加密，之后发送加密后的 Pre-Master Secret 给服务器。
6. 服务器收到了 Pre-Master Secret。基于 Pre-Master Secret，服务器和客户端各自产生了 Master Secret 和 session keys。
7. 客户端发送了 “Change cipher spec” 通知到服务器，以此指明客户端将会开始使用新的 session keys 来加密消息和哈希化消息。客户端也会发送一个 “Client finished” 消息给服务器。
8. 服务器收到了 “Change cipher spec” 消息，然后将其记录层安全状态转换为使用 session key 的对称加密。然后服务器发送了 “Server finished” 消息给客户端。
9. 客户端和服务器现在可以在它们所建立的安全信道上进行应用数据的交换，所有客户端和服务器间的消息都使用了 session key 进行加密。

流程中如果有任何的校验失败 —— 例如服务器使用了自签名的证书，用户都将会被警告。

#### 同源策略

浏览器强制对应用程序能够初始化的请求在类型上做出了限制，也强制对请求的源做了限制。

上面罗列的也远不够完整。同源策略的目的在于强调 “最小特权” 原则生效了。浏览器只暴露了应用代码所必需的 API 和资源：应用所用的数据、URL，浏览器格式化了请求并且操纵了每个连接完整的生命周期。

值得注意的是，“同源策略” 尚没有一个简单的概念，取而代之的是，有一系列相关的机制来强制对 DOM 访问、cookie 和 session 状态管理、网络、以及另外一些的浏览器组件做出限制。如果你对此仍存有疑惑，我建议你看看 Michal Zalewski 的 [The Tangled Web](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886)。

### 资源及客户端状态缓存

最好、最快的请求就是不做请求。在分发一个请求前，浏览器会自动检查资源缓存并进行必要的校验，如果满足特定的条件，则直接返回本地缓存的资源备份。类似地，如果没有命中本地缓存中的资源，就会发送一个网络请求，得到的响应将自动地放入缓存中服务于后续的访问。

* 浏览器会自动评估每个资源的缓存指令
* 浏览器会在可能的时候自动对过期资源进行再验证
* 浏览器会自动管理缓存大小并进行资源回收

手动管理一个高效的，最优化的资源缓存是非常困难的。幸运地是，浏览器自己承担了这份复杂的工作，我们只需要保证我们的服务器返回正确的缓存指令即可。想要了解更多的话，可以参看 [Cache Resources on the Client](https://hpbn.co/optimizing-application-delivery/#cache-resources-on-the-client)。你为页面的所有资源都提供了一个 Cache-Control，ETag 以及 Last-Modified 响应头，对吧？

最后，浏览器的一个常被忽略却至关重要的功能就是提供了认证、session（会话） 和 cookie 管理。浏览器为每个源维护了相互隔离的 “cookie jars（饼干罐）”，并暴露了应用和服务器所需的 API 来读写新的 cookie、session 以及认证数据，又通过自动添加和处理了正确的 HTTP 头部来帮助我们实现整个过程的自动化。

#### 举个栗子：

一个简单的例证就是将 session 状态管理推迟到浏览器所带来的便捷：一个已认证的 session 可以在多个浏览器标签页或者窗口中共享，反之亦然。在某个标签页进行的登出操作也会让所有其他的标签页或者窗口中对应的 session 失效。

### 应用层 API 和 协议

顺着网络服务的梯子一步步爬，最终我们将到达应用层，接触到应用层 API 和 协议。

正如我们所看到的，较低层的网络层提供了应用广泛而又关键的服务：socket 和连接管理、请求和响应处理、各种强制性的安全策略、缓存等等。每当我们初始化一个 HTTP 或者 XMLHttpRequest、一个长期存活的 Server-Sent Event 或者 WebSocket 会话、或者打开了一个 WebRTC 连接，我们都会和这些底层服务交互。

当然，不存在一个最好的协议和 API。每个大型应用都会混合不同的传输方式，这是基于各种各样的需求：和浏览器缓存交互、协议过载、消息延迟、应用可靠性、数据传输类型等等。一些协议可能提供低延迟的交付能力（例如 Server-Sent Events、WebSocket），但这可能又不满足其他的关键准则，例如利用浏览器缓存的能力或者在所有场景下都支持高效的二进制传输。

概括下来，有以下手段可以提高你的 web 应用性能和安全：

* 总在你的请求头部使用 “Connection: Keep-Alive” 。浏览器默认会做这件事儿。你要确定你的服务器也使用了同样的机制。
* 使用合适的 Cache-Control、ETag 和 Last-Modified 头部，借此你可以节省不少浏览器下载时间。
* 花费一些时间来调试和优化你的 web 服务器。
* 总是使用 TLS！特别是如果你的应用程序使用了任意类型的认证手段。
* 研究一下你所用的浏览器都提供了哪些安全策略，并在你的应用中强制使用它们。
* 务必浏览下本文参考资料中提及的书籍。可以从其中学到其他的技术。

在 SessionStack 中，性能和安全同属一等公民。二者被置于如此高的层面进行考虑的原因是，一旦 SessionStack 嵌入你的 web 应用，它就开始记录你应用的每一件事儿，从 DOM 变化和用户交互，到未捕获的异常和 debug 信息。所有这些数据都实时地传入我们的服务器，这让你能够通过视频重现你应用的每个问题，看见每一件发生在用户身上的事儿。所有的这些都具有最小的延时，也不会对你的应用造成任何的性能过载。

这就是为什么我们致力于在 SessionStack 利用上述所有的，以及未来博文中将讨论的建议。

这里有一个免费计划让你[开始使用我们的产品](https://www.sessionstack.com/signup/)。

![](https://cdn-images-1.medium.com/max/800/1*8wanSMWsaiOFLjEBb-5j8g.png)

#### 参考资料

* [https://hpbn.co/](https://hpbn.co/)
* [https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886](https://www.amazon.com/Tangled-Web-Securing-Modern-Applications/dp/1593273886)
* [https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513(v=vs.85).aspx](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380513%28v=vs.85%29.aspx)
* [http://www.internetlivestats.com/](http://www.internetlivestats.com/)
* [http://vanseodesign.com/web-design/browser-requests/](http://vanseodesign.com/web-design/browser-requests/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
