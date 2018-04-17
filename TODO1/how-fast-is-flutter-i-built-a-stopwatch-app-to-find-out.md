> * 原文地址：[How fast is Flutter? I built a stopwatch app to find out.](https://medium.freecodecamp.org/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out-9956fa0e40bd)
> * 原文作者：[Andrea Bizzotto](https://medium.freecodecamp.org/@biz84?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out.md)
> * 译者：
> * 校对者：

# How fast is Flutter? I built a stopwatch app to find out.

![](https://cdn-images-1.medium.com/max/2000/1*270WC2lY8lFF6jfPpca0WQ.jpeg)

Image Credit: [Petar Petkovski](https://unsplash.com/@petkovski)

This weekend I had some time to play with the new [Flutter](https://flutter.io/) UI framework by Google.

On paper it sounds great!

*   [Hot reloading](https://flutter.io/hot-reload/)? Yes, please.
*   Declarative [state-driven](https://flutter.io/tutorials/interactive/) UI programming? I’m all in!

According [to the docs](https://flutter.io/faq/#what-kind-of-app-performance-can-i-expect), high performance is to be expected:

> Flutter is designed to help developers easily achieve a constant 60fps.

But what about CPU utilization?

**TL;DR**: Not as good as native. And you have to do it right:

*   Frequent UI redraws are expensive
*   If you call `setState()` often, make sure it redraws as little UI as possible.

I built a simple stopwatch app in Flutter and profiled it to analyze CPU and memory usage.

![](https://cdn-images-1.medium.com/max/800/1*Bo0l0BjIRcInHZo2ACvjsA.png)

**Left**: iOS stopwatch app. **Right**: My version in Flutter. Beautiful, ain’t it?

### Implementation

The UI is driven by two objects: a [stopwatch](https://docs.flutter.io/flutter/dart-core/Stopwatch-class.html) and a [timer](https://docs.flutter.io/flutter/dart-async/Timer-class.html).

*   The user can start, stop and reset the stopwatch by tapping on two buttons.
*   Each time the stopwatch is started, a periodic timer is created with a callback that fires every 30ms and updates the UI.

The main UI is built like this:

```
class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Stopwatch stopwatch = new Stopwatch();

  void leftButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        print("${stopwatch.elapsedMilliseconds}");
      } else {
        stopwatch.reset();
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      } else {
        stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle = const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
      child: new Text(text, style: roundTextStyle),
      onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(height: 200.0, 
          child: new Center(
            child: new TimerText(stopwatch: stopwatch),
        )),
        new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildFloatingButton(stopwatch.isRunning ? "lap" : "reset", leftButtonPressed),
            buildFloatingButton(stopwatch.isRunning ? "stop" : "start", rightButtonPressed),
        ]),
      ],
    );
  }
}
```

How does this work?

*   Two buttons manage the state of the stopwatch object.
*   When the stopwatch is updated, `setState()` is called, triggering the `build()` method.
*   As part of the `build()` method, a new `TimerText` is created.

The `TimerText` class looks like this:

```
class TimerText extends StatefulWidget {
  TimerText({this.stopwatch});
  final Stopwatch stopwatch;

  TimerTextState createState() => new TimerTextState(stopwatch: stopwatch);
}

class TimerTextState extends State<TimerText> {

  Timer timer;
  final Stopwatch stopwatch;

  TimerTextState({this.stopwatch}) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }
  
  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    String formattedTime = TimerTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(formattedTime, style: timerTextStyle);
  }
}
```

A couple of notes:

*   The timer is created along with the `TimerTextState` object. Each time the callback fires, `setState()` is called **if the stopwatch is running**.
*   This causes the `build()` method to be called, which draws a new `Text` object with the updated time.

### Doing it right

When I first built this app, I was managing all the state and UI in the `TimerPage` class, which included both the stopwatch and the timer.

This meant that each time the timer callback was fired, the entire UI was re-built. This is redundant and inefficient: only the `Text` object containing the elapsed time should be redrawn — especially as the timer fires every 30ms.

This becomes apparent if we consider the un-optimised and optimised widget tree hierarchies:

![](https://cdn-images-1.medium.com/max/800/1*YrJV5E7jWzr3K0kjPBs1Mg.png)

Creating a separate `TimerText` class to encapsulate the timer logic is less CPU-intensive.

In other words:

*   Frequent UI redraws are expensive
*   If you call `setState()` often, make sure that it redraws as little UI as possible.

The Flutter docs state that the platform is optimised for [fast allocation](https://flutter.io/faq/#why-did-flutter-choose-to-use-dart):

> The Flutter framework uses a functional-style flow that depends heavily on the underlying memory allocator efficiently handling small, short-lived allocations

Perhaps rebuilding a widget tree doesn’t count as “small, short-lived allocation”. In practice, my code optimisations resulted in a lower CPU and memory usage (see below).

#### Update 19–03–2018

Since publishing this article, some Google engineers took notice and kindly contributed with some further optimisations.

The updated code further reduces UI redrawing by splitting `TimerText` into two `MinutesAndSeconds` and `Hundredths` widgets:

![](https://cdn-images-1.medium.com/max/800/1*NQxSNVJDSnZnC3DohLBTAA.png)

Further UI optimisations (credit: Google).

These register themselves as listeners to the timer callback, and only redraw when their state changes. This further optimises performance as only the `Hundredths` widget now renders every 30ms.

### Benchmarking results

I ran the app in release mode (`flutter run --release`):

*   Device: **iPhone 6** running **iOS 11.2**
*   Flutter version: [0.1.5](https://github.com/flutter/flutter/releases/tag/v0.1.5) (22 Feb 2018).
*   Xcode 9.2

I monitored CPU and memory usage in Xcode for three minutes, and measured the performance of the three different modes.

#### Non optimized code

*   CPU Usage: 28%
*   Memory usage: 32 MB (from a baseline of 17 MB after app start)

![](https://cdn-images-1.medium.com/max/800/1*F1GR6mVtVEwRjaJptEuEwQ.png)

#### Optimization pass 1 (separate timer text widget)

*   CPU Usage: 25%
*   Memory usage: 25 MB (from a baseline of 17 MB after app start)

![](https://cdn-images-1.medium.com/max/800/1*dTO3vThMfGx0LYrLqAIlAQ.png)

#### Optimization pass 2 (separate minutes, seconds, hundredths)

*   CPU Usage: 15% to 25%
*   Memory usage: 26 MB (from a baseline of 17 MB after app start)

![](https://cdn-images-1.medium.com/max/800/1*JFnMDRT8utbB9C4ETPklOg.png)

On this last test, the CPU usage graph tracks closely the GPU thread, while the UI thread stays fairly constant.

**NOTE**: running the same benchmark in [**slow mode**](https://flutter.io/faq/#my-app-has-a-slow-mode-bannerribbon-in-the-upper-right-why-am-i-seeing-that) yields CPU usage over 50%, and **memory usage increasing steadily** over time.

This may point to memory not being deallocated in development mode.

Key takeaway: **make sure to profile your apps in release mode**.

Note that Xcode reports a **very high** energy impact when CPU usage is over 20%.

### Digging deeper

The results got me thinking. A timer which fires ~30 times per second and re-renders a text label should not use up to 25% of a [dual core 1.4GHz CPU](https://en.wikipedia.org/wiki/Apple_A8).

The widget tree in a Flutter app is built with a **declarative paradigm**, rather than the **imperative** programming model used in iOS / Android.

But is the imperative model more performant?

To find out, I have built the same stopwatch app on iOS.

This is the Swift code to setup a timer and update a text label every 30ms:

```
startDate = Date()

Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
    
    let elapsed = Date().timeIntervalSince(self.startDate)
    let hundreds = Int((elapsed - trunc(elapsed)) * 100.0)
    let seconds = Int(trunc(elapsed)) % 60
    let minutes = seconds / 60
    let hundredsStr = String(format: "%02d", hundreds)
    let secondsStr = String(format: "%02d", seconds)
    let minutesStr = String(format: "%02d", minutes)
    self.timerLabel.text = "\(minutesStr):\(secondsStr).\(hundredsStr)"
}
```

For completeness, here is the time formatting code I used in Dart (optimization pass 1):

```
class TimerTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr"; 
  }
}
```

The final results?

**Flutter.** CPU: 25%, Memory: 22 MB

**iOS.** CPU: 7%, Memory: 8 MB

The Flutter implementation is over 3x heavier on CPU, and uses 3x as much memory.

When the timer is not running, CPU usage goes back to 1%. This confirms that all CPU work goes into handling the timer callbacks and redrawing the UI.

This is not entirely surprising.

*   In the Flutter app, I build and render a new `Text` widget every time.
*   On iOS, I just update the text of a `UILabel`.

“Hey!” — I hear you saying. “But the time formatting code is different! How do you know that the difference in CPU usage is not due to this?”

Well then, let’s modify both examples to do no formatting at all:

Swift:

```
startDate = Date()

Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
    
    let elapsed = Date().timeIntervalSince(self.startDate)
    self.timerLabel.text = "\(elapsed)"
}
```

Dart:

```
class TimerTextFormatter {
  static String format(int milliseconds) {
    return "$milliseconds"; 
  }
}
```

Updated results:

**Flutter.** CPU: 15%, Memory: 22 MB

**iOS.** CPU: 8%, Memory: 8 MB

The Flutter implementation is still twice as CPU-intensive. Additionally, it seems to do quite a bit of stuff on multiple threads (GPU, I/O work). On iOS, only one thread is active.

### Conclusion

I have compared the performance of Flutter/Dart vs iOS/Swift on a very specific use case.

The numbers don’t lie. When it comes to frequent UI updates, **you can’t have your cake and eat it, too**. 🎂

Flutter lets developers create apps for both iOS and Android with the same codebase. And features such as hot reloading further accelerate productivity. Flutter is still in its early days. I hope that Google and the community can improve the runtime profile, so that these benefits are carried over to the end-users.

As for your apps, consider fine-tuning your code to minimize UI redraws. It is well worth the effort.

I have added all the code for this project on [this GitHub repo](https://github.com/bizz84/stopwatch-flutter), so you can play with it yourself.

You’re welcome! 😊

This sample project was my first experiment with Flutter. If you know how to write more performant code, I’d love to hear your comments.

**About me:** I’m a freelance iOS developer, juggling between contract work, open source, side projects and blogging.

I’m [@biz84](https://twitter.com/biz84) on Twitter. You can also see my [GitHub](https://github.com/bizz84) page. Feedback, tweets, funny gifs, all welcome! My favorite? Lots of 👏👏👏. Oh, and banana bread.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
