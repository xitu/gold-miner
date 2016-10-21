>* 原文链接 : [Android: Why your Canvas shapes aren’t smooth](https://medium.com/@ali.muzaffar/android-why-your-canvas-shapes-arent-smooth-aa2a3f450eb5#.p3w0sj7cf)
* 原文作者 : [Ali Muzaffar](https://medium.com/@ali.muzaffar)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Sausure](https://github.com/Sausure)
* 校对者:[zhangzhaoqi](https://github.com/joddiy), [lovexiaov](https://github.com/lovexiaov)

# 为什么 Android 上 Canvas 画出的图形不够平滑

通过 Google 搜索我们很快就能找到这个在 StackOverflow 中被问了很多次的问题，同时答案也经常是相同的：你需要给你的 Paint 对象设置 ANTI_ALIAS_FLAG 属性。但对于大多数人来说这并不能解决问题。下面我讲讲原因。

#### 在 Canvas 上绘制

若你需要在 Canvas 上绘制，你有两种选择。

*   直接在 Canvas 上绘制。
*   先在 Bitmap 上绘制再将 Bitmap 绘制到 Canvas 上。

#### 直接在 Canvas 上绘制

在你绘制前，先设置 Paint 对象的 ANTI_ALIAS_FLAG 属性可以得到平滑的图形。

你有两种设置 ANTI_ALIAS_FLAG 属性的方式：
```java
    Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
    //或者
    Paint p = new Paint();
    p.setAntiAlias(true);
```
然后通过下面代码直接在 Canvas 上绘制。
```java
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawCircle(mLeftX + 100, mTopY + 100, 100, p);
    }
```
![](https://cdn-images-1.medium.com/max/800/1*n4VKxX92KrpuSOmzm1LDVg.png)

<figcaption>直接在 Canvas 上绘制</figcaption>

正如你看到的，设置 ANTI_ALIAS_FLAG 属性可以产生平滑的边缘。**这里它能起作用是因为默认下每当 onDraw 被调用时系统先将 Canvas 清空然后重绘所有东西。**当我在下文详细讨论 ANTI_ALIAS_FLAG 的工作原理时， 你会意识到这段信息的重要性。

#### 先在 Bitmap 上绘制再将 Bitmap 绘制到 Canvas 上

如果你需要保存这张被绘制的图形，或者你需要绘制透明的像素，有个很好的办法是先将图形绘制到 Bitmap 上然后再将 Bitmap 绘制到 Canvas 上。下面我们通过代码来实现它。

**注意：** 在 onDraw 方法中初始化 Bitmap 并不是一个好主意，但在这里可以增加代码可读性。
```java
    Paint p = new Paint();
    Bitmap bitmap = null;
    Canvas bitmapCanvas = null;
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (bitmap == null) {
            bitmap = Bitmap.createBitmap(200,
                                         200,
                                         Bitmap.Config.ARGB_8888);
            bitmapCanvas = new Canvas(bitmap);
            bitmapCanvas.drawColor(
                           Color.TRANSPARENT,
                           PorterDuff.Mode.CLEAR);
        }
        drawOnCanvas(bitmapCanvas);
        canvas.drawBitmap(bitmap, mLeftX, mTopY, p);

    }

    protected void drawOnCanvas(Canvas canvas) {
        canvas.drawCircle(mLeftX + 100, mTopY + 100, 100, p);
    }
```
此方式实现效果如下，没有设置 ANTI_ALIAS_FLAG 的图像不够平滑，而设置了该属性的更好一点，但你还是能发现它的边缘是粗糙的。

![](http://ww1.sinaimg.cn/large/a490147fgw1f3pd1icuf5j209j0i5dgd.jpg)

<figcaption>先在 Bitmap 上绘制再将 Bitmap 绘制到 Canvas 上</figcaption>

#### 上面的代码有什么错误？

我们很容易会忽视上面代码片段出现的问题。即虽然每次 onDraw 被调用时都会更新你在 Bitmap 上绘制的圆形，但理论上说，你只是在上一个图片上重绘。所以这个问题的答案是 ANTI_ALIAS_FLAG 到底是怎么工作的？

#### ANTI_ALIAS_FLAG 是怎么工作的？

简单来说，ANTI_ALIAS_FLAG 通过混合前景色与背景色来产生平滑的边缘。在我们的例子中，背景色是透明的而前景色是红色的，ANTI_ALIAS_FLAG 通过将边缘处像素由纯色逐步转化为透明来让边缘看起来是平滑的。

而当我们在 Bitmap 上**重绘**时，像素的颜色会越来越纯粹导致边缘越来越粗糙。在下面这张图片中，我们看下不断重绘 50% 透明度的红色会出现什么状况。正如你看到的，只需三次重绘，颜色就十分接近纯色了。**这就是为什么设置了 ANTI_ALIAS_FLAG 后你们图形的边缘还是十分粗糙。**

![](http://ww4.sinaimg.cn/large/a490147fgw1f3pd1zamtjj20b405ka9v.jpg)

#### 我该如何解决这问题？

这里有两个选择。

*   避免重绘。
*   在重绘前清空你的 Bitmap。

下面我修改了上文的代码，添加一行代码让它在每次重绘前先清空 Bitmap。当然，如果你觉得纯色更加符合你的需求的话，你也可以不用每次都清空 Bitmap。
```java
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (bitmap == null) {
            bitmap = Bitmap.createBitmap(200,
                                         200,
                                         Bitmap.Config.ARGB_8888);
            bitmapCanvas = new Canvas(bitmap);
        }
        bitmapCanvas.drawColor(
                  Color.TRANSPARENT,
                  PorterDuff.Mode.CLEAR); //this line moved outside if
        drawOnCanvas(bitmapCanvas);
        canvas.drawBitmap(bitmap, mLeftX, mTopY, p);
    }

    protected void drawOnCanvas(Canvas canvas) {
        canvas.drawCircle(mLeftX + 100, mTopY + 100, 100, p);
    }
```
现在， Bitmap 会在每次重绘前先清空。下面的图片就是代码更改后的效果。

![](http://ww4.sinaimg.cn/large/a490147fgw1f3pd2chefej208c0hmq3g.jpg)

**注意：** 如果不需要经常修改 Bitmap，你可以只（在 if 条件语句中）初始化并绘制 Bitmap 一次，然后在 onDraw 方法中将其绘制到 Canvas 上，这样能保证更好的性能。也意味着频繁地清空像素并绘制圆形的操作是没有必要的。

#### 总结

*   如需要先绘制到 Bitmap 上：  
    - 你想保存图像。  
    - 你想绘制透明的像素。  
    - 你的图像不需要经常改变并且/或者需要耗时操作。
*   通过设置 ANTI_ALIAS_FLAG 属性绘制平滑的边缘。
*   避免在 Bitmap 上重绘，或者在重绘前先清空 Bitmap。
