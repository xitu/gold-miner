> * 原文地址：[Introducing Constraint Layout 1.1](https://medium.com/google-developers/introducing-constraint-layout-1-1-d07fc02406bc)
> * 原文作者：[Sean McQuillan](https://medium.com/@objcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-constraint-layout-1-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-constraint-layout-1-1.md)
> * 译者：
> * 校对者：

# Introducing Constraint Layout 1.1

Constraint Layout simplifies creating complex layouts in Android by making it possible to build most of your UI using the visual editor in Android Studio. It’s often described as a more powerful `RelativeLayout`. With Constraint Layout you can define complex layouts without building complicated view hierarchies.

Constraint Layout 1.1 was recently released as stable and there’s a lot to love. A complete overhaul of optimization makes most layouts run even faster than before and new features like barriers and groups make real-world designs simple!

#### Android Gradle

```
dependencies {
    compile 'com.android.support.constraint:constraint-layout:1.1.0'
}
```

To use the new features in your project add Constraint Layout 1.1 as a dependency.

### New Features in 1.1

#### Percents

In Constraint Layout 1.0 making a view take up a percentage of the screen required making two guidelines. In Constraint Layout 1.1 we’ve made it simpler by allowing you to easily constrain any view to a percentage width or height.

![](https://cdn-images-1.medium.com/max/800/1*uqU2HbwRZeik-P2Ny-leIg.jpeg)

Specify the width of button using percents so it fits in the available space while maintaining your design.

All views support `layout_constraintWidth_percent` and `layout_constraintHeight_percent` attributes. These will cause the constraint to be fixed at a percentage of the available space. So making a `Button` or a `TextView` expand to fill a percent of the screen can be done with a few lines of XML.

```
<Button
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    app:layout_constraintWidth_percent="0.7" />
```

#### Chains

Positioning multiple elements with a **chain** lets you configure how they fill the available space. In 1.1 we’ve fixed several bugs with chains and made them work on more views. You make a chain by adding constraints in both directions. For example in this animation, there’s a constraint between every view.

![](https://cdn-images-1.medium.com/max/800/1*3wFzyPS9Fpc-b52roKVSCQ.gif)

Chains let you configure how to layout multiple related views with **spread**, **spread_inside**, and **packed**.

The `app:layout_constraintVertical_chainStyle` property is available on any view in the chain. You can set it to either `spread`, `spread_inside`, or `packed`.

*   **spread** evenly distributes all the views in the chain
*   **spread_inside** positions the first and last element on the edge, and evenly distribute the rest of the elements
*   **packed** pack the elements together at the center of the chain

#### Barriers

When you have several views that may change size at runtime, you can use a **barrier** to constrain elements . A barrier is positioned at the `start`, `top`, `end`, or `bottom` of several elements. You can think of it as a way of making a virtual group — virtual because it doesn’t add this group to view hierarchy.

Barriers are really useful when you’re laying out internationalized strings or displaying user generated content whose size you cannot predict.

![](https://cdn-images-1.medium.com/max/800/1*6Moj_NLX9iIzfen3aUh6WA.gif)

Barriers allow you to create a constraint from several views.

The barrier will always position itself just outside the virtual group, and you can use it to constrain other views. In this example, the right view is constrained to always be to the end of the largest text view.

#### Groups

Sometimes you need to show or hide several elements at once. To support this, Constraint Layout added **groups**.

A group doesn’t add a level to the view hierarchy — it’s really just a way to tag views. In the example below, we’re tagging `profile_name` and `profile_image` to be referenced by the id `profile`.

This is useful when you have several elements that are shown or displayed together.

```
<android.support.constraint.Group
    android:id="@+id/profile"
    app:constraint_referenced_ids="profile_name,profile_image" />
```

Once you’ve defined the group `profile` you can apply visibility to the group, and it’ll be applied to both `profile_name` and `profile_image`.

```
profile.visibility = GONE

profile.visibility = VISIBLE
```

#### Circular Constraints

In Constraint Layout most constraints are specified by the screen dimensions — horizontal and vertical. In Constraint Layout 1.1 there’s a new type of constraint ,`constraintCircle`, that lets you specify constraints along a circle. Instead of providing horizontal and vertical margins, you specify the angle and radius of a circle. This is useful for views that are offset at an angle like a radial menu!

![](https://cdn-images-1.medium.com/max/800/1*dkCMb35o4HN7SVX8S1N3ig.gif)

You can create radial menus by specifying a **radius** and **angle** to offset.

When creating circular constraints, note that angles start at the top and progress clockwise. Here’s how you would specify the middle fab in this example:

```
<android.support.design.widget.FloatingActionButton
    android:id="@+id/middle_expanded_fab"
    app:layout_constraintCircle="@+id/fab"
    app:layout_constraintCircleRadius="50dp"
    app:layout_constraintCircleAngle="315" />
```

#### Animations with ConstraintSet

You can use Constraint Layout along with `[ConstraintSet](https://developer.android.com/reference/android/support/constraint/ConstraintSet.html)` to animate several elements at once.

A `ConstraintSet` holds just the constraints of a `ConstraintLayout`. You can create a `ConstraintSet` in code, or by loading it from a layout file. You can then apply a `ConstraintSet` to a `ConstraintLayout`, updating all the constraints to match what’s in the `ConstraintSet`.

To make it animate, use `[TransitionManager.beginDelayedTransition()](https://developer.android.com/reference/android/transition/TransitionManager.html#beginDelayedTransition%28android.view.ViewGroup%29)` from the support library. This function will cause all the layout changes from your `ConstraintSet` to be animated.

Here’s a video covering the topic in more depth:

* YouTube 视频链接：https://youtu.be/OHcfs6rStRo

#### New Optimizations

Constraint Layout 1.1 adds several new optimizations that speed up your layouts. The optimizations run as a separate pass, and attempt to reduce the number of constraints needed to layout your views.

In general they work by finding constants in your layout and simplifying them.

There’s a new tag, called `layout_optimizationLevel`, which configures the optimization level. It can be set to the following:

*   **barriers** figures out where barriers are and replaces them with simpler constraints
*   **direct** optimizes elements directly connected to fixed element, for example the side of the screen or guidelines, and continues to optimize any elements directly connected to them
*   **standard** is the default optimization level which includes **barriers** and **direct**
*   **dimensions** is currently experimental and can cause issues on some layouts — it optimizes the layout pass by calculating dimensions
*   **chains** is currently experimental and figures out how to lay out chains of elements with fixed sizes

If you want to try out the experimental optimizations **dimensions** and **chains** you can enable them on a ConstraintLayout with

```
<android.support.constraint.ConstraintLayout 
    app:layout_optimizationLevel="standard|dimensions|chains"
```

Like what you read? Give Sean McQuillan a round of applause.

## Learn More

* [Build a Responsive UI with ConstraintLayout | Android Developers](https://developer.android.com/training/constraint-layout/index.html)
* [ConstraintLayout | Android Developers](https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html)
* [Use ConstraintLayout to design your Android views](https://codelabs.developers.google.com/codelabs/constraint-layout/)

To learn more about Constraint Layout 1.1 check out the documentation and code lab!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
