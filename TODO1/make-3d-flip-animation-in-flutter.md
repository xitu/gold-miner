> * 原文地址：[Make 3D flip animation in Flutter](https://medium.com/flutter-community/make-3d-flip-animation-in-flutter-16c006bb3798)
> * 原文作者：[Hung HD](https://medium.com/@hunghdyb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/make-3d-flip-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/make-3d-flip-animation-in-flutter.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# 使用 Flutter 制作 3D 翻转动画

从 UI 挑战中学习 Flutter

作为我的第一篇[文章](https://github.com/xitu/gold-miner/blob/master/TODO1/make-shimmer-effect-in-flutter.md)的续篇，我将开始新的挑战。这个将比前一个（微光闪烁）复杂一点。我称之为翻转动画：

![](https://cdn-images-1.medium.com/max/800/1*vDimOOn9HYlJyX3bDqNFjA.gif)

这已经足够值得挑战了，不是吗？是的，我们将播放一个**可能**产生 3D 效果的动画。

### 它是如何运作的

乍一看，有个很简单的想法：我们有一堆面板，每个面板被分成两半，每一半可以围绕 X 轴旋转并显示下一个面板。

如何用代码实现呢？我把它分为了两个小任务：

*   将面板分割为两半
*   围绕 X 轴旋转一半面板

那么 Flutter 如何帮助我们呢？查看 Flutter 文档，我发现有两个组件非常适合完成任务：**ClipRect** 和 **Transform**。

### 实现

*   **将面板分割为两半：**

**ClipRect** 组件有一个 **clipper** 参数来定义裁剪矩形的大小和位置，但是文档建议另一种使用 **ClipRect** 的方法：将它与 **Align** 一起使用：

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

尝试一下：

![](https://cdn-images-1.medium.com/max/800/1*_yUrbREU8PQsXXXoLib9Zw.png)

就是这样。此外，**child** 可以让我们随心所欲设计动画的内容（无论如何是文本，还是图像）。

*   **围绕 X 轴旋转一半面板**

**Transform** 组件有一个 **transform** 参数，类型是 **Matrix4**，用于定义所应用的转换类型。**Matrix4** 暴露了一个名为 **rotationX()** 的工厂构造函数，看起来是我们需要用的，让我们尝试一下用在面板的上半部分：

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

尝试一下：

![](https://cdn-images-1.medium.com/max/800/1*hMlNgRDsy9ozpXsbCqWjCA.png)

什么！！！！它看起来像放缩效果，不是吗？

到底怎么回事呢？回答出这个问题是这个任务中最难的一点。我回看 Flutter 的文档、示例代码、文章……最后以[这篇](https://medium.com/flutter-io/perspective-on-flutter-6f832f4d912e)告终。其中指出，改变 **Matrix4** 的第 3 行和第 2 列的值，会改变其视角，并且会给变形带来 3D 效果：

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

再试一下：

![](https://cdn-images-1.medium.com/max/800/1*pazybBHLVUECQLmEJvcrDA.png)

不错。但是不如试一下神奇的数字 0.006？说实话，我不知道如何准确计算它，只是尝试选个我感觉很好的一些值。

剩下的就是为我们的组件添加动画。这里有一点点棘手。实际上，每个面板都有两面（正面和背面）的内容，但是在代码中实现它并不明智，因为一个时刻只能看到一面。我假设要创建一个面板向上翻转的动画，所以动画的结果是两个阶段（顺序），第一个是向上翻转下半部分以使动画显示下一个面板的下半部分，然后隐藏当前面板的下半部分，第二个是在同一方向翻转上半部分，以显示下一半的上半部分，同时隐藏当前的上半部分：

![](https://cdn-images-1.medium.com/max/800/1*K3qR8ucwG2x_cjHGGjCQ-A.gif)

这个动画实现的代码很长，在此处插入并不太好。你可以在本文底部的链接中找到它。这是我们的最终效果：

![](https://cdn-images-1.medium.com/max/800/1*f0t6EXlImJyjjos0Lebn6Q.gif)

真棒。我们刚刚用 Flutter 完成了另一个 UI 挑战。**熟能生巧**。我会继续寻找新的挑战，使用 Flutter 解决它，并与你分享结果。感谢阅读。

**P/S：透视变换出现了个小问题（会导致变换后的图像偏斜），我在 rotateX() 中使用一个非常小的值而不是零，可以暂时解决这个问题。**

> **完整代码：** [https://gist.github.com/hnvn/f1094fb4f6902078516cba78de9c868e](https://gist.github.com/hnvn/f1094fb4f6902078516cba78de9c868e)

> **我已将我的代码发布，包名为** [**flip_panel**](https://pub.dartlang.org/packages/flip_panel)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
