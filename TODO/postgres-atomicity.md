
  > * 原文地址：[Stability in a Chaotic World: How Postgres Makes Transactions Atomic](https://brandur.org/postgres-atomicity)
  > * 原文作者：[Brandur](https://twitter.com/brandur)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/postgres-atomicity.md](https://github.com/xitu/gold-miner/blob/master/TODO/postgres-atomicity.md)
  > * 译者：[TanJianCheng](https://github.com/TanNingMeng)
  > * 校对者：[xiaoyusilen](https://github.com/xiaoyusilen) [mnikn](https://github.com/mnikn)
   
  # 混乱世界中的稳定：Postgres 如何使事务原子化

  原子性( “ACID” 特性)声明，对于一系列的数据库操作，要么所有操作一起提交，要么全部回滚；不允许中间状态存在。对于那些需要去适应混乱的现实世界的代码来说，简直是天赐良物。

那些改变数据并继续恶化下去的故障将被取代，这些改变会被恢复。当你在处理着百万级请求的时候，可能会因为间歇性的问题导致连接的断断续续或者出现一些其它的突发情况，从而导致一些不便，但不会打乱你的数据。

众所周知 Postgres 的实现中提供了强大的事务语义化。虽然我已经用了好几年，但是有些东西我从来没有真正理解。Postgres 有着稳定出色的工作表现，让我安心把它当成一个黑盒子 -- 惊人地好用，但是内部的机制却是不为人知的。

这篇文章是探索 Postgres 如何保持它的事务及原子性提交，和一些可以让我们深入理解其内部机制的关键概念<sup>[\[1\]](#footnote-1)</sup>。

## 管理并发访问

假如你建立了一个简易数据库，这个数据库读写硬盘上的 CSV 文件。当只有一个客户端发起请求时，它会打开文件，读取信息并写入信息。一切运行非常完美，有一天，你决定强化你的数据库，给它加入更加复杂的新特性 - 多客户端支持！

不幸地是，当两个客户端同时试图去操作数据的时候，新功能立即被出现的问题所困扰。当一个 CSV 文件正在被一个客户端读取，修改，和写入数据的时候，如果另一个客户端也尝试去做同样的事情，这个时候就会发生冲突。

[![](https://brandur.org/assets/postgres-atomicity/csv-database.svg)](https://brandur.org/assets/postgres-atomicity/csv-database.svg)

客户端之间的资源争夺会导致数据丢失。这是并发访问出现的常见问题。可以通过引入**并发控制**来解决。曾经有过许多原始解决方案。例如我们让来访者带上独占锁去读写文件，或者我们可以强制让所有访问都需要通过流控制点，从而实现同一时间只能运行其一。但是这些方法不仅运行缓慢，而且由于不能纵向扩展，从而使数据库不能完全支持 ACID 特性。现代数据库有一个完美的解决办法，MVCC （多版本并行控制系统）。

在 MVCC，语句在**事务**里面执行。它会创建一个新版本，而不会直接覆写数据。有需求的客户端仍然可以使用原始的数据，但新的数据会被隐藏起来直到事务被提交。这样客户端之间就不存在直接争夺的情况，数据也不再面临重写而且可以安全地被保存。

事务开始执行的时候，数据库会生成一个此刻数据库状态的快照。在数据库的每一个事务都会以**串行**的顺序执行，通过一个全局锁来保证每次只有一个事务能够提交或者中止操作。快照完美体现了两个事务之间的数据库状态。

为了避免被删除或隐藏的行数据不断地堆积，数据库最后将经过一个 **vacuum** 程序（或在某些情况下，带有歧义查询的 “microvacuums” 队列）来清理淘汰数据，但是只能在数据不再被其它快照使用的时候才能进行。

让我们看下 Postgres 如何使用 MVCC 管理并发的情况。

## 事务、元组和快照

这是 Postgres 用于实现事务的结构（来自 [proc.c](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/storage/proc.h#L207)）：

```
typedef struct PGXACT
{
    TransactionId xid;   /* 当前由程序执行的顶级事务 ID 
                          * 如果正在执行且 ID 被赋值；
                          * 否则是无效事务 ID */

    TransactionId xmin;  /* 正在运行最小的 XID，
                          *  除了 LAZY VACUUM:
                          * vacuum 不移除因 xid >= xmin
                          * 而被删除的元组 */

    ...
} PGXACT;
```

事务是以 `xid`（或 “xact” ID）来标记。这是 Postgres 的优化，当事务开始更改数据的时候，Postgres 会赋值一个 `xid` 给它。因为只有那个时候，其它程序才需要开始追踪它的改变。只读操作可以直接执行，不需要分配 `xid`。

当这个事务开始运行的时候，`xmin` 马上被设置为运行事务中 `xid` 最小的值。Vacuum 进程计算数据的最低边界，使它们保持 `xmin` 是所有事务中的最小值。

### 生命周期感知的元组

在 Postgres，行数据常常与**元组**有关。当 Postgres 使用像 B 树通用的查找结构去快速检索信息，索引并没有存储一个元素的完整数据或其中任意的可见信息。相反，他们存储可以从物理存储器（也称为“堆”）检索特定行的 `tid`（元组 ID）。Postgres 通过 `tid` 作为起始点，对堆进行扫描直到找到一个能满足当前快照的可见元组。

这是 Postgres 实现的**堆元组**（不是**索引元组**），以及它头信息的结构( [来自 `htup.h`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/access/htup_details.h#L116) [和 `htup_details.h`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/access/htup.h#L62)):

```
typedef struct HeapTupleData
{
    uint32          t_len;         /* *t_data 的长度 */
    ItemPointerData t_self;        /* SelfItemPointer */
    Oid             t_tableOid;    /* 唯一标识一个表 */
    HeapTupleHeader t_data;        /* -> 元组的头部及数据 */
} HeapTupleData;

/* 相关的 HeapTupleData */
struct HeapTupleHeaderData
{
    HeapTupleFields t_heap;

    ...
}

/* 相关的 HeapTupleHeaderData */
typedef struct HeapTupleFields
{
    TransactionId t_xmin;        /* 插入 xact ID */
    TransactionId t_xmax;        /* 删除或隐藏 xact ID */

    ...
} HeapTupleFields;
```

像事务一样，元组也会追踪它自己的 `xmin`，但是这只在特定的元组情况下，例如它被记录为第一个事务，其中元组变可见。（即创建它的那个）。它还追踪 `xmax` 作为最后的一个的**事务**，其中元组是可见的（即删除它的那个）<sup>[\[2\]](#footnote-2)</sup>。

[![](https://brandur.org/assets/postgres-atomicity/heap-tuple-visibility.svg)](https://brandur.org/assets/postgres-atomicity/heap-tuple-visibility.svg)

可以使用 `xmin` 和 `xmax` 来追踪堆元组的生存期。虽然 `xmin` 和 `xmax` 是内部概念，但是他们可以显示任何 Postgres 表上被隐藏的列。通过名字显示地选择它们：

```
# SELECT *, xmin, xmax FROM names;

 id |   name   | xmin  | xmax
----+----------+-------+-------
  1 | Hyperion | 27926 | 27928
  2 | Endymion | 27927 |     0
```

### 快照：xmin，xmax，和 xip

这是快照的实现结构 ([来自 snapshot.h](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/utils/snapshot.h#L52)):

```
typedef struct SnapshotData
{
    /*
     * 以下字段仅用于 MVCC 快照，和在特定的快照。
     * (但 xmin 和 xmax 专门用于 HeapTupleSatisfiesDirty)
     * 
     *
     * 一个 MVCC 快照 永远不可能见到 XIDs >= xmax 的事务。
     * 除了那些列表中的 snapshot，它会看到时间长的 XIDs 的内容。
     * 对于大多数的元组，xmin 被存储起来是个优化的操作，这样避免去搜索 XID 数组。
     * 
     */
    TransactionId xmin;            /* id小于xmin的所有事务更改在当前快照中可见 */
    TransactionId xmax;            /* id大于xmax的所有事务更改在当前快照中可见 */

    /*
     * 对于普通的 MVCC 快照，它包含了程序中所有的 xact IDs
     * 除非在它是空的情况下被使用。
     * 对于历史 MVCC 的快照, 这就是刚好相反, 即它包含了在 xmin 和 xmax 中已提交的事务。
     * 
     *
     * 注意: 所有在 xip[] 的 ids 都满足 xmin <= xip[i] < xmax
     */
    TransactionId *xip; /* 所有正在运行的事务的id列表 */
    uint32        xcnt; /* 正在运行的事务的计数 */

    ...
}
```

快照的 `xmin` 计算方式和计算事务的相同（即在正在运行的事务中，`xid` 最低的事务），但用途却不一样。`xmin` 是数据可见的最低边界。元组是被 `xid < xmin` 条件的事务所创建，对快照可见。

同时也有定义为 `xmax` 的变量，它被设置为最后一次提交事务的 `xid` + 1。`xmax` 是数据可见的上限；`xid >= xmax` 的事务对快照是不可见的。

最后，当快照被创建，它会定义一个 `*xip` 作为存储所有事务 `xid` 的数组。`*xip` 存在是因为即使 `xmin` 被设定为可见边界，可能有一些已经提交的事务的 `xid` 大于 `xmin`，但也存在 `xmin` **也**大于一些处于执行阶段的事务的 `xid`。

我们希望任何 `xid > xmin` 的事务提交结果都是可见的，但事实上它们被隐藏了。快照创建的时候，`*xip` 存储的有效事务清单可以帮助我们辨别各事务身份。

[![](https://brandur.org/assets/postgres-atomicity/snapshot-creation.svg)](https://brandur.org/assets/postgres-atomicity/snapshot-creation.svg)

事务是对数据库进行操作，快照是为了抓捕数据库一瞬间的信息。

## 开启事务

当你执行 `BEGIN` 语句，尽管 Postgres 对于一些常用的操作会有相应优化，但它会尽可能地推迟更多开销比较大的操作。举个例子，一个新的事务在开始修改数据之前，我们不会给它分配 xid。这样做可以减少在其他地方追踪它的花费。

新的事务也不会立即使用快照。当事务运行第一个查询，`exec_simple_query` ([在 `postgres.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/tcop/postgres.c#L1010))才会将其入栈。甚至一个简单的 `SELECT 1;` 语句也会触发：

```
static void
exec_simple_query(const char *query_string)
{
    ...

    /*
     * 如果解析/计划需要，则设置一个快照
     */
    if (analyze_requires_snapshot(parsetree))
    {
        PushActiveSnapshot(GetTransactionSnapshot());
        snapshot_set = true;
    }

    ...
}
```

创建新快照是程序真正开始加载的起始点。这是 `GetSnapshotData` ([在 `procarray.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/storage/ipc/procarray.c#L1507)):

```
Snapshot
GetSnapshotData(Snapshot snapshot)
{
    /* xmax 总是等于 latestCompletedXid + 1 */
    xmax = ShmemVariableCache->latestCompletedXid;
    Assert(TransactionIdIsNormal(xmax));
    TransactionIdAdvance(xmax);

    ...

    snapshot->xmax = xmax;
}
```

这个函数做了很多初始化的工作，但像我们谈到的，它最主要的工作就是设置快照的 `xmin`，`xmax`，和 `*xip`。其中最简单的就是设置 `xmax`，它可以从 Postmaster 管理的共享存储器中检索出来。每个提交的事务都会通知 Postmaster，和 `latestCompletedXid` 将会被更新，如果 `xid` 高于当前 `xid` 的值（稍后将详细介绍）。

需要注意的是，最后的 `xid` 自增是由函数实行的。因为在 Postgres 里面，事务的 IDs 是被允许包装，所以并不是单纯的自增那么简单。一个事务 ID 是被定义为一个无符号32位整数(来自 [c.h](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/c.h#L397)):

```
typedef uint32 TransactionId;
```

尽管 `xid` 是看情况来分配的（上文提过，读取数据时是不需要它的），但是系统大量的吞吐量很容易就达到32位的边界，所以系统需要根据需求将 `xid` 序列进行“重置”。这是由一些预处理器处理的(在 [transam.h](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/access/transam.h#L31)):

```
#define InvalidTransactionId        ((TransactionId) 0)
#define BootstrapTransactionId      ((TransactionId) 1)
#define FrozenTransactionId         ((TransactionId) 2)
#define FirstNormalTransactionId    ((TransactionId) 3)

...

/* 提前一个事务ID变量, 直接操作 */
#define TransactionIdAdvance(dest)    \
    do { \
        (dest)++; \
        if ((dest) < FirstNormalTransactionId) \
            (dest) = FirstNormalTransactionId; \
    } while(0)
```

最初的几个 ID 被保留作为特殊标识符，所以我们一般跳过它，从 `3` 开始。

回到 `GetSnapshotData` 里，通过迭代所有正在执行的事务我们可以得到 `xmin` 和 `xip` (回顾[快照](#snapshots)中它们的作用):

```
/*
 * 循环 procArray 查看 xid，xmin，和 subxids。  
 * 目的是得到所有 active xids，找到最低的 xmin，和试着去记录 subxids。
 * 
 */
for (index = 0; index < numProcs; index++)
{
    volatile PGXACT *pgxact = &allPgXact[pgprocno];
    TransactionId xid;
    xid = pgxact->xmin; /* fetch just once */

    /*
     * 如果事务中没有被赋值的 XID，我们可以跳过；
     * 对于 sub-XIDs 也同理。如果 XID >= xmax，我们也可以跳过它；
     * 这样的事务被认为(任何 sub-XIDs 都将 >= xmax)。
     * 
     */
    if (!TransactionIdIsNormal(xid)
        || !NormalTransactionIdPrecedes(xid, xmax))
        continue;

    if (NormalTransactionIdPrecedes(xid, xmin))
        xmin = xid;

    /* 添加 XID 到快照中。 */
    snapshot->xip[count++] = xid;

    ...
}

...

snapshot->xmin = xmin;
```

## 提交事务

事务通过 [`CommitTransaction` (在 `xact.c`)](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/xact.c#L1939)被提交。函数非常复杂，下面代码是函数比较重要部分：

```
static void
CommitTransaction(void)
{
    ...

    /*
     * 我们需要去 pg_xact 标记 XIDs 来表示已提交。作为
     * 已稳定提交的标记。
     */
    latestXid = RecordTransactionCommit();

    /*
     * 让其他知道没有其他事务在程序中。
     * 需要注意的是，这个操作必须在释放锁之前
     * 和记录事务提交之前完成。
     */
    ProcArrayEndTransaction(MyProc, latestXid);

    ...
}
```

### 持久性和 WAL 

Postgres 是完全围绕着持久性的概念设计的。这样即使像在外力摧毁或功率损耗的情况下，已提交的事务也保持原有的状态。像许多优秀的系统，Postgres 使用**预写式日志**( **WAL**，或 “xlog”）去实现稳定。所有的更改被记录进磁盘，甚至像宕机这种事情，Postgres 会搜寻 WAL，然后重新恢复没有写进数据文件的更改记录。

从上面 `RecordTransactionCommit` 的片段代码中，将事务的状态更改到 WAL：

```
static TransactionId
RecordTransactionCommit(void)
{
    bool markXidCommitted = TransactionIdIsValid(xid);

    /*
     * 如果目前我们还没有指派 XID，那我们就不能再指派，也不能
     * 写入提交记录
     */
    if (!markXidCommitted)
    {
        ...
    } else {
        XactLogCommitRecord(xactStopTimestamp,
                            nchildren, children, nrels, rels,
                            nmsgs, invalMessages,
                            RelcacheInitFileInval, forceSyncCommit,
                            MyXactFlags,
                            InvalidTransactionId /* plain commit */ );

        ....
    }

    if ((wrote_xlog && markXidCommitted &&
         synchronous_commit > SYNCHRONOUS_COMMIT_OFF) ||
        forceSyncCommit || nrels > 0)
    {
        XLogFlush(XactLastRecEnd);

        /*
         * 如果我们写入一个有关提交的记录，那么可能更新 CLOG
         */
        if (markXidCommitted)
            TransactionIdCommitTree(xid, nchildren, children);
    }

    ...
}
```

### commit log

伴随着 WAL，Postgres 也有一个**commit log**（或者叫 “clog” 和 “pg_xact”）。这个记录都保存事务提交痕迹，无论最后事务提交与否。上面的 `TransactionIdCommitTree` 实现了这个功能 - 首先会尝试把一系列的信息写入 WAL，然后 `TransactionIdCommitTree` 会在 commit log 中改为“已提交”。

虽然 commit log 也被称为“日志”，但实际上它是一个提交状态的位图，在共享内存和在磁盘上的进行拆分。
在现代编程中很少出现这么简约的例子，事务的状态可以仅使用二个字节来记录，我们能每字节存储四个事务，或者每个标准 8k 页面存储 32758。

来自 [`clog.h`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/access/clog.h#L26) 和 [`clog.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/clog.c#L57):

```
#define TRANSACTION_STATUS_IN_PROGRESS      0x00
#define TRANSACTION_STATUS_COMMITTED        0x01
#define TRANSACTION_STATUS_ABORTED          0x02
#define TRANSACTION_STATUS_SUB_COMMITTED    0x03

#define CLOG_BITS_PER_XACT  2
#define CLOG_XACTS_PER_BYTE 4
#define CLOG_XACTS_PER_PAGE (BLCKSZ * CLOG_XACTS_PER_BYTE)
```

### 优化的规模

稳定性固然重要，但性能表现也是一个 Postgres 哲学中的核心元素。若是事务从不赋值 `xid`，Postgres 就会跳过 WAL 和提交日志。若是事务被中止，我们仍然会把它中止的状态写进 WAL 和 commit log，但不要急着马上去刷新（同步），因为实际上即使系统崩溃了，我们也不会丢失任何信息。在故障恢复期间，Postgres 会提示没有标记的事务，认为它们被中止了。

### 防御性编程

`TransactionIdCommitTree` (在 [transam.c](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/transam.c#L259), 和 它的 实现 `TransactionIdSetTreeStatus` 在 [clog.c](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/clog.c#L148)) 提交信息呈树状，因为用户接下来可能还有二次提交。我不会详细介绍二次提交，因为二次提交使 `TransactionIdCommitTree` 不能保证原子性，每一个二次提交都单独提交，而父进程被记录为最后一次操作。当 Postgres 在宕机中恢复数据时，二次提交记录不被认为是提交的（即使它们已经同样被标记）直到父记录被读取和确认提交。

这再一次体现原子性；系统可以成功记录任何二次提交的记录，但在它写入父进程之前就崩溃了。


就像[在 `clog.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/clog.c#L254) 所实现的:

```
/*
 * 将提交日志中的事务目录的最终状态记录到单个页面上所有目录上。
 * 原子只出现在这个页面。
 *
 * 其他的 API 与 TransactionIdSetTreeStatus() 相同。
 */
static void
TransactionIdSetPageStatus(TransactionId xid, int nsubxids,
                           TransactionId *subxids, XidStatus status,
                           XLogRecPtr lsn, int pageno)
{
    ...

    LWLockAcquire(CLogControlLock, LW_EXCLUSIVE);

    /*
     * 无论什么情况，都设置事务的 id。
     *
     * 如果我们在写的时候在这个页面上更新超过一个 xid，
     * 我们可能发现有些位转到了磁盘，有些则不会。
     * 如果我们在更新页面的时候提交了一个破坏原子性的最高级 xid，
     * 那么在我们标记最高级的提交之前我们先提交 subxids。
     * 
     */
    if (TransactionIdIsValid(xid))
    {
        /* Subtransactions first, if needed ... */
        if (status == TRANSACTION_STATUS_COMMITTED)
        {
            for (i = 0; i < nsubxids; i++)
            {
                Assert(ClogCtl->shared->page_number[slotno] == TransactionIdToPage(subxids[i]));
                TransactionIdSetStatusBit(subxids[i],
                                          TRANSACTION_STATUS_SUB_COMMITTED,
                                          lsn, slotno);
            }
        }

        /* ... 然后是主事务 */
        TransactionIdSetStatusBit(xid, status, lsn, slotno);
    }

    ...

    LWLockRelease(CLogControlLock);
}
```
### 通过共用存储器来标记完成的事务

当事务被记录到提交日志，向系统其他部分进行提示是一种安全行为。这发生在上面的 `CommitTransaction` 的第二次调用([在 procarray.c](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/storage/ipc/procarray.c#L394)):

```
void
ProcArrayEndTransaction(PGPROC *proc, TransactionId latestXid)
{
    /*
     * 当清除我们的 XID时，我们必须锁住 ProcArrayLock
     * 这样当别人设置快照的时候，运行的事务已全被清空了。
     * 看讨论
     * src/backend/access/transam/README.
     */
    if (LWLockConditionalAcquire(ProcArrayLock, LW_EXCLUSIVE))
    {
        ProcArrayEndTransactionInternal(proc, pgxact, latestXid);
        LWLockRelease(ProcArrayLock);
    }

    ...
}

static inline void
ProcArrayEndTransactionInternal(PGPROC *proc, PGXACT *pgxact,
                                TransactionId latestXid)
{
    ... 

    /* 也是在持锁的情况下提前全局 latestCompletedXid */
    if (TransactionIdPrecedes(ShmemVariableCache->latestCompletedXid,
                              latestXid))
        ShmemVariableCache->latestCompletedXid = latestXid;
}
```

你可能想知道什么是“proc array”。不像其他的服务进程，Postgres 没有使用线程，而是使用一个分岔模型的程序来操作并发机制。当它接受一个新连接，Postmaster 分开一个新服务器进程([在 `postmaster.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/postmaster/postmaster.c#L4014))。使用 `PGPROC` 数据结构来表示服务器进程 ([在 `proc.h`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/include/storage/proc.h#L94))，和有效的程序的集合都可以在共用存储器追踪到，这就是“proc array”。

现在还记得我们如何创建一个快照并把它的 `xmax` 设置为 `latestCompletedXid + 1`？通过把全局共用存储器中的 `latestCompletedXid` 赋值给刚提交的事务的 `xid`，我们把它的结果对所有从这一刻开始，任何服务器进程的新快照都可见。

看以下获取锁和释放锁所调用的 `LWLockConditionalAcquire` 和 `LWLockRelease`。大多数时候，Postgres 非常乐意让程序都并行工作，但是有一些地方需要获得锁来避免争夺，而这就是需要用到它们的时候。在文章的开头，我们提到了在 Postgres 的事务是如何按顺序依次提交或中止的。`ProcArrayEndTransaction` 需要独占锁以便于当它更新  `latestCompletedXid` 的时候不被别的程序打扰。

### 响应客户端

在整个流程中，客户端在它的事务被确认之前会同步地等待。部分原子性是虚构数据库标记事务为提交，这不是不可能的。很多地方都可能发生故障，但是如果出现了故障，客户端会找出它然后去重试或解决问题。

## 检查可见性

我们之前说过如何将可见的信息存储在堆元组。`heapgettup` ([heapam.c](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/heap/heapam.c#L478)) 是负责扫描堆，看看里面有没有符合快照可见性的标准：

```
static void
heapgettup(HeapScanDesc scan,
           ScanDirection dir,
           int nkeys,
           ScanKey key)
{
    ...

    /*
     * 预先扫描直到找到符合的元组
     * 
     */
    lpp = PageGetItemId(dp, lineoff);
    for (;;)
    {
        /*
         * if current tuple qualifies, return it.
         */
        valid = HeapTupleSatisfiesVisibility(tuple,
                                             snapshot,
                                             scan->rs_cbuf);

        if (valid)
        {
            return;
        }

        ++lpp;            /* 这个页面的itemId数组向前移动一个索引 */
        ++lineoff;
    }

    ...
}
```

`HeapTupleSatisfiesVisibility` 是一个预处理宏，它将会调用 “satisfies” 功能像 `HeapTupleSatisfiesMVCC` ([在 `tqual.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/utils/time/tqual.c#L962)):

```
bool
HeapTupleSatisfiesMVCC(HeapTuple htup, Snapshot snapshot,
                       Buffer buffer)
{
    ...

    else if (TransactionIdDidCommit(HeapTupleHeaderGetRawXmin(tuple)))
        SetHintBits(tuple, buffer, HEAP_XMIN_COMMITTED,
                    HeapTupleHeaderGetRawXmin(tuple));

    ...

    /* xmax transaction committed */

    return false;
}
```

和 `TransactionIdDidCommit` ([来自 `transam.c`](https://github.com/postgres/postgres/blob/b35006ecccf505d05fd77ce0c820943996ad7ee9/src/backend/access/transam/transam.c#L124)):

```
bool /* true if given transaction committed */
TransactionIdDidCommit(TransactionId transactionId)
{
    XidStatus xidstatus;

    xidstatus = TransactionLogFetch(transactionId);

    /*
     *  如果该事务标记提交，那就提交
     */
    if (xidstatus == TRANSACTION_STATUS_COMMITTED)
        return true;

    ...
}
```

进一步探究 `TransactionLogFetch` 将揭示了它的工作原理。它从给出的事务 ID 计算提交日志中的位置，并通过它获取该事务中的提交状态。事务提交是否用于帮助确定元组的可见性。

关键在于一致性，提交日志被认为是提交状态的标准（还有扩展性，可见性）<sup>[\[3\]](#footnote-3)</sup>。无论 Postgres 是否在数小时前成功提交了事务，或服务器刚刚从崩溃的前几秒中恢复，同样的信息都会被返回。

### 提示位

在从数据可见检查返回之前，从上面的 `HeapTupleSatisfiesMVCC` 上再做一件事:

```
SetHintBits(tuple, buffer, HEAP_XMIN_COMMITTED,
            HeapTupleHeaderGetRawXmin(tuple));
```

核对提交日志去查看元组的 `xmin` 或 `xmax` 事务是否被提交是一个昂贵的操作。避免每次都要访问它，Postgres 会为被扫描的堆元组设置一个特别的提交状态标记（被称为“提示位”）。后续操作可以检查堆提示位并保存到提交日志。

## 盒子的黑墙

当我在数据库运行一个事务：

```
BEGIN;

SELECT * FROM users

INSERT INTO users (email) VALUES ('brandur@example.com')
RETURNING *;

COMMIT;
```

我不会停止思考其中发生什么。我得到一个强大的高级抽象（以 SQL 形式），我知道这样做是可靠的，如我们所看到的，Postgres 在底层做好了所有繁杂的细节工作。好的软件就是一个黑盒子，而 Postgres 是特别黑的那种（尽管有可访问的内部的接口）。

感谢 [Peter Geoghegan](https://twitter.com/petervgeoghegan) 耐心地回答了我所有业余问题，有关 Postgres 事务和快照，和给予我寻找相关源码的指引。

- [1](#footnote-1-source) 提几句建议：Postgres 源码是非常庞大，所以我略写了一些细节，让读者更容易消化。由于 Postgres 还在持续开发中，引用的代码可能会过时。
- [2](#footnote-2-source) 读者可能会注意到，`xmin` and `xmax` 对于跟踪元组的创建和删除是非常适合，但是它们还不足够去处理更新操作。为了达到目的，目前我不会谈论更新操作是如何实现的。
- [3](#footnote-3-source) 注意，提交日志最终将会被截断，但只能在快照的 `xmin` 范围之外，所以在对 WAL 检查之前，需要先对可见性进行检查。

**混乱世界中的稳定：Postgres 如何使事务变得原子化**发表于**旧金山**在 2017 年 8 月 16 日。

**在推特上可以找到我 [@brandur](https://twitter.com/brandur)**
请在 **[Hacker News](https://news.ycombinator.com/item?id=15027870)** 上发表你的见解。
如果文章有错，请 [pull request](https://github.com/brandur/sorg/edit/master/content/articles/postgres-atomicity.md).


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
