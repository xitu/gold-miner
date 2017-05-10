> * 原文地址：[Workcation App – Part 3. RecyclerView interaction with Animated Markers](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 3. RecyclerView interaction with Animated Markers #

#  Workcation App – 第三部分.Animated Markers 与 RecyclerView 的互动 #

Welcome to the second of series of posts about my R&D (Research & Development) project I’ve made a while ago. In this blog posts, I want to share my solutions for problems I encountered during the development of an animation idea you’ll see below.

欢迎阅读本系列文章的第三篇，此系列文章和我前一段时间完成的“研究与开发”项目有关。在文章里，我会针对开发中遇到的动画问题分享一些解决办法。

Part 1: [自定义 Fragment  转场](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-1-fragments-custom-transition.md)

Part 2: [Animating Markers 与 MapOverlayLayout ](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-2-animating-markers-with-mapoverlaylayout.md)

Part 3: [RecyclerView interaction 与 Animated Markers](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-3-recyclerview-interaction-with-animated-markers.md)

Part 4: [Shared Element Transition with RecyclerView and Scenes](https://github.com/xitu/gold-miner/blob/master/TODO/workcation-app-part-4-shared-element-transition-recyclerview-scenes.md)

 

项目的 Git 地址:  [Workcation App](https://github.com/panwrona/Workcation)

动画的 Dribbble 地址: [https://dribbble.com/shots/2881299-Workcation-App-Map-Animation](https://dribbble.com/shots/2881299-Workcation-App-Map-Animation)

 

# Prelude #

A few months back we’ve had a company meeting, where my friend Paweł Szymankiewicz showed the animation he’d done during his Research & Development. And I loved it. After the meeting, I decided that I will code it. I never knew what I’m going to struggle with…


几个月前我们开了一个部门会议，在会议上我的朋友 Paweł Szymankiewicz 给我演示了他在自己的“研究与开发”项目上制作的动画。我非常喜欢这个动画，在开完会以后我准备把用代码实现它。我可没想到到我会摊上啥...


![](https://www.thedroidsonroids.com/wp-content/uploads/2017/02/Bali-App-Animation-3-color-2.gif?x77083)

GIF 1 *“The animation”*

GIF 1 **“动画效果”**

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

RecyclerView has some native tools for managing its state. We can set ItemAnimator and ItemDecorator to add some nice animations and look for ViewHolders, LayoutManager for managing how views are measured and positioned. We also have listeners for receiving messages of specific condition of the RecyclerView.

RecyclerView 有一些本地工具来管理自身的状态。我们可以设置 ItemAnimator 或者 ItemDecorator 来添加一些不错的动画效果、查找 ViewHolder，设置 LayoutManager 来控制布局的显示方式。我们还有 listener 来监听 RecyclerView 的特殊状态。

As we can see, there is a horizontal RecyclerView with list of CardViews with some details about some places around Bali. While we are scrolling, the corresponding marker is animated with simple scale up/down animation. So how was it implemented? Of course, with some problems 🙂！

如上所示，这是一个横向的 RecyclerView，该 RecycleView 包含一组记录巴厘岛周边详情的 CardViews。当滑动 RecyclerView 的时候，对应的标记要做出闪烁。所以如何实现呢？当然是有一些问题需要解决的 🙂！

## OnScrollListener ##

OnScrollListener is a class that allows us to *receive messages when a scrolling event has occurred on that RecyclerView (via [documentation](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.OnScrollListener.html))*. This class have *onScrolled* method – it is the key to interact between scroll position and animating markers! This callback method is invoked when scroll occurs. Let’s look at it:

OnScrollListener 是一个允许我们**在 RecyclerView 的滑动事件被触发时接收回调的类(参见[此处](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.OnScrollListener.html))**。该类有 **onScrolled** 方法 —— 这是联系滚动位置（position）和标记的关键。该回调方法监听滚动事件。让我们看一看它长啥样：


 
```
Java
    @Override

    public void onScrolled(final RecyclerView recyclerView,final int dx,final int dy){

        super.onScrolled(recyclerView,dx,dy);

    }
```
 
As we can see, there is a RecyclerView passed as an argument, also dx and dy. “dx” is the amount of horizontal scroll, “dy” is the amount of vertical scroll. In our case we are interested in recyclerView argument.

如我们所见，此回调包含一个传入的参数 RecyclerView，还有整数型参数 dx 和 dy。“dx” 是横移量，“dy”是纵移量。在本项目中，我们只对 recycleview 参数感兴趣.

## First idea ##

## 第一个想法 ##

Okay, so we have OnScrollListener class with *onScrolled* method, there can’t be anything tricky right? We will check if view is in the center and then just notify the marker to animate itself. Easy? Of course it’s easy, but it doesn’t work 🙂 Look again on the animation. The first item and the last item will never reach the center of the RecyclerView!

好吧，既然我们已经有了含有 **onScrolled** 方法的 OnScrollListener 类，那就不复杂了吧？我们需要判断某个 RecycleView 的 item 是否处于正中心，如果是的话就通知对应的标记闪烁。简单不？确实很简单，但是不管用 🙂。再看一下动画，第一个 item 和最后一个 item 永远不会到达 RecycleView 的中心。

## Second idea ##

## 第二个想法

What we need to do? The point where the markers are notified must move across the RecyclerView. So the start position of this point should be in the center of the first item, and the last position should be in the center of the last item. We’ll do some math to calculate points position where corresponding marker should be animated.

该怎么做呢？触发标记闪烁的触发点是随着 RecyclerView 的滑动而移动的。所以这个触发点的起始位置应该在第一个 item 的中心，最终位置应该在最后一个 item 的中心。我们需要做些数学计算来判断触发点和闪烁标记的关联。

Will it work?
管用吗？

Of course not 🙂 *onScrolled* method doesn’t invoke for every pixel. If we scroll our RecyclerView fast, we will receive only few callbacks. So what should we do?
还是不管用 🙂。 **onScrolle** 方法不是每一个像素都被触发的。如果我们滑动 RecycleView 的速度太快，收到的回调就很少。那么应该怎么办呢？

## Third idea ##

##　第三个想法

Easy. We can’t have the moving point, because it’s unlikely that it will cover with “offset” parameter. We have to move the “range” which will notify marker when it covers f.e. 70% of the RecyclerView’s child. So think about it as a moving rectangle from left to right. Let’s look at the implementation:

很简单。既然不能计算移动的触发点 —— 因为看起来它不会包含“偏移量”的参数，那就移动“范围”。当该范围覆盖比如说 70% 的 RecycleView 子布局时，触发标记的闪烁。不妨把它想想成一个从左至右移动的矩形。让我们看看实现吧：

```
Java

public class HorizontalRecyclerViewScrollListener extends RecyclerView.OnScrollListener{

    private static final int OFFSET_RANGE = 50;

    private static final double COVER_FACTOR = 0.7;

 

    private int[] itemBounds = null;

    private final OnItemCoverListener listener;

 

    public HorizontalRecyclerViewScrollListener(final OnItemCoverListener listener){

        this.listener=listener;

    }

 

    @Override

    public void onScrolled(final RecyclerView recyclerView,final int dx,final int dy){

        super.onScrolled(recyclerView,dx,dy);

        if(itemBounds == null)
            fillItemBounds(recyclerView.getAdapter().getItemCount(),recyclerView);

        for(int i=0;i<itemBounds.length;i++){

            if(isInChildItemsRange(recyclerView.computeHorizontalScrollOffset(),itemBounds[i],OFFSET_RANGE))
                listener.onItemCover(i);

        }

    }

 

    private void fillItemBounds(final int itemsCount,final RecyclerView recyclerView){

        itemBounds=new int[itemsCount];

        int childWidth=(recyclerView.computeHorizontalScrollRange()-recyclerView.computeHorizontalScrollExtent())/itemsCount;

        for(inti=0;i<itemsCount;i++){

            itemBounds[i]=(int)(((childWidth*i+childWidth*(i+1))/2)*COVER_FACTOR);

        }

    }

 

    private boolean isInChildItemsRange(final int offset,final int itemBound,final int range){

        int rangeMin=itemBound-range;

        int rangeMax=itemBound+range;

        return (Math.min(rangeMin,rangeMax)<=offset) && (Math.max(rangeMin,rangeMax)>=offset);

    }

 

    public interface OnItemCoverListener{

        void onItemCover(final int position);

    }

}
```
 
First of all, we don’t want to make Fragment/Activity messy, so we want to extend RecyclerView.OnScrollListener class and override necessary method. Via the constructor we pass a listener, whose method *onItemCover* is invoked when the RecyclerView is in the child’s range. In the *onScrolled* method we call *fillItemBounds* method if we haven’t done it yet, and we iterate through all of the bounds to check if the recyclerView’s item is covered with corresponding bounds.

首先，我们不希望新代码和 Fragment/Activity 混到一起，因此继承 RecyclerView.OnScrollListener 的类并重写必要的方法。在构造函数中传一个 listener 进去，当 RecycleView 的 item 的范围符合时条件时就调用该 listener 的 **onItemCover** 方法。在 **onScrolled** 方法中，如果 itemBounds 为空我们可以调用 **fillItemBounds** 进行初始化。否则循环判断所有的边距，判断 RecycleView 的 item 是否被指定的范围覆盖。

The method *fillItemBounds* creates new integer’s table for every item in the RecyclerView. Next it calculates childWidth (RecyclerView’s item width). In the last part it fills the table with “item bounds” – actually, these are the “center” points which will be used to calculate if the RecyclerView is in child’s range.

方法 **fillItemBounds** 以 RecyclerView 的 item 个数为长度创建了一个整数数组。接下来它计算了子布局的宽度（也就是 RecyclerView 的 item 的宽度）。在最后它用“item 的范围”给数组赋值 —— 事实上，这些就是用来计算 RecycleView 是否处于子布局内的“中心”点。

When *onScrolled* is invoked, we iterate through all of RecyclerView’s children and we check if the position *isInChildItemsRange.* This method is actually our “rectangle” which we move along the RecyclerView. This method takes the *itemBound* (the “center” point we calculated store in *itemBounds* table), the current offset and calculates if they overlap each other. If so, the *onItemCover* method on the OnItemCoverListener is called, where the corresponding position is passed. With this argument we can get the corresponding Marker and animate it.

当调用 **onScrolled** 方法时，我们通过 **isInChildItemsRange** 循环判断 RecycleView item 的范围。该方法实际上就是当我们移动 RecycleView  时候的“矩形”。该方法计算 **item 的区域**(也就是我们计算并保存在 **itemBounds**里的中心点)与当前的偏移量是否重叠。如果符合条件的话，OnItemCoverListener 会调用 **onItemCover** 方法，传递指定的位置（position） 。通过此参数，我们就可以拿到判断当前的地图标记是哪个，让它进行闪烁。

```
    //Implementation of the HorizontalRecyclerViewScrollListener
    // HorizontalRecyclerViewScrollListener 的具体实现

    ...

    recyclerView.addOnScrollListener(new HorizontalRecyclerViewScrollListener(this));

    }

 

    //OnItemCoverListener method implementation
    // 实现 OnItemCoverListener 的方法

    @Override

    public void onItemCover(final int position){

        mapOverlayLayout.showMarker(position);// 在此处刷新标记

    }

    
    //PulseOverlayLayout - see the 2nd article from the series
    
    //PulseOverlayLayout - 参见系列的第二篇

    public void showMarker(final int position){

        ((PulseMarkerView)markersList.get(position)).pulse();

    }

  
    //PulseMarkerView - see the 2nd article from the series
    
        //PulseOverlayLayout - 参见系列的第二篇 

    public void pulse(){

        startAnimation(scaleAnimation);

    }
```

And there is the effect:

效果如下

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/markers_scaling.gif?x77083)

# Conclusion #

As we can see, we have some great tools from Android Framework, but in some cases we also have to think about some implementations to make everything work as we expect. That wasn’t so clear an obvious in the first place, but somehow we found the solution 😉

如我们所见，Android Framework 中有一些了不起的工具，但是在很多情况下还是需要思考怎么调用才能把事情按我们所想的实现。最开始的时候还不是很明确，但是现在我们已经找到解决办法了 😉。

Thanks for reading! The last part will be published on Tuesday 4.04. Feel free to leave a comment if you have any questions, and if you found this blog post helpful – don’t forget to share it!

多谢阅读！最后一篇会在星期二 4.04 发布。如果有疑问的话欢迎评论，如果觉得有用的话一定要分享哟！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
