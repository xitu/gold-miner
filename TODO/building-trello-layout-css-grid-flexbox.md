
> * 原文地址：[Building a Trello Layout with CSS Grid and Flexbox](https://www.sitepoint.com/building-trello-layout-css-grid-flexbox/)
> * 原文作者：[Giulio Mainardi](https://www.sitepoint.com/author/gmainardi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-trello-layout-css-grid-flexbox.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-trello-layout-css-grid-flexbox.md)
> * 译者：
> * 校对者：

# Building a Trello Layout with CSS Grid and Flexbox

In this tutorial, I’ll walk you through an implementation of the basic layout of a [Trello](https://trello.com/) board screen ([see example here](https://trello.com/b/nC8QJJoZ/trello-development-roadmap)). This is a responsive, CSS-only solution, and only the structural features of the layout will be developed.

For a preview, [here is a CodePen demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100) of the final result.

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/08/1504250645trello-screen.png)

Besides [Grid Layout](https://www.sitepoint.com/introduction-css-grid-layout-module/) and [Flexbox](https://www.sitepoint.com/flexbox-css-flexible-box-layout/), the solution employs [calc](https://www.sitepoint.com/css3-calc-function/) and [viewport units](https://www.sitepoint.com/css-viewport-units-quick-start/). To make the code more readable and efficient, I’ll also take advantage of [Sass variables](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#variables_).

No fallbacks are provided, so make sure to run the code in [a supporting browser](http://caniuse.com/#feat=css-grid). Without further ado, let’s dive in, developing the screen components one by one.

## The Screen Layout

The screen of a Trello board consists of an app bar, a board bar, and a section containing the card lists. I’ll build this structure with the following markup skeleton:

```html
<div class="ui">
  <nav class="navbar app">...</nav>
  <nav class="navbar board">...</nav>
  <div class="lists">
    <div class="list">
      <header>...</header>
      <ul>
        <li>...</li>
        ...
        <li>...</li>
      </ul>
      <footer>...</footer>
    </div>
  </div>
</div>
```

This layout will be achieved with a CSS Grid. Specifically, a 3×1 grid (that is, one column and three rows). The first row will be for the app bar, the second for the board bar, and the third for the `.lists` element.

The first two rows each have a fixed height, while the third row will span the rest of the available viewport height:

```css
.ui {
  height: 100vh;
  display: grid;
  grid-template-rows: $appbar-height $navbar-height 1fr;
}
```

Viewport units ensure that the `.ui` container will always be as tall as the browser’s viewport.

A grid formatting context is assigned to the container, and the grid rows and columns specified above are defined. To be more precise, only the rows are defined because there is no need to declare the unique column. The sizing of the rows is done with a couple of Sass variables for the height of the bars and the `fr` unit to make the height of the `.lists` element span the rest of the available viewport height.

## The Card Lists Section

As mentioned, the third row of the screen grid hosts the container for the card lists. Here’s the outline of its markup:

```html
<div class="lists">
  <div class="list">
    ...
  </div>
  ...
  <div class="list">
    ...
  </div>
</div>
```

I’m using a full viewport-width Flexbox single-line row container to format the lists:

```
.lists {
  display: flex;
  overflow-x: auto;
  > * {
    flex: 0 0 auto; // 'rigid' lists
    margin-left: $gap;
  }
  &::after {
    content: '';
    flex: 0 0 $gap;
  }
}
```

Assigning the auto value to the `overflow-x` property tells the browser to display a horizontal scrollbar at the bottom of the screen when the lists don’t fit in the width provided by the viewport.

The `flex` shorthand property is used on the flex items to make the lists rigid. The auto value for `flex-basis` (used in the shorthand) instructs the layout engine to read the size from the `.list` element’s width property, and the zero values for `flex-grow` and `flex-shrink` prevent the alteration of this width.

Next I’ll need to add a horizontal separation between the lists. If a right margin on the lists is set, then the margin after the last list in a board with horizontal overflowing is not rendered. To fix this, the lists are separated by a left margin and the space between the last list and the right viewport edge is handled by adding an `::after` pseudo-element to each `.lists` element. The default `flex-shrink: 1` must be overridden otherwise the pseudo-element ‘absorbs’ all the negative space and it vanishes.

Note that on Firefox < 54 an explicit `width: 100%` on `.lists` is needed to ensure the correct layout rendering.

## The Card List

Each card list is made up of a header bar, a sequence of cards, and a footer bar. The following HTML snippet captures this structure:

```html
<div class="list">
  <header>List header</header>
  <ul>
    <li>...</li>
    ...
    <li>...</li>
  </ul>
  <footer>Add a card...</footer>
</div>
```

The crucial task here is how to manage the height of a list. The header and footer have fixed heights (not necessarily equal). Then there are a variable number of cards, each one with a variable amount of content. So the list grows and shrinks vertically as cards are added or removed.

But the height cannot grow indefinitely, it needs to have an upper limit that depends on the height of the `.lists` element. Once this limit is reached, I want a vertical scrollbar to appear to allow access to the cards that overflow the list.

This sounds like a job for the `max-height` and `overflow` properties. But if these properties are applied to the root container `.list`, then, once the list reaches its maximum height, the scrollbar appears for all `.list` elements, header and footer included. The following illustration shows the wrong sidebar on the left and the correct one on the right:

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/08/1503994870wrong-right-sidebars.jpg)

So, let’s instead apply the `max-height` constraint to the inner `<ul>`. Which value should be used? The heights of the header and the footer must be subtracted from the height of the list parent container (`.lists`):

```
ul {
  max-height: calc(100% - #{$list-header-height} - #{$list-footer-height});
}
```

But there is a problem. The percentage value doesn’t refer to `.lists` but to the `<ul>` element’s parent, `.list`, and this element doesn’t have a definite height and so this percentage cannot be resolved. This can be fixed by making `.list` as tall as `.lists`:

```
.list {
  height: 100%;
}
```

This way, since `.list` is always as high as `.lists`, regardless of its content, its `background-color` property cannot be used for the list background color, but it is possible to use its children (header, footer, cards) for this purpose.

One last adjustment to the height of the list is necessary, to account for a bit of space (`$gap`) between the bottom of the list and the bottom edge of the viewport:

```
.list {
  height: calc(100% - #{$gap} - #{$scrollbar-thickness});
}
```

A further `$scrollbar-thickness` amount is subtracted to prevent the list from touching the `.list` element’s horizontal scrollbar. In fact, on Chrome this scrollbar ‘grows’ inside the `.lists` box. That is, the 100% value refers to the height of `.lists`, scrollbar included.

On Firefox instead, the scrollbar is ‘appended’ outside the `.lists` height, i.e, the 100% refers to the height of `.lists` not including the scrollbar. So this subtraction would not be necessary. As a result, when the scrollbar is visible, on Firefox the visual space between the bottom border of a list that has reached its maximum height and the top of the scrollbar is slightly larger.

Here are the relevant CSS rules for this component:

```css
.list {
  width: $list-width;
  height: calc(100% - #{$gap} - #{$scrollbar-thickness});

  > * {
    background-color: $list-bg-color;
    color: #333;
    padding: 0 $gap;
  }

  header {
    line-height: $list-header-height;
    font-size: 16px;
    font-weight: bold;
    border-top-left-radius: $list-border-radius;
    border-top-right-radius: $list-border-radius;
  }

  footer {
    line-height: $list-footer-height;
    border-bottom-left-radius: $list-border-radius;
    border-bottom-right-radius: $list-border-radius;
    color: #888;
  }

  ul {
    list-style: none;
    margin: 0;
    max-height: calc(100% - #{$list-header-height} - #{$list-footer-height});
    overflow-y: auto;
  }
}
```

As mentioned, the list background color is rendered by assigning the `$list-bg-color` value to the `background-color` property of each `.list` element’s children. `overflow-y` shows the cards scrollbar only when needed. Finally, some simple styling is added to the header and the footer.

## Finishing Touches

The HTML for a single card simply consists of a list item:

```
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit</li>
```

Or, if the card has a cover image:

```html
<li>
  <img src="..." alt="...">
  Lorem ipsum dolor sit amet
</li>
```

This is the relevant CSS:

```css
li {
  background-color: #fff;
  padding: $gap;

  &:not(:last-child) {
    margin-bottom: $gap;
  }

  border-radius: $card-border-radius;
  box-shadow: 0 1px 1px rgba(0,0,0, 0.1);

  img {
    display: block;
    width: calc(100% + 2 * #{$gap});
    margin: -$gap 0 $gap (-$gap);
    border-top-left-radius: $card-border-radius;
    border-top-right-radius: $card-border-radius;
  }
}
```

After having set a background, padding, and bottom margins, the cover image layout is ready. The image width must span the entire card from the left padding edge to the right padding edge:

```
width: calc(100% + 2 * #{$gap});
```

Then, negative margins are assigned to align the image horizontally and vertically:


```
margin: -$gap 0 $gap (-$gap);
```

The third positive margin value takes care of the space between the cover image and the card text.

Finally, I’ve added a flex formatting context to the two bars that occupy the first rows of the screen layout. But they are only sketched. Feel free to build your own implementation of this by [expanding on the demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100).

## Conclusion

This is only one possible way to accomplish this design and it would be interesting to see other approaches. Also, it would be nice to finalize the layout, for instance completing the two screen bars.

Another potential enhancement could be the implementation of custom scrollbars for the card lists.

So, feel free to [fork the demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100) and post a link in the discussion below.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
