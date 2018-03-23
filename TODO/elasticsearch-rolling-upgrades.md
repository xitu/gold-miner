> * 原文地址：[Rolling upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/rolling-upgrades.html)
> * 原文作者：[elastic.](https://www.elastic.co/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rolling-upgrades.md](https://github.com/xitu/gold-miner/blob/master/TODO/elasticsearch-rolling-upgrades.md)
> * 译者：[code4j](https://github.com/rpgmakervx)
> * 校对者：[Xekin-FE](https://github.com/Xekin-FE), [ClarenceC](https://github.com/ClarenceC)

# Elasticsearch 滚动升级

滚动升级允许 Elasticsearch 集群在业务不中断的情况下更新一个节点。集群中不支持同时运行多个版本，因为分片不会从新版本分配到旧版本的节点上。

从这个列表[table](setup-upgrade.html "Upgrading")中检查当前版本的ES是否支持滚动升级。

滚动升级步骤如下：

## 第一步: 滚动升级步骤如下：

当你关闭一个节点之后，分片分配进程会尝试立即将分片从当前节点复制到集群上的其他节点，导致浪费了大量的 I/O 操作。要想避免这个问题可以通过在关闭节点前禁用这个进程

```
PUT /_cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
```

## 第二步：停止不必要的索引，并执行同步刷新（这一步可选）

你可以在升级期间愉快的进行索引操作，当然，如果你使用如下命令，停止不必要的索引，并执行同步刷新[synced-flush](indices-synced-flush.html "Synced Flush")请求，分片恢复速度会更快：

```
POST /_flush/synced
```

同步刷新是锦上添花的操作。如果出现索引挂起的现象操作就会失败，为了安全起见有必要多试几次。

## 第三步：单个节点停机并升级

**升级前**关闭一个节点。

> 注意：当使用 zip 或 tar 包升级，默认情况下 Elasticsearch home 目录下的 config，data，log，plugins 等目录都会被覆盖。
最好解压到不同的目录，这样升级期间就不会删除原来的目录了。自定义的目录可以通过 path.conf 和 path.data 来[设置](setup-configuration.html#paths "Pathsedit")。
 RPM 或 DEB 包会把目录放到 [合适的位置](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/setup-dir-layout.html "Directory Layout")

使用 [rpm/deb](setup-repositories.html "Repositories") ) 安装包升级：

*  使用 `rpm` 或 `dpkg` 安装新包，所有的目录都会被放到合理的位置，配置文件不会被覆盖。

使用zip或tar包解压安装：

*   解压安装包，确保不要覆盖 `config` 和 `data` 目录。
*   从旧的安装目录拷贝 `conf` 目录到新安装目录，或者使用 `--path.conf` 选项到外部的config目录
*   从旧的安装目录拷贝 `data` 目录到新的安装目录，或修改 `config/elasticsearch.yml` 中的 `path.data` 设置 data 目录为原来的目录。

## 第四步：启动升级过的节点

启动升级后的节点并确认加入到集群中，可以通过日志或下面的命令来确认：

```
GET _cat/nodes
```

## 第五步：重新打开分片再平衡

一旦节点重新加入集群，解禁分片分配进程再平衡：

```
PUT /_cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "all"
  }
}
```

### 第六步：等待节点恢复正常

等待集群分片平衡结束后，再升级下一个节点。这一过程可以使用[`_cat/health`](cat-health.html "cat health")命令检查：

```
GET _cat/health
```

等到 `status` 这一列由 `yellow` 变成 `green`，Green 表示主分片和副本都分配完了。

> 重点：滚动升级过程中，高版本上的主分片不会把副本分配到低版本的节点，因为高版本的数据格式老版本不认。
>  如果高版本的主分片没法分配副本，换句话说如果集群中只剩下了一个高版本节点，那么节点就保持未分配的状态，集群健康会保持 `yellow`。
> 这种情况下，检查下有没有初始化或分片分配在执行。
> 一旦另一个节点升级结束后，分片将会被分配，然后集群状态会恢复到 `green` 。

没有使用[同步刷新](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/indices-synced-flush.html "Synced Flush")的分片恢复时间会慢一点。分片的状态可以通过[`_cat/recovery`](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/cat-recovery.html "cat recovery")请求监控：

```
GET _cat/recovery
```

如果你在这之前停止索引操作，那么在节点恢复完成之后重启也是安全的。

### 第七步：重复上述步骤

当集群稳定并且节点恢复后，对剩下的节点重复上述过程。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
