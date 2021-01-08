> * 原文地址：[How to build a circular slider in Flutter](https://medium.com/@danaya/how-to-build-a-circular-slider-in-flutter-cab3fc5312df)
> * 原文作者：[David Anaya](https://medium.com/@danaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-circular-slider-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-circular-slider-in-flutter.md)
> * 译者：[DevMcryYu](https://github.com/DevMcryYu)
> * 校对者：[MollyAredtana](https://github.com/MollyAredtana)，[JasonLinkinBright](https://github.com/JasonLinkinBright)

# 用 Flutter 打造一个圆形滑块（Slider）

![](https://cdn-images-1.medium.com/max/800/1*XDX3K2X8DhDCSNvzmezl4A.png)

你是否也曾想要通过为滑块添加双重滑块或修改其布局来让它看起来不那么无聊？

在这篇文章中我会展示如何通过整合 [GestureDetector](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html) 以及 [Canvas](https://docs.flutter.io/flutter/dart-ui/Canvas-class.html) 来在 Flutter 中构建一个圆形滑块。

如果你对构建它的过程不感兴趣，仅仅是为了获取此部件并使用它，那么你可以使用我在 [https://pub.dartlang.org/packages/flutter\_circular\_slider](https://pub.dartlang.org/packages/flutter_circular_slider) 发布的程序包。

## 为什么要用圆形滑块？

大多数情况下你并不会需要它。但想象一下：如果你想要用户选定一个时间段，或者只是想要一个比直线形状更有趣一点的常规滑块的场景时，就可以使用圆形滑块。

## 用什么来构建它？

我们要准备的第一件事就是创建一个真正的滑块。为此，我们要用一个完美的圆形作为背景，在它的基础上再画一个根据用户交互可以动态显示的圆。为了实现我们的想法，我们将用到一个名为 **CustomPaint** 的特殊部件，它提供一个允许让我们自由创作的画布（Canvas）。

当滑块渲染完成以后，我们希望用户能够和它进行交互，因此我们选择使用 **GestureDetector** 封装它来捕获点击及拖动事件。

完整流程是：

- 绘制滑块
- 当用户通过点击其中一个滑块并拖动它来与圆形滑块交互时识别此事件。
- 将事件的附加信息向下传递给画布（Canvas），在这里我们将重新绘制顶部圆形。
- 将新值一路向上传递给相应的 Handler，以便让用户观察到变化。（例如，更新滑块中心的文字显示）。

![](https://cdn-images-1.medium.com/max/800/1*pYN7CYWPxJikCq6aZ12OwA.png)

（只需关注上图黄色部分）

## 来画几个圆吧

我们要做的第一件事就是画两个圆。一个静态样式（无需改变），另一个则是动态的样式（响应用户交互），我使用两个 Painter 来分别绘制它们。

两个 Painter 都继承自 **CustomPainter** —— 一个由 **Flutter** 提供并实现 `paint()` 及 `shouldRepaint()` 方法的类。第一个方法用来绘制我们想要绘制的形状，第二个方法在有变化时进行重新绘制的时候调用。对于 **BasePainter** 而言我们永远不会需要重绘，因此它的返回值总是 false。而对于 **SliderPainter** 来说它总是返回 true，因为每次更改都意味着用户移动了滑块，必须更新所选择的项。

```
import 'package:flutter/material.dart';

class BasePainter extends CustomPainter {
  Color baseColor;

  Offset center;
  double radius;

  BasePainter({@required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = baseColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0;

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
```

可以看到，`paint()` 方法获得一个 **Canvas** 和一个 **Size** 参数。**Canvas** 提供一组方法可以让我们绘制任何形状：圆形、直线、圆弧、矩形等等。**Size** 参数即是画布的尺寸，由画布适配的部件尺寸决定。我们还需要一个 **Paint**，允许我们定制样式、颜色以及其他东西。

现在 **BasePainter** 的功能用法已经不言自明，然而 **SliderPainter** 却有一点儿不寻常，现在我们不仅要绘制一个圆弧而非圆，还需要绘制 Handler。

```
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/src/utils.dart';

class SliderPainter extends CustomPainter {
  double startAngle;
  double endAngle;
  double sweepAngle;
  Color selectionColor;

  Offset initHandler;
  Offset endHandler;
  Offset center;
  double radius;

  SliderPainter(
      {@required this.startAngle,
      @required this.endAngle,
      @required this.sweepAngle,
      @required this.selectionColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (startAngle == 0.0 && endAngle == 0.0) return;

    Paint progress = _getPaint(color: selectionColor);

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + startAngle, sweepAngle, false, progress);

    Paint handler = _getPaint(color: selectionColor, style: PaintingStyle.fill);
    Paint handlerOutter = _getPaint(color: selectionColor, width: 2.0);

    // 绘制 handler
    initHandler = radiansToCoordinates(center, -pi / 2 + startAngle, radius);
    canvas.drawCircle(initHandler, 8.0, handler);
    canvas.drawCircle(initHandler, 12.0, handlerOutter);

    endHandler = radiansToCoordinates(center, -pi / 2 + endAngle, radius);
    canvas.drawCircle(endHandler, 8.0, handler);
    canvas.drawCircle(endHandler, 12.0, handlerOutter);
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? 12.0;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
```

再一次地，我们获取了 center 和 radius 的值，但我们这次绘制的是圆弧。**SliderPainter** 将根据用户交互反馈的值作为 start、end 和 sweap 属性的值，以便于我们根据这些参数来绘制圆弧。值得一提的是我们需要从初始角度中减去 **pi/2**，因为我们的滑块的圆弧的起始位置是在圆形的正上方，而 `drawArc()` 方法使用 x 轴正轴作为起始位置。

当我们绘制好圆弧以后我们就需要准备绘制 Handler 了。为此，我们将分别绘制两个圆，一个在内部填充，一个在外部包裹。我调用了一些工具集函数用来将弧度转换为圆的坐标。你可以在 [Github 仓库内查阅这些函数](https://github.com/davidanaya/flutter-circular-slider/blob/master/lib/src/utils.dart)。

## 让滑块响应交互

目前来看，仅仅使用 **CustomPaint** 以及两个 Painter 就已经足够绘制想要的东西了。然而它们还是不能够进行交互。因此就要使用 **GestureDetector** 来对它进行封装。这样一来我们就可以在画布上对用户事件做出相应处理。

一开始我们将为 Handler 赋初值，当获取这些 Handler 的坐标后，我们将按照以下策略执行操作：

- 监听对于 Handler 的点击（按下）事件并更新相应 Handler 的状态。（**_xHandlerSelected = true**）。
- 监听被选中 Handler 的拖动更新事件，更新其坐标，同时分别向下、向上传递给 **SliderPainter** 和我们的回调函数。
- 监听 Handler 的点击（抬起）事件并重置未选中 Handler 的状态。

因为我们需要分别计算出坐标值、新的角度值再传递给 Handler 和 Painter，所以我们的 **CircularSliderPaint** 必须是一个 **StatefulWidget**。

```
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/src/base_painter.dart';
import 'package:flutter_circular_slider/src/slider_painter.dart';
import 'package:flutter_circular_slider/src/utils.dart';

class CircularSliderPaint extends StatefulWidget {
  final int init;
  final int end;
  final int intervals;
  final Function onSelectionChange;
  final Color baseColor;
  final Color selectionColor;
  final Widget child;

  CircularSliderPaint(
      {@required this.intervals,
      @required this.init,
      @required this.end,
      this.child,
      @required this.onSelectionChange,
      @required this.baseColor,
      @required this.selectionColor});

  @override
  _CircularSliderState createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSliderPaint> {
  bool _isInitHandlerSelected = false;
  bool _isEndHandlerSelected = false;

  SliderPainter _painter;

  /// 用弧度制表示的起始角度，用来确定 init Handler 的位置。
  double _startAngle;

  /// 用弧度制表示的结束角度，用来确定 end Handler 的位置。
  double _endAngle;

  /// 用弧度制表示的选择区间的绝对角度（夹角）
  double _sweepAngle;

  @override
  void initState() {
    super.initState();
    _calculatePaintData();
  }

  // 我们需要使用 gesture detector 来更新此部件，
  // 当父部件重建自己时也是如此。
  @override
  void didUpdateWidget(CircularSliderPaint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.init != widget.init || oldWidget.end != widget.end) {
      _calculatePaintData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: BasePainter(
            baseColor: widget.baseColor,
            selectionColor: widget.selectionColor),
        foregroundPainter: _painter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: widget.child,
        ),
      ),
    );
  }

  void _calculatePaintData() {
    double initPercent = valueToPercentage(widget.init, widget.intervals);
    double endPercent = valueToPercentage(widget.end, widget.intervals);
    double sweep = getSweepAngle(initPercent, endPercent);

    _startAngle = percentageToRadians(initPercent);
    _endAngle = percentageToRadians(endPercent);
    _sweepAngle = percentageToRadians(sweep.abs());

    _painter = SliderPainter(
      startAngle: _startAngle,
      endAngle: _endAngle,
      sweepAngle: _sweepAngle,
      selectionColor: widget.selectionColor,
    );
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (!_isInitHandlerSelected && !_isEndHandlerSelected) {
      return;
    }
    if (_painter.center == null) {
      return;
    }
    RenderBox renderBox = context.findRenderObject();
    var position = renderBox.globalToLocal(details.globalPosition);

    var angle = coordinatesToRadians(_painter.center, position);
    var percentage = radiansToPercentage(angle);
    var newValue = percentageToValue(percentage, widget.intervals);

    if (_isInitHandlerSelected) {
      widget.onSelectionChange(newValue, widget.end);
    } else {
      widget.onSelectionChange(widget.init, newValue);
    }
  }

  _onPanEnd(_) {
    _isInitHandlerSelected = false;
    _isEndHandlerSelected = false;
  }

  _onPanDown(DragDownDetails details) {
    if (_painter == null) {
      return;
    }
    RenderBox renderBox = context.findRenderObject();
    var position = renderBox.globalToLocal(details.globalPosition);
    if (position != null) {
      _isInitHandlerSelected = isPointInsideCircle(
          position, _painter.initHandler, 12.0);
      if (!_isInitHandlerSelected) {
        _isEndHandlerSelected = isPointInsideCircle(
            position, _painter.endHandler, 12.0);
      }
    }
  }
}
```

这里有几点需要注意：

- 我们想要在 Handler（以及选择区间）的位置更新时通知父部件，这也是该部件对外暴露了一个回调函数 `onSelectionChange()` 的原因。
- 当用户与滑块进行交互时，该部件需要被重新渲染，当起始位置的参数值改变时也需如此。这就是为什么我们有必要使用 `didUpdateWidget()` 方法。
- *CustomPaint* 同样可以接收一个 **child** 参数，这样我们就可以使用它在圆的内部渲染生成一些其他东西。只需要在 final widget 里暴露相同的参数，使用者就可以向其中传入任何想要的值。
- 我们使用一个间隔用以设置滑块的值。我们可以以此方便的将选择区间以百分比的形式表示。
- 再一次申明，为了在百分比、弧度以及坐标之间转换我调用了不同的工具集函数。画布（Canvas）中的坐标系与一般坐标系有一些不同，比如说画布坐标系是以左上角作为坐标原点，这样一来 x、y 的值都将一直是一个正值。同样的，弧度制的表示是以 x 正坐标轴开始并以顺时针方向（总是正值）从 **0** 到 **2*pi** 计量。
- 最后，Handler 的坐标计算以画布的原点为参考，而 **GestureDetector** 的坐标则是相对设备而言的，是全局的，因此我们需要用到 `RenderBox.globalToLocal()` 方法来对它们进行转换。该方法使用部件的 Context 作为参考。

有了这些，我们也就拥有了打造圆形滑块的一切需要。

## 额外的功能

由于篇幅有限，在这里并没有展开讲解所有的细节。你可以查看本项目的仓库，我会乐于回答评论中的任何问题。

在最终的版本里我添加了一些额外的功能，比如自定义选择区间和 Handler 的颜色；如果你想实现类似时钟的样式（小时和分钟）你可以根据需求进行选择。为了方便各位使用，我同样将所有内容打包放进了一个最终的部件内。

你也可以通过从 [https://pub.dartlang.org/packages/flutter\_circular\_slider](https://pub.dartlang.org/packages/flutter_circular_slider) 导入本库的方式来使用这个部件。

文章至此告一段落，感谢各位的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
