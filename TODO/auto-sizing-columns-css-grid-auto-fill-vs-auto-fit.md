> * 原文地址：[Auto-Sizing Columns in CSS Grid: `auto-fill` vs `auto-fit`](https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/)
> * 原文作者：[SARA SOUEIDAN](https://css-tricks.com/author/sarasoueidan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit.md](https://github.com/xitu/gold-miner/blob/master/TODO/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit.md)
> * 译者：
> * 校对者：

# Auto-Sizing Columns in CSS Grid: `auto-fill` vs `auto-fit`

One of the most powerful and convenient CSS Grid features is that, in addition to explicit column sizing, we have the option to repeat-to-fill columns in a Grid, and then auto-place items in them. More specifically, our ability to specify how many columns we want in the grid and then letting the browser handle the responsiveness of those columns for us, showing fewer columns on smaller viewport sizes, and more columns as the screen estate allows for more, without needing to write a single media query to dictate this responsive behavior.

We're able to do that using just one line of CSS — the one-liner that reminds me of when Dumbledore just waved his wand in Horace's apartment and _"the furniture flew back to its original places; ornaments reformed in midair, feathers zoomed into their cushions; torn books repaired themselves as they landed upon their shelves..."_.

This magical, media-query-less responsiveness is achieved using the `repeat()` function and the auto placement keywords.

Much has been written about this particular one-liner, so I won't be elaborating on how it works. Tim Wright has [a great writeup](http://csskarma.com/blog/css-grid-layout/) on this that I recommend reading.

To summarize, the `repeat()` function allows you to repeat columns as many times as needed. For example, if you're creating a 12-columns grid, you could write the following one-liner:

```
.grid {
   display: grid;

  /* define the number of grid columns */
  grid-template-columns: repeat(12, 1fr);
}
```

The `1fr` is what tells the browser to distribute the space between the columns so that each column equally gets one fraction of that space. That is, they're all fluid, equal-width columns. And the grid will, in this example, always have 12 columns regardless of how wide it is. This, as you have probably guessed, is not good enough, as the content will be too squished on smaller viewports.

So we need to start by specifying a minimum width for the columns, making sure they don't get too narrow. We can do that using the `minmax()` function.

```
grid-template-columns: repeat( 12, minmax(250px, 1fr) );
```

But the way CSS Grid works, this will cause overflow in the row. The columns will not wrap into new rows if the viewport width is too narrow to fit them all with the new minimum width requirement, because we're explicitly telling the browser to repeat the columns 12 times per row.

To achieve wrapping, we can use the `auto-fit` or `auto-fill` keywords.

```
grid-template-columns: repeat( auto-fit, minmax(250px, 1fr) );
```

These keywords tell the browser to handle the column sizing and element wrapping for us, so that the elements will wrap into rows when the width is not large enough to fit them in without any overflow. The fraction unit we used also ensures that, in case the width allows for a fraction of a column to fit but not a full column, that space will instead be distributed over the column or columns that already fit, making sure we aren't left with any empty space at the end of the row.

At first glace of the names, it might seem like `auto-fill` and `auto-fit` are opposites. But in fact, the difference between is quite subtle.

Maybe it seems like you are getting extra space at the end of the column with `auto-fit`. But when and how?

Let's take a look at what is really happening under the hood.

### Fill or Fit? What's the difference?

In a recent CSS workshop, I summarized the difference between `auto-fill` and `auto-fit` as follows:

> `auto-fill` FILLS the row with as many columns as it can fit. So it creates implicit columns whenever a new column can fit, because it's trying to FILL the row with as many columns as it can. The newly added columns can and may be empty, but they will still occupy a designated space in the row.
> 
> `auto-fit` FITS the CURRENTLY AVAILABLE columns into the space by expanding them so that they take up any available space. The browser does that after FILLING that extra space with extra columns (as with `auto-fill` ) and then collapsing the empty ones.

This may sound confusing at first, but it makes a lot more sense when you visualize this behavior. So we'll be doing exactly that, with the Firefox DevTools' Grid Inspector helping us visualize the size and position of our Grid items and columns.

Consider the following demo as an example.

See the Pen [auto-fill vs auto-fit](https://codepen.io/SaraSoueidan/pen/JrLdBQ/) by Sara Soueidan ([@SaraSoueidan](https://codepen.io/SaraSoueidan)) on [CodePen](https://codepen.io).

The columns are defined using the `repeat()` function and have a minimum width of 100px, and a maximum set to `1fr` , so that they would expand and equally share any extra space when it is available. As for the number of columns per row, we're going to use the auto-placement keywords, so that we let the browser take care of the responsiveness of the grid and will wrap the columns into new rows when needed.

The browser will place and size the columns in the first example using the `auto-fill` keyword, and it will use `auto-fit` for the second.

```
.grid-container--fill {
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
}

.grid-container--fit {
  grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
}
```

**Up to a certain point, both `auto-fill` and `auto-fit` show identical results.**

![](https://cdn.css-tricks.com/wp-content/uploads/2017/12/auto-fill.png)

But they don't have identical behavior under the hood. It just so happens that _they will give the same result_ up to a certain viewport width.

The point at which these two keywords start exhibiting different behaviors depends on the number and size of columns defined in `grid-template-columns`, so it will differ from one example to another.

The difference between these two keywords is made apparent when the viewport gets wide enough to fit one (or more) extra column(s) (that) into the row. At that point, the browser is presented with two ways to handle the situation, and how it handles it largely depends on whether or not there is content to be placed into that extra column.

So, when the row can fit a new column, the browser goes like:

1. "I have some space to fit a new column in there. Do I have any content (i.e. grid items) to go into that extra column? Yes? OK, all good. I'll add the column into the row, and it will wrap into a new row on smaller viewports."
2. In the case where there is no content to place into a new column: "Do I allow this new column to occupy space in the row (and, therefore, affect the position and size of the rest of the rows)? or do I collapse that column and use its space to expand the other columns?"

`auto-fill` and `auto-fit` provide the answer to that last question in particular, and dictate how the browser should handle this scenario. To collapse or not to collapse, that is the question. And that is also the answer.
Whether you want it to collapse or not depends on your content, and how you want that content to behave in the context of a responsive design.

Let's see how this works. To visualize the difference between `auto-fill` and `auto-fit`, take a look at the following screen recording. I'm resizing the viewport enough to create horizontal space that's enough to fit one (or more) column(s) into the row. Remember that these two rows are identical, and have the exact same of content and column number. The only difference in this demo is that I'm using `auto-fill` for the first one and `auto-fit` for the second.

Notice what is happening there? If it's still not clear, the following recording should make it clearer:

`auto-fill` behavior: "_fill_ that row up! Add as many columns as you can. I don't care if they're empty — they should all still show up. If you have enough space to add a column, add it. I don't care if it's empty or not, it's still occupying space in the row as if it were filled (_as in: filled with content/grid items_)."

While `auto-fill` fills the row with as many columns as it can, even if those columns are empty, `auto-fit` behaves a little differently.
`auto-fit` does, too, fill the row with more columns are the viewport width increases, but the only difference is that the newly added columns (and any column gaps associated with them) are collapsed. The Grid inspector is a fantastic way to visualize this. You'll notice that columns are being added when you keep your eye on the Grid line numbers, which will increase as the viewport width increases.

`auto-fit` behavior: "make whatever columns you have fit into the available space. Expand them as much as you need to fit the row size. Empty columns must not occupy any space. Put that space to better use by expanding the filled (as in: filled with content/grid items) columns to fit the available row space."

A useful tip to remember here is that the columns added in both cases (whether collapsed or not) are not implicit columns — that has specific meaning in the spec. In our case, we are adding/creating columns in the explicit grid in the same way as if we declared you wanted 12 columns, for example. So column number `-1` will work to target the end of this grid, which it doesn't if you are creating columns in the implicit grid. Props to [Rachel Andrew](https://twitter.com/rachelandrew) for this tip.

### Summing Up

The difference between `auto-fill` and `auto-fit` for sizing columns is only noticeable when the row is wide enough to fit more columns in it.

If you're using `auto-fit`, the content will stretch to fill the entire row width. Whereas with `auto-fill`, the browser will allow empty columns to occupy space in the row like their non-empty neighbors — they will be allocated a fraction of the space even if they have no grid items in them, thus affecting the size/width of the latter.

Which behavior you want or prefer is completely up to you. I have yet to think of a use case where `auto-fill` would make more sense than `auto-fit`. Do you have any use cases? If you do, please feel free to share them in the comments below.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
