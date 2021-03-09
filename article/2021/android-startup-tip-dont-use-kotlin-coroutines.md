> * 原文地址：[Android App Startup Tip: Don’t Use Kotlin Coroutines](https://medium.com/specto/android-startup-tip-dont-use-kotlin-coroutines-a7b3f7176fe5)
> * 原文作者：[Nathanael](https://medium.com/@nathanaelsilverman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/android-startup-tip-dont-use-kotlin-coroutines.md](https://github.com/xitu/gold-miner/blob/master/article/2021/android-startup-tip-dont-use-kotlin-coroutines.md)
> * 译者：
> * 校对者：

# Android App Startup Tip: Don’t Use Kotlin Coroutines

> I’ve retracted the conclusion reached in this article. The measurements were made on a debuggable app and differ surprisingly from production performance: [Don’t Run Benchmarks on a Debuggable Android App (Like I Did)](https://medium.com/specto/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did-34d95331cabb)

Did you know that there is a significant initialization cost to Kotlin coroutines? Well, maybe not significant in all cases, but when it comes to app startup, every millisecond boost is worth taking. I found that simply launching the first coroutine can take over 100ms. 😱

Most applications perform a variety of tasks on startup: initializing third-party libraries, setting up services or periodic jobs, making HTTP requests to fetch data… Some must happen synchronously on the main thread, the rest can be offloaded to background threads in order to speed up the app’s startup and keep it responsive. With Kotlin coroutines being [officially recommended](https://developer.android.com/guide/background#recommended-solutions) for background processing on Android, it would be tempting to use them during startup as well, for example:

```Kotlin
class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        
        // Tasks that must happen synchronously.

        CoroutineScope(Dispatchers.Default).launch {
            // Everything else.
        }
    }
}
```

On a Moto G6 running Android 9—a low-end device by 2020 standards—the line CoroutineScope(Dispatchers.Default).launch { … } blocks the main thread for 110±18ms on average (n=10, coroutines version `1.4.2`), regardless of the contents of the coroutine itself. Let’s see what’s going on. Here is a trace captured using the Android Profiler:

![](https://cdn-images-1.medium.com/max/5704/1*FfmgrEmOMqF6Hj1enUdvig.png)

About 15% of the time is spent creating the `CoroutineScope`. 30% is spent creating `Dispatchers.Default`. And 55% is the actual `launch` call. So there isn’t any single cause. We can see `kotlin.random.Random.\<clinit>` (the static initializer) taking a large proportion of the `launch` call, perhaps that could be avoided. But as users of the public API it’s not clear what we could do here.

Prior to Kotlin coroutines, the main recommendation for background threads was to [use an `ExecutorService`](https://developer.android.com/guide/background/threading#creating-multiple-threads), for example:

```Kotlin
class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        
        // Tasks that must happen synchronously.

        Executors.newSingleThreadExecutor().execute {
            // Everything else.
        }
    }
}
```

On the same device, creating the `ExecutorService` and queuing the execution took **1ms** on average, compared to 110ms for coroutines. I found this held true for all the`Executors` factory methods (they make it possible to use various types of thread pools). 🚀

As pointed out by [Jake Wharton](https://twitter.com/JakeWharton/status/1347260917097107456), the difference is partly due to `ExecutorService` being preloaded by the Zygote, a special part of the Android framework that shares code between processes. Other concurrency frameworks which, like coroutines, aren’t preloaded, will also have a comparatively high initialization cost.

That said, coroutines have a lot of advantages over `ExecutorService`. They’ve got scopes, suspending functions, they’re much more lightweight than threads, etc. The general recommendation to use them in Android applications is sound, but their impressive feature set has an initialization cost at the moment. Perhaps the Kotlin and Android teams will be able to optimize this in the future. Until then, best to avoid using coroutines in your `Application` class, or in your main `Activity`, if startup time is a primary concern.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
