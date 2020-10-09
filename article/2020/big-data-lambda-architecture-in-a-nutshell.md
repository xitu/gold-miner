> * 原文地址：[Big Data: Lambda Architecture in a nutshell](https://levelup.gitconnected.com/big-data-lambda-architecture-in-a-nutshell-fd5e04b12acc)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/big-data-lambda-architecture-in-a-nutshell.md](https://github.com/xitu/gold-miner/blob/master/article/2020/big-data-lambda-architecture-in-a-nutshell.md)
> * 译者：
> * 校对者：

# Big Data: Lambda Architecture in a nutshell

#### How do we beat the CAP theorem?

![the CAP theorem](https://cdn-images-1.medium.com/max/2730/1*ZyXE41bENSEUP29slqpQyQ.png)

There is one theorem in computer science called the CAP theorem states that it is impossible for a distributed data store to simultaneously provide more than two out of the following three guarantees.

* **Consistency**: every read receives the most recent write or an error.
* **Availability**: every request receives a (non-error) response, without the guarantee that it contains the most recent write.
* **Partition tolerance**: the system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes.

## A Brief of History

In 2011, Nathan Marz proposed an important approach to tackling the limitations of the CAP theorem in his blog¹, it called the Lambda architecture.

![the Lambda architecture](https://cdn-images-1.medium.com/max/2730/1*RX4WviL_wF7vVChcQUgyzg.png)

## How it works?

Let’s take a closer look at the Lambda architecture. There are three layers in the Lambda architecture: batch layer, speed layer, and serving layer.

> It combines real-time and batches processing of the same data.

**Firstly**, an incoming real-time data stream is stored in the master dataset at the batch layer as well as being kept in a memory cache at a speed layer. Data in the batch layer is **then** indexed and made available through batch views. While real-time data in the speed layer is exposed through real-time views. **Finally**, both batch and real-time views can be queried either independently or together to answer any historical or realtime questions.

#### Batch layer

This layer is responsible for managing the master data set. Data in the master dataset must hold three properties as follows.

* Data is raw
* Data is immutable
* Data is eternally true

The master dataset is the source of truth. Even if you were to lose all your serving layer datasets and speed layer datasets, you could re-construct your application from the master dataset.

The batch layer also pre-computes the master dataset into batch views so that queries can be resolved with low-latency.

![the pre-computation of batch views](https://cdn-images-1.medium.com/max/2730/1*0fEm3ceh7KurPVJ027S2TA.png)

Because our master dataset is continually growing, we must have a strategy for managing our batch views when new data becomes available.

* **Re-computation algorithms**: throwing away the old batch views and re-computing functions over the entire master dataset.
* **Incremental algorithms**: updating the views directly when new data arrives.

#### Speed layer

The speed layer indexes the batch views for fast ad hoc queries. It stores the realtime-views and processing the incoming data stream so as to update these views. The underlying storage layer must meet the following conditions.

* **Random reads**: supporting fast random reads to answer queries quickly.
* **Random writes**: to support incremental algorithms, it must also be possible to modify a real-time view with low latency.
* **Scalability**: the real-time views should scale with the amount of data they store and the read/write rates required by the application.
* **Fault tolenrance**: if a machine crashes, a real-time view should continue to function normally.

#### Serving layer

This layer provides low-latency access to the results of calculations performed on the master dataset. This process can be facilitated by additional indexing of the data in order to speed up the reads. Similar to the speed layer, this layer must meet the following requirements such as random reads, batch writes, scalability, and fault tolerance.

## The Lambda architecture satisfies almost all properties

The Lambda architecture is based on several assumptions: fault tolerance, support of ad hoc queries, scalability, extensibility.

* **Fault tolerance**: the Lambda architecture provides human fault tolerance capability to the big data system because when a mistake is made, we can fix the algorithms or re-compute the views from scratch.
* **Ad hoc queries:** the batch layer allows for ad-hoc querying against any data.
* **Scalability:** all the batch layer, speed layer, and serving layers are easily scalable. Since they are all fully distributed systems, we can scale them easily as adding new machines.
* ****Extensibility**: **adding a new view is easy as adding a new function of the master dataset.

## Some questions to ask?

#### How has the code be synchronized between layers?

One of the approaches to tackle this issue is to have a common code base for the layers by using common libraries or introducing some kind of abstraction shared between the flows. Examples of such frameworks are Summingbird or Lambdoop. Casado

#### Can we remove speed layer?

Yes, the speed layer is in many applications not necessary. If we shorten the batch cycles, the latency in data availability can be reduced. On the other hand, new faster tools for accessing the data stored on Hadoop such as Impala, Drill, or new versions of Tez, etc., make it possible to take some actions on the data in a reasonable time.

#### Can we give up the batch layer and process everything in the speed layer?

Yes, an example of such an architecture, called Kappa Kreps, proposes that incoming data be processed in streaming and whenever a larger history is needed, it can be re-streamed from Kafka buffers, or if we have to go back even further, from the historical data cluster.

## How to implement the Lambda architecture?

We can implement this architecture in the real-world by using Hadoop data lakes, where HDFS can be used to store the master dataset, Spark (or Storm) can form the speed layer, HBase (or Cassandra) can be the serving layer, and Hive creates views that can be queried.

![an example implementation of the Lambda architecture](https://cdn-images-1.medium.com/max/2730/1*4oItXvPnvE04LCB9Z2-BZw.png)

## Lambda architecture in use

#### Yahoo

For running analytics on its advertising data warehouse, Yahoo has taken a similar approach, also using Apache Storm, Apache Hadoop, and Druid².

#### Netflix

The Netflix Suro project is the backbone of Netflix’s Data Pipeline that has separate processing paths for data but does not strictly follow lambda architecture since the paths may be intended to serve different purposes and not necessarily to provide the same type of views³.

**LinkedIn**

Bridging offline and nearline computations with Apache Calcite.

## Conclusion

Keep in mind that: batch view = function (all data), realtime view = function (real-time view, new data) and query = function (batch view, real-time view).

Easy, right?

## References

- [1] [http://nathanmarz.com/blog/how-to-beat-the-cap-theorem.html](http://nathanmarz.com/blog/how-to-beat-the-cap-theorem.html)
- [2] [http://www.slideshare.net/Hadoop_Summit/interactive-analytics-in-human-time?next_slideshow=1](http://www.slideshare.net/Hadoop_Summit/interactive-analytics-in-human-time?next_slideshow=1)
- [3] [https://netflixtechblog.com/announcing-suro-backbone-of-netflixs-data-pipeline-5c660ca917b6](https://netflixtechblog.com/announcing-suro-backbone-of-netflixs-data-pipeline-5c660ca917b6)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
