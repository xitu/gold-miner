
> * 原文地址：[Exploring Kotlin’s hidden costs — Part 2](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-2-324a4a50b70)
> * 原文作者：[Christophe B.](https://medium.com/@BladeCoder)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-kotlins-hidden-costs-part-2.md)
> * 译者：
> * 校对者：

# Exploring Kotlin’s hidden costs — Part 2


## Local functions, null safety and varargs

This is part 2 of an ongoing series about the Kotlin programming language. Don’t forget to read [part 1](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-1-fbb9935d9b62) if you haven’t already.

Let’s take a new look behind the curtain and discover the implementation details of more Kotlin features.

![](https://cdn-images-1.medium.com/max/1000/1*pgUIupLpReTPmScVHMITjg.png)

### Local functions

There is a kind of function we did not cover in the first article: functions that are declared inside other functions, using the regular syntax. These are called [local functions](https://kotlinlang.org/docs/reference/functions.html#local-functions) and they are able to access the scope of the outer function.

```
fun someMath(a: Int): Int {
    fun sumSquare(b: Int) = (a + b) * (a + b)

    return sumSquare(1) + sumSquare(2)
}
```

Let’s begin by mentioning their biggest limitation: **local functions can not be declared **`**inline**` (yet?) **and a function containing a local function can not be declared **`**inline**`** either**. There is no magical way to avoid the cost of function calls in this case.

After compilation, these local functions are converted to `Function` objects, just like lambdas and with **most of the same limitations** described in the previous article regarding non-inline functions. The Java representation of the compiled code looks like this:

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

There is however one less performance hit compared to lambdas: because the actual instance of the function is known from the caller, its *specific* method will be called directly instead of its *generic* synthetic method from the `Function` interface. This means that **no casting or boxing of primitive types will occur when calling a local function from the outer function**. We can verify this by looking at the bytecode:

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

We can see that the method being invoked twice is the one accepting an `**int**` and returning an `**int**`, and that the addition is performed immediately without any intermediate unboxing operation.

Of course there is still the cost of creating a new `Function` object during each method call. This can be avoided by rewriting the local function to be non-capturing:

```
fun someMath(a: Int): Int {
    fun sumSquare(a: Int, b: Int) = (a + b) * (a + b)

    return sumSquare(a, 1) + sumSquare(a, 2)
}
```

Now the same `Function` instance will be reused an still no casting or boxing will occur. The only penalty of this local function compared to a classic private function will be the generation of an extra class with a few methods.

> Local functions are an alternative to private functions with the added benefit of being able to access local variables of the outer function. That benefit comes with the hidden cost of the creation of a `Function` object for each call of the outer function, so non-capturing local functions are preferred.

---

### Null safety

One of the best features of the Kotlin language is that it makes a clear distinction between [nullable and non-null types](https://kotlinlang.org/docs/reference/null-safety.html). This enables the compiler to effectively prevent unexpected `NullPointerException`s at runtime by forbidding any code assigning a `**null**` or nullable value to a non-null variable.

#### Non-null arguments runtime checks

Let’s declare a public function taking a non-null `String` as argument:

```
fun sayHello(who: String) {
    println("Hello $who")
}
```

And now take a look at the Java representation of the compiled code:

```
public static final void sayHello(@NotNull String who) {
   Intrinsics.checkParameterIsNotNull(who, "who");
   String var1 = "Hello " + who;
   System.out.println(var1);
}
```

Notice that the Kotlin compiler is a good Java citizen and adds the `@NotNull` annotation to the argument, so Java tools can use this hint to show a warning when a `**null**` value is passed.

But an annotation is not enough to enforce null safety from the external callers. That’s why the compiler also adds at the very beginning of our function a **static method call** that will check the argument and throw an `IllegalArgumentException` if it’s `**null**`. The function will fail early and consistently rather than failing randomly later with a `NullPointerException`, in order to make the unsafe caller code easier to fix.

In practice, **every public function** has one static call to `Intrinsics.checkParameterIsNotNull()` added **for each non-null reference argument**. These checks are **not added to private functions** because the compiler guarantees that the code inside a Kotlin class is null safe.

The performance impact of these static calls is negligible and they are really useful when debugging and testing an app. That being said, you may see them as an unnecessary extra cost for release builds. In that case, it’s possible to disable runtime null checks by using the `-Xno-param-assertions` compiler option or by adding the following [ProGuard](https://www.guardsquare.com/en/proguard) rule:

```
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
}
```

> Note that this ProGuard rule will only take effect with optimizations enabled. Optimizations are disabled in the default Android ProGuard configuration.

#### Nullable primitive types

This seems obvious but needs to be reminded: a nullable type is always a reference type. Declaring a variable for a primitive type as **nullable** prevents Kotlin from using the Java primitive value types like `**int**` or `**float**` and instead the **boxed reference types** like `Integer` or `Float` will be used, involving the extra cost of boxing and unboxing operations.

Contrary to Java which allows you to be sloppy and use an `Integer` variable almost exactly like an `**int**` variable, thanks to [autoboxing](http://docs.oracle.com/javase/8/docs/technotes/guides/language/autoboxing.html) and disregard of null safety, Kotlin forces you to write safe code when using nullable types so the benefits of using non-null types become clearer:

```
fun add(a: Int, b: Int): Int {
    return a + b
}
fun add(a: Int?, b: Int?): Int {
    return (a ?: 0) + (b ?: 0)
}
```

> Use non-null primitive types whenever possible for more readable code and better performance.

#### About arrays

There are 3 types of arrays in Kotlin:

- `IntArray`, `FloatArray` and others: an array of primitive values.
Compiles to `**int**[]`, `**float**[]` and others.
- `Array<T>`: a typed array of non-null object references.
This involves boxing for primitive types.
- `Array<T?>`: a typed array of nullable object references.
This also involves boxing for primitive types, obviously.

> If you need an array for a non-null primitive type, prefer using `IntArray` than `Array<Int>` for example, to avoid boxing.

---

### Varargs

Kotlin allows to declare functions with a [variable number of arguments](https://kotlinlang.org/docs/reference/functions.html#variable-number-of-arguments-varargs), like Java. The declaration syntax is a bit different:

```
fun printDouble(vararg values: Int) {
    values.forEach { println(it * 2) }
}
```

Just like in Java, the `**vararg**` argument actually gets compiled to an **array** argument of the given type. You can then call these functions in three different ways:

#### 1. Passing multiple arguments

```
printDouble(1, 2, 3)
```

The Kotlin compiler will transform this code to a creation and initialization of a new array, exactly like the Java compiler does:

```
printDouble(new int[]{1, 2, 3});
```

So there is the **overhead of the creation of a new array**, but this is nothing new compared to Java.

#### 2. Passing a single array

This is where things differ. In Java, you can directly pass an existing array reference as vararg argument. In Kotlin, you need to use the *spread operator*:

```
val values = intArrayOf(1, 2, 3)
printDouble(*values)
```

In Java, the array reference is passed “as-is” to the function, with no extra array allocation. However, the Kotlin *spread operator* compiles differently, as you can see in this Java representation:

```
int[] values = new int[]{1, 2, 3};
printDouble(Arrays.copyOf(values, values.length));
```

The existing array **always gets copied** when calling the function. The benefit is safer code: it allows the function to modify the array without impacting the caller code. **But it allocates extra memory**.

*Note that calling a Java method with a variable number of arguments from Kotlin code has the same effect.*

#### 3. Passing a mix of arrays and arguments

The main benefit of the *spread operator* is that it also allows mixing arrays with other arguments in the same call.

```
val values = intArrayOf(1, 2, 3)
printDouble(0, *values, 42)
```

How does *this* get compiled? The resulting code is quite interesting:

```
int[] values = new int[]{1, 2, 3};
IntSpreadBuilder var10000 = new IntSpreadBuilder(3);
var10000.add(0);
var10000.addSpread(values);
var10000.add(42);
printDouble(var10000.toArray());
```

In addition to the **creation of a new array**, a **temporary builder object** is used to compute the final array size and populate it. This adds another small cost to the method call.

> Calling a function with a variable number of arguments in Kotlin adds the cost of creating a new temporary array, even when using values from an existing array. For performance-critical code where the function is called repeatedly, consider adding a method with an actual array argument instead of `**vararg**`.

---

Thank you for reading and please share this article if you liked it.

Keep reading by heading to [part 3](https://medium.com/@BladeCoder/exploring-kotlins-hidden-costs-part-3-3bf6e0dbf0a4): *delegated properties* and *ranges*.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
