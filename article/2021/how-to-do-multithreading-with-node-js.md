> * 原文地址：[How To Do Multithreading With Node.js](https://medium.com/javascript-in-plain-english/how-to-do-multithreading-with-node-js-207aabdaddfb)
> * 原文作者：[Krishnanunny H](https://medium.com/@krishnanunny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-do-multithreading-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-do-multithreading-with-node-js.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[regon-cao](https://github.com/regon-cao)、[flashhu](https://github.com/flashhu)

# 如何使用 Node.js 执行多线程

从 Node.js 的第 13 版开始，它就能够执行多线程。

![This cover has been designed using resources from [Freepik.com](https://www.freepik.com/)](https://cdn-images-1.medium.com/max/2000/1*XX-DmkhMjdr3AyDpvlk0Aw.png)

## 简介

大部分 JavaScript 开发人员都认为 Node.js 是单线程的，通过非阻塞异步回调进程处理多个任务，不支持多线程，但现在已经不成立了。在 Node.js 第 13 版中，有一个名为工作线程（worker threads）的新模块可用于实现多线程。

尽管非阻塞异步回调可以非常有效地处理多个任务，但是对于需要大量 CPU 使用率的功能（例如加密操作）会阻止其他进程执行，在这种情况下，Node.js 的性能很弱。工作线程模块通过隔离该功能克服了这个不足，它将 CPU 使用率很高的任务放在一个独立的线程中并由后台处理，而不会阻塞其他进程。

## 实现

通常在 Node.js 中，主线程处理所有操作。借助以下示例来说明如何创建另一个线程来处理操作。示例中有两个 API，第一个 API 将在主线程上处理函数，另一个 API 将在单独的线程上处理函数。以下代码段显示了示例的基本结构。

```js
/*
*  文件名：index.js
*  描述：这是一个主线程
*/

const express = require("express");

const app = express();
const port = 3000;

app.get("/", (req, res) => {
res.send("Process function on main thread.");
});

app.get("/seprate-thread", (req, res) => {
res.send("Process function on seprate thread.");
});

app.listen(port, () => {
console.log(`Example app listening at http://localhost:${port}`);
});
```

首先，在主线程上添加一个函数。接下来，在另一个线程上添加相同的函数。使用的函数是 getSum，它将返回作为给定参数的极限值累加和。将 getSum 函数添加到主线程后，代码片段如下所示。

```js
/*
*  文件名：index.js
*  描述：这是一个主线程
*/

const express = require("express");

const app = express();
const port = 3000;

const getSum = (limit) => {
let sum = 0;
for (let i = 0; i < limit; i++) {
     sum += i;
}
return sum;
};

app.get("/", (req, res) => {

const result = getSum(1000);
res.send(`Processed function getSum on main thread and result: ${result}`);

});

app.get("/seprate-thread", (req, res) => {
res.send("Process function getSum on seprate thread.");
});

app.listen(port, () => {
console.log(`Example app listening at http://localhost:${port}`);
});
```

下一步是在另一个线程上添加相同的函数，它可以执行以下操作。

* 将工作线程模块导入到主线程。

```js
const { Worker } = require("worker_threads");
```

* 创建另一个文件 seprateThread.js，用于定义在另一个线程上运行的 getSum 函数。
* 创建工作线程模块的实例，并提供新创建文件的路径名。

```js
const seprateThread = new Worker(__dirname + "/seprateThread.js");
```

* 启动新线程。

```js
seprateThread.on("message", (result) => {
res.send(`Processed function getSum on seprate thread:  ${result}`);
});
```

* 将数据发送到新线程。

```js
seprateThread.postMessage(1000);
```

最后，主线程将类似于下面的代码片段。

```js
/*
*  文件名：index.js
*  描述：这是一个主线程
*/

const express = require("express");
const { Worker } = require("worker_threads");

const app = express();
const port = 3000;

const getSum = (limit) => {
let sum = 0;
for (let i = 0; i < limit; i++) {
     sum += i;
}
return sum;
};

app.get("/", (req, res) => {

const result = getSum(1000);
res.send(`Processed function getSum on main thread and result: ${result}`);

});

app.get("/seprate-thread", (req, res) => {

const seprateThread = new Worker(__dirname + "/seprateThread.js");
seprateThread.on("message", (result) => {
res.send(`Processed function getSum on seprate thread: ${result}`);
});
seprateThread.postMessage(1000);

});

app.listen(port, () => {
console.log(`Example app listening at http://localhost:${port}`);
});
```

从主线程创建新线程，将 getSum 函数放在新创建的线程上，以便在 seprateThread.js 文件上定义该函数。定义完成后，新线程应该将结果发回主线程。可以参考下面的代码。

```js
/*
*  文件名：seprateThread.js
*  描述：这是一个另一个线程
*/

const { parentPort } = require("worker_threads");

const getSum = (limit) => {
  let sum = 0;
  for (let i = 0; i < limit; i++) {
    sum += i;
  }
  return sum;
};

parentPort.on("message", (limit) => {
 const result = getSum(limit);
 parentPort.postMessage(result);
});
```

在上面的示例中，可以看到主线程使用 `seprateThread.postMessage()` 函数与子线程通信。同样，子线程使用 `parentPort.postMessage()` 与主线程通信。下图说明了子线程和主线程之间的通信过程。

![](https://cdn-images-1.medium.com/max/2000/1*ydQqBzkh6FO4WUwHtGF7zA.png)

## 特点

* 每个线程都有单独的 V8 引擎。
* 子线程可以相互通信。
* 子线程可以共享相同的内存。
* 初始值可以在启动新线程时作为选项传递。

## 结论

本文的目的是简要介绍 Node.js 上多线程的基本实现。Node.js 中的多线程与传统的多线程略有不同。对于大规模 I/O 操作，主线程可以比工作线程做得更好。要了解更多关于多线程的内容，请参考 Node.js 官方[文档](https://nodejs.org/api/worker_threads.html)和此处提供的示例源代码：

[**github.com/krishheii/Multithreading**](https://github.com/krishheii/Multithreading)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
