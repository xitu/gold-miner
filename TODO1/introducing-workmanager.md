> * 原文地址：[Introducing WorkManager](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)
> * 原文作者：[Pietro Maggi](https://medium.com/@pmaggi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-workmanager.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-workmanager.md)
> * 译者：
> * 校对者：

# Introducing WorkManager

![](https://cdn-images-1.medium.com/max/800/1*-Feqy3ufsr7NRCFSDuQfWw.png)

Illustration by [Virginia Poltrack](https://twitter.com/VPoltrack)

There are a lot of considerations and best practices for handling background work, outlined in [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series). One of the recurring call-outs is an [Android Jetpack](https://developer.android.com/jetpack/) library called [WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/), which expands on the capabilities of the [JobScheduler](https://developer.android.com/reference/android/app/job/JobScheduler) framework API and supports Android 4.0+ (API 14+). [WorkManager beta](https://developer.android.com/jetpack/docs/release-notes#december_19_2018) was just released today!

This blog post is the first in a new series on WorkManager. We’ll explore the basics of WorkManager, how and when to use it, and what’s going on behind the scenes. Then we’ll dive into more complex use cases.

### What is WorkManager?

WorkManager is one of the [Android Architecture Components](https://developer.android.com/topic/libraries/architecture/) and part of Android Jetpack, a new and opinionated take on how to build modern Android applications.

> _WorkManager is an Android library that runs_ **_deferrable_** _background work when the work’s_ **_constraints_** _are satisfied._
>
> _WorkManager is intended for tasks that require a_ **_guarantee_** _that the system will run them even if the app exit_s.

In other words, WorkManager provides a battery-friendly API that encapsulates years of evolution of Android’s background behavior restrictions. This is critical for Android applications that need to execute background tasks!

### When to use WorkManager

WorkManager handles background work that needs to run when various constraints are met, regardless of whether the application process is alive or not. Background work can be started when the app is in the background, when the app is in the foreground, or when the app starts in the foreground but goes to the background. Regardless of what the application is doing, background work should continue to execute, or be restarted if Android kills its process.

A common confusion about WorkManager is that it’s for tasks that needs to be run in a “background” thread but don’t need to survive process death. This is not the case. There are other solutions for this use case like Kotlin’s coroutines, ThreadPools, or libraries like RxJava. You can find more information about this use case in the [guide to background processing](https://developer.android.com/guide/background/).

There are many different situations in which you need to run background work, and therefore different solutions for running background work. This [blog post about background processing](https://android-developers.googleblog.com/2018/10/modern-background-execution-in-android.html) provides a lot of great information about when to use WorkManager. Take a look at this diagram from the blog:

![](https://cdn-images-1.medium.com/max/800/1*K-jWMXQbAK98EdkuuaZCFg.png)

Diagram from [Modern background execution in Android](https://android-developers.googleblog.com/2018/10/modern-background-execution-in-android.html)

In the case of WorkManager, it’s best for background work that has to **finish** and is **deferrable**.

To start, ask yourself:

*   **Does this task _need_ to finish?**
    If the application is closed by the user, is it still necessary to complete the task? An example is a note taking application with remote sync; once you finish writing a note, you expect that the app is going to synchronize your notes with a backend server. This happens even if you switch to another app and the OS needs to close the app to reclaim some memory. It also should happen even if you restart the device. WorkManager ensures tasks finish.

*   **Is this task deferrable?**
    Can we run the task later, or is it only useful if run **right** now? If the task can be run later, then it’s deferrable. Going back to the previous example, it would be nice to have your notes uploaded immediately but, if this is not possible and the synchronization happens later, it’s not a big problem. WorkManager respects OS background restrictions and tries to run your work in a battery efficient way.

So, as a guideline, WorkManager is intended for tasks that require a guarantee that the system will run them, even if the app exits. It is not intended for background work that requires immediate execution or requires execution at an exact time. If you need your work to execute at an exact time (such as an alarm clock, or event reminder), use [AlarmManager](https://developer.android.com/training/scheduling/alarms). For work that needs to be executed immediately but is long running, you’ll often need to make sure that work is executed when in the foreground; whether that’s by limiting execution to the foreground (in which case the work is not longer true background work) or using a [Foreground Service](https://android-developers.googleblog.com/2018/12/effective-foreground-services-on-android_11.html).

WorkManager can and should be paired with other APIs when you need to trigger some background work in more complex scenarios:

*   If your server triggers the work, WorkManager can be paired with Firebase Cloud Messaging.
*   If you are listening for broadcasts using a broadcast receiver and then need to trigger long running work, you can use WorkManager. Note that WorkManager provides support for many common [Constraints](https://developer.android.com/reference/androidx/work/Constraints) that normally come through as broadcasts — in these cases, you don’t need to register your own broadcast receivers.

### Why use WorkManager?

WorkManager runs background work while taking care of compatibility issues and best practices for battery and system health for you.

Furthermore, using WorkManager, you can schedule both periodic tasks and complex dependent chains of tasks: background work can be executed in parallel or sequentially, where you can specify an execution order. WorkManager seamlessly handles passing along input and output between tasks.

You can also set criteria on when the background task should run. For example, there’s no reason to make an HTTP request to a remote server if the device doesn’t have a network connection. So you can set a Constraint that the task can only run when a network connection is present.

As part of guaranteed execution, WorkManager takes care of persisting your work across device or application restarts. You can also easily define retry strategies if your work is stopped and you want to retry it later.

Finally, WorkManager lets you observe the state of the work request so that you can update your UI.

To summarize, WorkManager offers the following benefits:

*   Handles compatibility with different OS versions
*   Follows system health best practices
*   Supports asynchronous one-off and periodic tasks
*   Supports chained tasks with input/output
*   Lets you set constraints on when the task runs
*   Guarantees task execution, even if the app or device restarts

Let’s see a concrete example where we build a pipeline of concurrent tasks that applies filters to an image. The result is then sent to a compress task and then to an upload task.

We can define a set of constraints for these tasks and specify when they can be executed:

![](https://cdn-images-1.medium.com/max/800/1*2arjXq_bwgaNwVBCiLgiOw.png)

Sample chain of tasks with constraints

All these workers define a precise sequence: e.g. we don’t know the order in which the images will be filtered, but we know that the Compress worker will start only after all the Filter workers have completed.

### How the WorkManager scheduler works

To ensure compatibility back to API level 14, WorkManager chooses an appropriate way to schedule a background task depending on the device API level. WorkManager might use JobScheduler or a combination of BroadcastReceiver and AlarmManager.

![](https://cdn-images-1.medium.com/max/800/1*FxHlzZfv4Q0XBRBV2WmvPQ.png)

How WorkManager determines which scheduler to use

### Is WorkManager ready for production use?

WorkManager is now in beta. This means that there will be no breaking API changes in this major revision.

When WorkManager will be released as stable, it will be the preferred way to run background tasks. For this reason, this is a great moment to start using WorkManager and help [improve it](https://issuetracker.google.com/issues?q=componentid:409906)!

_Thanks to_ [_Lyla Fujiwara_](https://medium.com/@lylalyla)_._

### WorkManager’s Resources

*   [Documentation](https://developer.android.com/topic/libraries/architecture/workmanager/)
*   [Reference guide](https://developer.android.com/reference/androidx/work/package-summary)
*   [WorkManager 1.0.0-beta01 Release notes](https://developer.android.com/jetpack/docs/release-notes#december_19_2018)
*   [Codelab](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html)
*   [Source Code (part of AOSP)](https://android.googlesource.com/platform/frameworks/support/+/master/work)
*   [IssueTracker](https://issuetracker.google.com/issues?q=componentid:409906)
*   [WorkManager questions on StackOverflow](https://stackoverflow.com/questions/tagged/android-workmanager)
*   [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series)

Thanks to [Florina Munt](https://medium.com/@florina.muntenescu?source=post_page), [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page), and [Lyla Fujiwara](https://medium.com/@lylalyla?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
