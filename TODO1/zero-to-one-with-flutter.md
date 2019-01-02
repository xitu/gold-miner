> * 原文地址：[Zero to One with Flutter](https://medium.com/flutter-io/zero-to-one-with-flutter-43b13fd7b354)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md)
> * 译者：
> * 校对者：

# Zero to One with Flutter

_It was late summer 2016, and my first task as a new hire at the Google office in Aarhus, Denmark was to implement animated charts in an Android/iOS app using_ [_Flutter_](https://flutter.io) _and_ [_Dart_](https://www.dartlang.org)_. Besides being a “Noogler”, I was new to Flutter, new to Dart, and new to animations. In fact, I had never done a mobile app before. My very first smartphone was just a few months old — bought in a fit of panic that I might fail the phone interview by answering the call with my old Nokia..._

_I did have some prior experience with charts from desktop Java, but that wasn’t animated. I felt… weird. Partly a dinosaur, partly reborn._

![](https://cdn-images-1.medium.com/max/800/1*2t8GffL0BcNoGLU-IgHT9w.jpeg)

**TL;DR** Discovering the strength of Flutter’s widget and tween concepts by writing chart animations in Dart for an Android/iOS app.

Updated on August 7, 2018 to use Dart 2 syntax. [GitHub repo](https://github.com/mravn/charts) added on October 17, 2018. Each step described below is a separate commit.

* * *

Moving to a new development stack makes you aware of your priorities. Near the top of my list are these three:

*   **Strong concepts** deal effectively with complexity by providing simple, relevant ways of structuring thoughts, logic, or data.
*   **Clear code** lets us express those concepts cleanly, without being distracted by language pitfalls, excessive boilerplate, or auxiliary detail.
*   **Fast iteration** is key to experimentation and learning — and software development teams learn for a living: what the requirements really are, and how best to fulfill them with concepts expressed in code.

Flutter is a new platform for developing Android and iOS apps from a single codebase, written in Dart. Since our requirements spoke of a fairly complex UI including animated charts, the idea of building it only once seemed very attractive. My tasks involved exercising Flutter’s CLI tools, some pre-built widgets, and its 2D rendering engine — in addition to writing a lot of plain Dart code to model and animate charts. I’ll share below some conceptual highlights of my learning experience, and provide a starting point for your own evaluation of the Flutter/Dart stack.

![](https://cdn-images-1.medium.com/max/800/1*OKV3RzTg89W3VxXnpAH3Eg.gif)

A simple animated bar chart, captured from an iOS simulator during development

This is part one of a [two-part](https://medium.com/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb) introduction to Flutter and its ‘widget’ and ‘tween’ concepts. I’ll illustrate the strength of these concepts by using them to display and animate charts like the one shown above. Full code samples should provide an impression of the level of code clarity achievable with Dart. And I’ll include enough detail that you should be able to follow along on your own laptop (and emulator or device), and experience the length of the Flutter development cycle.

The starting point is a fresh [installation of Flutter](https://flutter.io/setup). Run

```
$ flutter doctor
```

to check the setup:

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

With enough check marks, you can create a Flutter app. Let’s call it `charts`:

```
$ flutter create charts
```

That should give you a directory of the same name:

```
charts
  android
  ios
  lib
    main.dart
```

About sixty files have been generated, making up a complete sample app that can be installed on both Android and iOS. We’ll do all our coding in `main.dart` and sibling files, with no pressing need to touch any of the other files or directories.

You should verify that you can launch the sample app. Start an emulator or plug in a device, then execute

```
$ flutter run
```

in the `charts` directory. You should then see a simple counting app on your emulator or device. It uses Material Design widgets, which is nice, but optional. As the top-most layer of the Flutter architecture, those widgets are completely replaceable.

* * *

Let’s start by replacing the contents of `main.dart` with the code below, a simple starting point for playing with chart animations.

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

Save the changes, then restart the app. You can do that from the terminal, by pressing `R`. This ‘full restart’ operation throws away the application state, then rebuilds the UI. For situations where the existing application state still makes sense after the code change, one can press `r` to do a ‘hot reload’, which only rebuilds the UI. There is also a Flutter plugin for IntelliJ IDEA providing the same functionality integrated with a Dart editor:

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
