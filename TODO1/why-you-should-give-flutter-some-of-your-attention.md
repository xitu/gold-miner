> * 原文地址：[Why You Should Give Flutter Some of Your Attention](https://medium.com/the-andela-way/why-you-should-give-flutter-some-of-your-attention-22dd7e5cae42)
> * 原文作者：[Bruce Bigirwenkya](https://medium.com/@bruce.bigirwenkya?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-give-flutter-some-of-your-attention.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-give-flutter-some-of-your-attention.md)
> * 译者：[DateBro](https://github.com/DateBro)
> * 校对者：[Swants](https://github.com/swants)

# 为什么你需要关注一下 Flutter

![](https://cdn-images-1.medium.com/max/1000/1*ksS2oqmcv5ol9nCaMkraIw.jpeg)

跨平台移动应用开发新方式

### 什么是 Flutter

Flutter 是由 Google 开发，完全开源的一款帮助开发者短时间内在 iOS 和 Android 上开发高质量原生界面的移动应用 SDK。

Flutter 刚刚发布了 [发布预览 1](https://medium.com/flutter-io/flutter-release-preview-1-943a9b6ee65a)

### 为什么选择 Flutter 呢？

了解为什么选择 Flutter 需要明白其用途和各个平台中的开发历史。

#### 谁是 Flutter 的目标用户

*   希望打造高性能用户界面的开发者。
*   不想学习各种原生平台语言但希望进入移动应用程序开发层的 Web 应用开发者。
*   希望通过一次开发吸引更多用户的公司。
*   希望应用程序设计与他们愿景一致的设计师。

#### 历史

原生应用程序开发与跨平台开发始终有明显区别，有着各种优点和缺点。

跨平台应用的确非常有吸引力。尽管如此，它仍然在不断变化，最终填补了原生应用程序开发空间的空白。一般来说，移动开发也比较年轻（不到十年）。

[这篇文章](https://hackernoon.com/whats-revolutionary-about-flutter-946915b09514) 详细介绍了移动开发中使用的视图技术的历史。

第一个跨平台框架使用了 Web 技术并显示 Web 视图

在 Apple 发布 iOS SDK 之前，他们鼓励第三方开发人员为 iPhone 搭建 web 应用，因此用 Web 技术搭建跨平台应用是一个明显的阶段。

[响应式编程](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) 是一种强调异步数据流与事件数据流的编程范式。在动画和其他渲染要求方面，它已经越来越多地被用于用户界面开发。

像 ReactJS 这样的响应式 Web 框架使用响应式编程技术来简化 Web 视图的构建。

根据编译机制和视图类型进行技术分类

![](https://cdn-images-1.medium.com/max/800/1*pxh6w9ALI-bAYHg33zZQ2g.png)

#### “桥”

传统上，构建跨平台应用会因为在不同领域运行而面临性能损失。应用程序是用 JavaScript 开发但界面是完全原生的。不同领域的变量不能互相访问。不同领域的变量和数据交互都必须通过“桥”来完成。

例如，如果你在 Chrome 中调试 React Native 应用，这就意味着程序将在两个不同的领域运行（桌面和移动）。而这些领域通过 WebSocket 连接起来。

React Native 的优化尝试在运行时通过“桥”将数据交换保持在最低值。最终，每个环境下的运行都很流畅但跨桥的交换的延迟会增大。

Flutter 依赖 Dart 语言的静态编译解决这个问题。这意味着在运行时不再需要“桥”，因为程序会被编译成原生代码。

#### 组件

窗口组件是控制和影响应用程序的视图和界面的元素。Flutter 中万物皆组件。这使它更加自包含，可重用和可扩展。

#### 布局

传统的布局依靠的是不同 CSS 文件中定义的多项样式规则。这些规则适用于标记，因此能够为所应用的规则创造多种可能的交互和矛盾。CSS3 有大约 375 项规则。不考虑规则中可能存在的矛盾，布局的可能性通常为 N 阶平方。

Flutter 重新设计的布局更高效也更直观。布局信息由组件在建模时单独指定。这不仅使查看代码的开发者更容易理解正在发生的事，而且还意味着窗口组件没有处理可能不适用于它的规则的开销。

Flutter 团队提供了很多他们觉得用起来不错的布局组件。Flutter 也有很多围绕布局的优化，像为了只在有必要生成大体积组件时的缓存。

#### Dart

Flutter 团队使用 Dart 有以下几个原因：

*   **静态编译**
    Dart 是静态编译的。Dart VM 可以为你正在开发的平台构建本机 ARM 代码。这意味着与使用即时编译器，在程序执行时编译的应用程序相比，程序要快得多。
*   **动态编译：** Dart 也可以即时编译。Flutter 利用这种开发能力来缩短开发周期。像热重载这样的功能是可行的，因为应用程序可以轻松编译更新，从而更容易测试和迭代产品。
*  **强类型：** Dart 是一种 [强类型](https://en.wikipedia.org/wiki/Strong_and_weak_typing) 语言。如果你用过 Java 或 C#，有几个原因使得过渡到 Dart 非常理想，其中一个就是是，Dart 看起来比较熟悉，以及它的类型安全，所以你不必牺牲程序的完整性。
*   **服务端的潜力：** Dart 非常适合很多事情，包括在服务器上运行。服务器端的 Dart 越来越受人们关注。考虑到统一代码库的可能性，在 Flutter 中使用它就是一个很好的例子。

你可以从 [这里](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf) 了解更多关于 Flutter 上使用的 Dart 语言。

#### Flutter 的结构

![](https://cdn-images-1.medium.com/max/800/1*okW6pQoMLLmlAhPnGL95PA.png)

Flutter 应用的结构

#### 在 Fuchsia 上的潜力

能够在 Fuchsia 上使用。[Fuchsia](https://fuchsia.googlesource.com/) 是一个新的 [开源](https://fuchsia.googlesource.com/) 操作系统，现在由谷歌开发，这在科技爱好者圈子引起了不少的关注。不像 Android 和其他流行的操作系统，它基于一个叫做“Zircon”的微内核。Flutter 已经和 Armadillo 一起用来测试 [Fuchsia 用户界面](https://9to5google.com/2018/03/02/fuchsia-friday-first-fuchsia-app/) 的开发了。

#### 目前的不足之处

现在能感觉出的缺点是基于过去的开发者经验。这部分只用于突出 Flutter 项目的重要性和解决方案。证明了 Flutter 团队的发展速度。

你可以查看本文，以了解原生移动开发者在测试驾驶 Flutter 时面临的挑战。他们强调的一些问题在我看来非常有争议，比如缺乏 OpenGL 支持，允许 Flutter 使用 Skia，支持 OpenGL 作为其后端之一。

由于 Flutter 处于刚发布不久，其他你可能面临的可能的挑战包括：

*   动画的低级实现。这在过去对于一些需要降低水平以创作想要的动画的人来说就是一种挑战。
*   仍然缺少数据操作库。Flutter 一开始专注视觉渲染。如果你是一个非常依赖现成的社区模块和组件来实现的人，那么你可能会因为稀缺的数据操作库而艰难前行。然而，我个人觉得这个领域正在稳步成熟，Flutter 提供了很多关于构建应用程序的建议，并为人们构建库以使其产品与最佳约定保持一致铺平了道路。

#### Flutter 入门

前往 [Flutter.io](http://flutter.io/) 了解怎样入门 Flutter 。你还也查看底部参考资料部分中的内容。

总之，Flutter 入门将涉及下载 SDK 并配置使用它的路径。在你使用的编辑器中安装必要的插件是必要的下一步。

* * *

你可能在 Mac OS 上遇到[依赖缺失问题](https://github.com/flutter/flutter/issues/16428) ，这可以通过运行 **pip install six** 来解决。

当你尝试运行 flutter upgrade 时，你可能遇到的另一个问题是合并冲突。如果你已经测试了与 SDK 捆绑在一起的 Flutter 示例，就会出现这种情况。在这种情况下，在运行 Flutter 升级命令之前进入 Flutter SDK 文件夹，存储已更改的文件（git add.| git stash）非常有用。

#### 一些资源

*   Rohan Taneja 在这篇[文章](https://medium.freecodecamp.org/learn-flutter-best-resources-18f88346ed0f) 中提供了珍贵资源的一套相当详细的链接。
*   [Fluttery](https://medium.com/fluttery) 是一系列为想入门 Flutter 的人准备的教程，挑战和模式集合。
*   [Flutter studio](https://flutterstudio.app/) 也是为想简化开发过程的人准备的优秀资源。

**我很高兴尝试它。如果你也是，请告诉我！** ❤️🚀

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
