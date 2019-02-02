> * 原文地址：[One Year with Flutter: My Experience](https://hackernoon.com/one-year-with-flutter-my-experience-5bfe64acc96f)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/one-year-with-flutter-my-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/one-year-with-flutter-my-experience.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：[shixi-li](https://github.com/shixi-li) [MirosalvaSun](https://github.com/MirosalvaSun)

# 我与 Flutter 的一年

![](https://cdn-images-1.medium.com/max/800/1*pO38uoqgEOZiQuzq6lDrvQ.jpeg)

这是 Flutter 美好的一年。

大概刚好一年前，我写了一篇名为[「为什么 Flutter 2018 年即将起飞」](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0)的文章。虽然 Flutter 几乎经过整个 2018 年的测试阶段才达成现在的 1.0 版本，但是它的社区和产品已经在这个过程中得到了飞速的成长，现在 Flutter 已经进入 GitHub 仓库 [star 排名前 20](https://twitter.com/timsneath/status/1079436636344049664)。而这篇文章，介绍的是我**一年来使用 Flutter 的经验**，以及我在此过程中发现的 Flutter 的**优缺点**。

过去一年我用 Flutter 做了什么：

*   使用 Flutter 重写了一个之前就已经上架 App Store 的 [iOS 应用](https://steadycalendar.com)。
*   发布免费 Flutter [速成课](https://fluttercrashcourse.com)，录制超过 5 小时的教学视频。
*   使用 Flutter 开发了一些尚未发布的小应用。

在我列出我的想法之前，先介绍一下我的技术背景，就移动开发来说我是 **iOS 开发**。另外，去年我在日常工作中也大量使用了 **React Native**。我**不打算**将 Flutter 与这些技术进行比较，但这些移动开发经验确实会影响我对 Flutter 的印象。

然后，以下就是我使用 Flutter 一年来学到的：

#### 1. Dart 简单易学，愉快使用

相比去年我在 React Native 开发中广泛使用的 [TypeScript](https://www.typescriptlang.org/) 和 [Flow](https://flow.org/)，Dart 更容易学习，语法更简单。我能够高效开发应用，必不可少的是可靠的编译器，它有明确的，定义良好的错误消息，极少的意外隐藏运行时错误。如果有足够多的人希望了解相关内容，我会写一篇更详细的例子比较。我要说的是，即使是编写中等规模的应用程序，开发人员也应该考虑强类型语言，因为这为高速开发和编写可靠代码节省了大量时间。

#### 2. 有时候仍然需要「自己动手」

涉及新技术的另一个常见情况是：需要「自己动手」写一个库对接第三方服务。例如，要使用 Mixpanel 分析我的应用程序（因为他们大方地给出了免费套餐，并且 UI 简单，清晰），我不得不自己动手封装一个库：[pure_mixpanel](https://pub.dartlang.org/packages/pure_mixpanel)，这不难，而且很有意思。

我使用 [scoped_model](https://pub.dartlang.org/packages/scoped_model) 获得了不错的实践，因为它很好的去掉了流的使用，使用方法很像 React 刚更新的 [Context API](https://reactjs.org/docs/context.html)。你可以干净利落地将业务逻辑和渲染逻辑完美地分开，并且非常容易上手。

#### 3. 架构和状态管理模式仍未成熟

Flutter 是一项新技术，因此在实践、架构模式和状态管理等方面仍然难以获得足够的意见。有些人遵循「[BLoC](https://www.youtube.com/watch?v=fahC3ky_zW0)」（business logic component）模式。因为我认为它有点过于的复杂，所以仍未确定使用它。还有 [RxDart](https://github.com/ReactiveX/rxdart) 和 [Redux for Flutter](https://pub.dartlang.org/packages/flutter_redux)，这两个我还没用过，因为它们似乎也太麻烦了。另一方面，Android 或 React 工程师似乎有不少成功实践，可能是因为他们已经习惯这种模式。

我认为整个生态系统将在 2019 年成熟，因为越来越多的人正在编写更复杂的 Flutter 应用程序。

#### 4. 热重载是个重点

关于这一点其实没什么好说的，Flutter 这个特性的重要程度，足以在本文增加这一节。Flutter 热重载很快，而且**更可靠**。对于其他技术的热重载，我真不敢这么说（告诉自己我没有黑其他技术）。

#### 5. 跨平台设计不容易

Material Design 很美好，可以让我们快速起步。显然对于某些类型的 web app 以及 Android 应用来说是个不错的选择，但是将它呈现给 iOS 用户并不是一个好主意，除非它是谷歌应用或其他非常简单的应用。iOS 用户习惯使用 CocoaTouch 风格的 UX。

「一次编写随处运行」、定制的自定义设计、引入设计常见的设计元素（例如，标签栏）等情况越来越普遍。尽管 Flutter 确实提供了大量 iOS 风格的 widget，但为了使代码易于维护，大多数人会使用封装定制后的 Flutter 的 Material Design 库，这是很容易实现的。

我将撰写另一篇关于这个主题的文章，但我的建议是坚持使用 Material Design，可以在某些方面，试着让那些 iOS 用户觉得不那么「安卓」。以表单为例，使用 Material Design 样式的表单字段对两种类型的用户都是足够熟悉的。

#### 6. 在 Flutter 中实现复杂布局很简单

我习惯使用 React、CSS Grid、Flexbox 等库来实现布局。Flutter 的布局方法从这些库中借鉴了许多。如果你已经熟悉这些基于 Web 的布局概念，那么学习 Flutter 布局将会非常简单。即使不懂 Web 布局，它仍然很简单。如果你想感受一下 Flutter 的布局方法，可以观看此[视频](https://fluttercrashcourse.com/lessons/container-layout-column-row)。

此外，从代码可读性的角度来看，Dart 和 Flutter 中的 UI 逻辑非常出色。总的来说，比起 JSX 我个人更喜欢这种布局方式。它让我想起了 Swift 和 iOS 中简单的布局逻辑（如果你是以编程方式实现布局的话）。

#### 7. 仍然需要更多关注端到端应用示例

虽然有**大量**可靠的文档，教程，社区以及与其他 Flutter 使用者的帮助，但是这些都太着重于 widget 了。Flutter 刚出来时这确实很必要。但最终，越来越多的人不仅仅是实现纯 UI 和动画，而是开始编写更多更完善的应用程序，我认为 Flutter 的网站上应该突出介绍更多的端到端教程。这也是我自己开设课程网站的主要原因。

我学习编写 Flutter 应用并不局限于仅仅使用控件。我发现有许多更高级的 Dart 功能非常有用，你必须挖掘它们。我提到的架构模式也值得挖掘。最后，集成 Web 服务和其他 Dart 最佳实践集成仍需要更多文档和教程。

#### 8. 下一个项目我将使用 GraphQL 或 gRPC

我总是争取更少的模版代码。虽然[某些工具](https://flutter.io/docs/development/data-and-backend/json)在一些简单项目中解决了我的问题，但我想我的下一个项目我会使用 [GraphQL](https://pub.dartlang.org/packages/graphql_flutter) 或 [gRPC](https://grpc.io/)。我认为对这两者的投入都是值得的。关于 gRPC，我不推荐将它用于较小的项目，但对于中大型项目，一旦你使用它，就会爱上它。gRPC 在我的一个 Swift 项目行之有效，已经投入生产环境运行好几年了。

#### 9. 在两个平台提交应用程序都很简单

你需要一定时间习惯为每个平台（特别是 Google Play 商店和 iTunes Connect）提交应用程序所需的工具和步骤，但这非常简单。我会说为 iOS 提交应用程序肯定更符合学习曲线。

#### 10. Flutter 有太多的 widget

在 Flutter 应用开发过程我认为有必要学习的那些控件中，实际被我用到的大概只有 20%。例如 [Center](https://docs.flutter.io/flutter/widgets/Center-class.html) widget，为什么需要一个**只**具备使子控件居中这样单一功能的控件？虽然它使新手很容易上手，但是在实现复杂的布局时，widget 会产生太多嵌套的Dart代码。相反，我会回到基本的 [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) 布局，因为这相比起来更灵活。

我的建议先关注于简单，基本的 widget，真正需要时再学习其他 widget。

#### 11. 我正在从 Firebase 转移（推送通知除外）

Firebase 似乎是一款出色的产品。它让我想起了当年的 [Parse](https://parseplatform.org/)。Firebase 对这些情况是比较好的选择：简单的项目，或者你将要把项目移交到没有足够后端技术人员的客户时。

但事实上，大多数产品已经有现成的后端，或者技术团队编写自己的后端。不管大型公司或者甚至是初创企业都是如此。

对于独立开发者或小团体，如果你的流量激增，每月 Firebase 账单会发生什么变化？这就是我避免使用 Firebase 的主要原因，如果我的应用真的如梦想一般被用户疯传，Firebase 找我要钱怎么办？

请注意，我的职业是编写后端系统，所以这仅仅是我的个人看法。如果你是初级开发人员，想要将简单的后端交付给客户，或者你只是不想编写后端 API，我仍然推荐使用 Firebase。

#### 12. Flutter 的文档越来越完善

Widget 和 class 文档现在有越来越多的示例（[例如](https://docs.flutter.io/flutter/widgets/Container-class.html)）。这是对比其他缺乏适当示例的库是巨大的优势，更不用说编写良好的文档了。

除了文档之外，去年 Stack Overflow 上还有很多热情、知识丰富的人为我提供技术支持。

#### 13. 即使被 iOS 开发惯坏了，也能使用 Flutter

我当 iOS 工程师很多年了，所以我有点被 iOS 开发惯坏了。不仅是文档和支持，还是 iOS 生态系统的整体质量，从库到 Xcode，再到 CocoaTouch SDK 的组织方式。

Flutter 也符合我之前的体验。它也非常简单，同时也考虑了某些 React Native 组件的简单性，比如 ListView（朋友，你使用过 iOS 的 UITableViewController 吗？Yuck）所以总的来说，有了成熟的工具来配合 Flutter，学习和使用它会非常流畅。不再需要像 Xcode 这样复杂的工具真的让人眼前一亮。

#### 14.我不会再回到「单平台」开发

游戏开发者可能永远不会只为一个平台编写一套代码。React Native 和 Flutter 出现后，「非游戏开发者」也能做到同样的事。

例如，在空闲时，我会参与夫妻经营的小项目，与我的 UX 设计师妻子编写应用程序。Flutter 重构这个 iOS 应用后，用户基数变为双倍，现在它已经在两个平台上发布，我肯定不会再考虑回到单平台了。

### 最后的想法

一年之后，我将开始编写下一个 Flutter 应用程序时（之后将会发布记录开发过程的视频！），我仍然非常高兴我将时间投入到学习 Flutter 中。我现在已经不能回到之前的开发模式。对于企业来说，作为一种用于多平台编写技术的可行选择是有意义的，而且，作为开发人员使用跨平台技术也是一种乐趣。再加上网页 Flutter 技术，比如 [Hummingbird](https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8) 以及谷歌为全新 [Fuschia 操作系统](https://en.wikipedia.org/wiki/Google_Fuchsia) 长期投入 Flutter，这些事实都表明谷歌注重这项技术。

欢迎随时通过 [Twitter](https://twitter.com/seenickcode) 与我联系。另外如果你感兴趣，可以看看我的网站 [fluttercrashcourse.com](https://fluttercrashcourse.com) 上的免费 Flutter 课程！

2019 编程快乐！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

