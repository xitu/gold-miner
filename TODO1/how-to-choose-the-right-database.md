> * 原文地址：[How to choose the right database](https://towardsdatascience.com/how-to-choose-the-right-database-afcf95541741)
> * 原文作者：[Tzoof Avny Brosh](https://medium.com/@tzoof)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-right-database.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-right-database.md)
> * 译者：
> * 校对者：

# How to choose the right database

#### We will go over the types of databases available and the best practices for different project types.

Whether you are an experienced software engineer or a student doing a university project, at some point you will need to choose a DB for your project.

If you’ve used DBs before you might be saying “I’ll just choose X, it’s the DB I know and worked with” and that’s completely fine if performance is not an important requirement for your system. Otherwise, choosing the wrong DB might come as an obstacle when the project grows and is sometimes painful to fix. Even if you are working on a mature project, that uses specific DB for a while, it’s important to know its limitations and identify when you should add another type of DB to your stack (it is very common to combine several DBs).

A bonus reason for understanding the different DBs and their properties is that it’s quite a common question in job interviews!

In this post we will review the 2 main types of databases:

* Relational Databases (SQL based).
* NoSQL Databases.

We will go over the different types of NoSQL DBs and when to use each one.  
And finally, discuss the advantages and disadvantages of Relational vs. NoSQL DBs.  
This post will not include a comparison between the different products offered for each type of database (e.g. MySQL vs. MS SQL Server).

TL;DR: if you are looking for a quick cheat sheet, skip to the end of the post.

---

![](https://cdn-images-1.medium.com/max/2000/1*boWbSGHBRs2Bc13aeHVDfw.png)

## Relational DBs (SQL based)

This DB consists of a collection of tables (like CSV tables), that are connected. Each row in a table represents a record.

Why is it called relational? What are the ‘relations’ that exist in this DB?
Let ’s say you have a table of students information, and a table of the course grades (course, grade, student id), every grade row **relates** to a student record.
See diagram below, where the value in the ‘Student ID’ column points to rows in the ‘Students’ table by the value of their ‘ID’ column.

All relational DBs are queried with SQL-like languages, which are commonly used and inherently support join operations.
They allow the indexing of columns for faster queries based on those columns.

Because of its structured nature, the relational DB’s schema is decided before inserting data.

**Common relational databases:** MySQL, PostgreSQL, Oracle, MS SQL Server

---

![](https://cdn-images-1.medium.com/max/2000/1*xtPrVMwIcya4ObgwTeg9GA.jpeg)

## NoSQL DBs

While in relational DBs everything is structured to rows and columns, in NoSQL DBs there is no common structured schema for all records. Most of the NoSQL databases contain JSON records, and different records can include different fields.

---

This family of databases should actually be called “Not mainly SQL” — since many NoSQL DBs support querying using SQL, but using it is not the best practice for them.

#### There are 4 main types of NoSQL databases:

## 1. Document-oriented DBs

The atomic unit of this DB is a document.
Each document is a JSON, the schema can vary between different documents and contain different fields.
Document DBs allow indexing of some fields in the document to allow faster queries based on those fields (this forces all the documents to have the field).

**When should I use it?**  
Data analysis — Since different records are not dependent on one another (logic and structure-wise) **this DB supports parallel computations.**
This allows you to perform big data analytics on our data easily.

**Common document-based databases**: MongoDB, CouchDB, DocumentDB.

![](https://cdn-images-1.medium.com/max/2000/1*--zqXFzt3rNFLF4hvkgX7Q.jpeg)

## 2. Columnar DBs

The atomic unit of this DB is a column in the table, meaning the data is stored column by column. It makes column-based queries very efficient, and since the data on each column is quite homogeneous, this allows better compression of the data.

**When should I use it?**  
When you tend to query on a subset of columns in your data (doesn’t need to be the same subset each time!).
Columnar DB performs such queries very fast since it only needs to read these specific columns (while row-based DB would have to read the entire data).

* This is often common in data science, where each column represents a feature. As a data scientist, I often train my models with subsets of the features and tend to check relations between features and scores (correlation, variance, significance).
* This is also common with logs — we often store a lot more fields in our logs database but uses only a few in each query.

**Common column DB database:** Cassandra.

![Column vs. raw based DBs.](https://cdn-images-1.medium.com/max/2000/1*4qcFp6XOvQj3_uf4_Jx-VA.jpeg)

## 3. Key-value DBs

The querying is only key-based — You ask for a key and get its value.
Doesn’t support queries across different record values like ‘select all records where city == New York’
A useful feature in this DB is the TTL field (time to live), this field can be set differently for each record and state when it should be deleted from the DB.

**Advantages —** It is very fast.  
First because of the use of unique keys, and second because most of the key-values databases store the data in memory (RAM) which allows quick access.
**Disadvantages —** You need to define unique keys that are good identifiers and built of the data you know in the time of the query.
Often more expensive than other kinds of databases (since runs on memory).

**When should I use it?**  
Mainly used for cache since it is very fast and doesn’t require complex querying, also the TTL feature comes very useful for caching.
It can also be used for any other kind of data that requires fast querying and meets the key-value format.

**Common key-value databases:** Redis, Memcached

![](https://cdn-images-1.medium.com/max/2000/1*toVGNhjap7O02NgIAAo7PQ.jpeg)

## 4. Graph DBs

Graph DBs contain nodes that represent entities and edges that represent relationships between entities.

**When should I use it?**  
When your data is a graph like, like knowledge graphs and social networks.

**Common graph databases:** Neo4j, InfiniteGraph

---

![](https://cdn-images-1.medium.com/max/2000/1*aoxi7WigljAnHpqyTzzLEg.png)

## Relational vs. Document DB

As you probably figured out by now, there is no right answer, no ‘One DB to rule them all’.
The most common DBs for ‘regular’ use are Relational and Document DBs so we’ll compare them.

#### Relational — advantages

* It has a simple structure that matches most kinds of data you normally have in a program.
* It uses **SQL**, which is commonly used and inherently supports JOIN operations.
* Allows **fast data updating**. All the DB is saved on one machine, and relations between records are used as pointers, this means you can update a record once and all its related records will update immediately.
* Relational DB also **supports atomic transactions**.
What are atomic transactions: let’s say I want to transfer X dollars from Alice to Bob. I want to perform 3 actions: decrease Alice’s balance by X, increase Bob’s balance by X and document the transaction. I want to treat these actions as one atomic unit — all of the actions or none will occur.

#### Relational — disadvantages

* Since each query is done on a table — the **query execution** time depends on the size of the table. This is a significant limitation that requires us to keep our tables relatively small and perform optimizations on our DB in order to scale.
* In relational DBs scaling is done by adding more computing power to the machine that holds your DB, this method is called ‘**Vertical Scaling’**.
Why is it a disadvantage? since there is a limit for the computing power machines can provide and since adding resources to your machine can require some downtime.
* Relational **does not support OOP** based objects, even representing simple lists is very complicated.

#### Document DB — advantages

* It allows you to keep objects with **different structures**.
* You can represent almost all data structures including **OOP based objects**, lists, and dictionaries using good old JSON.
* Although NoSQL is unschematized by nature, it often supports **schema** **validation**, meaning you can make a collection schematized, the schema won’t be as simple as a table, it will be a JSON schema with specific fields.
* **Querying** NoSQL is very **fast**, each record is independent and therefore the query time is independent of the DB’s size and **supports parallelity**.
* In NoSQL, scaling the DB is done by adding more machines and distributing your data between them, this method is called **‘Horizontal Scaling’**. This allows us to automatically add resources to our DB when needed without causing any downtime.

#### Document DB — disadvantages

* **Updating** the data is a **slow** process in Document DB since the data can be divided between machines and can be duplicated.
* **Atomic transactions are not inherently supported**. you can add it yourself in code by using verification and revert mechanism, but since the records are divided between machines it cannot be an atomic process and race conditions can occur.

---

![](https://cdn-images-1.medium.com/max/7802/1*OeNlPHG6RC2C37ycYKxyQg.png)

## Cheat Sheet:

* For **cache** — use a **key-value DB**.
* For **graph-** like data — use a **graph DB**.
* If you tend to query on **subsets of columns** /features — use **column DB.**
* For all other use cases — **Relational** or **Document DB**.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
