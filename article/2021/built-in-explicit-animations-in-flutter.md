> * 原文地址：[Built-in Explicit Animations in Flutter](https://medium.com/flutterdevs/built-in-explicit-animations-in-flutter-438a039dd90)
> * 原文作者：[Shaiq khan](https://medium.com/@shaiq_khan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/built-in-explicit-animations-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/built-in-explicit-animations-in-flutter.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[lsvih](https://github.com/lsvih)

# Flutter 中内置的显式动画

![](https://cdn-images-1.medium.com/max/2160/1*-VpftDFf_ArJZoyuOjqBJA.png)

在我们的 [上一篇文章](https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md) 中，我们弄清楚了如何利用 Flutter 的交织动画编写一些完美的动画。`AnimatedFoo` 和 `TweenAnimationBuilder` 让我们能够将一些基本动画运用在应用程序中。这些动画通常从头到尾使用补间进行渲染，而在这背后，Flutter 代替了我们控制好了这一切，满足了我们对动画的预期，也让我们不用再担心动画的播放顺序。

对于部分动画来说，使用补间动画是极好的选择。当然，我们也可以用另外一种方式重新开始制作新的动画。

Flutter 有很多带有过渡动画的控件，而它们都以 `Transition` 结尾，它们包括了 [`ScaleTransition`](https://api.flutter.cn/flutter/widgets/ScaleTransition-class.html)、[`SizeTransition`](https://api.flutter.cn/flutter/widgets/SizeTransition-class.html)、[`DecoratedBoxTransition`](https://api.flutter.cn/flutter/widgets/DecoratedBoxTransition-class.html)。它们与我们所创作的的 `AnimateBlah` 控件非常类似。

例如说 [`PositionedTransition`](https://api.flutter.cn/flutter/widgets/PositionedTransition-class.html)，它可以产生在各个位置移动的小部件的动画。这些动画与补间动画很是相像，但是有明显的不同：这些 `Transition` 控件应该在 [`AnimatedWidget`](https://api.flutter.cn/flutter/widgets/AnimatedWidget-class.htmlhttps://api.flutter.dev/flutter/widgets/AnimatedWidget-class.html) 的构造中使用，而这就是显式动画。

![一张太阳的图片，没有旋转](https://cdn-images-1.medium.com/max/5760/1*Rj0MJbE-gRj3gmUTwSkKog.jpeg)

## `RotationTransition` 旋转变换

[`RotationTransition`](https://api.flutter.cn/flutter/widgets/RotationTransition-class.html) 是一个非常有用的控件，它的构造语句仅仅需要三个属性。

```dart
// （大多数的） RotationTransition 构造语句
RotationTransition({
  Widget child,
  Alignment alignment,
  Animation<double> turns
})
```

`child` — 提供要旋转的控件，这里是显示太阳的图片的控件 `GalaxyWay()`。接下来我们要在 `alignment` 中提供控件旋转的中心（对齐），此处我们规定了图片的中心，即太阳的中心 —— 我们的预期嘛。

```dart
RotationTransition(
  child: GalaxyWay(),
  alignment: Alignment.center,
  turns: _repeatingAnimationLong
),
```

简简单单的代码就是使 `RotationTransition` 和各种 `Transition` 控件构成的动画被称为显式动画的原因。我们只需通过调用 `AnimatedContainer` 控件并进行更改就可以轻松实现旋转动画。借助显式动画，我们可以控制时间与旋转次数，使太阳不断旋转。

![](https://cdn-images-1.medium.com/max/2000/1*oeGSTGSJwkqzQueCykTggw.gif)

对于 `RotationTransition` 而言，属性 `turns` 会直接影响我们的控件的旋转次数，而它所接受的输入类型是 `Animation<double>`。

## 创建一个 `AnimationController` 动画控制器

得到一个 `Animation<double>` 值最有效的方法是创建一个 [`AnimationController` 动画控制器](https://api.flutter.cn/flutter/animation/AnimationController-class.html)。这个控制器将会为我们控制每一帧的动画。

我们必须在有状态的控件 `StatefulWidget` 中进行设置，以保证我们能够持续访问并操作动画控制器。由于 `AnimationController` 同样具有自己的状态要管理，因此我们需要在 `initState()` 中对其进行初始化，并在 `dispose()` 中对其进行处理。

我们应为“动画控制器”提供两个参数，第一个是动画的持续长度。Dart 为我们提供了一个 `Duration` 类供使用。对于这个例子，让我们设定下来，让太阳的图片转动一次持续 5 秒，然后暂停旋转 15 秒，咋样？

```dart
_animationController = AnimationController(
  duration: Duration(seconds: 15),
  // TODO: 尚需完成剩余构造
);
```

在我们把控制器制作完成以后，我们不会再需要编写完成太多的代码。这是因为我们已获得一个控制器。

创建 `AnimationController` 的同时，我们也要赋予一个 `vsync` 参数。`vsync` 的存在防止后台动画消耗不必要的资源。我们可以通过添加 `SingleTickerProviderStateMixin` 到控件的类定义，将有状态的控件赋予给 `vsync`。

另外，我们需要太阳永远旋转下去，不是吗？为此，我们需要要求控制器重复动画下去。

```dart
_animationController = AnimationController(
  duration: Duration(seconds: 15),
  vsync: this,
)..repeat();
```

## 使用 `AnimationController` 动画控制器

仁慈的我还添加了一个彩蛋，让用户可以控制阳光。我在页面中添加一个基本按钮，并隐藏在了动画中，然后我将其传递给控制器的引用，以便在其 `onTap` 监听中可以停止或重新开始动画。

控制器将维护包括动画的状态在内的各种状态。如果动画正在播放，我们可以检查动画状态，也可以停止播放动画。而如果动画不在播放中，我们可以使用控制器重新启动动画。也就是说，通过使用动画控制器，我们就可以根据需求控制动画的播放与暂停。除此之外，动画控制器还有一些其它的功能。

通过使用控制器，我们可以同样地为特定值设置动画（或从该值反向），并以给定的速度播放动画，或使用类似的控制器来控制各种动画。

![](https://cdn-images-1.medium.com/max/2000/1*qmRBKLFSVNTvW8-uWFvbKw.gif)

这只是我们对 Flutter 中的显式动画的第一次尝试。我们看到了 Transition 控件如何运行，以及学会了使用 `AnimationController` 来命令动画修改方向或其他动画属性。在以后的文章中，我们将进一步剖析显式动画以及介绍如何自定义使用显式动画。

在下面的视频中，我们可以看到这个显式动画的运行结果 —— 当我们在屏幕上的任意位置点击时，动画会被暂停。而在屏幕任意位置再次点击就会恢复动画的播放。同样的，我们也可以通过修改代码来控制动画的速度以及播放的方向。

![](https://cdn-images-1.medium.com/max/2000/1*y7sP1wxW1UHb_42Wv2foUw.gif)

这就是显式动画的基本入门了，我们在本文中构建了一个示例，而我相信，通过学习，你也同样可以轻松学会如何去制作这样一个动画，感谢你的阅读～

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
