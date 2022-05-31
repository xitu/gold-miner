> * 原文地址：[Node.js Memory Limits - What You Should Know](https://blog.appsignal.com/2021/12/08/nodejs-memory-limits-what-you-should-know.html)
> * 原文作者：[Camilo Reyes](https://blog.appsignal.com/authors/camilo-reyes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/nodejs-memory-limits-what-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/nodejs-memory-limits-what-you-should-know.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[Tong-H](https://github.com/Tong-H), [finalwhy](https://github.com/finalwhy)

# 你应该知道的 Node.js 内存限制

在这篇文章中，我将探索 Node 中的堆内存分配，以及尝试运行本地硬件的极限。然后，我们将找到合适的方式对 Node 进程进行监控以便调试内存问题。

准备好了吗？我们开始吧！

为了同步进度，你可以[从我的 GitHub 下载代码](https://github.com/beautifulcoder/node-memory-limitations) 。

## V8 垃圾回收简介

首先，我们先来简单介绍一下 V8 垃圾回收器。堆是分配内存的地方，它被分配成多个**分代**区域。这些区域被简单称为“代（generation）”，对象的整个生命周期中，根据它的存活时长不同，归属于不同的代。

V8 中有一个新生代和老生代。新生代中的对象会被进一步划分到 Nursery 和 Intermediate  两个子生代中。在每轮 GC 之后，存活下来的对象将进入到下一个的生代中。

![Generational Regions](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fgenerations.png&w=3840&q=75)

**来源：[https://v8.dev/_img/trash-talk/02.svg](https://v8.dev/_img/trash-talk/02.svg)**

分代假设的基本原理是大部分的对象会在新生代时消亡。V8 垃圾回收器旨在利用这一既定事实，它只晋升（译者注：指将该对象移入下一个生代的内存空间）那些在垃圾回收中存活下来的对象。当对象被复制到相邻的内存区域后，它们最终会在一个老生代中消亡。

三个主要的 Node 内存消耗区域：

* 代码 - 代码被执行的地方
* 调用栈（译者注：也通常被称为**栈内存**） - 函数和基础数据类型的局部变量，像 number，string，或者 boolean
* 堆内存

我们今天主要关注堆内存。

现在，你知道更多关于垃圾回收器的内容了，是时候在堆上分配一些内存了！

```js
function allocateMemory(size) {
  // 模拟字节数的分配
  const numbers = size / 8;
  const arr = [];
  arr.length = numbers;
  for (let i = 0; i < numbers; i++) {
    arr[i] = i;
  }
  return arr;
}
```

一旦调用栈中被调用的函数执行结束，局部变量就会消亡。像 `numbers` 这类基本数据类型永远不会进入堆中，而是在调用栈中被分配。`arr` 对象会进入堆中，而且很大可能会在垃圾回收中存活下来。

## 堆内存有什么限制吗？

我们现在大胆地尝试一下——将 Node 进程推到它的最大容量，然后看看它在哪里耗尽了堆内存：

```js
const memoryLeakAllocations = [];

const field = "heapUsed";
const allocationStep = 10000 * 1024; // 10MB

const TIME_INTERVAL_IN_MSEC = 40;

setInterval(() => {
  const allocation = allocateMemory(allocationStep);

  memoryLeakAllocations.push(allocation);

  const mu = process.memoryUsage();
  // # bytes / KB / MB / GB
  const gbNow = mu[field] / 1024 / 1024 / 1024;
  const gbRounded = Math.round(gbNow * 100) / 100;

  console.log(`Heap allocated ${gbRounded} GB`);
}, TIME_INTERVAL_IN_MSEC);
```

每隔 40 毫秒分配 10 MB 左右，这给垃圾回收足够的时间，将存活的对象晋升到老生代中。`process.memoryUsage` 是一个收集堆利用率指标的原生工具。其中，`heapUsed` 字段的值会随着堆分配的增多而增大、这个堆字段记录了当前使用的内存的字节数（bytes），字节数也可以转换为 GB。

上述代码在你的机器上执行结果可能与本文中不同。此处以一台内存为 32GB 的搭载 Windows 10 操作系统的笔记本电脑为例，会产生这样的结果：

```
Heap allocated 4 GB
Heap allocated 4.01 GB

<--- Last few GCs --->

[18820:000001A45B4680A0] 26146 ms: Mark-sweep (reduce) 4103.7 (4107.3) -> 4103.7 (4108.3) MB, 196.5 / 0.0 ms (average mu = 0.112, current mu = 0.000) last resort GC in old space requested

<--- JS stacktrace --->
FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - JavaScript heap out of memory
```

这里，垃圾回收器在放弃并抛出“内存栈溢出”异常之前，会尝试压缩内存作为最后手段。这个进程用了 26.6s 达到了 4.1GB 的内存限制，此时它意识到是时候终止了。

（存在内存限制的）具体原因尚不清楚。V8 垃圾回收器一开始运行在具有严格内存限制的 32 位的浏览器进程中。这些结果暗示内存限制也许来自遗留代码。

在写这篇文章的时候，脚本运行于最新的 LTS Node 版本下，并且用的是 64 位的可执行文件。理论上，64 位进程应该能分配高于 4GB 的内存，并且很容易地扩展到 16TB 的地址空间。

## 扩大内存分配限制

V8 垃圾回收器有一个 `--max-old-space-size` 可用参数，给 Node 执行：

```bash
node index.js --max-old-space-size=8000
```

它设置了最大限制是 8GB。当你做这件事的时候要小心。我的笔记本电脑有 32GB 的巨大空间。我建议将这个设置为你的 RAM 中的实际物理可用空间。一旦物理内存耗尽，该进程就开始通过虚拟内存消耗磁盘空间。如果你设置得太高了，可能会导致损坏你的电脑！此处设置为 8GB 的目标是为了避免机器跑着跑着就冒烟了。

在 8GB 的消耗下，测试新的限制：

```
Heap allocated 7.8 GB
Heap allocated 7.81 GB

<--- Last few GCs --->

[16976:000001ACB8FEB330] 45701 ms: Mark-sweep (reduce) 8000.2 (8005.3) -> 8000.2 (8006.3) MB, 468.4 / 0.0 ms (average mu = 0.211, current mu = 0.000) last resort GC in old space requested

<--- JS stacktrace --->

FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - JavaScript heap out of memory
```

堆使用的内存大小几乎达到了 8GB，但还有一些小差距。我怀疑剩余的这部分内存被分配给了 Node 进程中有一些常驻任务。这次，耗费了 45.7 秒才让进程停止。

在生产环境中，达到内存溢出的时间大概率不会像实验中这么短。这也正是监控内存消耗会有所帮助的原因之一。内存消耗会随着时间缓慢增长，所以你可能需要几天的时间，才知道有问题。如果进程持续崩溃，并且在日志中出现 ‘heap out of memory’ 异常，那么，代码中就可能存在**内存泄漏**。

进程可能也会因为正在处理大量的数据而（临时）吃掉更多的内存。但如果资源消耗持续增长，那可能是时候把这个庞然大物拆分成微服务了。这可以减少单个进程的内存压力，并且允许节点水平扩展。

## 如何跟踪 Node.js 中的内存泄漏

`process.memoryUsage` 函数里的 `heapUsed` 字段就派上用场了。调试内存泄漏的一种方法是将内存指标放在另一个工具中进行进一步处理。因为这个实现并不复杂，所以大多数地分析仍然是一个手工过程。

在代码中，将这段代码放到调用 `setInterval` 函数的正上方： 

```js
const path = require("path");
const fs = require("fs");
const os = require("os");

const start = Date.now();
const LOG_FILE = path.join(__dirname, "memory-usage.csv");

fs.writeFile(LOG_FILE, "Time Alive (secs),Memory GB" + os.EOL, () => {}); // fire-and-forget
```

为了避免将堆分配指标放在内存中，让我们选择将其写入 CSV 文件的方式以方便数据的使用。使用支持回调函数的异步 方法 `writeFile`，其回调函数留空，以便在写入文件后进程继续执行而不做任何进一步的处理。

为了获取逐渐增长的内存指标，在 `console.log` 前添加这些代码：

```js
const elapsedTimeInSecs = (Date.now() - start) / 1000;
const timeRounded = Math.round(elapsedTimeInSecs * 100) / 100;

s.appendFile(LOG_FILE, timeRounded + "," + gbRounded + os.EOL, () => {}); // fire-and-forget
```

有了这些代码，你就可以在堆利用率随时间增长时，调试内存泄漏。你也可以使用任何工具来分析原始 CSV 数据并呈现出漂亮的视觉效果。

如果你很紧急，并且只是想看看一些数据，用 Excel 就可以做到。

![内存增长](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fnode-memory-limitations.png&w=3840&q=75)

在 4.1GB 的限制下，你能看到内存占用在短时间内，呈线性增长。内存消耗持续增长且没有停滞，这就表明在某处代码存在内存泄漏。在调试这类内存问题时，寻找会导致最终分配到老生代对象的代码。垃圾回收中存活下来的对象，很大可能会一直存在直到进程结束。

一种让这种内存泄漏监测代码复用性更强的方式是，把它封装在它自己的作用域内（因为它不需要驻留在主循环中）。

```js
setInterval(() => {
  const mu = process.memoryUsage();
  // # bytes / KB / MB / GB
  const gbNow = mu[field] / 1024 / 1024 / 1024;
  const gbRounded = Math.round(gbNow * 100) / 100;

  const elapsedTimeInSecs = (Date.now() - start) / 1000;
  const timeRounded = Math.round(elapsedTimeInSecs * 100) / 100;

  fs.appendFile(LOG_FILE, timeRounded + "," + gbRounded + os.EOL, () => {}); // fire-and-forget
}, TIME_INTERVAL_IN_MSEC);
```

注意，这不是用作生产环境的，只是展示如何在本地代码中调试内存泄漏。真正的实现会包括自动可视化、报警、和记录上报日志，这样服务器就不会耗尽磁盘空间。

## 在生产环境中持续跟踪 Node.js 内存泄漏

虽然上面的代码在生产环境是不可行的，但是我们已经了解一些调试内存泄漏的方法。因此，作为一种替代方法，可以将 Node 进程封装在[守护进程（如 PM2 ）中](https://pm2.keymetrics.io/docs/usage/restart-strategies/) 。

设置内存消耗达到限制时的重启机制：

```bash
pm2 start index.js --max-memory-restart 8G
```

单位可以是 K（kilobyte），M（megabyte），和 G（gigabyte）。它用了大概30秒的时间才重启进程，因此，可以通过负载均衡器实现多个节点来避免服务中断。

另一个很棒的工具是独立于平台的原生模块 [node-memwatch](https://github.com/lloyd/node-memwatch) ，当它检测到正在运行的代码中存在内存泄漏时，会触发一个事件。

```js
const memwatch = require("memwatch");

memwatch.on("leak", function (info) {
  // event emitted
  console.log(info.reason);
});
```

该事件通过 `leak` 发布，其回调对象有一个 `reason` 属性，会表示经过连续的垃圾回收后，**堆内存占用逐渐增长**。

## 使用 AppSignal 的魔法面板诊断内存限制

[AppSignal 有一个用于垃圾收集统计的神奇面板](https://blog.appsignal.com/2021/01/19/nodejs-garbage-collection-heap-statistics-magic-dashboard-metrics.html) 监控堆内存的增长。

![堆内存的增长](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fnode-heap-statistics.png&w=3840&q=75)

上面显示外部请求在 14：25 左右停止了 7 分钟，此时 GC 被允许执行以减轻内存压力。当有对象在老生代停留时间过长而导致内存泄漏时，仪表盘也能展示出来。

## 总结：解决 Node.js 内存限制和泄漏

在这篇文章中，我们在探索堆内存是否有限制以及如何扩展内存分配限制之前，了解了 V8 的垃圾回收器到底做了什么。

最后，我们测试了一些有潜力的工具来监视你 Node.js 应用程序的内存泄漏。我们看到，我们可以通过使用 “memoryUsage” 等原始工具和一些调试技术，实现内存分配监控。不过，这里的分析仍然是不够自动化。

另一种选择是使用专业工具，如 AppSignal，它提供了监视、警报和良好的视觉效果来实时诊断内存问题。

我希望您喜欢这篇关于内存限制和诊断内存泄漏的简短介绍。

现在是时候敲代码啦！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
