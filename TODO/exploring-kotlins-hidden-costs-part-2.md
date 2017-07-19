
> * 原文地址：[Exploring Kotlin’s hidden costs — Part 2](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-2-324a4a50b70)
> * 原文作者：[Christophe B.](https://medium.com/@BladeCoder)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[PhxNirvana](https://github.com/phxnirvana) 、[tanglie](https://github.com/tanglie1993)

# 探索 Kotlin 中的隐性成本（第二部分）


## 局部函数，空值安全和可变参数

本文是正在进行中的 Kotlin 编程语言系列的第二部分。如果你还未读过[第一部分](https://juejin.im/post/596774c96fb9a06bb95ae46a)的话，别忘了去看一下。

让我们重新看一下 Kotlin 的本质，去发现更多 Kotlin 特性的实现细节。

![](https://cdn-images-1.medium.com/max/1000/1*pgUIupLpReTPmScVHMITjg.png)

### 局部函数

有一种函数我们在第一篇文章没有讲到：使用常规语法在其他函数内部声明的函数。这是[局部函数](https://kotlinlang.org/docs/reference/functions.html#local-functions)，它们可以访问外部函数的作用域。

```
fun someMath(a: Int): Int {
    fun sumSquare(b: Int) = (a + b) * (a + b)

    return sumSquare(1) + sumSquare(2)
}
```

让我们先来谈谈他们最大的局限性：**局部函数不能被声明为`内联`（还不能？）并且一个包含局部函数的函数也不能被声明为`内联`**。还没有一个神奇的方法可以避免在这种情况下函数调用的成本。

局部函数在编译后被转换为 `Function` 对象，就像 lambdas 那样，并且有着和上篇文章中描述的关于非内联函数的**大多数相同的限制**。编译之后的 Java 代码形式是这样的：

```
public static final int someMath(final int a) {
   Function1 sumSquare$ = new Function1(1) {
      // $FF: synthetic method
      // $FF: bridge method
      public Object invoke(Object var1) {
         return Integer.valueOf(this.invoke(((Number)var1).intValue()));
      }

      public final int invoke(int b) {
         return (a + b) * (a + b);
      }
   };
   return sumSquare$.invoke(1) + sumSquare$.invoke(2);
}
```

但是与 lambdas 相比有一个小的性能损失：由于调用者是知道这个函数的真正实例的，它的**特定**方法将被直接调用，而不是调用来自 `Function` 接口的通用合成方法。这意味着**当从外部函数调用局部函数的时候不会有强制类型转换或者基础类型装箱现象发生**。我们可以通过查看字节码来验证这一点：

```
ALOAD 1
ICONST_1
INVOKEVIRTUAL be/myapplication/MyClassKt$someMath$1.invoke (I)I
ALOAD 1
ICONST_2
INVOKEVIRTUAL be/myapplication/MyClassKt$someMath$1.invoke (I)I
IADD
IRETURN
```

我们可以看到那个被调用了两次的方法就是那个接收一个 **`int`** 参数并且返回一个 **`int`** 的方法，那个加法被立即执行并且没有任何中间的拆箱操作。

当然，在每次方法调用的过程中仍然有着创建一个新 `Function` 对象的成本。这个成本可以通过将局部函数重写为非捕获性的来避免：

```
fun someMath(a: Int): Int {
    fun sumSquare(a: Int, b: Int) = (a + b) * (a + b)

    return sumSquare(a, 1) + sumSquare(a, 2)
}
```

现在这个相同的 `Function` 实例将被复用，仍然没有强制类型转换或者装箱情况发生。与典型的私有函数相比，局部函数唯一的缺点就是会额外生成一个有几个方法的的类。

> 局部函数是私有函数的一种替代，其优点是可以访问外部函数的局部变量。但是这些优点附带着隐性成本，那就是每次调用外部函数时都会生成一个 `Function` 对象，所以最好用非捕获性的函数。

---

### 空值安全

Kotlin 语言中最好的特性之一就是明确区分了[可空与不可空类型](https://kotlinlang.org/docs/reference/null-safety.html)。这可以使编译器在运行时通过禁止任何代码将 `null` 或者可空值分配给不可空变量来有效地阻止意想不到的 `NullPointerException`。

#### 不可空参数运行时检查

让我们声明一个公共的接收一个不可空 `String` 做为参数的函数：

```
fun sayHello(who: String) {
    println("Hello $who")
}
```

现在看一下编译之后的等同的 Java 形式：

```
public static final void sayHello(@NotNull String who) {
   Intrinsics.checkParameterIsNotNull(who, "who");
   String var1 = "Hello " + who;
   System.out.println(var1);
}
```

注意，Kotlin 编译器是 Java 的好公民，它在参数上添加了一个 `@NotNull` 注解，因此当一个 **`null`** 值传过来的时候 Java 工具可以据此来显示一个警告。

但是一个注解还不足以让外部调用实现空值安全。这就是为什么编译器在函数的刚开始处还添加了一个可以检测参数并且如果参数为 **`null`** 就抛出 `IllegalArgumentException` 的**静态方法调用**。为了使不安全的调用代码更容易修复，这个函数在早期就会失败而不是在后期随机地抛出 `NullPointerException`。

在实践中，**每一个公共的函数**都会在**每一个不可空引用参数**上添加一个 `Intrinsics.checkParameterIsNotNull()` 静态调用。**私有函数不会**有这些检查，因为编译器会保证 Kotlin 类中的代码是空值安全的。

这些静态调用对性能的影响可以忽略不计并且他们在调试或者测试一个 app 时确实很有用。话虽这么说，但你还是可能将他们视为一种正式版本中不必要的额外成本。在这种情况下，可以通过使用编译器选项中的 `-Xno-param-assertions` 或者添加以下的[混淆](https://www.guardsquare.com/en/proguard)规则来禁用运行时空值检查：

```
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
}
```

> 注意，这条混淆规则只有在优化功能开启的时候有效。优化功能在默认的安卓混淆配置中是禁用的。

#### 可空的基本类型

虽然显而易见，但仍需谨记：可空类型都是引用类型。将基础类型变量声明为 **可空**的话，会阻止 Kotlin 使用 Java 中类似 **`int`** 或者 **`float`** 那样的基础类型，相应的类似 `Integer` 或者 `Float` 那样的**装箱引用类型**会被使用，这就引起了额外的装箱或拆箱成本。

与 Java 中允许草率地使用与 **`int`** 变量几乎完全一样的 **`Integer`** 变量相反，由于[自动装箱](http://docs.oracle.com/javase/8/docs/technotes/guides/language/autoboxing.html)和不需要考虑空值安全的原因，在使用可空类型时 Kotlin 会迫使你编写安全的代码，因此使用不可空类型的好处变得越来越清晰：

```
fun add(a: Int, b: Int): Int {
    return a + b
}
fun add(a: Int?, b: Int?): Int {
    return (a ?: 0) + (b ?: 0)
}
```

> 为了更好的可读性和更佳的性能尽量使用不可空基础类型。

#### 数组相关

Kotlin 中有三种数组类型：

- `IntArray`, `FloatArray` 还有其他的：基础类型数组。编译为 **`int[]`**, **`float[]`** 和其他的类型。
- `Array<T>`：不可空对象引用类型化数组，这涉及到对基础类型的装箱。
- `Array<T?>`：可空对象引用类型化数组。很明显，这也涉及到基础类型的装箱。

> 如果你需要一个不可空的基础类型数组，最好用 `IntArray` 而不是 `Array<Int>` 来避免装箱（操作）。

---

### 可变参数

Kotlin 允许声明具有[数量可变的参数](https://kotlinlang.org/docs/reference/functions.html#variable-number-of-arguments-varargs)的函数，就像 Java 那样。声明语法有点不一样：

```
fun printDouble(vararg values: Int) {
    values.forEach { println(it * 2) }
}
```

就像 Java 中那样，**`vararg`** 参数实际上被编译为一个给定类型的 **数组** 参数。你可以用三种不同的方式来调用这些函数：

#### 1. 传入多个参数

```
printDouble(1, 2, 3)
```

Kotlin 编译器会将这行代码转化为创建并初始化一个新的数组，和 Java 编译器做的完全一样：

```
printDouble(new int[]{1, 2, 3});
```

因此有**创建一个新数组的开销**，但与 Java 相比这并不是什么新鲜事。

#### 2. 传入一个单独的数组

这就是不同之处。在 Java 中，你可以直接传入一个现有的数组引用作为可变参数。但是在 Kotlin 中你需要使用 **分布操作符**:

```
val values = intArrayOf(1, 2, 3)
printDouble(*values)
```

在 Java 中，数组引用被“原样”传入函数，而无需分配额外的数组内存。然而，**分布操作符**编译的方式不同，正如你在（等同的）Java 代码中看到的：

```
int[] values = new int[]{1, 2, 3};
printDouble(Arrays.copyOf(values, values.length));
```

每当调用这个函数时，现在的数组总会被复制。好处是代码更安全：允许函数在不影响调用者代码的情况下修改这个数组。**但是会分配额外的内存**。

**注意，在 Kotlin 代码中调用一个有可变参数的 Java 方法会产生相同的效果。**

#### 3. 传入混合的数组和参数

**分布操作符**主要的好处是，它还允许在同一个调用中数组参数和其他参数混合在一起进行传递。

```
val values = intArrayOf(1, 2, 3)
printDouble(0, *values, 42)
```

**这**是如何编译的呢？生成的代码十分有意思：

```
int[] values = new int[]{1, 2, 3};
IntSpreadBuilder var10000 = new IntSpreadBuilder(3);
var10000.add(0);
var10000.addSpread(values);
var10000.add(42);
printDouble(var10000.toArray());
```

除了**创建新数组**外，一个**临时的 builder 对象**被用来计算最终的数组大小并填充它。这就使得这个方法调用又增加了另一个小的成本。

> 在 Kotlin 中调用一个具有可变参数的函数时会增加创建一个新临时数组的成本，即使是使用已有数组的值。对方法被反复调用的性能关键性的代码来说，考虑添加一个以真正的数组而不是 **`可变数组`** 为参数的方法。

---

感谢阅读，如果你喜欢的话请分享本文。

继续阅读[第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-3.md)：**委派属性**和**范围**。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
