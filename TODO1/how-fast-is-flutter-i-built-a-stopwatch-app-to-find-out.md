> * 原文地址：[How fast is Flutter? I built a stopwatch app to find out.](https://medium.freecodecamp.org/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out-9956fa0e40bd)
> * 原文作者：[Andrea Bizzotto](https://medium.freecodecamp.org/@biz84?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[swants](https://github.com/swants)、[talisk](https://github.com/talisk)

# Flutter 到底有多快？我开发了秒表应用来弄清楚。

![](https://cdn-images-1.medium.com/max/2000/1*270WC2lY8lFF6jfPpca0WQ.jpeg)

图片来源: [Petar Petkovski](https://unsplash.com/@petkovski)

这个周末，我花了点时间去用由谷歌新开发的 UI 框架 [Flutter](https://flutter.io/)。

从理论上讲，它听起来非常棒！

*   [热加载](https://flutter.io/hot-reload/)？是的，请。
*   声明式[状态驱动](https://flutter.io/tutorials/interactive/) UI 编程？我全押在这上面了！

根据[文档](https://flutter.io/faq/#what-kind-of-app-performance-can-i-expect)，高性能是预料之中的：

> Flutter 旨在帮助开发者轻松地实现恒定的 60 fps。

但是 CPU 利用率如何？

**太长了读不下去，直接看评论**：不如原生好。你必须正确地做到：

*   频繁地重绘用户界面代价是很高的。
*   如果你经常调用 `setState()` 方法，请确保尽可能少地重新绘制用户界面。

我用 Flutter 框架开发了一个简单的秒表应用程序，并分析了 CPU 和内存的使用情况。

![](https://cdn-images-1.medium.com/max/800/1*Bo0l0BjIRcInHZo2ACvjsA.png)

**图左**：iOS 秒表应用。 **图右**：用 Flutter 的版本。很漂亮吧？

### 实现

UI 界面是由两个对象驱动的: [秒表](https://docs.flutter.io/flutter/dart-core/Stopwatch-class.html)和[定时器](https://docs.flutter.io/flutter/dart-async/Timer-class.html)。

*   用户可以通过点击这两个按钮来启动、停止和重置秒表。
*   每当秒表开始计时时，都会创建一个周期性定时器，每 30 毫秒回调一次，并更新 UI 界面。

主界面是这样建立的：

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

这是如何运作的呢？

*   两个按钮分别管理秒表对象的状态。
*   当秒表更新时，`setState()` 会被调用，然后触发 `build()` 方法。
*   作为 `build()` 方法的一部分, 一个新的 `TimerText` 会被创建。

`TimerText` 类看起来是这样的：

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

一些注意事项：

*   定时器由 `TimerTextState` 对象所创建。每次触发回调后，**如果秒表在运行**，就会调用 `setState()` 方法。
*   这会调用 `build()` 方法，并在更新的时候绘制一个新的 `Text` 对象。

### 正确使用

当我一开始开发这个 App 时，我管理了 `TimerPage` 类中对全部状态以及 UI 界面，其中包括了秒表和定时器。

这就意味着每次触发定时器的回调时，会重新构建整个 UI 界面。这是不必要且低效的：只有包含了过去时间的 `Text` 对象需要重新绘制 —— 特别是当每 30 毫秒计时器触发一次时。

如果我们考虑到未优化和已优化的部件树层次结构，这一点就变得更显而易见了：

![](https://cdn-images-1.medium.com/max/800/1*YrJV5E7jWzr3K0kjPBs1Mg.png)

创建一个独立的的 `TimerText` 类来封装定时器的逻辑，可以降低 CPU 负担。

换句话说：

*   频繁地重绘 UI 用户界面代价很高。
*   如果经常调用 `setState()` 方法，确保尽可能少地重新绘制 UI 用户界面。

Flutter 官方文档指出该平台对[快速分配](https://flutter.io/faq/#why-did-flutter-choose-to-use-dart)进行了优化：

> Flutter 框架使用了一种功能式流程，这种流程很大程度上取决于内存分配器是否有效地处理了小型，短期的分配工作。

也许重建一棵部件树不能算作“小型，短期的分配”。实际上，我的代码优化了导致较低的 CPU 和内存使用率的问题（见下文）。

#### 更新至 19–03–2018

自从这篇文章发表以来，一些谷歌工程师注意到了这一点，并做出了进一步的优化。

更新后的代码通过将 `TimerText` 分为了两个 `MinutesAndSeconds` 和 `Hundredths` 控件，进一步减少了用户界面的重绘：

![](https://cdn-images-1.medium.com/max/800/1*NQxSNVJDSnZnC3DohLBTAA.png)

进一步的 UI 界面优化（来源：谷歌）。

它们将自己注册为定时器回调的监听器，并且只有状态发生改变时才会重新绘制。这进一步优化了性能，因为现在每 30 毫秒只有 `Hundredths` 控件会渲染。

### 基准测试结果

我在发布模式下运行了这个应用程序（`flutter run --release`）：

*   设备： **iPhone 6**运行于**iOS 11.2**
*   Flutter 版本：[0.1.5](https://github.com/flutter/flutter/releases/tag/v0.1.5) (2018年2月22日)。
*   Xcode 9.2

我在 Xcode 中监控了三分钟的 CPU 和内存使用情况，并测试了三种不同模式下的性能表现。

#### 未优化的代码

*   CPU 使用率：28%
*   内存使用率：32 MB （App启动后的基准线为 17 MB）

![](https://cdn-images-1.medium.com/max/800/1*F1GR6mVtVEwRjaJptEuEwQ.png)

#### 优化方案 1（独立的定时文本控件）

*   CPU 使用率：25%
*   内存使用率：25 MB （App启动后的基准线为 17 MB）

![](https://cdn-images-1.medium.com/max/800/1*dTO3vThMfGx0LYrLqAIlAQ.png)

#### 优化方案 2（独立的分钟、秒、分秒控件）

*   CPU Usage: 15% to 25%
*   内存使用率：26 MB （App启动后的基准线为 17 MB）

![](https://cdn-images-1.medium.com/max/800/1*JFnMDRT8utbB9C4ETPklOg.png)

在最后一个测试中，CPU 使用情况图密切地追踪了 GPU 线程，而 UI 线程保持地相当稳定。 

**注意**：在[**低速模式**](https://flutter.io/faq/#my-app-has-a-slow-mode-bannerribbon-in-the-upper-right-why-am-i-seeing-that)下以相同的基准运行，CPU 的使用率超过了 50%。随着时间的推移，**内存使用量也在不断增长**。

这可能意味着内存在开发模式下没有被释放。

关键要点：**确保你的应用处于发布模式**。

请注意，当 CPU 使用率超过 20% 时，Xcode 会报告出一个**非常高**的电力消耗警告。

### 深入探讨

我在不断思考这些结果。每秒触发 30 次并且重新渲染一个文本标签的定时器不应该占用 25 %的[双核 1.4GHz 的 CPU](https://en.wikipedia.org/wiki/Apple_A8)。

Flutter 应用中的控件树是由**声明式范型**所构建的，而不是在 iOS 和安卓上的**命令式**编程模型。

但是，命令模式下性能是否更加好呢？

为了找到答案，我在 iOS 上开发了相同的秒表应用。

这是用 Swift 代码设置了一个定时器，并且每 30 毫秒更新一次文本标签：

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

为了完整性，这是我在 Dart 中使用的时间格式代码（优化方案 1）：

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

最后结果如何？

**Flutter.** CPU：25%，内存：22 MB

**iOS.** CPU：7%，内存：8 MB

Flutter 实现方式在 CPU 的使用情况超过了 3 倍以上，内存上也同样是 3 倍之多。

当定时器停止运行时，CPU 的使用率回到了 1%。这就证实了全部 CPU 的工作都用于处理定时器的回调和重新绘制 UI 界面。

这并不足以让人惊讶。

*   在 Flutter 应用中，我每次都创建和渲染了一个新的 `Text` 控件。
*   在 iOS 中，我只是更新了 `UILabel` 的文本。

“嘿！” —— 我听到你说的。“但是时间格式的代码是不同的！你怎么知道 CPU 使用率的差异不是因为这个？”

那么，我们不进行格式去修改这两个例子：

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

最新结果：

**Flutter.** CPU：15%，内存：22 MB

**iOS.** CPU：8%，内存：8 MB

Flutter 的实现仍然是 CPU-intensive 的两倍。此外，它似乎在多线程（GPU，I/O 工作）上做了相当多的事情。但在 iOS 上，只有一个线程是处于活动状态的。

### 总结一下

我用一个具体的案例来对比了 Flutter/Dart 和 iOS/Swift 的性能表现。

数字是不会说谎的。当涉及到频繁的 UI 界面更新时候，**鱼和熊掌不可兼得**。 🎂

Flutter 框架让开发者用同样的代码库为 iOS 和安卓开发应用程序，像热加载等功能进一步提高了开发效率。但 Flutter 仍然处于初期阶段。我希望谷歌和社区可以改进运行时配置文件，更好地将好处带给终端用户。

至于你的应用程序，请务必考虑对代码进行微调，以减少用户界面的重绘。这份努力是值得。

我将这个项目的所有代码托管在[这个 GitHub 仓库](https://github.com/bizz84/stopwatch-flutter)，你可以自己来运行一下。

不用客气！😊

这个样品项目是我第一次使用 Flutter 框架的实验。如果你知道如何编写更优雅的代码，我很乐意收到你的评论。

**关于我：**我是一个自由职业的 iOS 开发者，同时兼顾在职工作，开源，写小项目和博客。

这是我的推特：[@biz84](https://twitter.com/biz84)。GiHub 主页：[GitHub](https://github.com/bizz84)。欢迎一切的反馈，推文，有趣的资讯！想知道我最喜欢什么？许多的掌声 👏👏👏。噢，还有香蕉和面包。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
