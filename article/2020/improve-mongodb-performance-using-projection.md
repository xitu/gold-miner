> * 原文地址：[Improve MongoDB Performance Using Projection](https://medium.com/better-programming/improve-mongodb-performance-using-projection-c08c38334269)
> * 原文作者：[Tek Loon](https://medium.com/@tcguy)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improve-mongodb-performance-using-projection.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improve-mongodb-performance-using-projection.md)
> * 译者：
> * 校对者：

# Improve MongoDB Performance Using Projection

![Photo by [Greg Rosenke](https://unsplash.com/@greg_rosenke?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10744/0*xNUvb3ABjaziY-2J)

This article documents all my findings and analysis on how much performance was improved using projection in MongoDB. At the end of this article, we will be able to know whether MongoDB query performance will be improved by leveraging projection.

Without further ado, let’s start.

## Problem Statement

This article was inspired during my working hour where I used [projection](https://docs.mongodb.com/manual/reference/glossary/#term-projection) when I retrieved the data from MongoDB. Projection is **“a document given to a query that specifies which fields MongoDB returns in the result set.”** according to MongoDB’s Official [Documentation](https://docs.mongodb.com/manual/reference/glossary/#term-projection).

It’s like ordering a Big Mac at McDonald’s, and we can choose a la carte instead of a full set that comes with drink and fries.

Thus, I was wondering — how much does the query performance improve if projection was used. Here are the primary objectives that I wanted to achieve in this research:

#### Primary objectives

* Discover whether performance will be improved if projection was used in MongoDB query.
* Discover the best scenario to use projection in MongoDB query.

## Solution Analysis

I always started with finding out what I need in order to continue the research. These items are what I needed:

* A collection with more than 500K documents so that I can find out the difference in query time with and without projection.
* Sub-document schema. This is because I suspect the document with sub-documents will increase a significant amount of query time. Let’s prepare this for the experiment as well.

Refer to the screenshot below for the outcome of data preparation. Check out this [article](https://medium.com/@tcguy/mongodb-performance-101-how-to-generate-millions-of-data-for-performance-optimization-cf45d3556693) on how I generate millions of dummy data for performance optimization.

![](https://cdn-images-1.medium.com/max/2128/1*iYK8wFD1zZg_ItA_GFPSUg.png)

From this screenshot, we knew that we have generated 500K documents with the following fields:

* `booking_no` - Booking Number for Flight
* `origin` - Departure City
* `destination` - Arrival City
* `persons` - An array of people which consists of `first_name`, `last_name` and `dob` field

## Performance Experiment

Before we started any experiment, let’s ensure the setup is correct. There are no indexes created the collection yet, except the default `_id` field.

The experiments I would like to perform here are:

* Experiment 1: Will query performance increase if I project lesser fields?
* Experiment 2: If experiment 1 result is no, what other scenarios will find out how projection will improve query performance?

## Experiment 1: Will Query Performance Increase If I Project Lesser Fields?

Unfortunately, the answer is **no**. However, the performance will improve if those returning fields are all indexed, and we will talk about this in the next section.

In this experiment, we’re going to retrieve all the flight bookings in which the destination is “Gerlachmouth”. Out of 500K bookings, there are 93 bookings where the destination is “Gerlachmouth”. Let’s examine how long it took to return these 93 documents.

I perform the performance analysis using the Mongo Shell Explain function, which enables us to discover the time spent on query and query strategy that was used.

![](https://cdn-images-1.medium.com/max/2000/1*ZILEtJVXHlvsVaKlImVusA.png)

The above screenshot shows the result when retrieving without projection. The query took 461ms to complete. While the screenshot below shows the result where we leverage projection, the query took 505ms to complete.

Thus, the performance did not improve — instead, it took a much longer time to process the query when we use projection.

![](https://cdn-images-1.medium.com/max/2000/1*1jXiJv35xCeu0cYVUtsuZQ.png)

The conclusion for Experiment 1 — Performance did not improve when you implement projection in the query. 👎👎

## Experiment 2: If the Experiment 1 Result is No, Find Other Scenarios on How Projection Improves Query Performance

Since my first hypothesis was wrong, then I tried to do some research and re-visit the performance [course](https://university.mongodb.com/courses/M201/about) offered by MongoDB University. The course is free — check it out if you are interested in learning MongoDB performance.

And I discovered Covered Query. Covered Query is a **“query that can be satisfied entirely using an index and does not have to examine any documents”,** according to MongoDB’s official [documentation](https://docs.mongodb.com/manual/core/query-optimization/#covered-query).

We can use the cooking metaphor to understand Covered Query. Imagine that you’re cooking a meal with all the ingredients are ready and inside your fridge. Basically, everything is covered, and you just have to cook it.

Before we create any indexes for the database, let’s start by asking: What is the field that we want to return to the application? Let’s give the following scenario:

* Admin would like to know all the flight bookings to a specific destination. The information that Admin would like to know is their respective `booking_no`, `origin` and `destination`.

Given the scenario above, let’s start by creating indexes. We can create two indexes.

* Destination — Create an index on the destination field only.
* Destination, Origin, and Booking No. — We can create a compound index with the sequence `destination`, `origin` and `booking_no` field.

Refer to the command below on how to create the index.

#### Query without projection

First, let’s start to query the booking where the destination is “Gerlachmouth”. The screenshot below shows the execution time for the query. As you can see, the total execution time reduced to **5ms**. It was almost **100 times faster** compared to one without indexes.

You might be satisfied with this performance, but this is not the end of the optimization. We can improve the query performance, and make it **250 times faster** using **Covered Query** compared to without indexes.

![](https://cdn-images-1.medium.com/max/2000/1*_07K8c-uv2n9X9cahQnEGQ.png)

## Query with Projection (Covered Query)

Using the covered query means we’re querying fields that are is indexed.

Using the above command, we able to optimize the query to **2ms**, which is around **60% faster** without using projection on the indexed field.

Aside from improving execution time, we also improve the query strategy. From the screenshot, we can see that we did not examine any documents, meaning the index itself already enough to satisfy the query. Thus, this improves the query performance overall, as we don’t have to fetch the documents.

![](https://cdn-images-1.medium.com/max/2000/1*R24vSTP-N7x_kfh2ucWr-g.png)

## Conclusion

Here are the key points of this article.

* Project lesser fields will not improve query performance unless all the returned fields can be satisfy using an index.
* An index can improve performance, but covered queries can level up your query performance.
* Covered Query performed 60% faster than Normal Optimized Query using Index Scan.

Thank you for reading. See you in the next article.

## References

* Projects Field From Query — MongoDB [Documentation](https://docs.mongodb.com/manual/tutorial/project-fields-from-query-results/)
* A Thorough Explanation from [StackOverflow](https://dba.stackexchange.com/questions/198444/how-mongodb-projection-affects-performance)
* Explain Output — MongoDB [Documentation](https://docs.mongodb.com/manual/reference/explain-results/#executionstats)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
