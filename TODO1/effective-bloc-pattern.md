> * 原文地址：[Effective BLoC pattern](https://medium.com/flutterpub/effective-bloc-pattern-45c36d76d5fe)
> * 原文作者：[Sagar Suri](https://medium.com/@sagarsuri56)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/effective-bloc-pattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/effective-bloc-pattern.md)
> * 译者：
> * 校对者：

# Effective BLoC pattern

Hey Folks, Its been so long I have written anything about Flutter. After writing two articles on BLoC pattern I was spending time doing analysis on the usage of this pattern by the community and after answering some questions on the implementation of BLoC pattern I saw that there was a lot of confusion among people. So I came up with a list of **“Rules of thumb”** that can be followed to properly implement the BLoC pattern which will help a developer to avoid making common mistakes while implementing it. So today I present to you a list of **8 golden points** that must be followed when working with BLoC.

![](https://cdn-images-1.medium.com/max/3770/1*XUDik4jakpEcQ6ZVm5jo3A@2x.png)

## Prerequisites

The audience I expect should know what BLoC pattern is or have created an app using the pattern(at least did `CTRL + C` and `CTRL + V`). If this is the first time you heard the word “**BLoC”** then the below three articles would be the perfect place to start understanding this pattern:

1. Architect your Flutter project using BLoC pattern [**PART 1**](https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1) and [**PART 2**](https://medium.com/flutterpub/architect-your-flutter-project-using-bloc-pattern-part-2-d8dd1eca9ba5)

2. [**When Firebase meets BLoC pattern**](https://medium.com/flutterpub/when-firebase-meets-bloc-pattern-fb5c405597e0)

## Story of those who encountered BLoC

I know I know it is a tough pattern to understand and implement. I have seen many posts from developers asking “**Which is the best resource to learn BLoC pattern?**” After going through all the different posts and comments I feel the following points are the common hurdles every single person went through when understanding this pattern.

1. Thinking reactively.

2. Struggling to understand how many BLoC files need to be created.

3. Scared whether this will scale or not.

4. Don’t know when the streams will get disposed.

5. What is the full form of BLoC? (It’s Business Logic Component 😅)

6. Many more….

But today I will list down some of the most important points that will help you implement BLoC pattern confidently and efficiently. Without any further delay let’s look at those amazing points.

## Every screen has its own BLoC

This is the most important point to remember. Whenever you create a new screen e.g Login screen, Registration screen, Profile screen etc which involves dealing with data, you have to **create a new BLoC** for it. Don’t use a global BLoC for all the screens in your app. You must be thinking that if I have a common BLoC I can easily use the data between the two screens. That’s not good because your repository should be responsible for providing those common data to the BLoC. BLoC will just take that data and provide to your screen in a manner which can be displayed to the user.

![The left diagram is the correct pattern](https://cdn-images-1.medium.com/max/2000/1*0z3wjE8m89iI4ppbeNe2Jg.png)

## Every BLoC must have a dispose() method

This is pretty straight forward. Every BLoC you create should have a `dispose()` method. This is the place where you do the cleanup or close all the streams you have created. A simple example of the `dispose()` method is shown below.

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

## Don’t use StatelessWidget with BLoC

Whenever you want to create a screen which will pass data to a BLoC or get data from a BLoC **always use `StatefulWidget`** . The biggest advantage of using `StatefulWidget` over `StatelessWidget` are the lifecycle methods available in the `StatefulWidget`. Later down the article, we will talk about the two most important methods to override when working with BLoC pattern. `StatelessWidgets` are good to make a small static part of your screen e.g showing an image or hardcoded text. If you want to see the implementation of BLoC pattern in a `StatelessWidget` check out **PART1** and in **PART2** I showed why I converted from `StatelessWidget` to a `StatefulWidget`.

## Override didChangeDependencies() to initialise BLoC

This is the most crucial method to override in a `StatefulWidget` if you need a `context` at the beginning to initialise a BLoC object. You can think of it as the initializing method(preferred for BLoC initialisation only). You may argue that we even have a `initState()` so why use `didChangeDependencies()` . As per the doc it’s clearly mentioned that it is safe to call [BuildContext.inheritFromWidgetOfExactType](https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html) from `didChangeDependencies()` method. A simple example of how to use this method is shown below:

```dart
@override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.fetchTrailersById(movieId);
    super.didChangeDependencies();
  }
```

## Override dispose() method to dispose BLoC

Just like there is an initializing method, we have been provided with a method where we can dispose of the connections we created in the BLoC. The `dispose()` method is the perfect place to call the BLoC `dispose()` method associated with that particular screen. This method is always called when you leaving the screen(technically when the `StatefulWidget` is getting disposed). Below is a small example of that method:

```dart
@override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
```

## Use RxDart only when dealing with complex logic

If you have worked with BLoC pattern earlier then you must have heard about `[RxDart](https://github.com/ReactiveX/rxdart)` library. It is a reactive functional programming library for Google Dart. This library is just a wrapper over the `Stream` API provided by Dart. I would advise you to use this library only when you are dealing with complex logic like chaining multiple network requests. But for simple implementations use the `Stream` API provided by the Dart language as it is quite mature. Below I have added a BLoC which uses `Stream` API rather than the `RxDart` library because the operations are quite simple and I didn’t need an additional library to do the same:

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

## Use PublishSubject over BehaviorSubject

This point is more specific for those using the `RxDart` library in their Flutter project. `BehaviorSubject` is a special `StreamController` that captures the latest item that has been added to the controller, and emits that as the first item to any new listener. Even if you call `close()` or `drain()` on the `BehaviorSubject` it will still hold the last item and emit when subscribed. This can be a nightmare for a developer if he/she is not aware of this feature. Whereas `PublishSubject` doesn’t store the last item and is best suited for most of the cases. Check out this [project](https://github.com/SAGARSURI/Goals) to see the `BehaviorSubject` feature in action. Run the app and go to the “Add Goal” screen, enter the details in the form and navigate back. Now again if you visit the “Add Goal” screen you will find the form pre-filled with the data you entered previously. If you are a lazy person like me then look at the video I have attached below:

[Goals App Demo](https://youtu.be/N7-C3o_O1jE)

## Proper use of BLoC Providers

Before I say anything about this point do check the below code snippet(line 9 and 10).

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

You can clearly see that multiple BLoC providers are nested. Now you must be worried that if you keep adding more BLoCs in that same chain then it will be a nightmare and you will conclude that BLoC pattern cannot scale. But let me tell you that there can be a special case(a BLoC only holding the UI configurations which is required across the app) when you need to access multiple BLoCs anywhere down the Widget tree so for such cases the above nesting is completely fine. But I would recommend you to avoid such nesting most of the time and provide the BLoC from where it is actually needed. So for example when you are navigating to a new screen you can use the BLoC provider like this:

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

This way the `MovieDetailBlocProvider` will provide the BLoC to the `MovieDetail` screen and not to the whole widget tree. You can see that I stored the `MovieDetailScreen` in a new `final variable` to avoid recreation of the `MovieDetailScreen` every time when the keyboard is opened or closed in the `MovieDetailScreen`.

## This is not the end

So here we come to the end of this article. But this is not the end of this topic. I will keep adding new points to this every growing list of optimizing the BLoC pattern as I learn better ways of scaling and implementing the pattern. I hope these points will surely help you implement BLoC pattern in a better way. Keep learning and keep coding. :) If you liked the article then show your love by hitting **50 claps 😄 👏 👏**.

Having any doubt, connect with me at [**LinkedIn**](https://www.linkedin.com/in/sagar-suri/) or follow me at [**Twitter**](https://twitter.com/SagarSuri94). I will try my best to solve all your queries.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
