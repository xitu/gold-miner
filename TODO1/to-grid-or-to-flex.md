> * 原文地址：[To Grid or to Flex?](https://css-irl.info/to-grid-or-to-flex/)
> * 原文作者：[Michelle Barker](https://twitter.com/mbarker_84)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/to-grid-or-to-flex.md](https://github.com/xitu/gold-miner/blob/master/TODO1/to-grid-or-to-flex.md)
> * 译者：[Reaper622](https://github.com/Reaper622)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[hanxiansen](https://github.com/hanxiansen)

# 选择 Grid 还是 Flex？

一个最近由 Chris Coyier 发起的的 [推特话题](https://twitter.com/chriscoyier/status/1088827201468813312) 使我开始思考人们通常在什么情况下使用 CSS Grid 布局还是 Flexbox 布局:

> 对于已经理解了 CSS grid 和 flexbox 的你们来说，最喜欢的描述二者之间差异的方法是什么？
> 
> — Chris Coyier (@chriscoyier) [January 25, 2019](https://twitter.com/chriscoyier/status/1088827201468813312?ref_src=twsrc%5Etfw)

自然地一些最有见地的回复来自于 Rachel Andrew 和 Jen Simmons：

> Flexbox 是一种一维布局。一行或者一列。Grid 是一种二维布局。多行和多列。
> 
> — Rachel Andrew (@rachelandrew) [January 25, 2019](https://twitter.com/rachelandrew/status/1088827732874747910?ref_src=twsrc%5Etfw)

> Grid 创造了实际的列和行。内容会按你要求的一个接一个地排列整齐。Flexbox 则不会。不止是在二维（最显而易见的），同样也在一维条件下，Flexbox 并不适用于当今我们一直使用它的大部分内容。
> 
> — Jen Simmons (@jensimmons) [January 26, 2019](https://twitter.com/jensimmons/status/1089181330133450752?ref_src=twsrc%5Etfw)

然而，只是单单阅读推文并不会告诉我们始末。这篇文章旨在告诉读者两者的适用场景，以及在哪种情况下只能选择使用其中一个。

当浏览话题下面的回复时，我发现相当大数量的人只在页面级的布局中使用Grid，其他情况下直接使用 flexbox。如果你把这个当成一条准则，那么你在严重地限制自己使用 Grid 的强大的功能。我特别建议：把每个设计独立化，分析可选方案的可行性，不要对你使用的技术来做出主观的猜想。当你选择一种布局方法时，先扪心自问一下下面的这些问题。

## 你需要做多少计算？

这是我对这个话题的发出的推文：

> 当我看起来似乎需要 `calc()` 对布局使用大量的计算时，Grid 是一个更好的选择。
> 
> — Michelle Barker (@mbarker_84) [January 26, 2019](https://twitter.com/mbarker_84/status/1089182216020742144?ref_src=twsrc%5Etfw)

通常地，如果你不得不大量的使用 _calc()_ 来得到精确地位置与尺寸(例如考虑到间隔的情况)，那么通常是值得去考虑一下使用 Grid 的，因为 _fr_ 单位会帮我们做繁重的适配，它会让你不那么头痛。虽然作为一般准则这很不错，但也并不是适用于所有的场景。这是一些你可能会用到 Grid 的场景，即使你的布局并不需要大量的 _calc()_。一个例子是一个固定宽度的二维布局，每个网格轨道是 200px 宽 - 你不需要 _calc()_ 来告诉你网格轨道应该是多宽，但你可能仍然想要 Grid 的表现行为。同样，有些你需要计算的情况下也会使用 flexbox，因此这只能作为一个指南。

## 一维还是二维？

Grid 和 flexbox 的一个很大的差异是 Grid 允许我们在二维空间(多行多列)控制元素的位置，flexbox 则不行。再强调一次，那并不意味着你**永远**不能在一维布局中使用 Grid。我经常在我需要准确地在一维空间控制元素的尺寸和位置时选择使用 Grid。就像在这个示例和随附的文章中：

在 [CodePen](https://codepen.io) 上查看 Michelle Barker ([@michellebarker](https://codepen.io/michellebarker)) 写的 [带有变量和媒体查询的 CSS Grid 组件](https://codepen.io/michellebarker/pen/XBPMZZ/)

## 你想要如何表现元素？

Grid 通常在你需要控制二维空间的布局时是一个正确的选择。但它不意味着对**任何情况**来说都是一个更好的选择。Grid 给你带来的网格轨道（多行和多列），网格单元以及网格区域（多个网格单元组成的组）并且元素必须被放置在这些网格单元或者 Grid 区域。我们可以使用 Grid 或 flexbox 进行布局，不过 Grid 布局相较起来更加简单明了。

假设我们有这样的布局：

我们有一个由九个等宽的元素组成的网格，从上到下排成三排，每个元素之间有 20px 的间隙：

```
.grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	grid-auto-rows: 200px;
	/* 假设我们想要我们的行都是一个固定的高度 - 如果我们想要高度响应地根据内容变化，可以保留为默认的 `auto` */
	gap: 20px;
}
```

元素之后就被自动放置，不需要我们再做其他的事情了。如果我们真的想要它变得非常灵巧，我们可以使用 Grid 的 _auto-fit()_ 和 _minmax()_ 方法来给我们一个不需要媒体查询的完全响应式的布局 - 尝试调整此示例的大小，看看会发生什么。

在 [CodePen](https://codepen.io) 上查看 Michelle Barker ([@michellebarker](https://codepen.io/michellebarker)) 的 [Grid 自适应例子](https://codepen.io/michellebarker/pen/bzvGaE/)。

我推荐观看 Heydon Pickering 的视频 [算法布局](https://www.youtube.com/watch?v=qOUtkN6M52M) 来作为一个对这个技术的概述等。

相反地，如果我们想要使用 flexbox 创建这个布局，我们可能要设置实际的**元素**和网格容器的样式：

```
.grid {
	display: flex;
	flex-wrap: wrap;
	margin: -10px;
	width: calc(100% + 20px);
}

.item {
	width: calc((100% / 3) - 20px);
	flex: 0 0 auto;
	margin: 0 10px 20px 10px;
}
```

我们需要在网格容器上使用负 margin 来抵消这一事实 —— 内部元素的总的宽度可能要比容器更大，因此它会被换行到下一行。我们也没有了开箱即用的响应式行为并且很可能需要使用媒体查询。

在 [CodePen](https://codepen.io) 上查看 Michelle Barker ([@michellebarker](https://codepen.io/michellebarker)) 的 [Flexbox 布局示例](https://codepen.io/michellebarker/pen/VgXwRJ/)。

使用 flexbox 可以通过几种不同的方式实现相同的布局，但他们都让我感觉有点复杂 - 它们本来就是那么复杂。我们将 flexbox 用于并不是它真正被设计出来要做的事 — 但并不意味着它总是错误的选择。

许多现代 CSS 框架对此布局使用此方法的一些变体。作为旁注，你若你真的要继续走这条路，我由衷地向你推荐 [Susy](https://oddbird.net/susy/)，它可以帮你处理大量的计算。

所以，什么是更好的选择 — Grid 还是 flexbox？似乎 Grid 有一些明显的优势，但为了回答这个问题，我们需要考虑当我们有超过 9 个但是少于 12 个元素（下一个允许他们填充一行的多个元素）时会发生什么。我们想要新元素就像我们已经看到的一样干脆直接放置在下一行的开始？又或是我们想要它表现的不一样？也许下一行就只有一个元素，我们希望它占用行所有的可用空间，就像下面的实例A。或者如果有两个元素，那么我们希望它们居中，就像下面的示例 B。

![](https://css-irl.info/to-grid-or-to-flex-01-54d85b1a963bc8bd56c67de60a19a9e8.svg)

使用 Grid 布局和自动放置，我们只能选择将最后一项放在左侧的单元格中，就像前面的例子所示 — 假设 [direction](https://developer.mozilla.org/en-US/docs/Web/CSS/direction) 的值未设置为 `rtl`（在这种情况下元素会被按从右到左的顺序放置，最后一项会放置在右侧的单元格）。

在 [CodePen](https://codepen.io) 上查看 Michelle Barker ([@michellebarker](https://codepen.io/michellebarker)) 的 [Flexbox 布局示例](https://codepen.io/michellebarker/pen/MLVYOq/)。

所以无论你为上面的布局选择 Grid 或者 flexbox，实际上都可归结为你希望你的网格元素的响应变化 - 并且能够针对不同的情况有不同的效果。

## 你想要用 Grid 替代 flexbox 吗？

当我演讲时，我经常被问到何时应该使用 flexbox 而不是 Grid，以及我们是否还需要 flexbox。在之前的例子里我们已经知道，Grid 不是 flexbox 的替代品。他们两者可以非常愉快的共存，并且知道何时使用它们可以为你的布局提供更多的动力。

![](https://css-irl.info/static/6620e303da7ceffb7ab2f86645b0f72c/893a4/to-grid-or-to-flex-02.jpg)

在上面的组件中，我们需要控制文本、图片以及横走坐标轴上的标题的位置，并控制它们如何在一定程度上相互交互。满意的实现这个效果的方法只能是使用 Grid。

但我绝对会用 flexbox 来构建一个桌面导航菜单：

在 [CodePen](https://codepen.io) 上查看Michelle Barker ([@michellebarker](https://codepen.io/michellebarker)) 的[Flexbox 导航](https://codepen.io/michellebarker/pen/bzvNmL/)。

这里我只想控制单维度的流，并且我想要元素是**响应式** - 这也是 flexbox 做的相当出色的地方。使用 flexbox 我们可以选择这些元素是否换行，并在所有项目无法显示在一行的情况下允许他们优雅地换行。

## 怎样适配不支持 Grid 的浏览器？

如果我们使用 Grid，另一个我们需要考虑的问题是浏览器是否支持以及我们想要在不支持的浏览器（IE11 及以下版本）上让我们的布局如何展示：

```
.grid {
	display: flex;
	flex-wrap: wrap;
	/* 其余的后备布局代码 */
}

@supports (display: grid) {
	.grid {
		display: grid;
		/* 其余的 Grid 布局代码 */
	}
}
```

然而，如果你发现你自己花费数小时的时间来试图为不支持 Grid 的浏览器复制**完全相同**的布局，那么可能一开始就不该 Grid。Grid 的好处是它可以做一些 flexbox 单独做不到的事情。

我们在这里讨论了一些非常简单，常见的布局的例子和如何使用 Grid 和 flexbox 来实现它们。如果想要看一些其他的复杂的例子，可以看一下这篇博客中的其他文章，或者继续关注我未来的更多帖子。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
