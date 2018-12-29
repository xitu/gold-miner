> * 原文地址：[Zero to One with Flutter](https://medium.com/flutter-io/zero-to-one-with-flutter-43b13fd7b354)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md)
> * 译者：
> * 校对者：

# Flutter 从 0 到 1 

2016年夏末,丹麦奥古斯谷歌办公室。 我来谷歌的第一个任务，是使用[_Flutter_](https://flutter.io) 和 [_Dart_](https://www.dartlang.org) 在Android/iOS应用程序中实现动画图表。 除了是一个谷歌新人之外， 我对Flutter，Dart，动画都不熟悉。事实上，我之前从未做过移动应用程序。我的第一部智能手机也只有几个月的历史——我是在一阵恐慌中买的，因为担心使用我的老诺基亚可能会导致电话面试失败……
我确实对桌面Java中的图表有过一些经验，但哪些图表并不是动画的。 我感到......惊奇。 部分是恐龙，部分重生.

![](https://cdn-images-1.medium.com/max/800/1*2t8GffL0BcNoGLU-IgHT9w.jpeg)

**长话短说** 在使用Dart开发Android/iOS应用程序的图表动画时，我发现Flutter的widget和tween的优点。

2018年8月7日更新，适配Dart 2语法. [GitHub repo](https://github.com/mravn/charts)在2018年10月17日添加。 下面描述的每个步骤都是单独提交的。

* * *

迁移到新的开发栈可以让您了解自己对技术的优先级。在我的清单上排在前三位的是：

* **强大的概念**通过提供简单的，相关的构造方法，逻辑或数据，从而有效地处理复杂度。
* **清晰的代码**让我们可以清晰地表达概念，不被语言陷阱、过多的引用或者辅助细节所干扰。。
* **快速迭代**是实验和学习的关键 - 软件开发团队以学习为生：需求到底是什么，以及如何通过最优的代码实现它。


Flutter是用Dart实现，可以用一套代码同时构建Android和iOS应用的新平台。由于我们的需求涉及到一个相当复杂的UI，包括动画图表，所以只构建一次的想法似乎非常有吸引力。我的任务包括使用Flutter的CLI工具，一些预先构建的Widgets及其它的2D渲染引擎。除了编写大量Dart代码来构建模型和动画图表外。我将在下面分享一些重点概念，并为您自己评估Flutter / Dart栈提供一个参考。

![](https://cdn-images-1.medium.com/max/800/1*OKV3RzTg89W3VxXnpAH3Eg.gif)

一个简单的动画条形图，在开发过程中从iOS模拟器获取

这是Flutter及其“widgets”和“tween”概念介绍的[两部分]（https://medium.com/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb）中的第一部分。 我将通过使用它们实现显示和动画，如上图所示的图表，来说明这些概念的强大之处。 完整的代码示例将给你Dart代码能清晰表达问题的印象。 我将包含足够的细节，您应该能够在自己的笔记本电脑（以及模拟器或设备）上进行操作，并体验Flutter开发周期的长度。

开始，[Flutter安装]（https://flutter.io/setup）。在终端运行

```
$ flutter doctor
```

检查设置：

```
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter
    (Channel beta, v0.5.1, on Mac OS X 10.13.6 17G65, locale en-US)
[✓] Android toolchain - develop for Android devices
    (Android SDK 28.0.0)
[✓] iOS toolchain - develop for iOS devices (Xcode 9.4)
[✓] Android Studio (version 3.1)
[✓] IntelliJ IDEA Community Edition (version 2018.2.1)
[✓] Connected devices (1 available)

• No issues found!
```

以上复选框都满足了，您将可以创建一个Flutter应用程序了。我们命名它为charts ：

```
$ flutter create charts
```

目录结构：

```
charts
  android
  ios
  lib
    main.dart
```

大约生成60个文件，组成一个可以安装在Android和iOS上的完整示例程序。 我们将在`main.dart`和它的同级文件中完成所有编码，而不需要触及任何其他文件或目录。

您应该验证是否可以启动示例程序。 启动模拟器或插入设备，然后在`charts`目录中，执行

```
$ flutter run
```
您应该在模拟器或设备上看到一个简单的计数应用程序。 它默认使用MD风格的widgets，但这是可选的。作为Flutter架构的最顶层，这些widgets是完全可替换的。

* * *

让我们首先用下面的代码替换`main.dart`的内容，作为玩转图表动画的简单起点。

```
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
  final random = Random();
  int dataSet;

  void changeData() {
    setState(() {
      dataSet = random.nextInt(100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Data set: $dataSet'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}
```

保存更改，然后重新启动应用程序。 您可以通过按“R”从终端执行此操作。 这种“完全重启”操作会重置应用程序状态，然后重建UI。 对于在代码更改后，现有应用程序状态仍然有效的情况，可以按“r”执行“热重载”，这只会重建UI。 IntelliJ IDEA安装Flutter插件，它提供了Dart编辑器集成相同的功能：

![](https://cdn-images-1.medium.com/max/800/1*soCdZ19Qugtv1YJewMQZGg.png)

屏幕截图来自IntelliJ IDEA，带有旧版本的Flutter插件，显示右上角的重新加载和重启按钮。 如果已在IDE中启动应用程序，则启用这些按钮。 较新版本的插件会在保存时进行热重载。

重新启动后，应用程序会显示一个居中的文本标签，上面写着“Data set：null”和一个浮动操作按钮来刷新数据。
要了解热重载和完全重启之间的区别，请尝试以下操作：按几次浮动操作按钮后，记下当前数据集编号，然后将代码中的Icons.refresh改为Icons.add，保存并执行热重载。观察按钮已经改变，但程序的状态仍然保留; 我们仍然在文本上显示获取的随机数。现在撤消Icon更改，保存并完全重新启动。 应用程序状态已重置，文本标签显示最初状态“Data set：null”。

我们简单的应用程序显示了Flutter Widget两个核心方面：

*   用户界面由**不可变的widgets**树定义，它是通过调用构造函数（你可以在其中配置widgets）和`build`方法构建的（其中widget可以决定子树的外观））。 我们的应用程序生成的树结构如下所示，每个widget的主要内容都在括号中。 正如您所看到的，虽然widget概念非常广泛，但每个具体widget类型通常都具有非常集中的职责。
```
MaterialApp                    (navigation)
  ChartPage                    (state management)
    Scaffold                   (layout)
      Center                   (layout)
        Text                   (text)
      FloatingActionButton     (user interaction)
        Icon                   (graphics)
```

*   使用定义用户界面的不可变widget的不可变树，更改该界面的唯一方法是重建树。当下一帧到期时，Flutter会处理这个问题。我们所要做的就是告诉Flutter一个子树所依赖的状态已经改变了。这种**状态依赖子树**的根必须是`StatefulWidget`。像任何像样的widget一样，`StatefulWidget`不是可变的，但是它的子树是由`State`对象构建的。 Flutter在树重建期间保留“State”对象，并在构建期间将每个对象附加到新树中的各自widget。然后，他们确定该widget的子树是如何构建的。在我们的应用程序中，`ChartPage`是一个`StatefulWidget`，`ChartPageState`为``State`。每当用户按下按钮时，我们执行一些代码来改变`ChartPageState。我们用`setState`划分了变化，以便Flutter可以进行内务处理并安排widget树进行重建。当发生这种情况时，`ChartPageState`将构建一个稍微不同的子树，该子树以新的`ChartPage`实例为根。

不可变widget和状态相关子树是Flutter为解决复杂UI中状态管理的复杂性而应对的主要工具，这些UI响应异步事件，如按钮按下，计时器滴答或传入数据。 从我的桌面体验来看，我会说这种复杂性是非常真实的。 评估Flutter方法的力量是 - 而且应该 - 是读者的练习：尝试一些非平凡的事情。

* * *

我们的图表应用程序将在widget结构方面保持简单，但我们会做一些动画自定义图形。 第一步是用非常简单的图表替换每个数据集的文本表示。 由于数据集当前只涉及区间“0..100”中的单个数字，因此图表将是带有单个条形的条形图，其高度由该数字决定。 我们将使用初始值“50”来避免“null”高度：

```
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
  final random = Random();
  int dataSet = 50;

  void changeData() {
    setState(() {
      dataSet = random.nextInt(100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
          painter: BarChartPainter(dataSet.toDouble()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(this.barHeight);

  final double barHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => barHeight != old.barHeight;
}
```

`CustomPaint`是一个widget，它将绘画委托给`CustomPainter`策略。 我们对该战略的实施只能形成一个障碍。

下一步是添加动画。 每当数据集发生变化时，我们都希望条形平滑而不是突然地改变高度。 Flutter有一个用于编排动画的`AnimationController`概念，通过注册一个监听器，我们被告知动画值 - 从零到一的双重运算 - 何时发生变化。 每当发生这种情况时，我们可以像以前一样调用`setState`并更新`ChartPageState`。

出于解释的原因，我们首先要做的就是丑陋：

```
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  final random = Random();
  int dataSet = 50;
  AnimationController animation;
  double startHeight;   // Strike one.
  double currentHeight; // Strike two.
  double endHeight;     // Strike three. Refactor.

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        setState(() {
          currentHeight = lerpDouble( // Strike one.
            startHeight,
            endHeight,
            animation.value,
          );
        });
      });
    startHeight = 0.0;                // Strike two.
    currentHeight = 0.0;
    endHeight = dataSet.toDouble();
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      startHeight = currentHeight;    // Strike three. Refactor.
      dataSet = random.nextInt(100);
      endHeight = dataSet.toDouble();
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
          painter: BarChartPainter(currentHeight),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(this.barHeight);

  final double barHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => barHeight != old.barHeight;
}
```

哎哟。 复杂性已经让人头疼，我们的数据集仍然只是一个数字！ 设置动画控件所需的代码是一个小问题，因为当我们获得更多图表数据时它不会分支。 真正的问题是变量`startHeight`，`currentHeight`和`endHeight`，它们反映了对数据集和动画值所做的更改，并在三个不同的地方进行了更新。

我们需要一个概念来处理这个烂摊子。

* * *

输入**tweens**。 虽然远非Flutter独有，但它们是构造动画代码的一个令人愉快的简单概念。 他们的主要贡献是用功能性方法取代上面的命令式方法。 补间是_value_。 它描述了在其他值的空间中的两个点之间的路径，如条形图，因为动画值从零到一个。

![](https://cdn-images-1.medium.com/max/800/1*3KpUQjhZLrvwvjF0daKg9g.jpeg)

补间在这些其他值的类型中是通用的，并且可以在Dart中表示为“Tween <T>”类型的对象：

```
abstract class Tween<T> {
  final T begin;
  final T end;
  
  Tween(this.begin, this.end);
  
  T lerp(double t);
}
```

行话`lerp`来自计算机图形学领域，是_linear interpolation_（作为名词）和_linearly interpolate_（作为动词）的缩写。 参数`t`是动画值，因此补间应该从`begin`（当`t`为零时）到`end`（当`t`为1时）。

Flutter SDK的`[Tween <T>]（https://docs.flutter.io/flutter/animation/Tween-class.html）`类与上面的类很相似，但它是一个支持变异`begin的具体类 `和`结束`。 我不完全确定为什么会做出这样的选择，但是在我尚未探索的SDK动画支持方面可能有很好的理由。 在下面，我将使用Flutter`Tween <T>`，但假装它是不可变的。

我们可以使用单个“Twin <double>”来清理代码：

```
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  final random = Random();
  int dataSet = 50;
  AnimationController animation;
  Tween<double> tween;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    tween = Tween<double>(begin: 0.0, end: dataSet.toDouble());
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      dataSet = random.nextInt(100);
      tween = Tween<double>(
        begin: tween.evaluate(animation),
        end: dataSet.toDouble(),
      );
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
          painter: BarChartPainter(tween.animate(animation)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(Animation<double> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final barHeight = animation.value;
    final paint = Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}
```

我们使用`Tween`将条形高度动画端点打包在一个值中。 它与`AnimationController`和`CustomPainter`整齐地接口，避免了动画期间的widgets树重建，因为Flutter基础设施现在标记`CustomPaint`用于在每个动画刻度处重绘，而不是标记整个`ChartPage`子树用于重建，重新布局和重绘。 这些都是明确的改进。 但补间概念还有更多内容; 它提供_structure_来组织我们的想法和代码，我们并没有真正认真对待。 补间概念说，

_Animate_` _T_`_s通过遍历all_`_T_`_s空间中的路径，因为动画值从零运行到1。 用a_` _Tween <T> _` _._建模路径

在上面的代码中，`T`是一个`double`，但我们不想动画`double`s，我们想要制作条形图的动画！ 嗯，好的，现在是单杠，但概念很强，如果我们让它，它会扩展。

（你可能想知道为什么我们不进一步采用这个论点并且坚持动画数据集而不是它们的表示作为条形图。这是因为数据集 - 与条形图是图形对象 - 通常不会占据空间 存在平滑路径的情况。条形图的数据集通常涉及根据离散数据类别映射的数字数据。但如果没有条形图的空间表示，则涉及不同类别的两个数据集之间没有合理的平滑路径概念。）

回到我们的代码，我们需要一个`Bar`类型和一个`BarTween`来为它设置动画。 让我们将与bar相关的类提取到`main.dart`旁边的`bar.dart`文件中：

```
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Bar {
  Bar(this.height);

  final double height;

  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(lerpDouble(begin.height, end.height, t));
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(Animation<Bar> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<Bar> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final bar = animation.value;
    final paint = Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - bar.height,
        barWidth,
        bar.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}
```

我在遵循一个Flutter SDK约定，在`Bar`类的静态方法中定义`BarTween.lerp`。 这适用于简单类型，如“Bar”，“Color”，“Rect”等等，但我们需要重新考虑更多涉及图表类型的方法。 Dart SDK中没有`double.lerp`，所以我们使用`dart：ui`包中的`lerpDouble`函数来达到同样的效果。

我们的应用程序现在可以用条形重新表达，如下面的代码所示; 我借此机会分发了`dataSet`字段。

```
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'bar.dart';

void main() {
  runApp(MaterialApp(home: ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  final random = Random();
  AnimationController animation;
  BarTween tween;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    tween = BarTween(Bar(0.0), Bar(50.0));
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      tween = BarTween(
        tween.evaluate(animation),
        Bar(random.nextDouble() * 100.0),
      );
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
          painter: BarChartPainter(tween.animate(animation)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}
```

新版本更长，额外的代码应该承担其重量。 当我们在[第二部分]（https://medium.com/@mravn/zero-to-one-with-flutter-part-two-5aa2f06655cb）中解决增加的图表复杂性时，它将会出现。 我们的要求涉及彩条，多条，部分数据，堆叠条，分组条，堆叠和分组条，......所有这些都是动画的。 敬请关注。

![](https://cdn-images-1.medium.com/max/800/1*n76TpChNv8Q25WrfBiuWpw.gif)

我们将在第二部分中对其中一个动画进行预览。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
