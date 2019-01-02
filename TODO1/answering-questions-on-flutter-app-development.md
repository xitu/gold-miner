> - 原文地址：[Answering Questions on Flutter App Development](https://medium.com/@dev.n/answering-questions-on-flutter-app-development-6d50eb7223f3)
> - 原文作者：[Deven Joshi](https://medium.com/@dev.n?source=post_header_lockup)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/answering-questions-on-flutter-app-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/answering-questions-on-flutter-app-development.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[zx-Zhu](https://github.com/zx-Zhu)

# 回答有关 Flutter App 开发的问题

![](https://cdn-images-1.medium.com/max/800/1*lMa5iiFWt33MxXUN7t9k6Q.png)

通过我的讲座和研讨会在与很多学生和开发人员亲自交流后，我意识到他们中很多人都对 Flutter 和应用程序开发有共同的问题，甚至还有误解。因此我决定去写一篇文章来解释这些普遍的疑惑。注意，这篇文章旨在解释一些问题，而不是对每个方面的详细表述。为简洁起见，我可能没有涉及到一些例外情况。请注意，Flutter 本身也有一个针对各种背景下的常问问题页面 [flutter.io](https://flutter.io/)，在这里我将更多地关注我经常看到的问题。虽然其中一些也包含在 Flutter 常见问题解答中，但是我还是尝试着去给出我的观点。

#### 布局文件在哪里？/ 为什么 Flutter 没有布局文件？

在 Android 框架中，我们将 Activity 分为布局和代码。因此，我们需要引用视图以在 Java 中使用它们。（当然 Kotlin 可以避免这种情况。）布局文件本身用 XML 编写，包含 Views 和 ViewGroups。

Flutter 使用一种全新的方法，而不是视图，**使用 Widget**。在 Android 中，View 就是布局的一个组件，但在 Flutter 中，Widget 几乎就是一切。从按钮到布局结构，所有的这些都是一个 Widget。他在这里的优势是**可定制性**。想象一下 Android 中的一个按钮。它具有文本等属性，可让你向按钮添加文本。但 Flutter 中的按钮不会将标题作为字符串，而是另一个 widget。这意味着，**在按钮内部，您可以拥有文本，图像，图标以及您可以想象的任何内容**，并且不会破坏布局约束。这也让你可以很容易地制作自定义 Widget，而在 Android 中制作自定义 view 是一件相当困难的事情。

#### 拖放不比在代码中进行布局更容易吗？

在某些方面，这是事实。但 Flutter 社区中的很多人都更喜欢代码方式，但这并不意味着拖放无法实现。如果你完全喜欢拖放，那么 Flutter Studio 是我推荐的一个很棒的资源，它可以通过拖放帮助你生成布局。这是一个让我印象深刻的工具，很想知道它将来会如何发展。

链接:  [https://flutterstudio.app](https://flutterstudio.app)

#### Flutter 是否像浏览器一样工作？/ 它与基于 WebView 的应用程序有何不同？

简单地回答这个问题：**为 WebView 编写的代码或类似运行的应用程序必须经过多个层才能最终执行。**从本质上讲，Flutter 通过**编译到原生 ARM** 代码来实现这两个平台上的执行。“混合”应用程序缓慢，缓慢，与它们运行的平台看起来不同。Flutter 应用程序的运行速度远远超过混合应用程序。此外，使用插件访问本机组件和传感器要比使用无法充分利用其平台的 WebView 更容易。

#### 为什么 Flutter 项目中有 Android 和 iOS 文件夹？

Flutter项目中有三个主要文件夹：lib、android 和 ios 。'lib' 负责处理你的 Dart 文件。Android 和 iOS 文件夹用于在各自的平台上实际构建应用程序，并在其上运行 Dart 文件。它们还可以帮助您为项目添加权限和特定于平台的功能。当您运行 Flutter 项目时，它会根据运行的模拟器或设备进行构建，使用其中的文件夹执行 Gradle 或 XCode 构建。**简而言之，这些文件夹为 Flutter 代码的运行成为一个完整的 APP 奠定了基础。**

#### 为什么我的 Flutter 这么大？

如果你运行 Flutter 应用程序，你知道它很快。非常**快**。它是如何做到的？在构建应用程序时，它**实际上用到了所有资源文件**，而不是仅使用特定的资源文件。为什么这有帮助？因为如果我将图标从一个更改为另一个，则不必完全重建应用程序。这就是 Flutter 调试版本如此之大的原因。创建发布版本时，只会获取所需的资源文件，并且我们会获得更多习惯的大小。Flutter 应用程序仍然比 Android 应用程序略大，但它相当小，加上 Flutter 团队一直在寻找减少应用程序大小的方法。

#### **如果我是编程新手并且我想从移动开发开始，我应该从 Flutter 开始吗？**

这有两部分答案。

1. 对于相同的页面，Flutter 非常适合编码并且代码比 Android 或 iOS 应用程序少得多。因此对于大多数应用程序，我认为不会出现重大问题。
2. 您需要记住的一件事是 Flutter 还依赖于 Android 和 iOS 项目，你至少需要熟悉那些项目结构。如果您想编写任何原生代码，你肯定需要在任一平台或两个平台上都有经验。

我的个人意见是学习 Android / iOS 一两个月，然后再开始学习 Flutter。

#### Packages 和 plugins 是什么？

Packages 允许您将新的工具或功能导入你的应用程序。Packages 和 plugins 之间有一点区别。Packages 通常是新的组件或纯粹在 Dart 中编写的代码，而 plugins 允许更多功能在设备上使用原生代码。通常在 DartPub 上，Packages 和 plugins 都被称为包，并且只有在创建新包时才明确提到区别。

#### 什么是 pubspec.yaml 文件，它有什么作用？

Pubspec.yaml 允许你定义应用依赖的包，声明你的资源文件，如图片，音频，视频等。它还允许你为你的应用设置约束。对于 Android 开发人员来说，这大致类似于 build.gradle 文件，但两者之间的差异也很明显。

#### 为什么第一个 Flutter 应用程序构建需要这么长时间？

首次构建 Flutter 应用程序时，会**构建特定于设备的 APK 或 IPA文件**。因为要用到 Gradle 和 XCode 用于构建文件，需要时间。下次重新启动或热重新加载应用程序时，Flutter 实际上会在现有应用程序之上修补更改，从而实现快速刷新。

**注意：**热重载或重启所做的更改不会设备 APK 或 IPA 文件中保存。要确保你的应用在设备上完成所有更改，请考虑停止并重新运行该应用。

#### State 是什么意思？什么是 setState()？

**简单来说，“State” 是 widget 变量值的集合。** 任何像计数器，文本等一样可以改变的东西都可以成为 State 的一部分。**想象一个柜台应用程序，主要的动态是计数器计数。计数更改时，需要刷新屏幕以显示新值。** setState() 本质上是一种告诉应用程序使用新值刷新和重建屏幕的方法。

#### 什么是有状态和无状态小部件？

太长了，简单的说：允许你刷新屏幕的 Widget是一个有状态小部件。反之则是无状态的。

详细地说，具有可以更改的内容的动态窗口小部件应该是有状态的 Widget。无状态 Widget 只能在参数更改时更改内容，因此需要在窗口小部件层次结构中的位置点之上完成。包含静态内容的屏幕或窗口小部件应该是无状态窗口小部件，但要更改内容，需要是有状态的。

#### 如何处理 Flutter 代码中的缩进和结构？

Android Studio 提供了一些工具，可以更轻松地构建 Flutter 代码。两个主要的方法是：

1. **Alt + Enter/ Command + Enter**：这使你可以轻松地在复杂的层次结构中包装和删除窗口小部件以及交换窗口小部件。要使用此功能，只需将光标指向小部件声明，然后按键即可为您提供一些选项。这种智能的感觉有时像天赐之物。
2. **DartFMT**：dartfmt 格式化您的代码以保持干净的层次结构和缩进。在你不小心移动几个括号后，它使您的代码更漂亮。

#### 为什么我们将函数传递给小部件？

我们将一个函数传递给一个小部件，主要是说“当事情发生时调用这个函数”。函数是 Dart 中的第一类对象，可以作为参数传递给其他函数。使用 Android（<Java 8） 等接口的回调有太多的样板代码用于简单的回调。

**Java 回调：**

```
button.setOnClickListener(new View.OnClickListener() {
    @override
    public void onClick(View view) {
      // Do something here
    }
  }
);
```

（请注意，这只是用于设置侦听器的代码。定义按钮需要单独的 XML 代码。）

**Dart equivalent：**

```
FlatButton(
  onPressed: () {
    // Do something here
  }
)
```

（Dart同时进行声明以及设置回调。）

这变得更加整洁，并帮助我们避免不必要的复杂化。

#### 什么是 ScopedModel / BLoC 模式？

ScopedModel 和 BLoC（业务逻辑组件）是常见的 Flutter 应用程序架构模式，可帮助**将业务逻辑与 UI 代码分离，并使用更少的有状态 widget。** 有[更好的资源](https://medium.com/flutter-community/let-me-help-you-to-understand-and-choose-a-state-management-solution-for-your-app-9ffeac834ee3)来学习这些，我不认为有理由在几行中解释它们。

我希望这篇文章能够消除一些疑问，并且我将尽力更新我遇到的常见问题。如果你喜欢这篇文章，请给我一些鼓励，如果你希望我添加其他问题，请务必发表评论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
