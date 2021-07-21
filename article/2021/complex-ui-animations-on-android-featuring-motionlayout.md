> * 原文地址：[Complex UI/Animations on Android — featuring MotionLayout](https://proandroiddev.com/complex-ui-animations-on-android-featuring-motionlayout-aa82d83b8660)
> * 原文作者：[Nikhil Panju](https://medium.com/@nikhilpanju22)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/complex-ui-animations-on-android-featuring-motionlayout.md](https://github.com/xitu/gold-miner/blob/master/article/2021/complex-ui-animations-on-android-featuring-motionlayout.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Android 上的复杂 UI/动画 —— MotionLayout 独占鳌头

![](https://miro.medium.com/max/5000/1*iJMugDxk4IxBbCIjWOgs9w.png)

使用 MotionLayout（和 Coroutines）探索复杂的多步动画。

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/complex-ui-animations-on-android-featuring-motionlayout-HairyWellwornGelding-mobile.gif?raw=true)

> [MotionLayout](https://developer.android.com/training/constraint-layout/motionlayout) 是动画、转换和复杂动作和其他有关动画的新人。在本文中，我们将研究 MotionLayout 和 Coroutines 可以如何帮助我们构建多步动画。

上一篇文章深入探讨了所有不使用 MotionLayout 的不同动画和小部件。我鼓励你阅读它，因为：

1. 在本文中我们将只讨论过滤器表的转换，而不是适配器、选项卡和其他动画。
2. 您可以理解和欣赏使用和不使用 MotionLayout 编写这些动画的差异。

## 在我们开始之前

* **觉得文章太繁琐太长了？**直接前往 [**Github 上查看源代码。**](https://github.com/nikhilpanju/FabFilter)！GitHub 仓库里面有很好的文档记录，并且包含了两种的代码：使用和没有使用 MotionLayout。
* [**在 PlayStore 上下载应用程序**](https://play.google.com/store/apps/details?id=com.nikhilpanju.fabfilter) 或构建源代码来演示应用程序。（不要忘记选中导航抽屉中的 **“使用 MotionLayout”** 复选框）。

## 什么是 MotionLayout？快速介绍……

![](https://miro.medium.com/max/60/1*4ddULlE7YKRVeneFY2IDqw.png?q=20)

![](https://miro.medium.com/max/1000/1*4ddULlE7YKRVeneFY2IDqw.png)

![](https://miro.medium.com/max/1000/1*4ddULlE7YKRVeneFY2IDqw.png)

简单地说，`MotionLayout` 是一个 `ConstraintLayout`，它可以让你轻松地在两个 ConstraintSet 之间进行转换。

`<ConstraintSet>` 包含每个视图的所有约束和布局属性。

`<Transition>` 用于指定要在其间转换的开始和结束的 ConstraintSet。

把所有这些都放到一个 `<MotionScene>` 文件中，你就拥有了一个 MotionLayout！

随着布局和动画变得更加复杂，MotionScene 也变得更加精细。我们将分别了解一下这些组件。

### 了解有关 MotionLayout 的更多信息

* **#1** Nicolas Roard 的 [MotionLayout 简介](https://medium.com/google-developers/introduction-to-motionlayout-part-i-29208674b10d) 系列。
* **#2** James Pearson 的 [Advanced & Practical MotionLayout](https://www.droidcon.com/media-detail?video=362742385) 谈话。
* **#3** 官方的 [MotionLayout 上的 Android 开发人员指南](https://developer.android.com/training/constraint-layout/motionlayout)。

## 动画

所有动画放在一起，该项目的 MotionScene 文件包含 **10 个 ConstraintSets** 和 **9 个 Transitions**。下面的视频演示了所有的 ConstraintSets 和 Transitions。我们将研究总共 **4 个动画**：

![](https://miro.medium.com/max/800/1*a6zN5iGhjNuehrCNi6gwBw.gif)

1. **打开过滤表：** Set1 → Set2 → Set3 → Set4
2. **关闭滤片：** Set4 → Set3 → Set2 → Set1
3. **应用过滤器：** Set4 → Set5 → Set6 → Set7
4. **去除过滤器：** Set7 → Set8 → Set9 → Set10

***注意：*** *后台的 RecyclerView Items 动画不是 MotionLayout 的一部分。在这篇文章的后面，我们将看到如何使用 MotionLayout 编排外部动画。*

> 本文中的每个动画（GIF）都将在其下方显示 ConstraintSet 详细信息（例如，`Set 4, Transitioning.., Set 5, etc`），以便在阅读和导航源代码时更容易理解。

---

## &lt;ConstraintSet />

ConstraintSets 是 MotionLayout 执行动画所需的*构建块*。您可以在此处指定所有约束、布局属性等。

> `<ConstraintSet>` 必须包含一个 `<Constraint>` 元素，该元素具有 **每个要动画化的视图** 的所有布局属性。

### 分解 &lt;Constraint> 标签

我们可以在 `<Constraint>` 元素中指定所有布局属性，**但是**对于更复杂的动画，我们应该使用 `<Layout> <PropertySet> <Transform> <Motion> <CustomAttribute>` 这些标签将其分解。

分解布局元素让我们可以在后续只需要覆盖所需要的属性，而不需要重写全部属性。

![](https://miro.medium.com/max/2000/1*P5OuFMZvsxccOKl5lgSqQg.png)

### app:deriveConstraintsFrom = "……"

`deriveConstraintsFrom` 是一个非常有用的标签，它允许我们从任何其他 `<ConstraintSet>` 继承属性。这样，我们不再需要重写所有视图/约束/属性，而只需重写要设置动画的那些相关属性即可。

将此与上一个分解 `<Constraint>` 元素的技巧结合起来，我们能够构建出一个简洁的 ConstraintSets，并且其中只包含我们想要的更改。

在这个项目中，10 个 ConstraintSet 中的每一个都继承前一个 Set，并且只修改需要运行动画的属性。例如：在下面的转换中，关闭图标旋转是通过从 “Set5” 继承所有约束，并且只在 “Set6” 中应用旋转来完成的。

![](https://miro.medium.com/max/800/1*_PKoZ0I_4Aj2adGSteJUbg.gif)

![](https://miro.medium.com/max/2922/1*BXjOwJORltd3n5o2cGqKJg.png)

> **警告：** 当覆盖 `<Layout> <PropertySet> <Transform> <Motion> <CustomAttribute>` 元素之一时，该元素中的所有属性都会被覆盖，因此我们可能必须复制另一个该元素的属性。

### 必要时展平你的试图

![](https://miro.medium.com/max/900/1*AuTuPGoxdr0YyejvJ733Dw.gif)

MotionLayout 只能使用它的 **直接子视图** 而没有嵌套视图。

例如，在此动画中，过滤器图标可能看起来像是圆形 FAB（`CardView`）的一部分。但是它们被分成了不同的视图，因为它们在这个动画中都有自己的任务要完成。

此外，FAB 的高度是从 `Set1 → Set2` 进行动画的；图标必须放置在更高的 elvation 才能被看到；我们也不希望图标有阴影。为了防止这种情况，我们可以使用：

```xml
android:outlineProvider="无"
```

阴影由视图的 `outlineProvider` 创建。如果我们将其设置为 `none`，视图就不会有阴影。

### 自定义属性

MotionLayout 提供了我们可能想要制作动画的大部分基本属性。但它不可能为我们提供*一切*我们想要的动画属性。例如，自定义视图可能需要为某些其他属性设置动画。

<[CustomAttribute](https://developer.android.com/reference/android/support/constraint/motion/MotionLayout#customattribute)\> 通过允许我们在视图中使用任何的 **setter** 来弥补这一差距。它使用 Reflect 来调用方法并设置值。

```xml
<CustomAttribute
        app:attributeName="radius"
        app:customDimension="16dp"/>
```

> **注意：** 我们必须使用 Setter Name，而**不是** XML 属性名。例如，CardView 有 `setRadius()` 方法，而对应的 XML 中的属性名是 `app:cardCornerRadius`，那么 CustomAttribute 就应该是参考 Setter 名 —— `radius`。

### `invisible` 和 `gone`

![](https://miro.medium.com/max/1400/1*ylmvRB33KyE_nQAy1Z3FPQ.gif)

**左图**：`invisible` → `visible` ｜ **左图**：`gone` → ` visible

将可见性从 `invisible` 或 `gone` 设置为 `visible` 时，请注意这种差异。

**✓** `gone → visible` 将应用透明度和缩放动画。

**✓** `invisible → visible` 只会应用透明度动画。

## &lt;Transition />

Transition 是 2 个 ConstraintSet 之间的连接，而 2 个 ConstraintSet 分别指定开始和结束之间的状态。

```xml
<Transition  
   app:constraintSetStart="@id/set1"  
   app:constraintSetEnd="@id/set2"  
   app:motionInterpolator="linear"  
   app:duration="300" />
```

我们还可以使用 `<OnClick>` 和 `<OnSwipe>` 元素在过渡中指定滑动和点击相关功能，但**我们不会在本文中讨论它们**，因为它们不是 10 个本文讨论的动画之中。

### Interpolator

我们可以使用 `app:motionInterpolator` 为过渡指定 Interpolator。这一属性的属性值可以是 `linear`、`easeIn`、`easeOut` 和 `easeInOut`。不过这些属性其实挺少的，我的意思是，如果让我们把它与 `[AnticipateInterpolator](https://developer.android.com/reference/android/view/animation/AnticipateInterpolator)`、`[BounceInterpolator](https://developer. android.com/reference/android/view/animation/BounceInterpolator)` 这些 Interpolators 相比较的话……

![](https://miro.medium.com/max/1000/1*CvYt6_vlb-Drn6usAGHAeA.png)

[https://cubic-bezier.com/#0,1,.5,1](https://cubic-bezier.com/#0,1,.5,1)

对于这些场景，我们可以使用 `cubic()` 选项。我们可以在其中使用 **bezier 曲线** 定义自己的 Interpolator。我们可以在 [cubic-bezier.com](https://cubic-bezier.com/) 上制作自己的贝塞尔曲线以构建属于自己的 Interpolator。

我们可以使用以下方法设置 Interpolator：

```xml
app:motionInterpolator=”cubic(0,1,0.5,1)
```

### Keyframe

有时只有开始和结束状态是不够的。对于更复杂的动画，我们可能希望更详细地指定元素过渡的过程。关键帧能够帮助我们在过渡中指定**检查点**，让我们可以在任何给定时间更改视图的任何属性。

[在 MotionLayout 中定义运动路径](https://medium.com/google-developers/defining-motion-paths-in-motionlayout-6095b874d37) 一文更深入地介绍了关键帧以及如何使用它们。

![](https://miro.medium.com/max/1000/1*iHhkXoHN9Yg9TPO488G_LQ.gif)

**左图**：有关键帧 ｜ **右图**：没有关键帧

左边的动画有 **9 个关键帧**，而右边的动画没有关键帧。

如你所见，它们的开始（Set 4）和结束（Set 5）是相同的。但是通过使用关键帧，我们可以更好地控制过渡期间每个元素在任何时候发生的情况。

### 构建关键帧

每个 `<Transition />` 可以有一个或多个 `<KeyFrameSet />` 元素，其中指定了所有关键帧。对于这个项目，我们只使用了 `<KeyPosition />` 和 `<KeyAttribute />` 元素。

![](https://miro.medium.com/max/1000/1*GG0V6txfOjGmkWBvGgM-7w.png)

* `motionTarget` 指定哪个视图受关键帧影响；
* `framePosition` 指定在过渡期间应用关键帧的时间（0–100）；
* `<KeyPosition />` 用于指定宽度、高度和 x,y 坐标的变化；
* `<KeyAttribute />` 用于指定任何其他更改**包括 CustomAttributes**；

### framePosition 的取值 0 和 1

有时，我们想在动画的**开始**更改属性。在普通动画中，可以使用 `animator.doOnStart{...}` 或类似的东西完成。让我们尝试使用关键帧实现相同的效果。

![](https://miro.medium.com/max/1000/1*qdGFGc27RyXN0Q5rf86DqQ.gif)

**左图**：`framePosition = 1` ｜ **右图**：`framePosition = 0`

在这个特定的动画中，当用户单击过滤器按钮时，动画开始时会将 FAB（CardView）更改为圆形并按大小折叠它。

这里的问题是当在动画开始时使用 `framePosition = 0` 来改变值时，MotionLayout 不会记录它。

因此，如果您想在任何过渡开始时指定一个关键帧，请改用 `framePosition = 1`。

```xml
<KeyAttribute  
   app:motionTarget="@id/fab"  
   app:framePosition="1">  
   <CustomAttribute  
      app:attributeName="radius"  
      app:customDimension="600dp" />  
</KeyAttribute>
```

### 必要时使用自定义视图

`CustomAttributes` 的可用性允许我们使用自定义视图进行灵活的布局。

例如，这个动画中的很多 Transition 都涉及到 FAB（`CardView`）以**圆形**的形状变大或变小。这样做的问题是，为了将  CardView 保持为圆形，`cornerRadius` 必须小于等于 `size/2`。通常我们可以很容易使用 `ValueAnimator` 之类的东西实现这个 Transition，因为我们一直都知道所有的值。

但是 `MotionLayout` 隐藏了我们所有的计算。所以为了实现这一点，我们必须引入一个新的视图：

![](https://miro.medium.com/max/1000/1*TP1JjqYD_Xb0qaylEulQDQ.png)

`CircleCardView` 通过将半径限制最大值为 `size/2` 来处理这种情况。现在，当 `MotionLayout` 调用  setter 时（还记得 `CustomAttributes` 吗？），我们将不会再遇到任何问题。

## 编排多步动画

目前，MotionLayout 没有允许受控多步过渡的 API。我们可以使用 `autoTransition`，但它非常有限（我们稍后会介绍）。在伪代码中，我们将这样做：

```kotlin
// set1 -> set2 -> set3 -> set4 的 Transition
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

这很快变得丑陋并变成可怕的回调地狱。**Coroutines** 协程，另一方面帮助我们将异步回调代码转换为线性代码。

### MotionLayout.awaitTransitionComplete()

Chris Banes 关于 [Suspending over Views](https://medium.com/androiddevelopers/suspending-over-views-example-260ce3dc9100) 的文章是关于如何在与视图相关的代码中实现协程的必读文章。

[暂停视图 —— 示例，来自 Tivi 应用程序的一个工作示例](https://medium.com/androiddevelopers/suspending-over-views-example-260ce3dc9100)

他向我们介绍了 `awaitTransitionComplete()`，这是一个**挂起函数**，可以隐藏了所有侦听器，让我们可以使用协程轻松地等待 Transition 的完成：

![](https://miro.medium.com/max/2000/1*yFk2YDqAfkC_pCugcEg5Og.png)

> **注意：** `awaitTransitionComplete()` 扩展方法使用[修改后的 MotionLayout](https://gist.github.com/chrisbanes/a7371683c224464bf6bda5a25491aee0)，它允许设置多个侦听器，而不是仅设置一个 —— ([功能请求](https://issuetracker.google.com/issues/144714753))。

### 自动转换

`autoTransition` 是不使用协程实现多步过渡的最简单方法。假设我们想要让动画实现 `Set7 → Set8 → Set9 → Set10` 以实现**取消过滤**的动画。

![](https://miro.medium.com/max/800/1*BzpK3fI5sfSSA_y4k4TiQw.gif)

![](https://miro.medium.com/max/2658/1*6zdUCilxhMIf6xBvIaHXxg.png)

现在，如果我们执行 `motionLayout.transitionToState(set8)`，MotionLayout 将从 `Set7` 过渡到 `Set8`。当它到达 `Set8` 时，它**自动转换**到 `Set9`。对于 `Set10` 也是同样的道理。

> `autoTransition` 将在 MotionLayout 到达 `constraintSetStart` 中指定的 ConstraintSet 时自动执行过渡。

### AutoTransition 并不完美

如果我们再次观看动画，我们能够注意到背景中的 adapter 的元素正在播放动画。为了与 MotionLayout 转换**并行**完成这些动画，我们将不得不使用协程。只使用 `autoTransition` 是无法正确同步时间的。

```kotlin
private fun unFilterAdapterItems(): Unit = lifecycleScope.launch {
  
  // 1) Set7 -> Set8（同时执行缩小动画）
  motionLayout.transitionToState(R.id.set8)
  startScaleDownAnimator(true) // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set8)
  
  // 2) Set8 -> Set9（同时取消 adpater 的过滤）
  (context as MainActivity).isAdapterFiltered = false // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set9)
  
  // 3) Set9 -> Set10（同时执行放大动画）
  startScaleDownAnimator(false) // Simulataneous
  motionLayout.awaitTransitionComplete(R.id.set10)
}
```

> 标有 `//Simultaneous` 的行与正在发生的转换并行发生。

由于 `autoTransition` 在从一个过渡跳转到下一个过渡时不会等待，所以 `awaitTransitionComplete()` 只会让我们知道过渡何时完成。它**不会**在转换结束时实际等待。这就是为什么我们在开始时只使用一次 `transitionToState()`。

## 多步向前和向后的 Transition

![](https://miro.medium.com/max/800/1*qB9qCBsilZrracH7BSGYHg.gif)

AutoTransition 结合协程帮助我们实现对多步过渡的控制。

但是如果我们想在反转每个过渡时向后设置动画（`Set4 → Set1`）怎么办？

通过使用 `transitionToStart()` 我们可以反转**特定的**转换，例如 `Set4 → Set3`。但是如果我们使用 `autoTransition`，那么它会动画到 `Set3`，然后由于 `autoTransition` 它会**自动**返回到 `Set4`。

### 开场动画

打开筛选 Sheet 的代码与我们在上一节中看到的略有不同，因为我们没有使用 `autoTransition`。

```kotlin
/** 动画顺序：Set1 -> Set2 -> Set3 -> Set4 */
private fun openSheet(): Unit = lifecycleScope.launch {
  
  // 设置开始过渡。
  // 这是必要的，因为取消筛选动画会以 set10 结束，
  // 而我们需要在下次打开 Sheet 时重新设置它
  motionLayout.setTransition(R.id.set1, R.id.set2)
  
  // 1) Set1 -> Set2（同时开始缩小动画）
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

* 每次等待后我们必须使用 `transitionToState()`。这在以前是没有必要的，因为 `autoTransition` 会直接运行所有这些而不用等待，但现在，我们必须手动完成这项工作。
* 注意我们不是在每次等待后都调用 `setTransition()`，这是因为 `MotionLayout` 将根据当前的 ConstraintSet 和 `transitionToState()` 中提到的 ConstraintSet 来确定要使用的过渡。

### 关闭 Sheet 的动画（反向）

```kotlin
/** 动画顺序：Set4 -> Set3 -> Set2 -> Set1 */
private fun closeSheet(): Unit = lifecycleScope.launch {
  
  // 我们不必在这里调用 setTransition()，因为当前过渡是 Set3 -> Set4。
   // transitionToStart() 将自动从：
  // 1) Set4 -> Set3
  motionLayout.transitionToStart()
  motionLayout.awaitTransitionComplete(R.id.set3)
    
  // 2) Set3 -> Set2
  motionLayout.setTransition(R.id.set2, R.id.set3)
  motionLayout.progress = 1f
  motionLayout.transitionToStart()
  motionLayout.awaitTransitionComplete(R.id.set2)
  
  // 3) Set2 -> Set1（同时开始放大的动画）
  motionLayout.setTransition(R.id.set1, R.id.set2)
  motionLayout.progress = 1f
  motionLayout.transitionToStart()
  startScaleDownAnimator(false) // Simultaneous
  motionLayout.awaitTransitionComplete(R.id.set1)
}
```

由于所有 `<Transition>` 元素都是基于前向的，我们必须添加几行以使其能够反向。 它的本质是：

```kotlin
// 将过渡设置为反向（MotionLayout 只能检测正向过渡）。
motionLayout.setTransition(startSet, endSet)
// 这将设置过渡的进度到最后
motionLayout.progress = 1f
// 反转从结束到开始的过渡
motionLayout.transitionToStart()
// 等待过渡到达开始
motionLayout.awaitTransitionComplete(startSet)
// 对每个过渡重复上述步骤……
```

✔️ 这现在允许我们反向逐步执行多个转换，同时保持并行执行其他操作的能力。

## 结论 —— 有和没有 MotionLayout 的区别？

`MotionLayout` 与协程相结合，可以用很少的代码轻松实现非常复杂的动画，**同时还能保持平面视图层次结构！**

在我的[上一篇文章](/complex-ui-animation-on-android-8f7a46f4aec4?source=friends_link&sk=f1fab1861a655b042ff5e9c305a0e012)中，我探讨了所有这些是如何在不使用 MotionLayout 的情况下完成的，而完成上一章**所需的代码量比这大多了。我们还被迫使用了大量的数学运算以求让动画正常工作，或是让我们能够构造复杂的视图层次结构等。

> MotionLayout 带走了所有的废话，只给我们留下了必要的东西。有了协程和即将推出的 IDE 编辑器，MotionLayout 的可能性可能是无穷无尽的！

希望你喜欢这篇文章😃！如果您有兴趣，你可以查看一下本文的一些 [源代码](https://github.com/nikhilpanju/FabFilter)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
