> * 原文地址：[Make shimmer effect in Flutter: Learn Flutter from UI challenges](https://medium.com/flutter-community/make-shimmer-effect-in-flutter-dbe7a1bfd980)
> * 原文作者：[Hung HD](https://medium.com/@hunghdyb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md)
> * 译者：
> * 校对者：

# Make shimmer effect in Flutter

Learn Flutter from UI challenges

### Intro

I am a passionate mobile developer on both of Android and iOS platform. I used to not believe in all of the cross-platform frameworks (Ionic, Xamarin, ReactNative,..) but I am here now to tell my story when I meet Flutter, a cross-platform framework.

### Inspiration

As a native developer, I feel the pains of UI customization and there’re even more pains in almost cross-platform frameworks. Flutter comes and really makes sense in this aspect.

Flutter builds up all of the UI elements (called Widget) from scratch. There’s no wrapped native views, no web-based ui elements. Like the way game frameworks builds up the world in game (character, enemies, palaces,..), Flutter is based on Skia graphics renderer engine to draw its own UI world. It really makes sense because you have full-control of what you are drawing on screen. That rings a bell in your head, doesn’t it? With me, it sounds like I can create UI customization easier. I try taking some UI challenges to figure it out.

A challenge I think of is shimmer effect. This is a very familiar effect, if that name is not familiar to you, think of the ‘Slide to unlock’ animation when you wake up your iPhone.

![](https://cdn-images-1.medium.com/max/800/1*rV4-EajphSqKhKNMULo6gg.gif)

### How it works

The basic idea is simple. The animation is made up of the movement of a gradient from left to right.

The point is I don’t want to bring up the effect for only text content. This effect is also very familiar as a loading animation in modern mobile applications.

![](https://cdn-images-1.medium.com/max/800/1*Q_vOKcscz1lQ7LL_prsARw.gif)

The first naive idea is simply to draw an opaque gradient area in the top of content layout. It works but not a good one. We don’t want our effect make dirty on our white background. The effect need to be only applied for a given content layout.

It’s time to turn to Flutter document and example code to find out how to do it.

My study drives me to a base class called **SingleChildRenderObjectWidget** which exposes **Canvas** object. **Canvas** is an object that is responsible for drawing content on screen and it has an interesting method called **saveLayer** to “_save a copy of the current transform and clip on the save stack, and then creates a new group which subsequent calls will become a part of”_ (its document said). It’s exactly the feature I need to isolate my shimmer effect on a particular content layer.

### Implementation

In Flutter, there’s a good practice to follow. A widget often includes a parameter named **child** or **children** that helps us to apply our transforms to descendant widgets. Our **Shimmer** widget also has a **child** and it lets us make up whatever layout we want then pass it as a **child** of **Shimmer**, **Shimmer** widget in its turn will only apply the effect for that **child**.

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

**_Shimmer** is our internal class responsible for effect painting. It extends from **SingleChildRenderObjectWidget** and overrides **paint** method to do paint tasks. We are going to use **saveLayer** and **paintChild** method of **Canvas** object to capture our **child** as a layer and draw the gradient on it (with a little magic from **BlendMode**).

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

The rest is to make an animation and our effect will really active. There’s nothing special here, we are going to create an animation to translate our **Canvas** from left to right before the gradient is drawn, it makes the effect of gradient moving.

We create a new **AnimationController** in **_ShimmerState** for our animation. Our **_Shimmer** and **_ShimmerFilter** class also need a new variable (call it **percent**) to store result from that animation execution and call **markNeedsPaint** whenever a new value emitted from **AnimationController** (it causes our widget repainted). The translation value of **Canvas** will be calculated form **percent** value.

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

Not bad. We’ve just done the shimmer effect with roughly 100 lines of code. That’s the beauty of Flutter.

It’s just beginning. There’re more complex challenges I want to play with Flutter. I will share my results in next posts. Thanks for reading!

> P/S: I already published my code as a package called [shimmer](https://pub.dartlang.org/packages/shimmer).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
