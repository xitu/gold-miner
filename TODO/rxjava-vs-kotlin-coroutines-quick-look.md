
> * 原文地址：[RxJava vs. Kotlin Coroutines, a quick look](http://akarnokd.blogspot.jp/2017/09/rxjava-vs-kotlin-coroutines-quick-look.html)
> * 原文作者：[Dávid Karnok](https://plus.google.com/113316559156085910174)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rxjava-vs-kotlin-coroutines-quick-look.md](https://github.com/xitu/gold-miner/blob/master/TODO/rxjava-vs-kotlin-coroutines-quick-look.md)
> * 译者：[PhxNirvana](https://github.com/phxnirvana)
> * 校对者：[jamweak](https://github.com/jamweak)、[jerry-shao](https://github.com/jerry-shao)

# 管中窥豹：RxJava 与 Kotlin 协程的对比

## 引言

Kotlin 的协程是否让 RxJava 和 [响应式编程光辉不再](https://twitter.com/PreusslerBerlin/status/905001787215798273) 了呢？答案取决于你询问的对象。狂信徒和营销者们会毫不犹豫地是是是。如果真是这样的话，开发者们迟早会将 Rx 代码用协程重写一遍，抑或从一开始就用协程来写。
因为 [协程](https://kotlinlang.org/docs/reference/coroutines.html) 目前还是实验性的，所以目前的诸如性能瓶颈之类的不足，都将逐渐解决。因此，相对于原生性能，本文的重点更在于易用性方面。

## 方案设计

假设有两个函数，**f1** 和 **f2**，用来模仿不可信的服务，二者都会在一段延迟之后返回一个数。调用这两个函数，将其返回值求和并呈现给用户。然而如果 500ms 之内没有返回的话，就不再指望它会返回值了，因此我们会在有限次数内取消并重试，直到超过次数最终放弃请求。

## 协程的方式

协程用起来就像是传统的 基于 **ExecutorService** 和 **Future** 的工具套装， 不同点在于协程的底层是用的挂起、状态机和任务调度来代替线程阻塞的。

首先，写两个函数来实现延迟操作：

```
suspend fun f1(i: Int) {
    Thread.sleep(if (i != 2) 2000L else 200L)
    return 1;
}

suspend fun f2(i: Int) {
    Thread.sleep(if (i != 2) 2000L else 200L)
    return 2;
}
```

与协程调度有关的函数需要加上 **suspend** 关键字并通过协程上下文来调用。为了演示上面的目的，如果传入参数不是 2 的时候，函数会延迟 2s。这样就会让超时检测将其结束掉，并在第三次尝试时在规定时间内成功。

因为异步总会在结束时离开主线程，我们需要一个方法来在业务逻辑完成前阻塞它，以防止直接退出 JVM。为了达到目的，可以使用 **runBlocking** 在主线程中调用函数。

```
fun main(arg: Array<string>) = runBlocking <unit>{

     coroutineWay()

     reactiveWay()
}

suspend func coroutineWay() {
    // TODO implement
}

func reactiveWay() {
    // TODO implement
}</unit> </string>
```

相比 RxJava 的函数式，用协程写出来的代码逻辑更简洁，而且代码看起来就像是线性和同步的一样。

```
suspend fun coroutineWay() {
    val t0 = System.currentTimeMillis()

    var i = 0;
    while (true) {                                       // (1)
        println("Attempt " + (i + 1) + " at T=" +
            (System.currentTimeMillis() - t0))

        var v1 = async(CommonPool) { f1(i) }             // (2)
        var v2 = async(CommonPool) { f2(i) }

        var v3 = launch(CommonPool) {                    // (3)
            Thread.sleep(500)
            println("    Cancelling at T=" +
                (System.currentTimeMillis() - t0))
            val te = TimeoutException();
            v1.cancel(te);                               // (4)
            v2.cancel(te);
        }

        try {
            val r1 = v1.await();                         // (5)
            val r2 = v2.await();
            v3.cancel();                                 // (6)
            println(r1 + r2)
            break;                                       
        } catch (ex: TimeoutException) {                 // (7)
            println("         Crash at T=" +
                (System.currentTimeMillis() - t0))
            if (++i > 2) {                               // (8)
                throw ex;
            }
        }
    }
    println("End at T=" 
        + (System.currentTimeMillis() - t0))             // (9)

}
```

添加的一些输出是用来观察这段代码如何运行的。

1. 通常线性编程的情况下，是没有直接重试某个操作的快捷方法的，因此，我们需要建立一个循环以及重试计数器 **i**。
2. 通过 **async(CommonPool)** 来执行异步操作，该函数可以在一些后台线程立即启动并执行函数。该函数会返回一个 **Deferred<Int>**，稍后会用到这个值。 如果用 await() 来得到 **v1** 作为最终值的话，当前线程将会挂起，另外，对 **v2** 的计算也不会开始，除非前一个恢复执行。除此以外，我们还需要在超时的情况下取消当前操作的方法。参考步骤 3 和 5。
3. 如果想让两个操作都超时的话，看起来我们只能在另一个异步线程中执行等待操作。**launch(CommonPool)** 方法会返回一个可以用在这种情况下的 **Job** 对象。 与 **async** 的区别是，这样执行无法返回值。之所以保存返回的 **Job** 是因为先前的异步操作可能及时返回，就不再需要取消操作了。
4. 在超时的任务中，我们用 **TimeoutException** 来取消 **v1** 和 **v2** ，这将恢复任何已经挂起来等待二者返回的操作。
5. 等待两个函数运行结果。如果超时，**await** 将重新扔出在第四步中使用的异常。
6. 如果没有异常，则取消不再需要执行的超时任务，并跳出循环。
7. 如果有超时，则走老一套捕获异常并执行状态检查来确定下一步操作。注意任何其他异常都会直接被抛出并退出循环。
8. 万一是第三次或更多次的尝试，直接扔出异常，什么都不做。
9. 如果一切按剧本走，打印运行的总时间，然后退出当前函数。

看起来挺简单的，尽管取消机制可能搞个大新闻：如果 **v2** 因为其他异常（比如网络原因导致的 **IOException**）崩溃了呢？当然我们得处理这些情况来确保任务可以在各种情况下被取消（举个栗子，试试 Kotlin 中的资源？）。然而，这种情况发生的背景是 **v1** 会及时返回，直到尝试 await 之前都无法取消 **v1** 或检测 **v2** 的崩溃。

不要在意那些细节，反正程序跑起来了，运行结果如下：

```
Attempt 1 at T=0
    Cancelling at T=531
         Crash at T=2017
Attempt 2 at T=2017
    Cancelling at T=2517
         Crash at T=4026
Attempt 3 at T=4026
3
End a
```

一共进行了 3 次尝试，最后一次成功了，值是 3。是不是和剧本一模一样的？一点都不快（此处有双关（译者并没有看出来哪里有双关））！ 我们可以看到取消事件发生的大概时间，两次不成功的请求之后大约 500 ms ，然而异常捕获发生在大约 2000 ms 之后！我们知道 **cancel()** 被成功调用是因为我们捕获了异常。然而，看起来函数中的 **Thread.sleep()** 并没有被打断，或者用协程的说法，没有在打断异常时恢复。这可能是 **CommonPool** 的一部分，对 **Future.cancel(false)** 的调用处于基础结构中，抑或只是简单的程序限制。

## 响应式

接下来我们看看 RxJava 2 是如何实现相同操作的。让人失望的是，如果函数前加了 suspended，就无法通过普通方式调用了，所以我们还得用普通方法重写一下两个函数：


```
fun f3(i: Int) : Int {
    Thread.sleep(if (i != 2) 2000L else 200L)
    return 1
}

fun f4(i: Int) : Int {
    Thread.sleep(if (i != 2) 2000L else 200L)
    return 2
}
```

为了匹配阻塞外部环境的功能，我们采用  [RxJava 2 Extensions](https://github.com/akarnokd/RxJava2Extensions#blockingscheduler) 中的 BlockingScheduler 来提供返回到主线程的功能。顾名思义，它阻塞了一开始的调用者/主线程，直到有任务通过调度器来提交并运行。

```
fun reactiveWay() {
    RxJavaPlugins.setErrorHandler({ })                         // (1)

    val sched = BlockingScheduler()                            // (2)
    sched.execute {
        val t0 = System.currentTimeMillis()
        val count = Array<Int>(1, { 0 })                       // (3)

        Single.defer({                                         // (4)
            val c = count[0]++;
            println("Attempt " + (c + 1) +
                " at T=" + (System.currentTimeMillis() - t0))

            Single.zip(                                        // (5)
                    Single.fromCallable({ f3(c) })
                        .subscribeOn(Schedulers.io()),
                    Single.fromCallable({ f4(c) })
                        .subscribeOn(Schedulers.io()),
                    BiFunction<Int, Int> { a, b -> a + b }               // (6)
            )
        })
        .doOnDispose({                                         // (7)
            println("    Cancelling at T=" + 
                (System.currentTimeMillis() - t0))
        })
        .timeout(500, TimeUnit.MILLISECONDS)                   // (8)
        .retry({ x, e ->
            println("         Crash at " + 
                (System.currentTimeMillis() - t0))
            x < 3 && e is TimeoutException                     // (9)
        })
        .doAfterTerminate { sched.shutdown() }                 // (10)
        .subscribe({
            println(it)
            println("End at T=" + 
                (System.currentTimeMillis() - t0))             // (11)
        },
        { it.printStackTrace() })
    }
}
```

实现起来有点长，对那些不熟悉 lambda 的人来说看起来可能有点可怕。

1. 众所周知 RxJava 2 无论如何都会传递异常。在 Android 上，无法传递的异常会使应用崩溃，除非使用 **RxJavaPlugins.setErrorHandler** 来捕获。在此，因为我们知道取消事件会打断 **Thread.sleep()** ，调用栈打出来的结果只会是一团乱麻，我们也不会去注意这么多的异常。
2. 设置 **BlockingScheduler** 并分发第一个执行的任务，以及剩下的主线程执行逻辑。 这是由于一旦锁住， **start()** 将会给主线程增加一个活锁状态，直到有任何随后事件打破锁定，主线程才会继续执行。
3. 设置一个堆变量来记录重试次数。
4. 一旦有通过 **Single.defer** 的订阅，计数器加一并打印 “Attempt” 字符串。该操作符允许保留每个订阅的状态，这正是我们在下游执行的 **retry()** 操作符所期望的。
5. 使用 **zip** 操作符来异步执行两个元素的计算，二者都在后台线程执行自己的函数。
6. 当二者都完成时，将结果相加。
7. 为了让超时取消，使用 **doOnDispose** 操作符来打印当前状态和时间。
8. 使用 **timeout** 操作符定义求和的超时。如果超时则会发送 **TimeoutException**（例如该场景下没有反馈时）。
9. retry 操作符的重载提供了重试时间以及当前错误。打印错误后，应该返回 **true** ——也就是说必须执行重试——如果重试次数小于三并且当前错误是 **TimeoutException** 的话。任何其他错误只会终止而不是触发重试。
10. 一旦完成，我们需要关闭调度器，来让释放主线程并退出JVM。
11. 当然，在完成前我们需要打印求和结果以及整个操作的耗时。

可能有人说，这比协程的实现复杂多了。不过……至少跑起来了：

```
    Cancelling at T=4527

Attempt 1 at T=72
    Cancelling at T=587
         Crash at 587
Attempt 2 at T=587
    Cancelling at T=1089
         Crash at 1090
Attempt 3 at T=1090
    Cancelling at T=1291
3
End at T=1292
```

有趣的是，如果在 **main** 函数中同时调用两个函数的话，**Cancelling at T=4527** 是在调用 **coroutineWay()** 方法时打印出来的：尽管最后根本没有时间消耗，取消事件自身就浪费在无法停止的计算问题上，也因此在取消已经完成的任务上增加了额外消耗。

另一方面，RxJava 至少及时地取消和重试了函数。然而，实际上也有几乎没必要的 **Cancelling at T=1291** 被打印出来了。呐，没办法，写出来就这样了，或者说我懒吧，在 **Single.timeout** 中是这样实现的：如果没有延时就完成了的话，无论操作符真实情况如何，内部的 **CompositeDisposable** 代理了上游的 **Disposable** 并将其和操作符一起取消了。

## 结论

最后呢，我们通过一个小小的改进来看一下响应式设计的强大之处：如果只需要重试没有响应的函数的话，为什么我们要重试整个过程呢？改进方法也可以很容易地在 RxJava 中找到：将 **doOnDispose().timeout().retry()** 放到每一个函数调用链中（也许用 transfomer 可以避免代码的重复）：

```
val timeoutRetry = SingleTransformer<Int, Int> { 
    it.doOnDispose({
        println("    Cancelling at T=" + 
            (System.currentTimeMillis() - t0))
    })
    .timeout(500, TimeUnit.MILLISECONDS)
    .retry({ x, e ->
        println("         Crash at " + 
            (System.currentTimeMillis() - t0))
        x < 3 && e is TimeoutException
    })
}

// ...

Single.zip(
    Single.fromCallable({ f3(c) })
        .subscribeOn(Schedulers.io())
        .compose(timeoutRetry)
    ,
    Single.fromCallable({ f4(c) })
        .subscribeOn(Schedulers.io())
        .compose(timeoutRetry)
    ,
    BiFunction<Int, Int> { a, b -> a + b }
)
// ...
```

欢迎读者亲自动手实践并更新协程的实现来实现相同行为（顺便可以试试各种其他形式的取消机制）。
响应式编程的好处之一是大多数情况下都不必去理会诸如线程、取消信息的传递和操作符的结构等恼人的东西。RxJava 之类的库已经设计好了 API 并将这些底层的大麻烦封装起来了，通常情况下，程序员只需要使用即可。

那么，协程到底有没有用呢？当然有用啦，但总的来说，我还是觉得性能对其是极大的限制，同时，我也想知道协程可以怎么做才能整体取代响应式编程。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
