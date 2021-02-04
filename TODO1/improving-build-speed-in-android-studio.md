> * 原文地址：[Improving build speed in Android Studio](https://medium.com/androiddevelopers/improving-build-speed-in-android-studio-3e1425274837)
> * 原文作者：[Android Developers](https://medium.com/@AndroidDev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/improving-build-speed-in-android-studio.md](https://github.com/xitu/gold-miner/blob/master/TODO1/improving-build-speed-in-android-studio.md)
> * 译者：[qiuyuezhong](https://github.com/qiuyuezhong) 
> * 校对者：[csming1995](https://github.com/csming1995) 

# 改善 Android Studio 的构建速度

**由 Android Studio 产品经理 Leo Sei 发布**

![](https://cdn-images-1.medium.com/max/2048/1*_aiGAO6qGx71h8VOZpo2ww.png)

## 改善构建速度

在 Android Studio 中，我们希望让你成为最高效的开发者。通过与开发者的讨论和调查，我们了解到缓慢的构建速度会降低生产力。

在这篇文章中，我们将分享一些新的分析方法，以便更好的指出是什么真正影响了构建速度，并分享一些我们正在为此所作的工作，以及你能做些什么来防止构建速度变慢。

* **感谢很多开发者选择在 “preference > data sharing” 中与我们共享他们的使用统计信息，使得这件事情变得可能。**

## 不同的速度测量方式

我们做的第一件事情是使用开源项目（[SignalAndroid](https://github.com/signalapp/Signal-Android/archive/v4.19.1.zip), [Tachiyomi](https://github.com/inorichi/tachiyomi/archive/014bb2f42634765ae2fec487cf3b8dc779f23f7b.zip), [SantaTracker](https://github.com/google/santa-tracker-android) & skeleton of [Uber](https://github.com/kageiit/android-studio-gradle-test.git)）来创建内部 benchmark，用于测量各种修改（代码，资源，manifest 等）对于项目构建速度的影响。

例如，这是一个研究代码更改对构建速度影响的 benchmark，可以看出，随着时间的推移，构建速度有很大的改善。

![](https://cdn-images-1.medium.com/max/2404/0*HgKjMF_Usu73_ihR)

我们还研究了真实的数据，主要关注 Android Gradle 插件升级前后构建调试版本的速度。我们用它来体现新版本上构建速度的实际提升。

这表明了在新版本上，构建速度确实改善了很多，自 2.3 版本以来，构建时间提升了将近 50%。

![](https://cdn-images-1.medium.com/max/2992/0*l55G21vNHzBc-D7D)

最后，我们在忽略版本变化的情况下，研究了构建时间随着时间的演变。我们用它来表示实际构建速度随时间的变化。遗憾的是，结果表明了构建速度是随着时间的推移而减慢的。

![](https://cdn-images-1.medium.com/max/2400/0*6_PsXttatVBSBJdd)

如果每个版本的构建速度确实越来越快，并且我们可以在数据中看到，那么为什么它们会随着时间的推移而变得越来越慢呢？

我们在更深入的研究之后，意识到在我们的生态系统中发生的事情正在导致构建速度减慢，减慢的速度比我们提升的速度更快。

虽然我们知道随着项目的迭代，代码的增加、资源的使用、语言特性的增加，使项目的构建速度越来越慢，但我们还发现，还有许多其他因素超出了我们的直接控制范围：

1. 2017 年末的 **[Spectre 和 Meltdown](https://meltdownattack.com/) 补丁**对新流程和 I/O 产生了一定影响，使清除构建的速度减慢了 50% 到 140% 之间。
2. **第三方和客制化的 Gradle 插件**：96% 的 Android Studio 开发者使用一些额外的 Gradle 插件（其中一些并没有采用[最新的最佳实践](https://developer.android.com/studio/build/optimize-your-build)）。
3. 大多数使用的**注释处理器都是非增量化的**，每次进行编辑时都会导致代码重新全量编译。
4. **使用 Java 8** 语言特性会导致需要执行去语法糖操作，这将影响构建时间。然而，我们已经用 D8 降低了去语法糖操作的影响。
5. **使用Kotlin**，尤其是 Kotlin（KAPT）中的注释处理，也会影响构建性能。我们将继续与 JetBrains 合作，以将影响降至最低。

* **和真实的项目不同，那些项目的构建时间不会随着时间的推移而增长。Benchmark 模拟更改，然后撤销更改，仅测量我们的插件随时间推移而受到的影响。**

* **3.3 版本专注于未来改善的基础工作（例如，名称空间资源、增量注释处理器支持、Gradle workers），因此提升了 0%。**

## 我们在做什么？

> 确定内部流程并持续提升性能。

我们也承认，许多问题来自于谷歌拥有的和推广的功能，我们改变了内部流程，以便在发布过程的早期更好地获得构建反馈。

我们还致力于让[注释处理器增量化](https://developer.android.com/studio/build/optimize-your-build#annotation_processors)。截至目前，Glide、Dagger 和 Auto Service 都是增量化的，并且我们还在研究其他的。

在最近的版本中，我们还加入了 R light class generation、lazy task 和 worker API，并继续与 Gradle Inc. 和 JetBrains 合作，以持续改善总体构建性能。

> 属性工具

最近的一项调查显示，约 60% 的开发者不去分析构建的影响或不知道如何分析。因此，我们希望改善 Android Studio 中的工具，在社区中提高对构建时间影响的意识和透明度。

我们正在探索如何在 Android Studio 中更好地提供插件和任务对构建时间影响的相关信息。

## 你现在能做些什么？

虽然配置时间可能因变量、模块和其他因素的数量而有所不同，但我们希望将与 **Android Gradle 插件**相关联的配置时间作为参考点，并和实际场景共享数据。

![](https://cdn-images-1.medium.com/max/2400/0*-ArOM3hHce2x6Xsl)

如果发现构建时间慢很多，可能是有客制化的构建逻辑（或者三方的 Gradle 插件）影响到构建时间。

> 使用的工具

Gradle 提供了一组**免费**的[工具](https://guides.gradle.org/performance/)来帮助分析构建中正在发生的事情。

我们建议你使用 [Gradle scan](https://guides.gradle.org/performance/#build_scans)，它提供了关于构建的大部分信息。如果你不希望构建信息上传到 Gradle 服务器上，可以使用 [Gradle profiler](https://guides.gradle.org/performance/#profile_report)，相对于 Gradle scan，它提供的信息要少一些，但是可以保证所有内容都在本地。

**注意：对于那些你可能想使用传统 JVM profiler 的项目，Gradle scan 对研究它们的配置延迟没有帮助。**

> 优化构建配置和任务

在研究构建速度时，这里有几个需要注意的最佳实践，可以随时查看我们的[最新最佳实践](https://developer.android.com/studio/build/optimize-your-build)。

配置

* 仅使用配置来创建任务（使用 lazy API），避免在其中执行任何 I/O 或任何其他工作。（配置不适合查询 git、读取文件、搜索连接的设备、进行计算等）。
* 在配置中创建所有的任务。配置不会知道实际生成了什么内容。

优化任务

* 保证每个任务都声明了输入/输出（即便是非文件性的），并且是增量化的和可缓存的。
* 将复杂的步骤拆分为多个任务，以帮助实现增量化和可缓存性。
（有些任务可以是最新的，而另一些任务可以执行或并行执行）。
* 确保任务不会写入或删除其他任务的输出。
* 在插件或 buildSrc 中用 Java/Kotlin 编写任务，而不是在 build.gradle 中用 Groovy 直接编写。

作为开发者，我们关心你的生产力。随着我们持续努力加快构建速度，希望这里的提示和指导方针能够帮助你缩短构建时间，以便让你能够更加专注于开发精彩的应用程序。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
