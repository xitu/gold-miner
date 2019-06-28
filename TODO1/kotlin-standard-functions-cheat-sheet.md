> * 原文地址：[Kotlin Standard Functions cheat-sheet](https://medium.com/androiddevelopers/kotlin-standard-functions-cheat-sheet-27f032dd4326)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-standard-functions-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-standard-functions-cheat-sheet.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[phxnirvana](https://github.com/phxnirvana)

# Kotlin 标准方法备忘

上周我在[推特](https://twitter.com/ppvi/status/1081168598813601793)上谈到了 **Kotlin 标准方法备忘的新内容**，我发现它们比传统的方法更好。它并不关注每个方法的工作原理，而是根据开发人员想要实现的目标来提供指导：

![](https://i.loli.net/2019/04/14/5cb2920d19bb0.png)

以 [PNG](https://raw.githubusercontent.com/JoseAlcerreca/kotlin-std-fun/master/Kotlin%20Standard%20Functions%20v1.png) 或者 [PDF](https://github.com/JoseAlcerreca/kotlin-std-fun/raw/master/Kotlin%20Standard%20Functions%20v1.pdf) 格式下载 **Kotlin 标准方法流程图**。

![**Kotlin Standard Functions flowchart**](https://cdn-images-1.medium.com/max/5404/1*cKwEowUXup3K7LmiMgn3XQ.png)

该流程图**为建议性**：每个决定都是有原因的，从语义到可读性。例如：虽然 `apply` 也会有副作用，但在一个单独的方法中使用会更具可读性和安全性。

该流程图**并非详尽无遗**：还有其他用例未涉及。如：`run` 虽然可用于限制作用域，但最好将它提取到一个方法中。

该流程图**尚未完成**：随着编程语言的发展和模式的出现，我们将对其进行更新。

我还提供了传统的表格:

![](https://i.loli.net/2019/04/14/5cb292386ad34.png)

以 [PNG](https://raw.githubusercontent.com/JoseAlcerreca/kotlin-std-fun/master/Kotlin%20Standard%20Functions%20Table.png) 或者 [PDF](https://github.com/JoseAlcerreca/kotlin-std-fun/raw/master/Kotlin%20Standard%20Functions%20Table.pdf) 格式下载 **Kotlin 标准方法表格**。

链接:

* [Github 仓库](https://github.com/JoseAlcerreca/kotlin-std-fun)

**感谢每一个为该图表和会话做出贡献的人**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
