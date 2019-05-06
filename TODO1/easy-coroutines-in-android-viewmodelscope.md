> * 原文地址：[Easy Coroutines in Android: viewModelScope](https://medium.com/androiddevelopers/easy-coroutines-in-android-viewmodelscope-25bffb605471)
> * 原文作者：[Manuel Vivo](https://medium.com/@manuelvicnt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/easy-coroutines-in-android-viewmodelscope.md](https://github.com/xitu/gold-miner/blob/master/TODO1/easy-coroutines-in-android-viewmodelscope.md)
> * 译者：
> * 校对者：

# Easy Coroutines in Android: viewModelScope

![](https://cdn-images-1.medium.com/max/2560/1*8Dyf1lQkPqZa08juZk6lKw.png)

Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)

Cancelling coroutines when they are no longer needed can be a task easy to forget, it’s monotonous work and adds a lot of boilerplate code. `viewModelScope` contributes to [structured concurrency](https://kotlinlang.org/docs/reference/coroutines/basics.html#structured-concurrency) by adding an [extension property](https://kotlinlang.org/docs/reference/extensions.html#extension-properties) to the ViewModel class that automatically cancels its child coroutines when the ViewModel is destroyed.

**Disclaimer**: `viewModelScope` will be introduced in the AndroidX Lifecycle v2.1.0 which is currently in alpha. As it is in alpha, the API’s may change and there could be bugs. If you find one, please, report it [here](https://issuetracker.google.com/issues?q=componentid:413132).

### Scopes in ViewModels

A [CoroutineScope](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-scope/) keeps track of all coroutines it creates. Therefore, if you cancel a scope, you cancel all coroutines it created. This is particularly important if you’re running coroutines in a [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel). If your ViewModel is getting destroyed, all the asynchronous work that it might be doing must be stopped. Otherwise, you’ll waste resources and potentially leaking memory. If you consider that certain asynchronous work should persist after ViewModel destruction, it is because it should be done in a lower layer of your app’s architecture.

Add a CoroutineScope to your ViewModel by creating a new scope with a [SupervisorJob](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-supervisor-job.html) that you cancel in the `onCleared()` method. The coroutines created with that scope will live as long as the ViewModel is being used. See following code:

```
class MyViewModel : ViewModel() {

    /**
     * This is the job for all coroutines started by this ViewModel.
     * Cancelling this job will cancel all coroutines started by this ViewModel.
     */
    private val viewModelJob = SupervisorJob()
    
    /**
     * This is the main scope for all coroutines launched by MainViewModel.
     * Since we pass viewModelJob, you can cancel all coroutines 
     * launched by uiScope by calling viewModelJob.cancel()
     */
    private val uiScope = CoroutineScope(Dispatchers.Main + viewModelJob)
    
    /**
     * Cancel all coroutines when the ViewModel is cleared
     */
    override fun onCleared() {
        super.onCleared()
        viewModelJob.cancel()
    }
    
    /**
     * Heavy operation that cannot be done in the Main Thread
     */
    fun launchDataLoad() {
        uiScope.launch {
            sortList()
            // Modify UI
        }
    }
    
    suspend fun sortList() = withContext(Dispatchers.Default) {
        // Heavy work
    }
}
```

The heavy work happening in the background will be cancelled if the ViewModel gets destroyed because the coroutine was started by that particular `uiScope`.

But that’s a lot of code to be included in every ViewModel, right? `viewModelScope` comes to simplify all this.

### viewModelScope means less boilerplate code

[AndroidX lifecycle v2.1.0](https://developer.android.com/jetpack/androidx/releases/lifecycle) introduced the extension property `viewModelScope` to the ViewModel class. It manages the coroutines in the same way we were doing in the previous section. That code is cut down to this:

```
class MyViewModel : ViewModel() {
  
    /**
     * Heavy operation that cannot be done in the Main Thread
     */
    fun launchDataLoad() {
        viewModelScope.launch {
            sortList()
            // Modify UI
        }
    }
  
    suspend fun sortList() = withContext(Dispatchers.Default) {
        // Heavy work
    }
}
```

All the CoroutineScope setup and cancellation is done for us. To use it, import the following dependency in your `build.gradle` file:

```
implementation “androidx.lifecycle.lifecycle-viewmodel-ktx$lifecycle_version”
```

Let’s take a look at what’s happening under the hood.

### Digging into viewModelScope

The code is [publicly available in AOSP](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/viewmodel/ktx/src/main/java/androidx/lifecycle/ViewModel.kt). `viewModelScope` is implemented as follows:

```
private const val JOB_KEY = "androidx.lifecycle.ViewModelCoroutineScope.JOB_KEY"

val ViewModel.viewModelScope: CoroutineScope
    get() {
        val scope: CoroutineScope? = this.getTag(JOB_KEY)
        if (scope != null) {
            return scope
        }
        return setTagIfAbsent(JOB_KEY,
            CloseableCoroutineScope(SupervisorJob() + Dispatchers.Main))
    }
```

The ViewModel class has a `ConcurrentHashSet` attribute where it can store any kind of object. The CoroutineScope is stored there. If we take a look at the code, the method `getTag(JOB_KEY)` tries to retrieve the scope from there. If it doesn’t exist, then it creates a new CoroutineScope the same way we did before and adds the tag to the bag.

When the ViewModel is cleared, it executes the method `clear()` before calling the `onCleared()` method that we would’ve had to override otherwise. In the `clear()` method the ViewModel cancels the Job of the `viewModelScope.` The [full ViewModel code is also available](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/viewmodel/src/main/java/androidx/lifecycle/ViewModel.java) but we are just focusing on the parts we are interested in:

```
@MainThread
final void clear() {
    mCleared = true;
    // Since clear() is final, this method is still called on mock 
    // objects and in those cases, mBagOfTags is null. It'll always 
    // be empty though because setTagIfAbsent and getTag are not 
    // final so we can skip clearing it
    if (mBagOfTags != null) {
        for (Object value : mBagOfTags.values()) {
            // see comment for the similar call in setTagIfAbsent
            closeWithRuntimeException(value);
        }
    }
    onCleared();
}
```

The method goes through all the items in the bag and calls `closeWithRuntimeException` that checks if the object is of type `Closeable` and if so, closes it. In order for the ViewModel to close the scope, it needs to implement the `Closeable` interface. That’s why `viewModelScope` is of type `**CloseableCoroutineScope**` that extends `CoroutineScope` overriding the `coroutineContext` and implements the `Closeable` interface.

```
internal class CloseableCoroutineScope(
    context: CoroutineContext
) : Closeable, CoroutineScope {
  
    override val coroutineContext: CoroutineContext = context
  
    override fun close() {
        coroutineContext.cancel()
    }
}
```

### Dispatchers.Main as default

`Dispatchers.Main` is set as the default [CoroutineDispatcher](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-dispatcher/index.html) for `viewModelScope`.

```
val scope = CloseableCoroutineScope(SupervisorJob() + Dispatchers.Main)
```

`Dispatchers.Main` is a natural fit for this case since ViewModel is a concept related to UI that is often involved in updating it so launching on another dispatcher will introduce at least 2 extra thread switches. Considering that suspend functions will do their own thread confinement properly, going with other Dispatchers wouldn’t be an option since we’d be making an assumption of what the ViewModel is doing.

### Unit Testing viewModelScope

`Dispatchers.Main` uses the Android `Looper.getMainLooper()` method to run code in the UI thread. That method is available in Instrumented Android tests but not in Unit tests.

Use the `org.jetbrains.kotlinx:kotlinx-coroutines-test:$coroutines_version` library to replace the Main Dispatcher by calling `Dispatchers.setMain` with a single threaded executor. Don’t use `Dispatchers.Unconfined`, it will break all assumptions and timings for code that does use `Dispatchers.Main`. Since a unit test should run well in isolation and without any side effects, you should call `Dispatchers.resetMain()` and clean up the executor when the test finishes running.

You can use this JUnitRule with that logic to simplify your code:

```
@ExperimentalCoroutinesApi
class CoroutinesMainDispatcherRule : TestWatcher() {
  
  private val singleThreadExecutor = Executors.newSingleThreadExecutor()
  
  override fun starting(description: Description?) {
      super.starting(description)
      Dispatchers.setMain(singleThreadExecutor.asCoroutineDispatcher())
  }
  
  override fun finished(description: Description?) {
      super.finished(description)
      singleThreadExecutor.shutdownNow()
      Dispatchers.resetMain()
  }
}
```

Now, you can use it in your Unit Tests.

```
class MainViewModelUnitTest {
  
    @get:Rule
    var coroutinesMainDispatcherRule = CoroutinesMainDispatcherRule()
  
    @Test
    fun test() {
        ...
    }
}
```

Notice that this is likely to change. There is an effort to integrate [TestCoroutineContext](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.test/-test-coroutine-context/) with structured concurrency. For more information, take a look at the issue [here](https://github.com/Kotlin/kotlinx.coroutines/issues/541).

* * *

If you are using architecture components, ViewModel and coroutines, use `viewModelScope` to let the framework manage its lifecycle for you. It’s a no brainer!

The [Coroutines codelab](https://codelabs.developers.google.com/codelabs/kotlin-coroutines) has been already updated to use it. Check it out to find out more about Coroutines and how to use them in an Android app.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
