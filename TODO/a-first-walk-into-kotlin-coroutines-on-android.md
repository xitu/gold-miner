> * 原文地址：[A first walk into Kotlin coroutines on Android](https://android.jlelse.eu/a-first-walk-into-kotlin-coroutines-on-android-fe4a6e25f46a)
> * 原文作者：[Antonio Leiva](https://android.jlelse.eu/@antoniolg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：

---

# A first walk into Kotlin coroutines on Android
# 第一次走进 Android 上的 Kotlin 协程

![](https://cdn-images-1.medium.com/max/800/1*QU1_XFQvVRS5at9EHTqBkw.jpeg)

> This article was extracted and adapted from the latest update of [Kotlin for Android Developers](https://antonioleiva.com/book) book.  

> 本文提取并改编自最近更新的 [Kotlin for Android Developers](https://antonioleiva.com/book) 一书。

Coroutines were the biggest introduction to Kotlin 1.1. They are really great because of how powerful they are, and the community is still finding out how to take the most out of them.

协程是 Kotlin 1.1 引入的最牛逼的功能。他们确实很棒，不但很强大，而且社区仍然在挖掘如何使他们得到更加充分的利用。

To put it simple, coroutines are a way to write asynchronous code sequentially. **Instead of messing around with callbacks, you can write your lines of code one after the other**. Some of them will have the ability to suspend the execution and wait until the result is available.

简单来说，协程是一种按序写异步代码的方式。**你可以一行一行的写程序，而不是到处都有乱七八糟的回调**。有的还有挂起执行然后等待结果返回的能力。

If you were a former C# developer, async/await is the closest concept. But coroutines in Kotlin are more powerful, because instead of being a specific implementation of the idea, they are **a language feature that can be implemented in different ways to solve different problems**.

如果你以前是 C# 程序员，async/await 是最接近的概念。但是 Kotlin 中的协程功能更强大，因为他们不是一个特定想法的实现，而是**一个语言级别的功能，可以有多种实现去解决各种问题**。

You can write your own implementation, or use one of the several options that the Kotlin team and other independent developers have built.

你可以自己去实现，或者使用一个 Kotlin 团队和其他独立开发者已经完成的实现。

You need to understand that **coroutines are an experimental feature in Kotlin 1.1**. This means that the implementation might change in the future, and though the old one will still be supported, you would might want to migrate to the new definition. As we’ll see later, you need to opt in for this feature, otherwise you will see a warning when you use it.

你要明白**协程在 Kotlin 1.1 中是一个实验性的功能**。这意味着当前实现在将来可能会改变，虽然旧的实现仍被支持，但你有可能想迁移到新的定义上。如我们稍后将见，你需要有所选择地使用这个特色，否则在使用的时候会有警告。

But this also means that you should take this article as an example of what you can do, not a rule of thumb. Things may change a lot in the next few months.

这也意味着你应该将本文视为一个（协程）可以做些什么的示例而不是一个经验法则。未来几个月可能会有很大变动。

---

### Understanding how coroutines work  
### 理解协程如何工作

My goal with this article is that you are able to get some basic concepts and use one of the existing libraries, not to build your own implementations. But I think it’s important to understand some of the internals so that you don’t just blindly use what you are given.

本文的目的旨在让你了解一些基本概念，会用一个现有的库，而不是去自己去实现一个。但我认为重要的是了解一些内部原理，这样你就不会盲目使用了。

Coroutines are based on the idea of *suspending functions*: **functions that can stop the execution** when they are called and make it continue once it has finished running their own task.

协程基于 *暂停功能* 的想法：那些方法被调用之后**可以中止（程序）执行**，一旦完成他们自己的任务之后又可以让他继续执行。

Suspending functions are marked with the reserved word `suspend`, and can only be called inside other suspending functions or inside a coroutine.

挂起方法用保留关键字 `suspend` 来标记，而且只能在其他挂起方法或协程内部被调用。

This means you can’t call a suspending function everywhere. There needs to be a surrounding function that builds the coroutine and provides the required context for this to be done. Something like this:

这意味着你不能随便调用一个挂起方法。需要有一个构建协程并提供所需的上下文的包裹函数。类似这样的： 

    fun <T> async(block: suspend () -> T)

I’m not explaining how to implement the above function. It’s a complex process that it’s out of the scope of this article, and for most cases there are solutions already implemented for you.

我并不是在解释如何实现上述方法。那是一个复杂的过程，不在本文范围内，并且大多情况下已经有实现好的方法了。

If you are really interested in building your own, **you can read the specification written in** [**coroutines Github**](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md). What you just need to know is that the function can have whatever name you want to give it, and that it will have at least a suspending block as a parameter.

如果你确实有兴趣实现自己的，你可以读一下写在 [**coroutines Github**](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md) 中的规范。你仅需要知道那个方法名字可以随意取，至少有一个挂起块做为参数。

Then you could implement a suspending function and call it inside that block:

你可以实现一个挂起方法然后在块中调用：

    suspend fun mySuspendingFun(x: Int) : Result {
     …
    }

    async {
     val res = mySuspendingFun(20)
     print(res)
    }

Coroutines are threads then? Not exactly. They work in a similar way, but **are much more lightweight and efficient**. You can have millions of coroutines running on a few threads, which opens a world of possibilities.

协程是线程吗？不完全是。他们以相似的方式工作，但是（协程）更轻量、更有效。你可以有数以百万的协程运行在少量的几个线程中，这打开了一个充满可能性的世界。

There are three ways you can make use of the coroutines feature:

使用协程功能有三种方式：

- *Raw implementation*: it means building your own way to use coroutines. This is quite complex and usually not required at all.
- *原始实现*：意思是你用自己的方式去创建。这非常复杂并且通常不是必要的。
- *Low-level implementations*: Kotlin provides a set of libraries that you can find in [kotlinx.coroutines](https://github.com/Kotlin/kotlinx.coroutines) repository, which solve some of the hardest parts and provide a specific implementation for different scenarios. There’s [one for Android](https://github.com/Kotlin/kotlinx.coroutines/tree/master/ui/kotlinx-coroutines-android), for instance.
- *低级的实现*： Kotlin 提供了一套库，解决了一些最难的部分并提供了不同场景下的具体实现，你可以在 [kotlinx.coroutines](https://github.com/Kotlin/kotlinx.coroutines) 库中找到，例如 [one for Android](https://github.com/Kotlin/kotlinx.coroutines/tree/master/ui/kotlinx-coroutines-android) 。
- *Higher-level implementations*: if you just want to have **a solution that provides everything you need** to start using coroutines right away, there are several libraries out there that do all the hard work for you, and the list keeps growing. I’m going to stick to [Anko](https://github.com/Kotlin/anko), which provides a solution that works really well on Android, and you are probably already familiar with it.
- *高级实现*：如果你只是想要**一个可以提供一切你所需要的解决方案**来马上开始使用协程的话，有几个库可以使用，他们为你做了所有复杂的工作，并且（库的）数量在持续增长。我推荐  [Anko](https://github.com/Kotlin/anko)，他提供了一个可以很好的工作在 Android 上的方案，有可能你已经很熟悉了。

---

### Using Anko for coroutines
### 使用 Anko 实现协程

Since 0.10 version, Anko provides a couple of ways to use coroutines in Android.

自从 0.10 版本以来，Anko 提供了两种方法以在 Android 上使用协程。

The first one is very similar to what we saw in the example above, and also similar to what other libraries do.

第一种与我们在上面的例子中看到的非常相似，和其他的库所做的也类似。

First, you need to create **an async block where suspension functions can be called**:

首先，你需要创建**一个可以调用挂起方法的异步块**：

    async(UI) {
     …
    }

The UI argument is the execution context for the `async` block.

UI参数是`async`块的执行上下文。

Then you can create **blocks that are executed in a background thread** and return the result to the UI thread. Those blocks are defined using the `bg` function:

然后你可以创建**在后台线程中执行的块**，将结果返回给UI线程。那些块就是以 `bg` 方法定义的。

    async(UI) {
     val r1: Deferred<Result> = bg { fetchResult1() }
     val r2: Deferred<Result> = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

`bg` returns a `Deferred` object, which **will suspend the coroutine when the function `await()` is called**, just until the result is returned. We’ll use this solution in the example below.

`bg` 返回一个 `Deferred` 对象，这个对象**在 `await()` 方法被调用后会挂起协程**，直到有结果返回。我们将在下面的例子中采用这种方案。

As you may know, as Kotlin compiler is able to [infer the type of the variables](https://antonioleiva.com/variables-kotlin/), this could be simpler:

正如你可能知道的，由于 Kotlin 编译器能够[推导出变量类型](https://antonioleiva.com/variables-kotlin/)，因此可以更加简单：

    async(UI) {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

The second alternative is to make use of the integration with listeners that is provided on specific sub-libraries, depending on which listener you are going to use.

第二种方法是使用与特定子库中提供的监听器的集成，这取决于你打算使用哪个监听器。

For instance, on `anko-sdk15-coroutines`, there exists an `onClick` listener whose lambda is indeed a coroutine. So you can start using suspending functions right away inside the listener block:

例如，在 `anko-sdk15-coroutines` 有一个 `onClick` 监听器，他的 lambda 实际 上是一个协程。这样你就可以在监听器代码块上立即使用挂起方法：

    textView.onClick {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

As you can see, the result is very similar to the previous one. You are just saving some code.

如你所见，结果与之前的很相似。只是少了一些代码。

To use it, you will need to add some of these dependencies, depending on the listeners you want to use:

为了使用他，你需要添加一些依赖，这取决于你想要使用哪些监听器：

    compile “org.jetbrains.anko:anko-sdk15-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-appcompat-v7-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-design-coroutines:$anko_version”

---

### Using coroutines in an example
### 在示例中使用协程

In the example that is explained[ in the book](https://antonioleiva.com/book) (which you can find [here on Github](https://github.com/antoniolg/Kotlin-for-Android-Developers)), we’re creating a simple weather App.

在[这本书](https://antonioleiva.com/book)所解释的例子（你可以在[这里](https://github.com/antoniolg/Kotlin-for-Android-Developers)找到）中，我们创建了一个简单的天气应用。

So, to use Anko coroutines, we first need to include the new dependency:

为了使用 Anko 协程，我们首先需要这个新的依赖：

    compile “org.jetbrains.anko:anko-coroutines:$anko_version”

Next, if you remember, I told you that you need to opt in for the feature, otherwise it will show a warning. To do that, simply add this line to the `gradle.properties` file in root folder (create it if it doesn’t exist yet):

接下来，如果你还记得，我曾经告诉过你需要有所选择地使用这个功能，否则就会有警告。要做到这一点，只需要简单的在根文件夹（如果不存在就创建）下的 `gradle.properties` 文件中添加这一行：

    kotlin.coroutines=enable

And now, you are ready to start using coroutines. Let’s go first to the detail activity. It just calls the database (which is caching the weekly forecast) using a specific command.

现在，你已经准备好开始使用协程了。让我们首先进入详情 activity 中。他只是使用一个特定的命令调用了数据库（用来缓存每周的天气预报）。

This is the resulting code:

这是生成的代码：

    async(UI) {
        val id = intent.getLongExtra(ID, -1)
        val result = bg { RequestDayForecastCommand(id)
            .execute() }
        bindForecast(result.await())
    }

This is nice! The forecast is requested in a background thread thanks to the `bg` function, which will return a deferred result. That result is awaited in the `bindForecast` call, until it’s ready to be returned.

太好了！天气预报数据是在一个后台线程中请求的，这多亏了 `bg` 方法，这个方法返回了一个延迟结果。那个延迟结果一直在 `bindForecast` 调用中等待，直到真正返回。

But not everything is great. What’s happening here? Coroutines have a problem: **they are keeping a reference to `DetailActivity`, leaking it if the request never finishes** for instance.

但并不是所有都好。发生了什么？协程有个问题：例如，**他们持有一个 `DetailActivity` 的引用，如果这个请求永不结束就会内存泄露**。

Don’t worry, because Anko has a solution. You can create a weak reference to your activity, and use that one instead:

别担心，因为 Anko 有一个解决方案。你可以为你的 activity 创建一个弱引用，然后使用那个弱引用来代替：

    val ref = asReference()
    val id = intent.getLongExtra(ID, -1)

    async(UI) {
     val result = bg { RequestDayForecastCommand(id).execute() }
     ref().bindForecast(result.await())
    }

This reference will allow calling the activity when it’s available, and will cancel the coroutine in case the activity has been killed. Be careful to ensure that all calls to activity methods or properties are done via this `ref` object.

在 activity 可用时，弱引用允许调用 activity，假使 activity 被杀死就取消协程。需要仔细确保的是所有对 activity 中的方法或属性的调用都要经过这个 `ref` 对象。

But this can get a little complicated if the coroutine interacts several times with the activity. In `MainActivity`, for instance, using this solution will become a little more convoluted.

但是如果协程多次和 activity 交互的话会有点复杂。例如，在 `MainActivity` 使用这个方案将变得更加复杂。

This activity will call an endpoint to request a week forecast based on a zipCode:

这个 activity 将基于一个 zipCode 来调用一个端点来请求一周的天气预报数据：

    private fun loadForecast() {

    val ref = asReference()
     val localZipCode = zipCode

    async(UI) {
     val result = bg { RequestForecastCommand(localZipCode).execute() }
     val weekForecast = result.await()
     ref().updateUI(weekForecast)
     }
    }

You can’t use `ref()` inside the `bg` block, because the code inside that block is not a suspension context, so you need to save the `zipCode` into another local variable.

你不能在 `bg` 块中使用 `ref()` ，因为在这个块中的代码不是一个挂起上下文，因为你需要将 `zipCode` 保存在一个本地变量中。

I honestly think that leaking the activity for 1–2 seconds is not that bad, and probably won’t be worth the boilerplate. So if you can ensure that your background process is not taking forever (for instance, by setting a timeout to your server requests), you will be safe by not using `asReference()`.

老实说，我认为泄露 activity 对象 1-2 秒没那么糟糕，不过有可能不能成为样板代码。因此如果你能确保你的后台处理不会永远不结束（比如，你可以为你的服务器请求设置一个超时）的话，不使用 `asReference()` 也是安全的。

This way, the changes to `MainActivity` would be simpler:

这样的话，`MainActivity` 将变得更加简单：

    private fun loadForecast() = async(UI) {
     val result = bg { RequestForecastCommand(zipCode).execute() }
     updateUI(result.await())
    }

So with all this, you now have your asynchronous code written in a synchronous way very easily.

综上，你已经拥有了你自己的用一种非常简单的同步方式书写的异步代码。

This code is quite simple, but imagine complex situations where the result of one background operation is used by the next one, or when you need to iterate over a list and execute a request per item.

这段代码非常简单，但是你可以想象一下复杂的情况：后台操作的结果被下一个后台操作使用，或者当你需要遍历列表并为第一项执行请求的时候。

All this can be written as regular synchronous code, which will be much easier to read and maintain.

所有一切都可以写成常规的同步代码，写起来、维护起来将更加容易。

---

There’s much more yet to learn about how to take the most out of coroutines. So if you have some more experience about it, please use the comments to let us know more about it.

关于如何充分利用协程还有更多需要学习。如果你有更多关于他的经验，请评论以让我们更加了解他。

And if you are just starting with Kotlin, you can take a look at [my blog](https://antonioleiva.com/kotlin), [the book](https://antonioleiva.com/book), or follow me on [Twitter](https://twitter.com/lime_cl), [LinkedIn](https://www.linkedin.com/in/antoniolg/) or [Github](https://github.com/antoniolg/).

如果你刚刚开始学习 Kotlin ，你可以看看我的[博客](https://antonioleiva.com/kotlin)，[这本书](https://antonioleiva.com/book)，或者关注我的 [Twitter](https://twitter.com/lime_cl)， [LinkedIn](https://www.linkedin.com/in/antoniolg/) 或者 [Github](https://github.com/antoniolg/) 。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
