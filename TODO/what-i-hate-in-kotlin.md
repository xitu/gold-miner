> * 原文地址：[What do I hate in Kotlin](http://marcinmoskala.com/kotlin/2017/05/31/what-i-hate-in-kotlin.html)
> * 原文作者：[Moskala Marcin](http://marcinmoskala.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Zhiw](https://github.com/Zhiw)
> * 校对者：[stormrabbit](https://github.com/stormrabbit),[yazhi1992](https://github.com/yazhi1992)

我爱 Kotlin。这是我学习过最棒的语言，并且这两年多的时间，我很享受用它来写应用。尽管如此，就像最好的老婚姻一样，我有一大堆讨厌的东西并且我知道大多数不会改变。它们大多数也不算大问题，也不容易让人陷入困境。不过，它们一直存在，是 Kotlin 美中不足之处。

# Java 的流毒

在 Kotlin 中，你不能定义这两个函数：

```
fun foo(strings: List<String>) {}
fun foo(ints: List<Int>) {}
```

这是因为他们两个都有相同的 JVM 签名。这不是 Kotlin 的问题，而是将他们编译成 Java 字节码的结果。这只是 Java 的流毒影响 Kotlin 执行的一种方式。但是这里还有更大的问题。例如，[拓展是静态解析](https://kotlinlang.org/docs/reference/extensions.html#extensions-are-resolved-statically)。这是一个大问题，我希望写一整篇文章来单独讨论这个问题。现在，它仅仅是个问题而且不直观。事实上，它就是这样设计的，因为这样拓展函数被简单地编译为一个接受第一个参数的静态函数。现在需要在 Kotlin/JavaScript 和 Kotlin/Native 中以相同的方式实现。可以，这很 Java。

# 减号运算符问题和其他不明确的操作结果

让我们来看一下这个操作：

```
println(listOf(2,2,2) - 2) // [2, 2]
```

结果是很直观的，我们从 list 中移除了该元素，因此我们得到一个没有该元素的 list。现在让我们来看一下这个表达式：

```
println(listOf(2,2,2) - listOf(2))
```

结果是什么？空的 list！非常不直观，并且我 [一年前报告了该问题](https://youtrack.jetbrains.com/issue/KT-11453)。但是得到的回复是“它就是这么设计的”。是的，函数说明如下：

```
/*
// 去除给定的集合中所包含的元素后，返回原集合。
*/
```

但是这并没有提高程序的可读性。这还只是不直观的一个例子。让我们来看一些更不直观的结果：

```
"1".toInt() // 1 - parsed to number
'1'.toInt() // 49 - its ASCII code
```

这是正确的，但同时奇怪的是，请注意以下表达式的结果是 true。

```
"1".toInt() != '1'.toInt()
"1".toInt() != "1"[0].toInt()
```

虽然 `String` 中任何非数字的字符都会导致 `NumberFormatException`，但对于返回 null 的 String 也有 `toIntOrNull` 函数。我认为这个函数首先应该命名为另外一种方式更好，或许是 `parseInt`?

 
让我们看一下另外一件事情，但这个更为复杂：（感谢 [Maciej Górski](https://github.com/mg6maciej) 的展示）。

```
1.inc() // 2
1.dec() // 0
-1.inc() // -2
-1.dec() // 0
```

后面两个结果很奇怪，难道不是吗？原因是 `-` 不是数字的一部分，而是 Int 的一元拓展函数。这就是为什么后面两行和下面的是相同的：

```
1.inc().unaryMinus()
1.dec().unaryMinus()
```

这也是这么设计的，并且这也不会改变。另外一些人会讨论这该如何如何。让我们假设在 Int 后面加了空格：

```
- 1.inc() // -2
- 1.dec() // 0
```

现在这看起来就合理了。这应该怎么使用呢？数字应该和 `-` 一起在括号里面。

```
(-1).inc() // 0
(-1).dec() // -2
```

从理性的角度来看，这没问题，但是我认为每个人都会觉得 `-2` 应该是一个数字，而不是 `2.unaryMinus()`。

# 孤立主义

Kotlin 有很多适用于任何对象的拓展（比如 let, apply, run, also, to, takeIf, …），我看到很多具有创造力的用法。在 Kotlin 中，你可以将以下定义：

```
val list = if(student != null) {
    getListForStudent(student)
} else {
    getStandardList()
}
```

替换为:

```
val list = student?.let { getListForStudent(student) } ?: getStandardList()
```

这样代码更少而且看起来更棒。另外，当添加其他条件时，我们依然可以使用：

```
val list = student?.takeIf { it.passing }?.let { getListForStudent(student) } ?: getStandardList()
```

但是这个真的比以前简单的 if 条件更好吗？

```
val list = if(student != null && student.passing) {
    getListForStudent(student)
} else {
    getStandardList()
}
```

我不置可否，但事实上，这种刻意使用 Kotlin 拓展实现的代码，对于没有使用过 Kotlin 的开发者来说是非常晦涩和抽象的。这种特性让 Kotlin 对于初学者来说变得很困难。Kotlin 的协程变化很大，这是一个很棒的特性。当我开始学习它的时候，我一整天都在重复“不可思议”和“哇”。Kotlin 协程（Coroutines）让多线程操作变得如此简单，非常棒。我觉得编程一开始就应该这么设计。不过，搞清楚 Kotlin 协程依然是一件很复杂的事情，并且它与其它技术的实现方式相去甚远。如果社区开始广泛使用协程，这又会是其它语言的开发者入门的另一个障碍。这就导致了孤立。并且我觉得这太早了。现在 Kotlin 在 Android 和 Web 方面变得越来越受欢迎，而且它刚刚开始在 JavaScript 和 native 中使用。我认为这种多样化对 Kotlin 来说愈发重要，并且 Kotlin 的具体功能介绍应该稍后开始。现在，Kotlin\JavaScript 和 Kotlin\Native 依然有很多工作要做。

# 元组 VS 单一抽象方法

[Kotlin 放弃了元组](https://blog.jetbrains.com/kotlin/migrating-tuples/)，并且只留下 `Pair` 和 `Triple`。因为应该使用数据类（date class）代替元组。这有什么不同呢？数据类包含其命名，以及其所有的属性的命名。除此之外，它可以像元组一样使用：

```
data class Student(
        val name: String,
        val surname: String,
        val passing: Boolean,
        val grade: Double
)

val (name, surname, passing, grade) = getSomeStudent()
```

同时，Kotlin 通过生成包含 lambda 方法而不是 Java 单一抽象方法（SAM:Simple Abstract Method）的 lambda 构造函数和方法来添加对 Java 单一抽象方法的支持：

```
view.setOnClickListener { toast("Foo") }
```

但是在 Kotlin 中定义的单一抽象方法不起作用，因为它建议使用函数类型。单一抽象方法和函数类型有什么不同呢？单一抽象方法包含名称，并且其所有参数的命名。从 Kotlin 1.1 开始，函数类型可以通过 typealias（类型别名）实现：


```
typealias OnClick = (view: View)->Unit
```

但我仍然觉得这缺乏对称性。如果强烈建议使用数据类，并禁止元组，那么为什么建议使用函数类型而不是单一抽象方法，并且 Kotlin 不支持单一抽象方法。可能的答案是元组会在现实生活的项目产生更多的问题。JetBrains 有很多关于语言用法的数据，他们知道如何分析它。他们非常了解 lambda 语言特性如何影响开发，并且我猜他们知道他们在做什么。我只是基于我的直觉，如果程序员可以决定是否要使用元组或数据类，那将会更好。而且这样显得不孤立，因为大多数现代语言都引入了元组。

# 总结

事实上，这只是一些小事情。与 JavaScript，PHP 或 Ruby 中存在的问题相比根本不算什么。Kotlin 从一开始就精心设计，是很多问题的解决方案。只有一些小东西不够好。
至少这几年，Kotlin 仍然是，也将是，我最喜欢的语言。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
