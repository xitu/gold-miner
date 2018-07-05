> * 原文地址：[Kotlin Demystified: Understanding Shorthand Lambda Syntax](https://medium.com/google-developers/kotlin-demystified-understanding-shorthand-lamba-syntax-74724028dcc5)
> * 原文作者：[Nicole Borrelli](https://medium.com/@borrelli?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-demystified-understanding-shorthand-lamba-syntax.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-demystified-understanding-shorthand-lamba-syntax.md)
> * 译者：
> * 校对者：

# Kotlin Demystified: Understanding Shorthand Lambda Syntax

![](https://cdn-images-1.medium.com/max/1600/1*bNXslQsg8CYCyD5-1MkK5A.jpeg)

Photo by [Stefan Steinbauer](https://unsplash.com/photos/HK8IoD-5zpg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/secret?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

During a trip to Austria, I visited the Austrian National Library in Vienna. The State Hall, in particular, is this amazing space that feels like something out of an Indiana Jones film. Spaced around the room are these doors built into the shelves, and it’s tempting to imagine what sort of secrets are hidden behind them.

As it turns out, however, they’re simply reading rooms.

Let’s imagine we have an app that tracks the books in the library. One day we’re wondering what the longest and shortest books in the collection are. After a bit, we write the code that allows us to find both of these:

```
    val shortestBook = library.minBy { it.pageCount }val longestBook = library.maxBy { it.pageCount }
```

Perfect! But this got me wondering, how do these methods work? How does `it` know, just from writing `it.pageCount`, how to do this?

The first thing I did was to click through to the definitions of `minBy`and `maxBy`, which are both in [_Collections.kt](https://github.com/JetBrains/kotlin/blob/1.2.50/libraries/stdlib/common/src/generated/_Collections.kt). Since they’re both nearly identical, let’s focus on `maxBy`, which starts on [line 1559](https://github.com/JetBrains/kotlin/blob/1.2.50/libraries/stdlib/common/src/generated/_Collections.kt#L1559).

The method there is build on the `[Iterable](https://developer.android.com/reference/java/lang/Iterable)` interface, but if we do a minor rewrite to work with `[Collection](https://developer.android.com/reference/java/util/Collection)`s, and perhaps rename some variables to be a bit more verbose, it’s easier to follow:

```
public inline fun <T, R : Comparable<R>> Collection<T>.maxBy(selector: (T) -> R): T? {
    if (isEmpty()) return null
    var maxElement = first()
    var maxValue = selector(maxElement)
    for (element in this) {
        val value = selector(element)
        if (maxValue < value) {
            maxElement = element
            maxValue = value
        }
    }
    return maxElement
}
```

We can see that it’s just grabbing each element in the `Collection`, checking if the value, from the `selector`, is greater than the max value its seen. If it is, it saves both the element and value. At the end, it returns the largest element it found. Rather simple.

`selector`, however, looks kind of neat, and it must be the thing that allows us to use `it.pageCount` above, so let's look into it some more.

There’s even quite a bit of syntactic sugar even just in this bit of the line. `selector: (T) -> R` is the short way to say a function that takes a single parameter, `T` in this case, and returns something of type `R`.

The way that works is Kotlin includes a set of interfaces called `FunctionN`, where _N_ is the number of parameters it accepts. Since ours has one, we can implement the `Function1` interface and then use that in our code:

```
class BookSelector : Function1<Book, Int> {
   override fun invoke(book: Book): Int {
       return book.pageCount
   }
}
 
val longestBook = library.maxBy(BookSelector())
```

That certainly shows how it works easily enough. `selector` is a `Function1` that, when given a `Book`, returns an `Int`. Then, `maxBy` takes the `Int` and compares it to the value it has.

This, incidentally, also explains why the generic parameter `R` has the type `R [implements] Comparable<R>`. If `R` weren't `Comparable`, we couldn't do `if (maxValue < value)`.

The next question then is, how do we go from [that](#full), to the one liner we started with? Let’s step through the process.

First, the code can be replaced with a lambda, which already shrinks it quite a bit:

```
val longestBook = library.maxBy({
    it.pageCount
})
```

The next step is that if the _last_ parameter of a method is a lambda, we’re allowed to close the parentheses and then add the lambda to the end of the line, like this:

```
val longestBook = library.maxBy() {
    it.pageCount
}
```

Finally, if a method only takes a lambda parameter, we’re allowed to completely leave off the `()` from the method, which gets us back to our initial code:

```
    val longestBook = library.maxBy { it.pageCount }
```

But wait! What about that `Function1`! Am I performing an allocation whenever I use this?

That’s a great question! The good news is, no, you’re not. If you look again, you’ll see that `maxBy` is marked as an `inline` function. This happens at the source level during compilation, so while there's more code compiled than it might initially look like there is, there aren't any significant performance impacts, and certainly no object allocations.

Awesome! Now we not only know what’s the shortest (and longest) books are in the library, we also better understand how `maxBy`works. We saw how Kotlin uses `[FunctionN](#full)` interfaces for lambdas, and how it's sometimes possible to move a lambda expressions outside the parameter list of functions. Finally, we learned that it's possible to [completely omit the parenthesis](#noparen) normally used when calling functions when there's only a single, lambda parameter.

Check out the [Google Developers](https://medium.com/google-developers) blog for more great content, and stay tuned for more articles on Kotlin!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
