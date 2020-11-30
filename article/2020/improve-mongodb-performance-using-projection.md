> * 原文地址：[Improve MongoDB Performance Using Projection](https://medium.com/better-programming/improve-mongodb-performance-using-projection-c08c38334269)
> * 原文作者：[Tek Loon](https://medium.com/@tcguy)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improve-mongodb-performance-using-projection.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improve-mongodb-performance-using-projection.md)
> * 译者：[onlinelei](https://github.com/onlinelei)
> * 校对者：[ivileey](https://github.com/ivileey)，[loststar](https://github.com/loststar)

# 利用映射提高 MongoDB 性能

![Photo by [Greg Rosenke](https://unsplash.com/@greg_rosenke?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10744/0*xNUvb3ABjaziY-2J)

本文记录了我的所有发现并且分析了在 MongoDB 中使用映射时对查询性能的提升。在文章的最后，我们将知道是否能通过映射提高 MongoDB 的查询性能。

事不宜迟，让我们开始吧。

## 问题描述

这篇文章的灵感来源于我曾在工作中使用[映射](https://docs.mongodb.com/manual/reference/glossary/#term-projection)在 MongoDB 数据库中查询数据。映射就是**“在文档中查询时指定返回的结果集字段”**具体可以查看 MongoDB 的官方[文档](https://docs.mongodb.com/manual/reference/glossary/#term-projection)

就像在麦当劳里买汉堡一样，我们可以选择单点一些菜品，而不是选择包含饮料和薯条的套餐。

因此，我想要了解使用映射能让查询性能提高多少。以下是主要目标：

#### 主要目标：

* 检测 MongoDB 时使用映射是否能提高查询性能。
* 寻找 MongoDB 中使用映射查询的最佳方案。

## 解决方案分析

我喜欢循序渐进的方式研究问题。这次也是一样：

* 我需要一个超过 50 万条数据的文档。这样我们能清楚的利用查询时间分辨使用映射和不使用时的性能差别。
* 我怀疑有子文档集合会增大查询时间，所以我们准备了子文档。

有关数据的准备，请参考下面的截图。关于如何生成百万级别的虚拟数据请参考这篇 [文章](https://medium.com/@tcguy/mongodb-performance-101-how-to-generate-millions-of-data-for-performance-optimization-cf45d3556693)。

![](https://cdn-images-1.medium.com/max/2128/1*iYK8wFD1zZg_ItA_GFPSUg.png)

上面这张截图中可以看到，我们已经生成了 50 万条用下面这些字段组成的文档：

* `booking_no` — 航班编号
* `origin` — 始发地
* `destination` — 目的地
* `persons` — 由包含 `姓`、 `名` 和 `出生日期` 对象组成的数组

## 性能试验

在开始性能试验之前，请确保所有的配置正确。除了默认的 `_id` 字段以外，没有创建其他的索引。

下面是我想演示的实验：

* 实验 1：查询的性能会因为映射字段的减少而提高吗？
* 实验 2：如果减少字段不能提高查询性能，还有哪些方法能够提升查询性能？

## 实验 1：查询的性能会因为映射字段的减少而提高吗？

不幸的是，性能并没有提高。但是如果把所有查询的字段加上索引，会提高查询性能，我将在下一章节讨论这一点。

在这次实验中，我们查询所有目的地为 “Gerlachmouth” 的航班订单。在 50 万笔订单中，满足条件的有 93 个订单。我们来看下需要多少时间。

为了查看消耗的时间，我使用了 Mongo Shell Explain 函数。

![](https://cdn-images-1.medium.com/max/2000/1*ZILEtJVXHlvsVaKlImVusA.png)

上面这张截图没有使用到映射。查询时间用了 461 毫秒。下面这张图中虽然使用到了映射，但是查询时间却用了 505 毫秒。

使用映射的并没有提高性能，却花费了更多的时间。

![](https://cdn-images-1.medium.com/max/2000/1*1jXiJv35xCeu0cYVUtsuZQ.png)

在查询中使用映射，实验 1 的结论是 —— 性能没有提高。👎👎

## 实验 2：如果减少字段不能提高查询性能，还有哪些方法能够提升查询性能？

因为第一个实验的失败，我研究了 MongoDB 大学提供的 [性能优化课程](https://university.mongodb.com/courses/M201/about)。这个课程是免费的，如果你想学习 MongoDB 性能优化课程，点击前面的链接。

然后我就发现了覆盖索引。根据 MongoDB 的官方 [文档](https://docs.mongodb.com/manual/core/query-optimization/#covered-query) 描述，覆盖索引是一种“可以完全使用索引的查询，不需要去访问文档”。

让我们拿烹饪来举例子，当你要做一顿饭时，你所需要的食材都已经准备好在冰箱里了，你要做的就只是加工一下而已。

在我们创建任何索引之前，我们要知道我们期望返回的字段有哪些，例如下面这些情况。

* 管理员希望知道到达某个目的地的所有航班订单。订单的信息包含 `航班号`, `始发地` 和 `目的地`。

根据上面知道的这些信息，我们可以创建两个索引。

* 目的地 — 在 `目的地` 字段上创建索引。
* 目的地、 始发地 和 航班号。 — 我们可以在字段 `目的地`、 `始发地` 和 `航班号` 上创建联合索引。

如何创建索引，请参考下面的命令。

#### 不使用映射进行查询

首先，我们查询目的地为 “Gerlachmouth” 的订单。下面的截图显示了查询消耗的时间。很显然，执行时间减少到了 **5 毫秒**。比不使用索引快了 **100 倍**。

你可能感觉这已经很棒了，但是这并不是最好的效果。在使用**覆盖索引**的情况下，可以将查询速度提高 **250 倍**。

![](https://cdn-images-1.medium.com/max/2000/1*_07K8c-uv2n9X9cahQnEGQ.png)

## 使用映射查询（覆盖索引）

使用覆盖索引意味着，我们所有想要的字段都被索引包含。

使用覆盖索引，可以将查询时间逼近 **2 毫秒**，比不使用索引性能大概提高了 **60%**。

除了提升查询消耗的时间，我们还改善了查询策略。从图中可以看出，索引本身已经包含了查询所需的字段。因此我们不需要查询任何文档，这从整体上提高了查询性能。

![](https://cdn-images-1.medium.com/max/2000/1*R24vSTP-N7x_kfh2ucWr-g.png)

## 总结

本文重点：

* 查询更少的字段并不能提升性能，除非需要返回的字段都在索引中。
* 索引可以提高查询性能，如果是覆盖索引的话性能将大幅度提高。
* 覆盖索引比不使用索引性能提升接近 60%。

感谢阅读，下篇文章见。

## 参考

* Projects Field From Query — MongoDB [Documentation](https://docs.mongodb.com/manual/tutorial/project-fields-from-query-results/)
* A Thorough Explanation from [StackOverflow](https://dba.stackexchange.com/questions/198444/how-mongodb-projection-affects-performance)
* Explain Output — MongoDB [Documentation](https://docs.mongodb.com/manual/reference/explain-results/#executionstats)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
