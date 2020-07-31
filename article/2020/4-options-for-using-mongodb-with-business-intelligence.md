> * 原文地址：[4 Options for Using MongoDB with Business Intelligence](https://levelup.gitconnected.com/4-options-for-using-mongodb-with-business-intelligence-ec278738b5d2)
> * 原文作者：[Sean Knight](https://medium.com/@sean_24930)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-options-for-using-mongodb-with-business-intelligence.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-options-for-using-mongodb-with-business-intelligence.md)
> * 译者：
> * 校对者：

# 4 Options for Using MongoDB with Business Intelligence - How to do SQL-style analytics on NoSQL data

![Photo by [Major Tom Agency](https://unsplash.com/@majortomagency?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/2134/0*tm1VLFJIPTSFjBcw)

## Can MongoDB be used with business intelligence?

MongoDB is making a name for itself as one of the top NoSQL providers on the market, which has sparked an interesting debate: [MongoDB vs SQL](https://www.knowi.com/blog/mongodb-vs-sql/)**.**

The main question that comes up when this debate does is whether or not MongoDB can be used for business intelligence in the same manner as a conventional SQL database.

While the answer to this question is yes, it comes with the caveat that it can come at a cost— in terms of both money and time — to get true business intelligence features while Mongo data.

In this article, I will briefly describe the advantages of using traditional relational databases such as SQL for business intelligence and compare them to the advantages of using NoSQL databases such as MongoDB for business intelligence. I will also cover the options that are available to get SQL-like BI features while still using MongoDB as the database.

## Advantages of SQL Databases

By nature, traditional relational databases are **structured**. Their data consists of normalized tables that are related to one another through keys or ID fields. The structured nature of relational databases makes it easy to use SQL to query them. One of SQL’s biggest strengths is that it is a structured query language with nearly identical syntax across most databases: this means that anybody who knows how to write a query in MySQL can write a query in Oracle and most other databases as well.

So, what advantages do relational databases have?

* **They are structured** — this suits them perfectly for applications such as financial data, which ought to be clean, consistent, and normalized. But it can also be limiting. More on that later.
* **Efficient memory usage** — the highly normalized nature of relational data generally ensures that storage isn’t wasted on duplicate data.
* **They make data retrieval easy** — SQL is a flexible and extensive interface that is used by most suppliers, which makes it easy to use SQL to query data, transform data, and join data from other relational tables.

## Advantages of MongoDB

By contrast to SQL databases, NoSQL databases don’t follow a relational database structure. Specifically, document-based NoSQL databases such as MongoDB are made up of a series of documents that contain JSON data. This JSON data often contains deep nested data structures, and these deep nested data structures aren’t always consistent across different objects. Millions of developers use MongoDB, making it one of the most popular NoSQL databases.

When these developers use MongoDB, what advantages do they enjoy?

* **Flexible schemas** — because MongoDB stores data in JSON objects, individual units are capable of holding extensive nested fields. Different object instances may also capture different fields.
* **Speed** — Indexing on JSON data generally provides the user with data more rapidly than indexing of typical relational databases.
* **Scalability** — MongoDB divides the data into shards, which means it can handle big data efficiently.

## Business Intelligence: SQL Databases vs. MongoDB

When it comes to business intelligence, how do these two types of databases compare? Generally speaking, the territory of [business intelligence belongs to SQL](https://www.knowi.com/mysql). SQL’s flexibility allows analysts to easily pull, filter, join, aggregate, and perform other functions on relational data. This makes it easy to visualize and report on relational data.

By contrast, business intelligence in NoSQL databases is not as well developed, which makes sense since NoSQL databases are still fairly nascent. NoSQL databases are capable of being used for business intelligence, but the unstructured nature of NoSQL databases means that generating queries generally isn’t as clean as it is in SQL. To give a few examples, the query language isn’t consistent across NoSQL databases like it is across SQL databases, and NoSQL databases generally haven’t supported joining across tables.

## How Can You Use MongoDB for Business Intelligence?

It’s easy to see why SQL databases are often a favorite for business intelligence. But the distinct advantages of NoSQL databases can become essential under certain use-cases. One area where NoSQL databases like Mongo are gaining traction is in the field of [IoT analytics](https://www.knowi.com/solution/iot-analytics/) for connected devices. This is a domain where there is a lot of data and it varies greatly in structure. In cases like this, you still need to be able to perform business intelligence functions on your Mongo data. So what do you do then?

#### Solution One: ETL

You could always copy your MongoDB data into a SQL database, and then conduct your business intelligence process using the relational data. Doing so would provide you with all of the benefits of using SQL for business intelligence, and might even allow you to perform real-time analytics if your company’s ETL procedure is efficient enough. Some solutions such as [AWS Glue](https://www.knowi.com/blog/aws-glue-etl/) do this very well. Other companies such as Avik Cloud help companies build data pipelines, which adds layers of transformation to the ETL process.

The issue with taking this approach is that it requires additional resources in the form of additional hardware, as well as additional man-hours in the configuration of the ETL process and maintenance of the new environment. Suddenly, the business intelligence process requires support from several different members across several different teams. Copying data from MongoDB into a SQL database also gives up all the advantages of having a schemaless data structure, since you have to force that data into a schema structure to get it into the SQL database.

#### Solution Two: Data Virtualization

One of the more recent options available to solve this that is being pioneered by companies like [Knowi](https://www.knowi.com) is **Data Virtualization**.

Data virtualization simulates a single unified dataset by using a logical data layer (the virtualization layer) that natively connects to all datasets being used. This allows SQL and NoSQL data that is siloed in different locations and databases to appear as a single unified dataset and be accessed in real-time.

![A diagram of how data virtualization was used to build the Knowi platform. The Data Services Layer is the data virtualization layer (source: [Knowi](https://www.knowi.com/why-knowi))](https://cdn-images-1.medium.com/max/3852/1*RtDIXrYGtUehJW_aT6GLWQ.png)

Knowi uses data virtualization to connect to MongoDB directly and provides users with an interface that allows them to manipulate data by generating queries.

Users can build queries using native MongoDB queries, point-and-click software, or a mixture of the two. After building their queries, users have the option to take things a step further and manipulate the data with [Cloud9QL](https://www.knowi.com/docs/cloud9QL.html), Knowi’s SQL-based language. This process is all done on the live MongoDB instance in real-time, which eliminates the need for any ETL process to store the data in a SQL database.

![Knowi’s native connection to SQL and NoSQL datasources provides a lot of flexibility](https://cdn-images-1.medium.com/max/2560/0*AJt8XmCOk3hG6fu8)

To put it simply, a user can employ data virtualization with a solution like Knowi to filter, join, and aggregate real-time data from MongoDB in the same way that they would in a SQL database, without ever using a SQL database. An added advantage here is that they can also just as easily pull in data from other sources like [Elasticsearch](https://www.knowi.com/elasticsearch-analytics), [REST APIs](https://www.knowi.com/rest-api), [MySQL](https://www.knowi.com/mysql), as well as premium database solutions like [Couchbase](https://www.knowi.com/couchbase) and [Datastax](https://www.knowi.com/datastax-enterprise-analytics).

#### Solution Three: Translation

There are companies out there that are trying to build a transitional system that allows the user to enter SQL queries and then “translate” these queries into MongoDB queries in order to solve this problem. [Dremio](https://www.dremio.com/) is one of them, and they do a great job of removing the need for ETL.

Unfortunately, things like joins across separate databases can cause major problems with this process. This process also includes a delay, which is far from ideal for rigorous, large-scale business intelligence procedures.

#### Solution Four: MongoDB Charts (limited-use cases only)

In an effort to remove some technical barriers to data visualization and business intelligence with Mongo data, the team at MongoDB recently released MongoDB Charts. MongoDB Charts is a native visualization tool that helps remove many of the barriers to using MongoDB for data visualization and business intelligence, but it comes with some drawbacks.

* The user must have a MongoDB Atlas account.
* The user is limited to only MongoDB data.
* You must have a MongoDB Atlas account.
* Every chart only displays data from a single data source.
* As of right now, the extent of business intelligence and visualizations is limited to simple charts and dashboards. However, they do frequently work on new features.

If your use-case won’t be impacted by these limitations, MongoDB Charts may be a good solution for you. It may be an even better solution if you’re already subscribed to MongoDB Atlas.

If these limitations aren’t relevant to your use-case, MongoDB Charts may be a good solution option — especially if you’re already a MongoDB Atlas subscriber.

## Conclusion

The modern environment of business intelligence is dynamic, which means we must constantly conduct analysis on a wide variety of different database types, and some of these database types are more conducive to business intelligence than others. MongoDB is not the only database to create some confusion within the sphere of business intelligence. Fortunately, solutions to this problem are being presented by a few innovative companies out there that are working to standardize and streamline the process of business intelligence across various data sources. Regardless of which solution you decide is best for your business, one thing is clear: your business no longer has to decide between MongoDB and business intelligence. You can have both.

## About the Author

Sean Knight works as VP of Growth [Knowi](https://www.knowi.com/), a SAAS analytics company. He has degrees in both physics and data science and has worked at particle accelerators, NASA JPL, a research nuclear reactor, and is now in the startup world. He is a data geek who enjoys contributing to Towards Data Science, Level Up Coding, The Startup, and Hackernoon.
Find him on [Twitter](https://twitter.com/SeanLikesData) and [Linkedin](https://www.linkedin.com/in/seanlikesdata/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
