> * 原文地址：[What do I hate in Kotlin](http://marcinmoskala.com/kotlin/2017/05/31/what-i-hate-in-kotlin.html)
> * 原文作者：[Moskala Marcin](http://marcinmoskala.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

I love Kotlin. It is the best language I ever learned, and I really enjoy writing applications in it since over 2 years.
After all, like in even the best old marriage, I have a bunch of stuff that I hate and I know that most of them won’t change.
Most of them are not a big problems and they are it is hard to fall into them.
Still, they are there, and they are Kotlins fly in the ointment.

# The legacy of Java

In Kotlin you cannot define this two functions:

```
fun foo(strings: List<String>) {}
fun foo(ints: List<Int>) {}
```

It is because both of them have the same JVM signature. This is not a Kotlin problem, but result of how they are compiled to Java bytecode.
It is just one way how Java legacy is influencing Kotlin execution. But there are bigger problems. For example, that [extensions are resolved statically](https://kotlinlang.org/docs/reference/extensions.html#extensions-are-resolved-statically). This is a big problem, and I hope to write whole article just about it. For now - it is just problematic and unintuitive.
Thing is, that it was designed this way, because then extension functions are simply compiled to static functions with receiver on first
parameter. Now it needs to be implemented the same way in Kotlin\JavaScipt and Kotlin\Native. Just great.

# Minus operator problems and other unintuitive operation results

Let’s look at this operation:

```
println(listOf(2,2,2) - 2) // [2, 2]
```

Result is intuitive- we are removing element from list so we get list without it. Now let’s look at this operation:

```
println(listOf(2,2,2) - listOf(2))
```

What is the result? Empty list! Pretty unintuitive, and I [report it over a year ago](https://youtrack.jetbrains.com/issue/KT-11453).
But the answer was “As Designed”. It is true, while function description is following:

```
/*
// Returns a list containing all elements of the original collection except the elements contained in the given [elements] collection.
*/
```

But it doesn’t make it’s behavior better. This is one example of implementation that is unintuitive. Let’s look at some more unintuitive results:

```
"1".toInt() // 1 - parsed to number
'1'.toInt() // 49 - its ASCII code
```


It is correct, but wired in the same time. Note that predicates are true:

```
"1".toInt() != '1'.toInt()
"1".toInt() != "1"[0].toInt()
```


While any non-numeric character in `String` will cause `NumberFormatException`, there is also `toIntOrNull` function for String that is returning null instead.
I think that it is good enough argument that this function should be named in different way in the first place. Maybe `parseInt`?

Let’s go to another thing, but this one is more complex to understand: (thanks to [Maciej Górski](https://github.com/mg6maciej) for showing it to me)

```
1.inc() // 2
1.dec() // 0
-1.inc() // -2
-1.dec() // 0
```

Two last results are strange, aren’t they? The reason is that minus is not a part of the number, but unary extension function
to Int. This is why this two last lines are the same as:

```
1.inc().unaryMinus()
1.dec().unaryMinus()
```

This is also as designed, and it wont change. Also, some will argue that it is how is how is should act. Let’s suppose that we made space behind Int:

```
- 1.inc() // -2
- 1.dec() // 0
```

Now it looks rational. How it should be used? Number should be in bracket together with minus.

```
(-1).inc() // 0
(-1).dec() // -2
```

From rational point of view it is ok, but I think that everyone feels that `-2` should be a number, not `2.unaryMinus()`.

# Isolationism

There are multiple Kotlin extensions to any object (like let, apply, run, also, to, takeIf, …), and I see lot’s of
creativity in their usage. In Kotlin, you can replace this definition:

```
val list = if(student != null) {
    getListForStudent(student)
} else {
    getStandardList()
}
```

With this:

```
val list = student?.let { getListForStudent(student) } ?: getStandardList()
```

Ok, is is shorter and looks good. Also, when there are some other conditions added then we can still use it:

```
val list = student?.takeIf { it.passing }?.let { getListForStudent(student) } ?: getStandardList()
```

But it is really better then simple, old if condition?

```
val list = if(student != null && student.passing) {
    getListForStudent(student)
} else {
    getStandardList()
}
```

I do not judge, but the fact is that implementation that is strongly using all Kotlin extensions are hard and unintuitive for people
who are not Kotlin developers. This kind of features are making Kotlin harder and harder for beginners. The big change comes with
Kotlin Coroutines. It is great feature. When I started learning it, then through whole day I was repeating “incretable” and “wow”.
It is awesome how Kotlin Coroutines are making multithreading so simple. I feel that this should be designed this way from the beginning of programming.
Still, it is complex to understand Kotlin Coroutines, and it is far away from how it is implemented in other technologies.
If community will start strongly using Coroutines, then it will be another barrier for programmers from other languages to jump in. This
leads to isolationism. And I feel that it is too early for that. Right now Kotlin is becoming more and more popular in Android and Web, and it just
started to be used in JavaScript and native. I think that this diversification is now much more important, and introduction
of Kotlin specific features should start later. Right now, there is still a lot of work to od in Kotlin\JavaScript and Kotlin\Native.

# Tuples vs SAM

[Kotlin resigned from tuples](https://blog.jetbrains.com/kotlin/migrating-tuples/) and left just `Pair` and `Triple`.
The reason was that there should be data classes used instead.
What is the difference? Data class contains name, and all its properties are named too. Except that, it can be used like tuple:

```
data class Student(
        val name: String,
        val surname: String,
        val passing: Boolean,
        val grade: Double
)

val (name, surname, passing, grade) = getSomeStudent()
```

It the same time, Kotlin added support to Java SAM (Simple Abstract Method) by generation of lambda constructor and methods
that are containing lambda methods instead of Java SAM:

```
view.setOnClickListener { toast("Foo") }
```

But it is not working for SAM defined in Kotlin, because it is suggested to use functional types instead. What is the difference
between SAM and functional type? SAM contains name, and all its parameters are named too. Sure, from Kotlin 1.1 named functional type
 can be implemented by typealias:

```
typealias OnClick = (view: View)->Unit
```

But I still feel that there is lack of symmetry. If it is strongly suggested to use named data classes and tuples are prohibited, then
why it is suggested to use functional types instead of SAM and Kotlin SAM are not supported? Possible answer is that tuples are making more
problems then good in real-life projects. JetBrains have a lot of data about languages usage and they know how to analyze it.
They know a lot about how lambguage features are influencing development and I guess that they know what are they doing.
I just base on feeling that, it would be better if programmer could decide if he want to use tuple or data class.
And it is not isolationism, because tuples are implemented in most modern languages.

# Summary

This are, in fact, just a small things. It is nothing comparing to what can be found in JavaScript, PHP or Ruby.
Kotlin was well designed from the beginning, and it is a solution to a lot of problems.
There are just some small stuff that didn’t go well enough.
Still it is, and it will be, my most favourite language for at least few more years.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
