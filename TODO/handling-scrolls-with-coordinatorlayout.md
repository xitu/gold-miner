> * 原文地址：[Handling Scrolls with CoordinatorLayout](https://guides.codepath.com/android/handling-scrolls-with-coordinatorlayout)
> * 原文作者：[CODEPATH](https://guides.codepath.com/android)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/handling-scrolls-with-coordinatorlayout.md](https://github.com/xitu/gold-miner/blob/master/TODO/handling-scrolls-with-coordinatorlayout.md)
> * 译者：[Feximin](https://github.com/Feximin)

# 用 CoordinatorLayout 处理滚动

## 总览

[CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html) 扩展了完成 Google's Material Design 中的多种[滚动效果](http://www.google.com/design/spec/patterns/scrolling-techniques.html)的能力。目前，此框架提供了几种不需要写任何自定义动画代码就可以（使动画）工作的方式。这些效果包括：

* 上下滑动 Floating Action Button 以给 Snackbar 提供空间。

![](https://imgur.com/zF9GGsK.gif)

* 将 Toolbar 或 header 展开或者收起从而为主内容区提供空间。

![](https://imgur.com/X5AIH0P.gif)

* 控制哪一个 view 以何种速率进行展开或收起，包括[视差滚动效果](https://ihatetomatoes.net/demos/parallax-scroll-effect/)动画。

![](https://imgur.com/1JHP0cP.gif)

### 代码示例

来自 Google 的 Chris Banes 将 `CoordinatorLayout` 和 [design support library](/android/Design-Support-Library) 中其他的特性放在一起做了一个酷炫的 demo。

[![](https://i.imgur.com/aA8aGSg.png)](https://github.com/chrisbanes/cheesesquare)

在 github 上可以查看[完整源码](https://github.com/chrisbanes/cheesesquare)。这个项目是最容易理解 `CoordinatorLayout` 的方式之一。

### 设置

首先要确保遵循 [Design Support Library](/android/Design-Support-Library) 的说明。

## Floating Action Button 和 Snackbar

CoordinatorLayout 可以通过使用 `layout_anchor` 和 `layout_gravity` 属性来创建悬浮效果。更多信息请参见 [Floating Action Buttons](/android/Floating-Action-Buttons) 指南。

当渲染一个 [Snackbar](/android/Displaying-the-Snackbar) 时，它通常出现在可见屏幕的底部。Floating action button 必须上移以便腾出空间。

![](https://imgur.com/zF9GGsK.gif)

只要 CoordinatorLayout 被用作主布局，这个动画效果就会自动出现。Float action button 有一个[默认的 behavior](https://developer.android.com/reference/android/support/design/widget/FloatingActionButton.Behavior.html) 可以在检测到 Snackbar 被加入的同时将这个 button 向上移动 Snackbar 的高度。

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

首先确保你使用的不是过时的 ActionBar。并确保遵循了 [将 ToolBar 用作 ActionBar](/android/Using-the-App-Toolbar#using-toolbar-as-actionbar) 指南。还要确保的是以 oordinatorLayout 作为主布局容器。

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

接下来，我们必须使用一个叫做 [AppBarLayout](http://developer.android.com/reference/android/support/design/widget/AppBarLayout.html) 的容器布局来使 ToolBar 响应滚动事件：

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

然后，我们需要在 AppBarLayout 和 期望被滚动的 View 之间定义一个关联。在 RecyclerView 或其他类似  [NestedScrollView](http://stackoverflow.com/questions/25136481/what-are-the-new-nested-scrolling-apis-for-android-l) 这样的可以嵌套滚动的 View 中加入 `app:layout_behavior`。支持库中有一个映射到 [AppBarLayout.ScrollingViewBehavior](https://developer.android.com/reference/android/support/design/widget/AppBarLayout.ScrollingViewBehavior.html) 的特殊字符串资源 `@string/appbar_scrolling_view_behavior`，它可以在某个特定的 view 上发生滚动事件时通知 `AppBarLayout`。Behavior 必须建立在触发（滚动）事件的 view 上。

```
 <android.support.v7.widget.RecyclerView
        android:id="@+id/rvToDoList"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:layout_behavior="@string/appbar_scrolling_view_behavior">
```

当 CoordinatorLayout 发现 RecyclerView 中声明了这一属性，它就会搜索包含在其下的其他 view 看有没有与这个 behavior 关联的任何相关 view。在这种特殊情况下 `AppBarLayout.ScrollingViewBehavior` 描述了 RecyclerView 和 AppBarLayout 之间的依赖关系。RecyclerView 上的任何滚动事件都将触发 AppBarLayout 或任何包含在其中的 view 的布局发生变化。

RecyclerView 的滚动事件触发了 `AppBarLayout` 中用 `app:layout_scrollFlags` 属性声明的 view 发生变化：

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

* `enterAlways`：向上滚动时 view 变得可见。此标志在从一个列表的底部滑动并且希望只要一向上滑动 `Toolbar` 就显示这种情况下是很有用的。
    > Ps：这里所说的 scrolling up 应该指的是 list 的滚动条向上滑动而不是上滑的手势。

    ![](https://imgur.com/sGltNwr.png)

    通常，只有当 list 滑到顶部的时候 `Toolbar` 才会显示，如下所示：

    ![](https://i.imgur.com/IZzcL1C.png)

* `enterAlwaysCollapsed`：通常只有当使用了 `enterAlways`，`Toolbar` 才会在你向下滑的时候继续展开：

    ![](https://imgur.com/nVtheyw.png)

    假设你声明了 `enterAlways` 并且已经设置了一个 `minHeight`，你也可以使用 `enterAlwaysCollapsed`。如果这样设置了，你的 view 只会显示出这个最低高度。只有当滑到头的时候那个 view 才会展开到它的完全高度：

    ![](https://imgur.com/HqR8Nx5.png)

* `exitUntilCollapsed`：当设置了 `scroll` 标志时，下滑通常会引起全部内容的移动：

    ![](https://imgur.com/qpEr4x5.png)

    通过指定 `minHeight` 和 `exitUntilCollapsed`，剩余内容开始滚动之前将首先达到 `Toolbar` 的最小高度，然后退出屏幕：

    ![](https://imgur.com/dTDPztp.png)

* `snap`：使用这一选项将由其决定在 view 只有部分减时所执行的功能。如果滑动结束时 view 的高度减少的部分小于原始高度的 50%，那么它将回到最初的位置。如果这个值大于它的 50%，它将完全消失。
    ![](https://i.imgur.com/9hnupWJ.png)

**注意**：在你脑海中要将使用了 `scroll` 标志位的 view 放在首位。这样，被折叠的 view 将会首先退出，留下在顶部固定着的元素。

至此，你应该意识到这个 ToolBar 响应了滚动事件。

![](https://imgur.com/Hl2Asb1.gif)

### 创建折叠效果

如果想创建折叠 ToolBar 的效果，我们必须将 ToolBar 包含在 CollapsingToolbarLayout 中：

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

![](https://imgur.com/X5AIH0P.gif)

通常，我们会设置 Toolbar 的标题。现在，我们需要在 CollapsingToolBarLayout 而不是 Toolbar 上设置标题。

```
 CollapsingToolbarLayout collapsingToolbar =
              (CollapsingToolbarLayout) findViewById(R.id.collapsing_toolbar);
 collapsingToolbar.setTitle("Title");
```

注意，在使用 `CollapsingToolbarLayout` 的时候，应该如[此文档](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/values-v21/styles.xml)所述，将状态栏设置成半透明（API 19）或者透明（API 21）的。特别是，应该在 `res/values-xx/styles.xml` 中设置以下样式：

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
通过像上面那样启用系统栏的半透明效果，你的布局会将内容填充到系统栏后面，因此你还必须在那些不想被系统栏覆盖的布局上使用 `android:fitsSystemWindow` 。另外一种为 API 19 添加内边距来避免系统栏覆盖 view 的方案可以在[这里](http://blog.raffaeu.com/archive/2015/04/11/android-and-the-transparent-status-bar.aspx)查看。

### 创建视差动画

CollapsingToolbarLayout 可以让我们做出更高级的动画，例如使用一个在折叠的同时可以渐隐的 ImageView。在用户滑动时，标题的高度也可以改变。

![](https://imgur.com/ah4l5oj.gif)

要想创建这种效果的话，我们需要添加一个 ImageView 并在 ImageView 标签中声明 `app:layout_collapseMode="parallax"` 属性。

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

在 support design library 的 `v23.2` 版本中已经支持底部表了。支持的底部表有两种类型：[persistent](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-persistent-bottom-sheets) 和 [modal](https://www.google.com/design/spec/components/bottom-sheets.html#bottom-sheets-modal-bottom-sheets)。Persistent 类型的底部表显示应用内的内容，而 modal 类型的则显示菜单或者简单的对话框。

![](https://imgur.com/3hCTnnC.png)

### Persistent 形式的底部表

有两种方法来创建 Persistent 形式的底部表。第一种是用 `NestedScrollView`，然后就简单地将内容嵌到里面。第二种是额外创建一个嵌入 `CoordinatorLayout` 中的 `RecyclerView`。如果 `layout_behavior` 是预定义好的 `@string/bottom_sheet_behavior`，那么这个 `RecyclerView` 默认是隐藏的。还要注意的是 `RecyclerView` 应该使用 `wrap_content` 而不是 `match_parent`，这是一个新修改，为的是让底部栏只占用必要的而不是全部空间：

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

### Modal 形式的底部表

Modal 形式的底部表基本上是从底部滑入的 Dialog Fragments。关于如何创建这种类型的 fragment 可以查看[本文](/android/Using-DialogFragment)。你应该继承 `BottomSheetDialogFragment` 而不是 `DialogFragment`。

### 高级的底部表示例

有很多复杂的使用了 floating action button 的底部表的例子，button 随着用户滑动或展开或收缩或改变表状态。最著名的例子就是使用了多阶表的 Google Maps：

![](https://i.imgur.com/lLSdNus.gif)

下述教程和代码示例可以帮助你实现这些更加复杂的效果：

* [CustomBottomSheetBehavior Sample](https://github.com/miguelhincapie/CustomBottomSheetBehavior) - 描述了在底部表滑动时三种状态来回切换。参考[相关 stackoverflow 博文](http://stackoverflow.com/a/37443680)。

* [Grafixartist Bottom Sheet Tutorial](http://blog.grafixartist.com/bottom-sheet-android-design-support-library/) - 关于在底部表滑动时如何定位 floating action button 以及对其使用动画的教程。
* 你可以阅读[本文](http://stackoverflow.com/questions/34160423/how-to-mimic-google-maps-bottom-sheet-3-phases-behavior)来进一步讨论如何模拟 Google Map 滑动期间状态改变的效果。

为了得到预期的效果可能需要相当多的实验。对于某些特定的用例，你可能会发现下面列出的第三方库是一种更简单的选择。

### 可选的第三方底部表

除了 design support library 中提供的官方底部表，有几个可选的非常流行的第三方库，他们在某些特定用法下更容易配置和使用：

![](https://i.imgur.com/xRv4IQH.gif)

以下是最常见的选择和相关的例子：

* [AndroidSlidingUpPanel](https://github.com/umano/AndroidSlidingUpPanel) - 一个广泛流行的实现了底部表的方法，这应当被视为官方的另一种方案。
* [Flipboard/bottomsheet](https://github.com/Flipboard/bottomsheet) - 另一个在官方方案发布前非常流行的可选方案。
* [ThreePhasesBottomSheet](https://github.com/AndroidDeveloperLB/ThreePhasesBottomSheet) - 利用第三方库来创建一个多阶底部表的示例代码。
* [Foursquare BottomSheet Tutorial](http://android.amberfog.com/?p=915) - 概述如何用第三方底部表来实现在老版本的 Foursquare 中使用的效果。

在官方的 persistent modal 表和这些第三方的替代方案之间，你应该可以通过足够的实验来实现任何想要的效果。

## CoordinatorLayout 故障解决

`CoordinatorLayout` 非常强大但容易出错。如果你在使用 behavior 时遇到了问题，请查看下面的建议：

* 关于如何高效使用 CoordinatorLayout 的例子请仔细参考 [cheesesquare 源码](https://github.com/chrisbanes/cheesesquare)。这个仓库是一个被 Google 持续更新的示例仓库，反映了 behavior 的最佳实践。尤其是  [layout for a tabbed ViewPager list](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/include_list_viewpager.xml) 和 [this for a layout for a detail view](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/activity_detail.xml) 这两个。可以仔细比较一下你的代码与 cheesesquare 的源码。
* 确保在 **`CoordinatorLayout` 的直接子 view** 上使用了 `app:layout_behavior="@string/appbar_scrolling_view_behavior"` 属性。例如，在一个下拉刷新的例子中，这个属性应该放在包含了 `RecyclerView` 的 `SwipeRefreshLayout` 中而不是第二层以下的后代中。
* 在一个使用了内部有 items 列表的 `ViewPager` 的 fragment 和一个父 activity 之间使用协调时，你想像[这里描述](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/include_list_viewpager.xml#L49)的那样在 `ViewPager` 上添加 `app:layout_behavior` 属性，认为这样就可以将 pager 中的滚动事件向上传递然后就可以被 `CoordinatorLayout` 管理。但是，记住，你**不应该**将 `app:layout_behavior` 属性放到 fragment 或者它内部列表上的任何一个位置。
* 谨记 `ScrollView` 不能与 `CoordinatorLayout` 一起使用。你将需要像[这个示例](https://github.com/chrisbanes/cheesesquare/blob/master/app/src/main/res/layout/activity_detail.xml#L61)中展示的那样用 `NestedScrollView` 来代替。将你的内容包含在 `NestedScrollView` 中，然后在其上添加 `app:layout_behavior` 就会使你的滚动行为预期工作。
* 确保你的 activity 或者 fragment 的根布局是 `CoordinatorLayout`。滚动事件不会响应其他任何布局。

使用 CoordinatorLayout 时出错的方式有很多种，当你发现出错时可以在这里添加提示。

## 自定义 Behavior

[CoordinatorLayout with Floating Action Buttons](/android/Floating-Action-Buttons#using-coordinatorlayout) 这篇文章中讨论了一个自定义 behavior 例子。

CoordinatorLayout 的工作方式是通过搜索所有在 XML 中静态地使用 `app:layout_behavior` 标签或者以编程的方式在 View 类中使用 `@DefaultBehavior` 注解装饰而定义 [CoordinatorLayout Behavior](http://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.Behavior.html) 的子 View。当滚动事件发生时，CoorinatorLayout 尝试去触发那些被声明为依赖项的子 View。

为了定义你自己的 CoordinatorLayout Behavior，你应该实现 layoutDependsOn() 和 onDependentViewChanged() 这两个方法。例如 AppBarLayout.Behavior 就定义了这两个关键方法。此 behavior 用来在滚动事件发生时触发 AppBarLayout 上的改变。

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

理解如何实现这些自定义的 behavior 最好方法是研究 [AppBarLayout.Behavior](https://github.com/android/platform_frameworks_support/blob/master/design/src/android/support/design/widget/AppBarLayout.java#L738) 和 [FloatingActionButtion.Behavior](https://android.googlesource.com/platform/frameworks/support/+/master/design/src/android/support/design/widget/FloatingActionButton.java#L554) 这两个示例。

## 第三方滚动和视差效果库

除了使用上述的 `CoordinatorLayout`，还可以查看[这些流行的第三方库](/android/Must-Have-Libraries#scrolling-and-parallax)来实现 `ScrollView`， `ListView`， `ViewPager` 和 `RecyclerView` 间的滚动和视差效果。

## 将 Google Map 嵌入 AppBarLayout

由于这个已被确认的 [issue](https://code.google.com/p/android/issues/detail?id=188487)，目前在 `AppBarLayout` 中还不支持使用 Google Map。在 v23.1.0 版本的 support design library 的更新中提供了一个 `setOnDragListener()` 方法，如果在此布局中需要拖拽效果的话，这个方法将非常有用。然而，它似乎不影响滚动，如这篇[博文](http://android-developers.blogspot.com/2015/10/android-support-library-231.html?linkId=17977963)所述。

## 参考

* [http://android-developers.blogspot.com/2015/05/android-design-support-library.html](http://android-developers.blogspot.com/2015/05/android-design-support-library.html)
* [http://android-developers.blogspot.com/2016/02/android-support-library-232.html](http://android-developers.blogspot.com/2016/02/android-support-library-232.html)
* [http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031](http://code.tutsplus.com/articles/how-to-use-bottom-sheets-with-the-design-support-library--cms-26031)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
