> * 原文地址：[How A Cache Stampede Caused One Of Facebook’s Biggest Outages](https://medium.com/better-programming/how-a-cache-stampede-caused-one-of-facebooks-biggest-outages-dbb964ffc8ed)
> * 原文作者：[Sun-Li Beatteay](https://medium.com/@SunnyB)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-a-cache-stampede-caused-one-of-facebooks-biggest-outages.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-a-cache-stampede-caused-one-of-facebooks-biggest-outages.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[kamly](https://github.com/kamly)、[JalanJiang](https://github.com/JalanJiang)

# 缓存踩踏事件是如何导致 Facebook 最大的宕机事件之一发生的

![由 [Susan Yin](https://unsplash.com/@syinq) 上传至 [Unsplash](https://unsplash.com)(https://unsplash.com)](https://cdn-images-1.medium.com/max/10368/0*FGGy038B4etUbHdm)

2010 年 9 月 23 日，Facebook 发生了迄今为止最严重的宕机事件之一。在这次事件中，Facebook 关闭了四个小时。情况如此严重，以至于工程师不得不让 Facebook 下线才得以恢复系统。

虽然 Facebook 那时候还没有现在那么庞大，但它当时仍然拥有超过 10 亿的用户，并且它的宕机并没有被忽视。人们只是在 Twitter 上或抱怨或开这件事的玩笑。

![图片来源：[https://www.businessinsider.com/how-we-weathered-the-great-facebook-outage-of-2010-2010-9#the-outage-had-far-reaching-consequences-7](https://www.businessinsider.com/how-we-weathered-the-great-facebook-outage-of-2010-2010-9#the-outage-had-far-reaching-consequences-7)](https://cdn-images-1.medium.com/max/2000/0*_-dYSO7eL_K9Qypi)

那么，究竟是什么导致了 Facebook 的停运呢？[根据事件发生后的官方分析](https://www.facebook.com/notes/facebook-engineering/more-details-on-todays-outage/431441338919)：

> 今天我们误改了一个配置。这意味着每个客户端都能收到这个错误配置并尝试修复它。由于修复操作涉及对数据库集群进行查询，因此该集群很快就被每秒数十万个查询所淹没。

---

错误的配置更改导致大量请求被传送到他们的数据库。这种请求踩踏被恰当地称为 [**缓存踩踏**](https://en.wikipedia.org/wiki/Cache_stampede)。这是困扰科技行业的一个普遍问题，它已经导致许多系统发生故障，例如 2016 年的 [Internet Archive](https://archive.org/index.php)。许多大型应用程序每天都在为此防范着，如 Instagram 和 DoorDash 。

## 什么是缓存踩踏？

当多个线程尝试并行访问一个缓存时，会发生缓存踩踏事件。如果缓存值不存在，线程将同时尝试从源获取数据。源通常是一个数据库，但也可以是 Web 服务器、第三方 API 或任何其他返回数据的东西。

缓存踩踏之所以如此具有破坏性的主要原因之一是因为它可能导致恶性故障循环：

1. 大量并发线程缓存未命中，导致它们都请求数据库。
2. 由于 CPU 峰值过大导致数据库崩溃，并且导致超时错误。
3. 收到超时，所有线程重试他们的请求 —— 导致另一次踩踏。
4. 循环往复。

你不需要拥有 Facebook 那样规模的用户也一样会遭其折磨。缓存踩踏与用户规模无关，因此它同时困扰着初创公司和科技巨头。

---

![图片来源：[https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/](https://engineering.fb. com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/)](https://cdn-images-1.medium.com/max/2000/0*PYCftRvef9KfysGE.gif)

## 如何防止缓存踩踏？

这是一个很好的问题，也是在我了解 Facebook 宕机后询问自己的问题。不出所料，自 2010 年以来，开发者们已经进行了大量防止缓存踩踏的研究。我通读了所有的这些研究。

---

在本文中，我们将探讨防止和减轻缓存踩踏的不同策略。毕竟，我们可不想亡羊补牢。

## 添加更多缓存

一个简单的解决方案是添加更多缓存。虽然这似乎违反直觉，但这与操作系统的工作方式类似。

操作系统采用了 [缓存层次结构](https://en.wikipedia.org/wiki/Cache_hierarchy)，其中每个组件都缓存自己的数据，因此访问速度被加快。

![操作系统缓存（图片来源：[https://www.sciencedirect.com](https://www.sciencedirect.com/topics/computer-science/disks-and-data)）](http://cdn-images-1.medium.com/max/2000/0*nhc5wYwVVERwqxlv.jpeg)

我们可以在我们的应用程序中通过合并内存缓存（第 1 层（L1）缓存）采用类似的模式。任何远程缓存都将被视为第 2 层（L2）。

！[图片来源：[https://medium.com/@DoorDash/avoiding-cache-stampede-at-doordash-55bbf596d94b](https://medium.com/@DoorDash/avoiding-cache-stampede-at-doordash -55bbf596d94b)](https://cdn-images-1.medium.com/max/2000/0*_uJf2mjpAbCLw9hp)

这对于防止频繁访问数据时发生踩踏事件特别有用。即使第 2 层缓存上的键过期，一些第 1 层缓存可能仍存储该值。这将限制需要重新计算缓存值的线程数。

但是，这种方法有一些方面需要注意权衡。如果你不小心，在应用程序服务器上缓存内存中的数据可能会导致 [内存不足](https://en.wikipedia.org/wiki/Out_of_memory) 问题，尤其是在缓存大量数据时。

此外，这种缓存策略仍然容易受到我所说的追随者踩踏的影响。

![图片来源：[https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/](https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/)](https://cdn-images-1.medium.com/max/3060/1*NBJp5l3dOMXcwNT7KCoZfg.gif)

追随者踩踏的一个例子是当名人将新照片或视频上传到他们的社交媒体帐户。当所有关注者都收到新内容的通知时，他们会争先恐后地查看。由于内容太新，还没有被缓存，就会导致可怕的缓存踩踏事件。

---

那么，对于追随者踩踏事件，我们能做些什么呢？

## Lock 和 Promise

从本质上讲，缓存踩踏是一种竞争状态 —— 多个线程争夺共享资源。在这种情况下，共享的资源是缓存。

![图片来源：[https://instagram-engineering.com/thundering-herds-promises-82191c8af57d](https://instagram-engineering.com/thundering-herds-promises-82191c8af57d)](https://cdn-images-1.medium.com/max/2000/0*KThIA3rqDvhQLXHp)

在高并发系统中很常见，一种防止共享资源竞争条件的方法是使用**锁**。虽然锁通常用于同一台机器上的线程，但也有一些方法可以使用[分布式锁](https://redis.io/topics/distlock) 用于远程缓存。

通过在缓存键上加锁，限制一次只有一个调用者能够访问缓存。如果缓存键丢失或过期，调用者就可以生成并缓存数据，同时持有锁。任何其他尝试从同一个缓存键读取的进程都必须等到锁空闲。

![图片来源：[https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/](https://engineering.fb. com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/)](https://cdn-images-1.medium.com/max/2000/0*7DqZBIsf7BByzB3q.gif)

使用锁解决了竞争状态问题，但它会产生另一个问题。你如何处理所有等待锁释放的线程？

不知道你是否使用过[自旋锁](https://en.wikipedia.org/wiki/Spinlock) 模式并让线程不断轮询锁？这将创建一个[忙等待](https://en.wikipedia.org/wiki/Busy_waiting) 场景。

在检查锁是否空闲之前，你是否让线程休眠了任意时间？这样你就会遇到[惊群效应问题](https://en.wikipedia.org/wiki/Thundering_herd_problem)。

你是否引入了[退避和抖动机制](https://www.baeldung.com/resilience4j-backoff-jitter)以防止惊群效应问题？这可能有效，但还有一个更普遍的问题。拥有锁的线程必须在释放锁之前重新计算值并更新缓存键。

这个过程可能需要一段时间。特别是如果该值的计算成本很高或存在网络问题。如果缓存耗尽其可用连接池并且用户请求被丢弃，这仍然可能导致宕机。

幸运的是，一些顶级公司正在使用一种更简单的解决方案：**Promise**。

#### Promise 如何防止自旋锁

引用 **[惊群效应问题与 Promise](https://instagram-engineering.com/thundering-herds-promises-82191c8af57d)** 来自 Instagram 的工程博客：

> 在 Instagram 上，当建立一个新集群时，我们会遇到**缓存踩踏**问题，因为集群的缓存是空的。然后我们使用 Promise 来帮助解决这个问题：**我们没有缓存实际值，而是缓存了一个最终会提供值的 Promise**。当我们以原子方式使用我们的缓存并出现未命中时，我们不会立即进入后端，而是会创建一个 Promise 并将其插入缓存中。然后这个新的 Promise 开始针对后端的工作。这样做的好处是其他并发请求不会错过，因为它们会找到现有的 Promise —— 并且所有这些并发工作人员将等待单个后端请求。

![图片来源：[https://instagram-engineering.com/thundering-herds-promises-82191c8af57d](https://instagram-engineering.com/thundering-herds-promises-82191c8af57d)](https://cdn-images-1.medium.com/max/2000/0*I28DPoMELLUV4QWN)

通过缓存 Promise 而不是实际值，不需要自旋锁。获取缓存未命中的第一个线程将使用原子操作（例如 Java 的 [`computeIfAbsent`](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#computeIfAbsent-K-java.util.function.Function-)）。所有顺序获取请求将立即返回 Promise 。

我们仍然需要使用锁来防止多个线程访问缓存键。但是假设创建一个 Promise 是一个近乎即时的操作，线程在自旋锁中停留的时间长度可以忽略不计。

[这正是 DoorDash 避免缓存踩踏的方式](https://medium.com/@DoorDash/avoiding-cache-stampede-at-doordash-55bbf596d94b)。

但是如果重新计算缓存值需要相对较长的时间呢？即使线程能够立即获取缓存的 Promise，它们仍然需要等待异步进程完成才能返回值。

---

虽然这种情况不一定算作中断，但它会影响尾部延迟和整体用户体验。如果保持较低的尾部延迟对你的应用程序很重要，那么还有另一种策略需要考虑。

## 提前重新计算

提前重新计算（Early Re-Computation，也称为提前到期 Early Expiration）背后的想法很简单。在缓存键正式过期之前，重新计算值并延长过期时间。这确保缓存始终是最新的，并且永远不会发生缓存未命中。

早期重新计算的最简单实现是后台进程或定时任务。例如，假设有一个缓存键，其过期时间在一小时内到期，计算该值需要两分钟。定时任务可以在一个小时结束前运行五分钟，并在更新后将过期时间再延长一个小时。

虽然这个想法在理论上很简单，但有一个明显的缺点。除非我们确切知道将使用哪些缓存键，否则我们需要重新计算缓存中的每个键。这可能是一个非常费力且成本高昂的过程。它还需要维护另一个活动部件，如果出现故障，则无法轻松追索。

由于这些原因，我无法在生产环境中找到任何此类早期重新计算的示例。但是也有例外。

#### 概率早期重新计算

2015 年，一组研究人员发表了名为 「Optimal Probabilistic Cache Stampede Prevention」 的[白皮书](https://cseweb.ucsd.edu/~avattani/papers/cache_stampede.pdf)。在其中，他们描述了一种算法，用于优化预测何时在缓存过期之前重新计算缓存值。

研究论文中有很多数学理论，但算法归结为：

```javascript
currentTime - ( timeToCompute * beta * log(rand()) ) > expiry
```

* `currentTime` 是当前时间戳。
* `timeToCompute` 是重新计算缓存值所需的时间。
* `beta` 是一个大于 0 的非负值。它默认为 1，但可以配置。
* `rand()` 是一个返回 0 到 1 之间随机数的函数。
* `expiry` 是缓存值设置为过期的未来时间戳。

这个想法是每次线程从缓存中获取时，它都会运行这个算法。如果它返回 `true`，那么该线程将自愿重新计算该值。越接近到期时间，此算法返回 `true` 的几率就会显着增加。

虽然这个策略不是最容易理解的，但它实施起来相当简单，不需要任何额外的移动部件。它也不需要重新计算缓存中的每个值。

[互联网档案馆](https://archive.org/index.php) 在 2016 年总统辩论的一次宕机后开始使用这种方法。这个 [RedisConf17 的演讲](https://www.youtube.com/watch?v=1sKn4gWesTw) 更深入地讲述了这个故事，并很好地概述了概率早期重新计算的工作原理。我**强烈**推荐[看看这个视频](https://youtu.be/1sKn4gWesTw)

---

然而，早期重新计算假设有重新计算的价值 —— 它不会单独阻止追随者踩踏。为此，我们需要将它与锁和 Promise 结合起来。

## 如何阻止正在进行的踩踏事件

Facebook 的缓存踩踏事件如此具有破坏性的原因之一是，即使工程师找到了解决方案，他们也无法部署它，因为踩踏事件仍在继续。

根据[事后分析](https://www.facebook.com/notes/facebook-engineering/more-details-on-todays-outage/431441338919)：

> 更糟糕的是，每次客户端在尝试查询其中一个数据库时出错，它都会将其解释为无效值，并删除相应的缓存键。这意味着即使在解决了原始问题之后，查询流仍在继续。只要数据库无法为某些请求提供服务，它们就会对自己造成更多请求。我们进入了一个不允许数据库恢复的反馈循环。

现实情况是，无法保证预防永远有效 —— 我们还需要缓解。[防御性编程](https://en.wikipedia.org/wiki/Defensive_programming)规定应该制定一个计划，以防踩踏事件绕过我们设置的限制。

幸运的是，有一个已知的模式来处理这个问题。

#### 熔断器

在编程中使用熔断器的想法并不新鲜。在 Michael Nygard 于 2007 年发表 [**Release It!**](https://www.amazon.com/gp/product/0978739213) 后，它开始流行。正如 Martin Fowler 在他的文章 **[CircuitBreaker](https://www.martinfowler.com/bliki/CircuitBreaker.html)** 所写的那样：

> 熔断器背后的基本思想非常简单。你将受保护的函数调用包装在熔断器对象中，该对象监视故障。一旦故障达到某个阈值，熔断器就会熔断，并且所有对熔断器的进一步调用都会返回错误，而不会调用到受到熔断器保护的地方。

![图片来源：[https://www.martinfowler.com/bliki/CircuitBreaker.html](https://www.martinfowler.com/bliki/CircuitBreaker.html)](https://cdn-images-1.medium.com/max/2000/0*2Jn_bNJ6Vh2-Lwla.png)

熔断器是被动的，这意味着它们不会阻止宕机，但它们将防止级联故障。当事情失控时，它提供了一个终止开关。如果 Facebook 使用熔断器，他们本可以避免让整个网站脱机。

---

诚然，熔断器在 2010 年并不那么流行。如今，有几个带有熔断器的库，例如 [Resilience4j](https://resilience4j.readme.io/)、[Istio](https://istio.io/) 和 [Envoy](https://www.envoyproxy.io/)。一些组织在生产中使用这些服务，例如 [Netflix](https://netflixtechblog.com/making-the-netflix-api-more-resilient-a8ec62159c2d) 和 [Lyft](https://www.getambassador.io /resources/mechanics-deploying-envoy-lyft-matt-klein/）。

## Facebook 买来了什么教训？

我在这篇文章中谈了很多关于解决缓存踩踏的不同策略以及其他科技公司如何使用它们。但是 Facebook 本身呢？

他们从故障中吸取了哪些教训，他们采取了哪些保护措施来防止再次发生这种情况？

他们的工程帖子，[**幕后：向数百万人广播直播视频**](https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/)，讨论他们对架构所做的改进。它讨论了我们已经讨论过的内容，例如缓存层次结构，但也包括一些新颖的方法，例如 HTTP 请求合并。这篇文章值得一读，但如果你时间不够，这个[视频提供了一个全面的概述](https://www.facebook.com/Engineering/videos/10153675295382200/?t=0)。

可以说 Facebook 从他们过去的错误中吸取了教训。

---

![图片来源：[https://engineering.fb.com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/](https://engineering.fb. com/2015/12/03/ios/under-the-hood-broadcasting-live-video-to-millions/)](https://cdn-images-1.medium.com/max/3076/1*8aT7_UKqYmXxdEkoMZBx4g.gif)

## 部分感想

虽然我相信了解缓存踩踏事件如何对系统造成严重破坏，但我不认为每个技术团队都必须立即添加这些措施。我们选择如何处理缓存踩踏将取决于我们项目的用例、架构和流量负载。

但是，当我们发现自己正在与惊群效应问题作斗争，那么了解缓存踩踏事件并了解可能的解决方案将使我们在未来受益。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
