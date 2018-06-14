> * 原文地址：[Flutter for JavaScript Developers](https://hackernoon.com/flutter-for-javascript-developers-35515e533317)
> * 原文作者：[Nader Dabit](https://hackernoon.com/@dabit3?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/flutter-for-javascript-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO/flutter-for-javascript-developers.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[bambooom](https://github.com/bambooom), [allenlongbaobao](https://github.com/allenlongbaobao)

# 为 JavaScript 程序员准备的 Flutter 指南

[Flutter](https://flutter.io/) 是一款用同一套代码构建高性能、高保真的 iOS 及安卓应用的跨平台移动端应用 SDK。

[文档](https://flutter.io/technical-overview/)中提到：

> Flutter 包括一个 **react 风格**的框架、一个 2D 渲染引擎、一些预制的插件以及开发者工具。

![](https://cdn-images-1.medium.com/max/800/1*oUyZxsBi_aS6jVhL8sjCsQ.png)

文本希望能快速为 JavaScript 开发者们提供一个简练的入门指南，我会试着以 JS 与 npm 生态系统来类比 Flutter / Dart 与 [Pub](https://pub.dartlang.org/) 包库。

> 如果你对最新的 Flutter 教程、库、公告及社区的更新感兴趣，我建议您订阅双周刊 [Flutter Newsletter](http://flutternewsletter.com/)。

* * *

我在 [React Native EU](https://react-native.eu/) 的演讲 [React Native — 跨平台及超越](https://www.youtube.com/watch?v=pFtvv0rJgPw)中讨论并演示了 React 生态系统中 [React Native Web](https://github.com/necolas/react-native-web)、[React Primitives](https://github.com/lelandrichardson/react-primitives) 和 [ReactXP](https://microsoft.github.io/reactxp/) 的不同之处，并且我也有机会讨论 [Weex](https://weex.incubator.apache.org/) 及 [Flutter](https://flutter.io/) 的不同之处。

在尝试 Flutter 之后，我认为它是近几年我所关注的前端技术中最让我激动的一个。在本文中，我将讨论为何它如此令我激动，并介绍如何尽可能快的入门 Flutter。

#### 如果你认识我，那么我知道你正在想什么…

![](https://cdn-images-1.medium.com/max/800/1*GTsgYXSN2AcJZN9wZm7zhQ.jpeg)

我是一名有着超过两年半经验的 React 与 React Native 开发者。现在，我仍然看好 React 和 React Native，并且我也知道有许多大公司正在使用它们，但我仍然乐于看到其他的能达到相同目的的想法方法，这无关乎我是否要去学习或改变技术栈。

### Flutter

> 我可以做个概括：Flutter 令人惊叹, 我相信近几年它会成为更多人的选择。

在使用了几周 Flutter SDK 之后，我正在应用它制作我的第一个 App，我十分享受这个过程。

在我开始介绍如何入门 Flutter 前，我将首先回顾一下我对它的 SDK 的优缺点的看法。

![](https://cdn-images-1.medium.com/max/800/1*hl9BrVAK5rNBJnw76tmTEQ.png)

### 优点

*   内置由核心团队维护的 UI 库（Material 及 Cupertino）。
*   Dart 团队与 Flutter 团队紧密合作，专门针对 Flutter 优化移动设备的 Dart VM。
*   有着崭新的、酷炫的文档。
*   强大的 CLI。
*   我能轻松、顺利地入门与运行它，没有碰到各种障碍与 Bug。
*   开箱即用的热加载功能，使得调试的体验相当好。此外，还有[一系列关于调试技术的很好的文档](https://flutter.io/debugging/)。
*   有由核心团队构建并维护的 nav 库，可靠且有见地。
*   Dart 语言诞生 6 年了，相当成熟。虽然 Dart 是一种基于类的面向对象编程语言，但如果你想用函数式编程，Dart 也有着作为第一公民的函数，并且支持许多函数式编程结构。
*   Dart 比我想象中的更容易入门，我十分喜欢它。
*   Dart 是一种无需任何多余配置的开箱即用的强类型语言（比如：TypeScript、Flow）。
*   如果你用过 React，会发现它有类似的状态机制（比如 lifecycle 方法与 `setState`）。

### 缺点

*   你要去学习 Dart（相信我，这很简单）。
*   仍在测试中。
*   目标平台仅为 iOS 和安卓。
*   插件生态系统还很稚嫩，[https://pub.dartlang.org/flutter](https://pub.dartlang.org/flutter) [](https://t.co/KMMwbnVM6M "http://pub.dartlang.org")在 2017 年 9 月还只有 70 余个包。
*   布局与编写样式需要学习一种全新的范式与 API。
*   需要学习不一样的项目配置（pubspec.yaml vs package.json）。

### 入门及其它观点

*   Flutter 文档推荐了 VS Code 编辑器与 [IntelliJ IDE](https://www.jetbrains.com/idea/)。尽管 [IntelliJ IDE](https://www.jetbrains.com/idea/) 内置支持热加载、在线加载这些 VS Code 没有的功能，但我还是选择使用安装了 [Dart Code extension](https://marketplace.visualstudio.com/items?itemName=DanTup.dart-code) 插件的 VS Code 编辑器，并得到了很好的开发体验。
*   Flutter 有一个模块系统，或者叫包管理系统 —— [Pub Dart Package Manager](https://pub.dartlang.org/)，它与 npm 有很多不同点。它的好坏取决于你对 npm 的看法。
*   我之前并没有 Dart 相关的知识，但我很快就入门了。它让我想起了 TypeScript，并且与 JavaScript 也有一些相似之处。
*   文档中有几个相当不错的代码实验室与教程，建议去查阅一番：1. [构建 UIS](https://codelabs.developers.google.com/codelabs/flutter/index.html#0) 2. [增加 Firebase](https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#0) 3. [构建布局](https://flutter.io/tutorials/layout/) 4\. [增加交互](https://flutter.io/tutorials/interactive/)

#### **说的够多了，现在让我们开始创建一个新的工程吧！**

### 在 macOS 中安装 CLI

如果你使用的是 Windows，请查阅 [此文档](https://flutter.io/setup/)。

如需查看完整的 macOS 平台下的安装指南，请查看 [此文档](https://flutter.io/setup-macos/)。

首先，我们需要克隆包含 flutter CLI 二进制文件的 repo，然后将其添加到系统目录中。比如我将 repo 克隆到了专门用于存放二进制文件的目录下，然后将这个新目录加到了 `$HOME/.bashrc` 和 `$HOME/.zshrc` 文件中。

1.  克隆 repo：

```
git clone -b alpha https://github.com/flutter/flutter.git
```

2. 增加路径：

```
export PATH=$HOME/bin/flutter/bin:$PATH (或者填你选择的安装路径)
```

3. 在命令行中运行 flutter doctor，检测 flutter 路径能被正确识别，并安装一切所需的依赖：

```
flutter doctor
```

### 安装其它依赖

如果你要部署 iOS app，那么必须安装 Xcode；如果你要部署安卓 app，那么必须要安装 Android Studio。

**了解关于安装这两个不同平台的知识，请参阅文档**：[文档](https://flutter.io/setup-macos/#platform-setup)。

### 创建你的第一个 Flutter app

现在我们已经安装好了 flutter CLI，可以创建我们的第一个 app 了。请运行 flutter create 命令：

```
flutter create myapp
```

此命令会帮助你创建一个新的 app，进入新目录，打开 iOS 模拟器或安卓模拟器，运行以下命令：

```
flutter run
```

![](https://cdn-images-1.medium.com/max/800/1*wr4Ox5ZFThwFMdaZL9To6w.jpeg)

此命令会在你打开的模拟器中运行 app。如果你同时打开了 iOS 与安卓模拟器，你可以用下面的命令来将程序传入指定的模拟器：

```
flutter run -d android / flutter run -d iPhone
```

也可以同时运行：

```
flutter run -d all
```

此时你应该在控制台中看到了关于重启 app 的信息：

![](https://cdn-images-1.medium.com/max/800/1*gdWuSFptAuk3ljy-AagJ_w.png)

### 项目结构

你正在运行的代码处于 `lib/main.dart` 文件中。

你会发现有一个 andoird 文件夹和一个 iOS 文件夹，原生的项目存在这些目录中。

项目的配置在 `pubspec.yaml` 中，此文件与 JavaScript 生态系统中的 `package.json` 类似。

现在将目光转向 `lib/main.dart`。

在文件的头部，可以看见一个 import：

`import ‘package:flutter/material.dart’;`

这个依赖文件是哪儿来的？请查看 `pubspec.yaml` 文件，可以发现在依赖列表中单独有一个 flutter 依赖项，在这儿是引用的 `package:flutter/`。如果想添加或导入其它依赖项，那么需要将新的依赖加入 `pubspec.yaml`，然后用过 import 来使用它们。

在 `main.dart` 的头部，我们还可以看到有一个名为 main 的函数。在 Dart 中，[main](https://www.dartlang.org/guides/language/language-tour#the-main-function) 是一个特殊的、**必要的**、顶级的函数，也是 app 开始执行的地方。因为 Flutter 是由 Dart 构建的，main 也是这个工程的主入口。

```
void main() {
  runApp(new MyApp());
}
```

此函数调用了 `new MyApp()`，这个类。与 React App 类似，有一个由多个组件组合而成的主组件，然后调用 `ReactDOM.render` 或 `AppRegistry.registerComponent` 进行渲染。

### Widget

Flutter [技术总览](https://flutter.io/technical-overview/)中的一个核心原则就是：“一切皆 Widget”。

> Widget 是每个 Flutter app 的最基本的构建模块。每个 Widget 都是用户界面的一个不可变定义。与其它框架分离视图、控制器、布局和其它属性不同，Flutter 有着统一的、一致的对象模型：Widget。

类比 Web 术语或 JavaScript，你可以将 Widget 看成与 Component 类似的东西。Widget 通常由内部类构成，这些类可能包含或不包含一些本地状态（local state）或方法。

如果你观察 main.dart，可以发现类似 StatelessWidget、StatefulWidget、Center、Text 的类引用。这些都是 Widget。如果想了解所有可用的 Widget，请查阅[文档](https://docs.flutter.io/flutter/widgets/widgets-library.html)。

### 布局与编写样式

虽然 Dart 和多数 Flutter 框架都很容易使用，但进行布局与编写样式让我最开始头疼了一阵子。

需要重点注意的是，与编写 Web 样式不同，以及与 React Native 的 View 会完成所有的布局和一些样式不同，Flutter 的布局由**你选择的 Widget 类型**及**本身的布局与样式属性**共同决定，也就是说它通常取决于你使用的 Widget。

例如，[Column](https://docs.flutter.io/flutter/widgets/Column-class.html) 能接收多个子 Widget，但不接受任何样式属性（[CrossAxisAlignment](https://docs.flutter.io/flutter/widgets/Flex/crossAxisAlignment.html) 及 [direction](https://docs.flutter.io/flutter/widgets/Flex/direction.html) 等布局属性除外）；而 [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) 能接收各种布局及样式属性。

Flutter 还有一些布局专用的组件，比如 [Padding](https://docs.flutter.io/flutter/widgets/Padding-class.html)，它仅能接收一个子 Widget，但除了给子 Widget 添加 padding（边距）之外不会做其它任何事。

请参考这个完整的 [Widget 列表](https://flutter.io/widgets/layout/)，能帮你使用 Container、Row、Column、Center、GridView 及其它有着自己布局规范的组件实现布局。

### SetState 及生命周期函数

与 React 类似，Flutter 也有有状态、无状态组件或 Widget。有状态组件可以创建、更新、销毁状态，与 React 中使用的生命周期函数类似。

在 Flutter 中，也有一个名为 setState 的函数用来更新状态。你可以在我们刚才创建的项目的 `_incrementCounter` 方法中看到此函数。

更多信息请查阅：[StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html), [State](https://docs.flutter.io/flutter/widgets/State-class.html) 和 [StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html)。

### 总结

作为专门制作跨平台应用的开发者，我会保持关注 React Native 的竞争对手。对于客户来说，也多了一种选择，他们可能会因为某些原因而要求使用 Fluter。我认为 Flutter 为我的客户带来了一些他们想要的东西，比如内置的类型系统、一流的 UI 库、由核心团队维护的 nav 库等。

我会把 Flutter 加入我的技术栈中，当碰到 React Native 无法解决的问题和情况时，我将会使用 Flutter。只要我觉得可以将它用于生产环境，我会向客户展示我的第一个 Flutter app，供他们选择这个技术。

> 我叫 [Nader Dabit](https://twitter.com/dabit3)，是一名 [AWS Mobile](https://aws.amazon.com/mobile/) 的开发者，开发了 [AppSync](https://aws.amazon.com/appsync/)、[Amplify](https://github.com/aws/aws-amplify) 等应用，同时也是 [React Native Training](http://reactnative.training/) 的创始人。

> 如果你喜欢 React 和 React Native，欢迎在 [Devchat.tv](http://devchat.tv/) 订阅我们的 podcast - [React Native Radio](https://devchat.tv/react-native-radio)。

> 此外，Manning Publications 已经出版了我的书 [React Native in Action](https://www.manning.com/books/react-native-in-action)，欢迎阅读。

> 如果你喜欢这篇文章，请点个赞吧~


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

