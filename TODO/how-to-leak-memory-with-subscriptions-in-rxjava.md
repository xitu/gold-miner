> * 原文地址：[How to leak memory with Subscriptions in RxJava](https://medium.com/@scanarch/how-to-leak-memory-with-subscriptions-in-rxjava-ae0ef01ad361#.frvn3pkux)
* 原文作者：[Marcin Robaczyński](https://medium.com/@scanarch)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [tanglie1993](https://github.com/tanglie1993)
* 校对者：[ilumer](https://github.com/ilumer), [jamweak](https://github.com/jamweak)

---

![](https://cdn-images-1.medium.com/max/2000/1*aroR2HpWJo8simEzPVRgjQ.jpeg)

# RxJava 中的 Subscriptions 是怎样泄露内存的

关于 RxJava 已经有了很多很好的的教程文章。在使用 Android 框架时，它确实显著地简化了工作。然而需要注意，这种简化有它自己的缺陷。在接下来的部分中，你将探索其中的一个，从而了解 RxJava 的 Subscriptions 有多容易造成内存泄漏。



### 解决简单任务

假设你的主管让你实现一个显示随机的电影名的控件。它必须基于一些外部的推荐服务。这个控件应当根据用户要求显示电影名称。如果用户没有要求，它也可以自己显示。你的主管还希望它可以存储一些和用户交互有关的信息。
有很多办法可以实现这一点。基于 MVP 的方法是其中之一。你可以创建一个包含 ProgressBar 和 TextView 的 view。`RecommendedMovieUseCase`负责提供一个随机的电影名。
`Presenter`和一个用例相连，并在 view 上显示一个标题。 Presenter 的状态是被保存在内存中的，甚至在 Activity（在 `NonConfigurationScope` 中）被重新创建时，它也还会在内存中。
这是你的 Presenter 的样子。在这篇文章中，我们假定你想要存储一个用于标志用户是否点击了标题的 flag。

```
@NonConfigurationScope
public class Presenter {

    private final RecommendMovieUseCase recommendMovieUseCase;

    private Subscription subscription = Subscriptions.empty();
    private MovieSuggestionView view;
    private boolean didUserTapTitle;

    public Presenter(RecommendMovieUseCase recommendMovieUseCase) {
        this.recommendMovieUseCase = recommendMovieUseCase;
    }

    public void setView(@NonNull MovieSuggestionView view) {
        this.view = view;
    }
    
    public void present() {
        showRecommendedMovieTitle(view);
    }

    private void showRecommendedMovieTitle(final MovieSuggestionView view) {
        view.showProgress();
        subscription = recommendMovieUseCase.recommendRandomMovie()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Action1<String>() {
                    @Override
                    public void call(String movieTitle) {
                        view.hideProgress();
                        view.showTitle(movieTitle);
                    }
                }, new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {
                        view.hideProgress();
                        view.showLoadingError();
                    }
                });
    }

    public void onViewTapped() {
        didUserTapTitle = true;
    }

    public void destroy() {
        subscription.unsubscribe();
        view = null;
    }
}

```
当用户请求推荐时，一个控件将会被加入紫色的容器。在用户决定清除它之后，它将会被移除。

![](https://cdn-images-1.medium.com/max/1600/1*C85wCkIAGeDiLIPGNXk8Iw.gif)

目前一切看起来都没问题。

安全起见，我们决定在 debug build 中初始化 StrictMode。
我们开始试用 app，并尝试把我们的设备旋转几次。突然，一条 log 消息出现了。

![](https://cdn-images-1.medium.com/max/2000/1*JF-royfW1_twemFL3Gn88Q.png)

这听起来不对。你可以尝试导出目前的内存状态，仔细研究这个问题：

![](https://cdn-images-1.medium.com/max/2000/1*e8IblGcaEdyFJC1jCYOpGw.png)

罪魁祸首是蓝色字体标出的部分。由于某种原因，仍然有一个 `MovieSuggestionView` 的实例持有对原有 `MainActivity` 的引用。

但是为什么？你已经注销了后台的工作，并在从你的 `Presenter` 中删除 view 时清除了对 `MovieSuggestionView` 的引用。这个泄露出自哪里？

### 查找泄露

通过把引用存储到 `Subscription`，你实际上把 `ActionSubscriber<T>` 的实例存储起来了。它看上去像这样：

```
public final class ActionSubscriber<T> extends Subscriber<T> {

    final Action1<? super T> onNext;
    final Action1<Throwable> onError;
    final Action0 onCompleted;

    ...
}
```
由于 `onNext`, `onError` 和 `onCompleted` 是 final 变量，你没有办法把它们设为 null。问题是在 `Subscriber` 上调用 `unsubscribe()` 只会把它标志为已注销（也会做些别的事情，但对我们来说不重要）。

对于那些怀疑这个 `ActionSubscriber` 从哪里来的人而言，你们可以看看 `subscribe` 方法的定义：

```
public final Subscription subscribe(final Action1<? super T> onNext, final Action1<Throwable> onError) {
    if (onNext == null) {
        throw new IllegalArgumentException("onNext can not be null");
    }
    if (onError == null) {
        throw new IllegalArgumentException("onError can not be null");
    }
    Action0 onCompleted = Actions.empty();
    return subscribe(new ActionSubscriber<T>(onNext, onError, onCompleted));
}
```

对 memory dump 的进一步分析证明：MovieSuggestionView 的引用仍然被保留在 `onNext` 和 `onError` 域的内部。

![](https://cdn-images-1.medium.com/max/2000/1*VS65D4I9rNUvlQ34sGnFSw.png)

为了更好地理解这个问题，请挖掘得更深一点，看你的代码编译后会发生什么。

    => ls -1 app/build/intermediates/classes/debug/me/scana/subscriptionsleak

    ...
    Presenter$1.class
    Presenter$2.class
    Presenter.class
    ...
    
你可以看到，除了你的主要的 `Presenter` 类之外，还有两个额外的类文件，分别对应你引入的两个匿名 `Action1<>` 类。

我们使用非常方便的 *javap* 工具，看看其中一个匿名类内部发生着什么：

    => javap -c Presenter\$1
    
```
class me.scana.subscriptionsleak.Presenter$1 implements rx.functions.Action1<java.lang.String> {

  final me.scana.subscriptionsleak.MovieSuggestionView val$view;
  final me.scana.subscriptionsleak.Presenter this$0;
  
  me.scana.subscriptionsleak.Presenter$1(me.scana.subscriptionsleak.Presenter, me.scana.subscriptionsleak.MovieSuggestionView);
    Code:
      0: aload_0
      1: aload_1
      2: putfield #1 //Field this$0:Lme/scana/subscriptionsleak/Presenter;
      5: aload_0
      6: aload_2
      7: putfield #2 //Field val$view:Lme/scana/subscriptionsleak/MovieSuggestionView;
      ...
}
view raw
```

你可能听说过，一个匿名的类持有对外部类的隐式引用。**事实证明，匿名类会持有所有在它内部使用的变量。**

因此，通过保留对 `Subscription` 对象的引用，你保留了用于处理电影名结果的匿名类的引用。它们保留了对你希望处理的 view 的引用，这就是内存泄露的地方。

### 你已经知道了目前的问题所在，那么，如何解决呢？

这很简单。

你可以对 `Subscription` 对象调用 `Subscription.empty()`，从而清除对旧  `ActionObserver` 的引用。

 `CompositeSubscription` 类可以存储多个 `Subscription` 对象，并对他们进行  `unsubscribe()`。这可以使我们免于直接存储 `Subscription` 引用。记住，这还不会解决你的问题。引用仍然会被存储在 `CompositeSubscription` 内部。

幸运的是，还有一个 `clear()` 方法，它注销所有东西并清除引用。它还允许你重用 `CompositeSubscription` 对象，而 `unsubscribe()` 会使你的对象完全不可用。

这是修正过的 `Presenter` 类，它实现了一个前文提到的方法：

```
@NonConfigurationScope
public class NonLeakingPresenter implements Presenter {

    private final RecommendMovieUseCase recommendMovieUseCase;

    private CompositeSubscription compositeSubscription = new CompositeSubscription();
    private MovieSuggestionView view;
    private boolean didUserTapTitle;

    public NonLeakingPresenter(RecommendMovieUseCase recommendMovieUseCase) {
        this.recommendMovieUseCase = recommendMovieUseCase;
    }

    @Override
    public void setView(@NonNull MovieSuggestionView view) {
        this.view = view;
    }
    
    @Override
    public void present() {
        showRecommendedMovieTitle(view);        
    }

    private void showRecommendedMovieTitle(final MovieSuggestionView view) {
        view.showProgress();
        Subscription subscription = recommendMovieUseCase.recommendRandomMovie()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Action1<String>() {
                    @Override
                    public void call(String movieTitle) {
                        view.hideProgress();
                        view.showTitle(movieTitle);
                    }
                }, new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {
                        view.hideProgress();
                        view.showLoadingError();
                    }
                });
        compositeSubscription.add(subscription);
    }

    @Override
    public void onViewTapped() {
        didUserTapTitle = true;
    }

    @Override
    public void destroy() {
        compositeSubscription.clear();
        view = null;
    }
}
```

值得一提的是，你有很多方法可以解决这个问题。记住：没有一种解决方案适用于你遇到的所有问题。

### 总结：

- `Subscription` 对象持有对你的回调的 final 引用。你的回调可能引用和 Android 生命周期绑定的对象。如果不小心的话，他们都有可能造成内存泄露。
- 你可以使用 StrictMode, javap, HPROF Viewer 等工具寻找和分析泄露的根源。我在文章中没有提及，但你也可以尝试 Square 的 LeakCanary。
- 深入挖掘你日常使用的库，有助于解决潜在的问题。
