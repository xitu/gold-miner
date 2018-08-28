> * 原文地址：[Flutter Heroes and Villains — bringing balance to the Flutterverse.](https://medium.com/flutter-community/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse-2e900222de41)
> * 原文作者：[Norbert](https://medium.com/@norbertkozsir?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-heroes-and-villains-bringing-balance-to-the-flutterverse.md)
> * 译者：[DateBro](https://github.com/DateBro)
> * 校对者：

# Flutter 的 Heroes 和 Villains —— 为 Flutterverse 带来平衡

## 这是一个关于 Heroes 和 Villains 如何运行的故事。

![](https://cdn-images-1.medium.com/max/1600/1*AHypbXYdBWnNfLoeseJ3lw.gif)

一个 Hero 常常与多个 Villain 相伴而生。

__Villain 允许你只需几行代码就可以添加上面的页面转换。__

安装包在[这里](https://github.com/Norbert515/flutter_villains)。你可以在项目的 [README](https://github.com/Norbert515/flutter_villains/blob/master/README.md) 如何使用 Villains。这篇文章更侧重于解释 Heroes 和 Villains 以及所有这些背后的思考过程。

Flutter 最令惊奇的一点是它为所有东西提供漂亮和干净的 API。我**喜欢**你使用 Hero 的方式。两行简单的代码，它就生效了。你只需要把 Hero 扔到这两个地方，按照标签分配，其它就不需要管了。

* * *

### 在你理解 Villain 之前，你必须先理解 Hero。

![](https://cdn-images-1.medium.com/max/1600/1*QbbLnNEKCz02skDo2QRuOg.gif)

先简单了解一下 Hero。

我们来快速了解一下 Hero 是如何实现的。

#### 概览

Hero 的动画涉及三个主要步骤。

**1. 找到并匹配 Heroes**

第一步是确定哪些 Hero 存在以及哪些 Hero 具有相同的标记。

**2. 确定 Hero 位置**

然后，捕获两个 Hero 的位置并准备好旅程。

**3. 启动旅程**

旅程始终在新屏幕上进行，而不在实际的组件中。在开始页面上的组件在旅程期间被替换成空的占位符组件 `(SizedBox)`。而使用 `Overlay`（`Overlay`可以在所有内容上显示组件）。

> 整个 Hero 动画发生在正在打开的页面上。组件是完全独立，不在页面之间共享任何状态的。

* * *

#### NavigationObserver

可以通过 `NavigationObserver` 观察压入和弹出路由的事件。

```
/// 一个管理 [Hero] 过渡的 [Navigator] observer。
///
/// 应该在 [Navigator.observers] 中使用 [HeroController] 的实例。
/// 这由 [MaterialApp] 自动完成。
class HeroController extends NavigatorObserver
```

[HeroController](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L431)

Hero 使用这个类开始旅程。除了能够自己添加 `NavigationObservers` 之外，`MaterialApp` 默认添加了 `HeroController`。[__看一下这里。__](https://github.com/flutter/flutter/blob/v0.5.5/packages/flutter/lib/src/material/app.dart#L598)

#### Hero 组件

```
  /// 创建一个 Hero
  ///
  /// [tag] 和 [child] 必须非空。
  const Hero({
    Key key,
    @required this.tag,
    this.createRectTween,
    @required this.child,
  }) : assert(tag != null),
       assert(child != null),
       super(key: key);
```

[Hero](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L80) 的构造器

Hero 组件实际上并没有做太多。它拥有 child 和 tag。除此之外，`createRectTween` 参数决定了 `Hero` 在飞往目的地时所采用的路由。默认的实现是 `MaterialRectArcTween`。顾名思义，它将 Hero 沿弧线移动到最终位置。

Hero 的状态也负责捕获大小并用占位符替换自己。

#### `_allHeroesFor`

元素（具体组件）放在树中。通过访客，你可以沿着树下去并收集信息。

```
  // 返回上下文中所有 Hero 的 map，由 hero 标记索引。
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

在方法内部声明了一个名为 visitor 的内联函数。`context.visitChildElements(visitor)` 方法和 `element.visitChildren(vistor)` 直到访问完上下文的所有元素才调用函数。在每次访问时，它会检查这个 child 是否为 `Hero`，如果是，则将其保存到 map 中。

#### 旅程的开始

```
  // 在 from 和 to 中找到匹配的 Hero 对，并启动新的 Hero 旅程，
  // 或转移现有的 Hero 旅程。
  void _startHeroTransition(PageRoute<dynamic> from, PageRoute<dynamic> to, _HeroFlightType flightType) {
    // 如果在调用帧尾回调之前删除了导航器或其中一个路由子树，
    // 那么接下来实际上不会开始转换。
    if (navigator == null || from.subtreeContext == null || to.subtreeContext == null) {
      to.offstage = false; // in case we set this in _maybeStartHeroTransition
      return;
    }

    final Rect navigatorRect = _globalBoundingBoxFor(navigator.context);

    // 在这一点上，toHeroes 可能是第一次建造和布局。
    final Map<Object, _HeroState> fromHeroes = Hero._allHeroesFor(from.subtreeContext);
    final Map<Object, _HeroState> toHeroes = Hero._allHeroesFor(to.subtreeContext);

    // 如果 `to` 路由是在屏幕外的，
    // 那么我们暗中将其动画值恢复到它“移到”屏幕外之前的状态。
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

这会响应路由压入/弹出事件而被调用。在第 14 行和第 15 行，你可以看到 `_allHeroesFor` 调用，它可以在两个页面上找到所有 Hero。从第 21 行开始构建 `_HeroFlightManifest` 并启动旅程。从这里开始，有一堆动画的代码设置和边缘情况的处理。我建议你看一下[整个类](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart)，这很有意思，里面还有很多值得学习的东西。你也可以看一下[这个](https://flutter.io/animations/hero-animations/)。

* * *

### Villains 是如何运行的

Villains 要比 Hero 更简单。

![](https://cdn-images-1.medium.com/max/1600/1*DyLbjknJBTxiDOWhcZf0bg.gif)

Hero 和 3 个 Villain 使用（AppBar，Text，FAB）。

他们使用相同的机制来查找给定上下文的所有 Villain，他们还使用 `NavigationObserver` 自动对页面转换做出反应。但不是从一个屏幕到另一个屏幕的动画，而是仅在它们各自的屏幕上做的动画。

#### SequenceAnimation 和 自定义 TickerProvider

处理动画时，通常使用 `SingleTickerProviderStateMixin`或 `TickerProviderStateMixin`。在这种情况下，动画不会在 `StatefulWidget` 中启动，因此我们需要另一种方法来访问 `TickerProvider`。

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

自定义一个 ticker 非常简单。所有这一切都是为了实现 `TickerProvider` 接口并返回一个新的 `Ticker`。

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

    // 用于新页面动画的控制器，因为它的时间比实际页面转换更长

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

    //开始动画
    return controller.forward().then((_) {
      controller.dispose();
    });
  }
```

首先，所有不应该展示的 Villain（那些将 animateExit/ animateEntrance 设置为 false 的人）都会被过滤掉。然后创建一个带有自定义 `TickerProvider` 的 `AnimationController`。使用 [SequenceAnimation](https://pub.dartlang.org/packages/flutter_sequence_animation) 库，每个 `Villain` 被分配一个动画，它们在各自的时间中运行 0.0 —— 1.0（`from` 和 `to` 持续时间）。最后，动画全部开始。当它们全部完成时，控制器被丢弃。

#### Villains 的 build() 方法

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

这可能看起来很可怕，但请先忍耐一下。让我们看看第 3 行和第 4 行。`widget.villainAnimation.animatedWidgetBuilder` 是一个自定义的 typedef：

```
typedef Widget AnimatedWidgetBuilder(Animation animation, Widget child);
```

它的工作是返回一个根据动画绘制的组件（大多数时候返回的组件是一个 `AnimatedWidget`）。

它得到了 Villain 的 child 和这个动画：

```
widget.villainAnimation.animatable.chain(CurveTween(curve: widget.villainAnimation.curve)).animate(_animation)
```

链方法首先评估 `CurveTween`。然后它使用该值来评估调用它的 `animatable`。这只是将所需的曲线添加到动画中。

**这是关于 Villain 如何工作的粗略概述，请务必也查看[源代码](https://github.com/Norbert515/flutter_villains/blob/master/lib/villains/villains.dart)并大胆地提出你们的问题。**

* * *

### 可变的静态变量很槽糕，让我解释一下

深夜，我坐在我的办公桌前，写下测试。几个小时后，每一次单独的测试都过去了，似乎没有 bug。就在睡觉之前，我把所有的测试都放在一起，以确保它真的没问题。然后发生了这个：

![](https://cdn-images-1.medium.com/max/1600/1*l2ugqc801sM0pm6FVa8KsQ.png)

每个测试都只能单独通过。

我很困惑。每次测试都成功。果然，当我自己运行这两个测试时，它们很正常。但是当一起运行所有测试时，最后两个失败了。WTF。

第一反应显然是：“我的代码肯定没错，它一定对测试的执行方式做了些什么！也许测试是并行播放因此相互干扰？也许是因为我使用了相同的键？”

Brian Egan向我指出，删除一个特定的测试修复了错误并将其移到顶部使得其他所有测试也失败了。如果那不是“共享数据”那么我不知道是什么。

当我发现问题是什么时，我忍不住笑了。这正是在某些情况下使用静态变量不好的原因。

基本上，预定义的动画都是静态的。我懒得为每个动画编写一个方法来获取 `VillainAnimation` 所需的所有参数。所以我使 `VillainAnimation` __是可变的（坏主意）__。这样我就没有必要在方法中明确写出所有必要的参数。使用时看起来像这样：

```
Villain(
  villainAnimation: VillainAnimation.fromBottom(0.4)
    ..to = Duration(milliseconds: 150),
  child: Text("HI"),
)
```

打破一切的测试应该在页面转换完成后开始测试 Villain 转换。它将动画的起点设置为 1 秒。因为它是在静态引用上设置它，之后的测试使用它作为默认值。测试失败，因为动画无法在 1 秒到 750 毫秒之间运行。

修复很简单（使一切都不可变并在方法中传递参数）但我仍然觉得这个小错误非常有趣。

* * *

### 总结

感谢 Villain 恢复了好坏之间的平衡。

关于 #fluttervillains 的意见和讨论是受欢迎的。如果你使用 Villain 一起制作很酷的动画，我很希望看到它。

[我的 Twitter: @norbertkozsir](https://twitter.com/norbertkozsir?lang=en)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

