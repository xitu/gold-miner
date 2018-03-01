> * 原文地址：[Auto-Sizing Columns in CSS Grid: `auto-fill` vs `auto-fit`](https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/)
> * 原文作者：[SARA SOUEIDAN](https://css-tricks.com/author/sarasoueidan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit.md](https://github.com/xitu/gold-miner/blob/master/TODO/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：[ParadeTo](https://github.com/ParadeTo)、[realYukiko](https://github.com/realYukiko)

# CSS Grid 之列宽自适应：`auto-fill` vs `auto-fit`

除了显式的指定列大小之外，CSS Grid 还有个非常强大的功能 —— 模式填充（repeat-to-fill）列然后对内容进行自动布局。也就是说，开发者只需要指定列数，自适应方面的事情（视口尺寸小则显示列数少，反之则多）交给浏览器来处理就行了，也不需要用媒体查询。

上述功能完全可以用一条语句就能实现，这不禁让我想起《哈利波特》里，邓布利多在霍拉斯家里挥舞着他的巴拉拉小魔棒，然后“家具一件件跳回了原来的位置，装饰品在半空中恢复了原形，羽毛重新钻回软垫里，破损的图书自动修复，整整齐齐地排列在书架上…”。

就是这么神奇，而且还不用媒体查询。这一切都归功于 `repeat()` 方法和自动布局的关键字。

其实这方面的技术文章很多，基本用法我就不在此赘述了，有兴趣可以参考 Tim Wright 写的 [博文](http://csskarma.com/blog/css-grid-layout/)，个人极力推荐。

总之，`repeat()` 方法能根据你的需要分割出任意多个列。例如，如果你需要一个基于 12 列的网格系统，你可以这么写：

```
.grid {
   display: grid;

  /* 指定网格列数 */
  grid-template-columns: repeat(12, 1fr);
}
```

`1fr` 表示让浏览器将网格空间进行均分，每列占其一分，这样就创建了 12 个宽度不固定但是相等的列。而且不管视口宽度如何，都会保持 12 列不变。但是，估计你也想到了，如果视口过窄，内容必然会被挤扁。

所以，这里有必要设置列的最小宽度来保证容器不至于太窄，这里需要用到 `minmax()` 方法。

```
grid-template-columns: repeat( 12, minmax(250px, 1fr) );
```

按照 grid 的脾性，这么做肯定会导致当前行内容溢出，即便视口在最小列宽的限制条件下实在无法容纳这些列，这些列也不会自动换行，因为之前告诉过浏览器必须有 12 列。

为了实现换行，可以用 `auto-fit` 或 `auto-fill`。

```
grid-template-columns: repeat( auto-fit, minmax(250px, 1fr) );
```

这条语句让浏览器自个儿去处理列宽和元素的换行，如果容器宽度不够，元素会自动换行，也就不会导致溢出了。这里仍旧用了 `fr` 单位，这样的话，如果行内剩下的空间不足以容纳另外一列时，已有的列能自动扩张占满一整行，不造成空间浪费。

乍一看名字，`auto-fill` 和 `auto-fit` 似乎是完全相反的两个东西，实际上它们的区别相当微妙。

非要说的话，用 `auto-fit` 的时候，当前行的末尾留了不少空白，但是什么时候留白，为什么会留白呢？

来让我们一探究竟。

### Fill 和 Fit 的区别到底在哪？

在最近一个 CSS 研讨会上，我是这么总结 `auto-fill` 和 `auto-fit` 的区别的：

> `auto-fill` 倾向于容纳更多的列，所以如果在满足宽度限制的前提下还有空间能容纳新列，那么它会暗中创建一些列来填充当前行。即使创建出来的列没有任何内容，但实际上还是占据了行的空间。
> 
> `auto-fit` 倾向于使用最少列数占满当前行空间，浏览器先是和 `auto-fill` 一样，暗中创建一些列来填充多出来的行空间，然后坍缩（collapse）这些列以便腾出空间让其余列扩张。

乍看起来还是挺懵逼的，稍后我会做一个可视化图来展示这些行为，这样更容易理解一点。Firefox 有专门的 Grid 分析工具能帮助显示元素和列的尺寸、位置（译者注：用开发者工具拾取容器元素，在样式侧边栏中的 `display: grid` 中的 `grid` 左侧有个网格图标，点一下就能显式网格线条了）。

以 [这里](https://codepen.io/SaraSoueidan/pen/JrLdBQ/) 的 demo 为例。

还是用 `repeat()` 方法来定义列，设置其最小宽度为 100px，最大为 `1fr`，这样，如果存在额外空间，每一列分到的空间大小都相等。这里让列数自行计算，换行和自适应都交给浏览器处理。

第一个例子使用 `auto-fill` 关键字，第二个则是 `auto-fit`。

```
.grid-container--fill {
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
}

.grid-container--fit {
  grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
}
```

**在特定的情况下，`auto-fill` 和 `auto-fit` 的效果是一样的。**

![](https://cdn.css-tricks.com/wp-content/uploads/2017/12/auto-fill.png)

虽然看起来一样，但骨子里还是不同的。看起来一样只是因为视口的宽度造成了这种巧合.

使它们产生不同的结果的关键点在于 `grid-template-columns` 中列数和列宽的设置，例子不同，产生的结果也会不同。

当视口的宽度大到能够容纳额外的列到当前行时，差别就会体现出来了。这时，浏览器会采用两种方式来处理这种情况，怎么处理取决于是否还有内容需要放到多出的列里面。

所以，如果当前行还能再放得下一列，浏览器的行为如下：

1. “我这还有空间再放一列，还有没放进来的内容吗（如：grid item）？如果有，OK，我再在当前行添加一列，如果视口太小，空间不够了，我换一行再加”。
2. 如果没有多的内容：“是让这新的一列尸位素餐呢，还是让其坍缩让其余的列进行扩张来占据它的空间呢？”

`auto-fill` 和 `auto-fit` 的出现解答了最后一个问题：在没有多的内容的情况下，是坍缩还是任其占位？
这是问题，同时也是选择，最终取决于你的内容，以及你想该内容在响应式设计下如何表现。

下面来详细解释。为了形象、生动的表现出 `auto-fill` 和 `auto-fit` 的区别，请按我的步骤做，观察屏幕上的变化。现在，我正在调整视口的大小，留出足够的横向空间，让其能容纳更多的列到当前行。牢记一点，例子中的两行有完全相同的内容、相同的列数，唯一的区别是第一行用的是 `auto-fill`，第二行用的是 `auto-fit`。

这下应该清楚了吧，如果还是不明白，那我们继续：

`auto-fill` 的做法：“来‘列’啊，给我把这行全占了，列越多越好，我不介意有些个列完全是透明的 —— 看不到不代表不存在嘛。有空间就加列，有无内容无所谓，反正空间我是占了（也就是说会用内容/grid item 来填充）。"

如上所述，`auto-fill` 尽可能容纳多的列，即使有些列是空的，`auto-fit` 则稍显不同。
`auto-fit` 的做法和 `auto-fill` 一样，随着视口宽度增大而增加列数，区别在于新增加的列都坍缩了（包括间隔 gap 在内）。用 Firefox 的 Grid 工具来可视化这个过程再合适不过了，当视口的宽度增加时，新的列也被添加进来，grid 的线条也会增加，肉眼就能观察得到全过程。

`auto-fit` 的做法：“先用已有的列进行填充，然后尽情扩张直到占满一整行空间。空白列不允许占据多出的空间，这些空间要好好利用，应该让已经填进去的列（内容/grid item）扩张自己来填充这些空间。”

有必要记住的一点是，在以上两种情况中，多出来的列（无论最后是否坍缩）都不是隐式的列（implicit columns） —— 这在官方文档里有特殊的含义。这里新增的，或者说创建的列都在显式 grid（explicit grid）里面，和直接指明划分出 12 列的 grid 是一样的。所以，使用列数索引时， `-1` 会指向 grid 的末端，如果是隐式创建的，情况就不是这样了。 给 [Rachel Andrew](https://twitter.com/rachelandrew) 加鸡腿，感谢他给出的这个小贴士。

### 总结

只有行的宽度大到能够容纳额外的列时，`auto-fill` 和 `auto-fit` 这两者的区别才会体现出来。

用 `auto-fit` 时，内容区会自动拉伸以便占满一整行；另一方面，使用 `auto-fill` 的时候，浏览器对待空列和那些有实质内容的列一样，一视同仁，允许其占用行空间 —— 即使这些空列并无实质性内容，它们也还是会分得行空间的一杯羹，所以也能间接的影响那些有内容的列的大小，或者说宽度。

你更倾向于哪种行为取决于你的需求，说实在的，我也在想到底有哪些情况，`auto-fill` 会比 `auto-fit` 更适用一点。如果你恰好周围有这样的使用场景，希望能在评论区不吝赐教。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
