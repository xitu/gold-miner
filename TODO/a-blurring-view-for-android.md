> * 原文链接: [A Blurring View for Android](http://developers.500px.com/2015/03/17/a-blurring-view-for-android.html)
* 原文作者 : [Jun Luo](https://500px.com/junluo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Sausre](https://github.com/Sausure)
* 校对者 :[lekenny](https://github.com/lekenny),[Adam Shen](https://github.com/shenxn)

# 在 Android 下进行实时模糊渲染

## 模糊渲染
  模糊渲染能生动地表达内容间的层次感。当专注于当前特定内容的时候，它允许用户维持相对的上下文，即使模糊层下面的内容发生了视差移动或者动态变化。

在IOS开发中，我们首先可以通过构造`UIVisualEffectView`获得这种模糊效果：

    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

接着我们可以添加`visualEffectView`到视图层中，那么在它之下的内容都会动态渲染模糊效果。

## 在Android中的现状

虽然在Android中并没有直接的方法实现模糊渲染，但我们依然能见到些十分优秀的例子比如Yahoo Weather应用，见[Nicholas Pomepuy的博文](http://nicolaspomepuy.fr/blur-effect-for-android-design/)，然而，它是通过缓存一张预先渲染模糊的背景图片实现的。

虽然这种方法挺有效果，但并不是我们想要的。在[500px](https://500px.com)社区，图片并不是用作背景而是焦点内容，这意味着图片可以随意改变甚至迅速改变，即使它们被覆盖在模糊层之下。[我们的Android应用](https://play.google.com/store/apps/details?id=com.fivehundredpx.viewer)就是个十分典型的例子。比如，当用户滑到下一页时，图片会向反方向移动并淡出，通过适当地维护多个预先渲染模糊的图片是很难满足这种需求的。

![Blurring in the tour of 500px Android App](http://developers.500px.com/images/2015-03-17-500px-android-tour-blurring.png)

## 通过自定义View的OnDraw方法

我们的需求是希望能实现一个模糊视图，它能实时动态地模糊渲染在它之下的视图。我们最终想要的代码最好能尽量简单例如直接让模糊视图拥有一份被模糊视图的引用:
```java
    blurringView.setBlurredView(blurredView);
```
然后当被模糊视图改变时 - 不管是内容的改变（如显示张新的图片）、视图的移动、或者是视图动画，我们都需要刷新模糊视图：
```java
    blurringView.invalidate();
```
为了实现模糊视图，我们需要继承`View`类然后重写`onDraw()`方法来渲染模糊效果：
```java
    protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);

    // 让被模糊视图的draw()方法在私有的画布上绘制
    mBlurredView.draw(mBlurringCanvas);

    // 模糊私有画布的位图并传递给mBlurredBitmap
    blur();

    // 经过转换后将mBlurredBitmap绘制在模糊视图的默认画布上
    canvas.save();
    canvas.translate(mBlurredView.getX() - getX(), mBlurredView.getY() - getY());
    canvas.scale(DOWNSAMPLE_FACTOR, DOWNSAMPLE_FACTOR);
    canvas.drawBitmap(mBlurredBitmap, 0, 0, null);
    canvas.restore();
    }
```
这里的关键是当模糊视图重绘的时候，我们会通过对被模糊视图的引用来调用它的`draw`方法，同时它会在我们私有的画布上绘画（译者注：对该画布的操作最终会作用到我们私有的位图上）:
```java
    mBlurredView.draw(mBlurringCanvas);
```
（通过这种途径访问其它的视图的`draw`方法十分有参考价值，我们也可以实现一个放大镜或者用来标注的视图，相对于模糊渲染，放大镜或者标注的区域更需要放大。）

下面的想法在[Nicholas Pomepuy的博文](http://nicolaspomepuy.fr/blur-effect-for-android-design/)中有谈到,我们结合二次抽样与[RenderScript](http://developer.android.com/guide/topics/renderscript/compute.html)进行快速处理。在我们完成模糊视图的私有画布`mBlurringCanvas`的初始化后二次抽样也设置完成：
```java
    int scaledWidth = mBlurredView.getWidth() / DOWNSAMPLE_FACTOR;
    int scaledHeight = mBlurredView.getHeight() / DOWNSAMPLE_FACTOR;

    mBitmapToBlur = Bitmap.createBitmap(scaledWidth, scaledHeight, Bitmap.Config.ARGB_8888);
    mBlurringCanvas = new Canvas(mBitmapToBlur);
```
通过了上面的设置后再适当地初始化RenderScript。那么上文`onDraw()`调用的`blur()`方法就简单多了：
```java
    mBlurInput.copyFrom(mBitmapToBlur);
    mBlurScript.setInput(mBlurInput);
    mBlurScript.forEach(mBlurOutput);
    mBlurOutput.copyTo(mBlurredBitmap);
```
注意此时`mBlurredBitmap`已经渲染好了，余下的工作是`onDraw()`方法对它适当的移动和缩放后绘制到模糊视图默认画布中。

## 实现细节

对于完全的实现，我们需要留心多个技术细节。首先，我们意识到，8个单位的缩放采样以及15个单位的模糊半径就能很好地呈现我们想要的效果。当然，或许对你来说，别的参数才能满足你的需求。

其次，在模糊位图的边缘处我们遇到了一些RenderScript的历史遗留问题,为了应对这个问题,我们对宽度和高度缩放到近似4倍。
```java
    // The rounding-off here is for suppressing RenderScript artifacts at the edge.
    scaledWidth = scaledWidth - (scaledWidth % 4) + 4;
    scaledHeight = scaledHeight - (scaledHeight % 4) + 4;
```
第三，我们为了更好地保证性能，需要创建两张位图分别是`mBitmapToBlur`做为私有画布`mBlurringCanvas`的底图和`mBlurredBitmap`，并会在被模糊视图的大小改变时重新创建它们。同时，我们也需要重新创建RenderScript的`Allocation`对象也就是`mBlurInput`和`mBlurOutput`。

第四，为了设计的明亮程度考虑，当最上面的被模糊视图拥有属性`PorterDuff.Mode.OVERLAY`时我们也可以绘制一个统一白色半透明层。

最后，由于RenderScript仅在API版本17及以上有效，我们在较低级版本也应该有个比较优雅的降级方案。可不幸的是，正如[Nicholas Pomepuy的博文](http://nicolaspomepuy.fr/blur-effect-for-android-design/)中说的那样，通过Java来实现图片模糊渲染速度上达不到实时渲染的需求。最后我们只能决定使用个有较高透明度的半透明视图做为降级方案。

## 优缺点

我们欣赏这个视图的绘制策略因为它能做到实时模糊同时十分简单易用。它无需知道被模糊视图的内容，同时在模糊和被模糊视图的关系之间有很大的灵活性。当然，最重要的是他很好地满足了我们的需求。

然而，这种策略需要模糊视图通过适当的坐标转换来掌握被模糊视图的位置。关键是模糊视图不能是被模糊视图的子视图否则你将会收到堆栈溢出错误提示因为它们在互相调用对方的绘制方法。一个简单但又十分有效摆脱这种限制的方法是保证模糊视图是被模糊视图的姊妹视图并通过z-order来变换它们的层次关系。

还有个注意点是对于矢量图和文本，默认的位图采样并不太有效。

## 类库和演示

你可以在[我们的Android应用](https://play.google.com/store/apps/details?id=com.fivehundredpx.viewer)中看到完全的解决方案。同时我们也[在GitHub上](https://github.com/500px/500px-android-blur)推出了一个轻量级的开源类库，里面有个演示应用来展示如何在内容发生改变和视图动画时使用该类库。

![500px Blurring View Demo](https://github.com/500px/500px-android-blur/raw/master/blurdemo.gif)
