> * 原文地址：[Make 3D flip animation in Flutter](https://medium.com/flutter-community/make-3d-flip-animation-in-flutter-16c006bb3798)
> * 原文作者：[Hung HD](https://medium.com/@hunghdyb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/make-3d-flip-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/make-3d-flip-animation-in-flutter.md)
> * 译者：
> * 校对者：

# Make 3D flip animation in Flutter

Learn Flutter from UI challenges

As a continuation of my first [article](https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md), I am going to take a new challenge. This one will be a bit more complex than the previous (the shimmer). I call it a flip animation:

![](https://cdn-images-1.medium.com/max/800/1*vDimOOn9HYlJyX3bDqNFjA.gif)

It’s good enough for a challenge, isn’t it? Yep, we are going to play with an animation running a _likely_ 3-D effect.

### How it works

At a first glance, the idea is simple: we have a stack of panels, each is broken into 2 halves, each half can rotate around X-axis and reveal a next one.

How to do it in code? I am going to divide it into 2 tasks:

*   Cut a panel into 2 halves
*   Rotate a half of panel around X-axis

So how does Flutter support us? Looking into Flutter document, I found two Widgets fit for our tasks: **ClipRect** and **Transform**.

### Implementation

*   _Cut a panel into 2 halves:_

**ClipRect** widget has a **clipper** parameter to define the size and location of the clip rect but its document also suggests another way to use **ClipRect**, by combining it with an **Align**:

```
class FlipWidget extends StatelessWidget {
  Widget child;

  FlipWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
            child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: child,
        )),
        Padding(
          padding: EdgeInsets.only(top: 2.0),
        ),
        ClipRect(
            child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.5,
          child: child,
        )),
      ],
    );
  }
}
```

Try it out:

![](https://cdn-images-1.medium.com/max/800/1*_yUrbREU8PQsXXXoLib9Zw.png)

That’s it. Additionally, the **child** lets us freely design the content of our animation (a text, an image, no matter).

*   _Rotate a half of panel around X-axis:_

**Transform** widget has a **transform** parameter of type **Matrix4** to define the kind of transform applied and **Matrix4** exposes a factory constructor called **rotationX()**, it looks like what we need, let try it for the upper half of panel:

```
@override
Widget build(BuildContext context) {
   return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          transform: Matrix4.rotationX(pi / 4),
          alignment: Alignment.bottomCenter,
          child: ClipRect(
              child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: child,
          )),
        ),
        ...
      ],
    );
  }
```

Try it out:

![](https://cdn-images-1.medium.com/max/800/1*hMlNgRDsy9ozpXsbCqWjCA.png)

What!!!! It looks like a scale effect, doesn’t it?

What’s wrong? Answer this question is the hardest point of this challenge. I turn to Flutter document, example codes, articles… and end up with [this one](https://medium.com/flutter-io/perspective-on-flutter-6f832f4d912e). It points out that changing value at row 3 and column 2 of **Matrix4** will change its perspective and bring up 3-D effect into our transformation:

```
...
Transform(
  transform: Matrix4.identity()..setEntry(3, 2, 0.006)..rotateX(pi / 4),
  alignment: Alignment.bottomCenter,
  child: ClipRect(
      child: Align(
    alignment: Alignment.topCenter,
    heightFactor: 0.5,
    child: child,
  )),
),
...
```

Try it out:

![](https://cdn-images-1.medium.com/max/800/1*pazybBHLVUECQLmEJvcrDA.png)

Cool. But what about the magic number of 0.006? To be honest, I don’t know how to calculate it exactly, just try some values and pick one I feel good.

The rest is to add animation for our widget. It needs a bit tricky here. In fact, each panel has content on both sides (front and back) but it’s silly to make it in code because there’s only one side visible at a moment. I assume we are going to create an animation that panels flip upward, so our animation turns out to be two phases (sequentially), the first is to flip the lower half upward to make the animation of revealing the lower half of a next panel while hiding the lower half of current panel, the second is to flip the upper half in the same direction to reveal the upper half of the next while hiding the upper half of the current:

![](https://cdn-images-1.medium.com/max/800/1*K3qR8ucwG2x_cjHGGjCQ-A.gif)

The implementation code of this animation is quite long, it’s not a good idea to embed it here. You can find it in the link I put at the bottom of this article. Here’s our final result:

![](https://cdn-images-1.medium.com/max/800/1*f0t6EXlImJyjjos0Lebn6Q.gif)

Awesome. We have just finished another UI challenge with Flutter. _The more you practice, the better you become_. I will keep looking new challenges, solve it with Flutter and share the results with you. Thanks for reading.

_P/S: There’s something wrong in the perspective transform (causes the transformed image skewed), I use a very small value instead of zero for rotateX() to temporarily get around this matter._

> _Full source code:_ [https://gist.github.com/hnvn/f1094fb4f6902078516cba78de9c868e](https://gist.github.com/hnvn/f1094fb4f6902078516cba78de9c868e)

> _I’ve published my code as a package called_ [_flip_panel_](https://pub.dartlang.org/packages/flip_panel)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
