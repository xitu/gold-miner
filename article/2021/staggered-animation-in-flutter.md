> * 原文地址：[Staggered Animation In Flutter](https://medium.com/flutterdevs/staggered-animation-in-flutter-e7282a936b99)
> * 原文作者：[Shaiq khan](https://medium.com/@shaiq_khan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[lsvih](https://github.com/lsvih)

# Flutter 中的交织动画

![Flutter 中的交织动画](https://cdn-images-1.medium.com/max/2000/1*icYuiagsCKqcRapvjiLbmw.png)

交织动画由一个动画序列或重叠的动画组成，而要制作交织的动画，我们需要使用多个或多组动画对象。我们应该使用同一个 `AnimationController` 控制所有动画，每个动画对象都应该指定某个点或锚点在一段时间内的运动，并且对于要执行的动画的每个属性，我们都应该创建一个补间（`Tween`）。

所谓交织动画，直接来说就是：并非在同一时刻发生全部的视觉变化，而是让其随着任务的进行逐步发生。这个动画可能纯粹只是一个顺序动画，视觉上的变化一个接一个的出现；也可能有部分的动画重叠出现，乃至完全重叠。当然，交织动画的动画中同样可能会有一些时刻空着，即在一些间隙中没有发生任何动画。

[**这里是一段有关交织动画的样例视频**](https://youtu.be/0fFvnZemmh8)

在这个视频中，你可以看到发生在一控件上，从一个带边框而略微有圆角的蓝色矩形的出现开始的动画。这个矩形会按照以下顺序变化：

* 淡入
* 水平上变宽
* 向上移动同时竖直上变得更高
* 变为一个有边框的圆圈
* 颜色变为橙色

在顺序播放完动画后，将会反向播放上述的动画。

#### 交织动画的基础结构

* 所有的动画都是由相同同样的 `AnimationController` 控制。
* 无论动画在现实时间中播放多长时间，控制器的值必须在 0.0 和 1.0 之间，包括 0.0 和 1.0。
* 每个动画都有一个 `Interval`，这个值必须在 0.0 和 1.0 之间，包括 0.0 和 1.0。
* 对于每一个间隔内产生动画的属性，创建一个 `Tween`。 `Tween` 指定此属性的开始值和结束值。
* `Tween` 产生一个由动画控制器管理的 `Animation` 对象。

#### 要设置这样一个动画

* 创建一个 `AnimationController` 管理所有的 `Animations`。
* 为每一个有动画的属性创建一个 `Tween`。
* 为 `Tween` 设置不同的值。
* `Tween` 的 `animate()` 方法需要一个 `AnimationController` 来用这些属性生成一个动画。
* 通过修改 `Animation` 构造器中的 `curve` 属性指定动画的间隔时间

**如何在 Flutter 中使用交织动画:**

下面的代码为 avatarSize 这一属性定义了一个补间动画。它构造了一个 [**CurvedAnimation**](https://api.flutter.cn/flutter/animation/CurvedAnimation-class.html) 动画类并且指定了动画曲线为一条 elasticOut 曲线。要查看更多的预设动画曲线，请访问网页 [**Curves**](https://api.flutter.cn/flutter/animation/Curves-class.html) 。

```dart
avatarSize = Tween<double>(
  begin: 50.0,
  end: 150.0,
).animate(
  CurvedAnimation(
    parent: controller,
    curve: Interval(
      0.125, 0.250,
      curve: Curves.elasticOut,
    ),
  ),
),
```

> `AnimationController` 和 `Animation` 定义了类 `AnimationController` 的实例
> 以下是 `AnimateController` 以及 5 个用于控制动画的进展的 `Animation` 的实例，其中 `<double>` 用于获取一个用于定义动画过程的数值，该数值必须在 0 到 1 之间。

```dart
final AnimationController controller;
final Animation<double> barHeight;
final Animation<double> avatarSize;
final Animation<double> titleOpacity;
final Animation<double> textOpacity;
final Animation<double> imageOpacity;
```

> 我们应该在控件的定义中覆写 `initState` 方法以在其中完成对 `AnimationController` 的初始化，在定义语句中，我们实际是在设置动画的参数。下面的例子我们将动画时长设置为 3 秒。

```dart
// 译者注：代码从 Flutter 库中截取，路径 /lib/src/animation/animation_controller.dart:150
@override
void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, // 对 SingleTickerProviderStateMixin 的引用
        duration: widget.duration,
    );
}
```

**如何在代码中实现：**

你需要在代码中实现以下内容：

* 添加一个 `StatefulWidget` （带有状态的）控件
* 然后将这个控件与 `SingleTickerProviderStateMixin` Mixin，以让 `AnimationController` 确定它的动画时长为 3500 毫秒。

控制器将会播放一个动画，然后会在 widget 树上创建一个无动画的部分。当在屏幕上检测到点击事件时，开始播放动画。动画一开始会顺序播放，然后会倒序播放。

```Dart
import 'package:flutter/material.dart';
import 'package:stag_animation/trekking/staggered_trekking.dart';

class StaggeredTrekkingAnimation extends StatefulWidget {
  @override
  _StaggeredTrekkingAnimationState createState() =>
      _StaggeredTrekkingAnimationState();
}

class _StaggeredTrekkingAnimationState extends State<StaggeredTrekkingAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    _controller.forward();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // 这个动画被暂停了，可能因为该控件被 dispose 了。
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _playAnimation();
      },
      child: StaggeredTrekking(
        controller: _controller,
      ),
    );
  }
}
```

在 Staggered Trekking Enter 动画中，我们使用了补间去决定动画的进展。

接下来，你会完成一个无状态的控件的 [Staggered Trekking 动画](https://github.com/ShaiqAhmedkhan/Flutter_Staggered_Animation/blob/master/lib/trekking/staggered_trekking.dart)。我们会用 `build()` 函数为这个控件的动画初始化定义一个 [**AnimatedBuilder**](https://api.flutter.cn/flutter/widgets/AnimatedBuilder-class.html)。同时，我们需要创建一个名为 `_buildAnimation()` 的函数，负责更新用户界面，并将其分配给 `builder` 属性.

```Dart
import 'package:flutter/material.dart';

class StaggeredTrekkingEnterAnimation {
  StaggeredTrekkingEnterAnimation(this.controller)
      : barHeight = Tween<double>(begin: 0, end: 150).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0, 0.3, curve: Curves.easeIn),
          ),
        ),
        avatarSize = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 0.6, curve: Curves.elasticOut),
          ),
        ),
        titleOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.6, 0.65, curve: Curves.easeIn),
          ),
        ),
        textOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.65, 0.8, curve: Curves.easeIn),
          ),
        ),
        imageOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 0.99, curve: Curves.easeIn),
          ),
        );

  final AnimationController controller;
  final Animation<double> barHeight;
  final Animation<double> avatarSize;
  final Animation<double> titleOpacity;
  final Animation<double> textOpacity;
  final Animation<double> imageOpacity;
}
```

`AnimatedBuilder` 将侦听来自动画控制器的通知，然后会标记该控件的值的改变。对于动画的每一帧，这些值会因为调用 `_buildAnimation()` 而都被更新。

在下面发布的视频中，你将看到交织动画的工作方式。当你在屏幕上的任意位置点击时，它将启动动画并在向前播放动画之后自动向后播放动画。在这代码中，你还可以控制动画播放的速度。

![](https://cdn-images-1.medium.com/max/2000/1*vQm1tBYamr7UZSaoApsAdg.gif)

这就是交织动画的基本示例。在这里我们做了一个简单的示例，你可以尝试学习它。

**单击下面的 GitHub 链接以找到交织动画的源代码：**

[**flutter-devs/Flutter-StaggeredAnimation**](https://github.com/flutter-devs/Flutter-StaggeredAnimation)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
