> * 原文地址：[Workcation App – Part 2. Animating Markers with MapOverlayLayout](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 2. Animating Markers with MapOverlayLayout #

Welcome to the second of series of posts about my R&D (Research & Development) project I’ve made a while ago. In this blog posts, I want to share my solutions for problems I encountered during the development of an animation idea you’ll see below.

Part 1: [Fragment’s custom transition
](https://www.thedroidsonroids.com/?p=5054)

Part 2: [Animating Markers with MapOverlayLayout](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout)
 
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

Pretty much. That’s why I’ve decided to show you all of the things in the series of posts. In this article, I will cover the map loading and mysterious MapWrapperLayout. Stay tuned!

# The Problem #

So the next step in my development was to load the map to show all of the markers provided by the “API” (simple singleton parsing JSON from assets).  Fortunately, it’s been already described in the [previous post](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition#preloading_map). The second thing we need to do is to load markers with fade/scale animation. Easy, right? Not really.

Unfortunately, the Google Maps API only allows us to pass BitmapDescriptor as an icon of the Marker. This is how it’s done:

```
Java

GoogleMap map=...// get a map.

   // Add a marker at San Francisco with an azure colored marker.

   Marker marker=map.add(newMarkerOptions()

       .position(newLatLng(37.7750,122.4183))

       .title("San Francisco")

       .snippet("Population: 776733"))

       .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE));
```

As you can see on the [animation gif](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout/#animation), we have to implement scale/fade in animation on loading, scale up/scale down animation while scrolling RecyclerView and fade out when entering details layout. It would be much easier with the Animation/ViewPropertyAnimator API available. Do we have a solution for that? Yes we have!

## MapOverlayLayout ##

So what is the solution? It’s rather simple, however, it took me a while to figure this out. We need to add a MapOverlayLayout over the SupportMapFragment from GoogleMapsApi. With a projection pulled out of the map (a projection is used to translate between on-screen location and geographic coordinates on the surface of the Earth, via

MapOverlayLayout is a custom FrameLayout with the same dimensions as the SupportMapFragment. When the map is loaded, we can pass a reference to the MapOverlayLayout and use it to add custom views with animation, move them along with the screen gestures, etc. And of course, we can do what we need – add Markers (now the custom views) with scale/fade animation, hide them, make the “pulse” animation while scrolling RecyclerView.

## MapOverlayLayout – the setup ##

So how to setup the MapOverlayLayout to cooperate with SupportMapFragment and GoogleMap?

First, let’s look at the DetailsFragment XML:

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

As we can see above, there is a PulseOverlayLayout with same dimensions as SupportMapFragment placed underneath. The PulseOverlayLayout inherits from the MapOverlayLayout and adds some specific logic for the app purpose (for example adding start and finish markers to the layout after clicking on the RecyclerView item, creating PulseMarkerView – custom views I will describe later in the post).  There is also an ImageView inside the layout – that’s the placeholder we use to create fragment enter transition I described [here](https://www.thedroidsonroids.com/blog/android/workcation-app-part-1-fragments-custom-transition#enter_transition). And that’s all the work for XML! Let’s move on to another piece 0f code – the DetailsFragment itself.

Let’s move on to another piece 0f code – the DetailsFragment itself.

```
publicclassDetailsFragment extendsMvpFragment<DetailsFragmentView,DetailsFragmentPresenter>

        implementsDetailsFragmentView,OnMapReadyCallback{

    publicstaticfinalStringTAG=DetailsFragment.class.getSimpleName();

 

    @BindView(R.id.recyclerview)RecyclerView recyclerView;

    @BindView(R.id.container)FrameLayout containerLayout;

    @BindView(R.id.mapPlaceholder)ImageView mapPlaceholder;

    @BindView(R.id.mapOverlayLayout)PulseOverlayLayout mapOverlayLayout;

 

    @Override

    publicvoidonViewCreated(finalView view,@Nullable finalBundle savedInstanceState){

        super.onViewCreated(view,savedInstanceState);

        setupBaliData();

        setupMapFragment();

    }

 

    privatevoidsetupBaliData(){

        presenter.provideBaliData();

    }

 

    privatevoidsetupMapFragment(){

        ((SupportMapFragment)getChildFragmentManager().findFragmentById(R.id.mapFragment)).getMapAsync(this);

    }

 

    @Override

    publicvoidonMapReady(finalGoogleMap googleMap){

        mapOverlayLayout.setupMap(googleMap);

        setupGoogleMap();

    }

 

    privatevoidsetupGoogleMap(){

        presenter.moveMapAndAddMarker();

    }

 

    @Override

    publicvoidprovideBaliData(finalList<Place>places){

        baliPlaces=places;

    }

 

    @Override

    publicvoidmoveMapAndAddMaker(finalLatLngBounds latLngBounds){

        mapOverlayLayout.moveCamera(latLngBounds);

        mapOverlayLayout.setOnCameraIdleListener(()->{

            for(inti=0;i<baliPlaces.size();i++){

                mapOverlayLayout.createAndShowMarker(i,baliPlaces.get(i).getLatLng());

            }

            mapOverlayLayout.setOnCameraIdleListener(null);

        });

        mapOverlayLayout.setOnCameraMoveListener(mapOverlayLayout::refresh);

    }

}
```

As we can see above – the map is loaded exactly the same as in the previous article, with *onMapReady* method. After receiving this callback, we are able to update maps bounds, add markers to MapOverlayLayout and set proper listeners.

In the following code, we are moving the camera to the bounds that will show us all of the markers. Next, when camera finishes moving, we are creating markers and showing them on the map. After that, we set OnCameraIdleListener to null. It is because we don’t want to add markers when we move the camera. In the last line of code, we are setting OnCameraMoveListener to refresh all of the Markers positions on the screen.

```
@Override

    publicvoidmoveMapAndAddMaker(finalLatLngBounds latLngBounds){

        mapOverlayLayout.moveCamera(latLngBounds);

        mapOverlayLayout.setOnCameraIdleListener(()->{

            for(inti=0;i<baliPlaces.size();i++){

                mapOverlayLayout.createAndShowMarker(i,baliPlaces.get(i).getLatLng());

            }

            mapOverlayLayout.setOnCameraIdleListener(null);

        });

        mapOverlayLayout.setOnCameraMoveListener(mapOverlayLayout::refresh);

    }
```

## MapOverlayLayout – how does it work? ##

So how it actually works?

With a projection pulled out of the map (a projection is used to translate between on-screen location and geographic coordinates on the surface of the Earth, via [*documentation*](https://developers.google.com/android/reference/com/google/android/gms/maps/Projection)) we are able to get x and y values of the Marker and use them to place Custom View in the place of the Marker on the MapOverlayLayout.

This approach allows us to use f.e. ViewPropertyAnimator API with custom views to animate them.

```
publicclassMapOverlayLayout<VextendsMarkerView>extendsFrameLayout{

 

    protectedList<V>markersList;

    protectedPolyline currentPolyline;

    protectedGoogleMap googleMap;

    protectedArrayList<LatLng>polylines;

 

    publicMapOverlayLayout(finalContext context){

        this(context,null);

    }

 

    publicMapOverlayLayout(finalContext context,finalAttributeSet attrs){

        super(context,attrs);

        markersList=newArrayList<>();

    }

 

    protectedvoidaddMarker(finalVview){

        markersList.add(view);

        addView(view);

    }

 

    protectedvoidremoveMarker(finalVview){

        markersList.remove(view);

        removeView(view);

    }

 

    publicvoidshowMarker(finalintposition){

        markersList.get(position).show();

    }

 

    privatevoidrefresh(finalintposition,finalPoint point){

        markersList.get(position).refresh(point);

    }

 

    publicvoidsetupMap(finalGoogleMap googleMap){

        this.googleMap=googleMap;

    }

 

    publicvoidrefresh(){

        Projection projection=googleMap.getProjection();

        for(inti=0;i<markersList.size();i++){

            refresh(i,projection.toScreenLocation(markersList.get(i).latLng()));

        }

    }

 

    publicvoidsetOnCameraIdleListener(finalGoogleMap.OnCameraIdleListener listener){

        googleMap.setOnCameraIdleListener(listener);

    }

 

    publicvoidsetOnCameraMoveListener(finalGoogleMap.OnCameraMoveListener listener){

        googleMap.setOnCameraMoveListener(listener);

    }

 

    publicvoidmoveCamera(finalLatLngBounds latLngBounds){

        googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(latLngBounds,150));

    }

}
```

The methods used in the *moveMapAndAddMarker* method in DetailsFragment are visible above. We can see setters for CameraListeners, *refresh* method for updating the Marker position on the MapOverlayLayout; *addMarker* and *removeMarker* methods,  which are adding MarkerView to the layout and also to the list. With this approach, the MapOverlayLayout have references to all of the views added to the MapOverlayLayout. At the top of the class, we can see that we have to make our custom views to inherit from the MarkerView. It is an abstract class that inherits from View class and looks like this:

```
publicabstractclassMarkerViewextendsView{

 

    protectedPoint point;

    protectedLatLng latLng;

 

    privateMarkerView(finalContext context){

        super(context);

    }

 

    publicMarkerView(finalContext context,finalLatLng latLng,finalPoint point){

        this(context);

        this.latLng=latLng;

        this.point=point;

    }

 

    publicdoublelat(){

        returnlatLng.latitude;

    }

 

    publicdoublelng(){

        returnlatLng.longitude;

    }

 

    publicPoint point(){

        returnpoint;

    }

 

    publicLatLng latLng(){

        returnlatLng;

    }

 

    publicabstractvoidshow();

 

    publicabstractvoidhide();

 

    publicabstractvoidrefresh(finalPoint point);

}
```

With *show, hide* and *refresh* abstract methods we can specify the way the Marker will appear, disappear or refresh. It also needs the Context, LatLng and Point. Let’s look into our implementation:

```
publicclassPulseMarkerViewextendsMarkerView{

    privatestaticfinalintSTROKE_DIMEN=2;

 

    privateAnimation scaleAnimation;

    privatePaint strokeBackgroundPaint;

    privatePaint backgroundPaint;

    privateStringtext;

    privatePaint textPaint;

    privateAnimatorSet showAnimatorSet,hideAnimatorSet;

 

    publicPulseMarkerView(finalContext context,finalLatLng latLng,finalPoint point){

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

 

    publicPulseMarkerView(finalContext context,finalLatLng latLng,finalPoint point,finalintposition){

        this(context,latLng,point);

        text=String.valueOf(position);

    }

 

    privatevoidsetupHideAnimatorSet(){

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

 

    privatevoidsetupSizes(finalContext context){

        size=GuiUtils.dpToPx(context,32)/2;

    }

 

    privatevoidsetupShowAnimatorSet(){

        Animator animatorScaleX=ObjectAnimator.ofFloat(this,View.SCALE_X,1.5f,1.f);

        Animator animatorScaleY=ObjectAnimator.ofFloat(this,View.SCALE_Y,1.5f,1.f);

        Animator animator=ObjectAnimator.ofFloat(this,View.ALPHA,0.f,1.f).setDuration(300);

        animator.addListener(newAnimatorListenerAdapter(){

            @Override

            publicvoidonAnimationStart(finalAnimator animation){

                super.onAnimationStart(animation);

                setVisibility(View.VISIBLE);

                invalidate();

            }

        });

        showAnimatorSet=newAnimatorSet();

        showAnimatorSet.playTogether(animator,animatorScaleX,animatorScaleY);

    }

 

    privatevoidsetupScaleAnimation(finalContext context){

        scaleAnimation=AnimationUtils.loadAnimation(context,R.anim.pulse);

        scaleAnimation.setDuration(100);

    }

 

    privatevoidsetupTextPaint(finalContext context){

        textPaint=newPaint();

        textPaint.setColor(ContextCompat.getColor(context,R.color.white));

        textPaint.setTextAlign(Paint.Align.CENTER);

        textPaint.setTextSize(context.getResources().getDimensionPixelSize(R.dimen.textsize_medium));

    }

 

    privatevoidsetupStrokeBackgroundPaint(finalContext context){

        strokeBackgroundPaint=newPaint();

        strokeBackgroundPaint.setColor(ContextCompat.getColor(context,android.R.color.white));

        strokeBackgroundPaint.setStyle(Paint.Style.STROKE);

        strokeBackgroundPaint.setAntiAlias(true);

        strokeBackgroundPaint.setStrokeWidth(GuiUtils.dpToPx(context,STROKE_DIMEN));

    }

 

    privatevoidsetupBackgroundPaint(finalContext context){

        backgroundPaint=newPaint();

        backgroundPaint.setColor(ContextCompat.getColor(context,android.R.color.holo_red_dark));

        backgroundPaint.setAntiAlias(true);

    }

 

    @Override

    publicvoidsetLayoutParams(finalViewGroup.LayoutParams params){

        FrameLayout.LayoutParams frameParams=newFrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,FrameLayout.LayoutParams.WRAP_CONTENT);

        frameParams.width=(int)GuiUtils.dpToPx(context,44);

        frameParams.height=(int)GuiUtils.dpToPx(context,44);

        frameParams.leftMargin=point.x-frameParams.width/2;

        frameParams.topMargin=point.y-frameParams.height/2;

        super.setLayoutParams(frameParams);

    }

 

    publicvoidpulse(){

        startAnimation(scaleAnimation);

    }

 

    @Override

    protectedvoidonDraw(finalCanvas canvas){

        drawBackground(canvas);

        drawStrokeBackground(canvas);

        drawText(canvas);

        super.onDraw(canvas);

    }

 

    privatevoiddrawText(finalCanvas canvas){

        if(text!=null&&!TextUtils.isEmpty(text))

            canvas.drawText(text,size,(size-((textPaint.descent()+textPaint.ascent())/2)),textPaint);

    }

 

    privatevoiddrawStrokeBackground(finalCanvas canvas){

        canvas.drawCircle(size,size,GuiUtils.dpToPx(context,28)/2,strokeBackgroundPaint);

    }

 

    privatevoiddrawBackground(finalCanvas canvas){

        canvas.drawCircle(size,size,size,backgroundPaint);

    }

 

    publicvoidsetText(Stringtext){

        this.text=text;

        invalidate();

    }

 

    @Override

    publicvoidhide(){

        hideAnimatorSet.start();

    }

 

    @Override

    publicvoidrefresh(finalPoint point){

        this.point=point;

        updatePulseViewLayoutParams(point);

    }

 

    @Override

    publicvoidshow(){

        showAnimatorSet.start();

    }

 

    publicvoidshowWithDelay(finalintdelay){

        showAnimatorSet.setStartDelay(delay);

        showAnimatorSet.start();

    }

 

    publicvoidupdatePulseViewLayoutParams(finalPoint point){

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
 
This is PulseMarkerView class which inherits from MarkerView. In the constructor, we are setting up the AnimatorSets for showing, hiding and “pulsing”. In overridden methods from MarkerView, we are simply starting specific AnimatorSet. There is also *updatePulseViewLayoutParams* method which updates the position of the PulseViewMarker on the screen. The rest is drawing on the canvas with Paints created in the constructor.

This is the effect:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/load_markers_pulse.gif?x77083)

*Loading Markers and scaling on scroll*

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/moving_map.gif?x77083)

*Refreshing the markers position while moving the map*

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/zooming_map.gif?x77083)

*Zooming the map*

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/zooming_pulsing.gif?x77083)

*Zooming the map and scaling Markers while scrolling*

# Conclusion #

As we can see, there is a big advantage from this approach – we can use the power of the Custom Views widely. Also, there is a very little delay when we move the map and refresh Markers position. I think it is a little price we have to pay compared to the advantages we have from this solution.

Thanks for reading! Next part will be published on Tuesday 14.03. Feel free to leave a comment if you have any questions, and if you found this blog post helpful – don’t forget to share it!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
