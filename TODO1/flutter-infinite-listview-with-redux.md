> * 原文地址：[Flutter: Infinite ListView with Redux](https://medium.com/flutter-community/flutter-redux-infinite-listview-b57e81ca4ef4)
> * 原文作者：[Pavel Sulimau](https://medium.com/@pavel.sulimau)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-infinite-listview-with-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-infinite-listview-with-redux.md)
> * 译者：
> * 校对者：

# Flutter: Infinite ListView with Redux

![](https://cdn-images-1.medium.com/max/3840/1*spVWmt32pcQItXguvspQqw.jpeg)

## Motivation

If you need to implement an app with more than one screen the odds are that one of the screens will represent its data in some form of a list. I’d like to show you how you can develop an “infinite” list of items with “pull-to-refresh” and “error-handling” on top of **Flutter** + **Redux**.

## Prerequisites

Make sure you feel comfortable with the terms described in the docs in [redux.dart](https://github.com/johnpryan/redux.dart) and [flutter_redux](https://github.com/brianegan/flutter_redux) repositories. I would also suggest that you take a look at [my previous article](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f).

## Goal

An app that displays [issues from the flutter GitHub repository](https://github.com/flutter/flutter/issues) sounds reasonable to me for the sake of this demo.

Here is the result that will be achieved in the end:

![](https://cdn-images-1.medium.com/max/2000/1*EdwqcExhCgZYHytAU-sUxA.gif)

## Development

We’ll need [flutter_redux](https://pub.dev/packages/flutter_redux) and [http](https://pub.dev/packages/http) packages, so get them added to your **pubspec.yaml** file and installed. Also, [intl](https://pub.dev/packages/intl) package and [redux_logging](https://pub.dev/packages/redux_logging) packages will be useful for date formatting and debugging purposes respectively.

#### Model

It’s just a simple class for holding some info about a Github issue. It also can initialize itself from a piece of JSON.

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

There is not so much data that we’ll need to keep inside the state: the list of items, the flags indicating whether the data is being loaded and whether there is more data available, and the error.

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

You may have noticed the `toString` method. It can be used for debugging purposes and comes in handy if you decide to use `LoggingMiddleware`.

#### Actions

There are two actions for dealing with actual data and two actions for dealing with a possible error.

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

The reducers that create a new state based on a received action are a bit more complicated than actions, but only a bit. They are just simple pure functions that are combined by the `combineReducers` function the library gives us.

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

The implemented middleware basically consists of the function that tries to load data from the API and posts either the successful action or the action indicating a failure.

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

Now we are getting closer to the presentation layer. Here is the container widget that is responsible for converting the latest **App State** to a `_ViewModel` and connecting the `_ViewModel` to the presentation widget.

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

This is the part where things become more interesting. Let’s start with two tiny presentation components that will be utilized in the `HomeScreen`. They are `CustomProgressIndicator` and `GithubIssueListItem`.

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

**Here goes the core presentation logic.**

**Pay more attention to the `HomeScreen`.** There are a few things worth noticing:

1. The screen involves the `ScrollController` to determine when we need to invoke the `loadNextPage` function.
2. Something called `Debouncer` is used (the implementation you’ll see below). It’s just a tiny class with a timer inside it that ensures that consecutive events from the `ScrollController` won’t create tons of requests for a next page, but rather the only request will be made in the specified period of time.
3. `RefreshIndicator` that helps us significantly to get the so-called “pull-to-refresh” feature.
4. `ErrorNotifier` that is responsible for showing a toast notification in case an error occurs. If you need more details on this one, take a look [at my previous article](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f).

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

This is the code for the `ErrorNotifer`.

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

And here is how the `ErrorNotifier` looks like in action.

![](https://cdn-images-1.medium.com/max/2000/1*6cesoZFB8Hj9UaLQgffcKA.gif)

This is the `Debouncer` that was mentioned above.

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

Finally, here is the `main.dart` file that combines all the described components.

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

Don’t hesitate to give this sample a go yourself, grab the sources from the [Github repo](https://github.com/Pavel-Sulimau/flutter_redux_infinite_list).

## Sources:

* [https://medium.com/filledstacks/flutter-redux-quick-start-3f549f5b05c5](https://medium.com/flutter-community/flutter-redux-toast-notification-fcd0971eaf0f)
* [https://github.com/johnpryan/redux.dart](https://github.com/johnpryan/redux.dart)
* [https://github.com/brianegan/flutter_redux](https://github.com/brianegan/flutter_redux)
* [https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart](https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart)
[**Flutter Community (@FlutterComm) | Twitter**
**The latest Tweets from Flutter Community (@FlutterComm). Follow to get notifications of new articles and packages from…**www.twitter.com](https://www.twitter.com/FlutterComm)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
