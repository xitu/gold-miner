> * 原文地址：[Gang of Four Patterns in Kotlin](https://dev.to/lovis/gang-of-four-patterns-in-kotlin)
> * 原文作者：[Lovis](https://dev.to/lovis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

Kotlin is getting more and more relevant. How would common design patterns implemented in Kotlin look like?

Inspired by Mario Fusco's [Talk](https://www.youtube.com/watch?v=Rmer37g9AZM)/[Blog posts](https://www.voxxed.com/blog/2016/04/gang-four-patterns-functional-light-part-1/)/[Repository](https://github.com/mariofusco/from-gof-to-lambda) "From GoF to lambda", I decided to implement some of the most famous design patterns in computer science in Kotlin!

The goal is not to simply *implement* the patterns, though. Since Kotlin supports object oriented programming and is interoperable with Java, I could just copy-auto-convert every java class in Mario's repository (doesn't matter whether it's the "traditional" or the "lambda" examples) and **it would still work!**

It's also important to note that these patterns where discovered to overcome the shortcomings of how imperative programming languages were designed in the 90s (C++ in particular). Many modern languages provide features to overcome these issues without writing extra code or falling back to patterns.

That's why —just like Mario in the `g ∘ f` repository— I will try to find a simpler, easier or more idiomatic way to solve the same problem each pattern is solving.

If you don't like reading explanations, you can directly jump to my [github repository](https://github.com/lmller/gof-in-kotlin)

---

As you might know, there are three types of (gof) patterns: **structural**, **creational** and **behavioral** patterns.

First up are the structural patterns. This is tough, because structural patterns are about - structure! How could I implement a structure with a *different* structure? I can't. An exception is the **Decorator**. While it's technically just about structure, its usage is more about behavior or responsibilities.

### Structural Patterns

#### Decorator

> Attach additional responsibilities to an object dynamically

Let's say I want to decorate a class `Text` with some text effects:

```
class Text(val text: String) {
    fun draw() = print(text)
}
```

If you know the pattern, you also know that a set of classes has to be created in order to "decorate" (that is extending the behavior) the `Text` class.

These extra classes can be avoided in Kotlin by using *extension functions*:

```
fun Text.underline(decorated: Text.() -> Unit) {
    print("_")
    this.decorated()
    print("_")
}

fun Text.background(decorated: Text.() -> Unit) {
    print("\u001B[43m")
    this.decorated()
    print("\u001B[0m")
}
```

With these extension functions, I can now create a new `Text` and decorate its `draw` method without creating other classes:

```
Text("Hello").run {
    background {
        underline {
            draw()
        }
    }
}
```

If you run this from the command line, you will see the text "_Hello_" with colored background (if your terminal supports ansi colors).

Compared to the original Decorator pattern, there is one drawback: I can not pass "pre-decorated" objects around, since there is no Decorator class anymore.

To solve this I can use functions again. Functions are first-class citizens in Kotlin, so I can pass those around instead.

```
fun preDecorated(decorated: Text.() -> Unit): Text.() -> Unit {
    return { background { underline { decorated() } } }
}
```

### Creational

#### Builder

> Separate the construction of a complex object from its representation so that the same construction process can create different representations

The **Builder** pattern is really useful. I can avoid variable-heavy constructors and easily re-use predefined setups. Kotlin supports this pattern out of the box with the `apply` extension function.

Consider a class `Car`:

```
class Car() {
    var color: String = "red"
    var doors = 3
}
```

Instead of creating a separate `CarBuilder` for this class, I can now use the `apply` (`also` works as well) extension to initialize the car:

```
Car().apply {
    color = "yellow"
    doors = 5
}
```

Since functions can be stored in a variable, this initialization could also be stored in a variable. This way, I can have pre-configured **Builder**-functions, e.g. `val yellowCar: Car.() -> Unit = { color = "yellow" }`

#### Prototype

> Specify the kinds of objects to create using a prototypical instance, and create new objects by copying this prototype

In Java, prototyping could theoretically be implemented using the `Cloneable` interface and `Object.clone()`. However, [`clone` is broken](http://www.artima.com/intv/bloch13.html), so we should avoid it.

Kotlin fixes this with data classes.

When I use data classes, I get `equals`, `hashCode`, `toString` and `copy` for free. By using `copy`, it's possible to clone the whole object and optionally change some of the new object's properties.

```
data class EMail(var recipient: String, var subject: String?, var message: String?)
...

val mail = EMail("abc@example.com", "Hello", "Don't know what to write.")

val copy = mail.copy(recipient = "other@example.com")

println("Email1 goes to " + mail.recipient + " with subject " + mail.subject)
println("Email2 goes to " + copy.recipient + " with subject " + copy.subject)
```

#### Singleton

> Ensure a class only has one instance, and provide a global point of access to it

Although the **Singleton** is considered an anti-pattern these days, it has its usages (I won't discuss this topic here, just use it with caution).

Creating a **Singleton** in Java needs a lot of ceremony, but Kotlin makes it easy with *`object` declarations*.

```
object Dictionary {
    fun addDefinition(word: String, definition: String) {
        definitions.put(word.toLowerCase(), definition)
    }

    fun getDefinition(word: String): String {
        return definitions[word.toLowerCase()] ?: ""
    }
}
```

Using the `object` keyword here will automatically create a class `Dictionary` and a single instance of it. The instance is created lazily, so it's not created until it is actually used.

The object is accessed like static functions in java:

```
val word = "kotlin"
Dictionary.addDefinition(word, "an awesome programming language created by JetBrains")
println(word + " is " + Dictionary.getDefinition(word))
```

### Behavioral

#### Template Method

> Define the skeleton of an algorithm in an operation, deferring some steps to subclasses

This pattern makes use of class hierarchies as well. You define an `abstract` method and call it somewhere inside the base class. The implementation is handled by the subclasses.

```
//java
public abstract class Task {
        protected abstract void work();
        public void execute(){
            beforeWork();
            work();
            afterWork();
        }
    }
```

I could now derive a concrete `Task`, that actually does something in `work`.

Similar to how the **Decorator** example uses extension functions, my **Template Method** approach uses a top-level function.

```
//kotlin
fun execute(task: () -> Unit) {
    val startTime = System.currentTimeMillis() //"beforeWork()"
    task()
    println("Work took ${System.currentTimeMillis() - startTime} millis") //"afterWork()"
}

...
//usage:
execute {
    println("I'm working here!")
}
```

As you can see, there is no need to have a class at all! One could argue, that this now resembles the **Strategy** pattern, which is probably correct. But then again, **Strategy** and **Template Method** are solving very similar problems (if not the same).

#### Strategy

> Define a family of algorithms, encapsulate each one, and make them interchangeable

Let's say I have a `Customer` that pays a certain fee per month. This fee can be discounted. Instead of having a subclass of `Customer` for each discounting-*strategy*, I use the **Strategy** pattern.

```
class Customer(val name: String, val fee: Double, val discount: (Double) -> Double) {
    fun pricePerMonth(): Double {
        return discount(fee)
    }
}
```

Notice that I'm using a function `(Double) -> Double` instead of an interface for the strategy. To make this more domain-specific, I could also declare a type alias, without losing the flexibility of an higher-order-function: `typealias Discount = (Double) -> Double`.

Either way, I can define multiple strategies for calculating the discount.

```
val studentDiscount = { fee: Double -> fee/2 }
val noDiscount = { fee: Double -> fee }
...

val student = Customer("Ned", 10.0, studentDiscount)
val regular = Customer("John", 10.0, noDiscount)

println("${student.name} pays %.2f per month".format(student.pricePerMonth()))
println("${regular.name} pays %.2f per month".format(regular.pricePerMonth()))
```

#### Iterator

> Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.

Writing an **Iterator** is a rare task. Most of the time, it's easier and more convenient to wrap a `List` and implement the `Iterable` interface.

In Kotlin, `iterator()` is an operator function. This means that when a class defines a function `operator fun iterator()`, it can be iterated using a `for` loop (no interface needed). That's particularly cool because it works also with extension functions. That's right - by using an extension function, I can make *every* object iterable. Consider this example:

```
class Sentence(val words: List<String>)
...
operator fun Sentence.iterator(): Iterator<String> = words.iterator()
```

I can now iterate over a `Sentence`. This also works if I'm not the owner of the class.

### More patterns

I mentioned a few patterns, but those are not all *Gang of Four* patterns. As I said in the introduction, especially the structural patterns are hard or impossible to write in a different way than in Java. [Some other patterns can be found in the repository](https://github.com/lmller/gof-in-kotlin). I'm open for feedback and pull-requests ☺.

I hope this post gave you an idea on how Kotlin can result in different approaches to well known problems.

One last thing I want to mention is, that the java-to-kotlin ratio in the repository is ~⅓ Kotlin and ~⅔ Java, although both versions do the same thing 🙃

---

The cover image was taken from [stocksnap.io](stocksnap.io)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
