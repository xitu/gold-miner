> * 原文地址：[Constraint Layout [Animations | Dynamic Constraints | UI by Java] ( What the hell is this )[Part3]](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：

# Constraint Layout Animations | Dynamic Constraints | UI by Java[Part3]
# Constraint Layout 动画 |动态 Constraint |用 Java 实现的 UI[Part3]


WOW, we got one more day so its time to make this day awesome by learning something new 🙂 .

喔，又是新的一天，是时候学些新东西来让今天变得精彩起来了。

Hello guys, hope every body is doing good. We already learned a lot of new things about Constraint Layout in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/) and [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/). Now Its time to start learning about remaining things of this awesome layout. Most probably this is the final post about Constraint Layout.

各位读者朋友你们好，希望各位一切顺利。我们之前已经在[第一部分](http://www.uwanttolearn.com/android/constraint-layout-hell/)和 [第二部分](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)
中学习了许多关于 Constraint Layout 的新东西。

**Motivation:**

Motivation is same as discus with you guys in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/). Now in this post my main focus is animations on Constraint Layout. One bad news there is not enough help on this topic in android docs. I want to apologise before starting this post may be I am wrong on some places in the perspective of concept due to lack of knowledge but I am giving you 100% surety in the end you will enjoy and comfortable with animations according to my concepts 🙂 .

**动机：**

写这篇文章的动机和在[第一部分](http://www.uwanttolearn.com/android/constraint-layout-hell/)讨论的是一样的。现在在这篇投稿里我主要谈论的是关于 Constraint Layout 的动画。关于这个主题有一个坏消息，那就是 android 的开发文档并没有提供足够的帮助。在开始这篇文章之前我想先道个歉，由于知识的欠缺我可能会在某些地方出现错误的观点。但是我可以 100% 的保证通过我的讲述，最终你会喜欢并且适应这些动画。

I am confuse for the name of this topic. So I decided I will go with three names, Constraint Layout Animations, Constraint Layout Dynamic Constraints and Constraint Layout UI by Java. In the end of this post, you will know why I choose three names.

我对这个主题的命名有些犹豫，所以我决定使用三个名字组成的题目，《Constraint Layout Animations, Constraint Layout Dynamic Constraints and Constraint Layout UI by Java》。在这篇文章的最后，你会了解到为什么我选择这三个名字。

Now this time I am not going to explain what features are given by Constraint Layout animations API instead I will share with you issues which may be you will face when implementing. So its time to **ATTACK** :).

现在我不打算讲解 Constraint Layout 动画 API 带来的新特点，替代的我将和你们分享我在实现动画效果遇到的一些问题。所以是时候开始我们的文章了。

We need to download 2.3 Android studio. In previous versions Visual Editor is not good and that show some wrong info on Design Tab. So that is really important download 2.3 beta which is available when I am writing this post.

我们需要下载 2.3 版本的 Android studio。在之前的版本里 Visual Editor 不太好，在 Design Tab 里经常会出现一些错误信息。所以下载  2.3 测试版的 Android studio 非常重要，这个版本在我写这篇文章的时候是可以下载到的。
 
**Introduction:**

**介绍:**


In this post we are mostly working with Java but before starting I am going to explain how everything will work in this post.

在这篇文章里我们主要使用 Java 语言来工作，但是在开始之前我打算解释下在这篇文章里一切是如何运作的。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM-578x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM.png)

For this post I am going to use above app. I have a one constraint layout in which I have total five buttons.

我将基于上面的 APP 来进行这篇文章的论述。我有一个 constraint layout ，这里面总共有五个按钮。

Apply and Reset buttons are doing nothing except they will apply or reset our animations. Other three buttons are used for our animations. We are playing with these three buttons by applying different animations. Most important point, we should know constraints of these three buttons before start.

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

So after examine the code you can easily see the relationship of these three buttons but for our ease see below image.

在你检查这段代码之后你可以轻松的了解这三个按钮之间的关系，看下面这张图会给你一个更直观的认识。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM-763x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM.png)

Haha I know that is simple in comparison with XML. Now you know about these three buttons relationship with each other and with parent. BOOOOM

Also I want to explain one more new API before deep diving.

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

Focus on bold lines, all other code is simple. So ConstraintSet is an API which we are using a lot in this tutorial. In simple words you can think like this API will remember all the constraints which we implement in XML. How? as you saw, I have a **constarintLayout** reference  in above code after that I am doing clone its constraints in our two fields **resetConstraintSet** and **applyConstraintSet**. Very easy.

留意粗体字，这些代码很简单。 ConstraintSet 就是我们要在这个教程中经常用到的一个 API。简单来说，你可以这样理解，这个 API 将记住我们在 XML 文件里实现的所有的 constraints。这样使用呢？就像你看到的，在上面的代码里我拥有了一个 **constarintLayout** 引用，在那之后，我将把它的 constraints 复制到我们的两个变量 **resetConstraintSet** 和 **applyConstraintSet** 中。非常的简单。 


Now from this point I am going to change my writing style for new requirements.  Confused…….

现在为了适应新的要求，我将改变我的写作风格。

I will use different sentences for same requirement, so you can easily understand my title of a post.

我将为同样的要求使用不同的语句，这样你可以轻易的理解我这篇文章的标题。

**New Requirement:**

I want to animate button 1, align left of a parent when user click apply.

In Developer Language:

Bro I want button 1, align to parent left when user click apply button using Java in constraint layout. Can you help me.

**新需求:**

我想要让按钮 1 动起来，当用户点击启动按钮的时候，让它与父控件的左边对齐。

用开发语言来说：

兄弟，我想要在 constraint layout 里使用 Java 代码让按钮 1 在用户点击启动按钮的时候与父控件的左边对齐。你可以帮我一下么。

**Solution:**

    public void onApplyClick(View view) {
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

    public void onResetClick(View view) {
        resetConstraintSet.applyTo(constraintLayout);
    }

From now I only show you onApplyClick() method, remaining code always same. Oh forgot, if you saw onResetClick(). I am always applying original constraints to go back to my original UI.

**解决方案:**

    public void onApplyClick(View view) {
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

    public void onResetClick(View view) {
        resetConstraintSet.applyTo(constraintLayout);
    }
 
 从现在开始我只向你展示 onApplyClick() 方法，代码始终是不变的。如果你看见了 onResetClick()方法，噢，请你忘掉它。我正在应用最初的 constraint 来返回到我最开始的 UI 界面。



Now there are two new API methods. setMargin() and applyTo(), I feel applyTo() no need to explain.

现在有两个新的 API 方法。setMargin() 和 applyTo()，我感觉没有必要去解释 applyTo() 方法。
 
SetMargin() will take three arguments(viewId, anchor, margin).

SetMargin() 方法将使用三个参数(viewId, anchor, margin)。


Button 1 has 52dp left margin but as user clicked I changed to 8px. Its time to see how it looks.

按钮 1 有 52dp 的左边距，但是当用户点击之后我会把间距改变到 8px。是时候看下这个过程了。 


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)


Oh no button is moving but with jerk, that did not looks like animation. That is bad so we need to review our code again. ———–. After reviewing I figure it out I need to add one more line in applyButton(). After adding that line how it looks as shown below.

除了猛地一跳，没有按钮移动的轨迹，这看起来并不像动画。所以我们需要重新检查下我们的代码。 ———–。在检查之后我发现需要在 applyButton() 方法里再加点东西。在增加了之后，得到动画效果如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)

DONE. Its time to review new code changes.

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

好了。是时候审视下新代码的变化了。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }


Here I need to add TransitionManager API. Guys there is a support library available for TransistionManager API. you can add gradle dependency.

    compile 'com.android.support:transition:25.1.0'
    
这里我需要添加 TransitionManager API 。这是 support library 里的一个 API 。你可以添加 gradle 依赖。

    compile 'com.android.support:transition:25.1.0'
 
 
Before going to next requirement. I want to revise everything.

In simple words we are using only two API’s. ConstraintSet and TransitionManager. From now we are only playing with ConstraintSet API.

在进行下一步的操作之前。我想要复习下现在的操作。

简单来说我们只使用了两个 API。ConstraintSet 和 TransitionManager。从现在起我们将只使用 ConstraintSet API。

**New Requirement:**

**新需求:**

In User Language:

I want to animate all buttons, centre horizontal in parent when user click apply.

用户语言：

当用户点击应用按钮的时候，我想要让所有的按钮动起来并在父容器里水平居中。


In Developer Language:

Bro I want, all buttons move to parent centre horizontal when user click apply button using Java in constraint layout. Can you help me.

开发者语言：

兄弟我想要当用户点击应用按钮的时候通过使用 Java 代码让所有的按钮在 constraint layout 里移动到水平居中的位置。



**Solution:**

**解决方案:**

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.centerHorizontally(R.id.button1, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button2, R.id.main);
        applyConstraintSet.centerHorizontally(R.id.button3, R.id.main);
        applyConstraintSet.applyTo(constraintLayout);
    }

here I used centerHorizontally() method. This method takes two arguments:

First: View which I want to do center horizontal.

Second: to view.

这里我使用 centerHorizontally() 方法。这个方法需要两个参数:

第一个：我想要进行水平居中操作的 View。
第二个：父容器 View。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)


Oh its not working as we want. After analysing I got the issue. We have different margins with these buttons so when we click apply button they are going into center but with taking care of margins. So its time to resolve this issue.

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

Here I did all buttons left and right margins to 0 and done.

这里我把所有按钮的左右外边距都设置为 0。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)

**New Requirement:**
**新需求:**


In User Language:

I want to animate button 3 to centre in parent when user click apply.

用户的语言：
当用户点击应用按钮的时候，我想让按钮 3 动起来，然后移动到正中心。

In Developer Language:

Bro I want button 3, move to parent centre when user click apply button using Java in constraint layout. Can you help me.

开发者的语言：

当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让按钮 3 移动到父控件的中心。你可以帮到我。

**Solution:**
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

So here first I did 0 margin on four sides and after that I used centerHorizontal + centerVertical method.

我在这里先为四个边缘设定为 0 像素的外边距，然后我使用 centerHorizontal + centerVertical 方法。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)




**New Requirement:**
**新需求:**

In User Language:

I want to animate all buttons width from current size to 600px when user click apply.

用户语言：
当用户点击应用按钮的时候，我想要让所有的按钮的宽度都变化成 600 像素。

In Developer Language:

Bro I want, all buttons width size change to 600px when user click apply button using Java in constraint layout. Can you help me.

开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让所有按钮的宽度尺寸都变成 600 像素。你可以帮到我。



**Solution:**
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

Here i used constraintWidth method as shown above.

上面展示的使我使用的 constraintWidth 方法。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)

**New Requirement:**
**新需求:**


In User Language:

I want to animate button1 width and height to whole screen and all other views should hide when user click apply.

用户语言：

当用户点击应用按钮的时候，我想要让按钮1的宽度和高度充满整个屏幕并且让其他的视图隐藏。


In Developer Language:

Bro I want button 1 should be match_parent, matche_parent and all other views should gone when user click apply button using Java in constraint layout. Can you help me.

开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码让按钮1的宽度和高度都 match_parent， 并且让其他的视图 gone，你可以帮到我。

**Solution:**
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

Here I want to explain some new methods which I used above:

setVisibility: I think that is simple.

clear: I want to clear all my constraints on view.

connect:  I want to apply constraint on a view. This method take 5 arguments.

First: View on which I want to apply constraint.

Second:  Side/Edge on which I want to apply constraint.

Third: View which is my anchor point for first view for constraint.

Fourth: Side/Edge of my anchor point view.

Fifth: Margin

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

Its time to start some advance stuff. As we already learned Chaining concept in [tutorial 2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/). I am going to show you how we can implement that by using JAVA. ( In developer language 😛 ) .

是时候开始进一步的操作了。在[教程2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)里我们已经了解到了 Chaining 的概念了。我将向你们展示如何使用 Java 语言来实现它。 

**New Requirement:**
**新需求:**

In User Language:

I want to animate all buttons, align to each other, top of the screen and horizontal center when user click apply button.

用户语言：
当用户点击应用按钮的时候，我想要让所有的按钮都与屏幕的顶端对齐并且水平居中。

In Developer Language:

Bro I want to implement packed chaining on all three  buttons, when user click apply button using Java in constraint layout. Can you help me.

开发者语言：
当用户点击应用按钮的时候，我想要通过在 constraint layout 里使用 Java 代码来实现这三个按钮的 packed chaining 逻辑。

**Solution:**
**解决方案:**


As I am saying that is advance thing in my opinion but I am going to explain like that is nothing. So guys ready.

？我将讲述进一步的操作但我不打算详细解释它。所以各位准备好。

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.clear(R.id.button1);
        applyConstraintSet.clear(R.id.button2);
        applyConstraintSet.clear(R.id.button3);

First I clear all the constraints from all three buttons. That is my personal preference you can do by removing only margin or size of a button or any other way but I feel that is the easiest solution to implement. Now our buttons have no constraints. (0 width, 0 height, 0 margin …).

首先我把三个按钮上的所有 constraint 都清除了。这是我个人的偏好，你可以只去掉按钮的外边距或者尺寸，其他方式也可以，但是我觉得这是最容易实现的方案。现在我们的按钮没有任何的 constraint。（0 width, 0 height, 0 margin …）。

    // button 1 left and top align to parent
    applyConstraintSet.connect(R.id.button1, ConstraintSet.LEFT, R.id.main, ConstraintSet.LEFT, 0);

Now I gave left constraint to button 1 as shown above.

如上面展示的，现在我给按钮 1 添加上左边的 constraint 。

    // button 3 right and top align to parent
    applyConstraintSet.connect(R.id.button3, ConstraintSet.RIGHT, R.id.main, ConstraintSet.RIGHT, 0);

Now I gave right constraint to button 3 as shown above.

如上面展示的，现在我给按钮 3 添加上右边的 constraint 。

Make a sketch of this code in your mind currently our button 1 on the left and top parent and same for button2 but right parent.

现在在你的脑海里勾勒出这些代码形成的草图，我们的按钮 1 在父控件的左上角，按钮 2 也一样，不过相对靠右。

    // bi-direction or Chaining between button 1 and button 2
    applyConstraintSet.connect(R.id.button2, ConstraintSet.LEFT, R.id.button1, ConstraintSet.RIGHT, 0);
    applyConstraintSet.connect(R.id.button1, ConstraintSet.RIGHT, R.id.button2, ConstraintSet.LEFT, 0);

Here I created bi-directional relationship between button1 and button 2 as shown above.

如上所示，我在这里创建了按钮 1 和按钮 2 的双向关系。

    // bi-direction or Chaining between button 2 and button 3
    applyConstraintSet.connect(R.id.button2, ConstraintSet.RIGHT, R.id.button3, ConstraintSet.LEFT, 0);
    applyConstraintSet.connect(R.id.button3, ConstraintSet.LEFT, R.id.button2, ConstraintSet.RIGHT, 0);

Here I created bi-directional relationship between button2 and button 3 as shown above.

如上所示，我在这里创建了按钮 2 和按钮 3 的双向关系。


    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3},
            null, ConstraintWidget.CHAIN_PACKED);

This method crate’s a Horizontal chain for us. So this method will take 5 arguments.

First: Id of a head view.

Second: Id of a tail view in chain.

Third: int array, give head and tail view ids as int array.

Fourth: float array, give weight if we want weight chaining otherwise null.

Fifth: Style of chaining like CHAIN_SPREAD.


这个方法为我们创建了一个水平的 chain。这个方法需要5个参数。

第一个：头部 view 的 id。
第二个：chain 里尾部 view 的 id。
第三个：int 数组，把头部和尾部 view 的 id 放入 int 数组。
第四个：float 数组，如果我们需要权重的 chaining 的话它可以给我们权重，否则的话为空。
第五个：chaining 的风格，类似 CHAIN_SPREAD。

Now If I try to run. I will get below result.

现在如果我运行一下，我会得到下面的结果。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)Oh no. That is not required behaviour. If you guys remember I clear all constraints of these Buttons. That’s why there width and height is 0. Now I need to give width and height as shown below.

这不是我们需要的动作。如果你们还记的我清除了这些按钮的 constraint，这就是为什么这里的宽度和高度都为 0.如下所示，我需要给它们的宽度和高度赋值。

    applyConstraintSet.constrainWidth(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button3,ConstraintSet.WRAP_CONTENT);

    applyConstraintSet.constrainHeight(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button3,ConstraintSet.WRAP_CONTENT);

Now its time to run again.

现在再运行一次。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)

Hurray. Its time to show you whole code together.

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

Now change chain style.

现在改变 chain 风格。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)

Now change chain style.

现在改变 chain 风格。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD_INSIDE);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)

Now I am going to show you again CHAIN_PACKED with bias.
现在我将向你们展示带有偏差值的 CHAIN_PACKED 。

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_PACKED);

    applyConstraintSet.setHorizontalBias(R.id.button1, .1f);

Here as shown above I used a new method setHorizontalBias() in which I gave a head of our chain group and bias value in float.

如上所示，我使用了一个新方法 setHorizontalBias()，在这个方法里我填入了我们 chain 组的头部和 float 类型的偏差值。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)

**Bonus**:
**奖励**:

I am showing you one more use of ConstraintSet which also mentioned in Android API doc. So basically we can apply two different ConstraintSet on same ConstraintLayout as shown below.

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

**XML of activity_main:**
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

**XML of activty_main2:**
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

Hurray we are done with ConstraitLayout Animations. Now the next and final topic which is remaining is [Constraint Layout Visual [Design] Editor ( What the hell is this )[Part4].](http://www.uwanttolearn.com/uncategorized/constraint-layout-visual-design-editor-hell/)

哇哦，我们已经完成了 ConstraitLayout 动画。剩下的最后一个主题是 [Constraint Layout Visual [Design] Editor ( What the hell is this )[Part4].](http://www.uwanttolearn.com/uncategorized/constraint-layout-visual-design-editor-hell/)


OK Guys its time to say Bye. Have a nice weekend.

好的各位，是时候说再见了，希望你们都有一个很棒的周末。
