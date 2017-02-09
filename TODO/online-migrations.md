> * 原文地址：[Online migrations at scale](https://stripe.com/blog/online-migrations)
* 原文作者：[Jacqueline Xu](https://stripe.com/about#jacqueline)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Engineering teams face a common challenge when building software: they eventually need to redesign the data models they use to support clean abstractions and more complex features. In production environments, this might mean migrating millions of active objects and refactoring thousands of lines of code.

Stripe users expect availability and consistency from our API. This means that when we do migrations, we need to be extra careful: objects stored in our systems need to have accurate values, and Stripe’s services need to remain available at all times.

In this post, we’ll explain how we safely did one large migration of our hundreds of millions of Subscriptions objects.

---

## Why are migrations hard?

-
### Scale

Stripe has hundreds of millions of Subscriptions objects. Running a large migration that touches all of those objects is a lot of work for our production database.

Imagine that it takes one second to migrate each subscription object: in sequential fashion, it would take over three years to migrate one hundred million objects.

-
### Uptime

Businesses are constantly transacting on Stripe. We perform all infrastructure upgrades online, rather than relying on planned maintenance windows. Because we couldn’t simply pause the Subscriptions service during migrations, we had to execute the transition with all of our services operating at 100%.

-
### Accuracy

Our Subscriptions table is used in many different places in our codebase. If we tried to change thousands of lines of code across the Subscriptions service at once, we would almost certainly overlook some edge cases. We needed to be sure that every service could continue to rely on accurate data.

## A pattern for online migrations

Moving millions of objects from one database table to another is difficult, but it’s something that many companies need to do.

There’s a common 4 step *dual writing pattern* that people often use to do large online migrations like this. Here’s how it works:

1. **Dual writing** to the existing and new tables to keep them in sync.
2. **Changing all read paths** in our codebase to read from the new table.
3. **Changing all write paths** in our codebase to only write to the new table.
4. **Removing old data** that relies on the outdated data model.

---

## Our example migration: Subscriptions

What are Subscriptions and why did we need to do a migration?

[Stripe Subscriptions](https://stripe.com/subscriptions) helps users like [DigitalOcean](https://www.digitalocean.com/) and [Squarespace](https://www.squarespace.com/) build and manage recurring billing for their customers. Over the past few years, we’ve steadily added features to support their more complex billing models, such as multiple subscriptions, trials, coupons, and invoices.

In the early days, each Customer object had, at most, one subscription. Our customers were stored as individual records. Since the mapping of customers to subscriptions was straightforward, subscriptions were stored alongside customers.

    class Customer
      Subscription subscription
    end

Eventually, we realized that some users wanted to create customers with multiple subscriptions. We decided to transform the `subscription` field (for a single subscription) to a `subscriptions` field—allowing us to store an array of multiple active subscriptions.

    class Customer
      array: Subscription subscriptions
    end

As we added new features, this data model became problematic. Any changes to a customer’s subscriptions meant updating the entire Customer record, and subscriptions-related queries scanning through customer objects. So we decided to store active subscriptions separately.

Our redesigned data model moves subscriptions into their own table.

As a reminder, our four migration phases were:

1. **Dual writing** to the existing and new tables to keep them in sync.
2. **Changing all read paths** in our codebase to read from the new table.
3. **Changing all write paths** in our codebase to only write to the new table.
4. **Removing old data** that relies on the outdated data model.

Let’s walk through these four phases looked like for us in practice.

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
