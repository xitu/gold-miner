>* 原文链接 : [A better underline for Android](https://medium.com/google-developers/a-better-underline-for-android-90ba3a2e4fb)
* 原文作者 : [Romain Guy](https://medium.com/@romainguy)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [jamweak](https://github.com/jamweak)
* 校对者:


在过去两年里，我常常会遇到一些涉及下划线文本的[文章](https://medium.com/design/crafting-link-underlines-on-medium-7c03a9274f9)和[库](https://eager.io/blog/smarter-link-underlines/)，这些作品的意图就是为了改善在网页中具有装饰性下划线文本的渲染。在Android平台上也存在着同样的问题：文本的下划线遇到了下行字母。比较下Android当前如何绘制下划线文本(上图)以及它的替代方案(下图)：

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2xgczirj20d506qmxg.jpg)

<figcaption class="imageCaption">你更喜欢哪一种?</figcaption>

尽管我百分百支持这种努力，但我却不喜欢这种解决方案被广泛使用。这种艺术般的状态—毫无疑问地会强迫开发者们受限于CSS—似乎是通过绘制线性渐变以及多重阴影（我见过多达12层的！）来实现的。这些解决方案都具有无法否认的成效，但这种绘制如此多阴影的做法，即使没有增加模糊效果，也会使得图形开发者们足够头疼了。还有一点，这种方法仅仅在实色的背景下有效。

这个下午，我突发奇想地想寻找其它的解决方案，来满足如下需求：

*   兼容旧版本的Android系统
*   仅使用标准的View和Canvas APIs
*   不需要过度重绘或者大量的阴影开销
*   在任何背景下都有效，而不是只支持实色背景
*   不依赖绘制流水线的操作顺序(文本先于/晚于下划线的绘制是无关紧要的)

我在这里提供了两种解决方案，你可以在[GitHub](https://github.com/romainguy/elegant-underline)获取。其中一种方法适用于[API level 19](https://www.android.com/versions/kit-kat-4-4/)及以上，另外一种适用于[API level 1](http://arstechnica.com/gadgets/2014/06/building-android-a-40000-word-history-of-googles-mobile-os/6/)及以上，或者说它 _应该_ 至少支持API level 1以上，我没有完全地测试，但我相信API文档。

你可以在下面的截图中观察比较下这两种方法，被称作 _路径_ 和 _区域_ ：

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2y5a88nj20j10xz0vv.jpg)

<figcaption class="imageCaption">在Android中更好展示下划线文本的两种可能的实现方式</figcaption>

### 如何实现的?

这些实现背后的思想与之前提到的CSS方法出奇地类似。我们获取了一整条直线段表示的下划线之后，剩下所需要做的就是为下行的字母挪出空间...

#### 使用 paths

API level 19 (叫KitKat更耳熟) 中引入了一个操作路径的新API叫做[path ops](https://developer.android.com/reference/android/graphics/Path.html#op%28android.graphics.Path,%20android.graphics.Path.Op%29)。这个API允许你为实例建立两个路径的交叉点，或是从一条路径中减去其它的路径。

使用这个API，制作我们想要的下划线就非常简单了。第一步就是为我们的文本[获取轮廓](https://developer.android.com/reference/android/graphics/Paint.html#getTextPath%28java.lang.String,%20int,%20int,%20float,%20float,%20android.graphics.Path%29)：

    mPaint.getTextPath(mText, 0, mText.length(), 0.0f, 0.0f, mOutline);

注意返回的path可以通过一种填充的样式来渲染原始文本，我们在这里要使用它来进行后续操作。

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2z6baigj20m8057aaj.jpg)

<figcaption class="imageCaption">文本轮廓</figcaption>

下一步就是剪切表示下划线的矩形轮廓。这一步不完全是必要的，但是这样可以避免下一步引起的人工的或其它偏差的增加。我们只需使用intersection path操作就能方便的实现这一功能：

    mOutline.op(mUnderline, Path.Op.INTERSECT);

现在轮廓路径仅仅包含几位下行字母与下划线的交叉部分。

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2zor2ptj20m804lwet.jpg)

<figcaption class="imageCaption">只有黑色区域表示是路径的一部分，其它部分将要以视觉目的而绘制出来。</figcaption>

剩下要做的就是从下划线中减去那些下行字母位置的部分。在做这个之前，我们必须扩大原始文本的尺寸来为下行字母与下划线间创造出间隙。这个功能可以通过划除我们剪切的轮廓然后建立一个新的填充路径实现：

    mStroke.setStyle(Paint.Style.FILL_AND_STROKE);        mStroke.setStrokeWidth(UNDERLINE_CLEAR_GAP);
    mStroke.getFillPath(mOutline, strokedOutline);

划掉的宽带代表着你想为下行字母和下划线之间留下多大的空间。

![](http://ww2.sinaimg.cn/large/a490147fgw1f5j3076zuvj20m804gq3a.jpg)

<figcaption class="imageCaption">划除剪切掉的轮廓</figcaption>

最后一步就是使用另外一个path操作从下划线矩形轮廓中减去划除部分和剪切掉的部分：

    mUnderline.op(strokedOutline, Path.Op.DIFFERENCE);

最后的下划线可以使用一个填充画笔绘制：

    canvas.drawPath(mUnderline, mPaint);

#### Using regions

[Regions](https://developer.android.com/reference/android/graphics/Region.html) are an efficient way to represent non-rectangular areas of the screen. You can imagine a region as a collection of rectangles aligned with the pixel boundaries of the render buffer. Regions can be used as a _rasterized_ representation of a path. This means that if we transform a path into a region, we obtain the collection of pixels coordinates that would be affected by the path if it was drawn.

What makes regions particularly interesting, is that they [offer operations similar to path operations](https://developer.android.com/reference/android/graphics/Region.html#op%28android.graphics.Region,%20android.graphics.Region.Op%29). Two regions can be intersected, subtracted, etc. More importantly, regions have been part of the Android API since the very first version.

The region implementation is almost identical to the path implementation. The major difference lies in when and how the outline path is clipped.

    Region underlineRegion = new Region(underlineRect);

    // Create a region for the text outline and clip
    // it with the underline
    Region outlineRegion = new Region();
    outlineRegion.setPath(mOutline, underlineRegion);

    // Extract the resulting region's path, we now have a clipped
    // copy of the text outline
    mOutline.rewind();
    outlineRegion.getBoundaryPath(mOutline);

    // Stroke the clipped text and get the result as a fill path
    mStroke.getFillPath(mOutline, strokedOutline);

    // Create a region from the clipped stroked outline
    outlineRegion = new Region();
    outlineRegion.setPath(strokedOutline, new Region(mBounds));

    // Subtracts the clipped, stroked outline region from the underline
    underlineRegion.op(outlineRegion, Region.Op.DIFFERENCE);

    // Create a path from the underline region
    underlineRegion.getBoundaryPath(mUnderline);

#### Differences between the two approaches

Due to the nature of paths and regions, there is a subtle difference between the two implementations. Because path operations work only on curves, they preserve the slant of the descenders when we subtract them from the underline. This creates gaps that run parallel to the curve slopes. This may or may not be the desired effect.

Regions on the other hand operate on whole pixels and will create clean vertical cuts through the underline (as long as your underline is thin enough). Here is a comparison between the two implementations:

![](http://ww4.sinaimg.cn/large/a490147fgw1f5j315r9vej20670bm0sx.jpg)

<figcaption class="imageCaption">Top: paths. Bottom: regions. Notice the slant? If not, you should. Look harder.</figcaption>

### Should I use this in production?

Before you try to use these techniques in your application, be aware that I have not done any performance measures at this time. Please remember that this exercise was mostly a fun programming challenge. The code provided does not try to position the underline text decoration properly depending on the font size. It also does not vary the width of the gaps based on the font size. There might also be issues that are font dependent as I have only tried the effect with some of Android’s default typefaces. Let’s call these issues exercises left to the readers.

If you were to try and use this code in your application, and I must admit I’d love to see an implementation for [spans](http://flavienlaurent.com/blog/2014/01/31/spans/), I would encourage you to at least cache the final fill path. Since they depend only on the typeface, font size and string, a cache should be fairly trivial to implement.

In addition, the two implementations described in this article are understandably restricted by the public SDK APIs. I have a few ideas on how this effect could be achieved more efficiently if it were to be implemented directly into the Android framework.

The _region_ variant could for instance be optimized by rendering the region itself, without going back to a _path_ (which can cause software rasterization and GPU texture updates). Regions are internally represented as collections of rectangles and it would be trivial for the rendering pipeline to draw a series of lines or rectangles instead of rasterizing a path.

Do you want to know more about text on Android? Learn [how Android’s hardware accelerated font renderer works](https://medium.com/@romainguy/androids-font-renderer-c368bbde87d9#.493idqqrm).

Get the [source of the demo](https://github.com/romainguy/elegant-underline) on GitHub.
