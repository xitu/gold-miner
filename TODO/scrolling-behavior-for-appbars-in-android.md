> * 原文地址：[Scrolling Behavior for Appbars in Android](https://android.jlelse.eu/scrolling-behavior-for-appbars-in-android-41aff9c5c468#.4fzku8r1x)
* 原文作者：[Karthikraj](https://android.jlelse.eu/@twit2karthikraj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley)
* 校对者：

# Scrolling Behavior for Appbars in Android #

# 安卓应用栏的滚动效果 #

App bars contains four main aspects, that plays huge role in scrolling behavior. They are,

应用栏包含四个主要部分。它们在滚动效果中扮演中重要角色。他们是：

- 状态栏

- 工具栏

- 标签栏／搜索栏

- 灵活空间


![](https://cdn-images-1.medium.com/max/600/0*2uu13QqDndXLuPrT.png)

Example of a status bar, navigation bar, tab/search bar, and flexible space. Image from material.io
一个有状态栏、导航栏、标签／搜索栏以及灵活空间的例子。图片来源是 material.io


AppBar scrolling behavior enriches the way contents in a page presented.

I am going to share my experience about how easily we can understand and use the elevation in scrolling, sizing the flexible spaces, how to anchor specific elements.

应用栏滚动效果使页面内容的显示方式更为丰富。

我想分享关于于我是怎么简单理解和使用应用栏在滚动时升高，调整灵活空间的大小，以及怎样将特定的元素固定。

App Bar has following scrolling options,

1. Standard App bar scrolling with only Toolbar

2. App bar scrolling with tabs

3. App bar scrolling with Flexible space

4. App bar scrolling with image in Flexible space

5. App bar scrolling with overlapping content in Flexible space

If you wish to jump into the code directly, Here is the [Github](https://github.com/karthikraj-duraisamy/ScrollingBehaviorAndroid) repository link.

应用栏有以下几种滚动的效果，

1. 标准的应用栏与工具栏一起滚动

2. 应用栏与标签一起滚动

3. 应用栏与灵活空间一起滚动

4. 应用栏与填充了图片的灵活空间一起滚动

5。 应用栏与在灵活空间中重叠的内容一起滚动

### Basic Setup ###

### 基本设置 ###

Before we start jumping in and see all types of scrolling behavior, we needs to be clear about the basic setup and implementation.

Use design support library to achieve **AppBar** scrolling behavior. This library provides many of the material design components.

在我们开始深入了解各种类型的滚动效果前，我们需要清楚基本设置和实现，

我们需要使用设计支持库来达到 **应用栏** 的滚动效果。这个库提供了很多原质化设计的部件。


In app build.gradle,

在应用的 build.gradle 里添加：

```
dependencies {  
    compile 'com.android.support:design:X.X.X'
}
```

Extend`android.support.v7.app.AppCompatActivity` in the Activity class.

将需要此功能的 Activity 类继承 `android.support.v7.app.AppCompatActivity`。

```
public class MainActivity extends AppCompatActivity {
```

In the layout xml, we need to have ***CoordinatorLayout*** in the top. Add ***Toolbar*** inside ***AppBarLayout*** and the ***AppBarLayout*** needs to be inside the ***CoordinatorLayout*** . ***CoordinatorLayout*** is the one, which gives proper scrolling and material animations to the views attached with it like ***FloatingButtons***, ***ModalSheets and SnackBar***.

在 layout 的 xml 文件中，我们要把 ***CoordinatorLayout*** 放在最上面。在 ***AppBarLayout*** 里添加 ***工具栏***，并在 ***CoordinatorLayout*** 里添加 
***AppBarLayout***。

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

就这样，我们完成了基本的实现。接下来我们需要了解一些决定了混动效果的标志属性。

### Standard App bar scrolling with only Toolbar ###
### 只有工具栏滚动的标准应用栏 ##

- **scroll off-screen** with the content and returns when the user reverse scrolls.

- **stay fixed at the top** with content scrolling under it.

- 随着内容往下翻 **滚动出屏幕** 并且当用户往回翻时重新出现。

－ 当内容在下方滚动时，工具栏 **停留在顶部**

![](https://cdn-images-1.medium.com/max/800/1*UsQiD6VrDEWufK4C7ZfGXw.gif)

Appbar with toolbar scrolls and settles back along with the content

To achieve this, apart from the above basic setup code implementation:

The ***Toolbar*** needs to have ***app:layout_scrollFlags***

应用栏中的工具栏滚动并在与内容一起出现。

为了达到这个目的，除了基本的代码实现，我们还需要：

在 ***Toolbar*** 添加 ***app:layout_scrollFlags***

```
<android.support.v7.widget.Toolbar  
    ...
    app:layout_scrollFlags="scroll|enterAlways|snap"/>
```

***scroll*** -will be scrolled along with the content.

***enterAlways*** -when content is pulled down, immediately app bar will appear.

***snap*** -when the ***AppBar*** is half scrolled and content scrolling stopped, this will allow the ***AppBar*** to settle either hidden or appear based on the scrolled size of ***Toolbar***.

Once ***app:layout_scrollFlags*** added to ***Toolbar***, the content view (Either a ***NestedScrollView*** or ***RecyclerView***) needs to have ***app:layout_behavior*** tag.

***scroll*** －随着内容一起滚动。

***enterAlways*** －当内容拉到最上面，应用栏会马上出现。

***snap*** －当 ***应用栏*** 在内容滚动停止时只显示出一半，这个属性会让 ***应用栏*** 根据工具栏的滚动部分的大小全部隐藏或者全部显示。

一旦 ***app:layout_scrollFlags*** 被添加进 ***应用栏***，内容视图（***NestedScrollView*** 或者 ***RecyclerView***）需要 ***app:layout_behavior*** 标签。

```
<android.support.v4.widget.NestedScrollView  
    ...
    app:layout_behavior="@string/appbar_scrolling_view_behavior"/>
```

That’s it these two tags along with basic setup is enough to achieve the Standard ***AppBar*** with ***Toolbar*** scrolling behavior. We can get different behaviors by playing with ***app:layout_scrollFlags.***

Here is clear explanation from Android docs for the flags,

这两个标签以及基本设置就足以达到只有工具栏滚动的应用栏效果了。我们可以尝试不同的 ***app:layout_scrollFlags.*** 属性值来看看不同的效果。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*MXrFGQeSybQeDmLJrZ6tWA.jpeg">

### App bar scrolling with tabs ###
### 标签栏滚动的应用栏 ###

- ***TabBar*** stays **anchored at the top**, while the ***Toolbar*****scrolls off**.

- Whole ***AppBar*** stays **anchored at the top**, with the **content scrolling underneath**.

- Both the **toolbar and tab bar scroll off with content**. The ***TabBar*** returns on reverse-scroll, and the ***Toolbar*** returns on complete reverse scroll.

- 当 **工具栏滚动消失后，标签栏停留在顶部**  

- 整个 **工具栏停留在顶部**，当用户反向滚动时，**标签栏**重现，并且当充分的反向滚动后，**工具栏**也重现。

- **工具栏和标签栏随着内容的滚动消失**。当用户反向滚动时，**标签栏**重现，并且当充分的反向滚动后，**工具栏**也重现。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*kUNBuDx-vGyuMh8Y7yLheQ.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UQ9Zw-yT1dZ5lU4srzuWOw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UsJmZmRwsXwZpHuNE9LuJg.gif">

AppBar with TabBar with different scrolling behavior.

有标签栏的应用栏的不同滚动效果。

To achieve this, we need to add ***TabLayout*** inside the ***AppBarLayout*** and provide the ***layout_scrollFlags*** inside ***TabLayout***. That will be enough to achieve this and we can play around with the scrolling behavior like above examples by just altering the ***layout_scrollFlags***.

要达到这种效果，我们需要在 **AppBarLayout** 中添加 **TabLayout**，并且为 **TabLayout** 提供 **layout_scrollFlags** 属性。只需要修改 **layout_scrollFlags** 的属性值就足够让我们玩转上面例子里的滚动效果了。

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

### 灵活空间随着滚动的应用栏 ###

- The **flexible space shrinks** until only the toolbar remains. The** title shrinks to 20sp** in the navigation bar. When scrolling to the top of the page, **the flexible space and the title grow into place again**.

- The whole **app bar scrolls off**. When the user reverse scrolls, the toolbar returns **anchored to the top**. When scrolling all the way back, the **flexible space and the title grow into place again**.

- 

![](https://cdn-images-1.medium.com/max/800/1*bG1RZCd7_623GzOxZ984KA.gif)

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

![](https://cdn-images-1.medium.com/max/800/1*Ee4hkJjvOyJOKxViXpTgEA.gif)

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

![](https://cdn-images-1.medium.com/max/800/1*S3P_sztswwHR6D-NViX9tg.gif)

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
