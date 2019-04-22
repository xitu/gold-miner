> * 原文地址：[Retries, Timeouts and Backoff](https://namc.in/2019-04-15-retries-timeouts-backoff)
> * 原文作者：[namc](http://namc.in/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/retries-timeouts-backoff.md](https://github.com/xitu/gold-miner/blob/master/TODO1/retries-timeouts-backoff.md)
> * 译者：
> * 校对者：

# Retries, Timeouts and Backoff

Distributed systems are hard. While we learn a lot about making highly available systems, we often overlook resiliency in system design.

Sure we have heard about fault-tolerant, but what is “resilience” now? Personally, I like to define it a system’s ability to handle and eventually recover from unexpected conditions. There are several ways to go about making your systems resilient to failure, but in this post, we will focus on following

* [Timeouts](#timeouts)
* [Retries](#retries)
* [Backoff](#backoffs)
* [Idempotency in distributed system](#idempotency-in-distributed-systems)

## Timeouts

Timeout, simply put, is a maximum period of inactivity between two consecutive data packets.

I suppose we have worked with database drivers and http-clients at some point of time. All clients/drivers that help connect your service to an external server has a Timeout parameter, which often defaults to zero, or -1. This means that the timeout is undefined, or infinite.

eg - See the `connectTimeout` and `socketTimeout` definition [Mysql Connector Configuration](https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-configuration-properties.html)

Most requests to external servers should have a timeout attached. This is essential when the server is not responding in a timely manner. If this value is not set, and defaults to 0/-1 , your code may hang for minutes or even more. This happens because when you do not receive a response from application server and since your timeout is indefinite, or infintely large, the connection pool remains open. As more requests come in, more connections open up which consequently never close, thereby causing your connection pool to run out. This causes a cascading failure in your application.

So whenever you are configuring your application to use such connectors, please set an explicit timeout value in their configurations.

One must also implement timeouts on both, frontend and backend. That is, if a read/write operation is stuck on a rest api or socket for too long, an exception should be raised and connection should be broken. This should signal the backend to cancel the operation and close the connection, thereby preventing indefinitely open connections.

## Retries

We might need to understand a little about **transient failures** as we would be using that term frequently. Simply put, transient failures in your service are temporary glitches, e.g. a network congestion, database overload. Something which is perhaps correct itself given enough cool-off period.

**How to determine if a failure is transient?**

The answer lies in implementation detail of your API/Server responses. If you have a rest API, return a [503 Service Unavailable](https://tools.ietf.org/html/rfc7231#section-6.6.1) instead of other 5xx/4xx error messages. This will let the client know that the timeout is being caused by “a temporary overload” - not because of a code-level error.

Retries, although helpful, are a bit notorious if not configured properly. Here’s how you can figure out the correct way to use retries.

**Retry**

If the error received from the server is transient, e.g. a network packet got currupted while being transmitted, the application could retry the request immediately because the failure is unlike to happen again.

This is however very agressive, and could prove to be detrimental to your service, which might already be running at capacity, or unavailable completely. It also degrades the application response time as your service would be trying to perform a failing operation continuously.

If your business logic requires this retry policy, it is best to limit the number of retries to prevent further requests going to the same source.

**Retry after delay**

If the fault is caused due to connectivity failures or due to excess traffic on the network, the application should add a delay period as per business logic before retrying the requests.

```
for(int attempts = 0; attempts < 5; attempts++)
{
    try
    {
        DoWork();
        break;
    }
    catch { }
    Thread.Sleep(50); // Delay
}
```
    

When using a library that connects to external services, please check if it implements retry policies, allowing you to configure maximum number of retries, delay between retries etc.

You can also implement retry policy on server-side, by setting a [Retry-After](https://tools.ietf.org/html/rfc7231#section-7.1.3) in response header.

It is also important to log why the operation might be failing. Some times it is due to lack of resources which can handled by adding more instances of that service. Other times it could be due to a memory leak, or a null-pointer exceptions. Hence, it is imperative to add logs and track the performance of your application.

## Backoffs

As we saw above, we can add delay to the retry policy. This delay is often referred to as _linear backoff_. This approach may not be the best way to implement a retry policy.

Consider the case where the fault in your service could be happening because the database is overloaded. It is quite possible that after some retries our request might succeed. It is also possible that consequent requests might be **adding to the overload** of your database server.Thus, the service would be in overloaded state far longer and will take more time to recover from this state.

There are several strategies that can be used to solve this problem.

**1. [Exponential Backoff](https://en.wikipedia.org/wiki/Exponential_backoff)**

As the name suggests. instead of period delay of, say 5 seconds, between retries, increase the delay between requests exponentially. We do this till we reach the maximum retry limit. If the request continues to fail, let the client know that the request has failed.

You must also set a limit on how large the delay can be. Exponential backoff might result in setting a delay which is very large, thereby keeping the request socket open indefinitely, and making the thread sleep for “eternity”. This will drain the system resources, thereby causing more problems with connection pools.

```
int delay = 50
for(int attempts = 0; attempts < 5; attempts++)
{
    try
    {
        DoWork();
        break;
    }
    catch { }
    
    Thread.sleep(delay);
    if (delay < MAX_DELAY)      // MAX_DELAY could depend upon application and business logic 
    {
        delay *= 2;
    }
}
```
    

One major drawback of exponential backoff is seen in distributed systems, where **requests that backoff at the same time, also retry at the same time**. This causes clusters of calls. Therefore, instead of reducing number of clients competing in every round, we have now introduced periods when no client is competing. A fixed progression exponential backoff does not reduce the contention much, and generates **peaks of loads**.

**2. [Backoff with jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/)**

In order to deal with load of spikes as mentioned in exponential backoff, we add _jitter_ to our backoff strategy. Jitter is a decorrelation strategy, it adds randomness to retry intervals and spreads out the load. This avoids cluster of network calls.

Jitter is usually not part of any configuration property and needs to implemented by the client. All it only requires is a function which can add randomness, and dynamically calculate the duration to wait before retrying.

By introducing jitter, the initial group of failing requests may be clustered in a very small window, say 100ms, but with each retry cycle, the cluster of requests spreads into a larger and larger time window, thereby reducing the size of the spike at a given time. The service is likely to be able to handle the requests when spread over a sufficiently large window.

```
int delay = 50
for(int attempts = 0; attempts < 5; attempts++)
{
    try
    {
        DoWork();
        break;
    }
    catch { }
    
    Thread.sleep(delay);
    delay *= random.randrange(0, min(MAX_DELAY, delay * 2 ** i)) // just a simple random number generation
}
```

In case of **long-lasting transient failures**, retries of any kind might not be the best approach. This could be due to a connectivity failure, power outtage (yes, they are very real) etc. The client would end up retrying several times, wasting system resources, further leading to cascading failures across multiple systems.

So we need a mechanism to determine if the failure is long-lasting, and implement a solution to handle it.

**3. [Circuit Breakers](https://en.wikipedia.org/wiki/Circuit_breaker_design_pattern)**

Circuit Breaker pattern is useful for handling long-lasting transient failures of a service by determining its availability, preventing the client from retrying requests that are bound to fail.

Circuit breaker design pattern requires that the state of the connection be retained over a series of requests. Lets look at this [Circuit breaker implementation by failsafe](https://github.com/jhalterman/failsafe#circuit-breakers)

```
CircuitBreaker breaker = new CircuitBreaker()
  .withFailureThreshold(5)
  .withSuccessThreshold(3)
  .withDelay(1, TimeUnit.MINUTES);

Failsafe.with(breaker).run(() -> connect());
``` 

When everything runs as expected, there are no outtages, the circuit breaker remains in a closed state.

When a threshold of executation failures occur, the circuit breaker trips and goes into **open** state, which means, all consequent requests will continue to fail without going through retry logic.

After a delay (1 minute as mentioned above), the circuit will go into **half-open** state, just to test if the problem with network call still exists, thereby deciding if the circuit should be closed or opened. If it succeeds, the circuit resets to **closed** state, else it is set as **open** again.

This helps in avoiding cluster of retry executions during long lasting faults, saving system resources.

While this can be maintained locally in a state variable, you might need an external storage layer if you have a **distributed system**. In a multi-node setup, the state of application server will need to shared across all instances. In such a scenario, you can use Redis, memcached to keep a record of the availability of external services. Before making any requests to external service, the state of service is queried from the persistent storage.

## Idempotency in distributed systems

A service is idempotent when clients can make same requests repeatedly while producing same end-result. While the operation would produce same result on the server, it might not give the same response to client.

In case of REST APIs, you need to remember -

* **POST** is NOT idempotent - POST causes new resources to be created on server. “n” POST requests result in creating “n” new resources on the server.
* **GET**, **HEAD**, **OPTIONS** and **TRACE** methods NEVER change the resource state on server. Hence, they are always idempotent.
* **PUT** requests are idempotent. “n” put requests will overwrite the same resource “n-1” times.
* **DELETE** is idempotent because it would return 200 (OK) initially, and 204 (No Content) or 404 (Not Found) on subsequent calls.

**Why care about idempotent operations?**

In a distributed system, there are several server and client nodes. If you make a request from Client to Server A which fail, or times out, then you would like to able to simply make that request again, without worrying if the previous request had any side-effects.

This is extremely essential in micro-services where a lot of components operate independently.

Some key benefits of idempotency are -

* **Minimal complexity** - No need to worry about side effects, any request can be simply retried, and same end-result is achieved.
* **Easier to implement** - You would not need to add logic to handle previous failed requests in your retry mechanism.
* **Easier to test** - Each action result in same result, no surprises.

## Final notes

We went through a bunch of ways you can build a more fault-tolerant system. However, that is not all. In closing, I would like to add a few pointers you can look into, which might help make your systems more available and tolerant to failures.

* In a multi-node setup, if a client is retrying several times, the requests are likely to hit the same server. When this happens, it is best to give a failure response and making the client try again from scratch.
* Profile your systems, keep them prepared for the worst. You might want to check out [Chaos Monkey by Netlifx](https://github.com/Netflix/chaosmonkey) - its a resiliency tool which triggers random failures in your system. This keeps you prepared for faults that might occur, helping you build a resilient system.
* If your systems are under excessive loads for some reason, you can try distributing it by load shedding. Google did a brilliant [case study](https://cloud.google.com/blog/products/gcp/using-load-shedding-to-survive-a-success-disaster-cre-life-lessons) which can serve as a good starting point.

* * *

Resources:

* [Patterns for distributed systems](https://www.dre.vanderbilt.edu/~schmidt/patterns-ace.html)
* [Retry Patterns - Microsoft](https://docs.microsoft.com/en-us/azure/architecture/patterns/retry)
* [Martin Fowler Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)

Thank you! ❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
