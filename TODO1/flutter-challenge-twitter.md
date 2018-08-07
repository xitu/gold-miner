> * 原文地址：[Flutter Challenge: Twitter](https://itnext.io/flutter-challenge-twitter-a1cb17f1e21b)
> * 原文作者：[Deven Joshi](https://itnext.io/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-twitter.md)
> * 译者：
> * 校对者：

# Flutter Challenge: Twitter

![](https://cdn-images-1.medium.com/max/1600/1*d741kjfzNQv6W_d5wd37HA.png)

Flutter Challenges will attempt to recreate a particular app UI or design in Flutter.

This challenge will attempt the home screen of the Twitter Android app. Note that the focus will be on the UI rather than actually fetching data from a backend server.

#### Understanding the app structure

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

The Twitter app has 4 main pages controlled by a Bottom Navigation Bar.

They are :

1.  Home (Displays tweets in your feed)
2.  Search (Search people, organisations, etc)
3.  Notifications (Notifications and mentions)
4.  Messages (Private messages)

The BottomNavigationBar has four tabs to go to each of these pages.

In our app, we’ll have four different pages and we’ll just change the pages when an item on the BottomNavigationBar is tapped.

#### Setting up the project

After creating a Flutter project (I’ve named it twitter\_ui\_demo), clear out the default code in the project until you’re left with this:

```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

#### Getting Started

Because the Bottom Navigation Bar is the main widget used to navigate, let’s try that first.

Here’s how the BottomNavigationBar looks like:

![](https://cdn-images-1.medium.com/max/1600/1*ROeASZyzAcmgMH2Y4jLV3g.jpeg)

Because we don’t have the exact icons used in the app, we’ll go with the [Font Flutter Awesome package](https://pub.dartlang.org/packages/font_awesome_flutter). Add the dependency in the pubspec.yaml and add

```
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
```

to the file.

The BottomNavigationBar code comes down to:

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

Notice when we set the color of the icons, we check if the icon is selected and then assign colors. In the twitter app, selected icon is blue and let’s set unselected ones to blueGrey.

We define a integer called selectedPageIndex which stores the index of the page selected. In the onTap function, we set the variable to the new index. It is wrapped in a setState() call as we need a refresh of the page to re-render the AppBar.

Here is our Bottom Navigation Bar:

![](https://cdn-images-1.medium.com/max/1600/1*Bx-LXAq4g0_SDJB53U0xMg.png)

#### Setting Up The Pages

Let’s set up the four basic pages which will be displayed when the respective icons are clicked.

We set up four pages (in different files) like this:

For the user feed (home) page :

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

Again in the base page, we import all theses pages and set up a list of these pages.

```
var pages = [
  UserFeedPage(),
  SearchPage(),
  NotificationPage(),
  MessagesPage(),
];
```

And in the Scaffold, we set

```
body: pages[selectedPageIndex],
```

which sets the body to display the page.

So till now, this is the MyHomePage base widget:

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

#### Creating the User Feed Page

![](https://cdn-images-1.medium.com/max/1600/1*mc1ca10Ra86E1J6EEQmVZg.jpeg)

There are two elements in the page: The AppBar and the list of tweets.

First let’s make the AppBar. It has a user profile picture and a black title with a white background.

```
appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text("Home", style: TextStyle(color: Colors.black),),
  leading: Icon(Icons.account_circle, color: Colors.grey, size: 35.0,),
),
```

We’ll use an icon instead of a profile picture.

![](https://cdn-images-1.medium.com/max/1600/1*mbPj5DfJmNBdTRoFz_2qZw.png)

The recreated AppBar

Now, we need to create the list of tweets. For this we use a ListView.builder().

Let’s take a look at the list item.

![](https://cdn-images-1.medium.com/max/1600/1*Dg5b1_8TBgd71HHUGbaAqA.jpeg)

First, we’ll have a column with a row and a divider you see at the bottom.

Inside the row, we’ll have the user icon and another column.

The column will hold a row for tweet information, a text with the tweet itself, an image and another row for actions to take on a tweet (like, comment, etc.).

For brevity, we’ll exclude the image for now, but adding it is as simple as adding an image in a row.

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

![](https://cdn-images-1.medium.com/max/1600/1*DF1_9kc9NGzT9pd4CtyDjw.png)

The recreated Twitter app

This is the recreated page for the Twitter user feed. The fact that recreating any UI is fast and easy in Flutter is a testament to its development speed and customisability at the same time. These are two things that rarely go together.

The complete example is hosted on Github.

Github link: [https://github.com/deven98/TwitterFlutter](https://github.com/deven98/TwitterFlutter)

Thank you for reading this Flutter challenge. Feel free to mention any app you might want recreated in Flutter. Be sure to leave a few claps if you enjoyed it, and see you in the next one.

Don’t miss:

[The Medium App in Flutter](https://blog.usejournal.com/flutter-challenge-the-medium-app-5f64a0f3c764)

[WhatsApp in Flutter](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
