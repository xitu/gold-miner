> * 原文地址：[Constraint Layout [Animations | Dynamic Constraints | UI by Java] ( What the hell is this )[Part3]](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Constraint Layout Animations | Dynamic Constraints | UI by Java[Part3]

WOW, we got one more day so its time to make this day awesome by learning something new 🙂 .

Hello guys, hope every body is doing good. We already learned a lot of new things about Constraint Layout in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/) and [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/). Now Its time to start learning about remaining things of this awesome layout. Most probably this is the final post about Constraint Layout.

**Motivation:**

Motivation is same as discus with you guys in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/). Now in this post my main focus is animations on Constraint Layout. One bad news there is not enough help on this topic in android docs. I want to apologise before starting this post may be I am wrong on some places in the perspective of concept due to lack of knowledge but I am giving you 100% surety in the end you will enjoy and comfortable with animations according to my concepts 🙂 .

I am confuse for the name of this topic. So I decided I will go with three names, Constraint Layout Animations, Constraint Layout Dynamic Constraints and Constraint Layout UI by Java. In the end of this post, you will know why I choose three names.

Now this time I am not going to explain what features are given by Constraint Layout animations API instead I will share with you issues which may be you will face when implementing. So its time to **ATTACK** :).

We need to download 2.3 Android studio. In previous versions Visual Editor is not good and that show some wrong info on Design Tab. So that is really important download 2.3 beta which is available when I am writing this post.

**Introduction:**

In this post we are mostly working with Java but before starting I am going to explain how everything will work in this post.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM-578x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.50.22-AM.png)

For this post I am going to use above app. I have a one constraint layout in which I have total five buttons.

Apply and Reset buttons are doing nothing except they will apply or reset our animations. Other three buttons are used for our animations. We are playing with these three buttons by applying different animations. Most important point, we should know constraints of these three buttons before start.

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM-763x1024.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-21-at-10.57.06-AM.png)

Haha I know that is simple in comparison with XML. Now you know about these three buttons relationship with each other and with parent. BOOOOM

Also I want to explain one more new API before deep diving.

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

Now from this point I am going to change my writing style for new requirements.  Confused…….

I will use different sentences for same requirement, so you can easily understand my title of a post.

**New Requirement:**

I want to animate button 1, align left of a parent when user click apply.

In Developer Language:

Bro I want button 1, align to parent left when user click apply button using Java in constraint layout. Can you help me.
**Solution:**

    public void onApplyClick(View view) {
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

    public void onResetClick(View view) {
        resetConstraintSet.applyTo(constraintLayout);
    }

From now I only show you onApplyClick() method, remaining code always same. Oh forgot, if you saw onResetClick(). I am always applying original constraints to go back to my original UI.

Now there are two new API methods. setMargin() and applyTo(), I feel applyTo() no need to explain.

SetMargin() will take three arguments(viewId, anchor, margin).

Button 1 has 52dp left margin but as user clicked I changed to 8px. Its time to see how it looks.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-29-32.gif)

Oh no button is moving but with jerk, that did not looks like animation. That is bad so we need to review our code again. ———–. After reviewing I figure it out I need to add one more line in applyButton(). After adding that line how it looks as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-34-58.gif)

DONE. Its time to review new code changes.

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        applyConstraintSet.setMargin(R.id.button1,ConstraintSet.START,8);
        applyConstraintSet.applyTo(constraintLayout);
    }

Here I need to add TransitionManager API. Guys there is a support library available for TransistionManager API. you can add gradle dependency.

    compile 'com.android.support:transition:25.1.0'

Before going to next requirement. I want to revise everything.

In simple words we are using only two API’s. ConstraintSet and TransitionManager. From now we are only playing with ConstraintSet API.

**New Requirement:**

In User Language:

I want to animate all buttons, centre horizontal in parent when user click apply.

In Developer Language:

Bro I want, all buttons move to parent centre horizontal when user click apply button using Java in constraint layout. Can you help me.

**Solution:**

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-45-02.gif)

Oh its not working as we want. After analysing I got the issue. We have different margins with these buttons so when we click apply button they are going into center but with taking care of margins. So its time to resolve this issue.

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-51-11.gif)

**New Requirement:**

In User Language:

I want to animate button 3 to centre in parent when user click apply.

In Developer Language:

Bro I want button 3, move to parent centre when user click apply button using Java in constraint layout. Can you help me.

**Solution:**

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-11-58-30.gif)

**New Requirement:**

In User Language:

I want to animate all buttons width from current size to 600px when user click apply.

In Developer Language:

1. Bro I want, all buttons width size change to 600px when user click apply button using Java in constraint layout. Can you help me.


**Solution:**

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-17-31-53.gif)

**New Requirement:**

In User Language:

I want to animate button1 width and height to whole screen and all other views should hide when user click apply.

In Developer Language:

Bro I want button 1 should be match_parent, matche_parent and all other views should gone when user click apply button using Java in constraint layout. Can you help me.

**Solution:**

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

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-12-11-25.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-12-11-25.gif)

Its time to start some advance stuff. As we already learned Chaining concept in [tutorial 2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/). I am going to show you how we can implement that by using JAVA. ( In developer language 😛 ) .

**New Requirement:**

In User Language:

I want to animate all buttons, align to each other, top of the screen and horizontal center when user click apply button.

In Developer Language:

1. Bro I want to implement packed chaining on all three  buttons, when user click apply button using Java in constraint layout. Can you help me.

**Solution:**

As I am saying that is advance thing in my opinion but I am going to explain like that is nothing. So guys ready.

    public void onApplyClick(View view) {
        TransitionManager.beginDelayedTransition(constraintLayout);

        applyConstraintSet.clear(R.id.button1);
        applyConstraintSet.clear(R.id.button2);
        applyConstraintSet.clear(R.id.button3);

First I clear all the constraints from all three buttons. That is my personal preference you can do by removing only margin or size of a button or any other way but I feel that is the easiest solution to implement. Now our buttons have no constraints. (0 width, 0 height, 0 margin …).

    // button 1 left and top align to parent
    applyConstraintSet.connect(R.id.button1, ConstraintSet.LEFT, R.id.main, ConstraintSet.LEFT, 0);

Now I gave left constraint to button 1 as shown above.

    // button 3 right and top align to parent
    applyConstraintSet.connect(R.id.button3, ConstraintSet.RIGHT, R.id.main, ConstraintSet.RIGHT, 0);

Now I gave right constraint to button 3 as shown above.

Make a sketch of this code in your mind currently our button 1 on the left and top parent and same for button2 but right parent.

    // bi-direction or Chaining between button 1 and button 2
    applyConstraintSet.connect(R.id.button2, ConstraintSet.LEFT, R.id.button1, ConstraintSet.RIGHT, 0);
    applyConstraintSet.connect(R.id.button1, ConstraintSet.RIGHT, R.id.button2, ConstraintSet.LEFT, 0);

Here I created bi-directional relationship between button1 and button 2 as shown above.

    // bi-direction or Chaining between button 2 and button 3
    applyConstraintSet.connect(R.id.button2, ConstraintSet.RIGHT, R.id.button3, ConstraintSet.LEFT, 0);
    applyConstraintSet.connect(R.id.button3, ConstraintSet.LEFT, R.id.button2, ConstraintSet.RIGHT, 0);

Here I created bi-directional relationship between button2 and button 3 as shown above.

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

Now If I try to run. I will get below result.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-27-28.gif)Oh no. That is not required behaviour. If you guys remember I clear all constraints of these Buttons. That’s why there width and height is 0. Now I need to give width and height as shown below.

    applyConstraintSet.constrainWidth(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainWidth(R.id.button3,ConstraintSet.WRAP_CONTENT);

    applyConstraintSet.constrainHeight(R.id.button1,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button2,ConstraintSet.WRAP_CONTENT);
    applyConstraintSet.constrainHeight(R.id.button3,ConstraintSet.WRAP_CONTENT);

Now its time to run again.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-14-31-53.gif)

Hurray. Its time to show you whole code together.

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

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-01-18.gif)

Now change chain style.

applyConstraintSet.createHorizontalChain(R.id.button1,

            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_SPREAD_INSIDE);



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-03-47.gif)

Now I am going to show you again CHAIN_PACKED with bias.

    applyConstraintSet.createHorizontalChain(R.id.button1,
            R.id.button3,
            new int[]{R.id.button1, R.id.button3}, null, ConstraintWidget.CHAIN_PACKED);

    applyConstraintSet.setHorizontalBias(R.id.button1, .1f);

Here as shown above I used a new method setHorizontalBias() in which I gave a head of our chain group and bias value in float.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-21-2017-15-07-46.gif)

**Bonus**:

I am showing you one more use of ConstraintSet which also mentioned in Android API doc. So basically we can apply two different ConstraintSet on same ConstraintLayout as shown below.

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

OK Guys its time to say Bye. Have a nice weekend.
