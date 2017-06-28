> * 原文地址：[A first walk into Kotlin coroutines on Android](https://android.jlelse.eu/a-first-walk-into-kotlin-coroutines-on-android-fe4a6e25f46a)
> * 原文作者：[Antonio Leiva](https://android.jlelse.eu/@antoniolg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

# A first walk into Kotlin coroutines on Android

![](https://cdn-images-1.medium.com/max/800/1*QU1_XFQvVRS5at9EHTqBkw.jpeg)

> This article was extracted and adapted from the latest update of [Kotlin for Android Developers](https://antonioleiva.com/book) book.

Coroutines were the biggest introduction to Kotlin 1.1. They are really great because of how powerful they are, and the community is still finding out how to take the most out of them.

To put it simple, coroutines are a way to write asynchronous code sequentially. **Instead of messing around with callbacks, you can write your lines of code one after the other**. Some of them will have the ability to suspend the execution and wait until the result is available.

If you were a former C# developer, async/await is the closest concept. But coroutines in Kotlin are more powerful, because instead of being a specific implementation of the idea, they are **a language feature that can be implemented in different ways to solve different problems**.

You can write your own implementation, or use one of the several options that the Kotlin team and other independent developers have built.

You need to understand that **coroutines are an experimental feature in Kotlin 1.1**. This means that the implementation might change in the future, and though the old one will still be supported, you would might want to migrate to the new definition. As we’ll see later, you need to opt in for this feature, otherwise you will see a warning when you use it.

But this also means that you should take this article as an example of what you can do, not a rule of thumb. Things may change a lot in the next few months.

---

### Understanding how coroutines work

My goal with this article is that you are able to get some basic concepts and use one of the existing libraries, not to build your own implementations. But I think it’s important to understand some of the internals so that you don’t just blindly use what you are given.

Coroutines are based on the idea of *suspending functions*: **functions that can stop the execution** when they are called and make it continue once it has finished running their own task.

Suspending functions are marked with the reserved word `suspend`, and can only be called inside other suspending functions or inside a coroutine.

This means you can’t call a suspending function everywhere. There needs to be a surrounding function that builds the coroutine and provides the required context for this to be done. Something like this:

    fun <T> async(block: suspend () -> T)

I’m not explaining how to implement the above function. It’s a complex process that it’s out of the scope of this article, and for most cases there are solutions already implemented for you.

If you are really interested in building your own, **you can read the specification written in **[**coroutines Github**](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md). What you just need to know is that the function can have whatever name you want to give it, and that it will have at least a suspending block as a parameter.

Then you could implement a suspending function and call it inside that block:

    suspend fun mySuspendingFun(x: Int) : Result {
     …
    }

    async {
     val res = mySuspendingFun(20)
     print(res)
    }

Coroutines are threads then? Not exactly. They work in a similar way, but **are much more lightweight and efficient**. You can have millions of coroutines running on a few threads, which opens a world of possibilities.

There are three ways you can make use of the coroutines feature:

- *Raw implementation*: it means building your own way to use coroutines. This is quite complex and usually not required at all.
- *Low-level implementations*: Kotlin provides a set of libraries that you can find in [kotlinx.coroutines](https://github.com/Kotlin/kotlinx.coroutines) repository, which solve some of the hardest parts and provide a specific implementation for different scenarios. There’s [one for Android](https://github.com/Kotlin/kotlinx.coroutines/tree/master/ui/kotlinx-coroutines-android), for instance.
- *Higher-level implementations*: if you just want to have **a solution that provides everything you need** to start using coroutines right away, there are several libraries out there that do all the hard work for you, and the list keeps growing. I’m going to stick to [Anko](https://github.com/Kotlin/anko), which provides a solution that works really well on Android, and you are probably already familiar with it.

---

### Using Anko for coroutines

Since 0.10 version, Anko provides a couple of ways to use coroutines in Android.

The first one is very similar to what we saw in the example above, and also similar to what other libraries do.

First, you need to create **an async block where suspension functions can be called**:

    async(UI) {
     …
    }

The UI argument is the execution context for the `async` block.

Then you can create **blocks that are executed in a background thread** and return the result to the UI thread. Those blocks are defined using the `bg` function:

    async(UI) {
     val r1: Deferred<Result> = bg { fetchResult1() }
     val r2: Deferred<Result> = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

`bg` returns a `Deferred` object, which **will suspend the coroutine when the function `await()` is called**, just until the result is returned. We’ll use this solution in the example below.

As you may know, as Kotlin compiler is able to [infer the type of the variables](https://antonioleiva.com/variables-kotlin/), this could be simpler:

    async(UI) {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

The second alternative is to make use of the integration with listeners that is provided on specific sub-libraries, depending on which listener you are going to use.

For instance, on `anko-sdk15-coroutines`, there exists an `onClick` listener whose lambda is indeed a coroutine. So you can start using suspending functions right away inside the listener block:

    textView.onClick {
     val r1 = bg { fetchResult1() }
     val r2 = bg { fetchResult2() }
     updateUI(r1.await(), r2.await())
    }

As you can see, the result is very similar to the previous one. You are just saving some code.

To use it, you will need to add some of these dependencies, depending on the listeners you want to use:

    compile “org.jetbrains.anko:anko-sdk15-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-appcompat-v7-coroutines:$anko_version”
    compile “org.jetbrains.anko:anko-design-coroutines:$anko_version”

---

### Using coroutines in an example

In the example that is explained[ in the book](https://antonioleiva.com/book) (which you can find [here on Github](https://github.com/antoniolg/Kotlin-for-Android-Developers)), we’re creating a simple weather App.

So, to use Anko coroutines, we first need to include the new dependency:

    compile “org.jetbrains.anko:anko-coroutines:$anko_version”

Next, if you remember, I told you that you need to opt in for the feature, otherwise it will show a warning. To do that, simply add this line to the `gradle.properties` file in root folder (create it if it doesn’t exist yet):

    kotlin.coroutines=enable

And now, you are ready to start using coroutines. Let’s go first to the detail activity. It just calls the database (which is caching the weekly forecast) using a specific command.

This is the resulting code:

    async(UI) {
        val id = intent.getLongExtra(ID, -1)
        val result = bg { RequestDayForecastCommand(id)
            .execute() }
        bindForecast(result.await())
    }

This is nice! The forecast is requested in a background thread thanks to the `bg` function, which will return a deferred result. That result is awaited in the `bindForecast` call, until it’s ready to be returned.

But not everything is great. What’s happening here? Coroutines have a problem: **they are keeping a reference to `DetailActivity`, leaking it if the request never finishes** for instance.

Don’t worry, because Anko has a solution. You can create a weak reference to your activity, and use that one instead:

    val ref = asReference()
    val id = intent.getLongExtra(ID, -1)

    async(UI) {
     val result = bg { RequestDayForecastCommand(id).execute() }
     ref().bindForecast(result.await())
    }

This reference will allow calling the activity when it’s available, and will cancel the coroutine in case the activity has been killed. Be careful to ensure that all calls to activity methods or properties are done via this `ref` object.

But this can get a little complicated if the coroutine interacts several times with the activity. In `MainActivity`, for instance, using this solution will become a little more convoluted.

This activity will call an endpoint to request a week forecast based on a zipCode:

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

I honestly think that leaking the activity for 1–2 seconds is not that bad, and probably won’t be worth the boilerplate. So if you can ensure that your background process is not taking forever (for instance, by setting a timeout to your server requests), you will be safe by not using `asReference()`.

This way, the changes to `MainActivity` would be simpler:

    private fun loadForecast() = async(UI) {
     val result = bg { RequestForecastCommand(zipCode).execute() }
     updateUI(result.await())
    }

So with all this, you now have your asynchronous code written in a synchronous way very easily.

This code is quite simple, but imagine complex situations where the result of one background operation is used by the next one, or when you need to iterate over a list and execute a request per item.

All this can be written as regular synchronous code, which will be much easier to read and maintain.

---

There’s much more yet to learn about how to take the most out of coroutines. So if you have some more experience about it, please use the comments to let us know more about it.

And if you are just starting with Kotlin, you can take a look at [my blog](https://antonioleiva.com/kotlin), [the book](https://antonioleiva.com/book), or follow me on [Twitter](https://twitter.com/lime_cl), [LinkedIn](https://www.linkedin.com/in/antoniolg/) or [Github](https://github.com/antoniolg/).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
