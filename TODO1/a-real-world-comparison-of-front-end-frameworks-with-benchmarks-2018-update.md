> * 原文地址：[A Real-World Comparison of Front-End Frameworks with Benchmarks (2018 update)](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update-e5760fb4a962)
> * 原文作者：[Jacek Schae](https://medium.freecodecamp.org/@jacekschae?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md)
> * 译者：geniusq1981
> * 校对者：

# 前端开发框架实战对比（2018年更新）

![](https://cdn-images-1.medium.com/max/1000/1*0aM-p4OCCxRMXroYn0qPVA.png)

本文是对2017年12月发表的 [前端开发框架的实战对比](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-e1cb62fd526c)一文的更新

在对比中，我们将展示不同框架之间去实现几乎相同的 [实战示例应用](https://github.com/gothinkster/realworld)有怎样的差别。

 [实战示例应用](https://github.com/gothinkster/realworld)为我们提供了：

1.  **实战应用** — 这不是“将要做的”。一般来说，“将要做的”无法表达构建一个真实应用的所需要的足够的知识和观点。
2.  **标准化的** — 符合一定规则的项目。提供后端 API，静态标记，样式和规格。
3.  **由专家撰写或审核** — 一个实战项目，理想情况下，由技术专家创建或审核。

#### 上一版本的不足（2017年12月）

✅ Angular 没有用于生产环境。 之前实战应用仓库列出的示例应用使用的是一个开发版本，感谢 [Jonathan Faircloth](https://medium.com/@jafaircl)，它现在已经是生产版本！

✅ Vue 没有包含在实战应用仓库，因此未包括在对比中。正如你可以想象的那样，Vue 在前端引起了很大的热度。你怎么没有包含Vue？出了什么问题吗？这一次我们加入了Vue.js！谢谢 [Emmanuel Vilsbol](https://medium.com/@evilsbol)

#### 我们比较哪些库/框架？

和2017年12月的文章一样，我们包含了实战应用仓中列出的所有实现方式。不管它有没有大量的拥趸，唯一标准就是它出现在 [实战应用仓库](https://github.com/gothinkster/realworld)页面上。

![](https://cdn-images-1.medium.com/max/1000/1*IJ4a_VfY1Qn3yJaIy7pjVw.png)

前往 [https://github.com/gothinkster/realworld](https://github.com/gothinkster/realworld)(2018年4月)

#### 我们看什么指标？

1.  **性能:** 应用需要多长时间能显示出页面内容并可用？
2.  **大小:** 应用程序多大？我们只会比较已编译过的的 JavaScript 文件大小。 CSS 对于所有不同实现框架都是通用的，并且从 CDN (内容分发网络)下载。 HTML 也是通用的。所有技术都编译或转换成 JavaScript，因此我们只计算这些文件的大小。
3.  **代码行:** 开发者根据开发指南需要写多少行代码来做一个实战应用？为了公平，虽然有些应用程序有一些花里胡哨的东西，但它不应该对结果产生影响。所以我们只计算每个应用程序中的 `src/` 文件夹。

### 公制 #1: **性能**

使用 Chrome 做的 [First Meaningful Paint](https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint）测试，使用工具 [Lighthouse Audit](https://developers.google.com/)。

渲染速度越快，应用的使用者体验也越好。Lighthouse 也测试 [First interactive](https://developers.google.com/web/tools/lighthouse/audits/first-interactive)，但对于大多数应用来说，这几乎是相同的，而它还处于测试阶段。

![](https://cdn-images-1.medium.com/max/1000/1*El9cBVFHxRG36XD8KNjA_g.png)

First meaningful paint(毫秒) - 越低越好

在性能方面你可能不会看到很多差异。

### 公制 #2: 大小

传输大小来自 Chrome 的网络标签，包含从服务器传送的压缩的响应头和响应正文。

文件越小，下载速度越快(并且需要解析的数据也越少)。

这取决于你的框架以及你添加的依赖库的大小，还有你的编译工具的好坏也有一定影响。

![](https://cdn-images-1.medium.com/max/1000/1*xHuwMctzoT6aA3BE4zXA5w.png)

传输大小(KB) - 越低越好

您可以看到 Svelte，Dojo 2 和 AppRun 做得非常好。我不能说 Elm 也表现足够好 - 特别是当你看下一张图时。我也想看看 [Hyperapp](https://hyperapp.js.org/)的表现。可能下次吧， [Jorge Bucaran](https://medium.com/@jorgebucaran)？

### 公制 #3: 代码行

通过 [cloc](https://github.com/AlDanial/cloc)我们计算每个仓库的 src 文件夹中的代码行。空白和注释行不会包含在内。为什么这个有意义？

>如果调试是删除软件错误的过程，那么编程就是引入错误的过程 - Edsger Dijkstra

![](https://cdn-images-1.medium.com/max/1000/1*YTfk05JBtqNBIoK_4u2H3g.png)

# 代码行 - 越少越好

您拥有的代码行越少，那么出现错误的概率就越小，而且你也只需要维护一个较小的代码库。

### 结论

我想说，非常感谢 [Eric Simons](https://medium.com/@er)创建了 [实战示例应用](https://github.com/gothinkster/realworld)，还有大量的提供不同实现的贡献者们

**更新:** 感谢 [Jonathan Faircloth](https://medium.com/@jafaircl) 提供生产版本的 Angular.

> 如果你对这篇文章感兴趣，你可以在[ Twitter](https://twitter.com/jacekschae) 和 Medium 上加我.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner)对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
