> * 原文地址：[An Introduction to CSS Shapes](https://tympanus.net/codrops/2018/11/29/an-introduction-to-css-shapes/)
> * 原文作者：[Tania Rascia](https://tympanus.net/codrops/author/taniarascia/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-css-shapes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-css-shapes.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：

# An Introduction to CSS Shapes

# CSS Shapes 简介

CSS Shapes allow us to make interesting and unique layouts by defining geometric shapes, images, and gradients that text content can flow around. Learn how to use them in this tutorial.

CSS Shapes 允许我们通过定义文本内容可以环绕的几何形状、图像和渐变，来创建有趣且独特的布局。

![cssshapes_featured](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_featured-1.jpg)

Until the introduction of [CSS Shapes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Shapes), it was nearly impossible to design a magazine-esque layout with free flowing text for the web. On the contrary, web design layouts have traditionally been shaped with grids, boxes, and straight lines.

在 [CSS Shapes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Shapes) 问世之前，为网页设计文本自由环绕的杂志式布局几乎是不可能的。相反，网页设计布局传统上用网格、盒子和直线构造。

CSS Shapes allow us to define geometric shapes that text can flow around. These shapes can be circles, ellipses, simple or complex polygons, and even images and gradients. A few practical design applications of Shapes might be displaying circular text around a circular avatar, displaying text over the simple part of a full-width background image, and displaying text flowing around drop caps in an article.

CSS Shaptes 允许我们定义文本环绕的几何形状。这些形状可以是圆、椭圆、简单或复杂的多边形，甚至图像和渐变。Shapes 的一些实际设计应用可能是圆形头像周围显示圆形环绕文本，全屏背景图片的简单部分上面展示文本，以及在文章的下沉部分显示环绕文本。

Now that CSS Shapes have gained widespread support across modern browsers, it’s worth taking a look into the flexibility and functionality they provide to see if they might make sense in your next design project.

目前为止，CSS Shapes 已经在现代浏览器中得到了广泛支持，它的灵活性和提供的功能，值得你去看看它们是否能在你的下一个设计项目中使用。

> **Attention**: At the time of writing this article, [CSS Shapes](https://caniuse.com/#feat=css-shapes) have support in Firefox, Chrome, Safari, and Opera, as well as mobile browsers such as iOS Safari and Chrome for Android. Shapes do not have IE support, and are [under consideration](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/shapes/) for Microsoft Edge.

> **注意**：在攥写本文时，[CSS Shapes](https://caniuse.com/#feat=css-shapes) 支持 Firefox，Chrome，Safari 和 Opera，以及 iOS Safari 和 Chrome for Android 等移动浏览器。Shapes 不支持 IE，对 Microsoft Edge 的支持[正在考虑中](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/shapes/)。

## First Look at CSS Shapes

## CSS Shapes 概览

The current implementation of CSS Shapes is [CSS Shapes Module Level 1](https://drafts.csswg.org/css-shapes/), which mostly revolves around the `[shape-outside](https://tympanus.net/codrops/css_reference/shape-outside/)` property. `shape-outside` defines a shape that text can flow around.

CSS Shapes 的当前实现是 [CSS Shapes 模块 1 级](https://drafts.csswg.org/css-shapes/)，它主要包含 `[shape-outside](https://tympanus.net/codrops/css_reference/shape-outside/)` 属性。`shape-outside` 定义了文本环绕的形状。

Considering there is a `shape-outside` property, you might assume there is a corresponding `shape-inside` property that would contain text within a shape. A `shape-inside` property might become a reality in the future, but it is currently a draft in [CSS Shapes Module Level 2](https://drafts.csswg.org/css-shapes-2/), and is not implemented by any browser.

考虑到有 `shape-outside` 属性，你可能会想到还有一个相应的 `shape-inside` 属性，它包含形状内的文本。`shape-inside` 属性可能会在将来实现，目前它只是 [CSS Shapes 模块 2 级](https://drafts.csswg.org/css-shapes-2/)里面的一个草案，并没有被任何浏览器实现。

In this article, we’re going to demonstrate how to use the [<basic-shape>](https://tympanus.net/codrops/css_reference/basic-shape/) data type and set it with shape function values, as well as setting a shape using a semi-transparent URL or gradient.

在本文中，我们将演示如何使用 [<basic-shape>](https://tympanus.net/codrops/css_reference/basic-shape/) 数据类型，使用形状函数值设置它，以及使用半透明URL或渐变设置形状。

## Basic Shape Functions

## 基本的形状函数

We can define all sorts of Basic Shapes in CSS by applying the following function values to the `shape-outside` property:

我们可以通过将下列函数值应用于 `shape-outside` 属性来定义 CSS 中的各种基本形状：

*   `circle()`
*   `ellipse()`
*   `inset()`
*   `polygon()`

In order to apply the `shape-outside` property to an element, the element must be floated, and have a defined height and width. Let’s go through each of the four basic shapes and demonstrate how they can be used.

要给元素设定 `shape-outside` 属性，该元素必须是浮动并且已设定宽高。让我们逐个来看四个基本形状，并演示它们的使用方法。

### Circle

### 圆

We’ll start with the `circle()` function. Imagine a situation in which we have a circular avatar of an author that we want to float left, and we want the author’s description text to flow around it. Simply using a `border-radius: 50%` on the avatar element won’t be enough to get the text to make a circular shape; the text will still treat the avatar as a rectangular element.

我们将从 `circle()` 函数开始。设想如下场景，有一个作者的圆形头像，我们想让头像左浮动并且作者的描述文本环绕它。仅对头像元素使用 `border-radius: 50%` 不足以使文本呈圆形；文本仍将把头像当成矩形元素。

With the circle shape, we can demonstrate how text can flow around a circle.

通过圆形，我们可以演示文本如何按圆环绕。

We’ll start by creating a `circle` class on a regular `div`, and making some paragraphs. (I used Bob Ross quotes as Lorem Ipsum text.)

首先我们在一个普通的 `div` 上创建一个 `circle` 样式，并且写一些句子。（我使用 Bob Ross 语录作为 Lorem Ipsum 文本）

```
<div class="circle"></div>
<p>Example text...</p>
```

In our `circle` class, we float the element left, give it an equal `height` and `width`, and set the `shape-outside` to `circle()`.

在 `circle` 样式里，我们设置元素左浮动，设定等值的 `height` 和 `width`，并且设置 `shape-outside` 为 `circle()`。

```
.circle {
  float: left;
  height: 200px;
  width: 200px;
  shape-outside: circle();
}
```

If we view the page, it will look like this.

如果我们访问页面，会看到如下场景。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle1.jpg)

As you can see, the text flows around the circle shape, but we don’t actually see any shape. Hovering over the element in Developer Tools will show us the actual shape that is being set.

如你所见，文本围绕圆形环绕，但是我们并没有看到任何形状。使用开发工具审查元素，我们可以看到已经设置好的实际形状。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle2.jpg)

At this point, you might assume that you can set a `background` color or image to the element, and you’ll see the shape. Let’s try that out.

此时，你可能会认为，给元素 `background` 设置颜色或者图片就能看到形状了。我们来试一下。

```
.circle {
  float: left;
  height: 200px;
  width: 200px;
  shape-outside: circle();
  background: linear-gradient(to top right, #FDB171, #FD987D);
}
```

Frustratingly, setting a `background` to the `circle` just gives us a rectangle, the very thing we’ve been trying to avoid.

不幸的是，给 `circle` 设置 `background` 后会显示一个矩形，这是我们一直试图避免的事情。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle3.jpg)

We can clearly see the text flowing around it, yet the element itself doesn’t have a shape. If we want to actually display our shape functions, we’ll have to use the [`clip-path`](https://tympanus.net/codrops/css_reference/clip-path/) property. `clip-path` takes many of the same values as `shape-outside`, so we can give it the same `circle()` value.

我们可以清晰地看到文本在它周围环绕，但元素本身没有形状。如果我们想要实际显示形状函数，需要使用 [`clip-path`](https://tympanus.net/codrops/css_reference/clip-path/) 属性。`clip-path` 采用许多和 `shape-outside` 相同的值，因此我们可以给它同样的 `circle()` 值。

```
.circle {
  float: left;
  height: 200px;
  width: 200px;
  shape-outside: circle();
  clip-path: circle();
  background: linear-gradient(to top right, #FDB171, #FD987D);
}
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle4.jpg)

> For the rest of the article, I’ll use `clip-path` to help us identify the shapes.

> 在本文剩下的部分，我将使用 `clip-path` 帮助我们辨认形状。

The `circle()` function takes an optional parameter of radius. In our case, the default radius (_r_) is `50%`, or `100px`. Using `circle(50%)` or `circle(100px)` would produce the same result as what we’ve already done.  
You might notice the text is right up against the shape. We can use the [`shape-margin`](https://tympanus.net/codrops/css_reference/shape-margin/) property to add a margin to the shape, which can be set in `px`, `em`, `%`, and any other standard CSS unit of measurement.

`circle()` 函数接收可选的 radius 参数。在本例中，默认 radius 是 `50%` 或者 `100px`。使用 `circle(50%)` 或者 `circle(100px)` 都将产生和我们已经完成样例的同样结果。

你可能注意到文本刚好和形状贴合。我们可以使用 [`shape-margin`](https://tympanus.net/codrops/css_reference/shape-margin/) 属性给形状添加 margin，单位可以是 `px`、`em`、`%` 和其他标准的CSS测量单位。

```
.circle {
  float: left;
  height: 200px;
  width: 200px;
  shape-outside: circle(25%);
  shape-margin: 1rem;
  clip-path: circle(25%);
  background: linear-gradient(to top right, #FDB171, #FD987D);
}
```

Here is an example of a `25%` `circle()` radius with a `shape-margin` applied.

这里有个 `circle` radius 设置 `25%` 并且使用 `shape-margin` 的例子。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle5.jpg)

In addition to the radius, a shape function can take a position using `at`. The default position is the center of the circle, so `circle()` would explicitly be written as `circle(50% at 50% 50%)` or `circle(100px at 100px 100px)`, with the two values being the horizontal and vertical positions, respectively.

除了 radius，形状函数可以使用 `at` 定位。默认位置是圆心，因此 `circle()` 也可以被显式设置为 `circle(50% at 50% 50%)` 或 `circle(100px at 100px 100px)`，两个值分别是水平和垂直位置。

To make it obvious how the positioning works, we could set the horizontal position value to `0` to make a perfect semi-circle.

为了搞清楚 position 的作用，我们可以设置水平位置值为 `0` 来创造一个完美的半圆。

```
circle(50% at 0 50%);
```

This coordinate positioning system is known as the reference box.

该坐标定位系统称为引用框。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle6.jpg)

Later on, we’ll learn how to use an image instead of a shape or gradient. For now, we’ll move on the to the next shape function.

稍后，我们将学习如何使用图像代替形状或者渐变。现在，我们将继续进行下一个形状函数。

### Ellipse

### 椭圆

Similar to the `circle()` function is the `ellipse()`, which creates an oval. To demonstrate, we can create an `ellipse` element and class.

`ellipse()` 和 `circle()` 函数类似，只是它会创造椭圆。为了演示，我们创建一个 `ellipse` 元素和样式。

```
<div class="ellipse"></div>
<p>Example text...</p>
```

```
.ellipse {
  float: left;
  shape-outside: ellipse();
  clip-path: ellipse();
  width: 150px;
  height: 300px;
  background: linear-gradient(to top right, #F17BB7, #AD84E3);
}
```

This time, we set a different `height` and `width` to make a vertically elongated oval.

这次，我们设置不同的 `height` 和 `width` 创建一个垂直拉长的椭圆。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse1.jpg)

The difference between an `ellipse()` and a `circle()` is that an ellipse has two radii – _r_x and _r_y, or the X-axis radius and Y-axis radius. Therefore, the above example can also be written as:

`ellipse()` 和 `circle()` 的区别在于椭圆有两个 radii —— _r_x 和 ——r_y，或者 X-axis radius 和 Y-axis radius。因此，上面的例子也可以写成：

```
ellipse(75px 150px);
```

The position parameters are the same for circles and ellipses. The radii, in addition to being a unit of measurement, also include the options of `farthest-side` and `closest-side`.

circles 和 ellipses 的位置参数是一样的。除了是测量单位，radii 也包括 `farthest-side` 和 `closest-side` 的选项。

`closest-side` refers to the length from the center to closest side of the reference box, and conversely, `farthest-side` refers to the length from the center to the farthest side of the reference box. This means that these two values have no effect if a position other than default isn’t set.

`closest-side` 代表引用框的中心到最近测的长度，相反，`farthest-side` 代表引用框中心到最远测的长度。这意味着如果未设置默认值以外的位置，则这两个值无效

Here is a demonstration of the difference of flipping `closest-side` and `farthest-side` on an `ellipse()` with a `25%` offset on the X and Y axes.

这里演示了在 `ellipse()` 上翻转 `closest-side` 和 `farthest-side` 的区别，它的 X 和 Y 轴的偏移量是 `25%`。

```
ellipse(farthest-side closest-side at 25% 25%)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse2.jpg)

```
ellipse(farthest-side closest-side at 25% 25%)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse3.jpg)

### Inset

### 插入

So far we’ve been only been dealing with round shapes, but we can define inset rectangles with the `inset()` function.

目前为止我们只处理了圆形，但是我们可以使用 `inset()` 函数定义插入矩形。

```
<div class="inset"></div>
<p>Example text...</p>
```

```
.inset {
  float: left;
  shape-outside: inset(75px);
  clip-path: inset(75px);
  width: 300px;
  height: 300px;
  background: linear-gradient(#58C2ED, #1B85DC);
}
```

In this example, we’ll create a `300px` by `300px` rectangle, and inset it by `75px` on all sides. This will leave us with a `150px` by `150px` with `75px` of space around it.

在本例中，我们创造了一个 `300px` 的正方形，每条边插入 `75px`。这将给我们留下 `150px` 周围有 `75px` 空间。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset1.jpg)

We can see that the rectangle is inset, and the text ignores the inset area.

我们可以看到矩形是插入的，文本忽略了插入区域。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset2.jpg)

An `inset()` shape can also take a `border-radius` with the `round` parameter, and the text will respect the rounded corners, such as this example with a `25px` on all sides and `75px` rounding.

`inset()` 形状也可以使用 `round` 参数获取 `border-radius`，并且文本会识别圆角，就像本例中所有边都是 `25px` 及 `75px` 圆角。

```
inset(25px round 75px)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset3.jpg)

Like `padding` or `margin` shorthand, the inset value will accept `top` `right` `bottom` `left` values in clockwise order (`inset(25px 25px 25px 25px)`), and only using a single value will make all four sides the same (`inset(25px)`).

像 `padding` 或 `margin` 简写，inset 值以顺时针方式（`inset(25px 25px 25px 25px)`）接收 `top` `right` `bottom` `left`，并且只传一个值将使四条边都相同（`inset(25px)`）。

### Polygon

The most interesting and flexible of the shape functions is the `polygon()`, which can take an array of `x` and `y` points to make any complex shape. Each item in the array represents _x_i _y_i, and would be written as `polygon(x1 y1, x2 y2, x3 y3...)` and so on.

The fewest amount of point sets we can apply to a polygon is three, which will create a triangle.

```
<div class="polygon"></div>
<p>Example text...</p>
```

```
.polygon {
  float: left;
  shape-outside: polygon(0 0, 0 300px, 200px 300px);
  clip-path: polygon(0 0, 0 300px, 200px 300px);
  height: 300px;
  width: 300px;
  background: linear-gradient(to top right, #86F7CC, #67D7F5);
}
```

In this shape, the first point is `0 0`, the top left most point in the `div`. The second point is `0 300px`, which is the bottom left most point in the `div`. The third and final point is `200px 300px`, which is 2/3rd across the X axis and still at the bottom. The resulting shape looks like this:

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon1.jpg)

An interesting usage of the `polygon()` shape function is that text content can flow between two or more shapes. Since the `polygon()` shape is so flexible and dynamic, this is one of the biggest opportunities to make truly unique, magazine-esque layouts. In this example, we’ll put some text between two polygon shapes.

```
<div class="left"></div>
<div class="right"></div>
<p>Example text...</p>
```

```
.left {
  float: left;
  shape-outside: polygon(0 0, 0 300px, 200px 300px);
  clip-path: polygon(0 0, 0 300px, 200px 300px);
  background: linear-gradient(to top right, #67D7F5, #86F7CC);
  height: 300px;
  width: 300px;
}

.right {
  float: right;
  shape-outside: polygon(200px 300px, 300px 300px, 300px 0, 0 0);
  clip-path: polygon(200px 300px, 300px 300px, 300px 0, 0 0);
  background: linear-gradient(to bottom left, #67D7F5, #86F7CC);
  height: 300px;
  width: 300px;
}
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon2.jpg)

Obviously, it would be very difficult to try to create your own complex shapes manually. Fortunately, there are several tools you can use to create polygons. Firefox has a built in editor for shapes, which you can use by clicking on the polygon shape in the Inspector.

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon3.jpg)

And for now, Chrome has some extensions you can use, such as [CSS Shapes Editor](https://chrome.google.com/webstore/detail/css-shapes-editor/nenndldnbcncjmeacmnondmkkfedmgmp?hl=en-US).

Polygons can be used to cut out shapes around images or other elements. In another example, we can create a drop cap by drawing a polygon around a large letter.

```
<div class="letter">R</div>
<p>Example text...</p>
```

```
.letter {
  float: left;
  font-size: 400px;
  font-family: Georgia;
  line-height: .8;
  margin-top: 20px;
  margin-right: 20px;
  shape-outside: polygon(5px 14px, 233px 20px, 246px 133px, 189px 167px, 308px 304px, 0px 306px) content-box;
  clip-path: polygon(5px 14px, 233px 20px, 246px 133px, 189px 167px, 308px 304px, 0px 306px);
}
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon4.jpg)

## URLs

An exciting feature of CSS Shapes is that you don’t always have to explicitly define the shape with a shape function; you can also use a url of a semi-transparent image to define a shape, and the text will automatically flow around it.

It’s important to note that the image used must be [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) compatible, otherwise you’ll get an error like one below.

```
Access to image at 'file:///users/tania/star.png' from origin 'null' 
has been blocked by CORS policy: The response is invalid.
```

Serving an image on a server from the same server will ensure you don’t get that error.

Unlike in the other examples, we’re going to use an `img` tag instead of a `div`. This time the CSS is simple – just put the `url()` into the `shape-outside` property, like you would with `background-image`.

```
<img src="./star.png" class="star">
<p>Example text...</p>
```

```
.star {
  float: left;
  height: 350px;
  width: 350px;
  shape-outside: url('./star.png')
}
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_image1.jpg)

Since the image I used was a star with a transparent background, the text knew which areas were transparent and which were opaque, and aligned itself accordingly.

## Gradients

Finally, a gradient can also be used as a shape. Gradients are the same as images, and just like the image example we used above, the text will know to flow around the transparent part.

We’re going to use one new property with gradients – the [`shape-image-threshold`](https://tympanus.net/codrops/css_reference/shape-image-threshold/). The `shape-image-threshold` defines the alpha channel threshold of a shape, or what percent of the image can be transparent vs. opaque.

I’m going to make a gradient example that’s a 50%/50% split of a color and transparent, and set a `shape-image-threshold` of `.5`, meaning all pixels that are over 50% opaque should be considered part of the image.

```
<div class="gradient"></div>
<p>Example text...</p>
```

```
.gradient {
  float: left;
  height: 300px;
  width: 100%;
  background: linear-gradient(to bottom right, #86F7CC, transparent);
  shape-outside: linear-gradient(to bottom right, #86F7CC, transparent);
  shape-image-threshold: .5;
}
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_gradient1.jpg)

We can see the gradient is perfectly split diagonally at the center of opaque and transparent.

## Conclusion

In this article, we learned about `shape-outside`, `shape-margin`, and `shape-image-threshold`, three properties of CSS Shapes. We also learned how to use the function values to create circles, ellipses, inset rectangles, and complex polygons that text can flow around, and demonstrated how shapes can detect the transparent parts of images and gradients.

**You can find all examples of this article in the following [demo](http://tympanus.net/Tutorials/CSSShapes/). You can also [download the source files](http://tympanus.net/Tutorials/CSSShapes/CSSShapes.zip).**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
