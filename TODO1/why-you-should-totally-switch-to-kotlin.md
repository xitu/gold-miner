> * 原文地址：[Why you should totally switch to Kotlin](https://medium.com/@magnus.chatt/why-you-should-totally-switch-to-kotlin-c7bbde9e10d5)
> * 原文作者：[Magnus Vinther](https://medium.com/@magnus.chatt?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-totally-switch-to-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-totally-switch-to-kotlin.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[Starrier](https://github.com/Starriers)、[Sergey Cheung](https://github.com/SergeyChang)

# 为什么你应该开始使用 Kotlin

## 是时候开始用现代编程语言了

![](https://cdn-images-1.medium.com/max/2000/1*59fOg88eGylkhsOLZAqM-w.jpeg)

我想要告诉你一种**新的编程语言**，叫做 **Kotlin**，以及为什么你应该考虑在下一个项目中使用它。在过去的时候，我更喜欢 Java，但是去年我发现自己无论何时都可以用 Kotlin 编写代码。此时，我真的想不出哪种情况下 Java 会是更好的选择。

它是由 [**JetBrains**](https://www.jetbrains.com/) 公司开发的, 而这些人是 **IntelliJ** 和 **ReSharper** 等 [IDEs](https://www.jetbrains.com/products.html?fromMenu#type=ide) 系列产品的幕后人物，Kotlin 确实很受欢迎。它的**实用性**和**简洁性**，让编码成为一种令人满意且高效的体验。

虽然 Kotlin 能编译为 [**JavaScript**](https://kotlinlang.org/docs/tutorials/javascript/kotlin-to-javascript/kotlin-to-javascript.html) 并很快编译成[**机器代码**](https://blog.jetbrains.com/kotlin/2017/04/kotlinnative-tech-preview-kotlin-without-a-vm/)，但是我将重点介绍它的主要环境，**JVM**。

因此，这里有一些原因可以解释为什么你应开始使用 Kotlin 语言（排名不分先后）：

#### 0# [Java 互操作性](https://kotlinlang.org/docs/reference/java-interop.html)

Kotlin 与 **Java 是 100% 可互操作的**。你可以使用 Kotlin 继续你之前的 Java 项目。所有你喜欢的 **Java 框架仍然可以用**，你用 Kotlin 编写的任何框架都都可以被你偏爱 Java 的朋友所使用。 

#### **1#** [**熟悉的语法**](https://kotlinlang.org/docs/reference/basic-syntax.html)

Kotlin 并不是诞生于学术界中的一种奇怪的语言。它的语法对于任何来自 [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming) 领域的程序员来说都不陌生，并且从一开始就能或多或少地理解。当然，Java也有**一些**不同之处，比如重写构造函数或者是 `val` 、 `var` 变量的声明。下面的代码介绍了大部分基础知识：

```
class Foo {

    val b: String = "b"     // 用 val 声明的变量值意味着不可修改
    var i: Int = 0          // 用 var 声明的变量值则可修改

    fun hello() {
        val str = "Hello"
        print("$str World")
    }

    fun sum(x: Int, y: Int): Int {
        return x + y
    }

    fun maxOf(a: Float, b: Float) = if (a > b) a else b

}
```

#### **2#** [**字符串插值**](https://kotlinlang.org/docs/reference/basic-types.html#string-templates)

这就像 Java 的 `String.format()` 的一个更智能、可读性更好的版本被构建到了语言中：

```
val x = 4
val y = 7
print("sum of $x and $y is ${x + y}")  // sum of 4 and 7 is 11
```

#### 3# [类型推断](https://kotlinlang.org/docs/reference/properties.html)

Kotlin 会在你需要的时候推断出类型，这有效地提高可读性：

```
val a = "abc"                         // 推断为 String 类型
val b = 4                             // 推断为 Int 类型

val c: Double = 0.7                   // 显式声明类型
val d: List<String> = ArrayList()     // 显式声明类型
```

#### 4# [智能转换](https://kotlinlang.org/docs/reference/typecasts.html)

如果可能的话，Kotlin 的编译器会跟踪你的逻辑并且**自动转换类型**，这意味少了许多的 `instanceof` 检查和显式转换：

```
if (obj is String) {
    print(obj.toUpperCase())     // obj 现在被认为是 String 类型。
}
```

#### 5# [Intuitive Equals](https://kotlinlang.org/docs/reference/equality.html)

你可以不再显示调用 `equals()` 方法，因为 `==` 操作符现在会检查表达式结构是否相同:

```
val john1 = Person("John")
val john2 = Person("John")

john1 == john2    // true （结构相同)
john1 === john2   // false （引用相等）
```

#### 6# [默认参数](https://kotlinlang.org/docs/reference/functions.html#default-arguments)

没有必要用不同的参数定义几种类似的方法：

```
fun build(title: String, width: Int = 800, height: Int = 600) {
    Frame(title, width, height)
}
```

#### 7# [命名参数](https://kotlinlang.org/docs/reference/functions.html#named-arguments)

结合默认的参数，命名参数消除了对[builders](https://en.wikipedia.org/wiki/Builder_pattern)的需求：

```
build("PacMan", 400, 300)                           // 等效
build(title = "PacMan", width = 400, height = 300)  // 等效
build(width = 400, height = 300, title = "PacMan")  // 等效
```

#### 8# [When 表达式](https://kotlinlang.org/docs/reference/control-flow.html#when-expression)

用可读性和灵活性更好的 when 表达式来取代 switch case 表达式：

```
when (x) {
    1 -> print("x is 1")
    2 -> print("x is 2")
    3, 4 -> print("x is 3 or 4")
    in 5..10 -> print("x is 5, 6, 7, 8, 9, or 10")
    else -> print("x is out of range")
}
```

它既可以在表达式或语句，也可以带参数或者无参使用：

```
val res: Boolean = when {
    obj == null -> false
    obj is String -> true
    else -> throw IllegalStateException()
}
```

#### **9#** [**属性**](https://kotlinlang.org/docs/reference/properties.html#getters-and-setters)

自定义 setter 和 getter 方法会被添加到 public 作用域中，这意味着我们可以避免无意之间使用 [get 和 set 行为]使得代码变得臃肿。 

```
class Frame {
    var width: Int = 800
    var height: Int = 600

    val pixels: Int
        get() = width * height
}
```

#### **10#** [**数据类**](https://kotlinlang.org/docs/reference/data-classes.html)

它是一个带有 `toString()`、`equals()`、`hashCode()` 和 `copy()` 方法的 POJO，与 Java 不同，它不会占用 100 行代码：

```
data class Person(val name: String,
                  var email: String,
                  var age: Int)

val john = Person("John", "john@gmail.com", 112)
```

#### 11# [运算符重载](https://kotlinlang.org/docs/reference/operator-overloading.html)

预定义的操作符集可以被重载以提高可读性：

```
data class Vec(val x: Float, val y: Float) {
    operator fun plus(v: Vec) = Vec(x + v.x, y + v.y)
}

val v = Vec(2f, 3f) + Vec(4f, 1f)
```

#### 12# [解构声明](https://kotlinlang.org/docs/reference/multi-declarations.html)

有些对象是可以被解构的，但这对于迭代 maps 是很有用的：

```
for ((key, value) in map) {
    print("Key: $key")
    print("Value: $value")
}
```

#### 13# [范围](https://kotlinlang.org/docs/reference/ranges.html)

为了可读性：

```
for (i in 1..100) { ... } 
for (i in 0 until 100) { ... }
for (i in 2..10 step 2) { ... } 
for (i in 10 downTo 1) { ... } 
if (x in 1..10) { ... }
```

#### **14#** [**扩展函数**](https://kotlinlang.org/docs/reference/extensions.html)

还记得你第一次在 Java 中对 `List` 进行排序吗？你找不到一个 `sort()` 函数，所以你必须去问你的导师或者在谷歌上学习使用 `Collections.sort()`。 后来当你必须要用 `String` 字符串的时候，你自己编写了一个辅助函数，因为你不知道可以用 `StringUtils.capitalize()`。

如果仅有一种方法可以将新的函数添加到旧的类中，那就是你的 IDE 代码补全的功能以帮助你在找到正确的函数。在 Kotlin，你完全可以这样做：

```
fun String.replaceSpaces(): String {
    return this.replace(' ', '_')
}

val formatted = str.replaceSpaces()
```

标准库扩展了 Java 的原有类型，`String` 尤其需要：

```
str.removeSuffix(".txt")
str.capitalize()
str.substringAfterLast("/")
str.replaceAfter(":", "classified")
```

#### **15#** [**Null 安全性**](https://kotlinlang.org/docs/reference/null-safety.html)

我们应该称 Java 为一种**几乎**静态类型的语言。其中，`String` 类型的变量不**保证**指向的类型就是 `String` —— 它可能指向了 `null`。尽管我们已经习惯了这一点，但它却否定了静态类型检查的安全性。其结果是 Java 开发者不得不长期生活在对[空指针异常](http://stackoverflow.com/questions/218384/what-is-a-nullpointerexception-and-how-do-i-fix-it) 的恐惧中。 

通过区分**非空类型**和**可空类型**，Kotlin 解决了这个问题。在默认的情况下，类型是非空的，可以像这样通过添加 `?` 使变量为空：

```
var a: String = "abc"
a = null                // 编译失败

var b: String? = "xyz"
b = null                // 编译成功
```

无论何时你访问一个非空类型的变量时，Kotlin 会强制你去防止空指针异常的情况发生：

```
val x = b.length        // 编译错误：变量 b 可能为空
```

虽然这看起来很麻烦，但是多亏了它的一些特性，这变得轻而易举。我们仍然可以智能转换，在任何可能的情况下，将可空类型的变量转换为非空类型：

```
if (b == null) return
val x = b.length        // 没有问题
```

我们也可以使用一个安全的 `?.` 字符来估算一下变量是否为空，而不是抛出一个空指针的异常：

```
val x = b?.length       // 变量 x 的类型是可空的 Int 类型
```

安全调用也可以连着一起调用，以避免我们有时用其他语言编写的嵌套的 if-not-null 检查。如果我们想要一个除了 `null` 之外的默认值，我们可以用 elvis 运算符 `?:`：

```
val name = ship?.captain?.name ?: "unknown"
```

如果这些对你来说不管用，而你又需要一个空指针异常，那么你必须显示声明：

```
val x = b?.length ?: throw NullPointerException()  // 下同
val x = b!!.length                                 // 上同
```

#### **16#** [**更好的 Lambdas**](https://kotlinlang.org/docs/reference/lambdas.html)

噢，兄弟，这是一个良好的 lambada 系统 —— 多亏了一些聪明的设计选择，让它在可读性和简洁性之间完美的平衡。语法首先是直截了当的：

```
val sum = { x: Int, y: Int -> x + y }   // type: (Int, Int) -> Int
val res = sum(4,7)                      // res == 11
```

接下来是精彩的部分：

1.  如果 lambda 是方法的最后或唯一的参数，则可以移动或省略括号。
2.  如果我们不声明单参数 lamda 的参数，它将隐式声明为 `it`.

这些实例放在一起，让以下三行代码作用相同：

```
numbers.filter({ x -> x.isPrime() })
numbers.filter { x -> x.isPrime() }
numbers.filter { it.isPrime() }
```

这让我们能够写出简洁的函数代码 —— 看看它的美：

```
persons
    .filter { it.age >= 18 }
    .sortedBy { it.name }
    .map { it.email }
    .forEach { print(it) }
```

Kotlin 的 lambda 系统结合扩展函数，使其成为 [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) 创建的理想选择。看看 [Anko](https://github.com/Kotlin/anko) 的一个 DSL 实例，它旨在提高 Android 开发：

```
verticalLayout {
    padding = dip(30)
    editText {
        hint = “Name”
        textSize = 24f
    }
    editText {
        hint = “Password”
        textSize = 24f
    }
    button(“Login”) {
        textSize = 26f
    }
}
```

#### 17# [IDE 支持](https://kotlinlang.org/docs/tutorials/getting-started.html)

如果你打算开始使用 Kotlin，你有很多可以选择的环境，但是我强烈推荐使用与 **Kotlin 捆绑在一起**的 **IntelliJ**，因为它的功能证明了让相同的人同时设计语言和 IDE 的优点。

给你一个虽小但聪明的例子，当我第一次尝试从 Stack Overflow 复制一些 Java 代码时，这个窗口就自动弹出来了：

![](https://cdn-images-1.medium.com/max/800/1*zpE0UpuBDGW7Mk-Vtx2uKw.png)

如果你将 Java 代码粘贴到 Kotlin 的文件中，IntelliJ 是会注意到的。

* * *

现在就这些了。谢谢你的阅读！这是我第一次在 Medium 上发帖。如果你还不能相信 Kotlin，这里有一些更有说服力的文章：

*   [**Kotlin on Android. Now official**](https://blog.jetbrains.com/kotlin/2017/05/kotlin-on-android-now-official/)
*   [**Why Kotlin is my next programming language**](https://medium.com/@octskyward/why-kotlin-is-my-next-programming-language-c25c001e26e3)
*   [**Scala vs Kotlin**](https://agilewombat.com/2016/02/01/scala-vs-kotlin/)
*   [**Swift is like Kotlin**](http://nilhcem.com/swift-is-like-kotlin/)
*   [**The Road to Gradle Script Kotlin 1.0**](https://blog.gradle.org/kotlin-scripting-update)
*   [**Introducing Kotlin support in Spring Framework 5.0**](https://spring.io/blog/2017/01/04/introducing-kotlin-support-in-spring-framework-5-0?utm_content=buffer546ec&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer)
*   [**10 cool things about Kotlin**](http://frozenfractal.com/blog/2017/2/10/10-cool-things-about-kotlin/)
*   [**Kotlin full stack application example**](https://github.com/Kotlin/kotlin-fullstack-sample)
*   [**Why I abandoned Java in favour of Kotlin**](https://hashnode.com/post/why-i-abandoned-java-in-favour-of-kotlin-ciuzhmecf09khdc530m1ghu6d)
*   [**I used Kotlin at Hackathon**](https://medium.com/@johnnytn.mail/i-used-kotlin-at-a-hackathon-cd9eab1725f9)
*   [**From Java to Kotlin**](https://fabiomsr.github.io/from-java-to-kotlin/)
*   [**Kotlin Idioms**](https://kotlinlang.org/docs/reference/idioms.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
