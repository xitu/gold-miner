> * 原文地址：[Flutter Challenge: YouTube (Picture-In-Picture)](https://proandroiddev.com/flutter-challenge-youtube-ec5ff36eca9b)
> * 原文作者：[Deven Joshi](https://proandroiddev.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# Flutter Challenge: YouTube (Picture-In-Picture)
# 挑战Flutter之YouTube（画中画）

![](https://cdn-images-1.medium.com/max/1600/1*_sC2115-tUgSig4Urh1jvQ.jpeg)

Flutter Challenges will attempt to recreate a particular app UI or design in Flutter.
挑战Flutter尝试在Flutter中重新创建特定应用的UI或设计。

This challenge will attempt the Home screen and the Video Detail screen (The screen where the video actually plays) of the Youtube app including the animation.
此挑战将尝试实现YouTube的主页和视频详情页（视频实际播放的页面），包括动画。

This challenge will be slightly more complex than my previous ones but the result is that much better for the same.
这个挑战将比我以前的挑战稍微复杂一些，但结果却更好。

#### Getting Started
#### 开始
The YouTube app comprises of:
YouTube应用包括：

a) The Home Screen which contains:
a）主页包括：
1.  The AppBar with 3 actions
1.  AppBar中有三个action
2.  The User Video Feed
2.  用户订阅视频
3.  The Bottom Navigation Bar
3.  底部导航栏

b) The Video Detail Screen which contains:
b）视频详情页包括：

1.  The main video player which can shrink to let users look at their feed (PIP)
1.  可缩小的主播放器，能让用户查看他们的订阅信息（PIP）
2.  Recommendations for users based on the current video
2.  基于当前视频的用户推荐

#### Setting up the project
#### 建立项目

Let’s make a Flutter project named youtube_flutter and remove all the default code leaving just a blank screen with the default app bar.
让我们创建一个名为youtube_flutter的Flutter项目，并删除所有默认代码，只留下一个带有默认appBar的空白屏幕。

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
#### 制作AppBar

The AppBar has the YouTube logo and name on the left and three actions, i.e. record, search and open profile on the right.
AppBar左侧有YouTube的logo和名称，右侧有三个action，即记录、搜索和打开配置文件。

The AppBar can be recreated as:
重新创建AppBar：

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
这就是重新创建的AppBar的样子：

![](https://cdn-images-1.medium.com/max/1600/1*xYqSCYNVC9zPB54z51NRxA.png)

Note: For the YouTube logo, I’ve used the FontFlutterAwesome icons [available as a package on Dart pub](https://pub.dartlang.org/packages/font_awesome_flutter#-readme-tab-).
注意：对于YouTube的logo，我使用了[Dart pub](https://pub.dartlang.org/packages/font_awesome_flutter#-readme-tab-)FontFlutterAwesome图标。

Let’s move on to the Bottom Navigation Bar,
接着制作底部导航栏，

#### Creating the BottomNavigationBar
#### 创建BottomNavigationBar

The bottom navigation bar has 5 items in it and is pretty straightforward to recreate in Flutter. We use the bottomNavigationBar parameter of the Scaffold.
底部导航栏有5项，在Flutter中重新创建非常简单。我们使用Scaffold的bottomNavigationBar参数。

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
注意：对于4个以上的项目我们需要指定一个固定的BottomNavigationBarType，因为为了避免拥挤默认类型是shifting。

The result is:
结果是：

![](https://cdn-images-1.medium.com/max/1600/1*E9L_VTaUMxs5eOjNl0NRwQ.png)

The recreated YouTube bottom navigation bar
重新创建的YouTube底部导航栏

#### The User Video Feed
#### 用户订阅视频

The User Video Feed is a list of items consisting of recommended videos. Let’s take a look at the list item:
用户订阅视频是由推荐视频组成的项目列表。我们来看看列表项：

![](https://cdn-images-1.medium.com/max/1600/1*5WvYpQxPdwPsJWmuGiax5w.png)

The list item consists of a Column with an image and a Row of information about the video. The Row consists of an image, a Column of the title and publisher and a menu button.
列表项由一个带有一张图片的Column和一个有关视频信息的Raw组成。该Row包含一张图片，一个和发布者列以及菜单按钮。该Row由一张图片，一个包含标题、发布者和菜单按钮的Column组成。

To create a list in Flutter, we use a ListView.builder(). Recreating the list items, we come to:
要在Flutter中创建列表，我们可以使用ListView.builder()。重新创建列表项，如下：

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
这里的视频只是包含由标题和发布者等视频详情的列表。

This is how the recreated home screen looks like:
这是重新创建的主页的样子：

![](https://cdn-images-1.medium.com/max/1600/1*Imp-nYfT9UYoRs4Hs_45Vg.png)

Our recreated home screen
我们重新创建的主页

Now, we’ll move on to the slightly harder part, the video detail screen.
现在，我们将继续讨论稍微难一点的部分，视频详情页。

#### Creating the Video Detail Screen
#### 创建视频详情页

The video detail screen is the screen which actually displays videos in the YouTube app. The highlight of the screen is that we can shrink the video and it keeps on playing on the bottom right side of the screen. For this article, we’ll focus on the shrinking animation instead of actually playing a video.
视频详情页才是在YouTube中真正展示视频的页面。页面的亮点是我们可以缩小视频，并在屏幕的右下角继续播放。对于本文，我们将专注于缩小动画而不是实际播放视频。

Notice, the screen is not a different page, but more of an overlay onto the existing screen. So, we’ll use the Stack widget to overlay the screen instead.
请注意，这并不是一个特别的页面，而是在现有屏幕上叠加覆盖层。因此，我们将使用Stack组件来覆盖屏幕。

So at the background, we’ll have our home screen and on the top will be our video page.
所以在背后，将有我们的主页，而顶部将是我们的视频页面。

#### Building the Floating Video Player (Picture-in-picture)
#### 构建浮动视频播放器（画中画）

To build the floating video player which can expand to fill the whole screen, we use a LayoutBuilder to fit the screen perfectly.
为了构建可以扩大至填充整个屏幕的浮动视频播放器，我们使用LayoutBuilder来完美地适配屏幕。

Before going ahead we define a few values, namely, what size the video player will be when shrunk and expanded. We don’t set the width for the expanded player, instead, we take it from the Layout Builder.
在继续之前，我们先定义一些值，即缩小和扩大时视频播放器的大小。我们不用为扩大的播放器设置宽度，而是从布局构建器中获取。

```
var currentAlignment = Alignment.topCenter;

var minVideoHeight = 100.0;
var minVideoWidth = 150.0;

var maxVideoHeight = 200.0;

// This is an arbitrary value and will be changed when layout is built. 
// 这是一个任意的值，当构建布局时会改变。
var maxVideoWidth = 250.0;

var currentVideoHeight = 200.0;
var currentVideoWidth = 200.0;

bool isInSmallMode = false;
```

Here, “small mode” is when the video player is shrunk.
这里，“small mode”指视频播放器缩小的时候。

The LayoutBuilder which builds the Video Detail Screen can be written as:
构建视频详情页的LayoutBuilder可以写成：

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
注意我们是如何获得最大屏幕宽度然后使用，而不是使用我们的第一个任意值来作为最大屏幕宽度。

We have attached a GestureDetector to detect swipes on the screen so that we can shrink and expand it accordingly. Let’s create the animations.
我们附加了一个GestureDetector来检测屏幕上的滑动，以便我们可以相应地缩小和扩大它。让我们创建动画。

#### Animating the Video Detail Screen
#### 为视频详情页添加动画

When we animate, we need to take care of two things:
当我们制作动画时，需要处理两件事：

1.  Bringing the video from top to the bottom right.
1.  将视频从右上角带到右下角​​。
2.  Changing the size of the video and making it smaller.
2.  更改视频的大小并使其变小。

For these things, we use two Tweens, an AlignmentTween and a Tween<double> and construct two separate animations which will run concurrently.
对于这些东西，我们使用两个Tweens，一个AlignmentTween和一个Tween<double>，并构造两个同时运行的独立动画。

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
当我们的视频播放器向上或向下滑动时，会触发这些动画。

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
这是代码的最终结果：

![](https://cdn-images-1.medium.com/max/1600/1*d0p0k1YrT6Ao87fxlG1fQw.png)

The final recreated YouTube app
最终重新创建的YouTube应用

Here’s a video of the app in action:
以下是该应用的视频：

* YouTube 视频链接：https://youtu.be/dTpZ1BtNy4w
* YouTube 视频链接：[https://youtu.be/dTpZ1BtNy4w](https://youtu.be/dTpZ1BtNy4w)

An iOS video of the final app
最终应用的iOS视频

Here is the GitHub link for the project : [https://github.com/deven98/YouTubeFlutter](https://github.com/deven98/YouTubeFlutter)
这是该项目的GitHub链接：[https://github.com/deven98/YouTubeFlutter](https://github.com/deven98/YouTubeFlutter)

Thank you for reading this Flutter challenge. Feel free to mention any app you might want recreated in Flutter. Be sure to leave a few claps if you enjoyed it, and see you in the next one.
感谢阅读此Flutter挑战。可以留言告诉我任何你想要在Flutter中重新创建的应用。喜欢请给个star，下次见。

Don’t miss:
不要错过：

[Flutter Challenge: Whatsapp](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
