> * 原文地址：[A Closer Look at the Provider Package](https://medium.com/flutter-nyc/a-closer-look-at-the-provider-package-993922d3a5a5)
> * 原文作者：[Martin Rybak](https://medium.com/@martinrybak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-closer-look-at-the-provider-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-closer-look-at-the-provider-package.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Baddyo](https://github.com/Baddyo)

# 深入解析 Provider 包

> 附加 Flutter 状态管理的简单背景介绍

![](https://cdn-images-1.medium.com/max/3840/1*8Ah2h28bxT0-vk18Q4xVVA.jpeg)

[Provider](https://pub.dev/packages/provider) 是一个用于状态管理的包，其作者是 [Remi Rousselet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjXrMKO8dLjAhWoT98KHUCDB_oQFjAAegQIARAB&url=https%3A%2F%2Ftwitter.com%2Fremi_rousselet&usg=AOvVaw3bEIgT0j4c_5xbq-YWB70q)，最近，这个包在 Google 和 Flutter 社区广受欢迎。那么**什么是**状态管理呢？什么又是**状态**？我们一起来温习一下：状态就是用来表示应用 UI 的数据。**状态管理**则是我们创建、访问以及处理数据的方法。为了能更好地理解 Provider 这个包，我们先来简单回顾一下 Flutter 中的状态管理选项。

## 1. 状态组件：StatefulWidget

无状态组件 [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) 很简单，它就是一个展示数据的 UI 组件。`StatelessWidget` 没有记忆功能；并根据需要被创建或者销毁。Flutter 同时也有状态组件 [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)，这个组件是有记忆功能的，此记忆功能来自于它的持久组合状态对象 [State](https://api.flutter.dev/flutter/widgets/State-class.html)。这个类中包含一个 `setState()` 方法，当该方法被调用时，会触发组件重建并渲染出新的状态。这是 Flutter 中最基本的状态管理形式。下面这个例子就是一个展示会展示最近一次被点击的时间的按钮：

```dart
class _MyWidgetState extends State<MyWidget> {
  DateTime _time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(_time.toString()),
      onPressed: () {
        setState(() => _time = DateTime.now());
      },
    );
  }
}
```

这种写法的问题是什么呢？假设应用在根 [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) 组件中保存了一些全局状态。这些数据可能会在 UI 的很多不同部分被用到。我们将数据以参数的方式传送到每个子组件，以此共享数据。任何试图修改数据的事件都要以更新事件的方式冒泡到根组件。这就意味着，很多参数和回调函数都需要传递多层组件，这种方式会让代码非常混乱。更甚至，根状态的任何更新都会触发整个组件树的重构，这是成本非常高的。

## 2. 可继承组件：InheritedWidget

[InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) 是 Flutter 中唯一可以不需要直接引用，就可以获取父级组件信息的组件。只需访问 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)，那么当其子组件需要引用它的时候，该消费组件就可以自动重新构建。这种技术让开发者可以更高效地更新 UI。此时如果想稍微修改某个状态，我们可以只有选择地重新构建 App 中特定的组件，而不必大范围地重新构建了。如果你已经使用了 `MediaQuery.of(context)` 或者 `Theme.of(context)`，那么其实你已经在应用 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) 了。而由于 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) [很难正确地实现](https://flutterbyexample.com/set-up-inherited-widget-app-state/)，你也不太可能会去实现自己的一个 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)。

## 3. ScopedModel

[ScopedModel](https://pub.dev/packages/scoped_model) 是 [Brian Egan](https://twitter.com/brianegan) 于 2017 年创建的包，它让使用 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) 存储应用状态变得更加容易了。首先，我们需要创建一个继承了 [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html) 的状态对象，然后在属性改变的时候调用 `notifyListeners()`。这和 Java 中 [PropertyChangeListener](https://docs.oracle.com/javase/7/docs/api/java/beans/PropertyChangeListener.html) 接口的实现有些类似。

```dart
class MyModel extends Model {
  String _foo;

  String get foo => _foo;
  
  void set foo(String value) {
    _foo = value;
    notifyListeners();  
  }
}
```

为了暴露出状态对象，我们将其实例包裹在应用根组件的 [ScopedModel](https://pub.dev/documentation/scoped_model/latest/scoped_model/ScopedModel-class.html) 组件中。

```dart
ScopedModel<MyModel>(
  model: MyModel(),
  child: MyApp(...)
)
```

这样，任何子组件都可以通过 [ScopedModelDescendant](https://pub.dev/documentation/scoped_model/latest/scoped_model/ScopedModelDescendant-class.html) 组件获取到 `MyModel`。模块实例会作为参数传入 `builder`：

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(
      builder: (context, child, model) => Text(model.foo),
    );
  }
}
```

任何子组件也可以**更新**此模块，同时它将自动触发重新构建（前提是我们的模块都正确地调用了 `notifyListeners()`）：

```dart
class OtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Update'),
      onPressed: () {
        final model = ScopedModel.of<MyModel>(context);
        model.foo = 'bar';
      },
    );
  }
}
```

[ScopedModel](https://pub.dev/packages/scoped_model) 是 Flutter 中热门的状态管理结构体，但是它会限制暴露继承自 [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html) 类的状态以及它自身的变更通知模式。

## 4. BLoC

在 [Google 2018 年发者大会上](https://www.youtube.com/watch?v=RS36gBEp8OI)，提出了[业务逻辑组件](https://www.freecodecamp.org/news/how-to-handle-state-in-flutter-using-the-bloc-pattern-8ed2f1e49a13/)，即 BLoC，作为另一种可以将状态迁移出组件的模式。BLoC 类是一种可持久的、没有 UI 的组件，它会维护自己的状态并将其以 [stream](https://api.dartlang.org/stable/2.6.0/dart-async/Stream/listen.html) 和 [sink](https://api.dartlang.org/stable/2.4.0/dart-core/Sink-class.html) 的形式暴露出来。通过将状态和业务逻辑从 UI 中分离出来，BLoC 模式让组件可以作为[无状态组件（StatelessWidget）](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)应用，并可以使用 [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) 自动重新构建。这让组件比较“傻瓜式”，更易于测试。

一个 BLoC 类的例子：

```dart
class MyBloc {
  final _controller = StreamController<MyType>();

  Stream<MyType> get stream => _controller.stream;
  StreamSink<MyType> get sink => _controller.sink;
  
  myMethod() {
    // YOUR CODE
    sink.add(foo);
  }

  dispose() {
    _controller.close();
  }
}
```

一个组件应用 BLoC 模式的例子：

```dart
@override
Widget build(BuildContext context) {
 return StreamBuilder<MyType>(
  stream: myBloc.stream,
  builder: (context, asyncSnapshot) {
    // 其余代码
 });
}
```

BLoC 模式的问题是，创建和销毁 BLoC 对象的方法没有那么显而易见。在上面的例子中，`myBloc` 实例是如何创建的？我们如何调用 `dispose()` 来销毁它呢？如果使用了 [stream](https://api.dartlang.org/stable/2.6.0/dart-async/Stream/listen.html)，就需要使用 [StreamController 类](https://api.dartlang.org/stable/2.4.0/dart-async/StreamController-class.html)，而为了防止内存泄漏，当我们不需要再使用 StreamController 的时候，就必须调用 `closed` 方法销毁它。（Dart 没有类的 [析构函数](https://en.wikipedia.org/wiki/Destructor_(computer_programming)) 的概念；只有 `StatefulWidget` 中的 [State](https://api.flutter.dev/flutter/widgets/State-class.html) 类有一个 `dispose()` 方法）同时，多组件之间共享 BLoC 的方法也不明朗。因此，对于开发者来说，刚开始使用 BLoC 时会觉得很困难。好消息是，有一些[包](https://pub.dev/flutter/packages?q=bloc)可以帮助你度过这一难关。

## 5. Provider

[Provider](https://pub.dev/packages/provider) 是 [Remi Rousselet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjXrMKO8dLjAhWoT98KHUCDB_oQFjAAegQIARAB&url=https%3A%2F%2Ftwitter.com%2Fremi_rousselet&usg=AOvVaw3bEIgT0j4c_5xbq-YWB70q) 于 2018 年写得一个代码包，它和 [ScopedModel](https://pub.dev/packages/scoped_model) 类似，但是不限制对 [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html) 子类的暴露。它同时也是 [可继承组件 InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) 的一个外包，但它允许向外暴露任何状态对象，这其中包括了 BLoC、[stream](https://api.dartlang.org/stable/2.6.0/dart-async/Stream/listen.html)、[futures](https://api.dartlang.org/stable/dart-async/Future-class.html) 等等。由于它简单灵活，Google 在第十九届 [Google 开发者大会](https://www.youtube.com/watch?v=d_m5csmrf7I)上宣布，[Provider](https://pub.dev/packages/provider) 是它的状态管理的首选。当然，你也可以选择使用[其他的管理工具](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)，但是如果你还不确定要用哪个，Google 推荐 [Provider](https://pub.dev/packages/provider)。

[Provider](https://pub.dev/packages/provider) “由组件构成，为了方便其他组件的应用”。使用 [Provider](https://pub.dev/packages/provider)，我们可以将任何状态对象放入组件树中，并在其他任何子组件中访问到这些状态对象。[Provider](https://pub.dev/packages/provider) 可以使用数据初始化状态对象，或者当状态对象从组件树中移除的时候清理它们，以此帮助我们管理状态对象的生命周期。因此，[Provider](https://pub.dev/packages/provider) 甚至可以用来实现 BLoC 组件，或者作为[其他](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)状态管理方案的基础！😲又或者，它还可以用于[依赖注入](https://en.wikipedia.org/wiki/Dependency_injection) —— 一种将数据注入组件的神奇的形式，这种形式可以降低耦合度并增强可测试性。最后，[Provider](https://pub.dev/packages/provider) 也具有一系列专门的类，这让其变得更加易用。我们下面将会逐个详细讲解：

* 基础 [Provider](https://pub.dev/documentation/provider/latest/provider/Provider-class.html)
* [ChangeNotifierProvider](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html)
* [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html)
* [FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html)
* [ValueListenableProvider](http://ValueListenableProvider)
* [MultiProvider](https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html)
* [ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html)

#### 安装

想要使用 [Provider](https://pub.dev/packages/provider)，第一步要做的就是将相关依赖加入 pubspec.yaml 文件：

```
provider: ^3.0.0
```

然后在需要使用它的地方引入 [Provider](https://pub.dev/packages/provider) 包：

```dart
import 'package:provider/provider.dart';
```

#### 基础 Provider

下面，我们一起来在应用的根节点创建一个基本的 [Provider](https://pub.dev/packages/provider)，它将包含应用模型的实例：

```dart
Provider<MyModel>(
  builder: (context) => MyModel(),
  child: MyApp(...),
)
```

> 参数 `builder` 创建了 `MyModel` 的实例。如果你想要给它赋值为一个现有的实例，那么请使用 [Provider.value](https://pub.dev/documentation/provider/latest/provider/Provider/Provider.value.html) 构建函数。

然后你就可以使用 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 组件，在 `MyApp` 的任意位置对这个模型实例进行**自定义**。

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(
      builder: (context, value, child) => Text(value.foo),
    );
  }
}
```

在上面的例子中，`MyWidget` 类包含一个使用了 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 组件的 `MyModel` 的实例。这个组件提供了一个 `builder` 方法，该方法的 `value` 参数包含了实例对象。

那么如果我们想要**更新**模型的数据呢？我们假设有另一个包含按钮的组件，当按钮按下的时候，需要更新 `foo` 属性：

```dart
class OtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Update'),
      onPressed: () {
        final model = Provider.of<MyModel>(context);
        model.foo = 'bar';
      },
    );
  }
}
```

> 注意访问 `MyModel` 实例时的语法差异。它在功能上和使用 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 组件是一致的。而当你无法在代码中获取到 [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html) 的时候，[Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 组件就会派上用场了。

你认为这样的操作会对我们之前创建的 `MyWidget` 造成什么影响呢？你是否认为，它将会展示新的 `bar` 值？**但不幸的是你猜错了，这并不会发生**。简单的已创建的旧 Dart 对象并不会监听变化（至少在没有 [reflection](https://api.dartlang.org/stable/dart-mirrors/dart-mirrors-library.html) 的时候不会，而 [reflection](https://api.dartlang.org/stable/dart-mirrors/dart-mirrors-library.html) 目前在 Flutter 中还不可用）。这就意味着，[Provider](https://pub.dev/packages/provider) 无法知道我们更新过了 `foo` 属性，也无法告知 `MyWidget` 响应改变从而作出更新。

#### ChangeNotifierProvider

但是，我们还是有其他解决问题的希望的！我们可以让 `MyModel` 类实现 [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) mixin。我们只需要稍稍修改模型的实现，即在属性改变的时候调用一个特别的 `notifyListeners()` 方法即可。这和 [ScopedModel](https://pub.dev/packages/scoped_model) 的工作原理类似，但却不需要继承一个特殊的类。只需要实现 [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-%E2%80%A6) mixin 即可。代码如下：

```dart
class MyModel with ChangeNotifier {
  String _foo;

  String get foo => _foo;
  
  void set foo(String value) {
    _foo = value;
    notifyListeners();  
  }
}
```

正如你所见，我们将 `foo`  属性改成了 `getter` 和 `setter` 函数，它们都会去维护一个私有的 `_foo` 变量。这样做就让我们能“监听”到所有对 `foo` 的修改，并告知监听者：对象发生了变化。

现在，在 [Provider](https://pub.dev/packages/provider) 端，我们可以将代码实现改为，使用另一个名为 [ChangeNotifierProvider](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html) 的类：

```dart
ChangeNotifierProvider<MyModel>(
  builder: (context) => MyModel(),
  child: MyApp(...),
)
```

这样就好了！现在，当 `OtherWidget` 更新了 `MyModel` 实例的 `foo` 属性的时候，`MyWidget` 将会根据改变自动更新。超酷吧？

还有一件事要说。你也许已经注意到了，在 `OtherWidget` 按钮的事件处理函数中，我们使用了下面的语法：

```dart
final model = Provider.of<MyModel>(context);
```

**默认情况下，这样写会让 `OtherWidget` 实例在 `MyModel` 变化的时候自动更新**。这也许并不是我们所期望的。毕竟 `OtherWidget` 只包含了一个按钮，并不需要跟随 `MyModel` 的数据变化而变化。为了避免这样的事情发生，我们可以使用如下的语法让模型不再注册重新构建的监听：

```dart
final model = Provider.of<MyModel>(context, listen: false);
```

这是 [Provider](https://pub.dev/packages/provider) 包给予我们的另一份免费的便利。

#### StreamProvider

[StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) 给人的第一印象是：好像并不那么有必要。毕竟在 Flutter 中，我们可以使用常规的 [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) 来订阅流信息。例如下面这段代码中，我们监听了 [FirebaseAuth](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/firebase_auth-library.html) 提供的 [onAuthStateChanged](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/onAuthStateChanged.html) 流：

```dart
@override
Widget build(BuildContext context {
  return StreamBuilder(
   stream: FirebaseAuth.instance.onAuthStateChanged, 
   builder: (BuildContext context, AsyncSnapshot snapshot){ 
     ...
   });
}
```

而如果想使用 [Provider](https://pub.dev/packages/provider) 来完成，我们可以在 App 的根结点，通过 [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) 暴露出这个流：

```dart
StreamProvider<FirebaseUser>.value(
  stream: FirebaseAuth.instance.onAuthStateChanged,
  child: MyApp(...),
}
```

然后在子组件中就可以像其他 [Provider](https://pub.dev/packages/provider) 那样使用了：

```dart
@override
Widget build(BuildContext context) {
  return Consumer<FirebaseUser>(
    builder: (context, value, child) => Text(value.displayName),
  );
}
```

除了能让组件代码更加清晰，**它也可以抽象并过滤掉数据是否是来自于流的这一信息**。例如，如果我们想要修改 [FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html) 的基础实现，此时就无须修改组件的代码。**事实上，你很快就会发现，以下所有不同的 provider 都是这样**。😲

#### FutureProvider

和上面的例子类似，[FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html) 是在组件中使用 [FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html) 的替换方案。这里是一段代码示例：

```dart
FutureProvider<FirebaseUser>.value(
  value: FirebaseAuth.instance.currentUser(),
  child: MyApp(...),
);
```

我们使用和上文中 [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) 相关的例子中一样的对 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 的应用，来在子元素中获取到这个值。

#### ValueListenableProvider

[ValueListenable](https://api.flutter.dev/flutter/foundation/ValueListenable-class.html) 是 [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) 类实现的 Dart 接口，它可以在自身接收的参数发生变化的时候通知监听者。我们可以在一个简单的模型类中，用它来包裹一个计时器：

```dart
class MyModel {
  final ValueNotifier<int> counter = ValueNotifier(0);  
}
```

> 如果我们使用的是复杂类型的参数，[ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) 将会使用 **`==`** 操作符来确认是否参数值变化了。

让我们来创建一个基础 [Provider](https://pub.dev/packages/provider) 用来容纳主模块，它同时还有一个 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html)，以及一个用于监听 `counter` 属性的嵌套的 [ValueListenableProvider](https://pub.dev/documentation/provider/latest/provider/ValueListenableProvider-class.html)：

```dart
Provider<MyModel>(
  builder: (context) => MyModel(),
  child: Consumer<MyModel>(builder: (context, value, child) {
    return ValueListenableProvider<int>.value(
      value: value.counter,
      child: MyApp(...)
    }
  }
}
```

> 注意：嵌套的 provider 的类型是 `int`。当然你的代码也会有其他可能的类型。如果有多个 Provider 都注册为同一类型，那么 [Provider](https://pub.dev/packages/provider) 将会返回最“近”的一个（距离最近的父级组件）。

如下代码可以监听任意子组件的 `counter` 属性：

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<int>(
      builder: (context, value, child) {
        return Text(value.toString());
      },
    );
  }
}
```

如下代码可以**更新**其他组件的 `counter` 属性。注意：我们首先需要获取原始的 `MyModel` 实例。

```dart
class OtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Update'),
      onPressed: () {
        final model = Provider.of<MyModel>(context);
        model.counter.value++;
      },
    );
  }
}
```

#### MultiProvider

如果我们应用了多个 [Provider](https://pub.dev/packages/provider) 组件，我们可能会在 app 根结点写出这样很丑陋的多层嵌套的结构：

```dart
Provider<Foo>.value( 
  value: foo, 
  child: Provider<Bar>.value( 
    value: bar, 
    child: Provider<Baz>.value( 
      value: baz , 
      child: MyApp(...)
    ) 
  ) 
)
```

[MultiProvider](https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html) 则允许我们在同一层级声明所有的 provider。但这仅仅是一种[语法糖](https://en.wikipedia.org/wiki/Syntactic_sugar)；它们实际上还是嵌套的。

```dart
MultiProvider( 
  providers: [ 
    Provider<Foo>.value(value: foo), 
    Provider<Bar>.value(value: bar), 
    Provider<Baz>.value(value: baz), 
  ], 
  child: MyApp(...), 
)
```

#### ProxyProvider

[ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html) 是个很有趣的类，它发布于 [Provider](https://pub.dev/packages/provider) 包的 v3 版本。这让我们可以声明依赖于其他 6 种 Provider 的 Provider。在下面这个例子中，`Bar` 类依赖于 `Foo` 的实例。当我们需要建立有赖于其他服务的根服务集时，这就很有用了。

```dart
MultiProvider ( 
  providers: [ 
    Provider<Foo> ( 
      builder: (context) => Foo(),
    ), 
    ProxyProvider<Foo, Bar>(
      builder: (context, value, previous) => Bar(value),
    ), 
  ], 
  child: MyApp(...),
)
```

> 第一个范型参数是 [ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html) 的类型，第二个是它需要返回的类型。

#### 同时监听多个 Provider

如果我们想要一个组件同时监听多个 Provider，并且当任意一个被监听的 Provider 发生变化时都要重构组件，那我们该怎么做呢？使用 [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) 组件的变量，我们最多可以监听 6 个 Provider。我们将会在 `builder` 方法的附加参数中获取它们的实例。

```dart
Consumer2<MyModel, int>(
  builder: (context, value, value2, child) {
    //value 是 MyModel 类型
    //value2 是 int 类型
  },
);
```

#### 总结

通过学习 [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) 和 [Provider](https://pub.dev/packages/provider)，我们学会了如何使用 “Flutter 式” 的方法管理状态。组件可以获取并监听状态对象，并同时将内部的通知机制抽象并隔离掉。这种方法通过提供勾子来创建并按需分发状态对象，帮助我们管理了它的生命周期。它可以应用于依赖注入，或者甚至可以作为更复杂的状态管理选择的基础。它已经获取了 Google 的赞许，同时 Flutter 社区也在给予更多的支持，因此选择它肯定是一个风险很小的决策。何不今天就一起来试试看 [Provider](https://pub.dev/packages/provider) 呢！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
