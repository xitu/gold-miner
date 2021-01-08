> * 原文地址：[Built-in Explicit Animations in Flutter](https://medium.com/flutterdevs/built-in-explicit-animations-in-flutter-438a039dd90)
> * 原文作者：[Shaiq khan](https://medium.com/@shaiq_khan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/built-in-explicit-animations-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/built-in-explicit-animations-in-flutter.md)
> * 译者：
> * 校对者：

# Built-in Explicit Animations in Flutter

![](https://cdn-images-1.medium.com/max/2160/1*-VpftDFf_ArJZoyuOjqBJA.png)

In our [last post](https://github.com/xitu/gold-miner/blob/master/article/2021/staggered-animation-in-flutter.md), we figured out how to do some marvellous animations movements utilizing Flutter’s staggered animations. `AnimatedFoo` and `TweenAnimationBuilder`enabled you to drop some fundamental animations into your application. These animations commonly go one way, “tweening” from a beginning to an end, where they stop. Off-camera, Flutter is taking control, accepting expectations and discarding any requirement for you to stress over the change starting with one thing then onto the next.

This works superbly for some animations objectives, yet in some cases that ever-forward bolt of time leaves us feeling transiently bolted. All in all, as we stop and think about the laws of thermodynamics and the unavoidable warmth demise of the universe, wouldn’t it be decent on the off chance that we could switch time, and do everything once more?

Transition widgets are a lot of Flutter widgets whose names all end in — you speculated it — Transition. [`ScaleTransition`](https://api.flutter.dev/flutter/widgets/ScaleTransition-class.html), [`SizeTransition`](https://api.flutter.dev/flutter/widgets/SizeTransition-class.html) , [`DecoratedBoxTransition`](https://api.flutter.dev/flutter/widgets/DecoratedBoxTransition-class.html), and that’s just the beginning. They look and feel a great deal like our `AnimateBlah` widgets. [`PositionedTransition`](https://api.flutter.dev/flutter/widgets/PositionedTransition-class.html), for example, animates a widget’s progress between various positions. This is a lot of like, however, there is one significant contrast: these Transition widgets are augmentations of [`AnimatedWidget`](https://api.flutter.dev/flutter/widgets/AnimatedWidget-class.htmlhttps://api.flutter.dev/flutter/widgets/AnimatedWidget-class.html). This makes them **explicit animations**.

![An image of Sun(GalaxyWay) just sitting on the galaxy, **not** rotating](https://cdn-images-1.medium.com/max/5760/1*Rj0MJbE-gRj3gmUTwSkKog.jpeg)

## RotationTransition

The [`RotationTransition`](https://api.flutter.dev/flutter/widgets/RotationTransition-class.html) widget is a helpful one that deals with the entirety of the trigonometry and changes math to make things turn. Its constructor just takes three things:

```dart
// [Most of] RotationTransition’s constructor
RotationTransition({
  Widget child,
  Alignment alignment,
  Animation<double> turns,
})
```

child — the widget we need to turn. The galaxy way, so we’ll put it there: Next, we have to give `RotationTransition` the point our sun turns around. Our sun is generally in the centre of the picture where we’d ordinarily anticipate. Along these lines, we’ll give an arrangement of focus, making the entirety of our rotational math “adjusted” to that point.

```dart
RotationTransition(
  turns: _repeatingAnimationLong,
  child: GalaxyWay(),
  alignment: Alignment.center,
),
```

Not to stress! This is a piece of what makes `RotationTransition `and the various Transition widgets, an explicit animation. We could achieve a similar rotation impact with an `AnimatedContainer` and a change, however then we’d turn once and afterwards stop. With our explicit animations movements, we have control of time and can make it so our sun spins constantly.

![](https://cdn-images-1.medium.com/max/2000/1*oeGSTGSJwkqzQueCykTggw.gif)

The turns property expects something that gives it a value and educates it when that value changes. An `Animation\<double>` is just that. For `RotationTransition`, the value analyzes how regularly we’ve turned, or even the more explicitly, the level of one revolution finished.

## Creating an AnimationController

Perhaps the most effortless approaches to get an `Animation\<double>` is to make an `AnimationController`, which is a [controller for animation](https://api.flutter.dev/flutter/animation/AnimationController-class.html). This controller handles tuning in for ticks¹ and gives us some helpful powers over what the movement is doing.

We’ll have to make this in a stateful widget since keeping an idea about the controller will be significant in our imminent future. Since `AnimationController` likewise has its own state to manage, we initialize it in `initState`, and dispose of it in `dispose()`.

There are two parameters we should provide for `Animation Controller’s `constructor. The first is a length, which is to what extent our explicit animation movement keeps going. The entire explanation we’re here is that we need an article to disclose to us how far along we are in a solitary revolution. Of course, `AnimationController` “emits” values from `0.0` to `1.0`. What number of and how granular those qualities are relied upon to what extent we need a single rotation to take. Luckily, Dart gives us a `Duration` class to utilize. For this demo, we should have the sun turning somewhere close to 5 seconds and 230 million years for every revolution. What about 15 seconds for each turn at that point?

```dart
_animationController = AnimationController(
  duration: Duration(seconds: 15),
  // TODO: finish constructing me.
);
```

On the off chance that we left things at that, not a lot occurs. That is on the grounds that we’ve been given a controller, yet haven’t pressed any of its buttons! We need our sun to turn forever, isn’t that so? For that, we’ll simply ask the controller to continually repeat the animation movement.

```dart
_animationController = AnimationController(
  duration: Duration(seconds: 15),
  vsync: this,
)..repeat();
```

## Making use of an AnimationController

Allowing anybody to control the sun appears to be a piece excessively lenient, however, so I’m going to make it an easter egg. I’ll add a sibling to the sun that is a basic button, covered up off background in the animation, and I’ll pass it a reference to our controller so that inside its `onTap` listener, we can stop or restart the movement.

The controller maintains — among other things — the status of the animation, which we can check and stop in case we’re running or restart in case we’re definitely not. What’s more, there you go! By utilizing an animation controller, we’re ready to control the animation movement on request. In any case, that is not everything you can do with the controller.

With it, you can likewise animate to (or in reverse from) a particular value, flying the animation movement forward with a given speed, or control various animations with a similar controller.

![](https://cdn-images-1.medium.com/max/2000/1*qmRBKLFSVNTvW8-uWFvbKw.gif)

This was only our first taste of explicit animations in Flutter. We saw how a Transition widget functions`AnimationController`to give some directionality and command over how our animation functions. In future posts, we’ll be jumping further into explicit animations and how to get considerably more altered.

here in the video posted below, you will see how explicit animation was working and when you tap anywhere in that screen then it pause the animation and the whole animation will freeze and then you tap again anywhere in that screen then it resumes animation, you can control the speed of animation and also the movement of directions.

![](https://cdn-images-1.medium.com/max/2000/1*y7sP1wxW1UHb_42Wv2foUw.gif)

So this was the basic example of Explicit Animation where we did a simple example and you can learn it and also you can do it.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
