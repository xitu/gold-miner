> * 原文地址：[Workcation App – Part 4. Shared Element Transition with RecyclerView and Scenes](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 4. Shared Element Transition with RecyclerView and Scenes #

#  Workcation App – 第四部分. 场景（Scenes）和 RecyclerView 的可共享的转场动画（Shared Element Transition）

PS：貌似 Shared Element Transition 没有特别标准的译法，直译是共享元素变化。结合上下文和我 的理解翻译成可共享的转场动画

**Discover how to show details layout with Shared Element Transition with Scene Framework!**

** 探索如何通过场景框架（Scene Framework）创建展示详情页的、可共享的转场动画。
Welcome to the fourth and last part of my post series about the R&D (Research & Development) project, which I made a while ago. I want to share with you my solutions for problems I encountered during the development of an animation idea, shown below. In this blogpost, I will cover how to show details layout with Shared Element Transition with Scene Framework!

欢迎阅读本系列文章的第四篇也是最后一篇，此系列文章和我前一段时间完成的“研究与开发”项目有关。在文章里，我会针对开发中遇到的动画问题分享一些解决办法。在这篇博文里，我会编写最后的部分：如何通过场景框架（Scene Framework）创建展示详情页的、可共享的转场动画。

Part 1: [自定义 Fragment  转场](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)

Part 2: [Animating Markers 与 MapOverlayLayout ](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-2-animating-markers-with-mapoverlaylayout.md)

Part 3: [RecyclerView interaction 与 Animated Markers](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-3-recyclerview-interaction-with-animated-markers.md)

Part 4: [Shared Element Transition with RecyclerView and Scenes](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-4-shared-element-transition-recyclerview-scenes.md)

 

项目的 Git 地址:  [Workcation App](https://github.com/panwrona/Workcation)

动画的 Dribbble 地址: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)



 

## PRELUDE ##

## 序

A few months back, we had a company meeting, where my friend Paweł Szymankiewicz showed the animation he’d done during his Research & Development. And I loved it. After the meeting, I decided that I will code it. I didn’t know what I was going to struggle with…

几个月前我们开了一个部门会议，在会议上我的朋友 Paweł Szymankiewicz 给我演示了他在自己的“研究与开发”项目上制作的动画。我非常喜欢这个动画，在开完会以后我准备把用代码实现它。我可没想到到我会摊上啥...

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083)

GIF 1 *“The animation”*

# Let’s start! #

# 开始吧！

As we can see, in the GIF above, there is a lot of going on.

就像上面 GIF 动画展示的，需要做的事情有很多。

1. After clicking on the bottom menu item, we are moving to the next screen, where we can see the map being loaded with some scale/fade animation from the top, RecyclerView items loaded with translation from the bottom, markers added to the map with scale/fade animation.

1. 在点击底部菜单栏最右方的菜单后，我们会跳转到一个新界面。在此界面中，我们可以看到地图通过缩放和渐显的转场动画被加载到屏幕上方，Recycleview 的 item 随着转场动画加载到屏幕下方，地图上的标记点在转场动画执行的同时被添加到地图上。

2. While scrolling the items in RecyclerView, the markers are pulsing to show their position on the map.


当滑动底部的 RecycleView item 的时候，地图上的标记会根据 RecycleView item 的顺序（position）闪烁。
3. After clicking on the item, we are transferred to the next screen, the map is animated below to show the route and start/finish marker. The RecyclerView’s item is transitioned to show some description, bigger picture, trip details and button.


在点击一个 item 以后，我们会进入到新界面。在此界面中，地图会显示我们到标记点的路径，同时此 RecyclerView 的item 会通过转场动画展示一些关于此地点的描述，背景图片也会放大，还附有更详细的信息和一个按钮。


4. While returning, the transition happens again back to the RecyclerView’s item, all of the markers are shown again, the route disappears.


当后退时，详情页通过转场变成普通的 RecycleView Item，所有的地图标记再次显示，同时路径一起消失。 


Pretty much. That’s why I’ve decided to show you all of the things in the series of posts. In this article, I will cover how to animate markers with RecyclerView interaction!

就这么多啦，这就是我准备在这一系列文章中向你展示的东西。在本文中，我会解决如何让标记与 RecycleView 产生互动。

# The Problem #

# 需求 

Okay, so as we can see in the GIF above, after clicking on the item in RecyclerView, we are entering the details layout with some information about our trip destination. There is definitely a Shared Element Transition, where some of the views are changing their bounds, while TextView is also changing its size and details with red buttons are sliding in from the bottom. Thanks to the Transition Framework, we are able to create this amazing animation.

好吧，我们已经看过上面的GIF了。在点击了RecycleView 的 item 以后，用户进入了显示路径的详情页面。这绝对是一个可共享的转场动画（Shared Element Transition）：view 和 Textview 同时改变自身的大小、填充详情内容，红色按钮的详情从 view 的底部向上滑动显示。多亏了转场动画框架（Transition Framework），我们可以用代码这种酷炫的动画效果。

My first guess was to create just like it appears in 90% of materials on the internet – via the Shared Element Transition between two Activities. However let’s look on the map. There is also an animation “underneath” the details layout – the route is being drawn and the map zooms to the fixed position. So, I guess we don’t want to create another activity with a transparent background and try to animate the map on the “background” activity.

我最初的想法和 90%的 网上设计一样 —— 声明一个 activities 之间可共享的转场动画（Shared Element Transition）。然而让我们看一下地图，详情布局下面还有一个动画 —— 绘制我们所在位置和目标点的路径。所以创建另一个背景空白 activity 并试图在此 activity 上绘制地图的动画效果的做法是不合适的。

My second guess was to create the Shared Element Transition between two fragments – add the DetailsFragment on the top of the stack and create a transition between views in both layouts – RecyclerView’s item and DetailsFragment’s layout. A better solution, but still – for me, it looks like the same screen and the same fragment, only with another layout added on top. So, do we have a solution that fits my needs?

我第二个想法是创建一个 fragment 之间可共享的转场动画（Shared Element Transition）—— 将 DetailsFragment 添加在顶端，在两个 view 之间添加一个转场动画 —— 就是 RecycleView 的 item 和 DetailFragment 的容器。做法会好一些 —— 但是对我来说，又是同样的屏幕啊、fragment什么的，有所不同的只是最上层又添了一层布局。那么，有满足我需求的办法吗？

Yes, we have! From API 19 (the Workcation App is 21 and above) we have an option – Scenes! When used with Transition Framework, they’re really powerful. We can manage our UI in a very sophisticated way. And the most important thing – it totally fits our needs! So, let’s look at the implementation!

当然有！自从 Android 4.4 以来（Workcation App 的 SDK 是 Android 5.0 以上的版本）我们就有了这么一个选择 —— 场景（Scenes）！当使用转场框架（Transition Framework）的时候，它们确实很勥。我们可以用非常精妙的方式管理用户界面。最重要的是 —— 完全符合我们的需求！看看它是怎么实现的吧!

 
## SHARED ELEMENT TRANSITION WITH RECYCLER VIEW ##

## RecycleView 的可共享转场动画

Let’s start from clicking on the RecyclerView’s item. Our DetailsFragment (the one with Map and RecyclerView) implements OnPlaceClickedListener. We pass the OnPlaceClickListener interface implementation in the constructor like this:

让我们从点击 RecycleView 的 item 开始吧。DetailsFragment (带有地图和 RecycleView 的那个)实现了 OnPlaceClickedListener 接口。我们是这样向构造方法传递 OnPlaceClickListener 的接口实现类作为参数的：

```
Java

BaliPlacesAdapter(OnPlaceClickListener listener,Context context){

    this.listener=listener;

    this.context=context;

}
```

Next, in the *onBindViewHolder* method, we trigger the *onPlaceClicked* method after clicking on the RecyclerView’s item. We do this simply by passing it to *onClickListener:*

接着在 **onBindViewHolder** 方法中，点击 RecycleView item 以后触发 *onPlaceClicked*。我们简单的通过给item 设置 **onClickListener** 来实现：

```
@Override

public void onBindViewHolder(final BaliViewHolder holder,final int position){

    [...]

    holder.root.setOnClickListener(view->listener.onPlaceClicked(holder.root,TransitionUtils.getRecyclerViewTransitionName(position),position));

    /*
    译者注：此处是 lamda 表达式，一种便捷的匿名函数语法。等同于
    holder.root.setOnClickListener( new OnClickListener(View view) {
            listener.onPlaceClicked(holder.root,TransitionUtils.getRecyclerViewTransitionName(position),position);
        }
    );
    
    AS 里这么写需要 2.4 及以上版本，或者第三方的库。
    推荐小姐姐翻译的文章:https://github.com/xitu/gold-miner/pull/1578/files
    */

}
```

As you can see above, we set the *onClickListener* on a root element – in our case, it is a CardView. We also pass it as the first argument in the *onPlaceClicked* method, while the second one is fixed TransitionName – we are simply adding a position to the transition name. We do this because we have to distinguish which child of RecyclerView needs to be transitioned. If every item has the same:

如上所见，我们在 holder 的 root 对象上设置了一个 **onClickListener**，在我们的项目中，这个 root 对象就是 CardView 。我们也把它作为第一个参数传进了 **onPlaceClicked**
方法。第二个参数是一个固定格式的转场动画名字 —— 只是简单的用位置命名。这么做的原因是我们需要区分哪个 RecycleView 的 item 需要转场动画。每一个名字的格式都是相同的：

```
Java

public static String getRecyclerViewTransitionName(final int position){

    return DEFAULT_TRANSITION_NAME + position;

}
```

For the last parameter, we pass the position of the clicked item. We are using the same collection of data to fill RecyclerView item and DetailsLayout, so we just want to get the specific item by the position. Below we can see the OnPlaceClickListener and BaliViewHolder

最后一个参数，传入了被点击 item 的位置（position）。我们会用同样的数据集合去填充 RecycleView item 和 DetailsLayout，所以需要通过 position 获得具体的 item。下面我们会看到 OnPlaceClickListener 和 BaliViewHolder:

```
Java

interface OnPlaceClickListener{

    void onPlaceClicked(View sharedView,String transitionName,final int position);

}
```

```
Java

static class BaliViewHolder extends RecyclerView.ViewHolder{

 

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

含有有 RecycleView 和 Map 的DetailsFragment 实现了 OnPlaceClickListener 接口。让我们看一下具体的 **onPlaceClicked** 方法：

```
Java

@Override

public void onPlaceClicked(final View sharedView,final String transitionName,final int position){

    currentTransitionName=transitionName;

    detailsScene=DetailsLayout.showScene(getActivity(),containerLayout,sharedView,transitionName,baliPlaces.get(position));

    drawRoute(position);

    hideAllMarkers();

}
```

In the first place, we save *currentTransitionName* as a global variable – we will need it when we will hide scene with DetailsLayout. We also assign the Scene object to the *detailsScene* variable – it is needed to handle the *onBackPressed* method properly. In the next step, we are drawing a route between our position and the destination position; parallelly, we are hiding all markers.

在最开始，我们将 *currentTransitionName* 保存为一个全局变量 —— 当隐藏 DetailsLayout 的场景（scene） 时就会用到它了。我们还用一个场景对象给变量 **detailsScene** 赋值 ——该变量负责正确的处理 **onBackPressed** 方法。下一步，我们会绘制一条我们的位置到目标位置的路径；同时，我们需要隐藏地图上所有的标记。

The part that we are mostly interested in is the one showing the scene. Let’s move to DetailsLayout.

我们最关心的部分是如何展示这些场景，看看 DetailsLayout 是怎么做的吧！


## USING SCENE FRAMEWORK TO CREATE SHARED ELEMENT TRANSITION ##

## 使用场景（Scene Framework）来创建共享的转场动画 

Below we have our custom CoordinatorLayout. It looks ordinary in the first part, but we have two additional two static methods – *showScene* and *hideScene* . Let’s look at them more closely:

在下面是自定义的 CoordinatorLayout。一眼看上去它非常普通，但是多了两个特别的静态方法 **showScene** 和 **hideScene**。让我们再更仔细的看一下它：


```

public class DetailsLayout extends CoordinatorLayout{

 

    @BindView(R.id.cardview)
    CardView cardViewContainer;

    @BindView(R.id.headerImage)
    ImageView imageViewPlaceDetails;

    @BindView(R.id.title)
    TextView textViewTitle;

    @BindView(R.id.description)
    TextView textViewDescription;

 

    public DetailsLayout(final Context context){

        this(context,null);

    }

 

    public DetailsLayout(final Context context,final AttributeSet attrs){

        super(context,attrs);

    }

 

    @Override

    protected void onFinishInflate(){

        super.onFinishInflate();

        ButterKnife.bind(this);

    }

 

    private void setData(Place place){

        textViewTitle.setText(place.getName());

        textViewDescription.setText(place.getDescription());

    }

 

    public static Scene showScene(Activity activity,final ViewGroup container,final View sharedView,final String transitionName,final Place data){

        DetailsLayout detailsLayout=(DetailsLayout)activity.getLayoutInflater().inflate(R.layout.item_place,container,false);

        detailsLayout.setData(data);

 

        TransitionSet set=new ShowDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

        Scene scene=new Scene(container,(View)detailsLayout);

        TransitionManager.go(scene,set);

        return scene;

    }

 

    public static Scene hideScene(Activity activity,final ViewGroup container,final View sharedView,final String transitionName){

        DetailsLayout detailsLayout=(DetailsLayout)container.findViewById(R.id.bali_details_container);

 

        TransitionSet set=new HideDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

        Scene scene=new Scene(container,(View)detailsLayout);

        TransitionManager.go(scene,set);

        return scene;

    }

}
```

In the first place, we are inflating the DetailsLayout. Next, we are setting the data (just the title and description for DetailsLayout). Next, we are creating TransitionSet – for our purpose, I’ve created a separate class to keep the codebase clean. The third step is to create the scene object – we just pass our inflated *detailsLayout* and *containerView* (the main ViewGroup of DetailsFragment – in our case, it is the FrameLayout that matches the whole screen and has RecyclerView as a child). To create our amazing animation, we just need to call one method – *TransitionManager.go(scene, transitionSet)*. Et voila! This is our effect:

最开始我们先填充了 DetailsLayout。接下来，我们添加了一些数据（详情页的标题和描述）。最后我们创建了转场动画 —— 为了我们的目的，我创建了一个单独的类来保持代码空间干净整洁。第三步创建了一个场景对象 —— 我们传递了填充好的 **detailsLayout** 和 **containerView** （DetailsFragment 主要的 ViewGroup —— 在我们的项目中，这是覆盖整个屏幕和作为 RecycleView 的子元素的 FrameLayout）。我们只需要调用 **TransitionManager.go(scene, transitionSet)** 方法就能创建酷炫的效动画果：

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)

A little bit of magic happens here. TransitionManager is a class which fires transitions when the scene change occurs. With a simple call like *TransitionManager.go(scene, transitionSet),* we are able to go to the specific scene, where some kind of transition happens. In our case, we are showing DetailsLayout with some data about a trip destination but, when using a TransitionManager, we are able to make this kind of transition which you can see above. Now, let’s see how the ShowDetailsTransitionSet is implemented.

魔法出现了。TransitionManager 是一个当场景发生改变时启动转场动画的类。通过简单的调用 **TransitionManager.go(scene, transitionSet)** ，我们可以转到拥有特定转场动画的特定的场景。在我们的项目中，通过使用 TransitionManager 就可以上面那种展示含有详情和旅途描述的 DetailsLayout 了。现在让我们看一下如何实现 ShowDetailsTransitionSet 吧。

## CREATING CUSTOM TransitionSet WITH TransitionBuiler ##

## 使用 TransitionBuiler 创建自定义的 TransitionSet

For keeping the code clean, I’ve created a TransitionBuilder – a simple class made using the Builder Pattern, which allows us to write less code to make a Transition, especially the Shared Element Transition. This is how it looks like:

为了保持代码整洁，我创建了一个 TransitionBuilder —— 一个尊遵从 builder 模式的类，该类允许我们用少量的代码创建一个转场动画， 尤其是可共享的转场动画。它看起来像是这个样子的：

```
Java

public class TransitionBuilder{

 

    private Transition transition;

 

    public TransitionBuilder(final Transition transition){

        this.transition=transition;

    }

 

    public TransitionBuilder duration(long duration){

        transition.setDuration(duration);

        return this;

    }

 

    public TransitionBuilder target(View view){

        transition.addTarget(view);

        return this;

    }

 

    public TransitionBuilder target(Classclazz){

        transition.addTarget(clazz);

        return this;

    }

 

    publicTransitionBuilder target(Stringtarget){

        transition.addTarget(target);

        return this;

    }

 

    public TransitionBuilder target(int targetId){

        transition.addTarget(targetId);

        return this;

    }

 

    public TransitionBuilder delay(long delay){

        transition.setStartDelay(delay);

        return this;

    }

 

    public TransitionBuilder pathMotion(PathMotion motion){

        transition.setPathMotion(motion);

        return this;

    }

 

    public TransitionBuilder propagation(TransitionPropagation propagation){

        transition.setPropagation(propagation);

        return this;

    }

 

    public TransitionBuilder pair(Pair<View,String> pair){

        pair.first.setTransitionName(pair.second);

        transition.addTarget(pair.second);

        return this;

    }

 

    publicTransitionBuilder excludeTarget(finalView view,finalbooleanexclude){

        transition.excludeTarget(view,exclude);

        return this;

    }

 

    public TransitionBuilder excludeTarget(final String targetName,final boolean exclude){

        transition.excludeTarget(targetName,exclude);

        return this;

    }

 

    public TransitionBuilder link(final View from,final View to,final String transitionName){

        from.setTransitionName(transitionName);

        to.setTransitionName(transitionName);

        transition.addTarget(transitionName);

        return this;

    }

 

    public Transition build(){

        return transition;

    }

}
```

Okay, now let’s go to the ShowDetailsTransitionSet, which creates this amazing transition. In the constructor, we pass the Context object, transitionName – this is the one that is created with the position in RecyclerView – the View object that we are transitioning from and the DetailsLayout that we are transitioning to. We also call the *addTransition* method, where we pass the Transition built with TransitionBuilder and returned from a specific method – *textResize(), slide()* and *shared()*.

好了，现在我们可以开始编写 ShowDetailsTransitionSet 了，正是这个类实现了酷炫的转场效果。在构造函数中，我们传递了一个上下文对象，转场名 —— 就是以 RecyclerView 的 item 的位置命名的那个 ，需要转场动画连接的 View 对象。我们还调用了 **addTransition** 方法，通过该方法传递了通过 TransitionBuilder 的具体的方法 —— *textResize(), slide()* 和 *shared()* —— 创建的转场动画。

```
Java

class ShowDetailsTransitionSet extends TransitionSet{

    private static final String TITLE_TEXT_VIEW_TRANSITION_NAME="titleTextView";

    private static final StringCARD_VIEW_TRANSITION_NAME="cardView";

    private final String transitionName;

    private final View from;

    private final DetailsLayout to;

    private final Context context;

 

    ShowDetailsTransitionSet(final Context ctx,final String transitionName,final View from,final DetailsLayout to){

        context=ctx;

        this.transitionName=transitionName;

        this.from=from;

        this.to=to;

        addTransition(textResize());

        addTransition(slide());

        addTransition(shared());

    }

 

    private String titleTransitionName(){

        return transitionName + TITLE_TEXT_VIEW_TRANSITION_NAME;

    }

 

    private String cardViewTransitionName(){

        return transitionName + CARD_VIEW_TRANSITION_NAME;

    }

 

    private Transition textResize(){

        return new TransitionBuilder(newTextResizeTransition())

                .link(from.findViewById(R.id.title),to.textViewTitle,titleTransitionName())

                .build();

    }

 

    private Transition slide(){

        return new TransitionBuilder(TransitionInflater.from(context).inflateTransition(R.transition.bali_details_enter_transition))

                .excludeTarget(transitionName,true)

                .excludeTarget(to.textViewTitle,true)

                .excludeTarget(to.cardViewContainer,true)

                .build();

    }

 

    private Transition shared(){

        return new TransitionBuilder(TransitionInflater.from(context).inflateTransition(android.R.transition.move))

                .link(from.findViewById(R.id.headerImage),to.imageViewPlaceDetails,transitionName)

                .link(from,to.cardViewContainer,cardViewTransitionName())

                .build();

    }

}
```

So, recapping and describing everything above:

所以，总结一下上面做的事情。

1. RecyclerView’s item’s title is animated as a SharedElementTransition with [TextResize](https://github.com/googlesamples/android-unsplash/blob/master/app/src/main/java/com/example/android/unsplash/transition/TextResize.java) transition (it is a specific case, which is well described in this [video](https://www.youtube.com/watch?v=4L4fLrWDvAU)).

让RecyclerView item 的标题执行了 SharedElementTransition 中的 [TextResize](https://github.com/googlesamples/android-unsplash/blob/master/app/src/main/java/com/example/android/unsplash/transition/TextResize.java)  动画（这是一个特定的项目,[这里](https://www.youtube.com/watch?v=4L4fLrWDvAU)有详细解释）。

2. The whole layout has a custom slide transition, implemented with some of kind start delay for a specific child.

整个布局执行了一个滑动的转场动画，实现了某种意义上的延迟加载。

3. The RecyclerView’s item’s header and container have SharedElementTransition implemented with a Move transition – the default transition for Android’s framework.

RecycleView 的item 的标题和内容通过 实现SharedElementTransition 有了一个转场动画 —— 默认使用的 android 自身的框架
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

通过这些不同的转场动画，我们就可以为我们的布局创建进入的效果
！

[](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)

Looks awesome to me! But what about a returning scene? Look below!

在我看起来真是碉堡了！但是返回怎么办呢？看下面。

## RETURNING TO THE PREVIOUS Scene AND HANDLING *onBackPress* ##

## 返回上一步场景，处理 **onBackPress**

As you can remember, we have two methods in  DetailsLayout 中 – *showScene* and *hideScene.* We’ve just covered the first method, but what’s with the second method? Let’s cover it too!

如果你还记得的话，我们在 DetailsLayout 中写了两个方法 —— *showScene* 和 *hideScene*。我们已经写了第一个方法，但是第二个方法是什么样的呢？让我们继续把它也写完吧。

```
public static Scene hideScene(Activity activity,final ViewGroup container,final View sharedView,final String transitionName){

    DetailsLayout detailsLayout=(DetailsLayout)container.findViewById(R.id.bali_details_container);

 

    TransitionSet set=newHideDetailsTransitionSet(activity,transitionName,sharedView,detailsLayout);

    Scene scene=newScene(container,(View)detailsLayout);

    TransitionManager.go(scene,set);

    return scene;

}
```

Now, there are few changes. We’ve added the DetailsLayout to DetailsFragment’s container (the FrameLayout mentioned before). So, to obtain DetailsLayout, we have to call *findViewById* on this container. Then, we have to create the TransitionSet with specific targets and specified settings. For this purpose, I’ve also written another class which inherits from TransitionSet – HideDetailsTransitionSet. This is how it looks:

现在，有一些小的改变。既然在 DetailsFragment 容器(之前提到的那个 FrameLayout) 上面添加了一个 DetailsLayout ，所以为了获得 DetailsLayout，我们还得在容器里调用 **findViewById**。然后我们必须创建特定的对象和转场，编写特定的设置。为此，我也写了另一个类来继承 TransitionSet —— HideDetailsTransitionSet。它看起来像是这个样子的：

```
Java

class HideDetailsTransitionSet extends TransitionSet{

    private static final String TITLE_TEXT_VIEW_TRANSITION_NAME="titleTextView";

    private static final String CARD_VIEW_TRANSITION_NAME="cardView";

    private final String transitionName;

    private final View from;

    private final DetailsLayout to;

    private final Context context;

 

    HideDetailsTransitionSet(final Context ctx,final String transitionName,final View from,final DetailsLayout to){

        context=ctx;

        this.transitionName=transitionName;

        this.from=from;

        this.to=to;

        addTransition(textResize());

        addTransition(shared());

    }

 

    private String titleTransitionName(){

        return transitionName+TITLE_TEXT_VIEW_TRANSITION_NAME;

    }

 

    private String cardViewTransitionName(){

        return transitionName+CARD_VIEW_TRANSITION_NAME;

    }

 

    private Transition textResize(){

        return newTransitionBuilder(newTextResizeTransition())

                .link(from.findViewById(R.id.title),to.textViewTitle,titleTransitionName())

                .build();

    }

 

    private Transition shared(){

        return new TransitionBuilder(TransitionInflater.from(context).inflateTransition(android.R.transition.move))

                .link(from.findViewById(R.id.headerImage),to.imageViewPlaceDetails,transitionName)

                .link(from,to.cardViewContainer,cardViewTransitionName())

                .build();

    }

}
```

In this case, we have *textResize**()* and *shared()* transitions once again. If you look closely at both methods, you will see that this TranstionBuilder has method *link()*. This method takes three parameters – sourceView, targetView and transitionName. It simply puts transitionName on sourceView and targetView, as well as placing it as a target on Transition object. So it’s used to “link” two views for Shared Element Transition.

在这个项目，我们又一次编写了 **textResize()** 和 **shared()** 。如果你仔细检查两个方法的话，你会发现 TranstionBuilder 有 **link()**
 方法。这种方法接收了3个参数 —— 源头 view、目标 view 和动画名字。它把转场动画的名字添加给了 源头 View 和目标 view，就像把它指定到了一个转场对象上。所以它用来“连接（link）” 两个view。
 
The rest looks the same. We create the Scene object, call TransitionManager*.go()* and voila! We have returned to the previous state!

剩下的部分就一样啦，我们又创建了一个场景对象，调用 TransitionManager.**go()** 然后哈利路亚~我们就可以返回之前的状态了。

 

## CONCLUSION ##

## 结语

As we can see – the sky’s the limit! We are able to create meaningful transitions with activities, fragments and even the layouts! Scenes and Transitions are really powerful and can really improve the UI and UX. What are the benefits from this solution? First of all, we don’t have another lifecycle to care about.  Secondly, there are some libraries that help us to create “fragmentless” UI. Applied with Scenes and Transitions, we can develop a pretty nice app. Thirdly, this approach is really rare, however, I think it’s giving us more control.

如我们所见 —— 天空才是我们的极限。我们可以创造有意义的转场动画连接 activity、fragment 甚至是 layout。场景和转场动画十分流弊，增进了用户界面和 用户体验。这种解决方案有什么好处呢？首先，我们不需要在关注另一个生命周期。其次，有许多第三方的库帮我们创建不需要 fragment 的用户界面。通过部署场景和转场动画，我们开发了一个非常不错的 app。第三，该方案很少见，但是确实让我们能更多的控制效果的实现。

That’s all folks! Thank you very much for reading my series of posts, I hope you liked it!

就这么多了。非常感谢阅读这一系列的文章，希望你喜欢它！

See you soon!

铁甲依然在！

Mariusz Brona aka panwrona

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
