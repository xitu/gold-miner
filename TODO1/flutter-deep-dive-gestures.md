> * 原文地址：[Flutter Deep Dive: Gestures](https://medium.com/flutter-community/flutter-deep-dive-gestures-c16203b3434f)
> * 原文作者：[Nash](https://medium.com/@Nash0x7E2?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-deep-dive-gestures.md)
> * 译者：
> * 校对者：

# Flutter Deep Dive: Gestures

![](https://cdn-images-1.medium.com/max/800/1*05K_qs3P3_1bBTGhXUYSOA.png)

Flutter provides some really amazing widgets out of the box which comes pre-built for handling touch events such as in `InkWell` and `InkResponse`. These widgets wrap your widgets so that they are able to respond to touch events. In addition to doing this, it also adds the Material Ink splash to your widget. `InkResponse`, for example, has options to control the shape and clipping of the splash as it extends out of the widget's boundary. An interesting thing to note is `InkWell` and `InkResponse` don't do any rendering, instead they update the parent _Material_ widget. A common example of this is an image. If you wrap an image in an `inkWell`, you would notice that the ripple is not visible. This is because it is drawn behind the image on the _Material_. To make the `Ink` splash visible, wrap your image using `Ink.Image`. While useful for most tasks, if you want to capture more events, such as when a user drags across the screen, one should use `GestureDetector`.

### So what is the Gesture Detector? How does it work?

The basic overview of gesture detector is a stateless widget which has parameters in its constructor for different touch events. It is worth noting that you cannot use `Pan` and `Scale` together since `Scale` is a superset of `Pan`. `GestureDetector` is used purely for detecting gestures and thus does not give any visual response (the _Material Ink_ propagation is absent).

Here is a table to show the different callbacks `GestureDetector`provides and a short description of what they do:

| Property/Callback        | Description                          |
| ------------------------ | ------------------------------------ |
| `onTapDown`              | `OnTapDown` is fired everytime the user makes contact with the screen. |
| `onTapUp`                | When the user stops touching the screen, `onTapUp` is called. |
| `onTap`                  | When the screen is briefly touched, `onTap`  is triggered. |
| `onTapCancel`            | When a user touches the screen but does not complete the `Tap`, this event is fired. |
| `onDoubleTap`            | `onDoubleTap` is called when the screen is touched twice in quick succession. |
| `onLongPress`            | The the user touches the screen for longer than _500 milliseconds_, `onLongPress` is fired. |
| `onVerticalDragDown`     | When a pointer comes into contact with the screen and begin to move in a vertical direction, `onVerticalDown` is called. |
| `onVerticalDragStart`    | `onVerticalDragStart` is called when the pointer _starts_ moving in a vertical direction. |
| `onVerticalDragUpdate`   | This is called every time there is a change in the position of the pointer on the screen. |
| `onVerticalDragEnd`      | When the user stops moving, the drag is considered complete and this event is called. |
| `onVerticalDragCancel`   | Called when the user abruptly stops dragging. |
| `onHorizontalDragDown`   | Called when the user/pointer comes into contact with the screen and begin to move horizontally. |
| `onHorizontalDragStart`  | The user/pointer has made contact with the screen and _started_ moving in a horizontal direction. |
| `onHorizontalDragUpdate` | Called every time there is a change in the location of the pointer on the horizontal/x-axis. |
| `onHorizontalDragEnd`    | At the end of a horizontal drag, this event is called. |
| `onHorizontalDragCancel` | Called when the pointer which triggered `onHorizontalDragDown` did not complete successfully. |
| `onPanDown`              | Called when a pointer comes into contact with the screen. |
| `onPanStart`             | `onPanStart` is fired when the pointer event begins to move. |
| `onPanUpdate`            | `onPanUpdate` is called everytime the pointer changes location. |
| `onPanEnd`               | When the pan is complete, this event is called. |
| `onScaleStart`           | When a pointer comes in contact with the screen and establishes a focal point of 1.0, this event is called. |
| `onScaleUpdate`          | The pointer which is in contact with the screen have indicated a new focal point. |
| `onScaleEnd`             | Called when the pointer is no longer in contact with the screen signalling the end of the gesture. |

`GestureDetector` decides which gestures to attempt to recognize based on which of its callbacks are non-null. This is useful since if you need to _disable_ a gesture, you would pass **_null_**.

**Let’s use the** `**onTap**` **gesture as an example and determine how this is processed by the** `**GestureDetector**`**.**

First of all, we create a GestureDetector with an `onTap` callback, since this is non-null the `GestureDetector` will use our callback when tap events occur. Inside of `GestureDetector`, a **Gesture Factory** is created. `Gesture Recognizer` does the hard work of determining what gesture is being handled. This process is the same for all of the different callbacks `GestureDetector` provides. The `GestureFactories` are then passed on to the `RawGestureDetector`.

`RawGestureDetector` does the hard work of detecting the gestures. It is a **stateful widget** which syncs all gestures when the state changes, disposes of the recognizers, takes all the _pointer events_ that occur and sends it to the recognizers registered. They then battle it out in **Gesture Arena**.

`RawGestureDetector` build method consists of a `Listener` which is the base class for listening to pointer events. If you would like to use raw inputs like up, down or cancel events which come from the platform, this is your go-to class. `Listener` does not give you any gestures, only the basic `onPointerDown`, `onPointerUp`, `onPointerMove` and `onPointerCancel` events. Everything must be handled manually, including reporting yourself to the **Gesture Arena**. If you don't, then you don't get cancelled automatically and would not be able to partake in the interactions which occur there. This is the lowest level on the **widget side.**

`Listener` is a `SingleChildRenderObjectWidget` which consist of the class `RenderPointerListener` which extends `RenderProxyBoxWithHitTestBehavior`, meaning it mimics the properties of its children while allowing `HitTestBehavior` to be customized. If you would like to learn more about Render Boxes and how they operate, you should check out this article by [Norbert Kozsir](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208).

`HitTestBehaviour` has three options, `deferToChild`, `opaque` and `translucent`. These come from and are configured in `GestureDetector`. `DeferToChild` passes the event down the widget tree and is the _default behaviour_. `Opaque` prevents widgets that are in the background from receiving the events and `Translucent` allows for the background widget to receive the event.

### So what if you wanted both the parent and the child to receive the pointer events?

Let’s for a minute imagine a situation where you had a nested list and you wanted to scroll both at the same time. For this, you would need the pointer to be received by both the parent and the child. You configure the hit test behaviour so that it is translucent, ensuring that both widgets are receiving the events but things don’t go according to plan…why is that?

Well, the answer to the above question would be `GestureArena`.

![](https://cdn-images-1.medium.com/max/800/1*-gE5KrWqiCw3sIJRuFkqZw.gif)

`GestureArena` is used in [**gesture disambiguation**](https://flutter.io/gestures/#gesture-disambiguation). All recognizer are sent here where they battle it out. At any given point on the screen, there can be multiple gesture recognizers. Arena takes into account the length of time the user touches the screen, the slop as well as the direction a user drags to determine a winner.

Both the parent list and the child list would have their recognizers sent to the arena but (at the time of writing this) only one will win and it always happens to be the child.

The fix would be to use a `RawGestureDetector` with your own `GestureFactory`'s which change the behaviour of how the arena performs.

As an example, let’s create a simple app which consists of two containers. The goal would be to have both the child and parent receive the gesture.

Both will be wrapped in a `RawGestureDetector`. Next, we are going to create a custom gesture recognizer, `AllowMultipleGestureRecognizer`. `GestureRecognizer` is the base class on which all other recognizers inherits from. It provides the basic API for classes so that they are able to work/interact with gesture recognizers. It is worth noting that `GestureRecognizer` doesn’t care about the specific details of the recognizers themselves.

```
// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

In the above code, we are creating a custom class `AllowMultipleGestureRecognizer` which extends `TapGestureRecognizer`. This means it is able to inherit the class of `TapGestureRecognizer`. In this example, we are overriding `rejectGesture` such that instead of disposing of the recognizers, it is being manually accepted.

Now we pass our custom gesture-recognizer in a `GestureRecognizerFactoryWithHandlers` to the `RawGestureDetector`.

```
Widget build(BuildContext context) {
   return RawGestureDetector(
     gestures: {
       AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          AllowMultipleGestureRecognizer>(
         () => AllowMultipleGestureRecognizer(), //constructor
         (AllowMultipleGestureRecognizer instance) { //initializer
           instance.onTap = () => print('Episode 4 is best! (parent container) ');
         },
       )
     },
```

Now we pass our custom gesture-recognizer in a `GestureRecognizerFactoryWithHandlers` to the `RawGestureDetector`. The factory requires two properties, a constructor and an initializer for constructing and initializing the gesture recognizer. We use a lambda for passing these parameters. As described in the above code, the constructor returns a new instance of `AllowMultipleGestureRecognizer` while the initializer takes the property `instance` which is used to listen for a tap and print some text to the console. This is going to be repeated for both containers, with the only difference being the text that is printed.

Here is the full source code to the sample app:

```
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//Main function. The entry point for your Flutter app.
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
//  Everything is handled manually with the use of `RawGestureDetector` and a custom `GestureRecognizer`(It extends `TapGestureRecognizer`).
//  The custom GestureRecognizer, `AllowMultipleGestureRecognizer` is added to the gesture list and creates a `GestureRecognizerFactoryWithHandlers` of type `AllowMultipleGestureRecognizer`.
//  It creates a gesture recognizer factory with the given callbacks, in this case, an `onTap`.
//  It listens for an instance of `onTap` then prints text to the console when it is called. Note that the `RawGestureDetector` code is the same for both
//  containers. The only difference being the text that is printed(Used as a way to identify the widget) 

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
      //Parent Container
      child: Container(
        color: Colors.blueAccent,
        child: Center(
          //Wraps the second container in RawGestureDetector
          child: RawGestureDetector(
            gestures: {
              AllowMultipleGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      AllowMultipleGestureRecognizer>(
                () => AllowMultipleGestureRecognizer(),  //constructor
                (AllowMultipleGestureRecognizer instance) {  //initializer
                  instance.onTap = () => print('Episode 8 is best! (nested container)');
                },
              )
            },
            //Creates the nested container within the first.
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
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
```

### So what is the result of running the above code?

As you tap the yellow container, both widgets receive the tap and thus there are two statements printed to the console.

The app:

![](https://cdn-images-1.medium.com/max/800/1*4c3RQrrqk4jKW-ELLb71JQ.png)

Console output:

![](https://cdn-images-1.medium.com/max/800/1*eEqe1QJzuxkYMExszi9_kA.png)

### What Happens When You Win?

After a gesture wins, the arena is `closed` and `swept`. This disposes of the unused recognizers and resets the arena. The winning gesture then performs an action.

Bringing it back to our _Tap_ example, after this occurs, the function mapped to `onTap` would now be executed.

### Summation

Today we looked at how the Flutter framework handles gestures. We started off by looking at the fantastic pre-built widgets Flutter provides for handling taps and other touch events. Next, we moved on to `GestureDetector` and examined the way in which it works internally. Through the use of an example, we followed how a Tap gesture is processed by Flutter. We journeyed through the land of `RawGestureDetector`, took in the sounds of `Listener` and admired the secret Flutter fight club known as `GestureArena`.

In closing, we covered the majority of the gesture system in Flutter from the perspective of an application. With this knowledge, you should now have a better understanding of a touch on the screen is picked up and worked on behind the scenes. If you have any questions or concerns, please feel free to leave a comment or reach out to me on [Twitterverse](https://twitter.com/Nash0x7E2?lang=en).

Also **_huge_** thanks to [Simon Lightfoot](https://twitter.com/devangelslondon)(aka the “Flutter Whisperer”) for contributing to this article ❤

* [Nash](http://nash0x7E2.github.io)

![](https://cdn-images-1.medium.com/max/800/1*P9yFVC0hMkKGBe0ZMpYWCA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
