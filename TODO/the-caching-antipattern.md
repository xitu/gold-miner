
> * 原文地址：[The Caching Antipattern](https://www.hidefsoftware.co.uk/2016/12/25/the-caching-antipattern/)
* 原文作者：[ROBERT STIFF](https://www.hidefsoftware.co.uk/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# The Caching Antipattern #

## 缓存反模式 ##

TL;DR - Caching done badly has bad implications. Try your hardest not to cache data; but if you really do have to, make sure you do it right.

太长；你别看了 - 糟糕的缓存暗示了很糟糕的东西。尽最大力量不要缓存数据，但如果你不得不那样做，要确保你做对了。

---

> There are only two hard things in Computer Science: cache invalidation and naming things.
> 
> – Phil Karlton

> 计算机科学中有两件难事：缓存失效和命名。
> 
> - phil Karlton

## Caching? ##

## 缓存？ ##

To make sure we’re on the same page, when I say *caching*, I am talking about the practice of speeding up your own application by masking slow dependencies by remembering previous responses and using them instead of making another slow call to the dependency.

As mentioned breifly by Phil Karlton in his well known sound byte, caching is a tricky problem. This is compounded by a number of common mistakes which I have seen over the years which have resulted in unnecessary confusion delay.

为了确保我们在同一频道，当我提到**缓存**的时候，我是指一种加速应用的实践，你会利用记住并使用先前的响应数据的方法来伪装缓慢的依赖关系，而不是重新执行一个缓慢的依赖关系调用。

正如 Phil Karlton 的名言中所提到的那样，缓存是一个棘手的问题。这是因为其中包含了许多我这些年来常见的普通错误，这也导致了不必要的混乱和延迟。

## Common Mistakes ##

## 普通错误 ##

Here are some of the mistakes I have seen and what we should to differently.

以下是我所见的一些错误，而我们应该区别对待。

### Cache on startup ###

### 启动就缓存 ###

When you know for a fact that your dependencies are so slow they are unusable so you don’t even try at run time. Pre-populating a cache as your application starts up rather than querying your dependent service is just admitting that your dependency is not fit for purpose. If it’s a 3rd party service then maybe there is nothing you can do about that, but all too often this technique is used to avoid having to make your services actually fit for purpose.

当你已经知道你的依赖关系慢到不能用的地步，因此在程序运行的时候你根本不会去尝试。在应用启动的时候你就预先缓存而不去请求你的依赖服务恰恰承认了你的依赖关系并不能实现目的。如果那是一个第三方的服务，也许你将对它无可奈何，但是这项技术经常被用来避免不得不进行的服务改造。

The problem with caching like this is that it extends application startup times, making scaling and failure recovery or even non-viable.

这种缓存方式的问题在于，它将会延长应用的启动时间，造成应用的缩放、故障恢复甚至不可用。

And even if you are okay with having a service that is slow to start or restart (which you shouldn’t be) it results in a cache which bares no relation to the nature of the data or your service’s usage patterns. A simple cache expiry policy would be meaningless here, as this pattern explicitly exists to avoid ever hitting your dependencies again.

即使你觉得就算某项服务的启动或者重启很慢也没关系（其实你不应该这样），这会产生既无关数据也无关服务使用模式的缓存。简单的缓存失效策在这里将会失去意义，因为这种模式很明确地就是为了避免再次触及你的依赖关系而存在的。

### Caching too early ###

### 过早地缓存 ###

I don’t mean too early in the request lifecycle, I mean too early in the development cycle. Many times I have seen developers write code, decide that it is too slow, and stick cache in front of it.

From that point on, the fact that their service is slow is hidden. There is no reason to optimise or improve the solution as the cache will ensure that the second request is much quicker; so why worry, right?

我并不是指在请求生命周期中过早地缓存，而是指在开发周期中过早地缓存。我见过很多次这样的情况，开发者写代码的时候就决定该方法很慢，然后在该段代码前设置了缓存。

这样做可以掩盖他们的服务其实很慢的事实。没理由再去优化和改进解决方案了，因为缓存已经能够确保第二次的请求会变得快很多，那还担心什么呢，对吧？

### Integrated Cache ###

### 完整的缓存 ###

What’s the S in SOLID? Single Responsibility. If your caching capability is integrated directly in to your service layer and you can’t run without it you’re definitely in breach of this principle. It’s not my my place extoll the virtues of this principle here.

SOLID 中的 S 扮演着什么样的角色？独立角色。如果你的缓存功能直接集成到服务层，那么你将不能离开它运行，而你绝对会违反这项原则。我并不赞同这项原则。

### Caching everything ###

### 缓存任何内容 ###

Blindly applying caching to every external call to ensure responsiveness without a thought for he implications. Even worse, this approach can result in developers and operators not even knowing that caching is occurring and making assumptions about the reliability of the underlying services that are simply not true.

盲目地将缓存应用到每一个额外的调用中来确保响应时不用考虑潜在因素。即使在更糟糕的情况下，这种方式也能做到在开发者和运维不知情的情况下产生缓存并造成底层服务很可靠的假象，但其实那并不是真的。

### Recaching ###

### 重复缓存 ###

Caching everything, or even just caching a lot, can result in caches that cache caches which cache caches.

On one end of the spectrum, this might result all internal caches expiring shortly before the very front cache, resulting in a huge waste of time and resources to operate layers and layers of caching which are never used.

At the other then, it can result effectively summing the cache expiry time of all caches involved, so 10 layers of 30 minutes caches can result in a system serving data which is 5 hours old. How’s *that* for counterintuitive?

缓存所有内容或者缓存过多内容，都可能会导致再次缓存的内容。

### Unflushable Cache ###

### 无法删除的缓存 ###

Occasionally cache implementations may back on to data stores like Redis which has management tooling which can be used to flush the cache on demand.

Other implementations, such as hand cranks in memory caches or even caches provided by mainstream frameworks will not expose any cache management tools. This leaves ops with the only option, to restart the service to flush the memory. (Or worse, know enough about the cache implementation to find it’s location on file system and clear it out manually.)

I have seen releases that have taken hours longer than necessary while different members of the team tried to track down cache after cache, flush them with a restart or wait for expiry before moving on to the next layer. All the time with a system taken offline because the system cannot be said to be consist within itself.

偶然地缓存实现中可能会有类似于 Redis 这种存储数据的方式，这种方式可以使用管理工具来根据需要删除缓存。

其他的实现中，比如内存中的缓存甚至主流框架中提供的缓存都没有任何的缓存管理工具。这让运维别无他法，只能重启服务来清空内存。（更糟糕的是，了解了缓存的实现并找到其在文件系统中的位置并手动地清除。）

## The implications ##

## 暗示 ##

Caching data has implications which these mistakes can accentuate as well as new issues we didn’t have to think of before.

缓存数据意味着这些错误都可能被放大，那些我们之前从没想过的问题也会被放大。

Deploying to a heavily cached system can be extremely time consuming while you wait for caches to expire or have to bust every cache you can find. Even in systems such as some CDNs I have worked with which serve traffic to tens of percent of the Internet and are thought to be the leaders in content delivery, flushing content and configuration caches globally can take up to two hours. This doesn’t need to be the case ([Fastly](https://www.fastly.com/products/instant-purging) can purge their cache in 150ms), and it results in confusion (is the new data being served yet?).

当你不得不等待缓存过期或者销毁每个你能找到的缓存的时候，部署一个过度缓存的系统将会变得特别地耗费时间。即使在一些公认为是业界领袖的 CDN 服务系统，在我使用中也会有百分之十左右的网络服务器阻塞，删除全局内容和配置的缓存可能会达到两个小时之久。其实并不需要这么久（[Fastly](https://www.fastly.com/products/instant-purging) 能够在 150ms 内清除缓存），并且这会让人感到迷惑（服务器是现在是新的数据了吗？）。

The natural response is to come up with a workaround, usually some of of cache busting. Let’s just think about that. A work around for a feature that you just implemented. Think about that, time, effort and cognitive load just to compensate for time, effort and cognitive load you just spent on caching in the first place.

自然响应是为了提出一个解决办法，通常是销毁缓存。让我们试想一个你刚实现的功能的周边工作内容，想一想，那些你一开始花费在缓存上的时间、精力和可感知的加载都需要时间、精力和可感知的加载来弥补。

Debugging a cached system also becomes a challenge as being up to your neck in a tricky debugging session will end up with unrelated things being missed or forgotten about. 3 hours of confusion later you realise that you haven’t actually been testing any of the changes you have been making.

调试一个缓存系统同样会变得极具挑战性，因为这会成为你在一些棘手的 session 调试中的瓶颈，最后只得到一些没有任何联系的被丢掉或者忘记的东西。三个小时后你突然意识到，你实际上并没有测试到你所做的任何改变（因为缓存一直存在）。

## What we should do instead ##

## 我们该怎样做呢？ ##

### Don’t cache! ###

### 不要缓存！ ###

Okay, sometimes caching is your only option. You’re on the web and it’s happening whether you like it or not. But even in this case there are options other than a simply slapping on `Cache-Control: max-age=xxx`.

有时缓存与否取决于你自己的选择。你在上网并且不管你喜不喜欢它都在发生着。但是即使在这种情况下，除了使用 `Cache-Control: max-age=xxx` 之外，你还有其他选择。

### Know your data ###

### 了解你的数据 ###

You should know when your data was last modified at the very least. Now you can make use of the `If-Modified-Since` header. Return 304-not-modified if the data hasn’t changed. Now you can intelligently utilise the the client’s caching capability without sacrificing visibility and control. Using this header will let you serve new content instantly and also cache indefinitely. The best of both worlds. Taking it one step further, if you’re able to version you data (or just generate a hash of your response), you can make use of [etags](https://en.wikipedia.org/wiki/HTTP_ETag) and still interact with the client and apply appropriate logic without the latency related to data transfer.

你应该了解数据在何时被修改为最新。现在你可以使用 `If-Modified-Since` 头。如果数据没有改变，将返回 304-not-modified。现在你可以智慧得使用客户端的缓存能力，而不用牺牲可见性和控制权。使用这个头部信息将能使你能够立即使用新的内容并及时缓存。这两者双剑合璧，天下无敌。更进一步说，如果你能标记数据的版本（或者只是生成一个响应的哈希），你将能利用 [etags](https://en.wikipedia.org/wiki/HTTP_ETag) 并且仍然可以和客户端交互并提供正确的逻辑而不会产生数据传输的延迟。

### Optimise for performance, don’t hide bad performance ###

### 优化性能，不要隐藏糟糕的性能 ###

Invest in profiler tooling. Find out why your application is slow and fix it. Reduce duplicate execution paths. Sort out bad query execution plans. Utilise indexes properly. If you’re using S3 or blob storage for your data you can always build your own index using Redis or the like. Redis is more than a cache. You can use it intelligently and get many benefits without the problems introduced by caching.

在分析工具上投入精力，找出你的应用慢的原因并修复它。减少重复的执行路径，找出糟糕的查询执行计划，正确地使用索引。如果你在只用 S3 或者 blob 存储数据，你总能够使用 Redis 或者类似的工具来建立你自己的索引。Redis 并不仅仅是缓存，你可以巧妙地使用它并得到许多的有利之处而不会存在缓存引发的问题。

## Finale ##

## 最后 ##

Caching is a useful tool, but can be easily abused without giving any signs of the abuse.

缓存是很有用的工具，但是若不加以指点很容易被滥用。

Don’t get involved with caching till the last minute; find any other way you can first. Optimise your application before you use the blunt tool of caching.

不到最后关头，不要尝试使用缓存，首先要寻找其他方法。在你使用迟钝的缓存工具之前首先优化你的应用。

If you’ve come across any fundamental problems caused by caching and bad discipline there of, let me know and I can add them to the list.

如果你也总结了一些由缓存导致的基本的为题或者类似的糟糕的内容，请告知我然后我会将他们添加到这个列表中。