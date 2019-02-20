> * 原文地址：[Introducing: Flutter Widget-Maker, a Flutter App-Builder written in Flutter](https://medium.com/flutter-community/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter-231e8d959348)
> * 原文作者：[Norbert](https://medium.com/@norbertkozsir)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter.md)
> * 译者：[jerryOnlyZRJ](https://github.com/jerryOnlyZRJ)
> * 校对者：[Mirosalva](https://github.com/Mirosalva)

# 介绍一款 Flutter 的 Widget 生成器：用 Flutter 编写的应用构建工具

不只是一个布局生成器

![](https://cdn-images-1.medium.com/max/1600/1*bZoLu2GwC2seNXdAJ0i7Ow.gif)

这是一款 Flutter Widget-Maker。虽然第一眼看上去它和其他布局生成器没什么差异，但是它具有更多功能。

**可以进入我制作的应用首页查看详情**：[_https://norbert515.github.io/widget_maker/website/_](https://norbert515.github.io/widget_maker/website/)

* * *

### 主要功能

下面我将介绍的就是这款软件的主要功能

**请先记住一点，大部分功能还没完全实现。**

#### 代码与视图的无缝衔接

不需要任何的复制粘贴，你只需要拖放我们的滑块就可以自动修改代码。

![](https://cdn-images-1.medium.com/max/1600/1*9CAO5kdRqpZ3KKyQtjY4UA.gif)

可以做到微小幅度的调整。

#### 响应式编辑

拖放组件的同时也会自动编辑它的源代码。

![](https://cdn-images-1.medium.com/max/1600/1*H3F9CwctvzaFkfcSDiXKHQ.gif)

编辑中的应用可以处在运行状态。

#### 能够轻松地修改一些复杂属性

能够轻而易举地修改 `BoxDecorations`、`CustomPaints` 还有 `CustomMultiChildLayouts` 这些复杂属性。

* * *

### 项目的核心概念

**对传统的编码形式做出提升而不是取代**

区别于其他一些尽可能隐藏实际的 HTML 和 CSS 代码的 HTML 编辑器（我觉得原因可能是有些人觉得 CSS 是很可怕的），这款编辑器释放了底层代码的强大功能。

它不是将代码隐藏在图形化界面下，而是生成清晰、易读和可靠代码的同时，还可以通过图形化界面实现组件可视化和可编辑的特性。

**没有平台限制**

这款 Widget-Maker 软件能够在所有的桌面平台上运行。不仅如此，得益于 Hummingbird 项目，它能直接在网页上运行。

除了能够在移动设备上运行编辑器之外，我还会考虑让用户能够在手机上编译自己的应用程序。我做了一些研究，我很确定我的想法是可行的。

![](https://cdn-images-1.medium.com/max/1600/1*tZoNGhSjm0GUk-vmTGQI0Q.gif)

应用程序在平板电脑上运行

**不需要任何花里胡哨的配置**

当 widget 生成器打开一个包含 widget 的 dart 文件时，widget 生成器会自动捕获分析 widget 并展示视图编辑器界面。。

**适用于每个人**

无论你是 Flutter 的新手，或者自从 alpha 版本就开始进行 Flutter 编码，都没关系，Widget-Maker 将为每个人带来价值。

* * *

### 快速的反馈回路

在我看来，快速的反馈回路能够为你带来最大的生产力提升。虽然 Flutter 的热重载做的很好，但是有些地方还可以做些优化。

我想谈谈一个例子：开发响应式布局。

你会做的就是编写代码并检查它在小型设备上的呈现，然后再在平板电脑上观察其呈现。

你也可能有幸拥有支持调整大小的设备模拟器、嵌入器，与同时打开多个物理设备、模拟器相比，这已经是一个巨大的进步。但是你仍然需要更改代码，然后将窗口调整为一堆不同的大小并不断重复这一操作。

但 Widget-Maker 的工作流程可能如下所示：

在一个图形化界面中打开不同大小的 Flutter 应用程序，在滑动滑块时实时更新，例如，控制其中一个 Expanded 的 flex 值。

* * *

### 未来可能做的一些尝试

我不想把现在的所有想法都拿来讨论，只是因为我首先要在扩展之前让它变得健壮（我有太多的想法），但这里有一些我的想法，而且有一天很有可能会让它成为现实：

#### 通过 keyframes 实现动画

工作流程：

选择一个属性并设置 keyframe，按下按钮或者触发其他操作，选择相同的属性并添加另一个 keyframe。

动画的代码立刻就能生成并能使用。

#### 即时编写测试

组件测试：自动生成组件的预期结果图像（待比较的组件图像）和常用的 assertions 方法（实际设置的颜色等等）。

集成测试：点击你的应用程序并设置 assert（就像安卓的 Robolectric），然后生成（能够在无头浏览器中运行的）组件测试用例和在实际设备上的测试用例。

#### 共享和下载组件

与 pub（Dart 包管理器）类似，但专注于组件

主要区别是：

1.  无需向 `pubspec.yaml` 文件添加任何内容
2.  可以预览组件的效果并查看源代码
3.  从 Web 中拖放组件
4.  共享和浏览组件

### 下载程序

传送门：[https://github.com/Norbert515/flutter_ide/releases/tag/v0.1-alpha](https://github.com/Norbert515/flutter_ide/releases/tag/v0.1-alpha)

只需解压缩文件夹并运行 `run.bat` 文件即可。

如果它不起作用，请尝试安装C ++运行时文件：([https://aka.ms/vs/15/release/vc_redist.x64.exe](https://aka.ms/vs/15/release/vc_redist.x64.exe))

* * *

### 你能为这个项目做哪些贡献？

我觉得这会是个大项目，但我需要你们的意见反馈。

在深入研究这个（一些人认为我已经做到了）项目之前，我需要确认大家对这个项目是否真正感兴趣。

为此，我制作了当前的演示版，可供下载和播放。但希望大家能记得，这只是一个演示版，它还有一些即将完成修复的 bug。

如果你喜欢这个项目或有什么意见建议，请通过电子邮件或 Twitter 或者其他方式告知我。我得到的反馈越多越好，这样我就可以对该项目的未来作出更明智的决定。

**PS. 感谢 [Simon Lightfoot](https://twitter.com/devangelslondon?lang=en) 在最后阶段给予的帮助 :)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
