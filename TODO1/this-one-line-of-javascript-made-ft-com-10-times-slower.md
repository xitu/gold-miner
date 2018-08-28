> * 原文地址：[This one line of Javascript made FT.com 10 times slower](https://medium.com/ft-product-technology/this-one-line-of-javascript-made-ft-com-10-times-slower-5afb02bfd93f)
> * 原文作者：[Arjun](https://medium.com/@adgad?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ft-product-technology/this-one-line-of-javascript-made-ft-com-10-times-slower.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ft-product-technology/this-one-line-of-javascript-made-ft-com-10-times-slower.md)
> * 译者：[IridescentMia](https://github.com/IridescentMia)
> * 校对者：[Eternaldeath](https://github.com/Eternaldeath), [Park-ma](https://github.com/Park-ma)

# 一行 JavaScript 代码竟然让 FT.com 网站慢了十倍

## 性能退化的探索之旅

### 发现问题

这一切开始于一个警报，首页应用的错误率高于 4％ 的阈值。

显示数千个错误页面对我们的用户产生了切实的影响（还好 CDN 缓存抵消一部分影响）。

![](https://cdn-images-1.medium.com/max/800/0*NulY2pOWG5_EEmKq)

被用户看到的错误页面

应用程序的错误日志显示，该应用程序没有任何有关 top stories 的数据。

![](https://cdn-images-1.medium.com/max/800/0*sctKUx9eZMjK3ecQ)

### 诊断问题

首页的工作原理是在一个时间间隔内轮询 GraphQL api 以获取数据，将该数据存储在内存中并根据请求渲染它。从理论上讲，如果请求失败，应该保留之前稳定的数据。进一步深入日志，我们看到对 GraphQL api 的请求失败了，但是是有错误而不是超时——或者至少是不同类型的超时。

```
FetchError: response timeout at https://….&source=next-front-page over limit: 5000
```

![](https://cdn-images-1.medium.com/max/800/0*QGxZjzHsATzwm8WF)

奇怪的是，API 的响应时间似乎远低于首页设置的 5 秒超时。这让我们相信问题出现在首页和应用程序之间的连接上。我们做了些尝试——在两者之间使用 keepAlive 连接，分散请求，这样它们就不会同时发起。这些似乎都没有产生任何影响。

![](https://cdn-images-1.medium.com/max/800/0*dFdztWjeKbMtWdLx)

更神秘的是 Heroku 上显示的响应时间。第 95 百分位数约为 2-3 秒，而最大值有时达到 10-15 秒。由于首页被 Fastly 高度缓存，包括 [stale-while-revalidate](https://docs.fastly.com/guides/performance-tuning/serving-stale-content.html) 头，许多用户可能不会注意到。但这很奇怪，因为首页**真的**不应该做很多工作来渲染页面。所有数据都保存在内存中。

![](https://cdn-images-1.medium.com/max/800/0*0KSUFEF86Vmgjq8S)

首页的 Heroku 响应时间

因此我们决定对本地运行的应用程序副本进行一些分析。我们将通过使用 Apache Bench 每秒发出10个请求，共发出 1000 个请求来复制一些负载。

```
ab -n 1000 -c 10 http://local.ft.com:3002/
```

使用 [node-clinic](https://www.nearform.com/blog/introducing-node-clinic-a-performance-toolkit-for-node-js-developers/) 和 [nsolid](https://nodesource.com/products/nsolid)，我们可以对内存、CPU 和应用程序代码有更深的理解。运行它们，确认我们可以在本地复现该问题。首页需要 200-300 s 才能完成测试，超过 800 个请求不成功。相比之下，在文章页面上运行相同的测试需要大约 50 秒。

```
测试用时：305.629 秒
完成的请求：1000
失败的请求：876
```

而且你看，n-solid 的图表显示事件循环的滞后超过 100 毫秒。

![](https://cdn-images-1.medium.com/max/800/0*VJC8ZG_P-WR28cvR)

在做加载测试时事件循环滞后

使用 n-solid 的 CPU 分析器，我们可以精确定位阻塞事件循环的确切代码行。

![](https://cdn-images-1.medium.com/max/800/0*nhC_5jlhKw7uqOL6)

火焰图显示导致滞后的函数

### 修复问题

罪魁祸首是...

```
return JSON.parse(JSON.stringify(this._data));
```

对于每个请求，我们使用 JSON.parse/stringify 来创建数据的深克隆。这种方法本身不坏 —— 可能是深克隆比较快方法之一。但它们是同步方法，因此在执行时会阻塞事件循环。

在我们的案例中，这个方法在每个页面渲染（对于每个被渲染的部分）中多次调用，具有大量数据（每次执行时整个页面所需的数据），并且我们有几个并发请求。由于 Javascript 是单线程的，因此这将对应用程序尝试执行的所有其他操作产生连锁反应。

深克隆数据的原因是，我们会根据请求中的一些信息（例如，是否启用了特定功能的切换），来改变对象。

为了解决这个问题——并减轻克隆所有内容的需要——我们在检索时对对象应用了深度冻结，然后在数据被改动的地方克隆特定位。这仍然执行同步克隆——但仅限于更小的数据子集。

### 结论

修复好后，我们重新运行了负载测试，并在很短的时间内完成，0 次错误。

```
测试用时：37.476 秒
完成的请求：1000
失败的请求：0
```

我们发布了修复程序，看到响应时间和错误（🤞🏼）立即减少，并希望一些用户开心！

![](https://cdn-images-1.medium.com/max/800/1*zsJVZsXvp39EDlv8vAOk2w.png)

修复后首页的响应时间

![](https://cdn-images-1.medium.com/max/800/1*ASzi7PZfAIVLLQr5ybNZzw.png)

### 关于未来

* 对其他一些应用程序运行此分析，并了解我们可以进一步优化和/或减少 dyno 大小，这也会很有趣。
* 我们可以让事件循环更可见吗？
* 我们的首页应该是 stale-on-error——所以为什么仍然会看到数以千计的错误页面？这个数字好还是坏？

感谢 [Samuel Parkinson](https://medium.com/@samparkinson_?source=post_page) 的付出。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
