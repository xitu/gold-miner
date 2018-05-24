> * 原文地址：[Loaders in Support Library 27.1.0](https://medium.com/google-developers/loaders-in-support-library-27-1-0-b1a1f0fee638)
> * 原文作者：[Ian Lake](https://medium.com/@ianhlake?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md)
> * 译者：[dreamhb](https://github.com/dreamhb)
> * 校对者：[Starriers](https://github.com/Starriers)

# 支持库 27.1.0 中的 Loader

为了 [支持库 27.1.0](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0)，我重写了 [`LoaderManager`](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html) 的内部结构，[`Loaders API`](https://developer.android.com/guide/components/loaders.html) 以它为基础，我也想解释下这些改变背后的缘由以及接下来会有什么期待。

#### Loader 和 Fragment 的一小段历史

一开始，Loader 和 Fragment 紧紧的联系在一起。这意味着，为了支持 Loader，在 [`FragmentActivity`](https://developer.android.com/reference/android/support/v4/app/FragmentActivity.html) 和 [`Fragment`](https://developer.android.com/reference/android/support/v4/app/Fragment.html) 中有许多的代码，然而事实上他们几乎没有关联。这也意味着和 Activity、Fragment 以及架构组件[生命周期](https://developer.android.com/topic/libraries/architecture/lifecycle.html) 相比，Loader 的生命周期和保障是完全独特的且受制与它那有趣且激动人心的行为差异和 bug。

#### 27.1.0 中的改变

在 27.1.0 中，Loader 的遗留问题已经大幅度的减少：实现 `LoaderManager` 的代码行数只有之前的三分之一，也有很多的测试让 Loader 在未来能够保持一个良好的状态。

所有这些都得意于架构组件。更确切的说是 [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) ( 在配置变化时保持状态 ) 和 [LiveData](https://developer.android.com/topic/libraries/architecture/livedata.html)( 支持生命周期和回调 )。现在的 Loader 基于这些更高级别且充分测试的组件并从中受益，减少了不断增加的性能损失，提高了 Loader 的可靠性和正确性。

#### 行为变化

这确实意味着一些行为变更。

首先，必须在主线程中调用 [`initLoader`](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#initLoader%28int,%20android.os.Bundle,%20android .support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29)、[`restartLoader`](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#restartLoader% 28int,%20android.os.Bundle,%20android.support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29) 和 [`destroyLoader`](https://developer.android.com/reference/android/ support/v4/app/LoaderManager.html#destroyLoader%28int%29)。这提供了一些非常特别的保障在回调结束或开始时，例如在销毁一个 loader 后，你将永远不会拿到 [`onLoadFinished`](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29) 的回调。

> 注意事项：就技术来说，这次发布之前，你可以在其他线程中做 loader 操作，但是 `LoaderManager` 不再是线程安全的，会导致经常性的未定义行为。

最重要的是，现在 [`onLoadFinished`](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29) 和 LiveData Observers 一样，总是在 `onStart` 和 `onStop` 之间被调用，且不会在 `onSaveInstanceState` 之后。这样你可以在 `onLoadFinished` 中安全的做 [Fragment Transactions](https://developer.android.com/guide/components/fragments.html#Transactions) 了。

#### 我应当使用什么，loader 后续如何？

像我在之前的博客 [Lifecycle Aware Data Loading with Architecture Components](https://medium.com/google-developers/lifecycle-aware-data-loading-with-android-architecture-components-f95484159de4) 中提到的那样，我强烈建议开发者使用 ViewModel+LiveData 的组合，我认为他们绝对是一个更灵活更容易理解的系统。然而，如果你已经有基于 loader 的 APIs，这些改变应当会极大的提升组件以后的可依赖性和稳定性。

这许多的改变让 Loader 变成一个功能，更加可选的依赖，不需要对 [LifecycleOwner](https://developer.android.com/reference/android/arch/lifecycle/LifecycleOwner.html)/[ViewModelStoreOwner](https://developer.android.com/reference/android/arch/lifecycle/ViewModelStoreOwner.html) 做很底层的修改。

#### 尝试下吧！

如果你正在使用 Loader，请尽快仔细查看并注意行为变更，他们都在[发布事项](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0 ) 中。

> 注意事项：显而易见，只有支持库有这些更改。如果你使用的是 Android 框架的 Loader，请尽快切换到支持库。因为框架的 Loader APIs 不会有错误修复或者计划中的改进。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端 )、[后端](https://github.com/xitu/gold-miner#后端 )、[区块链](https://github.com/xitu/gold-miner#区块链 )、[产品](https://github.com/xitu/gold-miner#产品 )、[设计](https://github.com/xitu/gold-miner#设计 )、[人工智能](https://github.com/xitu/gold-miner#人工智能 ) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

