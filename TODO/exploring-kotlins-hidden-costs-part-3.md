
> * 原文地址：[Exploring Kotlin’s hidden costs — Part 3](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-3-3bf6e0dbf0a4)
> * 原文作者：[Christophe B.](https://medium.com/@BladeCoder)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-3.md)
> * 译者：[PhxNirvana](https://juejin.im/user/57a16f4e6be3ff00650682d8)
> * 校对者：[Zhiw](https://github.com/Zhiw)、[Feximin](https://github.com/Feximin)

# 探索 Kotlin 的隐性成本（第三部分）

---

## 委托属性（Delegated propertie）和区间（range）

本系列关于 Kotlin 的前两篇文章发表之后，读者们纷至沓来的赞誉让我受宠若惊，其中还包括 Jake Wharton 的留言。很乐意和大家再次开始探索之旅。不要错过 [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-1.md) 和 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md).

本文我们将探索更多关于 Kotlin 编译器的秘密，并提供一些可以使代码更高效的建议。

![](https://cdn-images-1.medium.com/max/800/1*-iKupZ7diZBEzTw87Bkaxg.jpeg)

### 委托属性

[委托属性](https://kotlinlang.org/docs/reference/delegated-properties.html) 是一种通过**委托**实现拥有 getter 和可选 setter 的 [属性](https://kotlinlang.org/docs/reference/properties.html)，并允许实现可复用的自定义属性。

```
class Example {
    var p: String by Delegate()
}
```

委托对象必须实现一个拥有 `getValue()` 方法的操作符，以及 `setValue()` 方法来实现读/写属性。些方法将会接受**包含对象实例**以及**属性元数据**作为额外参数。

当一个类声明委托属性时，编译器生成的代码会和如下 Java 代码相似。

```
public final class Example {
   @NotNull
   private final Delegate p$delegate = new Delegate();
   // $FF: synthetic field
   static final KProperty[] $$delegatedProperties = new KProperty[]{(KProperty)Reflection.mutableProperty1(new MutablePropertyReference1Impl(Reflection.getOrCreateKotlinClass(Example.class), "p", "getP()Ljava/lang/String;"))};

   @NotNull
   public final String getP() {
      return this.p$delegate.getValue(this, $$delegatedProperties[0]);
   }

   public final void setP(@NotNull String var1) {
      Intrinsics.checkParameterIsNotNull(var1, "<set-?>");
      this.p$delegate.setValue(this, $$delegatedProperties[0], var1);
   }
}
```

一些静态属性元数据被加入到类中，委托在类的构造函数中初始化，并在每次读写属性时调用。

#### 委托实例

在上面的例子中，**创建了一个新的委托实例**来实现属性。这就要求委托的实现是**有状态的**，例如当其内部缓存计算结果时：

```
class StringDelegate {
    private var cache: String? = null

    operator fun getValue(thisRef: Any?, property: KProperty<*>): String {
        var result = cache
        if (result == null) {
            result = someOperation()
            cache = result
        }
        return result
    }
}
```

与此同时，当需要**额外的参数**时，需要建立新的委托实例，并将其传递到构造器中：

```
class Example {
    private val nameView by BindViewDelegate<TextView>(R.id.name)
}
```

但也有一些情况是**只需要一个委托实例来实现任何属性的**：当委托是无状态，并且它所需要的唯一变量就是已经提供好的包含对象实例和委托名称时，可以通过将其声明为 **`object`** 来替代 **`class`** 实现一个**单例**委托。

举个例子，下面的单例委托从 Android `Activity` 中取回与给定 tag 相匹配的 `Fragment`：

```
object FragmentDelegate {
    operator fun getValue(thisRef: Activity, property: KProperty<*>): Fragment? {
        return thisRef.fragmentManager.findFragmentByTag(property.name)
    }
}
```

类似地，**任何已有类都可以通过扩展变成委托**。`getValue()` 和 `setValue()` 也可以被声明成 [**扩展方法**](https://kotlinlang.org/docs/reference/extensions.html#extension-functions) 来实现。Kotlin 已经提供了内置的扩展方法来允许将 `Map` and `MutableMap` 实例用作委托，属性名作为其中的键。

如果你选择复用相同的局部委托实例来在一个类中实现多属性，你需要在构造函数中初始化实例。

**注意**：从 Kotlin 1.1 开始，也可以声明 [方法局部变量声明为委托属性](https://kotlinlang.org/docs/reference/delegated-properties.html#local-delegated-properties-since-11)。在这种情况下，委托可以直到该变量在方法内部声明的时候才去初始化，而不必在构造函数中就执行初始化。

> 类中声明的每一个委托属性都会涉及到与之**关联委托对象的开销**，并会在类中增加一些元数据。
> 如果可能的话，尽量在不同的属性间**复用**委托。
> 同时也要考虑一下如果需要声明大量委托时，委托属性是不是一个好的选择。

#### 泛型委托

委托方法也可以被声明成泛型的，这样一来不同类型的属性就可以复用同一个委托类了。

```
private var maxDelay: Long by SharedPreferencesDelegate<Long>()
```

然而，如果像上例那样对基本类型使用泛型委托的话，即便声明的基本类型非空，也会在每次读写属性的时候**触发装箱和拆箱的操作**。

> 对于非空基本类型的委托属性来说，最好使用**给定类型的特定委托类**而不是泛型委托来避免每次访问属性时增加装箱的额外开销。

#### 标准委托： lazy()

针对常见情形，Kotlin 提供了一些标准委托，如 [`Delegates.notNull()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.properties/-delegates/not-null.html)、 [`Delegates.observable()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.properties/-delegates/observable.html) 和 [*`lazy()`*](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/lazy.html)。

**`lazy()`** 是一个在第一次读取时通过给定的 lambda 值来计算属性的初值，并返回只读属性的委托。

```
private val dateFormat: DateFormat by lazy {
    SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
}
```

这是一种简洁的**延迟高消耗的初始化**至其真正需要时的方式，在保留代码可读性的同时提升了性能。

需要注意的是，`lazy()` 并不是内联函数，传入的 lambda 参数也会被编译成一个额外的 `Function` 类，并且不会被内联到返回的委托对象中。

经常被忽略的一点是 **`lazy()` 有可选的 `mode` 参数** 来决定应该返回 3 种委托的哪一种：

```
public fun <T> lazy(initializer: () -> T): Lazy<T> = SynchronizedLazyImpl(initializer)
public fun <T> lazy(mode: LazyThreadSafetyMode, initializer: () -> T): Lazy<T> =
        when (mode) {
            LazyThreadSafetyMode.SYNCHRONIZED -> SynchronizedLazyImpl(initializer)
            LazyThreadSafetyMode.PUBLICATION -> SafePublicationLazyImpl(initializer)
            LazyThreadSafetyMode.NONE -> UnsafeLazyImpl(initializer)
        }
```

默认模式 **`LazyThreadSafetyMode.SYNCHRONIZED`** 将提供相对耗费昂贵的 **双重检查锁** 来保证一旦属性可以从**多线程**读取时初始化块可以安全地执行。

如果你确信属性只会在**单线程**（如主线程）被访问，那么可以选择 **`LazyThreadSafetyMode.NONE`** 来代替，从而**避免使用锁的额外开销**。

```
val dateFormat: DateFormat by lazy(LazyThreadSafetyMode.NONE) {
    SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
}
```

> 使用 `lazy()` 委托来延迟初始化时的大量开销以及指定模式来避免不必要的锁。

---

### 区间

[区间](https://kotlinlang.org/docs/reference/ranges.html) 是 Kotlin 中用来代表一个有限的值集合的特殊表达式。值可以是任何 `Comparable` 类型。 这些表达式的形式都是创建声明了 [`ClosedRange`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.ranges/-closed-range/) 接口的方法。创建区间的主要方法是 `..` 操作符方法。

#### 包含
区间表达式的主要作用是使用 **`in`** 和 **`!in`** 操作符实现包含和不包含。

```
if (i in 1..10) {
    println(i)
}
```

该实现针对**非空基本类型的区间**（包括 `Int`、`Long`、`Byte`、`Short`、`Float`、`Double` 以及 `Char` 的值）实现了优化，所以上面的代码可以被优化成这样：

```
if(1 <= i && i <= 10) {
   System.out.println(i);
}
```

**零额外支出**并且没有额外对象开销。区间也可以被包含在 **`when`** 表达式中：

```
val message = when (statusCode) {
    in 200..299 -> "OK"
    in 300..399 -> "Find it somewhere else"
    else -> "Oops"
}
```

相比一系列的 `if{...} else if{...}` 代码块，这段代码在不降低效率的同时提高了代码的可读性。

然而，如果在声明和使用之间有至少一次间接调用的话，**range 会有一些微小的额外开销**。比如下面的代码：

```
private val myRange get() = 1..10

fun rangeTest(i: Int) {
    if (i in myRange) {
        println(i)
    }
}
```

在编译后会创建一个额外的 `IntRange` 对象：

```
private final IntRange getMyRange() {
   return new IntRange(1, 10);
}

public final void rangeTest(int i) {
   if(this.getMyRange().contains(i)) {
      System.out.println(i);
   }
}
```

将属性的 getter 声明为 **`inline`** 的方法也无法避免这个对象的创建。**这是 Kotlin 1.1 编译器可以优化的一个点。**至少通过这些特定的区间类避免了装箱操作。

> 尽量**在使用时直接**声明非空基本类型的区间，不要间接调用，来避免额外区间类的创建。
> 或者直接声明为**常量**来复用。

区间也可以用于其他实现了 `Comparable` 的非基本类型。

```
if (name in "Alfred".."Alicia") {
    println(name)
}
```

在这种情况下，最终实现并不会优化，而且总是会创建一个 `ClosedRange` 对象，如下面编译后的代码所示：

```
if(RangesKt.rangeTo((Comparable)"Alfred", (Comparable)"Alicia")
   .contains((Comparable)name)) {
   System.out.println(name);
}
```

> 如果你需要对一个实现了 `Comparable` 的非基本类型的区间进行频繁的包含的话，考虑将这个区间声明为常量来避免重复创建区间类吧。

#### 迭代：for 循环

**整型区间** （除了 `Float` 和 `Double`之外其他的基本类型）也是 **级数**：**它们可以被迭代**。这就可以将经典 Java 的 **`for`** 循环用一个更短的表达式替代。

```
for (i in 1..10) {
    println(i)
}
```

经过编译器优化后的代码实现了**零额外开销**：

```
int i = 1;
byte var3 = 10;
if(i <= var3) {
   while(true) {
      System.out.println(i);
      if(i == var3) {
         break;
      }
      ++i;
   }
}
```

如果要**反向迭代**，可以使用 [`downTo()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.ranges/down-to.html) 中缀方法来代替 `..`：

```
for (i in 10 downTo 1) {
    println(i)
}
```

编译之后，这也实现了零额外开销：

```
int i = 10;
byte var3 = 1;
if(i >= var3) {
   while(true) {
      System.out.println(i);
      if(i == var3) {
         break;
      }
      --i;
   }
}
```

然而，**其他迭代器参数并没有如此好的优化**。

反向迭代还有一种结果相同的方式，使用 [`reversed()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.ranges/reversed.html) 方法结合区间：

```
for (i in (1..10).reversed()) {
    println(i)
}
```

编译后的代码并没有看起来那么少：

```
IntProgression var10000 = RangesKt.reversed((IntProgression)(new IntRange(1, 10)));
int i = var10000.getFirst();
int var3 = var10000.getLast();
int var4 = var10000.getStep();
if(var4 > 0) {
   if(i > var3) {
      return;
   }
} else if(i < var3) {
   return;
}

while(true) {
   System.out.println(i);
   if(i == var3) {
      return;
   }

   i += var4;
}
```

会创建一个临时的 `IntRange` 对象来代表区间，然后创建另一个 `IntProgression` 对象来反转前者的值。

事实上，**任何结合不止一个方法来创建递进**都会生成类似的**至少创建两个微小递进对象**的代码。

这个规则也适用于使用 [`step()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.ranges/step.html) 中缀方法来操作递进的步骤，即使**只有一步**：

```
for (i in 1..10 step 2) {
    println(i)
}
```

一个次要提示，当生成的代码读取 `IntProgression` 的 **`last`** 属性时会通过对边界和步长的小小计算来决定准确的最后值。在上面的代码中，最终值是 9。

最后，[`until()`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.ranges/until.html) 中缀函数对于迭代也很有用，该函数（执行结果）不包含最大值。

```
for (i in 0 until size) {
    println(i)
}
```

遗憾的是，**编译器并没有针对这个经典的包含区间围优化**，迭代器依然会创建区间对象：

```
IntRange var10000 = RangesKt.until(0, size);
int i = var10000.getFirst();
int var1 = var10000.getLast();
if(i <= var1) {
   while(true) {
      System.out.println(i);
      if(i == var1) {
         break;
      }
      ++i;
   }
}
```

**这是 Kotlin 1.1 可以提升的另一个点**
与此同时，可以通过这样写来优化代码：

```
for (i in 0..size - 1) {
    println(i)
}
```

> **`for`** 循环内部的迭代，最好只用区间表达式的**一个单独方法来调用 `..` 或 `downTo()`** 来避免额外临时递进对象的创建。

#### 迭代：forEach()

作为 **`for`** 循环的替代，使用区间内联的扩展方法 `forEach()` 来实现相似的效果可能更吸引人。

```
(1..10).forEach {
    println(it)
}
```

但如果仔细观察这里使用的 `forEach()` 方法签名的话，你就会注意到并没有优化区间，而只是优化了 `Iterable`，所以需要创建一个 iterator。下面是编译后代码的 Java 形式：

```
Iterable $receiver$iv = (Iterable)(new IntRange(1, 10));
Iterator var1 = $receiver$iv.iterator();

while(var1.hasNext()) {
   int element$iv = ((IntIterator)var1).nextInt();
   System.out.println(element$iv);
}
```

这段代码相比前者**更为低效**，原因是为了创建一个 `IntRange` 对象，还需要额外创建 `IntIterator`。但至少它还是生成了基本类型的值。

> 迭代区间时，最好只使用 **`for`** 循环而不是区间上的 `forEach()` 方法来避免额外创建一个迭代器。

#### 迭代：集合

Kotlin 标准库提供了内置的 [*`indices`*](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/indices.html) 扩展属性来生成数组和 `Collection` 的区间。

```
val list = listOf("A", "B", "C")
for (i in list.indices) {
    println(list[i])
}
```

令人惊讶的是，对这个 *`indices`* 的迭代**得到了编译器的优化**：

```
List list = CollectionsKt.listOf(new String[]{"A", "B", "C"});
int i = 0;
int var2 = ((Collection)list).size() - 1;
if(i <= var2) {
   while(true) {
      Object var3 = list.get(i);
      System.out.println(var3);
      if(i == var2) {
         break;
      }
      ++i;
   }
}
```

从上面的代码中我们可以看到没有创建 `IntRange` 对象，列表的迭代是以最高效率的方式运行的。

这适用于数组和实现了 `Collection` 的类，所以你如果期望相同的迭代器性能的话，可以尝试在特定的类上使用自己的 *`indices`* 扩展属性。

```
inline val SparseArray<*>.indices: IntRange
    get() = 0..size() - 1

fun printValues(map: SparseArray<String>) {
    for (i in map.indices) {
        println(map.valueAt(i))
    }
}
```

但编译之后，我们可以发现**这并没有那么高效率**，因为编译器无法足够智能地避免区间对象的产生：

```
public static final void printValues(@NotNull SparseArray map) {
   Intrinsics.checkParameterIsNotNull(map, "map");
   IntRange var10002 = new IntRange(0, map.size() - 1);
   int i = var10002.getFirst();
   int var2 = var10002.getLast();
   if(i <= var2) {
      while(true) {
         Object $receiver$iv = map.valueAt(i);
         System.out.println($receiver$iv);
         if(i == var2) {
            break;
         }
         ++i;
      }
   }
}
```

所以，我会建议你避免声明自定义的 *`lastIndex`* 扩展属性：

```
inline val SparseArray<*>.lastIndex: Int
    get() = size() - 1

fun printValues(map: SparseArray<String>) {
    for (i in 0..map.lastIndex) {
        println(map.valueAt(i))
    }
}
```

> 当迭代没有声明 `Collection` 的**自定义集合** 时，**直接在 `for` 循环中写自己的序列区间**而不是依赖方法或属性来生成区间，从而避免区间对象的创建。

---

我在写本文时兴趣盎然，希望你读起来也一样。可能你还期待以后有更多的文章，但这三篇已经涵盖了我目前想要写的所有内容了。如果喜欢的话请分享。谢谢！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
