> * 原文地址：[Performance Under Load](https://medium.com/@NetflixTechBlog/performance-under-load-3e6fa9a60581)
> * 原文作者：[Netflix Technology Blog Netflix Technology Blog](https://medium.com/@NetflixTechBlog)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/performance-under-load.md](https://github.com/xitu/gold-miner/blob/master/TODO1/performance-under-load.md)
> * 译者：
> * 校对者：

# Performance Under Load

*Adaptive Concurrency Limits @ Netflix*
>  by Eran Landau, William Thurston, Tim Bozarth

At Netflix we are obsessed with service availability, and we’ve written several blog posts over the years about how we achieve our goals. These techniques include circuit breakers, concurrency limits, chaos testing and more. Today we’re announcing our most recent innovation: adaptive concurrency limits. Adaptive concurrency limits fundamentally improve how an application behaves under extreme load, and allow us to avoid cascading service failures. We have eliminated the arduous task of trying to determine the concurrency limit of a system, while ensuring that latencies remain low. With this announcement, we’re also open-sourcing a simple Java library with integrations for servlets, executors and GRPC.

## A little background first

Concurrency is nothing more than the number of requests a system can service at any given time and is normally driven by a fixed resource such as CPU. A system’s concurrency is normally calculated using Little’s law, which states: For a system at steady state, concurrency is the product of the average service time and the average service rate (L = 𝛌W). Any requests in excess of this concurrency cannot immediately be serviced and must be queued or rejected. With that said some queueing is necessary as it enables full system utilization in spite of non-uniform request arrival and service time.

![](https://cdn-images-1.medium.com/max/2468/1*XurJ5f2Hjf4lO-GspmCRIw.png)

Systems fail when no limit is enforced on this queue, such as during prolonged periods of time where the arrival rate exceeds the exit rate. As the queue grows so will latency until all requests start timing out and the system will ultimately run out of memory and crash. If left unchecked latency increases start adversely affecting it’s callers leading to cascading failures through the system.

![](https://cdn-images-1.medium.com/max/2432/1*HuSIJZzGk7RSeJbnINF-DQ.png)

Enforcing concurrency limits is nothing new; the hard part is figuring out this limit in a large dynamic distributed system where concurrency and latency characteristics are constantly changing. The main purpose of our solution is to dynamically identify this concurrency limit. This limit can be seen as maximum number of inflight requests (concurrency + queue) allowed before performance (i.e. latency) starts to degrade.

## The solution

Historically, at Netflix we’ve manually configured fixed concurrency limits measured via an arduous process of performance testing and profiling. While this provided an accurate value at that moment in time, the measured limit would quickly become stale as a system’s topology changes due to partial outages, auto-scaling or from code pushes that impact latency characteristics.

We knew we could to do better than static concurrency limits, so we sought to automatically identify a system’s inherent concurrency limit in a way that would:

 1. Require no manual work

 2. Require no centralized coordination

 3. Infer the limit without any knowledge of the hardware or system topology

 4. Adapt to changes in system topology

 5. Easy to compute and enforce

To solve this problem we turned to tried and true TCP congestion control algorithms that seek to determine how many packets may be transmitted concurrently (i.e. congestion window size) without incurring timeouts or increased latency. These algorithms keep track of various metrics to estimate the system’s concurrency limit and constantly adjust the congestion window size.

![](https://cdn-images-1.medium.com/max/2496/1*rWdqQuqi50OJNLnGeDgo1w.png)

Here we see a system with an unknown concurrency in blue. The client starts by sending requests at a low concurrency while frequently probing for higher concurrency by increasing the congestion window as long as latencies don’t go up. When latencies do increase the sender assumes to have reached the limit and backs off to a smaller congestion window size. The limit is continually probed resulting in the common saw-tooth pattern.

Our algorithm builds on latency based TCP congestion control algorithm that look at the ratio between the minimum latency (representing the best case scenario without queuing) and a time sampled latency measurement as a proxy to identifying that a queue has formed and is causing latencies to rise. This ratio gives us the gradient or magnitude of latency change: **gradient=(RTTnoload/RTTactual)** . A value of 1 indicates no queueing and that the limit can be increased. A value less than 1 indicates that an excessive queue has formed and that the limit should be decreased. With each new sample the limit adjusts using this ratio and adding an allowable queue size using the simple formula,

    **newLimit = currentLimit × gradient + queueSize**

After several iterations the algorithm converges on a limit that keeps latencies low while allowing for some queuing to account for bursts. Allowable queue size is tunable and is used to determine how quickly the limit may grow. We settled on a good default of the square root of the current limit. We chose square root mostly because it has the useful property of being large relative to the current limit for low numbers, thereby allowing for faster growth, but reduces for larger numbers for better stability.

## Adaptive Limits in Action

When enabled, adaptive server side limits reject excess RPS and keep latency low, allowing the instance to protect itself and the services it depends on. Without rejecting excess traffic, any sustained increase in RPS or latency previously translated to even worse latencies and ultimately system failure. Services are now able to shed excess load and keep latencies low while other mitigating actions such as auto-scaling kick into action.

![](https://cdn-images-1.medium.com/max/2452/1*sfDL_PVx-lCAs3W4z_S0cQ.png)

It’s important to note that limits are enforced at the server level (with no coordination) and that traffic to each server can be fairly bursty. The discovered limit and number of concurrent requests can therefore vary from server to server, especially in a multi-tenant cloud environment. This can result in shedding by one server when there was enough capacity elsewhere. With that said, using client side load balancing a single client retry is nearly 100% successful at reaching an instance with available capacity. Better yet, there’s no longer a concern about retries causing DDOS and retry storms as services are able to shed traffic quickly in sub millisecond time with minimum impact to performance.

## Conclusion

As we roll out adaptive concurrency limits we’re eliminating the need to babysit and manually tune how our services shed load. Even more, it does it while simultaneously improving the overall reliability and availability of our whole microservice-based ecosystem.

We’re excited to share our implementation and common integrations in a small open source library that can be found at [http://github.com/Netflix/concurrency-limits](http://github.com/Netflix/concurrency-limits). Our hope is that anyone interested in shielding their services from cascading failures and load-related latency degradation can take advantage of our code to achieve better availability. We look forward to feedback from the community and are happy to accept pull requests with new algorithms or integrations.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
