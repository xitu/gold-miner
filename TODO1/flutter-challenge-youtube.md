> * 原文地址：[Flutter Challenge: YouTube (Picture-In-Picture)](https://proandroiddev.com/flutter-challenge-youtube-ec5ff36eca9b)
> * 原文作者：[Deven Joshi](https://proandroiddev.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md)
> * 译者：
> * 校对者：

# Flutter Challenge: YouTube (Picture-In-Picture)

![](https://cdn-images-1.medium.com/max/1600/1*_sC2115-tUgSig4Urh1jvQ.jpeg)

Flutter Challenges will attempt to recreate a particular app UI or design in Flutter.

This challenge will attempt the Home screen and the Video Detail screen (The screen where the video actually plays) of the Youtube app including the animation.

This challenge will be slightly more complex than my previous ones but the result is that much better for the same.

#### Getting Started

The YouTube app comprises of:

a) The Home Screen which contains:

1.  The AppBar with 3 actions
2.  The User Video Feed
3.  The Bottom Navigation Bar

b) The Video Detail Screen which contains:

1.  The main video player which can shrink to let users look at their feed (PIP)
2.  Recommendations for users based on the current video

#### Setting up the project

Let’s make a Flutter project named youtube_flutter and remove all the default code leaving just a blank screen with the default app bar.

```
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
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
```

#### Making the AppBar

The AppBar has the YouTube logo and name on the left and three actions, i.e. record, search and open profile on the right.

The AppBar can be recreated as:

```
appBar: new AppBar(
  backgroundColor: Colors.white,
  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(FontAwesomeIcons.youtube, color: Colors.red,),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text("YouTube", style: TextStyle(color: Colors.black, letterSpacing: -1.0, fontWeight: FontWeight.w700),),
      ),
    ],
  ),
  actions: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Icon(Icons.videocam, color: Colors.black54,),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Icon(Icons.search, color: Colors.black54,),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Icon(Icons.account_circle, color: Colors.black54,),
    ),
  ],
),
```

This is what the recreated AppBar looks like:

![](https://cdn-images-1.medium.com/max/1600/1*xYqSCYNVC9zPB54z51NRxA.png)

Note: For the YouTube logo, I’ve used the FontFlutterAwesome icons [available as a package on Dart pub](https://pub.dartlang.org/packages/font_awesome_flutter#-readme-tab-).

Let’s move on to the Bottom Navigation Bar,

#### Creating the BottomNavigationBar

The bottom navigation bar has 5 items in it and is pretty straightforward to recreate in Flutter. We use the bottomNavigationBar parameter of the Scaffold.

```
bottomNavigationBar: BottomNavigationBar(items: [
  BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.fire, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.subscriptions, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.email, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.folder, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
], type: BottomNavigationBarType.fixed,),
```

Note: We need to specify a fixed BottomNavigationBarType because for 4+ items, the default type is shifting to avoid overcrowding.

The result is:

![](https://cdn-images-1.medium.com/max/1600/1*E9L_VTaUMxs5eOjNl0NRwQ.png)

The recreated YouTube bottom navigation bar

#### The User Video Feed

The User Video Feed is a list of items consisting of recommended videos. Let’s take a look at the list item:

![](https://cdn-images-1.medium.com/max/1600/1*5WvYpQxPdwPsJWmuGiax5w.png)

The list item consists of a Column with an image and a Row of information about the video. The Row consists of an image, a Column of the title and publisher and a menu button.

To create a list in Flutter, we use a ListView.builder(). Recreating the list items, we come to:

```
ListView.builder(
  itemCount: 3,
  itemBuilder: (context, position) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Image.asset(videos[position].imagePath, fit: BoxFit.cover,)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Icon(Icons.account_circle, size: 40.0,), flex: 2,),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(videos[position].title, style: TextStyle(fontSize: 18.0),),
                    ),
                    Text(videos[position].publisher, style: TextStyle(color: Colors.black54),)
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                flex: 9,
              ),
              Expanded(child: Icon(Icons.more_vert), flex: 1,),
            ],
          ),
        )
      ],
    );
  },
),
```

Here videos is simply a list of the video details like titles and publishers.

This is how the recreated home screen looks like:

![](https://cdn-images-1.medium.com/max/1600/1*Imp-nYfT9UYoRs4Hs_45Vg.png)

Our recreated home screen

Now, we’ll move on to the slightly harder part, the video detail screen.

#### Creating the Video Detail Screen

The video detail screen is the screen which actually displays videos in the YouTube app. The highlight of the screen is that we can shrink the video and it keeps on playing on the bottom right side of the screen. For this article, we’ll focus on the shrinking animation instead of actually playing a video.

Notice, the screen is not a different page, but more of an overlay onto the existing screen. So, we’ll use the Stack widget to overlay the screen instead.

So at the background, we’ll have our home screen and on the top will be our video page.

#### Building the Floating Video Player (Picture-in-picture)

To build the floating video player which can expand to fill the whole screen, we use a LayoutBuilder to fit the screen perfectly.

Before going ahead we define a few values, namely, what size the video player will be when shrunk and expanded. We don’t set the width for the expanded player, instead, we take it from the Layout Builder.

```
var currentAlignment = Alignment.topCenter;

var minVideoHeight = 100.0;
var minVideoWidth = 150.0;

var maxVideoHeight = 200.0;

// This is an arbitrary value and will be changed when layout is built. 
var maxVideoWidth = 250.0;

var currentVideoHeight = 200.0;
var currentVideoWidth = 200.0;

bool isInSmallMode = false;
```

Here, “small mode” is when the video player is shrunk.

The LayoutBuilder which builds the Video Detail Screen can be written as:

```
LayoutBuilder(
  builder: (context, constraints) {

    maxVideoWidth = constraints.biggest.width;

    if(!isInSmallMode) {
      currentVideoWidth = maxVideoWidth;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Align(
            child: Padding(
              padding: EdgeInsets.all(isInSmallMode? 8.0 : 0.0),
              child: GestureDetector(
                child: Container(
                  width: currentVideoWidth,
                  height: currentVideoHeight,
                  child: Image.asset(
                    videos[videoIndexSelected].imagePath,
                    fit: BoxFit.cover,),
                  color: Colors.blue,
                ),
                onVerticalDragEnd: (details) {
                  if(details.velocity.pixelsPerSecond.dy > 0) {
                    setState(() {
                      isInSmallMode = true;
                    });
                  }else if (details.velocity.pixelsPerSecond.dy < 0){
                    setState(() {
                    });
                  }
                },
              ),
            ),
            alignment: currentAlignment,
          ),
          flex: 3,
        ),
        currentAlignment == Alignment.topCenter ?
        Expanded(
          flex: 6,
          child: Container(
            child: Column(
              children: <Widget>[
                Row(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Video Recommendation"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Video Recommendation"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Video Recommendation"),
                    ),
                  ),
                )
              ],
            ),
            color: Colors.white,
          ),
        )
            :Container(),
        Row(),
      ],
    );
  },
)
```

Notice how we’re getting the maximum screen width and then using that instead of using our first arbitrary value for maximum screen width.

We have attached a GestureDetector to detect swipes on the screen so that we can shrink and expand it accordingly. Let’s create the animations.

#### Animating the Video Detail Screen

When we animate, we need to take care of two things:

1.  Bringing the video from top to the bottom right.
2.  Changing the size of the video and making it smaller.

For these things, we use two Tweens, an AlignmentTween and a Tween<double> and construct two separate animations which will run concurrently.

```
AnimationController alignmentAnimationController;
Animation alignmentAnimation;

AnimationController videoViewController;
Animation videoViewAnimation;

var currentAlignment = Alignment.topCenter;
@override
void initState() {
  super.initState();

  alignmentAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1))
    ..addListener(() {
      setState(() {
        currentAlignment = alignmentAnimation.value;
      });
    });
  alignmentAnimation = AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomRight).animate(CurvedAnimation(parent: alignmentAnimationController, curve: Curves.fastOutSlowIn));

  videoViewController = AnimationController(vsync: this, duration: Duration(seconds: 1))
    ..addListener(() {
      setState(() {
        currentVideoWidth = (maxVideoWidth*videoViewAnimation.value) + (minVideoWidth*(1.0-videoViewAnimation.value));
        currentVideoHeight = (maxVideoHeight*videoViewAnimation.value) + (minVideoHeight*(1.0-videoViewAnimation.value));
      });
    });
  videoViewAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(videoViewController);

}
```

We trigger these animations when our video player is swiped up or down.

```
onVerticalDragEnd: (details) {
  if(details.velocity.pixelsPerSecond.dy > 0) {
    setState(() {
      isInSmallMode = true;
      alignmentAnimationController.forward();
      videoViewController.forward();
    });
  }else if (details.velocity.pixelsPerSecond.dy < 0){
    setState(() {
      alignmentAnimationController.reverse();
      videoViewController.reverse().then((value) {
        setState(() {
          isInSmallMode = false;
        });
      });
    });
  }
},

```

This is the final result of the code:

![](https://cdn-images-1.medium.com/max/1600/1*d0p0k1YrT6Ao87fxlG1fQw.png)

The final recreated YouTube app

Here’s a video of the app in action:

* YouTube 视频链接：https://youtu.be/dTpZ1BtNy4w

An iOS video of the final app

Here is the GitHub link for the project : [https://github.com/deven98/YouTubeFlutter](https://github.com/deven98/YouTubeFlutter)

Thank you for reading this Flutter challenge. Feel free to mention any app you might want recreated in Flutter. Be sure to leave a few claps if you enjoyed it, and see you in the next one.

Don’t miss:

[Flutter Challenge: Whatsapp](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
