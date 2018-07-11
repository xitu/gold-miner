> * 原文地址：[Examining performance differences between Native, Flutter, and React Native mobile development.](https://robots.thoughtbot.com/examining-performance-differences-between-native-flutter-and-react-native-mobile-development)
> * 原文作者：[Alex Sullivan](https://robots.thoughtbot.com/authors/alex-sullivan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：

# 测试 Native，Flutter 和 React Native 移动开发之间的性能差异。

It’s a difficult decision deciding whether your company’s mobile app should be a true native application or employ a cross platform approach like [React Native](https://facebook.github.io/react-native/) or [Flutter](https://flutter.io/?gclid=CjwKCAjw_tTXBRBsEiwArqXyMpTQzgV_nMlPcId9f80SVLkTOOeDSBufRKeadabVPzTD5D262LhFPRoCkKEQAvD_BwE). One factor that often comes into play is the question of speed - we all have a general sense that most cross platform approaches are slower then native, but the concrete numbers can be difficult to come across. As a result, we’re often going with a gut feeling rather than specific numbers when we consider performance.决定贵公司的移动应用程序是真正的原生应用程序还是采用跨站点方法（如 [React Native](https://facebook.github.io/react-native/) 或 [Flutter](https：//flutter.io/?gclid=CjwKCAjw_tTXBRBsEiwArqXyMpTQzgV_nMlPcId9f80SVLkTOOeDSBufRKeadabVPzTD5D262LhFPRoCkKEQAvD_BwE)）。 经常发挥作用的一个因素是速度问题 - 我们都普遍认为大多数跨平台方法比原生方法慢，但具体数字可能难以实现。 因此，当我们考虑表现时，我们常常会有一种直觉，而不是特定的数字。

In the hopes of adding some structure to the above performance analysis, as well as a general interest in how well Flutter lives up to its performance promises, I decided to build a very simple app as a native app, a react native app, and a flutter app to compare their performances.希望在上述性能分析中添加一些结构，以及对Flutter如何顺应其性能承诺的普遍兴趣，我决定构建一个非常简单的应用程序作为本机应用程序，反应原生应用程序，以及 扑动app来比较他们的表现。

## [The app](#the-app)

The app that I built is about as simple as it can get while still being at least somewhat informative. It’s a timer app - specifically, the app displays a blob of text that counts up as time goes on. It displays the number of minutes, seconds, and milliseconds that have passed since the app was started. Pretty simple.我构建的应用程序尽可能简单，同时至少仍然提供了一些信息。 它是一个计时器应用程序 - 具体来说，该应用程序显示随着时间的推移计数的一团文本。 它显示自应用程序启动以来经过的分钟数，秒数和毫秒数。 很简单。

下面是它初始状态的样子：

![](https://images.thoughtbot.com/blog-vellum-image-uploads/0VCxRzRRfmVuQOZ89uQY_zero_time.png)

这是一分钟 14 秒 890 毫秒后的样子：

![](https://images.thoughtbot.com/blog-vellum-image-uploads/rhpib7pYRP60PJ403OSI_non_zero_timer.png)

Riveting.铆。

## [But why a timer?](#but-why-a-timer)

我选择计时器应用有两个原因：

1.  It was easy to develop on each platform. At its core this app is a text view of some type and a repeating timer. Pretty easy to translate across three different languages and stacks.1.在每个平台上都很容易开发。 该应用程序的核心是某种类型的文本视图和重复计时器。 很容易翻译三种不同的语言和堆栈。
2.  It gives an indication of how efficient the underlying system is at drawing something to the screen.它表明了底层系统在屏幕上绘制内容的效率。

## [让我们看一看代码](#let39s-take-a-look-at-the-code)

幸运的是，这个应用足够小，我可以直接在这里添加相关代码。

### [原生 Android 应用](#native-android)

以下是原生 Android 应用的 MainActivity：

```
class MainActivity : AppCompatActivity() {

  val timer by lazy {
    findViewById<TextView>(R.id.timer)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)
    initTimer()
  }

  private fun initTimer() {
    val startTime = elapsedRealtime()
    val handler = Handler()
    val runnable: Runnable = object: Runnable {
      override fun run() {
        val timeDifference = elapsedRealtime() - startTime
        val seconds = timeDifference / 1000
        val minutes = seconds / 60
        val leftoverSeconds = seconds % 60
        val leftoverMillis = timeDifference % 1000 / 10
        timer.text = String.format("%02d:%02d:%2d", minutes, leftoverSeconds, leftoverMillis)
        handler.postDelayed(this, 10)
      }
    }

    handler.postDelayed(runnable, 1)
  }
}
```

### [React Native](#react-native)

这是 React Native 应用程序的 `App.js` 文件：

```
export default class App extends Component {

  render() {
    return (
      <View style={styles.container}>
        <Timer />
      </View>
    );
  }
}

class Timer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      milliseconds: 0,
      seconds: 0,
      minutes: 0,
    }

    let startTime = global.nativePerformanceNow();
    setInterval(() => {
      let timeDifference = global.nativePerformanceNow() - startTime;
      let seconds = timeDifference / 1000;
      let minutes = seconds / 60;
      let leftoverSeconds = seconds % 60;
      let leftoverMillis = timeDifference % 1000 / 10;
      this.setState({
        milliseconds: leftoverMillis,
        seconds: leftoverSeconds,
        minutes: minutes,
      });
    }, 10);
  }

  render() {
    let { milliseconds, seconds, minutes } = this.state;
    let time = sprintf("%02d:%02d:%2d", minutes, seconds, milliseconds);
    return (
      <Text>{time}</Text>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  }
});
```

### [Flutter](#flutter)

最后这是我们的 Flutter `main.dart` 文件：

```
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _startTime = new DateTime.now().millisecondsSinceEpoch;
  int _numMilliseconds = 0;
  int _numSeconds = 0;
  int _numMinutes = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(milliseconds: 10), (Timer timer) {
      int timeDifference = new DateTime.now().millisecondsSinceEpoch - _startTime;
      double seconds = timeDifference / 1000;
      double minutes = seconds / 60;
      double leftoverSeconds = seconds % 60;
      double leftoverMillis = timeDifference % 1000 / 10;
      setState(() {
        _numMilliseconds = leftoverMillis.floor();
        _numSeconds = leftoverSeconds.floor();
        _numMinutes = minutes.floor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
          child: new Text(
            sprintf("%02d:%02d:%2d", [_numMinutes, _numSeconds, _numMilliseconds]),
          ),
        )
    );
  }
}
```

Each app follows the same basic structure - they all have a timer that repeats every ten milliseconds and recalculates the amount of minutes/seconds/milliseconds that have elapsed since the timer was started.每个应用程序都遵循相同的基本结构 - 它们都有一个计时器，每10毫秒重复一次，并重新计算自计时器启动以来经过的分钟数/秒/毫秒数。

## [我们如何测量性能？](#how-are-we-measuring-the-performance)

For those unfamiliar with Android development, Android Studio is the editor/environment of choice for building Android apps. It also comes with a helpful series of profilers to analyze your application - specifically, there’s a CPU profiler, a memory profiler, and a network profiler. So we’ll use those profilers to judge performance. All of the tests are run on thoughtbots Nexus 5X and my own personal first generation Google Pixel. The React Native app will be run with the `--dev` flag set to `false`, and the Flutter app will be run in the `profile` configuration to simulate a release app rather than a JIT compiled debug app.对于那些不熟悉Android开发的人来说，Android Studio是构建Android应用程序的首选编辑器/环境。 它还附带了一系列有用的分析器来分析您的应用程序 - 具体来说，它有一个CPU分析器，一个内存分析器和一个网络分析器。 所以我们将使用这些分析器来判断性能。 所有测试都在思想机器人Nexus 5X和我自己的第一代Google Pixel上运行。 React Native应用程序将在`--dev`标志设置为`false`的情况下运行，Flutter应用程序将在`profile`配置中运行，以模拟发布应用程序而不是JIT编译的调试应用程序。

## [Show me some numbers!](#show-me-some-numbers)

Time for the interesting part of the blog post. Let’s take a look at the results when run on the Thoughtbot office Nexus 5X.博客文章有趣部分的时间。让我们看一下在Thoughtbot办公室Nexus 5X上运行时的结果。

#### [Nexus 5X 上面原生应用的结果](#native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lFFEgOsfTSoj0vK5Se3T_5X-native.png)

#### [Nexus 5X 上面 React Native 应用的结果](#react-native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AZGU7tjrQafOmrSmInOA_5X-react-native.png)

#### [Nexus 5X 上面 Flutter 应用的结果](#flutter-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AJNqUln8TOiJE1vZ0tnj_5X-flutter-profile.png)

The first thing these results make clear is that a native Android app trumps both the React Native and Flutter apps by a non trivial margin when it comes to performance. CPU usage on the native app is less than half that of the Flutter app, which is still less CPU hungry than the React Native app, though by a fairly small margin. Memory usage is similarly low on the native app and inflated on both the React Native and Flutter applications, though this time the React Native app eked out a win over the Flutter app.这些结果首先表明的是，当涉及到性能时，原生Android应用程序胜过React Native和Flutter应用程序是非常微不足道的。 本机应用程序上的CPU使用率不到Flutter应用程序的一半，与React Native应用程序相比，它仍然比CPU更少，但是相当小的余量。 本机应用程序的内存使用率同样很低，并且在React Native和Flutter应用程序上都有所膨胀，尽管这次React Native应用程序赢得了Flutter应用程序的胜利。

The next interesting takeaway is how _close_ in performance the React Native and Flutter applications are. While the app is admittedly trivial, I was expecting the JavaScript bridge to impose a higher penalty since the application is sending so many messages over that bridge so quickly.下一个有趣的内容是如何在性能上实现React Native和Flutter应用程序。 虽然该应用程序无疑是微不足道的，但我期待JavaScript桥接器施加更高的惩罚，因为应用程序如此快速地通过该桥接器发送了如此多的消息。

现在让我们看看在 Pixel 上测试时的结果。

#### [Pixel 上面原生应用的结果](#native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/ZL2Ji5UAQF2rBSPVpuTA_pixel-native.png)

#### [Pixel 上面 React Native 应用的结果](#react-native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/wcCikaphRPy2lv8frxuS_pixel-react-native.png)

#### [Pixel 上面 Flutter 应用的结果](#flutter-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lQ2x4GucSWODuouxK270_pixel-flutter-profile.png)

So, right off the bat I’m surprised about the significantly higher CPU utilization on the Pixel. It’s certainly a more powerful (and in my opinion, much smoother) phone than the Nexus 5X, so my natural assumption would be that CPU utilization for the same application would be _lower_, not higher. I can see why the memory usage would be higher, since there’s more memory on the Pixel and Android follows a general “use it or lose it” strategy for holding onto memory. I’m interested in hearing why the CPU usage would be higher if anyone in the audience knows!所以，马上我对Pixel上显着更高的CPU利用率感到惊讶。 它肯定比Nexus 5X更强大（在我看来，更平滑）手机，所以我的自然假设是同一应用程序的CPU利用率将低于，而不是更高。 我可以看到为什么内存使用会更高，因为Pixel和Android上有更多的内存遵循一般的“使用它或丢失它”策略来保持内存。 我很想知道如果观众中的任何人都知道，为什么CPU使用率会更高！

The second interesting take away here is that Flutter and React Native have diverged _heavily_ in their strengths and weaknesses vs their native counterpart. React Native is only marginally more memory-hungry than the native app, while Flutters memory usage is almost 50% higher than the native app. On the other hand, the Flutter app came much closer to matching the native apps CPU usage, whereas the React Native app struggled to stay under 30% CPU utilization.第二个有趣的收获是，Flutter和React Native在他们的优势和劣势方面与他们的本土同行分道扬.. React Native只比原生应用程序略微占用内存，而Flutters的内存使用率比本机应用程序高出近50％。 另一方面，Flutter应用程序更接近于匹配本机应用程序CPU使用率，而React Native应用程序则难以保持低于30％的CPU利用率。

More than anything else, I’m surprised by how _different_ the results are between the 5X and the Pixel.最重要的是，我对 5X 和 Pixel 之间结果的_差异_感到惊讶。

## [结论](#conclusion)

I feel confident in saying that a native Android app will perform better than either a React Native app or a Flutter app. Unfortunately, I _do not_ feel confident in saying that a React Native app will out perform a Flutter app or vice versa. _Much_ more testing will need to be done to figure out if Flutter can actually offer a real world performance improvement over React Native.我有信心说原生Android应用程序的性能优于React Native应用程序或Flutter应用程序。 不幸的是，我没有信心说React Native应用程序将执行Flutter应用程序，反之亦然。 _Much_需要做更多的测试才能弄清楚Flutter是否能真正提供比React Native更高的真实性能。

## [注意事项](#caveats)

The profiling done above is _by no means_ conclusive. The small series of tests that I ran cannot be used to state that React Native is faster than Flutter or vice versa. They should only be interpreted as part of a larger question of profiling cross platform applications. There are many, many things that this small application does not touch that affect real world performance and user experience. It’s also worth pointing out that all three applications, in debug mode and release mode, ran smoothly.上面所做的分析是_不是_决定性的。 我运行的一小部分测试不能用来表示React Native比Flutter更快，反之亦然。 它们只应被解释为分析跨平台应用程序的更大问题的一部分。 这个小应用程序没有触及的许多东西会影响现实世界的性能和用户体验。 值得指出的是，在调试模式和发布模式下，所有三个应用程序都运行顺畅。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
