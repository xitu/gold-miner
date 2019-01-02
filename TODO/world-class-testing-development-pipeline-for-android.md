> * 原文链接 : [World-Class Testing Development Pipeline for Android - Part 1.](http://blog.karumi.com/world-class-testing-development-pipeline-for-android/)
* 原文作者 : [Karumi](hello@karumi.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [markzhai](https://github.com/markzhai)
* 校对者: [JustWe](https://github.com/lfkdsk), [Hugo Xie](https://github.com/xcc3641)

# 世界级的 Android 测试开发流程（一）

在开发完移动应用并和手动QA团队合作了数年后，我们决定开始写测试。作为工程师，我们知道，**自动化测试是成功的移动开发之关键。** 在这篇博客里，我将会分享我们的故事——Karumi启动于几年前的测试故事。这是系列博客的第一篇，我们将会囊括世界级的 Android测试流程的所有方面。

几年前，我们开始为移动应用写测试。我们对测试了解有限，所以我们致力于接受测试并使用最常用的框架来做单元测试，一个简单的test runner和mocking库。过了一段时间我们遇到了问题：

- 我们不知道测试什么和如何去测试它。
- 我们的代码还没准备好被测试。
- 我们沉迷于Mike Cohn的测试金字塔，却没有考虑到我们在写的软件类型。
- 即使我们的测试通过了，也不意味着代码没有问题。

是不是很可怕? 我们花了很多时间去克服这些挑战，在某个时刻我们意识到是方法错了。即便测试覆盖率很高，我们的软件仍然在出错。最坏的是，从我们的测试中，无法得到任何反馈。**解决我们的问题的关键是识别出我们一直碰到的问题所在：**

- 我们的接受测试太难写了，因为我们需要提供配置API来模拟接受测试的初始状态。
- 大部分时候，我们的测试会随机失败，而我们不知道为什么。只能用重复编译来通过测试。
- 我们有大量的单元测试和高覆盖率，但我们的单元测试从未失败。即便应用出问题了，我们的测试仍然能通过。
- 我们用很多时间去验证mock的调用。
- 我们不得不使用一些“魔法”测试工具来测试代码，一个私有方法或者模拟静态方法的调用结果。

这是我们决定停下，并开始思考为什么我们对自己的测试感觉不爽。我们快速需要找到问题的解决方案。我们的项目告诉说我们做错了，我们需要解决方案，**我们需要一个测试开发流程**。话虽如此，为了改善程序质量，测试开发流程不总是第一件要完善的事。

**一个测试开发流程定义了测什么、怎么测**。用什么工具，为什么用？测试的范围是什么？**即便有良好的测试开发流程，可测试的代码对有自信去写测试仍然是必须的**，因为大部分的测试是不可能的，或者至少，很难去写。如果你的代码没有准备好，与代码以及单元或集成范围最贴近的测试并不是那么容易去写的。因此，我们决定带着这些目标，首先识别出应用中的问题，然后去解决它们。那么问题来了，如果我们的代码能够是完美的，我们对它有何期望呢？期望是：

- 应用必须是可测试的。
- 代码必须是可读的。
- 职责必须是清晰而有结构的。
- 低耦合高内聚。
- 代码必须是诚实的。

在重构之前代码一团糟。软件职责丢失在代码的行与行之间。实现细节是完全暴露的，activities和fragments负责处理软件的状态，到处都是软件状态。另外，我们的业务逻辑和框架是耦合的。带着这些问题，我们决定把应用架构改成其他更有结构的东西。**我们使用的架构是 [“Clean Architecture”](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)。除了架构的核心内容，我们还应用了一些和GUI应用相关模式像是MVP和MMVM，以及数据处理相关的模式像是Repository模式**。架构详情和这篇博客没有关系（我们会在未来的博文中讨论到它），“Clean Architecture”的**核心元素**与**最重要的SOLID原则之一，[依赖倒置原则](http://martinfowler.com/articles/dipInTheWild.html)**相关。

**依赖倒置原则提出你的代码必须依赖于抽象而不是具体实现**。这个原则，仅仅是这个原则就是通向成功的钥匙。它是**改变我们的代码并适配测试策略以有效克服我们手上问题的关键**。依赖于抽象既无关于依赖注入框架，也无关于使用Java接口来定义类的API。然而，它与隐藏细节有关。根据不同角色，软件职责改变的点，引入[测试替身(TestDouble)](http://www.martinfowler.com/bliki/TestDouble.html)的点去创建层，大大限制了测试的范围。

**通过依赖倒置原则，我们能够去选择正确数量的代码去测试**。一旦这些点清晰了，我们就停下为所有的mocks去写测试。我们能够使用准确数字的mocks去覆盖一个测试用例，并确保我们在测试软件状态而不仅仅是组件之间的交互。

一旦应用架构清晰了，我们开始 **定义我们的测试开发流程。我们的目标是回答2个问题：我们想要测试什么？我们如何去测试它？** 在尝试找出如何分割测试，并用简单又可读的方式去写以后，我们注意到层次分离是最完美的出发点。结果，解决方案变得清晰：

我们想要测试什么?

- 独立于任何框架或者库去测试我们的业务逻辑。
- 测试我们的API集成。
- 持久化框架的集成。
- 一些通用UI组件。
- 测试黑盒场景下，从用户视角写的的接收准则。

我们想要怎么去测试?

- 这是我们在下一博客文章要说的东西，敬请期待！;)

参考:

- 世界级的Android测试开发流程幻灯片 by Pedro Vicente Gómez Sánchez. [http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android](http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android)
- Mike Cohn的测试金字塔 by Martin Fowler. [http://martinfowler.com/bliki/TestPyramid.html](http://martinfowler.com/bliki/TestPyramid.html)
- Clean架构 by Uncle Bob. [https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- 在野外的DIP by Martin Fowler.[http://martinfowler.com/articles/dipInTheWild.html](http://martinfowler.com/articles/dipInTheWild.html)
- 测试替身 by Martin Fowler. [http://www.martinfowler.com/bliki/TestDouble.html](http://www.martinfowler.com/bliki/TestDouble.html)
