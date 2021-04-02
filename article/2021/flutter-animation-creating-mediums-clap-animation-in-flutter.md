> * 原文地址：[Flutter Animation : Creating medium’s clap animation in flutter](https://proandroiddev.com/flutter-animation-creating-mediums-clap-animation-in-flutter-3168f047421e)
> * 原文作者：[Kartik Sharma](https://medium.com/@Kartik1607)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-animation-creating-mediums-clap-animation-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-animation-creating-mediums-clap-animation-in-flutter.md)
> * 译者：
> * 校对者：

# Flutter Animation : Creating medium’s clap animation in flutter

In this article we would be exploring flutter animation from scratch. We would learn some core concepts about animation by creating a mock-up of medium clap animation in Flutter.

As the title says this post would focus more on animation and less on the basics of flutter.

## Getting Started

We would start from the code flutter creates when creating a new flutter project. Simply create a new flutter project and we are greeted with this code.

Starting Code:

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

Flutter provides us some freebies with the starter code. It is already managing the state of click count and has created a floating action button for us.

![](https://miro.medium.com/max/110/1*TpeTkSaUBAfKctD802YCtA.png)

Button we currently have

Below is the end product we want to achieve.

![](https://miro.medium.com/max/1600/1*Hnkdb5BSXFmjVitdYQiirQ.gif)

Animation we would create. By [**Thuy Gia Nguyen**](https://dribbble.com/shots/4294768-Medium-Claps-Made-in-Flinto)

Let’s take a quick look and fix some easy issues before adding animation.

1. Change button icon and background.
2. Button should keep on adding count when we hold the button.

Lets add those 2 quick fixes and get started with animation.

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
    // User pressed the button. This can be a tap or a hold.
    increment(null); // Take care of tap
    timer = new Timer.periodic(duration, increment); // Takes care of hold
  }

  void onTapUp(TapUpDetails tap) {
    // User removed his finger from button.
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
    // Using custom gesture detector because we want to keep increasing the claps
    // when user holds the button.
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

Looking at the final product, there are 3 things we need to add.

1. Change size of widgets.
2. Show score widget when button is pressed and hide it when released.
3. Add those tiny sprinkle widget and animate them.

Lets take this one by one and slowly increase the learning curve. To get started, we need to understand some basic things about animation in flutter.

## Understanding components for a basic animation in Flutter

An animation is nothing but some values which change over time. For example, when we click on the button we want to animate the score widget rising from bottom, and when we leave the button it should rise even more and then hide.

If you look only at the score widget, we need to **change the values** of position and opacity of widget **over some time.**

Score Widget:

```dart
// main.dart

new Positioned(
  child: new Opacity(opacity: 1.0, 
    child: new Container(
      // ……
    )),
  bottom: 100.0
);
```

Let’s say we want out score widget to take 150 ms to reveal itself from bottom. Think of this on a timeline as below

![](https://miro.medium.com/max/974/1*KZuvwwIIH-YDxiHpMr9FqA.png)

This is a simple 2D graph. The position would change with time.

Notice that the diagonal line is straight. This can even be a curved if you like.

You can make the position increase slowly with time and then get faster and faster. Or you could have it come in a super high speed and then slow down at the end.

This is where we get to introduce out first component : **Animation Controller.**

Animation Controller Construction:

```dart
scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
```

Here, we have created a simple controller for the animation. We have specified that we want to run the animation for a duration of 150ms. But, what is that vsync?

Mobile devices refresh their screen after every few milliseconds. That is how we perceive set of images as a continuous flow or a movie.

The rate at which the screen is refreshed can vary from device to device. Let’s say the mobile refreshes its screen 60 times a second (60 Frames per Second). That would be after every 16.67 ms, we feed a new image to our brain. Sometimes, things can get misaligned (we send out a different image while the screen was refreshing) and we get to see screen tearing. VSync takes care of that.

Let us add a listener to the controller and run the animation.

```dart
scoreInAnimationController.addListener(() {
  print(scoreInAnimationController.value);
});
scoreInAnimationController.forward(from: 0.0);

/* OUTPUT
I/flutter ( 1913): 0.0
I/flutter ( 1913): 0.0
I/flutter ( 1913): 0.22297333333333333
I/flutter ( 1913): 0.3344533333333333
I/flutter ( 1913): 0.4459333333333334
I/flutter ( 1913): 0.5574133333333334
I/flutter ( 1913): 0.6688933333333335
I/flutter ( 1913): 0.7803666666666668
I/flutter ( 1913): 0.8918466666666668
I/flutter ( 1913): 1.0
*/
```

**The controller generated numbers from 0.0 to 1.0 in 150 ms.** Notice that the values generated are almost linear. 0.2, 0.3, 0.4 … How do we change this behavior? This would be done by out second component : **Curved Animation**

```dart
bounceInAnimation = new CurvedAnimation(parent: scoreInAnimationController, curve: Curves.bounceIn);
bounceInAnimation.addListener(() {
  print(bounceInAnimation.value);
});

/*OUTPUT
I/flutter ( 5221): 0.0
I/flutter ( 5221): 0.0
I/flutter ( 5221): 0.24945376519722218
I/flutter ( 5221): 0.16975716286388898
I/flutter ( 5221): 0.17177866222222238
I/flutter ( 5221): 0.6359024059750003
I/flutter ( 5221): 0.9119433941222221
I/flutter ( 5221): 1.0
*/
```

We create a Curved animation by setting the parent as our controller and providing the curve we want to follow. There are a range of choices of curves we can use at [flutter curves documentation page.](https://docs.flutter.io/flutter/animation/Curves-class.html) The controller provides value from 0.0 to 1.0 to the curved animation widget over a period of 150 ms. The curved animation widget interpolates those values as per the curve we have set.

Still, we are getting value from 0.0 to 1.0. But we want values from 0.0 to 100.0 for our score widget. We could simply multiply by 100 to get the result. Or we can use the third component : **The Tween Class**

```dart
tweenAnimation = new Tween(begin: 0.0, end: 100.0).animate(scoreInAnimationController);
tweenAnimation.addListener(() {
  print(tweenAnimation.value);
});

/* Output 
I/flutter ( 2639): 0.0
I/flutter ( 2639): 0.0
I/flutter ( 2639): 33.452000000000005
I/flutter ( 2639): 44.602000000000004
I/flutter ( 2639): 55.75133333333334
I/flutter ( 2639): 66.90133333333334
I/flutter ( 2639): 78.05133333333333
I/flutter ( 2639): 89.20066666666668
I/flutter ( 2639): 100.0
*/
```

The tween class generated values from **begin** to **end.** We have used our earlier scoreInAnimationController which uses a linear curve. Instead we could have used our bounce curve to get different value. Advantages of Tween does not end here. You can tween other things too. [You can directly tween color, offset, position and other widget properties using classes which further extends the base tween class.](https://docs.flutter.io/flutter/animation/Tween-class.html)

**Score Widget Position Animation**

At this point we have enough knowledge to make our score widget pop out from bottom when we press the button and hide when we tap up.

```dart
initState() {
  super.initState();
  scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
  scoreInAnimationController.addListener((){
    setState(() {}); // Calls render function
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

![](https://miro.medium.com/max/748/1*SG72TWaiaHNspnOUmPityQ.gif)

Current state of animation

The score widget pops out on tap. But there is still one problem.

When we tap the button multiple times, the score widget pops out again and again. This is because of a small bug in above code. We are telling controller to forward from 0 each time a button is tapped.

Now, let’s add the out animation for the score widget.

First, we add an enum to manage the state of score widget more easily.

```dart
enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  BECOMING_INVISIBLE
}
```

Then, we create an out animation controller. The animation controller will animate the position of widget from 100 to 150 non linearly. We have also added a status listener for animation. As soon as animation is over, we set the state of our score widget to hidden.

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

When a user removes his finger from the widget, we would set the state accordingly and kick off a timer of 300 ms. After 300 ms, we would animate the widget’s position and opacity.

```dart
void onTapUp(TapUpDetails tap) {
  // User removed his finger from button.
  scoreOutETA = new Timer(duration, () {
    scoreOutAnimationController.forward(from: 0.0);
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
  });
  holdTimer.cancel();
}
```

We have also modified the tap down event to handle some corner situations.

```dart
void onTapDown(TapDownDetails tap) {
  // User pressed the button. This can be a tap or a hold.
  if (scoreOutETA != null) scoreOutETA.cancel(); // We do not want the score to vanish!
  if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
    scoreInAnimationController.forward(from: 0.0);
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
  }
  increment(null); // Take care of tap
  holdTimer = new Timer.periodic(duration, increment); // Takes care of hold
}
```

Finally, we need to choose which controller’s value we need to use for the position and opacity of our score widget. A simple switch does the job.

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

Current output:

![](https://miro.medium.com/max/732/1*RNvj1meQIy6nCn5d-S74qQ.gif)

The score widget works nicely. It pops in and then fades out.

**Score Widget Size Animation**

At this point, we pretty much have idea to how to change size as well when the score increases. Let’s quickly add the size animation and then we move onto to tiny sparkles

I have updated the **ScoreWidgetStatus** enum to hold an extra **VISIBLE** value. Now, we add a new controller for the size property.

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

The controller generates value from 0 to 1 over a period of 150 ms and as soon as it completes, we generate value from 1 to 0. This gives a nice growing and shrinking effect.

We have also updated our increment function to start the animation when a number is incremented.

```dart
void increment(Timer t) {
  scoreSizeAnimationController.forward(from: 0.0);
  setState(() {
    _counter++;
  });
}
```

We need to take care of case which deals with Visible property of the enum. To do so, we need to add some basic conditions in the Touch down event.

```dart
void onTapDown(TapDownDetails tap) {
  // User pressed the button. This can be a tap or a hold.
  if (scoreOutETA != null) {
    scoreOutETA.cancel(); // We do not want the score to vanish!
  }
  if(_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
    // We tapped down while the widget was flying up. Need to cancel that animation.
    scoreOutAnimationController.stop(canceled: true);
    _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
  }
  else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN ) {
    _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
    scoreInAnimationController.forward(from: 0.0);
  }
  increment(null); // Take care of tap
  holdTimer = new Timer.periodic(duration, increment); // Takes care of hold
}
```

Finally we use the value from the controller in our widget.

```dart
extraSize = scoreSizeAnimationController.value * 10;
...
height: 50.0 + extraSize,
width: 50.0  + extraSize,
...
```

Full code, can be found at [this github gist.](https://gist.github.com/Kartik1607/52c882194e3119e0d176fb15e6c6b913) We have both size and position animation working together. Size animation needs a bit tweaking, which we would person at last.

![](https://miro.medium.com/max/716/1*5ttrTDWNuApskZBCIX1zrQ.gif)

Size and Position animation working together.

## Sparkles animation

Before doing sparkles animation, we need to do some tweaks on the size animation. The button is growing too much as of now. The fix is simple. We change the extrasize multiplier from 10 to a lower number.

Now coming to the sparkles animation, we can observe that **sparkles are just 5 images which whose positions are changing.**

I made the image image of a triangle and a circle in MS Paint and saved that to flutter resources. Then we can use that image as Image asset.

Before animation, let us think of positioning and some tasks we need to accomplish.

1. We need to position 5 images, each at different angles to form a complete circle.
2. We need to rotate the images as per the angle.
3. We need to increase radius of circle with time.
4. We need to find the coordinates based on angle and radius.

Simply trigonometry gives us formula to get x and y coordinates based on sin and cosine of the angles.

```dart
var sparklesWidget =
  new Positioned(child: new Transform.rotate(
    angle: currentAngle - pi/2,
    child: new Opacity(opacity: sparklesOpacity,
      child : new Image.asset("images/sparkles.png", width: 14.0, height: 14.0, ))
    ),
    left:(sparkleRadius*cos(currentAngle)) + 20,
    top: (sparkleRadius* sin(currentAngle)) + 20 ,
  );
```

Now, we need to create 5 of these widgets. Each widget would have a different angle. A simple for loop would do the trick.

```dart
for(int i = 0;i < 5; ++i) {
  var currentAngle = (firstAngle + ((2*pi)/5)*(i));
  var sparklesWidget = ...
  stackChildren.add(sparklesWidget);
}
```

We simply divide 2*pi, (360 degrees) into 5 parts and create a widget accordingly. Then, we add the widget to an array which would serve as child of a stack.

Now, at this point most of work is done. We only need to animate the sparkleRadius and generate a new firstAngle when score is incremented.

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

![](https://miro.medium.com/max/788/1*O5FNILFgN18aAbfbTVfsDA.gif)

Final Result

And that is our introduction to **basic animations in flutter.** I’ll keep exploring flutter more and learn to create advanced UI.

You can get the full code at my git repo [here](https://github.com/Kartik1607/FlutterUI/tree/master/MediumClapAnimation/medium_clap).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
