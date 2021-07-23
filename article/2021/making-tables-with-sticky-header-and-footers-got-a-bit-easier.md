> * 原文地址：[Making Tables With Sticky Header and Footers Got a Bit Easier](https://css-tricks.com/making-tables-with-sticky-header-and-footers-got-a-bit-easier/)
> * 原文作者：[Chris Coyier ](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/making-tables-with-sticky-header-and-footers-got-a-bit-easier.md](https://github.com/xitu/gold-miner/blob/master/article/2021/making-tables-with-sticky-header-and-footers-got-a-bit-easier.md)
> * 译者：
> * 校对者：

# Making Tables With Sticky Header and Footers Got a Bit Easier

It wasn’t long ago when I looked at sticky headers and footers in HTML `<table>`s in the blog post [A table with both a sticky header and a sticky first column](https://css-tricks.com/a-table-with-both-a-sticky-header-and-a-sticky-first-column/). In it, I never used `position: sticky` on any `<thead>`, `<tfoot>`, or `<tr>` element, because even though Safari and Firefox could do that, Chrome could not. But it could do table cells like `<th>` and `<td>`, which was a decent-enough workaround.

Well that’s changed.

![Twitter Post](https://i.imgur.com/wmeMAck.png)

Sounds like a big effort went into totally revamping tables in the rendering engine in Chromium, bringing tables up to speed. It’s not just the stickiness that was fixed, but [all sorts of things](https://docs.google.com/document/d/16PFD1GtMI9Zgwu0jtPaKZJ75Q2wyZ9EZnVbBacOfiNA/edit). I’ll just focus on the sticky thing since that’s what I looked at.

The headline to me is that `<thead>` and `<tfoot>` are sticky-able. That seems like it will be the most common use case here.

```css
table thead,
table tfoot {
  position: sticky;
}
table thead {
  inset-block-start: 0; /* "top" */
}
table tfoot {
  inset-block-end: 0; /* "bottom" */
}
```

[Codepen chriscoyier/WNpJewq](https://codepen.io/chriscoyier/pen/WNpJewq)

That works in all three major browsers. You might want to get clever and only sticky them at certain minimum viewport heights or something, but the point is it works.

I heard several questions about table *columns* as well. My original article had a sticky first column (that was kind of the point). While there is a table `<col>` tag, it’s… weird. It doesn’t actually wrap columns, it’s more like a pointer thing to be able to style down the column if you need to. I hardly ever see it used, but it’s there. Anyway, you totally *can’t* `position: sticky;` a `<col>`, but you *can* make sticky columns. You need to select all the cells in that column and stick them to the left or right. Here’s that using logical properties…

```css
table tr th:first-child {
  position: sticky;
  inset-inline-start: 0; /* "left" */
}
```

Here’s a sorta obnoxious table where the `<thead>`, `<tfoot>`, *and* the first and last columns are all sticky.

[Codepen chriscoyier/OJpweqJ](https://codepen.io/chriscoyier/pen/OJpweqJ)

I’m sure you could do something tasteful with this. Like maybe:

![Twitter Post](https://i.imgur.com/HcjEcim.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
