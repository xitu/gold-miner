> * 原文地址：[Advanced Kotlin Coroutines tips and tricks](https://proandroiddev.com/coroutines-snags-6bf6fb53a3d1)
> * 原文作者：[Alex Saveau](https://proandroiddev.com/@SUPERCILEX?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/coroutines-snags.md](https://github.com/xitu/gold-miner/blob/master/TODO1/coroutines-snags.md)
> * 译者：
> * 校对者：

# Advanced Kotlin Coroutines tips and tricks

## Learn about a few snags and how to get around them

![](https://cdn-images-1.medium.com/max/800/1*xGP1VG9jCjZN1VqFKgrL9A.png)

Coroutines are stable as of 1.3!

Kotlin Coroutines starts off incredibly simple: just put some long running operation in `launch` and you’re good, right? For simple cases, sure. But pretty soon, the complexity inherent to concurrency and parallelism starts piling up.

Here’s what you need to know when you’re knee deep in the coroutine trenches.

### Cancellation + blocking work = 😈

There’s no way to get around it: you’ll have to use good ol’ Java streams at some point or another. One problem (of many 😉) with streams is that they block the current thread. That’s bad news in the coroutines world. Now, if you want to cancel a coroutine, you’ll have to wait for the read or write to complete before you can continue.

As a simple reproducible example, let’s say you open a `ServerSocket` and wait for a connection with a 1 second timeout:

```
runBlocking(Dispatchers.IO) {
    withTimeout(1000) {
        val socket = ServerSocket(42)
        
         // We're stuck here forever until someone accepts. Don't you want to know the answer? 😜
        socket.accept()
    }
}
```

Should work, right? Nope.

Now you’re feeling a bit like this: 😖. So how do we fix it?

When `Closeable` APIs are well built, they support closing the stream from any thread and will fail appropriately.

> Note: in general, APIs from the JDK follow those best practices, but beware of any third party `Closeable` APIs that may not. You’ve been warned.

Thanks to the `suspendCancellableCoroutine` function, we can close any stream when a coroutine is cancelled:

```
public suspend inline fun <T : Closeable?, R> T.useCancellably(
        crossinline block: (T) -> R
): R = suspendCancellableCoroutine { cont ->
    cont.invokeOnCancellation { this?.close() }
    cont.resume(use(block))
}
```

Be sure this works with the API you are using!

Now that our blocking `accept` call is wrapped in `useCancellably`, the coroutine will fail when the timeout occurs.

```
runBlocking(Dispatchers.IO) {
    withTimeout(1000) {
        val socket = ServerSocket(42)

        // Blows up with `SocketException: socket closed`. Yay!
        socket.useCancellably { it.accept() }
    }
}
```

Success!

But what if you can’t support cancellation at all? Here’s what you need to watch out for:

*   If you use any instance properties/functions from your coroutine’s enclosing class, it will be leaked even if you cancel the coroutine. This is especially relevant if you think you’re cleaning up resources in `onDestroy`. **Workaround:** move the coroutine to a `ViewModel` or other non-context class and subscribe to its result.
*   Make sure to use `Dispatchers.IO` for blocking work since that allows Kotlin to set aside some threads that it expects to be waiting indefinitely.
*   Use `suspendCancellableCoroutine` over `suspendCoroutine` wherever possible.

### `launch` vs. `async`

Since the top SO answers about these two builders are out-of-date, I thought I’d touch upon their differences again.

#### `launch` bubbles up exceptions

When a coroutines crashes, its parent is cancelled which in turn cancels all the parent’s children. Once coroutines throughout the tree have finished cancelling, the exception is sent to the current context’s exception handler. On Android, that means _your app will crash_, regardless of what dispatcher you were using.

#### `async` holds on to its exceptions

That means `await()` explicitly handles all exceptions and installing a `CoroutineExceptionHandler` will have no effect.

#### `launch` “blocks” the parent scope

While the function will return immediately, its parent scope will _not_ finish until all coroutines built with `launch` have completed one way or another. This makes calling `join()` for all your child jobs at the end of the parent unnecessary if you simply want to wait for those coroutines to finish.

Unlike what you might expect, the outer scope will still wait for `async` coroutines to complete even if `await()` is not called.

#### `async` returns a result

This one’s pretty simple: if you need a result out of your coroutine, `async` is your only option. If you don’t need a result, use `launch` to create side effects. And only if you need those side effects to complete before moving on do you need to use `join()`.

#### `join()` vs. `await()`

`join()` does _not_ rethrow exceptions while `await()` will. However, `join()` cancels your coroutine if an error occurred, meaning any code after the suspending call to `join()` is not invoked.

### Logging exceptions

Now that you understand how differently exceptions are handled depending on which builder you use, you’re left with a dilemma: you want to log exceptions without crashing (so we can’t use `launch`), but you don’t want to manually `try`/`catch` them all (so we can’t use `async`). So that leaves us with… nothing? Thankfully not.

Logging exceptions is where the `CoroutineExceptionHandler` comes in handy. But first, let’s take a moment to understand what actually happens when an exception is thrown in a coroutine:

1.  The exception is caught and then resumed through a `Continuation`.
2.  If your code doesn’t handle the exception and it isn’t a `CancellationException`, the first `CoroutineExceptionHandler` is requested through the current `CoroutineContext`.
3.  If a handler isn’t found or it errors, the exception is sent to platform specific code.
4.  On the JVM, a `ServiceLoader` is used to locate global handlers.
5.  Once all handlers have been invoked or one of them errors, the current thread’s exception handler gets invoked.
6.  If the current thread doesn’t handle the exception, it bubbles up to the thread group and then finally to the default exception handler.
7.  Crash!

With that in mind, we have a few options:

*   Install a handler per thread, but that’s not realistic.
*   Install the default handler, but then errors from the main thread won’t crash your app and you’ll be left in a potentially bad state.
*   [Add the handler as a service](https://gist.github.com/SUPERCILEX/f4b01ccf6fd4ef7ec0a85dbd59c89d6c) which will be invoked when any coroutine built with `launch` crashes (hacky).
*   Use your own custom scope with a handler attached instead of `GlobalScope` or add the handler to every scope you use, but that’s annoying and makes logging optional instead of the default.

That last solution is preferred because it is flexible while requiring minimal code and hacks.

For app wide jobs, you’ll use an `AppScope` with a logging handler. For any other jobs, you can add the handler when logging is appropriate over crashing.

```
val LoggingExceptionHandler = CoroutineExceptionHandler { _, t ->
    Crashlytics.logException(t)
}
val AppScope = GlobalScope + LoggingExceptionHandler
```

```
class ViewModelBase : ViewModel(), CoroutineScope {
    override val coroutineContext = Job() + LoggingExceptionHandler

    override fun onCleared() = coroutineContext.cancel()
}
```

Not too shabby

### Closing thoughts

Anytime we have to deal with edge cases, things get messy pretty fast. I hope this article helped you understand the variety of problems you can run into given subpar conditions and what potential solutions you can apply.

Happy Kotlining!

* [**Alex Saveau (@SUPERCILEX) | Twitter**: The latest Tweets from Alex Saveau (@SUPERCILEX). All things 🔥base, Android, and open-source. Also, 🐤 builds...](https://twitter.com/SUPERCILEX "https://twitter.com/SUPERCILEX")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
