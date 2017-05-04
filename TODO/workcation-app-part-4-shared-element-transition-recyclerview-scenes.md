> * 原文地址：[Workcation App – Part 4. Shared Element Transition with RecyclerView and Scenes](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 4. Shared Element Transition with RecyclerView and Scenes #

**Discover how to show details layout with Shared Element Transition with Scene Framework!**

Welcome to the fourth and last part of my post series about the R&D (Research & Development) project, which I made a while ago. I want to share with you my solutions for problems I encountered during the development of an animation idea, shown below. In this blogpost, I will cover how to show details layout with Shared Element Transition with Scene Framework!

Part 1: [Fragment’s custom transition
](https://www.thedroidsonroids.com/?p=5054)

Part 2: [Animating Markers with MapOverlayLayout](https://www.thedroidsonroids.com/blog/workcation-app-part-2-animating-markers-with-mapoverlaylayout)

Part 3: [RecyclerView interaction with Animated Markers](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)

**Part 4: Shared element transition with RecyclerView and Scenes**

Link for the project on Github:  [Workcation App](https://github.com/panwrona/Workcation)

Link for the animation on Dribbble:
[https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)

 

## PRELUDE ##

A few months back, we had a company meeting, where my friend Paweł Szymankiewicz showed the animation he’d done during his Research & Development. And I loved it. After the meeting, I decided that I will code it. I didn’t know what I was going to struggle with…

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083)

GIF 1 *“The animation”*

## LET’S START! ##

As we can see, in the GIF above, there is a lot of going on.

1. After clicking on the bottom menu item, we are moving to the next screen, where we can see the map being loaded with some scale/fade animation from the top, RecyclerView items are loaded with translation from the bottom, while markers are added to the map with a scale/fade animation.
2. While scrolling the items in RecyclerView, the markers are pulsing to show their position on the map.
3. After clicking on an item, we are transferred to the next screen, while the map is animated below to show the route and the start/finish marker. The RecyclerView’s item is transitioned to show some description, a bigger picture, trip details and button.
4. While returning, the transition happens again back to the RecyclerView’s item, showing all of the markers again, as the route disappears.

That’s pretty much it. This is also why I’ve decided to show you all of these things in a series of posts. As I have mentioned above, in this article, I will cover how to show a details layout with Shared Element Transition with Scene and Transition Framework!

## THE PROBLEM ##

Okay, so as we can see in the GIF above, after clicking on the item in RecyclerView, we are entering the details layout with some information about our trip destination. There is definitely a Shared Element Transition, where some of the views are changing their bounds, while TextView is also changing its size and details with red buttons are sliding in from the bottom. Thanks to the Transition Framework, we are able to create this amazing animation.

My first guess was to create just like it appears in 90% of materials on the internet – via the Shared Element Transition between two Activities. However let’s look on the map. There is also an animation “underneath” the details layout – the route is being drawn and the map zooms to the fixed position. So, I guess we don’t want to create another activity with a transparent background and try to animate the map on the “background” activity.

My second guess was to create the Shared Element Transition between two fragments – add the DetailsFragment on the top of the stack and create a transition between views in both layouts – RecyclerView’s item and DetailsFragment’s layout. A better solution, but still – for me, it looks like the same screen and the same fragment, only with another layout added on top. So, do we have a solution that fits my needs?

Yes, we have! From API 19 (the Workcation App is 21 and above) we have an option – Scenes! When used with Transition Framework, they’re really powerful. We can manage our UI in a very sophisticated way. And the most important thing – it totally fits our needs! So, let’s look at the implementation!

 
## SHARED ELEMENT TRANSITION WITH RECYCLER VIEW ##

Let’s start from clicking on the RecyclerView’s item. Our DetailsFragment (the one with Map and RecyclerView) implements OnPlaceClickedListener. We pass the OnPlaceClickListener interface implementation in the constructor like this:

```
Java

BaliPlacesAdapter(OnPlaceClickListener listener,Context context){

    this.listener=listener;

    this.context=context;

}
```

Next, in the *onBindViewHolder* method, we trigger the *onPlaceClicked* method after clicking on the RecyclerView’s item. We do this simply by passing it to *onClickListener:*

```
@Override

publicvoidonBindViewHolder(finalBaliViewHolder holder,finalintposition){

    [...]

    holder.root.setOnClickListener(view->listener.onPlaceClicked(holder.root,TransitionUtils.getRecyclerViewTransitionName(position),position));

}
```

As you can see above, we set the *onClickListener* on a root element – in our case, it is a CardView. We also pass it as the first argument in the *onPlaceClicked* method, while the second one is fixed TransitionName – we are simply adding a position to the transition name. We do this because we have to distinguish which child of RecyclerView needs to be transitioned. If every item has the same:

```
Java

publicstaticStringgetRecyclerViewTransitionName(finalintposition){

    returnDEFAULT_TRANSITION_NAME+position;

}
```

For the last parameter, we pass the position of the clicked item. We are using the same collection of data to fill RecyclerView item and DetailsLayout, so we just want to get the specific item by the position. Below we can see the OnPlaceClickListener and BaliViewHolder

```
Java

interfaceOnPlaceClickListener{

    voidonPlaceClicked(View sharedView,StringtransitionName,finalintposition);

}
```

```
Java

staticclassBaliViewHolder extendsRecyclerView.ViewHolder{

 

    @BindView(R.id.title)TextView title;

    @BindView(R.id.price)TextView price;

    @BindView(R.id.opening_hours)TextView openingHours;

    @BindView(R.id.root)CardView root;

    @BindView(R.id.headerImage)ImageView placePhoto;

 

    BaliViewHolder(finalView itemView){

        super(itemView);

        ButterKnife.bind(this,itemView);

    }

}
```

The OnPlaceClickListener is implemented in DetailsFragment – the one that has RecyclerView and Map. Let’s look at the *onPlaceClicked* method:

```
Java

@Override

publicvoidonPlaceClicked(finalView sharedView,finalStringtransitionName,finalintposition){

    currentTransitionName=transitionName;

    detailsScene=DetailsLayout.showScene(getActivity(),containerLayout,sharedView,transitionName,baliPlaces.get(position));

    drawRoute(position);

    hideAllMarkers();

}
```

In the first place, we save *currentTransitionName* as a global variable – we will need it when we will hide scene with DetailsLayout. We also assign the Scene object to the *detailsScene* variable – it is needed to handle the *onBackPressed* method properly. In the next step, we are drawing a route between our position and the destination position; parallelly, we are hiding all markers.

The part that we are mostly interested in is the one showing the scene. Let’s move to DetailsLayout.

## USING SCENE FRAMEWORK TO CREATE SHARED ELEMENT TRANSITION ##

Below we have our custom CoordinatorLayout. It looks ordinary in the first part, but we have two additional two static methods – *showScene* and *hideScene* . Let’s look at them more closely:

```

publicclassDetailsLayoutextendsCoordinatorLayout{

 

    @BindView(R.id.cardview)CardView cardViewContainer;

    @BindView(R.id.headerImage)ImageView imageViewPlaceDetails;

    @BindView(R.id.title)TextView textViewTitle;

    @BindView(R.id.description)TextView textViewDescription;

 

    publicDetailsLayout(finalContext context){

        this(context,null);

    }

 

    publicDetailsLayout(finalContext context,finalAttributeSet attrs){

        super(context,attrs);

    }

 

    @Override

    protectedvoidonFinishInflate(){

        super.onFinishInflate();

        ButterKnife.bind(this);

    }

 

    privatevoidsetData(Place place){

        textViewTitle.setText(place.getName());

        textViewDescription.setText(place.getDescription());

    }

 

    publicstaticScene showScene(Activity activity,finalViewGroup container,finalView sharedView,finalStringtransitionName,finalPlace data){

        DetailsLayout detailsLayout=(DetailsLayout)activity.getLayoutInflater().inflate(R.layout.item_place,container,false);

        detailsLayout.setData(data);

 

        TransitionSet set=new ShowDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

        Scene scene=new Scene(container,(View)detailsLayout);

        TransitionManager.go(scene,set);

        returnscene;

    }

 

    publicstaticScene hideScene(Activity activity,finalViewGroup container,finalView sharedView,finalStringtransitionName){

        DetailsLayout detailsLayout=(DetailsLayout)container.findViewById(R.id.bali_details_container);

 

        TransitionSet set=new HideDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

        Scene scene=new Scene(container,(View)detailsLayout);

        TransitionManager.go(scene,set);

        returnscene;

    }

}
```

In the first place, we are inflating the DetailsLayout. Next, we are setting the data (just the title and description for DetailsLayout). Next, we are creating TransitionSet – for our purpose, I’ve created a separate class to keep the codebase clean. The third step is to create the scene object – we just pass our inflated *detailsLayout* and *containerView* (the main ViewGroup of DetailsFragment – in our case, it is the FrameLayout that matches the whole screen and has RecyclerView as a child). To create our amazing animation, we just need to call one method – *TransitionManager.go(scene, transitionSet)*. Et voila! This is our effect:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)

A little bit of magic happens here. TransitionManager is a class which fires transitions when the scene change occurs. With a simple call like *TransitionManager.go(scene, transitionSet),* we are able to go to the specific scene, where some kind of transition happens. In our case, we are showing DetailsLayout with some data about a trip destination but, when using a TransitionManager, we are able to make this kind of transition which you can see above. Now, let’s see how the ShowDetailsTransitionSet is implemented.

 

## CREATING CUSTOM TransitionSet WITH TransitionBuiler ##

For keeping the code clean, I’ve created a TransitionBuilder – a simple class made using the Builder Pattern, which allows us to write less code to make a Transition, especially the Shared Element Transition. This is how it looks like:

```
Java

publicclassTransitionBuilder{

 

    privateTransition transition;

 

    publicTransitionBuilder(finalTransition transition){

        this.transition=transition;

    }

 

    publicTransitionBuilder duration(longduration){

        transition.setDuration(duration);

        returnthis;

    }

 

    publicTransitionBuilder target(View view){

        transition.addTarget(view);

        returnthis;

    }

 

    publicTransitionBuilder target(Classclazz){

        transition.addTarget(clazz);

        returnthis;

    }

 

    publicTransitionBuilder target(Stringtarget){

        transition.addTarget(target);

        returnthis;

    }

 

    publicTransitionBuilder target(inttargetId){

        transition.addTarget(targetId);

        returnthis;

    }

 

    publicTransitionBuilder delay(longdelay){

        transition.setStartDelay(delay);

        returnthis;

    }

 

    publicTransitionBuilder pathMotion(PathMotion motion){

        transition.setPathMotion(motion);

        returnthis;

    }

 

    publicTransitionBuilder propagation(TransitionPropagation propagation){

        transition.setPropagation(propagation);

        returnthis;

    }

 

    publicTransitionBuilder pair(Pair<View,String>pair){

        pair.first.setTransitionName(pair.second);

        transition.addTarget(pair.second);

        returnthis;

    }

 

    publicTransitionBuilder excludeTarget(finalView view,finalbooleanexclude){

        transition.excludeTarget(view,exclude);

        returnthis;

    }

 

    publicTransitionBuilder excludeTarget(finalStringtargetName,finalbooleanexclude){

        transition.excludeTarget(targetName,exclude);

        returnthis;

    }

 

    publicTransitionBuilder link(finalView from,finalView to,finalStringtransitionName){

        from.setTransitionName(transitionName);

        to.setTransitionName(transitionName);

        transition.addTarget(transitionName);

        returnthis;

    }

 

    publicTransition build(){

        returntransition;

    }

}
```

Okay, now let’s go to the ShowDetailsTransitionSet, which creates this amazing transition. In the constructor, we pass the Context object, transitionName – this is the one that is created with the position in RecyclerView – the View object that we are transitioning from and the DetailsLayout that we are transitioning to. We also call the *addTransition* method, where we pass the Transition built with TransitionBuilder and returned from a specific method – *textResize(), slide()* and *shared()*.

```
Java

classShowDetailsTransitionSetextendsTransitionSet{

    privatestaticfinalStringTITLE_TEXT_VIEW_TRANSITION_NAME="titleTextView";

    privatestaticfinalStringCARD_VIEW_TRANSITION_NAME="cardView";

    privatefinalStringtransitionName;

    privatefinalView from;

    privatefinalDetailsLayout to;

    privatefinalContext context;

 

    ShowDetailsTransitionSet(finalContext ctx,finalStringtransitionName,finalView from,finalDetailsLayout to){

        context=ctx;

        this.transitionName=transitionName;

        this.from=from;

        this.to=to;

        addTransition(textResize());

        addTransition(slide());

        addTransition(shared());

    }

 

    privateStringtitleTransitionName(){

        returntransitionName+TITLE_TEXT_VIEW_TRANSITION_NAME;

    }

 

    privateStringcardViewTransitionName(){

        returntransitionName+CARD_VIEW_TRANSITION_NAME;

    }

 

    privateTransition textResize(){

        returnnewTransitionBuilder(newTextResizeTransition())

                .link(from.findViewById(R.id.title),to.textViewTitle,titleTransitionName())

                .build();

    }

 

    privateTransition slide(){

        returnnewTransitionBuilder(TransitionInflater.from(context).inflateTransition(R.transition.bali_details_enter_transition))

                .excludeTarget(transitionName,true)

                .excludeTarget(to.textViewTitle,true)

                .excludeTarget(to.cardViewContainer,true)

                .build();

    }

 

    privateTransition shared(){

        returnnewTransitionBuilder(TransitionInflater.from(context).inflateTransition(android.R.transition.move))

                .link(from.findViewById(R.id.headerImage),to.imageViewPlaceDetails,transitionName)

                .link(from,to.cardViewContainer,cardViewTransitionName())

                .build();

    }

}
```

So, recapping and describing everything above:

1. RecyclerView’s item’s title is animated as a SharedElementTransition with [TextResize](https://github.com/googlesamples/android-unsplash/blob/master/app/src/main/java/com/example/android/unsplash/transition/TextResize.java) transition (it is a specific case, which is well described in this [video](https://www.youtube.com/watch?v=4L4fLrWDvAU)).
2. The whole layout has a custom slide transition, implemented with some of kind start delay for a specific child.
3. The RecyclerView’s item’s header and container have SharedElementTransition implemented with a Move transition – the default transition for Android’s framework.

```
XHTML

<?xml version="1.0"encoding="utf-8"?>

<transitionSet xmlns:android="http://schemas.android.com/apk/res/android"

    android:transitionOrdering="together"

    android:duration="500">

    <slide

        android:slideEdge="bottom"

        android:interpolator="@android:interpolator/decelerate_cubic">

        <targets>

            <target android:targetId="@id/descriptionLayout" />

        </targets>

    </slide>

 

    <slide

        android:slideEdge="bottom"

        android:interpolator="@android:interpolator/decelerate_cubic"

        android:startDelay="100">

        <targets>

            <target android:targetId="@id/description" />

        </targets>

    </slide>

 

    <fade

        android:interpolator="@android:interpolator/decelerate_cubic"

        android:startDelay="100">

        <targets>

            <target android:targetId="@id/description" />

        </targets>

    </fade>

 

    <slide

        android:slideEdge="bottom"

        android:interpolator="@android:interpolator/decelerate_cubic"

        android:startDelay="200">

        <targets>

            <target android:targetId="@id/takeMe" />

        </targets>

    </slide>

</transitionSet>
```

With this set of different transitions we are able to create this “enter transition” for our layout:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)

Looks awesome to me! But what about a returning scene? Look below!

 

## RETURNING TO THE PREVIOUS Scene AND HANDLING *onBackPress* ##

As you can remember, we have two methods in DetailsLayout – *showScene* and *hideScene.* We’ve just covered the first method, but what’s with the second method? Let’s cover it too!

```
publicstaticScene hideScene(Activity activity,finalViewGroup container,finalView sharedView,finalStringtransitionName){

    DetailsLayout detailsLayout=(DetailsLayout)container.findViewById(R.id.bali_details_container);

 

    TransitionSet set=newHideDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

    Scene scene=newScene(container,(View)detailsLayout);

    TransitionManager.go(scene,set);

    returnscene;

}
```

Now, there are few changes. We’ve added the DetailsLayout to DetailsFragment’s container (the FrameLayout mentioned before). So, to obtain DetailsLayout, we have to call *findViewById* on this container. Then, we have to create the TransitionSet with specific targets and specified settings. For this purpose, I’ve also written another class which inherits from TransitionSet – HideDetailsTransitionSet. This is how it looks:

```
Java

classHideDetailsTransitionSetextendsTransitionSet{

    privatestaticfinalStringTITLE_TEXT_VIEW_TRANSITION_NAME="titleTextView";

    privatestaticfinalStringCARD_VIEW_TRANSITION_NAME="cardView";

    privatefinalStringtransitionName;

    privatefinalView from;

    privatefinalDetailsLayout to;

    privatefinalContext context;

 

    HideDetailsTransitionSet(finalContext ctx,finalStringtransitionName,finalView from,finalDetailsLayout to){

        context=ctx;

        this.transitionName=transitionName;

        this.from=from;

        this.to=to;

        addTransition(textResize());

        addTransition(shared());

    }

 

    privateStringtitleTransitionName(){

        returntransitionName+TITLE_TEXT_VIEW_TRANSITION_NAME;

    }

 

    privateStringcardViewTransitionName(){

        returntransitionName+CARD_VIEW_TRANSITION_NAME;

    }

 

    privateTransition textResize(){

        returnnewTransitionBuilder(newTextResizeTransition())

                .link(from.findViewById(R.id.title),to.textViewTitle,titleTransitionName())

                .build();

    }

 

    privateTransition shared(){

        returnnewTransitionBuilder(TransitionInflater.from(context).inflateTransition(android.R.transition.move))

                .link(from.findViewById(R.id.headerImage),to.imageViewPlaceDetails,transitionName)

                .link(from,to.cardViewContainer,cardViewTransitionName())

                .build();

    }

}
```

In this case, we have *textResize**()* and *shared()* transitions once again. If you look closely at both methods, you will see that this TranstionBuilder has method *link()*. This method takes three parameters – sourceView, targetView and transitionName. It simply puts transitionName on sourceView and targetView, as well as placing it as a target on Transition object. So it’s used to “link” two views for Shared Element Transition.

The rest looks the same. We create the Scene object, call TransitionManager*.go()* and voila! We have returned to the previous state!

 

## CONCLUSION ##

As we can see – the sky’s the limit! We are able to create meaningful transitions with activities, fragments and even the layouts! Scenes and Transitions are really powerful and can really improve the UI and UX. What are the benefits from this solution? First of all, we don’t have another lifecycle to care about.  Secondly, there are some libraries that help us to create “fragmentless” UI. Applied with Scenes and Transitions, we can develop a pretty nice app. Thirdly, this approach is really rare, however, I think it’s giving us more control.

That’s all folks! Thank you very much for reading my series of posts, I hope you liked it!

See you soon!

Mariusz Brona aka panwrona

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
