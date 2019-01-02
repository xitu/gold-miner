> * 原文地址：[The Android Lifecycle cheat sheet — part I: Single Activities](https://medium.com/google-developers/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)
> * 译者：[IllllllIIl](https://github.com/IllllllIIl)
> * 校对者：[tanglie1993](https://github.com/tanglie1993)，[atuooo](https://github.com/atuooo)

# Android 生命周期备忘录 — 第一部分：单一 Activities

Android 系统的目的是让用户增强控制权并且让他们简便地使用应用程序。例如，一个 app 的用户可能会旋转屏幕，回复一条通知信息，或者切换到另一个任务，而用户应该能够在这类操作后继续流畅地使用这个 app。

为了提供这种用户体验，你应该知道怎么管理组件的生命周期。组件可以是一个 Activity，一个 Fragment，一个 Service，或者 Application 本身，甚至是在默默运行的进程。组件有生命周期，生命周期会在多种状态中变换。当状态发生变化时，系统会通过一个生命周期回调方法通知你。

为了更好解释生命周期是怎么运作的，我们定义了根据现有组件进行分类的一系列用户场景。

**第一部分： Activities** — 单一 activity 的生命周期 (就是本文)

[**第二部分： 多个 activities** — 跳转和返回栈（back stack)](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)

[**第三部分： Fragments** — activity 和 fragment 的生命周期](https://medium.com/@JoseAlcerreca/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)

它们的图表也提供了 [PDF格式备忘录](https://github.com/JoseAlcerreca/android-lifecycles)，以方便查阅。

* * *

除非特别说明，接下来的这些场景展示了这些组件的默认行为。

**如果你发现有错误或者遗漏了什么重要的东西，请在下方评论。**

### **第一部分: Activities**

#### 单一 Activity — 场景 1：应用被结束并且重启

触发原因：

* 用户按下了 **返回键**，或者是
* `Activity.finish()` 方法被调用

这个最简单的场景说明了一个单一 activity 的应用被用户开启，结束，和重启时发生了什么：

![](https://cdn-images-1.medium.com/max/800/1*U_j3OP74jrPFoNvO2i7XzQ.png)

>**场景 1：应用被终止并且重启**

**状态处理**

* [onSaveInstanceState](https://developer.android.com/reference/android/app/Activity.html#onSaveInstanceState%28android.os.Bundle%29) 不会被调用 (因为 activity 被结束了，你不需要保存状态)
* [onCreate](https://developer.android.com/reference/android/app/Activity.html#onCreate%28android.os.Bundle%29) 没有 Bundle 对象，如果重新打开应用的话。因为先前的 activity 结束了，也不需要恢复状态。

* * *

#### **单一 Activity — 场景 2：用户切换出去**

触发原因：

* 用户按了 Home 键
* 用户切换到另一个应用（点击虚拟按键（Overview menu），点击一个通知，接听来电，等等）

![](https://cdn-images-1.medium.com/max/800/1*w3Hkt3deEkHSDWQD-I03cA.png)

>**场景 2：用户切换出去**

在这个场景中系统会 [stop](https://developer.android.com/guide/components/activities/activity-lifecycle.html#onstop) 这个 activity，但不会马上结束它。

**状态处理**

当你的 activity 进入 Stopped 状态，**系统会使用 onSaveInstanceState 去保存应用的状态以防系统一段时间后终止这个应用的进程** (请看下面)**。**

假设应用的进程没有被终止，这个应用的实例会常驻在内存，保存所有状态。当这个 activity 回到前台工作时，它会恢复这些状态。你不需要重新初始化这些之前已生成的组件。

* * *

#### **单一 Activity — 场景 3：配置发生变化**

触发原因：

* 配置发生变化，例如屏幕旋转
* 在多窗口模式下，用户调整窗口大小

![](https://cdn-images-1.medium.com/max/800/1*sw4ePskeHsYPs1LrHh2Pcg.png)

> 场景 3：屏幕旋转或其他配置变化

**状态处理**

像屏幕旋转或窗口大小改变，这种配置变化应该能够让用户在变化后继续无缝使用。

* activity 会被完全 destroy，但是 **activity 的状态会被保存下来并在下一个实例中恢复**。
* 在`onCreate` 和 `onRestoreInstanceState` 中的 Bundle 对象是相同的。

* * *

#### **单一 Activity — 场景 4：应用被系统暂停**

触发原因：

* 开启多窗口模式 （API 24+）并且应用失去焦点
* 另一个应用部分地覆盖在正在运行的应用上面（例如一个购买对话框，一个运行时权限确认对话框，一个第三方登陆对话框...）
* 调用意图选择器，例如调用了分享对话框

![](https://cdn-images-1.medium.com/max/800/1*j3blnCW082yMbQe5fkjMMg.png)

>**场景 4：应用被系统暂停**

这个场景不适用于以下情况：

* 对话框属于同一个应用。弹出一个警告对话框或者一个 DialogFragment 并不会暂停（执行 onPause 方法）被遮挡住的 activity。
* 通知。用户收到一个新通知或者拉下通知栏不会暂停被遮挡住的 activity。

### 延伸阅读

* [Android 生命周期备忘录 第二部分 — 多个 activities](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-2.md)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
