> * 原文地址：[Effective BLoC pattern](https://medium.com/flutterpub/effective-bloc-pattern-45c36d76d5fe)
> * 原文作者：[Sagar Suri](https://medium.com/@sagarsuri56)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/effective-bloc-pattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/effective-bloc-pattern.md)
> * 译者：[LucaslEliane](https://github.com/LucaslEliane)
> * 校对者：[portandbridge](https://github.com/portandbridge)

# 高效地使用 BLoC 模式

朋友们，我有好长一段时间没有写过 flutter 相关的文章了。在完成了两篇关于 BLoC 模式的文章之后，我花了一些时间，分析了社区对于这种模式的使用情况，在回答了一些关于 BLoC 模式实现的一些问题之后，我发现大家对于 BLoC 模式存在很多疑惑。所以，我构思了一套方法，大家按照这一套方法来做，就可以正确地实现 BLoC 模式了，这会帮助开发人员在实现的时候避免犯下一些常见的错误。所以，我今天向大家介绍一下在使用 BLoC 模式时必须要遵循的 **8 个黄金点**。

![](https://cdn-images-1.medium.com/max/3770/1*XUDik4jakpEcQ6ZVm5jo3A@2x.png)

## 前提

我心目中的读者，应该知道 BLoC 模式是什么，或者使用模式创建了一个应用（至少做过 `CTRL + C` 和 `CTRL + V`）。如果你是第一次听到 **BLoC** 这个词，那么下面三篇文章可以很好地帮助你理解这个模式。

1. 使用 BLoC 模式构建 Flutter 项目[第一部分](https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1)和[第二部分](https://medium.com/flutterpub/architect-your-flutter-project-using-bloc-pattern-part-2-d8dd1eca9ba5)

2. [当 Firebase 遇到了 BLoC 模式](https://medium.com/flutterpub/when-firebase-meets-bloc-pattern-fb5c405597e0)

## 和 BLoC 相遇的故事

我知道，BLoC 模式是一个很难去理解和实现的模式。我看过了很多开发人员的帖子，询问 **哪里是学习 BLoC 模式的最佳资源呢**？读完了不同的帖子和评论之后，我觉得大家在理解这个问题的阻碍有以下几点。

1. 响应式地思考。

2. 努力了解需要创建多少 BLoC 文件。

3. 害怕这个模式会造成代码复杂度的提升。

4. 不知道 stream 在什么时候会被处理掉。

5. 什么是 BLoC 模式的完整形式？（这是一个业务逻辑组件）

6. 更多其他的原因……

但是今天我要列出一些最为重要的点，这些点可以帮助你更加自信及有效地实现 BLoC 模式。现在，就让我们赶快看看有哪些很棒的点。

## 每一个页面都有其自己的 BLoC

这是需要记住的最重要的一个点。每当你创建了一个新的页面，例如登录页，注册页，个人资料页等涉及到数据处理的页面的时候，你必须要为其 **创建一个新的 BLoC**。不要将全局 BLoC 用于处理应用中的所有页面。你可能会认为，如果我们有一个全局的 BLoC，就可以轻松地处理跨页面的数据了。这很不好，因为你的库应当将这些公共数据提供给 BLoC。BLoC 仅仅是获取数据并且将其注入到页面中，来向用户展示。

![左图是正确的使用模式](https://cdn-images-1.medium.com/max/2000/1*0z3wjE8m89iI4ppbeNe2Jg.png)

## 每个 BLoC 必须要有一个 dispose() 方法

这一点比较直接。你创建的每个 BLoC 都应该有一个 `dispose()` 方法。这个方法是你清理或者关闭你创建的所有 stream 的位置。下面是一个 `dispose()` 的简单的例子。

```dart
class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}
```

## 不要在 BLoC 中使用 StatelessWidget

每当你想要创建一个传递数据到 BLoC 或者从 BLoC 中获取数据的页面的时候，**请使用 `StatefulWidget`** 。使用 `StatefulWidget` 相比于使用 `StatelessWidget` 的最大优点在于 `StatefulWidget` 中的生命周期方法。在文章的后面，我们会讨论在使用 BLoC 模式时需要覆盖的两个最重要的方法。`StatelessWidget` 很适合制作页面的小的静态部分，例如显示图像或者是硬编码的文本。如果你想要看看怎么用 `StatelessWidget` 来实现 BLoC 模式，请看上面推荐的文章的 **第一部分**，而在**第二部分**中，我讲述了自己为什么要从 `StatelessWidget` 迁移到 `StatefulWidget`。

## 重写 didChangeDependencies() 来初始化 BLoC

如果你需要在初始化的时候需要一个 `context` 来初始化 BLoC 对象，那么这个方法就是在 `StatefulWidget` 中需要重写的最重要的方法。你可以将其视为初始化方法（最好仅用于 BLoC 的初始化）。你或许会说，我们有 `initState()` 方法，那么为什么我们要使用 `didChangeDependencies()` 方法。文档里面清楚地提到，从 `didChangeDependencies()` 调用 [BuildContext.inheritFromWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) 是安全的。下面是使用这个方法的一个简单的例子：

```dart
@override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.fetchTrailersById(movieId);
    super.didChangeDependencies();
  }
```

## 重写 dispose() 方法来销毁 BLoC

就和有一个初始化方法一样，我们还有一个方法，来处理掉我们在 BLoC 中创建的连接。`dispose()` 方法是调用与该页面相连的对应的 BLoC 的 `dispose()` 方法的最佳位置。每当你离开页面的时候，需要调用这个方法（实际上就是`StatefulWidget`被处理掉的时候）。以下是该方法的一个小例子：

```dart
@override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
```

## 只有需要处理复杂逻辑的时候，才使用 RxDart

如果你之前使用过 BLoC 模式的话，那么你一定听说过 `[RxDart](https://github.com/ReactiveX/rxdart)` 库。这个库是 Google Dart 的响应式函数式编程库，它只是一个包装器，用来包装 Dart 提供的 `Stream` API。我建议你仅在需要处理，类似于链接多个网络请求这样的复杂逻辑时，才使用这个库。对于一些简单的实现，使用 Dart 语言提供的 `Stream` API 就足够了，因为这个 API 已经非常成熟了。下面我添加了一个 BLoC，它使用了 `Stream` API 而不是 `RxDart` 库，这样会让操作变得非常简单，我们不需要额外的库来实现同样的事情：

```dart
import 'dart:async';

class Bloc {

  //Our pizza house
  final order = StreamController<String>();

  //Our order office
  Stream<String> get orderOffice => order.stream.transform(validateOrder);

  //Pizza house menu and quantity
  static final _pizzaList = {
    "Sushi": 2,
    "Neapolitan": 3,
    "California-style": 4,
    "Marinara": 2
  };

  //Different pizza images
  static final _pizzaImages = {
    "Sushi": "http://pngimg.com/uploads/pizza/pizza_PNG44077.png",
    "Neapolitan": "http://pngimg.com/uploads/pizza/pizza_PNG44078.png",
    "California-style": "http://pngimg.com/uploads/pizza/pizza_PNG44081.png",
    "Marinara": "http://pngimg.com/uploads/pizza/pizza_PNG44084.png"
  };


  //Validate if pizza can be baked or not. This is John
  final validateOrder =
      StreamTransformer<String, String>.fromHandlers(handleData: (order, sink) {
    if (_pizzaList[order] != null) {
      //pizza is available
      if (_pizzaList[order] != 0) {
        //pizza can be delivered
        sink.add(_pizzaImages[order]);
        final quantity = _pizzaList[order];
        _pizzaList[order] = quantity-1;
      } else {
        //out of stock
        sink.addError("Out of stock");
      }
    } else {
      //pizza is not in the menu
      sink.addError("Pizza not found");
    }
  });

  //This is Mia
  void orderItem(String pizza) {
    order.sink.add(pizza);
  }
}
```

## 使用 PublishSubject 代替 BehaviorSubject

对于那些在 Flutter 项目中使用 `RxDart` 库的人来说，这一点会更加地明确。`BehaviorSubject` 是一个特殊的 `StreamController`，它会捕获到已经添加到 controller 的最新项，并且将其作为新的 listener 的第一个事件触发。即使你在 `BehaviorSubject` 上调用 `close()` 或者 `drain()`，它仍然会保留最后一项，并且在这个 listener 被订阅的时候触发。如果开发人员不了解这个功能，这有可能会变成一场噩梦。而 `PublishSubject` 不会存储最后一项，更加适合于大多数情况。在这个[项目](https://github.com/SAGARSURI/Goals)中，可以查看 `BehaviorSubject` 的功能。运行应用程序，并且跳转到 'Add Goal' 页面，在表单中输入详细信息，并且跳转回来。现在，再次访问 'Add Goal' 页面，你就会发现表单里已经预先填写了你之前输入的数据。如果你和我一样懒，那么可以看我下面附上的视频：

[Goals App Demo](https://youtu.be/N7-C3o_O1jE)

## 正确地使用 BLoC Providers

在我说这一点之前，请看下面的代码片（第 9 行和第 10 行）。

```dart
import 'package:flutter/material.dart';
import 'ui/login.dart';
import 'blocs/goals_bloc_provider.dart';
import 'blocs/login_bloc_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
      child: GoalsBlocProvider(
        child: MaterialApp(
          theme: ThemeData(
            accentColor: Colors.black,
            primaryColor: Colors.amber,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                "Goals",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.amber,
              elevation: 0.0,
            ),
            body: LoginScreen(),
          ),
        ),
      ),
    );
  }
}

```

你可以清楚地看到，多个 BLoC Provider 是嵌套的。这时候，那么你一定会担心，如果继续在同一个链中添加更多的 BLoC，会导致一场噩梦，你可能会得出 BLoC 模式无法扩展的结论。但是，让我告诉你，当你需要在 Widget 树中访问多个 BLoC 的时候，可能会有一种特殊的情况（BLoC 只保存应用程序所需要的 UI 配置），因此，对于这种情况，上述的嵌套是完全没问题的。但是我建议你在大多数的情况下，还是要避免这种嵌套的，并且只在实际需要的地方提供 BLoC。因此，比如当你需要导航到新的页面的时候，可以像这样使用 BLoC Provider：

```dart
openDetailPage(ItemModel data, int index) {
    final page = MovieDetailBlocProvider(
      child: MovieDetail(
        title: data.results[index].title,
        posterUrl: data.results[index].backdrop_path,
        description: data.results[index].overview,
        releaseDate: data.results[index].release_date,
        voteAverage: data.results[index].vote_average.toString(),
        movieId: data.results[index].id,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }
```

这样，`MovieDetailBlocProvider` 就不会为整个组件树，而是会为 `MovieDetail` 页面提供 BLoC。你可以看到，我将 `MovieDetailScreen` 存储在一个新的 `final variable` 中，来避免每次在 `MovieDetailScreen` 中打开或者关闭键盘的时候，都会重新创建 `MovieDetailScreen` 的问题。

## 还没有结束

虽然这里是本文的结尾了，但并不是这个主题的结尾。我也会在这个有关优化 BLoC 模式的文集中不断添加新的想法，从而继续丰富它的内容。我希望这些想法可以帮助你更好地实现 BLoC 模式。Keep learning and keep coding :)。如果你喜欢这篇文章，可以通过点赞来表达你的爱。

有任何疑问，请在 [LinkedIn](https://www.linkedin.com/in/sagar-suri/) 与我联系，或者在 [Twitter](https://twitter.com/SagarSuri94) 上关注我。我会尽我所能解决你的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
