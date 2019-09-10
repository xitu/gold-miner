> * 原文地址：[Flutter State Management: setState, BLoC, ValueNotifier, Provider](https://medium.com/coding-with-flutter/flutter-state-management-setstate-bloc-valuenotifier-provider-2c11022d871b)
> * 原文作者：[Andrea Bizzotto](https://medium.com/@biz84)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-state-management-setstate-bloc-valuenotifier-provider.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-state-management-setstate-bloc-valuenotifier-provider.md)
> * 译者：
> * 校对者：

# Flutter State Management: setState, BLoC, ValueNotifier, Provider

![](https://cdn-images-1.medium.com/max/3200/1*rXFefCEa1qbzIq7sefbZDA.jpeg)

This article is a write-up of the highlights in [this video](https://youtu.be/7eaV9gSnaXw), where we compare different state management techniques.

As an example, we use a simple authentication flow. This sets a loading state while a sign-in request is in progress.

For simplicity, this flow is composed of three possible states:

![](https://cdn-images-1.medium.com/max/4676/1*OhO8kZJhTODjQj_CZfGZBQ.png)

These are represented by the following state machine, which includes a **loading** state and an **authentication** state:

![](https://cdn-images-1.medium.com/max/2000/1*Oumxsqd0R9E2KgbBNfzfOA.png)

When a sign-in request is in progress, we disable the sign-in button and show a progress indicator.

This example app shows how to handle the loading state with various state management techniques.

## Main Navigation

The main navigation for the sign-in page is implemented with a widget that uses a [Drawer](https://api.flutter.dev/flutter/material/Drawer-class.html) menu to choose between different options:

![](https://cdn-images-1.medium.com/max/2700/1*FSD9i9fNx2YkhC-6dyvRmg.png)

The code for this is as follows:

```Dart
class SignInPageNavigation extends StatelessWidget {
  const SignInPageNavigation({Key key, this.option}) : super(key: key);
  final ValueNotifier<Option> option;

  Option get _option => option.value;
  OptionData get _optionData => optionsData[_option];

  void _onSelectOption(Option selectedOption) {
    option.value = selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_optionData.title),
      ),
      drawer: MenuSwitcher(
        options: optionsData,
        selectedOption: _option,
        onSelected: _onSelectOption,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_option) {
      case Option.vanilla:
        return SignInPageVanilla();
      case Option.setState:
        return SignInPageSetState();
      case Option.bloc:
        return SignInPageBloc.create(context);
      case Option.valueNotifier:
        return SignInPageValueNotifier.create(context);
      default:
        return Container();
    }
  }
}
```

This widget shows a `Scaffold` where:

* the `AppBar`’s title is the name of the selected option
* the drawer uses a custom built `MenuSwitcher`
* the body uses a switch to choose between different pages

## Reference flow (vanilla)

To enable sign-in, we can start with a simple vanilla implementation that doesn’t have a loading state:

```Dart
class SignInPageVanilla extends StatelessWidget {
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthService>(context);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignInButton(
        text: 'Sign in',
        onPressed: () => _signInAnonymously(context),
      ),
    );
  }
}

```

When the `SignInButton` is pressed, we call the `_signInAnonymously` method.

This uses [Provider](https://pub.dev/packages/provider) to get an `AuthService` object, and uses it to sign-in.

**NOTES**

* `AuthService` is a simple wrapper for Firebase Authentication. See [this article](https://medium.com/coding-with-flutter/flutter-designing-an-authentication-api-with-service-classes-45ec8d55963e) for more details.
* The authentication state is handled by an ancestor widget, that uses the `onAuthStateChanged` stream to decide which page to show. I covered this [in a previous article](https://medium.com/coding-with-flutter/super-simple-authentication-flow-with-flutter-firebase-737bba04924c).

## setState

The loading state can be added to the previous implementation by:

* Converting our widget to a `StatefulWidget`
* Declaring a local state variable
* Using it inside our build method
* Updating it before and after the call to sign in.

This is the resulting code:

```Dart
class SignInPageSetState extends StatefulWidget {
  @override
  _SignInPageSetStateState createState() => _SignInPageSetStateState();
}

class _SignInPageSetStateState extends State<SignInPageSetState> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthService>(context);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignInButton(
        text: 'Sign in',
        loading: _isLoading,
        onPressed: _isLoading ? null : () => _signInAnonymously(),
      ),
    );
  }
}
```

**Top Tip**: Note how we use a `[finally](https://dart.dev/guides/language/language-tour#finally)` clause. This can be used to execute some code, whether or not an exception was thrown.

## BLoC

The loading state can be represented by the values of a stream inside a BLoC.

And we need some extra boilerplate code to set things up:

```Dart
class SignInBloc {
  final _loadingController = StreamController<bool>();
  Stream<bool> get loadingStream => _loadingController.stream;

  void setIsLoading(bool loading) => _loadingController.add(loading);

  dispose() {
    _loadingController.close();
  }
}

class SignInPageBloc extends StatelessWidget {
  const SignInPageBloc({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      builder: (_) => SignInBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPageBloc(bloc: bloc),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthService>(context);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } finally {
      bloc.setIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {
        final isLoading = snapshot.data;
        return Center(
          child: SignInButton(
            text: 'Sign in',
            loading: isLoading,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        );
      },
    );
  }
}
```

In a nutshell, this code:

* Adds a `SignInBloc` with a `StreamController<bool>` that is used to handle the loading state
* Makes the `SignInBloc` accessible to our widget with a Provider/Consumer pair inside a `static create` method.
* Calls `bloc.setIsLoading(value)` to update the stream, inside the `_signInAnonymously` method
* Retrieves the loading state via a `StreamBuilder`, and uses it to configure the sign-in button.

## Note about RxDart

`BehaviourSubject` is special stream controller that gives us **synchronous** access to the last value of the stream.

As an alternative to BloC, we could use a `BehaviourSubject` to keep track of the loading state, and update it as needed.

I will update the [GitHub project](https://github.com/bizz84/simple_auth_comparison_flutter) to show how to do this.

## ValueNotifier

A `[ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)` can be used to hold a single value, and notify its listeners when this changes.

This is used to implement the same flow:

```Dart
class SignInPageValueNotifier extends StatelessWidget {
  const SignInPageValueNotifier({Key key, this.loading}) : super(key: key);
  final ValueNotifier<bool> loading;

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            SignInPageValueNotifier(
              loading: isLoading,
            ),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      loading.value = true;
      final auth = Provider.of<AuthService>(context);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignInButton(
        text: 'Sign in',
        loading: loading.value,
        onPressed: loading.value ? null : () => _signInAnonymously(context),
      ),
    );
  }
}
```

Inside the `static create` method, we use a `[ChangeNotifierProvider](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html)`/`[Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html)` with a `ValueNotifier<bool>`. This gives us a way to represent the loading state, and rebuild the widget when it changes.

## ValueNotifier vs ChangeNotifier

`[ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)` and `[ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)` are closely related.

In fact, `ValueNotifier` is a subclass of `ChangeNotifier` that implements `ValueListenable<T>`.

This is the implementation of `ValueNotifier` in the Flutter SDK:

```Dart
/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class ValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  ValueNotifier(this._value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue)
      return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
```

So, when should we use `ValueNotifier` vs `ChangeNotifier`?

* Use `ValueNotifier` if you need widgets to rebuild when a simple value changes.
* Use `ChangeNotifier` if you want more control on when `notifyListeners()` is called.

## Note about ScopedModel

`ChangeNotifierProvider` is very similar to [ScopedModel](https://pub.dev/packages/scoped_model). In fact these pairs are almost equivalent:

* `ScopedModel` ↔︎ `ChangeNotifierProvider`
* `ScopedModelDescendant` ↔︎ `Consumer`

So you don’t need ScopedModel if you are already using Provider, as `ChangeNotifierProvider` offers the same functionality.

## Final comparison

The three implementations (setState, BLoC, ValueNotifier) are very similar, and only differ in how the loading state is handled.

Here is how they compare:

* setState ↔︎ **least** amount of code
* BLoC ↔︎ **most** amount of code
* ValueNotifier ↔︎ **middle ground**

So `setState` works best **for this use case**, as we need to handle state that is **local to a single widget**.

You can evaluate which one is more suitable on a case-by-case basis, as you build your own apps 😉

## Bonus: Implementing the Drawer Menu

Keeping track of the currently selected option is also a state management problem:

![](https://cdn-images-1.medium.com/max/2700/1*FSD9i9fNx2YkhC-6dyvRmg.png)

I first implemented this with a local state variable and `setState`, inside the custom drawer menu.

However, the state was lost after sign-in in, because the drawer was removed from the widget tree.

As a solution, I decided to store the state with a `ChangeNotifierProvider<ValueNotifier<Option>>` inside the `LandingPage`:

```Dart
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Used to keep track of the selected option across sign-in events
    final authService = Provider.of<AuthService>(context);
    return ChangeNotifierProvider<ValueNotifier<Option>>(
      builder: (_) => ValueNotifier<Option>(Option.vanilla),
      child: StreamBuilder<User>(
        stream: authService.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return Consumer<ValueNotifier<Option>>(
                builder: (_, ValueNotifier<Option> option, __) =>
                    SignInPageNavigation(option: option),
              );
            }
            return HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
```

Here, the `[StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)` controls the authentication state of the user.

And by wrapping this with a `ChangeNotifierProvider<ValueNotifier<Option>>`, I’m able to retain the selected option even after the `SignInPageNavigation` is removed.

In summary:

* StatefulWidgets don’t **remember** their state **after** they are removed.
* With Provider, we can choose **where** to store state in the widget tree.
* This way, the state is **retained** even when the widgets that use it are removed.

`ValueNotifier` requires a bit more code than `setState`. But it can be used to **remember** the state, by placing a Provider where appropriate in the widget tree.

## Source code

The example code from this tutorial can be found here:

* [State Management Comparison: [ setState ❖ BLoC ❖ ValueNotifier ❖ Provider ]](https://github.com/bizz84/simple_auth_comparison_flutter)

All these state management techniques are covered in-depth in my Flutter & Firebase Udemy course. This is available for early access at this link (discount code included):

* [Flutter & Firebase: Build a Complete App for iOS & Android](https://www.udemy.com/flutter-firebase-build-a-complete-app-for-ios-android/?couponCode=DART15&password=codingwithflutter)

Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
