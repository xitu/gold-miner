> * 原文地址：[ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders](https://medium.com/google-developers/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders-fc7cc4a6c090)
> * 原文作者：[Lyla Fujiwara](https://medium.com/@lylalyla?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders.md](https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders.md)
> * 译者：[Feximin](https://github.com/Feximin/)

# ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders

### 介绍

我在[上篇博文](https://medium.com/google-developers/viewmodels-a-simple-example-ed5ac416317e)中用新的 [ViewModel](https://developer.android.com/reference/android/arch/lifecycle/ViewModel.html) 类开发了一个简单的用例来保存配置更改过程中的篮球分数。ViewModel 被设计用来以与生命周期相关的方式保存和管理 UI 相关的数据。ViewModel 允许数据在例如屏幕旋转这样的配置更改后依然保留。

现在，你可能会有几个问题是关于 ViewModel 到底能做什么。本文我将解答：

* **ViewModel 是否对数据进行了持久化？** 简而言之，没有，还像平常那样去持久化。
* **ViewModel 是** [**onSaveInstanceState**](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29) **的替代品吗？** 简而言之，不是，但是他们不无关联，请继续读。
* **我如何高效地使用 ViewModel 来保存和恢复 UI 状态？** 简而言之，你可以混合混合 ViewModels、 `onSaveInstanceState()`、本地持久化一起使用。
* **ViewModel 是 Loader 的一个替代品吗？** 简而言之，对，ViewModel 结合其他几个类可以代替 Loader 使用。

### 图模型是否对数据进行了持久化？

**简而言之，没有。** 还像平常那样去持久化。

ViewModel 持有 **UI 中的临时数据**，但是他们不会进行持久化。一旦相关联的 UI 控制器（fragment/activity）被销毁或者进程停止了，ViewModel 和所有被包含的数据都将被垃圾回收机制标记。

那些被多个应用共用的数据应该像正常那样通过 [本地数据库，Shared Preferences，和/或者云存储](https://developer.android.com/guide/topics/data/data-storage.html)被持久化。如果你想让用户在应用运行在后台三个小时候后再返回到与之前完全相同的状态，你也需要将数据持久化。这是因为一旦你的活动进入后台，此时如果你的设备运行在低内存的情况下，你的应用进程是可以被终止的。下面是 activity 类文档中的一个[手册表](https://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle)，它描述了在 activity 的哪个生命周期状态时你的应用是可被终止的：

![](https://cdn-images-1.medium.com/max/800/1*OlXDJ7WENwiFBgOeKWjH7g.png)

[Activity 生命周期文档](https://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle)

在此提醒，如果一个应用进程由于资源限制而被终止的话，则不是正常终止并且没有额外的生命周期回调。这意味着你不能依赖于 [`onDestroy`](https://developer.android.com/reference/android/app/Activity.html#onDestroy%28%29) 调用。在进程终止的时候你**没有**机会持久化数据。因此如果你想最大可能的保持数据不丢失，你应该在用户一进入（activity）的时候就进行持久化。也就是说即便你的应用在由于资源限制而被终止或者设备电量用完了的时候数据也将会被保存下来。如果你允许在类似设备突然关机的情况下丢失数据，你可以在 ['onStop()']((https://developer.android.com/reference/android/app/Activity.html#onStop%28%29))回调的时候将其保存，这个方法在 activity 一进入后台的时候就会被调用。

### ViewModel 是 onSaveInstanceState 的替代品吗？

**简而言之，不是，** 但是他们不无关联，请继续读。

理解 [`onSaveInstanceState()`](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle,%20android.os.PersistableBundle%29) 和 [`Fragment.setRetainInstance(true)`](https://developer.android.com/reference/android/app/Fragment.html#setRetainInstance%28boolean%29) 二者之间的不同有助于理解了解这种差异的微妙之处。

**onSaveInstanceState():** 这个回调是为了保存两种情况下的**少量** UI 相关的数据：

* 应用的进程在后台的时候由于内存限制而被终止。
* 配置更改。

`onSaveInstanceState()` 是被系统在 activity [stopped](https://developer.android.com/reference/android/app/Activity.html#onStop%28%29) 但没有 [finished](https://developer.android.com/reference/android/app/Activity.html#finish%28%29) 时调用的，而**不是**在用户显式地关闭 activity 或者在其他情形而导致 [`finish()`](https://developer.android.com/reference/android/app/Activity.html#finish%28%29) 被调用的时候调用。

注意，很多 UI 数据会自动地被保存和恢复：

> “该方法的默认实现保存了关于 activity 的视图层次状态的临时信息，例如 [EditText](https://developer.android.com/reference/android/widget/EditText.html) 控件中的文本或者 [ListView](https://developer.android.com/reference/android/widget/ListView.html) 控件中的滚动条位置。” — [Saving and Restoring Instance State Documentation](https://developer.android.com/guide/components/activities/activity-lifecycle.html#saras)。

这些也是很好的例子说明了 `onSaveInstanceState()` 方法中存储的数据的类型。`onSaveInstanceState()` [不是被设计](https://developer.android.com/guide/topics/resources/runtime-changes.html#RetainingAnObject)来存储类似 bitmap 这样的大的数据的。`onSaveInstanceState()` 方法被设计用来存储那些小的与 UI 相关的并且序列化或者反序列化不复杂的数据。如果被序列化的对象是复杂的话，序列化会消耗大量的内存。由于这一过程发生在主线程的配置更改期间，它需要快速处理才不会丢帧和引起视觉上的卡顿。

**Fragment.setRetainInstance(true)**：[Handling Configuration Changes documentation](https://developer.android.com/guide/topics/resources/runtime-changes.html#RetainingAnObject) 描述了在配置更改期间的一个用来存储数据的进程使用了一个保留的 fragment。这听起来没有 `onSaveInstanceState()` 涵盖了配置更改和进程关闭两种情况那么有用。创建一个保留 fragment 的好处是这可以保存类似 image 那样的大型数据集或者网络连接那样的复杂对象。

**ViewModel 只能在配置更改相关的销毁的情况下保留，而不能在被终止的进程中存留。** 这使 ViewModel 成为搭配 `setRetainInstance(true)`（实际上，ViewModel 在幕后使用了一个 fragment 并将 [setRetainInstance](https://developer.android.com/reference/android/app/Fragment.html#setRetainInstance%28boolean%29) 方法中的参数设置为 true） 一块使用的 fragment 的一种替代品。

####  ViewModel 的其他好处

ViewModel 和 `onSaveInstanceState()` 在 UI 数据的存储方法上有很大差别。`onSaveInstanceState()` 是生命周期的一个回调函数，而 ViewModel 从根本上改变了 UI 数据在你的应用中的管理方式。下面是使用了 ViewModel 后比 `onSaveInstanceState()` 之外的更多的一些好处：

*   **ViewModel 鼓励良好的架构设计。数据与 UI 代码分离**，这使代码更加模块化且简化了测试。
*   `onSaveInstanceState()` 被设计用来存储少量的临时数据，而不是复杂的对象或者媒体数据列表。**一个 ViewModel 可以代理复杂数据的加载，一旦加载完成也可以作为临时的存储**。
*   `onSaveInstanceState()` 在配置更改期间和 activity 进入后台时被调用；在这两种情况下，如果你的数据被保存在 ViewModel 中，实际上并不需要重新加载或者处理他们。

### 我如何高效地使用 ViewModel 来保存和恢复 UI 状态？

**简而言之**，你可以**混合**使用 **ViewModel**、 **`onSaveInstanceState()`**、**本地持久化**。继续读看看如何使用。

重要的是你的 activity 维持着用户期望的状态，即便是屏幕旋转，系统关机或者用户重启。如我刚才所说，不要用复杂对象阻塞 `onSaveInstanceState` 方法同样也很重要。你也不想在你不需要的时候重新从数据库加载数据。让我们看一个 activity 的例子，在这个 activity 中你可以搜索你的音乐库：

![](https://cdn-images-1.medium.com/max/800/1*KjsvodQeJCZwSWiwtPET2g.png)

Activity 未搜索时及搜索后的状态示例。

用户离开一个 activity 有两种常用的方式，用户期望的也是两种不同的结果：

*  第一个是用户是否**彻底关闭**了 activity。如果用户将一个 activity 从 [recents screen](https://developer.android.com/guide/components/activities/recents.html) 中滑出或者[导航出去或退出](https://developer.android.com/training/design-navigation/ancestral-temporal.html)一个 activity 就可以彻底关闭它。这两种情形都假设**用户永久退出了这个 activity，如果重新进入那个 activity，他们所期望的是一个干净的页面**。对我们的音乐应用来说，如果用户完全关闭了音乐搜索的 activity 然后重新打开它，音乐搜索框和搜索结果都将被清除。
*  另一方面，如果用户旋转手机或者 在activity 进入后台然后回来，用户希望搜索结果和他们想搜索的音乐仍存在，就像进入后台前那样。用户有数种途径可以使 activity 进入后台。他们可以按 home 键或者通过应用的其他地方导航（出去）。抑或在查看搜索结果的时候电话打了进来或收到通知。然而用户最终希望的是当他们返回到那个 activity 的时候页面状态与离开前完全一样。

为了实现这两种情形下的行为，用可以将本地持久化、ViewModel 和 `onSaveInstanceState()` 一起使用。每一种都会存储 activity 中使用的不同数据：

*  **本地持久化**是用于存储当打开或关闭 activity 的时所有你不想丢失的数据。

   **举例：** 包含了音频文件和元数据的所有音乐对象的集合。
*  **ViewModel** 是用于存储显示相关 UI 控制器的所需的所有数据。
  
   **举例：** 最近的搜索结果。
*  **onSaveInstanceState** 是用于存储在 UI 控制器被系统终止又重建后可以轻松地重新加载 activity 状态时所需的少量数据。在本地存储中持久化复杂对象，在 `onSaveInstanceState()` 中为这些对象存储唯一的 ID，而不是直接存储复杂对象。
   **举例：** 最近的搜索查询。

在音乐搜索的例子中，不同的事件应该被这样处理：

**用户添加一首音乐的时候 —** ViewModel 会迅速代理本地持久化这条数据。如果新添加的音乐需要在 UI 上显示，你还应该更新 ViewModel 中的数据来反应音乐的添加。谨记切勿在主线程中向数据库插入数据。 

**当用户搜索音乐的时候 —** 任何从数据库为 UI 控制器加载的复杂音乐数据应该马上存入 ViewModel。你也应该将搜索查询本身存入 ViewModel。

**当这个 activity 处于后台并且被系统终止的时候 —** 一旦 activity 进入后台 `onSaveInstanceState()` 就会被调用。你应将搜索查询存入 `onSaveInstanceState()` 的 bundle 里。这些少量数据易于保存。这同样也是使 activity 恢复到当前状态所需的所有数据。

**当 activity 被创建的时候 —** 可能出现三种不同的方式：

*   **Activity 是第一次被创建**：在这种情况下，`onSaveInstanceState()`方法中的 bundle 里是没有数据的，ViewModel 也是空的。创建 ViewModel 时，你传入一个空查询，ViewModel 会意识到还没有数据可以加载。这个 activity 以一种全新的状态启动起来。
*   **Activity 在被系统终止后创建**：activity 的 `onSaveInstanceState()` 的 bundle 中保存了查询。Activity 会将这个查询传入 ViewModel。ViewModel发现缓存中没有搜索结果，就会使用给定的搜索查询代理加载搜索结果。
*   **Activity 在配置更改后被创建**：Activity 会将本次查询保存在 `onSaveInstanceState()` 的 bundle 参数中并且 ViewModel 也会将搜索结果缓存起来。你通过 `onSaveInstanceState()` 的 bundle 将查询传入 ViewModel，这将决定它已加载了必须的数据从而**不**需要重新查询数据库。

这是一个良好的保存和恢复 activity 状态的方法。基于你的 activity 的实现，你可能根本不需要 `onSaveInstanceState()`。例如，有些 activity 在被用户关闭后不会以一个全新的状态打开。一般地，当我在 Android 手机上关闭然后重新打开 Chrome 时，返回到了关闭 Chrome 之前正在浏览的页面。如果你的 activity 行为如此，你可以不使用 `onSaveInstanceState()` 而在本地持久化所有数据。同样以音乐搜索为例，那意味着在例如 [Shared Preferences](https://developer.android.com/reference/android/content/SharedPreferences.html) 中持久化最近的查询。

此外，当你通过 intent 打开一个 activity，配置更改和系统恢复这个 activity 时 bundle 参数都会被传进来。如果搜索查询是通过 intent 的 extras 传进来，那么你就可以使用 extras 中的 bundle 代替 `onSaveInstanceState()` 中的 bundle。

不过，在这两种场景中，你仍需要一个 ViewModel 来避免因配置更改而重新从数据库中加载数据导致的资源浪费。

### ViewModel 是 Loader 的一个替代品吗？ 

**简而言之**，对，ViewModel 结合其他几个类可以代替 Loader 使用。

[**Loader**](https://developer.android.com/guide/components/loaders.html) 是 UI 控制器用来加载数据的。此外，Loader 可以在配置更改期间保留，比如说在加载的过程中你旋转了手机屏幕。这听起来很耳熟吧！

Loader ，特别是 [CursorLoader](https://developer.android.com/reference/android/content/CursorLoader.html)，的常见用法是观察数据库的内容并保持数据与 UI 同步。使用 CursorLoader 后，如果数据库其中的一个值发生改变，Loader 就会自动触发数据重新加载并且更新 UI。

![](https://cdn-images-1.medium.com/max/800/1*QuZeqCSgKlrfD7CGQq1laA.png)

ViewModel 与其他架构组件 [LiveData](https://developer.android.com/topic/libraries/architecture/livedata.html) 和 [Room](https://developer.android.com/topic/libraries/architecture/room.html) 一起使用可以替代 Loader。ViewModel 保证配置更改后数据不丢失。LiveData 保证 UI 与数据同步更新。Room 确保你的数据库更新时，LiveData 被通知到。

![](https://cdn-images-1.medium.com/max/800/1*Zc2mtVLw7y10MFZq4za7EA.png)

由于 Loader 在 UI 控制器中作为回调被实现，因此 ViewModel 的一个额外优点是将 UI 控制器与数据加载分离开来。这可以减少类之间的强引用。

一些使用 ViewModels 、LiveData 为加载数据的方法：

*   在[这篇文章](https://medium.com/google-developers/lifecycle-aware-data-loading-with-android-architecture-components-f95484159de4)中，[Ian Lake](https://medium.com/@ianhlake) 概述了如何使用 ViewModel 和 LiveData 来代替 [AsyncTaskLoader](https://developer.android.com/reference/android/content/AsyncTaskLoader.html)。
*   随着代码变得越来越复杂，你可以考虑在一个单独的类里进行实际的数据加载。一个 ViewModel 类的目的是为 UI 控制器持有数据。加载、持久化、管理数据这些复杂的方法超出了 ViewModel 传统功能的范围。[Guide to Android App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html#fetching_data) 建议创建一个**仓库**类。

> “仓库模块负责处理数据操作。他们为应用的其他部分提供了一套干净的 API。当数据更新时他们知道从哪里获取数据以及调用哪个 API。你可以把他们当做是不同数据源（持久模型、web service、缓存等）之间的协调员。” — [Guide to App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html#fetching_data)

### 结论以及进一步学习

在本文中，我回答了几个关于 ViewModel 类是什么和不是什么的问题。关键点是：

*   ViewModel 不是持久化的替代品 — 当数据改变时像平常那样持久化他们。
*   ViewModel 不是 `onSaveInstanceState()` 的替代品，因为他们在与配置更改相关的销毁时保存数据，而不能在系统杀死应用进程时保存。
*   `onSaveInstanceState()` 并不适用于那些需要长时间序列化/反序列化的数据。
*   为了高效的保存和恢复 UI 状态，可以混合使用 持久化、`onSaveInstanceState()` 和 ViewModel。复杂数据通过本地持久化保存然后用 `onSaveInstanceState()` 来保存那些复杂数据的唯一 ID。ViewModel 在数据加载后将他们保存在内存中。
*   在这个场景下，ViewModel 在 activity 旋转或者进入后台时仍保留数据，而单纯用 `onSaveInstanceState()` 并没那么容易实现。
*   结合 ViewModel 和 LiveData 一起使用可以代替 Loader。你可以使用 Room 来代替 CursorLoader 的功能。
*   创建仓库类来支持一个可伸缩的加载、缓存和同步数据的架构。

想要更多 ViewModel 相关的干货？请看：

*   [Instructions for adding the gradle dependencies](https://developer.android.com/topic/libraries/architecture/adding-components.html)
*   [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) documentation
*   Guided ViewModel practice with the [Lifecycles Codelab](https://codelabs.developers.google.com/codelabs/android-lifecycles/#0)
*   Helpful samples that include ViewModel [[Architecture Components](https://github.com/googlesamples/android-architecture-components)] [[Architecture Blueprint using Lifecycle Components](https://github.com/googlesamples/android-architecture/tree/dev-todo-mvvm-live/)]
*   The [Guide to App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html)

架构组件是基于你反馈来创建的。如果你有关于 ViewModel 或者任何架构组件的问题，请查看我们的[反馈页面](https://developer.android.com/topic/libraries/architecture/feedback.html)。关于本系列的任何问题，敬请留言。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
