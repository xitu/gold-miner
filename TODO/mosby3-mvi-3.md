> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART3 - STATE REDUCER](http://hannesdorfmann.com/android/mosby3-mvi-3)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-3.md)
> * 译者：
> * 校对者：

# REACTIVE APPS WITH MODEL-VIEW-INTENT - PART3 - STATE REDUCER

In the [previous part](http://hannesdorfmann.com/android/mosby3-mvi-2) we have discussed how to implement a simple screen with the **M**odel-**V**iew-**I**ntent pattern with an unidirectional data flow. In this blog post we are going to build a more complex screen with MVI with the help of a state reducer.

If you haven’t read [part 2](http://hannesdorfmann.com/android/mosby3-mvi-2) yet, you should read that before continue with this blog post, because there is described how we connect the View via Presenter with the business logic and how data flows unidirectional.

Now let’s build a more complex screen like this:

<iframe width="894" height="503" src="https://www.youtube.com/embed/WWeRn0tMoXM" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

As you see in the video above this screen displays a list of items (products) grouped by category. The app only displays 3 items for each category and the user can click on a “load more button” to load all items of that category (http request). Additionally, the user can do pull-to-refresh and once the user has scrolled down to the end of the list more categories are loaded (pagination). Of course all this actions can be executed simultaneously and each of them could also fail (i.e. no internet connection).

Let’s implement this step by step. First, let’s define the View interface.

```
public interface HomeView {

  /**
   * The intent to load the first page
   *
   * @return The value of the emitted item (boolean) can be ignored. true or false has no different meaning.
   */
  public Observable<Boolean> loadFirstPageIntent();

  /**
   * The intent to load the next page (pagination)
   *
   * @return The value of the emitted item (boolean) can be ignored. true or false has no different meaning.
   */
  public Observable<Boolean> loadNextPageIntent();

  /**
   * The intent to react on pull-to-refresh
   *
   * @return The value of the emitted item (boolean) can be ignored. true or false has no different meaning.
   */
  public Observable<Boolean> pullToRefreshIntent();

  /**
   * The intent to load more items from a given category
   *
   * @return Observable with the name of the category
   */
  public Observable<String> loadAllProductsFromCategoryIntent();

  /**
   * Renders the viewState
   */
  public void render(HomeViewState viewState);
}
```

The concrete View implementation is pretty straight forward and therefore I won’t show the code here (can be found [on github](https://github.com/sockeqwe/mosby/blob/master/sample-mvi/src/main/java/com/hannesdorfmann/mosby3/sample/mvi/view/home/HomeFragment.java)). Next let’s focus on the Model. As already said in previous posts the Model should reflect the State. So let’s introduce a Model called **HomeViewState**:

```
public final class HomeViewState {

  private final boolean loadingFirstPage; // Show the loading indicator instead of recyclerView
  private final Throwable firstPageError; // Show an error view if != null
  private final List<FeedItem> data;   // The items displayed in the recyclerview
  private final boolean loadingNextPage; // Shows the loading indicator for pagination
  private final Throwable nextPageError; // if != null, shows error toast that pagination failed
  private final boolean loadingPullToRefresh; // Shows the pull-to-refresh indicator
  private final Throwable pullToRefreshError; // if != null, shows error toast that pull-to-refresh failed

   // ... constructor ...
   // ... getters  ...
}
```

Note that **FeedItem** is just a interface every item has to implement that is displayable by the RecyclerView. For example **Product implements FeedItem**. Also the category title displayed in the recycler **SectionHeader implements FeedItem**. The UI element that indicates that more items of that category can be loaded is a FeedItem and holds internally it’s own little State to indicate whether or not we are loading more Items of a certain category:

```
public class AdditionalItemsLoadable implements FeedItem {
  private final int moreItemsAvailableCount;
  private final String categoryName;
  private final boolean loading; // if true then loading items is in progress
  private final Throwable loadingError; // indicates an error has occurred while loading

   // ... constructor ...
   // ... getters  ...
```

And last but not least there is a business logic component **HomeFeedLoader** responsible to load **FeedItems**:

```
public class HomeFeedLoader {

  // Typically triggered by pull-to-refresh
  public Observable<List<FeedItem>> loadNewestPage() { ... }

  //Loads the first page
  public Observable<List<FeedItem>> loadFirstPage() { ... }

  // loads the next page (pagination)
  public Observable<List<FeedItem>> loadNextPage() { ... }

  // loads additional products of a certain category
  public Observable<List<Product>> loadProductsOfCategory(String categoryName) { ... }
}
```

Now let’s connect the dots step by step in our Presenter. Please note that some code shown here as part of the Presenter should rather be moved into an Interactor in a real world application (which I didn’t for the sake of better readability). First, lets start with loading the initial data

```
class HomePresenter extends MviBasePresenter<HomeView, HomeViewState> {

  private final HomeFeedLoader feedLoader;

  @Override protected void bindIntents() {
    //
    // In a real app some code here should rather be moved into an Interactor
    //
    Observable<HomeViewState> loadFirstPage = intent(HomeView::loadFirstPageIntent)
        .flatMap(ignored -> feedLoader.loadFirstPage()
            .map(items -> new HomeViewState(items, false, null) )
            .startWith(new HomeViewState(emptyList, true, null) )
            .onErrorReturn(error -> new HomeViewState(emptyList, false, error))

    subscribeViewState(loadFirstPage, HomeView::render);
  }
}
```

So far so good, no big difference to how we have implemented the “search screen” as described in [part 2](http://hannesdorfmann.com/android/mosby3-mvi-2). Now let’s try to add support for pull-to-refresh.

```
class HomePresenter extends MviBasePresenter<HomeView, HomeViewState> {

  private final HomeFeedLoader feedLoader;

  @Override protected void bindIntents() {
    //
    // In a real app some code here should rather be moved into an Interactor
    //
    Observable<HomeViewState> loadFirstPage = ... ;

    Observable<HomeViewState> pullToRefresh = intent(HomeView::pullToRefreshIntent)
        .flatMap(ignored -> feedLoader.loadNewestPage()
            .map( items -> new HomeViewState(...))
            .startWith(new HomeViewState(...))
            .onErrorReturn(error -> new HomeViewState(...)));

    Observable<HomeViewState> allIntents = Observable.merge(loadFirstPage, pullToRefresh);

    subscribeViewState(allIntents, HomeView::render);
  }
}
```

Use Observable.merge() to merge together multiple intents.

But wait: **feedLoader.loadNewestPage()** only returns “newer” items but what about the previous items we have already loaded? In “traditional” MVP one would call something like **view.addNewItems(newItems)** but we have already discussed in [part 1](http://hannesdorfmann.com/android/mosby3-mvi-1) why this is a bad idea (“The State Problem”). The problem we are facing now is that pull-to-refresh depends on the previous HomeViewState since we want to “merge” the previous items with the items returned from pull-to-refresh.

**Ladies and Gentlemen please give a warm welcome to the STATE REDUCER**

![MVI](/images/mvi-mosby3/standingovation3.gif)

State Reducer is a concept from functional programming that takes the previous state as input and computes a new state from the previous state like this:

```
public State reduce( State previous, Foo foo ){
  State newState;
  // ... compute the new State by taking previous state and foo into account ...
  return newState;
}
```

The idea is that such a reduce() function combines the previous state with foo to compute a new state. Foo typically represents the changes we want to apply to the previous state. In our case we want to “reduce” the previous HomeViewState (originally computed from loadFirstPageIntent) with the result from pull-to-refresh. Guess what, RxJava has an operator for that called **scan()**. Let’s refactor our code a little bit. We have to introduce another class representing the partial change (the thing we have called Foo in the previous code snipped) that will be used to compute the new state.

```
class HomePresenter extends MviBasePresenter<HomeView, HomeViewState> {

  private final HomeFeedLoader feedLoader;

  @Override protected void bindIntents() {
    //
    // In a real app some code here should rather be moved into an Interactor
    //
    Observable<PartialState> loadFirstPage = intent(HomeView::loadFirstPageIntent)
        .flatMap(ignored -> feedLoader.loadFirstPage()
            .map(items -> new PartialState.FirstPageData(items) )
            .startWith(new PartialState.FirstPageLoading(true) )
            .onErrorReturn(error -> new PartialState.FirstPageError(error))

    Observable<PartialState> pullToRefresh = intent(HomeView::pullToRefreshIntent)
        .flatMap(ignored -> feedLoader.loadNewestPage()
            .map( items -> new PartialState.PullToRefreshData(items)
            .startWith(new PartialState.PullToRefreshLoading(true)))
            .onErrorReturn(error -> new PartialState.PullToRefreshError(error)));

    Observable<PartialState> allIntents = Observable.merge(loadFirstPage, pullToRefresh);
    HomeViewState initialState = ... ; // Show loading first page
    Observable<HomeViewState> stateObservable = allIntents.scan(initialState, this::viewStateReducer)

    subscribeViewState(stateObservable, HomeView::render);
  }

  private HomeViewState viewStateReducer(HomeViewState previousState, PartialState changes){
    ...
  }
}
```

So what we did here is, that each Intent now returns an Observable<PartialState> rather then directly Observable<HomeViewState>. Then we merge them all into one observable stream with **Observable.merge()** and finally apply the reducer function (**Observable.scan()**). Basically what this means is that, whenever the user starts an intent, this intent will produce **PartialState** objects which then will be “reduced” to a **HomeViewState** that then eventually will be displayed in the View (HomeView.render(HomeViewState)). The only missing part is the state reducer function itself. The HomeViewState class itself hasn’t changed (scroll up to see the class definition), but we have added a Builder (Builder pattern) so that we can create new HomeViewState objects in a convenient way. So let’s implement the state reducer function:

```
private HomeViewState viewStateReducer(HomeViewState previousState, PartialState changes){
    if (changes instanceof PartialState.FirstPageLoading)
        return previousState.toBuilder() // creates a new copy by taking the internal values of previousState
        .firstPageLoading(true) // show ProgressBar
        .firstPageError(null) // don't show error view
        .build()

    if (changes instanceof PartialState.FirstPageError)
     return previousState.builder()
         .firstPageLoading(false) // hide ProgressBar
         .firstPageError(((PartialState.FirstPageError) changes).getError()) // Show error view
         .build();

     if (changes instanceof PartialState.FirstPageLoaded)
       return previousState.builder()
           .firstPageLoading(false)
           .firstPageError(null)
           .data(((PartialState.FirstPageLoaded) changes).getData())
           .build();

     if (changes instanceof PartialState.PullToRefreshLoading)
      return previousState.builder()
            .pullToRefreshLoading(true) // Show pull to refresh indicator
            .nextPageError(null)
            .build();

    if (changes instanceof PartialState.PullToRefreshError)
      return previousState.builder()
          .pullToRefreshLoading(false) // Hide pull to refresh indicator
          .pullToRefreshError(((PartialState.PullToRefreshError) changes).getError())
          .build();

    if (changes instanceof PartialState.PullToRefreshData) {
      List<FeedItem> data = new ArrayList<>();
      data.addAll(((PullToRefreshData) changes).getData()); // insert new data on top of the list
      data.addAll(previousState.getData());
      return previousState.builder()
        .pullToRefreshLoading(false)
        .pullToRefreshError(null)
        .data(data)
        .build();
    }


   throw new IllegalStateException("Don't know how to reduce the partial state " + changes);
}
```

I know, all these **instanceof** checks are not super pretty but that is not the point of this blog post. Why does technical bloggers write “ugly” code like the one shown above? It’s because we want to make a point on a certain topic without requiring the reader to have a full mental model of the source code i.e. of our shopping cart app nor prior knowledge of certain design patterns. Therefore, I think it is better to avoid design patterns in blog posts which would produce nicer code but may lead to harder readable blog posts. The focus of this blog post is set on state reducer. By looking at the state reducer with instanceof checks everybody can understand what the reducer does. Should you use instanceof checks in your app? No, use design patterns or other solutions like defining PartialState as interface with a method like **public HomeViewState computeNewState(previousState)**. In general you may find [RxSealedUnions](https://github.com/pakoito/RxSealedUnions) by Paco Estevez useful when building apps with MVI.

Alright, I think you get the idea how a state reducer works. Let’s implement the remaining features as well: Pagination and the ability to load more items of a certain category:

```
class HomePresenter extends MviBasePresenter<HomeView, HomeViewState> {

  private final HomeFeedLoader feedLoader;

  @Override protected void bindIntents() {

    //
    // In a real app some code here should rather be moved to an Interactor
    //

    Observable<PartialState> loadFirstPage = ... ;
    Observable<PartialState> pullToRefresh = ... ;

    Observable<PartialState> nextPage =
      intent(HomeView::loadNextPageIntent)
          .flatMap(ignored -> feedLoader.loadNextPage()
              .map(items -> new PartialState.NextPageLoaded(items))
              .startWith(new PartialState.NextPageLoading())
              .onErrorReturn(PartialState.NexPageLoadingError::new));

      Observable<PartialState> loadMoreFromCategory =
          intent(HomeView::loadAllProductsFromCategoryIntent)
              .flatMap(categoryName -> feedLoader.loadProductsOfCategory(categoryName)
                  .map( products -> new PartialState.ProductsOfCategoryLoaded(categoryName, products))
                  .startWith(new PartialState.ProductsOfCategoryLoading(categoryName))
                  .onErrorReturn(error -> new PartialState.ProductsOfCategoryError(categoryName, error)));


    Observable<PartialState> allIntents = Observable.merge(loadFirstPage, pullToRefresh, nextPage, loadMoreFromCategory);
    HomeViewState initialState = ... ; // Show loading first page
    Observable<HomeViewState> stateObservable = allIntents.scan(initialState, this::viewStateReducer)

    subscribeViewState(stateObservable, HomeView::render);
  }

  private HomeViewState viewStateReducer(HomeViewState previousState, PartialState changes){
    // ... PartialState handling for First Page and pull-to-refresh as shown in previous code snipped ...

      if (changes instanceof PartialState.NextPageLoading) {
       return previousState.builder().nextPageLoading(true).nextPageError(null).build();
     }

     if (changes instanceof PartialState.NexPageLoadingError)
       return previousState.builder()
           .nextPageLoading(false)
           .nextPageError(((PartialState.NexPageLoadingError) changes).getError())
           .build();


     if (changes instanceof PartialState.NextPageLoaded) {
       List<FeedItem> data = new ArrayList<>();
       data.addAll(previousState.getData());
        // Add new data add the end of the list
       data.addAll(((PartialState.NextPageLoaded) changes).getData());

       return previousState.builder().nextPageLoading(false).nextPageError(null).data(data).build();
     }

     if (changes instanceof PartialState.ProductsOfCategoryLoading) {
         int indexLoadMoreItem = findAdditionalItems(categoryName, previousState.getData());

         AdditionalItemsLoadable ail = (AdditionalItemsLoadable) previousState.getData().get(indexLoadMoreItem);

         AdditionalItemsLoadable itemsThatIndicatesError = ail.builder() // creates a copy of the ail item
         .loading(true).error(null).build();

         List<FeedItem> data = new ArrayList<>();
         data.addAll(previousState.getData());
         data.set(indexLoadMoreItem, itemsThatIndicatesError); // Will display a loading indicator

         return previousState.builder().data(data).build();
      }

     if (changes instanceof PartialState.ProductsOfCategoryLoadingError) {
       int indexLoadMoreItem = findAdditionalItems(categoryName, previousState.getData());

       AdditionalItemsLoadable ail = (AdditionalItemsLoadable) previousState.getData().get(indexLoadMoreItem);

       AdditionalItemsLoadable itemsThatIndicatesError = ail.builder().loading(false).error( ((ProductsOfCategoryLoadingError)changes).getError()).build();

       List<FeedItem> data = new ArrayList<>();
       data.addAll(previousState.getData());
       data.set(indexLoadMoreItem, itemsThatIndicatesError); // Will display an error / retry button

       return previousState.builder().data(data).build();
     }

     if (changes instanceof PartialState.ProductsOfCategoryLoaded) {
       String categoryName = (ProductsOfCategoryLoaded) changes.getCategoryName();
       int indexLoadMoreItem = findAdditionalItems(categoryName, previousState.getData());
       int indexOfSectionHeader = findSectionHeader(categoryName, previousState.getData());

       List<FeedItem> data = new ArrayList<>();
       data.addAll(previousState.getData());
       removeItems(data, indexOfSectionHeader, indexLoadMoreItem); // Removes all items of the given category

       // Adds all items of the category (includes the items previously removed)
       data.addAll(indexOfSectionHeader + 1,((ProductsOfCategoryLoaded) changes).getData());

       return previousState.builder().data(data).build();
     }

     throw new IllegalStateException("Don't know how to reduce the partial state " + changes);
  }
}
```

Implementing pagination (loading next “page” of items) is pretty the same as pull-to-refresh except that we are adding the loaded items at the end of the list instead of the top of the list as we do with pull-to-refresh. More interesting is how we deal with loading more items of a certain category. Well, for displaying a loading indicator and an error / retry button for a given category we only have to search for the corresponding AdditionalItemsLoadable object in the list of all FeedItems. Then we change that item to either show loading indicator or error / retry button. If we have loaded all items of a certain category successfully we search for the SectionHeader and AdditionalItemsLoadable and replace all items in between with the newly loaded items. That’s it.

## Conclusion

The aim of this blog post was to show you how a state reducer can help us to build complex screens with very little and understandable code. Just step back and think how you would have implemented that with “traditional” MVP or MVVM without a state reducer? The key to be able to use a state reducer is obviously that we have a Model class that is reflecting the State. Therefore, it was very important to understand what a Model actually is as described in the [first part](http://hannesdorfmann.com/android/mosby3-mvi-1) of this blog post series. Also, a state reducer can only be used if we are sure that the State (or Model to be precise) comes from a single source of truth. Therefore, a unidirectional data flow is very important. I hope that now it makes more sense why we have spend part 1 and part 2 on these topics and that you now got this “aha” moment where all the dots connect together. If not, no worries, it took quite some time for me too (and a lot of practice and a lot of mistakes and retries).

You may be wondering why we haven’t used a state reducer for the “Search Screen” (see [part 2](http://hannesdorfmann.com/android/mosby3-mvi-2)). State Reducer make mostly sense if we are depending on the previous state somehow. In the “Search Screen” we are not depending on the previous state.

Last but not least, I would like to point out, if you haven’t noticed that yet (without going to much into details), that all our data is immutable (we always create a new HomeViewState, we never call a setter method on any object). Therefore, also mutli-threading is super easy. The user can start pull-to-refresh at the same time as loading the next page and load more items of a certain category because the state reducer is able to produce the correct state without depending on any particular order of the http responses. Additionally, we have written our code with pure functions, no [side-effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science)). This makes our code super testable, reproducible, simple to reason about and highly parallelizable (mutli-threading).

Of course state reducer wasn’t invented for MVI. You find the concept of a state reducer in many other libraries, frameworks and systems across multiple programming languages. A state reducer fits perfectly into the philosophy of Model-View-Intent with an unidirectional data flow and a Model representing the State.

In the next part we are focusing on how to build reusable and reactive UI components with MVI.

**This post is part of the blog post series "Reactive Apps with Model-View-Intent".
Here is the Table of Content:**

* [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
* [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
* [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
* [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
* [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
* [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
* [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
