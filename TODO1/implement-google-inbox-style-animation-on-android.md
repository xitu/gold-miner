> - 原文地址：[Implement Google Inbox Style Animation on Android](https://proandroiddev.com/implement-google-inbox-style-animation-on-android-18c261baeda6)
> - 原文作者：[Huan Nguyen](https://proandroiddev.com/@huan.nguyen?source=post_header_lockup)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implement-google-inbox-style-animation-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implement-google-inbox-style-animation-on-android.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：

# 在 Android 上实现 Google Inbox 的样式动画

![](https://cdn-images-1.medium.com/max/2000/1*aPCvPk2Yoh7C2e4MovuT8Q.jpeg)

作为一个 Android 用户和开发人员，我总是被精美的应用程序所吸引，这些应用程序具有漂亮而有意义的动画。对我来说，这样的应用程序不仅拥有了强大的功能，使用户的生活更便捷，同时还表现出他们背后的团队为了将用户体验提升一个层次所投入的精力和热情。我经常享受体验这些动画，然后花费数小时时间去试图复制它们。其中一个应用程序是 Google Inbox ，它提供了一个漂亮的电子邮件打开/关闭动画，如下所示（如果你不熟悉它）。



![](https://cdn-images-1.medium.com/max/800/1*KOc31AjVOzoNIutQPYIdow.gif)

在本文中，我将带您体验在 Android 上复制动画的旅程。

------

### 设置

为了复制动画，我构建了一个简单的带有2个 fragment 的应用程序 ，如下所示分别是 Email List fragment 和 Email Details fragment 。

![](https://cdn-images-1.medium.com/max/800/1*LoYsgZ4-uXPYdgqzXMmRmg.png)

电子邮件列表 InProgress 状态（左） - 电子邮件列表 Success 状态（中） - 电子邮件详细信息（右）

为了模拟电子邮件获取网络请求，我为 Email List fragment 创建了一个 `[ViewModel]（https://developer.android.com/reference/android/arch/lifecycle/ViewModel）`，它生成了2个状态，`InProgress` 表示正在获取电子邮件，`Success` 表示电子邮件数据已成功获取并准备好呈现（网络请求被模拟为2秒）。



```
sealed class State {
  object InProgress : State()
  data class Success(val data: List<String>) : State()
}
```

Email List fragment 有一种方法来呈现这些状态，如下所示。

```
private fun render(state: State) {
    when (state) {
      is InProgress -> {
        emailList.visibility = GONE
        progressBar.visibility = VISIBLE
      }

      is Success -> {
        emailList.visibility = VISIBLE
        progressBar.visibility = GONE
        emailAdapter.setData(state.data)
      }
}
```

每当 Email List fragment 被新加载时，都会获取电子邮件数据并呈现 `InProgress` 状态，直到电子邮件数据可用（`Success`状态）。点击电子邮件列表中的任何电子邮件项目将使用户进入 Email Details fragment ，并将用户从电子邮件详细信息中带回电子邮件列表。

现在开始我们的旅程吧...

### 第一站 - 那是什么样的动画？

有一点是可以立刻确定的就是他是一种 `[Explode]（https://developer.android.com/reference/android/transition/Explode）`过渡动画，因为在被点击的 item 上下的 item 有过度。但是等一下，电子邮件详细信息 view 也会从点击的电子邮件项目进行转换和扩展。这意味着还有一个共享元素转换。结合我说的，下面是我做出的第一次尝试。

```
override fun onBindViewHolder(holder: EmailViewHolder, position: Int) {
      fun onViewClick() {
        val viewRect = Rect()
        holder.itemView.getGlobalVisibleRect(viewRect)

        exitTransition = Explode().apply {
          duration = TRANSITION_DURATION
          interpolator = transitionInterpolator
          epicenterCallback = object : Transition.EpicenterCallback() {
                override fun onGetEpicenter(transition: Transition) = viewRect
              }
        }

        val sharedElementTransition = TransitionSet()
            .addTransition(ChangeBounds())
            .addTransition(ChangeTransform())
            .addTransition(ChangeImageTransform()).apply {
              duration = TRANSITION_DURATION
              interpolator = transitionInterpolator
            }

        val fragment = EmailDetailsFragment().apply {
          sharedElementEnterTransition = sharedElementTransition
          sharedElementReturnTransition = sharedElementTransition
        }

        activity!!.supportFragmentManager
            .beginTransaction()
            .setReorderingAllowed(true)
            .replace(R.id.container, fragment)
            .addToBackStack(null)
            .addSharedElement(holder.itemView, getString(R.string.transition_name))
            .commit()
      }

      holder.bindData(emails[position], ::onViewClick)
    }
```

这是我得到的（电子邮件详细信息视图的背景设置为蓝色，以便清楚地演示过渡效果）...

![](https://cdn-images-1.medium.com/max/800/1*ZuO5DDmtjvb2zY2kTyRxwQ.gif)

当然这不是我想要的。这里有两个问题。

1. 电子邮件项目不会同时开始转换。远离被点击条目的 items 过度的更快。
2. 被点击的电子邮件项目上的共享元素转换与其他项目的转换不同步，即，当分别展开时，`Email 4` 和`Email 6`应始终粘贴在蓝色矩形的顶部和底部边缘。但他们没有！

所以究竟哪里出了问题？

### 第二站：开箱即用的 Explode 效果不是我想要的。

在深入研究 `Explode` 源代码后，我发现了两个有趣的事实：

- 它使用 `CircularPropagation` 来强制执行这样一条规则，即，当它们从屏幕上消失时，离中心远的视图过渡速度会地比离中心近的视图快。`Explode`过渡的中心被设置为覆盖被点击的电子邮件项目的矩形。这解释了为什么未打开的电子邮件项目视图不会如上所述一起转换。
- 电子邮件条目的上下距离和被点击的条目的上下距离是不一样的。在这种特定情况下，该距离被确定为从被点击项目的中心点到屏幕的每个角落的距离中最长的。

所以我决定编写自己的 `Explode`过渡。我将它命名为 `SlideExplode` ，因为它与`Slide `  过渡非常相似，只是有2个部分在2个相反的方向上移动。

```
import android.animation.Animator
import android.animation.ObjectAnimator
import android.graphics.Rect
import android.transition.TransitionValues
import android.transition.Visibility
import android.view.View
import android.view.ViewGroup

private const val KEY_SCREEN_BOUNDS = "screenBounds"

/**
 * A simple Transition which allows the views above the epic centre to transition upwards and views
 * below the epic centre to transition downwards.
 */
class SlideExplode : Visibility() {
  private val mTempLoc = IntArray(2)

  private fun captureValues(transitionValues: TransitionValues) {
    val view = transitionValues.view
    view.getLocationOnScreen(mTempLoc)
    val left = mTempLoc[0]
    val top = mTempLoc[1]
    val right = left + view.width
    val bottom = top + view.height
    transitionValues.values[KEY_SCREEN_BOUNDS] = Rect(left, top, right, bottom)
  }

  override fun captureStartValues(transitionValues: TransitionValues) {
    super.captureStartValues(transitionValues)
    captureValues(transitionValues)
  }

  override fun captureEndValues(transitionValues: TransitionValues) {
    super.captureEndValues(transitionValues)
    captureValues(transitionValues)
  }

  override fun onAppear(sceneRoot: ViewGroup, view: View,
                        startValues: TransitionValues?, endValues: TransitionValues?): Animator? {
    if (endValues == null) return null

    val bounds = endValues.values[KEY_SCREEN_BOUNDS] as Rect
    val endY = view.translationY
    val startY = endY + calculateDistance(sceneRoot, bounds)
    return ObjectAnimator.ofFloat(view, View.TRANSLATION_Y, startY, endY)
  }

  override fun onDisappear(sceneRoot: ViewGroup, view: View,
                           startValues: TransitionValues?, endValues: TransitionValues?): Animator? {
    if (startValues == null) return null

    val bounds = startValues.values[KEY_SCREEN_BOUNDS] as Rect
    val startY = view.translationY
    val endY = startY + calculateDistance(sceneRoot, bounds)
    return ObjectAnimator.ofFloat(view, View.TRANSLATION_Y, startY, endY)
  }

  private fun calculateDistance(sceneRoot: View, viewBounds: Rect): Int {
    sceneRoot.getLocationOnScreen(mTempLoc)
    val sceneRootY = mTempLoc[1]
    return when {
      epicenter == null -> -sceneRoot.height
      viewBounds.top <= epicenter.top -> sceneRootY - epicenter.top
      else -> sceneRootY + sceneRoot.height - epicenter.bottom
    }
  }
}
```

现在我已经为 `SlideExplode` 交换了 `Explode`，让我们再试一次。

![](https://cdn-images-1.medium.com/max/800/1*7ddUWQHt5AnSMHbH7rV2LA.gif)

这样就好多了！上面和下面的项目现在开始同时转换。请注意，由于插值器设置为 `FastOutSlowIn`，因此当`Email 4`和`Email 6`分别靠近顶部和底部边缘时，它们会减慢速度。这表明 `SlideExplode` 过渡正常。

但是，`Explode` 转换和共享元素转换仍未同步。我们可以看到他们正在以不同的模式移动，这表明他们的插值器可能不同。前一个过渡开始非常快，最后减速，而后者一开始很慢，一段时间后加速。

但是怎么样？我确实在代码中将插值器设置相同了！

### 第三站：原来是 TransitionSet 的锅！

我再次深入研究源代码。这次我发现每当我将插值器设置为` TransitionSet` 时，它都不会在过渡的时候将插值器分配给它。这仅在标准  `TransitionSet中` 发生。它的支持版本（`android.support.transition.TransitionSet`）正常工作。要解决此问题，我们可以切换到支持版本，或者使用下面的扩展函数将插值器明确地传递给包含的转换。

```
fun TransitionSet.setCommonInterpolator(interpolator: Interpolator): TransitionSet {
  (0 until transitionCount)
      .map { index -> getTransitionAt(index) }
      .forEach { transition -> transition.interpolator = interpolator }

  return this
}
```

让我们在更新插值器的设置后再试一次。

![](https://cdn-images-1.medium.com/max/800/1*und_Bh9Mf-pJRMnyNCO9lg.gif)

YAYYYY！现在看起来很正确。但反向过渡怎么样？

![](https://cdn-images-1.medium.com/max/800/1*0SnMV9Lw5_KKpFllkdzXmg.gif)

没有达到我想要的结果！Explode 过渡似乎有效。但是，共享元素过渡不会。

### 第四站：推迟进入转换

反向过渡动画不起作用的原因是它发挥得太早。对于任何过渡的工作，它需要捕获目标视图的开始和结束状态（大小，位置，范围），在这种情况下，它们是  `Email Details`  视图和  `Email 5 item` 项。如果在 `Email 5 item` 的状态可用之前启动了反向转换，则它将无法像我们所看到的那样正常运行。

这里的解决方案是推迟反向转换，直到绘制项目。幸运的是， transition 框架提供了一对 `postponeEnterTransition`  方法，它向系统标记输入过渡应该被推迟，`startPostponedEnterTransition` 表示它可以启动。请注意，必须在调用 `startPostponedEnterTransition` 后的某个时间调用 `postponeEnterTransition` 。否则，将永远不会执行过渡动画，并且 fragment 也不会弹出。

根据我们的设置，每当从 Email Details fragment 重新进入 Email List fragment 时，它会从视图模型中获取最新状态并立即呈现电子邮件列表。因此，如果我们推迟过渡动画，直到呈现电子邮件列表，这不会是相当长的等待，因此推迟是有意义的（从死进程中恢复并弹出是一个不同的故事。这将在后面的帖子中介绍）。

更新后的代码如下所示。我们推迟了  `onViewCreated`  中的 enter 转换。

```
override fun onViewCreated(view: View, savedState: Bundle?) {
  super.onViewCreated(view, savedInstanceState)
  postponeEnterTransition()
  ...
}
```

并在渲染状态后开始推迟过渡。这是使用 [doOnPreDraw](https://android.github.io/android-ktx/core-ktx/androidx.view/android.view.-view/do-on-pre-draw.html)完成的。

```
is Success -> {
  ...
  (view?.parent as? ViewGroup)?.doOnPreDraw {
    startPostponedEnterTransition()
  }
}
```

![](https://cdn-images-1.medium.com/max/800/1*kpw-wtv3aOOki3p225Ou8Q.gif)

现在它成功了！但当方向变换时这个过度效果还会存在吗？

### 第五站：位置方向改变

转换后，Email List fragment 并没有发生反转过渡动画。经过一些调试后，我发现当 fragment 的方向发生改变时，过渡动画也被销毁了。因此，应在 fragment 被销毁后重新创建过渡动画。此外，由于屏幕尺寸和 UI 差异， `Explode` 的过渡中心在纵向和横向模式下通常是不相同的。因此我们也需要更新中心区域。

这要求我们跟踪点击项目的位置并在方向更改时重新记录，这将导致更新的代码如下。

```
override fun onViewCreated(view: View, savedState: Bundle?) {
  super.onViewCreated(view, savedState)
  tapPosition = savedState?.getInt(TAP_POSITION, NO_POSITION) ?: NO_POSITION
  postponeEnterTransition()
   ...
}
...
private fun render(state: State) {
  when (state) {
   ... 
   is Success -> {
      ...
      (view?.parent as? ViewGroup)?.doOnPreDraw {
          if (exitTransition == null) {
            exitTransition = SlideExplode().apply {
              duration = TRANSITION_DURATION
              interpolator = transitionInterpolator
            }
          }

          val layoutManager = emailList.layoutManager as LinearLayoutManager
          layoutManager.findViewByPosition(tapPosition)?.let { view ->
            view.getGlobalVisibleRect(viewRect)
            (exitTransition as Transition).epicenterCallback =
                object : Transition.EpicenterCallback() {
                  override fun onGetEpicenter(transition: Transition) = viewRect
                }
          }

          startPostponedEnterTransition()
        }
    }
  }
}
...
override fun onSaveInstanceState(outState: Bundle) {
  super.onSaveInstanceState(outState)
  outState.putInt(TAP_POSITION, tapPosition)
}
```

### 第六站：处理 Activity 被销毁和进程被杀死的情况

过渡动画现在可以在方向变化中存活，但在 activity 被销毁或者进程被杀死时又会有什么样的效果呢？在我们的特定方案中，电子邮件列表 viewModel 在任何一种情况下都不存活，因此电子邮件数据也不存在。我们的转换取决于所点击的电子邮件项目的位置，因此如果数据丢失则无法使用。

奇怪的是，我查看了几个著名的应用程序，看看它们在这种情况下如何处理转换：

- Google Inbox: 有趣的是，它不需要处理这种情况，因为它会在活动被销毁后重新加载电子邮件列表（而不是电子邮件详细信息）。
- Google Play: 活动销毁或处理死亡后没有反向共享元素转换。
- Plaid (不是一个真正的应用程序，而是 Android 上的一个优秀的 material design 的 demo ): 即使在方向改变之后（截至编写时），也没有反向共享元素过渡。

虽然上面的列表没有足够的结论来处理 Android 应用程序在这种情况下处理转换的模式，但它至少显示了一些观点。

回到我们的具体问题，通常有两种可能性取决于每个应用程序处理此类情况的方法：（1）忽略丢失的数据并重新获取数据，以及（2）保留数据并恢复数据。由于这篇文章主要是关于过渡动画，所以我不打算讨论在什么情况下哪种方法更好以及为什么等。如果采用方法（1），则不应该进行反向转换，因为我们不知道先前被点击的电子邮件项目是否会被取回，即使它是，我们不知道它在列表中的位置。如果采用方法（2），我们可以像定向改变方案那样进行转换。

方法（1）是我在这种特定情况下的偏好，因为新的电子邮件可能每分钟都会出现，因此在活动销毁或处理死亡之后重新加载过时的电子邮件列表是没有用的，这通常发生在用户离开应用程序一段时间之后。在我们的设置中，当activity 被销毁或进程被杀死后后重新创建电子邮件列表片段时，将自动获取电子邮件数据，因此不需要做太多工作。我们只需要确保在呈现  `InProgress`  状态时调用  `startPostponedEnterTransition`：

```
is InProgress -> {
  ...
  (view?.parent as? ViewGroup)?.doOnPreDraw {
    startPostponedEnterTransition()
  }
}
```

### 第七站：让过渡动画更加平滑

到目前为止,我们已经有了一个基本的  “Inbox style”  过渡。有很多方法实现平滑。一个例子是在展开细节时呈现淡入效果，类似于收件箱应用程序的功能。这可以通过以下方式实现：

```
class EmailDetailsFragment : Fragment() {
  ...
  override fun onViewCreated(view: View, savedState: Bundle?) {
    super.onViewCreated(view, savedState)

    val content = view.findViewById<View>(R.id.content).also { it.alpha = 0f }

    ObjectAnimator.ofFloat(content, View.ALPHA, 0f, 1f).apply {
      startDelay = 50
      duration = 150
      start()
    }
  }
}
```

过渡动画现在看起来如下。

![](https://cdn-images-1.medium.com/max/800/1*viOG8N-3JVhlxJRTW13JpA.gif)

### 他已经被完全复制了吗？

基本上是。唯一缺少的是能够垂直滑动电子邮件详细信息视图以显示电子邮件列表中的其他电子邮件，并通过释放手指触发反向过渡，就和下面的 GIF 图所展示的效果一样。

![](https://cdn-images-1.medium.com/max/800/1*duoZc7YrobM4PDa0TzOtAQ.gif)

这样的动画对我来说很有意义，因为如果用户可以点击电子邮件项目来打开/展开它，他自然会拖下电子邮件详细信息来隐藏/折叠它。目前我正在探索实现这种效果的几个选项，它们将在下一篇文章中讨论。

------

那就这样吧。实现动画是 Android 开发中一个具有挑战性但又有趣的部分。我希望你喜欢和我一样喜欢动画。源代码可以在[这里](https://github.com/huan-nguyen/InboxStyleAnimation)找到。欢迎提出反馈/意见/讨论！

- [Android](https://proandroiddev.com/tagged/android?source=post)
- [Transitions](https://proandroiddev.com/tagged/transitions?source=post)
- [Animation](https://proandroiddev.com/tagged/animation?source=post)
- [Material](https://proandroiddev.com/tagged/material-design?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
