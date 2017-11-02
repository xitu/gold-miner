> * 原文地址：[ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders](https://medium.com/google-developers/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders-fc7cc4a6c090)
> * 原文作者：[Lyla Fujiwara](https://medium.com/@lylalyla?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders.md](https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders.md)
> * 译者：
> * 校对者：

# ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders

### Introduction

In the [last blog post](https://medium.com/google-developers/viewmodels-a-simple-example-ed5ac416317e) I explored a simple use case with the new [ViewModel](https://developer.android.com/reference/android/arch/lifecycle/ViewModel.html) class for saving basketball score data during a configuration change. ViewModels are designed to hold and manage UI-related data in a life-cycle conscious way. ViewModels allow data to survive configuration changes such as screen rotations.

At this point, you might have a few questions about the breadth of what ViewModels do. In this post I’ll be answering:

*   **Do ViewModels persist my data?** TL;DR No.Persist as normal!
*   **Are ViewModels a replacement for** [**onSaveInstanceState**](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29)**?** TL;DR No, but they are related so keep reading.
*   **How do I use ViewModels to save and restore UI state efficiently?** TL;DRYou use a combination of ViewModels, `onSaveInstanceState()` and local persistence.
*   **Are ViewModels a replacement for Loaders?** TL;DR. Yes, ViewModels used in conjunction with a few other classes can replace Loaders.

### Do ViewModels persist my data?

**TL;DR No.** Persist as normal!

ViewModels hold **transient data used in the UI** but they don’t persist data. Once the associated UI Controller (fragment/activity) is destroyed or the process is stopped, the ViewModel and all the contained data gets marked for garbage collection.

Data used over multiple runs of the application should be persisted like normal in a [local database, Shared Preferences, and/or in the cloud](https://developer.android.com/guide/topics/data/data-storage.html). If you want the user to be able to put the app into the background and then come back three hours later to the exact same state, you should also persist data. This is because as soon as your activity goes into the background, your app process can be stopped if the device is running low on memory. There’s a [handy table in the activity class documentation](https://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle) which describes in which activity lifecycle states your app is stoppable:

![](https://cdn-images-1.medium.com/max/800/1*OlXDJ7WENwiFBgOeKWjH7g.png)

[Activity lifecycle documentation](https://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle)

As a reminder, when an app processes is stopped due to resource constraints, it’s stopped without ceremony and **no additional lifecycle callbacks are called.** This means that you can’t rely on `[onDestroy](https://developer.android.com/reference/android/app/Activity.html#onDestroy%28%29)` being called. You **do not** have a chance to persist data at the time of process shutdown. Therefore, if you want to be the _most_ sure that you won’t lose data, persist it as soon as the user enters it. This means that even if your app process is shut down due to resource constraints or if the device runs out of battery, the data will be saved. If you’re willing to concede losing data in instances of sudden device shutdown, you can save the data in the `[onStop()](https://developer.android.com/reference/android/app/Activity.html#onStop%28%29)`callback**,** which happens right as the activity is going into the background.

### Are ViewModels a replacement for onSaveInstanceState?

**TL;DR No,** but they are related so keep reading.

To understand the subtleties of this difference, it’s helpful to understand the difference between `[onSaveInstanceState()](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle,%20android.os.PersistableBundle%29)` and `[Fragment.setRetainInstance(true)](https://developer.android.com/reference/android/app/Fragment.html#setRetainInstance%28boolean%29)`

**onSaveInstanceState():** This callback is meant to retain a **small** amount of UI related data in two situations:

*   The app’s process is stopped when it’s in the background due to memory constraints.
*   Configuration changes.

`onSaveInstanceState()` is called in situations in which the activity is [stopped](https://developer.android.com/reference/android/app/Activity.html#onStop%28%29), but not [finished](https://developer.android.com/reference/android/app/Activity.html#finish%28%29), by the system. It is **not** called when the user explicitly closes the activity or in other cases when `[finish()](https://developer.android.com/reference/android/app/Activity.html#finish%28%29)` is called.

Note that a lot of UI data is automatically saved and restored for you:

> “The default implementation of this method saves transient information about the state of the activity’s view hierarchy, such as the text in an [EditText](https://developer.android.com/reference/android/widget/EditText.html) widget or the scroll position of a [ListView](https://developer.android.com/reference/android/widget/ListView.html) widget.” — [Saving and Restoring Instance State Documentation](https://developer.android.com/guide/components/activities/activity-lifecycle.html#saras)

These are also good examples of the type of data that is meant to be stored in `onSaveInstanceState()`. `onSaveInstanceState()` [is not designed to](https://developer.android.com/guide/topics/resources/runtime-changes.html#RetainingAnObject) store large amounts of data, such as bitmaps.`onSaveInstanceState()` is designed to store data that is small, related to the UI and not complicated to serialize or deserialize. Serialization can consume lots of memory if the objects being serialized are complicated. Because this process happens on the main thread during a configuration change, it needs to be fast so that you don’t drop frames and cause visual stutter.

**Fragment.setRetainInstance(true)**: The [Handling Configuration Changes documentation](https://developer.android.com/guide/topics/resources/runtime-changes.html#RetainingAnObject) describes a process for storing data during a configuration change using a retained fragment. This _sounds_ less useful than `onSaveInstanceState()` which covers both configuration changes as well as process shutdown. The usefulness of creating a retained fragment is that it’s meant to retain large sets of data such as images or to retain complex objects like network connections.

**ViewModels only survive configuration change-related destruction; they do not survive the process being stopped.** This makes ViewModels a replacement for using a fragment with `setRetainInstance(true)` (in fact ViewModels use a fragment with [setRetainInstance](https://developer.android.com/reference/android/app/Fragment.html#setRetainInstance%28boolean%29) set to true behind the scenes).

#### Additional ViewModel benefits

ViewModels and `onSaveInstanceState()` address UI data in very different ways. `onSaveInstanceState()` is a lifecycle callback, whereas ViewModels fundamentally change the way UI data is managed in your app. Here are a few more thoughts on the benefits of using ViewModel in addition to `onSaveInstanceState()`:

*   **ViewModels encourage good architectural design. Your data is separated from your UI code**, which makes the code more modular and simplifies testing.
*   `onSaveInstanceState()` is designed to save a small amount of transient data, but not complex lists of objects or media data. **A ViewModel can delegate the loading of complex data and also act as temporary storage once this data is loaded**.
*   `onSaveInstanceState()` is called during configuration changes and when the activity goes into the background; in both of these cases you actually do **not** need to reload or process the data if you keep it in a ViewModel.

### How do I use ViewModels to save and restore UI state efficiently?

**TL;DR** You use **a combination of ViewModels,** `**onSaveInstanceState()**` **and local persistence**.Read on to see how.

It’s important that your activity maintains the state a user expects, even as it is rotated, shut down by the system or restarted by the user. As I just mentioned, it’s also important that you don’t clog up `onSaveInstanceState` with complex objects. You also don’t want to reload data from the database when you don’t need to. Let’s look at an example of an activity that allows you to search through your library of songs:

![](https://cdn-images-1.medium.com/max/800/1*KjsvodQeJCZwSWiwtPET2g.png)

Example of the clean state of the activity and the state after a search.

There are two general ways a user can leave an activity, and two different outcomes the user will expect:

*   The first is if the user **completely closes** the activity. A user can completely close the activity if they swipe an activity off of the [recents screen](https://developer.android.com/guide/components/activities/recents.html) or if a user [navigates up or back](https://developer.android.com/training/design-navigation/ancestral-temporal.html) out of an activity. The assumption in these cases is that **the user has permanently navigated away from the activity, and if they ever re-open the activity, they will expect to start from a clean state**. For our song app, if a user completely closes the song search activity and later re-opens the activity, the song search box will be cleared and so will the search results.
*   On the other hand, if a user rotates the phone or puts the activity in the background and then comes back to it, the user expects that the search results and song they searched for are there, exactly as before. There are a few ways the user could put the activity in the background. They could press the home button or navigate somewhere else in the app. Or they could receive a phone call or notification in the middle of looking at search results. In the end, though, the user expects when they come back to the activity, that the state is the same as they left it.

To implement this behavior in both situations, you will use local persistence, ViewModels and `onSaveInstanceState()` together. Each will store different data the activity uses:

*   **Local persistence** is used for storing all data you don’t want to lose if you open and close the activity.  
    **Example:** The collection of all song objects, which could include audio files and metadata
*   **ViewModels** are used for storing all the data needed to display the associated UI Controller.  
    **Example:** The results of the most recent search, the most recent search query
*   **onSaveInstanceState** is used for storing a small amount of data needed to easily reload activity state if the UI Controller is stopped and recreated by the system. Instead of storing complex objects here, persist the complex objects in local storage and store a unique ID for these objects in `onSaveInstanceState()`.  
    **Example:** The most recent search query

In the song search example, here’s how different events should be handled:

**When the user adds a song — **The ViewModel will immediately delegate persisting this data locally. If this newly added song is something that should be shown in the UI, you should also update the data in ViewModel to reflect the addition of the song. Remember to do all database inserts off of the main thread.

**When the user searches for a song — **Whatever complex song data you load from the database for the UI Controller should be immediately stored in the ViewModel. You should also save the search query itself in the ViewModel.

**When the activity goes into the background and the activity is stopped by the system — **When the activity goes into the background, `onSaveInstanceState()` will be called. You should save the search query in the `onSaveInstanceState()` bundle. This small amount of data is easy to save. It’s also all the information you need to get the activity back into its current state.

**When the activity is created **— There are three different ways this could happen:

*   **The activity is created for the first time**: In this case, you’ll have no data in the `onSaveInstanceState()` bundle and an empty ViewModel. When creating the ViewModel, you’ll pass an empty query and the ViewModel will know that there’s no data to load yet. The activity will start in a clean empty state.
*   **The activity is created after being stopped by the system**: The activity will have the query saved in an `onSaveInstanceState()` bundle. The activity should pass the query to the ViewModel. The ViewModel will see that it has no search results cached and will delegate loading the search results, using the given search query.
*   **The activity is created after a configuration change**: The activity will have the query saved in an `onSaveInstanceState()` bundle AND the ViewModel will already have the search results cached. You pass the query from the `onSaveInstanceState()` bundle to the ViewModel, which will determine that it already has loaded the necessary data and that it does **not** need to re-query the database.

This is one sane way to handle saving and restoring activity state. Depending on your activity implementation, you might not need to use `onSaveInstanceState()` at all. For example, some activities don’t open in a clean state after the user closes them. Currently, when I close and re-open Chrome on Android, it takes me back to the exact webpage I was looking at before closing it. If your activity behaves this way, you can ditch `onSaveInstanceState()` and instead persist everything locally. In the song searching example, that would mean persisting the most recent query, for example, in [Shared Preferences](https://developer.android.com/reference/android/content/SharedPreferences.html).

Additionally, when you open an activity from an intent, the bundle of extras is delivered to you on both configuration changes and when the system restores an activity. If the search query were passed in as an intent extra, you could use the extras bundle instead of the `onSaveInstanceState()` bundle.

In both of these scenarios, though, you’d still use a ViewModel to avoid wasting cycles reloading data from the database during a configuration change!

### Are ViewModels a replacement for Loaders?

**TL;DR.** Yes, ViewModels used in conjunction with a few other classes can replace Loaders.

[**Loaders**](https://developer.android.com/guide/components/loaders.html) are for loading data for UI Controllers. In addition, Loaders can survive configuration changes, if, for example, you rotate the device in the middle of a load. This sounds familiar!

A common use case for Loaders, in particular [CursorLoaders](https://developer.android.com/reference/android/content/CursorLoader.html), is to have the Loader observe the content of a database and keep the data the UI displays in sync. Using a CursorLoader, if a value in the database changes, the Loader will automatically trigger a reload of the data and update the UI.

![](https://cdn-images-1.medium.com/max/800/1*QuZeqCSgKlrfD7CGQq1laA.png)

ViewModels, used with other Architecture Components, [LiveData](https://developer.android.com/topic/libraries/architecture/livedata.html) and [Room](https://developer.android.com/topic/libraries/architecture/room.html), can replace Loaders. The ViewModel ensures that the data can survive a configuration change. LiveData ensures that your UI can update when the data updates. Room ensures that when your database updates, your LiveData is notified.

![](https://cdn-images-1.medium.com/max/800/1*Zc2mtVLw7y10MFZq4za7EA.png)

Loaders are implemented as callbacks within your UI Controller, so an added benefit of ViewModels is they detangle your UI Controller and data loading. This makes you have fewer strong references between classes.

There are a few approaches to using ViewModels and LiveData to load data:

*   In [this blog post](https://medium.com/google-developers/lifecycle-aware-data-loading-with-android-architecture-components-f95484159de4), [Ian Lake](https://medium.com/@ianhlake) outlines how you can use a ViewModel and LiveData to replace an [AsyncTaskLoader](https://developer.android.com/reference/android/content/AsyncTaskLoader.html).
*   As your code gets more complex, you can consider having the actual data loading take place in a separate class. The purpose of a ViewModel class is to contain data for a UI controller such that that data survives configuration changes. Loading, persisting, and managing data are complicated functions that are outside of the scope of what a ViewModel traditionally does. The [Guide to Android App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html#fetching_data) suggests building a **repository** class.

> “Repository modules are responsible for handling data operations. They provide a clean API to the rest of the app. They know where to get the data from and what API calls to make when data is updated. You can consider them as mediators between different data sources (persistent model, web service, cache, etc.).” — [Guide to App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html#fetching_data)

### Conclusion and further learning

In this post, I answered a few questions about what the ViewModel class is and what it’s not. The key takeaways are:

*   ViewModels are not a replacement for persistence — persist your data like normal when it’s changed.
*   ViewModels are not a replacement for `onSaveInstanceState()` because they only survive configuration change related destruction; they do not survive the OS stopping the app’s process.
*   `onSaveInstanceState()` is not meant for complex data that require lengthy serialization/deserialization.
*   To efficiently save and restore UI state, use a combination of persistence, `onSaveInstanceState()` and ViewModels. Complex data is saved in local persistence and `onSaveInstanceState()` is used to store unique identifiers to that complex data. ViewModels store the complex data in memory after it is loaded.
*   In this scenario, ViewModels still retain the data when the activity is rotated or goes into the background, which is something that you can’t easily do by using purely `onSaveInstanceState()`.
*   ViewModels and LiveData, used in conjunction, can replace Loaders. You can use Room to replace CursorLoader functionality.
*   Repository classes are created to support a scalable architecture for loading, caching and syncing data.

Want more ViewModel-ly goodness? Check out:

*   [Instructions for adding the gradle dependencies](https://developer.android.com/topic/libraries/architecture/adding-components.html)
*   [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) documentation
*   Guided ViewModel practice with the [Lifecycles Codelab](https://codelabs.developers.google.com/codelabs/android-lifecycles/#0)
*   Helpful samples that include ViewModel [[Architecture Components](https://github.com/googlesamples/android-architecture-components)] [[Architecture Blueprint using Lifecycle Components](https://github.com/googlesamples/android-architecture/tree/dev-todo-mvvm-live/)]
*   The [Guide to App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html)

The architecture components were created based on your feedback. If you have questions or comments about ViewModel or any of the architecture components, check out our [feedback page](https://developer.android.com/topic/libraries/architecture/feedback.html). Questions about this series? Leave a comment!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
