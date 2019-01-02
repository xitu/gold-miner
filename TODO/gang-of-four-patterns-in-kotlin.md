> * 原文地址：[Gang of Four Patterns in Kotlin](https://dev.to/lovis/gang-of-four-patterns-in-kotlin)
> * 原文作者：[Lovis](https://dev.to/lovis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Boiler Yao](https://github.com/boileryao)
> * 校对者：[windmxf](https://github.com/windmxf), [wilsonandusa](https://github.com/wilsonandusa)

Kotlin 正在得到越来越广泛的应用。如果把常用的设计模式用 Kotlin 来实现会是什么样子呢？

受到 Mario Fusco 的“从‘四人帮’到 lambda”（相关的[视频](https://www.youtube.com/watch?v=Rmer37g9AZM)、[博客](https://www.voxxed.com/blog/2016/04/gang-four-patterns-functional-light-part-1/)、[代码](https://github.com/mariofusco/from-gof-to-lambda)）的启发，我决定动手实现一些计算机科学领域最著名的设计模式，用 “Kotlin”！（“四人帮”指 Erich Gamma、Richard Helm、Ralph Johnson 和 John Vlissides，四人在所著的《Design Patterns: Elements of Reusable Object-Oriented Software 》一书中介绍了 23 种设计模式，该书被誉为设计模式的经典之作。——译注）

当然，我的目标不是简单的 **实现** 这些模式。因为 Kotlin 支持面向对象编程并且和 Java 是可互操作的，我可以从 Mario 的仓库直接复制粘贴每一个 Java 文件（先不管是“传统”的还是“lambda 风格”的），**它们将仍然可以正常工作**！

需要特别说明一下，这些模式的发明是为了弥补起源于上世纪九十年代的一些命令式编程语言（尤其是 C++）的不足。很多现代编程语言提供了解决这些不足的特性，我们完全不需要再写多余的代码或者做刻意模仿设计模式这种事了。

这就是为什么我像 Mario （相关仓库地址：[gof](https://github.com/mariofusco/from-gof-to-lambda)）那样，去寻找一种更简单方便、更惯用的方式来解决这些模式所要解决的问题。

如果不想看下面这坨说明文字的话，你可以直接去 [这个 GitHub 仓库](https://github.com/lmller/gof-in-kotlin) 看代码。

---

众所周知，根据“四人帮”的定义设计模式可以分为三种: **结构型**、**创建型** 和 **行为型**。

 一开始，我们先来看结构型设计模式。这不是很好搞，因为结构型设计模式是关于结构的。怎样用一个 **不同** 的结构来实现这个结构呢，臣妾做不到啊。不过， **装饰器模式** 是个例外。虽然在技术层面来说算是结构型，但就使用来说，更多是和行为及职责有关的（装饰器模式，每个负责进行包装的类具有增加某一行为这一职责。——译注）。

### 结构型设计模式

#### 装饰器模式（Decorator）

> 动态地给对象添加行为（职责）

假设我们想用一些特效（duang）来装饰 `Text` 这个类：

```
class Text(val text: String) {
    fun draw() = print(text)
}
```

如果了解这个模式的话，你应该知道我们需要创建一些类来“修饰”（即，拓展行 为） `Text` 类。

在 Kotlin 中，我们可以用 **函数拓展（extension functions）** 来避免创建这么一大坨类：

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

有了这些拓展函数，我们现在可以实例化一个 `Text` 对象，并且在不创建其他类的情况下来修饰它的 `draw` 方法：

```
Text("Hello").run {
    background {
        underline {
            draw()
        }
    }
}
```

运行这段代码，你会看见带有彩色背景的“\_Hello\_”（如果终端支持 ansi 颜色的话）。

跟原本的装饰者相比，这里有一个不足：由于没有用来装饰的类了，所以我们不能使用“预装饰”过的对象了。

可以再次使用函数来解决这个问题，函数是 Kotlin 中的“一等公民”。我们可以这样写：

```
fun preDecorated(decorated: Text.() -> Unit): Text.() -> Unit {
    return { background { underline { decorated() } } }
}
```

### 创建型设计模式

#### Builder 模式

> 将复杂对象的构造与其表示分开，以便相同的构造过程可以创建不同形式的对象

**Builder** 模式很好用，可以避免臃肿的构造函数参数列表，还能方便地复用预先定义好的配置对象的代码。 Kotlin 的 `apply` 扩展原生支持 Builder 模式。

假设有一个 `Car` 类：

```
class Car() {
    var color: String = "red"
    var doors = 3
}
```

除了为这个类单独创建一个 `CarBuilder` ，我们可以使用 `apply`（`also` 也行）拓展来初始化一辆车：

```
Car().apply {
    color = "yellow"
    doors = 5
}
```

由于函数可以赋值给一个变量，所以这个初始化过程也可以放在一个变量里。这样，我们就有了一个预先定义好的 **Builder** “函数”，比如 `val yellowCar: Car.() -> Unit = { color = "yellow" }`

#### 原型模式（Prototype）

> 使用原型化的实例指定要创建的对象的种类，并通过复制此实例来创建特定的新对象

在 Java 中，原型模式理论上可以用 `Cloneable` 接口和 `Object.clone()` 来实现。然而，[`clone` 有很大的不足](http://www.artima.com/intv/bloch13.html)，所以我们应该避免使用它。

Kotlin 用数据类（data classes）提供了解决方案。

当使用数据类的时候，我们将免费得到 `equals`、`hashCode`、`toString` 和 `copy` 这几个函数。通过 `copy`，我们可以复制一整个对象并且修改所得到的新对象的一些属性。

```
data class EMail(var recipient: String, var subject: String?, var message: String?)
...

val mail = EMail("abc@example.com", "Hello", "Don't know what to write.")

val copy = mail.copy(recipient = "other@example.com")

println("Email1 goes to " + mail.recipient + " with subject " + mail.subject)
println("Email2 goes to " + copy.recipient + " with subject " + copy.subject)
```

#### 单例模式（Singleton）

> 确保一个类只有一个实例，并提供这个实例的全局访问点

尽管近来 **单例模式** 被认为是“反设计模式的”，但是它也有自己独特的用处（本文不会讨论这个话题，只是战战克克克克的来使用它）。

在 Java 中创建 **单例** 还是需要一番操作的，但是在 Kotlin 中只需要简单的使用 **`object`** 声明就可以了。

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

这里使用的 `object` 关键词会自动创建出 `Dictionary` 这个类以及它的一个单例。这个单例以“懒汉模式”创建，用到它时才会进行创建。

单例的访问方式和 Java 的静态方法差不多：

```
val word = "kotlin"
Dictionary.addDefinition(word, "an awesome programming language created by JetBrains")
println(word + " is " + Dictionary.getDefinition(word))
```

### 行为型设计模式

#### 模板方法（Template Method）

> 在操作中定义算法（步骤）的骨架，将一些步骤委托给子类

这个设计模式同时用到了类的继承。定义一些 `抽象方法` 并且在基类调用这些方法。抽象方法由子类负责实现。

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

现在从 `Task` 派生出一个在 `work` 方法中真正做了事情的具体类。

和 **装饰器模式** 使用函数拓展类似，这里的 **模板方法** 通过顶层函数实现。

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

看，根本没有必要写任何类！有人可能会有疑问，这不是 **策略模式** 吗，这个疑问不无道理。从另一方面来看，**策略模式** 和 **模板方法** 确实在解决很相似的问题（如果有什么不同）。

#### 策略模式（Strategy）

> 定义一系列算法，封装每个算法，并使它们可以互换

有一些 `Customer` ，他们每个月都要付一笔特定的费用。对于某些特定的人，这笔费用可以打折。我们不去为每种打折 **策略** 都去写一个对应的 `Customer` 子类，而是采用 **策略模式**。

```
class Customer(val name: String, val fee: Double, val discount: (Double) -> Double) {
    fun pricePerMonth(): Double {
        return discount(fee)
    }
}
```

注意这里没有使用接口，而是使用 `(Double) -> Double` （Double 到 Double）的函数来替代。为了使这个变换看上去有意义，我们可以声明一个类型别名，这样也不失高阶函数的灵活性： `typealias Discount = (Double) -> Double`.

无论哪种方式，我都可以定义多种 **策略** 来计算折扣。

```
val studentDiscount = { fee: Double -> fee/2 }
val noDiscount = { fee: Double -> fee }
...

val student = Customer("Ned", 10.0, studentDiscount)
val regular = Customer("John", 10.0, noDiscount)

println("${student.name} pays %.2f per month".format(student.pricePerMonth()))
println("${regular.name} pays %.2f per month".format(regular.pricePerMonth()))
```

#### 迭代器模式（Iterator）

> 提供了一种在不暴露其底层表示的情况下顺序访问聚合对象内部元素的方法

其实很难遇到需要手搓一个 **迭代器** 的情况。大多数情况，包装一个 `List` 并且实现 `Iterable`接口要更简单方便。

在 Kotlin 中， `iterator()` 是个操作符函数。这意味着当一个类定义了 `operator fun iterator()` 这个函数后，可以使用 `for` 循环来遍历它（不需要声明接口）。这个函数也能通过拓展函数配合使用，这是很酷炫的。 通过拓展函数，我们可以让 **每一个** 对象都是可迭代的。看下面这个例子：

```
class Sentence(val words: List<String>)
...
operator fun Sentence.iterator(): Iterator<String> = words.iterator()
```

现在我们可以在 `Sentence` 上进行迭代操作了。如果没有这个类的控制权的话，迭代器仍然将正常工作。

### 更多的模式……

这篇文章确实提到了相当几个设计模式，但这不是 **“四人帮”** 设计模式的全部。就像我在一开始提到的那样，尤其是结构型设计模式很难甚至根本不可能用和 Java 不同的方法来实现。 你可以在 [这个代码仓库](https://github.com/lmller/gof-in-kotlin) 找到更多的设计模式。欢迎来提交反馈和 PR。☺

希望这篇文章能给你些启发，让你认识到 Kotlin 可以为广为人知的问题带来的新的解决方案。

最后我想说的是，仓库中的代码量大概有 ⅓ 的 Kotlin 和 ⅔ 的 Java，虽然这两部分代码干了同样的事情🙃

---

封面图片来自 [stocksnap.io](stocksnap.io)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
