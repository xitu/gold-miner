> * 原文地址：[Easy and Responsive Modern CSS Grid Layout](https://www.sitepoint.com/easy-responsive-modern-css-grid-layout/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Ahmed Bouchefra](https://www.sitepoint.com/author/abouchefra/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md](https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# 简单的响应式现代 CSS 网格布局

**在本文中，我们将展示如何创建响应式现代 CSS 网格布局，演示如何在旧浏览器上使用降级代码，如何逐步添加 CSS 网格，如何使用对齐属性重新构建小型设备的布局以及居中元素。**

在之前的[文章](https://www.sitepoint.com/easy-responsive-css-grid-layouts/)中，我们探索了四种不同的技术，可以轻松构建响应式网格布局。那篇文章是在 2014 年写的 —— 在 CSS 网格可用之前 —— 因此在本教程中，我们将使用类似的 HTML 结构，但使用现代 CSS 网格布局。

在本教程中，我们将使用浮动来创建一个带有基本布局的演示，然后使用 CSS 网格对其进行增强。我们将演示许多有用的实用工具，例如居中元素，跨越元素，以及通过重新定义网格区域和使用媒体查询轻松更改小型设备上的布局。你可以在此 Codepen 中找到代码：[https：//codepen.io/SitePoint/pen/OweYNp](https：//codepen.io/SitePoint/pen/OweYNp)

## 响应式现代 CSS 网格布局

在我们开始创建响应式网格演示之前，首先介绍一下 CSS 网格。

CSS 网格是一个功能强大的二维系统，在 2017 年被添加到大多数现代浏览器中。它极大地改变了我们创建 HTML 布局的方式。网格布局允许我们在 CSS 而不是 HTML 中创建网格结构。

除了 IE11 之外，大多数现代浏览器都支持 CSS 网格，IE11 支持可能产生一些问题的旧版标准。你可以使用 [caniuse.com](https://caniuse.com/#feat=css-grid) 来检查支持情况。

网格布局有一个 `display` 属性为 `grid` 或 `inline-grid` 的父容器。容器的子元素是网格项，由强大的网格算法隐式定位。你还可以应用不同的类来控制子项的放置，尺寸，位置和其他方面的东西。

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

We use HTML semantics to define the header, sidebar, main and footer sections of our page. In the main section, we add a set of items using the `<article>` tag. `<article>` is an HTML5 semantic tag that could be used for wrapping independent and self-contained content. A single page could have any number of `<article>` tags.
我们使用 HTML 语义标签来定义页面的标题，侧边栏，主体和页脚部分。在主体部分中，我们使用 `<article>` 标记添加一组子项。`<article>` 是一个 HTML5 语义标签，可用于包装独立和自包含的内容。单个页面可以包含任意数量的 `<article>` 标签。

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

We use floats to position the sidebar to the left and the main section to the right and we set the width of the sidebar to a fixed _6.3rem_ width. Then we calculate and set the remaining width for the main section using the CSS `calc()` function. The main section contains a gallery of items organized as vertical blocks.
我们使用浮动将侧边栏定位到左侧，将主体部分定位到右侧，我们将侧边栏的宽度设置为固定的 **6.3rem**。然后我们使用 CSS `calc()` 函数来计算并设置主体部分的剩余宽度。主体部分包含一个有垂直排列的子项的 gallery。

![A gallery of items organized as vertical blocks](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534467330gallery-1024x249.png)

布局并不完美。例如，侧边栏与主体内容部分的高度不同。有各种 CSS 技术可以解决这些问题，但大多数都是 hack 或变通办法。由于此布局是网格的降级，因此快速减少的用户也可以看到。降级是可用的，足够了。

最新版本的 Chrome，Firefox，Edge，Opera 和 Safari 都支持 CSS 网格，这意味着如果你的访问者使用这些浏览器，则无需提供降级。你还需要考虑常青浏览器。最新版本的 Chrome，Firefox，Edge 和 Safari 是**常青浏览器**。也就是说，它们会在不提示用户的情况下自动静默更新。为确保你的布局适用于每个浏览器，你可以从默认的基于浮动的降级开始，然后使用渐进增强技术应用现代网格布局。那些使用旧浏览器的用户将无法获得相同的体验，但这样就足够了。

## 渐进增强：你不必全部覆盖

在降级布局的顶部添加 CSS 网格布局时，实际上不需要覆盖所有标签或使用完全独立的 CSS 样式：

* 在不支持 CSS 网格的浏览器中，你添加的网格属性将被忽略。
* 如果你使用浮动来布置元素，请记住网格项优先于浮动项。也就是说，如果将 `float: left|right` 样式添加到也是网格元素的元素（具有 `display: grid` 样式的父元素的子元素），则将忽略浮动以支持网格。
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

我们使用 `display:grid` 属性将 `<body>` 标记为网格容器。我们将网格 gap 设为 `0.1vw`。gap 允许你在网格单元格之间创建间距，而不是使用外边距。

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

这是结果的屏幕截图。注意主体区域没有占用剩余的全部宽度：

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

网格子节点可以​​是网格容器本身。让我们将 main 部分作为一个网格容器：

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

CSS Grid provides `grid-column` and `grid-row`, which allow you to position grid items inside their parent grid using grid lines. They’re shorthand for the following properties:

*   `grid-row-start`: specifies the start position of the grid item within the grid row
*   `grid-row-end`: specifies the end position of the grid item within the grid row
*   `grid-column-start`: specifies the start position of the grid item within the grid column
*   `grid-column-end`: specifies the end position of the grid item within the grid column.

You can also use the keyword `span` to specify how many columns or rows to span.

Let’s make the second child of the main area span four columns and two rows and position it from column line two and row line one (which is also its default location):

```
main article:nth-child(2) {
  grid-column: 2/span 4;
  grid-row: 1/span 2;
}
```

This is a screen shot of the result:

![Second child spanning four columns and two rows](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469657four-col-two-row-1024x666.png)

## Using Grid Alignment Utilities

We want to center the text inside the header, sidebar and footer and the numbers inside the `<article>` elements.

CSS Grid provides six properties `justify-items`, `align-items`, `justify-content`, `align-content`, `justify-self` and `align-self`, which can be used to align and justify grid items. They are actually part of [CSS box alignment module](https://www.w3.org/TR/css-align-3/).

Inside the header, aside, article and footer selectors add the following:

```
display: grid;
align-items: center;
justify-items: center;
```

*   `justify-items` is used to justify the grid items along the row axis or horizontally.
*   `align-items` aligns the grid items along the column axis, or vertically. They can both take the `start`, `end`, `center` and `stretch` values.

This is a screen shot after centering elements:

![Numbers are now centered horizontally and vertically in each cell](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469985centering-1024x671.png)

## Restructuring the Grid Layout in Small Devices

Our demo layout is convenient for medium and large screens, but might not be the best way to structure the page in small screen devices. Using CSS Grid, we can easily change this layout structure to make it linear in small devices — by redefining Grid areas and using Media Queries.

This is a screen shot before adding code to re-structure the layout on small devices:

![The initial mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470255mobile1.png)

Now, add the following CSS code:

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

On devices with `<= 575px` we use four rows with `6rem`, `1fr`, `5.5rem`, and `5.5rem` widths respectively, and one column that takes all the available space. We also redefine Grid areas so the sidebar can take the third row after the main content area on small devices:

![The developing mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470445mobile2.png)

Notice that the width of the sidebar isn’t filling the available width. This is caused by the fallback code, so all we need to do is override the `width: 6.3rem;` pair with `width: auto;` on browsers supporting Grid:

```
@supports (display: grid) {
  main, aside {
    width: auto;
  }
}
```

This is a screen shot of the final result:

![The final mobile layout](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534470564mobile3.png)

You can find the final code in the pen displayed near the start of this article, or [visit the pen](https://codepen.io/SitePoint/pen/OweYNp) directly.

## Conclusion

Throughout this tutorial, we’ve created a responsive demo layout with CSS Grid. We’ve demonstrated using fallback code for old browsers, adding CSS Grid progressively, restructuring the layout in small devices and centering elements using the alignment properties.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
