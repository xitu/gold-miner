> * 原文地址：[UUID or GUID as Primary Keys? Be Careful!](https://tomharrisonjr.com/uuid-or-guid-as-primary-keys-be-careful-7b2aa3dcb439)
> * 原文作者：[Tom Harrison Jr](https://tomharrisonjr.com/@tomharrisonjr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：
---

# UUID or GUID as Primary Keys? Be Careful!

![](https://cdn-images-1.medium.com/max/800/1*eOxYCicU2O_DHk5CWJS9TQ.png)

Nothing says “User friendly” like GUID!

I just read a post on ways to scale your database that hit home with me — the author suggests the use of UUIDs (similar to GUIDs) as the primary key (PK) of database tables.

### Reasons UUIDs are Good

There are several reasons using a UUID as a PK would be great compared to auto-incrementing integers:

1. At scale, when you have multiple databases containing a segment (shard) of your data, for example a set of customers, using a UUID means that one ID is unique across *all* databases, not just the one you’re in now. This makes moving data across databases safe. Or in my case where all of our database shards are merged onto our Hadoop cluster as one, no key conflicts.
2. You can know your PK before insertion, which avoids a round trip DB hit, and simplifies transactional logic in which you need to know the PK before inserting child records using that key as it’s foreign key (FK)
3. UUIDs do not reveal information about your data, so would be safer to use in a URL, for example. If I am customer 12345678, it’s easy to guess that there are customers 12345677 and 1234569, and this makes for an attack vector. (But see below for a better alternative).

### Reasons UUIDs May Not be Good

#### Don’t be naive

A naive use of a UUID, which might look like `70E2E8DE-500E-4630-B3CB-166131D35C21`, would be to treat as a string, e.g. `varchar(36)` — don’t do that!!

“Oh, pshaw”, you say, “no one would ever do such a thing.”

Think twice — in two cases of very large databases I have inherited at relatively large companies, this was *exactly* the implementation. Aside from the 9x cost in size (36 vs. 4 bytes for an int), strings don’t sort as fast as numbers because they rely on collation rules.

Things got really bad in one company where they had originally decided to use Latin-1 character set. When we converted to UTF-8 several of the compound-key indexes were not big enough to contain the larger strings. Doh!

#### UUIDs are a pain

Don’t underestimate how annoying it is to have to deal with values that are too big to remember or verbalize.

#### Planning for real scaling

If our goal is to scale, and I mean *really scale* let’s first acknowledge that an `int` is not big enough in many cases, maxing out at around 2 billion, which needs 4 bytes. We have way more than 2 billion transactions in each of several databases.

So `bigint` is needed in some cases and that uses 8 bytes. Meanwhile, using one of several strategies, databases like PostgreSQL and SQL Server have a native type that is stored in 16 bytes.

So who cares if it’s twice as large as `bigint` or four times bigger than `int`? It’s just a few bytes, right?

#### Primary keys get around in normalized databases

If you have a well normalized database, as we do at my current company, each use of the key as an FK starts adding up.

Not just on disk but during joins and sorts these keys need to live in memory. Memory is getting cheaper, but whether disk or RAM, it’s limited. And neither is free.

Our database has plenty of intermediate tables that are mainly containers for the foreign keys of others, especially in 1-to-many relations. Accounts have multiple card numbers, addresses, phone numbers, usernames, and all that. For each of these columns in a set of table with billions of accounts, the extra size of foreign keys adds up fast.

#### It’s really hard to sort random numbers

Another problem is fragmentation — because UUIDs are random, they have no natural ordering so cannot be used for clustering. This is why SQL Server has implemented a `newsequentialid()` function that is suitable for use in clustered indexes, and is [probably the right implementation](https://msdn.microsoft.com/en-us/library/ms189786.aspx) for all UUID PKs. It is probable that there are similar solutions for other databases, certainly PostgreSQL, MySQL and likely the rest.

### Primary keys should never be exposed, even UUIDs

A primary key is, by definition unique within its scope. It is, therefore, an obvious thing to use as a customer number, or in a URL to identify a unique page or row.

Don’t!

I would argue that *using a PK in any public context is a bad idea.*

The original issue with simple auto-incrementing values is that they are easily guessable as I noted above. Botnets will just keep guessing until they find one. (And they may keep guessing if you use UUIDs, but the chance of a correct guess is astronomically lower).

Arguably it would be a fool’s errand to try to guess a UUID, however [Microsoft warns against](https://msdn.microsoft.com/en-us/library/ms189786.aspx) using `newsequentialid()` because by mitigating the clustering issue, it makes the key more guessable.

#### My keys will never change (until they do)

But there’s a far more compelling reason not to use any kind of PK in a public context: if you *ever* need to change keys, all your external references are broken. Think “404 Page Not Found”.

When would you need to change keys? As it happens, we’re doing a data migration this week, because who knew in 2003 when the company started that we would now have 13 massive SQL Server databases and growing fast?

Never say “never”. I have been there and done that, and it has happened several times just for me. It’s easy to manage up front. It’s way harder to fix when you’re counting things in the trillions.

Indeed, my current company’s context is a perfect example of why UUIDs are needed, and why they are costly, and why exposing primary keys is an issue.

#### My internal system is external

I manage the Hadoop infrastructure that receives data nightly from all of our databases. The Hadoop system is linked (bound) to our SQL Server databases, which is fine — we’re in the same company.

Still, in order to disambiguate colliding sequence keys from our multiple databases, we generate a pseudo-primary-key by concatenating two values, the id (PK) of the customer which is unique across databases, plus the sequence id of the table rows themselves.

In so doing we have created a tight, and effectively permanent binding between years of historical customer data. If those primary keys in the RDBMS change, ours will need to also, or we’ll have some horrifying before-and-after scenario.

### Best of Both? Integers Internal, UUIDs External

One solution used in several different contexts that has worked for me is, in short, to use both. (Please note: not a good solution — see note about response to original post below).

Internally, let the database manage data relationships with small, efficient, numeric sequential keys, whether `int` or `bigint`.

Then *add a column* populated with a UUID (perhaps as a trigger on insert). Within the scope of the database itself, relationships can be managed using the usual PKs and FKs.

But when a reference to the data needs to be exposed to the outside world, *even when “outside” means another internal system,* they must rely only on the UUID.

This way, if you ever do have to change your internal primary keys, you can be sure it’s scoped only to one database. (Note: this is just plain wrong, as Chris observed)

We used this strategy at a different company for customer data, just to avoid the “guessable” problem. (Note: avoid is different than prevent, see below).

In another case, we would generate a “slug” of text (e.g. in blog posts like this one) that would make the URL a little more human friendly. If we had a duplicate, we would just append a hashed value.

Even as a “secondary primary key”, using a naive use of UUIDs in string form is wrong: use the built-in database mechanisms as values are stored as 8-byte integers, I would expect.

Use integers because they are efficient. Use the database implementation of UUIDs in addition for any external reference to obfuscate.

[Chris Russell](https://medium.com/@crussell52) responded to the original post on this section correctly noting two important caveats or errors in logic. First, even exposing a UUID that is effectively an alternate for the actual PK reveals information, and this is especially true when using the `newsequentialid` — don’t use UUIDs for security. Second, when the relations of a given schema are internally managed by integer keys, you still have the key-collision problem of merging two databases, unless all keys are doubled … in which case, just use the UUID. So, in reality, the right solution is probably: use UUIDs for keys, and don’t ever expose them. The external/internal thing is probably best left to things like friendly-url treatments, and then (as Medium does) with a hashed value tacked on the end. Thanks Chris!

#### References and many thanks

Thanks to [Ruby Weekly](http://rubyweekly.com/issues/335) (which I still read, wistfully although Scala is growing on me), [Starr Horne’s great blog from Honeybadger.io](http://blog.honeybadger.io/easy_rails_database_scaling_wins/) on this topic, the always [funny and smart post on Coding Horror by Jeff Atwood](https://blog.codinghorror.com/primary-keys-ids-versus-guids/), co-founder of Stack Overflow, and naturally a fine question on one of Stackoverflow’s sites at [dba.stackexchange.com](http://dba.stackexchange.com/questions/69254/whats-the-most-efficient-uuid-column-type). Also a nice post from [MySqlserverTeam](http://mysqlserverteam.com/storing-uuid-values-in-mysql-tables/), another from [theBuild.com](http://thebuild.com/blog/2015/10/08/uuid-vs-bigserial-for-primary-keys/) and of course MSDN which I linked earlier.

### Meta: Why I Blog

I learned *a lot* writing about this.

I started out reading email on a Sunday afternoon.

Then came across an interesting post by Starr, which got me thinking his advice might have unintended outcomes. So I googled and learned way more about UUIDs than I knew before, *and* changed my fundamental understanding and disposition about how and when to use them.

Halfway through writing this, I sent email to the team leads at my company wondering if we had considered one of the topics I discussed. Hopefully we’re ok, but I think we may have avoided at least one unexpected surprise in code scheduled for release this week.

Note that all of these are entirely selfish reasons :-)

Hope you like it, too!

[Image Credit](http://unlockforus.blogspot.com/2008/03/advanced-how-to-creategenerate-new-guid.html)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
