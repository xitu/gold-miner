> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART7 - TIMING (SINGLELIVEEVENT PROBLEM)](http://hannesdorfmann.com/android/mosby3-mvi-7)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mosby3-mvi-7.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mosby3-mvi-7.md)
> * 译者：
> * 校对者：

# REACTIVE APPS WITH MODEL-VIEW-INTENT - PART7 - TIMING (SINGLELIVEEVENT PROBLEM)

In my [previous](http://hannesdorfmann.com/android/arch-components-purist) blog post we discussed the importance of proper state management and why I think introducing a SingleLiveEvent as [discussed in Google’s Architecture Components GitHub repo](https://github.com/googlesamples/android-architecture-components/issues/63) is not a good idea because it just hides the real underlying problem: state management. In this blog post I would like to discuss how the problem SingleLiveEvent claims to solve can be solved with Model-View-Intent and proper state management.

A common scenario that illustrates this problem is a **Snackbar** that is displayed if an error has occurred. A Snackbar is not meant to be persistent but rather should just display the error message for a few seconds and then disappear. The problem is how do we model this error state and “disappearing”?

Take a look at this video to better understand what I’m talking about:

- YouTube 视频链接：https://youtu.be/8r7UgJg6d2s

This sample app displays a list of countries that are loaded from a **CountriesRepository**. If we click on a country we start a second Activity that just displays the “details” (just the country’s name). When we navigate back to the list of countries, we expect to see the same “state” displayed on the screen as before clicking on a country. So far so good, but what happens if we trigger a pull-to-refresh and an error occurres while loading data which eventually will display a Snackbar displaying the error message on the screen. As you see in the video above, whenever we come back to the list of countries the Snackbar is shown again but that is ususally not the behavior the user expects, right?

The problem is that this screen is in the “show error state”. Google’s Architecture Components Example based on ViewModel and LiveData uses a **SingleLiveEvent** to workaround this issue. The idea is: whenever the View resubscribes (after coming back from “details” screen) to his ViewModel, SingleLiveEvent ensures that “error state” is not emitted again. While this prevents reappearing Snackbar, does it really solves the problem?

## Timing is Everything (for Snackbars)

Again, I still think that such “workarounds” are not the proper way. Can we do it better? I think that proper state management and a unidirectional data flow is a better solution. Model-View-Intent is an architectural pattern that follows these principles. So how do we solve the “Snackbar problem” in MVI? First, let’s Model state:

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

The idea in MVI is that the View layer gets an (immutable) CountriesViewState and just displays that one. So if **pullToRefreshError** is true then display a Snackbar, otherwise don’t.

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

The important bit here is **Snackbar.LENGTH_INDEFINITE** which means Snackbar stays until we dismiss it. So we don’t let android animate the Snackbar in and out. Moreover, we don’t let android mess up with state nor let android introduce a state for UI that is different from the state of business logic. Instead of using **Snackbar.LENGTH_SHORT** which would display Snackbar for two seconds, we rather let the business logic take care of setting **CountriesViewState.pullToRefreshError** to true for two seconds and then set it to false.

How do we do that in RxJava? We can use **Observable.timer()** and **startWith()** operator.

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

    // Show Loading as inital state
    CountriesViewState initialState = CountriesViewState.showLoadingState();

    Observable<CountriesViewState> viewState = Observable.merge(loadingData, pullToRefreshData)
        .scan(initialState, (oldState, repoState) -> repoState.reduce(oldState))

    subscribeViewState(viewState, CountriesView::render);
  }
}
```

**CountriesRepositroy** has a method reload() that returns an **Observable<RepoState>**. RepoState (was named PartialViewState in previous posts in this MVI series) is just a POJO class that indicates if the repository is fetching data, has loaded data successfully or an error has occurred ([source code](https://github.com/sockeqwe/mvi-timing/blob/41095bdecf32c149c1d81b3d773937e7c08d4bdf/app/src/main/java/com/hannesdorfmann/mvisnackbar/RepositoryState.java)). Then we use a [State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3) to compute the View State (scan() operator). This should be familiar if you have read the previous blog posts of my MVI series. The “new” thing is:

```
repositroy.reload().switchMap(repoState -> {
  if (repoState instanceof PullToRefreshError) {
    // Let's show Snackbar for 2 seconds and then dismiss it
    return Observable.timer(2, TimeUnit.SECONDS)
        .map(ignoredTime -> new ShowCountries()) // Show just the list
        .startWith(repoState); // repoState == PullToRefreshError
  } else {
    return Observable.just(repoState);
  }
```

This piece of code does the following: If we run into an error (repoState instanceof PullToRefreshError) then we emit this error state (PullToRefreshError) which then causes the state reducer to set **CountriesViewState.pullToRefreshError = true**. After 2 seconds Observable.timer() emits ShowCountries state that causes the state reducer to set **CountriesViewState.pullToRefreshError = false**.

Et voilà, this is how we show and hide Snackbar in MVI.

- YouTube 视频链接：https://youtu.be/ykDnwZYY9tk

Please note that this is not a workaround like SingleLiveEvent. It’s proper state management and the View is just displaying or “rendering” the given state. So once the user of our app comes back from the details screen to the list of countries he doesn’t see the Snackbar anymore because the state has changed in the meantime to **CountriesViewState.pullToRefreshError = false**. Thus Snackbar doesn’t get displayed.

## User dismisses Snackbar

What if we want to allow the user to dismiss the Snackbar with a swipe gesture. Well, that’s pretty straight forward. Dismissing the snackbar is yet another intent to change the state. To put this into the existing code we just have to ensure that either the timer or the swipe to dismiss intent sets **CountriesViewState.pullToRefreshError = false**. The only thing we have to keep in mind is that if swipe to dismiss intent triggers before the timer we have to cancel the timer. That sounds complex but actually it isn’t thanks to RxJava’s great api and operators:

```
Observable<Long> dismissPullToRefreshErrorIntent = intent(CountriesView::dismissPullToRefreshErrorIntent)

...

repositroy.reload().switchMap(repoState -> {
  if (repoState instanceof PullToRefreshError) {
    // Let's show Snackbar for 2 seconds and then dismiss it
    return Observable.timer(2, TimeUnit.SECONDS)
        .mergeWith(dismissPullToRefreshErrorIntent) // merge timer and dismiss intent
        .take(1) // Only take the one who triggers first (dismiss intent or timer)
        .map(ignoredTime -> new ShowCountries()) // Show just the list
        .startWith(repoState); // repoState == PullToRefreshError
  } else {
    return Observable.just(repoState);
  }
```

- YouTube 视频链接：https://youtu.be/NYEZTXirGuA

With **mergeWith()** we combine the timer and dismiss intent into one observable and then with **take(1)** we take the first one that emits. If swipe to dismiss triggers before the timer then **take(1)** cancels the timer and vice versa: if timer triggers first, don’t react on dismiss intent.

## Conclusion

So let’s try to mess up our UI. Let’s do a pull to refresh, dismiss snackbar and also let the timer do it’s thing:

- YouTube 视频链接：https://youtu.be/UAiT2LSl6ik

As you can see in the video above: no matter how hard we try, the View displays the UI widgets properly because of the unidirectional data flow and state driven by business logic (View layer is stateless, View gets the state from underlying layer and just displays it). For example: we never see pull to refresh indicator and snackbar at the same time (except a small overlap while animating snackbar out).

Of course this Snackbar example is very simplistic but I think it demonstrates the power of such architectural patterns like Model-View-Intent that take state management serious. It’s not too hard to imagine how well this pattern will work out for more complex screens and use cases.

The source code for this demo app can be found [on Github](https://github.com/sockeqwe/mvi-timing).

**This post is part of the blog post series "Reactive Apps with Model-View-Intent". Here is the Table of Content:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
