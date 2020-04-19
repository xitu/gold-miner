> * 原文地址：[Kafka vs. RabbitMQ: Why Use Kafka?](https://medium.com/better-programming/kafka-vs-rabbitmq-why-use-kafka-8401b2863b8b)
> * 原文作者：[SeattleDataGuy](https://medium.com/@SeattleDataGuy)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kafka-vs-rabbitmq-why-use-kafka.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kafka-vs-rabbitmq-why-use-kafka.md)
> * 译者：
> * 校对者：

# Kafka vs. RabbitMQ: Why Use Kafka?

> Are all data streaming services made equal?

![Photo by [Levi Jones](https://unsplash.com/@ev?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/data?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/5754/1*DJvGajoZpUGKsSSEFyzwwQ.jpeg)

A vital part of the successful completion of any project is the selection of the right tools for performing essential basic functions. For developers, the availability of several messaging services to pick from always poses a challenge.

One crucial question unanswered is the use of [Apache Kafka](https://kafka.apache.org/) or [RabbitMQ](https://www.rabbitmq.com/) services. Both platforms feature several functionalities and use cases that can help users make an informed decision.

Apache Kafka and RabbitMQ are two top platforms in the area of messaging services. Although both platforms handle messaging differently, the difference lies in their selected architecture, design, and approach to delivery.

## But What Are Apache Kafka and RabbitMQ?

Apache Kafka and RabbitMQ are open-source platforms that are utilized for streaming data as well as come equipped with [pub/sub](https://www.rabbitmq.com/tutorials/tutorial-three-ruby.html) (which we will describe later) systems that are commercial — supported and used by several enterprises.

#### What is Apache Kafka?

Apache Kafka, in simple terms, is a message bus optimized for high-access data replays and streams. The robust message broker allows applications to continually process and re-process stream data.

The open-source platform uses an uncomplicated and easy routing approach that engages a routing key in sending messages to a topic. Launched in 2011, the Kafka tool was created for streaming setups.

#### What is RabbitMQ?

RabbitMQ is an all-round messaging broker with support protocols like Advanced Message Queuing Protocol (AMQP), MQ Telemetry Transport (MQTT), and Simple (or Streaming) Text-Oriented Messaging Protocol (STOMP).

RabbitMQ can handle use cases seeking high efficiency, like processing online payments. RabbitMQ can also serve as a message broker amongst microservices.

Launched in 2007, RabbitMQ started as a primary element in messaging and SOA systems. Nowadays, its expanded roles also include streaming use cases.

So, if you are considering whether to use Apache Kafka or RabbitMQ, read on to learn about the difference in architectures, approaches, and their performance pros and cons.

## Architecture Differences

#### Apache Kafka architecture

The Apache Kafka architecture uses a high volume of publish-subscribe messages and a streams platform that is quick and scalable. The robust message store, like logs, makes use of server clusters that hold several records in topics (categories).

[All Kafka messages feature a key, value, and timestamp](http://kth.diva-portal.org/smash/get/diva2:813137/FULLTEXT01.pdf). The smart consumer or dumb broker model do not attempt tracking on consumer messages and only retain unread messages. Apache Kafka holds all messages for a defined time frame.

#### RabbitMQ architecture

The RabbitMQ architecture makes use of an all-round message broker which entails variations in point-to-point, request/reply, and pub/sub communication designs.

The use of a dumb consumer and smart broker method allows for reliable message delivery to consumers with similar speed to that of a broker monitoring the state of consumers.

With the use of synchronous or asynchronous communication methods, the platform provides adequate support for several plugins including .NET, client libraries, Java, Node.js, Ruby, and more.

It also makes available distributed deployment scenarios alongside a multi-node cluster to cluster federation with zero reliance on external services.

With [RabbitMQ](http://kth.diva-portal.org/smash/get/diva2:813137/FULLTEXT01.pdf), publishers can transmit messages to exchanges, and retrieve messages from queues by consumers. The decoupling producers from lines through exchanges guarantee that producers are not troubled with hardcoded routing choices.

## Publish/Subscribe (Pub/Sub)

Publish/subscribe is amongst the main messaging patterns for asynchronous messaging, a messaging scheme where message production is decoupled from its processing by a consumer.

#### Apache Kafka

In Apache Kafka, the platform is created for high volume publish-subscribe messages and streams, which are intended to be durable, quick, and scalable. In essence, Kafka makes available a sustainable message store and a server cluster.

#### RabbitMQ

In RabbitMQ, the design entails an all-round message broker, using several variations of point-to-point, request/reply, and pub-sub communication style patterns.

## Push/Pull Model

#### Apache Kafka: Pull-based method

Kafka makes use of a pull model where consumers make message requests in batches from a specified offset. Apache Kafka also allows for long-pooling, which stops tight loops when no message goes through the offset.

The pull model remains logical for Apache Kafka due to its partitions. Its platform makes available message order within a barrier without contending consumers.

This approach lets users leverage message batching for efficient message delivery and better throughput.

#### RabbitMQ: Push-based method

RabbitMQ pushes messages to the consumer, which includes a prefetch limit configuration essential to preventing the consumer from becoming overwhelmed by multiple messages.

They can also be useful for low latency messaging. The purpose of the push method is the quick distribution of individual messages individually, alongside a guarantee that all of it is parallelized evenly and messages are processed in an ordered queue, usually as they arrive.

## Use Cases

#### Apache Kafka

Apache Kafka provides an additional broker itself, for which it is best known and it is a popular element of the platform. The additional broker has been premeditated and marketed in the direction of stream processing setups.

Also, the addition of Kafka Streams serves as an alternative to streaming platforms like Apache Flink, Apache Spark, Google Cloud Data Flow, and Spring Cloud Data Flow.

The exceptional [use cases](https://kafka.apache.org/uses) documentation provides a detailed use case for Apache Kafka including its commit logs, event sourcing, log aggregation, metrics, web activity tracking, and more tasks.

#### RabbitMQ

RabbitMQ delivers an all-round messaging solution with widespread usage amongst web servers’ timely response to requests in place of enforced response to performing resource-heavy measures while users await the result.

RabbitMQ is also excellent for distributing messages to multiple receivers as it offers a lot of [features for reliable delivery](http://www.rabbitmq.com/confirms.html), federation, management tools, routing, security, and [other functions](http://www.rabbitmq.com/features.html).

With assistance from additional software, RabbitMQ can also effectively address several substantial uses cases. A combination with Apache Cassandra can provide access to stream history, or with the [LevelDB](https://github.com/google/leveldb) plugin for access to an “infinite” queue.

## Conclusion

Both [Apache Kafka and RabbitMQ](https://www.theseattledataguy.com/kafka-vs-rabbitmq-why-use-kafka/) platforms offer a variety of critical services intended to suit a lot of demands.

RabbitMQ is sufficient for simple use cases that entail low data traffic. Also, with RabbitMQ, other additional benefits include flexible routing prospects and priority queue options.

On the other hand, if the proposed use case features the need for massive data and high traffic, then Apache Kafka is worth considering.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
