> * 原文地址：[Understanding Android’s vector image format: VectorDrawable](https://medium.com/androiddevelopers/understanding-androids-vector-image-format-vectordrawable-ab09e41d5c68)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-androids-vector-image-format-vectordrawable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-androids-vector-image-format-vectordrawable.md)
> * 译者：
> * 校对者：

# Understanding Android’s vector image format: `VectorDrawable`

![](https://cdn-images-1.medium.com/max/2000/1*C9YTPhelGjw4AoXlHeuqig.png)

Android devices come in all sizes, shapes and _screen densities_. That’s why I’m a huge fan of using resolution independent, vector assets. But what exactly are they? What are their benefits? What are the costs? When should I use them? _How_ do you create and use them? In this series of posts I’d like to explore these questions and explain why I think that the vast majority of the assets in your apps should be vectors, and how to get the most out of them.

### Raster vs Vector

Most image formats (png, jpeg, bmp, gif, webp etc) are raster which means they describe the image as a fixed grid of pixels. As such they’re defined at a particular resolution and don’t _understand_ anything about their contents, just the color of each pixel. Vector graphics however _describe_ the image as a series of shapes defined over an abstract canvas size.

### Why vector?

Vector assets have 3 main benefits, they are:

*   Sharp
*   Small
*   Dynamic

#### Sharp

Vector images resize gracefully; because they describe the image over an abstract canvas size you can scale this canvas up or down and then redraw the image at that size. Raster assets however can deteriorate when you resize them. Scaling raster assets down tends to be ok (as you’re discarding information) but scaling them up leads to artifacts like fuzziness or banding, because they have to interpolate the missing pixels.

![](https://cdn-images-1.medium.com/max/800/1*Z_ol_Ajp2SsMNx3DHKUgfQ.png)

Artifacts from (extreme) scaling up a raster image (left) vs a vector image (right)

This is why on Android we need to provide multiple versions of each raster asset for different density screens:

*   res/drawable-mdpi/foo.png
*   res/drawable-hdpi/foo.png
*   res/drawable-xhdpi/foo.png
*   …

Android picks the closest **larger** density and scales it down (if needed). With the trend for devices with ever higher density screens, app makers must keep creating, including and shipping ever larger versions of the same assets. Note that many modern devices don’t sit on exact density buckets (e.g. the Pixel 3 XL is 552dpi, somewhere between xxhdpi & xxxhdpi) so assets will often be scaled.

Because vector assets resize gracefully, you can include a single asset, safe in the knowledge that it will work on any and all screen densities.

#### Small

Vector assets are generally[*](#b172) more compact than raster assets both because you only need to include a single version, and because they compresses well.

For example [here’s a change](https://github.com/google/iosched/commit/78c5d25dfbb4bf8193c46c3fb8b73c9871c44ad6) from the [Google I/O app](https://play.google.com/store/apps/details?id=com.google.samples.apps.iosched) where we switched a number of icons from raster PNGs to vectors and saved 482KB. While this might not sound like much, this was just for small iconography; larger images (such as illustrations) would have larger savings.

This [illustration](https://github.com/google/iosched/blob/71f0c4cc20c5d75bc7b211e99fcf5205330109a0/android/src/main/res/drawable-nodpi/attending_in_person.png) for example from the on-boarding flow of a previous year’s I/O app for example:

![](https://cdn-images-1.medium.com/max/800/1*tzT8u-ungCXb_CHGAyAiPA.png)

Illustrations can be good candidates for vectors

We could not replace this with a `VectorDrawable` as gradients were not supported widely at that time (spoiler: they are now!) so we had to ship a raster version 😔. If we had been able to use a vector, this would have been 30% the size for a _better_ result:

*   Raster: Download Size = 53.9KB (Raw file size = 54.8KB)
*   Vector: Download Size = 3.7KB (Raw file size = 15.8KB)

> Note that while [Android App Bundle’s](https://developer.android.com/platform/technology/app-bundle/) density configuration splits bring similar benefits by only delivering the required density assets to the device, a `VectorDrawable` will generally still be smaller and also removes the need to keep creating ever larger raster assets.

#### Dynamic

As vector images describe their contents rather than ‘flattening’ them down to pixels, they open the door to interesting new possibilities like animation, interactivity or dynamic theming. More on this in future posts.

![](https://cdn-images-1.medium.com/max/800/1*rJQEzHNMyBrZxjzpPDb84w.gif)

Vectors maintain the image structure so individual elements can be themed or animated

### Trade-offs

Vectors do have some drawbacks that need to be considered:

#### Decoding

As previously stated, vector assets describe their contents, therefore they need to be inflated and drawn before use.

![](https://cdn-images-1.medium.com/max/800/1*OsKMU2enRRjNVo09fEb08A.png)

The steps involved in decoding a vector before rendering

There are two steps to this:

1.  **Inflation**. Your vector file has to be read and parsed into a `[VectorDrawable](https://developer.android.com/reference/android/graphics/drawable/VectorDrawable)` modeling the the [paths](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/graphics/drawable/static/src/main/java/androidx/vectordrawable/graphics/drawable/VectorDrawableCompat.java#1809), [groups](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/graphics/drawable/static/src/main/java/androidx/vectordrawable/graphics/drawable/VectorDrawableCompat.java#1440) etc you declare.
2.  **Drawing**. These model objects then have to be drawn by executing `Canvas` drawing commands.

Both of these steps are proportional to the complexity of the vector and the type of operations you perform. If you use very intricate shapes, it will take longer to parse this into a `[Path](https://developer.android.com/reference/android/graphics/Path)`. Similarly, more drawing operations will take longer to perform (and some are more expensive e.g. clip operations). We’ll revisit this in a future post in this series on profiling these costs.

For static vectors, the drawing stage only needs to be performed once and can then be cached to a `Bitmap`. Animated vectors, can’t make this optimization as their properties necessarily change requiring re-drawing.

Compare this to raster assets like PNGs which only need to decode the file’s contents, something which has been highly optimized over time.

This is the essential tradeoff of raster vs vector. Vectors provide the aforementioned benefits but at the cost of being more expensive to render. In Android’s early days, devices were less powerful and screen densities differed little. Today, Android devices are more powerful and come in a huge variety of screen densities. This is why I believe it is time for all apps to move to vector assets.

#### Suitability

![](https://cdn-images-1.medium.com/max/800/1*PyZVYFWUF5bH9DYpwW16aQ.png)

Due to the nature of the format, vectors are **great** at describing some assets like simple icons etc. They’re terrible at encoding photographic type images where it’s harder to _describe_ their contents as a series of shapes and it would likely be a lot more efficient to use a raster format (like webp). This is of course a spectrum, depending upon the complexity of your asset.

#### Conversion

No design tooling (that I know of) creates `VectorDrawable`s directly which means that there is a conversion step from other formats. This can complicate the workflow between designers and developers. We’ll go into this topic in depth in a future post.

### Why not SVG?

If you’ve ever worked with vector image formats, you’ll likely have come across the SVG format (Scalable Vector Graphics), the industry standard on the web. It is capable and mature with established tooling, but it’s also a _vast_ standard. It includes many complex capabilities like executing arbitrary javascript, blur and filter effects or embedding other images, even animated gifs. Android runs on constrained mobile devices so supporting the entirety of the SVG spec wasn’t a realistic goal.

SVG does however include a [path spec](https://www.w3.org/TR/SVG/paths.html) which defines how to describe and draw shapes. With this API you can express most vector shapes. This is essentially what Android supports: SVG’s path spec (plus a few additions).

Additionally, by defining its own format, `VectorDrawable` can integrate with Android platform features. For example working with the Android resource system to reference `@colors`, `@dimens` or `@strings`, working with theme attributes or `AnimatedVectorDrawable` using standard `Animator`s.

### `VectorDrawable`’s Capabilities

As stated, `VectorDrawable` supports [SVGs path spec](https://www.w3.org/TR/SVG/paths.html), allowing you to specify one or many shapes to be drawn. It’s authored as an XML document which looks like this:

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector xmlns:android="http://schemas.android.com/apk/res/android"
  android:width="24dp"
  android:height="24dp"
  android:viewportWidth="24"
  android:viewportHeight="24">

    <path
      android:name="cross"
      android:pathData="M6.4,6.4 L17.6,17.6 M6.4,17.6 L17.6,6.4"
      android:strokeWidth="2"
      android:strokeLineCap="square"
      android:strokeColor="#999" />

</vector>
```

Note that you need to specify the asset’s intrinsic size, which is the size it would be if you set it in a `wrap_content` `ImageView`. The second `viewport` sizes define the virtual canvas, or coordinate space all subsequent drawing commands are defined in. The intrinsic and viewport dimensions can differ (but should be in the same ratio)—you could define your vectors in a 1*1 canvas if you really want.

The `<vector>` element contains one or many `<path>` elements. They can be named (for later reference e.g. animation) but crucially must specify a `pathData` element which describes the shape. This cryptic looking string can be thought of as a series of commands controlling a pen on a virtual canvas:

![](https://cdn-images-1.medium.com/max/800/1*6BxPXqBgeJIpMoiYLoOygA.gif)

Visualizing path operations

The above commands move the virtual pen, then draw a line to another point, lift and move the pen, then draw another line. With just the 4 most common commands we can describe pretty much any shape (there are more commands see [the spec](https://www.w3.org/TR/SVG/paths.html#PathData)):

*   `M` move to
*   `L` line to
*   `C` (cubic bezier) curve to
*   `Z` close (line to first point)

_(Upper case commands use absolute coordinates & lowercase use relative)_

You might wonder if you need to care about this level of detail — don’t you just get these from SVG files? While you don’t need to be able to read a path and understand what it will draw, having a basic understanding of what a `VectorDrawable` is doing is extremely helpful and necessary for understanding some of the advanced features we’ll get to later.

Paths by themselves don’t draw anything, they need to be stroked and/or filled.

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

    <path
      android:pathData="..."
      android:fillColor="#ff00ff"
      android:strokeColor="#999"
      android:strokeWidth="2"
      android:strokeLineCap="square" />

</vector>
```

Part 2 of this series goes into more detail on the different ways of filling/stroking paths.

You can also define groups of paths. This allows you to define transformations that will be applied to all paths within the group.

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

    <path .../>

    <group
        android:name="foo"
        android:pivotX="12"
        android:pivotY="0"
        android:rotation="45"
        android:scaleX="1.2"
        android:translateY="-4">

        <path ... />

    </group>

</vector>
```

Note that you can’t rotate/scale/translate individual paths. If you want this behavior you’ll need to place them in a group. These transformation make little sense for static images which could ‘bake’ them into their paths directly — but they are extremely useful for animating.

You can also define `clip-path`s, that is mask the area that other paths _in the same group_ can draw to. They’re defined exactly the same way as `path`s.

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>
  
  <clip-path
    android:name="mask"
    android:pathData="..." />

  <path .../>

</vector>
```

One limitation of note is that clip-paths are not anti-aliased.

![](https://cdn-images-1.medium.com/max/800/1*mfAEoYPOzVBf2Ne2-lKE3w.png)

Demonstrating non-anti-aliased clip path

This example (which I’ve had to enlarge greatly to show the effect) shows two approaches for drawing a camera shutter icon. The first draws the paths, the second draws a solid square, masked to the shutter shape. Masking can help to create interesting effects (especially when animated) but it’s relatively expensive so if you can avoid it by drawing a shape in a different way, then do.

Paths can be trimmed; that is only draw a subset of the entire path. You can trim filled paths but the results can be surprising! It’s more common to trim stroked paths.

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector...>

  <path
    android:pathData="..."
    android:trimPathStart="0.1"
    android:trimPathEnd="0.9" />

</vector>
```

![](https://cdn-images-1.medium.com/max/800/1*7BaeX8n1mu2j7UTMRq-cLA.gif)

Trimming paths

You can trim either from the start, or end of a path or apply an offset to any trims. They are defined as a fraction of the path [0,1]. See how setting different trim values changes the portion of the line that is drawn. Also note that offsets can make the trim values ‘wrap around’. Once again, this property doesn’t make much sense for static images but is handy for animation.

The root `vector` element supports an `alpha` property [0, 1]. Groups do not have an alpha property but individual paths support `fillAlpha`/`strokeAlpha`.

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...
  android:alpha="0.7">

  <path
    android:pathData="..."
    android:fillColor="#fff"
    android:fillAlpha="0.5" />

</vector>
```

### Declare Independence

So hopefully this post gives you an idea of what vector assets are, their benefits and trade-offs. Android’s vector format is capable and has widespread support. Given the variety of devices in the market, using vector assets should be your default choice, only resorting to rasters in special cases. Join us in the next posts to learn more:

_Coming soon: Draw a Path  
Coming soon: Creating vector assets for Android  
Coming soon: Using vector assets in Android apps  
Coming soon: Profiling Android `VectorDrawable`s_

Thanks to [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page), [Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_page), and [Chris Banes](https://medium.com/@chrisbanes?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
