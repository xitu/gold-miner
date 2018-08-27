> * 原文地址：[Scrolling Behavior for Appbars in Android](https://android.jlelse.eu/scrolling-behavior-for-appbars-in-android-41aff9c5c468#.4fzku8r1x)
* 原文作者：[Karthikraj](https://android.jlelse.eu/@twit2karthikraj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley)
* 校对者：[jifaxu](https://github.com/jifaxu)，[tanglie1993](https://github.com/tanglie1993)


# 安卓应用栏的滚动效果 #


应用栏包含四个主要部分。它们在滚动效果中扮演中重要角色，分别是：

- 状态栏

- 工具栏

- 标签栏／搜索栏

- 弹性空白


![](https://cdn-images-1.medium.com/max/600/0*2uu13QqDndXLuPrT.png)

一个有状态栏、导航栏、标签／搜索栏以及弹性空白的例子。图片来自 material.io

应用栏滚动效果丰富了页面内容的显示方式。

我想把自己的经验分享给大家，其实理解和使用滚动的高度，弹性空白的大小调整，以及固定特定的元素可以很简单。

应用栏有以下几种滚动的效果，

1. 标准的工具栏滚动

2. 标签滚动

3. 弹性空白滚动

4. 填充了图片的弹性空白滚动

5. 弹性空白中重叠的内容滚动

如果你想直接看代码，这里是 [GitHub](https://github.com/karthikraj-duraisamy/ScrollingBehaviorAndroid) 的仓库链接。


### 基本设置 ###


在我们开始深入了解各种类型的滚动效果前，我们需要清楚基本设置和实现，

我们需要使用设计支持库来实现 **应用栏** 的滚动效果。这个库提供了很多原质化设计的部件。



在应用的 build.gradle 里添加：

```
dependencies {  
    compile 'com.android.support:design:X.X.X'
}
```


使需要此功能的 Activity 类继承 `android.support.v7.app.AppCompatActivity`。

```
public class MainActivity extends AppCompatActivity {
```


在 layout 的 xml 文件中，我们要把 **CoordinatorLayout** 放在最外层。在 **AppBarLayout** 里添加 **工具栏**，并在 **CoordinatorLayout** 里添加 **AppBarLayout**。

**CoordinatorLayout** 为其附属视图（例如 **FloatingButtons**,**ModalSheets** 和 **SnackBar**）提供合适的滚动以及原质动画。

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


就这样，我们完成了基本的实现。接下来我们需要了解一些决定了滚动效果的标志属性。

### 标准的工具栏滚动效果 ##


- 随着内容往下翻 **滚动出屏幕** 并且当用户往回翻时重新出现。

－ 当内容向下滚动时，工具栏 **停留在顶部**

![](https://cdn-images-1.medium.com/max/800/1*UsQiD6VrDEWufK4C7ZfGXw.gif)


带有工具栏的应用栏和内容一起滚动或出现。

为了达到这个目的，除了基本的代码实现，我们还需要：

在 **Toolbar** 添加 **app:layout_scrollFlags**

```
<android.support.v7.widget.Toolbar  
    ...
    app:layout_scrollFlags="scroll|enterAlways|snap"/>
```


**scroll** －随着内容一起滚动。

**enterAlways** －当内容拉到最上面，应用栏会马上出现。

**snap** －当 **应用栏** 在内容滚动停止时只显示出一半，这个属性会让 **应用栏** 根据工具栏的滚动部分的大小全部隐藏或者全部显示。

一旦 **app:layout_scrollFlags** 被添加进 **应用栏**，内容视图（**NestedScrollView** 或者 **RecyclerView**）就需要 **app:layout_behavior** 标签。

```
<android.support.v4.widget.NestedScrollView  
    ...
    app:layout_behavior="@string/appbar_scrolling_view_behavior"/>
```


这两个标签以及基本设置就足以让带有工具栏的应用栏滚动起来了。我们可以尝试不同的 **app:layout_scrollFlags.** 属性值来看看不同的效果。

下面是对属性的安卓文档解释。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*MXrFGQeSybQeDmLJrZ6tWA.jpeg">


### 标签栏的滚动效果 ###


- 当 **工具栏滚动消失后，标签栏停留在顶部**  

- 整个 **工具栏停留在顶部**，当用户反向滚动时，**标签栏**重现，并且当充分的反向滚动后，**工具栏**也重现。

- **工具栏和标签栏随着内容的滚动消失**。当用户反向滚动时，**标签栏**重现，并且当充分的反向滚动后，**工具栏**也重现。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*kUNBuDx-vGyuMh8Y7yLheQ.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UQ9Zw-yT1dZ5lU4srzuWOw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UsJmZmRwsXwZpHuNE9LuJg.gif">


有标签栏的应用栏的不同滚动效果。


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

### 弹性空白的滚动效果 ###


- **弹性空白收缩**到只剩下工具栏。在导航栏中**标题收缩至 20sp**。当用户滚动至顶端，**弹性空白和标题又拉长到原来的位置**。 

- 整个**应用栏随着滚动消失**。当用户回滚，工具栏重新出现并**固定在顶部**。当用户回滚到底时，**弹性空白和标题又拉长到原来的位置**。 

![](https://cdn-images-1.medium.com/max/800/1*bG1RZCd7_623GzOxZ984KA.gif)

可以滚动的弹性空白


为了得到**应用栏**的弹性空白，我们需要在 **CollapsingToolbarLayout** 里嵌套 **ToolBar** 标签。这意味着 **CoordinatorLayout** 在最上层， 然后 **AppBarLayout**, **CollapsingToolbarLayout**, **ToolbarLayout** 按照顺序摆放在里面。

我们要为 **AppBarLayout** 添加高度并且为 `CollapsingToolbarLayout` 指定 `app:layout_scrollFlags` 属性值。

同时，我们把 **app:layout_collapseMode=”pin”** 添加进 **Toolbar** 里。


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


**exitUntilCollapsed** －这个属性会让弹性空白滚动下来，当它随着内容滚动回到原来的位置。

### 加载了图片的弹性空白滚动效果 ###

- 与上面弹性空白的效果类似。当滚动图片时，**图片在被推上去的过程中会有小动画** 并且颜色变成应用的主色调。

- 当回滚的时候， **基色褪去**， 图片拉下来时有一个小动画。

![](https://cdn-images-1.medium.com/max/800/1*Ee4hkJjvOyJOKxViXpTgEA.gif)

图片的视差滚动


下面的改动与弹性空白的实现非常相似。

- **ImageView** 要加进 **CollapsingToolbarlayout**。

- **AppBarLayout** 里图片高度固定为 200dp。

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


### 弹性空白中重叠内容的滚动效果 ###


- 在这样的滚动效果中，有弹性空白的**应用栏**会被放置在页面内容的下面。一旦内容**开始滚动**，应用栏会**滚动得比内容快**直到它不再与**页面视图内容重叠**。一旦页面内容**滚动到顶部**，应用栏会从页面内容的上方出来并且**平滑地在下层滚动**。

- 整个**应用栏**可以随着页面内容滚动至消失在屏幕上，并且在回滚的时候重现。

- 这个效果中没有标签的位置。

![](https://cdn-images-1.medium.com/max/800/1*S3P_sztswwHR6D-NViX9tg.gif)

与内容重叠的弹性空白的滚动效果


在 **NestedScrollView** 或者 **RecyclerView** 中使用 **app:behaviour_overlapTop** 就可以达到这种效果。我们还要定义 **CollapsingToolbarLayout** 的高度。

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


同样地，我们可以通过 JAVA 代码动态指定 **scrollFlags** 属性值。

希望这篇文章可以帮你们实现应用栏的滚动效果。


这篇文章原来发表在[我的博客](http://karthikraj.net/2016/12/24/scrolling-behavior-for-appbars-in-android/)。


示例应用的代码可以通过 [GitHub](https://github.com/karthikraj-duraisamy/ScrollingBehaviorAndroid) 下载。


如果你喜欢这篇文章，请在 [Medium](https://medium.com/@twit2karthikraj) 和 [Twitter](https://twitter.com/MeKarthikraj) 上关注我。你也可以在 [LinkedIn](https://in.linkedin.com/in/karthikrajduraisamy) 上找到我。
