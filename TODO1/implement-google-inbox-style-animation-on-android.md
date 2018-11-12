> * 原文地址：[Implement Google Inbox Style Animation on Android](https://proandroiddev.com/implement-google-inbox-style-animation-on-android-18c261baeda6)
> * 原文作者：[Huan Nguyen](https://proandroiddev.com/@huan.nguyen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implement-google-inbox-style-animation-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implement-google-inbox-style-animation-on-android.md)
> * 译者：
> * 校对者：

# Implement Google Inbox Style Animation on Android

![](https://cdn-images-1.medium.com/max/2000/1*aPCvPk2Yoh7C2e4MovuT8Q.jpeg)

As an Android user and developer, I am always attracted to great apps with nice and meaningful animations. To me such apps not only deliver great features to make their users life easier but also show the enthusiasm to bring their user experience to the next level from the team behind them. I often enjoy playing and replaying those animations and then spending hours trying to replicate them myself. One of those apps is Google Inbox which offers a beautiful email open/close animation shown below (in case you’re not familiar with it).

![](https://cdn-images-1.medium.com/max/800/1*KOc31AjVOzoNIutQPYIdow.gif)

In this article, I’m going to take you through my journey of replicating the animation on Android.

* * *

### Setup

To replicate the animation, I built a simple app with 2 fragments, Email List fragment and Email Details fragment shown below.

![](https://cdn-images-1.medium.com/max/800/1*LoYsgZ4-uXPYdgqzXMmRmg.png)

Email List’s InProgress state (left) — Email List’s Success state (middle) — Email Details (right)

To simulate the email fetching network request, I created a `[ViewModel](https://developer.android.com/reference/android/arch/lifecycle/ViewModel)` for Email List fragment which generates 2 states, `InProgress` which indicates email data is being fetched and `Success` which indicates email data has successfully fetched and ready to be rendered (The network request is simulated to take 2 seconds).

```
sealed class State {
  object InProgress : State()
  data class Success(val data: List<String>) : State()
}
```

Email List fragment has a method to render those states as follows.

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

Whenever Email List fragment is freshly loaded, email data is fetched and it renders `InProgress` state until email data becomes available (`Success` state). Tapping on any of the email items in the email list would take user to the Email Details fragment and tapping back from Email Details brings user back to the Email List.

Now the journey begins…

### First stop — what kind of animation that is?

One could immediately tell that it is a kind of `[Explode](https://developer.android.com/reference/android/transition/Explode)` transition since the items above and below the tapped item are transitioning away from it. But wait a minute, the Email Details view are transformed and expanded from the tapped email item too. That means there is also a shared element transition. With that said, below is my first attempt.

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

And here is what I got (Email Details view’s background is purposefully set as blue to clearly demonstrate the transitions)…

![](https://cdn-images-1.medium.com/max/800/1*ZuO5DDmtjvb2zY2kTyRxwQ.gif)

Certainly it is not what I want. There are two problems here.

1.  The email items do not start to transition at the same time. Items farer from the tapped items start to transition sooner.
2.  The shared element transition on the tapped email item is not synchronised with the transitions of the other items, i.e., `Email 4` and `Email 6` should always be sticked at the top and bottom edge of the blue rectangle when it is expanded, respectively. But they do not!

So what’s wrong here?

### Second stop: the out-of-the-box Explode transition is not what I want.

After digging into the `Explode` source code, I found two interesting facts:

*   It uses `CircularPropagation` which enforces the rule that views farer from the epicenter will transition sooner than views closers to the epicenter when they disappear from screens. The epicenter of the `Explode` transition was set to be the rectangle covering the tapped email item. This explains why the untapped email item views are not transitioning together as mentioned above.
*   The distances over which the above and below email items transition are not the distance from the tapped item to the top and bottom of the screen, respectively. In this specific situation, that distance is determined to be the longest among the distances from the centre point of the tapped item to each corner of the screen.

So I decided to write my own `Explode` transition. I name it `SlideExplode` since it’s very similar to a `Slide` transition except having 2 parts moving in 2 opposite directions.

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

Now that I’ve swap `Explode` for `SlideExplode`, let’s try again.

![](https://cdn-images-1.medium.com/max/800/1*7ddUWQHt5AnSMHbH7rV2LA.gif)

Much better! The above and below items now start transitioning at the same time. Note that since the interpolator was set to `FastOutSlowIn`, `Email 4` and `Email 6` slow down when they are near the top and bottom edges, respectively. That indicates the `SlideExplode` transition works properly.

However, The `Explode` transition and the shared element transition are still not synchronised. We could see they are moving in different patterns which indicates their interpolators might be different. The former transition starts very fast and slow down at the end while the later is slow at first and accelerates after a while.

But how? I did set the interpolators to be the same in the code!

### Stop 3: It’s TransitionSet to blame!

I dug into the source code again. This time I found whenever I set interpolator to a `TransitionSet`, it does not distribute the interpolator to its contained transitions. This happens only with the standard `TransitionSet`. Its support version (`android.support.transition.TransitionSet`) works properly. To fix this issue we could either switch to the support version or explicitly pass the interpolator to the contained transitions using the below extension function.

```
fun TransitionSet.setCommonInterpolator(interpolator: Interpolator): TransitionSet {
  (0 until transitionCount)
      .map { index -> getTransitionAt(index) }
      .forEach { transition -> transition.interpolator = interpolator }

  return this
}
```

Let’s try again after updating how we set the interpolator.

![](https://cdn-images-1.medium.com/max/800/1*und_Bh9Mf-pJRMnyNCO9lg.gif)

YAYYYY! It looks correct now. But how about the reverse transition?

![](https://cdn-images-1.medium.com/max/800/1*0SnMV9Lw5_KKpFllkdzXmg.gif)

No where close to what I want! The Explode transition seems to work. However the shared element transition doesn’t.

### Stop 4: Postpone Enter Transition

The reason why the reverse transition didn’t work is that it was played too early. For any transition to work, it needs to capture the start and end states (size, position, bound) of the target views, which are the `Email Details` view and `Email 5 item` in this case. If the reverse transition is started before `Email 5 item`’s state is available, it wouldn’t function properly like what we saw.

The solution here is to postpone the reverse transition until the items are drawn. Luckily, the transition framework offers a pair of methods `postponeEnterTransition` which flags to the system that the enter transition should be postponed and `startPostponedEnterTransition` which signals that it can be started. Note that `startPostponedEnterTransition` must be called at some time after `postponeEnterTransition` was called. Otherwise the transition would never be played and the fragment is not popped.

Given our setup, whenever the Email List fragment is reentered by popping Email Details fragment, it grabs the latest state from the view model and renders the email list straightaway. Therefore if we postponed the transition until the email list is rendered, that wouldn’t be a considerably long wait and thus the postponement makes sense (popping after restoring from process death is a different story. That’s be covered later in the post).

The updated code looks like the followings. We’d postpone the enter transition in `onViewCreated`.

```
override fun onViewCreated(view: View, savedState: Bundle?) {
  super.onViewCreated(view, savedInstanceState)
  postponeEnterTransition()
  ...
}
```

And start the postponed transition after rendering the state. This is done using [doOnPreDraw](https://android.github.io/android-ktx/core-ktx/androidx.view/android.view.-view/do-on-pre-draw.html).

```
is Success -> {
  ...
  (view?.parent as? ViewGroup)?.doOnPreDraw {
    startPostponedEnterTransition()
  }
}
```

![](https://cdn-images-1.medium.com/max/800/1*kpw-wtv3aOOki3p225Ou8Q.gif)

Now it works! But would the transitions survive orientation change?

### Stop 5: Address orientation change

After a rotation, there is no reverse transition to Email List fragment. After some debugging I found that the transitions are destroyed together with the fragments on orientation change. Therefore, the transitions should be recreated after fragment is destroyed. Moreover, the epicenter of the `Explode` transition is normally not be the same across portrait and landscape mode due to the screen size and UI differences. Hence we would need to update the epicenter too.

That requires us to keep track of the position of the tapped item and restore it on orientation change, which leads to the updated code as follows.

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

### Stop 6: Handle activity destroyed and process death

The transitions now survive orientation change. But how about activity destroyed or process death? In our specific scenario, the Email List viewModel does not survive in either cases and thus neither does the email data. Our transitions depends on the position of the tapped email item and thus would not work if the data was lost.

Curiously, I checked out a couple of famous apps to see how they deal with transitions in such cases:

*   Google Inbox: interestingly it doesn’t need to deal with such cases since it reloads the Email List (not email details) after activity is destroyed.
*   Google Play: no reverse shared element transition after activity destroyed or process death.
*   Plaid (not really an app but a great demo of material design on Android): no reverse shared element transition even after orientation change (as of the time of writing).

Although the above list is by no mean enough to conclude Android apps’ pattern to deal with transitions in such cases, it at least shows some opinion.

Back to our specific issue, normally there are two possibilities depending on each app’s approach of handling such cases: (1) ignore data lost and re-fetch the data and (2) persist data and restore it. Since this post is mainly about transition, I’m not going into discussing when which approach is better and why etc. If approach (1) is taken, no reverse transition should be played since we don’t know if the previously tapped email item would be fetched again and even if it is, we don’t know its position in the list. If approach (2) is taken, we could play the transitions like what was done for the orientation change scenario.

Approach (1) is my preference in this particular scenario since new emails could come every minute and thus it’s not useful to reload an obsolete list of emails after activity destroyed or process death which typically happen after a user leaves the app for a while. In our setup, email data would automatically be fetched when the Email List fragment is recreated after activity destroyed or process death so not much needs to be done. We just need to make sure `startPostponedEnterTransition` is called when the `InProgress` state is rendered:

```
is InProgress -> {
  ...
  (view?.parent as? ViewGroup)?.doOnPreDraw {
    startPostponedEnterTransition()
  }
}
```

### Stop 7: Polish the transitions.

So far we’ve got a basic “Inbox style” transition. There are many ways to polish it. One example is to fade in the details while it is expanded, similar to what the Inbox app does. That can be achieved as follows:

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

The transition now looks like below.

![](https://cdn-images-1.medium.com/max/800/1*viOG8N-3JVhlxJRTW13JpA.gif)

### Is it completely replicated yet?

Most of it. The only thing missing is the ability to swipe the Email Detail view vertically to reveal other emails in the Email List and trigger the reverse transition by releasing finger which are shown in the below GIF.

![](https://cdn-images-1.medium.com/max/800/1*duoZc7YrobM4PDa0TzOtAQ.gif)

Such animation makes a lot of sense to me because if a user could tap on an email item to open/expand it, it is natural for him to drag down the email details to dismiss/collapse it. At the moment I’m exploring a couple of options to implement such an effect and they will be discussed in the next article.

* * *

That’s it. Implementing animations is a challenging yet fun part of Android development. I hope you enjoy working with animations as much as I do. The source code can be found [here](https://github.com/huan-nguyen/InboxStyleAnimation). Feedback/comments/discussions all welcome!

*   [Android](https://proandroiddev.com/tagged/android?source=post)
*   [Transitions](https://proandroiddev.com/tagged/transitions?source=post)
*   [Animation](https://proandroiddev.com/tagged/animation?source=post)
*   [Material](https://proandroiddev.com/tagged/material-design?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
