
> * 原文地址：[The Caching Antipattern](https://www.hidefsoftware.co.uk/2016/12/25/the-caching-antipattern/)
* 原文作者：[ROBERT STIFF](https://www.hidefsoftware.co.uk/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# The Caching Antipattern #

TL;DR - Caching done badly has bad implications. Try your hardest not to cache data; but if you really do have to, make sure you do it right.

---

> There are only two hard things in Computer Science: cache invalidation and naming things.
> 
> – Phil Karlton

## Caching? ##

To make sure we’re on the same page, when I say *caching*, I am talking about the practice of speeding up your own application by masking slow dependencies by remembering previous responses and using them instead of making another slow call to the dependency.

As mentioned breifly by Phil Karlton in his well known sound byte, caching is a tricky problem. This is compounded by a number of common mistakes which I have seen over the years which have resulted in unnecessary confusion delay.

## Common Mistakes ##

Here are some of the mistakes I have seen and what we should to differently.

### Cache on startup ###

When you know for a fact that your dependencies are so slow they are unusable so you don’t even try at run time. Pre-populating a cache as your application starts up rather than querying your dependent service is just admitting that your dependency is not fit for purpose. If it’s a 3rd party service then maybe there is nothing you can do about that, but all too often this technique is used to avoid having to make your services actually fit for purpose.

The problem with caching like this is that it extends application startup times, making scaling and failure recovery or even non-viable.

And even if you are okay with having a service that is slow to start or restart (which you shouldn’t be) it results in a cache which bares no relation to the nature of the data or your service’s usage patterns. A simple cache expiry policy would be meaningless here, as this pattern explicitly exists to avoid ever hitting your dependencies again.

### Caching too early ###

I don’t mean too early in the request lifecycle, I mean too early in the development cycle. Many times I have seen developers write code, decide that it is too slow, and stick cache in front of it.

From that point on, the fact that their service is slow is hidden. There is no reason to optimise or improve the solution as the cache will ensure that the second request is much quicker; so why worry, right?

### Integrated Cache ###

What’s the S in SOLID? Single Responsibility. If your caching capability is integrated directly in to your service layer and you can’t run without it you’re definitely in breach of this principle. It’s not my my place extoll the virtues of this principle here.

### Caching everything ###

Blindly applying caching to every external call to ensure responsiveness without a thought for he implications. Even worse, this approach can result in developers and operators not even knowing that caching is occurring and making assumptions about the reliability of the underlying services that are simply not true.

### Recaching ###

Caching everything, or even just caching a lot, can result in caches that cache caches which cache caches.

On one end of the spectrum, this might result all internal caches expiring shortly before the very front cache, resulting in a huge waste of time and resources to operate layers and layers of caching which are never used.

At the other then, it can result effectively summing the cache expiry time of all caches involved, so 10 layers of 30 minutes caches can result in a system serving data which is 5 hours old. How’s *that* for counterintuitive?

### Unflushable Cache ###

Occasionally cache implementations may back on to data stores like Redis which has management tooling which can be used to flush the cache on demand.

Other implementations, such as hand cranks in memory caches or even caches provided by mainstream frameworks will not expose any cache management tools. This leaves ops with the only option, to restart the service to flush the memory. (Or worse, know enough about the cache implementation to find it’s location on file system and clear it out manually.)

I have seen releases that have taken hours longer than necessary while different members of the team tried to track down cache after cache, flush them with a restart or wait for expiry before moving on to the next layer. All the time with a system taken offline because the system cannot be said to be consist within itself.

## The implications ##

Caching data has implications which these mistakes can accentuate as well as new issues we didn’t have to think of before.

Deploying to a heavily cached system can be extremely time consuming while you wait for caches to expire or have to bust every cache you can find. Even in systems such as some CDNs I have worked with which serve traffic to tens of percent of the Internet and are thought to be the leaders in content delivery, flushing content and configuration caches globally can take up to two hours. This doesn’t need to be the case ([Fastly](https://www.fastly.com/products/instant-purging) can purge their cache in 150ms), and it results in confusion (is the new data being served yet?).

The natural response is to come up with a workaround, usually some of of cache busting. Let’s just think about that. A work around for a feature that you just implemented. Think about that, time, effort and cognitive load just to compensate for time, effort and cognitive load you just spent on caching in the first place.

Debugging a cached system also becomes a challenge as being up to your neck in a tricky debugging session will end up with unrelated things being missed or forgotten about. 3 hours of confusion later you realise that you haven’t actually been testing any of the changes you have been making.

## What we should do instead ##

### Don’t cache! ###

Okay, sometimes caching is your only option. You’re on the web and it’s happening whether you like it or not. But even in this case there are options other than a simply slapping on `Cache-Control: max-age=xxx`.

### Know your data ###

You should know when your data was last modified at the very least. Now you can make use of the `If-Modified-Since` header. Return 304-not-modified if the data hasn’t changed. Now you can intelligently utilise the the client’s caching capability without sacrificing visibility and control. Using this header will let you serve new content instantly and also cache indefinitely. The best of both worlds. Taking it one step further, if you’re able to version you data (or just generate a hash of your response), you can make use of [etags](https://en.wikipedia.org/wiki/HTTP_ETag) and still interact with the client and apply appropriate logic without the latency related to data transfer.

### Optimise for performance, don’t hide bad performance ###

Invest in profiler tooling. Find out why your application is slow and fix it. Reduce duplicate execution paths. Sort out bad query execution plans. Utilise indexes properly. If you’re using S3 or blob storage for your data you can always build your own index using Redis or the like. Redis is more than a cache. You can use it intelligently and get many benefits without the problems introduced by caching.

## Finale ##

Caching is a useful tool, but can be easily abused without giving any signs of the abuse.

Don’t get involved with caching till the last minute; find any other way you can first. Optimise your application before you use the blunt tool of caching.

If you’ve come across any fundamental problems caused by caching and bad discipline there of, let me know and I can add them to the list.
