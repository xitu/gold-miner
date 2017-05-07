> * 原文地址：[Workcation App – Part 3. RecyclerView interaction with Animated Markers](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)
> * 原文作者：[Mariusz Brona](https://www.thedroidsonroids.com/blog/workcation-app-part-3-recyclerview-interaction-with-animated-markers/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  Workcation App – Part 3. RecyclerView interaction with Animated Markers #

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

As we can see, in the GIF above, there is a lot of going on.

1. After clicking on the bottom menu item, we are moving to the next screen, where we can see the map being loaded with some scale/fade animation from the top, RecyclerView items loaded with translation from the bottom, markers added to the map with scale/fade animation.
2. While scrolling the items in RecyclerView, the markers are pulsing to show their position on the map.
3. After clicking on the item, we are transferred to the next screen, the map is animated below to show the route and start/finish marker. The RecyclerView’s item is transitioned to show some description, bigger picture, trip details and button.
4. While returning, the transition happens again back to the RecyclerView’s item, all of the markers are shown again, the route disappears.

Pretty much. That’s why I’ve decided to show you all of the things in the series of posts. In this article, I will cover how to animate markers with RecyclerView interaction!

# The Problem #

RecyclerView has some native tools for managing its state. We can set ItemAnimator and ItemDecorator to add some nice animations and look for ViewHolders, LayoutManager for managing how views are measured and positioned. We also have listeners for receiving messages of specific condition of the RecyclerView.

As we can see, there is a horizontal RecyclerView with list of CardViews with some details about some places around Bali. While we are scrolling, the corresponding marker is animated with simple scale up/down animation. So how was it implemented? Of course, with some problems 🙂！

## OnScrollListener ##

OnScrollListener is a class that allows us to *receive messages when a scrolling event has occurred on that RecyclerView (via [documentation](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.OnScrollListener.html))*. This class have *onScrolled* method – it is the key to interact between scroll position and animating markers! This callback method is invoked when scroll occurs. Let’s look at it:

 
```
Java
    @Override

    publicvoidonScrolled(finalRecyclerView recyclerView,finalintdx,finalintdy){

        super.onScrolled(recyclerView,dx,dy);

    }
```
 
As we can see, there is a RecyclerView passed as an argument, also dx and dy. “dx” is the amount of horizontal scroll, “dy” is the amount of vertical scroll. In our case we are interested in recyclerView argument.

## First idea ##

Okay, so we have OnScrollListener class with *onScrolled* method, there can’t be anything tricky right? We will check if view is in the center and then just notify the marker to animate itself. Easy? Of course it’s easy, but it doesn’t work 🙂 Look again on the animation. The first item and the last item will never reach the center of the RecyclerView!

## Second idea ##

What we need to do? The point where the markers are notified must move across the RecyclerView. So the start position of this point should be in the center of the first item, and the last position should be in the center of the last item. We’ll do some math to calculate points position where corresponding marker should be animated.

Will it work?

Of course not 🙂 *onScrolled* method doesn’t invoke for every pixel. If we scroll our RecyclerView fast, we will receive only few callbacks. So what should we do?

## Third idea ##

Easy. We can’t have the moving point, because it’s unlikely that it will cover with “offset” parameter. We have to move the “range” which will notify marker when it covers f.e. 70% of the RecyclerView’s child. So think about it as a moving rectangle from left to right. Let’s look at the implementation:

```
Java

publicclassHorizontalRecyclerViewScrollListener extendsRecyclerView.OnScrollListener{

    privatestaticfinalintOFFSET_RANGE=50;

    privatestaticfinaldoubleCOVER_FACTOR=0.7;

 

    privateint[]itemBounds=null;

    privatefinalOnItemCoverListener listener;

 

    publicHorizontalRecyclerViewScrollListener(finalOnItemCoverListener listener){

        this.listener=listener;

    }

 

    @Override

    publicvoidonScrolled(finalRecyclerView recyclerView,finalintdx,finalintdy){

        super.onScrolled(recyclerView,dx,dy);

        if(itemBounds==null)fillItemBounds(recyclerView.getAdapter().getItemCount(),recyclerView);

        for(inti=0;i<itemBounds.length;i++){

            if(isInChildItemsRange(recyclerView.computeHorizontalScrollOffset(),itemBounds[i],OFFSET_RANGE))listener.onItemCover(i);

        }

    }

 

    privatevoidfillItemBounds(finalintitemsCount,finalRecyclerView recyclerView){

        itemBounds=newint[itemsCount];

        intchildWidth=(recyclerView.computeHorizontalScrollRange()-recyclerView.computeHorizontalScrollExtent())/itemsCount;

        for(inti=0;i<itemsCount;i++){

            itemBounds[i]=(int)(((childWidth*i+childWidth*(i+1))/2)*COVER_FACTOR);

        }

    }

 

    privatebooleanisInChildItemsRange(finalintoffset,finalintitemBound,finalintrange){

        intrangeMin=itemBound-range;

        intrangeMax=itemBound+range;

        return(Math.min(rangeMin,rangeMax)<=offset)&&(Math.max(rangeMin,rangeMax)>=offset);

    }

 

    publicinterfaceOnItemCoverListener{

        voidonItemCover(finalintposition);

    }

}
```
 
First of all, we don’t want to make Fragment/Activity messy, so we want to extend RecyclerView.OnScrollListener class and override necessary method. Via the constructor we pass a listener, whose method *onItemCover* is invoked when the RecyclerView is in the child’s range. In the *onScrolled* method we call *fillItemBounds* method if we haven’t done it yet, and we iterate through all of the bounds to check if the recyclerView’s item is covered with corresponding bounds.

The method *fillItemBounds* creates new integer’s table for every item in the RecyclerView. Next it calculates childWidth (RecyclerView’s item width). In the last part it fills the table with “item bounds” – actually, these are the “center” points which will be used to calculate if the RecyclerView is in child’s range.

When *onScrolled* is invoked, we iterate through all of RecyclerView’s children and we check if the position *isInChildItemsRange.* This method is actually our “rectangle” which we move along the RecyclerView. This method takes the *itemBound* (the “center” point we calculated store in *itemBounds* table), the current offset and calculates if they overlap each other. If so, the *onItemCover* method on the OnItemCoverListener is called, where the corresponding position is passed. With this argument we can get the corresponding Marker and animate it.

```
    //Implementation of the HorizontalRecyclerViewScrollListener

    ...

    recyclerView.addOnScrollListener(newHorizontalRecyclerViewScrollListener(this));

    }

 

    //OnItemCoverListener method implementation

    @Override

    publicvoidonItemCover(finalintposition){

        mapOverlayLayout.showMarker(position);// notify Marker here

    }

    
    //PulseOverlayLayout - see the 2nd article from the series

    publicvoidshowMarker(finalintposition){

        ((PulseMarkerView)markersList.get(position)).pulse();

    }

  
    //PulseMarkerView - see the 2nd article from the series

    publicvoidpulse(){

        startAnimation(scaleAnimation);

    }
```

And there is the effect:

![](https://www.thedroidsonroids.com/wp-content/uploads/2017/03/markers_scaling.gif?x77083)

# Conclusion #

As we can see, we have some great tools from Android Framework, but in some cases we also have to think about some implementations to make everything work as we expect. That wasn’t so clear an obvious in the first place, but somehow we found the solution 😉

Thanks for reading! The last part will be published on Tuesday 4.04. Feel free to leave a comment if you have any questions, and if you found this blog post helpful – don’t forget to share it!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
