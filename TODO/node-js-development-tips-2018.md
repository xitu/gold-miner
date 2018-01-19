> * 原文地址：[8 Tips to Build Better Node.js Apps in 2018](https://blog.risingstack.com/node-js-development-tips-2018/)
> * 原文作者：[Bertalan Miklos](https://twitter.com/@solkimicreb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/node-js-development-tips-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/node-js-development-tips-2018.md)
> * 译者：[PLDaily](https://github.com/PLDaily)
> * 校对者：[FateZeros](https://github.com/FateZeros)，[congFly](https://github.com/congFly)

# 8 个技巧让你在 2018 年构建更好的 Node.js 应用程序

在过去的两年里，我们介绍了编写和操作 Node.js 应用程序的最佳实践 (请阅读 [2016 版](https://blog.risingstack.com/how-to-become-a-better-node-js-developer-in-2016/)和 [2017 版](https://blog.risingstack.com/node-js-best-practices-2017/))。又一年过去了，是时候重温一下如何成为一个更好的开发者这个话题了！

在本文中，我们收集了一些我们认为 Node.js 开发者在 2018 年需要知道的技巧。随便挑选几个作为新年的开发礼物吧！

## 技巧 #1：使用 `async` - `await`

`Async` - `await` 在 Node.js 8 中繁荣发展。它改变了我们处理异步事件的方式，并简化了以前那些令人难以阅读的代码库。如果你到现在还没有使用过 `async` - `await` ，请阅读我们的[介绍博客文章](https://blog.risingstack.com/mastering-async-await-in-nodejs/)。

重温[异步编程和 Promises ](https://blog.risingstack.com/node-hero-async-programming-in-node-js/)对你认识 `async` - `await` 可能也会有所帮助。

## 技巧 #2：了解 `import` 和 `import()`

ES 模块已经广泛用于转换器与 [@std/esm ](https://github.com/standard-things/esm) 库。它在 Node.js 8.5 后加上 --experimental-modules 标志开始被支持，但是要在生产环境中使用还要走很长的路。(译者注：ES 模块在 Node.js 中属于 [Stability: 1 ](https://nodejs.org/dist/latest-v8.x/docs/api/documentation.html#documentation_stability_index) - 试验阶段)

我们建议你现在了解 ES 模块的基础知，并关注 2018 年的最新进展。你可以在[这里](http://2ality.com/2017/09/native-esm-node.html)找到一个简单的 Node.js 的 ES 模块教程。

## 技巧 #3：熟悉 HTTP/2

HTTP/2 在 Node.js 8.8 后不需要加标志便可被使用。它具有 server push (服务器推送) 和 multiplexing (多路复用) 功能，为浏览器中高效的加载本地模块铺平了道路。一些框架，如 Koa 和 Hapi，部分支持它。其他的 - 如 Express 和 Meteor - 正在致力于支持。

HTTP/2 在 Node.js 中虽然是试验性的，但是我们预计 2018 年会有很多新的库广泛采用它。 你可以在我们的[ HTTP/2 博客文章](https://blog.risingstack.com/node-js-http-2-push/)中了解更多关于该主题的内容。

## 技巧 #4：摆脱代码风格争议

[Prettier](https://github.com/prettier/prettier) 在 2017 年大受欢迎。这是一个有自己独立代码风格的代码格式化程序，它会将你的代码格式化成它的代码风格，而不是简单的代码风格报错。但仍然存在代码质量报错 - 比如[no-unused-vars](http://eslint.org/docs/rules/no-unused-vars) 和 [no-implicit-globals](http://eslint.org/docs/rules/no-implicit-globals) - 这些错误不能自动重新格式化。


## 技巧 #5：保护你的 Node.js 应用程序

每年都有很大的[安全漏洞](https://en.wikipedia.org/wiki/List_of_data_breaches)和新发现的漏洞，2017 年也不例外。安全是一个迅速变化的话题，不容忽视。 想要了解 Node.js 安全性，请从阅读我们的 [Node.js 安全清单](https://blog.risingstack.com/node-js-security-checklist/)开始。

如果你认为你的应用程序已经是安全的，那么你可以使用 [Snyk](https://snyk.io/) 和 [Node Security Platform ](https://nodesecurity.io/) 来发现一些隐蔽的漏洞。

## 技巧 #6：拥抱微服务

如果你有项目部署上的问题或有即将到来的大型项目，那么是时候采用微服务架构了。了解这两种技术，以便在 2018 年的微服务场景保持最新状态。

> [Docker](https://www.docker.com/) 是一个应用器引擎，它可以将软件运行所需要的一切打包到一个可移植的容器中。该文件系统包含了运行所需的所有东西：代码，运行时，系统工具和系统库。

> [Kubernetes](https://kubernetes.io/) 是一个进行自动化部署、扩展和容器操作的开源平台。

在深入到容器和编排之前，可以通过改进现有的代码来进行热身。遵循[ 12-factor 的应用程序](https://12factor.net/)方法，你可以更容易地容器化和部署你的服务。

## 技巧 #7：监控你的服务

在你的用户注意到它们之前解决问题。监控和警报是生产部署的重要组成部分，但是熟练掌握复杂的微服务系统并非易事。幸运的是，这是一个快速发展的领域，具有不断完善的工具。看看[未来的监测](https://blog.risingstack.com/the-future-of-microservices-monitoring-and-instrumentation/)或者了解最近的[ OpenTracing 标准](https://blog.risingstack.com/distributed-tracing-opentracing-node-js/)。

如果你是一个更实际的人，我们的[ Prometheus 教程](https://blog.risingstack.com/node-js-performance-monitoring-with-prometheus/)给监控世界提供了一个很好的介绍。

## 技巧 #8：贡献开源项目

你有什么喜欢的 Node.js 项目吗？在你的帮助下它们有机会变得更好。只要找到符合你兴趣的问题，并帮助他们解决问题。

如果您不知道如何开始，请仔细阅读[这些快速提示](https://egghead.io/articles/get-started-contributing-to-javascript-open-source)或观看有关 GitHub 上的开源贡献的[课程](https://egghead.io/courses/how-to-contribute-to-an-open-source-project-on-github)。实践是最好的学习方式，特别是程序员。

## 你有什么 Node.js 开发建议

对于 Node.js 开发者在 2018 年需要知道的技巧你还有什么建议？在评论部分留下你的意见！

**我们希望你会有一个很棒2018年。快乐编码！**

[Follow @RisingStack](https://twitter.com/RisingStack)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
