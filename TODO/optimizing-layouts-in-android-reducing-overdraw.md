> * 原文地址：[Optimizing Layouts in Android – Reducing Overdraw](http://riggaroo.co.za/optimizing-layouts-in-android-reducing-overdraw/)
* 原文作者：[Rebecca](https://riggaroo.co.za/female-android-developer/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：

# `Android` 界面的性能优化 —— 减少过度绘制

你有了一个很棒的灵感，并且把它制作成了一个应用程序发布到了网上。但是，现在你听到了来自用户的抱怨，例如这个应用程序运行起来很慢有卡顿的感觉并且太难使用。:disappointed_relieved:。

有一个简单的解决方法是，你可以使用 `GPU Overdraw` 工具来改进应用程序的渲染时间。

## 什么是过度绘制？

过度绘制发生在每一次应用程序要求系统在某些界面上再绘制一些界面的时候。这个 `Debug GPU Overdraw` 工具可以在屏幕最上层叠加上一些颜色，它显示出多少像素点是被重复绘制了。

## 我怎么能启动这个 `Debug GPU Overdraw` 工具？

1. 进入设备上的`设置`菜单
2. 进入`开发者选项`
3. 选择`调试 GPU 过度绘制`
4. 选择`显示过度绘制区域`

你会注意到屏幕上的颜色有了变化 —— 不必惊慌。返回到你的应用程序，现在我们学习如何来优化我们的界面。

## 不同颜色代表了什么意思？

[![Screenshot_2016-02-01-11-08-40](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-08-40.png?resize=576%2C1024&ssl=1)
](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-08-40.png?resize=576%2C1024&ssl=1)

以下是各种颜色的解释:

_**本色**_ —— _没有发生过度渲染_ —— 屏幕上的像素点只被绘制了 **1** 次。

**_蓝色_** —— _1 倍过度渲染_ —— 屏幕上的像素点被绘制了 **2** 次。

**绿色** —— _2 倍过度渲染_ —— 屏幕上的像素点被绘制了 **3** 次。

_**粉色**_ —— _3 倍过度渲染_ —— 屏幕上的像素点被绘制了 **4** 次。

_**红色**_ —— _4 倍过度渲染_ —— 屏幕上的像素点被绘制了 **5** 次。

[![GPU Overdraw](http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png?resize=150%2C150%20150w,%20http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png?resize=50%2C50%2050w)](http://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screen-Shot-2016-02-10-at-6.40.42-PM.png)

你可以看看我的 [`Book Dash` 应用程序](http://riggaroo.co.za/portfolio/book-dash-android-app/)，它在初始化的界面上做了很多过度绘制。

## 如何修正过度绘制的问题？

在上文的例子中，我移除了设定在 `RelativeLayout` 上的背景色，并且使用 `theme` 来绘制背景。

将以下代码:

```
<RelativeLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:background="#FFFFFF">

```

替换成:


```
<RelativeLayout
     android:layout_width="match_parent"
     android:layout_height="match_parent">
```


修改代码后的界面得到了如下的结果😊:

[![After removing the background colour.](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-20-08.png?resize=576%2C1024&ssl=1)
](https://i1.wp.com/riggaroo.co.za/wp-content/uploads/2016/02/Screenshot_2016-02-01-11-20-08.png)

就如你看到的，过度绘制的问题被最大程度地减少了。红色的过度渲染区域被大大地减少了。

这个界面还有继续优化的空间，现在大部分展现的已经是界面的真本色了，还有一些蓝色的过度渲染区域。有些过度渲染是不可避免的。

并不是所有的过度渲染都是由背景色造成的。其他问题也会呈现过度渲染，例如，有非常复杂层次结构或者包含有太多视图的界面。

你应当把目标定在 **最多只允许 2 倍过度渲染 （也就是只出现绿色过度渲染区域）**。

你也可以使用一些其他的工具来调试为什么发生了过度渲染，例如，[Hierarchy Viewer](http://developer.android.com/tools/performance/hierarchy-viewer/index.html) 和 [GL Tracer](http://developer.android.com/tools/help/gltracer.html).

你是怎么来解决调试过度渲染时遇到的问题？你还有其他宝贵的经验分享给大家么？

参考资料：

[http://developer.android.com/tools/performance/debug-gpu-overdraw/index.html](http://developer.android.com/tools/performance/debug-gpu-overdraw/index.html)



