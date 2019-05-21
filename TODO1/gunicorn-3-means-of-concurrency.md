> * 原文地址：[Better performance by optimizing Gunicorn config](https://medium.com/building-the-system/gunicorn-3-means-of-concurrency-efbb547674b7)
> * 原文作者：[Omar Rayward](https://medium.com/@orayward)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/gunicorn-3-means-of-concurrency.md](https://github.com/xitu/gold-miner/blob/master/TODO1/gunicorn-3-means-of-concurrency.md)
> * 译者：[shixi-li](https://github.com/shixi-li)

# 通过优化 Gunicorn 配置提高性能

> 关于如何配置 Gunicorn 的实用建议

> **概要，对于 CPU 受限的应用应该提升集群数量或者核心数量。但对于 I/O 受限的应用应该使用“伪线程”。**
 
![](https://cdn-images-1.medium.com/max/3078/1*39XEUZgpoUUzahu7giTlAw.png)

[Gunicorn](http://gunicorn.org/) 是一个 Python 的 WSGI HTTP 服务器。它所在的位置通常是在[反向代理](https://en.wikipedia.org/wiki/Reverse_proxy)（如 [Nginx](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)）或者 [负载均衡](https://f5.com/glossary/load-balancer)（如 [AWS ELB](https://aws.amazon.com/elasticloadbalancing/)）和一个 web 应用（比如 Django 或者 Flask）之间。

## Gunicorn 架构

Gunicorn 实现了一个 UNIX 的预分发 web 服务端。

好的，那这是什么意思呢？

* Gunicorn 启动了被分发到的一个主线程，然后因此产生的子线程就是对应的 worker。
* 主进程的作用是确保 worker 数量与设置中定义的数量相同。因此如果任何一个 worker 挂掉，主线程都可以通过分发它自身而另行启动。
* worker 的角色是处理 HTTP 请求。
* 这个 **预** in **预分发** 就意味着主线程在处理 HTTP 请求之前就创建了 worker。
* 操作系统的内核就负责处理 worker 进程之间的负载均衡。

为了提高使用 Gunicorn 时的性能，我们必须牢记 3 种并发方式。

### 第一种并发方式（workers 模式，又名 UNIX 进程模式）

每个 worker 都是一个加载 Python 应用程序的 UNIX 进程。worker 之间没有共享内存。

建议的 [`workers` 数量](http://docs.gunicorn.org/en/latest/design.html#how-many-workers)是 `(2*CPU)+1`。

对于一个双核（两个CPU）机器，5 就是建议的 worker 数量。

```bash
gunicorn --workers=5 main:app
```

![Gunicorn 使用默认的 worker 模式（同步模式）。注意看这个图片的第四行：“Using worker: sync”.](https://cdn-images-1.medium.com/max/2818/1*QbgEx24X6sZ204k5HOs3WA.png)

### 第二种并发方式（多线程）

Gunicorn 还允许每个 worker 拥有多个线程。在这种场景下，Python 应用程序每个 worker 都会加载一次，同一个 worker 生成的每个线程共享相同的内存空间。

为了在 Gunicorn 中使用多线程。我们使用了 `threads` 模式。每一次我们使用 `threads` 模式，worker 的类就会是 `gthread`：

```bash
gunicorn --workers=5 --threads=2 main:app
```

![Gunicorn 的多线程模式就是使用了 worker 的 gthread 类。请注意图片中的第四行 “Using worker: threads”。](https://cdn-images-1.medium.com/max/2786/1*hkpM7HoS_4PClLOVH9lCew.png)

上一条命令等同于：

```bash
gunicorn --workers=5 --threads=2 --worker-class=gthread main:app
```

在我们的例子里面最大的并发请求数就是 `worker * 线程`，也就是10。

在使用 worker 和多线程模式时建议的最大并发数量仍然是`(2*CPU)+1`。

因此如果我们使用四核（4 个 CPU）机器并且我们想使用 workers 和多线程模式，我们可以使用 3 个 worker 和 3 个线程来得到最大为 9 的并发请求数量。

```bash
gunicorn --workers=3 --threads=3 main:app
```

### 第三种并发方式（“伪线程”）

有一些 Python 库比如（[gevent](http://www.gevent.org/) 和 [Asyncio](https://docs.python.org/3/library/asyncio.html)）可以在 Python 中启用多并发。那是基于[协程](https://en.wikipedia.org/wiki/Coroutine)实现的“伪线程”。

Gunicrn 允许通过设置对应的 worker 类来使用这些异步 Python 库。

这里的设置适用于我们想要在单核机器上运行的`gevent`：

```bash
gunicorn --worker-class=gevent --worker-connections=1000 --workers=3 main:app
```

> worker-connections 是对于 gevent worker 类的特殊设置。

`(2*CPU)+1` 仍然是建议的`workers` 数量。因为我们仅有一核，我们将会使用 3 个worker。

在这种情况下，最大的并发请求数量是 3000。（3 个 worker * 1000 个连接/worker）

## 并发 vs. 并行

* 并发是指同时执行 2 个或更多任务，这可能意味着其中只有一个正在处理，而其他的处于暂停状态。
* 并行是指两个或多个任务正在同时执行。

在 Python 中，线程和伪线程都是并发的一种方式，但并不是并行的。但是 workers 是一系列基于并发或者并行的方式。

理论讲的很不错，但我应该怎样在程序中使用呢？

## 实际案例

通过调整Gunicorn设置，我们希望优化应用程序性能。

 1. 如果这个应用是 [I/O 受限](https://en.wikipedia.org/wiki/I/O_bound)，通常可以通过使用“伪线程”（gevent 或 asyncio）来得到最佳性能。正如我们了解到的，Gunicorn 通过设置合适的 **worker 类** 并将 `workers`数量调整到 `(2*CPU)+1` 来支持这种编程范式。
 2. 如果这个应用是 [CPU 受限](https://en.wikipedia.org/wiki/CPU-bound)，那么应用程序处理多少并发请求就并不重要。唯一重要的是并行请求的数量。因为 [Python’s GIL](https://wiki.python.org/moin/GlobalInterpreterLock)，线程和“伪线程”并不能以并行模式执行。实现并行性的唯一方法是增加**`workers`** 的数量到建议的 `(2*CPU)+1`，理解到最大的并行请求数量其实就是核心数。
 3. 如果不确定应用程序的[内存占用](https://en.wikipedia.org/wiki/Memory_footprint)，使用 **`多线程`** 以及相应的 **gthread worker 类** 会产生更好的性能，因为应用程序会在每个 worker 上都加载一次，并且在同一个 worker 上运行的每个线程都会共享一些内存，但这需要一些额外的 CPU 消耗。
 4. 如果你不知道你自己应该选择什么就从最简单的配置开始，就只是 `workers` 数量设置为 `(2*CPU)+1` 并且不用考虑 `多线程`。从这个点开始，就是所有测试和错误的基准环境。如果瓶颈在内存上，就开始引入多线程。如果瓶颈在 I/O 上，就考虑使用不同的 Python 编程范式。如果瓶颈在 CPU 上，就考虑添加更多内核并且调整 `workers` 数量。

## 构建系统

我们软件开发人员通常认为每个性能瓶颈都可以通过优化应用程序代码来解决，但并非总是如此。

有时候调整 HTTP 服务器的设置，使用更多资源或通过别的编程范式重新设计应用程序都是我们提升应用程序性能的解决方案。

在这种情况下，**构建系统**意味着理解我们应该灵活应用部署高性能应用程序的计算资源类型（进程，线程和“伪线程”）。

通过使用正确的理解，架构和实施正确的技术解决方案，我们可以避免陷入尝试通过优化应用程序代码来提高性能的陷阱。

## 参考

 1. **Gunicorn 是从 Ruby 的 [Unicorn](https://bogomips.org/unicorn/) 项目移植而来。它的[设计大纲](https://bogomips.org/unicorn/DESIGN.html)有助于澄清一些最基本的概念。[Gunicorn 架构](http://docs.gunicorn.org/en/latest/design.html) 进一步巩固了其中一些概念。**
 2. **[有态度的博文报道](https://tomayko.com/blog/2009/unicorn-is-unix)关于 Unicorn 怎么讲一些关键的特性基于 Unix 表述的非常好。**
 3. **Stack Overflow里有关预分发 Web 服务模型的回答。**
 4. **[一些](https://github.com/benoitc/gunicorn/issues/1045)[更多](https://stackoverflow.com/questions/38425620/gunicorn-workers-and-threads)[参考](http://docs.gunicorn.org/en/stable/settings.html)来理解怎么微调 Gunicorn。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
