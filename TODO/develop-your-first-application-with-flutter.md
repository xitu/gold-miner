> * 原文地址：[Develop your first Application with Flutter](https://hackernoon.com/develop-your-first-application-with-flutter-60c4308d18b7)
> * 原文作者：[Gahfy](https://hackernoon.com/@Gahfy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO/develop-your-first-application-with-flutter.md)
> * 译者：
> * 校对者：

# Develop your first Application with Flutter

![](https://cdn-images-1.medium.com/max/2000/1*P-bGlIkJPfxhVc4OsiXgCg.jpeg)

One week ago, Flutter released its first bêta version at the MWC in Barcelona. The main purpose of this article is to show you how to develop a first fully functional application with Flutter.

This article will be a little bit longer than usual, because it will go through install process and also teach how Flutter works.

We will develop an application displaying to the user a list of posts retrieved from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/).

### What is Flutter?

Flutter is an SDK that allows you to develop native applications for Android, iOS or the next OS of Google: Fuschia. It uses Dart as main programming language.

### Installing required tools

#### Git, Android Studio and XCode

In order to get Flutter, you will need to clone the official repository. You will also need Android Studio if you want to develop applications for Android, and XCode if you want to develop applications for iOS.

#### IntelliJ IDEA

You will also need IntelliJ IDEA (OK, it is not required, but much more useful). Once installed, add the Dart and Flutter plugins to IntelliJ IDEA.

#### Retrieve Flutter

All you have to do is to clone the official repository of Flutter:

```
git clone -b beta https://github.com/flutter/flutter.git
```

Then, you will have to add the path to the bin folder of the repository to your PATH environment variable. That’s it, you are now able to develop applications with Flutter.

Even if it’s enough, I really went quickly through the installation procedure in order not to make this article longer than needed. If you want a more complete guide, go to the [official documentation](https://flutter.io/get-started/install/).

### Creating the first project

Let us now open IntelliJ IDEA and create a first project. In the left panel, choose Flutter (if it is not available, please install Flutter and Dart plugins to your IDE).

We will name it as follow:

*   **Project name**: feedme
*   **Description**: A sample JSON API project
*   **Organization**: net.gahfy
*   **Android language**: Kotlin
*   **iOS language**: Swift

#### Running the first project and discovering Flutter

The editor of IntelliJ opened a file named `main.dart`, which is the main file of the application. If you do not already know Dart, don’t panic, it is not required for the rest of this story.

Now, plug an Android or iOS phone in your computer, or run an emulator.

You are now able to run the application by clicking on the run button (with a green triangle) at the top right:

![](https://cdn-images-1.medium.com/max/800/1*RKDfTzmZjwwqj0_JzssYqQ.png)

Click on the bottom floating action button in order to increment the number displayed. We will not go deeply into he code for now, but we will instead discover some fun features with Flutter.

#### Flutter Hot Reload

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

In this part, replace `Colors.blue` by `Colors.red`. Flutter allows you to hot reload your application, meaning that nothing will be modified from the current state of the application, but our new code will be applied.

In the application, click on the + bottom floating action button to increment the counter.

Then, on the top right of IntelliJ, click on the Hot Reload button (with a yellow lightning). You will see that the primary color is now red, but the counter remains with same number.

### Developing our final application

Let us now remove all the content of the `main.dart` file. What a better way to learn.

#### Minimal application

The first thing we will do now is to develop the minimal application, meaning the minimum code to be able to run it. As we will use Material Design for the design of our application, the first thing to do is to import package containing the Material Design Widgets:

```

import 'package:flutter/material.dart';
```

Let us now create a class extending `StatelessWidget` to make an instance of our application (we will go deeply into what a `StatelessWidget` is later in this article):

```
import 'package:flutter/material.dart';
 
class MyApp extends StatelessWidget {
 
}
```

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

Now that we implement the `build()` method we can see that it must return a `Widget` instance. We will return a `MaterialApp` as we are building the application here. To do so, add the following code in the `build()` method:

```
return new MaterialApp();
```

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

The last thing to do is to tell that when we run main.dart we want to run the `MyApp` application. To do so add the following line right after import statements:

```
void main() => runApp(new MyApp());
```

You will now be able to run your application. It is only a white screen without any content. So the first thing we will do now is to add the user interface of the application.

### Developing the User Interface

#### Few words about states

We may develop two kind of user interface. A user interface which is not regarding to the current state of the application, or a user interface regarding it.

When talking about states, we are meaning that the user interface may change when an event is triggered. And this exactly what we will do:

*   **Launching application event:
    -** Display the circular progress bar
    - Run the action to retrieve posts
*   **End of API request:**
    - If success, display the list of posts retrieved
    - If failure, display a Snackbar with failure message on an empty screen

For now, we only used `StatelessWidget` which are, as you can guess, not regarding the state. So lets start by initializing a `StatefulWidget`.

#### Initializing StatefulWidget

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

We actually return a `Scaffold` object as the toolbar of our application will not change nor depend on the current state. Only its body will depend on the state.

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

If you run the application now you will see a circular progress bar in the center.

### Displaying the list of posts

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

Now that it is done let us go back to our `PostPageState` class in the `main.dart` file to see how to use the class we just defined. We will start by initializing a `postState` property in the `PostPageState` class:

```
class _PostPageState extends State<PostPage>{
  final PostState postState = new PostState();
 
  // ...
}
```

> If IntelliJ IDEA displays `PostState` underlined in red, this means that the `PostState` class is not defined in the current file. So you will have to import it. To do so, move the cursor to the red underlined part and press Alt+Enter, then choose Import.

Now, let us define a method for returning a Widget when we successfully get the list of `Post`:

```
Widget _getSuccessStateWidget(){
  return new Center(
    child: new Text(postState.posts.length.toString() + " posts retrieved")
  );
}
```

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

Et voilà. You can run the application in order to see the result. Actually, there is almost no chance that you see the circular progress bar, even if it is actually displayed. This is because retrieving the list of Post is so fast that it is disappearing almost instantly.

#### Retrieving the list of Post from the API

In order to be sure that the circular progress bar is actually displayed, let us retrieve the post from the JSONPlaceholder API. If we take a look at the [post service of the API](https://jsonplaceholder.typicode.com/posts), we can see that it returns a JSON array of Post.

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

You now can run the application and you will see the circular progress bar more or less briefly depending on your internet connection.

#### Displaying the list of posts

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

If you run the application again you will see the list of posts.

### Handling errors

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

Feel free to now run your application in flight mode, the Snackbar should be displayed. If you leave flight mode and then click on RETRY, you should see the list of Post.

### Summary

So we learned that developing a fully functional application with Flutter is not something that much hard. Every elements of Material Design are provided, and you developed an application with it on both Android and iOS platforms.

All the source code of this project is available on the [Feed-Me Flutter project on GitHub](https://github.com/gahfy/feedme_flutter).

* * *

If you liked this article, feel free to [follow me on Twitter](https://twitter.com/gahfy) to get notified about next ones.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
