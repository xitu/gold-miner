> * 原文地址：[An Introduction to CSS Shapes](https://tympanus.net/codrops/2018/11/29/an-introduction-to-css-shapes/)
> * 原文作者：[Tania Rascia](https://tympanus.net/codrops/author/taniarascia/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-css-shapes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-css-shapes.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：

# CSS Shapes 简介

CSS Shapes 允许我们通过定义文本内容可以环绕的几何形状、图像和渐变，来创建有趣且独特的布局。本次教程会教你如何使用它们。

![cssshapes_featured](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_featured-1.jpg)

在 [CSS Shapes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Shapes) 问世之前，为网页设计文本自由环绕的杂志式布局几乎是不可能的。相反，网页设计布局传统上一直用网格、盒子和直线构造。

CSS Shaptes 允许我们定义文本环绕的几何形状。这些形状可以是圆、椭圆、简单或复杂的多边形，甚至图像和渐变。Shapes 的一些实际设计应用可能是圆形头像周围显示圆形环绕文本，全屏背景图片的简单部位上面展示文本，以及在文章中显示首字下沉。

现在 CSS Shapes 已经获得了现代浏览器的广泛支持，值得一看的是它们提供的灵活性和功能，以确定它们在您的下一个设计项目中是否有意义。

> **注意**：截至攥写本文时，[CSS Shapes](https://caniuse.com/#feat=css-shapes) 支持 Firefox、Chrome、Safari 和 Opera，以及 iOS Safari 和 Chrome for Android 等移动浏览器。Shapes 不支持 IE，对 Microsoft Edge 的支持[正在考虑中](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/shapes/)。

## CSS Shapes 初探

CSS Shapes 的当前实现是 [CSS Shapes 模块 1 级](https://drafts.csswg.org/css-shapes/)，它主要包含 `[shape-outside](https://tympanus.net/codrops/css_reference/shape-outside/)` 属性。`shape-outside` 定义了文本环绕的形状。

考虑到有 `shape-outside` 属性，你可能会想到还有一个相应的 `shape-inside` 属性，它包含形状内的文本。`shape-inside` 属性可能会在将来实现，目前它只是 [CSS Shapes 模块 2 级](https://drafts.csswg.org/css-shapes-2/)里面的一个草案，并没有被任何浏览器实现。

在本文中，我们将演示如何使用 [<basic-shape>](https://tympanus.net/codrops/css_reference/basic-shape/) 数据类型，并使用形状函数值设置它，以及使用半透明 URL 或渐变设置形状。

## 基本的形状函数

我们可以通过将下列函数值应用于 `shape-outside` 属性来定义 CSS 中的各种基本形状：

*   `circle()`
*   `ellipse()`
*   `inset()`
*   `polygon()`

要给元素设定 `shape-outside` 属性，该元素必须是浮动的并且已设定宽高。让我们逐个来看四个基本形状，并演示它们的使用方法。

### 圆

我们将从 `circle()` 函数开始。设想如下场景，有一个圆形的作者头像，我们想让头像左浮动并且作者的描述文本环绕它。仅对头像元素使用 `border-radius: 50%` 不足以使文本呈圆形；文本仍将把头像当成矩形元素。

通过圆形，我们可以演示文本如何按圆形环绕。

首先我们在一个普通的 `div` 上创建 `circle` 样式，并且写几段文字。（我使用 Bob Ross 语录作为 Lorem Ipsum 文本。）

```
<div class="circle"></div>
<p>Example text...</p>
```

在 `circle` 样式中，我们设置元素左浮动，设定等值的 `height` 和 `width`，并且设置 `shape-outside` 为 `circle()`。

```
.circle {
  float: left;
  height: 200px;
  width: 200px;
  shape-outside: circle();
}
```

如果我们访问页面，会看到如下场景。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle1.jpg)

如你所见，文本围绕圆形环绕，但是我们并没有看到任何形状。使用开发工具审查元素，我们可以看到已经设置好的实际形状。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle2.jpg)

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

不幸的是，给 `circle` 设置 `background` 后会显示一个矩形，这是我们一直试图避免的事情。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle3.jpg)

我们可以清晰地看到文本在它周围环绕，但元素本身没有形状。如果我们想要真实地显示形状函数，需要使用 [`clip-path`](https://tympanus.net/codrops/css_reference/clip-path/) 属性。`clip-path` 采用许多和 `shape-outside` 相同的值，因此我们可以给它同样的 `circle()` 值。

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

> 在本文剩下的部分，我将使用 `clip-path` 帮助我们辨认形状。

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

这里有个 `circle` radius 设置 `25%` 并且使用 `shape-margin` 的例子。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle5.jpg)

除了 radius，形状函数可以使用 `at` 定位。默认位置是圆心，因此 `circle()` 也可以被显式设置为 `circle(50% at 50% 50%)` 或 `circle(100px at 100px 100px)`，两个值分别是水平和垂直位置。

为了搞清楚 position 的作用，我们可以设置水平位置值为 `0` 来创造一个完美的半圆。

```
circle(50% at 0 50%);
```

该坐标定位系统称为引用框。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_circle6.jpg)

稍后，我们将学习如何使用图像代替形状或者渐变。现在，我们将继续进行下一个形状函数。

### 椭圆

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

这次，我们设置不同的 `height` 和 `width` 创建一个垂直拉长的椭圆。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse1.jpg)

`ellipse()` 和 `circle()` 的区别在于椭圆有两个 radii —— _r_x 和 _r_y，或者 X-axis radius 和 Y-axis radius。因此，上面的例子也可以写成：

```
ellipse(75px 150px);
```

circles 和 ellipses 的位置参数是一样的。除了是测量单位，radii 也包括 `farthest-side` 和 `closest-side` 的选项。

`closest-side` 代表引用框的中心到最近侧的长度，相反，`farthest-side` 代表引用框中心到最远侧的长度。这意味着如果未设置默认值以外的位置，则这两个值无效。

这里演示了在 `ellipse()` 上翻转 `closest-side` 和 `farthest-side` 的区别，它的 X 和 Y 轴的偏移量是 `25%`。

```
ellipse(farthest-side closest-side at 25% 25%)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse2.jpg)

```
ellipse(farthest-side closest-side at 25% 25%)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_ellipse3.jpg)

### 插入

目前为止我们只处理了圆形，但是我们可以使用 `inset()` 函数定义内嵌矩形。

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

在本例中，我们创造了一个 `300px` 的正方形，每条边内嵌 `75px`。这将给我们留下 `150px` 周围有 `75px` 空间。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset1.jpg)

我们可以看到矩形是内嵌的，文本忽略了内嵌区域。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset2.jpg)

`inset()` 形状也可以使用 `round` 参数接收 `border-radius`，并且文本会识别圆角，就像本例中所有边都是 `25px` 内嵌和 `75px` 圆角。

```
inset(25px round 75px)
```

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_inset3.jpg)

像 `padding` 或 `margin` 简写，inset 值以顺时针方式（`inset(25px 25px 25px 25px)`）接收 `top` `right` `bottom` `left`，并且只传一个值将使四条边都相同（`inset(25px)`）。

### 多边形

形状函数最有趣和灵活的是 `polygon()`，它可以采用一系列 `x` 和 `y` 点来制作任何复杂形状。数组里的每个元素代表 _x_i _y_i，将被写成 `polygon(x1 y1, x2 y2, x3 y3...)` 等等。

我们可以为多边形设置的点集数量最少为 3，这将创建一个三角形。

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

在这个形状中，第一个点是 `0 0`，`div` 中最左上角的点。第二个点是 `0 300px`，它是 `div` 中最左下角的点。第三个也就是最后一个点是 `200px 300px`，它在 X 轴的 2/3 处并且也在底部。最终的形状是这样：

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon1.jpg)

`polygon()` 形状函数的一个有趣用法是文本内容可以在两个或以上形状中环绕。因为 `polygon()` 形状是如此灵活和动态，这给我们制作真正独特的杂志式布局提供了一个最好机会。在本例中，我们将把文本放在两个多边形中。

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

显然，想要手动创造你自己的复杂形状是非常困难的。幸运的是，你可以用一些工具来创建多边形。Firefox 有一个内置的形状编辑器，你可以在 Inspector 中通过点击多边形使用。

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2018/11/cssshapes_polygon3.jpg)

目前，Chrome 有一些你可以使用的扩展程序，比如 [CSS Shapes Editor](https://chrome.google.com/webstore/detail/css-shapes-editor/nenndldnbcncjmeacmnondmkkfedmgmp?hl=en-US)。

多边形可以用来剪切图像或其他元素周围的形状。在另一个例子中，我们可以通过在大字母周围绘制多边形来创建首字下沉。

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

CSS Shapes 一个令人激动的特性是你不必每次都通过形状函数明确定义；你也可以使用半透明图像的 url 来定义形状，这样文本就会自动环绕它。

重要的是要注意图像使用必须要兼容 [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)，否则你将会遇到如下错误。

```
Access to image at 'file:///users/tania/star.png' from origin 'null' 
has been blocked by CORS policy: The response is invalid.
```

在同一个服务器上提供图像将会保证你不会遇到上面的错误。

与其他例子不同，我们将使用 `img` 代替 `div`。这次的 CSS 很简单——只用把 `url()` 放进 `shape-outside` 属性，就像 `background-image` 一样。

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

因为我使用了透明背景的星星图像，文本知道哪些区域是透明的哪些是不透明的，并相应地调整自己。

## 渐变

最后，渐变也可以用来当成形状。渐变和图像一样，就像我们上面用到的图像例子，文本也将知道在透明部分环绕。

我们将使用渐变的一个新属性——[`shape-image-threshold`](https://tympanus.net/codrops/css_reference/shape-image-threshold/)。`shape-image-threshold` 定义形状的 alpha 通道阈值，或者图像透明的百分比值。

我们将制作一个渐变例子，它是 50％/50％ 的颜色和透明分割，并且设置 `shape-image-threshold` 为 `.5`，意味着超过 50％ 不透明的所有像素都应被视为图像的一部分。

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

我们可以看到渐变在不透明和透明的中心对角线完美分割

## 结论

在本文中，我们学习了 CSS Shapes 的三个属性 `shape-outside`、 `shape-margin` 和 `shape-image-threshold`。我们也了解到如何使用函数值创建可供文本环绕的圆、椭圆、内嵌矩形以及复杂的多边形，并且演示了形状如何检测图像和渐变的透明部分。

**你可以在如下 [demo](http://tympanus.net/Tutorials/CSSShapes/) 中找到本文中用到的所有例子，也可以[下载源文件](http://tympanus.net/Tutorials/CSSShapes/CSSShapes.zip)。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
