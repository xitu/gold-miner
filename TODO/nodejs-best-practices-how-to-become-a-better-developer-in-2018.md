> * 原文地址：[Node.js Best Practices - How to become a better Node.js developer in 2018](https://nemethgergely.com/nodejs-best-practices-how-to-become-a-better-developer-in-2018/)
> * 原文作者：[GERGELY NEMETH](https://nemethgergely.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/nodejs-best-practices-how-to-become-a-better-developer-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/nodejs-best-practices-how-to-become-a-better-developer-in-2018.md)
> * 译者：[Yong Li](https://github.com/NeilLi1992)
> * 校对者：[guoyang](https://github.com/gy134340) [moods445](https://github.com/moods445)

# Node.js 最佳实践 —— 如何在 2018 年成为更好的 Node.js 开发者

在过去两年中，每年写一篇关于来年如何成为更好的 Node.js 开发者的建议已经成了我自己的传统。今年也不例外！🤗

如果你对我之前的新年建议感兴趣，你可以在 RisingStack 博客上阅读：

* [如何在 2016 年成为更好的 Node.js 开发者](https://blog.risingstack.com/how-to-become-a-better-node-js-developer-in-2016/)
* [如何在 2017 年成为更好的开发者](https://blog.risingstack.com/node-js-best-practices-2017/)

话不多说，一起来看 2018 年的建议！

## 采用 `async-await`

随着 Node.js 8 的发布，`async` 函数已经普遍可用了。有了 `async` 函数的存在，你可以替换掉回调，写出读起来和同步代码一样的异步代码。

但什么是 `async` 函数？让我们回顾一下 [Node.js Async 函数最佳实践](https://nemethgergely.com/async-function-best-practices/) 一文：

`async` 函数可以让你写出读起来像是同步代码的，但实际基于 `Promise` 的代码。一旦你使用了 `async` 关键字来定义函数，你就可以在函数体内使用 `await` 关键字。`async` 函数被调用时，它会返回一个 `Promise`。当 `async` 函数体中返回一个值时，该 `Promise` 完成（fulfilled）。当 `async` 函数抛出错误时，该 `Promise` 失败（rejected）。

`await` 关键字可以用来等待一个 `Promise` 完成并且返回结果值。如果传给 `await` 关键字的值不是一个 `Promise`，它会将其转换成一个已完成的 `Promise`。

如果你想掌握 `async` 函数，我推荐你浏览这些资源：

* [Learning to throw again](https://hueniverse.com/learning-to-throw-again-79b498504d28)
* [Catching without awating](https://hueniverse.com/catching-without-awaiting-b2cb7df45790)
* [Node.js async function best practices](https://nemethgergely.com/async-function-best-practices/)

## 让你的应用优雅地中止

当你部署应用的新版本时，必须更换旧版本。你使用的，**不管是 Heroku, Kubernetes, supervisor 还是任何其它的**进程管理器，会首先给应用发送一个 `SIGTERM` 信号，来通知它即将被中止。一旦应用得到了该信号，它应该**停止接受新的请求，完成所有正在处理中的请求，并且清理它使用的资源**。资源通常包含了数据库连接和文件锁。

为了让这一过程更简单，我们在 GoDaddy 上发布了名为 [terminus](https://github.com/godaddy/terminus) 的开源模块，来帮助你的应用实现优雅中止。[现在就来看看 ☺️](https://github.com/godaddy/terminus)

## 在公司内采用相同的风格指南

在一个有上百人开发团队的公司中采用风格指南是很有挑战性的 —— 让每个人都认可同一套规则简直难如登天。

恕我直言：你永远无法让上百个开发者认可同一组准则，即使这能带来显而易见的收益，譬如让团队更快地在项目间切换，而无需费时费力来习惯一套新的（即使只有一点儿不同）代码编写风格。

如果你正是工作在这种团队氛围中，我发现最好的办法是信任某位经验丰富的程序员，和其他人共同努力来决定风格指南包含哪些准则，但他要有最终决定权。在所有人都能遵循同一套准则之前，该准则的具体内容并不重要（我不想引发关于分号的争吵）。重要的是必须在某一刻有所决定。

## 把安全当做必备条件

我们看到越来越多的公司被列在 [haveibeenpwned](https://haveibeenpwned.com/) 上 —— 我打赌你不想成为下一个。当你向你的用户发布一段新代码的时候，代码审核应该包含安全领域的专家。如果你公司内没有这样的人才，或者他们非常非常忙，一个很好的解决办法是和类似 [Lift Security](https://liftsecurity.io/reviews/) 这样的公司合作。

而你作为一名开发者，同样应该努力更新你的安全知识。为此，我推荐你阅读这些材料：

* [Node.js 安全检查清单](https://blog.risingstack.com/node-js-security-checklist/)
* [「开放网络应用安全项目」网站](https://www.owasp.org/index.php/Main_Page)
* [Snyk 博客](https://snyk.io/blog/)

## 在见面会或会议上演讲

另一个成为更好的开发者，甚至更好地学会表达自己的方法，就是在见面会或者会议上演讲。如果你从未试过，我推荐先从一个本地的见面会开始，再去尝试申请全国的或者国际的会议。

我明白当众演讲会很难。当我准备我的第一次演说时，[Speaking.io](http://speaking.io/) 帮了我不少忙，我也推荐你去看看。如果你正在准备你的第一次演说，并且想要一些反馈的话，你可以在 [Twitter](https://twitter.com/nthgergo) 上找我谈谈，我很乐意帮忙！

一旦你有了一个想要在会议上分享的主题，你可以在 Github 上查看到 [2018 Web 会议](https://github.com/asciidisco/web-conferences-2018/blob/master/README.md) 征文集合，这太棒了！

## 直接使用新的浏览器 API 编写模块

九月时 [Mikeal](https://medium.com/@mikeal) 在 [Modern Modules](https://medium.com/@mikeal/modern-modules-d99b6867b8f1) 上发布了一篇很好的文章。其中我最喜欢的一件事，就是使用浏览器 API 来编写模块，当必要时填补（polyfill）Node.js。由此而来的显著优势就是你可以将更小的 JavaScript 代码发布进浏览器中（并且让页面加载得更快）。另一方面，没人会在意你的后端依赖是不是太过繁重。

## 采纳应用开发的 12-Factors 法则

应用开发的 12-Factors 原则，描述了网络应用应当如何编写的最佳实践，因此它也出现在今年我的建议列表中了。

随着 Kubernetes 和其它编排引擎的使用率不断提升，遵循 12-Factors 法则变得越来越重要。它们涵盖了以下领域：

1. [一份基准代码，多份部署](http://12factor.net/codebase)
2. [显示声明和分离依赖关系](http://12factor.net/dependencies)
3. [在环境中存储配置](http://12factor.net/config)
4. [把后端服务当做附加资源](http://12factor.net/backing-services)
5. [严格分离构建和运行](http://12factor.net/build-release-run)
6. [以一个或多个无状态进程运行应用](http://12factor.net/processes)
7. [通过端口绑定提供服务](http://12factor.net/port-binding)
8. [通过进程模型进行扩展](http://12factor.net/concurrency)
9. [快速启动和优雅中止可最大化健壮性](http://12factor.net/disposability)
10. [尽可能地保持开发、预发布、线上环境相同](http://12factor.net/dev-prod-parity)
11. [把日志当做事件流](http://12factor.net/logs)
12. [后台管理任务当做一次性进程运行](http://12factor.net/admin-processes)

## 学习新的 ECMASCript 特性

一些新的 ECMAScript 特性可以显著提升你的效率。它们可以帮你写出不言自明的清晰代码。其中我最爱的特性有（**老实说它们不是非常新了**）：

* [扩展语法](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator)
* [剩余参数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters)
* [解构](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
* [Async 函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)

如果你想知道新的 ECMAScript 特性的完整内容，我推荐阅读这本书 [ES6 & Beyond](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20&%20beyond/README.md#you-dont-know-js-es6--beyond)。

* * *

你想在这份列表中加入别的建议吗？请在留言中告诉我。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
