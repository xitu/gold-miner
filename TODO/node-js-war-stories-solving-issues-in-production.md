> * 原文地址：[Node.js War Stories: Debugging Issues in Production](https://blog.risingstack.com/node-js-war-stories-solving-issues-in-production-2/)
> * 原文作者：[Gergely Nemeth](https://blog.risingstack.com/author/gergely/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[mnikn](https://github.com/mnikn)
> * 校对者：[lsvih](https://github.com/lsvih)、[Aladdin-ADD](https://github.com/Aladdin-ADD)

# Node.js 之战: 在生产环境中调试错误 #

在这篇文章,**这篇文章讲述了 Netflix、RisingStack 和 nearForm 在生产环境中遇到 Node.js 错误的故事** - 因此你可以此为鉴，避免犯上同样的错误。同时你将会学到如何调试 Node.js 的错误。

**感谢来自 Netflix 的 Yunong Xiao、来自 Strongloop 的 NearForm 和来自 Shubhra Kar 的 Matteo Collina 对这篇文章的见解与帮助。**

过去4年里，我们在 RisingStack 的生产环境中运行 Node 应用，积累了许多相关经验 -  感谢 [Node.js 咨询、学习和开发](https://risingstack.com/) 的业务支持。

Netflix 和 nearForm 的 Node 开发团队都一样，我们都有把调试过程记录下来的习惯，因此整个开发团队 (现在是全世界的开发团队) 都可以从我们的错误中学习。 

## Netflix 与 Node 调试: 了解你的依赖库 ##

**让我们慢慢阅读我们的朋友 Yunong Xiao 在 Netflix 发生的故事。**

Netflix 的开发团队发现他们的应用的响应时间在逐渐变长 - 他们部分终端的延迟每小时增加 10 ms。 

同时，CPU 使用率的上升也反映了问题的存在。

![Netflix debugging Nodejs in production with the Request latency graph](https://blog-assets.risingstack.com/2017/04/Netflix-debugging-Nodejs-in-production---Request-latency-graph.png)

**不同时间段请求的传输时间 - 图片来源: Netflix**

一开始，他们调查是否是 request handler 造成其响应时间变长。 

**在隔离测试后,他们发现 request handler 的响应时间稳定在 1 ms 左右。**

所以问题并不是这个，他们开始怀疑到底层，是不是栈出现了问题。

接下来 Yunong 和 Netflix 开发团队的尝试是这个 [CPU 火焰图](http://www.brendangregg.com/FlameGraphs/cpuflamegraphs.html) 和 Linux [性能事件](https://perf.wiki.kernel.org/index.php/Main_Page)。

![Flame graph of Netflix Nodejs slowdown](https://blog-assets.risingstack.com/2017/04/Flame-graph-of-Netflix-Nodejs-slowdown.png)

**火焰图反映了 Netflix 的响应速度正在变慢 - 图片来源: Netflix**

**你可以从火焰图中看到的东西是**

- 它有一些很高的栈 **（这代表有许多函数被调用）**
- 并且一些矩形很宽 **（代表我们在这些函数中耗费了一些时间）**

经过深入调查，开发团队发现 Express 的 `router.handle` 和 `router.handle.next` 有许多引用。

> Express.js 的源代码揭示了一系列有趣的事情：
> 
> - 所有终端的 Route handlers 都储存在一个全局数组中。
> - Express.js 递归地遍历并唤醒所有 handlers 直到它找到合适的 route handler。

**在揭示谜题的解决方案前，我们需要知道更多的细节：**

Netflix 的底层代码包含了每 6 分钟运行的定时代码，从拓展资源中抓取新的路由配置信息，更新应用的 route handlers 从而响应改变的信息。

这些是通过删除并添加新的 handlers 来实现的。意外的是，同时它再一次添加了相同的静态 handler - 甚至是以前的 API route handlers。**这造成的结果是，响应时间额外增加了 10 ms。**

### 从 Netflix 的错误中获取的教训 ###

- **一定要了解你的依赖库** - 首先，你必须在生产环境中使用它们之前，彻底地了解它们。
- **可观察性是关键** - 火焰图帮助 Netflix 工程团队解决了问题。

> 从这里阅读整个故事: [火焰图中的 Node.js](http://techblog.netflix.com/2014/11/nodejs-in-flames.html)。

#### 当你最需要帮助时候的专家指引

##### 商业化 Node.js，由 RisingStack 提供
[了解更多](https://risingstack.com/nodejs-support?utm_source=rsblog&amp;utm_medium=roadblock-new&amp;utm_campaign=trace&amp;utm_content=/node-js-war-stories-solving-issues-in-production-2/) 

## RisingStack CTO: "加密是要花时间的" ##

你可能已经听过我们的故事 [拆分单体式应用的故事](https://www.youtube.com/watch?v=k9QZ4oIOHnk)，我们的 CTO Peter Marton 把 [Trace **(我们的 Node.js 监控系统)**](https://trace.risingstack.com) 分离成多个微服务模块。

**我们现在讨论的错误是 Trace 开发时的响应速度变慢：**

作为一个在 PaaS 运行的 早期 Trace 版本，它通过公共云来与我们的其他服务通信。

为了确保我们的请求是完整的，我们决定对所有请求进行签名。为了实现这个，我们看了 Joyent 的 [HTTP signing library](https://github.com/joyent/node-http-signature)。很棒的是，[request](https://www.npmjs.com/package/request) 这一模块支持开箱即用的HTTP签名。

**解决方案代价不仅很大，而且会对我们的响应速度造成不好的影响。**

![network delay in nodejs request visualized by trace](https://blog-assets.risingstack.com/2017/04/network-delay-in-nodejs-request-visualized-by-trace.png)

**网络延迟增加了我们的响应时间 - 图片来源: Trace**

从图中可看到，所给定的终端响应速度为 180 ms，然而对于总体来说，**单独两个服务的网络延迟只是 100 ms**。

一开始，我们 [用 Kubernetes 转移 PaaS provider](/moving-node-js-from-paas-to-kubernetes-tutorial/)。我们希望响应速度会快一点，这样内部网络就会平衡。

> 我们的方法奏效了 - 终端的响应速度提高了。

然而，我们想要更好的结果 - 大幅度降低 CPU 的使用率。下一步是分析 CPU 的使用情况，就像 Netflix 的人们做的一样：

![crypto sign function taking up cpu time](https://blog-assets.risingstack.com/2017/04/crypto-sign-function-taking-up-cpu-time.png)

从截图可以看出，`crypto.sign` 函数消耗的 CPU 时间最多,每次请求花费 10 ms。为了解决这个问题，你有两种选择：

- 如果你在可信任的环境中运行应用，你可以去除请求签名，
- 如果你在不可信的环境中运行，你可以升级你的机器让它拥有更强大的 CPU。

### 从 Peter Marton 中获取的教训  ###

- **服务之间的终端信息传输会对用户体验有巨大的影响** - 尽可能的平衡内部网络。
- **加密可能会消耗大量时间**。

## nearForm: 不要堵塞 Node.js 的事件循环 ##

**React 现在很流行**。开发者在前端和后端都会使用它，甚至他们更进一步用它来构建同构的 JavaScript 应用。

> 然而，渲染 React 页面会让 CPU 有挺大的负担，当绘制复杂的 React 内容时会受到 CPU 限制。

当你的 Node.js 正在进行绘制，它会堵塞事件循环，因为它的行为都是基于同步的。

结果就是，**服务器可能会毫无反应** - 当请求堆积起来，会把所有的负担都堆在 CPU 上。

更糟的是即使请求端已经关闭，请求仍然会被处理 - 仍然会对 Node.js 应用造成负担，nearForm  对此有解释 [Matteo Collina](https://github.com/mcollina)。

**不仅是 React，大多数字符串操作也会这样。** 如果你在构建 JSON REST APIs，你应该花心思在 `JSON.parse` 和 `JSON.stringify`。

Strongloop（现在是 Joyent) 的 Shubhra Kar 对此解释是，解析和转化成 JSON 字符串的等消耗巨大的操作也会消耗大量时间 **（同时在这期间会堵塞事件循环）**。

```
functionrequestHandler(req, res) {  
  const body = req.rawBody
  let parsedBody
  try {
    parsedBody = JSON.parse(body)
  }
  catch(e) {
     res.end(newError('Error parsing the body'))
  }
  res.end('Record successfully received')
}

```

**简易的 request handler**

这个例子展示了一个简易的 request handler，用来解析 body。对于内容不多的情况下，它运行的挺好 - 然而，**如果 JSON 的大小要以兆来描述的话，可能会花费数秒的时间来执行** 而不是在毫秒时间内执行。同理 `JSON.stringify` 也一样。

为了缓解这个问题，首先你要了解它们。为此，你可以用 Matteo 的 [loopbench](https://github.com/mcollina/loopbench) 模块，或者 [Trace](https://trace.risingstack.com) 的事件循环度量功能。

通过 `loopbench`，如果请求没有被实现，你可以返回状态码 503 给负载平衡器。为了启用这项功能，你要使用选项 `instance.overLimit`。这样 ELB 或者 NGINX 可以在不同的后端中重试，这样请求有可能会被处理。

一旦你了解这个问题并理解它，你就能开始修正它 - 你可以通过平衡 Node.js 流或者改变正在使用的架构来进行修正。

### 从 nearForm 中获取的教训 ###

- **总要留心对 CPU 负担大的操作** - 这类的操作越多，在你的事件循环里对 CPU 造成的压力越大。
- **字符串操作会对 CPU 造成巨大负担**

## 在生产环境中调试 Node.js 错误 ##

我希望 Netflix、RisingStack 和 nearForm 的例子会对你在生产环境中调试 Node.js 应用有帮助。

如果你想要了解更多，我建议看下最近这些文章，它们会加深你的 Node 知识：

- [案例学习：在 Ghost 中查找 Node.js 内存泄漏](https://blog.risingstack.com/case-study-node-js-memory-leak-in-ghost/)
- [理解 Node.js 事件循环](https://blog.risingstack.com/node-js-at-scale-understanding-node-js-event-loop/)
- [解释 Node.js 垃圾回收](https://blog.risingstack.com/node-js-at-scale-node-js-garbage-collection/)
- [Node.js 异步最佳实践和如何避免回调地狱](https://blog.risingstack.com/node-js-async-best-practices-avoiding-callback-hell-node-js-at-scale/)
- [Node.js 的事件溯源示范](https://blog.risingstack.com/event-sourcing-with-examples-node-js-at-scale/)
- [正确地开始 Node.js 测试和 TDD](https://blog.risingstack.com/getting-node-js-testing-and-tdd-right-node-js-at-scale/)
- [10个 Node.js REST APIs 最佳实践](https://blog.risingstack.com/10-best-practices-for-writing-node-js-rest-apis/)
- [使用 Nightwatch.js 对 Node.js 进行端到端测试](https://blog.risingstack.com/end-to-end-testing-with-nightwatch-js-node-js-at-scale/)
- [监测 Node.js 应用的最终指南](https://blog.risingstack.com/monitoring-nodejs-applications-nodejs-at-scale/)

如有任何疑问，请留下评论让我们知道！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
