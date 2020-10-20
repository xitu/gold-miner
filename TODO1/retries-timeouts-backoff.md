> * 原文地址：[Retries, Timeouts and Backoff](https://namc.in/2019-04-15-retries-timeouts-backoff)
> * 原文作者：[namc](http://namc.in/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/retries-timeouts-backoff.md](https://github.com/xitu/gold-miner/blob/master/TODO1/retries-timeouts-backoff.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[fireairforce](https://github.com/fireairforce)

# 重试、超时和退避

分布式系统很难。即使我们学了很多构建高可用性系统的方法，也常常会忽略系统设计中的弹性（resiliency）。

我们肯定听说过容错性，但什么是“弹性”呢？个人而言，我喜欢将其定义为系统处理意外情况并最终从中恢复的能力。有很多方法使你的系统能从故障中回弹，但在这篇文章中，我们主要关注以下几点：

* [超时](#超时)
* [重试](#重试)
* [退避](#退避)
* [分布式系统中的幂等性](#分布式系统中的幂等性)

## 超时

简单来说，超时就是两个连续的数据包之间的最大不活动时间。

假设我们在某个时刻已经使用过了数据库驱动和 HTTP 客户端。所有帮助你的服务连接到一个外部服务器的客户端或驱动都有 Timeout 参数。这个参数通常默认为零或 -1，表示超时时间未定义，或是无限时间。

例如：参考 `connectTimeout` 和 `socketTimeout` 的定义 [Mysql Connector 配置](https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-configuration-properties.html)

大多数对外部服务器的请求都附有一个超时时间。当外部服务器没有及时响应时，超时的设置非常有必要。如果没有设置超时，并使用默认值 0/-1，你的程序可能会阻塞几分钟或更长的时间。这是因为，当你没有收到来自应用服务器的响应，并且你的超时时间无限或非常大时，这个连接会一直开着。随着有更多的请求到来，更多的连接会打开，并永远无法关闭。这会导致你的连接池耗尽，进而导致你的应用的故障。

那么，每当你使用这样的连接器来配置你的应用时，请务必在配置中设置显式的超时值。

超时必须在前端和后端中都实现。如果一个读/写操作在一个 REST API 或 socket 接口上阻塞了太长时间，它应当抛出异常，并且断开连接。这可以通知后端取消操作并关闭连接，从而防止连接始终打开。

## 重试

我们可能需要了解**瞬时故障**这个术语，因为我们后面会频繁用到它。简单地说，服务中的瞬时故障是一种暂时的失灵，例如网络拥塞，数据库过载，是一种在有足够的冷却周期之后也许能自己恢复的故障。

**如何判断一个故障是否是瞬时的？**

答案取决于你的 API/Server 响应的实现细节。如果你有一个 REST API，请返回 [503 Service Unavailable](https://tools.ietf.org/html/rfc7231#section-6.6.1)，而不是其他 5xx/4xx 错误码。这可以让客户端知道超时是由“临时的过载”引起的，而不是由于代码层面的错误。

重试虽然有用，但如果没有正确地配置，则会让人讨厌。下面阐述了如何找出正确的重试方法。

**重试**

如果从服务器收到的错误是瞬时的，例如网络数据包在传输时损坏，应用程序可以立即重试请求，因为故障不太可能再次发生。

然而，这种方法非常激进。如果你的服务已经满负荷运行，或是已经完全不可用，这种方法可能对你的服务有害。这种方法还会拖慢应用的响应时间，因为你的服务会尝试不断执行一个失败的操作。

如果你的业务逻辑需要这样的重试策略，你最好限制重试的次数，不向同一个源头发送过多的请求。

**带延迟的重试**

如果是连接失败或网络上的过大流量导致的故障，应用程序则应当根据业务逻辑，在重试请求之前添加延迟时间。

```
for(int attempts = 0; attempts < 5; attempts++)
{
    try
    {
        DoWork();
        break;
    }
    catch { }
    Thread.Sleep(50); // 延迟
}
```
    
当使用一个连接至外部服务的库时，请检查它是否实现了重试策略，允许你配置重试的最大次数、重试之间的延迟等。

你还可以通过设置 [Retry-After](https://tools.ietf.org/html/rfc7231#section-7.1.3) 响应头，在服务器端实现重试的策略。

用日志记录操作失败的原因也很重要。有时候操作失败是因为缺少资源，这可以通过添加更多的服务实例来解决。也有时候操作失败可能是因为内存泄漏或空指针异常。那么，添加日志跟踪你的应用程序的行为就很重要了。

## 退避

如上所述，我们可以向重试策略中添加延迟。这种延迟通常称为**线性退避**。这可能不是实现一个重试策略的最佳方法。

考虑这种情况：你的服务因为数据库的过载发生了故障。我们的请求很可能在几次重试之后会成功。但不断发送的请求也可能**加重**你的数据库服务器的过载问题。因此，数据库服务会在过载状态停留更长时间，也会需要更多的时间从过载状态中恢复。

有几种策略可以用于解决这个问题。

**1. [指数退避](https://en.wikipedia.org/wiki/Exponential_backoff)**

顾名思义，指数退避不是在重试之间进行周期性的延迟（例如 5 秒），而是指数性地增加延迟时间。重试会一直进行到最大次数限制。如果请求始终失败，就告诉客户端请求失败了。

你还必须设置最大延迟时间的限制。指数退避可能导致出现非常大的延迟时间，导致请求的 socket 保持无限期开启，并使线程“永远”休眠。这会耗尽系统资源，导致连接池的更多问题。

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
    if (delay < MAX_DELAY)      // MAX_DELAY 可能依赖于应用程序和业务逻辑
    {
        delay *= 2;
    }
}
```
    
指数退避在分布式系统中的一个主要缺点是，**在同一时间开始退避的请求，也会在同一时间进行重试**。这导致了请求簇的出现。那么，我们并没有减少每一轮进行竞争的客户端数量，而是引入了没有客户端竞争的时期。固定的指数退避并不能减少很多竞争，并会生成**负载峰值**。

**2. [带抖动的退避](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/)**

为了处理指数退避的负载峰值问题，我们向退避策略中添加**抖动**。抖动是一种去相关性策略，在重试的间隔中添加随机性，从而分摊了负载，避免了出现网络请求簇。

抖动通常不是任何一项配置属性，需要客户端来实现。抖动所需要的只是一个可以加入随机性的函数，可以在重试之前动态地计算出等待的时间。

引入抖动之后，最初的一组失败的请求可能聚集在一个很小的窗口中，例如 100 ms。但是在每个重试周期之后，请求簇会摊开到越来越大的时间窗口中。当请求分摊在足够大的窗口上时，服务就很可能能够处理这些请求。

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
    delay *= random.randrange(0, min(MAX_DELAY, delay * 2 ** i)) // 只是生成一个简单的随机数
}
```

在**长时间的瞬时故障**的情况下，任何的重试可能都不是最好的方法。这种故障可能是由于连接失效，电力中断（是的，非常真实的情况）导致的。客户端最终会重试若干次，浪费了系统资源，并进一步导致了更多系统中的故障。

那么，我们需要一种可以确定故障是否会长期持续的机制，并实现一种应对该情况的解决方案。

**3. [断路器](https://en.wikipedia.org/wiki/Circuit_breaker_design_pattern)**

断路器模式在处理服务的长时间瞬时故障时非常有用。它通过确定服务的可用性，防止客户端重试注定会失败的请求。

断路器设计模式要求在一系列的请求中保留连接的状态。让我们看看 [failsafe 实现的断路器](https://github.com/jhalterman/failsafe#circuit-breakers)

```
CircuitBreaker breaker = new CircuitBreaker()
  .withFailureThreshold(5)
  .withSuccessThreshold(3)
  .withDelay(1, TimeUnit.MINUTES);

Failsafe.with(breaker).run(() -> connect());
``` 

当一切正常运行时，没有故障，断路器保持在关闭状态。

当达到执行故障的阈值时，断路器跳闸并进入**打开**状态。这意味着，后续的所有请求会直接失败，不会经过重试的逻辑。

经过一段延迟之后（如上述设置的 1 分钟），断路器会进入**半开**状态，测试网络请求的问题是否依然存在，并决定断路器是应当关闭还是打开。如果请求成功，断路器会重置为**关闭**状态，否则会重新置为**打开**状态。

这有助于在长时间的故障中避免重试执行的聚集，节省系统资源。

虽然断路器可以用一个状态变量在本地维护。但是如果你有一个**分布式系统**，你可能需要一个外部存储层。在多节点的配置中，应用服务器的状态需要在多个实例之间共享。在这种场景下，你可以使用 Redis、memcached 来记录外部服务的可用性。在向外部服务发送任何请求之前，从持久存储中查询服务的状态。

## 分布式系统中的幂等性

幂等的服务是指客户端可以重复地发起相同的请求，并得到相同的最终结果。虽然服务器会对此操作产生相同的结果，但客户端不一定作出相同的反应。

对于 REST API 而言，你需要记住 ——

* **POST** **不是**幂等的 —— POST 导致在服务器上创建新资源。n 个 POST 请求会在服务器上创建 n 个新的资源。
* **GET**、**HEAD**、**OPTIONS** 和 **TRACE** 方法**永远**不会改变服务器上资源的状态。因此，它们总是幂等的。
* **PUT** 请求是幂等的。n 个 PUT 请求会覆盖相同的资源 n-1 次。
* **DELETE** 是幂等的，因为它一开始会返回 200（OK），而后续的调用会返回 204（No Content）或 404（Not Found）。

**为什么关注幂等操作呢？**

在分布式系统中，有多个服务器和客户端节点。如果你从客户端向服务器 A 发送了请求，请求失败或超时了，那么你想能够简单地再次发送该请求，而不必担心先前的请求是否有任何副作用。

这在微服务中是极其重要的，因为有很多独立工作的组件。

幂等性的一些主要好处有 ——

* **最小的复杂性** —— 不需要担心副作用，可以简单地重试任何请求，并得到相同的最终结果。
* **易于实现** —— 你不需要添加逻辑来处理你的重试机制中先前失败的请求。
* **易于测试** —— 每个动作都会产生相同的结果，没有意外。

## 结语

我们梳理了一系列构建更容错系统的方法。然而，这些方法并不是全部。最后，我想指出几个供你查看的要点，或许能帮助提高你系统的可用性和容错性。

* 在多节点配置中，如果一个客户端重试了多次，这些请求很可能到达同一个服务器。此时，最好返回一个失败的响应，让客户端从头重试。
* 对你的系统做性能统计，让它们时刻准备最坏的情况。你可以查看 [Netflix 的 Chaos Monkey](https://github.com/Netflix/chaosmonkey) —— 这是一个在系统中触发随机故障的弹性测试工具。这能让你为可能发生的故障做好准备，构建一个有弹性的系统。
* 如果你的系统由于某种原因处于过载状态，你可以尝试通过减载（load shedding）来分布负载。Google 做了一个很棒的[案例研究](https://cloud.google.com/blog/products/gcp/using-load-shedding-to-survive-a-success-disaster-cre-life-lessons)，可以作为一个很好的起点。

* * *

一些资源：

* [分布式系统中的模式](https://www.dre.vanderbilt.edu/~schmidt/patterns-ace.html)
* [重试模式 - Microsoft](https://docs.microsoft.com/en-us/azure/architecture/patterns/retry)
* [Martin Fowler - 断路器](https://martinfowler.com/bliki/CircuitBreaker.html)

感谢！❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
