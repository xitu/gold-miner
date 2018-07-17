> * 原文地址：[Practical Flutter: 6 Tips for Newcomers](https://hackernoon.com/practical-flutter-my-personal-6-tips-for-newcomers-dfbe44a29246)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-flutter-my-personal-6-tips-for-newcomers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-flutter-my-personal-6-tips-for-newcomers.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# Flutter 实用指南：给初学者的 6 个小帖士

![](https://cdn-images-1.medium.com/max/800/1*49JRIXl5TjmS9GWjlyr7Sw.jpeg)

我刚刚在 [Google Play 商店](https://play.google.com/store/apps/details?id=com.manninglabs.steady) 提交了一款名为 [Steady Calendar](https://www.steadycalendar.com) 的应用，这是一款追踪极简主义习惯的应用，由我的妻子 [Irina](https://www.behance.net/irinamanning) 设计，并且在我成为父亲一小段空闲时间内独立开发出来的。此 App 由 iOS 移植到了 Flutter。在上周由 @[flutterfyi](https://twitter.com/flutterfyi) 组织的 [Flutter Camp](https://flutter.camp) 上谈到的经验分享 ([演示文稿](https://docs.google.com/presentation/d/1YQP7Qz1-4xRQWmOhwhswDTexmOl456RZPko45lhh-KU/edit#slide=id.gcb9a0b074_1_0))，我决定将我的谈话归结为对每个人来说更加丰富的东西, 成为即将到来的 Flutter 课程 —— [Flutter 实用指南](https://mailchi.mp/5a27b9f78aee/practical-flutter)的前奏。

好吧，在写完这个应用之后，我几乎没有多余的时间，而且没有削减太多的角落，我浪费了很多时间，因为我认为我必须了解 Flutter，这最终不是很有用并且排序失去的时间。

所以说，这里提供一些给 Flutter 新人的建议。

### 1. 在开始使用组件时尽可能保持简单

Flutter 在示例代码及其大多数库中大量使用了 [Material Design](https://material.io/design/) 组件。如果你想快速获得 UI，或者没有时间同时编写 Android 和 iOS 应用，请坚持使用 Material Design。

然而，Material Design 的问题在于它可能会疏远你的 iOS 用户，除非能适当地个性化定制。Google [最近一直在努力](https://www.theverge.com/2018/5/10/17339230/google-material-design-theme-update-new-tools-matias-duarte)使它的库更加灵活，并展示其兼容性，鼓励开发人员摆脱那些看起来像 Google Docs 的枯燥，重复的 UI。

Flutter 确实提供了 “Cupertino” [iOS 风格组件](https://flutter.io/widgets/cupertino/)，但是以需要进行大量代码拆分为代价的，因为这些组件需要其他[父组件](https://www.crossdart.info/p/flutter/0.0.32-dev/src/cupertino/scaffold.dart.html)才能正常工作。此外，在最近的一次活动中与其中一名员工交谈了解到，Google 并未专注于提供全面的、完善的 iOS 组件。

在我的下一个应用中，我将大量定制 Material Design 来满足设计需求。这里有一些你可能想要学习的组件，你可以灵活运用你的时间来学习：

*   [Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html) 以及 AppBar（分别用于屏幕和导航栏的 Container）
*   [Layouts](https://flutter.io/tutorials/layout/)，能够使用 Column、Row
*   [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) (能够设置 ‘padding’、‘decoration’ 等)
*   [Text](https://flutter.io/widgets/text/)
*   [AssetImage](https://flutter.io/assets-and-images/)（[NetworkImage](https://flutter.io/cookbook/images/network-image/) 作为 Bonus）
*   RaisedButton（从现在起忘记 icon）

### 2. 从第一天开始忘记学习 Dart

Flutter 使用了 [Dart](https://www.dartlang.org)，这个语言非常容易学习，即使是刚接触软件开发的人也是如此。然而，让应用运行并渲染一些简单的 UI 根本不需要任何 Dart 知识。

在你熟悉了布局的基本知识，能在页面上获取一些内容之后，再花一点单独的时间去阅读下 Dart。之后，你将准备学习诸如处理事件（即点击按钮）之类的内容，甚至可能从 API 中获取数据，具体取决于你的经验水平。

### 3. 从现在起坚持使用无状态的组件

‘StatelessWidget’ 是任何 Widget 在 Flutter 中扩展的一个默认类。顾名思义，它们用于渲染不需要保持任何状态的组件。

与之相对的是 ‘**Statefull** Widget’，Flutter 的文档通过展示，如何说明、处理事件和更改页面上的某些信息来呈现的。如果你是编程新手或初级开发人员，那么一开始就不需要学习这一点。我之所以这么说，是因为在学习任何东西之初，动力是继续前进的关键，你的主要关注点应该是能用一些内容去渲染漂亮的屏幕。

### 4. 建立一些“激励里程碑”

此外，在学习任何东西时，达到一些重要的里程碑是保持动力的关键。以下是我推荐的一些学习里程碑：

*   第一个里程碑：能够开发具有简单布局、文本、非工作按钮和图像的页面。
*   第二个里程碑：能够在真机上运行你的应用。这个非常酷，真的让人很有动力。
*   第三个里程碑：学习如何连接按钮，更改某些状态，并使用 StatefulWidget 在屏幕上渲染它。
*   第四个里程碑：花几个小时阅读 Dart（如果你愿意，这一步甚至可以在上一个里程碑之前）。
*   第五个里程碑：能够从公共 API（[示例](https://github.com/toddmotto/public-apis)）获取一些数据并在页面上渲染。学习如何使用和反序列化 JSON。
*   第六个里程碑：向朋友发布实际的 iOS 和/或 Android 版本。这会让你感到惊讶，但我真的相信尽早这么做，除非你还在评估 Flutter 是否适合你。显示您编写的应用程序，即使它对朋友和家人一无所知，并通过 iTunes Connect 或 Google Play商店（更简单）将其尽早发送给测试用户。这是保持动力的真正令人惊叹的方式，并确信有一天你可以向公众推出应用程序。

### 5. 学会如何获得帮助

如果在 Stack Overflow 上找不到问题的答案，请习惯使用 [Flutter Google Group](https://groups.google.com/forum/#!forum/flutter-dev)。在实际提问时，我建议前者优先于 Stack Overflow。你可以在[这里](https://flutter.io/faq/#where-can-i-get-support)阅读更多建议。

尝试找一些可以帮助你的导师。你会发现 Flutter 社区的人们非常投入和热情。

### 6. 分享你的作品

我认为 Twitter 是分享你作品的一个不错的方式。即使是个简单的功能，简单地发布一张应用截图并提及 @[flutterio](http://twitter.com/flutterio) 就真的非常激励了。

### 学习结语

总的来说，在学习资源方面，你有很多可以去使用，但我仍未发现有足够实际的、点对点、经过实战考验的 Flutter 教程。当然，Google 制作的 YouTube 视频以及 Udacity 课程都非常棒。但是，这些课程只能覆盖你在应用商店里上架真正的应用所需要学习知识的五分之一。我之所以这么说是因为，最近我写了一个从 iOS 到 Flutter 端的简单应用：Steady Calendar，我发现像 JSON、API、管理多个构建环境、本地化、缓存、代码组织、状态管理、为设计真正的自定义 UI 调整资料等等，都需要深入挖掘。

所以，**我计划发布一个测试版 Flutter 课程**，在此你将把我学习 Flutter 的经验，总结为实用的、更“点对点”类型的教程，这些教程将重点关注 Flutter 和所有可能需要写真正上架应用的一些技术诀窍。

如果你想在我 18 年 7 月发布第一课时注册收到通知，请在此处注册：[实用的 Flutter 教程](https://mailchi.mp/5a27b9f78aee/practical-flutter).

祝你在 Flutter 的世界里玩的开心！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
