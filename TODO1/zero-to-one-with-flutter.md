> * 原文地址：[Zero to One with Flutter](https://medium.com/flutter-io/zero-to-one-with-flutter-43b13fd7b354)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md)
> * 译者：
> * 校对者：

# Flutter 从 0 到 1 

2016年夏末,丹麦奥古斯谷歌办公室。 我接到来谷歌的第一个任务，使用[_Flutter_](https://flutter.io) 和 [_Dart_](https://www.dartlang.org) 在Android/iOS应用程序中实现动画图表。 除了是一个谷歌新人之外， 我对Flutter，Dart，动画都不熟悉。事实上，我之前从未做过移动应用程序。我的第一部智能手机只有几个月的历史——我是在一阵恐慌中买的，因为担心使用我的老诺基亚可能会导致电话面试失败……
我确实对桌面Java中的图表有过一些经验，但哪些图表并不是动画的。 我感到......惊奇。 部分是恐龙，部分重生.

![](https://cdn-images-1.medium.com/max/800/1*2t8GffL0BcNoGLU-IgHT9w.jpeg)

**长话短说** 在使用Dart开发Android/iOS应用程序的图标动画时，我发现Flutter的widget和tween的优势。

2018年8月7日更新，适配Dart 2语法. [GitHub repo](https://github.com/mravn/charts)在2018年10月17日添加。 下面描述的每个步骤都是单独的提交。

* * *

迁移到新的开发栈可以让您了解自己对技术的优先级。在我的清单上排在前三位的是：

* **强大的概念**通过简单的，相关的构思思想，逻辑或数据的方式，有效地处理复杂性。
* **清晰的代码**让我们可以清晰地表达概念，不被语言陷阱、过多的引用或者辅助细节所干扰。。
* **快速迭代**是实验和学习的关键 - 软件开发团队以学习为生：实际需求是什么，以及如何通过最优的代码实现它。


Flutter是用Dart实现，可以用一套代码同时构建Android和iOS应用的新平台。由于我们的需求涉及到一个相当复杂的UI，包括动画图表，所以只构建一次的想法似乎非常有吸引力。我的任务包括使用Flutter的CLI工具，一些预先构建的Widgets及其它的2D渲染引擎。除了编写大量Dart代码来构建模型和动画图表外。我将在下面分享一些重点概念，并为您自己评估Flutter / Dart栈提供一个参考。

![](https://cdn-images-1.medium.com/max/800/1*OKV3RzTg89W3VxXnpAH3Eg.gif)

一个简单的动画条形图，在开发过程中从iOS模拟器获取

全文包括两部分[]（https://medium.com/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb）对Flutter及其“widgets”和“tween”的介绍的第一部分概念。 我将通过使用它们来显示和动画图表来说明这些概念的强度，如上所示。 完整的代码示例应该提供Dart可实现的代码清晰度的印象。 我将包含足够的细节，您应该能够在自己的笔记本电脑（以及模拟器或设备）上进行操作，并体验Flutter开发周期的长度。

起点，[Flutter的安装]（https://flutter.io/setup）。在终端运行

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

以上复选框都满足了，您就可以创建一个Flutter应用程序。我们命名它为charts ：

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

您应该验证是否可以启动示例程序。 启动模拟器或插入设备，然后执行

```
$ flutter run
```
在`charts`目录中。 您应该在模拟器或设备上看到一个简单的计数应用程序。 它默认使用MD风格的widgets，但这是可选的。作为Flutter架构的最顶层，这些widgets是完全可替换的。

* * *

让我们首先用下面的代码替换`main.dart`的内容，开始我们的图表动画。

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

保存更改，然后重新启动应用程序。 您可以通过按“R”从终端执行此操作。 这种“完全重启”操作会重置应用程序状态，然后重建UI。 对于在代码更改后现有应用程序状态仍然有效的情况，可以按“r”执行“热加载”，这只会重建UI。 IntelliJ IDEA安装Flutter插件，提供与Dart编辑器集成的相同功能：

![](https://cdn-images-1.medium.com/max/800/1*soCdZ19Qugtv1YJewMQZGg.png)

Screen shot from IntelliJ IDEA with an older version of the Flutter plug-in, showing the reload and restart buttons in the top-right corner. These buttons are enabled, if the app has been started from within the IDE. Newer versions of the plugin do hot reload on save.

Once restarted, the app shows a centered text label saying `Data set: null` and a floating action button to refresh the data. Yes, humble beginnings.

To get a feel for the difference between hot reload and full restart, try the following: After you’ve pressed the floating action button a few times, make a note of the current data set number, then replace `Icons.refresh` with `Icons.add` in the code, save, and do a hot reload. Observe that the button changes, but that the application state is retained; we’re still at the same place in the random stream of numbers. Now undo the icon change, save, and do a full restart. The application state has been reset, and we’re back to `Data set: null`.

Our simple app shows two central aspects of the Flutter widget concept in action:

*   The user interface is defined by a tree of **immutable widgets** which is built via a foxtrot of constructor calls (where you get to configure widgets) and `build` methods (where widget implementations get to decide how their sub-trees look). The resulting tree structure for our app is shown below, with the main role of each widget in parentheses. As you can see, while the widget concept is quite broad, each concrete widget type typically has a very focused responsibility.

```
MaterialApp                    (navigation)
  ChartPage                    (state management)
    Scaffold                   (layout)
      Center                   (layout)
        Text                   (text)
      FloatingActionButton     (user interaction)
        Icon                   (graphics)
```

*   With an immutable tree of immutable widgets defining the user interface, the only way to change that interface is to rebuild the tree. Flutter takes care of that, when the next frame is due. All we have to do is tell Flutter that some state on which a subtree depends has changed. The root of such a **state-dependent subtree** must be a `StatefulWidget`. Like any decent widget, a `StatefulWidget` is not mutable, but its subtree is built by a `State` object which is. Flutter retains `State` objects across tree rebuilds and attaches each to their respective widget in the new tree during building. They then determine how that widget’s subtree is built. In our app, `ChartPage` is a `StatefulWidget` with `ChartPageState` as its `State`. Whenever the user presses the button, we execute some code to change `ChartPageState.` We’ve demarcated the change with `setState` so that Flutter can do its housekeeping and schedule the widget tree for rebuilding. When that happens, `ChartPageState` will build a slightly different subtree rooted at the new instance of `ChartPage`.

Immutable widgets and state-dependent subtrees are the main tools that Flutter puts at our disposal to address the complexities of state management in elaborate UIs responding to asynchronous events such as button presses, timer ticks, or incoming data. From my desktop experience I’d say this complexity is _very_ real. Assessing the strength of Flutter’s approach is — and should be — an exercise for the reader: try it out on something non-trivial.

* * *

Our charts app will stay simple in terms of widget structure, but we’ll do a bit of animated custom graphics. First step is to replace the textual representation of each data set with a very simple chart. Since a data set currently involves only a single number in the interval `0..100`, the chart will be a bar chart with a single bar, whose height is determined by that number. We’ll use an initial value of `50` to avoid a `null` height:

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

`CustomPaint` is a widget that delegates painting to a `CustomPainter` strategy. Our implementation of that strategy draws a single bar.

Next step is to add animation. Whenever the data set changes, we want the bar to change height smoothly rather than abruptly. Flutter has an `AnimationController` concept for orchestrating animations, and by registering a listener, we’re told when the animation value — a double running from zero to one — changes. Whenever that happens, we can call `setState` as before and update `ChartPageState`.

For reasons of exposition, our first go at this will be ugly:

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

Ouch. Complexity already rears its ugly head, and our data set is still just a single number! The code needed to set up animation control is a minor concern, as it doesn’t ramify when we get more chart data. The real problem is the variables `startHeight`, `currentHeight`, and `endHeight` which reflect the changes made to the data set and the animation value, and are updated in three different places.

We are in need of a concept to deal with this mess.

* * *

Enter **tweens**. While far from unique to Flutter, they are a delightfully simple concept for structuring animation code. Their main contribution is to replace the imperative approach above with a functional one. A tween is a _value_. It describes the path taken between two points in a space of other values, like bar charts, as the animation value runs from zero to one.

![](https://cdn-images-1.medium.com/max/800/1*3KpUQjhZLrvwvjF0daKg9g.jpeg)

Tweens are generic in the type of these other values, and can be expressed in Dart as objects of the type `Tween<T>`:

```
abstract class Tween<T> {
  final T begin;
  final T end;
  
  Tween(this.begin, this.end);
  
  T lerp(double t);
}
```

The jargon `lerp` comes from the field of computer graphics and is short for both _linear interpolation_ (as a noun) and _linearly interpolate_ (as a verb). The parameter `t` is the animation value, and a tween should thus lerp from `begin` (when `t` is zero) to `end` (when `t` is one).

The Flutter SDK’s `[Tween<T>](https://docs.flutter.io/flutter/animation/Tween-class.html)` class is very similar to the above, but is a concrete class that supports mutating `begin` and `end`. I’m not entirely sure why that choice was made, but there are probably good reasons for it in areas of the SDK’s animation support that I have yet to explore. In the following, I’ll use the Flutter `Tween<T>`, but pretend it is immutable.

We can clean up our code using a single `Tween<double>` for the bar height:

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

We’re using `Tween` for packaging the bar height animation end-points in a single value. It interfaces neatly with the `AnimationController` and `CustomPainter`, avoiding widget tree rebuilds during animation as the Flutter infrastructure now marks `CustomPaint` for repaint at each animation tick, rather than marking the whole `ChartPage` subtree for rebuild, relayout, and repaint. These are definite improvements. But there’s more to the tween concept; it offers _structure_ to organize our thoughts and code, and we haven’t really taken that seriously. The tween concept says,

_Animate_ `_T_`_s by tracing out a path in the space of all_ `_T_`_s as the animation value runs from zero to one. Model the path with a_ `_Tween<T>_`_._

In the code above, `T` is a `double`, but we do not want to animate `double`s, we want to animate bar charts! Well, OK, single bars for now, but the concept is strong, and it scales, if we let it.

(You may be wondering why we don’t take that argument a step further and insist on animating data sets rather than their representations as bar charts. That’s because data sets — in contrast to bar charts which are graphical objects — generally do not inhabit spaces where smooth paths exist. Data sets for bar charts typically involve numerical data mapped against discrete data categories. But without the spatial representation as bar charts, there is no reasonable notion of a smooth path between two data sets involving different categories.)

Returning to our code, we’ll need a `Bar` type and a `BarTween` to animate it. Let’s extract the bar-related classes into their own `bar.dart` file next to `main.dart`:

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

I’m following a Flutter SDK convention here in defining `BarTween.lerp` in terms of a static method on the `Bar` class. This works well for simple types like `Bar`, `Color`, `Rect` and many others, but we’ll need to reconsider the approach for more involved chart types. There is no `double.lerp` in the Dart SDK, so we’re using the function `lerpDouble` from the `dart:ui` package to the same effect.

Our app can now be re-expressed in terms of bars as shown in the code below; I’ve taken the opportunity to dispense of the `dataSet` field.

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

The new version is longer, and the extra code should carry its weight. It will, as we tackle increased chart complexity in [part two](https://medium.com/@mravn/zero-to-one-with-flutter-part-two-5aa2f06655cb). Our requirements speak of colored bars, multiple bars, partial data, stacked bars, grouped bars, stacked and grouped bars, … all of it animated. Stay tuned.

![](https://cdn-images-1.medium.com/max/800/1*n76TpChNv8Q25WrfBiuWpw.gif)

A preview of one of the animations we’ll do in part two.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
