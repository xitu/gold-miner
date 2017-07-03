
> * 原文地址：[Exploring Kotlin’s hidden costs — Part 1](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-1-fbb9935d9b62)
> * 原文作者：[Christophe B.](https://medium.com/@BladeCoder)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译文地址：[github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-1.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：

# Exploring Kotlin’s hidden costs — Part 1

# 探索 Kotlin 中的隐性成本（第一部分）

---

![](https://cdn-images-1.medium.com/max/800/1*jA64NTovT-efZ96tcq-X5g.png)

# Exploring Kotlin’s hidden costs — Part 1

# 探索 Kotlin 中的隐性成本（第一部分）

## Lambda expressions and companion objects

## Lambda 表达式和伴生对象

In 2016, [Jake Wharton](http://jakewharton.com/) gave a series of interesting talks about [Java’s hidden costs](https://news.realm.io/news/360andev-jake-wharton-java-hidden-costs-android/). Around the same period he also started advocating the use of the [Kotlin](https://kotlinlang.org/) language for Android development but barely mentioned the hidden costs of that language, aside from recommending the use of [inline functions](https://kotlinlang.org/docs/reference/inline-functions.html). Now that Kotlin is officially supported by Google in Android Studio 3, I thought it would be a good idea to write about that aspect of the language by studying the bytecode it produces.

2016年，[Jake Wharton](http://jakewharton.com/) 发表了一系列有趣的关于 [Java 的隐性成本](https://news.realm.io/news/360andev-jake-wharton-java-hidden-costs-android/) 的讨论。差不多同一时期他开始提倡使用 [Kotlin](https://kotlinlang.org/) 来开发 Android，但对 Kotlin 的隐性成本几乎只字未提，除了推荐使用[内联函数](https://kotlinlang.org/docs/reference/inline-functions.html)。如今 Kotlin 在 Android Studio 3 中被 Google 官方支持，我认为通过研究 Kotlin 产生的字节码来说一下关于这方面（隐性成本）的问题是个好主意。

Kotlin is a modern programming language with a lot more syntactic sugar compared to Java, and as such there is equally more “black magic” going on behind the scenes, some of it having non-negligible costs, especially for Android development targeting older and lower-end devices.

与 Java 相比，Kotlin 是一种有更多语法糖的现代编程语言，同样也有很多“黑魔法”运行在幕后，他们中有些有着不容忽视的成本，尤其是针对老的和低端的 Android 设备上的开发。

This is not a case against Kotlin: I like the language a lot and it increases productivity, but I also believe a good developer needs to know how language features work internally in order to use them more wisely. Kotlin is powerful and some famous quote says:

这不是一个专门针对 Kotlin 的现象：我很喜欢这门语言，它提高了效率，但是我相信一个优秀的开发者需要知道这些语言特性在内部是如何工作的以便更明智地使用他们。Kotlin 是强大的，有句名言说：

> “With great power comes great responsibility.”  
> “能力越大，责任越大。”

These articles will focus solely on the JVM/Android implementation of Kotlin 1.1, not the Javascript implementation.

本文只关注 Kotlin 1.1 在 JVM/Android 上的实现，不关注 Javascript 上的实现。

#### Kotlin Bytecode inspector
#### Kotlin 字节码检测器

This is the tool of choice to figure out how Kotlin code gets translated to bytecode. With the Kotlin plugin installed in Android Studio, select the “Show Kotlin Bytecode” action to open a panel showing the bytecode of the current class. You can then press the “Decompile” button in order to read the equivalent Java code.

这是一个可选择的工具，他能推断出 Kotlin 代码是怎样被转换成字节码的。在 Android Studio 中安装了 Kotlin 插件后，选择“显示 Kotlin 字节码”选项来打开一个显示当前类的字节码的面板。然后你可以点击“反编译”按钮来阅读同等的 Java 代码。

![](https://cdn-images-1.medium.com/max/800/1*RUsF1M4oD2G4OwGE89-yOw.png)

In particular, I’ll mention each time a Kotlin feature involves:

特别是，我将提到的 Kotlin 特性有：

- Boxing primitive types, which allocates short-lived objects
- 基本类型装包，分配短期对象
- Instantiating extra objects not directly visible in code
- 实例化额外的对象在代码中不是直接可见的
- Generating extra methods. As you may know, in Android applications [the number of allowed methods inside a single dex file is limited](https://developer.android.com/studio/build/multidex.html), and going above it requires configuring multidex which comes with limitations and performance penalties, particularly on Android versions before Lollipop.
- 生成额外的方法。正如你可能已知，在 Android 应用中[一个 dex 文件中允许的方法数量是有限的](https://developer.android.com/studio/build/multidex.html)，超限了就需要配置 multidex，然而这有局限性且有损性能，尤其是在 Lollipop 之前的 Adnroid 版本中。

#### A note about benchmarks
#### 注意基准

I deliberately chose **not** to publish any microbenchmark, because most of them are meaningless, flawed, or both and cannot apply to all code variations and runtime environments. Negative performance impact will usually be amplified when the concerned code is used in loops or nested loops.

我故意选择**不**公布任何微基准，因为他们中的大多数毫无意义，或者有缺陷，或者两者兼有，并且不能够应用于所有的代码变化和运行时环境。当相关的代码运行在循环或者嵌套循环中的时候负面的性能影响通常会被放大。

Furthermore, execution time is not the only thing to measure: increased memory usage has to be taken into consideration as well, because all allocated memory has to be reclaimed eventually and the cost of garbage collection depends on many factors like the available memory and the GC algorithm being used on the platform.

此外，执行时间并不是唯一衡量标准，增长的内存使用也必须考虑，因为所有分配的内存最终都必须回收，垃圾回收的成本取决于很多因素，比如说可用内存和平台上使用的垃圾回收算法。

In a nutshell: if you want to know if a Kotlin construct has some noticeable speed or memory impact, **measure your own code on your own target platform**.

简而言之，如果你想知道一个 Kotlin 构造对速度或者内存是否有明显的影响，**在你的目标平台上测试你的代码**。

---

### Higher-order functions and Lambda expressions
### 高阶函数和 Lambda 表达式

Kotlin supports assigning functions to variables and passing them as arguments to other functions. Functions accepting other functions as arguments are called *higher-order functions.* A Kotlin function can be referenced by its name prefixed with `::` or declared directly inside a code block as an anonymous function or using the [lambda expression syntax](https://kotlinlang.org/docs/reference/lambdas.html#lambda-expression-syntax) which is the most compact way to describe a function.

Kotlin 支持将函数赋值给变量并将他们做为参数传给其他函数。接收其他函数做为参数的函数被称为*高阶函数*。Kotlin 函数可以通过在他的名字前面加 `::` 前缀来引用，或者在代码中中直接声明为一个匿名函数，或者使用最简洁的 [lambda 表达式语法](https://kotlinlang.org/docs/reference/lambdas.html#lambda-expression-syntax) 来描述一个函数。

Kotlin is one of the best ways to provide lambdas support for Java 6/7 JVMs and Android.

Kotlin 是为 Java 6/7 JVM 和 Android 提供 lambda 支持的最好方法之一。

Consider the following utility function which performs arbitrary operations inside a database transaction and returns the number of affected rows:  
考虑下面的工具函数，在一个数据库事务中执行任意操作并返回受影响的行数：

```
fun transaction(db: Database, body: (Database) -> Int): Int {
    db.beginTransaction()
    try {
        val result = body(db)
        db.setTransactionSuccessful()
        return result
    } finally {
        db.endTransaction()
    }
}
```

We can call this function by passing a lambda expression as last argument, using a syntax similar to Groovy:  
我们可以通过传递一个 lambda 表达式做为最后的参数来调用这个函数，使用类似于 Groovy 的语法：

```
val deletedRows = transaction(db) {
    it.delete("Customers", null, null)
}
```

But Java 6 JVMs don’t support lambda expressions directly. So how are they translated to bytecode? As you might expect, lambdas and anonymous functions are compiled as `Function` objects.

但是 Java 6 的 JVM 并不直接支持 lambda 表达式。他们是如何转化为字节码的呢？如你所料，lambdas 和匿名函数被编译成 `Function` 对象。

#### Function objects
#### Function 对象

Here is the Java representation of the above lambda expression after compilation.  
这是上面的的 lamdba 表达式编译之后的 Java 表现形式。

```
class MyClass$myMethod$1 implements Function1 {
   // $FF: synthetic method
   // $FF: bridge method
   public Object invoke(Object var1) {
      return Integer.valueOf(this.invoke((Database)var1));
   }

   public final int invoke(@NotNull Database it) {
      Intrinsics.checkParameterIsNotNull(it, "it");
      return db.delete("Customers", null, null);
   }
}
```

In your Android dex file, each lambda expression compiled as a `Function` will actually [add 3 or 4 methods](https://gist.github.com/JakeWharton/ea4982e491262639884e) to the total methods count.  
在你的 Android dex 文件中，每一个 lambda 表达式都被编译成一个 `Function`，这将在方法总数上[增加3个或4个](https://gist.github.com/JakeWharton/ea4982e491262639884e)。

The good news is that new instances of these `Function` objects are only created when necessary. In practice, this means:  
好消息是，这些 `Function` 对象的新实例只在必要的时候才创建。在实践中，这意味着：

- For *capturing expressions*, a new `Function` instance will be created every time a lambda is passed as argument then garbage-collected after execution;
- 对*捕捉表达式*来说，每当一个 lambda 做为参数传递的时候都会生成一个新的 `Function` 实例，执行完后就会进行垃圾回收。
- For *non-capturing expressions* (pure functions), a singleton `Function` instance will be created and reused during the next calls.
- 对*非捕捉表达式*（纯函数）来说，会创建一个单例的 `Function` 实例并且在下次调用的时候重用。 

Since the caller code of our example uses a non-capturing lambda, it is compiled as a singleton and not an inner class:

由于我们示例中的调用者代码使用了一个非捕捉的 lambda，他被编译为一个单例而不是内部类：

```
this.transaction(db, (Function1)MyClass$myMethod$1.INSTANCE);
```

> Avoid calling standard (non-inline) higher-order functions repeatedly if they are invoking **capturing lambdas** in order to reduce pressure on the garbage collector.

> 如果那些标准（非内联）的高阶函数正在调用**捕获 lambdas**，避免反复调用他们以减少垃圾回收器的压力。

#### Boxing overhead
#### 装包的开销

Contrary to Java 8 which has about [43 different specialized function interfaces](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html) to avoid boxing and unboxing as much as possible, the `Function` objects compiled by Kotlin only implement fully generic interfaces, effectively using the `Object` type for any input or output value.

与 Java8 大约有[43个不同的专业方法接口](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)来尽可能地避免装包和拆包相反，Kotnlin 编译出来的 `Function` 对象只实现了完全通用的接口，有效的使用任何输入输出值的 `Object` 类型。

```
/** A function that takes 1 argument. */
public interface Function1<in P1, out R> : Function<R> {
    /** Invokes the function with the specified argument. */
    public operator fun invoke(p1: P1): R
}
```

This means that calling a function passed as argument in a higher-order function will actually involve **systematic boxing and unboxing** when the function involves primitive types (like `Int` or `Long`) for input values or the return value. This may have a non-negligible impact on performance, especially on Android.

这意味着调用一个做为参数传递给高阶函数的方法时，如果输入值或者返回值涉及到基本类型（比如 `Int` 或 `Long`），实际上调用了**系统的装包和拆包**。这在性能上可能有着不容忽视的影响，特别是在 Android 上。

In our compiled lambda above, you can see that the result is boxed to an `Integer` object. The caller code will then immediately unbox it.

在上面编译好的 lambda 中，你可以看到结果被装包成了 `Integer` 对象。然后调用者代码将马上拆包。

> Be careful when writing a standard (non-inline) higher-order function involving **an argument function using primitive types** for input or output values. Calling this argument function repeatedly will put more pressure on the garbage collector through boxing and unboxing operations.

> 当写一个标准（非内联）的高阶函数（涉及到以基本类型做为输入或输出值的函数做为参数）的时候要小心一点。反复调用这个参数函数会由于装包和拆包的操作对垃圾回收器造成更多压力。

#### Inline functions to the rescue
#### 内联函数来补救

Thankfully, Kotlin features a wonderful trick to avoid paying any of these costs when using lambda expressions: declaring the higher-order function as `[**inline**](https://kotlinlang.org/docs/reference/inline-functions.html#reified-type-parameters)`. This will make the compiler inline the function body directly inside the caller code, avoiding the call entirely. For higher-order functions the benefits are even greater because **the body of the lambda expressions passed as arguments will be inlined as well**. The practical effects are:

还好，在使用 lambda 表达式的时候，Kotlin 有一个非常棒的技巧来避免这些成本：将高阶函数声明为[**内联**](https://kotlinlang.org/docs/reference/inline-functions.html#reified-type-parameters)。这将会使编译器将函数体直接内联到调用者代码内，完全避免了调用。对高阶函数来说好处更大，因为**做为参数传递的 lambda 表达式的函数体也会被内联起来**。实际的影响有：

- No `Function` objects will be instantiated when the lambda is declared;
- 声明 lambda 的时候不会有 `Function` 对象被实例化；
- No boxing or unboxing will be applied to the lambda input and output values targeting primitive types;
- 不需要针对 lambda 输入输出的基本类型值进行装包和拆包；
- No methods will be added to the total methods count;
- 方法总数不会增加；
- No actual function call will be performed. This can improve performance for CPU-heavy code where the function is used many times.
- 不会执行真正的函数调用。对那些多次被使用的重 CPU 的方法来说可以提高性能。

After declaring our `transaction()` function as `**inline**`, the Java representation of our caller code effectively becomes:

将我们的 `transaction()` 函数声明为**内联**后，调用者代码变成了：

```
db.beginTransaction();
int var5;
try {
   int result$iv = db.delete("Customers", null, null);
   db.setTransactionSuccessful();
   var5 = result$iv;
} finally {
   db.endTransaction();
}
```

This killer feature comes with a few caveats:
这个杀手级的特性

- An inline function can not call itself directly or through another inline function;
- 内联函数不能直接调用自己，也不能通过其他内联函数来调用；
- A public inline function declared in a class can only access the public functions and fields of that class;
- 一个类中被声明为公共的内联函数只能访问这个类中公共的方法和成员变量；
- The code will grow in size. Inlining a long function referenced many times can make the generated code significantly larger, even more if this long function is itself referencing other long inline functions.
- 代码量将会增加。多次内联一个长函数能使生成的代码量明显增多，尤其这个长方法又引用了另外一个长的内联方法。

> When possible, declare higher-order functions as `**inline**`. Keep them short, moving big blocks of code to non-inline functions if required.  
> 只要有可能就将一个高阶函数声明为**内联**。保持简短，如果有必要可以将大段的代码块移至非内联的方法中。  
> You can also inline functions called from performance-critical portions of the code.  
> 你也可以

We’ll discuss other performance benefits of inline functions in a future article.
在未来的文章中我们将讨论内联函数在性能提升上的其他好处。

---

### Companion objects
### 伴生对象

Kotlin classes have no static fields or methods. Instead, fields and methods that are not instance-related can be declared in a [companion object](https://kotlinlang.org/docs/reference/object-declarations.html#companion-objects) inside the class.

Kotlin 类没有静态的变量和方法。相应的，类中与实例无关的字段和方法可以通过[伴生对象](https://kotlinlang.org/docs/reference/object-declarations.html#companion-objects)来声明。

#### Accessing private class fields from its companion object
#### 通过它的伴生对象来访问私有的类字段

Consider the following example:
考虑下面的例子：

```
class MyClass private constructor() {

    private var hello = 0

    companion object {
        fun newInstance() = MyClass()
    }
}
```

When compiled, a companion object is implemented as a singleton class. This means that just like for any Java class whose private fields need to be accessible from other classes, **accessing a **`**private**`** field (or constructor) of the outer class from the companion object will generate additional synthetic getter and setter methods**. Each read or write access to a class field will result in a static method call in the companion object.
编译的时候，一个伴生对象被实现为一个单例类。这差不多意味着对任何需要从外部类来访问其私有字段的类来说，通过伴生对象来**访问**外部类的**私有**字段（或构造器）都将生成额外的 getter 和 setter 方法。每次对一个类字段的读或写的访问都会在伴生对象中生成一个静态的方法调用。

```
ALOAD 1
INVOKESTATIC be/myapplication/MyClass.access$getHello$p (Lbe/myapplication/MyClass;)I
ISTORE 2
```

In Java we would use the `package` visibility for these fields to avoid generating these methods. However, there is no `package` visibility in Kotlin. Using the `public` or `internal` visibility instead will result in Kotlin generating default getter and setter instance methods to make the fields accessible to the outside world, and calling instance methods is technically more expensive than calling static methods. So don’t bother changing the visibility of these fields for optimization reasons.
在 Java 对这些字段我们可以使用 `package` 级别的访问权限来避免生成这些方法。但是 Kotlin 没有 `package` 级别的访问权限。使用 `public` 或者 `internal` 访问权限代码会生成默认的 getter 和 setter 实例方法来使外部世界能够访问字段，而且调用实例方法从技术上说比调用静态方法成本更大。所以不要因为优化的原因乱改字段的访问权限。

> If you need repeated read or write access to a class field from a companion object, you may cache its value in a local variable to avoid repeated hidden method calls.  
> 如果你需要从一个伴生对象中反复的读或写一个类字段，你可以将它的值缓存在一个本地变量中来避免反复的隐性的方法调用。

#### Accessing constants declared in a companion object
#### 访问伴生对象中声明的常量

In Kotlin you typically declare “static” constants you use in your class inside a companion object.
在 Kotlin 中你习以为常地在一个伴生对象中声明在类中使用的“静态”常量。


```
class MyClass {

    companion object {
        private val TAG = "TAG"
    }

    fun helloWorld() {
        println(TAG)
    }
}
```

That code looks neat and simple, but what happens behind the scenes is quite ugly.
这段代码看起来干净整洁，但是幕后发生的事情却十分不堪。

For the same reasons mentioned above, **accessing a **`**private**`** constant declared in the companion object will actually generate an additional synthetic getter method in the companion object implementation class**.
由于上面提到的相同原因，**访问**一个在伴生对象中声明为**私有**的常量实际上会在这个伴生对象的实现类中生成一个额外的 getter 方法。

```
GETSTATIC be/myapplication/MyClass.Companion : Lbe/myapplication/MyClass$Companion;
INVOKESTATIC be/myapplication/MyClass$Companion.access$getTAG$p (Lbe/myapplication/MyClass$Companion;)Ljava/lang/String;
ASTORE 1
```

But things get worse. The synthetic method does not actually return the value; it calls an instance method which is a getter generated by Kotlin:
但是更糟的是，语法方法实际上并没有返回值；它调用了 Kotlin 生成的实例 getter 方法：

```
ALOAD 0
INVOKESPECIAL be/myapplication/MyClass$Companion.getTAG ()Ljava/lang/String;
ARETURN
```

When the constant is declared `public` instead of `private`, this getter method is public and able to be called directly, so the synthetic method of the previous step is not needed. But Kotlin still requires calling a getter method to read a constant.
常量被声明为 `public` 而不是 `public` 的时候，getter 方法是公共的并且可以直接调用，因此不需要上一步的语法方法。但是 Kotlin 仍然必须通过调用 getter 方法来访问常量。

So, are we done yet? No! It turns out that in order to store the constant value, the Kotlin compiler generates an actual `private static final` field at the main class level and not inside the companion object. But, **because the static field is declared private in the class, another synthetic method is needed to access it from the companion object**.
所以我们完了吗？并没有！这证明了为了存储常量值，Kotlin 编译器实际上在主类级别上生成了一个 `private static final` 字段，而不是伴生对象中。但是，**因为在类中静态字段被声明为私有的，在伴生对象中需要有一个额外的语法方法来访问它**

```
INVOKESTATIC be/myapplication/MyClass.access$getTAG$cp ()Ljava/lang/String;
ARETURN
```

And that synthetic method reads the actual value, at last:
并且那个语法方法读取了实际的值，最终：

```
GETSTATIC be/myapplication/MyClass.TAG : Ljava/lang/String;
ARETURN
```

In other words, when you access a private constant field in a companion object from a Kotlin class, instead of reading a static field directly like Java does, your code will actually:
换句话说，当你从一个 Kotlin 类来访问一个伴生对象中的私有常量字段的时候，与 Java 直接读取一个静态字段不同，你的代码实际上会：

- call a static method in the companion object,
- 在伴生对象上调用一个静态方法，
- which will in turn call an instance method in the companion object,
- 在伴生对象上它会调用实例方法，
- which will in turn call a static method in the class,
- 在类中它会调用静态方法，
- which will read the static field and return its value.
- 读取静态字段然后返回它的值。

Here is the equivalent Java code:
这是赞同的 Java 代码：

```
public final class MyClass {
    private static final String TAG = "TAG";
    public static final Companion companion = new Companion();

    // synthetic
    public static final String access$getTAG$cp() {
        return TAG;
    }

    public static final class Companion {
        private final String getTAG() {
            return MyClass.access$getTAG$cp();
        }

        // synthetic
        public static final String access$getTAG$p(Companion c) {
            return c.getTAG();
        }
    }

    public final void helloWorld() {
        System.out.println(Companion.access$getTAG$p(companion));
    }
}
```

So can we get lighter bytecode? Yes, but not in every case.
我们能得到更少的字节码吗？是的，但并不是所有情况都如此。

First, it is possible to completely avoid any method call by declaring the value as a [compile-time constant](https://kotlinlang.org/docs/reference/properties.html#compile-time-constants) using the `**const**` keyword. This will effectively inline the value directly in the calling code, *but you can only use this for primitive types and Strings*.  
首先，通过 **`const`** 关键字声明值为[编译时常量](https://kotlinlang.org/docs/reference/properties.html#compile-time-constants)来完全避免任何的方法调用是有可能的。这将直接在调用代码中内联这个值，*但是只有基本类型和字符串能使用这种方式*。

```
class MyClass {

    companion object {
        private const val TAG = "TAG"
    }

    fun helloWorld() {
        println(TAG)
    }
}
```

Second, you can use the `[@JvmField](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#instance-fields)` annotation on a public field in the companion object to instruct the compiler to not generate any getter or setter and expose it as a static field in the class instead, just like pure Java constants. In fact, this annotation has been created solely for Java compatibility reasons and I would definitely not recommend to clutter your beautiful Kotlin code with an obscure interop annotation if you don’t need your constant to be accessible from Java code. *Also, it can only be used for public fields.* In the context of Android development, you will probably only use this annotation to implement `Parcelable` objects:  
第二，你可以在伴生对象的公共字段上使用 [`@JvmField`](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#instance-fields) 注解来告诉编译器不要生成任何的 getter 和 setter 方法，就像纯 Java 中的常量一样做为类的一个静态变量暴露出来。实际上，这个注解只是单独为了兼容 Java 而创建的，如果你的常量不需要从 Java 代码中访问的话，我是绝不推荐你用一个晦涩的交互注解来弄乱你漂亮的 Kotlin 代码的。*同样地，这只能运用在公共变量上*。在 Android 的开发环境中，你可能只在实现 `Parcelable` 对象的时候才使用这个注解：

```
class MyClass() : Parcelable {

    companion object {
        @JvmField
        val CREATOR = creator { MyClass(it) }
    }

    private constructor(parcel: Parcel) : this()

    override fun writeToParcel(dest: Parcel, flags: Int) {}

    override fun describeContents() = 0
}
```

Finally, you can also use the [ProGuard](https://developer.android.com/studio/build/shrink-code.html) tool to optimize the bytecode and hope that it will merge some of these chained method calls together, *but there is absolutely no guarantee this will work*.  
最后，你也可以用 [ProGuard](https://developer.android.com/studio/build/shrink-code.html) 工具来优化字节码，希望通过这种方式来合并这些链式方法调用，但是绝对不保证这是有效的。

> Reading a “static” constant from a companion object adds two to three additional levels of indirection in Kotlin compared to Java and two to three additional methods will be generated for each of these constants.  
> 与 Java 相比，在 Kotlin 中从伴生对象里读取一个 `static` 常量会增加 2 到 3 个额外的间接级别并且每一个常量都会生成 2 到 3个方法。  
> Always declare primitive type and String constants using the **const** keyword to avoid this.  
> 用 **const** 关键字将基本类型和字符串常量从面避免这
> For other types of constants you can’t, so if you need to access the constant repeatedly, you may want to cache the value in a local variable.  
> 对其他类型的常量来说，你不能这么做，因此如果你需要反复访问这个常量的话，你或许可以把它的值缓存在一个本地变量中。

> Also, prefer storing public global constants in their own object rather than a companion object.  
> 同时，最好在它们自己的对象而不是伴生对象中来存储公共的全局常量。

---

That’s all for this first article. Hopefully this gave you a better understanding of the implications of using these Kotlin features. Keep this in mind in order to write smarter code without sacrificing readability nor performance.  
这就是第一篇文章的所有。希望这些可以让你更好的理解使用这些 Kotlin 特性的影响。牢记这一点以编写更智能的不损失可读性和性能的代码。

Keep reading by heading to [part 2](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-2-324a4a50b70): *local functions*, *null safety* and *varargs*.  
继续阅读[第二部分](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-2-324a4a50b70)：*本地函数*，*空安全*，*可变参数*。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
