> * 原文地址：[Making Tables With Sticky Header and Footers Got a Bit Easier](https://css-tricks.com/making-tables-with-sticky-header-and-footers-got-a-bit-easier/)
> * 原文作者：[Chris Coyier ](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/making-tables-with-sticky-header-and-footers-got-a-bit-easier.md](https://github.com/xitu/gold-miner/blob/master/article/2021/making-tables-with-sticky-header-and-footers-got-a-bit-easier.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 使用粘性 Header 和 Footer 制作表格变得更容易

不久前，当我在博客文章[一个带有粘性 Header 和粘性第一列内容的表格](https://css-tricks.com/a-table-with-both-a-sticky-header-and-a-sticky-first-column/)中写到关于 HTML `<table>` 中的粘性 Header 和 Footer 的内容。那时我没有在任何 `<thead>`、`<tfoot>` 或 `<tr>` 元素上使用 `position: sticky`，因为即使在 Safari 和 Firefox 中我可以这样做，在 Chrome 也做不到。不过它可以应用于像 `<th>` 和 `<td>` 这样的表格单元格，这是一个不错的解决方法。

嗯，这已经改变了。

![推特帖子](https://i.imgur.com/wmeMAck.png)

听起来像是 Chromium 的渲染引擎中彻底重构了表格的渲染，使得表格的渲染能跟上节奏。这是一项巨大的努力，不仅仅是固定黏在顶上或底下的一行内容这么多，还有[各项其他工作](https://docs.google.com/document/d/16PFD1GtMI9Zgwu0jtPaKZJ75Q2wyZ9EZnVbBacOfiNA/edit)。不过我只关注了粘性 Header 和 Footer，因为那是我所关注的。

我的标题 `<thead>` 和 `<tfoot>` 是具有粘性的的，这似乎是这里最常见的用例：

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

这适用于所有三个主要浏览器。你可能想要变得更机智一些，希望只在特定的最小视口高度或其他地方粘住这几个元素，但关键是它有用能正常工作了。

我也听到了几个关于表格的**列**的问题。我的原文中有一个具有粘性的第一列内容（这就是重点）。虽然其中有一个表格 `<col>` 标签，但它……很奇怪。它实际上并没有包装列，它更像是一个指针，可以根据需要调整列的样式。我几乎从未见过它被使用过，但它就在那里。无论如何，你完全**不能**应用 `position:sticky;` 在一个 `<col>` 上，但你**可以**制作粘性列。你只需要选择该列中的所有单元格并将它们粘贴到左侧或右侧。这是使用逻辑属性……

```css
table tr th:first-child {
  position: sticky;
  inset-inline-start: 0; /* "left" */
}
```

下面是一个有点意思的表格，其中 `<thead>`、`<tfoot>`、**第一列和最后一列**都是粘性的。

[Codepen chriscoyier/OJpweqJ](https://codepen.io/chriscoyier/pen/OJpweqJ)

我相信你可以用这个做一些有品味的事情。像也许：

![推特帖子](https://i.imgur.com/HcjEcim.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
