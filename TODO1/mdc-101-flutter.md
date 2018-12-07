> * 原文地址：[MDC-101 Flutter: Material Components (MDC) Basics (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/#0)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
> * 译者：[DevMcryYu](https://github.com/devmcryyu)
> * 校对者：

# MDC-101 Flutter：Material Components（MDC）基础（Flutter）

> - [MDC-101 Flutter：Material Components（MDC）基础（Flutter）](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
> - [MDC 102 Flutter：Material 结构和布局](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
> - [MDC 103 Flutter：Material Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> - [MDC 104 Flutter：Material 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)

## 1. 介绍

### 什么是 Material Design 和  Material Components for Flutter？

**Material Design** 是一个用于构建醒目、美观的数字产品的系统。通过在一套统一的原则和组件下将风格、品牌、交互和动作结合起来，产品团队得以释放其极大的设计潜能。

**Material Components for Flutter**（**MDC-Flutter**）将设计和工程与组件库结合在一起，从而在各种应用和平台之间创建统一的用户体验。随着 Material Design 系统的发展，这些组件进行了更新以确保统一的像素级的完美实现，并遵循 Google 的前端开发标准。MDC 同样适用于 Android、iOS 和 Web。

在本教程中，你将使用多个 MDC Flutter 组件来构建一个登陆页面。

### 你将构建一个

本教程是四个教程里的第一个，它将指导你构建一款名为 **Shrine** —— 一个销售服装和家居用品的电子商务应用程序。它将演示如何使用 MDC-Flutter 自定义组件来体现任何品牌和风格。

在本教程中，你将为 Shrine 构建一个包含以下内容的登陆页面：

*   一个 Shrine 的 logo
*   应用名称（Shrine）
*   两个文本框，一个用于输入用户名，另一个用来输入密码
*   两个按钮，一个用于“Cancel”，另一个用于“Next”

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/db3def4f18a58eed.png)

相关教程可以在以下位置找到：

- [MDC 102 Flutter：Material 结构和布局](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
- [MDC 103 Flutter：Material Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
- [MDC 104 Flutter：Material 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)

在 MDC-104 的最后，你将会构建一个如下所示的应用：

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/e23a024b60357e32.png)

### 本教程中用到的 MDC 组件

*   Text field
*   Button
*   Ripple

> 在这个教程，你将使用由 MDC-Flutter 提供的默认组件。你将在 [MDC 103 Flutter：Material Theming 的颜色、形状、高度和类型](https://codelabs.developers.google.com/codelabs/mdc-103-flutter) 中学习如何定制它们。

## 2. 安装 Flutter 环境

### 前提条件

要开始使用 Flutter 开发移动应用程序，你需要：

*   [Flutter SDK](https://flutter.io/setup/)
*   装有 Flutter 插件的 IntelliJ IDE，或者你喜欢的代码编辑器

Flutter 的 IDE 工具适用于 [Android Studio](https://developer.android.com/studio/index.html)，[IntelliJ IDEA Community（免费）和 IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/download/)。

![](https://lh6.googleusercontent.com/ol-teJ4O7B69JJRkTfRVQ0a2afiPmL60r-KxNGD26R0KreGtbem_U05Js7HNw3FQu7rIaDVDBQozSFWUB7QVgyfoYpPCPVjKh1knJQGvtbAvLtDbdBmB7XaVbBvth3WOwBAIFDS7)  
要在 iOS 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS 的计算机
*   Xcode 9 或更新版本
*   iOS 模拟器，或者 iOS 物理设备

![](https://lh3.googleusercontent.com/Si2NN00ySyOEkNilzmWrhGLWwaCfGZME_01PwA1sSWu66Prw15UijYovXa-y3csDBg4NP_nhxBc_oqjparZ5Cme0zKuf0RRK1KiaN_n0Kn3AQ0zdkACXUhJJHAXdWK2WFshbxQLt)  
要在 Android 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS，Windows 或者 Linux 的计算机
*   Android Studio
*   Android 模拟器（随 Android Studio 一起提供）或 Android 物理设备

[获取详细的 Flutter 安装信息](https://flutter.io/setup/)

> **重要提示：** 如果连接到计算机的 Android 手机上出现“允许 USB 调试”对话框，请启用**始终允许从此计算机**选项，然后单击**确定**。

在继续本教程之前，请确保你的 SDK 处于正确的状态。如果之前安装过 Flutter，则使用 `flutter upgrade` 来确保 SDK 处于最新版本。

```
flutter upgrade
```

运行 `flutter upgrade` 将自动运行 `flutter doctor`。如果这是首次安装 Flutter 且不需升级，那么请手动运行 `flutter doctor`。查看显示的所有检查标记；这将会下载你需要的任何缺少的 SDK 文件，并确保你的计算机配置无误以进行 Flutter 的开发。

```
flutter doctor
```

## 3. 下载教程初始应用程序

[下载初始程序](https://github.com/material-components/material-components-flutter-codelabs/archive/101-starter.zip)

此入门程序位于 `material-components-flutter-codelabs-101-starter/mdc_100_series` 目录中。

### ...或者从 GitHub 克隆它

要从 GitHub 克隆此项目，请运行以下命令：

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 101-starter
```

> 更多帮助：[从 GitHub 上克隆存储库](https://help.github.com/articles/cloning-a-repository/)

> ### 正确的分支
>
> 教程 MDC-101 到 104 连续构建。所以当你完成 101 的代码后，它将变成 102 教程的初始代码！代码被分成不同的分支，你可以使用以下命令将它们全部列出：
>
> `git branch --list`
>
> 要查看完整代码，请切换到 `102-starter_and_101-complete` 分支。

建立你的项目

以下步骤默认你使用的是 Android Studio (IntelliJ)。

### 创建项目

1. 在终端中，导航到 `material-components-flutter-codelabs`

2. 运行 `flutter create mdc_100_series`

![](https://lh5.googleusercontent.com/J9CQ2xQy4PCirtParnKTrQbjo5tdy0LEh__NVXEjkSYdwSl96QWiwyX2fAdQcW5jTCUzVSzpAqF9-f5mfvyg9BE299XA5nNawKXkAKAO9KIJWawpJtEucLXwqi9buzCX3D7UJixV)

### 打开项目

1. 打开 Android Studio。

2. 如果你看到欢迎页面，单击 **打开已有的 Android Studio 项目**。

![](https://lh5.googleusercontent.com/q3QrMqM5NUKXvHdNL4f-OPx1WQJCiXZuq0XJzExqbMK6NrSEigfggRFuJ9C9zpqOCsl0uWfywG1_6W1B45xrafR2EGTP68B0Yr0QtGAu3NWCdnylzYHWEp-as7AkYj8S5oNwFzr-)

3. 导航到 `material-components-flutter-codelabs/mdc_100_series` 目录并单击打开，这将打开此项目。

**在构建项目一次之前，你可以忽略在分析中见到的任何错误。**

![](https://lh4.googleusercontent.com/eohV4ysnGI7n1WXZEpvDocqGoj2yBijhLPxkGovkL85mil0HSvbQxgJ4VlduNj1ypfOdVd1fyTxR5QnS31iu0HFaqjWcOY2GqWs2hHFNO4-zqQzj-S8rGGH0VqrOEtAFEbzUuCxB)

4. 在左侧的项目面板中，删除测试文件 `../test/widget_test.dart`

![](https://lh4.googleusercontent.com/tbOkXg3PBYapj_J0CpdwQTt-sqnf7s3bqi7E3Dd__z_aC5XANKphvuoMvmiOFfBR6oDeZixE0Ww2jTzskt1sDNgEXjAJjwHr7m242tkZ7VvXGaFMObmSIZ06oC7UQusGgCL7DpHr)

5. 如果出现提示，安装所有平台和插件更新或  FlutterRunConfigurationType，然后重新启动 Android Studio。

![](https://lh5.googleusercontent.com/MVD7YGuMneCprDEam1Vy8NusO9BPmOZTyrH4jvO8RmsfTeu8q-t0AfHU3kzXk1F8EUgHaFbqeORdXc7iOcz5ZLM4qbXsv_tMiVnAi0i68p0t957RThrZ56Udf-F292JgRV3iKs7T)

> **提示：** 确保你已安装 [ Flutter 和 Dart 插件](https://flutter.io/get-started/editor/#androidstudio).

### 运行初始程序

以下步骤默认你在 Android 模拟器或设备上进行测试。你也可以在 iOS 模拟器或设备上进行，只要你安装了 Xcode。

1. 选择设备或模拟器

如果 Android 模拟器尚未运行，请选择 **Tools -> Android -> AVD Manager** 来[创建您设备并启动模拟器](https://developer.android.com/studio/run/managing-avds.html)。 如果 AVD 已存在，你可以直接在 IntelliJ 的设备选择器中启动模拟器，如下一步所示。

（对于 iOS 模拟器，如果它尚未运行，通过选择 **Flutter Device Selection -> Open iOS Simulator** 来在你的开发设备上启动它。）

![](https://lh5.googleusercontent.com/mmcO6QRlA96Sc1AZhL8NqvaTE9DZL5q3QQJsrx-2U4ptShFUcrmYoEuVLB6uyAxL4F80dFaxiotLmWjtTYUYYJu-Rf9TtoKDcJLlzuyWezQIz0BiIIBsgy7mPNS8bO5VbqcMb1Qt)

2. 启动 Flutter 应用：

*   在你的编辑器窗口顶部寻找 Flutter Device Selection 下拉菜单，然后选择设备（例如，iPhone SE / Android SDK built for <version>）。
*   点击**运行**图标 （![](https://lh6.googleusercontent.com/Zu8-cWRMCfIrBGIjj4kSW-j8KBiIqVe33PX8Mht5lSKq00kRB7Na3X0kC4aaiG-G7hqqqLPpgtbxTz-1DdYbq2RiNvc2ZaJzfiu_vVYAh1oOc4TZu85pa42nFqqxmMQWySzLWeU1)）。

![](https://lh4.googleusercontent.com/NLXK-hHFYnHBPeQ6NYrKGnXpj9X2es9her6Y14CotXlR-OdSQBXHyRFv1nvhC1AFCmWx7jIG2Ulb7-OmLV_Pru_-kd-3gArn8OKEGTIOInDJlqIUJ7dxTQUsvLVa0CJwEO5EGjeu)

> 如果你无法成功运行此应用程序，停下来解决你的开发环境问题。尝试导航到  `material-components-flutter-codelabs`；如果你在终端中下载 .zip 文件，导航到 `material-components-flutter-codelabs-...` 然后运行 `flutter create mdc_100_series`。

成功！Shrine 的初始登陆代码应该在你的模拟器中运行了。你可以看到 Shrine  的 logo 和它下面的名称 "Shrine"。

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/e8f2476968468376.png)

> 如果你看到任何有关 `pubspec` 已被编辑的警告（提示获取依赖项），不要管他 。当你按下运行按钮时，它会为你运行 `flutter packages get`！
>
> `flutter packages get` 会安装你在 `pubspec.yaml` 文件中列出的依赖项。 你可以编写你自己的包以在 [Pub](https://pub.dartlang.org/) 上发布。本系列教程使用 `shrine_images` 自定义包来显示你将在  [MDC-102](http://go/mdc-102-flutter) 看到的产品图像。
>
> `flutter packages get` 调用底层 Dart pub 包管理器来安装 Flutter 应用程序的所有依赖项。本系列教程的产品图像使用自定义 `shrine_images` 包。
>
> 有关更多包的信息，参阅[使用包](https://flutter.io/using-packages/)。

让我们来看看代码。

### `login.dart` 中的小部件

打开 `login.dart`。里面应该包含：

```
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO：添加文本编辑控制器（101）
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text('SHRINE'),
              ],
            ),
            SizedBox(height: 120.0),
            // TODO：使用 AccentColorOverride 包装 Username（103）
            // TODO：删除填充：真值（103）
            // TODO：使用 AccentColorOverride 包装 Password（103）
            // TODO：添加文本框小部件（101）
            // TODO：添加按钮栏（101）
          ],
        ),
      ),
    );
  }
}

// TODO：添加 AccentColorOverride（103）
```

请注意：它包含一个 `import` 语句和两个新类：

*   `import` 语句将 Material Components 引入此文件
*   `LoginPage` 类代表模拟器中显示的整个页面。
*   `_LoginPageState` 类的 `build()` 函数控制如何创建 UI 中的所有小部件。

> 了解更多有关 Flutter UI 的基础以及什么是 widget 的内容，你可以参观 [ Flutter Widget 框架](https://flutter.io/widgets-intro/) 或者尝试 [编写你的第一个 Flutter 应用程序，第一部分](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1)。

## 4. 添加文本框小部件

首先，我们将在登陆页面添加两个文本字段，用户可以在其中输入用户名和密码。我们将使用文本框小部件，它显示一个浮动标签并激活触摸的波纹效果。

> Material 的文本框已得到极大增强，以提高品牌灵活性；在广泛的用户体验（UX）研究的支持下进行改进，从而实现更好的视觉设计，提高可用性。
>
> 在 Material Guidelines 的[文章](https://material.io/design/components/text-fields.html)中了解更多有关新 TextField 的信息。

此页面主要由 **ListView** 构成，它将其子项排列在一个可滚动的列中。让我们将文本框放在底部。

### 添加文本框小部件

在 `SizedBox(height: 120.0)` 之后添加两个新的文本框和一个间隔（spacer）。

```
// TODO: 添加文本框小部件（101）
// [用户名]
TextField(
  decoration: InputDecoration(
    filled: true,
    labelText: 'Username',
  ),
),
// 间隔（spacer）
SizedBox(height: 12.0),
// [密码]
TextField(
  decoration: InputDecoration(
    filled: true,
    labelText: 'Password',
  ),
  obscureText: true,
),
```

每个文本框都有一个 `decoration:`，它带有一个 **InputDecoration**  小部件。`filled: true` 意味着文本框的背景被浅色填充以帮助人们识别文本框的点击或触摸区域。第二个文本框的 `obscureText: true`值会自动将用户的输入替换为圆点形式，这适用于输入密码的地方。

保存你的项目（使用快捷键：command / ctrl + s）执行热重载。

你现在应该可以看到包含有用户名和密码文本框的页面！查看浮动标签和墨水波纹动画效果：

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/19af1564bbdffe0a.png)

> 如果应用没有更新，再次单击“运行”按钮，或单击“停止”后再单击“运行”。

> 文本框的功能包括：
>
> *   可以轻松改变 TextField 小部件的外观。在要修饰的区域，指定  InputDecoration 的值。
> *   MDC 文本框默认显示触摸反馈（称为 MDC 波纹或“墨水”）。
> *   FormField 是一个类似的小部件，具有在 Forms 中嵌入字段的特殊功能。
> *   [TextField 类文档](https://docs.flutter.io/flutter/material/TextField-class.html)

## 5. 添加按钮

接下来，我们将在登陆页面添加 “Cancel” 和 “Next” 两个按钮。我们将使用两种 MDC 按钮小部件：**FlatButton**（在 Material Guidelines 中称为“Text Button”）和 **RaisedButton**（称作“Contained Button”）。

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/fb1bc435bbb0a662.png)

> ### 在 Text Button 和 Contained Button 之间选择
>
> 为什么不简单地显示两个 Contained Button 呢？ 这是因为每个按钮的类型指示哪些操作比其他事情更重要。
>
> 一个布局应该包含一个突出的按钮。这清楚的表明其他按钮的重要性较低。这个突出的按钮代表了我们最希望用户采取的操作，用以推进我们的应用运行。
>
> 我们最不喜欢用户采取的操作是取消登陆。因为 Contained Button 以凸起的样式吸引眼球，所以它应该用于更重要的操作。相比之下左侧的纯文本按钮看起来不那么显眼。
>
> 在 Material Guidelines 的[按钮](https://material.io/design/components/buttons.html)一文中了解更多有关按钮层级的信息。

### 添加按钮栏

在文本框下面，添加 `ButtonBar` 作为 `ListView` 的子项：

```
// TODO：添加按钮栏（101）
ButtonBar(
  // TODO：给 CANCEL 添加斜面矩形边框（103）
  children: <Widget>[
    // TODO：添加按钮（101）
  ],
),
```

**ButtonBar** 将其子项全部横向排列

### 添加按钮

然后在 ButtonBar 的 `children` 列表中添加两个按钮：

```
// TODO：添加按钮（101）
FlatButton(
    child: Text('CANCEL'),
    onPressed: () {
    // TODO：清除文本框（101）
    },
),
// TODO：给 NEXT 按钮添加高度（103）
// TODO：给 NEXT 添加斜面矩形边框（103）
RaisedButton(
    child: Text('NEXT'),
    onPressed: () {
// TODO：显示下一页（101）
    },
),
```

> ### 为什么我们的 onPressed：字段为空块？
>
> 如果我们传递 null，或者没有包含该字段（默认为 null），则按钮将被禁用。没有关于触摸的反馈，我们无法很好的了解他们的启用行为。使用空块可以防止他们被禁用。
>
> 有关按钮及其交互的更多信息，请参阅[为你的应用程序添加交互](https://flutter.io/tutorials/interactive/)。

保存你的项目，在最下方的文本框下，你应该看到两个按钮：

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/fb1bc435bbb0a662.png)

ButtonBar 为你处理布局工作。它根据当前 **ButtonTheme** 中的填充，水平地定位按钮，使他们彼此相邻。（你将在 [MDC-103](http://go/mdc-103-flutter) 中了解更多相关信息。）

触摸按钮会启动墨水波纹动画，而不会导致其他任何事情发生。让我们在匿名函数 `onPressed:` 中添加功能来让取消按钮能够清空文本框，用下一个按钮来关闭屏幕：

### 添加 TextEditingControllers

为了能够清除文本框的值，我们将添加 **TextEditingControllers** 来控制他们的文本。

在 `_LoginPageState` 类的声明下，将控制器添加为 `final` 变量。

```
// TODO：添加文本编辑控制器（101）
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
```

在第一个文本框的 `controller:` 中，设置 `_usernameController`：

```
// [用户名]
TextField(
  controller: _usernameController,
```

在第二个文本框的 `controller:` 中，设置 `_passwordController`：

```
// [密码]
TextField(
  controller: _passwordController,
```

### 编辑 onPressed

添加命令以清除 FlatButton 中 `onPressed:` 函数的每个控制器：

```
// TODO：清除文本框（101）
_usernameController.clear();
_passwordController.clear();
```

保存你的项目。现在当你在文本字段中键入内容后，按下取消按钮将会清空每个文本框。

此登陆表单状态良好！让我们将用户带入 Shrine 应用的其余部分。

### 弹出

要忽略此视图，我们希望从导航栈中**弹出**（或者删除）此页面（在 Flutter 中称为**路由**）。

> **Navigator** 负责维护一个路由栈，就像 iOS 上的 UINavigationController 一样。_入栈_ 一个路由会将其放置在堆栈的顶部。 _出栈_ 会删除最近添加的路由。在我们程序的 `app.dart` 中，调用 `initialRoute: '/login',` 将登陆屏幕添加到 Navigator ，放到进入到 `home:` 的内容之上。
>
> 在[导航基础](https://flutter.io/cookbook/navigation/navigation-basics/)中详细了解路由和导航。

在 RaisedButton 的 `onPressed:` 函数中，从 Navigator 中弹出最近的路由：

```
// TODO：显示下一页（101）
            RaisedButton(
                child: Text('NEXT'),
                onPressed: () {
                Navigator.pop(context);
                },
            ),
```

就是这样！保存项目。然后单击“下一步”。

你做到了！

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/82ea25c31b367255.png)

这个页面是我们下一个教程的起点，你可以在 MDC-102 中继续使用它。

> 有关按钮：
>
> *   除了 FlatButton 和 RaisedButton 以外，还有 OutlineButton、 FloatingActionButton、IconButton 等。
> *   在 [MDC Widgets 目录](https://flutter.io/widgets/material)中浏览按钮及其文档。

## 6. 全部完成

我们添加了文本框和按钮并且几乎不必考虑布局代码。Material Components for Flutter 具有很多风格，几乎可以毫不费力地完成布局。

> 已完成的 MDC-101 应用可在 `102-starter_and_101-complete` 分支中找到。
>
> 你可以根据该分支中的应用测试你自己的应用版本。

### 下一步

文本框和按钮是 Material 系统中的两个核心组件，但是还有更多！你可以在 Flutter 的 [Material Components 库](https://flutter.io/widgets/material/)中浏览其余小部件。

另外，转到 [MDC 102 Flutter：Material 结构和布局 ](https://codelabs.developers.google.com/codelabs/mdc-102-flutter)了解 MDC-102 所涵盖的 Flutter 组件。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
