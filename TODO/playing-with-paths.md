> * 原文地址：[Playing with Paths](https://medium.com/google-developers/playing-with-paths-3fbc679a6f77)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/playing-with-paths.md](https://github.com/xitu/gold-miner/blob/master/TODO/playing-with-paths.md)
> * 译者：[IllllllIIl](https://github.com/IllllllIIl)
> * 校对者：[LeeSniper](https://github.com/LeeSniper)

# 玩转 Paths

我最近帮别人实现了一个 app 里面英雄人物的动画。然而，我现在还不能把这个动画分享给你们。但我想分享在实现它的过程中学到的东西。在这篇文章中，我将回顾如何重现这些由 [Dave ‘beesandbombs’ Whyte](https://beesandbombs.tumblr.com/) 展示的迷人动画，其中演示了很多一样的实现技巧。

![](https://cdn-images-1.medium.com/max/800/1*uHGhUwxAvufuD_THa7sjAg.gif)

beesandbombs 展示的[多边形绕圈](https://beesandbombs.tumblr.com/post/161295765794/polygon-laps)

当我看到这个时（对熟悉我工作的人来说可能不是很惊讶），第一想法是使用 [AnimatedVectorDrawable](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html) (下文会简称为 `AVD`)。`AVD` 很好用，但不是适用所有的情况 —— 特别是我们有如下的需求的话：

* 我知道我们需要画一个多边形，但还没却确定具体要画哪个形状。`AVD` 是需要预先设定参数的动画，即改变形状需要重新设置动画。
* 关于动画进度追踪的问题，我们只想要绘制多边形的一部分。`AVD` 是“义无反顾”地执行任务，如果动画开始后，它会完整地执行完整个动画，换句话说你不能取消它。
* 我们想要使另一个物体绕着多边形运动。这个当然也可以通过 `AVD` 实现。但它还是需要很多事前工作去计算想生成的轨迹。
* 我们想把绕多边形物体的运动进度与多边形的显示分离开来，独立控制。

因此我选择用自定义 [Drawable](https://developer.android.com/reference/android/graphics/drawable/Drawable.html) 来实现，其中包含多个 [Path](https://developer.android.com/reference/android/graphics/Path.html) 对象。`Path` 是对图形形状的基本描绘（AVD 中实际也使用了 Path！），而且 Android [Canvas](https://developer.android.com/reference/android/graphics/Canvas.html) 的 API也是借助 Path 来生成各种有趣的效果。在实现一些效果之前，我想强烈推荐 [Romain Guy](https://medium.com/@romainguy) 这篇写得很好的文章，里面展示的很多技巧就是我在本文所用到的：

[**Android Recipe #4, path tracing**](http://www.curious-creature.com/2013/12/21/android-recipe-4-path-tracing/)

#### 极坐标系

当定义 2d 形状的时候，我们通常在笛卡尔坐标系 (x,y) 中进行定义。通过指定 x 轴和 y 轴上离原点的距离，来定义图形形状。而另一个我们可选用的极坐标系，则是定义离原点的角度和半径长度。

![](https://cdn-images-1.medium.com/max/800/0*i620xgMH8TKxMtP3.)

笛卡尔坐标系（左边）vs 极坐标系（右边）

我们可以通过这两条公式进行极坐标系和笛卡尔坐标系之间的转换：

```
val x = radius * Math.cos(angle);
val y = radius * Math.sin(angle);
```

我强烈推荐读下面这篇文章以了解更多关于极坐标系的内容：

[**极坐标系**](http://varun.ca/polar-coords/ "http://varun.ca/polar-coords/")

为了能生成规则的多边形（例如每个内角的度数相同），极坐标系能起到非常大的作用。为了生成想要的边数，你可以通过计算求出对应的度数（因为内角度数和是 360 度），然后借助同一个半径，再利用这个度数的多个倍数关系去描绘出每个点。 你可以用图形 API 将这些点坐标转化为笛卡尔坐标。下面是一个通过给定的边数和半径生成多边形 `Path` 的函数：

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

所以为了生成想要的多边形组合，我们创建了一个有不同边数、半径和颜色的多边形 list 集合。`Polygon` 是一个持有这些信息和计算相应 `Path` 的类：

```
private val polygons = listOf(
  Polygon(sides = 3, radius = 45f, color = 0xffe84c65.toInt()),
  Polygon(sides = 4, radius = 53f, color = 0xffe79442.toInt()),
  Polygon(sides = 5, radius = 64f, color = 0xffefefbb.toInt()),
  ...
)
```

![](https://cdn-images-1.medium.com/max/800/1*w913bdMCd1gvcQJdkRC-gQ.png)

#### 有效的 path 绘制

绘制一个 Path 只需简单地调用 [Canvas.drawPath(path, paint)](https://developer.android.com/reference/android/graphics/Canvas.html#drawPath%28android.graphics.Path,%20android.graphics.Paint%29) 但是 [Paint](https://developer.android.com/reference/android/graphics/Paint.html) 类的参数[支持](https://developer.android.com/reference/android/graphics/Paint.html#setPathEffect%28android.graphics.PathEffect%29) [PathEffect](https://developer.android.com/reference/android/graphics/PathEffect.html)，借助这个我们可以去更改 path 被绘制时的效果。 例如我们可以使用 [CornerPathEffect](https://developer.android.com/reference/android/graphics/CornerPathEffect.html) 去把我们的多边形的各个角圆滑化处理或者是用 [DashPathEffect](https://developer.android.com/reference/android/graphics/DashPathEffect.html) 去分段地画出 `Path`（虚线效果，译者注）（关于这个技巧的更多细节，请阅读前面提到的那篇 Path tracing [文章](http://www.curious-creature.com/2013/12/21/android-recipe-4-path-tracing/) ）：

![](https://cdn-images-1.medium.com/max/800/0*YYIS8QVIZWMvkZU6.)

> 另外一种画分段 path 的方法是使用 [PathMeasure#getSegment](https://developer.android.com/reference/android/graphics/PathMeasure.html#getSegment%28float%2C%20float%2C%20android.graphics.Path%2C%20boolean%29)，它能复制 path 的某一部分到一个新的 Path 对象。我是直接使用了能画出虚线的方法，就像自己改变了绘制的时间间隔和分段绘制实现的效果一样。

通过暴露这些控制 drawable 特性的参数，我们可以很容易地生成动画：

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

例如，这是绘制同心圆多边形 path 过程的不同动画效果：

![](https://cdn-images-1.medium.com/max/800/0*YRIGAx02Jyocd7G4.)

#### 吸附在 path 上

为了绘制某个沿着 path 的物体，我们可以使用 [PathDashPathEffect](https://developer.android.com/reference/android/graphics/PathDashPathEffect.html). 这会把另一个 `Path` 沿着某条 path “点印”在它上面，例如像这样以蓝色圆形形状沿着一个多边形的边点印在上面：

![](https://cdn-images-1.medium.com/max/800/1*tKje69sTkg8-Wvwnkcj-IQ.png)

`PathDashPathEffect` 接收 `advance` 和 `phase` 两个参数 —— 分别对应每个 stamp（绘制在 path 上面的物体，译者注）之间的间距和绘制第一个 stamp 在 path 上的偏移量。通过把每个 stamp 的间距设置为和整个 path 的长度一样(通过 [PathMeasure#getLength](https://developer.android.com/reference/android/graphics/PathMeasure.html#getLength%28%29) 获取)， 我们就可以只绘制出一个 stamp。然后再通过不断改变偏移量，（偏移量是由 `dotProgress` 范围 [0, 1] 控制）我们就可以实现只有一个 stamp 沿着 path 在运动的动画效果。

```
val phase = dotProgress * polygon.length
dotPaint.pathEffect = PathDashPathEffect(pathDot, polygon.length,
    phase, TRANSLATE)
canvas.drawPath(polygon.path, dotPaint)
```

我们现在有生成我们图形的所有要素。通过添加另一个参数，就是每个点在每个多边形上所对应的第几“圈”的圈数，每个点会完成对应的绕圈动画。能生成像这样的效果：



![](https://cdn-images-1.medium.com/max/800/1*vCysqKE1ek9WjJXVrqqUqQ.gif)

通过 Android drawable 实现原本 gif 的效果

你可以通过下面的链接获得这个 drawable 的源码：
[https://gist.github.com/nickbutcher/b41da75b8b1fc115171af86c63796c5b#file-polygonlapsdrawable-kt](https://gist.github.com/nickbutcher/b41da75b8b1fc115171af86c63796c5b#file-polygonlapsdrawable-kt)

#### 展示不同的效果

你们可能已经注意到 PathDashPathEffect 构造方法中最后的参数：[Style](https://developer.android.com/reference/android/graphics/PathDashPathEffect.Style.html)。这个枚举类控制在 path 上面的 stamp 在每个位置上是如何被绘制的。为了展示这个参数的使用，下面的例子使用了一个三角形 stamp 代替圆形，去展示`平移（translate）`和`旋转（rotate）`的效果差别：

![](https://github.com/IllllllIIl/Translation/blob/master/path.gif?raw=true)

比较`平移`和`旋转`效果的异同

注意到使用 `translate` 效果时，三角形 stamp 方向总是相同的（箭头方向指向左）而如果是 `rotate` 效果的话，三角形会旋转自身保持在处于 path 的切线方向上。

还有一种 `类型` 叫做 `morph`，能让 stamp 平稳变换。为了展示这个效果，我把 stamp 变成了如下的一条线段。请观察当经过角落时，线段是如何弯曲的：

![](https://cdn-images-1.medium.com/max/800/1*Wc2bErgxb68pCBrODWD8Ag.gif)

当PathDashPathEffect.Style的类型为 `MORPH` 

有趣的是，某些情况下，在 path 的开头或紧密的角落，stamp 的形状有点扭曲。

> 提醒一点你可以使用 `ComposePathEffect` 去组合多种 `PathEffect` 在一起，通过将 `PathDashPathEffect`和 `CornerPathEffect` 一起组合使用，可以实现让 stamp 在有圆滑角落的 path 上运动。

#### 使用正切

上面我们所讨论的是关于如何生成多边形的绕圈组合，而我最初的需求实际上还要麻烦点。使用 `PathDashPathEffect` 的缺点是只能应用一种单一的形状和颜色。我自己的作品需要有更精巧的标记（marker，即 stamp，译者注），所以我用一种比点印在 path 上更好的办法。我使用了 `Drawable` 并且计算给定一个进度的话，沿着 Path 标记需要在哪个地方绘制出来。

![](https://cdn-images-1.medium.com/max/800/1*New-800sQntmGpmk6griDg.gif)

###### 沿着 path 移动 VectorDrawable

为了实现这个效果，我再次使用 `PathMeasure` 类，它提供了 [getPosTan](https://developer.android.com/reference/android/graphics/PathMeasure.html#getPosTan%28float%2C%20float%5B%5D%2C%20float%5B%5D%29) 方法获取位置坐标，和沿着某个 Path 给定长度时的正切值。通过这样（涉及到一点数学），我们可以平移和旋转画布，从而让我们的`标记`绘制在正确的位置和方向上。 

```
pathMeasure.setPath(polygon.path, false)
pathMeasure.getPosTan(markerProgress * polygon.length, pos, tan)
canvas.translate(pos[0], pos[1])
val angle = Math.atan2(tan[1].toDouble(), tan[0].toDouble())
canvas.rotate(Math.toDegrees(angle).toFloat())
marker.draw(canvas)
```

#### 找到你的 path 

希望这篇文章能够说明自定义 drawable 的同时去创建和操作 path 对于生成有趣的图形效果是多么有用。 编写一个自定义 drawable，在单独更改各部分的动画效果这方面有很灵活的控制。这个方法也能让你动态更改数值，而不用需要预先就设定好整个动画。期待你们通过 Android 的 Path API 和其他内置效果实现更多新奇的效果，而这些工具早在 API 1 的时候就已经可以使用了。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
