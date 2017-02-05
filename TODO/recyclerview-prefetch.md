> * 原文地址：[RecyclerView Prefetch](https://medium.com/google-developers/recyclerview-prefetch-c2f269075710#.b1or0k6l3)
* 原文作者：[Chet Haase](https://medium.com/@chethaase)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# RecyclerView Prefetch

## Smoother Flings and Scrolls by Doing Stuff Sooner

When I was a kid, my mother would attempt to cure my persistent procrastination by telling me that if I cleaned my room now, I wouldn’t have to do it later. But I never fell for it. I knew that it was always best to let it ride as long as possible. For one thing, if I cleaned it now, it’d just get dirty again, and then I’d have to perform that odious chore twice. Also, if I let it go long enough, she might just forget about it.

Procrastination has always worked for me. But I never had to deal with the issue of consistent frame-rate, unlike my friend RecyclerView.

### The Problem

During a scroll or fling operation, RecyclerView will need to display new items as they arrive on screen. These new items need to be bound to the data (and possibly created, if there are no items like it in the cache). Then they need to be laid out and drawn. When all of this is done lazily, just before it is needed, the UI thread can grind to a halt while the work completes. Then rendering can proceed and the scroll (or fling, but I’ll just refer to either as “scroll” from here on to simplify things) can get back to moving along smoothly… until the next new item comes into view.

![](https://cdn-images-1.medium.com/freeze/max/60/1*X9E34oKRhAJbG-uSrhv-TA.png?q=20)![](https://cdn-images-1.medium.com/max/1200/1*X9E34oKRhAJbG-uSrhv-TA.png)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1200/1*X9E34oKRhAJbG-uSrhv-TA.png">

Typical rendering phases of RecyclerView content during a scroll (as of the Lollipop release). On the UI thread, we process input events, handle animations, perform layout, and record the drawing operations. Then the RenderThread (RT) sends the commands to the GPU.
During most frames of a scroll, the RecyclerView has no problem doing what it needs to do, because there is no new content to deal with. During these frames, the UI thread processes input, handles animations, performs layout, and records drawing commands. It then syncs the drawing information over to the RenderThread (as of the [Lollipop](https://developer.android.com/about/versions/lollipop.html) release; prior releases do all of this work on the UI thread), which sends those commands over to the GPU.

![](https://cdn-images-1.medium.com/freeze/max/60/1*DIr64fruHL5lp72Ji-b7rw.png?q=20)![](https://cdn-images-1.medium.com/max/1200/1*DIr64fruHL5lp72Ji-b7rw.png)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1200/1*DIr64fruHL5lp72Ji-b7rw.png">

New items cause the Input stage to take longer as new views are created, bound, and laid out. This results in a later start for the Render stage, which might cause it to finish after the frame boundary, resulting in a missed frame.
When a new item comes on screen, more work is required in the input stage to bind, and possibly create, the appropriate views. This pushes the rest of the UI thread work later, as well as the ensuing work of the RenderThread, and can cause jank if it cannot all happen within the frame boundary.

![](https://cdn-images-1.medium.com/freeze/max/60/1*R0vg4lvbNilR1xB5Qrawmw.png?q=20)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1200/1*R0vg4lvbNilR1xB5Qrawmw.png">

The call stack during input shows that new items coming into view cause a large chunk of time to be spent creating and binding the new views
Examining the call stack during the input phase when these new items come in shows us that a large portion of the time is spent creating and binding the views.

Wouldn’t it be nice if we could do that work elsewhere instead of delaying everything while we get those new items ready?

![](https://cdn-images-1.medium.com/freeze/max/60/1*2XWNdvsSwW8-L_DQwYxLxw.png?q=20)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1200/1*2XWNdvsSwW8-L_DQwYxLxw.png">

Creating and binding views has to be done before they can be rendered, which takes up valuable time on the UI thread during the frame in which they’re needed. But meanwhile, that thread spends a lot of time idling in the previous frame…
This is the observation that [Chris Craik](http://androidbackstage.blogspot.com/2015/07/this-time-tor-and-chet-are-joined-by.html) (a graphics engineer on the Android UI Toolkit team) made when he was looking at [Systraces](https://developer.android.com/studio/profile/systrace.html) of RecyclerView scrolls. Specifically, he saw that we’re spending a lot of time getting the items ready right when they’re needed. But meanwhile, just a frame before that, the UI thread was spending a lot of the time in that frame sleeping, because it finished its tasks early.

### The Solution

![](https://cdn-images-1.medium.com/freeze/max/60/1*_qCP_uaM8nMSlgqU6L1CxA.png?q=20)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1200/1*_qCP_uaM8nMSlgqU6L1CxA.png">

Moving the creation and bind operations to the previous frame allows the UI Thread to do that work in parallel with the RenderThread, and avoids doing it later when it has to be done synchronously before the RenderThread can draw the results.
Obviously, it was time to play around with time. Specifically, Chris rearranged the way things happen in the default RecyclerView layouts such that it now pre-fetches items that are *about* to come into view, so that we do this work during an idle phase, and avoid doing it later when everyone’s waiting for those results.

Now the work can happen essentially for free. Because the UI Thread was not doing any work in that gap between frames, we’re able to use that idle time to get work done that we will need later, and make that future frame that much faster because the hard part is already done.

### Details, Details

The system works by scheduling a Runnable whenever RecyclerView starts a scrolling operation. This Runnable performs the prefetch of items that should come into view soon, depending on the layout manager and the direction that the views are being scrolled. Prefetching is not limited to a single item, either; it can fetch multiple items at once, such as when a row of GridLayoutManager items is coming on screen. In v25.1, prefetch operations are broken up into individual create/bind operations, which fit more easily into the UI thread gaps than operations on whole groups of items.

One of the interesting things about the prefetch approach is that the system has to predict how much time operations will take, and whether they can fit within the available gap. After all, if prefetch work delayed that frame past its deadline, we may still have jank from a skipped frame, just in a different place than we would without the prefetch. The way that the system handles this detail is by tracking the average create/bind durations per view type, enabling reasonable prediction of future create/bind operations.

Performing this work for nested RecyclerViews (containers whose items are, themselves, RecyclerViews) is trickier, since binding the inner RecyclerView doesn’t allocate any children — RecyclerView fetches children on demand when it’s attached and laid out. The prefetching system can still prepare children within that inner RecyclerView, but it has to know how many. This is the reason for the new API in v25.1 of LinearLayoutManager, [setInitialItemPrefetchCount()](https://developer.android.com/reference/android/support/v7/widget/LinearLayoutManager.html#setInitialPrefetchItemCount%28int%29), which tells the system how many items to prefetch to fill the RecyclerView when it’s about to scroll on screen.

### Caveats

There are a some important caveats here to be aware of:

- Pre-fetching may do work that ends up not being needed. Because we are pre-fetching a view, it is possible that we are doing this too aggressively, and that the RecyclerView will not get to the item in question. This means that our pre-fetching work may be wasted (although since it happened in parallel, this should not be a big deal. Besides, this should be pretty uncommon because we are fetching very soon before it is needed, and it’s unlikely that the scroll will stop or reverse between those two frames).
- RenderThread: The RenderThread was a performance feature introduced in Lollipop, to offload rendering onto a different thread and allow for some improvements such as running some immutable animations (for example, ripples and circular reveals) completely on the RenderThread, without being affected by UI Thread stalls. This means that devices running on releases earlier than Lollipop will not benefit from this optimization, because we cannot parallelize this work.

### I Want Some — Where Can I Get It?

The pre-fetch optimizations were introduced in [Support Library v25](https://developer.android.com/topic/libraries/support-library/revisions.html#rev25-0-0), with further enhancements in [v25.1.0](https://developer.android.com/topic/libraries/support-library/revisions.html#25-1-0). So the first step is to get the [latest version](https://developer.android.com/topic/libraries/support-library/revisions.html) of the Support Library.

If you use the default layout managers provided with RecyclerView, you will automatically get this optimization. However, if you are using nested RecyclerViews, or you wrote your own layout manager, you will need to change your code in order to take advantage of this feature.

For nested RecyclerViews, call LinearLayoutManager’s new [setInitialItemPrefetchCount()](https://developer.android.com/reference/android/support/v7/widget/LinearLayoutManager.html#setInitialPrefetchItemCount%28int%29) method (available in v25.1) on the inner LayoutManagers to get the best performance. For example, if rows in your vertical list show over three items at a minimum, call setInitialItemPrefetchCount(4).

If you’ve implemented your own LayoutManager, you will need to override [LayoutManager.collectAdjacentPrefetchPositions()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#collectAdjacentPrefetchPositions%28int,%20int,%20android.support.v7.widget.RecyclerView.State,%20android.support.v7.widget.RecyclerView.LayoutManager.LayoutPrefetchRegistry%29), which is called by RecyclerView when prefetch is enabled (the default implementation in LayoutManager does nothing). Secondly, if you want prefetching to occur from your LayoutManager when its RecyclerView is nested in another, you should also implement [LayoutManager.collectInitialPrefetchPositions()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#collectInitialPrefetchPositions%28int,%20android.support.v7.widget.RecyclerView.LayoutManager.LayoutPrefetchRegistry%29).

As always, it is worth optimizing both your create and bind steps, doing as little work as possible. The fastest code is that which doesn’t have to run; even when the framework can parallelize work done through prefetching, it still takes time, and expensive item creation can still cause jank. For example, a minimal view tree will always be cheaper to create and bind than a more complex one. And binding should essentially be as simple and fast as calling setters. Even if you are able to skate by under the frame time limit with your current code, optimizing it further means you will be more likely to run well on users’ lower-end devices, and saving performance even on higher-end devices always has battery benefits for these common situations. If you’ve already gotten the creation and bind as fast as they can be, then prefetching should help you hide the remaining time in the gap between frames.

If you want to see the optimization in action, either in one of the default LayoutManagers or in a custom LayoutManager of yours, you can toggle [LayoutManager.setItemPrefetchEnabled()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#setItemPrefetchEnabled%28boolean%29) and compare the results. You should be able to see the results visually; it really is that significant, especially with items that take a significant amount of time to create and bind. But if you want to see what’s going on under the hood, run a [Systrace](https://developer.android.com/studio/profile/systrace.html), or enable [GPU profiling](https://developer.android.com/studio/profile/dev-options-rendering.html), with and without prefetch enabled.

![](https://cdn-images-1.medium.com/freeze/max/60/1*gmuFD82uYJmGVVEPFxs6ag.png?q=20)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*gmuFD82uYJmGVVEPFxs6ag.png">

Systrace showing prefetch occurring during the otherwise idle time of the UI thread
### GOTO End

Check out the [latest Support Library](https://developer.android.com/topic/libraries/support-library/revisions.html) and play with the new prefetching RecyclerView. Meanwhile, I’ll get back to not cleaning my room.
