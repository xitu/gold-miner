> * 原文地址：[Don’t Run Benchmarks on a Debuggable Android App (Like I Did for Coroutines)](https://medium.com/specto/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did-34d95331cabb)
> * 原文作者：[Nathanael](https://medium.com/@nathanaelsilverman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did.md)
> * 译者：
> * 校对者：

# Don’t Run Benchmarks on a Debuggable Android App (Like I Did for Coroutines)

Last week I wrote about how [Kotlin coroutines can take over 100ms to initialize on Android](https://medium.com/specto/android-startup-tip-dont-use-kotlin-coroutines-a7b3f7176fe5). [Knuttyse](undefined) asked if I used an “optimized production build” for my measurements and the truth is I had not. I thought, how big of a difference can it make anyway? So I tried, and it made a 1000% difference.

![By [Alex E. Proimos](https://www.flickr.com/photos/proimos/4199675334/) — [CC BY 2.0](https://commons.wikimedia.org/w/index.php?curid=22535544)](https://cdn-images-1.medium.com/max/2048/1*W1KWLWBcLKVYLKYI0r1sYg.jpeg)

For my initial measurement I’d used a debug build. This time I started with a release build and enabled minification and resource shrinking. I ran the same bit of code as before:

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

On a Moto G6 running Android 9, where launching the coroutine had blocked the main thread for 110±18ms on average using a debug build, it now took 9±1ms (n=10, coroutines version `1.4.2`). I thought, wow, I owe the Kotlin folks an apology, but also, what’s going on? Is code minification that good?

Nope, in this case, turning off minification slowed things down to 14±1ms. Still much faster than a debug build. I started researching the differences between debug and release builds but found nothing that would account for that big a difference. So I asked around, and some friendly engineers (thank you Romain Guy, cketti and John Reck) explained that it’s not strictly speaking a build difference, it’s that debug builds are generally configured to be debuggable, which in turn changes the runtime behavior. Let’s break things down.

“debug” is one of two default built types for Android, the other being “release”. The debug build type, unless modified, sets the “debuggable” setting to `true`. Any build type can be configured to do this, including release. The debuggable setting does not affect the compilation process, but makes it possible to attach the debugger to the application. Now, I knew that actually attaching the debugger would slow things down, I hadn’t realized that enabling the **possibility** of attaching the debugger would as well. Why? Well, as I understand it, the application must prepare itself in case the debugger is attached: certain runtime optimizations can’t be applied, metadata has to be continuously collected, etc.

Anyway, I decided to measure all the things (values are averages with n=10):

* Non-debuggable, minified release build: 9±1ms
* Non-debuggable, **non-minified** release build: 14±1ms
* **Debuggable**, **minified** release build: 45±5msI
* Debuggable, **non-minified** release build: 92±2ms
* Debuggable, non-minified **debug** build: 93±5ms

First, I was delighted to find that my phone had become 15% faster than the previous week, as the average duration for a (debuggable) debug build was now 93ms rather than 110ms. This can happen, of course, and simply shows that benchmark comparisons should be done in as similar an environment as possible. It also confirmed that the debuggable and minification settings were the only performance differentiators between the default build types. What else can we take away here?

Assuming your release builds are not debuggable (the default), **then Kotlin coroutines do not take over 100ms to initialize on Android,** as I had previously claimed. At least not on my device, and probably not on any device that is commonly used. They may take 15ms or so, but that’s probably not worth sweating over. My apologies for the confusion. 🙇‍♂️

Also worth noting, enabling the debuggable setting increased the duration of the coroutines initialization by 650%. This is much more than the general 0**‑**80% range [reported by Android performance engineers](https://youtu.be/ZffMCJdA5Qc?t=635). When not using the debugger, you can turn off debuggable for some serious speed gains.

Finally, the lesson I’ve learned the hard way: **never run benchmarks on a debuggable application.** The Android documentation briefly mentions this in the context of the [new benchmarking library](https://developer.android.com/studio/profile/benchmark#configuration-errors), but I didn’t know it could have such an impact. Did you? Even the Android Profiler is used with debuggable applications, meaning time measurements taken during profiling will not be representative of production performance.

---

Wish you could easily monitor your app’s performance? In production, with debuggable turned off and less than 5% overhead? [You got it!](https://specto.dev)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
