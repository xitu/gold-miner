> * 原文地址：[I built the same API with & without Express. Here are the differences.](https://medium.com/javascript-in-plain-english/i-built-the-same-api-with-without-express-here-are-the-differences-83bbeb7ddad)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/i-built-the-same-api-with-without-express-here-are-the-differences.md](https://github.com/xitu/gold-miner/blob/master/article/2020/i-built-the-same-api-with-without-express-here-are-the-differences.md)
> * 译者：[lhd951220](https://github.com/lhd951220)、[finalwhy](ttps://github.com/finalwhy)
> * 校对者：[Cygra](https://github.com/Cygra)、[jaredliw](https://github/jaredliw)

# Express vs. http - API 基准测试

![Source: The author](https://cdn-images-1.medium.com/max/2794/1*UwjbdzSkB6KnS9SCM-wx3Q.png)

Express.js 如今是 Node.js 世界中的标杆。如果后端开发工程师想要开发 web 相关的应用，执行 `npm install express` 来初始化项目已经成为大多数人们的日常。

诚然，使用 Express.js 通常都会更愉快，当我开始学习 Node.js 的时候是从 Express.js 入手。（甚至于）在做这个实验之前，我写的任何东西都离不开 Express.js。

这也是为什么我会非常渴望对 Express 进行测试。本次的测试方式为在本地环境下访问一个简单的 API。

我创建了两个相同的 API，一个使用 Express，一个不使用，你可以在下面看到相关代码。但在此之前，我有一个小小的提示。

当我给这两个 APIs 运行测试，我注意到以下情况：**Express 应用程序的响应（体积）要高出约 15%。**

如果你想得到一个公平的基准以测试服务的性能，这肯定是有问题的。
不同的大小并不是响应体内容引起的，因为我们在两份服务器代码中使用 `res.end()` 发送了相同的内容。造成响应体积不同的原因来自于响应头。

Express.js 默认携带了一个仅仅用于“装饰”的请求头 —— `X-Powered-By` 标签。

![Express.js 的 `X-Powered-By` 标签](https://cdn-images-1.medium.com/max/2000/1*jVTQ2oCR5H5tufnSpffdGQ.png)

但我们可以通过 `app.disable('x-powered-by')` 来禁用它。

现在，这两个不同服务器的响应大小应该是完全相同的。让我们来看一下代码：

**基于 Express.js 实现的 API:**

```js
const express = require("express")
const app = express()
app.disable('x-powered-by');
app.get("/api", (req, res) => {
  res.end(`Hey ${req.query.name} ${req.query.lastname}`)
})

app.listen(5000)
```

**不基于 Express.js 实现的 API:**

```js
const http = require("http")
const url = require("url")

const app = http.createServer((req, res) => {
    const parsedURL = url.parse(req.url, true)
    if(parsedURL.pathname === "/api") {
        res.end(`Hey ${parsedURL.query.name} ${parsedURL.query.lastname}`)
    }
})


app.listen(5000)
```

在逻辑上，两个 API 做了绝对相同的事情。他们仅仅对 **`/api-route`** 进行响应，并且返回它们接收到的查询参数。

## 基准测试和结果

在基准测试上，我决定使用 Apache Bench。它是一个预安装在大多数系统（除了 Windows）上的简单命令行工具。

```
ab -n 10000 -c 100 <url>
```

**-n 10000** 是我们发送的总请求数，**-c 100** 表示我们同时打开的连接数，如此设置是为了让服务器程序发挥所有性能。

Apache Bench 会输出一些数据作为结果。最重要的数据如下所示：

*  **requests per second（每秒请求数）** 越多越好，**transfer rate（传输率）** 也是如此。
*  **time per request（单个请求花费时间）** 越少越好，单个请求应该尽可能快的被处理。

首先，我对原生 Node 模块实现的服务器程序进行测试：

**基准测试 1：**

```
Requests per second: 10882.52 [#/sec] (mean)
Time per request: 9.189 [ms] (mean)
Time per request: 0.092 [ms] (mean, across all concurrent requests)
Transfer rate: 988.35 [Kbytes/sec] received
```

**Benchmark 2:**

```
Requests per second: 10876.13 [#/sec] (mean)
Time per request: 9.194 [ms] (mean)
Time per request: 0.092 [ms] (mean, across all concurrent requests)
Transfer rate: 987.77 [Kbytes/sec] received
```

**Benchmark 3:**

```
Requests per second: 10928.75 [#/sec] (mean)
Time per request: 9.150 [ms] (mean)
Time per request: 0.092 [ms] (mean, across all concurrent requests)
Transfer rate: 992.55 [Kbytes/sec] received
```

接下来是 Express.js API 的结果。

**Benchmark 1:**

```
Requests per second: 4998.91 [#/sec] (mean)
Time per request: 20.004 [ms] (mean)
Time per request: 0.200 [ms] (mean, across all concurrent requests)
Transfer rate: 454.00 [Kbytes/sec] received
```

**Benchmark 2:**

```
Requests per second: 5076.82 [#/sec] (mean)
Time per request: 19.697 [ms] (mean)
Time per request: 0.197 [ms] (mean, across all concurrent requests)
Transfer rate: 461.08 [Kbytes/sec] received
```

**Benchmark 3:**

```
Requests per second: 5249.16 [#/sec] (mean)
Time per request: 19.051 [ms] (mean)
Time per request: 0.191 [ms] (mean, across all concurrent requests)
Transfer rate: 476.73 [Kbytes/sec] received
```

纯 Node.js 实现、不使用框架的服务器速度要快得多。

一开始，我并不相信这个结果。之后，在确定两个服务器条件相同的情况下，我又执行了很多次基准测试，但是得到的结果都是相同的。

然后，我在我的 Raspberry Pi 3B 上运行相同的基准测试，只是为了看看两者之间的差异是否同样如此巨大。

原生模块实现的服务器在我的 MacBook Pro 上运行的基准测试快了近 2 倍，而在 Raspberry Pi 上仅仅快了 25%。

但是，两者之间存在显著差异 — Express 在任何基准测试中都无法接近简单 Node.js 服务器的性能。

在我看来，我预期 Express.js 会更慢，但差异并非如此明显。最后，Express.js 走了点弯路，它使用 Node.js 的 HTTP 模块构建，该模块在我们的原生服务器上也有使用。

## 结论

学习了这篇文章之后，我们应该不再使用 Express.js 了吗？不，当然不。Express.js 很好，它能让开发后端应用变得非常简单。

不惜一切代价来换取性能并非总是有意义的。毕竟，Express 应用更易于维护和开发，这可以节省成本和时间。

网络上有关 Express 的文档和资源非常多，并且都解释得很好。

在如此短的时间发送 10000 个请求给服务器是一个不切实际的应用场景 — 当然，Express 的响应时间确实更高，但在正常情况下，这不会造成任何问题。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
