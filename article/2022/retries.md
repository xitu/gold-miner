> * 原文地址：[Fixing retries with token buckets and circuit breakers](https://brooker.co.za/blog/2022/02/28/retries.html)
> * 原文作者：[Marc Brooker](https://brooker.co.za/blog/publications.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/retries.md](https://github.com/xitu/gold-miner/blob/master/article/2022/retries.md)
> * 译者：
> * 校对者：

# Fixing retries with token buckets and circuit breakers

After my last post on [circuit breakers](https://brooker.co.za/blog/2022/02/16/circuit-breakers.html), a couple of people reached out to recommend using circuit breakers only to break retries, and still send normal first try traffic no matter the failure rate. That's a nice approach. It provides possible solutions to the core problem with client-side circuit breakers (they may make partial outages worse), and to the retry problem (where retries increase load on already-overloaded downstream services). To see how well that works, we can compare it to my favorite **better retries** approach: a token bucket.

First, let's formally introduce the players:

* **No retries**. When a client wants to make a call, it makes that call as normal. If it fails, the client moves on without retrying.
* **N retries**. When a client wants to make a call, it makes that call as normal. If it fails, the client makes a maximum of N retries of the call.
* **Adaptive Retries** (aka the **retry token bucket**). When a client wants to make a call, it makes that call as normal. If it succeeds, it drops part of a token into a limited-size [token bucket](https://en.wikipedia.org/wiki/Token_bucket). If the call fails, retry up to N times as long as there are (whole) tokens in the bucket. For example, each success could deposit 0.1 tokens, and each retry could consume 1 token.
* **Retry circuit breaker**. When a client wants to make a call, it makes that call as normal. On success or failure, it updates statistics which track the (recent) failure rate. If that failure rate is below a threshold, it retries up to N times. If it's above the threshold, it doesn't retry at all.

**Think it through**

First, let's try think through how each of these would perform.

No retries is the easiest. If the downstream failure rate is x%, the effective failure rate is x%.

N retries is the next easiest. If the downstream failure rate is x%, the effective failure rate is (1-x)N, but with significant additional work. At 100% failure rate, the system does 1+N times as much work.

The adaptive strategy is a little difficult to think about, but the rough idea is that it behaves like **N retries** when failure rates are low, and "some percent retries" when the failure rate is higher. For example, if each successful calls puts 10% of a token into the bucket, adaptive behaves like **N retries** a lot below 10% failure rate, and like "0.1 retries" much above 10% failure rate.

The circuit breaker strategy is somewhat similar. At low rates (below the threshold) it behaves like **N retries**. Above the threshold it behaves like **no retries**. This is a little complicate by the fact that each client doesn't know the true failure rate, and instead makes its decision based on a local sampling of the failure rate (which may vary substantially from the true rate for small clients).

Closed-form reasoning about these dynamics are difficult. Instead of trying to reason about it, we can simulate the effects with a small event-driven simulation of a service and clients. I'll write more in future about this simulation approach, but will start with some results.

**Simulating Performance**

Let's consider a model with a single abstract service, which randomly fails calls at some rate. The service is called by 100 independent clients, each starting new attempts at some rate[1](#foot1). We're concerned with two results: the success rate the client sees, and the load the server sees from the clients. In particular, we're concerned with how those things vary with the failure rate.

![Graph of failure rates and load for four retry strategies](https://mbrooker-blog-images.s3.amazonaws.com/retry_simulation_results.png)

We can immediately see a couple of expected things, and a few interesting things. As expected, **no retries** does no extra work, and provides availability that drops linearly with the failure rate. **Three retries** does a lot of extra work, and provides the best robustness against errors. The breaker strategy does extra work, and provides extra robustness at low failure rates, but drops down to match **no retries** after a threshold.

Let's zoom in a bit to the lower rates:

![Graph of failure rates and load for four retry strategies](https://mbrooker-blog-images.s3.amazonaws.com/retry_simulation_results_zoomed.png)

We can see the strategies start to diverge. The first interesting observation is that the breaker strategy starts tripping a little early: around half the expected rate. That's because each client is breaking independently. In this low-failure regime, the **adaptive** strategy is very similar to **three retries**, but slowly starting to diverge.

**The effect of client count**

Both the **adaptive** and **circuit breaker** approach depend on per-client estimates of the failure rate, either expressed explicitly with the circuit breaker failure threshold, or implicitly with the contents of the token bucket. When the number of clients is low, it's reasonable to expect that that these per-client estimates will converge on the true failure rate. With larger numbers of clients sending small volumes of traffic, estimates will vary more widely. This is especially important in serverless and container-based architectures, where clients may be numerous and short-lived, with each doing relatively little work (compared, say, to a multi-threaded monolith where a single client may see the work of very large numbers of threads).

We can simulate the effects of client count on the performance of our **adaptive** and **circuit breaker** strategies. Here, we've got the same total number of requests divided among 10, 100, and 1000 clients:

![Graph of failure rates and loads for different numbers of clients](https://mbrooker-blog-images.s3.amazonaws.com/retry_simulation_results_clients.png)

What's interesting here is that the two approaches have the opposite behavior. The **circuit breaker** strategy is tripping too early, and approaching the performance of the **no retries** approach. The **token bucket** strategy (starting with a full bucket) doesn't deplete its bucket fast enough, converging on the behavior of **n retries**. Clearly, neither does a perfect job of solving the retry problem with limited per-client knowledge. A model with state shared between clients would change these results, but also significantly increase the complexity of the system (because clients would need to discover and talk to each other).

**Which one is better?**

Choosing the right retry strategy depends on what we want to achieve. The ideal is to have a solution with no additional load and 100% success rate no matter the service failure rate. That's clearly unachievable for a simple reason: clients don't have any way to know which requests will succeed. The only mechanism they have is trying.

Short of that ideal, what can we have? What most applications want is to have a high success rate when the server failure rate is low, and not too much additional load. **No retries** fails on the first criterion, and **N retries** fails on the second. Both the **adaptive** and **circuit breaker** strategies succeed to different extents. The circuit breaker approach gives no additional load at high failure rates, which is great. But it suffers from some modality (it's either retrying or not retrying, and might switch back and forth between the two). The **adaptive** strategy isn't modal in the same way, and seems to perform better at lower failure rates, but does give some (tunable) additional load at higher rates.

**Footnotes**

1. In other words, each client presents independent Poisson-process arrivals, and keeps its own retry state. The Poisson model here isn't entirely accurate, but doesn't matter because we're not (yet) modelling overload or concurrency.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
