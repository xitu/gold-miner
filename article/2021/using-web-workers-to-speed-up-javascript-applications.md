> * 原文地址：[Using Web Workers to Speed-Up JavaScript Applications](https://blog.bitsrc.io/using-web-workers-to-speed-up-javascript-applications-5c567f209bdb)
> * 原文作者：[Bhagya](https://medium.com/@bhagya-16)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-web-workers-to-speed-up-javascript-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-web-workers-to-speed-up-javascript-applications.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)，[Kimhooo](https://github.com/Kimhooo)

# 使用 Web Workers 来加速 JavaScript 应用

![](https://cdn-images-1.medium.com/max/5760/1*dc6I4-IzvGDNryL2KpZX-Q.png)

Web Workers 是一种可以调用浏览器在后台执行大量且耗时任务的方法。它拥有开启新线程的能力，从而允许你优先处理某些任务，并可以解决如 JavaScript 这类单线程语言中的阻塞行为。

但是我们真的需要多线程的 JavaScript 吗？为了回答这个问题，让我们先来理解单线程 JavaScript 的局限性在哪。

## 单线程 JavaScript 的局限性

现代网络应用程序对浏览器提出了更高的要求。其中一些任务是需要长时间运行的，而这可能会导致用户界面冻结几秒钟。不管怎样，这对用户体验都是不好的。

为了让你更好的理解，我创建了一个示例应用程序，在浏览器中模拟它。其中 `Start_Animation` 按钮功能是将自行车向前移动，`Run_Calculation` 按钮的启动会消耗大量 CPU 资源来计算程序中的质数序列。

```JavaScript
const prime = (num) => {
  for (let i = 0; i <= num; i++) {
    let flag = 0;
  
    // 从 2 开始循环到用户输入的数字
    for (let j = 2; j < i; j++) {
        if (i % j == 0) {
            flag = 1;
            break;
        }
    }
  
    // 如果 number 大于 1 且不能被其他数字整除
    if (i > 1 && flag == 0) {
        console.log(i);
    }
  }
};

const Run_Calculation = () => {
  const num = 50000;
  console.log(prime(num));
  return prime(num);
};

const Start_Animation = () => {
  for (let i = 0; i < 3; i++) {
    const shuttleID = `shuttle${i + 1}`;
    let shuttle = document.getElementById(shuttleID);

    let position = 0;
    setInterval(() => {
      if (position > window.innerWidth / 1.2) {
        position = 0;
      } else {
        position++;
        shuttle.style.left = position + "px";
      }
    }, 1);
  }
};

```

运行上述代码，你将会看到如下的输出。如果仔细观察，你会发现当你调用 `Run_Calculation` 函数时，动画会冻结几秒钟。

![一个没有使用 Web Worker 的应用程序示例](https://cdn-images-1.medium.com/max/2280/1*ccudXc7quomjAc-4KQ2Wrg.gif)

既然你已经察觉到单线程 JavaScript 的局限性，让我们看看如何使用 Web Workers 来处理这个问题。

## 使用集成 Web Worker 的 JavaScript

让我们看看如何使用 Web Worker 优化上述代码。

### 第一步 — 分解函数功能

上述例子主要有两个函数：`Run_Calculation` 和 `Start_Animation`。因为在同一个线程中运行两个函数会导致其中一个冻结，所以我们需要将这两个函数分离，并在不同线程中运行它们。

因此，我创建来一个名为 worker.js 的新文件，并将质数生成的模块转移到那里。

> 为 Web Workers 创建一个单独的 Javascript 文件是必要的。因为主线程和 web worker 脚本必须完全独立，才能在不同的线程上操作。

如果不这样做，你将无法保证执行上下文的线程完全安全，并且它们可能在并行执行过程中导致意外的错误。

通常情况下，web worker 是在主线程中创建的。因此，你需要调用 [Worker()](https://developer.mozilla.org/en-US/docs/Web/API/Worker/Worker) 构造函数，来指定脚本在 worker 线程中的执行位置。

```JavaScript
let worker = new Worker("./worker.js");

const Run_Calculation = () => {
  const num = 50000;
  worker.postMessage(num);
};

worker.onmessage = event => {
  const num = event.data;
  console.log(num);
};

const Start_Animation = () => {
  for (let i = 0; i < 3; i++) {
    const bikeID = `bike${i + 1}`;
    let bike = document.getElementById(bikeID);

    let position = 0;
    setInterval(() => {
      if (position > window.innerWidth / 1.2) {
        position = 0;
      } else {
        position++;
        bike.style.left = position + "px";
      }
    }, 5);
  }
};
```

我相信你一定注意到，除了之前我们讨论的函数修改外，还有其他的一些修改。不用担心，我们将在接下来的步骤中解释它们。

### 第二步 — 实现两个文件之间通信

现在，我们有两个单独的脚本，我们需要实现一种在这两个脚本之间通信的方法。为此，你需要了解如何在主线程和 web worker 线程之间进行数据传递。

> Web Worker API 有一个 `postMessage()` 方法用来发送消息，还有一个 `onmessage `事件用来接收消息。

如果我们考虑这样一种场景。我们需要从 web worker 线程传递消息到主线程，我们可以在 worker 文件中使用 `postMessage()` 函数，并且使用 `worker.onmessage` 在主线程中监听来自 worker 的消息。

同理，这些相同的函数也可以用于将数据从主线程传递到 web worker 线程中。我们需要做的唯一区分是在主线程中调用 `worker.postMessage()` 方法，在 worker 线程中调用 `onmessage` 监听事件。

> **提示：** 重要的是要记住 `onmessage` 和 `postMessage()` 在主线程中使用而非 worker 线程时，需要挂在 worker 对象上，但如果不在 worker 线程中，这将会提高 worker 的效率，同时确保安全的**跨域通信**。

如你所见，我使用 `onmessage` 事件和 `postMessage()` 函数修改了两个文件，从而建立起主线程和 web worker 线程之间的通信。

```JavaScript
//worker.js 文件
self.onmessage = event => { 
  const num = event.data; 
  const result = prime(num); 
  self.postMessage(result); 
  self.close();
};

//main_scrpit.js
let worker = new Worker(“./worker.js”); 

const Run_Calculation = () => { 
  const num = 50000; 
  worker.postMessage(num);
}; 

worker.onmessage = event => { 
  const num = event.data;
};
```

> **备注：** 当消息在主线程和 worker 之间传递时，它将完全被移除而非共享。

现在，一切都设置好了，你可以在浏览器中重新加载程序，启动动画，并点击 `Run_Calculation` 按钮开始计算。你会看到质数计算结果仍然出现在浏览器控制台中，但这对图像的移动没有影响。因此，可以看到我们的应用程序表现有了**很大幅度的提高**。

![一个使用 Web Worker 应用程序示例](https://cdn-images-1.medium.com/max/2280/1*x0judL4Qm9bdKJ8RM4yeyQ.gif)

### 第三步 — 终止 web worker

作为实践，最好是在 worker 完成其功能后终止它，因为这会为其他应用程序释放资源。你可以使用 `terminate()` 函数或者 `close()` 函数来实现终止。

> 然而，必须知道何时在 terminate () 和 close() 方法之间进行选择，因为它们有不同的用处。

`close()` 函数只在 worker 文件中可见。因此，它只能在 worker 文件中终止 worker。另一方面，`terminate()` 方法是 worker 对象接口的一部分，你可以从主 JavaScript 文件中调用它。

```JavaScript
// 立即终止主 JS 文件
worker.terminate();

// 使用 worker 中代码停止 worker。
self.close();
```

你可以在我的 [GitHub](https://github.com/bhagya327/Demo-Application) 账号中找到完整示例。

## 最后的思考

Web Workers 是一种通过启动新线程来加速应用程序的简单方法。在我给的示例中，使用了一个计算量很大任务来展示使用 Web Workers 的和不使用它之间的差异点。

除此之外，还有很多 Web Workers 用例，比如缓存数据和网页、后台 I/O 操作、分析视频或者音频数据、执行周期任务等。

更重要的是，你也不用把自己局限于使用单个的 web worker。你可以启动更多的线程，并在其中并行运行任务。但是我一直建议，你不应该在没有任何需要的情况下创建 Web Workers ，这会产生额外的线程。

在这篇文章中，我谈到来我自己认为你需要了解的关于 Web Workers 多线程的最重要的几点。

一旦你理解了 Web Workers 的工作原理，就很容易确定是否在你的项目中使用它。因此，我邀请你体验一下 Web Workers 的实际用法，并在评论区分享你的想法。 

感谢阅读！！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
