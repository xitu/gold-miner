> * 原文地址：[Develop your first Application with Flutter](https://hackernoon.com/develop-your-first-application-with-flutter-60c4308d18b7)
> * 原文作者：[Gahfy](https://hackernoon.com/@Gahfy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md)
> * 译者：[mysterytony](https://github.com/mysterytony)
> * 校对者：

# 用 Flutter 开发你的第一个应用程序
# Develop your first Application with Flutter

![](https://cdn-images-1.medium.com/max/2000/1*P-bGlIkJPfxhVc4OsiXgCg.jpeg)

一周前，Flutter 在巴塞罗那的 MWC 上发布了第一款公测版本。本文的主要目的是向你展示如何用 Flutter 开发第一个功能齐全的应用程序。
One week ago, Flutter released its first bêta version at the MWC in Barcelona. The main purpose of this article is to show you how to develop a first fully functional application with Flutter.

这篇文章会描述安装过程和其是如何工作的，所以会比平时长一点。
This article will be a little bit longer than usual, because it will go through install process and also teach how Flutter works.

我们将开发一个向用户显示从 [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) 中检索的帖子列表的应用程序。
We will develop an application displaying to the user a list of posts retrieved from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/).

### 什么是 Flutter ？
### What is Flutter?

Flutter 是一款 SDK ，它可以让你开发基于安卓，iOS 或者 Google 的下一个操作系统 Fuschia 的原生应用。它使用 Dart 作为主要编程语言。
Flutter is an SDK that allows you to develop native applications for Android, iOS or the next OS of Google: Fuschia. It uses Dart as main programming language.

### 安装所需的工具
### Installing required tools

#### Git ，Android Studio 和 Xcode
#### Git, Android Studio and XCode

为了获取 Flutter ，你需要克隆其官方仓库。如果你想开发安卓应用，则还需要 Android Studio 。如果要开发 iOS 应用，则还需要 XCode 。
In order to get Flutter, you will need to clone the official repository. You will also need Android Studio if you want to develop applications for Android, and XCode if you want to develop applications for iOS.

#### IntelliJ IDEA
#### IntelliJ IDEA

你还需要 IntelliJ IDEA （这不是必须的，但是会很有用）。安装完成后，把 Dart 和 Flutter 插件添加到 IntelliJ IDEA。
You will also need IntelliJ IDEA (OK, it is not required, but much more useful). Once installed, add the Dart and Flutter plugins to IntelliJ IDEA.

#### 获取 Flutter
#### Retrieve Flutter

你所要做的就是克隆 Flutter 官方仓库：
All you have to do is to clone the official repository of Flutter:

```
git clone -b beta https://github.com/flutter/flutter.git
```

然后，你需要将把 bin 文件夹的路径添加到 PATH 环境变量中。就这样，你现在可以开始用 Flutter 开发应用程序了。
Then, you will have to add the path to the bin folder of the repository to your PATH environment variable. That’s it, you are now able to develop applications with Flutter.

虽然这已经足够了，为了不让这篇文章变得很长，我确实很快地结束了安装过程的讲解。如果你需要更完整的指南，请转至 [官方文档](https://flutter.io/get-started/install/)。
Even if it’s enough, I really went quickly through the installation procedure in order not to make this article longer than needed. If you want a more complete guide, go to the [official documentation](https://flutter.io/get-started/install/).

### 开发第一个项目
### Creating the first project

让我们现在打开 IntelliJ IDEA 并创建第一个项目。在左侧面板中，选择 Flutter （如果没有，就请将 Flutter 和 Dart 插件安装到你的 IDE 中）。
Let us now open IntelliJ IDEA and create a first project. In the left panel, choose Flutter (if it is not available, please install Flutter and Dart plugins to your IDE).

我们以以下方式命名：
We will name it as follow:

*   **项目名称**: feedme
*   **描述**: A sample JSON API project
*   **组织**: net.gahfy
*   **安卓语言**: Kotlin
*   **iOS 语言**: Swift
*   **Project name**: feedme
*   **Description**: A sample JSON API project
*   **Organization**: net.gahfy
*   **Android language**: Kotlin
*   **iOS language**: Swift

#### 运行第一个项目并探索 Flutter
#### Running the first project and discovering Flutter

IntelliJ 的编辑器打开了一个名为 `main.dart` 的文件，它是应用程序的主文件。如果你还不了解 Dart ，别慌，这个教程的剩下部分不时必须的。
The editor of IntelliJ opened a file named `main.dart`, which is the main file of the application. If you do not already know Dart, don’t panic, it is not required for the rest of this story.

现在，将安卓或 iOS 手机插入你的计算机，或运行一个模拟器。
Now, plug an Android or iOS phone in your computer, or run an emulator.

你现在可以通过点击右上角的运行按钮（带有绿色三角形）来运行该应用程序：
You are now able to run the application by clicking on the run button (with a green triangle) at the top right:

![](https://cdn-images-1.medium.com/max/800/1*RKDfTzmZjwwqj0_JzssYqQ.png)

点击底部浮动动作按钮来增加显示的数字。我们现在不会深入研究其代码，但我们会用 Flutter 发现一些有趣的功能。
Click on the bottom floating action button in order to increment the number displayed. We will not go deeply into he code for now, but we will instead discover some fun features with Flutter.

#### Flutter 热加载
#### Flutter Hot Reload

你可以看的到，这个应用的主要颜色是蓝色。我们可以改成红色。在 `main.dart` 文件中，找到以下代码：
As you can see, the primary color of this application is blue. Let us change this color to red. In the `main.dart` file, look for the following code:

```
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
In this part, replace `Colors.blue` by `Colors.red`. Flutter allows you to hot reload your application, meaning that nothing will be modified from the current state of the application, but our new code will be applied.

在应用程序中，点击底部浮动的 + 按钮开增加 counter 。
In the application, click on the + bottom floating action button to increment the counter.

然后，在 IntelliJ 右上角，点击 Hot Reload 按钮（带有黄色闪电）。你可以开到主要的颜色变成了红色，但是 counter 保持着一样的数字。
Then, on the top right of IntelliJ, click on the Hot Reload button (with a yellow lightning). You will see that the primary color is now red, but the counter remains with same number.

### 开发最终的应用程序
### Developing our final application

让我们现在删除 `main.dart` 文件里所有内容。岂不是一个很好的学习方式。
Let us now remove all the content of the `main.dart` file. What a better way to learn.

#### 最小的应用程序
#### Minimal application

我们要做的第一件事就是开发最小的应用程序，也就是能运行的最少代码。因为我们会用 Material Design 来设计我们的应用程序，所以首先要导入包含 Material Design Widgets 的包。
The first thing we will do now is to develop the minimal application, meaning the minimum code to be able to run it. As we will use Material Design for the design of our application, the first thing to do is to import package containing the Material Design Widgets:

```

import 'package:flutter/material.dart';
```

现在我们来创建一个继承 `StatelessWidget` 的类来创建我们应用程序的一个实例（之后会深入讨论 `StatelessWidget`）。
Let us now create a class extending `StatelessWidget` to make an instance of our application (we will go deeply into what a `StatelessWidget` is later in this article):

```
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
 
}
```

IntelliJ IDEA 在 MyApp 下显示红色下划线。实际上 `StatelessWidget` 是一个需要实现的 `build()` 方法的抽象类。为此，将光标移动到 MyApp 上，然后按 Alt + Enter 。
IntelliJ IDEA displays MyApp underlined in red. Actually `StatelessWidget` is an abstract class requiring the implementation of the `build()` method. To do so, move your cursor on MyApp and then press Alt+Enter.

```
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}
```

现在我们来实现 `build()` 方法，我们可以看到它必须返回一个 `Widget` 实例。我们要在这里构建应用程序时返回一个 `MaterialApp`。为此，在 `build()` 中添加以下代码。
Now that we implement the `build()` method we can see that it must return a `Widget` instance. We will return a `MaterialApp` as we are building the application here. To do so, add the following code in the `build()` method:

```
return new MaterialApp();
```

`MaterialApp` 的文档告诉我们至少要初始化 `home`，`routes`，`onGenerateRoute` 或者 `builder` 。我们只会在这里定义 `home` 属性。这将是应用程序的主界面。因为我们希望我们的应用程序是基于 Material Design 的布局，所以我们把 `home` 设置为一个空的 `Scaffold`：
The documentation of `MaterialApp` tells us that at least `home`, `routes`, `onGenerateRoute` or `builder` must be initialized. We will only define `home` property here. It will be the home screen of your application. Because we want our application to be a basic Material Design layout, we will set `home` as an empty `Scaffold`:

```
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

最后我们需要设置当我们运行 main.dart 时，我们想运行 `MyApp` 应用程序。为此，我们需要在导入语句后面添加以下行：
The last thing to do is to tell that when we run main.dart we want to run the `MyApp` application. To do so add the following line right after import statements:

```
void main() => runApp(new MyApp());
```

你现在已经可以运行你的应用程序。目前只是一个没有任何内容的白色界面。所以我们现在要做的第一件事就是添加一些用户界面。
You will now be able to run your application. It is only a white screen without any content. So the first thing we will do now is to add the user interface of the application.

### 开发用户界面
### Developing the User Interface

#### 几句关于状态的话
#### Few words about states

我们可能要开发两种用户界面。一种是与当前状态无关的用户界面或与之相关的用户界面。
We may develop two kind of user interface. A user interface which is not regarding to the current state of the application, or a user interface regarding it.

当谈到状态时，我们的意思是，当事件被触发时，用户界面可能会改变，这正是我们要做的：
When talking about states, we are meaning that the user interface may change when an event is triggered. And this exactly what we will do:

*   **应用程序启动事件:
    -** 显示循环进度条
    - 运行检索帖子的操作
*   **API 请求结束：**
    - 如果成功，显示检索帖子的结果
    - 如果失败， 在空白界面上显示带失败信息的 Snackbar
*   **Launching application event:
    -** Display the circular progress bar
    - Run the action to retrieve posts
*   **End of API request:**
    - If success, display the list of posts retrieved
    - If failure, display a Snackbar with failure message on an empty screen

目前，我们只用了 `StatelessWidget` ，正如里所猜测的那样，它并不涉及程序状态。因此，让我们先初始化一个 `StatefulWidget` 。
For now, we only used `StatelessWidget` which are, as you can guess, not regarding the state. So lets start by initializing a `StatefulWidget`.

#### 初始化 StatefulWidget
#### Initializing StatefulWidget

让我们添加一个继承 `StatefulWidget` 的类到我们的应用程序：
Let us add a class extending `StatefulWidget` to our application:

```
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
As we can see, we have to implement the `createState()` method which returns a `State` object. So let us create a class extending `State`:

```
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
As we can see we will have to implement `build()` method returning a Widget. In order to do so, let us first create an empty widget (`Row`) :

```
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
We actually return a `Scaffold` object as the toolbar of our application will not change nor depend on the current state. Only its body will depend on the state.

让我们现在创建一个方法，它将返回 Widget 以显示当前状态，以及一种返回一个包含居中的循环进度条的 Widget 的方法：
Let us now create a method that will return the Widget to display regarding the current state, and a method that will return the Widget containing the centered circular progress bar:

```
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
If you run the application now you will see a circular progress bar in the center.

### 显示帖子列表
### Displaying the list of posts

我们先定义 `Post` 对象，因为它是在 JSONPlaceholder API 中定义的。为此，创建一个包含以下内容的 `Post.dart` 文件：
We will start by defining the `Post` object as it is define in the JSONPlaceholder API. To do so, let us create a `Post.dart` file with the following content:

```
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
We will now define a `PostState` class in the same file to degine the current state of the application:

```
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
All we have to do now is to define a method in the `PostState` class to get the list of `Post` from the API. We will see how to do this later because for now we will only return a static list of `Post` asynchronously:

```
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
Now that it is done let us go back to our `PostPageState` class in the `main.dart` file to see how to use the class we just defined. We will start by initializing a `postState` property in the `PostPageState` class:

```
class _PostPageState extends State<PostPage>{
  final PostState postState = new PostState();
 
  // ...
}
```
> 如果 IntelliJ IDEA 在 `PostState` 下显示红色下划线，这意味着 `PostState` 类没有在当前文件中定义。所以你需要导入它。将光标移至红色下划线部分，然后按Alt + Enter ，然后选择导入。
> If IntelliJ IDEA displays `PostState` underlined in red, this means that the `PostState` class is not defined in the current file. So you will have to import it. To do so, move the cursor to the red underlined part and press Alt+Enter, then choose Import.

现在，让我们定义一个方法，当我们成功获取 `Post` 列表时就返回一个 Widget ：
Now, let us define a method for returning a Widget when we successfully get the list of `Post`:

```
Widget _getSuccessStateWidget(){
  return new Center(
    child: new Text(postState.posts.length.toString() + " posts retrieved")
  );
}
```

现在要做的就是如果我们成功获得 Post 的列表，编辑 `getCurrentStateWidget()` 方法来显示这个 Widget ：
All we have to do now is to edit the `getCurrentStateWidget()` method to display this Widget if we successfully get the list of Post:

```
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
Last thing to do, and maybe the most important one, is to run the request in order to retrieve the list of Post. To do so, we will define a `_getPosts()` method and call it when initializing the state:

```
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
Et voilà. You can run the application in order to see the result. Actually, there is almost no chance that you see the circular progress bar, even if it is actually displayed. This is because retrieving the list of Post is so fast that it is disappearing almost instantly.

#### 从 API 中检索帖子列表
#### Retrieving the list of Post from the API

为了确保实际显示循环进度条，让我们从 JSONPlaceholder API 中检索该帖子。如果我们看一下 [API 的 post 服务](https://jsonplaceholder.typicode.com/posts) ，我们可以看到它返回一个帖子的 JSON 数组。
In order to be sure that the circular progress bar is actually displayed, let us retrieve the post from the JSONPlaceholder API. If we take a look at the [post service of the API](https://jsonplaceholder.typicode.com/posts), we can see that it returns a JSON array of Post.

因此，我们必须先为 Post 类添加一个静态方法，以便将 Post 的 JSON 数组转换为 `Post` 列表：
So we will have to start by adding a static method to Post class in order to convert a JSON array of Post to a list of `Post`:

```
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
We now only have to edit the method retrieving the list of `Post` in the `PostState` class to actually retrieve it from the API:

```
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

你现在可以运行该应用程序，并根据你的互联网连接或多或少地看到循环进度条。
You now can run the application and you will see the circular progress bar more or less briefly depending on your internet connection.

#### 显示帖子列表
#### Displaying the list of posts

目前，我们只显示检索的帖子数量，但不会像我们预期的那样显示帖子列表。为了能够显示它，让我们编辑 `PostPageState` 类的 `_getSuccessStateWidget()` 方法：
For now, we only display the number of posts retrieved but not the list of Post as we expect. To be able to display it, let us edit the `_getSuccessStateWidget()` method of the `PostPageState` class:

```
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
If you run the application again you will see the list of posts.

### 处理错误
### Handling errors

我们还有最后一件事要做：处理错误。您可以尝试在飞行模式下运行应用程序，然后就可以看到无限循环进度条。所以我们要返回一个错误：
We have one last thing to do: handling the errors. You can try to run the application in flight mode, and you will see that you will see the circular progres bar indefinitely. We have to return an empty error state:

```
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

现在，当发生错误时，它会显示一个空白的界面。你可以随意更改内容来显示错误界面。但是我们说过，我们希望显示一个 Snackbar ，以便在出现错误时重试。为此，让我们在 `PostPageState` 类中开发 `showError()` 和 `retry()` 方法：
Now, when an error occurs, an empty screen is displayed. Feel free to change the content in order to display en error empty state screen. But we sayed that we want to display a Snackbar with ability to retry when an error occurs. To do so, let us develop a `showError()` and a `retry()` method in the `PostPageState` class:

```
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

正如我们所看到的，我们需要一个 `BuildContext` 来获得 `ScaffoldState` ，它可以让 Snackbar 出现并消失。但是我们必须使用 `Scaffold` 对象的 `BuildContext` 来获得 `ScaffoldState` 。为此，我们需要编辑 `PostPageState` 类的 `build()` 方法：
As we can see we need a `BuildContext` in order to get the `ScaffoldState` which is allowing us to make the Snackbar appear and disappear. But we have to use the `BuildContext` of a `Scaffold` object in order to get the `ScaffoldState`. To do so, we will have to edit the `build()` method of the `PostPageState` class:

```
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
Feel free to now run your application in flight mode, the Snackbar should be displayed. If you leave flight mode and then click on RETRY, you should see the list of Post.

### 总结
### Summary

我们了解了用 Flutter 开发一个功能齐全的应用程序并不困难。使用 Material Design 提供的元素，并且在 Android 和 iOS 平台上开发了一个应用程序。
So we learned that developing a fully functional application with Flutter is not something that much hard. Every elements of Material Design are provided, and you developed an application with it on both Android and iOS platforms.

该项目的所有源代码均可在 [Feed-Me Flutter project on GitHub](https://github.com/gahfy/feedme_flutter) 获得。
All the source code of this project is available on the [Feed-Me Flutter project on GitHub](https://github.com/gahfy/feedme_flutter).

* * *

如果你喜欢这篇文章，你可以关注 [我的推特](https://twitter.com/gahfy) 来获得下一篇的推送。
If you liked this article, feel free to [follow me on Twitter](https://twitter.com/gahfy) to get notified about next ones.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
