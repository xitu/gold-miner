> * 原文地址：[Easy Coroutines in Android: viewModelScope](https://medium.com/androiddevelopers/easy-coroutines-in-android-viewmodelscope-25bffb605471)
> * 原文作者：[Manuel Vivo](https://medium.com/@manuelvicnt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/easy-coroutines-in-android-viewmodelscope.md](https://github.com/xitu/gold-miner/blob/master/TODO1/easy-coroutines-in-android-viewmodelscope.md)
> * 译者：[twang1727](https://github.com/twang1727)

# Android中的简易协程：viewModelScope

![](https://cdn-images-1.medium.com/max/2560/1*8Dyf1lQkPqZa08juZk6lKw.png)

[Virginia Poltrack](https://twitter.com/vpoltrack) 绘图

取消不再需要的协程（coroutine）是件容易被遗漏的任务，它既枯燥又会引入大量模版代码。`viewModelScope` 对[结构化并发](https://kotlinlang.org/docs/reference/coroutines/basics.html#structured-concurrency) 的贡献在于将一项[扩展属性](https://kotlinlang.org/docs/reference/extensions.html#extension-properties)加入到 ViewModel 类中，从而在 ViewModel 销毁时自动地取消子协程。 

**声明**：`viewModelScope` 将会在尚在 alpha 阶段的 AndroidX Lifecycle v2.1.0 中引入。正因为在 alpha 阶段，API 可能会更改，可能会有 bug。点[这里](https://issuetracker.google.com/issues?q=componentid:413132)报错。

### ViewModel的作用域

[CoroutineScope](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-scope/) 会跟踪所有它创建的协程。因此，当你取消一个作用域的时候，所有它创建的协程也会被取消。当你在 [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) 中运行协程的时候这一点尤其重要。如果你的 ViewModel 即将被销毁，那么它所有的异步工作也必须被停止。否则，你将浪费资源并有可能泄漏内存。如果你觉得某项异步任务应该在 ViewModel 销毁后保留，那么这项任务应该放在应用架构的较低一层。

创建一个新作用域，并传入一个将在 `onCleared()` 方法中取消的 [SupervisorJob](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-supervisor-job.html)，这样你就在 ViewModel 中添加了一个 CoroutineScope。此作用域中创建的协程将会在 ViewModel 使用期间一直存在。代码如下：

```
class MyViewModel : ViewModel() {

    /**
     * 这是此 ViewModel 运行的所有协程所用的任务。
     * 终止这个任务将会终止此 ViewModel 开始的所有协程。
     */
    private val viewModelJob = SupervisorJob()
    
    /**
     * 这是 MainViewModel 启动的所有协程的主作用域。
     * 因为我们传入了 viewModelJob，你可以通过调用viewModelJob.cancel() 
     * 来取消所有 uiScope 启动的协程。
     */
    private val uiScope = CoroutineScope(Dispatchers.Main + viewModelJob)
    
    /**
     * 当 ViewModel 清空时取消所有协程
     */
    override fun onCleared() {
        super.onCleared()
        viewModelJob.cancel()
    }
    
    /**
     * 没法在主线程完成的繁重操作
     */
    fun launchDataLoad() {
        uiScope.launch {
            sortList()
            // 更新 UI
        }
    }
    
    suspend fun sortList() = withContext(Dispatchers.Default) {
        // 繁重任务
    }
}
```

当 ViewModel 销毁时后台运行的繁重操作会被取消，因为对应的协程是由这个 `uiScope` 启动的。

但在每个 ViewModel 中我们都要引入这么多代码，不是吗？我们其实可以用 `viewModelScope` 来进行简化。

### viewModelScope 可以减少模版代码

[AndroidX lifecycle v2.1.0](https://developer.android.com/jetpack/androidx/releases/lifecycle) 在 ViewModel 类中引入了扩展属性 `viewModelScope`。它以与前一小节相同的方式管理协程。代码则缩减为：

```
class MyViewModel : ViewModel() {
  
    /**
     * 没法在主线程完成的繁重操作
     */
    fun launchDataLoad() {
        viewModelScope.launch {
            sortList()
            // 更新 UI
        }
    }
  
    suspend fun sortList() = withContext(Dispatchers.Default) {
        // 繁重任务
    }
}
```

所有的 CoroutineScope 创建和取消步骤都为我们准备好了。使用时只需在 `build.gradle` 文件导入如下依赖：

```
implementation “androidx.lifecycle.lifecycle-viewmodel-ktx$lifecycle_version”
```

我们来看一下底层是如何实现的。

###  深入viewModelScope

[AOSP有分享](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/viewmodel/ktx/src/main/java/androidx/lifecycle/ViewModel.kt)的代码。`viewModelScope` 是这样实现的：

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

ViewModel 类有个 `ConcurrentHashSet` 属性来存储任何类型的对象。CoroutineScope 就存储在这里。如果我们看下代码，`getTag(JOB_KEY)` 方法试图从中取回作用域。如果取回值为空，它将以前文提到的方式创建一个新的 CoroutineScope 并将其加标签存储。

当 ViewModel 被清空时，它会运行 `clear()` 方法进而调用如果不用 viewModelScope 我们就得重写的 `onCleared()` 方法。在 `clear()` 方法中，ViewModel 会取消 `viewModelScope` 中的任务。[完整的 ViewModel 代码在此](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/viewmodel/src/main/java/androidx/lifecycle/ViewModel.java)，但我们只会讨论大家关心的部分：

```
@MainThread
final void clear() {
    mCleared = true;
    // 因为 clear() 是 final 的，这个方法在模拟对象上仍会被调用，
    // 且在这些情况下，mBagOfTags 为 null。但它总会为空，
    // 因为 setTagIfAbsent 和 getTag 不是
    // final 方法所以我们不用清空它。
    if (mBagOfTags != null) {
        for (Object value : mBagOfTags.values()) {
            // see comment for the similar call in setTagIfAbsent
            closeWithRuntimeException(value);
        }
    }
    onCleared();
}
```

这个方法遍历所有对象并调用 `closeWithRuntimeException`，此方法检查对象是否属于 `Closeable` 类型，如果是就关闭它。为了使作用域被 ViewModel 关闭，它应当实现 `Closeable` 接口。这就是为什么 `viewModelScope` 的类型是 **`CloseableCoroutineScope`**，这一类型扩展了 `CoroutineScope`、重写了 `coroutineContext` 并且实现了 `Closeable` 接口。

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

### 默认使用 Dispatchers.Main

`Dispatchers.Main` 是 `viewModelScope` 的默认 [CoroutineDispatcher](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-dispatcher/index.html)。

```
val scope = CloseableCoroutineScope(SupervisorJob() + Dispatchers.Main)
```

`Dispatchers.Main` 在此合用是因为 ViewModel 与频繁更新的 UI 相关，而用其他的派发器就会引入至少2个线程切换。考虑到挂起方法自身有线程封闭机制，使用其他派发器并不合适，因为我们不想去取代 ViewModel 已有的功能。

### 单元测试 viewModelScope

`Dispatchers.Main` 利用 Android 的 `Looper.getMainLooper()` 方法在 UI 线程执行代码。这个方法在 Instrumented Android 测试中可用，在单元测试中不可用。

借用 `org.jetbrains.kotlinx:kotlinx-coroutines-test:$coroutines_version` 库，调用 `Dispatchers.setMain` 并传入一个 singleThreadExecutor 来替换主派发器。不要用`Dispatchers.Unconfined`，它会破坏使用 `Dispatchers.Main` 的代码的所有假设和时间线。因为单元测试应该在隔离状态下运行完好且不造成任何副作用，所以当测试完成时，你应该调用 `Dispatchers.resetMain()` 来清理执行器。

你可以用以下体现这一逻辑的 JUnitRule 来简化你的代码。

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

现在，你可以把它加入你的单元测试了。

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

请注意这是有可能变的。[TestCoroutineContext](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.test/-test-coroutine-context/) 与结构化并发集成的工作正在进行中，详细信息请看这个 [issue](https://github.com/Kotlin/kotlinx.coroutines/issues/541)。

* * *

如果你使用 ViewModel 和协程, 通过 `viewModelScope` 让框架管理生命周期吧！不用多考虑了！

[Coroutines codelab](https://codelabs.developers.google.com/codelabs/kotlin-coroutines) 已经更新并使用它了。学习一下怎样在 Android 应用中使用协程吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
