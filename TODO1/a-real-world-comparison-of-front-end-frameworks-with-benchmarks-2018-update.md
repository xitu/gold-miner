> * 原文地址：[A Real-World Comparison of Front-End Frameworks with Benchmarks (2018 update)](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update-e5760fb4a962)
> * 原文作者：[Jacek Schae](https://medium.freecodecamp.org/@jacekschae?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md)
> * 译者：
> * 校对者：

# 前端开发框架实战对比（2018年更新）

![](https://cdn-images-1.medium.com/max/1000/1*0aM-p4OCCxRMXroYn0qPVA.png)

本文是对2017年12月发表的 [前端开发框架的实战对比](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks -e1cb62fd526c)一文的更新

在这个比较中，我们将展示几乎相同的 [RealWorld示例应用程序](https://github.com/gothinkster/realworld)的不同实现如何相互堆叠。

 [RealWorld示例应用](https://github.com/gothinkster/realworld)为我们提供了：

1. **真实世界应用程序** - 超过“待办事项”的东西。通常，“todos”不能传达足够的知识和观点来实际构建_real_应用程序。
2. **标准化** - 符合一定规则的项目。提供后端API，静态标记，样式和规范。
3. **由专家撰写或审核** - 一个一致的现实世界项目，理想情况下，该技术的专家可以创建或审查。

####上一版本的批评（2017年12月）

Ang️Angular没有投入生产。 RealWorld回购协议中列出的演示应用程序使用的是开发版本，但是感谢 [Jonathan Faircloth](https://medium.com/@jafaircl)，它现在处于生产版本！

✅Vue未列入真实世界回购协议中，因此未包括在内。正如你可以想象的那样，在前端世界，这引起了很大的热度。你怎么没有添加Vue？你有什么问题？这一次是Vue.js！谢谢 [Emmanuel Vilsbol](https://medium.com/@evilsbol)**。**

####我们正在比较哪些库/框架？

正如在2017年12月的文章中，我们包含了RealWorld回购中列出的所有实现。不管它是否有大的跟随都没关系。唯一的限制是它出现在 [RealWorld回购](https://github.com/gothinkster/realworld)页面上。

！[]（https://cdn-images-1.medium.com/max/1000/1*IJ4a_VfY1Qn3yJaIy7pjVw.png）

前往[https://github.com/gothinkster/realworld]（https://github.com/gothinkster/realworld）（2018年4月）

###我们看什么指标？

1. **性能：**该应用需要多长时间才能显示内容并变得可用？
2. **大小：**应用程序有多大？我们只会比较已编译的JavaScript文件的大小。 CSS对于所有变种都是通用的，并且从CDN（内容交付网络）下载。 HTML也适用于所有变体。所有技术都可以编译或转换成JavaScript，因此我们只调整这个文件的大小。
3. **代码行：**作者需要根据规范创建RealWorld应用程序需要多少行代码？公平地说，一些应用程序有更多的花里胡哨的，但它不应该有重大的影响。我们量化的唯一文件夹是每个应用程序中的“src /`。

###公制＃1：**性能**

使用[Lighthouse Audit]（https://developers.google.com/）查看[第一次有意义的涂料]（https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint）测试web / tools / lighthouse /）。

您越早画画，使用该应用程序的人的体验就越好。灯塔还测量[第一互动]（https://developers.google.com/web/tools/lighthouse/audits/first-interactive），但对于大多数应用来说，这几乎是相同的，并且它处于测试阶段。

！[]（https://cdn-images-1.medium.com/max/1000/1*El9cBVFHxRG36XD8KNjA_g.png）

第一个有意义的油漆（毫秒） - 越低越好

在性能方面你可能不会看到很多差异。

###公制＃2：大小

转化大小来自Chrome网络标签。 GZIPed响应头和服务器提供的响应正文。

文件越小，下载速度越快（并且解析出的数据也越少）。

这取决于你的框架的大小，以及你添加的额外的依赖关系，以及你的构建工具如何构建一个小包。

！[]（https://cdn-images-1.medium.com/max/1000/1*xHuwMctzoT6aA3BE4zXA5w.png）

传输大小（KB） - 越低越好

您可以看到Svelte，Dojo 2和AppRun做得非常好。我无法对榆树说得太多 - 特别是当你看下一张图时。我想看看[Hyperapp]（https://hyperapp.js.org/）是如何与下一次比较的[Jorge Bucaran]（https://medium.com/@jorgebucaran）？

###公制＃3：代码行

使用[cloc]（https://github.com/AlDanial/cloc）我们计算每个repo的src文件夹中的代码行。空白和注释行是**不是这个计算的一部分。为什么这是有意义的？

>如果调试是删除软件错误的过程，那么编程必须是将它们放入的过程 - Edsger Dijkstra

！[]（https://cdn-images-1.medium.com/max/1000/1*YTfk05JBtqNBIoK_4u2H3g.png）

＃行代码 - 越少越好

您拥有的代码行越少，那么发现错误的概率就越小。你也有一个较小的代码库来维护。

＃＃＃ 结论是

我想对[Eric Simons]（https://medium.com/@er）表示非常感谢

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
