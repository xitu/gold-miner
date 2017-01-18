
> * 原文地址：[The Caching Antipattern](https://www.hidefsoftware.co.uk/2016/12/25/the-caching-antipattern/)
* 原文作者：[ROBERT STIFF](https://www.hidefsoftware.co.uk/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# The Caching Antipattern #

## 为何我抵制使用缓存？ ##

## 缓存反模式 ##

> 请校对者就以上两个标题给出选择意见！

TL;DR - Caching done badly has bad implications. Try your hardest not to cache data; but if you really do have to, make sure you do it right.

TL;DR - 糟糕的缓存意味着很糟糕的事情。尽你最大的努力不要去缓存数据，但如果你真的必须那样做，那一定要确保你做的是对的。

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

为了确保我们在同一频道，当我提到**缓存**的时候，我是指一种加速应用的实践方法，该方法可以记住并使用先前的响应数据来掩饰缓慢的依赖关系，而不是重新执行一个依赖调用。

正如 Phil Karlton 的名言中所提到的那样，缓存是一个棘手的问题。这是因为其中包含的许多常见错误会导致不必要的混乱和延迟，这种情况我这些年来见多了。

## Common Mistakes ##

## 常见错误 ##

Here are some of the mistakes I have seen and what we should to differently.

以下是我常见的一些错误也是我们不应该做的一些事。

### Cache on startup ###

### 启动的时候缓存 ###

When you know for a fact that your dependencies are so slow they are unusable so you don’t even try at run time. Pre-populating a cache as your application starts up rather than querying your dependent service is just admitting that your dependency is not fit for purpose. If it’s a 3rd party service then maybe there is nothing you can do about that, but all too often this technique is used to avoid having to make your services actually fit for purpose.

如果你已经知晓该依赖关系慢到不能正常使用，因此你甚至都不会去尝试在运行中去调用它。在应用启动的时候就预先缓存而不去查询依赖服务，这种行为恰恰承认了你的依赖关系并不能胜任目标工作。如果该依赖服务来自第三方，你可能拿它一点办法都没有，但是这个技巧的使用通常是为了规避改造服务的必要性。

The problem with caching like this is that it extends application startup times, making scaling and failure recovery or even non-viable.

这种缓存的问题在于，这将延长应用的启动时间，引发阻碍、故障恢复甚至使应用失效。

And even if you are okay with having a service that is slow to start or restart (which you shouldn’t be) it results in a cache which bares no relation to the nature of the data or your service’s usage patterns. A simple cache expiry policy would be meaningless here, as this pattern explicitly exists to avoid ever hitting your dependencies again.

即使你觉得某项服务的启动或重启就算很慢也没关系（其实你不应该这样），这种做法仍然是错误的，因为这产生的缓存既无关数据也无关服务使用模式。原本简单的缓存失效策略在这里将变得毫无意义，因为这种模式很明确地就是为了避免再次触及你的依赖关系而存在的（所以你不能让缓存失效）。

### Caching too early ###

### 过早地缓存 ###

I don’t mean too early in the request lifecycle, I mean too early in the development cycle. Many times I have seen developers write code, decide that it is too slow, and stick cache in front of it.

From that point on, the fact that their service is slow is hidden. There is no reason to optimise or improve the solution as the cache will ensure that the second request is much quicker; so why worry, right?

我所指的早并不是在请求生命周期中而是指在开发周期中。我见过很多次这样的情况，开发者在写代码的时候就已经决定了这种做法会很慢，并在这之前设置缓存。

这样做的话，服务很慢的事实就被掩盖了。就没理由继续优化和改进解决方案了，因为缓存将会保证再次请求会快很多，那还有什么好担心的，对吧？

### Integrated Cache ###

### 全部缓存 ###

What’s the S in SOLID? Single Responsibility. If your caching capability is integrated directly in to your service layer and you can’t run without it you’re definitely in breach of this principle. It’s not my my place extoll the virtues of this principle here.

SOLID 中的 S 扮演着什么样的角色？它担负着单一的职责（缓存也是如此）。如果你将缓存功能直接集成到服务层，那么服务将不能离开缓存独立运行。这样你绝对是违反了模块独立的原则。我不是有意在这里赞美这项原则，但是事实就是这样。

### Caching everything ###

### 缓存所有内容 ###

Blindly applying caching to every external call to ensure responsiveness without a thought for he implications. Even worse, this approach can result in developers and operators not even knowing that caching is occurring and making assumptions about the reliability of the underlying services that are simply not true.

盲目地在每一个额外的调用中使用缓存，并以此确保响应时不用考虑其他因素。即使在更糟糕的情况下，这种方式也能在开发者和运维人员不知情的情况下产生缓存并造成底层服务很可靠的假象，但其实那并不是真的。

### Recaching ###

### 重复缓存 ###

Caching everything, or even just caching a lot, can result in caches that cache caches which cache caches.

On one end of the spectrum, this might result all internal caches expiring shortly before the very front cache, resulting in a huge waste of time and resources to operate layers and layers of caching which are never used.

At the other then, it can result effectively summing the cache expiry time of all caches involved, so 10 layers of 30 minutes caches can result in a system serving data which is 5 hours old. How’s *that* for counterintuitive?

缓存所有内容或者缓存过多内容，都可能导致重复缓存。

从另一方面来说，这可能会导致所有的核心缓存会在第一批缓存之前过期，这会造成时间和资源（操作层和缓存层未被使用的资源）上的极大浪费。

### Unflushable Cache ###

### 无法删除的缓存 ###

Occasionally cache implementations may back on to data stores like Redis which has management tooling which can be used to flush the cache on demand.

Other implementations, such as hand cranks in memory caches or even caches provided by mainstream frameworks will not expose any cache management tools. This leaves ops with the only option, to restart the service to flush the memory. (Or worse, know enough about the cache implementation to find it’s location on file system and clear it out manually.)

I have seen releases that have taken hours longer than necessary while different members of the team tried to track down cache after cache, flush them with a restart or wait for expiry before moving on to the next layer. All the time with a system taken offline because the system cannot be said to be consist within itself.

偶然情况下的缓存实现可能返回类似于 Redis 这种存储方式，并且可以使用管理工具来按需删除缓存。

其他的实现中，比如内存中的缓存甚至主流框架中提供的缓存都没有任何的管理工具。这让运维人员别无选择，只能通过重启服务来清空内存。（更糟糕的是，了解缓存的实现方式并在文件系统中找到其位置然后手动清除。）

我曾见过很多版本，团队中的不同成员尝试着跟踪缓存的位置，通过重启来清除缓存或者等待缓存过期之后才继续进行下一层的工作，他们所花费的数个小时实际上已经超过了这项工作所必须的时间。他们所有的时间都在跟一个离线的系统打交道，因为这个系统表里不一（因为缓存和实时数据可能会有区别）。

## The implications ##

## 暗示 ##

Caching data has implications which these mistakes can accentuate as well as new issues we didn’t have to think of before.

缓存数据意味着这些错误都可能被放大，也包括一些我们之前从没考虑过的新问题。

Deploying to a heavily cached system can be extremely time consuming while you wait for caches to expire or have to bust every cache you can find. Even in systems such as some CDNs I have worked with which serve traffic to tens of percent of the Internet and are thought to be the leaders in content delivery, flushing content and configuration caches globally can take up to two hours. This doesn’t need to be the case ([Fastly](https://www.fastly.com/products/instant-purging) can purge their cache in 150ms), and it results in confusion (is the new data being served yet?).

部署一个过度缓存的系统特别耗费时间，因为你不得不等待缓存过期或者销毁每个你能找到的缓存。即使是一些被公认为内容传输界领袖的 CDN 服务系统，在我的使用中也会有百分之十左右的网络服务阻塞，在那时删除全局内容和配置的缓存可能会达到两个小时之久。其实本不需要这么糟糕（[Fastly](https://www.fastly.com/products/instant-purging) 能够在 150ms 内清除缓存），并且这会让人感到迷惑（服务器是现在是新的数据了吗？）。

The natural response is to come up with a workaround, usually some of of cache busting. Let’s just think about that. A work around for a feature that you just implemented. Think about that, time, effort and cognitive load just to compensate for time, effort and cognitive load you just spent on caching in the first place.

自然的响应通常会带有一些附属工作，通常是销毁缓存。试想一下，你刚刚实现了一个功能，而花费在它附属工作上的时间、精力和可感的加载延迟正好补偿了一开始你从缓存中节省出来的部分。

Debugging a cached system also becomes a challenge as being up to your neck in a tricky debugging session will end up with unrelated things being missed or forgotten about. 3 hours of confusion later you realise that you haven’t actually been testing any of the changes you have been making.

调试一个缓存系统同样会变得极具挑战性。因为缓存会造成你做一些棘手的会话调试的瓶颈，最后你得出了结论，是因为丢失或者忘记了一些其实并不相关的内容。直到三个小时后你才突然意识到，实际上你并没有测试改动的内容（因为缓存一直存在）。

## What we should do instead ##

## 我们该怎样做呢？ ##

### Don’t cache! ###

### 不要缓存！ ###

Okay, sometimes caching is your only option. You’re on the web and it’s happening whether you like it or not. But even in this case there are options other than a simply slapping on `Cache-Control: max-age=xxx`.

好吧，有时候缓存是你的唯一选择，你在上网并且无论你喜不喜欢它都会发生。但是即使在这种情况下，除了使用 `Cache-Control: max-age=xxx` 之外，你还有其他选择。

### Know your data ###

### 了解你的数据 ###

You should know when your data was last modified at the very least. Now you can make use of the `If-Modified-Since` header. Return 304-not-modified if the data hasn’t changed. Now you can intelligently utilise the the client’s caching capability without sacrificing visibility and control. Using this header will let you serve new content instantly and also cache indefinitely. The best of both worlds. Taking it one step further, if you’re able to version you data (or just generate a hash of your response), you can make use of [etags](https://en.wikipedia.org/wiki/HTTP_ETag) and still interact with the client and apply appropriate logic without the latency related to data transfer.

你应该了解数据在何时被修改为最新。现在你可以使用 `If-Modified-Since` 头信息来实现，如果数据没有改变，服务器将返回 304-not-modified。现在你可以在不牺牲可见性和控制权的情况下巧妙地使用客户端的缓存能力。这个头部信息能使你立即使用新的内容并及时缓存。这两者双剑合璧，天下无敌。更进一步说，如果你能标记数据的版本（或者只是生成一个响应的哈希），你就能利用 [etags](https://en.wikipedia.org/wiki/HTTP_ETag) 并且仍然可以在和客户端的交互中提供正确的逻辑并且不会产生数据的延迟。

### Optimise for performance, don’t hide bad performance ###

### 优化性能，不要隐藏糟糕的性能 ###

Invest in profiler tooling. Find out why your application is slow and fix it. Reduce duplicate execution paths. Sort out bad query execution plans. Utilise indexes properly. If you’re using S3 or blob storage for your data you can always build your own index using Redis or the like. Redis is more than a cache. You can use it intelligently and get many benefits without the problems introduced by caching.

致力于分析工具的使用。利用工具找出应用运行慢的原因并修复它，减少重复的执行路径，找出糟糕的查询执行计划，正确地使用索引。如果你正在使用 S3 或者 blob 存储数据，你可以一直使用 Redis 或者类似的工具来建立自己的索引。Redis 并不仅仅是缓存系统，如果能够巧妙地使用它，你将受益良多并且不会有缓存引发的问题。

## Finale ##

## 最后 ##

Caching is a useful tool, but can be easily abused without giving any signs of the abuse.

缓存是很有用的工具，但是若不加以指点很容易被滥用。

Don’t get involved with caching till the last minute; find any other way you can first. Optimise your application before you use the blunt tool of caching.

不到最后关头，不要尝试使用缓存，首先要寻找其他方法。在使用迟钝的缓存工具之前首先要优化你的应用。

If you’ve come across any fundamental problems caused by caching and bad discipline there of, let me know and I can add them to the list.

如果你也遇到了一些由缓存或糟糕的法则导致的基础问题，请告诉我，以便我将它们也添加到文中。