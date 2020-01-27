> * 原文地址：[Is No-SQL killing SQL?](https://towardsdatascience.com/is-no-sql-killing-sql-3b0daff69ea)
> * 原文作者：[Tom Waterman](https://medium.com/@tjwaterman99)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md)
> * 译者：[江不知](http://jalan.space)
> * 校对者：

# SQL 将死于 No-SQL 之手？

![](https://cdn-images-1.medium.com/max/2688/1*b5c0bA8yVQ7Zeli-6nrXHA.png)

#### SQL 永生不灭的两个原因

上周，我的一位朋友向我转发了一封来自一位成功企业家的电子邮件，邮件宣称「SQL 已死」。

这位企业家宣称，像 MongoDB、Redis 这样广受欢迎的 No-SQL 数据库会慢慢取代基于 SQL 的数据库，因此，作为数据科学家还需学习 SQL 是一个「历史遗留问题」。

I was completely shocked by his email: how had he reached a conclusion that was so off-base? But it also made me curious… Was it possible that others were similarly misinformed? The entrepreneur had developed a large following and was quite outspoken — were new data scientists receiving the advice that they should avoid learning SQL?
看到他的电子邮件我十分震惊：他是如何得出如此毫无根据的结论？但是这也使我感到好奇……别人是否也有可能被类似地误导了？这位企业家已发展了大批追随者，且直言不讳 —— 新晋数据科学家是否已经收到了避免学习 SQL 的建议？

因此我觉得我应当公开分享我对该企业家的回应，以防他人认为 SQL 即将走向灭绝。

> 在数据科学领域，你**绝对**应当学习 SQL。No-SQL 的存在对学习 SQL 的价值毫无影响。

基本上有两个原因可以保证SQL在未来几十年仍然适用。

**原因 #1：No-SQL 数据库无法取代数据分析型数据库，例如 Presto、Redshift 或 BigQuery**

Regardless of whether your applications use a SQL-backend like MySQL or a No-SQL backend like MongoDB, the data in that backend will eventually be loaded into a specialized analytics database like Redshift, Snowflake, BigQuery, or Presto.

![Example architecture of a platform with an analytics database: SQL and NoSQL](https://cdn-images-1.medium.com/max/3104/1*LBVLAfUu29FwbYCFF0vRCg.png)

Why do companies transfer their data into specialized columnar stores like Redshift? Because columnar stores are capable of running analytics queries **much** faster than both NoSQL and row-store databases like MySQL. In fact, I’d bet that the columnar store databases are growing in popularity just as fast as the NoSQL databases.

So the technology of the application database, NoSQL or otherwise, is typically not relevant for Data Scientists because they don’t use the application database (although there are some exceptions I’ll discuss later).

**原因 #2：No-SQL 数据库的好处不在于他们不支持 SQL 语言**

It turns out that the No-SQL stores could implement a SQL-based query engine if it made sense for them to support it. Similarly, the SQL databases could support NoSQL query languages, too, but they choose not to.

So why do the columnar store databases **intentionally choose** to provide a SQL interface?

They make that choice because SQL is actually an incredibly strong language for expressing data manipulation instructions.

Consider the simple example of a query that counts the number of documents in a collection from the NoSQL database MongoDB.

> Note: Documents in MongoDB are analogous to rows, while collections are analogous to tables.

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

It should be clear that the SQL language is the better choice for a human that wants to extract data. (The NoSQL databases support a different language because SQL is comparatively harder for application libraries that interface with the database to construct correctly).

---

I mentioned previously that there are exceptions to the rule that the technology of the application’s database isn’t relevant for data scientists. At my first company, for example, we didn’t actually have an analytics database like Redshift, so I had to query the application’s database directly. (More accurately, I was querying a read-replica of the application’s database).

The company’s application also used the No-SQL database Redis, and there was at least one occasion where I needed to pull data from Redis directly, so I did have to learn some components of Redis’ NoSQL API.

So it’s possible that in environments where the primary application uses a NoSQL database exclusively, any SQL you learn won’t be relevant. But those environments are quite rare, and as the company grows, they’ll almost certainly invest in a columnar store analytics database that supports SQL.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
