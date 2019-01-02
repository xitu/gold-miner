> * 原文链接 : [How to hide/show Toolbar when list is scroling (part 1) · Michał Z.](https://mzgreen.github.io/2015/02/15/How-to-hideshow-Toolbar-when-list-is-scroling(part1)/)
* 原文作者 : [Michał Z.](https://twitter.com/mzmzgreen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Mi&Jack](https://github.com/mijack)
* 校对者 : [@laobie](https://github.com/laobie)
* 状态 :  翻译完成

# 让 Toolbar 随着 RecyclerView 的滚动而显示/隐藏

这篇文章是过时的，你应该跳到[第三部分 3](https://mzgreen.github.io/2015/06/23/How-to-hideshow-Toolbar-when-list-is-scrolling%28part3%29/)。

在这篇文章中，我们将看到如何实现像Google+ 应用程序一样，当列表下滑时，Toolbar和FAB（包括其他的View）隐藏；当列表上滑时，Toolbar和FAB（包括其他的View）显示的效果；这种效果在[Material Design Checklist](http://android-developers.blogspot.com/2014/10/material-design-on-android-checklist.html)提到过.

>“在一些场景下，当屏幕向上滚动时，app bar将会从屏幕上移除，给内容留出更多的空间。相反，当向上滚动时，app bar应再次显示。

我们的目标效果如下图所示：

![](https://mzgreen.github.io/images/1/demo_gif.gif)

我们将使用为我们的列表使用`RecyclerView`，当然，你也可以选择其他滚动控件（例如` ListView `)，但它就意味着更多的编码。现在，我有两种具体的实现方法：

1. 给List设置padding
2. 给List添加一个headr

我只是决定执行第二个方案，因为我发现在如何给`RecyclerView`添加header这一问题上，有很多需要注意的地方，这是一个很好的机会去解决他们。
我也将简要描述第一个方案。

###我们开始吧

我们要创建一个工程，并添加如下依赖：
```
    dependencies {
      compile fileTree(dir: 'libs', include: ['*.jar'])
      compile 'com.android.support:appcompat-v7:21.0.3'
      compile "com.android.support:recyclerview-v7:21.0.0"
      compile 'com.android.support:cardview-v7:21.0.3'
    }
```

现在我们应该定义`style.xml`，我们的应用程序将使用Material的主题,但我们不使用` ActionBar `（取而代之是`Toolbar`）：


```
<style name="AppTheme" parent="Theme.AppCompat.Light.NoActionBar">
  <item name="colorPrimary">@color/color_primary</item>
  <item name="colorPrimaryDark">@color/color_primary_dark</item>
</style>
```

接下来是创建`Activity`的布局：

```
<FrameLayout
	xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

	<android.support.v7.widget.RecyclerView
    	android:id="@+id/recyclerView"
        android:layout_width="match_parent"
        android:layout_height="match_parent">

		<android.support.v7.widget.Toolbar
        	android:id="@+id/toolbar"
        	android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary">

			<ImageButton
                android:id="@+id/fabButton"
                android:layout_width="56dp"
                android:layout_height="56dp"
                android:layout_gravity="bottom|right"
                android:layout_marginbottom="16dp"
                android:layout_marginright="16dp"
                android:background="@drawable/fab_background"
                android:src="@drawable/ic_favorite_outline_white_24dp"
                android:contentdescription="@null">
            </ImageButton>
        </android.support.v7.widget.Toolbar>
    </android.support.v7.widget.RecyclerView>
</FrameLayout>
```

这是一个简单的布局，只有`RecyclerView`、`Toolbar`以及作为FAB的`ImageButton`。我们需要把它们放在一个`FrameLayout`，因为这样可以达到`Toolbar`覆盖` RecyclerView`的效果。如果我们不这样做，当我们隐藏Toolbar的时候在列表的上方将会有一个空白的空间。


让我们来看看`MainActiviy`的代码吧：
```
public class MainActivity extends ActionBarActivity {
  private Toolbar mToolbar;
  private ImageButton mFabButton;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    initToolbar();
    mFabButton = (ImageButton) findViewById(R.id.fabButton);
    initRecyclerView();
  }

  private void initToolbar() {
    mToolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(mToolbar);
    setTitle(getString(R.string.app_name));
    mToolbar.setTitleTextColor(getResources().getColor(android.R.color.white));
  }

  private void initRecyclerView() {
    RecyclerView recyclerView = (RecyclerView) findViewById(R.id.recyclerView);
    recyclerView.setLayoutManager(new LinearLayoutManager(this));
    RecyclerAdapter recyclerAdapter = new RecyclerAdapter(createItemList());
    recyclerView.setAdapter(recyclerAdapter);
  }

}
```

正如你所看到的，这是一个十分简单的类，它只实现onCreate()方法，做了以下事情：

1. 初始化 `Toolbar`
2. 获取FAB
3. 初始化 `RecyclerView`

现在我们将为`RecylerView`创建adapter。在这之前，我们需要添加list item的布局：

```
<?xml version="1.0" encoding="utf-8"?>
<android.support.v7.widget.cardview
	xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:card_view="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_gravity="center"
    android:layout_margin="8dp"
    card_view:cardcornerradius="4dp">

    <TextView
    	android:id="@+id/itemTextView"
    	android:layout_width="match_parent"
        android:layout_height="?attr/listPreferredItemHeight"
        android:gravity="center_vertical"
        android:padding="8dp"
        style="@style/Base.TextAppearance.AppCompat.Body2">
    </TextView>
</android.support.v7.widget.cardview>
```

对应的`ViewHolder`如下:

```
public class RecyclerItemViewHolder extends RecyclerView.ViewHolder {
  private final TextView mItemTextView;

  public RecyclerItemViewHolder(final View parent, TextView itemTextView) {
    super(parent);
    mItemTextView = itemTextView;
  }

  public static RecyclerItemViewHolder newInstance(View parent) {
    TextView itemTextView = (TextView) parent.findViewById(R.id.itemTextView);
    return new RecyclerItemViewHolder(parent, itemTextView);
  }

  public void setItemText(CharSequence text) {
    mItemTextView.setText(text);
  }

}
```
我们的列表用于呈现带有文本的卡片 - 简单吧！

现在，我们看一下`RecyclerAdapter`的代码：
```
public class RecyclerAdapter extends RecyclerView.Adapter<recyclerview.viewholder> {
  private List<string> mItemList;

  public RecyclerAdapter(List<string> itemList) {
    mItemList = itemList;
  }

  @Override
  public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
    final View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_item, parent, false);
    return RecyclerItemViewHolder.newInstance(view);
  }

  @Override
  public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
    RecyclerItemViewHolder holder = (RecyclerItemViewHolder) viewHolder;
    String itemText = mItemList.get(position);
    holder.setItemText(itemText);
  }

  @Override
  public int getItemCount() {
    return mItemList == null ? 0 : mItemList.size();
  }

}
```

这个是`RecyclerView.Adapter`的基本实现。并没有什么特殊的东西。如果，你想深入了解 `RecyclerView`,我建议你好好的阅读一下Mark Allison的[文章](https://blog.stylingandroid.com/material-part-4/)

我们写好以上代码，运行一下！截图如下：

![](https://mzgreen.github.io/images/1/clipped.png)

等一下，那是什么？你注意到没有？`Toolbar`把我们的列表挡住了。那是因为我们在`activity_main.xml`中设置`FrameLayout`为根布局。在开始的时候，我们提到过，这里有两种解决方案。第一张就是给`RecyclerView`设置paddingTop，其高度和`Toolbar`保持一致。但是还有一些细节需要注意，因为默认情况下，控件的绘制区域是在padding里面的，所以我们需要将其关闭，具体代码如下:

    <android.support.v7.widget.recyclerview
    	android:id="@+id/recyclerView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:paddingtop="?attr/actionBarSize"
        android:cliptopadding="false"
    </android.support.v7.widget.recyclerview>


这样做，可以达到效果。但是，我想告诉你另一种实现方式-也许有点复杂，涉及增加了头的列表。

###为`RecyclerView`添加Header

首先，我们需要对Adapter做一些更改：

```
public class RecyclerAdapter extends RecyclerView.Adapter<recyclerview.viewholder> {
  //added view types
  private static final int TYPE_HEADER = 2;
  private static final int TYPE_ITEM = 1;

  private List<string> mItemList;

  public RecyclerAdapter(List<string> itemList) {
    mItemList = itemList;
  }

  //modified creating viewholder, so it creates appropriate holder for a given viewType
  @Override
  public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
    Context context = parent.getContext();
    if (viewType == TYPE_ITEM) {
      final View view = LayoutInflater.from(context).inflate(R.layout.recycler_item, parent, false);
      return RecyclerItemViewHolder.newInstance(view);
    } else if (viewType == TYPE_HEADER) {
      final View view = LayoutInflater.from(context).inflate(R.layout.recycler_header, parent, false);
      return new RecyclerHeaderViewHolder(view);
    }
    throw new RuntimeException("There is no type that matches the type " + viewType + " + make sure your using types    correctly");
  }

  //modifed ViewHolder binding so it binds a correct View for the Adapter
  @Override
  public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
    if (!isPositionHeader(position)) {
      RecyclerItemViewHolder holder = (RecyclerItemViewHolder) viewHolder;
      String itemText = mItemList.get(position - 1); // we are taking header in to account so all of our items are correctly positioned
      holder.setItemText(itemText);
    }
  }

  //our old getItemCount()
  public int getBasicItemCount() {
    return mItemList == null ? 0 : mItemList.size();
  }

  //our new getItemCount() that includes header View
  @Override
  public int getItemCount() {
    return getBasicItemCount() + 1; // header
  }

  //added a method that returns viewType for a given position
  @Override
  public int getItemViewType(int position) {
    if (isPositionHeader(position)) {
    return TYPE_HEADER;
    }
    return TYPE_ITEM;
  }

  //added a method to check if given position is a header
  private boolean isPositionHeader(int position) {
    return position == 0;
  }

}
```

代码的具体思路如下：

1. 我们需要为`Recycler`展示的不同的Item定义不同的Item Type。` RecyclerView `是一个非常灵活的组件。当您希望为您的列表项目有不同的布局时，可以使用Item Type。而这正是我们想要做的，我们的第一个Item将是一个标题视图，不同于其他的项目(lines 3-4).
2. 我们需要告诉`Recycler`，返回哪个类型用于显示(lines 49-54).
3. 我们需要修改` onCreateViewHolder `和` onBindViewHolder `方法，根据type的不同TYPE_ITEM或者TYPE_HEAD，返回相应的item(lines 14-34).
4. 我们需要修改 `getItemCount()` - 返回的总数为数据集总数 + 1，因为我们还有一个Header（line 43-45）。现在，我们创建一个布局，并为其添加一个`ViewHolder`。


```
    <view xmlns:android="http://schemas.android.com/apk/res/android"
    	android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize">
    </view>
```

布局很简单。重要的是要注意的是，它的高度需要是等于`Toolbar`的高度。这是` viewholder `，也很简单：


    public class RecyclerHeaderViewHolder extends RecyclerView.ViewHolder {
      public RecyclerHeaderViewHolder(View itemView) {
      	super(itemView);
      }
    }

![](https://mzgreen.github.io/images/1/clipping_fixed.png)
好了，我们完成了！截图如上：


好多了，对吗？所以，综上所述，我们需要为RecyclerView增加了一个Header。它和Toolbar高度相同，它是一个空视图。toolbar刚好将其挡住，而其他的视图可以恰当好处的显示。接下来我们可以实现列表滚动时显示/隐藏视图。

###在列表滚动的时候显示/隐藏View

为了实现这个效果，我们将为`RecyclerView`创建一个类` onscrolllistener`。


	public abstract class HidingScrollListener extends RecyclerView.OnScrollListener {
      private static final int HIDE_THRESHOLD = 20;
      private int scrolledDistance = 0;
      private boolean controlsVisible = true;

      @Override
      public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
		super.onScrolled(recyclerView, dx, dy);
        if (scrolledDistance > HIDE_THRESHOLD && controlsVisible) {
            onHide();
            controlsVisible = false;
            scrolledDistance = 0;
        } else if (scrolledDistance < -HIDE_THRESHOLD && !controlsVisible) {
        	onShow();
            controlsVisible = true;
            scrolledDistance = 0;
        }
        if((controlsVisible && dy>0) || (!controlsVisible && dy<0)) {
			scrolledDistance += dy;
    	}
      }

      public abstract void onHide();
      public abstract void onShow();

    }

真正起到作用的方法就是你现在看到的方法` onscrolled() `方法。它的参数——dx，dy是水平和垂直滚动的量。其实他们是每次滑动的变化量，是两个前后事件的差，不是总滚动距离。


基本的实现思路如下：

- 我们计算总的滚动距离（每一次滚动的总和）。但是，我们只关心View隐藏时的向上滑动或者View显示时的向下滑动，因为这些是我们所关心的情况。

    if((controlsVisible && dy>0) || (!controlsVisible && dy<0)) {
    	scrolledDistance += dy;
    }


- 如果当滚动值超过某个阈值（你可以设置阈值，值越大，需要滚动滚动更多的距离，才能看到显示/隐藏View的效果）。我们根据滚动的方向来显示/隐藏View（DY＞0意味着我们向下滚动，Dy＜0意味着我们滚动起来）。

    if (scrolledDistance > HIDE_THRESHOLD && controlsVisible) {
      onHide();
      controlsVisible = false;
      scrolledDistance = 0;
    } else if (scrolledDistance < -HIDE_THRESHOLD && !controlsVisible) {
      onShow();
      controlsVisible = true;
      scrolledDistance = 0;
    }

- 事实上，我们不可能在Scroll Listener中显示/隐藏View，更为靠谱的做法是，将其抽象出来，调用show()/hide()方法，所以我们需要在回调中实现它们。

现在，我们需要给`RecyclerView`设置listener:

    private void initRecyclerView() {
      RecyclerView recyclerView = (RecyclerView) findViewById(R.id.recyclerView);
      recyclerView.setLayoutManager(new LinearLayoutManager(this));
      RecyclerAdapter recyclerAdapter = new RecyclerAdapter(createItemList());
      recyclerView.setAdapter(recyclerAdapter);
      //setting up our OnScrollListener
      recyclerView.setOnScrollListener(new HidingScrollListener() {
    @Override
    public void onHide() {
      hideViews();
    }
    @Override
    public void onShow() {
      showViews();
    }
      });
    }

添加下面的方法，可以以动画的形式隐藏或显示View：

	private void hideViews() {
	  mToolbar.animate().translationY(-mToolbar.getHeight()).setInterpolator(new AccelerateInterpolator(2));

	  FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) mFabButton.getLayoutParams();
	  int fabBottomMargin = lp.bottomMargin;
	  mFabButton.animate().translationY(mFabButton.getHeight()+fabBottomMargin).setInterpolator(new AccelerateInterpolator(2)).start();
	}

	private void showViews() {
	  mToolbar.animate().translationY(0).setInterpolator(new DecelerateInterpolator(2));
	  mFabButton.animate().translationY(0).setInterpolator(new DecelerateInterpolator(2)).start();
	}

我们必须把margin作为隐藏Toolbar的参数，否则就不能完全隐藏Fab。

是时候看一下我们的应用程序的效果了！滚动屏幕截图

![](https://mzgreen.github.io/images/1/broken_gif.gif)

它看起来挺不错的，但是有一些小细节需要调整 - 如果你处于列表的顶部，而滑动隐藏的阈值设置的很小，那么即使在列表为空的情况下，你也可以隐藏`ToolBar`.幸运的是，这个问题很容易解决。我们需要做的是检测列表的第一项是否是可见的，从而根据实际情况调整`ToolBar`的显示/隐藏。

    @Override
    public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
      super.onScrolled(recyclerView, dx, dy);

      int firstVisibleItem = ((LinearLayoutManager) recyclerView.getLayoutManager()).findFirstVisibleItemPosition();
      //show views if first item is first visible position and views are hidden
      if (firstVisibleItem == 0) {
    if(!controlsVisible) {
      onShow();
      controlsVisible = true;
    }
      } else {
    if (scrolledDistance > HIDE_THRESHOLD && controlsVisible) {
      onHide();
      controlsVisible = false;
      scrolledDistance = 0;
    } else if (scrolledDistance < -HIDE_THRESHOLD && !controlsVisible) {
      onShow();
      controlsVisible = true;
      scrolledDistance = 0;
    }
      }

      if((controlsVisible && dy>0) || (!controlsVisible && dy<0)) {
    scrolledDistance += dy;
      }
    }

更改以后，当第一项是可见的时候，Header不会消失。接着向下滑的时候，其他的效果还是和之前的一样再次运行我们的项目，实际效果如下：

![](https://mzgreen.github.io/images/1/demo_gif.gif)

Yup! 现在看上去很不错哦！


这是我第一次写的博客，所以可能存在着一些错误，以后我会有所提高的。

如果你不想使用添加Head的方式，你也可以使用第二种给RecyclerView添加padding的方式。只需要加上padding，然后使用我们之前创建的 HidingScrollListener ，就可以实现了: )

在下一个部分，我将告诉你如何做出像Google Play一样的效果。

如果你有什么疑问，你可以在下面的评论区评论。
###代码

这篇文章提到的所有源代码，你都可以在[对应的Github仓库](https://github.com/mzgreen/HideOnScrollExample)上找到.

感谢[Mirek Stanek](https://twitter.com/froger_mcs)作为这篇文章的内测读者.

- Michał Z.

如果你喜欢这篇文章，你可以[把他分享给你的关注者](https://twitter.com/intent/tweet?url=http://mzgreen.github.io/2015/02/15/How-to-hideshow-Toolbar-when-list-is-scroling(part1)/&text=How%20to%20hide/show%20Toolbar%20when%20list%20is%20scroling%20(part%201)&via=mzmzgreen) 或者在[Twitter](https://twitter.com/mzmzgreen)关注我!
