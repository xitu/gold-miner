> * 原文地址：[Easy and Responsive Modern CSS Grid Layout](https://www.sitepoint.com/easy-responsive-modern-css-grid-layout/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Ahmed Bouchefra](https://www.sitepoint.com/author/abouchefra/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md](https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：[CoolRice](https://github.com/CoolRice)

# 简单的响应式现代 CSS 网格布局

**在本文中，我们将展示如何创建响应式现代 CSS 网格布局，演示如何在旧浏览器上使用降级代码，如何逐步添加 CSS 网格，如何使用对齐属性重新构建小型设备的布局以及居中元素。**

在之前的[文章](https://www.sitepoint.com/easy-responsive-css-grid-layouts/)中，我们探索了四种不同的技术，可以轻松构建响应式网格布局。那篇文章是在 2014 年写的 —— 在 CSS 网格可用之前 —— 因此在本教程中，我们将使用类似的 HTML 结构，但使用现代 CSS 网格布局。

在本教程中，我们将使用浮动来创建一个带有基本布局的演示项目，然后使用 CSS 网格对其进行增强。我们将演示许多有用的实用工具，例如居中元素，跨越元素，以及通过重新定义网格区域和使用媒体查询轻松更改小型设备上的布局。你可以在此 pen 中找到代码：[https://codepen.io/SitePoint/pen/OweYNp](https://codepen.io/SitePoint/pen/OweYNp)

## 响应式现代 CSS 网格布局

在我们开始创建响应式网格演示项目之前，首先介绍一下 CSS 网格。

CSS 网格是一个功能强大的二维系统，在 2017 年被添加到大多数现代浏览器中。它极大地改变了我们创建 HTML 布局的方式。网格布局允许我们在 CSS 而不是 HTML 中创建网格结构。

除了 IE11 之外，大多数现代浏览器都支持 CSS 网格，IE11 支持可能产生一些问题的旧版标准。你可以使用 [caniuse.com](https://caniuse.com/#feat=css-grid) 来检查支持情况。

网格布局有一个 `display` 属性为 `grid` 或 `inline-grid` 的父容器。容器的子元素是网格项，由强大的网格算法隐式定位。你还可以应用不同的类来控制网格项的放置，尺寸，位置和其他方面的东西。

让我们从一个基本的 HTML 页面开始。创建 HTML 文件并添加以下内容：

```
<header>
    <h2>CSS Grid Layout Example</h2>
</header>
<aside>
  .sidebar
</aside>

<main>
  <article>
    <span>1</span>
  </article>
  <article>
    <span>2</span>
  </article>
  <!--... -->
  <article>
    <span>11</span>
  </article>
</main>

<footer>
  Copyright 2018
</footer>
```

我们使用 HTML 语义标签来定义页面的头部，侧边栏，主体和页脚部分。在主体部分中，我们使用 `<article>` 标签添加一组子项。`<article>` 是一个 HTML5 语义标签，可用于包装独立和自包含的内容。单个页面可以包含任意数量的 `<article>` 标签。

这是此阶段页面的屏幕截图：

![The basic HTML layout so far](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534467147basic-html.png)

接下来，让我们添加基本的 CSS 样式。在文档的头部添加 `<style>` 标签并添加以下样式：

```
body {
  background: #12458c;
  margin: 0rem;
  padding: 0px;
  font-family: -apple-system, BlinkMacSystemFont,
            "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell",
            "Fira Sans", "Droid Sans", "Helvetica Neue",
            sans-serif;
}

header {
  text-transform: uppercase;
  padding-top: 1px;
  padding-bottom: 1px;
  color: #fff;
  border-style: solid;
  border-width: 2px;
}

aside {
  color: #fff;
  border-width:2px;
  border-style: solid;
  float: left;
  width: 6.3rem;
}

footer {
  color: #fff;
  border-width:2px;
  border-style: solid;
  clear: both;
}

main {
  float: right;
  width: calc(100% - 7.2rem);
  padding: 5px;
  background: hsl(240, 100%, 50%);
}

main > article {
  background: hsl(240, 100%, 50%);
  background-image: url('https://source.unsplash.com/daily');
  color: hsl(240, 0%, 100%);
  border-width: 5px;
}
```

这是一个小型演示页面，因此我们将直接设置标签样式以提高可读性，而不是应用类命名系统。

我们使用浮动将侧边栏定位到左侧，将主体部分定位到右侧，将侧边栏的宽度设置为固定的 **6.3rem**。然后我们使用 CSS `calc()` 函数来计算并设置主体部分可用的剩余宽度。主体部分包含一些垂直排列的子项。

![A gallery of items organized as vertical blocks](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534467330gallery-1024x249.png)

布局并不完美。例如，侧边栏与主体内容部分的高度并不相同。有各种 CSS 技术可以解决这些问题，但大多数都是 hack 或变通方法。由于此布局是网格的降级，因此快速减少的用户也可以看到效果。降级是可用的，足够了。

最新版本的 Chrome，Firefox，Edge，Opera 和 Safari 都支持 CSS 网格，这意味着如果你的访问者使用这些浏览器，则无需提供降级。你还需要考虑常青浏览器。最新版本的 Chrome，Firefox，Edge 和 Safari 是**常青浏览器**。也就是说，它们会在不提示用户的情况下自动静默更新。为确保你的布局适用于每个浏览器，你可以从默认的基于浮动的降级开始，然后使用渐进增强技术应用现代网格布局。那些使用旧浏览器的用户将无法获得相同的体验，但这样足够了。

## 渐进增强：你不必全部覆盖

在降级布局的顶部添加 CSS 网格布局时，实际上不需要覆盖所有标签或使用完全独立的 CSS 样式：

* 在不支持 CSS 网格的浏览器中，你添加的网格属性将被忽略。
* 如果你使用浮动来布置元素，请记住网格项优先于浮动项。也就是说，如果将 `float: left|right` 样式添加到也是网格元素的元素（具有 `display: grid` 样式的父元素的子元素）中，则将忽略浮动以支持网格。
* 可以使用 `@supports` 规则在 CSS 中检查特定功能的支持情况。这允许我们在必要时覆盖降级样式，而旧浏览器会忽略 `@supports` 代码块。

现在，让我们在页面中添加 CSS 网格。首先，我们让 `<body>` 成为一个网格容器并设置网格列，行和区域：

```
body {
  /*...*/
  display: grid;
  grid-gap: 0.1vw;
  grid-template-columns: 6.5rem 1fr;
  grid-template-rows: 6rem 1fr 3rem;
  grid-template-areas: "header   header"
                       "sidebar content"
                       "footer footer";  
}
```

我们使用 `display:grid` 属性将 `<body>` 标记为网格容器。将网格 gap 设为 `0.1vw`。gap 允许你在网格单元格之间创建间距，而不是使用外边距。

我们用 `grid-template-columns` 来添加两列。第一列宽度固定为 `6.5rem`，第二列为剩余宽度。`fr` 是一个小数单位，`1fr` 等于可用空间的一部分。

接下来，我们用 `grid-template-rows` 添加三行。第一行高度固定为 `6rem`，第三行高度固定为 `3rem`，剩余可用空间（`1fr`）指定给第二行。

然后我们用 `grid-template-areas` 将由列和行的交集产生的虚拟单元格分配给区域。现在我们需要使用 `grid-area` 实际定义区域模板中指定的区域：

```
header {
  grid-area: header;
  /*...*/
}
aside {
  grid-area: sidebar;
  /*...*/
}
footer {
  grid-area: footer;
  /*...*/
}
main {
  grid-area: content;
  /*...*/
}
```

我们的大多数降级代码对 CSS 网格没有任何副作用，除了主体部分的宽度 `width: calc(100% - 7.2rem);`，它在减去侧边栏的宽度加上外边距/内边距后计算主体部分的剩余宽度。

这是结果的屏幕截图。注意主体区域并没有占满剩余的全部宽度：

![Progressive layout with current grid settings](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534468684current-grid-1024x665.png)

要解决此问题，我们可以在支持网格时添加 `width: auto;`：

```
@supports (display: grid) {
  main {
    width: auto;
  }
}
```

这是结果的屏幕截图：

![The effect of adding width: auto](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469049adding-width-auto-1024x667.png)

## 添加嵌套网格

网格子项可以​​是网格容器本身。让我们将主体部分作为一个网格容器：

```
main {
  /*...*/
  display: grid;  
  grid-gap: 0.1vw;
  grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr));
  grid-template-rows: repeat(auto-fill, minmax(12rem, 1fr));
}
```

我们将网格 gap 设为 `0.1vw` 并使用 `repeat(auto-fill, minmax(12rem, 1fr));` 函数定义列和行。`auto-fill` 选项会尝试使用尽可能多的列或行填充可用空间，必要时会创建隐式列或行。如果要将可用列或行放入可用空间，则需要使用 `auto-fit`。详情请阅读 [`auto-fill` 和 `auto-fit` 的差异](https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/)。

这是结果的屏幕截图：

![A nested grid](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469316nested-grid-1024x666.png)

## 使用网格 `grid-column`，`grid-row` 和 `span` 关键词

CSS 网格提供了 `grid-column` 和 `grid-row`，它们允许你使用网格线在父网格中对网格项进行定位。它们是以下属性的简写：

*   `grid-row-start`: 指定网格行中网格项的起始位置
*   `grid-row-end`: 指定网格行中网格项的结束位置
*   `grid-column-start`: 指定网格列中网格项的起始位置
*   `grid-column-end`: 指定网格列中网格项的结束位置。

你还可以使用关键字 `span` 指定要跨越的列数或行数。

我们让主体区域的第二个子项跨越四列、两行，并让其从第二列和第一行（也是它的默认位置）开始放置：

```
main article:nth-child(2) {
  grid-column: 2/span 4;
  grid-row: 1/span 2;
}
```

这是结果的屏幕截图：

![Second child spanning four columns and two rows](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469657four-col-two-row-1024x666.png)

## 使用网格对齐工具

我们想让头部，侧边栏和页脚中的文本以及 `<article>` 元素内的数字居中。

CSS 网格提供了六个属性 `justify-items`、`align-items`、`justify-content`、`align-content`、`justify-self` 和 `align-self`，可用于对齐和分散网格项。它们实际上是 [CSS 盒对齐模型](https://www.w3.org/TR/css-align-3/)的一部分。

在头部内，侧边栏，文章和页脚选择器内添加以下内容：

```
display: grid;
align-items: center;
justify-items: center;
```

* `justify-items` 用于沿行轴或在水平方向上对齐网格项。
* `align-items` 沿着列轴或在垂直方向上对齐网格项。它们都可以使用 `start`、`end`、`center` 和 `stretch`。

这是居中元素后的屏幕截图：

![Numbers are now centered horizontally and vertically in each cell](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469985centering-1024x671.png)

## 重构小型设备中的网格布局

我们的演示布局适用于中型和大型屏幕，但可能不是在小屏幕设备中构建页面的最佳方式。使用 CSS 网格，我们可以轻松地更改此布局结构，使其在小型设备中平滑过渡 —— 通过重新定义网格区域及使用媒体查询。

这是在添加代码重构小型设备上的布局之前的屏幕截图：

![The initial mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470255mobile1.png)

现在，添加以下 CSS 代码：

```
@media all and (max-width: 575px) {
  body {
    grid-template-rows: 6rem  1fr 5.5rem  5.5rem;  
    grid-template-columns: 1fr;
    grid-template-areas:
      "header"
      "content"
      "sidebar"
      "footer";
    }
}
```

在宽度 `<= 575px` 的设备上我们使用宽度分别为 `6rem`、`1fr`、`5.5rem` 和 `5.5rem` 的四行，以及占满所有可用空间的一列。我们还重新定义了网格区域，让侧边栏在小型设备上处于主体内容区域下面的第三行：

![The developing mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470445mobile2.png)

请注意，侧边栏的宽度并未占满可用宽度。这是由降级代码引起的，所以我们需要做的是在支持网格的浏览器上用 `width: auto;` 覆盖掉 `width: 6.3rem;`：

```
@supports (display: grid) {
  main, aside {
    width: auto;
  }
}
```

这是最终结果的屏幕截图：

![The final mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470564mobile3.png)

你可以在本文开头附近的 pen 中找到最终代码，也可以直接[访问此 pen](https://codepen.io/SitePoint/pen/OweYNp)。

## 结论

在本教程中，我们使用 CSS 网格创建了一个响应式演示布局。我们已经演示了如何针对旧版浏览器使用降级代码，逐步添加 CSS 网格，在小型设备中重构布局以及使用对齐属性居中元素。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
