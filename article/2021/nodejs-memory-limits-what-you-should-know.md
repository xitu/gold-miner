> * 原文地址：[Node.js Memory Limits - What You Should Know](https://blog.appsignal.com/2021/12/08/nodejs-memory-limits-what-you-should-know.html)
> * 原文作者：[Camilo Reyes](https://blog.appsignal.com/authors/camilo-reyes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/nodejs-memory-limits-what-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/nodejs-memory-limits-what-you-should-know.md)
> * 译者：
> * 校对者：

# Node.js内存限制 - 你应该了解的知识

在这篇文章中，我们将探索学习Node中的内存堆分配，并将本地硬件推向其极限。 然后，我们将找到监视Node进程以调试内存问题的实际方法。  

准备好了吗? 让我们一起学习吧!  

你可以[从我的GitHub克隆代码](https://github.com/beautifulcoder/node-memory-limitations)。  

## V8垃圾回收器介绍

首先，简单介绍一下V8垃圾回收器。堆是内存分配的地方，堆内存被划分为几个区域，这些区域被简单地称为世代。对象在其整个生命周期中随着年龄的增长加入下一个世代。  

有新生代还有老年代。 新生代被进一步划分为幼儿子代和中间子代。 从垃圾回收器中幸存下来的对象，会加入到更老的一代中。  

![Generational Regions](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fgenerations.png&w=3840&q=75)

**源： [https://v8.dev/_img/trash-talk/02.svg](https://v8.dev/_img/trash-talk/02.svg)**

世代假设的基本原则是大多数对象都会在新生代死亡，V8的垃圾回收器就是利用这个原则设计的，它只促进那些在垃圾回收器中存活下来的对象。当对象被复制到相邻区域时，它们最终会在一个老年代中结束。

节点内存消耗主要有三个方面:

- 代码 - 代码执行的地方。

- 调用堆栈 - 用于函数和局部变量的基本类型，如Number，String或Boolean。

- 堆内存。

堆内存是我们要学习的重点。

现在你已经了解了关于垃圾回收器的信息，是时候在堆上分配一些内存了!

```js
function allocateMemory(size) {
  // 模拟字节分配
  const numbers = size / 8;
  const arr = [];
  arr.length = numbers;
  for (let i = 0; i < numbers; i++) {
    arr[i] = i;
  }
  return arr;
}
```

局部变量在函数调用结束后不久就会在调用堆栈中消失。像`numbers`这样的原语永远不会进入堆，而是在调用堆栈中被分配。对象`arr`将进入堆中，并可能在垃圾回收器中幸存。

## 堆内存有限制吗？

现在来个大胆的测试——将Node进程推到最大容量，看看在哪里耗尽了堆内存:

```js
const memoryLeakAllocations = [];

const field = "heapUsed";
const allocationStep = 10000 * 1024; // 10MB

const TIME_INTERVAL_IN_MSEC = 40;//时间间隔 - ms

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

这将分配大约10MB，间隔为40毫秒，这为垃圾回收提供了足够的时间，以便将幸存的对象提升到老年代。`memoryUsage`是一个回收堆利用率指标的粗糙工具。随着堆分配的增长，`heapUsed`字段跟踪堆的大小。这个堆字段报告RAM中的字节数，可以转换为GB。

你的结果可能有所不同。一台带有32GB内存的Windows 10笔记本电脑会产生这样的结果:

```
Heap allocated 4 GB
Heap allocated 4.01 GB

<--- Last few GCs --->

[18820:000001A45B4680A0] 26146 ms: Mark-sweep (reduce) 4103.7 (4107.3) -> 4103.7 (4108.3) MB, 196.5 / 0.0 ms (average mu = 0.112, current mu = 0.000) last resort GC in old space requested

<--- JS stacktrace --->
FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - JavaScript heap out of memory
```

在这里，垃圾回收器在放弃并抛出“内存堆溢出”异常之前，试图将压缩内存作为最后的手段。 这个过程达到了4.1GB的限制，需要26.6秒才能意识到是时候结束了。   

其原因尚不清楚。 V8垃圾回收器最初运行在32位浏览器进程中，有严格的内存限制。 这些结果表明内存限制可能来自遗留代码。  

在撰写本文时，该脚本运行在最新的LTS Node版本下，并且使用64位可执行文件。 理论上，一个64位进程应该能够分配超过4GB的地址空间，并且能够很好地扩展到16TB的地址空间。  

## 扩大内存分配限制

V8的垃圾回收器对Node可执行文件有一个`--max-old-space-size`参数可用:

```bash
node index.js --max-old-space-size=8000
```

这一步将最大限制设置为8GB。这样做时要小心。我的笔记本电脑有32GB的空间。我建议将其设置为你电脑的RAM中的物理可用空间大小。一旦物理内存耗尽，该进程就开始通过虚拟内存消耗磁盘空间。如果你设置的限制太高，可能会损坏你的电脑!

燃烧8GB，测试新的极限:

```
Heap allocated 7.8 GB
Heap allocated 7.81 GB

<--- Last few GCs --->

[16976:000001ACB8FEB330] 45701 ms: Mark-sweep (reduce) 8000.2 (8005.3) -> 8000.2 (8006.3) MB, 468.4 / 0.0 ms (average mu = 0.211, current mu = 0.000) last resort GC in old space requested

<--- JS stacktrace --->

FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - JavaScript heap out of memory
```

堆大小几乎达到了8GB，但还没有达到。我怀疑Node进程中有一些开销来分配这么多内存。这一次，进程结束需要45.7秒。

在生产环境中，耗尽内存的时间可能不会少于一分钟。这就是为什么监视和洞察内存消耗会有所帮助的原因之一。随着时间的推移，内存消耗可能会缓慢增长，可能需要几天时间才能发现问题。如果进程持续崩溃，并且在日志中出现“内存溢出”异常，那么代码中可能存在**内存泄漏**。

由于处理更多的数据，进程可能会消耗更多的内存。如果资源消耗继续增长，也许是时候打破这个庞然大物，将其转化为微服务了。这将减少单个进程的内存压力，并允许节点水平扩展。

## 如何跟踪Node.js内存泄漏

`process.memoryUsage`函数通过`heapUsed`字段是有点有用的。调试内存泄漏的一种方法是将内存指标放在另一个工具中进一步处理。因为这个实现并不复杂，所以分析仍然主要是一个手工过程。

在代码中把它放在`setInterval`调用的正上方:

```js
const path = require("path");
const fs = require("fs");
const os = require("os");

const start = Date.now();
const LOG_FILE = path.join(__dirname, "memory-usage.csv");

fs.writeFile(LOG_FILE, "Time Alive (secs),Memory GB" + os.EOL, () => {}); // fire-and-forget
```

为了避免将堆分配指标放在内存中，让我们选择写入CSV文件以方便数据的使用。使用async`writeFile`函数和回调函数。回调函数为空以写入文件，并继续执行，不进行进一步的处理。

要获取渐进内存指标，请将此添加到`console.log`上:

```js
const elapsedTimeInSecs = (Date.now() - start) / 1000;
const timeRounded = Math.round(elapsedTimeInSecs * 100) / 100;

s.appendFile(LOG_FILE, timeRounded + "," + gbRounded + os.EOL, () => {}); // fire-and-forget
```

使用此代码，你可以在堆利用率随时间增长时调试内存泄漏。你可以使用任何工具来分析原始CSV数据并显示良好的视觉效果。

如果你很赶时间，只想看一些数据，Excel可以做到:

![Memory Growth](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fnode-memory-limitations.png&w=3840&q=75)

在4.1GB的限制下，你可以看到内存使用量在短时间内呈线性增长。内存消耗继续增长，没有停滞不前，这表明某个地方存在内存泄漏。在调试这些类型的内存问题时，寻找导致分配结束在老年代的代码。在垃圾回收中幸存下来的对象可能会一直停留到进程死亡。

使此内存泄漏检测代码更加可重用的一种方法是将其包装在自己的时间间隔内(因为它不必驻留在主循环中)。

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

请记住，这不是用于生产的，只是展示了如何在本地代码中调试内存泄漏。实际的实现将包括自动可视化、警报和旋转日志，这样服务器就不会耗尽磁盘空间。

## 跟踪生产中的Node.js内存泄漏

虽然上面的代码在生产环境中是不可用的，但是我们已经了解了如何调试一些内存泄漏。因此，作为一种替代方法，可以将Node进程包裹在[PM2这样的守护进程](https://pm2.keymetrics.io/docs/usage/restart-strategies/)周围。

设置内存消耗达到限制时的重启策略:

```bash
pm2 start index.js --max-memory-restart 8G
```

单位可以是K (kilobyte)、M (megabyte)和G (gigabyte)。流程重新启动之前需要大约30秒的时间，因此通过负载平衡器拥有多个节点可以避免中断。

另一个很好用的工具是独立于平台的本机模块[node-memwatch](https://github.com/lloyd/node-memwatch)，它在检测到运行代码中的内存泄漏时触发一个事件。

```js
const memwatch = require("memwatch");

memwatch.on("leak", function (info) {
  // event emitted
  console.log(info.reason);
});
```

该事件是通过`leak`触发的，并且回调对象有一个`reason`属性，表示在连续的垃圾回收过程中**堆增长**。

## 使用AppSignal工具的折线图来检测内存限制

[AppSignal为垃圾回收统计提供了一个神奇的折线图](https://blog.appsignal.com/2021/01/19/nodejs-garbage-collection-heap-statistics-magic-dashboard-metrics.html)，用来监控堆的增长。

![Heap Growth](https://blog.appsignal.com/_next/image?url=%2Fimages%2Fblog%2F2021-12%2Fnode-heap-statistics.png&w=3840&q=75)

上面显示，请求在14:25左右停止了7分钟，允许垃圾回收以减少内存压力。折线图还将显示何时对象在旧空间附近挂起时间过长并导致内存泄漏。

## 总结:解决Node.js内存限制和泄漏

在这篇文章中，在探索堆内存是否有限制以及如何扩展内存分配限制之前，我们先了解了V8垃圾回收器做了什么事。

最后，我们研究了一些潜在的工具来监视你的Node.js应用程序中的内存泄漏。我们发现，通过使用`memoryUsage`这样的粗糙工具和一些调试技术，内存分配监控是可能的。在这里，分析仍然是一个手工过程。

另一种选择是使用专业工具，如AppSignal，它提供监视、警报和良好的视觉效果来实时诊断内存问题。

我希望你喜欢这篇关于内存限制和诊断内存泄漏的简短介绍。

现在开始编程吧!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
