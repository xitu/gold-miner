> - 原文地址：[Flutter May or May Not Be the Next Big Thing, But Kotlin Multiplatform Is Here to Stay](https://medium.com/better-programming/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay-baf1a44a692d)
> - 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay.md](https://github.com/xitu/gold-miner/blob/master/article/2020/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[zhuzilin](https://github.com/zhuzilin)、[PassionPenguin](https://github.com/PassionPenguin)

# Flutter 可能是下一个大事件，但 Kotlin Multiplatform 一直都是大事件

![Photo by [Marc Reichelt](https://unsplash.com/@mreichelt?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/8064/0*p9BRbpAgNsMKNKJS)

Google 的 Flutter 框架在过去的一年中取得了巨大的进展。它已经成为人们茶余饭后常谈的话题，有的人称它为下一个大事件，而另一些人则只是将其看作一项闪亮的新技术进行推广而已。

Flutter 的兴起对于跨平台应用程序开发来说是一个好兆头，不过却让 Android 原生开发者感到困惑，很多刚起步的 Android 原生开发者更是陷入两难境地：

- 应该坚持使用原生的 Android 和 Kotlin 还是切换到 Flutter 和 Dart 呢 ？
- Google 会大力支持 Flutter 而消灭 Android 原生开发吗？

因为原生 Android 框架和 Flutter 框架都是来自 Google 自己的技术库，所以很难两者之间做出抉择。

Google 对 Flutter 的强烈支持只会使 Android 开发人员更加担忧 Kotlin 在生态中的未来。

在讨论 Android 开发者的未来之前，我想先讨论两篇精彩的文章，它们分别对 Flutter 的未来提出了截然相反的看法。

这里是它们的简要概括：

- [Michael Long ](undefined) 在 “[isn’t the next big thing](https://medium.com/better-programming/why-flutter-isnt-the-next-big-thing-e268488521f4)” 文章中提到了一些挺有说服力的观点。Flutter 在 iOS  开发上永远都是二等公民，而且 Google 比任何人都擅长怎么快速杀死某项产品和技术。
- [Erik van Baaren](undefined) 在 “[is in fact the next big thing](https://medium.com/better-programming/why-flutter-is-in-fact-the-next-big-thing-in-app-development-8f514dd3a252)” 文章中提到了 Dart 与 Fuchsia（也许是 Android 系统的未来）兼容的方式，这是对上面意见的强烈反驳。

他们的争论虽然很有意思，但是谁也不能决定 Flutter 是否是下一件大事。

提到这些文章中的观点并不是在 Flutter 的争论中火上浇油。相反，我想将重点转移到 Android 原生开发上。

Flutter 的迅速崛起无疑让 Android 开发人员的心里担忧，因为没有人在关心 Kotlin 的未来。

虽然我们不确定 Flutter 是否为应用程序开发中的下一件大事。但现在 Kotlin 提供了跨平台支持，也就是说可以直接运行代码而忽略底层架构。这是革命性的发展成果，所以我想私下里把它称之为下一件大事。

值得庆幸的是，Kotlin 对平台独立性的支持让 Android 开发人员不会太担心。尽管移动开发社区对 Flutter 赞不绝口，但是不管 Flutter 和 Fuschia 的未来如何，Kotlin 都会一直留下来。

在深入探讨 Kotlin 充满希望的未来之前，让我们先分析一下 Google 为什么会先引入 Flutter（一项与原生 Android 竞争的技术）。

## 引入Flutter不是为了消灭原生 Android 开发者，只是未雨绸缪。

对于不了解它的人来说，Flutter 是 Google 的跨平台框架，用于构建可在 Android，iOS，Web 和 Desktop 上运行的应用。它使用 Google 的 Dart 语言，与 Java 虚拟机（JVM）不兼容。

Google 引入独立框架并非要与自己的原生 Android 进行竞争。而是由于甲骨文给他们带来的噩梦，所以打算通过引入它来对冲 Android 的风险。

对于那些不熟悉的人来说，因为 Android 设备中使用了某些 Java API 和 JVM ，所以 Oracle 和 Google 多年来一直处于法律纠纷。

而 JetBrains 推出了 Kotlin 以及之后 Google 宣布它为 Android 开发的首选语言并没有让 Google 不再担忧，这是因为 Kotlin（与 Java 一样）仍然需要 JVM 才能运行（当时，Kotlin / Native 尚处于萌芽状态）。

所以为了完全控制其软件生态系统，Google 引入了 Flutter 框架和 Fuschia OS。 Dart 是一种可编译为机器码的语言，因此不需要依赖 Oracle 的 Java 虚拟机。

同时，Fuschia OS 可能是 Google 努力摆脱基于 Linux 的设备，并确保 Android 开发的未来留在 Flutter。

但是这并不意味着很多现有的 Kotlin 的开发人员就这么被抛弃了。

## Kotlin Multiplatform 在移动开发中有着光明的未来

适用于 Android 的 Kotlin 已经被全世界的开发人员所熟知，但这只是 JetBrains Kotlin Multiplatform 项目的一个方面。

该项目的其他内容包括 Kotlin / JS（会转换 Kotlin 代码），Kotlin 标准库以及任何与 JavaScript 兼容的依赖。

但最重要的是有 Kotlin / Native 可以将 Kotlin 代码编译为本地二进制文件，而这些二进制文件无需虚拟机就可以运行。这实际上意味着可以将 Kotlin 代码用于 iOS Linux，macOS，Windows 和其他嵌入式设备。

需要注意的是 Kotlin / Native 不使用通用 UI，而仅在业务逻辑模块使用。也就是说如果使用 Kotlin / Native 构建 iOS 应用，则只需编写特定的平台 API 和/或 UI 代码（SwiftUI / UIKit）。

虽然上述这些并不能让 Kotlin / Native 暂时取代 Flutter，但它可以确保构建 100％ 的原生应用程序 - 这是任何一个跨平台方案都没有做到的。

无论如何 Kotlin 通过支持多个运行时目标（类似于 Dart）确保了 JetBrains 开发的语言不会消失，并将继续成为 Android 开发人员的重要支撑。

实际上，Jetpack Compose（Android 的声明式 UI 框架）的推出强烈表明了对平台无关性的支持，这使 Kotlin Multiplatforms 成为跨平台应用程序开发的有力竞争方案。

最后，就算 Fuschia OS 取代了 Android， Kotlin 开发人员还是会继续存在。 Android 是一个比 Flutter 大得多的生态系统，如果 JetBrains 添加了 Kotlin-to-Dart 转译器支持，那么 Kotlin 自然就能够继续支持未来的操作系统。

## 要点

尽管 Flutter 越来越受欢迎，但原生 Android 开发人员不必太担心。

Kotlin Multiplatforms 不仅解决了 Android-JVM 的难题，而且即使存在大量跨平台框架，也可以确保原生应用程序的开发得以继续进行。

Netflix 最近展示了 Kotlin Multiplatforms 确实可以[随时投入生产](https://netflixtechblog.com/netflix-android-and-ios-studio-apps-kotlin-multiplatform-d6d4d8d25d23)。

所以：

- 如果您是 Android 原生开发人员，请继续使用 Kotlin。
- 如果您是一位了解 Kotlin 并想涉足原生 iOS 生态系统的 Android 开发人员，请使用 Kotlin Multiplatform。
- 如果您想要使用跨平台框架，请使用 Flutter。

无论 Flutter 的发展前景如何，Kotlin 或 Android 原生开发地位都无法被撼动。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
