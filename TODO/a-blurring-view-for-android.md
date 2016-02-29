> * 原文链接: [A Blurring View for Android](http://developers.500px.com/2015/03/17/a-blurring-view-for-android.html)
* 原文作者 : [Jun Luo](https://500px.com/junluo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 认领中

## Blur Effect

Blur effect can be used to vividly convey a sense of layering of content. It allows the user to maintain the context, while focused on the currently featured content, even if what’s under the blurring surface shifts in a parallax fashion or changes dynamically.

On iOS, we could get this sort of blurring by first constructing a `UIVisualEffectView`:

    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

and then adding `visualEffectView` to a view hierarchy, in which it will dynamically blur what’s under it.

## State of the Art on Android

While things are not as straightforward on Android, we did see great examples of the blur effect, such as in the Yahoo Weather app. According to [Nicholas Pomepuy’s blog post](http://nicolaspomepuy.fr/blur-effect-for-android-design/), however, the blurring is here achieved through caching a pre-render blurred version of the background image.

While this approach could be very effective, it is not exactly suitable for our needs. At [500px](https://500px.com), images are typically the focal content rather than merely supplying a background. That means images could change a lot and change quickly, even if they are behind a blurring layer. The tour in [our Android app](https://play.google.com/store/apps/details?id=com.fivehundredpx.viewer) is a case in point. Here, as the user swipes for the next page, rows of images shift in opposite directions and fade out, making it difficult to appropriately manage multiple pre-rendered images for composing the required blur effect.

![Blurring in the tour of 500px Android App](http://developers.500px.com/images/2015-03-17-500px-android-tour-blurring.png)

## A View Drawing Approach

What we needed for the tour is a blurring view that dynamically blurs the views underneath it in real time. The interface we eventually arrived at is as simple as first giving the blurring view a reference to the blurred view:

    blurringView.setBlurredView(blurredView);

and then whenever the blurred view changes – whether it is due to content change (e.g. displaying a new photo), view transformation, or a step in animation, we invalidate the blurring view:

    blurringView.invalidate();

To implement the blurring view, we subclass the `View` class and override the `onDraw()` method to render the blurred effect:

    protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);

    // Use the blurred view’s draw() method to draw on a private canvas.
    mBlurredView.draw(mBlurringCanvas);

    // Blur the bitmap backing the private canvas into mBlurredBitmap
    blur();

    // Draw mBlurredBitmap with transformations on the blurring view’s main canvas.
    canvas.save();
    canvas.translate(mBlurredView.getX() - getX(), mBlurredView.getY() - getY());
    canvas.scale(DOWNSAMPLE_FACTOR, DOWNSAMPLE_FACTOR);
    canvas.drawBitmap(mBlurredBitmap, 0, 0, null);
    canvas.restore();
    }

The key here is that when the blurring view redraws, it uses the `draw()` method of the blurred view, to which it has a reference, but draws into a private, bitmap-backed canvas:

    mBlurredView.draw(mBlurringCanvas);

(It is worth noting that this approach of calling another view’s `draw()` method is also suitable for building a magnifier or signature UI, wherein the content of the magnified or signature area is enlarged, rather than blurred.)

Following the ideas discussed in [Nicholas Pomepuy’s post](http://nicolaspomepuy.fr/blur-effect-for-android-design/), we use a combination of subsampling and [RenderScript](http://developer.android.com/guide/topics/renderscript/compute.html) for fast processing. The setup for subsampling is done when we initialize the blurring view’s private canvas `mBlurringCanvas`:

    int scaledWidth = mBlurredView.getWidth() / DOWNSAMPLE_FACTOR;
    int scaledHeight = mBlurredView.getHeight() / DOWNSAMPLE_FACTOR;

    mBitmapToBlur = Bitmap.createBitmap(scaledWidth, scaledHeight, Bitmap.Config.ARGB_8888);
    mBlurringCanvas = new Canvas(mBitmapToBlur);

Given this setup and appropriate initialization of RenderScript, the `blur()` method used in `onDraw()` above is as simple as:

    mBlurInput.copyFrom(mBitmapToBlur);
    mBlurScript.setInput(mBlurInput);
    mBlurScript.forEach(mBlurOutput);
    mBlurOutput.copyTo(mBlurredBitmap);

Now that `mBlurredBitmap` is ready, the rest of the `onDraw()` method takes care of drawing it into the blurring view’s own canvas using appropriate translation and scaling.

## Implementation Detail

For a full implementation, we need to be mindful of several technical points. First, we have found that a factor of 8 for downsampling scaling and a blurring radius of 15 to be good for our purposes. Parameters suitable for your needs may be different.

Second, we encountered some RenderScript artifacts at the edge of the blurred bitmap. To counter that, we rounded the scaled width and height up to the nearest multiple of 4:

    // The rounding-off here is for suppressing RenderScript artifacts at the edge.
    scaledWidth = scaledWidth - (scaledWidth % 4) + 4;
    scaledHeight = scaledHeight - (scaledHeight % 4) + 4;

Third, to further ensure good performance, we create the two bitmaps `mBitmapToBlur`, which backs the private canvas `mBlurringCanvas`, and `mBlurredBitmap` on demand and recreate them only if the blurred view’s size has changed. Likewise, we create RenderScript’s `Allocation` objects `mBlurInput` and `mBlurOutput` only when the blurred view’s size has changed.

Fourth, we also draw a layer of uniform, semi-transparent white color with `PorterDuff.Mode.OVERLAY` on top of the blurred image for the lightness required for our design.

Finally, because RenderScript is only available on API level 17 and up, we need to degrade gracefully on older versions of Android. Unfortunately, a bitmap blurring solution in Java as noted in [Nicholas Pomepuy’s post](http://nicolaspomepuy.fr/blur-effect-for-android-design/), while adequate for pre-rendering a cached copy, is not fast enough for realtime rendering. The decision we made was to simply use a semitransparent view with high opacity as fallback.

## Pros and Cons

We like this view drawing approach because it blurs in real time, it’s easy to use, it allows agnosticity of the blurred view’s content, it also allows some flexibility in the relationship between the blurring and the blurred view, and, above all, it suits our needs.

However, this approach does expect the blurring view to be privy to the whereabouts of the blurred view for appropriate coordinate transformation. Relatedly, the blurring view must not be a subview of the blurred view, otherwise you’ll get a stack overflow from mutually nested drawing calls. A simple but principled way with this limitation is to ensure that the blurring view is a sibling of the blurred view that sits in front of it in z-order.

Another limitation we have noticed has to do with vector drawing and text, which does not seem to play well with our use of the default bitmap downsampling.

## Library and Demo

To see our solution in action, you can check out the tour in [our Android app](https://play.google.com/store/apps/details?id=com.fivehundredpx.viewer). We have also put together a tiny open source library [on GitHub](https://github.com/500px/500px-android-blur) along with a detailed demo that shows how to use it with content change and with animation as well as view transformation.

![500px Blurring View Demo](https://github.com/500px/500px-android-blur/raw/master/blurdemo.gif)

