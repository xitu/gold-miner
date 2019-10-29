> * 原文地址：[Flutter State Management: setState, BLoC, ValueNotifier, Provider](https://medium.com/coding-with-flutter/flutter-state-management-setstate-bloc-valuenotifier-provider-2c11022d871b)
> * 原文作者：[Andrea Bizzotto](https://medium.com/@biz84)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-state-management-setstate-bloc-valuenotifier-provider.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-state-management-setstate-bloc-valuenotifier-provider.md)
> * 译者：[talisk](https://github.com/talisk)
> * 校对者：[Fxy4ever](https://github.com/Fxy4ever)

# Flutter 的状态管理方案：setState、BLoC、ValueNotifier、Provider

![](https://cdn-images-1.medium.com/max/3200/1*rXFefCEa1qbzIq7sefbZDA.jpeg)

本文是[这个视频](https://youtu.be/7eaV9gSnaXw)中的重点内容，我们比较了不同的状态管理方案。

例如，我们使用简单的身份验证流程。当登录请求发起时，设置正在加载中的状态。

为简单起见，此流程由三种可能的状态组成：

![](https://cdn-images-1.medium.com/max/4676/1*OhO8kZJhTODjQj_CZfGZBQ.png)

图上的状态可以由如下状态机表示，其中包括**加载**状态和**认证**状态：

![](https://cdn-images-1.medium.com/max/2000/1*Oumxsqd0R9E2KgbBNfzfOA.png)

当登录的请求正在进行中，我们会禁用登录按钮并展示进度指示器。

此示例 app 展示了如何使用各种状态管理方案处理加载状态。

## 主要导航

登录页面的主要导航是通过一个小部件实现的，该小部件使用 [Drawer](https://api.flutter.dev/flutter/material/Drawer-class.html) 菜单在不同选项中进行选择。

![](https://cdn-images-1.medium.com/max/2700/1*FSD9i9fNx2YkhC-6dyvRmg.png)

代码如下：

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

这个 widget 展示了这样一个 `Scaffold`：

* `AppBar` 的标题是选中的项目名称
* drawer 使用了自定义构造器 `MenuSwitcher`
* body 使用了一个 switch 语句来区分不同的页

## 参考流程（vanilla）

要启用登录，我们可以从没有加载状态的简易 vanilla 实现开始：

```Dart
class SignInPageVanilla extends StatelessWidget {
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthService>(context);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: '登录失败',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignInButton(
        text: '登录',
        onPressed: () => _signInAnonymously(context),
      ),
    );
  }
}

```

当点击 `SignInButton` 按钮，就调用 `_signInAnonymously` 方法。

这里使用了 [Provider](https://pub.dev/packages/provider) 来获取 `AuthService` 对象，并将它用于登录。

**札记**

* `AuthService` 是一个对 Firebase Authentication 的简单封装。详情请见[这篇文章](https://medium.com/coding-with-flutter/flutter-designing-an-authentication-api-with-service-classes-45ec8d55963e)。
* 身份验证状态由一个祖先 widget 处理，该 widget 使用 `onAuthStateChanged` 来决定展示哪个页面。我在[前一篇文章](https://medium.com/coding-with-flutter/super-simple-authentication-flow-with-flutter-firebase-737bba04924c)中介绍了这一点。

## setState

加载状态可以经过以下流程，添加到刚刚的实现中：

* 将我们的 widget 转化为 `StatefulWidget`
* 定义一个局部 state 变量
* 将该 state 放进 build 方法中
* 在登录前和登录后更新它

以下是最终代码：

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
        title: '登录失败',
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
        text: '登录',
        loading: _isLoading,
        onPressed: _isLoading ? null : () => _signInAnonymously(),
      ),
    );
  }
}
```

**重要提示**：请注意我们如何使用 [`finally`](https://dart.dev/guides/language/language-tour#finally) 闭包。无论是否抛出异常，这都可被用于执行某些代码。

## BLoC

加载状态可以由 BLoC 中，stream 的值表示。

我们需要一些额外的示例代码来设置：

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
        title: '登录失败',
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
            text: '登录',
            loading: isLoading,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        );
      },
    );
  }
}
```

简而言之，这段代码：

* 使用 `StreamController<bool>` 添加一个 `SignInBloc`，用于处理加载状态。
* 通过静态 `create` 方法中的 Provider / Consumer，让 `SignInBloc` 可以访问我们的 widget。
* 在 `_signInAnonymously` 方法中，通过调用 `bloc.setIsLoading(value)` 来更新 stream。
* 通过 `StreamBuilder` 来检查加载状态，并使用它来设置登录按钮。

## 关于 RxDart 的注意事项

`BehaviorSubject` 是一种特殊的 stream 控制器，它允许我们**同步地**访问 stream 的最后一个值。

作为 BloC 的替代方案，我们可以使用 `BehaviorSubject` 来跟踪加载状态，并根据需要进行更新。

我会通过 [GitHub 项目](https://github.com/bizz84/simple_auth_comparison_flutter) 来展示具体如何实现。

## ValueNotifier

[`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) 可以被用于持有一个值，并当它变化的时候通知它的监听者。

实现相同的流程代码如下：

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
        title: '登录失败',
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
        text: '登录',
        loading: loading.value,
        onPressed: loading.value ? null : () => _signInAnonymously(context),
      ),
    );
  }
}
```

在 `静态 create` 方法中，我们使用了 `ValueNotifier<bool>` 的 [`ChangeNotifierProvider`](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html) 和 [`Consumer`](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html)，这为我们提供了一种表示加载状态的方法，并在更改时重建 widget。

## ValueNotifier vs ChangeNotifier

[`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) 和 [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) 密切相关。

实际上，`ValueNotifier` 就是实现了 `ValueListenable<T>` 的 `ChangeNotifier` 的子类。

这是 Flutter SDK 中 `ValueNotifier` 的实现：

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

所以我们应该什么时候用 `ValueNotifier`，什么时候用 `ChangeNotifier` 呢？

* 如果在简单值更改时需要重建 widget，请使用 `ValueNotifier`。
* 如果你想在 `notifyListeners()` 调用时有更多掌控，请使用 `ChangeNotifier`。

## 关于 ScopedModel 的注意事项

`ChangeNotifierProvider` 非常类似于 [ScopedModel](https://pub.dev/packages/scoped_model)。实际上，他们之间几乎相同：

* `ScopedModel` ↔︎ `ChangeNotifierProvider`
* `ScopedModelDescendant` ↔︎ `Consumer`

因此，如果你已经在使用 Provider，则不需要 ScopedModel，因为 `ChangeNotifierProvider` 提供了相同的功能。

## 最后的比较

上述三种实现（setState、BLoC、ValueNotifier）非常相似，只是处理加载状态的方式不同。

如下是他们的比较方式：

* setState ↔︎ **最精简**的代码
* BLoC ↔︎ **最多**的代码
* ValueNotifier ↔︎ **中等水平**

所以 `setState` 方案最适合**这个例子**，因为我们需要处理单个小部件的**各自的状态**。

在构建自己的应用程序时，你可以根据具体情况来评估哪个方案更合适 😉

## 小彩蛋：实现 Drawer 菜单

跟踪当前选择的选项也是一个状态管理问题：

![](https://cdn-images-1.medium.com/max/2700/1*FSD9i9fNx2YkhC-6dyvRmg.png)

我首先在自定义 Drawer 菜单中使用本地状态变量和 `setState` 实现它。

但是登录后状态丢失了，因为 Drawer 已经从 widget 树中删除。

有一个方案，我决定在 `LandingPage` 中使用 `ChangeNotifierProvider<ValueNotifier<Option>>` 存储状态：

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

这里使用 [`StreamBuilder`](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) 来控制用户的身份验证状态。

通过使用 `ChangeNotifierProvider<ValueNotifier<Option>>` 来包装它，即使在删除 `SignInPageNavigation` 之后，我也能保留所选的选项。

总结如下：

* StatefulWidget 在 state 被删除后，不再**记住**自己的 state。
* 使用 Provider，我们可以选择**在哪里**存储 widget 树中的状态。
* 这样，即使删除使用它的小部件，状态也会被**保留**。

`ValueNotifier` 比 `setState` 需要更多的代码。但它可以用来**记住**状态，通过在 widget 树中放置适当的 Provider。

## 源代码

可以在这里找到本教程中的示例代码：

* [State Management Comparison: [ setState ❖ BLoC ❖ ValueNotifier ❖ Provider ]](https://github.com/bizz84/simple_auth_comparison_flutter)

所有这些状态管理方案都在我的 Flutter & Firebase Udemy 课程中有深入介绍。这可以通过此链接进行了解（点这个链接有折扣哦）：

* [Flutter & Firebase: Build a Complete App for iOS & Android](https://www.udemy.com/flutter-firebase-build-a-complete-app-for-ios-android/?couponCode=DART15&password=codingwithflutter)

祝你代码敲得开心！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
