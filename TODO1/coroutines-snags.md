> * 原文地址：[Advanced Kotlin Coroutines tips and tricks](https://proandroiddev.com/coroutines-snags-6bf6fb53a3d1)
> * 原文作者：[Alex Saveau](https://proandroiddev.com/@SUPERCILEX?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/coroutines-snags.md](https://github.com/xitu/gold-miner/blob/master/TODO1/coroutines-snags.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[zx-Zhu](https://github.com/zx-Zhu)

# Kotlin 协程高级使用技巧

## 学习一些障碍以及如何绕过它们

![](https://cdn-images-1.medium.com/max/800/1*xGP1VG9jCjZN1VqFKgrL9A.png)

协程从 1.3 开始成为稳定版！

开始 Kotlin 协程非常简单：只需将一些耗时操作放在 `launch` 中即可，你做到了，对不？当然，这是针对简单的情况。但很快，并发与并行的复杂性会慢慢堆积起来。

当你深入研究协程时，以下是一些你需要知道的事情。

### 取消 + 阻塞操作 = 😈

没有办法绕过它：在某些时候，你不得不用原生 Java 流。这里的问题（很多情况下 😉）是使用流将会堵塞当前线程。这在协程中是一个坏消息。现在，如果你想要取消一个协程，在能够继续执行之前，你不得不等待读写操作完成。

作为一个简单可重复的例子，让我们打开 `ServerSocket` 并且等待 1 秒的超时连接：

```
runBlocking(Dispatchers.IO) {
    withTimeout(1000) {
        val socket = ServerSocket(42)

         // 我们将卡在这里直到有人接收该连接。难道你不想知道为什么吗？😜
        socket.accept()
    }
}
```

应该可以运行，对吗？不。

现在你的感受有点像：😖。 那么我们如何解决呢？

当 `Closeable` APIs 构建良好时，它们支持从任何线程关闭流并适当地失败。

> 注意：通常情况下，JDK 中的 APIs 遵循了这些最佳实践，但需注意第三方 `Closeable` APIs 可能并没有遵循。 你被提醒过了。

幸亏 `suspendCancellableCoroutine` 函数，当一个协程被取消时我们可以关闭任何流：

```
public suspend inline fun <T : Closeable?, R> T.useCancellably(
        crossinline block: (T) -> R
): R = suspendCancellableCoroutine { cont ->
    cont.invokeOnCancellation { this?.close() }
    cont.resume(use(block))
}
```

确保这适用于你正在使用的 API ！

现在阻塞的 `accept` 调用被 `useCancellably` 包裹，该协程会在超时触发的时候失败。

```
runBlocking(Dispatchers.IO) {
    withTimeout(1000) {
        val socket = ServerSocket(42)

        // 抛出 `SocketException: socket closed` 异常。好极了！
        socket.useCancellably { it.accept() }
    }
}
```

成功！

如果你不支持取消怎么办？以下是你需要注意的事项：

*   如果你使用协程封装类中的任何属性或方法，即使取消了协程也会存在泄漏。如果你认为你正在 `onDestroy` 中清理资源，这尤其重要。**解决方法:** 将协同程序移动到 `ViewModel` 或其他上下文无关的类中并订阅它的处理结果。
*   确保使用 `Dispatchers.IO` 来处理阻塞操作，因为这可以让 Kotlin 留出一些线程来进行无限等待。
*   尽可能使用 `suspendCancellableCoroutine` 替换 `suspendCoroutine`。

### `launch` vs. `async`

由于上面关于这两个特性的回答已经过时，我想我会再次分析它们的差异。

#### `launch` 异常冒泡

当一个协程崩溃时，它的父节点将被取消，从而取消所有父节点的子节点。一旦整个树节点中的协程完成取消操作，异常将会发送到当前上线文的异常处理程序。在 Android 中，这意味着 **你的** 程序将会 **崩溃**，而不管你使用什么来进行调度。

#### `async` 持有自己的异常

这意味着 `await()` 显式处理所有异常，安装 `CoroutineExceptionHandler` 将无任何效果。

#### `launch` “blocks” 父作用域

虽然该函数会立即返回，但其父作用域将 **不会** 结束，直到使用 `launch` 构建的所有协程以某种方式完成。因此如果你只是想等待所有协程完成，在父作用域末尾调用所有子作业的 `join()` 就没有必要了。

与你期望的可能不同，即使未调用 `await（）`，外部作用域仍将等待`async`协程完成。

#### `async` 返回值

这一部分相当简单：如果你需要协程的返回值，`async` 是唯一的选择。如果你不需要返回值，使用 `launch` 来创建副作用。并且在继续执行之前需要完成这些副作用才需要使用 `join()`。

#### `join()` vs. `await()`

`join()` 在 `await()` 时 **不会** 重新抛出异常。但如果发生错误，`join()` 会取消你的协程，这意味着在 `join()` 挂起后调用任何代码都不会起作用。

### 记录异常

现在你了解了你所使用不同构造器异常处理机制的差异，你会陷入两难境地：你想记录异常而不崩溃（所以我们不能使用 `launch`），但是你不想手动调用 `try`/`catch` （所以我们不能使用 `async`）。所以这让我们无所适从？谢天谢地。

记录异常是  `CoroutineExceptionHandler` 派上用场的地方。但首先，让我们花点时间了解在协程中抛出异常时究竟发生了什么：

1.  捕获异常，然后通过 `Continuation` 恢复。
2.  如果你的代码没有处理异常并且该异常不是 `CancellationException`，那么将通过当前的 `CoroutineContext` 请求第一个 `CoroutineExceptionHandler`。
3.  如果未找到处理程序或处理程序有错误，那么异常将发送到平台中的特定代码。
4.  在 JVM 上，`ServiceLoader` 用于定位全局处理程序。
5.  一旦调用了所有处理程序或有一个处理程序出现错误，就会调用当前线程的异常处理程序。
6.  如果当前线程没有处理该异常，它会冒泡到线程组并最终到达默认异常处理程序。
7.  崩溃！

考虑到这一点，我们有以下几个选择：

*   为每个线程安装一个处理程序，但这是不现实的。
*   安装默认处理程序，但主线程中的错误不会让你的应用崩溃，并且你将处于潜在的不良状态。
*   [将处理程序添加为服务](https://gist.github.com/SUPERCILEX/f4b01ccf6fd4ef7ec0a85dbd59c89d6c) 当使用 `launch` 的任何协程崩溃时都会调用它（hacky）。
*   使用你自己的自定义域与附加的处理程序来替换 `GlobalScope`，或将处理程序添加到你使用的每个作用域，但这很烦人并使日志记录由默认变成了可选。

最后一个方案是所推荐的，因为它具有灵活性并且需要最少的代码和技巧。

对于应用程序范围内的作业，你将使用带有日志记录处理程序的 `AppScope`。对于其他业务，你可以在日志记录崩溃的适当位置添加处理程序。

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

不是很糟糕

### 最后的思考

任何时候我们必须处理边缘情况，事情往往会很快变得混乱。我希望这篇文章能够帮助你了解在非标准条件下可能遇到的各种问题，以及你可以使用的解决方案。

Happy Kotlining!

* [**Alex Saveau (@SUPERCILEX) | Twitter**: The latest Tweets from Alex Saveau (@SUPERCILEX). All things 🔥base, Android, and open-source. Also, 🐤 builds...](https://twitter.com/SUPERCILEX "https://twitter.com/SUPERCILEX")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
