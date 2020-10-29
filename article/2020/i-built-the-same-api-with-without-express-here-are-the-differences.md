> * 原文地址：[I built the same API with & without Express. Here are the differences.](https://medium.com/javascript-in-plain-english/i-built-the-same-api-with-without-express-here-are-the-differences-83bbeb7ddad)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/i-built-the-same-api-with-without-express-here-are-the-differences.md](https://github.com/xitu/gold-miner/blob/master/article/2020/i-built-the-same-api-with-without-express-here-are-the-differences.md)
> * 译者：
> * 校对者：

# Express vs. http - API Benchmark

![Source: The author](https://cdn-images-1.medium.com/max/2794/1*UwjbdzSkB6KnS9SCM-wx3Q.png)

Express.js is now the standard in the Node.js world. If backend wants to develop applications for the web, the `npm install express` is pre-programmed and has become routine for most of us.

Admittedly, working with Express.js is much more pleasant — when I learned Node.js, I went straight into Express. Before this experiment, I probably never wrote anything without Express.js.

That’s why I had a great desire to put Express to the test — and test it in the form of a small API with a native approach.

So I built the same API twice, once with and once without Express. You can see the code below — first a little tip.

When I gave both APIs a test run, I noticed the following: **The response of the Express app is about 15% higher.**

This is of course problematic if you want to make a fair benchmark that measures the performance of the server. 
The different size is not due to the content of our response, because we send the same from both servers with `res.end()`, but to the headers.

Express.js comes with something in the header by default, which is only meant cosmetically — the `X-Powered-By` tag.

![X-Powered-By Express.js Tag](https://cdn-images-1.medium.com/max/2000/1*jVTQ2oCR5H5tufnSpffdGQ.png)

But we can simply deactivate it:`app.disable('x-powered-by')`

Then the two responses of the different servers should be exactly the same size. Let’s have a look at the code.

**The Express.js API:**

```js
const express = require("express")
const app = express()
app.disable('x-powered-by');
app.get("/api", (req, res) => {
  res.end(`Hey ${req.query.name} ${req.query.lastname}`)
})

app.listen(5000)
```

**The API without Express.js:**

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

Logically, both APIs do absolutely the same thing. They only respond to the **/api-route** and return the query parameters they receive.

## Benchmark and Results

As a benchmark tool, I decided to use Apache Bench. It is a simple command-line tool that is pre-installed on most systems (except for Windows).

```
ab -n 10000 -c 100 <url>
```

The **-n 10000** are the requests we send in total, **-c 100** stands for the connections we open at the same time — to really heat up the server.

Apache Bench then outputs some data as a result. The most important ones are listed below.

* The more **requests per second** the better, the same applies to the **transfer rate.**
* The less **time per request**, the better — the single request should be processed as fast as possible.

First I tested the native server, which is the one without Express.

**Benchmark 1:**

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

Now follows the Express.js API.

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

The pure Node.js implementation of the server, completely without a framework like Express.js is much faster.

At first sight, I couldn’t believe it, and again I made sure that I created the same conditions for both servers.
So I ran the benchmark many many times — but the result remains the same.

I then ran the same benchmark on my Raspberry Pi 3B — just to see if the differences there were as huge.

While the native server is almost twice as fast in the benchmark on my MacBook Pro, the native server on the Raspberry Pi is only about 25% faster.

However, there is a significant difference — Express does not come close to the performance of a simple Node.js server in any benchmark.

Personally, I had expected Express.js to be slower — but not that the difference is sometimes so noticeable. In the end, Express.js takes a detour and builds on the HTTP module of Node.js, which we used for the native server.

## Summing up

Should we learn from this to never use Express.js again? No, definitely not. Express.js is great — it makes developing backend applications very easy.

Performance at any price does not always make sense — after all, an Express app is also much easier to maintain and faster to develop, which can cost and save time on the other side.

The documentation and resources found on the Internet for Express alone are numerous and well explained.

Sending 10000 requests to a server in such a short time is also a rather unrealistic scenario — of course, the response time with Express is also higher, but under normal circumstances, this should not cause any problems for anyone.

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
