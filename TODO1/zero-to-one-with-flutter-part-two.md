> * 原文地址：[Zero to One with Flutter, Part Two](https://medium.com/flutter-io/zero-to-one-with-flutter-part-two-5aa2f06655cb)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter-part-two.md)
> * 译者：
> * 校对者：

# Flutter 从 0 到 1, 第二部分

> [Flutter 从 0 到 1（第一部分）](https://github.com/xitu/gold-miner/blob/master/TODO1/zero-to-one-with-flutter.md)

探索如何在跨平台移动应用程序的上下文中为复合图形对象设置动画。引入一个新的概念，如何将 tween 动画应用于结构化值中，例如条形图表。全部代码，按步骤实现。

校订: 2018年8月8日适配 Dart 2。[GitHub repo](https://github.com/mravn/charts) 并且差异链接于2018年10月17日添加。

![](https://cdn-images-1.medium.com/max/800/1*OSc2sFHg8KH4ZQR2ymytKg.png)

* * *

如何进入一个新的编程领域 ？实践是至关重要的，同时学习和模仿更有经验同行的代码也是关键。我个人喜欢挖掘概念：试着从最基本的原则出发，识别各种概念，探索它们的优势，有意识地寻求它们的本质。这是一种理性主义的方法，它不能独立存在，而是一种智力刺激的方法，可以更快地引导您获得更深入的见解。

这是 Flutter 及其 widget 和 tween 概念介绍的第二部分也是最后一部分。在 [Flutter 从 0 到 1 第一部分](https://medium.com/dartlang/zero-to-one-with-flutter-43b13fd7b354) 最后, 我们[得到](https://github.com/mravn/charts/tree/992e11e9cdec5a9fb626d6e4c7b62c0d6c558a9d) 一个 widget 树, 其包含布局和状态处理 widgets,

*   一个 widget，使用自定义动画绘制代码, 绘制单一 _Bar_ 。
*   一个浮动按钮 widget，控制 _Bar_ 高度动画显示。

![](https://cdn-images-1.medium.com/max/800/1*5ggIsPDAwb8sAgPw8vZkyw.gif)

高度动画 _Bar_ 。

使用 `BarTween` 实现动画，我保证 tween 可以扩展处理更复杂的情况。 在第二部分中，我将设计条形图包含更多属性，对应不同设置包含多个条形图。

* * *

首先我们为单个条形图添加颜色属性。在 `Bar` 类的 `height` 字段旁边添加一个 `color` 字段，并更新 `Bar.lerp` 对它们进行线性插值。这种模式很典型:

_通过线性插值对应的元件，生成 tween 的合成值。_

回想一下第一部分，`lerp` 是 `线性插值` 的缩写。

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

注意静态方法 `lerp` 产生的效果。 如果没有 `Bar.lerp`，`lerpDouble`（ `double.lerp` ）和 `Color.lerp`，我们必须实现 `BarTween` 来创建一个 `Tween <double>` 属性表示高度，和 `Tween <Color>` 属性表示颜色。 这些 tweens 将是 `BarTween` 的实例字段，由构造函数初始化，并在其 `lerp` 方法中使用。 我们将在 `Bar` 类之外多次重复访问 `Bar` 的属性。 代码维护者可能会发现这并不是一个好主意。

![](https://cdn-images-1.medium.com/max/800/1*kCvpZWFivphnjDnOiIoaIw.gif)

条形图动画显示高度和颜色.

为了在应用程序中使用彩色条，我们将更新 `BarChartPainter` 从 `Bar` 获得条形图颜色。 在 `main.dart` 中，我们需要创建一个空的 `Bar` 和一个随机的 `Bar`。 我们将为前者使用完全透明的颜色，为后者使用随机颜色。 颜色将从一个简单的 `ColorPalette` 类中获取，我们会在它自己的文件中快速实现它。 我们将在 `Bar` 类中创建 `Bar.empty` 和 `Bar.random` 两个工厂构造函数 ([code listing](https://gist.github.com/mravn-google/90bda9c82df356338b3fe3f733066f6c), [diff](https://github.com/mravn/charts/commit/91c800e7e69f2208afb20535aeeacce5a83b8f01)).

* * *

条形图涉及各种配置的多种形式。 为了缓慢地引入复杂性，我们的第一个实现将适用于显示固定类别的条形图。 示例包括每个工作日的访问者或每季度的销售额。 对于此类图表，将数据集更改为另一周或另一年不会更改使用的类别，只会更改每个类别显示的栏。

我们首先更新 `main.dart`，用 `BarChart` 替换 `Bar`，用 `BarChartTween` 替换 `BarTween` ([代码列表](https://gist.github.com/mravn-google/029930ddb613b00b6f5df7179d76fdc4), [差分](https://github.com/mravn/charts/commit/17cb4074be0f8267121ae36d865d9a13393e9e39#diff-fe53fad46868a294b309fc85ed138997)).

为了更好体现 Dart 语言优势，我们在 `bar.dart` 中创建 `BarChart` 类，并使用固定数目的 `Bar` 实例列表来实现它。 我们将使用五个条形图，表示一周中的工作日。 然后，我们需要将创建空条和随机条的函数从 `Bar` 类中转移到 `BarChart` 类中。 对于固定类别，空条形图合理地被视为空条的集合。 另一方面，让随机条形图成为随机条形图的集合会使我们的图表变得多种多样。 相反，我们将为图表选择一种随机颜色，让每个仍然具有随机高度的条形继承该图形。

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

`BarChartPainter` 在条形图中宽度均匀分布，使每个条形占据可用宽度的75％。

![](https://cdn-images-1.medium.com/max/800/1*aiUQNf70oukpvNf6sVw3GA.gif)

固定类别条形图。

注意 `BarChart.lerp` 是如何调用 `Bar.lerp` 实现的，使用 `List.generate` 生产列表结构。 固定类别条形图是复合值，对于这些复合值，直接使用 `lerp` 进行有意义的组合，正如具有多个属性的单个条形图一样 ([diff](https://github.com/mravn/charts/commit/17cb4074be0f8267121ae36d865d9a13393e9e39))。

* * *

这里有一种模式。 当Dart类的构造函数采用多个参数时，您通常可以线性插值单个参数或多个。 你可以任意地嵌套这种模式：仪表板将会线性插值条形图表，线性插值条形图，线性插值条形图高度和颜色。 颜色RGB 和 alpha 通过线性插值来组合。 整个过程，就是递归叶节点上的值，进行线性插值。

在数学上倾向于用 `_C_(_x_, _y_)` 来表达复合的线性插值结构，而编程实践中我们用 `_lerp_(_C_(_x_1, _y_1), _C_(_x_2, _y_2), _t_) == _C_(_lerp_(_x_1, _x_2, _t_), _lerp_(_y_1, _y_2, _t_))`

正如我们所看到的，这很好地概括了两个元件（条形图的高度和颜色）到任意多个元件（固定类别 _n_ 条条形图）。
 
然而，有一些情况会让这张漂亮的照片损坏。 我们希望在两个不以完全相同的方式组成的值之间进行动画处理。 举个简单的例子，考虑动画图表处理从包含工作日，到包括周末的情况。

您可能很容易想出这个问题的几种不同的临时解决方案，然后可能会要求您的UX设计师在它们之间进行选择。 这是一种有效的方法，但我认为在讨论过程中要记住这些不同解决方案共有的基本结构：`tween`。 回忆第一部分：

_动画值从0到1运动时，通过遍历空间路径中所有 `_T_` 的路径进行动画。用 `Tween_ _<T>_` 对路径建模。_

用户体验设计师要回答的核心问题是：图表有五个条形图和一个有七个条形图的中间值是多少？ 显而易见的选择是六个条形图，但我们需要比平滑动画更多的中间值。 我们需要以不同方式绘制条形图，放弃等宽，均匀间隔，适合的200像素设置。 换句话说，`T` 的值必须是通用的。

_通过将值嵌入到通用数据中，在具有不同结构的值之间进行线性插值，包括动画端点和所有中间值所需的特殊情况。_

我们可以分两步完成。 第一步，在 `Bar` 类中包含 _x_ 坐标属性和宽度属性：

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

第二步，我们使 `BarChart` 支持具有不同条形数的图表。我们的新图表将适用于数据集，其中条形图 _i_ 代表某些系列中的第 _i_ 个值，例如产品发布后的第 _i_ 天的销售额。[Counting as programmers](https://www.cs.utexas.edu/users/EWD/transcriptions/EWD08xx/EWD831.html), 任何这样的图表都涉及每个整数值 0 .. _n_ 的条形图，但条形图数 _n_ 可能在各个图表中表示的意义不同。

考虑两个图表分别有五个和七个条形图。 五个常见类别的条形图 0..5 像上面我们看到的那样进行动画。 索引为5和6的条形在另一个动画终点没有对应条，但由于我们现在可以自由地给每个条形图设置位置和宽度，我们可以引入两个不可见的条形来扮演这个角色。视觉效果是当动画进行时，第5和第6条会减弱或淡化为隐形的。

_通过线性插值对应的元件，生成 tween 的合成值。如果某个端点缺少元件，在其位置使用不可见元件。_

通常有几种方法可以选择隐形元件。假设我们友好的用户体验设计师决定使用零宽度，零高度的条形图，其中 _x_ 坐标和颜色从它们的可见元件继承而来。 我们将为 `Bar` 类添加一个方法，用于处理这样的实例。

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

将上述代码集成到我们的应用程序中，涉及重新定义 `BarChart.empty` 和 `BarChart.random` 。现在可以合理地将空条形图设置包含零条，而随机条形图可以包含随机数量的条，所有条都具有相同的随机选择颜色，并且每个条具有随机选择的高度。 但由于位置和宽度现在是 `Bar`类定义的，我们需要 `BarChart.random` 来指定这些属性。 用图表 `Size` 作为`BarChart.random` 的参数似乎是合理的，这样可以解除 `BarChartPainter.paint` 大部分计算 ([代码列表](https://gist.github.com/mravn-google/cac095296074b8b1b7ad6c91a21a5f1a), [差分](https://github.com/mravn/charts/commit/50585bd40160c336e80f3ec867bad01d08d8e0ec)).

![](https://cdn-images-1.medium.com/max/800/1*dN9og1kRYpRsL-cFIgO23w.gif)

隐藏条形图线性插值.

* * *

大多数读者可能已经注意 `BarChart.lerp` 有潜在的效率问题。 我们创建 `Bar` 实例只是作为参数提供给 `Bar.lerp` 函数，并且对于每个动画参数的 `t` 值都是重复调用。 每秒60帧，即使是相对较短的动画，也意味着很多 `Bar` 实例被送到垃圾收集器。 我们还有其他选择：

*   `Bar` 实例可以通过在 `Bar` 类中创建一次而不是每次调用 `collapsed` 来重新生成。 这种方法适用于此，但并不通用。

*   可以用 `BarChartTween` 来处理重用问题，方法是让 `BarChartTween` 的构造函数创建条形图列表时使用的 `BarTween` 实例的列表 `_tween`：`（i）=> _tweens [i] .lerp（t ）`。这种方法打破了整个使用静态`lerp`方法的惯例。静态` BarChart.lerp` 不会在动画持续时间内存储 tween 列表的对象。相比之下，`BarChartTween` 对象非常适合这种情况。

*   假设处理逻辑在 `Bar.lerp` 中，`null` 条可用于表示折叠条。这种方法既灵活又高效，但需要注意避免引用或误解 `null`。在 Flutter SDK 中，静态 `lerp` 方法倾向于接受 `null` 作为动画终点，通常将其解释为某种不可见元件，如完全透明的颜色或零大小的图形元件。作为最基本的例子，除非两个动画端点都是 `null` 之外 `lerpDouble` 将 `null` 视为 0。

下面的代码段显示了我们如何处理 `null`：

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

我认为公正的说 Dart 的 `？` 语法非常适合这项任务。但请注意，使用折叠（而不是透明）条形图作为不可见元件的决定现在隐藏在 `Bar.lerp` 中。 这是我之前选择看似效率较低的解决方案的主要原因。与性能与可维护性一样，您的选择应基于实践。

* * *

在完整地处理条形图动画之前，我们还有一个步要做。 考虑使用条形图的应用程序，按给定年份的产品类别显示销售额。 用户可以选择另一年，然后应用应该为该年的条形图设置动画。 如果两年的产品类别相同，或者恰好相同，除了其中一个图表右侧显示的其他类别，我们可以使用上面的现有代码。 但是，如果公司在2016年拥有A，B，C和X类产品，但是已经停产B并在2017年引入了D，那该怎么办？ 我们现有的代码动画如下：

```
2016  2017
  A -> A
  B -> C
  C -> D
  X -> X
```

动画可能是美丽而流畅的，但它仍然会让用户感到困惑。 为什么？ 因为它不保留语义。 它将表示产品类别 B 的图形元件转换为表示类别 C 的图形元件，而将 C 表示元件转移到其他地方。 仅仅因为 2016 B 恰好被绘制在 2017 C 后来出现的相同位置，并不意味着前者应该变成后者。 相反，2016 B 应该消失，2016 C 应该向左移动并变为 2017 C，2017 D 应该出现在右边。我们可以使用书中最古老的算法之一来实现这种融合：合并排序列表。

_通过线性插值对应的元件，生成 tween 的合成值。 当元素形成排序列表时，合并算法可以使这些元素处于同等水平，根据需要使用不可见元素来处理单侧合并。_

我们所需要的只是使 `Bar` 实例按线性顺序相互比较。 然后我们可以合并它们，如下：

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

具体地说，我们将为 _bar_ 添加 `rank` 属性作一个排序键。 `rank` 也可以方便地用于为每个栏分配调色板中的颜色，从而允许我们跟踪动画演示中各个小节的移动。

随机条形图现在将基于随机选择的 `rank` 来包括 ([代码列表](https://gist.github.com/mravn-google/4f7194e8c1f875eba189856eb40e6b1e), [diff](https://github.com/mravn/charts/commit/5a41b26279fb5ba334c219bf4f6d74cd33daf01b)).

![](https://cdn-images-1.medium.com/max/800/1*MuSAOLktwY8bTJdPGuoNqA.gif)

任意类别。合并基础，线性插值。

干的不错，但也许不是最有效的解决方案。 我们在 `BarChart.lerp` 中重复执行合并算法，对于 `t` 的每个值都执行一次。 为了解决这个问题，我们将实现前面提到的想法，将可重用信息存储在 `BarChartTween` 中。

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

我们现在可以删除静态方法 `BarChart.lerp` ([diff](https://github.com/mravn/charts/commit/bb3b46f9384b8b90d50be1db59ce44ed83c61b2c)).

* * *

让我们总结一下到目前为止我们对 `tween` 概念的理解：

_动画_ _T_ _通过在所有_ _T_ _的空间中描绘出一条路径作为动画值,在0到1之间运行。 使用 `_Tween <T> _` 路径建模。_

_首先泛化_ `_T_` _的概念_，_直到它包含所有动画端点和中间值。_

_通过线性插值对应的元件，生成 tween 的合成值。_

*   _通信应该基于上下文，而不是偶然的图形定位。_
*   _如果某个动画终点中缺少某个元件，在其位置使用不可见的元件，这个元件可能是从另一个端点派生出来的。_
*   _在元件形成排序列表的位置，使用合并算法将语义上相应的元件放在一起，根据需要使用不可见元件来处理单侧合并。_

_考虑使用静态方法 `_Xxx.lerp_` 实现 `tweens`，以便在合成 `tween` 实现时重用。 对单个动画路径调用 `_Xxx.lerp_` 进行重要的重新计算，请考虑将计算移动到 `_XxxTween_` 类的构造函数，并让其实例承载计算结果
。_

* * *

有了这些见解，我们终于有能力制作更复杂的图表。 我们将快速连续地实现堆叠条形图，分组条形图和堆叠+分组条形图：

*   堆叠条形用于二维类别数据集，并且条形高度的数量加起来是有意义的。 一个典型的例子是产品和地理区域的收入。 按产品堆叠可以轻松比较全球市场中的产品的表现。 按区域堆叠显示哪些区域重要。

![](https://cdn-images-1.medium.com/max/800/1*qKUFM56S-ZonH1amVDDXTw.gif)

堆叠条形图。

*   分组条也用于具有二维类别的数据集，这种情况使用堆叠条形图没有意义或不合适。 例如，如果数据是每个产品和区域的市场份额百分比，则按产品堆叠是没有意义的。 即使堆叠确实有意义，分组也是可取的，因为它可以更容易地同时对两个类别维度进行定量比较。

![](https://cdn-images-1.medium.com/max/800/1*YiojxPiaWY7lB5v9iZVgDg.gif)

分组条形图。

*   堆叠+分组条形图支持三维类别，好比产品的收入，地理区域和销售渠道。

![](https://cdn-images-1.medium.com/max/800/1*9ObVOKbos4DoQsmsqbMnRQ.gif)

堆叠+分组条形图。

在所有三种变体中，动画可用于可视化数据集更改，从而引入额外的维度（通常是时间）而不会使图表混乱。

为了使动画有用而不仅仅是漂亮，我们需要确保我们只在语义相应的元件之间进 `lerp`。 因此，用于表示2016年特定产品/地区/渠道收入的条形段,应变为2017年相同产品/区域/渠道（如果存在）的收入。

合并算法可用于确保这一点。 正如您在前面的讨论中所猜测的那样，合并将在多个层面上发挥作用，反映出类别的维度。 我们将在堆积图表中组合堆和条形图，在分组图表中合并组和条形图，以及堆叠+分组图表中组合上面三个。

为了减少重复代码，我们将合并算法抽象为通用接口，并将其放在自己的文件`tween.dart`中：

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
