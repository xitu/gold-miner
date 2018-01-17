> * 原文地址：[Playing with Paths](https://medium.com/google-developers/playing-with-paths-3fbc679a6f77)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/playing-with-paths.md](https://github.com/xitu/gold-miner/blob/master/TODO/playing-with-paths.md)
> * 译者：
> * 校对者：

# Playing with Paths

I recently helped out with a hero animation in an app–unfortunately I can’t share this animation just yet… but I wanted to share what I learned making it. In this post I’ll walk through recreating this mesmerizing animation by [Dave ‘beesandbombs’ Whyte](https://beesandbombs.tumblr.com/) which demonstrates many of the same techniques:

![](https://cdn-images-1.medium.com/max/800/1*uHGhUwxAvufuD_THa7sjAg.gif)

[_Polygon Laps_](https://beesandbombs.tumblr.com/post/161295765794/polygon-laps) by beesandbombs 🐝💣

My first thought when looking at this (which might not be much of a surprise to anyone who knows my work) was to reach for an `[AnimatedVectorDrawable](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html)` (`AVD` hereafter). `AVD`s are great, but they’re not suitable for every situation — specifically we had the following requirements:

* I knew we’d need to draw a polygon, but we hadn’t settled on the exact shape. `AVD`s are “pre-baked” animations, as such varying the shape would require re-making the animation.
* Part of the ‘progress tracking’ aspect, we’d want to only draw a portion of the polygon. `AVD`s are ‘fire-and-forget’ i.e. you can’t scrub through them.
* We wanted to move another object around the polygon. This is definitely achievable with `AVD`s… but again would require a lot of upfront work to pre-calculate the composition.
* We wanted to control the progress of the object moving around the polygon separately from the portion of the polygon being shown.

Instead I opted to implement this as a custom `[Drawable](https://developer.android.com/reference/android/graphics/drawable/Drawable.html)`, made up of `[Path](https://developer.android.com/reference/android/graphics/Path.html)` objects. `Path`s are a fundamental representation of a shape (which `AVD`s use under the hood!) and Android’s `[Canvas](https://developer.android.com/reference/android/graphics/Canvas.html)` APIs offer pretty rich support for creating interesting effects with them. Before going through some of these, I want to give a shout out to this excellent post by [Romain Guy](https://medium.com/@romainguy) which demonstrates many of techniques which I build upon in this post:

[**Android Recipe #4, path tracing**](http://www.curious-creature.com/2013/12/21/android-recipe-4-path-tracing/)

#### Polar coordination

Usually when defining 2d shapes, we work in (x, y) coordinates technically known as cartesian coordinates. They define shapes by specifying points by their distance from the origin along the x and y axes. An alternative is the polar coordinate system which instead defines points by an angle (θ) and a radius (r) from the origin.

![](https://cdn-images-1.medium.com/max/800/0*i620xgMH8TKxMtP3.)

Cartesian coordinates (left) vs polar coordinates (right)

We can convert between polar and cartesian coords with this formula:

```
val x = radius * Math.cos(angle);
val y = radius * Math.sin(angle);
```

I highly recommend this post to learn more about polar coordinates:

[**Polar Coordinates 🌀**](http://varun.ca/polar-coords/ "http://varun.ca/polar-coords/")

To generate regular polygons (i.e. where each interior angle is the same), polar coordinates are extremely useful. You can calculate the angle necessary to produce the desired number of sides (as the interior angles total 360º) and then use multiples of this angle with the same radius to describe each point. You can then convert these points into cartesian coordinates which graphics APIs work in. Here’s a function to create a `Path` describing a polygon with a given number of sides and radius:

```
fun createPath(sides: Int, radius: Float): Path {
  val path = Path()
  val angle = 2.0 * Math.PI / sides
  path.moveTo(
      cx + (radius * Math.cos(0.0)).toFloat(),
      cy + (radius * Math.sin(0.0)).toFloat())
  for (i in 1 until sides) {
    path.lineTo(
        cx + (radius * Math.cos(angle * i)).toFloat(),
        cy + (radius * Math.sin(angle * i)).toFloat())
    }
  path.close()
  return path
}
```

![](https://cdn-images-1.medium.com/max/800/0*gfEjYsmdKv2AF-ZV.)

So to recreate our target composition, we can create a list of polygons with different numbers of sides, radius and colors. `Polygon` is a simple class which holds this info and calculates the `Path`:

```
private val polygons = listOf(
  Polygon(sides = 3, radius = 45f, color = 0xffe84c65.toInt()),
  Polygon(sides = 4, radius = 53f, color = 0xffe79442.toInt()),
  Polygon(sides = 5, radius = 64f, color = 0xffefefbb.toInt()),
  ...
)
```

![](https://cdn-images-1.medium.com/max/800/1*w913bdMCd1gvcQJdkRC-gQ.png)

#### Effective path painting

Drawing a Path is simple using `[Canvas.drawPath(path, paint)](https://developer.android.com/reference/android/graphics/Canvas.html#drawPath%28android.graphics.Path,%20android.graphics.Paint%29)` but the `[Paint](https://developer.android.com/reference/android/graphics/Paint.html)` parameter [supports](https://developer.android.com/reference/android/graphics/Paint.html#setPathEffect%28android.graphics.PathEffect%29) a `[PathEffect](https://developer.android.com/reference/android/graphics/PathEffect.html)` which we can use to alter _how_ the path will be drawn. For example we can use a `[CornerPathEffect](https://developer.android.com/reference/android/graphics/CornerPathEffect.html)` to round off the corners of our polygon or a `[DashPathEffect](https://developer.android.com/reference/android/graphics/DashPathEffect.html)` to only draw a portion of the `Path` (see the ‘Path tracing’ section of the aforementioned [post](http://www.curious-creature.com/2013/12/21/android-recipe-4-path-tracing/) for more details on this technique):

![](https://cdn-images-1.medium.com/max/800/0*YYIS8QVIZWMvkZU6.)

> An alternative technique for drawing a subsection of a path is to use `[PathMeasure#getSegment](https://developer.android.com/reference/android/graphics/PathMeasure.html#getSegment%28float%2C%20float%2C%20android.graphics.Path%2C%20boolean%29)` which copies a portion into a new `Path` object. I used the dash technique as animating the `interval` and `phase` parameters enabled interesting possibilities.

By exposing the parameters controlling these effects as properties of our drawable, we can easily animate them:

```
object PROGRESS : FloatProperty<PolygonLapsDrawable>("progress") {
  override fun setValue(pld: PolygonLapsDrawable, progress: Float) {
    pld.progress = progress
  }
  override fun get(pld: PolygonLapsDrawable) = pld.progress
}

...

ObjectAnimator.ofFloat(polygonLaps, PROGRESS, 0f, 1f).apply {
  duration = 4000L
  interpolator = LinearInterpolator()
  repeatCount = INFINITE
  repeatMode = RESTART
}.start()
```

For example, here are different ways of animating the progress of the concentric polygon paths:

![](https://cdn-images-1.medium.com/max/800/0*YRIGAx02Jyocd7G4.)

#### Stick to the path

To draw objects along the path, we can use a `[PathDashPathEffect](https://developer.android.com/reference/android/graphics/PathDashPathEffect.html)`. This ‘stamps’ another `Path` along a path, so for example stamping blue circles along a polygon might look like this:

![](https://cdn-images-1.medium.com/max/800/1*tKje69sTkg8-Wvwnkcj-IQ.png)

`PathDashPathEffect` accepts `advance` and `phase` parameters — that is the gap between stamps and how far to move along the path before the first stamp. By setting the advance to the length of the entire path (obtained via `[PathMeasure#getLength](https://developer.android.com/reference/android/graphics/PathMeasure.html#getLength%28%29)`), we can draw a single stamp. By animating the phase (here controlled by a `dotProgress` parameter [0, 1]) we can make this single stamp move along the path.

```
val phase = dotProgress * polygon.length
dotPaint.pathEffect = PathDashPathEffect(pathDot, polygon.length,
    phase, TRANSLATE)
canvas.drawPath(polygon.path, dotPaint)
```

We now have all of the ingredients to create our composition. By adding another parameter to each polygon of the number of ‘laps’ each dot should complete per animation loop, we produce this:

![](https://cdn-images-1.medium.com/freeze/max/30/1*vCysqKE1ek9WjJXVrqqUqQ.gif?q=20)

![](https://cdn-images-1.medium.com/max/800/1*vCysqKE1ek9WjJXVrqqUqQ.gif)

A re-creation of the original gif as an Android drawable

You can find the source for this drawable here:
[https://gist.github.com/nickbutcher/b41da75b8b1fc115171af86c63796c5b#file-polygonlapsdrawable-kt](https://gist.github.com/nickbutcher/b41da75b8b1fc115171af86c63796c5b#file-polygonlapsdrawable-kt)

#### Show some style

The eagle eyed amongst you might have noticed the final parameter to `PathDashPathEffect`: `[Style](https://developer.android.com/reference/android/graphics/PathDashPathEffect.Style.html)`. This enum controls how to transform the stamp at each position it is drawn. To illustrate how this parameter works the example below uses a triangular stamp instead of a circle and shows both the `translate` and `rotate` styles:

![](https://cdn-images-1.medium.com/max/800/0*QpO_ClLfUcmbzHKC.)

_Comparing_ `_translate_` _style (left) with_ `_rotate_` _(right)_

Notice that when using `translate` the triangle stamp is always in the same orientation (pointing left) whilst with the `rotate` style, the triangles rotate to remain tangential to the path.

There’s a final `style` called `morph` which actually _transforms_ the stamp. To illustrate this behaviour, I’ve changed the stamp to a line below. Notice how the lines _bend_ when traversing the corners:

![](https://cdn-images-1.medium.com/max/800/1*Wc2bErgxb68pCBrODWD8Ag.gif)

Demonstrating `PathDashPathEffect.Style.MORPH`

This is an interesting effect but seems to struggle in some circumstances like the start of the path or tight corners.

> Note that you can combine `PathEffect`s using a `ComposePathEffect`, that’s how the path stamp follows the rounded corners here, by composing a `PathDashPathEffect` with a `CornerPathEffect`.

#### Going on a tangent

While the above was all we need to recreate the polygon laps composition, my initial challenge actually called for a bit more work. A drawback with using `PathDashPathEffect` is that the stamps can only be a single shape and color. The composition I was working on called for a more sophisticated marker so I had to move beyond the path stamping technique. Instead I use a `Drawable` and calculate where along the `Path` it needs to be drawn for a given progress.

![](https://cdn-images-1.medium.com/max/800/1*New-800sQntmGpmk6griDg.gif)

_Moving a_ `_VectorDrawable_` _along a path_

To achieve this, I again used the `PathMeasure` class which offers a `[getPosTan](https://developer.android.com/reference/android/graphics/PathMeasure.html#getPosTan%28float%2C%20float%5B%5D%2C%20float%5B%5D%29)` method to obtain position coordinates and tangent at a given distance along a `Path`. With this information (and a little math), we can translate and rotate the canvas to draw our `marker` drawable at the correct position and orientation:

```
pathMeasure.setPath(polygon.path, false)
pathMeasure.getPosTan(markerProgress * polygon.length, pos, tan)
canvas.translate(pos[0], pos[1])
val angle = Math.atan2(tan[1].toDouble(), tan[0].toDouble())
canvas.rotate(Math.toDegrees(angle).toFloat())
marker.draw(canvas)
```

#### Find your path

Hopefully this post has demonstrated how a custom drawable using path creation and manipulation can be useful for building interesting graphical effects. Creating a custom drawable gives you the ultimate control to alter and animate different parts of the composition independently. This approach also lets you dynamically supply values rather than having to prepare pre-canned animations. I was very impressed with what you can achieve with Android’s `Path` APIs and the built in effects, all of which have been available since API 1.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
