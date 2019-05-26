> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART3 - STATE REDUCER](http://hannesdorfmann.com/android/mosby3-mvi-3)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-3.md)
> * 译者：[pcdack](https://github.com/pcdack)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# 使用 MVI 开发响应式 APP — 第三部分 — 状态折叠器（state reducer）

在[前面的系列里](http://hannesdorfmann.com/android/mosby3-mvi-2) 我们已经讨论了如何用 Model-View-Intent 模式和单向数据流去实现一个简单的页面。在这篇博客里我们将要实现更加复杂页面，这个页面将有助于我们理解状态折叠器(state reducer)。

如果你没读[第二部分](http://hannesdorfmann.com/android/mosby3-mvi-2)，你应该先去读一下第二部分，然后再读这篇博客, 因为第二部分博客描述我们如何将业务逻辑通过 Presenter 与 View 进行沟通，如果让数据进行单向流动。

现在我们构建一个更加复杂的场景，像下面演示的内容:

![](https://i.loli.net/2018/02/24/5a9114deeb147.gif)

正如你所见，上面的演示内容，就是根据不同的类型显示商品列表。这个 APP 中每个类型只显示三个项,用户可以点击加载更多，来加载更多的商品（http请求）。另外，用户可以使用下拉刷新去更新不同类型下的商品，并且，当用户加载到最底端的时候，可以加载更多类型的商品（加载下一页的商品）。当然，当出现异常的时候，所有的这些动作执行过程与正常加载时候类似，只不过显示的内容不同（例如：显示网络错误）。

让我们一步一步实现这个页面。第一步定义View的接口。

```
public interface HomeView {

  /**
   * 加载首页意图
   *
   * @return 发射的值可以被忽略，无论true或者false都没有其他任何不一样的意义
   */
  public Observable<Boolean> loadFirstPageIntent();

  /**
   * 加载下一页意图
   *
   * @return 发射的值可以被忽略，无论true或者false都没有其他任何不一样的意义
   */
  public Observable<Boolean> loadNextPageIntent();

  /**
   * 下拉刷新意图
   *
   * @return 发射的值可以被忽略，无论true或者false都没有其他任何不一样的意义
  */
  public Observable<Boolean> pullToRefreshIntent();

  /**
   * 上拉加载更多意图
   *
   * @return 返回类别的可观察对象
   */
  public Observable<String> loadAllProductsFromCategoryIntent();

  /**
   * 渲染
   */
  public void render(HomeViewState viewState);
}
```

View的具体实现灰常简单，并且我不想把代码贴在这里(你可以在[github上看到](https://github.com/sockeqwe/mosby/blob/master/sample-mvi/src/main/java/com/hannesdorfmann/mosby3/sample/mvi/view/home/HomeFragment.java))。下一步，让我们聚焦Model。我前面的文章也说过Model应该代表状态(State)。因此让我们去实现我们的 **HomeViewState**:

```
public final class HomeViewState {

  private final boolean loadingFirstPage; // 显示加载指示器，而不是 recyclerView
  private final Throwable firstPageError; //如果不为 null，就显示状态错误的 View
  private final List<FeedItem> data;   // 在 recyclerview 显示的项
  private final boolean loadingNextPage; // 加载下一页时，显示加载指示器
  private final Throwable nextPageError; // 如果！=null，显示加载页面错误的Toast
  private final boolean loadingPullToRefresh; // 显示下拉刷新指示器 
  private final Throwable pullToRefreshError; // 如果！=null，显示下拉刷新错误

   // ... constructor ...
   // ... getters  ...
}
```

注意 **FeedItem**  是每一个 RecyclerView 所展示的子项所需要实现的接口。例如**Product 就是实现了 FeedItem 这个接口**。另外展示类别标签的 **SectionHeader同样也实现FeedItem**。加载更多的UI元素也是需要实现FeedItem，并且，它内部有一个小的状态，去标示我们在当前类型下是否加载更多项:

```
public class AdditionalItemsLoadable implements FeedItem {
  private final int moreItemsAvailableCount;
  private final String categoryName;
  private final boolean loading; // 如果为true，那么正在下载
  private final Throwable loadingError; // 用来表示，当加载过程中出现的错误

   // ... constructor ...
   // ... getters  ...
```

最后，也是比较重要的是我们的业务逻辑部分 **HomeFeedLoader** 的责任是加载其 **FeedItems**:

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

现在让我们一步一步的将上面分开的部分用Presenter连接起来。请注意，当在正式环境中这里展现的一部分Presenter的代码需要被移动到一个Interactor中（我没按照规范写是因为可以更好理解）。第一，让我们开始加载初始化数据

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

到现在为止，貌似和我们在[第二部分(已翻译)](https://juejin.im/post/5a7ef3af6fb9a0634a390d20)描述的构建搜索页面是一样的。 现在，我们需要添加下拉刷新的功能。

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

使用Observable.merge（）将多个意图合并在一起。

但是等等: **feedLoader.loadNewestPage()** 仅仅返回"最新"的项，但是关于前面我们已经加载的项如何处理？在"传统"的MVP中，那么可以通过调用类似于 **view.addNewItems(newItems)** 来处理这个问题。但是我们已经在这个系列的[第一篇(已翻译)](https://juejin.im/post/5a52e4445188257334228b28)中讨论过这为什么是一个不好的办法（“状态问题”）。现在我们面临的问题是下拉刷新依赖于先前的HomeViewState,我们想当下拉刷新完成以后，将新取得的项与原来的项合并。

**女士们，先生们让我们掌声有请--Mr.状态折叠器（STATE REDUCER）**

![MVI](/images/mvi-mosby3/standingovation3.gif)

状态折叠器(STATE REDUCER)是函数式编程里面的重要内容，它提供了一种机制能够让以前的状态作为输入现在的状态作为输出:

```
public State reduce( State previous, Foo foo ){
  State newState;
  // ... compute the new State by taking previous state and foo into account ...
  return newState;
}
```

这个想法是这样一个 reduce() 函数结合了前一个状态和 foo 来计算一个新的状态。Foo类型代表我们想让先前状态发生的变化。在这个案例中，我们通过下拉刷新，想"减少(reduce)"HomeViewState的先前状态生成我们希望的结果。你猜如何，RxJava提供了一个操作符叫做 **scan()**. 让我们重构一点我们的代码。我们不得不去描述另一个代表部分变化（在先前的代码片段中，我们称之为 Foo）的类，这个类将用来计算新的状态。

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

因此，我们这里在做的是。每个意图(Intent)现在会返回一个 Observable<PartialState> 而不是直接返回 Observable<HomeViewState>。然后，我们用 Observable.merge() 去合并它们到一个观察流，最后再应用减少(reducer)方法(Observable.scan())。这也就意味着，无论何时用户开启一个意图，这个意图将生成一个 **PartialState** 对象，这个对象将被"减少(reduced)"成为 **HomeViewState** 然后将被显示到View上(HomeView.render(HomeViewState))。还有一点剩下的部分，就是reducer函数自己的状态。HomeViewState 类它自己没有变化(向上滑动你可看到这个类的定义)。但是我们需要添加一个 Builder(Builder模式)因此我们可以创建一个新的 HomeViewState 对象用一种比较方便的方式。因此让我们实现状态折叠器(state reducer)的方法:

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

我知道，所有的 **instanceof** 检查不是一个特别好的方法，但是，这个不是这篇博客的重点。为啥技术博客就不能写"丑"的代码？我仅仅是想让我的观点能够让读者很快的理解和明白。我认为这是一个好的方法去避免一些博客写的一手好代码但是没几个人能看懂。我们这篇博客的聚焦点在状态折叠器上。通过 instanceof 检查所有的东西，我们可以理解状态折叠器到底是什么玩意。你应该用 instanceof 检查在你的 APP 中么？不应该，用设计模式或者其他的解决方法像定义 PartialState 作为接口带有一个 **public HomeViewState computeNewState(previousState)**。方法。通常情况下Paco Estevez 的 [RxSealedUnions](https://github.com/pakoito/RxSealedUnions) 库变得十分有用当我们使用MVI构建App的时候。

好的，我认为你已经理解了状态折叠器(state reducer)的工作原理。让我们实现剩下的方法：当前种类加载更多的功能:

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

实现分页功能（加载下一页的项）类似于下拉刷新，除了在下拉刷新中，我们把数据是更新到上面，而在这里我们把数据更新到当前分类数据的后面。当然，显示加载指示器，错误/重试按钮的实现，我们仅仅只需需要找到对应的 AdditionalltemsLoadable 对象在 FeedItems 列表中。然后，我们改变项的显示为错误/重新加载按钮。如果我们已经成功的加载了当前分类的所有的项，我们找到 SectionHeader和 AdditionaltemsLoadable，并且替换所有的项在新的项加载项之前。

## 总结

这篇博客的目标是为了向大家展示什么是状态折叠器，状态折叠器如何帮助大家用很少的代码去实现构建复杂的的页面。回过头来看，你可以实现"传统"的 MVP 或 MVVM 而不用状态折叠器?用状态折叠器的关键是我们用一个 Model 类来反应一种状态。因此，理解第一篇博客所写的什么是 Model 是十分重要的。并且，状态折叠器有且被用在如果我们明确的知道状态来自单个源头。因此，单项数据流也是十分重要的。我希望在理解这篇博客值钱吗需要先理解前几篇博客的内容。将所有分离的知识点联系起来。不要慌，这花了我很多时间（很多练习，错误和重试），你会比我花更少的时间的。

你也许会想，为什么我们在第二部分搜索页面不用状态折叠器(看[第二部分](http://hannesdorfmann.com/android/mosby3-mvi-2))。状态折叠器大多数用在，我们依赖于上一次状态的场景下。在“搜索页面下”我们不依赖于先前状态。

最后但是同样重要的是，我想指出，如果你也同样注意到（没有太多细节），就是我们所有的数据都是不变的(我们总是在不停的创建新的 HomeViewState,我们没有在任何一个对象里调用任何一个 setter 方法)。因此，多线程将变得非常简单。用户可以下拉刷新的同时上拉加载更多和加载当前分类的更多项因为状态折叠器生成当前状态不依赖于特有的 HTTP 请求。另外，我们写我们的代码用的是纯函数没有[副作用](https://en.wikipedia.org/wiki/Side_effect_(computer_science))。它使我们的代码非常容易的测试，重构，简单的逻辑和高度可并行化（多线程）。

当然，状态折叠器不是 MVI 创造的。你可以在其他库，架构和其他多语言中找到状态折叠器的概念。状态折叠器机制非常符合 MVI 中的单项数据流和 Model 代表状态的这种特性。

在下一个部分我们将关注与如何用 MVI 来构建可复用的响应式 UI 组件。

这篇博客是"Reactive Apps with Model-View-Intent"这个系列博客的一部分。
这里是内容表:

* [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
* [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
* [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
* [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
* [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
* [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
* [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
