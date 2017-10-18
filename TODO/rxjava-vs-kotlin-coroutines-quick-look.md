
> * 原文地址：[RxJava vs. Kotlin Coroutines, a quick look](http://akarnokd.blogspot.jp/2017/09/rxjava-vs-kotlin-coroutines-quick-look.html)
> * 原文作者：[Dávid Karnok](https://plus.google.com/113316559156085910174)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rxjava-vs-kotlin-coroutines-quick-look.md](https://github.com/xitu/gold-miner/blob/master/TODO/rxjava-vs-kotlin-coroutines-quick-look.md)
> * 译者：
> * 校对者：

# RxJava vs. Kotlin Coroutines, a quick look

## Introduction

Does Kotlin Coroutines make RxJava and [reactive programming obsolete](https://twitter.com/PreusslerBerlin/status/905001787215798273)? The answer depends on who you ask. Enthusiasts and marketing departments would say yes without hesitation. If so, sooner or later developers would have to convert Rx code into coroutines or write something with coroutines from the start.

Since [Coroutines](https://kotlinlang.org/docs/reference/coroutines.html) are currently experimental, there is always the prospect deficiencies, especially regarding the overhead, will be resolved eventually. Therefore, this post will focus more on usability than raw performance.

## The scenario

Let's say we have two functions imitating unreliable service: **f1** and **f2**, both returning a number after some delay. We have to call these services, sum up their returned values and present it to the user. However, if this doesn't happen within 500 milliseconds, we don't expect it to happen reasonably faster, thus we'd like to cancel and retry the two services for a limited amount of time before giving up after some number of retries.

## The Coroutine Way

Programming via coroutines feels like programming with the traditional **ExecutorService**- and **Future**-based toolset with the difference that the underlying infrastructure will use suspension, state machine(s) and task rescheduling instead of blocking a thread.

First, we need the functions that exhibit the delaying behavior:

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

Functions that participate in a coroutine execution should be declared with the **suspend** keyword and executed within a coroutine context. For demonstration purposes, the logic will sleep for 2 seconds if the parameter supplied to the functions is not 2\. This will give a chance to the timeout logic to kick in yet the 3rd attempt to succeed before the timeout.

Since going asynchronous usually ends up leaving the main thread, we need a way to block it until the business logic completes before letting the JVM quit. For this, we can use the **runBlocking** execution mode in the main method:

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

The coroutine way of writing the desired logic promises some simplicity compared to the functional ways of RxJava; it should look like as if everything is written in a sequential and synchronous manner.

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

The printlns were added to see what's happening when in this logic.

1. In traditional sequential programming, there is no convenient way of retrying an operation under certain conditions, therefore, we first need a loop with a retry counter **i**.
2. We fork off the async computations via the **async(CommonPool)** that will start and execute the functions immediately on some background thread. It returns a **Deferred<Int>** we will need later. If we applied await() to get var **v1** to be the resulting value, that would suspend the current thread and the calculation for **v2** wouldn't start until the first one resumes it. Plus we'll need a way of cancel the ongoing computation in case of a timeout. See steps 3 and 5.
3. If we'd like to timeout both computations, it seems we have to do the timed waiting ourselves with another async task. The method **launch(CommonPool)**, returning a **Job**, will be used for this. The difference from **async** is that such tasks can't return values. We save the returned **Job** because in case the previous async calls succeed in time, we no longer need the timer to fire anymore.
4. In the timeout job, we cancel **v1** and **v2** with a **TimeoutException**, that will unblock any routine that is suspended on getting a result from either of them.
5. We await the results of the two computation. If there is a timeout, the **await** will rethrow the exception we used in 4.
6. If there was no exception, we cancel the timeout task itself as its services are no longer needed, and break out the loop.
7. If there was a timeout, we catch it the traditional way and perform state checks to determine what to do. Note that any other exception simply falls through and exits the loop.
8. In case this was the 3rd (or later) attempt, we simply give up and rethrow the exception.
9. If everything went okay, we print the total time the run took and leave the function. 

Looks straightforward, although the cancellation management can get scary: what if **v2** crashes with some other exception (such as **IOException** due to network access)? Certainly we have to keep those task references around so they can get cancelled in such cases as well (i.e., try with resources in Kotlin?). However, this case also has the drawback that if **v1** would return in time after all, we can't cancel **v1** or detect the crash from **v2** until there is an attempt to await it.

Regardless, the setup works and we get a printout something like this:

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

3 attempts, last one succeeds and we get the sum of 3\. Looks reasonable, right? Not so fast (pun intended)! We can see the cancellation happened about time, ~500 milliseconds after the two unsuccessful attempts, yet the crash detection printout happened 2000 milliseconds after the attempt! We know the **cancel()** invocation worked because it was the source of the exception we actually caught. Therefore, it looks like the **Thread.sleep()** in the functions were not actually interrupted, or in coroutine terms, not resumed with the interruption exception. This could be a property of the **CommonPool** , the use of **Future.cancel(false)** in the underlying infrastructure or simply a limitation of it.

## The Reactive Way

Now let's see how to accomplish the same with RxJava 2\. Unfortunately, once a function is marked suspended, one can't call it from regular contexts, therefore we have to redo them in a traditional fashion:

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

To match the functionality of a blocking outer context, we will use the BlockingScheduler from the [RxJava 2 Extensions](https://github.com/akarnokd/RxJava2Extensions#blockingscheduler) project that allows returning to the main thread. As it name says, it blocks the caller/main thread when started until something submits a task through the scheduler to be executed.

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

A slightly longer implementation and certainly may look scary to those who are not used to so much lambdas.

1. RxJava 2 notoriously delivers exceptions in one way or other. On Android, undeliverable exceptions will crash the app unless handled with the **RxJavaPlugins.setErrorHandler**. Here, since we know a cancellation will interrupt a **Thread.sleep()**, the resulting stacktrace printed to the console would just clutter it and it is decided we ignore such excess exceptions.
2. We setup the **BlockingScheduler** and issue the first task to be executed on it, containing the rest of the logic to be executed in the main thread. This is due to the fact that because it blocks, a regular **start()** will livelock the main thread as any subsequent work, that would otherwise unblock it, wouldn't get executed.
3. We setup a heap variable that will count the number of retries.
4. We increment this counter and print out the "Attempt" string whenever there is a subscription via **Single.defer**. The operator allows us to have a per subscription state which we expect from the resubscriptions of a **retry()** operator down the chain.
5. We use the **zip** operator that starts two single-element asynchronous calculation, each calling the respective function from a background thread. 
6. Once both finish, we add the resulting number together.
7. To make a cancellation from the timeout visible, we add the **doOnDispose** operator to print out the indicator and timestamp of such event.
8. We define the overall timeout to get the sum via the **timeout** operator. The overload will signal a **TimeoutException** if the timeout happens (i.e., no fallback for this scenario).
9. The retry operator overload provides the number of times the retry happened and the current error. After printing the error, we should return **true** - which indicates the retry must happen - if the number of retries so far is less than 3 and the error itself is of **TimeoutException**. Any other error will simply fall through without triggering a retry.
10. Once we are done, we should shut down the scheduler so it can release the main thread and the JVM can quit.
11. Hovever, just before that, we print the resulting sum and the time it took the whole operation to finish.

One could say, it is more convoluted compared to the coroutine version. At least it works:

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

The **Cancelling at T=4527**, interestingly comes from the **coroutineWay()** call if we run the two functions together from the **main** method above: even though there was no timeout at last, cancelling the timeout itself suffered the same non-interruptible computation problem, hence the additional and mute signal about cancelling the already finished tasks.

RxJava, on the other hand, promptly cancels and retries the functions at least. There is, however, a practically unnecessary **Cancelling at T=1291** entry in the printout too. This is an artifact, or rather my sloppyness, in how **Single.timeout** is implemented: if it succeeds without timeout, the internal **CompositeDisposable** hosting the upstream's **Disposable** gets cancelled along with the timeout task regardless of the actual state of the operator.

## Conclusion

As a final thought, let's illustrate the power of reactive design by a small change in the expectations: Why retry the whole sum if we could only retry that function which doesn't respond in time? The solution is straightforward in RxJava: move the **doOnDispose().timeout().retry()** into each of the function call sequence (perhaps through a transformer to avoid code duplication):

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

I welcome the reader to try and update the coroutine implementation to accomplish the same behavior (including any other form of cancellation possibility while you are at it).
One of the benefits of declarative reactive programming is the ability to not bother with complications such as threading, propagation of cancellation and operation composition most of the time. Libraries such as RxJava give an API and a viewpoint that hide these lower level "evils" from the typical user.

So, are coroutines useful after all? Certainly they are, but I believe this usefulness is rather limited and I have my doubts on how it could replace reactive programming in general.</div>


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
