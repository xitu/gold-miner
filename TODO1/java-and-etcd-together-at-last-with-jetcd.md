> * 原文地址：[Java and etcd: together at last, with jetcd](https://coreos.com/blog/java-and-etcd-together-with-jetcd)
> * 原文作者：[Fanmin Shi](https://coreos.com/blog/java-and-etcd-together-with-jetcd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-and-etcd-together-at-last-with-jetcd.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-and-etcd-together-at-last-with-jetcd.md)
> * 译者：[mingxing](https://github.com/mingxing47)
> * 校对者：[xiantang](https://github.com/xiantang)

# Java 和 etcd: 因为 jetcd 最终走到了一起

可靠的键值存储为分布式系统提供了一致性配置和协调的公共基础。[etcd](https://github.com/coreos/etcd) 项目就是一个这样的系统，这是一个由 CoreOS 创建的开源键值存储系统。它是许多[生产级分布式系统](https://github.com/coreos/etcd/blob/master/documentation/producing-users.md)的核心组件和 [Kubernetes](https://kubernetes.io/) 等项目的数据存储中心。

Java 已经通过在包括 Hadoop 生态系统、Cassandra 数据存储和云基础设施技术栈中的使用而证明了自己是一种流行的分布式系统语言。此外，它仍然是一种非常流行的语言。可以看看在[谷歌趋势](https://trends.google.com/trends/explore?cat=32&q=%2Fm%2F07sbkfb,%2Fm%2F09gbxjr,%2Fm%2F06ff5,%2Fm%2F0gdzk,%2Fm%2F02p97)的统计数据中，Java 仍然占据主导地位：
![](https://coreos.com/sites/default/files/inline-images/google-trends-java.png)
> 就谷歌搜索结果而言，Java 仍然比 Microsoft 的 .Net 甚至 JavaScript 语言更受欢迎

面对着 Java 的流行及其在分布式系统中的普遍使用，我们认为对于 Java 开发来说，etcd 也应该作为后端基础被使用到。jetcd 这个新的 etcd 客户端的出现，将 etcd v3 API 带到了 Java 中。

通过使用 jetcd，Java 应用程序可以使用包装了 etcd 的原生 [gRPC](https://github.com/coreos/etcd/blob/master/Documentation/dev-guide/api_reference_v3.md) 协议的智能 API 来与 etcd 进行纯粹的交互。该 API 提供了仅在 etcd 上可用的表达性分布式特性。更重要的是，通过直接支持更多的语言，使用新的使用模式更容易为 etcd 编写新的应用程序，从而帮助 etcd 变得更加稳定和可靠。

## 初级入门

你可以通过构建并运行一个名为 `jetcdctl` 的[小例子程序](https://github.com/coreos/jetcd/tree/master/jetcd-examples/jetcd-simple-ctl)来试用 jetcd，该程序使用了 jetcd 去访问 etcd。对于更进一步的 jetcd 项目来说，jetcdctl 示例也是一个很好的起点。要继续学习，你还需要同时安装 Git 和 Java。

首先，克隆 jetcd 库来获取 jetcd 源码，然后使用 Maven 来构建 `jetcd-simple-ctl` 吧:

``` plain
$ git clone https://github.com/coreos/jetcd.git
$ cd jetcd/jetcd-examples/jetcd-simple-ctl
$ ./mvnw clean package
```

构建并准备好运行 `jetcdctl` 之后，下载一个 [etcd 发行版](https://github.com/coreos/etcd/releases)并在本地启动一个 etcd 服务。（译者注：若以下 “go get” 命令无法正常运行，可以参考[这里的资料](https://github.com/etcd-io/etcd/blob/master/Documentation/dl_build.md)）：

``` plain
# build with “go get github.com/coreos/etcd/cmd/etcd”
$ etcd &
```

接下来，使用 `jetcdctl` 将 `123` 写入 `abc`，与本地 etcd 服务器进行通信：

``` plain
$ java -jar target/jetcdctl.jar put abc 123
21:39:06.126|INFO |CommandPut - OK
```

你可以通过读取 `abc` 来确认写入 etcd 的 put 命令的正确性:

``` plain
$ java -jar target/jetcdctl.jar get abc 21:41:00.265|INFO |CommandGet - abc 21:41:00.267|INFO |CommandGet - 123
```

我们已经通过 get 和 put keys 演示了 jetcd 的基本功能。现在，让我们进一步研究如何在代码中使用 jetcd 吧。

## 更好的 watches（观察）特性

jetcd API 可以方便地管理 etcd 的底层 [gRPC](https://github.com/coreos/etcd/blob/master/Documentation/dev-guide/api_reference_v3.md) 协议。一个例子是 streaming key 事件，其中客户端观察 key，etcd 服务端不断地往客户端发回更新信息。jetcd 客户端管理着一个低级别的 gRPC 流，用来优雅地处理断开连接，并向用户呈现一个无缝的事件流。

如果 jetcd 应用程序希望接收到一个 key 的所有更新，它将使用 [watch](https://github.com/coreos/jetcd/blob/18b235a77aa680039cec170a394b8156fb01d7f0/jetcd-core/src/main/java/com/coreos/jetcd/Watch.java#L46) API 来创建一个 [Watcher](https://github.com/coreos/jetcd/blob/18b235a77aa680039cec170a394b8156fb01d7f0/jetcd-core/src/main/java/com/coreos/jetcd/Watch.java#L51)：

``` java
Watcher watch(ByteSequence key)
```

`Watcher` 的 `listen` 方法从 etcd 中读取 `WatchResponse` 消息。每个 `WatchResponse` 包含被监视 key 上的最新事件序列。如果没有任何事件，则 `listen` 被阻塞，直到有更新为止。`listen` 方法是可靠的；它不会在调用之间删除任何事件，即使在断开连接的情况下：

``` java
WatchResponse listen() throws InterruptedException
```

总之，客户端创建一个 `Watcher`，然后使用 `listen` 来等待事件。下面是在 key `abc` 上进行观察的代码，打印观察到的 key 和 value，直到 `listen` 抛出异常：总之，客户端创建一个 `Watcher`，然后使用 `listen` 来等待事件。下面是观察 key `abc` 的代码，打印 key 和 value，直到 `listen` 抛出异常：


``` java
Client client = Client.builder().endpoints(“http://127.0.0.1:2379).build();
Watcher watcher = client.getWatchClient().watch(ByteSequence.fromString("abc"));
while (true) {
    for (WatchEvent event : watcher.listen().getEvents()) {
        KeyValue kv = event.getKeyValue();
        System.out.println(event.getEventType());
        System.out.println(kv.getKey().toStringUtf8());
        System.out.println(kv.getValue().toStringUtf8());
    }
}
```

将此特性与 Apache 基金会中与 etcd 对标的 [ZooKeeper](https://zookeeper.apache.org/doc/r3.4.10/) 进行比较。从 ZooKeeper 3.4.10 开始，[watch 就已经是一次性触发器](https://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#sc_WatchSemantics)，这意味着一旦收到一个 watch 事件，您必须设置一个新的 watch，以便在将来发生更改时得到通知。要传输密钥事件，可会断必须与集群联系，为每个新事件注册一个新的观察者。

要在 key 更新时连续打印 key 的内容，ZooKeeper 应用程序首先创建一个 [Watcher](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/Watcher.html) 来侦听 `WatchedEvent` 消息。观察程序实现了一个事件回调方法 `process`，当 key 发生更改时就会调用该方法。要在事件中注册兴趣，观察程序需要添加到 [exists](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/ZooKeeper.html#exists%28java.lang.String，%20org.apache.zookeeper.Watcher%29) 方法中，该方法获取 key 的元数据(如果有的话)。当 key 发生变化时，观察者的 `process` 方法就会调用 [getData](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/ZooKeeper.html#getData%28java.lang.String,%20org.apache.zookeeper.Watcher,%20org.apache.zookeeper.AsyncCallback.DataCallback,%20java.lang.Object%29) 来检索 key 的值，然后再次注册相同的观察者来接收未来的更改，如下所示：

``` java
key = “/abc”;
Watcher w = new Watcher() {
  public void process(WatchedEvent event) {
    try {
      System.out.println(event.getType());
      System.out.println(event.getPath());
      if (event.getType() != EventType.NodeDeleted) {
        System.out.println(new String(zk.getData(event.getPath(), false, null)));
      }
      zk.exists(key, this);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
};
zk.exists(key, w);
```

与 jetcd 示例不同，ZooKeeper 代码[不能保证它观察所有更改](https://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#sc_WatchSemantics)，因为在监视程序接收事件和发送请求以获取新监视之间存在延迟。例如，在执行 `process` 和调用 `exists` 以注册新监视程序之间发生了一个事件。由于没有注册任何观察程序，因此该事件永远不会被触发，并且会丢失。

即使假设所有事件都已触发，代码仍然可能破坏事件流。没有 etcd 提供的[多版本并发控制](https://github.com/coreos/etcd/blob/master/Documentation/learning/data_model.md)，就无法访问历史 key。如果 key value 在接收事件和获取数据之间发生了变化，代码将打印出最新的值，而不是与 watch 事件关联的值。更糟的是，事件没有附带修订信息；无法确定 key 是来自事件还是来自 future 返回。

## v0.0.1 版本以及未来计划

从 v0.0.1 开始，jetcd 支持大多数应用程序需要的键值存储。这些原语可以作为复杂模式（如分布式队列、barriers 等）的构建块。在未来，jetcd 将能够使用 etcd 的本地锁和领导人选举 rpc 进行集群范围的标准化分布式协调。

jetcd 设计目的是易于使用，同时还能够利用 etcd 的先进功能。它是开源的，并且正在活跃开发中，欢迎社区的贡献和反馈。我们可以在 GitHub 上找到它，地址是[https://github.com/coreos/jetcd](https://github.com/coreos/jetcd)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
