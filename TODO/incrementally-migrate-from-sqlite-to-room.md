> * 原文地址：[Incrementally migrate from SQLite to Room](https://medium.com/google-developers/incrementally-migrate-from-sqlite-to-room-66c2f655b377)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/incrementally-migrate-from-sqlite-to-room.md](https://github.com/xitu/gold-miner/blob/master/TODO/incrementally-migrate-from-sqlite-to-room.md)
> * 译者：[IllllllIIl](https://github.com/IllllllIIl)
> * 校对者：[tanglie1993](https://github.com/tanglie1993), [jaymz1439](https://github.com/jaymz1439)

# 从 SQLite 逐步迁移到 Room

![](https://cdn-images-1.medium.com/max/2000/1*zoWpyj2lq7EpWiRuIhBwuQ.png)

通过可管理的 PR 将复杂的数据库迁移到 Room

你已经听说过 Room 了吧 —— 或许你已经看过[文档](https://developer.android.com/topic/libraries/architecture/room.html)，看过[一个](https://www.youtube.com/watch?v=H7I3zs-L-1w)或[两个](https://youtu.be/DeIKyVfCvC0)视频，并且决定开始整合 Room 到你的项目中。如果你的数据库只有几张表和简单查询的话，你可以很容易地跟着下面这 7 个步骤，通过较小改动的类似 pull request 操作迁移到 Room。

- [**7 Steps To Room**: A step by step guide on how to migrate your app to Room medium.com](https://medium.com/google-developers/7-steps-to-room-27a5fe5f99b2)

不过，如果你的数据库较大或者有复杂的查询操作的话，实现所有 entity 类，DAO 类，DAO的测试类并且替换 `SQLiteOpenHelper` 的使用就会耗费很多时间。你最终会需要一个大改动的 pull request，去实现这些和检查。让我们看看你怎么通过可管理的 PR（pull request），逐步从 SQLite 迁移到 Room。 

#### 文长不读的话，可以看下面的概括点：

> **第一个 PR**：创建你的 **entity** 类，**RoomDatabase**，并且更新你自定义的  SQLiteOpenHelper 为 [**SupportSQLiteOpenHelper**](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteOpenHelper.html)。

> **其余的 PR**：创建 DAO 类去代替有 Cursor 和 ContentValue 的代码。

### 项目设置

我们考虑有以下这些情况：

* 我们的数据库有 10 张表，每张有一个相应的 model 对象。例如，如果有 users 表的话，我们有相应的 User 对象。
* 一个继承自 `SQLiteOpenHelper` 的 `CustomDbHelper`。
* `LocalDataSource` 类，这个是通过 `CustomDbHelper` 访问数据库的类。
* 我们有一些对 `LocalDataSource` 类的测试。

### 第一个 PR

你第一个 PR 会包含设置 Room 所需的最小幅度改动操作。

#### 创建 entity 类

如果你已经有每张表数据的 model 对象类，就只用添加 [`@Entity`](https://developer.android.com/reference/android/arch/persistence/room/Entity.html)， [`@PrimaryKey`](https://developer.android.com/reference/android/arch/persistence/room/PrimaryKey.html) 和 [`@ColumnInfo`](https://developer.android.com/reference/android/arch/persistence/room/ColumnInfo.html) 的注解。

```
+ @Entity(tableName = "users")
  public class User {

    + @PrimaryKey
    + @ColumnInfo(name = "userid")
      private int mId;

    + @ColumnInfo(name = "username")
      private String mUserName;

      public User(int id, String userName) {
          this.mId = id;
          this.mUserName = userName;
      }

      public int getId() { return mId; }

      public String getUserName() { return mUserName; }
}
```

#### 创建 Room 数据库

创建一个继承 [`RoomDatabase`](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.html) 的抽象类。在 [`@Database`](https://developer.android.com/reference/android/arch/persistence/room/Database.html) 注解中，列出所有你已创建的 entity 类。现在，我们就不用再创建 DAO 类了。

更新你数据库版本号并生成一个 Migration 对象。如果你没改数据库的 schema，你仍需要生成一个空的 Migration 对象让 Room 保留已有的数据。


```
@Database(entities = {<all entity classes>}, 
          version = <incremented_sqlite_version>)
public abstract class AppDatabase extends RoomDatabase {
    private static UsersDatabase INSTANCE;
    static final Migration      MIGRATION_<sqlite_version>_<incremented_sqlite_version> 
= new Migration(<sqlite_version>, <incremented_sqlite_version>) {
         @Override public void migrate(
                    SupportSQLiteDatabase database) {
           // 因为我们并没有对表进行更改，
           // 所以这里没有什么要做的 
         }
    };
```

### 更新使用 SQLiteOpenHelper 的类

一开始，我们的 `LocalDataSource` 类使用 `CustomOpenHelper` 进行工作，现在我要把它更新为使用 `**SupportSQLiteOpenHelper**`，这个类可以从  [`RoomDatabase.getOpenHelper()`](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.html#getOpenHelper%28%29) 获得。

```
public class LocalUserDataSource {
    private SupportSQLiteOpenHelper mDbHelper;
    LocalUserDataSource(@NonNull SupportSQLiteOpenHelper helper) {
       mDbHelper = helper;
    }
```

因为 `SupportSQLiteOpenHelper` 并不是直接继承 `SQLiteOpenHelper`，而是对它的一层包装，我们需要更改获得可写可读数据库的调用方式，并使用 `SupportSQLiteDatabase` 而不再是 `SQLiteDatabase`。

```
SupportSQLiteDatabase db = mDbHelper.getWritableDatabase();
```

[`SupportSQLiteDatabase`](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteDatabase.html) 是一个数据库抽象层，提供类似 `SQLiteDatabase` 中的方法。因为它提供了一个更简洁的 API 去执行插入和查询数据库的操作，代码相比以前也需要做一些改动。

对于插入操作，Room 移除了可选的 `nullColumnHack` 参数。使用 [`SupportSQLiteDatabase.insert`](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteDatabase.html#insert%28java.lang.String,%20int,%20android.content.ContentValues%29) 代替 [`SQLiteDatabase.insertWithOnConflict`](https://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html#insertWithOnConflict%28java.lang.String,%20java.lang.String,%20android.content.ContentValues,%20int%29)。
```
@Override
public void insertOrUpdateUser(User user) {
    SupportSQLiteDatabase db = mDbHelper.getWritableDatabase();

    ContentValues values = new ContentValues();
    values.put(COLUMN_NAME_ENTRY_ID, user.getId());
    values.put(COLUMN_NAME_USERNAME, user.getUserName());

    - db.insertWithOnConflict(TABLE_NAME, null, values,
    -        SQLiteDatabase.CONFLICT_REPLACE);
    + db.insert(TABLE_NAME, SQLiteDatabase.CONFLICT_REPLACE,
    + values);
    db.close();
}
```

要查询的话，`SupportSQLiteDatabase` 提供了4种方法：

```
Cursor query(String query);
Cursor query(String query, Object[] bindArgs);
Cursor query(SupportSQLiteQuery query);
Cursor query(SupportSQLiteQuery query, CancellationSignal cancellationSignal);
```

如果你只是简单地使用原始的查询操作，那在这里就没有什么要改的。如果你的查询是较复杂的，你就得通过 [`SupportSQLiteQueryBuilder`](https://developer.android.com/reference/android/database/sqlite/SQLiteQueryBuilder.html) 创建一个 [`SupportSQLiteQuery`](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteQuery.html)。

举个例子，我们有一个 `users` 表，只想获得表中按名字排序的第一个用户。下面就是实现方法在`SQLiteDatabase` 和 `SupportSQLiteDatabase` 中的区别。

```
public User getFirstUserAlphabetically() {
        User user = null;
        SupportSQLiteDatabase db = mDbHelper.getReadableDatabase();
        String[] projection = {
                COLUMN_NAME_ENTRY_ID,
                COLUMN_NAME_USERNAME
        };
    
        // 按字母顺序从表中获取第一个用户
        - Cursor cursor = db.query(TABLE_NAME, projection, null,
        - null, null, null, COLUMN_NAME_USERNAME + “ ASC “, “1”);
        
        + SupportSQLiteQuery query =
        +  SupportSQLiteQueryBuilder.builder(TABLE_NAME)
        +                           .columns(projection)
        +                           .orderBy(COLUMN_NAME_USERNAME)
        +                           .limit(“1”)
        +                           .create();
        
        + Cursor cursor = db.query(query);
        
        if (c !=null && c.getCount() > 0){
            // read data from cursor
              ...
        }
        if (c !=null){
            cursor.close();
        }
        db.close();
        return user;
    }
```

> 如果你没有对你的 SQLiteOpenHelper 实现类进行测试的话，那我强烈推荐你先测试下再进行这个迁移的工作，避免产生相关 bug。

### 其余的 PR

既然你的数据层已经在使用 Room，你可以开始逐渐创建 DAO 类（附带测试）并通过 DAO 的调用替代 `Cursor` 和 `ContentValue` 的代码。

像在 `users` 表中按名字顺序查询第一个用户这个操作应该定义在 `UserDao` 接口中。

```
@Dao
public interface UserDao {
    @Query(“SELECT * FROM Users ORDERED BY name ASC LIMIT 1”)
    User getFirstUserAlphabetically();
}
```

这个方法会在 `LocalDataSource` 中被调用。

```
public class LocalDataSource {
     private UserDao mUserDao;
     public User getFirstUserAlphabetically() {
        return mUserDao.getFirstUserAlphabetically();
     }
}
```

* * *

在单一一个 PR 中，把 SQLite 迁移一个大型的数据库到 Room 会生成很多新文件和更新过后的文件。这需要一定时间去实现，因此导致 PR 更难检查。在最开始的 PR，先使用 `RoomDatabase` 提供的 OpenHelper 从而让代码最小程度地改动，然后在接下来的 PR 中才逐渐创建 DAO 类去替换 `Cursor` 和 `ContentValue` 的代码。

想了解 Room 的更多相关信息，请阅读下面这些文章：

- [**7 Pro-tips for Room**: _Learn how you can get the most out of Room_medium.com](https://medium.com/google-developers/7-pro-tips-for-room-fbadea4bfbd1)
- [**Understanding migrations with Room**: _Performing database migrations with the SQLite API always made me feel like I was defusing a bomb — as if I was one…_medium.com](https://medium.com/google-developers/understanding-migrations-with-room-f01e04b07929)
- [**Testing Room migrations**: _In a previous post I explained how database migrations with Room work under the hood. We saw that an incorrect…_medium.com](https://medium.com/google-developers/testing-room-migrations-be93cdb0d975)
- [**Room 🔗 RxJava**: _Doing queries in Room with RxJava_medium.com](https://medium.com/google-developers/room-rxjava-acb0cd4f3757)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
