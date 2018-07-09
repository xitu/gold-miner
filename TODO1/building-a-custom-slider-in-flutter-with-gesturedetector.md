> * 原文地址：[Building a Custom Slider in Flutter with GestureDetector](https://medium.com/@rjstech/building-a-custom-slider-in-flutter-with-gesturedetector-fcdd76224acd)
> * 原文作者：[RJS Tech](https://medium.com/@rjstech/building-a-custom-slider-in-flutter-with-gesturedetector-fcdd76224acd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-custom-slider-in-flutter-with-gesturedetector.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-custom-slider-in-flutter-with-gesturedetector.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# 使用 Flutter 的 GestureDetector 构建自定义滑块

![](https://cdn-images-1.medium.com/max/1600/1*jIONll1unU_jcNHgv0C5qg.png)

Flutter 的一大优点是，可以轻松创建自定义 UI。在本教程中，我们将看到这一点。

首先，我们先停下来思考一下，需要构建什么内容。我们应该有一个滑块，并在其顶部显示填充的百分比。

在此之前，很明显我们需要维护一个窗口小控件，它显示一个已填充的给定百分比的进度条。在构建 UI 时，最好考虑一下这些控件，它们不具有任何状态，但会显示父级控件所提供的内容。

所以，让我们开始声明小控件

![](https://cdn-images-1.medium.com/max/1600/1*9QyxospGGYvnt0b_OLpE_A.png)

这个小控件非常简单，我们接收完成的百分比值，以及正面和背面部分的颜色。主 `Container` 将背面颜色作为背景，我们将绘制正面部分去覆盖它。它的子节点是 `Row`，虽然它只包含一个子节点，但我保留了它，方便你添加另一个 `Container`，它可以显示背面的部分或其中的一些信息（例如，剩余的百分比）。通过从 `Container` 的总宽度中取相同的百分比，计算并显示已完成百分比的 `Container` 的 `width`。

接下来，我们从主要的 App 类开始。

![](https://cdn-images-1.medium.com/max/1600/1*XCxELZi86mQkd8RxK6yMAQ.png)

显然，现在我们必须声明 `MyHomePage` 类，现在这个类应该能够使用我们上面编写的 `CustomSlider` 控件，并处理手势检测部分，其中用户可以拖动来增加和减少滑块显示的百分比。

![](https://cdn-images-1.medium.com/max/1600/1*pjjpL-46CNHxQaur3jOp4A.png)

这个控件必须是有状态的，因为要追踪其百分比。在这里，我们声明了控件的颜色，并将初始百分比保持为 0.0。另外还要注意，现在我们有一个显示舍入百分比的 `Text`，它与 `CustomSlider` 一起在屏幕上居中。

现在，请注意我们用 `GestureDetector` 控件包围住了 `CustomSlider` 控件。我们接下来的工作就是，给控件注入活力，使用 `GestureDetector` 控件来捕获用户的拖动事件。

让我们看看实现这部分的代码。

![](https://cdn-images-1.medium.com/max/1600/1*pNfLsEImWg3IT2Y8YZtQIw.png)

这是添加了拖动部分的完整代码。`GestureDetector` 控件加入了 `onPanStart`、`onPanUpdate` 和 `onPanEnd` 属性来处理拖动的手势。我希望这些命名，能表明各自的用途。

为了知道用户拖动了多少，我们存储了拖动开始的位置，每次用户移动他/她的手指时，都会在 `onPanUpdate` 方法中计算距离。接着将距离除以滑块的宽度 200。然后我们简单地将计算完的距离添加到百分比的位置，设置值为 0.0 到 100.0 之间。该值不会超过滑动块的边界，这对于百分比的值来说是自然而然的事情。

这里只给出一个我们自定义的滑块……请用这个来展示一下你做了什么改变吧。

[点击这里](https://pastebin.com/C2ZuRdM8) 获得不同可以复制/粘贴的代码版本。

*   [JavaScript](https://medium.com/tag/javascript?source=post)
*   [Flutter](https://medium.com/tag/flutter?source=post)
*   [Gesturedetector](https://medium.com/tag/gesturedetector?source=post)
*   [Apps](https://medium.com/tag/apps?source=post)
*   [Dart](https://medium.com/tag/dart?source=post)

喜欢你读的东西吗？给 RJS Tech 一点掌声。

从为之欢呼到起立鼓掌，拍手表示你是多么喜欢这篇文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
