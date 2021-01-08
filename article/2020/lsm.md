> * 原文地址：[Understanding LSM Trees: What Powers Write-Heavy Databases](https://yetanotherdevblog.com/lsm/)
> * 原文作者：[Braden Groom](https://yetanotherdevblog.com/author/author/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/lsm.md](https://github.com/xitu/gold-miner/blob/master/article/2020/lsm.md)
> * 译者：
> * 校对者：

# Understanding LSM Trees: What Powers Write-Heavy Databases

A **log-structured merge-tree (LSM tree)** is a data structure typically used when dealing with write-heavy workloads. The write path is optimized by only performing sequential writes. LSM trees are the core data structure behind many databases, including [BigTable](https://cloud.google.com/bigtable), [Cassandra](https://cassandra.apache.org/), [Scylla](https://www.scylladb.com/), and [RocksDB](https://rocksdb.org/).

# SSTables

LSM trees are persisted to disk using a **Sorted Strings Table (SSTable)** format. As indicated by the name, SSTables are a format for storing key-value pairs in which the keys are in sorted order. An SSTable will consist of multiple sorted files called **segments**. These segments are immutable once they are written to disk. A simple example could look like this:

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--3-.png)

You can see that the key-value pairs within each segment are sorted by the key. We'll discuss what exactly a segment is and how it gets generated in the next section.

# Writing Data

Recall that LSM trees only perform sequential writes. You may be wondering how we sequentially write our data in a sorted format when values may be written in any order. This is solved by using an in-memory tree structure. This is frequently referred to as a **memtable**, but the underlying data structure is generally some form of a sorted tree like a [red-black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree). As writes come in, the data is added to this red-black tree.

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--4-.png)

Our writes get stored in this red-black tree until the tree reaches a predefined size. Once the red-black tree has enough entries, it is flushed to disk as a segment on disk in sorted order. This allows us to write the segment file as a single sequential write even though the inserts may occur in any order.

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--5-.png)

# Reading Data

So how do we find a value in our SSTable? A naive approach would be to scan the segments for the desired key. We would start with the newest segment and work our way back to the oldest segment until we find the key that we're looking for. This would mean that we are able to retrieve keys that were recently written more quickly. A simple optimization is to keep an in-memory [sparse index](https://yetanotherdevblog.com/dense-vs-sparse-index/).

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--6-.png)

We can use this index to quickly find the offsets for values that would come before and after the key we want. Now we only have to scan a small portion of each segment file based on those bounds. For example, let's consider a scenario where we want to look up the key `dollar` in the segment above. We can perform a binary search on our sparse index to find that `dollar` comes between `dog` and `downgrade`. Now we only need to scan from offset 17208 to 19504 in order to find the value (or determine it is missing).

This is a nice improvement, but what about looking up records that do not exist? We will still end up looping over all segment files and fail to find the key in each segment. This is something that a [bloom filter](https://yetanotherdevblog.com/bloom-filters/) can help us out with. A bloom filter is a space-efficient data structure that can tell us if a value is missing from our data. We can add entries to a bloom filter as they are written and check it at the beginning of reads in order to efficiently respond to requests for missing data.

# Compaction

Over time, this system will accumulate more segment files as it continues to run. These segment files need to be cleaned up and maintained in order to prevent the number of segment files from getting out of hand. This is the responsibility of a process called compaction. Compaction is a background process that is continuously combining old segments together into newer segments.

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--7-.png)

You can see in the example above that segments 1 and 2 both have a value for the key `dog`. Newer segments contain the latest values written, so the value from segment 2 is what gets carried forward into the segment 4. Once the compaction process has written a new segment for the input segments, the old segment files are deleted.

# Deleting Data

We've covered reading and writing data, but what about deleting data? How do you delete data from the SSTable when the segment files are considered immutable? Deletes  actually follow the exact same path as writing data.  Whenever a delete request is received, a unique marker called a **tombstone** is written for that key.

![](https://yetanotherdevblog.com/content/images/2020/06/output-onlinepngtools--8-.png)

The example above shows that the key `dog` had the value 52 at some point in the past, but now it has a tombstone marker. This indicates that if we receive a request for the key `dog` then we should return a response indicating that the key does not exist. This means that delete requests actually take up disk space initially which many developers may find surprising. Eventually, tombstones will get compacted away so that the value no longer exists on disk.

# Conclusion

We now understand how a basic LSM tree storage engine works:

1. Writes are stored in an in-memory tree (also known as a memtable). Any supporting data structures (bloom filters and sparse index) are also updated if necessary.
2. When this tree becomes too large it is flushed to disk with the keys in sorted order.
3. When a read comes in we check the bloom filter. If the bloom filter indicates that the value is not present then we tell the client that the key could not be found. If the bloom filter indicates that the value is present then we begin iterating over our segment files from newest to oldest.
4. For each segment file, we check a sparse index and scan the offsets where we expect the key to be found until we find the key. We'll return the value as soon as we find it in a segment file.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
