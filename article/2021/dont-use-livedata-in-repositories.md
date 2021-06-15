> * 原文地址：[Don’t use LiveData in Repositories](https://proandroiddev.com/dont-use-livedata-in-repositories-f3bebe502ed3)
> * 原文作者：[Jossi Wolf](https://medium.com/@jossiwolf)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dont-use-livedata-in-repositories.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dont-use-livedata-in-repositories.md)
> * 译者：
> * 校对者：

# Don’t use LiveData in Repositories

We recently joined a new project with heavy `LiveData` usage, everywhere. The search for main thread blockages led us down a rabbit hole of removing a significant portion of our `LiveData` usages.

## Our Setup

We started off with Repositories, ViewModels and Fragments. The repositories would connect to data sources and expose `LiveData`. The ViewModels would then expose the `LiveData` to the UI Layer.

![Our setup visualised.](https://cdn-images-1.medium.com/max/2000/1*McrUxX5rrk13bH474ttPdA.png)

Now — there are some issues with this, like the actually unneeded abstraction — but we won’t look at that here. Here’s what a typical Repository would look like:

```Kotlin
class SupermarketRepository(
    private val poiService: POIService,
    private val inStockDAO: InStockDAO
) {
 
    fun fetchOpeningHours(id: SupermarketId): LiveData<OpenHoursInformation> {
        val liveData = MutableLiveData<OpenHoursInformation>()
        val openingHours = poiService.downloadOpeningHours(poiType = SUPERMARKET, id).enqueue(
            object: Callback<OpenHoursInformation>() {
                override fun onResponse(call: Call<OpenHoursInformation>, response: Response<OpenHoursInformation>) {
                    liveData.postValue(response.body())
                }
                
                ...

            }
        )
        liveData.postValue(openingHours)
        return liveData
    }
 
    fun inStockChanges(itemType: ItemType = ToiletPaper): LiveData<InStockInformation> =
        inStockDAO.inStockInformationLiveData()
            .map { it.itemType == itemType }
    
}
```

From there, we used it in ViewModels:

```Kotlin
class HelpViewModel(
    private val supermarketRepo: SupermarketRepository
): ViewModel() {
    
    fun fetchSupermarketOpeningHours(id: SupermarketId) = 
        handleLiveData(
          map(supermarketRepo.fetchOpeningHours(id)) { openingHours ->
            openingHours.hours.filter { it != null }
          }
        )
    
}
```

The code didn’t look too great, but still okay. There is one big issue here though — and it’s not visible on first sight.

`handleLiveData` was a simple helper function that took a `LiveData` and emitted a loading state before the actual data was emitted. But at some point, we needed to run some transformations on the `LiveData`. Creating a `MediatorLiveData` every time is quite verbose, but luckily, there is the [`Transformations` package](https://developer.android.com/reference/androidx/lifecycle/Transformations) for `LiveData` . It offers methods like `map` and `switchMap` for `LiveData`.

## LiveData and Threading

![Android icon made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](http://www.flaticon.com/), then lovingly put together in Google Drawings by me.](https://cdn-images-1.medium.com/max/2000/1*xVPBlF0xzcxZpfT1TMb5Tw.png)

Soon after joining the project, we realised that we had a lot of Main Thread blocks in our app, so we went to investigate. Looking at our code and looking at `LiveData` documentation, we learned that `LiveData` observers are **always** called on the main thread.

This can be very helpful since `LiveData` is often used in the UI Layer. Whenever a new value comes through, you probably want to be on the main thread anyways to display that data. But this threading behavior also shot us in the foot.

### The Transformation Methods

Looking at the code underneath, our `map` function looked like this:

```Kotlin
fun <T, R> map(source: LiveData<T>, mapper: (T) -> R): LiveData<R> {
    val result = MediatorLiveData<R>()
    result.addSource(source) {
        result.value = mapper.invoke(it)
    }
    return result
}
```

Coming back to our threading behavior, the callback on line 4 above is called whenever the `source` emits a value. In the callback, we assign the `MediatorLiveData` ‘s value to the result of the `mapper` lambda.

Since the callback simply is a `LiveData` observer, it gets called on the main thread as well. Without actually noticing, we just switched threads! That’s not exactly a great thing: If you are on the main thread, you don’t want to run any long-running operations, if you are on a background thread, you don’t want to do any UI mutations.
So in this example, our `mapper` lambda gets invoked on the main thread. Just doing some data transformations might not be noticeable, but what if you’re running some more complicated operations? Maybe reading something from the database?

```Kotlin
class HelpViewModel(
    private val supermarketRepo: SupermarketRepository,
    private val filterDataDAO: FilterDataDAO
): ViewModel() {
    
    fun fetchSupermarketOpeningHours(id: SupermarketId) = 
        handleLiveData(
          map(supermarketRepo.fetchOpeningHours(id)) { openingHours ->
            val filters = filterDataDAO.getFilters()
            val filteredHours = openingHours.hours.filter { filter.runFor(it) }
            return@map filteredHours
          }
        )
    
}
```

So we learned to be extremely cautious about threading when running transformations on `LiveData`. We fixed it afterwards — you can learn how in the next part of this post, coming soon.

### How this even happened

Ideally, this wouldn’t have happened in the first place. The `LiveData` documentation clearly states that observers are called on the main thread, so that would have been a great indicator for the previous developer. But sometimes, time-pressure is high, or you might miss something. It happens to everyone and I’m sure there are many codebases out there that look worse than ours.

The [Guide to App Architecture](https://developer.android.com/jetpack/guide#show-in-progress-operations) also recommends using `LiveData` in Repositories. Lots of developers will have followed this advice, possibly bringing main thread blockages to their apps.

The other mechanism that should have helped catch this are the Support Annotations. The methods provided by the `Transformations` package are annotated with `@MainThread` , which tells Android Studio that that method should only be called from the main thread. Similarly, there’s also [`@WorkerThread` and some more](https://developer.android.com/studio/write/annotations.html#thread-annotations).

```Java
@MainThread
@NonNull
public static <X, Y> LiveData<Y> map(
    @NonNull LiveData<X> source,
    @NonNull final Function<X, Y> mapFunction
) {
    final MediatorLiveData<Y> result = new MediatorLiveData<>();
    result.addSource(source, new Observer<X>() {
        @Override
        public void onChanged(@Nullable X x) {
            result.setValue(mapFunction.apply(x));
        }
    });
    return result;
}
```

Android Studio will complain if you’re calling a function/method/class that’s also annotated with a Thread Annotation, like this one:

```Kotlin
@WorkerThread
suspend fun loadAllSupermarkets(radius: Meters) = 
    poiService.fetchPOIs(poiType = Supermarket, radius = radius.asNumber)
```

In our case, those annotations weren’t used, so Android Studio didn’t have a chance to catch these mistakes. If you’re doing something slightly funky with threading, or you are unsure about it, it definitely makes sense to use the Thread Annotations to make things more explicit.

Coming back to the methods offered by the `Transformations` package, I believe that it shouldn’t call the transformers on the main thread in any case. Transformations most probably shouldn’t be happening in the UI layer in any case, so running them on the main thread doesn’t make lots of sense.

### A (quick) attempt at fixing the issue

So we needed a quick fix, because who wants to ship apps with main thread blockages?

A really quick fix would look something like this:

```Kotlin
fun <T, R> map(source: LiveData<T>, mapper: (T) -> R): LiveData<R> {
    val result = MediatorLiveData<R>()
    result.addSource(source) {
        AppExecutors.background().execute { 
            val mappedValue = mapper(it)
            AppExecutors.mainThread().execute { 
                result.value = mappedValue
            }
        }
    }
    return result
}
```

We make sure that we call the `mapper` on a background thread and then set the value from the main thread. This might seem a bit complicated but `LiveData#setValue` has to be called from the main thread. Alternatively, we could use `LiveData#postValue` , but this might lead to unexpected behavior like [values being swallowed](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData#postValue(T)).
Obviously, this is all not great, but it works as a quick fix to help with some main thread blocks.

### LiveData and Repositories

Apart from the other points, `LiveData` is tied to the Android Lifecycle. This can be a great thing, especially when communicating between ViewModel and components like Activities or Fragments.

The way `LiveData` is architected, observing it mostly makes sense from the UI layer. Even when using `[LiveData#observeForever](https://developer.android.com/reference/android/arch/lifecycle/LiveData#observeforever)` which isn’t bound to a lifecycle, the observer is called on the main thread, so that every time you would have to make sure you’re on the right thread for what you want to do.
Repositories should be kept free of framework dependencies, and with that also `LiveData` since it is tied to the lifecycle.

### Flow to the rescue!

[Coroutines Flow](https://kotlinlang.org/docs/reference/coroutines/flow.html) are an awesome alternative here. `Flow`s offer similar functionality: Builders, cold streams, and useful helpers for e.g. transforming data. Unlike `LiveData`, they are not bound to the lifecycle and offer more control over the execution context, which [Roman Elizarov](undefined) wrote a [great post](https://medium.com/@elizarov/execution-context-of-kotlin-flows-b8c151c9309b) about.

![Where we’d put our Flows! :)](https://cdn-images-1.medium.com/max/2000/1*GdQRI793PSKbDiN36_nXmg.png)

Concluding, threading is always something to really look out for. Try to make it explicit which thread you are and should be on, e.g. by using the [Thread Annotations](https://developer.android.com/studio/write/annotations.html#thread-annotations). 
The “real” culprit here is `LiveData` though. Not everybody might be aware of the fact that `LiveData` observers are always called on the main thread, so it is something to make sure you’re good with when using `LiveData`.

With that, calling data transformation methods on the main thread is probably unexpected behavior for most developers and should be made more aware of (which this post hopefully helps with).

I’d recommend using `LiveData` only for communication between ViewModels and the UI Layer where observers being called on the main thread makes more sense.

**Watch this space for the second part — migrating from `LiveData` to Coroutines and Flow!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
