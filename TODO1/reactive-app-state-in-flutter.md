> * 原文地址：[Reactive app state in Flutter](https://medium.com/@maksimrv/reactive-app-state-in-flutter-73f829bcf6a7)
> * 原文作者：[Maksim Ryzhikov](https://medium.com/@maksimrv?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/reactive-app-state-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/reactive-app-state-in-flutter.md)
> * 译者：
> * 校对者：

# Reactive app state in Flutter

![](https://cdn-images-1.medium.com/max/800/1*TFZQzyVAHLVXI_wNreokGA.png)

flutter.io

I have been playing with [Flutter](https://flutter.io/) for several weeks and I can say it’s really great, thanks to Flutter and Dart team. But when I started to hack demo app in Flutter I met several problems:

1.  How to pass an app’s state down to the widgets tree
2.  How to rebuild widgets after updating the app’s state

So let’s start from the first problem “How to pass an app’s state”. I’ll be showing my solutions with a help of the Flutter’s standard “Counter” demo app. It’s easy to create such an app: we just need to type [“flutter create myapp”](https://flutter.io/getting-started/#creating-your-first-flutter-app) in a terminal (“myapp” — is the name of our demo app).

After that we should open “main.dart” file and make “MyHomePage” widget “stateless”:

```
import 'package:flutter/material.dart';

var _counter = 0;
...

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  _incrementCounter() {}
}
```

We just move “build” method from “MyHomePageState” to “MyHomePage” widget, then create the empty method `_incrementCounter` there and create var `_counter` on top of the file . Now we can reload our app and see that nothing has changed on the screen, except for the “+” button - now it doesn’t function. It’s ok because now our widget is stateless.

Let’s think about how our widget which provides the app’s state should look:

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Provider(      
      data: _counter,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
```

Here we can see the new widget “Provider” which wraps our whole app. It has two properties: “data” — which contains our app’s state and “child” — the descendant widget. Also we should have the possibility to get this data from any widget down the tree, but we will think about it later. Now let’s write down the straightforward implementation for our new widget.

First of all let’s create the new dart file “Provider.dart” by the “main.dart” where we will put our implementation for the “Provider” widget.

Now we create “Provider” as a “Stateless” widget:

```
import 'package:flutter/widgets.dart';

class Provider extends StatelessWidget {
  const Provider({this.data, this.child});

  final data;
  final child;

  @override
  Widget build(BuildContext context) => child;
}
```

Yup, pretty straightforward. Now let’s import “Provider” into “main.dart”

```
import 'package:flutter/material.dart';

import 'package:myapp/Provider.dart';
```

and rebuild our app to check that all is working without any errors. If all “works”, let’s move further. Now we have a container for our app’s state and we can return to the question about how to retrieve the data from this container. Fortunately Flutter already has a solution and it’s “[InheritedWidget](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html)”. The documentation describes it very well:

> Base class for widgets that efficiently propagate information down the tree.

This is exactly what we need. Let’s create our “inherited” widget.

Open “Provider.dart” and create the private “_InheritedProvider” widget:

```
class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({this.data, this.child})
      : super(child: child);

  final data;
  final child;

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return data != oldWidget.data;
  }
}
```

All subclasses of “InheritedWidget” should implement “updateShouldNotify” method. At this point we just check that the passed “data” has changed. For example, when we change the counter from “0” to “1” this method should return “true”.

Now let’s add our “Inherited” widget to the widget tree:

```
class Provider extends StatelessWidget {
  ...

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(data: data, child: child);
  }
  ...
}
```

Ok, now we’ve got widget which propagates data in our widget tree, but we should create a public method which allows to [get](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) this data:

```
class Provider extends StatelessWidget {
  ...

  static of(BuildContext context) {
    _InheritedProvider p =
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return p.data;
  }
  ...
}
```

“[inheritFromWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html)” method obtains the nearest parent widget of the “_InheritedProvider” type instance.

Now we have everything to solve the first problem:

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Provider(
      data: 0, 
      ...
    }
  ...
}

...

class MyHomePage extends StatelessWidget {
  ...
  Widget build(BuildContext context) {
    var _counter = Provider.of(context);
  ...
}
```

We have removed the global variable “_counter” and got “counter” inside “MyHomePage” widget using “Provider.of”. As you can see we didn’t pass it to “MyHomePage” as a parameter instead we used “Provider.of” for getting the app’s state, which can be applied to any widget down the tree. In addition to it “Provider.of” [registeres](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) the current widget’s context and [rebuild](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html)s it when our “_InheritedProvider” widget is changed.

Now it’s time to check that our app still works: let’s reload it. To make sure that our “Provider” works correctly we can change the “data” from “0” to “1” in “MyApp” widget and after that we have to reload the app again. However our “+” button still doesn’t work.

Here we face our second problem “How to rebuild widgets after the app’s state has been changed” and now we should put on our thinking caps again.

Our app’s state is just a number but it’s not that easy to detect when this number has been changed. What if we wrap our “counter" number into an “observable” object which will track changes and notify “listeners” about these changes.

Fortunately Flutter already has a solution and this is “[ValueNotifier](https://docs.flutter.io/flutter/foundation/ValueNotifier-class.html)”. Here’s a very good explanation from the documentation, as usual:

> When [value](https://docs.flutter.io/flutter/foundation/ValueNotifier/value.html) is replaced, this class notifies its listeners.

Ok, let’s create our app’s state class in “mian.dart”:

```
import 'package:flutter/material.dart';
import 'package:myapp/Provider.dart';

class AppState extends ValueNotifier {
  AppState(value) : super(value);
}

var appState = new AppState(0);
```

and pass it to the “Provider”

```
Widget build(BuildContext context) {
    return new Provider(
      data: appState,
```

since “data” contains an object we should change our “Provider.of(context)” usage, so let’s do it:

```
Widget build(BuildContext context) {
    var _counter = Provider.of(context).value;
```

Rebuild our app and make sure that there are no errors.

Now we are ready to implement “_incrementCounter”:

```
  floatingActionButton: new FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  _incrementCounter(context) {
    var appState = Provider.of(context);
    appState.value += 1;
  }
```

Let’s reload the app and try to press the “+” button. Nothing has changed, but if we run “Hot reload” we will see that the text has changed. It happens because we have changed our app’s state after we pressed the button. However we see the old state on the screen because we haven’t rebuilt the widgets. The moment we run “Hot reload” widgets get rebuilt and we can see the actual state on the screen.

The last challenge is to rebuild widgets after we changed the app’s state. But before that let’s take a look at the things we already have:

1.  “Provider” — the container for our app’s state
2.  “AppState” — the class which tracks app’s state changes and notifies “listeners”
3.  “_InheritedProvider” — the widget that efficiently propagates the app’s state down the tree and rebuilds consumers after having changed its own state.

At first let’s review the method “updateShouldNotify” of “_InheritedProvider”:

```
  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return data != oldWidget.data;
  }
```

Now “data” is equal to the instance of “AppState”, which means when we change the “value” of this instance in the “_incrementCounter” method, it actualy doesn’t change the instance itself. So this comparison always returns “false”. Let’s fix this problem by comparing “value”-s. But for this we should save the “value” in the widget which allows us not to lose the “value” between rebuilds:

```
class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({this.data, this.child})
      : _dataValue = data.value,
        super(child: child);

  final data;
  final child;
  final _dataValue;

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _dataValue != oldWidget._dataValue;
  }
}
```

Now it works correctly: when we change the value of the state the widget rebuilds consumers. But before rebuilding consumers we should rebuild the widget itself after the app’s state is changed.

There’s only one place in our code which knows about “_InheritedProvider” widget and this is the “Provider” widget. In case we want to track some state in widgets we should create the “statefull” widget. Ok, let’s convert our “Provider” widget from “stateless” to “statefull”:

```
class Provider extends StatefulWidget {
  const Provider({this.child, this.data});

  static of(BuildContext context) {
    _InheritedProvider p =
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return p.data;
  }

  final ValueNotifier data;
  final Widget child;

  @override
  State<StatefulWidget> createState() => new _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      data: widget.data,
      child: widget.child,
    );
  }
}

class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({this.data, this.child})
```

Now let’s “subscribe” to the app’s state change and call “ `setState`” after it has been changed:

```
class _ProviderState extends State<Provider> {
  @override
  initState() {
    super.initState();
    widget.data.addListener(didValueChange);
  }

  didValueChange() => setState(() {});
```

and don’t forget to remove garbage after the widget is destroyed:

```
class _ProviderState extends State<Provider> {
  ...

  @override
  dispose() {
    widget.data.removeListener(didValueChange);
    super.dispose();
  }
  ...
}
```

Let’s rebuild the app and check how it works. Hurray, now when we press the “+” button our app’s state gets changed and widgets are rebuilt.

Let’s check our problems:

1.  How to pass the app’s state down to the widgets tree — **Solved**
2.  How to rebuild widgets after the app’s state has been changed — **Solved**

The source code you can find here -[https://gist.github.com/c88f116d7d65d7222ca673b5f9c5bcc3](https://gist.github.com/c88f116d7d65d7222ca673b5f9c5bcc3)

Conclusion.

The general idea of this article is to show how to implement the “redux” pattern in Flutter without external packages. Flutter already has packages which implement the “redux” pattern but sometimes they don’t fit your architecture and it’s good to know how you can implement something from scratch with your own hands ✋.

Thanks,

Happy coding and develop with pleasure!

Thanks to [Elizaveta Kulikova](https://medium.com/@lizzy.kulikova?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
