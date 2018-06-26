> * 原文地址：[How to fix app quality issues with Android vitals](https://medium.com/googleplaydev/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part-498dde9f4ef6)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：[DateBro](https://github.com/DateBro)

# 如何用 Android vitals 解决应用程序的质量问题

## 两篇中的第一篇：修复 ANR 事件和过度唤醒是如何提高应用在 Play Store 上的表现的

![](https://cdn-images-1.medium.com/max/800/0*EWSxinDkL4qP3nQT.)

对于一个应用开发者来说，没有比开心的用户更好的衡量成功的标准，而且最好是有很多这样的用户。实现这一目标的最佳方式是拥有一个人人都想用的优秀应用，不过我们所说的“优秀”指的是什么呢？它可以归结为两件事：功能和应用质量。前者最终取决于你的创造力和选择的商业模式，而后者可以客观地衡量和改进。

在去年进行的一项 Google 内部研究中，我们查看了 Play Store 中的一星评论，发现超过 40％ 的人提到应用稳定性的问题。相对的，人们会用更高的评分和更好的评论持续奖励那些表现最佳的应用。这使得它们在 Google Play 上获得更好的排名，而好的排名有助于提高安装量。不仅如此，用户还会更加投入，并愿意在这些应用程序上花费更多的时间和金钱。

因此，解决应用程序的稳定性问题可以在很大程度上决定它有多成功。

为了提供一个客观的质量衡量标准，使你可以轻松发现应用需要解决哪些稳定性问题，我们在 Play Console 中添加了一个名为 Android vitals 的新模块。这个模块可以告诉你应用程序的性能和稳定性问题，而不需要在代码中添加仪器或库。当你的应用程序运行在众多设备上的时候，Android vitals 会收集关于应用程序性能的匿名指标。即使在使用硬件实验室进行测试时，它也会以其他方式难以获得的规模为你提供信息。

Android vitals 可以提醒你的问题包括崩溃、应用程序无响应（ANR）和渲染时间。这些问题都直接影响你的用户对应用的体验和看法。此外，还有一类用户可能不会直接与你的应用关联的不良应用行为：比如耗电的速度比预期的要快。

在本文中，我将着眼于以下两个问题：

*   **过度唤醒**。这会影响电池的续航时间，如果用户无法及时充电，可能会导致他们无法使用设备。这种行为很可能会让用户迅速卸载你的应用。
*   **应用程序无响应（ANR）事件**。这些事件发生在你的应用程序 UI 冻结的时候。发生冻结时，如果你的应用位于前台，会弹出对话框让用户选择关闭应用或等待响应。从用户的角度来看，这种行为与应用崩溃一样糟糕。用户可能不会立即卸载你的应用，但如果 ANR 持续存在，用户很可能会寻找替代的应用。

### 过度唤醒

![](https://cdn-images-1.medium.com/max/800/0*p72INJ4b8pd9CxM8.)

那么，唤醒是什么以及它们何时变得过度呢？

为了延长电池的续航时间，屏幕关闭后，Android 设备将通过禁用主 CPU 内核进入深度睡眠模式。除非用户唤醒设备，否则设备会尽可能长时间地保持在此状态。但是，有一些重要事件需要唤醒 CPU 并提醒用户，例如，当闹钟响起或有新的聊天消息到达时。这些警报可以通过唤醒警报（wakeup alarm）来处理，但正如我将要解释的那样，这并不是必须的。到目前为止，唤醒似乎是一件好事，它可以显示重要的事件引起用户的注意，但是如果有太多这种事件那么电池寿命就会受到影响。

### Android vitals 如何显示过度唤醒？

了解你的应用是否在驱动过多的唤醒是 Android vitals 的重要任务。收集的有关你应用行为的匿名数据用于显示自设备完全充电后，每小时经历超过 10 次唤醒的用户的百分比。要查看的关键点是一个红色的图标；这个图标告诉你，你的应用已超出不良行为阈值。而这个阈值表示你的应用属于 Google Play 上表现较差的应用，你应该考虑改善其行为。

![](https://cdn-images-1.medium.com/max/800/0*lI6WpGCrW0NIQDUk.)

### 唤醒警报是否有其他替代方法？

在指定时间或间隔后唤醒设备的主要方法是使用 AlarmManager API 的 RTC_WAKEUP 或 ELAPSED_REALTIME_WAKEUP 标志来安排警报。但是一定要注意谨慎地使用此功能，而且只有在其他调度和通知机制不能更好地提供服务的情况下。当你想要使用唤醒警报时，请注意考虑以下几点：

*   如果你需要根据网络返回的数据来显示信息，可以考虑使用消息推送来实现，例如 Firebase Cloud Messaging。使用这种机制而不是定期拉取新数据，你的应用只有在需要时才会被唤醒。
*   如果你无法使用消息推送并且依赖定期拉取，可以考虑使用 JobScheduler 或者是 Firebase JobDispatcher（甚至是 SyncManager 来获取帐户数据）。这些是比 AlarmManager 更高级别的 API，而且为更智能的定期任务提供以下好处：
    **A）**批处理 —— 许多任务将被批量处理以使设备睡眠时间更长，而不是多次唤醒系统来执行这些任务。 
    **B）**条件 —— 你可以指定必须满足某些条件才能执行你的任务，例如网络可用性或电池的充电状态。使用这些条件可以避免不必要的设备唤醒和应用运行。  
    **C）**持续性和自动重试 —— 任务可以持续执行（即使重新启动也可以），并且可以在发生故障时自动重试。
    **D）**Doze 兼容性 —— 任务只有在不受 Doze 模式限制或应用程序待机时才会执行。

只有当消息推送和定期任务不适合你的工作时，你才应该使用 AlarmManager 安排唤醒警报。或者从另一个角度来看，只有当你需要在特定时间启动闹钟时才需要使用唤醒警报，无论网络或其他条件如何。

### Android vitals 显示过度唤醒时你应该怎么做？

要解决过度唤醒的问题，请先确定你的应用在哪些地方设置了唤醒警报，然后降低触发这些警报的频率。

要确定你的应用在哪些地方设置了唤醒警报，请在 Android Studio 中打开 AlarmManager 类，右键单击 RTC_WAKEUP 或 ELAPSED_REALTIME_WAKEUP 字段并选择 “Find Usages”。 这将显示你项目中用到这些标志的所有实例。审查每一个实例，看看你是否可以切换到更智能的定时任务机制中的一种。

![](https://cdn-images-1.medium.com/max/800/0*AqOuensVaMAnWsbT.)

你还可以在 Find Usages 选项中将范围设置为“项目和库”，以确定你的依赖库是否使用了 AlarmManager API。如果是，你应该考虑使用替代库或向作者报告这个问题。

如果你决定必须使用唤醒警报，那么如果你提供了符合以下要求的警报标签，则 Play Console 可以提供更好的分析数据：

*   在你的警报标签名称中包含你的包名、类名或方法名。这也可以帮助你轻松识别警报设置在你源码中的什么位置。
*   请勿使用 Class＃getName() 作为警报名称，因为它可能会被 Proguard 混淆。改用硬编码的字符串。
*   不要将计数器或其他唯一标识符添加到警报标签，因为系统可能会丢弃标签，而且无法将它们聚合成有用的数据。

### 应用程序无响应

![](https://cdn-images-1.medium.com/max/800/0*ncJ-EVNH0Z1rJdVj.)

那么，什么是应用程序无响应（ANR），它又是如何影响用户的呢？

对于用户来说，ANR 是当他们尝试与你的应用进行交互时，该界面被冻结。界面保持冻结几秒钟后，会显示一个对话框，让用户选择等待或强制应用程序退出。

从应用程序开发的角度来看，当应用程序因为执行耗时操作（如磁盘或网络读写）阻塞主线程时，就会发生 ANR。主线程（有时称为 UI 线程）负责响应用户事件并刷新屏幕上每秒绘制六十次的内容。因此，将任何可能延迟其工作的操作都转移到后台线程是至关重要的。

### Android vitals 如何显示 ANR？

使用收集到的有关你应用 ANR 事件的匿名数据，Android vitals 提供了有关 ANR 的多个级别的详细信息。主屏幕显示你应用程序中发生 ANR 的 Activity 的概况。这显示了用户经历过至少一次 ANR 的每日会话的百分比，以及之前最近 30 天的单独报告。还提供了不良行为的阈值。

![](https://cdn-images-1.medium.com/max/800/0*WTt4VlpfdmHEK_su.)

详细信息视图的 **ANR 比例**页面显示了 ANR 比例随时间变化的详细信息，以及按应用版本、Activity 名称、ANR 类型和 Android 版本显示的 ANR 信息。你可以通过 APK 版本号、支持的设备、操作系统版本和时间段来过滤这些数据。

![](https://cdn-images-1.medium.com/max/800/0*uuk2F6DaMO7n4UMr.)

你还可以从 **ANRs & crashes** 部分获取更多详细信息。

![](https://cdn-images-1.medium.com/max/800/0*ODKOaFplhvN113N9.)

### ANR 的常见原因是什么？

如前所述，当应用程序进程阻塞主线程时就会发生 ANR。几乎任何原因都可能导致这种阻塞，但最常见的原因包括：

*   **在主线程上执行磁盘或网络读写操作**。这是迄今为止 ANR 最常见的原因。虽然大多数开发人员都认为你不应该在主线程上读取或写入数据到磁盘或网络，但有时我们总会无意间这么做。在理想情况下从磁盘读取几个字节可能不会导致 ANR，但是**这绝不是一个好主意**。如果用户使用的设备闪存很慢怎么办？如果他们的设备受到来自其他应用程序同时读取和写入的巨大压力，而你的应用程序在队列中等待执行“快速”读取操作时又该怎么办？**切勿在主线程上执行读写操作。**
*   **在主线程上执行长时间计算**。那么内存里的计算会怎么样呢？RAM 不会受长时间访问的影响，较小的操作应该没问题。但是，当你开始在循环中执行复杂计算或处理大型数据集时，可以轻松阻塞主线程。可以考虑调整包含数百万像素的大图像的大小，或解析大块的 HTML 文本，然后在 TextView 中显示。一般来说，最好让你的应用在后台执行这些操作。
*   **从主线程向另一个进程运行同步绑定调用**。与磁盘或网络操作类似，在跨进程边界进行阻塞调用时，程序执行会传递到你无法控制的某个位置。如果其他进程很忙怎么办？如果它需要访问磁盘或网络来响应你的请求怎么办？另外，数据传递给另一个进程需要进行序列化和反序列化，这也需要时间。最好从后台线程进行进程间调用。
*   **使用同步**。即使你将繁重的操作移动到后台线程，也需要与主线程进行通信以显示进度或计算的结果。多线程编程并不容易，而且在使用同步进行锁定时，通常很难保证不会阻塞执行。在最糟糕的情况下，它甚至可能导致死锁，线程之间互相阻塞永久等待下去。最好不要自己设计同步，使用专门的解决方案会更好一些，比如 [Handler](https://developer.android.com/reference/android/os/Handler.html)，从后台线程传递不可变的数据到主线程。

### 我如何检测 ANR 的原因？

查找 ANR 的原因可能会非常棘手，就拿 [URL](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html) 类来说吧。 你觉得确定两个 URL 是否相同的 [URL#equals](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html#equals%28java.lang.Object%29) 方法是否会被阻塞？SharedPreferences 又会怎样？如果你在后台从中读取值，可以在主线程上调用 [getSharedPreferences](https://developer.android.com/reference/android/content/Context.html#getSharedPreferences%28java.lang.String,%20int%29) 方法吗？在这两种情况下，答案是这些都可能是长时间阻塞操作。

幸运的是，[StrictMode](https://developer.android.com/reference/android/os/StrictMode.html) 使查找 ANR 不再靠猜的。在调试版本中使用这个工具可以捕获主线程上意外的磁盘和网络访问。在应用程序启动时使用 [StrictMode＃setThreadPolicy](https://developer.android.com/reference/android/os/StrictMode.html#setThreadPolicy%28android.os.StrictMode.ThreadPolicy%29) 可以自定义你想要检测的内容，包括磁盘和网络读写，甚至可以通过 [StrictMode＃noteSlowCall](http://link) 在应用程序中触发自定义的慢速调用。你还可以选择 StrictMode 在检测到阻塞调用时如何提醒你：通过让应用程序崩溃、Log 信息或者是显示对话框。更多详细信息，请参阅 [ThreadPolicy.Builder类](https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder.html)。

一旦你消除了主线程中的阻塞调用，记得在将你的应用程序发布到 Play Store 之前关闭 StrictMode。

消除过度唤醒和 ANR 将提高应用程序的质量和可用性，提高评分和评论，进而实现更多安装。通过查看 Android vitals，你可以快速轻松地发现是否存在需要解决的问题。在代码中查找和解决这些问题并不总是那么直截了当，但有些工具和技术可以帮你更高效地完成这些工作。

Android vitals 还可以给你提供更多帮助，我会在下一篇文章里介绍更多这些功能。我将在 5 月 8 日星期二下午 3 点，在 [Google I/O 2018](https://events.google.com/io/) 大会上和同事 Fergus Hurley 以及 Joel Newman 一起演示 [“Android vitals：调试应用程序性能和收获奖励”](https://events.google.com/io/schedule/?section=may-8&sid=b8e1c97f-8133-426d-87ee-7a0a61d33de4) 的环节。如果你在那里或者想通过直播了解更多关于 Android vitals、最新的 Play Console 和 Android Studio 工具以及帮助你提高应用质量的意见，请加入我们。

* * *

如果你对 Android vitals 有任何想法或疑问，请通过 **＃AskPlayDev** 发送推特告知我们。我们会通过 [@GooglePlayDev](http://twitter.com/googleplaydev) 回复你，我们也会定期在上面分享有关如何在 Google Play 上取得成功的新闻和提示。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
