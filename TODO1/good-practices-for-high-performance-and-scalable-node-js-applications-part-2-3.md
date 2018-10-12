> * 原文地址：[Good practices for high-performance and scalable Node.js applications [Part 2/3]](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3-2a68f875ce79)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3.md)
> * 译者：
> * 校对者：

# Node.js 高性能和可扩展应用程序的最佳实践[第 2/3 部分]

![](https://cdn-images-1.medium.com/max/2000/1*dt7IyIBFHQIBwf7_aW861Q.jpeg)

### 第 2 章 —— 如何使您的 Node.js 应用程序可扩展

在[上篇文章](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3-bb06b6204197)中，我们学会了不必担心代码出错，水平扩展 Node.js 应用程序。本章中，我们将讨论扩展时必须注意的事项，以便在扩展流程时防止错误发生。

### 从 DB 中分离应用程序实例

第一个提示不是关于代码，而是关于你的**基础架构**。

如果希望应用程序能够跨不同主机进行扩展，则必须在独立计算机上部署数据库，以便可以根据需要自由复制应用程序计算机。

![](https://cdn-images-1.medium.com/max/800/1*uSNVUpjeSG8H8AUK8-Yv7A.png)

在同一台机器上部署应用程序和数据库可能很便宜并且用于开发目的，但绝对不建议用于生产环境，其中应用程序和数据库必须能够独立扩展。这同样适用于像 Redis 这样的内存数据库。

### 无状态

如果您生成应用程序的多个实例，**每个进程都有自己的内存空间**。这意味着即使您在一台机器上运行，当您在全局变量中存储某些值，或者更常见的是在内存中存储会话时，如果平衡器在下一个请求期间将您重定向到另一个进程，您将无法在那里找到它。

这适用于会话数据和内部值，如任何类型的应用程序范围设置。

对于可在运行时更改的设置或配置，解决方案是将它们存储在外部数据库（存储或内存中）上，以使所有进程都可以访问它们。

### 使用 JWT 进行无状态身份验证

身份验证是开发无状态应用程序时要考虑的首要主题之一。如果将会话存储在内存中，它们将作用于该单个进程。

为了使工作正常，您应该将网络负载均衡器配置为始终将同一用户重定向到同一台计算机，并将本地用户重定向到同一用户始终重定向到同一进程（粘性会话）。

解决此问题的一个简单方法是将会话的存储策略设置为任何形式的持久性，例如将它们存储在DB而不是RAM中。但是，如果您的应用程序检查每个请求的会话数据，则每次API调用都会有磁盘 I/O，从性能的角度来看，这绝对不是好事。

更好，更快的解决方案（如果您的身份验证框架支持它）是将会话存储在像Redis这样的内存数据库中。Redis 实例通常位于应用程序实例外部，例如 DB 实例，但在内存中工作会使其更快。无论如何，在 RAM 中存储会话会使您在并发会话数增加时需要更多内存。

如果您想采用更有效的无状态身份验证方法，可以查看 **JSON Web 令牌**。

JWT 背后的想法很简单：当用户登录时，服务器生成一个令牌，该令牌本质上是包含有效负载的 JSON 对象的 base64 编码，加上签名获得的散列，该负载具有服务器拥有的密钥。 有效负载可以包含用于对用户进行身份验证和授权的数据，例如 userID 及其关联的 ACL 角色。令牌被发送回客户端并由其用于验证每个 API 请求。

当服务器处理传入请求时，它会获取令牌的有效负载并使用其密钥重新创建签名。 如果两个签名匹配，则可以认为有效载荷有效并且不被改变，并且可以识别用户。

重要的是要记住**JWT 不提供任何形式的加密**。 有效负载仅在 base64 中编码，并以明文形式发送，因此如果您需要隐藏内容，则必须使用 SSL。

[jwt.io](http://jwt.io) 借用的以下模式恢复了身份验证过程：

![](https://cdn-images-1.medium.com/max/800/1*7T41R0dSLEzssIXPHpvimQ.png)

在认证过程中，服务器不需要访问存储在某处的会话数据，因此每个请求都可以由非常有效的方式由不同的进程或机器处理。RAM 中没有保存数据，也不需要执行存储 I/O，因此在扩展时这种方法非常有用。

###存储在S3上

使用多台计算机时，无法将用户生成的资产直接保存在文件系统上，因为这些文件只能由该服务器本地的进程访问。 解决方案是将所有内容存储在外部服务**上，可能存储在像 Amazon S3 这样的专用服务上，并在数据库中仅保存指向该资源的绝对 URL。

![](https://cdn-images-1.medium.com/max/800/1*kmIPoA7Ab60n4kO36LWtNQ.png)

然后，每个进程/机器都可以以相同的方式访问该资源。

使用Node.js的官方 AWS sdk非常简单，您可以轻松地将服务集成到应用程序中。S3 非常便宜并且针对此目的进行了优化，在您的应用程序不是多进程的情况下也是一个不错的选择。

###正确配置 WebSockets

如果您的应用程序使用 WebSockets 进行客户端之间或客户端与服务器之间的实时交互，则需要链接后端实例**以便在连接到不同节点的客户端之间正确传播广播消息或消息。

Socket.io 库为此提供了一个特殊的适配器，称为 socket.io-redis，它允许您使用 Redis pub-sub 功能链接服务器实例。

为了使用多节点 socket.io 环境，您还需要强制协议为 “websockets”，因为长轮询需要粘性会话才能工作。

### 下一步

在这篇简短的文章中，我们已经看到了一些关于如何扩展 Node.js 应用程序的简单方面，这对于单节点环境也可以被视为良好实践。

在本系列的下一篇文章（也是最后一篇文章）中，我们将看到一些可以使您的应用程序表现更好的其他模式。你可以在[这里](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-3-3-c1a3381e1382)找到它。

* * *

_如果这篇文章对你有用，请给我点赞吧！_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。