> * 原文地址：[Constraint Layout Concepts ( What the hell is this ) (Tips and Tricks) Part 2 ](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Constraint Layout Concepts ( What the hell is this ) (Tips and Tricks) Part 2

WOW, we got one more day so its time to make this day awesome by learning something new 🙂 .

Hello guys, hope every body is doing good. In last week we learn about what is Constraint Layout in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/). Now Its time to start learning about remaining things about this awesome layout.

**Motivation:**

Motivation is same as discus with you guys in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/). Now this time I am not going to explain what features are given by Constraint Layout instead I will share with you issues which may be you will face when implementing. In the end I promise with you guys, you will know all concepts (which I know) without knowing you know 🙂 .

**Issues:**

1. [MATCH_PARENT not working.](#match_parent_not_working)

2. [Align view in centre (Horizontally, Vertically, In Parent View).](#align_view_in_centre)

3. [How move View from Centre to Left or Right some DP.](#how_move_view_from_centre_to_left_or_right)

4. [Management of Ratio of my Image View.](#management_of_ratio_of_my_image_view)

5. [Two or more columns required.](#two_or_more_columns_required)

6. [Parent Left Views, some have 16dp margin but some have 8dp.](#parent_left_views)

7. [How achieve Linear Layout in Constraint Layout.](#linear_layout_to_constraint_layout)

8. [View Gone, Break my UI.](#view_gone_break_my_ui)

Its time to ATTACK :).

We need to download 2.3 Android studio. In previous versions Visual Editor is not good and that show some wrong info on Design Tab. So that is really important download 2.3 beta which is available when I am writing this post.

**1. MATCH_PARENT not working:**

When you try to give match_parent width/height to any view in Constraint layout. That will not work as show below (Automatically change by Editor).

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-31-31.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-31-31.gif)

No more match_parent. Remember match_parent is not deprecated instead that is removed from Constraint Layout nested views.

Solution:

Use **parent** property for Constraint Layout nested views. Just like we do in RelativeLayout width=0dp and left and right to parent align. Same we will do here as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-50-40.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-08-50-40.gif)

**2. Align view in centre (Horizontally, Vertically, Centre In Parent):**

We need a Button in the centre of a parent. We can achieve as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-02-29.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-02-29.gif)

Now I have a feeling you can easily achieve Horizontal and Vertical centre positions on your own :).

**3. How move View from Centre to Left or Right some DP:**

Mostly designer’s give us weird requirements. For example designer want a text which is not 100% centre of parent instead that start from nearly to centre.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-9.15.48-AM-181x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-9.15.48-AM.png)

Solution:

First, Sorry designers 😛 .  Really easy to achieve this in Constraint Layout as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-21-32.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-21-32.gif)

Same you can play with app:layout_constraintVertical_bias=”.1″.  Remember value limit 0,0.1 .. 1.

**4. Management of Ratio of my Image View:**

Lots of time we have ImageView with some specific ratio like 4:3. So we can achieve that as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-39-48.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-39-48.gif)

Haha I know really simple. But now there is one more issue. Like I have a textview which has match_constrained in both width and height dimensions, but I want size of that TextView should be square according to device size. One more important thing, we need to mention square in perspective of Height or Width as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-56-50.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-09-56-50.gif)Now you can play more by changing values randomly.

**5. Two or more columns required:**

Now my designer want something like Table Layout. Two columns as shown below

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.17.19-AM-181x300.png)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.17.19-AM.png)

Solution:

That is really simple. Only we need to add one new concept of ConstraintLayout is called Guidelines. That is awesome. You will see in a minute. Basically these are virtual lines which you can use as a UI separator. There is only three important properties if you know you can say you are master of Guidelines.

**orientation**: horizontal, vertical // how you want to divide screen logically

**layout_constraintGuide_percent**: 0, 0.1 ..  1 // Total screen having 1.0 percent

**layout_constraintGuide_begin**: 200dp  // By using dp we can place our Guideline

In the end this Guideline never render on UI.

So first I am going to implement Guideline which will divide my screen into half. So I can get two column feeling.

    <android.support.constraint.Guideline
        android:id="@+id/guideline"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:orientation="vertical"
        app:layout_constraintGuide_percent=".5" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.32.35-AM-209x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.32.35-AM.png)

Its time to add first button.

    <Button
    android:id="@+id/button"
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    android:text="Button"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toLeftOf="@+id/guideline"
    app:layout_constraintTop_toTopOf="parent" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.35.24-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.35.24-AM.png)

Its time to add second button.

    <Button
        android:id="@+id/button2"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:text="Button"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toLeftOf="@+id/guideline"
        app:layout_constraintTop_toBottomOf="@+id/button" />


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.38.04-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.38.04-AM.png)

Its time to add textview in second column.

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

Very simple to achieve this type of UI in ConstraintLayout.  You can make more columns or rows by using same concept.

Whole code is written below.

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

**6. Parent Left Views, some have 16dp margin but some have 8dp:**

I have some views which have constant 16dp left margin and some have 8dp as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.52.32-AM-179x300.png)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-10.52.32-AM.png)

May be you can ask this question. That is simple why that is mention as issue in post? Basically I am sharing with you a good practice how to manage UI.  By implementing my way you can make scale able your UI. I want you should know, how you can use something in different perspectives.

So its time to start.

OK if you saw from top to bottom. First, second and last view having 16dp margin and all other have 8dp.

I can do by giving direct margin to all views. But many time’s designer ask me, hey on small devices it look ugly can you do all views which have 8dp to 12dp left margin and those which have 16dp give them 20dp left margin.

If you giving direct margin. Its a nightmare. So I am going to make two guide lines. One having 8dp margin and second has 16dp margin. Both have vertical orientation.

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

Now its really simple add all other views according to requirement but with “0dp” margin. Now I am giving you whole code below.

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

Now designer want’s to change 16dp to 20dp. I only need to change Guideline value  app:layout_constraintGuide_begin=”16dp” to app:layout_constraintGuide_begin=”20dp”. One important thing please don’t make your team members fooooool. Always refactor your name if required. Like currently I have **sixteenDpGuideLine**. As a good developer its my duty to refactor Id name to **twentyDpGuideLine**. Now you can see magic in below image.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-11-17-59.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-11-17-59.gif)

**7. How achieve Linear Layout in Constraint Layout:**

We have three buttons which are equally distributed in horizontal fashion. So in Linear layout I can achieve this by using weight as code written below.

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

How we can achieve this in Constraint Layout. Very easy, I am writing code below.

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

So we achieve same result. Only focus on one thing. I created Bi – Directional relationship in between these buttons and width=”0dp”

    android:id="@+id/button1"
    ........
    app:layout_constraintRight_toLeftOf="@+id/button2"

    android:id="@+id/button2"
    ........
    app:layout_constraintLeft_toRightOf="@+id/button1"
    app:layout_constraintRight_toLeftOf="@+id/button3"
    ........

Oh no, guys you learned one new concept is called **chaining**. When we have Bi Directional relationship between views. Editor automatically take that as chaining. Now its time to discuss what benefits we can get by using chaining but before that I want to show how chaining looks on UI editor.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.44.26-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.44.26-AM.png)

Here I am going to copy some definitions from Android Documentation. Because I feel that is good time to explain.

**Chains:**

Chains provide group-like behavior in a single axis (horizontally or vertically). The other axis can be constrained independently.

**Creating a chain:**

A set of widgets are considered a chain if they are linked together via a bi-directional connection (see below, showing a minimal chain, with two widgets).

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains.png)

**Chain heads**

Chains are controlled by attributes set on the first element of the chain (the “head” of the chain):

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains-head.png)

The head is the left-most widget for horizontal chains, and the top-most widget for vertical chains.

Now I have a feeling you guys are comfortable with the concept of Chaining. Its time to show you one more thing about chaining, that is called **chaining style**. Basically there is very good documentation available which I will show you later because that mostly create confusion. First I want to give you some practical experience.

For chaining style there is one new property **layout_constraintHorizontal_chainStyle
(layout_constraintVertical_chainStyle)** and we have five values for this property.

Spread Chain, Spread Inside Chain, Packed Chain, Packed Chain with Bias and Weighted Chain. Its time to look one by one of all these values.

**Spread Chain:**

By adding spread value in my Head view. I got below result.

    app:layout_constraintHorizontal_chainStyle="spread"



[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.57.28-AM-211x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-11.57.28-AM.png)

Nothing change because **spread **is a default value. 🙂

**Spread Inside Chain:**

By adding spread_inside in my Head view. I got below result.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-03-41.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-03-41.gif)

In easy words when I gave this property to my head view my head and last view automatically attached with parent left and right edges. If you want this type of behaviour use “spread_insdie” value.

**Packed Chain:**

By adding packed value in my Head view. I got below result.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-07-52.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-07-52.gif)So when we want all views should be together. we can use “packed” value. Only one thing, all views are together but centre horizontal by default. Now my issue is I don’t want centre horizontal. For that, check next property.

**Packed Chain with Bias:**

By adding packed and horizontal bias value in my Head view I got below result.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-15-05.gif)
](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-15-05.gif)By using bias property I can change position as I want.

**Weighted Chain:**

For example I have three buttons. First two buttons should take half screen and third will take a remaining half. For that I will use weighted chain concept as shown below. One important point, in this chaining style we always choose default style “spread” and then by using property **“layout_constraintHorizontal_weight**” we manage distribution of space between views.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-22-55.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-22-55.gif)

Now we know real concept of Chaining and what are different chaining styles. Next I am doing copy some definitions of these chaining styles .

- `CHAIN_SPREAD` — the elements will be spread out (default style)
- Weighted chain — in `CHAIN_SPREAD` mode, if some widgets are set to `MATCH_CONSTRAINT`, they will split the available space
- `CHAIN_SPREAD_INSIDE` — similar, but the endpoints of the chain will not be spread out
- `CHAIN_PACKED` — the elements of the chain will be packed together. The horizontal or vertical bias attribute of the child will then affect the positioning of the packed elements

![](https://developer.android.com/reference/android/support/constraint/resources/images/chains-styles.png)

**Weighted chains:**

The default behavior of a chain is to spread the elements equally in the available space. If one or more elements are using `MATCH_CONSTRAINT`, they will use the available empty space (equally divided among themselves). The attribute `layout_constraintHorizontal_weight` and `layout_constraintVertical_weight` will control how the space will be distributed among the elements using`MATCH_CONSTRAINT`. For exemple, on a chain containing two elements using `MATCH_CONSTRAINT`, with the first element using a weight of 2 and the second a weight of 1, the space occupied by the first element will be twice that of the second element.

** 8. View Gone, Break my UI:**

Now what happened when some view Gone on runtime. I did some experiment and I got very odd results. For explaining this issue and how we can resolve I am taking very easy but effective example. For example I have two buttons as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-12.33.31-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-14-at-12.33.31-PM.png)

According to functionality when second button clicked, first button will be gone. So as I implemented I have expectation my second button should go on the left edge of parent. So its time to see what will happen.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-36-13.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-36-13.gif)

Haha my expectations are ruined.

Its time to resolve. Basically there is one new property is given in Constraint Layout called “app:layout_goneMargin”. By using this property I can resolve these type of issues. So now I am going to add one more line of code and will see is my issue resolve or not.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-40-40.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-14-2017-12-40-40.gif)

Boom. Every thing is working according to expectations. Hurray.

OK guys. Its time to say BYE. We will meet again in next post.
**[Constraint Layout [Animations | Dynamic Constraints | UI by Java] ( What the hell is this) [Part3] ](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/)**
