> * 原文地址：[Why you should totally switch to Kotlin](https://medium.com/@magnus.chatt/why-you-should-totally-switch-to-kotlin-c7bbde9e10d5)
> * 原文作者：[Magnus Vinther](https://medium.com/@magnus.chatt?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-totally-switch-to-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-totally-switch-to-kotlin.md)
> * 译者：
> * 校对者：

# Why you should totally switch to Kotlin

## It’s time to start using a modern programming language

![](https://cdn-images-1.medium.com/max/2000/1*59fOg88eGylkhsOLZAqM-w.jpeg)

I want to tell you about a **new programming language** called **Kotlin** and why you should consider it for your next project. I used to prefer Java but the last year I’ve found myself coding Kotlin whenever I could, and at this point I really can’t think of a situation where Java would be a better choice.

It’s developed by [**JetBrains**](https://www.jetbrains.com/), and the fact that these are the people behind a suite of [IDEs](https://www.jetbrains.com/products.html?fromMenu#type=ide), such as **IntelliJ** and **ReSharper**,really shines through in Kotlin. It’s **pragmatic** and **concise**, and makes coding a satisfying and efficient experience.

Although Kotlin compiles to both [**JavaScript**](https://kotlinlang.org/docs/tutorials/javascript/kotlin-to-javascript/kotlin-to-javascript.html) and soon [**machine code**](https://blog.jetbrains.com/kotlin/2017/04/kotlinnative-tech-preview-kotlin-without-a-vm/), I’ll focus on its prime environment, the **JVM**.

So here’s a couple of reasons why you should totally switch to Kotlin (in no particular order):

#### 0# [Java Interoperability](https://kotlinlang.org/docs/reference/java-interop.html)

Kotlinis **100% interoperable with Java**. You can literally continue work on your old Java projects using Kotlin. All your favorite **Java frameworks are still available**, and whatever framework you’ll write in Kotlin is easily adopted by your stubborn Java loving friend.

#### **1#** [**Familiar Syntax**](https://kotlinlang.org/docs/reference/basic-syntax.html)

Kotlin isn’t some weird language born in academia. Its syntax is familiar to any programmer coming from the [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming) domain, and can be more or less understood from the get go. There are of course _some_ differences from Java such as the reworked constructors or the `val` `var` variable declarations. The snippet below presents most of the basics:

```
class Foo {

    val b: String = "b"     // val means unmodifiable
    var i: Int = 0          // var means modifiable

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

#### **2#** [**String Interpolation**](https://kotlinlang.org/docs/reference/basic-types.html#string-templates)

It’s as if a smarter and more readable version of Java’s `String.format()` was built into the language:

```
val x = 4
val y = 7
print("sum of $x and $y is ${x + y}")  // sum of 4 and 7 is 11
```

#### 3# [Type Inference](https://kotlinlang.org/docs/reference/properties.html)

Kotlin will infer your types wherever you feel it will improve readability:

```
val a = "abc"                         // type inferred to String
val b = 4                             // type inferred to Int

val c: Double = 0.7                   // type declared explicitly
val d: List<String> = ArrayList()     // type declared explicitly
```

#### 4# [Smart Casts](https://kotlinlang.org/docs/reference/typecasts.html)

The Kotlin compiler tracks your logic and **auto-casts types if possible**, which means no more `instanceof`checks followed by explicit casts:

```
if (obj is String) {
    print(obj.toUpperCase())     // obj is now known to be a String
}
```

#### 5# [Intuitive Equals](https://kotlinlang.org/docs/reference/equality.html)

You can stop calling `equals()` explicitly, because the `==` operator now checks for structural equality:

```
val john1 = Person("John")
val john2 = Person("John")

john1 == john2    // true  (structural equality)
john1 === john2   // false (referential equality)
```

#### 6# [Default Arguments](https://kotlinlang.org/docs/reference/functions.html#default-arguments)

No need to define several similar methods with varying arguments:

```
fun build(title: String, width: Int = 800, height: Int = 600) {
    Frame(title, width, height)
}
```

#### 7# [Named Arguments](https://kotlinlang.org/docs/reference/functions.html#named-arguments)

Combined with default arguments, named arguments eliminates the need for [builders](https://en.wikipedia.org/wiki/Builder_pattern):

```
build("PacMan", 400, 300)                           // equivalent
build(title = "PacMan", width = 400, height = 300)  // equivalent
build(width = 400, height = 300, title = "PacMan")  // equivalent
```

#### 8# [The When Expression](https://kotlinlang.org/docs/reference/control-flow.html#when-expression)

The switch case is replaced with the much more readable and flexible _when_ expression:

```
when (x) {
    1 -> print("x is 1")
    2 -> print("x is 2")
    3, 4 -> print("x is 3 or 4")
    in 5..10 -> print("x is 5, 6, 7, 8, 9, or 10")
    else -> print("x is out of range")
}
```

It works both as an expression or a statement, and with or without an argument:

```
val res: Boolean = when {
    obj == null -> false
    obj is String -> true
    else -> throw IllegalStateException()
}
```

#### **9#** [**Properties**](https://kotlinlang.org/docs/reference/properties.html#getters-and-setters)

Custom set & get behavior can be added to public fields, which means we can stop bloating our code with mindless [getters & setters](http://stackoverflow.com/questions/1568091/why-use-getters-and-setters).

```
class Frame {
    var width: Int = 800
    var height: Int = 600

    val pixels: Int
        get() = width * height
}
```

#### **10#** [**The Data Class**](https://kotlinlang.org/docs/reference/data-classes.html)

It’s a POJO complete with `toString()`, `equals()`, `hashCode()`, and `copy()`, and unlike in Java it won’t take up 100 lines of code:

```
data class Person(val name: String,
                  var email: String,
                  var age: Int)

val john = Person("John", "john@gmail.com", 112)
```

#### 11# [Operator Overloading](https://kotlinlang.org/docs/reference/operator-overloading.html)

A predefined set of operators can be overloaded to improve readability:

```
data class Vec(val x: Float, val y: Float) {
    operator fun plus(v: Vec) = Vec(x + v.x, y + v.y)
}

val v = Vec(2f, 3f) + Vec(4f, 1f)
```

#### 12# [Destructuring Declarations](https://kotlinlang.org/docs/reference/multi-declarations.html)

Some objects can be destructured, which is for example useful for iterating maps:

```
for ((key, value) in map) {
    print("Key: $key")
    print("Value: $value")
}
```

#### 13# [Ranges](https://kotlinlang.org/docs/reference/ranges.html)

For readability’s sake:

```
for (i in 1..100) { ... } 
for (i in 0 until 100) { ... }
for (i in 2..10 step 2) { ... } 
for (i in 10 downTo 1) { ... } 
if (x in 1..10) { ... }
```

#### **14#** [**Extension Functions**](https://kotlinlang.org/docs/reference/extensions.html)

Remember the first time you had to sort a `List` in Java? You couldn’t find a `sort()`function so you had to ask either your tutor or google to learn of `Collections.sort()`. And later when you had to capitalize a `String`, you ended up writing your own helper function because you didn’t know of `StringUtils.capitalize()`.

If only there was a way to add new functions to old classes; that way your IDE could help you find the right function in code-completion. In Kotlin you can do exactly that:

```
fun String.replaceSpaces(): String {
    return this.replace(' ', '_')
}

val formatted = str.replaceSpaces()
```

The standard library extends the functionality of Java’s original types, which was especially needed for `String`:

```
str.removeSuffix(".txt")
str.capitalize()
str.substringAfterLast("/")
str.replaceAfter(":", "classified")
```

#### **15#** [**Null Safety**](https://kotlinlang.org/docs/reference/null-safety.html)

Java is what we should call an _almost_ statically typed language. In it, a variable of type `String` is not _guaranteed_ to refer to a `String`— it might refer to `null`. Even though we are used to this, it negates the safety of static type checking, and as a result Java developers have to live in constant fear of [NPEs](http://stackoverflow.com/questions/218384/what-is-a-nullpointerexception-and-how-do-i-fix-it).

Kotlin resolves this by distinguishing between **non-null types** and **nullable types**. Types are non-null by default, and can be made nullable by adding a `?`like so:

```
var a: String = "abc"
a = null                // compile error

var b: String? = "xyz"
b = null                // no problem
```

Kotlin forces you to guard against NPEs whenever you access a nullable type:

```
val x = b.length        // compile error: b might be null
```

And while this might seem cumbersome, it’s really a breeze thanks to a few of its features. We still have smart casts, which casts nullable types to non-null wherever possible:

```
if (b == null) return
val x = b.length        // no problem
```

We could also use a safe call `?.`, which evaluates to null instead of throwing a NPE:

```
val x = b?.length       // type of x is nullable Int
```

Safe calls can be chained together to avoid those nested if-not-null checks we sometimes write in other languages, and if we want a default value other than `null` we can use the elvis operator `?:`:

```
val name = ship?.captain?.name ?: "unknown"
```

If none of that works for you, and you absolutely need a NPE, you will have to ask for it explicitly:

```
val x = b?.length ?: throw NullPointerException()  // same as below
val x = b!!.length                                 // same as above
```

#### **16#** [**Better Lambdas**](https://kotlinlang.org/docs/reference/lambdas.html)

Oh boy, is this a good lambda system — perfectly balanced between readability and terseness, thanks to some clever design choices. The syntax is first of all straight forward:

```
val sum = { x: Int, y: Int -> x + y }   // type: (Int, Int) -> Int
val res = sum(4,7)                      // res == 11
```

And here come the clever bits:

1.  Method parentheses can be moved or omitted if the lambda is the last or the only argument of a method.
2.  If we choose not to declare the argument of a single-argument-lambda it’ll be implicitly declared under the name `it`.

These facts combined makes the following three lines equivalent:

```
numbers.filter({ x -> x.isPrime() })
numbers.filter { x -> x.isPrime() }
numbers.filter { it.isPrime() }
```

And this allows us to write concise functional code — just look at this beauty:

```
persons
    .filter { it.age >= 18 }
    .sortedBy { it.name }
    .map { it.email }
    .forEach { print(it) }
```

Kotlin’s lambda system combined with extension functions makes it ideal for [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) creation. Check out [Anko](https://github.com/Kotlin/anko) for an example of a DSL that aims to enhance Android development:

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

#### 17# [IDE Support](https://kotlinlang.org/docs/tutorials/getting-started.html)

You have a number of options if you intend to get started with Kotlin, but I highly recommend using **IntelliJ** which **comes bundled with Kotlin**—its features demonstrate the advantage of having the same people design both language and IDE.

Just to give you a minor but clever example, this thing popped up when I first tried to copy-paste some Java code from Stack Overflow:

![](https://cdn-images-1.medium.com/max/800/1*zpE0UpuBDGW7Mk-Vtx2uKw.png)

IntelliJ will notice if you paste Java code into a Kotlin file

* * *

And that’s all for now. Thank you for reading! This is my first ever medium post. If you are not yet convinced about Kotlin here is some more convincing:

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
