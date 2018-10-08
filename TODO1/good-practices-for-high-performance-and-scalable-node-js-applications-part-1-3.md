> * 原文地址：[Good practices for high-performance and scalable Node.js applications [Part 1/3]](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3-bb06b6204197)
> * 原文作者：[virgafox](https://medium.com/@virgafox?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3.md)
> * 译者：
> * 校对者：

# Node.js 高性能和可扩展应用程序的最佳实践[第 1/3 部分]

![](https://cdn-images-1.medium.com/max/2000/1*LBVvh_2LqmucG-dP6Em-ww.jpeg)

在本系列的 3 篇文章中，我们将介绍有关开发 Node.js Web 后端应用的一些优秀实践。

本系列将不是关于 Node 的教程，您将阅读的所有内容都适用于已经熟悉 Node.js 基础知识并且正在寻找有关改进其架构的一些提示的开发人员。

主要关注的是效率和性能，以便以更少的资源获得最佳结果。

提高 Web 应用程序吞吐量的一种方法是对其进行扩展，多次实例化它以平衡多个实例之间的传入连接，因此第一篇文章将介绍**如何水平扩展 Node.js 应用程序**， 多个核心或多台机器。

当您向上扩展时，您必须小心应用程序的不同方面，从状态到身份验证，因此第二篇文章将介绍在扩展 Node.js 应用程序时必须考虑的一些事项。

在强制性规则中，有一些**可以解决的良好实践**将在第三篇文章中介绍，例如拆分 api 和工作进程，采用优先级队列，管理周期性工作，如 cron 进程， 当您扩展到 N 个进程/机器时，不打算运行 N 次。

### 第 1 章 —— 水平扩展 Node.js 应用程序

水平扩展是关于复制应用程序实例以管理大量传入连接。此操作可以在单个多核计算机上执行，也可以在不同计算机上执行。

垂直缩放是关于增加单机性能，并且它不涉及代码方面的特定工作。

### 同一台机器上的多个进程

增加应用程序吞吐量的一种常用方法是为计算机的每个核心生成一个进程。通过这种方式，Node.js 中请求的已经有效的“并发”管理（参见“事件驱动，非阻塞I/O”）可以相乘和并行化。

产生大于核心数量的大量进程可能并不聪明，因为在较低级别，操作系统可能会平衡这些进程之间的 CPU 时间。

在单个计算机上有不同的扩展策略，但常见的概念是在同一端口上运行多个进程，并使用某种内部负载平衡来分配所有进程/核心上的传入连接。

![](https://cdn-images-1.medium.com/max/800/1*p6YEK7y6JsVYBaZkhu4UbQ.png)

下面描述的策略是标准的 Node.js **集群模式**和自动的，更高级别的** PM2 集群**功能。

### 本机群集模式

本机 Node.js 集群模块是在单个机器上扩展 Node 应用程序的基本方法 ([https://Node.js.org/api/cluster.html](https://nodejs.org/api/cluster.html))。您的进程的一个实例（称为 “master”）是负责生成其他子进程（称为“worker”）的实例，每个进程对应一个运行应用程序的进程。 传入连接按照所有工作人员的循环策略进行分发，从而在同一端口上公开服务。

这种方法的主要缺点是必须在代码内部管理主进程和工作进程之间的差异，通常使用经典的 if-else 块，而无法轻松修改进程中的进程数。

以下示例取自官方文档：

```
const cluster = require(‘cluster’);
const http = require(‘http’);
const numCPUs = require(‘os’).cpus().length;

if (cluster.isMaster) {
  
 console.log(`Master ${process.pid} is running`);
  
 // Fork workers.
 for (let i = 0; i < numCPUs; i++) {
  cluster.fork();
 }
  
 cluster.on(‘exit’, (worker, code, signal) => {
  console.log(`worker ${worker.process.pid} died`);
 });
  
} else {
  
 // Workers can share any TCP connection
 // In this case it is an HTTP server
 http.createServer((req, res) => {
  res.writeHead(200);
  res.end(‘hello world\n’);
 }).listen(8000);
  
 console.log(`Worker ${process.pid} started`);
 
}
```

### PM2 群集模式

如果您使用 PM2 作为进程管理器（我建议您），那么有一个神奇的群集功能，可以让您跨所有核心扩展流程，而无需担心群集模块。 PM2 守护进程将涵盖“主”进程的角色，它将作为工作程序生成应用程序的N个进程，并进行循环平衡。

通过这种方式，您可以像编写单核用户一样编写应用程序（我们将在下一篇文章中介绍一些注意事项），PM2 将关注多核部分。

![](https://cdn-images-1.medium.com/max/800/0*zWc1jyWm1FNEeNgZ.)

在群集模式下启动应用程序后，您可以使用 “pm2 scale” 即时调整实例数，并执行 “0-second-downtime” 重新加载，其中进程将重新串联，以便始终 至少有一个在线流程。

作为流程管理器，如果 PM2 在生产中运行节点时应该考虑的许多其他有用的东西崩溃，PM2 也将负责重新启动流程。

如果您需要进一步扩展，则可能需要部署更多计算机。

### 具有网络负载平衡的多台计算机

跨多台计算机进行扩展的主要概念类似于在多个核心上进行扩展，有多台计算机，每台计算机运行一个或多个进程，以及用于将流量重定向到每台计算机的平衡器。

将请求发送到特定节点后，上一段中描述的内部平衡器会将流量发送到特定进程。

![](https://cdn-images-1.medium.com/max/800/1*ryiL00dESNJTL_jRnUyAyA.png)

可以以不同方式部署网络平衡器。 如果您使用AWS来配置您的基础架构，一个不错的选择是使用像ELB（Elastic Load Balancer）这样的托管负载均衡器，因为它支持自动扩展等有用功能，并且易于设置。

但是如果你想做旧学校，你可以自己部署一台机器并用NGINX设置一个平衡器。 指向上游的反向代理的配置对于此作业来说非常简单。 下面是配置示例：

```
http {

 upstream myapp1 {
   server srv1.example.com;
   server srv2.example.com;
   server srv3.example.com;
 }
 
 server {
   listen 80;
   location / {
    proxy_pass http://myapp1;
   }
 }
 
}
```

通过这种方式，负载均衡器将是您的应用程序暴露给外部世界的唯一入口点。 如果您担心它是基础架构的单点故障，您可以部署多个指向相同服务器的负载平衡器。

为了在平衡器之间分配流量（每个都有自己的IP地址），您可以向主域添加多个 DNS“A” 记录，因此 DNS 解析器将在您的平衡器之间分配流量，解析为不同的IP 每次都解决。

通过这种方式，您还可以在负载平衡器上实现冗余。

![](https://cdn-images-1.medium.com/max/800/1*iSVmpaGmwYzXWydLJnzM3A.png)

### 下一步

我们在这里看到的是如何在不同级别扩展 Node.js 应用程序，以便从您的基础架构获得尽可能高的性能，从单节点到多节点和多平衡器，但要小心：如果您想使用 在多进程环境中的应用程序，它必须准备好并为此做好准备，否则您将遇到几个问题和不良行为。

在下一篇文章中，我们将介绍如何使您的应用程序扩展就绪。 你可以在[这里](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3-2a68f875ce79)找到它。

* * *

_如果这篇文章对你有用，请给我点赞吧 !_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
