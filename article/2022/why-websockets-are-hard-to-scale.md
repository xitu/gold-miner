> * 原文地址：[why Websockets are Hard To Scale？](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267)
> * 原文作者：[nooptoday](https://dev.to/nooptoday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/why-websockets-are-hard-to-scale.md](https://github.com/xitu/gold-miner/blob/master/article/2022/why-websockets-are-hard-to-scale.md)
> * 译者：[CompetitiveLin](https://github.com/CompetitiveLin)
> * 校对者：[CarlosChenN](https://github.com/CarlosChenN) [Quincy-Ye](https://github.com/Quincy-Ye)

![Cover image for Why Websockets are Hard To Scale?](https://res.cloudinary.com/practicaldev/image/fetch/s--MeJ0-6T_--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c44dw0f0iguuiho1sn5c.jpeg)

## 为什么 Websockets 难以扩展？

封面图片来自于 [法比奥](https://unsplash.com/@fabioha)

Websockets 提供了一个重要的特性：双向通信。这使得服务器在不需要客户机请求的情况下向客户机**推送**事件。

Websockets 这种**双向**的特性是一把双刃剑！尽管这种特性为 websockets 提供了大量的用例，但与 HTTP 服务器相比，实现一个可伸缩的 websockets 服务器要困难得多。

> _无耻的自我推销：_ 我认为 websockets 是 web 网页的一个重要部分并且它们需要在软件开发界得到更多的认可。我正在计划发布更多的有关于 websockets 的文章。如果你不想错过这些文章，你可以访问 [https://nooptoday.com/](https://nooptoday.com/) 并且订阅我的邮箱列表！

___

## [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#what-makes-websockets-unique)是什么让 Websockets 如此独一无二?

Websocket 是一个应用层的协议，就像 HTTP 是另外一个应用层的协议一样。这两个协议都是通过 TCP 连接实现的。但是他们有不同特点，就像他们代表着通信世界的两个不同国家（如果这样形容能让你理解的话）。

HTTP 带有基于请求—响应的通信模型的标志，Websocket 带有双向通信模型的标志。

> 附注：为了更清晰地描述 Websocket，你将在文章中看到 HTTP 和 Websocket 的对比。但这并不意味着它们是相互竞争的协议，相反，它们都有自己的用例。

**Websocket 的特点：**

-   双向通信
-   长期的 TCP 连接
-   有状态的协议

**HTTP 的特点：**

-   基于请求响应的通信
-   短期的 TCP 连接
-   无状态的协议

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#stateful-vs-stateless-protocols)有状态 vs. 无状态协议

我相信你看过一些关于创建无状态、可无限扩展的后端服务器的文章。这些文章会告诉你使用 JWT 令牌进行无状态的身份验证，并在无状态应用程序中使用 lambda 函数等。

-   这些文章所谈论的**状态**是什么？当涉及到扩展服务器应用程序时，为什么它如此重要？

**状态**是你的应用程序为了正确运行所必须记住的所有信息。例如，你的应用程序应该记住已经登录的用户。99% 的应用程序都这么做并且它被成为会话管理。

-   OK，状态真是一个很好的东西！那为什么人们讨厌它并且总是试图做出**无状态的应用**呢？

你需要在某些地方存储你的状态，而那个地方通常是服务器的内存。但是你的应用服务器的内存对于其他服务器来说是不可访问的，那么问题就来了。

想象这样一个场景：

-   **用户 A** 向**服务器 1** 发起请求。**服务器 1** 授权给**用户 A**，接着在内存中存储它的**会话 A**。
-   **用户 A** 向**服务器 2** 发起第二个请求。**服务器 2** 搜索保存的会话，但是无法找到**会话 A**，因为它被存储在**服务器 1** 内部。

为了让你的服务器变得可扩展，你需要在应用程序之外管理状态。例如，你可以将会话保存到 Redis 实例中。这使得应用程序状态可以通过 Redis 对所有服务器可用，并且**服务器 2** 可以从 Redis 读取**会话 A**。

___

**有状态的 Websocket：** 打开 Websocket 连接就像客户端和服务器之间的婚礼：连接一直保持打开状态，直到其中一方关闭它（当然，或者由于网络条件欺骗它）。

**无状态的 HTTP：** 另一方面，HTTP 是一个令人心碎的协议，它希望尽快结束所有事情。打开 HTTP 连接后，客户端发送请求，服务器一响应，连接就会关闭。

OK，我不开玩笑了，但是记住，Websocket 连接**通常**是长连接，而 HTTP 连接注定是尽早结束的。当你把 Websocket 引入到你的应用程序时，它就变成了**有状态的**。

#### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#in-case-you-wonder)如果你想知道

尽管 HTTP 和 Websocket 都构建在 TCP 之上，但一个是无状态的，而另一个是有状态的。为了简单起见，我不想让你对 TCP 的细节感到困惑。但是请记住，即使在 HTTP 中，底层 TCP 连接也可能存在很长时间。这超出了本文的范围，但你可以在[这里](https://en.wikipedia.org/wiki/HTTP_persistent_connection)学到更多。

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#cant-i-just-use-a-redis-instance-to-store-sockets)我不能只使用一个 Redis 实例来存储套接字吗？

在上一个有关会话的例子中，其解决方法很简单。使用外部服务来存储会话，这样其他所有服务器都可以从那里读取会话（Redis 实例）。

Websockets 是一个不同的例子，因为你的状态不仅仅是关于套接字的数据，所以不可避免地要在服务器中存储**连接**。每个 websocket 连接都绑定到一台服务器上，其他服务器无法向该连接发送数据。

现在，第二个问题来了，你必须有一种方法让其他服务器发送消息到 websocket 连接。为此，您需要一种在服务器之间发送消息的方法。幸运的是，这已经有一个称为**消息代理**的东西。你甚至可以使用 Redis 的发布/订阅机制在你的服务器之间发送消息。

让我们总结一下目前为止我们讨论的内容：

-   Websocket 连接是有状态的
-   Websocket 服务器自动成为有状态的应用程序
-   为了使有状态应用程序能够扩展，您需要有一个外部状态存储（例如：Redis）
-   Websocket 连接绑定到单个服务器
-   服务器需要连接到消息代理，将消息发送到其他服务器中的 websockets

（就这样吗？添加一个 Redis 实例到我的堆栈就可以解决了所有的 Websockets可伸缩的问题？）

不幸的是，不是的。好吧，可伸缩的 websocket 架构还有另一个问题：**负载均衡**

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#load-balancing-websockets)Websockets 的负载均衡

负载均衡是确保所有服务器共享同等负载的一项技术。在普通的 HTTP 服务器中，这可以通过简单的算法例如轮询来实现。但这对于 Websocket 服务器来说并不理想。

想象一下你拥有一个自动伸缩的服务器组，这意味着，随着负载的增加，新的实例将会被部署，而随着负载的减少，一些实例将被关闭。

因为 HTTP 请求的生存时间很短，因此即使添加或删除服务器，所有实例之间的负载也会均衡一些。

Websocket 连接的生存时间很长（持久的），这意味着新服务器不会从旧服务器上减轻负载。因为，旧服务器仍然坚持它们的 websocket 连接。举个例子，假设**服务器 1** 拥有 1000 个开放的 websocket 连接。理想情况下，当添加一个新的服务器**服务器 2** 时，你希望将 500 个 websocket 连接从**服务器 1** 转移到**服务器 2**。但这对于传统的负载平衡器来说是不可能的。

你可以断开所有的 websocket 连接，并期望客户端重新连接。然后你就可以在你的服务器上实现 500 / 500 个 websocket 连接的分布方案，但这是一个糟糕的解决方案，因为：

1.  服务器将受到重连接请求的狂轰滥炸，服务器负载将大幅波动
2.  如果频繁地扩展服务器，客户端将频繁地重新连接，这可能会对用户体验产生负面影响
3.  这不是一个优雅的解决方案，（我知道你们关心这个！）

这个问题最优雅的解决方法被称为：一致性哈希

## [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#load-balancing-algorithm-consistent-hashing)负载均衡算法：一致性哈希

如今有各种各样的负载均衡算法，但一致性哈希来自另一个世界。（图片白纸上的内容译为“一致性哈希真的很棒！请改变我的这个想法。”） 
[![meme about consistent hashing](https://res.cloudinary.com/practicaldev/image/fetch/s--5P8luiyt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://nooptoday.com/content/images/2022/12/image-1.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--5P8luiyt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://nooptoday.com/content/images/2022/12/image-1.png)  
使用一致性哈希的负载均衡背后的基本思想是：

-   对即将到来并带有某些属性的连接进行哈希操作，就比如**用户 ID => 哈希值**
-   然后你可以用**哈希值**来确定该用户应该连接到哪个服务器

这里假设你的哈希函数将**用户 ID** 均匀分配到**哈希值**。

但是！总是有一个但是，不是吗？现在在添加或删除服务器时仍然存在这个问题。解决方案是在添加或删除新服务器时断开连接。

（等一下，什么！你刚刚还说这个一个坏主意？现在怎么又变成了解决方案了呢？）

这个解决方案的美妙之处在于，使用一致性哈希，你不必断开所有连接，而只需删除部分连接。实际上，你需要断开多少连接就断开多少连接。让我用一个场景来解释：

-   最开始， **服务器 1** 有 1000 个连接
-   新增**服务器 2**
-   一旦新增了**服务器 2**，**服务器 1** 就会运行重新平衡算法
-   重新平衡算法检测哪些 websocket 连接需要断开，如果我们的哈希函数检测到大约 500 个连接需要到**服务器 2**
-   **服务器 1** 向这 500 个客户端发出重新连接消息，然后它们连接到**服务器 2**。

[这是ByteByteGo的一个很棒的视频](https://www.youtube.com/watch?v=UF9Iqmg94tk)，这个视频从视觉上解释了这个概念。

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#a-much-simpler-and-efficient-solution)一个更简单且高效的解决办法

Discord 管理大量 Websocket 连接。他们是如何解决负载均衡的问题？

如果你研究了[开发者文档](https://discord.com/developers/docs/topics/gateway#get-gateway)关于如何建立 websocket 连接，下面是他们是如何做到的：

-   发送一个 HTTP 的 GET 请求到  `/gateway` 端点，接收可用的 Websocket 服务器 url。
-   连接到 Websocket 服务器。

这个解决方案的神奇之处在于，你可以控制新客户端应该连接哪台服务器。如果添加新服务器，则可以将所有新连接定向到新服务器。如果你想将 500 个连接从**服务器 1** 移动到**服务器 2**，只需从**服务器 1** 删除500个连接，并从 `/gateway` 端点提供**服务器 2** 地址。

`/gateway` 端点需要知道所有服务器的负载分布，并据此做出决策。以最小的负载直接返回服务器的 url。

与一致散列相比，这种解决方案有效且简单得多。但是，一致哈希方法不需要知道所有服务器的负载分布，也不需要事先进行 HTTP 请求。因此，客户端可以更快地连接，但这通常不是一个重要的考虑因素。此外，实现一致的哈希算法也很棘手。这就是为什么，我计划后续写一篇关于为负载均衡 Websockets 实现一致性哈希的文章。

我希望你能从这篇文章中学到一些新的东西，请在评论中告诉我你的想法。如果你不想错过新的文章，你可以订阅邮件列表！



> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
