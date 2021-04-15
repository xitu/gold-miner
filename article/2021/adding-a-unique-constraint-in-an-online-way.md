> this article assumes using Enterprise Edition

I have a table t and I want to add a unique constraint on one of its columns -- c1.

## The Offline Way

The straightforward and most simple way to do it is using a single alter table statement:

```SQL
SQL> alter table t add constraint c1_uk unique (c1);

Table altered.
```

By default, Oracle creates in this operation a unique constraint (named c1_uk) and a corresponding unique index (named c1_uk as well) that enforces the constraint.\
The downside is that this is an offline operation -- the table is locked in Share mode.

This is true even if we specify that the creation of the index is online:

```SQL
SQL> alter table t add constraint c1_uk unique (c1) using index online;

Table altered.
```

If the table contains many records, the creation of the index may take a significant amount of time, during which the table is locked and DML operations on the table are blocked.

## The Online Way

We can create the unique constraint in an online way, by splitting the operation into three steps:

### STEP 1: CREATING THE UNIQUE INDEX EXPLICITLY

Instead of letting Oracle create the index implicitly, we'll create it explicitly, using the online keyword:

```
SQL> create unique index c1_uk on t(c1) online;

Index created.
```

This operation may take some time, depending on the size of the table, but it is an online operation.

### STEP 2: CREATING THE CONSTRAINT

Now we can add the constraint, and associate it with the already-existing index. This is a fast operation, as the index already exists, but the default alter table... add constraint operation is an offline one. To make it online we should create the constraint as NOT VALIDATED:

```
SQL> alter table t add constraint c1_uk unique (c1)
  2  using index c1_uk
  3  enable novalidate;

Table altered.
```

So now the constraint is marked as ENABLED, which means that future DML statements will not be able to violate it, and as NOT VALIDATED, which means that existing records may violate it:

```
SQL> select status,validated,generated,index_name
  2  from user_constraints
  3  where constraint_name='C1_UK';

STATUS     VALIDATED       GENERATED  INDEX_NAME
---------- --------------- ---------- ----------
ENABLED    NOT VALIDATED   USER NAME  C1_UK
```

De facto we know that no existing record violates the constraint, because the unique index enforces the uniqueness for the entire table. To make this fact "officially documented", we'll go to the third step.

### STEP 3: VALIDATING THE CONSTRAINT

To mark the constraint as VALIDATED, we'll issue the following statement:

```
SQL> alter table t enable validate constraint c1_uk;

Table altered.
```

This is an online operation, but is it also a fast operation?\
When we validate a check constraint or a foreign key constraint, Oracle scans all the records in the table to make sure no record violates the constraint, and for big tables this may take a significant amount of time.

But in our case Oracle knows that the unique index already enforces the constraint for all the existing records in the table, and it optimizes the validation phase.\
Using SQL trace we can see that the query that performs the actual validation looks like this:

```
select /*+ all_rows ordered dynamic_sampling(2) */ A.rowid, :1, :2, :3
from "DEMO"."T" A
where 1=0
```

so this validation phase is fast, regardless of the size of the table, as the validation does not visit the table records at all.

## Enforcing a Unique Constraint by a Non-Unique Index

Oracle can enforce a unique constraint also by using a non-unique index, as long as the columns in the constraint are the leading columns of the index.

Let's repeat the steps from the previous section with a non-unique index (after dropping and recreating the table).

```
SQL> create /* non-unique */ index c1_idx on t(c1) online;

Index created.

SQL> alter table t add constraint c1_uk unique (c1)
  2  using index c1_idx
  3  enable novalidate;

Table altered.

SQL> alter table t enable validate constraint c1_uk;

Table altered.
```

In this case the third step is not just a "rubber stamp", as it was when we used a unique index. Here the existing records should be actually validated, and indeed we can see it in the trace file:

```
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
