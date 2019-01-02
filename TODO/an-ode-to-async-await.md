> * 原文地址：[An Ode to Async-Await](https://hackernoon.com/an-ode-to-async-await-7da2dd3c2056#.pdydhv9a0)
* 原文作者：[Tal Kol](https://hackernoon.com/@talkol)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Xekri](https://github.com/xekri/)
* 校对者：[sqrthree](https://github.com/sqrthree)、[Tina92](https://github.com/Tina92)

# 为 Async-Await 唱一曲赞歌

![](https://cdn-images-1.medium.com/max/2000/1*xB_H7hyiX3-K7wbf4hH9Yw.jpeg)

随着 Node 7 将原生支持 async-await 特性（不需要转译器）的[**消息**](https://blog.risingstack.com/async-await-node-js-7-nightly/)爆出，我决定为如此精妙的语言构造谱写一曲赞歌。近几年来，async-await  成了我最爱的异步业务逻辑实现方式。这是更高层的抽象对我们的日常工作产生巨大改变的一个很好的例子 —— 代码更简单、更易读、包含更少的脚手架代码，仍保持着所有替代方法中最佳的效率。

---

#### 心急吃不了热豆腐

不是所有事都能立马完成。软件中的一些操作要花一段时间才能做完，这就给它们在顺序执行执行系统中的实现提出了提出了有趣的挑战。如果你需要通过网络访问服务器，你必须等它作出响应。CPU 被设计成一个接一个地运行指令码而不做等待，这段时间它们能做些什么呢？

这就是**异步**和**并发**的出发点。

#### 为什么不直接阻塞？

就假设我们可以暂停执行并阻塞，直到预期的响应抵达。通常这不是一个好主意，因为在这期间我们的程序无法对任何其他事情作出响应。设想我们正在实现一个前端应用，如果用户在我们阻塞时尝试交互怎么办？又比如我们在写后端服务，如果新的请求突然出现会怎么样？

我们从最朴素的方式开始，用最少的抽象以及底层的 API 来实现，比如不朽的 [select](http://man7.org/linux/man-pages/man2/select.2.html) 函数。如果我们不想阻塞，替代方法就是立刻返回 —— 也就是所谓**轮询**。可这也不大对劲， [忙碌等待](https://en.wikipedia.org/wiki/Busy_waiting)一直听上去就不像个好主意。

我们需要别的东西。我们需要抽象。

#### 为什么多线程很糟糕

操作系统为我们提供了这个问题的传统解决方案 —— [**多线程**](https://en.wikipedia.org/wiki/Thread_%28computing%29)。我们需要阻塞，但我们不想阻塞主执行上下文。因此，让我们创建可并行运行的附加执行上下文。但如果我们只有一个单核 CPU 呢？这就是抽象的来源 —— 操作系统将在我们的多个执行线程间进行复用和透明跳转。

事实上，这种方法相当受欢迎，互联网上的大多数网站内容是这样提供的。[Apache HTTP 服务器](https://httpd.apache.org/)，世界上最受欢迎的 Web 服务器，拥有超过 [40% 的市场份额](https://news.netcraft.com/archives/2016/07/19/july-2016-web-server-survey.html)，历来就依赖于[单独的线程](https://httpd.apache.org/docs/2.4/mod/worker.html)来处理每个并发客户端。

问题是依靠线程来解决并发性问题通常来说代价是很昂贵的，并且还在使用时引入了显著的额外复杂性。

让我们从复杂性开始。线程代码看上去更简单，因为它可以**同步**并阻塞，直到事情准备完毕。问题是，当一个线程停止运行而另一个线程启动时（上下文切换），我们通常无法控制。如果几个线程依赖一个共享的数据结构，我们需要加倍小心。如果一个线程开始更新数据并且在完成更新之前切换，另一个线程就可能从不确定的状态中恢复运行。这个问题引入了同步机制，比如[互斥锁](https://en.wikipedia.org/wiki/Lock_%28computer_science%29)和[抽象数据类型](https://en.wikipedia.org/wiki/Semaphore_%28programming%29)，这些就一点也不[优雅](http://blog.nahurst.com/thread-synchronization-issues-romance)了。

第二个问题是成本，或者更具体地说是线程引起的资源开销。**调度器**是线程运行时在操作系统中承担[分配资源工作](https://en.wikipedia.org/wiki/Scheduling_%28computing%29)的实体。你运行的线程越多，操作系统花在决定谁该运行而不是实际运行它们的时间越多。 更严重的是内存问题。每个线程都有一个运行时的调用[堆栈](https://en.wikipedia.org/wiki/Call_stack)，通常会为此保留数兆的内存；其中某些必须是[非分页内存](https://blogs.technet.microsoft.com/askperf/2007/03/07/memory-management-understanding-pool-resources/)（因此[虚拟内存](https://en.wikipedia.org/wiki/Virtual_memory)起不了作用）。当运行大量线程时，这些就成为了瓶颈。

这些不仅是理论问题，更以非常实际的方式影响着我们周围的世界。首先，这使得我们今天对互联网的可负载量的要求标准很低。很多服务器处理不了超过几千的并发连接，这导致像 [Reddit 的死亡拥抱](http://www.urbandictionary.com/define.php?term=reddit%20hug%20of%20death)（译注：就像 xxx 观光团到此一游让某网站瞬间崩溃）这样可笑的事情不断发生。这便是著名的 [C10K](http://www.kegel.com/c10k.html) 问题。为什么说它可笑？因为同样是这些服务器，只要架构稍稍不同（只要不依赖多线程），就能轻松处理成千上万的并发连接。


#### 多线程不好，然后呢？

并不是说多线程真的是不好的，我想说的是，我们不应该**仅仅**依赖于这一层并发抽象。我们必须开发出一种能让我们在**单线程系统**下拥有同样并发自由的抽象层。


这就是我爱 [Node](https://nodejs.org) 的原因。由于某种[不相干](http://stackoverflow.com/questions/39879/why-doesnt-javascript-support-multithreading)的限制，JavaScript 强迫我们在单线程下工作。一开始我们可能觉得这是 (JavaScript) 生态系统的一大缺陷，但实际上我们因祸得福了。如果不能奢享多线程，我们就必须开发出强大的非多线程并发机制。

如果我们有多个 CPU 或多个核心会怎么样？ 既然 Node 是单线程的，我们如何充分利用它们？ 在这种情况下，我们可以在同一台机器上运行多个 Node 实例。


#### 从一个现实中的例子开始

为了让讨论更接地气，让我们从一个设想要实现的真实情景开始。我们来构建一个类似于 [Pingdom](https://www.pingdom.com/) 的服务。给定一个由服务器 URL 组成的数组，我们要对这些服务器通过发出 HTTP 请求分别进行 3 次（每 10 秒一次）的 `ping` 操作。。

该服务将返回未能响应的服务器列表以及它们未正确响应的次数。不需要并行地 ping 不同的服务器，所以我们将按照列表一个个地操作。最后，当我们等待服务器响应时，我们不会阻塞主线程执行。

我们可以通过实现下面的 `pingServers` 函数来实现整个的服务：

```js
const servers = [
  'http://www.sevengramscaffe.com',
  'http://www.hernanparra.co',
  'http://www.thetimeandyou.com',
  'http://www.luchoycarmelo.com'
 ];
pingServers(servers, function (failedServers) {
  for (const url in failedServers) {
    console.log(`${url} failed ${failedServers[url]} times`);
  }
});
```

#### 多线程的伪代码实现

如果我们使用多线程，并且允许阻塞，伪代码的实现将会是这样：

```js
function pingServers(servers) {
  let failedServers = {};
  for (const url of servers) {
    let failures = 0;
    for (let i = 0 ; i < 3 ; i++) {
      const response = blockingHttpRequest(url);
      if (!response.ok) failures++;
      blockingSleep(10000);
    }
    if (failures > 0) failedServers[url] = failures;
  }
  return failedServers;
}
```

为了确保我们不会突然的依赖线程，在接下来的部分中，我们将使用**异步代码**实现 Node 上的服务。

#### 第一种实现 —— 回调

Node 依赖 JavaScript 的[事件循环](https://developer.mozilla.org/en/docs/Web/JavaScript/EventLoop)机制。由于它是单线程的，因此 API 调用通常不会阻塞执行。相反，不能立即完成的命令会在执行时发布一个事件；我们可以指定事件完成时的回调函数，并将我们其余的业务逻辑代码放在那里。

关于回调，最著名的抱怨就是**厄运金字塔**（译注：回调地狱），你的代码最终就看上去像一堆[乱七八糟](http://callbackhell.com/)的缩进。事实上，我对回调的最大意见有所不同，即它不能很好地处理**控制流**。

什么是控制流？它是你需要通过 `for` 循环和 `if` 语句实现的基本业务逻辑，比如这里的对每个服务器 ping 正好三次、当且仅当失败时将服务器写入结果中。试着用 [forEach](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach) 和 [setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout) 来实现吧，你会发现它根本不能像你想象的那样，通过回调轻易地完成。

于是我们要怎么做？我知道的更灵活的方法之一是通过构建一个[状态机](https://en.wikipedia.org/wiki/Finite-state_machine)来实现这些重要的控制流。

```js
import request from 'request';

export function pingServers(servers, onComplete) {
  let state = {
    servers,
    currentServer: 0,
    currentPingNum: 0,
    failedServers: {}
  };
  handleState(state, onComplete);
}

function handleState(state, onComplete) {
  if (state.currentServer >= state.servers.length) {
    onComplete(state.failedServers);
    return;
  }
  if (state.currentPingNum >= 3) {
    state.currentServer++;
    state.currentPingNum = 0;
    setImmediate(() => handleState(state, onComplete));
    return;
  }
  const url = state.servers[state.currentServer];
  request(url, (error, response) => {
    if (error || response.statusCode !== 200) {
      if (!state.failedServers[url]) state.failedServers[url] = 0;
      state.failedServers[url]++;
    }
    state.currentPingNum++;
    setTimeout(() => handleState(state, onComplete), 10000);
    return;
  });
}
```

这能奏效，不过不像我想象的那样直接。让我们探索使用一个专门为回调控制流而生的库（[async](https://github.com/caolan/async)）的实现：

```js

import request from 'request';
import asyncLib from 'async';

export function pingServers(servers, onComplete) {
  let failedServers = {};
  asyncLib.eachSeries(servers, (url, onNextUrl) => {
    let failures = 0;
    asyncLib.timesSeries(3, (n, onNextAttempt) => {
      request(url, (error, response) => {
        if (error || response.statusCode !== 200) failures++;
        setTimeout(onNextAttempt, 10000);
      });
    }, () => {
      if (failures > 0) failedServers[url] = failures;
      onNextUrl();
    });
  }, () => {
    onComplete(failedServers);
  });
}
```

现在代码更好、更短了。不过它直白到了一眼看过去就能理解的程度吗？我想我们能做得更棒。

#### 第二种实现 —— Promises

我们对第一种实现方式并不满意，改进的方法是使用更高的一层抽象。[Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) 保存尚未确定下来的「未来」值。它是一种占位符，被用来代替能立即返回的值，即使定义它的异步操作尚未完成。关于 promise，有趣的是它允许我们立即使用未来的值，并且保持住链式操作，最后它在未来发生后 (resolved) 就能被执行了。

我们让 `pingServers` 返回一个 promise，并像下面这样改变它的用法：
```js
const servers = [
  'http://www.sevengramscaffe.com',
  'http://www.hernanparra.co',
  'http://www.thetimeandyou.com',
  'http://www.luchoycarmelo.com'
 ];
pingServers(servers).then( function (failedServers) {
  for (const url in failedServers) {
    console.log(`${url} failed ${failedServers[url]} times`);
  }
});
```

大多数现代异步 API 都倾向于使用 promise 来进行回调。在我们的示例中，我们将使用基于 promise 的 [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch) 作为我们 HTTP 请求的基础。

我们仍然有控制流的问题。我们的简单逻辑该如何用 promise 来实现？我认为[函数式编程](https://en.wikipedia.org/wiki/Functional_programming)与 promise 结合得最好，在 JavaScript 中这通常意味着使用 [lodash](https://lodash.com/)。

如果我们想并行地 ping 服务器，事情会变得很简单。我们可以用诸如 [map](https://lodash.com/docs#map) 这样的操作将我们的 URL 数组转换为一组 promise，resolve 时返回每个 URL 的失败次数。因为我们需要按序地 ping 这些服务器，事情有点更棘手。由于每个 promise 都需要连接到上一个的 [then](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then) 中，我们就要在不同的循环中传递数据。这可以通过在像 [reduce](https://lodash.com/docs#reduce) 或 [transform](https://lodash.com/docs#transform) 这样的操作中使用**累加器（accumulator）**来实现：

```js
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export function pingServers(servers) {
  return _.reduce(servers, (failedServersAccumulator, url) => {
    return failedServersAccumulator.then((failedServers) => {
      return _.reduce(_.range(3), (failuresAccumulator) => {
        return failuresAccumulator.then(delay(10000)).then((failures) => {
          return fetch(url).then((response) => {
            return response.ok ? failures : failures + 1;
          });
        });
      }, Promise.resolve(0)).then((failures) => {
        if (failures > 0) failedServers[url] = failures;
        return failedServers;
      });
    });
  }, Promise.resolve({}));
}
```

嗯……我不得不说这也有点瞎眼。事实上，在写完代码的 5 分钟后，我就很难跟上这节奏了。为了解决这样的混乱，我想如果我们将相同的实现放在两个单独的小函数中会更有助于理解：
```js
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export function pingServers(servers) {
  return _.reduce(servers, (failedServersAccumulator, url) => {
    return failedServersAccumulator.then((failedServers) => {
      return pingOneServer(url).then((failures) => {
        if (failures > 0) failedServers[url] = failures;
        return failedServers;
      });
    });
  }, Promise.resolve({}));
}

function pingOneServer(url) {
  return _.reduce(_.range(3), (failuresAccumulator) => {
    return failuresAccumulator.then(delay(10000)).then((failures) => {
      return fetch(url).then((response) => {
        return response.ok ? failures : failures + 1;
      });
    });
  }, Promise.resolve(0));
}
```

现在更清楚一些了……但是累加器还是让整件事变得更复杂了。

#### 第三种实现 —— async-await 的极乐净土

拜托，我们只不过是要按顺序 ping 几台服务器而已。前面两种实现方式的确有效，但它们不大容易效仿。为什么？也许是因为对业务逻辑而言，人们觉得过程化思维来得更符合直觉一点。

第一次与 **async-await** 模式[相遇](http://stackoverflow.com/questions/18498942/why-shouldnt-all-functions-be-async-by-default)，是在做微软 Azure 上的一个业余项目时，囫囵吞枣地学了一些 [C# 和 .NET](https://msdn.microsoft.com/en-us/library/mt674882.aspx)。我当时就震惊了。两个世界（译注：异步和同步）在这完美结合了——直接的过程化思维，而不用忍受该死的阻塞。这些家伙做得真棒！

看到 [JavaScript](https://github.com/tc39/ecmascript-asyncawait), [Python](https://www.python.org/dev/peps/pep-0492/), [Scala](http://docs.scala-lang.org/sips/pending/async.html), [Swift](https://github.com/yannickl/AwaitKit) 等越来越多的语言中渗入了这种模式，我十分庆幸。 

毋须多言，对 async-await 的最好介绍就是直接看代码，让它为自己代言：

```js
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export async function pingServers(servers) {
  let failedServers = {};
  for (const url of servers) {
    let failures = 0;
    for (const i of _.range(3)) {
      const response = await fetch(url);
      if (!response.ok) failures++;
      await delay(10000);
    }
    if (failures > 0) failedServers[url] = failures;
  }
  return failedServers;
}
```

代码看完了，我们来谈谈。易写又易读，代码在做什么一眼就能看明白。并且他是完全**异步**的。哈哈。我说不出比 [Jake Archibald](https://jakearchibald.com/2014/es7-async-functions/) 更棒的赞美了：

> 了不起。真的太了不起了，我想要修改法律，这样我就能和它们结婚了。

注意到这种类似于同步的实现流程是如何完成之前只能用多线程和阻塞来完成的事的。没有阻塞它是如何完成的呢？幕后其实有很多魔术一样的实现。我不打算深入，只是提醒一下 `await` 关键词并不阻塞，它使得事件循环中的执行切出（yield）到其他事件。一旦等待的结果准备就绪，就能从这一断点继续执行了。

此外，调用这个版本的 `pingServers` 的方法和之前的 promise 版本相同。`async` 函数返回一个 `promise`，让它与现有代码更容易整合。

#### 总结


我们割断了对同步多线程的依赖，并见识了三种不同风格的**异步**代码。**回调**、**promise** 和 **async-await** 是为类似目的设计的不同抽象表示。哪一个更好？这是个人口味的问题。

很高兴能看到这三种口味的风格如何代表了历史上的三代 JavaScript。回调从早期一直统治到了 ES5 时代。Promises 在 ES6 时代非常突出，这时 JavaScript 也作为一个整体朝现代语法迈出了一大步。当然，我们赞扬的主题 —— async-await 走在了 ES7 的最前沿。这是一个令人惊叹的工具，快用上它吧！
