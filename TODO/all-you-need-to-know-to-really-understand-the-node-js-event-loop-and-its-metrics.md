
> * 原文地址：[All you need to know to really understand the Node.js Event Loop and its Metrics](https://www.dynatrace.com/blog/all-you-need-to-know-to-really-understand-the-node-js-event-loop-and-its-metrics/)
> * 原文作者：[Daniel Khan](https://www.dynatrace.com/blog/author/daniel-khan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-to-really-understand-the-node-js-event-loop-and-its-metrics.md](https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-to-really-understand-the-node-js-event-loop-and-its-metrics.md)
> * 译者：[MuYunyun](https://github.com/MuYunyun)
> * 校对者：[sigoden](https://github.com/sigoden)、[zyziyun](https://github.com/zyziyun)

# 所有你需要知道的关于完全理解 Node.js 事件循环及其度量

Node.js 是一个基于事件的平台。这意味着在 Node 中发生的一切都是基于对事件的反应。通过 Node 的事件处理机制遍历一系列回调。

事件的回调，这一切都由一个名为 libuv 的库来处理，它提供了一种称为事件循环的机制。

这个事件循环可能是平台中最被误解的概念。当我们提及事件循环监测的主题时，我们花了很多精力来正确地理解我们实际监视的内容。

在本文中，我将带大家重新认知事件循环是如何工作以及它是如何正确地监视。

## 常见的误解

Libuv 是向 Node.js 提供事件循环的库。在 libuv 背后的关键人物 Bert Belder 的精彩的演讲 [Node 交互的主题演讲](https://www.youtube.com/watch?v=PNa9OMajw9w) 中，演讲开头他使用 Google 图像搜索展示了各种不同方式描述事件循环的图片，但是他指出大部分图片描绘的都是错误的。

[![](https://dt-cdn.net/wp-content/uploads/2017/07/Insert1-1024x464.png)](https://www.dynatrace.com/blog/?attachment_id=20207)

让我们来看看最流行的误解。

### 误解1：在用户代码中，事件循环在单独的线程中运行

#### 误解

用户的 JavaScript 代码运行在主线程上面，而另开一个线程运行事件循环。每次异步操作发生时，主线程将把工作交给事件循环线程，一旦完成，事件循环线程将通知主线程执行回调。

#### 现实

只有一个线程执行 JavaScript 代码，事件循环也运行在这个线程上面。回调的执行（在运行的 Node.js 应用程序中被传入、后又被调用的代码都是一个回调）是由事件循环完成地。稍后我们会深入讨论。

### 误解2：异步的所有内容都由线程池处理

#### 误解

异步操作，像操作文件系统，向外发送 HTTP 请求以及与数据库通信等都是由 libuv 提供的线程池处理的。

#### 现实

Libuv 默认使用四个线程创建一个线程池来完成异步工作。今天的操作系统已经为许多 I/O 任务提供了异步接口（[例子 AIO on Linux](http://man7.org/linux/man-pages/man7/aio.7.html)）。

只要有可能，libuv 将使用这些异步接口，避免使用线程池。

这同样适用于像数据库这样的第三方子系统。在这里，驱动程序的作者宁愿使用异步接口，而不是使用线程池。

简而言之：只有没有其他方式可以使用时，线程池才将会被用于异步 I/O 。

### 误解3：事件循环类似栈或队列

#### 误解

事件循环采用先进先出的方式执行异步任务，类似于队列，当一个任务执行完毕后调用对应的回调函数。

#### 现实

虽然涉及到类似队列的结构，事件循环并不是采用栈的方式处理任务。事件循环作为一个进程被划分为多个阶段，每个阶段处理一些特定任务，各阶段轮询调度。

## 了解事件循环周期的阶段

为了真正地了解事件循环，我们必须明白各个阶段都完成了哪些工作。 希望 Bert Belder 不介意，我直接拿了他的图片来说明事件循环是如何工作的：
![](https://dt-cdn.net/wp-content/uploads/2017/07/event-loop-final-phases-1024x538.png)

事件循环的执行可以分成 5 个阶段，让我们来讨论这些阶段。更加深入的解释见 [Node.js 官网](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/)

### 计时器

通过 setTimeout() 和 setInterval() 注册的回调会在此处处理。

### IO 回调

大部分回调将在这部分被处理。Node.js 中大多数用户代码都在回调中处理（例如，对传入的 http 请求触发级联的回调）。

### IO 轮询

对接着要处理的的事件进行新的轮询。

### Immediate 设置

此处处理所有由 setImmediate() 注册的回调。

### 结束

这里处理所有‘结束’事件的回调。

## 监测事件循环

我们看到，事实上在 Node 应用程序中进行的所有事件都将通过事件循环运行。这意味着如果我们可以从中获得指标，相应地我们可以分析出有关应用程序整体运行状况和性能的宝贵信息。

没有现成的 API 可以从事件循环中获取运行时指标，因此每个监控工具都提供自己的指标，让我们来看看都有些什么。

### 记录频率

每次的记录数。

### 记录持续时间

一个刻度的时间。

由于我们的代理作为本机模块运行，因此这是比较容易地添加探测器为我们提供这些信息。

#### 记录频率以及记录持续事件指标

当我们在不同的负载下进行第一次测试时，结果令人惊讶 - 让我举例说明一下：

在以下情况下，我正在调用一个 express.js 应用程序，对其他 http 服务器进行外拨呼叫。

有以下 4 中情况:

1. *Idle*

没有传入请求

2. *ab -c 5*

使用 apache bench 工具我一次创建了 5 个并发请求

3. *ab -c 10*

一次 10 个并发请求

4. *ab -c 10 (slow backend)*

为了模拟出一个很慢的后端，我们让被调用的 http 服务器在 1s 后返回数据。这样造成请求等待后端返回数据，被堆积在 Node 中，产生背压。

[![](https://dt-cdn.net/wp-content/uploads/2017/07/Insert3-1024x352.png)](https://www.dynatrace.com/blog/?attachment_id=20209)

事件循环执行阶段

如果我们看看得到的图表，我们可以做一个有趣的观察：

##### 事件循环持续时间和被动态调整频率

如果应用程序处于空闲状态，这意味着没有执行任何任务（定时器、回调等），此时全速运行这些阶段是没有意义的，事件循环就这种情况会在在轮询阶段阻塞一段时间以等待新的外部事件进入。

这也意味着，无负载下的度量（低频，高持续时间）与在高负载下与慢后端相关的应用程序相似。

我们还看到，该演示应用程序在场景中运行得“最好”的是并发 5 个请求。

**因此，标记频率和标记持续时间需要基于每秒并发请求量进行度量。**

虽然这些数据已经为我们提供了一些有价值的见解，但我们仍然不知道在哪个阶段花费时间，因此我们进一步研究并提出了另外两个指标。

### 工作处理延迟

这个度量衡量线程池处理异步任务所需的时间。

高工作处理的延迟表示一个繁忙/耗尽的线程池。

为了测试这个指标，我创建了一个使用 [Sharp](https://www.npmjs.com/package/sharp) 的模块来处理图像的 express 路由。 由于图像处理开销太大，Sharp 利用线程池来实现。

[![](https://dt-cdn.net/wp-content/uploads/2017/07/Insert4-1024x358.png)](https://www.dynatrace.com/blog/?attachment_id=20211)

通过 Apache bench 发起 5 个并发请求到具有图像处理功能的路由与没有使用图片处理的路由有很大不同，可以直接从图表上可以看到。

### 事件循环延迟

事件循环延迟测量在通过 setTimeout(X) 调度的任务真正得到处理之前需要多长时间。

事件循环高延迟表示事件循环正忙于处理回调。

为了测试这个指标，我创建了一个 express 路由使用了一个非常**低效**的算法来计算斐波那契。

[![](https://dt-cdn.net/wp-content/uploads/2017/07/Insert51-1024x400.png)](https://www.dynatrace.com/blog/?attachment_id=20212)

运行具有 5 个并发连接的 Apache bench，具有计算斐波那契功能的路由显示此刻回调队列处于繁忙状态。

我们清楚地看到，这四个指标可以为我们提供宝贵的见解，并帮助您更好地了解 Node.js 的内部工作。

这些需求仍然需要在更大的图片中去观察，以使其有意义。因此，我们正在收集信息以将这些数据纳入我们的异常检测。

## 回到事件循环

当然，在不了解如何从可能的行动中解决问题的情况下，衡量标准本身就不会有太大的帮助。当事件循环快耗尽时，这里有几个提示。

[![](https://dt-cdn.net/wp-content/uploads/2017/07/Insert6-1024x410.png)](https://www.dynatrace.com/blog/?attachment_id=20213)

事件循环耗尽

### 利用所有 CPU

Node.js 应用程序在单个线程上运行。在多核机器上，这意味着负载不会分布在所有内核上。使用 Node 附带的 [cluster module](https://nodejs.org/api/cluster.html) 可以轻松地为每个 CPU 生成一个子进程。每个子进程维护自己的事件循环，主进程在所有子进程之间透明地分配负载。

### 调整线程池

如上所述，libuv 将创建一个大小为 4 的线程池。通过设置环境变量 UV_THREADPOOL_SIZE 可以覆盖线程池的默认大小。

虽然这可以解决 I/O 绑定应用程序上的负载问题，我建议多次负载测试，因为较大的线程池可能仍然耗尽内存或 CPU 。

### 将任务扔给服务进程

如果 Node.js 花费太多时间参与 CPU 繁重的操作，开一些服务进程处理这些繁重任务或者针对某些特定任务使用其它语言编写服务也是一个可行的选择。

## 总结

我们总结一下我们在这篇文章中学到的内容：

- 事件循环是使 Node.js 应用程序运行的原因
- 它的功能经常被误解 - 它有多个阶段组成，各阶段处理特定任务，阶段间轮询调度
- 事件循环不提供现成的指标，因此收集的指标在 APM 供应商之间是不同的
- 这些指标清楚地提供了有关瓶颈的有价值的见解，但对事件循环的深刻理解以及正在运行的代码才是关键
- 在未来，Dynatrace 将会把事件循环添加到第一检测要素，从而将事件循环异常与问题相关联

对我来说，毫无疑问，我们今天刚刚在市场上构建了最全面的事件循环监控解决方案，我非常高兴在未来几个星期内，这个惊人的新功能将推向所有客户。

## 最后

我们一流的 Node.js 代理团队为了做好事件循环监控尽了很大努力。这篇博客文章中提出的大部分发现都是基于他们对 Node.js 内部运作的深入了解。 我要感谢 Bernhard Liedl ，Dominik Gruber ，GerhardStöbich 和 Gernot Reisinger 所有的工作和支持。

我希望这篇文章使大家在事件循环上有新的认知。请在 Twitter 上关注我 [@dkhan](https://twitter.com/dkhan)。我很乐意回答您在 Twitter 里或下面评论区中的提出的一切问题。

最后和以往一样：[下载免费试用版去监控您的完整堆栈，包括Node.js](https://www.dynatrace.com/technologies/nodejs-monitoring/)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
