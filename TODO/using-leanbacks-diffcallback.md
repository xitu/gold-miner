> * 原文地址：[Using leanback’s DiffCallback: The difference between the DiffUtil callbacks](https://medium.com/google-developers/using-leanbacks-diffcallback-77d47949212b)
> * 原文作者：[Benjamin Baxter](https://medium.com/@benbaxter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-leanbacks-diffcallback.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-leanbacks-diffcallback.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：[tanglie1993](https://github.com/tanglie1993), [hanliuxin5](https://github.com/hanliuxin5)

# 使用 leanback 的 DiffCallback： 和 DiffUtil 回调之间的区别

[24.2 版本的 support library](https://developer.android.com/topic/libraries/support-library/rev-archive.html#24-2-0-api-updates) 里引入了一个叫做 [DiffUtil](https://developer.android.com/reference/android/support/v7/util/DiffUtil.html) 的类，它让刷新 [RecyclerView.Adapter](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.Adapter.html) 变得更简单。在 [27.0 版本的 leanback support library](https://developer.android.com/topic/libraries/support-library/revisions.html#27-0-0) 里面又增加了一个支持 [ArrayObjectAdapter](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html) 的抽象 `DiffUtil`。

[ArrayObjectAdapter](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html) 有一个新的方法叫做 [setItems(final List itemList, final DiffCallback callback)](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html#setItems%28java.util.List,%20android.support.v17.leanback.widget.DiffCallback%29)，它接收一个新的类叫做 [DiffCallback](https://developer.android.com/reference/android/support/v17/leanback/widget/DiffCallback.html)。`DiffCallback` 看上去很像 [DiffUtil.Callback](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html)，只是少了几个方法。

```
public abstract class DiffCallback<Value> {

   public abstract boolean areItemsTheSame(@NonNull Value oldItem, 
                                           @NonNull Value newItem);

   public abstract boolean areContentsTheSame(@NonNull Value oldItem,
                                              @NonNull Value newItem);

   @SuppressWarnings("WeakerAccess")
   public Object getChangePayload(@NonNull Value oldItem, @NonNull Value newItem) {
       return null;
   }
}
```

获取 list 大小的方法不见了！这个 adapter 里的 `setItems()` 方法知道旧的数据和新的数据，当 adapter 创建 `DiffUtil.Callback` 的时候，它重写了 [getOldListSize()](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html#getOldListSize%28%29) 和 [getNewListSize()](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html#getNewListSize%28%29) 方法，让你能够专心比较 list 中数据的异同。

```
val diffCallback = object : DiffCallback<DummyItem>() {
    override fun areItemsTheSame(oldItem: DummyItem, 
                                 newItem: DummyItem): Boolean = 
        oldItem.id == newItem.id
    override fun areContentsTheSame(oldItem: DummyItem, 
                                    newItem: DummyItem): Boolean =
        oldItem == newItem
}
itemsAdapter.setItems(randomItems(), diffCallback)
```

Adapter 刷新 item 并且播放动画。

![](https://cdn-images-1.medium.com/max/800/1*3MLrzRJAXtHBQeO4KA0TRA.gif)

ArrayObjectAdapter 会播放合适的动画。

你不一定要调用带有 `DiffCallback` 的 `setItems()` 方法。如果你不支持 `DiffCallback`，adapter 会清空当前的 item 并且添加所有新的 item，这可能导致你的内容在屏幕上闪一下。

![](https://cdn-images-1.medium.com/max/800/1*HAKJdXzrZVRvcIuQ-J2-eQ.gif)

这一行里的内容会在删除和添加 item 的时候闪动。

通过查看 `setItems()` 的源码，我们可以发现 `ArrayObjectAdapter` 是如何抽象 `DiffUtil` 里的样板方法，给开发者提供一个更整洁的 API。

![](https://cdn-images-1.medium.com/max/800/1*1AIJuAbtOBUPxUT0_ib8Eg.png)

ArrayObjectAdapter 里面 `setItems()` 方法的部分源码。

如果你想尝试使用 `DiffCallback`，可以从参考这篇 [gist](https://gist.github.com/benbaxter/6c9fbb568d05d8cb4b3829dbdb23e0cb) 开始。

如果你在开发 Android TV 平台上的应用，我很想了解开发过程中你最喜欢的是什么，还有你的痛点是什么。如果你想继续这个话题，请在 [Twitter](https://twitter.com/benjamintravels) 上给我评论或者留言。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
