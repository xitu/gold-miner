> * 原文地址：[Understanding why a database deadlock occurs](https://levelup.gitconnected.com/understanding-why-a-database-deadlock-occurs-8bbd32be8026)
> * 原文作者：[Akshar Raaj](https://medium.com/@raaj.akshar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-why-a-database-deadlock-occurs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-why-a-database-deadlock-occurs.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[samyu2000](https://github.com/samyu2000), [Roc](https://github.com/QinRoc)

# 你理解数据库死锁发生的原因吗?

![图片来自 [Jose Fontano](https://unsplash.com/@josenothose?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11762/0*_u9DVXa89MGK57qy)

![数据库死锁](https://cdn-images-1.medium.com/max/2000/1*5fAlgCSLLbV3ByPQrtgbgQ.png)

## 说明

这篇文章将向你解释什么是数据库死锁以及为什么会发生死锁。

我们将写一条故意造成死锁的 SQL 语句，然后讨论如何减少死锁的发生。

说明一下，这里使用 PostgreSQL 作为我们的数据库。

## 开始

让我们启动 PostgreSQL shell 并创建一个名为 accounts 的表。

```base
akshar=# create table accounts (acct_id integer, amount integer); CREATE TABLE
```

在表中插入两行。

```base
akshar=# insert into accounts values (1, 500);
INSERT 0 1
akshar=# insert into accounts values (2, 300);
INSERT 0 1
```

让我们来确认一下这两行是否成功插入了。

```base
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 500
2 | 300
(2 rows)
```

## 事务

要正确理解死锁，必须对事务有基本的了解。

事务是 DBMS 的一个特性，它使数据库保持一致和可靠的状态。维基百科将事务定义为：

```base
在数据库管理系统中，数据库事务象征着数据库执行的工作单元，并以独立于其他事务的一致和可靠的方式进行处理。
```

事务保证了对 ACID 的遵守。阅读 [理解 ACID](https://en.wikipedia.org/wiki/ACID)。

银行账户转账是理解数据库事务的经典案例。假设我们的应用程序提供了从帐户 A 转账到帐户 B 的功能。

在转账过程中，A 账户金额减少，B 账户金额增加。两者构成一个程序执行单元。要么两个操作都发生，要么两个都不发生。所以这两个语句是单个事务的一部分。

让我们启动一个 `psql` shell 并执行一个事务，将钱从一个帐户转移到另一个帐户。

```base
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-10 where acct_id=1; UPDATE 1
akshar=# update accounts set amount=amount+10 where acct_id=2; UPDATE 1
akshar=# commit;
COMMIT
```

让我们核对一下这两个账户的金额。

```base
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 490
2 | 310
(2 rows)
```

结果表示转账成功，我们的事务代码是正确的。

## 引起死锁

我们现在要故意制造死锁的情况。

任何生产环境使用的 DBMS 都能够提供多个并发进程服务。我们将通过运行两个 `psql` shell 来模拟两个同时进行的转账。

第一个 shell 将模拟从账户 1 向账户 2 转账的过程。第二个 shell 将模拟从账户 2 向账户 1 转账的过程。

账户 1 向账户 2 转账，金额为 10，我们将执行第一个 shell 来完成这一过程。

```base
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-10 where acct_id=1; UPDATE 1
```

同时在第一次交易完成之前，账户 2 向账户 1 转账 20 的金额。我们将在第二个 shell 中做这个操作。

```base
akshar=# begin transaction;
BEGIN
akshar=# update accounts set amount=amount-20 where acct_id=2; UPDATE 1
```

假设 DBMS 给了第一个进程执行下一步的机会。这时我们在第一个 shell 中模拟帐户 2 增加金额。

```base
akshar=# update accounts set amount=amount+10 where acct_id=2;
```

你应该注意到数据库没有返回成功消息，因为进程被阻塞了，所以我们得不到任何响应。

这种情况之所以发生，是因为进程 2 对该行进行了更新，acct_id=2 的行当前被 锁定了。进程 1 在进程 2 释放该进程之前无法获得该锁。

数据库现在将给进程 2 一个执行的机会。我们在第二个 shell 中模拟帐户 1 增加金额。

```base
akshar=# update accounts set amount=amount+20 where acct_id=1;
```

数据库将返回： `错误: 检测到死锁`。

```base
ERROR: deadlock detected
DETAIL: Process 77716 waits for ShareLock on transaction 173312; blocked by process 76034.
Process 76034 waits for ShareLock on transaction 173313; blocked by process 77716.
HINT: See server log for query details. CONTEXT: while updating tuple (0,3) in relation "accounts"
```

当进程 1 从帐户 1 扣除金额 10 时，它已经锁定了 acct_id=1 的 db 行。现在，进程 2 尝试对同一行进行更新，这一步需要锁。进程 2 只有在进程 1 释放锁时才能获得锁。但是进程 1 被阻塞，等待进程 2 释放 acct_id=2 上的锁。总的来说，进程 1 正在等待进程 2 释放一个锁，而进程 2 正在等待进程 1 释放一个锁。这就是死锁。

数据库能灵敏的检测到死锁。

数据库将在进程 2 的 shell 中引发此死锁。一旦抛出死锁错误，进程 2 持有的所有锁都会被释放。这也让进程 1 有机会获得所需的锁。

检查进程 1 的 shell，已阻塞的命令将被 return，金额 10 被记入帐户 2。

```base
akshar=# update accounts set amount=amount+10 where acct_id=2; UPDATE 1
```

尝试在进程 2 的 shell 上 `commit`。

```base
akshar=# commit;
ROLLBACK
```

由于检测到死锁，这意味着命令执行失败，因此 commit 可能导致数据库进入不一致和不可靠的状态。DBMS 也聪明地意识到这一点，所以即使执行 `提交` 事务的命令，也将 `回滚`。

但是由于进程 1 命令成功执行，所以可以在进程 1 的 shell 上发出 `commit`。

```base
akshar=# commit;
COMMIT
```

现在能够验证账户 1 转出了金额 10，而账户 2 转入了金额 10。

```base
akshar=# select * from accounts;
acct_id | amount
---------+--------
1 | 480
2 | 320
(2 rows)
```

## 处理死锁

并发操作是一种真实和不可避免的情况。很有可能多个进程同时尝试操作一行导致彼此阻塞。在这种情况下，死锁是无法避免的。

在这种情况下，应该在应用程序中处理死锁。必须有异常处理代码来捕获死锁错误，然后重新执行失败的事务。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
