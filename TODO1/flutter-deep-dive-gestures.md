> * 原文地址：[Flutter Deep Dive: Gestures](https://medium.com/flutter-community/flutter-deep-dive-gestures-c16203b3434f)
> * 原文作者：[Nash](https://medium.com/@Nash0x7E2?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# Flutter Deep Dive: Gestures
# Flutter深入：手势

![](https://cdn-images-1.medium.com/max/800/1*05K_qs3P3_1bBTGhXUYSOA.png)

Flutter provides some really amazing widgets out of the box which comes pre-built for handling touch events such as in `InkWell` and `InkResponse`. These widgets wrap your widgets so that they are able to respond to touch events. In addition to doing this, it also adds the Material Ink splash to your widget. `InkResponse`, for example, has options to control the shape and clipping of the splash as it extends out of the widget's boundary. An interesting thing to note is `InkWell` and `InkResponse` don't do any rendering, instead they update the parent _Material_ widget. A common example of this is an image. If you wrap an image in an `inkWell`, you would notice that the ripple is not visible. This is because it is drawn behind the image on the _Material_. To make the `Ink` splash visible, wrap your image using `Ink.Image`. While useful for most tasks, if you want to capture more events, such as when a user drags across the screen, one should use `GestureDetector`.
Flutter提供了一些非常棒的预制组件，用于处理触摸事件，如 `in InkWell` 和 `InkResponse` 。用这些组件包裹住你的组件，它们就能够响应触摸事件了。除此之外，它还会向你的组件添加Material风格的飞溅效果。例如，当从组件的边界延伸出来时， `InkResponse` 可以选择控制飞溅的形状和剪裁效果。有趣的是 `InkWell` 和 `InkResponse` 不会做任何渲染，而是更新父级的 *Material* 组件。一个常见的例子是图片。如果用 `inkEll` 将图片包裹起来，你会注意到纹波并不可见。这是因为它在 *Material* 上的绘制处于图片后面。想让 `Ink` 飞溅效果可见，可以用 `Ink.Image` 包裹住图片。虽然这对大多数任务来说很有用，但如果你想捕获更多事件，例如当用户拖动屏幕时，则应该使用 `GestureDetector`。

### So what is the Gesture Detector? How does it work?
### 那么什么是手势探测器？它是如何工作的？

The basic overview of gesture detector is a stateless widget which has parameters in its constructor for different touch events. It is worth noting that you cannot use `Pan` and `Scale` together since `Scale` is a superset of `Pan`. `GestureDetector` is used purely for detecting gestures and thus does not give any visual response (the _Material Ink_ propagation is absent).
简单来说手势检测器是一个无状态组件，其构造函数中的参数可用于不同的触摸事件。值得注意的是，你不能同时使用 `Pan` 和 `Scale` ，因为 `Scale` 是 `Pan` 的一个超集。 `GestureDetector` 纯粹用于检测手势，因此不会给出任何视觉反应（不存在 _Material Ink_ 传播）。

Here is a table to show the different callbacks `GestureDetector`provides and a short description of what they do:
下面是一张表格，展示了 `GestureDetector`` 提供的不同回调以及对应的简短描述：

| Property/Callback        | Description                          |
| 属性/回调                | 描述                                 |
| ------------------------ | ------------------------------------ |
| ------------------------ | ------------------------------------ |
| `onTapDown`              | `OnTapDown` is fired everytime the user makes contact with the screen. |
| `onTapDown`              | 每次用户与屏幕联系时都会触发 `OnTapDown` 。 |
| `onTapUp`                | When the user stops touching the screen, `onTapUp` is called. |
| `onTapUp`                | 当用户停止触摸屏幕时， `onTapUp` 被调用。 |
| `onTap`                  | When the screen is briefly touched, `onTap`  is triggered. |
| `onTap`                  | 当短暂触摸屏幕时， `onTap` 被触发。 |
| `onTapCancel`            | When a user touches the screen but does not complete the `Tap`, this event is fired. |
| `onTapCancel`            | 当用户触摸屏幕但未完成 `Tap` 时，将触发此事件。 |
| `onDoubleTap`            | `onDoubleTap` is called when the screen is touched twice in quick succession. |
| `onDoubleTap`            | 当屏幕被快速连续触摸两次时调用 `onDoubleTap` 。 |
| `onLongPress`            | The the user touches the screen for longer than _500 milliseconds_, `onLongPress` is fired. |
| `onLongPress`            | 用户触摸屏幕超过 _500毫秒_ 时， `onLongPress` 被触发。 |
| `onVerticalDragDown`     | When a pointer comes into contact with the screen and begin to move in a vertical direction, `onVerticalDown` is called. |
| `onVerticalDragDown`     | 当指针与屏幕接触并开始沿垂直方向移动时， `onVerticalDown` 被调用。 |
| `onVerticalDragStart`    | `onVerticalDragStart` is called when the pointer _starts_ moving in a vertical direction. |
| `onVerticalDragStart`    | 当指针 _开始_ 沿垂直方向移动时调用 `onVerticalDragStart` 。 |
| `onVerticalDragUpdate`   | This is called every time there is a change in the position of the pointer on the screen. |
| `onVerticalDragUpdate`   | 每次指针在屏幕上的位置发生变化时都会调用此方法。 |
| `onVerticalDragEnd`      | When the user stops moving, the drag is considered complete and this event is called. |
| `onVerticalDragEnd`      | 当用户停止移动时，拖动被认为是完成的，将调用此事件。 |
| `onVerticalDragCancel`   | Called when the user abruptly stops dragging. |
| `onVerticalDragCancel`   | 当用户突然停止拖动时调用。 |
| `onHorizontalDragDown`   | Called when the user/pointer comes into contact with the screen and begin to move horizontally. |
| `onHorizontalDragDown`   | 当用户/指针与屏幕接触并开始水平移动时调用。 |
| `onHorizontalDragStart`  | The user/pointer has made contact with the screen and _started_ moving in a horizontal direction. |
| `onHorizontalDragStart`  | 用户/指针已与屏幕接触并 _开始_ 沿水平方向移动。 |
| `onHorizontalDragUpdate` | Called every time there is a change in the location of the pointer on the horizontal/x-axis. |
| `onHorizontalDragUpdate` | 每次指针在水平方向/x轴上的位置发生变化时调用。 |
| `onHorizontalDragEnd`    | At the end of a horizontal drag, this event is called. |
| `onHorizontalDragEnd`    | 在水平拖动结束时，将调用此事件。 |
| `onHorizontalDragCancel` | Called when the pointer which triggered `onHorizontalDragDown` did not complete successfully. |
| `onHorizontalDragCancel` | 当触发 `onHorizontalDragDown` 的指针未成功完成时调用。 |
| `onPanDown`              | Called when a pointer comes into contact with the screen. |
| `onPanDown`              | 当指针与屏幕接触时调用。 |
| `onPanStart`             | `onPanStart` is fired when the pointer event begins to move. |
| `onPanStart`             | 指针事件开始移动时， `onPanStart` 触发。 |
| `onPanUpdate`            | `onPanUpdate` is called everytime the pointer changes location. |
| `onPanUpdate`            | 每次指针改变位置时，调用 `onPanUpdate` 。 |
| `onPanEnd`               | When the pan is complete, this event is called. |
| `onPanEnd`               | 平移完成后，将调用此事件。 |
| `onScaleStart`           | When a pointer comes in contact with the screen and establishes a focal point of 1.0, this event is called. |
| `onScaleStart`           | 当指针与屏幕接触并建立1.0的焦点时，将调用此事件。 |
| `onScaleUpdate`          | The pointer which is in contact with the screen have indicated a new focal point. |
| `onScaleUpdate`          | 与屏幕接触的指针指示了新的焦点。 |
| `onScaleEnd`             | Called when the pointer is no longer in contact with the screen signalling the end of the gesture. |
| `onScaleEnd`             | 当指针不再与指示手势结束的屏幕接触时调用。 |

`GestureDetector` decides which gestures to attempt to recognize based on which of its callbacks are non-null. This is useful since if you need to _disable_ a gesture, you would pass **_null_**.
 `GestureDetector` 会根据哪个回调非空来决定尝试识别哪些手势。这很有用，因为如果你需要禁用手势，则需要传入 **_null_** 。

**Let’s use the** `**onTap**` **gesture as an example and determine how this is processed by the** `**GestureDetector**`**.**
**让我们以** `onTap` **手势为例，确定如何处理** `GestureDetector`**。**

First of all, we create a GestureDetector with an `onTap` callback, since this is non-null the `GestureDetector` will use our callback when tap events occur. Inside of `GestureDetector`, a **Gesture Factory** is created. `Gesture Recognizer` does the hard work of determining what gesture is being handled. This process is the same for all of the different callbacks `GestureDetector` provides. The `GestureFactories` are then passed on to the `RawGestureDetector`.
 首先，我们使用 `onTap` 回调创建一个GestureDetector，因为是非null，当发生tap事件时 `GestureDetector` 会使用我们的回调。在 `GestureDetector` 内部，创建了一个 **Gesture Factory** 。 `Gesture Recognizer` 会做大量工作来确定正在处理什么手势。这个过程对于 `GestureDetector` 提供的所有回调来说是相同的。 `GestureFactories` 随后会被传递到 `RawGestureDetector` 。

`RawGestureDetector` does the hard work of detecting the gestures. It is a **stateful widget** which syncs all gestures when the state changes, disposes of the recognizers, takes all the _pointer events_ that occur and sends it to the recognizers registered. They then battle it out in **Gesture Arena**.
  `RawGestureDetector` 会为检测手势做大量工作。它是一个 **有状态组件** ，当状态改变时会同步所有手势，处理识别器，获取发生的所有 _指针事件_ 并将其发送到注册的识别器。然后它们将在 **手势竞技场** 中一决雌雄。

`RawGestureDetector` build method consists of a `Listener` which is the base class for listening to pointer events. If you would like to use raw inputs like up, down or cancel events which come from the platform, this is your go-to class. `Listener` does not give you any gestures, only the basic `onPointerDown`, `onPointerUp`, `onPointerMove` and `onPointerCancel` events. Everything must be handled manually, including reporting yourself to the **Gesture Arena**. If you don't, then you don't get cancelled automatically and would not be able to partake in the interactions which occur there. This is the lowest level on the **widget side.**
  `RawGestureDetectorbuild` 构建方法由一个 用于监听指针事件的基类 `Listener` 组成。如果你想使用来自平台的原始输入，如向上，向下或取消事件，这是你的首选课程。 `Listener` 不会给你任何手势，只有基本的 `onPointerDown`， `onPointerUp` ， `onPointerMove` 和 `onPointerCancel` 事件。一切都必须手动处理，包括向 **手势竞技场** 报告自己。如果不这样做，那么你不会获得自动取消，也无法参与那里发生的交互。这是 **组件端** 的最底层。

`Listener` is a `SingleChildRenderObjectWidget` which consist of the class `RenderPointerListener` which extends `RenderProxyBoxWithHitTestBehavior`, meaning it mimics the properties of its children while allowing `HitTestBehavior` to be customized. If you would like to learn more about Render Boxes and how they operate, you should check out this article by [Norbert Kozsir](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208).
  `Listener` 是一个 `SingleChildRenderObjectWidget` ，由继承自 `RenderProxyBoxWithHitTestBehavior` 的类 `RenderPointerListener` 组成的，这意味着它会模仿其子类的属性，同时允许自定义 `HitTestBehavior` 。如果你想了解渲染盒及其运作方式的更多信息，请阅读[Norbert Kozsir](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208)撰写的这篇文章。

`HitTestBehaviour` has three options, `deferToChild`, `opaque` and `translucent`. These come from and are configured in `GestureDetector`. `DeferToChild` passes the event down the widget tree and is the _default behaviour_. `Opaque` prevents widgets that are in the background from receiving the events and `Translucent` allows for the background widget to receive the event.
 `HitTestBehaviour` 有三个选项，`deferToChild`， `opaque` 和 `translucent` 。这些来自 `GestureDetector` ，且可以在其中进行配置。 `DeferToChild` 将事件沿着组件树向下传递，这也是 _默认行为_ 。 `Opaque` 会防止后台组件接收事件，而 `Translucent` 则允许后台组件接收事件。

### So what if you wanted both the parent and the child to receive the pointer events?
### 那么如果你希望父组件和子组件都接收指针事件呢？

Let’s for a minute imagine a situation where you had a nested list and you wanted to scroll both at the same time. For this, you would need the pointer to be received by both the parent and the child. You configure the hit test behaviour so that it is translucent, ensuring that both widgets are receiving the events but things don’t go according to plan…why is that?
 让我们暂时想象一下你有一个嵌套列表的情况，你想要同时滚动它们。为此，你需要父组件和子组件都接收到指针。你配置命中测试行为，使其是半透明的，确保两个组件都接收到事件，但事情却不按计划进行...为什么？

Well, the answer to the above question would be `GestureArena`.
上述问题的答案就是 `GestureArena` 。

`GestureArena` is used in [**gesture disambiguation**](https://flutter.io/gestures/#gesture-disambiguation). All recognizer are sent here where they battle it out. At any given point on the screen, there can be multiple gesture recognizers. Arena takes into account the length of time the user touches the screen, the slop as well as the direction a user drags to determine a winner.
  `GestureArena` 被用于[手势消歧](https://flutter.io/gestures/#gesture-disambiguation)。所有识别器都会在这里一决雌雄并发送出去。在屏幕上的任何给定点处，可以存在多个手势识别器。竞技场会考虑用户触摸屏幕的时长，斜率以及拖动方向来确定胜利者。

Both the parent list and the child list would have their recognizers sent to the arena but (at the time of writing this) only one will win and it always happens to be the child.
 父列表和子列表都会将其识别器发送到竞技场，但（在撰写本文时）只有一个会赢，而且它恰好总是子列表。

The fix would be to use a `RawGestureDetector` with your own `GestureFactory`'s which change the behaviour of how the arena performs.
 修复方法是使用 `GestureFactory` 的同时使用 `RawGestureDetector` 来改变竞技场的表现。

As an example, let’s create a simple app which consists of two containers. The goal would be to have both the child and parent receive the gesture.
 举个例子，让我们创建一个由两个容器组成的简单应用程序。目标是让子容器和父容器都接收到手势。

Both will be wrapped in a `RawGestureDetector`. Next, we are going to create a custom gesture recognizer, `AllowMultipleGestureRecognizer`. `GestureRecognizer` is the base class on which all other recognizers inherits from. It provides the basic API for classes so that they are able to work/interact with gesture recognizers. It is worth noting that `GestureRecognizer` doesn’t care about the specific details of the recognizers themselves.
 用 `RawGestureDetector` 将两个容器都包裹起来。接下来，我们将创建一个自定义手势识别器 `AllowMultipleGestureRecognizer` 。 `GestureRecognizer` 是所有其他识别器继承的基类。它为类提供基础API，以便它们能够与手势识别器一起工作/交互。值得注意的是， `GestureRecognizer` 并不关心识别器本身的具体细节。

```
// Custom Gesture Recognizer.
// 自定义手势识别器。
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// 重写rejectGesture()。当一个手势被拒绝时，将调用此函数。默认情况下，它会处理
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// 识别器并进行清理。但是我们修改了它，它实际上是手动添加的，以代替识别器被处理。
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
// 结果是你将有两个识别器在竞技场中获胜。这是双赢。

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

In the above code, we are creating a custom class `AllowMultipleGestureRecognizer` which extends `TapGestureRecognizer`. This means it is able to inherit the class of `TapGestureRecognizer`. In this example, we are overriding `rejectGesture` such that instead of disposing of the recognizers, it is being manually accepted.
在上面的代码中，我们正在创建一个继承自 `TapGestureRecognizer` 的自定义类 `AllowMultipleGestureRecognizer` 。这意味着它能够继承 `TapGestureRecognizer` 。在这个例子中，我们重写了 `rejectGesture` ，使之不是处理识别器，而是手动接受。

Now we pass our custom gesture-recognizer in a `GestureRecognizerFactoryWithHandlers` to the `RawGestureDetector`.
现在我们将 `GestureRecognizerFactoryWithHandlers` 中的自定义手势识别器传递给 `RawGestureDetector` 。

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

Now we pass our custom gesture-recognizer in a `GestureRecognizerFactoryWithHandlers` to the `RawGestureDetector`. The factory requires two properties, a constructor and an initializer for constructing and initializing the gesture recognizer. We use a lambda for passing these parameters. As described in the above code, the constructor returns a new instance of `AllowMultipleGestureRecognizer` while the initializer takes the property `instance` which is used to listen for a tap and print some text to the console. This is going to be repeated for both containers, with the only difference being the text that is printed.
现在我们将 `GestureRecognizerFactoryWithHandlers` 中的自定义手势识别器传递给 `RawGestureDetector` 。工厂函数需要两个属性，构造函数和初始化器，用于构造和初始化手势识别器。我们使用lambda传递这些参数。如上面的代码所述，构造函数返回 `AllowMultipleGestureRecognizer` 的一个新实例，而初始化器则获取用于监听tap并将一些文本打印到控制台的属性 `instance` 。两个容器将重复这一过程，唯一的区别是打印的文本。

Here is the full source code to the sample app:
以下是示例应用的完整源码：

```
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//主函数。Flutter应用的入口
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: DemoApp(),
      ),
    ),
  );
}

//   Simple demo app which consists of two containers. The goal is to allow multiple gestures into the arena.
//   简单的演示应用程序，由两个容器组成。目标是允许多个手势进入竞技场。
//  Everything is handled manually with the use of `RawGestureDetector` and a custom `GestureRecognizer`(It extends `TapGestureRecognizer`).
//  所有的东西都是通过 `RawGestureDetector` 和自定义 `GestureRecognizer` （继承自 `TapGestureRecognizer` ）
//  The custom GestureRecognizer, `AllowMultipleGestureRecognizer` is added to the gesture list and creates a `GestureRecognizerFactoryWithHandlers` of type `AllowMultipleGestureRecognizer`.
//  将自定义GestureRecognizer，`AllowMultipleGestureRecognizer` 添加到手势列表中，并创建一个 `AllowMultipleGestureRecognizer` 类型的 `GestureRecognizerFactoryWithHandlers` 。
//  It creates a gesture recognizer factory with the given callbacks, in this case, an `onTap`.
//  它用给定的回调创建一个手势识别器工厂函数，在这里是 `onTap` 。
//  It listens for an instance of `onTap` then prints text to the console when it is called. Note that the `RawGestureDetector` code is the same for both
//  它监听 `onTap` 的一个实例，然后在被调用时向控制台打印文本。需要注意的是， `RawGestureDetector` 对于两个容器
//  containers. The only difference being the text that is printed(Used as a way to identify the widget) 
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
          //用RawGestureDetector将两个容器包裹起来
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

// Custom Gesture Recognizer.
// 自定义手势识别器。
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// 重写rejectGesture()。当一个手势被拒绝时，将调用此函数。默认情况下，它会处理
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// 识别器并进行清理。但是我们修改了它，它实际上是手动添加的，以代替识别器被处理。
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
// 结果是你将有两个识别器在竞技场中获胜。这是双赢。
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

### So what is the result of running the above code?
### 那么运行上面代码的结果是什么？

As you tap the yellow container, both widgets receive the tap and thus there are two statements printed to the console.
当你点击黄色容器时，两个组件都会收到tap事件，因此有两条语句打印到控制台。

The app:
应用程序：

![](https://cdn-images-1.medium.com/max/800/1*4c3RQrrqk4jKW-ELLb71JQ.png)

Console output:
控制台输出：

![](https://cdn-images-1.medium.com/max/800/1*eEqe1QJzuxkYMExszi9_kA.png)

### What Happens When You Win?
### 你赢的时候会发生什么？

After a gesture wins, the arena is `closed` and `swept`. This disposes of the unused recognizers and resets the arena. The winning gesture then performs an action.
一个手势获胜后，竞技场将处于 `closed` 和 `swept` 状态。这将丢弃未使用的识别器并重置竞技场。然后由胜利手势执行动作。

Bringing it back to our _Tap_ example, after this occurs, the function mapped to `onTap` would now be executed.
回到我们的 _Tap_ 示例，在此之后，映射到 `onTap` 的函数现在将被执行。

### Summation
### 总结

Today we looked at how the Flutter framework handles gestures. We started off by looking at the fantastic pre-built widgets Flutter provides for handling taps and other touch events. Next, we moved on to `GestureDetector` and examined the way in which it works internally. Through the use of an example, we followed how a Tap gesture is processed by Flutter. We journeyed through the land of `RawGestureDetector`, took in the sounds of `Listener` and admired the secret Flutter fight club known as `GestureArena`.
今天我们了解了Flutter框架如何处理手势。我们首先了解了Flutter为处理taps和其他触摸事件提供的梦幻般的预制组件。接下来，我们讨论了 `GestureDetector` 并实验了其内部工作方式。通过使用示例，我们了解了Flutter如何处理Tap手势。我们穿过了 `RawGestureDetector` 这片土地，聆听了 `Listener` 的声音，并向名为 `GestureArena` 的神秘的Flutter搏击俱乐部致敬。

In closing, we covered the majority of the gesture system in Flutter from the perspective of an application. With this knowledge, you should now have a better understanding of a touch on the screen is picked up and worked on behind the scenes. If you have any questions or concerns, please feel free to leave a comment or reach out to me on [Twitterverse](https://twitter.com/Nash0x7E2?lang=en).
最后，我们从应用程序的角度介绍了Flutter中的大部分手势系统。有了这些知识，你现在应该对如何获取屏幕上的触摸并在幕后进行处理有了更好地理解。如果你有任何问题或疑虑，请随时发表评论或通过[Twitterverse](https://twitter.com/Nash0x7E2?lang=en)与我联系。

Also **_huge_** thanks to [Simon Lightfoot](https://twitter.com/devangelslondon)(aka the “Flutter Whisperer”) for contributing to this article ❤
同样 **_非常_** 感谢[Simon Lightfoot](https://twitter.com/devangelslondon)（又名“Flutter Whisperer”）对本文的贡献❤

* [Nash](http://nash0x7E2.github.io)
* [纳什](http://nash0x7e2.github.io/)

![](https://cdn-images-1.medium.com/max/800/1*P9yFVC0hMkKGBe0ZMpYWCA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
