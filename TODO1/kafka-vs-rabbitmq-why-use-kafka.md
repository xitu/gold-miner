> * 原文地址：[Kafka vs. RabbitMQ: Why Use Kafka?](https://medium.com/better-programming/kafka-vs-rabbitmq-why-use-kafka-8401b2863b8b)
> * 原文作者：[SeattleDataGuy](https://medium.com/@SeattleDataGuy)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kafka-vs-rabbitmq-why-use-kafka.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kafka-vs-rabbitmq-why-use-kafka.md)
> * 译者：[Roc](https://github.com/QinRoc)
> * 校对者：[icy](https://github.com/Raoul1996)，[cyril](https://github.com/shixi-li)

# Kafka vs. RabbitMQ：为什么使用 Kafka？

> 所有的数据流服务都是一样的么？

![Photo by [Levi Jones](https://unsplash.com/@ev?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/data?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/5754/1*DJvGajoZpUGKsSSEFyzwwQ.jpeg)

任何项目的圆满完成都离不开选择正确的工具来实现必需的基础功能。对开发者而言，从多个消息服务中挑选出一个合适的，一直是一个挑战。

一个悬而未决的重要问题是：选择 Apache Kafka 还是 RabbitMQ？这两个平台都有独特的功能和使用场景，了解这些可以帮助用户做出明智的选择。

Apache Kafka 和 RabbitMQ 是消息服务领域的两大顶尖平台。这两个平台处理消息的方式存在差异，主要体现在它们的架构、设计和消息传递方式上。

## 但是 Apache Kafka 和 RabbitMQ 到底什么是呢？

Apache Kafka 和 RabbitMQ 都是可用于流数据处理的开源平台，由多家企业支持并使用，同样也配备有商业化的[发布/订阅（pub/sub）](https://www.rabbitmq.com/tutorials/tutorial-three-ruby.html)系统（我们将在后面介绍）。

#### Apache Kafka 是什么？

简而言之，Apache Kafka 是针对高速存取数据的重放和流而优化的消息总线。Kafka 健壮的消息代理使应用程序可以连续地处理和重新消费流数据。

这个开源平台使用了一种简单易行的路由方法，该方法使用了路由键（routing key）来将消息发送到某个主题（topic）。Kafka 于 2011 年推出，它为流处理体系而生。

#### RabbitMQ 是什么？

RabbitMQ 是一个多功能的消息代理，它支持多种协议的，例如 高级消息队列协议（Advanced Message Queuing Protocol，AMQP），MQ 遥测传输（MQ Telemetry Transport，MQTT）和 面向文本的简单（或流）消息协议（Simple (or Streaming) Text-Oriented Messaging Protocol，STOMP）。

RabbitMQ 可以处理追求高效的场景，例如处理在线支付场景。RabbitMQ 也可以用作微服务间的消息代理。

RabbitMQ 推出于 2007 年，甫一问世，就成为了消息处理和 SOA 系统的主要组件。现在，它已经覆盖了流处理的使用场景。

如果你正在纠结是选用 Apache Kafka 还是 RabbitMQ，那么请继续阅读，进一步了解两者在架构、方法以及性能优缺点方面的差异。

## 架构差异

#### Apache Kafka 的架构

Apache Kafka 的架构使用了大量的发布-订阅消息和一个高速、可扩展的流平台。它的健壮的消息存储机制（如日志）利用了服务器集群来存储不同 topic（即类别）下的多条记录。

[Kafka 的每条消息都由键、值和时间戳组成](http://kth.diva-portal.org/smash/get/diva2:813137/FULLTEXT01.pdf)。智能消费者（smart consumer）或哑代理（dumb broker）模型不会试图追踪消费者的消息，而只是保留未读消息。Apache Kafka 会在一个规定的时间范围内保留全部的消息。

#### RabbitMQ 的架构

RabbitMQ 的架构使用了多功能的消息代理，这个代理的设计综合了点对点、请求/响应和发布/订阅的多种通信方案的变体。

哑消费者（dumb consumer）和智能代理（smart broker）模型的运用可以为消费者可靠地投递消息，并且这种方法的速度与使用代理监控消费者状态的方法的速度不相上下。

通过使用同步或异步的通信方法，该平台对包括 .NET、Java、Node.js、Ruby 在内的多种语言客户端库和其他插件提供了足够的支持。

RabbitMQ 还在不依赖外部服务的情况下，实现了分布式部署方案和多节点集群联合。

使用 [RabbitMQ](http://kth.diva-portal.org/smash/get/diva2:813137/FULLTEXT01.pdf)，发布者可以将消息传输到交换机，消费者再从队列中取出消息。交换机将消息生产者从生产线中解耦出来，确保生产者不用担心硬编码的路由选择。

## 发布/订阅（Pub/Sub）

发布/订阅是异步消息传递的主要模式之一。异步消息传递方案解耦了消息的生产与消费者对它的处理。

#### Apache Kafka

在 Apache Kafka 中，该发布/订阅平台是为大量发布-订阅消息和流而创建的，旨在持久、高速和可扩展。本质上，Kafka 带来了持久化的消息存储和服务器集群。

#### RabbitMQ

RabbitMQ 的设计方案中有多功能的消息代理，这个代理基于点对点、请求/响应和发布-订阅通信模式的变体来实现。

## 推/拉（Push/Pull）模型

#### Apache Kafka：基于拉（Pull）的方法

Kafka 使用拉模型，在该模型中，消费者从特定的偏移量开始批量地请求消息。Apache Kafka 还支持长轮询，当通过偏移量不再获取到消息时，长轮询会停止紧凑的轮询请求。

由于分区（partitions）的存在，Apache Kafka 使用拉取模型是合理的。Kafka 可以在没有消费者相互竞争的情况下提供消息排序。

这种方法让用户可以利用消息批处理来实现高效的消息传递，获取更高的吞吐量。

#### RabbitMQ：基于推（Push）的方法

RabbitMQ 将消息推送给消费者，这个过程包括预读取限制的配置，该配置对于防止消费者被多个消息淹没至关重要。

它们对于低延迟的消息传递也很有用。推送方法的目的是快速而独立地分发各个消息，在这个过程中保证所有的分发是均匀地并行进行的，并使消息能够按照到达的顺序获得处理。

## 使用案例

#### Apache Kafka

众所周知，Apache Kafka 本身提供了一个额外的代理，该代理是这个平台的流行元素。这个额外的代理已经在流处理体系的方向上做了预先考虑和布局。

另外，增加的 Kafka Streams 可以替代 Apache Flink、Apache Spark、Google Cloud Data Flow 和 Spring Cloud Data Flow 等流处理平台。

Kafka 优秀的[案例文档](https://kafka.apache.org/uses)提供了详细的使用案例说明，包括提交日志、事件源、日志聚合、指标、Web 活动跟踪和更多其他任务。

#### RabbitMQ

RabbitMQ 提供了一种全面的消息传递解决方案，该方案广泛用于实现 Web 服务器对请求的及时响应，已经代替了让用户一直等待资源密集型计算的结果的响应方式。

RabbitMQ 还非常适合于将消息分发给多个接收者，因为它提供了许多[实现可靠投递的功能](http://www.rabbitmq.com/confirms.html)、联合、管理工具、路由和安全性，还有一些[其他功能](http://www.rabbitmq.com/features.html)。

借助其他软件的帮助，RabbitMQ 还可以有效地解决几个实际使用案例。RabbitMQ 与 Apache Cassandra 的组合可以提供对流历史的访问，或者与 [LevelDB](https://github.com/google/leveldb) 插件一起提供对“无限”队列的访问。

## 结论

Apache Kafka 和 RabbitMQ 平台均提供了多种关键服务，以适应大量的需求。

对于低数据流量的简单场景，RabbitMQ 就够用了。此外，RabbitMQ 还有其他的优势，例如灵活的路由预测和优先级队列选项。

另一方面，如果是需要大量数据和高流量的场景，那么 Apache Kafka 值得考虑。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
