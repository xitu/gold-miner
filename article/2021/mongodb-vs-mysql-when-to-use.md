> * 原文地址：[MongoDB Vs. MySQL: When to Use?](https://dzone.com/articles/mongodb-vs-mysql-when-to-use)
> * 原文作者：[Mariana Berga](https://dzone.com/users/4502628/mobrdev.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/mongodb-vs-mysql-when-to-use.md](https://github.com/xitu/gold-miner/blob/master/article/2021/mongodb-vs-mysql-when-to-use.md)
> * 译者：
> * 校对者：

# MongoDB Vs. MySQL: When to Use?

MongoDB and MySQL are both incredible databases with outstanding performance. However, their success is determined by the field in which they are playing. Rather than merely comparing the pros and cons, it is first essential to comprehend the different contexts in which they operate. Therefore, in this blog post, we will explore the key characteristics, differences, and benefits of using MongoDB and MySQL.

Keep reading to find out more about these (very different) databases and how to choose between both.

## What is MySQL?

MySQL is an open-source RDBMS, which stands for a Relational Database Management System. More specifically, an RDBMS is a useful and beneficial program to update, manage and formulate **relational databases**. A relational database is a type of database (usually arranged into tables) that allows for recognizing data in relation to another piece of data within the same database. MySQL, PostgreSQL, and SQL are RDBMSs that utilize their own variation of **SQL** (Structured Query Language).

One of the most popular open-source RDBMSs is MySQL once it has been on the market since 1995, thus, having years of high-valued reputation and reliability. Moreover, it is fairly easy to use. Since the database schema is pre-defined according to specific conditions and rules, the data will be organized in rows and columns demonstrating the relationships between the various tables' fields.

## What is MongoDB?

MongoDB is also open-source, however, and unlike MySQL, it is a document datastore. It stores documents within collections instead of tables with relations among them.

When using MongoDB, the data schema is not fixed. It is possible to remove or modify document properties within a collection, which allows for superior flexibility. In fact, documents can even be in the same collection and yet have completely different structures among themselves.

## MongoDB Vs. MySQL: The Differences

As the previous paragraphs already enlightened, the main difference when comparing both open-source databases is that while MySQL is relational, MongoDB is a document datastore. Throughout this chapter, we will examine what that implies regarding data schema and capacity; performance and speed; security; and query language.

## Data Schema and Capacity

In MongoDB, data is displayed in key-value pairs like JSON documents, allowing the database to have fewer constraints considering the schema design. This can be particularly advantageous for data with the potential for fast growth or other changes. Plus, MongoDB does provide a pre-defined structure that can be adopted if preferred.

![Source: MongoDB](https://www.imaginarycloud.com/blog/content/images/2021/02/MongoDBJSON.png)

Regarding **data schema**, the same does not happen in MySQL. Even though it is possible to change the schema, modifications are not as flexible and dynamic as in document databases. Before storing any data, MySQL mandatorily requires a pre-establishment of how the tables and columns will be organized. Altering the data schema requires carefully rethinking the database's DDL (Data Definition Language) and DML (Data Modeling Language).

Both databases, relational and document, use DDL and DML concepts. However, in relational databases, establishing the **DDL** and **DML** is vital. Contrarily, MongoDB has a more malleable data schema, thus, not being as concerned as MySQL about how data is structured. Even though it may seem like a big con, this consistency is actually one of MySQL's greatest strengths because it keeps the data structured and clean.

![Source: [dev.mysql](https://dev.mysql.com/)](https://www.imaginarycloud.com/blog/content/images/2021/02/dataschemasample_MySQL.png)

Each MongoDB database contains collections, which in turn, are filled with documents. These documents can include various fields and types of information, allowing for data storage of documents that vary in content and size. In MySQL, since the data schema is more constrained, every row within a table requires the same columns, which can be particularly hard to manage when working with high-volume databases. Hence, MySQL does not handle large and complex databases as easily as MongoDB.

In other words, MongoDB document database is superior to MySQL relational database when dealing with diverse and large quantities of complex data.

## Performance and Speed

MongoDB can accept more extensive amounts of structured or unstructured data faster than MySQL. However, suppose a business is working with fairly small and less diverse amounts of data: speed is not necessarily something to be concerned for since other features (like reliability and data consistency) might be prioritized over speed.

More important than comparing each database speed is understanding which one is more suitable and results in better performance according to the businesses' or projects' data requirements.

MySQL is a mature and reasoned solution to ensure **data privacy** and **integrity**. Due to its explicit schema, MySQL creates reliable database structures by using tables that systematize data types, making the respective values queried adequately and easy to search. Yet, it is definitely not a suitable option for unstructured data. The most significant advantage (and disadvantage) when using MySQL is that it requires a structure of the data beforehand. This results in less technical debt. Nonetheless, in some cases, it might be hard to design a suitable schema for complex data.

On the other hand, MongoDB has a more flexible and **faster performance** for unstructured data. Document datastores are good when the data schema is hard to design beforehand. However, if the data is diverse, then creating indexes on the data's attributes becomes challenging. Therefore, it requires frequent optimization of the data schema. Otherwise, it might be risking problems related to data consistency.

## Security

MySQL utilizes a privilege-based **security model**, which requires user authentication and can also provide or deny user privileges on a particular database. Plus, to transfer data from the database to the server MySQL necessarily employs encrypted connections between clients and the server, using the Secure Sockets Layer (SSL) - a security protocol.

MongoDB's security consist of **role-based access control** that includes authentication, authorization, and auditing. Additionally, if desired for encryption, it is also possible to apply Transport Layer Security (TLS) and SSL.

Even though both MongoDB and MySQL provide safe security models if reliability and data consistency are a business' priority, then MySQL is the most fitting choice.

## ACID: Atomicity, Consistency, Isolation, and Durability

In computer science, ACID refers to a set of database transactions' properties that ensure **data validity**. It stands for atomicity, consistency, isolation, and durability.

While MySQL is considered ACID, being ACID compliant for MongoDB is not a priority, since it would require sacrificing speed and high availability. In 2018, MongoDB made it possible to sustain ACID multi-document transactions. However, by default, this option is off. On the other hand, MySQL's transactions are ACID, which ensures data validity considering transaction properties.

## Query

MySQL uses **structured query language (SQL)** when requesting information from a database table or combination of tables. SQL is the most popular and utilized query language requiring only a data definition language (DDL) and a data manipulation language (DML) to communicate with the database.

On the other hand, MongoDB uses an **unstructured query language**. To request data or information from the JSON documents database, it is first essential to specify the documents with the properties that the results should match.

In other words, to fetch data from a MongoDB database, query operations need to be performed. To do so, the following function should be applied: `db.collection.find()`. MongoDB supports multiple languages (such as [Python](https://www.imaginarycloud.com/blog/why-use-python-for-web-development/), Java, C##, Perl, PHP, [Ruby](https://www.imaginarycloud.com/blog/ruby-vs-python-for-web-development/), and [JavaScript](https://www.imaginarycloud.com/blog/async-javascript-patterns-guide/)) in which queries can be built. A compound query can establish specific conditions for various fields within the collection's documents using query operators. Query operations (e.g. `$and`, `$or`, `$type`, `$eq`, etc.) specify the conditions and enable query filter documents. Once the conditions are defined, it identifies which information or record to select accordingly, and, further, it allows to update, read or delete.

![Source: [MongoDB](https://docs.mongodb.com/guides/)](https://www.imaginarycloud.com/blog/content/images/2021/02/MongoQuery.png)

Nevertheless, MongoDB does not perform JOIN operations nor has an equivalent. When using MySQL, **JOIN operations** (inner, outer, left, right, and cross) are applied to retrieve data from two or more database tables. Simply put, these operations are what allow relational data to relate by using a single SQL statement.

## MongoDB Vs. MySQL: When to Use?

It is hard to say which database is better when it all depends on the context they are being explored. Truth be told, both MySQL and MongoDB are beneficial and useful management systems that operate entirely differently. Therefore, even if one of the databases is the most suitable option for a specific business or project, it may not be the best solution for a different purpose. Some companies rely on both systems according to distinct tasks.

One of the very few things they do have in common is that they are **open source and easy to access**. Moreover, both systems provide commercial versions with additional features. Apart from these similarities, at the core of their performance is their relational and non-relational nature.

MongoDB, a document database, is the most suitable solution for **high-volume environments**, considering it does not limit the amount and types of data one wishes to store. It is particularly beneficial for cloud-based services since MongoDB's horizontal scalability aligns perfectly with cloud's agility. Plus, it reduces workload, eases scaling within a business or project, and provides **high availability** and fast data recoveries.

Despite the many advantages this system might have, MySQL surpasses MongoDB in some aspects, such as **reliability** and data **consistency**. Moreover, if security is also a priority, then MySQL is actually one of the most secure DBMS.

Further, when the type of application demands multi-row transactions (for instance, in accounting and banking systems), relational databases are the most appropriate option. In addition to providing safety, MySQL also enables a **high transaction rate**. In fact, while MongoDB focuses on allowing a high insert rate, contrarily, MySQL supports ACID transactions and concentrates on delivering transaction safety.

Overall, MySQL is highly recommended for businesses or projects that have a fixed data schema and do not intend to scale much in data diversity, thus requiring easy and low maintenance while ensuring data integrity and reliability.

On the other hand, MongoDB is the most suitable choice for businesses or projects that are growing but have an **unstable data schema**. This system's non-relational data nature allows documents to be freely used and stored without a structure, making it easy to update and retrieve. MongoDB is often used in projects that require content management, handle IoT (Internet-of-Things), perform real-time analytics, and so on.

## Conclusion

MySQL is an open-source relational database, meaning that its data is organized into tables that allow you to relate a piece of data with other parts of it. MongoDB is also open-source, but instead, it is a document database. Hence, it does not associate records, and its data schema is unfixed, allowing for a more dynamic and flexible database with a higher capacity to insert information.

Before deciding upon the best database system, the specific **business or project's priorities** should be clear and well-established. As mentioned, MongoDB handles large amounts of data better than MySQL. Thus, being the fittest option for cloud-based services, for applications prone to grow and change, and for environments characterized by high data volume.

Contrarily, MySQL's fixed and structured data schema provides greater consistency and reliability than most databases. Another great benefit of using MySQL is its superior data security due to ACID-compliant transactions, being the most suitable choice for applications that value this feature.

In short, both databases will deliver a very satisfying performance if applied to a context that matches both the applications' needs and desires with the system's characteristics and features.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
