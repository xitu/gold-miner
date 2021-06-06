> * 原文地址：[Adding a Unique Constraint in an Online Way](http://db-oriented.com/2018/02/15/adding-a-unique-constraint-in-an-online-way/)
> * 原文作者：[Oren Nakdimon](http://db-oriented.com/en/author/orenn/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/adding-a-unique-constraint-in-an-online-way.md](https://github.com/xitu/gold-miner/blob/master/article/2021/adding-a-unique-constraint-in-an-online-way.md)
> * 译者：[kamly](https://github.com/kamly)
> * 校对者：[huifrank](https://github.com/huifrank), [greycodee](https://github.com/greycodee)

# 以在线的方式添加唯一约束

> 本文假定使用企业版本。

我有一个表 `t`，想在该表的 `c1` 列上添加一个唯一约束。

## 离线方式

最简单直接的方法是使用单个 `ALTER TABLE` 语句：

```SQL
SQL> alter table t add constraint c1_uk unique (c1);

Table altered.
```

默认情况下，Oracle 在执行这条语句后会创建一个唯一约束（名为 C1_UK）和一个相应的唯一索引（也叫 C1_UK）来强制实施约束。
缺点是这是一个离线操作 —— 该表被加共享锁。

即使我们在创建索引时声明在线操作，也是如此：

```SQL
SQL> alter table t add constraint c1_uk unique (c1) using index online;

Table altered.
```

如果表包含许多记录，创建索引可能需要相当长的时间，在此期间表被锁定，表上的 DML 操作被阻塞。

## 在线方式

通过将操作拆分为三个步骤，我们可以以在线的方式创建唯一约束：

### 步骤1：显式创建唯一索引

我们将使用 `online` 关键字显式创建索引，而不是让 Oracle 隐式创建索引：

```SQL
SQL> create unique index c1_uk on t(c1) online;

Index created.
```

此操作可能需要一些时间，具体取决于表的大小，但它是一个在线操作。

### 步骤2：创建约束

现在我们可以添加约束，并将其与现有索引相关联。这是一个快速的操作，因为索引已经存在，但是默认的 `alter table ... add constraint ...` 是离线操作。为了让其在线执行，我们应该将约束创建设置为 `NOT VALIDATED`：

```SQL
SQL> alter table t add constraint c1_uk unique (c1)
  2  using index c1_uk
  3  enable novalidate;

Table altered.
```

因此，现在该约束被标记为 `ENABLED`，这意味着将来的 DML 语句将不能违反它，并且被标记为 `NOT VALIDATED`，这意味着现有记录可能会违反它：

```SQL
SQL> select status,validated,generated,index_name
  2  from user_constraints
  3  where constraint_name='C1_UK';

STATUS     VALIDATED       GENERATED  INDEX_NAME
---------- --------------- ---------- ----------
ENABLED    NOT VALIDATED   USER NAME  C1_UK
```

事实上，我们知道没有任何现有记录违反约束，因为唯一索引强制整个表具有唯一性。为了使这一事实被“正式记录”，我们将进入第三步。

### 步骤3：验证约束

要将约束标记为 `VALIDATED`，我们将使用以下语句：

```SQL
SQL> alter table t enable validate constraint c1_uk;

Table altered.
```

这是一个在线操作，但它也是一个快速操作吗？
当我们验证检查约束或外键约束时，Oracle 将扫描表中的所有记录，以确保没有记录违反约束，对于大型表，这可能需要很长时间。

但是在我们的例子中，Oracle 知道唯一索引已经对表中的所有现有记录实施了约束，并且它优化了验证阶段。
使用 SQL 跟踪，我们可以看到执行实际验证的查询如下所示：

```SQL
select /*+ all_rows ordered dynamic_sampling(2) */ A.rowid, :1, :2, :3
from "DEMO"."T" A
where 1=0
```

因此，无论表的大小如何，此验证阶段都很快，因为验证根本不访问表记录。

## 通过非唯一索引强制实施唯一约束

只要约束中的列是索引的前导列，Oracle 也可以通过使用非唯一索引来强制实施唯一约束。

让我们使用非唯一索引重复上一节中的步骤（在删除并重新创建表之后）。

```SQL
SQL> create /* non-unique */ index c1_idx on t(c1) online;

Index created.

SQL> alter table t add constraint c1_uk unique (c1)
  2  using index c1_idx
  3  enable novalidate;

Table altered.

SQL> alter table t enable validate constraint c1_uk;

Table altered.
```

在本例中，第三步不像我们使用唯一索引时那样只是一个“橡皮图章”。这里应该实际验证现有记录，并且实际上我们可以在跟踪文件中看到它：

```SQL
select /*+ all_rows ordered dynamic_sampling(2) */ A.rowid, :1, :2, :3
from "DEMO"."T" A,
     (select /*+ all_rows */ "C1" from "DEMO"."T" A
      where ("C1" is not null)
      group by "C1" having count(1) > 1) B
where( "A"."C1" is not null)
and (sys_op_map_nonnull("A"."C1") =  sys_op_map_nonnull("B"."C1"))

STAT #2199513034064 id=1 cnt=0 pid=0 pos=1 obj=0 op='HASH JOIN  (cr=4180 pr=0 pw=0 str=1 time=706676 us cost=2308 size=1150000 card=50000)'
STAT #2199513034064 id=2 cnt=1000000 pid=1 pos=1 obj=113672 op='TABLE ACCESS FULL T (cr=2090 pr=0 pw=0 str=1 time=103204 us cost=582 size=10000000 card=1000000)'
STAT #2199513034064 id=3 cnt=0 pid=1 pos=2 obj=0 op='VIEW  (cr=2090 pr=0 pw=0 str=1 time=425247 us cost=620 size=650000 card=50000)'
STAT #2199513034064 id=4 cnt=0 pid=3 pos=1 obj=0 op='FILTER  (cr=2090 pr=0 pw=0 str=1 time=425246 us)'
STAT #2199513034064 id=5 cnt=1000000 pid=4 pos=1 obj=0 op='SORT GROUP BY (cr=2090 pr=0 pw=0 str=1 time=404184 us cost=620 size=250000 card=50000)'
STAT #2199513034064 id=6 cnt=1000000 pid=5 pos=1 obj=113672 op='TABLE ACCESS FULL T (cr=2090 pr=0 pw=0 str=1 time=24097 us cost=582 size=5000000 card=1000000)'
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
