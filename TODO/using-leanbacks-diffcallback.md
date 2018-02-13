> * 原文地址：[Using leanback’s DiffCallback: The difference between the DiffUtil callbacks](https://medium.com/google-developers/using-leanbacks-diffcallback-77d47949212b)
> * 原文作者：[Benjamin Baxter](https://medium.com/@benbaxter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-leanbacks-diffcallback.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-leanbacks-diffcallback.md)
> * 译者：
> * 校对者：

# Using leanback’s DiffCallback: The difference between the DiffUtil callbacks

A class called `[DiffUtil](https://developer.android.com/reference/android/support/v7/util/DiffUtil.html)` was introduced in [version 24.2 of the support library](https://developer.android.com/topic/libraries/support-library/rev-archive.html#24-2-0-api-updates) that trivialized updating a `[RecyclerView.Adapter](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.Adapter.html)`. In [version 27.0 of the leanback support library](https://developer.android.com/topic/libraries/support-library/revisions.html#27-0-0) an abstraction of `DiffUtil` has been added that supports `[ArrayObjectAdapter](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html)`.

`[ArrayObjectAdapter](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html)` has a new method called `[setItems(final List itemList, final DiffCallback callback)](https://developer.android.com/reference/android/support/v17/leanback/widget/ArrayObjectAdapter.html#setItems%28java.util.List,%20android.support.v17.leanback.widget.DiffCallback%29)` that accepts a new class called `[DiffCallback](https://developer.android.com/reference/android/support/v17/leanback/widget/DiffCallback.html)`. `DiffCallback` looks like `[DiffUtil.Callback](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html)` with a few methods missing.

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

The list size methods are gone! The `setItems()` method in the adapter knows about the old and new items. When the adapter creates the `DiffUtil.Callback`, it overrides `[getOldListSize()](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html#getOldListSize%28%29)` and `[getNewListSize()](https://developer.android.com/reference/android/support/v7/util/DiffUtil.Callback.html#getNewListSize%28%29)` allowing you to focus on comparing the items in the list.

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

The adapter updates the items and dispatches the animation.

![](https://cdn-images-1.medium.com/max/800/1*3MLrzRJAXtHBQeO4KA0TRA.gif)

ArrayObjectAdapter will dispatch the appropriate animations.

You do not have to call `setItems()` with a `DiffCallback`. If you do not supply `DiffCallback`, the adapter clears the current items and adds all of the new items which may lead to your content flashing on the screen.

![](https://cdn-images-1.medium.com/max/800/1*HAKJdXzrZVRvcIuQ-J2-eQ.gif)

The content in the row jumps as items are removed and added.

Looking at the source code of `setItems()`, we see how `ArrayObjectAdapter` abstracts the boilerplate from `DiffUtil` — giving developers a cleaner API.

![](https://cdn-images-1.medium.com/max/800/1*1AIJuAbtOBUPxUT0_ib8Eg.png)

Part of the source code for `setItems()` in ArrayObjectAdapter.

If you want to experiment with `DiffCallback`, check out this [gist](https://gist.github.com/benbaxter/6c9fbb568d05d8cb4b3829dbdb23e0cb) to get started.

If you are working on an app for Android TV, I would love to hear about what you enjoy and what are your pain points. If you would like to continue the discussion, leave a comment or message me on [Twitter](https://twitter.com/benjamintravels).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
