> * 原文地址：[Convincing the Kotlin compiler that code is safe](http://blog.danlew.net/2017/06/14/convincing-the-kotlin-compiler-that-code-is-safe/)
> * 原文作者：[Dan Lew](http://blog.danlew.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

One of the best features of Kotlin is its built-in null safety in the type system. Try to use a nullable type in a non-null way and the compiler will yell at you.

This null safety can occasionally create some tricky situations, though. Code that you *know* is ironclad turns out to be full of potential nulls... at least according to the compiler.

## Navigating Maps

Let's look at an example. Suppose we want to convert a `List<String>` into a `Map<String, Int>`, where each `Int` represents the number of times each `String` appeared in the list. Here's how we might try to write it:

    fun countInstances(list: List<String>): Map<String, Int> {
      val map = mutableMapOf<String, Int>()
      for (key in list) {
        if (key !in map) {
          map[key] = 0
        }
        map[key] = map[key] + 1
      }
      return map
    }


The code is logically sound but it doesn't compile. Kotlin complains about this line in particular:

    map[key] = map[key] + 1


`map[key]` is equivalent to `map.get(key)`. Critically, **`get()` has the return type of `T?` since you could feed it a nonexistent key.** Even though *you* know that `map[key]` is non-null, the *compiler* doesn't realize that you always initialize it before use.

I found myself bumping into this problem a lot when working with `Map.get()`. I was applying non-null safety in my head, via the logic of the code, but a compiler can't verify that.

I *could* fallback on the `!!` operator, but it looks alarming for a reason - you shouldn't just ignore compiler errors. There are several better ways around this problem than that.

## Null Checks

Instead of operating on the `Map` directly, we can extract the value first into a local variable and perform a null check:

    val oldValue = map[key]
    if (oldValue != null) {
      map[key] = oldValue + 1
    }
    else {
      map[key] = 1
    }


Even though `oldValue` is a nullable type (`Int?`), it's a local variable and thus inaccessible to other threads. That means the compiler can be assured that it's not changing value after the if-check. As such, Kotlin treats it as non-null in the first branch.

Null checks work, but it's a rather verbose strategy.

## Elvis Operator

We can compact the null-checking solution into a single line of code with [the Elvis operator](https://kotlinlang.org/docs/reference/null-safety.html#elvis-operator):

    map[key] = (map[key] ?: 0) + 1


The Elvis operator allows us to take either the value in `map[key]` or `0`, whichever is non-null first. This guarantees the type `Int`, which we can then increment.

## Jedi Mind Tricks

What if we just wave our hands and say "these aren't non-null values"?

It turns out Kotlin provides a `Map.getValue()` just for this purpose. It has the return type of `T` instead of `T?`. As such, using `map.getValue(key)` works where `map[key]` does not:

    map[key] = map.getValue(key) + 1


What happens if there *is* no value? In that case, it throws an exception! Under the hood, `getValue()` looks a lot like this:

    val value = map[key] ?: throw new NoSuchElementException()


In this context, `getValue()` isn't any better than `!!`. Both will throw an exception if there's a null value. However...

## Default Values

You can wrap your map using `Map.withDefault()` to provide a default value. When using this method, `Map.getValue()` will now return the default value if the key is not found:

    fun countInstances(list: List<String>): Map<String, Int> {
      val map = mutableMapOf<String, Int>().withDefault { 0 }
      for (key in list) {
        map[key] = map.getValue(key) + 1
      }
      return map
    }


In this context, `Map.getValue()`*is* better than `!!` because it is guaranteed to never throw an exception.

If you don't want to wrap your entire `Map` with a default, you can also apply defaults on a case-by-case basis, such as using `Map.getOrDefault()`:

    map[key] = map.getOrDefault(key, 0) + 1


You can also execute the default as a function instead of a plain value using `Map.getOrElse()`:

    map[key] = map.getOrElse(key, { 0 }) + 1


Which is silly in this case, but this method can save time if the default value is expensive to calculate. (Also, `getOrDefault()` was only recently added to Android, so unless you're at minSdkVersion 24 you'll have to rely on Kotlin's `getOrElse()`.)

For this particular problem, default values are about as good as using the Elvis operator.

## Collection Transformations

Instead of iterating through each individual item in the collection, we could instead transform the entire collection at once. Transformations avoid null checking since we're only iterating over values that actually exist in the collection.

There are some nice built-in functions in the Kotlin standard library to solve our exact problem:

    fun countInstances(list: List<String>) = list.groupingBy { it }.eachCount()


What we're doing here is first converting our `List` into a [`Grouping`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/-grouping/). Then we use the helper function `Grouping.eachCount()` to transform that into `Map<String, Int>`.

Collection-level operations can be incredibly powerful and are often more useful than iterating over collections manually (especially because the standard library can optimize what's going on behind the scenes).

## Which is Best?

I've demonstrated a number of strategies to convince the compiler that your code is okay:

1. Null checks
2. Elvis operator
3. Casting to non-null (with possible exception)
4. Default values
5. Collection transformations

(I don't mean to imply that this is an exhaustive list of strategies; differing circumstances may yield more options.)

Often times it depends on context for which strategy is best. In this case, the clear winner is `groupingBy().eachCount()`. It's succinct, efficient, easy-to-understand, and completely sidesteps any null checking whatsoever.

---

*Many thanks to [Jake Wharton](https://twitter.com/JakeWharton) for helping with this article.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
