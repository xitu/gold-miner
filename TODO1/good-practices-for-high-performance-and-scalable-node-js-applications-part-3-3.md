> * 原文地址：[Good practices for high-performance and scalable Node.js applications [Part 3/3]](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-3-3-c1a3381e1382)
> * 原文作者：[virgafox](https://medium.com/@virgafox?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-3-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-3-3.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[calpa](https://github.com/calpa)，[Augustwuli](https://github.com/Augustwuli)

# 构建高性能和可扩展性 Node.js 应用的最佳实践 [第 3/3 部分]

![](https://cdn-images-1.medium.com/max/2000/1*AyzlnTJDIfbZCxdQPp8Seg.jpeg)

### 第三章 — 其它关于 Node.js 应用运行效率和性能的优秀实践

本系列的头两篇文章中我们看到[如何扩展一个 Node.js 应用](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3-bb06b6204197)以及[在应用的代码部分应该考虑什么](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3-2a68f875ce79)才能使其在这个过程中运行如我们所愿。在这最后一篇文章中，我们将介绍一些其它实践，以进一步提高应用运行效率和性能。

### Web 和 Worker 进程

就像你可能知道的那样，**Node.js 在实际运行中是单线程的**，因此一个进程实例在同一时间只能执行一个操作。在 Web 应用的运行生命周期中，会执行**很多不同类型的任务**：包括管理 API 调用，读/写数据库，与外部网络服务通信，以及不可避免地执行某些 CPU 密集型工作等。

尽管你使用的是异步编程，但是将所有这些操作都指派给同一个用于响应 API 调用的进程真的是一种效率很低的方式。

一种常见的模式是基于组成你应用不同类型进程之间的**责任分离**，这种情况下进程通常被分为 **web** 进程和 **worker** 进程。

![](https://cdn-images-1.medium.com/max/800/1*4u5WMX_JB8-E2byEBcUyYw.png)

Web 进程主要的任务是管理**传入的网络调用**并尽快将它们分发出去。每当一个非阻塞任务需要被执行时，例如发送电子邮件/通知，写日志，执行一个触发操作，它们都不需要马上响应 API 调用返回结果，Web 进程会把这些操作委派给 worker 进程。

**web 和 worker 进程之间的通信**可以通过不同的方式实现。一种常见且有效的解决方案是优先级队列，就像我们将在下一段描述的 Kue 所实现的那样。

这种方式有一个很大的优点，无论在同一台还是不同机器上其都可以**分别独立扩展 web 和 worker 进程**。

例如，如果你的应用请求量很大，相较于 worker 进程你可以部署更多的 web 进程而几乎不会产生任何副作用。而如果请求量不是很大但是有很多的工作需要 worker 进程去处理，你可以据此重新分配相应的资源。

### Kue

为了使 web 进程和 worker 进程可以相互通信，使用**队列**是一种灵活的方式，它可以使你不需要担心进程之间的通信。

[Kue](http://automattic.github.io/kue/) 是 Node.js 中常用的队列库，它基于 Redis 并且让你可以用完全一致的方式让运行在同一台或不同机器上的进程间相互通信。

任何类型的进程都可以创建一个工作并将之放入队列，然后被配置的相应 worker 进程就会从队列中提取并执行它。每个工作都提供了大量的可配置选项，如优先级，TTL，延迟等。

你创建的 worker 进程越多，执行这些作业的并行吞吐量也就越大。

### Cron

应用程序通常需要**定期执行**一些任务。通常这种类型的操作，是通过操作系统级别的 **cron 工作**进行管理，也就是会调用你应用程序之外的一个单独脚本。

当需要把你的应用部署到新的机器上时，这种方式会需要额外的配置工作，如果你想要自动化部署应用时，它会让人对其感到不舒服。

我们可以使用 **NPM 上的** [**cron 模块**](https://www.npmjs.com/package/cron)从而更轻松地实现同样的效果。它允许你在 Node.js 代码中定义 cron 工作，从而使其免于操作系统的配置。

根据上面所描述的 web/worker 进程模式，worker 进程可以通过定期调用一个函数把工作放到队列从而实现创建 cron。 

使用队列可以使 cron 的实现更加清晰并且还可以利用 Kue 所提供的所有功能，如优先级，重试等。

当你的应用有多个 worker 进程时就会出现一个问题，因为同一时间所有 worker 进程的 cron 函数都会唤醒应用把多个同样重复的工作放入队列，从而导致同一个工作将会被执行多次。

为了解决这个问题，有必要**识别将要执行 cron 操作的单个 worker 进程**。

### Leader 选举和 cron-cluster

这种类型的问题被称为 “**leader 选举**”，NPM 为我们提供了这种特定情况下的处理方案，有一个叫做 [cron-cluster](https://www.npmjs.com/package/cron-cluster) 的包。

它在维持和 cron 模块一致 API 的同时增强了模块，但是在启动过程中它需要有 **redis 连接**，用于和其它进程间通信和执行 leader 选举算法。

![](https://cdn-images-1.medium.com/max/800/1*kDpGv4d1Mj_AGg9TFVFhhQ.png)

使用 redis 作为单一事实的来源，**所有进程最终都会同意谁将执行 cron**，并且只有一个工作副本会被放入队列中。在这之后，所有的 worker 进程都可以像往常一样选择是否执行这个工作。

### 缓存 API 调用

**服务端缓存**是提高你 API 调用**性能和反馈性**一种常用的方式，但这是一个非常广泛的主题，有很多可能的实现。

在像我们在这个系列所描述的分布式环境中，如果想要所有的节点在处理缓存时表现一致，最好的办法或许是使用 redis 来缓存需要的值。

缓存所需要考虑最困难的方面就是缓存失效。一种快捷实用的解决方案是只考虑缓存时间，这样缓存中的值就会在固定的 TTL 时间后刷新，这样做的缺点是我们不得不等到下一次缓存刷新才能看到响应中的更新。

如果你能有更多的时间，最好在应用级别实现失效，即当数据库中的值更改时手动刷新 redis 缓存中的相关记录。

### 结论

在本系列文章中，我们介绍了有关扩展性和性能的一些主题。在这里所提供的建议可以作为指导，需要根据项目特定的需求进行定制。

请继续关注关于 Node.js 和 DevOps 主题内的其它文章！

* * *

y_如果你喜欢这篇文章，请多多支持！_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
