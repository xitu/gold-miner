> * 原文地址：[Handling Scrolls with CoordinatorLayout](https://guides.codepath.com/android/handling-scrolls-with-coordinatorlayout)
> * 原文作者：[CODEPATH](https://guides.codepath.com/android)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/handling-scrolls-with-coordinatorlayout.md](https://github.com/xitu/gold-miner/blob/master/TODO/handling-scrolls-with-coordinatorlayout.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：


# 用 CoordinatorLayout 处理滚动操作

## 总览

[CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html) 扩展实现了 Google's Material Design 中的多种[滚动效果](http://www.google.com/design/spec/patterns/scrolling-techniques.html)。目前，这个框架提供了几种不需要写任何自定义动画代码就可以（使动画）工作的方式。这些效果包括：
[CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html) extends the ability to accomplish many of the Google's Material Design [scrolling effects](http://www.google.com/design/spec/patterns/scrolling-techniques.html). Currently, there are several ways provided in this framework that allow it to work without needing to write your own custom animation code. These effects include:

* 上下滑动 Floating Action Button 以给 Snackbar 提供空间。
*   Sliding the Floating Action Button up and down to make space for the Snackbar.

![](https://imgur.com/zF9GGsK.gif)

* 将 Toolbar 或 header 展开或者收起从而为主内容区提供空间。
*   Expanding or contracting the Toolbar or header space to make room for the main content.

![](https://imgur.com/X5AIH0P.gif)

* 控制哪一个 view 以何种速率进行展开或收起，包括[视差滚动效果](https://ihatetomatoes.net/demos/parallax-scroll-effect/)动画。
*   Controlling which views should expand or collapse and at what rate, including [parallax scrolling effects](https://ihatetomatoes.net/demos/parallax-scroll-effect/) animations.

![](https://imgur.com/1JHP0cP.gif)

### 代码示例

来自 Google 的 Chris Banes 将 `CoordinatorLayout` 和 [design support library](/android/Design-Support-Library) 中其他的特性放在一起做了一个漂亮的 demo。
Chris Banes from Google has put together a beautiful demo of the `CoordinatorLayout` and other [design support library](/android/Design-Support-Library) features.

[![](https://i.imgur.com/aA8aGSg.png)](https://github.com/chrisbanes/cheesesquare)

在 github 上可以查看[完整的源码](https://github.com/chrisbanes/cheesesquare)。这个项目是理解 `CoordinatorLayout` 的最简单方式之一。
The [full source code](https://github.com/chrisbanes/cheesesquare) can be found on github. This project is one of the easiest ways to understand `CoordinatorLayout`.

### 设置
### Setup

首先要确保遵循 [Design Support Library](/android/Design-Support-Library) 的说明。
Make sure to follow the [Design Support Library](/android/Design-Support-Library) instructions first.

## Floating Action Button 和 Snackbar

CoordinatorLayout 可以通过使用 `layout_anchor` 和 `layout_gravity` 属性来创建悬浮效果。更多信息请参见 [Floating Action Buttons](/android/Floating-Action-Buttons) 指南。
The CoordinatorLayout can be used to create floating effects using the `layout_anchor` and `layout_gravity` attributes. See the [Floating Action Buttons](/android/Floating-Action-Buttons) guide for more information.

当渲染一个 [Snackbar](/android/Displaying-the-Snackbar) is rendered 时，它通常出现在可见屏幕的底部。Floating action button 必须上移以便腾出空间。
When a [Snackbar](/android/Displaying-the-Snackbar) is rendered, it normally appears at the bottom of the visible screen. To make room, the floating action button must be moved up to provide space.

![](https://imgur.com/zF9GGsK.gif)

只要 CoordinatorLayout 被用作主布局，这个动画效果就会自动出现。Float action button 有一个[默认的 behavior](https://developer.android.com/reference/android/support/design/widget/FloatingActionButton.Behavior.html) 可以在检测到 Snackbar 被加入的同时将这个 button 向上移动 Snackbar 的高度。
So long as the CoordinatorLayout is used as the primary layout, this animation effect will occur for you automatically. The floating action button has a [default behavior](https://developer.android.com/reference/android/support/design/widget/FloatingActionButton.Behavior.html) that detects Snackbar views being added and animates the button above the height of the Snackbar.

```
 <android.support.design.widget.CoordinatorLayout
        android:id="@+id/main_content"
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent">

   <android.support.v7.widget.RecyclerView
         android:id="@+id/rvToDoList"
         android:layout_width="match_parent"
         android:layout_height="match_parent"/>

   <android.support.design.widget.FloatingActionButton
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="bottom|right"
        android:layout_margin="16dp"
        android:src="@mipmap/ic_launcher"
        app:layout_anchor="@id/rvToDoList"
        app:layout_anchorGravity="bottom|right|end"/>
 </android.support.design.widget.CoordinatorLayout>
```

## 展开与收起 Toolbar

![](https://imgur.com/X5AIH0P.gif)

首先确保你使用的不是过时的 ActionBar。并确保遵循了 [将 ToolBar 用作 ActionBar](/android/Using-the-App-Toolbar#using-toolbar-as-actionbar) 指南。还要确保的是 CoordinatorLayout 作为主布局容器。
The first step is to make sure you are not using the deprecated ActionBar. Make sure to follow the [Using the ToolBar as ActionBar](/android/Using-the-App-Toolbar#using-toolbar-as-actionbar) guide. Also make sure that the CoordinatorLayout is the main layout container.

```
<android.support.design.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
 xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/main_content"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:fitsSystemWindows="true">

      <android.support.v7.widget.Toolbar
                android:id="@+id/toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:popupTheme="@style/ThemeOverlay.AppCompat.Light" />

</android.support.design.widget.CoordinatorLayout>
```

### 响应滚动事件

接下来，我们必须使用一个叫做 [AppBarLayout](http://developer.android.com/reference/android/support/design/widget/AppBarLayout.html) 的容器布局来使 ToolBar 响应滚动事件。
Next, we must make the Toolbar responsive to scroll events using a container layout called [AppBarLayout](http://developer.android.com/reference/android/support/design/widget/AppBarLayout.html):

```
<android.support.design.widget.AppBarLayout
        android:id="@+id/appbar"
        android:layout_width="match_parent"
        android:layout_height="@dimen/detail_backdrop_height"
        android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"
        android:fitsSystemWindows="true">

  <android.support.v7.widget.Toolbar
                android:id="@+id/toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:popupTheme="@style/ThemeOverlay.AppCompat.Light" />

 </android.support.design.widget.AppBarLayout>
```

**注意**：根据官方的 [Google 文档](http://developer.android.com/reference/android/support/design/widget/AppBarLayout.html)，目前 AppBarLayout 需要作为直接子元素被嵌入 CoordinatorLayout 中。
**Note**: AppBarLayout currently expects to be the direct child nested within a CoordinatorLayout according to the official [Google docs](http://developer.android.com/reference/android/support/design/widget/AppBarLayout.html).

然后，我们需要在 AppBarLayout 和 期望被滚动的 View 之间定义一个关联。在 RecyclerView 或其他类似  [NestedScrollView](http://stackoverflow.com/questions/25136481/what-are-the-new-nested-scrolling-apis-for-android-l) 这样的可以嵌套滚动的 View 中加入 `app:layout_behavior`。Support library 中有一个映射到 [AppBarLayout.ScrollingViewBehavior](https://developer.android.com/reference/android/support/design/widget/AppBarLayout.ScrollingViewBehavior.html) 的特殊字符串资源`@string/appbar_scrolling_view_behavior`，它可以在某个特定的 view 上发生滚动事件的时候通知 `AppBarLayout`。Behavior 必须建立在触发（滚动）事件的 view 上。
Next, we need to define an association between the AppBarLayout and the View that will be scrolled. Add an `app:layout_behavior` to a RecyclerView or any other View capable of nested scrolling such as [NestedScrollView](http://stackoverflow.com/questions/25136481/what-are-the-new-nested-scrolling-apis-for-android-l). The support library contains a special string resource `@string/appbar_scrolling_view_behavior` that maps to [AppBarLayout.ScrollingViewBehavior](https://developer.android.com/reference/android/support/design/widget/AppBarLayout.ScrollingViewBehavior.html), which is used to notify the `AppBarLayout` when scroll events occur on this particular view. The behavior must be established on the view that triggers the event.

```
 <android.support.v7.widget.RecyclerView
        android:id="@+id/rvToDoList"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:layout_behavior="@string/appbar_scrolling_view_behavior">
```

当 CoordinatorLayout 发现 RecyclerView 中声明了这一属性，它就会搜索包含在其下的其他 view 看有没有与这个 behavior 关联的相关 view。在这种特殊情况下 `AppBarLayout.ScrollingViewBehavior` 描述了 RecyclerView 和 AppBarLayout 之间的依赖关系。RecyclerView 上的任何滚动事件都将触发 AppBarLayout 或任何包含在其中的 view 的布局发生变化。
When a CoordinatorLayout notices this attribute declared in the RecyclerView, it will search across the other views contained within it for any related views associated by the behavior. In this particular case, the `AppBarLayout.ScrollingViewBehavior` describes a dependency between the RecyclerView and AppBarLayout. Any scroll events to the RecyclerView should trigger changes to the AppBarLayout layout or any views contained within it.

RecyclerView 的滚动事件触发了 `AppBarLayout` 中用 `app:layout_scrollFlags` 属性声明的 view 发生变化：
Scroll events in the RecyclerView trigger changes inside views declared within `AppBarLayout` by using the `app:layout_scrollFlags` attribute:

```
    <android.support.design.widget.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:fitsSystemWindows="true"
        android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar">

            <android.support.v7.widget.Toolbar
                android:id="@+id/toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:layout_scrollFlags="scroll|enterAlways"/>

 </android.support.design.widget.AppBarLayout>
```

若要使任一滚动效果生效，必须启用 `app:layout_scrollFlags` 属性中的 `scroll` 标志。这个标志必须与 `enterAlways`、`enterAlwaysCollapsed`、 `exitUntilCollapsed` 或者 `snap` 一同使用：
The `scroll` flag used within the attribute `app:layout_scrollFlags` must be enabled for any scroll effects to take into effect. This flag must be enabled along with `enterAlways`, `enterAlwaysCollapsed`, `exitUntilCollapsed`, or `snap`:

* `enterAlways`：向上滚动时 view 变得可见。当从一个列表的底部滑动并且希望只要一向上滑动 `Toolbar` 就显示，在这种情况下这个标志位是很有用的。
    > Ps：这里所说的 scrolling up 应该指的是 list 的滚动条向上滑动而不是上滑的手势。
*   `enterAlways`: The view will become visible when scrolling up. This flag is useful in cases when scrolling from the bottom of a list and wanting to expose the `Toolbar` as soon as scrolling up takes place.

    ![](https://imgur.com/sGltNwr.png)

    通过，只有当 list 滑到顶部的时候 `Toolbar` 才会显示，如下所示：
    Normally, the `Toolbar` only appears when the list is scrolled to the top as shown below:

    ![](https://i.imgur.com/IZzcL1C.png)

* `enterAlwaysCollapsed`：通常只有当使用了 `enterAlways`，`Toolbar` 才会在你向下滑的时候继续展开：
*   `enterAlwaysCollapsed`: Normally, when only `enterAlways` is used, the `Toolbar` will continue to expand as you scroll down:

    ![](https://imgur.com/nVtheyw.png)

    假设你声明了 `enterAlways` 并且已经设置了一个 `minHeight`，你也可以使用 `enterAlwaysCollapsed`。如果这样设置了，你的 view 只能显示出这个最低高度。只有当滑到头的时候那个 view 才会展开到它的完全高度。
    Assuming `enterAlways` is declared and you have specified a `minHeight`, you can also specify `enterAlwaysCollapsed`. When this setting is used, your view will only appear at this minimum height. Only when scrolling reaches to the top will the view expand to its full height:

    ![](https://imgur.com/HqR8Nx5.png)

* `exitUntilCollapsed`：当设置了 `scroll` 标志时，下滑通常会引起全部内容的移动：
*   `exitUntilCollapsed`: When the `scroll` flag is set, scrolling down will normally cause the entire content to move:

    ![](https://imgur.com/qpEr4x5.png)

    通过指定 `minHeight` 和 `exitUntilCollapsed`，剩余内容开始滚动之前将首先达到 `Toolbar` 的最小高度，然后退出屏幕：
    By specifying a `minHeight` and `exitUntilCollapsed`, the minimum height of the `Toolbar` will be reached before the rest of the content begins to scroll and exit from the screen:

    ![](https://imgur.com/dTDPztp.png)

* `snap`：使用这一选项将由其决定在 view 只有部分减少的时候做什么。如果滑动结束时 view 的高度减少的部分小于原始高度的 50%，那么它将回到最初的位置。如果这个值大于它的 50%，它将完全消失。
*   `snap`: Using this option will determine what to do when a view only has been partially reduced. If scrolling ends and the view size has been reduced to less than 50% of its original, then this view to return to its original size. If the size is greater than 50% of its sized, it will disappear completely.
    ![](https://i.imgur.com/9hnupWJ.png)

**注意**：在你脑海中要将使用了 `scroll` 标志位的 view 放在首位。这样，折叠的 view 将会首先退出，留下在顶部固定着的元素。
**Note**: Keep in mind to order all your views with the `scroll` flag first. This way, the views that collapse will exit first while leaving the pinned elements at the top.

至此，你应该意识到这个 ToolBar 响应了滚动事件。
At this point, you should notice that the Toolbar responds to scroll events.

![](https://imgur.com/Hl2Asb1.gif)

### 创建折叠效果

如果想创建折叠 ToolBar 的效果，我们必须将 ToolBar 包含在 CollapsingToolbarLayout 中：
If we want to create the collapsing toolbar effect, we must wrap the Toolbar inside CollapsingToolbarLayout:

```
<android.support.design.widget.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:fitsSystemWindows="true"
        android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar">
    <android.support.design.widget.CollapsingToolbarLayout
            android:id="@+id/collapsing_toolbar"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:fitsSystemWindows="true"
            app:contentScrim="?attr/colorPrimary"
            app:expandedTitleMarginEnd="64dp"
            app:expandedTitleMarginStart="48dp"
            app:layout_scrollFlags="scroll|exitUntilCollapsed">

            <android.support.v7.widget.Toolbar
                android:id="@+id/toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:layout_scrollFlags="scroll|enterAlways"></android.support.v7.widget.Toolbar>

    </android.support.design.widget.CollapsingToolbarLayout>
</android.support.design.widget.AppBarLayout>
```

现在结果应该显示为：
Your result should now appears as:

![](https://imgur.com/X5AIH0P.gif)

通常，我们会设置 Toolbar 的标题。现在，我们在 CollapsingToolBarLayout 而不是 Toolbar 上设置标题。
Normally, we set the title of the Toolbar. Now, we need to set the title on the CollapsingToolBarLayout instead of the Toolbar.

```
 CollapsingToolbarLayout collapsingToolbar =
              (CollapsingToolbarLayout) findViewById(R.id.collapsing_toolbar);
 collapsingToolbar.setTitle("Title");
```

注意，在使用 `CollapsingToolbarLayout` 的时候，应该如[这个文档](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/values-v21/styles.xml)所说的那样，将状态栏设置成半透明（API 19）或者透明（API 21）的。特别是，下面的样式应该在 `res/values-xx/styles.xml` 中设置：
Note that when using `CollapsingToolbarLayout`, the status bar should be made translucent (API 19) or transparent (API 21) as [shown in this file](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/values-v21/styles.xml). In particular, the following styles should be set in `res/values-xx/styles.xml` as illustrated:

```
<!-- res/values-v19/styles.xml -->
<style name="AppTheme" parent="Base.AppTheme">
    <item name="android:windowTranslucentStatus">true</item>
</style>

<!-- res/values-v21/styles.xml -->
<style name="AppTheme" parent="Base.AppTheme">
    <item name="android:windowDrawsSystemBarBackgrounds">true</item>
    <item name="android:statusBarColor">@android:color/transparent</item>
</style>
```
通过像上面那样启用系统栏的半透明效果，你的布局会将内容填充到系统栏后面，因此你必须在那些不想被系统栏覆盖的布局上使用 `android:fitsSystemWindow` 。另外一种为 API 19 添加内边距来避免系统栏覆盖 view 的方案可以在[这里](http://blog.raffaeu.com/archive/2015/04/11/android-and-the-transparent-status-bar.aspx)查看。
By enabling translucent system bars as shown above, your layout will fill the area behind the system bars, so you must also enable `android:fitsSystemWindow` for the portions of your layout that should not be covered by the system bars. An additional workaround for API 19 which adds padding to avoid the status bar clipping views [can be found here](http://blog.raffaeu.com/archive/2015/04/11/android-and-the-transparent-status-bar.aspx).

### 创建视差动画

CollapsingToolbarLayout 可以让我们做出更多高级动画，例如使用一个在折叠的同时可以渐隐的 ImageView。在用户滑动的时候，标题的高度也可以改变。
The CollapsingToolbarLayout also enables us to do more advanced animations, such as using an ImageView that fades out as it collapses. The title can also change in height as the user scrolls.

![](https://imgur.com/ah4l5oj.gif)

要想创建这种效果，我们添加一个 ImageView 并且在 ImageView 标签中声明 `app:layout_collapseMode="parallax"` 属性。
To create this effect, we add an ImageView and declare an `app:layout_collapseMode="parallax"` attribute to the tag.

```
<android.support.design.widget.CollapsingToolbarLayout
    android:id="@+id/collapsing_toolbar"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:fitsSystemWindows="true"
    app:contentScrim="?attr/colorPrimary"
    app:expandedTitleMarginEnd="64dp"
    app:expandedTitleMarginStart="48dp"
    app:layout_scrollFlags="scroll|exitUntilCollapsed">

            <android.support.v7.widget.Toolbar
                android:id="@+id/toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:layout_scrollFlags="scroll|enterAlways" />
            <ImageView
                android:src="@drawable/cheese_1"
                app:layout_scrollFlags="scroll|enterAlways|enterAlwaysCollapsed"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:scaleType="centerCrop"
                app:layout_collapseMode="parallax"
                android:minHeight="100dp" />

</android.support.design.widget.CollapsingToolbarLayout>
```

## 底部表

在 support design library 的 `v23.2` 版本中已经支持底部表了。支持两种底部表：[persistent](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-persistent-bottom-sheets) 和 [modal](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-modal-bottom-sheets)。Persistent 类型的底部表显示应用内的内容，而 modal 类型的则显示菜单或者简单的对话框。
Bottom Sheets are now supported in `v23.2` of the support design library. There are two types of bottom sheets supported: [persistent](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-persistent-bottom-sheets) and [modal](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-modal-bottom-sheets). Persistent bottom sheets show in-app content, while modal sheets expose menus or simple dialogs.

![](https://imgur.com/3hCTnnC.png)

### Persistent 形式的底部表

有两种方法来创建 Persistent 形式的底部表。第一种是用一个 `NestedScrollView`，然后就简单地嵌到里面。第二种是额外创建一个嵌入 `CoordinatorLayout` 中的 `RecyclerView`。如果 `layout_behavior` 是预定义好的 `@string/bottom_sheet_behavior`，那么这个 `RecyclerView` 默认是隐藏的。还要注意的是 `RecyclerView` 应该使用 `wrap_content` 而不是 `match_parent`，这是一个新修改，为的是让底部栏只占用所需要的而不是全部空间。
There are two ways you can create persistent modal sheets. The first way is to use a `NestedScrollView` and simply embed the contents within this view. The secondary way is to create them is using an additional [RecyclerView] (/android/Using-the-RecyclerView) nested inside a `CoordinatorLayout`. This `RecyclerView` will be hidden by default if the `layout_behavior` defined is set using the pre-defined `@string/bottom_sheet_behavior` value. Note also that this `RecyclerView` should be using `wrap_content` instead of `match_parent`, which is a new change that allows the bottom sheet to only occupy the necessary space instead of the entire page:

```
<CoordinatorLayout>

    <android.support.v7.widget.RecyclerView
        android:id="@+id/design_bottom_sheet"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:layout_behavior="@string/bottom_sheet_behavior">
</CoordinatorLayout>
```

下一步是创建 `RecyclerView`。我们可以创建一个简单的只包含一张图片和文字的 `Item`，和一个可以填充这些 items 的适配器。
The next step is to create `RecyclerView` elements. We can create a simple `Item` that contains an image and a text and an adapter that can inflate these items.

```

public class Item {

    private int mDrawableRes;

    private String mTitle;

    public Item(@DrawableRes int drawable, String title) {
        mDrawableRes = drawable;
        mTitle = title;
    }

    public int getDrawableResource() {
        return mDrawableRes;
    }

    public String getTitle() {
        return mTitle;
    }

}
```
接着，创建适配器：
Next, we create our adapter:

```
public class ItemAdapter extends RecyclerView.Adapter<ItemAdapter.ViewHolder> {

    private List<Item> mItems;

    public ItemAdapter(List<Item> items, ItemListener listener) {
        mItems = items;
        mListener = listener;
    }

    public void setListener(ItemListener listener) {
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter, parent, false));
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        holder.setData(mItems.get(position));
    }

    @Override
    public int getItemCount() {
        return mItems.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public ImageView imageView;
        public TextView textView;
        public Item item;

        public ViewHolder(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            imageView = (ImageView) itemView.findViewById(R.id.imageView);
            textView = (TextView) itemView.findViewById(R.id.textView);
        }

        public void setData(Item item) {
            this.item = item;
            imageView.setImageResource(item.getDrawableResource());
            textView.setText(item.getTitle());
        }

        @Override
        public void onClick(View v) {
            if (mListener != null) {
                mListener.onItemClick(item);
            }
        }
    }

    public interface ItemListener {
        void onItemClick(Item item);
    }
}
```

底部表默认是被隐藏的。我们需要用一个点击事件来触发显示和隐藏。**注意**：由于这个已知的 [issue](https://code.google.com/p/android/issues/detail?id=202174)，因此不要尝试在 `OnCreate()` 方法中展开底部表。
The bottom sheet should be hidden by default. We need to use a click event to trigger the show and hide. **Note**: do not try to expand the bottom sheet inside an `OnCreate()` method because of this [known issue](https://code.google.com/p/android/issues/detail?id=202174).

```
RecyclerView recyclerView = (RecyclerView) findViewById(R.id.design_bottom_sheet); 

// Create your items
ArrayList<Item> items = new ArrayList<>();
items.add(new Item(R.drawable.cheese_1, "Cheese 1"));
items.add(new Item(R.drawable.cheese_2, "Cheese 2"));

// Instantiate adapter
ItemAdapter itemAdapter = new ItemAdapter(items, null);
recyclerView.setAdapter(itemAdapter);

// Set the layout manager
recyclerView.setLayoutManager(new LinearLayoutManager(this));

CoordinatorLayout coordinatorLayout = (CoordinatorLayout) findViewById(R.id.main_content);
final BottomSheetBehavior behavior = BottomSheetBehavior.from(recyclerView);

fab.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View view) {
       if(behavior.getState() == BottomSheetBehavior.STATE_COLLAPSED) {
         behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
       } else {
         behavior.setState(BottomSheetBehavior.STATE_COLLAPSED);
       }
    }
});
```

你可以设置布局属性 `app:behavior_hideable=true` 来允许用户也可以通过滑动而隐藏底部表。还有一些其他的属性，包括：`STATE_DRAGGING`，`STATE_SETTLING`，和 `STATE_HIDDEN`。更多内容，请看 [底部表的另一篇教程](http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031)。
You can set a layout attribute `app:behavior_hideable=true` to allow the user to swipe the bottom sheet away too. There are other states including `STATE_DRAGGING`, `STATE_SETTLING`, and `STATE_HIDDEN`. For additional reading, you can see [another tutorial on bottom sheets here](http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031).

### Modal 形式的底部表

Modal 形式的底部表基本上是从底部滑入的 Dialog Fragments。关于如何创建这种类型的 fragment 可以查看[本文](/android/Using-DialogFragment)。你应该继承 `BottomSheetDialogFragment` 而不是 `DialogFragment`。
Modal sheets are basically Dialog Fragments that slide from the bottom. See [this guide](/android/Using-DialogFragment) about how to create these types of fragments. Instead of extending from `DialogFragment`, you would extend from `BottomSheetDialogFragment`.

### 高级的底部表示例

有很多使用了 floating action button 的或展开或收缩或表状态随用户的滑动而改变的复杂的底部表的例子。最著名的例子就是使用了多阶表的 Google Maps。
There are many examples in the wild of complex bottom sheets with a floating action button that grows or shrinks or sheet state transitions as the user scrolls. The most well-known example is Google Maps which has a multi-phase sheet:

![](https://i.imgur.com/lLSdNus.gif)

下述教程和代码示例可以帮助你实现这些更加复杂的效果：
The following tutorials and sample code should help achieve these more sophisticated effects:

* [CustomBottomSheetBehavior Sample](https://github.com/miguelhincapie/CustomBottomSheetBehavior) - 描述了在底部表滑动时三种状态来回切换。参考[相关 stackoverflow 博文](http://stackoverflow.com/a/37443680)。
*   [CustomBottomSheetBehavior Sample](https://github.com/miguelhincapie/CustomBottomSheetBehavior) - Demonstrates three-state phase shifts during scrolling of the bottom sheet. Refer to [related stackoverflow post](http://stackoverflow.com/a/37443680) for explanation.

* [Grafixartist Bottom Sheet Tutorial](http://blog.grafixartist.com/bottom-sheet-android-design-support-library/) - 关于在底部表滑动时如何定位 floating action button 以及对其使用动画。
*   [Grafixartist Bottom Sheet Tutorial](http://blog.grafixartist.com/bottom-sheet-android-design-support-library/) - Tutorial on how to position and animate the floating action button as the bottom sheet scrolls.
* 你可以查看[本文](http://stackoverflow.com/questions/34160423/how-to-mimic-google-maps-bottom-sheet-3-phases-behavior)来进一步讨论如何模拟 Google Map 滑动期间状态改变的效果。
*   You can read this [stackoverflow post](http://stackoverflow.com/questions/34160423/how-to-mimic-google-maps-bottom-sheet-3-phases-behavior) for additional discussion on how to mimic google maps state changes during scroll.

为了得到预期的效果可能会做相当多的实验。对于某些特定的用例，你可能觉得下面列出的第三方库是一种更简单的选择。
Getting the desired effect can take quite a bit of experimentation. For certain use-cases, you might find that the third-party libraries listed below provide easier alternatives.

### 可选的第三方底部表

除了 design support library 中提供的官方底部表，有几个可选的非常流行的第三方库，他们在某些特定用法下更容易配置和使用。
In addition to the official bottom sheet within the design support library, there are several extremely popular third-party alternatives that can be easier to use and configure for certain use cases:

![](https://i.imgur.com/xRv4IQH.gif)

以下代表了最常见的选择和相关的例子：
The following represent the most common alternatives and related samples:

* [AndroidSlidingUpPanel](https://github.com/umano/AndroidSlidingUpPanel) - 一个广泛流行的实现了底部表的方法，这应当被视为官方的另一种方案。
*   [AndroidSlidingUpPanel](https://github.com/umano/AndroidSlidingUpPanel) - A widely popular third-party approach to a bottom sheet that should be considered as an alternative to the official approach.
* [Flipboard/bottomsheet](https://github.com/Flipboard/bottomsheet) - 另一个在官方方案发布前非常流行的可选方案，
*   [Flipboard/bottomsheet](https://github.com/Flipboard/bottomsheet) - Another very popular alternative to the official bottom sheet that was widely in use before the official solution was released.
* [ThreePhasesBottomSheet](https://github.com/AndroidDeveloperLB/ThreePhasesBottomSheet) - 利用第三方库来创建一个多阶底部表的示例代码。
*   [ThreePhasesBottomSheet](https://github.com/AndroidDeveloperLB/ThreePhasesBottomSheet) - Sample code leveraging third-party libraries to create a multi-phase bottom sheet.
* [Foursquare BottomSheet Tutorial](http://android.amberfog.com/?p=915) - 概述如何用第三方底部表来实现在老版本的 Foursquare 中使用的效果。
*   [Foursquare BottomSheet Tutorial](http://android.amberfog.com/?p=915) - Outlines how to use third-party bottom sheets to achieve the effect used within an older version of Foursquare.

在官方的 persistent modal 表和这些第三方的替代方案之间，你应该可以通过足够的实验来实现任何想要的效果。
Between the official persistent modal sheets and these third-party alternatives, you should be able to achieve any desired effect with sufficient experimentation.

## CoordinatorLayout 故障解决

`CoordinatorLayout` 非常强大但是容易出错。如果你在使用 behavior 时遇到了问题，请查看下面的建议：
`CoordinatorLayout` is very powerful but error-prone at first. If you are running into issues with coordinating behavior, check the following tips below:

* 
*   The best example of how to use coordinator layout effectively is to refer carefully to the [source code for cheesesquare](https://github.com/chrisbanes/cheesesquare). This repository is a sample repo kept updated by Google to reflect best practices with coordinating behaviors. In particular, see the [layout for a tabbed ViewPager list](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/include_list_viewpager.xml) and [this for a layout for a detail view](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/activity_detail.xml). Compare your code carefully to the cheesesquare source code.
*   Make sure that the `app:layout_behavior="@string/appbar_scrolling_view_behavior"` property is applied to the **direct child of the `CoordinatorLayout`**. For example, if there's pull-to-refresh that the property is applied to the `SwipeRefreshLayout` that contains the `RecyclerView` rather than the 2nd-level descendant.
*   When coordinating between a fragment with a list of items inside of a `ViewPager` and a parent activity, you want to put the `app:layout_behavior` property on the `ViewPager` [as outlined here](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/include_list_viewpager.xml#L49) so the scrolls within the pager are bubbled up and can be managed by the `CoordinatorLayout`. Note that you **should not** put that `app:layout_behavior` property anywhere within the fragment or the list within.
*   Keep in mind that `ScrollView` **does not work** with `CoordinatorLayout`. You will need to use the `NestedScrollView` instead as shown in [this example](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/activity_detail.xml#L61). Wrapping your content in the `NestedScrollView` and applying the `app:layout_behavior` property will cause the scrolling behavior to work as expected.
*   Make sure that the root layout of your activity or fragment is a `CoordinatorLayout`. Scrolls will not react to any of the other layouts.

There's a lot of ways coordinating layouts can go wrong. Add tips here as you discover them.

## Custom Behaviors

One example of a custom behavior is discussed in using [CoordinatorLayout with Floating Action Buttons](/android/Floating-Action-Buttons#using-coordinatorlayout).

CoordinatorLayout works by searching through any child view that has a [CoordinatorLayout Behavior](http://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.Behavior.html) defined either statically as XML with a `app:layout_behavior` tag or programmatically with the View class annotated with the `@DefaultBehavior` decorator. When a scroll event happens, CoordinatorLayout attempts to trigger other child views that are declared as dependencies.

To define your own a CoordinatorLayout Behavior, the layoutDependsOn() and onDependentViewChanged() should be implemented. For instance, AppBarLayout.Behavior has these two key methods defined. This behavior is used to trigger a change on the AppBarLayout when a scroll event happens.

```

public boolean layoutDependsOn(CoordinatorLayout parent, View child, View dependency) {
          return dependency instanceof AppBarLayout;
      }

 public boolean onDependentViewChanged(CoordinatorLayout parent, View child, View dependency) {
          // check the behavior triggered
          android.support.design.widget.CoordinatorLayout.Behavior behavior = ((android.support.design.widget.CoordinatorLayout.LayoutParams)dependency.getLayoutParams()).getBehavior();
          if(behavior instanceof AppBarLayout.Behavior) {
          // do stuff here
          }
 }       
```

The best way to understand how to implement these custom behaviors is by studying the [AppBarLayout.Behavior](https://github.com/android/platform_frameworks_support/blob/master/design/src/android/support/design/widget/AppBarLayout.java#L738) and [FloatingActionButtion.Behavior](https://android.googlesource.com/platform/frameworks/support/+/master/design/src/android/support/design/widget/FloatingActionButton.java#L554) examples.

## Third-Party Scrolling and Parallax

In addition to using the `CoordinatorLayout` as outlined above, be sure to check out [these popular third-party libraries](/android/Must-Have-Libraries#scrolling-and-parallax) for scrolling and parallax effects across `ScrollView`, `ListView`, `ViewPager` and `RecyclerView`.

## Embedding Google Maps in AppBarLayout

There is currently no way of supporting Google Maps fragment within an `AppBarLayout` as confirmed in this [issue](https://code.google.com/p/android/issues/detail?id=188487). Changes in the support design library v23.1.0 now provide a `setOnDragListener()` method, which is useful if [drag and drop effects](/android/Gestures-and-Touch-Events#dragging-and-dropping) are needed within this layout. However, it does not appear to impact scrolling as stated in this [blog article](http://android-developers.blogspot.com/2015/10/android-support-library-231.html?linkId=17977963).

## References

* [http://android-developers.blogspot.com/2015/05/android-design-support-library.html](http://android-developers.blogspot.com/2015/05/android-design-support-library.html)
* [http://android-developers.blogspot.com/2016/02/android-support-library-232.html](http://android-developers.blogspot.com/2016/02/android-support-library-232.html)
* [http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031](http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
