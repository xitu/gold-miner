> * 原文地址：[Zero to One with Flutter, Part Two](https://medium.com/flutter-io/zero-to-one-with-flutter-part-two-5aa2f06655cb)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter-part-two.md)
> * 译者：
> * 校对者：

# Flutter 从 0 到 1, 第二部分

> [Flutter 从 0 到 1（第一部分）](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md)

了解如何在跨平台移动应用程序的上下文中为复合图形对象设置动画。引入一个新的概念，如何将 tween 应用于结构化值动画中，例如条形图。 实例代码如下。

编辑: 2018年8月8日适配 Dart 2。[GitHub repo](https://github.com/mravn/charts) 并且差异链接于2018年10月17日添加。

![](https://cdn-images-1.medium.com/max/800/1*OSc2sFHg8KH4ZQR2ymytKg.png)

* * *

如何进入一个新的编程领域？实践是关键，同时学习和模仿更有经验同行的代码也至关重要。我个人喜欢用挖掘概念的方式来处理：试着从最基本的原则出发，识别各种概念，探索它们的优势，有意识地寻求它们的指导。这是一种理性主义的方法，它不能独立存在，而是一种智力刺激的方法，可以更快地引导您获得更深入的见解。

这是 Flutter 及其 widget 和 tween 概念介绍的第二部分也是最后一部分。在 [part one](https://medium.com/dartlang/zero-to-one-with-flutter-43b13fd7b354) 最后, 我们[得到](https://github.com/mravn/charts/tree/992e11e9cdec5a9fb626d6e4c7b62c0d6c558a9d) 一个 widget 树, 其包含布局和状态处理 widgets,

*   一个 widget，使用自定义动画绘制代码, 绘制单一 _Bar_ 。
*   一个浮动按钮 widget，控制 _Bar_ 高度动画显示。

![](https://cdn-images-1.medium.com/max/800/1*5ggIsPDAwb8sAgPw8vZkyw.gif)

高度动画 _Bar_ 。

使用 `BarTween` 实现动画，tween 可以扩展处理更复杂的情况。 在第二部分中，我将通过将设计概括为具有更多属性的条形以及包含各种配置中的多个条形的条形图来实现该声明。

* * *

首先我们为单个条形图添加颜色。在 `Bar` 类的 `height` 字段旁边添加一个 `color` 字段，并更新 `Bar.lerp` 对它们进行 lerp。 这种模式很典型:

_Lerp between composite values by lerping corresponding components._

回想一下第一部分，“lerp” 是“线性插值”的缩写。

```
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Bar {
  Bar(this.height, this.color);

  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}
```

注意静态 `lerp` 方法，习惯用法产生的效果。 如果没有 `Bar.lerp`，`lerpDouble`（`double.lerp`）和 `Color.lerp`，我们必须实现 `BarTween` 来创建一个 `Tween <double>` 属性表示高度，和 `Tween <Color>` 属性表示颜色。 那些 tweens 将是 `BarTween` 的实例字段，由构造函数初始化，并在其 `lerp` 方法中使用。 我们将在 “Bar” 类之外多次重复 “Bar” 的属性。 代码维护者可能会发现这并不是一个好主意。

![](https://cdn-images-1.medium.com/max/800/1*kCvpZWFivphnjDnOiIoaIw.gif)

条形图动画显示高度和颜色.

为了在应用程序中使用彩色条，我们将更新 `BarChartPainter` 从 `Bar` 获得条形颜色。 在 `main.dart` 中，我们需要创建一个空的 `Bar` 和一个随机的 `Bar`。 我们将为前者使用完全透明的颜色，为后者使用随机颜色。 颜色将从一个简单的 `ColorPalette` 中获取，我们会在它自己的文件中快速引入。 我们将在 `Bar` 中创建 `Bar.empty` 和 `Bar.random` 工厂构造函数 ([code listing](https://gist.github.com/mravn-google/90bda9c82df356338b3fe3f733066f6c), [diff](https://github.com/mravn/charts/commit/91c800e7e69f2208afb20535aeeacce5a83b8f01)).

* * *

条形图涉及各种配置的多种形式。 为了缓慢地引入复杂性，我们的第一个实现将适用于显示固定类别的条形图。 示例包括每个工作日的访问者或每季度的销售额。 对于此类图表，将数据集更改为另一周或另一年不会更改使用的类别，只会更改每个类别显示的栏。

我们首先更新 `main.dart`，用 `BarChart` 替换 `Bar`，用 `BarChartTween` 替换 `BarTween` ([code listing](https://gist.github.com/mravn-google/029930ddb613b00b6f5df7179d76fdc4), [diff](https://github.com/mravn/charts/commit/17cb4074be0f8267121ae36d865d9a13393e9e39#diff-fe53fad46868a294b309fc85ed138997)).

为了更好体现 Dart 语言优势，我们在 `bar.dart` 中创建 `BarChart` 类，并使用固定长度的 `Bar` 实例列表来实现它。 我们将使用五个条形图，表示一周中的工作日。 然后，我们需要将创建空条和随机条的函数从 `Bar` 转移到 `BarChart`。 对于固定类别，空条形图合理地被视为空条的集合。 另一方面，让随机条形图成为随机条形图的集合会使我们的图表变得万花筒般。 相反，我们将为图表选择一种随机颜色，让每个仍然具有随机高度的条形继承该图形。

```
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'color_palette.dart';

class BarChart {
  static const int barCount = 5;

  BarChart(this.bars) {
    assert(bars.length == barCount);
  }

  factory BarChart.empty() {
    return BarChart(List.filled(
      barCount,
      Bar(0.0, Colors.transparent),
    ));
  }

  factory BarChart.random(Random random) {
    final Color color = ColorPalette.primary.random(random);
    return BarChart(List.generate(
      barCount,
      (i) => Bar(random.nextDouble() * 100.0, color),
    ));
  }

  final List<Bar> bars;

  static BarChart lerp(BarChart begin, BarChart end, double t) {
    return BarChart(List.generate(
      barCount,
      (i) => Bar.lerp(begin.bars[i], end.bars[i], t),
    ));
  }
}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);
}

class Bar {
  Bar(this.height, this.color);

  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  static const barWidthFraction = 0.75;

  BarChartPainter(Animation<BarChart> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<BarChart> animation;

  @override
  void paint(Canvas canvas, Size size) {
    void drawBar(Bar bar, double x, double width, Paint paint) {
      paint.color = bar.color;
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - bar.height, width, bar.height),
        paint,
      );
    }

    final paint = Paint()..style = PaintingStyle.fill;
    final chart = animation.value;
    final barDistance = size.width / (1 + chart.bars.length);
    final barWidth = barDistance * barWidthFraction;
    var x = barDistance - barWidth / 2;
    for (final bar in chart.bars) {
      drawBar(bar, x, barWidth, paint);
      x += barDistance;
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}
```

`BarChartPainter` 在条形图中均匀分布可用宽度，使每个条形占据可用宽度的75％。

![](https://cdn-images-1.medium.com/max/800/1*aiUQNf70oukpvNf6sVw3GA.gif)

固定类别条形图。

注意 `BarChart.lerp` 是如何用 `Bar.lerp` 实现的，即时重新生成列表结构。 固定类别条形图是复合值，对于这些复合值，直接使用 `lerp` 进行有意义的组合，正如具有多个属性的单个条形图一样 ([diff](https://github.com/mravn/charts/commit/17cb4074be0f8267121ae36d865d9a13393e9e39))。

* * *

There is a pattern at play here. When a Dart class’s constructor takes multiple parameters, you can often lerp each parameter separately and the combination will look good, too. And you can nest this pattern arbitrarily: dashboards would be lerped by lerping their constituent bar charts, which are lerped by lerping their bars, which are lerped by lerping their height and color. And colors are lerped by lerping their RGB and alpha components. At the leaves of this recursion, we lerp numbers.

在数学上倾向于用`_C_(_x_, _y_)`来表达复合的线性插值结构，而编程实践中我们用
`_lerp_(_C_(_x_1, _y_1), _C_(_x_2, _y_2), _t_) == _C_(_lerp_(_x_1, _x_2, _t_), _lerp_(_y_1, _y_2, _t_))`

正如我们所看到的，这很好地概括了两个组件（条形图的高度和颜色）到任意多个组件（固定类别 _n_ 条条形图）。
 
然而，有一些情况会让这张漂亮的照片损坏。 我们希望在两个不以完全相同的方式组成的值之间进行动画处理。 举个简单的例子，考虑动画图表处理从包含工作日，到包括周末的情况。

您可能很容易想出这个问题的几种不同的临时解决方案，然后可能会要求您的UX设计师在它们之间进行选择。 这是一种有效的方法，但我认为在讨论过程中要记住这些不同解决方案共有的基本结构：`tween`。 回忆第一部分：

动画值从0到1运动时，通过遍历空间路径中所有 _T_ 的路径进行动画。用 _Tween <T> _ 对路径建模。

用户体验设计师要回答的核心问题是：图表有五个条形图和一个有七个条形图的中间值是多少？ 显而易见的选择是六个条形图，但我们需要比平滑动画更多的中间值。 我们需要以不同方式绘制条形图，放弃等宽，均匀间隔，适合的200像素设置。 换句话说，`T` 的值必须是通用的。

_Lerp between values with different structure by embedding them into a space of more general values, encompassing as special cases both animation end points and all intermediate values needed._

我们可以分两步完成。 首先，`Bar` 包含 _x_ 坐标属性和宽度属性：

```
class Bar {
  Bar(this.x, this.width, this.height, this.color);

  final double x;
  final double width;
  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(
      lerpDouble(begin.x, end.x, t),
      lerpDouble(begin.width, end.width, t),
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}
```

其次，我们使 `BarChart` 支持具有不同条形数的图表。我们的新图表将适用于数据集，其中条形图 _i_ 代表某些系列中的_i_th值，例如产品发布后的第_i_天的销售额。[Counting as programmers](https://www.cs.utexas.edu/users/EWD/transcriptions/EWD08xx/EWD831.html), any such chart involves a bar for each integer value 0.._n_, but the bar count _n_ may be different from one chart to the next.

Consider two charts with five and seven bars, respectively. The bars for their five common categories, 0..5, can be animated compositionally as we’ve seen above. The bars with index 5 and 6 have no counterpart in the other animation end point, but as we are now free to give each bar its own position and width, we can introduce two invisible bars to play that role. The visual effect is that bars 5 and 6 grow into their final appearance as the animation proceeds. Animating in the other direction, bars 5 and 6 would diminish or fade into invisibility.

_Lerp between composite values by lerping corresponding components. Where a component is missing in one end point, use an invisible component in its place._

There are often several ways to choose invisible components. Let’s say our friendly UX designer has decided to use zero-width, zero-height bars with _x_ coordinate and color inherited from their visible counterpart. We’ll add a method to `Bar` for creating such a collapsed version of a given instance.

```
class BarChart {
  BarChart(this.bars);

  final List<Bar> bars;

  static BarChart lerp(BarChart begin, BarChart end, double t) {
    final barCount = max(begin.bars.length, end.bars.length);
    final bars = List.generate(
      barCount,
      (i) => Bar.lerp(
            begin._barOrNull(i) ?? end.bars[i].collapsed,
            end._barOrNull(i) ?? begin.bars[i].collapsed,
            t,
          ),
    );
    return BarChart(bars);
  }

  Bar _barOrNull(int index) => (index < bars.length ? bars[index] : null);
}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);
}

class Bar {
  Bar(this.x, this.width, this.height, this.color);

  final double x;
  final double width;
  final double height;
  final Color color;

  Bar get collapsed => Bar(x, 0.0, 0.0, color);
  
  static Bar lerp(Bar begin, Bar end, double t) {
    return Bar(
      lerpDouble(begin.x, end.x, t),
      lerpDouble(begin.width, end.width, t),
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}
```

Integrating the above code into our app involves redefining `BarChart.empty` and `BarChart.random` for this new setting. An empty bar chart can now reasonable be taken to contain zero bars, while a random one might contain a random number of bars all of the same randomly chosen color, and each having a randomly chosen height. But since position and width are now part of the definition of `Bar`, we need `BarChart.random` to specify those attributes too. It seems reasonable to provide `BarChart.random` with the chart `Size` parameter, and then relieve `BarChartPainter.paint` of most of its calculations ([code listing](https://gist.github.com/mravn-google/cac095296074b8b1b7ad6c91a21a5f1a), [diff](https://github.com/mravn/charts/commit/50585bd40160c336e80f3ec867bad01d08d8e0ec)).

![](https://cdn-images-1.medium.com/max/800/1*dN9og1kRYpRsL-cFIgO23w.gif)

Lerping to/from invisible bars.

* * *

The astute reader may have noticed a potential inefficiency in our definition of `BarChart.lerp` above. We are creating collapsed `Bar` instances only to be given as arguments to `Bar.lerp`, and that happens repeatedly, for every value of the animation parameter `t`. At 60 frames per second, that could mean a lot of `Bar` instances being fed to the garbage collector, even for a relatively short animation. There are alternatives:

*   Collapsed `Bar` instances can be reused by being created only once in the `Bar` class rather than on each call to `collapsed`. This approach works here, but is not generally applicable.

*   The reuse can be handled by `BarChartTween` instead, by having its constructor create a list `_tween` of `BarTween` instances used during the creation of the lerped bar chart: `(i) => _tweens[i].lerp(t)`. This approach breaks with the convention of using static `lerp` methods throughout. There is no object involved in the static `BarChart.lerp` in which to store the tween list for the duration of the animation. The `BarChartTween` object, by contrast, is perfectly suited for this.

*   A `null` bar can be used to represent a collapsed bar, assuming suitable conditional logic in `Bar.lerp`. This approach is slick and efficient, but does require some care to avoid dereferencing or misinterpreting `null`. It is commonly used in the Flutter SDK where static `lerp` methods tend to accept `null` as an animation end point, typically interpreting it as some sort of invisible element, like a completely transparent color or a zero-size graphical element. As the most basic example, `lerpDouble` treats `null` as zero, unless both animation end-points are `null`.

The snippet below shows the code we would write following the `null` approach:

```
class BarChart {
  BarChart(this.bars);

  final List<Bar> bars;

  static BarChart lerp(BarChart begin, BarChart end, double t) {
    final barCount = max(begin.bars.length, end.bars.length);
    final bars = List.generate(
      barCount,
      (i) => Bar.lerp(begin._barOrNull(i), end._barOrNull(i), t),
    );
    return BarChart(bars);
  }

  Bar _barOrNull(int index) => (index < bars.length ? bars[index] : null);
}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);
}

class Bar {
  Bar(this.x, this.width, this.height, this.color);

  final double x;
  final double width;
  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    if (begin == null && end == null)
      return null;
    return Bar(
      lerpDouble((begin ?? end).x, (end ?? begin).x, t),
      lerpDouble(begin?.width, end?.width, t),
      lerpDouble(begin?.height, end?.height, t),
      Color.lerp((begin ?? end).color, (end ?? begin).color, t),
    );
  }
}
```

I think it’s fair to say that Dart’s `?` syntax is well suited to the task. But notice how the decision to use collapsed (rather than, say, transparent) bars as invisible elements is now buried in the conditional logic in `Bar.lerp`. That is the main reason I chose the seemingly less efficient solution earlier. As always in questions of performance vs maintainability, your choice should be based on measurements.

* * *

We have one more step to take before we can tackle bar chart animation in full generality. Consider an app using a bar chart to show sales by product category for a given year. The user can select another year, and the app should then animate to the bar chart for that year. If the product categories were the same for the two years, or happened to be the same except for some additional categories shown to the right in one of the charts, we could use our existing code above. But what if the company had product categories A, B, C, and X in 2016, but had discontinued B and introduced D in 2017? Our existing code would animate as follows:

```
2016  2017
  A -> A
  B -> C
  C -> D
  X -> X
```

The animation might be beautiful and silky-smooth, but it would still be confusing to the user. Why? Because it doesn’t preserve semantics. It transforms a graphical element representing product category B into one representing category C, while the one for C goes elsewhere. Just because 2016 B happens to be drawn in the same position where 2017 C later appears doesn’t imply that the former should morph into the latter. Instead, 2016 B should disappear, 2016 C should move left and morph into 2017 C, and 2017 D should appear on its right. We can implement this mingling using one of the oldest algorithms in the book: merging sorted lists.

_Lerp between composite values by lerping semantically corresponding components. When components form sorted lists, the merge algorithm can bring such components on a par, using invisible components as needed to deal with one-sided merges._

All we need is to make `Bar` instances mutually comparable in a linear order. Then we can merge them as follows:

```
  static BarChart lerp(BarChart begin, BarChart end, double t) {
    final bars = <Bar>[];
    final bMax = begin.bars.length;
    final eMax = end.bars.length;
    var b = 0;
    var e = 0;
    while (b + e < bMax + eMax) {
      if (b < bMax && (e == eMax || begin.bars[b] < end.bars[e])) {
        bars.add(Bar.lerp(begin.bars[b], begin.bars[b].collapsed, t));
        b++;
      } else if (e < eMax && (b == bMax || end.bars[e] < begin.bars[b])) {
        bars.add(Bar.lerp(end.bars[e].collapsed, end.bars[e], t));
        e++;
      } else {
        bars.add(Bar.lerp(begin.bars[b], end.bars[e], t));
        b++;
        e++;
      }
    }
    return BarChart(bars);
  }
```

Concretely, we’ll assign each bar a sort key in the form of an integer `rank` attribute. The rank can then be conveniently used also to assign each bar a color from the palette, allowing us to follow the movement of individual bars in the animation demo.

A random bar chart will now be based on a random selection of ranks to include ([code listing](https://gist.github.com/mravn-google/4f7194e8c1f875eba189856eb40e6b1e), [diff](https://github.com/mravn/charts/commit/5a41b26279fb5ba334c219bf4f6d74cd33daf01b)).

![](https://cdn-images-1.medium.com/max/800/1*MuSAOLktwY8bTJdPGuoNqA.gif)

Arbitrary categories. Merge-based lerping.

This works nicely, but is perhaps not the most efficient solution. We are repeatedly executing the merge algorithm in `BarChart.lerp`, once for every value of `t`. To fix that, we’ll implement the idea mentioned earlier to store reusable information in `BarChartTween`.

```
class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end) {
    final bMax = begin.bars.length;
    final eMax = end.bars.length;
    var b = 0;
    var e = 0;
    while (b + e < bMax + eMax) {
      if (b < bMax && (e == eMax || begin.bars[b] < end.bars[e])) {
        _tweens.add(BarTween(begin.bars[b], begin.bars[b].collapsed));
        b++;
      } else if (e < eMax && (b == bMax || end.bars[e] < begin.bars[b])) {
        _tweens.add(BarTween(end.bars[e].collapsed, end.bars[e]));
        e++;
      } else {
        _tweens.add(BarTween(begin.bars[b], end.bars[e]));
        b++;
        e++;
      }
    }
  }

  final _tweens = <BarTween>[];

  @override
  BarChart lerp(double t) => BarChart(
        List.generate(
          _tweens.length,
          (i) => _tweens[i].lerp(t),
        ),
      );
}
```

We can now remove the static `BarChart.lerp` method ([diff](https://github.com/mravn/charts/commit/bb3b46f9384b8b90d50be1db59ce44ed83c61b2c)).

* * *

Let’s summarize what we’ve learned about the tween concept so far:

_Animate_ `_T_`_s by tracing out a path in the space of all_ `_T_`_s as the animation value runs from zero to one. Model the path with a_ `_Tween<T>_`_._

_Generalize the_ `_T_` _concept as needed until it encompasses all animation end points and intermediate values._

_Lerp between composite values by lerping corresponding components._

*   _The correspondence should be based on semantics, not on accidental graphical co-location._
*   _Where a component is missing in one animation end point, use an invisible component in its place, possibly derived from the other end point._
*   _Where components form sorted lists, use the merge algorithm to bring semantically corresponding components on a par, introducing invisible components as needed to deal with one-sided merges._

_Consider implementing tweens using static_ `_Xxx.lerp_` _methods to facilitate reuse in composite tween implementations. Where significant recomputation happens across calls to_ `_Xxx.lerp_` _for a single animation path, consider moving the computation to the constructor of the_ `_XxxTween_` _class, and let its instances host the computation outcome._

* * *

Armed with these insights, we are finally in position to animate more complex charts. We’ll do stacked bars, grouped bars, and stacked+grouped bars in quick succession:

*   Stacked bars are used for data sets where categories are two-dimensional and it makes sense to add up the numerical quantity represented by bar heights. An example might be revenue per product and geographical region. Stacking by product makes it easy to compare product performance in the global market. Stacking by region shows which regions are important.

![](https://cdn-images-1.medium.com/max/800/1*qKUFM56S-ZonH1amVDDXTw.gif)

Stacked bars.

*   Grouped bars are also used for data sets with two-dimensional categories, but where it is not meaningful or desirable to stack the bars. For instance, if the numeric quantity is market share in percent per product and region, stacking by product makes no sense. Even where stacking does makes sense, grouping can be preferable as it makes it easier to do quantitative comparisons across both category dimensions at the same time.

![](https://cdn-images-1.medium.com/max/800/1*YiojxPiaWY7lB5v9iZVgDg.gif)

Grouped bars.

*   Stacked+grouped bars support three-dimensional categories, like revenue per product, geographical region, and sales channel.

![](https://cdn-images-1.medium.com/max/800/1*9ObVOKbos4DoQsmsqbMnRQ.gif)

Stacked+grouped bars.

In all three variants, animation can be used to visualize data set changes, thus introducing an additional dimension (typically time) without cluttering the charts.

For the animation to be useful and not just pretty, we need to make sure that we lerp only between semantically corresponding components. So the bar segment used to represent the revenue for a particular product/region/channel in 2016 should be morphed into one representing revenue for the same product/region/channel in 2017 (if present).

The merge algorithm can be used to ensure this. As you may have guessed from the preceding discussion, merge will be put to work at multiple levels, reflecting the dimensionality of the categories. We’ll merge stacks and bars in stacked charts, groups and bars in grouped charts, and all three in stacked+grouped charts.

To accomplish that without a lot of code duplication, we’ll abstract the merge algorithm into a general utility, and put it in a file of its own, `tween.dart`:

```
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

abstract class MergeTweenable<T> {
  T get empty;

  Tween<T> tweenTo(T other);

  bool operator <(T other);
}

class MergeTween<T extends MergeTweenable<T>> extends Tween<List<T>> {
  MergeTween(List<T> begin, List<T> end) : super(begin: begin, end: end) {
    final bMax = begin.length;
    final eMax = end.length;
    var b = 0;
    var e = 0;
    while (b + e < bMax + eMax) {
      if (b < bMax && (e == eMax || begin[b] < end[e])) {
        _tweens.add(begin[b].tweenTo(begin[b].empty));
        b++;
      } else if (e < eMax && (b == bMax || end[e] < begin[b])) {
        _tweens.add(end[e].empty.tweenTo(end[e]));
        e++;
      } else {
        _tweens.add(begin[b].tweenTo(end[e]));
        b++;
        e++;
      }
    }
  }

  final _tweens = <Tween<T>>[];

  @override
  List<T> lerp(double t) => List.generate(
        _tweens.length,
        (i) => _tweens[i].lerp(t),
      );
}
```

`MergeTweenable <T>` 接口精确获得合并两个有序的 `T` 列表的所需的 `tween` 内容。 我们将使用 `Bar`，`BarStack` 和 `BarGroup` 实例化泛型参数 `T`，并且实现 `MergeTweenable <T>` ([diff](https://github.com/mravn/charts/commit/e7ec4c94bf560e483a267e60ee2b11c68932d4e0)).

[stacked](https://gist.github.com/mravn-google/78326296c59f0544d280a987d9ba39e2) ([diff](https://github.com/mravn/charts/commit/912b5eafd5296a549c6fbb6090bbcd3cb4bb4342)), [grouped](https://gist.github.com/mravn-google/d3f0f2a93cb478ab3a50dab03437a5d5) ([diff](https://github.com/mravn/charts/commit/b0b3af8115f3632971b33a4b74204dd8943db53e)), 和 [stacked+grouped](https://gist.github.com/mravn-google/cbd4a89e7b9e5431898a16727f7642b6) ([diff](https://github.com/mravn/charts/commit/44b0e5d07633edcf7770f5719ec1d1aa082a853c)) 已经完成实现. 我建议您自己实践一下:

*   更改 `BarChart.random`创建的 groups, stacks, 和 bars 的数量。
*   更改调色板。 对于 `stacked+grouped`	，我使用了单色调色板，因为我觉得它看起来更好。 您和您的UX设计师可能并不认同。
*   将 `BarChart.random` 和浮动操作按钮替换为年份选择器，并以实际数据集创建 `BarChart` 实例。
*   实现水平条形图。
*   实现其他图表类型（饼图，线条，堆积区域）。 使用 `MergeTweenable <T>` 或类似方法为它们设置动画。
*   添加图表图例，标签，坐标轴，然后为它们设置动画。

最后两个任务非常具有挑战性。不妨试试。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
