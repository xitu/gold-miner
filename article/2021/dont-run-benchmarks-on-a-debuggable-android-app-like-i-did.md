> - 原文地址：[Don’t Run Benchmarks on a Debuggable Android App (Like I Did for Coroutines)](https://medium.com/specto/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did-34d95331cabb)
> - 原文作者：[Nathanael](https://medium.com/@nathanaelsilverman)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dont-run-benchmarks-on-a-debuggable-android-app-like-i-did.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[5Reasons](https://github.com/5Reasons)

# 不要在可调试的 Android App 上运行基准测试 (就像我对协程做的那样)

上周我写了一篇关于 [Kotlin 协程在 Android 上初始化耗时超过 100ms](https://medium.com/specto/android-startup-tip-dont-use-kotlin-coroutines-a7b3f7176fe5)。Knuttyse 问我是否使用了“生产构建优化”来进行测试，然而实际上我并没有这么做。我本以为这不会有太大的区别，所以我尝试了一下，没想到差别大到难以想象。

![图源 [Alex E. Proimos](https://www.flickr.com/photos/proimos/4199675334/) — [CC BY 2.0](https://commons.wikimedia.org/w/index.php?curid=22535544)](https://cdn-images-1.medium.com/max/2048/1*W1KWLWBcLKVYLKYI0r1sYg.jpeg)

一开始我在调试版本下进行测试，这次我们从发行版本开始，启用了代码缩减和资源缩减，运行相同的代码：

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

在运行 Android 9 的 Moto G6 上测试该应用（调试版本），启动协程平均阻塞主线程 110±18ms，如果是发行版本只需要 9±1ms（n=10, 协程版本 `1.4.2`）。我想我欠开发协程的人们一个道歉，但同时我也好奇到底发生什么，代码缩减有那么好吗？

答案是否定的，在这种情况下，关闭代码缩减会使阻塞时间减低到 14±1ms。仍然比调试版本快得多。我开始研究调试版本和发行版本之间的差异，但没有发现任何可以解释这个巨大的差异。所以我四处询问，一些友好的工程师（感谢 Romain Guy，cketti 和 John Reck）解释说，严格来说这不是构建的区别，调试构建通常被配置为可调试的，这反过来改变了运行时的行为。让我们深入分析一下。

“debug” 是 Android 中默认两种构建方式之一，另一种是 “release”。除非修改过，否则调试构建类型会将 “debuggable” 设置为`true`。任何构建类型都可以这样配置，包括 “release”。可调试的设置不会影响编译过程，但是可以将调试器附加到应用程序。现在我知道实际上附加调试器会减慢速度，但之前却没有意识到启用附加调试器**可能**也会如此。为什么呢？个人觉得，因为应用程序必须做好准备去附加调试器，导致某些运行时的优化不能被应用，必须不断收集元数据，等等。

无论如何，我决定测试所有场景（十次统计平均耗时）：

- Non-debuggable, minified release 构建：9±1ms
- Non-debuggable, **non-minified** 构建：14±1ms
- **Debuggable**, **minified** release 构建：45±5ms
- Debuggable, **non-minified** release 构建：92±2ms
- Debuggable, non-minified **debug** 构建：93±5ms

首先，我很高兴地发现我的手机比前一周快了 15%，一个（可调试的）调试版本的平均耗时现在是 93ms，而不是110ms。当然，这是可能发生的，这只是说明应该在尽可能相似的环境中进行基准比较。它还证实了可调试和代码缩减设置是默认构建类型之间唯一的性能差异。除此之外我们还能得出什么结论呢？

假设你的发行版本是不可调试的（默认设置），正如我之前所说的，**Kotlin 协程在 Android 上初始化所需的时间基本不会超过 100ms**。至少在我的设备上，上述数据是成立的，我认为这个结论也适用于现在大部分常用的设备。Kotlin 协程的初始化可能需要 15ms 左右的时间，这么短的耗时可以说是无足轻重的。对于开头提到的、我之前写的那篇文章所造成的误解，我深感抱歉。🙇‍♂️

同样值得注意的是，启用可以调试模式会导致协程的初始化时间增加 650%。远远超出了[Android 性能工程师报告](https://youtu.be/ZffMCJdA5Qc?t=635)的 0**‑**80%。当不使用调试器时，你可以关闭调试模式以提高速度。

最后，经历了这次惨痛的教训：**永远不要在可调式的应用程序上运行基准测试**。Android 文档在[新的基准库](https://developer.android.com/studio/profile/benchmark#configuration-errors)上简单地提了一下，但是我没想到它会产生这样的影响。你呢？甚至 Android Profiler 也用于可调试的应用程序，这意味着在分析过程中所采取的时间度量将不能代表生产性能。

------

如果你希望轻松地监控你的应用程序的性能？在生产环境中，关闭可调试模式，并且开销不到 5%？[你说对了！](https://specto.dev)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
