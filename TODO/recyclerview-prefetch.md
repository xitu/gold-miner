> * 原文地址：[RecyclerView Prefetch](https://medium.com/google-developers/recyclerview-prefetch-c2f269075710#.b1or0k6l3)
* 原文作者：[Chet Haase](https://medium.com/@chethaase)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[tanglie1993](https://github.com/tanglie1993)
* 校对者：[skyar2009](https://github.com/skyar2009), [Zhiw](https://github.com/Zhiw)


# RecyclerView 数据预取

## 更快处理任务，使滚动和滑动更流畅

在我小时候，妈妈为了治疗我的拖延症，总是告诉我：“如果你现在打扫你的房间，就不用以后再打扫了。”但我从没这样做。我知道最好能拖延就尽量拖延。一个原因是：如果我现在打扫了，房间还会变脏，那时候我就必须再打扫一遍了。另外，如果我把这件事放下足够久，妈妈可能会忘了它的。

拖延对我来说总是有效。但我永远不用处理保持帧率的问题，不像我的朋友 RecyclerView 一样。

### 问题

在一次滚动或惯性滑动中，RecyclerView 需要在新条目抵达屏幕时予以展示。这些新条目需要与数据相绑定（如果缓存中没有相应条目的话，还需要创建一个）。接下来，它们还需要被展开并画出来。如果所有这些都是被懒加载的，在需要展示之前才做，UI 线程就会在工作完成时陷入停顿。接下来渲染可以继续并且滚动（或者说滑动，但我打算用滚动来指代它们，以简化讨论）可以平滑地继续，直到下一个条目进入视野范围。 

![](https://cdn-images-1.medium.com/max/1200/1*X9E34oKRhAJbG-uSrhv-TA.png)

一次典型的 RecyclerView 内容滚动中的各个渲染阶段（在 [Lollipop](https://developer.android.com/about/versions/lollipop.html) 版本时的情况）。在UI线程，我们处理输入事件和动画，完成布局，并且记录绘图操作。接下来渲染线程把指令送往GPU。
在一次滚动的大多数帧中，RecyclerView 可以没问题地完成它需要做的事，因为不需要处理新的内容。在这些帧中，UI 线程处理输入事件和动画，完成布局，记录绘图操作。接下来它把绘图信息与渲染线程同步（在 Lollipop 版本时的情况，之前的版本在 UI 线程完成所有工作），渲染线程把指令送往 GPU。

![](https://cdn-images-1.medium.com/max/1200/1*DIr64fruHL5lp72Ji-b7rw.png)

新条目使得输入阶段耗时更长，因为新的 view 需要被创建、绑定并布局。这推迟了渲染阶段的开始，从而导致它可能在帧的边界之后结束。在此情况下，就会发生掉帧。当一个新的条目来到屏幕中时，输入阶段就需要完成更多工作，以绑定（可能还要创建）正确的 view。这推迟了 UI 线程其余的工作，以及渲染线程接下来的工作。如果这些不能在帧边界内完成的话，就会发生卡顿。 

![](https://cdn-images-1.medium.com/max/1200/1*R0vg4lvbNilR1xB5Qrawmw.png)

输入阶段的调用栈表明：新的条目进入视野范围会导致一大块时间被用于创建和绑定新的 view。
如果我们可以在其它地方完成这些工作，而不推迟所有其它事情，不就很好吗？
![](https://cdn-images-1.medium.com/max/1200/1*2XWNdvsSwW8-L_DQwYxLxw.png)

在 view 可以被渲染之前，创建和绑定必须完成。这会在相应的帧中消耗 UI 线程的宝贵时间。然而，UI 线程在前一帧中有大量时间无所事事。
  [Chris Craik](http://androidbackstage.blogspot.com/2015/07/this-time-tor-and-chet-are-joined-by.html)（Android UI Toolkit 组的工程师）在用 [Systraces](https://developer.android.com/studio/profile/systrace.html) 查看 RecyclerView 滚动时发现了这一点。他特别注意到，我们在需要使用一个条目时，会花费大量时间准备它。而在一帧之前，UI 线程花了大量时间休眠，因为它很早就完成了任务。

### 解决方案

![](https://cdn-images-1.medium.com/max/1200/1*_qCP_uaM8nMSlgqU6L1CxA.png)

将创建和绑定工作移到前一帧，使 UI 线程能够与渲染线程同时工作，从而避免接下来在渲染线程绘制结果之前同步完成这些工作。
显然，这是优化耗时的好时机。Chris 重新安排了默认 RecyclerView 布局时事件发生的顺序，它现在在一个条目即将进入视野时预取数据，这样我们可以在空闲期完成工作，避免拖到大家都在等待结果时才完成。
完成这些工作基本上没有任何代价，因为 UI 线程在两帧之间的空隙不做任何工作。我们可以使用这些空闲时间来完成将来的工作，并使得未来的帧出现得更快，因为困难的部分已经被完成了。

### 细节，细节

这个系统的工作方式是，在 RecyclerView 开始一个滚动时安排一个 Runnable。这个 Runnable 负责根据 layout manager 和滚动的方向预取即将进入视野的条目。预取不限于一个单独的条目。它可以同时取出多个条目，例如在使用 GridLayoutManager 且新的一行马上要出现的时候。在 25.1 版本中，预取操作被分为单独的创建/绑定操作，从而比对整组条目做操作更容易被纳入 UI 线程的空隙中。

有趣的是，系统必须预测操作需要多少时间，以及它们是否可以被放入空隙中。毕竟，如果预取把当前帧推迟到截止时间之后，我们仍然会因掉帧而感觉到卡顿，只是和不预取时原因不同而已。系统处理这些细节的方式是追踪每种 view 类型的平均创建/绑定时间，从而使未来创建/绑定时间的合理预测成为可能。

对嵌套 RecyclerView（每一个条目自身都是 RecyclerView 的容器）完成这些工作更加复杂，因为绑定内部 RecyclerView 并不涉及任何子控件的分配——RecyclerView 在被绑定和布局时按需取得子控件。预取系统仍然可以预先准备内层的 RecyclerView 内部的子控件，但它必须知道有多少。这就是 25.1 版本中 LinearLayoutManager 新 API [setInitialItemPrefetchCount()](https://developer.android.com/reference/android/support/v7/widget/LinearLayoutManager.html#setInitialPrefetchItemCount%28int%29)的意义。它告诉系统，在滚动时需要预取多少条目来充满 RecyclerView。

### 警告

你需要注意这些危险：

-预取数据可能做一些最终不被需要的工作。因为我们在预取 view 时，有可能会采取太激进的策略，这样 RecyclerView 就可能不会滚动到我们预取的条目。这意味着我们的预取工作可能会被浪费（虽然这些工作是被并行完成的，应该不会浪费太多时间。另外，浪费是不太可能发生的，因为我们在需要数据之前不久才去预取，而且滚动不太可能在两帧之间停止或反转）。
-渲染线程：渲染线程是 Lollipop 版本引入的性能特性，它可以让一个不同的线程分担渲染工作，并且支持其他的一些改进，例如把不可变的动画（如涟漪、环形展现等）完全放在渲染线程，使其不受 UI 线程停顿的影响。这意味着运行 Lollipop 之前的版本的设备将不会受益于这个优化，因为我们无法并行完成这些工作。

### 我要一些 —— 去哪儿拿？

预取优化是在 [Support Library v25](https://developer.android.com/topic/libraries/support-library/revisions.html#rev25-0-0)中引入，在 [v25.1.0](https://developer.android.com/topic/libraries/support-library/revisions.html#25-1-0)中改进的。所以第一步是下载 [最新版本](https://developer.android.com/topic/libraries/support-library/revisions.html)的支持库。

如果你使用 RecyclerView 提供的默认 layout manager，你将自动获得这种优化。然而，如果你使用嵌套 RecyclerView 或者自己写 layout manager，你需要改变你的代码来利用这个特性。

对于嵌套 RecyclerView 而言，要获取最佳的性能，在内部的 LayoutManager 中调用 LinearLayoutManager 的 [setInitialItemPrefetchCount()](https://developer.android.com/reference/android/support/v7/widget/LinearLayoutManager.html#setInitialPrefetchItemCount%28int%29)方法（25.1版本起可用）。例如，如果你竖直方向的list至少展示三个条目，调用 setInitialItemPrefetchCount(4)。

如果你实现了自己的 LayoutManager，你需要重写 [LayoutManager.collectAdjacentPrefetchPositions()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#collectAdjacentPrefetchPositions%28int,%20int,%20android.support.v7.widget.RecyclerView.State,%20android.support.v7.widget.RecyclerView.LayoutManager.LayoutPrefetchRegistry%29)方法。该方法在数据预取开启时被 RecyclerView 调用（LayoutManager 的默认实现什么都不做）。第二，在嵌套的内层 RecyclerView 中，如果你想让你的 LayoutManager 预取数据，你同样应当实现 [LayoutManager.collectInitialPrefetchPositions()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#collectInitialPrefetchPositions%28int,%20android.support.v7.widget.RecyclerView.LayoutManager.LayoutPrefetchRegistry%29)。

和以前一样，优化你的创建和绑定步骤，做尽可能少的工作，是值得的。运行的最快的代码是根本不需要运行的代码；即使框架可以通过数据预取并行工作，它仍然消耗时间，而且耗时较长的条目创建仍然可以导致卡顿。例如，一棵最小的 view 树总比一棵复杂的更容易创建和绑定。本质上，绑定应该和调用 setter 一样方便，一样快。即使你用目前的代码就可以在一帧的时间限制中完成工作，进一步优化意味着它将更可能在低端的用户机型上运行良好。此外，在高端设备上为这些常用场景节约性能，总是对电池有益的。如果你已经尽可能缩短了创建和绑定的时间，预取将会帮助你缩短两帧之间的剩余时间。

如果你想要见到实际的优化，在默认或自定义的 LayoutManager 中，你可以切换 [LayoutManager.setItemPrefetchEnabled()](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#setItemPrefetchEnabled%28boolean%29)并比较结果。你应该能够从视觉上直观地看到差异；它确实如此显著，特别是在条目需要大量时间创建和绑定的情况下。但如果你想知道在表面下发生过什么，在预取打开和关闭时运行[Systrace](https://developer.android.com/studio/profile/systrace.html), 或者打开 [GPU profiling](https://developer.android.com/studio/profile/dev-options-rendering.html)。

![](https://cdn-images-1.medium.com/max/1600/1*gmuFD82uYJmGVVEPFxs6ag.png)

Systrace 显示数据预取在UI线程空闲时预取数据。
### GOTO 结尾

查看 [最新的 Support Library](https://developer.android.com/topic/libraries/support-library/revisions.html)并和能预取数据的 RecyclerView 一起玩耍。同时，我将继续不清理我的房间。
