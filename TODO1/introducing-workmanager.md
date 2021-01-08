> * 原文地址：[Introducing WorkManager](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)
> * 原文作者：[Pietro Maggi](https://medium.com/@pmaggi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-workmanager.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-workmanager.md)
> * 译者：[Rickon](https://juejin.im/user/5bffbdaf6fb9a049d81b914c)
> * 校对者：[DevMcryYu](https://github.com/DevMcryYu)

# WorkManager 简介

![](https://cdn-images-1.medium.com/max/800/1*-Feqy3ufsr7NRCFSDuQfWw.png)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

Android 系统处理后台工作有很多注意事项和最佳实践，详见 [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series)。其中一个反复出现的调用是一个名为 [WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/) 的 [Android Jetpack](https://developer.android.com/jetpack/) 库，它扩展了 [JobScheduler](https://developer.android.com/reference/android/app/job/JobScheduler) 框架 API 的功能，并支持 Android 4.0+（API 14+）。[WorkManager 测试版](https://developer.android.com/jetpack/docs/release-notes#december_19_2018)今天刚刚发布！

这篇文章是 WorkManager 系列中的第一篇。我们将探讨 WorkManager 的基础知识，如何以及何时使用它，以及幕后发生了什么。然后我们将深入研究更复杂的用例。

### WorkManager 是什么？

WorkManager 是 [Android 架构组件](https://developer.android.com/topic/libraries/architecture/)之一，也是 Android Jetpack 的一部分，是一个关于如何构建现代 Android 应用程序的新见解。

> WorkManager 是一个 Android 库，在满足工作的**约束条件**时运行**可延迟**的后台工作。
>
> WorkManager 适用于需要**保障**的任务，即使应用程序退出，系统也会运行它们。

换句话说，WorkManager 提供了一个电池友好的 API，它封装了 Android 后台行为限制多年来的演变。这对于需要执行后台任务的 Android 应用程序至关重要！

### 什么时候使用 WorkManager

无论应用程序进程是否存在，WorkManager 都会处理在满足各种约束条件时需要运行的后台工作。后台工作可以在应用程序位于后台、前台或者应用在前台打开即将转到后台的时候启动。无论应用程序在做什么，后台工作都应该继续进行，或者在 Android 终止其进程时重启其后台工作。

关于 WorkManager 的一个常见误解是它需要在“后台”线程中运行，但不需要在进程死亡时存活。事实并非如此。这种用例还有其他解决方案，如 Kotlin 的协程，ThreadPools 或 RxJava 等库。你可以在[后台处理指南](https://developer.android.com/guide/background/)中找到有关此用例的更多信息。

有许多不同的情况下，你需要运行后台工作，因此需要使用不同的解决方案来运行后台工作。这篇[关于后台运行的博客文章](https://android-developers.googleblog.com/2018/10/modern-background-execution-in-android.html)提供了很多关于何时使用 Workmanager 的有用信息。请看博客中的此图表：

![](https://cdn-images-1.medium.com/max/800/1*K-jWMXQbAK98EdkuuaZCFg.png)

图解来自 [Android 中的现代后台运行](https://android-developers.googleblog.com/2018/10/modern-background-execution-in-android.html)

对于 WorkManager，最适合处理的是必须**完成**并且可以**延迟**的后台工作。

首先，问问你自己：

*   **这个任务需要完成吗？** 如果应用程序被用户关闭了，是否仍需要完成任务？一个例子是带有远程同步的笔记应用程序;每次你写完一个笔记，你就会期望该应用程序将你的笔记与后端服务器同步。即使您切换到另一个应用程序并且操作系统需要关闭应用程序以回收一些内存。即使重新启动设备也会发生这种情况。WorkManager 能够确保任务完成。

*   **这个任务可以延迟吗？** 我们可以稍后运行任务，还是只在**现在**运行才可以用？如果任务可以稍后运行，那么它是可延迟的。回到前面的例子，立即同步你的笔记会很好，但是如果不能立即同步而是稍后进行的话也没什么大问题。WorkManager 尊重操作系统后台限制，并尝试以电池高效的方式运行你的工作。

因此，作为指导原则，WorkManager 适用于需要确保系统将运行它们的任务，即使应用程序退出也是如此。它不适用于需要立即执行或需要在确切时间执行的后台工作。如果你需要在准确的时间执行工作（例如闹钟或事件提醒），请使用 [AlarmManager](https://developer.android.com/training/scheduling/alarms)。对于需要立即执行但长时间运行的工作，你通常需要确保在前台执行工作;是否通过限制执行到前台（在这种情况下工作不再是真正的后台工作）或使用[前台服务](https://android-developers.googleblog.com/2018/12/effective-foreground-services-on-android_11.html)。

当你需要在更复杂的场景中触发一些后台工作时，WorkManager 可以并且应该与其他 API 配对使用：

*   如果你的服务器触发了工作，WorkManager 可以与 Firebase Cloud Messaging 配对使用。
*   如果你正在使用广播接收器监听广播，然后需要触发长时间运行的工作，那么你可以使用 WorkManager。请注意，WorkManager 支持许多通常作为广播传播的常见 [Constraints](https://developer.android.com/reference/androidx/work/Constraints) — 在这些情况下，你不需要注册自己的广播接收器。

### 为什么要用 WorkManager？

WorkManager 运行后台工作，同时能够为你处理电池和系统健康的兼容性问题和最佳实践。

此外，你可以使用 WorkManager 安排定时任务和复杂的从属任务链：后台工作可以并行或顺序执行，你可以在其中指定执行顺序。WorkManager 无缝地处理任务之间的输入和输出传递。

你还可以设置后台任务运行时间的标准。例如，如果设备没有网络连接，则没有理由向远程服务器发出 HTTP 请求。因此，您可以设置约束条件，该任务只能在网络连接时运行。

作为保证执行的一部分，WorkManager 负责在设备或应用程序重启时保持工作。你也可以轻松地定义重试策略如果你的工作已停止并且您想稍后重试。

最后，WorkManager 允许你观察工作请求的状态，以便你可以更新 UI。

总而言之，WorkManager 提供了以下好处：

*   处理不同系统版本的兼容性
*   遵循系统健康最佳实践
*   支持异步一次性和周期性任务
*   支持带输入/输出的链式任务
*   允许你设置在任务运行时的约束
*   即使应用程序或设备重启，也可以保证任务执行

让我们看一个具体的例子，我们构建一个将过滤器应用于图像的并发任务管道。然后将结果发送到压缩任务，然后发送到上传任务。

我们可以为这些任务定义一组约束，并指定何时可以执行它们：

![](https://cdn-images-1.medium.com/max/800/1*2arjXq_bwgaNwVBCiLgiOw.png)

带有约束的任务链示例

所有这些 workers 都定义了一个精确的序列：我们不知道过滤图像的顺序，但我们知道只有在所有过滤器工作完成后，Compress 工作才会启动。

### WorkManager 调度程序的工作原理

为了确保兼容性达到 API 14 级别，WorkManager 根据设备 API 级别选择适当的方式来安排后台任务。WorkManager 可能使用 JobScheduler 或 BroadcastReceiver 和 AlarmManager 的组合。

![](https://cdn-images-1.medium.com/max/800/1*FxHlzZfv4Q0XBRBV2WmvPQ.png)

WorkManager 如何确定要使用的调度程序

### WorkManager 准备好用于生产了吗？

WorkManager 现在处于测试阶段。这意味着在此主要修订版中不会有重大的 API 变更。

当 WorkManager 稳定版本发布时，它将是运行后台任务的首选方式。 因此，这是开始使用 WorkManager 并帮助[改进它](https://issuetracker.google.com/issues?q=componentid:409906)的好时机！

**感谢 [Lyla Fujiwara](https://medium.com/@lylalyla)。**

### WorkManager 相关资源

*   [官方文档](https://developer.android.com/topic/libraries/architecture/workmanager/)
*   [Reference guide](https://developer.android.com/reference/androidx/work/package-summary)
*   [WorkManager 1.0.0-beta01 Release notes](https://developer.android.com/jetpack/docs/release-notes#december_19_2018)
*   [Codelab](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html)
*   [源代码 (part of AOSP)](https://android.googlesource.com/platform/frameworks/support/+/master/work)
*   [IssueTracker](https://issuetracker.google.com/issues?q=componentid:409906)
*   [StackOverflow 网站上的 WorkManager 相关问题](https://stackoverflow.com/questions/tagged/android-workmanager)
*   [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series)

感谢 [Florina Munt](https://medium.com/@florina.muntenescu?source=post_page)、[Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page) 和 [Lyla Fujiwara](https://medium.com/@lylalyla?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
