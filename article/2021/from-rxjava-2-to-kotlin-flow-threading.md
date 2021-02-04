> * 原文地址：[From RxJava 2 to Kotlin Flow: Threading](https://proandroiddev.com/from-rxjava-2-to-kotlin-flow-threading-8618867e1955)
> * 原文作者：[Vasya Drobushkov](https://medium.com/@krossovochkin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/from-rxjava-2-to-kotlin-flow-threading.md](https://github.com/xitu/gold-miner/blob/master/article/2021/from-rxjava-2-to-kotlin-flow-threading.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 从 RxJava 2 转向使用 Kotlin 流：多线程

![[Source](https://unsplash.com/photos/vyyVbUOYNPc)](https://cdn-images-1.medium.com/max/2000/0*piI5NnrRuivMUOKD)

## 简介

尽管随着 Kotlin 的扩展和引入冷流（Flow）的出现让未来几年的情况可能会迅速改变，长期以来，RxJava 一直是 Android 反应式解决方案的无可争议的领导者。虽说反应式编程最初与线程无关，但合适的并发和并行性对程序而言仍然非常重要。在本文中，我们将简要回顾 RxJava 2 中的线程（对其用法做一些基本说明），然后看一下 Kotlin Flow 中的线程工作原理，让你们在不影响功能的情况下想要迁移其代码时候变得顺利。

让我们从 RxJava 2 的简短回顾开始。

## RxJava 2

RxJava 2 的 `Observable` 和 Kotlin Flow 都是冷流，意味着其中的代码都不会被执行直到被订阅。

> 在 RxJava 中也有另外的类型例如 `Flowable`、`Single` 等。在本文中，我们只会讲讲 `Observable` 因为它们之间都能够融会贯通。

最基础的使用方法是这样的：

```kotlin
observeSomething()
	.subscribeOn(io())
	.observeOn(mainThread())
	.subscribe { result -> println(result) }
```

在这里我们可以看到我们给在输入输出上设置了观察，并将每一个变化结果都打印在主线程上（因为我们正在观察主线程）。

#### subscribeOn

这是一个运算符用于声明将在哪一个要订阅的对象上设下一个用于观察的调度器。“将在哪一个要订阅的对象”是指“将在哪个调度器上启动我们的执行程序”。

第一个重要的事情是我们并不需要管 `subscribeOn` 具体在哪个地方声明，我们可以这样：

```kotlin
observeSomething()
	.subscribeOn(io())
	.observeOn(mainThread())
	.subscribe { result -> println(result) }
```

也可以这样：

```kotlin
observeSomething()
	.observeOn(mainThread())
	.subscribeOn(io())
	.subscribe { result -> println(result) }
```

上述的两种情况都会毫无意外的产生一样的结果。通过在代码链中声明这些运算符，我们声明了这个链的开始，并且运算符本身并不依赖于声明的位置。

第二个事情是因为一个链并不能同时在多个调度器处启动，因此我们无需在链中添加多个 `subscribeOn`，因为只有其中之一会起作用。如果出于某种原因你将多个 `subscribeOn` 运算符放在链中，则最上面的一个将被使用，而最下面的将被忽略：

```kotlin
observeSomething()
	.subscribeOn(io()) // 这个会被使用上
	.observeOn(mainThread())
	.subscribeOn(io()) // 这个会直接被忽略
	.subscribe { result -> println(result) }
```

#### observeOn

`subscribeOn` 表示将在哪个调度器上启动链，而 `observeOn` 表示将在哪个调度器上进行线程。实际上，这意味着 `observeOn` 会更改下面的链中的调度器。

```kotlin
/* 1 */	observeSomething()
/* 1 */		.subscribeOn(io())
/* 2 */		.observeOn(mainThread())
/* 2 */		.subscribe { result -> println(result) }
```

在这里，我们看到从链开始，直到链上的 `observeOn` 定义是第一部分，然后 `observeOn` 更改链要在 `mainThread` 调度器上运行，因此下面的所有内容现在都在 `mainThread` （第二部分）上执行。

与 `subscribeOn` 不同，实际上如果真的需要，我们可以添加多个 `observeOn`：

```kotlin
/* 1 */	observeSomething()
/* 1 */		.subscribeOn(io())
/* 2 */		.observeOn(computation())
/* 2 */		.map { result -> result.length }
/* 3 */		.observeOn(mainThread())
/* 3 */		.subscribe { result -> println(result) }
```

就例如上面这个例子：我们可以举个例子，我们先从网络中加载一些东西，然后对数据进行一些计算，然后打印结果。我们添加了多个 `observeOn`，让程序首先切换到 `computation` 调度器（以在后台线程中进行计算，这是第二部分），然后切换到 `mainThread` 以打印结果。

#### just + defer

有关 subscribeOn 的一个常见错误是将他于 `Observable.just` 一起使用。

```kotlin
Observable.just(loadDataSync())
	.subscribeOn(io())
	.observeOn(mainThread())
	.subscribe { result -> println(result) }
```

`just` 参数的值是立即计算的，而不是在订阅时才计算的。这意味着，如果您在主线程上创建此类可观察的对象，那么可能会在主线程上进行大量潜在的计算。虽说订阅将在 `io` 上正确完成，但是 `just` 的值将在订阅之前计算。

解决此问题的方法之一是将您的 `Observable.just` 包装到 `Observable.defer` 中，这样，内部的所有内容都将在订阅时以及在我们在 `subscribeOn` 中声明的调度器上进行计算：

```kotlin
Observable.defer { Observable.just(loadDataSync()) }
	.subscribeOn(io())
	.observeOn(mainThread())
	.subscribe { result -> println(result) }
```

#### flatMap 的并发和并行

另一个棘手的事情来自使用运算符 `flatMap` 和我们对并发性和并行性的理解。

例如，当我们拥有 ID 列表流并且对于每一个 ID 我们都希望从网络中加载一些数据：

```kotlin
Observable.fromIterable(listOf("id1", "id2", "id3"))
	.flatMap { id ->
		loadData(id)
	}
	.subscribeOn(io())
	.observeOn(mainThread())
	.toList()
	.subscribe { result -> println(result) }
```

我们在这里的预期是，我们已经订阅了 `io`，`io()` 的底层有线程池，因此对每个 `id` 的 `loadData` 的调用是并行化的。但是事实并非如此。我们使用 `flatMap` 编写了并发代码，但它不是并行运行的，其原因是我们告诉了程序我们要在 `io` 上启动链。我们的链的起点在 `flatMapIterable` 上，这意味着在订阅后，将使用 `io` 池中的一个线程，并在该单个线程上运行所有线程。为了改变行为并使我们的代码并行运行，我们需要将 `subscribeOn` 移动到 `flatMap` 之内：

```kotlin
Observable.fromIterable(listOf("id1", "id2", "id3"))
	.flatMap { id ->
		loadData(id)
			.subscribeOn(io())
	}
	.observeOn(mainThread())
	.toList()
	.subscribe { result -> println(result) }
```

一旦执行到了 `flatMap`，每个内部的可观察对象（`flatMap` 内部的可观察对象）都将被订阅。意味着在每一次执行 `loadData` 函数，都会有一个订阅，从 `io` 池中获取新线程。这样我们就达到了并行性。

因此，当我们使用诸如 `flatMap` 之类的运算符时，我们的链应该有多个订阅点：一个用于原始链起点，每个用于内部的可观察点：

```kotlin
/* 订阅点 1 */	Observable.fromIterable(listOf("id1", "id2", "id3"))
					.flatMap { id ->
/* 订阅点 2 */ 			loadData(id)
							.subscribeOn(io())
							.flatMap {
/* 订阅点 3 */ 					loadData2(id)
									.subscribeOn(io())
							}
						}
					.observeOn(mainThread())
					.toList()
					.subscribe { result -> println(result) }
```

代码中的注释指向了每一个订阅发生的位置。通过使用 `subscribeOn`，我们可以声明在这些情况下应该在哪个调度程序订阅上进行。

#### 非多线程运行

最后但并非最不重要的一点是，如果我们不使用 `subscribeOn` 或 `observeOn`，那么代码将是同步进行的，所有执行将是顺序执行的，并且在下一个语句的可观察到的完整执行之前是暂停的。

以上就基本上是 RxJava 中的线程的全部内容，让我们现在走进 Kotlin 流。

## Kotlin 流

Kotlin 流的最基础的使用方法是这样的：

```kotlin
CoroutineScope(Job() + Dispatchers.Main).launch {
	observeSomething()
		.flowOn(Dispatchers.IO)
		.collect { result -> println(result) }
}
```

> And here we immediately have many concepts which are related to coroutines, which might be needed to explain. We’ll not dive deep into explaining coroutines stuff, article is about Kotlin Flow, so it might be a good idea to read the documentation on the coroutines first if you are not familiar with them.

This example is identical (to some extent) to the example we’ve used in RxJava part: we again observe some changes on io and then print result on main, though the structure is different. Let’s find out the difference and how this works.

First thing which we should note is that flow can be collected only inside some coroutine scope (because `collect` method is a `suspend` function). Because of that we’ve created scope and in that scope `launch`’ed new coroutine. In that launched coroutines we now can collect the flow.

One important thing about Kotlin flow and collect function is a feature called **context preservation**. That means that we don’t need to declare on which Dispatcher to collect the data — that dispatcher always will be same as in the scope in which we’re collecting data from our flow.

So if we want to collect in Main, then we need to call `collect` function in the coroutine with `Dispatchers.Main` in the context.

#### flowOn

This is an operator which changes the context (dispatcher particularly) on which flow is working.

![](https://cdn-images-1.medium.com/max/2000/1*QOMRfQTktM17z2xHUYmcrQ.png)

So in our example above, by writing `flowOn(Dispatchers.IO)` we say that we want everything **before** it run on the IO.

If we add some computation (inside `map`) as we’ve done before with RxJava we’ll have the following result:

![](https://cdn-images-1.medium.com/max/2000/1*zpbvxCRXjGLSEuFlnrWarg.png)

We’ll see that basically we can change where our operators should work by declaring `flowOn` after them.

#### launchIn

One important thing about `collect` function is that it is suspending. That means that when we call `collect` execution is suspended until flow is finished.

So if you put inside same coroutine two `collect` functions, then first one will effectively block second from execution:

![](https://cdn-images-1.medium.com/max/2000/1*xopZFayVenZK03PQ9RoZ0Q.png)

Here we’ll see result printed, but “second $result” not, because first `collect` function will suspend and not allow second collect to happen.

To fix that we need to launch each flow in a separate coroutine:

![](https://cdn-images-1.medium.com/max/2000/1*511-boC1pDMN9gLmK9ySKg.png)

But it doesn’t look pretty and to make it look a bit better (without additional nested level) we can use `launchIn` extension function (which is just syntactic sugar over that wrapped launch) with `onEach`:

![](https://cdn-images-1.medium.com/max/2000/1*atQKeG0bwwMfjBD7nBIZHg.png)

This way we create code which looks more similar to us (who wrote on RxJava before), because subscription in RxJava usually not blocking (unless some `blockingXXX` method is used), so seems `launchIn` should be primary option for similar use cases.

#### flowOf

With `flowOf` we have similar situation as with `Observable.just`. If you put some calculation (suspending) then it will be done in the outer scope and not affected by `flowOn`:

![](https://cdn-images-1.medium.com/max/2000/1*jTX93fFjuwjxR33NLaSkmA.png)

If run inside context with `Dispatchers.Main`, then `calculate()` will be run on main and not on io.

To fix that you can use `flow` builder and explicitly emit value inside:

![](https://cdn-images-1.medium.com/max/2000/1*JSkHKLjh9X-YDL1Olkl5hQ.png)

Then calculation will be done on IO thread.

#### flatMapMerge concurrency and parallelism

To find out how Kotlin Flow works with flatMapMerge (analog of RxJava `flatMap`) we’ll use few test examples:

![](https://cdn-images-1.medium.com/max/2000/1*_G4_NwfgY1wmO7aVoamsrw.png)

Here we have flow which is collected on `d1` dispatcher. The flow has two items, which are flat mapped onto two other items each. And we have single `flowOn` on the `d2` dispatcher. In the code we’ve added `onEach` call with information on the thread on which execution happens.

In this example the output would be:

```
inner: pool-2-thread-2 @coroutine#4
inner: pool-2-thread-3 @coroutine#5
inner: pool-2-thread-3 @coroutine#5
inner: pool-2-thread-2 @coroutine#4
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
```

So, we see that unlike RxJava even when we’ve put `flowOn` outside (below) the inner `flatMapMerge`,`flowOn` anyway affected the inner code by running it in parallel on multiple threads.

If we put `flowOn` inside `flatMapMerge:`

![](https://cdn-images-1.medium.com/max/2000/1*sv6HwmwwsOufpc-00wZpCQ.png)

we’ll see the following result:

```
inner: pool-2-thread-2 @coroutine#6
inner: pool-2-thread-1 @coroutine#7
inner: pool-2-thread-2 @coroutine#6
inner: pool-2-thread-1 @coroutine#7
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
```

Again each inner flow runs on its own thread from second pool. Therefore there seems no difference where we put `flowOn`.

But there is a difference and let’s see what it is by adding `onEach` below first `flowOf` call:

![](https://cdn-images-1.medium.com/max/2000/1*isZ3b5z8Jg7f-V9tOqdFlw.png)

The result will be:

```
outer: pool-2-thread-1 @coroutine#3
outer: pool-2-thread-1 @coroutine#3
inner: pool-2-thread-2 @coroutine#4
inner: pool-2-thread-3 @coroutine#5
inner: pool-2-thread-3 @coroutine#5
inner: pool-2-thread-2 @coroutine#4
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
collect: pool-1-thread-2 @coroutine#2
```

That means that everything above flowOn is run on the second pool. Outer is on the first thread and each inner flow on its own (second and third):

![](https://cdn-images-1.medium.com/max/2000/1*dfWRpulMkYT_8aNiXJVCPA.png)

In red it is shown running on `d2`, and in blue — on `d1` .

Now let’s see what would be if we put `flowOn` inside `flatMapMerge`:

![](https://cdn-images-1.medium.com/max/2000/1*SM6l5_038WGzm9Z4Zd97nA.png)

The output will be:

```
outer: pool-1-thread-2 @coroutine#3
outer: pool-1-thread-2 @coroutine#3
inner: pool-2-thread-1 @coroutine#6
inner: pool-2-thread-2 @coroutine#7
inner: pool-2-thread-1 @coroutine#6
inner: pool-2-thread-2 @coroutine#7
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
collect: pool-1-thread-3 @coroutine#2
```

We see that outer now runs on the `d1` and therefore not affected by `flowOn`:

![](https://cdn-images-1.medium.com/max/2000/1*5D5AHoF0nPJyD7lcMvp0cA.png)

And that’s the difference.

## Comparison

Now let’s make some comparison and conclusion and also see few examples.

From the comparison part both RxJava and Kotlin Flow represent cold streams. Both have general operators and approaches for changing threading (schedulers or dispatchers) in the chain.

#### Control of threading

In RxJava for threading **Schedulers** are used (most common io(), computation(), mainThread())

In Kotlin Flow for threading **Dispatchers** are used ****(most common IO, Default, Main)

#### Threading operators

In RxJava we declare on which scheduler chain should be **subscribed (started)** using **subscribeOn**, and where it should **proceed** using **observeOn**.

In Kotlin Flow we declare on which context (dispatcher) chain should be **collected (ended)** using scope in which flow is collected, and where it works **before** that using **flowOn**.

So it is like reversed approaches. In RxJava we declare start and modify chain below. In Kotlin Flow we have end declared and can modify chain above.

#### Migration Example

Consider we have some complex RxJava chain we’d like to migrate to Kotlin Flow keeping the threading logic as before. From above we already understand that we basically need flip upside-down our mental model and do not forget to test.

Also we should already keep in mind that non-blocking threading in RxJava and suspending with thread reusing between coroutines are different approaches and we won’t be able to have exact one-to-one relation. Though we can put some constraints, like we want to keep parallelism where we had it and have same blocks of code run on same thread pools.

To make our test example as correct as possible we’ll use java executors under the hood of the Scheduler and Dispatcher. We’ll create a number of them for Rx:

![](https://cdn-images-1.medium.com/max/2000/1*24TAclWSQTvfOlYIw9I65w.png)

And for Kotlin Flow:

![](https://cdn-images-1.medium.com/max/2000/1*6WmwuDO_EMLlyHLDycCu8A.png)

We’ll have 4 pools with 3 threads and main executor with only one thread.

Our RxJava example will look like the following:

![](https://cdn-images-1.medium.com/max/2000/1*nYL6iK4SOlMEh9YMOsSbKQ.png)

Here we have stream of three items, which is started on s1, then we switch execution to s2. Inside flatMap we have inner observable with its own subscribe (allowing parallelism) and also some thread switching. Then after flat mapping we do some work and print result in main thread.

After we run the program we’ll see such an output:

```
1: pool-1-thread-1
1: pool-1-thread-1
1: pool-1-thread-1
2: pool-3-thread-1
2: pool-3-thread-1
2: pool-3-thread-1
inner 1: pool-4-thread-1
inner 1: pool-4-thread-2
inner 1: pool-4-thread-1
inner 1: pool-4-thread-1
inner 1: pool-4-thread-2
inner 1: pool-4-thread-2
inner 1: pool-4-thread-3
inner 2: pool-5-thread-1
inner 2: pool-5-thread-2
3: pool-5-thread-1
inner 2: pool-5-thread-2
inner 1: pool-4-thread-3
inner 2: pool-5-thread-2
inner 2: pool-5-thread-3
3: pool-5-thread-1
3: pool-5-thread-1
3: pool-5-thread-1
end: pool-6-thread-1
end: pool-6-thread-1
inner 1: pool-4-thread-3
end: pool-6-thread-1
3: pool-5-thread-1
inner 2: pool-5-thread-1
3: pool-5-thread-1
inner 2: pool-5-thread-3
inner 2: pool-5-thread-1
end: pool-6-thread-1
3: pool-5-thread-3
3: pool-5-thread-3
end: pool-6-thread-1
inner 2: pool-5-thread-3
3: pool-5-thread-3
end: pool-6-thread-1
end: pool-6-thread-1
end: pool-6-thread-1
end: pool-6-thread-1
```

It is pretty long, but should match our assumptions written before. Let’s visualize this:

![](https://cdn-images-1.medium.com/max/2000/1*VNsQnjyftFkMvtcPD8x_rQ.png)

So here we see exactly what we’ve described above. The main trick is that “3” is run on the same scheduler as “inner 2”. We had two starting points (original and inner), where we put the subscribeOn allowing paralleling inside inner. And then moved below the chain adding where necessary observeOn.

Now we’ll switch to the Kotlin Flow version:

![](https://cdn-images-1.medium.com/max/2000/1*qIELqmv38MzyvsUml8QUYw.png)

From the very beginning we fix the main thread as being our end thread. Then we start from the bottom and add `flowOn` where needed. First we add d4 and note that “inner 2” should also run on it. Then we switch to d3 and so on up to the very top of the chain. And here is the result:

```
1: pool-1-thread-1 @coroutine#6
1: pool-1-thread-1 @coroutine#6
1: pool-1-thread-1 @coroutine#6
2: pool-2-thread-2 @coroutine#5
2: pool-2-thread-2 @coroutine#5
2: pool-2-thread-2 @coroutine#5
inner 1: pool-3-thread-1 @coroutine#10
inner 1: pool-3-thread-2 @coroutine#11
inner 1: pool-3-thread-3 @coroutine#12
inner 1: pool-3-thread-2 @coroutine#11
inner 1: pool-3-thread-3 @coroutine#12
inner 2: pool-4-thread-3 @coroutine#9
inner 1: pool-3-thread-1 @coroutine#10
inner 1: pool-3-thread-3 @coroutine#12
inner 1: pool-3-thread-2 @coroutine#11
inner 2: pool-4-thread-1 @coroutine#7
inner 2: pool-4-thread-2 @coroutine#8
inner 2: pool-4-thread-1 @coroutine#7
inner 2: pool-4-thread-3 @coroutine#9
inner 1: pool-3-thread-1 @coroutine#10
3: pool-4-thread-1 @coroutine#3
inner 2: pool-4-thread-3 @coroutine#9
inner 2: pool-4-thread-2 @coroutine#8
end: pool-5-thread-1 @coroutine#2
3: pool-4-thread-1 @coroutine#3
inner 2: pool-4-thread-2 @coroutine#8
3: pool-4-thread-1 @coroutine#3
end: pool-5-thread-1 @coroutine#2
3: pool-4-thread-1 @coroutine#3
end: pool-5-thread-1 @coroutine#2
end: pool-5-thread-1 @coroutine#2
3: pool-4-thread-1 @coroutine#3
3: pool-4-thread-1 @coroutine#3
end: pool-5-thread-1 @coroutine#2
end: pool-5-thread-1 @coroutine#2
3: pool-4-thread-1 @coroutine#3
3: pool-4-thread-1 @coroutine#3
end: pool-5-thread-1 @coroutine#2
end: pool-5-thread-1 @coroutine#2
inner 2: pool-4-thread-1 @coroutine#7
3: pool-4-thread-1 @coroutine#3
end: pool-5-thread-1 @coroutine#2
```

Besides logs look differently (because RxJava is not the same as coroutines) we still can see that all the logic still applies and we haven’t broken parallel execution.

Though we still can see some differences. For example our code which runs “3” in RxJava example was running on:

```
3: pool-5-thread-1
...
3: pool-5-thread-3
```

And in coroutines example it was always run on one thread:

```
3: pool-4-thread-1 @coroutine#3
```

This could be just a coincidence because of concurrency, or maybe it is because of the coroutines better utilizing threads usage (or maybe not, actually I don’t know, so if somebody has some other ideas do not hesitate to post a response). Though we don’t care that much because usage of thread pool was anyway correct.

If we visualize threading, we can do something like:

![](https://cdn-images-1.medium.com/max/2000/1*z6XDLAkVgMLmyeYsvSTbbA.png)

## Conclusion

Kotlin Flow is good and can be compared to RxJava Observable. They have similar look, similar operators and they both handle threading inside their chains. They have similar tricks with usage of `Observable.just` or `flowOf`. But in terms of concurrency and parallelism seems Kotlin Flow is simpler. Also Kotlin Flow has no such an issue as RxJava with `subscribeOn`, as in flow we declare end of the chain with the scope and it is technically impossible to put multiple of them.

On the approaches to handling threading Kotlin Flow and RxJava have opposite concepts: in RxJava we think in terms of top-to-bottom, when in Kotlin Flow from bottom-to-top. But anyway it is possible to migrate your code vice versa if there is need to without breaking much of the functionality.

Hope you’ve enjoyed this article and it was useful for you.

Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
