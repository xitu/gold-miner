> * 原文地址：[How To Do Multithreading With Node.js](https://medium.com/javascript-in-plain-english/how-to-do-multithreading-with-node-js-207aabdaddfb)
> * 原文作者：[Krishnanunny H](https://medium.com/@krishnanunny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-do-multithreading-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-do-multithreading-with-node-js.md)
> * 译者：
> * 校对者：

# How To Do Multithreading With Node.js

Node.js is capable of doing multithreading with the release of version 13 onwards.

![This cover has been designed using resources from [Freepik.com](https://www.freepik.com/)](https://cdn-images-1.medium.com/max/2000/1*XX-DmkhMjdr3AyDpvlk0Aw.png)

## Introduction

Most JavaScript developers believe Node.js is single-threaded, which handles multiple operations by non-blocking asynchronous callback processes and doesn’t support multithreading, but it is not valid anymore. On Node.js version 13, a new module called worker threads is there to implement multithreading.

Even though non-blocking asynchronous callback could handle multiple operations very efficiently, functions requiring massive CPU utilization like encryption block other processes, Node.js’ performance is weak for such a scenario. The worker thread module overcomes that weakness by isolating the function, which takes high CPU usage into a separate thread and processing it in the background and won’t block any other process.

## Implementation

Typically in Node.js, the main thread handle all the operations. With the help of an example, here demonstrated how to create another thread for processing an operation. This example has two API, the first API will process the function on the main thread, and the other API will process the function on a separate thread. The below code snippet shows the basic structure of the example.

```
/*
*  File Name: index.js
*  Description: This is the main thread
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

As a first step, we add a function on the main thread, and as a next step, we add the same function on another thread. The function used will be getSum, which will return the cumulative sum up to the limit value given as an argument. After adding the getSum function to the main thread, the code snippet becomes like below.

```
/*
*  File Name: index.js
*  Description: This is the main thread
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

The next step is to add the same function on another thread, and it could do as follow.

* Importing the worker thread module to the main thread.

```
const { Worker } = require("worker_threads");
```

* Create another file, seprateThread.js, for defining the function getSum to run on another thread.
* Create an instance of the worker thread module and provide the pathname to the newly created file.

```
const seprateThread = new Worker(__dirname + "/seprateThread.js");
```

* Starting a new thread

```
seprateThread.on("message", (result) => {
res.send(`Processed function getSum on seprate thread:  ${result}`);
});
```

* Sending data to the new thread.

```
seprateThread.postMessage(1000);
```

Finally, the main thread will be like the below code snippet.

```
/*
*  File Name: index.js
*  Description: This is the main thread
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

Thus a new thread is created from the main thread. Let us put the getSum function on the newly created thread, so defines that function on the file seprateThread.js. After defining, the new thread is supposed to send the result back to the main thread; check the below code for reference.

```
/*
*  File Name: seprateThread.js
*  Description: This is another thread
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

In the above example, you could see `seprateThread.postMessage()` function used by the main thread to communicate with the child thread. Likewise, `parentPort.postMessage()` used by the child thread to communicate with the main thread. The below figure illustrates the communication between the child and the main thread.

![](https://cdn-images-1.medium.com/max/2000/1*ydQqBzkh6FO4WUwHtGF7zA.png)

## Features

* Each thread has separate v8 engines.
* Child threads could communicate with each other.
* Child threads could share the same memory.
* An initial value could be passed as an option while starting the new thread.

## Conclusion

This article’s motive is to give a brief idea about the basic implementation of multithreading on Node.js. Multithreading in Node.js is a little bit different from traditional multithreading. It is advised that for massive I/O operation main thread could do much better than worker threads. To understand more about multithreading, refer to the Node.js official [document ](https://nodejs.org/api/worker_threads.html)and the source code of the example available here.
[**krishheii/Multithreading**
**Multithreading using Node.js. Contribute to krishheii/Multithreading development by creating an account on GitHub.**github.com](https://github.com/krishheii/Multithreading)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
