> * 原文地址：[Flutter: Infinite ListView with Redux](https://medium.com/flutter-community/flutter-redux-infinite-listview-b57e81ca4ef4)
> * 原文作者：[Pavel Sulimau](https://medium.com/@pavel.sulimau)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-infinite-listview-with-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-infinite-listview-with-redux.md)
> * 译者：[Xat_MassacrE](https://github.com/XatMassacrE)
> * 校对者：[TsichiChang](https://github.com/TsichiChang)

# Flutter: 使用 Redux 实现无限滚动的 ListView

![](https://cdn-images-1.medium.com/max/3840/1*spVWmt32pcQItXguvspQqw.jpeg)

## 动机

如果你需要实现一个具有多页面的应用程序，而且其中的一个页面需要用列表的形式来展示数据。那么我将会告诉你如何基于 **Flutter** + **Redux** 来开发出一个具有 『下拉刷新』和『错误处理』功能的『无限』列表应用。

## 预备知识

首先要确保你对 [redux.dart](https://github.com/johnpryan/redux.dart) 和 [flutter_redux](https://github.com/brianegan/flutter_redux) 这两个文档中的术语有足够的了解。其次建议你阅读一下[我之前的文章](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f)。

## 目标

实现一个展示 [Flutter issues 列表](https://github.com/flutter/flutter/issues) 的 demo。

下图就是我们实现之后的样子。

![](https://cdn-images-1.medium.com/max/2000/1*EdwqcExhCgZYHytAU-sUxA.gif)

## 开发

首先我们需要 [flutter_redux](https://pub.dev/packages/flutter_redux) 和 [http](https://pub.dev/packages/http) 包，将这两个包添加到 **pubspec.yaml** 文件中并安装它们。同时，[intl](https://pub.dev/packages/intl) 和 [redux_logging](https://pub.dev/packages/redux_logging) 这两个包对于日期格式化以及调试也是非常有用的。

#### Model

Model 是一个包含 Github issue 属性的简单类，同时也可以通过 JSON 来实例化。

```Dart
import 'package:intl/intl.dart';

class GithubIssue {
  final String title;
  final String state;
  final DateTime createdAt;

  String get createdAtFormatted =>
      DateFormat.yMMMd().add_Hm().format(createdAt);

  GithubIssue.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        state = json['state'],
        createdAt = DateTime.parse(json['created_at']);
}
```

#### State

我们需要在 state 中记录的数据并不多：一个包含多个 issue 的列表，一个数据是否被载入的标志位，一个是否还有更多数据的标志位以及错误信息。

```Dart
import 'package:flutter_redux_infinite_list/models/github_issue.dart';

class AppState {
  AppState({
    this.isDataLoading,
    this.isNextPageAvailable,
    this.items,
    this.error,
  });

  final bool isDataLoading;
  final bool isNextPageAvailable;
  final List<GithubIssue> items;
  final Exception error;

  static const int itemsPerPage = 20;

  factory AppState.initial() => AppState(
        isDataLoading: false,
        isNextPageAvailable: false,
        items: const [],
      );

  AppState copyWith({
    isDataLoading,
    isNextPageAvailable,
    items,
    error,
  }) {
    return AppState(
      isDataLoading: isDataLoading ?? this.isDataLoading,
      isNextPageAvailable: isNextPageAvailable ?? this.isNextPageAvailable,
      items: items ?? this.items,
      error: error != this.error ? error : this.error,
    );
  }

  @override
  String toString() {
    return "AppState: isDataLoading = $isDataLoading, "
        "isNextPageAvailable = $isNextPageAvailable, "
        "itemsLength = ${items.length}, "
        "error = $error.";
  }
}

```

你们会注意到这里有一个 `toString` 方法。它的主要作用是调试和未来更方便的使用 `LoggingMiddleware`。

#### Actions

这里有两个 actions 用来处理真实数据，还有两个 actions 用来处理可能的错误。

```Dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux_infinite_list/models/github_issue.dart';
import 'package:meta/meta.dart';

class LoadItemsPageAction {
  LoadItemsPageAction({
    @required this.pageNumber,
    @required this.itemsPerPage,
  });

  final int pageNumber;
  final int itemsPerPage;
}

class ItemsPageLoadedAction {
  ItemsPageLoadedAction(this.itemsPage);

  final List<GithubIssue> itemsPage;
}

class ErrorOccurredAction {
  ErrorOccurredAction(this.exception);

  final Exception exception;
}

class ErrorHandledAction {}
```

#### Reducers

Reducer 会根据接收到的 action 创建新的 state，它会比 action 复杂一点，但是也并没有复杂很多。它们其实就是一些由 Redux 库提供的 `combineReducers` 函数结合起来的纯函数而已。

```Dart
import 'actions.dart';
import 'package:flutter_redux_infinite_list/models/github_issue.dart';
import 'package:flutter_redux_infinite_list/redux/state.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, action) {
  return state.copyWith(
    isDataLoading: _isDataLoadingReducer(state.isDataLoading, action),
    isNextPageAvailable:
        _isNextPageAvailableReducer(state.isNextPageAvailable, action),
    items: _itemsReducer(state.items, action),
    error: _errorReducer(state.error, action),
  );
}

final Reducer<bool> _isDataLoadingReducer = combineReducers<bool>([
  TypedReducer<bool, LoadItemsPageAction>(_isDataLoadingStartedReducer),
  TypedReducer<bool, ItemsPageLoadedAction>(_isDataLoadingFinishedReducer),
  TypedReducer<bool, ErrorOccurredAction>(_isDataLoadingFinishedReducer),
]);

bool _isDataLoadingStartedReducer(bool _, dynamic action) {
  return true;
}

bool _isDataLoadingFinishedReducer(bool _, dynamic action) {
  return false;
}

bool _isNextPageAvailableReducer(bool isNextPageAvailable, dynamic action) {
  return (action is ItemsPageLoadedAction)
      ? action.itemsPage.length == AppState.itemsPerPage
      : isNextPageAvailable;
}

List<GithubIssue> _itemsReducer(List<GithubIssue> items, dynamic action) {
  if (action is ItemsPageLoadedAction) {
    return List.from(items)..addAll(action.itemsPage);
  } else if (action is LoadItemsPageAction && action.pageNumber == 1) {
    return List<GithubIssue>();
  } else {
    return items;
  }
}

final Reducer<Exception> _errorReducer = combineReducers<Exception>([
  TypedReducer<Exception, ErrorOccurredAction>(_errorOccurredReducer),
  TypedReducer<Exception, ErrorHandledAction>(_errorHandledReducer),
]);

Exception _errorOccurredReducer(Exception _, ErrorOccurredAction action) {
  return action.exception;
}

Exception _errorHandledReducer(Exception _, ErrorHandledAction action) {
  return null;
}

```

#### Middleware

这里使用的 middleware 基本上是由加载数据的 API 函数和发送成功或失败的 action 构成的。

```Dart
import 'dart:convert';
import 'package:flutter_redux_infinite_list/models/github_issue.dart';
import 'package:flutter_redux_infinite_list/redux/actions.dart';
import 'package:flutter_redux_infinite_list/redux/state.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

List<Middleware<AppState>> createAppMiddleware() {
  return [
    TypedMiddleware<AppState, LoadItemsPageAction>(_loadItemsPage()),
    LoggingMiddleware.printer(),
  ];
}

_loadItemsPage() {
  return (Store<AppState> store, LoadItemsPageAction action,
      NextDispatcher next) {
    next(action);

    _loadFlutterGithubIssues(action.pageNumber, action.itemsPerPage).then(
      (itemsPage) {
        store.dispatch(ItemsPageLoadedAction(itemsPage));
      },
    ).catchError((exception, stacktrace) {
      store.dispatch(ErrorOccurredAction(exception));
    });
  };
}

Future<List<GithubIssue>> _loadFlutterGithubIssues(
    int page, int perPage) async {
  var response = await http.get(
      'https://api.github.com/repos/flutter/flutter/issues?page=$page&per_page=$perPage');
  if (response.statusCode == 200) {
    final items = json.decode(response.body) as List;
    return items.map((item) => GithubIssue.fromJson(item)).toList();
  } else {
    throw Exception('Error getting data, http code: ${response.statusCode}.');
  }
}

```

#### Container

现在，我们离视图层又近了一步。这里的 container 组件可以将最新的 **App State** 转换成一个 `_ViewModel` 并将 `_ViewModel` 与视图组件连接起来。

```Dart
import 'package:flutter_redux_infinite_list/models/github_issue.dart';
import 'package:flutter_redux_infinite_list/presentation/screens/home_screen.dart';
import 'package:flutter_redux_infinite_list/redux/actions.dart';
import 'package:flutter_redux_infinite_list/redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, vm) {
        return HomeScreen(
          isDataLoading: vm.isDataLoading,
          isNextPageAvailable: vm.isNextPageAvailable,
          items: vm.items,
          refresh: vm.onRefresh,
          loadNextPage: vm.onLoadNextPage,
          noError: vm.noError,
        );
      },
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(
          LoadItemsPageAction(pageNumber: 1, itemsPerPage: AppState.itemsPerPage),
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    this.isDataLoading,
    this.isNextPageAvailable,
    this.items,
    this.store,
    this.noError,
  });

  final bool isDataLoading;
  final bool isNextPageAvailable;
  final List<GithubIssue> items;
  final Store<AppState> store;
  final bool noError;

  void onLoadNextPage() {
    if (!isDataLoading && isNextPageAvailable) {
      store.dispatch(LoadItemsPageAction(
        pageNumber: (items.length ~/ AppState.itemsPerPage) + 1,
        itemsPerPage: AppState.itemsPerPage,
      ));
    }
  }

  void onRefresh() {
    store.dispatch(
      LoadItemsPageAction(pageNumber: 1, itemsPerPage: AppState.itemsPerPage),
    );
  }

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isDataLoading: store.state.isDataLoading,
      isNextPageAvailable: store.state.isNextPageAvailable,
      items: store.state.items,
      store: store,
      noError: store.state.error == null,
    );
  }
}

```

#### Presentation

这个部分将会更加有趣。让我们先从 `HomeScreen` 中用到的两个展示组件开始：`CustomProgressIndicator` 和 `GithubIssueListItem`。

```Dart
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  CustomProgressIndicator({this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : Container(width: 0.0, height: 0.0);
  }
}
```

```Dart
import 'package:flutter/material.dart';
import 'package:flutter_redux_infinite_list/models/github_issue.dart';

class GithubIssueListItem extends StatelessWidget {
  const GithubIssueListItem({
    Key key,
    @required this.itemIndex,
    @required this.githubIssue,
  }) : super(key: key);

  final int itemIndex;
  final GithubIssue githubIssue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        title: Text(
          '#${itemIndex + 1}: ${githubIssue.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(githubIssue.createdAtFormatted),
            Text(githubIssue.state),
          ],
        ),
        isThreeLine: true,
      ),
      height: 60.0,
    );
  }
}

```

**下面是主要的展示逻辑**

**注意一下 `HomeScreen`**。这里有好几个值得关注的点：

1. 页面包含的 `ScrollController` 决定了是否需要调用 `loadNextPage` 函数。
2. 在这里使用了 `Debouncer`（具体实现见下文）。它是一个含有定时器功能的简单类，能够确保来自 `ScrollController` 的连续事件不会触发大量的下一页请求，而是在一个特定时间段之内只发送一次请求。
3. `RefreshIndicator` 可以在我们使用『下拉刷新』功能时给予提示。
4. 当发生错误的时候 `ErrorNotifier` 将会显示 toast 通知。如果你需要在该通知中更多的显示详细信息，可以看看[我之前的文章](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f)。

```Dart
import 'package:flutter_redux_infinite_list/common/debouncer.dart';
import 'package:flutter_redux_infinite_list/models/github_issue.dart';
import 'package:flutter_redux_infinite_list/presentation/components/custom_progress_indicator.dart';
import 'package:flutter_redux_infinite_list/presentation/components/github_issue_list_item.dart';
import 'package:flutter_redux_infinite_list/presentation/error_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    this.isDataLoading,
    this.isNextPageAvailable,
    this.items,
    this.refresh,
    this.loadNextPage,
    this.noError,
  });

  final bool isDataLoading;
  final bool isNextPageAvailable;
  final List<GithubIssue> items;
  final Function refresh;
  final Function loadNextPage;
  final bool noError;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  final _scrollThresholdInPixels = 100.0;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite ListView with Redux'),
      ),
      body: ErrorNotifier(
        child: widget.isDataLoading && widget.items.length == 0
            ? CustomProgressIndicator(isActive: widget.isDataLoading)
            : RefreshIndicator(
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: widget.isNextPageAvailable
                      ? widget.items.length + 1
                      : widget.items.length,
                  itemBuilder: (context, index) {
                    return (index < widget.items.length)
                        ? GithubIssueListItem(
                            itemIndex: index, githubIssue: widget.items[index])
                        : CustomProgressIndicator(isActive: widget.noError);
                  },
                  controller: _scrollController,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: Theme.of(context).dividerColor),
                ),
                onRefresh: _onRefresh,
              ),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThresholdInPixels &&
        !widget.isDataLoading) {
      _debouncer.run(() => widget.loadNextPage());
    }
  }

  Future _onRefresh() {
    widget.refresh();
    return Future.value();
  }
}

```

下面是 `ErrorNotifer` 的代码。

```Dart
import 'package:flutter_redux_infinite_list/redux/actions.dart';
import 'package:flutter_redux_infinite_list/redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class ErrorNotifier extends StatelessWidget {
  ErrorNotifier({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) => child,
      onDidChange: (vm) {
        if (vm.error != null) {
          vm.markErrorAsHandled();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(vm.error.toString()),
            ),
          );
        }
      },
      distinct: true,
    );
  }
}

class _ViewModel {
  _ViewModel({
    this.markErrorAsHandled,
    this.error,
  });

  final Function markErrorAsHandled;
  final Exception error;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      markErrorAsHandled: () => store.dispatch(ErrorHandledAction()),
      error: store.state.error,
    );
  }

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is _ViewModel && other.error == this.error;
}

```

下图就是在 action 中 `ErrorNotifier` 呈现的样子。

![](https://cdn-images-1.medium.com/max/2000/1*6cesoZFB8Hj9UaLQgffcKA.gif)

接下来就是上文提到的 `Debouncer`。

```Dart
import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({this.milliseconds});

  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  run(VoidCallback action) {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
```

最后就是把所有声明的组件都结合起来的 `main.dart` 文件。

```Dart
import 'package:flutter_redux_infinite_list/redux/containers/home_container.dart';
import 'package:flutter_redux_infinite_list/redux/middleware.dart';
import 'package:flutter_redux_infinite_list/redux/reducers.dart';
import 'package:flutter_redux_infinite_list/redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: createAppMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeContainer(),
        theme: ThemeData(
          primaryColor: Color(0xFF0054A0),
        ),
      ),
    );
  }
}
```

不要犹豫，自己一定要去试一试，你可以从 [Github repo](https://github.com/Pavel-Sulimau/flutter_redux_infinite_list) 获取本文源码。

## 参考资源：

* [https://medium.com/filledstacks/flutter-redux-quick-start-3f549f5b05c5](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f)
* [https://github.com/johnpryan/redux.dart](https://github.com/johnpryan/redux.dart)
* [https://github.com/brianegan/flutter_redux](https://github.com/brianegan/flutter_redux)
* [https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart](https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
