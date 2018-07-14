> * 原文地址：[Make shimmer effect in Flutter: Learn Flutter from UI challenges](https://medium.com/flutter-community/make-shimmer-effect-in-flutter-dbe7a1bfd980)
> * 原文作者：[Hung HD](https://medium.com/@hunghdyb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 在 Flutter 中实现微光闪烁效果

通过挑战 UI 制作来学习 Flutter

### 介绍

我是一个狂热的移动开发者，Android 平台和 iOS 平台都有涉及。过去我不相信任何的跨平台开发框架（Ionic，Xamarin，ReactNative），但现在我要讲一下我遇到跨平台开发框架 Flutter 之后的故事。

### 灵感

作为一名原生应用开发人员，我深深感到 UI 定制开发是多么痛苦，甚至在几乎所有的跨平台框架中这种痛苦可能更甚。Flutter 的出现让我看到改善这种痛苦的希望。

Flutter 从无到有构建所有 UI 元素（称为 Widget）。没有封装原生视图，没有基于 web 的 UI 元素。如同游戏框架在游戏中构建世界的方式（角色、敌人、宫殿…）那样，Flutter 基于 Skia 图形渲染引擎来绘制自己的 UI。这样做真的很有意义，因为你可以完全控制你在屏幕上绘制的东西。这是否让你在脑海中想到点什么？对我来说，这听起来好像告诉我我可以更加容易地进行 UI 定制开发。我尝试用一些 UI 制作挑战来证明这一点。

我想到的一个挑战是微光闪烁效果。这是一个非常常见的效果，如果你不熟悉这个名字，那么想一下你唤醒手机时所显示的“滑动解锁”动画。

![](https://cdn-images-1.medium.com/max/800/1*rV4-EajphSqKhKNMULo6gg.gif)

### 怎么做

基本思路很简单。动画由从左到右移动的渐变效果组成。

关键是我不想仅仅为文本内容来做这个效果。这种效果在现代的移动应用中作为加载动画也非常流行。

![](https://cdn-images-1.medium.com/max/800/1*Q_vOKcscz1lQ7LL_prsARw.gif)

第一个原始想法在布局的顶部绘制一个不透明的渐变区域。这样做可以，但不是一个好做法。我们不希望我们的效果把我们的白色背景变得很脏。效果需要仅适用于给定的内容层上。

现在是时候参考一下 Flutter 文档和示例代码以了解如何实现这种效果。

经过研究我发现一个名为 **SingleChildRenderObjectWidget** 的基类，该基类公开 **Canvas** 对象。**Canvas** 是一个对象，它负责在屏幕上绘制内容，它有一个有趣的方法称为 **saveLayer**，它用来“在保存堆栈上保存当前转换和剪辑的副本，然后创建一个新的组，后续调用将成为其中的一部分”（摘自官方文档）。这正是我需要的特性，它让我可以在特定内容层上实现微光闪烁效果。

### 实现

在 Flutter 中，有一个很好的小练习可以残奥。一个 widget 通常包含一个名为 **child** 或 **children** 的参数，它可以帮助我们将变换应用到后代 widget。我们的 **Shimmer** widget 也有一个 **child**，它可以让我们创建任何我们想要的布局，然后将它作为 **Shimmer** 的 **child** 进行传递，**Shimmer** widget 反过来只会对那个 **child** 起作用。

```
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Gradient gradient;
  
  Shimmer({Key key, this.child, this.period, this.gradient}): super(key: key);
  
  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> {
  @override
  Widget build(BuildContext context) {
    return _Shimmer();
  }
}
```

** _ Shimmer **是我们负责效果绘画的内部类。 它从** SingleChildRenderObjectWidget **扩展并覆盖** paint **方法来执行绘制任务。 我们将使用** saveLayer **和** paintChild **方法** Canvas **对象来捕捉我们的**子**作为一个图层并在其上绘制渐变（来自** BlendMode的一点魔法）**）。

```
import 'package:flutter/rendering.dart';

class _Shimmer extends SingleChildRenderObjectWidget {
  final Gradient gradient;

  _Shimmer({Widget child, this.gradient})
      : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(gradient);
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final _clearPaint = Paint();
  final Paint _gradientPaint;
  final Gradient _gradient;

  _ShimmerFilter(this._gradient)
      : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  @override
  bool get alwaysNeedsCompositing => child != null;
  
  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final rect = offset & child.size;
      _gradientPaint.shader = _gradient.createShader(rect);

      context.canvas.saveLayer(rect, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }
}
```

剩下的就是做一个动画效果，让我们的效果动起来。这里没什么特别的，我们将创建一个动画效果来在绘制渐变之前从左到右翻译我的**画布**，它会使渐变效果移动。

我们在动画中为** _ ShimmerState **创建一个新的** AnimationController **。 我们的** _ Shimmer **和** _ ShimmerFilter **类还需要一个新变量（称之为**百分比**）来存储来自该动画执行的结果，并在** AnimationController发出新值时调用** markNeedsPaint ** **（它导致我们的小部件重新绘制）。 ** Canvas **的翻译值将以**百分比**值计算。

```
class _ShimmerState extends State<Shimmer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.period)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: widget.child,
      gradient: widget.gradient,
      percent: controller.value,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
```

[flutter_shimmer3_1.dart](https://gist.github.com/hnvn/6624c02f719d8753c6802f2090e767ce#file-flutter_shimmer3_1-dart)

```
class _Shimmer extends SingleChildRenderObjectWidget {
  ...
  final double percent;

  _Shimmer({Widget child, this.gradient, this.percent})
      : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  ...
  double _percent;

  _ShimmerFilter(this._percent, this._gradient)
      : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  ...

  set percent(double newValue) {
    if (newValue != _percent) {
      _percent = newValue;
      markNeedsPaint();
    }
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final width = child.size.width;
      final height = child.size.height;
      Rect rect;
      double dx, dy;

      dx = _offset(-width, width, _percent);
      dy = 0.0;
      rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);

      _gradientPaint.shader = _gradient.createShader(rect);

      context.canvas.saveLayer(offset & child.size, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.translate(dx, dy);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
```

[flutter_shimmer3_2.dart](https://gist.github.com/hnvn/6624c02f719d8753c6802f2090e767ce#file-flutter_shimmer3_2-dart)

还不错。我们刚刚只用了大约 100 行代码就实现了微光闪烁效果。这就是 Flutter 的美妙之处。

这只是个开始。接下来我会使用 Flutter 来挑战更复杂的效果。我将在下一篇文章中分享我的成果。感谢你的阅读!

> 备注: 我已经将我的代码发布为一个名为 [shimmer](https://pub.dartlang.org/packages/shimmer) 的包.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
