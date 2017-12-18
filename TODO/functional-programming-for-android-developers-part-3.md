> * 原文地址：[Functional Programming for Android Developers — Part 3](https://medium.freecodecamp.org/functional-programming-for-android-developers-part-3-f9e521e96788)
> * 原文作者：[Anup Cowkur](https://medium.freecodecamp.org/@anupcowkur?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-3.md)
> * 译者：[miguoer](https://github.com/miguoer)
> * 校对者：[shi-xiaopeng](https://github.com/shi-xiaopeng) [Cielsk](https://github.com/Cielsk)

# Android 开发者如何函数式编程 （三）

![](https://cdn-images-1.medium.com/max/800/1*exgznl7z65gttRxLsMAV2A.png)

在上一章，我们学习了**不可变性**和**并发**。在这一章，我们将学习**高阶函数**和**闭包**。

如果你还没有阅读过第一部分和第二部分，可以点击这里阅读：

- [Android 开发者如何函数式编程 （一）](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-1.md)
- [Android 开发者如何函数式编程 （二）](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-2.md)

### 高阶函数

高阶函数是可以接受将函数作为输入参数，也可以接受将函数作为输出结果的一类函数。很酷吧？

但是为什么有人想要那样做呢？

让我们看一个例子。假设我想压缩一堆文件。我想用两种压缩格式来做 — ZIP 或者 RAR 格式。如果用传统的 Java 来实现，通常会使用 [策略模式](https://en.wikipedia.org/wiki/Strategy_pattern)。

首先，创建一个定义策略的接口：

```
public interface CompressionStrategy {
    void compress(List<File> files);
}
```

然后，像以下代码一样实现两种策略：

```
public class ZipCompressionStrategy implements CompressionStrategy {
    @Override public void compress(List<File> files) {
        // Do ZIP stuff
    }
}
public class RarCompressionStrategy implements CompressionStrategy {
    @Override public void compress(List<File> files) {
        // Do RAR stuff
    }
}
```

在运行时，我们就可以使用任意一种策略：

```
public CompressionStrategy decideStrategy(Strategy strategy) {
    switch (strategy) {
        case ZIP:
            return new ZipCompressionStrategy();
        case RAR:
            return new RarCompressionStrategy();
    }
}
```

使用这种方式有一堆的代码和需要遵循的格式。

其实我们所要做的只是根据不同的变量实现两种不同的业务逻辑。由于业务逻辑不能在 Java 中独立存在，所以必须用类和接口去修饰。

如果能够直接传递业务逻辑，那不是很好吗？也就是说，如果可以把函数当作变量来处理，那么能否像传递变量和数据一样轻松地传递业务逻辑？

这**正是**高阶函数的功能！

现在，从高阶函数的角度来看这同一个例子。这里我要使用 [Kotlin](https://kotlinlang.org/) ，因为 Java 8 的 lambdas 表达式仍然包含了我们想要避免的 [一些创建函数接口的方式](https://stackoverflow.com/a/13604748/1369222) 。

```
fun compress(files: List<File>, applyStrategy: (List<File>) -> CompressedFiles){
    applyStrategy(files)
}
```

`compress` 方法接受两个参数 —— 一个文件列表和一个类型为 `List<File> -> CompressedFiles` 的 `applyStrategy` 函数。也就是说，它是一个函数，它接受一个文件列表并返回 `CompressedFiles`。

现在，我们调用 `compress` 时，传入的参数可以是任意接收文件列表并返回压缩文件的函数。：

```
compress(fileList, {files -> // ZIP it})
compress(fileList, {files -> // RAR it})
```

这样代码看起来干净多了。

所以高阶函数允许我们传递逻辑并将代码当作数据处理。 

### 闭包

闭包是可以捕捉其环境的函数。让我们通过一个例子来理解这个概念。假设给一个 view 设置了一个 click listener，在其方法内部想要打印一些值：

```
int x = 5;

view.setOnClickListener(new View.OnClickListener() {
    @Override public void onClick(View v) {
        System.out.println(x);
    }
});
```

Java 里面不允许我们这样做，因为 `x` 不是 final 的。在 Java 里 `x` 必须声明为 final，由于 `click listener` 可能在任意时间执行, 当它执行时 `x` 可能已经不存在或者值已经被改变，所以在 Java 里 `x` 必须声明为 `final`。Java 强制我们把这个变量声明为 final，实际上是为了把它设置成不可变的。

一旦它是不可变的，Java 就知道不管 click listener 什么时候执行，`x` 都等于 `5`。这样的系统并不完美，因为 `x` 可以指向一个列表，尽管列表的引用是不可变的，其中的值却可以被修改.

Java 没有一个机制可以让函数去捕捉和响应超过它作用域的变量。Java 函数不能捕捉或者涵盖到它们环境的变化。

让我们尝试在 Kotlin 中做相同的事。我们甚至不需要匿名内部类，因为在 Kotlin 中函数是「一等公民」：

```
var x = 5

view.setOnClickListener { println(x) }
```

这在 Kotlin 中是完全有效的。Kotlin 中的函数都是**闭包**。他们可以跟踪和响应其环境中的更新。

第一次触发 click listener 时, 会打印 `5`。如果我们改变 `x` 的值比如令 `x = 9`，再次触发 click listener ，这次会打印`9`。

#### 我们能利用闭包做什么？

闭包有很多非常好的用例。无论何时，只要你想让业务逻辑响应环境中的状态变化，那就可以使用闭包。

假设你在一个按钮上设置了点击 listener, 点击按钮会弹出对话框向用户显示一组消息。如果没有闭包，则每次消息更改时都必须使用新的消息列表并且初始化新的 listener。

有了闭包，你可以在某个地方存储消息列表并把列表的引用传递给 listener，就像我们上面做的一样，这个 listener 就会一直展示最新的消息。

**闭包也可以用来彻底替换对象。**这种用法经常出现在函数式编程语言的编程实践中，在那里你可能需要用到一些 OOP（面向对象编程）的编程方法，但是所使用的语言并不支持。

我们来看个例子：

```
class Dog {
    private var weight: Int = 10

    fun eat(food: Int) {
        weight += food
    }

    fun workout(intensity: Int) {
        weight -= intensity
    }

}
```

我有一条狗在喂食时体重增加，运动时体重减轻。我们能用闭包来描述相同的行为吗？

```
fun main(args: Array<String>) {
   dog(Action.feed)(5)
}
val dog = { action: Action ->
    var weight: Int = 10
when (action) {
        Action.feed -> { food: Int -> weight += food; println(weight) }
        Action.workout -> { intensity: Int -> weight -= intensity; println(weight) }
    }
}
enum class Action {
    feed, workout
}
```

`dog` 函数接受一个 `Action` 参数，这个 action 要么是给狗喂食，要么是让它去运动。当在 `main` 中调用 `dog(Action.feed)(5)`，结果将是 `15` 。 `dog` 函数接受了一个 `feed` 动作，并返回了另外一个真正去给狗喂食的函数。如果把 `5` 传递给这个返回的函数，它将把狗狗的体重增加到 `10 + 5 = 15` 并打印出来。

> 所以结合闭包和高阶函数，我们没有使用 OOP 就有了对象。

![](https://cdn-images-1.medium.com/max/800/1*qOekxkFDrnQQIekBjkouiQ.gif)

可能你在真正写代码的时候不会这样做，但是知道可以这样做也是蛮有趣的。确实，闭包被称为[**可怜人的对象**](http://wiki.c2.com/?ClosuresAndObjectsAreEquivalent)。

### 总结

在许多情况下，相比于 OOP 高阶函数让我们可以更好地封装业务逻辑，我们可以将它们当做数据一样传递。闭包捕获其周围环境，帮助我们有效地使用高阶函数。

在下一部分，我们将学习如何以函数式的方法去处理错误。

* * *

**如果你喜欢这篇文字，可以点击下面的 👏 按钮。我通知了他们每一个人，我也感激他们每一个人。**

感谢 [Abhay Sood](https://medium.com/@abhaysood?source=post_page) 和 [s0h4m](https://medium.com/@s0h4m?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
