> * 原文地址：[A Simple Web App in Rust, Conclusion: Putting Rust Aside for Now](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)
> * 译者：[mysterytony](https://github.com/mysterytony)
> * 校对者：

# 一个用 Rust 做的简单网页，结果：还是把 Rust 放一边吧

**警告：这篇文章充满了主见。虽然 Rust 社区也许不会很震惊，但我还是想列出一系列。**

多年前，我编辑过一系列以《Building a Simple Webapp in Rust》为标题的博客。我希望有一天能重新开始编辑，但是我没有，我甚至怀疑我能不能完成这一系列的创作 —— 现在来看，那个博客里几乎所有内容都是过时的。

从一个重要方面来讲这个项目还是成功的：因为我学到了很多关于 Rust 的知识。

我最终还是停止了这个项目，也停止了学习 Rust 。为什么？简单来说，相比于其他互联网的门路，我开始对 Rust 是否**对我来说**有足够的价值抱有怀疑态度。对我来说有一点是很清楚的，那就是当需要对硬件和性能有严格控制的时候， Rust 是一个很不错的语言。如果给我一个有这些要求的项目，我肯定会重新使用 Rust 。但是除了 Rust 我就要用 C++ 的话，我宁愿用 Rust 。
 。

但是，大多数我写过的软件里，硬件控制通常不是一个很重要的因素。我从来没有写过 C++ ，因为简洁和可维护性对于开发周期是最重要的。性能问题几乎可以等到软件能工作后再来处理，比如做一些性能测试和机智的优化。

让我继续研究 Rust 的一个引人注目的原因是：我从来没有听谁说过 Rust 是一个对他们来说效率最高的语言，或者他们认为对一般程序员来说是一个效率最高的语言。其中的原因是，所有制体系让他们更多地思考代码，并在某些方面显著地影响着设计。我认为这是很有可能的，但我依旧没有足够的信心对 Rust 倾注大量的时间，还是把时间花在别的事上比较好吧。

不幸的是，我最终决定了我的时间还是花在学习其他东西上比较好。特别是，Haskell （最初由 Elm 演变而来）以及其他对系统有很大影响的语言。

—

系列：用 Rust 做的简单网页

* [部分 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [部分 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [部分 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [部分 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [部分 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [总结](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
