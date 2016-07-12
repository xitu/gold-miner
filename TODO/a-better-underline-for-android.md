>* 原文链接 : [A better underline for Android](https://medium.com/google-developers/a-better-underline-for-android-90ba3a2e4fb)
* 原文作者 : [Romain Guy](https://medium.com/@romainguy)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



Over the past two years, I have regularly come across [articles](https://medium.com/design/crafting-link-underlines-on-medium-7c03a9274f9) and [libraries](https://eager.io/blog/smarter-link-underlines/) that attempt to improve how underline text decorations are rendered on the web. The same problem exist on Android: underline text decorations cross descenders. Compare how Android draws underlined text (top) and how it could be drawn instead (bottom):

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2xgczirj20d506qmxg.jpg)

<figcaption class="imageCaption">Which do you prefer?</figcaption>

While I wholeheartedly approve of these efforts, I have never been fond of the solutions made publicly available. The current state of the art — admittedly forced upon developers by the limitations of CSS — seems to rely on drawing linear gradients and multiple shadows (I have seen up to 12!). These solutions have the undeniable quality of working but the idea of drawing so many shadows, even without blurring them, makes the graphics programmer in me cringe. They also only work on solid color backgrounds.

On a whim, I set out to find other solutions this afternoon that would satisfy the following requirements:

*   Work on older versions of Android
*   Use only standard View and Canvas APIs
*   Do not require overdraw or expensive shadows
*   Work on any background, not just solid colors
*   Do not rely on the ordering of operations in the rendering pipeline (text drawn before/after the underline should not matter)

I do have two solutions to offer and that I have made [available on GitHub](https://github.com/romainguy/elegant-underline). One solution works on [API level 19](https://www.android.com/versions/kit-kat-4-4/) and up and the other one works on [API level 1](http://arstechnica.com/gadgets/2014/06/building-android-a-40000-word-history-of-googles-mobile-os/6/) and up. Or at least it _should_ work on API level 1 and up, I have not exactly tried. I trust the documentation.

You can observe and compare the two methods, called _path_ and _region_, in the following screenshot:

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2y5a88nj20j10xz0vv.jpg)

<figcaption class="imageCaption">Two possible implementations for better underline text decorations on Android</figcaption>

### How does it work?

The idea behind these implementations is eerily similar to the CSS approach mentioned earlier. We have an underline represented by a single straight line and all we need to do is make room for the descenders…

#### Using paths

API level 19 (better known as KitKat) introduced a fantastic new API for paths manipulation call [path ops](https://developer.android.com/reference/android/graphics/Path.html#op%28android.graphics.Path,%20android.graphics.Path.Op%29). This API allows you for instance to build the intersection of two paths or to subtract one path from another.

Using this API, crafting our underlines becomes trivial. The first step is to [get the outline](https://developer.android.com/reference/android/graphics/Paint.html#getTextPath%28java.lang.String,%20int,%20int,%20float,%20float,%20android.graphics.Path%29) of our text:

    mPaint.getTextPath(mText, 0, mText.length(), 0.0f, 0.0f, mOutline);

Note that the resulting path can be used to render the original text using a fill style. We are instead going to use it for further operations.

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2z6baigj20m8057aaj.jpg)

<figcaption class="imageCaption">Text outline</figcaption>

The next step is to clip the outline with the rectangle representing the underline. This step is not entirely necessary but avoids artifacts and other approximations that could arise in the next step. To do so, we simply use an intersection path operation:

    mOutline.op(mUnderline, Path.Op.INTERSECT);

The outline path now only contains the descender bits that cross the underline:

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2zor2ptj20m804lwet.jpg)

<figcaption class="imageCaption">Only the black regions are part of the path, the rest is drawn for visualization purpose only</figcaption>

All that is left to do is subtract the descender bits from the underline. Before doing so, we must expand the size of the original text to create gaps between the descenders and the underline. This can be achieved by stroking our clipped outline and creating a new fill path:

    mStroke.setStyle(Paint.Style.FILL_AND_STROKE);        mStroke.setStrokeWidth(UNDERLINE_CLEAR_GAP);
    mStroke.getFillPath(mOutline, strokedOutline);

The stroke width determines how much space you want to leave between a descender and the underline.

![](http://ww2.sinaimg.cn/large/a490147fgw1f5j3076zuvj20m804gq3a.jpg)

<figcaption class="imageCaption">Stroking the clipped outline</figcaption>

The last step is to subtract the stroked, clipped outline from the underline rectangle using another path operation:

    mUnderline.op(strokedOutline, Path.Op.DIFFERENCE);

The final underline path can be drawn using a fill paint:

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
