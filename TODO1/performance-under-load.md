> * 原文地址：[Performance Under Load](https://medium.com/@NetflixTechBlog/performance-under-load-3e6fa9a60581)
> * 原文作者：[Netflix Technology Blog Netflix Technology Blog](https://medium.com/@NetflixTechBlog)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/performance-under-load.md](https://github.com/xitu/gold-miner/blob/master/TODO1/performance-under-load.md)
> * 译者：[WangLeto](https://github.com/WangLeto)
> * 校对者：[sunui](https://github.com/sunui)，[xionglong58](https://github.com/xionglong58)

# 负载性能

**Netflix 的自适应并发限制**

> Eran Landau、William Thurston、Tim Bozarth 作

在 Netflix，我们沉迷于服务可用性的研究，关于如何实现目标这几年也写了几篇博客文章。这些技术包括了[断路器模式](https://zh.m.wikipedia.org/wiki/斷路器設計模式)、并发限制、混沌测试等等。现在我们宣布最近的创新：自适应并发限制。自适应并发限制从根本上提升了应用程序在极端负载下的表现，并使得我们可以避免级联服务故障。我们移除了判定系统并发限制的艰难工作，又保证了延迟保持较低水平。本文发布的同时，我们开源了一个简单的 Java 类库，集成了 servlet、executor 和 GRPC 框架支持。

## 简要的背景介绍

并发量其实就是系统在任意时刻能够处理的请求数，通常是由硬件资源决定的，比如 CPU。通常我们使用利特尔法则（Little’s Law）计算系统的并发量：稳定状态下的系统，并发量等于平均服务时间与平均服务速率的乘积（L = 𝛌W）。任何超过该并发量的请求都不能立即得到服务，必须排队或被拒绝。如此说来，即便请求到达速率和服务时间都不均匀，做些排队处理就能令整个系统被充分利用起来，因此它是很必要的。

![](https://cdn-images-1.medium.com/max/2468/1*XurJ5f2Hjf4lO-GspmCRIw.png)

当队列没有强制限制时系统会出问题，比如在很长的时间内请求到达速度都超过请求结束速度。随着队列增长，延迟也增长了，直到所有的请求都开始超时，最终系统耗尽内存然后崩溃。如果留下未经检测的延迟，它就会对其调用者产生不利影响，从而导致系统的级联故障。

![](https://cdn-images-1.medium.com/max/2432/1*HuSIJZzGk7RSeJbnINF-DQ.png)

强制进行并发限制不是什么新奇玩意儿；难的是在大型的动态分布式系统中找到并发量限制，而且这个系统的并发量和延迟特征还在不断改变。我们解决方案给出的主要目的，就是动态地确定并发量限制。这一并发量可以被视为在系统性能下降前（如延迟）所允许的最大请求数量（实时并发量＋排队中的请求）。

## 解决方案

以前，在 Netflix 我们手动配置了由复杂的性能测试和分析得到的并发限制。虽然这在某一时刻很准确，但是一旦系统部分停运导致拓扑结构变化、系统自动扩展（auto scaling）或是推送代码上线引起延迟特征变化，这一测量值都会很快过时。

我们知道我们可以做得比静态的并发限制更好，所以我们探索了自动确定系统固有并发限制的方案，该方案：

    1. 不需要人工

    2. 不需要集中协调

    3. 不需要硬件信息或系统拓扑结构就能确定并发限制

    4. 能适应系统的拓扑结构变动

    5. 计算容易，执行简单

为了解决该问题，我们转向尝试真正的 TCP 拥塞控制算法，不会引起超时或增加延迟就能探明可以同时传输多少个数据包（比如拥塞窗口大小）。这些算法持续跟踪各种指标，以估算系统的并发限制，并持续调节拥塞窗口大小。

![](https://cdn-images-1.medium.com/max/2496/1*rWdqQuqi50OJNLnGeDgo1w.png)

我们可以看到这个系统用蓝线代表了未知的实际并发量。客户端起初发送的请求被限制在较低的并发水平，系统在延迟不增加的情况下通过增加并发窗口频繁探测更高的并发量。当延迟真的开始增长时，传感器假定到达了并发极限，降回拥塞窗口大小。并发限制的探测持续进行，就产生了上图的锯齿状图像。

我们的算法建立在基于延迟的 TCP 拥塞控制算法的基础上，该算法查看最小的延迟（代表没有排队的最佳情况）除以按时间进行采样测量的延迟之间的比率，作为识别队列产生并开始导致延迟增加的衡量参照。从该比值可以获知延迟变化的梯度或级别：**gradient=(RTTnoload/RTTactual)** （译者注：[RTT](https://en.wikipedia.org/wiki/Round-trip_delay_time) 指 TCP 连接中一个数据包的往返时间，RTTnoload 指没有延迟的最小 RTT 值，RTTactual 指实际的 RTT 值）。值为 1 表示没有出现排队，可以增大并发限制；小于 1 的值表示形成了过多队列，应该减少并发限制。对于每个新样本，利用此比率调整并发限制，并使用一个简单公式增加所允许的队列大小：

```
newLimit = currentLimit × gradient + queueSize
```

经过几次迭代后，算法收敛到某个保持延迟较低的并发限制水平，同时允许一些排队处理来处理突发请求。所允许的队列大小是可调整的，并且该值决定了并发限制的增长速度。我们认定当前并发限制的算术平方根是个不错的默认值。选择算数平方根，主要是因为它能很大程度上反映出当前并发限制在较低请求数时的有用特性，允许迭代时快速增长，而在出现大量请求时又能灵活减小，从而保证了系统稳定。

## 启用自适应并发限制

启用后，自适应服务器端并发限制会拒绝过多的 RPS（Request Per Second） 来保持较低的延迟，从而保护实例自身及其所依赖的服务。如果不拒绝过多的并发请求，RPS 或者延迟的持续增加都会转化为更糟糕的延迟并最终导致系统故障。服务现在能够减少过多的负载并保持较低的延迟，而其他缓和措施（如自动扩展）则会起作用。

![](https://cdn-images-1.medium.com/max/2452/1*sfDL_PVx-lCAs3W4z_S0cQ.png)

注意这一点很重要：在服务器层面强制执行并发限制（不进行协调），每个服务器的流量限制可能应用得相当迅速。 因此，得到的并发请求限制和数量在不同服务器间可能相差较大，从云服务商租用的多个服务器尤其如此。 当其他地方有足够的承载能力时，可能引起某台服务器脱离服务集群。话虽如此，使用了客户端侧负载均衡，客户端只需重试一次请求，几乎就能 100％ 到达一台可用的服务实例。更棒的是，由于服务能够在亚毫秒时间内极速减少流量，这对服务性能的影响微乎其微，因此不用再担心客户端重试请求引起的 DDOS 和重试风暴（译者注：应该是指大量客户端因为请求被拒绝而反复重试服务请求）。

## 总结

随着我们推出自适应的并发限制，我们不再需要像看小孩一样看着系统性能，然后手动调整服务负载。 更重要的是，它同时提高了我们整个基于微服务的生态系统的可靠性和可用性。

我们很高兴在一个小型开源库中分享我们的思路实现和常见框架集成：http://github.com/Netflix/concurrency-limits。 我们希望，任何想要保护其服务免于级联故障和与负载引起的延迟降级的人，都可以利用我们的代码来实现更好的可用性。 我们期待社区的反馈，并乐意接受新算法或框架集成的 Pull Request。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
