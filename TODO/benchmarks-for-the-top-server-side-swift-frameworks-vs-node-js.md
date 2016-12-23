> * 原文地址：[Benchmarks for the Top Server-Side Swift Frameworks vs. Node.js](https://medium.com/@rymcol/benchmarks-for-the-top-server-side-swift-frameworks-vs-node-js-24460cfe0beb)
* 原文作者：[Ryan Collins](https://medium.com/@rymcol)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Tuccuay](https://github.com/Tuccuay)
* 校对者：[鳗鱼鱼](https://github.com/cyseria), [Nicolas(Yifei) Li](https://github.com/yifili09)

# 顶级 Swift 服务端框架对决 Node.js 

### 前言

最近我在做服务端 Swift 工作时，我被问到这样的问题：

> 「在服务端 Swift 能否击败 Node.js？」

Swift 是一个可以被用来做包括服务端在内的任何事情，从他第一次开源并且移植到 Linux 上就一直很引人入胜。你们肯定有很多人像我一样好奇，所以我非常乐意来分享我的学习成果。

#### 最受欢迎的服务端 Swift 框架

在写这篇文章的时候，按照 Github 上获得 star 的数量顺序排列最受欢迎的服务端 Swift 框架如下：

* [Perfect](https://github.com/perfectlySoft/Perfect) ⭐️7,956
* [Vapor](https://github.com/vapor/Vapor) ⭐️5,183
* [Kitura](https://github.com/ibm-swift/kitura) ⭐️4,017
* [Zewo](https://github.com/zewo/Zewo) ⭐️1,186

#### 本文组织形式

本文将以以下方式呈现：

* 这份快速指引
* 结果摘要
* 方法学
* 详细的结果
* 结论和说明

### 结果摘要

以下是主要测试的结果摘要，我想说的是：

> **无论各项得分怎样，这些框架内所有的表现都非常棒**

![这张图片在 2016 年 9 月 1 日更新](https://cdn-images-1.medium.com/max/2000/1*-J6071Zqsic7zY521MXUHg.png)

### 方法学笔记

#### 为什么使用博客和 JSON？

搭博客比打印 "Hello, World!" 到屏幕上有常见的用途，JSON 也是一种很常见的用例。良好的基准测试需要考虑每个框架在相似负载下的表现，它需要比简单的打印两个单词到屏幕上承载更多的压力。

#### 保持做相同的事情

在每一个主题测试项目中我都会尽量保证博客尽可能相似，同时贴合每个框架的语法风格来完成。为了在许多数据结构中一字不差的使用不同框架生成相同的内容，让每个框架都使用相同的数据模型工作，但是有些方面例如 URL 路由等方式会有很大的差别来适应每个不同框架中的语法和风格。

#### 一些微小的差别

在不同的 Swift 服务端框架直接有一些微小的差别需要注意。

* 在 Kitura 和 Zewo 中，如果绝对路径中存在空格都会在构建时引发一些问题，在 Xcode 中构建任何框架也存在相同的问题。

* Zewo 使用 05-09-a 的 Swift 快照版本，这意味着他在 release 模式下的构建存在一些问题，所以他运行在 debug 模式下。因为这个问题存在所以所有关于 Zewo 的测试都运行在 debug 模式下（这将不包含 release 优化）。

* 静态文件的处理是一个众多服务端 Swift 框架争议的焦点。Vapor 和 Zewo 都建议使用 Nginx 来作为静态文件的代理，然后使用框架来作为后端使用。Perfect 的建议是使用其内置的处理程序，但我并没有有看见 IBM 对此相关的任何评论。由于这项研究不是为了探讨框架如何连接 Nginx 这样的服务器应用，所以静态文件都使用了每个框架本身来处理。你或许可以为了性能考虑而在选择 Vapor 和 Zewo 的时候考虑这个问题，这也是为什么我考虑包含 JSON 测试的一个原因。

* [在 9 月 1 日更新的结果] Zewo 是一个单线程应用程序，你可以通过在每一个 CPU 上都运行一个实例来获得额外的性能提升，因为他们是并发运行而不是在多线程模式下工作。在本研究中，每个应用程序只会有一个实例运行。

* 工具链 (Toolchains)，每个框架都从 Apple 释出的工具链中选择了不同的快照版本，在本文发布时测试的版本如下：

    - DEVELOPMENT-SNAPSHOT-2016-08–24-a for Perfect
    - DEVELOPMENT-SNAPSHOT-2016-07–25-a for Vapor & Kitura
    - DEVELOPMENT-SNAPSHOT-2016-05–09-a for Zewo

* Vapor 运行 release 特殊语法。如果你只是简单的去执行二进制包，你将会在控制台中获得一些可以帮助开发和调试过程的日志记录。这将会带来一些额外的性能开销，为了让 Vapor 运行在 release 模式下你需要添加 `--env=production` 来运行，例如：

    ```bash
    .build/release/App --env=production
    ```

* [在 9 月 1 日更新的结果] 当使用 Zewo 的时候，即使你不能在 05-09-a 工具链上使用 release 模式，你依然可以通过添加以下代码来进行 release 优化：

    ```bash
    swift build -Xswiftc -O
    ```

* Node.js / Express 没有构建编译，因为他没有 debug 和 release 的区别。

* 静态文件处理包括了 Vapor 的默认中间件。如果你没有使用静态文件并且想要优化速度（译注：原作者的意思是如果没有用到它来处理静态文件，那么用这个方法来忽略掉 Vapor 默认的中间件以提高速度。），你必须包含如下代码（就像我在 VaporJSON 中所做的一样）：

    ```bash
    drop.middleware = []
    ```

#### 为什么使用 Node.js / Express?

我决定使用 Node.js 的 Express 来作为一个对照包含在测试中。因为他和 Swift 服务端框架具有非常相似的语法并且被广泛应用。他有助于建立一个基线来展示 Swift 能够多么的让人印象深刻。

#### 开发博客

在某些时候开始，我称之为「追逐弹球」。目前 Swift 服务端框架处于非常活跃的开发状态，因为 Swift 3 的每一个预览版相对于上一个都有成堆的改动。所以 Apple 的 Swift 团队导致所有的服务端 Swift 框架需要频繁的发布新版本。他们没有拥有完善的文档，所以我非常感谢框架的小组成员和广大 Swift 服务端框架社区。我也要对无数的社区成员和框架团队在我前进道路上给予的帮助表示感谢。这有很多的乐趣，我很乐意这样做。

一个额外声明，即使不需要许可说明，我也认为这个需要声明一下：所有包含在源码中的资源都来自 [Pixbay](https://pixabay.com/) 的无版权图片，这对于制作一个示例程序很有帮助。

#### 环境和变量

为了尽量消除不同环境带来的影响，我使用了一个 2012 款的 Mac mini 并且重新安装了 El Capitan (10.11.6)，然后下载了 Xcode 8 beta 6，并且设置 command-line-tools 为 Xcode 8。然后使用 swiftenv 安装了必要的快照版本，克隆仓库并且在 release 模式下清洁的编译每一个博客，并且不会同时进行两个测试。测试服务器的规格是这样的：

![](https://cdn-images-1.medium.com/max/1600/1*vH5SdlsoPeIBYsy2mU-lkw.png)

而在开发中我使用的是 2015 款的 rMBP。我在这里进行了构建测试，因为它是我现实生活中的开发设备所以更有意义。我用 wrk 来获得评分，并且我使用 Thunderbolt 2 线缆来连接两台设备，因为 Thunderbold 桥接能拥有一个令人难以置信的带宽使得你的路由器不会成为限制条件，他能更可靠的在博客单独运行在一台机器上的时候用另一个独立的机器去生成负载以压倒性的测试服务器。这提供了一个一致的测试环境，所以我可以说每个博客都是在相同的硬件和条件下运行，为了满足一些好奇心，我开发设备的规格是：

![](https://cdn-images-1.medium.com/max/1600/1*7QYZK-_cmb7231lnchJpuQ.png)

#### 测试基准

在测试中，我决定使用 4 个线程各生成 20 个连接并持续 10 分钟。4 秒钟不能称之为测试，而 10 分钟是一个合理的时间，因为能获得大量的数据并且 4 个线程运行 20 个连接会对博客造成沉重的负担而不至于断开链接。

#### 源代码

如果你想探索这个项目的源代码或者做任何自己的测试，我把这些测试代码都整合到了一个仓库中，你可以在这里找到：

[https://github.com/rymcol/Server-Side-Swift-Benchmarking](https://github.com/rymcol/Server-Side-Swift-Benchmarking)

### 详细结果

#### 构建时间

我认为可能需要先看一眼构建时间。构建时间在日复一日的开发中占据了很大一部分开发时间，并且他也能算作是框架的性能表现，我觉得我在探索的是真实的数字和持续时间的感觉。

#### 如何运行

对于每一个框架,

```bash
swift build --clean=dist
```

然后

```bash
time swift build
```

运行完之后，进行第二次测试

```bash
swift build --clean
```

最后

```bash
time swift build
```

这两次构建都使用了 SPM(Swift Package Manager, Swift 包管理器) 来管理依赖关系，包括常规的、清洁的依赖都已经下载好了。

#### 怎么运行的

这运行在我本地的 2015 款 rMBP 上并且构建在 debug 模式，因为在使用 Swift 开发应用时这是正常的过程。

#### 构建时间结果

![](https://cdn-images-1.medium.com/max/1600/1*lhhh_8CgevyvpgfnGnVxXA.png) 

![](https://cdn-images-1.medium.com/max/1600/1*wAWMcltJR7B9FP-x2NhzDQ.png)

* * *

#### 内存使用

我第二在意的就是在框架运行时候内存的占用量。

#### 如何运行

第一步 开始内存占用（单纯的启动进程）

第二步 测试我服务器上峰值内存占用

```bash
wrk -d 1m -t 4 -c 10
```

第三步 用下面的方法第二次测试内存占用

```bash
wrk -d 1m -t 8 -c 100
```

#### 怎么运行的

这个测试在一个干净的 Mac mini 专用测试服务器上运行。反映了每个框架在 release 模式可能存在的状况。同一时间只有一个框架在命令行中运行并且会在下一次测试前重启。在测试期间唯一打开的窗口是活动监视器，我用它来可视化内存占用。在每个框架运行的时候，我只是简单的指出峰值出现在活动监视器中的时候。

#### 内存占用结果

![](https://cdn-images-1.medium.com/max/1600/1*8cG8cHnkdhTzVM9Aj0QV9Q.png)

![](https://cdn-images-1.medium.com/max/1600/1*WhQcrT9d5OJI_J9n_XvZOA.png) 

![](https://cdn-images-1.medium.com/max/1600/1*NY3syLPSPdGN25-3G7EC1g.png)

* * *

#### 线程使用

我第三看重的事情是每个框架在负载下的线程使用情况

#### 如何运行

第一步 开始内存占用（单纯的启动进程）

第二部 在我的测试服务器上用下面的命令来产生线程使用：

```bash
wrk -d 1m -t 4 -c 10
```

#### 怎么运行的

这是一个用干净的 Mac mini 来搭建的专用测试服务器，每个框架都尽可能的在 release 模式下执行的。同一时间只有一个框架在命令行中运行并且会在下一次测试前重启。在测试期间唯一打开的窗口是活动监视器，我用它来可视化内存占用。在每个框架运行的时候，我只是简单的指出峰值出现在活动监视器中的时候。

#### 对于这些结果的说明

这里没有「胜出」这一类。许多不同的应用程度对于线程的管理方式不同，并且这些框架也不例外。例如 Zewo 就是一个单线程应用程序，他永远不会使用大于一个线程（如果你没有主动在每一个 CPU 上运行的话）。而 Perfect 则会使用每一个可用的 CPU，Vapor 则是为每个线程模型使用一个 CPU。因此该图的目的是使线程负载峰值更容易看到。

#### 线程使用结果

![](https://cdn-images-1.medium.com/max/1600/1*aLuf-9gs4Xd4ZtnwgNNgcA.png)

![](https://cdn-images-1.medium.com/max/1600/1*QwPMAL7EEOm9L8cIEelT3w.png)

* * *

#### 博客测试

第一个基准测试是处理 `/blog` 的路由，这是一个为每个请求返回 5 个随机图片的假博客文章接口。

#### 如何运行

```bash
wrk -d 10m -t 4 -c 20 http://169.254.237.101:(PORT)/blog
```

从我的 rMBP 上用 Thunderbolt 桥接运行每个博客。

#### 怎么运行的

在内存测试中，每个框架都在 release 模式运行，每次测试之前都会被重新启动。同一时间只有一个框架会被运行在服务器上。所有的活动都保持在最小的改变以保证环境尽可能相似。

#### 结果

![这张图片在 2016 年 9 月 1 日得到更新](https://cdn-images-1.medium.com/max/1600/1*T4iNJjI2pCUt1n-tZnWSnw.png)

![这张图片在 2016 年 9 月 1 日得到更新](https://cdn-images-1.medium.com/max/1600/1*ddAC0BWrOBpvST0QQfpN7Q.png)

* * *

#### JSON 测试

由于每个人对于静态文件的处理方法都各有风格，所以看上去更加公平的方式是使用简单的接口来进行相同的测试，所以我增加了 `/json` 路由来测试每个应用从沙盒内返回 0~1000 之间的随机数。这个测试是单独进行的，以保证静态文件处理程序和中间件不会影响到接结果。

#### 如何运行

```bash
wrk -d 10m -t 4 -c 20 http://169.254.237.101:(PORT)/json
```
    
对每个 JSON 项目都运行

#### 怎么运行的

在其他测试中，每个框架都在 release 模式运行，每次测试之前都会被重新启动。同一时间只有一个框架会被运行在服务器上。所有的活动都保持在最小的改变以保证环境尽可能相似。

#### Results

![这张图片在 2016 年 9 月 1 日得到更新](https://cdn-images-1.medium.com/max/1600/1*sb8WpWPKtUAO4hTTKr46Tg.png)

![这张图片在 2016 年 9 月 1 日得到更新](https://cdn-images-1.medium.com/max/1600/1*NFq7qLFZaGpStZlyEdjfmA.png)

### 结论

我的问题得到的回答是压倒性的 **是**。Swift 能做的不仅能作为服务端框架使用，并且所有的 Swift 服务端框架性能都表现得令人难以置信的好，而 Node.js 在每个测试中都排在最后两名。

由于服务端 Swift 框架可以和其它 Swift 应用共享基本代码库，所以它可以为你节省大量的时间。而从这里的结果可以看出，服务端 Swift 框架在编程领域是非常强有力的竞争者。我个人会在编程中（特别是在服务端）尽可能的使用 Swift。我也迫不及待地想看到社区涌现出更多令人感到惊奇的项目。

### 参与其中

如果你对服务端 Swift 感兴趣，现在是时候参与其中了！这些框架还有大量的工作需要完成，比如说他们的文档。并且有一些非常炫酷的应用程序作为示例（有开源也有闭源）。你可以在这里了解更多信息：

 - Perfect: [Website](http://perfect.org/) | [Github](https://github.com/PerfectlySoft/Perfect/) | [Slack](http://perfect.ly/) | [Gitter](https://gitter.im/PerfectlySoft/Perfect?utm_source=rymcol) 
 - Vapor: [Website](http://vapor.codes/) | [Github](https://github.com/vapor/Vapor/) | [Slack](http://vapor.team/)
 - Kitura: [Website](https://developer.ibm.com/swift/kitura/) | [Github](https://github.com/IBM-Swift/Kitura/) | [Gitter](https://gitter.im/IBM-Swift/Kitura?utm_source=rymcol) - Zewo: [Website](http://www.zewo.io/) | [Github](https://github.com/Zewo/Zewo/) | [Slack](http://slack.zewo.io/)

#### 保持联系

如果你有任何问题，可以在 Twitter 上和我取得联系 [@rymcol](http://twitter.ryanmcollins.com/)。

>需要额外说明的信息：这段内容增加于 2016 年 9 月 1 日，为 Zewo 使用 `swift build -c release` 方法构建而优化并修正了一些数据。PerfectlySoft 公司提供的经费为我进行这项研究提供了动力。我同时也在 Github 上 Perfect & Vapor 的团队中，我不是其中任何一个的雇员，我的意见也不代表他们的观点。我尽力保持绝对的公平公正，因为我同时在所有的四个平台上开发，我是真的想看到结果 [用于研究的所有代码都是公开](https://github.com/rymcol/Server-Side-Swift-Benchmarking)，你可以随时检查测试方式或者自己重复一些测试。


