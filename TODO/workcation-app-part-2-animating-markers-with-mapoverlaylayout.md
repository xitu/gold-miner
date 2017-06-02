> * 原文地址：[Workcation App – Part 2. Animating Markers with MapOverlayLayout](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[龙骑将杨影枫](https://github.com/stormrabbit)
> * 校对者：[Vivienmm](https://github.com/Vivienmm)、[张拭心](https://github.com/shixinzhang)

#  Workcation App – 第二部分 . Animating Markers 和 MapOverlayLayout #

欢迎阅读本系列文章的第二篇，此系列文章和我前一段时间完成的“研究发”项目有关。在文章里，我会针对开发中遇到的动画问题分享一些解决办法。

Part 1: [自定义 Fragment  转场](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)

Part 2: [带有动画的标记（Animating Markers） 与 MapOverlayLayout ](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-2-animating-markers-with-mapoverlaylayout.md)

Part 3: [带有动画的标记（Animated Markers） 与 RecyclerView 的互动](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-3-recyclerview-interaction-with-animated-markers.md)

Part 4: [场景（Scenes）和 RecyclerView 的共享元素转场动画（Shared Element Transition）](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-4-shared-element-transition-recyclerview-scenes.md)

项目的 Git 地址:  [Workcation App](https://github.com/panwrona/Workcation)

动画的 Dribbble 地址: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)

# 序言

几个月前我们开了一个部门会议，在会议上我的朋友 Paweł Szymankiewicz 给我演示了他在自己的“研发”项目上制作的动画。我非常喜欢这个动画，会后决定用代码实现它。我可没想到到我会摊上啥...

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083)

GIF 1 **“动画效果”**

# 开始吧！

就像上面 GIF 动画展示的，需要做的事情有很多。

1. 在点击底部菜单栏最右方的菜单后，我们会跳转到一个新界面。在此界面中，地图通过缩放和渐显的转场动画在屏幕上方加载，Recycleview 的 item 随着转场动画从底部加载，地图上的标记点在转场动画执行的同时被添加到地图上.

2. 当滑动底部的 RecycleView item 的时候，地图上的标记会通过闪烁来显示它们的位置(译者注：原文是show their **position** on the map，个人认为 position 有两层含义：一代表标记在地图上的位置，二代表标记所对应的 item 在 RecycleView 里序列的位置。)

3. 在点击一个 item 以后，我们会进入到新界面。在此界面中，地图通过动画方式来显示出路径以及起始/结束标记。同时此 RecyclerView 的item 会通过转场动画展示一些关于此地点的描述，背景图片也会放大，还附有更详细的信息和一个按钮。

4. 当后退时，详情页通过转场变成普通的 RecycleView Item，所有的地图标记再次显示，同时路径一起消失。

就这么多啦，这就是我准备在这一系列文章中向你展示的东西。在本文中我会编写地图加载以及神秘的 MapWrapperLayout。敬请期待！


# 需求

所以下一步的需求是：加载地图时展示所有由 API (一个解析 assets 文件夹中 JSON 文件的简单单例)提供的标记。幸运的是，[前一章节](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)里我们已经描述过这些标记了。再下一步的需求是：使用渐显和缩放动画来加载这些标记。听起来很简单，但理想和现实总是有差距的。

不幸的是，谷歌地图 API 只允许我们传递 BitmapDescriptor 类型的标记图标做参数，就像下面那样：

```
Java

GoogleMap map=...// 获得地图

   // 通过蓝色的标记标注旧金山的位置

   Marker marker=map.add(new MarkerOptions()

       .position(new LatLng(37.7750,122.4183))

       .title("San Francisco")

       .snippet("Population: 776733"))

       .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE));
```


如[效果](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/#animation)所示，我们需要在加载时实现标记渐显和缩放动画，滑动 RecycleView 的时候实现标记闪烁动画，进入详情页面的时候让标记在渐隐动画中隐藏。使用帧动画或者属性动画（Animation/ViewPropertyAnimator API）会更合理一些.我们有解决这个问题的方法吗？当然，我们有！


## MapOverlayLayout

该怎么办呢？其实很简单，但我还是花了点时间才弄明白。我们需要在 SupportMapFragment 上（注：也就是上一篇提到的 MapFragment）添加一层使用谷歌地图 API 所获得的 MapOverlayLayout，在该层上添加地图的映射（映射是用来转换屏幕上的的坐标和地理位置的实际坐标，参见[此文档](https://developers.google.com/android/reference/com/google/android/gms/maps/Projection)）。

**注：此处作者 via以后就没东西了，我估计是手滑写错了。下面有个一模一样的句子，但是多了一个说明，故此处按照下文翻译。**

类 MapOverlayLayout 是一个自定义的 帧布局（FrameLayout），该布局和 MapFragment 大小位置完全相同。当地图加载完毕的时候，我们可以将 MapOverlayLayout 作为参数传递给 MapFragment，通过它用动画加载自定义的 View 、根据手势移动地图镜头之类的事情。当然了，我们可以做现在需要的事情 —— 通过缩放和渐显动画添加标记 （也就是现在的自定义 View)、隐藏标记、当滑动 RecycleView 让标记开始闪烁。

## MapOverlayLayout – 添加

怎么样用 SupportMapFragment 和 谷歌地图添加一个 MapOverlayLayout 呢？

第一步,让我们先看看 DetailsFragment 的 XML 文件:

```

<android.support.design.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"

    android:layout_width="match_parent"

    android:layout_height="match_parent"

    android:orientation="vertical">



    <fragment

        android:id="@+id/mapFragment"

        class="com.google.android.gms.maps.SupportMapFragment"

        android:layout_width="match_parent"

        android:layout_height="match_parent"

        android:layout_marginBottom="@dimen/map_margin_bottom"/>



    <com.droidsonroids.workcation.common.maps.PulseOverlayLayout

        android:id="@+id/mapOverlayLayout"

        android:layout_width="match_parent"

        android:layout_height="match_parent"

        android:layout_marginBottom="@dimen/map_margin_bottom">



        <ImageView

            android:id="@+id/mapPlaceholder"

            android:layout_width="match_parent"

            android:layout_height="match_parent"

            android:transitionName="@string/mapPlaceholderTransition"/>



        </com.droidsonroids.workcation.common.maps.PulseOverlayLayout>

    ...

</android.support.design.widget.CoordinatorLayout>
```

如我们所见，有一个和 SupportMapFragment 尺寸相同、位置（marginBottom）也一样的 PulseOverlayLayout 盖在（SupportMapFragment ）上面。PulseOverlayLayout 继承自 MapOverlayLayout，根据 app 需要添加了自己独有的逻辑（比如说 点击 RecycleView 时在界面上添加开始标记与结束标记，创建 PulseMarkerView _ 一个在之后会解释的自定义 View）。在布局中还包含一个 ImageView，这是我[之前](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)准备创建的转场动画的占位符。 xml  的工作就完成了，现在就开始专注于代码实现 —— DetailsFragment。

现在就开始专注于代码实现 DetailsFragment。

```
public class DetailsFragment extends MvpFragment<DetailsFragmentView,DetailsFragmentPresenter>

        implements DetailsFragmentView, OnMapReadyCallback{

    public static final String TAG = DetailsFragment.class.getSimpleName();



    @BindView(R.id.recyclerview)
    RecyclerView recyclerView;

    @BindView(R.id.container)
    FrameLayout containerLayout;

    @BindView(R.id.mapPlaceholder)
    ImageView mapPlaceholder;

    @BindView(R.id.mapOverlayLayout)
    PulseOverlayLayout mapOverlayLayout;



    @Override

    public void onViewCreated(final View view,@Nullable final Bundle savedInstanceState){

        super.onViewCreated(view,savedInstanceState);

        setupBaliData();

        setupMapFragment();

    }



    private void setupBaliData(){

        presenter.provideBaliData();

    }



    private void setupMapFragment(){

        ((SupportMapFragment)getChildFragmentManager().findFragmentById(R.id.mapFragment)).getMapAsync(this);

    }



    @Override

    public void onMapReady(final GoogleMap googleMap){

        mapOverlayLayout.setupMap(googleMap);

        setupGoogleMap();

    }



    private void setupGoogleMap(){

        presenter.moveMapAndAddMarker();

    }



    @Override

    public void provideBaliData(final List<Place>places){

        baliPlaces=places;

    }



    @Override

    public void moveMapAndAddMaker(final LatLngBounds latLngBounds){

        mapOverlayLayout.moveCamera(latLngBounds);

        mapOverlayLayout.setOnCameraIdleListener(()->{

            for(int i=0;i<baliPlaces.size();i++){

                mapOverlayLayout.createAndShowMarker(i,baliPlaces.get(i).getLatLng());

            }

            mapOverlayLayout.setOnCameraIdleListener(null);

        });

        mapOverlayLayout.setOnCameraMoveListener(mapOverlayLayout::refresh);

    }

}
```

如上所示，地图通过 **onMapReady** 和上一篇一样进行加载。在接收回调后。我们就可以更新地图的边界，在 MapOverlayLayout 添加标记，设置监听。

在下面的代码中，我们会把地图镜头移动到可以展示我们所有标记的地方。然后当镜头移动完毕时，在地图上创造并展示标记。在这之后，我们设置 OnCameraIdleListener  空（null）。因为我们希望再次移动镜头时不要添加标记。在最后一行代码中，我们为 OnCameraMoveListener 设置了刷新所有标记位置的动作。

```
@Override

    public void moveMapAndAddMaker(final LatLngBounds latLngBounds){

        mapOverlayLayout.moveCamera(latLngBounds);

        mapOverlayLayout.setOnCameraIdleListener(()->{

            for(int i=0;i<baliPlaces.size();i++){

                mapOverlayLayout.createAndShowMarker(i,baliPlaces.get(i).getLatLng());

            }

            mapOverlayLayout.setOnCameraIdleListener(null);

        });

        mapOverlayLayout.setOnCameraMoveListener(mapOverlayLayout::refresh);

    }
```

## MapOverlayLayout – 它是怎么工作的呢？

那么它究竟是如何工作的呢？

通过地图映射(映射是用来转换屏幕上的的坐标和地理位置的实际坐标，参见[此文档](https://developers.google.com/android/reference/com/google/android/gms/maps/Projection))。我们可以拿到标记的横坐标与纵坐标，通过坐标来在 MapOverlayLayout 上放置标记的自定义 View。

这种做法可以让我们使用比如自定义 View 的属性动画（ViewPropertyAnimator ）API 创建动画效果。

```
public class MapOverlayLayout<V extends MarkerView> extends FrameLayout{



    protected List<V> markersList;

    protected Polyline currentPolyline;

    protected GoogleMap googleMap;

    protected ArrayList<LatLng>polylines;



    public MapOverlayLayout(final Context context){

        this(context,null);

    }



    public MapOverlayLayout(final Context context,final AttributeSet attrs){

        super(context,attrs);

        markersList=newArrayList<>();

    }



    protected void addMarker(final V view){

        markersList.add(view);

        addView(view);

    }



    protected void removeMarker(final V view){

        markersList.remove(view);

        removeView(view);

    }



    public void showMarker(final int position){

        markersList.get(position).show();

    }



    private void refresh(final int position,final Point point){

        markersList.get(position).refresh(point);

    }



    public void setupMap(final GoogleMap googleMap){

        this.googleMap = googleMap;

    }



    public void refresh(){

        Projection projection=googleMap.getProjection();

        for(int i=0;i<markersList.size();i++){

            refresh(i,projection.toScreenLocation(markersList.get(i).latLng()));

        }

    }



    public void setOnCameraIdleListener(final GoogleMap.OnCameraIdleListener listener){

        googleMap.setOnCameraIdleListener(listener);

    }



    public void setOnCameraMoveListener(final GoogleMap.OnCameraMoveListener listener){

        googleMap.setOnCameraMoveListener(listener);

    }



    public void moveCamera(final LatLngBounds latLngBounds){

        googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(latLngBounds,150));

    }

}
```

解释一下在 **moveMapAndAddMarker** 里调用的方法：为 CameraListeners 监听提供了 set 方法；**刷新**方法是为了更新标记的位置；**addMarker** 和 **removeMarker** 是用来添加 MarkerView (也就是上文所说的自定义 view )到布局和列表中。通过这个方案，MapOverlayLayout持有了所有被添加到自身的 View 引用。在类的最上面的是继承自 自定义 View —— MarkerView —— 的泛型。MarkerView 是一个继承自 View 的抽象类，看起来像这样：

```
public abstract class MarkerView extends View{



    protected Point point;

    protected LatLng latLng;



    private MarkerView(final Context context){

        super(context);

    }



    public MarkerView (final Context context,final LatLng latLng,final Point point){

        this(context);

        this.latLng=latLng;

        this.point=point;

    }



    public double lat(){

        return latLng.latitude;

    }



    public double lng(){

        return latLng.longitude;

    }



    public Point point(){

        return point;

    }



    public LatLng latLng(){

        return latLng;

    }



    public abstract voi dshow();



    public abstract void hide();



    public abstract void refresh(final Point point);

}
```

通过抽象方法 **show, hide** 和 **refresh** ，我们能够指定该标记显示、消失和刷新的方式。它还需要 Context 对象、经纬度和在屏幕上的坐标点。我们一起来看看它的实现类：

```
public class PulseMarkerView extends MarkerView{

    private static final int STROKE_DIMEN=2;



    private Animation scaleAnimation;

    private Paint strokeBackgroundPaint;

    private Paint backgroundPaint;

    private String text;

    private Paint textPaint;

    private AnimatorSet showAnimatorSet,hideAnimatorSet;



    public PulseMarkerView(final Context context,final LatLng latLng,final Point point){

        super(context,latLng,point);

        this.context=context;

        setVisibility(View.INVISIBLE);

        setupSizes(context);

        setupScaleAnimation(context);

        setupBackgroundPaint(context);

        setupStrokeBackgroundPaint(context);

        setupTextPaint(context);

        setupShowAnimatorSet();

        setupHideAnimatorSet();

    }



    public PulseMarkerView(final Context context,final LatLng latLng,final Point point,final int position){

        this(context,latLng,point);

        text=String.valueOf(position);

    }



    private void setupHideAnimatorSet(){

        Animator animatorScaleX=ObjectAnimator.ofFloat(this,View.SCALE_X,1.0f,0.f);

        Animator animatorScaleY=ObjectAnimator.ofFloat(this,View.SCALE_Y,1.0f,0.f);

        Animator animator=ObjectAnimator.ofFloat(this,View.ALPHA,1.f,0.f).setDuration(300);

        animator.addListener(newAnimatorListenerAdapter(){

            @Override

            publicvoidonAnimationStart(finalAnimator animation){

                super.onAnimationStart(animation);

                setVisibility(View.INVISIBLE);

                invalidate();

            }

        });

        hideAnimatorSet=newAnimatorSet();

        hideAnimatorSet.playTogether(animator,animatorScaleX,animatorScaleY);

    }



    private void setupSizes(finalContext context){

        size=GuiUtils.dpToPx(context,32)/2;

    }



    private void setupShowAnimatorSet(){

        Animator animatorScaleX=ObjectAnimator.ofFloat(this,View.SCALE_X,1.5f,1.f);

        Animator animatorScaleY=ObjectAnimator.ofFloat(this,View.SCALE_Y,1.5f,1.f);

        Animator animator=ObjectAnimator.ofFloat(this,View.ALPHA,0.f,1.f).setDuration(300);

        animator.addListener(newAnimatorListenerAdapter(){

            @Override

            public void onAnimationStart(finalAnimator animation){

                super.onAnimationStart(animation);

                setVisibility(View.VISIBLE);

                invalidate();

            }

        });

        showAnimatorSet = newAnimatorSet();

        showAnimatorSet.playTogether(animator,animatorScaleX,animatorScaleY);

    }



    private void setupScaleAnimation(final Context context){

        scaleAnimation=AnimationUtils.loadAnimation(context,R.anim.pulse);

        scaleAnimation.setDuration(100);

    }



    private void setupTextPaint(final Context context){

        textPaint=newPaint();

        textPaint.setColor(ContextCompat.getColor(context,R.color.white));

        textPaint.setTextAlign(Paint.Align.CENTER);

        textPaint.setTextSize(context.getResources().getDimensionPixelSize(R.dimen.textsize_medium));

    }



    private void setupStrokeBackgroundPaint(final Context context){

        strokeBackgroundPaint=newPaint();

        strokeBackgroundPaint.setColor(ContextCompat.getColor(context,android.R.color.white));

        strokeBackgroundPaint.setStyle(Paint.Style.STROKE);

        strokeBackgroundPaint.setAntiAlias(true);

        strokeBackgroundPaint.setStrokeWidth(GuiUtils.dpToPx(context,STROKE_DIMEN));

    }



    private void setupBackgroundPaint(final Context context){

        backgroundPaint=newPaint();

        backgroundPaint.setColor(ContextCompat.getColor(context,android.R.color.holo_red_dark));

        backgroundPaint.setAntiAlias(true);

    }



    @Override

    public void setLayoutParams(final ViewGroup.LayoutParams params){

        FrameLayout.LayoutParams frameParams=newFrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,FrameLayout.LayoutParams.WRAP_CONTENT);

        frameParams.width=(int)GuiUtils.dpToPx(context,44);

        frameParams.height=(int)GuiUtils.dpToPx(context,44);

        frameParams.leftMargin=point.x-frameParams.width/2;

        frameParams.topMargin=point.y-frameParams.height/2;

        super.setLayoutParams(frameParams);

    }



    public void pulse(){

        startAnimation(scaleAnimation);

    }



    @Override

    protected void onDraw(final Canvas canvas){

        drawBackground(canvas);

        drawStrokeBackground(canvas);

        drawText(canvas);

        super.onDraw(canvas);

    }



    private void drawText(final Canvas canvas){

        if(text!=null&&!TextUtils.isEmpty(text))

            canvas.drawText(text,size,(size-((textPaint.descent()+textPaint.ascent())/2)),textPaint);

    }



    private void drawStrokeBackground(final Canvas canvas){

        canvas.drawCircle(size,size,GuiUtils.dpToPx(context,28)/2,strokeBackgroundPaint);

    }



    private void drawBackground(final Canvas canvas){

        canvas.drawCircle(size,size,size,backgroundPaint);

    }



    public void setText(Stringtext){

        this.text=text;

        invalidate();

    }



    @Override

    public void hide(){

        hideAnimatorSet.start();

    }



    @Override

    public void refresh(finalPoint point){

        this.point=point;

        updatePulseViewLayoutParams(point);

    }



    @Override

    public void show(){

        showAnimatorSet.start();

    }



    public void showWithDelay(final int delay){

        showAnimatorSet.setStartDelay(delay);

        showAnimatorSet.start();

    }



    public void updatePulseViewLayoutParams(final Point point){

        this.point=point;

        FrameLayout.LayoutParams params=newFrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,FrameLayout.LayoutParams.WRAP_CONTENT);

        params.width=(int)GuiUtils.dpToPx(context,44);

        params.height=(int)GuiUtils.dpToPx(context,44);

        params.leftMargin=point.x-params.width/2;

        params.topMargin=point.y-params.height/2;

        super.setLayoutParams(params);

        invalidate();

    }

}
```

这是继承自 MarkerView 的 PulseMarkerView。在构造方法（constructor）中，我们设置一个显示、消失和闪烁的动画序列(AnimatorSets)。在重写 MarkerView 的方法里，我们只是单纯的启动了这个动画序列。**updatePulseViewLayoutParams** 中更新了屏幕上的 PulseViewMarker。接下来就是使用构造方法里创建的 Paints 来绘制界面。

效果：

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/load_markers_pulse.gif?x77083)


**加载地图和滑动 RecycleView**

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/moving_map.gif?x77083)


**移动地图镜头时刷新标记**

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/zooming_map.gif?x77083)


**地图缩放**

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/zooming_pulsing.gif?x77083)


**缩放和滚动效果**

# 总结


如上所示，这种做法有一个巨大的优势 —— 我们可以广泛的使用自定义 View 的力量。不过呢，移动地图和刷新标记位置的时候会有一点小延迟。和完成的需求相比，这是可以可以接受的代价。

多谢阅读！下一篇会在周二 14:03 更新。如果有任何疑问，欢迎评论。如果觉得有帮助的话，不要忘记分享哟。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
