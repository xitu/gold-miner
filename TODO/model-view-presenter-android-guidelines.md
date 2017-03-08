> * 原文地址：[Model-View-Presenter: Android guidelines](https://medium.com/@cervonefrancesco/model-view-presenter-android-guidelines-94970b430ddf#.e55fepeg1)
* 原文作者：[Francesco Cervone](https://medium.com/@cervonefrancesco?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Model-View-Presenter: Android guidelines #

There are plenty of articles and examples about the MVP architecture and there are a lot of different implementations. There is a constant effort by the developer community to adapt this pattern to Android in the best way possible.

If you decide to adopt this pattern, you are making an architectural choice and you must know that your codebase will change, as well as your way to approach new features (for the better). You must also know that you need to face with common Android problems like the Activity lifecycle and you may ask yourself questions like:

- *should I save the state of the presenter?*
- *should I persist the presenter?*
- *should presenter have a lifecycle?*

In this article, I’m going to put down a list of ***guidelines or best practices*** to follow in order to:

- **solve the most common problems** (or at least those ones I’ve had in my personal experience) using this pattern
- **maximize the benefits** of this pattern

First of all, let’s describe the players:

![](https://cdn-images-1.medium.com/max/800/1*3JERTTFmC35Rhx-C0uvECA.png)

Model-View-Presenter

- **Model**: it is an interface **responsible for managing data**. Model’s responsibilities include using APIs, caching data, managing databases and so on. The model can also be an interface that communicates with other modules in charge of these responsibilities. For example, if you are using the [Repository pattern](https://martinfowler.com/eaaCatalog/repository.html)  the model could be a Repository. If you are using the [Clean architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) , instead, the Model could be an Interactor.
- **Presenter**: the presenter is the middle-man between model and view. All your business logic belongs to it. The presenter is responsible for **querying the model and updating the view**, **reacting to user interactions updating the model**.
- **View**: it is only responsible for **presenting data in a way decided by the presenter**. The view can be implemented by Activities, Fragments, any Android widget or anything that can do operations like showing a ProgressBar, updating a TextView, populating a RecyclerView and so on.

The following are guidelines from my personal point of view and you might not like them, then I will try to explain why these principles seem reasonable to me.

### 1. Make View dumb and passive ###

One of the biggest problems of Android is that views (Activities, Fragments,…) aren’t easy to test because of the framework complexity. To solve this problem, you should implement the [**Passive View**](https://martinfowler.com/eaaDev/PassiveScreen.html) pattern.The implementation of this pattern reduces the behavior of the view to the absolute minimum by using a controller, in our case, the presenter. This choice dramatically improves testability.

For example, if you have a username/password form and a “submit” button, you don’t write the validation logic inside the view but inside the presenter. Your view should just collect the username and password and send them to the presenter.

### 2. Make presenter framework-independent ###

In order to make the previous principle really effective (improving testability), **make sure that presenter doesn’t depend on Android classes**. Write the presenter using just Java dependencies for two reasons: firstly you are abstracting presenter from implementation details (Android framework) and consequently, you can write *non-instrumented* tests for the presenter (even without [Robolectric](http://robolectric.org/)), running tests faster on your local JVM and without an emulator.

> What if I need the Context?

Well, get rid of it. In cases like this, you should ask yourself *why* you need the context. You may need the context to access shared preferences or resources, for example. But you shouldn’t do that in the presenter: you should access to resources in the view and to preferences in the model. These are just two simple examples, but I can bet that the most of the times it is just a problem of wrong responsibilities.

By the way, the **dependency inversion principle** helps a lot in cases like this, when you need to decouple an object.

### 3. Write a contract to describe the interaction between View and Presenter ###

When you are going to write a new feature, it is a good practice to write a contract at first step. The **contract describes the communication between view and presenter,** it helps you to design in a cleaner way the interaction.

I like to use the solution proposed by Google in the [Android Architecture](https://github.com/googlesamples/android-architecture)  repository: it consists of an interface with two inner interfaces, one for the view and one for the presenter.

Let’s make an example.

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

An MVP contract to search and show GitHub repositories

Just reading the method names, you should be able to understand the use case I’m describing with this contract.

If you can’t, I failed miserably.

As you can see from the example, view methods are so simple that suggest there isn’t any logic except presentation.

#### The View contract ####

Like I said before, the view is implemented by an Activity (or a Fragment). **The presenter must depend on the View interface and not directly on the Activity**: in this way, you decouple the presenter from the view implementation (and then from the Android platform) respecting the D of the SOLID principles: “*Depend upon Abstractions. Do not depend upon concretions*”.

We can replace the concrete view without changing a line of code of the presenter. Furthermore, we can easily unit-test presenter by creating a mock view.

#### The presenter contract ####

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
