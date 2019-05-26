> * 原文地址：[Will Node.js forever be the sluggish Golang?](https://levelup.gitconnected.com/will-node-js-forever-be-the-sluggish-golang-f632130e5c7a)
> * 原文作者：[Alex Hultman](https://medium.com/@alexhultman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/will-node-js-forever-be-the-sluggish-golang.md](https://github.com/xitu/gold-miner/blob/master/TODO1/will-node-js-forever-be-the-sluggish-golang.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[Endone](https://github.com/Endone)，[JasonLinkinBright](https://github.com/JasonLinkinBright)

# Node.js 会永远只是慢的 Golang 吗？

> 这篇文章展示的 Node.js 新扩展将颠覆这种情况

你似乎总是不可避免地听到下一个据称更快的所谓 Node.js “Web 框架”。是的，我们都知道 Express 很慢，但是存在另一个 “Web 框架”能真正**提升** I/O 性能吗？答案是否定的，除了避免 Express 的运行开销外，这些新框架在 I/O 性能上并不能做的更多。想要走的更远，就需要对 Node.js 深入挖掘并重新设计，而不仅仅是在其基础上加新的一层。

Express 是 Node.js 生态中最古老的所谓“网络框架”之一。它构建在由 Node.js 所提供的开箱即用功能的基础之上，并提供了一个以 App 为中心的接口来管理 URL、路由、参数、方法等。

当然，它既高效又优雅，但是在性能方面却不尽人意。最近还浮现出像 Fastify 以及其它数百个类似的网络框架。它们都旨在以较低的性能损失来提供 Express 中的功能。需要指出的是；这是一种性能的**损失**而不是提升。它们仍然被严格限制在 Node.js 所能提供的范围内，这与其竞争对象相比还远远不够：

![](https://cdn-images-1.medium.com/max/2000/1*1MrkEKoWL7MnDYuY3dk8aA.png)

无论是 Fastify 还是其它所谓基于 Node.js 的 “Web 框架”都不能越过 Node.js 的红线。相对于像 Golang 这样热门的选择方案来说，这样的**上限**可以说是相当低了。

幸运的是，Node.js 支持 C++ 扩展，Google 的 V8 绑定把 JavaScript 链接到 C++ 并且允许你的 JavaScript 代码调用其任何行为，甚至是 Node.js 本身并不提供的行为。

这使得扩展 JavaScript 成为可能。并提供了全新的视角去探索 JavaScript 的更多用途，使之可以充分发挥 Google V8 的功能，而不用限制于 Node.js “核心开发者” 所认为的足够好的功能。

### 发布新的 µWebSockets.js

我将发布全新的代码 µWebSockets.js，今天就可以在 Github 上看到：[https://github.com/uNetworking/uWebSockets.js](https://github.com/uNetworking/uWebSockets.js)。

* 使用 NPM 安装 Node.js（尽管托管在 GitHub 上）：npm install uNetworking/uWebSockets.js#v15.0.0，可以查看 NPM 安装文档。
* 不需要编译器；适用于 Linux，macOS 和 Windows。我们从 15.0.0 版本开始并根据 SemVer 递增。

它是另一个用于 JavaScript 后端的 Web 服务，由大概 6 千行 C 和 C++ 代码编写，在性能方面极大的超过了 Golang。Bitfinex.com 已经把他们的交易接口（REST 和 WebSocket）迁移到了这个服务并且正在逐步将之投入生产。

> 来自 Bitfinex 的 Paolo Ardoino 特别提到：“这是一个非常酷的项目”。

> **这项工作得以完成，需要感谢这些赞助者；BitMEX、Bitfinex 和 Coinbase 使这项工作成为可能。多亏了他们，我们现在有了一个新的版本！**

### 请解释下，这到底是怎么回事？

这是在新的代码许可 Apache 2.0 协议下一个新的项目，是所谓 “uws” 的继任者。它是一个完整的栈，从系统内核到 Google V8 引擎，为 Node.js 带来稳定，安全，符合标准，快速且轻量级的 I/O：

![](https://cdn-images-1.medium.com/max/2462/1*s3YLN_-95DbHflLKOOahoQ.png)

在这个层级的软件设计中，其中的每一层都只依赖先前的层级，这使得无论是追踪和修复问题还是扩展新的支持变得很简单。

µSockets 其本身甚至还有 3 个子层级，从 **eventing** 到 **networking** 再到 **crypto**，每一个子层只知道前面的层级。这使得更换部件，修复问题和添加替代的实现都不需要更改任何高层的代码。

对 OpenSSL 感到疲倦了？那好，通过替换 ssl.c 和 它的 600 行代码就可以替换 OpenSSL。其它层甚至都不用知道 SSL 是什么，因此很容易定位错误。

![Internal sub layers of µSockets](https://cdn-images-1.medium.com/max/2000/0*KYceR1fpeHeUZE2E.png)

这和 Node.js 的实现有很大的不同，其设计的实现为“把一切都堆在一起”。在 Node.js 的一个源文件中，你可以找到 libuv 调用，系统调用，OpenSSL调用，V8 调用。这一切都混成一团而没有试图去接耦分离使模块独立。这使得它很难做出任何真正的改变。

### 简而言之，为 µWebSockets.js 编码

以下是一个 µWebSockets.js 的非常简化的实现，为了简洁起见省略了很多概念，但是应该能让你大概知道 µWebSockets.js 是什么：

![](https://cdn-images-1.medium.com/max/2000/1*I6jsm23tYBFIJGxZKB07bg.png)

在某些方面相比于 Golang 的 Gorilla Gorilla，在 SSL 和 非 SSL 基础上它可能表现的更好。也就是说，SSL 基础上的 JS 代码可以比非 SSL 基础上的 Golang（在某些方面）更快的发送消息。我认为这真的很酷。

### 快速的发布/订阅支持

Socket.IO 在很多方面就是 Express 的“实时”等价物。它们都同样的古老，优雅且受欢迎，但是也**非常**的慢：

![](https://cdn-images-1.medium.com/max/2098/1*dY6cHErkXrqFiyJS7IrR1g.png)

大部分 Socket.IO 所能帮助你的功能可以归纳为发布/订阅，即向包含多个接收者的房间发送信息的功能，以及与之对应接收消息的功能。
>Fallbacks 在今天没有任何意义，因为每个浏览器都支持 WebSockets，而且这种情况已经持续很多年了。SSL 的流量不会被企业的代理劫持，并且将像任何 Http 流量一样通过，所以 SSL 上的 WebSockets 肯定不会被阻塞。你仍然可以有 fallbacks，但是它们毫无意义并且会产生不必要的复杂性。

μWebSockets.js 的一个目标是提供类似于 Socket.IO 中的功能，使之有可能被完全替代，而不是在其顶部包装一层。但这并不是强制执行任何特定的非标准协议。

大多数公司当遇到 WebSockets 时都在和某些发布/订阅的问题作斗争。遗憾的是，高效的发布/订阅服务并没有在这次发布的最后期限提供，但是它马上就要来了，以非常高的优先级。它会非常快（基准测试中已经比 Redis 更快了）。注意！

### 现在发生了什么？

优化，添加特性和修正错误。刚开始开发，可能不能够完全适应，所以需要有一些相关的介绍。请记住，它是一个由三个不同的仓库组成包含成千上万行代码的大型项目：

* [https://github.com/uNetworking/uWebSockets.js](https://github.com/uNetworking/uWebSockets.js)（JavaScript 包装层）
* [https://github.com/uNetworking/uWebSockets](https://github.com/uNetworking/uWebSockets)（C++ 网络服务）
* [https://github.com/uNetworking/uSockets](https://github.com/uNetworking/uSockets)（C 基础库）

一些在 I/O 上有巨大压力的公司在使用这个项目。稳定性和安全性（自然且明显的）是这个项目的**最高**优先级。记住要在早期的发布版本中报告稳定性方面的问题，因为这个发布版本是包含大量更改的大版本。

如果你作为一家公司认为这个项目是有意义的，并且是有经济利益的，那么请确保和我们取得联系。我将提供各种各样的咨询工作。请联系：[https://github.com/alexhultman](https://github.com/alexhultman)

谢谢！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
