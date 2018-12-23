> * 原文地址：[MDC-102 Flutter: Material Structure and Layout (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-102-flutter)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
> * 译者：[DevMcryYu](https://github.com/devmcryyu)
> * 校对者：

# MDC-102 Flutter：Material 结构和布局（Flutter）

## 1. 介绍

![](https://lh4.googleusercontent.com/yzZPYGHe5CrFE-84MXhqwb_y7YjCKLWQJHI7W7zqbT9_qdK8qufFjx51kepr3ITvZtF7vD3d72nurt-HPBARmQ6RF74PD1FwGZMNbXphLap4LqIEBCKWP5OxK2Vjeo-YEY3-oeIP)Material Components（MDC）帮助开发者实现 Material Design。MDC 由谷歌团队的工程师和 UX 设计师创造，为 Android、iOS、Web 和 Flutter 提供很多美观实用的 UI 组件。

material.io/develop

在教程 [MDC-101](https://codelabs.developers.google.com/codelabs/mdc-101-flutter) 中，你使用了两个 Material 组件：文本框和墨水波纹效果的按钮来构建一个登陆页面。现在让我们通过添加导航、结构和数据来拓展应用。

### 你将要构建

在本教程中,你将为 **Shrine** ——  一个销售服装和家居用品的电子商务应用程序构建一个主页面。它将含有：

*   一个位于顶部的应用栏
*   一个由产品填充的网格列表

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/532fe80b3fa3db74.png)

> 这是四篇教程里的第二篇，它将引导你为 Shrine 的产品构建应用程序。我们建议你按照教程的顺序一步一步地编写你的代码。
>
> 相关的教程可以在以下位置找到：
>
> *   [MDC-101: Material Components（MDC）基础](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
> *   [MDC-103: Material Design Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> *   [MDC-104: Material Design 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)。
>
> 到 MDC-104 的最后，你将会构建一个像这样的应用：
>
> ![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/e23a024b60357e32.png)

### 将要用到的 MDC 组件

*   顶部应用栏（Top app bar）
*   网格（Grid）
*   卡片（Card）

> 本教程中，你将使用 MDC-Flutter 提供的默认组件。你将会在 [MDC-103: Material Design Theming 的颜色、形状、高度和类型](https://codelabs.developers.google.com/codelabs/mdc-103-flutter)中学习如何定制它们。

### 你将需要

*   [Flutter SDK](https://flutter.io/setup/)
*   安装好 Flutter 插件的 Android Studio，或者你喜欢的代码编辑器
*   示例代码

#### 要在 iOS 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS 的计算机
*   Xcode 9 或更新
*   iOS 模拟器，或者 iOS 物理设备

#### 要在 Android 上构建和运行 Flutter 应用程序，你需要满足以下要求：

*   运行 macOS、 Windows 或 Linux 的计算机
*   Android Studio
*   Android 模拟器（随 Android Studio 一起提供）或 Android 物理设备

## 2. 安装 Flutter 环境

### 前提条件

要开始使用 Flutter 开发移动应用程序，你需要：

*   [Flutter SDK](https://flutter.io/setup/)
*   装有 Flutter 插件的 IntelliJ IDE，或者你喜欢的代码编辑器

Flutter 的 IDE 工具适用于 [Android Studio](https://developer.android.com/studio/index.html)、[IntelliJ IDEA Community（免费）和 IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/download/)。

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

### 从 MDC-101 继续？

如果你完成了 MDC-101，那么本教程所需代码应该已经准备就绪，跳转到 _添加应用栏_ 步骤。

### 从头开始？

### 下载初始应用程序

[下载初始程序](https://github.com/material-components/material-components-flutter-codelabs/archive/102-starter_and_101-complete.zip)

此入门程序位于 `material-components-flutter-codelabs-102-starter_and_101-complete/mdc_100_series` 目录中。

### ...或者从 GitHub 克隆它

要从 GitHub 克隆此项目，请运行以下命令：

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 102-starter_and_101-complete
```

> 更多帮助：[从 GitHub 上克隆存储库](https://help.github.com/articles/cloning-a-repository/)

> ### 正确的分支
>
> 教程 MDC-101 到 104 连续构建。所以当你完成 102 的代码后，它将变成 103 教程的初始代码！代码被分成不同的分支，你可以使用以下命令将它们全部列出：
>
> `git branch --list`
>
> 要查看完整代码，请切换到 `103-starter_and_102-complete` 分支。

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

> **提示：** 确保你已安装 [ Flutter 和 Dart 插件](https://flutter.io/get-started/editor/#androidstudio)。

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

成功！Shrine 的初始登陆代码应该在你的模拟器中运行了。你可以看到 Shrine 的 logo 和它下面的名称 "Shrine"。

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/db3def4f18a58eed.png)

现在登录页面看起来不错，让我们用一些产品来填充应用。

## 4. 添加顶部应用栏

。当登陆页面消失时主页面将出现并显示“你做到了！”。这很棒！但是我们的用户不知道能做什么操作，也不知道现在位于应用何处，为了解决这个问题，是时候添加导航了。

> **导航** 是指允许用户在应用中移动的组件、交互、视觉提示和信息结构。它使得内容和功能更加注目，任务也因此易于完成。
>
> 在 Material 指南中了解更多有关[导航](https://material.io/design/navigation/)的信息。

Material Design 提供确保高度可用性的导航模式，其中最注目的组件就是顶部应用栏。

> 你可以将顶部应用栏当作 iOS 中的“导航栏”，或者简单看成一个“App Bar”或 “Header”。

要提供导航并让用户快速访问其他操作，让我们添加一个顶部应用栏。

### 添加应用栏部件

在 `home.dart` 中，将应用栏添加到 Scaffold 中：

```
return Scaffold(
  // TODO: 添加应用栏（102）
  appBar: AppBar(
    // TODO: 添加按钮和标题（102）
  ),
```

将 **AppBar** 添加到 Scaffold 的 `appBar:` 字段位置，为了我们完美的布局，让应用栏保持在页面的顶部或底部。
> **Scaffold** 在中是一个重要的部件。它为像抽屉、snack bar 和 bottom sheet等各种常见 Material 组件提供方便的 API。它甚至可以帮助布置一个 Floating Action Button。
>
> 在 [Flutter 文档](https://docs.flutter.io/flutter/material/Scaffold-class.html)中了解更多有关 Scaffold 的信息。

保存项目，当 Shrine 应用更新后，单击 **Next** 来查看主屏幕。

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/431c9976adc79f2.png)

应用栏看起来不错，但它还需要一个标题。

> 如果应用没有更新，再次单击“Play”按钮，或者点击“Play”后的“Stop”。

### 添加文本部件

在 `home.dart` 中，给应用栏添加一个标题：

```
// TODO: 添加应用栏（102）  
  appBar: AppBar(
    // TODO: 添加按钮和标题（102）

    title: Text('SHRINE'),
        // TODO:添加后续按钮（102）
```

保存项目。

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/a858ee63d25880f2.png)

> 到目前为止，你应该已经注意到我们所说的“平台差异”了。Material 明白 Android、iOS、Web 各平台都有差异。用户对他们有不同的期望。举例来说，在 iOS 里标题几乎总是居中的，这是 UIKit 提供的默认配置。在 Android 上标题是左对齐的。所以如果你使用的是 Android 模拟器或设备，那么标题应该位于左侧，对于 iOS 模拟器和设备而言，它应该是居中的。
>
> 了解更多信息，请查参阅有关跨平台适配的 [Material 文章](https://material.io/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines)。

许多应用栏在标题旁边都设有按钮，让我们在应用中添加一个菜单图标。

### 添加位于首部的图标按钮

还是在 `home.dart` 中，在 AppBar 的 `leading` 字段设置一个图标按钮：（放在 `title:` 字段前，按照部件从首到尾的顺序）：

```
return Scaffold(
  appBar: AppBar(
    // TODO: 添加按钮和标题（102）
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        semanticLabel: 'menu',
      ),
      onPressed: () {
        print('Menu button');
      },
    ),
```

保存项目。

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/d03789520253636.png)

菜单图标（也被称作“汉堡包”）会在你期望的位置显示出来。

> [**IconButton**](https://docs.flutter.io/flutter/material/IconButton-class.html) 类是在你的应用里引入 [Material 图标](http://material.io/icons)的快捷方式。它有一个 **Icon** 部件。 Flutter 在 **Icons** 类里有整套的图标。它会根据字符串常量的映射自动导入图标。
>
> 在 [Flutter 文档](https://docs.flutter.io/flutter/material/Icons-class.html)中了解更多有关 Icons 类的信息。有关 Icon  部件的信息请阅读这个 [Flutter 文档](https://docs.flutter.io/flutter/widgets/Icon-class.html)。

你也可以在标题尾部添加按钮。在 Flutter 中，它们被称为 "action"。

> **Leading（首部）** 和 **trailing（尾部）** 是表达方向的术语，指的是与语言无关的文本行的开头和结尾。当使用一个像英语这样的 LTR（左到右）语言时，_leading_ 意味着 _左侧_ 而 _trailing_ 代表着 _右侧_ 。在像阿拉伯语这样的 RTL（右到左）语言时，_leading_ 意味着 _右侧_ 而 _trailing_ 代表着 _左侧_ 。
>
> 了解 UI 镜像的更多信息，请参阅 [ 双向性](https://material.io/guidelines/usability/bidirectionality.html) Material Design 准则。

### 添加 action

还有两个 IconButton 的空间。

在 AppBar 实例中的标题后面添加它们：

```
// TODO: 添加尾部按钮（102）
actions: <Widget>[
  IconButton(
    icon: Icon(
      Icons.search,
      semanticLabel: 'search',
    ),
    onPressed: () {
      print('Search button');
    },
  ),
  IconButton(
    icon: Icon(
      Icons.tune,
      semanticLabel: 'filter',
    ),
    onPressed: () {
      print('Filter button');
    },
  ),
],
```

保存你的项目。你的主屏幕看起来应该像这样：

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/a7020aee9da061dc.png)

现在这个应用在左侧有一个按钮、一个标题，右侧还有两个 action。应用栏还利用阴影显示**高度**，表示它与内容处于不同的层级。

> 在 Icon 类中，**SemanticLabel** 字段是在 Flutter 中添加辅助功能信息的常用方法。这很像Android 的 [ Content Label](https://support.google.com/accessibility/android/answer/7158690?hl=en) 或 iOS 的 [ UIAccessibility `accessibilityLabel`](https://developer.apple.com/documentation/uikit/accessibility/uiaccessibility?language=objc)。你会在很多类中见到它。
>
> 这个字段的信息很好地向使用屏幕阅读器的人说明了该按钮的作用。
>
> 对于没有 `semanticLabel:` 字段的部件，你可以将其包装在 **Semantics** 部件中，在其 [Flutter 文档](https://docs.flutter.io/flutter/widgets/Semantics-class.html)中了解更多有关的信息。

## 5. 在网格中添加卡片

现在我们的应用像点样子了，让我们接着放置一些卡片来组织内容。

> **卡片** 是显示单体内容和动作的独立的元素。它们是一种可以灵活地呈现近似内容集合的方式。
>
> 在 Material 指南有关[卡片](https://material.io/guidelines/components/cards.html)的文章中了解更多信息。
>
> 要了解卡片部件，请参阅[在 Flutter 中构建布局](https://flutter.io/tutorials/layout/)。

### 添加网格视图

让我们从应用栏底部添加一个卡片开始。单一的 **卡片** 部件不足以让我们将它放到我们想要的位置，所以我们需要将它封装在一个 **网格视图** 中。

用 GridView 替换 Scaffold 中 body 字段的 Center：

```
// TODO: 添加网格视图（102）
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  // TODO: 构建一组卡片（102）
  children: <Widget>[Card()],
),
```

让我们分析这段代码。网格视图调用 `count()` 构造函数，因要添加的项目数是可数的而不是无限的。但它需要更多信息来定义其布局。

`crossAxisCount:` 指定横向显示数目，我们设置成 2 行。

> Flutter 中的 **Cross axis（横轴）** 表示非滚动轴。可滚动的方向称为 **主轴**。所以如果你的应用像网格视图默认的那样垂直滚动，那么横轴就是水平方向。
>
> 详情请参阅[构建布局](https://flutter.io/tutorials/layout/)。

`padding:` 字段为网格视图的 4 条边设置填充。当然你现在看不到首尾的填充，因为网格视图内还没有其他子项。

`childAspectRatio:` 字段依据宽高比确定其大小。

默认地，网格视图中的项目尺寸相同。

将这些加在一起，网格视图按照如下方式计算每个子项的宽度：`([整个网格宽度] - [左填充] - [右填充]) / 列数`。 在这里就是：`([整个网格宽度] - 16 - 16) / 2`。

高度是根据宽度计算得来的，通过应用宽高比：`([整个网格宽度] - 16 - 16) / 2 * 9 / 8`。我们翻转了 8 和 9 ，因为我们是用宽度来计算高度。

我们已经有了一个空的卡片了，让我们添加一些子部件到卡片中。

### 布局内容

卡片内应该包含一张图片、一个标题和一个次级文本。

更新网格视图的子项：

```
// TODO: 构建一组卡片（102）
children: <Widget>[
  Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 18.0 / 11.0,
          child: Image.asset('assets/diamond.png'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title'),
              SizedBox(height: 8.0),
              Text('Secondary Text'),
            ],
          ),
        ),
      ],
    ),
  )
],
```

这段代码添加了一个列部件，用来垂直地布局子部件。

`crossAxisAlignment:` 字段指定 `CrossAxisAlignment.start` 属性，这意味着“文本与前沿对齐”。

**AspectRatio** 部件决定图像的形状，无论提供的是何种图像。

**Padding** 使得文本与边框保持一定距离。

两个 **Text** 部件垂直堆叠，在其间保持 8 个单位的间隔（**SizedBox**）。我们使用另一个 **Column** 来把它们放到  Padding 中。

保存你的项目：

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/781ef3ac46a65be3.png)

在这个预览里，你可以看到卡片从边缘置入，并带有圆角和阴影（这代表着卡片的高度）。整个形状在 Material 中被称为 “container（容器）”。（不要与名为 [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) 的实际部件类混淆。）

> 除了容器以外，在 Material 中卡片内所有的元素实际上都是可选的。你可以添加标题文本、缩略图、头像或者小标题文本、分隔符甚至是按钮和图标。
>
> 了解更多消息，请参阅 Material 指南上有关[卡片](https://material.io/guidelines/components/cards.html) 的文章。

卡片经常以集合的形式和其他卡片一起出现，让我们在网格视图中给它们布局。

## 6. 生成卡片集合

每当屏幕上出现多张卡片时，它们就会组成一个或多个集合。集合中的卡片是共面的，这意味着卡片共享相同的静止高度。（除了卡片被拾起或拖动，但在这里我们不会这么做。）

### 将卡片添加到集合

现在我们的卡片是网格视图内的 `children:` 字段子项。这有一大段难以阅读的嵌套代码。让我们将它提取到一个函数中来生成任意数量的空卡片，然后返回给我们。


```
// TODO: 生成卡片集合（102）
List<Card> _buildGridCards(int count) {
  List<Card> cards = List.generate(
    count,
    (int index) => Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.asset('assets/diamond.png'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Title'),
                SizedBox(height: 8.0),
                Text('Secondary Text'),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return cards;
}
```

将生成的卡片分配给网格视图的 `children` 字段。记得用新代码替换网格视图中的所有内容。

```
// TODO: 添加网格视图（102）
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  children: _buildGridCards(10) // 替换所有内容
),
```

保存你的项目：

卡片已经在这了，但它们什么都没有显示。现在是时候添加一些产品数据了。

###添加产品数据

这个应用中的产品有着图像、名称和价格。让我们把这些添加到已有的卡片部件中。

然后，在 `home.dart` 中，导入数据模型需要的新包和文件：

```
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
```

最后，更改 `_buildGridCards()` 来获取产品信息，并将数据应用到卡片中：

```
// TODO: 生成卡片集合（102）

// 替换整个方法
List<Card> _buildGridCards(BuildContext context) {
  List<Product> products = ProductsRepository.loadProducts(Category.all);

  if (products == null || products.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);
  final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString());

  return products.map((product) {
    return Card(
      // TODO: 调整卡片高度（103）
      child: Column(
        // TODO: 卡片的内容设置居中（103）
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
             // TODO: 调整盒子尺寸（102）
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
               // TODO: 标签底部对齐并居中（103）
               crossAxisAlignment: CrossAxisAlignment.start,
                // TODO: 更改最内部的列（103）
                children: <Widget>[
                 // TODO: 处理溢出的标签（103）
                 Text(
                    product.name,
                    style: theme.textTheme.title,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    formatter.format(product.price),
                    style: theme.textTheme.body2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}
```

**注意：** 应用现在无法编译和运行，我们还需要进行修改。

> 要设置文本的样式，我们使用当前 **BuildContext** 中的 **ThemeData** 。
>
> 了解有关文本样式的更多信息，请参阅 Material 指南中的[排版](https://material.io/design/typography/)一文。 了解有关主题的更多信息，请参考教程下一章 [MDC-103: Material Design Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)。

在尝试编译之前，将 **BuildContext** 传入 `build()` 方法中的 `_buildGridCards()`：

```
// TODO: Add a grid view (102)
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  children: _buildGridCards(context) // Changed code
),
```

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/7874b38e020afc1d.png)

你可能注意到了我们没有在卡片间添加任何垂直的间隔，这是因为在其顶部与底部默认有 4 个单位的填充。

保存你的项目：

产品的数据显示出来了，但是图像四周有额外的空间。图像默认依据 `.scaleDown` 的 **BoxFit** 绘制（在这个情况下）。让我们将其更改为 `.fitWidth` 来让它们放大一点，删除多余的空间。

修改图像的 `fit:` 字段：

```
  // TODO: 调整盒子尺寸（102）
  fit: BoxFit.fitWidth,
```

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/532fe80b3fa3db74.png)

现在我们的产品完美的展现在应用中了！

## 7. 总结

我们的应用已经有了基本的流程，将用户从登陆屏幕带到可以查看产品的主屏幕。通过几行代码，我们添加了一个顶部应用栏（带有标题和三个按钮）以及卡片（用于显示我们应用的内容）。我们的主屏幕简洁实用，具有基本的结构和可操作的内容。

> 完成的 MDC-102 应用可以在 `103-starter_and_102-complete` 分支中找到。
>
> 你可以用此分支下的应用来对照验证你的版本。

### 下一步

通过顶部应用栏、卡片、文本框和按钮，我们已经使用了 MDC-Flutter 库中的四个核心组件！你可以访问 [Flutter 部件目录](https://flutter.io/widgets/)来探索更多组件。

虽然它完全正常运行，我们的应用尚未表达任何特殊的品牌特点。在 [MDC-103: Material Design Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)中，我们将定制这些组件的样式，来表达一个充满活力的、现代的品牌。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
