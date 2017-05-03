> * 原文地址：[Workcation App – Part 1. Fragment custom transition](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 1. Fragment custom transition #

Welcome to the first of series of posts about my R&D (Research & Development) project I’ve made a while ago. In this blog posts, I want to share my solutions for problems I encountered during the development of an animation idea you’ll see below.

Part 1: [Fragment’s custom transition](https://www.thedroidsonroids.com/?p=5054)

Part 2: [Animating Markers with MapOverlayLayout](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/)

Part 3: [RecyclerView interaction with Animated Markers](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)

Part 4: [Shared Element Transition with RecyclerView and Scenes](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)

 

Link for project on Github:  [Workcation App](https://github.com/panwrona/Workcation)

Link for animation on Dribbble: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)

# Prelude #

A few months back we’ve had a company meeting, where my friend Paweł Szymankiewicz showed the animation he’d done during his Research & Development. And I loved it. After the meeting, I decided that I will code it. I never knew what I’m going to struggle with…

 

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083) 

GIF 1 *“The animation”*

# Let’s start! #

As we can see in the GIF above, there is a lot of going on.

1. After clicking on the bottom menu item, we are moving to the next screen, where we can see the map being loaded with some scale/fade animation from the top, RecyclerView items loaded with translation from the bottom, markers added to the map with scale/fade animation.
2. While scrolling the items in RecyclerView, the markers are pulsing to show their position on the map.
3. After clicking on the item, we are transferred to the next screen, the map is animated below to show the route and start/finish marker. The RecyclerView’s item is transitioned to show some description, bigger picture, trip details and button.
4. While returning, the transition happens again back to the RecyclerView’s item, all of the markers are shown again, the route disappears.

Pretty much. That’s why I’ve decided to show you all of the things in the series of posts. In this article I will cover the enter animation of the map fragment.

# The Problem #

As we can see in the GIF 1 above, it looks like the map is already loaded before and just animated to the proper position. This is not happening in the real world. What it really looks like:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/map_loading-1.gif?x77083)

# The Solution #

1. Preload map
2. When map is loaded, use Google Maps API to get bitmap from it and save it in cache
3. Create custom transition for scale and fade effect of the map when entering *DetailsFragment*

# Let’s go! #

## Preloading the map ##

To achieve that we have to take bitmap snapshot from already loaded map. Of course we can’t do that in the *DetailsFragment* if we want the smooth transition between screens. What we have to do, is to get bitmap underneath the *HomeFragment* and save it in the cache. As you can see, the map have some margin from the bottom, so we also have to fit the “future” map size.

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

```
publicclassMainActivity extendsMvpActivity<MainView,MainPresenter>implementsMainView,OnMapReadyCallback{

    SupportMapFragment mapFragment;

    privateLatLngBounds mapLatLngBounds;

    @Override

    protectedvoidonCreate(Bundle savedInstanceState){

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

    publicvoidsetMapLatLngBounds(finalLatLngBounds latLngBounds){

        mapLatLngBounds=latLngBounds;

    }

 

    @Override

    publicvoidonMapReady(finalGoogleMap googleMap){

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

In onCreate method we have three things:

1. We are providing *LatLngBounds* for map – they will be used to set the bounds of the map
2. We are replacing the *HomeFragment* in activities container layout
3. We are setting the *OnMapReadyCallback* on the *MapFragment*

After map is ready, the *onMapReady()* method is called, and we can do some operations to save the properly loaded map into bitmap. We are moving camera to earlier provided *LatLngBounds* using *CameraUpdateFactory.newLatLngBounds()* method. In our case we know exactly what will be the dimension of the map in the next screen, so we are able to pass *width*(width of screen) and *height*(height of screen with bottom margin) parameters to this method. We are calculating them like this:

```
publicstaticintcalculateWidth(finalWindowManager windowManager){

    DisplayMetrics metrics=newDisplayMetrics();

    windowManager.getDefaultDisplay().getMetrics(metrics);

    returnmetrics.widthPixels;

}


publicstaticintcalculateHeight(finalWindowManager windowManager,finalintpaddingBottom){

    DisplayMetrics metrics=newDisplayMetrics();

    windowManager.getDefaultDisplay().getMetrics(metrics);

    returnmetrics.heightPixels-paddingBottom;
```

Easy. After *googleMap.moveCamera()* method being called, we are setting the *OnMapLoadedCallback*. When camera is moved to the desired position, the *onMapLoaded()* method is called and we are ready to take bitmap from it.

## Getting bitmap and saving in cache ##

The *onMapLoaded()* method has only one task to do – call *presenter.saveBitmap()* after snapshot is taken from the map. Thanks to lambda expression, we can reduce boilerplate to simply one line

```
googleMap.setOnMapLoadedCallback(()->googleMap.snapshot(presenter::saveBitmap));
```

The presenters code is really simple. It only saves our bitmap in the cache.

```
@Override

publicvoidsaveBitmap(finalBitmap bitmap){

    MapBitmapCache.instance().putBitmap(bitmap);

}


publicclassMapBitmapCache extendsLruCache<String,Bitmap>{

    privatestaticfinalintDEFAULT_CACHE_SIZE=(int)(Runtime.getRuntime().maxMemory()/1024)/8;

    publicstaticfinalStringKEY="MAP_BITMAP_KEY";

 

    privatestaticMapBitmapCache sInstance;

    /**

     * @param maxSize for caches that do not override {@link #sizeOf}, this is

     * the maximum number of entries in the cache. For all other caches,

     * this is the maximum sum of the sizes of the entries in this cache.

     */

    privateMapBitmapCache(finalintmaxSize){

        super(maxSize);

    }

 

    publicstaticMapBitmapCache instance(){

        if(sInstance==null){

            sInstance=newMapBitmapCache(DEFAULT_CACHE_SIZE);

            returnsInstance;

        }

        returnsInstance;

    }

 

    publicBitmap getBitmap(){

        returnget(KEY);

    }

 

    publicvoidputBitmap(Bitmap bitmap){

        put(KEY,bitmap);

    }

 

    @Override

    protectedintsizeOf(Stringkey,Bitmap value){

        returnvalue==null?0:value.getRowBytes()*value.getHeight()/1024;

    }

}
```

I’ve used *LruCache* for it, because it is the recommended way, well described [here](https://developer.android.com/topic/performance/graphics/cache-bitmap.html).

So we have bitmap saved in the cache, the only thing we have to do is to make custom transition for scale and fade effect of the map when entering *DetailsFragment*. Easy peasy lemon squeezy.

## Custom enter transition for fade/scale map effect ##

So the most interesting part! The code is rather simple, however it allows us to do great stuff.

```
publicclassScaleDownImageTransitionextendsTransition{

    privatestaticfinalintDEFAULT_SCALE_DOWN_FACTOR=8;

    privatestaticfinalStringPROPNAME_SCALE_X="transitions:scale_down:scale_x";

    privatestaticfinalStringPROPNAME_SCALE_Y="transitions:scale_down:scale_y";

    privateBitmap bitmap;

    privateContext context;

 

    privateinttargetScaleFactor=DEFAULT_SCALE_DOWN_FACTOR;

 

    publicScaleDownImageTransition(finalContext context){

        this.context=context;

        setInterpolator(newDecelerateInterpolator());

    }

 

    publicScaleDownImageTransition(finalContext context,finalBitmap bitmap){

        this(context);

        this.bitmap=bitmap;

    }

 

    publicScaleDownImageTransition(finalContext context,finalAttributeSet attrs){

        super(context,attrs);

        this.context=context;

        TypedArray array=context.obtainStyledAttributes(attrs,R.styleable.ScaleDownImageTransition);

        try{

            targetScaleFactor=array.getInteger(R.styleable.ScaleDownImageTransition_factor,DEFAULT_SCALE_DOWN_FACTOR);

        }finally{

            array.recycle();

        }

    }

 

    publicvoidsetBitmap(finalBitmap bitmap){

        this.bitmap=bitmap;

    }

 

    publicvoidsetScaleFactor(finalintfactor){

        targetScaleFactor=factor;

    }

 

    @Override

    publicAnimator createAnimator(finalViewGroup sceneRoot,finalTransitionValues startValues,finalTransitionValues endValues){

        if(null==endValues){

            returnnull;

        }

        finalView view=endValues.view;

        if(view instanceofImageView){

            if(bitmap!=null)view.setBackground(newBitmapDrawable(context.getResources(),bitmap));

            floatscaleX=(float)startValues.values.get(PROPNAME_SCALE_X);

            floatscaleY=(float)startValues.values.get(PROPNAME_SCALE_Y);

 

            floattargetScaleX=(float)endValues.values.get(PROPNAME_SCALE_X);

            floattargetScaleY=(float)endValues.values.get(PROPNAME_SCALE_Y);

 

            ObjectAnimator scaleXAnimator=ObjectAnimator.ofFloat(view,View.SCALE_X,targetScaleX,scaleX);

            ObjectAnimator scaleYAnimator=ObjectAnimator.ofFloat(view,View.SCALE_Y,targetScaleY,scaleY);

            AnimatorSet set=newAnimatorSet();

            set.playTogether(scaleXAnimator,scaleYAnimator,ObjectAnimator.ofFloat(view,View.ALPHA,0.f,1.f));

            returnset;

        }

        returnnull;

    }

 

    @Override

    publicvoidcaptureStartValues(TransitionValues transitionValues){

        captureValues(transitionValues,transitionValues.view.getScaleX(),transitionValues.view.getScaleY());

    }

 

    @Override

    publicvoidcaptureEndValues(TransitionValues transitionValues){

        captureValues(transitionValues,targetScaleFactor,targetScaleFactor);

    }

 

    privatevoidcaptureValues(finalTransitionValues values,finalfloatscaleX,finalfloatscaleY){

        values.values.put(PROPNAME_SCALE_X,scaleX);

        values.values.put(PROPNAME_SCALE_Y,scaleY);

    }

}
```

What we do in this transition is that we are scaling down the scaleX and scaleY properties from ImageView from *scaleFactor* (default is 8) to desired view scale. So in other words we are increasing the width and height by *scaleFactor* in the first place, and then we are scaling it down to desired size.

### Creating custom transition ###

In order to do the custom transition, we have to inherit from Transition class. The next step is to override the *captureStartValues* and *captureEndValues*. What is happening here?

The Transition Framework is using the Property Animation API to animate between view’s start and end property value. If you are not familiar with this, you should definetely read [this article](https://developer.android.com/guide/topics/graphics/prop-animation.html).  As explained before, we want to scale down our image. So the startValue is our scaleFactor, and endValue is the desired scaleX and scaleY – normally it will be 1.

How to pass those values? As said before – easy. We have TransitionValues object passed as argument in both *captureStart* and *captureEnd* methods. It contains a reference to the view and a map in which you can store the view values – in our case the scaleX and scaleY.

With values captured, we need to override the *createAnimator()* method. In this method we are returning the *Animator* (or *AnimatorSet*) object which animates changes between view property values. So in our case we are returning the *AnimatorSet* which will animate the scale and alpha of the view. Also we want our transition to work only for ImageView, so we check if view reference from TransitionValues object passed as argument is ImageView instance.

### Applying custom transition ###

We have bitmap stored in memory, we have transition created, so we have last step – applying the transition to our fragment. I like to create static factory method for creating the fragments and activities. It looks really nice and helps us to keep the code rather clean. It is also the nice idea to put our Transition there programmatically.

```
publicstaticFragment newInstance(finalContext ctx){

    DetailsFragment fragment=newDetailsFragment();

    ScaleDownImageTransition transition=newScaleDownImageTransition(ctx,MapBitmapCache.instance().getBitmap());

    transition.addTarget(ctx.getString(R.string.mapPlaceholderTransition));

    transition.setDuration(800);

    fragment.setEnterTransition(transition);

    returnfragment;

}
```

As we can see it is really easy to do. We create new instance of our transition, we add target here and also in XML of the target view, via t*ransitionName* attribute.

```
<ImageView

    android:id="@+id/mapPlaceholder"

    android:layout_width="match_parent"

    android:layout_height="match_parent"

    android:layout_marginBottom="@dimen/map_margin_bottom"

    android:transitionName="@string/mapPlaceholderTransition"/>
```

Next we just pass transition to fragment via *setEnterTransition()* method and voila! There is the effect:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/map_transiton.gif?x77083)

# Conclusion #

As you can see, the final result is closer to the original from the GIF than native map loading. There is also a glitch in the final phase of the animation – this is because the snapshot from the map is different than the content of the SupportMapFragment.

Thanks for reading! Next part will be published on Tuesday 7.03. Feel free to leave a comment if you have any questions, and if you found this blog post helpful – don’t forget to share it!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
