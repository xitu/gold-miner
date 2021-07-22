> - 原文地址：[Adding Shadows to SVG Icons With CSS and SVG Filters](https://css-tricks.com/adding-shadows-to-svg-icons-with-css-and-svg-filters/)
> - 原文作者：[Joel Olawanle ](https://css-tricks.com/author/joelolawanlet/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/adding-shadows-to-svg-icons-with-css-and-svg-filters.md](https://github.com/xitu/gold-miner/blob/master/article/2021/adding-shadows-to-svg-icons-with-css-and-svg-filters.md)
> - 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> - 校对者：

# 使用 CSS 和 SVG 滤镜给 SVG 图标添加阴影

为什么我们需要给 SVG 添加阴影？

1. 阴影是一种常见的设计功能，可以帮助图标等元素脱颖而出。它们可以是持久的，也可以应用于不同的状态（例如专属于 `:hover`、`:focus` 或`:active` 的阴影）以指示与用户的交互。
2. 阴影发生在现实生活中，因此在页面中应用阴影可以为我们的元素注入活力，并[为设计添加一丝真实感](https://css-tricks.com/getting-deep-into-shadow/)。

由于我们正在制作列表，因此我们可以通过两种主要方式将阴影应用于 SVG：

1. 使用 CSS `[filter()](https://css-tricks.com/almanac/properties/f/filter/)` 属性；
2. 使用 SVG `<filter>`；

是的，两者都涉及滤镜！而且，是的，CSS 和 SVG 都有自己的滤镜类型。但这些之间也有一些交叉。例如，一个 CSS `filter` 可以引用一个 SVG `<filter>`；也就是说，我们可以在 CSS 中使用内联 SVG 而不是别的，比如说，在 CSS 中用作背景图像的 SVG。

**不能使用的内容：**CSS `box-shadow` 属性。这通常用于阴影，但它只会遵循元素的矩形外边缘，而不是我们所希望它遵循的 SVG 元素的边缘。这是 Michelle Barker 的[清晰解释](https://css-irl.info/drop-shadow-the-underrated-css-filter/)：

![两张亮粉色的扁平小猫脸，露出耳朵、眼睛和胡须。第一只小猫的盒子周围有阴影，第二只小猫的路径边缘有阴影。](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/s_EE31147C7EC35BC4B7EE00D7050579562DC2DDDC7CFB621A7904E66DFA700FE7_1622485808504_drop-shadow-01.jpg?resize=1800%2C846)

但是，如果我们使用的是 SVG 图标字体，则 [`text-shadow`](https://css-tricks.com/almanac/properties/t/text-shadow/) 始终都是可选择的添加阴影的方法。那确实会奏效。但是让我们关注前两个，因为它们符合大多数用例。

## 带有 CSS 滤镜的阴影

通过 CSS 滤镜将阴影直接应用于 SVG 的技巧是 `drop-shadow()` 函数：

```css
SVG {
  filter: shadow(3px 5px 2px rgb(0 0 0 / 0.4));
}
```

这将应用一个阴影，从水平方向 3px 开始并向下 5px，模糊半径是 2px，阴影颜色是 40% 的黑色。以下是一些示例：[Codepen chriscoyier/rNypeeJ](https://codepen.io/chriscoyier/pen/rNypeeJ)。

> 此浏览器支持数据来自 [Caniuse](https://caniuse.com/#feat=”css-filters”)，其中有更多详细信息。数字表示浏览器支持该版本及更高版本的功能。
>
> ![Caniuse](https://i.imgur.com/mqI4fZA.png)

### 在 CSS 滤镜中调用 SVG 滤镜

假设我们在 HTML 中有一个 SVG 滤镜：

```svg
<svg height="0" width="0">

  <filter id='shadow' color-interpolation-filters="sRGB">
    <feDropShadow dx="2" dy="2" stdDeviation="3" flood-opacity="0.5"/>
  </filter>

</svg>
```

我们可以使用 CSS 滤镜通过 ID 调用该 SVG 滤镜，而不是我们之前看到的值：

```css
SVG {
  filter: url(#shadow);
}
```

现在该滤镜取自 HTML 并在应用它的 CSS 中引用：[Codepen chriscoyier/yLMpOoP](https://codepen.io/chriscoyier/pen/yLMpOoP)。

### 使用 SVG 滤镜原始类型

你可能想知道我们是如何让 SVG `<filter>` 工作的。为了使用 SVG 滤镜制作阴影，我们使用**filter 原始类型**。SVG 中的滤镜原始类型是一种元素，它以某种图像或图形作为输入，然后在调用时输出该图像或图形。它们有点像图形编辑应用程序中的滤镜，但它们是代码中并且只能在 SVG [`<filter>`](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/filter) 元素中定义。

SVG 中有[许多不同的滤镜原始类型](https://developer.mozilla.org/en-US/docs/Web/SVG/Element#filter_primitive_elements)。我们要接触的是 `<feDropShadow>`。我会让你只看名字就猜到要做什么。

因此，类似于我们使用 CSS 滤镜执行此操作的方式：

```css
svg {
  filter: drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));
}
```

……我们可以使用 `<feDropShadow>` SVG 滤镜原始类型完成相同的操作。有三个关键属性值得一提，因为它们有助于定义阴影的外观：

- `dx` —— 这会沿 x 轴移动阴影的位置。
- `dy` —— 这会沿着 y 轴移动阴影的位置。
- `stdDeviation` —— 这定义了阴影模糊操作的标准偏差。我们还可以使用其他属性，例如用于设置阴影颜色的 `flood-color` 和用于设置阴影不透明度的 `flood-opacity`。

[Codepen olawanlejoel/xxqdaqN](https://codepen.io/olawanlejoel/pen/xxqdaqN)

该示例包括三个 `<filter>` 元素，每个元素都有自己的 `<feDropShadow>` 滤镜原始类型。

## 使用 SVG 滤镜

SVG 滤镜非常强大。我们刚刚了解了 `<feDropShadow>`，这当然非常有用，但它们可以做的还有很多（包括类似 Photoshop 的效果），而且我们只为阴影获得的东西的子集非常广泛。让我们看一些，比如彩色阴影和插入阴影。

让我们以 Twitter 徽标的 SVG 标记为例：

```svg
<svg class="svg-icon" viewBox="0 0 20 20">
  <path fill="#4691f6" d="M18.258,3.266c-0.693,0.405-1.46,0.698-2.277,0.857c-0.653-0.686-1.586-1.115-2.618-1.115c-1.98,0-3.586,1.581-3.586,3.53c0,0.276,0.031,0.545,0.092,0.805C6.888,7.195,4.245,5.79,2.476,3.654C2.167,4.176,1.99,4.781,1.99,5.429c0,1.224,0.633,2.305,1.596,2.938C2.999,8.349,2.445,8.19,1.961,7.925C1.96,7.94,1.96,7.954,1.96,7.97c0,1.71,1.237,3.138,2.877,3.462c-0.301,0.08-0.617,0.123-0.945,0.123c-0.23,0-0.456-0.021-0.674-0.062c0.456,1.402,1.781,2.422,3.35,2.451c-1.228,0.947-2.773,1.512-4.454,1.512c-0.291,0-0.575-0.016-0.855-0.049c1.588,1,3.473,1.586,5.498,1.586c6.598,0,10.205-5.379,10.205-10.045c0-0.153-0.003-0.305-0.01-0.456c0.7-0.499,1.308-1.12,1.789-1.827c-0.644,0.28-1.334,0.469-2.06,0.555C17.422,4.782,17.99,4.091,18.258,3.266" ></path>
</svg>
```

我们需要一个 `<filter>` 元素来实现这些效果。这需要在 HTML 的 `<svg>` 元素中。 `<filter>` 元素永远不会直接在浏览器中呈现 — 它仅用作可以通过 SVG 中的 `filter` 属性或 CSS 中的 `url()` 函数引用的内容。

以下是显示 SVG 滤镜并将其应用于源图像的语法：

```svg
<svg width="300" height="300" viewBox="0 0 300 300">

  <filter id="myfilters">
    <!-- 所有的滤镜效果/原始类型在此定义 -->
  </filter>

  <g filter="url(#myfilters)">
    <!-- 滤镜会应用于这一组下所有的东西 -->
    <path fill="……" d="……" ></path>
  </g>

</svg>
```

`filter` 元素旨在将 **filter 原始类型**作为子元素。它是一系列过滤操作的容器，这些操作组合起来以创建过滤效果。

这些滤镜原始类型对一个或多个输入执行单个基本图形操作（例如模糊、移动、填充、组合或扭曲）。它们就像构建块，每个 SVG 滤镜都可以用来与其他滤镜结合使用以创建效果。`<feGaussianBlur>` 是一种流行的滤镜原始类型，用于添加高斯模糊效果。

假设我们使用 `<feGaussianBlur>` 定义了以下 SVG 滤镜：

```svg
<svg version="1.1" width="0" height="0">
  <filter id="gaussian-blur">
    <feGaussianBlur stdDeviation="1 0" />
  </filter>
</svg>
```

当应用于元素时，此滤镜会创建[高斯模糊](https://www.adobe.com/creativecloud/photography/discover/gaussian-blur.html)效果，在 x 上以 `1px` 的模糊半径模糊元素，但在 y 轴上没有模糊。这是有和没有效果的结果：

[CodePen olawanlejoel/rNyGbjw](https://codepen.io/olawanlejoel/pen/rNyGbjw)

我们可以在单个滤镜中使用多个原始类型。这将创建有趣的效果，但是，我们需要让不同的原始类型相互了解。Bence Szabó 有一套[疯狂酷炫的模式](https://css-tricks.com/creating-patterns-with-svg-filters/)，他是用这种方式创建的：

当组合多个滤镜原始类型时，第一个原始类型使用原始图形（`SourceGraphic`）作为其图形输入。任何后续原始类型都使用它之前的过滤效果的结果作为其输入。等等。但是我们可以通过在原始元素上使用 `in`、`in2` 和 `result` 属性来获得一些灵活性。[Steven Bradley 有一篇关于滤镜原始类型的优秀文章](https://vanseodesign.com/web-design/svg-filter-primitives-input-output/)可以追溯到 2016 年，但今天仍然适用。

我们今天可以使用 17 个原始类型：

- `<feGaussianBlur>`
- `<feDropShadow>`
- `<feMorphology>`
- `<feDisplacementMap>`
- `<feBlend>`
- `<feColorMatrix>`
- `<feConvolveMatrix>`
- `<feComponentTransfer>`
- `<feSpecularLighting>`
- `<feDiffuseLighting>`
- `<feFlood>`
- `<feTurbulence>`
- `<feImage>`
- `<feTile>`
- `<feOffset>`
- `<feComposite>`
- `<feMerge>`

注意所有这些的 `fe` 前缀。那代表 `过滤效果`（`filter effect`）。理解 SVG 滤镜具有挑战性。像插入阴影这样的效果需要冗长的语法，如果没有对数学和色彩理论的透彻理解，就很难掌握。（Rob O'Leary 的 [“深入阴影”](https://css-tricks.com/getting-deep-into-shadows/) 是一个很好的起点。）

我们将使用一些预制的滤镜，而把我们自己带入奇妙的超现实状态或情况的事物之中。幸运的是，我们身边有很多现成的 SVG 滤镜。

### 插入阴影

要在 Twitter 徽标上使用过滤效果，我们需要在我们的“SVG 源文档”中声明它，并在我们的 `<filter>` 标签中使用唯一的 ID 进行引用。

```svg
<filter id='inset-shadow'>
  <!-- Shadow offset -->
  <feOffset
    dx='0'
    dy='0'
  />

  <!-- 阴影半径 -->
  <feGaussianBlur
    stdDeviation='1'
    result='offset-blur'
  />

  <!-- 反转阴影以制作内嵌的阴影 -->
  <feComposite
    operator='out'
    in='SourceGraphic'
    in2='offset-blur'
    result='inverse'
  />

  <!-- 修改阴影内的颜色透明度 -->
  <feFlood
    flood-color='black'
    flood-opacity='.95'
    result='color'
  />
  <feComposite
    operator='in'
    in='color'
    in2='inverse'
    result='shadow'
  />

  <!-- 在元素上放置阴影 -->
  <feComposite
    operator='over'
    in='shadow'
    in2='SourceGraphic'
  />
</filter>
```

那里有四种不同的原始类型，每一种都执行不同的功能。 但是，综合起来，它们实现了插入阴影。

<table>
    <tr>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-1a.jpg?ssl=1&resize=500%2C500" alt="fig 1a" /></td>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-2.jpg?ssl=1&resize=500%2C500" alt="fig 2" /></td>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-3.jpg?ssl=1&resize=500%2C500" alt="fig 3" /></td>
    </tr>
    <tr>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-4.jpg?ssl=1&resize=500%2C500" alt="fig 4" /></td>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-5.jpg?ssl=1&resize=500%2C500" alt="fig 5" /></td>
        <td><img src="https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/06/twitter-shadow-6.jpg?ssl=1&resize=500%2C500" alt="fig 6" /></td>
    </tr>
</table>

现在我们已经创建了这个插入阴影滤镜，我们可以将它应用到我们的 SVG 中。我们已经看到了如何通过 CSS 应用它。 就像是：

```css
.filtered {
  filter: url(#myfilters);
}

/* 或者只应用于特定的状态，比如说： */
svg:hover,
svg:focus {
  filter: url(#myfilters);
}
```

[Codepen olawanlejoel/jOBBRjd](https://codepen.io/olawanlejoel/pen/jOBBRjd)

我们还可以使用 `filter` 属性直接在 SVG 语法中应用 SVG `<filter>`，就像：

```svg
<svg>

  <!-- 应用单一滤镜 -->
  <path d="..." filter="url(#myfilters)" />

  <!-- 或者应用于一组元素 -->
  <g filter="url(#myfilters)">
    <path d="……" />
    <path d="……" />
  </g>
</svg>
```

[CodePen olawanlejoel/vYxmXVg](https://codepen.io/olawanlejoel/pen/vYxmXVg)

## 更多例子

以下是来自 Oleg Solomka 的更多阴影示例：

[CodePen sol0mka/6eca814eda8ec7e758d0feab628bd390](https://codepen.io/sol0mka/pen/6eca814eda8ec7e758d0feab628bd390)

请注意，这里的基本阴影可能比它们需要的要复杂一些。例如，彩色阴影仍然可以使用 `<feDropShadow>` 来完成，例如：

```svg
<feDropShadow dx="-0.8" dy="-0.8" stdDeviation="0"
  flood-color="pink" flood-opacity="0.5"/>
```

但是这种浮雕效果作为滤镜非常棒！

另请注意，我们可能会在 SVG 语法中看到 SVG 滤镜，如下所示：

```svg
<svg height="0" width="0" style="position: absolute; margin-left: -100%;">
  <defs>
    <filter id="my-filters">
      <!-- …… -->
    </filter>

    <symbol id="my-icon">
      <!-- …… -->
    </symbol>
  </defs>
</svg>
```

在第一行，意思是：这个 SVG 根本不应该渲染 —— 它只是我们打算稍后使用的东西。`<defs>` 标签说了类似的话：我们只是定义这些东西以备后用。这样，我们就不必一遍又一遍地写东西来重复自己。我们将通过 ID 和符号引用滤镜，也许像：

```svg
<svg>
  <use xlink:href="#my-icon" />
</svg>
```

SVG 滤镜得到广泛支持（甚至在 Internet Explorer 和 Edge 中！），而且性能非常之好。

> 此浏览器支持数据来自 [Caniuse](https://caniuse.com/#feat=”svg-filters”)，其中有更多详细信息。数字表示浏览器支持该版本及更高版本的功能。
>
> ![Caniuse](https://i.imgur.com/L7yoVeK.png)

## 总结一下

最后对比：

- CSS 滤镜更易于使用，但限制更多。例如，我认为不可能使用 `drop-shadow()` 函数添加插入阴影。
- SVG 滤镜更加健壮，但也更加复杂，并且需要在 HTML 中的某处使用 `<filter>`。
- 它们都具有出色的浏览器支持并且在所有现代浏览器上都表现良好，尽管 SVG 滤镜（令人惊讶地）拥有最深入的浏览器支持。

在本文中，我们通过示例了解了为什么以及如何将阴影应用于 SVG 图标。你有没有这样做过，但它的方式与我们所看到的不同吗？你是否尝试过制作无法实现的阴影效果？请分享！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
