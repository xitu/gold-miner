> * 原文地址：[Complex UI/Animations on Android — featuring MotionLayout](https://proandroiddev.com/complex-ui-animations-on-android-featuring-motionlayout-aa82d83b8660)
> * 原文作者：[Nikhil Panju](https://medium.com/@nikhilpanju22)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/complex-ui-animations-on-android-featuring-motionlayout.md](https://github.com/xitu/gold-miner/blob/master/article/2021/complex-ui-animations-on-android-featuring-motionlayout.md)
> * 译者：
> * 校对者：

# Complex UI/Animations on Android — featuring MotionLayout

![](https://miro.medium.com/max/5000/1*iJMugDxk4IxBbCIjWOgs9w.png)

Exploring complex multi-step animations with MotionLayout (and Coroutines).

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/complex-ui-animations-on-android-featuring-motionlayout-HairyWellwornGelding-mobile.gif?raw=true)

> [MotionLayout](https://developer.android.com/training/constraint-layout/motionlayout) is the new kid on the block for animations, transitions, complex motions, what-have-you. In this article, we’re going to look at how MotionLayout and Coroutines can help us structure multi-step animations.

The previous article dives into all the different animations and widgets without using MotionLayout. I encourage you to read it because:

1. We will only be going into the filter sheet transitions in this article and not the adapter, tabs and other animations.
2. You can understand and appreciate the differences in writing these animations with and without using MotionLayout.

# Before we begin

* **TLDR?** [**View the source code on Github.**](https://github.com/nikhilpanju/FabFilter) It’s well documented and contains code for both; with and without MotionLayout.
* [**Download the app on the PlayStore**](https://play.google.com/store/apps/details?id=com.nikhilpanju.fabfilter) or build the source code to demo the app. (Don’t forget to check the **“Use MotionLayout”** checkbox in the Nav Drawer).

# What is MotionLayout? A quick intro…

![](https://miro.medium.com/max/60/1*4ddULlE7YKRVeneFY2IDqw.png?q=20)

![](https://miro.medium.com/max/1000/1*4ddULlE7YKRVeneFY2IDqw.png)

![](https://miro.medium.com/max/1000/1*4ddULlE7YKRVeneFY2IDqw.png)

Simply put, `MotionLayout` is a `ConstraintLayout` that allows you to easily transition between two ConstraintSets.

`<ConstraintSet>` contains all the constraints and layout attributes for each view.

`<Transition>` specifies the starting and ending ConstraintSets to transition between.

Throw all of this into a `<MotionScene>` file and you have yourself a MotionLayout!

As layouts and animations become more complex, the MotionScene also becomes more elaborate. We’re going to take a look at these components.

## Learn more about MotionLayout:

* **#1** Nicolas Roard’s [Introduction to MotionLayout](https://medium.com/google-developers/introduction-to-motionlayout-part-i-29208674b10d) Series.
* **#2** James Pearson’s [Advanced & Practical MotionLayout](https://www.droidcon.com/media-detail?video=362742385) Talk.
* **#3** Official [Android Developers Guide on MotionLayout](https://developer.android.com/training/constraint-layout/motionlayout).

# The Animation

All the animations put together, the motion scene file for this project contains **10 ConstraintSets** and **9 Transitions** between them. The video below demonstrates all the ConstraintSets and Transitions. There are **4 Animations** in total that we will be looking into:

![](https://miro.medium.com/max/800/1*a6zN5iGhjNuehrCNi6gwBw.gif)

1. **Opening the filter sheet:** Set1 → Set2 → Set3 → Set4
2. **Closing the filter sheet:** Set4 → Set3 → Set2 → Set1
3. **Applying filters:** Set4 → Set5 → Set6 → Set7
4. **Removing filters:** Set7 → Set8 → Set9 → Set10

***Note:*** *The RecyclerView Items animation in the background is not a part of the MotionLayout. Later in this post, we will see how we can choreograph external animations along with the MotionLayout.*

> Every animation (GIF) in this article will show the ConstraintSet details (`Ex: Set 4, Transitioning.., Set 5, etc`) below it to make it easier to follow while reading and navigating the source code.

# < ConstraintSet />

ConstraintSets are the *building blocks* required by MotionLayout to perform animations. This is where you specify all your constraints, layout properties and more.

> A `<ConstraintSet>` must contain a `<Constraint>` element with all the layout properties **for each view** you want to animate.

## Break up your <Constraint> elements

You can specify all your layout properties in the `<Constraint>` element. **But** for more complex animations, you should break it up using the `<Layout> <PropertySet> <Transform> <Motion> <CustomAttribute>` tags.

This allows you to only override the properties that you want without rewriting all the properties repeatedly.

![](https://miro.medium.com/max/2000/1*P5OuFMZvsxccOKl5lgSqQg.png)

## app:deriveConstraintsFrom = ”…”

`deriveConstraintsFrom` is a very useful tag that allows you to inherit from any other `<ConstraintSet>`. This way, you don’t have to rewrite all your views/constraints/properties but just the ones you want to animate.

Combine this with the previous tip of breaking up your `<Constraint>` elements and you get neat ConstraintSets with just the changes you want.

In this project, each of the 10 ConstraintSets derives from the previous set and only modifies what needs to be animated. For example: In the following transition, the close icon rotation is done by deriving all constraints from `Set5` and only applying rotation in `Set6`.

![](https://miro.medium.com/max/800/1*_PKoZ0I_4Aj2adGSteJUbg.gif)

![](https://miro.medium.com/max/2922/1*BXjOwJORltd3n5o2cGqKJg.png)

> **Warning:** When overriding one of the `*<Layout> <PropertySet> <Transform> <Motion> <CustomAttribute>*` elements, all the properties in that element get overriden, so you may have to copy the other properties from that element.

## Flatten your views when necessary

![](https://miro.medium.com/max/900/1*AuTuPGoxdr0YyejvJ733Dw.gif)

MotionLayout can only work with it’s **direct children views** and no nested views.

For example, in this animation, it may look like the filter icon is a part of the circular FAB (`CardView`). But they were split into separate views because they each have their own journey in this animation.

Also, the elevation of the fab is animated from `Set1 → Set2`. The icon must be placed at a higher elevation for it to be visible. An undesired effect of this is the icon casts it’s own shadow. To prevent this, we can use:

```text
android:outlineProvider="none"
```

Shadows are created by the outline provider of a view. If we set it to `none` then a shadow isn’t created.

## Custom Attributes

MotionLayout provides most of the basic properties that we might want to animate. But it can’t provide *everything*. Custom Views, for example, might require animating some other property.

<[CustomAttribute](https://developer.android.com/reference/android/support/constraint/motion/MotionLayout#customattribute)\> bridges that gap by allowing you to use any **setter** in your view. It uses reflection to call the method and set the value.

```xml
<CustomAttribute
        app:attributeName="radius"
        app:customDimension="16dp"/>
```

> **Note:** You must use the setter name, **not** the xml attr name. For example, CardView has a `setRadius()` method and the same in xml is `app:cardCornerRadius`. CustomAttribute should refer to the setter — “radius”.

## “Invisible” vs “Gone”

![](https://miro.medium.com/freeze/max/60/1*ylmvRB33KyE_nQAy1Z3FPQ.gif?q=20)

![](https://miro.medium.com/max/1400/1*ylmvRB33KyE_nQAy1Z3FPQ.gif)

![](https://miro.medium.com/max/1400/1*ylmvRB33KyE_nQAy1Z3FPQ.gif)

**Left**: invisible `→` visibl`e ...` **Right**: gone `→` visible

When animating visibility from `invisible` /`gone` to `visible`, watch out for this difference.

**✓** `gone → visible` will animate **alpha and scale**.

**✓** `invisible → visible` will animate **only alpha**.

# <Transition />

Transitions are the connections between 2 ConstraintSets. They specify the start and end states to *transition* between.

```xml
<Transition  
   app:constraintSetStart="@id/set1"  
   app:constraintSetEnd="@id/set2"  
   app:motionInterpolator="linear"  
   app:duration="300" />
```

You can also specify swipe and click related functionality in the transitions using the`<OnClick>` and `<OnSwipe>` elements but **we will not be going into them in this article** since they’re not rquired for the 10 set animation we’re looking at.

## Interpolators

We can specify interpolators for our transitions using `app:motionInterpolator`. The available options are `linear`, `easeIn`, `easeOut` and `easeInOut`. These may not be enough when you compare them to things like `[AnticipateInterpolator](https://developer.android.com/reference/android/view/animation/AnticipateInterpolator)`, `[BounceInterpolator](https://developer.android.com/reference/android/view/animation/BounceInterpolator)`, etc.

![](https://miro.medium.com/max/60/1*CvYt6_vlb-Drn6usAGHAeA.png?q=20)

![](https://miro.medium.com/max/1000/1*CvYt6_vlb-Drn6usAGHAeA.png)

![](https://miro.medium.com/max/1000/1*CvYt6_vlb-Drn6usAGHAeA.png)

[https://cubic-bezier.com/#0,1,.5,1](https://cubic-bezier.com/#0,1,.5,1)

For these scenarios, you can use the `cubic()` option where you can define your own interpolator using **bezier curves**. You can make your own bezier curves and get the values at [cubic-bezier.com](https://cubic-bezier.com/).

You can set it by using:  

```text
app:motionInterpolator=”cubic(0,1,0.5,1)
```

## Keyframes

Sometimes, just having a start and end state isn’t enough. For more complex animations, we might want to specify the course of the transition in more detail. Keyframes help us specify *“checkpoints”* in the transition where we can change any attribute of a view at any given time.

The article “[Defining motion paths in MotionLayout](https://medium.com/google-developers/defining-motion-paths-in-motionlayout-6095b874d37)” goes into more depth on keyframes and how to use them.

![](https://miro.medium.com/max/1000/1*iHhkXoHN9Yg9TPO488G_LQ.gif)

**Left**: With keyframes … **Right**: Without keyframes

The animation on the left is with **9 keyframes** and the one on the right is without keyframes.

As you can see, the start (set 4) and the end (set 5) are the same for both of them. But by using keyframes, we have much finer control on what happens to each element at any point during the transition.

## Structuring Keyframes

Every `<Transition />` can have one or more `<KeyFrameSet />` elements in which all the keyframes are specified. For this project, only `<KeyPosition />` and `<KeyAttribute />` elements were used.

![](https://miro.medium.com/max/1000/1*GG0V6txfOjGmkWBvGgM-7w.png)

* `motionTarget` specifies which view is affected by the keyframe.
* `framePosition` specifies when the keyframe is applied during the transition (0–100)
* `<KeyPosition />` is used to specify changes in width, height and x,y coordinates
* `<KeyAttribute />` is used to specify any other change **including** **CustomAttributes**.

## framePosition = 0 vs 1

Sometimes, we want to change a property at the **very start** of an animation. In normal animations, it is possible by using `animator.doOnStart{...}` or something similar. Let’s try achieving the same with keyframes..

![](https://miro.medium.com/max/1000/1*qdGFGc27RyXN0Q5rf86DqQ.gif)

**Left**: framePosition=1 … **Right**: framePosition=0

In this particular animation, when the user clicks on the filter button, the animation begins by changing the fab (CardView) to a circle and collapsing it in size.

The problem here is when `framePosition = 0` is used to alter the value at the start of the animation, MotionLayout doesn’t record it.

So, if you want to have a keyframe that specifies something at the start of any transition, use `framePosition = 1` instead.

```xml
<KeyAttribute  
   app:motionTarget="@id/fab"  
   app:framePosition="1">  
   <CustomAttribute  
      app:attributeName="radius"  
      app:customDimension="600dp" />  
</KeyAttribute>
```

## Use Custom Views when necessary

The availability of `CustomAttributes` allows us to have flexible layouts with custom views.

For instance, a lot of the transitions in this animation involves the FAB (`CardView`) to grow and shrink **as a circle**. The issue with this is, to keep the CardView as a circle, `cornerRadius must be <= size/2`. Normally this is easy with something like `ValueAnimator` because we know all the values at all times.

But `MotionLayout` hides all the calculations away from us. So to achieve this, we must introduce a new view:

![](https://miro.medium.com/max/1000/1*TP1JjqYD_Xb0qaylEulQDQ.png)

`CircleCardView` handles this case by limiting the radius to a max of size/2. Now when `MotionLayout` calls into the setter (remember `CustomAttributes`?), we won’t face any issues.

# Choreographing multi-step animations

Currently, MotionLayout does not have an API that allows for controlled multi-step transitions. We can use `autoTransition` but it’s quite limiting (we’ll get into that later). In pseudocode, this is how you would do it:

```kotlin
// Transitioning from set1 -> set2 -> set3 -> set4
motionLayout.setTransition(set1, set2)
motionLayout.transitionToEnd()
motionLayout.doOnEnd {
    motionLayout.setTransition(set2, set3)
    motionLayout.transitionToEnd()
    motionLayout.doOnEnd {
        motionLayout.setTransition(set3, set4)
        motionLayout.transitionToEnd()
        motionLayout.doOnEnd {
            ...
        }
    }
}
```

This quickly turns ugly and into the dreaded callback-hell. **Coroutines**, on the other hand help us convert asynchoronous callback code into linear code.

## MotionLayout.awaitTransitionComplete()

Chris Banes’s article on [Suspending over Views](https://medium.com/androiddevelopers/suspending-over-views-example-260ce3dc9100) is a must-read on how you can implement coroutines in View-related code.

[Suspending over Views — Example, A worked example from the Tivi app](https://medium.com/androiddevelopers/suspending-over-views-example-260ce3dc9100)

He introduces us to `awaitTransitionComplete()`, which is a **suspend function** that hides away all the listeners, making it easy to wait for a transition to be complete using coroutines:

![](https://miro.medium.com/max/2000/1*yFk2YDqAfkC_pCugcEg5Og.png)

> **Note:** The `awaitTransitionComplete()` extension method uses a [modified MotionLayout](https://gist.github.com/chrisbanes/a7371683c224464bf6bda5a25491aee0) which enables multiple listeners to be set as opposed to only one ([feature request](https://issuetracker.google.com/issues/144714753)).

## AutoTransition

`autoTransition` is the easiest way to achieve multi-step transitions **without coroutines**. Let’s say we want to achieve the **“Removing Filters”** animation from `Set7 → Set8 → Set9 → Set10`.

![](https://miro.medium.com/max/800/1*BzpK3fI5sfSSA_y4k4TiQw.gif)

![](https://miro.medium.com/max/2658/1*6zdUCilxhMIf6xBvIaHXxg.png)

Now, if we do `motionLayout.transitionToState(set8)`, MotionLayout transitions from `Set7 → Set8`. When it reaches `Set8`, it **automatically transitions** to `Set9`. And similarly, to `Set10`.

> `autoTransition` will automatically execute the transition when MotionLayout reaches the ConstraintSet specified in `constraintSetStart`.

## AutoTransition is not perfect

If you watch the animation again, you will notice that there is an animation going on with the adapter items in the background. To accomplish these animations **in parallel** with the MotionLayout transitions, we will have to use coroutines. They cannot be timed correctly by only using `autoTransition`.

```kotlin
private fun unFilterAdapterItems(): Unit = lifecycleScope.launch {
  
  // 1) Set7 -> Set8 (Start scale down animation simultaneously)
  motionLayout.transitionToState(R.id.set8)
  startScaleDownAnimator(true) // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set8)
  
  // 2) Set8 -> Set9 (Un-filter adapter items simultaneously)
  (context as MainActivity).isAdapterFiltered = false // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set9)
  
  // 3) Set9 -> Set10 (Start scale 'up' animation simultaneously)
  startScaleDownAnimator(false) // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set10)
}
```

> The lines marked with `//Simultaneous` occur in parallel with the transition that’s taking place.

Since `autoTransition` doesn’t wait when jumping from one transition to the next, `awaitTransitionComplete()` only lets us know when the transition is complete. It **does not** actually wait at the end of the transition. Which is why, we use `transitionToState()` only once, at the beginning.

# Multi-Step Forward and Reverse Transitions

![](https://miro.medium.com/max/800/1*qB9qCBsilZrracH7BSGYHg.gif)

AutoTransition combined with coroutines help us achieve control over multi-step transitions.

But what if we want to animate backwards (`Set4 → Set1`) while reversing through each transition?

Reversing **a specific** transition, say, `Set4 → Set3` is possible by using `transitionToStart()`. But if we use `autoTransition`, then it would animate to `Set3`, then back to `Set4` **automatically** because of the `autoTransition`.

## Opening Sheet Animation

The code for opening the filter sheet will differ slightly from what we saw in the previous section since we aren’t using `autoTransition`.

```kotlin
/** Order of animation: Set1 -> Set2 -> Set3 -> Set4 */
private fun openSheet(): Unit = lifecycleScope.launch {
  
  // Set the start transition. This is necessary because the
  // un-filtering animation ends with set10 and we need to
  // reset it here when opening the sheet the next time
  motionLayout.setTransition(R.id.set1, R.id.set2)
  
  // 1) Set1 -> Set2 (Start scale down animation simultaneously)
  motionLayout.transitionToState(R.id.set2)
  startScaleDownAnimator(true) // Simultaneous
  motionLayout.awaitTransitionComplete(R.id.set2)
  
  // 2) Set2 -> Set3
  motionLayout.transitionToState(R.id.set3)
  motionLayout.awaitTransitionComplete(R.id.set3)
  
  // 3) Set3 -> Set4
  motionLayout.transitionToState(R.id.set4)
  motionLayout.awaitTransitionComplete(R.id.set4)
}
```

* We have to use `transitionToState()` after awaiting each time. This was not necessary before because `autoTransition` would just run through all of them without waiting. Here, we have to do it manually.
* Notice how we don’t use `setTransition()` everytime after awaiting. This is because `MotionLayout` will identify which transition to use based on the current ConstraintSet and the ConstraintSet mentioned in `transitionToState()`.

## Closing Sheet Animation (Reverse)

```kotlin
/** Order of animation: Set4 -> Set3 -> Set2 -> Set1 */
private fun closeSheet(): Unit = lifecycleScope.launch {
  
  // We don't have to setTransition() here since current transition is Set3 -> Set4.
  // transitionToStart() will automatically go from:
  // 1) Set4 -> Set3
  motionLayout.transitionToStart()
  motionLayout.awaitTransitionComplete(R.id.set3)
    
  // 2) Set3 -> Set2
  motionLayout.setTransition(R.id.set2, R.id.set3)
  motionLayout.progress = 1f
  motionLayout.transitionToStart()
  motionLayout.awaitTransitionComplete(R.id.set2)
  
  // 3) Set2 -> Set1 (Start scale 'up' animator simultaneously)
  motionLayout.setTransition(R.id.set1, R.id.set2)
  motionLayout.progress = 1f
  motionLayout.transitionToStart()
  startScaleDownAnimator(false) // Simultaneous
  motionLayout.awaitTransitionComplete(R.id.set1)
}
```

Since all `<Transition>` elements are forward-based, we have to add a couple of lines to make it reverse-able. The essence of it is:

```kotlin
// Set the transition to be reversed (MotionLayout can only detect forward transitions).
motionLayout.setTransition(startSet, endSet)
// This will set the progress of the transition to the end
motionLayout.progress = 1f
// Reverse the transition from end to start
motionLayout.transitionToStart()
// Wait for transition to reach the start
motionLayout.awaitTransitionComplete(startSet)
// Repeat for every transition...
```

✔️ This now allows us to step through multiple transitions in reverse while maintaing the ability to do other things in parallel.

# Conclusion — With or without MotionLayout?

`MotionLayout` combined with coroutines makes it super easy to achieve very complex animations with very little code **while maintaing a flat view hierarchy!**

In my [previous article](/complex-ui-animation-on-android-8f7a46f4aec4?source=friends_link&sk=f1fab1861a655b042ff5e9c305a0e012), I explore how all of this was done **without using MotionLayout.** The amount of code required to get all this to work was much greater. A lot of math was involved in getting the animations to work, complex view hierarchies, etc.

> MotionLayout takes away all the nonsense and leaves us with what’s necessary. With coroutines and a soon-to-come IDE editor, the possibilities might just be endless.

Hope you enjoyed this post 😃! Check out the [source code](https://github.com/nikhilpanju/FabFilter) if you’re further interested!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
