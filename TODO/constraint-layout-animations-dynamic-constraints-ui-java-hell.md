> * 原文地址：[Constraint Layout [Animations | Dynamic Constraints | UI by Java] ( What the hell is this )[Part3]](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：[tanglie1993](https://github.com/tanglie1993),[yazhi1992](https://github.com/yazhi1992)

# Constraint Layout 动画 |动态 Constraint |用 Java 实现的 UI（这到底是什么）[第三部分]


喔，又是新的一天，是时候学些新东西来让今天变得精彩起来了。


各位读者朋友你们好，希望各位一切顺利。我们之前已经在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md)和 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)
中学习了许多关于 Constraint Layout 的新东西。现在是时候学习这个令人惊讶的布局剩下的部分了。这一篇很有可能是关于 Constraint Layout系列的最后一篇文章了。


**动机：**

写这篇文章的动机和在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md)讨论的是一样的。现在在这篇文章里我主要谈论的是关于 Constraint Layout 的动画。关于这个主题有一个坏消息，那就是 Android 的开发文档并没有提供足够的帮助。在开始这篇文章之前我想先道个歉，由于知识的欠缺我可能会在某些地方出现错误的观点。但是我可以 100% 的保证通过我的讲述，最终你会喜欢并且适应这些动画。

我对这个主题的命名有些犹豫，所以我决定使用三个名字组成的题目，《Constraint Layout 动画 |动态 Constraint |用 Java 实现的 UI》。在这篇文章的最后，你会了解到为什么我选择这三个名字。



现在我不打算讲解 Constraint Layout 动画 API 带来的新特点，而是准备和你们分享我在实现动画效果时遇到的一些问题。那么让我们开始吧。



我们需要下载 2.3 版本的 Android studio。在之前的版本里 Visual Editor 不太好，在 Design Tab 里经常会出现一些错误信息。所以下载  2.3 测试版的 Android studio 非常重要，这个版本在我写这篇文章的时候是可以下载到的。
 

**介绍:**




在这篇文章里我们主要使用 Java 语言来工作，但是在开始之前我打算解释下在这篇文章里一切是如何运作的。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM-578x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM.png)



我将基于上面的 APP 来进行这篇文章的论述。我有一个 constraint layout ，这里面总共有五个按钮。



应用和重置按钮除了应用和重置我们的动画之外不做其他事情。另外三个按钮被用来进行我们的动画。我们通过应用不同的动画来使这三个按钮共同协作。最重要的一点，我们在开始之前应该知道这三个按钮的 constraint。

    <?xml version="1.0" encoding="utf-8"?>
        <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
            android:id="@+id/main"
            android:layout_width="match_parent"
            android:layout_height="match_parent">


            <Button
                android:id="@+id/applyButton"
                android:text="Apply"
                ...
                />

            <Button
                android:id="@+id/resetButton"
                android:text="Reset"
                ...
                />

            <Button
                android:id="@+id/button1"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:background="@color/colorAccent"
                android:text="Button 1"
                android:layout_marginLeft="52dp"
                app:layout_constraintLeft_toLeftOf="parent"
                android:layout_marginStart="52dp"
                app:layout_constraintTop_toTopOf="parent"
                android:layout_marginTop="69dp" />

            <Button
                android:id="@+id/button2"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:background="@color/colorPrimaryDark"
                android:text="Button 2"
                app:layout_constraintLeft_toRightOf="@+id/button1"
                android:layout_marginLeft="8dp"
                android:layout_marginStart="8dp"
                android:layout_marginRight="8dp"
                app:layout_constraintRight_toRightOf="parent"
                app:layout_constraintHorizontal_bias="0.571"
                app:layout_constraintTop_toTopOf="parent"
                android:layout_marginTop="136dp" />

            <Button
                android:id="@+id/button3"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:background="@android:color/holo_red_dark"
                android:text="Button 3"
                android:layout_marginTop="102dp"
                app:layout_constraintTop_toBottomOf="@+id/button1"
                android:layout_marginLeft="88dp"
                app:layout_constraintLeft_toLeftOf="parent"
                android:layout_marginStart="88dp" />

        </android.support.constraint.ConstraintLayout>


在你检查这段代码之后你可以轻松地了解这三个按钮之间的关系，下面这张图会给你一个更直观的认识。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM-763x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM.png)



哈哈，我知道把这张图与 XML 文件对照来看很容易理解。现在你了解了这三个按钮互相之间的关系以及与父控件的关系。
在深入的发掘之前我想再介绍一个新的 API。

    public class MainActivity extends AppCompatActivity {

        private ConstraintLayout constraintLayout;
        private ConstraintSet applyConstraintSet = new ConstraintSet();
        private ConstraintSet resetConstraintSet = new ConstraintSet();

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);
            constraintLayout = (ConstraintLayout) findViewById(R.id.main);
            resetConstraintSet.clone(constraintLayout);
            applyConstraintSet.clone(constraintLayout);
        }

        public void onApplyClick(View view) {

        }

        public void onResetClick(View view) {

        }



留意粗体字，这些代码很简单。 ConstraintSet 就是我们要在这个教程中经常用到的一个 API。简单来说，你可以这样理解，这个 API 将记住我们在 XML 文件里实现的所有的 constraints。怎样使用呢？就像你看到的，在上面的代码里我拥有了一个 **constarintLayout** 引用，在那之后，我将把它的 constraints 复制到我们的两个变量 **resetConstraintSet** 和 **applyConstraintSet** 中。非常的简单。 



现在为了适应新的要求，我将改变我的写作风格。


我将为同样的要求使用不同的语句，这样你可以轻易的理解我这篇文章的标题。



**新需求:**

我想要让按钮 1 动起来，当用户点击启动按钮的时候，让它与父控件的左边对齐。你能帮我一下么？
用开发语言来说：

兄弟，我想要在 constraint layout 里使用 Java 代码让按钮 1 在用户点击启动按钮的时候与父控件的左边对齐。你可以帮我一下么。



**解决方案:**

    public void onApplyClick(View view) {
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

    public void onResetClick(View view) {
        resetConstraintSet.applyTo(constraintLayout);
    }
 
从现在开始我只向你展示 onApplyClick() 方法，其他的代码始终是不变的。如果你看见了 onResetClick()方法，噢，请你忘掉它。我会一直使用最初时的 constraints 来返回到最开始的 UI 界面




现在有两个新的 API 方法。setMargin() 和 applyTo()，我感觉没有必要去解释 applyTo() 方法。
 

SetMargin() 方法将使用三个参数(viewId, anchor, margin)。



按钮 1 有 52dp 的左边距，但是当用户点击之后我会把间距改变到 8px。是时候看下这个过程了。 


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)



除了猛地一跳，没有按钮移动的轨迹，这看起来并不像动画。所以我们需要重新检查下我们的代码。在检查之后我发现需要在 applyButton() 方法里再加点东西。在增加了之后，得到动画效果如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)



好了。是时候审视下新代码的变化了。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }



    
这里我需要添加 TransitionManager API。从一个 support library 里面能够获取到 TransistionManager API。你可以添加 gradle 依赖。

    compile 'com.android.support:transition:25.1.0'
 
 

在进行下一步的操作之前。我想要复习下现在的操作。

简单来说我们只使用了两个 API。ConstraintSet 和 TransitionManager。从现在起我们将只使用 ConstraintSet API。


**新需求:**



用户语言：

当用户点击应用按钮的时候，我想要让所有的按钮动起来并在父容器里水平居中。



开发者语言：

兄弟我想要当用户点击应用按钮的时候通过使用 Java 代码让所有的按钮在 constraint layout 里移动到水平居中的位置。你能帮我一下么？

**解决方案:**

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.centerHorizontally(R.id.button1, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button2, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button3, R.id.main);
        applyConstraintSet.applyTo(constraintLayout);
    }



这里我使用 centerHorizontally() 方法。这个方法需要两个参数:

第一个：我想要进行水平居中操作的 View。
第二个：父容器 View。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)




它并没有像我们预期的那样工作。在分析之后我发现了问题。我们给这些按钮设置了不同的外边距，这导致了我们点击应用按钮时他们将移动到中心，但是由于外边距的设定，它们最终的位置出现了偏移。是时候解决这个问题了。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,0);
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.END,0);
        applyConstraintSet.setMargin(R.id.button2,ConstraintSet.START,0);
        applyConstraintSet.setMargin(R.id.button2,ConstraintSet.END,0);
        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.START,0);
        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.END,0);


        applyConstraintSet.centerHorizontally(R.id.button1, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button2, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button3, R.id.main);
        applyConstraintSet.applyTo(constraintLayout);
    }


这里我把所有按钮的左右外边距都设置为 0。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)

**新需求:**



用户的语言：
当用户点击应用按钮的时候，我想让按钮 3 动起来，然后移动到正中心。


开发者的语言：

当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让按钮 3 移动到父控件的中心。你能帮我一下么？

**解决方案:**

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.START,0);
        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.END,0);
        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.TOP,0);
        applyConstraintSet.setMargin(R.id.button3,ConstraintSet.BOTTOM,0);

        applyConstraintSet.centerHorizontally(R.id.button3, R.id.main);
        applyConstraintSet.centerVertically(R.id.button3, R.id.main);

        applyConstraintSet.applyTo(constraintLayout);
    }



我在这里先为四个边缘设定为 0 像素的外边距，然后我使用 centerHorizontal + centerVertical 方法。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)




**新需求:**


用户语言：
当用户点击应用按钮的时候，我想要让所有的按钮的宽度都变化成 600 像素。


开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让所有按钮的宽度尺寸都变成 600 像素。你能帮我一下么？



**解决方案:**

        public void onApplyClick(View view) {
            TransitionManager.beginDelayedTransition(constraintLayout);

            applyConstraintSet.constrainWidth(R.id.button1,600);
            applyConstraintSet.constrainWidth(R.id.button2,600);
            applyConstraintSet.constrainWidth(R.id.button3,600);

            // applyConstraintSet.constrainHeight(R.id.button1,100);
            // applyConstraintSet.constrainHeight(R.id.button2,100);
            // applyConstraintSet.constrainHeight(R.id.button3,100);

            applyConstraintSet.applyTo(constraintLayout);

        }


上面展示的是我使用的 constraintWidth 方法。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)

**新需求:**



用户语言：

当用户点击应用按钮的时候，我想要让按钮1的宽度和高度充满整个屏幕并且让其他的视图隐藏。




开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让按钮1的宽度和高度都 match_parent， 并且让其他的视图 gone，你能帮我一下么？

**解决方案:**

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.setVisibility(R.id.button2,ConstraintSet.GONE);
        applyConstraintSet.setVisibility(R.id.button3,ConstraintSet.GONE);
        applyConstraintSet.clear(R.id.button1);
        applyConstraintSet.connect(R.id.button1,ConstraintSet.LEFT,R.id.main,ConstraintSet.LEFT,0);
        applyConstraintSet.connect(R.id.button1,ConstraintSet.RIGHT,R.id.main,ConstraintSet.RIGHT,0);
        applyConstraintSet.connect(R.id.button1,ConstraintSet.TOP,R.id.main,ConstraintSet.TOP,0);
        applyConstraintSet.connect(R.id.button1,ConstraintSet.BOTTOM,R.id.main,ConstraintSet.BOTTOM,0);
        applyConstraintSet.applyTo(constraintLayout);
    }



我在上面用了一些新方法，在这里我来解释一下：

setVisibility:我觉得这个很简单。

clear: 我想要把 view 上的所有 constraint 都清除掉。

connect: 我想要 view 上添加 constraint。这个方法需要5个参数。

第一个:我想要在上面添加 constraint 的 view。

第二个：我准备添加的 constraint 的边缘状态。

第三个：constraint 的第一个 view，它被用来作为我的锚点。

第四个：我的锚点 view 的边缘状态。

第五：外边距。



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-12-11-25.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-12-11-25.gif)


是时候开始进一步的操作了。在[教程2](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)里我们已经了解到了 Chaining 的概念了。我将向你们展示如何使用 Java 语言来实现它。 

**新需求:**



用户语言：
当用户点击应用按钮的时候，我想要让所有的按钮都与屏幕的顶端对齐并且水平居中。


开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码来实现这三个按钮的 packed chaining 逻辑。你能帮我一下么？

**解决方案:**




我接下来要讲述的东西会有点超前，但我会把它当成没什么了不起的东西来解释。所以各位准备好。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.clear(R.id.button1);
        applyConstraintSet.clear(R.id.button2);
        applyConstraintSet.clear(R.id.button3);



首先我把三个按钮上的所有 constraint 都清除了。这是我个人的偏好，你可以只去掉按钮的外边距或者尺寸，其他方式也可以，但是我觉得这是最容易实现的方案。现在我们的按钮没有任何的 constraint。（0 width, 0 height, 0 margin …）。

    // button 1 left and top align to parent
    applyConstraintSet.connect(R.id.button1, ConstraintSet.LEFT, R.id.main, ConstraintSet.LEFT, 0);


如上面展示的，现在我给按钮 1 添加上左边的 constraint。

    // button 3 right and top align to parent
    applyConstraintSet.connect(R.id.button3, ConstraintSet.RIGHT, R.id.main, ConstraintSet.RIGHT, 0);


如上面展示的，现在我给按钮 3 添加上右边的 constraint。


现在在你的脑海里勾勒出这些代码形成的草图，我们的按钮 1 在父控件的左上角，按钮 2 也一样，不过相对靠右。

    // bi-direction or Chaining between button 1 and button 2
    applyConstraintSet.connect(R.id.button2, ConstraintSet.LEFT, R.id.button1, ConstraintSet.RIGHT, 0);
    applyConstraintSet.connect(R.id.button1, ConstraintSet.RIGHT, R.id.button2, ConstraintSet.LEFT, 0);


如上所示，我在这里创建了按钮 1 和按钮 2 的双向关系。

    // bi-direction or Chaining between button 2 and button 3
    applyConstraintSet.connect(R.id.button2, ConstraintSet.RIGHT, R.id.button3, ConstraintSet.LEFT, 0);
    applyConstraintSet.connect(R.id.button3, ConstraintSet.LEFT, R.id.button2, ConstraintSet.RIGHT, 0);


如上所示，我在这里创建了按钮 2 和按钮 3 的双向关系。


    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3},
            null, ConstraintWidget.CHAIN_PACKED);




这个方法为我们创建了一个水平的 chain。这个方法需要5个参数。

第一个：头部 view 的 id。
第二个：chain 里尾部 view 的 id。
第三个：int 数组，把头部和尾部 view 的 id 放入 int 数组。
第四个：float 数组，如果我们需要权重的 chaining 的话它可以给我们权重，否则的话为空。
第五个：chaining 的风格，类似 CHAIN_SPREAD。


现在如果我运行一下，我会得到下面的结果。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)

这不是我们需要的动作。如果你们还记得我清除了这些按钮的 constraint，这就是为什么这里的宽度和高度都为 0 的原因.如下所示，我需要给它们的宽度和高度赋值。

    applyConstraintSet.constrainWidth(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button3,ConstraintSet.WRAP_CONTENT);

    applyConstraintSet.constrainHeight(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button3,ConstraintSet.WRAP_CONTENT);


现在再运行一次。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)


效果不错，是时候向你们展示整段代码了。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.clear(R.id.button1);
        applyConstraintSet.clear(R.id.button2);
        applyConstraintSet.clear(R.id.button3);

        // button 1 left and top align to parent
        applyConstraintSet.connect(R.id.button1, ConstraintSet.LEFT, R.id.main, ConstraintSet.LEFT, 0);

        // button 3 right and top align to parent
        applyConstraintSet.connect(R.id.button3, ConstraintSet.RIGHT, R.id.main, ConstraintSet.RIGHT, 0);

        // bi-direction or Chaining between button 1 and button 2
        applyConstraintSet.connect(R.id.button2, ConstraintSet.LEFT, R.id.button1, ConstraintSet.RIGHT, 0);
        applyConstraintSet.connect(R.id.button1, ConstraintSet.RIGHT, R.id.button2, ConstraintSet.LEFT, 0);

        // bi-direction or Chaining between button 2 and button 3
        applyConstraintSet.connect(R.id.button2, ConstraintSet.RIGHT, R.id.button3, ConstraintSet.LEFT, 0);
        applyConstraintSet.connect(R.id.button3, ConstraintSet.LEFT, R.id.button2, ConstraintSet.RIGHT, 0);

        applyConstraintSet.createHorizontalChain(R.id.button1,
                R.id.button3,
                new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_PACKED);

        applyConstraintSet.constrainWidth(R.id.button1,ConstraintSet.WRAP_CONTENT);
        applyConstraintSet.constrainWidth(R.id.button2,ConstraintSet.WRAP_CONTENT);
        applyConstraintSet.constrainWidth(R.id.button3,ConstraintSet.WRAP_CONTENT);

        applyConstraintSet.constrainHeight(R.id.button1,ConstraintSet.WRAP_CONTENT);
        applyConstraintSet.constrainHeight(R.id.button2,ConstraintSet.WRAP_CONTENT);
        applyConstraintSet.constrainHeight(R.id.button3,ConstraintSet.WRAP_CONTENT);

        applyConstraintSet.applyTo(constraintLayout);
    }


现在改变 chain 风格。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)


现在改变 chain 风格。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD_INSIDE);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)

现在我将向你们展示带有偏差值的 CHAIN_PACKED。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_PACKED);

    applyConstraintSet.setHorizontalBias(R.id.button1, .1f);


如上所示，我使用了一个新方法 setHorizontalBias()，在这个方法里我填入了我们 chain 组的头部和 float 类型的偏差值。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)

**奖励**:


我将向你们展示 ConstraintSet 的另一个用法，这个用法在 Android API 文档里有提及到。所以如下所示，首先我们先在同一个 ConstraintLayout 里应用两个不同的 ConstraintSet。

    public class MainActivity extends AppCompatActivity {

        private ConstraintLayout constraintLayout;
        private ConstraintSet constraintSet1 = new ConstraintSet();
        private ConstraintSet constraintSet2 = new ConstraintSet();

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);
            constraintLayout = (ConstraintLayout) findViewById(R.id.main);
            constraintSet1.clone(constraintLayout);
            constraintSet2.clone(this, R.layout.activity_main2);
        }

        public void onApplyClick(View view) {
            TransitionManager.beginDelayedTransition(constraintLayout);
            constraintSet2.applyTo(constraintLayout);
        }

        public void onResetClick(View view) {
            TransitionManager.beginDelayedTransition(constraintLayout);
            constraintSet1.applyTo(constraintLayout);
        }
    }



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-35-55.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-35-55.gif)

**activity_main 布局的 XML 文件:**

    <?xml version="1.0" encoding="utf-8"?>
    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        xmlns:tools="http://schemas.android.com/tools"
        android:id="@+id/main"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        tools:context="com.constraintanimation.MainActivity">


        <Button
            android:onClick="onApplyClick"
            app:layout_constraintHorizontal_weight="1"
            android:id="@+id/applyButton"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Apply"
            android:layout_marginLeft="16dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="16dp"
            app:layout_constraintBottom_toBottomOf="parent"
            android:layout_marginBottom="16dp"
            app:layout_constraintRight_toLeftOf="@+id/resetButton"
            android:layout_marginRight="8dp"
            android:layout_marginEnd="8dp" />

        <Button
            android:onClick="onResetClick"
            app:layout_constraintHorizontal_weight="1"
            android:id="@+id/resetButton"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Reset"
            app:layout_constraintBottom_toBottomOf="parent"
            android:layout_marginBottom="16dp"
            app:layout_constraintLeft_toRightOf="@+id/applyButton"
            android:layout_marginLeft="8dp"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginStart="8dp"
            android:layout_marginEnd="8dp"

            />

        <ImageView
            android:id="@+id/imageView"
            android:layout_width="92dp"
            android:layout_height="92dp"
            app:srcCompat="@mipmap/ic_launcher"
            android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent"
            android:layout_marginLeft="8dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="8dp"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            app:layout_constraintHorizontal_bias="0.02"
            android:layout_marginEnd="8dp" />

        <TextView
            android:id="@+id/textView"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Hello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\n"
            android:layout_marginRight="8dp"
            android:lines="6"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginEnd="8dp"
            app:layout_constraintLeft_toRightOf="@+id/imageView"
            android:layout_marginLeft="8dp"
            android:layout_marginStart="8dp"
            app:layout_constraintHorizontal_bias="0.0"
            app:layout_constraintTop_toTopOf="parent"
            android:layout_marginTop="16dp" />

        <CheckBox
            android:id="@+id/checkBox"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="CheckBox"
            android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent"
            android:layout_marginLeft="16dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="16dp"
            app:layout_constraintRight_toLeftOf="@+id/textView"
            android:layout_marginRight="8dp"
            app:layout_constraintHorizontal_bias="1.0"
            android:layout_marginEnd="8dp" />

        <Button
            android:id="@+id/button"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Button"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginEnd="8dp"
            android:layout_marginLeft="8dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="8dp"
            android:layout_marginTop="8dp"
            app:layout_constraintTop_toBottomOf="@+id/textView" />

    </android.support.constraint.ConstraintLayout>

**activty_main2 布局的 XML 文件:**

    <?xml version="1.0" encoding="utf-8"?>
    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        xmlns:tools="http://schemas.android.com/tools"
        android:id="@+id/main"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        tools:context="com.constraintanimation.MainActivity">


        <Button
            android:onClick="onApplyClick"
            app:layout_constraintHorizontal_weight="1"
            android:id="@+id/applyButton"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Apply"
            android:layout_marginLeft="16dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="16dp"
            app:layout_constraintBottom_toBottomOf="parent"
            android:layout_marginBottom="16dp"
            app:layout_constraintRight_toLeftOf="@+id/resetButton"
            android:layout_marginRight="8dp"
            android:layout_marginEnd="8dp" />

        <Button
            android:onClick="onResetClick"
            app:layout_constraintHorizontal_weight="1"
            android:id="@+id/resetButton"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:text="Reset"
            app:layout_constraintBottom_toBottomOf="parent"
            android:layout_marginBottom="16dp"
            app:layout_constraintLeft_toRightOf="@+id/applyButton"
            android:layout_marginLeft="8dp"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginStart="8dp"
            android:layout_marginEnd="8dp"

            />

        <ImageView
            android:id="@+id/imageView"
            android:layout_width="353dp"
            android:layout_height="157dp"
            app:srcCompat="@mipmap/ic_launcher"
            android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginEnd="8dp"
            android:layout_marginLeft="8dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="8dp" />

        <TextView
            android:id="@+id/textView"
            android:layout_width="352dp"
            android:layout_height="108dp"
            android:text="Hello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\nHello this is a simple demo. Thanks for reading and learning new things.\n"
            android:lines="6"
            android:layout_marginTop="12dp"
            app:layout_constraintTop_toBottomOf="@+id/imageView"
            android:layout_marginRight="8dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginLeft="8dp"
            app:layout_constraintLeft_toLeftOf="parent"
            android:layout_marginStart="8dp"
            android:layout_marginEnd="8dp" />

        <CheckBox
            android:id="@+id/checkBox"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="CheckBox"
            android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent"
            android:layout_marginRight="16dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginEnd="16dp" />

        <Button
            android:id="@+id/button"
            android:layout_width="0dp"
            android:layout_height="0dp"
            android:text="Button"
            android:layout_marginRight="16dp"
            app:layout_constraintRight_toRightOf="parent"
            android:layout_marginEnd="16dp"
            android:layout_marginLeft="8dp"
            app:layout_constraintLeft_toLeftOf="parent"
            app:layout_constraintHorizontal_bias="0.0"
            android:layout_marginStart="8dp"
            android:layout_marginTop="8dp"
            app:layout_constraintTop_toBottomOf="@+id/textView"
            android:layout_marginBottom="8dp"
            app:layout_constraintBottom_toTopOf="@+id/applyButton" />

    </android.support.constraint.ConstraintLayout>


哇哦，我们已经完成了 ConstraitLayout 动画。剩下的最后一个主题是 [ConstraintLayout 可视化[Design]编辑器 （这到底是什么）[第四部分]](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-visual-design-editor-hell.md)


好的各位，是时候说再见了，希望你们都有一个很棒的周末。
