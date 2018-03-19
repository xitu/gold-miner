> * 原文地址：[Rolling upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/rolling-upgrades.html)
> * 原文作者：[elastic.](https://www.elastic.co/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rolling-upgrades.md](https://github.com/xitu/gold-miner/blob/master/TODO/rolling-upgrades.md)
> * 译者：
> * 校对者：

# Rolling upgrades

A rolling upgrade allows the Elasticsearch cluster to be upgraded one node at a time, with no downtime for end users. Running multiple versions of Elasticsearch in the same cluster for any length of time beyond that required for an upgrade is not supported, as shards will not be replicated from the more recent version to the older version.

Consult this [table](setup-upgrade.html "Upgrading") to verify that rolling upgrades are supported for your version of Elasticsearch.

To perform a rolling upgrade:



## Step 1: Disable shard allocation

When you shut down a node, the allocation process will immediately try to replicate the shards that were on that node to other nodes in the cluster, causing a lot of wasted I/O. This can be avoided by disabling allocation before shutting down a node:

```
PUT /_cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
```

## Step 2: Stop non-essential indexing and perform a synced flush (Optional)

You may happily continue indexing during the upgrade. However, shard recovery will be much faster if you temporarily stop non-essential indexing and issue a [synced-flush](indices-synced-flush.html "Synced Flush") request:

```
POST /_flush/synced
```

A synced flush request is a “best effort” operation. It will fail if there are any pending indexing operations, but it is safe to reissue the request multiple times if necessary.

## Step 3: Stop and upgrade a single node

Shut down one of the nodes in the cluster **before** starting the upgrade.

![Tip](images/icons/tip.png)

When using the zip or tarball packages, the `config`, `data`, `logs` and `plugins` directories are placed within the Elasticsearch home directory by default.

It is a good idea to place these directories in a different location so that there is no chance of deleting them when upgrading Elasticsearch. These custom paths can be [configured](setup-configuration.html#paths "Pathsedit") with the `path.conf` and `path.data` settings.

The Debian and RPM packages place these directories in the [appropriate place](setup-dir-layout.html "Directory Layout") for each operating system.

To upgrade using a [Debian or RPM](setup-repositories.html "Repositories") package:

*   Use `rpm` or `dpkg` to install the new package. All files should be placed in their proper locations, and config files should not be overwritten.

To upgrade using a zip or compressed tarball:

*   Extract the zip or tarball to a new directory, to be sure that you don’t overwrite the `config` or `data` directories.
*   Either copy the files in the `config` directory from your old installation to your new installation, or use the `--path.conf` option on the command line to point to an external config directory.
*   Either copy the files in the `data` directory from your old installation to your new installation, or configure the location of the data directory in the `config/elasticsearch.yml` file, with the `path.data` setting.

## Step 4: Start the upgraded node

Start the now upgraded node and confirm that it joins the cluster by checking the log file or by checking the output of this request:

```
GET _cat/nodes
```

## Step 5: Reenable shard allocation

Once the node has joined the cluster, reenable shard allocation to start using the node:

```
PUT /_cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "all"
  }
}
```

### Step 6: Wait for the node to recover

You should wait for the cluster to finish shard allocation before upgrading the next node. You can check on progress with the [`_cat/health`](cat-health.html "cat health") request:

```
GET _cat/health
```

Wait for the `status` column to move from `yellow` to `green`. Status `green` means that all primary and replica shards have been allocated.

![Important](images/icons/important.png)

During a rolling upgrade, primary shards assigned to a node with the higher version will never have their replicas assigned to a node with the lower version, because the newer version may have a different data format which is not understood by the older version.

If it is not possible to assign the replica shards to another node with the higher version — e.g. if there is only one node with the higher version in the cluster — then the replica shards will remain unassigned and the cluster health will remain status `yellow`.

In this case, check that there are no initializing or relocating shards (the `init` and `relo` columns) before proceding.

As soon as another node is upgraded, the replicas should be assigned and the cluster health will reach status `green`.

Shards that have not been [sync-flushed](indices-synced-flush.html "Synced Flush") may take some time to recover. The recovery status of individual shards can be monitored with the [`_cat/recovery`](cat-recovery.html "cat recovery") request:

```
GET _cat/recovery
```

If you stopped indexing, then it is safe to resume indexing as soon as recovery has completed.

### Step 7: Repeat

When the cluster is stable and the node has recovered, repeat the above steps for all remaining nodes.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
