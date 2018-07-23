> * 原文地址：[Examining performance differences between Native, Flutter, and React Native mobile development.](https://robots.thoughtbot.com/examining-performance-differences-between-native-flutter-and-react-native-mobile-development)
> * 原文作者：[Alex Sullivan](https://robots.thoughtbot.com/authors/alex-sullivan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：

# 测试原生，Flutter 和 React Native 移动开发之间的性能差异。

确定你们公司的移动应用程序是真正的原生应用还是采用跨平台方法实现（如 [React Native](https://facebook.github.io/react-native/) 或 [Flutter](https：//flutter.io/?gclid=CjwKCAjw_tTXBRBsEiwArqXyMpTQzgV_nMlPcId9f80SVLkTOOeDSBufRKeadabVPzTD5D262LhFPRoCkKEQAvD_BwE)）是一个很艰难的决定。经常会考虑的一个因素是速度问题 —— 我们都普遍认为大多数跨平台方法比原生方法慢，但是很难说出具体的数字。因此，当我们考虑性能时，我们常常会靠直觉，而不是具体的数据。

因为希望在上述性能分析中添加一些结构，以及对 Flutter 如何实现其性能承诺的兴趣，我决定构建一个非常简单的应用程序分别对应原生版本，React Native 版本以及 Flutter 版本，进而比较他们的性能。

## [测试应用](#the-app)

我构建的应用程序尽可能简单，同时确保至少仍能提供一些信息。它是一个计时器应用 —— 具体来说，该应用程序显示随着时间的推移计数的一团文本。它显示自应用程序启动以来经过的分钟数、秒数和毫秒数。相当简单。

下面是它初始状态的样子：

![](https://images.thoughtbot.com/blog-vellum-image-uploads/0VCxRzRRfmVuQOZ89uQY_zero_time.png)

这是 1 分钟 14 秒 890 毫秒后的样子：

![](https://images.thoughtbot.com/blog-vellum-image-uploads/rhpib7pYRP60PJ403OSI_non_zero_timer.png)

铆。

## [但是为什么选计时器?](#but-why-a-timer)

我选择计时器应用有两个原因：

1.  它在每个平台上都很容易开发。这个应用程序的核心是某种类型的文本视图和重复计时器，很容易翻译成三种不同的语言和堆栈。
2.  它表明了底层系统在屏幕上绘制内容的效率。

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

每个应用程序都遵循相同的基本结构 —— 它们都有一个计时器，每 10 毫秒重复一次，并重新计算自计时器启动以来经过的分钟数、秒和毫秒数。

## [我们如何测量性能？](#how-are-we-measuring-the-performance)

对于那些不熟悉 Android 开发的人来说，Android Studio 是构建 Android 应用程序的首选编辑器/环境。它还附带了一系列有用的分析器来分析你的应用程序 —— 具体来说，它有一个 CPU 分析器，一个内存分析器和一个网络分析器。所以我们将使用这些分析器来判断性能。所有测试都在 Thoughtbot 的 Nexus 5X 和我自己的第一代 Google Pixel 上运行。React Native 应用程序将在 `--dev` 标志设置为 `false` 的情况下运行，Flutter 应用程序将在 `profile` 配置中运行，以模拟发布应用程序而不是 JIT 编译的调试应用程序。

## [给我看数据！](#show-me-some-numbers)

到了这篇文章最有趣的部分了。让我们看一下在 Thoughtbot 办公室的 Nexus 5X 上运行时的结果。

#### [Nexus 5X 上面原生应用的结果](#native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lFFEgOsfTSoj0vK5Se3T_5X-native.png)

#### [Nexus 5X 上面 React Native 应用的结果](#react-native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AZGU7tjrQafOmrSmInOA_5X-react-native.png)

#### [Nexus 5X 上面 Flutter 应用的结果](#flutter-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AJNqUln8TOiJE1vZ0tnj_5X-flutter-profile.png)

这些结果首先表明的是，当涉及到性能时，原生 Android 应用程序胜过 React Native 和 Flutter 应用程序可不是一点半点。原生应用程序上的 CPU 使用率不到 Flutter 应用程序的一半，与 React Native 应用程序相比，Flutter 占用的 CPU 更少一些，但是差别不大。原生应用程序的内存使用率同样很低，并且在 React Native 和 Flutter 应用程序上内存使用率都有所增加，不过这次 React Native 应用表现得比 Flutter 应用更好。

下一个有趣的内容是 React Native 和 Flutter 应用程序在性能上是如此_相近_。虽然这个应用程序无疑是微不足道的，但我原本以为 JavaScript 桥接器会受到更多的影响，因为应用程序如此快速地通过该桥接器发送了如此多的消息。

现在让我们看看在 Pixel 上测试时的结果。

#### [Pixel 上面原生应用的结果](#native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/ZL2Ji5UAQF2rBSPVpuTA_pixel-native.png)

#### [Pixel 上面 React Native 应用的结果](#react-native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/wcCikaphRPy2lv8frxuS_pixel-react-native.png)

#### [Pixel 上面 Flutter 应用的结果](#flutter-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lQ2x4GucSWODuouxK270_pixel-flutter-profile.png)

所以，我立马就对 Pixel 上显然更高的 CPU 占用感到惊讶。它肯定是比 Nexus 5X 更强大（在我看来就是更流畅）的手机，所以我自然而然假设同一应用程序的 CPU 利用率将_更低_，而不是更高。我可以理解为什么内存使用会更高，因为 Pixel 上有更大的内存空间而且 Android 上遵循一条“使用它或者浪费它”的策略来保持内存。如果读者中有任何人知道的话，我很想了解一下为什么 CPU 使用率会更高！

第二个有趣的收获是，Flutter 和 React Native 与原生应用相比在他们的优势和劣势方面有了_更明显_的差别。React Native 只比原生应用程序占用的内存略微高一点，而 Flutter 的内存使用率比原生应用程序高出近 50％。另一方面，Flutter 应用程序更接近于原生应用程序的 CPU 使用率，而 React Native 应用程序则难以保持低于 30％ 的 CPU 使用率。

最重要的是，我对 5X 和 Pixel 之间结果的_差异之大_感到惊讶。

## [结论](#conclusion)

我可以很有信心地说原生 Android 应用的性能优于 React Native 应用或 Flutter 应用。不过，我_没有_信心说 React Native 应用将表现得比 Flutter 应用更好，反之亦然。还需要做_更多_的测试才能弄清楚 Flutter 是否能真正提供比 React Native 更高的真实性能。

## [注意事项](#caveats)

上面所做的分析是_并不是_最终结果。我运行的一小部分测试不能用来表示 React Native 比 Flutter 更快或者相反。它们只应被解释为分析跨平台应用程序这个大问题的一部分。还有很多这个小应用程序没有触及的东西会影响现实世界的性能和用户体验。值得指出的是，在 debug 模式和 release 模式下，所有三个应用程序都运行顺畅。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
