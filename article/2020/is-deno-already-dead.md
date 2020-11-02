> * 原文地址：[Is Deno Already Dead?](https://medium.com/javascript-in-plain-english/is-deno-already-dead-661ce807338a)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：

# Deno 已经死了吗？

![Source: the author](https://cdn-images-1.medium.com/max/2800/1*UH9zLe8rjJI9lFpj44yYDA.png)

在今年 5 月，不止冠状病毒成为人们关注的焦点，在 JavaScript 和后端开发社区中，Deno 也受到同样的关注并迅速传播开来。第一个稳定版本已经出现，而且引发了一场巨大的炒作。我也一样，迅速地参与到 Deno 并且期望能尝试点新东西。

[一篇文章](https://medium.com/javascript-in-plain-english/deno-vs-node-js-here-are-the-most-important-differences-62b547443be1) 我写了这篇文章，仅仅通过谷歌它就获得了数千的点击量 —— 显而易见大家对于 Deno 的兴趣是真的很浓厚。

但是炒作之后剩下了什么呢？那些甚至认为 Deno 可以取代 Node.js 的声音在哪里？显然，炒作已经所剩无几了 —— 谷歌证实了这一点：

![Source: [Google Trends](https://trends.google.com/trends/explore?q=deno)](https://cdn-images-1.medium.com/max/4592/1*nbOAGzuHmHB7vr00J7xOjw.png)

正如你从谷歌趋势中看到的那样，搜索词 Deno 已经不再像春末夏初的时候那么流行了 —— 还应该注意的是，谷歌 Deno 趋势不包括类别主题或编程语言。谷歌对 Deno 的其它搜索结果与这项技术无关，但仍包含在统计数据中。

## 其它技术的兴起

今年已经有很多东西可以提供 —— 在前端领域是 Svelte，在后端领域是 Deno。而且，总体而言，许多编程语言都得到了广泛的关注。Rust 和 Julia 就是很好的例子 —— 而 JavaScript 的普及率没有增长。

新技术总是带来新的可能性 —— 以及新框架和库。当然，他们都想经受住考验 —— 因此，举例来说，Rust 的 Actix Web 获得了关注，即使只是在 Rust 社区，以及对它感兴趣的人中。

在我看来，Deno 之所以没有了更大的炒作空间 —— 是因为它从来没有颠倒 web 世界的野心 —— 而这正是很快就变得清楚的地方。

## 没有惊天动地的新东西

在我关于 Deno 和 Node.js 对比差异的文章中，我就提到了这一点。以下是 Deno 展现出的极其重要的、独特的特性：

* 不支持 NPM
* 权限
* 顶层 Await
* 对 window 对象的支持
* 开箱即用的 TypeScript 支持

上述就是我以前所提到的 Deno 所带来的令人耳目一新的重要特性。

经过大量的反复试验，大多数开发人员可能已经意识到，这些功能不足以颠覆他们的世界。尤其是对于现有后端而言，他们没有巨大的动力来改变一切。

这也体现在对 Deno 的专业使用上 —— 根据 [StackShare.io,](https://stackshare.io/deno)，有 7 家公司使用 Deno。

## 迁移非常昂贵 —— 而且部分毫无意义

当然，Deno 和 Node.js 非常相似。在 Deno 中，您不会仅仅依赖 TypeScript。JavaScript 同样开箱即用地支持它。

但是在 JavaScript 一词出现的地方，您会立马想到 JS 社区中分布的许多库和框架。其中一些在 Node.js 中也可用。只需想一下 Express.js，Koa，Sails，Axios，Lodash 或 Sequelize。 所有这些库经常在 Node.js 项目中使用，并且可以通过 NPM 轻松安装。


NPM 是让您想起 Deno 的关键字 —— 因为将 NPM 模块与 Deno 结合使用本身并不是故意的，因此很麻烦。这使得从 Node.js 迁移到 Deno 变得相当困难。Deno 还以其安全性而闻名 —— 事实上，几乎所有内容都需要用户的许可。这也不错，绝对是一种敏感的方法。 但是我认为，这不是将现有 Node.js 应用程序完全迁移到 Deno 的好理由。

## 没有额外的表现

在这一点上，我想说明的是，我个人不认为仅仅因为 Node.js 的性能就应该将其放置在 Deno 之上。

当我们对其进行测量时，性能通常是相当不现实的，并且可以完全忽略，特别是对于用户很少的小型应用程序。 可扩展的服务提供商使您可以轻松地在性能方面适应您的需求 —— 您不必在固定的根服务器上安装最快的 Web 服务器和数据库。

但是，即使有纸面上的差异，也不能忽略许多开发人员对性能感兴趣。 但是就性能而言，Deno 的表现并不比 Node.js 好。

这不足为奇。毕竟，就性能而言，Deno 从未有过取代 Node.js 的雄心。它更多关注的是安全性和与此相关的东西。

您可以在 Deno 官方网站上找到它 —— 基准测试证明 Deno 不是最快的框架。更不用说与 Node.js 相比了。

![Source: [Deno Land — Benchmarks](https://deno.land/benchmarks)](https://cdn-images-1.medium.com/max/2924/1*H_5-f1ftdQirKClZzMFR1g.png)

在上面显示的基准测试中比较了 Node.js 和 Deno 的标准 HTTP 请求和响应模块。该基准测试表明 Node.js 提供了更高的性能。

我本人也在两个平台之间进行了基准测试 —— 结果是相同的。Node.js 的性能明显更好。尽管 Deno 看上去并不十分糟糕，但许多人仍主要在寻找性能。

当然，性能不是选择技术时唯一的决定性组成部分。诸如 Fastify 或用于 Go 和 Rust 的 HTTP 库之类的框架和技术通过它们的性能而引起了人们的极大兴趣。因此，您可以清楚地说，许多开发人员都对良好的性能感兴趣，并且与 Node.js 相比，Deno 不能提供完全相同的性能。

## 为时过早

新技术总是迅速引起炒作。每个人都想尝试一些新事物，现在是为其提供内容的最佳时机。结果，话题膨胀到了极点，而大多数人却没有认真的意图。

有些人甚至看到 Deno 发行时 Node.js 的结束 —— 当然，这是一个吸引了很多注意力的内容，因此对于创造者来说很有价值 —— 但是，当然，这完全是夸张的。

结果是一个浮夸的叙述，与现实不再相关，每个人都想自己检查 Deno 是否意味着 Node.js 的结束。其他一切都是不合逻辑的。在尝试之前，我还没有决定使用 Deno 重写现有的 Node.js 应用。

在 2010 年宣布并发布 Node.js 时，人们对此并不十分感兴趣。项目的早期版本似乎总是有点血腥和令人生畏。

某些技术可能会过时 —— 在2年内，围绕 Node.js 的一场或其他丑闻后，世界看起来可能会大不相同。 过去，NPM 软件包存在严重的安全问题。但是在危机中，总会有人获利 —— 也许 Deno 会是大赢家。

## 总结

Deno 不错，有其合理性。

Node.js 在其第一个版本中并未被大肆宣传，并且仍有改进的时间。因此，Deno 可能会继续发展。

特别是关于 node.js 我们尚不了解的性能和功能，可能会有很多变化。 因此，我对 Deno 会发生什么感到很好奇，并且我将始终检查并查看新版本将发布的内容。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
