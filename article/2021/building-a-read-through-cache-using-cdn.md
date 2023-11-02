> * 原文地址：[Building a read-through cache using CDN](https://levelup.gitconnected.com/building-a-read-through-cache-using-cdn-59988a3d75ce)
> * 原文作者：[Aritra Das](https://medium.com/@dev.aritradas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-read-through-cache-using-cdn.md](https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-read-through-cache-using-cdn.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[zaviertang](https://github.com/zaviertang)

# 使用 CDN 构建直读式缓存

![由 Pikisuperstar / Freepik 设计](https://cdn-images-1.medium.com/max/3000/1*vEUuzXh0fRgDxebH95faWg.png)

当你为需要高吞吐量的系统构建 API 时，缓存几乎是不可避免的。在分布式系统上工作的每个开发者多多少少都在某些时候使用了一些缓存机制。在本文中，我们将了解使用 CDN 构建直读式缓存的设计。这种做法不仅优化了 API，还能降低基础架构成本。

> 拥有一些关于缓存和 CDN 的了解将有助于理解这篇文章。如果你完全没有了解过这些知识的话，我希望你先稍微了解一点这些知识，然后再回来阅读这篇文章。

## 一点背景

在撰写本文时，我正与 [Glance](https://www.glance.com/) 合作。Glance 是世界上最大的基于锁屏的内容发现平台，在这一领域上有大约 1.4 亿个活跃的用户。所以你可以想象我们需要运行的服务的规模之大。而且在这种规模中，即使是最简单的事情也能变得超级复杂。作为后端开发者，我们始终努力建立高度优化的 API，为用户提供良好的体验。故事从这里开始，讲述我们如何面对确切的问题，然后我们又是如何解决这些问题的。我希望在阅读本文后，你能在大规模的系统设计上学有所成。

## 问题

我们需要开发一些具有以下特征的 API：

1. 数据不会经常变化。
2. 所有用户的响应是相同的，没有意外的查询参数，简单直接获取 API。
3. 最大响应数据量为 600 kB。
4. 我们预计 API 会有预期非常高的吞吐量（大约每秒 5～6 万次请求）。

那么你起初看到这个问题时，你想到了什么？对我来说，只要在节点上（由于数据量低）往 API 中添加内存缓存（可能是 Google Guava），使用 Kafka 发送无效消息（因为我喜欢 Kafka 😆 并且它是可靠的），设置为服务实例启动规模自动调节（因为整个日间的流量并不统一）。如图所示：

![设计 v1](https://cdn-images-1.medium.com/max/2000/1*F60S9SCN5JVmgutDCOwPKg.jpeg)

bam！问题解决了！很容易吗？好吧，其实并非如此。正如任何其他设计一样，这一个设计其实也有一些缺陷。例如，这个设计对于简单用例而言有一点点太复杂了，基础设施成本上升了 —— 我们现在需要构建一个 Kafka + Zookeeper 集群，再加上 5 万次请求每秒的规模，我们需要水平缩放我们的服务实例（对我们而言是 Kubernetes Pods）。这将转化为裸机节点或虚拟机数量的增加。

因此，我们寻找更简单且具有成本效益的方法，这就是我们为何最终会采用“使用 CDN 直读式缓存”这一解决方案。我将讨论架构的细节以及稍后的权衡。

---

但在进一步阐述之前，让我们先了解设计的构建块。

## 通过缓存读取

标准缓存更新策略是这样的

1. **Cache aside**
2. **Read-through**
3. **Write-through**
4. **Write back**
5. **Refresh ahead**

我不会详细介绍其他策略，而是专注于直读，毕竟这篇文章就是讲这个的。让我们进一步进行挖掘，了解它的工作原理。

> user1  -> 只是一个想象中的试图获取的数据

![](https://cdn-images-1.medium.com/max/2000/1*CZ3W153osigEQh1u09NFNQ.png)

上图不言自明，用于总结上文。

1. 应用程序从未直接与数据库进行交互，而是始终与缓存交互。
2. 没有缓存时，将从数据库读取并丰富缓存。
3. 有缓存时，数据来自缓存。

你可以看到，数据库的访问频率很低，并且由于我们的缓存主要都是内存缓存（REDIS / MEMCACHED），因此响应很快。现在我们已经解决了不少问题 😅

## CDN

网上关于 CDN 的定义是：“**内容分发网络（CDN）是一个全局分布的代理服务器网络，从靠近用户的位置服务于内容，并且用于提供诸如图像、视频、HTML、CSS 之类的静态文件**“。但我们将反向使用 CDN 并为用户提供动态内容（JSON 响应，而不是静态的 JSON 文件）。

此外，通常有两种 CDN 的概念

1. **Push CDN**：负责将数据上传到 CDN 服务器
2. **Pull CDN**：CDN 将从你的服务器（原始服务器）中提取数据

我们将使用Pull CDN，因为使用推送方法需要我处理重试、幂等性和其他事项，这对我来说是额外的麻烦，而且对于这个用例并没有真正增加任何价值。

## 把 CDN 当作直读式缓存

这个想法很简单，我们将 CDN 作为用户和实际后端服务之间的缓存层。

![设计 v2](https://cdn-images-1.medium.com/max/2000/1*fn-zmPouY7r3XoWS5c-mzQ.jpeg)

正如你可以看到 CDN 位于客户端和后端服务之间，也就成为了缓存。在数据流序列中看起来像这样：

![配图](https://cdn-images-1.medium.com/max/2000/1*4oGxf26V7E7MYAGKl4MtnA.png)

让我们更深入地挖掘它，因为这是设计的症结

### 要使用的缩写

> **T1** -> time instance 1 + 几毫秒
>
> **T2** -> time instance 1 + 一分钟 + 几毫秒
>
> **TTL** -> 留存时间
>
> **原始服务器** -> 在这种情况下你的实际后端服务

1. T1：客户端发起请求获取 user1。
2. T1：请求转移到 CDN 上。
3. T1：CDN 发现在缓存中没有 user1 相关的密钥。
4. T1：CDN 向上请求，即请求你的实际后端服务器，以获取 user1。
5. T1：后端服务将 user1 以标准 JSON 格式响应返回。
6. T1：CDN 收到 JSON 并存储该 JSON
7. 现在它需要决定这个数据的 TTL 应该是什么，它如何做到这一点？
8. 通常有两种方法可以做到这一点，原始服务器指定应高速缓存的长度或在 CDN 配置上设置了常量值。它会使用该时间来设置 TTL。
9. 让原始服务器来设置 TTL 是个更好的选择，这样我们就可以以我们喜欢的方式控制 TTL 或有条件地设置 TTL。
10. 现在问题提出了原始服务器如何指定 TTL。`cache-control` 标头此时起到了作用。来自原始服务器的响应可以包含 `cache-control` 标头，如 `cache-control: public, max-age: 180`，指示 CDN 可以公开地缓存此数据，它有效期为 180 秒。
11. T1：现在 CDN 得到这个信息，以 180s 的 TTL 缓存数据。
12. T1：CDN 用 user1 的 JSON 文件响应客户端。
13. T2：另一个客户端请求 user1。
14. T2：请求转移到 CDN 上。
15. T2：CDN 看到它有存储在其存储中的 user1 密钥，因此它不会请求原始服务器以获取 JSON。
16. T3：高速缓存在 180 秒后在 CDN 上过期。
17. T4：另一些客户端请求 user1，但由于缓存是空的，因此 CDN 从步骤 3 开始重复步骤，以此往复。

你不一定只能将 TTL 保留为 180 秒，而是只需要根据你应该为陈旧数据提供缓存的时间长度来选择 TTL。如果这让你有了这个问题，为什么不能在数据更改时候让缓存无效，稍后我将在缺点部分中回答。

## 实现

到目前为止，我们高谈阔论，一直聊着设计，而没有真正进入实际实现。作为设计的原因非常简单，可以在任何设置中实现。对于我们来说，我们的 CDN 在 Google Cloud 上，后端服务运行的 Kubernetes 集群在 Azure 上，因此我们根据我们的需求进行了设置。例如，你可以选择在 CloudFlare CDN 上执行此操作，因此未进入实施并保持抽象。但只是为了好奇的思想，这是我们的生产设置方式。

![](https://cdn-images-1.medium.com/max/3316/1*vrlRYFpBKKy5IqDSbrUidA.jpeg)

如果你不理解这个，也没关系。而如果你理解了这些概念，那么相关的构建对你来说将会是小菜一碟。

Google Cloud 的这篇优秀的[文档](https://cloud.google.com/cdn/docs/setting-up-cdn-with-external-origin)可以供你了解。

---

## 请求合并

但是仍然存在一个问题，CDN 为我们处理了所有负载，不过我们没有扩展的空间。可是我们的服务器会以 60k qps 的标准运行，意味着在缓存未命中的情况下，60k 的调用将会直接访问我们的源服务器（考虑到填充 CDN 缓存需要 1 秒），这可能会使服务不堪重负，对吗？

这就是请求合并起作用的地方。

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*ze0WtYQVhFRtClZq0GEoVQ.jpeg)

顾名思义，这实际上就是将具有相同查询参数的多个请求组合在一起，以实现只向源服务器发送数量较少的请求。

我们设计的美妙之处在于我们不必自己进行请求合并，CDN 会帮助我们完成。正如我已经提到的，我们正在使用的 Google Cloud CDN 就有一个 Request Coalescing 的概念（也是 Request Collapsing 的一个别称）。因此，当同时发出大量缓存填充请求时，CDN 能够识别出这一情况，然后 CDN 的每个节点就只会向源服务器发送一个请求并使用对应的响应内容，响应所有的请求。这就是它保护我们的源服务器免受高流量影响的方式。

---

好了，我们的文章差不多接近尾声了。任何设计，若是少了利弊分析，那都是不完整的。因此，让我们稍微分析一下设计，看看这个设计是怎样帮助我们的，以及它在哪些地方无法给予我们帮助。

## 设计的优点

1. **简单性：**这种设计超级简单，易于实施和维护。
2. **响应时间：**你知道 CDN 服务器在地理上定位以优化数据传输，因此，我们的响应时间也变得超快速。例如，60ms（忽略 TCP 连接建立时间）是不是很棒？
3. **减少负载：**由于实际的后端服务器现在每 180s 才收到一次请求，因此负载超低。
4. **基础设施成本：**如果我们没有这样做，那么处理这种装载我们必须扩展我们的基础架构，这具有很大的成本。但 [**Glance**](https://www.glance.com/) 已经在 CDN 中大量投资。因为我们是一个内容平台，所以为什么不使用这个方法？支持这些 API 的成本增加现在是微不足道的。

## 设计的缺点

1. **缓存失效：**缓存失效是在计算机科学中最难应付的事情之一，而且当 CDN 成为高速缓存后，这个问题甚至更难解决。CDN 上的任何突发的缓存失效是一个成本很高的过程，一般不会实时发生。如果你的数据更改，因为我们无法在 CDN 上使缓存无效，因此你的客户端可能会在某些时间内获得陈旧的数据，不过这取决于你的 TTL。如果你的 TTL 设置在了几小时内，那么你也可以在 CDN 上让缓存失效。但如果 TTL 在几秒钟/分钟内，那就会出大问题！此外，请记住，并非所有 CDN 提供商都会公开使 CDN 缓存失效的 API。
2. **缺少控制：**由于请求现在没有直接发送到我们的服务器上，我们会感觉，作为开发者，我们没有能够充分的统筹这个系统（或者也可能只是我这一个人是个控制狂 😈 想控制一切）。另外，可观察性可能会稍微减小。即便我们可以随时在 CDN 上设置日志记录和监控，但通常这样做会增加一定的成本。

## 几句感想

在分布式世界中，任何设计都具有一定的主观性，并且总会存在一些权衡。作为开发人员或者架构师，我们的责任是权衡利弊，并选择适合我们的设计。话虽如此，没有哪种设计足够具体以永远持续下去，因此在给定约束条件下，我们选择了某种设计，根据其对我们的适用性，我们可能会进一步发展它。

---

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
