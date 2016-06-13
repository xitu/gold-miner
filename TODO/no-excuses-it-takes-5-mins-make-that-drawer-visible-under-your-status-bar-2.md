>* 原文链接 : [IT TAKES LESS THAN 5 MINS, MAKE THAT DRAWER VISIBLE UNDER YOUR STATUS BAR](http://matthewwear.xyz/no-excuses-it-takes-5-mins-make-that-drawer-visible-under-your-status-bar-2/)
* 原文作者 : [MATTHEW WEAR](http://matthewwear.xyz/author/matthew/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

You probably know that Google's Material Design [spec](http://www.google.com/design/spec/patterns/navigation-drawer.html) specifies to make your Navigation Drawer _span the full height of the screen, including behind the status bar ... Everything behind the drawer is still visible but darkened by a scrim._

Yet, many apps look like this when their navigation drawer is opened  
![](http://matthewwear.xyz/content/images/2016/05/Screenshot-2016-05-31-09-57-54.png)

Here is how to bring this element up to spec

#### Extend your theme

You probably already have a theme defined for your `Activity` that contains the navigation drawer

    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">  
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>  

To get started, first, just create a new `Theme` that extends `AppTheme`

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

And make sure to specify that your `Activity` now uses this theme, like so

    <activity  
        android:name="MyDrawerNavActivity"
        android:theme="@style/AppTheme.NoActionBar"

#### Setup your DrawerLayout

Second, go to where your `DrawerLayout` is defined in your layout, set your `insetForegroundColor` (you don't have to, but if you want to control the color of the `ScrimInsetLayout`) and confirm that `fitsSystemWindow` is set.

    <android.support.v4.widget.DrawerLayout  
        ...
        android:fitsSystemWindows="true"
        app:insetForeground="@color/inset_color"
        >

That is it.

![](http://matthewwear.xyz/content/images/2016/05/Screenshot-2016-05-31-10-24-05.png)

Of course, if you later want to change the color of the status bar or the scrim inset layout programmatically, there are setters for both in `DrawerLayout`.

    drawerLayout.setStatusBarBackgroundColor(ContextCompat.getColor(this, R.color.wierd_green));  

    drawerLayout.setScrimColor(ContextCompat.getColor(this, R.color.wierd_transparent_orange));  

Thanks for reading. If you know of a better way to accomplish what I've shared, then please correct me in the comments, it would be much appreciated.

_* The Below Added June 5, 2016*_

###### If you subclass DrawerLayout

The above might not work for you as is if you subclass `DrawerLayout`. AppCompat is placing a `android.support.design.internal.ScrimInsetsFrameLayout` inside the `DrawerLayout` for you, and it doesn't seem to do this if you subclass `DrawerLayout`.

So, if you're subclassing `DrawerLayout` and not placing a `ScrimInsetsFrameLayout`, you need to, like so:

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

Place a `ScrimInsetsFrameLayout` in your layout file of the drawer's view, like so:

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

