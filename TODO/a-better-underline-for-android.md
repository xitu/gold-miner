>* 原文链接 : [A better underline for Android](https://medium.com/google-developers/a-better-underline-for-android-90ba3a2e4fb)
* 原文作者 : [Romain Guy](https://medium.com/@romainguy)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [jamweak](https://github.com/jamweak)
* 校对者: [yifili09](https://github.com/yifili09)，[whyalwaysmea](https://github.com/whyalwaysmea)

# Android 中美腻的下划线

在过去两年里，我经常发现一些尝试去如何提高有关在网页中渲染下划线文本修饰的[文章](https://medium.com/design/crafting-link-underlines-on-medium-7c03a9274f9)和[库](https://eager.io/blog/smarter-link-underlines/)。此类问题也同样发生在Android（平台）：下划线的文本修饰与[降部](http://www.fontke.com/article/712)相交。比较下Android当前如何绘制下划线文本(上图)以及它的替代方案(下图)：

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2xgczirj20d506qmxg.jpg)

<figcaption class="imageCaption">你更喜欢哪一种?</figcaption>

尽管我完全认可这些努力，但是我从未喜欢过任何公开的解决方法。目前最新的技术（追求艺术般的状态）—毫无疑问地会强迫开发者们受限于CSS—似乎是通过绘制线性渐变以及多重阴影（我见过多达12层的！）来实现的。这些解决方案都具有无法否认的成效，但这种绘制如此多阴影的做法，即使没有增加模糊效果，也会使得图形开发者们足够头疼了。还有一点，这种方法仅仅在实色的背景下有效。

我今天下午一时兴起，开始着手发掘满足以下需求的其他解决方案:

*   兼容旧版本的Android系统
*   仅使用标准的View和Canvas APIs
*   不需要过度重绘或者大量的阴影开销
*   在任何背景下都有效，而不是只支持实色背景
*   不依赖绘制流水线的操作顺序(文本先于/晚于下划线的绘制是无关紧要的)

我在这里提供了两种解决方案，你可以在[GitHub](https://github.com/romainguy/elegant-underline)获取。其中一种方法适用于[API level 19](https://www.android.com/versions/kit-kat-4-4/)及以上，另外一种适用于[API level 1](http://arstechnica.com/gadgets/2014/06/building-android-a-40000-word-history-of-googles-mobile-os/6/)及以上，或者说它 _应该_ 至少支持API level 1以上，我没有完全地测试，但我相信API文档。

你可以在下面的截图中观察比较下这两种被称作 _Path_ 和 _Region_ 的方法：

![](http://ww3.sinaimg.cn/large/a490147fgw1f5j2y5a88nj20j10xz0vv.jpg)

<figcaption class="imageCaption">在Android中更好展示下划线文本的两种可能的实现方式</figcaption>

### 如何实现的?

这些实现背后的思想与之前提到的CSS方法出奇地类似。我们使用一整条直线段来表示下划线，剩下所需要做的就是为降部挪出空间...

#### 使用Path类

API level 19 (叫KitKat更耳熟) 中引入了一个操作路径的新API叫做[path ops](https://developer.android.com/reference/android/graphics/Path.html#op%28android.graphics.Path,%20android.graphics.Path.Op%29)。这个API允许你为实例建立两个路径的交叉点，或是从一条路径中减去其它的路径。

使用这个API，制作我们想要的下划线就非常简单了。第一步就是为我们的文本[获取轮廓](https://developer.android.com/reference/android/graphics/Paint.html#getTextPath%28java.lang.String,%20int,%20int,%20float,%20float,%20android.graphics.Path%29)：

    mPaint.getTextPath(mText, 0, mText.length(), 0.0f, 0.0f, mOutline);

注意返回的path可以通过一种填充的样式来渲染原始文本，我们在这里要使用它来进行后续操作。

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2z6baigj20m8057aaj.jpg)

<figcaption class="imageCaption">文本轮廓</figcaption>

下一步就是剪切表示下划线的矩形轮廓。这一步不完全是必要的，但是这样可以避免在下一步可能出现的近似值偏差。我们只需使用intersection path操作就能方便的实现这一功能：

    mOutline.op(mUnderline, Path.Op.INTERSECT);

现在轮廓路径仅仅包含几位降部与下划线的交叉部分。

![](http://ww1.sinaimg.cn/large/a490147fgw1f5j2zor2ptj20m804lwet.jpg)

<figcaption class="imageCaption">只有黑色区域表示是路径的一部分，其余的部分只是为了可视目的。</figcaption>

剩下要做的就是从下划线中减去那些降部位置的部分。在做这个之前，我们必须扩大原始文本的尺寸来为降部与下划线间创造出间隙。这个功能可以通过划除我们剪切的轮廓然后建立一个新的填充路径实现：

    mStroke.setStyle(Paint.Style.FILL_AND_STROKE);        mStroke.setStrokeWidth(UNDERLINE_CLEAR_GAP);
    mStroke.getFillPath(mOutline, strokedOutline);

划掉的宽带代表着你想为降部和下划线之间留下多大的空间。

![](http://ww2.sinaimg.cn/large/a490147fgw1f5j3076zuvj20m804gq3a.jpg)

<figcaption class="imageCaption">划除剪切掉的轮廓</figcaption>

最后一步就是使用另外一个path操作从下划线矩形轮廓中减去划除部分和剪切掉的部分：

    mUnderline.op(strokedOutline, Path.Op.DIFFERENCE);

最后的下划线可以使用一个填充画笔绘制：

    canvas.drawPath(mUnderline, mPaint);

#### 使用Region类

[Region](https://developer.android.com/reference/android/graphics/Region.html)是一种在屏幕上高效展示非矩形形状的方法。你可以想象一块区域是由若干对齐到渲染缓冲区的矩形集合组成的。Regions可以被看作是_栅格化_的Path。这意味着如果我们将Path转换成Region后，我们获得的是一系列像素坐标点的集合，一旦Path被绘制，它将影响到这些获得的坐标集合。

Region有趣的地方在于它[提供了与Path相同的操作](https://developer.android.com/reference/android/graphics/Region.html#op%28android.graphics.Region,%20android.graphics.Region.Op%29)。两块Regions能够互相交错、扣除重叠的部分等等。更重要的是，Region从最早的Android API中就已经存在了。

用Region实现下划线的方法几乎与用Path完全相同，主要的区别存在于轮廓何时怎样被剪切的：

    Region underlineRegion = new Region(underlineRect);

    // 为文本建立一个Region并且剪切掉下划线部分
    Region outlineRegion = new Region();
    outlineRegion.setPath(mOutline, underlineRegion);

    // 提取返回的Region的Path，从而获得一份剪切后的文本轮廓的拷贝
    mOutline.rewind();
    outlineRegion.getBoundaryPath(mOutline);

    // 划掉剪切掉的文本，将其结果转为一个填充样式的Path
    mStroke.getFillPath(mOutline, strokedOutline);

    // 使用划掉文本的轮廓建立一个Region对象
    outlineRegion = new Region();
    outlineRegion.setPath(strokedOutline, new Region(mBounds));

    // 在下划线轮廓中扣除剪切掉的，划掉的文本轮廓
    underlineRegion.op(outlineRegion, Region.Op.DIFFERENCE);

    // 使用下划线Region建立一个Path
    underlineRegion.getBoundaryPath(mUnderline);

#### 两种方法的区别

由于Path类和Region类的本质不同，两种实现间有着不易察觉的区别。因为Path类仅仅在曲线上操作，因此在我们从下划线轮廓中扣除降部时，就保留了降部轮廓的斜度，这就造成下划线空隙的边缘与降部的曲线斜度平行。这种效果或许是又或许不是所期望的。

另一方面，Region类操作的是整个像素点，它会清除下划线竖向的切割（你的下划线足够细的话）。下图是两种实现的比较：

![](http://ww4.sinaimg.cn/large/a490147fgw1f5j315r9vej20670bm0sx.jpg)

<figcaption class="imageCaption">上图: Path类. 下图: Region类. 注意到上面的斜度没？如果没有,你需要仔细看。</figcaption>

### 应当在产品中使用吗?

在你尝试将这些技术运用到你的应用之前，需要了解到我这次没有做任何的性能测试。请记住这些尝试很大程度上只是一种编程乐趣的挑战。所提供的代码没有根据文本的大小来适配下划线的位置，也没有适配间隙的宽度。可能在字体的适配上也有问题，我只尝试了几种Android默认的字型。就让我们将这些问题留给读者当做练习来解决吧。

如果你将尝试着在你的应用里使用这些代码，那么我必须承认我将很乐于看到关于[spans](http://flavienlaurent.com/blog/2014/01/31/spans/)的实现，我会鼓励你至少缓存一下最后的填充Path。由于它仅仅依赖于字型，字体和字符串，缓存还是比较容易实现的。

另外，文章中描述的这两种实现方法完全严格遵循开放的SDK API。如果在Android framework层直接实现的话，我有一些想法能使得这个功能变得更有效率。

比如 _Region_ 的转换能够通过渲染自身来获得优化，而不用转换回 _Path_ 了（这会造成软件的碎片化以及GPU结构化更新）。Region类本身就是一系列矩形的集合，对于渲染流水线来说，与绘制碎片化的Path相比，绘制一系列的直线或矩形变得容易多了。

你想了解更多关于Android文本的东西？学习[Android的硬件是如何加速字体渲染的？](https://medium.com/@romainguy/androids-font-renderer-c368bbde87d9#.493idqqrm)。

在GitHub上获取[演示源码](https://github.com/romainguy/elegant-underline)。
