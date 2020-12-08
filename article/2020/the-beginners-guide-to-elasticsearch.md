> * 原文地址：[The Beginners Guide to Elasticsearch](https://levelup.gitconnected.com/the-beginners-guide-to-elasticsearch-8fc237fc3209)
> * 原文作者：[Landy Simpson](https://medium.com/@simplyy)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-beginners-guide-to-elasticsearch.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-beginners-guide-to-elasticsearch.md)
> * 译者：
> * 校对者：

# The Beginners Guide to Elasticsearch

#### A breakdown of the concepts to get started on this mighty analytical search engine.

![Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*a75ztDiDQX1fhNKE)

Elasticsearch is a distributed, scalable analytical search engine that supports complex aggregations for unstructured data.

**Akin to NoSQL data stores, Elasticsearch is built to handle unstructured data formats and dynamically determine fields’ data types.** Its primary data format is JSON **(Javascript Object Notation)** documents. JSON’s schema-less format allows for flexible data storage and ease of adding data without managing or creating relations.

However, Elasticsearch isn’t necessarily interchangeable to NoSQL databases. **Elasticsearch differs from NoSQL databases and has its own set of limitations.** For example, Elasticsearch distributed system adds a layer of complexity when performing transactions. Although it isn’t impossible to do distributed transactions, it’s ideal to avoid them if possible to simplify the process.

Elasticsearch also assumes enough memory is provided to its instances. Therefore it’s not too keen on handling OutOfMemory errors. As a result, it makes Elasticsearch less robust than other data storage systems.

Elasticsearch is commonly used as a secondary tool alongside other types of databases. **And it’s crucial to remember Elasticsearch is built for speed. It’s ideal for searching and filtering documents.**

#### Nodes and Clusters.

**Elasticsearch is made up of multiple nodes** (also known as Elasticsearch instances), **and a set of connected nodes is called a cluster.** All nodes within a cluster are knowledgeable about other nodes within that same cluster. Every node within a cluster can perform CRUD operations via HTTP requests **(POST, GET, PUT, DELETE)**. This model allows nodes to transfer client requests to other nodes that can fulfill the request.

![1 cluster, three nodes (ES instances), five shards](https://cdn-images-1.medium.com/max/4096/1*s51gp1IMLoTpsDHfGUimGg.png)

#### Index and Shards

Index are sometimes misunderstood for relational database indices. However, it’s crucial to understand the difference. **An Elasticsearch index is a collection of shards, and documents are evenly distributed among shards.** If not specified, then by default, Elasticsearch allocates five primary shards per index. The model is illustrated in the diagram above.

For instance, you might define `products` as an index. Within that index, there exists different product documents, like the following:

```
[{
 "title": "Apple MacBook Pro 13-Inch 'Core i7' 2.4",
 "price": "$2559",
 "sku": "123SampleBLK20",
 "itemCondition": "New",
 "availability": "IN_STOCK",
},
{
 "title": "Apple iPad Pro 12.9 (Wi-Fi Only - 4th Gen) 128GB",
 "price": "$699",
 "sku": "123SampleBLK21",
 "itemCondition": "Used",
 "availability": "IN_STOCK",
},
{
 "title": "Samsung Galaxy S20 - 128GB",
 "price": "$1199",
 "sku": "123SampleBLK22",
 "itemCondition": "New",
 "availability": "OUT_OF_STOCK",
}]
```

When documents are added to an index, Elasticsearch will determine which shard will hold that document. **Shards are evenly distributed amongst the nodes in the cluster.** If new nodes are added to the system, Elasticsearch will redistribute the shards evenly within the cluster.

![Notice an extra node was added to the cluster, and now the shards are redistributed as evenly.](https://cdn-images-1.medium.com/max/4096/1*QOQTNHjwiqe7KYj1IZ5cYw.png)

There’s also something to be said about “**active**” shards. **Active shards are somewhat self-explanatory. They’re shards that are actively holding data.** If there aren’t enough documents to utilize all the shards, some shards aren’t considered active even though they’ve been allocated for that index. You’ll see an example of this later on in the reading.

#### Replicas

Replicas are a type of shard, except they’re used to improve search performance and act as a backup for primary shards. **A complete replica is composed of five replica shards.** Therefore it’s often said there’s one replica per index.

Replica shards are a reliable fail-over because they’re never allocated on the same node as the shard they’re replicating. If you’re familiar with RAID **(Redundant Array of Independent Disks)**, then replica shards should sound somewhat similar. Data is mirrored onto a redundant disk or, in this case, shard. And because the shard is on a separate node, if nodes containing the primary shards fail, then the replicas will still be available. And the risk for nodes with replica and primary shards simultaneously failing is relatively low.

#### Clarifying the “Relational Database” Analogy

Elasticsearch can get a little complicated to understand. The confusion is mainly due to the inaccurate analogy the Elasticsearch team used to describe these concepts. Since then, the Elasticsearch team has tried to rectify the misinterpretation.

Most resources on the internet compare an index with an individual, relational database. Now, you might be thinking, **“Isn’t an index more like a table rather than a database?”**

You’re right. It does seem similar to a table. However, up until Elasticsearch v.6, there use to be the concept of mapping **types**. Types represented the type of document within an index. For example, if “**twitter”** is an index, then one could describe two types of **“twitter”** documents: “**tweet”** ****and** “user.” **There were many problems with types that I won’t delve into in this article, but essentially, types mimic relational database tables.

**My word of advice is not to make the connections with relational databases. It will confuse you, just as much as it confused me.**

## Installing and Getting Started.

**As previously noted, the primary way to interact with Elasticsearch is through HTTP requests (RESTFUL APIs).** In this section, we’ll review some basic methods for indexing into Elasticsearch instances to get you started.

To get started with Elasticsearch, install Docker and create a directory `data/elasticsearch`. Then run the following docker command to download the Elasticsearch Docker image and start the container.

```
docker run --restart=always -d --name elasticsearch \\
    -e "discovery.type=single-node"  \\
    -v ~/data/elasticsearch:/usr/share/elasticsearch/data \\
    -p 9200:9200 \\
    -p 9300:9300 \\
    docker.elastic.co/elasticsearch/elasticsearch:7.9.2
```

You can now access all the Elasticsearch API’s via`[http://localhost:9200](http://localhost:9200)`

#### Creating a New Index

You can create documents in one of two ways, through a PUT request or POST request. Since I’ll be using Elasticsearch v.7, I’ll avoid the topic of types. We’ll stick with Elasticsearch default type `_doc`. And work with indexes and documents.

We can create an empty index as follows:

PUT [http://localhost:9200](http://localhost:9200)/products

We can also create an index by inserting a document under the index name we desire, as shown below:

```
POST: http://localhost:9200/product/_doc/

{
 "title": "Apple MacBook Pro 13-Inch 'Core i7' 2.4",
 "price": "$2559",
 "sku": "123SampleBLK20",
 "itemCondition": "New",
 "availability": "IN_STOCK",
}
```

The above request will yield the following response:

```
{

  "_index": "product",
  "_type": "_doc",
  "_id": "xUs3MHYBPq6LuxBgrCHN",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
},
  "_seq_no": 6,
  "_primary_term": 1
}
```

The response above randomly generates an identifier `_id` for the document inserted. However, if you want to specify an identifier, change the POST request to a PUT request, and add the identifier to the end of the request as shown below:

```
PUT: http://localhost:9200/product/_doc/1
```

Going back to the response, notice there’s a total of two shards, one of which yielded a success. As I’ve briefly mentioned before, active shards contain data, and replica shards contain a copy. Therefore, this response informs us that data was fetched from one shard out of a total of two active shards **(one of which is a replica shard)**.

We can verify the number of shards by performing a CAT **(compact and align text)** API call, as shown below:

```
GET http://localhost:9200/_cat/shards/product
```

CAT API requests are statistical inquires about our Elasticsearch cluster. We can inquire about nodes, shards, indices, templates, and other Elasticsearch features.

The result of the above requests yields the following:

```
product 0 p STARTED    4 7kb 1xx.xx.x.x a6ffefa157e8
product 0 r UNASSIGNED
```

This response tells us that at index `product`, the shard identified **(in this case, they’re both labeled 0)** is either a replica **r** or primary **p,** and it has the state **STARTED** or **UNASSIGNED.** It also tells us the number of documents within the shard, the size on disk, the IP address, and the node id.

To get a complete list of CAT API requests, we can make the following request:

```
GET http://localhost:9200/_cat/
```

**I recommend keeping this request nearby. It’s convenient while you’re learning.**

#### Searching Indices

Elasticsearch's vast search capabilities are impossible to summarize in a few paragraphs. I’ll provide two basics to get you started: ******fetching all documents in an index and fetch a document by its identifier. ****I’ll cover more complex and interesting search queries in another article.**

We can request all documents in an index with the following request:

```
GET http://localhost:9200/product/_search
```

However, by default, Elasticsearch will return only 45 documents at a time. But we can increase that limit by specifying the query string, `size` as shown below:

```
GET http://localhost:9200/product/_search?size=100
```

Fetching a single document by its identifier is just as simple as adding a document except we change the POST request to a GET request, like as shown below:

```
GET http://localhost:9200/product_entity/_doc/1
```

---

#### Final Thoughts

Elasticsearch is a mighty analytical search engine. However, it can be very complex to maneuver.

In this article, I’ve covered some fundamental concepts to get you started. Still, I highly recommend looking through the [Elasticsearch v.7.9 or higher documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/index.html) and the [Elasticsearch blog](https://www.elastic.co/blog/) to expand your understanding.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
