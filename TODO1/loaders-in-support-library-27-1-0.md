> * 原文地址：[Loaders in Support Library 27.1.0](https://medium.com/google-developers/loaders-in-support-library-27-1-0-b1a1f0fee638)
> * 原文作者：[Ian Lake](https://medium.com/@ianhlake?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/loaders-in-support-library-27-1-0.md)
> * 译者：
> * 校对者：

# Loaders in Support Library 27.1.0

For [Support Library 27.1.0](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0), I rewrote the internals of `[LoaderManager](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html)`, the class powering the [Loaders API](https://developer.android.com/guide/components/loaders.html) and I wanted to explain the reasoning behind the changes and what to expect going forward.

#### Loaders and Fragments, a history

From the beginning, Loaders and Fragments were pretty tightly tied together at the hip. This meant that a lot of the code in `[FragmentActivity](https://developer.android.com/reference/android/support/v4/app/FragmentActivity.html)` and `[Fragment](https://developer.android.com/reference/android/support/v4/app/Fragment.html)` were there to support Loaders, despite the fact that there are indeed fairly independent. It also meant that the lifecycle and guarantees of Loaders were totally unique and subject to their own set of fun and exciting behavior differences and bugs when compared to the Activity, Fragment, and Architecture Component [lifecycle](https://developer.android.com/topic/libraries/architecture/lifecycle.html).

#### What’s changed in 27.1.0

With 27.1.0, the technical debt of Loaders has been greatly reduced: the lines of code needed to implement `LoaderManager` went down to about a third of its former size and there’s many, many more tests to backfill to ensure that Loaders remain in a good state going forward.

A lot of this is thanks to Architecture Components. More specifically, [ViewModels](https://developer.android.com/topic/libraries/architecture/viewmodel.html) (for retaining state across configuration changes) and [LiveData](https://developer.android.com/topic/libraries/architecture/livedata.html) (for providing lifecycle aware callbacks). Loaders now benefit from these same higher level, super well tested components as their basis, reducing ongoing bit rot and allowing improvements on the reliability/guarantees added there to propagate to Loaders automatically.

#### Behavior Changes

This does mean a few behavior changes though.

For one, calling `[initLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#initLoader%28int,%20android.os.Bundle,%20android.support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29)`, `[restartLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#restartLoader%28int,%20android.os.Bundle,%20android.support.v4.app.LoaderManager.LoaderCallbacks%3CD%3E%29)`, and `[destroyLoader](https://developer.android.com/reference/android/support/v4/app/LoaderManager.html#destroyLoader%28int%29)` now must be done on the main thread. This offers some very specific guarantees on when callbacks stop or start — you’ll never get a callback to `[onLoadFinished](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29)` after destroying a Loader for instance.

> Note: while technically you could do Loader operations on other threads prior to this release, `LoaderManager` was never thread safe, leading to often undefined behavior.

Most importantly, `[onLoadFinished](https://developer.android.com/reference/android/support/v4/app/LoaderManager.LoaderCallbacks.html#onLoadFinished%28android.support.v4.content.Loader%3CD%3E,%20D%29)` now follow the same rules as LiveData Observers for when they will be called — always between `onStart` and `onStop` and never after `onSaveInstanceState`. This allows you to safely do [Fragment Transactions](https://developer.android.com/guide/components/fragments.html#Transactions) in `onLoadFinished`.

#### What should I use and where are Loaders going?

As I mentioned in my previous blog post, [Lifecycle Aware Data Loading with Architecture Components](https://medium.com/google-developers/lifecycle-aware-data-loading-with-android-architecture-components-f95484159de4), I feel like ViewModels+LiveData are definitely a more flexible, easier to understand system that I’d strongly recommend to developers. However, if you have existing APIs built around Loaders, these changes should greatly improve the reliability and stability of the component going forward.

Much of the changes here lay the ground work for making Loaders a more optional dependency that won’t need deep hooks into the [LifecycleOwner](https://developer.android.com/reference/android/arch/lifecycle/LifecycleOwner.html)/[ViewModelStoreOwner](https://developer.android.com/reference/android/arch/lifecycle/ViewModelStoreOwner.html) to function.

#### Try it out!

If you’re using Loaders, please take an extra close look sooner rather than later and note the behavior changes listed in the [release notes](https://developer.android.com/topic/libraries/support-library/revisions.html#27-1-0).

> Note: Obviously, these changes only apply to Support Library Loaders. If you are using Android framework Loaders, please switch to the Support Library Loaders as soon as possible. There are no bug fixes or improvements planned for the framework Loader APIs.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
