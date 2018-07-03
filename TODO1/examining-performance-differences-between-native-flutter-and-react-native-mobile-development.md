> * 原文地址：[Examining performance differences between Native, Flutter, and React Native mobile development.](https://robots.thoughtbot.com/examining-performance-differences-between-native-flutter-and-react-native-mobile-development)
> * 原文作者：[Alex Sullivan](https://robots.thoughtbot.com/authors/alex-sullivan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/examining-performance-differences-between-native-flutter-and-react-native-mobile-development.md)
> * 译者：
> * 校对者：

# Examining performance differences between Native, Flutter, and React Native mobile development.

It’s a difficult decision deciding whether your company’s mobile app should be a true native application or employ a cross platform approach like [React Native](https://facebook.github.io/react-native/) or [Flutter](https://flutter.io/?gclid=CjwKCAjw_tTXBRBsEiwArqXyMpTQzgV_nMlPcId9f80SVLkTOOeDSBufRKeadabVPzTD5D262LhFPRoCkKEQAvD_BwE). One factor that often comes into play is the question of speed - we all have a general sense that most cross platform approaches are slower then native, but the concrete numbers can be difficult to come across. As a result, we’re often going with a gut feeling rather than specific numbers when we consider performance.

In the hopes of adding some structure to the above performance analysis, as well as a general interest in how well Flutter lives up to its performance promises, I decided to build a very simple app as a native app, a react native app, and a flutter app to compare their performances.

## [The app](#the-app)

The app that I built is about as simple as it can get while still being at least somewhat informative. It’s a timer app - specifically, the app displays a blob of text that counts up as time goes on. It displays the number of minutes, seconds, and milliseconds that have passed since the app was started. Pretty simple.

Here’s an example of its starting state:

![](https://images.thoughtbot.com/blog-vellum-image-uploads/0VCxRzRRfmVuQOZ89uQY_zero_time.png)

And here’s an example after one minute, 14 seconds and 890 milliseconds has passed:

![](https://images.thoughtbot.com/blog-vellum-image-uploads/rhpib7pYRP60PJ403OSI_non_zero_timer.png)

Riveting.

## [But why a timer?](#but-why-a-timer)

I chose a timer app for two reasons:

1.  It was easy to develop on each platform. At its core this app is a text view of some type and a repeating timer. Pretty easy to translate across three different languages and stacks.
2.  It gives an indication of how efficient the underlying system is at drawing something to the screen.

## [Let’s take a look at the code](#let39s-take-a-look-at-the-code)

Luckily, the app(s) are small enough that I can add the relevant sections right here.

### [Native Android](#native-android)

Here’s the main activity of the native Android app:

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

Here’s our `App.js` file for the React Native app:

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

And finally here’s our Flutter `main.dart` file:

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

Each app follows the same basic structure - they all have a timer that repeats every ten milliseconds and recalculates the amount of minutes/seconds/milliseconds that have elapsed since the timer was started.

## [How are we measuring the performance?](#how-are-we-measuring-the-performance)

For those unfamiliar with Android development, Android Studio is the editor/environment of choice for building Android apps. It also comes with a helpful series of profilers to analyze your application - specifically, there’s a CPU profiler, a memory profiler, and a network profiler. So we’ll use those profilers to judge performance. All of the tests are run on thoughtbots Nexus 5X and my own personal first generation Google Pixel. The React Native app will be run with the `--dev` flag set to `false`, and the Flutter app will be run in the `profile` configuration to simulate a release app rather than a JIT compiled debug app.

## [Show me some numbers!](#show-me-some-numbers)

Time for the interesting part of the blog post. Let’s take a look at the results when run on the Thoughtbot office Nexus 5X.

#### [Native results on the Nexus 5X](#native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lFFEgOsfTSoj0vK5Se3T_5X-native.png)

#### [React Native results on the Nexus 5X](#react-native-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AZGU7tjrQafOmrSmInOA_5X-react-native.png)

#### [Flutter results on the Nexus 5X](#flutter-results-on-the-nexus-5x)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/AJNqUln8TOiJE1vZ0tnj_5X-flutter-profile.png)

The first thing these results make clear is that a native Android app trumps both the React Native and Flutter apps by a non trivial margin when it comes to performance. CPU usage on the native app is less than half that of the Flutter app, which is still less CPU hungry than the React Native app, though by a fairly small margin. Memory usage is similarly low on the native app and inflated on both the React Native and Flutter applications, though this time the React Native app eked out a win over the Flutter app.

The next interesting takeaway is how _close_ in performance the React Native and Flutter applications are. While the app is admittedly trivial, I was expecting the JavaScript bridge to impose a higher penalty since the application is sending so many messages over that bridge so quickly.

Now let’s take a look at the results when tested on a Pixel.

#### [Native results on the Pixel](#native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/ZL2Ji5UAQF2rBSPVpuTA_pixel-native.png)

#### [React Native results on the Pixel](#react-native-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/wcCikaphRPy2lv8frxuS_pixel-react-native.png)

#### [Flutter results on the Pixel](#flutter-results-on-the-pixel)

![](https://images.thoughtbot.com/blog-vellum-image-uploads/lQ2x4GucSWODuouxK270_pixel-flutter-profile.png)

So, right off the bat I’m surprised about the significantly higher CPU utilization on the Pixel. It’s certainly a more powerful (and in my opinion, much smoother) phone than the Nexus 5X, so my natural assumption would be that CPU utilization for the same application would be _lower_, not higher. I can see why the memory usage would be higher, since there’s more memory on the Pixel and Android follows a general “use it or lose it” strategy for holding onto memory. I’m interested in hearing why the CPU usage would be higher if anyone in the audience knows!

The second interesting take away here is that Flutter and React Native have diverged _heavily_ in their strengths and weaknesses vs their native counterpart. React Native is only marginally more memory-hungry than the native app, while Flutters memory usage is almost 50% higher than the native app. On the other hand, the Flutter app came much closer to matching the native apps CPU usage, whereas the React Native app struggled to stay under 30% CPU utilization.

More than anything else, I’m surprised by how _different_ the results are between the 5X and the Pixel.

## [Conclusion](#conclusion)

I feel confident in saying that a native Android app will perform better than either a React Native app or a Flutter app. Unfortunately, I _do not_ feel confident in saying that a React Native app will out perform a Flutter app or vice versa. _Much_ more testing will need to be done to figure out if Flutter can actually offer a real world performance improvement over React Native.

## [Caveats](#caveats)

The profiling done above is _by no means_ conclusive. The small series of tests that I ran cannot be used to state that React Native is faster than Flutter or vice versa. They should only be interpreted as part of a larger question of profiling cross platform applications. There are many, many things that this small application does not touch that affect real world performance and user experience. It’s also worth pointing out that all three applications, in debug mode and release mode, ran smoothly.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
