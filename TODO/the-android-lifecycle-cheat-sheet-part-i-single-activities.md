> * 原文地址：[The Android Lifecycle cheat sheet — part I: Single Activities](https://medium.com/google-developers/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)
> * 译者：
> * 校对者：

# The Android Lifecycle cheat sheet — part I: Single Activities

Android is designed to empower users and let them use apps in a intuitive way. For example, users of an app might rotate the screen, respond to a notification, or switch to another task, and they should be able to continue using the app seamlessly after such an event.

To provide this user experience, you should know how to manage component lifecycles. A component can be an Activity, a Fragment, a Service, the Application itself and even the underlying process. The component has a lifecycle, during which it transitions through states. Whenever a transition happens, the system notifies you via a lifecycle callback method.

To help us explain how lifecycles work, we’ve defined a series of scenarios which are grouped according to the components that are present:

**Part I: Activities **— single activity lifecycle (this post)

[**Part II: Multiple activities** — navigation and back stack](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)

[**Part III: Fragments **— activity and fragment lifecycle](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)

The diagrams are also available as a [cheat sheet in PDF format](https://github.com/JoseAlcerreca/android-lifecycles) for quick reference.

* * *

The following scenarios showcase the default behavior of the components, unless otherwise noted.

_If you find errors or you think something important is missing, report it in the comments._

### **Part I: Activities**

#### Single Activity — Scenario 1: App is finished and restarted

Triggered by:

* The user presses the **Back button**, or
* The `Activity.finish()` method is called

The simplest scenario shows what happens when a single-activity application is started, finished and restarted by the user:

![](https://cdn-images-1.medium.com/max/800/1*U_j3OP74jrPFoNvO2i7XzQ.png)

**Scenario 1: App is finished and restarted**

**Managing state**

* `[onSaveInstanceState](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29)` is not called (since the activity is finished, you don’t need to save state)
* `[onCreate](https://developer.android.com/reference/android/app/Activity.html#onCreate%28android.os.Bundle%29)` doesn’t have a Bundle when the app is reopened, because the activity was finished and the state doesn’t need to be restored.

* * *

#### **Single Activity — Scenario 2: User navigates away**

Triggered by:

* The user presses the **Home button**
* The user switches to another app (via Overview menu, from a notification, accepting a call, etc.)

![](https://cdn-images-1.medium.com/max/800/1*w3Hkt3deEkHSDWQD-I03cA.png)

>**Scenario 2: User navigates away**

In this scenario the system will [stop](https://developer.android.com/guide/components/activities/activity-lifecycle.html#onstop) the activity, but won’t immediately finish it.

**Managing state**

When your activity enters the Stopped state, the **system uses onSaveInstanceState to save the app state in case the system kills the app’s process later on** (see below)**.**

Assuming the process isn’t killed, the activity instance is kept resident in memory, retaining all state. When the activity comes back to the foreground, the activity recalls this information. You don’t need to re-initialize components that were created earlier.

* * *

#### **Single Activity — Scenario 3: Configuration changes**

Triggered by:

* Configuration changes, like a **rotation**
* User resizes the window in multi-window mode

![](https://cdn-images-1.medium.com/max/800/1*sw4ePskeHsYPs1LrHh2Pcg.png)

Scenario 3: Rotation and other configuration changes

**Managing state**

Configuration changes like rotation or a window resize should let users continue exactly where they left off.

* The activity is completely destroyed, but **the state is saved and restored for the new instance**.
* The Bundle in `onCreate` and `onRestoreInstanceState` is the same.

* * *

#### **Single Activity — Scenario 4: App is paused by the system**

Triggered by:

* Enabling Multi-window mode (API 24+) and losing the focus
* Another app partially covers the running app (a purchase dialog, a runtime permission dialog, a third-party login dialog…)
* An intent chooser appears, such as a share dialog

![](https://cdn-images-1.medium.com/max/800/1*j3blnCW082yMbQe5fkjMMg.png)

**Scenario 4: App is paused by the system**

This scenario _doesn’t_ apply to:

* Dialogs in the same app. Showing an `AlertDialog` or a `DialogFragment` won’t pause the underlying activity.
* Notifications. User receiving a new notification or pulling down the notification bar won’t pause the underlying activity.

### Continue reading

* [The Android Lifecycle cheat sheet part II — Multiple activities](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
