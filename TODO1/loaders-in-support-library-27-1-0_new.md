> * 原文地址：[Loaders in Support Library 27.1.0](https://medium.com/google-developers/loaders-in-support-library-27-1-0-b1a1f0fee638)
> * 原文作者：[Ian Lake](https://medium.com/@ianhlake?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md)
> * 译者：
> * 校对者：

# 支持庫27.1.0中的Loaders

爲了[Support Library 27.1.0](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0),我重寫了`[LoaderManager](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html)`的內部結構，[Loaders API](https://developer.android.com/guide/components/loaders.html)以它爲基礎，我也想解釋下這些改變背後的緣由以及接下來會有什麼期待。


#### Loaders and Fragments的一小段歷史

一開始，Loaders和Fragments緊緊的聯繫在一起。這意味着，爲了支持Loaders，在`[FragmentActivity](https://developer.android.com/reference/android/support/v4/app/FragmentActivity.html)`和`[Fragment](https://developer.android.com/reference/android/support/v4/app/Fragment.html)`中有許多的代碼, 然而事實上他們幾乎沒有關聯。 這也意味着和Activity，Fragment和架構組件[lifecycle](https://developer.android.com/topic/libraries/architecture/lifecycle.html)相比，Loaders的生命週期和保證是完全獨特的且受制與那有趣和激動人心的行爲差異和bug。

#### 27.1.0中的改變

在27.1.0中，Loaders的技術債已經大幅度的減少：實現`LoaderManager`的代碼行數只有之前的三分之一，也有很多的測試讓Loaders在未來能夠保持一個良好的狀態。

所有這些都得意於架構組建。更確切的說是[ViewModels](https://developer.android.com/topic/libraries/architecture/viewmodel.html) (在配置變化是保持狀態) 和 [LiveData](https://developer.android.com/topic/libraries/architecture/livedata.html) (支持生命週期和回調). 現在Loaders基於這些更高級別且充分測試的組建並從中受益，減少持續的代碼冗餘和允許提升那些爲了穩定性和保證而自動添加到。allowing improvements on the reliability/guarantees added there to propagate to Loaders automatically.

#### 行爲變化

This does mean a few behavior changes though.

首先, 必須在主線程中調用 `[initLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#initLoader%28int,%20android.os.Bundle,%20android.support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29)`, `[restartLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#restartLoader%28int,%20android.os.Bundle,%20android.support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29)`, 和 `[destroyLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#destroyLoader%28int%29)` 。這提供了一些非常特別的保證在回調結束或開始時，例如在銷燬一個loader後，你將永遠不會拿到`[onLoadFinished](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29)`的回調。

> 注意事項: 在技術上這次發佈之前，你可以在其他線程中做loader操作，但是`LoaderManager`不再是線程安全的，會導致經常性的未定義行爲。

最重要的是, 現在`[onLoadFinished](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29)` 和LiveData Observers一樣，總是在`onStart`和`onStop`之間被調用，且不會在`onSaveInstanceState`之後。這樣你可以在`onLoadFinished`中安全的做[Fragment Transactions](https://developer.android.com/guide/components/fragments.html#Transactions)了.

#### 我應當做什麼，loader後續如何？

像我在之前的博客[Lifecycle Aware Data Loading with Architecture Components](https://medium.com/google-developers/lifecycle-aware-data-loading-with-android-architecture-components-f95484159de4)中提到的一樣, 我強烈的建議開發者使用ViewModels+LiveData，我認爲他們絕對是一個更靈活更容易理解的系統. 然而，如果你已經有基於loaders的APIs，這些改變應當會極大的提升組件之後的可依賴性和穩定性。

這許多的改變讓Loaders變成一個功能，更加可選的依賴，不需要對[LifecycleOwner](https://developer.android.com/reference/android/arch/lifecycle/LifecycleOwner.html)/[ViewModelStoreOwner](https://developer.android.com/reference/android/arch/lifecycle/ViewModelStoreOwner.html)做很底層的修改。

#### 嘗試下吧！

如果你正在使用Loaders，請儘快看看並注意行爲變更，他們都在[發佈事項](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0)中。

> 注意事項:顯而易見，只有支持庫有這些更改。如果你使用的是Android框架Loaders，請儘快切換到支持庫. 因爲框架的Loader APIs 不會有錯誤修復或者計劃中的改進。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
