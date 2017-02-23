> * 原文地址：[How to leak memory with Subscriptions in RxJava](https://medium.com/@scanarch/how-to-leak-memory-with-subscriptions-in-rxjava-ae0ef01ad361#.frvn3pkux)
* 原文作者：[Marcin Robaczyński](https://medium.com/@scanarch)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [tanglie1993](https://github.com/tanglie1993)
* 校对者：
---

![](https://cdn-images-1.medium.com/max/2000/1*aroR2HpWJo8simEzPVRgjQ.jpeg)

# RxJava 中的 Subscriptions 是怎样泄露内存的

关于 RxJava 已经有了很多很好的的教程文章。在使用 Android 框架时，它确实显著地简化了工作。然而需要注意，这种简化有它自己的缺陷。在接下来的部分中，你将探索其中的一个，从而了解 RxJava 的 Subscriptions 有多容易造成内存泄漏。



### 解决简单任务

假设你的主管让你实现一个显示随机的电影名的控件。它必须基于一些外部的推荐服务。这个控件应当根据用户要求显示电影名称。如果用户没有要求，它也可以自己显示。你的主管还希望它可以存储一些和用户交互有关的信息。
有很多办法可以实现这一点。基于 MVP 的方法是其中之一。你可以创建一个包含 ProgressBar 和 TextView 的 view。`RecommendedMovieUseCase`负责提供一个随机的电影名。
`Presenter`和一个用例相连，并在 view 上显示一个标题。 Presenter 的状态是被保存在内存中的，甚至在 Activity（在 `NonConfigurationScope` 中）被重新创建时，它也还会在内存中。
这是你的 Presenter 的样子。在这篇文章中，我们假定你想要存储一个用于标志用户是否点击了标题的flag。

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

安全起见，我们决定初始化在 debug build 中初始化 StrictMode。
我们开始试用我们的 app，并尝试把我们的设备旋转几次。突然，一条 log 消息出现了。

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

我们使用非常方便的 *javap* 工具，看看这些匿名类内部发生着什么：

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

你可能听说过，一个匿名的类持有对外部类的隐式引用。
You might have heard that an anonymous class holds an implicit reference to an outer class. **It turns out that anonymous classes also *capture* all of the variables that you use inside of them.**

Because of this, by keeping a reference to a `Subscription` object, you effectively keep references to those anonymous classes that you used to handle the movie title result. They keep the reference to a view that you wanted to do something with and there is your leak.

### You know what is wrong with our current solution. So, how do you fix it?

It is quite easy.

You can set our `Subscription` object to `Subscription.empty()`, thus clearing up a reference to an old `ActionObserver`.

There is also a `CompositeSubscription` class which allows to store multiple `Subscription` objects and performs `unsubscribe()` on them. This should relieve us from storing a `Subscription` reference directly. Keep in mind, though, that this will not yet solve your problem. The references are still going to be kept inside of `CompositeSubscription`.

Fortunately, there is a `clear()` method available, which unsubscribes everything and then clears up the references. It also allows you to reuse a `CompositeSubscription` object as opposed to `unsubscribe()` which renders your object unusable.

Here is fixed `Presenter` class with one of the aforementioned methods implemented:

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

It is worth adding that you can actually solve this problem in many different ways. Always keep in mind that there is no silver bullet for every issue that you come upon.

### To sum things up:

- `Subscription` objects hold final references to your callbacks. Your callbacks can hold references to your Android’s lifecycle-tied objects. They both can leak memory when not treated with care
- You can use tools like StrictMode, javap, HPROF Viewer to find and analyze the source of leaks. I did not mention it in the article, but you can also check out the LeakCanary library from Square.
- Digging into libraries that you use on a daily basis helps a lot with solving potential problems that may arise
