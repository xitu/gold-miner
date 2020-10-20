> * 原文地址：[Room 🔗 Coroutines](https://medium.com/androiddevelopers/room-coroutines-422b786dc4c5)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/room-coroutines.md](https://github.com/xitu/gold-miner/blob/master/TODO1/room-coroutines.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[fireairforce](https://github.com/fireairforce)

# Room 🔗 Coroutines

![Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/8418/1*6RyWETnyL2sG7wVUST49YQ.png)

Room 2.1（目前为 alpha 版本）添加了对 Kotlin 协程的支持。DAO 方法现在可以被标记为挂起以确保他们不会在主线程执行。默认情况下，Room 会使用架构组件 I/O `Executor` 作为 `Dispatcher` 来执行 SQL 语句，但在构建 `RoomDatabase` 的时候你也可以[提供](https://developer.android.com/reference/androidx/room/RoomDatabase.Builder.html#setQueryExecutor%28java.util.concurrent.Executor%29)自己的 `Executor`。请继续阅读以了解如何使用它、引擎内部的工作原理以及如何测试该项新功能。

> 目前，Coroutines 对 Room 的支持正在大力开发中，该库的未来版本中将会增加更多的特性。

### 给你的数据库添加 suspense 特性

为了在你的 app 中使用协程和 Room，需将 Room 升级为 2.1 版本并在 `build.gradle` 文件中添加新的依赖：

```
implementation "androidx.room:room-coroutines:${versions.room}"
```

你还需要 Kotlin 1.3.0 和 [Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html) 1.0.0 及以上版本。

现在，你可以更新 DAO 方法来使用挂起函数了：

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

具有 `suspend` 方法的 DAO

[`@Transaction`](https://developer.android.com/reference/android/arch/persistence/room/Transaction) 方法也可以挂起，并且可以调用其他挂起的 DAO 方法：

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

具有挂起事务功能的 DAO

Room 会根据是否在事务内调用挂起方法进行区别对待：

**1. 事务内**

Room 不会对触发数据库语句的协程上下文（CoroutineContext）做任何处理。方法调用者有责任确保当前不是在 UI 线程。由于 `suspend` 方法只能在其他 `suspend` 方法或协程中调用，因此需确保你使用的 `Dispatcher` 是 [`Dispatchers.IO`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-dispatchers/-i-o.html) 或自定义的，而不是 [`Dispatcher.Main`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-dispatchers/-main.html)。

**2. 事务外**

Room 会确保数据库语句是在架构组件 I/O `Dispatcher` 上被触发。该 `Dispatcher` 是基于使处于后台工作的 `LiveData` 运行起来的同一 I/O `Executor` 而创建的。

### 测试 DAO 挂起方法

测试 DAO 的挂起方法与测试其他挂起方法一般无二。例如，为了测试在插入一个用户后我们还可以取到它，我们将测试代码包含在一个 [`runBlocking`](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/run-blocking.html) 代码块中：

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

测试 DAO 的挂起方法

### 原理

为了能够了解原理，让我们看一下 Room 为同步的和挂起的插入方法生成的 DAO 实现类：

```
@Insert
fun insertUserSync(user: User)

@Insert
suspend fun insertUser(user: User)
```

同步的和挂起的插入方法

对于同步插入而言，生成的代码开启了一个事务，执行插入操作，将事务标记为成功并结束。同步方法只会在调用它的线程中执行插入操作。

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

Room 对同步插入生成的实现代码

再看一下添加 suspend 修饰符后发生的变化：生成的代码会确保数据在非 UI 线程上被插入。

生成的代码传入了一个 continution 和待插入的数据。使用了和同步插入方法相同的逻辑，不同的是它在一个 `Callable#call` 方法中执行。

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

Room 对挂起插入生成的实现代码

不过有趣的是 `CoroutinesRoom.execute` 方法，这是一个根据数据库是否打开以及是否处于事务内来处理上下文切换的方法。

**情形 1. 数据库被打开同时处于事务内**

这种情况下只触发了 call 方法，即用户在数据库中的实际插入操作

**情形 2. 非事务**

Room 通过架构组件 IO `Executor` 来确保 `Callable#call` 中的操作是在后台线程中完成的。

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

CoroutinesRoom.execute 实现

* * *

现在就开始在你的 app 中使用 Room 和协程吧，保证数据库的操作在一个非 UI 分发器上执行。在 DAO 方法上添加 `suspend` 修饰符并在其他 supend 方法或者协程中调用。

感谢 [Chris Banes](https://medium.com/@chrisbanes?source=post_page) 和 [Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
