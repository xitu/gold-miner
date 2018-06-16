> * 原文地址：[How to fix app quality issues with Android vitals](https://medium.com/googleplaydev/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part-498dde9f4ef6)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-fix-app-quality-issues-with-android-vitals-and-improve-performance-on-the-play-store-part.md)
> * 译者：
> * 校对者：

# How to fix app quality issues with Android vitals

## Post 1 of 2: How fixing ANR events and excessive wakeups can improve Play Store performance

![](https://cdn-images-1.medium.com/max/800/0*EWSxinDkL4qP3nQT.)

For an app developer there is no better measure of success than happy users, and preferably a lot of them. The best way to achieve this is to have a great app that people want to use, but what do we mean by “great”? It boils down to two things: features and app quality. While the former ultimately depends on your creativity and chosen business model, the latter can be objectively measured and improved.

In an internal Google study, conducted last year, we looked at one-star reviews on the Play Store and found over 40% mentioned app stability as an issue. Conversely, people consistently reward the best performing apps with better ratings and reviews. This leads to better rankings on Google Play, which helps increase installs. Not only that, but users stay more engaged, and are willing to spend more time and money in those apps.

So, addressing your app’s stability issues can significantly impact how successful it is.

To provide an objective measure of quality, so you can easily discover what stability issues your app has that need addressing, we added a new section to the Play Console called Android vitals. This section tells you about performance and stability problems in your app, without requiring the addition of instrumentation or libraries to your code. Android vitals gathers anonymous metrics about your app’s performance, while your app runs on a myriad of devices. It provides you with information at a scale that might be difficult to obtain otherwise, even when using a hardware lab for testing.

The issues that Android vitals can alert you to include crashes, Application Not Responding (ANR), and rendering times. These issues all directly impact your users’ experience and perception of your app. Then there is a category of bad app behaviors that a user might not associate directly with your app: those that drain the battery faster than might be expected.

In this article, I’m going to look at two of these issues:

*   **Excessive wakeups**. These impact battery life and can deprive the user of their device if they can’t get to a charger in time. This sort of behavior is likely to see the user swiftly uninstall your app.
*   **Application Not Responding (ANR) events**. These events record when your app’s UI freezes. When a freeze happens, if your app’s in the foreground, a dialog gives the user the opportunity to close the app or wait for it to respond. From the user’s point of view, this behavior is as bad as the app crashing. The user may not immediately uninstall your app, but if ANRs persist users are very likely to look for an alternative app.

### Excessive wakeups

![](https://cdn-images-1.medium.com/max/800/0*p72INJ4b8pd9CxM8.)

So, what are wakeups and when do they become excessive?

To extend battery life, after its screen turns off, an Android device enters a deep sleep mode by disabling the main CPU cores. Unless the user wakes up the device, it’s desirable for the device to stay in this state for as long as possible. However, there are some events when it’s important to wake up the CPU and alert the user — for example, when an alarm goes off or a new chat message arrives. These alerts could be handled by a wakeup alarm, but as I’ll explain, don’t have to be. So far, wakeups seem like a good thing, bringing important events to the users’ attention, but too many of them and battery life suffers.

### How does Android vitals show excessive wakeups?

Knowing whether your app is driving too many wakeups is where Android vitals comes in. Anonymous data collected about your app’s behavior is used to show the percentage of users who experienced more than 10 wakeups per hour since their device was fully charged. The key thing to look for is a red icon; this icon tells you that your app has exceeded the bad behavior threshold. This threshold indicates that your app is among the worse behaving apps on Google Play and you should look to improve its behavior.

![](https://cdn-images-1.medium.com/max/800/0*lI6WpGCrW0NIQDUk.)

### Are there alternatives to wakeup alarms?

The main way to wake a device at a given time or after an interval is by scheduling alarms with the RTC_WAKEUP or ELAPSED_REALTIME_WAKEUP flags using the AlarmManager API. It’s important to use this feature sparingly and only in situations that are not better served by other scheduling and notification mechanisms. Here are some things to consider when you’re thinking of using a wakeup alarm:

*   If you need to show information in response to data coming from the network, consider using push messages by implementing, for example, Firebase Cloud Messaging. Using this mechanism, instead of regularly polling for new data, your app will only be woken up when needed.
*   If you can’t use push messages and rely on regular polling, consider using JobScheduler or Firebase JobDispatcher (or even SyncManager for account data). These are much higher-level APIs than the AlarmManager and offer the following benefits for smarter job scheduling:  
    **A)** Batching — instead of waking up the system multiple times to run jobs, many jobs will be batched letting the device sleep longer.  
    **B)** Criteria — you can specify criteria, such as network availability or battery charging status, that must be met to run your job. Using criteria avoids waking up the device and running your app needlessly.  
    **C)** Persistence and automatic back-off — jobs can be persisted (even across reboots) and will benefit from automatic retry in case of a failure.  
    **D)** Doze compatibility — jobs will only run when there are no restrictions imposed by doze mode or app standby.

Only if push messaging and job scheduling are unsuitable for your job, should you use AlarmManager to schedule a wakeup alarm. Or to look at it another way, wakeup alarms should only be necessary when you require an alarm to be set off at a specific time, regardless of network or other conditions.

### What should you do when Android vitals shows excessive wakeups?

To address excessive wakeups, identify where your app schedules wakeup alarms and then reduce the frequency at which those alarms are triggered.

To identify where your app is scheduling wakeup alarms, in Android Studio open the AlarmManager class, right click on the RTC_WAKEUP or ELAPSED_REALTIME_WAKEUP fields and select “Find Usages”. This will show all the instances of these flags in your project. Review each one, to see whether you can switch to one of the smarter job scheduling mechanisms.

![](https://cdn-images-1.medium.com/max/800/0*AqOuensVaMAnWsbT.)

You can also set the scope to “Project and libraries” in Find Usages options to determine if your dependencies are using the AlarmManager APIs. If they are, you should consider using an alternative library or report the issue to the author.

If you decide that you have to use wakeup alarms, Play Console gives better analytics data if you provide good alarm tags that:

*   Include your package, class, or method name in your alarm’s tag name. This will also help you easily identify where the alarm was set in your source.
*   Don’t use Class#getName() for alarm names, because it could get obfuscated by Proguard. Use a hard-coded string instead.
*   Don’t add counters or other unique identifiers to alarm tags as the system may drop the tag and will not be able to aggregate them into useful data.

### Application Not Responding

![](https://cdn-images-1.medium.com/max/800/0*ncJ-EVNH0Z1rJdVj.)

So, what is an Application Not Responding (ANR) and how does it affect the user?

For users, an ANR is an incident where they are trying to interact with your app, but the interface is frozen. After the interface has remained frozen for a few seconds, a dialog displays that gives the user the choice of waiting or forcing the app to quit.

From the app development perspective, an ANR happens when an app is blocking the main thread by performing a long operation, such as disk or network I/O. The main thread (sometimes referred to as the UI thread) is responsible for responding to user events and refreshing what’s drawn on the screen sixty times per second. It’s therefore critical that any operations that might delay its work are moved to a background thread.

### How does Android vitals show ANRs?

Using anonymous data collected about your app’s ANR events, Android vitals provides several levels of detail about ANRs. The main screen shows a summary of ANR activity in your app. This shows the percentage of daily sessions where users experienced at least one ANR, with separate reports for the last and previous 30 days. The bad behavior threshold is also provided.

![](https://cdn-images-1.medium.com/max/800/0*WTt4VlpfdmHEK_su.)

The details view, the **ANR rate** page, shows details of the ANR rate over time, and ANRs by app version, activity name, ANR type, and Android version. You can filter this data by APK version codes, supported devices, OS versions, and period.

![](https://cdn-images-1.medium.com/max/800/0*uuk2F6DaMO7n4UMr.)

You can also get more details from the **ANRs & crashes** section.

![](https://cdn-images-1.medium.com/max/800/0*ODKOaFplhvN113N9.)

### What are the common reasons for ANRs?

As previously mentioned, an ANR occurs when an app process blocks the main thread. This blocking could happen for almost any reason, but the most common causes include:

*   **Executing disk or network I/O on the main thread**. This is by far the most common cause of ANRs. While most developers agree that you shouldn’t read or write data to disk or network on the main thread, sometimes we’re all tempted to do it. Reading a few bytes from disk will probably not cause an ANR under ideal conditions, but **it’s never a good idea**. What if the user has a device with slow flash memory? What if their device is under extreme pressure from other apps that are simultaneously reading and writing, while your app waits in the queue to perform your “fast” read operation? **Never perform I/O on the main thread.**
*   **Performing a long calculation on the main thread**. So what about in-memory calculations? RAM doesn’t suffer from long access times and smaller operations should be fine. But, when you start performing complex calculations in loops or working with large data sets, you can easily block the main thread. Consider resizing large images with millions of pixels, or parsing large chunks of HTML text to then display in a TextView. In general, it’s better for your app to run operations like these in the background.
*   **Running a synchronous binder call to another process from the main thread**. Similar to disk or network operations, when making blocking calls across process boundaries, program execution is passed to somewhere that you have no control over. What if the other process is busy? What if it needs to access disk or network to respond to your request? In addition, data needs to be parcelled and unparcelled to be passed to the other process, which takes time. It’s better to make interprocess calls from a background thread.
*   **Using synchronization**. Even if you move your heavy operations to a background thread, you need to communicate with the main thread to display progress or the result of your calculations. Multithreaded programming isn’t easy and when using synchronization for locking it’s often hard to ensure that you don’t block execution. In the worst-case, it might even result in a deadlock where your threads wait blocked on one another, forever. It’s best to avoid designing synchronization yourself, it’s better to use purpose-built solutions, such as [Handler](https://developer.android.com/reference/android/os/Handler.html), to pass immutable data from a background thread back to the main thread.

### How can I detect the cause of ANRs?

Finding the cause of an ANR can be tricky, take the [URL](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html) class as an example. Do you expect the [URL#equals](https://docs.oracle.com/javase/7/docs/api/java/net/URL.html#equals%28java.lang.Object%29), the method for determining if two URLs are the same, to be blocking? What about SharedPreferences? Can you call [getSharedPreferences](https://developer.android.com/reference/android/content/Context.html#getSharedPreferences%28java.lang.String,%20int%29) on the main thread if you read values from it in the background? In both cases, the answer is that these are potentially long blocking operations.

Fortunately, [StrictMode t](https://developer.android.com/reference/android/os/StrictMode.html)akes the guesswork out of finding ANRs. Use this tool in your debug builds to catch accidental disk and network accesses on the main thread. Use [StrictMode#setThreadPolicy](https://developer.android.com/reference/android/os/StrictMode.html#setThreadPolicy%28android.os.StrictMode.ThreadPolicy%29) on application start to customize what you want to detect, including disk and network I/O or even custom slow calls that you trigger in your app through [StrictMode#noteSlowCall](http://link). You can also select how you want StrictMode to alert you when it detects blocking calls: by crashing the app, or logging or displaying a dialog. Refer to the [ThreadPolicy.Builder class](https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder.html) for more details.

Once you eliminate blocking calls on the main thread, remember to turn off StrictMode before releasing your app to the Play Store.

Eliminating excessive wakeups and ANRs will enhance the quality and usability of your apps, drawing improved ratings and reviews, and, in turn, more installs. By checking Android vitals you can quickly and easily find out if you have issues that need to be addressed. Finding and addressing these issues in your code isn’t always as straightforward, but there are tools and techniques you can use to get the job done efficiently.

There is more that Android vitals can help you with, and I’ll look at more of these features in the next article. I’ll be at [Google I/O 2018](https://events.google.com/io/), along with colleagues Fergus Hurley and Joel Newman, presenting the session [“Android vitals: debug app performance and reap rewards”](https://events.google.com/io/schedule/?section=may-8&sid=b8e1c97f-8133-426d-87ee-7a0a61d33de4) on Tuesday 8th May at 3pm PT. Join us if you’re there or through the livestream to learn more about Android vitals, the latest Play Console and Android Studio tools, and insights to help you improve app quality.

* * *

If you have any thoughts or questions on Android vitals, let us know by tweeting with **#AskPlayDev**.  We’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
