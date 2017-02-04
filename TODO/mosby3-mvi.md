> * 原文地址：[Reactive Apps with Model-View-Intent - Part1 - Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
* 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Reactive Apps with Model-View-Intent - Part1 - Model #
# 模型-视图-意图模型下的响应式应用 － 第一部分 － 模型 #

Once I have figured out that I have modeled my Model classes wrong all the time, a lot of issues and headache I previously had with some Android platform related topics are gone. Moreover, finally I was able to build Reactive Apps using RxJava and Model-View-Intent (MVI) as I never was able before although the apps I have built so far are reactive too but not on the same level of reactiveness as I’m going to describe in this blog post series. In the first part I would like to talk about Model and why Model matters.
当我想明白原来我的模型类一直被我用错了，一大堆以前我遇到的安卓平台相关的问题就都消失了。更重要的是，我终于使用RxJava和模型-视图-意图模型来构建响应式应用了，因为我从来没成功过，尽管我已经构建过很多响应式应用，但与我马上要在博客上写的这一系列不是一个等级的。在第一部分，我想讲讲模型以及为什么模型这么重要。

So what do I mean with “modeled Models in a wrong way”? Well, there are a lot of architectural patterns out there to separate the “View” from your “Model”. The most popular ones, at least in Android development, are Model-View-Controller (MVC), Model-View-Presenter (MVP) and Model-View-ViewModel (MVVM). Do you notice something by just looking at the name of these patterns? They all talk about a “Model”. I realized that most of the time I didn’t have a Model at all.
我说“我的模型类一直被我用错了”是什么意思呢？其实，有很多架构模式可以把视图和模型分开。最受欢迎的几种（至少在安卓开发中）是模型－视图－控制器（MVC），模型－视图－提供器（MVP）以及模型－视图－视图模型（MVVM）。通过观察这些模式的名字，不知道你有没有注意到什么。它们都说到了“模型”。我发现大多数情况下我根本就没有用到模型。

Example: Just load a list of persons from a backend. A “traditional” MVP implementation could look like this:
例子：从后台加载一份人员列表。一个“传统的”MVP 实现看起来就像下面这样：

```
class PersonsPresenter extends Presenter<PersonsView> {

  public void load(){
    getView().showLoading(true); // 在屏幕上显示进度条
    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
        getView().showPersons(persons); // 在屏幕上显示一份人员名单      }

      public void onError(Throwable error){
        getView().showError(error); // 在屏幕上显示一个错误信息      }
    });
  }
}
```

But where or what is the “Model”? Is it the backend? No, that is business logic. Is it the result List? No, that is just one thing our View displays amongst others like a loading indicator or an error message. So, what actually is the "Model"?
但是，哪里或者哪个是所谓的“模型”呢？是后台吗？当然不是，哪个是业务逻辑。那是名单吗？也不是，那个只是我们的视图显示，跟加载指示器或错误信息一样。那么，到底哪个是“模型”呢？

From my point of view there should be a “Model” class like this:
在我看来，这里应该有个“模型”类像下面这样：

```
class PersonsModel {
  // 在真实的应用中，属性是私有的
  // 并且会有 getter 方法去获取他们
  final boolean loading;
  final List<Person> persons;
  final Throwable error;

  public(boolean loading, List<Person> persons, Throwable error){
    this.loading = loading;
    this.persons = persons;
    this.error = error;
  }
}
```

And then the Presenter could be implemented like this:
然后，提供器的可以实现如下：

```
class PersonsPresenter extends Presenter<PersonsView> {

  public void load(){
    getView().render( new PersonsModel(true, null, null) ); // 显示一个进度条

    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
        getView().render( new PersonsModel(false, persons, null) ); // 显示一份人员名单
      }

      public void onError(Throwable error){
          getView().render( new PersonsModel(false, null, error) ); // 显示一个错误信息
      }
    });
  }
}
```

Now the View has a Model which then will be “rendered” on the screen. This concept is not really something new. The original MVC definition by Trygve Reenskaug from 1979 had quite a similar concept: The View observes the Model for changes. Unfortunately, the term MVC has been (mis)used to describe too many different patterns that are not really the same what Reenskaug formulated in 1979. For instance, backend developers use MVC frameworks, iOS has ViewController and what does MVC on Android actually mean? Activities are Controller? What is a ClickListener then? Nowadays the term MVC is just a big mistake, misusage and misinterpretation of what Reenskaug originally formulated. But let’s stop this discussion about MVC here, this could run out of control.
现在，视图有一个模型可以显示在屏幕上。这并不是什么新的概念。Trygve Reenskaug 所定义的最原始的 MVC 有相近的概念：视图观察模型的改变。不幸的是，MVC 这个名词一直被误用于描述很多不同于 Reenskaug 在1979年所定义的模式。例如，后台开发者使用 MVC 架构，iOS 使用 VieController。但在 Android 里 MVC 到底意味着什么呢？Activity 是控制器吗？那么 ClickListener 是什么呢？如今， 大家对于 MVC 这个名词有很大的误解并且被误用，已经曲解了 Reenskaug 的原意。让我们先不急着讨论 MVC，这可能会让我们偏离正轨。

Let’s come back to what I have claimed at the beginning. Having a “Model” solves a lot of issues we quite often struggle with in Android development:
我们回到我最初的论点。一个“模型”解决了很多我们在安卓开发中常遇到并头疼的问题。

1. The State Problem

2. Screen orientation changes

3. Navigation on the back stack

4. Process death

5. Immutability and unidirectional data flow

6. Debuggable and reproducible states

7. Testability

1. 状态问题

2. 屏幕方向的改变

3. 返回栈导航

4. 进程死亡

5. 不可变的单向数据流

6. 可调试且可复现的状态

7. 易测性


Let’s discuss these points and let’s see how “traditional” implementations of MVP and MVVM deal with these problems and finally how a “Model” can help to prevent common pitfalls.
让我们一起讨论这几点问题，看看是在 MVP 和 MVVM 模式下，这些问题是如何用“传统”的实现来解决，最后”模型“是怎么帮助我们绕过通常的陷阱。

## 1. The State Problem ##
## 1. 状态问题 ##

Reactive Apps - this is a buzzword, isn’t it? With that I mean are apps with a UI that react on state changes. Ah, here we have another nice word: “State”. What is “State”? Well, most of the time we describe “State” as what we see on the screen, like “loading state” when the View displays a ProgressBar. Therein lies the crux: we frontend developers tend to be focused on UI. That is not necessarily a bad thing because at the end of the day a good UI decides whether or not a User will use our app and therefore how successful an app is. But take a look at the very basic MVP code example from above (not the one using PersonsModel).
Here the state of the UI is coordinated by the Presenter, since the Presenter tells the View what to display. The same is true for MVVM. In this blog post I want to distinguish between two MVVM implementations: The first one with Android’s data binding and the second option using RxJava. In MVVM with data binding the state directly sits in the ViewModel:
响应式应用 － 真是一个时髦的词语。我用这个词来表达一个应用通过 UI 来响应状态的改变。啊，对，我们有另外一个词：“State（状态）”。什么是“State”呢？其实，通常我们把“State”描述为我们在屏幕上的所见，比如视图显示进度条时表示“正在加载的状态”。关键在于：我们的前端开发者趋于关注 UI。这并不一定是一件坏事因为最终用户是否会使用我们的应用是由 UI 的好坏决定，而这也决定了一个应用的成败。但是，看一下上面简单的 MVP 例子（没有用到 PersonsModel 的那个）。在这里，UI 的状态是与显示器协作的，因为显示器会告诉视图需要显示什么。同样地，这也适用于 MVVM。在这篇博客里，我想要区别两种 MVVM 实现：第一种使用安卓的数据绑定，第二种使用 RxJava。在使用数据绑定的 MVVM 模式中，状态直接放在 ViewModel（视图模型）中：

```
class PersonsViewModel {
  ObservableBoolean loading;
  // ……为了提高代码可读性，此处省略其他字段
  public void load(){

    loading.set(true);

    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
      loading.set(false);
      // ……其他类似人员名单的东西      
      }

      public void onError(Throwable error){
        loading.set(false);
        // ……其他类似错误信息的东西
      }
    });
  }
}
```

In MVVM with RxJava we don’t use the data binding engine but bind Observable to UI Widgets in the View, for example:
在使用 RxJava 的 MVVM 模式中，我们不使用数据绑定引擎，但是我们绑定 Observable 对象到视图里的 UI 部件上。

```
class RxPersonsViewModel {
  private PublishSubject<Boolean> loading;
  private PublishSubject<List<Person> persons;
  private PublishSubject loadPersonsCommand;

  public RxPersonsViewModel(){
    loadPersonsCommand.flatMap(ignored -> backend.loadPersons())
      .doOnSubscribe(ignored -> loading.onNext(true))
      .doOnTerminate(ignored -> loading.onNext(false))
      .subscribe(persons)
      // 也可能有其它不同的实现
  }

  // 在视图中订阅 (如 Activity / Fragment)
  public Observable<Boolean> loading(){
    return loading;
  }

  // 在视图中订阅 (如 Activity / Fragment)
  public Observable<List<Person>> persons(){
    return persons;
  }

  // 当这个行为被触发时（调用 onNext（）），我们加载人员名单
  public PublishSubject loadPersonsCommand(){
    return loadPersonsCommand;
  }
}
```

Of course these code snippets are not perfect and your implementation may look entirely different. The point is that usually in MVP and MVVM the state is driven by either the Presenter or the ViewModel.
当然，这些代码片段并不完美。你的实现也可能看起来完全不同。然而重点在于，在 MVP 和 MVVM 模式下，状态同时是由 Presenter（提供器）或是 ViewModel（视图模型）驱动。

This leads to the following observations:
我们由此可以发现：

1. The business logic has its own state, the Presenter (or ViewModel) has its own state (and you try to sync the state of business logic and Presenter so that both have the same state) and the View may also have its own state (i.e. you set the visibility somehow directly in the View, or Android itself restores the state from bundle during recreation).
1. 业务逻辑有自己的状态，Presenter（提供器）（或是 ViewModel（视图模型））有自己的状态（并且你尝试同步业务逻辑和 Presenter 两者间的状态，使他们一致），并且 View（视图）可能也有自己的状态（比如，你直接在视图中设置了可见性，或者安卓本身在重建时从绑定中恢复状态）。

2. A Presenter (or ViewModel) has arbitrarily many inputs (the View triggers an action handled by Presenter) which is ok, but a Presenter also has many outputs (or output channels like view.showLoading() or view.showError() in MVP or ViewModel is offering multiple Observables) which eventually leads to conflicting states of View, Presenter and business logic especially when working with multiple threads.
2. Presenter（提供器）（或是 ViewModel（视图模型））有很多任意的输入（View (视图）触发一个动作，由 Presenter（提供器）处理）是可以的，但同时，Presenter（提供器）也有很多输出（或者说在 MVP 中 view.showLoading() 或 view.showError() 的输出方式，以及 ViewModel（视图模型）提供的多种 Observable 对象）。这就会导致
当View（视图）, Presenter（提供器）和业务逻辑三者在不同线程工作时的状态冲突。

[![](https://i.ytimg.com/vi_webp/zCwESjEpNdk/maxresdefault.webp)](https://www.youtube.com/embed/zCwESjEpNdk)

In the best-case scenario, this only results in visual bugs such as displaying a loading indicator (“loading state”) and error indicator (“error state”) at the same time like this:
在最好的情况下，我们能直接看到代码缺陷，因为他们在加载显示器（“加载状态”）和错误显示器（“错误状态”）中同时显示了出来：

In the worst-case scenario, you have a serious bug reported to you from a crash reporting tool like Crashlytics, that you are not able to reproduce and therefore making it almost impossible to fix.
而在最坏的情况下，你会收到像 Crashlytics 这样的崩溃反馈工具的严重缺陷报告。并且你将无法重现它而很可能无法修复。

What if we only have one single source of truth for state passed from bottom (business logic) to the top (the View). Actually, we have already seen a similar concept at the very beginning of this blog post when we talked about “Model”.
但假如我们有且尽有一个，由下（业务逻辑饿）至上（视图）的可信状态来源呢？实际上，当在这篇博客的最初说到“Model（模型）”的时候，我们就已经看到了一个相似的概念。

```
class PersonsModel {
  // 在真实的应用中，属性是私有的
  // 并且会有 getter 方法去获取他们
  final boolean loading;
  final List<Person> persons;
  final Throwable error;

  public(boolean loading, List<Person> persons, Throwable error){
    this.loading = loading;
    this.persons = persons;
    this.error = error;
  }
}
```

Guess what? **Model reflects the State**. Once I have understood this, a lot of state related issues were solved (and prevented from the very beginning) and suddenly my Presenter has exactly one output: *getView().render(PersonsModel)*. This reflects a simple mathematical function like *f(x) = y* (also possible with multiple inputs i.e. f(a,b,c), exactly one output). Math might not be everyone’s cup of tea, but a mathematician doesn’t know what a bug is. Software Engineers do.
猜猜怎么着？**模型反应状态**。一旦我们理解了这个，我们就可以解决很多相关问题（同时也可以避免很多问题），并且，我的 Presenter（提供其）只有一个输出：**getView().render(PersonsModel)**。这个反应了一个简单的数学函数, **f(x) = y**（也可能是由多个输入的函数的如 f(a,b,c)，但只有一个输出）。可能不是每个人都喜欢数学，但是数学家不知道这样的代码缺陷在哪里，而软件工程师知道。

Understanding what a “Model” is and how to model it properly is important, because at the end a Model can solve the “State Problem”
理解“Model（模型）”并知道如何正确实现它是非常关键的，因为 Model（模型）最后可以解决“状态问题”。

## 2. Screen orientation changes ##
## 2. 屏幕方向的改变 ##

In Android screen orientation change is a challenging problem. The simplest way to deal with that is to ignore it. Just reload everything on each screen orientation change. This is a completely valid solution. Most of the time your app works offline too so that data comes from a local database or another local cache. Therefore, loading data is super-fast after screen orientation changes. However, I personally dislike seeing a loading indicator, even if it’s just for a few milliseconds, because in my opinion this is not a seamless user experience. So people (including myself) started to use MVP with “retaining presenter” so that a View can be detached (and destroyed) during screen orientation changes, whereas the Presenter survives in memory and then the View gets reattached to the Presenter.
The same concept is possible with MVVM with RxJava, but we have to keep in mind that once a View gets unsubscribed from his ViewModel the observable stream is destroyed. You could work around this with Subjects for example. In MVVM with data binding a ViewModel is directly bound to the View by the data binding engine himself. To avoid memory leaks we have to destroy the ViewModel on screen orientation changes.

But the problem with retaining Presenter (or ViewModel) is: how do we bring the View’s state back to the same state as it was before the screen orientation change, so that both, View and Presenter, are in the same state again? I have written a MVP library called [Mosby](https://github.com/sockeqwe/mosby) with a feature called ViewState which basically synchronizes the state of your business logic with the View. [Moxy](https://github.com/Arello-Mobile/Moxy), another MVP library, implemented a quite interesting solution by using “commands” to reproduce the View’s state after a screen orientation change:

![moxy](http://hannesdorfmann.com/images/mvi-mosby3/moxy.gif)

Image borrowed from https://github.com/Arello-Mobile/Moxy

I’m pretty sure that there are also other solutions for the View’s state problem out there. Let’s take a step back and summarize the issue those libraries try to solve: They try to solve the problem of state which we have already discussed.

So, again, having one “Model” which reflects the current “State” and exactly one method to “render” the “Model” solves this problem as easy as calling *getView().render(PersonsModel)* (with the latest Model when reattaching the View to Presenter).

## 3. Navigation on the back stack ##

Does a Presenter (or ViewModel) need to be kept when the View is not in use anymore? For instance, if the Fragment (View) has been replaced with another Fragment because the user has navigated to another screen, then there is no View attached to the Presenter. If no View is attached a Presenter obviously can’t update the View with the latest data from business logic. What if the user comes back (i.e. pressing the back button to pop the back stack)? Reload the data or reuse the existing Presenter? This is more a philosophical question.
Usually once the user comes back to a previous screen (pop back stack) he would expect to continue where he left off. This is basically the “restore View’s state problem” as discussed in 2. So the solution is straightforward: With a “Model” representing the state we just call *getView().render(PersonsModel)* to render the View when coming back from back stack.

## 4. Process death ##

I think it is a common misunderstanding in Android development that process death is a bad thing and that we need libraries that help us to restore state (and Presenters or ViewModels) after process death. First, a process death only ever happens for a good reason: the Android operating system needs more resources for other apps or to save battery. But this will never happen when your app is in the foreground and is being actively used by your app’s user. So be a good citizen and don’t fight against the platform. If you really have some long running work to do in the background use a *Service* as this is the only way to signal the operating system that your app is still “actively used”.
If a process death happens Android provides some callbacks like *onSaveInstanceState()* to save the state. Again, State. Should we save our View information into the Bundle? Does the Presenter have its own state we have to save into the bundle too? What about business logic state? We already had this dance: As described in 1. 2. and 3. we only need a Model class that is representing the whole state. Then it’s easy to save this Model into a bundle and to restore it afterwards.
However, I personally think that most of the time it is better to not save the state but rather reload the whole screen just like we are doing on first app start. Think of a NewsReader app displaying a list of news articles. When our app is killed and we save the state and 6 hours later the user reopens our app and the state is restored, our app may display outdated content. Maybe not storing the Model / State and simply reloading the data is better in this scenario.

## 5. Immutability and unidirectional data flow ##

I’m not going to talk about the advantage of immutability because there are a lot of [resources](https://www.quora.com/What-are-the-advantages-and-disadvantages-of-immutable-data-structures) available about this topic. We want an immutable “Model” (which is representing the state). Why? Because we want only one single source of truth. We don’t want that other components in our app can manipulate our Model / State as we pass the Model object around. Let’s imagine we are going to write a simple “counter” Android app that has an increment and decrement button and displays the current counter value in a TextView. If our Model (which in this case is just the counter value - an integer) is immutable, how do we change the counter? I’m glad you asked. We are not manipulating the TextView directly on each button click. Some observations: First, our View should just have a *view.render(…)*. Second, our model is immutable, so no direct change of Model is possible. Third, there is only one single source of truth: the business logic. We let click events “sink down” to the business logic. The business logic knows the current Model (i.e. has a private field with the current Model) and will create a new Model with the incremented / decremented value according to the old Model.

![Counter](http://hannesdorfmann.com/images/mvi-mosby3/counter.png)

By doing so we have established a unidirectional data flow with the business logic as single source of truth which creates immutable Model instances. But this seems so over engineered for just a simple counter, doesn’t it? Yes, a counter is just a simple app. Most apps start as a simple app but then the complexity grows fast. A unidirectional data flow and an immutable model is necessary from my point of view even for simple apps to ensure they stay simple (from developers point of view) when complexity grows.

## 6. Debuggable and reproducible states ##

Moreover, the unidirectional data flow ensures that our app is easy to debug. Wouldn’t it be nice next time we get a crash report from Crashlytics that we could reproduce and fix this crash easily because all required information is attached to that crash report. What is “the required information”? Well, all information we need is the current Model and the action the user wanted to perform when the crash happened (i.e. clicked decrement Button). That’s all we need to reproduce this crash and that information is super easy to log and to attach to a crash report. This would not be as easy without a unidirectional data flow (i.e. someone misuses an EventBus and fires CounterModels out into the wild) or without immutability (so that we are not sure who has actually changed the Model).

## 7. Testability ##

“Traditional” MVP or MVVM improves testability of an app. MVC is also testable: nobody ever said that we have to put all our business logic into the activity. With a Model representing State we can simplify our unit test’s code as we can simply check *assertEquals(expectedModel, model)*. This eliminates a lot of objects we otherwise have to mock. Additionally, this removes many verification tests that a certain method has been called i.e. *Mockito.verify(view, times(1)).showFoo()*. Eventually, this makes our unit test’s code more readable, understandable and finally maintainable as we don’t have to deal that much with implementation details of our real code.

# Conclusion #

In this first part of this blog post series we talked a lot about theoretical stuff. Do we really need a dedicated blog post about Model? I think it is elementary to understand that a Model is important and helps to prevent some issues we otherwise would struggle with. Model doesn’t mean business logic. It’s the business logic (i.e. an Interactor, a Usecase, a Repositor or whatever you call it in your app) that produces a Model. In the second part we will see this theoretical Model stuff in action when we finally build a reactive app with Model-View-Intent. The demo app we are going to build is a app for a fictional online shop. Here is just a short preview demo of what you can expect in part two. Stay tuned.

[![](https://i.ytimg.com/vi_webp/rmR9mV1Dsqk/maxresdefault.webp)](https://www.youtube.com/embed/rmR9mV1Dsqk)
