> * 原文地址：[Flutter Challenge: YouTube (Picture-In-Picture)](https://proandroiddev.com/flutter-challenge-youtube-ec5ff36eca9b)
> * 原文作者：[Deven Joshi](https://proandroiddev.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-youtube.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# 挑战Flutter之YouTube（画中画）

![](https://cdn-images-1.medium.com/max/1600/1*_sC2115-tUgSig4Urh1jvQ.jpeg)

挑战 Flutter 尝试在 Flutter 中重新创建特定应用的 UI 或设计。

此挑战将尝试实现 YouTube 的主页和视频详情页（视频实际播放的页面），包括动画。

这个挑战将比我以前的挑战稍微复杂一些，但结果却更好。

#### 开始

 YouTube 应用包括：

a）主页包括：

1.   AppBar 中有三个 action
2.  用户订阅视频
3.  底部导航栏

b）视频详情页包括：

1.  可缩小的主播放器，能让用户查看他们的订阅信息（PIP）
2.  基于当前视频的用户推荐

#### 建立项目

让我们创建一个名为 youtube_flutter 的 Flutter 项目，并删除所有默认代码，只留下一个带有默认 appBar 的空白页面。

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

#### 制作 AppBar 

 AppBar 左侧有 YouTube 的 logo 和名称，右侧有三个 action ，即记录、搜索和打开配置文件。

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

这就是重新创建的 AppBar 的样子：

![](https://cdn-images-1.medium.com/max/1600/1*xYqSCYNVC9zPB54z51NRxA.png)

注意：对于 YouTube 的 logo ，我使用了 [Dart pub](https://pub.dartlang.org/packages/font_awesome_flutter#-readme-tab-) FontFlutterAwesome 图标。

接着制作底部导航栏，

#### 创建 BottomNavigationBar 

底部导航栏有5项，在 Flutter 中重新创建非常简单。我们使用 Scaffold 的 bottomNavigationBar 参数。

```
bottomNavigationBar: BottomNavigationBar(items: [
  BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.fire, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.subscriptions, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.email, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
  BottomNavigationBarItem(icon: Icon(Icons.folder, color: Colors.black54,), title: Text("Home", style: TextStyle(color: Colors.black54),),),
], type: BottomNavigationBarType.fixed,),
```

注意：对于4个以上的项目我们需要指定一个固定的 BottomNavigationBarType ，因为为了避免拥挤默认类型是 shifting 。

结果是：

![](https://cdn-images-1.medium.com/max/1600/1*E9L_VTaUMxs5eOjNl0NRwQ.png)

重新创建的 YouTube 底部导航栏

#### 用户订阅视频

用户订阅视频是由推荐视频组成的项目列表。我们来看看列表项：

![](https://cdn-images-1.medium.com/max/1600/1*5WvYpQxPdwPsJWmuGiax5w.png)

列表项由一个带有一张图片的 Column 和一个有关视频信息的 Raw 组成。该 Row 由一张图片，一个包含标题、发布者和菜单按钮的 Column 组成。

要在 Flutter 中创建列表，我们可以使用 ListView.builder() 。重新创建列表项，如下：

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

这里的视频只是包含由标题和发布者等视频详情的列表。

这是重新创建的主页的样子：

![](https://cdn-images-1.medium.com/max/1600/1*Imp-nYfT9UYoRs4Hs_45Vg.png)

我们重新创建的主页

现在，我们将继续讨论稍微难一点的部分，视频详情页。

#### 创建视频详情页

视频详情页才是在 YouTube 中真正展示视频的页面。页面的亮点是我们可以缩小视频，并在屏幕的右下角继续播放。对于本文，我们将专注于缩小动画而不是实际播放视频。

请注意，这并不是一个特别的页面，而是在现有屏幕上叠加覆盖层。因此，我们将使用 Stack 组件来覆盖屏幕。

所以在背后，将有我们的主页，而顶部将是我们的视频页面。

#### 构建浮动视频播放器（画中画）

为了构建可以扩大至填充整个屏幕的浮动视频播放器，我们使用 LayoutBuilder 来完美地适配屏幕。

在继续之前，我们先定义一些值，即缩小和扩大时视频播放器的大小。我们不用为扩大的播放器设置宽度，而是从布局构建器中获取。

```
var currentAlignment = Alignment.topCenter;

var minVideoHeight = 100.0;
var minVideoWidth = 150.0;

var maxVideoHeight = 200.0;

// 这是一个任意的值，当构建布局时会改变。
var maxVideoWidth = 250.0;

var currentVideoHeight = 200.0;
var currentVideoWidth = 200.0;

bool isInSmallMode = false;
```

这里， “small mode” 指视频播放器缩小的时候。

构建视频详情页的 LayoutBuilder 可以写成：

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

注意我们是如何获得最大屏幕宽度然后使用，而不是使用我们的第一个任意值来作为最大屏幕宽度。

我们附加了一个 GestureDetector 来检测屏幕上的滑动，以便我们可以相应地缩小和扩大它。让我们创建动画。

#### 为视频详情页添加动画

当我们制作动画时，需要处理两件事：

1.  将视频从右上角移动到右下角。
2.  更改视频的大小并使其变小。

对于这些东西，我们使用两个 Tweens ，一个 AlignmentTween 和一个 Tween<double> ，并构造两个同时运行的独立动画。

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

这是代码的最终结果：

![](https://cdn-images-1.medium.com/max/1600/1*d0p0k1YrT6Ao87fxlG1fQw.png)

最终重新创建的 YouTube 应用

以下是该应用的视频：

* YouTube 视频链接：[https://youtu.be/dTpZ1BtNy4w](https://youtu.be/dTpZ1BtNy4w)

最终应用的 iOS 视频

这是该项目的 GitHub 链接：[https://github.com/deven98/YouTubeFlutter](https://github.com/deven98/YouTubeFlutter)

感谢阅读此 Flutter 挑战。可以留言告诉我任何你想要在 Flutter 中重新创建的应用。喜欢请给个 star ，下次见。

不要错过：

[Flutter Challenge: Whatsapp](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
