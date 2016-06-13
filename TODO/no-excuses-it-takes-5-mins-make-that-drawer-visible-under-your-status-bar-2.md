>* 原文链接 : [IT TAKES LESS THAN 5 MINS, MAKE THAT DRAWER VISIBLE UNDER YOUR STATUS BAR](http://matthewwear.xyz/no-excuses-it-takes-5-mins-make-that-drawer-visible-under-your-status-bar-2/)
* 原文作者 : [MATTHEW WEAR](http://matthewwear.xyz/author/matthew/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Dwight](https://github.com/ldhlfzysys)
* 校对者:


你也许听过谷歌最新的设计理念Material Design （“材料设计”）[规范](http://www.google.com/design/spec/patterns/navigation-drawer.html)，可以让你的抽屉式导航栏跨越整个屏幕，包括状态栏，并且让抽屉后的所有控件以灰暗的网格形式可见。

然而，许多应用打开抽屉式导航栏时看来是这样的
![](http://matthewwear.xyz/content/images/2016/05/Screenshot-2016-05-31-09-57-54.png)

这里将示范如何把这些元素改造成上面说到的规范。

#### 扩展你的主题

你也许已经定义了一个包含抽屉式导航的页面。

    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">  
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>  

第一步,创建一个新的主题 `Theme` 扩展自 `AppTheme`

**vaules/styles.xml**

    <style name="AppTheme.NoActionBar">  
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>

**v21/styles.xml**

    <style name="AppTheme.NoActionBar">  
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
    </style>  

并且确保你的页面指向了这个主题，比如

    <activity  
        android:name="MyDrawerNavActivity"
        android:theme="@style/AppTheme.NoActionBar"

#### 安装你的 DrawerLayout控件


第二步，到你定义`DrawerLayout`控件的页面，设置`insetForegroundColor` (如果你不想控制 `ScrimInsetLayout`的颜色，你也可以不设置)。

    <android.support.v4.widget.DrawerLayout  
        ...
        android:fitsSystemWindows="true"
        app:insetForeground="@color/inset_color"
        >

看起来这样

![](http://matthewwear.xyz/content/images/2016/05/Screenshot-2016-05-31-10-24-05.png)

当然，如果一会你想在代码里改变状态栏的颜色或`ScrimInsetLayout`的颜色，你可以在`DrawerLayout`中通过setters方法来获取并改变。

    drawerLayout.setStatusBarBackgroundColor(ContextCompat.getColor(this, R.color.wierd_green));  

    drawerLayout.setScrimColor(ContextCompat.getColor(this, R.color.wierd_transparent_orange));  

感谢你的阅读，如果在我分享的内容里，你有更好的方法来实现，那么在评论里更正，感激不尽。

_* 以下添加于 6月5, 2016*_

###### 如果你继承 DrawerLayout

如果你继承了`DrawerLayout`，以上说的内容有可能不起作用。继承时，应用兼容器会为你在`DrawerLayout`里放置一个 `android.support.design.internal.ScrimInsetsFrameLayout`，但当你继承`DrawerLayout`时应用兼容器可能并不会这么做。

如果你继承了`DrawerLayout` 但是没有放置`ScrimInsetsFrameLayout`，你需要这么做：

**activity_with_drawer_layout.xml**

    <com.myproject.views.MyDrawerLayout  
        android:id="@+id/drawer_layout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:fitsSystemWindows="true">

        <FrameLayout
            android:id="@+id/content_frame"
            android:layout_width="match_parent"
            android:layout_height="match_parent"/>

        <fragment
            android:id="@+id/left_drawer"
            android:name="com.myproject.fragments.NavigationFragment"
            android:layout_width="wrap_content"
            android:layout_height="match_parent"
             />

    </com.myproject.views.MyDrawerLayout>  

放置一个`ScrimInsetsFrameLayout` 在你抽屉页面里，如：

**navigation_fragment_layout.xml**

    <?xml version="1.0" encoding="utf-8"?>  
    <android.support.design.internal.ScrimInsetsFrameLayout  
        ...
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="@android:color/transparent"
        android:fitsSystemWindows="true"
        >

        <!--- content of drawer here --->

    </android.support.design.internal.ScrimInsetsFrameLayout>  

