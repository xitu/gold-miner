> * 原文地址：[The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md)
> * 译者：[Qiuk17](https://github.com/Qiuk17)
> * 校对者：[xiaxiayang](https://github.com/xiaxiayang), [DevMcryYu](https://github.com/DevMcryYu)

# Android 生命周期备忘录 — 第三部分：Fragments

本系列文章：  
[**第一部分：Activities** — 单一 activity 的生命周期](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)  
[**第二部分：多个 activities** — 跳转和返回栈（back stack）](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)   
**第三部分： Fragments** — Activity 和 Fragment 的生命周期（即本文）
[**第四部分：ViewModels、透明 Activities 及启动模式**](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)

为了更方便地查询，你可以去查阅 [PDF 版本的图表备忘录](https://github.com/JoseAlcerreca/android-lifecycles)。

本节中我们将介绍依附在 Activity 上的 Fragment 的行为。不过别把这种情况和加入到返回栈的 Fragment 搞混了（请参看 [Tasks and Back Stack](https://medium.com/google-developers/tasks-and-the-back-stack-dbb7c3b0f6d4) 这篇文章来学习有关 Fragment 事务和返回栈的知识）。

## 场景 1：当带有 Fragment 的 Activity 启动和终止时

![](https://cdn-images-1.medium.com/max/800/1*ALMDBkuAAZ28BJ2abmvniA.png)

**场景 1：当带有 Fragment 的 Activity 启动和终止时**

虽然 Activity 的 `onCreate` 方法保证在 Fragment 的 `onCreate` 方法之前被调用，但是其它像 `onStart` 和 `onResume` 这样的回调会被并行执行，因此它们会被以任意顺序调用。例如，系统可能先调用 Activity 的 `onStart` 方法再调用 Fragment 的 `onStart`，但在此之后却先调用 **Fragment** 的 `onResume` 方法再执行 Activity 的 `onResume`。

**小心管理它们执行的顺序和时间，以避免两者竞争带来的问题。**

## 场景 2：当带有 Fragment 的 Activity 被旋转时

![](https://cdn-images-1.medium.com/max/800/1*ukapaC23cOJSPUeZ0bUdCA.png)

**场景 2：当带有 Fragment 的 Activity 被旋转时**

### 状态管理

Fragment 状态的保存和恢复与 Activity 状态非常相似，区别在于 Fragment 中没有 `onRestoreInstanceState` 方法，但是 Fragment 的 `onCreate`、`onCreateView` 和 `onActivityCreated` 方法中的 Bundle 对象是可被获取的。

Fragment 是可以被保留的，这意味着当配置被改变时可以使用同一个 Fragment 实例。正如接下来的场景中所描述的，被复用的 Fragment 与普通 Fragment 有些许不同。

* * *

## 场景 3：当带有可被复用的 Fragment 的 Activity 被旋转时

![](https://cdn-images-1.medium.com/max/800/1*hK_YRdty1GoafABfug-r4g.png)

**场景 3：当带有可被复用的 Fragment 的 Activity 被旋转时**

Fragment 对象既没有被创建也没有被销毁，因为在 Activity 被重新创建后，同一个 Fragment 实例被复用了。因此在 `onActivityCreated` 过程中 Bundle 仍然是可被获取的。

使用可被复用的 Fragment 是不被推荐的，除非你想在配置改变时使用非 UI 的 Fragment 来存储数据。它的功能和内部组件库中的 [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) 相同，但 ViewModel 具有更简洁的 API。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
