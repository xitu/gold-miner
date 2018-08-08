> * 原文地址：[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)
> * 原文作者：[Deven Joshi](https://itnext.io/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# 挑战 Flutter 之 Twitter

![](https://cdn-images-1.medium.com/max/1600/1*d741kjfzNQv6W_d5wd37HA.png)

挑战 Flutter 将尝试在 Flutter 中重新创建特定应用的 UI 或设计。

此挑战将尝试实现安卓版 Twitter 的主页。请注意，重点将放在 UI 上，而不是实际从后端服务器获取数据。

#### 了解应用结构

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

 Twitter 有四个由底部导航栏控制的主要页面。

它们是：

1.  主页（展示订阅的推文）
2.  搜索页（搜索人员，组织等）
3.  通知页（通知和提及）
4.  消息页（私人消息）

 BottomNavigationBar 有四个选项卡可以跳转到每个页面。

在我们的应用中将有四个不同的页面，只需点击 BottomNavigationBar 上的项目来切换页面。

#### 建立项目

创建好 Flutter 项目（我将其命名为 twitter\_ui\_demo ）后，清除项目中的默认代码，只留下这些：

```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //这是应用的根组件
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
      body: new Center(
      ),
    );
  }
}
```

 HomePage 中有一个 Scaffold ，它存有我们的 BottomNavigationBar 以及当前激活的页面。

#### 开始

因为底部导航栏是用于导航的主要组件，所以我们先试着实现它。

这是 BottomNavigationBar 的样子：

![](https://cdn-images-1.medium.com/max/1600/1*ROeASZyzAcmgMH2Y4jLV3g.jpeg)

因为没有应用中所需的图标，所以我们将使用 [Font Flutter Awesome package](https://pub.dartlang.org/packages/font_awesome_flutter) 。在 pubspec.yaml 中添加依赖项并引入

```
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
```

到文件中

 BottomNavigationBar 的代码如下：

```
bottomNavigationBar: BottomNavigationBar(items: [
  BottomNavigationBarItem(
    title: Text(""),
    icon: Icon(FontAwesomeIcons.home, color: selectedPageIndex == 0? Colors.blue : Colors.blueGrey,),
  ),
  BottomNavigationBarItem(
    title: Text(""),
    icon: Icon(FontAwesomeIcons.search, color: selectedPageIndex == 1? Colors.blue : Colors.blueGrey,),
  ),
  BottomNavigationBarItem(
      title: Text(""),
      icon: Icon(FontAwesomeIcons.bell, color: selectedPageIndex == 2? Colors.blue : Colors.blueGrey,)
  ),
  BottomNavigationBarItem(
      title: Text(""),
      icon: Icon(FontAwesomeIcons.envelope, color: selectedPageIndex == 3? Colors.blue : Colors.blueGrey,),
  ),
], onTap: (index) {
  setState(() {
    selectedPageIndex = index;
  });
}, currentIndex: selectedPageIndex)
```

将其添加到 HomePage 。

请注意，当设置图标的颜色时，我们会检查是否选中了图标，然后指定颜色。在 Twitter 中，选中的图标为蓝色，让我们将未选择的图标设置为 blueGrey 。

定义一个名为 selectedPageIndex 的整型变量，用于存储所选页面的索引。在 onTap 函数中，我们将变量设置为新索引。用 setState（）包裹起来，因为我们需要刷新页面来重新渲染 AppBar 。

实现的底部导航栏：

![](https://cdn-images-1.medium.com/max/1600/1*Bx-LXAq4g0_SDJB53U0xMg.png)

#### 构建页面

让我们构建四个基本页面，这些页面将在单击相应的图标时显示。

建立的四个页面（在不同的文件中）如下：

用户订阅（主页）页面的代码如下：

```
import 'package:flutter/material.dart';

class UserFeedPage extends StatefulWidget {
  @override
  _UserFeedPageState createState() => _UserFeedPageState();
}

class _UserFeedPageState extends State<UserFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

类似的，我们建立好搜索，通知和消息页面。

回到基础页面中，引入这些页面并定义成一个列表。

```
var pages = [
  UserFeedPage(),
  SearchPage(),
  NotificationPage(),
  MessagesPage(),
];
```

在Scaffold中，写入

```
body: pages[selectedPageIndex],
```

它将设置 body 来展示这些页面。

到目前为止， MyHomePage 基础组件的代码如下：

```
class _MyHomePageState extends State<MyHomePage> {

  var selectedPageIndex = 0;

  var pages = [
    UserFeedPage(),
    SearchPage(),
    NotificationPage(),
    MessagesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: pages[selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          title: Text(""),
          icon: Icon(FontAwesomeIcons.home, color: selectedPageIndex == 0? Colors.blue : Colors.blueGrey,),
        ),
        BottomNavigationBarItem(
          title: Text(""),
          icon: Icon(FontAwesomeIcons.search, color: selectedPageIndex == 1? Colors.blue : Colors.blueGrey,),
        ),
        BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(FontAwesomeIcons.bell, color: selectedPageIndex == 2? Colors.blue : Colors.blueGrey,)
        ),
        BottomNavigationBarItem(
          title: Text(""),
            icon: Icon(FontAwesomeIcons.envelope, color: selectedPageIndex == 3? Colors.blue : Colors.blueGrey,),
        ),
      ], onTap: (index) {
        setState(() {
          selectedPageIndex = index;
        });
      }, currentIndex: selectedPageIndex,),
    );
  }
}
```

现在，我们将重新创建页面。

#### 创建用户订阅页

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

页面中有两个元素： AppBar 和推文列表。

首先制作 AppBar 。它有一张用户个人资料图片和一个白底黑字的标题。

```
appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text("Home", style: TextStyle(color: Colors.black),),
  leading: Icon(Icons.account_circle, color: Colors.grey, size: 35.0,),
),
```

我们将使用图标而不是个人资料图片。

![](https://cdn-images-1.medium.com/max/1600/1*mbPj5DfJmNBdTRoFz_2qZw.png)

重新创建的 AppBar 

现在，我们需要创建推文列表。为此，我们使用 ListView.builder（）。

来看看列表项。

![](https://cdn-images-1.medium.com/max/1600/1*Dg5b1_8TBgd71HHUGbaAqA.jpeg)

首先，我们需要一个由 row 和 divider 组成的 column 。

在 row 中，有一个 icon 和另一个 column 。

该 column 中有一个用于展示推文信息的 row ，一个用于展示推文本身的 text ，一个 image 和另一个用于对推文应用操作（如评论等）的 row 。

为简洁起见，我们暂时抛开 image ，实际上和在 row 中添加 image 一样简单。

```
return Column(
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.account_circle, size: 60.0, color: Colors.grey,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text:tweet.username, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                              TextSpan(text:" " + tweet.twitterHandle,style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                              TextSpan(text:" ${tweet.time}",style: TextStyle(fontSize: 16.0, color: Colors.grey))
                            ]
                          ),overflow: TextOverflow.ellipsis,
                        )),flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.expand_more, color: Colors.grey,),
                        ),flex: 1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(tweet.tweet, style: TextStyle(fontSize: 18.0),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.comment, color: Colors.grey,),
                      Icon(FontAwesomeIcons.retweet, color: Colors.grey,),
                      Icon(FontAwesomeIcons.heart, color: Colors.grey,),
                      Icon(FontAwesomeIcons.shareAlt, color: Colors.grey,),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    Divider(),
  ],
);
```

在创建一个用于提供简单推文的帮助类和一个简单的 FloatingActionButton 后，页面如下：

![](https://cdn-images-1.medium.com/max/1600/1*DF1_9kc9NGzT9pd4CtyDjw.png)

重新创建的 Twitter 应用

这是重新构建的 Twitter 用户订阅页。在 Flutter 中可以快速轻松地重新创建任何 UI ，这说明了它的开发速度和可定制性非常不错。两者是很难兼顾的。

完整的示例托管在 Github 上。

 Github 链接：[https://github.com/deven98/TwitterFlutter](https://github.com/deven98/TwitterFlutter)

感谢阅读此 Flutter 挑战。可以留言告诉我任何你想要在 Flutter 中重新创建的应用。喜欢请给个 star ，下次见。

不要错过：

[The Medium App in Flutter](https://blog.usejournal.com/flutter-challenge-the-medium-app-5f64a0f3c764)

[WhatsApp in Flutter](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
