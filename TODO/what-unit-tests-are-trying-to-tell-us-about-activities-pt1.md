> * 原文地址：[What Unit Tests are Trying to Tell us about Activities: Pt. 1](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt1/)
> * 原文作者：[Philosophical Hacker](https://www.philosophicalhacker.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [tanglie1993](https://github.com/tanglie1993)
> * 校对者：[yunshuipiao](https://github.com/yunshuipiao), [skyar2009](https://github.com/skyar2009)

![](https://www.philosophicalhacker.com/images/broken-brick.jpg)

# 单元测试试图告诉我们关于 Activity 的什么事情：第一部分

`Activity` 和 `Fragment`，可能是因为一些[奇怪的历史巧合](/post/why-android-testing-is-so-hard-historical-edition/)，从 Android 推出之时起就被视为构建 Android 应用的**最佳**构件。我们把这种想法——`Activity` 和 `Fragment` 是应用的最佳构件——称为“android-centric”架构。

本系列博文是关于 android-centric 架构的可测试性和其它问题之间的联系的，而这些问题正导致 Android 开发者们排斥这种架构。这些博文也涉及单元测试怎样试图告诉我们：`Activity` 和 `Fragment` 不是应用的最佳构件，因为它们迫使我们写出**高耦合**和**低内聚**的代码。

在本系列文章的第一部分，我想介绍一点 android-centric 架构之所以统治了这么久的原因。另外，我认为单元测试可以为摒弃 android-centric 架构提供有价值的见解。我在第一部分中也将提供一点与之相关的背景。

### 什么是 Android-Centric 架构？

在 android-centric 架构中，用户看见的每一个屏幕都**最终**基于一个主要用于和 Android 操作系统交互的类。我们接下来将发现，Diane Hackborne 和 Chet Haase 最近都表示 `Activity` 就是这样的类。因为 `Fragment` 和 `Activity` 非常相似，我认为一个每个屏幕都基于 `Fragment` 的应用也属于 android-centric 架构，哪怕这个应用只有一个 `Activity`。

目前，MVP 和 VIPER 和 RIBLETS 等在 Android 社区中都很火。然而，这些建议并不**必然**完全排斥 android-centric 架构。虽然可能涉及 `Presenter` 或 `Interactors` 或其它的东西，这些对象仍是被建筑在 `Activity` 或 `Fragment` 之上的；它们仍然可以被 android-centric 组件实例化或者被委派给这些组件，每个组件对应一个用户看见的屏幕。

一个不遵循 android-centric 架构的应用有一个 `Activity` 并且没有 `Fragment`。Router 和 Controller 类型的类都是 POJOs。

### 为什么是 Android-Centric 架构？

我怀疑我们采用 android-centric 架构的一部分原因是 Google 直到不久以前才搞清楚 `Activity` 和 `Fragment` 是什么。在比 Android 文档更不正规和更不明显的渠道中，[Chet Haase](https://medium.com/google-developers/developing-for-android-vii-the-rules-framework-concerns-d0210e52eee3#.1o25pxfat) 和 [Diane Hackborne](https://plus.google.com/+DianneHackborn/posts/FXCCYxepsDU) 都表示 `Activity` 并不是人们想要用来构建应用的东西。

Hackborne 是这样说的：
> …从它的 Java 语言 API 和相当高层的概念来看，它像是一个典型的应用框架，用于指示应用应当如何工作。但就大部分情况而言，它不是。
> 
> 大概把 Android API 称为“系统框架”会更合适。大多数情况下，我们提供的平台 API 是用于定义一个应用如何与操作系统互动的；但对于任何从纯粹在应用内部运行的东西而言，这些 API 和它并没有什么关系。

而 Haase 是这样说的：

> 应用组件（activities, services, providers, receivers）是用于和操作系统互动的接口；不推荐把它们作为架构整个应用的核心。

Hackborne 和 Haase 几乎明确地反对 android-centric 架构。我说“几乎”，因为看起来他们并不反对把 `Fragment` 作为我们应用的构件。然而，尽管“ `Activity` 不是应用的合适组件”和“ `Fragment` 是应用的合适组件”两种观点之间存在着冲突，这两种组件仍然是有很多共同点的。

似乎可以说：Google 通过以前的 [Google I/O 应用样例](https://github.com/google/iosched) 和官方文档建议人们使用 android-centric 架构。Android  文档的“应用组件”一节是一个很好的例子。 [本节介绍](https://developer.android.com/guide/components/index.html) 告诉读者，他们将会学到“如何建造构成你的应用的**基本组件**（包括 `Activity` 和 `Fragment`）”。

在过去几年中，很多 Android 开发者 —— 包括我自己 —— 开始意识到 `Activity` 和 `Fragment` 通常并不是他们应用的有用的构件。包括 [Square](https://medium.com/square-corner-blog/advocating-against-android-fragments-81fd0b462c97)，[Lyft](https://eng.lyft.com/building-single-activity-apps-using-scoop-763d4271b41#.mshtjz99n) 和 [Uber](https://eng.uber.com/new-rider-app/) 在内的一些公司都正在远离  android-centric 架构。两种常见的抱怨是：随着应用不断变得更加复杂，代码变得**难以理解**以及**在处理多种用例时过于死板**。

### 测试和它有什么关系？

*Growing Object Oriented Software Guided by Tests* 中的内容很好地解释了可测试性和容易理解、灵活的代码之间的关系：

> 要想让一个类易于单元测试，这个类必须低耦合高内聚 —— 换句话说，设计得好。

耦合和内聚直接影响了你的代码的可读性和灵活性。所以如果这句话是对的而且 `Activity` 和 `Fragment` 很难进行单元测试（即使你没有看过[我的](/post/why-we-should-stop-putting-logic-in-activities/) [帖子](https://www.philosophicalhacker.com/2015/04/17/why-android-unit-testing-is-so-hard-pt-1/) 也很可能知道这一点），那么单元测试就可以告诉我们 `Activity` 和 `Fragment` 并不是理想的用于构建应用的组件。这样，我们就可以在 Google 告诉我们之前，也在痛苦的开发经验之前，发现这个结论。

### 下一次…

在下一篇帖子中，我将尝试对 `Activity` 写一个测试。这个测试将会失败，以显示低内聚高耦合的 `Activity` 使测试变得多么困难。接下来，我将用测试驱动同一个功能的实现，最终得到可测试的代码。在接下来的帖子中，我将说明所得到的代码是高内聚低耦合的，并讨论其带来的一些好处 —— 如何对 Android 常见问题提出新的解决办法，比如运行时权限，不稳定的连接等。
