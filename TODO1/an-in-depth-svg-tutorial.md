> * 原文地址：[AN IN-DEPTH SVG TUTORIAL](https://flaviocopes.com/svg/)
> * 原文作者：[flaviocopes.com](https://flaviocopes.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-svg-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-svg-tutorial.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[dandyxu](https://github.com/dandyxu)、[allenlongbaobao](https://github.com/allenlongbaobao)

#  深入浅出 SVG

SVG 是优秀且令人难以置信的强大图像格式。本教程通过简单地解释所有需要了解的知识，为您提供 SVG 的概述。

![](https://d33wubrfki0l68.cloudfront.net/50363ccc126579554d19078999c0b7bc173fb83f/3272b/svg/banner.png)

## 介绍

尽管在 21 世纪初被标准化了，SVG（**Scalable Vector Graphics** 的缩写）是近年来的一个热门话题。

SVG 已经被糟糕的浏览器支持（尤其是 IE）惩罚了好多年。

我发现这话源自一本 2011 的书：在撰写本文时，只有在最新的浏览器中才能将 SVG 直接嵌入到 HTML 中工作。7 年过去了，这句话现在已经是过去式了，我们可以很安全地使用 SVG 图像。

现在我们可以安全地使用 SVG 图像，除非您有很多用户使用 IE8 以及更低版本，或者使用较旧的 Android 设备。这种情况下，依然存在着备选方案。

![SVG 支持的浏览器](https://d33wubrfki0l68.cloudfront.net/fa8f32426c30d6e82f1aec35c6b25389036ed752/3723d/svg/svg-browser-support.png)

SVG 成功的一部分是由于我们必须支持各种不同分辨率和尺寸的屏幕显示。SVG 能完美解决这个问题。

同时，Flash 在过去几年的迅速衰退导致大家对 SVG 产生了兴趣。这对于 Flash 过去所做的许多事情都是非常重要的。

SVG 是一种 **vector** 图像文件格式。这使得它们与其他图像格式（如 PNG、GIF 或 JPG）有很大的不同，后者是光栅图像文件格式。 

## SVG 的优势

由于 SVG 图像是矢量图像，可以**无限缩放**，而且在图像质量下降方面没有任何问题。为什么会这样呢？因为 SVG 图像是使用 **XML 标记**构建的，浏览器通过绘制每个点和线来打印它们，而不是用预定义的像素填充某些空间。这确保 SVG 图像可以适应不同的屏幕大小和分辨率，即使是那些尚未发明的。

 由于是在 XML 中定义的，SVG 图像比 JPG 或 PNG 图像更**灵活**，而且**我们可以使用 CSS 和 JavaScript 与它们进行交互**。SVG 图像设置可以**包含** CSS 和 JavaScript。

SVG 可以渲染比其他格式小得多的矢量风格图像，主要用于标识和插图。另一个巨大的用例是图标。曾经是图标字体域，比如 FontAwesome，现在的设计师更喜欢使用 SVG 图像，因为它更小，并且允许使用多色图标。

SVG 在动画方面很简单，这是一个非常酷的话题。

SVG 提供了一些图像编辑效果，比如屏蔽和剪裁、应用过滤器等等。

SVG 只是文本，因此可以使用 GZip 对其进行有效压缩。

## 您的第一个 SVG 图像

SVG 图像使用 XML 定义，这意味着如果您精通 HTML，SVG 看起来会非常熟悉，除了在 SVG 中有标签适合文档构建（如  `p`、 `article`、 `footer`、 `aside`）我们还有矢量图的构建块： `path`、 `rect`、 `line` 等等。

这是一个 SVG 图像示例：

```
<svg width="10" height="10">
  <rect x="0" y="0" width="10" height="10" fill="blue" />
</svg>
```

注意它非常容易阅读和理解图像的样子：它是一个 10 x 10 像素的简单蓝色矩形（默认单元）。

大多情况下，您不必编写 SVG 代码，因为您可以使用 Sketch 或 Figma 等工具或任何其他矢量图形工具来创建图像，并将其导出为 SVG。

SVG 的当前版本是 1.1， SVG 2.0 正在研发。

## 使用 SVG

浏览器可以通过将它们包含在一个 `img` 标签中来显示 SVG 图像：

```
<img src="image.svg" alt="My SVG image" />
```

就像其他基于像素的图像格式一样：

```
<img src="image.png" alt="My PNG image" />
<img src="image.jpg" alt="My JPG image" />
<img src="image.gif" alt="My GIF image" />
<img src="image.webp" alt="My WebP image" />
```

此外，SVG 非常独特，它们可以直接包含在 HTML 页面中：

```
<!DOCTYPE html>
<html>
  <head>
    <title>A page</title>
  </head>
  <body>
    <svg width="10" height="10">
      <rect x="0" y="0" width="10" height="10" fill="blue" />
    </svg>
  </body>
</html>
```

> 请注意 HTML5 和 XHTML 对于内联 SVG 图像需要不同的语法。幸运的是，XHTML已经是过去的事情了，因为它过于繁杂，但是如果您仍然需要处理 XHTML 页面，就值得去了解它。 

 **在 HTLM 中内联 SVG** 的功能使该格式成为场景中的 **unicorn**,因为其他图像不能这样做，必须为每个图像打开一个单独的请求来获取该格式。

## SVG 元素

在上面的示例中，您看到了 `rect` 元素的用法。SVG 有许多不同的元素。

最常用的是

*   `text`: 创建一个 text 元素
*   `circle`: 创建一个圆
*   `rect`: 创建一个矩形
*   `line`: 创建一条线
*   `path`: 在两点之间创建一条路径
*   `textPath`: 在两点之间创建一条路径，并创建一个链接文本元素
*   `polygon`: 允许创建任意类型的多边形
*   `g`: 单独的元素

> 坐标从绘图区域左上角的 0，0 开始，并 **从左到右**表示 `x`, **从上到下**表示 `y`。
> 
> 您看到的图像反映了上面所示的代码。使用[浏览器 DevTools](https://flaviocopes.com/browser-dev-tools/)，您可以检查和更改它们。

### `text`

 `text` 元素添加文本。可以使用鼠标选择文本。`x` 和 `y` 定义文本的起始点。

```
<svg>
  <text x="5" y="30">A nice rectangle</text>
</svg>
```

<svg>
  <text x="5" y="30">漂亮的长方形</text>
</svg>

### `circle`

定义圆。 `cx` 和 `cy` 是中心坐标，`r` 是半径。 `fill` 是一个常用属性，表示图形颜色。

```
<svg>
  <circle cx="50" cy="50" r="50" fill="#529fca" />
</svg>
```

<svg>
  <circle cx="50" cy="50" r="50" fill="#529fca" />
</svg>

### `rect`

定义矩形。 `x` ， `y` 是起始坐标，`width` 和 `height` 是自解释的。

```
<svg>
  <rect x="0" y="0" width="100" height="100" fill="#529fca" />
</svg>
```

<svg>
  <rect x="0" y="0" width="100" height="100" fill="#529fca" />
</svg>

### `line`

`x1` 和 `y1` 定义起始坐标。`x2` 和 `y2` 定义结束坐标。`stroke` 是一个常用属性，表示线条颜色。

```
<svg>
  <line x1="0" y1="0" x2="100" y2="100" stroke="#529fca" />
</svg>
```

<svg>
  <line x1="0" y1="0" x2="100" y2="100" stroke="#529fca" />
</svg>

### `path`

路径是一系列的直线和曲线。它是所有 SVG 绘制工具中最强大的，因此也是最复杂的。

`d` 包含方向命令。这些命令以命令名和一组坐标开始：

*   `M` 表示移动，它接受一组 x，y 坐标
*   `L` 表示直线将绘制到它接受一组 x，y
*   `H` 是一条水平线，它只接受 x 坐标
*   `V` 是一条垂直线，它只接受 y 坐标
*   `Z` 表示关闭路径，并将其放回起始位置
*   `A` 表示 Arch，它自己需要一个完整的教程
*   `Q` 是一条二次 Bezier 曲线，同样，它自己也需要一个完整的教程

```
<svg height="300" width="300">
  <path d="M 100 100 L 200 200 H 10 V 40 H 70"
        fill="#59fa81" stroke="#d85b49" stroke-width="3" />
</svg>
```

<svg height="300" width="300">
  <path d="M 100 100 L 200 200 H 10 V 40 H 70"
        fill="#59fa81" stroke="#d85b49" stroke-width="3" />
</svg>

### `textPath`

沿路径元素的形状添加文本。

<svg viewBox="0 0 1000 600" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <path id="MyPath" d="M 20 40 Q 260 240 400 500"></path>
  </defs>
  <use xlink:href="#MyPath" fill="none" stroke="#59fa81"></use>
  <text font-family="Courier New" font-size="42.5">
    <textPath xlink:href="#MyPath">
      Wow such a nice SVG tut
    </textPath>
  </text>
</svg>

### `polygon`

使用 `polygon` 绘制任意多边形。 `points` 代表一组 x，y 坐标多边形应该链接：

```
<svg>
  <polygon points="9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78" />
</svg>
```

<svg>
  <polygon points="9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78" />
</svg>

### `g`

使用 `g` 元素，您可以对多个元素进行分组： 

```
<svg width="200" height="200">
  <rect x="0" y="0" width="100" height="100" fill="#529fca" />
  <g id="my-group">
    <rect x="0" y="100" width="100" height="100" fill="#59fa81" />
    <rect x="100" y="0" width="100" height="100" fill="#59fa81" />
  </g>
</svg>
```

<svg width="200" height="200">
  <rect x="0" y="0" width="100" height="100" fill="#529fca" />
  <g id="my-group">
    <rect x="0" y="100" width="100" height="100" fill="#59fa81" />
    <rect x="100" y="0" width="100" height="100" fill="#59fa81" />
  </g>
</svg>

## SVG viewport 和 viewBox

SVG 相对于其容器的大小由 `svg` 元素的 `width` 和 `height` 属性设置。这些单位默认为像素，但您可以使用任何其他常用单位，如 `%` 或 `em`。这是 **viewport**。

> 通常 “container” 指的是浏览器窗口，但 `svg` 元素可以包含其他 `svg` 元素，在这种情况下，容器是父元素 `svg`。

一个重要的属性是 `viewBox`。它允许您在 SVG 画布中定义一个新的坐标系统。

假设在 200x200px SVG 中有一个简单的圆：

```
<svg width="200" height="200">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>
```

<svg width="200" height="200">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>

通过指定 **viewBox** ，您可以选择 **只显示此 SVG 的一部分**。例如，您可以从 0，0 点开始，只显示一个 100 x 100 px 画布：

```
<svg width="200" height="200" viewBox="0 0 100 100">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>
```

<svg width="200" height="200" viewBox="0 0 100 100">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>

从 100，100 开始，您会看到另一部分，圆圈的右下角：

```
<svg width="200" height="200" viewBox="100 100 100 100">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>
```

<svg width="200" height="200" viewBox="100 100 100 100">
  <circle cx="100" cy="100" r="100" fill="#529fca" />
</svg>

一个很好的可视化方法是想象 Google Maps 是一个巨大的 SVG 图像，而您的浏览器是一个和窗口大小一样大的视图框。当您移动时，Viewbox 会更改它的起始点（x,y）坐标，并且当您调整窗口的大小时，会更改 Viewbox 的宽度和高度。

## 在 Web 网页中插入 SVG

将 SVG 添加到网页中有多种方法。

最常见的是：

*   带有 `img` 标签
*   带有 CSS `background-image` 属性
*   在 HTML 中内联
*   带有 `object`、 `iframe` 或 `embed` 标签

在 Glitch 上可以查看这些示例 [https://flavio-svg-loading-ways.glitch.me/](https://flavio-svg-loading-ways.glitch.me/)

### 带有 `img` 标签

```
<img src="flag.svg" alt="Flag" />
```

### 带有 css `background-image` 属性

```
<style>
.svg-background {
  background-image: url(flag.svg);
  height: 200px;
  width: 300px;
}
</style>
<div class="svg-background"></div>
```

### 在 HTML 中内联

```
<svg width="300" height="200" viewBox="0 0 300 200"
    version="1.1" xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink">
  <title>Italian Flag</title>
  <desc>By Flavio Copes https://flaviocopes.com</desc>
  <g id="flag">
      <rect fill="green" x="0" y="0" width="100" height="200"></rect>
      <rect fill="white" x="100" y="0" width="100" height="200"></rect>
      <rect fill="red" x="200" y="0" width="100" height="200"></rect>
  </g>
</svg>
```

### 带有 `object` 、`iframe` 或 `embed` 标签

```
<object data="flag.svg" type="image/svg+xml"></object>

<iframe src="flag.svg" frameborder="0"></iframe>

<embed src="flag.svg" type="" />
```

使用 `embed`，您可以使用以下命令从父文档获取 SVG 文档

```
document.getElementById('my-svg-embed').getSVGDocument()
```

在 SVG 内部，您可以通过以下方式引用父文档：

```
window.parent.document
```

## 使用数据 URL 内联 SVG

您可以使用以上任何示例结合 [Data URLs](https://flaviocopes.com/data-urls/) 将 SVG 内联到 HTML 中：

```
<img src="data:image/svg+xml;<DATA>" alt="Flag" />

<object data="data:image/svg+xml;<DATA>" type="image/svg+xml"></object>

<iframe data="data:image/svg+xml;<DATA>" frameborder="0"></iframe>
```

在 CSS 中也是：

```
.svg-background {
  background-image: url("data:image/svg+xml;<DATA>");
}
```

只需使用适当的[Data URL](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs) 更改`<DATA>`。

## 样式元素

任何 SVG 元素都可以接受 `style` 属性，就像 HTML标签一样。并非所有的 CSS 属性都能像您预期的那样工作。例如，要更改文本元素的颜色，请使用 `fill` 而不是 `color`。

```
<svg>
  <text x="5" y="30" style="fill: green">A nice text</text>
</svg>

<svg>
  <text x="5" y="70" style="fill: green; font-family: Courier New">
    A nice text
  </text>
</svg>
```

您也可以使用 `fill` 作为元素属性，正如您在前面看到的那样：

```
<svg>
  <text x="5" y="70" fill="green">A nice text</text>
</svg>
```

其他公共属性包括

*   `fill-opacity`，背景颜色不透明度
*   `stroke`，定义边框颜色
*   `stroke-width`，设置边框宽度

CSS 可以针对 SVG 元素，就像您以 HTML 标签为目标一样：

```
rect {
  fill: red;
}
circle {
  fill: blue;
}
```

## 使用 CSS 或 JavaSCript 与 SVG 交互

SVG 图像可以使用 CSS 进行样式化，或者使用 JavaScript 编写脚本，这种情况下：

*   **当 SVG 在 HTML 中内联**
*   通过 `object` 、`embed` 或 `iframe` 标签加载图像时

但是 (⚠️ 取决于浏览器实现) 它们必须从相同的域（和协议）加载，这是同源策略所导致的。
`iframe` 需要显式定义的尺寸，否则内容将被裁剪，同时调整 `object` 和 `embed` 尺寸以适应其内容。.

如果 SVG 是使用 `img` 标签加载的，或者使用 CSS 作为背景，则与源无关：

*   CSS 和 JavaScript 不能与之进行交互
*   SVG 中包含的 JavaScript 被禁用
*   无法从外部加载资源（如图像、样式表、脚本、字体）

细节

* * *

| 特性 |  SVG 内联 | `object`/`embed`/`iframe` | `img` |
| --- | --- | --- | --- |
| 可以与用户交互 | ✅ | ✅ | ✅ |
| 支持动画 | ✅ | ✅ | ✅ |
| 可以运行 JavaScript 脚本 | ✅ | ✅ | 👎🏼 |
| 可以从外部编写脚本 | ✅ | 👎🏼 | 👎🏼 |

内联 SVG 图像无疑是最强大和最灵活的，它是使用 SVG 执行某些操作的唯一方法。

**如果您想要 SVG 与您的脚本进行任何交互，它必须以内联的方式加载到 HTML中**。

如果您不需要与 SVG 交互，只需在页面中显示它，将 SVG 加载至 `img` 、 `object` 或者 `embed` 中即可，如果您在不同的页面中重用 SVG 图像，或者 SVG 图像的大小相当大，那么加载 SVG 就特别方便。

### CSS 嵌入 SVG

将 CSS 加至 CDATA:

```
<svg>
  <style>
    <![CDATA[
      #my-rect { fill: blue; }
    ]]>
  </style>
  <rect id="my-rect" x="0" y="0" width="10" height="10" />
</svg>
```

SVG 文件还可以包括外部样式表

```
<?xml version="1.0" standalone="no"?>
<?xml-stylesheet type="text/css" href="style.css"?>
<svg xmlns="http://www.w3.org/2000/svg" version="1.1"
     width=".." height=".." viewBox="..">
  <rect id="my-rect" x="0" y="0" width="10" height="10" />
</svg>
```

### JavaScript 嵌入 SVG

你可以将 JavaScript 放在第一个位置上，并包装在一个 `load` 事件中，以便在页面完全加载并在 DOM 中插入 SVG 时执行它：

```
<svg>
  <script>
    <![CDATA[
      window.addEventListener("load", () => {
        //...
      }, false)
    ]]>
  </script>
  <rect x="0" y="0" width="10" height="10" fill="blue" />
</svg>
```

或者如果您将 JS 放在其他 SVG 代码的末尾，可以避免添加事件监听，确保当 SVG 出现在页面时 JavaSCript 会执行。

```
<svg>
  <rect x="0" y="0" width="10" height="10" fill="blue" />
  <script>
    <![CDATA[
      //...
    ]]>
  </script>
</svg>
```

与 HTML 元素一样，SVG 元素也可以有 `id` 和 `class` 属性，因此我们可以使用 [Selectors API](https://flaviocopes.com/selectors-api/) 来引用它们：

```
<svg>
  <rect x="0" y="0" width="10" height="10" fill="blue"
        id="my-rect" class="a-rect" />
  <script>
    <![CDATA[
      console.log(document.getElementsByTagName('rect'))
      console.log(document.getElementById('my-rect'))
      console.log(document.querySelector('.a-rect'))
      console.log(document.querySelectorAll('.a-rect'))
    ]]>
  </script>
</svg>
```

请查看此故障 [https://flaviocopes-svg-script.glitch.me/](https://flaviocopes-svg-script.glitch.me/) 以获得功能性提示。

### SVG 外部的 JavaScript

如果可以与 SVG 交互（SVG 在 HTML 中是内联的），则可以使用 JavaScript 更改任何 SVG 属性，例如：

```
document.getElementById("my-svg-rect").setAttribute("fill", "black")
```

或者真正地做任何您想要的 [DOM](https://flaviocopes.com/dom/) 操作。

### SVG 外部的 CSS

您可以使用 CSS 更改 SVG 图像的任何样式。

SVG 属性可以很容易地在 CSS中 被覆盖，并且它们比 CSS 具有更低的优先级。它们的行为不像具有更高优先级的内联 CSS。

```
<style>
  #my-rect {
    fill: red
  }
</style>
<svg>
  <rect x="0" y="0" width="10" height="10" fill="blue"
        id="my-rect" />
</svg>
```

## SVG vs Canvas API

 Canvas API 是 Web 平台一个很好的补充，它有类似于 SVG 的浏览器支持。与 SVG 主要的（也是最大的）不同之处是：画布不是基于矢量的，而是基于像素的，所以

*   它具有与基于像素的 png、jpg 和 gif 图像格式相同的缩放问题。
*   这使得不可能像使用 SVG 那样使用 CSS 或 JavaScropt 编辑画布图像。

## SVG 符号

符号使您可以定义一次SVG图像，并在多个地方重用它。如果您需要重用一个图像，这是一个很大的帮助，可能只是改变一点它的一些属性。

您可以通过添加一个 `symbol` 元素并分配一个 `id` 属性来完成此操作：

```
<svg class="hidden">
  <symbol id="rectangle" viewBox="0 0 20 20">
    <rect x="0" y="0" width="300" height="300" fill="rgb(255,159,0)" />
  </symbol>
</svg>
```

```
<svg>
  <use xlink:href="#rectangle" href="#rectangle" />
</svg>

<svg>
  <use xlink:href="#rectangle" href="#rectangle" />
</svg>
```

(`xlink:href` 用于 Safari 支持，即使它是一个已废弃的属性)

这让我们能开始了解 SVG 的强大功能。

如果您希望对这两个矩形使用不同的样式，例如，对每个矩形使用不同的颜色？您可以使用[CSS 变量](https://flaviocopes.com/css-variables/).

```
<svg class="hidden">
  <symbol id="rectangle" viewBox="0 0 20 20">
    <rect x="0" y="0" width="300" height="300" fill="var(--color)" />
  </symbol>
</svg>
```

```
<svg class="blue">
  <use xlink:href="#rectangle" href="#rectangle" />
</svg>

<svg class="red">
  <use xlink:href="#rectangle" href="#rectangle" />
</svg>

<style>
svg.red {
  --color: red;
}
svg.blue {
  --color: blue;
}
</style>
```

查看 SVG 符号--[我的 Glitch playground](https://flavio-svg-symbols.glitch.me/)。

## 验证 SVG

SVG 文件是 XML，可以用无效的格式编写，有些服务或应用程序可能不接受无效的 SVG 文件。

SVG 可以使用 [W3C Validator](https://validator.w3.org)验证。

## 我应该包含 `xmlns` 属性么？

有时 SVG 别定义为

```
<svg>
  ...
</svg>
```

有时定义为

```
<svg version="1.1" xmlns="http://www.w3.org/2000/svg">
  ...
</svg>
```

第二个表单是 XHTML。它可以与 HTML5 一起使用（文档具有 `<!DOCTYPE html>`），但在本例中，第一种形式更简单。

## 我应该担心浏览器支持问题么？

在 2018 版本中，绝大多数用户的浏览器都支持 SVG。.

您仍然可以使用诸如 [Modernizr](https://modernizr.com/) 这样的库来检查缺少的支持，并提供一个后备：

```
if (!Modernizr.svg) {
  $(".my-svg").attr("src", "images/logo.png");
}
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
