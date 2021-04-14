> * 原文地址：[Telegram-like uploading animation](https://proandroiddev.com/telegram-like-uploading-animation-e284f1404f63)
> * 原文作者：[Michael Spitsin](https://programmerr47.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/telegram-like-uploading-animation.md](https://github.com/xitu/gold-miner/blob/master/article/2021/telegram-like-uploading-animation.md)
> * 译者：
> * 校对者：

# Telegram-like uploading animation

![](https://miro.medium.com/max/1656/1*Fkn89gxEsTWWefUu1dV0UA.png)

Some time ago I worked on a new feature: sending images in the app’s internal chat. The feature itself was big and included multiple things, but actually, initially, there was no design for uploading animation with the ability to cancel the upload. When I moved to this part I decided that Images Needs Their Uploading Animations, so let’s give them that. :)

![](https://miro.medium.com/max/1528/1*La8YF7kI31hvmawzNVHN6g.gif)

## View vs Drawable

Actually, it’s a good question. Because if we [look at one of my other posts about sonar-like animation](https://proandroiddev.com/sonar-like-animation-c1e7c5b291bd), I used a `Drawable` there. In my personal opinion there is a pretty good and concise answer [in StackOverflow](https://stackoverflow.com/questions/12445045/android-custom-drawable-vs-custom-view):

> `Drawable` only response for the draw operations, while view response for the draw and user interface like touch events and turning off screen and more.

Now let’s analyze, what we want to do. We want to have an infinite circle animation of the arc that increases in angle until it will fit the circle and spinning around at the same time. Seems like a drawable is our best friend. And actually, I should do that. But I didn’t.

My reason was in the small three-dots animation that you can see in the sample above. The point is that I did this animation with a custom view and I already prepared the background for infinite animations. For me, it was easier to extract the animation preparation logic into the parent view and then reuse it, rather than rewrite everything as drawables. So I’m not saying that my solution was right *(actually nothing is right)*, but rather it met my needs.

## Base InfiniteAnimationView

For the sake of my own needs I will split the desired progress view into two views:

1. `ProgressView` — which is responsible for the drawing of the desired progress
2. `InfiniteAnimateView` — abstract view which is responsible for the preparation, starting, and stopping animation. Since the progress contains the infinite spinning part, we need to understand when we need to start this animation and when to stop

After looking in the [source code of Android’s `ProgressBar`](https://android.googlesource.com/platform/frameworks/base/+/master/core/java/android/widget/ProgressBar.java) we can end up with something like that:

```kotlin
// InfiniteAnimateView.kt

abstract class InfiniteAnimateView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var isAggregatedVisible: Boolean = false

    private var animation: Animator? = null

    override fun onVisibilityAggregated(isVisible: Boolean) {
        super.onVisibilityAggregated(isVisible)

        if (isAggregatedVisible != isVisible) {
            isAggregatedVisible = isVisible
            if (isVisible) startAnimation() else stopAnimation()
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        startAnimation()
    }

    override fun onDetachedFromWindow() {
        stopAnimation()
        super.onDetachedFromWindow()
    }

    private fun startAnimation() {
        if (!isVisible || windowVisibility != VISIBLE) return
        if (animation == null) animation = createAnimation().apply { start() }
    }

    protected abstract fun createAnimation(): Animator

    private fun stopAnimation() {
        animation?.cancel()
        animation = null
    }
}
```

Unfortunately, it will not work mainly because of the method `onVisibilityAggregated`. [Because it supported since API 24](https://developer.android.com/reference/android/view/View#onVisibilityAggregated(boolean)). Moreover, I had issues with `!isVisible || windowVisibility != VISIBLE` when the view was visible but the container of it was not. So I decided to rewrite this:

```kotlin
// InfiniteAnimateView.kt

abstract class InfiniteAnimateView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var animation: Animator? = null

    /**
     * We can not use `onVisibilityAggregated` since it is introduced from sdk 24, but we have min = 21
     */
    override fun onVisibilityChanged(changedView: View, visibility: Int) {
        super.onVisibilityChanged(changedView, visibility)

        if (isShown) startAnimation() else stopAnimation()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        startAnimation()
    }

    override fun onDetachedFromWindow() {
        stopAnimation()
        super.onDetachedFromWindow()
    }

    private fun startAnimation() {
        if (!isShown) return
        if (animation == null) animation = createAnimation().apply { start() }
    }

    protected abstract fun createAnimation(): Animator

    private fun stopAnimation() {
        animation?.cancel()
        animation = null
    }
}
```

Unfortunately, this also didn’t work, however, I was sure that it will. So to be honest, I don’t know the exact reason. Probably it will work in an ordinary case, but will not work for the RecyclerView. Some time ago I had some problems with tracking if some things are displayed in recycler view using `isShown`. Thus, probably my final solution will be not right, but at least it working as I’m expecting in my scenarios:

```kotlin
// InfiniteAnimateView.kt

abstract class InfiniteAnimateView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var animation: Animator? = null

    /**
     * We can not use `onVisibilityAggregated` since it is introduced from sdk 24, but we have min = 21
     */
    override fun onVisibilityChanged(changedView: View, visibility: Int) {
        super.onVisibilityChanged(changedView, visibility)
        if (isDeepVisible()) startAnimation() else stopAnimation()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        startAnimation()
    }

    override fun onDetachedFromWindow() {
        stopAnimation()
        super.onDetachedFromWindow()
    }

    private fun startAnimation() {
        if (!isAttachedToWindow || !isDeepVisible()) return
        if (animation == null) animation = createAnimation().apply { start() }
    }

    protected abstract fun createAnimation(): Animator

    private fun stopAnimation() {
        animation?.cancel()
        animation = null
    }

    /**
     * Probably this function implements View.isShown, but I read that there are some issues with it
     * And I also faced with those issues in Lottie lib. Since we have as always no time to completelly
     * investigate this, I decided to put this small and simple method just to be sure it does,
     * what exactly I need :)
     *
     * Upd: tried to use isShown instead of this method, and it didn't work out. So if you know
     * how to improve that, you most welcome :)
     */
    private fun isDeepVisible(): Boolean {
        var isVisible = isVisible
        var parent = parentView
        while (parent != null && isVisible) {
            isVisible = isVisible && parent.isVisible
            parent = parent.parentView
        }
        return isVisible
    }

    private val View.parentView: ViewGroup? get() = parent as? ViewGroup
}
```

## Progress animation

### Preparation

So first of all let’s talk about the structure of our view. Which drawing components does it contain? The best representation of it, in this case, is the declaration of different paints:

```kotlin
// progress_paints.kt

private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
    style = Paint.Style.FILL
    color = defaultBgColor
}
private val bgStrokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
    style = Paint.Style.STROKE
    color = defaultBgStrokeColor
    strokeWidth = context.resources.getDimension(R.dimen.chat_progress_bg_stroke_width)
}
private val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
    style = Paint.Style.STROKE
    strokeCap = Paint.Cap.BUTT
    strokeWidth = context.resources.getDimension(R.dimen.chat_progress_stroke_width)
    color = defaultProgressColor
}
```

For the purpose of showing I will variate stroke’s widths and other things so you will see the difference in some aspects. So those 3 paints are associated with 3 key parts of the progress:

![](https://miro.medium.com/max/1200/1*UnoyHSg3xYZzyRNwYm35HA.gif)

**left:** background; **center:** stroke; **right:** progress

You may be wondering why `Paint.Cap.BUTT`. Well to make this progress more “telegramish” (at least as on iOS devices) you should use `Paint.Cap.ROUND`. Let me demonstrate the difference between all three possible caps (will increase stroke width for more obvious difference spots).

![](https://miro.medium.com/max/1200/1*lh_H6Nv_1ixygHP6q8k6Lw.gif)

**left:** `Cap.BUTT`, **center:** `Cap.ROUND`, **right:** `Cap.SQUARE`

So the main difference is that `Cap.ROUND` gives to the stroke’s corners the special rounding, whereas `Cap.BUTT` and `Cap.SQUARE` just cut. The `Cap.SQUARE` also use the additional space as `Cap.ROUND`, but not for rounding. This can result in that `Cap.SQUARE` shows the same angle as `Cap.BUTT`, but with additional extra space:

![](https://miro.medium.com/max/1364/1*auxY8ZqofcNmZMsezh0DkA.png)

Trying to show 90 degrees with Cap.BUTT and Cap.SQUARE.

Giving all of that it is best to use `Cap.BUTT` as it shows a more proper angle representation than `Cap.SQUARE`

> By the way `Cap.BUTT` is default paint’s stroke cap. Here is an official [documentation link](https://developer.android.com/reference/android/graphics/Paint.Cap). But I wanted to show you the real difference, because initially I wanted to make it round, then I started to use `SQUARE` but noticed couple of artifacts.

### Base spinning

The animation itself is really simple giving that we have `InfiniteAnimateView`

```kotlin
ValueAnimator.ofFloat(currentAngle, currentAngle + MAX_ANGLE)
    .apply {
        interpolator = LinearInterpolator()
        duration = SPIN_DURATION_MS
        repeatCount = ValueAnimator.INFINITE
        addUpdateListener { 
            currentAngle = normalize(it.animatedValue as Float)
        }
    }
```

where `normalize` is a simple method of putting every angle in `[0, 360)` range. For instance, for angle *400.54* the normalized version will be *40.54.*

```kotlin
private fun normalize(angle: Float): Float {
    val decimal = angle - angle.toInt()
    return (angle.toInt() % MAX_ANGLE) + decimal
}
```

### Measurement & Drawing

We will rely on measured dimensions that will be provided by the parent or through the xml’s exact`layout_width` & `layout_height` value. So we do nothing in terms of view’s measurement, but we used the measured dimensions for the preparation of the progress rectangle, in which we will draw the view.

Well, it is not so hard, but we need to keep in mind a few things.

![](https://miro.medium.com/max/692/1*x0X1dP0bxHg-Z-iU0p-JhA.png)

* We can not just take `measuredWidth` & `measuredHeight` to draw a circle background, progress, and stroke. Mainly because of the stroke. If we will not take into account the stroke’s width and will not subtract its half from our dimension computations we will end up with cut looking borders :(

![](https://miro.medium.com/max/680/1*pQhNsv1OWffDnraP6njZgA.png)

* If we will not take into account the stroke’s width we may end up overlapping it in the drawing stage. It can be fine for opaque colors.

But if you will use translucent colors, you will see overlapping as a strange artifact (I increased stroke width for more clear picture)

### Sweep angle

Okay, the last thing is progress itself. Suppose we can change it from 0 to 1

```kotlin
@FloatRange(from = .0, to = 1.0, toInclusive = false)
var progress: Float = 0f
```

@FloatRange(from = .0, to = 1.0, toInclusive = false)  
var progress: Float = 0f

To draw the arc we need to compute a special sweep angle. It is a special angle of the drawing part. 360 — a full circle will be drawn. 90 — a quarter of the circle will be drawn.

So we need to convert the progress to degrees. And at the same time, we need to keep the sweep angle not 0, so we will be able to draw a small piece of progress if the value `progress` will be equal to 0.

```kotlin
private fun convertToSweepAngle(progress: Float): Float =
    MIN_SWEEP_ANGLE + progress * (MAX_ANGLE - MIN_SWEEP_ANGLE)
```

private fun convertToSweepAngle(progress: Float): Float =  
MIN\_SWEEP\_ANGLE + progress \* (MAX\_ANGLE - MIN\_SWEEP\_ANGLE)

Where `MAX_ANGLE = 360` (but you can put whatever you prefer) and `MIN_SWEEP_ANGLE` is the minimum amount of progress in degrees that will be shown if `progress = 0`.

## Gather up

Now giving all that information we can build the completed view

```kotlin
// ChatProgressView.kt

class ChatProgressView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : InfiniteAnimateView(context, attrs, defStyleAttr) {

    private val defaultBgColor: Int = context.getColorCompat(R.color.chat_progress_bg)
    private val defaultBgStrokeColor: Int = context.getColorCompat(R.color.chat_progress_bg_stroke)
    private val defaultProgressColor: Int = context.getColorCompat(R.color.white)

    private val progressPadding = context.resources.getDimension(R.dimen.chat_progress_padding)

    private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = defaultBgColor
    }
    private val bgStrokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        color = defaultBgStrokeColor
        strokeWidth = context.resources.getDimension(R.dimen.chat_progress_bg_stroke_width)
    }
    private val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = context.resources.getDimension(R.dimen.chat_progress_stroke_width)
        color = defaultProgressColor
    }

    @FloatRange(from = .0, to = 1.0, toInclusive = false)
    var progress: Float = 0f
        set(value) {
            field = when {
                value < 0f -> 0f
                value > 1f -> 1f
                else -> value
            }
            sweepAngle = convertToSweepAngle(field)
            invalidate()
        }

    //in degrees [0, 360)
    private var currentAngle: Float by observable(0f) { _, _, _ -> invalidate() }
    private var sweepAngle: Float by observable(MIN_SWEEP_ANGLE) { _, _, _ -> invalidate() }

    private val progressRect: RectF = RectF()
    private var bgRadius: Float = 0f

    init {
        attrs?.parseAttrs(context, R.styleable.ChatProgressView) {
            bgPaint.color = getColor(R.styleable.ChatProgressView_bgColor, defaultBgColor)
            bgStrokePaint.color = getColor(R.styleable.ChatProgressView_bgStrokeColor, defaultBgStrokeColor)
            progressPaint.color = getColor(R.styleable.ChatProgressView_progressColor, defaultProgressColor)
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)

        val horizHalf = (measuredWidth - padding.horizontal) / 2f
        val vertHalf = (measuredHeight - padding.vertical) / 2f

        val progressOffset = progressPadding + progressPaint.strokeWidth / 2f

        //since the stroke it drawn on center of the line, we need to safe space for half of it, or it will be truncated by the bounds
        bgRadius = min(horizHalf, vertHalf) - bgStrokePaint.strokeWidth / 2f

        val progressRectMinSize = 2 * (min(horizHalf, vertHalf) - progressOffset)
        progressRect.apply {
            left = (measuredWidth - progressRectMinSize) / 2f
            top = (measuredHeight - progressRectMinSize) / 2f
            right = (measuredWidth + progressRectMinSize) / 2f
            bottom = (measuredHeight + progressRectMinSize) / 2f
        }
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        with(canvas) {
            //(radius - strokeWidth) - because we don't want to overlap colors (since they by default translucent)
            drawCircle(progressRect.centerX(), progressRect.centerY(), bgRadius - bgStrokePaint.strokeWidth / 2f, bgPaint)
            drawCircle(progressRect.centerX(), progressRect.centerY(), bgRadius, bgStrokePaint)
            drawArc(progressRect, currentAngle, sweepAngle, false, progressPaint)
        }
    }

    override fun createAnimation(): Animator = ValueAnimator.ofFloat(currentAngle, currentAngle + MAX_ANGLE).apply {
        interpolator = LinearInterpolator()
        duration = SPIN_DURATION_MS
        repeatCount = ValueAnimator.INFINITE
        addUpdateListener { currentAngle = normalize(it.animatedValue as Float) }
    }

    /**
     * converts (shifts) the angle to be from 0 to 360.
     * For instance: if angle = 400.54, the normalized version will be 40.54
     * Note: angle = 360 will be normalized to 0
     */
    private fun normalize(angle: Float): Float {
        val decimal = angle - angle.toInt()
        return (angle.toInt() % MAX_ANGLE) + decimal
    }

    private fun convertToSweepAngle(progress: Float): Float =
        MIN_SWEEP_ANGLE + progress * (MAX_ANGLE - MIN_SWEEP_ANGLE)

    private companion object {
        const val SPIN_DURATION_MS = 2_000L
        const val MIN_SWEEP_ANGLE = 10f //in degrees
        const val MAX_ANGLE = 360 //in degrees
    }
}
```

### The bonus!

The small bonus for that is we can play a little bit with a method`drawArc`. You see, we have a `currentAngle`, which represents the angle of the starting point for arc’s drawing. And we have a `sweepAngle`, which represents how much of arc in degrees we need to draw.

When the progress is increased, we change only `sweepAngle`, which means that if `currentAngle` is the static value (not mutable), then we will see *“increasing”* the arc only in one direction. We can play with it. Let’s consider three cases and look at the result:

```kotlin
//In this scenario arc "increases" only in one direction
1. drawArc(progressRect, currentAngle, sweepAngle, false, progressPaint)
//In this scenario arc "increases" in both directions
2. drawArc(progressRect, currentAngle - sweepAngle / 2f, sweepAngle, false, progressPaint)
//In this scenario arc "increases" in another direction
3. drawArc(progressRect, currentAngle - sweepAngle, sweepAngle, false, progressPaint)
```

And the result is:

![](https://miro.medium.com/max/1200/1*fbLfs0wImFm_GzMyJYWJCA.gif)

**Left:** 1st scenario, **Middle:** 2nd scenario, **Right**: 3rd scenario

As you can see the left and the right animations (scenarios `1.` and `3.`) are not consistent in terms of speed. While the first one gives a sense of faster spinning speed, the progress is increasing, the last on the contrary gives a sense of slower spinning speed. And vice versa for decreasing progress.

The middle animation is consistent however in terms of spinning speed. So if you will not just increase progress (for file uploading, for instance), or just decrease the progress (for count down timer, for example), then I would recommend using the option `2.`.

## Afterwords

Animations are great. Pixels are great. Shapes are great. We just need to treat them carefully with love. As details are the most valuable thing in the product ;)

![](https://miro.medium.com/max/292/0*19Qsjr8oaWOKrhLk.gif)

If you liked that article, don’t forget to support me by clapping and if you have any questions, comment me and let’s have a discussion. Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
