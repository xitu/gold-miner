> * 原文地址：[Make shimmer effect in Flutter: Learn Flutter from UI challenges](https://medium.com/flutter-community/make-shimmer-effect-in-flutter-dbe7a1bfd980)
> * 原文作者：[Hung HD](https://medium.com/@hunghdyb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)

# 在 Flutter 中实现微光闪烁效果

通过挑战 UI 制作来学习 Flutter

### 介绍

我是一个狂热的移动开发者，Android 平台和 iOS 平台开发都有涉及。过去我不相信任何跨平台的开发框架（Ionic，Xamarin，ReactNative），但现在我要讲一下我遇到跨平台开发框架 Flutter 之后的故事。

### 灵感

作为一名原生应用开发人员，我深深感到 UI 定制开发是多么痛苦，即使是使用跨平台开发框架去进行开发，这种痛苦也不能得到缓解，有时甚至会更糟糕。但 Flutter 的出现让我看到改善这种痛苦的希望。

Flutter 从无到有构建所有 UI 元素（称为 Widget）。没有去封装原生视图，没有使用基于 web 的 UI 元素。如同游戏框架在游戏中构建游戏世界的方式（角色、敌人、宫殿…）那样，Flutter 基于 Skia 图形渲染引擎来绘制自己的 UI。这样做真的很有意义，因为你可以完全控制你在屏幕上绘制的东西。这是否让你在脑海中想到点什么？对我来说，这听起来似乎是在告诉我我可以更加容易地进行 UI 定制开发了。我尝试挑战一些 UI 效果实现来证明这一点。

我想到的一个挑战是微光闪烁效果。这是一个非常常见的效果，如果你不熟悉这个名字，那么想一下你唤醒手机时所显示的“滑动解锁”动画。

![](https://cdn-images-1.medium.com/max/800/1*rV4-EajphSqKhKNMULo6gg.gif)

### 怎么做

基本思路很简单。动画效果由从左到右移动的渐变所组成。

关键是我不想仅仅为文本内容来做这个效果。这种效果在现代的移动应用中作为加载动画是非常流行的。

![](https://cdn-images-1.medium.com/max/800/1*Q_vOKcscz1lQ7LL_prsARw.gif)

第一个初始想法是在内容布局的顶部绘制一个不透明的渐变区域。虽然这可以实现，但不是一个好方法。我们不希望动画效果弄脏我们的整个白色背景。效果需要仅适用在给定的内容布局上。

现在是时候参考一下 Flutter 文档和示例代码去了解如何实现这种效果了。

经过研究我发现一个名为 **SingleChildRenderObjectWidget** 的基类，该基类露出一个 **Canvas** 对象。**Canvas** 是一个对象，它负责在屏幕上绘制内容，它有一个有趣的方法称为 **saveLayer**，它用来“在保存堆栈上保存当前变换和片段的副本，然后创建一个新的组，用于保存后续调用”（摘自官方文档）。这正是我需要的特性，它让我可以在特定内容布局上实现微光闪烁效果。

### 实现

在 Flutter 中，有一个很不错的小练习可以参考。一个 widget 通常包含一个名为 **child** 或 **children** 的参数，它可以帮助我们将变换应用到后代 widget。我们的 **Shimmer** widget 也有一个 **child**，它可以让我们创建任何我们想要的布局，然后将它作为 **Shimmer** 的 **child** 进行传递，**Shimmer** widget 反过来只会对那个 **child** 起作用。

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

**`_Shimmer`** 是负责效果绘画的内部类。它从 **SingleChildRenderObjectWidget** 扩展而来并重写了 **paint** 方法来执行绘制任务。我们使用 **Canvas** 对象的 **saveLayer** 和 **paintChild** 方法来捕捉我们的 **child** 作为一个图层并在上面绘制渐变效果（带上一点 **BlendMode** 的魔法）。

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

剩下的就是添加一个动效，让我们的效果动起来。这里没什么特别的，我们将创建一个动效来在绘制渐变之前从左到右移动 **Canvas**，这样就能产生渐变移动的效果。

我们在 **`_ShimmerState`** 中为动效创建一个新的 **AnimationController**。我们的 **`_Shimmer`** 类和 **`_ShimmerFilter`** 类还需要一个新变量（称之为 **percent**）来存储该动画执行的进度结果，并在每次 **AnimationController** 发出新值时调用 **markNeedsPaint**（这会让 widget 重新绘制）。**Canvas** 的移动位移量可以根据 **percent** 的值计算出来。

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

这只是个开始。接下来我会使用 Flutter 来挑战更多更复杂的 UI 效果。我将在下一篇文章中分享我的成果。感谢你的阅读!

> 备注：我已经将我的代码发布为一个名为 [shimmer](https://pub.dartlang.org/packages/shimmer) 的包.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
