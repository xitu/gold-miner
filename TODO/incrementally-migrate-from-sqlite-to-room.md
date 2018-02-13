> * 原文地址：[Incrementally migrate from SQLite to Room](https://medium.com/google-developers/incrementally-migrate-from-sqlite-to-room-66c2f655b377)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/incrementally-migrate-from-sqlite-to-room.md](https://github.com/xitu/gold-miner/blob/master/TODO/incrementally-migrate-from-sqlite-to-room.md)
> * 译者：
> * 校对者：

# Incrementally migrate from SQLite to Room

![](https://cdn-images-1.medium.com/max/2000/1*zoWpyj2lq7EpWiRuIhBwuQ.png)

_Migrate your complex database to Room with manageable PRs._

You’ve heard about Room — perhaps you checked out the [documentation](https://developer.android.com/topic/libraries/architecture/room.html), watched a [video](https://www.youtube.com/watch?v=H7I3zs-L-1w) or [two](https://youtu.be/DeIKyVfCvC0), and decided to start integrating Room into your project. If your database has only a few tables and simple queries, you can easily migrate with a relatively small pull request by following these 7 steps to Room.

- [**7 Steps To Room**: _A step by step guide on how to migrate your app to Room_medium.com](https://medium.com/google-developers/7-steps-to-room-27a5fe5f99b2)

However, if your database is larger or has complex queries, implementing all the entities, DAOs, tests for the DAOs, and replacing usages of `SQLiteOpenHelper` can take a long time; you’ll end up with a big pull request that will take time to implement and review. Let’s see how you can gradually migrate from SQLite to Room, with manageable PRs.

#### TL;DR:

> **_First PR_**_: Create your_ **_entity_** _classes, the_ **_RoomDatabase_**_, and update from your custom SQLiteOpenHelper to_ [**_SupportSQLiteOpenHelper_**](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteOpenHelper.html)_._

> **_Following PRs_**_: Gradually create_ **_DAOs_** _to replace Cursor and ContentValue code._

### Project setup

Let’s consider the following:

* Our database has 10 tables, each with a corresponding model object. E.g. for the `users` table, we have a corresponding `User` object.
* A `CustomDbHelper` class extends `SQLiteOpenHelper`
* The class that works with the `CustomDbHelper` to access the database is the `LocalDataSource`.
* We have tests for `LocalDataSource`.

### First PR

Your initial PR will contain the minimum amount of changes that are needed to setup the Room database.

#### Create the entity classes

If you already have data model objects for every table, just add the `[@Entity](https://developer.android.com/reference/android/arch/persistence/room/Entity.html)`, `[@PrimaryKe](https://developer.android.com/reference/android/arch/persistence/room/PrimaryKey.html)y` and `[@ColumnInfo](https://developer.android.com/reference/android/arch/persistence/room/ColumnInfo.html)` annotations.

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

#### Create the Room database

Create an abstract class extending `[RoomDatabase](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.html)`. In the `[@Database](https://developer.android.com/reference/android/arch/persistence/room/Database.html)` annotation, list all the entity classes you’ve created. For now, we don’t need to create DAO classes.

Increment your database version number and implement a migration. If you didn’t change the database schema, you’ll still need to implement an empty migration to tell Room to keep the existing data.

```
@Database(entities = {<all entity classes>}, 
          version = <incremented_sqlite_version>)
public abstract class AppDatabase extends RoomDatabase {
    private static UsersDatabase INSTANCE;
    static final Migration      MIGRATION_<sqlite_version>_<incremented_sqlite_version> 
= new Migration(<sqlite_version>, <incremented_sqlite_version>) {
         @Override public void migrate(
                    SupportSQLiteDatabase database) {
           // Since we didn’t alter the table, there’s nothing else 
           // to do here.
         }
    };
```

### Update the class that works with SQLiteOpenHelper

Initially, our `LocalDataSource` worked with a `CustomOpenHelper` class. We’ll update this to use the `**SupportSQLiteOpenHelper**` from the `[RoomDatabase.getOpenHelper()](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.html#getOpenHelper%28%29)`.

```
public class LocalUserDataSource {
    private SupportSQLiteOpenHelper mDbHelper;
    LocalUserDataSource(@NonNull SupportSQLiteOpenHelper helper) {
       mDbHelper = helper;
    }
```

Because `SupportSQLiteOpenHelper` doesn’t directly extend `SQLiteOpenHelper` but instead is a wrapper over it, we need to update calls to get the writable and readable database and use `SupportSQLiteDatabase` instead of `SQLiteDatabase`.

```
SupportSQLiteDatabase db = mDbHelper.getWritableDatabase();
```

`[SupportSQLiteDatabase](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteDatabase.html)` is a database abstraction that provides similar methods to the `SQLiteDatabase`. Because it provides a cleaner API for inserting and querying the database, some changes in the code will be required.

For insert, Room removes the optional `nullColumnHack` parameter. Instead of `[SQLiteDatabase.insertWithOnConflict](https://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html#insertWithOnConflict%28java.lang.String,%20java.lang.String,%20android.content.ContentValues,%20int%29)`, use `[SupportSQLiteDatabase.insert](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteDatabase.html#insert%28java.lang.String,%20int,%20android.content.ContentValues%29)`.

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

For queries, `SupportSQLiteDatabase` provides 4 methods:

```
Cursor query(String query);
Cursor query(String query, Object[] bindArgs);
Cursor query(SupportSQLiteQuery query);
Cursor query(SupportSQLiteQuery query, CancellationSignal cancellationSignal);
```

If you’re using raw queries, then no changes will be required. If your queries are more complex, you’ll have to create a `[SupportSQLiteQuery](https://developer.android.com/reference/android/arch/persistence/db/SupportSQLiteQuery.html)` via `[SupportSQLiteQueryBuilder](https://developer.android.com/reference/android/database/sqlite/SQLiteQueryBuilder.html)`.

For example, we have a `users` table and we want to get only the first user in the table, ordered by name. Here’s how the method would look like with `SQLiteDatabase` vs `SupportSQLiteDatabase`.

```
public User getFirstUserAlphabetically() {
        User user = null;
        SupportSQLiteDatabase db = mDbHelper.getReadableDatabase();
        String[] projection = {
                COLUMN_NAME_ENTRY_ID,
                COLUMN_NAME_USERNAME
        };
    
        // Get the first user from the table ordered alphabetically
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

> If you don’t have **tests** for the usages of your SQLiteOpenHelper implementation, I strongly recommend writing tests first then working on the migration to Room, to decrease the risks of regression issues.

### Following PRs

Now that your data layer is using Room, you can start to gradually create DAOs (with tests) and replace the `Cursor` and `ContentValue` code with DAO calls.

The query that gets the first user from the `users` table ordered by name would be defined in the `UserDao` class.

```
@Dao
public interface UserDao {
    @Query(“SELECT * FROM Users ORDERED BY name ASC LIMIT 1”)
    User getFirstUserAlphabetically();
}
```

The method will then be used in the `LocalDataSource`.

```
public class LocalDataSource {
     private UserDao mUserDao;
     public User getFirstUserAlphabetically() {
        return mUserDao.getFirstUserAlphabetically();
     }
}
```

* * *

Moving a large database from SQLite to Room in a single PR will contain a lot of new and updated files; it can take quite some time to implement and consequently make the PR harder to review. Use the OpenHelper exposed by `RoomDatabase` to make minimal changes to your code for the initial PR and then gradually add DAOs to replace the `Cursor` and `ContentValue` code in follow up PRs.

For more info on Room, check out these articles:

- [**7 Pro-tips for Room**: _Learn how you can get the most out of Room_medium.com](https://medium.com/google-developers/7-pro-tips-for-room-fbadea4bfbd1)
- [**Understanding migrations with Room**: _Performing database migrations with the SQLite API always made me feel like I was defusing a bomb — as if I was one…_medium.com](https://medium.com/google-developers/understanding-migrations-with-room-f01e04b07929)
- [**Testing Room migrations**: _In a previous post I explained how database migrations with Room work under the hood. We saw that an incorrect…_medium.com](https://medium.com/google-developers/testing-room-migrations-be93cdb0d975)
- [**Room 🔗 RxJava**: _Doing queries in Room with RxJava_medium.com](https://medium.com/google-developers/room-rxjava-acb0cd4f3757)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
