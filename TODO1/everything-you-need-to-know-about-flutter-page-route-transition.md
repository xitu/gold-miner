> * 原文地址：[Everything you need to know about Flutter page route transition](https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823)
> * 原文作者：[Divyanshu Bhargava](https://medium.com/@divyanshub024)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-flutter-page-route-transition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-flutter-page-route-transition.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Charlo-O](https://github.com/Charlo-O)

# 关于 Flutter 页面路由过渡动画，你所需要知道的一切

![](https://cdn-images-1.medium.com/max/3200/1*WAl2w_h9BRPm1HfhNJ6mSA.png)

在使用 Flutter 的时候，我们都知道从一个路由跳转到另一个这件事非常简单。我们只需要做 push 和 pop 的操作即可。

push 操作：

```
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondRoute()),
  );
```

pop 操作：

```
Navigator.pop(context);
```

**就这么简单。但是这样做，路由跳转就是无聊的页面切换，完全没有动画效果 😦**

当我们在 [Winkl](http://bit.ly/2KNpLo4) 开始第一次应用动画效果，我们意识到，页面跳转的过渡效果可以让你的用户交互界面变得很好看。如果你想要一个像 iOS 上那样的滑动页面切换，你可以用 **CupertinoPageRoute**。只有这个，没有其他的了。

```
Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Screen2()))
```

但是，对于用户自定义的过渡效果，Flutter 提供了不同的方案：[动画组件](https://flutter.dev/docs/development/ui/widgets/animation)。下面我们一起来看看如何应用它。

我们知道，**Navigator.push** 接受两个参数 **(BuildContext context, Route<T> route)**。我们可以使用一些过渡动画来创建自定义的页面路由跳转。我们先从一些简单的例子开始，比如滑动过渡。

### 滑动过渡

首先，我们要扩充类 PageRouteBuilder，然后定义 transitionsBuilder，它将返回滑动过渡组件。这个滑动过渡组件将使用类型 **Animation<Offset>** 的位置信息，我们将会使用 **Tween<Offset>** 来给出动画开始和结束的偏移量。

```
import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}
```

我们现在就可以像这样使用 **SlideRightRoute** ，代替了之前的 **MaterialPageRoute**。

```
Navigator.push(context, SlideRightRoute(page: Screen2()))
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*3PohRvAFrLe0hBp23wHCWQ.gif)

代码非常简单的对吧？你可以通过修改偏移量 **offset** 来改变滑动过渡的方向。

### 缩放过渡

缩放过渡会通过改变组件的大小来完成动画效果。你也可以通过修改 **CurvedAnimation** 的 **curves** 来改变动画。下面这个例子我使用的是 **Curves.fastOutSlowIn。**

```
import 'package:flutter/material.dart';

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),
        );
}
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*eoE7viPQK-i_ENa59_Qocw.gif)

### 旋转过渡

旋转过渡会以转动作为组件的动画。你也可以为你的 **PageRouteBuilder** 加入 **transitionDuration**。

```
import 'package:flutter/material.dart';

class RotationRoute extends PageRouteBuilder {
  final Widget page;
  RotationRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              RotationTransition(
                turns: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.linear,
                  ),
                ),
                child: child,
              ),
        );
}
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*0y_Q7enSbrwWB2zj9nazrw.gif)

### 大小过渡

```
import 'package:flutter/material.dart';

class SizeRoute extends PageRouteBuilder {
  final Widget page;
  SizeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Align(
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              ),
        );
}
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*xoqjWA0KN_tk2rmlD35pZQ.gif)

### 渐变过渡

```
import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*WVzbhZapoLuCPQ508tF_HQ.gif)

**棒棒哒！！** 现在我们学习过了所有基础的过渡效果。

***

现在我们来实践一些更高级的。如果在进入页面和离开页面这两个路由跳转的时候都想要动画该怎么做呢？我们可以使用堆栈过渡动画（stack transition animations），并应用于这两个路由跳转上。一个例子就是滑入新页面，然后划出旧页面。这是我最喜欢的过渡动画了 ❤️。我们来看看代码是如何实现的。

```
import 'package:flutter/material.dart';

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
                children: <Widget>[
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: exitPage,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: enterPage,
                  )
                ],
              ),
        );
}
```

然后如下这样来使用 EnterExitRoute：

```
Navigator.push(context,
    EnterExitRoute(exitPage: this, enterPage: Screen2()))
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*5PIKSynhS-fImK8WikmBSQ.gif)

***

我们也可以将多个过渡效果结合在一起，创建出很多神奇的效果，比如同时应用缩放和旋转。首先，创建 ScaleTransition，它的 child 属性包括了 RotationTransition，而 RotationTransition 的 child 属性则是要显示动画的页面。

```
import 'package:flutter/material.dart';

class ScaleRotateRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRotateRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: RotationTransition(
                  turns: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.linear,
                    ),
                  ),
                  child: child,
                ),
              ),
        );
}
```

代码运行的效果是...

![](https://cdn-images-1.medium.com/max/2000/1*M3AL5EOXoLqnvnItBr7fzg.gif)

***

![](https://cdn-images-1.medium.com/max/2000/1*1yYzQI2L7cIuizL3KkyE5A.gif)

棒极了！这些就是关于 Flutter 页面路由过渡动画，你所需要知道的一切。亲自试着将不同的过渡效果结合起来，创造出一些很棒的动画吧，并且别忘了和我分享你的成果。所有代码的源码可见：[GitHub 仓库](https://github.com/divyanshub024/Flutter-page-route-transition)。

***

如果你喜欢本篇文章那就请点个赞吧，并且可以在 [Twitter](https://twitter.com/divyanshub024)，[Github](https://github.com/divyanshub024) 和 [LinkedIn](https://www.linkedin.com/in/divyanshub024/) 联系我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
