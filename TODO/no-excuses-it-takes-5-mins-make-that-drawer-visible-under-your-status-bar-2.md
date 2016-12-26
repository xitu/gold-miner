>* 原文链接 : [IT TAKES LESS THAN 5 MINS, MAKE THAT DRAWER VISIBLE UNDER YOUR STATUS BAR](http://matthewwear.xyz/no-excuses-it-takes-5-mins-make-that-drawer-visible-under-your-status-bar-2/)
* 原文作者 : [MATTHEW WEAR](http://matthewwear.xyz/author/matthew/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Dwight](https://github.com/ldhlfzysys)
* 校对者: [aidistan](https://github.com/aidistan), [Goshin](https://github.com/Goshin)

# 怎样在 5 分钟内使 Drawer 在状态栏下可见？

你也许听过谷歌最新的设计理念 Material Design （“质感设计”）[规范](http://www.google.com/design/spec/patterns/navigation-drawer.html)，可以让你的抽屉式导航栏跨越整个屏幕，包括状态栏，并且让抽屉后的所有控件以灰暗的网格形式可见。

然而，许多应用打开抽屉式导航栏时看来是这样的


![](http://matthewwear.xyz/content/images/2016/05/Screenshot-2016-05-31-09-57-54.png)

这里将示范如何把这些元素改造成上面说到的规范。

#### 扩展你的主题

你可能已经给包含抽屉的 Activity 定义了一个样式。

    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">  
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>  

第一步,创建一个扩展自`AppTheme`的新`Theme`

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

并且确保你的 Activity 指定使用了这个 theme，比如

    <activity  
        android:name="MyDrawerNavActivity"
        android:theme="@style/AppTheme.NoActionBar"

#### 配置 DrawerLayout 控件


第二步，到你定义`DrawerLayout`控件的地方，设置`insetForegroundColor` (如果你不想控制 `ScrimInsetLayout`的颜色，你也可以不设置)。并设置好 `fitsSystemWindow` 属性值

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

Android Support 兼容包(AppCompat) 会在 `DrawerLayout` 里加入一个 `android.support.design.internal.ScrimInsetsFrameLayout`, 但如果你使用继承自 DrawerLayout 的自定义控件则不会这么做。

如果你继承了`DrawerLayout` 但是没有加入`ScrimInsetsFrameLayout`，你需要这么做：

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

在你的抽屉布局文件中加入一个 `ScrimInsetsFrameLayout`，如：

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

