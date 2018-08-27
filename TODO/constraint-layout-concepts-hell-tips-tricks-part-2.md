> * 原文地址：[Constraint Layout Concepts ( What the hell is this ) (Tips and Tricks) Part 2 ](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[Jifaxu](https://github.com/jifaxu)，[AngryD](https://github.com/yazhi1992)

# ConstraintLayout ( 这到底是什么 ) (小贴士及小技巧) 第二部分

哇哦，我们又有一整天时间，所以就来学点酷炫的新知识吧。

你们好，希望各位都有所进步。在上周中，我们学习了 ConstraintLayout 的[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md)。现在是时候来学习这个神奇布局的剩下内容了。

**动机:**
学习动机与先前在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md)中讨论的是一样的。 不过这次我不准备解释 ConstraintLayout 的特性，相反，我会分享一些当你们独立实现时可能遇到的问题。最后，我向大家保证，你们将会潜移默化地了解所有（我知道的）概念。

**问题:**

1. [MATCH_PARENT 不起作用](#1)

2. [居中对齐视图 (水平, 垂直, 在父视图中心)](#2)

3. [怎样将视图从中心向左或右移动一些 DP 值](#3)

4. [管理图片视图的比例](#4)

5. [需要两列或多列](#5)

6. [父视图的左边距, 一些是 16dp ，一些是 8dp ](#6)

7. [怎样在 ConstraintLayout 中实现 LinearLayout](#7)

8. [隐藏视图后，布局遭到破坏](#8)

是时候开始了！:)

我们需要下载 2.3 版本的 Android studio。先前版本的可视化编辑器不太完善，有时会在面板上显示错误的信息。所以下载 2.3 测试版本是非常重要的，该版本在我写这篇文章时已经可以获取到了。

<h6 id="1">1. MATCH_PARENT 不起作用:</h6>

当你在 ConstraintLayout 中试图设置长宽为 match_parent 时，如下图所示，将不会起作用（编辑器会自动修正）。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-31-31.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-31-31.gif)

不要再用 match_parent。记住 match_parent 不是被废弃了，而是从 ConstraintLayout 嵌套的视图中移除掉了。

解决方案:

恰当地在 Constrain Layout 嵌套的视图中使用 **parent** 属性。就像我们在 RelativeLayout 中设置 width=0dp，然后对齐到父布局的左右两边一样，我们需要做同样的操作，如下图所示：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-50-40.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-50-40.gif)

<h6 id="2">2. 居中对齐视图 (水平, 垂直, 在父视图中心):</h6>

我们需要在父布局的中心放置一个按钮，能通过下图的操作实现：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-02-29.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-02-29.gif)

现在我坚信，你能轻易地自己实现水平和垂直居中了。:)

<h6 id="3">3. 怎样将视图从中心向左或右移动一些 DP 值:</h6>

大部分设计师都给我们提过奇怪的需求，比如有人想要一段文字不是 100% 居中的，而是几乎从中心开始的。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-9.15.48-AM-181x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-9.15.48-AM.png)

解决方案:

首先, 抱歉了设计师😛。 在 ConstraintLayout 中实现起来非常容易：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-21-32.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-21-32.gif)

同样地，你可以使用 app:layout_constraintVertical_bias=”.1″.  记住取值区间是 0,0.1 .. 1。

<h6 id="4">4. 管理图片视图的比例:</h6>

很多时候我们的 ImageView 都有特定的比例，比如 4:3，因此我们能用下图的方式实现：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-39-48.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-39-48.gif)

哈哈！我知道这很简单，但还有另外一个问题。比如我有一个宽高尺寸都是 match_constrained 类型的 TextView，但是我希望整个 textView 的形状适应设备大小为方型。一个关键点是，我们需要按如下方式设置宽高属性来约束为方型：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-56-50.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-56-50.gif)

现在你可以随机地尝试更多设置值了。

<h6 id="5">5. 需要两列或多列:</h6>

现在我们的设计师又要求像是表格布局的样式，像是下面这样的两列：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.17.19-AM-181x300.png)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.17.19-AM.png)

解决方案：

实现起来非常简单。我们只需在 ConstraintLayout 中添加一个叫做 Guidelines 即可。这非常酷！你能马上搞定。 你可以将这些线条主要用作分隔 UI 的辅助工具。如果你说你掌握了 Guidelines 的话，你必须知道下面三个重要的属性：

**orientation**: 水平, 垂直 // 分隔屏幕的方式

**layout_constraintGuide_percent**: 0, 0.1 ..  1 // 屏幕的全部大小表示为 1.0 

**layout_constraintGuide_begin**: 200dp  // 通过 dp 值来表示放置 Guidelines 的位置

最终，Guidelines 永远不会绘制到 UI 界面中。
首先，我先来实现一个将屏幕分隔为两部分的 Guidelines ，以便我能看到两列内容。

    <android.support.constraint.Guideline
        android:id="@+id/guideline"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:orientation="vertical"
        app:layout_constraintGuide_percent=".5" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.32.35-AM-209x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.32.35-AM.png)

首先添加第一个按钮：

    <Button
    android:id="@+id/button"
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    android:text="Button"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toLeftOf="@+id/guideline"
    app:layout_constraintTop_toTopOf="parent" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.35.24-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.35.24-AM.png)

添加第二个按钮：

    <Button
        android:id="@+id/button2"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:text="Button"
        app:layout_constraintLeft_toLeftOf="parent"
       app:layout_constraintRight_toLeftOf="@+id/guideline"
        app:layout_constraintTop_toBottomOf="@+id/button" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.38.04-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.38.04-AM.png)

接下来在第二列中添加 Textview：

    <TextView
        android:id="@+id/textView2"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:background="@color/colorAccent"
        android:text="TextView"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toRightOf="@+id/guideline"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.41.39-AM-210x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.41.39-AM.png)

使用 ConstraintLayout 实现这样的 UI 效果非常简单。使用这个方法，你可以随意添加更多的行和列。

完整的代码如下：

    <?xml version="1.0" encoding="utf-8"?>
        <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
            xmlns:app="http://schemas.android.com/apk/res-auto"
            xmlns:tools="http://schemas.android.com/tools"
            android:layout_width="match_parent"
            android:layout_height="match_parent">

            <android.support.constraint.Guideline
                android:id="@+id/guideline"
                android:layout_width="0dp"
                android:layout_height="0dp"
                android:orientation="vertical"
                app:layout_constraintGuide_percent=".5"/>

            <Button
                android:id="@+id/button"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="parent"
                app:layout_constraintRight_toLeftOf="@+id/guideline"
                app:layout_constraintTop_toTopOf="parent" />

            <Button
                android:id="@+id/button2"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_marginTop="0dp"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="parent"
                app:layout_constraintRight_toLeftOf="@+id/guideline"
                app:layout_constraintTop_toBottomOf="@+id/button" />

            <TextView
                android:id="@+id/textView2"
                android:layout_width="0dp"
                android:layout_height="0dp"
                android:background="@color/colorAccent"
                android:text="TextView"
                app:layout_constraintBottom_toBottomOf="parent"
                app:layout_constraintLeft_toRightOf="@+id/guideline"
                app:layout_constraintRight_toRightOf="parent"
                app:layout_constraintTop_toTopOf="parent" />
        </android.support.constraint.ConstraintLayout>

<h6 id="6">6. 父视图的左边距, 一些是 16dp ，一些是 8dp:</h6>

我有一些视图，其中一些左边距是 16dp，一些是 8dp。如下所示： 

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.52.32-AM-179x300.png)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.52.32-AM.png)

也许你会问这样的问题：为什么这篇文章中会提到这么简单的效果？主要是因为我在分享一些管理 UI 布局的技巧，我觉得你应该知道怎样用不同的方式来实现效果。

所以是时候开始了。

如果你由上至下地看下来，首先，第二个和最后一个视图外边距为 16dp，其余的外边距为 8dp。

我能够直接设置所有视图的外边距，但是许多时候设计师说这样在某些小屏设备上看起来很丑，能否将这些视图都设置成 8dp 到 12dp 的外边距，并且将所有 16dp 的外边距改为 12dp。

如果你直接设置外边距，那简直就是噩梦 。所以我将要设置两条辅助线，一个边距是 8dp，另一个边距是 16dp。两个都是垂直方向的。 

    <android.support.constraint.Guideline
        android:id="@+id/eightDpGuideLine"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:orientation="vertical"
        app:layout_constraintGuide_begin="8dp" />

    <android.support.constraint.Guideline
        android:id="@+id/sixteenDpGuideLine"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:orientation="vertical"
        app:layout_constraintGuide_begin="16dp" />

现在只需要将所有视图的外边距都设置成 0dp 就可以很轻松地实现需求了。下面会给出完整的代码：

    <?xml version="1.0" encoding="utf-8"?>
        <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
            xmlns:app="http://schemas.android.com/apk/res-auto"
            xmlns:tools="http://schemas.android.com/tools"
            android:layout_width="match_parent"
            android:layout_height="match_parent">

            <android.support.constraint.Guideline
                android:id="@+id/eightDpGuideLine"
                android:layout_width="0dp"
                android:layout_height="0dp"
                android:orientation="vertical"
                app:layout_constraintGuide_begin="8dp"/>

            <android.support.constraint.Guideline
                android:id="@+id/sixteenDpGuideLine"
                android:layout_width="0dp"
                android:layout_height="0dp"
                android:orientation="vertical"
                app:layout_constraintGuide_begin="16dp"/>

            <Button
                android:id="@+id/button3"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="38dp"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="@+id/sixteenDpGuideLine"
                app:layout_constraintTop_toTopOf="parent" />

            <Button
                android:id="@+id/button4"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="99dp"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="@+id/eightDpGuideLine"
                app:layout_constraintTop_toTopOf="parent" />

            <Button
                android:id="@+id/button5"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="75dp"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="@+id/sixteenDpGuideLine"
                app:layout_constraintTop_toBottomOf="@+id/button3" />

            <TextView
                android:id="@+id/textView5"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="115dp"
                android:text="TextView"
                app:layout_constraintLeft_toLeftOf="@+id/eightDpGuideLine"
                app:layout_constraintTop_toBottomOf="@+id/button4" />

            <ProgressBar
                android:id="@+id/progressBar"
                style="?android:attr/progressBarStyle"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="86dp"
                app:layout_constraintLeft_toLeftOf="@+id/sixteenDpGuideLine"
                app:layout_constraintTop_toBottomOf="@+id/button5" />
        </android.support.constraint.ConstraintLayout>



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.11.23-AM-1024x559.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.11.23-AM.png)

现在设计师想要把 16dp 改成 20dp。我只需要改变 Guideline 值即可：  app:layout_constraintGuide_begin=”16dp” 变为 app:layout_constraintGuide_begin=”20dp”。另外值得注意的是：要及时修改命名以免给你的同事造成困惑。例如这里我会及时将命名由 sixteenDpGuideLine 修改成 twentyDpGuideLine。现在你可以看到下图中神奇的变化： 

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-11-17-59.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-11-17-59.gif)

<h6 id="7">7. 怎样在 ConstraintLayout 中实现 LinearLayout:</h6>

我们现在有三个按钮，水平均分并排着。在 LinearLayout 中我们可以通过 weight 来实现，代码如下：

    <?xml version="1.0" encoding="utf-8"?>
        <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:orientation="horizontal">

            <Button
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Button1" />

            <Button
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Button2" />

            <Button
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="Button3" />
        </LinearLayout>



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.27.11-AM-209x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.27.11-AM.png)

怎样在 ConstraintLayout 中实现这种效果呢？ 非常简单，直接看代码： 

    <?xml version="1.0" encoding="utf-8"?>
        <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
            xmlns:app="http://schemas.android.com/apk/res-auto"
            xmlns:tools="http://schemas.android.com/tools"
            android:layout_width="match_parent"
            android:layout_height="match_parent">

            <Button
                android:id="@+id/button1"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:text="Button"
                app:layout_constraintLeft_toLeftOf="parent"
                app:layout_constraintRight_toLeftOf="@+id/button2" />

            <Button
                android:id="@+id/button2"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:text="Button"
                app:layout_constraintLeft_toRightOf="@+id/button1"
                app:layout_constraintRight_toLeftOf="@+id/button3" />

            <Button
                android:id="@+id/button3"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:text="Button"
                app:layout_constraintLeft_toRightOf="@+id/button2"
                app:layout_constraintRight_toRightOf="parent" />
        </android.support.constraint.ConstraintLayout>



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.36.04-AM-209x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.36.04-AM.png)

这样就得到了同样的效果。只需关注一点，在这些按钮中我建立了两两之间的关系，并且设置 width=”0dp”。

    android:id="@+id/button1"
    ........
    app:layout_constraintRight_toLeftOf="@+id/button2"

    android:id="@+id/button2"
    ........
    app:layout_constraintLeft_toRightOf="@+id/button1"
    app:layout_constraintRight_toLeftOf="@+id/button3"
    ........

噢不，你们已经学到了一个新的概念叫做 **chaining**。当我们建立视图之间的两者关系时，编辑器会自动链接起来。现在是时候来讨论下使用 chaining 带来的好处了。在这之前，我想要你先了解 chaining 在编辑器中的样子：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.44.26-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.44.26-AM.png)

在下文我将复制一些来自 Android 官方的文档。因为我觉得解释得很好。

**Chains:**

Chains 在一个方向（水平或垂直）提供类似组合的行为。另一方向可以独立约束。

**创建 chain:**

 一系列控件通过建立双向联系从而链接成链 (看下面，展示了一个含有两个控件的最小链)。

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains.png)

**Chain 的头部**

Chain 被位于它链中第一个元素的属性集控制 (链的“头”部)：

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains-head.png)

对于水平链来说最左边的控件是头部，对垂直链来说最上面的控件是头部。

现在我觉得你们应该熟悉了 Chaining 的概念了。接下来我会介绍关于 chaining 的另一个知识点：**chaining style**。本来有一个非常好的文档来介绍它，但我决定稍后再推荐，因为它会把你搞混淆。首先，我先来让你们掌握些实际经验。

对于 chaining style 来说，有一个新的属性 **layout_constraintHorizontal_chainStyle
(layout_constraintVertical_chainStyle)** 我们能给这个属性设置五种值。

Spread Chain, Spread Inside Chain, Packed Chain, Packed Chain with Bias 以及 Weighted Chain。下面将一一介绍每一种值。

**Spread Chain:**

通过在头部视图的属性中添加 “spread”，得到如下的结果。

    app:layout_constraintHorizontal_chainStyle="spread"



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.57.28-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.57.28-AM.png)

并没有发生变化，因为 **spread ** 就是默认值。🙂

**Spread Inside Chain:**
 
在头部视图中添加 “spread inside”，得到如下结果： 

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-03-41.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-03-41.gif)

简而言之当我的头部视图中设置这个值时，链头和尾部的视图都自动地依附到了父容器的左右两边。如果你想要这种效果，那就应该使用  “spread_insdie” 值。

**Packed Chain:**

在头部视图中添加 “packed”，得到如下结果：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-07-52.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-07-52.gif)

如果我们想要所有的视图连在一起，我们就应使用 “packed” 属性。需要注意一点，所有的视图会默认变为水平居中。现在我的问题是我不想要水平居中的效果，那么就轮到下个属性了。

**Packed Chain with Bias:**

在头部视图中添加 “packed and horizontal bias”，得到如下结果：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-15-05.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-15-05.gif)

通过使用偏移量属性，我能随意地修改位置。

**Weighted Chain:**

比如我有三个按钮，前两个要占半个屏幕，第三个占据剩下的一半屏幕。对于这种需求，我将要使用到 weighted chain 概念，如下所示。一个关键点是，通常来说，我们使用默认的 “spread” 属性，然后添加一个 **“layout_constraintHorizontal_weight”** 属性来管理视图空白的分布。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-22-55.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-22-55.gif)

现在我们了解了 Chaining 的概念以及 chaining styles 的不同。接下来我将要复制一些关于样式的定义：

- `CHAIN_SPREAD` — 元素将被展开 (默认样式)
- Weighted chain — 在 `CHAIN_SPREAD` 模式下, 如果控件被设置成 `MATCH_CONSTRAINT`, 它们将会分割剩余空间
- `CHAIN_SPREAD_INSIDE` — 同样地, 但是链的端点不会被展开
- `CHAIN_PACKED` —链的元素将会被拼接，子元素的水平或垂直偏移量会影响拼接后整体的位置

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains-styles.png)

**Weighted chains:**

链的默认样式是展开并均分剩余空间。如果一个或多个元素使用  `MATCH_CONSTRAINT`，它们将会使用剩余空间(平均分配剩余空间)。 `layout_constraintHorizontal_weight` 属性和  `layout_constraintVertical_weight` 属性将会控制类型为 `MATCH_CONSTRAINT` 的元素如何分配剩余空间。例如， 一条链上有两个元素使用 `MATCH_CONSTRAINT`, 第一个元素的权重值是 2 第二个元素的权重值是 1, 那么第一个元素占据的空间将是第二个元素的两倍。

<h6 id="8">8. 隐藏视图后，布局遭到破坏：</h6>

在运行时，某些视图隐藏之后会发生什么呢？我做了一些实验并得到了奇怪的结果。 为了解释并解决这些问题，我用了一个非常简单但有效的例子，例如我有如下两个按钮：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-12.33.31-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-12.33.31-PM.png)

根据编写的代码，当第二个按钮点击时，第一个按钮会隐藏。当我实现这个代码时，我猜想第二个按钮会移动到父容器的左边缘，让我们来看看发生了什么。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-36-13.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-36-13.gif)和

哈哈我的设想被推翻了！

解决方案：基本上来说，ConstraintLayout 中有一个新的属性叫做  “app:layout_goneMargin”。通过使用这个属性，我能解决这种问题。因此我将添加一两行代码然后看看我的问题解决没。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-40-40.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-40-40.gif)

砰！如期所至！好耶。

好啦各位，该说再见啦。下期再见！

**[ConstraintLayout \[Animations | Dynamic Constraints | UI by Java\] ( What the hell is this) \[Part3\] ](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-animations-dynamic-constraints-ui-java-hell.md)**
