> * 原文地址：[MVC/MVP/MVVM/CLEAN/VIPER/REDUX/MVI/PRNSAASPFRUICC — building abstractions for the sake of building abstractions (and because they’re pretty and popular)](https://proandroiddev.com/mvc-mvp-mvvm-clean-viper-redux-mvi-prnsaaspfruicc-building-abstractions-for-the-sake-of-building-18459ab89386)
> * 原文作者：[Gabor Varadi](https://proandroiddev.com/@Zhuinden?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mvc-mvp-mvvm-clean-viper-redux-mvi-prnsaaspfruicc-building-abstractions-for-the-sake-of-building.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mvc-mvp-mvvm-clean-viper-redux-mvi-prnsaaspfruicc-building-abstractions-for-the-sake-of-building.md)
> * 译者：
> * 校对者：

# MVC/MVP/MVVM/CLEAN/VIPER/REDUX/MVI/PRNSAASPFRUICC — building abstractions for the sake of building abstractions (and because they’re pretty and popular)

![](https://cdn-images-1.medium.com/max/2000/1*WyNyQHxQZyB9V5azQDCiNQ.png)

This might be the most controversial post I’ve ever written up to this point.

> **_TL;DR and take-away:_** If you support offline data storage, then:
> - observe your data layer via either Room’s LiveData support/SQLBrite/etc — what matters is that it can be observed for changes
> - if you do cache the data across config changes (ViewModel), then store the data in something that can be observed for changes (BehaviorSubject or LiveData). Refer to [Google’s “Guide to App Architecture”](https://developer.android.com/topic/libraries/architecture/guide.html), the ideas in there are useful.
> Always make sure you persist [presenter state via onSaveInstanceState()](https://stackoverflow.com/questions/49773172/how-to-restore-the-application-state-when-using-dagger2-mvp). Activity is a process entry point, not just “a view”.
> Also, I don’t like Redux, and neither of its variants, at all. Really. There is a very long section dedicated to why I don’t like Redux.
> Overall, I think if you want to use some presentation layer pattern, use MVVM instead for now, or come up with something better (that doesn’t bind a screen to its abstraction). Until then, follow [the Architecture Components guide](https://developer.android.com/topic/libraries/architecture/guide.html). Check out [the codelabs](https://codelabs.developers.google.com/codelabs/android-room-with-a-view/#0).
> Compared to Redux, the AAC MVVM is much cleaner, leaner, easier to wrap your head around, and has much less hidden cost involved, and doesn’t make trivial everyday tasks difficult.

---

People _love_ application architecture patterns.

It’s true! Otherwise we wouldn’t have so many of them.

Although even the term `application architecture pattern` in this case is a bit of a misnomer, considering that most of these patterns in the title apply only to presentation layer, and that’s only one layer of the application.

Sometimes (and honestly, me included) we build up samples that follow one of these patterns for the sake of following the pattern, look at it and say, “my, this is pretty!”

Extra negative points if the sample has no unit tests —[ also something I tend to be an offender of, myself](https://github.com/Zhuinden/xkcd-example/blob/b1f20ed680ce5c1c36b17a3f9aae0594530d997d/app/src/test/java/com/zhuinden/xkcdexample/ExampleUnitTest.java#L16).

Maybe this is my personal assumption, but a lot of us are influenced by the description of [**_a Clean Architecture_** with Strictly Enforced Separate Layers, as we’ve read **the article by Fernando Cejas** on how to build such a layered application and what rules it must obey](https://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/).

In fact, we even read the next article that says we should [implement each use-case as an RxJava observable transformer](https://fernandocejas.com/2015/07/18/architecting-android-the-evolution/). Sure, why not? It makes sense.

And once we have the `abstract class UseCase` in place, we could [even send arguments to them with a](https://fernandocejas.com/2016/12/24/clean-architecture-dynamic-parameters-in-use-cases/) `[Params](https://fernandocejas.com/2016/12/24/clean-architecture-dynamic-parameters-in-use-cases/)` [object that is basically a Bundle](https://fernandocejas.com/2016/12/24/clean-architecture-dynamic-parameters-in-use-cases/)!

Okay, people actually generally didn’t take _that_ one to heart.

#### Enough foreword, what’s the goal here?

There’s one very important thing to keep in mind regarding these presentation layer “architectures”.

They were created to enforce separation, in order to introduce **_indirection_** (create a new “seam”), so that UI behavior can become  **_unit testable_**.

If we flip that around, we _don’t_ _actually need_ that **indirection** _if_ we _don’t_ **unit test** _the UI logic_.

---

I can hear alarms going off already, so I’ll take note that doing your best to adhere to SOLID principles — especially the **D**ependency Inversion Principle — is typically a good idea.

Naturally emerging patterns, such as providing dependencies to constructors, introducing DI if the object graph is sufficiently complex — all of that is useful.

---

However, introduction of “artificially” emerging patterns might lead us to the wrong abstraction. Each architecture comes with a price, and it comes with even more cost if the architecture is done wrong. And let’s not forget about possible hidden costs that are a result of hidden complexity and learning curves.

> _By nature, the default “gain” of these patterns would be unit testability by levels of indirection. If we don’t unit test, then we’re building these to make things “pretty”. But what is the cost? What is the trade off? What is the problem we are aiming to solve by introducing indirection? What is the indirection we introduce in the first place?_

### Overview of aforementioned popular patterns

#### MVC: Model View Controller

The key points of MVC is:

*   The user’s interactions _call methods_ on the Controller
*   The Controller updates the Model (where the model is what actually stores state)
*   The Model _exposes change listeners to notify observers_ that it has changed
*   The View _subscribes for changes emitted by the model_ to update itself

The thing that people tend to call “MVC” or “massive view-controller” has nothing to do with real MVC. No, the layout XML is not a “View”.

The Model should have the ability to emit change events, and the View should be subscribed to it.

I haven’t seen many if any MVC samples for Android, except [in this discussion.](https://www.reddit.com/r/androiddev/comments/80remi/im_studying_android_and_trying_to_understand/duzgvey/?context=1000) So I can’t accurately judge it, as I haven’t really seen it in action! :)

#### MVP: Model View Presenter

The key points of MVP is:

*   The user’s interactions _call methods_ on the Presenter
*   The Presenter stores state, manages state, and _calls methods on the view_ to notify it to update itself
*   The Model is just data
*   The View _receives method calls from the presenter_ to be notified of changes to update itself

The supposed benefit of MVP is that there is a well-defined contract between Presenter and View, and it can be verified that “under the right circumstances, the Presenter calls the right methods on the View”.

Some hidden costs:

*   the Presenter is typically bound to a single View, so argument passing between Presenters and hierarchic relations of the Views themselves can introduce difficulty: maintaining the existence of and communication between child presenters and sibling presenters (if they exist) is tricky. This can be avoided if the Presenter is shared between Views of the same flow.

The downside is that:

*   the Presenter stores the state, so we must be able to persist/restore the presenter state when the process is re-created (which is typically Android-specific — and sometimes ignored!)
*   the View is updated via callbacks, which is more manual work than listening for changes
*   if the Presenter can survive configuration changes, then it is possible for the View to be detached when Presenter receives asynchronous results, and **there is a chance that method calls to the View can be dropped** ( `if(view != null) {` anyone?)

To eliminate the ability to drop events, we must be able to enqueue these events until the View resubscribes, deferring their execution. But if we’re emitting events and listening to them, then it’s not really a Presenter anymore, is it? :)

#### VIPER: View Interactor Presenter Entity Routing

This is actually just an additional twist on top of MVP, namely that they have a `Router` interface defined for handling navigation.

iOS variant also had a “Wireframe”, but that’s essentially dependency injection.

Any limitations that the `Presenter` had in MVP still applies.

#### MVVM: Model View ViewModel

The key points of MVVM is:

*   The user’s interactions _call methods_ on the ViewModel
*   The ViewModel stores state, manages state, and _exposes change events_ when the state changes
*   The Model is the data mapped into the observable fields (or any other form of event emission)
*   The View _subscribes for change events exposed by the viewmodel_ to update itself

The supposed benefit is that View can be “dumb” as all it does is display what’s in the ViewModel, and then what is in the ViewModel can be verified to have “the right values under the right conditions”.

The downside is:

*   All state must be moved to the ViewModel (and be somewhat “duplicated”, which is why ViewModel and View must be kept in sync — this is what databinding frameworks help with)
*   the ViewModel stores the state, so we must be able to persist/restore the ViewModel state when the process is re-created (which is typically Android-specific)
*   Method calls to View are replaced with event emission, so some form of the Observer pattern needs to be implemented — typically combination of PublishSubject/BehaviorSubject, but people try to hack LiveData to work like a PublishSubject and it doesn’t

In this case, the learning curve is the possible overhead, and there aren’t real inherent problems/limitations with the actual _idea_ behind it (other than that it binds a ViewModel to a single view, similarly to MVP). Go MVVM!

#### CLEAN: Clean Architecture

This is actually the odd-one-out on the list, as it’s actually an architecture. Namely [“Data-Domain-Presentation Layering”](https://martinfowler.com/bliki/PresentationDomainDataLayering.html) (or [Hexagonal Architecture](http://java-design-patterns.com/patterns/hexagonal/)). So you _can_ have “clean architecture” while following MVVM in the presentation layer, for example.

The key points of CLEAN Architecture is:

*   Strict separation of “data retrieval”, actual “business logic” + application state management, and “displaying state”
*   All specific implementation used (f.ex. image loading, database access) are hidden under interfaces that don’t leak implementation details: isolation of dependencies

The supposed benefit is that you can plug out any module at any time and replace it with another one. Also, data/domain modules can theoretically be shared between different versions of the same app (think phone vs TV).  
Also, having layer-specific objects means the mapping between them can be tested.

The downside is:

*   If you don’t need to share modules with multiple projects, enforcing the separation is overhead: as you need layer-specific objects and mapping inbetween
*   Did I mention the mapping between objects defined in 3 different layers? That’s _a lot_ of boilerplate code.
*   Navigation should be a domain-layer responsibility, but it is a common problem that people _abuse_ Activities and make navigation state implicitly part of the task stack. If we wanted to have complete control over our application state, we’d have only 1 Activity that displays the current state. This is often ignored, leaving the “clean” implementation unclean.
*   Hiding certain things under interfaces can be hard, often people still leak details, or their abstraction does not properly handle how their library of choice actually works (for example, SQLite vs Realm — singleton global instance vs thread-local ref-counted instances).

Personally, I advise keeping API responses and the database’s objects separate. That’s one mapping that’s typically worth introducing: the server response shouldn’t accidentally define what data we’re trying to store, and in what format.

The idea is good, but sometimes [you just aren’t gonna need it](https://martinfowler.com/bliki/Yagni.html).

But also be aware that sometimes you do.

#### REDUX: well, just Redux, although it should be called ActionCreator-Action-Dispatcher-Middleware-Reducer-Store-Middleware-View

Redux is one of the newest “architectures” that came to light, a take on the original [Flux pattern](https://github.com/facebook/flux/) which had a Store per View (“component”).

**_Flux_**, in a nutshell:

*   Actions: the object that encapsulates an action, basically _the View emitting an event_ instead of calling a method on a presenter/viewmodel
*   Dispatcher: an event queue (where actions are placed), it is similar to the contract that allowed the View to call methods on the presenter/viewmodel
*   Store: stores state and emits change events (basically the viewmodel), and also subscribes for actions in the dispatcher
*   View: observes state changes emitted by the store

So Flux was basically MVVM with event emission from the View to the ViewModel (now Store) via the Dispatcher (an event queue).

---

**_Redux_** “improves” upon the original design by creating a single global singleton Store that stores the state for every single view that exists in the application, and the state of the application, including navigation state and everything else, currently loaded data, whether data is currently being loaded, or if you should show a loading indicator in some segment of the app. Everything in one big object.

In Redux, this state is modified by `Reducer`s that modify bits and pieces of the global app state — but not in place: a new object is created with the changes applied. Generally, it has the signature of `(State, Action) -> State`, and can be modelled with the `scan()` operator.

The supposed benefits are that:

*   the State is immutable, and each change made to it creates a new State, so if we keep a history of Actions and States, we have a snapshot of _everything_ in the app — and if something goes wrong, we can “see what goes wrong” (time-travel debugging)
*   each action emitted by the View is deferred to allow enqueueing them: the processing of each actions is forced to be serial execution (a necessary requirement to always have the latest state in the reducer, and to always provide the latest state for the subscribers of the store)
*   it attempts to mimic certain functional programming aspects and other languages like [Elm](https://guide.elm-lang.org/architecture/) so it’s probably great

Considering most available samples involving Redux aren’t more complex than a Todo application that has no network calls, no state persistence, and otherwise no asynchronous operations in general, it might be tempting to start using it — especially if you’ve seen [time-travel debugging (of _Todo_ apps) in live action](https://www.youtube.com/watch?v=xsSnOQynTHs).

But there are plenty of downsides, especially if attempting to use Redux in the context of Android:

*   Common implementations of Redux _bundle together application state and currently loaded data,_ **making it impossible to save the application state to Bundle in** `**onSaveInstanceState()**` **, which can result in cryptic bugs.**
*   Loading data both from local or remote data source is hard, because it must be implemented as a Middleware (as it is a “side-effect”, asynchronous operation) to ensure that action execution order is correct ~ and the explanation of middlewares is that “you get to _curry_ the function so that you can for example add a logger that prints text”.
*   Any form of asynchronous action requires the introduction of magical elements such as `redux-thunk`, which introduces additional learning curve.
*   Execution of one-off operations (like “showing a toast”) is hard, because you only get to observe “current state”, meaning an action must _somehow_ emit a state for “START_SHOWING_TOAST” and “STOP_SHOWING_TOAST” to have the effect akin to calling `view.showToast()`, or `showToastEvent.call()`.
*   The single Store contains all app state, therefore the resulting state can easily be a large tree with lots of data, where we must ensure that each view has its own unique ID so that they don’t accidentally overwrite each other’s states. Each view must know how to access the sub-state intended just for them.
*   We must also ensure that each element in the State is immutable, including lists/collections (Kotlin helps).
*   Creating a new immutable copy of the state is only useful if you actually retain the previous values as “history”, otherwise mutation in place + notifying observers is a much simpler (and less costly) mechanism.

**_So Redux disadvantages on Android in short:_**

*   all actions are serialized, and inevitably delayed by waiting for middlewares to execute asynchronous operations — creating laggy UX
*   despite trying to make state management easier, it just makes state management more difficult
*   it makes asynchronous operations and simple one-off operations _much_ harder
*   if that is not yet evident, SUPER HIGH LEARNING CURVE if you want to make ANYTHING more complex than a simple Todo app
*   bundling together data and transient state in a single “immutable object” makes proper Android state persistence _very hard or_ **_impossible_**

Overall, what Redux tries to do is abstract away method calls from the View to the Presenter/ViewModel, by creating an object that is passed onto a queue (like Flux) — replace method calls with event emission.

Then merge all Presenters together to store their state in one place, and create copies of the state each time it is changed in any way.

The supposed benefit of course would be the easy testability of the Reducer. But you generally require some form of framework to get a reliable “immutable event loop” for your state.

If you ask me, there is so much “to draw of the rest of the fucking owl”, that I’d argue that **Redux is not production ready** out of the box, and takes a lot of punching to get into a shape that can properly model real-world requirements.

#### MVI: Model-View-Intent

MVI is pretty much the same thing as Flux (multiple stores, view emits actions), with some aspects of Redux (immutable state copies and state reducers), implemented on top of RxJava.

The key points:

*   Intentions: same as Actions in Flux — event emission from the View. The “dispatcher” is the Observable that results from merging the actions together into a single stream.
*   Model: the view state that is immutable and copied each time it is changed
*   Reducers: same as in Redux — evaluates the new value of the current State based on the current method call

Downside:

*   Every method call is replaced with a sealed data class and event streams modelled by Observables, so every action is implemented via RxJava operators. This can result in high learning curve and hard to reason about.

Of course, we also still have the disadvantage mentioned along with Redux:

*   Common implementations bundle data and state together, making persistence to Bundle difficult/impossible.

If we read the page regarding MVI, we see the following:

> FROM THE ARTICLE **“REACTIVE APPS WITH MODEL-VIEW-INTENT — PART1 — MODEL”:**

> However, I personally think that most of the time it is better to not save the state but rather reload the whole screen just like we are doing on first app start. Think of a NewsReader app displaying a list of news articles. When our app is killed and we save the state and 6 hours later the user reopens our app and the state is restored, our app may display outdated content. Maybe not storing the Model / State and simply reloading the data is better in this scenario.

Which is crazy, because I can induce a process death for whatever app I have open just by opening Skype and/or the Camera, and I’m sure that starting up the camera takes less time than 6 hours — and I have a Nexus 5X with 2.5 GB RAM.

Ignoring [the Activity contract](https://plus.google.com/+DianneHackborn/posts/FXCCYxepsDU) is a suboptimal solution, especially if we are trying to improve maintainability and reliability, instead of just introducing bugs and user frustration.

If you see a ViewState class and it doesn’t have `@Parcelize` annotation on it, then it’s probably not a production-ready implementation.

Always [test your application against process death to know what happens in case of low memory condition](https://stackoverflow.com/questions/49046773/singleton-object-becomes-null-after-app-is-resumed/49107399#49107399).

_For more information on this architecture, check out_ [_the comment chain below_](https://medium.com/@chessmani/you-really-dont-need-to-understand-that-much-and-there-really-no-need-for-all-those-functional-4c50f6c495ac)_._

#### PRNSAASPFRUICC: Production-Ready Native Single-Atom-State Purely Functional Reactive Composable UI Components

Honestly I just added this to the list for the shock value of the abbreviation.

But you can check out the [original proposition](https://gist.github.com/bkase/dbfc79353ed67a27a822) and the [accompanying library: cyklic](https://github.com/bkase/cyklic) (fairly unmaintained), it’s also yet another take on emitting events from the view, running them through a reducer (this time called a “Driver”) and it has a `start/stop` method. Overall, it is MVI-ish.

#### Honorable mention: RIBs (Router Interactor Builder)

While I have not used [RIBs](https://github.com/uber/RIBs), supposedly Uber has solved the problem of automatic constructor and tear-down of [deep scope hierarchies](https://eng.uber.com/deep-scope-hierarchies/), and provide proper events (via RxJava) to let you know when that happens.

This is mentioned as a presentation layer architecture pattern because they make it possible that the scope hierarchy contains the state, while views are just a display of the current state.

To make this happen, they use a single-activity architecture, so that the scope tree provides the navigation information for “what view should be showing” as well. With that, they actually solve “the current view determines the current Presenter/ViewModel instead of the other way around” problem.

#### Honorable mention: Reactive Workflows

There used to be no open-source example of Reactive Workflows, but it is [what Square swapped out their original Mortar-like ViewPresenters of MVP with](https://www.youtube.com/watch?v=mvBVkU2mCF4).

I’ve since then been informed that someone named Blake Oliveira has attempted to re-create a part of this architecture in [this repository](https://github.com/blakelee/ReactiveWorkflows).

The gist of it is that one “workflow” can be shared across multiple screens, and the “workflow” contains a state machine to describe the current state (somewhat reducer-y in this regard).

Most importantly, the Workflow defines a contract for what Events it can emit, and the view subscribes to them.

And workflows can be chained together, but I’m not sure about that part :)

To make the workflows manage the application state independently of the presentation layer, they use a single-activity architecture.

### The current recommendation: Google’s Android Architecture Components — LiveData (and ViewModel)

Google came out with [Architecture Components for Android](https://developer.android.com/topic/libraries/architecture/index.html), right? They have [documentation on how to use it](https://developer.android.com/topic/libraries/architecture/guide.html), and [even samples that show how to use it in real life and even write tests for it](https://github.com/googlesamples/android-architecture-components).

![](https://cdn-images-1.medium.com/max/800/1*-yY0l4XD3kLcZz0rO1sfRA.png)

The final architecture provided by Architecture Components (from [here](https://developer.android.com/topic/libraries/architecture/guide.html))

It handles edge cases better than MVP, and it takes less magic than MVI, and it’s definitely more production-ready (and less confusing!) than Redux.

And this all makes it easier to follow [the official Android guide on “saving state”](https://developer.android.com/topic/libraries/architecture/saving-states.html), instead of taking shortcuts like implementors of MVP/MVI/Redux — and riddling our app with unpredictable behavior and frustrating bugs for the end user.

Always test against [process death](https://stackoverflow.com/questions/49046773/singleton-object-becomes-null-after-app-is-resumed/49107399#49107399). Forgetting user input is a bug. After all, the Activity is not just a view.

### Conclusion

That might have been a long article, and a lot to take in (it also took long to write!), but overall, I’d say that for now, AAC is the clear winner — which is an Android-specific variant of MVVM.

As long as we use `LiveData` for emitting data, and `PublishSubject` for one-off events, things should work as expected (except in fragments: always remove observers in `onDestroyView()` in Fragments).

AAC solves certain common problems that can arise when writing an Android application. However, while doing so, it aims to reduce the complexity of the solution, rather than add additional layers of complexity on it (like Redux and “currying with middlewares” just to call a log statement, and so on).

Therefore, until Flow Coordinators or Reactive Workflows pop up in every-day use, I’d say for now, MVVM is the clear winner, and AAC helps with that quite elegantly. Paging library will be awesome.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
