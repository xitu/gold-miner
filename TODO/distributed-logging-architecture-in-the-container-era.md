* 原文地址：[ Distributed Logging Architecture in the Container Era ](https://blog.treasuredata.com/blog/2016/08/03/distributed-logging-architecture-in-the-container-era/ )
* 原文作者：[Glenn Davis](https://blog.treasuredata.com/blog/author/glenn/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：

# Distributed Logging Architecture in the Container Era

## 容器时代的分布式日志系统

### Microservices and Macroproblems

### 微服务与宏观问题

Modern tech enterprise is all about microservices and, increasingly, containers. Microservices are essential in a world in which services need to support a multitude of platforms and applications. Containers, like Docker, allow much more efficient resource utilization, better isolation, and greater portability than their closest cousins, Virtual Machines, making them ideal for microservices.

But microservices and containers create their own problems. Consider a modern microservice architecture compared to its unfashionable ancestor, monolithic architecture.

现代的科技公司强调微服务架构，容器，也随着越来越重要。在需要为多种平台和应用提供服务的世界里，微服务是必不可少的。容器，比如Docker，相比于它的近亲，虚拟机， 拥有更有效的资源利用性，更好的隔离性和更棒的可移植性，这使其成为了微服务的理想选择。

但微服务和容器也会带来问题。思考把现代的微服务架构与它已不再流行的前代，单体架构作对比。

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/1.png?w=800)

Monolithic architecture may not have the virtues of scalability and flexibility, but it does have unity. To see why this is important, consider the different kinds of log data you might need to collect and aggregate, depending on your business needs. You might want to know what page your website users visited most frequently, or what buttons and ads they clicked on. You might want to compare this with sales data gathered from your mobile app, or game data if you’re a game maker. You might also want to collect operations logs from your customers’ phones, or sensor data. If your internal teams are doing funnel analysis or event impact analysis, you might need to compare these computed results with historical data. IoT data, SaaS data, public data… the list goes on and on.

单体架构也许不具备可扩展性和灵活性，但它有统一性的优势。要理解为什么统一性非常重要，想象你也许需要根据你的业务需求，收集和聚合不同类型的日志数据。你也许想知道站点的哪个页面是访问最频繁的，哪个按钮或者广告是用户频繁点击的。你也许想把这些数据与从手机应用渠道来的销售数据，或者游戏数据做比对，如果你是一个游戏制作者的话。你也许想收集用户手机的操作日志，或者传感器的数据。如果你的内部团队正在做漏洞分析或者事件影响分析，你也许需要对比这些计算结果和历史数据。物联网数据，SaaS 服务数据，公共数据等等，数据类型可以有很多。

The data produced by a monolithic architecture, theoretically, is easy to track. Since the system is centralized by definition, the logs it produces can all be formatted with the same schema. Microservices, as we know, are not like this. Logs for different services have their own schema, or no schema at all! Because of this, simply ingesting logs from different services and getting them into a readable format is a hard data infrastructure problem to solve.

> In a containerized world, we must think differently about logging.

理论上，由单体架构产生的数据很容易追踪。按定义说，系统是中心化的，它生成的日志都可以使用相同的模式格式化。微服务，就我们所知道，不是这样的。不同服务的日志有自己的模式，或者根本就没有模式可言！因此，简单地从不同的服务收集日志，再将它们转成可读的格式，是一个难以解决的数据基础架构问题。

> 在容器化的世界里，我们必须从不同的角度想日志记录。

This is all before we start talking about containers. Containerization, as we’ve said, is a boon for microservice-based services because it’s efficient. Containers use far fewer resources than VMs — much less bare metal servers. They can be very close to their clients, increasing the speed of operations. And since they’re walled off from each other, the problem of dependencies is reduced (if not completely eliminated).

这是接下来我们要聊容器之前的所有问题。容器化，如我们所说，对以微服务为基础的服务是非常有用的，因为它很高效。容器使用的资源比虚拟机少得多 -- 远比实体服务器少。它们可以非常接近客户，提高运行速度。并且由于它们相互隔离，依赖的问题会可以减少（如果不能完全消除）。

But the things that make containers so great for microservices cause more problems with logging and data aggregation. Traditionally, logs are tagged with the IP address of the server they came from. This needn’t be the case with containers, severing the fixed mapping between servers and roles. Another problem is with storage of the log files. Containers are immutable and disposable, so logs stored in the container would go away when the container instance goes away. You can store them on the host server, but you might have multiple containers and services running on the same host server. What happens when the server runs out of storage? And how should we go fetch these logs? Use service discovery software, like Consul? Great, another component to install. (Eye roll.) Or maybe we should use rsync, or ssh and tail. So now we need to make sure our favored tool is installed on all our containers…

但这些使容器有利于微服务的优势，也导致了更多日志和数据聚合问题。传统上，日志用它们的来源服务器的 IP 地址标记。这不适用于容器，容器阻隔了固定的服务器和角色之间的映射。另一个问题是日志文件的存储。容器是不可变的，用后即可丢弃的，所以存在容器里的日志会随着容器实例结束而消失。你可以把它们存储在主机服务器上，但你也许并不是在同一台主机上运行多个容器和服务。如果服务器的存储空间不足时又会发生什么呢？我们如何获取这些日志呢？用服务发现软件，比如 Consul？太棒了，有需要安装一个组件（翻白眼）。或者也许我们应该用 rsync，或 ssh 和 tail。现在我们需要把这些喜欢的工具安装在我们的所有容器里。。。

### Breaking the Log Jam: Intelligent Data Infrastructure ###

There’s no getting around it. In a containerized microservices world, we must think differently about logging.

Logs should be:

- Labeled and parsed at the source, and
- Pushed to their destination as soon as possible

Let’s take a look at how this works.

### 突破日志困境：智能的数据基础架构

没有办法绕过上面的问题。在一个容器化微服务的世界中，我们必须重新思考如何记录日志。

日志应该是：

- 在来源处标记和解析，并
- 尽可能快地推送到目的地

让我们来看看这是如何工作的。



![](https://i2.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/2.png?w=450)

As mentioned earlier, logs from different sources can come in a variety of structured or unstructured formats. Processing raw logs is a data analytics nightmare. Collector Nodes solve this problem by converting the raw logs into structured data, i.e. key-value pairs in JSON, MessagePack, or some other standard format.

如我们前面说的，来自不同来源的日志可能是结构化或者非结构化的格式。处理原始日志简直是数据分析的噩梦。收集器节点通过将原始日志转换为结构化数据（例如，JSON中的键值对，消息包或者其他标准格式）来解决这个问题。

The Collector Node ‘agent’, which lives on the container, then forwards the structured data in real-time (or micro-batches) to an Aggregator Node. The job of the Aggregator Node is to combine multiple smaller streams into a single data stream that’s easier to process and ingest into the Store, where it’s persisted for future consumption.

What I’ve just described is a Data Infrastructure. Not everyone is accustomed to the idea their data needs an infrastructure, but in the Containerized Microservices world, there is no way around it.

There are a few requirements that need to be considered in order to make our data infrastructure scalable and resilient.

在容器里运行的收集器节点代理，将结构化的数据实时的（或者微批量的）转发到聚合器节点。聚合器节点的工作是将多个小的日志流组合成一个数据流，更容易处理和收集到 Store 节点，在那里他们将被持久化以备日后使用。

我刚刚介绍的就是一种数据基础架构。并不是每个人都接受他们的数据需要基础架构的想法，但是在容器化微服务的世界里，没有其他办法。

为了使我们的数据基础架构具有可扩展性和可恢复性，有一些问题需要提前考虑。

- Network Traffic. With all these nodes shuttling data back and forth, we need a “traffic cop” to make sure we don’t overload our network and/or lose data.
- CPU Load. Parsing data at the source and formatting it on the aggregator is CPU-intensive. Again, we need a system to manage these resources so we don’t overload our CPUs.
- Redundancy. Resiliency requires redundancy. We need to make our aggregators redundant in order to guard against data loss in case of a node failure.
- Controlling Delay. There’s no way to avoid some amount of latency in the system. If we can’t get rid of it altogether, we need to control the delay so that we know when we’ll know what’s happening in our systems.

Now that we’ve gone over the requirements, let’s look at some different aggregation patterns in service architecture.

- 网络流量。数据在所有的这些节点之间来回转发，我们需要一个“流量警察”，以确保网络不会过载或丢失数据。
- CPU 负载。在来源端解析数据和在聚合器上对其格式化是非常消耗计算资源的。同样，我们也需要一个系统来管理这些资源，防止我们的 CPU 超载。
- 冗余。弹性需要冗余。我们需要使聚合器冗余，以防止单点故障时造成数据丢失。
- 控制延迟。没有办法避免系统中的延迟。我们不能完全摆脱延迟，但我们需要控制它，这样我们才知道什么时候，系统中发生了什么。

现在我们看完了这些需求，让我们接着看看服务架构中一些不同的聚合模式。

![](https://i2.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/4.png?w=700)


### Source-Side Aggregation Patterns ###

The first question is whether we should aggregate at the source of the data—on the service side. The answer is a matter of tradeoffs.

### 来源端聚合模式

第一个问题是，我们是否应该在数据来源端（服务端）聚合 。答案是这需要权衡一下。

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/6.gif?w=450)

The big benefit of a service aggregation framework without source aggregation is simplicity. But the simplicity comes at a cost:

- Fixed aggregator (endpoint) address. If you change the address of your aggregator, you’ve got to reconfigure each individual collector.

- Many network connections. Remember when we said we need to be careful not to overload our network? This is how network overloads happen. Aggregating our data on the source side is much, much more network-efficient than aggregating it on the destination side — leading to fewer sockets and data streams for the network to support.

- High load in aggregator. Not only does source-side aggregation result in high network traffic, it can overload the CPU in the aggregator, resulting in data loss.

Now let’s look at the tradeoffs for source-side aggregation.

不在来源端设置聚合的服务框架的最大优势是简单，但这种简单是有代价的：

- 固定的聚合器（服务端）地址。如果想更改聚合器的地址，你不得不重新配置每一个收集器。
- 过多的网络连接。记得我们说的，小心不要超载我们的网络吗？网络超载就是这样发生的。在来源端聚合数据远比直接在目标端聚合数据，网络效率高得多 — 需要支撑的 socket 连接和数据流更少。
- 聚合器高负载。来源端聚合不仅导致网络流量高，也会使聚合器的 CPU 过载，导致数据丢失。

现在让我们看下在来源端聚合数据的利弊。

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/7.gif?w=500)

Aggregating on the source has one downside: It’s a bit more resource-intensive. It requires an extra container on each host. But this extra resource brings several benefits:

- Fewer connections. Fewer connections means less network traffic.
- Lower aggregator load. Since this resource cost is spread out over your entire data infrastructure, you have far less chance of overloading any individual aggregator, resulting in less chance of data loss.
- Less configuration in containers. Since the aggregator address for each collector is “localhost”, configuration is drastically simplified. The destination address only needs to be specified in one node—the local aggregate container.
- Highly flexible configuration. This simplified configuration makes your data infrastructure highly “modular”. You can swap services in and out to your heart’s content.

在来源端聚合有一个缺点就是：它会消耗更多的资源。它需要在每台主机上设置另一个容器，额外的资源消耗带来的好处有：

- 更少的网络连接数。更少的网络连接也意味着更少的网络流量。
- 较低的聚合负载。因为资源的消耗分摊在整个数据基础架构上，因此某个聚合器过载的几率会大大减少，从而数据丢失几率更小。
- 容器的配置更简单。因为对于每个收集器，聚合器的地址都是 “localhost”（本地），设置可以大大简化。目标端地址只需要在一个节点中（本地的聚合器容器）指定。
- 高度灵活的配置。这种简化配置使你的数据基础架构高度模块化。你可以随时为你的主要业务增删服务器。

### Destination-Side Aggregation Patterns

Regardless of whether we aggregate on the Source side, we can also elect to have separate aggregators on the Destination side. Whether we should do this is, again, a matter of tradeoffs. Avoiding Destination Aggregation limits the number of nodes, resulting in a much simpler configuration.

#### Source-Only Aggregation

## 目标端聚合模式

无论我们是否在来源端聚合，我们都可以选择在目标端创建单独的聚合器。最终是否应该这样做，同样是个离别权衡问题。避免目标端聚合可以限制节点数量，从而实现更简单的配置。

### 仅在来源端聚合

![](https://i2.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/9.gif?w=450)

But, just as on the Source side, avoiding aggregation on the Destination side comes with costs:

- A change on the Destination side affects the Source side. This is the same configuration problem we saw when we didn’t have aggregators on the Source side. If the Destination address changes, all the aggregators on the Source have to be reconfigured.
- Worse performance. Having no aggregators on the Destination side results in many concurrent connections and write requests being made to our Storage system. Depending on which one you use, this almost always results in a major performance impact. In fact, it’s the part of the system that most often breaks at scale, bringing even the most robust infrastructures to their knees.

但是，类似来源端，放弃目标端聚合也会是有代价的：

- 目标端的修改会影响来源端。这和我们不在来源端设置聚合器的情况下遇到的配置问题类似。如果目标端地址更新了，所有的来源端的聚合器都要被重新配置。
- 更差的性能。在不在目标端设置聚合器会导致很多并发连接和写请求发送到我们的存储系统。视你选择的存储系统而定，这几乎总是会导致重大的性能问题。实际上，这是系统最频繁的大规模出现问题的部分，甚至可以让最健壮的系统宕掉。

#### Source and Destination Aggregation

#### 来源端和目标端聚合

![](https://i1.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/10.gif?w=450)

The optimal configuration is to have aggregation on both the Source and the Destination side. Again, the tradeoff is that we end up with more nodes and a slightly more complicated configuration up front. But the benefits are clear:

- Destination side changes don’t affect the Source side. This results in far less overall maintenance.
- Better performance. With separate aggregators on the Source side, we can fine-tune the aggregators and have fewer write requests on the Store, allowing us to use standard databases with fewer performance and scaling issues.

最佳的配置是同时在来源端和目标端设置聚合器，同样，我们要权衡利弊，这样会导致有更多的节点，比之前的配置稍复杂。但是好处是显而易见的：

- 目标端的改变不会影响来源端，总体维护成本更低。
- 更好的性能。有了来源端的独立的聚合器，我们可以调整聚合器，减少对 Store 的写请求，这让我们可以选择性能和扩展问题更少的标准数据库。

#### Redundancy

Another major benefit of Source side aggregation is fault tolerance. In the real world, servers sometimes go down. The constant, heavy load of processing the service log generated in a large system of microservices makes server crashes more likely. When this happens, events that occur during the downtime can be lost forever. If your system stays down long enough, even your source-side buffers (if you are using a logging platform with source-side buffers—more on that in a minute) will overflow and result in permanent data loss.

Destination side aggregation improves fault tolerance by adding redundancy. By providing a final layer between containers and databases, identical copies of your data can be sent to multiple aggregators, without overwhelming your database with concurrent connections.

#### 冗余

在来源端聚合的另一个好处是容错性。在现实世界中，服务器是可能宕掉的。在处理由大量微服务连续不断生成的日志时，过重的负载更可能让服务器崩溃。当这种情况发生时，在宕机期间产生的事件会永久丢失，如果你的系统宕机时间过长，即使有来源端缓冲（如果你用的日志平台有来源端缓冲 — 超过一分钟）也会溢出，导致永久性的数据丢失。

目标端聚合通过增加冗余提高了容错能力。通过在容器和数据库之间多加一层，相同的数据副本会被发送给多个聚合器，而不是用并发连接过载你的数据库。

### Scaling Patterns

Load balancing is another important data infrastructure consideration. There are a thousand ways to handle load balancing, but the important factor we’re concerned with here is the tradeoff between scaling up, i.e. using a single HTTP/TCP load balancer which handles scale with a huge queue and an army of workers, or scaling out, where load balancing is distributed across many client aggregator nodes, in round robin fashion, and scale is managed by simply adding more aggregators.

### 扩展模式

负载均衡是数据基础架构另一个需要考虑的问题。有一千种方法来实现负载均衡，但是我们重点是要扩展模式之间做权衡，比如用一个 HTTP/TCP 负载均衡服务器来处理巨大的队列和大批的工作节点，或者水平扩展，负载通过循环方式均衡地分配到多个客户端聚合器节点，通过简单地增加聚合器来管理扩展。

![](https://i1.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/11.gif?w=800)

Which type of load balancing is best? Again, it depends. The approach you use should be determined by the  size of your system, and whether it uses Destination-side aggregation.

Scaling up is slightly simpler than scaling out, at least in concept. Because of this, it can be appropriate for startups. But there limits to scaling up against which companies tend to smash at the worst possible time. Don’t you hate it when [your service scales to 5 billion events per day and suddenly starts crashing every time it has to do garbage collection?](https://www.treasuredata.com/case-study/mobfox)

Scaling out is more complex, but offers (theoretically) infinite capacity. You can always add more aggregator nodes.

哪种类型的负载均衡是最好的，同样，取决于现实情况。使用哪种方式取决于你系统的规模和它是否采用目标端聚合。

至少在概念上垂直扩展比水平扩展简单。因此，它很适合创业项目。但是垂直扩展有局限性，有可能在最坏的时机出故障。难道当[你的服务扩展到每天处理 50 亿事件，然后突然开始在每次垃圾回收的崩溃](https://www.treasuredata.com/case-study/mobfox)，你不恼火吗？

水平扩展更复杂，但可以提供（理论上讲）无限的容量。你可以随时添加更多的聚合器节点。

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/12.gif?w=600)

### Lock and Key: Docker + [Fluentd](http://www.fluentd.org/)

### 锁与钥匙：Docker + [Fluentd](http://www.fluentd.org/)

The need for a unified logging layer for microservices led Sadayuki Furuhashi, [Treasure Data](https://www.treasuredata.com/)’s Chief Architect, to develop and open-source the [Fluentd](http://www.fluentd.org/)framework. [Fluentd](http://www.fluentd.org/) is a data collection system—a daemon, like syslogd, that listens for messages from services and routes them in various ways. But unlike syslogd, [Fluentd](http://www.fluentd.org/) was built from the ground up to unify log sources from microservices, so they can be used efficiently for production and analytics. The same performant code can be used in both Collector or Aggregator modes with a single tweak to configuration, making it extremely easy to deploy across an entire system.

对微服务统一的日志层的需求促使  Sadayuki Furuhashi，[Treasure Data](https://www.treasuredata.com/) 首席机构师，开发并开源了 [Fluentd](http://www.fluentd.org/) 框架。Fluentd 是一个日志采集系统，守护进程，类似 syslogd，它监听来自服务的消息，并以各种方式路由它们。但与 syslogd 不同，Fluentd 是为了统一微服务的日志源从头构建的，因此可以有效地用于生产环境和分析工具。相同的高性能代码可以在收集器或聚合器模式下使用，只要简单的调整配置，使其非常容易在整个系统上进行部署。

Because [Fluentd](http://www.fluentd.org/) is natively supported on Docker Machine, all container logs can be collected without running any “agent” inside individual containers. Just spin up Docker containers with “–log-driver=[fluentd](http://www.fluentd.org/)” option, and make sure either the host machine or designated “logging” containers run [Fluentd](http://www.fluentd.org/). This approach ensures that most containers can run “lean” because no logging agent needs to be installed at source containers.

因为 Docker Machine 原生支持 [Fluentd](http://www.fluentd.org/)，可以不必在每个容器中运行任何“代理”，就可以收集所有容器日志。只需要使用 “-log-driver=fluentd” 选项启动 Docker 容器，并确保主机或者指定的“日志”容器运行 Fluentd。这种方法可以确保大部分容器运行“精简”，因为不需要在来源容器中安装日志代理。

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/16.png?w=462)

[Fluentd](http://www.fluentd.org/)’s light weight and extensibility make it suitable for aggregating logs on both the source and destination sides, in either a “scaling up” or “scaling out” configuration. Again, which flavor is best for you depends on your present setup and your future needs. Let’s look at each in turn.

Fluentd 的轻量级和可扩展性使其适用于在来源和目的地端聚合日志，无论是“向上扩展”还是“向外扩展”配置。同样，哪种设置更好要根据你当前的设置和未来的需求来定。让我依次看看这两个设置。

### Simple Forwarding + Scaling Up ###

### 简单的转发 + 垂直扩展

![](https://i2.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/13.gif?w=400)

For easy setup, it’s hard to beat the simplicity of including a few lines of configuration code from the[Fluentd](http://www.fluentd.org/) logger library in your app and instantly enabling direct log forwarding with a single [Fluentd](http://www.fluentd.org/) instance per container. Because it’s nearly effortless, this can be a great boon to fledgling startups, which usually have a small number of services and data volumes low enough to store in a standard MySQL database with a few concurrent connections.

But at the risk of beating a seriously dead horse, there are limits to how much a system like this can scale. [What if your startup really takes off?](https://www.treasuredata.com/case-study/mobfox) Depending on how data-driven your business is, you might want to put in the implementation effort up front (or consider [outsourcing the problem with a manageddata infrastructure stack](http://treasuredata.com) ) to avoid panic attacks later on.

说到易于配置，很难有比只需要在你的应用里配置几行 Fluentd 日志库的代码，就可以在每个容器中启用直接把日志转发到 Fluentd 实例更易用的了。因为这几乎毫不费力，对于刚刚起步的创业公司来说是巨大利好，这类公司通常只有少数几个服务，数据量也比较小，可以通过几个并发连接存在标准的 MySQL 数据库中。

但是冒着徒劳无收益的风险，这样的系统可扩展的能力是有限的。[如果你的创业公司一飞冲天呢？](https://www.treasuredata.com/case-study/mobfox)取决于你的业务多大程度上是数据驱动的，你也许想提前做些准备（或者考虑[把问题托管给数据架构技术公司](http://treasuredata.com)）来避免到时措手不及。

### Source Aggregation + Scaling Up ###

### 来源端聚合 + 垂直扩展

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/14.png?w=400)

Another possible configuration is to aggregate on the source with [Fluentd](http://www.fluentd.org/), and send the aggregated logs to a NoSQL data store using one of [Fluentd](http://www.fluentd.org/)’s [400+ community contributed plugins](https://www.fluentd.org/plugins) . We’ll look at [Elasticsearch](https://www.elastic.co/)for this example, because it’s popular. This configuration (using Kibana for visualization), called the [EFK stack](https://www.pandastrike.com/posts/20150807-fluentd-vs-logstash) , is what e.g. [Kubernetes](http://kubernetes.io/docs/getting-started-guides/logging-elasticsearch/)  runs on. It’s reasonably straightforward, and it works great for medium data volumes. Usually.

A caveat with Elasticsearch: While being a great platform for search, it is [less than optimal as a central component of your data infrastructure.](https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/) This is especially true when you’re trying to load high volumes of important data. At production scale, Elasticsearch has been shown to have critical ingestion problems, including [split brain,](https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/)that result in data loss. In the EFK configuration, since [Fluentd](http://www.fluentd.org/) is aggregating on the source and not the destination, there’s nothing it can do if the store drops data.

For production-scale analytics, you might consider a more fault-tolerant platform, such as [Hadoop](https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/)or Cassandra — which are both optimized for high volume write loads.

另一种可能的配置是在来源端使用 Fluentd 聚合，并用有[400种多社区贡献插件](https://www.fluentd.org/plugins)之一，将聚合好的日志发送至一个 NoSQL 数据库存储。我们看看 [Elasticsearch](https://www.elastic.co/) 这个例子，因为它非常流行。这种配置（用 Kibana 做数据可视化），被称作 [EFK 技术栈](https://www.pandastrike.com/posts/20150807-fluentd-vs-logstash)，可以运行在 [Kubernetes](http://kubernetes.io/docs/getting-started-guides/logging-elasticsearch/) 上。这相当直观，通常对于中等数据规模来说也很管用。

使用 Elasticsearch 需要注意：它是一个很棒的搜索平台，但[不是数据基础架构中心组建的最优选择]((https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/))。当你需要负载大量的重要数据时，尤其如此。在生产级扩展方面，Elasticserach 已经被证明有关键的采集问题，包括[脑裂问题]((https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/))，会导致数据丢失。在 EFK 配置里，由于 Fluentd 是在来源端聚合而不是目标端，如果存储部件丢失数据，则无法继续进行任何公众。

对于生产级扩展分析，你可以考虑一个更容错的平台，比如 [Hadoop](https://blog.treasuredata.com/blog/2015/08/31/hadoop-vs-elasticsearch-for-advanced-analytics/) 或者 Cassandra ，这两个平台都针对大量写操作负载进行了优化。

### Source/Destination Aggregation + Scaling Out

### 来源端／目标端聚合 + 水平扩展

![](https://i0.wp.com/blog.treasuredata.com/wp-content/uploads/2016/08/15.png?w=400)

If you need to process massive amounts of complex data, your best bet is to set up both source and destination side aggregationnodes, leveraging the various configuration modes of [Fluentd](http://www.fluentd.org/). With the[Fluentd](http://www.fluentd.org/) logging driver that comes bundled with Docker, your application can just write its logs to STDOUT. Docker will automatically forward them to the [Fluentd](http://www.fluentd.org/) instance at localhost, which in turn aggregates and forwards them on to destination-side [Fluentd](http://www.fluentd.org/) aggregators via TCP.

如果你需要处理大量的复杂数据，最好的办法是同时在来源端和目标端设置聚合节点，利用 Fluentd 的多种设置模式。使用 Docker 附带的 Fluentd 日志驱动程序，你的应用程序可以将其日志写到 STDOUT 输出流。Docker 会自动把它们转发到本地的 Fluentd 实例上，然后按顺序聚合并通过 TCP 连接把它们再转发到目标端的 Fluentd 聚合器上。

This is where the power and flexibility of [Fluentd](http://www.fluentd.org/) really comes into its own. In this architecture,[Fluentd](http://www.fluentd.org/), by default, enables round-robin load balancing with automatic failover. This lends itself to scale-out architecture because each new node is load-balanced by the downstream instance feeding it. Additionally, the built-in [buffer architecture](http://docs.fluentd.org/articles/buffer-plugin-overview) gives it an automatic fail-safe against data loss at every stage of the transfer process. It even includes automatic corruption detection (which initiates upload retries until the complete dataset is transferred), as well as a deduplication API.

这就是 Fluentd 强大的功能和灵活性的体现。在这种构架中，Fluentd 默认启用具有自动故障转移功能的循环负载平衡。这很适合水平扩展的架构，因为每个新节点都根据下游实例的流量复杂平衡。另外，内置的[缓冲存储插件](http://docs.fluentd.org/articles/buffer-plugin-overview)能使其在传输过程中的每个阶段提自动防止数据丢失。它甚至包括自动的损坏检测（启动上传重试，直到完成全部数据传送）以及数据去重 API。

### What configuration is right for you?

It depends on your budget and how fast you must move. Are you a resource-strapped startup processing small amounts of data? You may be able to get away with forwarding straight from your source into a single node MySQL database. If your needs are more moderate without a strong need for fail safe data capture, the EFK stack may suffice.

As organizations of all sizes become more data-driven, however, it’s worth taking the time up front to think through your long-term goals. Do you need to make sure your data pipeline won’t choke when you start processing billions of events per day? Do you want maximum extensibility for whatever data sources you may want to add in the future? Then you may want to consider implementing both source and destination aggregation up front. Your future self (and colleagues) will thank you when your data volumes start exploding.

### 哪种配置更适合你？

这取决于你的预算和业务发展有多快。你的创业公司是资源紧缺，只需要处理少量数据吗？你可以直接从来源端容器转发到一个单节点的 MySQL 数据库。如果你的需求更加简单，没有捕获故障的数据安全需求，EFK 技术栈就可以满足了。

然而，随着各种规模的组织变得越来越数据驱动，花时间思考你的长期目标是值得的。你是否需要确保当每天开始处理数十亿次事件时，数据管道不会阻塞？你是否希望未来无论添加的任何数据源时，系统具有最大的可扩展性？那样你应该考虑同时在来源端和目标端做聚合。未来数据量爆发时，你（和同事）将感谢你的深谋远虑。

Whatever your configuration, the simplicity, reliability and extensibility of [Fluentd](http://www.fluentd.org/) make it a great choice for data forwarding and aggregation. And the fact that it comes built-in with Docker makes it a no-brainer for any microservices-based system.

If you need maximum future scalability and don’t have the resources to implement it today, or want to minimize time spent on maintenance in the future, you might consider [Fluentd](http://www.fluentd.org/) Enterprise Support from [Treasure Data](https://www.treasuredata.com/). This enterprise-ready service comes with 24/7 security, monitoring, and maintenance, as well as world-class support from the team who wrote the framework.

无论你如何配置，Fluentd 的简单性，可靠性和可扩展性使其成为数据转发和聚合的理想选择。事实上，Docker 的内置使 Fluentd 成为了任何基于微服务的系统的不二选择。

如果你需要最大未来可扩展性，但现在没有足够的资源来实现，或者想要未来最大限度地减少维护用时，你可以考虑 [Treasure Data](https://www.treasuredata.com/) 的 [Fluentd](http://www.fluentd.org/) 企业支持版。企业版提供 24*7 的安全，监控和维护服务以及框架研发团队的支持。

If you want a plug-and-play data stack to outsource management of your entire analytics system, consider our fully-managed collection, storage, and processing system at [Treasure Data](https://www.treasuredata.com/).

Happy Logging!

*Thanks to [Satoshi “Moris” Tagomori,](https://twitter.com/tagomoris)  on whose LinuxCon Japan presentation this blog post is based!*

如果您想要即插即用数据技术栈来外包整个分析系统的管理，请考虑 [Treasure Data](https://www.treasuredata.com/) 全面管理的收集，存储和处理系统。

Happy Logging!

感谢 [Satoshi “Moris” Tagomori,](https://twitter.com/tagomoris)，这篇 post 内容基于他在 LinuxCon Japan 的演讲。
