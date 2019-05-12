> * 原文地址：[Better performance by optimizing Gunicorn config](https://medium.com/building-the-system/gunicorn-3-means-of-concurrency-efbb547674b7)
> * 原文作者：[Omar Rayward](https://medium.com/@orayward)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/gunicorn-3-means-of-concurrency.md](https://github.com/xitu/gold-miner/blob/master/TODO1/gunicorn-3-means-of-concurrency.md)
> * 译者：
> * 校对者：

# Better performance by optimizing Gunicorn config

> Practical advice on how to configure Gunicorn.

> **TL;DR, For CPU bounded apps increase workers and/or cores. For I/O bounded apps use “pseudo-threads”.**

![](https://cdn-images-1.medium.com/max/3078/1*39XEUZgpoUUzahu7giTlAw.png)

[Gunicorn](http://gunicorn.org/) is a Python WSGI HTTP Server that usually lives between a [reverse proxy](https://en.wikipedia.org/wiki/Reverse_proxy) (e.g., [Nginx](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)) or [load balancer](https://f5.com/glossary/load-balancer) (e.g., [AWS ELB](https://aws.amazon.com/elasticloadbalancing/)) and a web application such as Django or Flask.

## Gunicorn architecture

Gunicorn implements a UNIX pre-fork web server.

Great, what does that mean?

* Gunicorn starts a single master process that gets forked, and the resulting child processes are the workers.
* The role of the master process is to make sure that the number of workers is the same as the ones defined in the settings. So if any of the workers die, the master process starts another one, by forking itself again.
* The role of the workers is to handle HTTP requests.
* The **pre** in **pre-forked** means that the master process creates the workers before handling any HTTP request.
* The OS kernel handles load balancing between worker processes.

To improve performance when using Gunicorn we have to keep in mind 3 means of concurrency.

### 1st means of concurrency (workers, aka UNIX processes)

Each of the workers is a UNIX process that loads the Python application. There is no shared memory between the workers.

The suggested [number of `workers`](http://docs.gunicorn.org/en/latest/design.html#how-many-workers) is `(2*CPU)+1`.

For a dual-core (2 CPU) machine, 5 is the suggested `workers` value.

```bash
gunicorn --workers=5 main:app
```

![Gunicorn with default worker class (sync). Note the 4th line in the image: “Using worker: sync”.](https://cdn-images-1.medium.com/max/2818/1*QbgEx24X6sZ204k5HOs3WA.png)

### 2nd means of concurrency (threads)

Gunicorn also allows for each of the workers to have multiple threads. In this case, the Python application is loaded once per worker, and each of the threads spawned by the same worker shares the same memory space.

To use threads with Gunicorn, we use the `threads` setting. Every time that we use `threads`, the worker class is set to `gthread`:

```bash
gunicorn --workers=5 --threads=2 main:app
```

![Gunicorn with threads setting, which uses the gthread worker class. Note the 4th line in the image: “Using worker: threads”.](https://cdn-images-1.medium.com/max/2786/1*hkpM7HoS_4PClLOVH9lCew.png)

The previous command is the same as:

```bash
gunicorn --workers=5 --threads=2 --worker-class=gthread main:app
```

The maximum concurrent requests are`workers * threads` 10 in our case.

The suggested maximum concurrent requests when using workers and threads is still`(2*CPU)+1`.

So if we are using a quad-core (4 CPU) machine and we want to use a mix of workers and threads, we could use 3 workers and 3 threads, to get 9 maximum concurrent requests.

```bash
gunicorn --workers=3 --threads=3 main:app
```

### 3rd means of concurrency (“pseudo-threads” )

There are some Python libraries such as [gevent](http://www.gevent.org/) and [Asyncio](https://docs.python.org/3/library/asyncio.html) that enable concurrency in Python by using “pseudo-threads” implemented with [coroutines](https://en.wikipedia.org/wiki/Coroutine).

Gunicorn allows for the usage of these asynchronous Python libraries by setting their corresponding worker class.

Here the settings that would work for a single core machine that we want to run using `gevent`:

```bash
gunicorn --worker-class=gevent --worker-connections=1000 --workers=3 main:app
```

> worker-connections is a specific setting for the gevent worker class.

`(2*CPU)+1` is still the suggested `workers` since we only have 1 core, we’ll be using 3 workers.

In this case, the maximum number of concurrent requests is 3000 (3 workers * 1000 connections per worker)

## Concurrency vs. Parallelism

* Concurrency is when 2 or more tasks are being performed at the same time, which might mean that only 1 of them is being worked on while the other ones are paused.
* Parallelism is when 2 or more tasks are executing at the same time.

In Python, threads and pseudo-threads are a means of concurrency, but not parallelism; while workers are a means of both concurrency and parallelism.

That’s all good theory, but what should I use in my program?

## Practical use cases

By tuning Gunicorn settings we want to optimize the application performance.

 1. If the application is [I/O bounded](https://en.wikipedia.org/wiki/I/O_bound), the best performance usually comes from using “pseudo-threads” (gevent or asyncio). As we have seen, Gunicorn supports this programming paradigm by setting the appropriate **worker class** and adjusting the value of `**workers**`to `(2*CPU)+1`.
 2. If the application is [CPU bounded](https://en.wikipedia.org/wiki/CPU-bound), it doesn’t matter how many concurrent requests are handled by the application. The only thing that matters is the number of parallel requests. Due to [Python’s GIL](https://wiki.python.org/moin/GlobalInterpreterLock), threads and “pseudo-threads” cannot run in parallel. The only way to achieve parallelism is to increase **`workers`** to the suggested `(2*CPU)+1`, understanding that the maximum number of parallel requests is the number of cores.
 3. If there is a concern about the application [memory footprint](https://en.wikipedia.org/wiki/Memory_footprint), using **`threads`** and its corresponding **gthread worker class** in favor of `workers` yields better performance because the application is loaded once per worker and every thread running on the worker shares some memory, this comes to the expense of some additional CPU consumption.
 4. If you don’t know you are doing, start with the simplest configuration, which is only setting `**workers**` to `(2*CPU)+1` and don’t worry about `threads`. From that point, it’s all trial and error with benchmarking. If the bottleneck is memory, start introducing threads. If the bottleneck is I/O, consider a different python programming paradigm. If the bottleneck is CPU, consider using more cores and adjusting the `**workers**` value.

## Building the system

We, software developers commonly think that every performance bottleneck can be fixed by optimizing the application code, and this is not always true.

There are times in which tuning the settings of the HTTP server, using more resources or re-architecting the application to use a different programming paradigm are the solutions that we need to improve the overall application performance.

In this case, **building the system** means understanding the types of computing resources (processes, threads and “pseudo-threads”) that we have available to deploy a performant application.

By understanding, architecting and implementing the right technical solution with the right resources we avoid falling into the trap of trying to improve performance by optimizing application code.

## References

 1. **Gunicorn is ported from Ruby’s [Unicorn](https://bogomips.org/unicorn/) project. Its [design outline](https://bogomips.org/unicorn/DESIGN.html) helped on clarifying some of the most fundamental concepts. [Gunicorn architecture](http://docs.gunicorn.org/en/latest/design.html) cemented some of those concepts.**
 2. **[Opinionated blog post](https://tomayko.com/blog/2009/unicorn-is-unix) about how Unicorn deferring some of the most critical features to Unix is good.**
 3. **Stack Overflow answer about the pre-fork web server model.**
 4. **[Some](https://github.com/benoitc/gunicorn/issues/1045) [more](https://stackoverflow.com/questions/38425620/gunicorn-workers-and-threads) [references](http://docs.gunicorn.org/en/stable/settings.html) to understand how to fine tune Gunicorn.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
