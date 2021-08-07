> * 原文地址：[5 Reasons Why Flutter Is Better Than React Native](https://betterprogramming.pub/5-reasons-why-flutter-is-better-than-react-native-cf2e9b077f66)
> * 原文作者：[Shalitha Suranga](https://medium.com/@shalithasuranga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-flutter-is-better-than-react-native.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-flutter-is-better-than-react-native.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[zaviertang](https://github.com/zaviertang)、[Chorer](https://github.com/Chorer)

# Flutter 比 React Native 更优秀的五个理由

![Photo by [Sandy Millar](https://unsplash.com/@sandym10?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/flutter?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*CuHCh8SBH_AY43P5kb2VYg.jpeg)

现在，程序员们有两个有竞争力的跨平台应用开发选择。[Flutter](https://flutter.dev/) 和 [React Native](https://reactnative.dev/)。我们可以使用这两个框架来构建跨平台的移动应用和桌面应用。这两个框架从外观和可用的功能上看确实相似。希望你已经看过关于 Flutter 和 React Native 的比较和评论。很多开发者认为 Flutter 不会被广泛使用，因为它使用了一种陌生的编程语言 [Dart](https://dart.dev/)，但编程语言只是开发人员与框架互动的一个接口。

对于一个特定的框架如何解决跨平台开发的问题，比特定框架的编程语言的流行更重要。我对 Flutter 和 React Native 的内部架构做了一些简要探索。此外，我还使用这两个框架在不同平台上创建了几个应用程序。最后，我发现如果你用 Flutter 开发你的下一个应用软件，会有以下五点好处。

## Flutter 具有近乎原生的性能

如今，由于设备的先进完善，应用的运行性能不被重视。但是用户的设备有各种不同的规格。部分用户可能试图在运行你的应用程序的同时，也运行很多其他应用程序。你的应用程序应该在所有这些条件下也能正常工作。因此，性能仍然是现代跨平台应用程序的一个关键因素。可以肯定的是没有任何框架编写的应用程序比 Flutter 和 React Native 应用程序的性能更好。但我们经常要选择一个跨平台的应用框架来快速交付功能。

一个典型的 React Native 应用有两个独立的模块：原生 UI 和 JavaScript 引擎。React Native 根据 React 状态的变化渲染本地平台特定的 UI 元素。另一方面，它使用一个 JavaScript 引擎（在大多数情况下是 [Hermes](https://github.com/facebook/hermes)）来运行应用程序的 JavaScript。每一个 JavaScript 到原生和原生到 JavaScript 的调用都要经过一个 JavaScript 连接，类似于 Apache Cordova 的设计。React Native 在最后默默地将你的应用程序与一个 JavaScript 引擎捆绑在一起。

Flutter 应用程序没有任何 JavaScript 运行时，Flutter 使用二进制信息传递通道在 Dart 和本地代码之间建立双向通信流。由于这种二进制信息传递协议和 Dart 的超前（AOT）编译过程，Flutter 为从 Dart 调用本地代码提供了接近原生的性能。当有高于平均水平的本地调用时，React Native 应用程序可能表现不佳。

## Flutter 应用程序有一个统一的 UI

React Native 会渲染特定平台的 UI 元素。例如，如果你在苹果的移动设备上运行你的应用程序，你的应用程序会渲染原生的 iOS UI 元素。每个平台都为其 UI 元素定义了独特的设计概念。有些平台的 UI 元素是其他平台所没有的。因此，如果你使用 React Native，即使是一个简单的 UI 变化也需要在多个平台上进行测试。同时，你也无法克服平台特有的 UI 元素的限制。

Flutter SDK 定义了自己的 UI 工具包。因此，Flutter 应用程序在每个操作系统上看起来都一样。与 React Native 的特定平台 UI 元素不同，Flutter 团队可以为每个 UI 元素引入新功能。由于 Flutter-theming 的存在，你可以根据用户在特定操作系统上的设置来改变应用程序的主题。

几乎所有的现代应用程序都从应用程序的设计概念中显示出它们的品牌。Flutter 激励人们在所有支持的操作系统上建立一致的用户体验，并采用一致的 GUI 层。

---

## Flutter 提供了一个富有成效的布局体系

React Native 有一个用 [Yoga](https://yogalayout.com/) 布局引擎创建的基于 FlexBox 概念的布局系统。所有的 Web 开发者和 UI 设计师都熟悉 CSS FlexBox 的造型。React Native 的布局语法与 CSS FlexBox 的布局风格。许多开发人员经常为高级 CSS 样式而苦恼，他们经常让团队的 UI 开发人员来解决 CSS。因此，如果你使用 React Native 制作你的下一个应用程序，你需要雇用一个 UI 开发人员或要求移动开发人员熟悉 CSS FlexBox 语法。

Flutter 有一个基于 widget 树的布局系统。换句话说，Flutter 的开发者通常通过覆盖 [`build`](https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html) 方法，在一个类似渲染树的数据结构中定义部件。可以想象每个小部件将如何在屏幕上呈现。如果你选择 Flutter，不需要额外的 UI 开发人员，也不要求现有的开发人员拥有 FlexBox 开发经验。即使是后端工程师也能很快熟悉这种 widget-tree 的概念，而不是 FlexBox 的概念。

多亏了 Flutter 的树状布局系统，我们可以提高跨平台应用程序的功能开发速度。当应用程序的布局变得复杂时，程序员可以通过将小部件分配给不同的 Dart 变量，将它们分组到不同的部分。

## Flutter 正式支持所有热门平台

React Native 官方只支持 Android 和 iOS 平台。然而，有几个 React Native 的分支支持桌面平台。例如，Proton Native 可以从 React Native 代码库中生成基于 Qt 和 wxWidgets 的跨平台桌面应用程序。现在开发人员并没有积极维护 Proton Native，但还有一个活跃的分支：Valence Native。

同时，微软维护着两个 React Native 分支：[`react-native-windows`](https://github.com/microsoft/react-native-windows) 和 [`react-native-macos`](https://github.com/microsoft/react-native-macos)。如果你想为现有的 React Native 应用建立一个桌面应用，倒是有几个选择。每个流行的 React Native 库都不支持所有这些分支。另外，目前还没有功能完善的 React Native 支持 Linux。

Flutter 官方支持 Android、iOS、Linux、Windows、macOS、Fuchsia 和 Web。所有支持的操作系统都使用相同的渲染后端，即 [Skia](https://skia.org/)。Flutter 通过提供高性能的 Dart-to-Native 二进制通信机制和完善的文档，激励所有插件开发者为所有平台添加实现。因此，几乎所有流行的 Flutter 插件都能在所有支持的平台上运行。

## Flutter 应用程序将在 Fuchsia 上运行自如

也许你已经知道，谷歌正在从头开始开发一个新的操作系统，即 Fuchsia。基于微内核架构的 Zircon 内核为 Fuchsia 提供动力。根据[维基百科](https://en.wikipedia.org/wiki/Google_Fuchsia)，谷歌的想法是使 Fuchsia 成为一个通用的操作系统，支持几乎所有的设备（包括嵌入式设备，例如数字手表和交通灯系统）。谷歌正在从所有现有平台的许多经验中构建 Fuchsia。因此，Fuchsia 在操作系统市场上获得成功的概率较大。

Fuchsia 正在实现 Starnix 模块，以便在 Fuchsia 内部运行 Linux 二进制文件。根据其[设计文档](https://github.com/vsrinivas/fuchsia/tree/master/src/proc/bin/starnix#starnix)，Starnix 模块仍然是一个非常实验性的模块。显然，他们正试图通过在一个类似 Docker 的容器中运行 Linux 内核来运行 Linux 二进制文件。因此，你的 React Native 应用不会在 Fuchsia 上作为一个真正的本地应用工作。如果有人希望为 React Native 添加一个 Fuchsia 后端，需要有人再做一个像 `react-native-windows` 的分支。

Flutter SDK 可能成为 Fuchsia 上默认的 GUI 应用开发工具包。因此，你的 Flutter 应用程序将在 Fuchsia 上原生工作。

## 本文总结

React Native 项目比 Flutter 项目早两年，整个 React 社区都支持它。Flutter 的社区仍然处于新兴成长阶段，因为 Flutter 没有使用 Angular，而且 Dart 在早期并不是一种像 JavaScript 那样流行的通用编程语言。我们仍然无法将 [Flutter 的功能](https://betterprogramming.pub/stop-comparing-flutters-current-stage-with-other-matured-frameworks-fcdbcf1e204b)与其他成熟的跨平台框架进行比较。但 Flutter 通过最有效的方法解决了跨平台的问题。

这两个框架都是在本地主机应用之上运行的。React Native 不能像 Flutter 那样提高性能，因为它是基于 JavaScript 运行时的架构。尝试用 Flutter 构建应用程序，不要由于 Dart 是一种陌生的语言而感到害怕。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
