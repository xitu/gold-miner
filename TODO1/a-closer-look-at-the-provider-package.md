> * 原文地址：[A Closer Look at the Provider Package](https://medium.com/flutter-nyc/a-closer-look-at-the-provider-package-993922d3a5a5)
> * 原文作者：[Martin Rybak](https://medium.com/@martinrybak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-closer-look-at-the-provider-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-closer-look-at-the-provider-package.md)
> * 译者：
> * 校对者：

# A Closer Look at the Provider Package

> Plus a Brief History of State Management in Flutter

![](https://cdn-images-1.medium.com/max/3840/1*8Ah2h28bxT0-vk18Q4xVVA.jpeg)

[Provider](https://pub.dev/packages/provider) is a state management package written by [Remi Rousselet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjXrMKO8dLjAhWoT98KHUCDB_oQFjAAegQIARAB&url=https%3A%2F%2Ftwitter.com%2Fremi_rousselet&usg=AOvVaw3bEIgT0j4c_5xbq-YWB70q) that has been recently embraced by Google and the Flutter community. But what **is** state management? Heck, what is **state**? Recall that state is simply the data that represents the UI in our app. **State management** is how we create, access, update, and dispose this data. To better understand the Provider package, let’s look at a brief history of state management options in Flutter.

## 1. StatefulWidget

A [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) is a simple UI component that displays only the data it is given. A `StatelessWidget` has no “memory”; it is created and destroyed as needed. Flutter also comes with a [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) that **does** have a memory thanks to its long-lived companion [State](https://api.flutter.dev/flutter/widgets/State-class.html) object. This class comes with a `setState()` method that, when invoked, triggers the widget to rebuild and display the new state. This is the most basic, out-of-the-box form of state management in Flutter. Here is an example with a button that always shows the last time it was tapped:

```
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

So what’s the problem with this approach? Let’s say that our app has some global state stored in a root [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). It contains data that is intended to be used by many different parts of the UI. We share that data by passing it down to every child widget in the form of parameters. And any events that intend to mutate this data are bubbled back up in the form of callbacks. This means a lot of parameters and callbacks being passed through many intermediate widgets, which can get very messy. Even worse, any updates to that root state will trigger a rebuild of the whole widget tree, which is inefficient.

## 2. InheritedWidget

[InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) is a unique component in Flutter that lets a widget access an ancestor widget without having a direct reference. By simply accessing an [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html), a consuming widget is automatically rebuilt whenever the inherited widget requires it. This technique lets us be more efficient when updating our UI. Instead of rebuilding huge parts of our app in response to a small state change, we can surgically choose to rebuild only specific widgets. You’ve already used [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) whenever you’ve used `MediaQuery.of(context)` or `Theme.of(context)`. It’s probably less likely that you’ve ever implemented your own [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) though. That’s because they are [tricky to implement](https://flutterbyexample.com/set-up-inherited-widget-app-state/) correctly.

## 3. ScopedModel

[ScopedModel](https://pub.dev/packages/scoped_model) is a package created in 2017 by [Brian Egan](https://twitter.com/brianegan) that makes it easier to use an [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) to store app state. First we have to make a state object that inherits from [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html), and then invoke `notifyListeners()` when its properties change. This is similar to implementing the [PropertyChangeListener](https://docs.oracle.com/javase/7/docs/api/java/beans/PropertyChangeListener.html) interface in Java.

```
class MyModel extends Model {
  String _foo;

  String get foo => _foo;
  
  void set foo(String value) {
    _foo = value;
    notifyListeners();  
  }
}
```

To expose our state object, we wrap our state object instance in a [ScopedModel](https://pub.dev/documentation/scoped_model/latest/scoped_model/ScopedModel-class.html) widget at the root of our app:

```
ScopedModel<MyModel>(
  model: MyModel(),
  child: MyApp(...)
)
```

Any descendant widget can now access `MyModel` by using the [ScopedModelDescendant](https://pub.dev/documentation/scoped_model/latest/scoped_model/ScopedModelDescendant-class.html) widget. The model instance is passed into the `builder` parameter:

```
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(
      builder: (context, child, model) => Text(model.foo),
    );
  }
}
```

Any descendant widget can also **update** the model, and it will automatically trigger a rebuild of any `ScopedModelDescendants` (provided that our model invokes `notifyListeners()` correctly):

```
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

[ScopedModel](https://pub.dev/packages/scoped_model) became a popular form of state management in Flutter, but is limited to exposing state objects that extend the [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html) class and its change notifier pattern.

## 4. BLoC

At [Google I/O ’18](https://www.youtube.com/watch?v=RS36gBEp8OI), the [Business Logic Component](https://www.freecodecamp.org/news/how-to-handle-state-in-flutter-using-the-bloc-pattern-8ed2f1e49a13/) (BLoC) pattern was introduced as another pattern for moving state out of widgets. BLoC classes are long-lived, non-UI components that hold onto state and expose it in the form of [streams](http://dart stream listen) and [sinks](https://api.dartlang.org/stable/2.4.0/dart-core/Sink-class.html). By moving state and business logic out of the UI, it allows a widget to be implemented as a simple [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) and use a [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) to automatically rebuild. This makes the widget “dumber” and easier to test.

An example of a BLoC class:

```
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

An example of a widget consuming a BLoC:

```
@override
Widget build(BuildContext context) {
 return StreamBuilder<MyType>(
  stream: myBloc.stream,
  builder: (context, asyncSnapshot) {
    // YOUR CODE
 });
}
```

The trouble with the BLoC pattern is that it is not obvious how to create and destroy BLoC objects. In the example above, how was the `myBloc` instance created? How do we call `dispose()` on it? [Streams](http://dart stream listen) require the use of a [StreamController](https://api.dartlang.org/stable/2.4.0/dart-async/StreamController-class.html), which must be `closed` when no longer needed in order to prevent memory leaks. (Dart has no notion of a class [destructor](https://en.wikipedia.org/wiki/Destructor_(computer_programming)); only the `StatefulWidget` [State](https://api.flutter.dev/flutter/widgets/State-class.html) class has a `dispose()` method.) Also, it is not clear how to share this BLoC across multiple widgets. So it is often difficult for developers to get started using BLoC. There are some [packages](https://pub.dev/flutter/packages?q=bloc) that attempt to make this easier.

## 5. Provider

[Provider](https://pub.dev/packages/provider) is a package written in 2018 by [Remi Rousselet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjXrMKO8dLjAhWoT98KHUCDB_oQFjAAegQIARAB&url=https%3A%2F%2Ftwitter.com%2Fremi_rousselet&usg=AOvVaw3bEIgT0j4c_5xbq-YWB70q) that is similar to [ScopedModel](https://pub.dev/packages/scoped_model) but is not limited to exposing a [Model](https://pub.dev/documentation/scoped_model/latest/scoped_model/Model-class.html) subclass. It too is a wrapper around [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html), but can expose any kind of state object, including BLoC, [streams](http://dart stream listen), [futures](https://api.dartlang.org/stable/dart-async/Future-class.html), and others. Because of its simplicity and flexibility, Google announced at [Google I/O ](https://www.youtube.com/watch?v=d_m5csmrf7I)’19 that [Provider](https://pub.dev/packages/provider) is now its preferred package for state management. Of course, you can still use [others](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options), but if you’re not sure what to use, Google recommends going with [Provider](https://pub.dev/packages/provider).

[Provider](https://pub.dev/packages/provider) is built “with widgets, for widgets.” With [Provider](https://pub.dev/packages/provider), we can place any state object into the widget tree and make it accessible from any other (descendant) widget. [Provider](https://pub.dev/packages/provider) also helps manage the lifetime of state objects by initializing them with data and cleaning up after them when they are removed from the widget tree. For this reason, [Provider](https://pub.dev/packages/provider) can even be used to implement BLoC components, or serve as the basis for [other](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options) state management solutions! 😲 Or it can be used simply for [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) — a fancy term for passing data into widgets in a way that reduces coupling and increases testability. Finally, [Provider](https://pub.dev/packages/provider) comes with a set of specialized classes that make it even more user-friendly. We’ll explore each of these in detail.

* Basic [Provider](https://pub.dev/documentation/provider/latest/provider/Provider-class.html)
* [ChangeNotifierProvider](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html)
* [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html)
* [FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html)
* [ValueListenableProvider](http://ValueListenableProvider)
* [MultiProvider](https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html)
* [ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html)

#### Installing

First, to use [Provider](https://pub.dev/packages/provider), add the dependency to your pubspec.yaml:

```
provider: ^3.0.0
```

Then import the [Provider](https://pub.dev/packages/provider) package where needed:

```
import 'package:provider/provider.dart';
```

#### Basic Provider

Let’s create a basic [Provider](https://pub.dev/packages/provider) at the root of our app containing an instance of our model:

```
Provider<MyModel>(
  builder: (context) => MyModel(),
  child: MyApp(...),
)
```

> The `builder` parameter creates instance of `MyModel`. If you want to give it an existing instance, use the [Provider.value](https://pub.dev/documentation/provider/latest/provider/Provider/Provider.value.html) constructor instead.

We can then **consume** this model instance anywhere in `MyApp`by using the [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) widget:

```
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(
      builder: (context, value, child) => Text(value.foo),
    );
  }
}
```

In the example above, the `MyWidget` class obtains the `MyModel` instance using the [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) widget. This widget gives us a `builder` containing our object in the `value` parameter.

Now, what if we want to **update** the data in our model? Let’s say that we have another widget where pushing a button should update the `foo` property:

```
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

> Note the different syntax for accessing our `MyModel` instance. This is functionally equivalent to using the [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) widget. The [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) widget is useful if you can’t easily get a [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html) reference in your code.

What do you expect will happen to the original `MyWidget` we created earlier? Do you think it will now display the new value of `bar`? **Unfortunately, no**. It is not possible to listen to changes on plain old Dart objects (at least not without [reflection](https://api.dartlang.org/stable/dart-mirrors/dart-mirrors-library.html), which is not available in Flutter). That means [Provider](https://pub.dev/packages/provider) is not able to “see” that we updated the `foo` property and tell `MyWidget` to update in response.

#### ChangeNotifierProvider

However, there is hope! We can make our `MyModel` class implement the [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) mixin. We need to modify our model implementation slightly by invoking a special `notifyListeners()` method whenever one of our properties change. This is similar to how [ScopedModel](https://pub.dev/packages/scoped_model) works, but it’s nice that we don’t need to inherit from a particular model class. We can just implement the [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-%E2%80%A6) mixin. Here’s what that looks like:

```
class MyModel with ChangeNotifier {
  String _foo;

  String get foo => _foo;
  
  void set foo(String value) {
    _foo = value;
    notifyListeners();  
  }
}
```

As you can see, we changed our `foo` property into a `getter` and `setter `backed by a private `_foo` variable. This allows us to “intercept” any changes made to the `foo` property and tell our listeners that our object changed.

Now, on the [Provider](https://pub.dev/packages/provider) side, we can change our implementation to use a different class called [ChangeNotifierProvider](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html):

```
ChangeNotifierProvider<MyModel>(
  builder: (context) => MyModel(),
  child: MyApp(...),
)
```

That’s it! Now when our `OtherWidget` updates the `foo` property on our `MyModel` instance, `MyWidget` will automatically update to reflect that change. Cool huh?

One more thing. You may have noticed in the `OtherWidget` button handler that we used the following syntax:

```
final model = Provider.of<MyModel>(context);
```

**By default, this syntax will automatically cause our `OtherWidget` instance to rebuild whenever `MyModel` changes.** That might not be what we want. After all, `OtherWidget` just contains a button that doesn’t change based on the value of `MyModel` at all. To avoid this, we can use the following syntax to access our model **without** registering for a rebuild:

```
final model = Provider.of<MyModel>(context, listen: false);
```

This is another nicety that the [Provider](https://pub.dev/packages/provider) package gives us for free.

#### StreamProvider

At first glance, the [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) seems unnecessary. After all, we can just use a regular [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) to consume a stream in Flutter. For example, here we listen to the [onAuthStateChanged](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/onAuthStateChanged.html) stream provided by [FirebaseAuth](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/firebase_auth-library.html):

```
@override
Widget build(BuildContext context {
  return StreamBuilder(
   stream: FirebaseAuth.instance.onAuthStateChanged, 
   builder: (BuildContext context, AsyncSnapshot snapshot){ 
     ...
   });
}
```

To do this with [Provider](https://pub.dev/packages/provider) instead, we can expose this stream via a [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) at the root of our app:

```
StreamProvider<FirebaseUser>.value(
  stream: FirebaseAuth.instance.onAuthStateChanged,
  child: MyApp(...),
}
```

Then consume it in a child widget like any other [Provider](https://pub.dev/packages/provider):

```
@override
Widget build(BuildContext context) {
  return Consumer<FirebaseUser>(
    builder: (context, value, child) => Text(value.displayName),
  );
}
```

Besides making the consuming widget code much cleaner, **it also abstracts away the fact that the data is coming from a stream**. If we ever decide to change the underlying implementation to a [FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html), for instance, it will require no changes to our widget code. **In fact, you’ll see that this is the case for all of the different providers below**. 😲

#### FutureProvider

Similar to the example above, [FutureProvider](https://pub.dev/documentation/provider/latest/provider/FutureProvider-class.html) is an alternative to using the standard [FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html) inside our widgets. Here is an example:

```
FutureProvider<FirebaseUser>.value(
  value: FirebaseAuth.instance.currentUser(),
  child: MyApp(...),
);
```

To consume this value in a child widget, we use the same [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) implementation used in the [StreamProvider](https://pub.dev/documentation/provider/latest/provider/StreamProvider-class.html) example above.

#### ValueListenableProvider

[ValueListenable](https://api.flutter.dev/flutter/foundation/ValueListenable-class.html) is a Dart interface implemented by the [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) class that takes a value and notifies listeners when it changes to another value. We can use it to wrap an integer counter in a simple model class:

```
class MyModel {
  final ValueNotifier<int> counter = ValueNotifier(0);  
}
```

> When using complex types, [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) uses the `**==**` operator of the contained object to determine whether the value has changed.

Let’s create a basic [Provider](https://pub.dev/packages/provider) to hold our main model, followed by a [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) and a nested [ValueListenableProvider](https://pub.dev/documentation/provider/latest/provider/ValueListenableProvider-class.html) that listens to the `counter` property:

```
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

> Note that the type of the nested provider is `int`. You might have others. If you have multiple Providers registered for the same type, [Provider](https://pub.dev/packages/provider) will return the “closest” one (nearest ancestor).

Here’s how we can listen to the `counter` property from any descendant widget:

```
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

And here is how we can **update** the `counter` property from yet another widget. Note that we need to access the original `MyModel` instance.

```
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

If we are using many [Provider](https://pub.dev/packages/provider) widgets, we may end up with an ugly nested structure at the root of our app:

```
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

[MultiProvider](https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html) lets us declare them all our providers at the same level. This is just [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar); they are still being nested behind the scenes.

```
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

[ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html) is an interesting class that was added in the v3 release of the [Provider](https://pub.dev/packages/provider) package. This lets us declare Providers that themselves are dependent on up to 6 other Providers. In this example, the `Bar` class depends on an instance of `Foo.` This is useful when establishing a root set of services that themselves have dependencies on one another.

```
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

> The first generic type argument is the type your [ProxyProvider](https://pub.dev/documentation/provider/latest/provider/ProxyProvider-class.html) depends on, and the second is the type it returns.

#### Listening to Multiple Providers Simultaneously

What if we want a single widget to list to multiple Providers, and trigger a rebuild whenever any of them change? We can listen to up to 6 Providers at a time using variants of the [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) widget. We will receive the instances as additional parameters in the `builder` method.

```
Consumer2<MyModel, int>(
  builder: (context, value, value2, child) {
    //value is MyModel
    //value2 is int
  },
);
```

#### Conclusion

By embracing [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html), [Provider](https://pub.dev/packages/provider) gives us a “Fluttery” way of state management. It lets widgets access and listen to state objects in a way that abstracts away the underlying notification mechanism. It helps us manage the lifetimes of state objects by providing hooks to create and dispose them as needed. It can be used for simple dependency injection, or even as the basis for more extensive state management options. Having received Google’s blessing, and with growing support from the Flutter community, it is a safe choice to go with. Give [Provider](https://pub.dev/packages/provider) a try today!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
