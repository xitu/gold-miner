> * 原文地址：[A first walk into Kotlin coroutines on Android](https://android.jlelse.eu/a-first-walk-into-kotlin-coroutines-on-android-fe4a6e25f46a)
> * 原文作者：[Antonio Leiva](https://android.jlelse.eu/@antoniolg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[wilsonandusa](https://github.com/wilsonandusa) 、[atuooo](https://github.com/atuooo)

---

# 第一次走进 Android 中的 Kotlin 协程

![](https://cdn-images-1.medium.com/max/800/1*QU1_XFQvVRS5at9EHTqBkw.jpeg)

> 本文提取并改编自最近更新的 [Kotlin for Android Developers](https://antonioleiva.com/book) 一书。


协程是 Kotlin 1.1 引入的最牛逼的功能。他们确实很棒，不但很强大，而且社区仍然在挖掘如何使他们得到更加充分的利用。

简单来说，协程是一种按序写异步代码的方式。**你可以一行一行地写代码，而不是到处都有乱七八糟的回调**。有的还将会有暂停执行然后等待结果返回的能力。

如果你以前是 C# 程序员，async/await 是最接近的概念。但是 Kotlin 中的协程功能更强大，因为他们不是一个特定想法的实现，而是**一个语言级别的功能，可以有多种实现去解决各种问题**。

你可以编写自己的实现，或者使用一个 Kotlin 团队和其他独立开发者已经构建好的实现。

你要明白**协程在 Kotlin 1.1 中是一个实验性的功能**。这意味着当前实现在将来可能会改变，尽管旧的实现仍将被支持，但你有可能想迁移到新的定义上。如我们稍后将见，你需要去选择开启这个特性，否则在使用的时候会有警告。

这也意味着你应该将本文视为一个（协程）可以做些什么的示例而不是一个经验法则。未来几个月可能会有很大变动。

---
 
### 理解协程如何工作

本文旨在让你了解一些基本概念，会用一个现有的库，而不是去自己去实现一个。但我认为重要的是了解一些内部原理，这样你就不会盲目使用了。

协程基于**暂停函数**的想法：那些函数被调用之后**可以终止（程序）执行**，一旦完成他们自己的任务之后又可以让他（程序）继续执行。

暂停函数用保留关键字 `suspend` 来标记，而且只能在其他暂停函数或协程内部被调用。

这意味着你不能随便调用一个暂停函数。需要有一个包裹函数来构建协程并提供所需的上下文。类似这样的： 

    fun <T> async(block: suspend () -> T)

我并不是在解释如何实现上述方法。那是一个复杂的过程，不在本文范围内，并且大多情况下已经有多种实现好的方法了。

如果你确实有兴趣实现自己的，你可以读一下 [**coroutines Github**](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md) 中所写的规范。你仅需要知道的是：方法名字可以随意取，至少有一个暂停块做为参数。

然后你可以实现一个暂停函数并在块中调用：

    suspend fun mySuspendingFun(x: Int) : Result {
     …
    }

    async {
     val res = mySuspendingFun(20)
     print(res)
    }

协程是线程吗？不完全是。他们的工作方式相似，但是（协程）更轻量、更有效。你可以有数以百万的协程运行在少量的几个线程中，这打开了一个充满可能性的世界。

使用协程功能有三种方式：

- **原始实现**：意思是创建你自己的方式去使用协程。这非常复杂并且通常不是必要的。
- **底层实现**： Kotlin 提供了一套库，解决了一些最难的部分并提供了不同场景下的具体实现，你可以在 [kotlinx.coroutines](https://github.com/Kotlin/kotlinx.coroutines) 仓库中找到这些库，比如说： [one for Android](https://github.com/Kotlin/kotlinx.coroutines/tree/master/ui/kotlinx-coroutines-android) 。
- **高级实现**：如果你只是想要**一个可以提供一切你所需的解决方案**来开始马上使用协程的话，有几个库可以使用，他们为你做了所有复杂的工作，并且（库的）数量在持续增长。我推荐  [Anko](https://github.com/Kotlin/anko)，他提供了一个可以很好的工作在 Android 上的方案，有可能你已经很熟悉了。

---

### 使用 Anko 实现协程

自从 0.10 版本以来，Anko 提供了两种方法以在 Android 上使用协程。

第一种与我们在上面的例子中看到的非常相似，和其他的库所做的也类似。

首先，你需要创建**一个可以调用暂停函数的异步块**：

    async(UI) {
     …
    }

UI参数是 `async` 块的执行上下文。

然后你可以创建**在后台线程中执行的块**，将结果返回给UI线程。那些块以 `bg` 方法定义：

    async(UI) {
     val r1: Deferred<Result> = bg { fetchResult1() }
     val r2: Deferred<Result> = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

`bg` 返回一个 `Deferred` 对象，这个对象**在 `await()` 方法被调用后会暂停协程**，直到有结果返回。我们将在下面的例子中采用这种方案。

正如你可能知道的，由于 Kotlin 编译器能够[推导出变量类型](https://antonioleiva.com/variables-kotlin/)，因此可以更加简单：

    async(UI) {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

第二种方法是利用与特定子库中提供的监听器的集成，这取决于你打算使用哪个监听器。

例如，在 `anko-sdk15-coroutines` 中有一个 `onClick` 监听器，他的 lambda 实际上是一个协程。这样你就可以在监听器代码块上立即使用暂停函数：

    textView.onClick {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

如你所见，结果与之前的很相似。只是少了一些代码。

为了使用他，你需要添加一些依赖，这取决于你想要使用哪些监听器：

    compile “org.jetbrains.anko:anko-sdk15-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-appcompat-v7-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-design-coroutines:$anko_version”

---

### 在示例中使用协程

在[这本书](https://antonioleiva.com/book)所解释的例子（你可以在[这里](https://github.com/antoniolg/Kotlin-for-Android-Developers)找到）中，我们创建了一个简单的天气应用。

为了使用 Anko 协程，我们首先需要添加这个新的依赖：

    compile “org.jetbrains.anko:anko-coroutines:$anko_version”

接下来，如果你还记得，我曾经告诉过你需要选择使用这个功能，否则就会出现警告。要做到这一点（使用协程功能），只需要简单地在根文件夹下的 `gradle.properties` 文件（如果不存在就创建）中添加这一行：

    kotlin.coroutines=enable

现在，你已经准备好开始使用协程了。让我们首先进入详情 activity 中。他只是使用一个特定的命令调用了数据库（用来缓存每周的天气预报数据）。

这是生成的代码：

    async(UI) {
        val id = intent.getLongExtra(ID, -1)
        val result = bg { RequestDayForecastCommand(id)
            .execute() }
        bindForecast(result.await())
    }

太棒了！天气预报数据是在一个后台线程中请求的，这多亏了 `bg` 方法，这个方法返回了一个延迟结果。那个延迟结果在可以返回前会一直在 `bindForecast` 调用中等待。

但并不是一切都好。发生了什么？协程有一个问题：**他们持有一个 `DetailActivity` 的引用，如果这个请求永不结束就会内存泄露**。

别担心，因为 Anko 有一个解决方案。你可以为你的 activity 创建一个弱引用，然后使用那个弱引用来代替：

    val ref = asReference()
    val id = intent.getLongExtra(ID, -1)

    async(UI) {
     val result = bg { RequestDayForecastCommand(id).execute() }
     ref().bindForecast(result.await())
    }

在 activity 可用时，弱引用允许访问 activity，当 activity 被杀死，协程将会取消。需要仔细确保的是所有对 activity 中的方法或属性的调用都要经过这个 `ref` 对象。

但是如果协程多次和 activity 交互的话会有点复杂。例如，在 `MainActivity` 使用这个方案将变得更加复杂。

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

你不能在 `bg` 块中使用 `ref()` ，因为在那个块中的代码不是一个暂停上下文，因此你需要将 `zipCode` 保存在另一个本地变量中。

老实说，我认为泄露 activity 对象 1-2 秒没那么糟糕，不过有可能不能成为样板代码。因此如果你能确保你的后台处理不会永远不结束（比如，为你的服务器请求设置一个超时）的话，不使用 `asReference()` 也是安全的。

这样的话，`MainActivity` 将变得更加简单：

    private fun loadForecast() = async(UI) {
     val result = bg { RequestForecastCommand(zipCode).execute() }
     updateUI(result.await())
    }

综上，你已经可以一种非常简单的同步方式来写你的异步代码。

这些代码非常简单，但是想象一下复杂的情况：后台操作的结果被下一个后台操作使用，或者当你需要遍历列表并为每一项都执行请求的时候。

所有一切都可以写成常规的同步代码，写起来、维护起来将更加容易。

---

关于如何充分利用协程还有很多需要学习。如果你有更多相关的经验，请评论以让我们更加了解协程。

如果你刚刚开始学习 Kotlin ，你可以看看[我的博客](https://antonioleiva.com/kotlin)，[这本书](https://antonioleiva.com/book)，或者关注我的 [Twitter](https://twitter.com/lime_cl)， [LinkedIn](https://www.linkedin.com/in/antoniolg/) 或者 [Github](https://github.com/antoniolg/) 。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
