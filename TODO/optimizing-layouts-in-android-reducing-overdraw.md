> * 原文地址：[Optimizing Layouts in Android – Reducing Overdraw](http://riggaroo.co.za/optimizing-layouts-in-android-reducing-overdraw/)
* 原文作者：[Rebecca](https://riggaroo.co.za/female-android-developer/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Optimizing Layouts in Android – Reducing Overdraw

You have a great idea and you have launched your application into the wild. Now you hear people complaining how your app is slow and horrible to use. Sad face.

One such step to improve the rendering time of your application is to have a look at the GPU Overdraw tool.

## What is Overdraw?

Overdraw happens every time the application asks the system to draw something on top of something else. The “Debug GPU Overdraw” tool overlays colours on top of your screen to indicate how many times a pixel has been redrawn.

## How do I enable the tool Debug GPU Overdraw?

1.  Go to Settings on your device.
2.  Go to Developer Options
3.  Select “Debug GPU Overdraw”.
4.  Select “Show overdraw areas”

You will notice your screen change colour – don’t panic. Navigate to your application and now we can begin to understand how to improve our layouts.

## What do the different colours mean?

[![Screenshot_2016-02-01-11-08-40](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-08-40.png?resize=576%2C1024&ssl=1)
](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-08-40.png?resize=576%2C1024&ssl=1)

The colours mean the following things:

_**Original colour**_ – _no overdraw_ – The pixels have been painted once on the screen.

**_Blue_** – _1x Overdraw_ –  The pixels have been painted **2** times on the screen.

**Green –** _2x Overdraw –_ The pixels on the screen have been painted **3** times on the screen.

_**Pink**_ – _3x Overdraw_ – The pixels on the screen have been painted **4** times on the screen.

_**Red** – 4x Overdraw –_ The pixels on the screen have been painted **5** times on the screen_._

[![GPU Overdraw](http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png?resize=150%2C150%20150w,%20http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png?resize=50%2C50%2050w)](http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png)

You can see from my [Book Dash application](http://riggaroo.co.za/portfolio/book-dash-android-app/), that my initial layout was doing a lot of overdraw.

## How do you fix overdraw?

In the example above, I removed the background colour that was set on the RelativeLayout and let the theme draw the background.

So going from this:

```
<RelativeLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:background="#FFFFFF">

```

to this:


```
<RelativeLayout
     android:layout_width="match_parent"
     android:layout_height="match_parent">
```


Modifying the layout yielded the following result 😊:

[![After removing the background colour.](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-20-08.png?resize=576%2C1024&ssl=1)
](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-20-08.png)

As you can see, the overdraw has been minimized. The red overdraw has been reduced.

This could be further improved to the layout showing mostly its true colour and a slight amount of blue overdraw. Some overdraw is inevitable.

Not all cases of overdraw are related to background colours. Other problems can be present too, like very complex layout hierarchies or too many views.

You should aim for a **maximum overdraw of 2x (Green)**.

You can also use other tools to see why overdraw is happening, tools such as [Hierarchy Viewer](http://developer.android.com/tools/performance/hierarchy-viewer/index.html) and [GL Tracer](http://developer.android.com/tools/help/gltracer.html).

How do you debug overdraw issues? Do you have any other tips to share?

Links:

[http://developer.android.com/tools/performance/debug-gpu-overdraw/index.html](http://developer.android.com/tools/performance/debug-gpu-overdraw/index.html)



