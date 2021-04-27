> * 原文地址：[Demystify Graph Coloring Algorithms](https://medium.com/better-programming/demystify-graph-coloring-algorithms-9ae51351ea5b)
> * 原文作者：[Edward Huang](https://medium.com/@edwardgunawan880)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/demystify-graph-coloring-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2021/demystify-graph-coloring-algorithms.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[flashhu](https://github.com/flashhu)

# 揭开图着色算法的神秘面纱

![Photo by [salvatore ventura](https://unsplash.com/@salvoventura?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12032/0*nMi_GsBxeMO5LlkM)

图着色是指将特定的颜色按照约束条件（相邻任意两个部分的颜色不能相同）在图中分配的问题。要进行图着色算法，你必须先为一个图形着色，要么是上色顶点或是上色图的边，并且需要保证不存在两个相邻的部分有相同的颜色 —— 没有两个相邻的顶点或边会有相同的颜色。

我是在偶然间发现了这个算法，并思考如何应用它。当我更深入地研究图着色问题以及实际使用时，我意识到它在我们使用的应用程序中有着广泛的应用。本文将简要介绍这种算法和图着色实例。

## 图着色算法

现实中存在许多与图着色问题相关的问题，你可以使用[顶点着色](https://mathworld.wolfram.com/VertexColoring.html#:~:text=A%20vertex%20coloring%20is%20an,colors%20for%20a%20given%20graph.)、边着色或[地图着色](https://en.wikipedia.org/wiki/Map_coloring#:~:text=Map%20coloring%20is%20the%20act,different%20features%20on%20a%20map.&text=The%20second%20is%20in%20mathematics,features%20have%20the%20same%20color.)解图着色问题。在这个算法中，你可以思考各种不同类型的问题。例如，我们可以解决不同时分配彼此依赖的相同资源的问题。我们也可以解决这样的问题：为这个图上色所需的最小颜色数是多少。此外，我们可以把它变成一个回溯问题，在这个问题中我们希望找到所有可能的着色方法可以着色这个图。

以下是一个简单的示例。只要我们理解了基本的算法，我们就能解决这些问题。

我们假设这是顶点着色问题，那么如果我想给图形着色，相邻的两个顶点将不会有相同的颜色。

我们假设一个图中有五个顶点。我们可以分配给每个顶点的最大颜色数是五个。因此，我们可以将颜色列表初始化为五种颜色。

![](https://cdn-images-1.medium.com/max/2000/0*dX9rqaI1V_1bvgv2.png)

接下来，开始在一个空白图中将任意一个顶点作为第一个顶点进行上色操作。

在下面的算法中，我们根据以下操作对图中的每个顶点进行着色：

* 遍历所有相邻顶点。如果相邻顶点有颜色，将该颜色放入一个桶（集合）中。
* 选择不在该桶（集合）中的第一种颜色，并将其指定给当前顶点。
* 清空桶，接着处理下一个尚未着色的顶点。

![](https://cdn-images-1.medium.com/max/2000/0*d2tx_zFC6IhmcT58.png)

这种贪心算法策略足以解决图着色问题。虽然它不保证最小颜色数量，但它保证了分配给图形的颜色数量上限。

我们遍历顶点，总是选择第一个不存在于其相邻顶点的颜色。我们开始算法的颜色选择顺序很重要。

如果我们迭代的顶点有较少的引入边，我们可能需要更多的颜色来给图着色。所以还有一种算法叫做韦尔奇-鲍威尔（Welch-Powell）算法。

我想解释一下韦尔奇-鲍威尔算法是如何工作的。为了证明在一个图中保证最小数量的着色，请查看下面的资料。这个话题有很多内容可以深入探讨。

该算法如下所示：

1. 计算每个顶点的入边，并按降序排列它们。
2. 选择最多入边的顶点作为第一个顶点，并为其分配颜色——我们称其为顶点 A。
3. 循环遍历其他顶点，只有在以下情况下才为顶点分配颜色：⑴ 不是顶点 A 的相邻点。⑵ 顶点尚未着色。⑶ 相邻顶点的颜色与顶点 A 的颜色不同。
4. 继续执行步骤 3，直到所有顶点都被着色。

现在你已经大致了解图着色算法，那你可能想知道，这样做有什么用呢？

## 算法使用情况

通常图着色算法用于解决资源有限和其他约束条件的问题。这个颜色是你试图优化的任何资源的抽象，图则是对问题的抽象。

图通常被建模为现实世界的问题，我们可以使用算法来找到图的相应属性来解决我们的一些问题。

让我们来看一些图着色用例。

## 调度算法

假设你有一系列的工作要做，而且只有几个工人。如果你在特定时间段内将工人合理分配到某个作业，将会对整体工作有所帮助。你可以按任何顺序分配作业，但一对作业可能会在一个时隙内发生冲突——因为它们共享相同的资源。如何有效地分配作业，使作业不会发生冲突？在这种情况下，顶点可以是作业，如果两个作业依赖于相同的资源，则边可以是两个作业的连接。如果你的工作进程数量不受限制，则可以使用图着色算法来获得调度所有作业的最佳安排时间，并且不会发生冲突。在这个例子中，颜色将是工人的编号。如果为两个顶点（作业）分配了相同的颜色，则该工作者将处理这两个作业。

另一个例子是制定日程表或时间表。你想做一个考试日程安排，每个科目都有一份学生名单，每个学生都要上多节课。你要确保安排的考试不会相互冲突。在这种情况下，顶点可以是课程，如果两个课程中都有相同的学生，则两个课程之间会有边。在这种情况下，图的颜色将是安排考试所需的时间段总数。因此，顶点 A 和顶点 B 上的相同颜色意味着 A 和 B 将在同一时间段中进行。

通常，这类问题中存在共享资源，我们希望有一个调度程序来确保系统中没有两个实体冲突。该颜色一般表示时间段或工作人员。

## 地图着色

![](https://cdn-images-1.medium.com/max/2000/0*fiE_-5ZC7cQZdSxN.gif)

在地图着色问题中，没有两个相邻的城市或州在地图上被分配相同的颜色。根据[四色定理](https://mathworld.wolfram.com/Four-ColorTheorem.html#:~:text=The%20four%2Dcolor%20theorem%20states,conjectured%20the%20theorem%20in%201852.)，四种颜色足以给任何地图上色。在这种情况下，顶点代表每个区域，它的每一个相邻区域可以被分类为一条边。

## 数独难题

![from ResearchGate-net](https://cdn-images-1.medium.com/max/2000/0*-aELwvDUPCYaizOI.png)

数独是图着色问题的一个变种，其中每个单元格代表一个顶点。如果两个顶点在同一行、列和块中，则在这两个顶点内形成一条边，每个块将有不同的颜色。

## 编译器的寄存器分配

编译器是将源代码从高级语言（Java、Scala）转换成机器代码的程序。这通常是分步骤进行的，最后一步是将寄存器分配给程序中最常用的值，同时将其它值放入内存。我们可以将符号寄存器（变量）建模为顶点，如果同时需要两个变量，则形成一条边。如果该图可以用 K 色进行着色，那么变量可以存储在 k 寄存器中。

图着色算法还有许多其它用例，希望你能有所收获！

## 补充资料

关于图着色算法以及它的用例，还有一些不错的资料。如果你想了解更多信息，请查看以下资料：

* [图算法](https://www.cs.cornell.edu/courses/cs3110/2012sp/recitations/rec21-graphs/rec21.html)
* [使用图着色调度并行任务（会议）| OSTI.GOV](https://www.osti.gov/servlets/purl/1524829)
* [图着色 | 第一讲（介绍及应用程序）— GeeksforGeeks](https://www.geeksforgeeks.org/graph-coloring-applications/?ref=rp)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
