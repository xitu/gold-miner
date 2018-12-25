> * 原文地址：[Data Streaming](http://tutorials.jenkov.com/data-streaming/index.html)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-data-streaming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-data-streaming.md)
> * 译者：
> * 校对者：

# Data Streaming

- [Data Streaming](#data-streaming)
  - [Data Streaming Comes in Many Variations](#data-streaming-comes-in-many-variations)
  - [Data Streams Decouple Producers and Consumers](#data-streams-decouple-producers-and-consumers)
  - [Data Streaming as Data Sharing Mechanism](#data-streaming-as-data-sharing-mechanism)
  - [Persistent Data Streams](#persistent-data-streams)
  - [Data Streaming Use Cases](#data-streaming-use-cases)
    - [Data Streaming For Event Driven Architecture](#data-streaming-for-event-driven-architecture)
    - [Data Streaming For Smart Cities and Internet of Things](#data-streaming-for-smart-cities-and-internet-of-things)
    - [Data Streaming For Regularly Sampled Data](#data-streaming-for-regularly-sampled-data)
    - [Data Streaming For Data Points](#data-streaming-for-data-points)
  - [Records, Messages, Events, Samples Etc.](#records-messages-events-samples-etc)

_Data Streaming_ is a data distribution technique where data producers write data records into an ordered data stream from which data consumers can read that data in the same order. Here is a simple data streaming diagram illustrating a data producer, a data stream and a data consumer:

![Data stream of records with a data producer and consumer.](http://tutorials.jenkov.com/images/data-streaming/data-streaming-introduction-1.png) 

## Data Streaming Comes in Many Variations

On the surface, data streaming as a concept my look very simple. Data producers store records to a data stream which are read later by consumers. However, under the surface there are many details that affect what your data streaming system will look like, how it will behave, and what you can do with it.

Each data streaming product makes a certain set of assumptions about the use cases and processing techniques to support. These assumptions leads to certain design choices, which affect what types of stream processing behaviour you can implement with them. This data streaming tutorial examines many of these design choices, and discuss their consequences for you as a user of products based on these design choices.

## Data Streams Decouple Producers and Consumers

Data streaming decouple data producers and data consumers from each other. When a data producer simply writes its data to a data stream, the producer does not need to know the consumers that read the data. Consumers can be added and removed independently of the producer. Consumers can also start and stop or pause and resume their consumption without the data producer needing to know about it. This decoupling simplifies the implementation of both data producers and consumers.

## Data Streaming as Data Sharing Mechanism

Data streaming is a very useful mechanism to both store and share data in bigger distributed systems. As mentioned earlier, data producers just send the data to the data stream system. Producers do not need to know anything about the consumers. Consumers can be up, down, added and removed without affecting the producer.

Big companies like LinkedIn use data streaming extensively internally. Uber uses data streaming internally too. Many enterprise level companies are adopting, or have already adopted, data streaming internally. So has many startups.

## Persistent Data Streams

A data stream can be persistent, in which case it is sometimes referred to as a _log_ or a _journal_. A persistent data stream has the advantage that the data in the stream can survive a shutdown of the data streaming service, so no data records are lost.

Persistent data streaming services can typically hold larger amounts of historic data than a data streaming service that only holds records in memory. Some data streaming services can even hold historic data all the way back to the first record written to the data stream. Others only hold e.g. a number of days of historic data.

In the cases where a persistent data stream holds the full history of records, consumers can replay all these records and recreate their internal state based on these records. In case a consumer discovers a bug in its own code, it can correct that code and replay the data stream to recreate its internal database.

## Data Streaming Use Cases

Data streaming is a quite versatile concept which can be used to support many different use cases. In this section I will cover some of the more commonly used use cases for data streaming.

### Data Streaming For Event Driven Architecture

Data streaming is often used to implement [event driven architecture](http://tutorials.jenkov.com/software-architecture/event-driven-architecture.html). The events are written by event producers as records to some data streaming system from which they can be read by event consumers.

### Data Streaming For Smart Cities and Internet of Things

Data streaming can also be used to stream data from sensors mounted around a _Smart City_, from sensors inside a _smart factory_ or from other _Internet of Things_ devices. Values, like temperature, pollution levels etc. can be sampled from devices regularly and written to a data stream. Data consumers can read the samples from the data stream when needed.

### Data Streaming For Regularly Sampled Data

Sensors in a smart city, and Internet of Things devices, are just two examples of data sources which can be regularly sampled and made available via data streaming. But there are many other types of data which can be sampled regularly and streamed. For instance, currency exchange rates or stock prices can be sampled and streamed too. Poll numbers can be sampled and streamed regularly too.

### Data Streaming For Data Points

In the example of poll numbers, you could decide to stream each individual answer to the poll, rather than stream the regularly sampled totals. In some scenarios where totals are made up from individual data points (like polls) it can sometimes make more sense to stream the individual data points rater than the calculated totals. It depends on the concrete use case, and on other factors, like whether the individual data points are anonymous or contains private, personal information which should not be shared.

## Records, Messages, Events, Samples Etc.

Data streaming records are sometimes referred to as messages, events, samples, objects and other terms. What term is used depends on the concrete use case of the data streaming, and how the producers and consumers process and react to the data. It will normally be reasonably clear from the use case what term it makes sense to refer to records by.

It is worth noting, that the use case also influences what a given record represents. Not all data records are the same. An event is not the same as a sampled value, and cannot always be used in the same way. I will touch this in more detail later in this (and / or other) tutorials.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
