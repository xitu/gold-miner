> * 原文地址：[Room 🔗 Coroutines](https://medium.com/androiddevelopers/room-coroutines-422b786dc4c5)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/room-coroutines.md](https://github.com/xitu/gold-miner/blob/master/TODO1/room-coroutines.md)
> * 译者：
> * 校对者：

# Room 🔗 Coroutines

![Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/8418/1*6RyWETnyL2sG7wVUST49YQ.png)

Room 2.1 (currently in alpha) adds support for Kotlin coroutines. DAO methods can now be marked as suspending to ensure that they are not executed on the main thread. By default, Room will use the Architecture Components I/O `Executor` as the `Dispatcher` to run SQL statements, but you can also [supply](https://developer.android.com/reference/androidx/room/RoomDatabase.Builder.html#setQueryExecutor%28java.util.concurrent.Executor%29) your own `Executor` when building the `RoomDatabase`. Read on to see how to use this, how it works under the hood and how to test this new functionality.

> Coroutines support for Room is currently under heavy development, with more features planned to be supported in the future versions of the library.

### Add some suspense to your database

To use coroutines and Room in your app, update to Room 2.1 and add the new dependency to your `build.gradle` file:

```
implementation "androidx.room:room-coroutines:${versions.room}"
```

You’ll also need Kotlin 1.3.0 and [Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html) 1.0.0 or newer.

You can now update your DAO methods to use suspension functions:

```
@Dao
interface UsersDao {

    @Query("SELECT * FROM users")
    suspend fun getUsers(): List<User>

    @Query("UPDATE users SET age = age + 1 WHERE userId = :userId")
    suspend fun incrementUserAge(userId: String)

    @Insert
    suspend fun insertUser(user: User)

    @Update
    suspend fun updateUser(user: User)

    @Delete
    suspend fun deleteUser(user: User)

}
```

DAO with `suspend` methods

[`@Transaction`](https://developer.android.com/reference/android/arch/persistence/room/Transaction) methods can also be suspending and they can call other suspending DAO functions:

```
@Dao
abstract class UsersDao {
    
    @Transaction
    open suspend fun setLoggedInUser(loggedInUser: User) {
        deleteUser(loggedInUser)
        insertUser(loggedInUser)
    }

    @Query("DELETE FROM users")
    abstract fun deleteUser(user: User)

    @Insert
    abstract suspend fun insertUser(user: User)
}
```

DAO with suspend transaction function

Room treats suspending functions differently, based on whether they are called within a transaction or not:

**1. In a transaction**

Room doesn’t do any handling of the CoroutineContext on which the database statement is triggered. It’s the responsibility of the caller of the function to make sure that this is not on a UI thread. Since `suspend` functions can only be called from other `suspend` functions or from coroutines, make sure that the `Dispatcher` you’re using is not [`Dispatcher.Main`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-dispatchers/-main.html), rather [`Dispatchers.IO`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-dispatchers/-i-o.html) or your own custom one.

**2. Not in a transaction**

Room makes sure that the database statement is triggered on the Architecture Components I/O `Dispatcher`. This `Dispatcher` is created based on the same I/O `Executor` used to run `LiveData` work on a background thread.

### Testing DAO suspension functions

Testing a DAO suspending function is no different from testing any other suspending function. For example, to check that after inserting a user we are able to retrieve it, we wrap the test in a [`runBlocking`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/run-blocking.html) block:

```
@Test fun insertAndGetUser() = runBlocking {
    // Given a User that has been inserted into the DB
    userDao.insertUser(user)

    // When getting the Users via the DAO
    val usersFromDb = userDao.getUsers()

    // Then the retrieved Users matches the original user object
    assertEquals(listOf(user), userFromDb)
}
```

Testing DAO suspend functions

### Under the hood

To see what’s under the hood, let’s take a look at the DAO class implementation Room generates for a synchronous and for a suspending insert:

```
@Insert
fun insertUserSync(user: User)

@Insert
suspend fun insertUser(user: User)
```

Synchronous and suspending insert functions

For the synchronous insert, the generated code starts a transaction, executes the insert, marks the transaction as successful and ends it. The synchronous method will just execute the insert on whatever thread it’s called from.

```
@Override
public void insertUserSync(final User user) {
  __db.beginTransaction();
  try {
    __insertionAdapterOfUser.insert(user);
    __db.setTransactionSuccessful();
  } finally {
    __db.endTransaction();
  }
}
```

Room synchronous insert generated implementation

Now let’s see how adding the suspend modifier changes things: the generated code will make sure that your data gets inserted but also that this happens off of the UI thread.

The generated code passes a continuation and the data to be inserted. The same logic from the synchronous insert method is used but within a `Callable#call` method.

```
@Override
public Object insertUserSuspend(final User user,
    final Continuation<? super Unit> p1) {
  return CoroutinesRoom.execute(__db, new Callable<Unit>() {
    @Override
    public Unit call() throws Exception {
      __db.beginTransaction();
      try {
        __insertionAdapterOfUser.insert(user);
        __db.setTransactionSuccessful();
        return kotlin.Unit.INSTANCE;
      } finally {
        __db.endTransaction();
      }
    }
  }, p1);
}
```

Room suspending insert generated implementation

The interesting part though is the `CoroutinesRoom.execute` function, since this is the one that handles the context switch, depending on whether the database is opened and we are in a transaction or not.

**Case 1. The database is opened and we are in a transaction**

Here we’re just triggering the call method — i.e. the actual insertion of the user in the database

**Case 2. We’re not in a transaction**

Room makes sure that the work done in the `Callable#call` method is performed on a background thread by using the Architecture Components IO `Executor`.

```
suspend fun <R> execute(db: RoomDatabase, callable: Callable<R>): R {
   if (db.isOpen && db.inTransaction()) {
       return callable.call()
   }
   return withContext(db.queryExecutor.asCoroutineDispatcher()) {
       callable.call()
   }
}
```

CoroutinesRoom.execute implementation

* * *

Start using Room and coroutines in your app, the database work is guaranteed to be run on a non-UI Dispatcher. Mark your DAO method with the `suspend` modifier and call them from other suspend functions or coroutines!

Thanks to [Chris Banes](https://medium.com/@chrisbanes?source=post_page) and [Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
