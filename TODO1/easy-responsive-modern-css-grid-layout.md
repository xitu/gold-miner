> * 原文地址：[Easy and Responsive Modern CSS Grid Layout](https://www.sitepoint.com/easy-responsive-modern-css-grid-layout/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Ahmed Bouchefra](https://www.sitepoint.com/author/abouchefra/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md](https://github.com/xitu/gold-miner/blob/master/TODO1/easy-responsive-modern-css-grid-layout.md)
> * 译者：
> * 校对者：

# Easy and Responsive Modern CSS Grid Layout

**In this article, we’ll show how to create a responsive modern CSS Grid layout, demonstrating how to use fallback code for old browsers, how to add CSS Grid progressively, and how to restructure the layout in small devices and center elements using the alignment properties.**

In a previous [article](https://www.sitepoint.com/easy-responsive-css-grid-layouts/) we explored four different techniques for easily building responsive grid layouts. That article was written back in 2014 — before CSS Grid was available — so in this tutorial, we’ll be using a similar HTML structure but with modern CSS Grid layout.

Throughout this tutorial, we’ll create a demo with a basic layout using floats and then enhance it with CSS Grid. We’ll demonstrate many useful utilities such as centering elements, spanning items, and easily changing the layout on small devices by redefining grid areas and using media queries. You can find the code in this pen: https://codepen.io/SitePoint/pen/OweYNp

## Responsive Modern CSS Grid Layout

Before we dive into creating our responsive grid demo, let’s first introduce CSS Grid.

CSS Grid is a powerful 2-dimensional system that was added to most modern browsers in 2017. It has dramatically changed the way we’re creating HTML layouts. Grid Layout allows us to create grid structures in CSS and not HTML.

CSS Grid is supported in most modern browsers except for IE11, which supports an older version of the standard that could give a few issues. You can use [caniuse.com](https://caniuse.com/#feat=css-grid) to check for support.

A Grid Layout has a parent container with the `display` property set to `grid` or `inline-grid`. The child elements of the container are grid items which are implicitly positioned thanks to a powerful Grid algorithm. You can also apply different classes to control the placement, dimensions, position and other aspects of the items.

Let’s start with a basic HTML page. Create an HTML file and add the following content:

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

This is a screen shot of the page at this stage:

![The basic HTML layout so far](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534467147basic-html.png)

Next, let’s add basic CSS styling. Add a `<style>` tag in the head of the document and add the following styles:

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

This is a small demonstration page, so we’ll style tags directly to aid readability rather than applying class naming systems.

We use floats to position the sidebar to the left and the main section to the right and we set the width of the sidebar to a fixed _6.3rem_ width. Then we calculate and set the remaining width for the main section using the CSS `calc()` function. The main section contains a gallery of items organized as vertical blocks.

![A gallery of items organized as vertical blocks](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534467330gallery-1024x249.png)

The layout is not perfect. For example, the sidebar does not have the same height as the main content section. There are various CSS techniques to solve the problems but most are hacks or workarounds. Since this layout is a fallback for Grid, it will be seen by a rapidly diminishing number of users. The fallback is usable and good enough.

The latest versions of Chrome, Firefox, Edge, Opera and Safari have support for CSS Grid, so that means if your visitors are using these browsers you don’t need to worry about providing a fallback. Also you need to account for evergreen browsers. The latest versions of Chrome, Firefox, Edge, and Safari are **evergreen browsers**. That is, they automatically update themselves silently without prompting the user. To ensure your layout works in every browser, you can start with a default float-based fallback then use progressive enhancement techniques to apply a modern Grid layout. Those with older browsers will not receive an identical experience but it will be good enough.

## Progressive Enhancement: You Don’t Have to Override Everything

When adding the CSS Grid layout on top of your fallback layout, you don’t actually need to override all tags or use completely separate CSS styles:

*   In a browser that doesn’t support CSS Grid, the grid properties you add will be simply ignored.
*   If you’re using floats for laying out elements, keep in mind that a grid item takes precedence over float. That is, if you add a `float: left|right` style to an element which is also a grid element (a child of a parent element that has a `display: grid` style), the float will be ignored in favor of grid.
*   Specific feature support can be checked in CSS using `@supports` rules. This allows us to override fallback styles where necessary while older browsers ignore the `@supports` block.

Now, let’s add CSS Grid to our page. First, let’s make the `<body>` a grid container and set the grid columns, rows and areas:

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

We use the `display:grid` property to mark `<body>` as a grid container. We set a grid gap of `0.1vw`. Gaps lets you create gutters between Grid cells instead of using margins.

We also use `grid-template-columns` to add two columns. The first column takes a fixed width which is `6.5rem` and the second column takes the remaining width. `fr` is a fractional unit and `1fr` equals one part of the available space.

Next, we use `grid-template-rows` to add three rows. The first row takes a fixed height which equals `6rem`, the third row takes a fixed height of `3rem` and the remaining available space (`1fr`) is assigned to the second row.

We then use `grid-template-areas` to assign the virtual cells, resulted from the intersection of columns and rows, to areas. Now we need to actually define those areas specified in the areas template using `grid-area`:

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

Most of our fallback code doesn’t have any side effects on the CSS Grid except for the width of the main section `width: calc(100% - 7.2rem);` which calculates the remaining width for the main section after subtracting the width of the sidebar plus any margin/padding spaces.

This is a screen shot of the result. Notice how the main area is not taking the full remaining width:

![Progressive layout with current grid settings](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534468684current-grid-1024x665.png)

To solve this issue, we can add `width: auto;` when Grid is supported:

```
@supports (display: grid) {
  main {
    width: auto;
  }
}
```

This is the screen shot of the result now:

![The effect of adding width: auto](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469049adding-width-auto-1024x667.png)

## Adding a Nested Grid

A Grid child can be a Grid container itself. Let’s make the main section a Grid container:

```
main {
  /*...*/
  display: grid;  
  grid-gap: 0.1vw;
  grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr));
  grid-template-rows: repeat(auto-fill, minmax(12rem, 1fr));
}
```

We use a grid gap of `0.1vw` and we define columns and rows using the `repeat(auto-fill, minmax(12rem, 1fr));` function. The `auto-fill` option tries to fill the available space with as many columns or rows as possible, creating implicit columns or rows if needed. If you want to fit the available columns or rows into the available space, you need to use `auto-fit`. Read a good explanation of [the differences between `auto-fill` and `auto-fit`](https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/).

This is the screen shot of the result:

![A nested grid](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2018/08/1534469316nested-grid-1024x666.png)

## Using the Grid `grid-column`, `grid-row` and `span` Keywords

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
