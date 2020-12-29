> - 原文地址：[Fundamentals of Caching Web Applications](https://blog.bitsrc.io/fundamentals-of-caching-web-applications-a215c4333cbb)
> - 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/fundamentals-of-caching-web-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2020/fundamentals-of-caching-web-applications.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[Usualminds](https://github.com/Usualminds) [ZavierTang](https://github.com/ZavierTang)

# Web 应用缓存的基础知识

![Photo by [Yuiizaa September](https://unsplash.com/@yuiizaa?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9458/0*0OwYJoWVEwP_rPjk)

Web 应用至今已经走过了漫长的道路。典型的 web 应用开发要经过设计、开发和测试之后才能发布。一旦你的 web 应用程序发布，现实生活中的用户每天都会访问它。如果你的 web 应用变得流行起来，每天至少会有数百万用户访问它。虽然这听起来令人兴奋，但这将耗费大量的运行成本。

除了运行成本，复杂的计算和读写操作都需要花费时间去完成。这意味着用户需要等待这些操作完成，如果等待时间过长，用户体验会很糟糕。

系统设计人员使用几种方案来改善这些问题。**缓存** 是其中的方案之一。让我们来更好地了解一下缓存。

## Web 应用里的缓存是什么？

web 缓存只是一个能够临时存储 HTTP 响应的机制，只要满足某些条件，就可以将其用于后续的 HTTP 请求。

Web 缓存是 HTTP 协议的一个关键设计特性，目的是减少网络流量，同时提升整个系统的预期响应速度。缓存存在于从服务器到浏览器的每一个阶段。

简单地说，在接收到类似性质的 HTTP 请求时，web 缓存能够复用存储在缓存中的 HTTP 响应。让我们思考一个简单的例子，用户从服务器请求某种类型的产品(书籍)。假设整个过程大约需要 670 毫秒。如果这个用户在当天晚些时候执行相同的查询，不会再次执行相同的计算并花费 670 毫秒，而是将存储在缓存中的 HTTP 响应直接返回给用户。这将大大减少响应时间。在现实场景中，这个响应时间可能不到 50 毫秒。

## 缓存的优点

从用户和开发者的角度来看，缓存有几个优点。

#### 降低带宽成本

如前所述，客户端到服务端的 HTTP 请求路径的各个点都可以缓存内容。内容缓存离客户越近，传输距离就越短，带宽消耗就越少。

#### 提升响应速度

由于缓存维护在离用户更近的地方，因此不需要往返于服务器之间。缓存越近，响应就越快。这对提升用户体验有显著的效果。

#### 提高了在同一硬件上的性能

由于缓存为类似的请求提供了服务，服务器硬件可以专注于其他需要处理能力的请求。主动缓存可以进一步提升这种性能。

#### 网络故障内容依然可访问

当使用某些缓存策略时，在服务器发生故障的情况下，可以在短时间内将内容从缓存提供给终端用户。这可能非常有用，因为它允许用户执行基本任务，而不会受到源服务器故障的影响。

## 缓存的缺点

与优点类似，缓存也有几个缺点。

#### 服务器重新启动时缓存会被删除

只要重新启动服务器，缓存数据也会被删除。这是因为缓存是不稳定的，当电源断掉时就会丢失。但是你可以维护策略，即你可以定期将缓存写入磁盘，以便在服务器重新启动期间持久化缓存的数据。

#### 提供过期的数据

缓存的主要问题之一是提供过期的数据。过期数据是指未更新且包含以前版本的数据。如果缓存了一个产品查询，但同时产品管理员删除了四个产品，用户将获得不存在的产品清单。这个问题很难识别和解决。

## 缓存的应用场景

如前所述，内容可以缓存在请求路径中的不同位置。

#### 浏览器缓存

Web 浏览器自身保留了一个小型缓存。通常，浏览器会通过设置策略来缓存最重要的内容。这可能是特定于用户的内容，或者下载成本较高且很可能被重新使用的内容。若要禁用资源的缓存，可以设置如下的响应头。

```
Cache-Control: no-store
```

#### 第三方缓存代理

位于用户设备和服务器基础设施之间的任何服务器都可以根据需要缓存内容。这些缓存可能由 ISPs 或其他独立机构维护。

#### 反转缓存

你可以在后端服务中实现自己的缓存基础设施。使用这种方法可以从外部连接点提供内容，而不需要经过后端服务器。你可以使用 Redis、Memcache 这样的服务来实现。

在[这里](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#Controlling%20caching)阅读更多的关于 `Cache-Control` 的知识。

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)](https://cdn-images-1.medium.com/max/2000/0*QaYpasQXpfIKwiTV.png)

## 能缓存什么？

所有类型的内容都可以缓存。可以缓存并不意味着应该被缓存。

#### 应该缓存

下面的内容应该缓存，因为它们不经常变化，因此可以缓存更长的时间。

- 媒介内容
- JavaScript 库
- 样式表
- 图片、Logo、图标

#### 适度缓存

下面的内容可以缓存，但是要格外小心，因为这些类型的内容可能定期更改。

- 经常修改的 JS 和 CSS
- HTML 页面
- 带有身份验证 cookie 的内容请求

#### 不应该缓存

以下类型的内容永远不应该被缓存，因为它们可能会导致安全问题。

- 高度敏感的内容，如银行信息等。
- 特定于用户的通常不应该被缓存，因为它是经常更新的。

## 为什么需要缓存策略？

在实际情况中，你不能实现主动缓存，因为大多数时候它可能会返回未更新的数据。这就是为什么应该需要一个定制的缓存策略来平衡和实现长期缓存，并且通过实现与之匹配的缓存回收算法来响应站点的内容更新。由于每个系统都是独特的，并且有自己的一系列需求，因此应该花充足的时间来创建缓存策略。

实现一个完美的缓存策略的关键是尽可能地促进积极有效的缓存，同时留出余地，在将来站点内容更新时使缓存失效。

---

本文的目的是向你介绍 web 应用程序中缓存的基本原理。我跳过了一些主题，如控制头、缓存基础配置、开发缓存策略的指导方针等，因为它们对于本文的介绍来说有点太高级了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
