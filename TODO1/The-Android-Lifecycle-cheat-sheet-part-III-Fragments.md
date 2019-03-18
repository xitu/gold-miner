> * 原文地址：[The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-III-Fragments.md)
> * 译者：
> * 校对者：

# The Android Lifecycle cheat sheet — part III : Fragments

In this series:  
[**Part I: Activities** — single activity lifecycle](https://github.com/xitu/gold-miner/blob/master/TODO/the-android-lifecycle-cheat-sheet-part-i-single-activities.md)  
[**Part II: Multiple activities** — navigation and back stack](https://github.com/xitu/gold-miner/blob/master/TODO1/The-Android-Lifecycle-cheat-sheet-part-II-Multiple-activities.md)   
**Part III: Fragments** — activity and fragment lifecycle (this post)  
[**Part IV: ViewModels, Translucent Activities and Launch Modes**](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)

The diagrams are also available as a [cheat sheet in PDF format](https://github.com/JoseAlcerreca/android-lifecycles) for quick reference.

In this section we’ll cover the behavior of a fragment that is attached to an activity. Don’t confuse this scenario with that of a fragment added to the back stack (see [Tasks and Back Stack](https://medium.com/google-developers/tasks-and-the-back-stack-dbb7c3b0f6d4) for more information on fragment transactions and the back stack).

## Scenario 1: Activity with Fragment starts and finishes

![](https://cdn-images-1.medium.com/max/800/1*ALMDBkuAAZ28BJ2abmvniA.png)

**Scenario 1: Activity with Fragment starts and finishes**

Note that it’s guaranteed that the Activity’s `onCreate` is executed before the Fragment’s. However, callbacks shown side by side — such as `onStart` and `onResume` — are executed in parallel and can therefore be called in either order. For example, the system might execute the Activity’s `onStart` method before the Fragment’s `onStart` method, but then execute the _Fragment’s_ `onResume` method before the Activity’s `onResume` method.

**Be careful to manage the timing of the respective execution sequences so that you avoid race conditions.**

## Scenario 2: Activity with Fragment is rotated

![](https://cdn-images-1.medium.com/max/800/1*ukapaC23cOJSPUeZ0bUdCA.png)

**Scenario 2: Activity with Fragment is rotated**

### State management

Fragment state is saved and restored in very similar fashion to activity state. The difference is that there’s no `onRestoreInstanceState` in fragments, but the Bundle is available in the fragment’s `onCreate`, `onCreateView` and `onActivityCreated`.

Fragments can be retained, which means that the same instance is used on configuration change. As the next scenario shows, this changes the diagram slightly.

* * *

## Fragments — Scenario 3: Activity with retained Fragment is rotated

![](https://cdn-images-1.medium.com/max/800/1*hK_YRdty1GoafABfug-r4g.png)

**Scenario 3: Activity with retained Fragment is rotated**

The fragment is not destroyed nor created after the rotation because the same fragment instance is used after the activity is recreated. The state bundle is still available in `onActivityCreated`.

Using retained fragments is not recommended unless they are used to store data across configuration changes (in a non-UI fragment). This is what the [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) class from the Architecture Components library uses internally, but with a simpler API.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
