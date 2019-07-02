> * 原文地址：[MDC-104 Flutter: Material Advanced Components (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)
> * 译者：[DevMcryYu](https://github.com/DevMcryYu)
> * 校对者：[iceytea](https://github.com/iceytea)

# MDC-104 Flutter：Material 高级组件（Flutter）

## 1. 介绍

> Material 组件（MDC）帮助开发者实现 [Material Design](material.io/develop)。MDC 由谷歌团队的工程师和 UX 设计师创造，为 Android、iOS、Web 和 Flutter 提供很多美观实用的 UI 组件。

在 MDC-103 教程中，自定义定制了 Material 组件（MDC）的颜色、高度、排版和形状来给你的应用设置样式。

Material Design 系统中的组件执行一些预定义的工作并具有一定特征，例如一个 button。然而一个 button 不仅仅是用来给用户执行操作的，它可以用其形状、尺寸和颜色表达一种视觉体验，让用户知道它是可交互的，触摸或点击它时可能会有事情发生。

Material Design 指南以设计师的角度来描述组件。它们描述了跨平台可用的基本功能以及构成每个组件的基本元素。例如，一个背景包含一个背层内容、前层内容及其本身的内容、运动规则和显示选项。根据每个应用的需求、用例和内容可以自定义每个组件，包括传统的视图、控件以及你所处平台 SDK 的功能。

Material Design 指南命名了很多组件，但不是所有的组件都可以很好的被重用，因此无法在 MDC 中找到它们。你可以自己塑造这样的经历，实现使用传统代码自定义你的应用样式。

### 你将构建一个

本教程里，将把 Shrine 应用的 UI 修改成名为“背景”的两级展示。它包含一个菜单，列出了用于过滤在不对称网格中展示的产品的可选类别。在本教程中，你将使用如下 Flutter 组件：

*   形状（Shape）
*   动作（Motion）
*   Flutter 小部件（在往期教程中所使用的）

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/a533be3bc12ef2f7.png)

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/42b6ae2cb79fc507.png)

> 这是四篇教程中的最后一篇，它将指导你构建一个名为 Shrine 的应用。我们建议你阅读每篇教程，跟随进度逐步完成此项目。
>
> 有关教程可以在这里找到：
>
> *   [MDC-101: Material 组件（MDC）基础](https://codelabs.developers.google.com/codelabs/mdc-101-flutter)
> *   [MDC-102: Material Design 结构和布局](https://codelabs.developers.google.com/codelabs/mdc-102-flutter).
> *   [MDC-103: Material Design Theming 的颜色、形状、高度和类型](https://codelabs.developers.google.com/codelabs/mdc-103-flutter)

### 此教程中的 MDC-Flutter 组件

*   形状（Shape）

### 你将需要

*   [Flutter SDK](https://flutter.io/setup/)
*   安装好 Flutter 插件的 Android Studio，或者你喜欢的代码编辑器
*   示例代码

### 要在 iOS 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS 的计算机
*   Xcode 9 或更新版本
*   iOS 模拟器，或者 iOS 物理设备

### 要在 Android 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS、Windows 或 Linux 的计算机
*   Android Studio
*   Android 模拟器（随 Android Studio 一起提供）或 Android 物理设备

## 2. 安装 Flutter 环境

### 前提条件

要开始使用 Flutter 开发移动应用程序，你需要：

*   [Flutter SDK](https://flutter.io/setup/)
*   装有 Flutter 插件的 IntelliJ IDE，或者你喜欢的代码编辑器

Flutter 的 IDE 工具适用于 [Android Studio](https://developer.android.com/studio/index.html)、[IntelliJ IDEA Community（免费）和 IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/download/)。

要在 iOS 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS 的计算机
*   Xcode 9 或更新版本
*   iOS 模拟器，或者 iOS 物理设备

要在 Android 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS，Windows 或者 Linux 的计算机
*   Android Studio
*   Android 模拟器（随 Android Studio 一起提供）或 Android 物理设备

[获取详细的 Flutter 安装信息](https://flutter.io/setup/)

> **重要提示**：如果连接到计算机的 Android 手机上出现“允许 USB 调试”对话框，请启用**始终允许从此计算机**选项，然后单击**确定**。

在继续本教程之前，请确保你的 SDK 处于正确的状态。如果之前安装过 Flutter SDK，则使用 `flutter upgrade` 来确保 SDK 处于最新版本。

```
flutter upgrade
```

运行 `flutter upgrade` 将自动运行 `flutter doctor`。如果这是首次安装 Flutter 且不需升级，那么请手动运行 `flutter doctor`。查看显示的所有 ✓ 标记；这将会下载你需要的任何缺少的 SDK 文件，并确保你的计算机配置无误以进行 Flutter 的开发。

```
flutter doctor
```

## 3. 下载教程初始应用程序

### 从 MDC-103 继续？

如果你完成了 MDC-103，那么本教程所需的代码应该已经准备就绪。跳转到：**添加背景菜单**。

### 从头开始？

[下载入门程序](https://github.com/material-components/material-components-flutter-codelabs/archive/104-starter_and_103-complete.zip)

初始程序位于 `material-components-flutter-codelabs-104-starter_and_103-complete/mdc_100_series` 目录下。

### ...或者从 GitHub 克隆它

从 GitHub 克隆此项目，运行以下命令：

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 104-starter\_and\_103-complete
```

> 更多帮助：[从 GitHub 克隆一个仓库](https://help.github.com/articles/cloning-a-repository/)

>  **正确的分支**
>
> 教程 MDC-101 到 MDC-104 在前一个基础上持续构建。MDC-103 的完整代码将是 MDC-104 的初始代码。代码被分成多个分支。要列出 GitHub 中的分支，使用如下命令：
>
> `git branch --list`
>
> 想要查看完整代码，切换到 `104-complete` 分支。

建立你的项目

以下步骤默认你使用的是 Android Studio (IntelliJ)。

### 创建项目

1. 在终端中，导航到 `material-components-flutter-codelabs`

2. 运行 `flutter create mdc_100_series`

![](https://lh5.googleusercontent.com/J9CQ2xQy4PCirtParnKTrQbjo5tdy0LEh__NVXEjkSYdwSl96QWiwyX2fAdQcW5jTCUzVSzpAqF9-f5mfvyg9BE299XA5nNawKXkAKAO9KIJWawpJtEucLXwqi9buzCX3D7UJixV)

### 打开项目

1. 打开 Android Studio。

2. 如果你看到欢迎页面，单击**打开已有的 Android Studio 项目**。

![](https://lh5.googleusercontent.com/q3QrMqM5NUKXvHdNL4f-OPx1WQJCiXZuq0XJzExqbMK6NrSEigfggRFuJ9C9zpqOCsl0uWfywG1_6W1B45xrafR2EGTP68B0Yr0QtGAu3NWCdnylzYHWEp-as7AkYj8S5oNwFzr-)

3. 导航到 `material-components-flutter-codelabs/mdc_100_series` 目录并单击打开，这将打开此项目。

**在构建项目一次之前，你可以忽略在分析中见到的任何错误。**

![](https://lh4.googleusercontent.com/eohV4ysnGI7n1WXZEpvDocqGoj2yBijhLPxkGovkL85mil0HSvbQxgJ4VlduNj1ypfOdVd1fyTxR5QnS31iu0HFaqjWcOY2GqWs2hHFNO4-zqQzj-S8rGGH0VqrOEtAFEbzUuCxB)

4. 在左侧的项目面板中，如果看到测试文件 `../test/widget_test.dart`，删除它。

![](https://lh4.googleusercontent.com/tbOkXg3PBYapj_J0CpdwQTt-sqnf7s3bqi7E3Dd__z_aC5XANKphvuoMvmiOFfBR6oDeZixE0Ww2jTzskt1sDNgEXjAJjwHr7m242tkZ7VvXGaFMObmSIZ06oC7UQusGgCL7DpHr)

5. 如果出现上图提示，安装所有平台和插件更新或 FlutterRunConfigurationType，然后重新启动 Android Studio。

![](https://lh5.googleusercontent.com/MVD7YGuMneCprDEam1Vy8NusO9BPmOZTyrH4jvO8RmsfTeu8q-t0AfHU3kzXk1F8EUgHaFbqeORdXc7iOcz5ZLM4qbXsv_tMiVnAi0i68p0t957RThrZ56Udf-F292JgRV3iKs7T)

> **提示**：确保你已安装 [Flutter 和 Dart 插件](https://flutter.io/get-started/editor/#androidstudio)。

### 运行初始程序

以下步骤默认你在 Android 模拟器或真实设备上进行测试。如果你安装了 Xcode，则也可以在 iOS 模拟器或设备上测试。

1. 选择设备或模拟器

如果 Andorid 模拟器尚未运行，选择 **Tools -> Android -> AVD Manager** 来[创建并运行一个模拟设备](https://developer.android.com/studio/run/managing-avds.html)。如果 AVD 已存在，你可以直接在 IntelliJ 的设备选择器中启动模拟器，如下一步所示。

（对于 iOS 模拟器，如果它尚未运行，通过选择 **Flutter Device Selection -> Open iOS Simulator** 来在你的开发设备上启动它。）

![](https://lh5.googleusercontent.com/mmcO6QRlA96Sc1AZhL8NqvaTE9DZL5q3QQJsrx-2U4ptShFUcrmYoEuVLB6uyAxL4F80dFaxiotLmWjtTYUYYJu-Rf9TtoKDcJLlzuyWezQIz0BiIIBsgy7mPNS8bO5VbqcMb1Qt)

2. 启动 Flutter 应用：

*   在你的编辑器窗口顶部寻找 Flutter Device Selection 下拉菜单，然后选择设备（例如，iPhone SE / Android SDK built for \<version>）。
*   点击**运行**图标（![](https://lh6.googleusercontent.com/Zu8-cWRMCfIrBGIjj4kSW-j8KBiIqVe33PX8Mht5lSKq00kRB7Na3X0kC4aaiG-G7hqqqLPpgtbxTz-1DdYbq2RiNvc2ZaJzfiu_vVYAh1oOc4TZu85pa42nFqqxmMQWySzLWeU1)）。

![](https://lh4.googleusercontent.com/NLXK-hHFYnHBPeQ6NYrKGnXpj9X2es9her6Y14CotXlR-OdSQBXHyRFv1nvhC1AFCmWx7jIG2Ulb7-OmLV_Pru_-kd-3gArn8OKEGTIOInDJlqIUJ7dxTQUsvLVa0CJwEO5EGjeu)

> 如果你无法成功运行此应用程序，停下来解决你的开发环境问题。尝试导航到 `material-components-flutter-codelabs`；如果你在终端中下载 .zip 文件，导航到 `material-components-flutter-codelabs-...` 然后运行 `flutter create mdc_100_series`。

成功！上一篇教程中 Shrine 的登陆页面应该在你的模拟器中运行了。你可以看到 Shrine 的 logo 和它下面的名称 "Shrine"。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/58aa28868bf094a0.png)

> 如果应用没有更新，再次单击 “Play” 按钮，或者点击 “Play” 后的 “Stop”。

## 4. 添加背景菜单

背景出现在所有其他内容和组件后面。它由两层组成：后层（显示操作和过滤器）和前层（用来显示内容）。你可以使用背景来显示交互信息和操作，例如导航或内容过滤。

### 移除 home 的应用栏

HomePage 的小部件将成为前层的内容。现在它有一个应用栏。我们将应用栏移动到后层，这样 HomePage 将只包含 AsymmetricView。

在 `home.dart`中，修改 `build()` 方法使其仅返回一个 AsymmetricView：

    // TODO：返回一个 AsymmetricView（104）
    return  AsymmetricView(products: ProductsRepository.loadProducts(Category.all));

### 添加背景小部件

创建名为 **Backdrop** 的小部件，使其包含 `frontLayer` 和 `backLayer`。

`backLayer` 包含一个菜单，它允许你选择一个类别来过滤列表（`currentCategory`）。由于我们希望菜单选择保持不变，因此我们将 Backdrop 继承 StatefulWidget。

在 `/lib` 下添加名为 `backdrop.dart` 的文件：

```
    import 'package:flutter/material.dart';
    import 'package:meta/meta.dart';

    import 'model/product.dart';

    // TODO：添加速度常量（104）

    class Backdrop extends StatefulWidget {
      final Category currentCategory;
      final Widget frontLayer;
      final Widget backLayer;
      final Widget frontTitle;
      final Widget backTitle;

      const Backdrop({
        @required this.currentCategory,
        @required this.frontLayer,
        @required this.backLayer,
        @required this.frontTitle,
        @required this.backTitle,
      })  : assert(currentCategory != null),
            assert(frontLayer != null),
            assert(backLayer != null),
            assert(frontTitle != null),
            assert(backTitle != null);

      @override
      _BackdropState createState() => _BackdropState();
    }

    // TODO：添加 _FrontLayer 类（104）
    // TODO：添加 _BackdropTitle 类（104）
    // TODO：添加 _BackdropState 类（104）
```

导入 **meta** 包来添加 `@required` 标记。当构造函数中的属性没有默认值且不能为空的时候，用它来提醒你不能遗漏。注意，我们在构造方法后再一次声明了传入的值的确不是 `null`。

在 Backdrop 类定义下添加 `_BackdropState` 类：

```
    // TODO：添加 _BackdropState 类（104）
    class _BackdropState extends State<Backdrop>
        with SingleTickerProviderStateMixin {
      final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

      // TODO：添加 AnimationController 部件（104）

      // TODO：为 _buildStack 添加 BuildContext 和 BoxConstraints 参数（104）
      Widget _buildStack() {
        return Stack(
        key: _backdropKey,
          children: <Widget>[
            widget.backLayer,
            widget.frontLayer,
          ],
        );
      }

      @override
      Widget build(BuildContext context) {
        var appBar = AppBar(
          brightness: Brightness.light,
          elevation: 0.0,
          titleSpacing: 0.0,
          // TODO：用 IconButton 替换 leading 菜单图标（104）
          // TODO：移除 leading 属性（104）
          // TODO：使用 _BackdropTitle 参数创建标题（104）
          leading: Icon(Icons.menu),
          title: Text('SHRINE'),
          actions: <Widget>[
            // TODO：添加从尾部图标到登陆页面的快捷方式（104）
            IconButton(
              icon: Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
              // TODO：打开登录（104）
              },
            ),
            IconButton(
              icon: Icon(
                Icons.tune,
                semanticLabel: 'filter',
              ),
              onPressed: () {
              // TODO：打开登录（104）
              },
            ),
          ],
        );
        return Scaffold(
          appBar: appBar,
          // TODO：返回一个 LayoutBuilder 部件（104）
          body: _buildStack(),
        );
      }
    }
```

`build()` 方法像 HomePage 一样返回一个带有 app bar 的 Scaffold。但是 Scaffold 的主体是一个 **Stack**。Stack 的孩子可以重叠。每个孩子的大小和位置都是相对于 Stack 的父级指定的。

现在在 ShrineApp 中添加一个 Backdrop 实例。

在 `app.dart` 中引入 `backdrop.dart` 及 `model/product.dart`:
```
    import 'backdrop.dart'; // 新增代码
    import 'colors.dart';
    import 'home.dart';
    import 'login.dart';
    import 'model/product.dart'; // 新增代码
    import 'supplemental/cut_corners_border.dart';
```

在 `app.dart` 中修改 ShrineApp 的 `build()` 方法。将 `home:` 改成以 HomePage 为 `frontLayer` 的 Backdrop。
```
        // TODO：将 home: 改为使用 HomePage frontLayer 的 Backdrop（104）
        home: Backdrop(
          // TODO：使 currentCategory 持有 _currentCategory （104）
          currentCategory: Category.all,
          // TODO：为 frontLayer 传递 _currentCategory（104）
          frontLayer: HomePage(),
          // TODO：将 backLayer 的值改为 CategoryMenuPage（104）
          backLayer: Container(color: kShrinePink100),
          frontTitle: Text('SHRINE'),
          backTitle: Text('MENU'),
        ),
```

如果你点击运行按钮，你将会看到主页与应用栏已经出现了：

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/19d0457f72708f20.png)

backLayer 在 frontLayer 的主页后面插入了一个新的粉色背景。

你可以使用 [Flutter Inspector](https://flutter.io/inspector/) 来验证在 Stack 里的主页后面确实有一个容器。就像这样：

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/58aa28868bf094a0.png)

现在你可以调整两个层的设计和内容。

## 5. 添加形状（Shape）

在本小节，你将为 frontLayer 设置样式以在其左上角添加一个切片。

Material Design 将此类定制称为形状。Material 表面可以具有任意形状。形状为表面增加了重点和风格，可用于表达品牌特点。普通的矩形形状可以定制使其具有弯曲或成角度的角和边缘，以及任意数量的边。它们可以是对称的或不规则的。

### 为 front layer 添加一个形状（Shape）

斜角 Shrine logo 激发了 Shrine 应用的形状故事。形状故事是应用程序中应用的形状的常见用法。例如，徽标形状在应用了形状的登录页面元素中回显。在本小节，您将在左上角使用倾斜切片做为前层设置样式。

在 `backdrop.dart` 中，添加新的 `_FrontLayer` 类：

```
    // TODO：添加 _FrontLayer 类（104）
    class _FrontLayer extends StatelessWidget {
      // TODO：添加 on-tap 回调（104）
      const _FrontLayer({
        Key key,
        this.child,
      }) : super(key: key);

      final Widget child;

      @override
      Widget build(BuildContext context) {
        return Material(
          elevation: 16.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO：添加 GestureDetector（104）
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      }
    }
```

然后在 BackdropState 的 `_buildStack()` 方法里将 front layer 包裹在 `_FrontLayer` 内：

```
      Widget _buildStack() {
        // TODO：创建一个 RelativeRectTween 动画（104）

        return Stack(
        key: _backdropKey,
          children: <Widget>[
            widget.backLayer,
            // TODO：添加 PositionedTransition（104）
            // TODO：在 _FrontLayer 中包裹 front layer（104）
              _FrontLayer(child: widget.frontLayer),
          ],
        );
      }
```
重载。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/df346fb575d5885e.png)

我们给 Shrine 的主表面定制了一个形状。由于表面具有高度，用户可以看到白色前层后面有东西。让我们添加一个动作，以便用户可以看到背景的背景层。

## 6. 添加动作（Motion）

动作是一种可以让你的应用变得更真实的方式。它可以是大且夸张的、小且微妙的，亦或是介于两者之间的。但需要注意的是动作的形式一定要适合使用场景。多次重复的有规律的动作要精细小巧，才不会分散用户的注意力或占用太多时间。适当的情况，如用户第一次打开应用时，长时的动作可能会更引人注目，一些动画也可以帮助用户了解如何使用您的应用程序。

### 为菜单按钮添加显示动作

在 `backdrop.dart` 的顶部，其他类函数外，添加一个常量来表示我们需要的动画执行的速度：

```
    // TODO：添加速度常数（104）
    const double _kFlingVelocity = 2.0;
```

在 `_BackdropState` 中添加 `AnimationController` 部件，在 `initState()` 函数中实例化它，并将其部署在 state 的 `dispose()` 函数中：

```
      // TODO：添加 AnimationController 部件（104）
      AnimationController _controller;

      @override
      void initState() {
        super.initState();
        _controller = AnimationController(
          duration: Duration(milliseconds: 300),
          value: 1.0,
          vsync: this,
        );
      }

      // TODO：重写 didUpdateWidget（104）

      @override
      void dispose() {
        _controller.dispose();
        super.dispose();
      }

      // TODO：添加函数以确定并改变 front layer 可见性（104）
```

> **部件生命周期**
>
> 仅在部件成为其渲染树的一部分之前会调用一次 `initState()` 方法。只有在部件从树中移除时才会调用一次 `dispose()` 方法。

AnimationController 用来配合 Animation，并提供播放、反向和停止动画的 API。现在我们需要使用某个方法来移动它。

添加函数以确定并改变 front layer 的可见性：
```
      // TODO：添加函数以确定并改变 front layer 的可见性（104）
      bool get _frontLayerVisible {
        final AnimationStatus status = _controller.status;
        return status == AnimationStatus.completed ||
            status == AnimationStatus.forward;
      }

      void _toggleBackdropLayerVisibility() {
        _controller.fling(
            velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
      }
```

将 backLayer 包裹在 ExcludeSemantics 部件中。当 back layer 不可见时，此部件将从语义树中剔除 backLayer 的菜单项。

```
        return Stack(
          key: _backdropKey,
          children: <Widget>[
            // TODO：将 backLayer 包裹在 ExcludeSemantics 部件中（104）
            ExcludeSemantics(
              child: widget.backLayer,
              excluding: _frontLayerVisible,
            ),
          ...
```
修改 `_buildStack()` 方法使其持有一个 BuildContext 和 BoxConstraints。同时包含一个使用 RelativeRectTween 动画的 PositionedTransition：

```
      // TODO：为 _buildStack 添加 BuildContext 和 BoxConstraints 参数（104）
      Widget _buildStack(BuildContext context, BoxConstraints constraints) {
        const double layerTitleHeight = 48.0;
        final Size layerSize = constraints.biggest;
        final double layerTop = layerSize.height - layerTitleHeight;

        // TODO：创建一个 RelativeRectTween 动画（104）
        Animation<RelativeRect> layerAnimation = RelativeRectTween(
          begin: RelativeRect.fromLTRB(
              0.0, layerTop, 0.0, layerTop - layerSize.height),
          end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
        ).animate(_controller.view);

        return Stack(
          key: _backdropKey,
          children: <Widget>[
            ExcludeSemantics(
              child: widget.backLayer,
              excluding: _frontLayerVisible,
            ),
            // TODO：添加一个 PositionedTransition（104）
            PositionedTransition(
              rect: layerAnimation,
              child: _FrontLayer(
                // TODO：在 _BackdropState 上实现 onTap 属性（104）
                child: widget.frontLayer,
              ),
            ),
          ],
        );
      }
```

最后，返回一个使用 `_buildStack` 作为其 builder 的 **LayoutBuilder** 部件，而不是为 Scaffold 的主体调用 `_buildStack` 函数：

```
        return Scaffold(
          appBar: appBar,
          // TODO：返回一个 LayoutBuilder 部件（104）
          body: LayoutBuilder(builder: _buildStack),
        );
```

我们使用 LayoutBuilder 将 front/back 堆栈的构建延迟到布局阶段，以便我们可以合并背景的实际整体高度。LayoutBuilder 是一个特殊的部件，其构建器回调提供了大小约束。

> **LayoutBuilder**
>
> 部件树通过遍历叶结点来组织布局。约束在树下传递，但是在叶结点根据约束返回其大小之前通常不会计算大小。叶子点无法知道它的父母的大小，因为它尚未计算。
>
> 当部件必须知道其父部件的大小以便自行布局（且父部件大小不依赖于子部件）时，LayoutBuilder 就派上用场了。它使用一个方法来返回部件。
>
> 了解有关更多信息，请查看 [LayoutBuilder 类](https://docs.flutter.io/flutter/widgets/LayoutBuilder-class.html)文档。

在 `build()` 方法中，将应用栏中的前导菜单图标转换为 IconButton，并在点击按钮时使用它来切换 front layer 的可见性。

```
          // TODO：用 IconButton 替换 leading 菜单图标（104）
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _toggleBackdropLayerVisibility,
          ),
```

在模拟器中重载并点击菜单按钮。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/9b027fdb5f0cb48.png)

front layer 在向下移动（滑动）。但如果向下看，则会出现红色错误和溢出错误。这是因为 AsymmetricView 被这个动画挤压并变小，反过来使得 Column 的空间更小。最终，Column 不能用给定的空间自行排列并导致错误。如果我们用 ListView 替换 Column，则移动时列的尺寸仍然保持不变。

### 在 ListView 中包裹产品列项

在 `supplemental/product_columns.dart` 中，将 `OneProductCardColumn` 的 Column 替换成 ListView：

```
    class OneProductCardColumn extends StatelessWidget {
      OneProductCardColumn({this.product});

      final Product product;

      @override
      Widget build(BuildContext context) {
        // TODO：用 ListView 替换 Column（104）
        return ListView(
          reverse: true,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            ProductCard(
              product: product,
            ),
          ],
        );
      }
    }
```

Column 包含 `MainAxisAlignment.end`。要使得从底部开始布局，使用 `reverse: true`。其孩子的顺序将翻转以弥补变化。

重载并点击菜单按钮。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/96f7660473bb549b.png)

OneProductCardColumn 上的灰色溢出警告消失了！现在让我们修复另一个问题。

在 `supplemental/product_columns.dart` 中修改 `imageAspectRatio` 的计算方式，并将 `TwoProductCardColumn` 中的 Column 替换成 ListView：

```
          // TODO：修改 imageAspectRatio 的计算方式（104）
          double imageAspectRatio =
              (heightOfImages >= 0.0 && constraints.biggest.width > heightOfImages)
                  ? constraints.biggest.width / heightOfImages
                  : 33 / 49;

          // TODO：用 ListView 替换 Column（104）
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 28.0),
                child: top != null
                    ? ProductCard(
                        imageAspectRatio: imageAspectRatio,
                        product: top,
                      )
                    : SizedBox(
                        height: heightOfCards,
                      ),
              ),
              SizedBox(height: spacerHeight),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 28.0),
                child: ProductCard(
                  imageAspectRatio: imageAspectRatio,
                  product: bottom,
                ),
              ),
            ],
          );
        });
```

我们还为 `imageAspectRatio` 添加了一些安全性。

重载。然后点击菜单按钮。

现在已经没有溢出了。

## 7. 在 back layer 上添加菜单

菜单是由可点击文本项组成的列表，当发生点击事件时通知监听器。在此小节，你将添加一个类别过滤菜单。

### 添加菜单

在 front layer 添加菜单并在 back layer 添加互动按钮。

创建名为 `lib/category_menu_page.dart` 的新文件：

```
    import 'package:flutter/material.dart';
    import 'package:meta/meta.dart';

    import 'colors.dart';
    import 'model/product.dart';

    class CategoryMenuPage extends StatelessWidget {
      final Category currentCategory;
      final ValueChanged<Category> onCategoryTap;
      final List<Category> _categories = Category.values;

      const CategoryMenuPage({
        Key key,
        @required this.currentCategory,
        @required this.onCategoryTap,
      })  : assert(currentCategory != null),
            assert(onCategoryTap != null);

      Widget _buildCategory(Category category, BuildContext context) {
        final categoryString =
            category.toString().replaceAll('Category.', '').toUpperCase();
        final ThemeData theme = Theme.of(context);

        return GestureDetector(
          onTap: () => onCategoryTap(category),
          child: category == currentCategory
            ? Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  categoryString,
                  style: theme.textTheme.body2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14.0),
                Container(
                  width: 70.0,
                  height: 2.0,
                  color: kShrinePink400,
                ),
              ],
            )
          : Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              categoryString,
              style: theme.textTheme.body2.copyWith(
                  color: kShrineBrown900.withAlpha(153)
                ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            color: kShrinePink100,
            child: ListView(
              children: _categories
                .map((Category c) => _buildCategory(c, context))
                .toList()),
          ),
        );
      }
    }
```

它是一个 **GestureDetector**，它包含一个 Column，其孩子是类别名称。下划线用于指示所选的类别。

在 `app.dart` 中，将 ShrineApp 部件从 stateless 转换成 stateful。

1.  高亮 `ShrineApp.`
2.  按 alt（option）+ enter
3.  选择 "Convert to StatefulWidget"。
4.  将 ShrineAppState 类更改为 private（`_ShrineAppState`）。要从 IDE 主菜单执行此操作，请选择 Refactor > Rename。或者在代码中，您可以高亮显示类名 ShrineAppState，然后右键单击并选择 Refactor > Rename。输入 `_ShrineAppState` 以使该类成为私有。

在 `app.dart` 中，为选择的类别添加一个变量 `_ShrineAppState`，并在点击时添加一个回调：

```
    // TODO：将 ShrineApp 转换成 stateful 部件（104）
    class _ShrineAppState extends State<ShrineApp> {
      Category _currentCategory = Category.all;

      void _onCategoryTap(Category category) {
        setState(() {
          _currentCategory = category;
        });
      }
```

然后将 back layer 修改为 CategoryMenuPage。

在 `app.dart` 中引入 CategoryMenuPage：

```
    import 'backdrop.dart';
    import 'colors.dart';
    import 'home.dart';
    import 'login.dart';
    import 'category_menu_page.dart';
    import 'model/product.dart';
    import 'supplemental/cut_corners_border.dart';
```

在 `build()` 方法，将 backlayer 字段修改成 CategoryMenuPage 并让 currentCategory 字段持有实例变量。

```
          home: Backdrop(
            // TODO：让 currentCategory 字段持有 _currentCategory（104）
            currentCategory: _currentCategory,
            // TODO：为 frontLayer 传递 _currentCategory（104）
            frontLayer: HomePage(),
            // TODO：将 backLayer 修改成 CategoryMenuPage（104）
            backLayer: CategoryMenuPage(
              currentCategory: _currentCategory,
              onCategoryTap: _onCategoryTap,
            ),
            frontTitle: Text('SHRINE'),
            backTitle: Text('MENU'),
          ),
```

重载并点击菜单按钮。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/570506f76fc169b.png)

你点击了菜单选项，然而什么也没有发生...让我们修复它。

在 `home.dart` 中，为 Category 添加一个变量并将其传递给 AsymmetricView。

```
    import 'package:flutter/material.dart';

    import 'model/products_repository.dart';
    import 'model/product.dart';
    import 'supplemental/asymmetric_view.dart';

    class HomePage extends StatelessWidget {
      // TODO：为 Category 添加一个变量（104）
      final Category category;

      const HomePage({this.category: Category.all});

      @override
      Widget build(BuildContext context) {
        // TODO：为 Category 添加一个变量并将其传递给 AsymmetricView（104）
        return AsymmetricView(products: ProductsRepository.loadProducts(category));
      }
    }
```

在 `app.dart` 中为 `frontLayer` 传递 `_currentCategory`：

```
            // TODO：为 frontLayer 传递 _currentCategory（104）
            frontLayer: HomePage(category: _currentCategory),
```

重载。点击模拟器中的菜单按钮并选择一个类别。

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/963f80325fbd359c.png)

点击菜单图标以查看产品。他们被过滤了！

## 选择菜单项后关闭 front layer

在 `backdrop.dart` 中，为 `BackdropState` 重写 `didUpdateWidget()` 方法：

```
      // TODO：为 didUpdateWidget() 添加重写方法（104）
      @override
      void didUpdateWidget(Backdrop old) {
        super.didUpdateWidget(old);

        if (widget.currentCategory != old.currentCategory) {
          _toggleBackdropLayerVisibility();
        } else if (!_frontLayerVisible) {
          _controller.fling(velocity: _kFlingVelocity);
        }
      }
```

热重载，然后点击菜单图标并选择一个类别。菜单应该自动关闭，然后你将看到所选择类别的物品。现在同样地将这个功能添加到 front layer 。

### 切换 front layer

在 `backdrop.dart` 中，给 backdrop layer 添加一个 on-tap 回调：

```
    class _FrontLayer extends StatelessWidget {
      // TODO：添加 on-tap 回调（104）
      const _FrontLayer({
        Key key,
        this.onTap, // 新增代码
        this.child,
      }) : super(key: key);

      final VoidCallback onTap; // 新增代码
      final Widget child;
```

然后将一个 GestureDetector 添加到 `_FrontLayer` 的孩子 Column 的子节点中：

```
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO：添加一个 GestureDetector（104）
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Container(
                  height: 40.0,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
```

然后在 `_buildStack()` 方法的 `_BackdropState` 中实现新的 `onTap` 属性：

```
              PositionedTransition(
                rect: layerAnimation,
                child: _FrontLayer(
                  // TODO：在 _BackdropState 中实现 onTap 属性（104)
                  onTap: _toggleBackdropLayerVisibility,
                  child: widget.frontLayer,
                ),
              ),
```

重载并点击 front layer 的顶部。每次你点击 front layer 顶部时都它应该打开或者关闭。

## 8. 添加品牌图标

品牌肖像也应该延伸到熟悉的图标。让我们自定义显示图标并将其与我们的标题合并，以获得独特的品牌外观。

### 修改菜单按钮图标

![](https://codelabs.developers.google.com/codelabs/mdc-104-flutter/img/a533be3bc12ef2f7.png)

在 `backdrop.dart` 中，新建 `_BackdropTitle` 类。

```
    // TODO：添加 _BackdropTitle 类（104）
    class _BackdropTitle extends AnimatedWidget {
      final Function onPress;
      final Widget frontTitle;
      final Widget backTitle;

      const _BackdropTitle({
        Key key,
        Listenable listenable,
        this.onPress,
        @required this.frontTitle,
        @required this.backTitle,
      })  : assert(frontTitle != null),
            assert(backTitle != null),
            super(key: key, listenable: listenable);

      @override
      Widget build(BuildContext context) {
        final Animation<double> animation = this.listenable;

        return DefaultTextStyle(
          style: Theme.of(context).primaryTextTheme.title,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          child: Row(children: <Widget>[
            // 品牌图标
            SizedBox(
              width: 72.0,
              child: IconButton(
                padding: EdgeInsets.only(right: 8.0),
                onPressed: this.onPress,
                icon: Stack(children: <Widget>[
                  Opacity(
                    opacity: animation.value,
                    child: ImageIcon(AssetImage('assets/slanted_menu.png')),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(1.0, 0.0),
                    ).evaluate(animation),
                    child: ImageIcon(AssetImage('assets/diamond.png')),
                  )]),
              ),
            ),
            // 在这里，我们在 backTitle 和 frontTitle 之间是实现自定义的交叉淡入淡出效果
            // 这使得两个文本之间能够平滑过渡。
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: CurvedAnimation(
                    parent: ReverseAnimation(animation),
                    curve: Interval(0.5, 1.0),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(0.5, 0.0),
                    ).evaluate(animation),
                    child: backTitle,
                  ),
                ),
                Opacity(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.5, 1.0),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset(-0.25, 0.0),
                      end: Offset.zero,
                    ).evaluate(animation),
                    child: frontTitle,
                  ),
                ),
              ],
            )
          ]),
        );
      }
    }
```

`_BackdropTitle` 是一个自定义部件，它将替换 `AppBar` 里 `title` 参数的 `Text` 部件。它有一个动画菜单图标和前后标题之间的动画过渡。动画菜单图标将使用新资源。因此必须将对新 `slanted_menu.png` 的引用添加到 `pubspec.yaml`中。

```
    assets:
        - assets/diamond.png
        - assets/slanted_menu.png
        - packages/shrine_images/0-0.jpg
```

移除 `AppBar` builder 中的 `leading` 属性。这样才能在原始 `leading` 部件的位置显示自定义品牌图标。`listenable` 动画和品牌图标的 `onPress` 处理将传递给 `_BackdropTitle`。`frontTitle` 和 `backTitle` 也会被传递，以便将它们显示在背景标题中。`AppBar` 的 `title` 参数如下所示：

```
    // TODO：使用 _BackdropTitle 参数创建标题（104）
    title: _BackdropTitle(
      listenable: _controller.view,
      onPress: _toggleBackdropLayerVisibility,
      frontTitle: widget.frontTitle,
      backTitle: widget.backTitle,
    ),
```

品牌图标在 `_BackdropTitle` 中创建。它包含一组动画图标：倾斜的菜单和钻石，它包裹在 `IconButton` 中，以便可以按下它。然后将 `IconButton` 包装在 `SizedBox` 中，以便为图标水平运动腾出空间。

Flutter 的 "everything is a widget" 架构允许更改默认 `AppBar` 的布局，而无需创建全新的自定义 `AppBar` 小部件。`title` 参数最初是一个 `Text` 部件，可以用更复杂的 `_BackdropTitle` 替换。由于 `_BackdropTitle` 还包含自定义图标，因此它取代了 `leading` 属性，现在可以省略。这个简单的部件替换是在不改变任何其他参数的情况下完成的，例如动作图标，它们可以继续运行。

### 添加返回登录屏幕的快捷方式

在 `backdrop.dart` 中，从应用栏中的两个尾部图标向登录屏幕添加一个快捷方式：更改图标的 `semanticLabel` 以反映其新用途。

```
            // TODO：添加从尾部图标到登陆页面的快捷方式（104）
            IconButton(
              icon: Icon(
                Icons.search,
                semanticLabel: 'login', // 新增代码
              ),
              onPressed: () {
                // TODO：打开登陆（104）
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.tune,
                semanticLabel: 'login', // 新增代码
              ),
              onPressed: () {
                // TODO：打开登录（104）
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                );
              },
            ),
```

如果你尝试重载将收到错误消息。导入 `login.dart` 以修复错误：

```
    import 'login.dart';
```

重载应用并点击搜索或调整按钮以返回登录屏幕。

## 9. 总结

通过四篇教程，你已经了解了如何使用 Material 组件来构建表达品牌个性和风格的独特，优雅的用户体验。

> 完整的 MDC-104 应用可在 `104-complete` 分支中找到。
>
> 您可以使用该分支中的版本测试你的应用。

### 下一步

MDC-104 到此已经完成。你可以访问 [Flutter Widget 目录](https://flutter.io/widgets/)以在 MDC-Flutter 中探索更多组件。

对于进阶的目标，尝试使用 [AnimatedIcon](https://docs.flutter.io/flutter/material/AnimatedIcon-class.html) 替换品牌图标。

要了解如何将应用连接到 Firebase 以获得后端支持，请参阅 [Flutter 中的 Firebase](http://codelabs.developers.google.com/codelabs/flutter-firebase)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
