> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART5 - DEBUGGING WITH EASE](http://hannesdorfmann.com/android/mosby3-mvi-5)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-5.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-5.md)
> * 译者：
> * 校对者：

# 使用MVI编写响应式APP - 第5部分 - 简单的调试

在前面的系列博客中我们已经讨论了 Model-View-Intent(MVI) 模式和它的特征。在[第一部分](http://hannesdorfmann.com/android/mosby3-mvi-1)我们已经讨论了关于单向数据流的重要性和应用状态被业务逻辑驱动。在这篇博客中我们将看到如何通过 debug 来简化开发者的开发工作。

你以前有没有收到一个崩溃报告,并且你不能复现报告中的 bug？ 听起来很熟悉？我也觉得很熟悉！ 在花费数小时看 stacktrace 和我们的源代码,我选择放弃和关掉这个 issue 在我们 issue 跟踪中，而且跟随着一个小的 comment 像“不能复现这个 bug”或者“这一定是一个奇怪设备/厂商（大厂）导致的错误”。

用我们商城的具体的例子,我们已经在这个博客前面系列里开发了:当在 home 页面，我们的用户可以做下拉刷新，并且，不知道为什么，根据 crash 清单状态，当下拉刷新加载新的数据的时候，这里会触发 NullPointerException 异常。

你做为开发这开始在 home 页面进行上拉刷新操作，但是，这个 App 并没有崩溃。它像预期的那样工作。因此，你关闭了代码。但是，你不能看到 NullPointException 在这里如何被抛出的。你接着去调试，单步调试相关组件的代码,但是仍然：它正常的工作。这个应用程序如何能够在下拉刷新时崩溃？

这个问题是你不能够重现当崩溃发生的时候的场景。如果有崩溃问题的用户能够给你它 app （发生崩溃前）的状态随着 staktrace 一起呈现在崩溃日志中，岂不美哉？伴随着单项数据流和 Model-View-Intent 模式那么这种情况将变得十分简单。我们简单 log 所有用户触发的意图和 model（model 代表了 app 的状态，换句话说，view的状态），被渲染到view上。让我们在我们 home 页面做前面所说的内容，通过添加 logs 在我们的 **HomePresenter** (对于更多的细节可以看[第三部分](http://hannesdorfmann.com/android/mosby3-mvi-1) 在第三部分中我们已经讨论过状态折叠器的优点)。在下面的代码中我将贴出我们使用 [Crashlytics](https://fabric.io/kits/ios/crashlytics)(类似于 Bugly) 的代码片段,但是它应当与其他的 crash 报告工具的使用是相同的。

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

我们简单应用RxJava的**\.doOnNext()**操作符，添加 log 到所有的意图和每个意图的“结果”，这个将要被渲染到 view 的 view 状态，我们序列化 view 状态为json对象（我们稍后来讨论这个）。

我们可以看一下这些logs:

![logs](http://hannesdorfmann.com/images/mvi-mosby3/crashlytics-mvi-logs.png)

不仅仅我们可以看到崩溃发生前的最后状态，而且我们可以看到用户到达这个状态的整个流程。为了更好的可读性，我已经强调了状态过滤，并且用_[…]_替换掉“数据”(这些项将被显示到 recycler view 上)。 因此，用户开启这个 app -加载第一页的意图。然后加载指示条显示"loadFirstPage"。然后，真的数据就被加载进来了(_data[…]_)。 接下来用户滑动列表项并且到达了 recyclerView 的1底部，这将触发加载下一页的意图去加载更多数据(分页),这将造成状态转换成"loadingNextPage":对。一旦下一页被加载的数据(_data[…]_)已经被更新并且"loadNextPage":错误已经被矫正。用户做同样的事情第二次。并且它开始采用下拉刷新意图并且状态，状态转变为“loadingPullRefresh”：正确。突然 App 崩溃了（没有更多之后的 log 信息）。

因此如何做到使这些信息信息帮助我们修复这个 bug？显然，我们知道那个意图用户触发了，因此我们可以人工去复现 bug。此外，我们可以将我们的 app 的状态快照成 json。我们可以简单的将最后一个状态反序列化 json，并且成为我们初始状态去修复这个 Bug:

```
String json ="  {\"data\":[...],\"loadingFirstPage\":false,\"loadingNextPage\":false,\"loadingPullToRefresh\":false} ";
HomeViewState stateBeforeCrash = gson.fromJson(json, HomeViewState.class);
HomePresenter homePresenter = new HomePresenter(stateBeforeCrash);
```

然后，我们连带 debugger 和触发下拉刷新意图的。它将出现在如果用户已经向下滑第二次滑到第二页没有更多的数据存在，并且，我们的 app 没有正确的处理，因此下拉刷新造成了崩溃。

## 总结

制作 app 的状态"快照"让我们的开发生涯更加简单。不仅我们可以简单的复现崩溃场景，另外，我们可以序列化状态去写[回归测试](https://en.wikipedia.org/wiki/Regression_testing)，不用额外消耗任意代码。记住这仅仅适用于如果 app 的状态遵循单项数据流（被业务逻辑驱动），不变性和纯函数的原则。Model-View-Intent 带领我们去正确的方向，因此我们构建“可快照”的 app 是非常好和十分有用，这就是这种架构的“副作用”。

"可快照的" app 有什么缺点？显然我们序列化 app 的状态（例如：使用 Gson）。这将添加额外的计算时间。在我的一般大小的 app 中这个过程，即使用 Gson 第一次状态得到序列化，将消耗 30 毫秒。因为 Gson 需要使用反射来扫描类去决定需要序列化的区域。连续状态序列化在 Nexus 4 中平均需要花费 6 毫秒。当序列化运行在**.doOnNext()** 这是一般运行在其他线程，但是，我 app 的用户不得不等 6 毫秒比那些没有快照的 app。我的观点是等 6 毫秒用户是很难察觉到。无论如何，关于快照状态的一个讨论是当崩溃发生大量的数据从用户的设备通过崩溃日志工具上传到服务器是十分巨大的。如果用户连接着 wifi 没什么大不了的，但是可以谈论用户的移动端数据计划。最后但是同样重要的，你也许泄露了伴随着状态的敏感数据的崩溃日志。不序列化可能附在状态的敏感数据到崩溃日志，是不可能完全达到的（并且因此是无用的）或者加密敏感数据（这将消耗额外的 CPU 时间）。

总结一下：我个人看到了一些快照我 app 的有点，然而，你也不得不做一些权衡.也许你需要开始启用快照在你的 app 到你的内部版本或者设施版本看看在你的 app 上工作的如何。

#### 红利:时间旅行

当你的 app 拥有“时间旅行”设置，在开发阶段，这难道不是一件很好的事情。也许嵌入一个调试侧边栏像 Jake Wharton 的 u2020 dome app:

![debug-drawer](http://hannesdorfmann.com/images/mvi-mosby3/u2020-debug-drawer.gif)

所有我们需要类似于调试侧边栏只需要两个按钮“前一个状态”和“后一个状态”因此我们可以一步一的从一个状态及时的到前一个状态（或下一个状态）。例如：如果我们已经做了一个 HTTP 请求作为状态变化的一部分，我们可以确定不想去再次进行真正的 HTTP 请求当使用在“时间旅行”的时候(译:这里的意思是我们不需要再次去进行 HTTP 请求，我们是录制状态。)，因为意味着数据发生了改变。

时间旅行要求一些额外的层，像一个代理层在一个 app 的边界部分因此我们可以“录制”和“回放”状态像 http 请求（同理 sqlite等等）。对这类事情十分的感兴趣？这就像我的朋友 Felipe 为OKHttp做类似的事情。可以随意联系他来得到他正在写的库的更多细节。

![Snipaste_2018-03-07_11-40-30.png](https://i.loli.net/2018/03/07/5a9f5f80ca8f0.png)

> 你是否正在找一个十分有用的安卓库，可以录制和回放 OkHttp 网络交互，比如说 Espresso 测试？
> 
> — Felipe Lima (@felipecsl) [28\. Februar 2017](https://twitter.com/felipecsl/status/836380525380026368)

**这是使用 MVI 开发响应式 APP 的一部分。
这里是内容表:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)

**这是中文翻译:**
* [第一部分：Model](https://juejin.im/post/5a52e4445188257334228b28)
* [第二部分:View 和 Intent](https://juejin.im/post/5a587c06518825732f7eab86)
* [第三部分:状态折叠器](https://juejin.im/post/5a955c50f265da4e853d856a)
* [第四部分:独立 UI 组件开发](https://juejin.im/post/5a9debfbf265da23830a6230)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
