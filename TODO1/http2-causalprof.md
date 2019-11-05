> * 原文地址：[Using Causal Profiling to Optimize the Go HTTP/2 Server](http://morsmachine.dk/http2-causalprof)
> * 原文作者：[Morsing](http://morsmachine.dk/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/http2-causalprof.md](https://github.com/xitu/gold-miner/blob/master/TODO1/http2-causalprof.md)
> * 译者：[JackEggie](https://github.com/JackEggie)
> * 校对者：

# 使用因果分析优化 Go HTTP/2 服务器

## 简介

如果你一直都有关注本博客，那么你应该看过这篇[介绍因果分析的论文](https://www.sigops.org/s/conferences/sosp/2015/current/2015-Monterey/printable/090-curtsinger.pdf)。这种分析方式旨在建立性能消耗周期与性能优化之间的联系。我已经在 Go 语言中实践了这种分析方式。我觉得是时候在一个真正的软件中 —— Go 标准库的 HTTP/2 实现中去实践一下了。

## HTTP/2

HTTP/2 是我们熟悉并且受够了的 HTTP/1 协议的全新实现。它的一个连接可以被用来多次发送或接收请求，以减少建立连接时的开销。Go 中的实现会对每一个请求分配一个 goroutine，或者在一次连接中分配多个 goroutine 以处理异步通讯，为了决定谁在何时可以向连接中写入数据，多个 goroutine 之间会互相协调配合。

这种设计非常适合因果分析。如果有什么东西暗中阻塞了一个请求，那么在因果分析中会很容易发现它，而在传统的分析方式中可能就没那么容易了。

## 实验配置

为了方便度量，我基于 HTTP/2 服务器和其客户端构建了一个综合性的基准测试。服务器请求 Google 首页获取请求的报头和正文，并把每一个请求都记录下来。客户端使用 Firefox 的客户端报头请求根路径下的文档。客户端的最大并发请求量为 10。这个数量是随意选择的，但这应该足以保持 CPU 饱和。

我们需要对程序进行跟踪以便执行因果分析。我们会设置一个 `Progress` 标记，它会记录两行代码之间消耗的执行时间。HTTP/2 服务器会调用 `runHandler` 函数，它会在 goroutine 中运行 HTTP 处理程序。我们在创建 goroutine 前就标记了开始，以便评估并发调度延迟和 HTTP 处理的消耗。结束标记则设置在处理程序向信道中写入所有数据之后。

为了获得测试基线，让我们使用传统的方式从服务器获取一份 CPU 分析数据，结果如下图：

![](http://morsmachine.dk/pprofcausal.png)

好吧，这就是我们从一个已经优化过的大型应用程序中获得的东西，一个巨大的难以优化的调用关系图。红色的大框是系统调用，这部分我们是不可能优化的。

下面的数据给了我们更多相关的内容，但对我们也没有实质性的帮助。

```bash
(pprof) top
Showing nodes accounting for 40.32s, 49.44% of 81.55s total
Dropped 453 nodes (cum <= 0.41s)
Showing top 10 nodes out of 186
      flat  flat%   sum%        cum   cum%
    18.09s 22.18% 22.18%     18.84s 23.10%  syscall.Syscall
     4.69s  5.75% 27.93%      4.69s  5.75%  crypto/aes.gcmAesEnc
     3.88s  4.76% 32.69%      3.88s  4.76%  runtime.futex
     3.49s  4.28% 36.97%      3.49s  4.28%  runtime.epollwait
     2.10s  2.58% 39.55%      6.28s  7.70%  runtime.selectgo
     2.02s  2.48% 42.02%      2.02s  2.48%  runtime.memmove
     1.84s  2.26% 44.28%      2.13s  2.61%  runtime.step
     1.69s  2.07% 46.35%      3.97s  4.87%  runtime.pcvalue
     1.26s  1.55% 47.90%      1.39s  1.70%  runtime.lock
     1.26s  1.55% 49.44%      1.26s  1.55%  runtime.usleep
```

看起来程序主要包含了运行时方法的调用和加密方法的调用。让我们先把加密方法放在一边，因为它已经足够优化了。

## 使用因果分析来拯救这个程序

我们最好在使用因果分析得到分析结果之前回顾一下程序的工作方式。当因果分析被启用时，程序将执行一系列测试。测试首先选择一个调用并执行一些加速程序。当该调用被执行时（通过对程序底层的分析来检测），我们会通过加速程序来降低其他线程的执行速度。

这似乎有悖直觉，但由于我们知道从 `Progress` 标记开始执行时程序会慢多少，我们就可以消除这种影响，以获得加速访问站点后程序将会花费的时间。我建议你阅读我的其他关于因果分析的文章或是[最初的论文](https://www.sigops.org/s/conferences/sosp/2015/current/2015-Monterey/printable/090-curtsinger.pdf)来深入了解其中的原理。

最终，因果分析看上去就像是一些被加速了的请求，使得 `Progress` 标记之间的代码运行时间发生了改变。对于 HTTP/2 服务器来说，一次请求的结果如下：

```bash
0x4401ec /home/daniel/go/src/runtime/select.go:73
  0%    2550294ns
 20%    2605900ns    +2.18%    0.122%
 35%    2532253ns    -0.707%    0.368%
 40%    2673712ns    +4.84%    0.419%
 75%    2722614ns    +6.76%    0.886%
 95%    2685311ns    +5.29%    0.74%
```

在这个例子中，我们观察 `select` 运行时代码中的 `unlock` 调用。我们实际上加速了这一次调用，从而改变了调用的数量、消耗的时间和与基线的差异。结果表明，我们并没有从这样的加速中获得更多潜在的性能提升。事实上，当我们加速 `select` 代码时，程序反而变得更慢了。

第四列数据看上去有点奇怪。它是在这次请求中检测到的样本占比数据，应该和加速成正比。在传统分析方式中，它可以粗略地表示为加速带来的期望性能提升。

现在来看一个更有趣的调用分析结果：

```bash
0x4478aa /home/daniel/go/src/runtime/stack.go:881
  0%    2650250ns
  5%    2659303ns    +0.342%    0.84%
 15%    2526251ns    -4.68%    1.97%
 45%    2434132ns    -8.15%    6.65%
 50%    2587378ns    -2.37%    8.12%
 55%    2405998ns    -9.22%    8.31%
 70%    2394923ns    -9.63%    10.1%
 85%    2501800ns    -5.6%    11.7%
```

该调用位于堆栈代码中，上面的数据显示这里的加速可能会得到不错的结果。第四列数据表明，程序运行时这部分代码占比相当大。让我们基于上面的测试数据再来看看重点关注堆栈代码的传统分析方式的分析结果。

```bash
(pprof) top -cum newstack
Active filters:
   focus=newstack
Showing nodes accounting for 1.44s, 1.77% of 81.55s total
Dropped 36 nodes (cum <= 0.41s)
Showing top 10 nodes out of 65
      flat  flat%   sum%        cum   cum%
     0.10s  0.12%  0.12%      8.47s 10.39%  runtime.newstack
     0.09s  0.11%  0.23%      8.25s 10.12%  runtime.copystack
     0.80s  0.98%  1.21%      7.17s  8.79%  runtime.gentraceback
         0     0%  1.21%      6.38s  7.82%  net/http.(*http2serverConn).writeFrameAsync
         0     0%  1.21%      4.32s  5.30%  crypto/tls.(*Conn).Write
         0     0%  1.21%      4.32s  5.30%  crypto/tls.(*Conn).writeRecordLocked
         0     0%  1.21%      4.32s  5.30%  crypto/tls.(*halfConn).encrypt
     0.45s  0.55%  1.77%      4.23s  5.19%  runtime.adjustframe
         0     0%  1.77%      3.90s  4.78%  bufio.(*Writer).Write
         0     0%  1.77%      3.90s  4.78%  net/http.(*http2Framer).WriteData
```

上面的数据表明 `newstack` 是从 `writeFrameAsync` 中调用的。每当 HTTP/2 服务器向客户端发送数据帧时，都会创建一个 goroutine 并调用该方法。而在任何时刻，只有一个 `writeFrameAsync` 可以运行，如果程序试图发送更多的数据帧，那么它将被阻塞，直到前一个 `writeFrameAsync` 返回。

由于 `writeFrameAsync` 的调用跨越多个逻辑层，因此不可避免会产生大量的堆栈调用。

## 我是如何将 HTTP/2 服务器的性能提升 28.2% 的

堆栈的增长拖慢了程序的运行，那么我们需要采取一些措施来避免它。每次创建 goroutine 的时候都会调用 `writeFrameAsync`，因此写入每一个数据帧时我们都需要付出堆栈增长的代价。

反过来说，如果我们可以重用 goroutine，我们就可以让堆栈只增长一次，而随后的每一次调用都可以重用已经生成好的堆栈了。我将这个改动部署到服务器上，因果分析的测试基线从 2.650ms 下降到 1.901ms，性能提升了 28.2%。

需要注意的是，HTTP/2 服务器通常不会在本地全速运行。我估计，如果将服务器连接到互联网中，收益将会小得多，因为堆栈增长所消耗的 CPU 时间比网络延迟要小得多。

## 结论

因果分析方法目前还不太成熟，但我认为这个小例子明确地展示了它所具有的潜力。你可以查看该项目的[分支](https://github.com/DanielMorsing/go/tree/causalprof)，其中已经加入了因果分析的埋点。你也可以向我推荐其他的测试基线，来看看我们还能得出哪些结论。

附注：我现在正在找工作。如果你们需要对 Go 语言底层的内部实现有所了解并且熟悉分布式架构的人才，请查看我的[简历](https://github.com/DanielMorsing/CV)或发送邮件到 [daniel@lasagna.horse](mailto:daniel@lasagna.horse)。

## 相关文章

* [因果分析概念更新](http://morsmachine.dk/causalprof-update)
* [Go 语言中的因果分析](http://morsmachine.dk/causalprof)
* [Go 语言中的异常处理](http://morsmachine.dk/error-handling)
* [Go 语言中的 netpoller](http://morsmachine.dk/netpoller)
* [Go 语言中的 scheduler](http://morsmachine.dk/go-scheduler)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
