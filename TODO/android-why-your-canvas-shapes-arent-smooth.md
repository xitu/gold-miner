>* 原文链接 : [Android: Why your Canvas shapes aren’t smooth](https://medium.com/@ali.muzaffar/android-why-your-canvas-shapes-arent-smooth-aa2a3f450eb5#.p3w0sj7cf)
* 原文作者 : [Ali Muzaffar](https://medium.com/@ali.muzaffar)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


A quick Google search will show that this question has been asked on StackOverflow several times and often results in the same answer; you need to set the ANTI_ALIAS_FLAG on your Paint object. For a lot of users this does not solve their problem. Here’s why.

#### Drawing shapes on Canvas

When you draw on Canvas, you have two options.

*   Draw your shapes directly on canvas;
*   Draw your shapes on a bitmap and draw the bitmap on Canvas.

#### Draw your shapes directly on Canvas

When you draw your shapes, setting the ANTI_ALIAS_FLAG on the Paint object should result in smooth shapes.

You can set the anti-alias flag in two ways:

    Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
    //or
    Paint p = new Paint();
    p.setAntiAlias(true);

I have used the code below to draw directly on Canvas.

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawCircle(mLeftX + 100, mTopY + 100, 100, p);
    }

![](https://cdn-images-1.medium.com/max/800/1*n4VKxX92KrpuSOmzm1LDVg.png)

<figcaption>Draw directly on Canvas</figcaption>

As you can see, anti-alias produces a smooth edge. **This works because each time onDraw is called, the canvas is cleared and everything has to be redrawn.** When I discuss how anti-aliasing works below, you’ll see why this bit of information is important.

#### Drawing a shape on a Bitmap, then draw the bitmap on Canvas

If we need to persist the drawn image; or you need to draw transparent pixels, it is a good idea to draw your shape on a Bitmap first and then draw that Bitmap on Canvas. We can do this with the code below.

**Note:** I've initialized the Bitmap in the onDraw method which is not a great idea, however it makes reading the code snippets easier.

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

The result of this approach can be seen below, the image without anti-alias is not smooth, the one with anti-alias is better, however you can still make out that the edges are rough.

![](http://ww1.sinaimg.cn/large/a490147fgw1f3pd1icuf5j209j0i5dgd.jpg)

<figcaption>Draw on a bitmap and then draw on Canvas</figcaption>

#### What’s wrong with the code?

It’s easy to not notice the problem with the snipped of code above. You draw a circle on a bitmap and the circle is updated each time onDraw is called. In theory, you are just redrawing over the previous image. However, the answer to the problem is in how anti-aliasing works.

#### How does anti-aliasing work?

To keep the story simple, anti-aliasing works by blending the foreground and background colors to create a smoother edge. In our example, since the background color is transparent and the foreground color is red, anti aliasing essentially makes the pixels on the edge go from solid to transparent gradually. This makes the edge look smooth to the eye.

So when we redraw on a bitmap, pixels will become increasingly solid and the edges become rougher. In the image below, I show what happens when the color red with 50% opacity is redraw repeatedly. As you can see, after about 3 redraws, the color is almost solid. **This is what causes the edges of your shapes to appear rough even though you have anti-alias set.**

![](http://ww4.sinaimg.cn/large/a490147fgw1f3pd1zamtjj20b405ka9v.jpg)

#### How do I fix this?

There are 2 main options.

*   Avoid redraw.
*   Clear your bitmap before redrawing.

I’ve modified the code above by modifying one line to clear the bitmap before each redraw. You don’t have to clear the bitmap each time, you can draw a solid color on the bitmap if that suits your need better.

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

Now, the bitmap is cleared before we draw on it again. This results in the sharp image shown below.

![](http://ww4.sinaimg.cn/large/a490147fgw1f3pd2chefej208c0hmq3g.jpg)

**Note:** If we don’t have to modify out bitmap often, we can simply initialize the bitmap and draw it once (in the if condition) and then in onDraw, simply draw the bitmap on Canvas. This would make our code perform better, as it would mean expensive operations like clearing all pixels and drawing the circle do not need to be performed again and again.

#### In conclusion

*   Draw a bitmap first if:  
    - You need to persist the image.  
    - You need to draw transparent pixels.  
    - Your shapes don’t change often and/or require time consuming operations.
*   Use anti-aliasing to draw smooth edges.
*   Avoid redraws on the bitmap if possible or else, clear a bitmap before redrawing.

