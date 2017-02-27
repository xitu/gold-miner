> * 原文地址：[What Unit Tests are Trying to Tell us about Activities: Pt. 1](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt1/)
* 原文作者：[Philosophical Hacker](https://www.philosophicalhacker.com)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [tanglie1993](https://github.com/tanglie1993)
* 校对者：

![](https://www.philosophicalhacker.com/images/broken-brick.jpg)

# 单元测试试图告诉我们关于 Activity 的什么事情：第一部分

`Activity` 和 `Fragment`，可能是因为一些[奇怪的历史巧合](/post/why-android-testing-is-so-hard-historical-edition/)，从 Android 推出之时起就被视为构建 Android 应用的*最佳*构件。我们把这种想法——`Activity` 和 `Fragment` 是应用的最佳构件——称为“android-centric”架构。

本系列博文是关于 android-centric 架构的可测试性和其它问题之间的联系的，而这些问题正导致 Android 开发者们排斥这种架构。这些博文也涉及单元测试怎样试图告诉我们：`Activity` 和 `Fragment` 不是应用的最佳构件，因为它们迫使我们写出*高耦合*和*低内聚*的代码。

在本系列文章的第一部分，我想介绍一点 android-centric 架构之所以统治了这么久的原因。另外，我认为单元测试可以为摒弃 android-centric 架构提供有价值的见解。我在第一部分中也将提供一点与之相关的背景。

### 什么是 Android-Centric 架构？

在 android-centric 架构中，用户看见的每一个屏幕都*最终*基于一个主要用于和 Android 操作系统交互的类。我们接下来将发现，Diane Hackborne 和 Chet Haase 最近都表示 `Activity` 就是这样的类。因为 `Fragment` 和 `Activity` 非常相似，我认为一个每个屏幕都基于 `Fragment` 的应用也属于 android-centric 架构，哪怕这个应用只有一个 `Activity`。

MVP 和 VIPER 和 RIBLETS 和……都在 Android 社区中很火。然而，这些建议并不*必然*完全排斥 android-centric 架构。虽然可能有 `Presenter` 或 `Interactors` 或其它的东西涉及，这些对象仍是被建筑在 `Activity` 或 `Fragment` 之上的；它们仍然可以被 android-centric 组件实例化或者被委派给这些组件，每个组件对应一个用户看见的屏幕。

一个不遵循 android-centric 架构的应用有一个 `Activity` 但没有 `Fragment`。Router 和 Controller 类型的类都是 POJOs。

### 为什么是 Android-Centric 架构？

我怀疑我们采用 android-centric 架构的一部分原因是 Google 直到不久以前才搞清楚 `Activity` 和 `Fragment` 是什么。在比 Android 文档更不正规和更不明显的渠道中，[Chet Haase](https://medium.com/google-developers/developing-for-android-vii-the-rules-framework-concerns-d0210e52eee3#.1o25pxfat) 和 [Diane Hackborne](https://plus.google.com/+DianneHackborn/posts/FXCCYxepsDU) 都表示 `Activity` 并不是人们想要用来构建应用的东西。

Hackborne是这样说的：
> …从它的 Java 语言 API 和相当高层的概念来看，它像是一个典型的应用框架，用于指示应用应当如何工作。但就大部分情况而言，它不是。
> 
> 大概把 Android API 称为“系统框架”会更合适。大多数情况下，我们提供的平台 API 是用于定义一个应用如何与操作系统互动的；但对于任何从纯粹在应用内部运行的东西而言，这些 API 和它并没有什么关系。

而Haase是这样说的：

> 应用组件（activities, services, providers, receivers）是用于和操作系统互动的接口；不推荐把它们作为架构整个应用的核心。

Hackborne 和 Haase 几乎明确地反对 android-centric 架构。我说“几乎”，因为看起来他们并不反对把 `Fragment` 作为我们应用的构件。然而，尽管“ `Activity` 不是应用的合适组件” However, there’s a tension between the idea `Activity`s are not suitable app components and that `Fragment`s are, and that tension is as strong as the the many similarities between the two components.

It might even be fair to say that Google has actually suggested an android-centric architecture through the previous [Google I/O app samples](https://github.com/google/iosched) and the android documentation. The “app components” section of the Android docs is a particularly good example of this. [The section introduction](https://developer.android.com/guide/components/index.html) tells the reader that they’ll learn “how you can build the components [including `Activity`s and `Fragment`s] that define the *building blocks* of your app.”

Over the past couple of years, many Android developers – myself included – are starting to realize that `Activity`s and `Fragment`s often are not helpful building blocks for their applications. Companies like [Square](https://medium.com/square-corner-blog/advocating-against-android-fragments-81fd0b462c97), [Lyft](https://eng.lyft.com/building-single-activity-apps-using-scoop-763d4271b41#.mshtjz99n), and [Uber](https://eng.uber.com/new-rider-app/) are moving away from android-centric architecture. Two common complaints stand out: as the app gets more complicated, the code is *difficult to understand* and *too rigid to handle their varying use-cases.*

### What does Testing have to do with this?

The connection between testability and understandable, flexible code is well expressed in this quotation from *Growing Object Oriented Software Guided by Tests*:

> for a class to be easy to unit-test, the class must…be loosely coupled and highly cohesive – in other words, well-designed.

Coupling and cohesion have direct bearing on how understandable and flexible your code is, so if this quote is right and if unit testing `Activity`s and `Fragment`s is difficult – and you likely know that even if you haven’t read [my](/post/why-we-should-stop-putting-logic-in-activities/) [posts](https://www.philosophicalhacker.com/2015/04/17/why-android-unit-testing-is-so-hard-pt-1/) suggesting as much – then writing unit tests would have shown us, before Google and painful experiences did, that `Activity`s and `Fragment`s aren’t the building blocks we want for constructing our applications.

### Next Time…

In the next post, I’ll try and fail to write an example test against an `Activity` and show exactly how the tight coupling and low cohesion of `Activity`s makes testing difficult. Next, I’ll test drive the same functionality, and we’ll end up with testable code. In the following post, I’ll show how the resulting code is loosely coupled and highly cohesive and talk about some of the benefits of these properties, including how they open up novel solutions to common problems on Android, like runtime permissions and intermittent connectivity.
