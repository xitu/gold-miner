> * 原文地址：[Why Android Testing is so Hard: Historical Edition](https://www.philosophicalhacker.com/post/why-android-testing-is-so-hard-historical-edition/)
* 原文作者：[David West](https://www.philosophicalhacker.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[tanglie1993](https://github.com/tanglie1993)
* 校对者：[skyar2009](https://github.com/skyar2009), [phxnirvana](https://github.com/phxnirvana)

![](https://www.philosophicalhacker.com/images/time.jpg)

# 为什么 Android 测试如此困难：历史版本 #
          
> 作为一种职业，程序员总是完全无视自己的历史。
> 
> David West, 《Object Thinking》

大约两年以前，我写了[两篇](https://www.philosophicalhacker.com/2015/04/17/why-android-unit-testing-is-so-hard-pt-1/)[文章](https://www.philosophicalhacker.com/2015/04/24/why-android-unit-testing-is-so-hard-pt-2/) 用于尝试回答这个问题：“为什么测试 Android 应用这么困难？”在这些帖子中，我提出是 Android 应用的标准架构使得测试如此困难的。这个对于 Android 应用测试困难性的解释提出了一个更深、更历史性的问题：为什么一个如此难以测试的架构，在当初会成为开发 Android 应用的默认方式？

在本帖子中，我将推测这个问题的答案。我认为 Android 目前不理想的测试状态由三个原因造成：性能因素、应用组件类目的不明确，以及在 Android 刚推出时 TDD 和自动化测试的不成熟。

### 性能 ###

在某种程度上，代码的性能和可测试性是反相关的。就像 Michael Feathers 指出的那样，可测试的代码需要抽象层。

> ……遗留代码中一个普遍的问题是：它通常没有太多的抽象层；系统中最重要的代码通常和底层 API 调用混杂在一起。我们已经见到，它是怎样把测试复杂化的……<sup>[\[1\]](#note1)</sup>

如同 Chet Haase 所说，抽象层有性能代价。作为 Android 开发者，我们需要对其额外警惕：

> 如果有些代码很少执行……，但更清晰的风格对它有益，那么一个传统的抽象层会是正确的决定。但如果分析显示你经常反复执行某些代码路径，并在过程中造成大量内存抖动，考虑这些避免过量分配的策略……<sup>[\[2\]](#note2)</sup>

虽然 2017 年有“#perfmatters”，但性能问题在 Android 推出之初比现在更受关注。这意味着 Android API 的设计和 Android 应用的早期架构/实践是对性能非常敏感的。添加额外的抽象层用于测试，在那段时间可能是不现实的。

第一部 Android 手机，[G1](https://www.google.com/shopping/product/1556749025834621307/specs?sourceid=chrome-psyapi2&amp;ion=1&amp;espv=2&amp;ie=UTF-8&amp;q=tmobile+g1+android&amp;oq=tmobile+g1+android&amp;aqs=chrome..69i57j0l5.2528j0j4&amp;sa=X&amp;ved=0ahUKEwjilvOU0YXSAhVG8CYKHTp2BrAQuC8IjgE)，有 *192 MB  RAM* 和一个 *528MHZ* 的处理器。显然，从那以后我们已经走过了很长的路。而且在很多情况下，我们可以承受可测试性所要求的额外抽象层的代价。

我最近听 Ficus Kirkpatrick 说了一件有趣的事。它是关于在 Android 系统设计和早期的 Android 开发中，性能因素有多重要的。Ficus Kirkpatrick 是 Android 组成立时的成员之一，他在最近某期 Android Developers backstage 中提起：

> …当涉及到 CPU 周期和内存时，就出现很多 enum 之类的东西和极度节俭的哲学……这是观察 Android 早期决定的一个有趣的角度。我看到很多工程师就像在大萧条时期长大的一样，锱铢必较地节俭。 <sup>[\[3\]](#note3)</sup>

关于性能和开发速度之间的权衡，在播客中已经有了很好的讨论。Chet Haase 和 Tor Norbye 非常强调性能因素，而目前在 Facebook 工作的 Ficus Fitzpatrick 看起来更倾向于牺牲性能换取开发速度。

谁是对的——或者意见是否最终可以达成一致——对我们不重要。重要的是他们的对话，和 [关于](https://plus.google.com/105051985738280261832/posts/YDykw2hstUu) [enums](https://twitter.com/jakewharton/status/551876948469620737?lang=en)[的宣传](https://www.youtube.com/watch?v=5MzayZXtSiQ), 明确显示了 Android 系统的开发人员仍然很关心性能。这可能导致他们对于有一些性能消耗的抽象不那么热衷，哪怕这对测试有益。

### 关于 Android 组件的误解 ###

另一个造成 Android 测试环境如此恶劣的原因是我们可能完全误解了 Android 的组件类（即`Activity`, `Service`, `BroadcastReceiver`, 和 `ContentProvider`）的目的。在很长一段时间里，我以为这些类是用于方便应用开发的。Diane Hackborne 并不这样认为：

> …从它的 Java 语言 API 和相当高层的概念来看，它像是一个典型的应用框架，用于指示应用应当如何工作。但就大部分情况而言，它不是。
> 
> 大概把 Android API 称为“系统框架”会更合适。大多数情况下，我们提供的平台 API 是用于定义一个应用如何与操作系统互动的；但对于任何从纯粹在应用内部运行的东西而言，这些 API 和它并没有什么关系。

Chet Haase在他的 *Developing for Android* medium 博客中重新强调了这一点：

> 应用组件（activities, services, providers, receivers）是用于和操作系统互动的接口；不推荐把它们作为架构整个应用的核心。<sup>[\[4\]](#note4)</sup>

我认为现在大家都已经知道，[把业务逻辑写在 Activity 和其它应用组件类中，会使测试变得困难](/post/why-we-should-stop-putting-logic-in-activities/) ，因为缺乏合适的依赖注入。由于我们中有许多人会围绕这些组件建立整个应用，我们可能会过度使用它们，使应用的测试状况进一步恶化。

### Android 和单元测试的崛起 ###

有另一件事情导致了 Android 不佳的测试状况： TDD 和 Android 同时崛起。 Android 最初的版本是在 2008 年九月发布的。最早的关于 TDD 型单元测试的书之一——*TDD by Example*，仅仅比它早 3 年。

自动化测试的重要性比那时更广泛地被接受。测试的重要性影响了 Android SDK 的设计决策，以及 Android 社区对于支持测试的架构和实践的热情。


### 注: ###

1. <a name="note1"></a>
Michael Feathers, *Working Effectively with Legacy Code*, 350-351.

2. <a name="note2"></a>
Chet Haase, *[Developing for Android II The Rules: Memory](https://medium.com/google-developers/developing-for-android-ii-bb9a51f8c8b9#.p49q9k3uj)*

3. <a name="note3"></a>
“In the Beginning,” [*Android Developers Backstage*](http://androidbackstage.blogspot.com/2016/10/episode-56-in-beginning.html), ~25:00.

4. <a name="note4"></a>
Haase, *[Developing for Android VII The Rules: Framework](https://medium.com/google-developers/developing-for-android-vii-the-rules-framework-concerns-d0210e52eee3#.yegpenynu)*
