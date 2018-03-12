> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART5 - DEBUGGING WITH EASE](http://hannesdorfmann.com/android/mosby3-mvi-5)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-5.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-5.md)
> * 译者：
> * 校对者：

# REACTIVE APPS WITH MODEL-VIEW-INTENT - PART5 - DEBUGGING WITH EASE

In the previous blog posts we have discussed the Model-View-Intent (MVI) pattern and it’s characteristics. In [part 1](http://hannesdorfmann.com/android/mosby3-mvi-1) we have talked about the importance of an unidirectional data flow and application state that is driven by the “business logic”. In this blog post we will see how this pays off when it comes to debugging to simplify the life of developers.

Have you ever got a crash report and you were not able to reproduce the bug? Sounds familiar? For me too! After having spend many hours looking at the stacktrace and our source code I gave up and have closed such issues in our issue tracker with a little comment like “can’t reproduce it” or “must be a strange device / manufacturer specific bug”.

Concrete example from our shopping cart app we have developed in this blog post series: On the home screen the user of our app can do a pull-to-refresh and somehow, as the crash reports states, there is a NullPointerException thrown while loading the newest data triggered by pull-to-refresh.

So you as developer start the app and do a pull-to-refresh on the home screen but the app is not crashing. It’s working as expected. So you take a closer look at your code but you can’t see how a NullPointerException could be thrown there. You attach a debugger, go step by step through the code of the involved components, but still: it is working properly. How the hell can this app crash on a pull-to-refresh?

The problem is that you can’t reproduce the state before the crash happened. Wouldn’t it be nice if the user who had the crash could give you his app state (before the crash happened) along with the stacktrace in the crash report? With unidirectional data flow and Model-View-Intent this is super easy. We simply log all intents the user triggers and the model (model reflects the app state, a.k.a. view state) that is rendered on the view. Let’s do that for the home screen by adding logs in the **HomePresenter** (for more details about this class see [part 3](http://hannesdorfmann.com/android/mosby3-mvi-1) where we have discussed the advantages of a state reducer). In the following code snippets we use [Crashlytics](https://fabric.io/kits/ios/crashlytics) but it should be possible to do the same with any other crash reporting tool.

```
class HomePresenter extends MviBasePresenter<HomeView, HomeViewState> {

  private final HomeViewState initialState; // Show loading indicator

  public HomePresenter(HomeViewState initialState){
    this.initialState = initialState;
  }

  @Override protected void bindIntents() {

    Observable<PartialState> loadFirstPage = intent(HomeView::loadFirstPageIntent)
          .doOnNext(intent -> Crashlytics.log("Intent: load first page"))
          .flatmap(...); // business logic calls to load data

    Observable<PartialState> pullToRefresh = intent(HomeView::pullToRefreshIntent)
          .doOnNext(intent -> Crashlytics.log("Intent: pull-to-refresh"))
          .flatmap(...); // business logic calls to load data

    Observable<PartialState> nextPage = intent(HomeView::loadNextPageIntent)
          .doOnNext(intent -> Crashlytics.log("Intent: load next page"))
          .flatmap(...); // business logic calls to load data

    Observable<PartialState> allIntents = Observable.merge(loadFirstPage, pullToRefresh, nextPage);
    Observable<HomeViewState> stateObservable = allIntents
          .scan(initialState, this::viewStateReducer) // call the state reducer
          .doOnNext(newViewState -> Crashlytics.log( "State: "+gson.toJson(newViewState) ));

    subscribeViewState(stateObservable, HomeView::render); // display new state
  }

  private HomeViewState viewStateReducer(HomeViewState previousState, PartialState changes){
    ...
  }
}
```

We simply add logging with RxJava’s **.doOnNext()** operator for every intent and to the “result” of each intent, the view state, which then will be rendered on the view. We serialize the view state as json (we will talk about that in a minute).

Now our crash report looks like this:

![logs](http://hannesdorfmann.com/images/mvi-mosby3/crashlytics-mvi-logs.png)

Take a look at the logs: Not only we see the latest state before the crash happened but we see the full history how the user reached this state. For better readability I have underlined the state transitions and replaced the “data” field (the items that are displayed in the recycler view) with _[…]_ . So the user started the app - load first page intent. Then the loading indicator is displayed _“loadingFirstPage”:true_ and then the data has been loaded (_data[…]_). Next the user scrolled through the list of items and reached the end of the RecyclerView which triggers a load next page intent to load more data (pagination), which causes a state transition to _“loadingNextPage”:true_. Once the next page is loaded the data (_data[…]_) has been updated and _“loadingNextPage”:false_ has been set properly. The user did the same (scroll down the RecyclerView and trigger a load next page intent) for a second time. And then he started a pull-to-refresh intent and the state transitions to _“loadingPullToRefresh”:true_. Suddenly the app crashes (no more logs afterwards).

So how does that information helps us to fix that bug? Obviously, we know which intents the user triggered, so we can do that manually to reproduce the bug. Moreover, we have snapshots of our app’s state (over time) as json. We can simply take the last state, deserialize the json and take this state as our initial state to fix that bug:

```
String json ="  {\"data\":[...],\"loadingFirstPage\":false,\"loadingNextPage\":false,\"loadingPullToRefresh\":false} ";
HomeViewState stateBeforeCrash = gson.fromJson(json, HomeViewState.class);
HomePresenter homePresenter = new HomePresenter(stateBeforeCrash);
```

Then we attach a debugger and trigger the pull-to-refresh intent. It turns out that if the user has scrolled down the page 2 times no more data is available and our app didn’t handled that fact properly, so that a following pull-to-refresh causes the crash.

## Conclusion

Making app’s state “snapshotable” makes the life of us developers much easier. Not only that we are able to reproduce crashes easily, furthermore, we can take the serialized state to write [regression tests](https://en.wikipedia.org/wiki/Regression_testing) with almost zero extra costs. Keep in mind that this is only possible if the app’s state follows the principle of an unidirectional data flow (driven by the business logic), immutability and pure functions. Model-View-Intent pushes us into that direction so that building “snapshotable” apps is a nice and useful side effect of this architecture.

What are the downsides of “snapshotable” apps? Obviously we are serializing the apps state (i.e. with Gson). This adds some extra computation time. In an average sized app of mine this takes about 30 milliseconds for the first time the state gets serialized with Gson because Gson has to scan the classes by using reflections to determine the fields that have to be serialized. Consecutive state serialization takes about 6 milliseconds on average on a Nexus 4. Since serialization runs in **.doOnNext()** this typically runs on a background thread, but yes, a user of my app has to wait 6 milliseconds more than without snapshotting to see the new state on the screen. From my point of view that is not noticeable by an apps user. However, an issue with snapshotting the state is that on a crash the amount of data uploaded from the users device by the crash reporting tool to his server is significant bigger. No big deal if the user is connected over wifi, but could be an issue for the users mobile data plan. Last but not least, you may leak sensitive user data when attaching the state to a crash report. Either don’t serialize sensitive data which may cause that the state attached to the crash report is not complete (and therefore almost useless) or encrypt sensitive data (which may requires some extra cpu time).

To sum it up: I personally see a lot of advantages in snapshotting my app, however, you may have to make some tradeoffs. Maybe you start to enable snapshotting your app for your internal builds or beta builds to see how it works out for your app.

#### Bonus: Time Traveling

Wouldn’t it be nice to have some kind of “time traveling” option during development. Maybe embedded in a debug-drawer like the one of Jake Wharton’s u2020 demo app:

![debug-drawer](http://hannesdorfmann.com/images/mvi-mosby3/u2020-debug-drawer.gif)

All we need in such a debug-drawer are two buttons “previous state” and “next state” so that we can step by step travel back in time from one state to previous (or next) state. Obviously that requires some additional setup then just snapshotting our app’s state. For example: if we have made a HTTP request as part of a state transition we certainly don’t want to make the real HTTP request again while time traveling because data on backend side might have changed in the mean time.

Time traveling requires some kind of extra layer like a proxy at the boundary of an app so that we can “record” and “replay” things like http requests (same for sqlite database etc.). Interested in something like that? It seems that my friend Felipe is working on something like that for OkHttp. Feel free to ping him to get more details about the library he is currently working on.

![Snipaste_2018-03-07_11-40-30.png](https://i.loli.net/2018/03/07/5a9f5f80ca8f0.png)

> Would you find useful an Android library that can record and replay OkHttp network interaction for, say Espresso tests?
> 
> — Felipe Lima (@felipecsl) [28\. Februar 2017](https://twitter.com/felipecsl/status/836380525380026368)

**This post is part of the blog post series "Reactive Apps with Model-View-Intent".
Here is the Table of Content:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
