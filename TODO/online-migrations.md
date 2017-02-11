> * 原文地址：[Online migrations at scale](https://stripe.com/blog/online-migrations)
* 原文作者：[Jacqueline Xu](https://stripe.com/about#jacqueline)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[steinliber](https://github.com/steinliber)
* 校对者：

工程师团队在构建软件时会面临一个普遍的挑战：为了支持整洁的抽象和更加复杂的特性，他们通常需要重新设计所使用的数据模型。在生产环境中，这或许就意味着迁移百万级的活跃对象和重构数千行的代码。

Strip 的用户期望我们的接口是可用并且一致的。这就意味着当我们在做迁移的时候，我们需要格外的小心：储存在我们系统的对象需要又精确的值，而且 Strip 的服务需要在任何时候都保持可用性。

在这篇文章中，我们将会说明我们是如何在数以百万的订阅对象进行安全的大规模迁移。

---

## 为什么迁移时困难的?

-
### 规模

Strip 有数亿的订阅对象。运行一次涉及所有这些对象的大规模迁移对于我们的生产数据库来说意味着大量的工作。

想象如果每个对象的迁移都要耗费1秒钟：以这个线性增长的方式计算，迁移数亿的对象要花掉超过三年的时间。

-
### 上线时间

商家在 Strip 上持续不断的进行交易。我们在线上进行所有的基础设施升级，而不是依赖于计划中的维护期。因为我们在迁移过程中不能只是简单的暂停订阅，我们必须保证所有交易的执行都可以在我们的所有服务器上 100% 执行。

-
### 精确性

我们的订阅表在代码库的许多不同地方都会用到。如果我们想一次性在订阅服务中修改上千行的代码，我们几乎可以确信会忽略一些边缘条件。我们需要确保每一个服务可以继续依靠精确的数据。

## 在线迁移的一个模式

从一个数据库表迁移数百万的对象到另一个是困难的，但是这是许多公司所要做的一些事。

这里有一个通用的 4 步*双重写入模式*，人们经常使用像这样的模式来做线上的大规模迁移。这里是它如何工作的

1. **双重写入** 到已经存在和新的数据库来保持它们同步。
2. **修改所有代码库里的读路径** 从新的表读数据。
3. **修改所有代码库里的写路径** 只写入新的表.
4. **移除依赖于过期数据模型的旧数据** 。

---

## 我们迁移的例子: 订阅

什么是订阅已经我们为什么需要做迁移？

[Stripe 订阅](https://stripe.com/subscriptions) 帮助像 [DigitalOcean](https://www.digitalocean.com/) 和 [Squarespace](https://www.squarespace.com/) 的用户建立和管理它们消费者的定期结算，在这过去的几年中，我们已经添加了许多特性去支持它们越来越复杂的账单模型，比如说多方订阅，试用，优惠券和发票。

在早些时候，每个消费者对象最多可以有一个订阅。我们的消费者当作独立的记录储存。因为消费者和订阅的映射是直接的，订阅是和消费者一起储存的。

    class Customer
      Subscription subscription
    end

最终，我们意识到有些用户想要创建有多个订阅表的消费者。我们决定把 `subscription` 字段（只支持一个订阅）转换成`subscriptions`字段，这样我们就可以储存一个有多个活跃订阅的队列。

    class Customer
      array: Subscription subscriptions
    end

在我们添加新特性的时候,发现这个数据模型会有问题。任何对消费者订阅的改变都意味着更新整个消费者模型，而且和订阅相关的查询也会在消费者对象中查询。所以我们独立储存活跃的订阅。

我们重新设计了数据模型把订阅移到课他们自己的表中。

提醒一下⏰，我们的 4 个迁移阶段是

1. **双重写入** 到已经存在和新的数据库来保持它们同步。
2. **修改所有代码库里的读路径** 从新的表读数据。
3. **修改所有代码库里的写路径** 只写入新的表.
4. **移除依赖于过期数据模型的旧数据**。

让我们像实践中一样走过这4个阶段。

---

## Part 1: Dual writing

We begin the migration by creating a new database table. The first step is to start duplicating new information so that it’s written to both stores. We’ll then backfill missing data to the new store so the two stores hold identical information.

All new writes should update both stores.

In our case, we record all newly-created subscriptions into both the Customers table and the Subscriptions table. Before we begin dual writing to both tables, it’s worth considering the potential performance impact of this additional write on our production database. We can mitigate performance concerns by slowly ramping up the percentage of objects that get duplicated, while keeping a careful eye on operational metrics.

At this point, newly created objects exist in both tables, while older objects are only found in the old table. We’ll start copying over existing subscriptions in a lazy fashion: whenever objects are updated, they will automatically be copied over to the new table. This approach lets us begin to incrementally transfer our existing subscriptions.

Finally, we’ll backfill any remaining Customer subscriptions into the new Subscriptions table.

We need to backfill existing subscriptions to the new Subscriptions table.

The most expensive part of backfilling the new table on the live database is simply finding all the objects that need migration. Finding all the objects by querying the database would require many queries to the production database, which would take a lot of time. Luckily, we were able to offload this to an offline process that had no impact on our production databases. We make snapshots of our databases available to our Hadoop cluster, which lets us use [MapReduce](https://en.wikipedia.org/wiki/MapReduce) to quickly process our data in a offline, distributed fashion.

We use [Scalding](https://github.com/twitter/scalding) to manage our MapReduce jobs. Scalding is a useful library written in Scala that makes it easy to write MapReduce jobs (you can write a simple one in 10 lines of code). In this case, we’ll use Scalding to help us identify all subscriptions. We’ll follow these steps:

- Write a Scalding job that provides a list of all subscription IDs that need to be copied over.
- Run a large, multi-threaded migration to duplicate these subscriptions with a fleet of processes efficiently operating on our data in parallel.
- Once the migration is complete, run the Scalding job once again to make sure there are no existing subscriptions missing from the Subscriptions table.

---

## Part 2: Changing all read paths

Now that the old and new data stores are in sync, the next step is to begin using the new data store to read all our data.

For now, all reads use the existing Customers table: we need to move to the Subscriptions table.

We need to be sure that it’s safe to read from the new Subscriptions table: our subscription data needs to be consistent. We’ll use GitHub’s [Scientist](https://github.com/github/scientist) to help us verify our read paths. Scientist is a Ruby library that allows you to run experiments and compare the results of two different code paths, alerting you if two expressions ever yield different results in production. With Scientist, we can generate alerts and metrics for differing results in real time. When an experimental code path generates an error, the rest of our application won’t be affected.

We’ll run the following experiment:

- Use Scientist to read from both the Subscriptions table and the Customers table.
- If the results don’t match, raise an error alerting our engineers to the inconsistency.

GitHub’s Scientist lets us run experiments that read from both tables and compare the results.

After we verified that everything matched up, we started reading from the new table.

Our experiments are successful: all reads now use the new Subscriptions table.

---

## Part 3: Changing all write paths

Next, we need to update write paths to use our new Subscriptions store. Our goal is to incrementally roll out these changes, so we’ll need to employ careful tactics.

Up until now, we’ve been writing data to the old store and then copying them to the new store:

We now want to reverse the order: write data to the new store and then archive it in the old store. By keeping these two stores consistent with each other, we can make incremental updates and observe each change carefully.

Refactoring all code paths where we mutate subscriptions is arguably the most challenging part of the migration. Stripe’s logic for handling subscriptions operations (e.g. updates, prorations, renewals) spans thousands of lines of code across multiple services.

The key to a successful refactor will be our incremental process: we’ll isolate as many code paths into the smallest unit possible so we can apply each change carefully. Our two tables need to stay consistent with each other at every step.

For each code path, we’ll need to use a holistic approach to ensure our changes are safe. We can’t just substitute new records with old records: every piece of logic needs to be considered carefully. If we miss any cases, we might end up with data inconsistency. Thankfully, we can run more Scientist experiments to alert us to any potential inconsistencies along the way.

Our new, simplified write path looks like this:

We can make sure that no code blocks continue using the outdated `subscriptions` array by raising an error if the property is called:

    class Customer
      def subscriptions
        hard_assertion_failed("Accessing subscriptions array on customer")
      endend

---

## Part 4: Removing old data

Our final (and most satisfying) step is to remove code that writes to the old store and eventually delete it.

Once we’ve determined that no more code relies on the `subscriptions` field of the outdated data model, we no longer need to write to the old table:

With this change, our code no longer uses the old store, and the new table now becomes our source of truth.

We can now remove the `subscriptions` array on all of our Customer objects, and we’ll incrementally process deletions in a lazy fashion. We first automatically empty the array every time a subscription is loaded, and then run a final Scalding job and migration to find any remaining objects for deletion. We end up with the desired data model:

---

## Conclusion

Running migrations while keeping the Stripe API consistent is complicated. Here’s what helped us run this migration safely:

- We laid out a four phase migration strategy that would allow us to transition data stores while operating our services in production without any downtime.
- We processed data offline with Hadoop, allowing us to manage high data volumes in a parallelized fashion with MapReduce, rather than relying on expensive queries on production databases.
- All the changes we made were incremental. We never attempted to change more than a few hundred lines of code at one time.
- All our changes were highly transparent and observable. Scientist experiments alerted us as soon as a single piece of data was inconsistent in production. At each step of the way, we gained confidence in our safe migration.

We’ve found this approach effective in the many online migrations we’ve executed at Stripe. We hope these practices prove useful for other teams performing migrations at scale.


