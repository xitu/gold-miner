> * 原文地址：[How to use Flutter to build an app with bottom navigation](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 原文作者：[Joseph Cherry](https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-flutter-to-build-an-app-with-bottom-navigation.md)
> * 译者：
> * 校对者：

# How to use Flutter to build an app with bottom navigation

![](https://images.ctfassets.net/3cttzl4i3k1h/6zwT0UszrUmYQq8MWm2G4K/cceed7b9aeda5e862a3927fb02913c15/3-01.png?w=1400&h=600&q=80&fm=&f=&fit=fill)

If you’re into mobile development then you have probably heard of Google’s new cross platform SDK called Flutter. Flutter’s [beta](https://medium.com/flutter-io/announcing-flutter-beta-1-build-beautiful-native-apps-dc142aea74c0) was announced on February 27 and recently moved to its first release preview. To help you get started with Flutter, this tutorial will cover some of the basic parts of the SDK while also showing you how to set up a bottom navigation bar. To help you follow along, the code for this tutorial is available on [GitHub](https://github.com/JoeCherry/my_app).

### What is Flutter?

Before we dive in to writing code let’s talk about what Flutter is. The Flutter SDK ships with a full framework that includes the widgets and tools needed to build native mobile apps on Android and iOS. What separates it from other cross platform frameworks like React Native and Xamarin is that is does not use the native widgets, nor does it use WebViews. Instead, Flutter has its own rendering engine written in C/C++, while the Dart code that is used to actually write Flutter apps can be compiled into native code on each platform. This results in performant apps on each platform. Not only do apps feel quick, but development time is sped up by Flutter’s great hot reload feature. Hot reload allows developers to have changes in their code show up immediately on their devices or simulators during development saving time that is usually wasted waiting for code to compile.

### How to create a Flutter app

Now that we have an understanding of what Flutter is let’s get started creating our app. If you haven’t already, follow the steps on the [Flutter website](https://flutter.io/get-started/install/) for installing the Flutter SDK. To create your app run `flutter create my_app`. If you want to your app to use Swift or Kotlin for platform specific code, then you can run `flutter create -i swift -a kotlin my_app` from your terminal or command line. Open your newly created project in either Visual Studio Code with the Dart plugin installed or Android Studio with the Flutter and Dart plugin installed. If you need help with getting your editor setup you can refer back to Flutter’s [documentation](https://flutter.io/get-started/editor/#androidsstudio) again.

#### Step 1. Define our entry point

Let’s start by opening the `main.dart` file that is located under the `lib/` directory. Next, delete all the code inside that file because we are going to write our app from scratch. This file is the entry point for our application. At the top of the file write:

```
import 'package:flutter/material.dart';
```

This brings in all the material design widgets that are provided with the Flutter SDK. If you want to see all the widgets provided, you can check them out in the [widget catalog](https://flutter.io/widgets/).

After the import statement we need to add our main method.

```
void main() => runApp(App());
```

If you see errors after adding the main method don’t worry. This is because we haven’t created our `App` widget class that we are passing in to the `runApp` function. The `runApp` function takes in a class of type `Widget` and this will serve as the root widget.

Now we are going to create our `App` widget. Still inside `main.dart` add it below the main method.

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

This creates a new stateless widget called `App`. It can be a stateless widget because nothing in its build method depends on any state updates. All `StatelessWidgets` need to implement the `build` method because this is where we create our user interface. In our `App` widget we are simply creating a new `MaterialApp` and setting the `home` property to the first page or widget we want our app to display. In our case we are setting home to our `Home` widget that we will create next.

#### Step 2. Create the home page

Under the `lib` folder, create a new file and call it `home_widget.dart`. At the top of this file we need to import the material widgets again.

```
import 'package:flutter/material.dart';
```

Next we are going to create the widget that will act as our homepage. For this we will create a new `StatefulWidget`. `Stateful` widgets come in handy when your user interface will change depending on the current state of your application. For example, we are going to be using a bottom navigation bar and our `Home` widget will render a different widget based on what tab is currently selected. To get started with this add the following code below your import statement.

```
class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}
```

You may notice that this widget class doesn’t implement the build method that we mentioned earlier as being required. When it comes to `StatefulWidgets` the build method is implemented in the widget’s corresponding `State` class. The only required method in a `StatefulWidge`t is the `createState` method we implemented above where we simply return an instance of our `_HomeState` class. The “_” in front of the class names is how Dart marks classes or class properties as private. We now need to create our home widget’s state class. Add this at the end of your `home_widget.dart` file:

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

There is a lot to take in here so let’s run through it. In our `_HomeState` class we implement the build method for our `Home` widget. The widget we return from our build method is called `Scaffold`. This widget has some nice properties for helping us lay out our main screen including adding bottom navigation bars, sliding drawers, and tab bars. We are just using its `appBar` and `bottomNavigationBar` properties for now. In our bottom navigation bar we return a list of items we would like to appear in the bottom bar. As you can see we have three items with tabs called Home, Messages, and Profile. We also have the current index as a property and set it to 0 for now. We will hook this up a little later on to reflect the current tab we are on. The current index is how the navigation bar knows which icon to animate as the currently selected tab.

At this point we are almost ready to run our Flutter app for the first time and see our hard work pay off. To do this we need to go back to our main.dart file. At the top we need to import our newly created Home widget. We can do that by adding this import statement under the one that is currently there.

```
import 'home_widget.dart';
```

We should now be able to run our app. You can do this by pressing F5 in any Dart file in Visual Studio Code, clicking the run button in Android Studio, or typing `flutter run` in your terminal. If you need help setting up an emulator or simulator to run your app, refer back to Flutter’s documentation. If all goes well, then your app should look something like this.

![flutter1](//images.ctfassets.net/3cttzl4i3k1h/6yqGn7yZ0c0wsYSQUyka2y/b34fbe9ff45aec6cc7ce77e1926e90df/flutter1.png)

Great! We have an app running with a nice bottom navigation bar. However, there is one problem. Our navigation bar doesn’t navigate anywhere! Let’s fix that now.

#### Step 3. Prepare for navigation

Go back to our `home_widget.dart` file because we need to make some changes to our `_HomeState` class. At the top of the class we need to add two new instance properties.

```
 class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
...
```

The first one will track the index of our currently selected tab and the other one will be a list of widgets that we want to render based on the currently selected tab.

Next we need to use these properties to tell our widget what needs to be displayed when a new tab is tapped. To do this we need to make some changes to the scaffold widget we return from our build method. Here is our new build method.

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

The three changed lines in our build method are commented with `// new`. First we added the body of our scaffold which is the widget that gets displayed between our app bar and bottom navigation bar. We set the body equal to the corresponding widget in our `_children` widget list. Next we added the `onTap` property of the bottom navigation bar. We set it equal to a function called `onTabTapped` that will take in the index of the tab that is tapped and decide what to do with it. We will implement this function in just a second. Finally we set the `currentIndex` of the bottom navigation bar to the current index held in our state’s `_currentIndex` property.

#### Step 4. Handle navigation

Now we will add that `onTabTapped` function we mentioned in the last step. At the bottom of our `_HomeState` class add the following function.

```
void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
```

This function takes in the tapped tab’s index and calls `setState` on our state class. This will trigger the build method to be run again with the state that we pass in to it. In this case we are sending the updated tab index which will change the body of our scaffold widget and animate our navigation bar to the correct tab.

#### Step 5. Add the child widgets

We are getting close to being done with our app. The final step will include making the widget for our `_children` widget list and adding to the navigation bar. Start by creating a new file under your lib folder called `placeholder_widget.dart`. This file will serve as a simple `StatelessWidget` that takes in a background color.

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

Now all we have to do is add the `PlaceholderWidget` to our navigation bar. At the top of our `home_widget.dart` file we need to import our widget.

```
import 'placeholder_widget.dart';
```

Then all we do is add these widgets to our `_children` list so that they will be rendered when we select a new tab.

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

That’s it! You should now be able run your app and switch between tabs. If you want to see Flutter’s hot reload feature in action, then try changing any of your `BottomNavigationBarItems`. It’s worth noting that changing the colors passed in to our `PlaceholderWidgets` will not be reflected during a hot reload because Flutter will maintain the state of our `StatefulWidget`.

![image1](//images.ctfassets.net/3cttzl4i3k1h/4XtVKoNlS06cKkm8AMmgey/d41905e98f2c7c4fd2a52a7a85b2a700/image1.gif)

### Conclusion

In this tutorial we learned how to set up a new Flutter app and get a bottom navigation bar working. Cross platform tools like Flutter are gaining popularity in the mobile space due to the decreased development times they offer. Flutter is a unique take on these tools because it doesn’t require using platform native widgets or WebViews. One of the main drawbacks of adopting Flutter right now is the lack of third party support for features. However, Flutter is still a promising tool for writing great looking cross platform apps without having to sacrifice performance.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
