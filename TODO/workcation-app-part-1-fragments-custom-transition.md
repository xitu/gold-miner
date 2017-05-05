> * 原文地址：[Workcation App – Part 1. Fragment custom transition](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 1. Fragment custom transition #

#  Workcation App – 第一部分 . 自定义 Fragment 转场动画 #


Welcome to the first of series of posts about my R&D (Research & Development) project I’ve made a while ago. In this blog posts, I want to share my solutions for problems I encountered during the development of an animation idea you’ll see below.

欢迎阅读本系列文章的第一篇，此系列文章和我前一段时间完成的“研究与开发”项目有关。在文章里，我会针对开发中遇到的动画问题分享一些解决办法。

Part 1: [自定义 Fragment  转场](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)

Part 2: [Animating Markers 与 MapOverlayLayout ](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-2-animating-markers-with-mapoverlaylayout.md)

Part 3: [RecyclerView interaction 与 Animated Markers](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-3-recyclerview-interaction-with-animated-markers.md)

Part 4: [Shared Element Transition with RecyclerView and Scenes](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-4-shared-element-transition-recyclerview-scenes.md)

 

项目的 Git 地址:  [Workcation App](https://github.com/panwrona/Workcation)

动画的 Dribbble 地址: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)

# Prelude #

# 序言 #

A few months back we’ve had a company meeting, where my friend Paweł Szymankiewicz showed the animation he’d done during his Research & Development. And I loved it. After the meeting, I decided that I will code it. I never knew what I’m going to struggle with…

几个月前我们开了一个部门会议，在会议上我的朋友 Paweł Szymankiewicz 给我演示了他在自己的“研究与开发”项目上制作的动画。我非常喜欢这个动画，在开完会以后我准备把用代码实现它。我可没想到到我会摊上啥...

 

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083) 

GIF 1 *“The animation”*

GIF 1 *“动画效果”*

# Let’s start! 

# 开始吧！

As we can see in the GIF above, there is a lot of going on.

就像上面 GIF 动画展示的，需要做的事情有很多。

1. After clicking on the bottom menu item, we are moving to the next screen, where we can see the map being loaded with some scale/fade animation from the top, RecyclerView items loaded with translation from the bottom, markers added to the map with scale/fade animation.

1. 在点击底部菜单栏最右方的菜单后，我们会跳转到一个新界面。在此界面中，我们可以看到地图通过缩放和渐显的转场动画被加载到屏幕上方，Recycleview 的 item 随着转场动画加载到屏幕下方，地图上的标记点在转场动画执行的同时被添加到地图上.

2. While scrolling the items in RecyclerView, the markers are pulsing to show their position on the map.

当滑动底部的 RecycleView item 的时候，地图上的标记会根据 RecycleView item 的顺序（position）闪烁。

3. After clicking on the item, we are transferred to the next screen, the map is animated below to show the route and start/finish marker. The RecyclerView’s item is transitioned to show some description, bigger picture, trip details and button.

在点击一个 item 以后，我们会进入到新界面。在此界面中，地图会显示我们到标记点的路径，同时此 RecyclerView 的item 会通过转场动画展示一些关于此地点的描述，背景图片也会放大，还附有更详细的信息和一个按钮。

4. While returning, the transition happens again back to the RecyclerView’s item, all of the markers are shown again, the route disappears.

当后退时，详情页通过转场变成普通的 RecycleView Item，所有的地图标记再次显示，同时路径一起消失。 


Pretty much. That’s why I’ve decided to show you all of the things in the series of posts. In this article I will cover the enter animation of the map fragment.

就这么多啦，这就是我准备在这一系列文章中向你展示的东西。在本文中我会编写进入地图 fragment 的转场动画。

# The Problem 

# 难点 #

As we can see in the GIF 1 above, it looks like the map is already loaded before and just animated to the proper position. This is not happening in the real world. What it really looks like:

就像我们在 GIF 1 里看到的那样，看起来好像地图在移动到正确地点之前已经加载完毕了。这在真实世界里是不可能的，它实际上是这个样子的：

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/map_loading-1.gif?x77083)

# The Solution 

# 需求 #

1. Preload map

    预加载地图

2. When map is loaded, use Google Maps API to get bitmap from it and save it in cache

    加载完毕后，使用 Google Map API 获得地图的快照图片（bitmap）并保存在缓存中。

3. Create custom transition for scale and fade effect of the map when entering *DetailsFragment*

    为地图编写一个包含缩放与渐显的自定义转场动画（transition），进入 **DetailsFragment** 的时候就激活。

# Let’s go! #

# 动手吧!

## Preloading the map ##

## 预加载地图 ##

To achieve that we have to take bitmap snapshot from already loaded map. Of course we can’t do that in the **DetailsFragment** if we want the smooth transition between screens. What we have to do, is to get bitmap underneath the **HomeFragment** and save it in the cache. As you can see, the map have some margin from the bottom, so we also have to fit the “future” map size.

为了实现上述目标，我们首先从已加载的地图上拿到一份快照（snapshot）。当然我们如果想把转场动画做的更平滑一点，肯定不能等进入 **DetailsFragment** 后才获取。所以要怎么做呢？当然是是悄悄的在 **HomeFragment** 里拿到这个图片（bitmap） 并且保存在缓存里啦。地图距离底部还有一点距离（margin），所以我们拿到的图片必须满足"将来的"地图尺寸。

```
XHTML

<?xml version="1.0"encoding="utf-8"?>

<android.support.design.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"

    xmlns:tools="http://schemas.android.com/tools"

    android:layout_width="match_parent"

    android:layout_height="match_parent"

    xmlns:app="http://schemas.android.com/apk/res-auto"

    tools:MContext=".screens.main.MainActivity">

 

    <fragment

        android:id="@+id/mapFragment"

        class="com.google.android.gms.maps.SupportMapFragment"

        android:layout_width="match_parent"

        android:layout_height="match_parent"

        android:layout_marginBottom="@dimen/map_margin_bottom"/>

 

    <LinearLayout

        android:layout_width="match_parent"

        android:layout_height="match_parent"

        android:orientation="vertical"

        android:background="@color/white">

        ...

        ...

        </LinearLayout>

    </android.support.design.widget.CoordinatorLayout>
```

As you can see in the snippet above, the *MapFragment* is placed under the rest of the layout. It will allow us to load the map invisible for the user.

就像上面代码展示的那样，**MapFragment** 被放在布局的最下方，这样我们就可以在用户看不到地方加载地图。

```
public class MainActivity extends MvpActivity<MainView,MainPresenter> implements MainView,OnMapReadyCallback{

    SupportMapFragment mapFragment;

    privateLatLngBounds mapLatLngBounds;

    @Override

    protected void onCreate(Bundle savedInstanceState){

        super.onCreate(savedInstanceState);

        presenter.provideMapLatLngBounds();

        getSupportFragmentManager()

                .beginTransaction()

                .replace(R.id.container,HomeFragment.newInstance(),HomeFragment.TAG)

                .addToBackStack(HomeFragment.TAG)

                .commit();

        mapFragment=(SupportMapFragment)getSupportFragmentManager().findFragmentById(R.id.mapFragment);

        mapFragment.getMapAsync(this);

    }

 

    @Override

    public void setMapLatLngBounds(finalLatLngBounds latLngBounds){

        mapLatLngBounds=latLngBounds;

    }

 

    @Override

    public void onMapReady(final GoogleMap googleMap){

        googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(

                mapLatLngBounds,

                MapsUtil.calculateWidth(getWindowManager()),

                MapsUtil.calculateHeight(getWindowManager(),getResources().getDimensionPixelSize(R.dimen.map_margin_bottom)),

                MapsUtil.DEFAULT_ZOOM));

        googleMap.setOnMapLoadedCallback(()->googleMap.snapshot(presenter::saveBitmap));

    }

}
```

MainActivity inherits from MvpActivity, which is a class from [Mosby Framework](https://github.com/sockeqwe/mosby) created by Hannes Dorfmann. The whole project follows MVP pattern, and the framework I mentioned before is a very nice implementation of it.

MainActivity 继承自 MvpActivity，而 MvpActivity 是来自  Hannes Dorfmann 写的 [Mosby Framework](https://github.com/sockeqwe/mosby)。我的项目都遵从 MVP 模式，而这个框架是一个 MVP 模式的非常好的实现。

In onCreate method we have three things:

在 onCreate 方法里我们做了三件事：

1. We are providing *LatLngBounds* for map – they will be used to set the bounds of the map

 为地图提供了 **LatLngBounds**，他们会被用来添加在地图上的标记

2. We are replacing the *HomeFragment* in activities container layout

 在 activity 的布局里加载了 **HomeFragment**

3. We are setting the *OnMapReadyCallback* on the *MapFragment*

 为 **Mapfragment** 设置了 **OnMapReadyCallback** 的回调。


After map is ready, the *onMapReady()* method is called, and we can do some operations to save the properly loaded map into bitmap. We are moving camera to earlier provided *LatLngBounds* using *CameraUpdateFactory.newLatLngBounds()* method. In our case we know exactly what will be the dimension of the map in the next screen, so we are able to pass *width*(width of screen) and *height*(height of screen with bottom margin) parameters to this method. We are calculating them like this:

当已经准备好加载地图时，就会调用 **onMapReady()** 方法，我们就可以通过一些操作把当前加载的地图转换成 bitmap 图片。通过 **CameraUpdateFactory.newLatLngBounds()** 方法，我们可以把镜头转到之前提供的 **LatLngBounds**  上。这样的话我们就精确的知道下个页面的地图区域，再把屏幕宽度和高度当作参数传入 **onMapReady()** 方法，像这样操作:


```
public static intcalculateWidth(final WindowManager windowManager){

    DisplayMetrics metrics=newDisplayMetrics();

    windowManager.getDefaultDisplay().getMetrics(metrics);

    returnmetrics.widthPixels;

}


public static intcalculateHeight(final WindowManager windowManager,finalintpaddingBottom){

    DisplayMetrics metrics=newDisplayMetrics();

    windowManager.getDefaultDisplay().getMetrics(metrics);

    returnmetrics.heightPixels-paddingBottom;
```

Easy. After *googleMap.moveCamera()* method being called, we are setting the *OnMapLoadedCallback*. When camera is moved to the desired position, the *onMapLoaded()* method is called and we are ready to take bitmap from it.

很简单吧？在调用 **googleMap.moveCamera()** 方法以后，我们设置 **OnMapLoadedCallback**  的回调。当镜头移动到正确的位置的时候，**onMapLoaded()** 会被调用，我们准备好从在此处截图了。

## Getting bitmap and saving in cache ##

## 获得图片并保存在缓存中 ##

The *onMapLoaded()* method has only one task to do – call *presenter.saveBitmap()* after snapshot is taken from the map. Thanks to lambda expression, we can reduce boilerplate to simply one line

**onMapLoaded()** 方法只做一件事 —— 在从地图上获得快照后调用  **presenter.saveBitmap()** 方法。多亏 lambda 表达式，我们可以缩短代码到一行。(译者注：有关 lamb 表达式，推荐搭配[此文章](https://github.com/xitu/gold-miner/pull/1578/files)一起食用。)

```
googleMap.setOnMapLoadedCallback(()->googleMap.snapshot(presenter::saveBitmap));
```

The presenters code is really simple. It only saves our bitmap in the cache.

此 presenter （注：MVP 里的 P） 的代码非常简单，它只是把图片保存在缓存里。

```
@Override

public void saveBitmap(final Bitmap bitmap){

    MapBitmapCache.instance().putBitmap(bitmap);

}


public class MapBitmapCache extends LruCache<String,Bitmap>{

    private static final int DEFAULT_CACHE_SIZE=(int)(Runtime.getRuntime().maxMemory()/1024)/8;

    public static final String KEY="MAP_BITMAP_KEY";

 

    private static MapBitmapCache sInstance;

    /**

     * @param maxSize for caches that do not override {@link #sizeOf}, this is

     * the maximum number of entries in the cache. For all other caches,

     * this is the maximum sum of the sizes of the entries in this cache.

     */

    private MapBitmapCache(final int maxSize){

        super(maxSize);

    }

 

    public staticMapBitmapCache instance(){

        if(sInstance==null){

            sInstance=newMapBitmapCache(DEFAULT_CACHE_SIZE);

            returnsInstance;

        }

        returnsInstance;

    }

 

    public Bitmap getBitmap(){

        return get(KEY);

    }

 

    public void putBitmap(Bitmap bitmap){

        put(KEY,bitmap);

    }

 

    @Override

    protected intsizeOf(String key,Bitmap value){

        return value==null ? 0 : value.getRowBytes()*value.getHeight()/1024;

    }

}
```

I’ve used *LruCache* for it, because it is the recommended way, well described [here](https://developer.android.com/topic/performance/graphics/cache-bitmap.html).

此处我使用了 **LruCache** ，因为这是比较推荐的做法，[此处](https://developer.android.com/topic/performance/graphics/cache-bitmap.html)有详细解释。

So we have bitmap saved in the cache, the only thing we have to do is to make custom transition for scale and fade effect of the map when entering *DetailsFragment*. Easy peasy lemon squeezy.

现在我们把bitmap 存到了缓存里，剩下唯一要做的事情就是自定义一个缩放和渐进效果的转场动画。
毛毛雨洒洒水啦~(译者注: 原文为 Easy peasy lemon squeezy。是一个比较有意思的、以俏皮的语气表达“轻而易举”或者“手到擒来”概念的短语。)


## Custom enter transition for fade/scale map effect ##
## 自定义一个包含缩放和渐显效果的转场 ##

So the most interesting part! The code is rather simple, however it allows us to do great stuff.

下面是最有意思的部分，代码也炒鸡简单！但就是这部分完成了比较炫酷的事情。

```
public class ScaleDownImageTransition extends Transition{

    private static final int DEFAULT_SCALE_DOWN_FACTOR = 8;

    private static final String PROPNAME_SCALE_X="transitions:scale_down:scale_x";

    private static final String PROPNAME_SCALE_Y="transitions:scale_down:scale_y";

    private Bitmap bitmap;

    private Context context;

 

    private int targetScaleFactor = DEFAULT_SCALE_DOWN_FACTOR;

 

    public ScaleDownImageTransition(final Context context){

        this.context=context;

        setInterpolator(newDecelerateInterpolator());

    }

 

    public ScaleDownImageTransition(final Context context,final Bitmap bitmap){

        this(context);

        this.bitmap=bitmap;

    }

 

    public ScaleDownImageTransition(final Context context,final AttributeSet attrs){

        super(context,attrs);

        this.context=context;

        TypedArray array=context.obtainStyledAttributes(attrs,R.styleable.ScaleDownImageTransition);

        try{

            targetScaleFactor=array.getInteger(R.styleable.ScaleDownImageTransition_factor,DEFAULT_SCALE_DOWN_FACTOR);

        }finally{

            array.recycle();

        }

    }

 

    public void setBitmap(final Bitmap bitmap){

        this.bitmap=bitmap;

    }

 

    public void setScaleFactor(final intfactor){

        targetScaleFactor=factor;

    }

 

    @Override

    public Animator createAnimator(final ViewGroup sceneRoot,final TransitionValues startValues,final TransitionValues endValues){

        if(null == endValues){

            return null;

        }

        final View view=endValues.view;

        if (view instanceof ImageView){

            if (bitmap!=null)
                view.setBackground(new BitmapDrawable(context.getResources(),bitmap));

            float scaleX=(float)startValues.values.get(PROPNAME_SCALE_X);

            float scaleY=(float)startValues.values.get(PROPNAME_SCALE_Y);

 

            float targetScaleX=(float)endValues.values.get(PROPNAME_SCALE_X);

            float targetScaleY=(float)endValues.values.get(PROPNAME_SCALE_Y);

 

            ObjectAnimator scaleXAnimator = ObjectAnimator.ofFloat(view,View.SCALE_X,targetScaleX,scaleX);

            ObjectAnimator scaleYAnimator = ObjectAnimator.ofFloat(view,View.SCALE_Y,targetScaleY,scaleY);

            AnimatorSet set=new AnimatorSet();

            set.playTogether(scaleXAnimator,scaleYAnimator,ObjectAnimator.ofFloat(view,View.ALPHA,0.f,1.f));

            return set;

        }

        return null;

    }

 

    @Override

    public void captureStartValues(TransitionValues transitionValues){

        captureValues(transitionValues,transitionValues.view.getScaleX(),transitionValues.view.getScaleY());

    }

 

    @Override

    public void captureEndValues(TransitionValues transitionValues){

        captureValues(transitionValues,targetScaleFactor,targetScaleFactor);

    }

 

    private void captureValues(final TransitionValues values,final float scaleX,final float scaleY){

        values.values.put(PROPNAME_SCALE_X,scaleX);

        values.values.put(PROPNAME_SCALE_Y,scaleY);

    }

}
```

What we do in this transition is that we are scaling down the scaleX and scaleY properties from ImageView from *scaleFactor* (default is 8) to desired view scale. So in other words we are increasing the width and height by *scaleFactor* in the first place, and then we are scaling it down to desired size.

我们在转场动画中做了什么事情呢？我们用 **scaleFactor** 对传入的 imageView 进行了 scaleX 和 scaleY 属性的缩放（默认是8）。换句话说我们通过 **scaleFactor** 先把图片拉伸，然后再把图片压缩回需要的大小。

### Creating custom transition ###
### 创建自定义转场动画 ###

In order to do the custom transition, we have to inherit from Transition class. The next step is to override the *captureStartValues* and *captureEndValues*. What is happening here?

为了编写转场动画，我们必须继承一个 Transition 类。然后重写 **captureStartValues** 和 **captureEndValues** 方法。猜猜发生了啥？

The Transition Framework is using the Property Animation API to animate between view’s start and end property value. If you are not familiar with this, you should definetely read [this article](https://developer.android.com/guide/topics/graphics/prop-animation.html).  As explained before, we want to scale down our image. So the startValue is our scaleFactor, and endValue is the desired scaleX and scaleY – normally it will be 1.

Transition 框架使用了属性动画的 API ，通过改变 view 开始和结束时的属性值来产生动画。如果你不熟悉属性动画，强烈推荐阅读[这篇文章](https://developer.android.com/guide/topics/graphics/prop-animation.html)。就像刚才解释的那样，我们要缩放图片。开始值是 scaleFactor ,结束值是期望 scaleX 和 scaleY的值，通常情况下是1。

How to pass those values? As said before – easy. We have TransitionValues object passed as argument in both *captureStart* and *captureEnd* methods. It contains a reference to the view and a map in which you can store the view values – in our case the scaleX and scaleY.

怎么传递这些值呢？如前所述，很简单。我们把 TransitionValues 对象当作参数传进 **captureStart** 和 **captureEnd** 方法里。它包括一个 view 的引用和一个可以保存值的 Map 对象，在我们的项目中需要保存的值就是 scaleX 和 scaleY。

With values captured, we need to override the *createAnimator()* method. In this method we are returning the *Animator* (or *AnimatorSet*) object which animates changes between view property values. So in our case we are returning the *AnimatorSet* which will animate the scale and alpha of the view. Also we want our transition to work only for ImageView, so we check if view reference from TransitionValues object passed as argument is ImageView instance.

获得这些值以后，我们需要重写 **createAnimator()** 方法。在这个方法中需要返回一个动态改变 view 属性的**动画对象**（或者 **动画序列对象**）。本项目中返回的是**动画序列**对象，此对象同时改变一个 view 的尺寸和亮度。同时，因为我们只希望转场动画作用在 ImageView 上，所以通过 instanceof 进行了对象类型校验，以保证传入的 view 是一个 ImageView。

### Applying custom transition ###

### 部署自定义转场动画 ###

We have bitmap stored in memory, we have transition created, so we have last step – applying the transition to our fragment. I like to create static factory method for creating the fragments and activities. It looks really nice and helps us to keep the code rather clean. It is also the nice idea to put our Transition there programmatically.

我们已经在缓存中保存了 bitmap 图片，也已经创建了转场动画，所以只剩最后一步 —— 就是为 fragment 添加转场动画。我喜欢写一个静态工厂方法来创建 fragments 和 activities 。这么做可以让我们保持代码逻辑清晰，所以也应该用编程的方式添加转场动画.

```
public static Fragment newInstance(final Context ctx){

    DetailsFragment fragment = new DetailsFragment();

    ScaleDownImageTransition transition=new ScaleDownImageTransition(ctx,MapBitmapCache.instance().getBitmap());

    transition.addTarget(ctx.getString(R.string.mapPlaceholderTransition));

    transition.setDuration(800);

    fragment.setEnterTransition(transition);

    return fragment;

}
```

As we can see it is really easy to do. We create new instance of our transition, we add target here and also in XML of the target view, via t*ransitionName* attribute.

瞧，做起来多简单。我们为转场动画实例化了一个新的实例，又通过 xml 为它添加了 **transitionName** 的属性。

```
<ImageView

    android:id="@+id/mapPlaceholder"

    android:layout_width="match_parent"

    android:layout_height="match_parent"

    android:layout_marginBottom="@dimen/map_margin_bottom"

    android:transitionName="@string/mapPlaceholderTransition"/>
```

Next we just pass transition to fragment via *setEnterTransition()* method and voila! There is the effect:

然后我们通过 **setEnterTransition()** 把fragment 传递进去, 看吧!效果出现啦:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/map_transiton.gif?x77083)

# Conclusion #

#  总结

As you can see, the final result is closer to the original from the GIF than native map loading. There is also a glitch in the final phase of the animation – this is because the snapshot from the map is different than the content of the SupportMapFragment.

你看，最终效果已经很接近像 GIF 那样从本地加载地图的效果了。但是最后一帧动画仍然会有那么一点闪烁，因为地图的快照还是与实际的地图有点差别。

Thanks for reading! Next part will be published on Tuesday 7.03. Feel free to leave a comment if you have any questions, and if you found this blog post helpful – don’t forget to share it!

多谢阅读，下一部分会在 7.03 星期二更新。如果有疑问的话，欢迎评论。当然如果发现这些博文很有趣，不要忘记分享噢。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
