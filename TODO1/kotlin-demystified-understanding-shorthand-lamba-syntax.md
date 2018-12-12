> * 原文地址：[Kotlin Demystified: Understanding Shorthand Lambda Syntax](https://medium.com/google-developers/kotlin-demystified-understanding-shorthand-lamba-syntax-74724028dcc5)
> * 原文作者：[Nicole Borrelli](https://medium.com/@borrelli?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-demystified-understanding-shorthand-lamba-syntax.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-demystified-understanding-shorthand-lamba-syntax.md)
> * 译者：[androidxiao](https://github.com/androidxiao)

# Kotlin 揭秘：理解并速记 Lambda 语法

![](https://cdn-images-1.medium.com/max/1600/1*bNXslQsg8CYCyD5-1MkK5A.jpeg)

摄影：[Stefan Steinbauer](https://unsplash.com/photos/HK8IoD-5zpg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)，来自 [Unsplash](https://unsplash.com/search/photos/secret?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)。

在奥地利旅行期间，我参观了维也纳的奥地利国家图书馆。特别是国会大厅，这个令人惊叹的空间感觉就像印第安纳琼斯电影中的一些东西。房间周围的空间是这些门被装在架子上，很容易想象它们背后隐藏着什么样的秘密。

然而，事实证明，它们只是简单的图书馆。

让我们假设我们有一个应用程序来跟踪库中的书籍。有一天，我们想知道这个系列中最长和最短的书是什么。之后，我们编写代码，允许我们找到这两个：

```
val shortestBook = library.minBy { it.pageCount }val longestBook = library.maxBy { it.pageCount }
```

完美！但这让我感到疑惑，这些方法是如何工作的？`it` 是怎么知道的，只是写了 `it.pageCount`，到底该怎么做呢？

我做的第一件事就是定义 `minBy` 和 `maxBy`，这两者都是在 [Collections.kt](https://github.com/JetBrains/kotlin/blob/1.2.50/libraries/stdlib/common/src/generated/_Collections.kt)。由于它们几乎完全相同，所以让我们来看看 `maxBy`，它从 1559 行开始。

那里的方法是在 `[Iterable](https://developer.android.com/reference/java/lang/Iterable)` 接口上构建的，但是如果我们做一个小的重写来使用`[Collection](https://developer.android.com/reference/java/util/Collection)`s，也许将一些变量的重命名变的更冗长，更容易理解：

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

我们可以看到它只是在 `Collection` 中获取每个元素，检查来自 `selector` 的值是否大于它看到的最大值。如果是，则保存元素和值。最后，它返回它找到的最大元素。相当简单。

然而 `selector`，看起来很整洁,它必须是允许我们在上面使用 `it.pageCount` 的东西，所以让我们再看看它。

即使只是在这一行中，甚至还有相当多的语法糖。在这种情况下，对于 `selector: (T) -> R` 来说是一个带有单个参数 `T` 的函数，并返回一些类型 `R` 相关的返回值。

可行的方法是 Kotlin 包含一组名为 `FunctionN` 的接口，其中 `N` 是它接受的参数数量。由于我们有一个参数，我们可以实现 `Function1` 接口，然后在我们的代码中使用它：

```
class BookSelector : Function1<Book, Int> {
   override fun invoke(book: Book): Int {
       return book.pageCount
   }
}
 
val longestBook = library.maxBy(BookSelector())
```

这无疑显示了它的工作原理。`selector` 是一个 `Function1`，当给定 `Book` 时，返回一个 `Int`。然后，`maxBy` 获取 `Int` 并将其与它具有的值进行比较。

顺便说一句，这也解释了为什么泛型参数 `R` 具有类型 `R [implements] Comparable <R>`。如果 `R` 不是 `Comparable `，我们不能做 `if（maxValue <value）`。

接下来的问题是，我们如何从那开始，到我们开始的一个循环？让我们逐步完成整个过程。

首先，代码可以替换为 `lambda`，它已经减少了很多：

```
val longestBook = library.maxBy({
    it.pageCount
})
```

下一步是如果方法的最后一个参数是 lambda，我们可以关闭括号，然后将 lambda 添加到行的末尾，如下所示：

```
val longestBook = library.maxBy() {
    it.pageCount
}
```

最后，如果一个方法只接受一个 lambda 参数，我们就可以完全放弃 `()` 方法，这会让我们回到初始代码：

```
val longestBook = library.maxBy { it.pageCount }
```

但是等等！那个 `Function1` 要怎么样！我每次使用它时都会执行分配吗？

这是一个很好的问题！好消息是，不，你不是。如果你再看一遍，你会看到它 `maxBy` 被标记为一个 `inline` 函数。这在编译期时会在源级别发生，因此虽然编译的代码比最初看起来的样本多，但是没有任何显着的性能影响，当然也没有对象分配。

真棒！现在，我们不仅知道图书馆中最短（也是最长）的书籍，我们还能更好地理解 `maxBy` 它是如何工作的。我们看到 Kotlin 如何使用`[FunctionN](#full)` lambda 的接口，以及如何将 lambda 表达式移到函数的参数列表之外。最后，我们知道，当只有一个 lambda 参数调用函数时，可以[完全省略](https://medium.com/google-developers/kotlin-demystified-understanding-shorthand-lamba-syntax-74724028dcc5#noparen)通常使用[的括号](https://medium.com/google-developers/kotlin-demystified-understanding-shorthand-lamba-syntax-74724028dcc5#noparen)。

查看 [Google Developers](https://medium.com/google-developers) 博客，了解更多精彩内容，敬请期待更多关于 Kotlin 的文章！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
