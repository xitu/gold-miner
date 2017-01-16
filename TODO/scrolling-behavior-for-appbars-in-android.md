> * 原文地址：[Scrolling Behavior for Appbars in Android](https://android.jlelse.eu/scrolling-behavior-for-appbars-in-android-41aff9c5c468#.4fzku8r1x)
* 原文作者：[Karthikraj](https://android.jlelse.eu/@twit2karthikraj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Scrolling Behavior for Appbars in Android #

App bars contains four main aspects, that plays huge role in scrolling behavior. They are,

![](https://cdn-images-1.medium.com/max/600/0*2uu13QqDndXLuPrT.png)

Example of a status bar, navigation bar, tab/search bar, and flexible space. Image from material.io

- Status Bar

- Toolbar

- Tab bar/Search bar

- Flexible space

AppBar scrolling behavior enriches the way contents in a page presented.

I am going to share my experience about how easily we can understand and use the elevation in scrolling, sizing the flexible spaces, how to anchor specific elements.

App Bar has following scrolling options,

1. Standard App bar scrolling with only Toolbar

2. App bar scrolling with tabs

3. App bar scrolling with Flexible space

4. App bar scrolling with image in Flexible space

5. App bar scrolling with overlapping content in Flexible space

If you wish to jump into the code directly, Here is the [Github](https://github.com/karthikraj-duraisamy/ScrollingBehaviorAndroid) repository link.

### Basic Setup ###

Before we start jumping in and see all types of scrolling behavior, we needs to be clear about the basic setup and implementation.

Use design support library to achieve **AppBar** scrolling behavior. This library provides many of the material design components.

In app build.gradle,

```
dependencies {  
    compile 'com.android.support:design:X.X.X'
}
```

Extend`android.support.v7.app.AppCompatActivity` in the Activity class.

```
public class MainActivity extends AppCompatActivity {
```

In the layout xml, we need to have ***CoordinatorLayout*** in the top. Add ***Toolbar*** inside ***AppBarLayout*** and the ***AppBarLayout*** needs to be inside the ***CoordinatorLayout*** . ***CoordinatorLayout*** is the one, which gives proper scrolling and material animations to the views attached with it like ***FloatingButtons***, ***ModalSheets and SnackBar***.

```
<android.support.design.widget.CoordinatorLayout  
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">
```

```
<android.support.design.widget.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="?attr/colorPrimary">
```

```
<android.support.v7.widget.Toolbar
            android:id="@+id/toolbar"/>
```

```
</android.support.design.widget.AppBarLayout>
```

```
...
```

```
</android.support.design.widget.CoordinatorLayout>
```

That’s it. We have done with the basic implementation and after this, there are some flags that will decide the scrolling behavior.

### Standard App bar scrolling with only Toolbar ###

- **scroll off-screen** with the content and returns when the user reverse scrolls.

- **stay fixed at the top** with content scrolling under it.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*UsQiD6VrDEWufK4C7ZfGXw.gif">

Appbar with toolbar scrolls and settles back along with the content

To achieve this, apart from the above basic setup code implementation:

The ***Toolbar*** needs to have ***app:layout_scrollFlags***

```
<android.support.v7.widget.Toolbar  
    ...
    app:layout_scrollFlags="scroll|enterAlways|snap"/>
```

***scroll*** -will be scrolled along with the content.

***enterAlways*** -when content is pulled down, immediately app bar will appear.

***snap*** -when the ***AppBar*** is half scrolled and content scrolling stopped, this will allow the ***AppBar*** to settle either hidden or appear based on the scrolled size of ***Toolbar***.

Once ***app:layout_scrollFlags*** added to ***Toolbar***, the content view (Either a ***NestedScrollView*** or ***RecyclerView***) needs to have ***app:layout_behavior*** tag.

```
<android.support.v4.widget.NestedScrollView  
    ...
    app:layout_behavior="@string/appbar_scrolling_view_behavior"/>
```

That’s it these two tags along with basic setup is enough to achieve the Standard ***AppBar*** with ***Toolbar*** scrolling behavior. We can get different behaviors by playing with ***app:layout_scrollFlags.***

Here is clear explanation from Android docs for the flags,

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*MXrFGQeSybQeDmLJrZ6tWA.jpeg">

### App bar scrolling with tabs ###

- ***TabBar*** stays **anchored at the top**, while the ***Toolbar*****scrolls off**.

- Whole ***AppBar*** stays **anchored at the top**, with the **content scrolling underneath**.

- Both the **toolbar and tab bar scroll off with content**. The ***TabBar*** returns on reverse-scroll, and the ***Toolbar*** returns on complete reverse scroll.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*kUNBuDx-vGyuMh8Y7yLheQ.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UQ9Zw-yT1dZ5lU4srzuWOw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UsJmZmRwsXwZpHuNE9LuJg.gif">

AppBar with TabBar with different scrolling behavior.

To achieve this, we need to add ***TabLayout*** inside the ***AppBarLayout*** and provide the ***layout_scrollFlags*** inside ***TabLayout***. That will be enough to achieve this and we can play around with the scrolling behavior like above examples by just altering the ***layout_scrollFlags***.

```
<android.support.design.widget.AppBarLayout  
    ...>
    <android.support.v7.widget.Toolbar
        .../>
    <android.support.design.widget.TabLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:layout_scrollFlags="scroll|enterAlways|snap"/>
</android.support.design.widget.AppBarLayout>
```

### App bar scrolling with Flexible space ###

- The **flexible space shrinks** until only the toolbar remains. The** title shrinks to 20sp** in the navigation bar. When scrolling to the top of the page, **the flexible space and the title grow into place again**.

- The whole **app bar scrolls off**. When the user reverse scrolls, the toolbar returns **anchored to the top**. When scrolling all the way back, the **flexible space and the title grow into place again**.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*bG1RZCd7_623GzOxZ984KA.gif">

Flexible space with Scrolling

To get Flexible space for **AppBar**, we need to use **CollapsingToolbarLayout** around the **ToolBar** tag. Which means **CoordinatorLayout** in the top and **AppBarLayout**, **CollapsingToolbarLayout**, **ToolbarLayout** inside the order.

We need to add height for the **AppBarLayout** and need to specify `app:layout_scrollFlags` for `CollapsingToolbarLayout.`

Also we need to add ***app:layout_collapseMode=”pin”*** tag in **Toolbar**.

```
<android.support.design.widget.AppBarLayout  
    android:layout_width="match_parent"
    android:layout_height="200dp">

    <android.support.design.widget.CollapsingToolbarLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:contentScrim="?attr/colorPrimary"
        app:layout_scrollFlags="scroll|exitUntilCollapsed">

        <android.support.v7.widget.Toolbar
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
app:layout_collapseMode="pin"/>

    </android.support.design.widget.CollapsingToolbarLayout>

</android.support.design.widget.AppBarLayout>
```

***exitUntilCollapsed*** -flag will make the Flexible space scrolled down while scrolling back to position along with the content.

### App bar scrolling with image in Flexible space ###

- Similar to the above Flexible space behavior. When scrolling image will **pushed up with slight animation** and the color changes to primary color.

- While reversing the scrolling **primary color fades away to leave way for the image** been pulled down with a slight animation.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Ee4hkJjvOyJOKxViXpTgEA.gif">

Image parallax scrolling

It is very much similar to the Flexible Space implementation with the below changes,

- **ImageView** needs to added inside **CollapsingToolbarlayout**.

- **AppBarLayout** height specified 200dp will be applied to image.

```
<android.support.design.widget.AppBarLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:background="?attr/colorPrimary">
    <android.support.design.widget.CollapsingToolbarLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:contentScrim="?attr/colorPrimary"
        app:layout_scrollFlags="scroll|exitUntilCollapsed"
        app:expandedTitleTextAppearance="@style/TextAppearance.AppCompat.Title">

        <ImageView
            android:layout_width="match_parent"
            android:layout_height="200dp"
            app:layout_collapseMode="parallax"/>
    <android.support.v7.widget.Toolbar
        android:id="@+id/toolbar"
        android:layout_width="match_parent"
        app:layout_collapseMode="pin"
        android:layout_height="?attr/actionBarSize"
        app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
        app:theme="@style/ToolBarStyle" />
</android.support.design.widget.CollapsingToolbarLayout>
</android.support.design.widget.AppBarLayout>
```

### App bar scrolling with overlapping content in Flexible space ###

- In this scrolling, the **AppBar** with Flexible space will be placed behind the content. Once content **starts scrolling**, the app bar will **scroll faster than the content** until it gets out of the **overlapping content view**. Once the content **reaches top**, app bar comes upside of the content and content goes **underneath and scrolls smoothly**.

- The whole **AppBar** can **scroll off-screen** along with content and can be **returned while reverse scrolling**.

- There will not be any **TabBar** placement in this behavior.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*S3P_sztswwHR6D-NViX9tg.gif">

Flexible space scrolling with content overlapping

This can be achieved by using ***app:behaviour_overlapTop*** in the **NestedScrollView** or **RecyclerView**. Also in this case we are specifying height value for `**CollapsingToolbarLayout**` .

```
<android.support.design.widget.AppBarLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:background="?attr/colorPrimary">
    <android.support.design.widget.CollapsingToolbarLayout
        android:layout_width="match_parent"
        android:layout_height="172dp"
        app:contentScrim="?attr/colorPrimary"
        app:titleEnabled="false"
        app:layout_scrollFlags="scroll|exitUntilCollapsed"
        app:expandedTitleTextAppearance="@style/TextAppearance.AppCompat.Title">

    <android.support.v7.widget.Toolbar
        android:id="@+id/toolbar"
        android:layout_width="match_parent"
        app:layout_collapseMode="pin"
        android:layout_height="?attr/actionBarSize"
        app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
        app:theme="@style/ToolBarStyle" />
</android.support.design.widget.CollapsingToolbarLayout>
</android.support.design.widget.AppBarLayout>

<android.support.v4.widget.NestedScrollView
    android:layout_width="wrap_content"
    android:layout_height="match_parent"
    app:behavior_overlapTop="100dp"
    app:layout_behavior="@string/appbar_scrolling_view_behavior">

    ...
</android.support.v4.widget.NestedScrollView>
```

Also we can implement and specify the **scrollFlags** dynamically through java code.

Hopefully this article will help you to implement scrolling behaviors for AppBar.

I posted this article originally on [my blog](http://karthikraj.net/2016/12/24/scrolling-behavior-for-appbars-in-android/).

Code for demo app is available on [Github](https://github.com/karthikraj-duraisamy/ScrollingBehaviorAndroid).

If you like the article, follow me on [Medium](https://medium.com/@twit2karthikraj)  and [Twitter](https://twitter.com/MeKarthikraj) . You can also find me on [LinkedIn](https://in.linkedin.com/in/karthikrajduraisamy) .
