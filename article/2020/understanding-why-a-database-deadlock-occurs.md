> * 原文地址：[Understanding why a database deadlock occurs](https://levelup.gitconnected.com/understanding-why-a-database-deadlock-occurs-8bbd32be8026)
> * 原文作者：[Akshar Raaj](https://medium.com/@raaj.akshar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-why-a-database-deadlock-occurs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-why-a-database-deadlock-occurs.md)
> * 译者：
> * 校对者：

# Understanding why a database deadlock occurs

![Photo by [Jose Fontano](https://unsplash.com/@josenothose?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11762/0*_u9DVXa89MGK57qy)

![Database deadlock](https://cdn-images-1.medium.com/max/2000/1*5fAlgCSLLbV3ByPQrtgbgQ.png)

## Agenda

This post attempts to explain what a database deadlock is and why they occur.

We will write SQL statements and cause deliberate deadlocks and discuss how deadlocks could be mitigated.

We will use PostgreSQL as our database.

## Setup

Let’s start a PostgreSQL shell and create a table called accounts.

```
akshar=# create table accounts (acct_id integer, amount integer); CREATE TABLE
```

Let’s insert two rows in this table.

```
akshar=# insert into accounts values (1, 500);
INSERT 0 1
akshar=# insert into accounts values (2, 300);
INSERT 0 1
```

Let’s verify the rows are inserted.

```
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 500
2 | 300
(2 rows)
```

## Transaction

It’s essential to have a basic understanding of transaction to properly understand a deadlock.

Transaction is a DBMS feature which keeps the database in a coherent and reliable state. Wikipedia defines a transaction as:

```
A database transaction symbolizes a unit of work performed within a database management system against a database, and treated in a coherent and reliable way independent of other transactions.
```

Transaction guarantees ACID compliance. Read [this for an understanding of ACID](https://en.wikipedia.org/wiki/ACID).

A bank account transfer is a classic case to understand database transaction. Let’s assume our application provides a functionality to transfer an amount from account A to account B.

During a transfer, account A should get debited and B should get credited. Debit and Credit form a single unit of work. Either both the operations should happen or neither of them should happen. That’s why these two statements should be part of a single transaction.

Let’s start a `psql` shell and do a transaction to transfer money from one account to another.

```
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-10 where acct_id=1; UPDATE 1
akshar=# update accounts set amount=amount+10 where acct_id=2; UPDATE 1
akshar=# commit;
COMMIT
```

Let’s check the amounts in both accounts.

```
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 490
2 | 310
(2 rows)
```

This suggests that the transfer was successfully done and our transaction code is correct.

## Causing deadlock

We will deliberately cause a deadlock now.

Any production ready DBMS is capable of serving multiple simultaneous processes. We will simulate two simultaneous amount of transfers by running two `psql` shells.

First shell will simulate a process which does amount transfer from account 1 to 2. Second shell will simulate a process which does a transfer from account 2 to 1.

Account 1 wants to transfer amount 10 to account 2. We will do this on first shell.

```
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-10 where acct_id=1; UPDATE 1
```

Simultaneously i.e before first transaction could complete, account 2 decided to transfer amount 20 to account 1. We will do this on second shell

```
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-20 where acct_id=2; UPDATE 1
```

Let’s assume the DBMS gave the first process a chance to run next. So let’s simulate that by crediting account 2 on first shell.

```
akshar=# update accounts set amount=amount+10 where acct_id=2;
```

You should notice that the database wouldn’t return with a success message, instead it is blocked and you wouldn’t get any response.

This happened because the row for acct_id=2 is currently `locked` because process 2 did an update on that row. Process 1 cannot get hold of that lock until process 2 releases it.

The database would now give process 2, a chance to run. So let’s simulate that by crediting account 1 on second shell.

```
akshar=# update accounts set amount=amount+20 where acct_id=1;
```

The database would have returned an `ERROR: deadlock detected`.

```
ERROR: deadlock detected
DETAIL: Process 77716 waits for ShareLock on transaction 173312; blocked by process 76034.
Process 76034 waits for ShareLock on transaction 173313; blocked by process 77716.
HINT: See server log for query details. CONTEXT: while updating tuple (0,3) in relation "accounts"
```

Process 1 had already locked the db row with acct_id=1 when it debited amount 10 from account 1. Now process 2 tried to do an update on the same row, this step needs the lock. Process 2 could only acquire the lock if process 1 releases it. But process 1 is blocked waiting for process 2 to release the lock on acct_id=2. Essentially process 1 is waiting for a lock to be released by process 2 and process 2 is waiting for a lock to be released by process 1. This is a deadlock.

Database is smart enough to detect a deadlock.

Database would raise this deadlock error in process 2 shell. Once deadlock error is raised all the locks held by this process are released. This also gives process 1 a chance to acquire the needed lock.

Check process 1 shell, the blocked command would have returned and amount 10 would have been credited to account 2.

```
akshar=# update accounts set amount=amount+10 where acct_id=2; UPDATE 1
```

Try to issue a `commit` on process 2 shell.

```
akshar=# commit;
ROLLBACK
```

Since a deadlock was detected, it means the commands wouldn’t have succeeded and so commit could lead database into an inconsistent and unreliable state. DBMS is smart to realize that and so even issuing a `commit` would lead to a `rollback`.

But since process 1 commands executed successfully, so `commit` can be issued on process 1 shell.

```
akshar=# commit;
COMMIT
```

You should be able to verify that account 1 was debited by amount 10 and account 2 was credited by amount 10.

```
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 480
2 | 320
(2 rows)
```

## Handling deadlock

Concurrency is a reality and is unavoidable. It is very much possible that multiple processes simultaneously attempt to update the same set of rows and get blocked by each other. Deadlock is inevitable in such cases.

Deadlock should be handled at the application level in such cases. There has to be exception handling code to catch deadlock errors and retry the failed transaction.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
