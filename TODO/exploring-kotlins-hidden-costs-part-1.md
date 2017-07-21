
> * 原文地址：[Exploring Kotlin’s hidden costs — Part 1](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-1-fbb9935d9b62)
> * 原文作者：[Christophe B.](https://medium.com/@BladeCoder)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译文地址：[github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-1.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[CACppuccino](https://github.com/CACppuccino) 、[phxnirvana](https://github.com/phxnirvana)

# 探索 Kotlin 中的隐性成本（第一部分）

---

![](https://cdn-images-1.medium.com/max/800/1*jA64NTovT-efZ96tcq-X5g.png)

# 探索 Kotlin 中的隐性成本（第一部分）

## Lambda 表达式和伴生对象

2016年，[Jake Wharton](http://jakewharton.com/) 做了一系列有趣的关于 [Java 的隐性成本](https://news.realm.io/news/360andev-jake-wharton-java-hidden-costs-android/) 的讨论。差不多同一时期他开始提倡使用 [Kotlin](https://kotlinlang.org/) 来开发 Android，但对 Kotlin 的隐性成本几乎只字未提，除了推荐使用[内联函数](https://kotlinlang.org/docs/reference/inline-functions.html)。如今 Kotlin 在 Android Studio 3 中被 Google 官方支持，我认为通过研究 Kotlin 产生的字节码来说一下关于这方面（隐性成本）的问题是个好主意。

与 Java 相比，Kotlin 是一种有更多语法糖的现代编程语言，同样也有很多“黑魔法”运行在幕后，他们中有些有着不容忽视的成本，尤其是针对老的和低端的 Android 设备上的开发。

这不是一个专门针对 Kotlin 的现象：我很喜欢这门语言，它提高了效率，但是我相信一个优秀的开发者需要知道这些语言特性在内部是如何工作的以便更明智地使用他们。Kotlin 是强大的，有句名言说：

> “能力越大，责任越大。”

本文只关注 Kotlin 1.1 在 JVM/Android 上的实现，不关注 Javascript 上的实现。

#### Kotlin 字节码检测器

这是一个可选择的工具，他能推断出 Kotlin 代码是怎样被转换成字节码的。在 Android Studio 中安装了 Kotlin 插件后，选择 “Show Kotlin Bytecode” 选项来打开一个显示当前类的字节码的面板。然后你可以点击 “Decompile” 按钮来阅读同等的 Java 代码。

![](https://cdn-images-1.medium.com/max/800/1*RUsF1M4oD2G4OwGE89-yOw.png)

特别是，我将提到的 Kotlin 特性有：

- 基本类型装箱，分配短期对象
- 实例化额外的对象在代码中不是直接可见的
- 生成额外的方法。正如你可能已知的，在 Android 应用中[一个 dex 文件中允许的方法数量是有限的](https://developer.android.com/studio/build/multidex.html)，超限了就需要配置 multidex，然而这有局限性且有损性能，尤其是在 Lollipop 之前的 Android 版本中。

#### 注意基准

我故意选择**不**公布任何微基准，因为他们中的大多数毫无意义，或者有缺陷，或者两者兼有，并且不能够应用于所有的代码变化和运行时环境。当相关的代码运行在循环或者嵌套循环中时负面的性能影响通常会被放大。

此外，执行时间并不是唯一衡量标准，增长的内存使用也必须考虑，因为所有分配的内存最终都必须回收，垃圾回收的成本取决于很多因素，比如说可用内存和平台上使用的垃圾回收算法。

简而言之，如果你想知道一个 Kotlin 构造对速度或者内存是否有明显的影响，**在你的目标平台上测试你的代码**。

---

### 高阶函数和 Lambda 表达式

Kotlin 支持将函数赋值给变量并将他们做为参数传给其他函数。接收其他函数做为参数的函数被称为**高阶函数**。Kotlin 函数可以通过在他的名字前面加 `::` 前缀来引用，或者在代码中中直接声明为一个匿名函数，或者使用最简洁的 [lambda 表达式语法](https://kotlinlang.org/docs/reference/lambdas.html#lambda-expression-syntax) 来描述一个函数。

Kotlin 是为 Java 6/7 JVM 和 Android 提供 lambda 支持的最好方法之一。

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

我们可以通过传递一个 lambda 表达式做为最后的参数来调用这个函数，使用类似于 Groovy 的语法：

```
val deletedRows = transaction(db) {
    it.delete("Customers", null, null)
}
```

但是 Java 6 的 JVM 并不直接支持 lambda 表达式。他们是如何转化为字节码的呢？如你所料，lambdas 和匿名函数被编译成 `Function` 对象。

#### Function 对象

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

在你的 Android dex 文件中，每一个 lambda 表达式都被编译成一个 `Function`，这将最终[增加3到4个方法](https://gist.github.com/JakeWharton/ea4982e491262639884e)。

好消息是，这些 `Function` 对象的新实例只在必要的时候才创建。在实践中，这意味着：

- 对**捕获表达式**来说，每当一个 lambda 做为参数传递的时候都会生成一个新的 `Function` 实例，执行完后就会进行垃圾回收。
- 对**非捕获表达式**（纯函数）来说，会创建一个单例的 `Function` 实例并且在下次调用的时候重用。 

由于我们示例中的调用代码使用了一个非捕获的 lambda，因此它被编译为一个单例而不是内部类：

```
this.transaction(db, (Function1)MyClass$myMethod$1.INSTANCE);
```

> 避免反复调用那些正在调用**捕获 lambdas**的标准的（非内联）高阶函数以减少垃圾回收器的压力。

#### 装箱的开销

与 Java8 大约有[43个不同的专业方法接口](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)来尽可能地避免装箱和拆箱相反，Kotnlin 编译出来的 `Function` 对象只实现了完全通用的接口，有效地使用任何输入输出值的 `Object` 类型。

```
/** A function that takes 1 argument. */
public interface Function1<in P1, out R> : Function<R> {
    /** Invokes the function with the specified argument. */
    public operator fun invoke(p1: P1): R
}
```

这意味着调用一个做为参数传递给高阶函数的方法时，如果输入值或者返回值涉及到基本类型（如 `Int` 或 `Long`），实际上调用了**系统的装箱和拆箱**。这在性能上可能有着不容忽视的影响，特别是在 Android 上。

在上面编译好的 lambda 中，你可以看到结果被装箱成了 `Integer` 对象。然后调用者代码马上将其拆箱。

> 当写一个标准（非内联）的高阶函数（涉及到以基本类型做为输入或输出值的函数做为参数）时要小心一点。反复调用这个参数函数会由于装箱和拆箱的操作对垃圾回收器造成更多压力。

#### 内联函数来补救

幸好，使用 lambda 表达式时，Kotlin 有一个非常棒的技巧来避免这些成本：将高阶函数声明为[**内联**](https://kotlinlang.org/docs/reference/inline-functions.html#reified-type-parameters)。这将会使编译器将函数体直接内联到调用代码内，完全避免了方法调用。对高阶函数来说好处更大，因为**作为参数传递的 lambda 表达式的函数体也会被内联起来**。实际的影响有：

- 声明 lambda 时不会有 `Function` 对象被实例化；
- 不需要针对 lambda 输入输出的基本类型值进行装箱和拆箱；
- 方法总数不会增加；
- 不会执行真正的函数调用。对那些多次被使用的注重 CPU （计算）的方法来说可以提高性能。

将我们的 `transaction()` 函数声明为**内联**后，调用代码变成了：

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

关于这个杀手锏特性的一些警告：

- 内联函数不能直接调用自己，也不能通过其他内联函数来调用；
- 一个类中被声明为公共的内联函数只能访问这个类中公共的方法和成员变量；
- 代码量会增加。多次内联一个长函数会使生成的代码量明显增多，尤其这个长方法又引用了另外一个长的内联方法。

> 如果可能的话，就将一个高阶函数声明为**内联**。保持简短，如有必要可以将大段的代码块移至非内联的方法中。  
> 你还可以将调用自代码中影响性能的关键部分的函数内联起来。

我们将在以后的文章中讨论内联函数的其他性能优势。

---

### 伴生对象

Kotlin 类没有静态变量和方法。相应的，类中与实例无关的字段和方法可以通过[伴生对象](https://kotlinlang.org/docs/reference/object-declarations.html#companion-objects)来声明。

#### 通过它的伴生对象来访问私有的类字段

考虑下面的例子：

```
class MyClass private constructor() {

    private var hello = 0

    companion object {
        fun newInstance() = MyClass()
    }
}
```

编译的时候，一个伴生对象被实现为一个单例类。这意味着，就像任何需要从外部类来访问其私有字段的 Java 类一样，通过伴生对象来**访问**外部类的**私有**字段（或构造器）将生成额外的 getter 和 setter 方法。每次对一个类字段的读或写都会在伴生对象中引起一个静态的方法调用。

```
ALOAD 1
INVOKESTATIC be/myapplication/MyClass.access$getHello$p (Lbe/myapplication/MyClass;)I
ISTORE 2
```

在 Java 对这些字段我们可以使用 `package` 级别的访问权限来避免生成这些方法。但是 Kotlin 没有 `package` 级别的访问权限。使用 `public` 或者 `internal` 访问权限来代替的话会生成默认的 getter 和 setter 实例方法来使外部世界能够访问字段，而且调用实例方法从技术上说比调用静态方法成本更大。所以不要因为优化的原因而改变字段的访问权限。

> 如果需要从一个伴生对象中反复的读或写一个类字段，你可以将它的值缓存在一个本地变量中来避免反复的隐性的方法调用。

#### 访问伴生对象中声明的常量

在 Kotlin 中你通常在一个伴生对象中声明在类中使用的“静态”常量。


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

这段代码看起来干净整洁，但是幕后发生的事情却十分不堪。

基于上述原因，**访问**一个在伴生对象中声明为**私有**的常量实际上会在这个伴生对象的实现类中生成一个额外的、合成的 getter 方法。

```
GETSTATIC be/myapplication/MyClass.Companion : Lbe/myapplication/MyClass$Companion;
INVOKESTATIC be/myapplication/MyClass$Companion.access$getTAG$p (Lbe/myapplication/MyClass$Companion;)Ljava/lang/String;
ASTORE 1
```

但是更糟的是，这个合成方法实际上并没有返回值；它调用了 Kotlin 生成的实例 getter 方法：

```
ALOAD 0
INVOKESPECIAL be/myapplication/MyClass$Companion.getTAG ()Ljava/lang/String;
ARETURN
```

当常量被声明为 `public` 而不是 `private` 时，getter 方法是公共的并且可以被直接调用，因此不需要上一步的方法。但是 Kotlin 仍然必须通过调用 getter 方法来访问常量。

所以我们（真的）解决了（问题）吗？并没有！事实证明，为了存储常量值，Kotlin 编译器实际上在主类级别上而不是伴生对象中生成了一个 `private static final` 字段。但是，**因为在类中静态字段被声明为私有的，在伴生对象中需要有另外一个合成方法来访问它**

```
INVOKESTATIC be/myapplication/MyClass.access$getTAG$cp ()Ljava/lang/String;
ARETURN
```

最终，那个合成方法读取实际值：

```
GETSTATIC be/myapplication/MyClass.TAG : Ljava/lang/String;
ARETURN
```

换句话说，当你从一个 Kotlin 类来访问一个伴生对象中的私有常量字段的时候，与 Java 直接读取一个静态字段不同，你的代码实际上会：

- 在伴生对象上调用一个静态方法，
- 然后在伴生对象上调用实例方法，
- 然后在类中调用静态方法，
- 读取静态字段然后返回它的值。

这是等同的 Java 代码：

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

我们能得到更少的字节码吗？是的，但并不是所有情况都如此。

首先，通过 **`const`** 关键字声明值为[编译时常量](https://kotlinlang.org/docs/reference/properties.html#compile-time-constants)来完全避免任何的方法调用是有可能的。这将有效地在调用代码中直接内联这个值，**但是只有基本类型和字符串才能如此使用**。

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

第二，你可以在伴生对象的公共字段上使用 [`@JvmField`](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#instance-fields) 注解来告诉编译器不要生成任何的 getter 和 setter 方法，就像纯 Java 中的常量一样做为类的一个静态变量暴露出来。实际上，这个注解只是单独为了兼容 Java 而创建的，如果你的常量不需要从 Java 代码中访问的话，我是一点也不推荐你用一个晦涩的交互注解来弄乱你漂亮 Kotlin 代码的。**此外，它只能用于公共字段**。在 Android 的开发环境中，你可能只在实现 `Parcelable` 对象的时候才会使用这个注解：

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

最后，你也可以用 [ProGuard](https://developer.android.com/studio/build/shrink-code.html) 工具来优化字节码，希望通过这种方式来合并这些链式方法调用，但是绝对不保证这是有效的。

> 与 Java 相比，在 Kotlin 中从伴生对象里读取一个 `static` 常量会增加 2 到 3 个额外的间接级别并且每一个常量都会生成 2 到 3个方法。  
> 始终用 **const** 关键字来声明基本类型和字符串常量从而避免这些（成本）。
> 对其他类型的常量来说，你不能这么做，因此如果你需要反复访问这个常量的话，你或许可以把它的值缓存在一个本地变量中。

> 同时，最好在它们自己的对象而不是伴生对象中来存储公共的全局常量。

---

这就是第一篇文章的全部内容了。希望这可以让你更好的理解使用这些 Kotlin 特性的影响。牢记这一点以便在不损失可读性和性能的情况下编写更智能的的代码。

继续阅读[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md)：**局部函数**，**空值安全**，**可变参数**。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
