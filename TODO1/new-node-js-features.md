> * 原文地址：[New Node.js 12 features will see it disrupt AI, IoT and more surprising areas](https://tsh.io/blog/new-node-js-features/)
> * 原文作者：[Adam Polak](https://pl.linkedin.com/in/adam-polak-3267a99b)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/new-node-js-features.md](https://github.com/xitu/gold-miner/blob/master/TODO1/new-node-js-features.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[Alfxjx](https://github.com/Alfxjx), [cyz980908](https://github.com/cyz980908)

# Node.js 新特性将颠覆 AI、物联网等更多惊人领域

**新版 Node.js 的特性并非这个平台此前的那些等闲卖点。Node.js 主要以其[迅速和简洁](https://tsh.io/blog/node-js-tutorial-for-beginners/)而闻名。这也是为何那么多公司都愿意尝试 Node.js。然而，随着最新的 LTS（long-term support，长期支持）版本的发布，Node.js 将会带来很多让每位 Node.js 开发者欣喜若狂的新特性。为什么？因为 Node.js 12 新鲜出炉的特性及其带来的可能性简直让人惊艳！**

## 多线程趋向稳定！

在上一个 LTS 版本中，我们已经可以使用多线程了。诚然，这是一个试验性特性，需要一个名为 **--experimental-worker** 的标志（flag）才能生效。

在即将问世的这个 LTS 版本（Node 12）中，多线程仍是试验性的，但不再需要依赖 **--experimental-worker** 这种标志了。稳定版本正在向我们翩跹走来！

## 支持 ES 模块

我们需要认清这样的事实：ES 模块是目前 JavaScript 开发的必经之路。我们在前端应用中使用它。我们在桌面端乃至移动端应用中使用它。可是，在 Node.js 领域，我们还卡在 Common.js 模块停滞不前。

当然了，我们还有 Babel 和 TypeScript 可以用，但既然 Node.js 是一门后端技术，我们应当关心的应该只是服务器上安装的 Node 的版本是否更新。我们不必去在意五花八门的浏览器和 Node.js 对它们的支持情况，那么安装专门针对此目的而设计的工具（Babel、Webpack 等）有什么意义呢？

在 Node 10 版本中，我们总算是可以用 ES 模块小试牛刀了（目前的 LTS 版本对模块进行了试验性的实现），但还需要使用一个特定的文件扩展 —— **.mjs**（模块 JavaScript 代码文件）。

而在 Node 12 版本中，使用 ES 模块要稍微容易一些了。正如在 Web App 中一样，我们可以用一个专有的属性类型来定义某段代码是应该处理为 Common.js 还是 ES 模块。

要想把文件都作为模块使用，你只需在 package.json 中添加 **type** 属性并赋值为 **module**。

```json
{
  "type": "module"
}
```

从现在起，如果离 .js 文件**最近**的 package.json 文件带有 type 属性，那么这些 .js 文件将作为模块存在。再见了您呐，**mjs**（如果想用，还是可以继续用的）！

那么，要是我们想要用 Common.js 风格的模块，该怎么办呢？

只要离它最近的 package.json 不包含模块属性 type，那它就将被视为是遵循 Common.js 规范的代码。

另外，我们可以使用一种新型的扩展文件，叫做 **cjs** —— 代表一个 Common.js 文件。

每个 **mjs** 文件都是一个 ES 模块，而每个 **cjs** 都是一个 Common.js 文件。

如果你还没尝过这一勺鲜，那现在赶紧试试吧！

## JavaScript 和私有变量

说起 JavaScript，我们总需要绞尽脑汁防止类或函数中的数据外泄。

JavaScript 因其猴子补丁（[Monkey patching](https://segmentfault.com/n/1330000004293098)）而闻名，这意味着我们总是能通过某种门路拿到所有数据。

我们尝试过用闭包、Symbol 等等模拟私有变量。Node 12 版本装载了新版 V8 引擎，因此我们有机会使用一个炫酷特性 —— 类中的私有属性。

我想你们都还记得在 Node 中实现私有性的老方法：

```js
class MyClass {
  constructor() {
    this._x = 10
  }
  
  get x() {
    return this._x
  }
}
```

我们都清楚，这并非真正的私有 —— 我们总有办法拿到它，但大多数 IDE 都把它看作私有字段，多数 Node 开发者都知道这个惯例。现在，我们终于可以将这种方法抛之脑后了。

```js
class MyClass {
  #x = 10
  
  get x() {
    return this.#x
  }
}
```

能看到二者的差异吗？没错，我们用 **#** 告诉 Node，这个变量是私有变量，只能在类内部访问到。

如果试图直接访问它，你会看到报错信息，说这个变量不存在。

令人郁闷的是，有些 IDE 目前还不能识别这种私有变量。

## Flat 和 flatMap

在 Node 12 版本中，我们可以尽情使用 JavaScript 的新特性。

首先，我们可以使用数组的新方法 —— **flat** 和 **flatMap**。前者很像 **Lodash** 中的 **flattenDepth** 方法。

如果向方法中传入一个嵌套的数组，可以得到一个展开的数组。

```js
[10, [20, 30], [40, 50, [60, 70]]].flat() // => [10, 20, 30, 40, 50, [60, 70]]
[10, [20, 30], [40, 50, [60, 70]]].flat(2) // => [10, 20, 30, 40, 50, 60, 70]
```

如你所见，该方法还有个特别的参数 —— **depth**（深度）。这个参数决定了嵌套数组将以何种深度被降维。

第二个新特性 —— **flatMap**，其作用类似于首先执行 **map** 方法，再执行 **flat**。🙂

## 可选的 Catch 绑定

另一个新特性就是 **可选的 Catch 绑定**（Optional catch binding）。此前，我们总是需要为 **try - catch** 定义一个 error 变量。

```js
try {
  someMethod()
} catch(err) {
  // err 变量是必须的
}
```

而在 Node 12 版本中，我们虽不能完全摆脱 **try - catch** 语句，但 error 变量是可以省了。

```js
try {
  someMethod()
} catch {
  // err 变量是可选的
}
```

## Object.fromEntries

还有一个新特性就是 **Object.fromEntries** 方法。其主要用途是通过 **Map** 或者**键值对**数组创建一个对象。

```js
Object.fromEntries(new Map([['key', 'value'], ['otherKey', 'otherValue']]));
// { key: 'value', otherKey: 'otherValue' }


Object.fromEntries([['key', 'value'], ['otherKey', 'otherValue']]);
// { key: 'value', otherKey: 'otherValue' }
```

## V8 引擎的变化

我提到过，新版的 Node 装载了 V8 引擎。这使得 Node 不仅支持私有变量，还带有一些性能优化功能。

Await 将会像 Javascript 解析那样运行飞快。

而由于支持堆栈追踪，我们的应用将会加载得更快，Async 代码将更加易于调试。

另外，堆（Heap）的大小也正在改变。此前，其体量为 700MB（在 32 位系统中）或 1400MB（在 64 位系统中）。随着新版本带来的变化，堆大小将依可用内存大小而定！

## Node 12 版本来啦！

我不知道你期不期待，反正我是对 Node 12 拭目以待。距离官方将 12 版本更新为 LTS 版本还要几个月（发布日期定于 2019 年 10 月），但我们将要得到的新特性无疑是前途无量的。

只有几个月啦！

## 新版 Node.js 最大的看点就是多线程！

**每种编程语言都各有其利弊**，这是我们大家都毋庸置疑的。大多数流行的技术都在技术世界有各自的一席之地。Node.js 也不例外。
  
几年来，我们一直都说 [Node.js 适用于 API gateway](https://tsh.io/blog/serverless-in-node-js-beginners-guide/) 和实时仪表板（[如基于 Websocket](https://tsh.io/blog/php-websocket/)）。事实上，Node 的设计让我们不得不依赖微服务架构来弥补其本身的常见缺陷。

经过时间的检验，我们已知悉，由于其单线程设计理念，Node.js 不适合处理耗时长、严重占用 CPU 算力或阻塞操作的任务。这是事件循环机制本身的问题。
  
如果有一个复杂的同步操作阻塞了事件循环，那么在该操作完成前，别的什么也做不了。这就是我们频繁使用 Async 或将耗时间的逻辑移到单独的微服务中的原因。
  
随着 Node.js 10 版本中的新特性的面世，这种权宜之计将变得不再必要。**这个化腐朽为神奇的工具就是 Worker thread**。正因如此，Node.js 将能够在通常我们会使用其他语言的领域中大放异彩。

人工智能、机器学习或大数据都是很好的佐证，就目前来说，这些领域的研究需要大量的 CPU 算力，这让我们别无他选，只能搭建更多的服务或者换一个更适合的语言。但从新版 Node.js 开始，一切都不一样了。

## 支持多线程？怎么做到的？

这个新特性仍处在试验阶段 —— 还不能在生产环境中使用。但我们还是可以随意玩玩的。那从哪开始呢？

从 Node 12 开始及至更高版本中，我们不再需要使用特定的特性标志 **--experimental-worker**。 Worker 将是默认激活的！

**node index.js**

现在我们可以充分利用 **worker_threads** 模块。让我们先写一个简单的带有两个方法的 HTTP 服务器：

* GET /hello（返回带有“Hello World”信息的 JSON 对象），
* GET /compute（使用一个同步方法重复加载一个大 JSON 文件）。

```js
const express = require('express');
const fs = require('fs');

const app = express();

app.get('/hello', (req, res) => {
  res.json({
    message: 'Hello world!'
  })
});

app.get('/compute', (req, res) => {
  let json = {};
  for (let i=0;i<100;i++) {
    json = JSON.parse(fs.readFileSync('./big-file.json', 'utf8'));
  }

  json.data.sort((a, b) => a.index - b.index);

  res.json({
    message: 'done'
  })
});

app.listen(3000);
```

这段代码的运行结果很容易预测。当 **GET /compute** 和 **/hello** 被同时调用，我们必须等到 **compute** 调用完成才能从 **hello** 得到响应。事件循环被阻塞，直到文件加载完成。

让我们用多线程优化一下吧！

```js
const express = require('express');
const fs = require('fs');
const { Worker, isMainThread, parentPort, workerData } = require('worker_threads');

if (isMainThread) {
  console.log("Spawn http server");

  const app = express();

  app.get('/hello', (req, res) => {
    res.json({
      message: 'Hello world!'
    })
  });

  app.get('/compute', (req, res) => {

    const worker = new Worker(__filename, {workerData: null});
    worker.on('message', (msg) => {
      res.json({
        message: 'done'
      });
    })
    worker.on('error', console.error);
	  worker.on('exit', (code) => {
		if(code != 0)
          console.error(new Error(`Worker stopped with exit code ${code}`))
    });
  });

  app.listen(3000);
} else {
  let json = {};
  for (let i=0;i<100;i++) {
    json = JSON.parse(fs.readFileSync('./big-file.json', 'utf8'));
  }

  json.data.sort((a, b) => a.index - b.index);

  parentPort.postMessage({});
}
```

很明显，这种语法和我们所知道的 Node.js 集群扩展非常相似。但从这儿就开始变得有趣起来了。

你可以试着同时调用两个路径。注意到什么了吗？。没错，事件循环不再被阻塞，这样我们就能在文件加载期间调用 **/hello** 了。

现在，这就是我们都翘首以盼的东西！剩下的就是等待稳定版本的 API 出炉了。

## 渴望更多的 Node.js 新特性？这个 N-API 能够构建 C/C++ 模块！

Node.js 的原生运行速度正是我们青睐这个技术的原因之一。Worker threads 将会更进一步地提升 Node.js 的速度。但仅仅是这样就够了吗？

Node.js 是一种基于 C 语言的技术。当然了，我们把 JavaScript 当作一个主要编程语言来使用。但如果我们能用 C 语言做更加复杂的计算呢？

Node.js 10 版本给我们带来了 **N-API**。这是一个标准化的 API，适用于原生模块，让用 C/C++ 甚至是 Rust 语言构建模块成为可能。听起来很棒，对吧？

![C++ logo](https://tsh.io/wp-content/uploads/2018/12/c-logo-267x300.png)

用 C/C++ 构建 Node.js 原生模块变得更加容易。

下面是一个很简单的原生模块示例：

```cpp
#include <napi.h>
#include <math.h>

namespace helloworld {
    Napi::Value Method(const Napi::CallbackInfo& info) {
        Napi::Env env = info.Env();
        return Napi::String::New(env, "hello world");
    }

    Napi::Object Init(Napi::Env env, Napi::Object exports) {
        exports.Set(Napi::String::New(env, "hello"),
                    Napi::Function::New(env, Method));
        return exports;
    }

    NODE_API_MODULE(NODE_GYP_MODULE_NAME, Init)
}
```

如果你有 C++ 的基础，写一个自定义模块肯定不费吹灰之力。你只需记得在模块结尾将 C++ 的类型转化为 Node.js 类型即可。

接下来我们需要**绑定**（binding）：

```gyp
{
    "targets": [
        {
            "target_name": "helloworld",
            "sources": [ "hello-world.cpp"],
            "include_dirs": ["<!@(node -p \"require('node-addon-api').include\")"],
            "dependencies": ["<!(node -p \"require('node-addon-api').gyp\")"],
            "defines": [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ]
        }
    ]
}
```

这个简单的配置让我们能够构建 *.cpp 文件，以便于后续在 Node.js 应用中使用。

在用于 JavaScript 代码之前，我们必须进行构建并配置 package.json 文件来查找 gyp 文件（绑定文件）。

```json
{
  "name": "n-api-example",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "install": "node-gyp rebuild"
  },
  "gypfile": true,
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "node-addon-api": "^1.5.0",
    "node-gyp": "^3.8.0"
  }
}
```

当模块准备就绪，我们就可以用 **node-gyp rebuild** 命令进行构建并导入到 JavaScript 代码中。用法和其他流行的模块的用法一样！

```js
const addon = require('./build/Release/helloworld.node');

console.log(addon.hello());
```

N-API 以及 Worker threads 赋予我们功能强大的工具，帮我们构建高性能的应用。不用说 API 或仪表板 —— 即使是复杂的数据处理或者机器学习系统都将垂手可得。多么棒啊！

**另请参阅：**[Swoole – Is it Node in PHP? ](https://tsh.io/blog/swoole-is-it-node-in-php-or-am-i-wrong/)

## Node.js 会全面支持 HTTP/2 吗？当然了！何乐不为？

我们能够**计算得更快**。我们能进行**分布式计算**。那么**资源和页面服务**方面表现如何？

多年来，我们一直都卡在优秀却陈旧的 **http** 模块和 HTTP/1.1 上没有进步。随着服务器要提供的资源越来越多，我们越来越受制于加载所花费的时间。针对每个服务器或代理服务器，各个浏览器都有个并发持久连接数上限，特别是 HTTP/1.1 协议下。有了对 HTTP/2 的支持，我们就可以和这个问题吻别了。

那我们该从哪里下手呢？你是否还记得网上每个教程中都会出现的这个 Node.js 基础示例？对，就是这个：

```js
const http = require('http');

http.createServer(function (req, res) {
  res.write('Hello World!');
  res.end();
}).listen(3000);
```

在 Node.js 10 版本中，有一个崭新的 **http2** 模块可以让我们使用 HTTP/2.0！可算是迎来了 HTTP/2.0！

```js
const http = require('http2');
const fs = require('fs');

const options = {
  key: fs.readFileSync('example.key'),
  cert: fs.readFileSync('example.crt')
 };

http.createSecureServer(options, function (req, res) {
  res.write('Hello World!');
  res.end();
}).listen(3000);
```

![Http/2 协议 logo](https://tsh.io/wp-content/uploads/2018/12/https2-logo-300x300.png)

我们心心念念的就是 Node.js 10 版本中全面支持的 HTTP/2。

## 这些新特性会让 Node.js 的未来一片光明

Node.js 的新特性为我们的技术生态注入了新鲜血液。它们给 Node.js 插上翅膀，让它飞向新的天地。你想到过这个技术有一天会用于图像识别或者数据科学吗？我也从来没有想到过。

这个版本的 Node.js 还带来了更多的人们期盼已久的特性，例如对 **ES 模块**的支持（虽然仍出于试验阶段）；又如 **fs** 方法的更新，终于让我们能够脱离回调地狱、拥抱 Promise 天堂了。

想知道**更多的 Node.js 新特性**吗？请观看[这个短视频](https://youtu.be/FuWZeUfaI4s)。

在下面的折线图中，我们可以发现，经过历年的增长，Node.js 的人气在 2017 年早期达到了巅峰。这并不是增长开始缓慢的迹象，而是标志着这个技术的成熟。

![Node.js 历年人气折线图，2017 年达到峰值](https://tsh.io/wp-content/uploads/2018/12/node-popularity-over-the-years-chart-1024x425.png)

不论如何，我能够清晰地看出，所有这些新的改进和 Node.js 区块链应用（基于 truffle.js 框架）的走红，或可进一步推动 Node.js 的发展，让 Node.js 在新型的项目、角色和环境中梅开二度。

TSH（The Software House）Node.js 团队非常期待 2020 年的到来!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
