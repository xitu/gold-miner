* 原文[Quickstarts - Guides](https://cloud.google.com/functions/docs)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)


##什么是 Google 云函数(Google Cloud Function)?

```
Alpah

这是 Google Cloud Function 的 Alpha 版。这些特性可能会通过向后兼容的方式进行改变，并且不推荐大家把它用到生成环境。它适用任何生产层面的协议（SLA -- service-level agreement ）或者弃用策略的附属物。[申请列入白名单以使用此特性](https://docs.google.com/forms/d/1WQNWPK3xdLnw4oXPT_AIVR9-gd6DLo5ZIucyxzSQ5fQ/viewform)

```

Google Cloud Functions 是一个轻量的，基于事件的，异步的计算解决方案，用于创建小而简单的函数。这些函数不需要管理服务器或者运行环境，只需要对云事件做出及时的响应即可。

Google Cloud Function 用 JavaScript 编写并在 Google Cloud Platform 管理的 Node.js 环境中运行。由 Google Cloud Storage 和 Google Cloud Pub/Sub 产生的事件异步触发 Cloud Function，你也可以通过 HTTP 触发并同步执行

##云事件(Cloud Events)和触发器

云事件是指发生在你云环境中的事件。它们可能是数据库中数据的更改、存储系统中文件的添加，或者是创建了一个新的虚拟主机实例。

事件是不论你是否决定去响应都会发生的。创建一个事件的响应是通过触发器来实现的。触发器用来声明你对特定的一个或一组事件感兴趣。创建触发器可以捕获事件并响应。

##云函数

Cloud Functions 是用来响应事件的一种机制。你的 Cloud Functions 中包含了用于响应触发器并处理事件的代码。
