> * 原文地址：[High-speed inserts with MySQL](https://medium.com/@benmorel/high-speed-inserts-with-mysql-9d3dcd76f723)
> * 原文作者：[Benjamin Morel](https://medium.com/@benmorel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/high-speed-inserts-with-mysql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/high-speed-inserts-with-mysql.md)
> * 译者：
> * 校对者：

# High-speed inserts with MySQL

![Get the dolphin up to speed — Photo by [JIMMY ZHANG](https://unsplash.com/photos/5Xm_LIystCg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6528/1*9Ihf50zErzTg4KR4JnodzA.jpeg)

When you need to bulk-insert many million records in a MySQL database, you soon realize that sending `INSERT` statements one by one is not a viable solution.

The MySQL documentation has some [INSERT optimization tips](https://dev.mysql.com/doc/refman/5.7/en/insert-optimization.html) that are worth reading to start with.

I will try to summarize here the two main techniques to efficiently load data into a MySQL database.

## LOAD DATA INFILE

If you’re looking for raw performance, this is indubitably your solution of choice. `LOAD DATA INFILE` is a highly optimized, MySQL-specific statement that directly inserts data into a table from a CSV / TSV file.

There are two ways to use `LOAD DATA INFILE`. You can copy the data file to the server's data directory (typically `/var/lib/mysql-files/`) and run:

```sql
LOAD DATA INFILE '/path/to/products.csv' INTO TABLE products;
```

This is quite cumbersome as it requires you to have access to the server’s filesystem, set the proper permissions, etc.

The good news is, you can also store the data file **on the client side**, and use the `LOCAL` keyword:

```sql
LOAD DATA LOCAL INFILE '/path/to/products.csv' INTO TABLE products;
```

In this case, the file is read from the client’s filesystem, transparently copied to the server’s temp directory, and imported from there. All in all, **it’s almost as fast as loading from the server’s filesystem directly**. You do need to ensure that this [option](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_local_infile) is enabled on your server, though.

There are many options to `LOAD DATA INFILE`, mostly related to how your data file is structured (field delimiter, enclosure, etc.). Have a look at the [documentation](https://dev.mysql.com/doc/refman/5.7/en/load-data.html) to see them all.

While `LOAD DATA INFILE` is your best option performance-wise, it requires you to have your data ready as delimiter-separated text files. If you don’t have such files, you’ll need to spend additional resources to create them, and will likely add a level of complexity to your application. Fortunately, there’s an alternative.

## Extended inserts

A typical SQL `INSERT` statement looks like:

```sql
INSERT INTO user (id, name) VALUES (1, 'Ben');
```

An extended `INSERT` groups several records into a single query:

```sql
INSERT INTO user (id, name) VALUES (1, 'Ben'), (2, 'Bob');
```

The key here is to find the optimal number of inserts per query to send. There is no one-size-fits-all number, so you need to benchmark a sample of your data to find out the value that yields the maximum performance, or the best tradeoff in terms of memory usage / performance.

To get the most out of extended inserts, it is also advised to:

* use prepared statements
* run the statements in a transaction

## The benchmark

I’m inserting 1.2 million rows, 6 columns of mixed types, ~26 bytes per row on average. I tested two common configurations:

* Client and server on the same machine, communicating through a UNIX socket
* Client and server on separate machines, on a very low latency (\< 0.1 ms) Gigabit network

As a basis for comparison, I copied the table using `INSERT … SELECT`, yielding a performance of **313,000 inserts / second**.

#### LOAD DATA INFILE

To my surprise, `LOAD DATA INFILE` proves **faster** than a table copy:

* `LOAD DATA INFILE`: **377,000** inserts / second
* `LOAD DATA LOCAL INFILE` over the network: **322,000** inserts / second

The difference between the two numbers seems to be directly related to the time it takes to transfer the data from the client to the server: the data file is 53 MiB in size, and the timing difference between the 2 benchmarks is 543 ms, which would represent a transfer speed of 780 mbps, close to the Gigabit speed.

This means that, in all likelihood, **the MySQL server does not start processing the file until it is fully transferred**: your insert speed is therefore directly related to the bandwidth between the client and the server, which is important to take into account if they are not located on the same machine.

#### Extended inserts

I measured the insert speed using `BulkInserter`, a PHP class part of [an open-source library](https://github.com/brick/db) that I wrote, with up to 10,000 inserts per query:

![](https://cdn-images-1.medium.com/max/2000/1*k_QS1qtgN5-UyrDkjSRg_w.png)

As we can see, the insert speed raises quickly as the number of inserts per query increases. We got a 6× increase in performance on localhost and a 17× increase over the network, compared to the sequential `INSERT` speed:

* 40,000 → 247,000 inserts / second on localhost
* 12,000 → 201,000 inserts / second over the network

It takes around 1,000 inserts per query to reach the maximum throughput in both cases, but **40 inserts per query are enough to achieve 90% of this throughput** on localhost, which could be a good tradeoff here. It’s also important to note that **after a peak, the performance actually decreases** as you throw in more inserts per query.

The benefit of extended inserts is higher over the network, because sequential insert speed becomes a function of your latency:

```sql
max sequential inserts per second ~= 1000 / ping in milliseconds
```

The higher the latency between the client and the server, the more you’ll benefit from using extended inserts.

## Conclusion

As expected, **`LOAD DATA INFILE` is the preferred solution when looking for raw performance on a single connection**. It requires you to prepare a properly formatted file, so if you have to generate this file first, and/or transfer it to the database server, be sure to take that into account when measuring insert speed.

Extended inserts on the other hand, do not require a temporary text file, and can give you around 65% of the `LOAD DATA INFILE` throughput, which is a very reasonable insert speed. It’s interesting to note that it doesn’t matter whether you’re on localhost or over the network, **grouping several inserts in a single query always yields better performance**.

If you decide to go with extended inserts, be sure to **test your environment with a sample of your real-life data** and a few different inserts-per-query configurations before deciding upon which value works best for you.

Be careful when increasing the number of inserts per query, as it may require you to:

* allocate more memory on the client side
* increase the [max_allowed_packet](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_allowed_packet) setting on the MySQL server

As a final note, it’s worth mentioning that according to Percona, you can achieve even better performance using concurrent connections, partitioning, and multiple buffer pools. See [this post on their blog](http://www.percona.com/blog/2011/01/07/high-rate-insertion-with-mysql-and-innodb/) for more information.

**The benchmarks have been run on a bare metal server running Centos 7 and MySQL 5.7, Xeon E3 @ 3.8 GHz, 32 GB RAM and NVMe SSD drives. The MySQL benchmark table uses the InnoDB storage engine.**

**The benchmark source code can be found in [this gist](https://gist.github.com/BenMorel/78f742356391d41c91d1d733f47dcb13). The benchmark result graph is available on [plot.ly](https://plot.ly/~BenMorel/52).**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
