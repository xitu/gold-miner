> * 原文地址：[Java and etcd: together at last, with jetcd](https://coreos.com/blog/java-and-etcd-together-with-jetcd)
> * 原文作者：[Fanmin Shi](https://coreos.com/blog/java-and-etcd-together-with-jetcd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-and-etcd-together-at-last-with-jetcd.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-and-etcd-together-at-last-with-jetcd.md)
> * 译者：
> * 校对者：

# Java and etcd: together at last, with jetcd

A reliable key-value store gives distributed systems a common substrate for consistent configuration and coordination. One such system is the [etcd](https://github.com/coreos/etcd) project, an open source key-value store created by CoreOS. It is the heart of many [production distributed systems](https://github.com/coreos/etcd/blob/master/Documentation/production-users.md) and is the data store for [Kubernetes](https://kubernetes.io/), among other projects.

Java has proven itself a popular distributed systems language including notable use in the Hadoop ecosystem, the Cassandra datastore, and cloud infrastructure stacks. Further it remains a hugely popular language. Just look at these stats of Java's dominance on [Google trends](https://trends.google.com/trends/explore?cat=32&q=%2Fm%2F07sbkfb,%2Fm%2F09gbxjr,%2Fm%2F06ff5,%2Fm%2F0gdzk,%2Fm%2F02p97):
![](https://coreos.com/sites/default/files/inline-images/google-trends-java.png)
> In terms of Google searches, Java remains more popular than Microsoft .Net and even JavaScript

In face of Java's popularity and its common use inside of distributed systems we thought etcd should also be available as a backend for Java development. Enter jetcd, the new etcd client that brings the etcd v3 API to Java.

With jetcd, Java applications can cleanly interact with etcd using a smart API wrapping etcd’s native [gRPC](https://github.com/coreos/etcd/blob/master/Documentation/dev-guide/api_reference_v3.md) protocol. This API provides expressive distributed features available only on etcd. What's more, by directly supporting more languages, it becomes easier to write new applications for etcd with new usage patterns, helping etcd become more stable and reliable.

## Getting started

You can try out jetcd by building and running a small [example](https://github.com/coreos/jetcd/tree/master/jetcd-examples/jetcd-simple-ctl) program, `jetcdctl`, which uses jetcd to access etcd. The jetcdctl example is also a good starting point for further jetcd projects. To follow along, you'll need to have both Git and Java installed.

First, get the jetcd source by cloning the jetcd repository, then build the `jetcd-simple-ctl` package using the included Maven script:

``` plain
$ git clone https://github.com/coreos/jetcd.git
$ cd jetcd/jetcd-examples/jetcd-simple-ctl
$ ./mvnw clean package
```

Once `jetcdctl` is built and ready to run, download an [etcd release](https://github.com/coreos/etcd/releases) and start a local server:

``` plain
# build with “go get github.com/coreos/etcd/cmd/etcd”
$ etcd &
```

Next, use `jetcdctl` to talk to the local etcd server with jetcd by writing `123` into `abc`:

``` plain
$ java -jar target/jetcdctl.jar put abc 123
21:39:06.126|INFO |CommandPut - OK
```

You can confirm the put command wrote to etcd by reading back `abc`:

``` plain
$ java -jar target/jetcdctl.jar get abc 21:41:00.265|INFO |CommandGet - abc 21:41:00.267|INFO |CommandGet - 123
```

This demonstrates jetcd’s basic functionality by getting and putting keys. Now let's take a closer look at writing code using jetcd.

## Better watches

The jetcd API conveniently manages etcd’s underlying [gRPC](https://github.com/coreos/etcd/blob/master/Documentation/dev-guide/api_reference_v3.md) protocol. One example is streaming key events, where the client watches a key and etcd continuously sends back updates. The jetcd client manages a low level gRPC stream, gracefully handles disconnects, and presents a seamless event stream back to the user.

If a jetcd application wishes to receive all changes to a key, it creates a [Watcher](https://github.com/coreos/jetcd/blob/18b235a77aa680039cec170a394b8156fb01d7f0/jetcd-core/src/main/java/com/coreos/jetcd/Watch.java#L51) using the [watch](https://github.com/coreos/jetcd/blob/18b235a77aa680039cec170a394b8156fb01d7f0/jetcd-core/src/main/java/com/coreos/jetcd/Watch.java#L46) API:

``` java
Watcher watch(ByteSequence key)
```

The `Watcher`’s `listen` method reads `WatchResponse` messages from etcd. Each `WatchResponse` contains the newest sequence of events on the watched key. If there aren’t any events, `listen` blocks until there’s an update. The `listen` method is reliable; it drops no events between calls, even in case of disconnect:

``` java
WatchResponse listen() throws InterruptedException
```

All together, the client creates a `Watcher` then uses `listen` to wait for events. Here’s the code to watch on a key `abc`, printing the key and values until `listen` throws an exception:

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

Contrast this behavior with [ZooKeeper](https://zookeeper.apache.org/doc/r3.4.10/), the Apache Foundation's etcd equivalent. As of ZooKeeper 3.4.10, [watches are one-time triggers](https://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#sc_WatchSemantics), meaning once a watch event is received, you must set a new watch to be notified of future changes. To stream key events, the client must contact the cluster to register a new watcher for each new event.

To continually print a key’s content as it updates, a ZooKeeper application first creates a [Watcher](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/Watcher.html) to listen for `WatchedEvent` messages. The Watcher implements an event callback method `process` that is called when the key changes. To register interest in events, the Watcher attaches to the [exists](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/ZooKeeper.html#exists%28java.lang.String,%20org.apache.zookeeper.Watcher%29) method, which fetches key metadata if there is any. When the key changes, the watcher’s `process` method calls [getData](https://zookeeper.apache.org/doc/r3.4.10/api/org/apache/zookeeper/ZooKeeper.html#getData%28java.lang.String,%20org.apache.zookeeper.Watcher,%20org.apache.zookeeper.AsyncCallback.DataCallback,%20java.lang.Object%29) to retrieve the key’s value, then registers the same Watcher again to receive future changes, as shown below:

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

Unlike the jetcd example, the ZooKeeper code [cannot guarantee that it observes all changes](https://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#sc_WatchSemantics) because there is latency between when the Watcher receives an event and sending a request to get a new watch. For example, an event arrives between executing `process` and calling `exists` to register a new Watcher. Since no Watcher is registered, the event is never delivered and is lost.

Even assuming all events are delivered, the code can still corrupt the event stream. Without [multi-version concurrency control](https://github.com/coreos/etcd/blob/master/Documentation/learning/data_model.md) like etcd offers, there’s no way to access historical keys. If the key value changes between receiving the event and getting the data, the code will print the newest value, not the value associated with the watch event. Worse, events have no attached revision information; there is no way to determine whether the value is from the event or the future.

## Version 0.0.1 and beyond

As of v0.0.1, jetcd supports the primitives most applications need from a key-value store. These primitives can serve as building blocks for sophisticated patterns such as distributed queues, barriers, and more. In the future, jetcd will be able to use etcd’s native lock and leader election RPCs for cluster-wide standardized distributed coordination.

jetcd is designed to be simple to use while taking advantage of etcd’s advanced features under the hood. It is open source and under active development, and contributions and feedback from the community are always welcome. Find it on GitHub at [https://github.com/coreos/jetcd](https://github.com/coreos/jetcd).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
