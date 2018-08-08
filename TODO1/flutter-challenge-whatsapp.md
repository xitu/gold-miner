> * 原文地址：[Flutter Challenge: WhatsApp](https://medium.com/@dev.n/flutter-challenge-whatsapp-b4dcca52217b)
> * 原文作者：[Deven Joshi](https://medium.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-whatsapp.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-challenge-whatsapp.md)
> * 译者： [YueYong](https://github.com/YueYongDev)
> * 校对者：

# Flutter 挑战之 WhatsApp

![](https://cdn-images-1.medium.com/max/1600/1*5n_vLiGTQ-RTWW-hdIT6XQ.jpeg)

Flutter Challenges 是一项尝试利用 Flutter 重新创建特定的应用程序UI或设计的挑战。

此次挑战将尝试 Whatsapp Android 应用程序的主界面。请注意将重点放在 UI 上而不是实际获取消息。

#### 开始

WhatsApp 的主界面包括：

1.  一个带有搜索操作和菜单的 AppBar
2.  在 AppBar 的底部有四个标签
3.  一个用于拍照的相机标签
4.  一个用于多种用途的 FloatingActionButton
5.  一个“聊天”标签可查看所有对话
6.  一个“状态”选项卡可查看所有状态
7.  一个“打电话”选项卡可查看所有的通话记录

#### 项目设置

让我们创建一个名为 whatsapp_ui 的 Flutter 项目并删除所有默认代码，只留下一个带有默认应用栏的空白屏幕。

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

AppBar 具有应用程序的标题，以及两个操作：搜索和菜单。

将其添加到 AppBar 中，

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

代码结果如下：

![](https://cdn-images-1.medium.com/max/1600/1*4fwyAwhd3o7shdeZ1GAIaQ.png)

现在继续

#### The Tabs

tabs（选项卡） 是 AppBar 的简单扩展，Flutter 使它们非常容易实现。

AppBar 有一个“底部”字段，用于保存我们的标签：

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

此外，我们需要一个 TabController 来实现这一点。

创建一个新的 TabController。

```
TabController tabController;

@override
void initState() {
  // TODO: implement initState
  super.initState();

  tabController = TabController(vsync: this, length: 4);

}
```

现在将该控制器添加到 TabBar 的 “controller” 字段中。

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

而对于 TabBarView

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

现在，在转到各个页面之前，我们将添加选项卡所代表的页面。用以下方法切换脚手架的现有“正文”代码：

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

子项代表选项卡所用的页面。现在整个页面都是一个 Text 小部件。

#### 悬浮按钮

Floating Action Button 根据屏幕上的页面而变化。

首先在脚手架中添加一个 FloatingActionButton。

```
floatingActionButton: FloatingActionButton(
  onPressed: () {
  },
  child: fabIcon,
  backgroundColor: whatsAppGreenLight,
),
```

“fabIcon” 字段只存储要显示的图标，因为我们需要根据显示的屏幕更改显示的图标。

要监听选项卡选定的更改，需要给 TabController 添加一个监听器。

```
tabController = TabController(vsync: this, length: 4)
  ..addListener(() {
    
  });
```

现在，当标签控制器实现页面已更改时，请更改 FAB 图标。

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

继续，

#### 聊天界面

聊天屏幕有一个我们需要显示的消息列表。要创建消息列表，我们使用 ListView.builder() 并构造我们的项目。

让我们来看看聊天界面的列表项。

![](https://cdn-images-1.medium.com/max/1600/1*Qgf5MHYD-NOXpNx8I0oxIw.png)

最外面的小部件是一行图标和另一行

第二行内部是一列，包含一行和一个文本小部件。

该行具有标题和消息日期。

让我们构建一个聊天项模型作为用于存储列表项详细信息的类。

```
class ChatItemModel {
  
  String name;
  String mostRecentMessage;
  String messageDate;
  
  ChatItemModel(this.name, this.mostRecentMessage, this.messageDate);
  
}
```

现在，为简洁起见，我省略了添加个人资料图片。

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

创建第一个列表后，结果如下：

![](https://cdn-images-1.medium.com/max/1600/1*WZq07uhmt7L-NYemQaRSRA.png)

我们可以类似地在其他屏幕上的屏幕上创建其他选项卡。完整的示例托管在GitHub上。

GitHub 链接 : [https://github.com/deven98/WhatsappFlutter](https://github.com/deven98/WhatsappFlutter)

感谢您阅读此 Flutter 挑战。随意提及您可能想要在 lutter 中重新创建的任何应用程序。如果你喜欢它，一定要留下掌声，再见。

不要忘了： [The Medium App in Flutter](https://blog.usejournal.com/flutter-challenge-the-medium-app-5f64a0f3c764)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
