> * 原文地址：[Exploring ConstraintLayout 2.0 in Android](https://medium.com/better-programming/exploring-constraintlayout-2-0-in-android-317584003ee9)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/exploring-constraintlayout-2-0-in-android.md](https://github.com/xitu/gold-miner/blob/master/article/2020/exploring-constraintlayout-2-0-in-android.md)
> * 译者：
> * 校对者：

# Exploring ConstraintLayout 2.0 in Android

![Photo by [rafzin p](https://unsplash.com/@rafzin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8942/0*goSdyD-yGtjIfUCP)

## Introduction

`ConstraintLayout` is one of the powerful Jetpack libraries that allows developers to create complex and responsive UI quickly with interactive tooling built into Android Studio, in order to preview your XML.

One of the significant advantages of `ConstraintLayout` is that we can build complex UI with a flat view hierarchy (no nested view groups). This result is drawing a lesser number of layers, which increases the performance.

#### A few key features of ConstraintLayout

1. We can position the views relatively one another.
2. We can center the views using bias or other views.
3. We can specify the aspect ratio of the view.
4. We can group and chain the views.

#### A few helper objects

Helper objects are the objects that are not visible to the user but come in handy to align developers’ views.

* `Guideline`
* `Barrier`
* `Placeholder`

To learn more about `ConstraintLayout` v1.0, read this [article](https://medium.com/better-programming/essential-components-of-constraintlayout-7f4026a1eb87).

## ConstraintLayout 2.0

Enough with the history lessons. It’s time to integrate v2.0 of `ConstraintLayout` into your project. To do so, add the following line under the dependencies tag in `build.gradle` file.

```
implementation “androidx.constraintlayout:constraintlayout:2.0.1”
```

This version brings several new features to `ConstraintLayout`; let’s start digging into them without any delay.

## Flow

`Flow` is a new virtual layout added in v2, similar to the group in v1. It’s a combination of `Chain` and `Group`, with special powers. In simple words, `Flow` chains the views with dynamic size at runtime.

Similar to `Group`, `Flow` also takes the reference view IDs and creates a `Chain` behavior. One of the vital advantages that `Flow` offers is `wrapMode` (a way to configure the views when they overflow). Out of the box, we’ve three modes to choose from: `none`, `aligned`, and `chain`.

![Flow mode : none, chain and aligned](https://cdn-images-1.medium.com/max/2000/0*RK2f87Te_cm259Gg)

* `[wrap none](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_none) `: Creates a chain out of the referenced views
* `[wrap chain](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_chain)` : Creates multiple chains (one after the other) only if the referenced views do not fit
* `[wrap aligned](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_aligned)` : Similar to `wrap chain`, but will align the views by creating rows and columns

```XML
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <androidx.constraintlayout.helper.widget.Flow
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:flow_wrapMode="chain"
        app:constraint_referenced_ids="btn1, btn2, btn3, btn4, btn5"
        />

    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/btn1"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        android:text="Button 1"/>

    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/btn2"
        app:layout_constraintLeft_toRightOf="@+id/btn1"
        app:layout_constraintTop_toTopOf="parent"
        android:text="Button 2"/>
    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/btn3"
        app:layout_constraintLeft_toRightOf="@+id/btn2"
        app:layout_constraintTop_toTopOf="parent"
        android:text="Button 3"/>

    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/btn4"
        app:layout_constraintLeft_toRightOf="@+id/btn3"
        app:layout_constraintTop_toTopOf="parent"
        android:text="Button 4"/>

    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/btn5"
        app:layout_constraintLeft_toRightOf="@+id/btn4"
        app:layout_constraintTop_toTopOf="parent"
        android:text="Button 5"/>

</androidx.constraintlayout.widget.ConstraintLayout>
```

This feature seems simple, but we can create flow layouts using `ConstraintLayout` 2.0. We no longer need to use flow layout libraries anymore.

Before `ConstraintLayout` 2.0, we had to calculate the remaining space after rendering each view to make sure the next view fits in there, else we’ve to align it in the next line. But now we need to use `Flow`.

To learn more about `Flow`, [read the official docs](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow).

## Layer

`Layer` is the new helper in `ConstraintLayout` 2.0, similar to `Guideline`s and `Barrier`s. We can create a virtual layer like a group with multiple referenced views. Once the views are referenced, we can apply transformations on those views using `Layer`.

It’s similar to a `Group` helper, where we can bind multiple views and perform basic actions like visibility (visible and gone). With `Layer`, we can take it to the next level. We can apply animations to `rotate`, `translate`, or `scale `multiple views together.

```XML
<androidx.constraintlayout.helper.widget.Layer
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:scaleX="20"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:constraint_referenced_ids="btn6, btn7"
        />
```

## MotionLayout

`MotionLayout` is a subclass of `ConstraintLayout` that includes all of its outstanding features, and it’s fully declarative, with the capability to implement complicated transitions in the XML. It is backward-compatible with API level 14, which means it covers 99% of use cases.

The new `MotionLayout` editor in Android Studio 4.0 makes it easy to work with `MotionLayout`. It provides a fancy environment to implement transitions, `MotionScenes`, and more.

To learn more about `MotionLayout`, read this [article](https://medium.com/better-programming/beginners-guide-to-motion-layout-732395a7de7e).

---

That is all for now, hope you learned something useful, thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
