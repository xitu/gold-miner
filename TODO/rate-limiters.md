> * 原文地址：[Scaling your API with rate limiters](https://stripe.com/blog/rate-limiters)
> * 原文作者：[Paul Tarjan](https://stripe.com/about#pt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# [Scaling your API with rate limiters](/blog/rate-limiters) #


Availability and reliability are paramount for all web applications and APIs. If you’re providing an API, chances are you’ve already experienced sudden increases in traffic that affect the quality of your service, potentially even leading to a service outage for all your users.

The first few times this happens, it’s reasonable to just add more capacity to your infrastructure to accommodate user growth. However, when you’re running a production API, not only do you have to make it robust with techniques like [idempotency](/blog/idempotency), you also need to build for scale and ensure that one bad actor can’t accidentally or deliberately affect its availability.

Rate limiting can help make your API more reliable in the following scenarios:

- One of your users is responsible for a spike in traffic, and you need to stay up for everyone else.
- One of your users has a misbehaving script which is accidentally sending you a lot of requests. Or, even worse, one of your users is intentionally trying to overwhelm your servers.
- A user is sending you a lot of lower-priority requests, and you want to make sure that it doesn’t affect your high-priority traffic. For example, users sending a high volume of requests for analytics data could affect critical transactions for other users.
- Something in your system has gone wrong internally, and as a result you can’t serve all of your regular traffic and need to drop low-priority requests.

At Stripe, we’ve found that carefully implementing a few [rate limiting](https://en.wikipedia.org/wiki/Rate_limiting) strategies helps keep the API available for everyone. In this post, we’ll explain in detail which rate limiting strategies we find the most useful, how we prioritize some API requests over others, and how we started using rate limiters safely without affecting our existing users’ workflows.


## Rate limiters and load shedders

A *rate limiter* is used to control the rate of traffic sent or received on the network. When should you use a rate limiter? If your users can afford to change the pace at which they hit your API endpoints without affecting the outcome of their requests, then a rate limiter is appropriate. If spacing out their requests is not an option (typically for real-time events), then you’ll need another strategy outside the scope of this post (most of the time you just need more infrastructure capacity).

Our users can make a lot of requests: for example, batch processing payments causes sustained traffic on our API. We find that clients can always (barring some extremely rare cases) spread out their requests a bit more and not be affected by our rate limits.

Rate limiters are amazing for day-to-day operations, but during incidents (for example, if a service is operating more slowly than usual), we sometimes need to drop low-priority requests to make sure that more critical requests get through. This is called *load shedding*. It happens infrequently, but it is an important part of keeping Stripe available.

A *load shedder* makes its decisions based on the whole state of the system rather than the user who is making the request. Load shedders help you deal with emergencies, since they keep the core part of your business working while the rest is on fire.


## Using different kinds of rate limiters in concert

Once you know rate limiters can improve the reliability of your API, you should decide which types are the most relevant.

At Stripe, we operate 4 different types of limiters in production. The first one, the *Request Rate Limiter*, is by far the most important one. We recommend you start here if you want to improve the robustness of your API.

### Request rate limiter

This rate limiter restricts each user to *N* requests per second. Request rate limiters are the first tool most APIs can use to effectively manage a high volume of traffic.

Our rate limits for requests is constantly triggered. It has rejected millions of requests this month alone, especially for test mode requests where a user inadvertently runs a script that’s gotten out of hand.

Our API provides the same rate limiting behavior in both test and live modes. This makes for a good developer experience: scripts won't encounter side effects due to a particular rate limit when moving from development to production.

After analyzing our traffic patterns, we added the ability to briefly burst above the cap for sudden spikes in usage during real-time events (e.g. a flash sale.)

![](https://stripe.com/img/blog/posts/rate-limiters/1-request-rate-limiter.svg)

Request rate limiters restrict users to a maximum number of requests per second.

### Concurrent requests limiter

Instead of “You can use our API 1000 times a second”, this rate limiter says “You can only have 20 API requests in progress at the same time”. Some endpoints are much more resource-intensive than others, and users often get frustrated waiting for the endpoint to return and then retry. These retries add more demand to the already overloaded resource, slowing things down even more. The concurrent rate limiter helps address this nicely.

Our concurrent request limiter is triggered much less often (12,000 requests this month), and helps us keep control of our CPU-intensive API endpoints. Before we started using a concurrent requests limiter, we regularly dealt with resource contention on our most expensive endpoints caused by users making too many requests at one time. The concurrent request limiter totally solved this.

It is completely reasonable to tune this limiter up so it rejects more often than the Request Rate Limiter. It asks your users to use a different programming model of “Fork off X jobs and have them process the queue” compared to “Hammer the API and back off when I get a HTTP 429”. Some APIs fit better into one of those two patterns so feel free to use which one is most suitable for the users of your API.

![](https://stripe.com/img/blog/posts/rate-limiters/2-concurrent-requests-limiter.svg)

Concurrent request limiters manage resource contention for CPU-intensive API endpoints.

### Fleet usage load shedder

Using this type of load shedder ensures that a certain percentage of your fleet will always be available for your most important API requests.

We divide up our traffic into two types: critical API methods (e.g. creating charges) and non-critical methods (e.g. listing charges.) We have a Redis cluster that counts how many requests we currently have of each type.

We always reserve a fraction of our infrastructure for critical requests. If our reservation number is 20%, then any non-critical request over their 80% allocation would be rejected with status code 503.

We triggered this load shedder for a very small fraction of requests this month. By itself, this isn’t a big deal—we definitely had the ability to handle those extra requests. But we’ve had other months where this has prevented outages.

![](https://stripe.com/img/blog/posts/rate-limiters/2-concurrent-requests-limiter.svg)

Fleet usage load shedders reserves fleet resources for critical requests.

### Worker utilization load shedder

Most API services use a set of workers to independently respond to incoming requests in a parallel fashion. This load shedder is the final line of defense. If your workers start getting backed up with requests, then this will shed lower-priority traffic.

This one gets triggered very rarely, only during major incidents.

We divide our traffic into 4 categories:

1. Critical methods
2. POSTs
3. GETs
4. Test mode traffic

We track the number of workers with available capacity at all times. If a box is too busy to handle its request volume, it will slowly start shedding less-critical requests, starting with test mode traffic. If shedding test mode traffic gets it back into a good state, great! We can start to slowly bring traffic back. Otherwise, it’ll escalate and start shedding even more traffic.

It’s very important that shedding and bringing load happen slowly, or you can end up flapping (“I got rid of testmode traffic! Everything is fine! I brought it back! Everything is awful!”). We used a lot of trial and error to tune the rate at which we shed traffic, and settled on a rate where we shed a substantial amount of traffic within a few minutes.

Only 100 requests were rejected this month from this rate limiter, but in the past it’s done a lot to help us recover more quickly when we have had load problems. This load shedder limits the impact of incidents that are already happening and provides damage control, while the first three are more preventative.

![](https://stripe.com/img/blog/posts/rate-limiters/4-worker-utilization-load-shedder.svg)

Worker utilization load shedders reserve workers for critical requests.


## Building rate limiters in practice

Now that we’ve outlined the four basic kinds of rate limiters we use and what they’re for, let’s talk about their implementation. What rate limiting algorithms are there? How do you actually implement them in practice?

We use the [token bucket algorithm](https://en.wikipedia.org/wiki/Token_bucket) to do rate limiting. This algorithm has a centralized bucket host where you take tokens on each request, and slowly drip more tokens into the bucket. If the bucket is empty, reject the request. In our case, every Stripe user has a bucket, and every time they make a request we remove a token from that bucket.

We implement our rate limiters using Redis. You can either operate the Redis instance yourself, or, if you use Amazon Web Services, you can use a managed service like [ElastiCache](https://aws.amazon.com/elasticache/).

Here are important things to consider when implementing rate limiters:

- **Hook the rate limiters into your middleware stack safely.** Make sure that if there were bugs in the rate limiting code (or if Redis were to go down), requests wouldn’t be affected. This means catching exceptions at all levels so that any coding or operational errors would fail open and the API would still stay functional.
- **Show clear exceptions to your users.** Figure out what kinds of exceptions to show your users. In practice, you should decide if you want [HTTP 429](https://tools.ietf.org/html/rfc6585#section-4) (Too Many Requests) or [HTTP 503](https://tools.ietf.org/html/rfc7231#section-6.6.4) (Service Unavailable) and what is the most accurate depending on the situation. The message you return should also be actionable.
- **Build in safeguards so that you can turn off the limiters.** Make sure you have kill switches to disable the rate limiters should they kick in erroneously. Having feature flags in place can really help should you need a human escape valve. Set up alerts and metrics to understand how often they are triggering.
- **Dark launch each rate limiter to watch the traffic they would block.** Evaluate if it is the correct decision to block that traffic and tune accordingly. You want to find the right thresholds that would keep your API up without affecting any of your users’ existing request patterns. This might involve working with some of them to change their code so that the new rate limit would work for them.


## Conclusion

Rate limiting is one of the most powerful ways to prepare your API for scale. The different rate limiting strategies described in this post are not all necessary on day one, you can gradually introduce them once you realize the need for rate limiting.

Our recommendation is to follow the following steps to introduce rate limiting to your infrastructure:

1. Start by building a Request Rate Limiter. It is the most important one to prevent abuse, and it’s by far the one that we use the most frequently.
2. Introduce the next three types of rate limiters over time to prevent different classes of problems. They can be built slowly as you scale.
3. Follow good launch practices as you're adding new rate limiters to your infrastructure. Handle any errors safely, put them behind feature flags to turn them off easily at any time, and rely on very good observability and metrics to see how often they’re triggering.

To help you get started, we’ve created a [GitHub gist](https://gist.github.com/ptarjan/e38f45f2dfe601419ca3af937fff574d) to share implementation details based on the code we actually use in production at Stripe.

  Like this post? Join the Stripe engineering team. [View Openings](/jobs?ref=blog#engineering)    


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
