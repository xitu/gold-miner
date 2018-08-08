> * 原文地址：[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)
> * 原文作者：[Deven Joshi](https://itnext.io/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# Flutter Challenge: Twitter
# 挑战Flutter之Twitter

![](https://cdn-images-1.medium.com/max/1600/1*d741kjfzNQv6W_d5wd37HA.png)

Flutter Challenges will attempt to recreate a particular app UI or design in Flutter.
挑战Flutter将尝试在Flutter中重新创建特定应用的UI或设计。

This challenge will attempt the home screen of the Twitter Android app. Note that the focus will be on the UI rather than actually fetching data from a backend server.
此挑战将尝试实现安卓版Twitter的主页。请注意，重点将放在UI上，而不是实际从后端服务器获取数据。

#### Understanding the app structure
#### 了解应用结构

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

The Twitter app has 4 main pages controlled by a Bottom Navigation Bar.
Twitter有四个由底部导航栏控制的主要页面。

They are :
它们是：

1.  Home (Displays tweets in your feed)
1.  主页（展示订阅的推文）
2.  Search (Search people, organisations, etc)
2.  搜索页（搜索人员，组织等）
3.  Notifications (Notifications and mentions)
3.  通知页（通知和提及）
4.  Messages (Private messages)
4.  消息页（私人消息）

The BottomNavigationBar has four tabs to go to each of these pages.
BottomNavigationBar有四个选项卡可以跳转到每个页面。

In our app, we’ll have four different pages and we’ll just change the pages when an item on the BottomNavigationBar is tapped.
在我们的应用中将有四个不同的页面，只需点击BottomNavigationBar上的项目来切换页面。

#### Setting up the project
#### 建立项目

After creating a Flutter project (I’ve named it twitter\_ui\_demo), clear out the default code in the project until you’re left with this:
创建好Flutter项目（我将其命名为twitter\_ui\_demo）后，清除项目中的默认代码，只留下这些：

```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

The HomePage will have a Scaffold that will hold our main BottomNavigationBar and whatever page is currently active.
HomePage中有一个Scaffold，它存有我们的BottomNavigationBar以及当前激活的页面。

#### Getting Started
#### 开始

Because the Bottom Navigation Bar is the main widget used to navigate, let’s try that first.
因为底部导航栏是用于导航的主要组件，所以我们先试着实现它。

Here’s how the BottomNavigationBar looks like:
这是BottomNavigationBar的样子：

![](https://cdn-images-1.medium.com/max/1600/1*ROeASZyzAcmgMH2Y4jLV3g.jpeg)

Because we don’t have the exact icons used in the app, we’ll go with the [Font Flutter Awesome package](https://pub.dartlang.org/packages/font_awesome_flutter). Add the dependency in the pubspec.yaml and add
因为没有应用中所需的图标，所以我们将使用[Font Flutter Awesome package](https://pub.dartlang.org/packages/font_awesome_flutter)。在pubspec.yaml中添加依赖项并引入：

```
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
```

to the file.
到文件中

The BottomNavigationBar code comes down to:
BottomNavigationBar的代码如下：

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

Add this to the HomePage.
将其添加到HomePage。

Notice when we set the color of the icons, we check if the icon is selected and then assign colors. In the twitter app, selected icon is blue and let’s set unselected ones to blueGrey.
请注意，当设置图标的颜色时，我们会检查是否选中了图标，然后指定颜色。在Twitter中，选中的图标为蓝色，让我们将未选择的图标设置为blueGrey。

We define a integer called selectedPageIndex which stores the index of the page selected. In the onTap function, we set the variable to the new index. It is wrapped in a setState() call as we need a refresh of the page to re-render the AppBar.
定义一个名为selectedPageIndex的整型变量，用于存储所选页面的索引。在onTap函数中，我们将变量设置为新索引。用setState（）包裹起来，因为我们需要刷新页面来重新渲染AppBar。

Here is our Bottom Navigation Bar:
实现的底部导航栏：

![](https://cdn-images-1.medium.com/max/1600/1*Bx-LXAq4g0_SDJB53U0xMg.png)

#### Setting Up The Pages
#### 构建页面

Let’s set up the four basic pages which will be displayed when the respective icons are clicked.
让我们构建四个基本页面，这些页面将在单击相应的图标时显示。

We set up four pages (in different files) like this:
建立的四个页面（在不同的文件中）如下：

For the user feed (home) page :
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

Similarly we set up the Search, Notification and Messages Page.
类似的，我们建立好搜索，通知和消息页面。

Again in the base page, we import all theses pages and set up a list of these pages.
回到基础页面中，引入这些页面并定义成一个列表。

```
var pages = [
  UserFeedPage(),
  SearchPage(),
  NotificationPage(),
  MessagesPage(),
];
```

And in the Scaffold, we set
在Scaffold中，写入

```
body: pages[selectedPageIndex],
```

which sets the body to display the page.
它将设置body来展示这些页面。

So till now, this is the MyHomePage base widget:
到目前为止，MyHomePage基础组件的代码如下：

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

Now, we’ll recreate the pages themselves.
现在，我们将重新创建页面。

#### Creating the User Feed Page
#### 创建用户订阅页

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

There are two elements in the page: The AppBar and the list of tweets.
页面中有两个元素：AppBar和推文列表。

First let’s make the AppBar. It has a user profile picture and a black title with a white background.
首先制作AppBar。它有一张用户个人资料图片和一个白底黑字的标题。

```
appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text("Home", style: TextStyle(color: Colors.black),),
  leading: Icon(Icons.account_circle, color: Colors.grey, size: 35.0,),
),
```

We’ll use an icon instead of a profile picture.
我们将使用图标而不是个人资料图片。

![](https://cdn-images-1.medium.com/max/1600/1*mbPj5DfJmNBdTRoFz_2qZw.png)

The recreated AppBar
重新创建的AppBar

Now, we need to create the list of tweets. For this we use a ListView.builder().
现在，我们需要创建推文列表。为此，我们使用ListView.builder（）。

Let’s take a look at the list item.
来看看列表项。

![](https://cdn-images-1.medium.com/max/1600/1*Dg5b1_8TBgd71HHUGbaAqA.jpeg)

First, we’ll have a column with a row and a divider you see at the bottom.
首先，我们需要一个由row和divider组成的column。

Inside the row, we’ll have the user icon and another column.
在row中，有一个icon和另一个column。

The column will hold a row for tweet information, a text with the tweet itself, an image and another row for actions to take on a tweet (like, comment, etc.).
该column中有一个用于展示推文信息的row，一个用于展示推文本身的text，一个image和另一个用于对推文应用操作（如评论等）的row。

For brevity, we’ll exclude the image for now, but adding it is as simple as adding an image in a row.
为简洁起见，我们暂时抛开image，实际上和在row中添加image一样简单。

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

After making a helper class for supplying simple tweets and adding a simple FloatingActionButton, this is the result:
在创建一个用于提供简单推文的帮助类和一个简单的FloatingActionButton后，页面如下：

![](https://cdn-images-1.medium.com/max/1600/1*DF1_9kc9NGzT9pd4CtyDjw.png)

The recreated Twitter app
重新创建的Twitter应用

This is the recreated page for the Twitter user feed. The fact that recreating any UI is fast and easy in Flutter is a testament to its development speed and customisability at the same time. These are two things that rarely go together.
这是重新构建的Twitter用户订阅页。在Flutter中可以快速轻松地重新创建任何UI，这说明了它的开发速度和可定制性非常不错。两者很难兼顾。

The complete example is hosted on Github.
完整的示例托管在Github上。

Github link: [https://github.com/deven98/TwitterFlutter](https://github.com/deven98/TwitterFlutter)
Github链接：[https://github.com/deven98/TwitterFlutter](https://github.com/deven98/TwitterFlutter)

Thank you for reading this Flutter challenge. Feel free to mention any app you might want recreated in Flutter. Be sure to leave a few claps if you enjoyed it, and see you in the next one.
感谢阅读此Flutter挑战。可以留言告诉我任何你想要在Flutter中重新创建的应用。喜欢请给个star，下次见。

Don’t miss:
不要错过：

[The Medium App in Flutter](https://blog.usejournal.com/flutter-challenge-the-medium-app-5f64a0f3c764)

[WhatsApp in Flutter](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
