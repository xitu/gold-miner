> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART7 - TIMING (SINGLELIVEEVENT PROBLEM)](http://hannesdorfmann.com/android/mosby3-mvi-7)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mosby3-mvi-7.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mosby3-mvi-7.md)
> * 译者：[pcdack](https://github.com/pcdack)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)，[allenlongbaobao](https://github.com/allenlongbaobao)

# 使用MVI构建响应式 APP — 第七部分 — TIMING (SINGLELIVEEVENT 问题)

在我[前面](http://hannesdorfmann.com/android/arch-components-purist)系列博客中， 我们讨论了正确的状态管理的重要性，并且也阐述了为什么我认为一个像在[谷歌架构组件的 github 中讨论](https://github.com/googlesamples/android-architecture-components/issues/63)的 SingleLiveEvent 不是一个好的主意。因为，它仅仅隐藏了真正底部的问题：状态管理。在这篇博客中，我想去讨论，SingleLiveEvent 声称能解决的问题，使用 Model-View-Intent 和正确的状态管理是如何解决的。

这个问题可以用一个常见的场景来举例说明：当一个错误发生的时候弹出一个snackbar。SnackBar 不会一直保持在一个位置，一两秒后它就会消失。这个问题是我们如何用 model 来控制错误状态和让其消失？

让我们看下下面的的视频，这样可以让你们更好的理解，我在说什么：

![](https://i.loli.net/2018/03/28/5abba0ba01a21.gif)

这个简单的 app 显示了一个国家的列表，这些国家的数据是通过 **CountriesRepository** 加载的。如果，我们点击一个国家，我们打开了第二个 Activity ，这个 Activity 会显示一些「细节」（国家的名字）。当我们返回到国家列表，我们期待看到与点击前相同「状态」显示到屏幕上。到目前为止一切都很正常，但是如果，我触发下拉刷新时，在数据加载的时候出现了错误，这个错误会让 Snackbar 显示在屏幕上，用来提示错误信息，会发生什么？ 正如你在上面视频中看到的那样，无论何时我们回到国家列表，这个 SnackBar 都会再次显示。但是，这肯定不是用户所期待的，对吧？

这个问题发生在这个屏幕处在「显示错误」的状态。谷歌的架构组件的例子是基于 ViewModel 和 LiveData 用一个 **SingleLiveEvent** 去解决这个问题。使用的方法是：无论何时 view 被它的 ViewModel 重新订阅（在从「细节」页面返回之后），SingleLiveEvent 确保「错误状态」不会被重新触发。这防止了 Snackbar 的复现，它真正解决问题了么？

## 时机就是一切（对于 Snackbar 来说）

再次强调一下，我仍然认为这种解决方法是不正确的方法。我们可以做的更好么？我认为正确状态管理和单向的数据流是更好的解决方法。Model-View-Intent 是一个架构组件并且遵循一定的原则。因此，我们在 MVI 中，如何解决上面的「Snackbar 问题」，首先，让我们定义 state：

```
public class CountriesViewState {

  // True if progressbar should be displayed
  boolean loading;

  // List of countries (country names)  if loaded
  List<String> countries;

  // true if pull to refresh indicator should be displayed
  boolean pullToRefresh;

  // true if an error has occurred while pull to refresh -> Show Snackbar.
  boolean pullToRefreshError;
}
```

在 MVI 中的解决思路是 View 层得到一个（不变的）CountriesViewState，然后，仅仅显示这个状态。因此，如果，**pullToRefreshError** 是 true，那么显示 Snackbar，其他情况不显示。

```
public class CountriesActivity extends MviActivity<CountriesView, CountriesPresenter>
    implements CountriesView {

  private Snackbar snackbar;
  private ArrayAdapter<String> adapter;

  @BindView(R.id.refreshLayout) SwipeRefreshLayout refreshLayout;
  @BindView(R.id.listView) ListView listView;
  @BindView(R.id.progressBar) ProgressBar progressBar;

   ...

  @Override public void render(CountriesViewState viewState) {
    if (viewState.isLoading()) {
      progressBar.setVisibility(View.VISIBLE);
      refreshLayout.setVisibility(View.GONE);
    } else {
      // show countries
      progressBar.setVisibility(View.GONE);
      refreshLayout.setVisibility(View.VISIBLE);
      adapter.setCountries(viewState.getCountries());
      refreshLayout.setRefreshing(viewState.isPullToRefresh());

      if (viewState.isPullToRefreshError()) {
        showSnackbar();
      } else {
        dismissSnackbar();
      }
    }
  }

  private void dismissSnackbar() {
    if (snackbar != null)
      snackbar.dismiss();
  }

  private void showSnackbar() {
    snackbar = Snackbar.make(refreshLayout, "An Error has occurred", Snackbar.LENGTH_INDEFINITE);
    snackbar.show();
  }
}
```

这里的重点是 **Snackbar.Length_INDEFINITE** 这就意味着 Snackbar 会一直存在，直到我们 dismiss 它。因此，我们不让 android 系统来控制 SnackBar 的显示和隐藏。此外，我们不能让 android 系统扰乱状态，也不让它引入一个不同于业务逻辑的 UI 状态。取而代之，用 **Snackbar.LENGTH_SHORT** 来使 Snackbar 显示两秒，我们宁愿让业务逻辑使 **CountriesViewState.pullToRefreshError** 设置为 true 两秒钟，然后，将再它置为 false。

我们如何使用 RxJava 来做到这一点咧？我们可以用 **Observable.timer()** 和 **startWith()** 操作符。

```
public class CountriesPresenter extends MviBasePresenter<CountriesView, CountriesViewState> {

  private final CountriesRepositroy repositroy = new CountriesRepositroy();

  @Override protected void bindIntents() {

    Observable<RepositoryState> loadingData =
        intent(CountriesView::loadCountriesIntent).switchMap(ignored -> repositroy.loadCountries());

    Observable<RepositoryState> pullToRefreshData =
        intent(CountriesView::pullToRefreshIntent).switchMap(
            ignored -> repositroy.reload().switchMap(repoState -> {
              if (repoState instanceof PullToRefreshError) {
                // Let's show Snackbar for 2 seconds and then dismiss it
                return Observable.timer(2, TimeUnit.SECONDS)
                    .map(ignoredTime -> new ShowCountries()) // Show just the list
                    .startWith(repoState); // repoState == PullToRefreshError
              } else {
                return Observable.just(repoState);
              }
            }));

    // 初始状态显示 Loading
    CountriesViewState initialState = CountriesViewState.showLoadingState();

    Observable<CountriesViewState> viewState = Observable.merge(loadingData, pullToRefreshData)
        .scan(initialState, (oldState, repoState) -> repoState.reduce(oldState))

    subscribeViewState(viewState, CountriesView::render);
  }
}
```
**CountriesRepositroy** 有一个 reload() 方法，这个方法返回一个 **Observable<
RepoState>**。RepoState(在这个系列的前面几篇文章中叫做 PattialViewState) 仅仅是个 POJO 类，用来表示 repository 是否取到数据，是成功的取到数据，或者产生了错误（[源码](https://github.com/sockeqwe/mvi-timing/blob/41095bdecf32c149c1d81b3d773937e7c08d4bdf/app/src/main/java/com/hannesdorfmann/mvisnackbar/RepositoryState.java)）。然后，我们使用状态折叠器去完成我们 View 的状态（scan() 操作符)。如果你读过 MVI 前面的文章，那么你应当很熟悉状态折叠器。新的东西是：

```
repositroy.reload().switchMap(repoState -> {
  if (repoState instanceof PullToRefreshError) {
    //让 Snackbar 显示两秒然后让其消失
    return Observable.timer(2, TimeUnit.SECONDS)
        .map(ignoredTime -> new ShowCountries()) // Show just the list
        .startWith(repoState); // repoState == PullToRefreshError
  } else {
    return Observable.just(repoState);
  }
```

这一小段代码做了下面这些事：如果我们的程序跑错了（repoState instanceof PullToRefreshError），然后，我们触发了这个错误的状态（PullToRefreshError），这将造成[状态折叠器](http://hannesdorfmann.com/android/mosby3-mvi-3)去设置 **CountriesViewState.pullToRefreshError =true**。两秒过后 Observable.timer() 触发了 ShowCountries 状态，这将造成状态折叠器设置**CountriesViewState.pullToRefreshError = false**。

 bingo～这就是我们在 MVI 中如何显示和隐藏 Snackbar。

![](https://i.loli.net/2018/03/28/5abb9d4f58ae8.gif)

请注意，这和 SingleLiveEvent 解决方法不一样。这是一种正确的状态管理，并且 view 仅仅显示或「渲染」给定的状态。因此，一旦我们的 APP 从详情页返回到国家列表。他再也不会看到 Snackbar 了，因为，状态已经同时发生了改变，变成了**CountriesViewState.pullToRefreshError = false** 因此，Snackbar 不会再次显示。

## 用户撤销 Snackbar

如果，我们想要允许用户通过轻扫手势撤销 Snackbar。这非常简单。撤销 Snackbar 也是一种改变状态的意图。要想在原有的代码中添加这种功能，我们仅仅需要确保，无论计时器或者轻扫滑动去撤销**CountriesViewState.pullToRefreshError = false** 的意图设置。你仅仅需要记住的唯一一件事情是，在你轻轻滑动之前，你的计时器已经被取消掉了。这听起来很复杂，但是，实现起来很简单，这要感谢 RxJava 伟大的操作符和 API：

```
Observable<Long> dismissPullToRefreshErrorIntent = intent(CountriesView::dismissPullToRefreshErrorIntent)

...

repositroy.reload().switchMap(repoState -> {
  if (repoState instanceof PullToRefreshError) {
    //让 Snackbar 显示两秒然后让其消失
    return Observable.timer(2, TimeUnit.SECONDS)
        .mergeWith(dismissPullToRefreshErrorIntent) // 合并定时器并解除意图
        .take(1) // 仅仅取先触发的那个（解除意图或计时器）
        .map(ignoredTime -> new ShowCountries()) // Show just the list
        .startWith(repoState); // repoState == PullToRefreshError
  } else {
    return Observable.just(repoState);
  }
```

![](https://i.loli.net/2018/03/28/5abba02fc8f79.gif)

通过使用 **mergeWith()** 操作符，我们可以将 timer 和撤销意图联合起来到一个可观察对象，然后，第一个发射 **take(1)** 。如果轻扫撤销触发在 timer 之前，那么，take(1) 取消 timer，反之亦然：如果 timer 先触发，则不要触发退出意图。.

## 总结

因此，让我们尝试能不能把 UI 搞乱吧。让我们做下拉刷新的动作，退出 Snackbar 并且，让 timer 计时：

![](https://i.loli.net/2018/03/28/5abba1372958b.gif)

正如你在视频上所看到的，无论我多努力的尝试，view 都能够在 UI 上正确显示，因为，单项数据流和业务逻辑驱使状态（view 层是无状态的，view 是从底层得到状态的，并且，仅仅起到显示作用）。例如：我们从来我们从来没有见过加载指示器和 Snackbar 同时显示（除去 Snackbar 退出过程中，一个小的叠加情况）。

当然，Snackbar 例子十分简单，但是，我认为它向我们展示了能够严格进行状态管理像 Model-View-Intent 这类模式的力量。不难想象，这种模式用在复杂的页面和用户需求上也会很棒。

dome app 的源代码已经在 [Github](https://github.com/sockeqwe/mvi-timing) 上了。

**这篇博客是 "用 MVI 开发响应式App"中的一篇博客。下面是内容表:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)

**这是中文翻译:**

* [第一部分：Model](https://juejin.im/post/5a52e4445188257334228b28)
* [第二部分：View 和 Intent](https://juejin.im/post/5a587c06518825732f7eab86)
* [第三部分：状态折叠器](https://juejin.im/post/5a955c50f265da4e853d856a)
* [第四部分：独立 UI 组件开发](https://juejin.im/post/5a9debfbf265da23830a6230)
* [第五部分：简单的调试](https://juejin.im/post/5aafa3e85188255562)
* [第六部分：状态恢复](https://juejin.im/post/5ab4c028518825557e7853a1)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
