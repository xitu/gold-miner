> * 原文地址：[Windows Insets + Fragment Transitions: A tale of woe](https://medium.com/google-developers/windows-insets-fragment-transitions-9024b239a436)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/windows-insets-fragment-transitions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/windows-insets-fragment-transitions.md)
> * 译者：
> * 校对者：

# Windows Insets + Fragment Transitions

## A tale of woe

![](https://cdn-images-1.medium.com/max/1000/1*QUTUt9FU2cA9czR2ArOI8g.jpeg)

[Cat Window](https://flic.kr/p/92WJtS).

This post is the second in a small series I’m writing about fragment transitions. The first is available below, which sets up how to get fragment transitions working.

- [**Fragment Transitions**: Getting them working_medium.com](https://medium.com/google-developers/fragment-transitions-ea2726c3f36f)

* * *

> Before I go any further, I’m going to assume you know what window insets are and how they’re dispatched. If you don’t, I suggest you watch this talk (and yes, it’s from me 🙋)

- [**Becoming a master window fitter 🔧**: Window insets have long been a source of confusion to developers, and that's because they are indeed very confusing…_chris.banes.me](https://chris.banes.me/talks/2017/becoming-a-master-window-fitter-lon/)

* * *

I have a confession to make. When I was working on the first blog post in this series I cheated a bit with the videos. I actually hit an issue with window insets which meant that I actually ended up with the following:

![](https://cdn-images-1.medium.com/max/800/1*F5gd8B0lTil_dF7pwP9JbA.gif)

Transition breaks status bar handling.

Woops, not exactly what I showed in the first post 🤐. I did not want to overcomplicate the first post so decided to write this up separately. Anyway, you can see that we suddenly lost all status bar handling when the transition was added, and the views got pushed up behind the status bar.

#### The problem

Both of these fragments make heavy use of the window insets to draw behind the system bars. Fragment A uses a [CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html) and [AppBarLayout](https://developer.android.com/reference/android/support/design/widget/AppBarLayout.html), whereas Fragment B uses custom window inset handling (via an [OnApplyWindowInsetsListener](https://developer.android.com/reference/android/support/v4/view/OnApplyWindowInsetsListener.html)). Regardless of the implementation, the transition messes with both.

So why is this happening? Well when you’re using fragment transitions, what actually happens to the exiting (Fragment A) and entering (Fragment B) content views is the following:

1.  Transition is `commit()`ed.
2.  Since we’re using an exit transition on Fragment A, View A stays in place and the transition is run on it.
3.  View B is added to the container view and immediately set to be invisible.
4.  Fragment B’s enter and ‘shared element enter’ transitions are started.
5.  View B is set to be visible.
6.  When Fragment A’s exit transition has finished, View A is removed from the container view.

That all sounds fine, so why does it suddenly affect window insets handling? It’s all due the fact that during the transition, both fragments’ views are present in the container.

That sounds perfectly OK though right? Well in my scenario both of the fragments’ views want to handle and consume the window insets, since they both expect to the only “main” view on screen. Only one of the views will receive the window insets though: the first child. This is due to how ViewGroup [dispatches window insets](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/ViewGroup.java#6928), which is by iterating through it’s children in order until one of them consumes the insets. If the first child (fragment A here) consumes the insets, any subsequent children (fragment B here) won’t get them, and we end up in this situation.

Lets step through again, but this time add in the time when window insets are dispatched:

1.  Transaction is `commit()`ed.
2.  Since we’re using an exit transition, View A stays in place and the transition is run on it.
3.  View B is added to the container view and immediately set to be invisible.
4.  **Window insets are dispatched. We want View B (child 1) to get them, but View A (child 0) gets them again.**
5.  Fragment B’s enter and ‘shared element enter’ transitions are started.
6.  View B is set to be visible.
7.  When Fragment A’s exit transition has finished, View A is removed.

#### The fix

The fix is actually relatively simple: we just need to make sure that both views
receive the window insets.

The way I’ve done this is by adding an [OnApplyWindowInsetsListener](https://developer.android.com/reference/android/support/v4/view/OnApplyWindowInsetsListener.html) to the container view (in the host activity in this case) which manually dispatches any insets to all of it’s children, not just until one consumes the insets.

```
fragment_container.setOnApplyWindowInsetsListener { view, insets ->
  var consumed = false

  (view as ViewGroup).forEach { child ->
    // Dispatch the insets to the child
    val childResult = child.dispatchApplyWindowInsets(insets)
    // If the child consumed the insets, record it
    if (childResult.isConsumed) {
      consumed = true
    }
  }

  // If any of the children consumed the insets, return
  // an appropriate value
  if (consumed) insets.consumeSystemWindowInsets() else insets
}
```

After we apply that, both fragments receive the window insets and we get the result I actually shown in the first post:

![](https://cdn-images-1.medium.com/max/800/1*qIMJQmMCS_g9Yl4XfPEMQQ.gif)

* * *

#### Bonus section 💃: make sure to request

One small related thing which I nearly forgot to write about. If you’re handling window insets in fragments, implicitly (by using AppBarLayout, etc) or explicitly, you need to make sure that you request some insets. This is easy to do with [requestApplyInsets()](https://developer.android.com/reference/android/support/v4/view/ViewCompat.html#requestApplyInsets%28android.view.View%29):

```
override fun onViewCreated(view: View, icicle: Bundle) {
  super.onViewCreated(view, savedInstanceState)
  // yadda, yadda
  ViewCompat.requestApplyInsets(view)
}
```

You have to do this is because the window will only send insets down automatically if the aggregated system ui visibility value for the entire view hierarchy **changes**. Since there may be times when your two fragments provide the exact same value, the aggregated value will not change, so the system will ignore the ‘change’.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
