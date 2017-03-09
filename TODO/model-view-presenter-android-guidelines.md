> * 原文地址：[Model-View-Presenter: Android guidelines](https://medium.com/@cervonefrancesco/model-view-presenter-android-guidelines-94970b430ddf#.e55fepeg1)
* 原文作者：[Francesco Cervone](https://medium.com/@cervonefrancesco?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[tanglie1993](https://github.com/tanglie1993)
* 校对者：

# Model-View-Presenter: Android 指南 #

目前已经有了很多关于 MVP 架构的文章和例子，也有很多不同的实现。开发者们一直试图把这个模式以最合适的方式适配到 Android 平台上。

如果你决定采用这种模式，你就做了一个架构选择，而且你必须知道你的代码库，以及实现新特性的方式会因此改变（变得更好）。你也必须知道，你需要面对像 Activity 生命周期之类的常见 Android 问题，而且你可能问自己这些问题：

- *我是否应该保存 presenter 的状态？*
- *我是否应该持久化 presenter？*
- *presenter 是否应该有生命周期？*

在本文中，我将我将写下一个**指南和最佳实践**的清单。它是用来：

- 用这种模式**解决最常见的问题** （至少是我个人经验中最常见的问题）
- **最大化此模式的优势**

首先，让我描述一下参与者：

![](https://cdn-images-1.medium.com/max/800/1*3JERTTFmC35Rhx-C0uvECA.png)

Model-View-Presenter

- **Model**: 它是**负责管理数据**的接口。Model 的职责包括使用 API，缓存数据，管理数据库等等。Model 也可以是一个和其它模块交流并负责这些功能的接口。例如，如果你在使用  [Repository 模式](https://martinfowler.com/eaaCatalog/repository.html)，model 可以是一个 Repository。如果你在使用  [Clean architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)，Model 可以是一个 Interactor。
- **Presenter**: presenter 是 model 和 view 之间的中间人。你所有的业务逻辑都属于它。Presenter 负责**查询 model 并更新 view**，**响应用户交互并更新 model**。
- **View**: 它只负责**以 presenter 决定的方式展示数据**。View 可以通过 Activities，Fragments，任何 Android widget 或者任何能展示 ProgressBar，更新 TextView，填充 RecyclerView 等的东西实现。

下面的内容是我根据个人观点提出的指南。你可能不喜欢它们，但接下去我会解释为什么这些原则在我看来是合理的。

### 1. 使 View 变得沉默和被动 ###

Android 最大的问题之一是 views (Activities, Fragments,…) 由于框架的复杂性而不容易测试。要解决这个问题，你应该实现**被动 View**(https://martinfowler.com/eaaDev/PassiveScreen.html) 模式。这个模式的实现通过使用 controller （在我们的例子中是 presenter）把 view 的行为减到最少。这个选择把可测试性提高了很多。

比如，如果你有一个用户名/密码表格和一个“提交”按钮，把验证逻辑写在 presenter 而不是 view 中。你的 view 应该只收集用户名和密码，并把它发送给 presenter。

### 2. 使 presenter 不依赖于框架 ###

为了把前一条原则变得真正有效（提升可测试性），**确保 presenter 不依赖于 Android 类**。有两个理由支持只用 Java 依赖写 presenter：首先，你把 presenter 从 实现细节 （Android framework）中抽象出来，因此你可以给 presenter 写**不依赖于 instrument** 的测试（甚至不需要 Robolectric(http://robolectric.org/)），把测试不借助模拟器运行在本地 JVM 上会更快。

> 如果我需要 Context 怎么办？

避免它。在这种情况下，你应该问自己 **为什么** 你需要 context。比如，你可能需要通过它访问 shared preferences 或资源。但你不应该在 presenter 中做这些事：你应该在 view 中访问资源，在 model 中访问 preferences。这些只是两个简单的例子，但我可以打赌，大多数时候这只是错误的职责带来的问题。

顺便一提，**依赖倒置原则**在这种情况下很有帮助，如果你需要解耦一个对象的话。

### 3. 写一个描述 View 和 Presenter 之间交互的合约 ###

如果你打算写一个新的 feature，首先写一个合约是一个好的做法。**合约描述 view 和 presenter 之间的交互**，它帮助你以更清晰的方式设计交互。

我喜欢使用 Google 在 [Android Architecture](https://github.com/googlesamples/android-architecture) repository 中提出的解决方案： 它包括一个包含两个内部接口的接口，其中一个用于 view，另一个用于 presenter。

举个例子。

```
public interface SearchRepositoriesContract {
  interface View {
    void addResults(List<Repository> repos);
    void clearResults();
    void showContentLoading();
    void hideContentLoading();
    void showListLoading();
    void hideListLoading();
    void showContentError();
    void hideContentError();
    void showListError();
    void showEmptyResultsView();
    void hideEmptyResultsView();
  }
  interface Presenter extends BasePresenter<View> {
    void load();
    void loadMore();
    void queryChanged(String query);
    void repositoryClick(Repository repo);
  }
}
```

一个用于搜索和显示 Github repositories 的合约

只要阅读方法名，你就应该可以理解我用这个合约描述的用例。

如果你不能，我就很可悲地失败了。

就像你在例子中看到的那样，view 方法如此简单，说明它除了展示以外没有任何逻辑。

#### View 合约 ####

就像我曾说过的，这个 view 是被一个 Activity（或Fragment） 实现的。**Presenter 必须依赖 View 接口，而不直接依赖 Activity**：这样，你就把 presenter 和 view 的具体实现（从而和 Android 平台）解耦了。这体现了 SOLID 原则中的 D：**依赖于抽象而非具体**。

我们可以不改动 presenter 中的任何代码而改变具体的 view。而且，我们可以轻易地用 mock view 对 presenter 做单元测试。

#### Presenter 合约 ####

> Wait. Do we really need a Presenter interface?

[Actually **no**](http://blog.karumi.com/interfaces-for-presenters-in-mvp-are-a-waste-of-time/), but I would say **yes**.

There are two different schools of thought about this topic.

Some people think you should write the Presenter interface because you are decoupling the concrete view from the concrete presenter.

However, some developers think you are abstracting something that is already an abstraction (of the view) and you don’t need to write an interface. Moreover, you will likely never write an alternative presenter, then it would be a waste of time and lines of code.

Anyway, having an interface could help you to write a mock presenter, but if you use tools like [Mockito](http://site.mockito.org/)  you don’t need any interface.

Personally, **I prefer to write the Presenter interface** for two simple reasons (besides those I listed before):

- **I’m not writing an interface for the presenter. I’m writing a Contract that describes the interactions between View and Presenter**. And having the rules of both “contractual parties” in the same file sounds very clean to me.
- **It isn’t a real effort**.

It’s been a year, more or less, that I write Contracts like this and I’ve never seen this as a problem.

### 4. Define a naming convention to separate responsibilities ###

The presenter may generally have two categories of methods:

- **Actions** (`load()` for example): they describes what the presenter does
- **User events** (`queryChanged(...)` for example): they are actions triggered by the user like “*typing in a search view*” or “*clicking on a list item*”.

More actions you have, more logic will be inside the view. User events, instead, suggest that they leave to the presenter the decision of what to do. For instance, a search can be launched only when at least a fixed number of characters are typed by the user. In this case, the view just calls the `queryChanged(...)` method and the presenter will decide when to launch a new search applying this logic.

`loadMore()` method, instead, is called when a user scrolls to the end of the list, then presenter loads another page of results. This choice means that when a user scrolls to the end, view knows that a new page has to be loaded. To “reverse” this logic, I could have named the method `onScrolledToEnd()` letting concrete presenter decide what to do.

What I’m saying is that during the “contract design” phase, **you must decide for each user event, what is the corresponding action and who the logic should belong to.**

### 5. Do not create Activity-lifecycle-style callbacks in the Presenter interface ###

With this title I mean the presenter shouldn’t have methods like `onCreate(...)`, `onStart()`, `onResume()` and their dual methods for several reasons:

- In this way, the **presenter would be coupled in particular with the Activity lifecycle**. What if I want to replace the Activity with a Fragment? When should I call the `presenter.onCreate(state)` method? In fragment’s `onCreate(...)`, `onCreateView(...)`or `onViewCreated(...)`? What if I’m using a custom view?
- **The presenter shouldn’t have a so complex lifecycle**. The fact that the main Android components are designed in this way, doesn’t mean that you have to reflect this behavior everywhere. If you have the chance to simplify, just do it.

Instead of calling a method of the same name, **in an Activity lifecycle callback, you can call a presenter’s action**. For example, you could call `load()` at the end of `Activity.onCreate(...)`.

### 6. Presenter has a 1-to-1 relation with the view ###

The presenter doesn’t make sense without a view. It comes with the view and goes when the view is destroyed. It manages one view at a time.

You can handle the view dependency in the presenter in multiple ways. One solution is to provide some methods like `attach(View view)` and `detach()` in the presenter interface, like the example shown before. The problem of this implementation is that the view is *nullable*, then you have to add a null-check every time presenter needs it. This could be a bit boring…

I said that there is a 1-to-1 relation between view and presenter. We can take advantage of this. **The concrete presenter, indeed, can take the view instance as a constructor parameter**. By the way, you may need anyway a method to subscribe presenter to some events. So, I recommend to define a method `start()` (or something similar) to run presenter’s business.

> What about `detach()`?

If you have a method `start()`, you may need at least a method to release dependencies. Since we called the method that lets presenter subscribe some events `start()`, I’d call this one `stop()`.

```
public interface BasePresenter<V> {
  void attach(V view);
  void detach();
}

public interface BasePresesnter {
  void start();
  void stop();
}

```

### 7. Do not save the state inside the presenter ###

I mean using a `Bundle`. You can’t do this if you want to respect the point 2. You can’t serialize data into a `Bundle` because presenter would be coupled with an Android class.

I’m not saying that the presenter should be stateless because I’d be lying. In the use case I described before, for instance, the presenter should at least have the page number/offset somewhere.

> So, you must retain the presenter, right?

### 8. No. Do not retain the presenter ###

I don’t like this solution mainly because I think that presenter is not something we should persist, it is not a data class, to be clear.

Some proposals provide a way to retain presenter during configuration changes using retained fragments or [Loaders](https://medium.com/@czyrux/presenter-surviving-orientation-changes-with-loaders-6da6d86ffbbf#.ii7px6adf) . Apart from personal considerations, I don’t think that this is the best solution. With this trick, the presenter survives to orientation changes, but when Android kills the process and destroys the Activity, the latter will be recreated together with a new presenter. For this reason, **this solution solves only half of the problem**.

> So…?

### 9. Provide a cache for the Model to restore the View state ###

In my opinion, solving the *“restore state”* problem requires adapting a bit the app architecture. A great solution in line with this thoughts was proposed in [this article](https://medium.com/@theMikhail/presenters-are-not-for-persisting-f537a2cc7962#.ssl022wg7) . Basically, the author suggests **caching network results** using an interface like a Repository or anything with the aim to manage data, scoped to the application and not to the Activity (so that it can survive to orientation changes).

This interface is just a smarter **Model**. The latter should provide at least a disk-cache strategy and possibly an in-memory cache. Therefore, even if the process is destroyed, the presenter can restore the view state using the disk cache.

The view should concern only about any necessary request parameters to restore the state. For instance, in our example, we just need to save the query.

Now, you have two choices:

- **You abstract this behavior in the model layer** so that when presenter calls `repository.get(params)`, if the page is already in cache, the data source just returns it, otherwise the APIs are called
- **You manage this inside the presenter** adding just another method in the contract to restore the view state. `restore(params)`, `loadFromCache(params)` or `reload(params)` are different names that describe the same action, you choose.

### Conclusions ###

I think we are done. That’s it. This is my knowledge about Model-View-Presenter applied to Android. I tried to learn from my mistakes, others’ and my experiences. I’ve been constantly finding the best approach.

I hope you liked this article. If you have any feedback, feel free to comment below: I would be very happy to get suggestions and to see any different solution.
