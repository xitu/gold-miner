> * 原文地址：[Is No-SQL killing SQL?](https://towardsdatascience.com/is-no-sql-killing-sql-3b0daff69ea)
> * 原文作者：[Tom Waterman](https://medium.com/@tjwaterman99)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md)
> * 译者：[江不知](http://jalan.space)
> * 校对者：[Jessica](https://github.com/cyz980908), [司徒公子](https://github.com/stuchilde)

# SQL 将死于 No-SQL 之手？

![](https://cdn-images-1.medium.com/max/2688/1*b5c0bA8yVQ7Zeli-6nrXHA.png)

#### SQL 永生不灭的两个原因

上周，我的一位朋友向我转发了一封来自一位成功创业者的电子邮件，邮件宣称「SQL 已死」。

这位创业者宣称，像 MongoDB、Redis 这样广受欢迎的 No-SQL 数据库会慢慢取代基于 SQL 的数据库，因此，作为数据科学家还需学习 SQL 是一个「历史遗留问题」。

我完全被他的电子邮件震惊了：他怎么得出如此离谱的结论？但是这也使我感到好奇……别人是否也有可能被类似地误导了？这位企业家已经发展了大批追随者，且直言不讳 —— 那么新晋数据科学家是否已经收到了避免学习 SQL 的建议？

因此我觉得我应当公开分享我对该创业者的回应，以防他人认为 SQL 即将走向灭绝。

> 在数据科学的职业生涯中，你**绝对**应当学习 SQL。No-SQL 的存在绝对不会影响学习 SQL 的价值。

基本上有两个原因可以保证 SQL 在未来几十年仍然适用。

**原因 #1：No-SQL 数据库无法取代数据分析型数据库，例如 Presto、Redshift 或 BigQuery**

无论你的应用是使用以 SQL 为后端的数据库，例如 MySQL，或是以 No-SQL 为后端的数据库，例如 MongoDB，这些后端中的数据最终都将被加载到一个专用的数据分析数据库中，例如 Redshift、Snowflake、BigQuery 或 Presto。

![分析型数据库平台架构示例：SQL 与 NoSQL](https://cdn-images-1.medium.com/max/3104/1*LBVLAfUu29FwbYCFF0vRCg.png)

为什么公司要将他们的数据转移到像 Redshift 这样特定的列式存储中？因为和 NoSQL 与 MySQL 这样的行式存储数据库相比，列式存储能**更**快地运行分析查询。事实上，我敢打赌，列式存储和 NoSQL 一样会越来越受欢迎。

因此，无论是 NoSQL 还是其他的应用程序数据库都与数据科学家无关，因为数据科学家不会对应用程序数据库进行操作（尽管有一些例外，这些例外我将在之后讨论）。

**原因 #2：No-SQL 数据库的好处不在于他们不支持 SQL 语言**

事实证明，如果 No-SQL 数据存储支持基于 SQL 的查询引擎是有意义的，那么它们就可以实现该引擎。类似地，SQL 数据库也可以支持 NoSQL 查询语言，但是它们选择不支持。

为什么列式存储**有意选择**提供 SQL 接口呢？

他们之所以作出这样的选择是因为 SQL 是一种表达数据操作指令的强大语言。

让我们来考虑一个简单的查询示例，该查询用于计算来自 NoSQL 数据库 MongoDB 中某集合的文档数量。

> 注意：MongoDB 中的文档类似于行，集合类似于表。

```js
db.sales.aggregate( [
  {
    $group: {
       _id: null,
       count: { $sum: 1 }
    }
  }
] )
```

将其与等价的 SQL 语句进行比较。

```sql
select count(1) from sales
```

显然，对于想要提取数据的人来说，SQL 语言是更好的选择。（NoSQL 数据库支持另一种语言，因为对于与数据库连接的应用程序库来说，正确构造 SQL 相对比较困难）。

---

在前面我提到过，应用程序数据库技术与科学家无关的规则是有例外的。例如，在我的第一家公司，我们实际上没有任何像 Redshift 这样的分析型数据库，所以我不得不直接查询该应用程序的数据库。（更准确地说，我是在查询应用程序数据库的只读副本）。

公司的应用也使用了 Redis 这样的 No-SQL 数据库，这样至少有一次，我需要从 Redis 中提取数据，所以我必须学习一些 Redis 的 NoSQL API 的某些组件。

因此，如果在主应用程序环境中完全使用 NoSQL 数据库，那么你学到的任何 SQL 知识都与之无关了。但是这样的环境非常少见，随着公司的发展，他们几乎都会把一个基于 SQL 的列式存储数据库投入使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
