> * 原文地址：[Introducing Constraint Layout 1.1](https://medium.com/google-developers/introducing-constraint-layout-1-1-d07fc02406bc)
> * 原文作者：[Sean McQuillan](https://medium.com/@objcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-constraint-layout-1-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-constraint-layout-1-1.md)
> * 译者：Moosphon
> * 校对者：

# 带你领略 ConstraintLayout 1.1 的新功能

**约束布局**（ConstraintLayout）通过使用 Android Studio 中的可视化编辑器来为您生成绝大多数的 UI，进而达到简化 Android 中创建复杂布局的目的。它通常被我们描述为更加强大的`相对布局`。通过使用约束布局，您可以定义一些复杂的布局而不需要创建复杂的视图层级。

约束布局最近发布了 1.1 稳定版本，并迅速获得大量好评。全面的优化改进可以让多数布局的运行速度比以前更快，屏障和群组等新功能使现实生活的设计变得简单！

#### Android Gradle

```
dependencies {
    compile 'com.android.support.constraint:constraint-layout:1.1.0'
}
```

如果您想要在项目中使用新特性，需要添加 ConstraintLayout 1.1 版本作为依赖。

### 1.1 版本中的新特性

#### 百分比

在约束布局 1.0 版本中，需要使用两条引导线才能让视图根据百分比来占据屏幕。而在约束布局 1.1 版本中，通过允许您轻松地将任何视图限制为百分比宽度或高度，一切将变得很简单。![](https://cdn-images-1.medium.com/max/800/1*uqU2HbwRZeik-P2Ny-leIg.jpeg)

使用百分比指定按钮的宽度，以便在保持设计效果的同时适应可用空间。

所有视图都支持 `layout_constraintWidth_percent` 和 `layout_constraintHeight_percent` 属性。这些将导致约束被固定在可用空间指定百分比位置。 因此，使用几行 XML 代码就可以使 `Button` 或 `TextView` 展开并以百分比填充屏幕。

```
<Button
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    app:layout_constraintWidth_percent="0.7" />
```

#### 链条

通过**链条**功能来放置多个元素可以让你配置它们该如何填充可用空间。在 1.1 版本中，我们已经修复了链条的一些问题，并使它们能够处理更多的视图。您可以通过在两边添加约束来生成一个链条。例如在下面这个动画中，每个视图之间都有一个约束。

![](https://cdn-images-1.medium.com/max/800/1*3wFzyPS9Fpc-b52roKVSCQ.gif)

通过 **spread**，**spread_inside** 和 **packed**，链条能够让您配置如何布置多个相关的视图。

`app:layout_constraintVertical_chainStyle` 属性可以作用于链条中的任何视图。 您可以设置它的值为 `spread`， `spread_inside` 或者 `packed`。

*   **spread**：均匀分配链中的所有视图
*   **spread_inside**：将第一个元素和最后一个元素放置在边缘上，并均匀分布其余元素
*   **packed**：将元素包裹在链条的中心

#### 屏障

如果您有几个视图会在运行时更改大小，则可以使用**屏障**功能来约束元素。您可以将屏障放置于几个元素的开始，顶部，末尾或底部。您可以将其视为制作虚拟组的一种方式 ，因为它不会将此组添加到视图层次结构中。

在布置国际化字符串或显示用户生成的无法预测大小的内容时，屏障非常有用。

![](https://cdn-images-1.medium.com/max/800/1*6Moj_NLX9iIzfen3aUh6WA.gif)

屏障允许您通过几个视图来创建一个约束。

屏障将始终将自己置于虚拟群组之外，并且您可以使用它来限制其他视图。在上面这个例子中，右视图被限制为始终处于最大文本视图的末尾。

#### 群组

有时您需要一次显示或隐藏多个元素。为了支持这个，约束布局增加了**群组**功能。

一个群组并没有增加视图的层级——这实际上只是一种标记视图的方式。在下面的示例中，我们将标记 `profile_name` 和 `profile_image` 以供 id 配置文件引用。

当您有多个需要显示或陈列在一起的元素时，这将很有用。

```
<android.support.constraint.Group
    android:id="@+id/profile"
    app:constraint_referenced_ids="profile_name,profile_image" />
```

当定义群组配置文件后，您可以为该群组设置可见性，并将其应用于 `profile_name` 和 `profile_image`。

```
profile.visibility = GONE

profile.visibility = VISIBLE
```

#### 圆形约束

在约束布局中，大多数约束由屏幕尺寸指定——水平和垂直。在约束布局 1.1 版本中，有一个新的类型约束 `constraintCircle` ，它允许您指定沿着一个圆形进行约束。您不必提供水平和垂直边距，而是指定圆的角度和半径。这对于像径向菜单这样的角度偏移的视图将非常有用！

![](https://cdn-images-1.medium.com/max/800/1*dkCMb35o4HN7SVX8S1N3ig.gif)

您可以通过指定要偏移的**半径**和**角度来创建径向菜单。

创建圆形约束时，请注意，角度从顶部开始并顺时针进行。在这个例子中，你将按如下方式指定中间的 fab ：

```
<android.support.design.widget.FloatingActionButton
    android:id="@+id/middle_expanded_fab"
    app:layout_constraintCircle="@+id/fab"
    app:layout_constraintCircleRadius="50dp"
    app:layout_constraintCircleAngle="315" />
```

#### 约束集与动画

您可以将 `ConstraintLayout` 随同 [`ConstraintSet`](https://developer.android.com/reference/android/support/constraint/ConstraintSet.html) (约束集)一起使用来一次实现多个元素的动画效果。

一个 `ConstraintSet` 仅持有一个 `ConstraintLayout` 的约束。你可以在代码中创建一个`ConstraintSet`，或者从一个布局文件中加载它。然后，您可以将 `ConstraintSet` 应用于 `ConstraintLayout` ，更新所有约束以匹配 `ConstraintSet` 中的约束。

要使其具有动画效果，请使用 support library 中的 [`TransitionManager.beginDelayedTransition()`](https://developer.android.com/reference/android/transition/TransitionManager.html#beginDelayedTransition%28android.view.ViewGroup%29) 方法。此功能将使您的 `ConstraintSet` 中的所有布局的更新都通过动画来呈现。

这是一个更深入地涵盖了这个话题的视频：

* YouTube 视频链接：https://youtu.be/OHcfs6rStRo

#### 新的优化

约束布局 1.1 版本中添加了几个新的优化点，可加快您的布局速度。这些优化点作为一个单独的通道运行，并尝试减少布局视图所需的约束数量。

总的来说，它们是通过在布局中寻找常量并简化它们来运作的。

有一个名为 `layout_optimizationLevel` 的新标签，用于配置优化级别。它可以设置为以下内容：

*   **barriers**：找出**屏障**所在，并用简单的约束取代它们
*   **direct**：优化那些直接连接到固定元素的元素，例如屏幕边缘或引导线，并继续优化直接连接到它们的任何元素。
*   **standard**：这是包含 **barriers** 和 **direct** 的默认优化级别 。
*   **dimensions**：目前处于实验阶段，并且可能会在某些布局上出现问题  —它会通过计算维度来优化布局传递。
*   **chains**：目前正在实验阶段，并计算出如何布置固定尺寸的元素链。

如果你想尝试试验性的优化上述中的 **dimensions** 和 **chains**，你可以在 ConstraintLayout 中通过如下代码来启用它们：

```
<android.support.constraint.ConstraintLayout 
    app:layout_optimizationLevel="standard|dimensions|chains"
```

喜欢这篇文章？不如给 Sean McQuillan 一点鼓励。

## 了解更多

* [使用约束布局构建响应式UI | Android Developers](https://developer.android.com/training/constraint-layout/index.html)
* [约束布局 | Android Developers](https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html)
* [使用约束布局来设计你的Android视图](https://codelabs.developers.google.com/codelabs/constraint-layout/)

想要了解有关约束布局 1.1 版本的更多信息，请查看文档和代码实验室！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
