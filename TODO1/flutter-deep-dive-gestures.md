> * 原文地址：[Flutter Deep Dive: Gestures](https://medium.com/flutter-community/flutter-deep-dive-gestures-c16203b3434f)
> * 原文作者：[Nash](https://medium.com/@Nash0x7E2?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：[HaoChuan9421](https://github.com/HaoChuan9421)

# 深入 Flutter 之手势

![](https://cdn-images-1.medium.com/max/800/1*05K_qs3P3_1bBTGhXUYSOA.png)

Flutter 提供了一些非常棒的预制组件，用于处理触摸事件，如 `in InkWell` 和 `InkResponse`。用这些组件包裹住你的组件，它们就能够响应触摸事件了。除此之外，它还会向你的组件添加 Material 风格的飞溅效果。例如，当从组件的边界延伸出来时，`InkResponse` 可以选择控制飞溅的形状和剪裁效果。有趣的是 `InkWell` 和 `InkResponse` 不会做任何渲染，而是更新父级的 *Material* 组件。一个常见的例子是图片。如果用 `inkEll` 将图片包裹起来，你会注意到纹波并不可见。这是因为它是在 Material 上的图片后面绘制的。想让 `Ink` 飞溅效果可见，可以用 `Ink.Image` 包裹住图片。虽然这对大多数任务来说很有用，但如果你想捕获更多事件，例如当用户拖动屏幕时，则应该使用 `GestureDetector`。

### 那么什么是手势探测器？它是如何工作的？

简单来说手势检测器是一个无状态组件，其构造函数中的参数可用于不同的触摸事件。值得注意的是，你不能同时使用 `Pan` 和 `Scale`，因为 `Scale` 是 `Pan` 的一个超集。`GestureDetector` 纯粹用于检测手势，因此不会给出任何视觉反应（不存在 _Material Ink_ 传播）。

下面是一张表格，展示了 `GestureDetector` 提供的不同回调以及对应的简短描述：

| 属性/回调                | 描述                                 |
| ------------------------ | ------------------------------------ |
| `onTapDown`              | 每次用户与屏幕联系时都会触发 `OnTapDown`。 |
| `onTapUp`                | 当用户停止触摸屏幕时，`onTapUp` 被调用。 |
| `onTap`                  | 当短暂触摸屏幕时，`onTap` 被触发。 |
| `onTapCancel`            | 当用户触摸屏幕但未完成 `Tap` 时，将触发此事件。 |
| `onDoubleTap`            | 当屏幕被快速连续触摸两次时调用 `onDoubleTap`。 |
| `onLongPress`            | 用户触摸屏幕超过 _500毫秒_ 时，`onLongPress` 被触发。 |
| `onVerticalDragDown`     | 当指针与屏幕接触并开始沿垂直方向移动时，`onVerticalDown` 被调用。 |
| `onVerticalDragStart`    | 当指针 _开始_ 沿垂直方向移动时调用 `onVerticalDragStart`。 |
| `onVerticalDragUpdate`   | 每次指针在屏幕上的位置发生变化时都会调用此方法。 |
| `onVerticalDragEnd`      | 当用户停止移动时，拖动被认为是完成的，将调用此事件。 |
| `onVerticalDragCancel`   | 当用户突然停止拖动时调用。 |
| `onHorizontalDragDown`   | 当用户/指针与屏幕接触并开始水平移动时调用。 |
| `onHorizontalDragStart`  | 用户/指针已与屏幕接触并 _开始_ 沿水平方向移动。 |
| `onHorizontalDragUpdate` | 每次指针在水平方向/x轴上的位置发生变化时调用。 |
| `onHorizontalDragEnd`    | 在水平拖动结束时，将调用此事件。 |
| `onHorizontalDragCancel` | 当指针未成功触发 `onHorizontalDragDown` 时调用。 |
| `onPanDown`              | 当指针与屏幕接触时调用。 |
| `onPanStart`             | 指针事件开始移动时，`onPanStart` 触发。 |
| `onPanUpdate`            | 每次指针改变位置时，调用 `onPanUpdate`。 |
| `onPanEnd`               | 平移完成后，将调用此事件。 |
| `onScaleStart`           | 当指针与屏幕接触并建立 1.0 的焦点时，将调用此事件。 |
| `onScaleUpdate`          | 与屏幕接触的指针指示了新的焦点。 |
| `onScaleEnd`             | 当指针不再与指示手势结束的屏幕接触时调用。 |

`GestureDetector` 会根据哪个回调非空来决定尝试识别哪些手势。这很有用，因为如果你需要禁用手势，则需要传入 **_null_**。

**让我们以** `**onTap**` **手势为例，确定如何处理** `**GestureDetector**`**。**

首先，我们使用 `onTap` 回调创建一个 GestureDetector，因为是非 null，当发生 tap 事件时 `GestureDetector` 会使用我们的回调。在 `GestureDetector` 内部，创建了一个 **Gesture Factory** 。`Gesture Recognizer` 会做大量工作来确定正在处理什么手势。这个过程对于 `GestureDetector` 提供的所有回调来说是相同的。`GestureFactories` 随后会被传递到 `RawGestureDetector`。

`RawGestureDetector` 会为检测手势做大量工作。它是一个 **有状态组件** ，当状态改变时会同步所有手势，处理识别器，获取发生的所有 _指针事件_ 并将其发送到注册的识别器。然后它们将在 **手势竞技场** 中一决雌雄。

`RawGestureDetectorbuild` 构建方法由一个 用于监听指针事件的基类 `Listener` 组成。如果你想使用来自平台的原始输入，如向上，向下或取消事件，这是你的首选类。`Listener` 不会给你任何手势，只有基本的 `onPointerDown`，`onPointerUp`，`onPointerMove` 和 `onPointerCancel` 事件。一切都必须手动处理，包括向 **手势竞技场** 报告自己。如果不这样做，那么你不会获得自动取消，也无法参与那里发生的交互。这是 **组件端** 的最底层。

`Listener` 是一个 `SingleChildRenderObjectWidget`，由继承自 `RenderProxyBoxWithHitTestBehavior` 的类 `RenderPointerListener` 组成的，这意味着它会模仿其子类的属性，同时允许自定义 `HitTestBehavior`。如果你想了解渲染盒及其运作方式的更多信息，请阅读 [Norbert Kozsir](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208) 撰写的这篇文章。

`HitTestBehaviour` 有三个选项，`deferToChild`，`opaque` 和 `translucent`。这些来自 `GestureDetector`，且可以在其中进行配置。`DeferToChild` 将事件沿着组件树向下传递，这也是 _默认行为_ 。`Opaque` 会防止后台组件接收事件，而 `Translucent` 则允许后台组件接收事件。

### 那么如果你希望父组件和子组件都接收指针事件呢？

让我们暂时想象一下你有一个嵌套列表的情况，你想要同时滚动它们。为此，你需要父组件和子组件都接收到指针。你配置命中测试行为，使其是半透明的，确保两个组件都接收到事件，但事情却不按计划进行...为什么？

上述问题的答案就是 `GestureArena`。

![](https://cdn-images-1.medium.com/max/800/1*-gE5KrWqiCw3sIJRuFkqZw.gif)

`GestureArena` 被用于 [手势消歧](https://flutter.io/gestures/#gesture-disambiguation) 。所有识别器都会在这里一决雌雄并发送出去。在屏幕上的任何给定点处，可以存在多个手势识别器。竞技场会考虑用户触摸屏幕的时长，斜率以及拖动方向来确定胜利者。

父列表和子列表都会将其识别器发送到竞技场，但（在撰写本文时）只有一个会赢，而且它恰好总是子列表。

修复方法是使用 `GestureFactory` 的同时使用 `RawGestureDetector` 来改变竞技场的表现。

举个例子，让我们创建一个由两个容器组成的简单应用程序。目标是让子容器和父容器都接收到手势。

用 `RawGestureDetector` 将两个容器都包裹起来。接下来，我们将创建一个自定义手势识别器 `AllowMultipleGestureRecognizer`。`GestureRecognizer` 是所有其他识别器继承的基类。它为类提供基础 API ，以便它们能够与手势识别器一起工作/交互。值得注意的是，`GestureRecognizer` 并不关心识别器本身的具体细节。

```
// 自定义手势识别器。
// 重写 rejectGesture()。当一个手势被拒绝时，将调用此函数。默认情况下，它会处理
// 识别器并进行清理。但是我们修改了它，它实际上是手动添加的，以代替识别器被处理。
// 结果是你将有两个识别器在竞技场中获胜。这是双赢。

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

在上面的代码中，我们正在创建一个继承自 `TapGestureRecognizer` 的自定义类 `AllowMultipleGestureRecognizer`。这意味着它能够继承 `TapGestureRecognizer`。在这个例子中，我们重写了 `rejectGesture`，使之不是处理识别器，而是手动接受。

现在我们将 `GestureRecognizerFactoryWithHandlers` 中的自定义手势识别器传递给 `RawGestureDetector`。

```
Widget build(BuildContext context) {
   return RawGestureDetector(
     gestures: {
       AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          AllowMultipleGestureRecognizer>(
         () => AllowMultipleGestureRecognizer(), //构造函数
         (AllowMultipleGestureRecognizer instance) { //初始化器
           instance.onTap = () => print('Episode 4 is best! (parent container) ');
         },
       )
     },
```

现在我们将 `GestureRecognizerFactoryWithHandlers` 中的自定义手势识别器传递给 `RawGestureDetector`。工厂函数需要两个属性，构造函数和初始化器，用于构造和初始化手势识别器。我们使用 lambda 传递这些参数。如上面的代码所述，构造函数返回 `AllowMultipleGestureRecognizer` 的一个新实例，而初始化器则获取用于监听 tap 并将一些文本打印到控制台的属性 `instance`。两个容器将重复这一过程，唯一的区别是打印的文本。

以下是示例应用的完整源码：

```
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//主函数。 Flutter 应用的入口
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: DemoApp(),
      ),
    ),
  );
}

//   简单的演示应用程序，由两个容器组成。目标是允许多个手势进入竞技场。
//  所有的东西都是通过 `RawGestureDetector` 和自定义 `GestureRecognizer` （继承自 `TapGestureRecognizer` ）
//  将自定义 GestureRecognizer，`AllowMultipleGestureRecognizer` 添加到手势列表中，并创建一个 `AllowMultipleGestureRecognizer` 类型的 `GestureRecognizerFactoryWithHandlers`。
//  它用给定的回调创建一个手势识别器工厂函数，在这里是 `onTap`。
//  它监听 `onTap` 的一个实例，然后在被调用时向控制台打印文本。需要注意的是，`RawGestureDetector` 对于两个容器
//  是相同的。唯一的区别是打印的文本（用来标识组件）。

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            AllowMultipleGestureRecognizer>(
          () => AllowMultipleGestureRecognizer(),
          (AllowMultipleGestureRecognizer instance) {
            instance.onTap = () => print('Episode 4 is best! (parent container) ');
          },
        )
      },
      behavior: HitTestBehavior.opaque,
      //父容器
      child: Container(
        color: Colors.blueAccent,
        child: Center(
          //用 RawGestureDetector 将两个容器包裹起来
          child: RawGestureDetector(
            gestures: {
              AllowMultipleGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      AllowMultipleGestureRecognizer>(
                () => AllowMultipleGestureRecognizer(),  //构造函数
                (AllowMultipleGestureRecognizer instance) {  //初始化器
                  instance.onTap = () => print('Episode 8 is best! (nested container)');
                },
              )
            },
            //在第一个容器中创建嵌套容器。
            child: Container(
               color: Colors.yellowAccent,
               width: 300.0,
               height: 400.0,
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义手势识别器。
// 重写 rejectGesture()。当一个手势被拒绝时，将调用此函数。默认情况下，它会处理
// 识别器并进行清理。但是我们修改了它，它实际上是手动添加的，以代替识别器被处理。
// 结果是你将有两个识别器在竞技场中获胜。这是双赢。
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

### 那么运行上面代码的结果是什么？

当你点击黄色容器时，两个组件都会收到 tap 事件，因此有两条语句打印到控制台。

应用程序：

![](https://cdn-images-1.medium.com/max/800/1*4c3RQrrqk4jKW-ELLb71JQ.png)

控制台输出：

![](https://cdn-images-1.medium.com/max/800/1*eEqe1QJzuxkYMExszi9_kA.png)

### 你赢的时候会发生什么？

一个手势获胜后，竞技场将处于 `closed` 和 `swept` 状态。这将丢弃未使用的识别器并重置竞技场。然后由胜利手势执行动作。

回到我们的 _Tap_ 示例，在此之后，映射到 `onTap` 的函数现在将被执行。

### 总结

今天我们了解了 Flutter 框架如何处理手势。我们首先了解了 Flutter 为处理 taps 和其他触摸事件提供的梦幻般的预制组件。接下来，我们讨论了 `GestureDetector` 并实验了其内部工作方式。通过使用示例，我们了解了 Flutter 如何处理 Tap 手势。我们穿过了 `RawGestureDetector` 这片土地，聆听了 `Listener` 的声音，并向名为 `GestureArena` 的神秘的 Flutter 搏击俱乐部致敬。

最后，我们从应用程序的角度介绍了 Flutter 中的大部分手势系统。有了这些知识，你现在应该对如何获取屏幕上的触摸并在幕后进行处理有了更好地理解。如果你有任何问题或疑虑，请随时发表评论或通过 [Twitterverse](https://twitter.com/Nash0x7E2?lang=en) 与我联系。

同样 **非常** 感谢[Simon Lightfoot](https://twitter.com/devangelslondon)（又名“Flutter Whisperer”）对本文的贡献❤

* [Nash](http://nash0x7E2.github.io)

![](https://cdn-images-1.medium.com/max/800/1*P9yFVC0hMkKGBe0ZMpYWCA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
