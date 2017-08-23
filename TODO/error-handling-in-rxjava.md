
  > * 原文地址：[Error handling in RxJava](https://rongi.github.io/kotlin-blog/rxjava/rx/2017/08/01/error-handling-in-rxjava.html)
  > * 原文作者：[Dmitry Ryadnenko](https://twitter.com/KotlinBlog)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/error-handling-in-rxjava.md](https://github.com/xitu/gold-miner/blob/master/TODO/error-handling-in-rxjava.md)
  > * 译者：[星辰](https://www.zhihu.com/people/tmpbook)
  > * 校对者：[张拭心](https://github.com/shixinzhang) [Liz](https://github.com/lizwangying)

  # RxJava 中的错误处理

  ![Drawing](https://rongi.github.io/kotlin-blog/assets/error-handling-in-rxjava-title.jpg)

一旦你开始使用 RxJava 函数库写代码，你会发现一些东西能有很多不同的实现方式，但是有时你很难立即确定哪种方法最好，错误处理就是其中之一。

那么，在 RxJava 中处理错误的最佳方法是什么，又有哪些选择呢？

## 在 onError 消费者中处理错误

假设你有一个 Observable 可能会产生异常。如何处理呢？第一反应应该是直接在 `onError` 消费者中处理错误。

    userProvider.getUsers().subscribe(
      { users -> onGetUsersSuccess(users) },
      { e -> onGetUsersFail(e) } // 停止执行，显示错误信息等。
    )

它类似于我们以前使用的 `AsyncTasks`，并且看起来很像一个 try-catch 块。

这儿有一个大问题。 假设在 `userProvider.getUsers()` Observable 中存在编程错误，导致 `NullPointerException` 或类似的异常。如果能够立刻崩溃的话就好了，我们可以现场检测出问题并且解决。然而上面的代码中我们无法看到崩溃，因为错误被 onError 处理了，它只会显示一个错误信息或者其他结果。

更糟糕的是，测试时不会有任何崩溃。测试会失败，并伴随着神秘且意想不到的行为。你不得不花时间调试，而不是立即在一个直观/具体的栈中找到原因。

## 预期的和非预期的异常

首先声明，解释下我所谓的预期中的和非预期中的异常。

可预期异常不是说代码出 bug，而是指运行环境有问题。比如各种 IO 异常，无网络异常等。你的软件应该适当的对这些异常产生反应，或者显示错误消息等。预期的异常类似于第二个有效的返回值，它们是方法签名的一部分。

非预期的异常大多是编程错误。它们可以并且将会在开发的时候出现，但是它们永远不应该发生在生产环境中。至少这是一个目标。但是如果它们确实发生了，通常立即使应用崩溃是一个好主意。这有助于提高问题的关注度然后尽快修复之。

在 Java 中，预期中的异常大多是使用受检异常（直接从 `Exception` 类子类化）实现的。而大多数预期之外的异常则是使用从 `RuntimeException` 类派生的未受检异常实现的。

## 运行时崩溃异常

所以，如果我们想要崩溃，为什么不检查异常是否是一个 `RuntimeException`，并在 `onError` 消费者内重新抛出它呢？如果不仅仅像之前的例子那样处理它呢？

    userProvider.getUsers().subscribe(
      { users -> onGetUsersSuccess(users) },
      { e ->
        if (e is RuntimeException) {
          throw e
        } else {
          onGetUsersFail(e)
        }
      }
    )

这可能看起来不错，但它有一些缺陷：

1. 在 RxJava 2 中，非常令人费解的是它会在实时运行的应用中崩溃，而在测试中不会。在 RxJava 1 中，则无论实时运行还是测试都会崩溃。
2. 我们想要崩溃的，除了 `RuntimeException` 之外还有更多未受检异常，这包括 `Error` 等。很难追踪所有的这类异常。

但主要缺点是这样的：

在应用开发过程中，你的 Rx 链将会变得越来越复杂。你的 Observable 也将会在不同的地方被重用，包括你从没料到会使用到的上下文中。

假设你已经决定在这个链中使用 `userProvider.getUsers()` 这个 Observable：

    Observable.concat(userProvider.getUsers(), userProvider.getUsers())
      .onErrorResumeNext(just(emptyList()))
      .subscribe { println(it) }

当两个 `userProvider.getUsers()` 都触发一个错误将会发生什么？

现在，你可能认为这两个错误都分别映射到一个空列表上，因此将会有两个空列表被触发。不过你可能会惊讶的发现，实际上只有一个列表被触发。这是因为第一个 `userProvider.getUsers()` 中发生的错误将会终止整个链的上游， `concat` 的第二个参数永远不会被执行。

你看，RxJava 中的错误是非常具有破坏性的。它们被设计成致命的信号来终止整条链的上游。它们不应该是你的 Observable 接口的一部分。它们表现为意料之外的错误。

Observable 被设计成使用有效输出来表示错误的触发，这限制了它的使用范围。复杂的链在错误的情况下如何工作很不明朗，所以很容易误用这种 Observable 。这最终会导致错误。非常恶心的错误，只能偶尔重现的（特殊情况下，比如缺少网络）而且不会留下堆栈痕迹的错误。

## 结果类

那么，如何设计 Observable 来让其返回预期的错误呢？只需让它们返回一些 `Result` 类，即包含操作的结果也包含异常，就像这样：

    data class Result<out T>(
      val data: T?,
      val error: Throwable?
    )

将所有预期的异常包含进去，然后将所有不可预期的都放行而使程序崩溃。避免使用 `onError` 消费者，让 RxJava 为你控制崩溃。

现在，虽然这种途径看起来不是特别优雅或直观，并且产生了相当多的样板，但是我发现它会导致最少的问题。此外，它看起来像是在 RxJava 中进行错误处理的『官方』方式。我看到过它在互联网的多个讨论中被 RxJava 的维护者所推荐。

## 一些有用的代码段

为了使你的 Retrofit Observable 返回 `Result` 类，你可以使用这个方便的扩展功能：

    fun <T> Observable<T>.retrofitResponseToResult(): Observable<Result<T>> {
      return this.map { it.asResult() }
        .onErrorReturn {
          if (it is HttpException || it is IOException) {
            return@onErrorReturn it.asErrorResult<T>()
          } else {
            throw it
          }
        }
    }

    fun <T> T.asResult(): Result<T> {
      return Result(data = this, error = null)
    }

    fun <T> Throwable.asErrorResult(): Result<T> {
      return Result(data = null, error = this)
    }

这样，你的 Observable `userProvider.getUsers()` 看起来可以像这样：


    class UserProvider {
      fun getUsers(): Observable<Result<List<String>>> {
        return myRetrofitApi.getUsers()
          .retrofitResponseToResult()
      }
    }


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  