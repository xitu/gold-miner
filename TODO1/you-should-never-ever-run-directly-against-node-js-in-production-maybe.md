> * 原文地址：[You should never ever run directly against Node.js in production. Maybe.](https://medium.freecodecamp.org/you-should-never-ever-run-directly-against-node-js-in-production-maybe-7fdfaed51ec6)
> * 原文作者：[Burke Holland](https://medium.com/@burkeholland)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/you-should-never-ever-run-directly-against-node-js-in-production-maybe.md](https://github.com/xitu/gold-miner/blob/master/TODO1/you-should-never-ever-run-directly-against-node-js-in-production-maybe.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[HearFishle](https://github.com/HearFishle), [JasonLinkinBright](https://github.com/JasonLinkinBright)

# 如果可以，永远不要在生产中直接运行 Node.js

![](https://cdn-images-1.medium.com/max/5120/1*Lh8JaRfiqPj9bTrd8a3xgQ.png)

有时候我也在想我是否真的知道很多东西。

就在几周前，我正在和一个朋友谈话，他不经意间提到，“你永远都不会在生产中直接使用 Node 来运行程序”。我强烈点头，表示我**也**不会在生产中直接运行 Node，原因可能每个人都知道。但是我并不知道，我应该知道原因吗？我还能继续写代码吗？

如果让我绘制一个维恩图来表示我所知道的和其他人都知道的东西，它看起来就像这样：

![](https://cdn-images-1.medium.com/max/2204/1*ThJbM2JMjrnTuHczo0tLqw.png)

顺便一提，我年纪越大，那个小点就会越小。

[Alicia Liu](https://medium.com/counter-intuition/overcoming-impostor-syndrome-bdae04e46ec5) 创建了一个更好的图表，改变了我的生活。她说这种情况更像是...

![](https://cdn-images-1.medium.com/max/2000/1*N7vv39ri9yC0l6krsSFlQA.png)

我非常喜欢这个图表，因为我希望它是真实的。我不想把余生都过得像一个微不足道的萎缩蓝点一样。

太戏剧化了。怪潘多拉。当我写这篇文章的时候，我无法控制接下来要发生什么。而 [Dashboard Confessional](https://www.youtube.com/watch?v=ixG3DgrPC3c) 真是一副毒药。

好吧，假设 Alicia 的图表是真的，我想与大家分享一下我**现在**对在生产中运行 Node 应用程序的一些认识。也许在这个问题上我们的相对维恩图没有重叠。

首先，让我们弄清楚“永远不要在生产中直接通过 Node 运行程序”的说法。

### 永远不要直接运行生产中的 Node

这个说法可能对，也可能不对。我们一起来探讨下这个说法是怎么得到的。首先，让我们看看为什么不对。

假设我们有一个简单的 Express 服务器。我能想到的最简单的 Express 服务器如下：

```JavaScript
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

// 查看 http://localhost:3000
app.get("/", function(req, res) {
  res.send("Again I Go Unnoticed");
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
```

通过定义在 `package.json` 中的启动脚本来运行它。  

```
"scripts": {
  "start": "node index.js",
  "test": "pfffft"
}
```

![](https://cdn-images-1.medium.com/max/2784/1*VceC98Qk5zKqzBmiu1szDQ.png)

这里会有两个问题。第一个是开发问题，还有一个是生产问题。

开发问题指的是当我们修改代码的时候，我们必须停止并且再次启动应用程序来得到我们更改后的效果。

我们通常会使用某种 Node 进程管理器，例如 `supervisor` 或 `nodemon` 来解决这个问题。这些包会监听我们的项目，并会在我们提交更改时重启服务器。我通常都会这样做。

```
"scripts": {
  "dev": "npx supervisor index.js",
  "start": "node index.js"
}
```

然后运行 `npm run dev`。请注意，我在这里运行 `npx supervisor`，它允许我们在未安装 `supervisor` 包的情况下使用它。

我们的另外一个问题是我们仍然直接在针对 Node 运行，我们已经说过这很糟糕，现在我们将要找出原因。

我要在这里添加另一个路由，尝试从不存在的磁盘读取文件。这是一个很容易在任何实际应用程序中出现的错误。

```JavaScript
const express = require("express");
const app = express();
const fs = require("fs");
const port = process.env.PORT || 3000;

// 查看 http://localhost:3000
app.get("/", function(req, res) {
  res.send("Again I Go Unnoticed");
});

app.get("/read", function(req, res) {
  // 这个路由不存在
  fs.createReadStream("my-self-esteem.txt");
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
```

如果我们直接针对 Node 运行 `npm start` 并且导航到 `read` 端点，页面会报错，因为这个文件不存在。

![](https://cdn-images-1.medium.com/max/2784/1*pAUoJV-LRJwxs7MRegnuoA.png)

这没什么大不了的，对吧？这只是一个错误，碰巧发生了。

不。这很重要。如果你返回终端，你会看到应用程序已经完全关闭了。

![](https://cdn-images-1.medium.com/max/2560/1*69LuEt53W2isIXP34vUlYA.png)

这意味着，如果你回到浏览器并尝试访问站点的根 URL，你会得到相同的错误页面。一个方法中的错误导致应用中**所有的路由**都失效了。

这是很糟糕的。这就是人们说 **“永远都不要直接在生产中运行 Node”**

好。如果我们无法在生产中直接运行 Node，那么在生产中运行 Node 的正确方法是什么？

### 生产中 Node 的选项

我们有几个选择。

其中之一就是在生产中简单地使用类似 `supervisor` 或 `nodemon` 的工具，就像我们在开发中使用它们一样。这可行，但这些工具有点轻量级。更好的选择是 pm2。

### pm2 支援

pm2 是一个 Node 进程管理器，有很多有用的功能。就像其他的 “JavaScript” 库一样，你可以使用 `npm` 全局安装它 —— 或者你也可以再次使用 `npx`。这里不再赘述。

有很多使用 pm2 运行程序的方法。最简单的就是在入口文件调用 `pm2 start`。

```
"scripts": {
  "start": "pm2 start index.js",
  "dev": "npx supervisor index.js"
},
```

终端会显示这些内容：

![](https://cdn-images-1.medium.com/max/2560/1*uvsnmQahRBHtnh0X7tt_xA.png)

这是我们在 pm2 监控的后台运行的进程。如果你访问 `read` 端点把程序搞崩了，pm2 将自动重新启动它。你在终端不会看到任何内容，因为它在后台运行。如果你想看到 pm2 正在做什么，你可以运行 `pm2 log 0`。这个 `0` 是我们想要查看日志的进程的 ID。

![](https://cdn-images-1.medium.com/max/2560/1*AbR1eyySpr2IllYtA4wE-Q.png)

接下来！你可以看到，pm2 会在应用程序由于未处理的错误而停机时重新启动应用程序。

我们还可以提取开发命令，并为我们准备PM2监视文件，在任何更改发生时重新启动程序。

```
"scripts": {
  "start": "pm2 start index.js --watch",
  "dev": "npx supervisor index.js"
},
```

请注意，因为 pm2 在后台运行，所以你不能只是通过 `ctrl+c` 来终止正在运行的 pm2 进程。你必须通过传递进程的 ID 或者名称来停止进程。

`pm2 stop 0`

`pm2 stop index`

另请注意，pm2 会保存对进程的引用，以便你可以重新启动它。

![](https://cdn-images-1.medium.com/max/2560/1*Z4yLru6TmwUVQv84DkZDAQ.png)

如果要删除该进程引用，则需要运行 `pm2 delete`。你可以使用一个命令 `delete` 来停止和删除进程。

`pm2 delete index`

我们也可以使用 pm2 来运行我们应用程序的多个进程。pm2 会自动平衡这些实例的负载。

### 使用 pm2 fork 模式的多个进程

pm2 有很多配置选项，它们包含在一个 “ecosystem” 文件中。可以通过运行 `pm2 init`来创建一个。你会得到以下的内容：

```JavaScript
module.exports = {
  apps: [
    {
      name: "Express App",
      script: "index.js",
      instances: 4,
      autorestart: true,
      watch: true,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "development"
      },
      env_production: {
        NODE_ENV: "production"
      }
    }
  ]
};
```

本文不会去讲关于“部署”的内容，因为我对“部署”也不太了解。

“应用程序”部分定义了希望 pm2 运行和监视的应用程序。你可以运行不止一个应用程序。许多这些配置设置可能是不言而喻的。这里我要关注的是**实例**设置。

pm2 可以运行你的应用程序的多个实例。你可以传入多个你想运行的实例，pm2 都可以启动它们。因此，如果我们想运行 4 个实例，我们可以创建以下配置文件。

```JavaScript
module.exports = {
  apps: [
    {
      name: "Express App",
      script: "index.js",
      instances: 4,
      autorestart: true,
      watch: true,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "development"
      },
      env_production: {
        NODE_ENV: "production"
      }
    }
  ]
};
```

然后我们使用 `pm2 start` 来运行它。

![](https://cdn-images-1.medium.com/max/2560/1*_rYp7NMQTCMmOfBV0w0RTw.png)

pm2 现在会以“集群”模式运行。这些进程中的每一个都会在我的计算机上的不同 CPU 上运行，具体取决于我拥有的内核数量。如果我们想在不知道拥有多个内核的情况下为每个内核运行一个进程，我们就可以将 `max` 参数传递给 `instances` 参数来进行配置。

```
{
   ...
   instances: "max",
   ...
}
```

让我们看看我的这台机器上有几个内核。

![](https://cdn-images-1.medium.com/max/2560/1*nhjuG0xFsMgkYB382_xfyw.png)

8个内核！哇。我要在我的微软发行的机器上安装 Subnautica。别告诉他们我说过。 

在分隔的 CPU 上运行进程的好处是，即使有一个进程运行异常，占用了 100% 的 CPU，其他进程依然可以保持运行。pm2 将根据需要将 CPU 上的进程加倍。

你可以使用 pm2 进行更多操作，包括监视和以其他方式处理那些讨厌的 [environment variables](https://medium.freecodecamp.org/)。

另外一个注意事项：如果由于某种原因，你希望 pm2 运行 `npm start` 指令。你可以通过运行 npm 作为进程并传递 `-- start`。“start” 之前的空格在这里非常重要。

```
pm2 start npm -- start
```

在 [Azure AppService](https://docs.microsoft.com/en-us/azure/app-service/?WT.mc_id=medium-blog-buhollan) 中，默认在后台包含 pm2。如果要在 Azure 中使用 pm2，则无需将其包含在 `package.json` 文件中。你可以添加一个 ecosystem 文件，然后就可以使用了。

![](https://cdn-images-1.medium.com/max/2560/1*TYOm2q57lXad3te35tGwqg.png)

好！既然我们已经了解了关于 pm2 的所有内容，那么让我们谈谈为什么你可能不想使用它，而且它可能确实可以直接针对 Node 运行。

### 在生产中直接针对 Node 运行

我对此有一些疑问，所以我联系了 [Tierney Cyren](https://twitter.com/bitandbang)，它是巨大的橙色知识圈的一部分，特别是在 Node 方面。

Tierney 指出使用基于 Node 的进程管理器（如 pm2）有一些缺点。

主要原因是不应该使用 Node 来监视 Node。你肯定不希望用你正在监视的东西监视它自己。就像你在周五晚上让我十几岁的儿子监督他自己一样：结果会很糟糕吗？可能，也可能不会。。

Tierney 建议你不要使用 Node 进程管理器来运行应用程序。相反，在更高级别上有一些东西可以监视应用程序的多个单独实例。例如，一个理想的设置是，如果你有一个 Kubernetes 集群，你的应用程序在不同的容器上运行。然后 Kubernetes 可以监控这些容器，如果其中任何容器发生故障，它可以将它们恢复并且报告健康状况。

在这种情况下，你可以直接针对Node运行，因为你正在更高级别进行监视。

事实证明，Azure 已经在做这件事了。如果我们不将 pm2 ecosystem 文件推送到 Azure，它将使用我们的 `package.json` 文件运行脚本来启动应用程序，我们可以直接针对Node运行。

```
"scripts": {
  "start": "node index.js"
}
```

在这种情况下，我们直接针对 Node 运行，没关系。如果应用程序崩溃，你会发现它又回来了。那是因为在 Azure 中，你的应用程序在一个容器中运行。Azure 负责容器调度，并知道何时去更新。

![](https://cdn-images-1.medium.com/max/2560/1*YSvtZOR4DIt1McSdDChVew.png)

但这里仍然只有一个实例。容器崩溃后需要一秒钟才能重新联机，这意味着你的用户可能会有几秒钟的停机时间。

理想情况下，你希望运行多个容器。解决方案是将应用程序的多个实例部署到多个 Azure AppService 站点，然后使用 Azure Front Door 在单个 IP 地址下对应用程序进行负载均衡。Front Door 知道容器何时关闭，并且将流量路由到应用程序的其他健康实例。

[**Azure Front Door Service | Microsoft Azure**](https://azure.microsoft.com/en-us/services/frontdoor/?WT.mc_id=medium-blog-buhollan)  
[使用 Azure Front Door 交付，保护和跟踪全球分布式微服务应用程序的性能](https://azure.microsoft.com/en-us/services/frontdoor/?WT.mc_id=medium-blog-buhollan)

### systemd

Tierney 的另一个建议是使用 `systemd` 运行 Node。我不是很了解（或者说根本不知道）`systemd`，我已经把这句话弄错过一次了，所以我会用 Tierney 自己的原话来表述：

> 只有在部署中访问 Linux 并控制 Node 在服务级别上启动的方式时，才有可能实现此选项。如果你在一个长时间运行的 Linux 虚拟机中运行 node.js 进程，比如说 Azure 虚拟机，那么使用 systemd 运行 node.js 是个不错的选择。如果你只是将文件部署到类似于 Azure AppService 或 Heroku 的服务中，或者运行在类似于 Azure 容器实例的容器化环境中，那么你可以避开此选项。

- [**使用 Systemd 运行 Node.js 应用程序 —— 第一部分**](https://nodesource.com/blog/running-your-node-js-app-with-systemd-part-1/)  
- [你已经在 Node 中编写了下一个很棒的应用程序，并且你已经准备发布它。这意味着你可以...](https://nodesource.com/blog/running-your-node-js-app-with-systemd-part-1/)

### Node.js 工作线程

Tierney 还希望你知道 Node 中有工作线程，这可以让你在多个线程上启动你的应用程序，从而无需像 pm2 这样的东西。也许吧。我不知道，我没看过这篇文章。

- [**Node.js v11.14.0 Documentation**](https://nodejs.org/api/worker_threads.html)  
- [The worker_threads module enables the use of threads that execute JavaScript in parallel. To access it: const worker =…](https://nodejs.org/api/worker_threads.html)

### 做个成熟的开发者

Tierney 的最后一个建议就是像一个成熟的开发者一样处理错误和编写测试。但是谁有时间呢？

### 小圆圈永驻

现在你知道这个蓝色小圆圈里的大部分东西了。剩下的只是关于 emo 乐队和啤酒的无用事情。

有关 pm2, Node 和 Azure 的更多信息，请查看以下资源：

* [http://pm2.keymetrics.io/](http://pm2.keymetrics.io/)
* [VS Code 上的 Node.js 部署](https://code.visualstudio.com/tutorials/nodejs-deployment/getting-started?WT.mc_id=medium-blog-buhollan)
* [将简单的 Node 站点部署到 Azure](https://azurecasts.com/2019/03/31/002-node-vscode/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
