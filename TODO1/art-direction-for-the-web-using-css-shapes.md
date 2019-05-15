> * 原文地址：[Art Direction For The Web Using CSS Shapes](https://www.smashingmagazine.com/2019/04/art-direction-for-the-web-using-css-shapes/)
> * 原文作者：[Andy Clarke](https://stuffandnonsense.co.uk/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/art-direction-for-the-web-using-css-shapes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/art-direction-for-the-web-using-css-shapes.md)
> * 译者：[xujiujiu](https://github.com/xujiujiu)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234), [cyz980908](https://github.com/cyz980908), [portandbridge](https://github.com/portandbridge)

# Web 使用 CSS Shapes 的艺术设计

> “[web 的艺术设计](https://www.smashingmagazine.com/printed-books/art-direction-for-the-web/)” 的作者及设计师 Andy Clarke，在使用 CSS 创造令人惊喜的新设计时，从未害怕突破边界。在本教程中，他超越了基本的 CSS 形状，并展示了如何使用它们为你艺术的设计创建五种独特且有趣的布局。

去年，Rachel Andrew 写了一篇文章，[重新审视 CSS Shapes](https://www.smashingmagazine.com/2018/09/css-shapes/) ，其中为读者重新介绍了 CSS Shapes 基础的使用。对于任何渴望了解如何使用 `shape-outside`、`shape-margin` 和 `shape-image-threshold` 等属性的人来说，这篇文章是理想的入门读物。

我曾经见过很多用这些属性的例子，但是很少见到 Shapes 的高级用法，包括 `circle()`、`ellipse()`、`inset()`。甚至连使用 `polygon()` 的例子少之更少。考虑到 CSS Shapes 提供的创造性机会，这种现象也太令人失望了。但是，我确信只要有一点灵感和想象力，我们就可以制作出更具特色和吸引力的设计。所以，接下来，我将向你展示如何使用 CSS Shapes 创建以下五种不同类型的布局：

1. [V 型](#1-v-型)
2. [Z 型](#2-Z-型)
3. [弯曲型](#3-弯曲型)
4. [对角线型](#4-对角线型)
5. [旋转型](#5-对角线型)

### 一点启发

遗憾的是，你在一些使用 CSS Shapes 的网站中找不到许多令人有启发的例子。但这并不意味着那里没有灵感 — 你只需要往深处寻找，比如广告、杂志和海报的设计。然而，如果只是模仿上一个时代的媒体对我们来说是愚蠢的。

![你可以在意想不到的地方找到灵感，例如这些古董广告。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a92a6d6e-3e23-44dd-83ac-7d67831e81f4/img-1.png)

你可以在意想不到的地方找到灵感，例如这些古董广告。

在过去几年里，我已经在 Dropbox 文件夹放满了我的灵感，我真的应该把这些实例转移到 Pinterest 上。幸运的是，比我勤奋的 Kristopher Van Sant 已经在收集一个充满启发性的 [‘形状文本’的例子](https://www.pinterest.co.uk/kisstafurr/shapes-of-text/) 的 Pinterest 板了。

形状为设计增加了活力，而且这种操作吸引了人们。它们有助于**将观众与你的故事联系起来**，并在你的视觉和书面内容之间建立更紧密的联系。

当你需要内容在形状周围流动时，使用 `shape-outside` 属性。你必须向左或者向右浮动元素，以便 `shape-outside` 产生效果。

```css
img {
  float: <values>;
  shape-outside: <values>;
}
```

**注意：当有流动的内容围绕在形状的周围时，请注意不要让任何文本行变得太窄而只能容纳一两个单词。**

开发动态和原始的布局通常需要极少的标签。这五个设计系列的 HTML 只包含标题和主要元素、图形、图像，并且通常不会比下面的更复杂：

```html
<header role="banner">
  <h1>Mini Cooper</h1>
</header>

<figure>
  <img src="mini.png" alt="Mini Cooper">
</figure>

<main>
…
</main>
```

### 1. V 型

对我来说，现代 CSS 一个超棒的地方就是，我不用绘制多边形路径，就可以用部分透明图像的 alpha 通道创建一个形状。我仅需要创建一个图像，剩下的事情浏览器都可以处理。

我认为这是 CSS 中最令人惊喜的补充之一，它使得开发 Web 艺术设计更加简单，特别是在你开发内容管理系统或动态生成的内容时。

![左：没有 CSS 形状，这种设计感觉枯燥无生气。右图：创建 V 形使这种设计更具特色和吸引力。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/165e495e-1a22-449a-9d86-192fa6dec7be/img-3-4.png)

左图：没有 CSS 形状，这种设计感觉枯燥无生气。右图：创建 V 形使这种设计更具特色和吸引力

要从图像中创建形状，它们必须具有完全或部分透明的 alpha 通道。在第一个设计中，我不需要绘制多边形以使内容在两侧的三角形形状之间流动；相反，我只需要指定图像文件的 URL 作为 `shape-outside` 值：

```css
[src*="shape-left"],
[src*="shape-right"] {
  width: 50%;
  height: 100%;
}

[src*="shape-left"] {
  float: left;
  shape-outside: url('alpha-left.png');
}

[src*="shape-right"] {
  float: right;
  shape-outside: url('alpha-right.png');
}
```

![一个 CSS 形状的例子](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/292b2666-7718-49b4-b82a-54052f1bbfc7/img-4.png)

使用图像开发形状时，请注意 CORS（跨源资源共享）。图像必须与产品或网站托管在同一个域里。如果你使用 CDN，请确保它发送正确的标头以启用形状。值得注意的是，在本地测试形状的唯一方法是使用 Web 服务器。`file://` 协议根本不起作用。

#### Generated Content 模块

正如 Rachel 在她文章中说的那样：

> “你还可以用一张图片作为形状的路径来做出弯曲文本的效果，而且在页面上可以不显示这张图片。但是，你仍需要浮动一些内容，因此，我们可以使用 Generated Content 模块。”

作为 alpha 通道的替代，我可以使用 Generated Content — 应用于两个伪元素 — 一个用于左边的多边形，另一个用于右边。运行的文本将在两个生成的形状之间流动：

```css
main::before {
  content: "";
  display: block;
  float: left;
  width: 50%;
  height: 100%;
  shape-outside: polygon(0 0, 0 100%, 100% 100%);
}

main p:first-child::before {
  content: "";
  display: block;
  float: right;
  width: 50%;
  height: 100%;
  shape-outside: polygon(100% 0, 0 100%, 100% 100%);
}
```

**注意：Bennett Feely 的 [CSS clip-path 制作](http://bennettfeely.com/clippy/) 是一个很棒的工具，用于计算与 CSS Shapes 一起使用的坐标值。**

![在多个转折点处调整 alpha 图像的宽度，使之能够展示文本形状，以完美匹配其视口。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e55053ee-9096-4093-8bd5-4fd93a4e3411/img-5-6.png)

在多个转折点处调整 alpha 图像的宽度，就能让流动文本的形状完美匹配其视口。

### 2. Z 型

当从左到右，从上到下阅读时，Z 型是我们眼睛所遵循的熟悉路径。通过沿着 Z 形的隐藏线放置内容，有助于引导读者沿着我们希望的路径阅读，例如 Call-To-Action（行动召唤）。低调的做法是用焦点或具有更高视觉重量的元素暗示，明显的做法则是使用 CSS Shapes。

![在两个形状之间放入一小段文本，会形成一个 Z 形，它表明了在驾驶这款标志性小型车时，人们会感受到的速度和乐趣](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57236ebd-12ee-4e43-8bde-55ee99b7de76/img-8.png)

在两个形状之间放入一小段文本，会形成一个 Z 形，它表明了在驾驶这款标志性小型车时，人们会感受到的速度和乐趣。

在这个设计中，一个不明显的 Z 型形成如下:

1. 大图片横穿整个页面宽度，右对齐的标题强调断点。
2. 运行文本块由两个 CSS Shapes 组成。
3. 作为页脚的图形上的厚顶边框完成了 Z 型。

没有必要使用复杂的标签来实现这个设计，我的 HTML 简单到只包含下面三个元素：

```html
<header role="banner">
  <h1>Mini Cooper:icon of the ’60s</h1>
  <img src="banner.png" alt="Mini Cooper">
</header>

<main>
  <img src="placeholder-left.png" alt="" aria-hidden="true">
  <img src="placeholder-right.png" alt="" aria-hidden="true">
  …
</main>

<figure role="contentinfo">
…
</figure>
```

横跨整页的标题和图形的设计没什么需要说明的，但是两个多边形之间的流动文本设计有点复杂。为了实现这种 z 型设计，我选择将两个 1 x 1 px 的微小图像，放置到使用 `shape-outside` 的两个大的形状图像上。通过给这些图像设置 `aria-hidden` 属性，浏览器就不会绘制他们。

给两个形状图像提供相同的尺寸后，我向左浮动一个图像，向右浮动另一个图像，这样我的运行文本就可以在它们之间流动：

```css
[src*="placeholder-left"],
[src*="placeholder-right"] {
  display: block;
  width: 240px;
  height: 100%;
}

[src*="placeholder-left"] {
  float: left;
  shape-outside: url('shape-right.png');
}

[src*="placeholder-right"] {
  float: right;
  shape-outside: url('shape-right.png');
}
```

![左图：一种缺乏活力的可展现但却很普通的设计。右图：使用 CSS Shapes 展示了乐趣和速度。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e00dcb8e-642b-43ec-947b-349fea165d1d/img-7-8.png)

左图：一种缺乏活力的可展现但却很普通的设计。右图：使用 CSS Shapes 展示了乐趣和速度。

标志性的 Mini Cooper 驾驶起来快速而有趣。即使不用 CSS Shapes 做出的 Z 型布局也能完美呈现页面，但这种设计看起来很普通并且缺乏活力。但通过操作两个形状之间的一小段流动文本，便可以创建的 Z 型布局，这种布局暗示了驾驶这辆标志性小型车时的速度和乐趣。

### 3. 弯曲型

CSS Shapes 最迷人的一个方面是如何使用部分透明图像中的 alpha 通道创建优雅的形状。这种形状可以是我想象到的任何东西。我只需要创建一个图像，浏览器将会在它周围流动内容。

虽然 [CSS Shapes 模块 2 级规范](https://drafts.csswg.org/css-shapes-2/) 中已经提出将内容限制在形状内，但目前无法知道是否以及何时可以在浏览器中实现。不过，虽然 `shape-inside`（暂时）不可用，这并不代表我用 `shape-outside` 创建不出类似的结果。

![左：另一个可展示但普通的设计。右：使用 CSS Shapes 创建更独特的外观。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4913ceec-6073-42f4-bd21-03b6f0ffe3e0/img-9-10.png)

左：另一个可展示但普通的设计。右：使用 CSS Shapes 创建更独特的外观。

通过将我的内容限制在右侧浮动的曲线图像中，我可以轻松地为下一个设计添加独特的外观。为了创建形状，我再次使用 `shape-outside` 属性，这次使用的值与可见图像的 URL 相同：

```css
[src*="curve"] {
  float: right;
  width: 400px;
  height: 100vh;
  shape-outside: url('curve.png');
}
```

为了在我的形状和在其周围流动的内容之间留出一些距离，`shape-margin` 属性在第一个形状的轮廓之外绘制出更多的形状。我可以使用任何 CSS 绝对长度单位 — 毫米、厘米、英寸、派卡、像素和点 — 或相对单位（`ch`、`em`、`ex`、`rem`、`vh` 和 `vw`）：

```css
[src*="curve"] {
  shape-margin: 3rem;
}
```

#### 更多的边距

为这种弯曲的设计添加移动文本不仅仅依赖于 CSS 形状。使用视口宽度单位，我为标题，图像和运行文本提供不同的左边距，每个边距与视口的宽度成比例。这会从我的标题尾部到汽车头部形成一条对角线：

```css
h1 {
  margin-left: 5vw;
}

img {
  margin-left: 10vw;
}

p {
  margin-left: 20vw;
}
```

### 4. 对角线型

角度可以使布局看起来不那么结构化，感觉更有生机。不设置明确的结构，能让视野在组合物周围自由漫游。这种操作也能产生一种有活力的布局。

我每天看到都是绕水平轴和垂直轴设置的设计，基于对角线的很稀少。每隔一段时间，我就会看到一个有角度的元素 - 也许是一个底部倾斜的横幅图形 - 但它对设计来说并没有什么必要。

![在印刊设计中经常看到内容在形状周围流动，在 CSS Shapes 之前，这在 web 上是不可能实现的](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8ab6fcc-9f78-470b-aa03-1b87ec597c6b/img-11-12.png)

在印刊设计中经常看到内容在形状周围流动，在 CSS Shapes 之前，这在 web 上是不可能实现的。

即使 CSS Grid 只涉及到列和行的设置，也没有理由不使用它来创建动态对角线。下一个设计只需要一个标题和主要元素：

```html
<header role="banner">
  <h1>Mini Cooper</h1>
  <img src="banner.png" alt="Mini Cooper">
</header>

<main>
  <img src="shape.png" alt="">
  …
</main>
```

为了在这个设计中创建对角线细节，我再次围绕一个向左浮动的形状图像流动内容。我再次使用 `shape-outside` 属性，其 URL 与可见图像相同，并在我的形状和围绕它的内容之间使用 `shape-margin` 设置距离：

```css
[src*="shape"] {
  float: left;
  shape-outside: url('shape.png');
  shape-margin: 3rem;
}
```

鉴于响应式是网络的内在属性之一，我们很难预测内容将如何流动，但我们可以避免像这样的设计。如果所有正在运行的文本因为空间太小而无法适应形状，那每个形状都浮动意味着内容将流入到形状下方的空间。

### 5. 旋转型

为什么要满足于只使用 CSS Grid 和 Shapes 呢？有些几年前难以想象的布局，现在只要再引入 Transforms 就能做出来了。在最后一个例子中，要做到围绕图像中的汽车流动文本，同时旋转整个布局，需要这些属性的所有组合。

![为什么只使用 CSS Grid 和 Shapes？](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/72c40e9f-fe9c-4253-a146-022ad53778c1/img-13.png)

为什么只使用 CSS Grid 和 Shapes？

由于这些汽车的图像没有透明的 alpha 通道，因此，在形状周围的流动文本需要包含仅包含 alpha 通道信息的第二个图像。

![实现这种设计需要两个图像：一个可见，另一个要有 alpha 通道信息。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4970459c-3ad8-4182-b089-965f233d2671/img-14.png)

实现这种设计需要两个图像：一个可见，另一个要有 alpha 通道信息。

这一次，我向右浮动可见图像并应用 `shape-outside` 属性，其 URL 与我的 alpha 通道图像一样：

```css
[src*="shape"] {
  float: right;
  width: 50%;
  shape-outside: url('alpha.png');
  shape-margin: 1rem;
}
```

你可能已经注意到我的两个图像都包含了我顺时针旋转了 10 度的元素。这些图像就位后，我可以朝相反的方向上旋转整个布局 10 度，以给出我的图像直立的错觉：

```css
body {
  transform: rotate(-10deg);
}
```

![我将此布局旋转到足以使设计更具吸引力的角度，但却不会牺牲可读性。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7b3dddc2-c5b3-4e24-b65a-bc6368981523/img-15-16.png)

我将此布局旋转到足以使设计更具吸引力的角度，但却不会牺牲可读性。

### 栗子免费送：多边形形状塑造列

**摘自 2019 年 3 月 26 日的“网上艺术指南”。**

你可以创建仅具有类型的强大结构形状。结合 `polygon()` 形状和伪元素，你可以从运行文本的实体块中创建形状，就像 [Alexey Brodovitch](https://en.wikipedia.org/wiki/Alexey_Brodovitch) 的风格和他对 Harper’s Bazaar 有影响力的作品一样。

![左：这些漂亮的数字太可爱了。它们也非常适合刻在那些内容上。右：当我使用没有背景或边框的不可见伪元素来开发多边形时，结果是两个异常形状的内容。](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b7832cb6-7eed-42e9-973b-3ddc0f7d5282/img-17-18.png)

左：这些漂亮的数字太可爱了。它们也非常适合刻在那些内容上。右：当我使用没有背景或边框的不可见伪元素来开发多边形时，结果是两个异常形状的内容。

我用两个文章构成这些列，即它们之间有一个沟槽和最大宽度，这有助于保持舒适度：

```css
body {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-gap: 2vw;
  max-width: 48em;
}
```

因为有两个文章元素，我还为我的网格指定了两列，所以没有必要具体说明这些文章的位置。我可以让浏览器为我放置它们，剩下的就是将 `shape-outside` 应用于每列中生成的伪元素：

```css
article:nth-of-type(1) p:nth-of-type(1)::before {
  content: "";
  float: left;
  width: 160px;
  height: 320px;
  shape-outside: polygon(0px 0px, 90px 0px, [...]);
}

article:nth-of-type(2) p:nth-of-type(2)::before {
  content: "";
  float: right;
  width: 160px;
  height: 320px;
  shape-outside: polygon(20px 220px, 120px 0px, [...]);
}
```

### 成果

现在 Firefox 已经发布了一个支持 CSS Shapes 的版本，并在其开发工具中启动了一个 Shape Path Editor 插件，目前只有 Edge 不支持 CSS Shapes。由于微软宣布将他们自己的 EdgeHTML 渲染引擎改为 Chromium 的 Blink 引擎（一个与 Chrome 和 Opera 相同的引擎），这种情况很快就会改变。

像 CSS Shapes 这样的工具现在为我们提供了无数可以利用艺术设计吸引读者的注意力并让他们保持参与的机会。我希望你现在和我一样兴奋！

**编者注: Andy 的新书，《Web 艺术设计》（[预购地址](https://www.smashingmagazine.com/printed-books/art-direction-for-the-web/)），探索了 100 年的艺术设计，以及我们如何利用这些知识和最新的网络技术来创造更好的数字产品。[阅读摘录章节](http://provide.smashingmagazine.com/eBooks/Art-direction-FTW-excerpt.pdf?_ga=2.206394323.1550887490.1554923173-204951999.1554923173)，了解这本书的内容。**

#### 更多资源

* “[《Web 的艺术设计》](http://artdirectionfortheweb.com)” Andy Clarke 著
* “[《重新审视 CSS Shapes》](https://www.smashingmagazine.com/2018/09/css-shapes/)” Rachel Andrew 著
* “[CSS Shapes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Shapes)” MDN 网络文档，Mozilla
* “[在 CSS 上编辑形状路径](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_CSS_shapes)” MDN 网络文档，Mozilla
* “[Web 的艺术设计：一本新的畅销书](https://www.smashingmagazine.com/2019/03/art-direction-release/)” Smashing 杂志

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
