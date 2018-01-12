> * 原文地址：[Constraint Layout ( What the hell is this )](http://www.uwanttolearn.com/android/constraint-layout-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jifaxu](https://github.com/jifaxu)
* 校对者：[yazhi1992](https://github.com/yazhi1992),  [jamweak](https://github.com/jamweak)

# ConstraintLayout (这到底是什么)

喔，又是新的一天，为了不浪费这宝贵的时光，让我们来学点新知识吧 :)。

大家好，今天让我们学习 Android 里的 Constraint 布局。

**动机：**

我想先讨论一下我在学习这个很酷的布局时的经验。当 Google 发布这个布局后我就开始学习了，在这个过程中我遇到了很多的问题。我想找一些优秀的教程，但是结果都是一些教我在可视化编辑器里拖拽图片的东西，这些对我一点用都没有。两个月之后我改变了我的方法。通过分析我自己的特点我找到了答案。我擅长用 XML 来编写 LinearLayout，RelativeLayout，FrameLayout 等，所以我觉得我应该通过 XML 来学习 ConstraintLayout。但是当我在可视化编辑器里添加了一些组件并打开 XML 文件的时候，我再一次陷入了困境，这里面有太多我不认识的新标签了。虽然感到很沮丧但我并不打算就此放弃。再一次地，我改变了方法，这次我决定放弃可视化编辑器，创建一个 RelativeLayout 再将它转换成 ConstraintLayout。一切尽在意料之中，这次我只用了一天就掌握了它 🙂，现在我已经习惯使用 ConstraintLayout 了。

在这之后，我又用同样的方法将 LinearLayout 和 FrameLayout 转成了 ConstraintLayout。今天我将会在这篇博客中使用同样的方法。每个人脑回路都不太一样，所以有可能你并不认同我的方法。但是对于那些苦于不知如何入手的朋友们那那可以向你保证这个方法时值得一试的。还有一个好消息那就是现在我知道如何顺畅的使用可视化编辑器了。事情已经说的很清楚了，现在是时候开始学习 **CONSTRAINT LAYOUT** 了。

首先我们需要下载 Android Studio 2.3。在这之前的可视化编辑器做的不够好，而且在 Design 标签栏里还有一些问题。所以一定要下载 2.3 beta 版。

创建新工程

[![Create a new project.](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.39.45-AM-300x152.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.39.45-AM.png)

[![New proejct](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.44.51-AM-300x180.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.44.51-AM.png)

[![screen-shot-2017-01-07-at-9-45-10-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.10-AM-300x188.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.10-AM.png)

[![screen-shot-2017-01-07-at-9-45-29-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.29-AM-300x173.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.29-AM.png)

现在，我们的工程已经准备好了。因为我选了 No Activity，所以在工程里没有 Java 和 XML 布局文件。如下所示。

[![screen-shot-2017-01-07-at-9-53-17-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.53.17-AM-300x267.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.53.17-AM.png)

我们将主要围绕布局文件来构建这篇文章。

**1. 从 RelativeLayout 到 ConstraintLayout：**

现在我会创建第一个 RelativeLayout，之后我们将把它转化成 ConstraintLayout。

[![screen-shot-2017-01-07-at-10-11-05-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.11.05-AM-1024x437.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.11.05-AM.png)

从上图我们可以看到这是一个 Android 最常见的列表设计样式。我会在下面向你展示我是如何通过 XML 实现的。现在只简单的关注图片上一眼就可以看到的箭头。从这些箭头可以看出来我们是怎样用 RelativeLayout 的标签来实现位置关系的。

比如标题 TextView 就是 android:layout_toRightOf ImageView 的。

作为一个用户我有这些需求

1. 我想要一个贴靠屏幕左侧并且宽高比为 4:3 的 ImageView。

2. 我想要一个单行标题，它应该在图片的右边。

3. 我想要一个描述，在图片右边标题下边，最多两行。

4. 我想要一个按钮，在图片下边并且和描述左对齐

我写了下面这样的 XML，重要的标签会**加粗**显示。

    <?xml version="1.0" encoding="utf-8"?>
    <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:padding="16dp">
    
        <!-- 4:3 ratio -->
        <ImageView
            android:id="@+id/listingImageView"
            android:layout_width="96dp"
            android:layout_height="72dp"
            android:scaleType="centerCrop"
            android:src="@drawable/image" />
    
        <TextView
            android:id="@+id/titleTextView"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginBottom="5dp"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_toRightOf="@id/listingImageView"
            android:lines="1"
            android:text="Hey I am title"
            android:textSize="20sp"
    
            android:textStyle="bold" />
    
        <TextView
            android:id="@+id/descriptionTextView"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_below="@id/titleTextView"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_toRightOf="@id/listingImageView"
            android:ellipsize="end"
            android:lines="2"
            android:text="Hey I am description. Yes I am description. Believe on me I am description."
            android:textSize="16sp"
            />
    
        <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_alignLeft="@id/descriptionTextView"
            android:layout_below="@id/listingImageView"
            android:text="What! Button, Why " />
    
    </RelativeLayout>

现在我想每个人都可以很轻松地知道我是如何实现这个 UI 的了。为了更突出一点，我将 UI 中重要的标签单独拿出来了。

    ImageView       android:id="@+id/listingImageView"

    TextView        android:id="@+id/titleTextView"
                    android:layout_toRightOf="@id/listingImageView"
    
    TextView        android:id="@+id/descriptionTextView"
                    android:layout_below="@id/titleTextView"
                    android:layout_toRightOf="@id/listingImageView"
    
    Button          android:layout_alignLeft="@id/descriptionTextView"
                    android:layout_below="@id/listingImageView"

现在是时候把这个布局转换成 ConstraintLayout 了。首先我们需要在 gradle 文件里增加依赖并同步。

     compile 'com.android.support.constraint:constraint-layout:1.0.0-beta4'

如下图示，现在我们的 UI 已经是 ConstraintLayout 了。

[![screen-shot-2017-01-07-at-10-49-16-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.16-AM-1024x568.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.16-AM.png)

这和 RelativeLayout 的效果是百分百相同的。你可能要问了。为什么我没有在这张图里显示箭头。那是因为我不想搅乱你的思绪。我马上就会向你展示带箭头的图像，但是你得保证不只关注下面这张图，开始阅读和享受吧。

[![screen-shot-2017-01-07-at-10-49-47-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.47-AM-1024x632.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.47-AM.png)

哈哈，再说一件事。当我学习到这个阶段时，我不依赖可视化编辑器创建了这个 UI，但是当我打开可视化编辑器了，我对自己做到的事感到惊讶。所以在学习了 XML 之后，我可以在几分钟之内通过可视化编辑器完成同样的事了。现在是时候从 XML 开始学习了。重要的标签已经被**加粗**显示。

    <?xml version="1.0" encoding="utf-8"?>
    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent">
        <!-- 4:3 ratio -->
    
        <ImageView
            android:id="@+id/listingImageView"
            android:layout_width="96dp"
            android:layout_height="72dp"
            android:layout_marginLeft="16dp"
            android:layout_marginStart="16dp"
            android:layout_marginTop="16dp"
            android:scaleType="centerCrop"
            android:src="@drawable/image"
            app:layout_constraintLeft_toLeftOf="parent"
            app:layout_constraintTop_toTopOf="parent" />
    
        <TextView
            android:id="@+id/titleTextView"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_marginBottom="5dp"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_marginTop="16dp"
            android:lines="1"
            android:text="Hey I am title"
            android:textSize="20sp"
            android:textStyle="bold"
            app:layout_constraintLeft_toRightOf="@+id/listingImageView"
            app:layout_constraintRight_toRightOf="parent"
            app:layout_constraintTop_toTopOf="parent" />
    
        <TextView
            android:id="@+id/descriptionTextView"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_marginTop="0dp"
            android:ellipsize="end"
            android:lines="2"
            android:text="Hey I am description. Yes I am description. Believe on me I am description."
            android:textSize="16sp"
            app:layout_constraintLeft_toRightOf="@+id/listingImageView"
            app:layout_constraintRight_toRightOf="parent"
            app:layout_constraintTop_toBottomOf="@+id/titleTextView" />


        <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginLeft="0dp"
            android:layout_marginStart="0dp"
            android:layout_marginTop="0dp"
            android:text="What! Button, Why "
            app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView"
            app:layout_constraintTop_toBottomOf="@+id/listingImageView" />
    
    </android.support.constraint.ConstraintLayout>

在了解更多细节之前，我要告诉你一个关于 ConstraintLayout 的秘密武器：如何阅读XML。

就像在 RelativeLayout 中，当我们使用 **android:layout_toRightOf="@id/abc"** 就代表着当前的视图在源视图的右边。这意味着编辑器自动地识别出了我们指的是当前的视图。我不需要额外的声明我操作的是哪个视图，只需要通过 id 引用其它视图就好了。

但在 ConstraintLayout 中，我需要同时指出当前的组件和别的组件。这是 ConstraintLayout 的一个特点。就像下面的例子一样。(**只需要关注标签名，暂时别去想它是干嘛的**)


    app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView

如果你看了就知道我指的是 "layout_constraintLeft_toLeftOf"。

我对这个组件说，嗨，把你的的左边缘和有这个 id 的组件的左边对齐。简单，现在回到正题吧。

为了简单考虑，我还是将我们需要的标签单独拿出来讨论。


    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent">
        <!-- 4:3 ratio -->
    
    ImageView       android:id="@+id/listingImageView"
                    app:layout_constraintLeft_toLeftOf="parent"
                    app:layout_constraintTop_toTopOf="parent" />
    
    TextView        android:id="@+id/titleTextView"
                    android:layout_width="0dp"
                    app:layout_constraintLeft_toRightOf="@+id/listingImageView"
                    app:layout_constraintRight_toRightOf="parent"
                    app:layout_constraintTop_toTopOf="parent" />
    
    TextView        android:id="@+id/descriptionTextView"
                    android:layout_width="0dp"
                    app:layout_constraintLeft_toRightOf="@+id/listingImageView"
                    app:layout_constraintRight_toRightOf="parent"
                    app:layout_constraintTop_toBottomOf="@+id/titleTextView" />
    
    Button          app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView"
                    app:layout_constraintTop_toBottomOf="@+id/listingImageView" />


现在我们就只讨论描述文字。把之前提到的 ConstraintLayout 的特点记在脑子里，你需要先提当前视图，然后才轮到其它视图。。

**android:id=”@+id/titleTextView”:**

我想这够简单，不需要解释。

**android:layout_width=”0dp”:**

宽 0dp 说明宽应当被别的约束控制，你会在下面看到它。

**app:layout_constraintLeft_toRightOf=”@+id/listingImageView”:**

在这里我指定了渲染的顺序。嗨，把我(当前的 TextView)的左边缘放在 ImageView(@+id/listingImageView) 的右边。欢呼吧，现在我们已经知道该如何使用这个布局。只要你掌握了阅读的方法就是很简单的。

**app:layout_constraintRight_toRightOf=”parent”:**

在这里我指定了渲染的顺序。嗨，让我(当前的 TextView)的右边缘和父组件的右边对齐。现在，我的宽度就是从 ImageView 的右边到父组件右边这么多了。这就是为什么我们将宽度设为 0dp。

**着重注意：**

这里没有 match_parent 属性，就算你用了也没用。你必须使用 parent 属性。你肯定要问为什么了，可是我也不知道。但是我觉得使用 parent 会让你在阅读 XML 更明确。


**app:layout_constraintTop_toTopOf=”parent”:**

在这里我指定了渲染的顺序。嗨，把我(当前的 TextView)的上边缘和父组件的上边缘对齐。这样我就始终在上面了。

现在大家最重要的事就是去练习练习了。我花费了大量的时间去学习这个布局，但希望你能节省点时间。

现在我想向你展示完成时的可视化编辑器显示的样子。

[![screen-shot-2017-01-07-at-11-24-22-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-11.24.22-AM-1024x798.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-11.24.22-AM.png)

现在你可以暂停一下了。尝试去实现同样的例子。当你完成适应了这个布局就可以尝试我下面提到的这些标签了。

    app:layout_constraintTop_toTopOf="@id/view"
    app:layout_constraintTop_toBottomOf="@id/view"
    app:layout_constraintRight_toLeftOf="@id/view"
    app:layout_constraintRight_toRightOf="@id/view"
    app:layout_constraintBottom_toBottomOf="@id/view"
    app:layout_constraintBottom_toTopOf="@id/view"
    app:layout_constraintLeft_toLeftOf="@id/view"
    app:layout_constraintLeft_toRightOf="@id/view"
    app:layout_constraintStart_toStartOf="@id/view"
    app:layout_constraintStart_toEndOf="@id/view"
    app:layout_constraintEnd_toStartOf="@id/view"
    app:layout_constraintEnd_toEndOf="@id/view"

在试过之后。找一个合适的时间，我们将会在下一篇文章中说一些 ConstraintLayout 的新知识。掌握了这些标签后学点新东西也就不是什么难事了。

那么大家，是时候说再见了。让我们在下一篇文章中再会。

[**Constraint Layout Concepts ( What the hell is this )[ (Tips and Tricks) Part 2 ]**](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)
