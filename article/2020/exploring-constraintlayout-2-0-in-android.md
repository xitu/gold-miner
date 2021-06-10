> - 原文地址：[Exploring ConstraintLayout 2.0 in Android](https://medium.com/better-programming/exploring-constraintlayout-2-0-in-android-317584003ee9)
> - 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/exploring-constraintlayout-2-0-in-android.md](https://github.com/xitu/gold-miner/blob/master/article/2020/exploring-constraintlayout-2-0-in-android.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[regon-cao](https://github.com/regon-cao)、[happySteveQi](https://github.com/happySteveQi)

# 探索 Android 中的 ConstraintLayout 2.0

![Photo by [rafzin p](https://unsplash.com/@rafzin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8942/0*goSdyD-yGtjIfUCP)

## 介绍

`ConstraintLayout` 是功能强大的 Jetpack 库之一，开发人员可以使用 Android Studio 内置的交互工具结合该库快速创建复杂且响应迅速的布局，同时预览该 XML 布局。

 `ConstraintLayout` 的一大优点是我们可以使用单层视图层次结构（无嵌套视图）构建复杂的布局。由于绘制的视图层数更少，性能自然就提高了。

#### ConstraintLayout的一些关键功能

1. 我们可以指定视图的相对位置。
2. 我们可以使用偏移或其他视图来居中视图。
3. 我们可以指定视图的宽高比例。
4. 我们可以对视图进行分组和链接。

#### 一些辅助布局

辅助布局是用户看不见的布局，但是可以方便开发人员对齐视图。

- `Guideline`
- `Barrier`
- `Placeholder`

要了解 `ConstraintLayout` v1.0 的更多信息，请阅读这篇[文章](https://medium.com/better-programming/essential-components-of-constraintlayout-7f4026a1eb87)。

## ConstraintLayout 2.0

在充分了解完它的历史之后，是时候将`ConstraintLayout` v2.0 集成到您的项目中了。要引入它需要在 build.gradle 文件中添加如下依赖。

```
implementation “androidx.constraintlayout:constraintlayout:2.0.1”
```

这个版本为`ConstraintLayout`带来了几个新功能。让我们马上来研究一下吧。

## Flow

`Flow` 是 v2 版本中新增的虚拟布局方式，类似于v1版本中的 `group` 。它是 `Chain` 和 `Group` 布局的一个结合，具有特殊的功能。简而言之就是 `Flow` 在运行时根据布局的大小动态链接视图。

与 `Group` 类似，`Flow` 同样也是通过获取视图的ID并创建 `Chain` 所具有的行为。使用 `Flow` 布局重要优势之一是 `wrapMode`（一种在视图溢出时配置视图的方法）。添加该布局属性即可使用，我们提供三种模式供您选择：`none`，`aligned` 和 `chain`。

![Flow mode : none, chain and aligned](https://cdn-images-1.medium.com/max/2000/0*RK2f87Te_cm259Gg)

- `[wrap none](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_none) `: 所有引用的视图形成一条链
- `[wrap chain](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_chain)` : 仅当引用的视图不适合时才创建多个链（一个接一个）
- `[wrap aligned](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow#wrap_aligned)` : 与 `wrap chain` 类似，但是将通过创建行和列来对齐视图

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

这个功能看起来很简单，不过我们可以使用 `ConstraintLayout` 2.0 创建流式布局。不再需要使用其他流式布局库。          

在 `ConstraintLayout` 2.0 之前，我们必须在渲染每个视图之后计算剩余空间，来确定下一个视图是否有足够的空间适合存放，否则我们必须将其对齐到下一行。但是现在我们只要使用 `Flow` 就可以了。

要了解有关 `Flow` 的更多信息，请[阅读官方文档](https://developer.android.com/reference/androidx/constraintlayout/helper/widget/Flow)。

## Layer

`Layer` 是 `ConstraintLayout` 2.0 中的新增的辅助布局方式，类似于 `Guideline` 和 `Barrier` 的辅助布局方式。我们可以通过创建一个虚拟图层，类似与一个父视图(Layer)中有多个子视图的方式。一旦子视图引用了父视图，我们就可以使用 `Layer` 对这些视图进行转换。

它类似于 `Group` 布局，我们可以通过它绑定多个视图并设置其可见性（可见和消失）等基本操作。一旦视图被 `Layer` 引用，我们的视图就可以使用 `Layer` 给我们带来的那些转换功能了。我们可以对多个视图做旋转，平移，缩放或者组合动画。

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

`MotionLayout` 是 `ConstraintLayout` 的子类，继承了父类的所有的优秀功能，并且是完全声明性的，而且能够在 XML 中实现复杂的转换。它从 API 14 开始向后兼容，也就是说它兼容了 99％ 的应用。

Android Studio 4.0 中新增加的 `MotionLayout` 编辑器让我们方便的使用 `MotionLayout`。它提供了一个很好的场景来实现过渡，比如 `MotionScenes` 等。

要了解有关 `MotionLayout` 的更多信息，请阅读此[文章](https://medium.com/better-programming/beginners-guide-to-motion-layout-732395a7de7e)。

------

到此为止，希望你学到一些有用的东西，感谢阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
