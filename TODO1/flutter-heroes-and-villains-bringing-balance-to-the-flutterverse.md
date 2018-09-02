> * 原文地址：[Flutter Heroes and Villains — bringing balance to the Flutterverse.](https://medium.com/flutter-community/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse-2e900222de41)
> * 原文作者：[Norbert](https://medium.com/@norbertkozsir?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse.md)
> * 译者：
> * 校对者：

# Flutter Heroes and Villains — bringing balance to the Flutterverse.

## A story about how heroes and villains work.

![](https://cdn-images-1.medium.com/max/1600/1*AHypbXYdBWnNfLoeseJ3lw.gif)

Villains combined with a hero.

_Villains allow you to add page transition like the one above with just a few lines of code._

The package is available [here](https://github.com/Norbert515/flutter_villains). You can find how to use villains in the projects [README](https://github.com/Norbert515/flutter_villains/blob/master/README.md). This post is more focused on explaining heroes and villains and the thought process behind all of it.

One of the most awesome parts of flutter is having such a nice and clean API for everything. I just **love** the way you can use Heroes. Two simple lines of code, and it just works. You just drop in Heroes at two places, assign according tags and the rest is taken care of.

* * *

### Before you understand the villain, you must first understand the hero.

![](https://cdn-images-1.medium.com/max/1600/1*QbbLnNEKCz02skDo2QRuOg.gif)

Simple Hero transition.
 
We’ll take a quick look at how the heroes are implemented.

#### Overview

There are three major steps involved in the hero animation.

1.  **Finding and matching the heroes**

The first step is to determine which heroes exist and which have the same tag.

**2. Determining the hero positions**

Then, the position of both heroes are captured and the flight is ready to happen.

**3. Initiating the flight**

The flight always happens on the new screen, but not with the actual widget. The widget on the opening page is replaced with an empty placeholder widget `(SizedBox)` during the flight. Instead the `Overlay` is used (the `Overlay` can display widgets on top of everything).
 
> The whole hero animation happens on the page being opened. The widgets don’t share any state between pages and are completely separate.

* * *

#### The NavigationObserver

It is possible to observe the events of routes being pushed and popped with a `NavigationObserver`.

```
/// A [Navigator] observer that manages [Hero] transitions.
///
/// An instance of [HeroController] should be used in [Navigator.observers].
/// This is done automatically by [MaterialApp].
class HeroController extends NavigatorObserver
```

[HeroController](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L431)

The hero uses this class to start the flight. Besides being able to add `NavigationObservers` yourself, the `MaterialApp` adds the `HeroController` by default. [_Take a look._](https://github.com/flutter/flutter/blob/v0.5.5/packages/flutter/lib/src/material/app.dart#L598)

#### The Hero Widget

```
  /// Create a hero.
  ///
  /// The [tag] and [child] parameters must not be null.
  const Hero({
    Key key,
    @required this.tag,
    this.createRectTween,
    @required this.child,
  }) : assert(tag != null),
       assert(child != null),
       super(key: key);
```

The constructor of the [Hero](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L80)

The hero widget doesn’t actually do much. It holds the child and the tag. In addition to that, the `createRectTween` argument determines what route the `Hero` takes while flying to its destination. The default implementation is the `MaterialRectArcTween`. As the name suggests it moves the hero along an arc to its final position.

The state of the hero also is responsible for capturing sizes and replacing itself with the placeholder.

#### _allHeroesFor

Elements (concrete widgets) are placed in a tree. Using a visitor, you can walk down the tree and gather information.

```
  // Returns a map of all of the heroes in context, indexed by hero tag.
  static Map<Object, _HeroState> _allHeroesFor(BuildContext context) {
    assert(context != null);
    final Map<Object, _HeroState> result = <Object, _HeroState>{};
    void visitor(Element element) {
      if (element.widget is Hero) {
        final StatefulElement hero = element;
        final Hero heroWidget = element.widget;
        final Object tag = heroWidget.tag;
        assert(tag != null);
        assert(() {
          if (result.containsKey(tag)) {
            throw new FlutterError(
              'There are multiple heroes that share the same tag within a subtree.\n'
              'Within each subtree for which heroes are to be animated (typically a PageRoute subtree), '
              'each Hero must have a unique non-null tag.\n'
              'In this case, multiple heroes had the following tag: $tag\n'
              'Here is the subtree for one of the offending heroes:\n'
              '${element.toStringDeep(prefixLineOne: "# ")}'
            );
          }
          return true;
        }());
        final _HeroState heroState = hero.state;
        result[tag] = heroState;
      }
      element.visitChildren(visitor);
    }
    context.visitChildElements(visitor);
    return result;
  }
```

[heroes.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L119)

An inline function called visitor is declared inside the method. The `context.visitChildElements(visitor)` method and `element.visitChildren(vistor)`call the function until all elements below the context are visited. On each visit it checks whether that child is a `Hero` and if it is, it saves it into a map.

#### The start of the flight

```
// Find the matching pairs of heros in from and to and either start or a new
  // hero flight, or divert an existing one.
  void _startHeroTransition(PageRoute<dynamic> from, PageRoute<dynamic> to, _HeroFlightType flightType) {
    // If the navigator or one of the routes subtrees was removed before this
    // end-of-frame callback was called, then don't actually start a transition.
    if (navigator == null || from.subtreeContext == null || to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    final Rect navigatorRect = _globalBoundingBoxFor(navigator.context);

    // At this point the toHeroes may have been built and laid out for the first time.
    final Map<Object, _HeroState> fromHeroes = Hero._allHeroesFor(from.subtreeContext);
    final Map<Object, _HeroState> toHeroes = Hero._allHeroesFor(to.subtreeContext);

    // If the `to` route was offstage, then we're implicitly restoring its
    // animation value back to what it was before it was "moved" offstage.
    to.offstage = false;

    for (Object tag in fromHeroes.keys) {
      if (toHeroes[tag] != null) {
        final _HeroFlightManifest manifest = new _HeroFlightManifest(
          type: flightType,
          overlay: navigator.overlay,
          navigatorRect: navigatorRect,
          fromRoute: from,
          toRoute: to,
          fromHero: fromHeroes[tag],
          toHero: toHeroes[tag],
          createRectTween: createRectTween,
        );
        if (_flights[tag] != null)
          _flights[tag].divert(manifest);
        else
          _flights[tag] = new _HeroFlight(_handleFlightEnded)..start(manifest);
      } else if (_flights[tag] != null) {
        _flights[tag].abort();
      }
    }
  }
```

[heroes.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L499)

This gets called in response to the route push/pop event. On line 14 and 15 you can see the `_allHeroesFor` call which finds all heroes on both pages. Starting on line 21 a `_HeroFlightManifest` is constructed and the flight is initiated. From here on there is a bunch of code setting up the animation and handling edge cases. I encourage you to take a look at the [whole class](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart), it’s pretty interesting and there’s a lot to learn from it. Also you can take a look at [this](https://flutter.io/animations/hero-animations/).

* * *

### How do villains work

Villains are simpler creatures than Heroes.

![](https://cdn-images-1.medium.com/max/1600/1*DyLbjknJBTxiDOWhcZf0bg.gif)

Hero with 3 villains playing (AppBar, Text, FAB).

They use the same mechanic of finding all villains for a given context and they also use a `NavigationObserver` to automatically react on page transitions. But instead of animating from one screen to another they only animate on their respective screen.

#### SequenceAnimation and custom TickerProvider

When dealing with animations, you usually use the `SingleTickerProviderStateMixin` or the `TickerProviderStateMixin`. In this case the animation doesn’t start in a `StatefulWidget` and we therefore need another way to access a `TickerProvider`.

```
class TransitionTickerProvider implements TickerProvider {
  final bool enabled;

  TransitionTickerProvider(this.enabled);

  @override
  Ticker createTicker(TickerCallback onTick) {
    return new Ticker(onTick, debugLabel: 'created by $this')..muted = !this.enabled;
  }
}
```

Defining a custom ticker is pretty easy. All there is to it is implementing the `TickerProvider` interface and returning a new `Ticker`.

```
  static Future playAllVillains(BuildContext context, {bool entrance = true}) {
    List<_VillainState> villains = VillainController._allVillainssFor(context)
      ..removeWhere((villain) {
        if (entrance) {
          return !villain.widget.animateEntrance;
        } else {
          return !villain.widget.animateExit;
        }
      });

    // Controller for the new page animation because it can be longer then the actual page transition

    AnimationController controller = new AnimationController(vsync: TransitionTickerProvider(TickerMode.of(context)));

    SequenceAnimationBuilder builder = new SequenceAnimationBuilder();

    for (_VillainState villain in villains) {
      builder.addAnimatable(
        anim: Tween<double>(begin: 0.0, end: 1.0),
        from: villain.widget.villainAnimation.from,
        to: villain.widget.villainAnimation.to,
        tag: villain.hashCode,
      );
    }

    SequenceAnimation sequenceAnimation = builder.animate(controller);

    for (_VillainState villain in villains) {
      villain.startAnimation(sequenceAnimation[villain.hashCode]);
    }

    //Start the animation
    return controller.forward().then((_) {
      controller.dispose();
    });
  }
```

First all villains which should not be playing (those who set animateExit/animateEntrance to false) are filtered out. Then an `AnimationController` with the custom `TickerProvider` is created. Using the [SequenceAnimation](https://pub.dartlang.org/packages/flutter_sequence_animation) library each `Villain` is assigned an animation running from 0.0–1.0 in their respective time slot (the `from` and `to` duration). At the end, animations are all started. When all of them finish, the controller is disposed.

#### The Villain build()

```
  @override
  Widget build(BuildContext context) {
    Widget animatedWidget = widget.villainAnimation
        .animatedWidgetBuilder(widget.villainAnimation.animatable.chain(CurveTween(curve: widget.villainAnimation.curve)).animate(_animation), widget.child);
    if (widget.secondaryVillainAnimation != null) {
      animatedWidget = widget.secondaryVillainAnimation.animatedWidgetBuilder(
          widget.secondaryVillainAnimation.animatable.chain(CurveTween(curve: widget.secondaryVillainAnimation.curve)).animate(_animation), animatedWidget);
    }

    return animatedWidget;
  }
```

This might look scary, but bear with me. Let’s just look at line 3 and 4. The `widget.villainAnimation.animatedWidgetBuilder` is a custom typedef:

```
typedef Widget AnimatedWidgetBuilder(Animation animation, Widget child);
```

Its job is to return a widget which animates according to the animation (most of the times the returned widget is an `AnimatedWidget`).

It gets handed the child of the villain and this animation:

```
widget.villainAnimation.animatable.chain(CurveTween(curve: widget.villainAnimation.curve)).animate(_animation)
```

The chain method first evaluates the `CurveTween`. It then uses that value to evaluate the `animatable` on which it is called. This simply adds the desired curve to the animation.

**_That was a rough overview on how the villains work, be sure to also look at the_** [**_source code_**](https://github.com/Norbert515/flutter_villains/blob/master/lib/villains/villains.dart) **_and feel free to ask questions._**

* * *

### Mutable static variables are bad, let me explain..

I was sitting at my desk in the late evening, writing tests. After a few hours every single test was passing and it seemed there were no bugs. Right before heading to bed I ran all the tests together to make sure it’s alright. Then this happend:

![](https://cdn-images-1.medium.com/max/1600/1*l2ugqc801sM0pm6FVa8KsQ.png)

Each test passes on its own but not together

I was pretty confused. Every test succeed before. Sure enough, when I ran those two tests by themselves, they worked as expected. But when running all tests together the last two failed. WTF.

The first reaction was obviously: “My code must be working, it has to do something with the way tests are executed! Maybe tests are playing in parallel and thus interfering with each other? Maybe it is because I used the same keys?”.

Brian Egan point out to me that deleting one particular test fixed the bug and moving it to the top made all other tests fail too. If that doesn’t scream “SHARED DATA” then I don’t know what does.

When I found out what the problem was I just couldn’t stop laughing. It was exactly the reason why using static variables are considered bad in certain situations.

Basically, the predefined animations were all static. I was too lazy to write a method for each animation taking all the parameters that a `VillainAnimation` needs. So I made the `VillainAnimation` _mutable (bad idea)._ This way I didn’t have to explicitly write all the necessary parameters into the method. This looked like this when using it:

```
Villain(
  villainAnimation: VillainAnimation.fromBottom(0.4)
    ..to = Duration(milliseconds: 150),
  child: Text("HI"),
)
```

The test which broke everything was supposed to test villain transitions starting after the page transition finished. It set the starting point of the animation to 1 second. Because it was setting it on a static reference, the test after that used that as the default. The tests failed because an animation can’t run from 1 second to 750 milliseconds.

The fix was pretty easy (making everything immutable and passing the arguments in the method) but I still found this little bug quite entertaining.

* * *

### Wrapping up

Thanks to the Villains the balance between good and evil is now restored.

Opinions and discussions about the #fluttervillains are welcome. If you create cool animations with the villains, I’d love to see it.

[My Twitter: @norbertkozsir](https://twitter.com/norbertkozsir?lang=en)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
