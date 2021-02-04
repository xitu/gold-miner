> * 原文地址：[4 CSS Filters For Adjusting Color](https://vanseodesign.com/css/4-css-filters-for-adjusting-color/)
> * 原文作者：[Steven Bradley](https://www.vanseodesign.com/about/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/4-css-filters-for-adjusting-color.md](https://github.com/xitu/gold-miner/blob/master/TODO1/4-css-filters-for-adjusting-color.md)
> * 译者：[iceytea](https://github.com/iceytea)
> * 校对者：[lgh757079506](https://github.com/lgh757079506), [Baddyo](https://github.com/Baddyo)

# 4 个 CSS 调色滤镜

SVG 提供了一种非破坏性的方式来更改图像或图形的某些颜色属性。但不幸的是，有一些更改实现起来比较麻烦。CSS 滤镜允许你以非破坏性的方式更改某些颜色属性，并且比 SVG 滤镜更简单。

过去几周里，我一直把 CSS 滤镜作为 SVG 滤镜的备选方案来探讨。首先我[大体介绍了一下滤镜](http://vanseodesign.com/css/css-filters-introduction/)，并展示了滤镜函数 blur() 的示例；然后我介绍了 [url() 和 drop-shadow() 滤镜函数](http://vanseodesign.com/css/drop-shadow-filter/)并分别提供了示例。

今天我想带你了解另外四个 CSS 滤镜函数，这些函数都是 SVG 滤镜函数 feColorMatrix 不同类型和值的快捷方式。

## feColorMatrix

feColorMatrix 可以作为更改元素中某些[颜色基本属性](http://vanseodesign.com/web-design/hue-saturation-and-lightness/)的一般方法。顾名思义，它通过使用值矩阵来为元素添加不同的滤镜效果。

CSS 中有四个不同的滤镜函数，它们可以复制使用 [feColorMatrix](http://vanseodesign.com/web-design/svg-filter-primitives-fecolormatrix/) 创建的效果。这有力地证明了，单个 SVG 滤镜比任何一个单独的 CSS 滤镜函数都要强大。

以下是那四个 CSS 滤镜：

- grayscale();
- hue-rotate();
- saturate();
- sepia();

那就让我们依次探究这些 CSS 滤镜函数，用它们为这张熟悉的（如果你一直在关注本系列文章的话）图片改变颜色吧。

![strawberry.jpg](https://i.loli.net/2019/06/11/5cfe904a4ed7316962.jpg)

## grayscale()

grayscale() 将图像转换为灰度图像。

```
grayscale() = grayscale( [ <number> | <percentage> ] )
```

你可以通过提供介于 0.0 和 1.0 之间的数字或 0% 到 100% 之间的百分比来确定转换图像的比例。100%（或 1.0）将图像完全转换为[灰度](http://vanseodesign.com/web-design/luminance-working-in-grayscale/)图像，0%（或 0.0）不会转换图像。0.0 到 1.0（或 0% 到 100%）之间的值是效果的线性乘数。不允许使用负值。

在第一个例子中，我给滤镜函数传入了值 1，给图片赋予了 100% 灰度的效果。

```css
.strawberry {
 filter: grayscale(1);
}
```

原始图像包含大量灰色，但我认为你依然可以看到滤镜的效果，因为现在所有彩色都已被擦除。

![](https://i.loli.net/2019/06/11/5cfe8f0c2a04c14602.jpg)

为了比较，我在下面列出了与滤镜函数等效的矩阵实现方式。公平地说，使用 feColorMatrix 来删除彩色的更简便方法，是把 type 属性设置为 saturate。我稍后会告诉你的。

```html
<filter id="grayscale">
 <feColorMatrix type="matrix"
    values="(0.2126 + 0.7874 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0
            (0.2126 - 0.2126 * [1 - amount]) (0.7152 + 0.2848 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0
            (0.2126 - 0.2126 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 + 0.9278 * [1 - amount]) 0 0 0 0 0 1 0"/>
</filter>
```

尽管如此，这个示例仍是 CSS 滤镜功能更易用的有力佐证。使用这个特定矩阵，只是因为我在网上看到了该方法的一个应用示例。我不需要在滤镜函数中搜索值 1。

## hue-rotate()

hue-rotate() 按指定的量更改元素中每个像素的色调。

```
hue-rotate() = hue-rotate( <angle> )
```

参数 angle（角度）以度为单位，你需要将单位指定为 deg。0deg 使元素保持不变，360deg 的任意倍数（720deg、1080deg、1440px 等）也是如此。

在这个例子中，我将色相旋转了 225 度。

```css
.strawberry {
 filter: hue-rotate(225deg);
}
```

该值将原本是红色和黄色的花色，变得更加偏向粉色、紫色和蓝色。

![](https://i.loli.net/2019/06/11/5cfe8f0c2bf0c97252.jpg)

这是用于比较的 SVG 滤镜。相比之下，CSS 滤镜仍然更简单，但在这种情况下的差距不大。

```html
<filter id="hue-rotate">
 <feColorMatrix type="hueRotate" values="225"/>
</filter>
```

## saturate()

CSS 还提供了 saturate()，可用于提高或降低元素颜色的饱和度。

```
saturate() = saturate( [ <number> | <percentage> ] )
```

与灰度函数一样，该函数的参数值定义了转换的比例。0%（或 0.0）使元素完全去饱和，100%（1.0）使元素保持不变。0 到 100 之间的值是效果的线性乘数。

在这里，我将元素设置为 50% 饱和度。

```css
.strawberry {
 filter: saturate(0.5);
}
```

这生成了下面的图像效果。

![](https://i.loli.net/2019/06/11/5cfe8f0c2dd0b48070.jpg)

saturate() 不允许使用负值，但你可以设置大于 100% 或 1.0 的值使元素过饱和。下面是同一张图片施加 900% 饱和度的效果（`filter: saturate(9);`）。

![](https://i.loli.net/2019/06/11/5cfe8f0d1d1d649096.jpg)

和 saturate() 对应的 SVG 滤镜也很简单。

```html
<filter id="saturate">
 <feColorMatrix type="saturate" values="0.5"/>
</filter>
```

在之前我曾经提到，用 feColorMatrix 来创建灰度图像，有一种更简单的方式，那就是把 type 属性设为 saturate。你所要做的就是将值设置为 0 以使图像完全去饱和，这与将其设置为 `saturate(100%)` 相同。

## sepia()

最后是 sepia()，它将图像转换为棕褐色。

```
sepia() = sepia( [ <number> | <percentage> ] )
```

现在你应该很熟悉这种写法了。这里的值定义了转换比例，100%（1.0）展现为完全棕褐色，0%（0.0）使图像效果保持不变。从 0% 到 100%，效果线性增强。

这个函数不允许使用负值，你可以设置大于 100%（1.0）的值，但效果不会继续增强。

这里我将 sepia 设为 75%：

```css
.strawberry {
 filter: sepia(75%);
}
```

下图是滤镜的效果展示：

![5.jpg](https://i.loli.net/2019/06/11/5cfe8f0d12a1a21806.jpg)

feColorMatrix 不支持棕褐色效果模式。如果要获得相同的棕褐色效果，你需要使用另一个模型。

```html
<filter id="sepia">
 <feColorMatrix type="matrix"
    values="(0.393 + 0.607 * [1 - amount]) (0.769 - 0.769 * [1 - amount]) (0.189 - 0.189 * [1 - amount]) 0 0
            (0.349 - 0.349 * [1 - amount]) (0.686 + 0.314 * [1 - amount]) (0.168 - 0.168 * [1 - amount]) 0 0
            (0.272 - 0.272 * [1 - amount]) (0.534 - 0.534 * [1 - amount]) (0.131 + 0.869 * [1 - amount]) 0 0 0 0 0 1 0"/>
</filter>
```

我认为，在达成相同效果上，SVG 可以为你提供更大的灵活性，CSS 滤镜函数更简单。

## 结论

上面提到的这四个 CSS 滤镜函数都是 feColorMatrix 的快捷方式。其中有两个（`grayscale()` 和 `sepia()`）替换了复杂矩阵，另外两个替换了特定类型的函数。

我希望你能了解到这四个滤镜函数都简单易用好理解。但恐怕你在使用这些函数调整图像图形参数时，还是会遇到一些困难。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
