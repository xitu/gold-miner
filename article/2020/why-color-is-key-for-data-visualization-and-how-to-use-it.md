> * 原文地址：[Why Color Is Key for Data Visualization and How to Use It](https://towardsdatascience.com/why-color-is-key-for-data-visualization-and-how-to-use-it-b24627116b71)
> * 原文作者：[Aseem Kashyap](https://medium.com/@aseem.kash)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-color-is-key-for-data-visualization-and-how-to-use-it.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-color-is-key-for-data-visualization-and-how-to-use-it.md)
> * 译者：[贺雪](https://github.com/Amy-Designer)
> * 校对者：[Chorer](https://github.com/Chorer)

# 颜色为何成为数据可视化的关键，怎样使用它？—— 数据分析&色彩应用理论

![图片](https://user-images.githubusercontent.com/5164225/91420085-bea57e80-e886-11ea-9bd5-f291b8da6711.png)

#### 最佳颜色应用的图解指南

数据可视化的目标是传递出在分析过程中发现的隐藏模式。虽然可视化结果必须看起来有审美吸引力，但它的主要目标并非“看着漂亮”。

> 在可视化中使用颜色应该有助于关键发现的传递，而非追求一些艺术造诣。

#### 就颜色而言，并非多多益善

颜色的使用策略必须经过仔细的制订，以便关键发现的传递，因此，我们不能把这件事交给自动化算法来完成。**大多数数据应使用灰色这样的中性色，而明亮色则用以将注意力引导至重要或非典型数据点上。**

![](https://cdn-images-1.medium.com/max/2000/1*k67hW4R2Pb6NWdFgXJ5wFg.png)

图：1991–1996 年的销售额（单位：百万美元）。红色用于提醒人们注意到 1995 年异常低的销售量，其它年份近乎一致的销售额则都是用灰色呈现的。[图源来自作者]

#### 颜色有助于对相关数据点进行分组

颜色可用于对包含相似值的数据点进行分组，并且通过使用以下两个调色板来呈现这种相似程度：

![[图源来自作者]](https://cdn-images-1.medium.com/max/2000/1*dhyh0FhGdRKBtQYuNXYFig.png)

**顺序调色板** 是在统一的饱和度下，由单一色相中不同强度的色调组成的。邻近颜色的明度变化与它们用于呈现的数据值的变化相对应。

![[图源来自作者]](https://cdn-images-1.medium.com/max/2000/1*Rps6Rqc2LbFZyhW1YIyHLw.png)

**相异调色板** 是由两个顺序的调色板（每个均为不同色调）堆叠在一起，中间有个拐点。当需要在两个不同方向上呈现可视化数据时，这些调色板会非常有用。

下方左边的图表使用了由单一色相（绿色）组成的顺序调色板，用以表示 -0.25 到 +0.25 之间的值，而右边的图表则使用了相异调色板来表示正值（蓝色）和负值（红色）。

![](https://cdn-images-1.medium.com/max/2620/1*ypk58BjbbjxuB0VUslVyKw.png)

图：2010-2019 年间的美国人口百分比变化。以零为拐点、由两种色相（红色和蓝色）组成的相异调色板比顺序配色方案更合适。[图源来自作者]。[数据来源](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-counties-total.html)。

在右侧的地图中，单凭颜色即可立即分辨出正负值。我们可以马上得出这样的结论：中西部和南部城镇的人口减少了，而东海岸和西海岸的人口增加了。**这种对数据的关键洞察在左侧的图表中并非一目了然，我们必须通过绿色的饱和度，而非颜色本身来读懂地图。**

#### 类别色彩可以用于表示完全不相关的数据

![[图源来自作者]](https://cdn-images-1.medium.com/max/2000/1*16lnKOqQDF2nWfRhEzLkhg.png)

**类别调色板** 是在统一的饱和度和色调强度下，由不同色相派生而来的，可用于将来源完全不同的无关数据点或是无关数值进行可视化。[请查看](http://archive.nytimes.com/www.nytimes.com/interactive/2011/01/23/nyregion/20110123-nyc-ethnic-neighborhoods-map.html?_r=0)纽约市不同种族的可视化数据图表。不同种族的数据之间没有相关性，因此这里采用了类别调色板。

> 顺序调色板和相异调色板应该通过对定性值进行编码来呈现幅度变化；而类别调色板应该通过对定量值进行编码来呈现无关数据的类别。

#### 类别色彩只有几个容易分辨的区块

虽然使用不同的颜色有助于区分不同的数据点，但图表最多只应有 6-8 种不同的颜色类别，以便快速进行分辨。

![](https://cdn-images-1.medium.com/max/2482/1*WTKqzvNWimO5Hxe-HZJiZw.png)

图：在役卫星数量排名前 15 名的国家。[图源来自作者]。[数据来源](https://www.n2yo.com/satellites/?c=&t=country)

在 15 个国家中，每个国家都使用了不同的颜色，这让左边图表的阅读性变差，特别是那些拥有较少卫星的国家。右边的图表更易阅读，代价是舍弃拥有较少卫星的国家的信息，所有此类信息都被归在“其它”区块中。

请注意，我们在这里采用类别配色方案的原因是：各个国家间的数据完全不相关，例如，印度卫星的数量完全独立于法国。

#### 图表类型的变化经常伴随着颜色需求的减少

在前面的例子中，饼图可能并非最佳选择，因为它造成的类别方面的信息损失有时候是让人难以接受的。通过绘制条形图来进行代替，我们就可以只用一种颜色，同时还能保留全部的 15 个数据类别。

![](https://cdn-images-1.medium.com/max/2000/1*3dvxxps_iDNeTuZICwyd4g.png)

图：前 15 个国家的在役卫星数量。[图源来自作者]。[数据来源](https://www.n2yo.com/satellites/?c=&t=country)

> 如果在可视化数据图表中需要使用不止 6-8 种不同的颜色（色相），要么合并一些类别，要么尝试一下其它图表类型。

#### 什么时候不使用顺序配色方案

为了使一个顺序调色板中细微的色彩差异变得十分明显，这些颜色必须如下面左边的图表所示，互相之间紧挨着放置。当它们如在散点图中彼此分开时，那些细微的色彩差异就会变得难以掌握。

![当数据点如右边的散点图中那样，没有被紧挨着放置时，顺序配色方案的阅读性变差。这些颜色只能如左边的图表中那样，用来可视化相对值。[图源来自作者]](https://cdn-images-1.medium.com/max/2000/1*HqwJC1UmrFRhlvrbss7JnQ.png)

> 顺序配色方案的最佳使用方式是呈现数值间的差异。它并不适用于绘制绝对值，绝对值最好是通过类别配色方案进行呈现。

#### 选择合适的背景

请查看由 Akiyoshi Kitaoka 制作的 [动画](https://twitter.com/i/status/1028473566193315841)，它展示了我们对移动方块颜色的感知是如何随着背景的变化而变化的。**人类对颜色的感知并非绝对的，而是与周围环境相关联的。**

对一个物体的颜色感知不仅取决于物体本身的颜色，还会被其背景所影响。因此，我们得出以下关于在图表中使用背景颜色的结论：

> 按相同颜色分组的不同对象应该搭配相同的背景。这通常意味着背景颜色的变化必须被最小化。

#### 不是每个人都能看到所有的颜色

世界上大约有 10% 的人是色盲，为了让每个人都能看到彩色的信息图，请避免使用红色和绿色的组合。

![](https://cdn-images-1.medium.com/max/2000/1*a411ds64pbdeuwK7R5yu3w.png)

图：色盲如何影响对颜色的感知。[图源来自作者]

#### 结论

> 可视化的推动力是讲述数据背后的故事。只有充分地利用好颜色才有助于强化这个故事中的关键论点。

我在工作中发现了一些有助于颜色在数据分析和可视化中进行应用的资源，总结如下：

## 用以挑选颜色组合的工具

1. [Colour brewer](https://colorbrewer2.org/#type=qualitative&scheme=Set3&n=6)
2. [d3-interpolate](https://github.com/d3/d3-interpolate)
3. [Colourco](https://colourco.de)
4. [Color Palette Helper](https://vis4.net/palettes/#/9|d|00429d,96ffea,ffffe0|ffffe0,ff005e,93003a|1|1)
5. [I want hue](https://medialab.github.io/iwanthue/)
6. [Adobe Colour](https://color.adobe.com/create/color-wheel)

## 颜色应用理论：阅读列表

1. [颜色在图表中的实战规则](https://nbisweden.github.io/Rcourse/files/rules_for_using_color.pdf) by **Stephen Few**.
2. [颜色在数据可视化中的重要性](https://www.forbes.com/sites/evamurray/2019/03/22/the-importance-of-color-in-data-visualizations/#451901e057ec) by **Eva Murray**.
3. [100 种颜色组合以及如何应用它们。](https://www.canva.com/learn/100-color-combinations/)
4. [如何为你的数据可视化作品挑选完美的颜色组合](https://blog.hubspot.com/marketing/color-combination-data-visualization) by **Bethany Cartwright**.
5. [调色板的影响力：为什么颜色是数据可视化的关键，以及如何使用它](https://theblog.adobe.com/the-power-of-the-palette-why-color-is-key-in-data-visualization-and-how-to-use-it/) by **Alan Wilson** 
6. [在进行数据可视化时选择颜色时要考虑什么](https://www.dataquest.io/blog/what-to-consider-when-choosing-colors-for-data-visualization/)
7. [颜色在数据可视化中的使用](https://earthobservatory.nasa.gov/resources/blogs/intro_to_color_for_visualization.pdf) by **Robert Simmon**
8. [颜色在地图中的使用](https://morphocode.com/the-use-of-color-in-maps/)

请留下您的评论或给我的邮箱 aseem.kash@gmail.com 写信发表建议。感谢您的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
