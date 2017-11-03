> * 原文地址：[Making the Switch from Node.js to Golang](https://medium.com/@theflapjack103/the-way-of-the-gopher-6693db15ae1f#.f1purx7x4)
* 原文作者：[Alexandra Grant](https://medium.com/@theflapjack103)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Mark](https://github.com/marcmoore)，[Jiang Haichao](https://github.com/AceLeeWinnie)

# 从 Node.js 到 Golang 的迁徙之路

**本文由 Digg 的软件工程师 [Alexandra Grant](https://twitter.com/TheFlapjack103) 所作，最初发表在 [Medium](http://t.umblr.com/redirect?z=https%3A%2F%2Fmedium.com%2F%40theflapjack103%2Fthe-way-of-the-gopher-6693db15ae1f&t=ZTNjOWEzYTUzMGUzNWQwNDk2NDY4ZDM1YWNlMGQwZWI0ZGMwMDFlMCx2SE41TFFrZg%3D%3D)。**

我在大学时期就开始涉猎 JavaScript 并会随便写一些网页。我把 JS 当作写 C 语言和 Java 时候的一种小憩，并且我认为它是一种相当受限制的语言，它一直在鼓吹能够实现一些令用户叹为观止的特效和动画。我第一次教人编程就是用的 JS，因为它简单易学、能快速给开发者以可见的结果。将它与 HTML 和 CSS 代码写到一起，就能得到一个网页，初学者对此爱不释手。

然后意想不到的事情发生了。两年前，我还在一个研究性质的岗位上从事服务端编程和安卓应用原型的开发的时候，Node.js 突然跃入了我的视野。后端的 JavaScript？谁会拿它当回事儿呢？充其量也就是尝试让服务端性能、扩展等方面的开发容易些罢了，但随之而来的是运行和扩展性能的下滑等等。或许那仅仅是我根深蒂固的开发者的怀疑论，当读到一些有关快速、简单和高产的东西的时候，我就总是会那样想。

![image](http://ac-Myg6wSTV.clouddn.com/012e5669d7719053f0ef.gif)![image](http://ac-Myg6wSTV.clouddn.com/a512fa1f20bb772ab90d.gif)

然后是接踵而至的研究、报告、教程和附加项目，六个月之后我才意识到自从第一次读到 Node 以来，我一直在心无旁骛地研究它。它太简单了，尤其是当我每两个月就要开发新的创意的时候我更加意识到它的方便。但是 Node 并不仅仅是为应用原型和小项目而生的，甚至很多像 Netflix 这样成熟的公司也将业务分了一杯羹给 Node。霎时间，我手里拿着金刚钻看到了这世界充满了瓷器活儿。

很快又几个月过去了，我来到了现在的工作岗位，在 [Digg](http://t.umblr.com/redirect?z=http%3A%2F%2Fdigg.com&t=Y2ZjZDUzMjNkYmVhZmMyMzk5NTE5MzhhOWZlZGM5ZWNkZjIwNWIwZix2SE41TFFrZg%3D%3D) 做一名后端开发人员。早在 2015 年四月我入职的时候，Digg 的运行栈主要是 Python，除了两个服务等着用 Node 来写入。当被分派去给一个经常出问题的服务填坑时，我甚至感觉无比激动。

我们问题重重的 Node 服务器承担着相当直接的使命。Digg 使用亚马逊的 S3 的云存储服务，S3 很出色但是不支持批量 GET 操作。为了不将所有的负荷都加到我们的 Python 服务器上，不让 Python 服务器每次都从 S3 请求超过 100 个 key，我们决定利用 Node 简单的异步代码模式和大并发处理来完成。于是 S3 的内容获取服务 Octo 诞生了。

Node Octo 除了偶尔的掉链子之外性能都很好。某天它需要处理一个网络峰值，每分钟的请求数量从 50 跃升至 200+，与此同时每个请求中 Octo 基本都要从 S3 获取大概 10-100 个 key，也就是说它可能每分钟有 20,000 次 S3 的 GET 请求。日志表明，网络峰值的时候服务器的性能会大大下降，但是问题在于它并不总是能恢复。就这样，每隔一周在 Octo 卡住并且失灵后，我们也卡在恢复 EC2 实例当中。

服务器请求有着严格的超时时间，接收到请求后的几毫秒时刻内，Octo 应该将从 S3 成功获取的信息返回给客户端并继续工作。然而，即使设置超时时间为最大值 1200 毫秒，Octo 在最坏的情况下还是会出现请求处理时间达到 10 秒之久。

Octo 的代码非常的不同步并且我们获取 S3 的 key 和 value 的方式非常激进，并且它还和两个中型的 EC2 实例交叉运行，后来我们增加到四个。

我将代码重写过三次，每次都更深层次地挖掘 Node 的优化、填坑并在性能上锱铢必较。我查看了流行的 Node 网站服务器框架的性能评估，比如 Express 和 Hapi，并和 Node 内置的 HTTP 模块做了比较。我移除了所有第三方的模块，尽管它们很好用但是会拖慢代码的执行，结果三次都遭遇了相同的问题。无论我多努力，我还是不能使得 Octo 走上正轨，也不能减少请求峰值时性能的下降。

最终一个理念浮现出来，我必须要从 Node 的 event loop 工作入手。如果你不了解 event loop，请查看 [Node Source](http://t.umblr.com/redirect?z=https%3A%2F%2Fnodesource.com%2Fblog%2Funderstanding-the-nodejs-event-loop%2F&t=MWZlZjIwMDE0N2NjMTQzYTU5ZDgzYjBhYTM3ZWYwODQ3OWIwNDFlOSx2SE41TFFrZg%3D%3D)：

> Node 的 “event loop” 是处理高传送率方案的核心。那里充满了神迹和天马行空，也正是因为它才使得 Node 虽然是单线程却还能够允许后台处理任意数量的操作。

![image](http://ac-Myg6wSTV.clouddn.com/188c024ccb691dbf3a08.png)

**并没有多么神奇的 Event Loop 阻塞（X轴：时间/毫秒）**

你能看到在我们对服务进行弹性恢复之后原本丢失的性能又回来了。

即使发现了 event loop 阻塞是罪魁祸首，那也只是说明了在一开始的时候性能滞后的原因。

大多数的开发人员都听过 Node 的非阻塞 I/O 模型，那非常棒因为它意味着所有的请求在异步处理的时候不会造成执行阻塞，也不会产生任何多余开销（像线程和进程）并且作为开发人员你能很幸福地不用管后台发生的事。然而，你要牢记 Node 是单线程的，那意味着没有并行执行的代码。I/O 或许不会阻塞服务器，但是你的代码会啊。如果我在代码中调用休眠 5 秒钟，那么服务器在这段时间将不会有任何响应。

![image](http://ac-Myg6wSTV.clouddn.com/279f90490044dceae89e.png)

**形象化的 Event Loop：[StrongLoop](http://t.umblr.com/redirect?z=https%3A%2F%2Fstrongloop.com%2Fstrongblog%2Fnode-js-performance-event-loop-monitoring%2F&t=NTJhNDYxN2I2YzkzYmYwYThiZDkyZGNhODFjYjM3MDQwNmVkNWVjNyx2SE41TFFrZg%3D%3D)**

那么非阻塞代码呢？当处理请求的时候，事件被触发，消息和各自的回调函数一同进入队列。想了解更加深入，请查看对此有着独到见解的 [Carbon Five 的博文](http://t.umblr.com/redirect?z=http%3A%2F%2Fblog.carbonfive.com%2F2013%2F10%2F27%2Fthe-javascript-event-loop-explained%2F&t=MTA5NWNlODA3NDJjMTM3YTQwMmIwZWM2ZThkMzI2YTk5NzBjZmJmYyx2SE41TFFrZg%3D%3D)：

> 在一个循环中，队列轮询下一个消息（每个轮询被称为一个“tick”），当遇到一个消息时，执行该消息的回调函数。这个回调函数的调用作为调用堆栈中的初始帧，并且因为 JavaScript 是单线程的，堆栈中所有调用的返回之前会停止进一步的消息轮询。并发的（同步的）函数调用会在堆栈中增加新的调用帧……

如果我们的 Node 服务只是需要返回触手可得的数据，那它处理接收的请求绰绰有余。但是相反，它一直等待着许多嵌套的回调函数，这完全依赖于 S3 的响应（而这有时会超级慢）。请求超时之后，事件和与其相关的回调函数会被置于超载消息队列中。然而，超时事件可能在 1 秒的时候发生，只有等当前队列的消息和其回调函数都执行完（这可能需要几秒钟）该事件的回调函数才会被处理。我能想象请求峰值时堆栈的状态，但事实上，我并不需要想象，只需一点点 CPU 的运行切面就能展示给我们相当生动的状态图像。对以上的长篇累牍我表示抱歉。

![image](http://ac-Myg6wSTV.clouddn.com/43280c3b75d49c7558b0.png)

**失败情况下的火焰图**

先对火焰图做一个简单的介绍，y 轴代表堆栈中的帧的数量，每个函数是其下面的函数的子函数。x 轴代表样本的数量和持续时间。盒子的宽度表示在 CPU 上处理的时间，越宽就表示这个函数执行越慢或者它被调用地越频繁。现在你能从堆栈的深度看到 Octo 在巨大的峰值时的火焰图。想了解更多切面的信息和火焰图请点击[这里](http://t.umblr.com/redirect?z=http%3A%2F%2Fwww.brendangregg.com%2FFlameGraphs%2Fcpuflamegraphs.html&t=YTE0MDdhMDEwN2RhYjhmM2E1ZTA3ZDIyOGY3MWE3ZTA2MzVkNmIyMCx2SE41TFFrZg%3D%3D)。

看到这些我醍醐灌顶，也许 Node.js 并不合适处理这项任务。CTO 和我促膝而谈，我们当然不想每隔一周就对 Octo 进行一次弹性恢复并且我们都对一项互联网上[非常有前景的案例研究](http://t.umblr.com/redirect?z=http%3A%2F%2Fmarcio.io%2F2015%2F07%2Fhandling-1-million-requests-per-minute-with-golang%2F&t=ZTlmMjRlZjVmZmM4NjMxYTEyNGM0NDQ4ZDkxMjE5ODQ1NTFhODM3YSx2SE41TFFrZg%3D%3D)感兴趣。

如果这个标题没有足够悬念的话[原标题是：使用 Golang 每分钟处理百万请求。译者注]，其主题是创建服务向 S3 发送 PUT 请求（有人遇到过同样的问题么？）。这已经不是第一次我们谈论要使用 Golang 了，而现在我们有了一个绝佳的测试对象。

我速成了 Golang 的课程，两周之后，我们搭建并运行了一个新 Octo 服务。我严格按照 [Malwarebyte’s](http://t.umblr.com/redirect?z=https%3A%2F%2Fwww.malwarebytes.org%2F&t=ZDgzZjY3ZTIzMzI0ZGZhZmExNGZhNDNlZjZkODA3ZDM4YmMxYTFmZCx2SE41TFFrZg%3D%3D) 的 Golang 文章中描述的那样搭建了一个激动人心的解决方案。该服务有一个工作池（worker pool）和一个托管（delegator），托管会将接收的工作分派给空闲的工作区（worker）。每一个工作区在自己的协程（goroutine）上工作，并且一旦任务完成它们将返回工作池，简单高效。立竿见影的结果好到让人惊讶地合不拢嘴。

![image](http://ac-Myg6wSTV.clouddn.com/64aafd0bd86b8597ec6c.png)

**良好的不温不火的状态**

我们的服务平均响应时间几乎缩减了一半，我们的超时设置（S3 响应太慢，所以会有超时）也能够按部就班，并且网络峰值也只对服务造成了微小的影响而已。

![image](http://ac-Myg6wSTV.clouddn.com/325e8b4df6f127e0a630.png)

**蓝色的是 Node.js Octo | 绿色的是 Golang Octo**

用 Golang 升级之后，我们很容易地就能每分钟处理 200 个请求，每天处理 150 万个 S3 内容获取。我们一开始运行在 Octo 上的那四台负载均衡实例怎样了？我们现在又所缩减到了两个。

自从过渡到 Golang 我们还没回顾过这段经历。尽管我们主要的堆栈工作是用的 Python（很有可能会一直是这样），但是我们也已经开始模块化处理我们的基础代码并在系统中用微服务去处理特殊的内容。除了 Octo，我们现在生产环境中还有另外 3 台 Golang 服务，它们给我们提供实时的消息系统并且为我们的内容提供重要的元数据。我们对这些最新版本的 Golang 代码库感到骄傲，[DiggBot](http://t.umblr.com/redirect?z=http%3A%2F%2Fdigg.com%2Fdiggbot&t=ZjViNWY1YTAyMDQzMjA1ODNmODlhOGZiY2Y4NWY2MTVmMzdkODQ0Yyx2SE41TFFrZg%3D%3D)。

我并不是为了说明 Golang 是解决我们疑难杂症的灵丹妙药。我们再三考虑了我们每项服务的需求，作为一个公司，我们努力地站在新技术的前沿并且会反躬自省，我们能做得更好吗？这将是一个持续进步的过程，我们将会再三调研并认真计划。

我可以很自豪地说，我们的 Octo 服务已经非常成功地运行了几个月（修复了一些 bug 除外），结局皆大欢喜，Digg 将继续前行。

![image](http://ac-Myg6wSTV.clouddn.com/406585559a3d18e43467.png)

[](http://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fgengo%2Fgoship&t=ZjlkNmY2NjYzZGE1OWY5ZjY3MDc3ODUwNWEzNDkxYTgzNTc1OTYwZix2SE41TFFrZg%3D%3D)_[https://github.com/gengo/goship](http://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fgengo%2Fgoship&t=ZjlkNmY2NjYzZGE1OWY5ZjY3MDc3ODUwNWEzNDkxYTgzNTc1OTYwZix2SE41TFFrZg%3D%3D)_
