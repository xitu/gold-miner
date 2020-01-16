> * 原文地址：[Is No-SQL killing SQL?](https://towardsdatascience.com/is-no-sql-killing-sql-3b0daff69ea)
> * 原文作者：[Tom Waterman](https://medium.com/@tjwaterman99)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-no-sql-killing-sql.md)
> * 译者：
> * 校对者：

# Is No-SQL killing SQL?

![](https://cdn-images-1.medium.com/max/2688/1*b5c0bA8yVQ7Zeli-6nrXHA.png)

#### Two reasons why SQL will never, ever die

Last week a friend forwarded me an email from a successful entrepreneur that pronounced “SQL is dead.”

The entrepreneur claimed that the wildly popular, No-SQL databases like MongoDB and Redis would slowly strangle SQL-based databases out of existence, and therefore learning SQL as a data scientist was a “legacy concern.”

I was completely shocked by his email: how had he reached a conclusion that was so off-base? But it also made me curious… Was it possible that others were similarly misinformed? The entrepreneur had developed a large following and was quite outspoken — were new data scientists receiving the advice that they should avoid learning SQL?

So I thought I’d share my response to the entrepreneur publicly, in the chance that anyone else believes SQL is being ran into extinction.

> You should **absolutely** learn SQL for a career in data science, period. No-SQL will have No-effect on the value of learning SQL

There’s basically two reasons that guarantee SQL will stay relevant for many decades to come.

**Reason #1: No-SQL databases won’t replace analytics databases like Presto, Redshift, or BigQuery**

Regardless of whether your applications use a SQL-backend like MySQL or a No-SQL backend like MongoDB, the data in that backend will eventually be loaded into a specialized analytics database like Redshift, Snowflake, BigQuery, or Presto.

![Example architecture of a platform with an analytics database: SQL and NoSQL](https://cdn-images-1.medium.com/max/3104/1*LBVLAfUu29FwbYCFF0vRCg.png)

Why do companies transfer their data into specialized columnar stores like Redshift? Because columnar stores are capable of running analytics queries **much** faster than both NoSQL and row-store databases like MySQL. In fact, I’d bet that the columnar store databases are growing in popularity just as fast as the NoSQL databases.

So the technology of the application database, NoSQL or otherwise, is typically not relevant for Data Scientists because they don’t use the application database (although there are some exceptions I’ll discuss later).

**Reason #2: the benefits of NoSQL databases aren’t because they don’t support the SQL language**

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

Compare that to the equivalent SQL.

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
