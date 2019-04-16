> * 原文地址：[Develop your first Application with Flutter](https://hackernoon.com/develop-your-first-application-with-flutter-60c4308d18b7)
> * 原文作者：[Gahfy](https://hackernoon.com/@Gahfy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md)
> * 译者：[mysterytony](https://github.com/mysterytony)
> * 校对者：[rockzhai](https://github.com/rockzhai), [zhaochuanxing](https://github.com/zhaochuanxing)

# 用 Flutter 开发你的第一个应用程序

![](https://cdn-images-1.medium.com/max/2000/1*P-bGlIkJPfxhVc4OsiXgCg.jpeg)

一周前，Flutter 在巴塞罗那的 MWC 上发布了第一版公测版本。本文的主要目的是向你展示如何用 Flutter 开发第一个功能齐全的应用程序。

这篇文章会介绍 Flutter 的安装过程和工作原理，所以会比平时长一点。

我们将开发一个向用户显示从 [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) 中检索的帖子列表的应用程序。

### 什么是 Flutter ？

Flutter 是一款 SDK，它可以让你开发基于 Android，iOS 或者 Google 的下一个操作系统 Fuschia 的原生应用。它使用 Dart 作为主要编程语言。

### 安装所需的工具

#### Git，Android Studio 和 XCode

为了获取 Flutter，你需要克隆其官方仓库。如果你想开发 Android 应用，则还需要 Android Studio 。如果要开发 iOS 应用，则还需要 XCode 。

#### IntelliJ IDEA

你还需要 IntelliJ IDEA（这不是必须的，但是会很有用）。安装完 IntelliJ IDEA 之后，把 Dart 和 Flutter 插件添加到 IntelliJ IDEA。

#### 获取 Flutter

你所要做的就是克隆 Flutter 官方仓库：

``` bash
git clone -b beta https://github.com/flutter/flutter.git
```

然后，你需要将把 bin 文件夹的路径添加到 PATH 环境变量中。就这样，你现在可以开始用 Flutter 开发应用程序了。

虽然这已经足够了，为了不让这篇文章显得冗长，我缩短了安装过程的讲解。如果你需要更完整的指南，请转至 [官方文档](https://flutter.io/get-started/install/)。

### 开发第一个项目

让我们现在打开 IntelliJ IDEA 并创建第一个项目。在左侧面板中，选择 Flutter （如果没有，就请将 Flutter 和 Dart 插件安装到你的 IDE 中）。

我们以以下方式命名：

*   **项目名称**: feedme
*   **描述**: A sample JSON API project
*   **组织**: net.gahfy
*   **Android 语言**: Kotlin
*   **iOS 语言**: Swift

#### 运行第一个项目并探索 Flutter

IntelliJ 的编辑器打开了一个名为 `main.dart` 的文件，它是应用程序的主文件。如果你还不了解 Dart，别慌，这个教程的剩下部分不时必须的。

现在，将 Android 或 iOS 手机插入你的计算机，或运行一个模拟器。

你现在可以通过点击右上角的运行按钮（带有绿色三角形）来运行该应用程序：

![](https://cdn-images-1.medium.com/max/800/1*RKDfTzmZjwwqj0_JzssYqQ.png)

点击底部浮动动作按钮来增加显示的数字。我们现在不会深入研究其代码，但我们会用 Flutter 发现一些有趣的功能。

#### Flutter 热重载

你可以看到，这个应用的主要颜色是蓝色。我们可以改成红色。在 `main.dart` 文件中，找到以下代码：

``` dart
return new MaterialApp(
  title: 'Flutter Demo',
  theme: new ThemeData(
    // This is the theme of your application.
    //
    // Try running your application with "flutter run". You'll see the
    // application has a blue toolbar. Then, without quitting the app, try
    // changing the primarySwatch below to Colors.green and then invoke
    // "hot reload" (press "r" in the console where you ran "flutter run",
    // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
    // counter didn't reset back to zero; the application is not restarted.
    primarySwatch: Colors.blue,
  ),
  home: new MyHomePage(title: 'Flutter Demo Home Page'),
);
```

在这个部分，用 `Colors.red` 来代替 `Colors.blue`。Flutter 允许你热加载应用程序，也就是说应用程序的当前状态不会被修改，但是会使用新的代码。

在应用程序中，点击底部浮动的 + 按钮开增加 counter 。

然后，在 IntelliJ 右上角，点击 Hot Reload 按钮（带有黄色闪电）。你可以开到主要的颜色变成了红色，但是 counter 保持着一样的数字。

### 开发最终的应用程序

让我们现在删除 `main.dart` 文件里所有内容，这岂不是一个更好的学习方式吗。

#### 最小的应用程序

我们要做的第一件事就是开发最小的应用程序，也就是能运行的最少代码。因为我们会用 Material Design 来设计我们的应用程序，所以首先要导入包含 Material Design Widgets 的包。

``` dart
import 'package:flutter/material.dart';
```

现在我们来创建一个继承 `StatelessWidget` 的类来创建我们应用程序的一个实例（之后会深入讨论 `StatelessWidget`）。

``` dart
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
 
}
```

IntelliJ IDEA 在 MyApp 下显示红色下划线。实际上 `StatelessWidget` 是一个需要实现 `build()` 方法的抽象类。为此，将光标移动到 MyApp 上，然后按 Alt + Enter 。

``` dart
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}
```

现在我们来实现 `build()` 方法，我们可以看到它必须返回一个 `Widget` 实例。我们要在这里构建应用程序时返回一个 `MaterialApp`。为此，在 `build()` 中添加以下代码：

``` dart
return new MaterialApp();
```

`MaterialApp` 的文档告诉我们至少要初始化 `home`，`routes`，`onGenerateRoute` 或者 `builder` 。我们只会在这里定义 `home` 属性。这将是应用程序的主界面。因为我们希望我们的应用程序是基于 Material Design 的布局，所以我们把 `home` 设置为一个空的 `Scaffold`：

``` dart
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold()
    );
  }
}
```

最后我们需要设置当运行 main.dart 时，我们想运行 `MyApp` 应用程序。因此，我们需要在导入语句后面添加以下行：

``` dart
void main() => runApp(new MyApp());
```

你现在已经可以运行你的应用程序。目前只是一个没有任何内容的白色界面。所以我们现在要做的第一件事就是添加一些用户界面。

### 开发用户界面

#### 几句关于状态的话

我们可能要开发两种用户界面。一种是与当前应用状态无关的用户界面，而另一种是与当前状态相关的用户界面。

当谈到状态时，我们的意思是，当事件被触发时，用户界面可能会改变，这正是我们要做的：

*   **应用程序启动事件:
    -** 显示循环进度条
    - 运行检索帖子的操作
*   **API 请求结束：**
    - 如果成功，显示检索帖子的结果
    - 如果失败， 在空白界面上显示带失败信息的 Snackbar

目前，我们只用了 `StatelessWidget`，正如你所猜测的那样，它并不涉及程序状态。那么让我们先初始化一个 `StatefulWidget` 。

#### 初始化 StatefulWidget

让我们添加一个继承 `StatefulWidget` 的类到我们的应用程序：

``` dart
import 'package:flutter/material.dart';
 
void main() => runApp(new MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new PostPage()
    );
  }
}
 
class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);
 
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  }
}
```

像我们看到的一样，我们需要实现返回一个 `State` 对象的 `createState()` 方法。所以让我们创建一个继承 `State` 的类：

``` dart
class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);
 
  @override
  _PostPageState createState() => new _PostPageState();
}
 
class _PostPageState extends State<PostPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}
```

就像看到的，我们需要实现 `build()` 方法，让它返回一个 Widget 。为此，我们先创建一个空部件 （`Row`）：

``` dart
class _PostPageState extends State<PostPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('FeedMe'),
        ),
        body: new Row()//TODO add the widget for current state
    );
  }
}
```

我们事实上返回了一个 `Scaffold` 对象，因为我们应用程序的工具栏不会改变，也不依赖于当前状态。只是他的 body 会取决于当前状态。

让我们现在创建一个方法，它将返回 Widget 以显示当前状态，以及一种返回一个包含居中的循环进度条的 Widget 的方法：

``` dart
class _PostPageState extends State<PostPage>{
  Widget _getLoadingStateWidget(){
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
 
  Widget getCurrentStateWidget(){
    Widget currentStateWidget;
    currentStateWidget = _getLoadingStateWidget();
    return currentStateWidget;
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('FeedMe'),
        ),
        body: getCurrentStateWidget()
    );
  }
}
```

如果你现在运行这个应用程序，你会看到一个居中的循环进度条。

### 显示帖子列表

我们先定义 `Post` 对象，因为它是在 JSONPlaceholder API 中定义的。为此，创建一个包含以下内容的 `Post.dart` 文件：

``` dart
class Post {
  final int userId;
 
  final int id;
 
  final String title;
 
  final String body;
 
  Post({
    this.userId,
    this.id,
    this.title,
    this.body
  });
}
```

现在我们在同一个文件中定义一个 `PostState` 类来设计应用程序的当前状态：

``` dart
class PostState{
  List<Post> posts;
  bool loading;
  bool error;
 
  PostState({
    this.posts = const [],
    this.loading = true,
    this.error = false,
  });
 
  void reset(){
    this.posts = [];
    this.loading = true;
    this.error = false;
  }
}
```

现在要做的就是在 `PostState` 类中定义一个方法来从 API 中获取 `Post` 的列表。稍后我们将看到如何做到这一点，因为现在我们只能异步地返回一个静态的 `Post` 列表：

``` dart
Future<void> getFromApi() async{
  this.posts = [
    new Post(userId: 1, id: 1, title: "Title 1", body: "Content 1"),
    new Post(userId: 1, id: 2, title: "Title 2", body: "Content 2"),
    new Post(userId: 2, id: 3, title: "Title 3", body: "Content 3"),
  ];
  this.loading = false;
  this.error = false;
}
```

现在完成了，让我们回到 `main.dart` 文件中的 `PostPageState` 类来看看如何使用我们刚定义的类。我们在 `PostPageState` 类中初始化一个 `postState` 属性：

``` dart
class _PostPageState extends State<PostPage>{
  final PostState postState = new PostState();
 
  // ...
}
```
> 如果 IntelliJ IDEA 在 `PostState` 下显示红色下划线，这意味着 `PostState` 类没有在当前文件中定义。所以你需要导入它。将光标移至红色下划线部分，然后按Alt + Enter，然后选择导入。

现在，让我们定义一个方法，当我们成功获取 `Post` 列表时就返回一个 Widget ：

``` dart
Widget _getSuccessStateWidget(){
  return new Center(
    child: new Text(postState.posts.length.toString() + " posts retrieved")
  );
}
```

如果我们成功获得 Post 的列表，现在要做的就是编辑 `getCurrentStateWidget()` 方法来显示这个 Widget ：

``` dart
Widget getCurrentStateWidget(){
  Widget currentStateWidget;
  if(!postState.error && !postState.loading) {
    currentStateWidget = _getSuccessStateWidget();
  }
  else{
    currentStateWidget = _getLoadingStateWidget();
  }
  return currentStateWidget;
}
```

最后要做的，也许最重要的一件事就是运行请求以检索 Post 的列表。为此，定义一个 `_getPosts()` 方法并在初始化状态时调用它：

``` dart
@override
void initState() {
  super.initState();
  _getPosts();
}
 
_getPosts() async {
  if (!mounted) return;
 
  await postState.getFromApi();
  setState((){});
}
```

当当当，你可以运行应用程序来看结果。实际上，即使真的显示了循环进度条，也几乎没有机会看得到。这是因为检索 Post 的列表非常快，以致它几乎立即消失。

#### 从 API 中检索帖子列表

为了确保实际显示循环进度条，让我们从 JSONPlaceholder API 中检索该帖子。如果我们看一下 [API 的 post 服务](https://jsonplaceholder.typicode.com/posts)，我们可以看到它返回一个帖子的 JSON 数组。

因此，我们必须先为 Post 类添加一个静态方法，以便将 Post 的 JSON 数组转换为 `Post` 列表：

``` dart
static List<Post> fromJsonArray(String jsonArrayString){
  List data = JSON.decode(jsonArrayString);
  List<Post> result = [];
  for(var i=0; i<data.length; i++){
    result.add(new Post(
        userId: data[i]["userId"],
        id: data[i]["id"],
        title: data[i]["title"],
        body: data[i]["body"]
    ));
  }
  return result;
}
```

我们现在只需编辑检索 `PostState` 类中的 `Post` 列表的方法，让它从 API 真正地检索帖子：

``` dart
Future<void> getFromApi() async{
  try {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      this.posts = Post.fromJsonArray(json);
      this.loading = false;
      this.error = false;
    }
    else{
      this.posts = [];
      this.loading = false;
      this.error = true;
    }
  } catch (exception) {
    this.posts = [];
    this.loading = false;
    this.error = true;
  }
}
```

你现在可以运行该应用程序，根据网速或多或少地可以看到循环进度条。

#### 显示帖子列表

目前，我们只显示检索的帖子数量，但不会像我们预期的那样显示帖子列表。为了能够显示它，让我们编辑 `PostPageState` 类的 `_getSuccessStateWidget()` 方法：

``` dart
Widget _getSuccessStateWidget(){
  return new ListView.builder(
    itemCount: postState.posts.length,
    itemBuilder: (context, index) {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(postState.posts[index].title,
            style: new TextStyle(fontWeight: FontWeight.bold)),
 
          new Text(postState.posts[index].body),
 
          new Divider()
        ]
      );
    }
  );
}
```

如果再次运行应用程序，你就会看到帖子列表。

### 处理错误

我们还有最后一件事要做：处理错误。您可以尝试在飞行模式下运行应用程序，然后就可以看到无限循环进度条。所以我们要返回一个空白错误：

``` dart
Widget _getErrorState(){
  return new Center(
    child: new Row(),
  );
}
 
Widget getCurrentStateWidget(){
  Widget currentStateWidget;
  if(!postState.error && !postState.loading) {
    currentStateWidget = _getSuccessStateWidget();
  }
  else if(!postState.error){
    currentStateWidget = _getLoadingStateWidget();
  }
  else{
    currentStateWidget = _getErrorState();
  }
  return currentStateWidget;
}
```

现在，当发生错误时，它会显示一个空白的界面。你可以随意更改内容来显示错误界面。但是我们说过，我们希望显示一个 Snackbar，以便在出现错误时重试。为此，让我们在 `PostPageState` 类中开发 `showError()` 和 `retry()` 方法：

``` dart
class _PostPageState extends State<PostPage>{
  // ...
  BuildContext context;
 
  // ...
  _retry(){
    Scaffold.of(context).removeCurrentSnackBar();
    postState.reset()
    setState((){});
    _getPosts();
  }
 
  void _showError(){
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("An unknown error occurred"),
      duration: new Duration(days: 1), // Make it permanent
      action: new SnackBarAction(
        label : "RETRY",
        onPressed : (){_retry();}
      )
    ));
  }
 
  //...
}
```

正如我们所看到的，我们需要一个 `BuildContext` 来获得 `ScaffoldState`，它可以让 Snackbar 出现并消失。但是我们必须使用 `Scaffold` 对象的 `BuildContext` 来获得 `ScaffoldState` 。为此，我们需要编辑 `PostPageState` 类的 `build()` 方法：

``` dart
Widget currentWidget = getCurrentStateWidget();
return new Scaffold(
    appBar: new AppBar(
      title: new Text('FeedMe'),
    ),
    body: new Builder(builder: (BuildContext context) {
      this.context = context;
      return currentWidget;
    })
);
```

现在在飞行模式下运行你的应用程序，它现在就会显示 Snackbar 了。如果您离开飞行模式，然后点击重试，就可以看到帖子了。

### 总结

我们了解了用 Flutter 开发一个功能齐全的应用程序并不困难。所有 Material Design 的元素都是被提供的，并且就在刚刚，你用它们在 Android 和 iOS 平台上开发了一个应用程序。

该项目的所有源代码均可在 [Feed-Me Flutter project on GitHub](https://github.com/gahfy/feedme_flutter) 获得。

* * *

如果你喜欢这篇文章，你可以关注 [我的推特](https://twitter.com/gahfy) 来获得下一篇的推送。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
