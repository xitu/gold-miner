> * 原文地址：[How to leak memory with Subscriptions in RxJava](https://medium.com/@scanarch/how-to-leak-memory-with-subscriptions-in-rxjava-ae0ef01ad361#.frvn3pkux)
* 原文作者：[Marcin Robaczyński](https://medium.com/@scanarch)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

![](https://cdn-images-1.medium.com/max/2000/1*aroR2HpWJo8simEzPVRgjQ.jpeg)

# How to leak memory with Subscriptions in RxJava

There are plenty of great how-to articles about RxJava. It does simplify things significantly when working with Android framework but be careful because simplification may have its own pitfalls. In the following parts, you are going to explore one of them and see how easy it is to create a memory leak with RxJava’s `Subscriptions`.

### Solving simple task

Imagine that your manager called in and asked you to create a widget which displays a random movie title. It has to be based on some external recommendation service. This widget should display a movie title on user’s demand or it could do it on its own. The manager also wants this widget to be able to store some information related to user’s interaction with it.

MVP-based approach is one of the many ways to do this. You create a simple view containing both`ProgressBar` and`TextView` widgets. The `RecommendedMovieUseCase` handles providing a random movie title. 
`Presenter` connects to a use case and displays a title on a view. Saving presenter’s state is implemented by keeping it in memory even when your Activity is being recreated (in so-called `NonConfigurationScope`).

Here is how your `Presenter` looks like. For the purpose of this article, let’s assume that you want to store a flag indicating whether the user has tapped the title.

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

A widget will be added to a purple container when the user asks for a recommendation. It will be removed after the user decides to clear it.

![](https://cdn-images-1.medium.com/max/1600/1*C85wCkIAGeDiLIPGNXk8Iw.gif)

Everything seems to be working fine for now.

To be safer, we decided to initialize StrictMode in debug builds.
We start to play around with our app and try to rotate our device a couple of times. Suddenly, a log message appears.

![](https://cdn-images-1.medium.com/max/2000/1*JF-royfW1_twemFL3Gn88Q.png)

This does not sound right. You can try dumping current memory state and take a deeper look at the problem:

![](https://cdn-images-1.medium.com/max/2000/1*e8IblGcaEdyFJC1jCYOpGw.png)

There is your culprit marked with the blue font. For some reason, there is still an instance of `MovieSuggestionView` holding a reference to an old `MainActivity` instance.

But why? You have unsubscribed from your background job and also cleared the reference to a `MovieSuggestionView` when dropping the view from your `Presenter`. Where is this leak coming from?

### Searching for a leak

By storing a reference to a `Subscription`, you are actually storing an instance of an `ActionSubscriber<T>`, which looks like this:

```
public final class ActionSubscriber<T> extends Subscriber<T> {

    final Action1<? super T> onNext;
    final Action1<Throwable> onError;
    final Action0 onCompleted;

    ...
}
```

Because of `onNext`, `onError` and `onCompleted` fields being final there is no clean way to nullify them. The problem is that calling `unsubscribe()` on a `Subscriber` only marks it as unsubscribed (and couple of things more, but it is not important in our case).

For those who are wondering from where this `ActionSubscriber` object comes from, take a look at the `subscribe` method definition:

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

Further analysis of the memory dump proves that MovieSuggestionView reference is indeed still kept inside of `onNext` and `onError` fields.

![](https://cdn-images-1.medium.com/max/2000/1*VS65D4I9rNUvlQ34sGnFSw.png)

To understand the problem better, let’s dig a little bit deeper and see what happens after your code gets compiled.

    => ls -1 app/build/intermediates/classes/debug/me/scana/subscriptionsleak

    ...
    Presenter$1.class
    Presenter$2.class
    Presenter.class
    ...

You can see that in addition to your main `Presenter` class, you get two additional class files, one for each of anonymous `Action1<>` classes that you introduced.

Let’s check out what is happening inside of one of those anonymous classes using a handy *javap* tool:

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