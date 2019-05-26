> * 原文地址：[Windows Insets + Fragment Transitions: A tale of woe](https://medium.com/google-developers/windows-insets-fragment-transitions-9024b239a436)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/windows-insets-fragment-transitions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/windows-insets-fragment-transitions.md)
> * 译者：[LeeSniper](https://github.com/LeeSniper)
> * 校对者：[Starrier](https://github.com/Starriers)

# WindowsInsets 和 Fragment 过渡动画

## 一个悲伤的故事

![](https://cdn-images-1.medium.com/max/1000/1*QUTUt9FU2cA9czR2ArOI8g.jpeg)

[猫和窗户](https://flic.kr/p/92WJtS).

这篇文章是我写的关于 fragment 过渡动画的小系列中的第二篇。第一篇可以通过下面的链接查看，里面写了如何让 fragment 过渡动画开始工作。

- [**Fragment 过渡动画**：让他们工作起来](https://medium.com/google-developers/fragment-transitions-ea2726c3f36f)

* * *

> 在我开始进一步探讨之前，我会假设你知道什么是 WindowsInsets 以及它们是如何分发的。如果你不知道，我建议你先看这个演讲（是的，这是我的演讲 🙋）

- [**成为屏幕适配大师 🔧**: WindowInsets 一直是开发者头疼的对象，那是因为它们确实很难理解……_chris.banes.me](https://chris.banes.me/talks/2017/becoming-a-master-window-fitter-lon/)

* * *

我需要坦白。当我在写本系列第一篇博客文章的时候，我对视频做了点手脚。实际上我遇到了 WindowInsets 的问题，也就是说我实际上最终得到的是以下结果：

![](https://cdn-images-1.medium.com/max/800/1*F5gd8B0lTil_dF7pwP9JbA.gif)

过渡动画破坏了状态栏的效果。

Woops，跟我在第一篇文章中展示的效果不太一样 🤐。我不想让第一篇文章变得太复杂，所以决定单独写这篇文章。无论如何，你可以看到当添加过渡动画之后，我们突然失去了所有状态栏的效果，而且视图被推到状态栏的下面。

#### 问题

这两个 fragment 为了在系统栏下面进行绘制都大量使用了 WindowInsets。Fragment A 使用了 [CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html) 和 [AppBarLayout](https://developer.android.com/reference/android/support/design/widget/AppBarLayout.html)，而 Fragment B 使用自定义 WindowInsets 来处理（通过一个 [OnApplyWindowInsetsListener](https://developer.android.com/reference/android/support/v4/view/OnApplyWindowInsetsListener.html)）。无论它们是如何实现的，过渡动画都会混淆两者。

那么为什么会这样呢？其实当你在使用 fragment 过渡动画时，退出（Fragment A）和进入（Fragment B）的内容视图实际上经历了以下几个过程：

1.  过渡动画开始。
2.  因为我们对 Fragment A 使用了一个退出的过渡动画，所以 View A 还留在原来的位置，过渡动画在上面运行。
3.  View B 被添加到内容视图里面，并且被立即设置成不可见。
4.  Fragment B 的进入动画和“共享元素进入”过渡动画开始执行。
5.  View B 被设置成可见的。
6.  当 Fragment A 的退出动画结束的时候，View A 从容器视图中移除。

这一切听起来都很好，那为什么会突然影响到 WindowInsets 的效果呢？这是因为在过渡的过程中，两个 fragment 的视图都存在于容器中。

但是这听起来完全 OK 啊，不是吗？然而在我的场景中，这两个 fragment 的视图都想要处理和消费 WindowInsets，因为它们都期望在屏幕上显示唯一的“主”视图。可是只有其中的一个视图会收到 WindowInsets：也就是第一个子 view。这取决于 ViewGroup 是如何[分发 WindowInsets](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/ViewGroup.java#6928) 的，也就是通过按顺序遍历它的子节点直到其中的一个消费了 WindowInsets。 如果第一个子 view（就是这里的 Fragment A）消费了 WindowInsets，任何后续的子 view（就是这里的 Fragment B）都不会得到它们，我们最终就会得到这种情况。

让我们再来一步一步检查一遍，只是这一次加上分发 windowinsets 的时机：

1.  过渡动画开始。
2.  因为我们对 Fragment A 使用了一个退出的过渡动画，所以 View A 还留在原来的位置，过渡动画在上面运行。
3.  View B 被添加到内容视图里面，并且被立即设置成不可见。
4.  **分发 WindowInsets。我们希望 View B（child 1）拿到它们，但是 View A（child 0）又一次拿到了 WindowInsets。**
5.  Fragment B 的进入动画和‘共享元素进入’过渡动画开始执行。
6.  View B 被设置成可见的。
7.  当 Fragment A 的退出动画结束的时候，View A 从容器视图中移除。

#### 修复

这个修复实际上相对简单：我们只需要确保两个视图都能够拿到 WindowInsets。

我实现这一点的方法是通过在容器视图（在这个例子中就是在宿主 activity）里添加一个 [OnApplyWindowInsetsListener](https://developer.android.com/reference/android/support/v4/view/OnApplyWindowInsetsListener.html)，它会手动分发 WindowInsets 给所有的子 view，直到其中一个子 view 消费掉这个 WindowInsets。

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

在我们应用这个修复之后，这两个 fragment 都会收到 WindowInsets，然后我们就会得到第一篇文章中实际显示的结果：

![](https://cdn-images-1.medium.com/max/800/1*qIMJQmMCS_g9Yl4XfPEMQQ.gif)

* * *

#### 额外部分 💃: 一定要进行请求

还有一件我差点忘了写的小事。如果你要在 fragment 里面处理 WindowInsets，无论是隐式（通过使用 AppBarLayout 等）还是显式，你需要确保请求了一些 WindowInsets。只需要调通过 [requestApplyInsets()](https://developer.android.com/reference/android/support/v4/view/ViewCompat.html#requestApplyInsets%28android.view.View%29) 就能很容易做到：

	override fun onViewCreated(view: View, icicle: Bundle) {
  		super.onViewCreated(view, savedInstanceState)
  		// yadda, yadda
  		ViewCompat.requestApplyInsets(view)
	}

你必须这样做是因为窗口只有在整个视图层级总体的系统 UI 可见性的值发生**改变**的时候才会自动分发 WindowInsets。 由于有时你的两个 fragment 可能提供完全相同的值，总体的值不会改变，因此系统将忽略这个“改变”。



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
