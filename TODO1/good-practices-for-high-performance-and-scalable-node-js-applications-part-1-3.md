> * 原文地址：[Good practices for high-performance and scalable Node.js applications [Part 1/3]](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3-bb06b6204197)
> * 原文作者：[virgafox](https://medium.com/@virgafox?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-practices-for-high-performance-and-scalable-node-js-applications-part-1-3.md)
> * 译者：
> * 校对者：

# Node.js 高性能和可扩展应用程序的最佳实践[第 1/3 部分]

![](https://cdn-images-1.medium.com/max/2000/1*LBVvh_2LqmucG-dP6Em-ww.jpeg)

在本系列的 3 篇文章中，我们将介绍有关开发 Node.js Web 后端应用的一些优秀实践。

本系列将不是关于 Node 的基础教程，您将阅读的所有内容都适用于已经熟悉 Node.js 基础知识的开发者，这些内容有助于他们改进应用架构。

本文主要关注的是效率和性能，以便以更少的资源获得最佳结果。

提高 Web 应用程序吞吐量的一种方法是对其进行扩展，多次实例化以处理多个传入请求，因此本系列第一篇文章将介绍在多核或多台机器上**如何水平扩展 Node.js 应用程序**。

当您扩展时，您必须小心应用程序的不同方面，比如状态和身份验证，因此第二篇文章将介绍在扩展 Node.js 应用程序时必须考虑的一些**注意事项**。

在指定的操作中，有一些**推荐做法**将在第三篇文章中介绍当您扩展到 N 个进程/机器而不打算运行 N 次时，例如拆分 api 和工作进程，采用优先级队列，管理周期性工作，如 cron 进程。

### 第 1 章 —— 水平扩展 Node.js 应用程序

水平扩展是关于复制应用程序实例来处理大量传入请求。此操作可以在一个多核计算机上执行，也可以在不同计算机上执行。

垂直扩展是关于增加单机性能，并且它不涉及代码方面的特定操作。

### 同一台机器上的多个进程

增加应用程序吞吐量的一种常用方法是为计算机的每个核生成一个进程。通过这种方式，我们就可以继续生成和并行这种在 Node.js 中行之有效的『并发』请求管理（参见“事件驱动，非阻塞 I/O”）。

大于核心数量的进程可能并不好，因为在较低级别的进程调度，操作系统可能会均衡这些进程之间的 CPU 时间。

在一个计算机上有不同的扩展策略，但常见的策略是在同一端口上运行多个进程，并使用负载均衡来分配所有进程/核心上的传入请求。

![](https://cdn-images-1.medium.com/max/800/1*p6YEK7y6JsVYBaZkhu4UbQ.png)

下面描述的策略是标准的 Node.js **集群模式**和自动的、更高级别的 **PM2 集群**功能。

### 本机群集模式

本地 Node.js 集群是在一个机器上扩展 Node 应用程序的基本方法 ([https://Node.js.org/api/cluster.html](https://nodejs.org/api/cluster.html))。您的进程的一个实例（称为 “master”）是负责生成其他子进程（称为 “worker”）的实例，每个进程对应一个运行应用程序的进程。 传入请求按照所有 worker 循环策略进行分发，并且在同一端口上访问。

这种方法的主要缺点是必须在代码内管理主进程和工作进程之间的差异，通常使用经典的 if-else 块，而无法轻松修改进程中的进程数。

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

如果您使用 PM2 作为进程管理器（我建议您使用），那么有一个神奇的群集功能，可以让您跨所有核心扩展流程，而无需担心群集。 PM2 守护进程将作为 “master”，并生成 N 个子进程作为 worker，然后利用轮询算法（round-robin）进行负载均衡。

通过这种方式，您可以像编写单核用法一样编写应用程序（我们将在下一篇文章中介绍一些注意事项），PM2 将关注多核部分。

![](https://cdn-images-1.medium.com/max/800/0*zWc1jyWm1FNEeNgZ.)

在群集模式下启动应用程序后，您可以使用 “pm2 scale” 实时调整实例数，并执行 “0-second-downtime” 重新加载，其中进程将重新串联，以便始终至少有一个在线进程。

作为进程管理器，如果 PM2 在生产中运行节点时，其他有用的进程崩溃了，PM2 也将负责重新启动他们。

如果您需要进一步扩展，则可能需要部署更多计算机。

### 多服务器网络负载均衡

跨多台计算机进行扩展可以理解为在多个核心上进行扩展，有多台计算机，每台计算机运行一个或多个进程，以及用于将流量重定向到每台计算机的负载均衡服务器。

将请求发送到特定节点后，上一段中描述的负载均衡服务器会将流量发送到特定进程。

![](https://cdn-images-1.medium.com/max/800/1*ryiL00dESNJTL_jRnUyAyA.png)

可以以不同方式部署网络负载均衡服务器。 如果您使用 AWS 来配置您的基础架构，一个不错的选择是使用像 ELB（Elastic Load Balancer）这样的托管负载均衡服务器，因为它支持自动扩展等有用功能，并且易于设置。

但是简单点，你可以自己部署一台机器并用 NGINX 设置负载均衡。 NGINX 反向代理的配置负载均衡来说非常简单。 下面是配置示例：

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

通过这种方式，负载均衡服务器通过唯一端口将您的应用程序暴露给外部。 如果您担心它出现单点故障，您可以部署多个指向相同服务器的负载均衡服务器。

为了在负载均衡服务器之间分配流量（每个都有自己的 IP 地址），您可以向主域添加多个 DNS“A” 记录，因此 DNS 解析将在您配置的多个负载均衡服务器之间分配流量，每次都解析为不同的 IP。

通过这种方式，您还可以在负载均衡服务器上实现冗余。

![](https://cdn-images-1.medium.com/max/800/1*iSVmpaGmwYzXWydLJnzM3A.png)

### 下一步

我们在这里看到了如何在不同级别扩展 Node.js 应用程序，以便从您的系统架构中获得尽可能高的性能，从单节点到多节点和多负载均衡，但要小心：如果您想使用在多进程环境中的应用程序，它必须准备好，否则您将遇到很多问题。

在下一篇文章中，我们将介绍使您的应用程序扩展就绪的一些注意事项。 你可以在[这里](https://medium.com/iquii/good-practices-for-high-performance-and-scalable-node-js-applications-part-2-3-2a68f875ce79)找到它。

* * *

_如果这篇文章对你有用，请给我点赞吧 !_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
