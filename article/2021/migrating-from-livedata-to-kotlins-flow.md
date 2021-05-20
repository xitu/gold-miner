> * 原文地址：[Migrating from LiveData to Kotlin’s Flow](https://medium.com/androiddevelopers/migrating-from-livedata-to-kotlins-flow-379292f419fb)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/migrating-from-livedata-to-kotlins-flow.md](https://github.com/xitu/gold-miner/blob/master/article/2021/migrating-from-livedata-to-kotlins-flow.md)
> * 译者：
> * 校对者：

# Migrating from LiveData to Kotlin’s Flow

![](https://miro.medium.com/max/8000/1*6gh2Ttj_yiu1SeYVETlvog.jpeg)

**LiveData** was something we needed back in 2017. The observer pattern made our lives easier, but options such as RxJava were too complex for beginners at the time. The Architecture Components team created **LiveData**: a very opinionated observable data holder class, designed for Android. It was kept simple to make it easy to get started and the recommendation was to use RxJava for more complex reactive streams cases, taking advantage of the integration between the two.

## DeadData?

LiveData is still our **solution for Java developers, beginners, and simple situations**. For the rest, a good option is moving to **Kotlin Flows**. Flows still have a steep learning curve but they are part of the Kotlin language, supported by Jetbrains; and Compose is coming, which fits nicely with the reactive model.

We’ve been [talking about using](/androiddevelopers/lessons-learnt-using-coroutines-flow-4a6b285c0d06) Flows for a while to connect the different parts of your app except for the view and ViewModel. Now that we have [a safer way to collect flows from Android UIs](/androiddevelopers/a-safer-way-to-collect-flows-from-android-uis-23080b1f8bda), we can create a complete migration guide.

In this post you’ll learn how to expose Flows to a view, how to collect them, and how to fine-tune it to fit specific needs.

## Flow: Simple things are harder and complex things are easier

LiveData did one thing and it did it well: it [exposed data while caching the latest value](/androiddevelopers/livedata-with-coroutines-and-flow-part-i-reactive-uis-b20f676d25d7) and understanding Android’s lifecycles. Later we learned that it could also [start coroutines](/androiddevelopers/livedata-with-coroutines-and-flow-part-ii-launching-coroutines-with-architecture-components-337909f37ae7) and [create complex transformations](/androiddevelopers/livedata-beyond-the-viewmodel-reactive-patterns-using-transformations-and-mediatorlivedata-fda520ba00b7#:~:text=The%20observable%20paradigm%20works%20really,take%20advantage%20of%20lifecycle%20awareness.&text=Observe%20changes%20in%20SharedPreferences,document%20or%20collection%20in%20Firestore), but this was a bit more involved.

Let’s look at some LiveData patterns and their Flow equivalents:

### #1: Expose the result of a one-shot operation with a Mutable data holder

This is the classic pattern, where you mutate a state holder with the result of a coroutine:

![](https://miro.medium.com/max/1600/0*uEwETJ80kXERy4bJ)

Expose the result of a one-shot operation with a Mutable data holder (LiveData)

```kt
<!-- Copyright 2020 Google LLC.	
   SPDX-License-Identifier: Apache-2.0 -->

class MyViewModel {
    private val _myUiState = MutableLiveData<Result<UiState>>(Result.Loading)
    val myUiState: LiveData<Result<UiState>> = _myUiState

    // Load data from a suspend fun and mutate state
    init {
        viewModelScope.launch { 
            val result = ...
            _myUiState.value = result
        }
    }
}
```

To do the same with Flows, we use (Mutable)StateFlow:

![](https://miro.medium.com/max/1854/0*Hf3EmJ8gchpSy6nd)

Expose the result of a one-shot operation with a Mutable data holder (StateFlow)

```kt
class MyViewModel {
    private val _myUiState = MutableStateFlow<Result<UiState>>(Result.Loading)
    val myUiState: StateFlow<Result<UiState>> = _myUiState

    // Load data from a suspend fun and mutate state
    init {
        viewModelScope.launch { 
            val result = ...
            _myUiState.value = result
        }
    }
}
```

[**StateFlow**](https://developer.android.com/kotlin/flow/stateflow-and-sharedflow#stateflow) is a special kind of [**SharedFlow**](https://developer.android.com/kotlin/flow/stateflow-and-sharedflow#sharedflow) (which is a special type of Flow), closest to LiveData:

* It always has a value.
* It only has one value.
* It supports multiple observers (so the flow is **shared**).
* It always replays the latest value on subscription, independently of the number of active observers.

> When exposing UI state to a view, use **StateFlow**. It’s a safe and efficient observer designed to hold UI state.

### #2: Expose the result of a one-shot operation

This is the equivalent to the previous snippet, exposing the result of a coroutine call without a mutable backing property.

With LiveData we used the `[liveData](https://developer.android.com/topic/libraries/architecture/coroutines#livedata)` coroutine builder for this:

![](https://miro.medium.com/max/1854/0*HKl0HDnxMxlYbZb_)

Expose the result of a one-shot operation (LiveData)

```kt
class MyViewModel(...) : ViewModel() {
    val result: LiveData<Result<UiState>> = liveData {
        emit(Result.Loading)
        emit(repository.fetchItem())
    }
}
```

Since the state holders always have a value, it’s a good idea to wrap our UI state in some kind of **Result** class that supports states such as `Loading`, `Success`, and `Error`.

The Flow equivalent is a bit more involved because you have to do some **configuration**:

![](https://miro.medium.com/max/1854/0*sFoX0pbnLijOPaiy)

Expose the result of a one-shot operation (StateFlow)

```kt
class MyViewModel(...) : ViewModel() {
    val result: StateFlow<Result<UiState>> = flow {
        emit(repository.fetchItem())
    }.stateIn(
        scope = viewModelScope, 
        started = WhileSubscribed(5000), // Or Lazily because it's a one-shot
        initialValue = Result.Loading
    )
}
```

`stateIn` is a Flow operator that converts a Flow to **StateFlow**. Let’s trust these parameters for now, as we need more complexity to explain it properly later.

### #3: One-shot data load with parameters

Let’s say you want to load some data that depends on the user’s ID and you get this information from an `AuthManager` that exposes a Flow:

![](https://miro.medium.com/max/1854/0*NkfiDL2ko9lkKPTh)

One-shot data load with parameters (LiveData)

With LiveData you would do something similar to this:

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: LiveData<String?> = 
        authManager.observeUser().map { user -> user.id }.asLiveData()

    val result: LiveData<Result<Item>> = userId.switchMap { newUserId ->
        liveData { emit(repository.fetchItem(newUserId)) }
    }
}
```

`switchMap` is a transformation whose body is executed and the result subscribed to when `userId` changes.

If there’s no reason for `userId` to be a LiveData, a better alternative to this is to combine streams with Flow and finally convert the exposed result to LiveData.

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: Flow<UserId> = authManager.observeUser().map { user -> user.id }

    val result: LiveData<Result<Item>> = userId.mapLatest { newUserId ->
       repository.fetchItem(newUserId)
    }.asLiveData()
}
```

Doing this with Flows looks very similar:

![](https://miro.medium.com/max/1854/0*IGFPV_i3vBpPQKsA)

One-shot data load with parameters (StateFlow)

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: Flow<UserId> = authManager.observeUser().map { user -> user.id }

    val result: StateFlow<Result<Item>> = userId.mapLatest { newUserId ->
        repository.fetchItem(newUserId)
    }.stateIn(
        scope = viewModelScope, 
        started = WhileSubscribed(5000), 
        initialValue = Result.Loading
    )
}
```

Note that if you need more flexibility you can also use `transformLatest` and `emit` items explicitly:

```kt
val result = userId.transformLatest { newUserId ->
    emit(Result.LoadingData)
    emit(repository.fetchItem(newUserId))
}.stateIn(
    scope = viewModelScope, 
    started = WhileSubscribed(5000), 
    initialValue = Result.LoadingUser // Note the different Loading states
)
```

### #4: Observing a stream of data with parameters

Now let’s make the example more **reactive**. The data is not fetched, but **observed**, so we propagate changes in the source of data automatically to the UI.

Continuing with our example: instead of calling `fetchItem` on the data source, we use a hypothetical `observeItem` operator that returns a Flow.

With LiveData you can convert the flow to LiveData and `emitSource` all the updates:

![](https://miro.medium.com/max/1854/0*gieCVtPGDY0GLmSW)

Observing a stream with parameters (LiveData)

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: LiveData<String?> = 
        authManager.observeUser().map { user -> user.id }.asLiveData()

    val result = userId.switchMap { newUserId ->
        repository.observeItem(newUserId).asLiveData()
    }
}
```

Or, preferably, combine both flows using `[flatMapLatest](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/flat-map-latest.html)` and convert only the output to LiveData:

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: Flow<String?> = 
        authManager.observeUser().map { user -> user?.id }

    val result: LiveData<Result<Item>> = userId.flatMapLatest { newUserId ->
        repository.observeItem(newUserId)
    }.asLiveData()
}
```

The Flow implementation is similar but it doesn’t have LiveData conversions:

![](https://miro.medium.com/max/1854/0*T-S2IXEmR2RL308f)

Observing a stream with parameters (StateFlow)

```kt
class MyViewModel(authManager..., repository...) : ViewModel() {
    private val userId: Flow<String?> = 
        authManager.observeUser().map { user -> user?.id }

    val result: StateFlow<Result<Item>> = userId.flatMapLatest { newUserId ->
        repository.observeItem(newUserId)
    }.stateIn(
        scope = viewModelScope, 
        started = WhileSubscribed(5000), 
        initialValue = Result.LoadingUser
    )
}
```

The exposed StateFlow will receive updates whenever the user changes or the user’s data in the repository is changed.

### #5 Combining multiple sources: MediatorLiveData -> Flow.combine

MediatorLiveData lets you observe one or more sources of updates (LiveData observables) and do something when they get new data. Usually, you update the value of the MediatorLiveData:

```kt
val liveData1: LiveData<Int> = ...
val liveData2: LiveData<Int> = ...

val result = MediatorLiveData<Int>()

result.addSource(liveData1) { value ->
    result.setValue(liveData1.value ?: 0 + (liveData2.value ?: 0))
}
result.addSource(liveData2) { value ->
    result.setValue(liveData1.value ?: 0 + (liveData2.value ?: 0))
}
```

The Flow equivalent is much more straightforward:

```kt
val flow1: Flow<Int> = ...
val flow2: Flow<Int> = ...

val result = combine(flow1, flow2) { a, b -> a + b }
```

You can also use the [combineTransform](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/combine-transform.html) function, or [zip](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/zip.html).

## Configuring the exposed StateFlow (stateIn operator)

We previously used `stateIn` to convert a regular flow to a StateFlow, but it requires some configuration. If you don’t want to go into detail right now and just need to copy-paste, this combination is what I recommend:

```kt
val result: StateFlow<Result<UiState>> = someFlow
    .stateIn(
        scope = viewModelScope, 
        started = WhileSubscribed(5000), 
        initialValue = Result.Loading
    )
```

However, if you’re not sure about that seemingly random 5-second `started` parameter, read on.

`stateIn` has 3 parameters (from docs):

```
@param scope the coroutine scope in which sharing is started.
@param started the strategy that controls when sharing is started and stopped.
@param initialValue the initial value of the state flow.
This value is also used when the state flow is reset using the [SharingStarted.WhileSubscribed] strategy with the `replayExpirationMillis` parameter.
```

`started` can take 3 values:

* `Lazily`: start when the first subscriber appears and stop when `scope` is cancelled.
* `Eagerly`: start immediately and stop when `scope` is cancelled
* `WhileSubscribed`: **It’s complicated.**

For one-shot operations you can use `Lazily` or `Eagerly`. However, if you’re observing other flows, you should use `WhileSubscribed` to do small but important optimizations as explained below.

## The WhileSubscribed strategy

WhileSubscribed cancels the **upstream flow** when there are no collectors. The StateFlow created using `stateIn` exposes data to the View, but it’s also observing flows coming from other layers or the app (upstream). Keeping these flows active might lead to wasting resources, for example, if they continue reading data from other sources such as a database connection, hardware sensors, etc. **When your app goes to the background, you should be a good citizen and stop these coroutines.**

`WhileSubscribed` takes two parameters:

```kt
public fun WhileSubscribed(  
    stopTimeoutMillis: Long = 0,  
    replayExpirationMillis: Long = Long.MAX_VALUE  
)
```

### Stop timeout

From its documentation:

> `stopTimeoutMillis` configures a delay (in milliseconds) between the disappearance of the last subscriber and the stopping of the upstream flow. It defaults to zero (stop immediately).

This is useful because you don’t want to cancel the upstream flows if the view stopped listening for a fraction of a second. This happens all the time — for example, when the user rotates the device and the view is destroyed and recreated in quick succession.

The solution in the `liveData` coroutine builder was to [add a delay](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-livedata-ktx/src/main/java/androidx/lifecycle/CoroutineLiveData.kt;l=356) of 5 seconds after which the coroutine would be stopped if no subscribers are present. `WhileSubscribed(5000)` does exactly that:

```kt
class MyViewModel(...) : ViewModel() {
    val result = userId.mapLatest { newUserId ->
        repository.observeItem(newUserId)
    }.stateIn(
        scope = viewModelScope, 
        started = WhileSubscribed(5000), 
        initialValue = Result.Loading
    )
}
```

This approach checks all the boxes:

* When the user sends your app to the background, updates coming from other layers will stop after five seconds, saving battery.
* The latest value will still be cached so that when the user comes back to it, the view will have some data immediately.
* Subscriptions are restarted and new values will come in, refreshing the screen when available.

### Replay expiration

If you don’t want the user to see stale data when they’ve gone away for too long and you prefer to display a loading screen, check out the `replayExpirationMillis` parameter in `WhileSubscribed`. It’s very handy in this situation and it also saves some memory, as the cached value is restored to the initial value defined in `stateIn`. Coming back to the app won’t be as snappy, but you won’t show old data.

> `replayExpirationMillis`— configures a delay (in milliseconds) between the stopping of the sharing coroutine and the resetting of the replay cache (which makes the cache empty for the `shareIn` operator and resets the cached value to the original `initialValue` for the `stateIn` operator). It defaults to `Long.MAX_VALUE` (keep replay cache forever, never reset buffer). Use zero value to expire the cache immediately.

## Observing StateFlow from the view

As we’ve seen so far, it’s very important for the view to let the StateFlows in the ViewModel know that they’re no longer listening. However, as with everything related to lifecycles, it’s not that simple.

In order to collect a flow, you need a coroutine. Activities and fragments offer a bunch of coroutine builders:

* `Activity.lifecycleScope.launch`: starts the coroutine immediately and cancels it when the activity is destroyed.
* `Fragment.lifecycleScope.launch`: starts the coroutine immediately and cancels it when the fragment is destroyed.
* `Fragment.viewLifecycleOwner.lifecycleScope.launch`: starts the coroutine immediately and cancels it when the fragment’s view lifecycle is destroyed. You should use the view lifecycle if you’re modifying UI.

## LaunchWhenStarted, launchWhenResumed…

Specialized versions of `launch` called `launchWhenX` will wait until the `lifecycleOwner` is in the X state and suspend the coroutine when the `lifecycleOwner` falls below the X state. It’s important to note that **they don’t cancel the coroutine until their lifecycle owner is destroyed**.

![](https://miro.medium.com/max/60/0*rlKJkDx0aSQrdhDO?q=20)

![](https://miro.medium.com/max/2400/0*rlKJkDx0aSQrdhDO)

Collecting Flows with `launch/launchWhenX` is unsafe

Receiving updates while the app is in the background could lead to crashes, which is solved by suspending the collection in the View. However, upstream flows are kept active while the app is in the background, possibly wasting resources.

This means that everything we’ve done so far to configure StateFlow would be quite useless; however, there’s a new API in town.

## lifecycle.repeatOnLifecycle to the rescue

This new coroutine builder (available from [lifecycle-runtime-ktx 2.4.0-alpha01](https://developer.android.com/jetpack/androidx/releases/lifecycle#2.4.0-alpha01)) does exactly what we need: it starts coroutines at a particular state and it stops them when the lifecycle owner falls below it.

![](https://miro.medium.com/max/2400/0*pDKnvDJ9FzaCgXCd)

Different Flow collection methods

For example, in a Fragment:

```kt
onCreateView(...) {
    viewLifecycleOwner.lifecycleScope.launch {
        viewLifecycleOwner.lifecycle.repeatOnLifecycle(STARTED) {
            myViewModel.myUiState.collect { ... }
        }
    }
}
```

This will start collecting when the view of the Fragment is `STARTED`, will continue through `RESUMED`, and will stop when it goes back to `STOPPED`. Read all about it in [A safer way to collect flows from Android UIs](/androiddevelopers/a-safer-way-to-collect-flows-from-android-uis-23080b1f8bda).

**Mixing the** `repeatOnLifecycle` **API with the StateFlow guidance above will get you the best performance while making a good use of the device’s resources.**

![](https://miro.medium.com/max/2400/0*AJokESYOHI4uxfWs)

StateFlow exposed with WhileSubscribed(5000) and collected with repeatOnLifecycle(STARTED)

> Warning: The [StateFlow support recently added to **Data Binding**](https://developer.android.com/topic/libraries/data-binding/observability#stateflow) uses `launchWhenCreated` to collect updates, and it will start using `repeatOnLifecycle` instead when it reaches stable.
> 
> For **Data Binding**, you should use Flows everywhere and simply add `asLiveData()` to expose them to the view. Data Binding will be updated when `lifecycle-runtime-ktx 2.4.0` goes stable.

## Summary

The best way to expose data from a ViewModel and collect it from a view is:

* ✔️ Expose a `StateFlow`, using the `WhileSubscribed` strategy, with a timeout. \[[example](https://gist.github.com/JoseAlcerreca/4eb0be817d8f94880dab279d1c27a4af)\]
* ✔️ Collect with `repeatOnLifecycle`. \[[example](https://gist.github.com/JoseAlcerreca/6e2620b5615425a516635744ba59892e)\]

Any other combination will keep the upstream Flows active, wasting resources:

* ❌ Expose using `WhileSubscribed`and collect inside `lifecycleScope.launch`/`launchWhenX`
* ❌ Expose using `Lazily`/`Eagerly` and collect with `repeatOnLifecycle`

Of course, if you don’t need the full power of Flow… just use LiveData. :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
