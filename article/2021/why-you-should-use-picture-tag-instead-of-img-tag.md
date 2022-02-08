> * 原文地址：[Why You Should Use Picture Tag Instead of  Img Tag](https://blog.bitsrc.io/why-you-should-use-picture-tag-instead-of-img-tag-b9841e86bf8b)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-you-should-use-picture-tag-instead-of-img-tag.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-you-should-use-picture-tag-instead-of-img-tag.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：[Usualminds](https://github.com/Usualminds)、苏苏的 [霜羽 Hoarfroster](https://github.com/PassionPenguin)

# 为什么你应该使用 Picture 标签而不是 Img 标签

![](https://cdn-images-1.medium.com/max/5760/1*Sv9aXzgr2N6IiblcW_lFPg.jpeg)

现代 web 应用程序中，在用户界面中使用大量图片和动画是一件很常见的事情。这些现代设计聚焦于提升应用的用户体验，但是如果没有做好设备对图片的响应式支持，其效果可能适得其反。

作为开发者，我们需要完成所有的需求。但是，在大多数情况下，我们可能会错过一些能产生巨大影响的细节，因为我们是以一个更高的视角来解决问题。

选择 `picture` 还是 `img` 标签就是这么一个小细节，如果你做出了正确的选择，那么就可以同时提升用户体验和应用性能。

本文接下来会讨论 `picture` 与 `img` 标签之间的差异，以及 `picture` 标签优于  `img` 标签之处。

## 为什么 Img 标签不能满足现代 web 应用的需求？

众所周知，`img` 标签在很长的一段的时期内都是 HTML 的核心标签之一，这毫无疑问是因为它的简单和易用。

> **然而，屏幕尺寸和分辨率的发展以及复杂的用户需求，让 `img` 标签在响应式和跨设备应用程序的使用中出现了一些问题。**

所有的问题都可以被归结为两个主要方面：

1. 分辨率切换（Resolution Switching）—— 如何为窄屏设备提供较小尺寸的图片。
2. 美术设计（Art Direction）—— 如何为不同尺寸的屏幕显示不同的图片。

现在，让我们来看看如何解决上述问题，并了解下 `picture` 标签的额外功能。

## 使用 srcset 和 sizes 属性实现分辨率切换

正如我先前提到的，现代的 web 设计师经常使用高分辨率的图像来吸引用户的注意力。但是作为开发者，我们必须谨慎地选择合适的 HTML 元素。

> **假设你对高分辨率图片使用了 `img` 标签。在这种情况下，相同的图片会在运行了该应用程序的每个设备上应用，并且会影响低分辨率设备（如：移动设备）的性能。**

这个可能会导致更长的图片加载时间以及自上而下的图片逐部分加载。

![Top to bottom image loading issue](https://cdn-images-1.medium.com/max/2000/1*Atpq5fQFaAWBzVRgsMt75w.gif)

通过使用 `picture` 标签的 `srcset` 和 `sizes` 属性，可以轻松的解决这个问题。

```html
<picture>

   <source

      srcset="small-car-image.jpg 400w,
              medium-car-image.jpg 800w,
              large-car-image.jpg 1200w"

      sizes="(min-width: 1280px) 1200px,
             (min-width: 768px) 400px,
             100vw">

   <img src="medium-car-image.jpg" alt="Car">

</picture>
```

`srcset` 属性接受多个带有宽度像素值的图片，浏览器根据这些像素值来选择要显示的图片。在上面的例子中，为相同的图片提供了 3 个不同大小的版本。

`sizes` 属性定义了图片在屏幕上会占据的空间大小。在上面的例子中，如果屏幕的最小尺寸是 1280px ，则图像会占据 1200px 的宽度。

> **话虽如此，最好不要只因为分辨率切换就使用 picture 标签，因为现在的 img 标签也能做到同样的事情（并且有更多的浏览器支持）。**

```html
<img srcset="small-car-image.jpg 400w,
             medium-car-image.jpg 800w,
             large-car-image.jpg 1200w"

     sizes="(min-width: 1280px) 1200px,
            (min-width: 768px) 400px,
            100vw"
     
     src="medium-car-image.jpg" alt="Car">
```

然而，在大多数情况下，我们需要同时处理分辨率切换和美术设计，那么 `picture` 标签就是最好的选择。

所以，让我们来看看如何使用 `picture` 标签来实现美术设计。

## 使用 media 属性实现美术设计

美术设计背后的主要思想是，基于设备的屏幕尺寸显示不同的图片。在大多数情况下，一张在大屏设备上看起来很好的图，会在当你切换到移动设备时被裁剪或者看起来很小。

> **我们可以通过为不同的屏幕尺寸提供图片的不同版本来解决这个问题。这些不同的版本可以是横向的、纵向的、或者同一图像的任意自定义版本。**

使用 `picture` 标签，并在其中使用多个 `source` 标签，我们可以轻松的处理分辨率切换。

```html
<picture>
   
   <source ....>
   <source ....>
   <source ....>

</picture>
```

接着，我们可以使用 `media` 属性来定义这些 `source` 标签会被使用的情况（媒体条件）。我们也可以用类似于上一节讨论的方式那样来使用 `srcset` 和 `sizes` 属性。

下面的代码是将 `picture` 标签用于美术设计和分辨率切换的示例。

```html
<picture>
     
   <source media="(orientation: landscape)"
             
      srcset="land-small-car-image.jpg 200w,
              land-medium-car-image.jpg 600w,
              land-large-car-image.jpg 1000w"
             
      sizes="(min-width: 700px) 500px,
             (min-width: 600px) 400px,
             100vw">
     
   <source media="(orientation: portrait)"
             
      srcset="port-small-car-image.jpg 700w,
              port-medium-car-image.jpg 1200w,
              port-large-car-image.jpg 1600w"
             
      sizes="(min-width: 768px) 700px,
             (min-width: 1024px) 600px,
             500px">
     
   <img src="land-medium-car-image.jpg" alt="Car">

</picture>
```

如果屏幕方向是水平时，浏览器会从第一个图片集（srcset）中显示图片。而当屏幕方面是竖直时，浏览器会使用第二个图片集（srcset）。除此之外，你也可以在 `media` 属性中设置 `max-width` 和 `min-width` 参数：

```html
<picture>
     <source media="(max-width: 767px)" ....>
     <source media="(min-width: 768px)" ....>
</picture>
```

最后的 `img` 标签是用来向后兼容那些不支持 `picture` 标签的浏览器。

## 实现图像格式切换

随着科技的快速发展，每天都会产生不同的现代图片格式。其中一些格式，如：`webp`、`svg` 以及 `avif` 可以提供更好的用户体验。

另一方面，一些浏览器不支持这些现代图像格式。如果我们不使用兼容的图像格式，有时就会适得其反。

> **我们可以轻松的解决这个问题，因为 picture 标签支持我们在其中使用多个 source。**

```html
<picture>

  <source srcset="test.avif" type="image/avif">
  <source srcset="test.webp" type="image/webp">
  <img src="test.png" alt="test image">

</picture>
```

上面的例子包含了 `avif`、`webp` 和 `png` 三种图像格式。首先，浏览器会尝试加载 `avif` 格式。如果失败了，浏览器会接着尝试 `webp` 格式。如果这两种格式都不支持，浏览器就会使用 `png` 格式的图片。

> **当 Chrome 声明其浏览器开发者工具（DevTools）将会在渲染选项卡（Rendering）中提供两种新的模拟方式以模拟部分支持的图像类型时，有关 `picture` 标签的事情开始变得有趣起来了。**

从 Chrome 88 开始，你可以使用其浏览器开发者工具（DevTools）来检查浏览器对于图像格式的兼容情况。

![Using Chrome DevTools for Image Compatibility Emulations](https://cdn-images-1.medium.com/max/2562/1*GAFavZjkfi4FUDRkkPMA4Q.png)

## 总结

虽然我们讨论了为什么 `picture` 标签相比 `img` 标签更好。但是，我必须声明的是， `img` 标签并没有消亡，短期内也不会。

如果我们能有效的使用 `srcset` 和 `sizes` 等属性，我们就能最大限度的用好 `img` 标签。比如，我们能仅使用 `img` 标签来实现分辨率切换。

另一方面，我们可以借助 `picture` 标签使用媒体查询和其他的属性来轻松解决分辨率切换和美术设计。

适配图像格式切换与 Chrome DevTools 对其的支持都可以被视为 `picture` 标签的优势。

这两个标签各有利弊。所以，我们必须仔细思考并基于我们的需求使用最合适的标签。

感谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
