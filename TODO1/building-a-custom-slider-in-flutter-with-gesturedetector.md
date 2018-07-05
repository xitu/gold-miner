> * 原文地址：[Building a Custom Slider in Flutter with GestureDetector](https://medium.com/@rjstech/building-a-custom-slider-in-flutter-with-gesturedetector-fcdd76224acd)
> * 原文作者：[RJS Tech](https://medium.com/@rjstech/building-a-custom-slider-in-flutter-with-gesturedetector-fcdd76224acd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-custom-slider-in-flutter-with-gesturedetector.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-custom-slider-in-flutter-with-gesturedetector.md)
> * 译者：
> * 校对者：

# Building a Custom Slider in Flutter with GestureDetector

![](https://cdn-images-1.medium.com/max/1600/1*jIONll1unU_jcNHgv0C5qg.png)

One of the great thing about Flutter is how easy it makes creating custom UI. In this tutorial we are going to see just that.

First of all, lets stop and think for moment about what we need to build. So, we should have a slider, and display the percentage filled at the top of it.

Before anything, its clear that we would need to maintain a widget which displays kind of a progress bar which shows a given percentage filled. When building an UI, its better to think out the widgets which are not going to have any state of their own but will display something according to what they were given by their parent.

So, lets declare the widget

![](https://cdn-images-1.medium.com/max/1600/1*9QyxospGGYvnt0b_OLpE_A.png)

This widget is quit simple, we take in the percentage completed and the colours for the positive and the negative parts, the main container takes the negative colour as its background as we are going to draw the positive part overlaying it. Its child is a `Row`, though it contains just one child, I have kept it so that you can add another `Container` which would show the negative part explicitly or show some information in it (for example, the remaining percentage ). The `width` of the `Container` showing the percentage completed is calculated as by taking the same percentage from the total width of the container.

Next, lets start with the main App class.

![](https://cdn-images-1.medium.com/max/1600/1*XCxELZi86mQkd8RxK6yMAQ.png)

Clearly, now we have to declare the `MyHomePage` class, now this class should be able to use the `CustomSlider` widget we wrote above and handle the gesture detection part, where the user drags to increase and decrease the percentage shown by the slider.

![](https://cdn-images-1.medium.com/max/1600/1*pjjpL-46CNHxQaur3jOp4A.png)

This has to be a stateful widget because we have to keep track of the percentage. Here we have declared the colors and kept the initial percentage to be 0.0. Also notice, now we have a `Text` displaying the rounded off percentage, which is centered on the screen along with our `CustomSlider`.

Now, notice we have surrounded the `CustomSlider` widget with a `GestureDetector` widget. Our next job is to breathe life into this and use the `GestureDetector` widget to catch the user’s drag events.

Let’s see the code to do just that.

![](https://cdn-images-1.medium.com/max/1600/1*pNfLsEImWg3IT2Y8YZtQIw.png)

This is again the full code with the drag part added. The `GestureDetector`widget takes in the `onPanStart`, `onPanUpdate` and he `onPanEnd` properties to handle drag gestures. I hope the names are self exclamatory on what they do.

To understand how much has been dragged, we store the position where the drag is starting from, and every time the user move his/her finger, a distance is calculated in the `onPanUpdate` function. The distance is then divided by 200, as it was our width for the slider. Then we simple add that to the percentage and clamp it from 0.0 to 100.0, which means the value wont be able to exceed these bounds, which are natural for a percentage value.

Just this would give you a custom slider… do play with this and show us what variations you made.

[Click Here](https://pastebin.com/C2ZuRdM8) to get a copy/paste friendly version of the code.

*   [JavaScript](https://medium.com/tag/javascript?source=post)
*   [Flutter](https://medium.com/tag/flutter?source=post)
*   [Gesturedetector](https://medium.com/tag/gesturedetector?source=post)
*   [Apps](https://medium.com/tag/apps?source=post)
*   [Dart](https://medium.com/tag/dart?source=post)

Like what you read? Give RJS Tech a round of applause.

From a quick cheer to a standing ovation, clap to show how much you enjoyed this story.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
