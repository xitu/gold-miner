> * 原文地址：[Flutter Challenge: WhatsApp](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)
> * 原文作者：[Deven Joshi](https://medium.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-whatsapp.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-whatsapp.md)
> * 译者：
> * 校对者：

# Flutter Challenge: WhatsApp

![](https://cdn-images-1.medium.com/max/1600/1*5n_vLiGTQ-RTWW-hdIT6XQ.jpeg)

Flutter Challenges will attempt to recreate a particular app UI or design in Flutter.

This challenge will attempt the home screen of the Whatsapp Android app. Note that the focus will be on the UI rather than actually fetching messages.

#### Getting Started

The WhatsApp home screen consists of

1.  An AppBar with with a search action and an menu
2.  Four tabs in the bottom of the AppBar
3.  A camera tab to take a photo
4.  A FloatingActionButton for multiple purposes
5.  A “Chats” tab to view all conversations
6.  A “Status” tab to view all statuses
7.  A “Calls” tab to view all past calls

#### Setting up the Project

Let’s make a Flutter project named whatsapp_ui and remove all the default code leaving just a blank screen with the default app bar.

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
        title: new Text("WhatsApp"),
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

#### The AppBar

The AppBar has the title of the app, and the two actions: Search and a menu.

Adding that to the AppBar,

```
appBar: new AppBar(
  title: new Text("WhatsApp", style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),),
  actions: <Widget>[
    Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Icon(Icons.search),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Icon(Icons.more_vert),
    ),
  ],
  backgroundColor: whatsAppGreen,
),
```

This is the result of the code:

![](https://cdn-images-1.medium.com/max/1600/1*4fwyAwhd3o7shdeZ1GAIaQ.png)

Now moving on to

#### The Tabs

The tabs are a simple extension to the AppBar and Flutter makes it extremely easy to implement them.

The AppBar has a “bottom” field which holds our tabs:

```
bottom: TabBar(
  tabs: [
    Tab(icon: Icon(Icons.camera_alt),),
    Tab(child: Text("CHATS"),),
    Tab(child: Text("STATUS",)),
    Tab(child: Text("CALLS",)),
  ], indicatorColor: Colors.white,
),
```

Also, we need a TabController for this to work.

Create a new TabController.

```
TabController tabController;

@override
void initState() {
  // TODO: implement initState
  super.initState();

  tabController = TabController(vsync: this, length: 4);

}
```

Now add that controller to the “controller” field of both the TabBar.

```
bottom: TabBar(
  tabs: [
    Tab(icon: Icon(Icons.camera_alt),),
    Tab(child: Text("CHATS"),),
    Tab(child: Text("STATUS",)),
    Tab(child: Text("CALLS",)),
  ], indicatorColor: Colors.white,
  controller: tabController,
),
```

And for the TabBarView

```
body: TabBarView(
  controller: tabController,
  children: [
    Icon(Icons.camera_alt),
    Text("Chat Screen"),
    Text("Status Screen"),
    Text("Call Screen"),
  ],
),
```

![](https://cdn-images-1.medium.com/max/1600/1*Cr01YXR6o8fN2XXKPpHaHQ.png)

Now before going to the individual pages, we’ll add the pages that the tabs represent. Switch the existing “body” code of the Scaffold with this:

```
body: TabBarView(
  children: [
    Icon(Icons.camera_alt),
    Text("Chat Screen"),
    Text("Status Screen"),
    Text("Call Screen"),
  ],
),
```

The children represent the pages that the tabs are for. For now an entire page is a Text widget.

#### Floating Action Button

The Floating Action Button changes depending on which page is on screen.

First add a FloatingActionButton in the Scaffold.

```
floatingActionButton: FloatingActionButton(
  onPressed: () {
  },
  child: fabIcon,
  backgroundColor: whatsAppGreenLight,
),
```

The “fabIcon” field simply stores which icon to display because we need to change which icon is displayed according to the screen displayed.

To listen to tab selected changes, attach a listener to the TabController.

```
tabController = TabController(vsync: this, length: 4)
  ..addListener(() {
    
  });
```

Now when tab controller realises the page has changed, change the FAB icon.

```
tabController = TabController(vsync: this, length: 4)
  ..addListener(() {
    setState(() {
      switch(tabController.index) {
        case 0:
          break;
        case 1:
          fabIcon = Icons.message;
          break;
        case 2:
          fabIcon = Icons.camera_enhance;
          break;
        case 3:
          fabIcon = Icons.call;
          break;
      }
    });
  });
```

![](https://cdn-images-1.medium.com/max/1600/1*OI_nzQqPKrnsboh_IP9W6g.png)

Moving on,

#### The Chat Screen

The Chat Screen has a list of messages we need to display. To make a list of messages, we use a ListView.builder() and construct our items.

Let’s take a look at the list item for the chat screen.

![](https://cdn-images-1.medium.com/max/1600/1*Qgf5MHYD-NOXpNx8I0oxIw.png)

The outer most widget is a row of one icon and another row

Inside the second row is a column consisting of one row and one text widget.

The row has the title and message date.

Let’s construct a Chat Item Model as a class for storing the details of the list item.

```
class ChatItemModel {
  
  String name;
  String mostRecentMessage;
  String messageDate;
  
  ChatItemModel(this.name, this.mostRecentMessage, this.messageDate);
  
}
```

Right now, I’ve omitted adding a profile picture for brevity.

```
itemBuilder: (context, position) {
  ChatItemModel chatItem = ChatHelper.getChatItem(position);

  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 64.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          chatItem.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                        Text(
                          chatItem.messageDate,
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        chatItem.mostRecentMessage,
                        style: TextStyle(
                            color: Colors.black45, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Divider(),
    ],
  );
},
```

After creating the first list this is the result:

![](https://cdn-images-1.medium.com/max/1600/1*WZq07uhmt7L-NYemQaRSRA.png)

We can similarly create the other tabs on the screens on the other screens. The complete example is hosted on GitHub.

GitHub link : [https://github.com/deven98/WhatsappFlutter](https://github.com/deven98/WhatsappFlutter)

Thank you for reading this Flutter challenge. Feel free to mention any app you might want recreated in Flutter. Be sure to leave a few claps if you enjoyed it, and see you in the next one.

Don’t miss: [The Medium App in Flutter](https://blog.usejournal.com/flutter-challenge-the-medium-app-5f64a0f3c764)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
