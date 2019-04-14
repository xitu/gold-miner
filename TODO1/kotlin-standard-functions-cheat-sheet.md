> * 原文地址：[Kotlin Standard Functions cheat-sheet](https://medium.com/androiddevelopers/kotlin-standard-functions-cheat-sheet-27f032dd4326)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-standard-functions-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-standard-functions-cheat-sheet.md)
> * 译者：
> * 校对者：

# Kotlin Standard Functions cheat-sheet

Last week I [tweeted](https://twitter.com/ppvi/status/1081168598813601793) about this **new take on a Kotlin Standard Functions Cheat-Sheet** that I find better than the traditional approach. Instead of focusing on how each function works, it provides guidance depending on what the developer wants to achieve:

![](https://i.loli.net/2019/04/14/5cb2920d19bb0.png)

Download the **Kotlin Standard Functions flowchart** in [PNG](https://raw.githubusercontent.com/JoseAlcerreca/kotlin-std-fun/master/Kotlin%20Standard%20Functions%20v1.png) or [PDF](https://github.com/JoseAlcerreca/kotlin-std-fun/raw/master/Kotlin%20Standard%20Functions%20v1.pdf).

![**Kotlin Standard Functions flowchart**](https://cdn-images-1.medium.com/max/5404/1*cKwEowUXup3K7LmiMgn3XQ.png)

It is **opinionated**: every decision was taken for a reason, from semantics to readability. For example: a side-effect could be executed inside an `apply` too, but it’s much more readable and safer to indicate it in a separate function.

It is **not exhaustive:** there are other use cases not covered by it. Example:`run` can be used to limit scope but it’s preferred to extract to a method.

It is **not done: a**s the language evolves and patterns emerge, we’ll update it.

I also provided the traditional table:

![](https://i.loli.net/2019/04/14/5cb292386ad34.png)

Download the **Kotlin Standard Functions table** in [PNG](https://raw.githubusercontent.com/JoseAlcerreca/kotlin-std-fun/master/Kotlin%20Standard%20Functions%20Table.png) or [PDF](https://github.com/JoseAlcerreca/kotlin-std-fun/raw/master/Kotlin%20Standard%20Functions%20Table.pdf).

Links:

* [Github repository](https://github.com/JoseAlcerreca/kotlin-std-fun)

**Thank you to everyone that contributed to the diagrams and to the conversation.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
