> * 原文地址：[The Android Lifecycle cheat sheet — part IV: ViewModels, Translucent Activities and Launch Modes](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-IV.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-IV.md)
> * 译者：[xiaxiayang](https://github.com/xiaxiayang)
> * 校对者：[phxnirvana](https://github.com/phxnirvana)

# Android 生命周期备忘录 —— 第四部分：ViewModel、半透明 Activity 及启动模式

本系列文章：

- [**第一部分：Activity** — 单一 activity 的生命周期](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)  
- [**第二部分：多个 Activity** — 跳转和返回栈（back stack）](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)   
-  [**第三部分：Fragment** — activity 和 fragment 的生命周期](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md)  
-  **第四部分：ViewModel、半透明 Activity 及启动模式** (即本文)

为了更方便地查询，你可以去查阅 [PDF 版本的图表备忘录](https://github.com/JoseAlcerreca/android-lifecycles)。

## ViewModel

`ViewModel` 的生命周期非常简单：它只有 `onCleared` 这一个回调。但是，这个函数的作用域在 activity 和 fragment 中是有区别的：

![](https://cdn-images-1.medium.com/max/800/1*InXHWv6E6bLpOAXbTRZ9Zg.png)

**ViewModel 作用域**

注意，初始化是在获取 `ViewModel` 时进行的，通常在 `onCreate` 方法中完成。

[下载 ViewModel 图表](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheetviewmodelsvg.pdf)

## 半透明 Activity

半透明的 activity 有半透明（通常是透明的）的背景，所以用户仍然可以看到该 activity 下面是什么。

当一个 activity 的主题设置了 `android:windowIsTranslucent` 属性时，生命周期稍有变化：背景后面的 activity 不会被停止，只会被暂停，所以可以继续接收 UI 的更新：

![](https://cdn-images-1.medium.com/max/800/1*e53GrDAmNgD9WbiI8lgIFw.png)

**常规 activity 和半透明 activity 之间的比较**

此外，当返回到一个任务时，这两个 activity 都会被恢复，重走 `onRestart` 和 `onStart` 方法，但只有半透明的 activity 重走 `onResume` 方法：

![](https://cdn-images-1.medium.com/max/800/1*zXVUFwBl5tfBlGxhaUfHQw.png)

**按下 home 键，回到带有半透明 activity 的应用程序**

[下载半透明 activity 图表](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheettranslucent.pdf)

## 启动模式

处理任务和回退栈的推荐方法主要是：**别处理** — 你应该采用默认行为。要了解更多细节，请阅读 Ian Lake 的关于这个主题的文章：[任务和回退栈](https://medium.com/androiddevelopers/tasks-and-the-back-stack-dbb7c3b0f6d4)。

如果你**真的需要使用** [`SINGLE_TOP`](https://developer.android.com/guide/topics/manifest/activity-element#lmode)，下图展现了它的行为模式：

![](https://cdn-images-1.medium.com/max/800/1*y4f7Txiv_bqjm5PfrGtSWg.png)

**Single Top 行为模式**

方便比较，下面是 [`singleTask`](https://developer.android.com/guide/topics/manifest/activity-element#lmode) 模式看起来的样子（但是你可能不应该用到它）：

![](https://cdn-images-1.medium.com/max/800/1*IOhNkOHU5SOglqpS-FEdEw.png)

**Single Task**

注意：如果你用了 Jetpack 中 [导航架构组件（Navigation Architecture Component）](https://developer.android.com/topic/libraries/architecture/navigation/)，你会从它支持 Single Top 和自动合成回退栈中受益。

 [下载启动模式图表](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheetmodes.pdf)

 > 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

 ---

 > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
