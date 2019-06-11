> * 原文地址：[Outside-In development with Double Loop TDD](http://coding-is-like-cooking.info/2013/04/outside-in-development-with-double-loop-tdd/)
> * 原文作者：[Emily Bache](http://coding-is-like-cooking.info)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/outside-in-development-with-double-loop-tdd.md](https://github.com/xitu/gold-miner/blob/master/TODO/outside-in-development-with-double-loop-tdd.md)
> * 译者：[Yong Li](https://github.com/NeilLi1992)
> * 校对者：[Liao Malin](https://github.com/liaodalin19903)

# 利用双环 TDD 进行由外向内的开发

在我上一篇 [文章](http://coding-is-like-cooking.info/2013/04/the-london-school-of-test-driven-development/ "The London School of Test Driven Development") 中，我开始讨论伦敦派测试驱动开发（TDD），以及我认为它和传统 TDD 不同的两个特点。第一个是利用双环 TDD 进行由外向内的开发，我将在这篇文章中详细讨论。第二点是「说，而不是问」的面向对象设计，我将在 [下一篇文章](http://coding-is-like-cooking.info/2013/05/tell-dont-ask-object-oriented-design/) 中再作讨论。

### 双环 TDD

[![london_school_001](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_001-300x162.jpg)](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_001.jpg)

当你进行双环 TDD 时，你在内环上花费的时间是以分钟计的，而在外环上花费的时间是以小时或天计的。外环测试是从系统的外部用户的角度来写的，通常覆盖了粗粒度的功能，并且已部署在真实的（或至少接近真实的）环境中。在 [我的书中](https://leanpub.com/codingdojohandbook) 我把这类测试称之为「指导测试」（Guiding Test），而 Freeman 和 Pryce 称之为 「验收测试」（Acceptance Tests）。这些测试应当在客户期望不能满足时失败 —— 换而言之，它们提供了良好的回溯保护。它们也记载了系统应有的行为。（另见我的文章「[敏捷自动化测试设计的原则](http://coding-is-like-cooking.info/2013/03/principles-for-agile-test-automation-2nd-edition/)」）

我不认为双环 TDD 是伦敦派 TDD 特有的，我相信传统 TDD 开发者也会采用。这一理念早在 Kent Beck 的第一本关于极限编程的书中就存在了。但我认为伦敦派的独到之处在于由外向内的设计，并且辅之以 mock 的使用。

### 由外向内的设计

如果你使用双环  TDD，通常你会先写一个指导测试来体现一个用户是如何与你的系统交互的。这个测试会帮助你确定位于最顶层，被首先调用的，作为需求功能的入口点的函数或类。这常常是一个 GUI 组件，一个网页上的链接，或是一个命令行标志。

而对伦敦派 TDD 而言，等你开始设计那些由该 GUI 组件、网页链接或是命令行标志来调用的内环 TDD 的类或方法的时候，你很快就会意识到这些新的代码无法由自己来实现整块功能，而是需要其它的协作类来共同完成。

[![london_school_003](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_003-300x147.jpg)](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_003.jpg)

**用户观察系统，并且期望某些功能。这意味着系统的边界需要一个新的类。而这个类又进而需要更多尚未存在的协作类。**

这些协作类尚不存在，或者至少不能提供你需要的全部功能。与其在此时暂停 TDD 而去立刻开发这些新的类，你其实可以在测试中将它们替换为 mock。在你将接口和协议开发到满足需求之前，更换 mock 和实验代码通常是很容易的。如此一来，当你在设计测试用例的同时，你也在设计生产代码了。

[![london_school_004](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_004-300x145.jpg)](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_004.jpg)

**你可以将协作对象替换为 mock，这样你就能设计它们之间的接口和协议了。**

当你对你的设计满意了，并且测试也通过了以后，你就可以深入下一层开始真正实现一个协作类。当然，如果某个类又进一步需要其它协作者，你可以再将它们替换为 mock 来进一步设计这些接口。这一方法可以持续整个系统设计，通达各个架构层和抽象层。

[![london_school_005](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_005-300x186.jpg)](http://coding-is-like-cooking.info/wp-content/uploads/2013/05/london_school_005.jpg)

**你已经完成了系统边界的类，现在你可以开发它的某个协作类，并且用 mock 替换这个类进一步需要的协作类。**

这一工作方式可以让你把问题分解成可控的部件，在你每开始一个新部件之前都能把当前的部件详细规定、充分测试。你能从关注用户需求开始，然后由外向内地构建，在系统中一个部件一个部件地追踪用户交互的全过程，直到指导测试可以通过。通常在指导测试中不会将系统的部件替换成 mock，这样最终当指导测试通过的时候你就可以确信你没有忘记实现任何一个协作类。

### 在传统 TDD 中由外向内

在传统 TDD 的方法中也可以由外向内，但是用一种几乎不需要 mock 的方法。存在几种不同的策略来解决「协作类尚不存在」的问题。其中一种是从退化的用例开始设计，此时从用户视角来看几乎什么都没发生。这是一种当输出比实际用例，或者愉快路径要简单得多的时候的特例。这样你就能只用最基础的空实现，或者假的返回值来构建这一简化版的功能需求所需要的类的结构和方法。一旦结构有了，你就可以充实它（或许由内而外地进行也行）。

另外一种在传统 TDD 中由外向内的策略是，先由外向内地写测试，而当你发现你无法在某个协作类被实现之前使测试通过之时，就注释掉那个测试，转而去实现所需的协作类。最终你会发现你可以仅凭已经存在的协作者，就完全实现某个类，由此再逐步向上实现。

由外向内有时在传统 TDD 方法中也许根本行不通。你会从系统中心的某个类开始，挑出某个仅凭已有的协作者就能完全实现和测试的部件。这通常是应用的领域模型的中心的一个类。当它完成以后，你再由中心向外继续开发系统，一个一个地添加新的类。因为只使用已有的类，你就几乎不需要使用 mock。最终你也会发现你完成了所有功能，也通过了指导测试。

### 优缺点

我认为由外向内的方法是有显著优势的。它能帮助你持续关注用户的真正所需，使你构建一些真正有用的东西，而避免浪费时间粉饰打磨用户不需要的。我认为无论对传统 TDD 还是伦敦派 TDD 来说，由外向内的方法都需要技巧和训练。学会如何将功能拆解成你能一步一步来开发和设计的增量部件并非易事。但是如果你由中心向外工作，就存在你会构建用户不需要的东西的风险，或者当你抵达外层却最终发现系统并不适用，而不得不进行重构。

然而，假设你已经是由外向内工作的了，我仍认为，取决于你是在真正的生产代码中编写假的实现，还是只在 mock 中写，这两者是有所不同的。如果你在生产代码中写，你就逐步需要把它们取代为真正的功能。而如果你把假的功能放在 mock 中，它们就能永远存在于测试代码中，即使当真的功能已经实现了，它们还在那儿。这对于程序文档很有用，也能让你的测试得以继续快速执行。

话虽如此，也存在一些关于在测试中使用了很多 mock 之后的可维护性的争议。当设计更改时，除了生产代码外还要更新所有的 mock 也许代价太大了。一旦真正的实现完成了，或许内环测试就应该被删除？毕竟指导测试已经能提供你需要的全部回溯保护了，因此那些仅仅对你最初的设计有用的测试并不值得保留？我不觉得这样做就是毫无指摘的。从我和一些伦敦派支持者的讨论来看，即使他们也会删除部分的测试，但他们并不会删除所有使用了 mock 的测试。

我也仍在尝试理解这些争端，并且试着找出在怎样的场合里伦敦派 TDD 可以带来最大的收益。我希望我已经概述了由外向内的开发中，各种方法的区别。在我的下篇文章中，我将探讨伦敦派 TDD 是如何推广[「说，而不是问」的面向对象设计](http://coding-is-like-cooking.info/2013/05/tell-dont-ask-object-oriented-design/) 的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
