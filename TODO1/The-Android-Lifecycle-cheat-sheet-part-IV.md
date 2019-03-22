
> * 原文地址：[The Android Lifecycle cheat sheet — part IV: ViewModels, Translucent Activities and Launch Modes](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-IV.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-IV.md)
> * 译者：
> * 校对者：

# The Android Lifecycle cheat sheet — part IV : ViewModels, Translucent Activities and Launch Modes

In this series:  
- [**Part I: Activities** — single activity lifecycle](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)  
- [**Part II: Multiple activities** — navigation and back stack](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)   
-  [**Part III: Fragments** — activity and fragment lifecycle](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md)  
-  **Part IV: ViewModels, Translucent Activities and Launch Modes** (this post)

The diagrams are also [in PDF format](https://github.com/JoseAlcerreca/android-lifecycles) for quick reference.

## ViewModels

The lifecycle of `ViewModel`s is quite simple: they have only one callback: `onCleared`. However, there’s a difference between scoping to an activity or to a fragment:

![](https://cdn-images-1.medium.com/max/800/1*InXHWv6E6bLpOAXbTRZ9Zg.png)

**ViewModel scoping**

Note that the initialization happens whenever you obtain the `ViewModel`, which is normally done in `onCreate`.

[Download ViewModels diagram](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheetviewmodelsvg.pdf)

## Translucent Activities

Translucent activities have translucent (usually transparent) backgrounds so the user can still see what’s underneath.

When the property `android:windowIsTranslucent` is applied to an activity’s theme, the diagram changes slightly: the background activity is never stopped, only paused, so it can continue receiving UI updates:

![](https://cdn-images-1.medium.com/max/800/1*e53GrDAmNgD9WbiI8lgIFw.png)

**Comparison between regular and translucent activities**

Also, when coming back to a task, both activities are restored and started, and only the translucent is resumed:

![](https://cdn-images-1.medium.com/max/800/1*zXVUFwBl5tfBlGxhaUfHQw.png)

**Pressing home and coming back to an app with a translucent activity**

[Download Translucent activities diagram](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheettranslucent.pdf)

## Launch Modes

The recommended way to deal with tasks and the back stack is, basically: **don’t** — you should adopt the default behavior. For more details, read Ian Lake’s post about this topic: [Tasks and Back Stack](https://medium.com/androiddevelopers/tasks-and-the-back-stack-dbb7c3b0f6d4).

If you **really need to use** `[SINGLE_TOP](https://developer.android.com/guide/topics/manifest/activity-element#lmode)`, here’s its diagram:

![](https://cdn-images-1.medium.com/max/800/1*y4f7Txiv_bqjm5PfrGtSWg.png)

**Single Top behavior**

For the sake of comparison, here’s what [`singleTask`](https://developer.android.com/guide/topics/manifest/activity-element#lmode) would look like (but you probably shouldn’t use it):

![](https://cdn-images-1.medium.com/max/800/1*IOhNkOHU5SOglqpS-FEdEw.png)

**Single Task**

Note: If you use Jetpack’s [Navigation Architecture Component](https://developer.android.com/topic/libraries/architecture/navigation/) , you will benefit from Single Top support and automatic synthetic back stack.

 [Download launch modes diagram](https://github.com/JoseAlcerreca/android-lifecycles/blob/a5dfd030a70989ad2496965f182e5fa296e6221a/cheatsheetmodes.pdf)

 > 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

 ---

 > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
