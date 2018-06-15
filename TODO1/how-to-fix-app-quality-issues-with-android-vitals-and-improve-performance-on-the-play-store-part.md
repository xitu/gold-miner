> * 原文地址：[How to fix app quality issues with Android vitals](https://medium.com/googleplaydev/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part-498dde9f4ef6)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md)
> * 译者：
> * 校对者：

# How to fix app quality issues with Android vitals如何解决Android应用程序质量问题

## Post 1 of 2: How fixing ANR events and excessive wakeups can improve Play Store performance如何修复ANR事件和过度唤醒可以提高Play商店的性能

![](https://cdn-images-1.medium.com/max/800/0*EWSxinDkL4qP3nQT.)

For an app developer there is no better measure of success than happy users, and preferably a lot of them. The best way to achieve this is to have a great app that people want to use, but what do we mean by “great”? It boils down to two things: features and app quality. While the former ultimately depends on your creativity and chosen business model, the latter can be objectively measured and improved.对于应用程序开发人员来说，没有比开心用户更好的成功度量标准，最好是其中的很多。 实现这一目标的最佳方式是拥有一个人们想要使用的优秀应用程序，但是我们认为“好”是什么意思？ 它归结为两件事：功能和应用程序质量。 前者最终取决于你的创造力和选择的商业模式，后者可以客观地衡量和改进。

In an internal Google study, conducted last year, we looked at one-star reviews on the Play Store and found over 40% mentioned app stability as an issue. Conversely, people consistently reward the best performing apps with better ratings and reviews. This leads to better rankings on Google Play, which helps increase installs. Not only that, but users stay more engaged, and are willing to spend more time and money in those apps.在去年进行的Google内部研究中，我们查看了Play商店中的一星评论，发现超过40％的人提到应用稳定性是一个问题。 相反，人们持续奖励评分和评论更好的表现最佳的应用。 这会在Google Play上获得更好的排名，这有助于提高安装量。 不仅如此，用户仍然更加投入，并愿意花费更多的时间和金钱在这些应用程序中。

So, addressing your app’s stability issues can significantly impact how successful it is.因此，解决您应用程序的稳定性问题可以显着影响它的成功程度。

To provide an objective measure of quality, so you can easily discover what stability issues your app has that need addressing, we added a new section to the Play Console called Android vitals. This section tells you about performance and stability problems in your app, without requiring the addition of instrumentation or libraries to your code. Android vitals gathers anonymous metrics about your app’s performance, while your app runs on a myriad of devices. It provides you with information at a scale that might be difficult to obtain otherwise, even when using a hardware lab for testing.为了提供客观的质量衡量标准，您可以轻松发现应用需要解决哪些稳定性问题，我们在Play Console中添加了一个名为Android vitals的新部分。 本节介绍应用程序中的性能和稳定性问题，而不需要在代码中添加仪器或库。 Android应用程序会收集关于应用程序性能的匿名指标，而您的应用程序则运行在众多设备上。 即使在使用硬件实验室进行测试时，它也会以难以获得的规模为您提供信息。

The issues that Android vitals can alert you to include crashes, Application Not Responding (ANR), and rendering times. These issues all directly impact your users’ experience and perception of your app. Then there is a category of bad app behaviors that a user might not associate directly with your app: those that drain the battery faster than might be expected.Android重要的问题可以提醒您包括崩溃，应用程序不响应（ANR）和渲染时间。 这些问题都直接影响您的用户对应用的体验和看法。 然后，有一类用户可能不会直接与应用关联的不良应用行为：那些耗尽电池的速度比预期的要快。

In this article, I’m going to look at two of these issues:在本文中，我将着眼于以下两个问题：

*   **Excessive wakeups**. These impact battery life and can deprive the user of their device if they can’t get to a charger in time. This sort of behavior is likely to see the user swiftly uninstall your app.**过度唤醒**。 这会影响电池的使用寿命，如果无法及时充电，可能会导致用户无法使用设备。 这种行为很可能会让用户迅速卸载您的应用。
*   **Application Not Responding (ANR) events**. These events record when your app’s UI freezes. When a freeze happens, if your app’s in the foreground, a dialog gives the user the opportunity to close the app or wait for it to respond. From the user’s point of view, this behavior is as bad as the app crashing. The user may not immediately uninstall your app, but if ANRs persist users are very likely to look for an alternative app.**应用程序无响应（ANR）事件**。 这些事件会记录你的应用程序的UI冻结的时间。 发生冻结时，如果您的应用位于前台，对话框会为用户提供关闭应用或等待应答的机会。 从用户的角度来看，这种行为与应用程序崩溃一样糟糕。 用户可能不会立即卸载您的应用程序，但如果ANR持续存在，用户很可能会寻找替代应用程序。

### Excessive wakeups

![](https://cdn-images-1.medium.com/max/800/0*p72INJ4b8pd9CxM8.)

So, what are wakeups and when do they become excessive?那么，唤醒是什么以及它们何时变得过度？

To extend battery life, after its screen turns off, an Android device enters a deep sleep mode by disabling the main CPU cores. Unless the user wakes up the device, it’s desirable for the device to stay in this state for as long as possible. However, there are some events when it’s important to wake up the CPU and alert the user — for example, when an alarm goes off or a new chat message arrives. These alerts could be handled by a wakeup alarm, but as I’ll explain, don’t have to be. So far, wakeups seem like a good thing, bringing important events to the users’ attention, but too many of them and battery life suffers.为延长电池续航时间，屏幕关闭后，Android设备将通过禁用主CPU内核进入深度睡眠模式。 除非用户唤醒设备，否则设备尽可能长时间保持在此状态。 但是，有一些事件需要唤醒CPU并提醒用户，例如，当闹钟响起或新的聊天消息到达时。 这些警报可以通过唤醒警报来处理，但正如我将要解释的那样，并不是必须的。 到目前为止，唤醒似乎是一件好事，为用户的注意力带来了重要事件，但其中太多事件和电池寿命受到影响。

### How does Android vitals show excessive wakeups?Android生命力如何显示过度唤醒？

Knowing whether your app is driving too many wakeups is where Android vitals comes in. Anonymous data collected about your app’s behavior is used to show the percentage of users who experienced more than 10 wakeups per hour since their device was fully charged. The key thing to look for is a red icon; this icon tells you that your app has exceeded the bad behavior threshold. This threshold indicates that your app is among the worse behaving apps on Google Play and you should look to improve its behavior.了解您的应用是否在驱动过多的唤醒情况是Android的重要任务。收集的有关您的应用行为的匿名数据用于显示自设备完全充电后每小时体验超过10次唤醒的用户的百分比。 要寻找的关键是一个红色的图标; 此图标告诉您，您的应用已超出不良行为阈值。 此阈值表示您的应用属于Google Play上表现较差的应用，您应该考虑改善其行为。

![](https://cdn-images-1.medium.com/max/800/0*lI6WpGCrW0NIQDUk.)

### Are there alternatives to wakeup alarms?唤醒警报是否有其他选择？

The main way to wake a device at a given time or after an interval is by scheduling alarms with the RTC_WAKEUP or ELAPSED_REALTIME_WAKEUP flags using the AlarmManager API. It’s important to use this feature sparingly and only in situations that are not better served by other scheduling and notification mechanisms. Here are some things to consider when you’re thinking of using a wakeup alarm:在给定时间或间隔后唤醒设备的主要方法是使用AlarmManager API通过RTC_WAKEUP或ELAPSED_REALTIME_WAKEUP标志来安排警报。 只有在其他调度和通知机制不能更好地服务的情况下，谨慎使用此功能非常重要。 当您想要使用唤醒警报时，请注意以下几点：

*   If you need to show information in response to data coming from the network, consider using push messages by implementing, for example, Firebase Cloud Messaging. Using this mechanism, instead of regularly polling for new data, your app will only be woken up when needed.如果您需要显示信息以响应来自网络的数据，请考虑通过实施Firebase云消息传递来使用推送消息。 使用这种机制，而不是定期轮询新数据，只有在需要时才会唤醒您的应用程序。
*   If you can’t use push messages and rely on regular polling, consider using JobScheduler or Firebase JobDispatcher (or even SyncManager for account data). These are much higher-level APIs than the AlarmManager and offer the following benefits for smarter job scheduling:  如果您无法使用推送消息并依赖常规轮询，请考虑使用JobScheduler或Firebase JobDispatcher（甚至是SyncManager获取帐户数据）。 这些是比AlarmManager更高级别的API，为更智能的作业调度提供以下好处：
    **A)** Batching — instead of waking up the system multiple times to run jobs, many jobs will be batched letting the device sleep longer.  ** A）**批处理 - 不是多次唤醒系统来运行作业，许多作业将批量使设备睡眠时间更长。
    **B)** Criteria — you can specify criteria, such as network availability or battery charging status, that must be met to run your job. Using criteria avoids waking up the device and running your app needlessly.** B）**条件 - 您可以指定必须满足的条件（如网络可用性或电池充电状态）来运行您的工作。 使用标准可避免唤醒设备并不必要地运行您的应用程序。  
    **C)** Persistence and automatic back-off — jobs can be persisted (even across reboots) and will benefit from automatic retry in case of a failure.  ** C）**持久性和自动回退 - 作业可以保持（即使在重新启动时也可以），并且可以在发生故障时自动重试。
    **D)** Doze compatibility — jobs will only run when there are no restrictions imposed by doze mode or app standby.** D）**打盹兼容性 - 只有在打盹模式或应用程序待机没有限制时才会运行作业。

Only if push messaging and job scheduling are unsuitable for your job, should you use AlarmManager to schedule a wakeup alarm. Or to look at it another way, wakeup alarms should only be necessary when you require an alarm to be set off at a specific time, regardless of network or other conditions.只有在推送消息和作业安排不适合您的工作时，您是否应该使用AlarmManager安排唤醒警报。 或者从另一个角度来看，只有当您需要在特定时间启动闹钟时，才需要唤醒警报，无论网络或其他条件如何。

### What should you do when Android vitals shows excessive wakeups?Android应用程序显示过度唤醒时应该怎么做？

To address excessive wakeups, identify where your app schedules wakeup alarms and then reduce the frequency at which those alarms are triggered.要解决过度的唤醒问题，请确定您的应用安排唤醒警报的位置，然后降低触发这些警报的频率。

To identify where your app is scheduling wakeup alarms, in Android Studio open the AlarmManager class, right click on the RTC_WAKEUP or ELAPSED_REALTIME_WAKEUP fields and select “Find Usages”. This will show all the instances of these flags in your project. Review each one, to see whether you can switch to one of the smarter job scheduling mechanisms.要确定您的应用在哪里安排唤醒警报，请在Android Studio中打开AlarmManager类，右键单击RTC_WAKEUP或ELAPSED_REALTIME_WAKEUP字段并选择“查找用法”。 这将显示项目中这些标志的所有实例。 审查每一个，看看你是否可以切换到更聪明的作业调度机制之一。

![](https://cdn-images-1.medium.com/max/800/0*AqOuensVaMAnWsbT.)

You can also set the scope to “Project and libraries” in Find Usages options to determine if your dependencies are using the AlarmManager APIs. If they are, you should consider using an alternative library or report the issue to the author.您还可以在查找使用选项中将范围设置为“项目和库”，以确定您的依赖项是否使用AlarmManager API。 如果是，您应该考虑使用替代库或向作者报告问题。

If you decide that you have to use wakeup alarms, Play Console gives better analytics data if you provide good alarm tags that:如果您决定必须使用唤醒警报，则如果您提供了以下好警报标记，则Play控制台可提供更好的分析数据：

*   Include your package, class, or method name in your alarm’s tag name. This will also help you easily identify where the alarm was set in your source.将您的包裹，班级或方法名称包含在警报的标签名称中。 这也可以帮助您轻松识别您的来源中警报设置的位置。
*   Don’t use Class#getName() for alarm names, because it could get obfuscated by Proguard. Use a hard-coded string instead.请勿使用Class＃getName（）作为警报名称，因为它可能会被Proguard混淆。 改用硬编码的字符串。
*   Don’t add counters or other unique identifiers to alarm tags as the system may drop the tag and will not be able to aggregate them into useful data.不要将计数器或其他唯一标识符添加到警报标签，因为系统可能会丢弃标签，并且无法将它们聚合成有用的数据。

### Application Not Responding

![](https://cdn-images-1.medium.com/max/800/0*ncJ-EVNH0Z1rJdVj.)

So, what is an Application Not Responding (ANR) and how does it affect the user?那么，什么是应用程序无响应（ANR），它是如何影响用户的？

For users, an ANR is an incident where they are trying to interact with your app, but the interface is frozen. After the interface has remained frozen for a few seconds, a dialog displays that gives the user the choice of waiting or forcing the app to quit.对于用户来说，ANR是他们尝试与您的应用进行交互的事件，但该界面被冻结。 接口保持冻结几秒钟后，会显示一个对话框，让用户选择等待或强制应用程序退出。

From the app development perspective, an ANR happens when an app is blocking the main thread by performing a long operation, such as disk or network I/O. The main thread (sometimes referred to as the UI thread) is responsible for responding to user events and refreshing what’s drawn on the screen sixty times per second. It’s therefore critical that any operations that might delay its work are moved to a background thread.从应用程序开发的角度来看，当应用程序通过执行长操作（如磁盘或网络I / O）阻止主线程时，会发生ANR。 主线程（有时称为UI线程）负责响应用户事件并刷新屏幕上每秒六十次绘制的内容。 因此，任何可能延迟其工作的操作都转移到后台线程是至关重要的。

### How does Android vitals show ANRs?Android的重要性如何显示ANR？

Using anonymous data collected about your app’s ANR events, Android vitals provides several levels of detail about ANRs. The main screen shows a summary of ANR activity in your app. This shows the percentage of daily sessions where users experienced at least one ANR, with separate reports for the last and previous 30 days. The bad behavior threshold is also provided.使用收集的有关您的应用的ANR事件的匿名数据，Android生命期提供了有关ANR的多个级别的详细信息。 主屏幕显示应用程序中ANR活动的摘要。 这显示了用户每天经历至少一次ANR的每日会话的百分比，以及最近和最近30天的单独报告。 还提供了不良行为阈值。

![](https://cdn-images-1.medium.com/max/800/0*WTt4VlpfdmHEK_su.)

The details view, the **ANR rate** page, shows details of the ANR rate over time, and ANRs by app version, activity name, ANR type, and Android version. You can filter this data by APK version codes, supported devices, OS versions, and period.详细信息视图** ANR费率**页面显示ANR费率随时间变化的详细信息，以及按应用版本，活动名称，ANR类型和Android版本显示的ANR。 您可以通过APK版本代码，支持的设备，操作系统版本和期限来过滤这些数据。

![](https://cdn-images-1.medium.com/max/800/0*uuk2F6DaMO7n4UMr.)

You can also get more details from the **ANRs & crashes** section.您还可以从** ANR和崩溃**部分获取更多详细信息。

![](https://cdn-images-1.medium.com/max/800/0*ODKOaFplhvN113N9.)

### What are the common reasons for ANRs?ANR的常见原因是什么？

As previously mentioned, an ANR occurs when an app process blocks the main thread. This blocking could happen for almost any reason, but the most common causes include:如前所述，应用程序进程阻塞主线程时会发生ANR。 这种阻塞可能发生几乎任何原因，但最常见的原因包括：

*   **Executing disk or network I/O on the main thread**. This is by far the most common cause of ANRs. While most developers agree that you shouldn’t read or write data to disk or network on the main thread, sometimes we’re all tempted to do it. Reading a few bytes from disk will probably not cause an ANR under ideal conditions, but **it’s never a good idea**. What if the user has a device with slow flash memory? What if their device is under extreme pressure from other apps that are simultaneously reading and writing, while your app waits in the queue to perform your “fast” read operation? **Never perform I/O on the main thread.****在主线程**上执行磁盘或网络I / O。 这是迄今为止ANRs最常见的原因。 虽然大多数开发人员都认为您不应该在主线程上读取或写入数据到磁盘或网络，但有时我们都会试着去做。 从磁盘读取几个字节可能不会在理想情况下导致ANR，但是**这绝不是一个好主意**。 如果用户使用缓慢闪存的设备会怎么样？ 如果他们的设备受到来自同时读取和写入的其他应用程序的巨大压力，那么当您的应用程序在队列中等待执行“快速”读取操作时该怎么办？ **切勿在主线程上执行I / O。**
*   **Performing a long calculation on the main thread**. So what about in-memory calculations? RAM doesn’t suffer from long access times and smaller operations should be fine. But, when you start performing complex calculations in loops or working with large data sets, you can easily block the main thread. Consider resizing large images with millions of pixels, or parsing large chunks of HTML text to then display in a TextView. In general, it’s better for your app to run operations like these in the background.**对主线程**执行长时间计算。 那么内存计算呢？ 内存不会长时间访问，较小的操作应该没问题。 但是，当您开始在循环中执行复杂计算或处理大型数据集时，可以轻松阻止主线程。 考虑调整数百万像素的大图像，或解析HTML文本的大块，然后显示在TextView中。 一般来说，最好让你的应用在后台运行这些操作。
*   **Running a synchronous binder call to another process from the main thread**. Similar to disk or network operations, when making blocking calls across process boundaries, program execution is passed to somewhere that you have no control over. What if the other process is busy? What if it needs to access disk or network to respond to your request? In addition, data needs to be parcelled and unparcelled to be passed to the other process, which takes time. It’s better to make interprocess calls from a background thread.**从主线程**向另一个进程运行同步绑定程序调用。 与磁盘或网络操作类似，在跨进程边界进行阻塞调用时，程序执行会传递到您无法控制的某个位置。 如果其他进程很忙？ 如果它需要访问磁盘或网络来响应您的请求会怎么样？ 另外，数据需要被分包并且未被清理以传递给另一个过程，这需要时间。 最好从后台线程进行进程间调用。
*   **Using synchronization**. Even if you move your heavy operations to a background thread, you need to communicate with the main thread to display progress or the result of your calculations. Multithreaded programming isn’t easy and when using synchronization for locking it’s often hard to ensure that you don’t block execution. In the worst-case, it might even result in a deadlock where your threads wait blocked on one another, forever. It’s best to avoid designing synchronization yourself, it’s better to use purpose-built solutions, such as [Handler](https://developer.android.com/reference/android/os/Handler.html), to pass immutable data from a background thread back to the main thread.**使用同步**。 即使将繁重的操作移动到后台线程，也需要与主线程进行通信以显示进度或计算结果。 多线程编程并不容易，在使用同步进行锁定时，通常很难确保不会阻止执行。 在最糟糕的情况下，它甚至可能导致永久性的线程永久等待阻塞的死锁。 最好避免自己设计同步，最好使用专用的解决方案，比如[Handler]（https://developer.android.com/reference/android/os/Handler.html），以传递来自 后台线程回到主线程。

### How can I detect the cause of ANRs?我如何检测ANR的原因？

Finding the cause of an ANR can be tricky, take the [URL](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html) class as an example. Do you expect the [URL#equals](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html#equals%28java.lang.Object%29), the method for determining if two URLs are the same, to be blocking? What about SharedPreferences? Can you call [getSharedPreferences](https://developer.android.com/reference/android/content/Context.html#getSharedPreferences%28java.lang.String,%20int%29) on the main thread if you read values from it in the background? In both cases, the answer is that these are potentially long blocking operations.查找ANR的原因可能会非常棘手，请以[URL]（https://docs.oracle.com/javase/7/docs/api/java/net/URL.html）类为例。 你期望[URL＃等于]（https://docs.oracle.com/javase/7/docs/api/java/net/URL.html#equals%28java.lang.Object%29） 确定两个URL是否相同，是否被阻止？ 怎么样SharedPreferences？ 如果您从中读取值，可以在主线程上调用[getSharedPreferences]（https://developer.android.com/reference/android/content/Context.html#getSharedPreferences%28java.lang.String,%20int%29） 在后台？ 在这两种情况下，答案都是这些可能是长时间阻塞操作。

Fortunately, [StrictMode t](https://developer.android.com/reference/android/os/StrictMode.html)akes the guesswork out of finding ANRs. Use this tool in your debug builds to catch accidental disk and network accesses on the main thread. Use [StrictMode#setThreadPolicy](https://developer.android.com/reference/android/os/StrictMode.html#setThreadPolicy%28android.os.StrictMode.ThreadPolicy%29) on application start to customize what you want to detect, including disk and network I/O or even custom slow calls that you trigger in your app through [StrictMode#noteSlowCall](http://link). You can also select how you want StrictMode to alert you when it detects blocking calls: by crashing the app, or logging or displaying a dialog. Refer to the [ThreadPolicy.Builder class](https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder.html) for more details.幸运的是，[StrictMode t]（https://developer.android.com/reference/android/os/StrictMode.html）使猜测无法找到ANR。在调试版本中使用此工具可以捕获主线程上意外的磁盘和网络访问。在应用程序上使用[StrictMode＃setThreadPolicy]（https://developer.android.com/reference/android/os/StrictMode.html#setThreadPolicy%28android.os.StrictMode.ThreadPolicy%29）开始自定义要检测的内容，包括磁盘和网络I / O，甚至可以通过[StrictMode＃noteSlowCall]（http：//链接）在应用程序中触发自定义慢速调用。您还可以选择您希望StrictMode在检测到阻塞呼叫时提醒您：通过崩溃应用程序或记录或显示对话框。有关更多详细信息，请参阅[ThreadPolicy.Builder类]（https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder.html）。

Once you eliminate blocking calls on the main thread, remember to turn off StrictMode before releasing your app to the Play Store.一旦消除了主线程中的阻塞呼叫，请记住在将您的应用程序发布到Play商店之前关闭StrictMode。

Eliminating excessive wakeups and ANRs will enhance the quality and usability of your apps, drawing improved ratings and reviews, and, in turn, more installs. By checking Android vitals you can quickly and easily find out if you have issues that need to be addressed. Finding and addressing these issues in your code isn’t always as straightforward, but there are tools and techniques you can use to get the job done efficiently.消除过多的唤醒和ANR将提高应用程序的质量和可用性，提高评分和评论，进而实现更多安装。 通过检查Android标志，您可以快速轻松地发现是否存在需要解决的问题。 在代码中查找和解决这些问题并不总是那么直截了当，但有些工具和技术可以用来高效完成工作。

There is more that Android vitals can help you with, and I’ll look at more of these features in the next article. I’ll be at [Google I/O 2018](https://events.google.com/io/), along with colleagues Fergus Hurley and Joel Newman, presenting the session [“Android vitals: debug app performance and reap rewards”](https://events.google.com/io/schedule/?section=may-8&sid=b8e1c97f-8133-426d-87ee-7a0a61d33de4) on Tuesday 8th May at 3pm PT. Join us if you’re there or through the livestream to learn more about Android vitals, the latest Play Console and Android Studio tools, and insights to help you improve app quality.还有更多Android的重要功能可以帮助您，下一篇文章将介绍更多这些功能。 我将与[2018 Google I / O]（https://events.google.com/io/）以及同事Fergus Hurley和Joel Newman一起出席会议[“Android的重要性：调试应用程序性能和收获奖励 “]（https://events.google.com/io/schedule/?section=may-8&sid=b8e1c97f-8133-426d-87ee-7a0a61d33de4）5月8日星期二下午3点。 如果您在那里或通过直播了解更多关于Android活力，最新Play控制台和Android Studio工具以及深入见解，以帮助您提高应用质量，请加入我们。

* * *

If you have any thoughts or questions on Android vitals, let us know by tweeting with **#AskPlayDev**.  We’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.如果您对Android的重要性有任何想法或疑问，请通过**＃AskPlayDev **发送消息告知我们。 我们会回复[@GooglePlayDev]（http://twitter.com/googleplaydev），我们会定期分享有关如何在Google Play上取得成功的新闻和提示。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
