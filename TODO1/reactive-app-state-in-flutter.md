> * 原文地址：[Reactive app state in Flutter](https://medium.com/@maksimrv/reactive-app-state-in-flutter-73f829bcf6a7)
> * 原文作者：[Maksim Ryzhikov](https://medium.com/@maksimrv?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/reactive-app-state-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/reactive-app-state-in-flutter.md)
> * 译者：[Starriers](https://github.com/Starriers)

# Flutter 中的原生应用程序状态

![](https://cdn-images-1.medium.com/max/800/1*TFZQzyVAHLVXI_wNreokGA.png)

flutter.io

我使用 [Flutter](https://flutter.io/) 已经有几个星期了，所以我能感受到它为开发所带来的便利，感谢 Flutter 和 Dart 团队。但起初我尝试攻击 Flutter 中演示案例时，遇到了一些问题：

1.  如何将应用程序的状态传递给小部件树
2.  如何在更新应用程序状态之后重建小部件

那么我们从第一个问题“如何传递应用程序状态”开始。我用 Flutter 的标准 “Counter” 示例应用程序来演示我的解决方案。创建一个这样的应用程序非常简单：我们只需要在终端输入 [“flutter create myapp”](https://flutter.io/getting-started/#creating-your-first-flutter-app)（“myapp” —— 是我的示例应用程序的名字）。

然后我们打开 “main.dart” 文件，并使 “MyHomePage” 小部件为 “stateless”：

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

我们只需将 “build” 方法 “MyHomePageState” 移至 “MyHomePage” 小部件，然后在文件的顶部新建空方法 `_incrementCounter` 和变量 `_counter`。现在我们可以重新加载我们的应用程序，然后发现屏幕上没有任何变化，除了 “+” 按钮 —— 现在它还没有任何功能。这没关系，因为我们的小部件是无状态的。

我们考虑一下提供应用程序状态的小部件应该是什么样子的：

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

这里我们可以看到包装了我们整个应用程序的新的小部件 “Provider”。它有两个属性：包含应用程序状态的 “data” 和子代小部件的 “child”。此外，我们应该有可能从树下的任何小部件中获取这些数据，但稍后我们会考虑的。现在，我们为我们的新小部件写下简单的实现。

首先，我们通过 “main.dart” 来新建一个 “Provider.dart” dart 文件，然后用来实现我们的 “Provider” 小部件。

现在我们创建 “Provider” 作为 “Stateless” 小部件：

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

是的，直截了当。现在我们将 "Provider" 导入 “main.dart”

```
import 'package:flutter/material.dart';

import 'package:myapp/Provider.dart';
```

重建我们应用程序，以检查所有的工作是否有错。如果全部“运行”，那我们就可以进行下一步了。我们现在有了一个用于应用程序状态的容器，我们可以返回如何从这个容器中检索数据的问题。幸运的是，Flutter 已经有了解决方案，而且它是 “[InheritedWidget](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html)”。这些文档已经说得很清楚了：

> 用于在树中有效传播信息的小部件的基类。

这正是我们所需要的。我们创建“继承”小部件。

打开 “Provider.dart”，然后创建私有 “`_InheritedProvider`” 小部件：

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

“InheritedWidget” 的所有子类都应该实现 “updateShouldNotify” 方法。此时，我们只需检查传递的 “data” 是否已更改。例如，当我们将计数器从 “0” 改为 “1” 时，该方法应该返回 “true”。

我们现在讲“继承”小部件，然后添加到小部件树中：

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

好的，我们现在有了小部件，它在小部件树中传播数据，但我们应该创建一个公有方法，它允许 [get](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) 这个数据：

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

“[inheritFromWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html)” 方法获取 “_InheritedProvider” 类型实例的最近父部件。

我们现在有了解决第一个问题的能力：

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

我们删除了全局变量 “_counter” 并使用 “Provider.of” 在 “MyHomePage” 小部件中取得了 “counter”。如你所见，我们没有将它作为参数传递给 “MyHomePage”，而是使用 “Provider.of” 来获取应用程序的状态，他可以应用于树下的任何小部件。 此外，“Provider.of” 还包括当前小部件的上下文和[重建](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html)，并在更改 “`_InheritedProvider`” 小部件时对其进行[注册](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html)。

现在是时候检测我们的应用程序是否起作用了：我们重新加载它。为了确保我们的 "Provider" 正常工作，我们可以将 “data” 从 “0” 更改为 “MyApp” 小部件中的 “1”，然后我们必须重新加载应用程序。然而，我们的 “+” 按钮仍然无法工作。

在这里，我们面临的第二个问题是“如何在改变应用程序的状态后重建小部件”，现在我们应该重新开始思考。

我们的应用程序状态只是一个数字，但当这个数字被更改时，检测起来就没有那么容易了。如果我们将“计数器”编号包装成一个“可观察的”对象，该对象将跟踪更改并通知“监听器”这些更改。

庆幸的是，Flutter 已经有了解决方案，这就是 “[ValueNotifier](https://docs.flutter.io/flutter/foundation/ValueNotifier-class.html)”。像通常一样，这里有一个很好的文档解释：

> 当 [value](https://docs.flutter.io/flutter/foundation/ValueNotifier/value.html) 被替代时，这个类会通知它的监听器。

好的，让我们在 “mian.dart” 中创建应用程序的状态类：

```
import 'package:flutter/material.dart';
import 'package:myapp/Provider.dart';

class AppState extends ValueNotifier {
  AppState(value) : super(value);
}

var appState = new AppState(0);
```

然后将其传递给 "Provider"

```
Widget build(BuildContext context) {
    return new Provider(
      data: appState,
```

由于 “data” 包含一个对象，所以我们更改 “Provider.of(context)” 用法，那就这样做：

```
Widget build(BuildContext context) {
    var _counter = Provider.of(context).value;
```

重建我们的应用程序，并确保没有错误。

我们现在已经实现了 “`_incrementCounter`”：

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

我们重新加载了应用程序，并尝试按下 “+” 按钮。没有改变什么。但如果我们允许“热加载”，我们将看到文本已经改变。这是因为我们按下按钮后改变了应用程序的状态。但我们在屏幕上看到了旧的状态，因为我们还没有重新构建小部件。当我们允许小部件进行“热加载”时，我们就可以看到屏幕上的实际状态。

最后的挑战是在我们更改应用程序的状态后重建小部件。但在此之前，我们看看已有的东西：

1.  “Provider” —— 我们应用程序状态的容器
2.  “AppState” —— 跟踪应用程序状态改变并通知“监听者”的类
3.  “_InheritedProvider” —— 小部件将有效地将应用程序状态传播到网上，并在改变了自己的状态之后重建用户。

首先，我们回顾一下 “_InheritedProvider” 的 “updateShouldNotify” 方法：

```
  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return data != oldWidget.data;
  }
```

现在 “data” 等于 “AppState” 的实例，这意味着我们在 “`_incrementCounter`” 方法中更改此实例的 “value” 时，它实际上并不会改变实例本身。因此，这个比较总是返回 “false”。我们通过比较  “value”-s 来解决这个问题。但为此，我们应该将“值”曝出在小部件中，这允许我们可以不丢失重构之间的 “value”：

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

现在它可以正确地工作了：当我们改变状态值时，小部件会重新构建消费者。但在重新构建消费者之前，我们应该在改变应用程序的状态后重建小部件本身。

我们的代码中只有一个可以了解 “_InheritedProvider” 的小部件，就是 “Provider” 小部件。如果我们想要跟踪小部件中的某种状态，我们应该创建 “statefull” 小部件。好的，让我们将 “Provider” 小部件从 “stateless” 转换为 “statefull”：

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

我们现在可以 “subscribe” 应用程序的状态改变，并在它被更改后调用 “`setState`”：

```
class _ProviderState extends State<Provider> {
  @override
  initState() {
    super.initState();
    widget.data.addListener(didValueChange);
  }

  didValueChange() => setState(() {});
```

不要忘记在小部件被销毁后删除垃圾：

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

我们重建这个应用程序，并检查它是如何工作的。现在，当我们按下 “+” 按钮时，我们的应用程序状态就会发生改变，小部件也会被重建。

我们检查一下我们的问题：

1.  我们如何将应用程序状态传递到小部件树 —— **已解决**
2.  如何在更改应用程序状态后重建小部件 —— **已解决**

源代码在这里 —— [https://gist.github.com/c88f116d7d65d7222ca673b5f9c5bcc3](https://gist.github.com/c88f116d7d65d7222ca673b5f9c5bcc3)

结论。

本文的总体思想是演示如何在没有额外包的情况下，在 Flutter 中实现 “redux” 模式。Flutter 已经有了可以实现 “redux” 模式的包，但有时它们不适合你的体系结构，知道如何用你自己的手从头开始实现是好事 ✋。

感谢，

快乐的编码，快乐的发展！

感谢 [Elizaveta Kulikova](https://medium.com/@lizzy.kulikova?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
