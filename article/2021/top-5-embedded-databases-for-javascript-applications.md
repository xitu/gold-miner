> * 原文地址：[Top 5 Embedded Databases for JavaScript Applications](https://blog.bitsrc.io/top-5-embedded-databases-for-javascript-applications-1c68496aebac)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-5-embedded-databases-for-javascript-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-5-embedded-databases-for-javascript-applications.md)
> * 译者：
> * 校对者：

# Top 5 Embedded Databases for JavaScript Applications

![Image by [Pexels](https://pixabay.com/users/pexels-2286921/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1836594) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1836594)](https://cdn-images-1.medium.com/max/3840/1*pbWGFLeMU5gfUc7jSLvoPA.jpeg)

We’re used to thinking about databases as huge storage platforms where we can throw all the data we need, and then retrieve it by some form of a query language. Scaling these databases, keeping the information consistent and fault-tolerant is a challenge on its own. However, what happens when our data needs are very small?

What happens when RedShift, BigQuery, and even MySQL are too big of a solution to our tiny-bitty data requirements? Well, as it turns out, there is an app for that. In fact, there are plenty of options, so here I’m going to be covering the top 5 embedded databases for your tiny data needs.

## What is an embedded database though?

When we read the word “embedded” 90% of us jumps to the conclusion that I’m talking about IoT or mobile devices. But this is not the case.

Not the only case anyway. Granted, those systems have very limited resources which makes most traditional database systems hard to configure and install there.

But there are other use cases for small databases and that is embedding them as part of a software product. For example, imagine a search done on a big code repository through your IDE. The IDE could have embedded a reverse-index database that would allow you to search for keywords and get a quick reference to the relevant files. Or maybe when performing a search on your favorite email desktop client, that one most likely has an embedded database as well. All emails are stored and indexed there so you can access that information quickly and easily.

Another big benefit from embedded databases that you might’ve picked up on by now, is that they don’t require network calls to interact with. That is a huge performance boost compared to the standard database variety. Essentially while on a normal development you’d want to have your database on its own server (or cluster of servers) so its resource consumption won´t affect the rest of the components of your architecture, for embedded databases you want them as close to the client code as possible. This reduces the latency between them and avoids the dependency on the communication channel (i.e the network).

Now this idea can take many shapes, from a quick in-memory database using a JSON file as main storage, to a highly efficient tiny relational database that can be queried using a SQL-like language.

Let’s take a look at 5 alternatives.

## LowDB

Let’s start simple, [LowDB](https://github.com/typicode/lowdb) is a tiny in-memory database. It’s a very basic solution but that solves a very simple use case: needing to store and access JSON-like structures (i.e documents) from JavaScript-based projects.

One of the main benefits of LowDB is that it’s meant to be used from JavaScript, which translates to: it can be used for back-end, desktop, and browser code alike.

On the back-end you can use it with Node.js, for desktop development it can be integrated into an Electron project, and finally, it can also be run directly on the browser through its integrated JS runtime.

The API provided by this database is also quite simplistic and minimal, it doesn’t provide any search functionality out-of-the-box. It’s limiting itself to loading the data of a JSON file into an array variable and letting you (the user) find what you’re looking for however you see fit.

For instance, take a look at the following code:

```JavaScript
import { LowSync, JSONFileSync } from 'lowdb'

const title = "This is a test"
const adapter = new JSONFileSync('file.json')
const db = new LowSync(adapter)

db.read()  //Load the content of the file into memory
db.data ||= { posts: [] } //default value

db.data.posts.push({ title }) //add data into the "collection"

db.write() //persist the data by saving it to the JSON file

//any Find-like operation is left to the skill of the user

let record = db.data.posts.find( p => p.title == "Hello world")

if(!record) {
  console.log("No data found!")
} else {
  console.log("== Record found ==")
  console.log(record)
}
```

As you can see, the interesting part here is not the default behavior but the fact that I’m using an adapter called `JSONFileSync` . I could be using a custom one created by me just as easily, which is the real strong point of this database.

It’s highly extensible and compatible with TypeScript, which provides a schema-like behavior for the data storage (i.e you’re not allowed to add data that doesn’t follow a pre-set schema).

If you mix those two options, LowDB starts showing some promise as an interesting option to handle local JSON-like data.

## LevelDB

[LevelDB](https://github.com/google/leveldb) is an open-source key-value database built by Google. It is meant to be a super-fast yet very limited key-value storage where data is stored sorted by key out-of-the-box.

It only has three basic operations: Put, Get and Delete, nothing else — kind of like LowDB if you think about it.

And much like LowDB it does not have a client-server wrapper, which means there is no way to communicate with it from any language, if you want to use it, you’ll have to use the C/C++ libraries and if you want a server-like behavior, you’ll have to wrap it yourself.

Much like in most of the cases we’ll cover here, the functionality is very basic since they cover a very simple yet needed use case: storing data close to the code and accessing it fast.

The database’s storage architecture is around a Log-structured Merge Tree (LSM) which means it is optimized for large sequential write operations instead of small random ones.

One major limitation from LevelDB is that it acquires a system-level lock on the storage once opened which means only one process can interact with the database at the time. Of course, you can use multiple threads to parallelize some operations from within that process. But that is the extent of it.

Interestingly enough, this database is used as the backend DB for [Chrome’s IndexedDB ](https://blog.openreplay.com/getting-started-with-indexeddb-for-big-data-storage)and apparently Minecraft Bedrock edition uses it for some chunk and entity data storage (although [by the looks of it](https://minecraft.fandom.com/wiki/Bedrock_Edition_level_format), they use a slightly modified version of Google’s implementation).

## Raima Database Manager

I mentioned IoT before didn’t I? Well [Raima ](https://raima.com/)is one of the fastest database managers especially optimized to run in resource-restricted IoT devices.

What do I mean by resource-constrained environments? Raima only requires 350kb of RAM to operate. That’s what I can minimalistic resource utilization.

One of the main characteristics of this solution which hasn’t appear on any of the previous ones, is that it fully supports SQL. It provides a relational data model and allows you to query using the SQL language.

It also, unlike LevelDB, allows for multi-process access to the database through a client-server architecture (i.e this one allows you to move away from the source code a bit further than others). And if you decide to go for a close-to-source embedded application, you can also use multithreading to support concurrent access to multiple databases.

The flexibility of Raima allows you to go from a traditional client-server approach to the most efficient (and of course limited) use case of a single in-memory database consumed by a single client. But hey, this is a very valid use case for embedded databases.

![Images taken from [Raima’s website](https://raima.com/architecture/)](https://cdn-images-1.medium.com/max/3166/1*Wri490chKY--YYgiIkLUsA.png)

This flexibility makes it a very versatile solution. Of course, each deployment mode will have its own benefits and limitations, but it’ll also be optimized for very specific use cases. So make sure you pick the right one for you and get the most out of this database.

## Apache Derby

If you’re looking for another very small, SQL-like database, [Apache Derby](http://db.apache.org/derby/) might very well be what you were looking for.

Derby is completely written in JAVA which also loses a bit of credit when it claims to only have a 3.5Mb footprint. After all, you can’t run it or use it in any way without also having installed the JVM on the host system.

That being said, if your use case allows for the JVM, then fantastic, you can keep considering Derby, otherwise you might want to go for a more native solution like LevelDb or Raima.

But as I said, if you’re working on a JAVA project already and have the need to integrate a small, reliable, SQL-based database then Derby is definitely a potential candidate.

It comes with an integrated JDBC driver, so there is no need for extra dependencies. It can work both, on an embedded mode inside your JAVA application or as a standalone server, allowing for multiple applications to interact with it concurrently (similar to how Raima does, but without the many variants).

The biggest downside to this project to be honest, is its documentation. It might be a standard for the JAVA community but it’s not user-friendly and most of the official links sent readers to a private confluence page. Many other solutions here provide a smoother experience when it comes to documentation which also helps with the adoption of their products.

## solidDB

Last but certainly not least solidDB covers a very interesting case by providing an in-memory relational database that can also boost a persistent model at the same time. Claiming it can keep both data storage options synchronized in real-time. That’s no small claim.

Essentially just like other solutions listed here, solidDB can be accessed either through ODBC or JDBC, which allows for JAVA and C applications to interact with it, through SQL.

Also like some of the solutions listed here, it can be deployed in several modes:

* **Highly available mode**. Which involves having multiple servers with duplicated data. Of course, this mode doesn’t fall very much into the use cases we were considering.
* **Shared Memory Access**. This one is very interesting because it not only keeps the data in memory (like other solutions already listed) but it also allows multiple applications to access this memory (hence the **shared memory** part). Of course, direct access to this shared memory needs to be done by applications within the same node, however, it also allows for JDBC/ODBC-based access to the same data from outside nodes. Turning the Shared Memory into an in-memory database that has external access.

Multiple big names, such as Cisco, Alcatel, Nokia, and Siemens claim to be using this database for their mission-critical operations due to the lightning-fast speed at which data is accessed.

Given all its deployment modes, its extensive documentation, and list of high-demand customers I can see how this is one of the most reliable, stable, and fast embedded databases on this list.

---

Embedded databases are meant to handle a very specific use case either by providing fast and reliable data storage with minimum latency or by allowing fast and secure access to data. The solutions listed here achieve those goals by different means, it’s up to you and your particular context to decide which one is the right fit for you.

Have you tried any of these solutions in the past? Have you had the need for an embedded database on one of your projects? What did you decide to go with?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
