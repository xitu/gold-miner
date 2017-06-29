> * 原文地址：[Convincing the Kotlin compiler that code is safe](http://blog.danlew.net/2017/06/14/convincing-the-kotlin-compiler-that-code-is-safe/)
> * 原文作者：[Dan Lew](http://blog.danlew.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[wilsonandusa](https://github.com/wilsonandusa)
> * 校对者：[mnikn](https://github.com/mnikn)，[zaraguo](https://github.com/zaraguo)

 Kotlin 这门语言最出色的特点之一就是它内部自带的空值安全系统。如果你在要求非空的情况下使用空值，那么编译器会就会发出警告。

不过确保空值安全偶尔也会造成一些棘手的情况。你所**熟知**的毋庸置疑的代码也会布满空值的隐患...至少从编译器的角度来说是这样。

## 操纵 Map

来看一个例子。假设我们想将一个 `List<String>` 转化为 `Map<String, Int>`， 其中每一个 `Int` 代表对应 `String` 在数列中所出现的次数。我们可以这么写：

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


代码逻辑正确但却无法编译。 Kotlin 认为这行代码有问题：

    map[key] = map[key] + 1



 `map[key]` 等同于 `map.get(key)` 。严格上来讲 **`get()` 会返回 `T?` 类型，因为你可以给它提供一个本身不存在的关键词**。即使**你**知道 `map[key]` 不是空值，**编译器**意识不到你在每次使用 `map[key]` 前都会将其初始化。

我发现我在使用 `Map.get()` 时经常出现这个问题。我自己总是通过思考代码的逻辑来保障非空值的使用是否安全，但编译器无法对此进行核实。

我可以依赖使用运算符`!!`，但它看上去就像是一种警告 - 你不能无视编译器所产生的的错误。以下是其他几种可以解决这种问题的方法。

## 空值检查

不直接在地图上进行操作，而是通过先提取数值并存储于本地变量中再进行空值检查。

    val oldValue = map[key]
    if (oldValue != null) {
      map[key] = oldValue + 1
    }
    else {
      map[key] = 1
    }

虽然 `oldValue` 是可为空类型( `Int?`)，但它是一个本地变量，所以其他线程无法接触到它。这意味着编译器能确保在条件判断后这个变量的值不会再发生改变。结果就是 Kotlin 将其视为非空变量。

空值检查可以用，但是这个方法较为繁琐。

## Elvis运算符
我们可以通过结合[ Elvis 运算符](https://kotlinlang.org/docs/reference/null-safety.html#elvis-operator)将空值检查的解法压缩为单行代码:

    map[key] = (map[key] ?: 0) + 1


 Elvis 运算符会选择 `map[key]` 和`0`中第一个为非空值的那一个。这样能保证结果为整数类型，以便后期对其进行增值。

## 绝地心术
如果我们直接声明“这些都不是非空值”会发生什么呢？

其实 Kotlint 专门为此提供了 `Map.getValue()`。这个函数会返回 `T` 类而不是 `T?` 类。因此， `map.getValue(key)` 具有 `map[key]` 所不具备的功能：

    map[key] = map.getValue(key) + 1


如果**本来**就没有值会发生什么？这种情况下，它会生成一个异常！ `getValue()` 本身长这样：

    val value = map[key] ?: throw new NoSuchElementException()



结合前文可得知， `getValue()` 和`!!`其实差不多。如果有空值存在它们都会生成异常，然而...

## 默认值

你可以通过使用 `Map.withDefault()` 来给你的 Map 提供默认值。使用这个方法的话， `Map.getValue()` 在找不到关键词的情况下会返回默认值：

    fun countInstances(list: List<String>): Map<String, Int> {
      val map = mutableMapOf<String, Int>().withDefault { 0 }
      for (key in list) {
        map[key] = map.getValue(key) + 1
      }
      return map
    }



在这种情况下， `Map.getValue()` **肯定**比`!!`好，因为它不可能产生异常。

如果你不想为整个地图设置默认值，你也可以分情况使用默认值，比如用 `Map.getOrDefault()`:

    map[key] = map.getOrDefault(key, 0) + 1


除了使用数值作为默认值，你还可以使用 `Map.getOrElse()` 将函数作为默认值：

    map[key] = map.getOrElse(key, { 0 }) + 1



在这个例子里这么写很不明智，但如果默认值的计算很费时，这个方法会节省很多时间。（同时，由于 `getOrDefault()` 最近才添加到 Android 中，除非你所使用的最低开发版本为24，你还得用 Kotlin 的 `getOrElse()` 函数。）在这个例子中，设默认值和使用 Elvis 运算符都行。

## 集合的变形

除了遍历集合中的每一个元素，我们也可以将整个集合进行一次变形。变形能避免空值检查，因为我们所遍历的元素一定存在于集合中。

 Kotlin 的标准库中内置很多不错的函数正好能解决我们的问题：

    fun countInstances(list: List<String>) = list.groupingBy { it }.eachCount()


这里我们首先将 `List` 转化为[ `Grouping`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/-grouping/)，然后我们用 `Grouping.eachCount()` 将其变形为 `Map<String, Int>`。

集合层面的操作能力十分强大，经常会比遍历整个集合有用很多（主要是因为标准库会在背后进行优化）。

## 哪个最好？

我已经示范了几种能保证代码通过编译器的策略：
1. 空值检查
2.  Elvis 运算符
3. 转化为非空值 (可能出现异常)
4. 默认值
5. 集合变形

（我这么写并不意味着这就是所有的策略；不同情况可能有其它选择）

一般要根据代码的上下文来判断哪种方法最适合。在我们的例子中， `groupingBy().eachCount()` 肯定最好。它简洁，有效，不难理解，而且完全避免了空值检查。

---

**感谢 [Jake Wharton ](https://twitter.com/JakeWharton)对这篇文章的帮助**
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
