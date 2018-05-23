> * 原文地址：[New CSS Features That Are Changing Web Design](https://www.smashingmagazine.com/2018/05/future-of-web-design/)
> * 原文作者：[Zell](https://www.smashingmagazine.com/author/zellliew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/future-of-web-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/future-of-web-design.md)
> * 译者：
> * 校对者：

# New CSS Features That Are Changing Web Design

Today, the design landscape has changed completely. We’re equipped with new and powerful tools — CSS Grid, CSS custom properties, CSS shapes and CSS writing-mode, to name a few — that we can use to exercise our creativity. Zell Liew explains how.

There was a time when web design got monotonous. Designers and developers built the same kinds of websites over and over again, so much so that we were mocked by people in our own industry for creating only two kinds of websites:

![](https://i.loli.net/2018/05/23/5b052472069ff.png)

Is this the limit of what our “creative” minds can achieve? This thought sent an incontrollable pang of sadness into my heart.

I don’t want to admit it, but maybe that was the best we could accomplish back then. Maybe we didn’t have suitable tools to make creative designs. The demands of the web were evolving quickly, but we were stuck with ancient techniques like floats and tables.

Today, the design landscape has changed completely. We’re equipped with new and powerful tools — CSS Grid, CSS custom properties, CSS shapes and CSS `writing-mode`, to name a few — that we can use to exercise our creativity.

### How CSS Grid Changed Everything

Grids are essential for web design; you already knew that. But have you stopped to asked yourself how you designed the grid you mainly use?

Most of us haven’t. We use the 12-column grid that has became a standard in our industry.

*   But why do we use the same grid?
*   Why are grids made of 12 columns?
*   Why are our grids sized equally?

Here’s one possible answer to why we use the same grid: **We don’t want to do the math**.

In the past, with float-based grids, to create a three-column grid, you needed to calculate the width of each column, the size of each gutter, and how to position each grid item. Then, you needed to create classes in the HTML to style them appropriately. It was [quite complicated](https://zellwk.com/blog/responsive-grid-system/).

To make things easier, we adopted grid frameworks. In the beginning, frameworks such as [960gs](https://960.gs) and [1440px](https://1440px.com) allowed us to choose between 8-, 9-, 12- and even 16-column grids. Later, Bootstrap won the frameworks war. Because Bootstrap allowed only 12 columns, and changing that was a pain, we eventually settled on 12 columns as the standard.

But we shouldn’t blame Bootstrap. It was the best approach back then. Who wouldn’t want a good solution that works with minimal effort? With the grid problem settled, we turned our attention to other aspects of design, such as typography, color and accessibility.

Now, with the **advent of CSS Grid, grids have become much simpler**. We no longer have to fear grid math. It’s become so simple that I would argue that creating a grid is easier with CSS than in a design tool such as Sketch!

Why?

Let’s say you want to make a 4-column grid, each column sized at 100 pixels. With CSS Grid, you can write `100px` four times in the `grid-template-columns` declaration, and a 4-column grid will be created.

```
.grid {
  display: grid;
  grid-template-columns: 100px 100px 100px 100px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows four columns.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/9287f25c-75f8-456b-9f22-b3190802d543/future-web-design-grid-four.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/9287f25c-75f8-456b-9f22-b3190802d543/future-web-design-grid-four.png) 

You can create four grid columns by specifying a column-width four times in `grid-template-columns`.

If you want a 12-column grid, you just have to repeat `100px` 12 times.

```
.grid {
  display: grid;
  grid-template-columns: 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px 100px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows twelve columns.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/61ab598a-9c0d-4d81-a624-3fbca4dfb6b2/future-web-design-grid-twelve.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/61ab598a-9c0d-4d81-a624-3fbca4dfb6b2/future-web-design-grid-twelve.png) 

Creating 12 columns with CSS Grid.

Yes, the code isn’t beautiful, but we’re not concerned with optimizing for code quality (yet) — we’re still thinking about design. CSS Grid makes it so easy for anyone — even a designer without coding knowledge — to create a grid on the web.

If you want to create grid columns with different widths, you just have to specify the desired width in your `grid-template-columns` declaration, and you’re set.

```
.grid {
  display: grid;
  grid-template-columns: 100px 162px 262px;
  grid-column-gap: 20px;
}
```

[![Screenshot of Firefox's grid inspector that shows three colums of different width.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6be83c78-9646-4c17-8d74-a3ffa55c13e1/future-web-design-grid-asym.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6be83c78-9646-4c17-8d74-a3ffa55c13e1/future-web-design-grid-asym.png) 

Creating columns of different widths is easy as pie.

#### Making Grids Responsive

No discussion about CSS Grid is complete without talking about the responsive aspect. There are several ways to make CSS Grid responsive. One way (probably the most popular way) is to use the `fr` unit. Another way is to change the number of columns with media queries.

`fr` is a flexible length that represents a fraction. When you use the `fr` unit, browsers divide up the open space and allocate the areas to columns based on the `fr` multiple. This means that to create four columns of equal size, you would write `1fr` four times.

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr;
  grid-column-gap: 20px;
}
```

[![GIF shows four columns created with the fr unit. These columns resize according to the available white space](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif)

Grids created with the `fr` unit respect the maximum width of the grid. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f12ee9f9-e577-4e2a-8173-f8c6fddff213/future-web-design-grid-fr.gif))

**Let’s do some calculations to understand why four equal-sized columns are created**.

First, let’s assume the total space available for the grid is `1260px`.

Before allocating width to each column, CSS Grid needs to know how much space is available (or leftover). Here, it subtracts `grip-gap` declarations from `1260px`. Since each gap `20px`, we’re left with `1200px` for the available space. `(1260 - (20 * 3) = 1200)`.

Next, it adds up the `fr` multiples. In this case, we have four `1fr` multiples, so browsers divide `1200px` by four. Each column is thus `300px`. This is why we get four equal columns.

**However, grids created with the `fr` unit aren’t always equal**!

When you use `fr`, you need to be aware that each `fr` unit is a fraction of the available (or leftover) space.

If you have an element that is wider than any of the columns created with the `fr` unit, the calculation needs to be done differently.

For example, the grid below has one large column and three small (but equal) columns even though it’s created with `grid-template-columns: 1fr 1fr 1fr 1fr`.

See the Pen [CSS Grid `fr` unit demo 1](https://codepen.io/zellwk/pen/vjWQep/) by Zell Liew ([@zellwk](https://codepen.io/zellwk)) on [CodePen](https://codepen.io).

After splitting `1200px` into four and allocating `300px` to each of the `1fr` columns, browsers realize that the first grid item contains an image that is `1000px`. Since `1000px` is larger than `300px`, browsers choose to allocate `1000px` to the first column instead.

That means, we need to recalculate leftover space.

The new leftover space is `1260px - 1000px - 20px * 3 = 200px`; this `200px` is then divided by three according to the amount of leftover fractions. Each fraction is then `66px`. Hopefully that explains why `fr` units do not always create equal-width columns.

If you want the `fr` unit to create equal-width columns everytime, you need to force it with `minmax(0, 1fr)`. For this specific example, you’ll also want to set the image’s `max-width` property to 100%.

See the Pen [CSS Grid `fr` unit demo 2](https://codepen.io/zellwk/pen/mxyXOm/) by Zell Liew ([@zellwk](https://codepen.io/zellwk)) on [CodePen](https://codepen.io).

**Note**: Rachel Andrew has written an amazing [article](https://www.smashingmagazine.com/2018/01/understanding-sizing-css-layout/) on how different CSS values (min-content, max-content, fr, etc.) affect content sizes. It’s worth a read!

#### Unequal-Width Grids

To create grids with unequal widths, you simply vary the fr multiple. Below is a grid that follows the golden ratio, where the second column is 1.618 times of the first column, and the third column is 1.618 times of the second column.

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1.618fr 2.618fr;
  grid-column-gap: 1em;
}
```

[![GIF shows a three-column grid created with the golden ratio. When the browser is resized, the columns resize accordingly.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/18f3c1ee-74f1-4bdc-b747-1019285f671b/future-web-design-grid-fr-asym.gif)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/18f3c1ee-74f1-4bdc-b747-1019285f671b/future-web-design-grid-fr-asym.gif) 

A three-column grid created with the golden ratio.

#### Changing Grids At Different Breakpoints

If you want to change the grid at different breakpoints, you can declare a new grid within a media query.

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

Isn’t it easy to create grids with CSS Grid? Earlier designers and developers would have killed for such a possibility.

#### Height-Based Grids

It was impossible to make grids based on the height of a website previously because there wasn’t a way for us to tell how tall the viewport was. Now, with viewport units, CSS Calc, and CSS Grid, we can even make grids based on viewport height.

In the demo below, I created grid squares based on the height of the browser.

See the Pen [Height based grid example](https://codepen.io/zellwk/pen/qoEYaL/) by Zell Liew ([@zellwk](https://codepen.io/zellwk)) on [CodePen](https://codepen.io).

Jen Simmons has a great video that talks about [desgining for the fourth edge](https://www.youtube.com/watch?v=dQHtT47eH0M&feature=youtu.be) — with CSS Grid. I highly recommend you watch it.

#### Grid Item Placement

Positioning grid items was a big pain in the past because you had to calculate the `margin-left` property.

Now, with CSS Grid, you can place grid items directly with CSS without the extra calculations.

```
.grid-item {
  grid-column: 2; /* Put on the second column */
}
```

[![Screenshot of a grid item placed on the second column](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bf790516-2d0d-4078-aac0-6a1d9357a74b/future-web-design-grid-placement.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bf790516-2d0d-4078-aac0-6a1d9357a74b/future-web-design-grid-placement.png) 

Placing an item on the second column.

You can even tell a grid item how many columns it should take up with the `span` keyword.

```
.grid-item {
  /* Put in the second column, span 2 columns */
  grid-column: 2 / span 2;
}
```

[![Screenshot of a grid item that's placed on the second column. It spans two columns](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a66e3449-3bd9-40ff-8fe2-6116c0939d77/future-web-design-grid-placement-span.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a66e3449-3bd9-40ff-8fe2-6116c0939d77/future-web-design-grid-placement-span.png) 

You can tell grid items the number of columns (or even rows) they should occupy with the `span` keyword.

#### Inspirations

CSS Grid enables you to lay things out so easily that you can create a lot of variations of the same website quickly. One prime example is [Lynn Fisher’s personal home page](https://lynnandtonic.com).

If you’d like to find out more about what CSS Grid can do, check out [Jen Simmon’s lab](http://labs.jensimmons.com), where she explores how to create different kinds of layouts with CSS Grid and other tools.

To learn more about CSS Grid, check out the following resources:

*   [Master CSS Grid](http://mastercssgrid.com), Rachel Andrew and Jen Simmons
    Video tutorials
*   [Layout Land](https://www.youtube.com/channel/UC7TizprGknbDalbHplROtag), Jen Simmons
    A series of videos about layout
*   [CSS layout workshop](https://thecssworkshop.com), Rachel Andrew
    A CSS layout course
*   [Learn CSS Grid](https://learncssgrid.com), Jonathan Suh
    A free course on CSS Grid.
*   [Grid critters](https://geddski.teachable.com/p/gridcritters), Dave Geddes
    A fun way to learn CSS Grid

### Designing With Irregular Shapes

We are used to creating rectangular layouts on the web because the CSS box model is a rectangle. Besides rectangles, we’ve also found ways to create simple shapes, such as triangles and circles.

Today, we don’t need to stop there. With CSS shapes and `clip-path` at our disposal, we can create irregular shapes without much effort.

For example, [Aysha Anggraini](https://twitter.com/RenettaRenula) experimented with a comic-strip-inspired layout with CSS Grid and `clip path`.

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

See the Pen [Comic-book-style layout with CSS Grid](https://codepen.io/rrenula/pen/LzLXYJ/) by Aysha Anggraini ([@rrenula](https://codepen.io/rrenula)) on [CodePen](https://codepen.io).

[Hui Jing](https://twitter.com/hj_chen) explains how to use CSS shapes in a way that [allows text to flow](https://www.chenhuijing.com/blog/why-you-should-be-excited-about-css-shapes/) along the Beyoncé curve.

[![An image of Huijing's article, where text flows around Beyoncé.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e2b60894-b7dd-41ac-94dd-b87a6bdf3cbc/future-web-design-beyonce.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e2b60894-b7dd-41ac-94dd-b87a6bdf3cbc/future-web-design-beyonce.png) 

Text can flow around Beyoncé if you wanted it to!

If you’d like to dig deeper, [Sara Soueidan](https://twitter.com/SaraSoueidan) has an article to help you [create non-rectangular layouts](https://www.sarasoueidan.com/blog/css-shapes/).

CSS shapes and `clip-path` give you infinite possibilities to create custom shapes unique to your designs. Unfortunately, syntax-wise, CSS shapes and `clip-path` aren’t as intuitive as CSS Grid. Luckily, we have tools such as [Clippy](https://bennettfeely.com/clippy/) and [Firefox’s Shape Path Editor](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_CSS_shapes) to help us create the shapes we want.

[![Image of Clippy, a tool to help you create custom CSS shapes](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c101607-4aac-4fa9-a968-62a33133331c/future-web-design-clippy.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c101607-4aac-4fa9-a968-62a33133331c/future-web-design-clippy.png) 

Clippy helps you create custom shapes easily with `clip-path`.

### Switching Text Flow With CSS’ `writing-mode`

We’re used to seeing words flow from left to right on the web because the web is predominantly made for English-speaking folks (at least that’s how it started).

But some languages don’t flow in that direction. For example, Chinese words can read top down and right to left.

CSS’ `writing-mode` makes text flow in the direction native to each language. Hui Jing experimented with a Chinese-based layout that flows top down and right to left on a website called [Penang Hokkien](http://penang-hokkien.gitlab.io). You can read more about her experiment in her article, “[The One About Home](https://www.chenhuijing.com/blog/the-one-about-home/#🏀)”.

Besides articles, Hui Jing has a great talk on typography and `writing-mode`, “[When East Meets West: Web Typography and How It Can Inspire Modern Layouts](https://www.youtube.com/watch?v=Tqxo269aORM)”. I highly encourage you to watch it.

[![An image of the Penang Hokken, showcasing text that reads from top to bottom and right to left.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2f69df2b-18d2-4da4-8e44-22226ef0becd/future-web-design-penang-hokkien.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2f69df2b-18d2-4da4-8e44-22226ef0becd/future-web-design-penang-hokkien.png) 

Penang Hokkien shows that Chinese text can be written from top to bottom, right to left.

Even if you don’t design for languages like Chinese, it doesn’t mean you can’t apply CSS’ `writing-mode` to English. Back in 2016, when I created [Devfest.asia](https://2016.devfest.asia/community/), I flexed a small creative muscle and opted to rotate text with `writing-mode`.

[![An image that shows how I rotated text in a design I created for Devfest.asia](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/70acafa4-5454-4257-bbdd-3f5fe18d3696/future-web-design-devfest.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/70acafa4-5454-4257-bbdd-3f5fe18d3696/future-web-design-devfest.png) 

Tags were created by using writing mode and transforms.

[Jen Simmons’s lab](http://labs.jensimmons.com) contains many experiments with `writing-mode`, too. I highly recommend checking it out, too.

[![An image from Jen Simmon's lab that shows a design from Jan Tschichold.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4f024681-c86e-4009-89aa-1ff379e71e8a/future-web-design-lab.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4f024681-c86e-4009-89aa-1ff379e71e8a/future-web-design-lab.png) 

An image from Jen Simmon's lab that shows Jan Tschichold.

### Effort And Ingenuity Go A Long Way

Even though the new CSS tools are helpful, you don’t need any of them to create unique websites. A little ingenuity and some effort go a long way.

For example, in [Super Silly Hackathon](https://supersillyhackathon.sg), [Cheeaun](https://twitter.com/cheeaun) rotates the entire website by -15 degrees and makes you look silly when reading the website.

[![A screenshot from Super Silly Hackthon, with text slightly rotated to the left](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e308a830-ba6a-431c-8e5d-c4128cad965a/future-web-design-supersilly.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e308a830-ba6a-431c-8e5d-c4128cad965a/future-web-design-supersilly.png) 

Cheeaun makes sure you look silly if you want to enter Super Silly Hackathon.

[Darin Senneff](https://twitter.com/dsenneff) made an [animated login avatar](https://codepen.io/dsenneff/pen/QajVxO) with some trigonometry and GSAP. Look at how cute the ape is and how it covers its eyes when you focus on the password field. Lovely!

![](https://i.loli.net/2018/05/23/5b0528b7e755a.png)

When I created the sales page for my course, [Learn JavaScript](https://learnjavascript.today), I added elements that make the JavaScript learner feel at home.

[![Image where I used JavaScript elements in the design for Learn JavaScript.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6b66f918-dc6f-4da1-870e-aa6b5ea8029c/future-web-design-learnjavascript.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6b66f918-dc6f-4da1-870e-aa6b5ea8029c/future-web-design-learnjavascript.png) 

I used the `function` syntax to create course packages instead of writing about course packages.

### Wrapping Up

A unique web design isn’t just about layout. It’s about how the design integrates with the content. With a little effort and ingenuity, all of us can create unique designs that speak to our audiences. The tools at our disposal today make our jobs easier.

The question is, do you care enough to make a unique design? I hope you do.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
