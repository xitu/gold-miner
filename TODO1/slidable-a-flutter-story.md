> * 原文地址：[Slidable: A Flutter story](https://medium.com/flutter-community/slidable-a-flutter-story-f4a5f55f6a96)
> * 原文作者：[Romain Rastel](https://medium.com/@lets4r?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/slidable-a-flutter-story.md](https://github.com/xitu/gold-miner/blob/master/TODO1/slidable-a-flutter-story.md)
> * 译者： [YueYong](https://github.com/YueYongDev)
> * 校对者：

# Slidable: 一个Flutter的故事

![](https://cdn-images-1.medium.com/max/800/1*BBp8dGLaZ8v8IHvXUYoZng.png)

### 概要

这是创建 **Slidable** 小部件背后的故事 (点击[这里](https://pub.dartlang.org/packages/flutter_slidable))。 他是一个当您向左侧或右侧滑动时，可以在列表项上添加上下文操作的小部件。

### 这一切是如何开始的呢

我是一个充满激情的开发者。编码是我为生活所做的，但他更多的是我的主要爱好 ❤️。有些人通过文字，图画，音乐表达自己，我通过代码表达自己。 变量和函数比打球更能让我感到舒服。这就是我。

我们 2018 年 7 月在法国的布列塔尼，这里阳光充足☀️，有点热，但我不想享受阳光或者去海滩，我渴望学习新东西和编码。

我是 Flutter 的忠实粉丝，我已经发布了一些软件包([flutter_staggered_grid_view](https://github.com/letsar/flutter_staggered_grid_view), [flutter_parallax](https://github.com/letsar/flutter_parallax), [flutter_sticky_header](https://github.com/letsar/flutter_sticky_header))。所有这些都有一些共同之处： **Slivers**.  
还记得吗？我想学习新的东西。所以我选了一个新主题：动画！

现在我有一些东西需要学习，我需要一个想法，用这些知识创造一些东西。我记得当我发现 Flutter 的时候，我考虑了 3 个当时不存在的小部件：交错的网格视图，粘性标题和一个允许用户在左右滑动时显示在列表项两侧的上下文菜单。我没有尝试过最后一个，所以就诞生了这个想法💡。

### 从哪里开始呢

在一个已有的例子上创造总是更容易。这就是为什么每次我想要创造一些东西时，我首先要研究是否有类似的我可以调整的东西。

我开始在 Pub Dart 上搜索，看看是否有人还没有发布过那个，如果是这样的话，我会停下来去寻找一个新的想法。

在那里我找不到我想要的东西，所以我搜索了 StackOverflow 并找到了这个[问题](https://stackoverflow.com/questions/46651974/swipe-list-item-for-more-options-flutter/46662914)。用户 Remi Rousselet 给出了一个非常好的[答案](https://stackoverflow.com/a/46662914/3241871)。
我阅读并理解了他的代码，并对我构建了第一个原型有很大的帮助。所以 Remi ，如果你正在读我，非常感谢 👏。

### 从原型到第一次发布

在我开发了使用一个动画的原型后，我立刻想到让开发人员创建自己的动画。我想起一个让开发人员在网格中控制布局的工具 [SliverDelegate](https://docs.flutter.io/flutter/rendering/SliverGridDelegate-class.html) ， 并决定创建类似的东西。

让开发人员自定义动画很棒，但我必须提供一些内置动画，以便任何开发人员都可以使用它们，或调整我的动画来创建他们的动画。

这就是为什么我首先创建了 3 个代表：

#### SlidableBehindDelegate

使用这个对象，滑动操作在列表项后。

![](https://cdn-images-1.medium.com/max/800/1*-lxI0VkO5MCC3PW74VaLWA.gif)

SlidableBehindDelegate的例子

#### SlidableScrollDelegate

使用此对象，幻灯片操作将以与列表项相同的方向滚动。

![](https://cdn-images-1.medium.com/max/800/1*KW9wXmgPGHbCV24gGIl8ZA.gif)

 SlidableScrollDelegate的例子

#### SlidableStrechDelegate

使用此对象，当列表项滑动时，幻灯片操作正在增长。

![](https://cdn-images-1.medium.com/max/800/1*lwGjFSE0--Ij7U5YbvOiSQ.gif)

SlidableStrechDelegate的例子

#### SlidableDrawerDelegate

有了这个，滑动动作显示出一种视差效果，就像在 iOS 中一样。

![](https://cdn-images-1.medium.com/max/800/1*OlubJ7rmOK5QgvsC3aVY8Q.gif)

SlidableDrawerDelegate的例子

对于这个故事，当我向我的同事 [Clovis Nicolas](https://github.com/clovisnicolas) 展示前 3 位代表时，他告诉我，在 iOS 中拥有这样效果的应用会很棒。由于我不是 iOS 用户，我认为它更像是SlidableStrechDelegate，但没有。
这就是 SlidableDrawerDelegate 如何诞生的过程。

###  Flutter 中的动画

我没有写过我在 Flutter 中学到的关于动画的内容，因为还有其他内容可以很好的解释它，就像[这个](https://proandroiddev.com/animations-in-flutter-6e02ee91a0b2)。

但我可以分享我对 Flutter 中动画的感受：它们非常棒且易于处理 😍!

我很后悔之前没有使用过他们😃。

### 写在最后

完成这些内置对象后，我认为这将是一个很好的初始版本。所以我公开了我的 [GitHub 代码库](https://github.com/letsar/flutter_slidable)，并在 [Dart Pub](https://pub.dartlang.org/packages/flutter_slidable) 上发布了它。

![](https://cdn-images-1.medium.com/max/800/1*FXzo-qRHkPFTZ-hiQwb_gQ.gif)

Slidable 部件预览

这就是 **Slidable** 部件如何诞生的过程。 现在它需要一些发展。 如果您想要一些新功能，欢迎您在GitHub上创建一个 [issue](https://github.com/letsar/flutter_slidable/issues)  并解释您想要的内容。如果它与我对这个包的看法一致，我将很乐意实现它！

您可以在 [代码库](https://github.com/letsar/flutter_slidable)中找到一些文档，以及上面的[示例](https://github.com/letsar/flutter_slidable/blob/master/example/lib/main.dart)。

如果这个软件包对你有所帮助，你可以通过⭐️这个 [repo](https://github.com/letsar/flutter_slidable)，或者👏这个故事。你也可以在 [Twitter](https://twitter.com/lets4r)上关注我。

如果您使用此软件包构建应用程序，请告诉我 😃。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
