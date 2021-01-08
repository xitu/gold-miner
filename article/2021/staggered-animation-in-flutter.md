> * 原文地址：[Staggered Animation In Flutter](https://medium.com/flutterdevs/staggered-animation-in-flutter-e7282a936b99)
> * 原文作者：[Shaiq khan](https://medium.com/@shaiq_khan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md)
> * 译者：
> * 校对者：

# Staggered Animation In Flutter

![](https://cdn-images-1.medium.com/max/2000/1*icYuiagsCKqcRapvjiLbmw.png)

A staggered animation includes consecutive or covering animations.To make an staggered animation, to utilize a few/couple of Animation items.One Animation Controller controls all the Animations.Each Animation object shows the movement at some point or another of an Interval.For each preferred position being animated, make a Tween.

Staggered animations movements are a direct idea: visual changes occur as a progression of tasks, instead of at the same time. The activity may be simply consecutive, with one change occuring after the following, or it may somewhat or totally cover. It may likewise have holes, where no progressions happen.

[**Here is the demo video you can take a look staggered animation**](https://youtu.be/0fFvnZemmh8)

In this video, you will see the accompanying animation movement of a single widget, which starts as a bordered blue square with marginally adjusted corners. The square runs they will blur and afterward change in square was broaden in measure and afterward square becomes taller while moving upwards and they will changes into an outskirt circle and the progressions shading blue to orange,after walking forward, the activity runs backward.

#### Structure of a staggered animation

The entire of the animations are pushed by methods for a similar Animation Controller.Regardless of the way extensive the animation movement keeps going in genuine time, the controller’s qualities should be among zero.0 and 1.0, comprehensive.

Every animation movement has an Interval among zero.Zero and 1.0, comprehensive.

For every having a place that animates in an interval, make a Tween. The Tween determines the beginning and give up values for that assets.The Tween produces a Animation thing that is made do with the guide of the controller.

#### To set up the animation:

* Make a Animation Controller that deals with every one of the Animations.
* Make a Tween for each having a place being animated.
* The Tween characterizes different values.
* The Tween’s animate technique requires the decide controller, and produces a Animation for that assets.
* Determine the interval time frame at the Animation’s curve assets.

**How to use Staggered animation in Flutter:**

The following code makes a tween for the avatarSize property. It constructs a [**CurvedAnimation**](https://api.flutter.dev/flutter/animation/CurvedAnimation-class.html), determining an elasticOut curve. See [**Curves**](https://api.flutter.dev/flutter/animation/Curves-class.html) for other accessible pre-characterized animation **Curves**.

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

> **Animation controller and Animation** define an instance of the class **AnimationController** for the animation controller and five instances of the class **Animation** to handle animations (double to get a progressive value from 0 to 1).

```dart
final AnimationController controller;
final Animation<double> barHeight;
final Animation<double> avatarSize;
final Animation<double> titleOpacity;
final Animation<double> textOpacity;
final Animation<double> imageOpacity;
```

> **Animation initializing** override the `initState` method and define the parameters for the animation. For this situation, the duration is set to three seconds.

```dart
_controller = AnimationController(
  duration: const Duration(milliseconds: 3500),
  vsync: this,);
```

**How to implement in dart file:**

You need to implement it in your code respectively:

This stateful widget, Staggered Trekking Animation add as a mixin the **SingleTickerProviderStateMixin** and makes the AnimationController was determining a 3500 ms duration. It will plays the animation movement and builds the non-animating portion of the widget. The animation start when a tap is distinguished in the screen. The animation movement runs forward and then reverse automatically.

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
      // the animation got canceled, probably because we were disposed
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

In Staggered Trekking Enter Animation, using the tween’s current values and next you will make a Stateless widget, [Staggered Trekking](https://github.com/ShaiqAhmedkhan/Flutter_Staggered_Animation/blob/master/lib/trekking/staggered_trekking.dart)** make a `build()` function an [**AnimatedBuilder**](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html)—this widget for building animations. We create a function named `_buildAnimation()` and it work UI updates and assigns it to its **builder** property.

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
//final Animation<double> contactOpacity;
}
```

AnimatedBuilder will listen to the notifications from the animation controller will marking the widget for the values change. For each tick of the animation, the values were updated, resulting in a call to `_buildAnimation()`.

here in the video posted below, you will see how staggered animation were working and when you tap anywhere in that screen it starts animation and run reverse automatically animation, you can control the speed of animation also.

![](https://cdn-images-1.medium.com/max/2000/1*vQm1tBYamr7UZSaoApsAdg.gif)

So this was the basic example of Staggered Animation where we did a simple example and you can learn it.

**Click the GitHub link below to find the source code of the Staggered Animation:**

[**flutter-devs/Flutter-StaggeredAnimation**](https://github.com/flutter-devs/Flutter-StaggeredAnimation)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
