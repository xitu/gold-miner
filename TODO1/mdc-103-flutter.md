> * 原文地址：[MDC-103 Flutter: Material Theming with Color, Shape, Elevation, and Type (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/#0)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> * 译者：[DevMcryYu](https://github.com/devmcryyu)
> * 校对者：[PrinceChou](https://github.com/PrinceChou), [Fengziyin1234](https://github.com/Fengziyin1234)

# MDC-103 Flutter: Material Theming 的颜色、形状、高度和类型（Flutter）

## 1. 介绍

![](https://lh4.googleusercontent.com/yzZPYGHe5CrFE-84MXhqwb_y7YjCKLWQJHI7W7zqbT9_qdK8qufFjx51kepr3ITvZtF7vD3d72nurt-HPBARmQ6RF74PD1FwGZMNbXphLap4LqIEBCKWP5OxK2Vjeo-YEY3-oeIP)Material 组件（MDC）帮助开发者实现 Material Design。MDC 由谷歌团队的工程师和 UX 设计师创造，为 Android、iOS、Web 和 Flutter 提供很多美观实用的 UI 组件。

material.io/develop

现在可以使用 MDC 来为你的应用程序定制远比以前独特的样式。Material Design 近期的更新使得设计师和开发者可以更灵活地表达他们的产品理念。

在教程 MDC-101 和 MDC-102 中，你使用 Material 组件（MDC）为一个名为 **Shrine** 的销售服装和家居用品的电子商务应用程序构建基础。这个应用的用户使用流程包括一个开始的登陆页面，然后导航用户前往展示商品的主屏幕。

### 你将构建一个

在本教程中，你将会使用以下属性来定制 Shrine 应用：

*   颜色（Color）
*   排版（Typography）
*   高度（Elevation）
*   形状（Shape）
*   布局（Layout）

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/7f521db8a762f5ee.png)

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/7ac46e5cb6b1e064.png)

这是四篇教程中的第三篇，来引导你构建 Shrine 应用。

其余教程可在这里找到：

*   [MDC-101：Material Components（MDC）基础（Flutter）](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
*   MDC-102：Material 结构和布局](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
*   [MDC-104: Material Design 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)

到 MDC-104 的最后，你将会构建一个像这样的应用：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/e23a024b60357e32.png)

## 本教程中使用到的 MDC-Flutter 组件和子系统

*   主题（Theme）
*   排版（Typography）
*   高度（Elevation）
*   图片列表（Image list）

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

![](https://lh6.googleusercontent.com/ol-teJ4O7B69JJRkTfRVQ0a2afiPmL60r-KxNGD26R0KreGtbem_U05Js7HNw3FQu7rIaDVDBQozSFWUB7QVgyfoYpPCPVjKh1knJQGvtbAvLtDbdBmB7XaVbBvth3WOwBAIFDS7)要在 iOS 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS 的计算机
*   Xcode 9 或更新版本
*   iOS 模拟器，或者 iOS 物理设备

![](https://lh3.googleusercontent.com/Si2NN00ySyOEkNilzmWrhGLWwaCfGZME_01PwA1sSWu66Prw15UijYovXa-y3csDBg4NP_nhxBc_oqjparZ5Cme0zKuf0RRK1KiaN_n0Kn3AQ0zdkACXUhJJHAXdWK2WFshbxQLt)要在 Android 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS，Windows 或者 Linux 的计算机
*   Android Studio
*   Android 模拟器（随 Android Studio 一起提供）或 Android 物理设备

[获取详细的 Flutter 安装信息](https://flutter.io/setup/)

> **重要提示：** 如果连接到计算机的 Android 手机上出现“允许 USB 调试”对话框，请启用**始终允许从此计算机**选项，然后单击**确定**。

在继续本教程之前，请确保你的 SDK 处于正确的状态。如果之前安装过 Flutter SDK，则使用 `flutter upgrade` 来确保 SDK 处于最新版本。

```
flutter upgrade
```

运行 `flutter upgrade` 将自动运行 `flutter doctor`。如果这是首次安装 Flutter 且不需升级，那么请手动运行 `flutter doctor`。查看显示的所有 ✓ 标记；这将会下载你需要的任何缺少的 SDK 文件，并确保你的计算机配置无误以进行 Flutter 的开发。

```
flutter doctor
```

## 3. 下载教程初始应用程序

### 从 MDC-102 继续？

如果你完成了 MDC-102，那么本教程所需代码应该已经准备就绪，跳转到**调整颜色**一步。

### 从头开始？

### 下载初始应用程序

[Download starter app](https://github.com/material-components/material-components-flutter-codelabs/archive/103-starter_and_102-complete.zip)

此入门程序位于 `material-components-flutter-codelabs-103-starter_and_102-complete/mdc_100_series` 目录中。

### ...或者从 GitHub 克隆它

要从 GitHub 克隆此项目，请运行以下命令：

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 103-starter_and_102-complete
```

> 更多帮助：[从 GitHub 上克隆存储库](https://help.github.com/articles/cloning-a-repository/)

> 正确的分支
>
> 教程 MDC-101 到 104 连续构建。所以当你完成 103 的代码后，它将变成 104 教程的初始代码！代码被分成不同的分支，你可以使用以下命令将它们全部列出：
>
> `git branch --list`
>
> 要查看完整代码，请切换到 `104-starter_and_103-complete` 分支。

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

4. 在左侧的项目面板中，删除测试文件 `../test/widget_test.dart`

![](https://lh4.googleusercontent.com/tbOkXg3PBYapj_J0CpdwQTt-sqnf7s3bqi7E3Dd__z_aC5XANKphvuoMvmiOFfBR6oDeZixE0Ww2jTzskt1sDNgEXjAJjwHr7m242tkZ7VvXGaFMObmSIZ06oC7UQusGgCL7DpHr)

5. 如果出现提示，安装所有平台和插件更新或 FlutterRunConfigurationType，然后重新启动 Android Studio。

![](https://lh5.googleusercontent.com/MVD7YGuMneCprDEam1Vy8NusO9BPmOZTyrH4jvO8RmsfTeu8q-t0AfHU3kzXk1F8EUgHaFbqeORdXc7iOcz5ZLM4qbXsv_tMiVnAi0i68p0t957RThrZ56Udf-F292JgRV3iKs7T)

> **提示**：确保你已安装 [Flutter 和 Dart 插件](https://flutter.io/get-started/editor/#androidstudio)。

### 运行初始程序

以下步骤默认你在 Android 模拟器或设备上进行测试。你也可以在 iOS 模拟器或设备上进行，只要你安装了 Xcode。

1. 选择设备或模拟器

如果 Android 模拟器尚未运行，请选择 **Tools -> Android -> AVD Manager** 来[创建您设备并启动模拟器](https://developer.android.com/studio/run/managing-avds.html)。如果 AVD 已存在，你可以直接在 IntelliJ 的设备选择器中启动模拟器，如下一步所示。

（对于 iOS 模拟器，如果它尚未运行，通过选择 **Flutter Device Selection -> Open iOS Simulator** 来在你的开发设备上启动它。）

![](https://lh5.googleusercontent.com/mmcO6QRlA96Sc1AZhL8NqvaTE9DZL5q3QQJsrx-2U4ptShFUcrmYoEuVLB6uyAxL4F80dFaxiotLmWjtTYUYYJu-Rf9TtoKDcJLlzuyWezQIz0BiIIBsgy7mPNS8bO5VbqcMb1Qt)

2. 启动 Flutter 应用：

*   在你的编辑器窗口顶部寻找 Flutter Device Selection 下拉菜单，然后选择设备（例如，iPhone SE / Android SDK built for <version>）。
*   点击**运行**图标（![](https://lh6.googleusercontent.com/Zu8-cWRMCfIrBGIjj4kSW-j8KBiIqVe33PX8Mht5lSKq00kRB7Na3X0kC4aaiG-G7hqqqLPpgtbxTz-1DdYbq2RiNvc2ZaJzfiu_vVYAh1oOc4TZu85pa42nFqqxmMQWySzLWeU1)）。

![](https://lh4.googleusercontent.com/NLXK-hHFYnHBPeQ6NYrKGnXpj9X2es9her6Y14CotXlR-OdSQBXHyRFv1nvhC1AFCmWx7jIG2Ulb7-OmLV_Pru_-kd-3gArn8OKEGTIOInDJlqIUJ7dxTQUsvLVa0CJwEO5EGjeu)

> 如果你无法成功运行此应用程序，停下来解决你的开发环境问题。尝试导航到 `material-components-flutter-codelabs`；如果你在终端中下载 .zip 文件，导航到 `material-components-flutter-codelabs-...` 然后运行 `flutter create mdc_100_series`。

成功！上一篇教程中 Shrine 的登陆页面应该在你的模拟器中运行了。你可以看到 Shrine 的 logo 和它下面的名称 "Shrine"。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/db3def4f18a58eed.png)

> 如果应用没有更新，再次单击 “Play” 按钮，或者点击 “Play” 后的 “Stop”。

点击“Next”来查看上一教程中的主屏幕。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/532fe80b3fa3db74.png)

## 4. 调整颜色（Color）

一个代表着 Shrine 品牌的配色方案已经创建好了。设计师希望你在 Shrine 应用中实现这个配色方案。

首先，让我们在项目里导入这些颜色。

### **创建** `colors.dart`

在 `lib` 目录下新建一个名为 `colors.dart` 的 dart 文件。导入 Material 组件并添加 Color 常量：

```
import 'package:flutter/material.dart';

const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);
const kShrinePink400 = const Color(0xFFEAA4A4);

const kShrineBrown900 = const Color(0xFF442B2D);

const kShrineErrorRed = const Color(0xFFC5032B);

const kShrineSurfaceWhite = const Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;
```

### 自定义调色板（Color palette）

此颜色主题由设计师自选颜色进行创建（如下图所示）。它包含 Shrine 的品牌色并应用于 Material 主题编辑器，由此衍生出的完整的调色板。（这些颜色并非来自 2014 Material color palette。）

Material 主题编辑器使用以数字表示的色度（shade）对颜色进行分类，每种颜色都有 50、100、200、... 一直到 900 等几个色度。Shrine 仅仅使用 50、100 和 300 色度的粉色调以及 900 色度的棕色调。

> 译者注：色度：色彩深浅、明暗的程度。

![](https://lh3.googleusercontent.com/P2WMR2CBjl5H2CfhCWnqrpw4UiLMJgnZ3KRh-n4cA2YLbGPBA_WXq463bUigJDjO_ThANoki4cuFeuS12Wamvn08rmgxPhJMerUytDwlXaS7XiFYjKYvIgaeo9iYAINstV3GwhoD)

![](https://lh5.googleusercontent.com/sfrxmMvcYDu-JrEaTdnRjRRJx2wyf6GfoNRolI1Xodrm0mNIsFMRaAFAO8MbxYPu3-Ust19LPPcfKIEvQhXeDOGHqvupsWatCRFF-eH52cv5B6ksqowA1Z0W4JIPS3medD4FnqVC)

每个部件的颜色参数都对应此模板内的颜色。例如，文本框在接收输入时的修饰颜色应该是主题的 Primary color。如果该颜色不合适（易于与背景区分），请改用 PrimaryVariant。

> ### Colors 类
>
> `kShrineBackgroundWhite` 的值来自于 **Colors** 类。这个类包含常见的颜色值，例如白色。它还包含 2014 color palette 作为 MaterialColor 类。
>
> ### MaterialColor 类
>
> 在 'material/colors.dart' 中找到的 **MaterialColor** 类（子类是 **ColorSwatch**）是一组包含 14 或更少种由原色变换成的颜色，比如 14 种不同色度的红色、绿色、浅绿或石灰色。这就类似于你在油漆店里见到的渐变色色卡。  
>
> 这些颜色是在 2014 Material 指南中提出的，并且在当前指南（[颜色系统（Color System）](https://material.io/design/color/the-color-system.html)）以及 MDC-Flutter 中仍然可用。要在代码里访问它们，只需调用基础色后接色度（通常为 100 的倍数）即可。例如，Pink 400 可通过 `Colors.pink[400]` 检索到。
>
> 你完全可以将这些调色盘运用到你的设计和代码上。如果已经有属于品牌自己的配色，也可以使用[调色板生成工具](https://material.io/tools/color/)或者[Material 主题编辑器](https://material.io/tools/theme-editor/)来生成自己的配色。

现在我们有想用的颜色了。我们可以将它应用到 UI 上。我们将通过设置应用于 MaterialApp 实例顶部层次结构的 **ThemeData** 部件来实现。

### 定制 ThemeData.light()

Flutter 包含一些内置主题。light 主题就是其中之一。与其从零开始制作一个 ThemeData 部件，我们不如拷贝 light 主题然后修改其中的一部分属性来为我们的应用进行定制。

### 拷贝 ThemeData 实例

我们在默认的 light ThemeData 中调用 `copyWith()`，然后传入一些自定义属性值（`copyWith()` 在 Flutter 中是一个常用方法，你会在很多类和部件中看到它）。这个命令返回与调用它的实例匹配的部件实例，但是替换了一些指定的值。

为什么不实例化一个 ThemeData 然后设它的属性呢？当然可以！如果我们继续构建我们的程序,这将很有意义。由于 ThemeData 拥有**大量**的属性，为了节省时间，我们的教程将从修改一个有吸引力的主题的可见值入手。当我们稍后尝试使用替代主题时，我们将从 MDC-Flutter 附带的 ThemeData 开始。

在 [Flutter 文档](https://docs.flutter.io/flutter/material/ThemeData-class.html)中了解更多有关 ThemeData 的信息。

让我们在 `app.dart` 中导入 `colors.dart`。

```
import 'colors.dart';
```

然后将以下内容添加到 app.dart 的 ShrineApp 类**之外**的地方：

```
// TODO：构建 Shrine 主题（103）
final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    // TODO：添加文本主题（103）
    // TODO：添加图标主题（103）
    // TODO：修饰输入内容（103）
  );
}
```

现在在应用的 `build()` 函数最后(在 MaterialApp 部件中)将 `theme:` 设成我们的新主题：

```
// TODO：添加主题（103）
return MaterialApp(
  title: 'Shrine',
  // TODO：将 home: 改为 HomePage frontLayer（104）
  home: HomePage(),
  // TODO：让 currentCategory 字段持有 _currentCategory（104）
  // TODO：向 frontLayer 传递 _currentCategory（104）
  // TODO：将 backLayer 字段值改为 CategoryMenuPage（104）
  initialRoute: '/login',
  onGenerateRoute: _getRoute,
  theme: _kShrineTheme, // 新加代码
);
```

点击运行按钮，你的登陆页面看起来应该是这个样子的：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/6c1a1df9a99150a6.png)

你的主屏幕看起来应该像这样：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/img/31adaca378656d60.png)

> 有关颜色（Color）和主题(Theme)的注意事项：
>
> *  你可以自定义 UI 中的颜色以便诠释你的品牌特色。
> *  从两种颜色（主要和次要颜色）开始制作调色板，使用不同色度的颜色。或者使用 Material Design 调色盘工具生成。
> *  不要忘记排版的颜色！
> *  确保文本与背景的颜色对比度适中（主文本为 3:1，副文本为 4:1）

## 5. 修改排版和标签样式

除了更改颜色，设计师还为我们提供了特定的排版。Flutter 的 ThemeData 包含 3 种文本主题。每个文本主题都是一个文本样式的集合，如 “headline” 和 “title”。我们将为我们的应用使用几种样式并更改一些值。

### 定制文本主题

为了将字体导入项目，我们必须将它们添加到 pubspec.yaml 文件中。

在 pubspec.yaml 中，在 `flutter:` 标签下添加以下内容：

```
  # TODO：引入字体（103）
  fonts:
    - family: Rubik
      fonts:
        - asset: fonts/Rubik-Regular.ttf
        - asset: fonts/Rubik-Medium.ttf
          weight: 500
```

现在你可以访问并使用 Rubik 字体了。

### pubspec 文件故障排除

如果你剪切并粘贴上面的声明代码，你可能会在运行 **pub get** 时遇到错误。如果出现错误，请先删除前导空格，然后使用空格缩进替换空格。

```
fonts:
```

之前有两个空格，

```
family: Rubik
```

之前有四个空格，以此类推。

如果你看到 **Mapping values are not allowed here（此处不允许存在映射值）**，检查问题所在行以及上方的其他行的缩进。

`app.dart` 中，在 `_buildShrineTheme()` 之后添加如下内容：

```
// TODO：构建 Shrine 文本主题（103）
TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kShrineBrown900,
    bodyColor: kShrineBrown900,
  );
}
```

这需要一个**文本主题**并且更改 headline、titles 和 captions 的样式。

用这种方式应用 `fontFamily` 仅将更改应用于 `copyWith()` 字段中指定的（headline, title, caption）排版比例。

对于某些字体，我们正在为其设置自定义 FontWeight。**FontWeight** 部件在 100s 上具有方便的值。在字体中，w500（权值（weight）500）是中等大小，w400 是常规大小。

### 使用新的文本主题

> ### 文本主题
>
>文本主题是确保应用内所有文本一致且可读的有效方法。例如，文本主题样式可以是黑色或白色，具体取决于主题主要颜色的亮度。这可确保文本与背景形成适当的对比，使其始终可读。
>
> 在 [Flutter 文档](https://docs.flutter.io/flutter/material/TextTheme-class.html)中了解有关文本主题的更多信息。

在 `_buildShrineTheme` 的 errorColor 后添加以下内容：

```
// TODO：添加文本主题（103）

textTheme: _buildShrineTextTheme(base.textTheme),
primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
```

在点击停止按钮后再次点击允许按钮。

登陆页面和主屏幕中的文本看起来有些不同 —— 有些使用 Rubik 字体，其他文本则呈现棕色，而不是黑色或白色。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/2153d8c98cafac14.png)

> 有关排版的注意事项：
>
> *  当选择文本字体时注意，为小号和主体文本选择清晰的字体，而不是注重某种样式。
> *  用作标题的、大号文本的字体应该用来表达或强调品牌。

注意到没有，我们的图标仍然时白色的，这是因为它们有一个另外的主题。

### 使用自定义的主要图标主题

将其添加到 `_buildShrineTheme()` 函数：

```
// TODO: 添加图标主题（103）
primaryIconTheme: base.iconTheme.copyWith(
    color: kShrineBrown900
),
```

单击运行按钮。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/9489cc4b3274b10a.png)

应用栏的图标变成棕色的了！

### 收缩文本

我们的标签有点太大了。

在 `home.dart` 中，改变 `children:` 字段最内部的列：

```
// TODO：改变最内部的列（103）
children: <Widget>[
// TODO：处理溢出标签（103）

  Text(
    product == null ? '' : product.name,
    style: theme.textTheme.button,
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  ),
  SizedBox(height: 4.0),
  Text(
    product == null ? '' : formatter.format(product.price),
    style: theme.textTheme.caption,
  ),
  // 新增代码结尾
],
```

### 居中放置文本

我们想要将标签居中，并将文本与每张卡片的底部，而不是图片的底部对齐。

将标签移动到主轴的结尾（底部）并将它们改为居中：

```
// TODO：将标签对齐底部和中心（103）

  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.center,
```

保存项目。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/8c639fa1b15fd7a5.png)

已经很接近了，但是文本还不是在卡片的居中位置。

更改父列的横轴对齐：

```
// TODO：卡片内容居中（103）

    crossAxisAlignment: CrossAxisAlignment.center,
```

保存项目。你的应用应该看起来像这样：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/136b6248cce28ba6.png)

这样看起来好多了。

### 主题化文本框

你也可以使用 **InputDecorationTheme** 来主题化文本框的修饰。

 在 `app.dart` 中的 `_buildShrineTheme()` 方法里，指定 `inputDecorationTheme:` 的值：

```
// TODO：修饰输入内容（103）

inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(),
),
```

现在，文本框有一个 `filled` 修饰。让我们移除它。

在 `login.dart` 内，移除 `filled: true` 值：

```
// 移除 filled: true 值（103）
TextField(
  controller: _usernameController,
  decoration: InputDecoration(
    // 移除 filled: true
    labelText: 'Username',
  ),
),
SizedBox(height: 12.0),
TextField(
  controller: _passwordController,
  decoration: InputDecoration(
    // 移除 filled: true
    labelText: 'Password',
  ),
  obscureText: true,
),
```

单击停止按钮，然后单击运行（为了从头开始启动应用程序）。你的登陆页面在用户名文本框处于活动状态时（当你输入时）应该是这样的：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/ea7b1fcf376cbc1.png)

在正确的强调色文本框修饰和浮动占位符渲染中输入。但是我们不能轻易地看到它。给那些无法区分足够高色彩对比度像素的人带设置了障碍。（更多详细信息，参看 Material 指南中有关“无障碍颜色”的[色彩文章](https://material.io/design/color/)。）让我们创建一个特殊类来覆盖部件的强调颜色，将其变成设计师在上面的颜色主题中为我们提供的 PrimaryVariant。

在 `login.dart` 中任何其他类的范围之外添加以下内容：

```
// TODO：添加强调色覆盖（103）
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(accentColor: color),
    );
  }
}
```

下一步，将 `AccentColorOverride` 应用到文本框。

在 `login.dart` 中，导入 colors：

```
import 'colors.dart';
```

使用新的部件包装 Username 文本框：

```
// TODO：使用 AccentColorOverride 包装 Username（103）
// [Name]
AccentColorOverride(
  color: kShrineBrown900,
  child: TextField(
    controller: _usernameController,
    decoration: InputDecoration(
      labelText: 'Username',
    ),
  ),
),
```

同样使用新的部件包装 Password 文本框：

```
// TODO：使用 AccentColorOverride 包装 Password（103）
// [Password]
AccentColorOverride(
  color: kShrineBrown900,
  child: TextField(
    controller: _passwordController,
    decoration: InputDecoration(
      labelText: 'Password',
    ),
  ),
),
```

单击运行按钮。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/added42041a83345.png)

## 6. 调整高度

现在你已经为页面设置了与 Shrine 相匹配的特定颜色和排版，让我们看看展示 Shrine 产品的卡片。这些卡片位于导航旁边的白色平面上。

### 调整卡片高度

在 `home.dart` 中为卡片添加 `elevation:` 值：

```
// TODO：调整卡片高度（103）

    elevation: 0.0,
```

保存你的项目。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/52920c70743adf6e.png)

现在你已经移除了卡片下的阴影。

让我们更改登陆页面组件的高度来补全它。

### 调整 NEXT 按钮的高度

RaisedButton 的默认高度是 2。让我们把它调高一点。

在 `login.dart` 中为 **NEXT** RaisedButton 添加 `elevation:` 值：

```
RaisedButton(
  child: Text('NEXT'),
  elevation: 8.0, // 新增代码
```

单击停止按钮，然后单击运行。你的登陆页面看起来应该是这样的：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/9346cdffc30760da.png)  

> 关于高度(Elevation)的说明：
>
> *  所有 Material Design 的平面（surface）和组件都拥有高度值。
> *  一个平面末尾与另一个平面开始的分隔由平面的边缘区分。
> *  表面之间的高差可以使用暗淡的或明亮的背景或阴影来表示。
> *  其它平面前的平面通常包含更重要的内容。

## 7. 添加形状

Shrine 定义了八角形或矩形的元素，它具有酷炫的几何风格。让我们在主屏幕上的卡片以及登录屏幕上的文本字段和按钮中实现形状样式。

### 在登录屏幕上更改文本字段的形状

在 `app.dart` 中，导入 special cut corners border 文件：

```
import 'supplemental/cut_corners_border.dart';
```

还是在 `app.dart` 中，在文本字段的修饰主题上添加一个带有切角的形状：

```
// TODO：修饰输入内容（103）
inputDecorationTheme: InputDecorationTheme(
  border: CutCornersBorder(), // 替换代码
),
```

### 在登录屏幕上更改按钮形状

在 `login.dart` 中，向 **CANCEL** 按钮添加一个斜面矩形边框：

```
FlatButton(
  child: Text('CANCEL'),

  shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  ),
```

FlatButton 没有可见的形状，为什么我们要添加边框形状？这样触摸时，波纹动画将绑定到相同的形状。

现在给 NEXT 按钮添加同样的形状：

```
RaisedButton(
  child: Text('NEXT'),
  elevation: 8.0,
  shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  ),
```

> 关于形状的说明：
>
> *  使用形状可以促进品牌的视觉表达。
> *  形状具有可调曲线和无角度拐角，曲线和边角以及拐角总数。
> *  组件的形状不应该干扰其可用性！

单击停止按钮，然后单击运行：

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/a05e9659fd90b969.png)

## 8. 修改布局

接下来，让我们更改布局以显示不同宽高比和大小的卡片，以便使每张卡片看起来都是不同的。

### 用 AsymmetricView 替换 GridView

我们已经为不对称的布局编写了文件。

在 `home.dart` 中，修改以下所有文件：

```
import 'package:flutter/material.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
import 'supplemental/asymmetric_view.dart';

class HomePage extends StatelessWidget {
  // TODO：为 Category 添加变量（104）

  @override
  Widget build(BuildContext context) {
  // TODO：返回一个 AsymmetricView（104）
  // TODO：传递 Category 变量给 AsymmetricView（104）
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Menu button');
          },
        ),
        title: Text('SHRINE'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      body: AsymmetricView(products: ProductsRepository.loadProducts(Category.all)),
    );
  }
}
```

保存项目。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/ed68ec421f46e598.png)

现在产品以编织图案风格水平滚动。此外状态栏文本（顶部的时间和网络）现在为黑色。那是因为我们将 AppBar 的 brightness 改为了 light，`brightness: Brightness.light`

## 9. 尝试另一个主题

颜色是诠释品牌的有效方式，颜色的微小变化会对您的用户体验产生很大影响。为了测试这一点，让我们看看如果品牌的配色方案完全不同时 Shrine 会是什么样子。

### 修改颜色

在 `colors.dart` 中，添加以下内容：

```
const kShrineAltDarkGrey = const Color(0xFF414149);
const kShrineAltYellow = const Color(0xFFFFCF44);
```

在 `app.dart` 中，按照以下内容修改 `_buildShrineTheme()` 和 `_buildShrineTextTheme` 方法：

```
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    accentColor: kShrineAltDarkGrey,
    primaryColor: kShrineAltDarkGrey,
    buttonColor: kShrineAltYellow,
    scaffoldBackgroundColor: kShrineAltDarkGrey,
    cardColor: kShrineAltDarkGrey,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      color: kShrineAltYellow
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: CutCornersBorder(),
    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
      fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kShrineSurfaceWhite,
    bodyColor: kShrineSurfaceWhite,
  );
}
```

在 `login.dart` 中，将钻石标志变成白色：

```
Image.asset(
  'assets/diamond.png',
  color: kShrineBackgroundWhite, // 新增代码
),
```

还是在 `login.dart` 中，将两个文本字段的强调色覆盖更改为黄色：

```
AccentColorOverride(
  color: kShrineAltYellow, // 修改的代码
  child: TextField(
    controller: _usernameController,
    decoration: InputDecoration(
      labelText: 'Username',
    ),
  ),
),
SizedBox(height: 12.0),
AccentColorOverride(
  color: kShrineAltYellow, // 修改的代码
  child: TextField(
    controller: _passwordController,
    decoration: const InputDecoration(
      labelText: 'Password',
    ),
  ),
),
```

在 `home.dart` 中，修改 brightness 为 dark：

```
brightness: Brightness.dark,
```

保存项目。现在应该出现新的主题了。

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/8916ab5abc89be45.png)

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/dc23dbb043a99db.png)

结果非常不同！让我们在转到 104 教程之前还原这个颜色代码。

[下载 MDC-104 初始代码](https://github.com/material-components/material-components-flutter-codelabs/archive/104-starter_and_103-complete.zip)

## 10. 总结

到目前为止，您已经创建了一个按照设计师设计规范设计的应用程序。

> 完整的 MDC-103 应用程序可在 `104-starter_and_102-complete` 分支中找到。
>
> 您可以针对该分支中的应用测试您的页面版本。

### 下一步

你现在已经使用过了以下 MDC 组件：主题、排版、高度和形状。你可以在 MDC-Flutter 库中探索更多组件和子系统。

深入 `supplemental` 目录中的文件来了解我们是如何制作水平滚动的，非对称的布局网格的。

如果您的应用程序设计包含 MDC 库中没有的组件元素该怎么办？在 [MDC-104: Material Design 高级组件](https://codelabs.developers.google.com/codelabs/mdc-104-flutter)一文中我们将展示如何使用 MDC 库创建自定义组件以实现特定外观。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
