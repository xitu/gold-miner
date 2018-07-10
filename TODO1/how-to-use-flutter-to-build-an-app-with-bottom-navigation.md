> * 原文地址：[How to use Flutter to build an app with bottom navigation](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 原文作者：[Joseph Cherry](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 如何使用 Flutter 来创建一个带有底部导航的应用程序

![](https://images.ctfassets.net/3cttzl4i3k1h/6zwT0UszrUmYQq8MWm2G4K/cceed7b9aeda5e862a3927fb02913c15/3-01.png?w=1400&h=600&q=80&fm=&f=&fit=fill)

如果你从事移动开发，你可能听说过谷歌的跨平台SDK：Flutter。Flutter 的[beta 版本](https://medium.com/flutter-io/announcing-flutter-beta- build-beautiful-native-apps-dc142aea74c0) 于 2 月 27 日发布，并于近期发布了第一个预览版。为了帮助您开始使用Flutter，本教程将介绍 SDK 的一些基内容，同时还将介绍如何设置底部导航条。为了帮助您继续学习，本教程的代码可以在 [GitHub](https://github.com/JoeCherry/my_app)上获得。


### 什么是 Flutter?


在我们开始编写代码之前，让我们先谈谈什么是 Flutter。Flutter SDK 搭载了一个完整框架，其中包括在 Android 和 iOS 上构建本地移动应用所需的部件和工具。与其他诸如 React Native 和 Xamarin 等跨平台框架的区别在于，它不使用原生的底层部件，也不使用 webview。相反，Flutter 有自己的用 C/C++ 编写的渲染引擎，而用来编写 Flutter 应用程序的 Dart 代码在各个平台上都可以编译成底层代码。这就使的在每个平台上都能做出高性能的应用。不仅应用的使用体验感觉快，而且通过 Flutter 的热加载特性也大大加快了开发时间。热加载允许开发人员在他们的设备或模拟器上立即显示修改内容的变化效果，由此可以节省那些浪费在等待代码编译的时间。


### 如何创建一个 Flutter 应用


现在我们已经了解了 Flutter 是什么，让我们开始创建我们的应用程序。如果您还没有准备好环境，请按照 [Flutter网站](https://flutter.io/get-started/install/)的步骤安装 Flutter SDK。要创建应用程序，请运行“flutter create my_app”。如果您想让您的应用程序使用 Swift 或 Kotlin 作为平台特定代码，那么您可以从终端或命令行运行“flutter create -i Swift -a Kotlin my_app”。打开你创建的新项目，你可以使用安装了 Dart 插件的 VS Code 或者安装了 Flutter 和 Dart 插件的 Android Studio。如果您需要编辑器安装的帮助，请再参考 Flutter 的 [帮助文档](https://flutter.io/get-started/editor/#androidsstudio)。

#### 第 1 步 定义入口点

让我们从打开 `main.dart` 文件开始，该文件位于 `lib/` 目录下。接着，由于我们要从头开始编写应用程序，所以删除文件中的所有代码。这个文件是我们应用程序的入口点。在文件的开始编写:

```
import 'package:flutter/material.dart';
```

这就引入了 Flutter SDK 提供的 Material Design widgets。如果您想查看所提供的所有的 widget，可以在 [Widget 目录](https://flutter.io/widgets/) 中检查它们。


在引入语句之后，我们需要添加 main 方法。

```
void main() => runApp(App());
```

如果您在添加 main 方法后看到一些错误，不要担心。这是因为我们还没有创建传递给 `runApp` 函数的 `App` 部件类。`runApp` 函数接收一个类型为 `Widget` 的类，并将它作为 root widget 运行。


现在我们要创建我们的 `App` widget。还是在 `main.dart` 里面的 main 方法下面添加以下的代码。

```
class App extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'My Flutter App',
     home: Home(),
   );
 }
}
```

这就创建了一个新的无状态 widget `App`。之所以是一个无状态 widget，因为它的构建方法中没有任何内容依赖于状态更新。所有的 `StatelessWidgets` 都需要实现 `build` 方法，因为这是我们创建用户界面的地方。在我们的 `App` widget 中，我们简单地创建了一个新的 `MaterialApp`，并将 `Home` 属性设置为我们希望显示的第一个页面或 widget。在本例中，我们把它设置为 `Home` widget，我们将在接下来创建这个 widget。

#### 第 2 步 创建主页

在 `lib` 目录下，创建一个新文件，并将其命名为 `home_widget.dart`。在这个文件的头部，我们需要再次引入 material widgets。

```
import 'package:flutter/material.dart';
```

接下来，我们将创建作为我们主页的 widget。为此，我们将创建一个新的 `StatefulWidget`。当用户界面根据应用程序的当前状态发生变化时，`StatefulWidget` 就派上用场了。例如，我们将使用底部导航条，我们的“Home”小部件将根据当前选择的选项卡呈现不同的小部件。首先，在导入语句下面添加以下代码。

```
class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}
```

您可能会注意到，这个小部件类没有实现我们前面提到的需要的构建方法。当涉及到“有状态窗口小部件”时，构建方法在小部件对应的“状态”类中实现。在“StatefulWidge not”中，唯一需要的方法是我们在上面实现的“createState”方法，我们只返回' _HomeState '类的一个实例。类名前面的“_”是Dart将类或类属性标记为private的方式。我们现在需要创建home小部件的状态类。在“home_widget”末尾添加这个。飞镖的文件:

```
class _HomeState extends State<Home> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('My Flutter App'),
     ),
     bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.mail),
           title: new Text('Messages'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),
           Title: Text('Profile')
         )
       ],
     ),
   );
 }
}
```

这里有很多内容，我们来看看。在“_HomeState”类中，我们实现了“Home”小部件的构建方法。我们从构建方法返回的小部件称为“Scaffold”。这个小部件有一些很好的属性，可以帮助我们布置主屏幕，包括添加底部导航条、滑动抽屉和选项卡条。我们现在只使用它的“appBar”和“bottomNavigationBar”属性。在我们的底部导航栏中，我们返回一个列表，其中列出了我们希望在底部栏中出现的项目。如您所见，我们有三个选项卡，分别是Home、message和Profile。我们还将当前索引作为属性设置为0。稍后我们将把它连接起来，以反映当前选项卡。当前索引是导航条如何知道要将哪个图标作为当前选择的选项卡动画。


此时，我们几乎已经准备好第一次运行Flutter应用，并看到我们的努力得到了回报。飞镖文件。在顶部，我们需要导入新创建的Home小部件。我们可以通过在当前的导入语句下添加这个导入语句来实现这一点。

```
import 'home_widget.dart';
```

我们现在应该可以运行我们的应用了。你可以在Visual Studio代码中的任何Dart文件中按F5，在Android Studio中点击run按钮，或者在终端中输入“flutter run”。如果您需要帮助设置一个模拟器或模拟器来运行您的应用程序，请参考Flutter的文档。如果一切顺利，你的应用应该是这样的。

![flutter1](//images.ctfassets.net/3cttzl4i3k1h/6yqGn7yZ0c0wsYSQUyka2y/b34fbe9ff45aec6cc7ce77e1926e90df/flutter1.png)

太棒了!我们有一个应用程序，它有一个很好的底部导航条。然而，有一个问题。我们的导航条不会在任何地方导航!现在让我们解决这个问题。

#### 步骤3。准备导航

回到“home_widget”。因为我们需要对“_HomeState”类做一些更改，所以需要使用dart '文件。在类的顶部，我们需要添加两个新的实例属性。

```
 class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
...
```

第一个将跟踪当前所选选项卡的索引，另一个将是我们希望基于当前所选选项卡呈现的小部件列表。


接下来，我们需要使用这些属性来告诉我们的小部件，当一个新选项卡被选中时需要显示什么。为此，我们需要对构建方法返回的scaffold小部件进行一些更改。这是我们的新构建方法。

```
@override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('My Flutter App'),
     ),
     body: _children[_currentIndex], // new
     bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.home),
           title: Text('Home'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.mail),
           title: Text('Messages'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Profile')
         )
       ],
     ),
   );
 }
```

我们的构建方法中更改的三行被用' // new '注释。首先，我们添加了scaffold的主体，即在应用程序条和底部导航条之间显示的小部件。我们将主体设置为“_children”小部件列表中相应的小部件。接下来，我们添加了底部导航条的“onTap”属性。我们将它设置为一个名为“ontabtap”的函数，该函数将接收被选中的选项卡的索引并决定如何处理它。我们马上就会实现这个函数。最后，我们将底部导航条的“currentIndex”设置为状态的“_currentIndex”属性中的当前索引。

#### 步骤4。处理导航

现在，我们将添加上一步中提到的“ontabtap”函数。在“_HomeState”类的底部添加以下函数。

```
void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
```

这个函数接受被选中的选项卡的索引，并在我们的state类上调用“setState”。这将触发构建方法以我们传递给它的状态再次运行。在本例中，我们将发送更新的选项卡索引，该索引将更改scaffold小部件的主体，并将导航条激活到正确的选项卡。

#### 第5步。添加子小部件

我们的应用程序即将完成。最后一步将包括为“_children”小部件列表创建小部件并添加到导航条。首先在lib文件夹下创建一个名为“placeholder_widget.dart”的新文件。这个文件将作为一个简单的“StatelessWidget”来使用背景颜色。

```
import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
 final Color color;

 PlaceholderWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Container(
     color: color,
   );
 }
}
```

现在我们要做的就是向导航栏中添加“PlaceholderWidget”。在“home_widget”的顶部。我们需要导入小部件的dart文件。

```
import 'placeholder_widget.dart';
```

然后，我们要做的就是将这些小部件添加到“_children”列表中，以便在选择新选项卡时呈现它们。

```
class _HomeState extends State<Home> {
 int _currentIndex = 0;
 final List<Widget> _children = [
   PlaceholderWidget(Colors.white),
   PlaceholderWidget(Colors.deepOrange),
   PlaceholderWidget(Colors.green)
 ];
...
```

就是这样!现在应该可以运行应用程序并在选项卡之间切换了。如果您想要看到Flutter的hot reload特性，请尝试更改任何“BottomNavigationBarItems”。值得注意的是，更改传递给“PlaceholderWidgets”的颜色不会在热重载期间反映出来，因为Flutter将保持“StatefulWidget”的状态。

![image1](//images.ctfassets.net/3cttzl4i3k1h/4XtVKoNlS06cKkm8AMmgey/d41905e98f2c7c4fd2a52a7a85b2a700/image1.gif)

### 结论

在本教程中，我们学习了如何设置一个新的Flutter应用程序并使底部导航条工作。像Flutter这样的跨平台工具在移动领域越来越流行，因为它们提供的开发时间减少了。Flutter是这些工具的独特之处，因为它不需要使用平台本地小部件或webview。目前采用Flutter的主要缺点之一是缺少对特性的第三方支持。然而，Flutter仍然是一种很有前途的工具，它可以编写出看起来很棒的跨平台应用程序，而不必牺牲性能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
