> * 原文地址：[Medium Android Developers](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)
> * 译者：
> * 校对者：

# The Android Lifecycle cheat sheet — part II: Multiple activities
In this series:  
[Part I: Activities — single activity lifecycle](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)  
**Part II: Multiple activities** — navigation and back stack (this post)
[Part III: Fragments — activity and fragment lifecycle](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)  
[Part IV: ViewModels, Translucent Activities and Launch Modes](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)

The diagrams are also available as a [cheat sheet in PDF format](https://github.com/JoseAlcerreca/android-lifecycles) for quick reference.


> Note that, when showing lifecycles for multiple components (activities, fragments, etc) in a diagram, grouped events that appear side by side run in parallel. The execution focus can switch from one parallel group of events to another at any time, so **the order of calls among parallel groups of events is not guaranteed**. However, order inside a group is guaranteed.
>
> The following scenarios don’t apply to activities and tasks that have a custom launch mode or task affinity defined. For more information, see [Tasks And Back Stack](https://developer.android.com/guide/components/activities/tasks-and-back-stack.html) on the Android developer website.

## Back Stack — Scenario 1: Navigating between activities

![](https://cdn-images-1.medium.com/freeze/max/800/1*Bt1fQmVtZc0ExHUlzhJO6Q.png)

**Scenario 1: Navigating between activities**

In this scenario, when a new activity is started, activity 1 is [STOPPED](https://developer.android.com/guide/components/activities/activity-lifecycle.html#onstop) (but not destroyed), similar to a user navigating away (as if “Home” was pressed).

When the Back button is pressed, activity 2 is destroyed and finished.

### Managing state

Note that [`onSaveInstanceState`](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29) is called, **but** [`onRestoreInstanceState`](https://developer.android.com/reference/android/app/Activity.html#onRestoreInstanceState%28android.os.Bundle,%20android.os.PersistableBundle%29) **is not**. If there is a configuration change when the second activity is active, the first activity will be destroyed and recreated only when it’s back in focus. That’s why saving an instance of the state is important.

If the system kills the app process to save resources, this is another scenario in which the state needs to be restored.


## Back Stack — Scenario 2: Activities in the back stack with configuration changes

![](https://cdn-images-1.medium.com/max/800/1*TaoqKwKSPur_2S__OzhdoQ.png)

**Scenario 2: Activities in the back stack with configuration changes**

### Managing state

Saving state is not only important for the activity in the foreground. **All activities in the stack need to restore state after a configuration change** to recreate their UI.

Also, the system can kill your app’s process at almost any time so you should be prepared to restore state in any situation.


## Back Stack — Scenario 3: App’s process is killed

When the Android operating system needs resources, it kills apps in the background.

![](https://cdn-images-1.medium.com/max/800/1*Au5PqGADz31UCfANL3ZRug.png)

**Scenario 3: App’s process is killed**

### Managing state

Note that the state of the full back stack is saved but, in order to efficiently use resources, activities are only restored when they are recreated.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
