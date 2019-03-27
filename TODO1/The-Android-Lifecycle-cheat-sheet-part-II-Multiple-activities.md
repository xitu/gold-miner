> * 原文地址：[Medium Android Developers](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)
> * 译者：[Rickon](https://github.com/gs666)
> * 校对者：[Endone](https://github.com/Endone)，[Mirosalva](https://github.com/Mirosalva)

# Android 生命周期备忘录 — 第二部分：多 Activity

在这个系列中：

- [第一部分：单一 Activities](https://juejin.im/post/5a77c9aef265da4e6f17bd51)
- [**第二部分：多 Activity** — 跳转和返回栈（本篇文章）](https://juejin.im/post/5c8e018d51882545ca77d857)
- [**第三部分：Fragments** — activity 和 fragment 的生命周期](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md)
- [第四部分：ViewModels、半透明 Activity 和启动模式](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)

为了方便查阅，我制作了 [PDF 格式备忘录](https://github.com/JoseAlcerreca/android-lifecycles)。

> 请注意，图表中显示多个组件（activities，fragments 等）的生命周期时，并排显示的分组事件是并行的。执行焦点可以随时从一个并行事件组切换到另一个，因此**并行事件组之间的调用顺序并不能保证**。但是，组内的顺序是有保证的。
>
> 以下场景并不适用于有着自定义启动模式或任务关联型的 activities 和任务。想要了解更多，详见 Android 开发者官网：[任务和返回栈](https://developer.android.com/guide/components/activities/tasks-and-back-stack.html)。

## 返回栈 — 场景 1：在 Activity 之间跳转

![](https://user-gold-cdn.xitu.io/2019/3/2/1693d96d9b8fa76e?w=728&h=972&f=png&s=49929)

**场景 1：在 Activity 之间跳转**

在这种场景下，当一个新 activity 启动时，activity 1 被[停止](https://developer.android.com/guide/components/activities/activity-lifecycle.html#onstop)（但没有被销毁），类似于用户在进行跳转（就像按下 "Home" 一样）。

当返回按钮被按下，activity 2 被销毁结束运行。

### 管理状态

请注意，尽管 [`onSaveInstanceState`](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29) 被调用，**但是** [`onRestoreInstanceState`](https://developer.android.com/reference/android/app/Activity.html#onRestoreInstanceState%28android.os.Bundle,%20android.os.PersistableBundle%29) **不会被调用**。如果在第二个 activity 处于活动状态时配置发生改变，则第一个活动将被销毁并仅在其重新获取焦点时重新创建。这就是保存一个状态的实例很重要的原因。

如果系统杀死应用程序进程以节省资源，这是另一种需要恢复状态的场景。

## 返回栈 — 场景 2：配置发生变化时返回栈中的 Activities

![](https://user-gold-cdn.xitu.io/2019/3/2/1693d96e23dc5098?w=742&h=1127&f=png&s=58345)

**场景 2：配置发生变化时返回栈中的 Activities**

### 管理状态

保存状态不仅对前台的 activity 很重要。**配置发生变化后，栈中的所有的 activities 都需要重新恢复状态**来重新创建它们的 UI。

此外，系统几乎可以随时终止你的应用程序进程，因此你应该准备好在任何情况下恢复状态。

## 返回栈 — 场景 3：应用的进程被终止

当 Android 操作系统需要资源时，它会杀死在后台的应用程序。

![](https://user-gold-cdn.xitu.io/2019/3/2/1693d96d9c7c0d19?w=800&h=1077&f=png&s=104247)

**场景 3：应用的进程被终止**

### 管理状态

请注意，完整返回栈的状态被保存起来，但为了有效地使用资源，只有在重新创建 activity 时才会恢复 activity。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
