
> * 原文地址：[On Strategies to apply Kotlin to existing Java code](https://medium.com/@enriquelopezmanas/on-strategies-to-apply-kotlin-to-existing-java-code-6317974717ec)
> * 原文作者：[Enrique López Mañas](https://medium.com/@enriquelopezmanas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/on-strategies-to-apply-kotlin-to-existing-java-code.md](https://github.com/xitu/gold-miner/blob/master/TODO/on-strategies-to-apply-kotlin-to-existing-java-code.md)
> * 译者：[Luolc](https://github.com/Luolc)
> * 校对者：[skyar2009](https://github.com/skyar2009), [phxnirvana](https://github.com/phxnirvana)

# 将 Kotlin 应用于现有 Java 代码的策略

---

![](https://cdn-images-1.medium.com/max/2000/1*3fqrq8dMl-V3294hR5VfbQ.jpeg)

# 将 Kotlin 应用于现有 Java 代码的策略

自 Google 在 I/O 大会上发布最新消息（译者注：Google 宣布 Android Studio 将默认支持 Kotlin）起，事情变得疯狂起来。在过去的两周内，[Kotlin 周报](http://www.kotlinweekly.net/)邮件列表的订阅人数增长了 20% 以上，文章提交数增长超过 200%。我所组织的线下交流（[Kotlin 慕尼黑用户组](https://www.meetup.com/Kotlin-User-Group-Munich/)）的参与人数大幅增长。所有这一切伴随着开发者社区总体的爆发性增长。

![](https://cdn-images-1.medium.com/max/1600/1*QtuHCInbXJ9Fyl8Cy1Cnsw.png)

一个还会不断增长的趋势。

总之现在来看，未来将会如何发展是很显然的。尽管 Google 承诺将继续支持 Java，但 [Google 和 Oracle 之间的法律纠纷](https://en.wikipedia.org/wiki/Oracle_America,_Inc._v._Google,_Inc.)以及 Kotlin 是一个更加简洁、高效、强大的语言的清晰事实正在标志着你学习的方向。我发现下面这个推文相当有预见性。

![](https://ws3.sinaimg.cn/large/006tKfTcly1fh3l62xqunj30wo0fggn4.jpg)

几个月前，当我出现在与 Kotlin 相关的讨论、社区中时，可能最常被问及的问题是，现在是否是一个迁移至 Kotlin 的好时机。我的回答始终不会变：**是的**。进行 Kotlin 迁移有很多收益，且几乎没有任何坏处。我所能想到的唯一一个技术上的副作用是方法数将会增多，因为 Kotlin 标准库（目前）增加了 [7191 个新方法](https://blog.jetbrains.com/kotlin/2016/03/kotlins-android-roadmap/)。综合利弊来看，这是一个完全可以接受的不足。

既然这个问题的答案是毫无争议的肯定，我意识到另一个问题在浮现出来：**开始使用 Kotlin 应该采取什么样的步骤？**

本文旨在向那些困惑从何开始或寻求灵感的人们提供一些自己的想法。

### 1.- 从测试开始

是的，我知道测试是有限制性的。单元测试确切是指：你所测试的（是）独立单元和模块。当你所拥有的一切只是一群单独的类和可能的少量辅助类时，开发复杂的架构网是很困难的。但是这是一种对新语言建立认知和拓展的非常廉价和高效的方法。

我所听到的一个最常见的反对 Kotlin 的观点是，要避免在生产环境中部署 Kotlin 代码。虽然在我看来这是一种非常有偏见的观点，我想向你强调的是，如果你从测试开始，没有任何代码会被实际部署（到生产环境）。取而代之的是，这些代码可能会在你的持续集成环境中被使用，而这也是一种拓展知识的方式。

开始用 Kotlin 书写新的测试吧，它们可以直接与其他 Java 类进行协同和互通。当你有空闲时间时，可以[将 Java 类迁移](https://www.jetbrains.com/help/idea/2017.1/converting-a-java-file-to-kotlin-file.html)，并检查生成的代码，根据需要进行手动更改。以我个人经验来看，60% 的转换代码都是可以直接使用的，对于没有复杂功能的简单类而言这个比例会更高。我发现这是一个非常安全的场景，可以作为第一步来开始。

### 2.- 迁移已有代码

你已经开始编写了一些 Kotlin 代码。你了解了一些关于语言的基础。现在你已经[准备好将 Kotlin 用于生产环境](https://www.youtube.com/watch?v=-3uiFhI18g8)了！

当你要第一次开始在生产环境中使用时，从低耦合的类（[DTO](https://en.wikipedia.org/wiki/Data_transfer_object) 和数据类）开始是非常高效的。这些类的影响很小，可以在非常短的时间内轻松的重构。这是了解[数据类](https://kotlinlang.org/docs/reference/data-classes.html)并大幅减少你的代码量的最佳时机。

![](https://cdn-images-1.medium.com/max/1600/1*CiirveRVOZzMAOLv45aw7A.png)

这是你希望发起的 PR。

在这之后，开始迁移单一类。可能是类似 **LanguageHelper** 或 **Utils** 这样的类。虽然它们在很多地方被调用，但这种类一般只提供一些影响和依赖关系很有限的功能。

在某个时间节点，你会感觉解决架构中那些更加庞大和核心的类已经足够舒适了。不要害怕。请特别注意**可为空（nullability）**，这是 Kotlin 中最为重要的特性之一。如果你已经进行了很多年的 Java 编程的话，它需要你用一种新的思维方式。但请相信我，新的编程范式最终会在你的头脑中形成。

记住：你不需要强制迁移整个代码库。Kotlin 和 Java 可以无缝交互，现在你并不需要让代码库 100% 由 Kotlin 组成。当你感觉到足够舒适的时候再去做它。

### 3.- 尽情的使用 Kotlin

到这个阶段你一定可以开始用 Kotlin 编写所有的新代码了。把这当成过去的事，不要总是回看。当你开始用纯 Kotlin 编写第一个功能时，除了在上面提到过的**可为空（nullability）**，你还需要对默认参数多加注意。更多的考虑扩展功能，而不是继承。发起拉取请求（Pull Request）和代码审查，和你的同事讨论如何能够进一步完善。

最后的建议，享受吧！

### 用于学习 Kotlin 的资源

下面所列的是我曾经尝试过并且可以推荐的学习 Kotlin 的资源链接。我特别喜欢书籍，尽管有些人讨厌它们。我发现把它们大声读出来是很重要的，同时在电脑上进行编写和练习的话对于知识的沉淀更有帮助。

1. [Kotlin Slack](http://slack.kotlinlang.org/): 许多 JetBrains 的人和 Kotlin 狂热者会聚集在这里。
2. [Kotlin Weekly](http://kotlinweekly.net/): 我管理的一个每周选取 Kotlin 相关资讯发布的邮件列表。
3. [Kotlin Koans](https://kotlinlang.org/docs/tutorials/koans.html): 一系列可以训练和强化你的 Kotlin 技能的在线练习。
4. [Kotlin in Action](https://www.manning.com/books/kotlin-in-action): 来自 JetBrains 的一些 Kotlin 工作者的书。
5. [Kotlin for Android developers](https://transactions.sendowl.com/stores/7146/39165): 一本重点在如何使用 Kotlin 做 Android 开发的书。
6. [Resources to Learn Kotlin](https://developer.android.com/kotlin/resources.html): Google 提供的更多学习 Kotlin 的资源。

我在我的 [Twitter 账户](https://twitter.com/eenriquelopez)上分享关于软件工程和生活的一些观点。如果你喜欢这篇文章或它真的对你有所帮助，非常乐意你能够分享、点赞或回复。这是业余作者的最大动力。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
