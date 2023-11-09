> * 原文地址：[Flutter Animation : Creating medium’s clap animation in flutter](https://proandroiddev.com/flutter-animation-creating-mediums-clap-animation-in-flutter-3168f047421e)
> * 原文作者：[Kartik Sharma](https://medium.com/@Kartik1607)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-animation-creating-mediums-clap-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-animation-creating-mediums-clap-animation-in-flutter.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[greycodee](https://github.com/greycodee)、[HumanBeingXenon](https://github.com/HumanBeingXenon)

# Flutter 动画：构建一个和 Medium 一样的鼓掌动画

在这篇文章中，我们将从零开始探索 Flutter 动画。我们将通过在 Flutter 中模仿制作 Medium 的鼓掌动画，同时学习一些关于动画的核心概念。

正如标题所说，这篇文章将更多地关注动画，而不是 Flutter 的基础知识。

## 开始

我们会从新建一个 Flutter 项目开始。每当我们新建一个 Flutter 项目，我们就会看到这段代码：

```dart
// main.dart

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
```

Flutter 为我们提供了一份免费的入门代码午餐～它已经写了用于管理点击次数的状态的代码，也为我们创建了一个浮动的动作按钮。

![我们目前有的按钮](https://miro.medium.com/max/110/1*TpeTkSaUBAfKctD802YCtA.png)

下面是我们想要达到的最终效果：

![我们将会创建的动画。作者：[**Thuy Gia Nguyen**](https://dribbble.com/shots/4294768-Medium-Claps-Made-in-Flinto)](https://miro.medium.com/max/1600/1*Hnkdb5BSXFmjVitdYQiirQ.gif)

在添加动画之前，我们先来快速浏览并解决一些简单的问题。

1. 改变按钮图标和背景。
2. 当我们按住按钮时，按钮应该继续添加计数。

让我们添上这两个更改，然后开始着手制作动画：

```dart
// main.dart

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final duration = new Duration(milliseconds: 300);
  Timer timer;


  initState() {
    super.initState();
  }

  dispose() {
   super.dispose();
  }

  void increment(Timer t) {
    setState(() {
      _counter++;
    });
  }

  void onTapDown(TapDownDetails tap) {
    // 用户按下了按钮（要么是轻触，要么是长按）
    increment(null); // 负责于轻触
    timer = new Timer.periodic(duration, increment); // 负责于长按
  }

  void onTapUp(TapUpDetails tap) {
    // 用户的触控结束
    timer.cancel();
  }

  Widget getScoreButton() {
    return new Positioned(
        child: new Opacity(opacity: 1.0, child: new Container(
            height: 50.0 ,
            width: 50.0 ,
            decoration: new ShapeDecoration(
              shape: new CircleBorder(
                  side: BorderSide.none
              ),
              color: Colors.pink,
            ),
            child: new Center(child:
            new Text("+" + _counter.toString(),
              style: new TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),))
        )),
        bottom: 100.0
    );
  }

  Widget getClapButton() {
    // 因为我们希望保持鼓掌次数的增加，我们在这里应用了自定义的 GestureDetector
    // 当用户长按按钮的时候
    return new GestureDetector(
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: new Container(
          height: 60.0 ,
          width: 60.0 ,
          padding: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.pink, width: 1.0),
              borderRadius: new BorderRadius.circular(50.0),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(color: Colors.pink, blurRadius: 8.0)
              ]
          ),
          child: new ImageIcon(
              new AssetImage("images/clap.png"), color: Colors.pink,
              size: 40.0),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new Padding(
          padding: new EdgeInsets.only(right: 20.0),
          child: new Stack(
            alignment: FractionalOffset.center,
            overflow: Overflow.visible,
            children: <Widget>[
              getScoreButton(),
              getClapButton(),
            ],
          )
      ),
    );
  }
}
```

从我们希望实现的效果来看，我们仍需要做出 3 点修正。

1. 改变 Widget 的大小
2. 当按钮被按下时，显示那个展示鼓掌次数的 Widget，并在按钮释放时隐藏这个 Widget
3. 添加那些很小的向四周撒花的 Widget，并将它们做成动画

让我们一个一个来，慢慢推进学习进度。开始之前，我们需要了解 Flutter 中一些关于动画的基本知识。

## 了解 Flutter 中基本动画的 Widget

一个动画无非是一些随时间变化的数值。例如，当我们点击按钮时，我们想让显示鼓掌次数的 Widget 从底部逐步上移。当按钮释放的时候它应该已经上移了不少，这时候我们应该把它隐藏起来。

将焦点关注在显示鼓掌次数的 Widget 上，我们需要**在一段时间内改变**它的位置和不透明度。

```dart
// 显示鼓掌次数的 Widget

new Positioned(
  child: new Opacity(opacity: 1.0, 
    child: new Container(
      // ……
    )),
  bottom: 100.0
);
```

比方说，我们想让显示鼓掌次数的 Widget 在 150 毫秒后才从底部向上淡入。让我们在时间轴上思索一下，如下所示：

![](https://miro.medium.com/max/974/1*KZuvwwIIH-YDxiHpMr9FqA.png)

这是一幅简单的二维图像，位置随着时间推移而改变。

请注意这是一条斜线，不过如果你喜欢的话，这其实也可以是一条曲线。

你可以让位置随着时间慢慢增加，然后越来越快。或者你也可以让它以超高速进来，然后在最后慢下来。

这就是我们要介绍的第一个 Widget `AnimationController`。

`AnimationController` 构造器是这样的：

```dart
scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
```

在这里，我们已经为动画创建了一个简单的控制器，并指定了要运行动画的持续时间为 150ms。不过那个 `vsync` 是什么？

移动设备每隔几毫秒就会刷新一次屏幕。这就是我们如何将一组图像感知为一个连续的流或一部影片。

屏幕刷新的速度可以因设备而异。比方说，手机每秒刷新屏幕 60 次（60 帧/秒），那就是每隔 16.67 毫秒之后设备会绘制一个新的界面。有时图像可能会发生错位（我们在屏幕刷新时发送了不同的图像），我们就会看到屏幕撕裂。`vsync` 可以解决这个问题。

让我们在控制器上添加一个监听器然后运行动画：

```dart
scoreInAnimationController.addListener(() {
  print(scoreInAnimationController.value);
});
scoreInAnimationController.forward(from: 0.0);

/* OUTPUT
I/flutter (1913): 0.0
I/flutter (1913): 0.0
I/flutter (1913): 0.22297333333333333
I/flutter (1913): 0.3344533333333333
I/flutter (1913): 0.4459333333333334
I/flutter (1913): 0.5574133333333334
I/flutter (1913): 0.6688933333333335
I/flutter (1913): 0.7803666666666668
I/flutter (1913): 0.8918466666666668
I/flutter (1913): 1.0
*/
```

**控制器在 150 毫秒内产生了从 0.0 到 1.0 的数字** —— 请注意，产生的数值几乎是线性的（0.2, 0.3, 0.4……）。我们如何改变这个输出？这将由第二个 Widget `CurvedAnimation` 来完成：

```dart
bounceInAnimation = new CurvedAnimation(parent: scoreInAnimationController, curve: Curves.bounceIn);
bounceInAnimation.addListener(() {
  print(bounceInAnimation.value);
});

/* OUTPUT
I/flutter (5221): 0.0
I/flutter (5221): 0.0
I/flutter (5221): 0.24945376519722218
I/flutter (5221): 0.16975716286388898
I/flutter (5221): 0.17177866222222238
I/flutter (5221): 0.6359024059750003
I/flutter (5221): 0.9119433941222221
I/flutter (5221): 1.0
*/
```

我们通过将 `parent` 设置为我们的控制器并提供我们想要跟随的曲线，创建了一个曲线动画。在 [Flutter Curves 类参考文档页面](https://docs.flutter.io/flutter/animation/Curves-class.html)我们可以看到一系列我们可以使用的曲线。控制器在 150 毫秒的时间内向曲线动画 Widget 提供 0.0 到 1.0 的数值，而曲线动画 Widget 就会按照我们设置的曲线对这些值进行插值。

现在我们得到了从 0.0 到 1.0 的值，而我们希望我们的展示点赞次数的 Widget 的动画值的范围是 `[0.0, 100.0]`。我们可以简单地将上一步得到的值乘以 100 来得到结果。或者我们可以使用第三种部件 `Tween` 类。

```dart
tweenAnimation = new Tween(begin: 0.0, end: 100.0).animate(scoreInAnimationController);
tweenAnimation.addListener(() {
  print(tweenAnimation.value);
});

/* Output 
I/flutter (2639): 0.0
I/flutter (2639): 0.0
I/flutter (2639): 33.452000000000005
I/flutter (2639): 44.602000000000004
I/flutter (2639): 55.75133333333334
I/flutter (2639): 66.90133333333334
I/flutter (2639): 78.05133333333333
I/flutter (2639): 89.20066666666668
I/flutter (2639): 100.0
*/
```

`Tween` 类生成了从 `begin` 到 `end` 的值。我们使用了前面的 `scoreInAnimationController` ，它使用了一条线性曲线。（当然我们也可以使用我们的反弹曲线来获得不同的值）。`Tween` 的优势并不止于此 —— 你还可以 `Tween` 其他东西。[你可以直接 `Tween` 颜色、偏移、位置以及其他继承了 `Tween` 基类的 Widget 属性](https://docs.flutter.io/flutter/animation/Tween-class.html)。

### 展示鼓掌次数的 Widget 的位置动画

在这一点上，我们已经有足够的知识让我们的展示鼓掌次数的 Widget 在我们按下按钮时从底部弹出，而在我们释放按钮的时候隐藏。

```dart
initState() {
  super.initState();
  scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
  scoreInAnimationController.addListener((){
    setState(() {}); // 调用渲染函数
  });
}

void onTapDown(TapDownDetails tap) {
  scoreInAnimationController.forward(from: 0.0);
  ...    
}
Widget getScoreButton() {
  var scorePosition = scoreInAnimationController.value * 100;
  var scoreOpacity = scoreInAnimationController.value;
  return new Positioned(
    child: new Opacity(opacity: scoreOpacity, 
      child: new Container(/* …… */)
    ),
    bottom: scorePosition
  );
}
```

![动画的现状](https://miro.medium.com/max/748/1*SG72TWaiaHNspnOUmPityQ.gif)

点开后弹出展示鼓掌次数的 Widget，不过还是有一个问题：

当我们多次点击按钮时，展示鼓掌次数的 Widget 会不断地弹出。这是因为上面代码中的一个小错误。我们告诉控制器在每次点击按钮时从 0 开始前进。

现在，让我们为展示鼓掌次数的 Widget 添加输出动画。

首先，我们添加一个枚举来帮助我们更轻松地管理展示鼓掌次数的 Widget 的状态。

```dart
enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  BECOMING_INVISIBLE
}
```

然后，我们创建一个动画控制器，对 Widget 的位置值在 `[100, 150]` 范围内进行非线性动画。我们还为动画添加了一个状态监听器，一旦动画结束，我们就将展示鼓掌次数的 Widget 的状态设置为隐藏。

```dart
scoreOutAnimationController = new AnimationController(vsync: this, duration: duration);
scoreOutPositionAnimation = new Tween(begin: 100.0, end: 150.0).animate(
  new CurvedAnimation(parent: scoreOutAnimationController, curve: Curves.easeOut)
);
scoreOutPositionAnimation.addListener((){
  setState(() {});
});
scoreOutAnimationController.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  }
});
```

当用户将手指从 Widget 上移开时，我们将设置相应的状态，并启动一个 300 毫秒的计时器。300 毫秒后，我们将对 Widget 的位置和不透明度进行动画处理：

```dart
void onTapUp(TapUpDetails tap) {
  // 用户移开了他的手指
  scoreOutETA = new Timer(duration, () {
    scoreOutAnimationController.forward(from: 0.0);
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
  });
  holdTimer.cancel();
}
```

当用户将手指点按 Widget 时，我们将设置相应的状态，并启动一个 300 毫秒的计时器：

```dart
void onTapDown(TapDownDetails tap) {
  // 用户点按了按钮 —— 不管是长按还是触控
  if (scoreOutETA != null) scoreOutETA.cancel(); // 我们不希望次数消失！
  if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
    scoreInAnimationController.forward(from: 0.0);
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
  }
  increment(null); // 关注点按
  holdTimer = new Timer.periodic(duration, increment); // 关注长按
}
```

我们还修改了 `TapDown` 事件，以处理一些特殊情况。最后，我们需要选择我们需要使用哪个控制器的值来处理我们的展示鼓掌次数的 Widget 的位置和不透明度。一个简单的 `switch` 就可以完成这项工作：

```dart
Widget getScoreButton() {
  var scorePosition = 0.0;
  var scoreOpacity = 0.0;
  switch(_scoreWidgetStatus) {
    case ScoreWidgetStatus.HIDDEN:
      break;
    case ScoreWidgetStatus.BECOMING_VISIBLE:
      scorePosition = scoreInAnimationController.value * 100;
      scoreOpacity = scoreInAnimationController.value;
      break;
    case ScoreWidgetStatus.BECOMING_INVISIBLE:
      scorePosition = scoreOutPositionAnimation.value;
      scoreOpacity = 1.0 - scoreOutAnimationController.value;
  }
  return ……
}
```

现在我们得到的效果：

![](https://miro.medium.com/max/732/1*RNvj1meQIy6nCn5d-S74qQ.gif)

最后，我们需要选择我们需要使用哪个控制器的值来设置展示鼓掌次数的 Widget 的位置和不透明度 —— 它应该弹出+淡出。

### 展示鼓掌次数的 Widget 大小动画

在这一点上，当次数增加时我们也知道如何改变大小。让我们快速添加大小动画，然后我们转到撒花动画上。

我更新了 `ScoreWidgetStatus` 枚举，以持有一个额外的 `VISIBLE` 值。现在，我们为大小属性添加一个新的控制器。

```dart
scoreSizeAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 150));
scoreSizeAnimationController.addStatusListener((status) {
  if(status == AnimationStatus.completed) {
    scoreSizeAnimationController.reverse();
  }
});
scoreSizeAnimationController.addListener((){
  setState(() {});
});
```

控制器在 150 毫秒内产生从 0 到 1 的数值，一旦完成，我们就产生从 1 到 0 的数值，这样就有了很好的放大和缩小的效果。

我们还更新了我们的 `increment` 函数 —— 当数字递增时就会开始动画。

```dart
void increment(Timer t) {
  scoreSizeAnimationController.forward(from: 0.0);
  setState(() {
    _counter++;
  });
}
```

我们需要处理枚举的 `Visible` 属性的情况。为此，我们需要在 `TouchDown` 事件中添加一些判断：

```dart
void onTapDown(TapDownDetails tap) {
  // 用户点按了按钮 —— 不管是长按还是触控
  if (scoreOutETA != null) scoreOutETA.cancel(); // 我们不希望次数消失！
  if(_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
    // 在 Widget 向上飞入的时候点击了按钮，把那玩意暂停掉！
    scoreOutAnimationController.stop(canceled: true);
    _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
  }
  else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN ) {
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
    scoreInAnimationController.forward(from: 0.0);
  }
  increment(null); // 关注触控
  holdTimer = new Timer.periodic(duration, increment); // 关注长按
}
```

最后，我们在 Widget 中使用控制器的值。

```dart
extraSize = scoreSizeAnimationController.value * 10;
...
height: 50.0 + extraSize,
width: 50.0  + extraSize,
...
```

完整的代码可以在 [GitHub Gist](https://gist.github.com/Kartik1607/52c882194e3119e0d176fb15e6c6b913) 处找到。这里我们同时运行的大小和位置的动画。尺寸放缩动画还需要一点点调整，最后再说。

![尺寸和位置动画一起工作](https://miro.medium.com/max/716/1*5ttrTDWNuApskZBCIX1zrQ.gif)

## 撒花动画

在做撒花动画之前，我们需要对尺寸放缩动画做一些调整。目前来看，按钮的放大幅度太大。解决方法很简单，将 `extrasize` 系数从 `10` 改为小一点的数字。

现在来看撒花动画。我们可以观察到，**撒出来的花只是 5 个变化着位置的图像。**

我在微软的 Paint 软件中制作了一个三角形和一个圆形的图像，并将其保存到 Flutter 资源中。现在我们就可以将该图像作为 Image Asset 素材。

在制作动画之前，我们先来思考一下定位和一些我们需要完成的任务。

1. 我们需要定位 5 张图片，每张图片呈现不同角度，围成一个完整的圆。
2. 我们需要根据角度旋转图像。
3. 我们需要随着时间增加圆的半径。
4. 我们需要根据角度和半径找到坐标。

简单的三角学知识给我们提供了根据角度的正弦和余弦得到 x 和 y 坐标的公式。

```dart
var sparklesWidget =
  new Positioned(child: new Transform.rotate(
    angle: currentAngle - pi/2,
    child: new Opacity(opacity: sparklesOpacity,
      child : new Image.asset("images/sparkles.png", width: 14.0, height: 14.0, ))
    ),
    left:(sparkleRadius*cos(currentAngle)) + 20,
    top: (sparkleRadius*sin(currentAngle)) + 20 ,
  );
```

现在，我们需要创建 5 个这样的 Widget，而每个 Widget 都应该有不同的角度。一个简单的 `for` 循环就可以实现啦。

```dart
for(int i = 0;i < 5; ++i) {
  var currentAngle = (firstAngle + ((2*pi)/5)*(i));
  var sparklesWidget = ...
  stackChildren.add(sparklesWidget);
}
```

我们只需将 `2*pi`（360 度）分成 5 份，并据此创建一个 Widget。然后，我们将这些 Widget 添加到一个数组中，作为 `Stack` 的子 Widgets。

现在，在这一点上，大部分的工作已经完成。我们只需要对 `sparkleRadius` 进行动画处理，并在分数递增时生成一个新的 `firstAngle`。

```dart
sparklesAnimationController = new AnimationController(vsync: this, duration: duration);
sparklesAnimation = new CurvedAnimation(parent: sparklesAnimationController, curve: Curves.easeIn);
sparklesAnimation.addListener((){
  setState(() { });
});

void increment(Timer t) {
  sparklesAnimationController.forward(from: 0.0);
  ...
  setState(() {
  ...
  _sparklesAngle = random.nextDouble() * (2*pi);
});
     
Widget getScoreButton() {
  ...
  var firstAngle = _sparklesAngle;
  var sparkleRadius = (sparklesAnimationController.value * 50) ;
  var sparklesOpacity = (1 - sparklesAnimation.value);
  ...
}
```

![最终效果](https://miro.medium.com/max/788/1*O5FNILFgN18aAbfbTVfsDA.gif)

这就是我们对 Flutter 中**基本动画的介绍**。我们未来还会继续探索更多的 Flutter 知识，以学习创建更高级的 UI。

你可以在我的 [Git 仓库](https://github.com/Kartik1607/FlutterUI/tree/master/MediumClapAnimation/medium_clap)找到完整的代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
