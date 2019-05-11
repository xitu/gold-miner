> * 原文地址：[Everything you need to know about Flutter page route transition](https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823)
> * 原文作者：[Divyanshu Bhargava](https://medium.com/@divyanshub024)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-flutter-page-route-transition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-flutter-page-route-transition.md)
> * 译者：
> * 校对者：

# Everything you need to know about Flutter page route transition

![](https://cdn-images-1.medium.com/max/3200/1*WAl2w_h9BRPm1HfhNJ6mSA.png)

We know how easy it is to navigate from one route to another in Flutter. We just need to do push and pop.

To push:

```
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondRoute()),
  );
```

To pop:

```
Navigator.pop(context);
```

**That’s it. BUT… It’s very boring, there is no animation at all** 😦 **.**

At [Winkl](http://bit.ly/2KNpLo4) when we started playing with animations we realized that page transition can really make your UI beautiful. If you want to have a slide transition like iOS you use **CupertinoPageRoute.** That’s it, nothing else.

```
Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Screen2()))
```

But for custom transition Flutter provides different [transition widgets](https://flutter.dev/docs/development/ui/widgets/animation). Let’s see how we can use them.

We know that **Navigator.push** takes two arguments **(BuildContext context, Route<T> route).** We can create our own custom page route with some transition animation. Let’s start with something simple like a slide transition.

### Slide Transition

We will extend the PageRouteBuilder and define the transitionsBuilder which will return SlideTransition widget. The SlideTransition widget takes the position of type **Animation<Offset>.** We will use **Tween<Offset>** to give begin and end offset.

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

We can now use **SlideRightRoute** instead of **MaterialPageRoute** like this**.**

```
Navigator.push(context, SlideRightRoute(page: Screen2()))
```

The result is…

![](https://cdn-images-1.medium.com/max/2000/1*3PohRvAFrLe0hBp23wHCWQ.gif)

Pretty easy, isn’t it? You can change the direction of the slide transition by changing the **offset**.

### Scale Transition

Scale Transition animates the scale of a transformed widget. You can also change how the animation comes in by changing the **curves** of **CurvedAnimation.** In the below example I have used **Curves.fastOutSlowIn.**

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

The result is…

![](https://cdn-images-1.medium.com/max/2000/1*eoE7viPQK-i_ENa59_Qocw.gif)

### Rotation Transition

Rotation transition animates the rotation of a widget. You can also provide **transitionDuration** to your **PageRouteBuilder**.

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

The result is…

![](https://cdn-images-1.medium.com/max/2000/1*0y_Q7enSbrwWB2zj9nazrw.gif)

### Size Transition

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

The result is…

![](https://cdn-images-1.medium.com/max/2000/1*xoqjWA0KN_tk2rmlD35pZQ.gif)

### Fade Transition

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

The result is…

![](https://cdn-images-1.medium.com/max/2000/1*WVzbhZapoLuCPQ508tF_HQ.gif)

**Great!!** We have seen all the basic transitions.

***

Now let’s do something more advance. What if we want to animate both the routes. The entering route(new page) and the exit route(old page). We can use the stack transition animations and apply it to both the routes. one example of this could be the slide in the new route and slide out the old route. This is my favourite transition animation ❤️. Let’s see how we can do it.

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

And use it like this.

```
Navigator.push(context,
    EnterExitRoute(exitPage: this, enterPage: Screen2()))
```

And the result is…

![](https://cdn-images-1.medium.com/max/2000/1*5PIKSynhS-fImK8WikmBSQ.gif)

***

We can also combine more than one transition to create something awesome like scale and rotate at the same time. First, there is a ScaleTransition, child of it is RotationTransition and it’s child is the page.

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

And the result is…

![](https://cdn-images-1.medium.com/max/2000/1*M3AL5EOXoLqnvnItBr7fzg.gif)

***

![](https://cdn-images-1.medium.com/max/2000/1*1yYzQI2L7cIuizL3KkyE5A.gif)

Great job guys! This is everything you need to know about the route transition animation in Flutter. Try to combine some transition and make something great. If you make something great, don’t forget to share it with me. All the source code is here on [GitHub repo](https://github.com/divyanshub024/Flutter-page-route-transition).

***

If you liked this article make sure to 👏 it below, and connect with me on [Twitter](https://twitter.com/divyanshub024), [Github](https://github.com/divyanshub024) and [LinkedIn](https://www.linkedin.com/in/divyanshub024/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
