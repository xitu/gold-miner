> * 原文地址：[How to use Flutter to build an app with bottom navigation](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 原文作者：[Joseph Cherry](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[DateBro](https://github.com/DateBro)

# 如何用 Flutter 来创建一个带有底部导航栏的应用程序

![](https://images.ctfassets.net/3cttzl4i3k1h/6zwT0UszrUmYQq8MWm2G4K/cceed7b9aeda5e862a3927fb02913c15/3-01.png?w=1400&h=600&q=80&fm=&f=&fit=fill)

如果你从事移动开发，你可能听说过谷歌的跨平台 SDK：Flutter。Flutter 的 [beta 版本](https://medium.com/flutter-io/announcing-flutter-beta- build-beautiful-native-apps-dc142aea74c0) 于 2 月 27 日发布，并于近期发布了第一个预览版。为了帮助您开始使用 Flutter，本教程将介绍 SDK 的一些基本内容，同时还将介绍如何设置底部导航栏。为了帮助您学习，本教程的代码可以在 [GitHub](https://github.com/JoeCherry/my_app)上获得。

### 什么是 Flutter？

在我们开始编写代码之前，让我们先谈谈什么是 Flutter。Flutter SDK 继承了一套完整的开发框架，包括在 Android 和 iOS 上构建原生移动应用所需的 widget 和工具。与其他诸如 React Native 和 Xamarin 等跨平台框架的区别在于，它不使用平台原生 widget，也不使用 webview。相反，Flutter 有自己的用 C/C++ 编写的渲染引擎，而用来编写 Flutter 应用程序的 Dart 代码在各个平台上都可以编译成底层代码。这就可以在每个平台上都能做出高性能的应用。不仅应用在使用体验上非常快，而且通过 Flutter 的热重载特性也大大加快了开发时间。热重载允许开发人员在他们的设备或模拟器上立即显示修改内容的变化效果，由此可以减少那些浪费在等待代码编译的时间。

### 如何创建一个 Flutter 应用

现在我们已经了解了 Flutter 是什么，让我们开始创建我们的应用程序。如果您还没有准备好开发环境，请按照 [Flutter 网站](https://flutter.io/get-started/install/)的步骤安装 Flutter SDK。要创建应用程序，请运行“flutter create my_app”。如果您想让您的应用程序使用 Swift 或 Kotlin 作为平台特定代码，那么您可以从终端或命令行运行“flutter create -i Swift -a Kotlin my_app”。打开你创建的新项目，你可以使用安装了 Dart 插件的 VS Code 或者安装了 Flutter 和 Dart 插件的 Android Studio。如果您需要编辑器安装的相关帮助，请参考 Flutter 的 [帮助文档](https://flutter.io/get-started/editor/#androidsstudio)。

#### 第一步 定义入口点

让我们从打开 `main.dart` 文件开始，该文件位于 `lib/` 目录下。接下来，由于我们要从头开始编写应用程序，所以删除文件中的所有代码。这个文件是我们应用程序的入口点。在文件的开始编写:

```
import 'package:flutter/material.dart';
```

这就导入了 Flutter SDK 提供的 Material Design widgets。如果您想查看所有提供的 widget，可以在 [Widget 目录](https://flutter.io/widgets/) 中查看。

在导入语句之后，我们需要添加 main 方法。

```
void main() => runApp(App());
```

如果您在添加 main 方法后看到一些错误，不要担心。这是因为我们还没有创建传递给 `runApp` 函数的 `App` widget 类。`runApp` 函数接收一个类型为 `Widget` 的类，并将它作为 root widget 运行。


现在我们要创建我们的 `App` widget。还是在 `main.dart` 里面，在 main 方法下面添加以下的代码。

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

这就创建了一个新的无状态 widget `App`。之所以是一个无状态 widget，因为它的构建方法中没有任何内容会依赖于状态更新。所有的 `StatelessWidgets` 都需要实现 `build` 方法，因为这是我们创建用户界面的地方。在我们的 `App` widget 中，我们简单地创建了一个新的 `MaterialApp`，并将 `Home` 属性设置为我们希望显示的第一个页面或 widget。在本例中，我们把它设置为 `Home` widget，我们将在接下来创建这个 widget。

#### 第二步 创建主页

在 `lib` 目录下，创建一个新文件，并将其命名为 `home_widget.dart`。在这个文件的头部，我们需要再次导入 material widgets。

```
import 'package:flutter/material.dart';
```

接下来，我们将创建作为我们主页的 widget。为此，我们将创建一个新的 `StatefulWidget`。当用户界面需要根据应用程序的当前状态发生变化时，`StatefulWidget` 就派上用场了。例如，现在我们要使用底部导航栏，我们的 `Home` widget 将根据当前选定的选项卡来渲染出不同的 widget。首先，在导入语句下面添加以下代码。

```
class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}
```

您可能会注意到，这个 widget 类没有实现我们前面提到的 build 方法。当涉及到 `StatefulWidgets` 时，build 方法会在 widget 对应的 `State` 类中实现。在 `StatefulWidget` 中，唯一需要的方法是我们在上面实现的 `createState` 方法，我们只返回一个 `_HomeState` 类实例。类名前面的 `“_”` 代表 Dart 将类或类属性标记为 private。我们现在需要创建 home widget 的 state 类。在 `home_widget.dart` 文件的末尾添加这个段代码：

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

这里有很多内容，我们来逐一看看。在 `_HomeState` 类中，我们实现了 `Home` widget 的 build 方法。我们从 build 方法返回的 widget 叫做 `Scaffold`。这个 widget 有一些很棒的属性，可以帮助我们布置主屏幕，包括添加底部导航栏、滑动条和选项卡。我们现在只使用它的 `appBar` 和 `bottomNavigationBar` 属性。在我们的底部导航栏中，我们返回一个列表，其中列出了我们希望在底部栏中出现的项目。如您所见，我们有三个选项卡，分别是 Home、Message 和 Profile。我们还将当前索引作为属性设置为 0。稍后我们将把它与当前选项卡联系起来。当前索引可以让导航栏知道要将哪个图标用于当前选择的选项卡。

此时，我们差不多已经准备好第一次运行 Flutter 应用了，来看看我们的成果。再回到 main.dart 文件，在顶部，我们需要导入新创建的 Home widget。我们可以通过在当前的导入语句下添加下面这个导入语句来实现。

```
import 'home_widget.dart';
```

我们现在应该可以运行我们的应用了。你可以在 VS Code 里面，任意的 Dart 文件里按 F5，或者在 Android Studio 中点击 run 按钮，或者在终端中输入 `flutter run`。如果您需要模拟器安装或者模拟运行应用程序的相关帮助，请参考 Flutter 的帮助文档。如果一切顺利，你的应用应该是这样的。

![flutter1](//images.ctfassets.net/3cttzl4i3k1h/6yqGn7yZ0c0wsYSQUyka2y/b34fbe9ff45aec6cc7ce77e1926e90df/flutter1.png)

太棒了!我们现在已经有一个应用程序了，而且它有很漂亮的底部导航栏。然而，这里有一个问题。我们的导航栏不会导引到任何地方!现在让我们解决这个问题。

#### 第三步 准备导航

回到 `home_widget.dart` 文件，我们需要对 `_HomeState` 类做一些更改。在类的顶部，我们需要添加两个新的实例属性。

```
 class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
...
```

第一个是当前所选选项卡的索引，另一个则是选项卡对应的希望渲染的 widget 列表。

接下来，我们需要使用这些属性来告诉我们的 widget，当一个新选项卡被选中时需要显示什么。为此，我们需要对 build 方法返回的 scaffold widget 进行一些更改。这是我们新的 build 方法。

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

我们的 build 方法中更改的三行用 `// new` 注释了。首先，我们添加了 scaffold 的 body 属性，即在应用程序栏和底部导航栏之间显示的 widget。我们将 body 设置为与 `_children widget` 列表中相对应的 widget。接下来，我们给底部导航栏添加 `onTap` 属性。我们将它设置为一个名为 `ontabtap` 的函数，该函数将接收被选中选项卡的索引并决定如何处理它。我们马上就实现这个函数。最后，我们将底部导航栏的 `currentIndex` 设置为 state 类里面的  `_currentIndex` 属性。

#### 第四步 处理导航

现在，我们将添加上一步中提到的 `ontabtap` 函数。在 `_HomeState` 类的底部添加以下函数。

```
void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
```

这个函数接收被选中选项卡的索引，并在我们的 state 类上调用 `setState`。这将触发 build 方法接收我们传递给它的状态信息并再次运行。在本例中，我们将传递更新的选项卡索引，该索引将更改 scaffold widget 的 body，并激活导航栏上正确的选项卡。

#### 第五步 添加子 widgets

我们的应用程序就要完成了。最后一步是创建 `_children` widget 列表中用到的 widget 并把它们添加到导航栏。首先 在 lib 目录下创建一个名为 `placeholder_widget.dart` 的新文件。这个文件将作为一个简单的 `StatelessWidget` 来使用背景色。

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

现在我们要做的就是向导航栏中添加 `PlaceholderWidget`。在 `home_widget.dart` 的顶部,需要导入我们的 widget。

```
import 'placeholder_widget.dart';
```

然后，我们要做的就是将这些 widget 添加到 `_children` 列表中，以便在选择新选项卡时渲染它们。

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

就是这样!现在应该可以运行应用程序并在选项卡之间切换了。如果您想要看到 Flutter 的热重载特性，请尝试更改一下 `BottomNavigationBarItems`。值得注意的是，更改传递给 `PlaceholderWidgets` 的颜色不会在热重载期间反映出来，因为 Flutter 会保持我们 `StatefulWidget` 的状态。

![image1](//images.ctfassets.net/3cttzl4i3k1h/4XtVKoNlS06cKkm8AMmgey/d41905e98f2c7c4fd2a52a7a85b2a700/image1.gif)

### 结论

在本教程中，我们学习了如何搭建一个新的 Flutter 应用程序并让底部导航栏工作。像 Flutter 这样的跨平台工具在移动领域越来越流行，因为它们缩短了开发时间。Flutter 有它的独特之处，因为它不需要使用
底层原生的 widget 或 webview。目前采用 Flutter 的主要缺点之一是在功能特性上缺少第三方支持。然而，Flutter 仍然是一种很有前途的工具，使用它可以在不牺牲性能的前提下编写出非常棒的跨平台应用程序。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
