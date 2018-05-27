> * 原文地址：[New CSS Features That Are Changing Web Design](https://www.smashingmagazine.com/2018/05/future-of-web-design/)
> * 原文作者：[Zell](https://www.smashingmagazine.com/author/zellliew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/future-of-web-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/future-of-web-design.md)
> * 译者：[sophia](https://github.com/sophiayang1997)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94/)

# 新的 CSS 特性正在改变网页设计

如今，网页设计的风貌已经完全改变。我们拥有又新潮又强大的工具 —— CSS 网格/栅格（CSS Grid），CSS 自定义属性（CSS custom properties），CSS 图形（CSS shapes）和 CSS 写作模式（CSS writing-mode），这里仅举此几例 —— 这些都可以被用来锻炼我们的创造力。本文作者 Zell Liew 将解释如何用它们来锻炼我们的创造力。

曾经有一段时间网页设计变得单调乏味。设计师们和开发者们一次又一次地构建相同类型的网站，以至于我们被本行业的人嘲笑只会创建两种类型的网站：

![](https://i.loli.net/2018/05/23/5b052472069ff.png)

这难道是我们的“创造性”思维可以实现的最大限度吗？这种想法让我感到一阵无法控制的悲伤。

我不想承认这一点，但这也许是我们当时能完成的最好作品。也许是因为我们没有合适的工具去进行创意设计导致的。网络的需求正在迅速发展，但我们被浮动（floats）和表格（tables）这些古老的技术所局限。

如今，网页设计的风貌已经完全改变。我们拥有又新潮又强大的工具 —— CSS 网格（CSS Grid），CSS 自定义属性（CSS custom properties），CSS图形（CSS shapes）和 CSS 写作模式（CSS writing-mode），我们可以用仅举的这几项工具来锻炼我们的创造力。

### CSS 网格（CSS Grid）如何改变一切

你早就已经知道网格对于网页设计至关重要。但是你是否停下来问问自己，你主要使用网格去如何设计网页？

我们大多数的人都没有思考这个问题。我们通常习惯使用已经成为我们行业标准的 12 列网格。

*   但为什么我们使用相同的网格？
*   为什么网格由 12 列组成？
*   为什么我们的网格大小相等？

我们使用相同网格的理由可能是：**我们并不想计算**。

过去，在基于浮动的的网格中去创建一个三列网格。你需要计算每列的宽度，每个间隔的大小以及如何去放置这些网格项。然后，你需要在 HTML 中创建类（classes）以适当地设置它们的样式。这样做[非常复杂](https://zellwk.com/blog/responsive-grid-system/)。

为了让事情更简单，我们可以采用网格框架。一开始，[960gs](https://960.gs) 和 [1440px](https://1440px.com) 等框架允许我们选择 8、9、12 甚至 16 列的网格。后来，Bootstrap 在这场框架大战之中胜出。由于 Bootstrap 值仅允许网格 12 列，并且想要改变这个规则是非常痛苦的过程，因此我们最终以 12 列作为网格标准。

但我们不应该责怪 Bootstrap。那是当时最好的办法。谁不想要一个能够以最小的努力工作就可以获得的优良解决方案？随着网格的问题解决，我们将注意力转移到设计的其他方面，例如排版、颜色和可访问性。

现在，随着 **CSS Grid 的出现，网格变得更加简单**。我们不再需要担心网格中遇到的复杂计算。这些工作变得非常简单，以至于我认为使用 CSS 创建网格比使用 Sketch 等设计工具更加容易！

为什么呢？

假设你想制作一个 4 列的网格，每列的大小为 100 像素。使用 CSS 网格，你可以在 `grid-template-columns` 声明中写四次 `100px` ，之后一个 4 列网格就会被创建。

```
.grid {
  display: grid;
  grid-template-columns: 100px 100px 100px 100px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows four columns.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/9287f25c-75f8-456b-9f22-b3190802d543/future-web-design-grid-four.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/9287f25c-75f8-456b-9f22-b3190802d543/future-web-design-grid-four.png)

你可以通过在 `grid-template-columns` 中指定四次列宽来创建四个网格列。

如果你想要一个 12 列的网格，你只需要重复 `100px` 12 次。

```
.grid {
  display: grid;
  grid-template-columns: 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows twelve columns.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/61ab598a-9c0d-4d81-a624-3fbca4dfb6b2/future-web-design-grid-twelve.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/61ab598a-9c0d-4d81-a624-3fbca4dfb6b2/future-web-design-grid-twelve.png) 

使用 CSS Grid 创建 12 列网格。

如你所见，这段代码并不优雅，但我们（暂时还）并不关心优化代码质量，我们优先考虑设计方面的。对于任何人来说，CSS Grid 都很容易，即使是没有编码知识的设计师，也可以在网络上创建网格。

如果你想要创建具有不同宽度的网格列，只需在 `grid-template-columns` 声明中指定所需的宽度，就搞定了。

```
.grid {
  display: grid;
  grid-template-columns: 100px 162px 262px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows three colums of different width.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6be83c78-9646-4c17-8d74-a3ffa55c13e1/future-web-design-grid-asym.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6be83c78-9646-4c17-8d74-a3ffa55c13e1/future-web-design-grid-asym.png) 

创建不同宽度的列也是小菜一碟。

#### 使网格具有响应性

在关于 CSS 网格的讨论中，没有不讨论其响应性的。有几种方法可以使 CSS Grid 具有响应性。一种方式（可能是最流行的方式）是使用 `fr` 单位。另一种方法是更改​​媒体查询的列数。

`fr` 是代表一个片段的灵活长度单位。当你使用 `fr` 单位时，浏览器会分割开放空间并根据 `fr` 倍数将区域分配给列。这意味着要创建四个相同大小的列，你需要写四次 `1fr`。

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr;
  grid-column-gap: 20px;
}
```

[![GIF shows four columns created with the fr unit. These columns resize according to the available white space](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif)

用 `fr` 单位创建的网格遵守网格的最大宽度。 ([大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif))

**让我们做一些计算来理解为什么以上代码创建四个相等大小的列**。

首先，我们假设网格的总可用空间为 `1260px`。

在为每列分配宽度之前，CSS Grid 需要知道有多少可用空间（或剩余空间）。在这里，它从 `1260px` 减去 `grip-gap` 声明。由于每个间隙 `20px`，我们剩下 `1200px` 的可用空间。`（1260 - （20 * 3）= 1200）`。

接下来，将 `fr` 倍数考虑进来。在这个例子里面，我们有四个 `1fr` 倍数，所以浏览器将 `1200px` 除以四。每列是 300 px。这就是为什么我们得到四个相等的列。

**但是，使用 `fr` 单元创建的网格并不总是相等的**！

当你使用 `fr` 时，你需要知道每个 `fr` 单位是可用（或剩余）空间的一个小片段。

如果你的元素比使用 `fr` 单位创建的任何列都要宽，则需要以不同的方式进行计算。

例如，下面例子中的网格具有一个大列和和三个小（但相等的）列，即使它是使用 `grid-template-columns: 1fr 1fr 1fr 1fr` 创建的。

请参阅 [CodePen](https://codepen.io) 上 Zell Liew（[@zellwk](https://codepen.io/zellwk)）的 [CSS Grid `fr` unit demo 1](https://codepen.io/zellwk/pen/vjWQep/)。

将 `1200px` 分成四部分并为每个 `1fr` 列分配 `300px` 的区域后，浏览器意识到第一个网格项包含 `1000px` 的图像。由于 `1000px` 大于 `300px`，浏览器会选择将 `1000px` 分配给第一列。

这意味着，我们需要重新计算剩余空间。

新的剩余空间是 `1260px - 1000px - 20px * 3 = 200px`；然后根据剩余部分的数量将这 `200px` 除以三。每个部分是 `66px`。我希望这能够解释为什么 `fr` 单位不总是创建等宽列。

如果你希望 `fr` 单位每次都创建等宽列，则需要使用 `minmax(0, 1fr)` 去强制指定它。对于此特定示例，你还需要将图像的 `max-width` 属性设置为 100％。

请参阅 [CodePen](https://codepen.io) 上 Zell Liew（[@zellwk](https://codepen.io/zellwk)）的 [CSS Grid `fr` unit demo 2](https://codepen.io/zellwk/pen/mxyXOm/)

**注意**：Rachel Andrew 撰写了一篇关于不同 CSS 值（min-content，max-content，fr等）如何影响内容大小的[文章](https://www.smashingmagazine.com/2018/01/understanding-sizing-css-layout/)。这篇文章值得一读！ 

#### 不等宽网格

只需更改 fr 倍数，就可以创建宽度不等的网格。下面是一个遵循黄金比例的网格，其中第二列是第一列的 1.618 倍，第三列是第二列的 1.618 倍。

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1.618fr 2.618fr;
  grid-column-gap: 1em;
}
```

[![GIF shows a three-column grid created with the golden ratio. When the browser is resized, the columns resize accordingly.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/18f3c1ee-74f1-4bdc-b747-1019285f671b/future-web-design-grid-fr-asym.gif)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/18f3c1ee-74f1-4bdc-b747-1019285f671b/future-web-design-grid-fr-asym.gif) 

用黄金比例创建的三列网格。

#### 在不同的断点改变网格

如果你想要在不同的断点处更改网格，则可以在媒体查询中声明新的网格。

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-column-gap: 1em;
}

@media (min-width: 30em) {
  .grid {
    grid-template-columns: 1fr 1fr 1fr 1fr;
  }
}
```

使用 CSS Grid 创建网格很难吗？要是产品经理知道是这么简单的话，设计师和开发人员早就被干掉了。

#### 基于高度的网格

之前根据网站的高度来制作网格是不可能的，因为我们没有办法获取视口的高度。现在，通过视口单元（viewport units）、CSS Calc 和 CSS Grid，我们甚至可以根据视口高度制作网格。

在下面的演示中，我根据浏览器的高度创建了网格方形。

请参阅 [CodePen](https://codepen.io) 上 Zell Liew（[@zellwk](https://codepen.io/zellwk)）的 [Height based grid example](https://codepen.io/zellwk/pen/qoEYaL/)。

Jen Simmons 有一个很棒的视频，讲述了[四维空间设计](https://www.youtube.com/watch?v=dQHtT47eH0M&feature=youtu.be) —— 使用 CSS Grid。我强烈建议你去看看。

#### 网格项的放置

在过去，定位网格项是一种很大的痛苦，因为你必须计算 `margin-left` 属性。

现在，使用 CSS Grid，你可以直接使用 CSS 放置网格项而无需额外的计算。 

```
.grid-item {
  grid-column: 2; /* 放在第二列 */
}
```

[![Screenshot of a grid item placed on the second column](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bf790516-2d0d-4078-aac0-6a1d9357a74b/future-web-design-grid-placement.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bf790516-2d0d-4078-aac0-6a1d9357a74b/future-web-design-grid-placement.png) 

在第二列放置一个项目。

你甚至可以通过 `span` 关键字告诉网格项应该占用多少列。

```
.grid-item {
  /* 放在第二列，跨越 2 列 */
  grid-column: 2 / span 2;
}
```

[![Screenshot of a grid item that's placed on the second column. It spans two columns](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a66e3449-3bd9-40ff-8fe2-6116c0939d77/future-web-design-grid-placement-span.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a66e3449-3bd9-40ff-8fe2-6116c0939d77/future-web-design-grid-placement-span.png) 

你可以使用 `span` 关键字来告诉网格项应该占用的列数（或行数）。

#### 启示

CSS Grid 能够使你能够轻松地布置事物，以便你可以快速地创建许多同一网站的不同变体。一个最好的例子是 [Lynn Fisher 的个人主页](https://lynnandtonic.com)。

如果你想了解更多关于 CSS Grid 可以做什么的内容，请查看 [Jen Simmon 的实验室](http://labs.jensimmons.com)，在那里她将探索如何使用 CSS Grid 和其他工具创建不同类型的布局。

要了解关于 CSS Grid 的更多信息，请查看以下资源：

*   [Master CSS Grid](http://mastercssgrid.com)，Rachel Andrew 和 Jen Simmons
    视频教程
*   [Layout Land](https://www.youtube.com/channel/UC7TizprGknbDalbHplROtag)，Jen Simmons
    关于布局的一系列视频
*   [CSS layout workshop](https://thecssworkshop.com)，Rachel Andrew
    一个 CSS 布局课程
*   [Learn CSS Grid](https://learncssgrid.com)，Jonathan Suh
    一个关于 CSS Grid 的免费课程
*   [Grid critters](https://geddski.teachable.com/p/gridcritters)，Dave Geddes
    一种学习 CSS Grid 的有趣方法

### 使用不规则形状进行设计

我们习惯于在网页上创建矩形布局，因为 CSS 盒子模型是一个矩形。除了矩形之外我们还找到了创建简单形状的方法，例如三角形和圆形。

今天，我们不需要因为创建不规则形状而止步不前。使用 CSS 形状和 `clip-path`，我们可以毫不费力地创建不规则的形状。

例如，[Aysha Anggraini](https://twitter.com/RenettaRenula) 尝试使用 CSS Grid 和 `clip path` 创建一个 comic-strip-inspired 布局。

```
<div class="wrapper">
  <div class="news-item hero-item">
  </div>
  <div class="news-item standard-item">
  </div>
  <div class="news-item standard-item">
  </div>
  <div class="news-item standard-item">
  </div>
</div>
```

```
.wrapper {
  display: grid;
  grid-gap: 10px;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: 1fr;
  max-width: 1440px;
  font-size: 0;
}

.hero-item,
.standard-item {
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.news-item {
  display: inline-block;
  min-height: 400px;
  width: 50%;
}

.hero-item {
  background-image: url('https://s3-us-west-2.amazonaws.com/s.cdpn.io/53819/divinity-ori-sin.jpg');
}

.standard-item:nth-child(2) {
  background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/53819/re7-chris-large.jpg");
}

.standard-item:nth-child(3) {
  background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/53819/bioshock-large.jpg");
}

.standard-item:nth-child(4) {
  background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/53819/dishonored-large.jpg");
}

@supports (display: grid) {
  .news-item {
    width: auto;
    min-height: 0;
  }
  
  .hero-item {
    grid-column: 1 / span 2;
    grid-row: 1 / 50;
    -webkit-clip-path: polygon(0 0, 100% 0, 100% calc(100% - 75px), 0 100%);
    clip-path: polygon(0 0, 100% 0, 100% calc(100% - 75px), 0 100%);
  }

  .standard-item:nth-child(2) {
    grid-column: 1 / span 1;
    grid-row: 50 / 100;
    -webkit-clip-path: polygon(0 14%, 0 86%, 90% 81%, 100% 6%);
    clip-path: polygon(0 14%, 0 86%, 90% 81%, 100% 6%);
    margin-top: -73px;
  }

  .standard-item:nth-child(3) {
    grid-column: 2 / span 1;
    grid-row: 50 / 100;
    -webkit-clip-path: polygon(13% 6%, 4% 84%, 100% 100%, 100% 0%);
    clip-path: polygon(13% 6%, 4% 84%, 100% 100%, 100% 0%);
    margin-top: -73px;
    margin-left: -15%;
    margin-bottom: 18px;
  }

  .standard-item:nth-child(4) {
    grid-column: 1 / span 2;
    grid-row: 100 / 150;
    -webkit-clip-path: polygon(45% 0, 100% 15%, 100% 100%, 0 100%, 0 5%);
    clip-path: polygon(45% 0, 100% 15%, 100% 100%, 0 100%, 0 5%);
    margin-top: -107px;
  }
}
```

请参阅 [CodePen](https://codepen.io) 上 Aysha Anggraini（[@rrenula](https://codepen.io/rrenula)）的 [Comic-book-style layout with CSS Grid](https://codepen.io/rrenula/pen/LzLXYJ/)。

[Hui Jing](https://twitter.com/hj_chen) 解释了如何使用 CSS 形状，[使文本能够沿着碧昂丝的曲线流动](https://www.chenhuijing.com/blog/why-you-should-be-excited-about-css-shapes/) 。

[![An image of Huijing's article, where text flows around Beyoncé.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e2b60894-b7dd-41ac-94dd-b87a6bdf3cbc/future-web-design-beyonce.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e2b60894-b7dd-41ac-94dd-b87a6bdf3cbc/future-web-design-beyonce.png) 

如果你愿意，文本可以在碧昂丝周围流动！

如果你想深入挖掘，[Sara Soueidan](https://twitter.com/SaraSoueidan) 的文章可以帮助你[创建非矩形布局](https://www.sarasoueidan.com/blog/css-shapes/)。

CSS 形状和 `clip-path` 为你提供无限的可能性来创建属于你设计的且独一无二的自定义形状。不幸的是，在语法上，CSS 形状和 `clip-path` 并不像 CSS Grid 那么直观。 幸运的是，我们有诸如 [Clippy](https://bennettfeely.com/clippy/) 和 [Firefox’s Shape Path Editor](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_CSS_shapes) 来帮助我们创建我们想要的形状。

[![Image of Clippy, a tool to help you create custom CSS shapes](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c101607-4aac-4fa9-a968-62a33133331c/future-web-design-clippy.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c101607-4aac-4fa9-a968-62a33133331c/future-web-design-clippy.png) 

Clippy 可帮助你使用 `clip-path` 轻松创建自定义形状。 

###  使用 CSS 的 `writing-mode` 切换文本流

我们习惯于在网络上看到从左到右的文字排版，因为网络一开始主要是为讲英语的人们制作的。

但有些语言不是朝这个方向进行文字排版的。例如，中文可以自上而下阅读，也可以从右到左阅读。

CSS 的 `writing-mode` 可以使文本按照每种语言原生的方向流动。Hui Jing 尝试了一种中国式布局，在一个名为 [Penang Hokkien](http://penang-hokkien.gitlab.io) 的网站上自上而下，从右到左流动。你可以在她的文章“[The One About Home](https://www.chenhuijing.com/blog/the-one-about-home/#🏀)”中阅读更多关于她的实验。

除了文章之外，Hui Jing 在排版和 `writing-mode` 方面进行了精彩的演讲，“[When East Meets West: Web Typography and How It Can Inspire Modern Layouts](https://www.youtube.com/watch?v=Tqxo269aORM)”。我强烈建议你观看它。

[![An image of the Penang Hokken, showcasing text that reads from top to bottom and right to left.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2f69df2b-18d2-4da4-8e44-22226ef0becd/future-web-design-penang-hokkien.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2f69df2b-18d2-4da4-8e44-22226ef0becd/future-web-design-penang-hokkien.png) 

槟城福建人（Penang Hokkien）表示中文文本可以从上到下，从右到左书写。

即使你不设计像中文那样语言，也不意味着你无法将 CSS 的 `writing-mode` 应用于英文。早在2016年，当我创建 [Devfest.asia](https://2016.devfest.asia/community/) 时，我灵光一闪，选择使用 `writing-mode` 旋转文字。

[![An image that shows how I rotated text in a design I created for Devfest.asia](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/70acafa4-5454-4257-bbdd-3f5fe18d3696/future-web-design-devfest.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/70acafa4-5454-4257-bbdd-3f5fe18d3696/future-web-design-devfest.png) 

标签是使用 `writing-mode` 和转换创建的。

[Jen Simmons 的实验室](http://labs.jensimmons.com) 也包含许多关于 `writing-mode` 的实验。我强烈建议你也看一下。

[![An image from Jen Simmon's lab that shows a design from Jan Tschichold.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4f024681-c86e-4009-89aa-1ff379e71e8a/future-web-design-lab.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4f024681-c86e-4009-89aa-1ff379e71e8a/future-web-design-lab.png) 

Jen Simmon 实验室的图片显示了 Jan Tschichold。

### 努力和创造力能使人走得更远

尽管新的 CSS 工具很有帮助，但你并不是一定需要它们中的任何一个才能创建独特的网站。一点点聪明才智和一些努力都需要走很长的路。

例如，在 [Super Silly Hackathon](https://supersillyhackathon.sg) 中，[Cheeaun](https://twitter.com/cheeaun) 将整个网站旋转-15度，当你在阅读网站时，你会看起来像个傻子。

[![A screenshot from Super Silly Hackthon, with text slightly rotated to the left](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e308a830-ba6a-431c-8e5d-c4128cad965a/future-web-design-supersilly.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e308a830-ba6a-431c-8e5d-c4128cad965a/future-web-design-supersilly.png) 

如果你想进入 Super Silly Hackathon，Cheeaun 会确保你看起来很傻。

[Darin Senneff](https://twitter.com/dsenneff) 制作了一个带有一些三角和 GSAP 的[动画登录头像](https://codepen.io/dsenneff/pen/QajVxO)。看看这只猿是多么的可爱，以及当你的鼠标光标位于密码框时它是如何遮住眼睛的。卡哇伊！

![](https://i.loli.net/2018/05/23/5b0528b7e755a.png)

当我为我的课程 [Learn JavaScript](https://learnjavascript.today) 创建销售页面时，我添加了让JavaScript学习者感到宾至如归的元素。 

[![Image where I used JavaScript elements in the design for Learn JavaScript.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6b66f918-dc6f-4da1-870e-aa6b5ea8029c/future-web-design-learnjavascript.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6b66f918-dc6f-4da1-870e-aa6b5ea8029c/future-web-design-learnjavascript.png) 

我使用 `function` 语法来创建课程包，而不是普通地编写有关课程包的信息。

### 总结

独特的网页设计不仅仅是布局设计，而是关于设计如何与内容整合。只需付出一点努力和创造性，我们所有人都可以创造独一无二的设计并广而告之，如今我们可以使用的工具让我们的工作更轻松。

问题是，你是否足够在意制作出独一无二的设计呢？我希望你是。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
