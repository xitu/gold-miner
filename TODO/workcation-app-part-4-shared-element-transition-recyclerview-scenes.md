> * 原文地址：[Workcation App – Part 4. Shared Element Transition with RecyclerView and Scenes](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-4-shared-element-transition-recyclerview-scenes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[龙骑将杨影枫](https://github.com/stormrabbit)
> * 校对者：[张拭心](https://github.com/shixinzhang)、[Feximin](https://github.com/Feximin)

#  Workcation App – 第四部分. 场景（Scenes）和 RecyclerView 的共享元素转场动画（Shared Element Transition）


**探索如何通过场景框架（Scene Framework）创建展示详情页的共享元素转场动画(Shared Element Transition)**。

欢迎阅读本系列文章的第四篇也是最后一篇，此系列文章和我前一段时间完成的“研发”项目有关。在文章里，我会针对开发中遇到的动画问题分享一些解决办法。在这篇博文里，我会编写最后的部分：如何通过场景框架（Scene Framework）创建展示详情页的共享元素转场动画（Shared Element Transition）。

Part 1: [自定义 Fragment  转场](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)

Part 2: [带有动画的标记（Animating Markers） 与 MapOverlayLayout ](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-2-animating-markers-with-mapoverlaylayout.md)

Part 3: [带有动画的标记（Animated Markers） 与 RecyclerView 的互动](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-3-recyclerview-interaction-with-animated-markers.md)

Part 4: [场景（Scenes）和 RecyclerView 的共享元素转场动画（Shared Element Transition）](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-4-shared-element-transition-recyclerview-scenes.md)

项目的 Git 地址:  [Workcation App](https://github.com/panwrona/Workcation)

动画的 Dribbble 地址: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)


## 序言

几个月前我们开了一个部门会议，在会议上我的朋友 Paweł Szymankiewicz 给我演示了他在自己的“研发”项目上制作的动画。我非常喜欢这个动画，在开完会以后我准备把用代码实现它。我可没想到到我会摊上啥...

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083)

GIF 1 **“动画效果”**

# 开始吧！

就像上面 GIF 动画展示的，需要做的事情有很多。

1. 在点击底部菜单栏最右方的菜单后，我们会跳转到一个新界面。在此界面中，地图通过缩放和渐显的转场动画在屏幕上方加载，Recycleview 的 item 随着转场动画从底部加载，地图上的标记点在转场动画执行的同时被添加到地图上.

2. 当滑动底部的 RecycleView item 的时候，地图上的标记会通过闪烁来显示它们的位置(译者注：原文是show their **position** on the map，个人认为 position 有两层含义：一代表标记在地图上的位置，二代表标记所对应的 item 在 RecycleView 里的位置。)

3. 在点击一个 item 以后，我们会进入到新界面。在此界面中，地图通过动画方式来显示出路径以及起始/结束标记。同时此 RecyclerView 的item 会通过转场动画展示一些关于此地点的描述，背景图片也会放大，还附有更详细的信息和一个按钮。

4. 当后退时，详情页通过转场变成普通的 RecycleView Item，所有的地图标记再次显示，同时路径一起消失。

就这么多啦，这就是我准备在这一系列文章中向你展示的东西。在本文中，我回展示如何通过场景框架、共享元素转场动画来展示详情页。

# 需求

好吧，我们已经看过上面的GIF了。在点击了RecycleView 的 item 以后，我们进入了详情页面，上面显示了旅行目的地的一些信息。这确实是一个共享元素的转场动画：view 和 Textview 同时改变自身的大小、填充详情内容，含有红色按钮的详情介绍从底部向上滑动显示。多亏了转场动画框架（Transition Framework），我们可以用代码实现这种酷炫的动画效果。

我最初的想法和 90%的 网上设计一样 —— 声明一个 activities 之间的共享元素转场动画（Shared Element Transition）。然而让我们看一下地图，详情布局下面还有一个动画 —— 绘制路径同时地图缩放至特定位置。所以创建另一个背景透明 activity 并试图在此 activity 上绘制地图的动画效果的做法是不合适的。

我第二个想法是创建一个 fragment 之间的共享元素转场动画（Shared Element Transition）—— 将 DetailsFragment 添加在顶端，在两个 view 之间添加一个转场动画 —— 就是 RecycleView 的 item 和 DetailFragment 的容器。这么做是更好一些 —— 但是对我来说，又是同样的屏幕啊、fragment什么的，有所不同的只是最上层又添了一层布局。那么，有满足我需求的办法吗？

当然有！自从 Android 4.4 以来（Workcation App 的 SDK 是 Android 5.0 以上的版本）我们就有了这么一个选择 —— 场景（Scenes）！当使用转场框架（Transition Framework）的时候，它们确实很勥。我们可以用非常精妙的方式管理用户界面。最重要的是 —— 完全符合我们的需求！看看它是怎么实现的吧!

## RecycleView 的可共享转场动画

让我们从点击 RecycleView 的 item 开始吧。DetailsFragment (带有地图和 RecycleView 的那个)实现了 OnPlaceClickedListener 接口。我们是这样向构造方法传递 OnPlaceClickListener 的接口实现类作为参数的：

```
Java

BaliPlacesAdapter(OnPlaceClickListener listener,Context context){

    this.listener=listener;

    this.context=context;

}
```

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

如上所见，我们在 holder 的根节点上设置了点击事件（ **onClickListener**），在本项目中，这个根节点就是 CardView 。我们也把它作为第一个参数传进了 **onPlaceClicked**
方法。第二个参数是一个固定格式的转场动画名字 —— 只是简单的用位置命名。这么做的原因是我们需要区分哪个 RecycleView 的 item 需要转场动画。每一个名字的格式都是相同的：

```
Java

public static String getRecyclerViewTransitionName(final int position){

    return DEFAULT_TRANSITION_NAME + position;

}
```

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

在最开始，我们将 **currentTransitionName** 保存为一个全局变量 —— 当隐藏 DetailsLayout 的场景（scene） 时就会用到它了。同时我们还将这个场景对象赋值给 **detailsScene** 变量 —— 该变量负责正确的处理 **onBackPressed** 方法。下一步，我们会绘制一条我们的位置到目标位置的路径；同时，我们需要隐藏地图上所有的标记。

我们最关心的部分是如何展示这些场景，看看 DetailsLayout 是怎么做的吧！

## 使用场景（Scene Framework）来创建共享的转场动画

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

最开始我们先渲染了 DetailsLayout。接下来，我们添加了一些数据（详情页的标题和描述）。最后我们创建了转场动画 —— 为了我们的目的，我创建了一个单独的类来保持代码空间干净整洁。第三步创建了一个场景对象 —— 我们传递了渲染好的 **detailsLayout** 和 **containerView** （DetailsFragment 主要的 ViewGroup —— 在我们的项目中，这是覆盖整个屏幕并且有一个 RecycleView 作为子元素的 FrameLayout）。我们只需要调用 **TransitionManager.go(scene, transitionSet)** 方法就能创建酷炫的效动画果：

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)


魔法出现了。TransitionManager 是一个当场景发生改变时启动转场动画的类。通过简单的调用 **TransitionManager.go(scene, transitionSet)** ，我们可以转到拥有特定转场动画的特定的场景。在我们的项目中，通过使用 TransitionManager 就可以上面那种展示含有详情和旅途描述的 DetailsLayout 了。现在让我们看一下如何实现 ShowDetailsTransitionSet 吧。

## 使用 TransitionBuiler 创建自定义的 TransitionSet


为了保持代码整洁，我创建了一个 TransitionBuilder —— 一个尊遵从 builder 模式的类，该类允许我们用少量的代码创建一个转场动画， 尤其是共享元素转场动画。它看起来像是这个样子的：

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

好了，现在我们可以开始编写 ShowDetailsTransitionSet 了，正是这个类实现了酷炫的转场效果。在构造函数中，我们传递了一个上下文对象，转场名 —— 就是以 RecyclerView 的 item 的位置命名的那个，转场开始的View对象以及转场结束的DetailsLayout。我们还调用了 **addTransition** 方法，通过该方法传递了通过 TransitionBuilder 的具体的方法 —— *textResize(), slide()* 和 *shared()* —— 创建的转场动画。

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

所以，总结一下上面做的事情。

1. 让RecyclerView item 的标题执行了 SharedElementTransition 中的 [TextResize](https://github.com/googlesamples/android-unsplash/blob/master/app/src/main/java/com/example/android/unsplash/transition/TextResize.java)  动画（这是一个特定的项目,[这里](https://www.youtube.com/watch?v=4L4fLrWDvAU)有详细解释）。

2. 整个布局执行了一个滑动的转场动画，实现了某种意义上的延迟加载。

3. RecycleView 的item 的标题和内容有一个共享元素转场动画（Shared Element Transition），它实现了Android 框架默认的转场动画 —— Move transition。
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

通过这些不同的转场动画，我们就可以为我们的布局创建进入的效果
！

[](https://www.thedroidsonroids.com/wp-content/uploads/2017/04/ezgif.com-video-to-gif-1.gif?x77083)

在我看起来真是碉堡了！但是返回怎么办呢？看下面。

## 返回上一步场景，处理 **onBackPress**

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

在这个项目，我们又一次编写了 **textResize()** 和 **shared()** 。如果你仔细检查两个方法的话，你会发现 TranstionBuilder 有 **link()**
 方法。这种方法接收了3个参数 —— 源头 view、目标 view 和动画名字。它把转场动画的名字添加给了 源头 View 和目标 view，就像把它指定到了一个转场对象上。所以它用来“连接（link）” 两个view。

剩下的部分就一样啦，我们又创建了一个场景对象，调用 TransitionManager.**go()** 然后哈利路亚~我们就可以返回之前的状态了。

## 结语

如我们所见 —— 思考永无止境（the sky’s the limit）！我们可以为 activities、fragments 甚至 layouts 创造有意义的转场动画。场景和转场动画十分流弊，增进了用户界面和 用户体验。这种解决方案有什么好处呢？首先，我们不需要在关注另一个生命周期。其次，有许多第三方的库帮我们创建不需要 fragment 的用户界面。通过部署场景和转场动画，我们可以开发出一个非常不错的 app。第三，该方案很少见，但是确实让我们能更多的控制效果如何实现。

就这么多了。非常感谢阅读这一系列的文章，希望你喜欢它！

铁甲依然在！（译者：咳咳，原文是 See you soon!）

Mariusz Brona aka panwrona

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
