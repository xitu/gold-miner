> * 原文地址：[4 CSS Filters For Adjusting Color](https://vanseodesign.com/css/4-css-filters-for-adjusting-color/)
> * 原文作者：[Steven Bradley](https://www.vanseodesign.com/about/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/4-css-filters-for-adjusting-color.md](https://github.com/xitu/gold-miner/blob/master/TODO1/4-css-filters-for-adjusting-color.md)
> * 译者：
> * 校对者

# 四个调色的 CSS 滤镜

SVG offers a non-destructive way to change some color properties of an image or graphic. Unfortunately some of those changes are more cumbersome to make than others. CSS filters allow you to non-destructively change some properties of color as well and in a less cumbersome way than SVG.

SVG提供了一种非破坏性的方式来更改图像或图形的某些颜色属性。 不幸的是，其中一些变化比其他变化更麻烦。 CSS过滤器允许您以非破坏性的方式更改某些颜色属性，并且比SVG更简单。

The last couple of weeks I've been talking about CSS filters as an alternative to SVG filters. First I offered [an introduction](http://vanseodesign.com/css/css-filters-introduction/) and showed you an example of the blur() filter-function and then I walked through the [url() and drop-shadow() filter-functions](http://vanseodesign.com/css/drop-shadow-filter/) and provided examples for each.

过去几周我一直在谈论CSS过滤器作为SVG过滤器的替代品。 首先我提供[介绍]（http://vanseodesign.com/css/css-filters-introduction/）并向您展示了blur（）过滤器函数的示例，然后我走过了[url（）并放弃了 -shadow（）filter-functions]（http://vanseodesign.com/css/drop-shadow-filter/）并为每个提供了示例。

Today I want to walk you through four more CSS filter-functions all of which are shortcuts to different types and values of the SVG filter primitive feColorMatrix.

今天我想引导您完成另外四个CSS过滤器函数，所有这些函数都是SVG过滤器基元feColorMatrix的不同类型和值的快捷方式。

## The feColorMatrix Filter Primitive

## feColorMatrix过滤器原语

The feColorMatrix primitive can be used as a general way to change some of the [fundamental properties of color](http://vanseodesign.com/web-design/hue-saturation-and-lightness/) in an element. As the name implies, the primitive makes use of a matrix of values to add different filter effects.

feColorMatrix原语可用作更改元素中某些[颜色的基本属性]（http://vanseodesign.com/web-design/hue-saturation-and-lightness/）的一般方法。 顾名思义，基元使用值矩阵来添加不同的滤镜效果。

Four different CSS filter-functions exist to replicate effects you can create with [feColorMatrix](http://vanseodesign.com/web-design/svg-filter-primitives-fecolormatrix/). It's one example where a single SVG primitive can do more than any one CSS filter-function.

存在四种不同的CSS过滤器函数来复制您可以使用[feColorMatrix]（http://vanseodesign.com/web-design/svg-filter-primitives-fecolormatrix/）创建的效果。 这是一个示例，其中单个SVG基元可以比任何一个CSS过滤器功能做得更多。

Here are the four CSS filters.

以下是四个CSS过滤器。

- grayscale();
- hue-rotate();
- saturate();
- sepia();

Let's walk through each of them and change the colors of what is likely a familiar image, if you've been following along with this series.

如果您一直关注这个系列，那么让我们一起浏览每一个并改变可能是熟悉图像的颜色。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

## The grayscale() filter-function

##灰度（）滤镜功能

The grayscale() filter-function converts an image to grayscale.

灰度（）滤镜功能将图像转换为灰度。

```
grayscale() = grayscale( [ <number> | <percentage> ] )
```

You determine the proportion to convert the image by supplying either a percentage or a number between 0.0 and 1.0. 100% (or 1.0) is full conversion to [grayscale](http://vanseodesign.com/web-design/luminance-working-in-grayscale/) and 0% (or 0.0) leads to no conversion. Values between 0.0 and 1.0 or 0% and 100% are linear multipliers of the effect. Negative values are not allowed.

您可以通过提供介于0.0和1.0之间的百分比或数字来确定转换图像的比例。 100％（或1.0）完全转换为[灰度]（http://vanseodesign.com/web-design/luminance-working-in-grayscale/），0％（或0.0）导致无转换。 0.0和1.0或0％和100％之间的值是效果的线性乘数。 不允许使用负值。

In this first example I applied 100% grayscale to my Strawberry Fields image using the value 1 in the filter-function.

在第一个例子中，我使用过滤器函数中的值1将100％灰度应用于我的草莓字段图像。

```css
.strawberry {
 filter: grayscale(1);
}
```

The original image contains a lot of gray as it is, but I think you can see the effect of the filter as now all color has been removed.

原始图像包含大量灰色，但我认为您可以看到过滤器的效果，因为现在所有颜色都已被删除。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

For comparison here's the matrix the filter-function replaces. To be fair there's an easier way to use feColorMatrix to remove color by setting the type attribute to saturate. I'll show you that in a bit.

为了比较，这里是滤波器函数替换的矩阵。 公平地说，通过将type属性设置为饱和，可以更轻松地使用feColorMatrix来删除颜色。 我稍后会告诉你的。

```html
<filter id="grayscale">
 <feColorMatrix type="matrix"
    values="(0.2126 + 0.7874 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0
            (0.2126 - 0.2126 * [1 - amount]) (0.7152 + 0.2848 * [1 - amount]) (0.0722 - 0.0722 * [1 - amount]) 0 0
            (0.2126 - 0.2126 * [1 - amount]) (0.7152 - 0.7152 * [1 - amount]) (0.0722 + 0.9278 * [1 - amount]) 0 0 0 0 0 1 0"/>
</filter>
```

Still, this is definitely a case where the CSS filter-function is a lot easier to use. The only reason I knew to use this particular matrix is because I found an example using it online. I didn't need to search for the value 1 in the filter-function.

尽管如此，这肯定是CSS过滤器功能更容易使用的情况。 我知道使用这个特定矩阵的唯一原因是因为我找到了一个在线使用它的例子。 我不需要在filter-function中搜索值1。

## The hue-rotate() filter-function

## hue-rotate（）过滤器函数

The hue-rotate() filter-function changes the hue of every pixel in the element by the amount you specify.

hue-rotate（）过滤器函数按指定的量更改元素中每个像素的色调。

```
hue-rotate() = hue-rotate( <angle> )
```

The angle is set in degrees and you do need to specify the units as deg. An angle of 0deg leaves the element unchanged as does a any multiple of 360deg (720deg, 1080deg, 1440px, etc.).

In this example I rotated the hue 225 degrees.

角度以度为单位，您需要将单位指定为deg。 0deg的角度使元素保持不变，360deg的任意倍数（720deg，1080deg，1440px等）也是如此。

在这个例子中，我将色调旋转了225度。

```css
.strawberry {
 filter: hue-rotate(225deg);
}
```

The value turns the red and yellow flowers into flowers that contain more pinks, purples, and blues.

该值将红色和黄色的花朵变成含有更多粉红色，紫色和蓝色的花朵。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Here's the SVG filter for comparison. The CSS is still simpler, however in this case, not by a lot.

这是用于比较的SVG过滤器。 CSS仍然更简单，但在这种情况下，不是很多。

```html
<filter id="hue-rotate">
 <feColorMatrix type="hueRotate" values="225"/>
</filter>
```

## The saturate() filter-function

CSS also provides a saturate() filter-function that you can use to saturate or desaturate an element.

CSS还提供了saturate（）过滤器函数，可用于使元素饱和或去饱和。

```
saturate() = saturate( [ <number> | <percentage> ] )
```

As with the grayscale function, the value defines the proportion of the conversion. 0% (or 0.0) results in a completely desaturated element and 100% (1.0) leaves the element unchanged. Values in between are linear multipliers of the effect.

Here I set the filter to 50% saturation.

与灰度函数一样，该值定义了转换的比例。 0％（或0.0）导致完全去饱和元素，100％（1.0）导致元素保持不变。 中间的值是效果的线性乘数。

在这里，我将滤镜设置为50％饱和度。

```css
.strawberry {
 filter: saturate(0.5);
}
```

Which results in the image below.

这导致下面的图像。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Negative values are not allowed, but you can can provide values greater than 100% or 1.0 to super-saturate the element. Here's the image again with 900% saturation applied ( filter:saturate(9); ).

不允许使用负值，但您可以提供大于100％或1.0的值以使元素超饱和。 这是再次施加900％饱和度的图像（滤波器：饱和（9）;）。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

Like saturate(), the corresponding SVG filter is relatively simple.

像saturate（）一样，相应的SVG滤波器相对简单。

```html
<filter id="saturate">
 <feColorMatrix type="saturate" values="0.5"/>
</filter>
```

I mentioned earlier that you can set the type attribute to saturate for a simpler way to use feColorMatrix to create a grayscale image. All you have to do is set the value to 0 to completely desaturate the image, which produces the same as setting it to 100% grayscale.

我前面提到过你可以设置type属性以使用更简单的方法来使用feColorMatrix来创建灰度图像。 您所要做的就是将值设置为0以使图像完全去饱和，这与将其设置为100％灰度相同。

## The sepia() filter-function

Finally there's the sepia() filter-function, which converts an image to sepia.

最后是sepia（）过滤器函数，它将图像转换为棕褐色。

```
sepia() = sepia( [ <number> | <percentage> ] )
```

This should be familiar by now, but the value defines the proportion of the conversion. 100% (1.0) is completely sepia while 0% (0.0) leaves the image unchanged and values in between are linear multipliers of the effect.

Negative values are not allowed. You can supply a value greater than 100% or 1.0, but it won't increase the effect.

Here I set the sepia function to 75%

现在这应该是熟悉的，但是值定义了转换的比例。 100％（1.0）完全是棕褐色，而0％（0.0）使图像保持不变，其间的值是效果的线性乘数。

不允许使用负值。 您可以提供大于100％或1.0的值，但不会增加效果。

在这里我将sepia功能设置为75％

```css
.strawberry {
 filter: sepia(75%);
}
```

And here's how it looks.

而这就是它的外观。

![](http://www.vanseodesign.com/blog/wp-content/uploads/2013/09/strawberry-fields.jpg)

There is no sepia type for feColorMatrix so to get the same sepia effect you need to use another matrix.

feColorMatrix没有棕褐色类型，所以要获得相同的棕褐色效果，您需要使用另一个矩阵。

```html
<filter id="sepia">
 <feColorMatrix type="matrix"
    values="(0.393 + 0.607 * [1 - amount]) (0.769 - 0.769 * [1 - amount]) (0.189 - 0.189 * [1 - amount]) 0 0
            (0.349 - 0.349 * [1 - amount]) (0.686 + 0.314 * [1 - amount]) (0.168 - 0.168 * [1 - amount]) 0 0
            (0.272 - 0.272 * [1 - amount]) (0.534 - 0.534 * [1 - amount]) (0.131 + 0.869 * [1 - amount]) 0 0 0 0 0 1 0"/>
</filter>
```

I take it you agree that using the CSS filter-function is again the easier of the two options, even if the SVG offers greater flexibility in what you can do.

我认为，即使SVG在您可以做的事情上提供更大的灵活性，使用CSS过滤器功能也是两个选项中更容易的选择。

## Closing Thoughts

##结束思考

All four of the CSS filter-functions I walked through today are shortcuts for the feColorMatrix filter primitive. Two of them replace complicated matrices and the other two replace a specific type of the primitive.

I hope you agree that all four of these filter-functions are easy enough to understand and use. I doubt you'll have much difficulty working with them or figuring out what values to use to adjust your images and graphics.

我今天走过的所有四个CSS过滤器函数都是feColorMatrix过滤器原语的快捷方式。 其中两个替换复杂的矩阵，另外两个替换特定类型的基元。

我希望您同意所有这四个过滤器功能都很容易理解和使用。 我怀疑你在使用它们或找出用于调整图像和图形的值时会遇到很多困难。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
