> * 原文链接：[Design Better Data Tables](https://medium.com/mission-log/design-better-data-tables-430a30a00d8c#.ju6qcpd2c)
* 原文作者：[Matthew Ström](https://medium.com/@ilikescience)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[Kulbear](https://github.com/Kulbear), [Gran](https://github.com/Graning)

# 这样做才能设计出更好的数据表

**差强人意的表格。**他们哪里没有做对？

由于一些历史原因，表格在成为网页的必须品之后，因为有更加新潮，更加时髦的布局，它被很多设计师弃用。但是现如今，他们没法在网页上再创造出更多的外观，而数据表格仍然可以用于收集和组织很多我们日常生活中使用的信息。

例如，我认为所有表格的起源是：美国的 `"Harmonized Tariff 的计划表"`，一个包含有 3,550 页的表格，它罗列了每一样可以被进口入美国的货物清单，包含有些令人兴奋的货物，例如，"男士外衣，短大衣，披肩，斗篷，厚夹克（包括滑雪夹克），防风夹克和相似的东西（包括棉外套，背心夹克）。"

![](https://cdn-images-1.medium.com/max/1600/1*NoYxEosGh6slPJUUPE1buw.png)

不过，什么是短风衣？

数据表格让人不爽的地方（毫无疑问），是没有被精美的设计过，它看起来太丑了。设计是一个表格的关键: 如果正确的制作一个表格，它会让复杂的数据变得容易检索和比较。如果错误的制作一个表格，它能让所要表达的信息完全不能被理解。

所以，让我们用正确的方式（制作一个表格），好吧？

理解你的数字符号

数字并非生来平等。我并不是在讨论 `π` 和 `∞`（虽然我常这样，在实践中）; 我正在讨论的数字，它们是 *tabular* 或者 *oldstyle*, *lining* 或者 *proportional*。 

以下插图展示了 *oldstyle* 和 *lining* 的不同。

![](https://cdn-images-1.medium.com/max/2000/1*xWe8Z0-KdRwoncgUtIWG7g.png)

`Oldstyle` Vs. `lining` 数字

`Oldstyle` 的数字在句子中看起来很漂亮，他们在小写字母的大小和间距上匹配得更好; `lining` 的数字更统一，并且加强了表的网格状结构。 

*proportional* 和 *tabular* 数字之间的区别并不明显:

![](https://cdn-images-1.medium.com/max/2000/1*Xj1N2kM1uKC58kRYGxehag.png)

`Proportional` vs. `tabular` 数字

`Proportional` 数字被设计成匹配颜色 - 它是一般的大小和字间距 - 的字型。`Tabular` 数字，另一方面而言，都是统一的的大小，所以每列数字都能整齐的排列起来。虽然这个区别在 1 或 2 行看上去不是那么强烈，使用 `lining` 的数字会让查看大型的表格变得很容易并且更少的错误率。

#### 一份有关使用 `tabular` `lining` 数字的技术说明

当设计表格的时候，你需要为确保你正在使用的数字符号是正确的那个多做一些功课（`tabular` `lining` 数字并不是一般的默认值）。`Adobe` 的产品有一个 `opentype` 面板，它能被使用来设定合适的数字，并且 `CSS` 提供了一个 [有点神秘的语法](https://css-tricks.com/almanac/properties/f/font-feature-settings) 为了启用这个特性。除此之外，你可以 `google` 一些结果，它们将带领你走向正确的道路。

现在播送一条坏消息: 不是所有的字型都有 `tabular` `lining` 数字。[有些可能会贵](https://www.myfonts.com/fonts/fontfont/ff-meta/)。也有一些例外: 这个很棒的 [Work Sans](https://fonts.google.com/specimen/Work+Sans) 是一个免费的字型，它有真正的 `tabular` `lining` 数字。

如果你无法找到一个合适的有 `tabular` `lining` 字型，一个好的回退方案是 `等宽字体` -  当然他们会看上去像 `源码`，他们能很好的在表内展示。额外的，新的 `Apple` 系统默认的字体 `San Francisco` 就有很出色的 `tabular` `lining` 数字，在小号的表现上也是很好看的。

### 对齐很重要

3½ 关注这些简单原则:

* 1. 数值数据向右对齐
* 2. 文本数据向左对齐
* 3. 表头和他们的数据对齐
* 3½. 不要使用居中对齐

![](https://cdn-images-1.medium.com/max/2000/1*ReTh9L-cl-QStJVAUVqejA.png)

美国人口历史表 — [Wikipedia](https://en.wikipedia.org/wiki/List_of_U.S._states_by_historical_population)

数值数据从右向左读; 我们比较数字通过先看个位数字，再看十位数字，等等。这就是大部分人学习算数的方法 - 先从右开始再往左，依次读数据。因此，表格应该以右对齐的方式保存数值数据。

文本数据从左往右读（以英文为例）。比较文本元素通常是通过字母表的排序完成: 如果两个文本的起始字母都是相同的，那就从第二位开始比较，依次类推。尝试阅读非左对齐的文本是很令人很抓狂的。

表头，通常来说，应该和他们的数据对齐。这保持了垂直的行看上去很干净，并且提供了一致性和上下文。

居中对齐会让表格变得 “参差不齐”，这让查看变得更加困难，常常需要额外的分割线和图形元素。

#### 一样有效的数字 = 更好的对齐方式

保持有效数字的一致性 - 常常是小数点后的数字，是一种简单又更好的对齐表格的方法 - 保持同样位数的小数，每一列都一致。有效数字是整篇文章的 "兔子洞"，所以我将简单的阐述我的建议: 更少的有效数字，更好的效果。

#### 更少的，更简洁的标签

为你的数据增加标签是至关重要的。这些伴随着表格上下问的标签，可能给读者一个更广的阅读视角。

![](https://cdn-images-1.medium.com/max/1600/1*na9P5f323Pi8sI-kpvLs9w.png)

`密西西比河洪水水位状况预报` - [NOAA](http://www.srh.noaa.gov/lmrfc/?n=lmrfc-mississippiandohioriverforecast)

#### 标题

这听上去像传统观点，但是赋予你的数据表格一个干净和简洁的标题和其他你所做的设计决定是一样重要的。有一个好的标题，表格是可扩展的: 他们能被用于不同的上下文，也一样能被外部的数据引用。

#### 单位

在表格里最常用的标签是对数据的计量单位; 常常，它重复出现在每个数据点。无需重复给所有数据添加单位，在每列的第一个数据点上增加即可。

#### 表头

尽可能的保持表头；数据表格的设计应当关注数据本身，并且表头标签会占据很多可视空间。

#### 给自己省点墨

当决定对表选择什么样式的图形元素的时候，你的目标应该是在确定表格保真度的同时，减少表格占据的空间。一个可能的方式就是少用点墨水 - 无论何时，都不要设计元素的样式。

![](https://cdn-images-1.medium.com/max/2000/1*71B5i6rZMMsryN0pDwuXzw.png)

'2016 美国职棒大联盟统计' - [BaseballReference](http://www.baseball-reference.com/leagues/NL/2016.shtml)

#### 规则

如果你能在你的表格中对齐数据点，规则就不是那么重要了。他们主要提供的便利是，允许你减少元素间距的同时，还能很好的区分开不同的元素。即使应用了一些规则，它也应该几乎不会对你的快速阅读造成困扰。

水平的规则是最有用的，因为他们允许你大大减少长表格的垂直间距占用的空间，让对比不同的数值变得更快或者看到一段时间内（数据的）趋势。

我有一个未经证实的规则是 **斑马条纹是糟糕的**。实际上，非常糟糕。选用或者弃用。

#### 背景

背景在区分不同区间的数据时，是十分实用的: 比如，频繁切换于单一值，总数和平均值之间。如果只需要将数据高亮，为数据提供额外的上下文，或凸显和前一时期不同的变化数值是需要用背景的，使用图形元素会更好，例如 ✻, † （我最爱的之一）, 或者 ▵.

另外，表格应该是单色的。使用颜色来提供有组织的上下文或者增加额外的意思，很可能提高了误解和错误率，并且对那些视力不好的人来说会造成使用上的问题。

### 总结

表格可能是 [无趣的](https://medium.com/mission-log/well-designed-interfaces-look-boring-568faa4559e0#.e6301amez)，但是他们对包含有大梁数据的文档都是十分重要的，他们每一块都值得仔细的设计。通过设计更高效，更清晰，和易于使用的表格，你能显著改善分析理解大量数据所带来的痛苦。

#### 延伸阅读 & 灵感

[**FiveThirtyEight**](http://fivethirtyeight.com/features/the-rise-and-rise-of-nneka-ogwumike/) 是一个伟大灵感的来源 - 他们把数据设定在一个叫做 [Decima Mono](https://www.myfonts.com/fonts/tipografiaramis/decima-mono/) 的字型上，它特别为了将很多数据适应一个小空间而设计。

[**Butterick’s Practical Typography**](http://practicaltypography.com/) 是我的一个秘密武器，它会被使用在我所有需要排版印刷的东西上，并且所有你需要留有多分拷贝的参考资料 - 它太适用了！

最后，如果没有 [**Edward Tufte**](http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=00041I)，那就没有任何有关数据设计的文章能被完成。他对有关设计的富有洞察力的作品是不可缺少的。

***[1]*** 有关其他对算术有关的实现，可查看日本孩子是怎么使用 [*Soroban*](https://www.youtube.com/watch?v=Px_hvzYS3_Y) 或者 [*lattice multiplication*](https://www.khanacademy.org/math/arithmetic/multiplication-division/lattice-multiplication/v/lattice-multiplication) 是怎么工作的。
